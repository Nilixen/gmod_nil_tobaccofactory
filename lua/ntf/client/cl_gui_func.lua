function TobaccoFactory:drawBoxCorners(x,y,w,h,fade)
	//top left
	draw.RoundedBox(0,x+10,y,40,10,Color(255,255,255,fade or 255))
	draw.RoundedBox(0,x,y,10,50,Color(255,255,255,fade or 255))
	//top right
	draw.RoundedBox(0,x+w-50,y,40,10,Color(255,255,255,fade or 255))
	draw.RoundedBox(0,x+w-10,y,10,50,Color(255,255,255,fade or 255))
	//down left
	draw.RoundedBox(0,x+10,y+h-10,40,10,Color(255,255,255,fade or 255))
	draw.RoundedBox(0,x,y+h-50,10,50,Color(255,255,255,fade or 255))
	//down right
	draw.RoundedBox(0,x+w-50,y+h-10,40,10,Color(255,255,255,fade or 255))
	draw.RoundedBox(0,x+w-10,y+h-50,10,50,Color(255,255,255,fade or 255))
end
