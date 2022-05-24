AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel(Foxy.CarDealer.Settings.Garage.Model)
    self:SetHullType(HULL_HUMAN)
    self:SetHullSizeNormal()
    self:SetNPCState(NPC_STATE_SCRIPT)
    self:SetSolid(SOLID_BBOX)
    self:SetUseType(SIMPLE_USE)
    self:SetBloodColor(BLOOD_COLOR_RED)
    self:CapabilitiesAdd(CAP_ANIMATEDFACE, CAP_TURN_HEAD)
    self:SetMaxYawSpeed(90)
end

function ENT:AcceptInput(name, _, caller)
    if name == "Use" and caller:IsPlayer() then
    
        if caller:GetPos():DistToSqr(self:GetPos()) > 1000*6 then return end

        local tab = {}
        if file.Exists("foxy/car_dealer/player/" .. caller:SteamID64() .. ".json", "DATA") then
            tab = util.JSONToTable(file.Read("foxy/car_dealer/player/" .. caller:SteamID64() .. ".json"))
        end
        net.Start("Foxy:CarDealer:OpenGarage")
            net.WriteTable(tab)
        net.Send(caller)
    end
end

function ENT:OnTakeDamage()
    return 0
end