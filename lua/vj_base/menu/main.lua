/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
if !CLIENT then return end
local colorBlue = Color(30, 200, 255)
local colorYellow = Color(255, 215, 0)
local colorBlack = Color(0, 0, 0)
local colorRed = Color(231, 76, 60)
local colorDarkGreen = Color(0, 102, 0)
local colorDarkBlue = Color(0, 0, 102)
--
local function VJ_MAIN_ABOUT(panel)
	panel:Help("VJ Base, short for Vrej Base, was established in 2012 with the aim of assisting in the development of various addons. It is popularly used to create scripted NPCs.")

	local gitButton = vgui.Create("DButton")
		gitButton:SetFont("TargetID")
		gitButton:SetText("#vjbase.menu.about.github")
		gitButton:SetSize(150, 25)
		gitButton:SetColor(colorBlack)
		gitButton:SetFont("VJBaseSmallMedium")
		function gitButton:DoClick()
			gui.OpenURL("https://github.com/DrVrej/VJ-Base")
		end
	panel:AddPanel(gitButton)
	
	local docButton = vgui.Create("DButton")
		docButton:SetFont("TargetID")
		docButton:SetText("#vjbase.menu.about.documentation")
		docButton:SetSize(150, 25)
		docButton:SetColor(colorBlack)
		docButton:SetFont("VJBaseSmallMedium")
		function docButton:DoClick()
			gui.OpenURL("https://drvrej.com/project/vjbase/")
		end
	panel:AddPanel(docButton)
	
	local changelogButton = vgui.Create("DButton")
		changelogButton:SetFont("TargetID")
		changelogButton:SetText("#vjbase.menu.about.changelogs")
		changelogButton:SetSize(150, 25)
		changelogButton:SetColor(colorBlack)
		changelogButton:SetFont("VJBaseSmallMedium")
		function changelogButton:DoClick()
			gui.OpenURL("https://github.com/DrVrej/VJ-Base/releases")
		end
	panel:AddPanel(changelogButton)
	
	local incompButton = vgui.Create("DButton")
		incompButton:SetFont("CloseCaption_Bold")
		incompButton:SetText("#vjbase.menu.about.incompatible")
		incompButton:SetSize(150, 30)
		incompButton:SetColor(colorRed)
		incompButton:SetFont("VJBaseSmallMedium")
		function incompButton:DoClick()
			gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=1129493108")
		end
	panel:AddPanel(incompButton)
	
	panel:ControlHelp(" ") -- Spacer

	local discordButton = vgui.Create("DButton")
		discordButton:SetFont("TargetID")
		discordButton:SetText("#vjbase.menu.about.discord")
		discordButton:SetSize(150, 25)
		discordButton:SetColor(colorDarkGreen)
		discordButton:SetFont("VJBaseSmallMedium")
		function discordButton:DoClick()
			gui.OpenURL("https://discord.gg/zwQjrdG")
		end
	panel:AddPanel(discordButton)
	
	local steamButton = vgui.Create("DButton")
		steamButton:SetFont("TargetID")
		steamButton:SetText("#vjbase.menu.about.steam")
		steamButton:SetSize(150, 25)
		steamButton:SetColor(colorDarkGreen)
		steamButton:SetFont("VJBaseSmallMedium")
		function steamButton:DoClick()
			gui.OpenURL("https://steamcommunity.com/groups/vrejgaming")
		end
	panel:AddPanel(steamButton)

	local youtubeButton = vgui.Create("DButton")
		youtubeButton:SetFont("TargetID")
		youtubeButton:SetText("#vjbase.menu.about.youtube")
		youtubeButton:SetSize(150, 25)
		youtubeButton:SetColor(colorDarkGreen)
		youtubeButton:SetFont("VJBaseSmallMedium")
		function youtubeButton:DoClick()
			gui.OpenURL("https://www.youtube.com/@VrejGaming")
		end
	panel:AddPanel(youtubeButton)
	
	local patreonButton = vgui.Create("DButton")
		patreonButton:SetFont("TargetID")
		patreonButton:SetText("#vjbase.menu.about.patreon")
		patreonButton:SetSize(150, 30)
		patreonButton:SetColor(colorDarkBlue)
		patreonButton:SetFont("VJBaseSmallMedium")
		function patreonButton:DoClick()
			gui.OpenURL("https://www.patreon.com/drvrej")
		end
	panel:AddPanel(patreonButton)
	panel:ControlHelp("#vjbase.menu.about.patreon.label")
	
	panel:ControlHelp(" ") -- Spacer
	
	local ply = LocalPlayer()
	local labelGame = panel:Help("Game Details:")
	labelGame:SetFont("VJBaseTinySmall")
	panel:Help("┏ Date - " .. os.date("%b %d, %Y | %I:%M %p"))
	panel:Help("┣ Name - " .. ply:Nick() .. " | " .. ply:SteamID())
	panel:Help("┣ VJ Base - " .. VJBASE_VERSION .. " | " .. #VJ.Plugins .. " plugins | " .. GetConVar("vj_language"):GetString())
	panel:Help("┣ Session - " .. (game.SinglePlayer() and "SinglePlayer" or "Multiplayer") .. " | " .. gmod.GetGamemode().Name .. " | " .. game.GetMap())
	panel:Help("┣ System - " .. (system.IsLinux() and "Linux" or (system.IsOSX() and "OSX" or "Windows")) .. " | " .. ScrW() .. "x" .. ScrH()) // system.IsWindows()
	local mountedGames = ""
	local mountedNum = 0
	for _, g in ipairs(engine.GetGames()) do
		if g.mounted then
			mountedGames = mountedGames .. (mountedNum == 0 and "" or ", ") .. g.title
			mountedNum = mountedNum + 1
		end
	end
	panel:Help("┗ Mounted Games (" .. tostring(mountedNum) .. ") - " .. mountedGames)
	
	local labelCredits = panel:Help("Credits:")
	labelCredits:SetFont("VJBaseTinySmall")
	panel:Help("┏ DrVrej (Me) - Author")
	panel:Help("┣ Cpt. Hazama - Various contributions, suggestions, testing")
	panel:Help("┣ Darkborn - Suggestions, testing")
	panel:Help("┣ Oteek - Blood pool textures, testing")
	panel:Help("┣ Orion - Helped with the first build (2011-2012)")
	panel:Help("┣ BOO342 - Original campfire model")
	panel:Help("┣ China-Mandem - Original K-3 model")
	panel:Help("┣ Crowbar Collective - Original gib models, blood pool texture, Glock-17 model")
	panel:Help("┗ Valve - Various assets")
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
			chat.AddText(colorYellow, "#vjbase.menu.settings.client.lang.notify", " ", colorBlue, value)
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
	local plugins = VJ.Plugins
	
	panel:Help("#vjbase.menu.plugins.label")
	panel:ControlHelp(language.GetPhrase("#vjbase.menu.plugins.version") .. " " .. VJBASE_VERSION)
	panel:ControlHelp(language.GetPhrase("#vjbase.menu.plugins.total") .. " " .. #plugins)
	
	local pluginList = vgui.Create("DListView")
		pluginList:SetSize(100, 300)
		pluginList:SetMultiSelect(false)
		pluginList:AddColumn("#vjbase.menu.plugins.header.name")
		pluginList:AddColumn("#vjbase.menu.plugins.header.type"):SetFixedWidth(50)
		pluginList:AddColumn("#vjbase.menu.plugins.header.version"):SetFixedWidth(50)
		if plugins then
			for _, v in SortedPairsByMemberValue(plugins, "Name") do
				local row = pluginList:AddLine(v.Name, v.Type, v.Version)
				row:SetTooltip(language.GetPhrase("#vjbase.menu.plugins.chat.name") .. " " .. row:GetValue(1) .. "\n" .. language.GetPhrase("#vjbase.menu.plugins.chat.type") .. " " .. row:GetValue(2) .. "\n" .. language.GetPhrase("#vjbase.menu.plugins.chat.version") .. " " .. row:GetValue(3))
			end
		else
			pluginList:AddLine("#vjbase.menu.plugins.none", "", "")
		end
	panel:AddItem(pluginList)
	
	-- Changelog
	local changelogButton = vgui.Create("DButton")
		changelogButton:SetFont("TargetID")
		changelogButton:SetText("#vjbase.menu.plugins.changelog")
		changelogButton:SetSize(150, 25)
		changelogButton:SetColor(colorDarkGreen)
		changelogButton:SetFont("VJBaseSmallMedium")
		function changelogButton:DoClick()
			gui.OpenURL("https://github.com/DrVrej/VJ-Base/releases")
		end
	panel:AddPanel(changelogButton)
	
	-- Documentation
	local docButton = vgui.Create("DButton")
		docButton:SetFont("TargetID")
		docButton:SetText("#vjbase.menu.plugins.makeaddon")
		docButton:SetSize(150, 25)
		docButton:SetColor(colorDarkBlue)
		docButton:SetFont("VJBaseSmallMedium")
		function docButton:DoClick()
			gui.OpenURL("https://drvrej.com/project/vjbase/")
		end
	panel:AddPanel(docButton)
	
	-- Tutorial Video
	local tutorialButton = vgui.Create("DButton")
		tutorialButton:SetFont("TargetID")
		tutorialButton:SetText("#vjbase.menu.general.tutorial.vid")
		tutorialButton:SetSize(150, 25)
		tutorialButton:SetColor(colorDarkBlue)
		tutorialButton:SetFont("VJBaseSmallMedium")
		function tutorialButton:DoClick()
			gui.OpenURL("https://www.youtube.com/watch?v=dGoqEpFZ5_M")
		end
	panel:AddPanel(tutorialButton)
end
----=================================----
hook.Add("PopulateToolMenu", "VJ_ADDTOMENU_MAIN", function()
	spawnmenu.AddToolMenuOption("DrVrej", "Main", "vj_menu_plugins", "#vjbase.menu.plugins", "", "", VJ_MAIN_PLUGINS)
	spawnmenu.AddToolMenuOption("DrVrej", "Main", "vj_menu_about", "#vjbase.menu.about", "", "", VJ_MAIN_ABOUT)
	spawnmenu.AddToolMenuOption("DrVrej", "Main", "vj_menu_cleanup", "#vjbase.menu.cleanup", "", "", VJ_MAIN_CLEANUP)
	spawnmenu.AddToolMenuOption("DrVrej", "Main", "vj_menu_settings_sv", "#vjbase.menu.settings.server", "", "", VJ_MAIN_SERVER)
	spawnmenu.AddToolMenuOption("DrVrej", "Main", "vj_menu_settings_cl", "#vjbase.menu.settings.client", "", "", VJ_MAIN_CLIENT)
end)