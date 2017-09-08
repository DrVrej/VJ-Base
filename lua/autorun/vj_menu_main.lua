/*--------------------------------------------------
	=============== Main Menu ===============
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to load the main menu for VJ Base
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
-- Console Commands ---------------------------------------------------------------------------------------------------------------------------------------------
concommand.Add("vj_cleanup_all",function(ply)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		game.CleanUpMap()
		if (SERVER) then ply:SendLua("GAMEMODE:AddNotify(\"Cleaned Up Everything!\", NOTIFY_CLEANUP, 5)") end
		ply:EmitSound("buttons/button15.wav")
	end
end)
----=================================----
concommand.Add("vj_cleanup_snpcscorpse",function(ply)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		local i = 0
		for k, v in pairs(ents.GetAll()) do
			if v.IsVJBaseCorpse == true or v.IsVJBase_Gib == true or v:GetClass() == "obj_vj_gib_*" then
				undo.ReplaceEntity(v,nil)
				v:Remove()
				i = i + 1
				/*local cleandatsnpc = ents.GetAll()
				for _, x in pairs(cleandatsnpc) do
					if v:IsNPC() && v:IsValid() && v.IsVJBaseSNPC == true then
					x.VJCorpseDeleted = true
					//if x:IsValid() then x.Corpse = ents.Create(x.DeathCorpseEntityClass)
					end
				end*/
			end
		end
		if (SERVER) then ply:SendLua("GAMEMODE:AddNotify(\"Removed "..i.." Corpses\", NOTIFY_CLEANUP, 5)") end
		ply:EmitSound("buttons/button15.wav")
	end
