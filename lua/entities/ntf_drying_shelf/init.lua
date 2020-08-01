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
	self:SetAngles(self:GetAngles()+Angle(0,90,0))
	self.nextTime = CurTime() + 1

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

end

function ENT:Think()
	if self.nextTime <= CurTime() then
		self.nextTime = CurTime()+1
		for k,v in pairs(self.filledSlots) do
			if v:GetClass() == "ntf_leaves_box" then
				if v:GetDoneTime() > 1 then
					v:SetDoneTime(v:GetDoneTime()-1)
				end
			end
		end
	end
end

function ENT:GetOpenSlots()
	if self.filledSlots == {} then return 6 end

	local open = table.Count(self.slots)

	for k, v in pairs(self.filledSlots) do
		if IsValid(v) then
			open = open - 1
		else
			self.filledSlots[k] = nil
		end
	end
	return open
end

function ENT:FirstAvaibleSlot()
	for k,_ in pairs(self.slots) do
		if self.filledSlots[k] == nil then return k end
	end
	return

end

function ENT:PlugIn(ent)
	if !IsValid(ent) then return end
	if ent:GetClass() != "ntf_leaves_box" then return end
	if ent:GetDoneTime() == 1 then return end
	if self:GetOpenSlots() <= 0 then return end

	local num = self:FirstAvaibleSlot()


	local pos = self.slots[num].pos
	local ang = self.slots[num].ang

	ent.parent = self
	ent:SetPos(self:LocalToWorld(pos or Vector()))
	ent:SetAngles(self:LocalToWorldAngles(ang or Angle()))
	ent:SetParent(self)

	self.filledSlots[num] = ent

end

function ENT:UnPlug(ent)
	if ent:GetClass() != "ntf_leaves_box" then return end

	for k, v in pairs(self.filledSlots) do
		if not IsValid(v) then continue end
		if v == ent then
			self.filledSlots[k] = nil
			ent.parent = nil
			ent:SetParent()


			local pos = (self.slots[k].pos + Vector(0, -35, 0) or self:GetPos()+Vector(0, -35, 0))
			local ang = self.slots[k].ang

			ent:SetPos(self:LocalToWorld(pos))
			local phys = ent:GetPhysicsObject()
			phys:EnableMotion(true)
		end
	end
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
