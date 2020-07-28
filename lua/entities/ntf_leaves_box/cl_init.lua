include("shared.lua")
surface.CreateFont( "ntb_semi_small", {
	font = "Bahnschrift SemiLight",
  size = 50,
  weight = 10
} )

function ENT:Draw()
	self:DrawModel()

	local DisColor = (250-self:GetPos():Distance( LocalPlayer():GetPos()))

	ang = self:GetAngles()
	ang:RotateAroundAxis(self:GetAngles():Forward(),0)
	ang:RotateAroundAxis(self:GetAngles():Up(),180)
	ang:RotateAroundAxis(self:GetAngles():Right(),0)

	if self:GetPos():Distance( LocalPlayer():GetPos()) < 400 then
		cam.Start3D2D(self:GetPos()+ang:Up()*4.5,ang,0.03)
			draw.RoundedBox(0,-190,-140,380,250,Color(30,30,30,DisColor))
			draw.SimpleText("Pudełko liści tytoniu","ntb_semi_small",0,-100,Color(255,255,255,DisColor),1,0)
			draw.SimpleText(self:GetStatus(),"ntb_semi_small",0,-50,Color(255,255,255,DisColor),1,0)
			draw.SimpleText("(Shift+E)","ntb_semi_small",0,50,Color(255,255,255,DisColor),1,0)

		cam.End3D2D()
	end

end
