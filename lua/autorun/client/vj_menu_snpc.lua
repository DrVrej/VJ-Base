/*--------------------------------------------------
	=============== SNPC Menu ===============
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
include('autorun/client/vj_menu_plugins.lua')
---------------------------------------------------------------------------------------------------------------------------------------------
local function VJ_SNPC_OPTIONS(Panel) -- Options
	if !game.SinglePlayer() && (!LocalPlayer():IsAdmin() or !LocalPlayer():IsSuperAdmin()) then
		Panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.not"})
		Panel:ControlHelp("#vjbase.menu.general.admin.only")
		return
	end
	
	Panel:ControlHelp("#vjbase.menu.general.admin.only")
	Panel:AddControl("Label", {Text = "#vjbase.menu.general.snpc.warnfuture"})
	Panel:AddControl("Button",{Text = "#vjbase.menu.general.reset.everything", Command = "vj_npc_godmodesnpc 0\nvj_npc_playerfriendly 0\nvj_npc_zombiefriendly 0\nvj_npc_antlionfriendly 0\nvj_npc_combinefriendly 0\nvj_npc_corpsefade 0\nvj_npc_corpsefadetime 10\nvj_npc_undocorpse 0\nvj_npc_allhealth 0\nvj_npc_fadegibs 1\nvj_npc_fadegibstime 30\nvj_npc_gibcollidable 0\nvj_npc_addfrags 1\nvj_npc_showhudonkilled 1\nvj_npc_dropweapon 1\nvj_npc_itemdrops 1\nvj_npc_accuracy_poor 1\nvj_npc_accuracy_average 0\nvj_npc_accuracy_good 0\nvj_npc_accuracy_verygood 0\nvj_npc_accuracy_perfect 0\nvj_npc_creatureopendoor 1\nvj_npc_vjfriendly 0\nvj_npc_globalcorpselimit 32\nvj_npc_seedistance 0\nvj_npc_processtime 1\nvj_npc_usegmoddecals 0\nvj_npc_knowenemylocation 0\nvj_npc_plypickupdropwep 1\nvj_npc_difficulty 0\nvj_npc_human_canjump 1"})
	local vj_difficulty = {Options = {}, CVars = {}, Label = "#vjbase.menu.snpc.options.difficulty.header", MenuButton = "0"}
		vj_difficulty.Options["#vjbase.menu.snpc.options.difficulty.neanderthal"] = {vj_npc_difficulty = "-3"}
		vj_difficulty.Options["#vjbase.menu.snpc.options.difficulty.childs_play"] = {vj_npc_difficulty = "-2"}
		vj_difficulty.Options["#vjbase.menu.snpc.options.difficulty.easy"] = {vj_npc_difficulty = "-1"}
		vj_difficulty.Options["#vjbase.menu.snpc.options.difficulty.normal"] = {vj_npc_difficulty = "0"}
		vj_difficulty.Options["#vjbase.menu.snpc.options.difficulty.hard"] = {vj_npc_difficulty = "1"}
		vj_difficulty.Options["#vjbase.menu.snpc.options.difficulty.insane"] = {vj_npc_difficulty = "2"}
		vj_difficulty.Options["#vjbase.menu.snpc.options.difficulty.impossible"] = {vj_npc_difficulty = "3"}
		vj_difficulty.Options["#vjbase.menu.snpc.options.difficulty.nightmare"] = {vj_npc_difficulty = "4"}
		vj_difficulty.Options["#vjbase.menu.snpc.options.difficulty.hell_on_earth"] = {vj_npc_difficulty = "5"}
		vj_difficulty.Options["#vjbase.menu.snpc.options.difficulty.total_annihilation"] = {vj_npc_difficulty = "6"}
	Panel:AddControl("ComboBox", vj_difficulty)
	
	Panel:AddControl("Label", {Text = "#vjbase.menu.snpc.options.label1"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.options.togglefriendlyantlion", Command = "vj_npc_antlionfriendly"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.options.togglefriendlycombine", Command = "vj_npc_combinefriendly"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.options.togglefriendlyplayer", Command = "vj_npc_playerfriendly"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.options.togglefriendlyzombie", Command = "vj_npc_zombiefriendly"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.options.togglefriendlyvj", Command = "vj_npc_vjfriendly"})
	Panel:ControlHelp("#vjbase.menu.snpc.options.label2")
	
	Panel:AddControl("Label", {Text = "#vjbase.menu.snpc.options.label3"})
	Panel:AddControl("Slider",{Label = "#vjbase.menu.snpc.options.corpselimit",min = 4,max = 300,Command = "vj_npc_globalcorpselimit"})
	Panel:ControlHelp("#vjbase.menu.snpc.options.label4")
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.options.toggleundocorpses", Command = "vj_npc_undocorpse"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.options.togglecorpsefade", Command = "vj_npc_corpsefade"})
	Panel:AddControl("Slider",{Label = "#vjbase.menu.snpc.options.corpsefadetime",min = 0,max = 600,Command = "vj_npc_corpsefadetime"})
	Panel:ControlHelp("#vjbase.menu.snpc.options.label5")
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.options.togglegibcollision", Command = "vj_npc_gibcollidable"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.options.togglefadegibs", Command = "vj_npc_fadegibs"})
	Panel:AddControl("Slider",{Label = "#vjbase.menu.snpc.options.gibfadetime",min = 0,max = 600,Command = "vj_npc_fadegibstime"})
	Panel:ControlHelp("#vjbase.menu.snpc.options.label6")
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.options.togglesnpcgodmode", Command = "vj_npc_godmodesnpc"})
	//Panel:AddControl("Slider", {Label = "Health Changer",min = 0,max = 10000,Command = "vj_npc_allhealth"})
	Panel:AddControl("TextBox", {Label = "#vjbase.menu.snpc.options.health", Command = "vj_npc_allhealth", WaitForEnter = "0"})
	Panel:ControlHelp("#vjbase.menu.snpc.options.defaulthealth")
	
	Panel:AddControl("Label", {Text = "#vjbase.menu.snpc.options.label7"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.options.toggleknowenemylocation", Command = "vj_npc_knowenemylocation"})
	Panel:AddControl("TextBox", {Label = "#vjbase.menu.snpc.options.sightdistance", Command = "vj_npc_seedistance", WaitForEnter = "0"})
	Panel:ControlHelp("#vjbase.menu.snpc.options.label8")
	Panel:AddControl("Slider",{Label = "#vjbase.menu.snpc.options.processtime",Type = "Float",min = 0.05,max = 3,Command = "vj_npc_processtime"})
	local vid = vgui.Create("DButton") -- Process Time Video
		vid:SetFont("TargetID")
		vid:SetText("#vjbase.menu.snpc.options.whatisprocesstime")
		vid:SetSize(150,25)
		//vid:SetColor(Color(76,153,255,255))
		vid.DoClick = function(vid)
			gui.OpenURL("https://www.youtube.com/watch?v=7wKsCmGpieU")
		end
	Panel:AddPanel(vid)
	Panel:ControlHelp("#vjbase.menu.snpc.options.label9")
	
	Panel:AddControl("Label", {Text = "#vjbase.menu.snpc.options.label10"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.options.togglegmoddecals", Command = "vj_npc_usegmoddecals"})
	Panel:ControlHelp("#vjbase.menu.snpc.options.label11")
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.options.toggleitemdrops", Command = "vj_npc_itemdrops"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.options.toggleshowhudonkilled", Command = "vj_npc_showhudonkilled"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.options.toggleaddfrags", Command = "vj_npc_addfrags"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.options.togglecreatureopendoor", Command = "vj_npc_creatureopendoor"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.options.togglehumansdropweapon", Command = "vj_npc_dropweapon"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.options.togglehumanscanjump", Command = "vj_npc_human_canjump"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.options.toggleplydroppedweapons", Command = "vj_npc_plypickupdropwep"})
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function VJ_SNPC_SETTINGS(Panel) -- Settings
	if !game.SinglePlayer() && (!LocalPlayer():IsAdmin() or !LocalPlayer():IsSuperAdmin()) then
		Panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.not"})
		Panel:ControlHelp("#vjbase.menu.general.admin.only")
		return
	end

	Panel:ControlHelp("#vjbase.menu.general.admin.only")
	Panel:AddControl("Label", {Text = "#vjbase.menu.general.snpc.warnfuture"})
	Panel:AddControl("Button",{Text = "#vjbase.menu.general.reset.everything", Command = "vj_npc_nocorpses 0\nvj_npc_nobleed 0\nvj_npc_nomelee 0\nvj_npc_norange 0\nvj_npc_noleap 0\nvj_npc_noflinching 0\nvj_npc_noallies 0\nvj_npc_noweapon 0\nvj_npc_noforeverammo 0\nvj_npc_nowandering 0\nvj_npc_nogib 0\nvj_npc_nodeathanimation 0\nvj_npc_noscarednade 0\nvj_npc_animal_runontouch 0\nvj_npc_animal_runonhit 0\nvj_npc_slowplayer 0\nvj_npc_bleedenemyonmelee 0\nvj_npc_noproppush 0\nvj_npc_nopropattack 0\nvj_npc_nogibdeathparticles 0\nvj_npc_noidleparticle 0\nvj_npc_nogibdecals 0\nvj_npc_noreload 0\nvj_npc_nouseregulator 0\nvj_npc_nobecomeenemytoply 0\nvj_npc_nofollowplayer 0\nvj_npc_nothrowgrenade 0\nvj_npc_nobloodpool 0\nvj_npc_nochasingenemy 0\nvj_npc_nosnpcchat 0\nvj_npc_nomedics 0\nvj_npc_nomeleedmgdsp 0"})
	
	Panel:AddControl("Label", {Text = "#vjbase.menu.snpc.settings.label1"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.settings.togglewandering", Command = "vj_npc_nowandering"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.settings.togglechasingenemy", Command = "vj_npc_nochasingenemy"})
	Panel:ControlHelp("#vjbase.menu.snpc.settings.label2")
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.settings.togglemedics", Command = "vj_npc_nomedics"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.settings.togglefollowplayer", Command = "vj_npc_nofollowplayer"})
	Panel:ControlHelp("#vjbase.menu.snpc.settings.label3")
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.settings.toggleallies", Command = "vj_npc_noallies"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.settings.togglebecomeenemytoply", Command = "vj_npc_nobecomeenemytoply"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.settings.toggleproppush", Command = "vj_npc_noproppush"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.settings.togglepropattack", Command = "vj_npc_nopropattack"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.settings.togglescarednade", Command = "vj_npc_noscarednade"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.settings.togglereloading", Command = "vj_npc_noreload"})
	
	Panel:AddControl("Label", {Text = "#vjbase.menu.snpc.settings.label4"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.settings.togglemelee", Command = "vj_npc_nomelee"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.settings.togglerange", Command = "vj_npc_norange"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.settings.toggleleap", Command = "vj_npc_noleap"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.settings.togglethrownade", Command = "vj_npc_nothrowgrenade"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.settings.toggleweapons", Command = "vj_npc_noweapon"})
	Panel:ControlHelp("#vjbase.menu.snpc.settings.label5")
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.settings.togglemeleedsp", Command = "vj_npc_nomeleedmgdsp"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.settings.toggleslowplayer", Command = "vj_npc_slowplayer"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.settings.togglebleedonmelee", Command = "vj_npc_bleedenemyonmelee"})
	
	Panel:AddControl("Label", {Text = "#vjbase.menu.snpc.settings.label6"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.settings.toggleidleparticles", Command = "vj_npc_noidleparticle"})
	Panel:ControlHelp("#vjbase.menu.snpc.settings.label7")
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.settings.togglesnpcchat", Command = "vj_npc_nosnpcchat"})
	Panel:ControlHelp("#vjbase.menu.snpc.settings.label8")
	
	Panel:AddControl("Label", {Text = "#vjbase.menu.snpc.settings.label9"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.settings.toggleflinching", Command = "vj_npc_noflinching"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.settings.togglebleeding", Command = "vj_npc_nobleed"})
	Panel:ControlHelp("#vjbase.menu.snpc.settings.label10")
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.settings.togglebloodpool", Command = "vj_npc_nobloodpool"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.settings.togglegib", Command = "vj_npc_nogib"})
	Panel:ControlHelp("#vjbase.menu.snpc.settings.label11")
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.settings.togglegibdecals", Command = "vj_npc_nogibdecals"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.settings.togglegibdeathparticles", Command = "vj_npc_nogibdeathparticles"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.settings.toggledeathanim", Command = "vj_npc_nodeathanimation"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.settings.togglecorpses", Command = "vj_npc_nocorpses"})
	
	Panel:AddControl("Label", {Text = "#vjbase.menu.snpc.settings.label12"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.settings.togglerunontouch", Command = "vj_npc_animal_runontouch"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.settings.togglerunonhit", Command = "vj_npc_animal_runonhit"})
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function VJ_SNPC_SOUNDSETTINGS(Panel) -- Sound Settings
	if !game.SinglePlayer() && (!LocalPlayer():IsAdmin() or !LocalPlayer():IsSuperAdmin()) then
		Panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.not"})
		Panel:ControlHelp("#vjbase.menu.general.admin.only")
		return
	end
	
	Panel:ControlHelp("#vjbase.menu.general.admin.only")
	Panel:AddControl("Label", {Text = "#vjbase.menu.general.snpc.warnfuture"})
	Panel:AddControl("Button",{Text = "#vjbase.menu.general.reset.everything", Command = "vj_npc_sd_nosounds 0\n vj_npc_sd_idle 0\n vj_npc_sd_alert 0\n vj_npc_sd_pain 0\n vj_npc_sd_death 0\n vj_npc_sd_footstep 0\n vj_npc_sd_soundtrack 0\n vj_npc_sd_meleeattack 0\n vj_npc_sd_meleeattackmiss 0\n vj_npc_sd_rangeattack 0\n vj_npc_sd_leapattack 0\n vj_npc_sd_ongrenadesight 0\n vj_npc_sd_onplayersight 0\n vj_npc_sd_damagebyplayer 0\n vj_npc_sd_slowplayer 0\n vj_npc_sd_gibbing 0\n vj_npc_sd_breath 0\n vj_npc_sd_followplayer 0\n vj_npc_sd_becomenemytoply 0\n vj_npc_sd_medic 0\n vj_npc_sd_reload 0\n vj_npc_sd_grenadeattack 0\n vj_npc_sd_suppressing 0\n vj_npc_sd_callforhelp 0\n vj_npc_sd_onreceiveorder 0"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.sdsettings.toggleallsounds", Command = "vj_npc_sd_nosounds"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.sdsettings.togglesoundtrack", Command = "vj_npc_sd_soundtrack"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.sdsettings.toggleidle", Command = "vj_npc_sd_idle"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.sdsettings.togglebreathing", Command = "vj_npc_sd_breath"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.sdsettings.togglefootsteps", Command = "vj_npc_sd_footstep"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.sdsettings.toggleattacksounds", Command = "vj_npc_sd_meleeattack"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.sdsettings.togglemeleemiss", Command = "vj_npc_sd_meleeattackmiss"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.sdsettings.togglerangeattack", Command = "vj_npc_sd_rangeattack"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.sdsettings.togglealert", Command = "vj_npc_sd_alert"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.sdsettings.togglepain", Command = "vj_npc_sd_pain"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.sdsettings.toggledeath", Command = "vj_npc_sd_death"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.sdsettings.togglegibbing", Command = "vj_npc_sd_gibbing"})
	Panel:ControlHelp("#vjbase.menu.snpc.sdsettings.label1")
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.sdsettings.togglemedic", Command = "vj_npc_sd_medic"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.sdsettings.togglefollowing", Command = "vj_npc_sd_followplayer"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.sdsettings.togglecallhelp", Command = "vj_npc_sd_callforhelp"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.sdsettings.togglereceiveorder", Command = "vj_npc_sd_onreceiveorder"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.sdsettings.togglebecomeenemy", Command = "vj_npc_sd_becomenemytoply"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.sdsettings.toggleplayersight", Command = "vj_npc_sd_onplayersight"})
	Panel:ControlHelp("#vjbase.menu.snpc.sdsettings.label2")
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.sdsettings.toggledmgbyplayer", Command = "vj_npc_sd_damagebyplayer"})
	Panel:ControlHelp("#vjbase.menu.snpc.sdsettings.label3")
	
	Panel:AddControl("Label", {Text = "#vjbase.menu.general.snpc.creaturesettings"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.sdsettings.toggleleap", Command = "vj_npc_sd_leapattack"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.sdsettings.toggleslowedplayer", Command = "vj_npc_sd_slowplayer"})
	Panel:ControlHelp("#vjbase.menu.snpc.sdsettings.label4")
	
	Panel:AddControl("Label", {Text = "#vjbase.menu.general.snpc.humansettings"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.sdsettings.togglegrenade", Command = "vj_npc_sd_grenadeattack"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.sdsettings.togglegrenadesight", Command = "vj_npc_sd_ongrenadesight"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.sdsettings.togglesuppressing", Command = "vj_npc_sd_suppressing"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.sdsettings.togglereload", Command = "vj_npc_sd_reload"})
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function VJ_SNPC_DEVSETTINGS(Panel) -- Developer Settings
	if !game.SinglePlayer() && (!LocalPlayer():IsAdmin() or !LocalPlayer():IsSuperAdmin()) then
		Panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.not"})
		Panel:ControlHelp("#vjbase.menu.general.admin.only")
		return
	end
	
	Panel:ControlHelp("#vjbase.menu.general.admin.only")
	Panel:AddControl("Label", {Text = "#vjbase.menu.snpc.devsettings.label1"})
	Panel:AddControl("Label", {Text = "#vjbase.menu.snpc.devsettings.label2"})
	Panel:AddControl("Button",{Text = "#vjbase.menu.general.reset.everything", Command = "vj_npc_printammo 0\n vj_npc_printweapon 0\n vj_npc_printaccuracy 0\n vj_npc_printdied 0\n vj_npc_printondamage 0\n vj_npc_printontouch 0\n vj_npc_printstoppedattacks 0\n vj_npc_printtakingcover 0\n vj_npc_printresetenemy 0\n vj_npc_printlastseenenemy 0\n vj_npc_usedevcommands 0\n vj_npc_printcurenemy 0"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.devsettings.toggledev", Command = "vj_npc_usedevcommands"})
	Panel:ControlHelp("#vjbase.menu.snpc.devsettings.label3")
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.devsettings.printtouch", Command = "vj_npc_printontouch"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.devsettings.printcurenemy", Command = "vj_npc_printcurenemy"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.devsettings.printlastseenenemy", Command = "vj_npc_printlastseenenemy"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.devsettings.printonreset", Command = "vj_npc_printresetenemy"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.devsettings.printonstopattack", Command = "vj_npc_printstoppedattacks"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.devsettings.printtakingcover", Command = "vj_npc_printtakingcover"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.devsettings.printondamage", Command = "vj_npc_printondamage"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.devsettings.printondeath", Command = "vj_npc_printdied"})
	Panel:AddControl("Label", {Text = "#vjbase.menu.general.snpc.humansettings"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.devsettings.printweapon", Command = "vj_npc_printweapon"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.devsettings.printammo", Command = "vj_npc_printammo"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.devsettings.printaccuracy", Command = "vj_npc_printaccuracy"})
	Panel:AddControl("Button", {Label = "#vjbase.menu.snpc.devsettings.cachedmodels", Command = "listmodels"})
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function VJ_SNPC_NPCONTROLLERSETTINGS(Panel) -- NPC Controller Settings
	Panel:AddControl("Label", {Text = "#vjbase.menu.snpc.consettings.label1"})
	Panel:AddControl("Button",{Text = "#vjbase.menu.general.reset.everything", Command = "vj_npc_cont_hud 1\n vj_npc_cont_zoomdist 5\n vj_npc_cont_devents 0"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.consettings.displayhud", Command = "vj_npc_cont_hud"})
	Panel:AddControl("Slider",{Label = "#vjbase.menu.snpc.consettings.zoomdistance",min = 5,max = 300,Command = "vj_npc_cont_zoomdist"})
	Panel:ControlHelp("#vjbase.menu.snpc.consettings.label2")
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.snpc.consettings.displaydev", Command = "vj_npc_cont_devents"})
	
	Panel:AddControl("Label", {Text = "#vjbase.menu.snpc.consettings.label3"})
	
	local ControlList = vgui.Create("DListView")
	ControlList:SetTooltip(false)
	ControlList:SetSize(100, 260) -- Size
	ControlList:SetMultiSelect(false)
	ControlList:AddColumn("#vjbase.menu.snpc.consettings.bind.header1") -- Add column
	ControlList:AddColumn("#vjbase.menu.snpc.consettings.bind.header2") -- Add column
		ControlList:AddLine("W A S D", "#vjbase.menu.snpc.consettings.bind.movement")
		ControlList:AddLine("END", "#vjbase.menu.snpc.consettings.bind.exitcontrol")
		ControlList:AddLine("FIRE1", "#vjbase.menu.snpc.consettings.bind.meleeattack")
		ControlList:AddLine("FIRE2", "#vjbase.menu.snpc.consettings.bind.rangeattack")
		ControlList:AddLine("JUMP", "#vjbase.menu.snpc.consettings.bind.leaporgrenade")
		ControlList:AddLine("RELOAD", "#vjbase.menu.snpc.consettings.bind.reloadweapon")
		ControlList:AddLine("T", "#vjbase.menu.snpc.consettings.bind.togglebullseye")
		ControlList:AddLine("RUN + UP ARROW", "#vjbase.menu.snpc.consettings.bind.cameraup")
		ControlList:AddLine("RUN + Down ARROW", "#vjbase.menu.snpc.consettings.bind.cameradown")
		ControlList:AddLine("UP ARROW", "#vjbase.menu.snpc.consettings.bind.cameraforward")
		ControlList:AddLine("Down ARROW", "#vjbase.menu.snpc.consettings.bind.camerabackward")
		ControlList:AddLine("LEFT ARROW", "#vjbase.menu.snpc.consettings.bind.cameraleft")
		ControlList:AddLine("RIGHT ARROW", "#vjbase.menu.snpc.consettings.bind.cameraright")
		ControlList:AddLine("BACKSPACE", "#vjbase.menu.snpc.consettings.bind.resetzoom")
	ControlList.OnRowSelected = function(panel, rowIndex, row)
		chat.AddText(Color(0,255,0), language.GetPhrase("#vjbase.menu.snpc.consettings.bind.clickmsg1").." ", Color(255,255,0), row:GetValue(1), Color(0,255,0), " | "..language.GetPhrase("#vjbase.menu.snpc.consettings.bind.clickmsg2").." ", Color(255,255,0), row:GetValue(2))
	end
	Panel:AddItem(ControlList)
end
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PopulateToolMenu", "VJ_ADDTOMENU_SNPC", function()
	spawnmenu.AddToolMenuOption("DrVrej", "SNPCs", "SNPC Options", "#vjbase.menu.snpc.options", "", "", VJ_SNPC_OPTIONS, {})
	spawnmenu.AddToolMenuOption("DrVrej", "SNPCs", "SNPC Settings", "#vjbase.menu.snpc.settings", "", "", VJ_SNPC_SETTINGS, {})
	spawnmenu.AddToolMenuOption("DrVrej", "SNPCs", "SNPC Sound Settings", "#vjbase.menu.snpc.sdsettings", "", "", VJ_SNPC_SOUNDSETTINGS, {})
	spawnmenu.AddToolMenuOption("DrVrej", "SNPCs", "SNPC Developer Settings", "#vjbase.menu.snpc.devsettings", "", "", VJ_SNPC_DEVSETTINGS, {})
	spawnmenu.AddToolMenuOption("DrVrej", "SNPCs", "NPC Controller Settings", "#vjbase.menu.snpc.consettings", "", "", VJ_SNPC_NPCONTROLLERSETTINGS, {})
end)