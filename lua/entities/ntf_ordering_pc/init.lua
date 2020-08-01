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

	self.svlgc = 0
	self.selNum = 1
	self.orderTime = 0
end

function ENT:Think()

	self.svlgc = ((CurTime()-self.orderTime) / TobaccoFactory.Config.ShopList[self.selNum].time)
	print(self.svlgc)   // FIX PLS
	if self.svlgc >= 1 then
		entity = ents.Create(TobaccoFactory.Config.ShopList[self.selNum].class)
		entity:SetModel(TobaccoFactory.Config.ShopList[self.selNum].model)
		entity:Spawn()
		entity:SetPos(self:LocalToWorld(self:GetPos()+Vector(0,50,0)))
		entity:SetAngles(self:GetAngles())
	end
end

function ENT:Use(ply, call)
	if ply != self:CPPIGetOwner() then ply:ChatPrint(TobaccoFactory.Config.Lang.CantUseThatPC) return end

	net.Start("ntf_ordering_pc")
		net.WriteEntity(self)
	net.Send(call)

end

net.Receive("ntf_ordering_pc",function(len, ply)
	local ent = net.ReadEntity()
	local orderTime = net.ReadInt(8)
	local selNum = net.ReadInt(8)
	ply:addMoney(-TobaccoFactory.Config.ShopList[selNum].price)
	ent.orderTime = orderTime
	ent.selNum = selNum
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
