ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "[SMALL] Leaves Box"
ENT.Spawnable = false
ENT.Category = "N-Tobacco"

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "State" )
end
