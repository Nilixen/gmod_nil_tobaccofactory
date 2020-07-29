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

local blur = Material("pp/blurscreen")
local function DrawBlur(panel, amount)
	local x, y = panel:LocalToScreen(0, 0)
	local scrW, scrH = ScrW(), ScrH()
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(blur)
	for i = 1, 3 do
		blur:SetFloat("$blur", (i / 3) * (amount or 6))
		blur:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
	end
end

net.Receive("ntf_ordering_pc",function()
	local ent = net.ReadEntity()
	local frame = vgui.Create("DFrame")
	frame:SetSize(ScrW() * 0.6, ScrH() * 0.6)
	frame:Center()
	frame:MakePopup()
	frame:SetTitle("")
	frame:ShowCloseButton(false)
	frame.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
	    DrawBlur(frame, 5)
		draw.RoundedBox(0, 0, 0, w, h * 0.035, Color(0, 0, 0, 200))
		draw.SimpleText(TobaccoFactory.Config.Lang.OrderingPC, "ntf_vgui", w * 0.005, h * 0.005, Color(255, 255, 255, 255), 0, 0)
	end

	local ScrollPanel = vgui.Create("DScrollPanel",frame)
	ScrollPanel:SetSize(frame:GetWide()* 0.3 ,frame:GetTall() * 0.9 )
	ScrollPanel:Dock(LEFT)
	ScrollPanel.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
	end

	List = vgui.Create("DListLayout",ScrollPanel)
	List:SetSize(ScrollPanel:GetWide(),ScrollPanel:GetTall())
	List:SetPos(0,0)



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



end)
