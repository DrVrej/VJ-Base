if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end

ENT.Base 			= "base_ai"
ENT.Type 			= "ai"
ENT.PrintName 		= "VJ Test NPC"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Just a testing NPC."
ENT.Instructions 	= "Don't change anything."
ENT.Category		= "VJ Base"

ENT.Spawnable = false
ENT.AdminOnly = false
ENT.AutomaticFrameAdvance = true

function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim
end

if CLIENT then
	function ENT:Draw() self:DrawModel() end
	
	net.Receive("vj_testentity_onmenuopen", function()
		local welMsgs = {
			"Welcome to my shop, how can I help you?",
			"Hi!",
			"Hello "..LocalPlayer():GetName()..", You need anything?",
			"What can I do for you "..LocalPlayer():GetName().."?",
			"This ain't cheap stuff, but it is good!",
		}
	
		local frame = vgui.Create("DFrame")
		frame:SetSize(600, 300)
		frame:SetPos(ScrW()*0.5, ScrH()*0.5)
		frame:SetTitle('VJ Test Menu')
		//frame:SetBackgroundBlur(true)
		frame:SetSizable(true)
		frame:SetDeleteOnClose(false)
		frame:MakePopup()

		local label_wel = vgui.Create("DLabel", frame)
		label_wel:SetPos(10, 30)
		label_wel:SetText(VJ_PICK(welMsgs))
		label_wel:SizeToContents()
		
		local button_kill = vgui.Create("DButton", frame)
		button_kill:SetText("Kill Yourself")
		button_kill:SetPos(10, 50)
		button_kill:SetSize(100, 50)
		button_kill.DoClick = function()
			RunConsoleCommand("kill")
			LocalPlayer():EmitSound(Sound("vj_misc/illuminati_confirmed.mp3"), 0, 200)
		end
		
		local label_admin = vgui.Create("DLabel", frame)
		label_admin:SetPos(10, 110)
		label_admin:SetText("NOTE: Only admins can use these buttons! Most of this commands require 'sv_cheats' to be 1")
		label_admin:SizeToContents()
		
		local button_god = vgui.Create("DButton", frame)
		button_god:SetText("Toggle God Mode")
		button_god:SetPos(10, 130)
		button_god:SetSize(100, 50)
		button_god.DoClick = function()
			if LocalPlayer():IsAdmin() then RunConsoleCommand("god") end
		end
		
		local button_buddha = vgui.Create("DButton", frame)
		button_buddha:SetText("Toggle Buddha")
		button_buddha:SetPos(120, 130)
		button_buddha:SetSize(100, 50)
		button_buddha.DoClick = function()
			if LocalPlayer():IsAdmin() then RunConsoleCommand("buddha") end
		end
		
		local button_fp = vgui.Create("DButton", frame)
		button_fp:SetText("Firstperson")
		button_fp:SetPos(230, 130)
		button_fp:SetSize(100, 50)
		button_fp.DoClick = function()
			if LocalPlayer():IsAdmin() then RunConsoleCommand("firstperson") end
		end
		
		local button_tp = vgui.Create("DButton", frame)
		button_tp:SetText("Thirdperson")
		button_tp:SetPos(340, 130)
		button_tp:SetSize(100, 50)
		button_tp.DoClick = function()
			if LocalPlayer():IsAdmin() then RunConsoleCommand("thirdperson") end
		end
		
		if LocalPlayer():SteamID() == "STEAM_0:0:22688298" then
			local button_vj = vgui.Create("DButton", frame)
			button_vj:SetText("Illuminati")
			button_vj:SetPos(10, 170)
			button_vj:SetSize(50, 30)
			button_vj.DoClick = function()
				net.Start("vj_testentity_runtextsd")
				net.WriteBool(false)
				net.SendToServer()
			end
			
			local button_sd = vgui.Create("DButton", frame)
			button_sd:SetText("THIRSTY")
			button_sd:SetPos(120, 170 )
			button_sd:SetSize(50, 30)
			button_sd.DoClick = function()
				net.Start("vj_testentity_runtextsd")
				net.WriteBool(true)
				net.SendToServer()
			end
		end
	end)
end