end)
----=================================----
concommand.Add("vj_cleanup_snpcs",function(ply)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		local i = 0
		for k, v in pairs(ents.GetAll()) do
			if v:IsNPC() && v:IsValid() && v.IsVJBaseSNPC == true then
				// if v:ValidEntity() then
				undo.ReplaceEntity(v,nil)
				v:Remove()
				i = i + 1
			end            
		end
		if (SERVER) then ply:SendLua("GAMEMODE:AddNotify(\"Removed "..i.." SNPCs\", NOTIFY_CLEANUP, 5)") end
		ply:EmitSound("buttons/button15.wav")
		//ply:ChatPrint("Removed "..i.." SNPCs")
	end
end)
----=================================----
concommand.Add("vj_cleanup_s_npcs", function(ply)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		local i = 0
		for k, v in pairs(ents.GetAll()) do
			if v:IsNPC() /* v:ValidEntity() */then
				undo.ReplaceEntity(v,nil)
				v:Remove()
				i = i + 1
			end            
		end
		if (SERVER) then ply:SendLua("GAMEMODE:AddNotify(\"Removed "..i.." (S)NPCs\", NOTIFY_CLEANUP, 5)") end
		ply:EmitSound("buttons/button15.wav")
		//ply:ChatPrint("Removed "..i.." SNPCs")
	end
end)
----=================================----
concommand.Add("vj_cleanup_decals", function(ply)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		for k, v in pairs(player.GetAll()) do
			v:ConCommand("r_cleardecals")        
		end
		if (SERVER) then ply:SendLua("GAMEMODE:AddNotify(\"Removed All Decals\", NOTIFY_CLEANUP, 5)") end
		ply:EmitSound("buttons/button15.wav")
	end
end)
----=================================----
concommand.Add("vj_cleanup_playerammo", function(ply)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		ply:RemoveAllAmmo()
		if (SERVER) then ply:SendLua("GAMEMODE:AddNotify(\"Removed All Your Ammo\", NOTIFY_CLEANUP, 5)") end
		ply:EmitSound("buttons/button15.wav")
	end
end)
----=================================----
concommand.Add("vj_cleanup_playerweapon", function(ply)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		ply:StripWeapons()
		if (SERVER) then ply:SendLua("GAMEMODE:AddNotify(\"Removed All Your Weapons\", NOTIFY_CLEANUP, 5)") end
		ply:EmitSound("buttons/button15.wav")
	end
end)
----=================================----
concommand.Add("vj_cleanup_vjgibs", function(ply)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		local i = 0
		for k, v in pairs(ents.GetAll()) do
			if v.IsVJBase_Gib == true or v:GetClass() == "obj_vj_gib" then
				undo.ReplaceEntity(v,nil)
				v:Remove()
				i = i + 1
			end
		end
		if (SERVER) then ply:SendLua("GAMEMODE:AddNotify(\"Removed "..i.." Gibs\", NOTIFY_CLEANUP, 5)") end
		ply:EmitSound("buttons/button15.wav")
	end
end)
----=================================----
concommand.Add("vj_cleanup_props", function(ply)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		local i = 0
		for k, v in pairs(ents.FindByClass("prop_physics")) do
			if v:GetParent() == NULL or (IsValid(v:GetParent()) && v:GetParent():Health() <= 0 && (v:GetParent():IsNPC() or v:GetParent():IsPlayer())) then
				undo.ReplaceEntity(v,nil)
				v:Remove()
				i = i + 1
			end
		end
		if (SERVER) then ply:SendLua("GAMEMODE:AddNotify(\"Removed "..i.." Props\", NOTIFY_CLEANUP, 5)") end
		ply:EmitSound("buttons/button15.wav")
	end
end)
----=================================----
concommand.Add("vj_cleanup_groundweapons", function(ply)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		local i = 0
		for k, v in pairs(ents.GetAll()) do
			if v:IsValid() && v:IsWeapon() && v:GetOwner() == NULL then
				undo.ReplaceEntity(v,nil)
				v:Remove()
				i = i + 1
			end
		end
		if (SERVER) then ply:SendLua("GAMEMODE:AddNotify(\"Removed "..i.." Ground Weapons\", NOTIFY_CLEANUP, 5)") end
		ply:EmitSound("buttons/button15.wav")
	end
end)
----=================================----
concommand.Add("vj_cleanup_spawners", function(ply)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		local i = 0
		for k, v in pairs(ents.GetAll()) do
			if v.IsVJBaseSpawner == true then
				undo.ReplaceEntity(v,nil)
				v:Remove()
				i = i + 1
			end
		end
		if (SERVER) then ply:SendLua("GAMEMODE:AddNotify(\"Removed "..i.." Spawners\", NOTIFY_CLEANUP, 5)") end
		ply:EmitSound("buttons/button15.wav")
	end
end)
-- Main Menu ---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
	local function VJ_MAINMENU_CLEANUP(Panel)
		if !game.SinglePlayer() then
		if !LocalPlayer():IsAdmin() or !LocalPlayer():IsSuperAdmin() then
			Panel:AddControl( "Label", {Text = "You are not a admin!"})
			Panel:ControlHelp("Notice: Only admins can use the clean up buttons.")
			return
			end
		end
		Panel:ControlHelp(" ") -- Spacer
		Panel:ControlHelp("Notice: Only admins can use the clean up buttons.")
		Panel:AddControl("Button", {Label = "Clean Up Everything", Command = "vj_cleanup_all"})
		Panel:AddControl("Button", {Label = "Stop all Sounds", Command = "stopsound"})
		Panel:AddControl("Button", {Label = "Remove all VJ SNPCs", Command = "vj_cleanup_snpcs"})
		Panel:AddControl("Button", {Label = "Remove all (S)NPCs", Command = "vj_cleanup_s_npcs"})
		Panel:AddControl("Button", {Label = "Remove all Spawners", Command = "vj_cleanup_spawners"})
		Panel:AddControl("Button", {Label = "Remove all Corpses", Command = "vj_cleanup_snpcscorpse"})
		Panel:AddControl("Button", {Label = "Remove all VJ Gibs", Command = "vj_cleanup_vjgibs"})
		Panel:AddControl("Button", {Label = "Remove all Ground Weapons", Command = "vj_cleanup_groundweapons"})
		Panel:AddControl("Button", {Label = "Remove all Props", Command = "vj_cleanup_props"})
		Panel:AddControl("Button", {Label = "Remove all Decals", Command = "vj_cleanup_decals"})
		Panel:AddControl("Button", {Label = "Remove all of your Weapons", Command = "vj_cleanup_playerweapon"})
		Panel:AddControl("Button", {Label = "Remove all of your Ammo", Command = "vj_cleanup_playerammo"})
	end
	----=================================----
	local function VJ_MAINMENU_MISC(Panel)
		local bugr = vgui.Create("DButton") -- Bug Report
		bugr:SetFont("CloseCaption_Bold")
		bugr:SetText("Report a Bug")
		bugr:SetSize(150, 35)
		bugr:SetColor(Color(255,0,0,255))
		bugr.DoClick = function(bugr)
			gui.OpenURL("http://steamcommunity.com/groups/vrejgaming/discussions/2/")
			// http://docs.google.com/forms/d/1ZS1rSFtY4j6hJMZ_eGktYoBGScuW0GZdX4gjEJpBjjU/viewform?pli=1
		end
		Panel:AddPanel(bugr)
		
		local suggest = vgui.Create("DButton") -- Suggestions
		suggest:SetFont("DermaDefaultBold")
		suggest:SetText("Suggest Something")
		suggest:SetSize(150, 20)
		suggest:SetColor(Color(0,0,255,200))
		suggest.DoClick = function(suggest)
			gui.OpenURL("http://steamcommunity.com/groups/vrejgaming/discussions/1/")
			// http://docs.google.com/forms/d/1dMj6NWEmIpP7JYRxETZtKAl_aSQ6NUY4Fp3Ci2Olc2o/viewform?pli=1
		end
		Panel:AddPanel(suggest)
		
		Panel:ControlHelp(" ") -- Spacer
		
		Panel:AddControl("Label", {Text = "Follow/subscribe/like/join one of this links to get updates about my addons!"})
		Panel:ControlHelp("Thanks for your support!")
		
		local steaml = vgui.Create("DButton") -- Steam Group
		steaml:SetFont("TargetID")
		steaml:SetText("Join my Steam Group!")
		steaml:SetSize(150, 25)
		steaml:SetColor(Color(76,153,0,255))
		steaml.DoClick = function(steaml)
			gui.OpenURL("http://steamcommunity.com/groups/vrejgaming")
		end
		Panel:AddPanel(steaml)
		
		local ytl = vgui.Create("DButton") -- YouTube
		ytl:SetFont("TargetID")
		ytl:SetText("Subscribe my YouTube Channel!")
		ytl:SetSize(150, 25)
		ytl:SetColor(Color(76,153,0,255))
		ytl.DoClick = function(ytl)
			gui.OpenURL("http://www.youtube.com/user/gmod95")
		end
		Panel:AddPanel(ytl)
		
		local fbl = vgui.Create("DButton") -- Facebook
		fbl:SetFont("TargetID")
		fbl:SetText("Like my Facebook Page!")
		fbl:SetSize(150, 25)
		fbl:SetColor(Color(76,153,0,255))
		fbl.DoClick = function(fbl)
			gui.OpenURL("http://www.facebook.com/VrejGaming")
		end
		Panel:AddPanel(fbl)

		local tweetl = vgui.Create("DButton") -- Twitter
		tweetl:SetFont("TargetID")
		tweetl:SetText("Follow my Twitter Page!")
		tweetl:SetSize(150, 25)
		tweetl:SetColor(Color(76,153,0,255))
		tweetl.DoClick = function(tweetl)
			gui.OpenURL("http://twitter.com/vrejgaming")
		end
		Panel:AddPanel(tweetl)
		
		Panel:ControlHelp(" ") -- Spacer
		
		Panel:AddControl("Label", {Text = "To Donate:"})
		Panel:ControlHelp("By donating, you will be encouraging me to keep making and updating addons! Thank you!")
		local donate = vgui.Create("DButton") -- Donate
		donate:SetFont("TargetID")
		donate:SetText("Donate to Help!")
		donate:SetSize(150, 30)
		donate:SetColor(Color(76,153,255,255))
		donate.DoClick = function(donate)
			gui.OpenURL("https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=VTLG9CHSAEUT6")
		end
		Panel:AddPanel(donate)
		
		/*HTMLTest = vgui.Create("HTML")
		HTMLTest:SetPos(50,50)
		HTMLTest:SetSize(ScrW() - 100, ScrH() - 100)
		HTMLTest:OpenURL("http://steamcommunity.com/sharedfiles/filedetails/?id=131759821")	*/
		//Panel:AddPanel(HTMLTest)
	end
	----=================================----
	local function VJ_MAINMENU_ADMINSERVER(Panel)
		if !game.SinglePlayer() then
		if !LocalPlayer():IsAdmin() or !LocalPlayer():IsSuperAdmin() then
			Panel:AddControl( "Label", {Text = "You are not a admin!"})
			Panel:ControlHelp("Notice: Only admins can use this settings.")
			return
			end
		end
		//Panel:AddControl("Header",{Description = "TESTINGGGGGGGGGGG"})
		Panel:AddControl( "Label", {Text = "Notice: Only admins can change this settings."})
		Panel:AddControl( "Label", {Text = "WARNING: SOME SETTINGS NEED CHEATS ENABLED!"})
		local vj_resetadminmenu = {Options = {}, CVars = {}, Label = "Reset Everything:", MenuButton = "0"}
		//vj_resetadminmenu:SetText("Select Default to reset everything")
		vj_resetadminmenu.Options["#vjbase.menugeneral.default"] = {
		sbox_noclip = "1",
		sbox_weapons =	"1",
		sbox_playershurtplayers = "1",
		sbox_godmode = "0",
		sv_gravity = "600",
		host_timescale = "1",
		phys_timescale = "1",
		}
		Panel:AddControl("ComboBox", vj_resetadminmenu)
		Panel:ControlHelp(" ") -- Spacer
		Panel:AddControl("Checkbox", {Label = "Allow NoClip", Command = "sbox_noclip"})
		Panel:AddControl("Checkbox", {Label = "Allow Weapons", Command = "sbox_weapons"})
		Panel:AddControl("Checkbox", {Label = "Allow PvP", Command = "sbox_playershurtplayers"})
		Panel:AddControl("Checkbox", {Label = "God Mode (Everyone)", Command = "sbox_godmode"})
		Panel:AddControl("Checkbox", {Label = "Bone Manipulate NPCs", Command = "sbox_bonemanip_npc"})
		Panel:AddControl("Checkbox", {Label = "Bone Manipulate Players", Command = "sbox_bonemanip_player"})
		Panel:AddControl("Checkbox", {Label = "Bone Manipulate Others", Command = "sbox_bonemanip_misc"})
		Panel:AddControl("Slider",{Label = "General TimeScale",Type = "Float",min = 0.1,max = 10,Command = "host_timescale"})
		Panel:AddControl("Slider",{Label = "Physics TimeScale",Type = "Float",min = 0,max = 2,Command = "phys_timescale"})
		Panel:AddControl("Slider",{Label = "General Gravity",Type = "Float",min = -200,max = 600,Command = "sv_gravity"})
		Panel:AddControl( "Label", {Text = "Max Props/Entities:"})
		for _, x in pairs(cleanup.GetTable()) do -- Simply receives all of the GMod limit convars
			if (!GetConVar("sbox_max"..x)) then continue end
			Panel:AddControl("Slider",{Label = "#max_"..x, Command = "sbox_max"..x, Min = "0", Max = "9999"})
		end
	end
	----=================================----
	function VJ_ADDTOMENU_MAIN()
		spawnmenu.AddToolMenuOption( "DrVrej", "Main Menu", "Clean Up", "Clean Up", "", "", VJ_MAINMENU_CLEANUP, {} )
		spawnmenu.AddToolMenuOption( "DrVrej", "Main Menu", "Contact and Support", "Contact and Support", "", "", VJ_MAINMENU_MISC, {} )
		spawnmenu.AddToolMenuOption( "DrVrej", "Main Menu", "Admin Server Settings", "Admin Server Settings", "", "", VJ_MAINMENU_ADMINSERVER, {} )
	end
		hook.Add( "PopulateToolMenu", "VJ_ADDTOMENU_MAIN", VJ_ADDTOMENU_MAIN )
end
-- Misc ---------------------------------------------------------------------------------------------------------------------------------------------
/*function vrej_welcome(ply)
timer.Simple(1, function()
ply:ChatPrint("------------------- DrVrej's SNPCs -------------------")
ply:ChatPrint("If you find a bug, contact me to my Steam Account or My website")
ply:ChatPrint("Make sure you have VJ Base! Or else my addons won't work!")
ply:ChatPrint("SignUp On My Website! http://vrejgaming.webs.com/")
ply:ChatPrint("Join My Steam Group! http://steamcommunity.com/groups/vrejgaming")
ply:ChatPrint("Like My Page On FaceBook! http://www.facebook.com/VrejGaming")
ply:ChatPrint("Follow Me on Twitter! https://twitter.com/vrejgaming")
ply:ChatPrint("Subscribe me on YouTube! http://www.youtube.com/user/gmod95")
end)
end
hook.Add("PlayerInitialSpawn","vrej_welcome",vrej_welcome)*/