AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/player/kleiner.mdl"}
ENT.StartHealth = 100
ENT.BloodColor = VJ.BLOOD_COLOR_RED
ENT.UsePoseParameterMovement = true
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"}
ENT.AlliedWithPlayerAllies = true

ENT.HasMeleeAttack = true
ENT.AnimTbl_MeleeAttack = "vjseq_seq_meleeattack01"

ENT.WeaponInventory_AntiArmorList = {"weapon_vj_rpg"}
ENT.WeaponInventory_MeleeList = {"weapon_vj_crowbar"}

ENT.HasGrenadeAttack = true
ENT.GrenadeAttackThrowTime = 0.85
ENT.GrenadeAttackModel = "models/weapons/w_npcnade.mdl"
ENT.AnimTbl_GrenadeAttack = "vjges_gesture_item_throw"

ENT.AnimTbl_Medic_GiveHealth = "vjges_gesture_item_drop"
ENT.AnimTbl_CallForHelp = {"vjges_gesture_signal_group", "vjges_gesture_signal_forward"}
ENT.AnimTbl_DamageAllyResponse = "vjges_gesture_signal_halt"
ENT.Weapon_OcclusionDelay = false

ENT.FootstepSoundTimerRun = 0.3
ENT.FootstepSoundTimerWalk = 0.5

ENT.CanFlinch = true
ENT.FlinchCooldown = 1
ENT.AnimTbl_Flinch = {"vjges_flinch_01", "vjges_flinch_02"}
ENT.FlinchHitGroupMap = {
	{HitGroup = {HITGROUP_HEAD}, Animation = {"vjges_flinch_head_01", "vjges_flinch_head_02"}},
	{HitGroup = {HITGROUP_CHEST}, Animation = {"vjges_flinch_phys_01", "vjges_flinch_phys_02", "vjges_flinch_back_01"}},
	{HitGroup = {HITGROUP_STOMACH}, Animation = {"vjges_flinch_stomach_01", "vjges_flinch_stomach_02"}},
	{HitGroup = {HITGROUP_LEFTARM}, Animation = {"vjges_flinch_shoulder_l"}},
	{HitGroup = {HITGROUP_RIGHTARM}, Animation = {"vjges_flinch_shoulder_r"}}
}

ENT.HasDeathAnimation = true
ENT.AnimTbl_Death = {"vjseq_death_02", "vjseq_death_03", "vjseq_death_04"}
ENT.DeathAnimationChance = 2

ENT.SoundTbl_FootStep = {"npc/footsteps/hardboot_generic1.wav", "npc/footsteps/hardboot_generic2.wav", "npc/footsteps/hardboot_generic3.wav", "npc/footsteps/hardboot_generic4.wav", "npc/footsteps/hardboot_generic5.wav", "npc/footsteps/hardboot_generic6.wav", "npc/footsteps/hardboot_generic8.wav"}
ENT.SoundTbl_IdleDialogue = {"common/wpn_denyselect.wav", "common/wpn_select.wav"}
ENT.SoundTbl_IdleDialogueAnswer = {"common/wpn_denyselect.wav", "common/wpn_select.wav"}
ENT.SoundTbl_FollowPlayer = "common/wpn_select.wav"
ENT.SoundTbl_UnFollowPlayer = "common/wpn_denyselect.wav"
ENT.SoundTbl_Death = {"player/pl_pain5.wav", "player/pl_pain6.wav", "player/pl_pain7.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
	-- Set all the player models into the model variable
	-- WARNING: Do NOT use "ipairs", this is NOT a sequential table!
    for _, v in pairs(player_manager.AllValidModels()) do
		self.Model[#self.Model + 1] = v
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	VJ.EmitSound(self, "player/pl_drown1.wav") -- Player connect sound
	
	-- Random bodygroups and skins
	for i = 1, self:GetNumBodyGroups() -1 do
		self:SetBodygroup(i, math.random(0, self:GetBodygroupCount(i - 1)))
	end
	self:SetSkin(math.random(0, self:SkinCount() - 1))
	
	-- Random playermodel color
	self:SetPlayerColor(Color(math.Rand(0, 255), math.Rand(0, 255), math.Rand(0, 255)):ToVector())
end
---------------------------------------------------------------------------------------------------------------------------------------------
/*function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpseEnt)
	-- Has to be client side, not worth networking, therefore this has been abandoned
	corpseEnt.SetupDataTables = function()
		//corpseEnt:NetworkVar("Vector", 0, "PlayerColor")
		corpseEnt:DTVar("Vector", 0, "PlayerColor")
	end
	
	corpseEnt:InstallDataTable()
	corpseEnt:SetupDataTables()
	
	corpseEnt:DTVar("Vector", 0, "PlayerColor")
	//corpseEnt:SetDTVector(0, self:GetPlayerColor())
    //corpseEnt:SetPlayerColor(self:GetPlayerColor())
end*/
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnGrenadeAttack(status, grenade, customEnt, landDir, landingPos)
	if status == "Throw" then
		if !IsValid(customEnt) then
			-- Glow and trail are both based on the original: https://github.com/ValveSoftware/source-sdk-2013/blob/master/mp/src/game/server/hl2/grenade_frag.cpp#L158
			local redGlow = ents.Create("env_sprite")
			redGlow:SetKeyValue("model", "sprites/redglow1.vmt")
			redGlow:SetKeyValue("scale", "0.2")
			redGlow:SetKeyValue("rendermode", "3") -- kRenderGlow
			redGlow:SetKeyValue("renderfx", "14") -- kRenderFxNoDissipation
			redGlow:SetKeyValue("renderamt", "200")
			redGlow:SetKeyValue("rendercolor", "255 255 255")
			redGlow:SetKeyValue("GlowProxySize", "4.0")
			redGlow:SetParent(grenade)
			redGlow:Fire("SetParentAttachment", "fuse")
			redGlow:Spawn()
			redGlow:Activate()
			grenade:DeleteOnRemove(redGlow)
			local redTrail = util.SpriteTrail(grenade, 1, Color(255, 0, 0), true, 8, 1, 0.5, 0.0555, "sprites/bluelaser1.vmt")
			redTrail:SetKeyValue("rendermode", "5") -- kRenderTransAdd
			redTrail:SetKeyValue("renderfx", "0") -- kRenderFxNone
			grenade.SoundTbl_Idle = "Grenade.Blip"
			grenade.IdleSoundPitch = VJ.SET(100, 100)
		end
		return (landingPos - grenade:GetPos()) + (self:GetUp()*200 + self:GetForward()*500 + self:GetRight()*math.Rand(-20, 20))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "Initial" then
		local pos = self:GetPos()
		local pitch = math.random(95, 105)
		local function deathSound(time, snd)
			timer.Simple(time, function()
				sound.Play(snd, pos, 65, pitch)
			end)
		end
		deathSound(0, "hl1/fvox/beep.wav")
		deathSound(0.25, "hl1/fvox/beep.wav")
		deathSound(0.75, "hl1/fvox/beep.wav")
		deathSound(1.25, "hl1/fvox/beep.wav")
		deathSound(1.7, "hl1/fvox/flatline.wav")
	end
end