if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
include('shared.lua')
/*--------------------------------------------------
	=============== Test Entity ===============
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to Test Things
--------------------------------------------------*/
ENT.RenderGroup = RENDERGROUP_BOTH
function ENT:Draw() self:DrawModel() end

usermessage.Hook("vj_testentity_onmenuopen",function()
	local welmsg = {}
	welmsg[1] = "Welcome to my shop, how can I help you?"
	welmsg[2] = "Hi!"
	welmsg[3] = "Hello "..LocalPlayer():GetName()..", You need anything?"
	welmsg[4] = "What can I do for you "..LocalPlayer():GetName().."?"
	welmsg[5] = "This ain't cheap stuff, but it is good!"

	local Frame = vgui.Create("DFrame")
	Frame:SetSize(600, 300)
	Frame:SetPos(ScrW()*0.5, ScrH()*0.5)
	Frame:SetTitle('VJ Test Menu')
	//Frame:SetBackgroundBlur(true)
	Frame:SetSizable(true)
	Frame:SetDeleteOnClose(false)
	Frame:MakePopup()

	local label = vgui.Create("DLabel", Frame)
	label:SetPos(10, 30)
	label:SetText(table.Random(welmsg))
	label:SizeToContents()
	
	local button = vgui.Create("DButton", Frame)
	button:SetText("Kill Yourself")
	button:SetPos(10, 50)
	button:SetSize(100, 50)
	button.DoClick = function()
		RunConsoleCommand("kill")
		//surface.PlaySound(Sound("vj_illuminati/Illuminati Confirmed.mp3"))
		LocalPlayer():EmitSound(Sound("vj_illuminati/Illuminati Confirmed.mp3"),0,200)
	end
	
	local label = vgui.Create("DLabel", Frame)
	label:SetPos(10, 110)
	label:SetText("NOTE: Only admins can use these buttons! Most of this commands require 'sv_cheats' to be 1")
	label:SizeToContents()
	
	local button2 = vgui.Create("DButton", Frame)
	button2:SetText( "Toggle God Mode" )
	button2:SetPos(10, 130)
	button2:SetSize(100, 50)
	button2.DoClick = function()
		if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then RunConsoleCommand("god") end
	end
	
	local button3 = vgui.Create("DButton", Frame)
	button3:SetText("Toggle Buddha")
	button3:SetPos(120, 130)
	button3:SetSize(100, 50)
	button3.DoClick = function()
		if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then RunConsoleCommand("buddha") end
	end
	
	local button4 = vgui.Create("DButton", Frame)
	button4:SetText("Firstperson")
	button4:SetPos(230, 130)
	button4:SetSize(100, 50)
	button4.DoClick = function()
		if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then RunConsoleCommand("firstperson") end
	end
	
	local button5 = vgui.Create("DButton", Frame)
	button5:SetText("Thirdperson")
	button5:SetPos(340, 130)
	button5:SetSize(100, 50)
	button5.DoClick = function()
		if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then RunConsoleCommand("thirdperson") end
	end
	
	if LocalPlayer():SteamID() == "STEAM_0:0:22688298" then
		local button_DrVrej1 = vgui.Create("DButton", Frame)
		button_DrVrej1:SetText("Illuminati")
		button_DrVrej1:SetPos(10, 170)
		button_DrVrej1:SetSize(50, 30)
		button_DrVrej1.DoClick = function()
			net.Start("vj_testentity_runtextsd")
			net.WriteEntity(LocalPlayer())
			net.WriteString("DrVrej is in this server, be aware!")
			net.WriteString("vj_illuminati/Illuminati Confirmed.mp3")
			net.SendToServer()
		end
		local button_DrVrej2 = vgui.Create("DButton", Frame)
		button_DrVrej2:SetText("THIRSTY")
		button_DrVrej2:SetPos(120, 170 )
		button_DrVrej2:SetSize(50, 30)
		button_DrVrej2.DoClick = function()
			net.Start("vj_testentity_runtextsd")
			net.WriteEntity(LocalPlayer())
			net.WriteString("Are you thirsty?")
			net.WriteString("vj_illuminati/areyouthristy.wav")
			net.SendToServer()
		end
	end
end)