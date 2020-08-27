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

	self.orderTime = 0
	self.deliveryTime = 0

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



net.Receive("ntf_ordering_pc",function()
	local ent = net.ReadEntity()
	local limittable = net.ReadTable()
	local orderTime

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
	closeButton:SetSize(frame:GetWide()*0.040,frame:GetWide()*0.040)
	closeButton:SetPos(frame:GetWide()-frame:GetWide()*0.040-4.5,0)
	closeButton:SetText("")
	closeButton:SetFont("ntf_vgui")
	closeButton.DoClick = function()
		frame:Remove()
	end
	closeButton.Paint = function(s, w, h)
		TobaccoFactory:Blur( s, 255, 150, 255 )
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 150))
		TobaccoFactory:drawBoxCorners(0,0,w,h,10,3,1)
		draw.SimpleText("X", "ntf_vgui_title", w / 2, h / 2, Color(255, 255, 255), 1, 1)
	end

	local selNum = 1

	local scrollPanel = vgui.Create("DScrollPanel",frame)
	scrollPanel:SetSize(frame:GetWide()* 0.3 ,frame:GetTall() * 0.9 )
	scrollPanel:DockMargin(0,15,0,0)
	scrollPanel:Dock(LEFT)
	scrollPanel.Paint = function(s, w, h)
		TobaccoFactory:Blur( s, 255, 150, 255 )
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
	selectionPanel:DockMargin(5,15,0,0)
	selectionPanel:Dock(TOP)
	selectionPanel.Paint = function( s, w, h )
		TobaccoFactory:Blur( s, 255, 150, 255 )
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
		TobaccoFactory:Blur( s, 255, 150, 255 )
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 150))
		TobaccoFactory:drawBoxCorners(0,0,w,h,15,3,1)
	end

	local orderProgress = vgui.Create( "DProgress" , orderPanel)
	orderProgress:Dock(LEFT)
	orderProgress:DockMargin(10,10,5,10)
	orderProgress:SetSize( orderPanel:GetWide() * 0.50 , orderPanel:GetTall()-20 )
	orderProgress:SetFraction( 0 )
	orderProgress.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 150))
		draw.RoundedBox(0, 0, 0, w*s:GetFraction(), h, Color(200, 200, 200, 150))
		if orderProgress:GetFraction() == 0 then
			draw.SimpleText(TobaccoFactory.Config.Lang.NoDelivery,"ntf_vgui_shoplist",w * 0.5,h * 0.5,Color(255,255,255),1,1)
		else
			draw.SimpleText(TobaccoFactory.Config.Lang.DeliveryInProgress,"ntf_vgui_shoplist",w * 0.5,h * 0.5,Color(255,255,255),1,1)
		end
		TobaccoFactory:drawBoxCorners(0,0,w,h,10,2,1)
		if ent.orderTime > 0 and ent.deliveryTime > 0 then
			orderProgress:SetFraction( (CurTime()-ent.orderTime) /(ent.deliveryTime) )
		end
		if orderProgress:GetFraction() >= 1 then
			ent.orderTime = 0
			ent.deliveryTime = 0
			orderProgress:SetFraction( 0 )
			table.insert(limittable,TobaccoFactory.Config.ShopList[selNum].class)
		end
	end

	local orderCancelButton = vgui.Create("DButton",orderPanel)
	orderCancelButton:Dock(FILL)
	orderCancelButton:DockMargin(5,10,10,10)
	orderCancelButton:SetText("")
	orderCancelButton.Paint = function(s, w, h)

		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 150))
		if orderProgress:GetFraction() > 0 then
			draw.RoundedBox(0, 0, 0, w, h, Color(75, 0, 0, 150))
			draw.SimpleText(TobaccoFactory.Config.Lang.Cancel,"ntf_vgui_title",w * 0.5,h * 0.45,Color(255,255,255),1,1)
			draw.SimpleText(TobaccoFactory.Config.Lang.NoRefunds,"ntf_vgui_shoplist",w * 0.5,h * 0.65,Color(255,255,255),1,1)
		elseif orderProgress:GetFraction() == 0 and TobaccoFactory:HasValueInt(limittable,TobaccoFactory.Config.ShopList[selNum].class) >= TobaccoFactory.Config.ShopList[selNum].limit then
			draw.RoundedBox(0, 0, 0, w, h, Color(75, 0, 0, 150))
			draw.SimpleText(TobaccoFactory.Config.Lang.ReachedLimit,"ntf_vgui_title",w * 0.5,h * 0.5,Color(255,255,255),1,1)
		elseif orderProgress:GetFraction() == 0 and LocalPlayer():canAfford(TobaccoFactory.Config.ShopList[selNum].price) then
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 75, 0, 150))
			draw.SimpleText(TobaccoFactory.Config.Lang.Order,"ntf_vgui_title",w * 0.5,h * 0.5,Color(255,255,255),1,1)
		elseif orderProgress:GetFraction() == 0 and !LocalPlayer():canAfford(TobaccoFactory.Config.ShopList[selNum].price) then
			draw.RoundedBox(0, 0, 0, w, h, Color(75, 0, 0, 150))
			draw.SimpleText(TobaccoFactory.Config.Lang.CantOrder,"ntf_vgui_title",w * 0.5,h * 0.5,Color(255,255,255),1,1)
		end
		TobaccoFactory:drawBoxCorners(0,0,w,h,10,2,1)
	end
	orderCancelButton.DoClick = function()
		if orderProgress:GetFraction() == 0 and LocalPlayer():canAfford(TobaccoFactory.Config.ShopList[selNum].price) and TobaccoFactory:HasValueInt(limittable,TobaccoFactory.Config.ShopList[selNum].class) < TobaccoFactory.Config.ShopList[selNum].limit then
			orderTime = CurTime()
			ent.deliveryTime = TobaccoFactory.Config.ShopList[selNum].time
			ent.orderTime = orderTime

			net.Start("ntf_ordering_pc")
				net.WriteString("order")
				net.WriteEntity(ent)
				net.WriteInt(selNum,8)
			net.SendToServer()

		elseif orderProgress:GetFraction() == 0 and !LocalPlayer():canAfford(TobaccoFactory.Config.ShopList[selNum].price) then
		elseif orderProgress:GetFraction() > 0 then
			ent.orderTime = 0
			ent.deliveryTime = 0
			print(ent.orderTime)
			print(ent.deliveryTime)
			orderProgress:SetFraction( 0 )
			net.Start("ntf_ordering_pc")
				net.WriteString("cancel")
				net.WriteEntity(ent)
			net.SendToServer()
		end
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
	icon:SetColor(TobaccoFactory.Config.ShopList[selNum].customColor)



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
			icon:SetColor(TobaccoFactory.Config.ShopList[selNum].customColor)
		end

	end
end)
