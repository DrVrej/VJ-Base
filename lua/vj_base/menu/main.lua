/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
---------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
	concommand.Add("vj_dev_numnpcs", function(ply, cmd, args)
		if IsValid(ply) && ply:IsAdmin() then
			local numNPC = 0
			local numVJ = 0
			local numNextBot = 0
			for _, v in ipairs(ents.GetAll()) do
				if v:IsNPC() then
					numNPC = numNPC + 1
					if v.IsVJBaseSNPC then
						numVJ = numVJ + 1
					end
				elseif v:IsNextBot() then
					numNextBot = numNextBot + 1
				end
			end
			ply:ChatPrint("Total NPCs: " .. numNPC .. " | VJ NPCs: " .. numVJ .. " | NextBots: " .. numNextBot)
		end
	end)
	--
	local cTypes = {
		vjnpcs = "VJ NPCs",
		npcs = "NPCs",
		spawners = "Spawners",
		corpses = "Corpses",
		gibs = "Gibs",
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
				if (v:IsNPC() && (cType == "npcs" or (cType == "vjnpcs" && v.IsVJBaseSNPC))) or (cType == "spawners" && v.IsVJBaseSpawner) or (cType == "corpses" && (v.IsVJBaseCorpse or v.IsVJBaseCorpse_Gib)) or (cType == "gibs" && v.IsVJBaseCorpse_Gib) or (cType == "groundweapons" && v:IsWeapon() && v:GetOwner() == NULL) or (cType == "props" && v:GetClass() == "prop_physics" && (v:GetParent() == NULL or (IsValid(v:GetParent()) && v:GetParent():Health() <= 0 && (v:GetParent():IsNPC() or v:GetParent():IsPlayer())))) then
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
	end, nil, "", FCVAR_DONTRECORD)
