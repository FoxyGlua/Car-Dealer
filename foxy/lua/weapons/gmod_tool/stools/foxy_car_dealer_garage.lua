TOOL.Category = "Foxy"
TOOL.Name = "Garage Spawner"
TOOL.Command = nil
TOOL.ConfigName = "Garage Spawner"

TOOL.ClientConVar["myparameter"] = "fubar"

TOOL.Information = {
	{ name = "left" },
	{ name = "right" }
}

if CLIENT then
	language.Add("Tool.foxy_car_dealer_garage.name", "Garage Spawner")
    language.Add("tool.foxy_car_dealer_garage.desc", "Faire spawn le Garage.")
	language.Add("Tool.foxy_car_dealer_garage.left", "Spawn")
	language.Add("Tool.foxy_car_dealer_garage.right", "Save")
end

local DInfos
 
function TOOL:LeftClick(trace)
    if SERVER then
        if IsValid(Foxy.CarDealer.Garage) then Foxy.CarDealer.Garage:Remove() end
        Foxy.CarDealer.Garage = ents.Create("foxy_car_dealer_garage")
        Foxy.CarDealer.Garage:SetModel("models/Humans/Group01/male_02.mdl")
        Foxy.CarDealer.Garage:SetPos(trace.HitPos)
        Foxy.CarDealer.Garage:Spawn()  
    end
end
 
function TOOL:RightClick(trace)
    if SERVER then
        if IsValid(Foxy.CarDealer.Garage) then
            DInfos = {
                pos = Foxy.CarDealer.Garage:GetPos(),
                ang = Foxy.CarDealer.Garage:GetAngles()
            }

            local tab = util.TableToJSON(DInfos)
            file.Write("foxy/car_dealer/garage_pos.json", tab)
        end
    elseif CLIENT then
        Foxy:Notify("Le Garage à bien été sauvegarder !", 0, 5)
    end
end

function TOOL:DrawToolScreen(width, height)
    draw.RoundedBox(0, 0, 0, width, height, Color(19, 24, 29))
    draw.SimpleText("Garage Spawner", Foxy:Font(40), width/2, height/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end