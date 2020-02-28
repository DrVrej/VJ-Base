/*--------------------------------------------------
	=============== Language Files ===============
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
include('autorun/vj_controls.lua')

/*
	How it works:
	* Looks for the current set language and translates all the strings that are given.
	* If a string isn't translated, it will automatically default to English.
	* When a updated while in a map, it will try to refresh some of the menus, but many menus requires a map restart!
*/

if (CLIENT) then
	local function add(name, str) -- Aveli tirountsnelou hamar e
		language.Add(name, str)
	end
	
	function VJ_REFRESH_LANGUAGE()
		local conv = GetConVar("vj_language"):GetString()
		
		add("vjbase.menugeneral.default", "Default") -- Deprecated, don't use or translate.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ ///// WARNING: Don't touch anything above this line! \\\\\ ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		-- General Base (Used everywhere)
		// add("vjbase.general.print.runningvj", "Notice: This server is running VJ Base.")
		
		-- General Menu (Used everywhere)
		add("vjbase.menu.general.default", "Default")
		add("vjbase.menu.general.admin.only", "Notice: Only admins can use this menu.")
		add("vjbase.menu.general.admin.not", "You are not a admin!")
		add("vjbase.menu.general.reset.everything", "Reset Everything")
		add("vjbase.menu.general.reset.everything.colon", "Reset Everything:")
		add("vjbase.menu.general.snpc.warnfuture", "WARNING: Only future spawned SNPCs will be affected!")
		add("vjbase.menu.general.snpc.creaturesettings", "Creature Settings:")
		add("vjbase.menu.general.snpc.humansettings", "Human Settings:")
		
		-- Menu Tabs
		add("vjbase.menu.tabs.mainmenu", "Main Menu")
		add("vjbase.menu.tabs.settings.snpc", "SNPC Settings")
		add("vjbase.menu.tabs.settings.weapon", "Weapon Settings")
		add("vjbase.menu.tabs.settings.hud", "HUD Settings")
		add("vjbase.menu.tabs.tools", "Tools")
		add("vjbase.menu.tabs.configures.snpc", "SNPC Configures")
		
		-- Main Menu
		add("vjbase.menu.cleanup", "Clean Up")
		add("vjbase.menu.cleanup.everything", "Clean Up Everything")
		add("vjbase.menu.cleanup.stopsounds", "Stop all Sounds")
		add("vjbase.menu.cleanup.remove.vjnpcs", "Remove all VJ SNPCs")
		add("vjbase.menu.cleanup.remove.npcs", "Remove all (S)NPCs")
		add("vjbase.menu.cleanup.remove.spawners", "Remove all Spawners")
		add("vjbase.menu.cleanup.remove.corpses", "Remove all Corpses")
		add("vjbase.menu.cleanup.remove.vjgibs", "Remove all VJ Gibs")
		add("vjbase.menu.cleanup.remove.groundweapons", "Remove all Ground Weapons")
		add("vjbase.menu.cleanup.remove.props", "Remove all Props")
		add("vjbase.menu.cleanup.remove.decals", "Remove all Decals")
		add("vjbase.menu.cleanup.remove.allweapons", "Remove all of your Weapons")
		add("vjbase.menu.cleanup.remove.allammo", "Remove all of your Ammo")
		
		add("vjbase.menu.helpsupport", "Contact and Support")
		add("vjbase.menu.helpsupport.reportbug", "Report a Bug")
		add("vjbase.menu.helpsupport.suggestion", "Suggest Something")
		add("vjbase.menu.helpsupport.discord", "Join me on Discord!")
		add("vjbase.menu.helpsupport.steam", "Join me on Steam!")
		add("vjbase.menu.helpsupport.youtube", "Subscribe me on YouTube!")
		add("vjbase.menu.helpsupport.twtiter", "Follow me on Twitter!")
		add("vjbase.menu.helpsupport.patron", "Donate me on Patron!")
		add("vjbase.menu.helpsupport.label1", "Follow one of these links to get updates about my addons!")
		add("vjbase.menu.helpsupport.label2", "Donations help and encourage me to continue making/updating addons! Thank you!")
		add("vjbase.menu.helpsupport.thanks", "Thanks for your support!")
		
		add("vjbase.menu.svsettings", "Admin Server Settings")
		add("vjbase.menu.svsettings.label", "WARNING: SOME SETTINGS NEED CHEATS ENABLED!")
		add("vjbase.menu.svsettings.admin.npcproperties", "Restrict SNPC Properties to Admins Only")
		add("vjbase.menu.svsettings.noclip", "Allow NoClip")
		add("vjbase.menu.svsettings.weapons", "Allow Weapons")
		add("vjbase.menu.svsettings.pvp", "Allow PvP")
		add("vjbase.menu.svsettings.godmode", "God Mode (Everyone)")
		add("vjbase.menu.svsettings.bonemanip.npcs", "Bone Manipulate NPCs")
		add("vjbase.menu.svsettings.bonemanip.players", "Bone Manipulate Players")
		add("vjbase.menu.svsettings.bonemanip.others", "Bone Manipulate Others")
		add("vjbase.menu.svsettings.timescale.general", "General TimeScale")
		add("vjbase.menu.svsettings.timescale.physics", "Physics TimeScale")
		add("vjbase.menu.svsettings.gravity", "General Gravity")
		add("vjbase.menu.svsettings.maxentsprops", "Max Props/Entities:")
		
		add("vjbase.menu.clsettings", "Client Settings")
		add("vjbase.menu.clsettings.label", "Use this menu to customize your client settings, servers can't change these settings!")
		add("vjbase.menu.clsettings.labellang", "Select the Language:")
		add("vjbase.menu.clsettings.notify.lang", "VJ Base Language Set To:")
		
		add("vjbase.menu.info", "Information")
		
		add("vjbase.menu.plugins", "Installed Plugins")
		add("vjbase.menu.plugins.label", "List of installed VJ Base plugins.")
		add("vjbase.menu.plugins.version", "Version:")
		add("vjbase.menu.plugins.totalplugins", "Total Plugins:")
		add("vjbase.menu.plugins.header1", "Name")
		add("vjbase.menu.plugins.header2", "Type")
		add("vjbase.menu.plugins.notfound", "No Plugins Found.")
		add("vjbase.menu.plugins.changelog", "Changelog")
		add("vjbase.menu.plugins.makeaddon", "Want to make an addon? Click Here!")
		
		-- SNPC Menus
		add("vjbase.menu.snpc.options", "Options")
		add("vjbase.menu.snpc.options.difficulty.header", "Select the Difficulty:")
		add("vjbase.menu.snpc.options.difficulty.neanderthal", "Neanderthal | -99% Health and Damage")
		add("vjbase.menu.snpc.options.difficulty.childs_play", "Child's Play | -75% Health and Damage")
		add("vjbase.menu.snpc.options.difficulty.easy", "Easy | -50% Health and Damage")
		add("vjbase.menu.snpc.options.difficulty.normal", "Normal | Original Health and Damage")
		add("vjbase.menu.snpc.options.difficulty.hard", "Hard | +50% Health and Damage")
		add("vjbase.menu.snpc.options.difficulty.insane", "Insane | +100% Health and Damage")
		add("vjbase.menu.snpc.options.difficulty.impossible", "Impossible | +150% Health and Damage")
		add("vjbase.menu.snpc.options.difficulty.nightmare", "Nightmare | +250% Health and Damage")
		add("vjbase.menu.snpc.options.difficulty.hell_on_earth", "Hell On Earth | +350% Health and Damage")
		add("vjbase.menu.snpc.options.difficulty.total_annihilation", "Total Annihilation | +500% Health and Damage")
		add("vjbase.menu.snpc.options.label1", "Relationship Options:")
		add("vjbase.menu.snpc.options.togglefriendlyantlion", "Antlion Friendly")
		add("vjbase.menu.snpc.options.togglefriendlycombine", "Combine Friendly")
		add("vjbase.menu.snpc.options.togglefriendlyplayer", "Player Friendly")
		add("vjbase.menu.snpc.options.togglefriendlyzombie", "Zombie Friendly")
		add("vjbase.menu.snpc.options.togglefriendlyvj", "VJ Base Friendly")
		add("vjbase.menu.snpc.options.label2", "All VJ SNPCs will be allied!")
		add("vjbase.menu.snpc.options.label3", "Corpse & Health Options:")
		add("vjbase.menu.snpc.options.corpselimit", "Corpse Limit, Def:32")
		add("vjbase.menu.snpc.options.label4", "Corpse Limit when 'Keep Corpses' is off")
		add("vjbase.menu.snpc.options.toggleundocorpses", "Undoable Corpses (Undo Key)")
		add("vjbase.menu.snpc.options.togglecorpsefade", "Fade Corpses")
		add("vjbase.menu.snpc.options.corpsefadetime", "Corpse Fade Time")
		add("vjbase.menu.snpc.options.label5", "Total: 600 seconds (10 Minutes)")
		add("vjbase.menu.snpc.options.togglegibcollision", "Collidable Gibs")
		add("vjbase.menu.snpc.options.togglefadegibs", "Fade Gibs")
		add("vjbase.menu.snpc.options.gibfadetime", "Gib Fade Time")
		add("vjbase.menu.snpc.options.label6", "Default: 30 | Total: 600 seconds (10 Minutes)")
		add("vjbase.menu.snpc.options.togglesnpcgodmode", "God Mode (They won't take any damage)")
		add("vjbase.menu.snpc.options.health", "Health:")
		add("vjbase.menu.snpc.options.defaulthealth", "0 = Default Health (9 digits max!)")
		add("vjbase.menu.snpc.options.label7", "AI Options:")
		add("vjbase.menu.snpc.options.toggleknowenemylocation", "Always Know Enemy Location")
		add("vjbase.menu.snpc.options.sightdistance", "Sight Distance:")
		add("vjbase.menu.snpc.options.label8", "Each NPC has its own distance, but this will make them all the same, so use it cautiously! (0 = Original | Average: 10k)")
		add("vjbase.menu.snpc.options.processtime", "Process Time")
		add("vjbase.menu.snpc.options.whatisprocesstime", "What is Process Time?")
		add("vjbase.menu.snpc.options.label9", "Default: 1 | Lower number causes more lag!")
		add("vjbase.menu.snpc.options.label10", "Miscellaneous Options:")
		add("vjbase.menu.snpc.options.togglegmoddecals", "Use Garry's Mod's Current Blood Decals")
		add("vjbase.menu.snpc.options.label11", "Colors that aren't Yellow or Red won't change!")
		add("vjbase.menu.snpc.options.toggleitemdrops", "Item Drops On Death")
		add("vjbase.menu.snpc.options.toggleshowhudonkilled", "Show HUD Display on SNPC killed (Top Right)")
		add("vjbase.menu.snpc.options.toggleaddfrags", "Add points to the player's scoreboard when killed")
		add("vjbase.menu.snpc.options.togglecreatureopendoor", "Creatures Can Open Doors")
		add("vjbase.menu.snpc.options.togglehumansdropweapon", "Humans Drop Weapon On Death")
		add("vjbase.menu.snpc.options.togglehumanscanjump", "Humans Can Jump")
		add("vjbase.menu.snpc.options.toggleplydroppedweapons", "Players Can Pick Up Dropped Weapons")
		
		add("vjbase.menu.snpc.settings", "Settings")
		add("vjbase.menu.snpc.settings.label1", "AI Settings:")
		add("vjbase.menu.snpc.settings.togglewandering", "Disable Wandering When Idle")
		add("vjbase.menu.snpc.settings.togglechasingenemy", "Disable Chasing Enemy")
		add("vjbase.menu.snpc.settings.label2", "Use this setting with caution, it can break a lot of things!")
		add("vjbase.menu.snpc.settings.togglemedics", "Disable Medic SNPCs")
		add("vjbase.menu.snpc.settings.togglefollowplayer", "Disable Following Player")
		add("vjbase.menu.snpc.settings.label3", "Example: When you press 'E' on a SNPC and they follow you")
		add("vjbase.menu.snpc.settings.toggleallies", "Disable Alliance (No Allies!)")
		add("vjbase.menu.snpc.settings.togglebecomeenemytoply", "Disable Allies Becoming Enemy")
		add("vjbase.menu.snpc.settings.toggleproppush", "Disable Prop Pushing (Creatures)")
		add("vjbase.menu.snpc.settings.togglepropattack", "Disable Prop Attacking (Creatures)")
		add("vjbase.menu.snpc.settings.togglescarednade", "Disable Humans Running from Grenades")
		add("vjbase.menu.snpc.settings.togglereloading", "Disable Weapon Reloading")
		add("vjbase.menu.snpc.settings.label4", "Attack Settings:")
		add("vjbase.menu.snpc.settings.togglemelee", "Disable Melee Attacks")
		add("vjbase.menu.snpc.settings.togglerange", "Disable Range Attacks")
		add("vjbase.menu.snpc.settings.toggleleap", "Disable Leap Attacks (Creatures)")
		add("vjbase.menu.snpc.settings.togglethrownade", "Disable Grenade Attacks (Humans)")
		add("vjbase.menu.snpc.settings.toggleweapons", "Disable Weapons (Humans)")
		add("vjbase.menu.snpc.settings.label5", "Humans will not be able to use weapons!")
		add("vjbase.menu.snpc.settings.togglemeleedsp", "Disable DSP Effect On Heavy Melee Damages")
		add("vjbase.menu.snpc.settings.toggleslowplayer", "Disable Players Slowing Down on Melee Attack")
		add("vjbase.menu.snpc.settings.togglebleedonmelee", "Disable Players/NPCs Bleeding on Melee Attack")
		add("vjbase.menu.snpc.settings.label6", "Miscellaneous Settings:")
		add("vjbase.menu.snpc.settings.toggleidleparticles", "Disable Idle Particles and Effects")
		add("vjbase.menu.snpc.settings.label7", "Disabling this can help with performance")
		add("vjbase.menu.snpc.settings.togglesnpcchat", "Disable SNPC Chat")
		add("vjbase.menu.snpc.settings.label8", "For example: 'Scientist is now following you'")
		add("vjbase.menu.snpc.settings.label9", "Damage & Corpse Settings:")
		add("vjbase.menu.snpc.settings.toggleflinching", "Disable Flinching")
		add("vjbase.menu.snpc.settings.togglebleeding", "Disable Bleeding")
		add("vjbase.menu.snpc.settings.label10", "Disables blood particles, decals, blood pools etc.")
		add("vjbase.menu.snpc.settings.togglebloodpool", "Disable Blood Pools (On Death)")
		add("vjbase.menu.snpc.settings.togglegib", "Disable Gibbing")
		add("vjbase.menu.snpc.settings.label11", "Disabling this can help with performance")
		add("vjbase.menu.snpc.settings.togglegibdecals", "Disable Gib Decals")
		add("vjbase.menu.snpc.settings.togglegibdeathparticles", "Disable Gib/Death Particles and Effects")
		add("vjbase.menu.snpc.settings.toggledeathanim", "Disable Death Animation")
		add("vjbase.menu.snpc.settings.togglecorpses", "Disable Corpses")
		add("vjbase.menu.snpc.settings.label12", "Passive Settings:")
		add("vjbase.menu.snpc.settings.togglerunontouch", "Disable Running on Touch")
		add("vjbase.menu.snpc.settings.togglerunonhit", "Disable Running on Hit")
		
		add("vjbase.menu.snpc.sdsettings", "Sound Settings")
		add("vjbase.menu.snpc.sdsettings.toggleallsounds", "Disable All Sounds")
		add("vjbase.menu.snpc.sdsettings.togglesoundtrack", "Disable Sound Tracks")
		add("vjbase.menu.snpc.sdsettings.toggleidle", "Disable Idle Sounds")
		add("vjbase.menu.snpc.sdsettings.togglebreathing", "Disable Breathing Sounds")
		add("vjbase.menu.snpc.sdsettings.togglefootsteps", "Disable Footstep Sounds")
		add("vjbase.menu.snpc.sdsettings.toggleattacksounds", "Disable Melee Attack Sounds")
		add("vjbase.menu.snpc.sdsettings.togglemeleemiss", "Disable Melee Miss Sounds")
		add("vjbase.menu.snpc.sdsettings.togglerangeattack", "Disable Range Attack Sounds")
		add("vjbase.menu.snpc.sdsettings.togglealert", "Disable Alert Sounds")
		add("vjbase.menu.snpc.sdsettings.togglepain", "Disable Pain Sounds")
		add("vjbase.menu.snpc.sdsettings.toggledeath", "Disable Death Sounds")
		add("vjbase.menu.snpc.sdsettings.togglegibbing", "Disable Gibbing Sounds")
		add("vjbase.menu.snpc.sdsettings.label1", "Also applies to the sounds that play when a gib collides with something")
		add("vjbase.menu.snpc.sdsettings.togglemedic", "Disable Medic Sounds")
		add("vjbase.menu.snpc.sdsettings.togglefollowing", "Disable Following Sounds")
		add("vjbase.menu.snpc.sdsettings.togglecallhelp", "Disable Calling for Help Sounds")
		add("vjbase.menu.snpc.sdsettings.togglereceiveorder", "Disable Receiving Order Sounds")
		add("vjbase.menu.snpc.sdsettings.togglebecomeenemy", "Disable Become Enemy to Player Sounds")
		add("vjbase.menu.snpc.sdsettings.toggleplayersight", "Disable Player Sighting Sounds")
		add("vjbase.menu.snpc.sdsettings.label2", "Special sounds that play when a SNPC sees the player")
		add("vjbase.menu.snpc.sdsettings.toggledmgbyplayer", "Disable Damage By Player Sounds")
		add("vjbase.menu.snpc.sdsettings.label3", "When the player shoots at a SNPC, usually friendly SNPCs")
		add("vjbase.menu.snpc.sdsettings.toggleleap", "Disable Leap Attack Sounds")
		add("vjbase.menu.snpc.sdsettings.toggleslowedplayer", "Disable Slowed Player Sounds")
		add("vjbase.menu.snpc.sdsettings.label4", "Sounds that play when the player is slowed down by melee attack")
		add("vjbase.menu.snpc.sdsettings.togglegrenade", "Disable Grenade Attack Sounds")
		add("vjbase.menu.snpc.sdsettings.togglegrenadesight", "Disable On Grenade Sight Sounds")
		add("vjbase.menu.snpc.sdsettings.togglesuppressing", "Disable Suppressing Call Out Sounds")
		add("vjbase.menu.snpc.sdsettings.togglereload", "Disable Reload Call Out Sounds")
		
		add("vjbase.menu.snpc.devsettings", "Developer Settings")
		add("vjbase.menu.snpc.devsettings.label1", "This settings are used when developing SNPCs.")
		add("vjbase.menu.snpc.devsettings.label2", "WARNING: Some of this options cause lag!")
		add("vjbase.menu.snpc.devsettings.toggledev", "Enable Developer Mode?")
		add("vjbase.menu.snpc.devsettings.label3", "This option must be enabled from here or through the context menu! (Required for the options below)")
		add("vjbase.menu.snpc.devsettings.printtouch", "Print On Touch (Console)")
		add("vjbase.menu.snpc.devsettings.printcurenemy", "Print Current Enemy (Console)")
		add("vjbase.menu.snpc.devsettings.printlastseenenemy", "Print 'LastSeenEnemy' time (Chat/Console)")
		add("vjbase.menu.snpc.devsettings.printonreset", "Print On Reset Enemy (Console)")
		add("vjbase.menu.snpc.devsettings.printonstopattack", "Print On Stopped Attacks (Console)")
		add("vjbase.menu.snpc.devsettings.printtakingcover", "Print Taking Cover (Console)")
		add("vjbase.menu.snpc.devsettings.printondamage", "Print On Damage (Console)")
		add("vjbase.menu.snpc.devsettings.printondeath", "Print On Death (Console)")
		add("vjbase.menu.snpc.devsettings.printweapon", "Print Current Weapon (Console)")
		add("vjbase.menu.snpc.devsettings.printammo", "Print Amount of Ammo (Console)")
		add("vjbase.menu.snpc.devsettings.printaccuracy", "Print Gun Accuracy (Console)")
		add("vjbase.menu.snpc.devsettings.cachedmodels", "Cached Models (Console)")
		
		add("vjbase.menu.snpc.consettings", "Controller Settings")
		add("vjbase.menu.snpc.consettings.label1", "Notice: These are client-side settings only!")
		add("vjbase.menu.snpc.consettings.label2", "How far or close the zoom changes every click.")
		add("vjbase.menu.snpc.consettings.displayhud", "Display HUD")
		add("vjbase.menu.snpc.consettings.zoomdistance", "Zoom Distance")
		add("vjbase.menu.snpc.consettings.displaydev", "Display Developer Entities")
		add("vjbase.menu.snpc.consettings.label3", "Key Bindings:")
		add("vjbase.menu.snpc.consettings.bind.header1", "Control")
		add("vjbase.menu.snpc.consettings.bind.header2", "Description")
		add("vjbase.menu.snpc.consettings.bind.clickmsg1", "Selected Key:")
		add("vjbase.menu.snpc.consettings.bind.clickmsg2", "Description:")
		add("vjbase.menu.snpc.consettings.bind.movement", "Movement (Supports 8-Way)")
		add("vjbase.menu.snpc.consettings.bind.exitcontrol", "Exit the Controller")
		add("vjbase.menu.snpc.consettings.bind.meleeattack", "Melee Attack")
		add("vjbase.menu.snpc.consettings.bind.rangeattack", "Range / Weapon Attack")
		add("vjbase.menu.snpc.consettings.bind.leaporgrenade", "Leap / Grenade Attack")
		add("vjbase.menu.snpc.consettings.bind.reloadweapon", "Reload Weapon")
		add("vjbase.menu.snpc.consettings.bind.togglebullseye", "Toggle Bullseye Tracking")
		add("vjbase.menu.snpc.consettings.bind.cameraup", "Move Camera Up")
		add("vjbase.menu.snpc.consettings.bind.cameradown", "Move Camera Down")
		add("vjbase.menu.snpc.consettings.bind.cameraforward", "Move Camera Forward")
		add("vjbase.menu.snpc.consettings.bind.camerabackward", "Move Camera Backward")
		add("vjbase.menu.snpc.consettings.bind.cameraleft", "Move Camera Left")
		add("vjbase.menu.snpc.consettings.bind.cameraright", "Move Camera Right")
		add("vjbase.menu.snpc.consettings.bind.resetzoom", "Reset Zoom")
		
		-- Weapon Client Settings
		add("vjbase.menu.clweapon", "Client Settings")
		add("vjbase.menu.clweapon.notice", "Notice: This settings are client, meaning it won't change for other people!")
		add("vjbase.menu.clweapon.togglemuzzle", "Disable Muzzle Flash")
		add("vjbase.menu.clweapon.togglemuzzlelight", "Disable Muzzle Flash Dynamic Light")
		add("vjbase.menu.clweapon.togglemuzzle.label", "Disabling muzzle flash will also disable this")
		add("vjbase.menu.clweapon.togglemuzzlesmoke", "Disable Muzzle Smoke")
		add("vjbase.menu.clweapon.togglemuzzleheatwave", "Disable Muzzle Heat Wave")
		add("vjbase.menu.clweapon.togglemuzzlebulletshells", "Disable Bullet Shells")
		
		-- NPC Properties (C Menu)
		add("vjbase.menuproperties.control", "TAKE CONTROL")
		add("vjbase.menuproperties.guard", "Toggle Guarding")
		add("vjbase.menuproperties.wander", "Toggle Wandering")
		add("vjbase.menuproperties.medic", "Make Medic (Toggle)")
		add("vjbase.menuproperties.allyme", "Ally To Me")
		add("vjbase.menuproperties.hostileme", "Hostile To Me")
		add("vjbase.menuproperties.slay", "Slay")
		add("vjbase.menuproperties.gib", "Gib (If Valid)")
		add("vjbase.menuproperties.devmode", "Toggle Developer Mode")
		
		if conv == "armenian" then
			
		elseif conv == "russian" then
			
		elseif conv == "german" then
			
		elseif conv == "french" then
			
		elseif conv == "lithuanian" then
			
		elseif conv == "spanish_lt" then
			
		elseif conv == "portuguese_br" then
			
		end
		
		print("VJ Base Language Set To: "..conv)
	end
	
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ ///// WARNING: Don't touch anything below this line! \\\\\ ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	VJ_REFRESH_LANGUAGE() -- Arachin ankam ganch e, garevor e asiga!
end