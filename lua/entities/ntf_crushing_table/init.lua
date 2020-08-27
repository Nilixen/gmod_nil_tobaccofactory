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

	self.filledSlots = {}

	self.Taps = 0

	self.slots = {
		{
		pos = Vector(7, -27, 39),
		ang = Angle(0, 345, 0)
		},
		{
		pos = Vector(-5, -21, 39),
		ang = Angle(0, 325, 0)
		},
		{
		pos = Vector(0, -24, 47),
		ang = Angle(0, 330, 0)
		},
	}

	self.Sounds = {
		"physics/plaster/ceiling_tile_impact_hard1.wav",
		"physics/plaster/ceiling_tile_impact_hard2.wav",
		"physics/plaster/ceiling_tile_impact_hard3.wav",
	}
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
			for k,v in pairs(ent.filledSlots) do
				if IsValid(v) then
					v:Remove()
				end
			end
			local tobacco = ents.Create("ntf_tobacco")
			tobacco:SetPos(ent:LocalToWorld(ent.slots[1].pos+Vector(-5,0,1.2)))
			tobacco:SetAngles(ent:LocalToWorldAngles(ent.slots[1].ang+Angle(0,320,0)))
			tobacco:Spawn()
			tobacco:SetParent(ent)
			tobacco.parent = ent
			ent.filledSlots[1] = tobacco
			local a = {}
			for k,v in pairs(ent.filledSlots) do
				if IsValid(v) then
					a[k] = v:GetClass()
				end
			end
			ent:SetfilledSlots(util.TableToJSON(a))

		end
	end

end)

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
	if ent:GetClass() != "ntf_leaves_box" then return end
	if IsValid(self.filledSlots[1]) then
		if self.filledSlots[1]:GetClass() == "ntf_tobacco" then return end
	end
	if self:GetOpenSlots() <= 0 then return end

	local num = self:FirstAvaibleSlot()

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
	if ent:GetClass() != "ntf_tobacco" then return end
	local pos = (self.slots[1].pos + Vector(35, 0, 0) or self:GetPos()+Vector(35, 0, 0))
	local ang = self.slots[1].ang

	ent.parent = nil
	ent:SetParent()
	ent:SetPos(self:LocalToWorld(pos))
	self.filledSlots = {}
	self:SetfilledSlots(util.TableToJSON(self.filledSlots))

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
