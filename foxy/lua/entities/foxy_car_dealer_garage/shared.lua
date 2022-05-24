ENT.Base = "base_ai"
ENT.Type = "ai"

ENT.PrintName = "Garage"
ENT.Author = "Foxy"
ENT.Category = "Foxy Car Dealer"

ENT.Spawnable = false
ENT.AdminOnly = false

ENT.AutomaticFrameAdvance = true

function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim
end