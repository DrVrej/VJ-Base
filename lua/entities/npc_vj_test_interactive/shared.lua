ENT.Base 			= "npc_vj_human_base"
ENT.Type 			= "ai"
ENT.PrintName 		= "Interactive NPC"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Information 	= "Interactive human NPC demo for developers.\nPress USE on it to open the menu!"
ENT.Category		= "VJ Base"

ENT.VJ_ID_Civilian = true
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MatFootStepQCEvent(data)
	return
end
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	net.Receive("vj_npc_testint_menu", function()
		local welMsgs = {
			"Hi!",
			"Welcome to my shop, how can I help you?",
			"Hello " .. LocalPlayer():GetName() .. ", You need anything?",
			"What can I do for you " .. LocalPlayer():GetName() .. "?",
			"This ain't cheap stuff, but it is good!",
		}
	
		local frame = vgui.Create("DFrame")
		frame:SetSize(450, 210)
		frame:SetPos(ScrW() * 0.5, ScrH() * 0.5)
		frame:SetTitle("VJ Test Menu")
		//frame:SetBackgroundBlur(true)
		frame:SetSizable(true)
		frame:SetDeleteOnClose(false)
		frame:MakePopup()

		local label_wel = vgui.Create("DLabel", frame)
		label_wel:SetPos(10, 30)
		label_wel:SetText(VJ.PICK(welMsgs))
		label_wel:SizeToContents()
		
		local button_kill = vgui.Create("DButton", frame)
		button_kill:SetText("Kill Yourself")
		button_kill:SetPos(10, 50)
		button_kill:SetSize(100, 50)
		button_kill.DoClick = function()
			RunConsoleCommand("kill")
			LocalPlayer():EmitSound("vj_base/player/illuminati.mp3", 0, 200)
		end
		
		local label_admin = vgui.Create("DLabel", frame)
		label_admin:SetPos(10, 110)
		label_admin:SetText("Only admins can use the buttons below and they require require \"sv_cheats\" to be on!")
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
			button_vj:SetSize(100, 30)
			button_vj:SetConsoleCommand("vj_run_meme", "0")
			
			local button_sd = vgui.Create("DButton", frame)
			button_sd:SetText("THIRSTY")
			button_sd:SetPos(120, 170 )
			button_sd:SetSize(100, 30)
			button_sd:SetConsoleCommand("vj_run_meme", "1")
		end
	end)
end