local FCD = Foxy.CarDealer

function FCD.OpenDealer()
    local VehList = net.ReadTable()

    FCD.DealerFrame = vgui.Create("Foxy.CarDealer.Dealer")
    FCD.DealerFrame:Dock(FILL)
    FCD.DealerFrame:DockMargin(400, 200, 400, 200)
    FCD.DealerFrame:VehTable(VehList)
end

function FCD.OpenGarage()
    local VehList = net.ReadTable()

    FCD.GarageFrame = vgui.Create("Foxy.CarDealer.Garage")
    FCD.GarageFrame:Dock(FILL)
    FCD.GarageFrame:DockMargin(400, 200, 400, 200)
    FCD.GarageFrame:VehTable(VehList)
end

function FCD.PreCacheGetModel()
    net.Start("Foxy:CarDealer:PreCacheGetModel")
    net.SendToServer()
end

function FCD.PreCacheModelCL()
    local tab = net.ReadTable()

	for k, v in ipairs(tab) do

		local info = list.Get("Vehicles")[v.Class]

		if util.IsValidModel(info.Model) then
			util.PrecacheModel(info.Model)
			Foxy:Message(info.Model, "PreCache")
		end
	end
end

net.Receive("Foxy:CarDealer:OpenDealer", FCD.OpenDealer)
net.Receive("Foxy:CarDealer:OpenGarage", FCD.OpenGarage)
net.Receive("Foxy:CarDealer:PreCacheSendModel", FCD.PreCacheModelCL)
hook.Add("InitPostEntity", "Foxy:CarDealer:CreateDir", FCD.PreCacheGetModel)
