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
	self.tSlots = ""
	self.filledSlots = {}
end

function ENT:Draw()
	self:DrawModel()

	local DisColor = (250-self:GetPos():Distance( LocalPlayer():GetPos()))

	local ang = self:GetAngles()
	ang:RotateAroundAxis(self:GetAngles():Forward(),0)
	ang:RotateAroundAxis(self:GetAngles():Up(),90)
	ang:RotateAroundAxis(self:GetAngles():Right(),0)
	if self.tSlots != self:GetfilledSlots() then
		self.tSlots = self:GetfilledSlots()
		self.filledSlots = util.JSONToTable(self:GetfilledSlots()) or {}

	end

		if self:GetPos():Distance( LocalPlayer():GetPos()) < 400 then
			cam.Start3D2D(self:GetPos()+ang:Up()*35.3,ang,0.03)
				draw.RoundedBox(0,-800 * 0.5, -800 * 0.5, 1400, 800,Color(30,30,30,DisColor))
				TobaccoFactory:drawBoxCorners(-800 * 0.5, -800 * 0.5, 1400, 800,50,10,3,DisColor)
				draw.SimpleText(TobaccoFactory.Config.Lang.CrushingTable,"ntf_big",300,-400,Color(255,255,255,DisColor),1,0)
				if self.filledSlots[1] == "ntf_leaves_box" and self.filledSlots[2] == "ntf_leaves_box" and self.filledSlots[3] == "ntf_leaves_box" then
					draw.SimpleText(TobaccoFactory.Config.Lang.CrushLeaves,"ntf_small",300,-250,Color(255,255,255,DisColor),1,0)
					if self.Taps < TobaccoFactory.Config.CrushingTableTaps then
						draw.RoundedBox(0,self.pos[self.posnum].posx,self.pos[self.posnum].posy,120,120,Color(30,30,30,DisColor))
						draw.SimpleText("(E)","ntf_small",self.pos[self.posnum].posx+15,self.pos[self.posnum].posy+15,Color(255,255,255,DisColor),0,0)
						TobaccoFactory:drawBoxCorners(self.pos[self.posnum].posx,self.pos[self.posnum].posy,120,120,30,5,1,DisColor)
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

				elseif self.filledSlots[1] == "ntf_tobacco" then
					draw.SimpleText(TobaccoFactory.Config.Lang.TakeOutTobacco,"ntf_small",300,-250,Color(255,255,255,DisColor),1,0)
				else
					draw.SimpleText(TobaccoFactory.Config.Lang.WaitingForLeaves,"ntf_small",300,-250,Color(255,255,255,DisColor),1,0)
				end
			cam.End3D2D()
		end

end
