util.AddNetworkString("Foxy:CarDealer:OpenDealer")
util.AddNetworkString("Foxy:CarDealer:AddVehicle")
util.AddNetworkString("Foxy:CarDealer:RemoveVehicle")
util.AddNetworkString("Foxy:CarDealer:BuyVehicle")
util.AddNetworkString("Foxy:CarDealer:OpenGarage")
util.AddNetworkString("Foxy:CarDealer:SpawnVehicle")
util.AddNetworkString("Foxy:CarDealer:SellVehicle")
util.AddNetworkString("Foxy:CarDealer:PreCacheGetModel")
util.AddNetworkString("Foxy:CarDealer:PreCacheSendModel")
util.AddNetworkString("Foxy:CarDealer:ReturnVehicle")

resource.AddFile("materials/foxy/car_dealer/up.png")
resource.AddFile("materials/foxy/car_dealer/down.png")
resource.AddFile("resource/fonts/circular.ttf")

function Foxy.CarDealer.CreateDir()
	if not file.IsDir("foxy/car_dealer/", "DATA") then
		file.CreateDir("foxy/car_dealer/")
	end
    if not file.IsDir("foxy/car_dealer/player", "DATA") then
		file.CreateDir("foxy/car_dealer/player")
	end
end

function Foxy.CarDealer.CreateDealer()
	if not file.Exists("foxy/car_dealer/dealer_pos.json", "DATA") then return end
	local tab = util.JSONToTable(file.Read("foxy/car_dealer/dealer_pos.json", "DATA"))
	if IsValid(Foxy.CarDealer.Dealer) then Foxy.CarDealer.Dealer:Remove() end
	Foxy.CarDealer.Dealer = ents.Create("foxy_car_dealer_dealer")
	Foxy.CarDealer.Dealer:SetModel("models/Humans/Group01/male_02.mdl")
	Foxy.CarDealer.Dealer:SetPos(tab.pos)
	Foxy.CarDealer.Dealer:SetAngles(tab.ang)
	Foxy.CarDealer.Dealer:Spawn() 
end

function Foxy.CarDealer.CreateSpawn()
	if not file.Exists("foxy/car_dealer/spawn_pos.json", "DATA") then return end
	local tab = util.JSONToTable(file.Read("foxy/car_dealer/spawn_pos.json", "DATA"))
	if IsValid(Foxy.CarDealer.Spawn) then Foxy.CarDealer.Spawn:Remove() end
	Foxy.CarDealer.Spawn = ents.Create("foxy_car_dealer_spawn")
	Foxy.CarDealer.Spawn:SetModel("models/hunter/plates/plate3x6.mdl")
	Foxy.CarDealer.Spawn:SetPos(tab.pos)
	Foxy.CarDealer.Spawn:SetAngles(tab.ang)
	Foxy.CarDealer.Spawn:Spawn()
	timer.Simple(5, function()
		Foxy.CarDealer.Spawn:SetColor(Color(0, 0, 0, 0)) 
		Foxy.CarDealer.Spawn:SetRenderMode(RENDERMODE_TRANSCOLOR)
	end)
end

function Foxy.CarDealer.CreateGarage()
	if not file.Exists("foxy/car_dealer/garage_pos.json", "DATA") then return end
	local tab = util.JSONToTable(file.Read("foxy/car_dealer/garage_pos.json", "DATA"))
	if IsValid(Foxy.CarDealer.Garage) then Foxy.CarDealer.Garage:Remove() end
	Foxy.CarDealer.Garage = ents.Create("foxy_car_dealer_garage")
	Foxy.CarDealer.Garage:SetModel("models/Humans/Group01/male_02.mdl")
	Foxy.CarDealer.Garage:SetPos(tab.pos)
	Foxy.CarDealer.Garage:SetAngles(tab.ang)
	Foxy.CarDealer.Garage:Spawn() 
end

