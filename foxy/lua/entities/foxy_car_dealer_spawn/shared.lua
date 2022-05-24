ENT.Base = "base_gmodentity"
ENT.Type = "anim"

ENT.PrintName = "Spawn"
ENT.Author = "Foxy"
ENT.Category = "Foxy Car Dealer"

ENT.Spawnable = false
ENT.AdminOnly = false

ENT.AutomaticFrameAdvance = true

function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim
end