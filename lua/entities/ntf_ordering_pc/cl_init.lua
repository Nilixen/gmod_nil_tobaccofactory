include("shared.lua")


function ENT:Initialize()
	self.c_Monitor = ClientsideModel( "models/props/cs_office/computer_monitor.mdl")
	self.c_Monitor:SetPos(self:LocalToWorld(Vector(-7,0,31)))
	self.c_Monitor:SetAngles( self:GetAngles())
	self.c_Monitor:Spawn()
	self.c_Monitor:SetParent(self)

	self.c_Keyboard = ClientsideModel( "models/props/cs_office/computer_keyboard.mdl")
	self.c_Keyboard:SetPos(self:LocalToWorld(Vector(5,-3,31)))
	self.c_Keyboard:SetAngles( self:GetAngles())
	self.c_Keyboard:Spawn()
	self.c_Keyboard:SetParent(self)

	self.c_Mouse = ClientsideModel( "models/props/cs_office/computer_mouse.mdl")
	self.c_Mouse:SetPos(self:LocalToWorld(Vector(5,14,31)))
	self.c_Mouse:SetAngles( self:GetAngles())
	self.c_Mouse:Spawn()
	self.c_Mouse:SetParent(self)


	self.a = 0

end

function ENT:Draw()
	self:DrawModel()
end

function ENT:OnRemove()
    if IsValid(self.c_Monitor) then
			self.c_Monitor:Remove()
		end
    if IsValid(self.c_Keyboard ) then
			self.c_Keyboard:Remove()
		end
    if IsValid(self.c_Mouse ) then
			self.c_Mouse:Remove()
		end

end
local blur = Material( "pp/blurscreen" )
function Blur( panel, layers, density, alpha )
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



