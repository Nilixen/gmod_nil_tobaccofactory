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
	self.selNum = 0
	self.orderTime = 0
	self.owner = self:CPPIGetOwner()
	self.owner.ntfent = {}
end



function ENT:Think()
	if self.selNum > 0 then
		self.svlgc = ((CurTime()-self.orderTime) / TobaccoFactory.Config.ShopList[self.selNum].time)
		if self.svlgc >= 1 then
			entity = ents.Create(TobaccoFactory.Config.ShopList[self.selNum].class)
			entity:SetModel(TobaccoFactory.Config.ShopList[self.selNum].model)
			entity:Spawn()
			entity:SetPos(self:LocalToWorld(Vector(0,70,10)))
			entity:SetAngles(self:GetAngles())
			TobaccoFactory.Config.ShopList[self.selNum].fnc(entity)
			entity:CPPISetOwner(self.owner)
			self.owner.ntfent[table.Count(self.owner.ntfent)+1] = entity
			self.svlgc = 0
			self.selNum = 0
			self.orderTime = 0
		end
	end
end

function ENT:Use(ply, call)
	if ply != self.owner then ply:ChatPrint(TobaccoFactory.Config.Lang.CantUseThatPC) return end

	net.Start("ntf_ordering_pc")
		net.WriteEntity(self)
		net.WriteTable(self.owner.ntfent)
	net.Send(call)

end

net.Receive("ntf_ordering_pc",function(len, ply)
	local str = net.ReadString()
	if str == "order" then
		local ent = net.ReadEntity()
		local selNum = net.ReadInt(8)

		if TobaccoFactory:HasValueInt(ply.ntfent,TobaccoFactory.Config.ShopList[selNum].class) < TobaccoFactory.Config.ShopList[selNum].limit then
			ply:addMoney(-TobaccoFactory.Config.ShopList[selNum].price)
			ent.orderTime = CurTime()
			ent.selNum = selNum
		else
			ply:ChatPrint(TobaccoFactory.Config.Lang.YouHaveReachedTheLimit.." "..TobaccoFactory.Config.ShopList[selNum].name)
		end
	elseif str == "cancel" then
		local ent = net.ReadEntity()
		ent.svlgc = 0
		ent.selNum = 0
		ent.orderTime = 0
	end
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
