local PANEL = {}

function PANEL:Init()
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, 0.3, 0)

    timer.Simple(0.1, function()
        local Inside = self:Add("DPanel")
        Inside:Dock(FILL)
        Inside:DockMargin(7, 7, 7, 7)
        Inside.Paint = function(panel, w, h)
            draw.RoundedBox(14, 0, 0, w, h, Color(19, 24, 29))
        end

        local Left = Inside:Add("DPanel")
        Left:Dock(LEFT)
        Left:DockMargin(7, 7, 7, 7)
        Left:SetWidth(Foxy:Width(300))
        Left.Paint = function(panel, w, h)
            draw.RoundedBox(8, 0, 0, w, h, Color(14, 18, 22))
        end

        local CloseBtn = Left:Add("Foxy.CarDealer.Button")
        CloseBtn:Dock(BOTTOM)
        CloseBtn:DockMargin(7, 0, 7, 7)
        CloseBtn:SetHeight(Foxy:Height(30))
        CloseBtn:SetText("Fermer le Menu")
        CloseBtn.DoClick = function(panel)
            surface.PlaySound("UI/buttonrollover.wav")
            Foxy:AlphaClose(self)
        end

        if Foxy.CarDealer.Settings.StaffGroup[LocalPlayer():GetUserGroup()] then
            local RemoveBtn = Left:Add("Foxy.CarDealer.Button")
            RemoveBtn:Dock(BOTTOM)
            RemoveBtn:DockMargin(7, 0, 7, 7)
            RemoveBtn:SetHeight(Foxy:Height(30))
            RemoveBtn:SetColor(Color(255, 192, 72))
            RemoveBtn:SetText("Retirez un Véhicule")
            RemoveBtn.DoClick = function(panel)
                surface.PlaySound("UI/buttonrollover.wav")
                local Menu = DermaMenu()

                Menu.Paint = function(self, w, h)
                    draw.RoundedBox(6, 0, 0, w, h, Color(30, 39, 46))
                end

                local scroll = Menu:GetVBar()
                scroll:SetSize(0,0)

                for k, v in pairs(self.VehTable) do
                    Menu:AddOption(v.Name, function()
                        net.Start("Foxy:CarDealer:RemoveVehicle")
                            net.WriteString(k)
                        net.SendToServer()
                        Foxy:AlphaClose(self)
                    end):SetTextColor(color_white)
                end

                Menu:Open()
            end

            local AddBtn = Left:Add("Foxy.CarDealer.Button")
            AddBtn:Dock(BOTTOM)
            AddBtn:DockMargin(7, 0, 7, 7)
            AddBtn:SetHeight(Foxy:Height(30))
            AddBtn:SetColor(Color(11, 232, 129))
            AddBtn:SetText("Ajoutez un Véhicule")
            AddBtn.DoClick = function(panel)
                surface.PlaySound("UI/buttonrollover.wav")
                Foxy:AlphaClose(self)
                Foxy.CarDealer.DealerAddFrame = vgui.Create("Foxy.CarDealer.Dealer.Add")
                Foxy.CarDealer.DealerAddFrame:Dock(FILL)
                Foxy.CarDealer.DealerAddFrame:DockMargin(650, 358, 650, 358)
            end
        end

        local VehScroll = Left:Add("DScrollPanel")
        VehScroll:Dock(FILL)
        VehScroll:DockMargin(7, 7, 7, 7)

        local vBar = VehScroll:GetVBar()
        vBar:SetSize(0,0)

        for k, v in ipairs(self.VehTable) do

            local info = list.Get("Vehicles")[v.Class]

            local VehBtn = VehScroll:Add("DButton")
            VehBtn:Dock(TOP)
            VehBtn:DockMargin(7, 7, 7, 0)
            VehBtn:SetHeight(Foxy:Height(65))
            VehBtn:SetText("")
            VehBtn.Paint = function(panel, w, h)
                if panel:IsHovered() then
                    draw.RoundedBox(6, 0, 0, w, h, Color(0, 0, 0, 200))
                end
                draw.DrawText(v.Name, Foxy:Font(Foxy:Width(22)), w*0.28, h*0.23, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                draw.DrawText(tonumber(v.Price) == 0 and "Gratuit" or DarkRP.formatMoney(tonumber(v.Price)), Foxy:Font(Foxy:Width(18)), w*0.28, h*0.52, Color(255, 255, 255, 150), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end
            VehBtn.DoClick = function(panel)
                surface.PlaySound("UI/buttonrollover.wav")
                if IsValid(VehMdl) then VehMdl:Remove() end

                VehMdl = Inside:Add("DPanel")
                VehMdl:Dock(FILL)
                VehMdl:DockMargin(8, 8, 8, 8)
                VehMdl.Paint = function(self, w, h)
                    draw.DrawText(v.Name, Foxy:Font(Foxy:Width(30)), w/2, h*0.1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end

                local Vehicle = VehMdl:Add("DModelPanel")
                Vehicle:Dock(FILL)
                Vehicle:DockMargin(6, 6, 6, 6)
                Vehicle:SetModel(info.Model)
                Vehicle:SetFOV(50)
                Vehicle:SetCamPos(Vector(200, 250, 100))
                Vehicle:SetMouseInputEnabled(false)
                
                local BuyBtn = VehMdl:Add("Foxy.CarDealer.Button")
                BuyBtn:Dock(BOTTOM)
                BuyBtn:DockMargin(180, 0, 180, 7)
                BuyBtn:SetHeight(Foxy:Height(30))
                BuyBtn:SetColor(Color(11, 232, 129))
                BuyBtn:SetText("Achetez le Véhicule")
                BuyBtn.DoClick = function(panel)
                    surface.PlaySound("UI/buttonrollover.wav")
                    Foxy:AlphaClose(self)
                    net.Start("Foxy:CarDealer:BuyVehicle")
                        net.WriteString(v.Class)
                        net.WriteString(v.Name)
                        net.WriteString(v.Price)
                    net.SendToServer()
                end
            end

            local Models = VehBtn:Add("DModelPanel")
            Models:Dock(LEFT)
            Models:DockMargin(6, 6, 6, 6)
            Models:SetWidth(Foxy:Width(65))
            Models:SetModel(info.Model)
            Models:SetFOV(50)
            Models:SetCamPos(Vector(200, 250, 100))
            Models.LayoutEntity = function(Entity) 
                return 
            end
        end
    end)
end

function PANEL:VehTable(tbl)
    self.VehTable = tbl
end

function PANEL:Paint(w, h)
    draw.RoundedBox(20, 0, 0, w, h, Color(30, 39, 46))
end

vgui.Register("Foxy.CarDealer.Dealer", PANEL, "EditablePanel")