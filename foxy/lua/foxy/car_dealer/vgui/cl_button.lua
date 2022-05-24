local PANEL = {}

function PANEL:Init()
    self:SetFont(Foxy:Font(Foxy:Width(18)))
    self:SetTextColor(color_white)
end

function PANEL:SetColor(color)
    self.Color = color
end

function PANEL:SetRadius(radius)
    self.Radius = radius
end

function PANEL:Paint(w, h)
    draw.RoundedBox((self.Radius or 6), 0, 0, w, h, (self.Color or Color(255, 94, 87)))
    if self:IsHovered() then 
        draw.RoundedBox((self.Radius or 6), 0, 0, w, h, Color(0, 0, 0, 150))
    end
end

vgui.Register("Foxy.CarDealer.Button", PANEL, "DButton")