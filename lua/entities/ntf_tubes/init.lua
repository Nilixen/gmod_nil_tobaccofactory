AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()

	self:SetModel("models/props/cs_office/cardboard_box02.mdl")
	self:SetColor(Color(50,50,180))
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS )
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:SetMass(50)
	end
	self:SetHealth(50)

end

function ENT:Touch(ent)
	if ent:GetClass() != "ntf_packing_table" then return end
	ent:PlugIn(self)
end

function ENT:OnTakeDamage(dmg)
	self:TakePhysicsDamage(dmg)

	self:SetHealth(self:Health() - dmg:GetDamage())
	if self:Health() <= 0 then
		self:Remove()
	end
end

function ENT:Use(ply)

	if self.parent == nil or self.parent:GetClass() != "ntf_packing_table" then return end
	self.parent:UnPlug(self)

end

function ENT:OnRemove()

end
