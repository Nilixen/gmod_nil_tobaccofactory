ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Ordering PC"
ENT.Spawnable = true
ENT.Category = "Tobacco Factory"

function TobaccoFactory:HasValueInt(tab,data)
	local a = 0
	for k,v in pairs(tab) do
    if isstring(v) then
      if v == data then
        a = a +1
      end
    else
  		if IsValid(v) then
  			if v:GetClass() == data then
  				a = a +1
        end
  		end
    end
	end
  
	return a
end
