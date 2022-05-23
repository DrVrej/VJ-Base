AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/player/kleiner.mdl"}
ENT.StartHealth = 100
ENT.UsePlayerModelMovement = true

ENT.BloodColor = "Red"

ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"}
ENT.FriendsWithAllPlayerAllies = true

ENT.HasMeleeAttack = false
ENT.MeleeAttackAnimationAllowOtherTasks = true

ENT.WeaponInventory_AntiArmor = true
ENT.WeaponInventory_AntiArmorList = {"weapon_vj_rpg"}
ENT.WeaponInventory_Melee = true
ENT.WeaponInventory_MeleeList = {"weapon_vj_crowbar"}

ENT.HasGrenadeAttack = false

ENT.WaitForEnemyToComeOut = false
ENT.HasCallForHelpAnimation = false

ENT.NextMoveRandomlyWhenShootingTime1 = 0
ENT.NextMoveRandomlyWhenShootingTime2 = 0.2

ENT.FootStepTimeRun = 0.3
ENT.FootStepTimeWalk = 0.5

ENT.SoundTbl_FootStep = {"npc/footsteps/hardboot_generic1.wav","npc/footsteps/hardboot_generic2.wav","npc/footsteps/hardboot_generic3.wav","npc/footsteps/hardboot_generic4.wav","npc/footsteps/hardboot_generic5.wav","npc/footsteps/hardboot_generic6.wav","npc/footsteps/hardboot_generic8.wav"}
ENT.SoundTbl_IdleDialogue = {"common/wpn_denyselect.wav","common/wpn_select.wav"}
ENT.SoundTbl_IdleDialogueAnswer = {"common/wpn_denyselect.wav","common/wpn_select.wav"}
ENT.SoundTbl_FollowPlayer = {"common/wpn_select.wav"}
ENT.SoundTbl_UnFollowPlayer = {"common/wpn_denyselect.wav"}
ENT.SoundTbl_Death = {"player/pl_pain5.wav","player/pl_pain6.wav","player/pl_pain7.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	VJ_EmitSound(self, "player/pl_drown1.wav") -- Player connect sound
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled()
	local pos = self:GetPos()
	local pitch = math.random(95,105)
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