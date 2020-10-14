ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Cigarette boxes"
ENT.Spawnable = true
ENT.Category = "Tobacco Factory"

function ENT:SetupDataTables()
  self:NetworkVar( "Int", 0, "amount" )
end
