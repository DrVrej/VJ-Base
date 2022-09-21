/*--------------------------------------------------
	=============== Main Menu ===============
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
	local cTypes = {
		vjnpcs = "VJ NPCs",
		npcs = "NPCs",
		spawners = "Spawners",
		corpses = "Corpses",
		vjgibs = "Gibs",
		groundweapons = "Ground Weapons",
		props = "Props",
		decals = "Removed All Decals",
		allweapons = "Removed All Your Weapons",
		allammo = "Removed All Your Ammo",
	}
	concommand.Add("vj_cleanup", function(ply, cmd, args)
		if IsValid(ply) && !ply:IsAdmin() then return end
		local cType = args[1]
		local i = 0
		if !cType then -- Not type given, so it means its a clean up all!
			game.CleanUpMap()
		elseif cType == "decals" then
			for _, v in ipairs(player.GetAll()) do
				v:ConCommand("r_cleardecals")
			end
		elseif IsValid(ply) && cType == "allweapons" then
			ply:StripWeapons()
		elseif IsValid(ply) && cType == "allammo" then
			ply:RemoveAllAmmo()
		else
			for _, v in ipairs(ents.GetAll()) do
				if (v:IsNPC() && (cType == "npcs" or (cType == "vjnpcs" && v.IsVJBaseSNPC == true))) or (cType == "spawners" && v.IsVJBaseSpawner == true) or (cType == "corpses" && (v.IsVJBaseCorpse == true or v.IsVJBase_Gib == true)) or (cType == "vjgibs" && v.IsVJBase_Gib == true) or (cType == "groundweapons" && v:IsWeapon() && v:GetOwner() == NULL) or (cType == "props" && v:GetClass() == "prop_physics" && (v:GetParent() == NULL or (IsValid(v:GetParent()) && v:GetParent():Health() <= 0 && (v:GetParent():IsNPC() or v:GetParent():IsPlayer())))) then
					//undo.ReplaceEntity(v, NULL)
					v:Remove()
					i = i + 1
				end
			end
			-- Clean up client side corpses
			-- DOES NOT WORK, FUNCTION IS BROKEN!
			//if cType == "corpses" then
				//game.RemoveRagdolls()
			//end
		end
		if IsValid(ply) then
			if !cType then
				ply:SendLua("GAMEMODE:AddNotify(\"Cleaned Up Everything!\", NOTIFY_CLEANUP, 5)")
			elseif cType == "decals" or cType == "allweapons" or cType == "allammo" then
				ply:SendLua("GAMEMODE:AddNotify(\""..cTypes[cType].."\", NOTIFY_CLEANUP, 5)")
			else
				ply:SendLua("GAMEMODE:AddNotify(\"Removed "..i.." "..cTypes[cType].."\", NOTIFY_CLEANUP, 5)")
			end
			ply:EmitSound("buttons/button15.wav")
		end
	end, nil, "", {FCVAR_DONTRECORD})
else
	local function VJ_MAINMENU_CLEANUP(Panel)
		if !game.SinglePlayer() && !LocalPlayer():IsAdmin() then
			Panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.not"})
			Panel:AddControl( "Label", {Text = "#vjbase.menu.general.admin.only"})
			return
		end
		Panel:ControlHelp(" ") -- Spacer
		Panel:AddControl( "Label", {Text = "#vjbase.menu.general.admin.only"})
		Panel:Button("#vjbase.menu.cleanup.all", "vj_cleanup")
		Panel:Button("#vjbase.menu.cleanup.stopsounds", "stopsound")
		Panel:Button("#vjbase.menu.cleanup.remove.vjnpcs", "vj_cleanup", "vjnpcs")
		Panel:Button("#vjbase.menu.cleanup.remove.npcs", "vj_cleanup", "npcs")
		Panel:Button("#vjbase.menu.cleanup.remove.spawners", "vj_cleanup", "spawners")
		Panel:Button("#vjbase.menu.cleanup.remove.corpses", "vj_cleanup", "corpses")
		Panel:Button("#vjbase.menu.cleanup.remove.vjgibs", "vj_cleanup", "vjgibs")
		Panel:Button("#vjbase.menu.cleanup.remove.groundweapons", "vj_cleanup", "groundweapons")
		Panel:Button("#vjbase.menu.cleanup.remove.props", "vj_cleanup", "props")
		Panel:Button("#vjbase.menu.cleanup.remove.decals", "vj_cleanup", "decals")
		Panel:Button("#vjbase.menu.cleanup.remove.allweapons", "vj_cleanup", "allweapons")
		Panel:Button("#vjbase.menu.cleanup.remove.allammo", "vj_cleanup", "allammo")
	end
	----=================================----
	local function VJ_MAINMENU_MISC(Panel)
		local incomp = vgui.Create("DButton") -- Incompatible Addons
		incomp:SetFont("CloseCaption_Bold")
		incomp:SetText("#vjbase.menu.helpsupport.incompatibleaddons")
		incomp:SetSize(150, 35)
		incomp:SetColor(Color(231, 76, 60))
		incomp:SetFont("VJFont_Trebuchet24_SmallMedium")
		incomp.DoClick = function()
			gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=1129493108")
		end
		Panel:AddPanel(incomp)
		
		local bugr = vgui.Create("DButton") -- Bug Report
		bugr:SetFont("CloseCaption_Bold")
		bugr:SetText("#vjbase.menu.helpsupport.reportbug")
		bugr:SetSize(150, 35)
		bugr:SetColor(Color(231, 76, 60))
		bugr:SetFont("VJFont_Trebuchet24_SmallMedium")
		bugr.DoClick = function()
			gui.OpenURL("http://steamcommunity.com/groups/vrejgaming/discussions/2/")
		end
		Panel:AddPanel(bugr)

		local suggest = vgui.Create("DButton") -- Suggestions
		suggest:SetFont("DermaDefaultBold")
		suggest:SetText("#vjbase.menu.helpsupport.suggestion")
		suggest:SetSize(150, 20)
		suggest:SetColor(Color(211, 84, 0))
		suggest:SetFont("VJFont_Trebuchet24_SmallMedium")
		suggest.DoClick = function()
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
		discordl:SetColor(Color(0, 102, 0))
		discordl:SetFont("VJFont_Trebuchet24_SmallMedium")
		discordl.DoClick = function()
			gui.OpenURL("https://discord.gg/zwQjrdG")
		end
		Panel:AddPanel(discordl)
		
		local steaml = vgui.Create("DButton") -- Steam Group
		steaml:SetFont("TargetID")
		steaml:SetText("#vjbase.menu.helpsupport.steam")
		steaml:SetSize(150, 25)
		steaml:SetColor(Color(0, 102, 0))
		steaml:SetFont("VJFont_Trebuchet24_SmallMedium")
		steaml.DoClick = function()
			gui.OpenURL("http://steamcommunity.com/groups/vrejgaming")
		end
		Panel:AddPanel(steaml)

		local ytl = vgui.Create("DButton") -- YouTube
		ytl:SetFont("TargetID")
		ytl:SetText("#vjbase.menu.helpsupport.youtube")
		ytl:SetSize(150, 25)
		ytl:SetColor(Color(0, 102, 0))
		ytl:SetFont("VJFont_Trebuchet24_SmallMedium")
		ytl.DoClick = function()
			gui.OpenURL("http://www.youtube.com/user/gmod95")
		end
		Panel:AddPanel(ytl)

		local tweetl = vgui.Create("DButton") -- Twitter
		tweetl:SetFont("TargetID")
		tweetl:SetText("#vjbase.menu.helpsupport.twitter")
		tweetl:SetSize(150, 25)
		tweetl:SetColor(Color(0, 102, 0))
		tweetl:SetFont("VJFont_Trebuchet24_SmallMedium")
		tweetl.DoClick = function()
			gui.OpenURL("http://twitter.com/vrejgaming")
		end
		Panel:AddPanel(tweetl)

		Panel:ControlHelp(" ") -- Spacer
		
		local donate = vgui.Create("DButton") -- Donate
		donate:SetFont("TargetID")
		donate:SetText("#vjbase.menu.helpsupport.patreon")
		donate:SetSize(150, 30)
		donate:SetColor(Color(0, 0, 102))
		donate:SetFont("VJFont_Trebuchet24_SmallMedium")
		donate.DoClick = function()
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
		if !game.SinglePlayer() && !LocalPlayer():IsAdmin() then
			Panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.not"})
			Panel:AddControl( "Label", {Text = "#vjbase.menu.general.admin.only"})
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