function Foxy.CarDealer.AddVehicle(_, ply)
	local fClass = net.ReadString()
	local fName = net.ReadString()
	local fPrice = net.ReadString()

	local tbl = {
		Name = fName,
		Class = fClass,
		Price = fPrice
	}

	if file.Exists("foxy/car_dealer/vehicle_list.json", "DATA") then
		local tab = util.JSONToTable(file.Read("foxy/car_dealer/vehicle_list.json"))

		table.insert(tab, tbl)

		local tab2 = util.TableToJSON(tab)
		file.Write("foxy/car_dealer/vehicle_list.json", tab2)
	else
		local tab = {}

		table.insert(tab, tbl)

		local tab2 = util.TableToJSON(tab)
		file.Write("foxy/car_dealer/vehicle_list.json", tab2)
	end
end

function Foxy.CarDealer.RemoveVehicle(_, ply)
	local fID = net.ReadString()

	if file.Exists("foxy/car_dealer/vehicle_list.json", "DATA") then
		local tab = util.JSONToTable(file.Read("foxy/car_dealer/vehicle_list.json"))

		table.remove(tab, fID)

		local tab2 = util.TableToJSON(tab)
		file.Write("foxy/car_dealer/vehicle_list.json", tab2)
	end
end

function Foxy.CarDealer.SellVehicle(_, ply)
	local fID = net.ReadString()
	local fPrice = net.ReadString()

	local PercentagePrice = (fPrice*Foxy.CarDealer.Settings.Percentage)

	print(PercentagePrice)

	DarkRP:addMoney(PercentagePrice)
	DarkRP.notify(ply, 1, 3, "Vous avez vendu un véhicule pour " .. PercentagePrice .. " !") 

	if file.Exists("foxy/car_dealer/player/" .. ply:SteamID64() .. ".json", "DATA") then
		local tab = util.JSONToTable(file.Read("foxy/car_dealer/player/" .. ply:SteamID64() .. ".json"))

		table.remove(tab, fID)

		local tab2 = util.TableToJSON(tab)
		file.Write("foxy/car_dealer/player/" .. ply:SteamID64() .. ".json", tab2)
	end
end

function Foxy.CarDealer.BuyVehicle(_, ply)
	local fClass = net.ReadString()
	local fName = net.ReadString()
	local fPrice = net.ReadString()

	local tbl = {
		Name = fName,
		Class = fClass,
		Price = fPrice
	}

	if not ply:canAfford(tonumber(fPrice)) then return DarkRP.notify(ply, 1, 3, "Vous ne pouvez pas vous permettre cela !") end

	DarkRP.notify(ply, 0, 3, "Vous avez achetez " .. fName .. " pour " .. DarkRP.formatMoney(tonumber(fPrice)) .. "!")

	ply:addMoney(-tonumber(fPrice))

	if file.Exists("foxy/car_dealer/player/" .. ply:SteamID64() .. ".json", "DATA") then
		local tab = util.JSONToTable(file.Read("foxy/car_dealer/player/" .. ply:SteamID64() .. ".json"))

		table.insert(tab, tbl)

		local tab2 = util.TableToJSON(tab)
		file.Write("foxy/car_dealer/player/" .. ply:SteamID64() .. ".json", tab2)
	else
		local tab = {}

		table.insert(tab, tbl)

		local tab2 = util.TableToJSON(tab)
		file.Write("foxy/car_dealer/player/" .. ply:SteamID64() .. ".json", tab2)
	end
end

