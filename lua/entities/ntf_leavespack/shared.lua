ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Leaves Box"
ENT.Spawnable = true
ENT.Category = "Tobacco Factory"

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "Boxes" )
end
