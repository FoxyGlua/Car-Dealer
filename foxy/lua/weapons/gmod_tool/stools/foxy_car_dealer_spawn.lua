TOOL.Category = "Foxy"
TOOL.Name = "Spawn Spawner"
TOOL.Command = nil
TOOL.ConfigName = "Spawn Spawner"

TOOL.ClientConVar["myparameter"] = "fubar"

TOOL.Information = {
	{ name = "left" },
	{ name = "right" }
}

if CLIENT then
	language.Add("Tool.foxy_car_dealer_spawn.name", "Spawn Spawner")
    language.Add("tool.foxy_car_dealer_spawn.desc", "Faire spawn le Spawn.")
	language.Add("Tool.foxy_car_dealer_spawn.left", "Spawn")
	language.Add("Tool.foxy_car_dealer_spawn.right", "Save")
end

local DInfos
 
function TOOL:LeftClick(trace)
    if SERVER then
        if IsValid(Foxy.CarDealer.Spawn) then Foxy.CarDealer.Spawn:Remove() end
        Foxy.CarDealer.Spawn = ents.Create("foxy_car_dealer_spawn")
        Foxy.CarDealer.Spawn:SetModel("models/hunter/plates/plate3x6.mdl")
        Foxy.CarDealer.Spawn:SetPos(trace.HitPos)
        Foxy.CarDealer.Spawn:Spawn() 
    end
end
 
function TOOL:RightClick(trace)
    if SERVER then
        if IsValid(Foxy.CarDealer.Spawn) then

            Foxy.CarDealer.Spawn:SetColor(Color(0, 0, 0, 0)) 
            Foxy.CarDealer.Spawn:SetRenderMode(RENDERMODE_TRANSCOLOR)

            DInfos = {
                pos = Foxy.CarDealer.Spawn:GetPos(),
                ang = Foxy.CarDealer.Spawn:GetAngles()
            }

            local tab = util.TableToJSON(DInfos)
            file.Write("foxy/car_dealer/spawn_pos.json", tab)
        end
    elseif CLIENT then
        Foxy:Notify("Le Spawn à bien été sauvegarder !", 0, 5)
    end
end

function TOOL:DrawToolScreen(width, height)
    draw.RoundedBox(0, 0, 0, width, height, Color(19, 24, 29))
    draw.SimpleText("Spawn Spawner", Foxy:Font(40), width/2, height/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end