include("shared.lua")


function ENT:Draw()
	self:DrawModel()

	local DisColor = (250-self:GetPos():Distance( LocalPlayer():GetPos()))

	local ang = self:GetAngles()
	ang:RotateAroundAxis(self:GetAngles():Forward(),0)
	ang:RotateAroundAxis(self:GetAngles():Up(),90)
	ang:RotateAroundAxis(self:GetAngles():Right(),0)

		if self:GetPos():Distance( LocalPlayer():GetPos()) < 400 then

		end

end
