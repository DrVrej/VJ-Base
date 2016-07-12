/*--------------------------------------------------
	=============== SNPC Menu ===============
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to load the SNPC Menu for VJ Base 
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
include('autorun/client/vj_installed_addons.lua')
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
	local vj_options_reset = {Options = {}, CVars = {}, Label = "Reset Everything:", MenuButton = "0"}
	//vj_options_reset:SetText("Select Default to reset everything")
	vj_options_reset.Options["#vjbase.menugeneral.default"] = {
	vj_npc_godmodesnpc = "0",
	vj_npc_playerfriendly =	"0",
	vj_npc_zombiefriendly = "0",
	vj_npc_antlionfriendly = "0",
	vj_npc_combinefriendly = "0",
	vj_npc_corpsefade = "0",
	vj_npc_corpsefadetime = "10",
	vj_npc_undocorpse = "0",
	vj_npc_allhealth = "0",
	vj_npc_fadegibs = "1",
	vj_npc_fadegibstime = "30",
	vj_npc_gibcollidable = "0",
	vj_npc_dif_easy = "0",vj_npc_dif_normal = "1",vj_npc_dif_hard = "0",vj_npc_dif_hellonearth = "0",
	vj_npc_addfrags = "1",
	vj_npc_showhudonkilled = "1",
	vj_npc_dropweapon = "1",
	vj_npc_itemdrops = "1",
	vj_npc_accuracy_poor = "1",vj_npc_accuracy_average = "0",vj_npc_accuracy_good = "0",vj_npc_accuracy_verygood = "0",vj_npc_accuracy_perfect = "0",
	vj_npc_creatureopendoor = "1",
	vj_npc_vjfriendly = "0",
	vj_npc_globalcorpselimit = "32",
	vj_npc_seedistance = "0",
	vj_npc_processtime = "1",
	}
	Panel:AddControl("ComboBox", vj_options_reset)
	//Panel:AddControl( "Label", { Text = "________________________________________\n"})
	Panel:AddControl( "Label", {Text = "Relationship Options:"})
	Panel:ControlHelp("NOTE: Relationships can cause a massive lag!")
	Panel:AddControl("Checkbox", {Label = "Player Friendly", Command = "vj_npc_playerfriendly"})
	Panel:AddControl("Checkbox", {Label = "Zombie Friendly", Command = "vj_npc_zombiefriendly"})
	Panel:AddControl("Checkbox", {Label = "Antlion Friendly", Command = "vj_npc_antlionfriendly"})
	Panel:AddControl("Checkbox", {Label = "Combine Friendly", Command = "vj_npc_combinefriendly"})
	Panel:AddControl("Checkbox", {Label = "VJ Friendly", Command = "vj_npc_vjfriendly"})
	Panel:ControlHelp("All of my SNPCs will be friendly to each other")
	Panel:AddControl("Checkbox", {Label = "Undoable Corpses", Command = "vj_npc_undocorpse"})
	Panel:ControlHelp("Corpses will be removed when pressed the undo key")
	Panel:AddControl("Slider",{Label = "Corpse Limit, Default:32",min = 4,max = 300,Command = "vj_npc_globalcorpselimit"})
	Panel:ControlHelp("Corpse Limit when 'Keep Corpses' is off")
	Panel:AddControl("Checkbox", {Label = "Fade Corpses", Command = "vj_npc_corpsefade"})
	Panel:AddControl("Slider",{Label = "Corpse Fade Time",min = 0,max = 600,Command = "vj_npc_corpsefadetime"})
	Panel:ControlHelp("Total: 600 seconds (10 Minutes)")
	Panel:AddControl("Checkbox", {Label = "Collidable Gibs", Command = "vj_npc_gibcollidable"})
	Panel:AddControl("Checkbox", {Label = "Fade Gibs", Command = "vj_npc_fadegibs"})
	Panel:AddControl("Slider",{Label = "Gib Fade Time",min = 0,max = 600,Command = "vj_npc_fadegibstime"})
	Panel:ControlHelp("Default: 30 | Total: 600 seconds (10 Minutes)")
	Panel:AddControl("Checkbox", {Label = "GodMode", Command = "vj_npc_godmodesnpc"})
	Panel:ControlHelp("They won't take any damage")
	//Panel:AddControl("Slider", {Label = "Health Changer",min = 0,max = 10000,Command = "vj_npc_allhealth"})
	Panel:AddControl( "Label", {Text = "Health (0 = Original health):"})
	local textbox = vgui.Create("DTextEntry")
		textbox:SetSize(10,20)
		//textbox:SetPos(5,27)
		textbox:SetText("Test")
		textbox:SetConVar("vj_npc_allhealth")
		textbox:SetMultiline(false)
	Panel:AddPanel(textbox)
	Panel:ControlHelp("Don't put more than 9 digits")
	Panel:AddControl( "Label", {Text = "Sight Distance (0 = Original | Average: 10k):"})
	local textbox = vgui.Create("DTextEntry")
		textbox:SetSize(10,20)
		//textbox:SetPos(5,27)
		textbox:SetText("Test")
		textbox:SetConVar("vj_npc_seedistance")
		textbox:SetMultiline(false)
	Panel:AddPanel(textbox)
	Panel:ControlHelp("Each SNPC has its own sight distance, but this will make them all the same, so use it cautiously!")
	local vj_difficulty = {Options = {}, CVars = {}, Label = "Select the Difficulty:", MenuButton = "0"}
	vj_difficulty.Options["#vjbase.menudifficulty.easy"] = {
	vj_npc_dif_easy = "1",vj_npc_dif_normal = "0",vj_npc_dif_hard = "0", vj_npc_dif_hellonearth = "0",}
	vj_difficulty.Options["#vjbase.menudifficulty.normal"] = {
	vj_npc_dif_easy = "0",vj_npc_dif_normal = "1",vj_npc_dif_hard = "0", vj_npc_dif_hellonearth = "0",}
	vj_difficulty.Options["#vjbase.menudifficulty.hard"] = {
	vj_npc_dif_easy = "0",vj_npc_dif_normal = "0",vj_npc_dif_hard = "1", vj_npc_dif_hellonearth = "0",}
	vj_difficulty.Options["#vjbase.menudifficulty.hellonearth"] = {
	vj_npc_dif_easy = "0",vj_npc_dif_normal = "0",vj_npc_dif_hard = "0", vj_npc_dif_hellonearth = "1",}
	Panel:AddControl("ComboBox", vj_difficulty)
	Panel:AddControl("Slider",{Label = "Process Time",Type = "Float",min = 0.05,max = 3,Command = "vj_npc_processtime"})
	Panel:ControlHelp("Default: 1 | Lower number means more lag!")
	Panel:AddControl("Checkbox", {Label = "Item Drops On Death", Command = "vj_npc_itemdrops"})
	Panel:AddControl("Checkbox", {Label = "Show HUD Display on SNPC killed", Command = "vj_npc_showhudonkilled"})
	Panel:AddControl("Checkbox", {Label = "Add points to the player's scoreboard when killed", Command = "vj_npc_addfrags"})
	Panel:AddControl( "Label", {Text = "Creature Options:"})
	Panel:AddControl("Checkbox", {Label = "Creatures Open Doors", Command = "vj_npc_creatureopendoor"})
	Panel:AddControl( "Label", {Text = "Human Options:"})
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
	Panel:AddControl("Checkbox", {Label = "Drop Weapon On Death", Command = "vj_npc_dropweapon"})
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
	local vj_settings_reset = {Options = {}, CVars = {}, Label = "Reset Everything:", MenuButton = "0"}
	vj_settings_reset.Options["#vjbase.menugeneral.default"] = { 
	vj_npc_nocorpses = "0",
	vj_npc_nobleed = "0",
	vj_npc_nomelee = "0",
	vj_npc_norange = "0",
	vj_npc_noleap = "0",
	vj_npc_noflinching = "0",
	vj_npc_noallies = "0",
	vj_npc_noweapon = "0",
	vj_npc_noforeverammo = "0",
	vj_npc_nowandering = "0",
	vj_npc_nogib = "0",
	vj_npc_nodeathanimation = "0",
	vj_npc_noscarednade = "0",
	vj_npc_animal_runontouch = "0",
	vj_npc_animal_runonhit = "0",
	vj_npc_slowplayer = "0",
	vj_npc_bleedenemyonmelee = "0",
	vj_npc_noproppush = "0",
	vj_npc_nopropattack = "0",
	vj_npc_nogibdeathparticles = "0",
	vj_npc_noidleparticle = "0",
	vj_npc_nogibdecals = "0",
	vj_npc_noreload = "0",
	vj_npc_nouseregulator = "0",
	vj_npc_nobecomeenemytoply = "0",
	vj_npc_nofollowplayer = "0",
	vj_npc_nothrowgrenade = "0",
	vj_npc_nobloodpool = "0",
	vj_npc_nochasingenemy = "0",
	vj_npc_nosnpcchat = "0",
	vj_npc_nomedics = "0",
	}
	Panel:AddControl("ComboBox", vj_settings_reset)
	Panel:AddControl( "Label", {Text = "Shared Settings:"})
	Panel:AddControl("Checkbox", {Label = "Disable Alliance", Command = "vj_npc_noallies"})
	Panel:ControlHelp("The SNPCs will not have ANY allies!")
	Panel:AddControl("Checkbox", {Label = "Disable Melee Attacks", Command = "vj_npc_nomelee"})
	Panel:AddControl("Checkbox", {Label = "Disable Range Attacks", Command = "vj_npc_norange"})
	Panel:AddControl("Checkbox", {Label = "Disable Wandering", Command = "vj_npc_nowandering"})
	Panel:ControlHelp("They won't wander around when idle")
	Panel:AddControl("Checkbox", {Label = "Disable Chasing Enemy", Command = "vj_npc_nochasingenemy"})
	Panel:ControlHelp("Use this setting with caution, it can break a lot of things!")
	Panel:AddControl("Checkbox", {Label = "Disable Idle Particles and Effects", Command = "vj_npc_noidleparticle"})
	Panel:ControlHelp("This is useful if you got a bad computer")
	Panel:AddControl("Checkbox", {Label = "Disable Allies Becoming Enemy", Command = "vj_npc_nobecomeenemytoply"})
	Panel:AddControl("Checkbox", {Label = "Disable Medic NPCs", Command = "vj_npc_nomedics"})
	Panel:AddControl("Checkbox", {Label = "Disable Following Player", Command = "vj_npc_nofollowplayer"})
	Panel:ControlHelp("Example: When you press 'E' on a SNPC and they follow you")
	Panel:AddControl("Checkbox", {Label = "Disable SNPC Chat", Command = "vj_npc_nosnpcchat"})
	Panel:ControlHelp("For example: 'Scientist is now following you'")
	Panel:AddControl("Checkbox", {Label = "Disable Bleeding", Command = "vj_npc_nobleed"})
	Panel:ControlHelp("Disables blood particles, decals, blood pools, etc.")
	Panel:AddControl("Checkbox", {Label = "Disable Flinching", Command = "vj_npc_noflinching"})
	Panel:AddControl("Checkbox", {Label = "Disable Blood Pools (On Death)", Command = "vj_npc_nobloodpool"})
	Panel:AddControl("Checkbox", {Label = "Disable Death Animation", Command = "vj_npc_nodeathanimation"})
	Panel:AddControl("Checkbox", {Label = "Disable Corpses", Command = "vj_npc_nocorpses"})
	Panel:AddControl("Checkbox", {Label = "Disable Gibbing", Command = "vj_npc_nogib"})
	Panel:ControlHelp("Can be useful if you have a bad PC")
	Panel:AddControl("Checkbox", {Label = "Disable Gib/Death Particles and Effects", Command = "vj_npc_nogibdeathparticles"})
	Panel:AddControl("Checkbox", {Label = "Disable Gib Decals", Command = "vj_npc_nogibdecals"})
	Panel:AddControl( "Label", {Text = "Creature Settings:"})
	Panel:AddControl("Checkbox", {Label = "Disable Leap Attacks", Command = "vj_npc_noleap"})
	Panel:AddControl("Checkbox", {Label = "Disable Players/NPCs Slowing Down on Melee Attack", Command = "vj_npc_slowplayer"})
	Panel:AddControl("Checkbox", {Label = "Disable Players Bleeding on Melee Attack", Command = "vj_npc_bleedenemyonmelee"})
	Panel:AddControl("Checkbox", {Label = "Disable Prop Pushing", Command = "vj_npc_noproppush"})
	Panel:AddControl("Checkbox", {Label = "Disable Prop Attacking", Command = "vj_npc_nopropattack"})
	Panel:AddControl( "Label", {Text = "Human Settings:"})
	Panel:AddControl("Checkbox", {Label = "Disable Weapons", Command = "vj_npc_noweapon"})
	Panel:ControlHelp("Humans will not be able to use weapons!")
	Panel:AddControl("Checkbox", {Label = "Disable Reloading", Command = "vj_npc_noreload"})
	Panel:AddControl("Checkbox", {Label = "Disable Throwing Grenades", Command = "vj_npc_nothrowgrenade"})
	Panel:AddControl("Checkbox", {Label = "Disable Running from Grenades", Command = "vj_npc_noscarednade"})
	Panel:AddControl("Checkbox", {Label = "Disable Use Regulator", Command = "vj_npc_nouseregulator"})
	Panel:ControlHelp("Use this if a weapon you tried on the SNPC didn't work")
	Panel:AddControl("Checkbox", {Label = "Disable Unlimited Ammo", Command = "vj_npc_noforeverammo"})
	Panel:AddControl( "Label", {Text = "Animal Settings:"})
	Panel:AddControl("Checkbox", {Label = "Disable Running on Touch", Command = "vj_npc_animal_runontouch"})
	Panel:AddControl("Checkbox", {Label = "Disable Running on Hit", Command = "vj_npc_animal_runonhit"})
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
	local vj_soundsettings_reset = {Options = {}, CVars = {}, Label = "Reset Everything:", MenuButton = "0"}
	vj_soundsettings_reset.Options["#vjbase.menugeneral.default"] = {
	vj_npc_sd_nosounds = "0",
	vj_npc_sd_idle = "0",
	vj_npc_sd_alert = "0",
	vj_npc_sd_pain = "0",
	vj_npc_sd_death = "0",
	vj_npc_sd_footstep = "0",
	vj_npc_sd_soundtrack = "0",
	vj_npc_sd_meleeattack = "0",
	vj_npc_sd_meleeattackmiss = "0",
	vj_npc_sd_rangeattack = "0",
	vj_npc_sd_leapattack = "0",
	//vj_npc_sd_combatidle = "0",
	vj_npc_sd_ongrenadesight = "0",
	vj_npc_sd_onplayersight = "0",
	vj_npc_sd_damagebyplayer = "0",
	vj_npc_sd_slowplayer = "0",
	vj_npc_sd_gibbing = "0",
	vj_npc_sd_breath = "0",
	vj_npc_sd_followplayer = "0",
	vj_npc_sd_becomenemytoply = "0",
	vj_npc_sd_medic = "0",
	vj_npc_sd_reload = "0",
	vj_npc_sd_grenadeattack = "0",
	vj_npc_sd_suppressing = "0",
	vj_npc_sd_callforhelp = "0",
	vj_npc_sd_onreceiveorder = "0",
	}
	Panel:AddControl("ComboBox", vj_soundsettings_reset)
	Panel:AddControl("Checkbox", {Label = "Disable All Sounds", Command = "vj_npc_sd_nosounds"})
	Panel:AddControl("Checkbox", {Label = "Disable Idle Sounds", Command = "vj_npc_sd_idle"})
	//Panel:AddControl("Checkbox", {Label = "Disable Combat Idle Sounds", Command = "vj_npc_sd_combatidle"})
	Panel:AddControl("Checkbox", {Label = "Disable Breathing Sounds", Command = "vj_npc_sd_breath"})
	Panel:AddControl("Checkbox", {Label = "Disable Melee Attack Sounds", Command = "vj_npc_sd_meleeattack"})
	Panel:AddControl("Checkbox", {Label = "Disable Melee Miss Sounds", Command = "vj_npc_sd_meleeattackmiss"})
	Panel:AddControl("Checkbox", {Label = "Disable Range Attack Sounds", Command = "vj_npc_sd_rangeattack"})
	Panel:AddControl("Checkbox", {Label = "Disable Alert Sounds", Command = "vj_npc_sd_alert"})
	Panel:AddControl("Checkbox", {Label = "Disable Pain Sounds", Command = "vj_npc_sd_pain"})
	Panel:AddControl("Checkbox", {Label = "Disable Death Sounds", Command = "vj_npc_sd_death"})
	Panel:AddControl("Checkbox", {Label = "Disable Footstep Sounds", Command = "vj_npc_sd_footstep"})
	Panel:AddControl("Checkbox", {Label = "Disable Sound Tracks", Command = "vj_npc_sd_soundtrack"})
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
	Panel:AddControl("Checkbox", {Label = "Disable Reload Callout Sounds", Command = "vj_npc_sd_reload"})
	Panel:AddControl("Checkbox", {Label = "Disable Suppressing Callout Sounds", Command = "vj_npc_sd_suppressing"})
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
	Panel:AddControl( "Label", {Text = "WARNING: Some of this commands cause lag!"})
	Panel:AddControl("Button", {Label = "Cached Models (Console)", Command = "listmodels"})
	local vj_devsettings_reset = {Options = {}, CVars = {}, Label = "Reset Everything:", MenuButton = "0"}
	vj_devsettings_reset.Options["#vjbase.menugeneral.default"] = {
	vj_npc_printammo = "0",
	vj_npc_printweapon = "0",
	vj_npc_printseenenemy = "0",
	vj_npc_printalerted = "0",
	vj_npc_printaccuracy = "0",
	vj_npc_printdied = "0",
	vj_npc_printondamage = "0",
	vj_npc_printontouch = "0",
	vj_npc_printstoppedattacks = "0",
	vj_npc_printtakingcover = "0",
	vj_npc_printenemyclass = "0",
	vj_npc_drvrejfriendly = "0",
	vj_npc_printresteenemy = "0",
	vj_npc_printlastseenenemy = "0",
	vj_npc_usedevcommands = "0",
	}
	Panel:AddControl("ComboBox", vj_devsettings_reset)
	Panel:AddControl("Checkbox", {Label = "All SNPCs and NPCs love DrVrej?! =D", Command = "vj_npc_drvrejfriendly"})
	Panel:AddControl("Checkbox", {Label = "Enable Developer Mode?", Command = "vj_npc_usedevcommands"})
	Panel:ControlHelp("Many of the commands below require this to be checked!")
	Panel:AddControl("Checkbox", {Label = "Print On Touch (Console)", Command = "vj_npc_printontouch"})
	Panel:AddControl("Checkbox", {Label = "Print On Damage (Console)", Command = "vj_npc_printondamage"})
	Panel:AddControl("Checkbox", {Label = "Print On Death (Console)", Command = "vj_npc_printdied"})
	Panel:AddControl("Checkbox", {Label = "Print On Reset Enemy (Console)", Command = "vj_npc_printresteenemy"})
	Panel:AddControl("Checkbox", {Label = "Print Stopped Attacks (Console)", Command = "vj_npc_printstoppedattacks"})
	Panel:AddControl("Checkbox", {Label = "Print Current Enemy Class (Console)", Command = "vj_npc_printenemyclass"})
	Panel:AddControl("Checkbox", {Label = "Print Seen Enemy (Console)", Command = "vj_npc_printseenenemy"})
	Panel:AddControl("Checkbox", {Label = "Print Alerted (Console)", Command = "vj_npc_printalerted"})
	Panel:AddControl("Checkbox", {Label = "Print Taking Cover (Console)", Command = "vj_npc_printtakingcover"})
	Panel:AddControl("Checkbox", {Label = "Print 'LastSeenEnemy' time (Chat/Console)", Command = "vj_npc_printlastseenenemy"})
	Panel:AddControl( "Label", {Text = "Human Settings:"})
	Panel:AddControl("Checkbox", {Label = "Print Current Weapon Class (Console)", Command = "vj_npc_printweapon"})
	Panel:AddControl("Checkbox", {Label = "Print Amount of Ammo (Console)", Command = "vj_npc_printammo"})
	Panel:AddControl("Checkbox", {Label = "Print Gun Accuracy (Console)", Command = "vj_npc_printaccuracy"})
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_ADDTOMENU_SNPC()
	spawnmenu.AddToolMenuOption( "DrVrej", "VJ SNPC Configures", "SNPC Options", "Options", "", "", VJ_SNPC_OPTIONS, {} )
	spawnmenu.AddToolMenuOption( "DrVrej", "VJ SNPC Configures", "SNPC Settings", "Settings", "", "", VJ_SNPC_SETTINGS, {} )
	spawnmenu.AddToolMenuOption( "DrVrej", "VJ SNPC Configures", "SNPC Sound Settings", "Sound Settings", "", "", VJ_SNPC_SOUNDSETTINGS, {} )
	spawnmenu.AddToolMenuOption( "DrVrej", "VJ SNPC Configures", "SNPC Developer Settings", "Developer Settings", "", "", VJ_SNPC_DEVSETTINGS, {} )
end
hook.Add( "PopulateToolMenu", "VJ_ADDTOMENU_SNPC", VJ_ADDTOMENU_SNPC )