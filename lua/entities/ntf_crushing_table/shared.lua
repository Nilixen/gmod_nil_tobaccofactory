ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Crushing table"
ENT.Spawnable = true
ENT.Category = "Tobacco Factory"

function ENT:SetupDataTables()
	self:NetworkVar( "Entity", 0, "Childs" )

end