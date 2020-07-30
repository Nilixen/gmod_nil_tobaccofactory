AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

util.AddNetworkString("ntf_ordering_pc")

function ENT:Initialize()
	self:SetModel("models/props/de_inferno/tableantique.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS )
	self:SetSolid(SOLID_VPHYSICS)


	local phys = self:GetPhysicsObject()

	if IsValid(phys) then
		phys:Wake()
		phys:SetMass(150)
	end
	self:SetUseType(SIMPLE_USE)
	self:SetHealth(150)

end

function ENT:Use(ply, call)
	if engine.ActiveGamemode() == "darkrp" then
		if ply != self:CPPIGetOwner() then ply:ChatPrint(TobaccoFactory.Config.Lang.orderingPCCantUseNotOwnedPC) return end
	end

	net.Start("ntf_ordering_pc")
		net.WriteEntity(self)
	net.Send(call)

end

net.Receive("ntf_ordering_pc",function(len, ply)

end)





function ENT:OnTakeDamage(dmg)
	self:TakePhysicsDamage(dmg)

	self:SetHealth(self:Health() - dmg:GetDamage())
	if self:Health() <= 0 then
		self:Remove()
	end
end
function ENT:OnRemove()
    if IsValid(self.pallet) then
			self.pallet:Remove()
		end
end
