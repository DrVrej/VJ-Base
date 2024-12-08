/*--------------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
---------------------------------------------------------------------------------------------------------------------------------------------
local function VJ_NPC_OPTIONS(Panel)
	if !game.SinglePlayer() && !LocalPlayer():IsAdmin() then
		Panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.not"})
		Panel:AddControl( "Label", {Text = "#vjbase.menu.general.admin.only"})
		return
	end
	
	Panel:AddControl( "Label", {Text = "#vjbase.menu.general.admin.only"})
	Panel:AddControl("Label", {Text = "#vjbase.menu.general.snpc.warnfuture"})
	Panel:AddControl("Button",{Text = "#vjbase.menu.general.reset.everything", Command = "vj_npc_godmodesnpc 0\nvj_npc_playerfriendly 0\nvj_npc_zombiefriendly 0\nvj_npc_antlionfriendly 0\nvj_npc_combinefriendly 0\nvj_npc_corpsefade 0\nvj_npc_corpsefadetime 10\nvj_npc_undocorpse 0\nvj_npc_allhealth 0\nvj_npc_fadegibs 1\nvj_npc_fadegibstime 90\nvj_npc_gibcollidable 0\nvj_npc_addfrags 1\nvj_npc_dropweapon 1\nvj_npc_droploot 1\nvj_npc_creatureopendoor 1\nvj_npc_vjfriendly 0\nvj_npc_globalcorpselimit 32\nvj_npc_seedistance 0\nvj_npc_usegmoddecals 0\nvj_npc_knowenemylocation 0\nvj_npc_plypickupdropwep 1\nvj_npc_difficulty 0\nvj_npc_human_canjump 1\nvj_npc_corpsecollision 0"})
	local vj_difficulty = {Options = {}, CVars = {}, Label = "#vjbase.menu.npc.options.difficulty.header", MenuButton = "0"}
		vj_difficulty.Options["#vjbase.menu.npc.options.difficulty.neanderthal"] = {vj_npc_difficulty = "-3"}
		vj_difficulty.Options["#vjbase.menu.npc.options.difficulty.childs_play"] = {vj_npc_difficulty = "-2"}
		vj_difficulty.Options["#vjbase.menu.npc.options.difficulty.easy"] = {vj_npc_difficulty = "-1"}
		vj_difficulty.Options["#vjbase.menu.npc.options.difficulty.normal"] = {vj_npc_difficulty = "0"}
		vj_difficulty.Options["#vjbase.menu.npc.options.difficulty.hard"] = {vj_npc_difficulty = "1"}
		vj_difficulty.Options["#vjbase.menu.npc.options.difficulty.insane"] = {vj_npc_difficulty = "2"}
		vj_difficulty.Options["#vjbase.menu.npc.options.difficulty.impossible"] = {vj_npc_difficulty = "3"}
		vj_difficulty.Options["#vjbase.menu.npc.options.difficulty.nightmare"] = {vj_npc_difficulty = "4"}
		vj_difficulty.Options["#vjbase.menu.npc.options.difficulty.hell_on_earth"] = {vj_npc_difficulty = "5"}
		vj_difficulty.Options["#vjbase.menu.npc.options.difficulty.total_annihilation"] = {vj_npc_difficulty = "6"}
	Panel:AddControl("ComboBox", vj_difficulty)
	
	Panel:AddControl("Label", {Text = "#vjbase.menu.npc.options.label1"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.options.togglefriendlyantlion", Command = "vj_npc_antlionfriendly"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.options.togglefriendlycombine", Command = "vj_npc_combinefriendly"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.options.togglefriendlyplayer", Command = "vj_npc_playerfriendly"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.options.togglefriendlyzombie", Command = "vj_npc_zombiefriendly"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.options.togglefriendlyvj", Command = "vj_npc_vjfriendly"})
	Panel:ControlHelp("#vjbase.menu.npc.options.label2")
	
	Panel:AddControl("Label", {Text = "#vjbase.menu.npc.options.label3"})
	local vj_collision = {Options = {}, CVars = {}, Label = "#vjbase.menu.npc.options.collision.header", MenuButton = "0"}
		vj_collision.Options["#vjbase.menu.npc.options.collision.default"] = {vj_npc_corpsecollision = "0"}
		vj_collision.Options["#vjbase.menu.npc.options.collision.everything"] = {vj_npc_corpsecollision = "1"}
		vj_collision.Options["#vjbase.menu.npc.options.collision.onlyworld"] = {vj_npc_corpsecollision = "2"}
		vj_collision.Options["#vjbase.menu.npc.options.collision.excludedebris"] = {vj_npc_corpsecollision = "3"}
		vj_collision.Options["#vjbase.menu.npc.options.collision.excludeplynpcs"] = {vj_npc_corpsecollision = "4"}
		vj_collision.Options["#vjbase.menu.npc.options.collision.excludeply"] = {vj_npc_corpsecollision = "5"}
	Panel:AddControl("ComboBox", vj_collision)
	Panel:AddControl("Slider",{Label = "#vjbase.menu.npc.options.corpselimit",min = 4,max = 300,Command = "vj_npc_globalcorpselimit"})
	Panel:ControlHelp("#vjbase.menu.npc.options.label4")
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.options.toggleundocorpses", Command = "vj_npc_undocorpse"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.options.togglecorpsefade", Command = "vj_npc_corpsefade"})
	Panel:AddControl("Slider",{Label = "#vjbase.menu.npc.options.corpsefadetime",min = 0,max = 600,Command = "vj_npc_corpsefadetime"})
	Panel:ControlHelp("#vjbase.menu.npc.options.label5")
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.options.togglegibcollision", Command = "vj_npc_gibcollidable"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.options.togglefadegibs", Command = "vj_npc_fadegibs"})
	Panel:AddControl("Slider",{Label = "#vjbase.menu.npc.options.gibfadetime",min = 0,max = 600,Command = "vj_npc_fadegibstime"})
	Panel:ControlHelp("#vjbase.menu.npc.options.label6")
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.options.togglesnpcgodmode", Command = "vj_npc_godmodesnpc"})
	//Panel:AddControl("Slider", {Label = "Health Changer",min = 0,max = 10000,Command = "vj_npc_allhealth"})
	Panel:AddControl("TextBox", {Label = "#vjbase.menu.npc.options.health", Command = "vj_npc_allhealth", WaitForEnter = "0"})
	Panel:ControlHelp("#vjbase.menu.npc.options.defaulthealth")
	
	Panel:AddControl("Label", {Text = "#vjbase.menu.npc.options.label7"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.options.toggleknowenemylocation", Command = "vj_npc_knowenemylocation"})
	Panel:AddControl("TextBox", {Label = "#vjbase.menu.npc.options.sightdistance", Command = "vj_npc_seedistance", WaitForEnter = "0"})
	Panel:ControlHelp("#vjbase.menu.npc.options.label8")
	
	Panel:AddControl("Label", {Text = "#vjbase.menu.npc.options.label10"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.options.togglegmoddecals", Command = "vj_npc_usegmoddecals"})
	Panel:ControlHelp("#vjbase.menu.npc.options.label11")
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.options.togglecreatureopendoor", Command = "vj_npc_creatureopendoor"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.options.togglehumanscanjump", Command = "vj_npc_human_canjump"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.options.toggleitemdrops", Command = "vj_npc_droploot"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.options.togglehumansdropweapon", Command = "vj_npc_dropweapon"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.options.toggleplydroppedweapons", Command = "vj_npc_plypickupdropwep"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.options.toggleaddfrags", Command = "vj_npc_addfrags"})
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function VJ_NPC_SETTINGS(Panel)
	if !game.SinglePlayer() && !LocalPlayer():IsAdmin() then
		Panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.not"})
		Panel:AddControl( "Label", {Text = "#vjbase.menu.general.admin.only"})
		return
	end

	Panel:AddControl( "Label", {Text = "#vjbase.menu.general.admin.only"})
	Panel:AddControl("Label", {Text = "#vjbase.menu.general.snpc.warnfuture"})
	Panel:AddControl("Button",{Text = "#vjbase.menu.general.reset.everything", Command = "vj_npc_nocorpses 0\nvj_npc_nobleed 0\nvj_npc_nomelee 0\nvj_npc_norange 0\nvj_npc_noleap 0\nvj_npc_noflinching 0\nvj_npc_noallies 0\nvj_npc_noweapon 0\nvj_npc_nowandering 0\nvj_npc_nogib 0\nvj_npc_nodeathanimation 0\nvj_npc_nodangerdetection 0\nvj_npc_no_runontouch 0\nvj_npc_no_runonhit 0\nvj_npc_slowplayer 0\nvj_npc_bleedenemyonmelee 0\nvj_npc_noproppush 0\nvj_npc_nopropattack 0\nvj_npc_novfx_gibdeath 0\nvj_npc_noidleparticle 0\nvj_npc_noreload 0\nvj_npc_nobecomeenemytoply 0\nvj_npc_nofollowplayer 0\nvj_npc_nothrowgrenade 0\nvj_npc_nobloodpool 0\nvj_npc_nochasingenemy 0\nvj_npc_nosnpcchat 0\nvj_npc_nomedics 0\nvj_npc_nomeleedmgdsp 0\nvj_npc_nocallhelp 0\nvj_npc_noeating 0\nvj_npc_noinvestigate 0"})
	
	Panel:AddControl("Label", {Text = "#vjbase.menu.npc.settings.title.ai"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.togglewandering", Command = "vj_npc_nowandering"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.togglechasingenemy", Command = "vj_npc_nochasingenemy"})
	Panel:ControlHelp("#vjbase.menu.npc.settings.help.chasingenemy")
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.togglemedics", Command = "vj_npc_nomedics"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.togglefollowplayer", Command = "vj_npc_nofollowplayer"})
	Panel:ControlHelp("#vjbase.menu.npc.settings.help.followplayer")
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.toggleallies", Command = "vj_npc_noallies"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.togglebecomeenemytoply", Command = "vj_npc_nobecomeenemytoply"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.togglecallhelp", Command = "vj_npc_nocallhelp"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.toggleinvestigate", Command = "vj_npc_noinvestigate"})
	Panel:ControlHelp("#vjbase.menu.npc.settings.help.investigate")
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.toggleproppush", Command = "vj_npc_noproppush"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.togglepropattack", Command = "vj_npc_nopropattack"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.toggledangersight", Command = "vj_npc_nodangerdetection"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.togglereloading", Command = "vj_npc_noreload"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.toggleeating", Command = "vj_npc_noeating"})
	
	Panel:AddControl("Label", {Text = "#vjbase.menu.npc.settings.title.attack"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.togglemelee", Command = "vj_npc_nomelee"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.togglerange", Command = "vj_npc_norange"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.toggleleap", Command = "vj_npc_noleap"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.togglethrownade", Command = "vj_npc_nothrowgrenade"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.toggleweapons", Command = "vj_npc_noweapon"})
	Panel:ControlHelp("#vjbase.menu.npc.settings.help.noweapon")
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.togglemeleedsp", Command = "vj_npc_nomeleedmgdsp"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.toggleslowplayer", Command = "vj_npc_slowplayer"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.togglebleedonmelee", Command = "vj_npc_bleedenemyonmelee"})
	
	Panel:AddControl("Label", {Text = "#vjbase.menu.npc.settings.title.misc"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.toggleidleparticles", Command = "vj_npc_noidleparticle"})
	Panel:ControlHelp("#vjbase.menu.npc.settings.help.idleparticles")
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.togglesnpcchat", Command = "vj_npc_nosnpcchat"})
	Panel:ControlHelp("#vjbase.menu.npc.settings.help.npcchat")
	
	Panel:AddControl("Label", {Text = "#vjbase.menu.npc.settings.title.damagecorpse"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.toggleflinching", Command = "vj_npc_noflinching"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.togglebleeding", Command = "vj_npc_nobleed"})
	Panel:ControlHelp("#vjbase.menu.npc.settings.help.bleeding")
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.togglebloodpool", Command = "vj_npc_nobloodpool"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.togglegib", Command = "vj_npc_nogib"})
	Panel:ControlHelp("#vjbase.menu.npc.settings.help.gib")
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.togglegibdeathvfx", Command = "vj_npc_novfx_gibdeath"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.toggledeathanim", Command = "vj_npc_nodeathanimation"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.togglecorpses", Command = "vj_npc_nocorpses"})
	
	Panel:AddControl("Label", {Text = "#vjbase.menu.npc.settings.title.passive"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.togglerunontouch", Command = "vj_npc_no_runontouch"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.togglerunonhit", Command = "vj_npc_no_runonhit"})
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function VJ_NPC_SETTINGS_SOUND(Panel)
	if !game.SinglePlayer() && !LocalPlayer():IsAdmin() then
		Panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.not"})
		Panel:AddControl( "Label", {Text = "#vjbase.menu.general.admin.only"})
		return
	end
	
	Panel:AddControl( "Label", {Text = "#vjbase.menu.general.admin.only"})
	Panel:AddControl("Label", {Text = "#vjbase.menu.general.snpc.warnfuture"})
	Panel:AddControl("Button",{Text = "#vjbase.menu.general.reset.everything", Command = "vj_npc_sd_nosounds 0\n vj_npc_sd_idle 0\n vj_npc_sd_alert 0\n vj_npc_sd_pain 0\n vj_npc_sd_death 0\n vj_npc_sd_footstep 0\n vj_npc_sd_soundtrack 0\n vj_npc_sd_meleeattack 0\n vj_npc_sd_rangeattack 0\n vj_npc_sd_leapattack 0\n vj_npc_sd_ondangersight 0\n vj_npc_sd_onplayersight 0\n vj_npc_sd_damagebyplayer 0\n vj_npc_sd_slowplayer 0\n vj_npc_sd_gibbing 0\n vj_npc_sd_breath 0\n vj_npc_sd_followplayer 0\n vj_npc_sd_becomenemytoply 0\n vj_npc_sd_medic 0\n vj_npc_sd_reload 0\n vj_npc_sd_grenadeattack 0\n vj_npc_sd_suppressing 0\n vj_npc_sd_callforhelp 0\n vj_npc_sd_onreceiveorder 0"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.sdsettings.toggleallsounds", Command = "vj_npc_sd_nosounds"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.sdsettings.togglesoundtrack", Command = "vj_npc_sd_soundtrack"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.sdsettings.toggleidle", Command = "vj_npc_sd_idle"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.sdsettings.togglebreathing", Command = "vj_npc_sd_breath"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.sdsettings.togglefootsteps", Command = "vj_npc_sd_footstep"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.sdsettings.toggleattacksounds", Command = "vj_npc_sd_meleeattack"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.sdsettings.togglerangeattack", Command = "vj_npc_sd_rangeattack"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.sdsettings.togglealert", Command = "vj_npc_sd_alert"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.sdsettings.togglepain", Command = "vj_npc_sd_pain"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.sdsettings.toggledeath", Command = "vj_npc_sd_death"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.sdsettings.togglegibbing", Command = "vj_npc_sd_gibbing"})
	Panel:ControlHelp("#vjbase.menu.npc.sdsettings.label1")
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.sdsettings.togglemedic", Command = "vj_npc_sd_medic"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.sdsettings.togglefollowing", Command = "vj_npc_sd_followplayer"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.sdsettings.togglecallhelp", Command = "vj_npc_sd_callforhelp"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.sdsettings.togglereceiveorder", Command = "vj_npc_sd_onreceiveorder"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.sdsettings.togglebecomeenemy", Command = "vj_npc_sd_becomenemytoply"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.sdsettings.toggleplayersight", Command = "vj_npc_sd_onplayersight"})
	Panel:ControlHelp("#vjbase.menu.npc.sdsettings.label2")
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.sdsettings.toggledmgbyplayer", Command = "vj_npc_sd_damagebyplayer"})
	Panel:ControlHelp("#vjbase.menu.npc.sdsettings.label3")
	
	Panel:AddControl("Label", {Text = "#vjbase.menu.general.snpc.creaturesettings"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.sdsettings.toggleleap", Command = "vj_npc_sd_leapattack"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.sdsettings.toggleslowedplayer", Command = "vj_npc_sd_slowplayer"})
	Panel:ControlHelp("#vjbase.menu.npc.sdsettings.label4")
	
	Panel:AddControl("Label", {Text = "#vjbase.menu.general.snpc.humansettings"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.sdsettings.togglegrenade", Command = "vj_npc_sd_grenadeattack"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.sdsettings.toggledangersight", Command = "vj_npc_sd_ondangersight"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.sdsettings.togglesuppressing", Command = "vj_npc_sd_suppressing"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.sdsettings.togglereload", Command = "vj_npc_sd_reload"})
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function VJ_NPC_SETTINGS_DEV(Panel)
	if !game.SinglePlayer() && !LocalPlayer():IsAdmin() then
		Panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.not"})
		Panel:AddControl( "Label", {Text = "#vjbase.menu.general.admin.only"})
		return
	end
	
	Panel:AddControl( "Label", {Text = "#vjbase.menu.general.admin.only"})
	Panel:AddControl("Label", {Text = "#vjbase.menu.npc.devsettings.label1"})
	Panel:AddControl("Label", {Text = "#vjbase.menu.npc.devsettings.label2"})
	Panel:AddControl("Button",{Text = "#vjbase.menu.general.reset.everything", Command = "vj_npc_debug_weapon 0\n vj_npc_debug_death 0\n vj_npc_debug_ondmg 0\n vj_npc_debug_ontouch 0\n vj_npc_debug_stopattacks 0\n vj_npc_debug_takingcover 0\n vj_npc_debug_resetenemy 0\n vj_npc_debug_lastseenenemytime 0\n vj_npc_debug 0\n vj_npc_debug_enemy 0\n vj_npc_debug_engine 0"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.devsettings.toggledev", Command = "vj_npc_debug"})
	Panel:ControlHelp("#vjbase.menu.npc.devsettings.label3")
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.devsettings.enginedebug", Command = "vj_npc_debug_engine"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.devsettings.printcurenemy", Command = "vj_npc_debug_enemy"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.devsettings.printlastseenenemy", Command = "vj_npc_debug_lastseenenemytime"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.devsettings.printonreset", Command = "vj_npc_debug_resetenemy"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.devsettings.printonstopattack", Command = "vj_npc_debug_stopattacks"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.devsettings.printtakingcover", Command = "vj_npc_debug_takingcover"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.devsettings.printondamage", Command = "vj_npc_debug_ondmg"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.devsettings.printondeath", Command = "vj_npc_debug_death"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.devsettings.printtouch", Command = "vj_npc_debug_ontouch"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.devsettings.printweaponinfo", Command = "vj_npc_debug_weapon"})
	Panel:AddControl("Button", {Label = "#vjbase.menu.npc.devsettings.cachedmodels", Command = "listmodels"})
	Panel:AddControl("Button", {Label = "#vjbase.menu.npc.devsettings.numofnpcs", Command = "vj_dev_numnpcs"})
	Panel:AddControl("Label", {Text = "#vjbase.menu.npc.devsettings.label4"})
	Panel:AddControl("Button", {Label = "#vjbase.menu.npc.devsettings.reloadsounds", Command = "snd_restart"})
	Panel:AddControl("Button", {Label = "#vjbase.menu.npc.devsettings.reloadmaterials", Command = "mat_reloadallmaterials"})
	Panel:AddControl("Button", {Label = "#vjbase.menu.npc.devsettings.reloadtextures", Command = "mat_reloadtextures"})
	Panel:AddControl("Button", {Label = "#vjbase.menu.npc.devsettings.reloadmodels", Command = "r_flushlod"})
	Panel:AddControl("Button", {Label = "#vjbase.menu.npc.devsettings.reloadspawnmenu", Command = "spawnmenu_reload"})
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function VJ_NPC_SETTINGS_CONTROLLER(Panel)
	Panel:AddControl("Label", {Text = "#vjbase.menu.npc.consettings.label1"})
	Panel:AddControl("Button",{Text = "#vjbase.menu.general.reset.everything", Command = "vj_npc_cont_hud 1\n vj_npc_cont_zoomdist 5\n vj_npc_cont_devents 0\n vj_npc_cont_cam_speed 6\n vj_npc_cont_cam_zoomspeed 10\n vj_npc_cont_diewithnpc 0"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.consettings.displayhud", Command = "vj_npc_cont_hud"})
	Panel:AddControl("Slider", {Label = "#vjbase.menu.npc.consettings.camzoomdistance", min = 5, max = 300, Command = "vj_npc_cont_zoomdist"})
	Panel:AddControl("Slider", {Label = "#vjbase.menu.npc.consettings.camzoomspeed", min = 1, max = 200, Command = "vj_npc_cont_cam_zoomspeed"})
	Panel:AddControl("Slider", {Label = "#vjbase.menu.npc.consettings.camspeed", min = 1, max = 180, Command = "vj_npc_cont_cam_speed"})
	Panel:ControlHelp("#vjbase.menu.npc.consettings.label2")
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.consettings.diewithnpc", Command = "vj_npc_cont_diewithnpc"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.consettings.displaydev", Command = "vj_npc_cont_devents"})
	
	Panel:AddControl("Label", {Text = "#vjbase.menu.npc.consettings.label3"})
	
	local ControlList = vgui.Create("DListView")
		ControlList:SetTooltip(false)
		ControlList:SetSize(100, 320)
		ControlList:SetMultiSelect(false)
		ControlList:AddColumn("#vjbase.menu.npc.consettings.bind.header1") -- Add column
		ControlList:AddColumn("#vjbase.menu.npc.consettings.bind.header2") -- Add column
			ControlList:AddLine("W A S D", "#vjbase.menu.npc.consettings.bind.movement")
			ControlList:AddLine("END", "#vjbase.menu.npc.consettings.bind.exitcontrol")
			ControlList:AddLine("FIRE1", "#vjbase.menu.npc.consettings.bind.meleeattack")
			ControlList:AddLine("FIRE2", "#vjbase.menu.npc.consettings.bind.rangeattack")
			ControlList:AddLine("JUMP", "#vjbase.menu.npc.consettings.bind.leaporgrenade")
			ControlList:AddLine("RELOAD", "#vjbase.menu.npc.consettings.bind.reloadweapon")
			ControlList:AddLine("T", "#vjbase.menu.npc.consettings.bind.togglebullseye")
			ControlList:AddLine("H", "#vjbase.menu.npc.consettings.bind.cameramode")
			ControlList:AddLine("J", "#vjbase.menu.npc.consettings.bind.movementjump")
			ControlList:AddLine("MOUSE WHEEL", "#vjbase.menu.npc.consettings.bind.camerazoom")
			ControlList:AddLine("UP ARROW", "#vjbase.menu.npc.consettings.bind.cameraforward")
			ControlList:AddLine("UP ARROW + RUN", "#vjbase.menu.npc.consettings.bind.cameraup")
			ControlList:AddLine("DOWN ARROW", "#vjbase.menu.npc.consettings.bind.camerabackward")
			ControlList:AddLine("DOWN ARROW + RUN", "#vjbase.menu.npc.consettings.bind.cameradown")
			ControlList:AddLine("LEFT ARROW", "#vjbase.menu.npc.consettings.bind.cameraleft")
			ControlList:AddLine("RIGHT ARROW", "#vjbase.menu.npc.consettings.bind.cameraright")
			ControlList:AddLine("BACKSPACE", "#vjbase.menu.npc.consettings.bind.resetzoom")
		ControlList.OnRowSelected = function(panel, rowIndex, row)
			chat.AddText(Color(0,255,0), language.GetPhrase("#vjbase.menu.npc.consettings.bind.clickmsg1").." ", Color(255,255,0), row:GetValue(1), Color(0,255,0), " | "..language.GetPhrase("#vjbase.menu.npc.consettings.bind.clickmsg2").." ", Color(255,255,0), row:GetValue(2))
		end
	Panel:AddItem(ControlList)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function VJ_NPC_SETTINGS_PERFORMANCE(Panel)
	if !game.SinglePlayer() && !LocalPlayer():IsAdmin() then
		Panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.not"})
		Panel:AddControl( "Label", {Text = "#vjbase.menu.general.admin.only"})
		return
	end
	
	Panel:AddControl( "Label", {Text = "#vjbase.menu.general.admin.only"})
	Panel:AddControl("Label", {Text = "#vjbase.menu.npc.performance.initial.label"})
	Panel:AddControl("Button",{Text = "#vjbase.menu.general.reset.everything", Command = "vj_npc_shadows 1\n vj_npc_poseparams 1\n vj_npc_ikchains 1\nvj_npc_processtime 1\nvj_npc_forcelowlod 0"})
	Panel:AddControl("Slider",{Label = "#vjbase.menu.npc.performance.processtime",Type = "Float",min = 0.05,max = 3,Command = "vj_npc_processtime"})
	local vid = vgui.Create("DButton") -- Process Time Video
		vid:SetFont("TargetID")
		vid:SetText("#vjbase.menu.npc.performance.processtime.button")
		vid:SetSize(150,25)
		//vid:SetColor(Color(76,153,255,255))
		vid.DoClick = function()
			gui.OpenURL("https://www.youtube.com/watch?v=7wKsCmGpieU")
		end
	Panel:AddPanel(vid)
	Panel:ControlHelp("#vjbase.menu.npc.performance.processtime.label")
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.performance.poseparams", Command = "vj_npc_poseparams"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.performance.shadows", Command = "vj_npc_shadows"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.performance.ikchains", Command = "vj_npc_ikchains"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.performance.forcelowlod", Command = "vj_npc_forcelowlod"})
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function VJ_WEAPON_SETTINGS_CLIENT(Panel)
	Panel:AddControl("Label", {Text = "#vjbase.menu.wep.clsettings.notice"})
	Panel:AddControl("Button",{Text = "#vjbase.menu.general.reset.everything", Command = "vj_wep_nomuszzleflash 0\n vj_wep_nobulletshells 0\n vj_wep_nomuszzleflash_dynamiclight 0"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.wep.clsettings.togglemuzzle", Command = "vj_wep_nomuszzleflash"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.wep.clsettings.togglemuzzlelight", Command = "vj_wep_nomuszzleflash_dynamiclight"})
	Panel:ControlHelp("#vjbase.menu.wep.clsettings.togglemuzzle.label")
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.wep.clsettings.togglemuzzlebulletshells", Command = "vj_wep_nobulletshells"})
end
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PopulateToolMenu", "VJ_ADDTOMENU_CONFIGURES", function()
	spawnmenu.AddToolMenuOption("DrVrej", "NPCs", "vj_menu_npc_options", "#vjbase.menu.npc.options", "", "", VJ_NPC_OPTIONS, {})
	spawnmenu.AddToolMenuOption("DrVrej", "NPCs", "vj_menu_npc_settings", "#vjbase.menu.npc.settings", "", "", VJ_NPC_SETTINGS, {})
	spawnmenu.AddToolMenuOption("DrVrej", "NPCs", "vj_menu_npc_settings_sound", "#vjbase.menu.npc.sdsettings", "", "", VJ_NPC_SETTINGS_SOUND, {})
	spawnmenu.AddToolMenuOption("DrVrej", "NPCs", "vj_menu_npc_settings_dev", "#vjbase.menu.npc.devsettings", "", "", VJ_NPC_SETTINGS_DEV, {})
	spawnmenu.AddToolMenuOption("DrVrej", "NPCs", "vj_menu_npc_settings_cont", "#vjbase.menu.npc.consettings", "", "", VJ_NPC_SETTINGS_CONTROLLER, {})
	spawnmenu.AddToolMenuOption("DrVrej", "NPCs", "vj_menu_npc_settings_perf", "#vjbase.menu.npc.performance", "", "", VJ_NPC_SETTINGS_PERFORMANCE, {})
	spawnmenu.AddToolMenuOption("DrVrej", "Weapons", "vj_menu_wep_settings_cl", "#vjbase.menu.wep.clsettings", "", "", VJ_WEAPON_SETTINGS_CLIENT, {})
end)