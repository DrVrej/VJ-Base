/*--------------------------------------------------
	=============== Main Menu ===============
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Console Commands ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
concommand.Add("vj_cleanup_all",function(ply)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		game.CleanUpMap()
		if (SERVER) then ply:SendLua("GAMEMODE:AddNotify(\"Cleaned Up Everything!\", NOTIFY_CLEANUP, 5)") end
		ply:EmitSound("buttons/button15.wav")
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
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
---------------------------------------------------------------------------------------------------------------------------------------------
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
---------------------------------------------------------------------------------------------------------------------------------------------
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
---------------------------------------------------------------------------------------------------------------------------------------------
concommand.Add("vj_cleanup_decals", function(ply)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		for k, v in pairs(player.GetAll()) do
			v:ConCommand("r_cleardecals")
		end
		if (SERVER) then ply:SendLua("GAMEMODE:AddNotify(\"Removed All Decals\", NOTIFY_CLEANUP, 5)") end
		ply:EmitSound("buttons/button15.wav")
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
concommand.Add("vj_cleanup_playerammo", function(ply)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		ply:RemoveAllAmmo()
		if (SERVER) then ply:SendLua("GAMEMODE:AddNotify(\"Removed All Your Ammo\", NOTIFY_CLEANUP, 5)") end
		ply:EmitSound("buttons/button15.wav")
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
concommand.Add("vj_cleanup_playerweapon", function(ply)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		ply:StripWeapons()
		if (SERVER) then ply:SendLua("GAMEMODE:AddNotify(\"Removed All Your Weapons\", NOTIFY_CLEANUP, 5)") end
		ply:EmitSound("buttons/button15.wav")
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
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
---------------------------------------------------------------------------------------------------------------------------------------------
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
---------------------------------------------------------------------------------------------------------------------------------------------
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
---------------------------------------------------------------------------------------------------------------------------------------------
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
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Main Menu ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
	local function VJ_MAINMENU_CLEANUP(Panel)
		if !game.SinglePlayer() && (!LocalPlayer():IsAdmin() or !LocalPlayer():IsSuperAdmin()) then
			Panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.not"})
			Panel:ControlHelp("#vjbase.menu.general.admin.only")
			return
		end
		Panel:ControlHelp(" ") -- Spacer
		Panel:ControlHelp("#vjbase.menu.general.admin.only")
		Panel:AddControl("Button", {Label = "#vjbase.menu.cleanup.everything", Command = "vj_cleanup_all"})
		Panel:AddControl("Button", {Label = "#vjbase.menu.cleanup.stopsounds", Command = "stopsound"})
		Panel:AddControl("Button", {Label = "#vjbase.menu.cleanup.remove.vjnpcs", Command = "vj_cleanup_snpcs"})
		Panel:AddControl("Button", {Label = "#vjbase.menu.cleanup.remove.npcs", Command = "vj_cleanup_s_npcs"})
		Panel:AddControl("Button", {Label = "#vjbase.menu.cleanup.remove.spawners", Command = "vj_cleanup_spawners"})
		Panel:AddControl("Button", {Label = "#vjbase.menu.cleanup.remove.corpses", Command = "vj_cleanup_snpcscorpse"})
		Panel:AddControl("Button", {Label = "#vjbase.menu.cleanup.remove.vjgibs", Command = "vj_cleanup_vjgibs"})
		Panel:AddControl("Button", {Label = "#vjbase.menu.cleanup.remove.groundweapons", Command = "vj_cleanup_groundweapons"})
		Panel:AddControl("Button", {Label = "#vjbase.menu.cleanup.remove.props", Command = "vj_cleanup_props"})
		Panel:AddControl("Button", {Label = "#vjbase.menu.cleanup.remove.decals", Command = "vj_cleanup_decals"})
		Panel:AddControl("Button", {Label = "#vjbase.menu.cleanup.remove.allweapons", Command = "vj_cleanup_playerweapon"})
		Panel:AddControl("Button", {Label = "#vjbase.menu.cleanup.remove.allammo", Command = "vj_cleanup_playerammo"})
	end
	----=================================----
	local function VJ_MAINMENU_MISC(Panel)
		local bugr = vgui.Create("DButton") -- Bug Report
		bugr:SetFont("CloseCaption_Bold")
		bugr:SetText("#vjbase.menu.helpsupport.reportbug")
		bugr:SetSize(150, 35)
		bugr:SetColor(Color(231, 76, 60, 255))
		bugr.DoClick = function(bugr)
			gui.OpenURL("http://steamcommunity.com/groups/vrejgaming/discussions/2/")
		end
		Panel:AddPanel(bugr)

		local suggest = vgui.Create("DButton") -- Suggestions
		suggest:SetFont("DermaDefaultBold")
		suggest:SetText("#vjbase.menu.helpsupport.suggestion")
		suggest:SetSize(150, 20)
		suggest:SetColor(Color(211, 84, 0, 200))
		suggest.DoClick = function(suggest)
			gui.OpenURL("http://steamcommunity.com/groups/vrejgaming/discussions/1/")
		end
		Panel:AddPanel(suggest)

		Panel:ControlHelp(" ") -- Spacer

		Panel:AddControl("Label", {Text = "#vjbase.menu.helpsupport.label1"})
		Panel:ControlHelp("#vjbase.menu.helpsupport.thanks")

		local discordl = vgui.Create("DButton") -- Discord
		discordl:SetFont("TargetID")
		discordl:SetText("#vjbase.menu.helpsupport.discord")
		discordl:SetSize(150, 25)
		discordl:SetColor(Color(39, 174, 96, 255))
		discordl.DoClick = function(discordl)
			gui.OpenURL("https://discord.gg/zwQjrdG")
		end
		Panel:AddPanel(discordl)
		
		local steaml = vgui.Create("DButton") -- Steam Group
		steaml:SetFont("TargetID")
		steaml:SetText("#vjbase.menu.helpsupport.steam")
		steaml:SetSize(150, 25)
		steaml:SetColor(Color(39, 174, 96, 255))
		steaml.DoClick = function(steaml)
			gui.OpenURL("http://steamcommunity.com/groups/vrejgaming")
		end
		Panel:AddPanel(steaml)

		local ytl = vgui.Create("DButton") -- YouTube
		ytl:SetFont("TargetID")
		ytl:SetText("#vjbase.menu.helpsupport.youtube")
		ytl:SetSize(150, 25)
		ytl:SetColor(Color(39, 174, 96, 255))
		ytl.DoClick = function(ytl)
			gui.OpenURL("http://www.youtube.com/user/gmod95")
		end
		Panel:AddPanel(ytl)

		local tweetl = vgui.Create("DButton") -- Twitter
		tweetl:SetFont("TargetID")
		tweetl:SetText("#vjbase.menu.helpsupport.twitter")
		tweetl:SetSize(150, 25)
		tweetl:SetColor(Color(39, 174, 96, 255))
		tweetl.DoClick = function(tweetl)
			gui.OpenURL("http://twitter.com/vrejgaming")
		end
		Panel:AddPanel(tweetl)

		Panel:ControlHelp(" ") -- Spacer
		
		local donate = vgui.Create("DButton") -- Donate
		donate:SetFont("TargetID")
		donate:SetText("#vjbase.menu.helpsupport.patreon")
		donate:SetSize(150, 30)
		donate:SetColor(Color(52, 152, 219, 255))
		donate.DoClick = function(donate)
			gui.OpenURL("https://www.patreon.com/drvrej")
		end
		Panel:AddPanel(donate)
		Panel:ControlHelp("#vjbase.menu.helpsupport.label2")

		/*HTMLTest = vgui.Create("HTML")
		HTMLTest:SetPos(50,50)
		HTMLTest:SetSize(ScrW() - 100, ScrH() - 100)
		HTMLTest:OpenURL("http://steamcommunity.com/sharedfiles/filedetails/?id=131759821")	*/
		//Panel:AddPanel(HTMLTest)
	end
	----=================================----
	local function VJ_MAINMENU_ADMINSERVER(Panel)
		if !game.SinglePlayer() && (!LocalPlayer():IsAdmin() or !LocalPlayer():IsSuperAdmin()) then
			Panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.not"})
			Panel:ControlHelp("#vjbase.menu.general.admin.only")
			return
		end
		Panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.only"})
		Panel:AddControl("Label", {Text = "#vjbase.menu.svsettings.label"})
		local vj_resetadminmenu = {Options = {}, CVars = {}, Label = language.GetPhrase("#vjbase.menu.general.reset.everything")..":", MenuButton = "0"}
		//vj_resetadminmenu:SetText("Select Default to reset everything")
		vj_resetadminmenu.Options["#vjbase.menu.general.default"] = {
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
		Panel:AddControl("Checkbox", {Label = "#vjbase.menu.svsettings.admin.npcproperties", Command = "vj_npc_admin_properties"})
		Panel:AddControl("Checkbox", {Label = "#vjbase.menu.svsettings.noclip", Command = "sbox_noclip"})
		Panel:AddControl("Checkbox", {Label = "#vjbase.menu.svsettings.weapons", Command = "sbox_weapons"})
		Panel:AddControl("Checkbox", {Label = "#vjbase.menu.svsettings.pvp", Command = "sbox_playershurtplayers"})
		Panel:AddControl("Checkbox", {Label = "#vjbase.menu.svsettings.godmode", Command = "sbox_godmode"})
		Panel:AddControl("Checkbox", {Label = "#vjbase.menu.svsettings.bonemanip.npcs", Command = "sbox_bonemanip_npc"})
		Panel:AddControl("Checkbox", {Label = "#vjbase.menu.svsettings.bonemanip.players", Command = "sbox_bonemanip_player"})
		Panel:AddControl("Checkbox", {Label = "#vjbase.menu.svsettings.bonemanip.others", Command = "sbox_bonemanip_misc"})
		Panel:AddControl("Slider",{Label = "#vjbase.menu.svsettings.timescale.general",Type = "Float",min = 0.1,max = 10,Command = "host_timescale"})
		Panel:AddControl("Slider",{Label = "#vjbase.menu.svsettings.timescale.physics",Type = "Float",min = 0,max = 2,Command = "phys_timescale"})
		Panel:AddControl("Slider",{Label = "#vjbase.menu.svsettings.gravity",Type = "Float",min = -200,max = 600,Command = "sv_gravity"})
		Panel:AddControl("Label", {Text = "#vjbase.menu.svsettings.maxentsprops"})
		for _, x in pairs(cleanup.GetTable()) do -- Simply receives all of the GMod limit convars
			if (!GetConVar("sbox_max"..x)) then continue end
			Panel:AddControl("Slider",{Label = "#max_"..x, Command = "sbox_max"..x, Min = "0", Max = "9999"})
		end
	end
	----=================================----
	hook.Add("PopulateToolMenu", "VJ_ADDTOMENU_MAIN", function()
		spawnmenu.AddToolMenuOption("DrVrej", "Main Menu", "Clean Up", "#vjbase.menu.cleanup", "", "", VJ_MAINMENU_CLEANUP, {})
		spawnmenu.AddToolMenuOption("DrVrej", "Main Menu", "Contact and Support", "#vjbase.menu.helpsupport", "", "", VJ_MAINMENU_MISC, {})
		spawnmenu.AddToolMenuOption("DrVrej", "Main Menu", "Admin Server Settings", "#vjbase.menu.svsettings", "", "", VJ_MAINMENU_ADMINSERVER, {})
	end)
end