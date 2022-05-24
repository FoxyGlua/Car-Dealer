include("shared.lua")

function ENT:Draw()
    self:DrawModel()

	Foxy:Header(self, Foxy.CarDealer.Settings.Dealer.Name)
end