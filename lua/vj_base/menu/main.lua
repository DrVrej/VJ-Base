/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
if !CLIENT then return end
local colorDarkBlue = Color(30, 200, 255)
local colorYellow = Color(255, 215, 0)
--
local function VJ_MAIN_INFO(panel)
	local client = LocalPlayer() -- Local Player
	panel:Help("About VJ Base:")
	panel:ControlHelp("VJ Base is made by DrVrej. The main purpose of this base is for the sake of simplicity. It provides many types of bases including a very advanced artificial intelligent NPC base.")
	--
	--
	panel:Help("User Information:")
	panel:ControlHelp("Date - " .. os.date("%b %d, %Y - %I:%M %p")) -- Date
	panel:ControlHelp("Name - " .. client:Nick() .. " (" .. client:SteamID() .. ")") -- Name + Steam ID
	panel:ControlHelp("Session - " .. (game.SinglePlayer() and "SinglePlayer" or "Multiplayer") .. ", " .. gmod.GetGamemode().Name .. " (" .. game.GetMap() .. ")") -- Game Session
	panel:ControlHelp("VJ Base - " .. VJBASE_VERSION .. ", " .. #VJ.Plugins .. " plugins, " .. GetConVar("vj_language"):GetString()) -- VJ Base Information
	panel:ControlHelp("System - " .. (system.IsLinux() and "Linux" or (system.IsOSX() and "OSX" or "Windows")) .. " (" .. ScrW() .. "x" .. ScrH() .. ")") // system.IsWindows() -- System
	--
	--
	panel:Help("Mounted Games:")
	panel:ControlHelp("HL1S - " .. tostring(IsMounted("hl1")))
	panel:ControlHelp("HL2 - " .. tostring(IsMounted("hl2")))
	panel:ControlHelp("HL2Ep1 - " .. tostring(IsMounted("episodic")))
	panel:ControlHelp("HL2Ep2 - " .. tostring(IsMounted("ep2")))
	panel:ControlHelp("CSS - " .. tostring(IsMounted("cstrike")))
	panel:ControlHelp("DoD - " .. tostring(IsMounted("dod")))
	panel:ControlHelp("TF2 - " .. tostring(IsMounted("tf")))
	--
	--
	panel:Help("Convar Prefixes:")
	panel:ControlHelp("NPCs - 'vj_npc_*'")
	panel:ControlHelp("Weapons - 'vj_wep_*'")
	panel:ControlHelp("HUD - 'vj_hud_*'")
	panel:ControlHelp("Crosshair - 'vj_hud_ch_*'")
	--
	--
	panel:Help("Credits:")
	panel:ControlHelp("DrVrej (Me) - Author")
	panel:ControlHelp("Crowbar Collective - Original gib models, blood pool texture, Glock-17 model")
	panel:ControlHelp("Valve - Various assets")
	panel:ControlHelp("Orion - Helped create first version of the base (2011-2012)")
	panel:ControlHelp("Cpt. Hazama - Various contributions, suggestions, testing")
	panel:ControlHelp("Darkborn - Suggestions, testing")
	panel:ControlHelp("Oteek - Blood pool textures, testing")
	panel:ControlHelp("BOO342 - Original fireplace model")
	panel:ControlHelp("China-Mandem - Original K-3 Model")
	
	panel:ControlHelp("")
	panel:ControlHelp("============================")
	
	panel:ControlHelp("Copyright (c) " .. os.date("20%y") .. " by DrVrej, All rights reserved.")
	panel:ControlHelp("No parts of the code may be reproduced, copied, modified or adapted, without the prior written consent of the author.")
end
----=================================----
local function VJ_MAIN_CLIENT(panel)
	panel:Help("#vjbase.menu.settings.client.label")
	
	-- Icons: https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
	local langCombo = vgui.Create("DComboBox")
		langCombo:SetSize(100, 30)
		langCombo:SetValue("#vjbase.menu.settings.client.lang.label")
		langCombo:AddChoice("English", "english", false, "flags16/us.png")
		langCombo:AddChoice("简体中文", "schinese", false, "flags16/cn.png")
		langCombo:AddChoice("ՀայերԷն *", "armenian", false, "flags16/am.png")
		langCombo:AddChoice("Русский", "russian", false, "flags16/ru.png")
		langCombo:AddChoice("Deutsche *", "german", false, "flags16/de.png")
		langCombo:AddChoice("Français *", "french", false, "flags16/fr.png")
		langCombo:AddChoice("Lietuvių", "lithuanian", false, "flags16/lt.png")
		langCombo:AddChoice("Español (Latino Americano)", "spanish_lt", false, "flags16/mx.png")
		langCombo:AddChoice("Português (Brasileiro) *", "portuguese_br", false, "flags16/br.png")
		langCombo:AddChoice("Türkçe", "turkish", false, "flags16/tr.png")
		langCombo:AddChoice("Nederlands *", "dutch", false, "flags16/nl.png")
		langCombo:AddChoice("norsk *", "norwegian", false, "flags16/no.png")
		langCombo:AddChoice("Polski *", "polish", false, "flags16/pl.png")
		langCombo:AddChoice("Ελληνικά *", "greek", false, "flags16/gr.png")
		langCombo:AddChoice("日本語 *", "japanese", false, "flags16/jp.png")
		langCombo:AddChoice("tiếng Việt *", "vietnamese", false, "flags16/vn.png")
		function langCombo:OnSelect(index, value, data)
			RunConsoleCommand("vj_language", langCombo:GetOptionData(index))
			chat.AddText(colorYellow, "#vjbase.menu.settings.client.lang.notify", " ", colorDarkBlue, value)
			timer.Simple(0.2, function() VJ.RefreshLanguage(val) RunConsoleCommand("spawnmenu_reload") end) -- Bedke kichme espasenk minchevor command-e update ela
		end
	panel:AddPanel(langCombo)
	panel:ControlHelp("* stands for unfinished translation!")
	panel:CheckBox("#vjbase.menu.settings.client.lang.auto", "vj_language_auto")
	panel:ControlHelp("#vjbase.menu.settings.client.lang.auto.label")
end
----=================================----
local function VJ_MAIN_CLEANUP(panel)
	if !game.SinglePlayer() && !LocalPlayer():IsAdmin() then
		panel:Help("#vjbase.menu.general.admin.not")
		panel:Help("#vjbase.menu.general.admin.only")
		return
	end
	panel:Help("#vjbase.menu.general.admin.only")
	panel:Button("#vjbase.menu.cleanup.all", "vj_run_cleanup")
	panel:Button("#vjbase.menu.cleanup.sounds", "stopsound")
	panel:Button("#vjbase.menu.cleanup.remove.npcs.vj", "vj_run_cleanup", "vjnpcs")
	panel:Button("#vjbase.menu.cleanup.remove.npcs", "vj_run_cleanup", "npcs")
	panel:Button("#vjbase.menu.cleanup.remove.spawners", "vj_run_cleanup", "spawners")
	panel:Button("#vjbase.menu.cleanup.remove.corpses", "vj_run_cleanup", "corpses")
	panel:Button("#vjbase.menu.cleanup.remove.gibs", "vj_run_cleanup", "gibs")
	panel:Button("#vjbase.menu.cleanup.remove.groundweapons", "vj_run_cleanup", "groundweapons")
	panel:Button("#vjbase.menu.cleanup.remove.props", "vj_run_cleanup", "props")
	panel:Button("#vjbase.menu.cleanup.remove.decals", "vj_run_cleanup", "decals")
	panel:Button("#vjbase.menu.cleanup.remove.ply.weapons", "vj_run_cleanup", "allweapons")
	panel:Button("#vjbase.menu.cleanup.remove.ply.ammo", "vj_run_cleanup", "allammo")
end
----=================================----
local function VJ_MAIN_CONTACT(panel)
	local incompButton = vgui.Create("DButton") -- Incompatible Addons
		incompButton:SetFont("CloseCaption_Bold")
		incompButton:SetText("#vjbase.menu.contact.incompatible")
		incompButton:SetSize(150, 35)
		incompButton:SetColor(Color(231, 76, 60))
		incompButton:SetFont("VJBaseSmallMedium")
		function incompButton:DoClick()
			gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=1129493108")
		end
	panel:AddPanel(incompButton)

	panel:ControlHelp(" ") -- Spacer

	local gitButton = vgui.Create("DButton") -- GitHub
		gitButton:SetFont("TargetID")
		gitButton:SetText("#vjbase.menu.contact.github")
		gitButton:SetSize(150, 25)
		gitButton:SetColor(Color(0, 0, 0))
		gitButton:SetFont("VJBaseSmallMedium")
		function gitButton:DoClick()
			gui.OpenURL("https://github.com/DrVrej/VJ-Base")
		end
	panel:AddPanel(gitButton)
	
	local docButton = vgui.Create("DButton") -- Documentation
		docButton:SetFont("TargetID")
		docButton:SetText("#vjbase.menu.contact.documentation")
		docButton:SetSize(150, 25)
		docButton:SetColor(Color(0, 0, 0))
		docButton:SetFont("VJBaseSmallMedium")
		function docButton:DoClick()
			gui.OpenURL("https://drvrej.com/project/vjbase/")
		end
	panel:AddPanel(docButton)
	
	local changelogButton = vgui.Create("DButton") -- Change Logs
		changelogButton:SetFont("TargetID")
		changelogButton:SetText("#vjbase.menu.contact.changelogs")
		changelogButton:SetSize(150, 25)
		changelogButton:SetColor(Color(0, 0, 0))
		changelogButton:SetFont("VJBaseSmallMedium")
		function changelogButton:DoClick()
			gui.OpenURL("https://github.com/DrVrej/VJ-Base/releases")
		end
	panel:AddPanel(changelogButton)
	
	panel:ControlHelp(" ") -- Spacer

	local discordButton = vgui.Create("DButton") -- Discord
		discordButton:SetFont("TargetID")
		discordButton:SetText("#vjbase.menu.contact.discord")
		discordButton:SetSize(150, 25)
		discordButton:SetColor(Color(0, 102, 0))
		discordButton:SetFont("VJBaseSmallMedium")
		function discordButton:DoClick()
			gui.OpenURL("https://discord.gg/zwQjrdG")
		end
	panel:AddPanel(discordButton)
	
	local steamButton = vgui.Create("DButton") -- Steam Group
		steamButton:SetFont("TargetID")
		steamButton:SetText("#vjbase.menu.contact.steam")
		steamButton:SetSize(150, 25)
		steamButton:SetColor(Color(0, 102, 0))
		steamButton:SetFont("VJBaseSmallMedium")
		function steamButton:DoClick()
			gui.OpenURL("http://steamcommunity.com/groups/vrejgaming")
		end
	panel:AddPanel(steamButton)

	local youtubeButton = vgui.Create("DButton") -- YouTube
		youtubeButton:SetFont("TargetID")
		youtubeButton:SetText("#vjbase.menu.contact.youtube")
		youtubeButton:SetSize(150, 25)
		youtubeButton:SetColor(Color(0, 102, 0))
		youtubeButton:SetFont("VJBaseSmallMedium")
		function youtubeButton:DoClick()
			gui.OpenURL("http://www.youtube.com/user/gmod95")
		end
	panel:AddPanel(youtubeButton)

	local twitterButton = vgui.Create("DButton") -- Twitter
		twitterButton:SetFont("TargetID")
		twitterButton:SetText("#vjbase.menu.contact.twitter")
		twitterButton:SetSize(150, 25)
		twitterButton:SetColor(Color(0, 102, 0))
		twitterButton:SetFont("VJBaseSmallMedium")
		function twitterButton:DoClick()
			gui.OpenURL("http://twitter.com/vrejgaming")
		end
	panel:AddPanel(twitterButton)

	panel:ControlHelp(" ") -- Spacer
	
	local patreonButton = vgui.Create("DButton") -- patreon
		patreonButton:SetFont("TargetID")
		patreonButton:SetText("#vjbase.menu.contact.patreon")
		patreonButton:SetSize(150, 30)
		patreonButton:SetColor(Color(0, 0, 102))
		patreonButton:SetFont("VJBaseSmallMedium")
		function patreonButton:DoClick()
			gui.OpenURL("https://www.patreon.com/drvrej")
		end
	panel:AddPanel(patreonButton)
	panel:ControlHelp("#vjbase.menu.contact.patreon.label")

	/*HTMLTest = vgui.Create("HTML")
	HTMLTest:SetPos(50, 50)
	HTMLTest:SetSize(ScrW() - 100, ScrH() - 100)
	HTMLTest:OpenURL("http://steamcommunity.com/sharedfiles/filedetails/?id=131759821")	*/
	//panel:AddPanel(HTMLTest)
end
----=================================----
local function VJ_MAIN_SERVER(panel)
	if !game.SinglePlayer() && !LocalPlayer():IsAdmin() then
		panel:Help("#vjbase.menu.general.admin.not")
		panel:Help("#vjbase.menu.general.admin.only")
		return
	end
	panel:Help("#vjbase.menu.general.admin.only")
	panel:Help("#vjbase.menu.settings.server.label")
	panel:AddControl("Button", {Text = "#vjbase.menu.general.reset.everything", Command = "vj_npc_admin_properties 0\n sbox_noclip 1\n sbox_weapons 1\n sbox_playershurtplayers 1\n sbox_godmode 0\n sv_gravity 600\n host_timescale 1\n phys_timescale 1"})
	panel:CheckBox("#vjbase.menu.settings.server.admin.npcproperties", "vj_npc_admin_properties")
	panel:CheckBox("#vjbase.menu.settings.server.noclip", "sbox_noclip")
	panel:CheckBox("#vjbase.menu.settings.server.weapons", "sbox_weapons")
	panel:CheckBox("#vjbase.menu.settings.server.pvp", "sbox_playershurtplayers")
	panel:CheckBox("#vjbase.menu.settings.server.godmode", "sbox_godmode")
	panel:CheckBox("#vjbase.menu.settings.server.bonemanip.npcs", "sbox_bonemanip_npc")
	panel:CheckBox("#vjbase.menu.settings.server.bonemanip.players", "sbox_bonemanip_player")
	panel:CheckBox("#vjbase.menu.settings.server.bonemanip.others", "sbox_bonemanip_misc")
	panel:NumSlider("#vjbase.menu.settings.server.timescale.general", "host_timescale", 0.1, 10, 2)
	panel:NumSlider("#vjbase.menu.settings.server.timescale.physics", "phys_timescale", 0, 2, 2)
	panel:NumSlider("#vjbase.menu.settings.server.gravity", "sv_gravity", -200, 600, 2)
end
----=================================----
local function VJ_MAIN_PLUGINS(panel)
	local numPlugins = #VJ.Plugins
	
	panel:Help("#vjbase.menu.plugins.label")
	panel:ControlHelp(language.GetPhrase("#vjbase.menu.plugins.version") .. " " .. VJBASE_VERSION) -- Main Number / Version / Patches
	panel:ControlHelp(language.GetPhrase("#vjbase.menu.plugins.total") .. " " .. numPlugins)
	
	local pluginList = vgui.Create("DListView")
		//pluginList:Center() -- No need since Size does it already
		pluginList:SetSize(100, 300)
		pluginList:SetMultiSelect(false)
		pluginList:AddColumn("#vjbase.menu.plugins.header.name")
		pluginList:AddColumn("#vjbase.menu.plugins.header.type"):SetFixedWidth(50)
		pluginList:AddColumn("#vjbase.menu.plugins.header.version"):SetFixedWidth(50)
		if VJ.Plugins then
			for _, v in SortedPairsByMemberValue(VJ.Plugins, "Name") do
				pluginList:AddLine(v.Name, v.Type, v.Version)
			end
		else
			pluginList:AddLine("#vjbase.menu.plugins.none", "", "")
		end
		function pluginList:OnRowSelected(rowIndex, row)
			//surface.PlaySound("vj_base/player/illuminati.mp3")
			chat.AddText(colorYellow, language.GetPhrase("#vjbase.menu.plugins.chat.name") .. " " .. row:GetValue(1))
			chat.AddText(colorYellow, language.GetPhrase("#vjbase.menu.plugins.chat.type") .. " " .. row:GetValue(2))
			chat.AddText(colorYellow, language.GetPhrase("#vjbase.menu.plugins.chat.version") .. " " .. row:GetValue(3))
		end
	panel:AddItem(pluginList)
	
	-- Changelog for VJ Base
	local changelogButton = vgui.Create("DButton")
		changelogButton:SetFont("TargetID")
		changelogButton:SetText("#vjbase.menu.plugins.changelog")
		changelogButton:SetSize(150, 25)
		changelogButton:SetColor(Color(0, 102, 0))
		changelogButton:SetFont("VJBaseSmallMedium")
		function changelogButton:DoClick()
			gui.OpenURL("https://github.com/DrVrej/VJ-Base/releases")
		end
	panel:AddPanel(changelogButton)
	
	-- Github Wiki
	local gitButton = vgui.Create("DButton")
		gitButton:SetFont("TargetID")
		gitButton:SetText("#vjbase.menu.plugins.makeaddon")
		gitButton:SetSize(150, 25)
		gitButton:SetColor(Color(0, 0, 102))
		gitButton:SetFont("VJBaseSmallMedium")
		function gitButton:DoClick()
			gui.OpenURL("https://drvrej.com/project/vjbase/")
		end
	panel:AddPanel(gitButton)
	
	-- Tutorial Video
	local tutorialButton = vgui.Create("DButton")
		tutorialButton:SetFont("TargetID")
		tutorialButton:SetText("#vjbase.menu.general.tutorial.vid")
		tutorialButton:SetSize(150, 25)
		tutorialButton:SetColor(Color(0, 0, 102))
		tutorialButton:SetFont("VJBaseSmallMedium")
		function tutorialButton:DoClick()
			gui.OpenURL("https://www.youtube.com/watch?v=dGoqEpFZ5_M")
		end
	panel:AddPanel(tutorialButton)
end
----=================================----
hook.Add("PopulateToolMenu", "VJ_ADDTOMENU_MAIN", function()
	spawnmenu.AddToolMenuOption("DrVrej", "Main", "vj_menu_plugins", "#vjbase.menu.plugins", "", "", VJ_MAIN_PLUGINS)
	spawnmenu.AddToolMenuOption("DrVrej", "Main", "vj_menu_info", "#vjbase.menu.info", "", "", VJ_MAIN_INFO)
	spawnmenu.AddToolMenuOption("DrVrej", "Main", "vj_menu_settings_cl", "#vjbase.menu.settings.client", "", "", VJ_MAIN_CLIENT)
	spawnmenu.AddToolMenuOption("DrVrej", "Main", "vj_menu_cleanup", "#vjbase.menu.cleanup", "", "", VJ_MAIN_CLEANUP)
	spawnmenu.AddToolMenuOption("DrVrej", "Main", "vj_menu_contact", "#vjbase.menu.contact", "", "", VJ_MAIN_CONTACT)
	spawnmenu.AddToolMenuOption("DrVrej", "Main", "vj_menu_settings_sv", "#vjbase.menu.settings.server", "", "", VJ_MAIN_SERVER)
end)