include("shared.lua")

function ENT:Initialize()
	self.pos = {
		{
			posx = 200,
			posy = -100,
		},
		{
			posx = -350,
			posy = -150,
		},
		{
			posx = -50,
			posy = 250
		},
		{
			posx = 550,
			posy = -150
		},
		{
			posx = -100,
			posy = 150
		},
		{
			posx = 350,
			posy = 50
		},
		{
			posx = 150,
			posy = 250
		},
		{
			posx = -150,
			posy = -150
		},
	}
	self.posnum = math.random(1,table.Count(self.pos))
	self.Taps = 0

end

function ENT:Draw()
	self:DrawModel()

	local DisColor = (250-self:GetPos():Distance( LocalPlayer():GetPos()))

	local ang = self:GetAngles()
	ang:RotateAroundAxis(self:GetAngles():Forward(),0)
	ang:RotateAroundAxis(self:GetAngles():Up(),90)
	ang:RotateAroundAxis(self:GetAngles():Right(),0)

	if self:GetPos():Distance( LocalPlayer():GetPos()) < 400 then
		cam.Start3D2D(self:GetPos()+ang:Up()*35.3,ang,0.03)
			draw.RoundedBox(0,-1000 * 0.5, -800 * 0.5, 1400, 800,Color(30,30,30,DisColor))
			TobaccoFactory:drawBoxCorners(-1000 * 0.5, -800 * 0.5, 1400, 800,DisColor)
			draw.SimpleText(TobaccoFactory.Config.Lang.CrushingTable,"ntf_big",200,-400,Color(255,255,255,DisColor),1,0)
			if IsValid(self:GetChilds()) and self:GetChilds():GetClass() == "ntf_leaves_box" then
				draw.SimpleText(TobaccoFactory.Config.Lang.CrushLeaves,"ntf_small",200,-250,Color(255,255,255,DisColor),1,0)
			elseif IsValid(self:GetChilds()) and  self:GetChilds():GetClass() == "ntf_tobacco" then
				draw.SimpleText(TobaccoFactory.Config.Lang.TakeOutTobacco,"ntf_small",200,-250,Color(255,255,255,DisColor),1,0)
			else
				draw.SimpleText(TobaccoFactory.Config.Lang.WaitingForLeaves,"ntf_small",200,-250,Color(255,255,255,DisColor),1,0)
			end

			if IsValid(self:GetChilds()) and self:GetChilds():GetClass() == "ntf_leaves_box" and self.Taps < TobaccoFactory.Config.CrushingTableTaps then
				draw.RoundedBox(0,self.pos[self.posnum].posx,self.pos[self.posnum].posy,120,120,Color(30,30,30,DisColor))
				draw.SimpleText("(E)","ntf_small",self.pos[self.posnum].posx+15,self.pos[self.posnum].posy+15,Color(255,255,255,DisColor),0,0)
				TobaccoFactory:drawBoxCorners(self.pos[self.posnum].posx,self.pos[self.posnum].posy,120,120,DisColor)
				if LocalPlayer():GetEyeTrace().Entity == self then

	        local tr = self:WorldToLocal( LocalPlayer():GetEyeTrace().HitPos )
					if ((tr.y > self.pos[self.posnum].posx * 0.03 and tr.y < (self.pos[self.posnum].posx * 0.03) + 4) and (tr.x > self.pos[self.posnum].posy * 0.03 and tr.x < (self.pos[self.posnum].posy * 0.03) + 4) and (tr.z > 34.9 and tr.z < 35 )) then

						draw.SimpleText("(E)","ntf_small",self.pos[self.posnum].posx+15,self.pos[self.posnum].posy+15,Color(255,0,0,DisColor),0,0)

						if LocalPlayer():KeyPressed(IN_USE) then
							self.Taps = self.Taps + 1
							if self.Taps >= TobaccoFactory.Config.CrushingTableTaps then
								self.Taps = 0
							end
							self.posnum = math.random(1,table.Count(self.pos))
							net.Start("ntf_crushing_table")
								net.WriteString("Crush")
								net.WriteEntity(self)
							net.SendToServer()
						end
					end
				end
			end
		cam.End3D2D()
	end
end