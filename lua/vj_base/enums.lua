/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
if !VJ then VJ = {} end -- If VJ isn't initialized, initialize it!

---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	- Never call by their value as they may change around in updates!
	- Recommended to localize the enum if it's called often
-----------------------------------------------------------]]

-- NPC attack type
VJ.ATTACK_TYPE_NONE				= 0 -- No attack is set | DEFAULT
VJ.ATTACK_TYPE_CUSTOM			= 1 -- Custom attack | Used by developers to make custom attacks
VJ.ATTACK_TYPE_MELEE			= 2 -- Melee attack
VJ.ATTACK_TYPE_RANGE			= 3 -- Ranged attack
VJ.ATTACK_TYPE_LEAP				= 4 -- Leap attack
VJ.ATTACK_TYPE_GRENADE			= 5 -- Grenade attack

-- NPC attack state
VJ.ATTACK_STATE_NONE			= 0 -- No attack state is set | DEFAULT
VJ.ATTACK_STATE_DONE			= 1 -- Current attack has been executed completely and is marked as done
VJ.ATTACK_STATE_STARTED			= 2 -- Current attack has started and is expected to execute soon
VJ.ATTACK_STATE_EXECUTED		= 3 -- Current attack has been executed at least once
VJ.ATTACK_STATE_EXECUTED_HIT	= 4 -- Current attack has been executed at least once AND hit an entity at least once (Melee & Leap attacks)

-- NPC facing status
VJ.NPC_FACE_NONE				= 0 -- Not currently facing anything | DEFAULT
VJ.NPC_FACE_ENEMY				= 1 -- Currently attempting to face the enemy
VJ.NPC_FACE_ENEMY_VISIBLE		= 2 -- Currently attempting to face the enemy when it's visible
VJ.NPC_FACE_ENTITY				= 3 -- Currently attempting to face a specific entity
VJ.NPC_FACE_ENTITY_VISIBLE		= 4 -- Currently attempting to face a specific entity when it's visible
VJ.NPC_FACE_POSITION			= 5 -- Currently attempting to face a specific position
VJ.NPC_FACE_POSITION_VISIBLE	= 6 -- Currently attempting to face a specific position when it's visible

-- Danger detected type (Used by human NPCs)
VJ.NPC_DANGER_TYPE_ENTITY		= 1 -- Entity type of danger | Commonly produced by projectiles | Associated: "ent.VJTag_ID_Danger"
VJ.NPC_DANGER_TYPE_GRENADE		= 2 -- Grenade type of danger | Commonly produced by grenades | Associated: "ent.VJTag_ID_Grenade"
VJ.NPC_DANGER_TYPE_HINT			= 3 -- Hint type of danger | Commonly used by sound hints | Associated: COND_HEAR_DANGER, COND_HEAR_PHYSICS_DANGER, COND_HEAR_MOVE_AWAY

-- NPC weapon state
VJ.NPC_WEP_STATE_READY			= 0 -- Weapon is ready to be fired | DEFAULT
VJ.NPC_WEP_STATE_HOLSTERED		= 1 -- Weapon is holstered
VJ.NPC_WEP_STATE_RELOADING		= 2 -- Weapon is reloading

-- NPC weapon inventory status
VJ.NPC_WEP_INVENTORY_NONE		= 0 -- Currently using no weapon | DEFAULT
VJ.NPC_WEP_INVENTORY_PRIMARY	= 1 -- Currently using its primary weapon
VJ.NPC_WEP_INVENTORY_SECONDARY	= 2 -- Currently using its secondary weapon
VJ.NPC_WEP_INVENTORY_MELEE		= 3 -- Currently using its melee weapon
VJ.NPC_WEP_INVENTORY_ANTI_ARMOR	= 4 -- Currently using its anti-armor weapon

-- Animation type
VJ.ANIM_TYPE_NONE				= 0 -- No type detected including fail cases and resets | DEFAULT
VJ.ANIM_TYPE_ACTIVITY			= 1 -- Animation is an activity
VJ.ANIM_TYPE_SEQUENCE			= 2 -- Animation is a sequence
VJ.ANIM_TYPE_GESTURE			= 3 -- Animation is a gesture

-- Model animation set
VJ.ANIM_SET_NONE				= 0 -- No model animation set detected | DEFAULT
VJ.ANIM_SET_COMBINE				= 1 -- Current model's animation set is HL2 combine
VJ.ANIM_SET_METROCOP			= 2 -- Current model's animation set is HL2 metrocop
VJ.ANIM_SET_REBEL				= 3 -- Current model's animation set is HL2 citizen / rebel
VJ.ANIM_SET_PLAYER				= 4 -- Current model's animation set is default player
VJ.ANIM_SET_CUSTOM				= 10 -- Use this when defining a custom model set
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Tags / Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
[Variable]						[Type]		[Description]

-- Base types
IsVJBaseSNPC					bool
IsVJBaseSNPC_Creature			bool
IsVJBaseSNPC_Human				bool
IsVJBaseSNPC_Tank				bool
IsVJBaseWeapon					bool
IsVJBaseCorpse					bool
IsVJBaseCorpse_Gib				bool
IsVJBaseSpawner					bool
IsVJBaseBullseye				bool
IsVJBaseEdited					bool		This entity's meta table has been edited by VJ Base

-- Activities & Behaviors
VJTag_IsLiving					bool		Entity is a living object and should be detected by VJ NPCs | Includes: Players, NPCs, NextBots
VJTag_IsAttackable				bool		Entity is an object that should be attacked or pushed by NPCs in certain cases (Ex: Object is in the way while chasing)
VJTag_IsDamageable				bool		Entity is an object that should be damaged by attacks, projectiles, etc. (Ex: An object in the crossfire of a melee attack)
VJTag_IsPickupable				bool		Entity can be picked up by NPCs (Ex: Grenades)
VJTag_IsPickedUp				bool		Entity that is currently picked up by an NPC and most likely throwing it away (Ex: Grenades)
VJTag_PickedUpOrgMoveType		enum		Entity's original move type before being picked up, usually set alongside "VJTag_IsPickedUp"
VJTag_IsHealing					bool		Entity is healing (either itself or by another entity)
VJTag_IsEating					bool		Entity is eating something (Ex: a corpse)
VJTag_IsBeingEaten				bool		Entity is being eaten by something

-- Identifiers
VJTag_ID_Boss					bool		Entity is a very large and/or a boss | It affects parts of the entity, for example It won't receive any melee knock back
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
VJ_IsBeingControlled			bool		Entity is being controlled by the NPC Controller | Also applied to the bullseye entity!
VJ_IsBeingControlled_Tool		bool		Entity is being controlled by the NPC Mover tool
VJ_TheController				entity		The player that's controlling this entity through the NPC Controller
VJ_TheControllerEntity			entity		The controller entity

-- Miscellaneous
VJ_LastInvestigateSd			number		Last time this NPC/Player has made a sound that should be investigated by enemy NPCs
VJ_LastInvestigateSdLevel		number		The sound level of the above variable
*/