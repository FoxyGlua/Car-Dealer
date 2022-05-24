TOOL.Category = "Foxy"
TOOL.Name = "Dealer Spawner"
TOOL.Command = nil
TOOL.ConfigName = "Dealer Spawner"

TOOL.ClientConVar["myparameter"] = "fubar"

TOOL.Information = {
	{ name = "left" },
	{ name = "right" }
}

if CLIENT then
	language.Add("Tool.foxy_car_dealer_dealer.name", "Dealer Spawner")
    language.Add("tool.foxy_car_dealer_dealer.desc", "Faire spawn le Dealer.")
	language.Add("Tool.foxy_car_dealer_dealer.left", "Spawn")
	language.Add("Tool.foxy_car_dealer_dealer.right", "Save")
end

local DInfos
 
function TOOL:LeftClick(trace)
    if SERVER then
        if IsValid(Foxy.CarDealer.Dealer) then Foxy.CarDealer.Dealer:Remove() end
        Foxy.CarDealer.Dealer = ents.Create("foxy_car_dealer_dealer")
        Foxy.CarDealer.Dealer:SetModel("models/Humans/Group01/male_02.mdl")
        Foxy.CarDealer.Dealer:SetPos(trace.HitPos)
        Foxy.CarDealer.Dealer:Spawn()  
    end
end
 
function TOOL:RightClick(trace)
    if SERVER then
        if IsValid(Foxy.CarDealer.Dealer) then
            DInfos = {
                pos = Foxy.CarDealer.Dealer:GetPos(),
                ang = Foxy.CarDealer.Dealer:GetAngles()
            }

            local tab = util.TableToJSON(DInfos)
            file.Write("foxy/car_dealer/dealer_pos.json", tab)
        end
    elseif CLIENT then
        Foxy:Notify("Le Dealer à bien été sauvegarder !", 0, 5)
    end
end

function TOOL:DrawToolScreen(width, height)
    draw.RoundedBox(0, 0, 0, width, height, Color(19, 24, 29))
    draw.SimpleText("Dealer Spawner", Foxy:Font(40), width/2, height/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end