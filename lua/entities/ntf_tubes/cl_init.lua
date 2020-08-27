include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	local DisColor = (250-self:GetPos():Distance( LocalPlayer():GetPos()))

	local ang = self:GetAngles()
	ang:RotateAroundAxis(self:GetAngles():Forward(),0)
	ang:RotateAroundAxis(self:GetAngles():Up(),90)
	ang:RotateAroundAxis(self:GetAngles():Right(),270)

		if self:GetPos():Distance( LocalPlayer():GetPos()) < 400 then
			cam.Start3D2D(self:GetPos()+ang:Up()*6.4,ang,0.03)
				draw.RoundedBox(0,-205, -250, 400, 230,Color(30,30,30,DisColor))
				TobaccoFactory:drawBoxCorners(-205, -250, 400, 230,50,10,3,DisColor)
				draw.SimpleText(TobaccoFactory.Config.Lang.CigaretteTubes,"ntf_very_small",0,-200,Color(255,255,255,DisColor),1,0)
				draw.SimpleText(self:Getamount().." "..TobaccoFactory.Config.Lang.TubesLeft,"ntf_very_small",0,-150,Color(255,255,255,DisColor),1,0)
			cam.End3D2D()
		end

end
