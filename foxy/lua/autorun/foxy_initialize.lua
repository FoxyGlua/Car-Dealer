if not Foxy then return end

Foxy.CarDealer = {}

function Foxy:Initialize(str)
    local files = file.Find(str .. "/*", "LUA")
    for _, v in ipairs(files) do
        local path = str .. "/" .. v
        if string.StartWith(v, "sv_") then
            if SERVER then
                include(path)
            end
            Foxy:Message(v, "Initialize", Color(61, 255, 255))
        elseif string.StartWith(v, "cl_") then
            if SERVER then
                AddCSLuaFile(path)
            else
                include(path)
            end
            Foxy:Message(v, "Initialize", Color(255, 119, 61))
        else
            AddCSLuaFile(path)
            include(path)
            Foxy:Message(v, "Initialize", Color(113, 255, 61))
        end
    end
end

Foxy:Initialize("foxy")
Foxy:Initialize("foxy/car_dealer")
Foxy:Initialize("foxy/car_dealer/vgui")