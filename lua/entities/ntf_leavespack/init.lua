AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")
function ENT:Initialize()
	self:SetModel("models/props_junk/cardboard_box001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS )
	self:SetSolid(SOLID_VPHYSICS)
	self:SetColor(Color(225,255,180))

	local phys = self:GetPhysicsObject()

	if IsValid(phys) then
		phys:Wake()
		phys:SetMass(50)
	end
	self:SetUseType(SIMPLE_USE)
	self:SetPos(self:GetPos()+Vector(0,0,25))
	self:SetHealth(150)

	self:SetBoxes(TobaccoFactory.Config.Leaves)
end

function ENT:Use(ply)
	if self:GetBoxes() > 0 then
		self:SetBoxes(self:GetBoxes()-1)
		local smallLeavesBox = ents.Create("ntf_leaves_box")
		smallLeavesBox:SetPos(self:GetPos()+Vector(0,0,35))
		smallLeavesBox:SetAngles(self:GetAngles())
		smallLeavesBox:Spawn()
		if self:GetBoxes() == 0 then
			self:Remove()
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
