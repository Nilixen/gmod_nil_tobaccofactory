include("shared.lua")


function ENT:Draw()
	self:DrawModel()

	local DisColor = (250-self:GetPos():Distance( LocalPlayer():GetPos()))

	ang = self:GetAngles()
	ang:RotateAroundAxis(self:GetAngles():Forward(),0)
	ang:RotateAroundAxis(self:GetAngles():Up(),180)
	ang:RotateAroundAxis(self:GetAngles():Right(),0)

	if self:GetPos():Distance( LocalPlayer():GetPos()) < 400 then
		cam.Start3D2D(self:GetPos()+ang:Up()*4.2,ang,0.03)
			draw.RoundedBox(0,-190,-140,380,250,Color(30,30,30,DisColor))
			TobaccoFactory:drawBoxCorners(-190,-140,380,250,DisColor)
			draw.SimpleText(TobaccoFactory.Config.Lang.LeavesBox,"ntf_very_small",0,-100,Color(255,255,255,DisColor),1,0)

			if self:GetDoneTime() == 0 and IsValid(self:GetParent()) and self:GetParent():GetClass() == "ntf_drying_shelf" then
				draw.SimpleText(TobaccoFactory.Config.Lang.TakeOut,"ntf_very_small",0,-20,Color(255,255,255,DisColor),1,0)

			elseif self:GetDoneTime() == 0 and !IsValid(self:GetParent()) then
				draw.SimpleText(TobaccoFactory.Config.Lang.PlaceInCrusher,"ntf_extreme_small",0,-20,Color(255,255,255,DisColor),1,0)

			elseif IsValid(self:GetParent()) and self:GetParent():GetClass() == "ntf_crushing_table" then
				draw.SimpleText(TobaccoFactory.Config.Lang.Crush,"ntf_extreme_small",0,-20,Color(255,255,255,DisColor),1,0)

			elseif IsValid(self:GetParent()) and self:GetParent():GetClass() == "ntf_drying_shelf" then
				draw.SimpleText(TobaccoFactory.Config.Lang.Wait.." "..self:GetDoneTime().." "..TobaccoFactory.Config.Lang.Seconds,"ntf_extreme_small",0,-20,Color(255,255,255,DisColor),1,0)

			else
				draw.SimpleText(TobaccoFactory.Config.Lang.PlaceInDryer,"ntf_very_small",0,-20,Color(255,255,255,DisColor),1,0)

			end

		cam.End3D2D()
	end

end
