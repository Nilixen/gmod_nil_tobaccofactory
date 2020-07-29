AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

util.AddNetworkString("ntf_crushing_table")

function ENT:Initialize()
	self:SetModel("models/props/cs_militia/table_kitchen.mdl")
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

	self:SetChilds(nil)

	self.Taps = 0

	self.slot = {
		pos = Vector(1, -25, 39),
		ang = Angle(0, 305, 0)
	}

	self.Sounds = {
		"physics/plaster/ceiling_tile_impact_hard1.wav",
		"physics/plaster/ceiling_tile_impact_hard2.wav",
		"physics/plaster/ceiling_tile_impact_hard3.wav",
	}
end

function ENT:Think()

end

net.Receive("ntf_crushing_table",function(lng,ply)
	local str = net.ReadString()
	if str == "Crush" then
		local ent = net.ReadEntity()
		if ent:GetClass() != "ntf_crushing_table" then return end
		ent.WorkingSound = CreateSound(ent, ent.Sounds[math.random(1,3)])
		ent.WorkingSound:Play()
		ent.Taps = ent.Taps + 1
		if ent.Taps >= TobaccoFactory.Config.CrushingTableTaps then
			ent.Taps = 0
			ent:GetChilds():Remove()
			local tobacco = ents.Create("ntf_tobacco")
			tobacco:SetPos(ent:LocalToWorld(ent.slot.pos+Vector(0,0,1)))
			tobacco:SetAngles(ent:LocalToWorldAngles(ent.slot.ang))
			tobacco:Spawn()
			tobacco:SetParent(ent)
			tobacco.parent = ent
			ent:SetChilds(tobacco)

		end
	end

end)

function ENT:PlugIn(ent)
	if ent:GetClass() != "ntf_leaves_box" then return end
	if ent:GetDoneTime() != 0 then return end
	if IsValid(self:GetChilds()) then return end

	local pos = self.slot.pos
	local ang = self.slot.ang

	ent.parent = self
	ent:SetPos(self:LocalToWorld(pos or Vector()))
	ent:SetAngles(self:LocalToWorldAngles(ang or Angle()))
	ent:SetParent(self)

	self:SetChilds(ent)

end

function ENT:UnPlug(ent)
	if ent:GetClass() != "ntf_tobacco" then return end
	local pos = (self.slot.pos + Vector(35, 0, 0) or self:GetPos()+Vector(35, 0, 0))
	local ang = self.slot.ang

	ent.parent = nil
	ent:SetParent()
	ent:SetPos(self:LocalToWorld(pos))
	self:SetChilds(nil)

	local phys = ent:GetPhysicsObject()
	phys:EnableMotion(true)
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
