/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
if !VJ then VJ = {} end -- If VJ isn't initialized, initialize it!

---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	- Never call by their value as they may change around in updates!
	- Recommended to localize the enum if it's called often
-----------------------------------------------------------]]

-- Additional damage types | For use with "dmginfo:SetDamageCustom()"
VJ.DMG_BLEED					= 123454 -- Bleeding damage, usually caused by melee attacks
VJ.DMG_FORCE_FLINCH				= 123455 -- Causes NPCs to always flinch

-- NPC attack type
VJ.ATTACK_TYPE_NONE				= false -- No attack is set | DEFAULT
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
VJ.NPC_FACE_NONE				= false -- Not currently facing anything | DEFAULT
VJ.NPC_FACE_ENEMY				= 1 -- Currently attempting to face the enemy
VJ.NPC_FACE_ENEMY_VISIBLE		= 2 -- Currently attempting to face the enemy when it's visible
VJ.NPC_FACE_ENTITY				= 3 -- Currently attempting to face a specific entity
VJ.NPC_FACE_ENTITY_VISIBLE		= 4 -- Currently attempting to face a specific entity when it's visible
VJ.NPC_FACE_POSITION			= 5 -- Currently attempting to face a specific position
VJ.NPC_FACE_POSITION_VISIBLE	= 6 -- Currently attempting to face a specific position when it's visible

-- Alert state
VJ.NPC_ALERT_STATE_NONE			= false -- Not currently facing anything | DEFAULT
VJ.NPC_ALERT_STATE_READY		= 1 -- Alerted but no enemy was ever seen since it got alerted
VJ.NPC_ALERT_STATE_ENEMY		= true -- Has seen an enemy since it got alerted

-- Danger detected type (Used by human NPCs)
VJ.NPC_DANGER_TYPE_ENTITY		= 1 -- Entity type of danger | Commonly produced by projectiles | Associated: "ent.VJ_ID_Danger"
VJ.NPC_DANGER_TYPE_GRENADE		= 2 -- Grenade type of danger | Commonly produced by grenades | Associated: "ent.VJ_ID_Grenade"
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
VJ.ANIM_TYPE_NONE				= false -- No type detected including fail cases and resets | DEFAULT
VJ.ANIM_TYPE_ACTIVITY			= 1 -- Animation is an activity
VJ.ANIM_TYPE_SEQUENCE			= 2 -- Animation is a sequence
VJ.ANIM_TYPE_GESTURE			= 3 -- Animation is a gesture

-- Model animation set
VJ.ANIM_SET_NONE				= false -- No model animation set detected | DEFAULT
VJ.ANIM_SET_COMBINE				= 1 -- Current model's animation set is HL2 combine
VJ.ANIM_SET_METROCOP			= 2 -- Current model's animation set is HL2 metrocop
VJ.ANIM_SET_REBEL				= 3 -- Current model's animation set is HL2 citizen / rebel
VJ.ANIM_SET_PLAYER				= 4 -- Current model's animation set is default player
VJ.ANIM_SET_CUSTOM				= 10 -- Use this when defining a custom model set

-- Blood Colors
VJ.BLOOD_COLOR_NONE				= false -- No blood color | DEFAULT
VJ.BLOOD_COLOR_RED				= "Red"
VJ.BLOOD_COLOR_YELLOW			= "Yellow"
VJ.BLOOD_COLOR_GREEN			= "Green"
VJ.BLOOD_COLOR_ORANGE			= "Orange"
VJ.BLOOD_COLOR_BLUE				= "Blue"
VJ.BLOOD_COLOR_PURPLE			= "Purple"
VJ.BLOOD_COLOR_WHITE			= "White"
VJ.BLOOD_COLOR_OIL				= "Oil"

-- Projectile types
VJ.PROJ_TYPE_LINEAR				= 0
	-- Gravity: Disabled
	-- Mass: 1
	-- Collision Group: COLLISION_GROUP_PROJECTILE
	-- Triggers: Enabled
	-- Examples: Rocket, Orb
VJ.PROJ_TYPE_GRAVITY			= 1
	-- Gravity: Enabled
	-- Mass: 1
	-- Collision Group: COLLISION_GROUP_PROJECTILE
	-- Triggers: Enabled
	-- Examples: Spit
