/*--------------------------------------------------
	=============== SNPC Menu ===============
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
include('autorun/client/vj_menu_plugins.lua')
---------------------------------------------------------------------------------------------------------------------------------------------
local function VJ_SNPC_OPTIONS(Panel) -- Options
	if !game.SinglePlayer() then
	if !LocalPlayer():IsAdmin() or !LocalPlayer():IsSuperAdmin() then
		Panel:AddControl( "Label", {Text = "You are not an admin!"})
		Panel:ControlHelp("Notice: Only admins can change this options.")
		return
		end
	end
	Panel:AddControl( "Label", {Text = "Notice: Only admins can change this options."})
	Panel:AddControl( "Label", {Text = "WARNING: Only future spawned SNPCs will be affected!"})
	Panel:AddControl("Button",{Text = "Reset Everything", Command = "vj_npc_godmodesnpc 0\nvj_npc_playerfriendly 0\nvj_npc_zombiefriendly 0\nvj_npc_antlionfriendly 0\nvj_npc_combinefriendly 0\nvj_npc_corpsefade 0\nvj_npc_corpsefadetime 10\nvj_npc_undocorpse 0\nvj_npc_allhealth 0\nvj_npc_fadegibs 1\nvj_npc_fadegibstime 30\nvj_npc_gibcollidable 0\nvj_npc_addfrags 1\nvj_npc_showhudonkilled 1\nvj_npc_dropweapon 1\nvj_npc_itemdrops 1\nvj_npc_accuracy_poor 1\nvj_npc_accuracy_average 0\nvj_npc_accuracy_good 0\nvj_npc_accuracy_verygood 0\nvj_npc_accuracy_perfect 0\nvj_npc_creatureopendoor 1\nvj_npc_vjfriendly 0\nvj_npc_globalcorpselimit 32\nvj_npc_seedistance 0\nvj_npc_processtime 1\nvj_npc_usegmoddecals 0\nvj_npc_knowenemylocation 0\nvj_npc_plypickupdropwep 1\nvj_npc_difficulty 0"})
	local vj_difficulty = {Options = {}, CVars = {}, Label = "Select the Difficulty:", MenuButton = "0"}
	vj_difficulty.Options["#vjbase.menudifficulty.neanderthal"] = {vj_npc_difficulty = "-3"}
	vj_difficulty.Options["#vjbase.menudifficulty.childs_play"] = {vj_npc_difficulty = "-2"}
	vj_difficulty.Options["#vjbase.menudifficulty.easy"] = {vj_npc_difficulty = "-1"}
	vj_difficulty.Options["#vjbase.menudifficulty.normal"] = {vj_npc_difficulty = "0"}
	vj_difficulty.Options["#vjbase.menudifficulty.hard"] = {vj_npc_difficulty = "1"}
	vj_difficulty.Options["#vjbase.menudifficulty.insane"] = {vj_npc_difficulty = "2"}
	vj_difficulty.Options["#vjbase.menudifficulty.impossible"] = {vj_npc_difficulty = "3"}
	vj_difficulty.Options["#vjbase.menudifficulty.nightmare"] = {vj_npc_difficulty = "4"}
	vj_difficulty.Options["#vjbase.menudifficulty.hell_on_earth"] = {vj_npc_difficulty = "5"}
	vj_difficulty.Options["#vjbase.menudifficulty.total_annihilation"] = {vj_npc_difficulty = "6"}
	Panel:AddControl("ComboBox", vj_difficulty)
	
	Panel:AddControl( "Label", {Text = "Relationship Options:"})
	Panel:AddControl("Checkbox", {Label = "Antlion Friendly", Command = "vj_npc_antlionfriendly"})
	Panel:AddControl("Checkbox", {Label = "Combine Friendly", Command = "vj_npc_combinefriendly"})
	Panel:AddControl("Checkbox", {Label = "Player Friendly", Command = "vj_npc_playerfriendly"})
	Panel:AddControl("Checkbox", {Label = "Zombie Friendly", Command = "vj_npc_zombiefriendly"})
	Panel:AddControl("Checkbox", {Label = "VJ Base Friendly", Command = "vj_npc_vjfriendly"})
	Panel:ControlHelp("All VJ SNPCs will be allied!")
	
	Panel:AddControl( "Label", {Text = "Corpse & Health Options:"})
	Panel:AddControl("Slider",{Label = "Corpse Limit, Def:32",min = 4,max = 300,Command = "vj_npc_globalcorpselimit"})
	Panel:ControlHelp("Corpse Limit when 'Keep Corpses' is off")
	Panel:AddControl("Checkbox", {Label = "Undoable Corpses (Undo Key)", Command = "vj_npc_undocorpse"})
	Panel:AddControl("Checkbox", {Label = "Fade Corpses", Command = "vj_npc_corpsefade"})
	Panel:AddControl("Slider",{Label = "Corpse Fade Time",min = 0,max = 600,Command = "vj_npc_corpsefadetime"})
	Panel:ControlHelp("Total: 600 seconds (10 Minutes)")
	Panel:AddControl("Checkbox", {Label = "Collidable Gibs", Command = "vj_npc_gibcollidable"})
	Panel:AddControl("Checkbox", {Label = "Fade Gibs", Command = "vj_npc_fadegibs"})
	Panel:AddControl("Slider",{Label = "Gib Fade Time",min = 0,max = 600,Command = "vj_npc_fadegibstime"})
	Panel:ControlHelp("Default: 30 | Total: 600 seconds (10 Minutes)")
	Panel:AddControl("Checkbox", {Label = "God Mode (They won't take any damage)", Command = "vj_npc_godmodesnpc"})
	//Panel:AddControl("Slider", {Label = "Health Changer",min = 0,max = 10000,Command = "vj_npc_allhealth"})
	//Panel:AddControl( "Label", {Text = "Health (0 = Original health):"})
	/*local textbox = vgui.Create("DTextEntry")
		textbox:SetSize(10,20)
		//textbox:SetPos(5,27)
		textbox:SetText("Test")
		textbox:SetConVar("vj_npc_allhealth")
		textbox:SetMultiline(false)
	Panel:AddPanel(textbox)*/
	Panel:AddControl("TextBox", {Label = "Health:", Command = "vj_npc_allhealth", WaitForEnter = "0"})
	Panel:ControlHelp("0 = Default Health (9 digits max!)")
	
	Panel:AddControl( "Label", {Text = "AI Options:"})
	Panel:AddControl("Checkbox", {Label = "Always Know Enemy Location", Command = "vj_npc_knowenemylocation"})
	/*Panel:AddControl( "Label", {Text = "Sight Distance (0 = Original | Average: 10k):"})
	local textbox = vgui.Create("DTextEntry")
		textbox:SetSize(10,20)
		//textbox:SetPos(5,27)
		textbox:SetText("Test")
		textbox:SetConVar("vj_npc_seedistance")
		textbox:SetMultiline(false)
	Panel:AddPanel(textbox)*/
	Panel:AddControl("TextBox", {Label = "Sight Distance:", Command = "vj_npc_seedistance", WaitForEnter = "0"})
	Panel:ControlHelp("Each SNPC has its own sight distance, this will make them all the same, so use it cautiously! (0 = Original | Average: 10k)")
	Panel:AddControl("Slider",{Label = "Process Time",Type = "Float",min = 0.05,max = 3,Command = "vj_npc_processtime"})
	local vid = vgui.Create("DButton") -- Process Time Video
		vid:SetFont("TargetID")
		vid:SetText("What is Process Time?")
		vid:SetSize(150,25)
		//vid:SetColor(Color(76,153,255,255))
		vid.DoClick = function(vid)
			gui.OpenURL("https://www.youtube.com/watch?v=7wKsCmGpieU")
		end
	Panel:AddPanel(vid)
	Panel:ControlHelp("Default: 1 | Lower number causes more lag!")
	
	Panel:AddControl( "Label", {Text = "Miscellaneous Options:"})
	Panel:AddControl("Checkbox", {Label = "Use Garry's Mod's Current Blood Decals", Command = "vj_npc_usegmoddecals"})
	Panel:ControlHelp("Colors that aren't Yellow or Red won't change!")
	Panel:AddControl("Checkbox", {Label = "Item Drops On Death", Command = "vj_npc_itemdrops"})
	Panel:AddControl("Checkbox", {Label = "Show HUD Display on SNPC killed (Top Right)", Command = "vj_npc_showhudonkilled"})
	Panel:AddControl("Checkbox", {Label = "Add points to the player's scoreboard when killed", Command = "vj_npc_addfrags"})
	Panel:AddControl("Checkbox", {Label = "Creatures Can Open Doors", Command = "vj_npc_creatureopendoor"})
	Panel:AddControl("Checkbox", {Label = "Humans Drop Weapon On Death", Command = "vj_npc_dropweapon"})
	Panel:AddControl("Checkbox", {Label = "Players Can Pick Up Dropped Weapons", Command = "vj_npc_plypickupdropwep"})
	/*local vj_accuracy = {Options = {}, CVars = {}, Label = "Gun Accuracy:", MenuButton = "0"}
	vj_accuracy.Options["Poor"] = {
	vj_npc_accuracy_poor = "1",vj_npc_accuracy_average = "0",vj_npc_accuracy_good = "0",vj_npc_accuracy_verygood = "0",vj_npc_accuracy_perfect = "0", }
	vj_accuracy.Options["Average"] = {
	vj_npc_accuracy_poor = "0",vj_npc_accuracy_average = "1",vj_npc_accuracy_good = "0",vj_npc_accuracy_verygood = "0",vj_npc_accuracy_perfect = "0", }
	vj_accuracy.Options["Good"] = {
	vj_npc_accuracy_poor = "0",vj_npc_accuracy_average = "0",vj_npc_accuracy_good = "1",vj_npc_accuracy_verygood = "0",vj_npc_accuracy_perfect = "0", }
	vj_accuracy.Options["Very Good"] = {
	vj_npc_accuracy_poor = "0",vj_npc_accuracy_average = "0",vj_npc_accuracy_good = "0",vj_npc_accuracy_verygood = "1",vj_npc_accuracy_perfect = "0", }
	vj_accuracy.Options["Perfect"] = {
	vj_npc_accuracy_poor = "0",vj_npc_accuracy_average = "0",vj_npc_accuracy_good = "0",vj_npc_accuracy_verygood = "0",vj_npc_accuracy_perfect = "1", }
	Panel:AddControl("ComboBox", vj_accuracy)*/
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function VJ_SNPC_SETTINGS(Panel) -- Settings
	if !game.SinglePlayer() then
	if !LocalPlayer():IsAdmin() or !LocalPlayer():IsSuperAdmin() then
		Panel:AddControl( "Label", {Text = "You are not an admin!"})
		Panel:ControlHelp("Notice: Only admins can change this settings.")
		return
		end
	end

	Panel:AddControl( "Label", {Text = "Notice: Only admins can change this settings."})
	Panel:AddControl( "Label", {Text = "WARNING: Only future spawned SNPCs will be affected!"})
	Panel:AddControl("Button",{Text = "Reset Everything", Command = "vj_npc_nocorpses 0\nvj_npc_nobleed 0\nvj_npc_nomelee 0\nvj_npc_norange 0\nvj_npc_noleap 0\nvj_npc_noflinching 0\nvj_npc_noallies 0\nvj_npc_noweapon 0\nvj_npc_noforeverammo 0\nvj_npc_nowandering 0\nvj_npc_nogib 0\nvj_npc_nodeathanimation 0\nvj_npc_noscarednade 0\nvj_npc_animal_runontouch 0\nvj_npc_animal_runonhit 0\nvj_npc_slowplayer 0\nvj_npc_bleedenemyonmelee 0\nvj_npc_noproppush 0\nvj_npc_nopropattack 0\nvj_npc_nogibdeathparticles 0\nvj_npc_noidleparticle 0\nvj_npc_nogibdecals 0\nvj_npc_noreload 0\nvj_npc_nouseregulator 0\nvj_npc_nobecomeenemytoply 0\nvj_npc_nofollowplayer 0\nvj_npc_nothrowgrenade 0\nvj_npc_nobloodpool 0\nvj_npc_nochasingenemy 0\nvj_npc_nosnpcchat 0\nvj_npc_nomedics 0\nvj_npc_nomeleedmgdsp 0"})
	
	Panel:AddControl( "Label", {Text = "AI Settings:"})
	Panel:AddControl("Checkbox", {Label = "Disable Wandering When Idle", Command = "vj_npc_nowandering"})
	Panel:AddControl("Checkbox", {Label = "Disable Chasing Enemy", Command = "vj_npc_nochasingenemy"})
	Panel:ControlHelp("Use this setting with caution, it can break a lot of things!")
	Panel:AddControl("Checkbox", {Label = "Disable Medic SNPCs", Command = "vj_npc_nomedics"})
	Panel:AddControl("Checkbox", {Label = "Disable Following Player", Command = "vj_npc_nofollowplayer"})
	Panel:ControlHelp("Example: When you press 'E' on a SNPC and they follow you")
	Panel:AddControl("Checkbox", {Label = "Disable Alliance", Command = "vj_npc_noallies"})
	Panel:ControlHelp("SNPCs will not have ANY allies!")
	Panel:AddControl("Checkbox", {Label = "Disable Allies Becoming Enemy", Command = "vj_npc_nobecomeenemytoply"})
	Panel:AddControl("Checkbox", {Label = "Disable Prop Pushing (Creatures)", Command = "vj_npc_noproppush"})
	Panel:AddControl("Checkbox", {Label = "Disable Prop Attacking (Creatures)", Command = "vj_npc_nopropattack"})
	Panel:AddControl("Checkbox", {Label = "Disable Humans Running from Grenades", Command = "vj_npc_noscarednade"})
	Panel:AddControl("Checkbox", {Label = "Disable Weapon Reloading", Command = "vj_npc_noreload"})
	
	Panel:AddControl( "Label", {Text = "Attack Settings:"})
	Panel:AddControl("Checkbox", {Label = "Disable Melee Attacks", Command = "vj_npc_nomelee"})
	Panel:AddControl("Checkbox", {Label = "Disable Range Attacks", Command = "vj_npc_norange"})
	Panel:AddControl("Checkbox", {Label = "Disable Leap Attacks (Creatures)", Command = "vj_npc_noleap"})
	Panel:AddControl("Checkbox", {Label = "Disable Grenade Attacks (Humans)", Command = "vj_npc_nothrowgrenade"})
	Panel:AddControl("Checkbox", {Label = "Disable Weapons (Humans)", Command = "vj_npc_noweapon"})
	Panel:ControlHelp("Humans will not be able to use weapons!")
	Panel:AddControl("Checkbox", {Label = "Disable DSP Effect On Heavy Melee Damages", Command = "vj_npc_nomeleedmgdsp"})
	Panel:AddControl("Checkbox", {Label = "Disable Players Slowing Down on Melee Attack", Command = "vj_npc_slowplayer"})
	Panel:AddControl("Checkbox", {Label = "Disable Players/NPCs Bleeding on Melee Attack", Command = "vj_npc_bleedenemyonmelee"})
	
	Panel:AddControl( "Label", {Text = "Miscellaneous Settings:"})
	Panel:AddControl("Checkbox", {Label = "Disable Idle Particles and Effects", Command = "vj_npc_noidleparticle"})
	Panel:ControlHelp("Disabling this can help with performance")
	Panel:AddControl("Checkbox", {Label = "Disable SNPC Chat", Command = "vj_npc_nosnpcchat"})
	Panel:ControlHelp("For example: 'Scientist is now following you'")
	
	Panel:AddControl( "Label", {Text = "Damage & Corpse Settings:"})
	Panel:AddControl("Checkbox", {Label = "Disable Flinching", Command = "vj_npc_noflinching"})
	Panel:AddControl("Checkbox", {Label = "Disable Bleeding", Command = "vj_npc_nobleed"})
	Panel:ControlHelp("Disables blood particles, decals, blood pools etc.")
	Panel:AddControl("Checkbox", {Label = "Disable Blood Pools (On Death)", Command = "vj_npc_nobloodpool"})
	Panel:AddControl("Checkbox", {Label = "Disable Gibbing", Command = "vj_npc_nogib"})
	Panel:ControlHelp("Disabling this can help with performance")
	Panel:AddControl("Checkbox", {Label = "Disable Gib Decals", Command = "vj_npc_nogibdecals"})
	Panel:AddControl("Checkbox", {Label = "Disable Gib/Death Particles and Effects", Command = "vj_npc_nogibdeathparticles"})
	Panel:AddControl("Checkbox", {Label = "Disable Death Animation", Command = "vj_npc_nodeathanimation"})
	Panel:AddControl("Checkbox", {Label = "Disable Corpses", Command = "vj_npc_nocorpses"})
	
	Panel:AddControl( "Label", {Text = "Animal Settings:"})
	Panel:AddControl("Checkbox", {Label = "Disable Running on Touch", Command = "vj_npc_animal_runontouch"})
	Panel:AddControl("Checkbox", {Label = "Disable Running on Hit", Command = "vj_npc_animal_runonhit"})
	
	//Panel:AddControl( "Label", {Text = "Human Settings:"})
	//Panel:AddControl("Checkbox", {Label = "Disable Use Regulator", Command = "vj_npc_nouseregulator"})
	//Panel:ControlHelp("Use this if a weapon you tried on the SNPC didn't work")
	//Panel:AddControl("Checkbox", {Label = "Disable Unlimited Ammo", Command = "vj_npc_noforeverammo"})
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function VJ_SNPC_SOUNDSETTINGS(Panel) -- Sound Settings
	if !game.SinglePlayer() then
	if !LocalPlayer():IsAdmin() or !LocalPlayer():IsSuperAdmin() then
		Panel:AddControl( "Label", {Text = "You are not an admin!"})
		Panel:ControlHelp("Notice: Only admins can change this settings.")
		return
		end
	end
	Panel:AddControl( "Label", {Text = "Notice: Only admins can change this settings."})
	Panel:AddControl( "Label", {Text = "WARNING: Only future spawned SNPCs will be affected!"})
	Panel:AddControl("Button",{Text = "Reset Everything", Command = "vj_npc_sd_nosounds 0\n vj_npc_sd_idle 0\n vj_npc_sd_alert 0\n vj_npc_sd_pain 0\n vj_npc_sd_death 0\n vj_npc_sd_footstep 0\n vj_npc_sd_soundtrack 0\n vj_npc_sd_meleeattack 0\n vj_npc_sd_meleeattackmiss 0\n vj_npc_sd_rangeattack 0\n vj_npc_sd_leapattack 0\n vj_npc_sd_ongrenadesight 0\n vj_npc_sd_onplayersight 0\n vj_npc_sd_damagebyplayer 0\n vj_npc_sd_slowplayer 0\n vj_npc_sd_gibbing 0\n vj_npc_sd_breath 0\n vj_npc_sd_followplayer 0\n vj_npc_sd_becomenemytoply 0\n vj_npc_sd_medic 0\n vj_npc_sd_reload 0\n vj_npc_sd_grenadeattack 0\n vj_npc_sd_suppressing 0\n vj_npc_sd_callforhelp 0\n vj_npc_sd_onreceiveorder 0"})
	Panel:AddControl("Checkbox", {Label = "Disable All Sounds", Command = "vj_npc_sd_nosounds"})
	Panel:AddControl("Checkbox", {Label = "Disable Sound Tracks", Command = "vj_npc_sd_soundtrack"})
	Panel:AddControl("Checkbox", {Label = "Disable Idle Sounds", Command = "vj_npc_sd_idle"})
	Panel:AddControl("Checkbox", {Label = "Disable Breathing Sounds", Command = "vj_npc_sd_breath"})
	Panel:AddControl("Checkbox", {Label = "Disable Footstep Sounds", Command = "vj_npc_sd_footstep"})
	Panel:AddControl("Checkbox", {Label = "Disable Melee Attack Sounds", Command = "vj_npc_sd_meleeattack"})
	Panel:AddControl("Checkbox", {Label = "Disable Melee Miss Sounds", Command = "vj_npc_sd_meleeattackmiss"})
	Panel:AddControl("Checkbox", {Label = "Disable Range Attack Sounds", Command = "vj_npc_sd_rangeattack"})
	Panel:AddControl("Checkbox", {Label = "Disable Alert Sounds", Command = "vj_npc_sd_alert"})
	Panel:AddControl("Checkbox", {Label = "Disable Pain Sounds", Command = "vj_npc_sd_pain"})
	Panel:AddControl("Checkbox", {Label = "Disable Death Sounds", Command = "vj_npc_sd_death"})
	Panel:AddControl("Checkbox", {Label = "Disable Gibbing Sounds", Command = "vj_npc_sd_gibbing"})
	Panel:ControlHelp("Also applies to the sounds that play when a gib collides with something")
	Panel:AddControl("Checkbox", {Label = "Disable Medic Sounds", Command = "vj_npc_sd_medic"})
	Panel:AddControl("Checkbox", {Label = "Disable Following Sounds", Command = "vj_npc_sd_followplayer"})
	Panel:AddControl("Checkbox", {Label = "Disable Calling for Help Sounds", Command = "vj_npc_sd_callforhelp"})
	Panel:AddControl("Checkbox", {Label = "Disable Receiving Order Sounds", Command = "vj_npc_sd_onreceiveorder"})
	Panel:AddControl("Checkbox", {Label = "Disable Become Enemy to Player Sounds", Command = "vj_npc_sd_becomenemytoply"})
	Panel:AddControl("Checkbox", {Label = "Disable Player Sighting Sounds", Command = "vj_npc_sd_onplayersight"})
	Panel:ControlHelp("Special sounds that play when a SNPC sees the player")
	Panel:AddControl("Checkbox", {Label = "Disable Damage By Player Sounds", Command = "vj_npc_sd_damagebyplayer"})
	Panel:ControlHelp("When the player shoots at a SNPC, usually friendly SNPCs")
	
	Panel:AddControl( "Label", {Text = "Creature Settings:"})
	Panel:AddControl("Checkbox", {Label = "Disable Leap Attack Sounds", Command = "vj_npc_sd_leapattack"})
	Panel:AddControl("Checkbox", {Label = "Disable Slowed Player Sounds", Command = "vj_npc_sd_slowplayer"})
	Panel:ControlHelp("Sounds that play when the player is slowed down by melee attack")
	
	Panel:AddControl( "Label", {Text = "Human Settings:"})
	Panel:AddControl("Checkbox", {Label = "Disable Grenade Attack Sounds", Command = "vj_npc_sd_grenadeattack"})
	Panel:AddControl("Checkbox", {Label = "Disable On Grenade Sight Sounds", Command = "vj_npc_sd_ongrenadesight"})
	Panel:AddControl("Checkbox", {Label = "Disable Suppressing Callout Sounds", Command = "vj_npc_sd_suppressing"})
	Panel:AddControl("Checkbox", {Label = "Disable Reload Callout Sounds", Command = "vj_npc_sd_reload"})
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function VJ_SNPC_DEVSETTINGS(Panel) -- Developer Settings
	if !game.SinglePlayer() then
	if !LocalPlayer():IsAdmin() or !LocalPlayer():IsSuperAdmin() then
		Panel:AddControl( "Label", {Text = "You are not an admin!"})
		Panel:ControlHelp("Notice: Only admins can change this settings.")
		return
		end
	end
	Panel:AddControl( "Label", {Text = "Notice: Only admins can change this settings."})
	Panel:AddControl( "Label", {Text = "This settings are used when developing SNPCs."})
	Panel:AddControl( "Label", {Text = "WARNING: Some of this options cause lag!"})
	Panel:AddControl("Button",{Text = "Reset Everything", Command = "vj_npc_printammo 0\n vj_npc_printweapon 0\n vj_npc_printalerted 0\n vj_npc_printaccuracy 0\n vj_npc_printdied 0\n vj_npc_printondamage 0\n vj_npc_printontouch 0\n vj_npc_printstoppedattacks 0\n vj_npc_printtakingcover 0\n vj_npc_printresteenemy 0\n vj_npc_printlastseenenemy 0\n vj_npc_usedevcommands 0\n vj_npc_printcurenemy 0"})
	//Panel:AddControl("Checkbox", {Label = "All SNPCs and NPCs love DrVrej?! =D", Command = "vj_npc_drvrejfriendly"})
	Panel:AddControl("Checkbox", {Label = "Enable Developer Mode?", Command = "vj_npc_usedevcommands"})
	Panel:ControlHelp("Most of the options below require this to be checked!")
	Panel:AddControl("Checkbox", {Label = "Print On Touch (Console)", Command = "vj_npc_printontouch"})
	Panel:AddControl("Checkbox", {Label = "Print Alerted (Console)", Command = "vj_npc_printalerted"})
	Panel:AddControl("Checkbox", {Label = "Print Current Enemy (Console)", Command = "vj_npc_printcurenemy"})
	Panel:AddControl("Checkbox", {Label = "Print 'LastSeenEnemy' time (Chat/Console)", Command = "vj_npc_printlastseenenemy"})
	Panel:AddControl("Checkbox", {Label = "Print On Reset Enemy (Console)", Command = "vj_npc_printresteenemy"})
	Panel:AddControl("Checkbox", {Label = "Print on Stopped Attacks (Console)", Command = "vj_npc_printstoppedattacks"})
	Panel:AddControl("Checkbox", {Label = "Print Taking Cover (Console)", Command = "vj_npc_printtakingcover"})
	Panel:AddControl("Checkbox", {Label = "Print On Damage (Console)", Command = "vj_npc_printondamage"})
	Panel:AddControl("Checkbox", {Label = "Print On Death (Console)", Command = "vj_npc_printdied"})
	Panel:AddControl( "Label", {Text = "Human Settings:"})
	Panel:AddControl("Checkbox", {Label = "Print Current Weapon Class (Console)", Command = "vj_npc_printweapon"})
	Panel:AddControl("Checkbox", {Label = "Print Amount of Ammo (Console)", Command = "vj_npc_printammo"})
	Panel:AddControl("Checkbox", {Label = "Print Gun Accuracy (Console)", Command = "vj_npc_printaccuracy"})
	Panel:AddControl("Button", {Label = "Cached Models (Console)", Command = "listmodels"})
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function VJ_SNPC_NPCONTROLLERSETTINGS(Panel) -- NPC Controller Settings
	Panel:AddControl( "Label", {Text = "Notice: These are client-side settings only!"})
	Panel:AddControl("Button",{Text = "Reset Everything", Command = "vj_npc_cont_hud 1\n vj_npc_cont_zoomdist 5\n vj_npc_cont_devents 0"})
	Panel:AddControl("Checkbox", {Label = "Display HUD", Command = "vj_npc_cont_hud"})
	Panel:AddControl("Slider",{Label = "Zoom Distance",min = 5,max = 300,Command = "vj_npc_cont_zoomdist"})
	Panel:ControlHelp("How far or close the zoom changes every click.")
	Panel:AddControl("Checkbox", {Label = "Display Developer Entities", Command = "vj_npc_cont_devents"})
	Panel:AddControl( "Label", {Text = "Controls:"})
	Panel:ControlHelp("W A S D | Movement (Supports 8-Way)")
	Panel:ControlHelp("END | Exit the Controller")
	Panel:ControlHelp("FIRE1 | Melee Attack")
	Panel:ControlHelp("FIRE2 | Range / Weapon Attack")
	Panel:ControlHelp("JUMP | Leap / Grenade Attack")
	Panel:ControlHelp("RELOAD | Reload Weapon")
	Panel:ControlHelp("T | Toggle Bullseye Tracking")
	Panel:ControlHelp("RUN + UP ARROW | Move Camera Up")
	Panel:ControlHelp("RUN + Down ARROW | Move Camera Down")
	Panel:ControlHelp("UP ARROW | Move Camera Forward")
	Panel:ControlHelp("Down ARROW | Move Camera Backward")
	Panel:ControlHelp("LEFT ARROW | Move Camera Left")
	Panel:ControlHelp("RIGHT ARROW | Move Camera Right")
	Panel:ControlHelp("BACKSPACE | Reset Zoom")
end
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PopulateToolMenu", "VJ_ADDTOMENU_SNPC", function()
	spawnmenu.AddToolMenuOption("DrVrej", "SNPCs", "SNPC Options", "Options", "", "", VJ_SNPC_OPTIONS, {})
	spawnmenu.AddToolMenuOption("DrVrej", "SNPCs", "SNPC Settings", "Settings", "", "", VJ_SNPC_SETTINGS, {})
	spawnmenu.AddToolMenuOption("DrVrej", "SNPCs", "SNPC Sound Settings", "Sound Settings", "", "", VJ_SNPC_SOUNDSETTINGS, {})
	spawnmenu.AddToolMenuOption("DrVrej", "SNPCs", "SNPC Developer Settings", "Developer Settings", "", "", VJ_SNPC_DEVSETTINGS, {})
	spawnmenu.AddToolMenuOption("DrVrej", "SNPCs", "NPC Controller Settings", "NPC Controller Settings", "", "", VJ_SNPC_NPCONTROLLERSETTINGS, {})
end)