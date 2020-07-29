include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	local DisColor = (255-self:GetPos():Distance( LocalPlayer():GetPos()))

	ang = self:GetAngles()
	ang:RotateAroundAxis(self:GetAngles():Forward(),0)
	ang:RotateAroundAxis(self:GetAngles():Up(),90)
	ang:RotateAroundAxis(self:GetAngles():Right(),0)

	if self:GetPos():Distance( LocalPlayer():GetPos()) < 400 then
		cam.Start3D2D(self:GetPos()+ang:Up()*12.3,ang,0.03)
			draw.RoundedBox(0,-545,-250,1100,450,Color(30,30,30,DisColor))
			TobaccoFactory:drawBoxCorners(-545,-250,1100,450,DisColor)
			draw.SimpleText(TobaccoFactory.Config.Lang.LeavesPack,"ntf_big",0,-200,Color(255,255,255,DisColor),1,0)
			draw.SimpleText(self:GetBoxes().." "..TobaccoFactory.Config.Lang.PacksLeft,"ntf_big",0,-80,Color(255,255,255,DisColor),1,0)
			draw.SimpleText(TobaccoFactory.Config.Lang.Unpack,"ntf_big",0,50,Color(255,255,255,DisColor),1,0)
		cam.End3D2D()
	end

end
