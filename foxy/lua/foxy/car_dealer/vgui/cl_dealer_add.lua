local PANEL = {}

function PANEL:Init()
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, 0.3, 0)

    local Inside = self:Add("DPanel")
    Inside:Dock(FILL)
    Inside:DockMargin(7, 7, 7, 7)
    Inside.Paint = function(panel, w, h)
        draw.RoundedBox(14, 0, 0, w, h, Color(19, 24, 29))
    end

    local VheSelect = ""
    local NameEnter

    local VehBtn = Inside:Add("DButton")
    VehBtn:Dock(TOP)
    VehBtn:DockMargin(7, 7, 7, 7)
    VehBtn:SetHeight(Foxy:Height(30))
    VehBtn:SetText("")
    VehBtn.Paint = function(self, w, h)
        draw.RoundedBox(6, 0, 0, w, h, Color(0, 0, 0, 150))
        draw.SimpleText("Véhicules", Foxy:Font(Foxy:Width(20)), w*0.025, h*0.17, color_white)
        if IsValid(Menu) then
            Foxy:Material("car_dealer/down", w*0.94, h*0.4, w*0.025, w*0.025)
        else
            Foxy:Material("car_dealer/up", w*0.94, h*0.4, w*0.025, w*0.025)
        end
    end
    VehBtn.DoClick = function(self)
        surface.PlaySound("UI/buttonrollover.wav")
        local Menu = DermaMenu()

        Menu.Paint = function(self, w, h)
            draw.RoundedBox(6, 0, 0, w, h, Color(30, 39, 46))
        end

        local scroll = Menu:GetVBar()
        scroll:SetSize(0,0)

        for k, v in pairs(list.Get("Vehicles")) do
            Menu:AddOption(v.Name, function() 
                VheSelect = tostring(k)
                NameEnter:SetValue(v.Name)
            end):SetTextColor(color_white)
        end

        Menu:Open()
    end

    NameEnter = Inside:Add("DTextEntry")
    NameEnter:Dock(TOP)
    NameEnter:DockMargin(7, 0, 7, 7)
    NameEnter:SetHeight(Foxy:Height(30))
    NameEnter:SetNumeric(true)
    NameEnter:SetFont(Foxy:Font(Foxy:Width(20)))
    NameEnter:SetDrawLanguageID(false)
    NameEnter.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 150))
        self:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255))
    end
    NameEnter:SetValue("Nom du Véhicule")

    local PriceEnter = Inside:Add("DTextEntry")
    PriceEnter:Dock(TOP)
    PriceEnter:DockMargin(7, 0, 7, 7)
    PriceEnter:SetHeight(Foxy:Height(30))
    PriceEnter:SetNumeric(true)
    PriceEnter:SetFont(Foxy:Font(Foxy:Width(20)))
    PriceEnter:SetDrawLanguageID(false)
    PriceEnter.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 150))
        self:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255))
    end
    PriceEnter:SetValue("0")

    local CloseBtn = Inside:Add("Foxy.CarDealer.Button")
    CloseBtn:Dock(BOTTOM)
    CloseBtn:DockMargin(7, 0, 7, 7)
    CloseBtn:SetHeight(Foxy:Height(30))
    CloseBtn:SetText("Fermer le Menu")
    CloseBtn.DoClick = function(panel)
        surface.PlaySound("UI/buttonrollover.wav")
        Foxy:AlphaClose(self)
    end

    local AddBtn = Inside:Add("Foxy.CarDealer.Button")
    AddBtn:Dock(BOTTOM)
    AddBtn:DockMargin(7, 7, 7, 7)
    AddBtn:SetHeight(Foxy:Height(30))
    AddBtn:SetColor(Color(11, 232, 129))
    AddBtn:SetText("Ajoutez le Véhicule")
    AddBtn.DoClick = function(panel)
        surface.PlaySound("UI/buttonrollover.wav")
        Foxy:AlphaClose(self)
        Foxy:Notify("Vous avez ajoutez un nouveau véhicule", 0, 3)
        net.Start("Foxy:CarDealer:AddVehicle")
            net.WriteString(VheSelect)
            net.WriteString(NameEnter:GetValue())
            net.WriteString(PriceEnter:GetValue())
        net.SendToServer()
    end
end

function PANEL:Paint(w, h)
    draw.RoundedBox(20, 0, 0, w, h, Color(30, 39, 46))
end

vgui.Register("Foxy.CarDealer.Dealer.Add", PANEL, "EditablePanel")