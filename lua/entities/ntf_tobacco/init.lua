AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")
function ENT:Initialize()
	self:SetModel("models/props_lab/jar01b.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS )
	self:SetSolid(SOLID_VPHYSICS)
	self:SetColor(Color(200,150,0))

	local phys = self:GetPhysicsObject()

	if IsValid(phys) then
		phys:Wake()
		phys:SetMass(5)
	end
	self:SetHealth(50)
	self:SetUseType(SIMPLE_USE)
	if self:GetTobacco() == 0 then
		self:SetTobacco(TobaccoFactory.Config.TobaccoInJar)
	end

end

function ENT:Use(ply)
	if not ply:GetEyeTrace().Entity == self then return end
	if self.parent == nil or self.parent:GetClass() != "ntf_packing_table" and self.parent:GetClass() != "ntf_crushing_table" then return end

	self.parent:UnPlug(self)

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
