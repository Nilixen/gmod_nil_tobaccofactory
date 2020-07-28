AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")
function ENT:Initialize()
	self:SetModel("models/props_wasteland/kitchen_shelf001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS )
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()

	if IsValid(phys) then
		phys:Wake()
		phys:SetMass(150)
	end
	self:SetHealth(300)

	self.filledSlots = {}

	self.slots = {
		{
			pos = Vector(15, -1, 15),
			ang = Angle(0, 193, 0)
		},
		{
			pos = Vector(-4, -1.5, 15),
			ang = Angle(0, 182, 0)
		},
		{
			pos = Vector(-20, -0.5, 15),
			ang = Angle(0, 188, 0)
		},
		{
			pos = Vector(15, -0.5, 36.5),
			ang = Angle(0, 197, 0)
		},
		{
			pos = Vector(-4, -1, 36.5),
			ang = Angle(0, 188, 0)
		},
		{
			pos = Vector(-20, -1.5, 36.5),
			ang = Angle(0, 181, 0)
		},
	}
	self.radiator = nil
	self.radiatorSlot = {
		pos = Vector(0, 16, 35),
		ang = Angle(0, 90, 0)
	}

end

function ENT:Think()

end

function ENT:GetOpenSlots()
	if self.filledSlots == {} then return 6 end

	local open = table.Count(self.slots)

	for k, v in pairs(self.boxes) do
		if IsValid(v) then
			open = open - 1
		else
			self.boxes[k] = nil
		end
	end
	return open
end

function ENT:FirstAvaibleSlot()
	for k,v in pairs(self.FilledSlots) do
		if v == nil then return k end
	end
	return
end

function ENT:PlugIn(ent)
	if !isValid(ent) then return end
	if ent:GetClass() != "" then return end

	
end

function ENT:UnPlug(ent)

end

function ENT:OnTakeDamage(dmg)
	self:TakePhysicsDamage(dmg)

	self:SetHealth(self:Health() - dmg:GetDamage())
	if self:Health() <= 0 then
		self:Remove()
	end
end

function ENT:OnRemove()

end
