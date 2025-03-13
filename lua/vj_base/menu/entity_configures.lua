/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
---------------------------------------------------------------------------------------------------------------------------------------------
local function VJ_NPC_SETTINGS_AI(panel)
	if !game.SinglePlayer() && !LocalPlayer():IsAdmin() then
		panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.not"})
		panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.only"})
		return
	end

	panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.only"})
	panel:AddControl("Label", {Text = "#vjbase.menu.general.npc.note.future"})
	panel:AddControl("Button", {Text = "#vjbase.menu.general.reset.everything", Command = "vj_npc_sight_distance 0\n vj_npc_sight_xray 0\n vj_npc_wander 1\n vj_npc_chase 1\n vj_npc_flinch 1\n vj_npc_investigate 1\n vj_npc_callhelp 1\n vj_npc_ply_follow 1\n vj_npc_medic 1\n vj_npc_eat 1\n vj_npc_dangerdetection 1\n vj_npc_human_jump 1\n vj_npc_creature_opendoor 1\n vj_npc_allies 1\n vj_npc_ply_betray 1\n vj_npc_fri_base 0\n vj_npc_fri_player 0\n vj_npc_fri_zombie 0\n vj_npc_fri_antlion 0\n vj_npc_fri_combine 0"})
	
	panel:AddControl("TextBox", {Label = "#vjbase.menu.npc.settings.ai.sightdistance", Command = "vj_npc_sight_distance", WaitForEnter = "0"})
	panel:ControlHelp("#vjbase.menu.npc.settings.ai.sightdistance.label")
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.ai.sightxray", Command = "vj_npc_sight_xray"})
	panel:ControlHelp("#vjbase.menu.npc.settings.ai.sightxray.label")
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.ai.wander", Command = "vj_npc_wander"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.ai.chase", Command = "vj_npc_chase"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.ai.detectdanger", Command = "vj_npc_dangerdetection"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.ai.flinch", Command = "vj_npc_flinch"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.ai.eat", Command = "vj_npc_eat"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.ai.investigate", Command = "vj_npc_investigate"})
	panel:ControlHelp("#vjbase.menu.npc.settings.ai.investigate.label")
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.ai.alliances", Command = "vj_npc_allies"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.ai.medics", Command = "vj_npc_medic"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.ai.callhelp", Command = "vj_npc_callhelp"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.ai.plybetray", Command = "vj_npc_ply_betray"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.ai.plyfollow", Command = "vj_npc_ply_follow"})
	panel:ControlHelp("#vjbase.menu.npc.settings.ai.plyfollow.label")
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.ai.creatureopendoor", Command = "vj_npc_creature_opendoor"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.ai.humanjump", Command = "vj_npc_human_jump"})
	panel:AddControl("Label", {Text = "#vjbase.menu.npc.settings.ai.relation.label"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.ai.relation.antlion", Command = "vj_npc_fri_antlion"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.ai.relation.combine", Command = "vj_npc_fri_combine"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.ai.relation.player", Command = "vj_npc_fri_player"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.ai.relation.zombie", Command = "vj_npc_fri_zombie"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.ai.relation.base", Command = "vj_npc_fri_base"})
	panel:ControlHelp("#vjbase.menu.npc.settings.ai.relation.base.label")
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function VJ_NPC_SETTINGS_ATTACKS(panel)
	if !game.SinglePlayer() && !LocalPlayer():IsAdmin() then
		panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.not"})
		panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.only"})
		return
	end

	panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.only"})
	panel:AddControl("Label", {Text = "#vjbase.menu.general.npc.note.future"})
	panel:AddControl("Button", {Text = "#vjbase.menu.general.reset.everything", Command = "vj_npc_wep_ply_pickup 1\n vj_npc_wep_drop 1\n vj_npc_wep_reload 1\n vj_npc_wep 1\n vj_npc_grenade 1\n vj_npc_melee_ply_dsp 1\n vj_npc_melee_propint 1\n vj_npc_melee_bleed 1\n vj_npc_melee_ply_speed 1\n vj_npc_melee 1\n vj_npc_range 1\n vj_npc_leap 1"})
	
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.atk.range", Command = "vj_npc_range"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.atk.grenade", Command = "vj_npc_grenade"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.atk.leap", Command = "vj_npc_leap"})
	panel:AddControl("Label", {Text = "#vjbase.menu.npc.settings.atk.melee.label"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.atk.melee", Command = "vj_npc_melee"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.atk.melee.bleed", Command = "vj_npc_melee_bleed"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.atk.melee.ply.dsp", Command = "vj_npc_melee_ply_dsp"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.atk.melee.ply.speed", Command = "vj_npc_melee_ply_speed"})
	local propint = {Options = {}, CVars = {}, Label = "#vjbase.menu.npc.settings.atk.melee.propint.header", MenuButton = "0"}
		propint.Options["#vjbase.menu.npc.settings.atk.melee.propint.disable"] = {vj_npc_melee_propint = "0"}
		propint.Options["#vjbase.menu.npc.settings.atk.melee.propint.all"] = {vj_npc_melee_propint = "1"}
		propint.Options["#vjbase.menu.npc.settings.atk.melee.propint.onlydamage"] = {vj_npc_melee_propint = "2"}
		propint.Options["#vjbase.menu.npc.settings.atk.melee.propint.onlypush"] = {vj_npc_melee_propint = "3"}
	panel:AddControl("ComboBox", propint)
	panel:AddControl("Label", {Text = "#vjbase.menu.npc.settings.atk.wep.label"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.atk.wep", Command = "vj_npc_wep"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.atk.wep.reload", Command = "vj_npc_wep_reload"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.atk.wep.drop", Command = "vj_npc_wep_drop"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.atk.wep.ply.pickup", Command = "vj_npc_wep_ply_pickup"})
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function VJ_NPC_SETTINGS_GENERAL(panel)
	if !game.SinglePlayer() && !LocalPlayer():IsAdmin() then
		panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.not"})
		panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.only"})
		return
	end

	panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.only"})
	panel:AddControl("Label", {Text = "#vjbase.menu.general.npc.note.future"})
	panel:AddControl("Button", {Text = "#vjbase.menu.general.reset.everything", Command = "vj_npc_corpse 1\n vj_npc_corpse_limit 32\n vj_npc_corpse_collision 0\n vj_npc_corpse_fade 0\n vj_npc_corpse_fadetime 10\n vj_npc_corpse_undo 0\n vj_npc_gib 1\n vj_npc_gib_vfx 1\n vj_npc_gib_collision 0\n vj_npc_gib_fade 1\n vj_npc_gib_fadetime 90\n vj_npc_god 0\n vj_npc_health 0\n vj_npc_blood 1\n vj_npc_blood_pool 1\n vj_npc_blood_gmod 0\n vj_npc_anim_death 1\n vj_npc_loot 1\n vj_npc_difficulty 0\n vj_npc_ply_frag 1\n vj_npc_ply_chat 1"})
	
	local vj_difficulty = {Options = {}, CVars = {}, Label = "#vjbase.menu.npc.settings.gen.difficulty.header", MenuButton = "0"}
		vj_difficulty.Options["#vjbase.menu.npc.settings.gen.difficulty.neanderthal"] = {vj_npc_difficulty = "-3"}
		vj_difficulty.Options["#vjbase.menu.npc.settings.gen.difficulty.childs_play"] = {vj_npc_difficulty = "-2"}
		vj_difficulty.Options["#vjbase.menu.npc.settings.gen.difficulty.easy"] = {vj_npc_difficulty = "-1"}
		vj_difficulty.Options["#vjbase.menu.npc.settings.gen.difficulty.normal"] = {vj_npc_difficulty = "0"}
		vj_difficulty.Options["#vjbase.menu.npc.settings.gen.difficulty.hard"] = {vj_npc_difficulty = "1"}
		vj_difficulty.Options["#vjbase.menu.npc.settings.gen.difficulty.insane"] = {vj_npc_difficulty = "2"}
		vj_difficulty.Options["#vjbase.menu.npc.settings.gen.difficulty.impossible"] = {vj_npc_difficulty = "3"}
		vj_difficulty.Options["#vjbase.menu.npc.settings.gen.difficulty.nightmare"] = {vj_npc_difficulty = "4"}
		vj_difficulty.Options["#vjbase.menu.npc.settings.gen.difficulty.hell_on_earth"] = {vj_npc_difficulty = "5"}
		vj_difficulty.Options["#vjbase.menu.npc.settings.gen.difficulty.total_annihilation"] = {vj_npc_difficulty = "6"}
	panel:AddControl("ComboBox", vj_difficulty)
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.gen.deathanim", Command = "vj_npc_anim_death"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.gen.lootdrops", Command = "vj_npc_loot"})
	
	panel:AddControl("Label", {Text = "#vjbase.menu.npc.settings.gen.health.label"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.gen.health.god", Command = "vj_npc_god"})
	panel:AddControl("TextBox", {Label = "#vjbase.menu.npc.settings.gen.health.override", Command = "vj_npc_health", WaitForEnter = "0"})
	panel:ControlHelp("#vjbase.menu.npc.settings.gen.health.override.label")
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.gen.health.blood.vfx", Command = "vj_npc_blood"})
	panel:ControlHelp("#vjbase.menu.npc.settings.gen.health.blood.vfx.label")
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.gen.health.blood.pool", Command = "vj_npc_blood_pool"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.gen.health.blood.gmoddecals", Command = "vj_npc_blood_gmod"})
	panel:ControlHelp("#vjbase.menu.npc.settings.gen.health.blood.gmoddecals.label")
	
	panel:AddControl("Label", {Text = "#vjbase.menu.npc.settings.gen.corpse.label"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.gen.corpse", Command = "vj_npc_corpse"})
	panel:AddControl("Slider", {Label = "#vjbase.menu.npc.settings.gen.corpse.limit", min = 4, max = 300, Command = "vj_npc_corpse_limit"})
	panel:ControlHelp("#vjbase.menu.npc.settings.gen.corpse.limit.label")
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.gen.corpse.fade", Command = "vj_npc_corpse_fade"})
	panel:AddControl("Slider", {Label = "#vjbase.menu.npc.settings.gen.corpse.fadetime", min = 0, max = 600, Command = "vj_npc_corpse_fadetime"})
	panel:ControlHelp("#vjbase.menu.npc.settings.gen.corpse.fadetime.label")
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.gen.corpse.undo", Command = "vj_npc_corpse_undo"})
	local vj_collision = {Options = {}, CVars = {}, Label = "#vjbase.menu.npc.settings.gen.collision.header", MenuButton = "0"}
		vj_collision.Options["#vjbase.menu.npc.settings.gen.collision.default"] = {vj_npc_corpse_collision = "0"}
		vj_collision.Options["#vjbase.menu.npc.settings.gen.collision.everything"] = {vj_npc_corpse_collision = "1"}
		vj_collision.Options["#vjbase.menu.npc.settings.gen.collision.onlyworld"] = {vj_npc_corpse_collision = "2"}
		vj_collision.Options["#vjbase.menu.npc.settings.gen.collision.excludedebris"] = {vj_npc_corpse_collision = "3"}
		vj_collision.Options["#vjbase.menu.npc.settings.gen.collision.excludeplynpcs"] = {vj_npc_corpse_collision = "4"}
		vj_collision.Options["#vjbase.menu.npc.settings.gen.collision.excludeply"] = {vj_npc_corpse_collision = "5"}
	panel:AddControl("ComboBox", vj_collision)
	
	panel:AddControl("Label", {Text = "#vjbase.menu.npc.settings.gen.gib.label"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.gen.gib", Command = "vj_npc_gib"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.gen.gib.vfx", Command = "vj_npc_gib_vfx"})
	panel:ControlHelp("#vjbase.menu.npc.settings.gen.gib.vfx.label")
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.gen.gib.collision", Command = "vj_npc_gib_collision"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.gen.gib.fade", Command = "vj_npc_gib_fade"})
	panel:AddControl("Slider", {Label = "#vjbase.menu.npc.settings.gen.gib.fadetime", min = 0, max = 600, Command = "vj_npc_gib_fadetime"})
	panel:ControlHelp("#vjbase.menu.npc.settings.gen.gib.fadetime.label")
	
	panel:AddControl("Label", {Text = "#vjbase.menu.npc.settings.gen.ply.label"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.gen.ply.addfrags", Command = "vj_npc_ply_frag"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.gen.ply.chat", Command = "vj_npc_ply_chat"})
	panel:ControlHelp("#vjbase.menu.npc.settings.gen.ply.chat.label")
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function VJ_NPC_SETTINGS_SOUND(panel)
	if !game.SinglePlayer() && !LocalPlayer():IsAdmin() then
		panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.not"})
		panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.only"})
		return
	end
	
	panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.only"})
	panel:AddControl("Label", {Text = "#vjbase.menu.general.npc.note.future"})
	panel:AddControl("Button", {Text = "#vjbase.menu.general.reset.everything", Command = "vj_npc_snd 1\n vj_npc_snd_idle 1\n vj_npc_snd_alert 1\n vj_npc_snd_pain 1\n vj_npc_snd_death 1\n vj_npc_snd_footstep 1\n vj_npc_snd_track 1\n vj_npc_snd_melee 1\n vj_npc_snd_range 1\n vj_npc_snd_leap 1\n vj_npc_snd_danger 1\n vj_npc_snd_plysight 1\n vj_npc_snd_plydamage 1\n vj_npc_snd_plyspeed 1\n vj_npc_snd_gib 1\n vj_npc_snd_breath 1\n vj_npc_snd_plyfollow 1\n vj_npc_snd_plybetrayal 1\n vj_npc_snd_medic 1\n vj_npc_snd_wep_reload 1\n vj_npc_snd_grenade 1\n vj_npc_snd_wep_suppressing 1\n vj_npc_snd_callhelp 1\n vj_npc_snd_receiveorder 1"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.snd.togglesounds", Command = "vj_npc_snd"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.snd.togglesoundtrack", Command = "vj_npc_snd_track"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.snd.toggleidle", Command = "vj_npc_snd_idle"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.snd.togglebreathing", Command = "vj_npc_snd_breath"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.snd.togglefootsteps", Command = "vj_npc_snd_footstep"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.snd.togglemelee", Command = "vj_npc_snd_melee"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.snd.togglerange", Command = "vj_npc_snd_range"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.snd.togglealert", Command = "vj_npc_snd_alert"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.snd.togglepain", Command = "vj_npc_snd_pain"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.snd.toggledeath", Command = "vj_npc_snd_death"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.snd.togglegibbing", Command = "vj_npc_snd_gib"})
	panel:ControlHelp("#vjbase.menu.npc.settings.snd.togglegibbing.label")
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.snd.togglemedic", Command = "vj_npc_snd_medic"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.snd.togglefollowing", Command = "vj_npc_snd_plyfollow"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.snd.togglecallhelp", Command = "vj_npc_snd_callhelp"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.snd.togglereceiveorder", Command = "vj_npc_snd_receiveorder"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.snd.togglebecomeenemy", Command = "vj_npc_snd_plybetrayal"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.snd.toggleplayersight", Command = "vj_npc_snd_plysight"})
	panel:ControlHelp("#vjbase.menu.npc.settings.snd.toggleplayersight.label")
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.snd.toggledmgbyplayer", Command = "vj_npc_snd_plydamage"})
	panel:ControlHelp("#vjbase.menu.npc.settings.snd.toggledmgbyplayer.label")
	
	panel:AddControl("Label", {Text = "#vjbase.menu.general.npc.creature"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.snd.toggleleap", Command = "vj_npc_snd_leap"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.snd.toggleslowedplayer", Command = "vj_npc_snd_plyspeed"})
	panel:ControlHelp("#vjbase.menu.npc.settings.snd.toggleslowedplayer.label")
	
	panel:AddControl("Label", {Text = "#vjbase.menu.general.npc.human"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.snd.togglegrenade", Command = "vj_npc_snd_grenade"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.snd.toggledangersight", Command = "vj_npc_snd_danger"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.snd.togglesuppressing", Command = "vj_npc_snd_wep_suppressing"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.snd.togglereload", Command = "vj_npc_snd_wep_reload"})
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function VJ_NPC_SETTINGS_DEV(panel)
	if !game.SinglePlayer() && !LocalPlayer():IsAdmin() then
		panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.not"})
		panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.only"})
		return
	end
	
	panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.only"})
	panel:AddControl("Label", {Text = "#vjbase.menu.npc.settings.dev.header.main"})
	panel:AddControl("Label", {Text = "#vjbase.menu.npc.settings.dev.header.warning"})
	panel:AddControl("Button", {Text = "#vjbase.menu.general.reset.everything", Command = "vj_npc_debug_weapon 0\n vj_npc_debug_damage 0\n vj_npc_debug_touch 0\n vj_npc_debug_attack 0\n vj_npc_debug_takingcover 0\n vj_npc_debug_resetenemy 0\n vj_npc_debug_lastseenenemytime 0\n vj_npc_debug 0\n vj_npc_debug_enemy 0\n vj_npc_debug_engine 0"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.dev.debug.toggle", Command = "vj_npc_debug"})
	panel:ControlHelp("#vjbase.menu.npc.settings.dev.debug.toggle.label")
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.dev.debug.engine", Command = "vj_npc_debug_engine"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.dev.debug.attack", Command = "vj_npc_debug_attack"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.dev.debug.enemy", Command = "vj_npc_debug_enemy"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.dev.debug.lastseenene", Command = "vj_npc_debug_lastseenenemytime"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.dev.debug.resetene", Command = "vj_npc_debug_resetenemy"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.dev.debug.cover", Command = "vj_npc_debug_takingcover"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.dev.debug.damage", Command = "vj_npc_debug_damage"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.dev.debug.touch", Command = "vj_npc_debug_touch"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.dev.debug.weapon", Command = "vj_npc_debug_weapon"})
	panel:AddControl("Button", {Label = "#vjbase.menu.npc.settings.dev.cachedmodels", Command = "listmodels"})
	panel:AddControl("Button", {Label = "#vjbase.menu.npc.settings.dev.print.numnpcs", Command = "vj_dev_numnpcs"})
	panel:AddControl("Label", {Text = "#vjbase.menu.npc.settings.dev.header.reloadbuttons"})
	panel:AddControl("Button", {Label = "#vjbase.menu.npc.settings.dev.reload.sounds", Command = "snd_restart"})
	panel:AddControl("Button", {Label = "#vjbase.menu.npc.settings.dev.reload.materials", Command = "mat_reloadallmaterials"})
	panel:AddControl("Button", {Label = "#vjbase.menu.npc.settings.dev.reload.textures", Command = "mat_reloadtextures"})
	panel:AddControl("Button", {Label = "#vjbase.menu.npc.settings.dev.reload.models", Command = "r_flushlod"})
	panel:AddControl("Button", {Label = "#vjbase.menu.npc.settings.dev.reload.menus", Command = "spawnmenu_reload"})
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function VJ_NPC_SETTINGS_CONTROLLER(panel)
	panel:AddControl("Label", {Text = "#vjbase.menu.npc.settings.con.header.main"})
	panel:AddControl("Button", {Text = "#vjbase.menu.general.reset.everything", Command = "vj_npc_cont_hud 1\n vj_npc_cont_cam_zoom_dist 5\n vj_npc_cont_debug 0\n vj_npc_cont_cam_speed 6\n vj_npc_cont_cam_zoom_speed 10\n vj_npc_cont_diewithnpc 0"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.con.displayhud", Command = "vj_npc_cont_hud"})
	panel:AddControl("Slider", {Label = "#vjbase.menu.npc.settings.con.camzoomdistance", min = 5, max = 300, Command = "vj_npc_cont_cam_zoom_dist"})
	panel:AddControl("Slider", {Label = "#vjbase.menu.npc.settings.con.camzoomspeed", min = 1, max = 200, Command = "vj_npc_cont_cam_zoom_speed"})
	panel:AddControl("Slider", {Label = "#vjbase.menu.npc.settings.con.camspeed", min = 1, max = 180, Command = "vj_npc_cont_cam_speed"})
	panel:ControlHelp("#vjbase.menu.npc.settings.con.camspeed.label")
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.con.diewithnpc", Command = "vj_npc_cont_diewithnpc"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.con.displaydev", Command = "vj_npc_cont_debug"})
	
	panel:AddControl("Label", {Text = "#vjbase.menu.npc.settings.con.header.keybindings"})
	
	local ControlList = vgui.Create("DListView")
		ControlList:SetTooltip(false)
		ControlList:SetSize(100, 320)
		ControlList:SetMultiSelect(false)
		ControlList:AddColumn("#vjbase.menu.npc.settings.con.bind.header1")
		ControlList:AddColumn("#vjbase.menu.npc.settings.con.bind.header2")
			ControlList:AddLine("W A S D", "#vjbase.menu.npc.settings.con.bind.movement")
			ControlList:AddLine("END", "#vjbase.menu.npc.settings.con.bind.exitcontrol")
			ControlList:AddLine("FIRE1", "#vjbase.menu.npc.settings.con.bind.meleeattack")
			ControlList:AddLine("FIRE2", "#vjbase.menu.npc.settings.con.bind.rangeattack")
			ControlList:AddLine("JUMP", "#vjbase.menu.npc.settings.con.bind.leaporgrenade")
			ControlList:AddLine("RELOAD", "#vjbase.menu.npc.settings.con.bind.reloadweapon")
			ControlList:AddLine("T", "#vjbase.menu.npc.settings.con.bind.togglebullseye")
			ControlList:AddLine("H", "#vjbase.menu.npc.settings.con.bind.cameramode")
			ControlList:AddLine("J", "#vjbase.menu.npc.settings.con.bind.movementjump")
			ControlList:AddLine("MOUSE WHEEL", "#vjbase.menu.npc.settings.con.bind.camerazoom")
			ControlList:AddLine("UP ARROW", "#vjbase.menu.npc.settings.con.bind.cameraforward")
			ControlList:AddLine("UP ARROW + RUN", "#vjbase.menu.npc.settings.con.bind.cameraup")
			ControlList:AddLine("DOWN ARROW", "#vjbase.menu.npc.settings.con.bind.camerabackward")
			ControlList:AddLine("DOWN ARROW + RUN", "#vjbase.menu.npc.settings.con.bind.cameradown")
			ControlList:AddLine("LEFT ARROW", "#vjbase.menu.npc.settings.con.bind.cameraleft")
			ControlList:AddLine("RIGHT ARROW", "#vjbase.menu.npc.settings.con.bind.cameraright")
			ControlList:AddLine("BACKSPACE", "#vjbase.menu.npc.settings.con.bind.resetzoom")
		ControlList.OnRowSelected = function(panel2, rowIndex, row)
			chat.AddText(Color(0, 255, 0), language.GetPhrase("#vjbase.menu.npc.settings.con.bind.clickmsg1").." ", Color(255, 255, 0), row:GetValue(1), Color(0, 255, 0), " | "..language.GetPhrase("#vjbase.menu.npc.settings.con.bind.clickmsg2").." ", Color(255, 255, 0), row:GetValue(2))
		end
	panel:AddItem(ControlList)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function VJ_NPC_SETTINGS_PERFORMANCE(panel)
	if !game.SinglePlayer() && !LocalPlayer():IsAdmin() then
		panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.not"})
		panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.only"})
		return
	end
	
	panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.only"})
	panel:AddControl("Label", {Text = "#vjbase.menu.general.npc.note.future"})
	panel:AddControl("Label", {Text = "#vjbase.menu.npc.settings.perf.header.main"})
	panel:AddControl("Button", {Text = "#vjbase.menu.general.reset.everything", Command = "vj_npc_shadows 1\n vj_npc_poseparams 1\n vj_npc_ikchains 1\nvj_npc_processtime 1\n vj_npc_forcelowlod 0\n vj_npc_reduce_vfx 0"})
	
	panel:AddControl("Slider", {Label = "#vjbase.menu.npc.settings.perf.processtime", Type = "Float", min = 0.05, max = 3, Command = "vj_npc_processtime"})
	local vid = vgui.Create("DButton") -- Process Time Video
		vid:SetFont("TargetID")
		vid:SetText("#vjbase.menu.npc.settings.perf.processtime.button")
		vid:SetSize(150, 25)
		vid.DoClick = function()
			gui.OpenURL("https://www.youtube.com/watch?v=7wKsCmGpieU")
		end
	panel:AddPanel(vid)
	panel:ControlHelp("#vjbase.menu.npc.settings.perf.processtime.label")
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.perf.poseparams", Command = "vj_npc_poseparams"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.perf.shadows", Command = "vj_npc_shadows"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.perf.ikchains", Command = "vj_npc_ikchains"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.perf.forcelowlod", Command = "vj_npc_forcelowlod"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.npc.settings.perf.reducevfx", Command = "vj_npc_reduce_vfx"})
	panel:ControlHelp("#vjbase.menu.npc.settings.perf.reducevfx.label")
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function VJ_WEAPON_SETTINGS_CLIENT(panel)
	panel:AddControl("Label", {Text = "#vjbase.menu.wep.clsettings.notice"})
	panel:AddControl("Button", {Text = "#vjbase.menu.general.reset.everything", Command = "vj_wep_muzzleflash 1\n vj_wep_shells 1\n vj_wep_muzzleflash_light 1"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.wep.clsettings.togglemuzzle", Command = "vj_wep_muzzleflash"})
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.wep.clsettings.togglemuzzlelight", Command = "vj_wep_muzzleflash_light"})
	panel:ControlHelp("#vjbase.menu.wep.clsettings.togglemuzzle.label")
	panel:AddControl("Checkbox", {Label = "#vjbase.menu.wep.clsettings.toggleshells", Command = "vj_wep_shells"})
end

---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PopulateToolMenu", "VJ_ADDTOMENU_CONFIGURES", function()
	spawnmenu.AddToolMenuOption("DrVrej", "NPCs", "vj_menu_npc_settings_ai", "#vjbase.menu.npc.settings.ai", "", "", VJ_NPC_SETTINGS_AI, {})
	spawnmenu.AddToolMenuOption("DrVrej", "NPCs", "vj_menu_npc_settings_atk", "#vjbase.menu.npc.settings.atk", "", "", VJ_NPC_SETTINGS_ATTACKS, {})
	spawnmenu.AddToolMenuOption("DrVrej", "NPCs", "vj_menu_npc_settings_gen", "#vjbase.menu.npc.settings.gen", "", "", VJ_NPC_SETTINGS_GENERAL, {})
	spawnmenu.AddToolMenuOption("DrVrej", "NPCs", "vj_menu_npc_settings_snd", "#vjbase.menu.npc.settings.snd", "", "", VJ_NPC_SETTINGS_SOUND, {})
	spawnmenu.AddToolMenuOption("DrVrej", "NPCs", "vj_menu_npc_settings_dev", "#vjbase.menu.npc.settings.dev", "", "", VJ_NPC_SETTINGS_DEV, {})
	spawnmenu.AddToolMenuOption("DrVrej", "NPCs", "vj_menu_npc_settings_con", "#vjbase.menu.npc.settings.con", "", "", VJ_NPC_SETTINGS_CONTROLLER, {})
	spawnmenu.AddToolMenuOption("DrVrej", "NPCs", "vj_menu_npc_settings_perf", "#vjbase.menu.npc.settings.perf", "", "", VJ_NPC_SETTINGS_PERFORMANCE, {})
	spawnmenu.AddToolMenuOption("DrVrej", "Weapons", "vj_menu_wep_settings_cl", "#vjbase.menu.wep.clsettings", "", "", VJ_WEAPON_SETTINGS_CLIENT, {})
end)