function Foxy.CarDealer.SpawnVehicle(_, ply)
	local Class = net.ReadString()

	if not IsValid(Foxy.CarDealer.Spawn) then return DarkRP.notify(ply, 1, 3, "Acun Spawn n'a été trouver !") end
	if IsValid(ply.FoxyVeh) then return DarkRP.notify(ply, 1, 3, "Vous avez déja un véhicule de spawn !") end

	local VehiclesTable = list.Get("Vehicles")[Class]
	local spawnpos
	local spawnang

	for k, v in ipairs(ents.FindByClass("foxy_car_dealer_spawn")) do
		spawnpos = v:GetPos()
		spawnang = v:GetAngles()
	end
	
	ply.FoxyVeh = ents.Create("prop_vehicle_jeep")
	ply.FoxyVeh:SetModel(VehiclesTable.Model)
	ply.FoxyVeh:SetPos(spawnpos)
	ply.FoxyVeh:SetAngles(spawnang)
	ply.FoxyVeh:SetKeyValue("vehiclescript", VehiclesTable.KeyValues.vehiclescript)
	ply.FoxyVeh:Activate()
	ply.FoxyVeh:SetVehicleClass(Class)
	ply.FoxyVeh:Spawn()
	ply.FoxyVeh:keysOwn(ply)
	ply.FoxyVeh:keysLock()
    ply.FoxyVeh:SetCollisionGroup(COLLISION_GROUP_WORLD)
	ply.FoxyVeh:SetColor(Color(255, 255, 255, 240))
	ply.FoxyVeh:SetRenderMode(RENDERMODE_TRANSCOLOR)

	timer.Simple(3, function()
		ply.FoxyVeh:SetCollisionGroup(COLLISION_GROUP_VEHICLE)
		ply.FoxyVeh:SetColor(Color(255, 255, 255))
	end)

	timer.Simple(0.1, function()
		if IsValid(ply.FoxyVeh) then
			if Foxy.CarDealer.Settings.SpawnEnter then
				ply:EnterVehicle(ply.FoxyVeh)
			end
		end
	end)

    gamemode.Call("PlayerSpawnedVehicle", ply, ply.FoxyVeh)
end

function Foxy.CarDealer.ReturnVehicle(_, ply)
	if IsValid(ply.FoxyVeh) then
		if ply:GetPos():DistToSqr(ply.FoxyVeh:GetPos()) < 10000*Foxy.CarDealer.Settings.Distance then
			ply.FoxyVeh:Remove()
			DarkRP.notify(ply, 0, 3, "Vous avez retourner un véhicule !")
		else
			DarkRP.notify(ply, 1, 3, "Le véhicule n'est pas assez proche !")
		end
	else
		DarkRP.notify(ply, 1, 3, "Vous n'avez aucun véhicule de sortie !")
	end
end

function Foxy.CarDealer.PreCacheModelSV()
	if not file.Exists("foxy/car_dealer/vehicle_list.json", "DATA") then return end

	local tab = util.JSONToTable(file.Read("foxy/car_dealer/vehicle_list.json"))

	for k, v in ipairs(tab) do

		local info = list.Get("Vehicles")[v.Class]

		if util.IsValidModel(info.Model) then
			util.PrecacheModel(info.Model)
			Foxy:Message(info.Model, "PreCache")
		end
	end
end

function Foxy.CarDealer.PreCacheSendModel(_, ply)
	if not file.Exists("foxy/car_dealer/vehicle_list.json", "DATA") then return end

	local tab = util.JSONToTable(file.Read("foxy/car_dealer/vehicle_list.json"))

	net.Start("Foxy:CarDealer:PreCacheSendModel")
		net.WriteTable(tab)
	net.Send(ply)
end

net.Receive("Foxy:CarDealer:AddVehicle", Foxy.CarDealer.AddVehicle)
net.Receive("Foxy:CarDealer:RemoveVehicle", Foxy.CarDealer.RemoveVehicle)
net.Receive("Foxy:CarDealer:BuyVehicle", Foxy.CarDealer.BuyVehicle)
net.Receive("Foxy:CarDealer:SpawnVehicle", Foxy.CarDealer.SpawnVehicle)
net.Receive("Foxy:CarDealer:SellVehicle", Foxy.CarDealer.SellVehicle)
net.Receive("Foxy:CarDealer:PreCacheGetModel", Foxy.CarDealer.PreCacheSendModel)
net.Receive("Foxy:CarDealer:ReturnVehicle", Foxy.CarDealer.ReturnVehicle)

hook.Add("InitPostEntity", "Foxy:CarDealer:CreateDir", function()
	Foxy.CarDealer.CreateDir()
	Foxy.CarDealer.CreateDealer()
	Foxy.CarDealer.CreateSpawn()
	Foxy.CarDealer.CreateGarage()
	Foxy.CarDealer.PreCacheModelSV()
end)

hook.Add("PostCleanupMap", "Foxy:CarDealer:CleanUP", function()
	Foxy.CarDealer.CreateDealer()
	Foxy.CarDealer.CreateSpawn()
	Foxy.CarDealer.CreateGarage()
	Foxy.CarDealer.PreCacheModelSV()
end)