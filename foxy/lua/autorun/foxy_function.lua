Foxy = Foxy or {}

function Foxy:Message(msg, top, color)
    MsgC(color or Color(255, 156, 206), "[Foxy][" .. (top or "Global") .. "] ")
    MsgC(Color(240, 240, 240), msg or "Invalid Message !", " \n")
end

function Foxy:Width(pos) 
	return pos/1920*ScrW()
end

function Foxy:Height(pos)
	return pos/1080*ScrH()
end

if CLIENT then
	local blur = Material("pp/blurscreen")
	function Foxy:Blur(x, y, w, h, amount)
		surface.SetDrawColor(255, 255, 255) 
		surface.SetMaterial(blur)
		for i = 1, 3 do 
			blur:SetFloat("$blur", (i / 3) * (amount or 6)) 
			blur:Recompute() 
			render.UpdateScreenEffectTexture() 
			surface.DrawTexturedRect(x, y, w, h)
		end
	end

	function Foxy:Material(mat, posx, posy, sizex, sizey, col)
		surface.SetMaterial(Material("foxy/" .. mat .. ".png", "smooth"))
		surface.SetDrawColor(col or color_white)
		surface.DrawTexturedRect(posx, posy, sizex, sizey)
	end

	Foxy.Fonts = {}
	function Foxy:Font(size, weight)
		size = size or Foxy:Width(10)
		weight = weight or 500
		
		local FontName = ("Foxy:Font:%s:%s"):format(size, weight)
		if not Foxy.Fonts[FontName] then
			surface.CreateFont(FontName, {
				font = "Circular Std Medium",
				size = size,
				weight = weight,
				extended = false
			})

			Foxy.Fonts[FontName] = true

		end

		return FontName
	end

	function Foxy:Header(self, name)
		local angle = self:GetAngles()

		angle = Angle( 0, angle.y, 0 )
	
		angle.y = angle.y + math.sin( CurTime() ) * 10
	
		angle:RotateAroundAxis( angle:Up(), 90 )
		angle:RotateAroundAxis( angle:Forward(), 90 )
	
		local pos = self:GetPos()
	
		pos = pos + Vector( 2, -2, math.cos( CurTime() / 2 ) + 78 )
	
		cam.Start3D2D( pos, angle, 0.1 )
			surface.SetFont(Foxy:Font(30))
			local tW, tH = surface.GetTextSize(name)
	
			draw.RoundedBox(10, -tW/2, -4, tW+30, 40, Color(30, 39, 46))
			draw.RoundedBox(8, -(tW-4)/2, -2, tW+26, 36, Color(19, 24, 29))
	
			draw.SimpleText(name, Foxy:Font(30), -(tW-30)/2, 0, color_whit)
		cam.End3D2D()
	end

	function Foxy:AlphaClose(panel)
		if IsValid(panel) then
			panel:AlphaTo(0, 0.3, 0)
			timer.Simple(0.3, function()
				if IsValid(panel) then
					panel:Remove()
				end
			end)
		end
	end

	function Foxy:Notify(txt, code, time)
		notification.AddLegacy(txt, code, time)
	end
end