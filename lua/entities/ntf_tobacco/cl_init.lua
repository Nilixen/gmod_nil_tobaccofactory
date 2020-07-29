include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	local DisColor = (250-self:GetPos():Distance( LocalPlayer():GetPos()))

	ang = self:GetAngles()
	ang:RotateAroundAxis(self:GetAngles():Forward(),90)
	ang:RotateAroundAxis(self:GetAngles():Up(),180)
	ang:RotateAroundAxis(self:GetAngles():Right(),0)

	if self:GetPos():Distance( LocalPlayer():GetPos()) < 400 then
//		cam.Start3D2D(self:GetPos()+ang:Up()*5.3,ang,0.03)
		cam.Start3D2D(self:GetPos()+ang:Up()*3.5,ang,0.03)
//			draw.RoundedBox(190,-95,-95,190,190,Color(30,30,30,DisColor))
//			draw.SimpleText(TobaccoFactory.Config.Lang.Tobacco,"ntf_extreme_small",0,-50,Color(255,255,255,DisColor),1,0)
//			draw.SimpleText(self:GetTobacco()..TobaccoFactory.Config.Lang.Weight ,"ntf_extreme_small",0,10,Color(255,255,255,DisColor),1,0)
				draw.RoundedBox(0,-90,-80,180,210,Color(30,30,30,DisColor))
				TobaccoFactory:drawBoxCorners(-90,-80,180,210,DisColor)
				draw.SimpleText(TobaccoFactory.Config.Lang.Tobacco,"ntf_extreme_small",0,-50,Color(255,255,255,DisColor),1,0)



		cam.End3D2D()
	end

end
