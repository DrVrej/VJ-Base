/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
---------------------------------------------------------------------------------------------------------------------------------------------
local function VJ_NPC_SETTINGS_AI(panel)
	if !game.SinglePlayer() && !LocalPlayer():IsAdmin() then
		panel:Help("#vjbase.menu.general.admin.not")
		panel:Help("#vjbase.menu.general.admin.only")
		return
	end

	panel:Help("#vjbase.menu.general.admin.only")
	panel:Help("#vjbase.menu.general.npc.note.future")
	panel:AddControl("Button", {Text = "#vjbase.menu.general.reset.everything", Command = "vj_npc_sight_distance 0\n vj_npc_sight_xray 0\n vj_npc_wander 1\n vj_npc_chase 1\n vj_npc_flinch 1\n vj_npc_investigate 1\n vj_npc_callhelp 1\n vj_npc_ply_follow 1\n vj_npc_medic 1\n vj_npc_eat 1\n vj_npc_dangerdetection 1\n vj_npc_human_jump 1\n vj_npc_creature_opendoor 1\n vj_npc_allies 1\n vj_npc_ply_betray 1\n vj_npc_fri_base 0\n vj_npc_fri_player 0\n vj_npc_fri_zombie 0\n vj_npc_fri_antlion 0\n vj_npc_fri_combine 0"})
	
	panel:TextEntry("#vjbase.menu.npc.settings.ai.sightdistance", "vj_npc_sight_distance")
	panel:ControlHelp("#vjbase.menu.npc.settings.ai.sightdistance.label")
	panel:CheckBox("#vjbase.menu.npc.settings.ai.sightxray", "vj_npc_sight_xray")
	panel:ControlHelp("#vjbase.menu.npc.settings.ai.sightxray.label")
	panel:CheckBox("#vjbase.menu.npc.settings.ai.wander", "vj_npc_wander")
	panel:CheckBox("#vjbase.menu.npc.settings.ai.chase", "vj_npc_chase")
	panel:CheckBox("#vjbase.menu.npc.settings.ai.detectdanger", "vj_npc_dangerdetection")
	panel:CheckBox("#vjbase.menu.npc.settings.ai.flinch", "vj_npc_flinch")
	panel:CheckBox("#vjbase.menu.npc.settings.ai.eat", "vj_npc_eat")
	panel:CheckBox("#vjbase.menu.npc.settings.ai.investigate", "vj_npc_investigate")
	panel:ControlHelp("#vjbase.menu.npc.settings.ai.investigate.label")
	panel:CheckBox("#vjbase.menu.npc.settings.ai.alliances", "vj_npc_allies")
	panel:CheckBox("#vjbase.menu.npc.settings.ai.medics", "vj_npc_medic")
	panel:CheckBox("#vjbase.menu.npc.settings.ai.callhelp", "vj_npc_callhelp")
	panel:CheckBox("#vjbase.menu.npc.settings.ai.plybetray", "vj_npc_ply_betray")
	panel:CheckBox("#vjbase.menu.npc.settings.ai.plyfollow", "vj_npc_ply_follow")
	panel:ControlHelp("#vjbase.menu.npc.settings.ai.plyfollow.label")
	panel:CheckBox("#vjbase.menu.npc.settings.ai.creatureopendoor", "vj_npc_creature_opendoor")
	panel:CheckBox("#vjbase.menu.npc.settings.ai.humanjump", "vj_npc_human_jump")
	panel:Help("#vjbase.menu.npc.settings.ai.relation.label")
	panel:CheckBox("#vjbase.menu.npc.settings.ai.relation.antlion", "vj_npc_fri_antlion")
	panel:CheckBox("#vjbase.menu.npc.settings.ai.relation.combine", "vj_npc_fri_combine")
	panel:CheckBox("#vjbase.menu.npc.settings.ai.relation.player", "vj_npc_fri_player")
	panel:CheckBox("#vjbase.menu.npc.settings.ai.relation.zombie", "vj_npc_fri_zombie")
	panel:CheckBox("#vjbase.menu.npc.settings.ai.relation.base", "vj_npc_fri_base")
	panel:ControlHelp("#vjbase.menu.npc.settings.ai.relation.base.label")
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function VJ_NPC_SETTINGS_ATTACKS(panel)
	if !game.SinglePlayer() && !LocalPlayer():IsAdmin() then
		panel:Help("#vjbase.menu.general.admin.not")
		panel:Help("#vjbase.menu.general.admin.only")
		return
	end

	panel:Help("#vjbase.menu.general.admin.only")
	panel:Help("#vjbase.menu.general.npc.note.future")
	panel:AddControl("Button", {Text = "#vjbase.menu.general.reset.everything", Command = "vj_npc_wep_ply_pickup 1\n vj_npc_wep_drop 1\n vj_npc_wep_reload 1\n vj_npc_wep 1\n vj_npc_grenade 1\n vj_npc_melee_ply_dsp 1\n vj_npc_melee_propint 1\n vj_npc_melee_bleed 1\n vj_npc_melee_ply_speed 1\n vj_npc_melee 1\n vj_npc_range 1\n vj_npc_leap 1"})
	
	panel:CheckBox("#vjbase.menu.npc.settings.atk.range", "vj_npc_range")
	panel:CheckBox("#vjbase.menu.npc.settings.atk.grenade", "vj_npc_grenade")
	panel:CheckBox("#vjbase.menu.npc.settings.atk.leap", "vj_npc_leap")
	panel:Help("#vjbase.menu.npc.settings.atk.melee.label")
	panel:CheckBox("#vjbase.menu.npc.settings.atk.melee", "vj_npc_melee")
	panel:CheckBox("#vjbase.menu.npc.settings.atk.melee.bleed", "vj_npc_melee_bleed")
	panel:CheckBox("#vjbase.menu.npc.settings.atk.melee.ply.dsp", "vj_npc_melee_ply_dsp")
	panel:CheckBox("#vjbase.menu.npc.settings.atk.melee.ply.speed", "vj_npc_melee_ply_speed")
	local propint = {Options = {}, CVars = {}, Label = "#vjbase.menu.npc.settings.atk.melee.propint.header", MenuButton = "0"}
		propint.Options["#vjbase.menu.npc.settings.atk.melee.propint.disable"] = {vj_npc_melee_propint = "0"}
		propint.Options["#vjbase.menu.npc.settings.atk.melee.propint.all"] = {vj_npc_melee_propint = "1"}
		propint.Options["#vjbase.menu.npc.settings.atk.melee.propint.onlydamage"] = {vj_npc_melee_propint = "2"}
		propint.Options["#vjbase.menu.npc.settings.atk.melee.propint.onlypush"] = {vj_npc_melee_propint = "3"}
	panel:AddControl("ComboBox", propint)
	panel:Help("#vjbase.menu.npc.settings.atk.wep.label")
	panel:CheckBox("#vjbase.menu.npc.settings.atk.wep", "vj_npc_wep")
	panel:CheckBox("#vjbase.menu.npc.settings.atk.wep.reload", "vj_npc_wep_reload")
	panel:CheckBox("#vjbase.menu.npc.settings.atk.wep.drop", "vj_npc_wep_drop")
	panel:CheckBox("#vjbase.menu.npc.settings.atk.wep.ply.pickup", "vj_npc_wep_ply_pickup")
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function VJ_NPC_SETTINGS_GENERAL(panel)
	if !game.SinglePlayer() && !LocalPlayer():IsAdmin() then
		panel:Help("#vjbase.menu.general.admin.not")
		panel:Help("#vjbase.menu.general.admin.only")
		return
	end

	panel:Help("#vjbase.menu.general.admin.only")
	panel:Help("#vjbase.menu.general.npc.note.future")
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
	panel:CheckBox("#vjbase.menu.npc.settings.gen.deathanim", "vj_npc_anim_death")
	panel:CheckBox("#vjbase.menu.npc.settings.gen.lootdrops", "vj_npc_loot")
	
	panel:Help("#vjbase.menu.npc.settings.gen.health.label")
	panel:CheckBox("#vjbase.menu.npc.settings.gen.health.god", "vj_npc_god")
	panel:TextEntry("#vjbase.menu.npc.settings.gen.health.override", "vj_npc_health")
	panel:ControlHelp("#vjbase.menu.npc.settings.gen.health.override.label")
	panel:CheckBox("#vjbase.menu.npc.settings.gen.health.blood.vfx", "vj_npc_blood")
	panel:ControlHelp("#vjbase.menu.npc.settings.gen.health.blood.vfx.label")
	panel:CheckBox("#vjbase.menu.npc.settings.gen.health.blood.pool", "vj_npc_blood_pool")
	panel:CheckBox("#vjbase.menu.npc.settings.gen.health.blood.gmoddecals", "vj_npc_blood_gmod")
	panel:ControlHelp("#vjbase.menu.npc.settings.gen.health.blood.gmoddecals.label")
	
	panel:Help("#vjbase.menu.npc.settings.gen.corpse.label")
	panel:CheckBox("#vjbase.menu.npc.settings.gen.corpse", "vj_npc_corpse")
	panel:NumSlider("#vjbase.menu.npc.settings.gen.corpse.limit", "vj_npc_corpse_limit", 4, 300, 0)
	panel:ControlHelp("#vjbase.menu.npc.settings.gen.corpse.limit.label")
	panel:CheckBox("#vjbase.menu.npc.settings.gen.corpse.fade", "vj_npc_corpse_fade")
	panel:NumSlider("#vjbase.menu.npc.settings.gen.corpse.fadetime", "vj_npc_corpse_fadetime", 0, 600, 0)
	panel:ControlHelp("#vjbase.menu.npc.settings.gen.corpse.fadetime.label")
	panel:CheckBox("#vjbase.menu.npc.settings.gen.corpse.undo", "vj_npc_corpse_undo")
	local vj_collision = {Options = {}, CVars = {}, Label = "#vjbase.menu.npc.settings.gen.collision.header", MenuButton = "0"}
		vj_collision.Options["#vjbase.menu.npc.settings.gen.collision.default"] = {vj_npc_corpse_collision = "0"}
		vj_collision.Options["#vjbase.menu.npc.settings.gen.collision.everything"] = {vj_npc_corpse_collision = "1"}
		vj_collision.Options["#vjbase.menu.npc.settings.gen.collision.onlyworld"] = {vj_npc_corpse_collision = "2"}
		vj_collision.Options["#vjbase.menu.npc.settings.gen.collision.excludedebris"] = {vj_npc_corpse_collision = "3"}
		vj_collision.Options["#vjbase.menu.npc.settings.gen.collision.excludeplynpcs"] = {vj_npc_corpse_collision = "4"}
		vj_collision.Options["#vjbase.menu.npc.settings.gen.collision.excludeply"] = {vj_npc_corpse_collision = "5"}
	panel:AddControl("ComboBox", vj_collision)
	
	panel:Help("#vjbase.menu.npc.settings.gen.gib.label")
	panel:CheckBox("#vjbase.menu.npc.settings.gen.gib", "vj_npc_gib")
	panel:CheckBox("#vjbase.menu.npc.settings.gen.gib.vfx", "vj_npc_gib_vfx")
	panel:ControlHelp("#vjbase.menu.npc.settings.gen.gib.vfx.label")
	panel:CheckBox("#vjbase.menu.npc.settings.gen.gib.collision", "vj_npc_gib_collision")
	panel:CheckBox("#vjbase.menu.npc.settings.gen.gib.fade", "vj_npc_gib_fade")
	panel:NumSlider("#vjbase.menu.npc.settings.gen.gib.fadetime", "vj_npc_gib_fadetime", 0, 600, 0)
	panel:ControlHelp("#vjbase.menu.npc.settings.gen.gib.fadetime.label")
	
	panel:Help("#vjbase.menu.npc.settings.gen.ply.label")
	panel:CheckBox("#vjbase.menu.npc.settings.gen.ply.addfrags", "vj_npc_ply_frag")
	panel:CheckBox("#vjbase.menu.npc.settings.gen.ply.chat", "vj_npc_ply_chat")
	panel:ControlHelp("#vjbase.menu.npc.settings.gen.ply.chat.label")
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function VJ_NPC_SETTINGS_SOUND(panel)
	if !game.SinglePlayer() && !LocalPlayer():IsAdmin() then
		panel:Help("#vjbase.menu.general.admin.not")
		panel:Help("#vjbase.menu.general.admin.only")
		return
	end
	
	panel:Help("#vjbase.menu.general.admin.only")
	panel:Help("#vjbase.menu.general.npc.note.future")
	panel:AddControl("Button", {Text = "#vjbase.menu.general.reset.everything", Command = "vj_npc_snd 1\n vj_npc_snd_idle 1\n vj_npc_snd_alert 1\n vj_npc_snd_pain 1\n vj_npc_snd_death 1\n vj_npc_snd_footstep 1\n vj_npc_snd_track 1\n vj_npc_snd_melee 1\n vj_npc_snd_range 1\n vj_npc_snd_leap 1\n vj_npc_snd_danger 1\n vj_npc_snd_plysight 1\n vj_npc_snd_plydamage 1\n vj_npc_snd_plyspeed 1\n vj_npc_snd_gib 1\n vj_npc_snd_breath 1\n vj_npc_snd_plyfollow 1\n vj_npc_snd_plybetrayal 1\n vj_npc_snd_medic 1\n vj_npc_snd_wep_reload 1\n vj_npc_snd_grenade 1\n vj_npc_snd_wep_suppressing 1\n vj_npc_snd_callhelp 1\n vj_npc_snd_receiveorder 1"})
	panel:CheckBox("#vjbase.menu.npc.settings.snd.togglesounds", "vj_npc_snd")
	panel:CheckBox("#vjbase.menu.npc.settings.snd.togglesoundtrack", "vj_npc_snd_track")
	panel:CheckBox("#vjbase.menu.npc.settings.snd.toggleidle", "vj_npc_snd_idle")
	panel:CheckBox("#vjbase.menu.npc.settings.snd.togglebreathing", "vj_npc_snd_breath")
	panel:CheckBox("#vjbase.menu.npc.settings.snd.togglefootsteps", "vj_npc_snd_footstep")
	panel:CheckBox("#vjbase.menu.npc.settings.snd.togglemelee", "vj_npc_snd_melee")
	panel:CheckBox("#vjbase.menu.npc.settings.snd.togglerange", "vj_npc_snd_range")
	panel:CheckBox("#vjbase.menu.npc.settings.snd.togglealert", "vj_npc_snd_alert")
	panel:CheckBox("#vjbase.menu.npc.settings.snd.togglepain", "vj_npc_snd_pain")
	panel:CheckBox("#vjbase.menu.npc.settings.snd.toggledeath", "vj_npc_snd_death")
	panel:CheckBox("#vjbase.menu.npc.settings.snd.togglegibbing", "vj_npc_snd_gib")
	panel:ControlHelp("#vjbase.menu.npc.settings.snd.togglegibbing.label")
	panel:CheckBox("#vjbase.menu.npc.settings.snd.togglemedic", "vj_npc_snd_medic")
	panel:CheckBox("#vjbase.menu.npc.settings.snd.togglefollowing", "vj_npc_snd_plyfollow")
	panel:CheckBox("#vjbase.menu.npc.settings.snd.togglecallhelp", "vj_npc_snd_callhelp")
	panel:CheckBox("#vjbase.menu.npc.settings.snd.togglereceiveorder", "vj_npc_snd_receiveorder")
	panel:CheckBox("#vjbase.menu.npc.settings.snd.togglebecomeenemy", "vj_npc_snd_plybetrayal")
	panel:CheckBox("#vjbase.menu.npc.settings.snd.toggleplayersight", "vj_npc_snd_plysight")
	panel:ControlHelp("#vjbase.menu.npc.settings.snd.toggleplayersight.label")
	panel:CheckBox("#vjbase.menu.npc.settings.snd.toggledmgbyplayer", "vj_npc_snd_plydamage")
	panel:ControlHelp("#vjbase.menu.npc.settings.snd.toggledmgbyplayer.label")
	
	panel:Help("#vjbase.menu.general.npc.creature")
	panel:CheckBox("#vjbase.menu.npc.settings.snd.toggleleap", "vj_npc_snd_leap")
	panel:CheckBox("#vjbase.menu.npc.settings.snd.toggleslowedplayer", "vj_npc_snd_plyspeed")
	panel:ControlHelp("#vjbase.menu.npc.settings.snd.toggleslowedplayer.label")
	
	panel:Help("#vjbase.menu.general.npc.human")
	panel:CheckBox("#vjbase.menu.npc.settings.snd.togglegrenade", "vj_npc_snd_grenade")
	panel:CheckBox("#vjbase.menu.npc.settings.snd.toggledangersight", "vj_npc_snd_danger")
	panel:CheckBox("#vjbase.menu.npc.settings.snd.togglesuppressing", "vj_npc_snd_wep_suppressing")
	panel:CheckBox("#vjbase.menu.npc.settings.snd.togglereload", "vj_npc_snd_wep_reload")
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function VJ_NPC_SETTINGS_DEV(panel)
	if !game.SinglePlayer() && !LocalPlayer():IsAdmin() then
		panel:Help("#vjbase.menu.general.admin.not")
		panel:Help("#vjbase.menu.general.admin.only")
		return
	end
	
	panel:Help("#vjbase.menu.general.admin.only")
	panel:Help("#vjbase.menu.npc.settings.dev.header.main")
	panel:Help("#vjbase.menu.npc.settings.dev.header.warning")
	panel:AddControl("Button", {Text = "#vjbase.menu.general.reset.everything", Command = "vj_npc_debug_weapon 0\n vj_npc_debug_damage 0\n vj_npc_debug_touch 0\n vj_npc_debug_attack 0\n vj_npc_debug_takingcover 0\n vj_npc_debug_resetenemy 0\n vj_npc_debug_lastseenenemytime 0\n vj_npc_debug 0\n vj_npc_debug_enemy 0\n vj_npc_debug_engine 0"})
	panel:CheckBox("#vjbase.menu.npc.settings.dev.debug.toggle", "vj_npc_debug")
	panel:ControlHelp("#vjbase.menu.npc.settings.dev.debug.toggle.label")
	panel:CheckBox("#vjbase.menu.npc.settings.dev.debug.engine", "vj_npc_debug_engine")
	panel:CheckBox("#vjbase.menu.npc.settings.dev.debug.attack", "vj_npc_debug_attack")
	panel:CheckBox("#vjbase.menu.npc.settings.dev.debug.enemy", "vj_npc_debug_enemy")
	panel:CheckBox("#vjbase.menu.npc.settings.dev.debug.lastseenene", "vj_npc_debug_lastseenenemytime")
	panel:CheckBox("#vjbase.menu.npc.settings.dev.debug.resetene", "vj_npc_debug_resetenemy")
	panel:CheckBox("#vjbase.menu.npc.settings.dev.debug.cover", "vj_npc_debug_takingcover")
	panel:CheckBox("#vjbase.menu.npc.settings.dev.debug.damage", "vj_npc_debug_damage")
	panel:CheckBox("#vjbase.menu.npc.settings.dev.debug.touch", "vj_npc_debug_touch")
	panel:CheckBox("#vjbase.menu.npc.settings.dev.debug.weapon", "vj_npc_debug_weapon")
	panel:Button("#vjbase.menu.npc.settings.dev.cachedmodels", "listmodels")
	panel:Button("#vjbase.menu.npc.settings.dev.print.numnpcs", "vj_dev_numnpcs")
	panel:Help("#vjbase.menu.npc.settings.dev.header.reloadbuttons")
	panel:Button("#vjbase.menu.npc.settings.dev.reload.sounds", "snd_restart")
	panel:Button("#vjbase.menu.npc.settings.dev.reload.materials", "mat_reloadallmaterials")
	panel:Button("#vjbase.menu.npc.settings.dev.reload.textures", "mat_reloadtextures")
	panel:Button("#vjbase.menu.npc.settings.dev.reload.models", "r_flushlod")
	panel:Button("#vjbase.menu.npc.settings.dev.reload.menus", "spawnmenu_reload")
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function VJ_NPC_SETTINGS_CONTROLLER(panel)
	panel:Help("#vjbase.menu.npc.settings.con.header")
	panel:AddControl("Button", {Text = "#vjbase.menu.general.reset.everything", Command = "vj_npc_cont_hud 1\n vj_npc_cont_cam_zoom_dist 5\n vj_npc_cont_debug 0\n vj_npc_cont_cam_speed 6\n vj_npc_cont_cam_zoom_speed 10\n vj_npc_cont_diewithnpc 0"})
	panel:CheckBox("#vjbase.menu.npc.settings.con.displayhud", "vj_npc_cont_hud")
	panel:NumSlider("#vjbase.menu.npc.settings.con.camzoomdistance", "vj_npc_cont_cam_zoom_dist", 5, 300, 0)
	panel:NumSlider("#vjbase.menu.npc.settings.con.camzoomspeed", "vj_npc_cont_cam_zoom_speed", 1, 200, 0)
	panel:NumSlider("#vjbase.menu.npc.settings.con.camspeed", "vj_npc_cont_cam_speed", 1, 180, 0)
	panel:ControlHelp("#vjbase.menu.npc.settings.con.camspeed.label")
	panel:CheckBox("#vjbase.menu.npc.settings.con.diewithnpc", "vj_npc_cont_diewithnpc")
	panel:CheckBox("#vjbase.menu.npc.settings.con.displaydev", "vj_npc_cont_debug")
	
	panel:Help("#vjbase.menu.npc.settings.con.bind.header")
	
	local ControlList = vgui.Create("DListView")
		ControlList:SetTooltip(false)
		ControlList:SetSize(100, 320)
		ControlList:SetMultiSelect(false)
		ControlList:AddColumn("#vjbase.menu.npc.settings.con.bind.header.key")
		ControlList:AddColumn("#vjbase.menu.npc.settings.con.bind.header.desc")
			ControlList:AddLine("W A S D", "#vjbase.menu.npc.settings.con.bind.movement")
			ControlList:AddLine("END", "#vjbase.menu.npc.settings.con.bind.exit")
			ControlList:AddLine("FIRE1", "#vjbase.menu.npc.settings.con.bind.melee")
			ControlList:AddLine("FIRE2", "#vjbase.menu.npc.settings.con.bind.range")
			ControlList:AddLine("JUMP", "#vjbase.menu.npc.settings.con.bind.leaporgrenade")
			ControlList:AddLine("RELOAD", "#vjbase.menu.npc.settings.con.bind.reloadweapon")
			ControlList:AddLine("T", "#vjbase.menu.npc.settings.con.bind.bullseye")
			ControlList:AddLine("H", "#vjbase.menu.npc.settings.con.bind.cameramode")
			ControlList:AddLine("J", "#vjbase.menu.npc.settings.con.bind.movejump")
			ControlList:AddLine("MOUSE WHEEL", "#vjbase.menu.npc.settings.con.bind.camerazoom")
			ControlList:AddLine("UP ARROW", "#vjbase.menu.npc.settings.con.bind.cameraforward")
			ControlList:AddLine("UP ARROW + RUN", "#vjbase.menu.npc.settings.con.bind.cameraup")
			ControlList:AddLine("DOWN ARROW", "#vjbase.menu.npc.settings.con.bind.camerabackward")
			ControlList:AddLine("DOWN ARROW + RUN", "#vjbase.menu.npc.settings.con.bind.cameradown")
			ControlList:AddLine("LEFT ARROW", "#vjbase.menu.npc.settings.con.bind.cameraleft")
			ControlList:AddLine("RIGHT ARROW", "#vjbase.menu.npc.settings.con.bind.cameraright")
			ControlList:AddLine("BACKSPACE", "#vjbase.menu.npc.settings.con.bind.resetzoom")
		ControlList.OnRowSelected = function(panel2, rowIndex, row)
			chat.AddText(Color(0, 255, 0), language.GetPhrase("#vjbase.menu.npc.settings.con.bind.chat.key").." ", Color(255, 255, 0), row:GetValue(1), Color(0, 255, 0), " | "..language.GetPhrase("#vjbase.menu.npc.settings.con.bind.chat.desc").." ", Color(255, 255, 0), row:GetValue(2))
		end
	panel:AddItem(ControlList)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function VJ_NPC_SETTINGS_PERFORMANCE(panel)
	if !game.SinglePlayer() && !LocalPlayer():IsAdmin() then
		panel:Help("#vjbase.menu.general.admin.not")
		panel:Help("#vjbase.menu.general.admin.only")
		return
	end
	
	panel:Help("#vjbase.menu.general.admin.only")
	panel:Help("#vjbase.menu.general.npc.note.future")
	panel:Help("#vjbase.menu.npc.settings.perf.header.main")
	panel:AddControl("Button", {Text = "#vjbase.menu.general.reset.everything", Command = "vj_npc_shadows 1\n vj_npc_poseparams 1\n vj_npc_ikchains 1\nvj_npc_processtime 1\n vj_npc_forcelowlod 0\n vj_npc_reduce_vfx 0"})
	
	panel:NumSlider("#vjbase.menu.npc.settings.perf.processtime", "vj_npc_processtime", 0.05, 3, 2)
	local vid = vgui.Create("DButton") -- Process Time Video
		vid:SetFont("TargetID")
		vid:SetText("#vjbase.menu.npc.settings.perf.processtime.button")
		vid:SetSize(150, 25)
		vid.DoClick = function()
			gui.OpenURL("https://www.youtube.com/watch?v=7wKsCmGpieU")
		end
	panel:AddPanel(vid)
	panel:ControlHelp("#vjbase.menu.npc.settings.perf.processtime.label")
	panel:CheckBox("#vjbase.menu.npc.settings.perf.poseparams", "vj_npc_poseparams")
	panel:CheckBox("#vjbase.menu.npc.settings.perf.shadows", "vj_npc_shadows")
	panel:CheckBox("#vjbase.menu.npc.settings.perf.ikchains", "vj_npc_ikchains")
	panel:CheckBox("#vjbase.menu.npc.settings.perf.forcelowlod", "vj_npc_forcelowlod")
	panel:CheckBox("#vjbase.menu.npc.settings.perf.reducevfx", "vj_npc_reduce_vfx")
	panel:ControlHelp("#vjbase.menu.npc.settings.perf.reducevfx.label")
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function VJ_WEAPON_SETTINGS_CLIENT(panel)
	panel:Help("#vjbase.menu.wep.settings.client.notice")
	panel:AddControl("Button", {Text = "#vjbase.menu.general.reset.everything", Command = "vj_wep_muzzleflash 1\n vj_wep_shells 1\n vj_wep_muzzleflash_light 1"})
	panel:CheckBox("#vjbase.menu.wep.settings.client.toggle.muzzle", "vj_wep_muzzleflash")
	panel:CheckBox("#vjbase.menu.wep.settings.client.toggle.muzzlelight", "vj_wep_muzzleflash_light")
	panel:ControlHelp("#vjbase.menu.wep.settings.client.toggle.muzzlelight.label")
	panel:CheckBox("#vjbase.menu.wep.settings.client.toggle.shells", "vj_wep_shells")
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
	spawnmenu.AddToolMenuOption("DrVrej", "Weapons", "vj_menu_wep_settings_cl", "#vjbase.menu.wep.settings.client", "", "", VJ_WEAPON_SETTINGS_CLIENT, {})
end)