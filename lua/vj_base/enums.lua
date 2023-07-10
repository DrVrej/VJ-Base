/*-----------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
if !VJ then VJ = {} end -- If VJ isn't initialized, initialize it!

---------------------------------------------------------------------------------------------------------------------------------------------
-- NPC attack type
VJ.ATTACK_TYPE_NONE				= 0 -- No state is set (Default)
VJ.ATTACK_TYPE_CUSTOM			= 1 -- Custom attack (Used by developers to make custom attacks)
VJ.ATTACK_TYPE_MELEE			= 2 -- Melee attack
VJ.ATTACK_TYPE_RANGE			= 3 -- Ranged attack
VJ.ATTACK_TYPE_LEAP				= 4 -- Leap attack
VJ.ATTACK_TYPE_GRENADE			= 5 -- Grenade attack

-- NPC attack state
VJ.ATTACK_STATE_NONE			= 0 -- No state is set (Default)
VJ.ATTACK_STATE_DONE			= 1 -- The current attack has been executed completely and is marked as done
VJ.ATTACK_STATE_STARTED			= 2 -- The current attack has started and is expected to execute soon
VJ.ATTACK_STATE_EXECUTED		= 10 -- The current attack has been executed at least once
VJ.ATTACK_STATE_EXECUTED_HIT	= 11 -- The current attack has been executed at least once AND hit an entity at least once (Melee & Leap attacks)

-- NPC facing status
VJ.NPC_FACING_NONE				= 0 -- No status is set (Default)
VJ.NPC_FACING_ENEMY				= 1 -- Currently attempting to face the enemy
VJ.NPC_FACING_ENTITY			= 2 -- Currently attempting to face a specific entity
VJ.NPC_FACING_POSITION			= 3 -- Currently attempting to face a specific position

-- Danger detected type (Used by human NPCs)
VJ.NPC_DANGER_TYPE_ENTITY		= 1 -- Entity type of danger that could harm the NPC | Commonly produced by projectiles | Associated: "ent.VJTag_ID_Danger"
VJ.NPC_DANGER_TYPE_GRENADE		= 2 -- Grenade type of danger that could harm the NPC | Associated: "ent.VJTag_ID_Grenade"
VJ.NPC_DANGER_TYPE_HINT			= 3 -- Hint type of danger that could harm the NPC | Commonly used by sound hints | Associated: COND_HEAR_DANGER, COND_HEAR_PHYSICS_DANGER, COND_HEAR_MOVE_AWAY

-- NPC weapon state
VJ.NPC_WEP_STATE_READY			= 0 -- No state is set (Default)
VJ.NPC_WEP_STATE_HOLSTERED		= 1 -- Weapon is holstered
VJ.NPC_WEP_STATE_RELOADING		= 2 -- Weapon is reloading

-- NPC weapon inventory status
VJ.NPC_WEP_INVENTORY_NONE		= 0 -- Currently using no weapon (Default)
VJ.NPC_WEP_INVENTORY_PRIMARY	= 1 -- Currently using its primary weapon
VJ.NPC_WEP_INVENTORY_SECONDARY	= 2 -- Currently using its secondary weapon
VJ.NPC_WEP_INVENTORY_MELEE		= 3 -- Currently using its melee weapon
VJ.NPC_WEP_INVENTORY_ANTI_ARMOR	= 4 -- Currently using its anti-armor weapon

-- Model animation set
VJ.ANIM_SET_NONE				= 0 -- No model animation set detected (Default)
VJ.ANIM_SET_COMBINE				= 1 -- Current model's animation set is combine
VJ.ANIM_SET_METROCOP			= 2 -- Current model's animation set is metrocop
VJ.ANIM_SET_REBEL				= 3 -- Current model's animation set is citizen / rebel
VJ.ANIM_SET_PLAYER				= 4 -- Current model's animation set is player
VJ.ANIM_SET_CUSTOM				= 10 -- Use this when defining a custom model set
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Tags / Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
[Variable]						[Type]		[Description]

-- Activities & Behaviors
VJTag_IsPickupable				bool		Entity can be picked up by NPCs (Ex: Grenades)
VJTag_IsPickedUp				bool		Entity that is currently picked up by an NPC and most likely throwing it away (Ex: Grenades)
VJTag_IsHealing					bool		Entity is healing (either itself or by another entity)
VJTag_IsEating					bool		Entity is eating something (Ex: a corpse)
VJTag_IsBeingEaten				bool		Entity is being eaten by something
VJTag_IsBaseFriendly			bool		Friendly to VJ NPCs

-- Base types
IsVJBaseSNPC					bool
IsVJBaseSNPC_Creature			bool
IsVJBaseSNPC_Human				bool
IsVJBaseSNPC_Tank				bool
IsVJBaseWeapon					bool
IsVJBaseCorpse					bool
IsVJBaseCorpse_Gib				bool
IsVJBaseSpawner					bool
IsVJBaseBoneFollower			bool
IsVJBaseEdited					bool		This entity's meta table has been edited by VJ Base

-- Identifiers
VJ_IsHugeMonster				bool		NPC is considered to be very large and/or a boss
VJTag_ID_Prop					bool		Entity is considered a prop and can be attacked/pushed by NPCs
VJTag_ID_Danger					bool		Entity is dangerous and should be detected as a regular danger by NPCs
VJTag_ID_Grenade				bool		Entity is a grenade type and should be detected as a grenade danger by NPCs
VJTag_ID_Headcrab				bool
VJTag_ID_Police					bool
VJTag_ID_Civilian				bool
VJTag_ID_Turret					bool
VJTag_ID_Vehicle				bool
VJTag_ID_Aircraft				bool

-- Sounds
VJTag_SD_PlayingMusic			bool		Entity is playing a sound track

-- Controllers
VJTag_IsControllingNPC			bool		Entity is controlling an NPC, usually using the NPC Controller | Mainly used for players
VJ_IsBeingControlled			bool		Entity is being controlled by the NPC Controller
VJ_IsBeingControlled_Tool		bool		Entity is being controlled by the NPC Mover tool
VJ_TheController				entity		The player that's controlling this entity through the NPC Controller
VJ_TheControllerEntity			entity		The controller entity

-- Miscellaneous
VJ_LastInvestigateSd			number		Last time this NPC/Player has made a sound that should be investigated by enemy NPCs
VJ_LastInvestigateSdLevel		number		The sound level of the above variable
*/