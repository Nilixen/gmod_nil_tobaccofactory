AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

util.AddNetworkString("ntf_crushing_table")

function ENT:Initialize()
	self:SetModel("models/props/cs_militia/table_shed.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS )
	self:SetSolid(SOLID_VPHYSICS)


	local phys = self:GetPhysicsObject()

	if IsValid(phys) then
		phys:Wake()
		phys:SetMass(150)
	end
	self:SetHealth(300)
	self:SetUseType(SIMPLE_USE)

	self.filledSlots = {}

	self.slots = {
		{
		pos = Vector(9, -34, 35),
		ang = Angle(0, 65, 0),
		class = "ntf_tubes"
		},
		{
		pos = Vector(-5, -21, 39),
		ang = Angle(0, 325, 0),
		class = "ntf_tobacco"
		},
		{
		pos = Vector(0, -24, 39),
		ang = Angle(0, 330, 0),
		class = "ntf_filters"
		},
		{
		pos = Vector(7, -14, 39),
		ang = Angle(0, 330, 0),
		class = "ntf_boxes"
		},
	}

	self.sounds = {
		"physics/plaster/ceiling_tile_impact_hard1.wav",
		"physics/plaster/ceiling_tile_impact_hard2.wav",
		"physics/plaster/ceiling_tile_impact_hard3.wav",
	}
end

function ENT:GetOpenSlots(ent)
 local class = ent:GetClass()
 local tbl = {}
 for k,v in pairs(self.slots) do

	 if self.slots[k].class == class and !IsValid(self.filledSlots[k]) then
		 tbl[table.Count(tbl)+1] =  ent
	 end
	end
	return table.Count(tbl)
end

function ENT:FirstAvaibleSlot(ent)
	for k,_ in pairs(self.slots) do
		if self.filledSlots[k] == nil and ent:GetClass() == self.slots[k].class then return k end
	end
	return

end

function ENT:PlugIn(ent)
	if ent:GetClass() != "ntf_tubes" and ent:GetClass() != "ntf_tobacco" and ent:GetClass() != "ntf_filters" and ent:GetClass() != "ntf_boxes" and ent:GetClass() != "ntf_export_box" then return end
	if self:GetOpenSlots(ent) <= 0 then return end


	local num = self:FirstAvaibleSlot(ent)

	local pos = self.slots[num].pos
	local ang = self.slots[num].ang

	ent.parent = self
	ent:SetPos(self:LocalToWorld(pos or Vector()))
	ent:SetAngles(self:LocalToWorldAngles(ang or Angle()))
	ent:SetParent(self)

	self.filledSlots[num] = ent
	local a = {}
	for k,v in pairs(self.filledSlots) do
		if IsValid(v) then
			a[k] = v:GetClass()
		end
	end
	self:SetfilledSlots(util.TableToJSON(a))
end

function ENT:UnPlug(ent)
	if ent:GetClass() != "ntf_tubes" and ent:GetClass() != "ntf_tobacco" and ent:GetClass() != "ntf_filters" and ent:GetClass() != "ntf_boxes" and ent:GetClass() != "ntf_export_box" then return end
	for k, v in pairs(self.filledSlots) do
		if not IsValid(v) then continue end
		if v == ent then
			self.filledSlots[k] = nil
			ent.parent = nil
			ent:SetParent()


			local pos = (self.slots[k].pos + Vector(55, 0, 0) or self:GetPos()+Vector(55, 0, 0))
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
 for _,v in pairs(self.filledSlots) do
	 if IsValid(v) then
		 self:UnPlug(v)
	 end
 end
end
