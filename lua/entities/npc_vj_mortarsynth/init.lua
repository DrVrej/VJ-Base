AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/mortarsynth.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
// models/skyrim/chaurusflyer.mdl // models/gunship.mdl // models/combine_helicopter.mdl
ENT.StartHealth = 150
ENT.HullType = HULL_TINY
ENT.MovementType = VJ_MOVETYPE_AERIAL -- How does the SNPC move?
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_COMBINE"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Oil" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_RANGE_ATTACK1} -- Melee Attack Animations
ENT.MeleeAttackDistance = 60 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 80 -- How far does the damage go?
ENT.TimeUntilMeleeAttackDamage = 0.7 -- This counted in seconds | This calculates the time until it hits something
ENT.NextAnyAttackTime_Melee = 1.3 -- How much time until it can use any attack again? | Counted in Seconds
ENT.MeleeAttackDamage = 30
ENT.HasDeathRagdoll = false -- If set to false, it will not spawn the regular ragdoll of the SNPC
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Breath = {"npc/scanner/scanner_combat_loop1.wav"}
ENT.SoundTbl_Idle = {"npc/scanner/scanner_talk1.wav","npc/scanner/scanner_talk2.wav"}
ENT.SoundTbl_Alert = {"npc/scanner/combat_scan5.wav"}
ENT.SoundTbl_MeleeAttack = {"npc/scanner/scanner_electric1.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"npc/zombie/claw_miss1.wav","npc/zombie/claw_miss2.wav"}
ENT.SoundTbl_Pain = {"npc/scanner/scanner_pain1.wav","npc/scanner/scanner_pain2.wav"}
ENT.SoundTbl_Death = {"npc/waste_scanner/grenade_fire.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	// self:SetCollisionBounds(Vector(20, 20, 250), Vector(-20, -20, 0))
	self:SetCollisionBounds(Vector(33, 33, 26), Vector(-33, -33, -30))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPriorToKilled(dmginfo,hitgroup)
	ParticleEffect("explosion_turret_break",self:GetPos(),Angle(0,0,0),nil)
	util.BlastDamage(self,self,self:GetPos(),80,20)
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/