else
	//local colorOrange = Color(243, 101, 35)
	local colorWhite = Color(255, 255, 255)
	local colorLightBlue = Color(0, 255, 255)
	local colorDarkBlue = Color(30, 200, 255)
	local colorYellow = Color(255, 215, 0)
	--
	local function VJ_MAIN_INFO(Panel)
		local client = LocalPlayer() -- Local Player
		Panel:AddControl("Label", {Text = "About VJ Base:"})
		Panel:ControlHelp("VJ Base is made by DrVrej. The main purpose of this base is for the sake of simplicity. It provides many types of bases including a very advanced artificial intelligent NPC base.")
		--
		--
		Panel:AddControl("Label", {Text = "User Information:"})
		Panel:ControlHelp("Date - "..os.date("%b %d, %Y - %I:%M %p")) -- Date
		Panel:ControlHelp("Name - "..client:Nick().." ("..client:SteamID()..")") -- Name + Steam ID
		Panel:ControlHelp("Session - "..(game.SinglePlayer() and "SinglePlayer" or "Multiplayer")..", "..gmod.GetGamemode().Name.." ("..game.GetMap()..")") -- Game Session
		Panel:ControlHelp("VJ Base - "..VJBASE_VERSION..", "..#VJ.Plugins.." plugins, "..GetConVar("vj_language"):GetString()) -- VJ Base Information
		Panel:ControlHelp("System - "..(system.IsLinux() and "Linux" or (system.IsOSX() and "OSX" or "Windows")).." ("..ScrW().."x"..ScrH()..")") // system.IsWindows() -- System
		--
		--
		Panel:AddControl("Label", {Text = "Mounted Games:"})
		Panel:ControlHelp("HL1S - "..tostring(IsMounted("hl1")))
		Panel:ControlHelp("HL2 - "..tostring(IsMounted("hl2")))
		Panel:ControlHelp("HL2Ep1 - "..tostring(IsMounted("episodic")))
		Panel:ControlHelp("HL2Ep2 - "..tostring(IsMounted("ep2")))
		Panel:ControlHelp("CSS - "..tostring(IsMounted("cstrike")))
		Panel:ControlHelp("DoD - "..tostring(IsMounted("dod")))
		Panel:ControlHelp("TF2 - "..tostring(IsMounted("tf")))
		--
		--
		Panel:AddControl("Label", {Text = "Convar Prefixes:"})
		Panel:ControlHelp("NPCs - 'vj_npc_*'")
		Panel:ControlHelp("Weapons - 'vj_wep_*'")
		Panel:ControlHelp("HUD - 'vj_hud_*'")
		Panel:ControlHelp("Crosshair - 'vj_hud_ch_*'")
		--
		--
		Panel:AddControl("Label", {Text = "Credits:"})
		Panel:ControlHelp("DrVrej (Me) - Author")
		Panel:ControlHelp("Crowbar Collective - Original gib models, blood pool texture, Glock-17 model")
		Panel:ControlHelp("Valve - Various assets")
		Panel:ControlHelp("Orion - Helped create first version of the base (2011-2012)")
		Panel:ControlHelp("Cpt. Hazama - Various contributions, suggestions, testing")
		Panel:ControlHelp("Darkborn - Suggestions, testing")
		Panel:ControlHelp("Oteek - Blood pool textures, testing")
		Panel:ControlHelp("BOO342 - Original fireplace model")
		Panel:ControlHelp("China-Mandem - Original K-3 Model")
		
		Panel:ControlHelp("")
		Panel:ControlHelp("============================")
		
		Panel:ControlHelp("Copyright (c) "..os.date("20%y").." by DrVrej, All rights reserved.")
		Panel:ControlHelp("No parts of the code may be reproduced, copied, modified or adapted, without the prior written consent of the author.")
	end
	----=================================----
	local function VJ_MAIN_CLIENT(Panel)
		Panel:AddControl("Label", {Text = "#vjbase.menu.settings.client.label"})
		
		-- Icons: https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
		local vj_combo_box = vgui.Create("DComboBox")
			vj_combo_box:SetSize(100, 30)
			vj_combo_box:SetValue("#vjbase.menu.settings.client.lang.label")
			vj_combo_box:AddChoice("English", "english", false, "flags16/us.png")
			vj_combo_box:AddChoice("简体中文", "schinese", false, "flags16/cn.png")
			vj_combo_box:AddChoice("ՀայերԷն *", "armenian", false, "flags16/am.png")
			vj_combo_box:AddChoice("Русский", "russian", false, "flags16/ru.png")
			vj_combo_box:AddChoice("Deutsche *", "german", false, "flags16/de.png")
			vj_combo_box:AddChoice("Français *", "french", false, "flags16/fr.png")
			vj_combo_box:AddChoice("Lietuvių", "lithuanian", false, "flags16/lt.png")
			vj_combo_box:AddChoice("Español (Latino Americano)", "spanish_lt", false, "flags16/mx.png")
			vj_combo_box:AddChoice("Português (Brasileiro) *", "portuguese_br", false, "flags16/br.png")
			vj_combo_box:AddChoice("Türkçe", "turkish", false, "flags16/tr.png")
			vj_combo_box:AddChoice("Nederlands *", "dutch", false, "flags16/nl.png")
			vj_combo_box:AddChoice("norsk *", "norwegian", false, "flags16/no.png")
			vj_combo_box:AddChoice("Polski *", "polish", false, "flags16/pl.png")
			vj_combo_box:AddChoice("Ελληνικά *", "greek", false, "flags16/gr.png")
			vj_combo_box:AddChoice("日本語 *", "japanese", false, "flags16/jp.png")
			vj_combo_box:AddChoice("tiếng Việt *", "vietnamese", false, "flags16/vn.png")
			vj_combo_box.OnSelect = function(data, index, text)
				RunConsoleCommand("vj_language", vj_combo_box:GetOptionData(index))
				chat.AddText(colorYellow, "#vjbase.menu.settings.client.lang.notify", " ", colorDarkBlue, text)
				timer.Simple(0.2, function() VJ.RefreshLanguage(val) RunConsoleCommand("spawnmenu_reload") end) -- Bedke kichme espasenk minchevor command-e update ela
			end
		Panel:AddPanel(vj_combo_box)
		Panel:ControlHelp("* stands for unfinished translation!")
		Panel:AddControl("Checkbox", {Label = "#vjbase.menu.settings.client.lang.auto", Command = "vj_language_auto"})
		Panel:ControlHelp("#vjbase.menu.settings.client.lang.auto.label")
	end
	----=================================----
	local function VJ_MAIN_CLEANUP(Panel)
		if !game.SinglePlayer() && !LocalPlayer():IsAdmin() then
			Panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.not"})
			Panel:AddControl( "Label", {Text = "#vjbase.menu.general.admin.only"})
			return
		end
		Panel:AddControl( "Label", {Text = "#vjbase.menu.general.admin.only"})
		Panel:Button("#vjbase.menu.cleanup.all", "vj_cleanup")
		Panel:Button("#vjbase.menu.cleanup.sounds", "stopsound")
		Panel:Button("#vjbase.menu.cleanup.remove.npcs.vj", "vj_cleanup", "vjnpcs")
		Panel:Button("#vjbase.menu.cleanup.remove.npcs", "vj_cleanup", "npcs")
		Panel:Button("#vjbase.menu.cleanup.remove.spawners", "vj_cleanup", "spawners")
		Panel:Button("#vjbase.menu.cleanup.remove.corpses", "vj_cleanup", "corpses")
		Panel:Button("#vjbase.menu.cleanup.remove.gibs", "vj_cleanup", "gibs")
		Panel:Button("#vjbase.menu.cleanup.remove.groundweapons", "vj_cleanup", "groundweapons")
		Panel:Button("#vjbase.menu.cleanup.remove.props", "vj_cleanup", "props")
		Panel:Button("#vjbase.menu.cleanup.remove.decals", "vj_cleanup", "decals")
		Panel:Button("#vjbase.menu.cleanup.remove.ply.weapons", "vj_cleanup", "allweapons")
		Panel:Button("#vjbase.menu.cleanup.remove.ply.ammo", "vj_cleanup", "allammo")
	end
	----=================================----
	local function VJ_MAIN_CONTACT(Panel)
		local incomp = vgui.Create("DButton") -- Incompatible Addons
		incomp:SetFont("CloseCaption_Bold")
		incomp:SetText("#vjbase.menu.contact.incompatible")
		incomp:SetSize(150, 35)
		incomp:SetColor(Color(231, 76, 60))
		incomp:SetFont("VJBaseSmallMedium")
		incomp.DoClick = function()
			gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=1129493108")
		end
		Panel:AddPanel(incomp)

		Panel:ControlHelp(" ") -- Spacer

		local github = vgui.Create("DButton") -- GitHub
		github:SetFont("TargetID")
		github:SetText("#vjbase.menu.contact.github")
		github:SetSize(150, 25)
		github:SetColor(Color(0, 0, 0))
		github:SetFont("VJBaseSmallMedium")
		github.DoClick = function()
			gui.OpenURL("https://github.com/DrVrej/VJ-Base")
		end
		Panel:AddPanel(github)
		
		local documentation = vgui.Create("DButton") -- Documentation
		documentation:SetFont("TargetID")
		documentation:SetText("#vjbase.menu.contact.documentation")
		documentation:SetSize(150, 25)
		documentation:SetColor(Color(0, 0, 0))
		documentation:SetFont("VJBaseSmallMedium")
		documentation.DoClick = function()
			gui.OpenURL("https://drvrej.com/project/vjbase/")
		end
		Panel:AddPanel(documentation)
		
		local changelogs = vgui.Create("DButton") -- Change Logs
		changelogs:SetFont("TargetID")
		changelogs:SetText("#vjbase.menu.contact.changelogs")
		changelogs:SetSize(150, 25)
		changelogs:SetColor(Color(0, 0, 0))
		changelogs:SetFont("VJBaseSmallMedium")
		changelogs.DoClick = function()
			gui.OpenURL("https://github.com/DrVrej/VJ-Base/releases")
		end
		Panel:AddPanel(changelogs)
		
		Panel:ControlHelp(" ") -- Spacer

		local discord = vgui.Create("DButton") -- Discord
		discord:SetFont("TargetID")
		discord:SetText("#vjbase.menu.contact.discord")
		discord:SetSize(150, 25)
		discord:SetColor(Color(0, 102, 0))
		discord:SetFont("VJBaseSmallMedium")
		discord.DoClick = function()
			gui.OpenURL("https://discord.gg/zwQjrdG")
		end
		Panel:AddPanel(discord)
		
		local steam = vgui.Create("DButton") -- Steam Group
		steam:SetFont("TargetID")
		steam:SetText("#vjbase.menu.contact.steam")
		steam:SetSize(150, 25)
		steam:SetColor(Color(0, 102, 0))
		steam:SetFont("VJBaseSmallMedium")
		steam.DoClick = function()
			gui.OpenURL("http://steamcommunity.com/groups/vrejgaming")
		end
		Panel:AddPanel(steam)

		local youtube = vgui.Create("DButton") -- YouTube
		youtube:SetFont("TargetID")
		youtube:SetText("#vjbase.menu.contact.youtube")
		youtube:SetSize(150, 25)
		youtube:SetColor(Color(0, 102, 0))
		youtube:SetFont("VJBaseSmallMedium")
		youtube.DoClick = function()
			gui.OpenURL("http://www.youtube.com/user/gmod95")
		end
		Panel:AddPanel(youtube)

		local twitter = vgui.Create("DButton") -- Twitter
		twitter:SetFont("TargetID")
		twitter:SetText("#vjbase.menu.contact.twitter")
		twitter:SetSize(150, 25)
		twitter:SetColor(Color(0, 102, 0))
		twitter:SetFont("VJBaseSmallMedium")
		twitter.DoClick = function()
			gui.OpenURL("http://twitter.com/vrejgaming")
		end
		Panel:AddPanel(twitter)

		Panel:ControlHelp(" ") -- Spacer
		
		local patreon = vgui.Create("DButton") -- patreon
		patreon:SetFont("TargetID")
		patreon:SetText("#vjbase.menu.contact.patreon")
		patreon:SetSize(150, 30)
		patreon:SetColor(Color(0, 0, 102))
		patreon:SetFont("VJBaseSmallMedium")
		patreon.DoClick = function()
			gui.OpenURL("https://www.patreon.com/drvrej")
		end
		Panel:AddPanel(patreon)
		Panel:ControlHelp("#vjbase.menu.contact.patreon.label")

		/*HTMLTest = vgui.Create("HTML")
		HTMLTest:SetPos(50, 50)
		HTMLTest:SetSize(ScrW() - 100, ScrH() - 100)
		HTMLTest:OpenURL("http://steamcommunity.com/sharedfiles/filedetails/?id=131759821")	*/
		//Panel:AddPanel(HTMLTest)
	end
	----=================================----
	local function VJ_MAIN_SERVER(Panel)
		if !game.SinglePlayer() && !LocalPlayer():IsAdmin() then
			Panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.not"})
			Panel:AddControl( "Label", {Text = "#vjbase.menu.general.admin.only"})
			return
		end
		Panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.only"})
		Panel:AddControl("Label", {Text = "#vjbase.menu.settings.server.label"})
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
		Panel:AddControl("Checkbox", {Label = "#vjbase.menu.settings.server.admin.npcproperties", Command = "vj_npc_admin_properties"})
		Panel:AddControl("Checkbox", {Label = "#vjbase.menu.settings.server.noclip", Command = "sbox_noclip"})
		Panel:AddControl("Checkbox", {Label = "#vjbase.menu.settings.server.weapons", Command = "sbox_weapons"})
		Panel:AddControl("Checkbox", {Label = "#vjbase.menu.settings.server.pvp", Command = "sbox_playershurtplayers"})
		Panel:AddControl("Checkbox", {Label = "#vjbase.menu.settings.server.godmode", Command = "sbox_godmode"})
		Panel:AddControl("Checkbox", {Label = "#vjbase.menu.settings.server.bonemanip.npcs", Command = "sbox_bonemanip_npc"})
		Panel:AddControl("Checkbox", {Label = "#vjbase.menu.settings.server.bonemanip.players", Command = "sbox_bonemanip_player"})
		Panel:AddControl("Checkbox", {Label = "#vjbase.menu.settings.server.bonemanip.others", Command = "sbox_bonemanip_misc"})
		Panel:AddControl("Slider", {Label = "#vjbase.menu.settings.server.timescale.general", Type = "Float", min = 0.1, max = 10, Command = "host_timescale"})
		Panel:AddControl("Slider", {Label = "#vjbase.menu.settings.server.timescale.physics", Type = "Float", min = 0, max = 2, Command = "phys_timescale"})
		Panel:AddControl("Slider", {Label = "#vjbase.menu.settings.server.gravity", Type = "Float", min = -200, max = 600, Command = "sv_gravity"})
		Panel:AddControl("Label", {Text = "#vjbase.menu.settings.server.max.header"})
		for _, x in pairs(cleanup.GetTable()) do -- Simply receives all of the GMod limit convars
			if (!GetConVar("sbox_max"..x)) then continue end
			Panel:AddControl("Slider", {Label = "#max_"..x, Command = "sbox_max"..x, Min = "0", Max = "9999"})
		end
	end
	----=================================----
	local function VJ_MAIN_PLUGINS(Panel)
		local numPlugins = #VJ.Plugins
		
		Panel:AddControl("Label", {Text = "#vjbase.menu.plugins.label"})
		Panel:ControlHelp(language.GetPhrase("#vjbase.menu.plugins.version").." "..VJBASE_VERSION) -- Main Number / Version / Patches
		Panel:ControlHelp(language.GetPhrase("#vjbase.menu.plugins.total").." "..numPlugins)
		
		local pluginList = vgui.Create("DListView")
		pluginList:SetTooltip(false)
		//pluginList:Center() -- No need since Size does it already
		pluginList:SetSize(100, 300) -- Size
		pluginList:SetMultiSelect(false)
		pluginList:AddColumn("#vjbase.menu.plugins.header.name")
		pluginList:AddColumn("#vjbase.menu.plugins.header.type"):SetFixedWidth(50)
		//Panel:SetName("Test") -- Renames the blue label
		if VJ.Plugins != nil then
			for _, v in SortedPairsByMemberValue(VJ.Plugins, "Name") do
				pluginList:AddLine(v.Name, v.Type)
			end
		else
			pluginList:AddLine("#vjbase.menu.plugins.none", "")
		end
		pluginList.OnRowSelected = function(panel, rowIndex, row)
			//surface.PlaySound("vj_base/player/illuminati.mp3")
			chat.AddText(colorYellow, language.GetPhrase("#vjbase.menu.plugins.chat.name").." "..row:GetValue(1))
			chat.AddText(colorYellow, language.GetPhrase("#vjbase.menu.plugins.chat.type").." "..row:GetValue(2))
		end
		Panel:AddItem(pluginList)
		
		-- Changelog for VJ Base
		local changelog = vgui.Create("DButton")
		changelog:SetFont("TargetID")
		changelog:SetText("#vjbase.menu.plugins.changelog")
		changelog:SetSize(150, 25)
		changelog:SetColor(Color(0, 102, 0))
		changelog:SetFont("VJBaseSmallMedium")
		changelog.DoClick = function(x)
			gui.OpenURL("https://github.com/DrVrej/VJ-Base/releases")
		end
		Panel:AddPanel(changelog)
		
		-- Github Wiki
		local github = vgui.Create("DButton")
		github:SetFont("TargetID")
		github:SetText("#vjbase.menu.plugins.makeaddon")
		github:SetSize(150, 25)
		github:SetColor(Color(0, 0, 102))
		github:SetFont("VJBaseSmallMedium")
		github.DoClick = function(x)
			gui.OpenURL("https://drvrej.com/project/vjbase/")
		end
		Panel:AddPanel(github)
		
		-- Tutorial Video
		local tutorialVid = vgui.Create("DButton")
		tutorialVid:SetFont("TargetID")
		tutorialVid:SetText("#vjbase.menu.general.tutorial.vid")
		tutorialVid:SetSize(150, 25)
		tutorialVid:SetColor(Color(0, 0, 102))
		tutorialVid:SetFont("VJBaseSmallMedium")
		tutorialVid.DoClick = function(x)
			gui.OpenURL("https://www.youtube.com/watch?v=dGoqEpFZ5_M")
		end
		Panel:AddPanel(tutorialVid)
		
		-- *insert lenny face*
		if (LocalPlayer():SteamID() == "STEAM_0:0:22688298") then
			local memeButton = vgui.Create("DButton")
			memeButton:SetFont("TargetID")
			memeButton:SetText("HELLO")
			memeButton:SetSize(150, 25)
			memeButton:SetColor(Color(0, 0, 102))
			memeButton:SetFont("VJBaseSmallMedium")
			memeButton.DoClick = function(x)
				net.Start("vj_meme")
				net.SendToServer()
			end
			Panel:AddPanel(memeButton)
		end
	end
	---------------------------------------------------------------------------------------------------------------------------------------------
	local function doWelcomeMsg()
		//print("Notice: This server is running VJ Base.")
		chat.AddText(colorLightBlue, "VJ Base ", colorDarkBlue, VJBASE_VERSION, colorWhite, " : Navigate to the ", colorYellow, "DrVrej", colorWhite, " tab in the spawn menu for settings.")
	end
	net.Receive("vj_welcome_msg", doWelcomeMsg)
	---------------------------------------------------------------------------------------------------------------------------------------------
	concommand.Add("vj_iamhere", function(ply, cmd, args)
		net.Start("vj_meme")
		net.SendToServer()
	end)
	----=================================----
	hook.Add("PopulateToolMenu", "VJ_ADDTOMENU_MAIN", function()
		spawnmenu.AddToolMenuOption("DrVrej", "Main", "vj_menu_plugins", "#vjbase.menu.plugins", "", "", VJ_MAIN_PLUGINS)
		spawnmenu.AddToolMenuOption("DrVrej", "Main", "vj_menu_info", "#vjbase.menu.info", "", "", VJ_MAIN_INFO, {})
		spawnmenu.AddToolMenuOption("DrVrej", "Main", "vj_menu_settings_cl", "#vjbase.menu.settings.client", "", "", VJ_MAIN_CLIENT, {})
		spawnmenu.AddToolMenuOption("DrVrej", "Main", "vj_menu_cleanup", "#vjbase.menu.cleanup", "", "", VJ_MAIN_CLEANUP, {})
		spawnmenu.AddToolMenuOption("DrVrej", "Main", "vj_menu_contact", "#vjbase.menu.contact", "", "", VJ_MAIN_CONTACT, {})
		spawnmenu.AddToolMenuOption("DrVrej", "Main", "vj_menu_settings_sv", "#vjbase.menu.settings.server", "", "", VJ_MAIN_SERVER, {})
	end)
end
