function TobaccoFactory:drawBoxCorners(x,y,w,h,size,width,linewidth,fade)
	//top left
	draw.RoundedBox(0,x+width,y,size-width,width,Color(255,255,255,fade or 255))
	draw.RoundedBox(0,x,y,width,size,Color(255,255,255,fade or 255))
	//top right
	draw.RoundedBox(0,x+w-size,y,size-width,width,Color(255,255,255,fade or 255))
	draw.RoundedBox(0,x+w-width,y,width,size,Color(255,255,255,fade or 255))
	//down left
	draw.RoundedBox(0,x+width,y+h-width,size-width,width,Color(255,255,255,fade or 255))
	draw.RoundedBox(0,x,y+h-size,width,size,Color(255,255,255,fade or 255))
	//down right
	draw.RoundedBox(0,x+w-size,y+h-width,size-width,width,Color(255,255,255,fade or 255))
	draw.RoundedBox(0,x+w-width,y+h-size,width,size,Color(255,255,255,fade or 255))

	// left line
	draw.RoundedBox(0,x,y+size,linewidth,h-(size*2),Color(255,255,255,fade or 255))
	// right line
	draw.RoundedBox(0,x+w-linewidth,y+size,linewidth,h-(size*2),Color(255,255,255,fade or 255))
	// top line
	draw.RoundedBox(0,x+size,y,w-(size*2),linewidth,Color(255,255,255,fade or 255))
	// down line
	draw.RoundedBox(0,x+size,y+h-linewidth,w-(size*2),linewidth,Color(255,255,255,fade or 255))
end

local blur = Material( "pp/blurscreen" )
function TobaccoFactory:Blur( panel, layers, density, alpha )
	-- Its a scientifically proven fact that blur improves a script
	local x, y = panel:LocalToScreen(0, 0)

	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetMaterial( blur )

	for i = 1, 3 do
		blur:SetFloat( "$blur", ( i / layers ) * density )
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect( -x, -y, ScrW(), ScrH() )
	end
end
local color = 1
hook.Add( "PreDrawHalos", "ntf_ordering_pc_halo", function()
	local ents = ents.FindByClass( "ntf_ordering_pc" )
	local p = {}
	for k,v in pairs(ents) do
		p[k] = ents[k].c_Box
	end
	frequency = 1
	color = color + 1
	halo.Add(	p, HSVToColor( color * frequency % 360, 1, 1 ), 5, 5, 2 )
end )