net.Receive("ntf_ordering_pc",function()
	local ent = net.ReadEntity()
	local deltime = net.ReadInt(8)

	local frame = vgui.Create("DFrame")
	frame:SetSize(ScrW() * 0.6, ScrH() * 0.6)
	frame:Center()
	frame:MakePopup()
	frame:SetTitle("")
	frame:ShowCloseButton(false)
	frame.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 5))
		//TobaccoFactory:drawBoxCorners(0,0,w,h,15,3,1)
	end

	local closeButton = vgui.Create("DButton",frame)
	closeButton:SetSize(frame:GetWide()*0.035,frame:GetTall()*0.035)
	closeButton:SetPos(frame:GetWide()-closeButton:GetWide(),0)
	closeButton:SetText("")
	closeButton:SetFont("ntf_vgui")
	closeButton.DoClick = function()
		frame:Remove()
	end
	closeButton.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(150, 0, 0, 150))
		draw.SimpleText("X", "ntf_vgui", w / 2, h / 2, Color(255, 255, 255), 1, 1)
	end

	local selNum = 1

	local scrollPanel = vgui.Create("DScrollPanel",frame)
	scrollPanel:SetSize(frame:GetWide()* 0.3 ,frame:GetTall() * 0.9 )
	scrollPanel:Dock(LEFT)
	scrollPanel.Paint = function(s, w, h)
		Blur( s, 255, 150, 255 )
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 150))
		TobaccoFactory:drawBoxCorners(0,0,w,h,15,3,1)
	end

	local sbar = scrollPanel:GetVBar()
	sbar:SetSize(0,0)




	local list = vgui.Create("DListLayout",scrollPanel)
	list:SetSize(scrollPanel:GetWide(),scrollPanel:GetTall())
	list:SetPos(0,0)

	local selectionPanel = vgui.Create("DPanel",frame)
	selectionPanel:SetSize(frame:GetWide() * 0.7 ,frame:GetTall() * 0.7)
	selectionPanel:Dock(TOP)
	selectionPanel:DockMargin(5,0,0,0)
	selectionPanel.Paint = function( s, w, h )
		Blur( s, 255, 150, 255 )
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 150))
		TobaccoFactory:drawBoxCorners(0,0,w,h,15,3,1)
		draw.SimpleText(TobaccoFactory.Config.ShopList[selNum].name,"ntf_vgui_title",w * 0.6,h * 0.06,Color(255,255,255),1,1)
		draw.SimpleText(TobaccoFactory.Config.ShopList[selNum].description,"ntf_vgui_shoplist",w * 0.6,h * 0.12,Color(255,255,255),1,1)
		draw.SimpleText(TobaccoFactory.Config.Lang.DeliveryTime.." "..TobaccoFactory.Config.ShopList[selNum].time.." "..TobaccoFactory.Config.Lang.Seconds,"ntf_vgui_shoplist",10,h * 0.48,Color(255,255,255),0,1)

	end

	local orderPanel = vgui.Create("DPanel",frame)
	orderPanel:SetSize(frame:GetWide()*0.7, frame:GetTall()*0.225)
	orderPanel:Dock(FILL)
	orderPanel:DockMargin(5,5,0,0)
	orderPanel.Paint = function( s, w, h )
		Blur( s, 255, 150, 255 )
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 150))
		TobaccoFactory:drawBoxCorners(0,0,w,h,15,3,1)
	end

	local orderProgress = vgui.Create( "DProgress" , orderPanel)
	orderProgress:SetPos( 10, 10 )
	orderProgress:SetSize( orderPanel:GetWide() * 0.50 , orderPanel:GetTall()-20 )
	orderProgress:SetFraction( 0.6 )
	orderProgress.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 150))
		draw.RoundedBox(0, 0, 0, w*s:GetFraction(), h, Color(200, 200, 200, 150))
		if orderProgress:GetFraction() == 0 then
			draw.SimpleText(TobaccoFactory.Config.Lang.NoDelivery,"ntf_vgui_shoplist",w * 0.5,h * 0.5,Color(255,255,255),1,1)
		else
			draw.SimpleText(TobaccoFactory.Config.Lang.DeliveryInProgress,"ntf_vgui_shoplist",w * 0.5,h * 0.5,Color(255,255,255),1,1)
		end
		TobaccoFactory:drawBoxCorners(0,0,w,h,10,2,1)
	end

	local iconPanel = vgui.Create("DPanel",selectionPanel)
	iconPanel:SetSize(150, 150 )
	iconPanel:SetPos(10,10)
	iconPanel.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 30, 30, 30, 100 ) )
		TobaccoFactory:drawBoxCorners(0,0,w,h,10,2,1)
	end
	local icon = vgui.Create("DModelPanel", iconPanel)
	icon:SetSize(iconPanel:GetWide(), iconPanel:GetTall() )
	icon:SetPos(0,0)
	icon:SetModel(TobaccoFactory.Config.ShopList[selNum].model)
	icon:SetCamPos(TobaccoFactory.Config.ShopList[selNum].camPos)
	icon:SetLookAng(TobaccoFactory.Config.ShopList[selNum].camAng)




	for k,v in pairs(TobaccoFactory.Config.ShopList) do
		local shopPanel = vgui.Create("DPanel",list)
		shopPanel:SetSize(list:GetWide(),55)
		shopPanel:Dock(TOP)
		shopPanel:DockMargin(10,10,10,0)
		shopPanel.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 120 ) )
			TobaccoFactory:drawBoxCorners(0,0,w,h,10,2,1)

			draw.SimpleText(v.name,"ntf_vgui_shoplist",w * 0.03,h * 0.5,Color(255,255,255),0,1)
			if LocalPlayer():canAfford(v.price) then
				draw.SimpleText(DarkRP.formatMoney(v.price),"ntf_vgui_shoplist",w * 0.95,h * 0.5,Color(50,255,50),2,1)
			else
				draw.SimpleText(DarkRP.formatMoney(v.price),"ntf_vgui_shoplist",w * 0.95,h * 0.5,Color(255,50,50),2,1)
			end
		end
		local shopButton = vgui.Create("DButton",shopPanel)
		shopButton:SetSize(shopPanel:GetWide(), shopPanel:GetTall())
		shopButton:SetPos(0,0)
		shopButton:SetText("")
		shopButton.Paint = function()

		end
		shopButton.DoClick = function()
			selNum = k
			icon:SetModel(TobaccoFactory.Config.ShopList[selNum].model)
			icon:SetCamPos(TobaccoFactory.Config.ShopList[selNum].camPos)
			icon:SetLookAng(TobaccoFactory.Config.ShopList[selNum].camAng)
		end

	end
end)