VJ.PROJ_TYPE_PROP				= 2
	-- Gravity: Enabled
	-- Mass: Model's mass
	-- Collision Group: COLLISION_GROUP_NONE
	-- Triggers: Disabled (Can't touch noclipping players, Certain flying NPCs, etc.)
	-- Examples: Grenade

-- Projectile collision behavior
VJ.PROJ_COLLISION_NONE			= false -- Do nothing
VJ.PROJ_COLLISION_REMOVE		= 1 -- Deal damage, paint decal, play sound, etc, and then remove the entity
VJ.PROJ_COLLISION_PERSIST		= 2 -- Deal damage, paint decal, play sound, etc, but do NOT remove the entity

-- Kill icons
VJ.KILLICON_TYPE_FONT			= -2 -- Use this to make a font-based kill icon
VJ.KILLICON_TYPE_ALIAS			= -1 -- Use this to make it use another class's kill icon
VJ.KILLICON_DEFAULT				= "HUD/killicons/default"
VJ.KILLICON_PROJECTILE			= "vj_base/hud_controller/range.png"
VJ.KILLICON_GRENADE				= "vj_base/hud_controller/grenade.png"

-- Colors
VJ.COLOR_LOGO_ORANGE			= Color(244, 102, 34)
VJ.COLOR_LOGO_ORANGE_LIGHT		= Color(255, 163, 121) -- Used to refer to VJ Base in console prints
VJ.COLOR_SERVER					= Color(156, 241, 255, 200) -- GMod's server print color
VJ.COLOR_CLIENT					= Color(255, 241, 122, 200) -- GMod's client print color
--
VJ.COLOR_RED					= Color(255, 0, 0)
VJ.COLOR_RED_LIGHT				= Color(255, 130, 130)
VJ.COLOR_GREEN					= Color(0, 255, 0)
VJ.COLOR_BLUE					= Color(0, 0, 255)
VJ.COLOR_YELLOW					= Color(255, 255, 0)
VJ.COLOR_ORANGE					= Color(255, 165, 0)
VJ.COLOR_PURPLE					= Color(128, 0, 128)
VJ.COLOR_CYAN					= Color(0, 255, 255)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Tags / Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
[Variable]						[Type]		[Description]

-- Base types
IsVJBaseSNPC					bool		It's inherited from a VJ NPC base
IsVJBaseSNPC_Creature			bool		It's inherited from "npc_vj_creature_base"
IsVJBaseSNPC_Human				bool		It's inherited from "npc_vj_human_base"
IsVJBaseSNPC_Tank				bool		It's inherited from "npc_vj_tank_base" or "npc_vj_tankg_base"
IsVJBaseSNPC_TankChassis		bool		It's inherited from "npc_vj_tank_base"
IsVJBaseSNPC_TankGun			bool		It's inherited from "npc_vj_tankg_base"
IsVJBaseWeapon					bool		It's inherited from "weapon_vj_base"
IsVJBaseProjectile				bool		It's inherited from "obj_vj_projectile_base"
IsVJBaseCorpse					bool		It's spawned as a corpse from a VJ NPC or inherited from "obj_vj_gib"
IsVJBaseCorpse_Gib				bool		It's spawned as a gib from a VJ NPC or inherited from "obj_vj_gib"
IsVJBaseSpawner					bool		It's inherited from "obj_vj_spawner_base"
IsVJBaseBullseye				bool		It's inherited from "obj_vj_bullseye"
IsVJBaseEdited					bool		its meta table has been edited by VJ Base

-- States
VJ_ST_Grabbed					bool		It's currently grabbed by an NPC and most likely throwing it away (Ex: Grenades)
VJ_ST_GrabOrgMoveType			enum		Its original move type before being grabbed, set alongside "VJ_ST_Grabbed"
VJ_ST_Healing					bool		It's healing itself or by another entity
VJ_ST_Eating					bool		It's eating something (Ex: a corpse)
VJ_ST_BeingEaten				bool		It's being eaten by something

-- Identifiers
VJ_ID_Living					bool		It's a living and should be detected by VJ NPCs | Includes: Players, NPCs, NextBots
VJ_ID_Attackable				bool		It should be attacked or pushed by NPCs in certain cases (Ex: It's in the way while an NPC is chasing)
VJ_ID_Destructible				bool		It should be damaged by attacks, projectiles, etc. (Ex: It's in the crossfire of a melee attack)
VJ_ID_Grabbable					bool		It can be grabbed up by NPCs (Ex: Grenades)
VJ_ID_Danger					bool		It's dangerous and should be detected as a regular danger by NPCs
VJ_ID_Grenade					bool		It's a grenade type and should be detected as a grenade danger by NPCs
VJ_ID_Boss						bool		It's a large and/or a boss | Affects parts of the entity, for example It won't receive any melee knock back
VJ_ID_Police					bool		Police officers, metrocops, etc.
VJ_ID_Civilian					bool		Civilians, citizens, etc.
VJ_ID_Headcrab					bool		Headcrabs
VJ_ID_Turret					bool		Turrets, sentry guns, etc.
VJ_ID_Vehicle					bool		Cars, tanks, APCs, helicopters, planes, boats, etc.
VJ_ID_Aircraft					bool		Helicopters, jets, planes, etc.

-- Sounds
VJ_SD_InvestTime				number		Last time this NPC/Player has made a investigatable sound that should be heard by enemy NPCs
VJ_SD_InvestLevel				number		Sound level of the last investigatable sound made by this NPC/Player | Used alongside "VJ_SD_InvestTime"
VJ_SD_PlayingMusic				bool		It's playing a sound track

-- Controllers
VJ_IsControllingNPC				bool		It's controlling an NPC, usually using the NPC Controller | Mainly used for players
VJ_IsBeingControlled			bool		It's being controlled by the NPC Controller | Also applied to the bullseye entity!
VJ_IsBeingControlled_Tool		bool		It's being controlled by the NPC Mover tool
VJ_TheController				entity		The player that's controlling this entity through the NPC Controller
VJ_TheControllerEntity			entity		The controller entity
*/