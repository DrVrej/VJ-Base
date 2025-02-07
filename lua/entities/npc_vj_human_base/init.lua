AddCSLuaFile("shared.lua")
include("vj_base/ai/core.lua")
include("vj_base/ai/schedules.lua")
include("vj_base/ai/base_aa.lua")
include("shared.lua")
/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
local PICK = VJ.PICK
AccessorFunc(ENT, "m_iClass", "NPCClass", FORCE_NUMBER)
AccessorFunc(ENT, "m_fMaxYawSpeed", "MaxYawSpeed", FORCE_NUMBER)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Core ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.Model = false -- Model(s) to spawn with | Picks a random one if it's a table
ENT.EntitiesToNoCollide = false -- Set to a table of entity class names for the NPC to not collide with otherwise leave it to false
ENT.CanChatMessage = true -- Should this NPC be allowed to post in a player's chat? | Example: "Blank no longer likes you."
	-- ====== Health ====== --
ENT.StartHealth = 50 -- Starting health of the NPC
ENT.HasHealthRegeneration = false -- Can the NPC regenerate its health?
ENT.HealthRegenerationAmount = 4 -- How much should the health increase after every delay?
ENT.HealthRegenerationDelay = VJ.SET(2, 4) -- How much time until the health increases
ENT.HealthRegenerationResetOnDmg = true -- Should the delay reset when it receives damage?
	-- ====== Collision / Hitbox ====== --
ENT.HullType = HULL_HUMAN -- List of Hull types: https://wiki.facepunch.com/gmod/Enums/HULL
ENT.HasSetSolid = true -- set to false to disable SetSolid
	-- ====== Sight & Speed ====== --
ENT.SightDistance = 6500 -- Initial sight distance | To retrieve: "self:GetMaxLookDistance()" | To change: "self:SetMaxLookDistance(distance)"
ENT.SightAngle = 177 -- Initial field of view | To retrieve: "self:GetFOV()" | To change: "self:SetFOV(degree)" | 360 = See all around
ENT.TurningSpeed = 20 -- How fast it can turn
ENT.TurningUseAllAxis = false -- If set to true, angles will not be restricted to y-axis, it will change all axes (plural axis)
ENT.CanTurnWhileMoving = true -- Can the NPC turn while moving? | EX: GoldSrc NPCs, Facing enemy while running to cover, Facing the player while moving out of the way
	-- ====== Movement ====== --
	-- Types: VJ_MOVETYPE_GROUND | VJ_MOVETYPE_AERIAL | VJ_MOVETYPE_AQUATIC | VJ_MOVETYPE_STATIONARY | VJ_MOVETYPE_PHYSICS
ENT.MovementType = VJ_MOVETYPE_GROUND -- How the NPC moves around
ENT.UsePoseParameterMovement = false -- Sets the NPC's "move_x" and "move_y" pose parameters while moving | Required for player models to move properly!
	-- Movement: JUMP --
	-- Requires "CAP_MOVE_JUMP" capability
	-- Applied automatically by the base if "ACT_JUMP" is valid on the NPC's model
	-- Example scenario:
	--      [A]       <- Apex
	--     /   \
	--    /     [S]   <- Start
	--  [E]           <- End
ENT.JumpVars = {
	Enabled = true, -- Can the NPC do movements jumps?
	MaxRise = 80, -- How high it can jump up ((S -> A) AND (S -> E))
	MaxDrop = 230, -- How low it can jump down (E -> S)
	MaxDistance = 275, -- Maximum distance between Start and End
}
	-- Movement: STATIONARY --
ENT.CanTurnWhileStationary = true -- Can the NPC turn while it's stationary?
	-- ====== NPC Controller Data ====== --
ENT.VJC_Data = {
	CameraMode = 1, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
	ThirdP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in third person
	FirstP_Bone = "ValveBiped.Bip01_Head1", -- If left empty, the base will attempt to calculate a position for first person
	FirstP_Offset = Vector(0, 0, 5), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = true, -- Should the bone shrink? Useful if the bone is obscuring the player's view
	FirstP_CameraBoneAng = 0, -- Should the camera's angle be affected by the bone's angle? | 0 = No, 1 = Pitch, 2 = Yaw, 3 = Roll
	FirstP_CameraBoneAng_Offset = 0, -- How much should the camera's angle be rotated by? | Useful for weird bone angles
}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ AI & Relationship ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.CanOpenDoors = true -- Can it open doors?
ENT.CanReceiveOrders = true -- Can the NPC receive orders from others? | Ex: Allies calling for help, allies requesting backup on damage, etc.
	-- When false it will not receive the following: "CallForHelp", "CallForBackUpOnDamage", "BringFriendsOnDeath", "AlertFriendsOnDeath", "Passive_AlliesRunOnDamage"
ENT.CanAlly = true -- Put to false if you want it not to have any allies
ENT.VJ_NPC_Class = {} -- NPCs with the same class with be allied to each other
	-- Common Classes:
		-- Players / Resistance / Black Mesa = "CLASS_PLAYER_ALLY" || HECU = "CLASS_UNITED_STATES" || Portal = "CLASS_APERTURE"
		-- Combine = "CLASS_COMBINE" || Zombie = "CLASS_ZOMBIE" || Antlions = "CLASS_ANTLION" || Xen = "CLASS_XEN" || Black-Ops = "CLASS_BLACKOPS"
ENT.FriendsWithAllPlayerAllies = false -- Should this NPC be friends with other player allies?
ENT.Behavior = VJ_BEHAVIOR_AGGRESSIVE -- Type of AI behavior to use for this NPC
	-- VJ_BEHAVIOR_AGGRESSIVE = Default behavior, attacks enemies || VJ_BEHAVIOR_NEUTRAL = Neutral to everything, unless provoked
	-- VJ_BEHAVIOR_PASSIVE = Doesn't attack, but can be attacked by others || VJ_BEHAVIOR_PASSIVE_NATURE = Doesn't attack and is allied with everyone
ENT.IsGuard = false -- If set to false, it will attempt to stick to its current position at all times
ENT.AlertedToIdleTime = VJ.SET(14, 16) -- How much time until it calms down after the enemy has been killed/disappeared | Sets self.Alerted to false after the timer expires
ENT.TimeUntilEnemyLost = 15 -- Time until it resets its enemy if the enemy is not visible
ENT.MoveOutOfFriendlyPlayersWay = true -- Should the NPC move and give space to friendly players?
ENT.BecomeEnemyToPlayer = false -- Should it become enemy towards an allied player if it's damaged by them or it witnesses another ally killed by them?
	-- false = Don't | number = Threshold, where each negative event increases it by 1, if it passes this number it will become enemy
	-- ====== Passive Behavior ====== --
ENT.Passive_RunOnTouch = true -- Should it run away and make a alert sound when something collides with it?
ENT.Passive_NextRunOnTouchTime = VJ.SET(3, 4) -- How much until it can run away again when something collides with it?
ENT.Passive_RunOnDamage = true -- Should it run when it's damaged? | This doesn't impact how self.Passive_AlliesRunOnDamage works
ENT.Passive_AlliesRunOnDamage = true -- Should its allies (other passive NPCs) also run when it's damaged?
ENT.Passive_AlliesRunOnDamageDistance = 800 -- Any allies within this distance will run when it's damaged
ENT.Passive_NextRunOnDamageTime = VJ.SET(6, 7) -- How much until it can run the code again?
	-- ====== On Player Sight ====== --
ENT.HasOnPlayerSight = false -- Should do something when it sees the enemy? Example: Play a sound
ENT.OnPlayerSightDistance = 200 -- How close should the player be until it runs the code?
ENT.OnPlayerSightDispositionLevel = 1 -- 0 = Run it every time | 1 = Run it only when friendly to player | 2 = Run it only when enemy to player
ENT.OnPlayerSightOnlyOnce = true -- If true, it will only run the code once | Sets self.HasOnPlayerSight to false once it runs!
ENT.OnPlayerSightNextTime = VJ.SET(15, 20) -- How much time should it pass until it runs the code again?
	-- ====== Call For Help ====== --
ENT.CallForHelp = true -- Can the NPC request allies for help while in combat?
ENT.CallForHelpDistance = 2000 -- -- How far away the NPC's call for help travels
ENT.NextCallForHelpTime = 4 -- Time until it calls for help again
ENT.HasCallForHelpAnimation = true -- if true, it will play the call for help animation
ENT.AnimTbl_CallForHelp = {ACT_SIGNAL_ADVANCE, ACT_SIGNAL_FORWARD}
ENT.CallForHelpAnimationFaceEnemy = true -- Should it face the enemy when playing the animation?
ENT.NextCallForHelpAnimationTime = 30 -- How much time until it can play the animation again?
	-- ====== Medic ====== --
ENT.IsMedic = false -- Is this NPC a medic? It will heal friendly players and NPCs
ENT.AnimTbl_Medic_GiveHealth = ACT_SPECIAL_ATTACK1 -- Animations is plays when giving health to an ally
ENT.Medic_DisableAnimation = false -- if true, it will disable the animation code
	-- To let the base automatically detect the animation duration, set this to false:
ENT.Medic_TimeUntilHeal = false -- Time until the ally receives health
ENT.Medic_CheckDistance = 600 -- How far does it check for allies that are hurt? | World units
ENT.Medic_HealDistance = 30 -- How close does it have to be until it stops moving and heals its ally?
ENT.Medic_HealthAmount = 25 -- How health does it give?
ENT.Medic_NextHealTime = VJ.SET(10, 15) -- How much time until it can give health to an ally again
ENT.Medic_SpawnPropOnHeal = true -- Should it spawn a prop, such as small health vial at a attachment when healing an ally?
ENT.Medic_SpawnPropOnHealModel = "models/healthvial.mdl" -- The model that it spawns
ENT.Medic_SpawnPropOnHealAttachment = "anim_attachment_LH" -- The attachment it spawns on
ENT.Medic_CanBeHealed = true -- Can this NPC be healed by medics?
	-- ====== Follow System ====== --
	-- Associated variables: self.FollowData, self.IsFollowing
ENT.FollowPlayer = true -- Should the NPC follow the player when the player presses a certain key? | Restrictions: Player has to be friendly and the NPC's move type cannot be stationary!
ENT.FollowMinDistance = 100 -- Minimum distance the NPC should come to the player | The base automatically adds the NPC's size to this variable to account for different sizes!
ENT.NextFollowUpdateTime = 0.5 -- Time until it checks if it should move to the player again | Lower number = More performance loss
	-- ====== Movement & Idle ====== --
ENT.IdleAlwaysWander = false -- Should the NPC constantly wander while idling?
ENT.DisableWandering = false
ENT.DisableChasingEnemy = false
	-- ====== Constantly Face Enemy ====== --
ENT.ConstantlyFaceEnemy = false -- Should it face the enemy constantly?
ENT.ConstantlyFaceEnemy_IfVisible = true -- Should it only face the enemy if it's visible?
ENT.ConstantlyFaceEnemy_IfAttacking = false -- Should it face the enemy when attacking?
ENT.ConstantlyFaceEnemy_Postures = "Both" -- "Both" = Moving or standing | "Moving" = Only when moving | "Standing" = Only when standing
ENT.ConstantlyFaceEnemyDistance = 2500 -- How close does it have to be until it starts to face the enemy?
	-- ====== Pose Parameter ====== --
ENT.HasPoseParameterLooking = true -- Does it look at its enemy using pose parameters?
ENT.PoseParameterLooking_CanReset = true -- Should it reset its pose parameters if there is no enemies?
ENT.PoseParameterLooking_InvertPitch = false -- Inverts the pitch pose parameters (X)
ENT.PoseParameterLooking_InvertYaw = false -- Inverts the yaw pose parameters (Y)
ENT.PoseParameterLooking_InvertRoll = false -- Inverts the roll pose parameters (Z)
ENT.PoseParameterLooking_TurningSpeed = 10 -- How fast does the parameter turn?
ENT.PoseParameterLooking_Names = {pitch={}, yaw={}, roll={}} -- Custom pose parameters to use, can put as many as needed
	-- ====== Investigation ====== --
	-- Showcase: https://www.youtube.com/watch?v=cCqoqSDFyC4
ENT.CanInvestigate = true -- Can it detect and investigate disturbances? | EX: Sounds, movement, flashlight, bullet hits
ENT.InvestigateSoundDistance = 9 -- How far can the NPC hear sounds? | This number is multiplied by the calculated volume of the detectable sound
	-- ====== Danger & Grenade Detection ====== --
	-- Showcase: https://www.youtube.com/watch?v=XuaMWPTe6rA
	-- EXAMPLES: Props that are one fire, especially objects like barrels that are about to explode, Combine mine that is triggered and about to explode, The location that the Antlion Worker's spit is going to hit, Combine Flechette that is about to explode,
	-- Antlion Guard that is charging towards the NPC, Player that is driving a vehicle at high speed towards the NPC, Manhack that has opened its blades, Rollermine that is about to self-destruct, Combine Helicopter that is about to drop bombs or is firing a turret near the NPC,
	-- Combine Gunship's is about to fire its belly cannon near the NPC, Turret impact locations fired by Combine Gunships, or Combine Dropships, or Striders, The location that a Combine Dropship is going to deploy soldiers, Strider is moving on top of the NPC,
	-- The location that the Combine or HECU mortar is going to hit, SMG1 grenades that are flying close by, A Combine soldier that is rappelling on top of the NPC, Stalker's laser impact location, Combine APC that is driving towards the NPC
ENT.CanDetectDangers = true -- Should the NPC detect dangers? | This includes grenades!
ENT.DangerDetectionDistance = 400 -- Max danger detection distance | WARNING: Most of the non-grenade dangers ignore this max value
ENT.CanThrowBackDetectedGrenades = true -- Should it pick up the detected grenade and throw it away or to the enemy?
	-- NOTE: Can only throw grenades away if it has a grenade attack AND can detect dangers
	-- ====== Taking Cover ====== --
ENT.AnimTbl_TakingCover = ACT_COVER_LOW -- The animation it plays when hiding in a covered position
ENT.AnimTbl_MoveToCover = ACT_RUN_CROUCH -- The animation it plays when moving to a covered position
	-- ====== Control ====== --
	-- Adjust these variables carefully! Wrong adjustment can have unintended effects!
ENT.FindEnemy_CanSeeThroughWalls = false -- Should it be able to see through walls and objects? | Useful to make it know where the enemy is at all times
ENT.DisableFindEnemy = false -- Disables FindEnemy code, friendly code still works though
ENT.DisableTakeDamageFindEnemy = false -- Disables the AI component that allows the NPC to find enemies all around it when it's damaged while idling
ENT.DisableTouchFindEnemy = false -- Disables the AI component that makes the NPC turn and look at an enemy that touched it
ENT.NextProcessTime = 1 -- Time until it runs the essential part of the AI, which can be performance heavy!
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Damaged / Injured ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.HideOnUnknownDamage = 5 -- number = Hide on unknown damage, defines the time until it can hide again | false = Disable this AI component
	-- ====== Blood ====== --
	-- Leave blood tables empty to let the base decide depending on the blood type
ENT.Bleeds = true -- Does the NPC bleed? Controls all bleeding related components such blood decal, particle, pool, etc.
ENT.BloodColor = VJ.BLOOD_COLOR_NONE -- NPC's blood type, this will determine the blood decal, particle, etc.
ENT.HasBloodDecal = true -- Should it spawn a decal when damaged?
ENT.BloodDecal = {} -- Decals to spawn when it's damaged
ENT.BloodDecalUseGMod = false -- Should it use the current default decals defined by Garry's Mod? | Only applies for certain blood types!
ENT.BloodDecalDistance = 150 -- Max distance blood decals can splatter
ENT.HasBloodParticle = true -- Should it spawn a particle when damaged?
ENT.BloodParticle = {} -- Particles to spawn when it's damaged
ENT.HasBloodPool = true -- Should a blood pool spawn by its corpse?
ENT.BloodPool = {} -- Blood pools to be spawned by the corpse
	-- ====== Immunity ====== --
ENT.GodMode = false -- Immune to everything
ENT.Immune_AcidPoisonRadiation = false -- Immune to Acid, Poison and Radiation
ENT.Immune_Bullet = false -- Immune to bullet type damages
ENT.Immune_Blast = false -- Immune to explosive-type damages
ENT.Immune_Dissolve = false -- Immune to dissolving | Example: Combine Ball
ENT.Immune_Electricity = false -- Immune to electrical-type damages | Example: shock or laser
ENT.Immune_Fire = false -- Immune to fire-type damages
ENT.Immune_Melee = false -- Immune to melee-type damage | Example: Crowbar, slash damages
ENT.Immune_Sonic = false -- Immune to sonic-type damages
ENT.ForceDamageFromBosses = false -- Should the NPC get damaged by bosses regardless if it's not supposed to by skipping immunity checks, etc. | Bosses are attackers tagged with "VJ_ID_Boss"
ENT.AllowIgnition = true -- Can this NPC be set on fire?
	-- ====== Flinching ====== --
ENT.CanFlinch = 0 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.FlinchDamageTypes = {DMG_BLAST} -- If it uses damage-based flinching, which types of damages should it flinch from?
ENT.FlinchChance = 16 -- Chance of it flinching from 1 to x | 1 will make it always flinch
	-- To let the base automatically detect the animation duration, set this to false:
ENT.NextMoveAfterFlinchTime = false -- How much time until it can move, attack, etc.
	-- To let the base automatically detect the animation duration, set this to false:
ENT.NextFlinchTime = 5 -- How much time until it can flinch again?
ENT.AnimTbl_Flinch = ACT_FLINCH_PHYSICS -- The regular flinch animations to play
ENT.HitGroupFlinching_DefaultWhenNotHit = true -- If it uses hitgroup flinching, should it do the regular flinch if it doesn't hit any of the specified hitgroups?
ENT.HitGroupFlinching_Values = false -- EXAMPLES: {{HitGroup = {HITGROUP_HEAD}, Animation = {ACT_FLINCH_HEAD}}, {HitGroup = {HITGROUP_LEFTARM}, Animation = {ACT_FLINCH_LEFTARM}}, {HitGroup = {HITGROUP_RIGHTARM}, Animation = {ACT_FLINCH_RIGHTARM}}, {HitGroup = {HITGROUP_LEFTLEG}, Animation = {ACT_FLINCH_LEFTLEG}}, {HitGroup = {HITGROUP_RIGHTLEG}, Animation = {ACT_FLINCH_RIGHTLEG}}}
	-- ====== Call For Back On Damage ====== --
	-- NOTE: This AI component only runs when there is NO enemy detected!
ENT.CallForBackUpOnDamage = true -- Should the NPC call for help when damaged?
ENT.CallForBackUpOnDamageDistance = 800 -- How far away does the call for help go?
ENT.CallForBackUpOnDamageLimit = 4 -- How many allies should it call? | 0 = Unlimited
ENT.NextCallForBackUpOnDamageTime = VJ.SET(9, 11) -- How much time until it can run this AI component again
ENT.CallForBackUpOnDamageAnimation = ACT_SIGNAL_GROUP -- Animations played when it calls for help on damage
ENT.DisableCallForBackUpOnDamageAnimation = false -- Disables the animations from playing
	-- ====== Move Or Hide On Damage ====== --
	-- Basically when damaged it will attempt to hide behind cover or move away if no cover is found
	-- NOTE: This only runs when it has a active enemy
ENT.MoveOrHideOnDamageByEnemy = true -- Should the NPC move away or hide behind cover when being damaged while fighting an enemy?
ENT.MoveOrHideOnDamageByEnemy_OnlyMove = false -- Should it only move away and not hide behind cover?
ENT.MoveOrHideOnDamageByEnemy_HideTime = VJ.SET(3, 5) -- How long should it hide behind cover?
ENT.MoveOrHideOnDamageByEnemy_NextTime = VJ.SET(3, 3.5) -- How long until it can do this behavior again? (hide behind cover or move away)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Death & Corpse ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.DeathDelayTime = 0 -- Time until the NPC spawns the corpse, removes itself, etc.
	-- ====== Ally Reaction On Death ====== --
	-- Default: Creature base uses "BringFriends" and Human base uses "AlertFriends"
	-- "BringFriendsOnDeath" takes priority over "AlertFriendsOnDeath"!
ENT.BringFriendsOnDeath = false -- Should the NPC's allies come to its position while it's dying?
ENT.BringFriendsOnDeathDistance = 800 -- How far away does the signal go? | Counted in World Units
ENT.BringFriendsOnDeathLimit = 3 -- How many people should it call? | 0 = Unlimited
ENT.AlertFriendsOnDeath = true -- Should the NPC's allies get alerted while it's dying? | Its allies will also need to have this variable set to true!
ENT.AlertFriendsOnDeathDistance = 800 -- How far away does the signal go? | Counted in World Units
ENT.AlertFriendsOnDeathLimit = 50 -- How many people should it alert?
	-- ====== Death Animation ====== --
ENT.HasDeathAnimation = false -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {}
	-- To let the base automatically detect the animation duration, set this to false:
	-- NOTE: This is added on top of "self.DeathDelayTime" !
ENT.DeathAnimationTime = false -- How long should the death animation play?
ENT.DeathAnimationChance = 1 -- Put 1 if you want it to play the animation all the time
ENT.DeathAnimationDecreaseLengthAmount = 0 -- This will decrease the time until it turns into a corpse
	-- ====== Corpse ====== --
ENT.HasDeathCorpse = true -- Should a corpse spawn when it's killed?
ENT.DeathCorpseEntityClass = false -- Corpse's class | false = Let the base automatically detect the class
ENT.DeathCorpseModel = false -- Model(s) to spawn as the NPC's corpse | false = Use the NPC's model | Can be a single string or a table of strings
ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS -- Collision type for the corpse | NPC Options Menu can only override this value if it's set to COLLISION_GROUP_DEBRIS!
ENT.DeathCorpseFade = false -- Should the corpse fade after the given amount of seconds? | false = Don't fade | number = Fade out time
ENT.DeathCorpseSetBoneAngles = true -- This can be used to stop the corpse glitching or flying on death
ENT.DeathCorpseApplyForce = true -- Should the force of the damage be applied to the corpse?
ENT.DeathCorpseSubMaterials = nil -- Apply a table of indexes that correspond to a sub material index, this will cause the base to copy the NPC's sub material to the corpse.
	-- ====== Dismemberment / Gib ====== --
ENT.CanGib = true -- Can the NPC gib? | Makes "CreateGibEntity" fail and overrides "CanGibOnDeath" to false
ENT.CanGibOnDeath = true -- Is it allowed to gib on death?
ENT.GibOnDeathFilter = true -- Should it only gib and call "self:HandleGibOnDeath" when it's killed by a specific damage types? | false = Call "self:HandleGibOnDeath" from any damage type
ENT.HasGibOnDeathSounds = true -- Does it have gib sounds? | Mostly used for the settings menu
ENT.HasGibOnDeathEffects = true -- Does it spawn particles on death or when it gibs? | Mostly used for the settings menu
	-- ====== Drops On Death ====== --
ENT.DropWeaponOnDeath = true -- Should it drop its weapon on death?
ENT.DropDeathLoot = true -- Should it drop loot on death?
ENT.DeathLootChance = 14 -- If set to 1, it will always drop loot
ENT.DeathLoot = {"weapon_frag", "item_healthvial"} -- List of entities it will randomly pick to drop | Leave it empty to drop nothing
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Melee Attack ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasMeleeAttack = true -- Can this NPC melee attack?
ENT.MeleeAttackDamage = 10
ENT.MeleeAttackDamageType = DMG_CLUB -- Type of Damage
ENT.HasMeleeAttackKnockBack = true -- Should knockback be applied on melee hit? | Use "MeleeAttackKnockbackVelocity" function to edit the velocity
	-- ====== Animation ====== --
ENT.AnimTbl_MeleeAttack = ACT_MELEE_ATTACK1
ENT.MeleeAttackAnimationDelay = 0 -- It will wait certain amount of time before playing the animation
ENT.MeleeAttackAnimationFaceEnemy = true -- Should it face the enemy while playing the melee attack animation?
ENT.MeleeAttackAnimationDecreaseLengthAmount = 0 -- This will decrease the time until starts chasing again. Use it to fix animation pauses until it chases the enemy.
	-- ====== Distance ====== --
ENT.MeleeAttackDistance = false -- How close an enemy has to be to trigger a melee attack | false = Let the base auto calculate on initialize based on the NPC's collision bounds
ENT.MeleeAttackAngleRadius = 100 -- What is the attack angle radius? | 100 = In front of the NPC | 180 = All around the NPC
ENT.MeleeAttackDamageDistance = false -- How far does the damage go? | false = Let the base auto calculate on initialize based on the NPC's collision bounds
ENT.MeleeAttackDamageAngleRadius = 100 -- What is the damage angle radius? | 100 = In front of the NPC | 180 = All around the NPC
	-- ====== Timer ====== --
	-- Set this to false to make the attack event-based:
ENT.TimeUntilMeleeAttackDamage = 0.5 -- This counted in seconds | This calculates the time until it hits something
ENT.NextMeleeAttackTime = 0 -- How much time until it can use a melee attack?
ENT.NextMeleeAttackTime_DoRand = false -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer
	-- To let the base automatically detect the attack duration, set this to false:
ENT.NextAnyAttackTime_Melee = false -- How much time until it can use any attack again? | Counted in Seconds
ENT.NextAnyAttackTime_Melee_DoRand = false -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer
ENT.MeleeAttackReps = 1 -- How many times does it run the melee attack code?
ENT.MeleeAttackExtraTimers = nil -- Extra melee attack timers, EX: {1, 1.4} | it will run the damage code after the given amount of seconds
ENT.StopMeleeAttackAfterFirstHit = false -- Should it stop the melee attack from running rest of timers when it hits an enemy?
	-- ====== Control ====== --
ENT.DisableMeleeAttackAnimation = false -- if true, it will disable the animation code
ENT.DisableDefaultMeleeAttackCode = false -- When set to true, it will completely disable the melee attack code
ENT.DisableDefaultMeleeAttackDamageCode = false -- Disables the default melee attack damage code
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Weapon Attack ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.DisableWeapons = false -- If set to true, it won't be able to use weapons
ENT.Weapon_NoSpawnMenu = false -- Should it ignore the weapon override setting from the spawn menu?
ENT.Weapon_Accuracy = 1 -- NPC's accuracy with weapons, affects bullet spread! | x < 1 = Better accuracy | x > 1 = Worse accuracy
ENT.Weapon_CanFireWhileMoving = true -- Can it fire its weapon while it's moving?
ENT.Weapon_StrafeWhileFiring = true -- Should it move randomly while firing a weapon?
ENT.Weapon_StrafeWhileFiringDelay = VJ.SET(3, 6) -- How much time until it can randomly move again?
ENT.Weapon_WaitOnOcclusion = true -- Should it wait before leaving its position to pursue the enemy after its been occluded?
ENT.Weapon_WaitOnOcclusionTime = VJ.SET(3, 5) -- How long should it wait before it starts to pursue?
ENT.Weapon_WaitOnOcclusionMinDist = 100 -- Skip this behavior if the occluded enemy is within this distance
ENT.Weapon_UnarmedBehavior = true -- Should it use the fleeing behavior when it's unarmed? | It will run and hide from enemies
	-- ====== Distance ====== --
ENT.Weapon_FiringDistanceFar = 3000 -- How far away it can shoot
ENT.Weapon_FiringDistanceClose = 10 -- How close until it stops shooting
ENT.Weapon_RetreatDistance = 150 -- If enemy is within this distance, it will retreat back | 0 = Never back away
ENT.Weapon_AimTurnDiff = false -- Weapon aim turning threshold between 0 and 1 | "self.HasPoseParameterLooking" must be set to true!
	-- EXAMPLES: 0.707106781187 = 45 degrees | 0.866025403784 = 30 degrees | 1 = 0 degrees, always turn!
	-- false = Let base decide based on animation set and weapon hold type
	-- ====== Primary Fire ====== --
ENT.AnimTbl_WeaponAttack = ACT_RANGE_ATTACK1 -- Animation(s) to play while firing a weapon
ENT.Weapon_CanCrouchAttack = true -- Can it crouch while shooting?
ENT.Weapon_CrouchAttackChance = 2 -- How much chance of crouching? | 1 = Crouch whenever possible
ENT.AnimTbl_WeaponAttackCrouch = ACT_RANGE_ATTACK1_LOW -- Animation(s) to play while firing a weapon in crouched position
ENT.DisableWeaponFiringGesture = false -- If set to true, it will disable the weapon firing gestures
ENT.AnimTbl_WeaponAttackGesture = ACT_GESTURE_RANGE_ATTACK1 -- Gesture animation(s) to play while firing a weapon
	-- ====== Secondary Fire ====== --
ENT.Weapon_CanSecondaryFire = true -- Can the NPC use the weapon's secondary fire if it's available?
ENT.AnimTbl_WeaponAttackSecondary = "shootAR2alt" -- Animation(s) to play while firing the weapon's secondary attack
	-- To let the base automatically detect the animation duration, set this to false:
ENT.Weapon_SecondaryFireTime = 0.9 -- The weapon uses this integer to set the time until the firing code is ran
	-- ====== Reloading ====== --
ENT.Weapon_CanReload = true -- Can the NPC reload its weapon?
ENT.Weapon_FindCoverOnReload = true -- Should it attempt to find cover before proceeding to reload?
ENT.AnimTbl_WeaponReload = ACT_RELOAD -- Animations that play when the NPC reloads
ENT.AnimTbl_WeaponReloadCovered = ACT_RELOAD_LOW -- Animations that play when the NPC reloads, but behind cover
ENT.DisableWeaponReloadAnimation = false -- if true, it will disable the animation code when reloading
	-- ====== Weapon Inventory ====== --
	-- Weapons are given on spawn and the NPC will only switch to those if the requirements are met
	-- All are stored in "self.WeaponInventory" with the following keys:
		-- Primary : Default weapon
		-- AntiArmor : Current enemy is an armored enemy tank/vehicle or a boss
		-- Melee : Current enemy is (very close and the NPC is out of ammo) OR (in regular melee attack distance) + NPC must have more than 25% health
ENT.WeaponInventory_AntiArmorList = false -- On spawn it will give the NPC one of the weapons | Can be a table or a string
ENT.WeaponInventory_MeleeList = false -- On spawn it will give the NPC one of the weapons | Can be a table or a string
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Grenade Attack ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasGrenadeAttack = false -- Should the NPC have a grenade attack?
ENT.GrenadeAttackEntity = "obj_vj_grenade" -- Entities that it can spawn when throwing a grenade | If set as a table, it picks a random entity | VJ: "obj_vj_grenade" | HL2: "npc_grenade_frag"
ENT.GrenadeAttackModel = nil -- Overrides the model of the grenade | Can be nil, string, and table | Does NOT apply to picked up grenades and forced grenade attacks with custom entity
ENT.GrenadeAttackAttachment = "anim_attachment_LH" -- The attachment that the grenade will be set to | -1 = Skip to use "self.GrenadeAttackBone" instead
ENT.GrenadeAttackBone = "ValveBiped.Bip01_L_Finger1" -- The bone that the grenade will be set to | -1 = Skip to use fail safe instead
	-- ====== Animation ====== --
ENT.AnimTbl_GrenadeAttack = "grenThrow"
ENT.GrenadeAttackAnimationDelay = 0 -- It will wait certain amount of time before playing the animation
ENT.GrenadeAttackAnimationFaceEnemy = true -- Should it face the enemy while playing the grenade attack animation?
ENT.DisableGrenadeAttackAnimation = false -- if true, it will disable the animation code when doing grenade attack
	-- ====== Distance & Chance ====== --
ENT.GrenadeAttackChance = 4 -- 1 in x chance that it will throw a grenade when all the requirements are met | 1 = Throw it every time
ENT.GrenadeAttackThrowDistance = 1500 -- How far it can throw grenades
ENT.GrenadeAttackThrowDistanceClose = 400 -- How close until it stops throwing grenades
	-- ====== Timer ====== --
	-- Set this to false to make the attack event-based:
ENT.TimeUntilGrenadeIsReleased = 0.72 -- Time until the grenade is released
ENT.NextThrowGrenadeTime = VJ.SET(10, 15) -- Time until it can throw a grenade again
	-- To let the base automatically detect the attack duration, set this to false:
ENT.NextAnyAttackTime_Grenade = VJ.SET(false, false) -- How much time until it can use any attack again? | Counted in Seconds
ENT.GrenadeAttackFuseTime = 3 -- The grenade's fuse start time right after the NPC throws it
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Sound ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasSounds = true -- Put to false to disable ALL sounds!
ENT.OnKilledEnemy_OnlyLast = true -- Should it only play the "OnKilledEnemy" sounds if there is no enemies left?
ENT.DamageByPlayerDispositionLevel = 1 -- At which disposition levels it should play the damage by player sounds | 0 = Always | 1 = ONLY when friendly to player | 2 = ONLY when enemy to player
	-- ====== Footstep Sound ====== --
ENT.HasFootStepSound = true -- Can the NPC play footstep sounds?
ENT.DisableFootStepSoundTimer = false -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
ENT.FootStepTimeWalk = 0.5 -- Delay between footstep sounds while it is walking | false = Disable while walking
ENT.FootStepTimeRun = 0.25 -- Delay between footstep sounds while it is running | false = Disable while running
	-- ====== Idle Sound ====== --
ENT.HasIdleSounds = true -- If set to false, it won't play the idle sounds
ENT.IdleSounds_PlayOnAttacks = false -- It will be able to continue and play idle sounds when it performs an attack
ENT.IdleSounds_NoRegularIdleOnAlerted = false -- if set to true, it will not play the regular idle sound table if the combat idle sound table is empty
	-- ====== Idle dialogue Sound ====== --
	-- When an allied NPC or player is within range, it will play these sounds rather than regular idle sounds
	-- If the ally is a VJ NPC and has dialogue answer sounds, it will respond back
ENT.HasIdleDialogueSounds = true -- If set to false, it won't play the idle dialogue sounds
ENT.HasIdleDialogueAnswerSounds = true -- If set to false, it won't play the idle dialogue answer sounds
ENT.IdleDialogueDistance = 400 -- How close should the ally be for the NPC to talk to the it?
ENT.IdleDialogueCanTurn = true -- If set to false, it won't turn when a dialogue occurs
	-- ====== Main Control ====== --
ENT.HasBreathSound = true -- Should it make a breathing sound?
ENT.HasOnReceiveOrderSounds = true -- If set to false, it won't play any sound when it receives an order from an ally
ENT.HasFollowPlayerSounds = true -- Can it play follow and unfollow player sounds?
ENT.HasMoveOutOfPlayersWaySounds = true -- If set to false, it won't play any sounds when it moves out of the player's way
ENT.HasMedicSounds_BeforeHeal = true -- If set to false, it won't play any sounds before it gives a med kit to an ally
ENT.HasMedicSounds_AfterHeal = true -- If set to false, it won't play any sounds after it gives a med kit to an ally
ENT.HasMedicSounds_ReceiveHeal = true -- If set to false, it won't play any sounds when it receives a medkit
ENT.HasOnPlayerSightSounds = true -- If set to false, it won't play the saw player sounds
ENT.HasInvestigateSounds = true -- If set to false, it won't play any sounds when it's investigating something
ENT.HasLostEnemySounds = true -- If set to false, it won't play any sounds when it looses it enemy
ENT.HasAlertSounds = true -- If set to false, it won't play the alert sounds
ENT.HasCallForHelpSounds = true -- If set to false, it won't play any sounds when it calls for help
ENT.HasBecomeEnemyToPlayerSounds = true -- If set to false, it won't play the become enemy to player sounds
ENT.HasSuppressingSounds = true -- If set to false, it won't play any sounds when firing a weapon
ENT.HasWeaponReloadSounds = true -- If set to false, it won't play any sound when reloading
ENT.HasMeleeAttackSounds = true -- If set to false, it won't play the melee attack sound
ENT.HasExtraMeleeAttackSounds = false -- Set to true to use the extra melee attack sounds
ENT.HasMeleeAttackMissSounds = true -- If set to false, it won't play the melee attack miss sound
ENT.HasGrenadeAttackSounds = true -- If set to false, it won't play any sound when doing grenade attack
ENT.HasOnGrenadeSightSounds = true -- If set to false, it won't play any sounds when it sees a grenade
ENT.HasOnDangerSightSounds = true -- If set to false, it won't play any sounds when it detects a danger
ENT.HasOnKilledEnemySound = true -- Should it play a sound when it kills an enemy?
ENT.HasAllyDeathSound = true -- Should it paly a sound when an ally dies?
ENT.HasPainSounds = true -- If set to false, it won't play the pain sounds
ENT.HasImpactSounds = true -- If set to false, it won't play the impact sounds
ENT.HasDamageByPlayerSounds = true -- If set to false, it won't play the damage by player sounds
ENT.HasDeathSounds = true -- If set to false, it won't play the death sounds
ENT.HasSoundTrack = false -- Does the NPC have a sound track?
	-- ====== Sound Paths ====== --
	-- There are 2 types of sounds: "Speech" and "Effect" | Most sound tables are "Speech" unless stated
		-- Speech : Tables that mostly play a talking sound | Will stop when another sound is played (Usually another speech sound)
		-- Effect : Tables that mostly play sound effects | EX: Movement sound, impact sound, attack swipe sound, etc.
ENT.SoundTbl_FootStep = false -- Effect
ENT.SoundTbl_Breath = false -- Effect
ENT.SoundTbl_Idle = false
ENT.SoundTbl_IdleDialogue = false
ENT.SoundTbl_IdleDialogueAnswer = false
ENT.SoundTbl_CombatIdle = false
ENT.SoundTbl_OnReceiveOrder = false
ENT.SoundTbl_FollowPlayer = false
ENT.SoundTbl_UnFollowPlayer = false
ENT.SoundTbl_MoveOutOfPlayersWay = false
ENT.SoundTbl_MedicBeforeHeal = false
ENT.SoundTbl_MedicAfterHeal = false -- Effect
ENT.SoundTbl_MedicReceiveHeal = false
ENT.SoundTbl_OnPlayerSight = false
ENT.SoundTbl_Investigate = false
ENT.SoundTbl_LostEnemy = false
ENT.SoundTbl_Alert = false
ENT.SoundTbl_CallForHelp = false
ENT.SoundTbl_BecomeEnemyToPlayer = false
ENT.SoundTbl_Suppressing = false
ENT.SoundTbl_WeaponReload = false
ENT.SoundTbl_BeforeMeleeAttack = false
ENT.SoundTbl_MeleeAttack = false
ENT.SoundTbl_MeleeAttackExtra = false -- Effect
ENT.SoundTbl_MeleeAttackMiss = false -- Effect
ENT.SoundTbl_GrenadeAttack = false
ENT.SoundTbl_OnGrenadeSight = false
ENT.SoundTbl_OnDangerSight = false
ENT.SoundTbl_OnKilledEnemy = false
ENT.SoundTbl_AllyDeath = false
ENT.SoundTbl_Pain = false
ENT.SoundTbl_Impact = false -- Effect
ENT.SoundTbl_DamageByPlayer = false
ENT.SoundTbl_Death = false
ENT.SoundTbl_SoundTrack = false
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ ///// WARNING: Don't change anything in this box! \\\\\ ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Default sound file paths for certain sound tables | Base will play these if the corresponding table is left empty
local DefaultSoundTbl_FootStep = {"npc/metropolice/gear1.wav", "npc/metropolice/gear2.wav", "npc/metropolice/gear3.wav", "npc/metropolice/gear4.wav", "npc/metropolice/gear5.wav", "npc/metropolice/gear6.wav"}
ENT.DefaultSoundTbl_MeleeAttack = {"physics/body/body_medium_impact_hard1.wav", "physics/body/body_medium_impact_hard2.wav", "physics/body/body_medium_impact_hard3.wav", "physics/body/body_medium_impact_hard4.wav", "physics/body/body_medium_impact_hard5.wav", "physics/body/body_medium_impact_hard6.wav"}
------ ///// WARNING: Don't change anything in this box! \\\\\ ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- ====== Sound Chance ====== --
	-- Higher number = less chance of playing | 1 = Always play
ENT.IdleSoundChance = 3
ENT.IdleDialogueAnswerSoundChance = 1
ENT.CombatIdleSoundChance = 1
ENT.OnReceiveOrderSoundChance = 1
ENT.FollowPlayerSoundChance = 1 -- Controls both "self.SoundTbl_FollowPlayer" and "self.SoundTbl_UnFollowPlayer"
ENT.MoveOutOfPlayersWaySoundChance = 2
ENT.MedicBeforeHealSoundChance = 1
ENT.MedicAfterHealSoundChance = 1
ENT.MedicReceiveHealSoundChance = 1
ENT.OnPlayerSightSoundChance = 1
ENT.InvestigateSoundChance = 1
ENT.LostEnemySoundChance = 1
ENT.AlertSoundChance = 1
ENT.CallForHelpSoundChance = 1
ENT.BecomeEnemyToPlayerChance = 1
ENT.BeforeMeleeAttackSoundChance = 1
ENT.MeleeAttackSoundChance = 1
ENT.ExtraMeleeSoundChance = 1
ENT.MeleeAttackMissSoundChance = 1
ENT.GrenadeAttackSoundChance = 1
ENT.OnGrenadeSightSoundChance = 1
ENT.OnDangerSightSoundChance = 1
ENT.SuppressingSoundChance = 2
ENT.WeaponReloadSoundChance = 1
ENT.OnKilledEnemySoundChance = 1
ENT.AllyDeathSoundChance = 4
ENT.PainSoundChance = 1
ENT.ImpactSoundChance = 1
ENT.DamageByPlayerSoundChance = 1
ENT.DeathSoundChance = 1
ENT.SoundTrackChance = 1
	-- ====== Timer ====== --
	-- Randomized time between the two variables, x amount of time has to pass for the sound to play again | Counted in seconds
	-- false = Base will decide the time
ENT.NextSoundTime_Breath = false
ENT.NextSoundTime_Idle = VJ.SET(8, 25)
ENT.NextSoundTime_Investigate = VJ.SET(5, 5)
ENT.NextSoundTime_LostEnemy = VJ.SET(5, 6)
ENT.NextSoundTime_Alert = VJ.SET(2, 3)
ENT.NextSoundTime_Suppressing = VJ.SET(7, 15)
ENT.NextSoundTime_OnKilledEnemy = VJ.SET(3, 5)
ENT.NextSoundTime_AllyDeath = VJ.SET(3, 5)
	-- ====== Volume ====== --
	-- Number must be between 0 and 1
	-- 0 = No sound, 1 = normal/loudest
ENT.SoundTrackVolume = 1
	-- ====== Sound Level ====== --
	-- The proper number are usually range from 0 to 180, though it can go as high as 511
	-- More Information: https://developer.valvesoftware.com/wiki/Soundscripts#SoundLevel_Flags
ENT.FootStepSoundLevel = 70
ENT.BreathSoundLevel = 60
ENT.IdleSoundLevel = 75
ENT.IdleDialogueSoundLevel = 75
ENT.IdleDialogueAnswerSoundLevel = 75
ENT.CombatIdleSoundLevel = 80
ENT.OnReceiveOrderSoundLevel = 80
ENT.FollowPlayerSoundLevel = 75 -- Controls both "self.SoundTbl_FollowPlayer" and "self.SoundTbl_UnFollowPlayer"
ENT.MoveOutOfPlayersWaySoundLevel = 75
ENT.BeforeHealSoundLevel = 75
ENT.AfterHealSoundLevel = 75
ENT.MedicReceiveHealSoundLevel = 75
ENT.OnPlayerSightSoundLevel = 75
ENT.InvestigateSoundLevel = 80
ENT.LostEnemySoundLevel = 75
ENT.AlertSoundLevel = 80
ENT.CallForHelpSoundLevel = 80
ENT.BecomeEnemyToPlayerSoundLevel = 75
ENT.BeforeMeleeAttackSoundLevel = 75
ENT.MeleeAttackSoundLevel = 75
ENT.ExtraMeleeAttackSoundLevel = 75
ENT.MeleeAttackMissSoundLevel = 75
ENT.SuppressingSoundLevel = 80
ENT.WeaponReloadSoundLevel = 80
ENT.GrenadeAttackSoundLevel = 80
ENT.OnGrenadeSightSoundLevel = 80
ENT.OnDangerSightSoundLevel = 80
ENT.OnKilledEnemySoundLevel = 80
ENT.AllyDeathSoundLevel = 80
ENT.PainSoundLevel = 80
ENT.ImpactSoundLevel = 60
ENT.DamageByPlayerSoundLevel = 75
ENT.DeathSoundLevel = 80
	-- ====== Sound Pitch ====== --
	-- Range: 0 - 255 | Lower pitch < x > Higher pitch
ENT.UseTheSameGeneralSoundPitch = true -- If set to true, the base will decide a number when the NPC spawns and uses it for all sound pitches set to false
	-- It picks the number between these two variables below:
		-- These two variables control any sound pitch variable that is set to false
ENT.GeneralSoundPitch1 = 90
ENT.GeneralSoundPitch2 = 100
	-- To not use the variables above, set the pitch to something other than false
ENT.FootStepPitch = VJ.SET(80, 100)
ENT.BreathSoundPitch = VJ.SET(100, 100)
ENT.IdleSoundPitch = VJ.SET(false, false)
ENT.IdleDialogueSoundPitch = VJ.SET(false, false)
ENT.IdleDialogueAnswerSoundPitch = VJ.SET(false, false)
ENT.CombatIdleSoundPitch = VJ.SET(false, false)
ENT.OnReceiveOrderSoundPitch = VJ.SET(false, false)
ENT.FollowPlayerPitch = VJ.SET(false, false) -- Controls both "self.SoundTbl_FollowPlayer" and "self.SoundTbl_UnFollowPlayer"
ENT.MoveOutOfPlayersWaySoundPitch = VJ.SET(false, false)
ENT.BeforeHealSoundPitch = VJ.SET(false, false)
ENT.AfterHealSoundPitch = VJ.SET(100, 100)
ENT.MedicReceiveHealSoundPitch = VJ.SET(false, false)
ENT.OnPlayerSightSoundPitch = VJ.SET(false, false)
ENT.InvestigateSoundPitch = VJ.SET(false, false)
ENT.LostEnemySoundPitch = VJ.SET(false, false)
ENT.AlertSoundPitch = VJ.SET(false, false)
ENT.CallForHelpSoundPitch = VJ.SET(false, false)
ENT.BecomeEnemyToPlayerPitch = VJ.SET(false, false)
ENT.BeforeMeleeAttackSoundPitch = VJ.SET(false, false)
ENT.MeleeAttackSoundPitch = VJ.SET(95, 100)
ENT.ExtraMeleeSoundPitch = VJ.SET(80, 100)
ENT.MeleeAttackMissSoundPitch = VJ.SET(90, 100)
ENT.SuppressingPitch = VJ.SET(false, false)
ENT.WeaponReloadSoundPitch = VJ.SET(false, false)
ENT.GrenadeAttackSoundPitch = VJ.SET(false, false)
ENT.OnGrenadeSightSoundPitch = VJ.SET(false, false)
ENT.OnDangerSightSoundPitch = VJ.SET(false, false)
ENT.OnKilledEnemySoundPitch = VJ.SET(false, false)
ENT.AllyDeathSoundPitch = VJ.SET(false, false)
ENT.PainSoundPitch = VJ.SET(false, false)
ENT.ImpactSoundPitch = VJ.SET(80, 100)
ENT.DamageByPlayerPitch = VJ.SET(false, false)
ENT.DeathSoundPitch = VJ.SET(false, false)
	-- ====== Playback Rate ====== --
	-- Decides how fast the sound should play
	-- Examples: 1 = normal, 2 = twice the normal speed, 0.5 = half the normal speed
ENT.SoundTrackPlaybackRate = 1
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Customization Functions ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Use the functions below to customize parts of the base or add new systems without overridng major parts of the base
-- Some base functions don't have a extra function because you can simply override the base function and call "self.BaseClass.FuncName(self)" to run the base code as well
--
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	-- Collision bounds of the NPC | NOTE: All 4 Xs and Ys should be the same! | To view: "cl_ent_bbox"
	-- self:SetCollisionBounds(Vector(50, 50, 100), Vector(-50, -50, 0))
	
	-- Damage bounds of the NPC | NOTE: All 4 Xs and Ys should be the same! | To view: "cl_ent_absbox"
	-- self:SetSurroundingBounds(Vector(150, 150, 200), Vector(-150, -150, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThinkActive() end
---------------------------------------------------------------------------------------------------------------------------------------------
-- UNCOMMENT TO USE | Called at the end of every entity it checks every process time
-- NOTE: "calculatedDisp" can in some cases be nil
-- function ENT:OnMaintainRelationships(ent, calculatedDisp, entDist) end
---------------------------------------------------------------------------------------------------------------------------------------------
-- UNCOMMENT TO USE
-- function ENT:OnUpdatePoseParamTracking(pitch, yaw, roll) end
---------------------------------------------------------------------------------------------------------------------------------------------
-- UNCOMMENT TO USE | Called from the engine
-- function ENT:ExpressionFinished(strExp) end
---------------------------------------------------------------------------------------------------------------------------------------------
-- UNCOMMENT TO USE | Called whenever "VJ.CreateSound" or "VJ.EmitSound" is called | return a new file path to replace the one that is about to play
-- function ENT:OnPlaySound(sdFile) return "example/sound.wav" end
---------------------------------------------------------------------------------------------------------------------------------------------
-- UNCOMMENT TO USE | Called whenever a sound starts playing through "VJ.CreateSound"
-- function ENT:OnCreateSound(sdData, sdFile) end
---------------------------------------------------------------------------------------------------------------------------------------------
-- UNCOMMENT TO USE | Called whenever a sound starts playing through "VJ.EmitSound"
-- function ENT:OnEmitSound(sdFile) end
---------------------------------------------------------------------------------------------------------------------------------------------
-- UNCOMMENT TO USE | Called every time "self:FireBullets" is called
-- function ENT:OnFireBullet(data) end
---------------------------------------------------------------------------------------------------------------------------------------------
-- UNCOMMENT TO USE | Called whenever something collides with the NPC
-- function ENT:OnTouch(ent) end
---------------------------------------------------------------------------------------------------------------------------------------------
-- UNCOMMENT TO USE | Called from the engine
-- function ENT:OnCondition(cond) VJ.DEBUG_Print(self, "OnCondition", cond, " = ", self:ConditionName(cond)) end
---------------------------------------------------------------------------------------------------------------------------------------------
-- UNCOMMENT TO USE
-- function ENT:OnInput(key, activator, caller, data) VJ.DEBUG_Print(self, "OnInput", key, activator, caller, data) end
---------------------------------------------------------------------------------------------------------------------------------------------
-- UNCOMMENT TO USE
-- local getEventName = util.GetAnimEventNameByID
-- --
-- function ENT:OnAnimEvent(ev, evTime, evCycle, evType, evOptions)
-- 	local eventName = getEventName(ev)
-- 	VJ.DEBUG_Print(self, "OnAnimEvent", eventName, ev, evTime, evCycle, evType, evOptions)
-- end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Called whenever the NPC begins following or stops following an entity
		- status = Type of call:
			- "Start"	= NPC is now following the given entity
			- "Stop"	= NPC is now unfollowing the given entity
		- ent = The entity that the NPC is now following or unfollowing
-----------------------------------------------------------]]
function ENT:OnFollow(status, ent) end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Called every time a change occurs in the eating system
		- ent = The entity that it is checking OR speaking with
		- status = The change that occurred, possible changes:
			- "CheckEnt"	= Possible friendly entity found, should we speak to it? | return anything other than true to skip and not speak to this entity!
			- "Speak"		= Everything passed, start speaking
			- "Answer"		= Another entity has spoken to me, answer back! | return anything other than true to not play an answer back dialogue!
		- statusData = Some status may have extra info, possible infos:
			- For "CheckEnt"	= Boolean value, whether or not the entity can answer back
			- For "Speak"		= Duration of our sentence
	Returns
		- ONLY used for "CheckEnt" & "Answer" | Check above for what each status return does
-----------------------------------------------------------]]
function ENT:OnIdleDialogue(ent, status, statusData) end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[
Called whenever the medic behavior updates

=-=-=| PARAMETERS |=-=-=
	1. status [string] : Type of update that is occurring, holds one of the following states:
		-> "BeforeHeal" : Right before it's about to heal an entity
				USAGE EXAMPLES -> Play chain of animations | Additional sound effect
				PARAMETERS
					2. statusData [nil]
				RETURNS
					-> [nil]
		-> "OnHeal" : When the timer expires and is about to give health
				USAGE EXAMPLES -> Override healing code | Play an after heal animation
				PARAMETERS
					2. statusData [entity] : The entity that it's about to heal
				RETURNS
					-> [bool] : Returning false will NOT update entity's health and will NOT clear its decals (Useful for custom code)
		-> "OnReset" : When the behavior ends OR has to move because entity moved
				USAGE EXAMPLES -> Cleanup bodygroups | Play a sound
				PARAMETERS
					2. statusData [string] : Holds one of the following states:
						--> "Retry" : When it attempts to retry healing the entity, such as when the entity moved away so it has to chase again
						--> "End" : When the medic behavior exits completely
				RETURNS
					-> [nil]
	2. statusData [nil | entity | string] : Depends on `status` value, refer to it for more details

=-=-=| RETURNS |=-=-=
	-> [nil | bool] : Depends on `status` value, refer to it for more details
--]]
function ENT:OnMedicBehavior(status, statusData) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPlayerSight(ent) end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	UNCOMMENT TO USE | Called every time footstep sound plays
		- moveType = Type of movement | Types: "Walk", "Run", "Event"
		- sdFile = Sound that it just played
-----------------------------------------------------------]]
-- function ENT:OnFootstepSound(moveType, sdFile) end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	UNCOMMENT TO USE | Called when the NPC detects a danger
		- dangerType = Type of danger detected | Enum: VJ.NPC_DANGER_TYPE_*
		- data = Danger / grenade entity for types "DANGER_TYPE_ENTITY" and "DANGER_TYPE_GRENADE"
			-- Currently empty for danger type "DANGER_TYPE_HINT"
-----------------------------------------------------------]]
-- function ENT:OnDangerDetected(dangerType, data) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInvestigate(ent) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnResetEnemy() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAlert(ent) end
---------------------------------------------------------------------------------------------------------------------------------------------
-- "ally" = Ally that we called for help
-- "isFirst" = Is this the first ally that received this call? Use this to avoid running certain multiple times when many allies are around!
function ENT:OnCallForHelp(ally, isFirst) end
---------------------------------------------------------------------------------------------------------------------------------------------
-- UNCOMMENT TO USE | Use this to create a completely new attack system!
-- function ENT:CustomAttack(ene, eneVisible) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_BeforeStartTimer(seed) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_AfterStartTimer(seed) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_BeforeChecks() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetMeleeAttackDamageOrigin()
	return (IsValid(self:GetEnemy()) and VJ.GetNearestPositions(self, self:GetEnemy(), true)) or self:GetPos() + self:GetForward() -- Override this to use a different position
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_AfterChecks(hitEnt, isProp) end -- return `true` to disable the attack and move onto the next entity!
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MeleeAttackKnockbackVelocity(hitEnt)
	return self:GetForward() * math.random(100, 140) + self:GetUp() * 10
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_Miss() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnWeaponChange(newWeapon, oldWeapon, invSwitch) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnWeaponCanFire() end -- Return false to disallow firing the weapon
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnWeaponAttack() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnWeaponStrafeWhileFiring() end -- Return false to disable default behavior, delay will still apply!
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnWeaponReload() end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[
Called for important changes or requests during a grenade attack

=-=-=| PARAMETERS |=-=-=
	1. status [string] : Type of update that is occurring, holds one of the following states:
		-> "Start" : Before the start timer is ran
			USAGE EXAMPLES -> Change grenade attack sounds | Make changes to "self.TimeUntilGrenadeIsReleased"
			RETURNS
				-> [nil]
		-> "SpawnPos" : When the spawn position is requested
			USAGE EXAMPLES -> Override the spawn position if needed by returning a vector
			RETURNS
				-> [nil] : Do NOT override the spawn position, this lets the default code execute
				-> [vector] : Override the spawn position
		-> "Throw" : When the grenade is being thrown
			USAGE EXAMPLES -> Throw velocity | Apply changes to grenade entity | Disallow throw velocity
			RETURNS
				-> [nil] : Do NOT apply any velocity to the grenade
				-> [vector] : Velocity that will be applied to the grenade
	2. grenade [nil | entity] : The actual grenade entity that is being thrown | NOTE: Only valid for "Throw" status
	3. customEnt [nil | string | entity] : What entity it should throw (IF any)
		-> [nil] : Using the default grenade class set by "self.GrenadeAttackEntity"
		-> [string] : Using the given class name to override "self.GrenadeAttackEntity"
		-> [entity] : Using an existing entity to override "self.GrenadeAttackEntity" | Example: When the NPC is throwing back an enemy grenade
	4. landDir [number | vector | bool] : Direction the grenade should land, used to align where the grenade should land
		-> 0 : Use enemy's position
		-> 1 : Use enemy's last visible position
		-> [vector] : Use given vector
		-> [bool] : Find the best random position
	5. landingPos [nil | vector] : The position the grenade is aimed to land | NOTE: Only valid for "Throw" status

=-=-=| RETURNS |=-=-=
	-> [nil | vector] : Depends on `status` value, refer to it for more details
--]]
function ENT:OnGrenadeAttack(status, grenade, customEnt, landDir, landingPos)
	if status == "Throw" then
		return (landingPos - grenade:GetPos()) + (self:GetUp()*200 + self:GetForward()*500 + self:GetRight()*math.Rand(-20, 20))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnKilledEnemy(ent, inflictor, wasLast) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAllyKilled(ent) end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[
 Called whenever the NPC takes damage

=-=-=| PARAMETERS |=-=-=
	1. dmginfo [object] = CTakeDamageInfo object
	2. hitgroup [number] = The hitgroup that it hit
	3. status [string] : Type of update that is occurring, holds one of the following states:
		-> "Initial" : First call on take damage, even before immune checks
		-> "PreDamage" : Right before the damage is applied to the NPC
		-> "PostDamage" : Right after the damage is applied to the NPC
--]]
function ENT:OnDamaged(dmginfo, hitgroup, status) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnBleed(dmginfo, hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[
 Called whenever the NPC attempts to play flinch

=-=-=| PARAMETERS |=-=-=
	1. dmginfo [object] = CTakeDamageInfo object
	2. hitgroup [number] = The hitgroup that it hit
	3. status [string] : Type of update that is occurring, holds one of the following states:
		-> "PriorExecution" : Before the animation is played or any values are set
				USAGE EXAMPLES -> Disallow flinch | Override the animation | Add a extra check
				RETURNS
					-> [nil | bool] : Return true to disallow the flinch from playing
		-> "Execute" : Right after the flinch animation starts playing and all the values are set
				RETURNS
					-> [nil]

=-=-=| RETURNS |=-=-=
	-> [nil | bool] : Depends on `status` value, refer to it for more details
--]]
function ENT:OnFlinch(dmginfo, hitgroup, status) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnBecomeEnemyToPlayer(dmginfo, hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSetEnemyFromDamage(dmginfo, hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[
 Called on death when the NPC is supposed to gib

=-=-=| PARAMETERS |=-=-=
	1. dmginfo [object] = CTakeDamageInfo object
	2. hitgroup [number] = The hitgroup that it hit

=-=-=| RETURNS |=-=-=
	-> [bool] : Notifies the base if the NPC gibbed or not
		- false : Spawns death corpse | Plays death animations | Does NOT play gib sounds
		- true : Disallows death corpse | Disallows death animations | Plays gib sounds
	-> [nil | table] : Overrides default actions, first return must be "true" for this to apply!
		- AllowCorpse : Allows death corpse to spawn | DEFAULT: false
		- AllowAnim : Allows death animations to play | DEFAULT: false
		- AllowSound : Allows default gib sounds to play | DEFAULT: true
		EXAMPLE:
			- {AllowCorpse = true} : Will spawn death corpse
--]]
function ENT:HandleGibOnDeath(dmginfo, hitgroup) return false end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[
 Called when the NPC dies

=-=-=| PARAMETERS |=-=-=
	1. dmginfo [object] = CTakeDamageInfo object
	2. hitgroup [number] = The hitgroup that it hit
	3. status [string] : Type of update that is occurring, holds one of the following states:
		-> "Initial" : First call when it dies before anything is changed or reset
		-> "DeathAnim" : Right before the death animation plays
		-> "Finish" : Right before the corpse is spawned, the active weapon is dropped and the NPC is removed
--]]
function ENT:OnDeath(dmginfo, hitgroup, status) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeathWeaponDrop(dmginfo, hitgroup, wepEnt) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpseEnt) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt)
	//ply:ChatPrint("CTRL + MOUSE2: Rocket Attack") -- Example key binding message
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetAnimationTranslations(wepHoldType)
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	------ Combine ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	if self.AnimModelSet == VJ.ANIM_SET_COMBINE then
		if !self.Weapon_AimTurnDiff then self.Weapon_AimTurnDiff_Def = 0.71120220422745 end
		
		self.AnimationTranslations[ACT_COVER_LOW] 					= {ACT_COVER, "vjseq_Leanwall_CrouchLeft_A_idle", "vjseq_Leanwall_CrouchLeft_B_idle", "vjseq_Leanwall_CrouchLeft_C_idle", "vjseq_Leanwall_CrouchLeft_D_idle"}
		//self.AnimationTranslations[ACT_RELOAD] 					= ACT_RELOAD_SMG1 -- No need to translate, it's already the correct animation
		//self.AnimationTranslations[ACT_RELOAD_LOW] 				= ACT_RELOAD_SMG1_LOW -- No need to translate, it's already the correct animation
		
		self.AnimationTranslations[ACT_WALK_CROUCH] 				= ACT_WALK_CROUCH_RIFLE
		self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= ACT_WALK_CROUCH_AIM_RIFLE
		
		self.AnimationTranslations[ACT_RUN] 						= ACT_RUN_RIFLE
		self.AnimationTranslations[ACT_RUN_AGITATED] 				= ACT_RUN_RIFLE
		self.AnimationTranslations[ACT_RUN_PROTECTED] 				= ACT_RUN_CROUCH_RIFLE
		self.AnimationTranslations[ACT_RUN_CROUCH] 					= ACT_RUN_CROUCH_RIFLE
		self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_RUN_CROUCH_AIM_RIFLE
		
		if wepHoldType == "ar2" or wepHoldType == "smg" or wepHoldType == "rpg" then
			if wepHoldType == "ar2" then
				self.AnimationTranslations[ACT_RANGE_ATTACK1] 			= ACT_RANGE_ATTACK_AR2
				self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 	= ACT_GESTURE_RANGE_ATTACK_AR2
				self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 		= ACT_RANGE_ATTACK_AR2_LOW
				//self.AnimationTranslations[ACT_IDLE_ANGRY] 			= ACT_IDLE_ANGRY -- No need to translate, it's already the correct animation
			elseif wepHoldType == "smg" or wepHoldType == "rpg" then
				self.AnimationTranslations[ACT_RANGE_ATTACK1] 			= ACT_RANGE_ATTACK_SMG1
				self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 	= ACT_GESTURE_RANGE_ATTACK_SMG1
				self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 		= ACT_RANGE_ATTACK_SMG1_LOW
				self.AnimationTranslations[ACT_IDLE_ANGRY] 				= ACT_IDLE_ANGRY_SMG1
			end
			
			self.AnimationTranslations[ACT_IDLE] 						= ACT_IDLE_SMG1
			
			self.AnimationTranslations[ACT_WALK] 						= VJ.SequenceToActivity(self, "walkeasy_all")
			self.AnimationTranslations[ACT_WALK_AGITATED] 				= ACT_WALK_RIFLE
			self.AnimationTranslations[ACT_WALK_AIM] 					= ACT_WALK_AIM_RIFLE
			
			self.AnimationTranslations[ACT_RUN_AIM] 					= ACT_RUN_AIM_RIFLE
		elseif wepHoldType == "pistol" or wepHoldType == "revolver" then
			self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= ACT_RANGE_ATTACK_AR2
			self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_GESTURE_RANGE_ATTACK_AR2
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_RANGE_ATTACK_AR2_LOW
			
			self.AnimationTranslations[ACT_IDLE] 						= VJ.SequenceToActivity(self, "idle_unarmed")
			//self.AnimationTranslations[ACT_IDLE_ANGRY] 				= ACT_IDLE_ANGRY -- No need to translate, it's already the correct animation
			
			self.AnimationTranslations[ACT_WALK] 						= VJ.SequenceToActivity(self, "walkunarmed_all")
			//self.AnimationTranslations[ACT_WALK_AGITATED] 			= ACT_WALK_RIFLE -- No need uses same as ACT_WALK
			self.AnimationTranslations[ACT_WALK_AIM] 					= ACT_WALK_AIM_RIFLE
			
			self.AnimationTranslations[ACT_RUN_AIM] 					= ACT_RUN_AIM_RIFLE
		elseif wepHoldType == "crossbow" or wepHoldType == "shotgun" then
			self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= ACT_RANGE_ATTACK_SHOTGUN
			self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= wepHoldType == "crossbow" and ACT_GESTURE_RANGE_ATTACK_AR2 or ACT_GESTURE_RANGE_ATTACK_SHOTGUN
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_RANGE_ATTACK_SHOTGUN_LOW
			
			self.AnimationTranslations[ACT_IDLE] 						= ACT_IDLE_SMG1
			self.AnimationTranslations[ACT_IDLE_ANGRY] 					= ACT_IDLE_ANGRY_SHOTGUN
			
			self.AnimationTranslations[ACT_WALK] 						= ACT_WALK_AIM_SHOTGUN
			//self.AnimationTranslations[ACT_WALK_AGITATED] 			= ACT_WALK_AIM_SHOTGUN -- No need uses same as ACT_WALK
			self.AnimationTranslations[ACT_WALK_AIM] 					= ACT_WALK_AIM_SHOTGUN
			
			self.AnimationTranslations[ACT_RUN_AIM] 					= ACT_RUN_AIM_SHOTGUN
		elseif wepHoldType == "melee" or wepHoldType == "melee2" or wepHoldType == "knife" then
			self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= ACT_MELEE_ATTACK1
			self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= false -- Don't play anything for melee!
			//self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 		= ACT_RANGE_ATTACK_SMG1_LOW -- Not used for melee
			
			self.AnimationTranslations[ACT_IDLE] 						= VJ.SequenceToActivity(self, "idle_unarmed")
			self.AnimationTranslations[ACT_IDLE_ANGRY] 					= VJ.SequenceToActivity(self, "idle_unarmed")
			
			self.AnimationTranslations[ACT_WALK] 						= VJ.SequenceToActivity(self, "walkunarmed_all")
			//self.AnimationTranslations[ACT_WALK_AGITATED] 			= ACT_WALK_AIM_SHOTGUN -- No need uses same as ACT_WALK
			self.AnimationTranslations[ACT_WALK_AIM] 					= ACT_WALK_AIM_RIFLE
			
			self.AnimationTranslations[ACT_RUN_AIM] 					= ACT_RUN_AIM_RIFLE
		else -- Unarmed!
			self.AnimationTranslations[ACT_IDLE] 						= VJ.SequenceToActivity(self, "idle_unarmed")
			self.AnimationTranslations[ACT_WALK] 						= VJ.SequenceToActivity(self, "walkunarmed_all")
			//self.AnimationTranslations[ACT_WALK_AGITATED] 			= ACT_WALK_AIM_SHOTGUN -- No need uses same as ACT_WALK
		end
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	------ Metrocop ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	elseif self.AnimModelSet == VJ.ANIM_SET_METROCOP then
		if !self.Weapon_AimTurnDiff then self.Weapon_AimTurnDiff_Def = 0.71120220422745 end
		
		-- Do not translate crouch walking and also make the crouch running a walking one instead
		self.AnimationTranslations[ACT_RUN_CROUCH] 						= ACT_WALK_CROUCH
		
		if wepHoldType == "smg" or wepHoldType == "rpg" or wepHoldType == "ar2" or wepHoldType == "crossbow" or wepHoldType == "shotgun" then
			-- Note: Metrocops must use smg animation, they don't have any animations for AR2!
			self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= ACT_RANGE_ATTACK_SMG1
			self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_GESTURE_RANGE_ATTACK_SMG1
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_RANGE_ATTACK_SMG1_LOW
			self.AnimationTranslations[ACT_RELOAD] 						= ACT_RELOAD_SMG1
			self.AnimationTranslations[ACT_COVER_LOW] 					= ACT_COVER_SMG1_LOW
			self.AnimationTranslations[ACT_RELOAD_LOW] 					= ACT_RELOAD_SMG1_LOW
			
			self.AnimationTranslations[ACT_IDLE] 						= ACT_IDLE_SMG1
			self.AnimationTranslations[ACT_IDLE_ANGRY] 					= ACT_IDLE_ANGRY_SMG1
			
			self.AnimationTranslations[ACT_WALK] 						= ACT_WALK_RIFLE
			//self.AnimationTranslations[ACT_WALK_AGITATED] 			= ACT_WALK_RIFLE -- No need uses same as ACT_WALK
			self.AnimationTranslations[ACT_WALK_AIM] 					= ACT_WALK_AIM_RIFLE
			self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= ACT_WALK_CROUCH_AIM_RIFLE
			
			self.AnimationTranslations[ACT_RUN] 						= ACT_RUN_RIFLE
			//self.AnimationTranslations[ACT_RUN_AGITATED] 				= ACT_RUN_RIFLE -- No need uses same as ACT_RUN
			self.AnimationTranslations[ACT_RUN_AIM] 					= ACT_RUN_AIM_RIFLE
			self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_RUN_CROUCH_AIM_RIFLE
		elseif wepHoldType == "pistol" or wepHoldType == "revolver" then
			self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= ACT_RANGE_ATTACK_PISTOL
			self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_GESTURE_RANGE_ATTACK_PISTOL
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_RANGE_ATTACK_PISTOL_LOW
			self.AnimationTranslations[ACT_COVER_LOW] 					= ACT_COVER_PISTOL_LOW
			self.AnimationTranslations[ACT_RELOAD] 						= ACT_RELOAD_PISTOL
			self.AnimationTranslations[ACT_RELOAD_LOW] 					= ACT_RELOAD_PISTOL_LOW
			
			self.AnimationTranslations[ACT_IDLE] 						= ACT_IDLE_PISTOL
			self.AnimationTranslations[ACT_IDLE_ANGRY] 					= ACT_IDLE_ANGRY_PISTOL
			
			//self.AnimationTranslations[ACT_WALK] 						= ACT_WALK -- No need to translate
			self.AnimationTranslations[ACT_WALK_AGITATED] 				= ACT_WALK_PISTOL
			self.AnimationTranslations[ACT_WALK_AIM] 					= ACT_WALK_AIM_PISTOL
			//self.AnimationTranslations[ACT_WALK_CROUCH] 				= ACT_WALK_CROUCH_RIFLE -- No need to translate
			self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= ACT_WALK_CROUCH_AIM_RIFLE
			
			//self.AnimationTranslations[ACT_RUN] 						= ACT_RUN -- No need to translate
			self.AnimationTranslations[ACT_RUN_AGITATED] 				= ACT_RUN_PISTOL
			self.AnimationTranslations[ACT_RUN_AIM] 					= ACT_RUN_AIM_PISTOL
			//self.AnimationTranslations[ACT_RUN_CROUCH] 				= ACT_RUN_CROUCH_RIFLE -- No need to translate
			self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_RUN_CROUCH_AIM_RIFLE
		elseif wepHoldType == "melee" or wepHoldType == "melee2" or wepHoldType == "knife" then
			self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= ACT_MELEE_ATTACK_SWING
			self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= false //ACT_MELEE_ATTACK_SWING_GESTURE -- Don't play anything!
			//self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 		= ACT_RANGE_ATTACK_SMG1_LOW -- Not used for melee
			self.AnimationTranslations[ACT_COVER_LOW] 					= ACT_COWER
			//self.AnimationTranslations[ACT_RELOAD] 					= ACT_RELOAD_SMG1 -- Not used for melee
			//self.AnimationTranslations[ACT_RELOAD_LOW] 				= ACT_RELOAD_SMG1_LOW -- Not used for melee
			
			self.AnimationTranslations[ACT_IDLE] 						= {ACT_IDLE, ACT_IDLE, ACT_IDLE, ACT_IDLE, VJ.SequenceToActivity(self, "plazathreat1")}
			self.AnimationTranslations[ACT_IDLE_ANGRY] 					= ACT_IDLE_ANGRY_MELEE
			
			//self.AnimationTranslations[ACT_WALK] 						= ACT_WALK -- No need to translate
			self.AnimationTranslations[ACT_WALK_AGITATED] 				= ACT_WALK_ANGRY
			//self.AnimationTranslations[ACT_WALK_AIM] 					= ACT_WALK_AIM_RIFLE -- Not used for melee
			//self.AnimationTranslations[ACT_WALK_CROUCH] 				= ACT_WALK_CROUCH_RIFLE -- No need to translate
			//self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= ACT_WALK_CROUCH_AIM_RIFLE -- Not used for melee
			
			//self.AnimationTranslations[ACT_RUN] 						= ACT_RUN -- No need to translate
			//self.AnimationTranslations[ACT_RUN_AGITATED] 				= ACT_RUN -- No need to translate
			//self.AnimationTranslations[ACT_RUN_AIM] 					= ACT_RUN_AIM_RIFLE -- Not used for melee
			//self.AnimationTranslations[ACT_RUN_CROUCH] 				= ACT_RUN_CROUCH_RIFLE -- No need to translate
			//self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 			= ACT_RUN_CROUCH_AIM_RIFLE -- Not used for melee
		end
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	------ Rebel / Citizen ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	elseif self.AnimModelSet == VJ.ANIM_SET_REBEL then
		local isFemale = VJ.AnimExists(self, ACT_IDLE_ANGRY_PISTOL)
		if !self.Weapon_AimTurnDiff then self.Weapon_AimTurnDiff_Def = 0.78187280893326 end
		
		-- Handguns use a different set!
		self.AnimationTranslations[ACT_COVER_LOW] 						= {ACT_COVER_LOW_RPG, ACT_COVER_LOW, "vjseq_coverlow_l", "vjseq_coverlow_r"}
		
		if wepHoldType == "ar2" then
			self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= ACT_RANGE_ATTACK_AR2
			self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_GESTURE_RANGE_ATTACK_AR2
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_RANGE_ATTACK_AR2_LOW
			self.AnimationTranslations[ACT_RELOAD] 						= VJ.SequenceToActivity(self, "reload_ar2")
			self.AnimationTranslations[ACT_RELOAD_LOW] 					= ACT_RELOAD_SMG1_LOW
			
			self.AnimationTranslations[ACT_IDLE] 						= PICK({VJ.SequenceToActivity(self, "idle_relaxed_ar2_1"), VJ.SequenceToActivity(self, "idle_alert_ar2_1"), VJ.SequenceToActivity(self, "idle_angry_ar2")})
			self.AnimationTranslations[ACT_IDLE_ANGRY] 					= VJ.SequenceToActivity(self, "idle_ar2_aim")
			
			self.AnimationTranslations[ACT_WALK] 						= PICK({VJ.SequenceToActivity(self, "walk_ar2_relaxed_all"), VJ.SequenceToActivity(self, "walkalerthold_ar2_all1"), VJ.SequenceToActivity(self, "walkholdall1_ar2")})
			self.AnimationTranslations[ACT_WALK_AGITATED] 				= VJ.SequenceToActivity(self, "walkalerthold_ar2_all1")
			self.AnimationTranslations[ACT_WALK_AIM] 					= PICK({VJ.SequenceToActivity(self, "walkaimall1_ar2"), VJ.SequenceToActivity(self, "walkalertaim_ar2_all1")})
			self.AnimationTranslations[ACT_WALK_CROUCH] 				= ACT_WALK_CROUCH_RPG
			self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= ACT_WALK_CROUCH_AIM_RIFLE
			
			self.AnimationTranslations[ACT_RUN] 						= PICK({VJ.SequenceToActivity(self, "run_alert_holding_ar2_all"), VJ.SequenceToActivity(self, "run_ar2_relaxed_all"), VJ.SequenceToActivity(self, "run_holding_ar2_all")})
			self.AnimationTranslations[ACT_RUN_AGITATED] 				= PICK({VJ.SequenceToActivity(self, "run_alert_holding_ar2_all"), VJ.SequenceToActivity(self, "run_holding_ar2_all")})
			self.AnimationTranslations[ACT_RUN_AIM] 					= PICK({ACT_RUN_AIM_RIFLE, VJ.SequenceToActivity(self, "run_alert_aiming_ar2_all")})
			self.AnimationTranslations[ACT_RUN_CROUCH] 					= ACT_RUN_CROUCH_RPG
			self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_RUN_CROUCH_AIM_RIFLE
		elseif wepHoldType == "smg" then
			self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= ACT_RANGE_ATTACK_SMG1
			self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_GESTURE_RANGE_ATTACK_SMG1
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_RANGE_ATTACK_SMG1_LOW
			self.AnimationTranslations[ACT_RELOAD] 						= ACT_RELOAD_SMG1
			self.AnimationTranslations[ACT_RELOAD_LOW] 					= ACT_RELOAD_SMG1_LOW
			
			self.AnimationTranslations[ACT_IDLE] 						= PICK({ACT_IDLE_SMG1_RELAXED, ACT_IDLE_SMG1_STIMULATED, ACT_IDLE_SMG1, VJ.SequenceToActivity(self, "idle_smg1_relaxed")})
			self.AnimationTranslations[ACT_IDLE_ANGRY] 					= ACT_IDLE_ANGRY_SMG1
			
			self.AnimationTranslations[ACT_WALK] 						= PICK({ACT_WALK_RIFLE_RELAXED, ACT_WALK_RIFLE_STIMULATED})
			self.AnimationTranslations[ACT_WALK_AGITATED] 				= ACT_WALK_RIFLE
			self.AnimationTranslations[ACT_WALK_AIM] 					= PICK({ACT_WALK_AIM_RIFLE, ACT_WALK_AIM_RIFLE_STIMULATED})
			self.AnimationTranslations[ACT_WALK_CROUCH] 				= ACT_WALK_CROUCH_RIFLE
			self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= ACT_WALK_CROUCH_AIM_RIFLE
			
			self.AnimationTranslations[ACT_RUN] 						= PICK({ACT_RUN_RIFLE, ACT_RUN_RIFLE_STIMULATED, ACT_RUN_RIFLE_RELAXED})
			self.AnimationTranslations[ACT_RUN_AGITATED] 				= PICK({ACT_RUN_RIFLE, ACT_RUN_RIFLE_STIMULATED})
			self.AnimationTranslations[ACT_RUN_AIM] 					= PICK({ACT_RUN_AIM_RIFLE, ACT_RUN_AIM_RIFLE_STIMULATED})
			self.AnimationTranslations[ACT_RUN_CROUCH] 					= ACT_RUN_CROUCH_RIFLE
			self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_RUN_CROUCH_AIM_RIFLE
		elseif wepHoldType == "crossbow" or wepHoldType == "shotgun" then
			self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= ACT_RANGE_ATTACK_SHOTGUN
			self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_GESTURE_RANGE_ATTACK_SHOTGUN
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_RANGE_ATTACK_SMG1_LOW
			self.AnimationTranslations[ACT_RELOAD] 						= ACT_RELOAD_SHOTGUN
			self.AnimationTranslations[ACT_RELOAD_LOW] 					= ACT_RELOAD_SMG1_LOW //ACT_RELOAD_SHOTGUN_LOW
			
			self.AnimationTranslations[ACT_IDLE] 						= PICK({ACT_IDLE_SHOTGUN_RELAXED, ACT_IDLE_SHOTGUN_STIMULATED})
			self.AnimationTranslations[ACT_IDLE_ANGRY] 					= VJ.SequenceToActivity(self, "idle_ar2_aim")
			
			self.AnimationTranslations[ACT_WALK] 						= PICK({VJ.SequenceToActivity(self, "walk_ar2_relaxed_all"), VJ.SequenceToActivity(self, "walkalerthold_ar2_all1"), VJ.SequenceToActivity(self, "walkholdall1_ar2")})
			self.AnimationTranslations[ACT_WALK_AGITATED] 				= VJ.SequenceToActivity(self, "walkalerthold_ar2_all1")
			self.AnimationTranslations[ACT_WALK_AIM] 					= PICK({VJ.SequenceToActivity(self, "walkaimall1_ar2"), VJ.SequenceToActivity(self, "walkalertaim_ar2_all1")})
			self.AnimationTranslations[ACT_WALK_CROUCH] 				= ACT_WALK_CROUCH_RPG
			self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= ACT_WALK_CROUCH_AIM_RIFLE
			
			self.AnimationTranslations[ACT_RUN] 						= PICK({VJ.SequenceToActivity(self, "run_alert_holding_ar2_all"), VJ.SequenceToActivity(self, "run_ar2_relaxed_all"), VJ.SequenceToActivity(self, "run_holding_ar2_all")})
			self.AnimationTranslations[ACT_RUN_AGITATED] 				= PICK({VJ.SequenceToActivity(self, "run_alert_holding_ar2_all"), VJ.SequenceToActivity(self, "run_holding_ar2_all")})
			self.AnimationTranslations[ACT_RUN_AIM] 					= PICK({ACT_RUN_AIM_RIFLE, VJ.SequenceToActivity(self, "run_alert_aiming_ar2_all")})
			self.AnimationTranslations[ACT_RUN_CROUCH] 					= ACT_RUN_CROUCH_RPG
			self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_RUN_CROUCH_AIM_RIFLE
		elseif wepHoldType == "rpg" then
			self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= ACT_RANGE_ATTACK_RPG
			self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_GESTURE_RANGE_ATTACK_RPG
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_RANGE_ATTACK_SMG1_LOW
			self.AnimationTranslations[ACT_RELOAD] 						= ACT_RELOAD_SMG1
			self.AnimationTranslations[ACT_RELOAD_LOW] 					= ACT_RELOAD_SMG1_LOW
			
			self.AnimationTranslations[ACT_IDLE] 						= PICK({ACT_IDLE_RPG, ACT_IDLE_RPG_RELAXED})
			self.AnimationTranslations[ACT_IDLE_ANGRY] 					= ACT_IDLE_ANGRY_RPG
			
			self.AnimationTranslations[ACT_WALK] 						= PICK({ACT_WALK_RPG, ACT_WALK_RPG_RELAXED})
			self.AnimationTranslations[ACT_WALK_AGITATED] 				= ACT_WALK_RPG
			self.AnimationTranslations[ACT_WALK_AIM] 					= PICK({VJ.SequenceToActivity(self, "walkaimall1_ar2"), VJ.SequenceToActivity(self, "walkalertaim_ar2_all1")})
			self.AnimationTranslations[ACT_WALK_CROUCH] 				= ACT_WALK_CROUCH_RPG
			self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= ACT_WALK_CROUCH_AIM_RIFLE
			
			self.AnimationTranslations[ACT_RUN] 						= PICK({ACT_RUN_RPG, ACT_RUN_RPG_RELAXED})
			self.AnimationTranslations[ACT_RUN_AGITATED] 				= ACT_RUN_RPG
			self.AnimationTranslations[ACT_RUN_AIM] 					= PICK({ACT_RUN_AIM_RIFLE, VJ.SequenceToActivity(self, "run_alert_aiming_ar2_all")})
			self.AnimationTranslations[ACT_RUN_CROUCH] 					= ACT_RUN_CROUCH_RPG
			self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_RUN_CROUCH_AIM_RIFLE
		elseif wepHoldType == "pistol" or wepHoldType == "revolver" then
			self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= ACT_RANGE_ATTACK_PISTOL
			self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_GESTURE_RANGE_ATTACK_PISTOL
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_RANGE_ATTACK_PISTOL_LOW
			self.AnimationTranslations[ACT_COVER_LOW] 					= {"crouchidle_panicked4", "vjseq_crouchidlehide"}
			self.AnimationTranslations[ACT_RELOAD] 						= ACT_RELOAD_PISTOL
			self.AnimationTranslations[ACT_RELOAD_LOW] 					= isFemale and ACT_RELOAD_SMG1_LOW or ACT_RELOAD_PISTOL_LOW -- Only males have covered pistol reload
			
			self.AnimationTranslations[ACT_IDLE] 						= isFemale and ACT_IDLE_PISTOL or ACT_IDLE -- Only females have pistol idle animation
			self.AnimationTranslations[ACT_IDLE_ANGRY] 					= isFemale and ACT_IDLE_ANGRY_PISTOL or VJ.SequenceToActivity(self, "idle_ar2_aim") -- Only females have angry pistol animation
			
			//self.AnimationTranslations[ACT_WALK] 						= ACT_WALK -- No need to translate
			//self.AnimationTranslations[ACT_WALK_AGITATED] 			= ACT_WALK -- No need, same as ACT_WALK
			self.AnimationTranslations[ACT_WALK_AIM] 					= isFemale and ACT_WALK_AIM_PISTOL or PICK({VJ.SequenceToActivity(self, "walkaimall1_ar2"), VJ.SequenceToActivity(self, "walkalertaim_ar2_all1")})
			//self.AnimationTranslations[ACT_WALK_CROUCH] 				= ACT_WALK_CROUCH_RIFLE -- No need to translate
			self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= ACT_WALK_CROUCH_AIM_RIFLE
			
			//self.AnimationTranslations[ACT_RUN] 						= ACT_RUN -- No need to translate
			//self.AnimationTranslations[ACT_RUN_AGITATED] 				= ACT_RUN -- No need, same as ACT_RUN
			self.AnimationTranslations[ACT_RUN_AIM] 					= isFemale and ACT_RUN_AIM_PISTOL or VJ.SequenceToActivity(self, "run_alert_aiming_ar2_all")
			//self.AnimationTranslations[ACT_RUN_CROUCH] 				= ACT_RUN_CROUCH_RIFLE -- No need to translate
			self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_RUN_CROUCH_AIM_RIFLE
		elseif wepHoldType == "melee" or wepHoldType == "melee2" or wepHoldType == "knife" then
			self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= ACT_MELEE_ATTACK_SWING
			self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= false -- Don't play anything!
			//self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 		= ACT_RANGE_ATTACK_SMG1_LOW -- Not used for melee
			self.AnimationTranslations[ACT_COVER_LOW] 					= {"crouchidle_panicked4", "vjseq_crouchidlehide"}
			//self.AnimationTranslations[ACT_RELOAD] 					= ACT_RELOAD_SMG1 -- Not used for melee
			//self.AnimationTranslations[ACT_RELOAD_LOW] 				= ACT_RELOAD_SMG1_LOW -- Not used for melee
			
			self.AnimationTranslations[ACT_IDLE] 						= ACT_IDLE
			self.AnimationTranslations[ACT_IDLE_ANGRY] 					= isFemale and ACT_IDLE_ANGRY or ACT_IDLE_ANGRY_MELEE -- Only males have unique idle angry for melee weapons!
			
			//self.AnimationTranslations[ACT_WALK] 						= ACT_WALK -- No need to translate
			//self.AnimationTranslations[ACT_WALK_AGITATED] 			= ACT_WALK -- No need, same as ACT_WALK
			//self.AnimationTranslations[ACT_WALK_AIM] 					= ACT_WALK_AIM_RIFLE -- Not used for melee
			//self.AnimationTranslations[ACT_WALK_CROUCH] 				= ACT_WALK_CROUCH_RIFLE -- No need to translate
			//self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= ACT_WALK_CROUCH_AIM_RIFLE -- Not used for melee
			
			self.AnimationTranslations[ACT_RUN] 						= ACT_RUN
			if !isFemale then -- Females don't have this sequence
				self.AnimationTranslations[ACT_RUN_AGITATED] 			= VJ.SequenceToActivity(self, "run_all_panicked")
			end
			//self.AnimationTranslations[ACT_RUN_AIM] 					= ACT_RUN_AIM_RIFLE -- Not used for melee
			//self.AnimationTranslations[ACT_RUN_CROUCH] 				= ACT_RUN_CROUCH_RIFLE -- No need to translate
			//self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 			= ACT_RUN_CROUCH_AIM_RIFLE -- Not used for melee
		end
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	------ Player ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	elseif self.AnimModelSet == VJ.ANIM_SET_PLAYER then
		if !self.Weapon_AimTurnDiff then self.Weapon_AimTurnDiff_Def = 0.61155587434769	end
		self.AnimationTranslations[ACT_COWER] 							= ACT_HL2MP_IDLE_COWER
		self.AnimationTranslations[ACT_RUN_PROTECTED] 					= ACT_HL2MP_RUN_PROTECTED
		
		if wepHoldType == "ar2" then
			self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= ACT_HL2MP_IDLE_AR2
			self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_HL2MP_IDLE_CROUCH_AR2
			self.AnimationTranslations[ACT_RELOAD] 						= "vjges_reload_ar2"
			self.AnimationTranslations[ACT_RELOAD_LOW] 					= "vjges_reload_ar2"
			self.AnimationTranslations[ACT_COVER_LOW] 					= ACT_HL2MP_IDLE_CROUCH_AR2
			
			self.AnimationTranslations[ACT_IDLE] 						= ACT_HL2MP_IDLE_PASSIVE
			self.AnimationTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_AR2
			self.AnimationTranslations[ACT_JUMP] 						= ACT_HL2MP_JUMP_AR2
			self.AnimationTranslations[ACT_GLIDE] 						= ACT_HL2MP_JUMP_AR2
			self.AnimationTranslations[ACT_LAND] 						= ACT_HL2MP_IDLE_AR2
			
			self.AnimationTranslations[ACT_WALK] 						= ACT_HL2MP_WALK_PASSIVE
			self.AnimationTranslations[ACT_WALK_AGITATED] 				= ACT_HL2MP_WALK_AR2
			self.AnimationTranslations[ACT_WALK_AIM] 					= ACT_HL2MP_WALK_AR2
			self.AnimationTranslations[ACT_WALK_CROUCH] 				= ACT_HL2MP_WALK_CROUCH_PASSIVE
			self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= ACT_HL2MP_WALK_CROUCH_AR2
			
			self.AnimationTranslations[ACT_RUN] 						= ACT_HL2MP_RUN_PASSIVE
			self.AnimationTranslations[ACT_RUN_AGITATED] 				= ACT_HL2MP_RUN_AR2
			self.AnimationTranslations[ACT_RUN_AIM] 					= ACT_HL2MP_RUN_AR2
			self.AnimationTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH_PASSIVE
			self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_AR2
		elseif wepHoldType == "pistol" then
			self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= ACT_HL2MP_IDLE_PISTOL
			self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_HL2MP_IDLE_CROUCH_PISTOL
			self.AnimationTranslations[ACT_RELOAD] 						= "vjges_reload_pistol"
			self.AnimationTranslations[ACT_RELOAD_LOW] 					= "vjges_reload_pistol"
			self.AnimationTranslations[ACT_COVER_LOW] 					= ACT_HL2MP_IDLE_CROUCH_PISTOL
			
			self.AnimationTranslations[ACT_IDLE] 						= ACT_HL2MP_IDLE
			self.AnimationTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_PISTOL
			self.AnimationTranslations[ACT_JUMP] 						= ACT_HL2MP_JUMP_PISTOL
			self.AnimationTranslations[ACT_GLIDE] 						= ACT_HL2MP_JUMP_PISTOL
			self.AnimationTranslations[ACT_LAND] 						= ACT_HL2MP_IDLE_PISTOL
			
			self.AnimationTranslations[ACT_WALK] 						= ACT_HL2MP_WALK
			self.AnimationTranslations[ACT_WALK_AGITATED] 				= ACT_HL2MP_WALK_PISTOL
			self.AnimationTranslations[ACT_WALK_AIM] 					= ACT_HL2MP_WALK_PISTOL
			self.AnimationTranslations[ACT_WALK_CROUCH] 				= ACT_HL2MP_WALK_CROUCH
			self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= ACT_HL2MP_WALK_CROUCH_PISTOL
			
			self.AnimationTranslations[ACT_RUN] 						= ACT_HL2MP_RUN_FAST
			self.AnimationTranslations[ACT_RUN_AGITATED] 				= ACT_HL2MP_RUN_PISTOL
			self.AnimationTranslations[ACT_RUN_AIM] 					= ACT_HL2MP_RUN_PISTOL
			self.AnimationTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH
			self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_PISTOL
		elseif wepHoldType == "smg" then
			self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= ACT_HL2MP_IDLE_SMG1
			self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_HL2MP_IDLE_CROUCH_SMG1
			self.AnimationTranslations[ACT_RELOAD] 						= "vjges_reload_smg1"
			self.AnimationTranslations[ACT_RELOAD_LOW] 					= "vjges_reload_smg1"
			self.AnimationTranslations[ACT_COVER_LOW] 					= ACT_HL2MP_IDLE_CROUCH_SMG1
			
			self.AnimationTranslations[ACT_IDLE] 						= ACT_HL2MP_IDLE_PASSIVE
			self.AnimationTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_SMG1
			self.AnimationTranslations[ACT_JUMP] 						= ACT_HL2MP_JUMP_SMG1
			self.AnimationTranslations[ACT_GLIDE] 						= ACT_HL2MP_JUMP_SMG1
			self.AnimationTranslations[ACT_LAND] 						= ACT_HL2MP_IDLE_SMG1
			
			self.AnimationTranslations[ACT_WALK] 						= ACT_HL2MP_WALK_PASSIVE
			self.AnimationTranslations[ACT_WALK_AGITATED] 				= ACT_HL2MP_WALK_SMG1
			self.AnimationTranslations[ACT_WALK_AIM] 					= ACT_HL2MP_WALK_SMG1
			self.AnimationTranslations[ACT_WALK_CROUCH] 				= ACT_HL2MP_WALK_CROUCH_PASSIVE
			self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= ACT_HL2MP_WALK_CROUCH_SMG1
			
			self.AnimationTranslations[ACT_RUN] 						= ACT_HL2MP_RUN_PASSIVE
			self.AnimationTranslations[ACT_RUN_AGITATED] 				= ACT_HL2MP_RUN_SMG1
			self.AnimationTranslations[ACT_RUN_AIM] 					= ACT_HL2MP_RUN_SMG1
			self.AnimationTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH_PASSIVE
			self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_SMG1
		elseif wepHoldType == "shotgun" then
			self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= ACT_HL2MP_IDLE_SHOTGUN
			self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_HL2MP_IDLE_CROUCH_SHOTGUN
			self.AnimationTranslations[ACT_RELOAD] 						= "vjges_reload_shotgun"
			self.AnimationTranslations[ACT_RELOAD_LOW] 					= "vjges_reload_shotgun"
			self.AnimationTranslations[ACT_COVER_LOW] 					= ACT_HL2MP_IDLE_CROUCH_SHOTGUN
			
			self.AnimationTranslations[ACT_IDLE] 						= ACT_HL2MP_IDLE_PASSIVE
			self.AnimationTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_SHOTGUN
			self.AnimationTranslations[ACT_JUMP] 						= ACT_HL2MP_JUMP_SHOTGUN
			self.AnimationTranslations[ACT_GLIDE] 						= ACT_HL2MP_JUMP_SHOTGUN
			self.AnimationTranslations[ACT_LAND] 						= ACT_HL2MP_IDLE_SHOTGUN
			
			self.AnimationTranslations[ACT_WALK] 						= ACT_HL2MP_WALK_PASSIVE
			self.AnimationTranslations[ACT_WALK_AGITATED] 				= ACT_HL2MP_WALK_SHOTGUN
			self.AnimationTranslations[ACT_WALK_AIM] 					= ACT_HL2MP_WALK_SHOTGUN
			self.AnimationTranslations[ACT_WALK_CROUCH] 				= ACT_HL2MP_WALK_CROUCH_PASSIVE
			self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= ACT_HL2MP_WALK_CROUCH_SHOTGUN
			
			self.AnimationTranslations[ACT_RUN] 						= ACT_HL2MP_RUN_PASSIVE
			self.AnimationTranslations[ACT_RUN_AGITATED] 				= ACT_HL2MP_RUN_SHOTGUN
			self.AnimationTranslations[ACT_RUN_AIM] 					= ACT_HL2MP_RUN_SHOTGUN
			self.AnimationTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH_PASSIVE
			self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_SHOTGUN
		elseif wepHoldType == "rpg" then
			self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= ACT_HL2MP_IDLE_RPG
			self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_HL2MP_GESTURE_RANGE_ATTACK_RPG
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_HL2MP_IDLE_CROUCH_RPG
			self.AnimationTranslations[ACT_RELOAD] 						= "vjges_reload_ar2"
			self.AnimationTranslations[ACT_RELOAD_LOW] 					= "vjges_reload_ar2"
			self.AnimationTranslations[ACT_COVER_LOW] 					= ACT_HL2MP_IDLE_CROUCH_RPG
			
			self.AnimationTranslations[ACT_IDLE] 						= ACT_HL2MP_IDLE_PASSIVE
			self.AnimationTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_RPG
			self.AnimationTranslations[ACT_JUMP] 						= ACT_HL2MP_JUMP_RPG
			self.AnimationTranslations[ACT_GLIDE] 						= ACT_HL2MP_JUMP_RPG
			self.AnimationTranslations[ACT_LAND] 						= ACT_HL2MP_IDLE_RPG
			
			self.AnimationTranslations[ACT_WALK] 						= ACT_HL2MP_WALK_PASSIVE
			self.AnimationTranslations[ACT_WALK_AGITATED] 				= ACT_HL2MP_WALK_RPG
			self.AnimationTranslations[ACT_WALK_AIM] 					= ACT_HL2MP_WALK_RPG
			self.AnimationTranslations[ACT_WALK_CROUCH] 				= ACT_HL2MP_WALK_CROUCH_PASSIVE
			self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= ACT_HL2MP_WALK_CROUCH_RPG
			
			self.AnimationTranslations[ACT_RUN] 						= ACT_HL2MP_RUN_PASSIVE
			self.AnimationTranslations[ACT_RUN_AGITATED] 				= ACT_HL2MP_RUN_RPG
			self.AnimationTranslations[ACT_RUN_AIM] 					= ACT_HL2MP_RUN_RPG
			self.AnimationTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH_PASSIVE
			self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_RPG
		elseif wepHoldType == "physgun" then
			self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= ACT_HL2MP_IDLE_PHYSGUN
			self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_HL2MP_IDLE_CROUCH_PHYSGUN
			self.AnimationTranslations[ACT_RELOAD] 						= "vjges_reload_ar2"
			self.AnimationTranslations[ACT_RELOAD_LOW] 					= "vjges_reload_ar2"
			self.AnimationTranslations[ACT_COVER_LOW] 					= ACT_HL2MP_IDLE_CROUCH_PHYSGUN
			
			self.AnimationTranslations[ACT_IDLE] 						= ACT_HL2MP_IDLE_PASSIVE
			self.AnimationTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_PHYSGUN
			self.AnimationTranslations[ACT_JUMP] 						= ACT_HL2MP_JUMP_PHYSGUN
			self.AnimationTranslations[ACT_GLIDE] 						= ACT_HL2MP_JUMP_PHYSGUN
			self.AnimationTranslations[ACT_LAND] 						= ACT_HL2MP_IDLE_PHYSGUN
			
			self.AnimationTranslations[ACT_WALK] 						= ACT_HL2MP_WALK_PASSIVE
			self.AnimationTranslations[ACT_WALK_AGITATED] 				= ACT_HL2MP_WALK_PHYSGUN
			self.AnimationTranslations[ACT_WALK_AIM] 					= ACT_HL2MP_WALK_PHYSGUN
			self.AnimationTranslations[ACT_WALK_CROUCH] 				= ACT_HL2MP_WALK_CROUCH_PASSIVE
			self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= ACT_HL2MP_WALK_CROUCH_PHYSGUN
			
			self.AnimationTranslations[ACT_RUN] 						= ACT_HL2MP_RUN_PASSIVE
			self.AnimationTranslations[ACT_RUN_AGITATED] 				= ACT_HL2MP_RUN_PHYSGUN
			self.AnimationTranslations[ACT_RUN_AIM] 					= ACT_HL2MP_RUN_PHYSGUN
			self.AnimationTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH_PASSIVE
			self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_PHYSGUN
		elseif wepHoldType == "crossbow" then
			self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= ACT_HL2MP_IDLE_CROSSBOW
			self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_HL2MP_IDLE_CROUCH_CROSSBOW
			self.AnimationTranslations[ACT_RELOAD] 						= "vjges_reload_ar2"
			self.AnimationTranslations[ACT_RELOAD_LOW] 					= "vjges_reload_ar2"
			self.AnimationTranslations[ACT_COVER_LOW] 					= ACT_HL2MP_IDLE_CROUCH_CROSSBOW
			
			self.AnimationTranslations[ACT_IDLE] 						= ACT_HL2MP_IDLE_PASSIVE
			self.AnimationTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_CROSSBOW
			self.AnimationTranslations[ACT_JUMP] 						= ACT_HL2MP_JUMP_CROSSBOW
			self.AnimationTranslations[ACT_GLIDE] 						= ACT_HL2MP_JUMP_CROSSBOW
			self.AnimationTranslations[ACT_LAND] 						= ACT_HL2MP_IDLE_CROSSBOW
			
			self.AnimationTranslations[ACT_WALK] 						= ACT_HL2MP_WALK_PASSIVE
			self.AnimationTranslations[ACT_WALK_AGITATED] 				= ACT_HL2MP_WALK_CROSSBOW
			self.AnimationTranslations[ACT_WALK_AIM] 					= ACT_HL2MP_WALK_CROSSBOW
			self.AnimationTranslations[ACT_WALK_CROUCH] 				= ACT_HL2MP_WALK_CROUCH_PASSIVE
			self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= ACT_HL2MP_WALK_CROUCH_CROSSBOW
			
			self.AnimationTranslations[ACT_RUN] 						= ACT_HL2MP_RUN_PASSIVE
			self.AnimationTranslations[ACT_RUN_AGITATED] 				= ACT_HL2MP_RUN_CROSSBOW
			self.AnimationTranslations[ACT_RUN_AIM] 					= ACT_HL2MP_RUN_CROSSBOW
			self.AnimationTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH_PASSIVE
			self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_CROSSBOW
		elseif wepHoldType == "slam" then
			self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= ACT_HL2MP_IDLE_SLAM
			self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_HL2MP_GESTURE_RANGE_ATTACK_SLAM
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_HL2MP_IDLE_CROUCH_SLAM
			//self.AnimationTranslations[ACT_RELOAD] 					= "vjges_reload_pistol"
			//self.AnimationTranslations[ACT_RELOAD_LOW] 				= "vjges_reload_pistol"
			self.AnimationTranslations[ACT_COVER_LOW] 					= ACT_HL2MP_IDLE_CROUCH_SLAM
			
			self.AnimationTranslations[ACT_IDLE] 						= ACT_HL2MP_IDLE
			self.AnimationTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_SLAM
			self.AnimationTranslations[ACT_JUMP] 						= ACT_HL2MP_JUMP_SLAM
			self.AnimationTranslations[ACT_GLIDE] 						= ACT_HL2MP_JUMP_SLAM
			self.AnimationTranslations[ACT_LAND] 						= ACT_HL2MP_IDLE_SLAM
			
			self.AnimationTranslations[ACT_WALK] 						= ACT_HL2MP_WALK
			self.AnimationTranslations[ACT_WALK_AGITATED] 				= ACT_HL2MP_WALK_SLAM
			self.AnimationTranslations[ACT_WALK_AIM] 					= ACT_HL2MP_WALK_SLAM
			self.AnimationTranslations[ACT_WALK_CROUCH] 				= ACT_HL2MP_WALK_CROUCH
			self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= ACT_HL2MP_WALK_CROUCH_SLAM
			
			self.AnimationTranslations[ACT_RUN] 						= ACT_HL2MP_RUN
			self.AnimationTranslations[ACT_RUN_AGITATED] 				= ACT_HL2MP_RUN_SLAM
			self.AnimationTranslations[ACT_RUN_AIM] 					= ACT_HL2MP_RUN_SLAM
			self.AnimationTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH
			self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_SLAM
		elseif wepHoldType == "duel" then
			self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= ACT_HL2MP_IDLE_DUEL
			self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_HL2MP_GESTURE_RANGE_ATTACK_DUEL
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_HL2MP_IDLE_CROUCH_DUEL
			self.AnimationTranslations[ACT_RELOAD] 						= "vjges_reload_duel"
			self.AnimationTranslations[ACT_RELOAD_LOW] 					= "vjges_reload_duel"
			self.AnimationTranslations[ACT_COVER_LOW] 					= ACT_HL2MP_IDLE_CROUCH_DUEL
			
			self.AnimationTranslations[ACT_IDLE] 						= ACT_HL2MP_IDLE
			self.AnimationTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_DUEL
			self.AnimationTranslations[ACT_JUMP] 						= ACT_HL2MP_JUMP_DUEL
			self.AnimationTranslations[ACT_GLIDE] 						= ACT_HL2MP_JUMP_DUEL
			self.AnimationTranslations[ACT_LAND] 						= ACT_HL2MP_IDLE_DUEL
			
			self.AnimationTranslations[ACT_WALK] 						= ACT_HL2MP_WALK
			self.AnimationTranslations[ACT_WALK_AGITATED] 				= ACT_HL2MP_WALK_DUEL
			self.AnimationTranslations[ACT_WALK_AIM] 					= ACT_HL2MP_WALK_DUEL
			self.AnimationTranslations[ACT_WALK_CROUCH] 				= ACT_HL2MP_WALK_CROUCH
			self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= ACT_HL2MP_WALK_CROUCH_DUEL
			
			self.AnimationTranslations[ACT_RUN] 						= ACT_HL2MP_RUN
			self.AnimationTranslations[ACT_RUN_AGITATED] 				= ACT_HL2MP_RUN_DUEL
			self.AnimationTranslations[ACT_RUN_AIM] 					= ACT_HL2MP_RUN_DUEL
			self.AnimationTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH
			self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_DUEL
		elseif wepHoldType == "revolver" then
			self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= ACT_HL2MP_IDLE_REVOLVER
			self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_HL2MP_IDLE_CROUCH_REVOLVER
			self.AnimationTranslations[ACT_RELOAD] 						= "vjges_reload_revolver"
			self.AnimationTranslations[ACT_RELOAD_LOW] 					= "vjges_reload_revolver"
			self.AnimationTranslations[ACT_COVER_LOW] 					= ACT_HL2MP_IDLE_CROUCH_REVOLVER
			
			self.AnimationTranslations[ACT_IDLE] 						= ACT_HL2MP_IDLE
			self.AnimationTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_REVOLVER
			self.AnimationTranslations[ACT_JUMP] 						= ACT_HL2MP_JUMP_REVOLVER
			self.AnimationTranslations[ACT_GLIDE] 						= ACT_HL2MP_JUMP_REVOLVER
			self.AnimationTranslations[ACT_LAND] 						= ACT_HL2MP_IDLE_REVOLVER
			
			self.AnimationTranslations[ACT_WALK] 						= ACT_HL2MP_WALK
			self.AnimationTranslations[ACT_WALK_AGITATED] 				= ACT_HL2MP_WALK_REVOLVER
			self.AnimationTranslations[ACT_WALK_AIM] 					= ACT_HL2MP_WALK_REVOLVER
			self.AnimationTranslations[ACT_WALK_CROUCH] 				= ACT_HL2MP_WALK_CROUCH
			self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= ACT_HL2MP_WALK_CROUCH_REVOLVER
			
			self.AnimationTranslations[ACT_RUN] 						= ACT_HL2MP_RUN
			self.AnimationTranslations[ACT_RUN_AGITATED] 				= ACT_HL2MP_RUN_REVOLVER
			self.AnimationTranslations[ACT_RUN_AIM] 					= ACT_HL2MP_RUN_REVOLVER
			self.AnimationTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH
			self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_REVOLVER
		elseif wepHoldType == "melee" then
			self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= ACT_HL2MP_IDLE_MELEE
			self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_HL2MP_IDLE_CROUCH_MELEE
			//self.AnimationTranslations[ACT_RELOAD] 					= "vjges_reload_pistol"
			//self.AnimationTranslations[ACT_RELOAD_LOW] 				= "vjges_reload_pistol"
			self.AnimationTranslations[ACT_COVER_LOW] 					= ACT_HL2MP_IDLE_CROUCH_MELEE
			
			self.AnimationTranslations[ACT_IDLE] 						= ACT_HL2MP_IDLE
			self.AnimationTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_MELEE
			self.AnimationTranslations[ACT_JUMP] 						= ACT_HL2MP_JUMP_MELEE
			self.AnimationTranslations[ACT_GLIDE] 						= ACT_HL2MP_JUMP_MELEE
			self.AnimationTranslations[ACT_LAND] 						= ACT_HL2MP_IDLE_MELEE
			
			self.AnimationTranslations[ACT_WALK] 						= ACT_HL2MP_WALK
			self.AnimationTranslations[ACT_WALK_AGITATED] 				= ACT_HL2MP_WALK_MELEE
			self.AnimationTranslations[ACT_WALK_AIM] 					= ACT_HL2MP_WALK_MELEE
			self.AnimationTranslations[ACT_WALK_CROUCH] 				= ACT_HL2MP_WALK_CROUCH
			self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= ACT_HL2MP_WALK_CROUCH_MELEE
			
			self.AnimationTranslations[ACT_RUN] 						= ACT_HL2MP_RUN
			self.AnimationTranslations[ACT_RUN_AGITATED] 				= ACT_HL2MP_RUN_MELEE
			self.AnimationTranslations[ACT_RUN_AIM] 					= ACT_HL2MP_RUN_MELEE
			self.AnimationTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH
			self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_MELEE
		elseif wepHoldType == "melee2" then
			self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= ACT_HL2MP_IDLE_MELEE2
			self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_HL2MP_IDLE_CROUCH_MELEE2
			//self.AnimationTranslations[ACT_RELOAD] 					= "vjges_reload_pistol"
			//self.AnimationTranslations[ACT_RELOAD_LOW] 				= "vjges_reload_pistol"
			self.AnimationTranslations[ACT_COVER_LOW] 					= ACT_HL2MP_IDLE_CROUCH_MELEE2
			
			self.AnimationTranslations[ACT_IDLE] 						= ACT_HL2MP_IDLE
			self.AnimationTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_MELEE2
			self.AnimationTranslations[ACT_JUMP] 						= ACT_HL2MP_JUMP_MELEE2
			self.AnimationTranslations[ACT_GLIDE] 						= ACT_HL2MP_JUMP_MELEE2
			self.AnimationTranslations[ACT_LAND] 						= ACT_HL2MP_IDLE_MELEE2
			
			self.AnimationTranslations[ACT_WALK] 						= ACT_HL2MP_WALK
			self.AnimationTranslations[ACT_WALK_AGITATED] 				= ACT_HL2MP_WALK_MELEE2
			self.AnimationTranslations[ACT_WALK_AIM] 					= ACT_HL2MP_WALK_MELEE2
			self.AnimationTranslations[ACT_WALK_CROUCH] 				= ACT_HL2MP_WALK_CROUCH
			self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= ACT_HL2MP_WALK_CROUCH_MELEE2
			
			self.AnimationTranslations[ACT_RUN] 						= ACT_HL2MP_RUN
			self.AnimationTranslations[ACT_RUN_AGITATED] 				= ACT_HL2MP_RUN_MELEE2
			self.AnimationTranslations[ACT_RUN_AIM] 					= ACT_HL2MP_RUN_MELEE2
			self.AnimationTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH
			self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_MELEE2
		elseif wepHoldType == "knife" then
			self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= ACT_HL2MP_IDLE_KNIFE
			self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_HL2MP_IDLE_CROUCH_KNIFE
			//self.AnimationTranslations[ACT_RELOAD] 					= "vjges_reload_pistol"
			//self.AnimationTranslations[ACT_RELOAD_LOW] 				= "vjges_reload_pistol"
			self.AnimationTranslations[ACT_COVER_LOW] 					= ACT_HL2MP_IDLE_CROUCH_KNIFE
			
			self.AnimationTranslations[ACT_IDLE] 						= ACT_HL2MP_IDLE
			self.AnimationTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_KNIFE
			self.AnimationTranslations[ACT_JUMP] 						= ACT_HL2MP_JUMP_KNIFE
			self.AnimationTranslations[ACT_GLIDE] 						= ACT_HL2MP_JUMP_KNIFE
			self.AnimationTranslations[ACT_LAND] 						= ACT_HL2MP_IDLE_KNIFE
			
			self.AnimationTranslations[ACT_WALK] 						= ACT_HL2MP_WALK
			self.AnimationTranslations[ACT_WALK_AGITATED] 				= ACT_HL2MP_WALK_KNIFE
			self.AnimationTranslations[ACT_WALK_AIM] 					= ACT_HL2MP_WALK_KNIFE
			self.AnimationTranslations[ACT_WALK_CROUCH] 				= ACT_HL2MP_WALK_CROUCH
			self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= ACT_HL2MP_WALK_CROUCH_KNIFE
			
			self.AnimationTranslations[ACT_RUN] 						= ACT_HL2MP_RUN
			self.AnimationTranslations[ACT_RUN_AGITATED] 				= ACT_HL2MP_RUN_KNIFE
			self.AnimationTranslations[ACT_RUN_AIM] 					= ACT_HL2MP_RUN_KNIFE
			self.AnimationTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH
			self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_KNIFE
		elseif wepHoldType == "grenade" then
			self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= ACT_HL2MP_IDLE_GRENADE
			self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_HL2MP_IDLE_CROUCH_GRENADE
			//self.AnimationTranslations[ACT_RELOAD] 					= "vjges_reload_pistol"
			//self.AnimationTranslations[ACT_RELOAD_LOW] 				= "vjges_reload_pistol"
			self.AnimationTranslations[ACT_COVER_LOW] 					= ACT_HL2MP_IDLE_CROUCH_GRENADE
			
			self.AnimationTranslations[ACT_IDLE] 						= ACT_HL2MP_IDLE
			self.AnimationTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_GRENADE
			self.AnimationTranslations[ACT_JUMP] 						= ACT_HL2MP_JUMP_GRENADE
			self.AnimationTranslations[ACT_GLIDE] 						= ACT_HL2MP_JUMP_GRENADE
			self.AnimationTranslations[ACT_LAND] 						= ACT_HL2MP_IDLE_GRENADE
			
			self.AnimationTranslations[ACT_WALK] 						= ACT_HL2MP_WALK
			self.AnimationTranslations[ACT_WALK_AGITATED] 				= ACT_HL2MP_WALK_GRENADE
			self.AnimationTranslations[ACT_WALK_AIM] 					= ACT_HL2MP_WALK_GRENADE
			self.AnimationTranslations[ACT_WALK_CROUCH] 				= ACT_HL2MP_WALK_CROUCH
			self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= ACT_HL2MP_WALK_CROUCH_GRENADE
			
			self.AnimationTranslations[ACT_RUN] 						= ACT_HL2MP_RUN
			self.AnimationTranslations[ACT_RUN_AGITATED] 				= ACT_HL2MP_RUN_GRENADE
			self.AnimationTranslations[ACT_RUN_AIM] 					= ACT_HL2MP_RUN_GRENADE
			self.AnimationTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH
			self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_GRENADE
		elseif wepHoldType == "camera" then
			self.AnimationTranslations[ACT_RANGE_ATTACK1] 				= ACT_HL2MP_IDLE_CAMERA
			//self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_HL2MP_GESTURE_RANGE_ATTACK_CAMERA
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_HL2MP_IDLE_CROUCH_CAMERA
			//self.AnimationTranslations[ACT_RELOAD] 					= "vjges_reload_pistol"
			//self.AnimationTranslations[ACT_RELOAD_LOW] 				= "vjges_reload_pistol"
			self.AnimationTranslations[ACT_COVER_LOW] 					= ACT_HL2MP_IDLE_CROUCH_CAMERA
			
			self.AnimationTranslations[ACT_IDLE] 						= ACT_HL2MP_IDLE
			self.AnimationTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_CAMERA
			self.AnimationTranslations[ACT_JUMP] 						= ACT_HL2MP_JUMP_CAMERA
			self.AnimationTranslations[ACT_GLIDE] 						= ACT_HL2MP_JUMP_CAMERA
			self.AnimationTranslations[ACT_LAND] 						= ACT_HL2MP_IDLE_CAMERA
			
			self.AnimationTranslations[ACT_WALK] 						= ACT_HL2MP_WALK
			self.AnimationTranslations[ACT_WALK_AGITATED] 				= ACT_HL2MP_WALK_CAMERA
			self.AnimationTranslations[ACT_WALK_AIM] 					= ACT_HL2MP_WALK_CAMERA
			self.AnimationTranslations[ACT_WALK_CROUCH] 				= ACT_HL2MP_WALK_CROUCH
			self.AnimationTranslations[ACT_WALK_CROUCH_AIM] 			= ACT_HL2MP_WALK_CROUCH_CAMERA
			
			self.AnimationTranslations[ACT_RUN] 						= ACT_HL2MP_RUN
			self.AnimationTranslations[ACT_RUN_AGITATED] 				= ACT_HL2MP_RUN_CAMERA
			self.AnimationTranslations[ACT_RUN_AIM] 					= ACT_HL2MP_RUN_CAMERA
			self.AnimationTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH
			self.AnimationTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_CAMERA
		else -- Unarmed!
			self.AnimationTranslations[ACT_IDLE] 						= ACT_HL2MP_IDLE
			self.AnimationTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_ANGRY
			self.AnimationTranslations[ACT_JUMP] 						= ACT_HL2MP_JUMP_PISTOL
			self.AnimationTranslations[ACT_GLIDE] 						= ACT_HL2MP_JUMP_PISTOL
			self.AnimationTranslations[ACT_LAND] 						= ACT_HL2MP_IDLE_PISTOL
			
			self.AnimationTranslations[ACT_WALK] 						= ACT_HL2MP_WALK
			self.AnimationTranslations[ACT_WALK_CROUCH] 				= ACT_HL2MP_WALK_CROUCH
			
			self.AnimationTranslations[ACT_RUN] 						= ACT_HL2MP_RUN_FAST
			self.AnimationTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH
		end
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ ///// WARNING: Don't touch anything below this line! \\\\\ ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local defPos = Vector(0, 0, 0)

local StopSound = VJ.STOPSOUND
local CurTime = CurTime
local IsValid = IsValid
local GetConVar = GetConVar
local math_min = math.min
local math_max = math.max
local math_rad = math.rad
local math_cos = math.cos
local math_angApproach = math.ApproachAngle
local VJ_STATE_FREEZE = VJ_STATE_FREEZE
local VJ_STATE_ONLY_ANIMATION = VJ_STATE_ONLY_ANIMATION
local VJ_STATE_ONLY_ANIMATION_CONSTANT = VJ_STATE_ONLY_ANIMATION_CONSTANT
local VJ_STATE_ONLY_ANIMATION_NOATTACK = VJ_STATE_ONLY_ANIMATION_NOATTACK
local VJ_BEHAVIOR_PASSIVE = VJ_BEHAVIOR_PASSIVE
local VJ_BEHAVIOR_PASSIVE_NATURE = VJ_BEHAVIOR_PASSIVE_NATURE
local VJ_MOVETYPE_GROUND = VJ_MOVETYPE_GROUND
local VJ_MOVETYPE_AERIAL = VJ_MOVETYPE_AERIAL
local VJ_MOVETYPE_AQUATIC = VJ_MOVETYPE_AQUATIC
local VJ_MOVETYPE_STATIONARY = VJ_MOVETYPE_STATIONARY
local VJ_MOVETYPE_PHYSICS = VJ_MOVETYPE_PHYSICS
local ANIM_TYPE_GESTURE = VJ.ANIM_TYPE_GESTURE

ENT.UpdatedPoseParam = false
ENT.Weapon_UnarmedBehavior_Active = false
ENT.WeaponEntity = NULL
ENT.WeaponState = VJ.WEP_STATE_READY
ENT.WeaponInventoryStatus = VJ.WEP_INVENTORY_NONE
ENT.AllowWeaponWaitOnOcclusion = true
ENT.WeaponLastShotTime = 0
ENT.WeaponAttackState = VJ.WEP_ATTACK_STATE_NONE
ENT.WeaponAttackAnim = ACT_INVALID
ENT.Weapon_AimTurnDiff_Def = 1 -- Default value to use when "self.Weapon_AimTurnDiff" false, this is auto calculated depending on anim set and weapon hold type
ENT.NextWeaponAttackT = 0
ENT.NextWeaponAttackT_Base = 0 -- Handled by the base, used to avoid running shoot animation twice
ENT.NextWeaponStrafeWhileFiringT = 0
ENT.NextMeleeWeaponAttackT = 0
ENT.NextMoveOnGunCoveredT = 0
ENT.NextThrowGrenadeT = 0
ENT.NextGrenadeAttackSoundT = 0
ENT.NextSuppressingSoundT = 0
ENT.NextDangerDetectionT = 0
ENT.NextOnGrenadeSightSoundT = 0
ENT.NextOnDangerSightSoundT = 0
ENT.NextMoveOrHideOnDamageByEnemyT = 0
ENT.TimersToRemove = {"timer_grenade_start", "timer_grenade_finished_ableto", "timer_grenade_finished", "timer_weapon_state_reset", "timer_state_reset", "timer_turning", "timer_flinch_reset", "timer_pauseattacks_reset", "timer_melee_finished", "timer_melee_start", "timer_melee_finished_ableto", "timer_weapon_reload", "timer_alerted_reset"}

local vj_npc_debug = GetConVar("vj_npc_debug")
local vj_npc_processtime = GetConVar("vj_npc_processtime")
local vj_npc_poseparams = GetConVar("vj_npc_poseparams")
local vj_npc_shadows = GetConVar("vj_npc_shadows")
local vj_npc_snd = GetConVar("vj_npc_snd")
local vj_npc_fri_base = GetConVar("vj_npc_fri_base")
local vj_npc_fri_player = GetConVar("vj_npc_fri_player")
local vj_npc_fri_antlion = GetConVar("vj_npc_fri_antlion")
local vj_npc_fri_combine = GetConVar("vj_npc_fri_combine")
local vj_npc_fri_zombie = GetConVar("vj_npc_fri_zombie")
local vj_npc_allies = GetConVar("vj_npc_allies")
local vj_npc_anim_death = GetConVar("vj_npc_anim_death")
local vj_npc_corpse = GetConVar("vj_npc_corpse")
local vj_npc_loot = GetConVar("vj_npc_loot")
local vj_npc_wander = GetConVar("vj_npc_wander")
local vj_npc_chase = GetConVar("vj_npc_chase")
local vj_npc_flinch = GetConVar("vj_npc_flinch")
local vj_npc_melee = GetConVar("vj_npc_melee")
local vj_npc_blood = GetConVar("vj_npc_blood")
local vj_npc_god = GetConVar("vj_npc_god")
local vj_npc_wep_reload = GetConVar("vj_npc_wep_reload")
local vj_npc_ply_betray = GetConVar("vj_npc_ply_betray")
local vj_npc_callhelp = GetConVar("vj_npc_callhelp")
local vj_npc_investigate = GetConVar("vj_npc_investigate")
local vj_npc_eat = GetConVar("vj_npc_eat")
local vj_npc_ply_follow = GetConVar("vj_npc_ply_follow")
local vj_npc_ply_chat = GetConVar("vj_npc_ply_chat")
local vj_npc_medic = GetConVar("vj_npc_medic")
local vj_npc_wep = GetConVar("vj_npc_wep")
local vj_npc_grenade = GetConVar("vj_npc_grenade")
local vj_npc_dangerdetection = GetConVar("vj_npc_dangerdetection")
local vj_npc_wep_drop = GetConVar("vj_npc_wep_drop")
local vj_npc_gib_vfx = GetConVar("vj_npc_gib_vfx")
local vj_npc_gib = GetConVar("vj_npc_gib")
local vj_npc_blood_gmod = GetConVar("vj_npc_blood_gmod")
local vj_npc_sight_xray = GetConVar("vj_npc_sight_xray")
local vj_npc_runontouch = GetConVar("vj_npc_runontouch")
local vj_npc_runonhit = GetConVar("vj_npc_runonhit")
local vj_npc_snd_gib = GetConVar("vj_npc_snd_gib")
local vj_npc_snd_track = GetConVar("vj_npc_snd_track")
local vj_npc_snd_footstep = GetConVar("vj_npc_snd_footstep")
local vj_npc_snd_idle = GetConVar("vj_npc_snd_idle")
local vj_npc_snd_breath = GetConVar("vj_npc_snd_breath")
local vj_npc_snd_alert = GetConVar("vj_npc_snd_alert")
local vj_npc_snd_danger = GetConVar("vj_npc_snd_danger")
local vj_npc_snd_melee = GetConVar("vj_npc_snd_melee")
local vj_npc_snd_pain = GetConVar("vj_npc_snd_pain")
local vj_npc_snd_death = GetConVar("vj_npc_snd_death")
local vj_npc_snd_plyfollow = GetConVar("vj_npc_snd_plyfollow")
local vj_npc_snd_plybetrayal = GetConVar("vj_npc_snd_plybetrayal")
local vj_npc_snd_plydamage = GetConVar("vj_npc_snd_plydamage")
local vj_npc_snd_plysight = GetConVar("vj_npc_snd_plysight")
local vj_npc_snd_medic = GetConVar("vj_npc_snd_medic")
local vj_npc_snd_wep_reload = GetConVar("vj_npc_snd_wep_reload")
local vj_npc_snd_grenade = GetConVar("vj_npc_snd_grenade")
local vj_npc_snd_wep_suppressing = GetConVar("vj_npc_snd_wep_suppressing")
local vj_npc_snd_callhelp = GetConVar("vj_npc_snd_callhelp")
local vj_npc_snd_receiveorder = GetConVar("vj_npc_snd_receiveorder")
local vj_npc_corpse_collision = GetConVar("vj_npc_corpse_collision")
local vj_npc_debug_engine = GetConVar("vj_npc_debug_engine")
local vj_npc_difficulty = GetConVar("vj_npc_difficulty")
local vj_npc_sight_distance = GetConVar("vj_npc_sight_distance")
local vj_npc_health = GetConVar("vj_npc_health")
local vj_npc_human_jump = GetConVar("vj_npc_human_jump")
local vj_npc_ply_frag = GetConVar("vj_npc_ply_frag")
local vj_npc_blood_pool = GetConVar("vj_npc_blood_pool")
local vj_npc_corpse_undo = GetConVar("vj_npc_corpse_undo")
local vj_npc_corpse_fade = GetConVar("vj_npc_corpse_fade")
local vj_npc_corpse_fadetime = GetConVar("vj_npc_corpse_fadetime")
local ai_serverragdolls = GetConVar("ai_serverragdolls")

---------------------------------------------------------------------------------------------------------------------------------------------
local function InitConvars(self)
	if vj_npc_debug:GetInt() == 1 then self.VJ_DEBUG = true end
	if vj_npc_poseparams:GetInt() == 0 && !self.OnUpdatePoseParamTracking then self.HasPoseParameterLooking = false end
	if vj_npc_shadows:GetInt() == 0 then self:DrawShadow(false) end
	if vj_npc_snd:GetInt() == 0 then self.HasSounds = false end
	if vj_npc_fri_base:GetInt() == 1 then self.VJ_NPC_Class[#self.VJ_NPC_Class + 1] = "CLASS_VJ_BASE" end
	if vj_npc_fri_player:GetInt() == 1 then self.VJ_NPC_Class[#self.VJ_NPC_Class + 1] = "CLASS_PLAYER_ALLY" end
	if vj_npc_fri_antlion:GetInt() == 1 then self.VJ_NPC_Class[#self.VJ_NPC_Class + 1] = "CLASS_ANTLION" end
	if vj_npc_fri_combine:GetInt() == 1 then self.VJ_NPC_Class[#self.VJ_NPC_Class + 1] = "CLASS_COMBINE" end
	if vj_npc_fri_zombie:GetInt() == 1 then self.VJ_NPC_Class[#self.VJ_NPC_Class + 1] = "CLASS_ZOMBIE" end
	if vj_npc_allies:GetInt() == 0 then self.CanAlly = false self.PlayerFriendly = false end
	if vj_npc_anim_death:GetInt() == 0 then self.HasDeathAnimation = false end
	if vj_npc_corpse:GetInt() == 0 then self.HasDeathCorpse = false end
	if vj_npc_loot:GetInt() == 0 then self.DropDeathLoot = false end
	if vj_npc_wander:GetInt() == 0 then self.DisableWandering = true end
	if vj_npc_chase:GetInt() == 0 then self.DisableChasingEnemy = true end
	if vj_npc_flinch:GetInt() == 0 then self.CanFlinch = false end
	if vj_npc_melee:GetInt() == 0 then self.HasMeleeAttack = false end
	if vj_npc_blood:GetInt() == 0 then self.Bleeds = false end
	if vj_npc_god:GetInt() == 1 then self.GodMode = true end
	if vj_npc_wep_reload:GetInt() == 0 then self.Weapon_CanReload = false end
	if vj_npc_ply_betray:GetInt() == 0 then self.BecomeEnemyToPlayer = false end
	if vj_npc_callhelp:GetInt() == 0 then self.CallForHelp = false end
	if vj_npc_investigate:GetInt() == 0 then self.CanInvestigate = false end
	if vj_npc_eat:GetInt() == 0 then self.CanEat = false end
	if vj_npc_ply_follow:GetInt() == 0 then self.FollowPlayer = false end
	if vj_npc_ply_chat:GetInt() == 0 then self.CanChatMessage = false end
	if vj_npc_medic:GetInt() == 0 then self.IsMedic = false end
	if vj_npc_wep:GetInt() == 0 then self.DisableWeapons = true end
	if vj_npc_grenade:GetInt() == 0 then self.HasGrenadeAttack = false end
	if vj_npc_dangerdetection:GetInt() == 0 then self.CanDetectDangers = false end
	if vj_npc_wep_drop:GetInt() == 0 then self.DropWeaponOnDeath = false end
	if vj_npc_gib_vfx:GetInt() == 0 then self.HasGibOnDeathEffects = false end
	if vj_npc_gib:GetInt() == 0 then self.CanGib = false self.CanGibOnDeath = false end
	if vj_npc_blood_gmod:GetInt() == 1 then self.BloodDecalUseGMod = true end
	if vj_npc_sight_xray:GetInt() == 1 then self.SightAngle = 360 self.FindEnemy_CanSeeThroughWalls = true end
	if vj_npc_runontouch:GetInt() == 0 then self.Passive_RunOnTouch = false end
	if vj_npc_runonhit:GetInt() == 0 then self.Passive_RunOnDamage = false end
	if vj_npc_snd_gib:GetInt() == 0 then self.HasGibOnDeathSounds = false end
	if vj_npc_snd_track:GetInt() == 0 then self.HasSoundTrack = false end
	if vj_npc_snd_footstep:GetInt() == 0 then self.HasFootStepSound = false end
	if vj_npc_snd_idle:GetInt() == 0 then self.HasIdleSounds = false end
	if vj_npc_snd_breath:GetInt() == 0 then self.HasBreathSound = false end
	if vj_npc_snd_alert:GetInt() == 0 then self.HasAlertSounds = false end
	if vj_npc_snd_danger:GetInt() == 0 then self.HasOnGrenadeSightSounds = false self.HasOnDangerSightSounds = false end
	if vj_npc_snd_melee:GetInt() == 0 then self.HasMeleeAttackSounds = false self.HasExtraMeleeAttackSounds = false self.HasMeleeAttackMissSounds = false end
	if vj_npc_snd_pain:GetInt() == 0 then self.HasPainSounds = false end
	if vj_npc_snd_death:GetInt() == 0 then self.HasDeathSounds = false end
	if vj_npc_snd_plyfollow:GetInt() == 0 then self.HasFollowPlayerSounds = false end
	if vj_npc_snd_plybetrayal:GetInt() == 0 then self.HasBecomeEnemyToPlayerSounds = false end
	if vj_npc_snd_plydamage:GetInt() == 0 then self.HasDamageByPlayerSounds = false end
	if vj_npc_snd_plysight:GetInt() == 0 then self.HasOnPlayerSightSounds = false end
	if vj_npc_snd_medic:GetInt() == 0 then self.HasMedicSounds_BeforeHeal = false self.HasMedicSounds_AfterHeal = false self.HasMedicSounds_ReceiveHeal = false end
	if vj_npc_snd_wep_reload:GetInt() == 0 then self.HasWeaponReloadSounds = false end
	if vj_npc_snd_grenade:GetInt() == 0 then self.HasGrenadeAttackSounds = false end
	if vj_npc_snd_wep_suppressing:GetInt() == 0 then self.HasSuppressingSounds = false end
	if vj_npc_snd_callhelp:GetInt() == 0 then self.HasCallForHelpSounds = false end
	if vj_npc_snd_receiveorder:GetInt() == 0 then self.HasOnReceiveOrderSounds = false end
	local corpseCollision = vj_npc_corpse_collision:GetInt()
	if corpseCollision != 0 && self.DeathCorpseCollisionType == COLLISION_GROUP_DEBRIS then
		if corpseCollision == 1 then
			self.DeathCorpseCollisionType = COLLISION_GROUP_NONE
		elseif corpseCollision == 2 then
			self.DeathCorpseCollisionType = COLLISION_GROUP_WORLD
		elseif corpseCollision == 3 then
			self.DeathCorpseCollisionType = COLLISION_GROUP_INTERACTIVE
		elseif corpseCollision == 4 then
			self.DeathCorpseCollisionType = COLLISION_GROUP_WEAPON
		elseif corpseCollision == 5 then
			self.DeathCorpseCollisionType = COLLISION_GROUP_PASSABLE_DOOR
		elseif corpseCollision == 6 then
			self.DeathCorpseCollisionType = COLLISION_GROUP_NONE
		end
	end
	-- Enables source engine debug overlays (some commands like 'npc_conditions' need it)
	if self.VJ_DEBUG && vj_npc_debug_engine:GetInt() == 1 then
		self:SetSaveValue("m_debugOverlays", bit.bor(0x00000001, 0x00000002, 0x00000004, 0x00000008, 0x00000010, 0x00000020, 0x00000040, 0x00000080, 0x00000100, 0x00000200, 0x00001000, 0x00002000, 0x00004000, 0x00008000, 0x00020000, 0x00040000, 0x00080000, 0x00100000, 0x00200000, 0x00400000, 0x04000000, 0x08000000, 0x10000000, 0x20000000, 0x40000000))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function ApplyBackwardsCompatibility(self)
	-- !!!!!!!!!!!!!! DO NOT USE ANY OF THESE !!!!!!!!!!!!!! [Backwards Compatibility!]
	-- Most of these are pre-revamp variables & functions
	if self.CustomOnInitialize then self:CustomOnInitialize() end
	if self.CustomInitialize then self:CustomInitialize() end
	if self.CustomOn_PoseParameterLookingCode then self.OnUpdatePoseParamTracking = function(_, pitch, yaw, roll) self:CustomOn_PoseParameterLookingCode(pitch, yaw, roll) end end
	if self.CustomOnAlert then self.OnAlert = function(_, ent) self:CustomOnAlert(ent) end end
	if self.CustomOnInvestigate then self.OnInvestigate = function(_, ent) self:CustomOnInvestigate(ent) end end
	if self.CustomOnFootStepSound then self.OnFootstepSound = function(_, moveType, sdFile) self:CustomOnFootStepSound(moveType, sdFile) end end
	if self.CustomOnCallForHelp then self.OnCallForHelp = function(_, ally, isFirst) self:CustomOnCallForHelp(ally, isFirst) end end
	if self.CustomOnPlayerSight then self.OnPlayerSight = function(_, ent) self:CustomOnPlayerSight(ent) end end
	if self.CustomOnThink then self.OnThink = function() self:CustomOnThink() end end
	if self.CustomOnThink_AIEnabled then self.OnThinkActive = function() self:CustomOnThink_AIEnabled() end end
	if self.CustomOnTakeDamage_OnBleed then self.OnBleed = function(_, dmginfo, hitgroup) self:CustomOnTakeDamage_OnBleed(dmginfo, hitgroup) end end
	if self.CustomOnMoveRandomlyWhenShooting then self.OnWeaponStrafeWhileFiring = function() self:CustomOnMoveRandomlyWhenShooting() end end
	if self.CustomOnAcceptInput then self.OnInput = function(_, key, activator, caller, data) self:CustomOnAcceptInput(key, activator, caller, data) end end
	if self.CustomOnHandleAnimEvent then self.OnAnimEvent = function(_, ev, evTime, evCycle, evType, evOptions) self:CustomOnHandleAnimEvent(ev, evTime, evCycle, evType, evOptions) end end
	if self.CustomOnWeaponReload then self.OnWeaponReload = function() self:CustomOnWeaponReload() end end
	if self.CustomOnWeaponAttack then self.OnWeaponAttack = function() self:CustomOnWeaponAttack() end end
	if self.CustomOnDropWeapon then self.OnDeathWeaponDrop = function(_, dmginfo, hitgroup, wepEnt) self:CustomOnDropWeapon(dmginfo, hitgroup, wepEnt) end end
	if self.CustomOnDeath_AfterCorpseSpawned then self.OnCreateDeathCorpse = function(_, dmginfo, hitgroup, corpseEnt) self:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt) end end
	if self.MoveRandomlyWhenShooting != nil then self.Weapon_StrafeWhileFiring = self.MoveRandomlyWhenShooting end
	if self.NextMoveRandomlyWhenShootingTime1 or self.NextMoveRandomlyWhenShootingTime2 then self.Weapon_StrafeWhileFiringDelay = VJ.SET(self.NextMoveRandomlyWhenShootingTime1 or 3, self.NextMoveRandomlyWhenShootingTime2 or 6) end
	if self.WaitForEnemyToComeOut != nil then self.Weapon_WaitOnOcclusion = self.WaitForEnemyToComeOut end
	if self.WaitForEnemyToComeOutTime then self.Weapon_WaitOnOcclusionTime = self.WaitForEnemyToComeOutTime end
	if self.Immune_Physics then self:SetPhysicsDamageScale(0) end
	if self.MaxJumpLegalDistance then self.JumpVars.MaxRise = self.MaxJumpLegalDistance.a; self.JumpVars.MaxDrop = self.MaxJumpLegalDistance.b end
	if self.VJ_IsHugeMonster then self.VJ_ID_Boss = self.VJ_IsHugeMonster end
	if self.UsePlayerModelMovement then self.UsePoseParameterMovement = true end
	if self.WaitBeforeDeathTime then self.DeathDelayTime = self.WaitBeforeDeathTime end
	if self.HasDeathRagdoll != nil then self.HasDeathCorpse = self.HasDeathRagdoll end
	if self.AllowedToGib != nil then self.CanGib = self.AllowedToGib end
	if self.HasGibOnDeath != nil then self.CanGibOnDeath = self.HasGibOnDeath end
	if self.HasGibDeathParticles != nil then self.HasGibOnDeathEffects = self.HasGibDeathParticles else self.HasGibDeathParticles = self.HasGibOnDeathEffects end
	if self.HasItemDropsOnDeath != nil then self.DropDeathLoot = self.HasItemDropsOnDeath end
	if self.ItemDropsOnDeathChance != nil then self.DeathLootChance = self.ItemDropsOnDeathChance end
	if self.ItemDropsOnDeath_EntityList != nil then self.DeathLoot = self.ItemDropsOnDeath_EntityList end
	if self.AllowMovementJumping != nil then self.JumpVars.Enabled = self.AllowMovementJumping end
	if self.HasShootWhileMoving == false then self.Weapon_CanFireWhileMoving = false end
	if self.HasWeaponBackAway == false then self.Weapon_RetreatDistance = 0 end
	if self.WeaponBackAway_Distance then self.Weapon_RetreatDistance = self.WeaponBackAway_Distance end
	if self.WeaponSpread then self.Weapon_Accuracy = self.WeaponSpread end
	if self.AllowWeaponReloading != nil then self.Weapon_CanReload = self.AllowWeaponReloading end
	if self.WeaponReload_FindCover != nil then self.Weapon_FindCoverOnReload = self.WeaponReload_FindCover end
	if self.ThrowGrenadeChance then self.GrenadeAttackChance = self.ThrowGrenadeChance end
	if self.OnlyDoKillEnemyWhenClear != nil then self.OnKilledEnemy_OnlyLast = self.OnlyDoKillEnemyWhenClear end
	if self.NoWeapon_UseScaredBehavior != nil then self.Weapon_UnarmedBehavior = self.NoWeapon_UseScaredBehavior end
	if self.CanCrouchOnWeaponAttack != nil then self.Weapon_CanCrouchAttack = self.CanCrouchOnWeaponAttack end
	if self.CanCrouchOnWeaponAttackChance != nil then self.Weapon_CrouchAttackChance = self.CanCrouchOnWeaponAttackChance end
	if self.AnimTbl_WeaponAttackFiringGesture != nil then self.AnimTbl_WeaponAttackGesture = self.AnimTbl_WeaponAttackFiringGesture end
	if self.CanUseSecondaryOnWeaponAttack != nil then self.Weapon_CanSecondaryFire = self.CanUseSecondaryOnWeaponAttack end
	if self.WeaponAttackSecondaryTimeUntilFire != nil then self.Weapon_SecondaryFireTime = self.WeaponAttackSecondaryTimeUntilFire end
	if self.DisableFootStepOnWalk then self.FootStepTimeWalk = false end
	if self.DisableFootStepOnRun then self.FootStepTimeRun = false end
	if self.FindEnemy_UseSphere then self.SightAngle = 360 end
	if self.IsMedicSNPC then self.IsMedic = self.IsMedicSNPC end
	if self.BecomeEnemyToPlayer == true then self.BecomeEnemyToPlayer = self.BecomeEnemyToPlayerLevel or 2 end
	if self.CustomBlood_Particle then self.BloodParticle = self.CustomBlood_Particle end
	if self.CustomBlood_Pool then self.BloodPool = self.CustomBlood_Pool end
	if self.CustomBlood_Decal then self.BloodDecal = self.CustomBlood_Decal end
	if self.GibOnDeathDamagesTable then
		for _, v in ipairs(self.GibOnDeathDamagesTable) do
			if v == "All" then
				self.GibOnDeathFilter = false
			end
		end
	end
	if self.SetUpGibesOnDeath then
		self.HandleGibOnDeath = function(_, dmginfo, hitgroup)
			local gibbed, overrides = self:SetUpGibesOnDeath(dmginfo, hitgroup)
			local tbl = {}
			if overrides then
				if overrides.AllowCorpse then tbl.AllowCorpse = true end
				if overrides.DeathAnim then tbl.AllowAnim = true end
			end
			if self.CustomGibOnDeathSounds && !self:CustomGibOnDeathSounds(dmginfo, hitgroup) then
				tbl.AllowSound = false
			end
			return gibbed, tbl
		end
	end
	if self.CustomOnDoKilledEnemy then
		self.OnKilledEnemy = function(_, ent, inflictor, wasLast)
			if (self.OnKilledEnemy_OnlyLast == false) or (self.OnKilledEnemy_OnlyLast == true && wasLast) then
				self:CustomOnDoKilledEnemy(ent, self, inflictor)
			end
		end
	end
	if self.CustomOnMedic_BeforeHeal or self.CustomOnMedic_OnHeal or self.CustomOnMedic_OnReset then
		self.OnMedicBehavior = function(_, status, statusData)
			if status == "BeforeHeal" && self.CustomOnMedic_BeforeHeal then
				self:CustomOnMedic_BeforeHeal()
			elseif status == "OnHeal" && self.CustomOnMedic_OnHeal then
				return self:CustomOnMedic_OnHeal(statusData)
			elseif status == "OnReset" && self.CustomOnMedic_OnReset then
				self:CustomOnMedic_OnReset()
			end
		end
	end
	if self.CustomOnTakeDamage_BeforeImmuneChecks or self.CustomOnTakeDamage_BeforeDamage or self.CustomOnTakeDamage_AfterDamage then
		self.OnDamaged = function(_, dmginfo, hitgroup, status)
			if status == "Initial" && self.CustomOnTakeDamage_BeforeImmuneChecks then
				self:CustomOnTakeDamage_BeforeImmuneChecks(dmginfo, hitgroup)
			elseif status == "PreDamage" && self.CustomOnTakeDamage_BeforeDamage then
				self:CustomOnTakeDamage_BeforeDamage(dmginfo, hitgroup)
			elseif status == "PostDamage" && self.CustomOnTakeDamage_AfterDamage then
				self:CustomOnTakeDamage_AfterDamage(dmginfo, hitgroup)
			end
		end
	end
	if self.CustomOnFlinch_BeforeFlinch or self.CustomOnFlinch_AfterFlinch then
		self.OnFlinch = function(_, dmginfo, hitgroup, status)
			if status == "PriorExecution" then
				if self.CustomOnFlinch_BeforeFlinch then
					return !self:CustomOnFlinch_BeforeFlinch(dmginfo, hitgroup)
				end
			elseif status == "Execute" then
				if self.CustomOnFlinch_AfterFlinch then
					self:CustomOnFlinch_AfterFlinch(dmginfo, hitgroup)
				end
			end
		end
	end
	if self.CustomOnInitialKilled or self.CustomOnPriorToKilled or self.CustomDeathAnimationCode or self.CustomOnKilled or self.CustomOnDeath_BeforeCorpseSpawned then
		self.OnDeath = function(_, dmginfo, hitgroup, status)
			if status == "Initial" then
				if self.CustomOnInitialKilled then
					self:CustomOnInitialKilled(dmginfo, hitgroup)
				end
				if self.CustomOnPriorToKilled then
					self:CustomOnPriorToKilled(dmginfo, hitgroup)
				end
			elseif status == "DeathAnim" && self.CustomDeathAnimationCode then
				self:CustomDeathAnimationCode(dmginfo, hitgroup)
			elseif status == "Finish" then
				if self.CustomOnKilled then
					self:CustomOnKilled(dmginfo, hitgroup)
				end
				if self.CustomOnDeath_BeforeCorpseSpawned then
					self:CustomOnDeath_BeforeCorpseSpawned(dmginfo, hitgroup)
				end
			end
		end
	end
	if self.HasWorldShakeOnMove && !self.OnFootstepSound then
		self.OnFootstepSound = function()
			util.ScreenShake(self:GetPos(), self.WorldShakeOnMoveAmplitude or 10, self.WorldShakeOnMoveFrequency or 100, self.WorldShakeOnMoveDuration or 0.4, self.WorldShakeOnMoveRadius or 1000)
		end
	end
	if self.DeathCorpseSkin && self.DeathCorpseSkin != -1 then
		local orgFunc = self.OnCreateDeathCorpse
		self.OnCreateDeathCorpse = function(_, dmginfo, hitgroup, corpseEnt)
			orgFunc(self, dmginfo, hitgroup, corpseEnt)
			corpseEnt:SetSkin(self.DeathCorpseSkin)
		end
	end
	if self.CustomOnTouch then
		self.OnTouch = function(_, ent)
			self:CustomOnTouch(ent)
		end
	end
	-- !!!!!!!!!!!!!! DO NOT USE ANY OF THESE !!!!!!!!!!!!!! [Backwards Compatibility!]
end
---------------------------------------------------------------------------------------------------------------------------------------------
local defShootVec = Vector(0, 0, 55)
local capBitsDefault = bit.bor(CAP_SKIP_NAV_GROUND_CHECK, CAP_TURN_HEAD, CAP_DUCK)
local capBitsDoors = bit.bor(CAP_OPEN_DOORS, CAP_AUTO_DOORS, CAP_USE)
local capBitsWeapons = bit.bor(CAP_USE_WEAPONS, CAP_WEAPON_RANGE_ATTACK1)
--
function ENT:Initialize()
	self:PreInit()
	if self.CustomOnPreInitialize then self:CustomOnPreInitialize() end -- !!!!!!!!!!!!!! DO NOT USE !!!!!!!!!!!!!! [Backwards Compatibility!]
	
	self:SetSpawnEffect(false)
	self:SetRenderMode(RENDERMODE_NORMAL)
	self:AddEFlags(EFL_NO_DISSOLVE)
	self:SetUseType(SIMPLE_USE)
	local models = PICK(self.Model); if models then self:SetModel(models) end
	self:SetHullType(self.HullType)
	self:SetHullSizeNormal()
	if self.HasSetSolid then self:SetSolid(SOLID_BBOX) end
	self:SetCollisionGroup(COLLISION_GROUP_NPC)
	self:SetMaxYawSpeed(self.TurningSpeed)
	self:SetSaveValue("m_HackedGunPos", defShootVec) -- Overrides the location of self:GetShootPos()
	
	-- Set a name if it doesn't have one
	if self:GetName() == "" then
		local findListing = list.Get("NPC")[self:GetClass()]
		if findListing then
			self:SetName((self.PrintName == "" and findListing.Name) or self.PrintName)
		end
	end
	
	-- Initialize variables
	InitConvars(self)
	self.NextProcessTime = vj_npc_processtime:GetInt()
	self.SelectedDifficulty = vj_npc_difficulty:GetInt()
	if !self.RelationshipEnts then self.RelationshipEnts = {} end
	if !self.RelationshipMemory then self.RelationshipMemory = {} end
	self.AnimationTranslations = {}
	self.WeaponInventory = {}
	self.NextIdleSoundT_RegularChange = CurTime() + math.random(0.3, 6)
	self.UseTheSameGeneralSoundPitch_PickedNumber = (self.UseTheSameGeneralSoundPitch and math.random(self.GeneralSoundPitch1, self.GeneralSoundPitch2)) or 0
	local sightConvar = vj_npc_sight_distance:GetInt(); if sightConvar > 0 then self.SightDistance = sightConvar end
	
	-- Capabilities & Movement
	self:DoChangeMovementType(self.MovementType)
	self:CapabilitiesAdd(capBitsDefault)
	if self.CanOpenDoors then self:CapabilitiesAdd(capBitsDoors) end
	-- Both of these attachments have to be valid for "ai_baseactor" to work properly!
	if self:LookupAttachment("eyes") > 0 && self:LookupAttachment("forward") > 0 then
		self:CapabilitiesAdd(CAP_ANIMATEDFACE)
	end
	if self.Behavior == VJ_BEHAVIOR_PASSIVE or self.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE then
		self.DisableWeapons = true
		self.Weapon_NoSpawnMenu = true
	elseif !self.DisableWeapons && !self.Weapon_NoSpawnMenu then
		self:CapabilitiesAdd(capBitsWeapons)
	end
	
	-- Health
	local hpConvar = vj_npc_health:GetInt()
	local hp = hpConvar > 0 && hpConvar or self:ScaleByDifficulty(self.StartHealth)
	self:SetHealth(hp)
	self.StartHealth = hp
	
	self:Init()
	ApplyBackwardsCompatibility(self)
	
	-- Collision-based computations
	//self:SetSurroundingBoundsType(BOUNDS_HITBOXES) -- AVOID! Has to constantly recompute the bounds! | Issues: Entities get stuck inside the NPC, movements failing, unable to grab the NPC with physgun
	local collisionMin, collisionMax = self:GetCollisionBounds()
	-- Auto compute damage bounds if the damage bounds == collision bounds then the developer has NOT changed it | Call after "Init"
	if self:GetSurroundingBounds() == self:WorldSpaceAABB() then
		self:SetSurroundingBounds(Vector(collisionMin.x * 2, collisionMin.y * 2, collisionMin.z * 1.2), Vector(collisionMax.x * 2, collisionMax.y * 2, collisionMax.z * 1.2))
	end
	if !self.MeleeAttackDistance then self.MeleeAttackDistance = math.abs(collisionMax.x) + 30 end
	if !self.MeleeAttackDamageDistance then self.MeleeAttackDamageDistance = math.abs(collisionMax.x) + 60 end
	self:SetupBloodColor(self.BloodColor) -- Collision bounds dependent
	
	self.NextWanderTime = ((self.NextWanderTime != 0) and self.NextWanderTime) or (CurTime() + (self.IdleAlwaysWander and 0 or 1)) -- If self.NextWanderTime isn't given a value THEN if self.IdleAlwaysWander isn't true, wait at least 1 sec before wandering
	duplicator.RegisterEntityClass(self:GetClass(), VJ.CreateDupe_NPC, "Model", "Class", "Equipment", "SpawnFlags", "Data")
	
	-- Delayed init
	timer.Simple(0.1, function()
		if IsValid(self) then
			self:SetMaxLookDistance(self.SightDistance)
			self:SetFOV(self.SightAngle)
			if self:GetNPCState() <= NPC_STATE_NONE then self:SetNPCState(NPC_STATE_IDLE) end
			if IsValid(self:GetCreator()) && self:GetCreator():GetInfoNum("vj_npc_spawn_guard", 0) == 1 then self.IsGuard = true end
			self:StartSoundTrack()
			
			-- Setup common default pose parameters
			if self:LookupPoseParameter("aim_pitch") != -1 then
				self.PoseParameterLooking_Names.pitch[#self.PoseParameterLooking_Names.pitch + 1] = "aim_pitch"
			end
			if self:LookupPoseParameter("head_pitch") != -1 then
				self.PoseParameterLooking_Names.pitch[#self.PoseParameterLooking_Names.pitch + 1] = "head_pitch"
			end
			if self:LookupPoseParameter("aim_yaw") != -1 then
				self.PoseParameterLooking_Names.yaw[#self.PoseParameterLooking_Names.yaw + 1] = "aim_yaw"
			end
			if self:LookupPoseParameter("head_yaw") != -1 then
				self.PoseParameterLooking_Names.yaw[#self.PoseParameterLooking_Names.yaw + 1] = "head_yaw"
			end
			if self:LookupPoseParameter("aim_roll") != -1 then
				self.PoseParameterLooking_Names.roll[#self.PoseParameterLooking_Names.roll + 1] = "aim_roll"
			end
			if self:LookupPoseParameter("head_roll") != -1 then
				self.PoseParameterLooking_Names.roll[#self.PoseParameterLooking_Names.roll + 1] = "head_roll"
			end
			if self.DisableWeapons then
				self:UpdateAnimationTranslations()
			else
				local wep = self:GetActiveWeapon()
				if IsValid(wep) then
					self.WeaponEntity = self:DoChangeWeapon() -- Setup the weapon
					self.WeaponInventory.Primary = wep
					if IsValid(self:GetCreator()) && self.CanChatMessage && !wep.IsVJBaseWeapon then
						self:GetCreator():PrintMessage(HUD_PRINTTALK, "WARNING: "..self:GetName().." requires a VJ Base weapon to work properly!")
					end
					local antiArmor = PICK(self.WeaponInventory_AntiArmorList)
					if antiArmor && wep:GetClass() != antiArmor then -- If the list isn't empty and it's not the current active weapon
						self.WeaponInventory.AntiArmor = self:Give(antiArmor)
						self:SelectWeapon(wep) -- Change the weapon back to the primary weapon
						wep:Equip(self)
					end
					local melee = PICK(self.WeaponInventory_MeleeList)
					if melee && wep:GetClass() != melee then -- If the list isn't empty and it's not the current active weapon
						self.WeaponInventory.Melee = self:Give(melee)
						self:SelectWeapon(wep) -- Change the weapon back to the primary weapon
						wep:Equip(self)
					end
				else
					self:UpdateAnimationTranslations()
					if IsValid(self:GetCreator()) && self.CanChatMessage && !self.Weapon_NoSpawnMenu then
						self:GetCreator():PrintMessage(HUD_PRINTTALK, "WARNING: "..self:GetName().." requires a weapon!")
					end
				end
			end
			if self:GetIdealActivity() == ACT_IDLE then -- Reset the idle animation in case animation translations changed it!
				self:MaintainIdleAnimation(true)
			end
			-- This is needed as setting "NextThink" to CurTime will cause performance drops, so we set the idle maintain in a separate hook that runs every tick
			local thinkHook = hook.GetTable()["Think"]
			if (thinkHook && !thinkHook[self]) or (!thinkHook) then
				if #self:GetBoneFollowers() > 0 then
					hook.Add("Think", self, function()
						if VJ_CVAR_AI_ENABLED then
							self:MaintainIdleAnimation()
						end
						self:UpdateBoneFollowers()
					end)
				else
					hook.Add("Think", self, function()
						if VJ_CVAR_AI_ENABLED then
							self:MaintainIdleAnimation()
						end
					end)
				end
			else
				VJ.DEBUG_Print(self, false, "warn", "has an existing embedded \"Think\" hook already, which is disallowing the default base hook from assigning. Make sure to handle \"MaintainIdleAnimation\" in the overridden hook!")
			end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local capBitsGround = bit.bor(CAP_MOVE_GROUND, CAP_MOVE_JUMP, CAP_MOVE_CLIMB, CAP_MOVE_SHOOT)
local capBitsShared = bit.bor(CAP_MOVE_GROUND, CAP_MOVE_JUMP, CAP_MOVE_CLIMB, CAP_MOVE_SHOOT, CAP_MOVE_FLY)
--
function ENT:DoChangeMovementType(movType)
	if movType then
		self.MovementType = movType
		if movType == VJ_MOVETYPE_GROUND then
			self:RemoveFlags(FL_FLY)
			self:CapabilitiesRemove(CAP_MOVE_FLY)
			self:SetNavType(NAV_GROUND)
			self:SetMoveType(MOVETYPE_STEP)
			self:CapabilitiesAdd(CAP_MOVE_GROUND)
			if (VJ.AnimExists(self, ACT_JUMP) && vj_npc_human_jump:GetInt() == 1) or self.UsePoseParameterMovement then self:CapabilitiesAdd(CAP_MOVE_JUMP) end
			//if VJ.AnimExists(self, ACT_CLIMB_UP) then self:CapabilitiesAdd(bit.bor(CAP_MOVE_CLIMB)) end
			if !self.DisableWeapons && self.Weapon_CanFireWhileMoving then self:CapabilitiesAdd(CAP_MOVE_SHOOT) end
		elseif movType == VJ_MOVETYPE_AERIAL or movType == VJ_MOVETYPE_AQUATIC then
			self:CapabilitiesRemove(capBitsGround)
			self:SetGroundEntity(NULL)
			self:AddFlags(FL_FLY)
			self:SetNavType(NAV_FLY)
			self:SetMoveType(MOVETYPE_STEP) // MOVETYPE_FLY = causes issues like Lerp functions not being smooth
			self:CapabilitiesAdd(CAP_MOVE_FLY)
		elseif movType == VJ_MOVETYPE_STATIONARY then
			self:RemoveFlags(FL_FLY)
			self:CapabilitiesRemove(capBitsShared)
			self:SetNavType(NAV_NONE)
			if !IsValid(self:GetParent()) then -- Only set move type if it does NOT have a parent!
				self:SetMoveType(MOVETYPE_FLY)
			end
		elseif movType == VJ_MOVETYPE_PHYSICS then
			self:RemoveFlags(FL_FLY)
			self:CapabilitiesRemove(capBitsShared)
			self:SetNavType(NAV_NONE)
			self:SetMoveType(MOVETYPE_VPHYSICS)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local schedule_alert_chaseLOS = vj_ai_schedule.New("SCHEDULE_ALERT_CHASE_LOS")
	schedule_alert_chaseLOS:EngTask("TASK_GET_PATH_TO_ENEMY_LOS", 0)
	//schedule_alert_chaseLOS:EngTask("TASK_RUN_PATH", 0)
	schedule_alert_chaseLOS:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
	//schedule_alert_chaseLOS:EngTask("TASK_FACE_ENEMY", 0)
	//schedule_alert_chaseLOS.ResetOnFail = true
	schedule_alert_chaseLOS.CanShootWhenMoving = true
	schedule_alert_chaseLOS.CanBeInterrupted = true
--
local schedule_alert_chase = vj_ai_schedule.New("SCHEDULE_ALERT_CHASE")
	schedule_alert_chase:EngTask("TASK_GET_PATH_TO_ENEMY", 0)
	schedule_alert_chase:EngTask("TASK_RUN_PATH", 0)
	schedule_alert_chase:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
	//schedule_alert_chase:EngTask("TASK_FACE_ENEMY", 0)
	//schedule_alert_chase.ResetOnFail = true
	schedule_alert_chase.CanShootWhenMoving = true
	schedule_alert_chase.CanBeInterrupted = true
--
function ENT:SCHEDULE_ALERT_CHASE(doLOSChase)
	self:ClearCondition(COND_ENEMY_UNREACHABLE)
	if self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then self:AA_ChaseEnemy() return end
	if self.CurrentScheduleName == "SCHEDULE_ALERT_CHASE" or self:GetNavType() == NAV_JUMP or self:GetNavType() == NAV_CLIMB then return end // && (self:GetEnemyLastKnownPos():Distance(self:GetEnemy():GetPos()) <= 12)
	if doLOSChase then
		schedule_alert_chaseLOS.RunCode_OnFinish = function()
			local ene = self:GetEnemy()
			if IsValid(ene) then
				self:RememberUnreachable(ene, 0)
				self:SCHEDULE_ALERT_CHASE(false)
			end
		end
		self:StartSchedule(schedule_alert_chaseLOS)
	else
		self:StartSchedule(schedule_alert_chase)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MaintainAlertBehavior(alwaysChase) -- alwaysChase = Override to always make the NPC chase
	local ene = self:GetEnemy()
	local curTime = CurTime()
	if self.NextChaseTime > curTime or self.Dead or self.VJ_IsBeingControlled or self.Flinching or self:GetState() == VJ_STATE_ONLY_ANIMATION_CONSTANT then return end
	if !IsValid(ene) or self.TakingCoverT > curTime or (self.AttackAnimTime > curTime && self.MovementType != VJ_MOVETYPE_AERIAL && self.MovementType != VJ_MOVETYPE_AQUATIC) then return end
	
	-- Not melee attacking yet but it is in range, so don't chase the enemy!
	if self.HasMeleeAttack && self.NearestPointToEnemyDistance < self.MeleeAttackDistance && self.EnemyData.IsVisible && (self:GetInternalVariable("m_latchedHeadDirection"):Dot((ene:GetPos() - self:GetPos()):GetNormalized()) > math_cos(math_rad(self.MeleeAttackAngleRadius))) then
		self:SCHEDULE_IDLE_STAND()
		return
	end
	
	-- Things that override can't bypass, Forces the NPC to ONLY idle stand!
	if self.MovementType == VJ_MOVETYPE_STATIONARY or self.IsFollowing or self.Medic_Status or self:GetState() == VJ_STATE_ONLY_ANIMATION then
		self:SCHEDULE_IDLE_STAND()
		return
	end
	
	-- Non-aggressive NPCs
	if self.Behavior == VJ_BEHAVIOR_PASSIVE or self.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE then
		self:SCHEDULE_COVER_ENEMY("TASK_RUN_PATH")
		self.NextChaseTime = curTime + 3
		return
	end
	
	if !alwaysChase && (self.DisableChasingEnemy or self.IsGuard) then self:SCHEDULE_IDLE_STAND() return end
	
	-- If the enemy is not reachable
	if (self:HasCondition(COND_ENEMY_UNREACHABLE) or self:IsUnreachable(ene)) && (IsValid(self:GetActiveWeapon()) && (!self:GetActiveWeapon().IsMeleeWeapon)) then
		self:SCHEDULE_ALERT_CHASE(true)
		self:RememberUnreachable(ene, 2)
	else -- Is reachable, so chase the enemy!
		self:SCHEDULE_ALERT_CHASE(false)
	end
	
	-- Set the next chase time
	if self.NextChaseTime > curTime then return end -- Don't set it if it's already set!
	self.NextChaseTime = curTime + (((self.LatestEnemyDistance > 2000) and 1) or 0.1) -- If the enemy is far, increase the delay!
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Overrides any activity by returning another activity
		- act = Activity that is being called to be translated
	Returns
		- Activity, the translated activity, otherwise it will return the given activity back
	RULES
		1. Always return an activity, never return nothing or a table!
			- Suggested to call `return self.BaseClass.TranslateActivity(self, act)` at the end of the function
		2. If you are replacing ACT_IDLE from a randomized table, then you must call `self:ResolveAnimation`
			- This is to ensure the idle animation system properly detects if it should be setting a new idle animation
-----------------------------------------------------------]]
function ENT:TranslateActivity(act)
	//VJ.DEBUG_Print(self, "TranslateActivity", act)
	-- Handle idle scared and angry animations
	if act == ACT_IDLE then
		if self.Weapon_UnarmedBehavior_Active then
			//return PICK(self.AnimTbl_ScaredBehaviorStand)
			return ACT_COWER
		elseif self.Alerted && self:GetWeaponState() != VJ.WEP_STATE_HOLSTERED && IsValid(self:GetActiveWeapon()) then
			//return PICK(self.AnimTbl_WeaponAim)
			return ACT_IDLE_ANGRY
		end
	-- Handle running while scared animation
	elseif act == ACT_RUN && self.Weapon_UnarmedBehavior_Active && !self.VJ_IsBeingControlled then
		// PICK(self.AnimTbl_ScaredBehaviorMovement)
		return ACT_RUN_PROTECTED
	elseif (act == ACT_RUN or act == ACT_WALK) && self.Alerted then
		-- Handle aiming while moving animations
		if self.Weapon_CanFireWhileMoving && IsValid(self:GetEnemy()) && (self.EnemyData.IsVisible or (self.EnemyData.LastVisibleTime + 5) > CurTime()) && self.CurrentSchedule != nil && self.CurrentSchedule.CanShootWhenMoving && self:CanFireWeapon(true, false) then
			local anim = self:TranslateActivity(act == ACT_RUN and ACT_RUN_AIM or ACT_WALK_AIM)
			if VJ.AnimExists(self, anim) then
				if self.EnemyData.IsVisible then
					self.WeaponAttackState = VJ.WEP_ATTACK_STATE_FIRE
				else -- Not visible but keep aiming
					self.WeaponAttackState = VJ.WEP_ATTACK_STATE_AIM_MOVE
				end
				return anim
			end
		end
		-- Handle walk/run angry animations
		local anim = self:TranslateActivity(act == ACT_RUN and ACT_RUN_AGITATED or ACT_WALK_AGITATED)
		if VJ.AnimExists(self, anim) then
			return anim
		end
	end
	
	-- Handle translations table
	local translation = self.AnimationTranslations[act]
	if translation then
		if istable(translation) then
			if act == ACT_IDLE then
				return self:ResolveAnimation(translation)
			end
			return translation[math.random(1, #translation)] or act -- "or act" = To make sure it doesn't return nil when the table is empty!
		else
			return translation
		end
	end
	return act
end
---------------------------------------------------------------------------------------------------------------------------------------------
local sdWepSwitch = {"physics/metal/weapon_impact_soft1.wav", "physics/metal/weapon_impact_soft2.wav", "physics/metal/weapon_impact_soft3.wav"}
--
function ENT:DoChangeWeapon(wep, invSwitch)
	wep = wep or nil -- The weapon to give or setup | Setting it nil will only setup the current active weapon
	invSwitch = invSwitch or false -- If true, it will not delete the previous weapon!
	local curWep = self:GetActiveWeapon()
	
	-- If not supposed to have a weapon, then return!
	if self.DisableWeapons && IsValid(curWep) then
		curWep:Remove()
		return NULL
	end
	
	-- Only remove and actually give the weapon if the function is given a weapon class to set
	if wep != nil then
		if invSwitch then
			self:SelectWeapon(wep)
			VJ.EmitSound(self, sdWepSwitch, 70)
			curWep = wep
		else
			if IsValid(curWep) && self.WeaponInventoryStatus <= VJ.WEP_INVENTORY_PRIMARY then
				curWep:Remove()
			end
			curWep = self:Give(wep)
			self.WeaponInventory.Primary = curWep
		end
	end
	
	-- If we are given a new weapon or switching weapon, then do all of the necessary set up
	if IsValid(curWep) then
		self.WeaponAttackAnim = ACT_INVALID
		self:SetWeaponState() -- Reset the weapon state because we do NOT want previous weapon's state to be used!
		if invSwitch then
			if curWep.IsVJBaseWeapon then curWep:Equip(self) end
		else -- If we are not switching weapons, then we know curWep is the primary weapon
			self.WeaponInventoryStatus = VJ.WEP_INVENTORY_PRIMARY
			-- If this is completely new weapon, then set the weapon inventory's primary to this weapon
			local curPrimary = self.WeaponInventory.Primary
			if curWep != self.WeaponInventory.Primary then
				if IsValid(curPrimary) then curPrimary:Remove() end -- Remove the old primary weapon
				self.WeaponInventory.Primary = curWep
			end
		end
		self:UpdateAnimationTranslations(curWep:GetHoldType())
		self:OnWeaponChange(curWep, self.WeaponEntity, invSwitch)
		self.WeaponEntity = curWep
	else
		self.WeaponInventoryStatus = VJ.WEP_INVENTORY_NONE
	end
	return curWep
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetWeaponState(state, time)
	time = time or -1
	self.WeaponState = state or VJ.WEP_STATE_READY
	if time >= 0 then
		timer.Create("timer_weapon_state_reset"..self:EntIndex(), time, 1, function()
			self:SetWeaponState()
		end)
	else
		timer.Remove("timer_weapon_state_reset"..self:EntIndex())
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetWeaponState()
	return self.WeaponState
end
---------------------------------------------------------------------------------------------------------------------------------------------
local finishAttack = {
	[VJ.ATTACK_TYPE_MELEE] = function(self, skipStopAttacks)
		if !skipStopAttacks then
			timer.Create("timer_melee_finished"..self:EntIndex(), self:DecideAttackTimer(self.NextAnyAttackTime_Melee, self.NextAnyAttackTime_Melee_DoRand, self.TimeUntilMeleeAttackDamage, self.AttackAnimDuration), 1, function()
				self:StopAttacks()
				self:MaintainAlertBehavior()
			end)
		end
		timer.Create("timer_melee_finished_ableto"..self:EntIndex(), self:DecideAttackTimer(self.NextMeleeAttackTime, self.NextMeleeAttackTime_DoRand), 1, function()
			self.IsAbleToMeleeAttack = true
		end)
	end,
	[VJ.ATTACK_TYPE_GRENADE] = function(self, skipStopAttacks)
		if !skipStopAttacks then
			timer.Create("timer_grenade_finished"..self:EntIndex(), self:DecideAttackTimer(self.NextAnyAttackTime_Grenade.a, self.NextAnyAttackTime_Grenade.b, self.TimeUntilGrenadeIsReleased, self.AttackAnimDuration), 1, function()
				self:StopAttacks()
				self:MaintainAlertBehavior()
			end)
		end
		//timer.Create("timer_grenade_finished_ableto"..self:EntIndex(), self:DecideAttackTimer(self.NextThrowGrenadeTime.a, self.NextThrowGrenadeTime.b), 1, function()
			//self.IsAbleToGrenadeAttack = true
		//end)
		self.NextThrowGrenadeT = CurTime() + self:DecideAttackTimer(self.NextThrowGrenadeTime.a, self.NextThrowGrenadeTime.b)
	end
}
---------------------------------------------------------------------------------------------------------------------------------------------
local function playReloadAnimation(self, anims)
	local anim, animDur, animType = self:PlayAnim(anims, true, false, "Visible")
	if anim != ACT_INVALID then
		local wep = self.WeaponEntity
		if wep.IsVJBaseWeapon then wep:NPC_Reload() end
		timer.Create("timer_weapon_reload"..self:EntIndex(), animDur, 1, function()
			if IsValid(self) && IsValid(wep) && self:GetWeaponState() == VJ.WEP_STATE_RELOADING then
				wep:SetClip1(wep:GetMaxClip1())
				if wep.IsVJBaseWeapon then wep:OnReload("Finish") end
				self:SetWeaponState()
			end
		end)
		self.AllowWeaponWaitOnOcclusion = false
		-- If NOT controlled by a player AND is a gesture make it stop moving so it doesn't run after the enemy right away
		if !self.VJ_IsBeingControlled && animType == ANIM_TYPE_GESTURE then
			self:StopMoving()
		end
		return true -- We have successfully ran the reload animation!
	end
	return false -- The given animation was invalid!
end
---------------------------------------------------------------------------------------------------------------------------------------------
//function ENT:OnActiveWeaponChanged(old, new) print(old, new) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	//if self.NextActualThink <= CurTime() then
		//self.NextActualThink = CurTime() + 0.065
	
	-- Schedule debug
	//if self.CurrentSchedule then PrintTable(self.CurrentSchedule) end
	//if self.CurrentTask then PrintTable(self.CurrentTask) end
	
	//self:SetCondition(1) -- Probably not needed as "sv_pvsskipanimation" handles it | Fix attachments, bones, positions, angles etc. being broken in NPCs! This condition is used as a backup in case "sv_pvsskipanimation" isn't disabled!
	//if self.MovementType == VJ_MOVETYPE_GROUND && self:GetVelocity():Length() <= 0 && !self:IsEFlagSet(EFL_IS_BEING_LIFTED_BY_BARNACLE) /*&& curSchedule.IsMovingTask*/ then self:DropToFloor() end -- No need, already handled by the engine
	
	local curTime = CurTime()
	
	-- This is here to make sure the initialized process time stays in place...
	-- otherwise if AI is disabled then reenabled, all the NPCs will now start processing at the same exact CurTime!
	local doHeavyProcesses = curTime > self.NextProcessT
	if doHeavyProcesses then
		self.NextProcessT = curTime + self.NextProcessTime
	end
	
	if !self.Dead then
		-- Detect any weapon change, unless the NPC is dead because the variable is used by self:DeathWeaponDrop()
		if self.WeaponEntity != self:GetActiveWeapon() then
			self.WeaponEntity = self:DoChangeWeapon()
		end
		
		-- Breath sound system
		if self.HasBreathSound && self.HasSounds && curTime > self.NextBreathSoundT then
			local pickedSD = PICK(self.SoundTbl_Breath)
			local dur = 10 -- Make the default value large so we don't check it too much!
			if pickedSD then
				StopSound(self.CurrentBreathSound)
				dur = (self.NextSoundTime_Breath == false and SoundDuration(pickedSD)) or math.Rand(self.NextSoundTime_Breath.a, self.NextSoundTime_Breath.b)
				self.CurrentBreathSound = VJ.CreateSound(self, pickedSD, self.BreathSoundLevel, self:GetSoundPitch(self.BreathSoundPitch.a, self.BreathSoundPitch.b))
			end
			self.NextBreathSoundT = curTime + dur
		end
	end
	
	self:OnThink()
	--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
	if VJ_CVAR_AI_ENABLED && self:GetState() != VJ_STATE_FREEZE && !self:IsEFlagSet(EFL_IS_BEING_LIFTED_BY_BARNACLE) then
		if self.VJ_DEBUG then
			if GetConVar("vj_npc_debug_enemy"):GetInt() == 1 then VJ.DEBUG_Print(self, false, "Enemy -> " .. tostring(self:GetEnemy() or "NULL") .. " | Alerted? " .. tostring(self.Alerted))  end
			if GetConVar("vj_npc_debug_takingcover"):GetInt() == 1 then if curTime > self.TakingCoverT then VJ.DEBUG_Print(self, false, "NOT taking cover") else VJ.DEBUG_Print(self, false, "Taking cover ("..self.TakingCoverT - curTime..")") end end
			if GetConVar("vj_npc_debug_lastseenenemytime"):GetInt() == 1 then PrintMessage(HUD_PRINTTALK, (curTime - self.EnemyData.LastVisibleTime).." ("..self:GetName()..")") end
			if IsValid(self.WeaponEntity) && GetConVar("vj_npc_debug_weapon"):GetInt() == 1 then VJ.DEBUG_Print(self, false, " : Weapon -> " .. tostring(self.WeaponEntity) .. " | Ammo: "..self.WeaponEntity:Clip1().." / "..self.WeaponEntity:GetMaxClip1().." | Accuracy: "..self.Weapon_Accuracy) end
		end
		
		//self:SetPlaybackRate(self.AnimationPlaybackRate)
		self:OnThinkActive()
		
		-- Update follow system's data
		//print("------------------")
		//PrintTable(self.FollowData)
		if self.IsFollowing && self:GetNavType() != NAV_JUMP && self:GetNavType() != NAV_CLIMB then
			local followData = self.FollowData
			local followEnt = followData.Ent
			local followIsLiving = followEnt.VJ_ID_Living
			//print(self:GetTarget())
			if IsValid(followEnt) && (!followIsLiving or (followIsLiving && (self:Disposition(followEnt) == D_LI or self:GetClass() == followEnt:GetClass()) && followEnt:Alive())) then
				if curTime > followData.NextUpdateT && !self.VJ_ST_Healing then
					local distToPly = self:GetPos():Distance(followEnt:GetPos())
					local busy = self:BusyWithActivity()
					self:SetTarget(followEnt)
					followData.StopAct = false
					if distToPly > followData.MinDist then -- Entity is far away, move towards it!
						local isFar = distToPly > (followData.MinDist * 4)
						-- IF (we are busy but far) OR (not busy) THEN move
						if (busy && isFar) or (!busy) then
							followData.Moving = true
							-- If we are far then stop all activities (ex: attacks) and just go there already!
							if isFar then
								followData.StopAct = true
							end
							if self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then
								self:AA_MoveTo(self:GetTarget(), true, (distToPly < (followData.MinDist * 1.5) and "Calm") or "Alert", {FaceDestTarget = true})
							elseif !self:IsMoving() or self:GetCurGoalType() != 1 then
								//self:NavSetGoalTarget(followEnt) // local goalTarget = -- No longer works, a recent GMod commit broke it
								-- Do NOT check for validity! Let it be sent to "OnTaskFailed" so an NPC can capture it! (Ex: HL1 scientist complaining to the player)
								//if goalTarget then
								local schedule = vj_ai_schedule.New("SCHEDULE_FOLLOW")
								schedule:EngTask("TASK_GET_PATH_TO_TARGET", 0) -- Required to generate the path!
								schedule:EngTask("TASK_MOVE_TO_TARGET_RANGE", followData.MinDist * 0.8)
								schedule:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
								schedule:EngTask("TASK_FACE_TARGET", 1)
								schedule.CanShootWhenMoving = true
								if IsValid(self:GetActiveWeapon()) then
									schedule.FaceData = {Type = VJ.FACE_ENEMY_VISIBLE}
								end
								self:StartSchedule(schedule)
								//else
								//	self:ClearGoal()
								//end
								/*self:SCHEDULE_GOTO_TARGET((distToPly < (followData.MinDist * 1.5) and "TASK_WALK_PATH") or "TASK_RUN_PATH", function(schedule)
									schedule.CanShootWhenMoving = true
									if IsValid(self:GetActiveWeapon()) then
										schedule.FaceData = {Type = VJ.FACE_ENEMY_VISIBLE}
									end
								end)*/
							end
						end
					elseif followData.Moving == true then -- Entity is very close, stop moving!
						if !busy then -- If not busy then make it stop moving and do something
							self:TaskComplete()
							self:StopMoving(false)
							self:SelectSchedule()
						end
						followData.Moving = false
					end
					followData.NextUpdateT = curTime + self.NextFollowUpdateTime
				end
			else
				self:ResetFollowBehavior()
			end
		end

		-- Handle main parts of the turning system
		local turnData = self.TurnData
		if turnData.Type then
			-- If StopOnFace flag is set AND (Something has requested to take over by checking "ideal yaw != last set yaw") OR (we are facing ideal) then finish it!
			if turnData.StopOnFace && (self:GetIdealYaw() != turnData.LastYaw or self:IsFacingIdealYaw()) then
				self:ResetTurnTarget()
			else
				self.TurnData.LastYaw = 0 -- To make sure the turning maintain works correctly
				local turnTarget = turnData.Target
				if turnData.Type == VJ.FACE_POSITION or (turnData.Type == VJ.FACE_POSITION_VISIBLE && self:VisibleVec(turnTarget)) then
					local resultAng = self:GetTurnAngle((turnTarget - self:GetPos()):Angle())
					if self.TurningUseAllAxis then
						local myAng = self:GetAngles()
						self:SetAngles(LerpAngle(FrameTime()*self.TurningSpeed, myAng, Angle(resultAng.p, myAng.y, resultAng.r)))
					end
					self:SetIdealYawAndUpdate(resultAng.y)
					self.TurnData.LastYaw = resultAng.y
				elseif IsValid(turnTarget) && (turnData.Type == VJ.FACE_ENTITY or (turnData.Type == VJ.FACE_ENTITY_VISIBLE && self:Visible(turnTarget))) then
					local resultAng = self:GetTurnAngle((turnTarget:GetPos() - self:GetPos()):Angle())
					if self.TurningUseAllAxis then
						local myAng = self:GetAngles()
						self:SetAngles(LerpAngle(FrameTime()*self.TurningSpeed, myAng, Angle(resultAng.p, myAng.y, resultAng.r)))
					end
					self:SetIdealYawAndUpdate(resultAng.y)
					self.TurnData.LastYaw = resultAng.y
				end
			end
		end
		
		//print("MAX CLIP: ", self.WeaponEntity:GetMaxClip1())
		//print("CLIP: ", self.WeaponEntity:Clip1())
			
		if !self.Dead then
			-- Health Regeneration System
			if self.HasHealthRegeneration && curTime > self.HealthRegenerationDelayT then
				local myHP = self:Health()
				self:SetHealth(math_min(math_max(myHP + self.HealthRegenerationAmount, myHP), self:GetMaxHealth()))
				self.HealthRegenerationDelayT = curTime + math.Rand(self.HealthRegenerationDelay.a, self.HealthRegenerationDelay.b)
			end
			
			-- Run the heavy processes
			if doHeavyProcesses then
				self:MaintainRelationships()
				self:CheckForDangers()
				self:MaintainMedicBehavior()
				//self.NextProcessT = curTime + self.NextProcessTime
			end
			
			local plyControlled = self.VJ_IsBeingControlled
			local myPos = self:GetPos()
			local ene = self:GetEnemy()
			local eneValid = IsValid(ene)
			local eneData = self.EnemyData
			if !eneData.Reset then
				-- Reset enemy if it doesn't exist or it's dead
				if !eneValid then
					self:ResetEnemy(true, true)
					ene = self:GetEnemy()
					eneValid = IsValid(ene)
				-- Reset enemy if it has been unseen for a while
				elseif (curTime - eneData.LastVisibleTime) > ((self.LatestEnemyDistance < 4000 and self.TimeUntilEnemyLost) or (self.TimeUntilEnemyLost / 2)) && !self.IsVJBaseSNPC_Tank then
					self:PlaySoundSystem("LostEnemy")
					self:ResetEnemy(true, true)
					ene = self:GetEnemy()
					eneValid = IsValid(ene)
				end
			end
			
			local curWep = self.WeaponEntity
			//if self.WeaponAttackState then self:CapabilitiesRemove(CAP_TURN_HEAD) else self:CapabilitiesAdd(CAP_TURN_HEAD) end -- Fixes their heads breaking
			-- If we have a valid weapon...
			if IsValid(curWep) && !self:BusyWithActivity() then
				-- Weapon Inventory System
				if !plyControlled then
					if eneValid then
						-- Switch to melee
						if !self.IsGuard && IsValid(self.WeaponInventory.Melee) && ((self.LatestEnemyDistance < self.MeleeAttackDistance) or (self.LatestEnemyDistance < 300 && curWep:Clip1() <= 0)) && (self:Health() > self:GetMaxHealth() * 0.25) && curWep != self.WeaponInventory.Melee then
							if self:GetWeaponState() == VJ.WEP_STATE_RELOADING then self:SetWeaponState() end -- Since the reloading can be cut off, reset it back to false, or else it can mess up its behavior!
							//timer.Remove("timer_weapon_reload"..self:EntIndex()) -- No longer needed
							self.WeaponInventoryStatus = VJ.WEP_INVENTORY_MELEE
							self:DoChangeWeapon(self.WeaponInventory.Melee, true)
							curWep = self.WeaponEntity
						-- Switch to anti-armor
						elseif self:GetWeaponState() != VJ.WEP_STATE_RELOADING && IsValid(self.WeaponInventory.AntiArmor) && (ene.IsVJBaseSNPC_Tank or ene.VJ_ID_Boss) && curWep != self.WeaponInventory.AntiArmor then
							self.WeaponInventoryStatus = VJ.WEP_INVENTORY_ANTI_ARMOR
							self:DoChangeWeapon(self.WeaponInventory.AntiArmor, true)
							curWep = self.WeaponEntity
						end
					end
					if self:GetWeaponState() != VJ.WEP_STATE_RELOADING then
						-- Reset weapon status from melee to primary
						if self.WeaponInventoryStatus == VJ.WEP_INVENTORY_MELEE && (!eneValid or (eneValid && self.LatestEnemyDistance >= 300)) then
							self.WeaponInventoryStatus = VJ.WEP_INVENTORY_PRIMARY
							self:DoChangeWeapon(self.WeaponInventory.Primary, true)
							curWep = self.WeaponEntity
						-- Reset weapon status from anti-armor to primary
						elseif self.WeaponInventoryStatus == VJ.WEP_INVENTORY_ANTI_ARMOR && (!eneValid or (eneValid && !ene.IsVJBaseSNPC_Tank && !ene.VJ_ID_Boss)) then
							self.WeaponInventoryStatus = VJ.WEP_INVENTORY_PRIMARY
							self:DoChangeWeapon(self.WeaponInventory.Primary, true)
							curWep = self.WeaponEntity
						end
					end
				end
				
				-- Weapon Reloading
				if self.Weapon_CanReload && self:GetWeaponState() == VJ.WEP_STATE_READY && (!curWep.IsMeleeWeapon) && !self.AttackType && ((!plyControlled && ((!eneValid && curWep:GetMaxClip1() > curWep:Clip1() && (curTime - eneData.TimeSet) > math.random(3, 8) && !self:IsMoving()) or (eneValid && curWep:Clip1() <= 0))) or (plyControlled && self.VJ_TheController:KeyDown(IN_RELOAD) && curWep:GetMaxClip1() > curWep:Clip1())) then
					self.WeaponAttackState = VJ.WEP_ATTACK_STATE_NONE
					self.NextChaseTime = curTime + 2
					if !plyControlled then self:SetWeaponState(VJ.WEP_STATE_RELOADING) end
					if eneValid then self:PlaySoundSystem("WeaponReload") end -- tsayn han e minag yete teshnami ga!
					self:OnWeaponReload()
					if self.DisableWeaponReloadAnimation then -- Reload animation is disabled
						if self:GetWeaponState() == VJ.WEP_STATE_RELOADING then self:SetWeaponState() end
						curWep:SetClip1(curWep:GetMaxClip1())
						if curWep.IsVJBaseWeapon then curWep:NPC_Reload() end
					else
						-- Controlled by a player...
						if plyControlled then
							self:SetWeaponState(VJ.WEP_STATE_RELOADING)
							playReloadAnimation(self, self:TranslateActivity(PICK(self.AnimTbl_WeaponReload)))
						-- NOT controlled by a player...
						else
							-- NPC is hidden, so attempt to crouch reload
							if eneValid && self:DoCoverTrace(myPos + self:OBBCenter(), ene:EyePos(), false, {SetLastHiddenTime=true}) then
								-- if It does NOT have a cover reload animation, then just play the regular standing reload animation
								if !playReloadAnimation(self, self:TranslateActivity(PICK(self.AnimTbl_WeaponReloadCovered))) then
									playReloadAnimation(self, self:TranslateActivity(PICK(self.AnimTbl_WeaponReload)))
								end
							-- NPC is NOT hidden...
							else
								-- Under certain situations, simply do standing reload without running to a hiding spot
								if !self.Weapon_FindCoverOnReload or self.IsGuard or self.IsFollowing or self.VJ_IsBeingControlled_Tool or !eneValid or self.MovementType == VJ_MOVETYPE_STATIONARY or self.LatestEnemyDistance < 650 then
									playReloadAnimation(self, self:TranslateActivity(PICK(self.AnimTbl_WeaponReload)))
								else -- If all is good, then run to a hiding spot and reload!
									local schedule = vj_ai_schedule.New("SCHEDULE_COVER_RELOAD")
									schedule:EngTask("TASK_FIND_COVER_FROM_ENEMY", 0)
									schedule:EngTask("TASK_RUN_PATH", 0)
									schedule:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
									schedule.RunCode_OnFinish = function()
										if self:GetWeaponState() == VJ.WEP_STATE_RELOADING then
											-- If the current situation isn't favorable, then abandon the current reload, and try again!
											if self.AttackType or (IsValid(self:GetEnemy()) && self.LatestEnemyDistance <= self.Weapon_RetreatDistance) then
												self:SetWeaponState()
												//timer.Remove("timer_weapon_reload"..self:EntIndex()) -- Remove the timer to make sure it doesn't set reloading to false at a random time (later on)
											else -- Our hiding spot is good, so reload!
												playReloadAnimation(self, self:TranslateActivity(PICK(self.AnimTbl_WeaponReload)))
											end
										end
									end
									self:StartSchedule(schedule)
								end
							end
						end
					end
				end
			end
		
			if eneValid then
				local enePos = ene:GetPos()
				local eneDist = myPos:Distance(enePos)
				local eneDistNear = VJ.GetNearestDistance(self, ene, true)
				local eneIsVisible = plyControlled and true or self:Visible(ene)
				
				-- Set latest enemy information
				self:UpdateEnemyMemory(ene, enePos)
				eneData.Reset = false
				eneData.IsVisible = eneIsVisible
				self.LatestEnemyDistance = eneDist
				self.NearestPointToEnemyDistance = eneDistNear
				local firingWep = self.WeaponAttackState && self.WeaponAttackState >= VJ.WEP_ATTACK_STATE_FIRE
				if eneIsVisible then
					if self:IsInViewCone(enePos) && (eneDist < self:GetMaxLookDistance()) then
						eneData.LastVisibleTime = curTime
						-- Why 2 vars? Because the last "Visible" tick is usually not updated in time, causing the engine to give false positive, thinking the enemy IS visible
						eneData.LastVisiblePos = eneData.LastVisiblePosReal
						eneData.LastVisiblePosReal = ene:EyePos() -- Use EyePos because "Visible" uses it to run the trace in the engine! | For origin, use "self:GetEnemyLastSeenPos()"
					end
					if firingWep then self:PlaySoundSystem("Suppressing") end
				elseif firingWep then
					self.WeaponAttackState = VJ.WEP_ATTACK_STATE_NONE
				end
				
				-- Turning / Facing Enemy
				if self.ConstantlyFaceEnemy then self:MaintainConstantlyFaceEnemy() end
				turnData = self.TurnData
				if turnData.Type == VJ.FACE_ENEMY or (turnData.Type == VJ.FACE_ENEMY_VISIBLE && eneIsVisible) then
					local resultAng = self:GetTurnAngle((enePos - myPos):Angle())
					if self.TurningUseAllAxis then
						local myAng = self:GetAngles()
						self:SetAngles(LerpAngle(FrameTime()*self.TurningSpeed, myAng, Angle(resultAng.p, myAng.y, resultAng.r)))
					end
					self:SetIdealYawAndUpdate(resultAng.y)
					self.TurnData.LastYaw = resultAng.y
				end

				-- Call for help
				if self.CallForHelp && curTime > self.NextCallForHelpT && !self.AttackType then
					self:Allies_CallHelp(self.CallForHelpDistance)
					self.NextCallForHelpT = curTime + self.NextCallForHelpTime
				end
				
				self:UpdatePoseParamTracking()
				
				if !self.PauseAttacks && self:GetState() != VJ_STATE_ONLY_ANIMATION_NOATTACK && self.Behavior != VJ_BEHAVIOR_PASSIVE && self.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE && curTime > self.NextDoAnyAttackT then
					-- Attack priority in order: Custom --> Melee --> Grenade
					-- To avoid overlapping situations where 2 attacks can be called at once, check for "self.AttackType == VJ.ATTACK_TYPE_NONE"
					local funcCustomAtk = self.CustomAttack; if funcCustomAtk then funcCustomAtk(self, ene, eneIsVisible) end
					-- Melee Attack
					if self.HasMeleeAttack && self.IsAbleToMeleeAttack && !self.Flinching && !self.FollowData.StopAct && !self.AttackType && (!IsValid(curWep) or (IsValid(curWep) && (!curWep.IsMeleeWeapon))) && ((plyControlled && self.VJ_TheController:KeyDown(IN_ATTACK)) or (!plyControlled && (eneDistNear < self.MeleeAttackDistance && eneIsVisible) && (self:GetInternalVariable("m_latchedHeadDirection"):Dot((enePos - myPos):GetNormalized()) > math_cos(math_rad(self.MeleeAttackAngleRadius))))) then
						local seed = curTime; self.AttackSeed = seed
						self.AttackType = VJ.ATTACK_TYPE_MELEE
						self.AttackState = VJ.ATTACK_STATE_STARTED
						self.IsAbleToMeleeAttack = false
						self.AttackAnim = ACT_INVALID
						self.AttackAnimDuration = 0
						self.AttackAnimTime = 0
						self:SetTurnTarget("Enemy") -- Always turn towards the enemy at the start
						self:CustomOnMeleeAttack_BeforeStartTimer(seed)
						self:PlaySoundSystem("BeforeMeleeAttack")
						self.NextAlertSoundT = curTime + 0.4
						if self.DisableMeleeAttackAnimation == false then
							local anim, animDur, animType = self:PlayAnim(self.AnimTbl_MeleeAttack, false, 0, false, self.MeleeAttackAnimationDelay)
							if anim != ACT_INVALID then
								self.AttackAnim = anim
								self.AttackAnimDuration = animDur - (self.MeleeAttackAnimationDecreaseLengthAmount / self.AnimPlaybackRate)
								if animType != ANIM_TYPE_GESTURE then -- Useful for gesture-based attacks, it allows things like chasing to continue running
									self.AttackAnimTime = curTime + self.AttackAnimDuration
								end
							end
						end
						if self.TimeUntilMeleeAttackDamage == false then
							finishAttack[VJ.ATTACK_TYPE_MELEE](self)
						else -- If it's not event based...
							timer.Create("timer_melee_start"..self:EntIndex(), self.TimeUntilMeleeAttackDamage / self.AnimPlaybackRate, self.MeleeAttackReps, function() if self.AttackSeed == seed then self:MeleeAttackCode() end end)
							if self.MeleeAttackExtraTimers then
								for k, t in ipairs(self.MeleeAttackExtraTimers) do
									self:AddExtraAttackTimer("timer_melee_start"..curTime + k, t, function() if self.AttackSeed == seed then self:MeleeAttackCode() end end)
								end
							end
						end
						self:CustomOnMeleeAttack_AfterStartTimer(seed)
					end
					
					-- Grenade attack
					if self.HasGrenadeAttack && self:GetWeaponState() != VJ.WEP_STATE_RELOADING && !self:BusyWithActivity() && curTime > self.NextThrowGrenadeT && curTime > self.TakingCoverT then
						if plyControlled then
							if self.VJ_TheController:KeyDown(IN_JUMP) then
								self:GrenadeAttack()
								self.NextThrowGrenadeT = curTime + math.random(self.NextThrowGrenadeTime.a, self.NextThrowGrenadeTime.b)
							end
						else
							local chance = self.GrenadeAttackChance
							-- If chance is above 4, then half it by 2 if the enemy is a tank OR not visible
							if math.random(1, (chance > 3 && (ene.IsVJBaseSNPC_Tank or !eneIsVisible) and math.floor(chance / 2)) or chance) == 1 && eneDist < self.GrenadeAttackThrowDistance && eneDist > self.GrenadeAttackThrowDistanceClose then
								self:GrenadeAttack()
							end
							self.NextThrowGrenadeT = curTime + math.random(self.NextThrowGrenadeTime.a, self.NextThrowGrenadeTime.b)
						end
					end
				end
				
				-- Face enemy for stationary types OR attacks
				if (self.MovementType == VJ_MOVETYPE_STATIONARY && self.CanTurnWhileStationary) or (self.AttackType && ((self.MeleeAttackAnimationFaceEnemy && self.AttackType == VJ.ATTACK_TYPE_MELEE) or (self.GrenadeAttackAnimationFaceEnemy && self.AttackType == VJ.ATTACK_TYPE_GRENADE && eneIsVisible))) then
					self:SetTurnTarget("Enemy")
				end
			else -- No Enemy
				self.WeaponAttackState = VJ.WEP_ATTACK_STATE_NONE
				if !self.Alerted && self.UpdatedPoseParam && !plyControlled then
					self:ClearPoseParameters()
					self.UpdatedPoseParam = false
				end
				eneData.TimeSinceAcquired = 0
			end
			
			-- Guarding Position
			if self.IsGuard && !self.IsFollowing then
				if !self.GuardingPosition then -- If it hasn't been set then set the guard position to its current position
					self.GuardingPosition = myPos
					self.GuardingDirection = myPos + self:GetForward()*51
				end
				-- If it's far from the guarding position, then go there!
				if !self:IsMoving() && !self:BusyWithActivity() then
					local dist = myPos:Distance(self.GuardingPosition) -- Distance to the guard position
					if dist > 50 then
						self:SetLastPosition(self.GuardingPosition)
						self:SCHEDULE_GOTO_POSITION(dist <= 800 and "TASK_WALK_PATH" or "TASK_RUN_PATH", function(x)
							x.CanShootWhenMoving = true
							x.FaceData = {Type = VJ.FACE_ENEMY}
							x.RunCode_OnFinish = function()
								timer.Simple(0.01, function()
									if IsValid(self) && !self:IsMoving() && !self:BusyWithActivity() && self.GuardingDirection then
										self:SetLastPosition(self.GuardingDirection)
										self:SCHEDULE_FACE("TASK_FACE_LASTPOSITION")
									end
								end)
							end
						end)
					end
				end
			end
		end
		-- Handle the unique movement system for player models
		if self.UsePoseParameterMovement && self.MovementType == VJ_MOVETYPE_GROUND then
			local moveDir = VJ.GetMoveDirection(self, true)
			if moveDir then
				self:SetPoseParameter("move_x", moveDir.x)
				self:SetPoseParameter("move_y", moveDir.y)
			else -- I am not moving, reset the pose parameters, otherwise I will run in place!
				self:SetPoseParameter("move_x", 0)
				self:SetPoseParameter("move_y", 0)
			end
		end
	else -- AI Not enabled
		self.WeaponAttackState = VJ.WEP_ATTACK_STATE_NONE
	end
	
	//if aiEnabled then
		//self:MaintainIdleAnimation()
	//end
	
	-- Maintain turning when needed otherwise Engine will take over during movements!
	-- No longer needed as "OverrideMoveFacing" now handles it!
	/*if !didTurn then
		local curTurnData = self.TurnData
		if curTurnData.Type && curTurnData.LastYaw != 0 then
			self:SetIdealYawAndUpdate(curTurnData.LastYaw)
			didTurn = true
		end
	end*/
	
	self:NextThink(curTime + 0.065)
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MeleeAttackCode()
	if self.Dead or self.PauseAttacks or self.Flinching or self.AttackType == VJ.ATTACK_TYPE_GRENADE or (self.StopMeleeAttackAfterFirstHit && self.AttackState == VJ.ATTACK_STATE_EXECUTED_HIT) then return end
	self:CustomOnMeleeAttack_BeforeChecks()
	if self.DisableDefaultMeleeAttackCode then return end
	local myPos = self:GetPos()
	local myClass = self:GetClass()
	local hitRegistered = false
	for _, ent in ipairs(ents.FindInSphere(self:GetMeleeAttackDamageOrigin(), self.MeleeAttackDamageDistance)) do
		if ent == self or ent:GetClass() == myClass or (ent.IsVJBaseBullseye && ent.VJ_IsBeingControlled) then continue end
		if ent:IsPlayer() && (ent.VJ_IsControllingNPC or !ent:Alive() or VJ_CVAR_IGNOREPLAYERS) then continue end
		if ((ent.VJ_ID_Living && self:Disposition(ent) != D_LI) or ent.VJ_ID_Attackable or ent.VJ_ID_Destructible) && self:GetInternalVariable("m_latchedHeadDirection"):Dot((Vector(ent:GetPos().x, ent:GetPos().y, 0) - Vector(myPos.x, myPos.y, 0)):GetNormalized()) > math_cos(math_rad(self.MeleeAttackDamageAngleRadius)) then
			local isProp = ent.VJ_ID_Attackable
			if self:CustomOnMeleeAttack_AfterChecks(ent, isProp) == true then continue end
			-- Knockback (Don't push things like doors, trains, elevators as it will make them fly when activated)
			if self.HasMeleeAttackKnockBack && ent:GetMoveType() != MOVETYPE_PUSH && ent.MovementType != VJ_MOVETYPE_STATIONARY && (!ent.VJ_ID_Boss or ent.IsVJBaseSNPC_Tank) then
				ent:SetGroundEntity(NULL)
				ent:SetVelocity(self:MeleeAttackKnockbackVelocity(ent))
			end
			-- Apply actual damage
			if !self.DisableDefaultMeleeAttackDamageCode then
				local applyDmg = DamageInfo()
				applyDmg:SetDamage(self:ScaleByDifficulty(self.MeleeAttackDamage))
				applyDmg:SetDamageType(self.MeleeAttackDamageType)
				if ent.VJ_ID_Living then applyDmg:SetDamageForce(self:GetForward() * ((applyDmg:GetDamage() + 100) * 70)) end
				applyDmg:SetInflictor(self)
				applyDmg:SetAttacker(self)
				VJ.DamageSpecialEnts(self, ent, applyDmg)
				ent:TakeDamageInfo(applyDmg, self)
			end
			if ent:IsPlayer() then
				ent:ViewPunch(Angle(math.random(-1, 1) * self.MeleeAttackDamage, math.random(-1, 1) * self.MeleeAttackDamage, math.random(-1, 1) * self.MeleeAttackDamage))
			end
			if !isProp then -- Only for non-props...
				hitRegistered = true
				if self.StopMeleeAttackAfterFirstHit then break end
			end
		end
	end
	if self.AttackState < VJ.ATTACK_STATE_EXECUTED then
		self.AttackState = VJ.ATTACK_STATE_EXECUTED
		if self.TimeUntilMeleeAttackDamage != false then
			finishAttack[VJ.ATTACK_TYPE_MELEE](self)
		end
	end
	if hitRegistered then
		self:PlaySoundSystem("MeleeAttack")
		self.AttackState = VJ.ATTACK_STATE_EXECUTED_HIT
	else
		self:CustomOnMeleeAttack_Miss()
		self:PlaySoundSystem("MeleeAttackMiss", nil, VJ.EmitSound)
	end
end

---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Performs a grenade attack
		- customEnt = What entity it should throw | DEFAULT: nil
			- nil = Spawn the NPC's default grenade class usually set by "self.GrenadeAttackEntity"
			- string = Spawn the given entity class as the grenade
			- entity = Use the given entity as the grenade by changing its parent to the NPC and altering its position
		- disableOwner = If set to true, the NPC will not be set as the owner of the grenade, allowing it to damage itself and its allies when applicable!
	Returns
		- false, Grenade attack was canceled
-----------------------------------------------------------]]
function ENT:GrenadeAttack(customEnt, disableOwner)
	if self.Dead or self.Flinching or self.AttackType == VJ.ATTACK_TYPE_MELEE then return false end
	local eneData = self.EnemyData
	local ene = self:GetEnemy()
	local isLiveEnt = IsValid(customEnt)
	local landDir = false -- 0 = Enemy's position | 1 = Enemy's last visible position | anything else = Best position
	local seed = CurTime(); self.AttackSeed = seed

	-- Handle possible destinations:
		-- Enemy not valid --> Best position away from the NPC and allies
		-- Enemy valid AND Enemy visible --> Enemy's position
		-- Enemy valid AND Enemy not visible AND last seen position is visible --> Enemy's last visible position
		-- Enemy valid AND Enemy not visible AND last seen position is not visible --> Cancel attack
		-- Enemy valid AND Enemy not visible AND last seen position is not visible AND grenade is live throw back --> Best position away from the NPC and allies
	if IsValid(ene) then
		-- If enemy is visible then face them!
		if eneData.IsVisible then
			landDir = 0 -- If enemy is visible leave then do NOT face random pos, even if "self.GrenadeAttackAnimationFaceEnemy" is disabled!
		else -- We have a hidden enemy...
			-- Attempt to flush the enemy out of hiding
			if self:VisibleVec(eneData.LastVisiblePos) && ene:GetPos():Distance(eneData.LastVisiblePos) <= self.GrenadeAttackThrowDistance then // self.GrenadeAttackThrowDistance
				landDir = 1 -- We are going to face flush position, do NOT face random pos!
			-- If can't flush the enemy, then face random open position ONLY if we are given a live entity, otherwise...
			-- If live entity is NOT given and it's allowed to continue, it will cause the NPC to throw a grenade when both the enemy and its flush position are hidden!
			elseif !isLiveEnt then
				return false
			end
		end
	end
	
	-- Handle animations
	self.AttackAnim = ACT_INVALID
	self.AttackAnimDuration = 0
	self.AttackAnimTime = 0
	if self.DisableGrenadeAttackAnimation == false then
		local anim, animDur = self:PlayAnim(self.AnimTbl_GrenadeAttack, false, 0, false, self.GrenadeAttackAnimationDelay)
		if anim != ACT_INVALID then
			self.AttackAnim = anim
			self.AttackAnimDuration = animDur
			self.AttackAnimTime = CurTime() + self.AttackAnimDuration
		end
	end
	
	if landDir == 0 then -- Face enemy
		if self.GrenadeAttackAnimationFaceEnemy then
			self:SetTurnTarget("Enemy")
		end
	elseif landDir == 1 then -- Face enemy's last visible pos
		self:SetTurnTarget(eneData.LastVisiblePos, self.AttackAnimDuration or 1.5)
	else -- Face best pos
		local bestPos = PICK(VJ.TraceDirections(self, "Quick", 200, true, false, 8))
		if bestPos then
			landDir = bestPos -- Save the position so it can be used when it's thrown
			self:SetTurnTarget(bestPos, self.AttackAnimDuration or 1.5)
		end
	end
	
	-- Handle situation where already spawned entity is given | EX: Grenade picked up by the NPC
	if isLiveEnt then
		customEnt.VJ_ST_Grabbed = true
		customEnt.VJ_ST_GrabOrgMoveType = customEnt:GetMoveType()
		-- Change the grenade's position so the NPC is actively holding it, in order with priority:
			-- 1. CUSTOM 		If custom position is given then use that, otherwise...
			-- 2. ATTACHMENT 	If a valid attachment is given then use that, otherwise...
			-- 3. BONE 			If a valid bone is given then use that, otherwise...
			-- 4. FAIL 			Use the NPC's shoot position (fail safe)
		local customPos = self:OnGrenadeAttack("SpawnPos", nil, customEnt, landDir, nil)
		if !customPos then -- If no custom position is given...
			local getAttach = self:LookupAttachment(self.GrenadeAttackAttachment)
			if !getAttach or getAttach == 0 or getAttach == -1 then -- Attachment invalid, try bone...
				local getBone = self:LookupBone(self.GrenadeAttackBone)
				if getBone then -- Bone valid
					local bonePos, boneAng = self:GetBonePosition(getBone)
					customEnt:SetPos(bonePos)
					customEnt:SetAngles(boneAng)
					customEnt:FollowBone(self, getBone) -- Calls SetParent internally
				else -- Fail safe! (All cases failed)
					customEnt:SetPos(self:GetShootPos())
					//customEnt:SetAngles(self:GetShootPos():Angle()) -- No need as this is a fail safe anyway
					customEnt:SetParent(self)
				end
			else -- Attachment valid
				local attachData = self:GetAttachment(getAttach)
				customEnt:SetMoveType(MOVETYPE_NONE) -- Must set this for attachments to have any effect!
				customEnt:SetParent(self, getAttach)
				customEnt:SetPos(attachData.Pos)
				customEnt:SetAngles(attachData.Ang)
			end
		else -- Custom position valid
			customEnt:SetPos(customPos)
			customEnt:SetAngles(customPos:Angle())
			customEnt:SetParent(self)
		end
	end

	self.AttackType = VJ.ATTACK_TYPE_GRENADE
	self.AttackState = VJ.ATTACK_STATE_STARTED
	self:OnGrenadeAttack("Start", nil, customEnt, landDir, nil)
	self:PlaySoundSystem("GrenadeAttack")
	
	local releaseTime = self.TimeUntilGrenadeIsReleased
	if releaseTime == false then -- Call this right away for event-based attacks!
		finishAttack[VJ.ATTACK_TYPE_GRENADE](self)
	end
	-- "timer_grenade_start" is still called on event-based attacks unlike other attacks because we need to retain the data (customEnt, disableOwner, landDir)...
	-- ...But the timer will be based off of "timer_grenade_finished" to be used as a fail safe in case the animation is cut off!
	-- Call "timer.Adjust("timer_grenade_start"..self:EntIndex(), 0)" in the event code to make it throw the grenade
	timer.Create("timer_grenade_start"..self:EntIndex(), (releaseTime == false and timer.TimeLeft("timer_grenade_finished"..self:EntIndex())) or releaseTime / self.AnimPlaybackRate, 1, function()
		if self.AttackSeed == seed then
			if isLiveEnt && !IsValid(customEnt) then return end
			self:GrenadeAttackThrow(customEnt, disableOwner, landDir)
		end
	end)
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Performs a grenade attack
		- customEnt = What entity it should throw | DEFAULT: nil
			- nil = Spawn the NPC's default grenade class usually set by "self.GrenadeAttackEntity"
			- string = Spawn the given entity class as the grenade
			- entity = Use the given entity as the grenade by changing its parent to the NPC and altering its position
		- disableOwner = If set to true, the NPC will not be set as the owner of the grenade, allowing it to damage itself and its allies when applicable!
		- landDir = Direction the grenade should land | Used by the base to align where the grenade is gonna land
			- 0 = Use enemy's position
			- 1 = Use enemy's last visible position
			- Vector = Use given vector's position
			- Anything else = Find a best random position
	Returns
		- false, Grenade attack was canceled
		- Entity, The grenade that was thrown
-----------------------------------------------------------]]
function ENT:GrenadeAttackThrow(customEnt, disableOwner, landDir)
	if self.Dead or self.PauseAttacks or self.Flinching or self.AttackType == VJ.ATTACK_TYPE_MELEE then return false end
	local grenade;
	local isLiveEnt = IsValid(customEnt) -- Whether or not the given custom entity is live
	local fuseTime = self.GrenadeAttackFuseTime
	
	-- Handle the grenade's spawn position and angle, in order with priority:
		-- 1. CUSTOM 		If custom position is given then use that, otherwise...
		-- 2. ATTACHMENT 	If a valid attachment is given then use that, otherwise...
		-- 3. BONE 			If a valid bone is given then use that, otherwise...
		-- 4. FAIL 			Use the NPC's shoot position (fail safe)
	local spawnPos = self:OnGrenadeAttack("SpawnPos", nil, customEnt, landDir, nil)
	local spawnAng;
	if !spawnPos then -- If no custom position is given...
		local getAttach = self:LookupAttachment(self.GrenadeAttackAttachment)
		if !getAttach or getAttach == 0 or getAttach == -1 then -- Attachment invalid, try bone...
			local getBone = self:LookupBone(self.GrenadeAttackBone)
			if getBone then -- Bone valid
				spawnPos, spawnAng = self:GetBonePosition(getBone)
			else -- Fail safe! (All cases failed)
				spawnPos = self:GetShootPos()
				spawnAng = self:GetAngles()
			end
		else -- Attachment valid
			local attachData = self:GetAttachment(getAttach)
			spawnPos = attachData.Pos
			spawnAng = attachData.Ang
		end
	else -- Custom position valid
		spawnAng = spawnPos:Angle()
	end
	
	-- Handle NPC turning and grenade landing position
	-- Do NOT set it to actually turn & face because it's pointless at this point since the grenade is already being released!
	local landingPos = self:GetPos() + self:GetForward()*200
	if landDir == 0 then -- Use enemy's position
		landingPos = self:GetEnemyLastKnownPos()
		//if self.GrenadeAttackAnimationFaceEnemy then self:SetTurnTarget("Enemy") end
	elseif landDir == 1 then -- Use enemy's last visible position
		local eneData = self.EnemyData
		landingPos = eneData.LastVisiblePos
		//self:SetTurnTarget(eneData.LastVisiblePos, self.AttackAnimDuration - self.TimeUntilGrenadeIsReleased)
	elseif isvector(landDir) then -- Use given vector's position
		landingPos = landDir
	else -- Find a best random position
		local bestPos = PICK(VJ.TraceDirections(self, "Quick", 200, true, false, 8))
		if bestPos then
			landingPos = bestPos
			//self:SetTurnTarget(bestPos, self.AttackAnimDuration - self.TimeUntilGrenadeIsReleased)
		end
	end
	
	-- If its a live entity then clean it up and set it as the grenade...
	-- Otherwise, create a new entity with the given custom entity name OR one of NPC's default grenades
	if isLiveEnt then -- It's an existing entity
		customEnt.VJ_ST_Grabbed = false -- Set this to false, as we are no longer holding it!
		-- Clean up by removing the parent, move type, and follow bone effect
		customEnt:SetParent(NULL)
		if customEnt:GetMoveType() == MOVETYPE_NONE && customEnt.VJ_ST_GrabOrgMoveType then customEnt:SetMoveType(customEnt.VJ_ST_GrabOrgMoveType) end
		customEnt:RemoveEffects(EF_FOLLOWBONE)
		grenade = customEnt
		//customEnt:Remove()
	else
		grenade = ents.Create(customEnt or PICK(self.GrenadeAttackEntity))
		if !customEnt then -- Skip model override if function is called with a custom entity string
			local setModel = PICK(self.GrenadeAttackModel)
			if setModel then
				grenade:SetModel(setModel)
			end
		end
	end
	
	if !disableOwner then grenade:SetOwner(self) end
	grenade:SetPos(spawnPos)
	grenade:SetAngles(spawnAng)
	
	if !isLiveEnt then
		-- Set the fuse timers for all the different grenade entities
		local gerClass = grenade:GetClass()
		if gerClass == "obj_vj_grenade" then
			grenade.FuseTime = fuseTime
		elseif gerClass == "npc_grenade_frag" then
			grenade:Input("SetTimer", grenade:GetOwner(), grenade:GetOwner(), fuseTime)
		elseif gerClass == "obj_cpt_grenade" then
			grenade:SetTimer(fuseTime)
		elseif gerClass == "obj_spore" then
			grenade:SetGrenade(true)
		elseif gerClass == "ent_hl1_grenade" then
			grenade:ShootTimed(grenade:GetOwner(), defPos, fuseTime)
		elseif gerClass == "doom3_grenade" or gerClass == "obj_handgrenade" then
			grenade:SetExplodeDelay(fuseTime)
		elseif gerClass == "cw_grenade_thrown" or gerClass == "cw_flash_thrown" or gerClass == "cw_smoke_thrown" then
			grenade:SetOwner(self)
			grenade:Fuse(fuseTime)
		end
		
		-- Spawn the grenade
		grenade:Spawn()
		grenade:Activate()
	end
	
	-- Handle throw velocity
	local throwVel = self:OnGrenadeAttack("Throw", grenade, customEnt, landDir, landingPos)
	if throwVel then
		local phys = grenade:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			phys:AddAngleVelocity(Vector(math.Rand(500, 500), math.Rand(500, 500), math.Rand(500, 500)))
			phys:SetVelocity(throwVel)
		else -- If we don't have a physics object, then attempt to set the entity's velocity directly
			grenade:SetVelocity(throwVel)
		end
	end
	
	if self.AttackState < VJ.ATTACK_STATE_EXECUTED then
		self.AttackState = VJ.ATTACK_STATE_EXECUTED
		if self.TimeUntilGrenadeIsReleased != false then
			finishAttack[VJ.ATTACK_TYPE_GRENADE](self)
		end
	end
	return grenade
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
local sdBitSource = bit.bor(SOUND_DANGER, SOUND_CONTEXT_REACT_TO_SOURCE) ---> Combine dropship impact position, Combine gunship turret impact position, Strider minigun impact position
local sdBitCombine = bit.bor(SOUND_DANGER, SOUND_CONTEXT_EXCLUDE_COMBINE) ---> Flechette impact position, Strider foot impact position
local sdBitPlyVehicle = bit.bor(SOUND_DANGER, SOUND_CONTEXT_PLAYER_VEHICLE) ---> Player driving a vehicle
local sdBitMortar = bit.bor(SOUND_DANGER, SOUND_CONTEXT_MORTAR) ---> Combine mortars impact position

3 types of danger detections:
- ent.VJ_ID_Grenade
	- Detected as a grenade
	- Distance based on self.DangerDetectionDistance
	- Ignores grenades from allies
	- BEST USE: Grenade type of entities
- ent.VJ_ID_Danger
	- Detected as a danger
	- Distance based on self.DangerDetectionDistance
	- Ignores dangers from allies
	- BEST USE: Entities that should NOT scare the owner's allies, commonly used for projectiles
- NPC Conditions (Old system: sound.EmitHint)
	- Detected as a danger
	- Distance based on the sound hint's volume/distance
	- Does NOT ignore, is detected by everyone that catches the hint, including allies
	- BEST USE: Sounds that should scare the owner's allies
-----------------------------------------------------------]]
function ENT:CheckForDangers()
	if !self.CanDetectDangers or self.AttackType == VJ.ATTACK_TYPE_GRENADE or self.NextDangerDetectionT > CurTime() then return end
	local regDangerDetected = false -- A regular non-grenade danger has been found (This is done to make sure grenades take priority over other dangers!)
	for _, ent in ipairs(ents.FindInSphere(self:GetPos(), self.DangerDetectionDistance)) do
		if (ent.VJ_ID_Danger or ent.VJ_ID_Grenade) && self:Visible(ent) then
			local vOwner = ent:GetOwner()
			if !(IsValid(vOwner) && vOwner.IsVJBaseSNPC && ((self:GetClass() == vOwner:GetClass()) or (self:Disposition(vOwner) == D_LI))) then
				if ent.VJ_ID_Danger then regDangerDetected = ent continue end -- If it's a regular danger then just skip it for now
				local funcCustom = self.OnDangerDetected; if funcCustom then funcCustom(self, VJ.DANGER_TYPE_GRENADE, ent) end
				self:PlaySoundSystem("OnGrenadeSight")
				self.NextDangerDetectionT = CurTime() + 4
				self.TakingCoverT = CurTime() + 4
				-- If has the ability to throw it back, then throw the grenade!
				if self.CanThrowBackDetectedGrenades && self.HasGrenadeAttack && ent.VJ_ID_Grabbable && !ent.VJ_ST_Grabbed && ent:GetVelocity():Length() < 400 && VJ.GetNearestDistance(self, ent) < 100 && self:GrenadeAttack(ent, true) then
					self.NextGrenadeAttackSoundT = CurTime() + 3
					return
				end
				-- Was not able to throw back the grenade, so take cover instead!
				self:SCHEDULE_COVER_ORIGIN("TASK_RUN_PATH", function(x)
					x.CanShootWhenMoving = true
					x.FaceData = {Type = VJ.FACE_ENEMY}
				end)
				return
			end
		end
	end
	if regDangerDetected or self:HasCondition(COND_HEAR_DANGER) or self:HasCondition(COND_HEAR_PHYSICS_DANGER) or self:HasCondition(COND_HEAR_MOVE_AWAY) then
		local funcCustom = self.OnDangerDetected
		if funcCustom then
			if regDangerDetected then
				funcCustom(self, VJ.DANGER_TYPE_ENTITY, regDangerDetected)
			else
				funcCustom(self, VJ.DANGER_TYPE_HINT, nil)
			end
		end
		self:PlaySoundSystem("OnDangerSight")
		self.NextDangerDetectionT = CurTime() + 4
		self.TakingCoverT = CurTime() + 4
		self:SCHEDULE_COVER_ORIGIN("TASK_RUN_PATH", function(x)
			x.CanShootWhenMoving = true
			x.FaceData = {Type = VJ.FACE_ENEMY}
		end)
		return
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StopAttacks(checkTimers)
	if !self:Alive() then return end
	if self.VJ_DEBUG && GetConVar("vj_npc_debug_attack"):GetInt() == 1 then VJ.DEBUG_Print(self, "StopAttacks", "Attack type = " .. self.AttackType) end
	
	if checkTimers && self.AttackType == VJ.ATTACK_TYPE_MELEE && self.AttackState < VJ.ATTACK_STATE_EXECUTED then
		finishAttack[VJ.ATTACK_TYPE_MELEE](self, true)
	end
	
	self.AttackType = VJ.ATTACK_TYPE_NONE
	self.AttackState = VJ.ATTACK_STATE_DONE
	self.AttackSeed = 0
	
	self:MaintainAlertBehavior()
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function math_angDif(diff)
    diff = diff % 360
    if diff > 180 then return diff - 360 end
    return diff
end
--
function ENT:UpdatePoseParamTracking(resetPoses)
	if !self.HasPoseParameterLooking or (!self.VJ_IsBeingControlled && (!self.WeaponAttackState or (!self.EnemyData.IsVisible && self.WeaponAttackState < VJ.WEP_ATTACK_STATE_FIRE))) then return end
	//VJ.GetPoseParameters(self)
	local ene = self:GetEnemy()
	local newPitch = 0
	local newYaw = 0
	local newRoll = 0
	if IsValid(ene) && !resetPoses then
		local myEyePos = self:EyePos()
		local myAng = self:GetAngles()
		local eneAng = (self:GetAimPosition(ene, myEyePos) - myEyePos):Angle()
		newPitch = math_angDif(eneAng.p - myAng.p)
		if self.PoseParameterLooking_InvertPitch then newPitch = -newPitch end
		newYaw = math_angDif(eneAng.y - myAng.y)
		if self.PoseParameterLooking_InvertYaw then newYaw = -newYaw end
		newRoll = math_angDif(eneAng.z - myAng.z)
		if self.PoseParameterLooking_InvertRoll then newRoll = -newRoll end
	elseif !self.PoseParameterLooking_CanReset then -- Should it reset its pose parameters if there is no enemies?
		return
	end
	
	local funcCustom = self.OnUpdatePoseParamTracking; if funcCustom then funcCustom(self, newPitch, newYaw, newRoll) end
	
	local namesPitch = self.PoseParameterLooking_Names.pitch
	local namesYaw = self.PoseParameterLooking_Names.yaw
	local namesRoll = self.PoseParameterLooking_Names.roll
	local speed = self.PoseParameterLooking_TurningSpeed
	local getPoseParameter = self.GetPoseParameter
	local setPoseParameter = self.SetPoseParameter
	for x = 1, #namesPitch do
		local pose = namesPitch[x]
		setPoseParameter(self, pose, math_angApproach(getPoseParameter(self, pose), newPitch, speed))
	end
	for x = 1, #namesYaw do
		local pose = namesYaw[x]
		setPoseParameter(self, pose, math_angApproach(getPoseParameter(self, pose), newYaw, speed))
	end
	for x = 1, #namesRoll do
		local pose = namesRoll[x]
		setPoseParameter(self, pose, math_angApproach(getPoseParameter(self, pose), newRoll, speed))
	end
	self.UpdatedPoseParam = true
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Determines whether it's about to fire its current weapon
		- checkDistance = Should it check for distance and weapon time too? | DEFAULT = false
		- checkDistanceOnly = Should it only check the above statement? | DEFAULT = false
	Returns
		- Boolean, Whether or not it can fire its active weapon
-----------------------------------------------------------]]
function ENT:CanFireWeapon(checkDistance, checkDistanceOnly)
	if self:OnWeaponCanFire() == false then return false end
	local hasDist = false
	local hasChecks = false
	local curWep = self.WeaponEntity
	
	if self.PauseAttacks or !IsValid(curWep) or self:GetWeaponState() != VJ.WEP_STATE_READY then return false end
	if self.VJ_IsBeingControlled then
		checkDistance = false
	else
		local enemyDist = self.LatestEnemyDistance
		if checkDistance && CurTime() > self.NextWeaponAttackT && enemyDist < self.Weapon_FiringDistanceFar && ((enemyDist > self.Weapon_FiringDistanceClose) or curWep.IsMeleeWeapon) then
			hasDist = true
		end
		if checkDistanceOnly then
			return hasDist
		end
	end
	if !self.AttackType && !self:BusyWithActivity() then
		hasChecks = true
		if !checkDistance then return true end
	end
	return hasDist && hasChecks
end
---------------------------------------------------------------------------------------------------------------------------------------------
local schedule_player_move = vj_ai_schedule.New("SCHEDULE_PLAYER_MOVE")
	schedule_player_move:EngTask("TASK_MOVE_AWAY_PATH", 120)
	schedule_player_move:EngTask("TASK_RUN_PATH", 0)
	schedule_player_move:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
	schedule_player_move.CanShootWhenMoving = true
	schedule_player_move.FaceData = {} -- This is constantly edited!
--
function ENT:SelectSchedule()
	if self.VJ_IsBeingControlled or self.Dead then return end
	
	local hasCond = self.HasCondition
	local curTime = CurTime()
	local ene = self:GetEnemy()
	local eneValid = IsValid(ene)
	self:IdleSoundCode()
	
	-- Idle Behavior --
	if !eneValid then
		if self.AttackType != VJ.ATTACK_TYPE_GRENADE then
			self:MaintainIdleBehavior()
		end
		if !self.Alerted then
			self.TakingCoverT = 0
		end
		self.Weapon_UnarmedBehavior_Active = false
		
		-- Investigation: Conditions // hasCond(self, COND_HEAR_PLAYER)
		if self.CanInvestigate && (hasCond(self, COND_HEAR_BULLET_IMPACT) or hasCond(self, COND_HEAR_COMBAT) or hasCond(self, COND_HEAR_WORLD) or hasCond(self, COND_HEAR_DANGER)) && self.NextInvestigationMove < curTime && self.TakingCoverT < curTime && !self:IsBusy() then
			local sdSrc = self:GetBestSoundHint(bit.bor(SOUND_BULLET_IMPACT, SOUND_COMBAT, SOUND_WORLD, SOUND_DANGER)) // SOUND_PLAYER, SOUND_PLAYER_VEHICLE
			if sdSrc then
				//PrintTable(sdSrc)
				local allowed = true
				local sdOwner = sdSrc.owner
				if IsValid(sdOwner) then
					-- Ignore dangers produced by vehicles driven by an allies
					if sdSrc.type == SOUND_DANGER && sdOwner:IsVehicle() && IsValid(sdOwner:GetDriver()) && self:Disposition(sdOwner:GetDriver()) == D_LI then
						allowed = false
					-- Ignore bullet impacts by allies
					elseif self:Disposition(sdOwner) == D_LI then
						allowed = false
					end
				end
				-- For now ignore player sounds because friendly NPCs also see it since the sound owner is NULL
				//if sdSrc.type == SOUND_PLAYER then
				//	if VJ_CVAR_IGNOREPLAYERS or self:IsMoving() or self.IsGuard then
				//		skip = true
				//	end
				//end
				if allowed then
					self:DoReadyAlert()
					self:StopMoving()
					self:SetLastPosition(sdSrc.origin)
					self:SCHEDULE_FACE("TASK_FACE_LASTPOSITION")
					-- Works but just faces the enemy that fired at
					//local sched = vj_ai_schedule.New("SCHEDULE_HEAR_SOUND")
					//sched:EngTask("TASK_STORE_BESTSOUND_REACTORIGIN_IN_SAVEPOSITION", 0)
					//sched:EngTask("TASK_STOP_MOVING", 0)
					//sched:EngTask("TASK_FACE_SAVEPOSITION", 0)
					//self:StartSchedule(sched)
					self:OnInvestigate(sdOwner)
					self:PlaySoundSystem("InvestigateSound")
					self.TakingCoverT = curTime + 1
				end
			end
		end
		
	-- Combat Behavior --
	else
		local wep = self:GetActiveWeapon()
		
		-- Check for weapon validity
		if !IsValid(wep) then
			-- Scared behavior system
			if self.Weapon_UnarmedBehavior then
				if !self:IsBusy() && curTime > self.NextChaseTime then
					self.Weapon_UnarmedBehavior_Active = true -- Tells the idle system to use the scared behavior animation
					if self.IsFollowing == false && self.EnemyData.IsVisible then
						self:SCHEDULE_COVER_ENEMY("TASK_RUN_PATH")
						return
					end
				end
			-- If it doesn't do scared behavior, then make it chase the enemy if it can melee!
			elseif self.HasMeleeAttack then
				self.Weapon_UnarmedBehavior_Active = false -- In case it was scared, return it back to normal
				self.NextDangerDetectionT = curTime + 4 -- Ignore dangers while chasing!
				self:MaintainAlertBehavior()
				return
			end
			self:MaintainIdleBehavior(2)
			//return -- Allow other behaviors like "COND_PLAYER_PUSHING", etc to run
		else
			self.Weapon_UnarmedBehavior_Active = false -- In case it was scared, return it back to normal
			
			local enePos_Eye = ene:EyePos()
			local myPos = self:GetPos()
			local myPosCentered = myPos + self:OBBCenter()
			local canAttack = true
			
			-- Back away from the enemy if it's to close
			if self.LatestEnemyDistance <= self.Weapon_RetreatDistance && (!wep.IsMeleeWeapon) && curTime > self.TakingCoverT && curTime > self.NextChaseTime && !self.AttackType && !self.IsFollowing && ene.Behavior != VJ_BEHAVIOR_PASSIVE && !self:DoCoverTrace(myPosCentered, enePos_Eye) then
				local moveCheck = PICK(VJ.TraceDirections(self, "Quick", 200, true, false, 8, true))
				if moveCheck then
					self:SetLastPosition(moveCheck)
					if self:GetWeaponState() == VJ.WEP_STATE_RELOADING then self:SetWeaponState() end
					self.TakingCoverT = curTime + 2
					canAttack = false
					self:SCHEDULE_GOTO_POSITION("TASK_RUN_PATH", function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.CanShootWhenMoving = true x.FaceData = {Type = VJ.FACE_ENEMY} end)
				end
			end
			
			if canAttack && self:CanFireWeapon(false, false) && self:GetState() != VJ_STATE_ONLY_ANIMATION_NOATTACK then
				-- Enemy to far away or not allowed to fire a weapon
				if self.LatestEnemyDistance > self.Weapon_FiringDistanceFar or curTime < self.NextWeaponAttackT then
					self:MaintainAlertBehavior()
					self.AllowWeaponWaitOnOcclusion = false
				-- Check if enemy is in sight, then continue...
				elseif self:CanFireWeapon(true, true) then
					-- I can't see the enemy from my eyes
					if self:DoCoverTrace(self:EyePos(), enePos_Eye, true) then // or (!self.EnemyData.IsVisible)
						if self.TakingCoverT > curTime then return end -- Do NOT interrupt when taking cover (such as "MoveOrHideOnDamageByEnemy")
						if self:GetWeaponState() != VJ.WEP_STATE_RELOADING then
							-- Wait when enemy is occluded
							if self.Weapon_WaitOnOcclusion && self.WeaponAttackState != VJ.WEP_ATTACK_STATE_AIM_OCCLUSION && !wep.IsMeleeWeapon && self.AllowWeaponWaitOnOcclusion && (curTime - self.WeaponLastShotTime) <= 4.5 && self.LatestEnemyDistance > self.Weapon_WaitOnOcclusionMinDist then
								self.WeaponAttackState = VJ.WEP_ATTACK_STATE_AIM_OCCLUSION
								self:MaintainIdleBehavior(2) -- Make it play idle stand (Which will turn into ACT_IDLE_ANGRY)
								self.NextChaseTime = curTime + math.Rand(self.Weapon_WaitOnOcclusionTime.a, self.Weapon_WaitOnOcclusionTime.b)
							-- I am hidden, so stand up in case I am crouching if I had detected to be in a hidden position and the enemy may be visible!
							elseif curTime < self.LastHiddenZoneT && !self:DoCoverTrace(myPosCentered + self:GetUp()*30, enePos_Eye + self:GetUp()*30, true) then
								self:MaintainIdleBehavior(2) -- Make it play idle stand (Which will turn into ACT_IDLE_ANGRY)
								goto goto_checkwep
							else
								-- Everything failed, go after the enemy!
								if self.WeaponAttackState && self.WeaponAttackState >= VJ.WEP_ATTACK_STATE_FIRE && self.CurrentScheduleName != "SCHEDULE_ALERT_CHASE" && self.CurrentScheduleName != "SCHEDULE_ALERT_CHASE_LOS" then
									self.WeaponAttackState = VJ.WEP_ATTACK_STATE_NONE
								end
								self:MaintainAlertBehavior()
							end
						end
						goto goto_conditions
					end
					-- I can see the enemy...
					::goto_checkwep::
					if wep.IsVJBaseWeapon then -- VJ Base weapons
						-- Do proper weapon aim turning, based on "FInAimCone" - https://github.com/ValveSoftware/source-sdk-2013/blob/0d8dceea4310fde5706b3ce1c70609d72a38efdf/mp/src/game/server/ai_basenpc.cpp#L2584
						if !self.HasPoseParameterLooking then -- Pose parameter looking is disabled then always face
							self:SetTurnTarget("Enemy")
						else
							local wepDif = 1// self.Weapon_AimTurnDiff or self.Weapon_AimTurnDiff_Def
							local los = ene:GetPos() - myPos
							los.z = 0
							local facingDir = self:GetAngles():Forward() -- Do NOT use sight dir bec some NPCs use their eyes as the dir, it will trick the system to think the NPC is facing the enemy
							facingDir.z = 0
							local coneCalc = facingDir:Dot((los):GetNormalized())
							if coneCalc < wepDif then
								self:SetTurnTarget("Enemy")
								self:UpdatePoseParamTracking(true) -- Reset pose parameters to help with turning snaps
							end
						end
						local canFire = true
						// self:MaintainAlertBehavior()
						-- if covered, try to move forward by calculating the distance between the prop and the NPC
						local inCover, inCoverTrace = self:DoCoverTrace(myPosCentered, enePos_Eye, false, {SetLastHiddenTime=true})
						local inCoverEnt = inCoverTrace.Entity
						local wepInCover, wepInCoverTrace = self:DoCoverTrace(wep:GetBulletPos(), enePos_Eye, false)
						local wepInCoverEnt = wepInCoverTrace.Entity
						//print("Is covered? ", inCover)
						//print("Is gun covered? ", wepInCover)
						local inCoverEntLiving = false -- The covered entity is NOT a living entity
						if IsValid(inCoverEnt) && inCoverEnt.VJ_ID_Living then
							inCoverEntLiving = true
						end
						if !wep.IsMeleeWeapon then
							-- If friendly in line of fire, then move!
							if inCoverEntLiving && self.WeaponAttackState == VJ.WEP_ATTACK_STATE_FIRE_STAND && curTime > self.TakingCoverT && IsValid(wepInCoverEnt) && wepInCoverEnt:IsNPC() && wepInCoverEnt != self && (self:Disposition(wepInCoverEnt) == D_LI or self:Disposition(wepInCoverEnt) == D_NU) && wepInCoverTrace.HitPos:Distance(wepInCoverTrace.StartPos) <= 3000 then
								local moveCheck = PICK(VJ.TraceDirections(self, "Quick", 50, true, false, 4, true, true))
								if moveCheck then
									self:StopMoving()
									if self.IsGuard then self.GuardingPosition = moveCheck end -- Set the guard position to this new position that avoids friendly fire
									self:SetLastPosition(moveCheck)
									self.NextChaseTime = curTime + 1
									self:SCHEDULE_GOTO_POSITION("TASK_WALK_PATH", function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.CanShootWhenMoving = true x.FaceData = {Type = VJ.FACE_ENEMY} end)
								end
							end
							
							-- NPC is behind cover...
							if inCover then
								-- Behind cover and I am taking cover, don't fire!
								if curTime < self.TakingCoverT then
									canFire = false
								elseif curTime > self.NextMoveOnGunCoveredT && ((inCoverTrace.HitPos:Distance(myPos) > 150 && !inCoverEntLiving) or (wepInCover && !wepInCoverEnt.VJ_ID_Living)) then
									self.AllowWeaponWaitOnOcclusion = false
									local nearestPos;
									local nearestEntPos;
									if IsValid(inCoverEnt) then
										nearestPos, nearestEntPos = VJ.GetNearestPositions(self, inCoverEnt)
										nearestPos.z = myPos.z; nearestEntPos.z = myPos.z -- Floor the Z-axis as it can be used for a movement position!
									else
										nearestPos, nearestEntPos = self:NearestPoint(inCoverTrace.HitPos), inCoverTrace.HitPos
									end
									nearestEntPos = nearestEntPos - self:GetForward()*15
									if nearestPos:Distance(nearestEntPos) <= (self.IsGuard and 60 or 1000) then
										if self.IsGuard then self.GuardingPosition = nearestEntPos end -- Set the guard position to this new position that provides cover
										self:SetLastPosition(nearestEntPos)
										//VJ.DEBUG_TempEnt(nearestEntPos, self:GetAngles(), Color(0,255,255))
										local schedule = vj_ai_schedule.New("SCHEDULE_GOTO_POSITION")
										schedule:EngTask("TASK_GET_PATH_TO_LASTPOSITION", 0)
										local coverRunAnim = self:TranslateActivity(PICK(self.AnimTbl_MoveToCover))
										if VJ.AnimExists(self, coverRunAnim) then
											self:SetMovementActivity(coverRunAnim)
										else -- Only shoot if we aren't crouching running!
											schedule.CanShootWhenMoving = true
										end
										schedule:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
										schedule.FaceData = {Type = VJ.FACE_ENEMY}
										//schedule.StopScheduleIfNotMoving_Any = true
										self:StartSchedule(schedule)
										//self:SCHEDULE_GOTO_POSITION("TASK_WALK_PATH",function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.CanShootWhenMoving = true x.FaceData = {Type = VJ.FACE_ENEMY} end)
									end
									self.NextMoveOnGunCoveredT = curTime + 2
									return
								end
							//else -- NPC is NOT behind cover
							end
						end
						
						if canFire && curTime > self.NextWeaponAttackT && curTime > self.NextWeaponAttackT_Base then
							-- Melee weapons
							if wep.IsMeleeWeapon then
								self:OnWeaponAttack()
								local finalAnim = self:TranslateActivity(PICK(self.AnimTbl_WeaponAttack))
								if curTime > self.NextMeleeWeaponAttackT && VJ.AnimExists(self, finalAnim) then // && !VJ.IsCurrentAnim(self, finalAnim)
									local animDur = VJ.AnimDuration(self, finalAnim)
									wep.NPC_NextPrimaryFire = animDur -- Make melee weapons dynamically change the next primary fire
									VJ.EmitSound(self, wep.NPC_BeforeFireSound, wep.NPC_BeforeFireSoundLevel, math.Rand(wep.NPC_BeforeFireSoundPitch.a, wep.NPC_BeforeFireSoundPitch.b))
									self.NextMeleeWeaponAttackT = curTime + animDur
									self.WeaponAttackAnim = finalAnim
									self:PlayAnim(finalAnim, false, false, true)
									self.WeaponAttackState = VJ.WEP_ATTACK_STATE_FIRE_STAND
								end
							-- Ranged weapons
							else
								self.AllowWeaponWaitOnOcclusion = true
								local hasAmmo = wep:Clip1() > 0 -- Does it have ammo?
								if !hasAmmo && self.WeaponAttackState != VJ.WEP_ATTACK_STATE_AIM then
									self.WeaponAttackAnim = ACT_INVALID
								end
								-- If it's already doing a firing animation, then do NOT restart the animation
								if VJ.IsCurrentAnim(self, self:TranslateActivity(self.WeaponAttackAnim)) then
									self.WeaponAttackState = VJ.WEP_ATTACK_STATE_FIRE_STAND
								-- If the current activity isn't the last weapon animation and it's not a transition, then continue
								elseif self:GetActivity() != self.WeaponAttackAnim && self:GetActivity() != ACT_TRANSITION then
									self:OnWeaponAttack()
									if self.WeaponAttackState == VJ.WEP_ATTACK_STATE_AIM_OCCLUSION then
										self.WeaponAttackState = VJ.WEP_ATTACK_STATE_NONE
									end
									self.WeaponLastShotTime = curTime
									//self.NextWeaponStrafeWhileFiringT = curTime + 2
									local finalAnim = false
									-- Check if the NPC has ammo
									if !hasAmmo then
										self:MaintainIdleBehavior(2) -- Make it play idle stand (Which will turn into ACT_IDLE_ANGRY)
										//finalAnim = self:TranslateActivity(PICK(self.AnimTbl_WeaponAim))
										self.WeaponAttackState = VJ.WEP_ATTACK_STATE_AIM
									else
										-- Crouch fire
										local anim_crouch = self:TranslateActivity(PICK(self.AnimTbl_WeaponAttackCrouch))
										if self.Weapon_CanCrouchAttack && !inCover && !wepInCover && self.LatestEnemyDistance > 500 && VJ.AnimExists(self, anim_crouch) && math.random(1, self.Weapon_CrouchAttackChance) == 1 && !self:DoCoverTrace(wep:GetBulletPos() + self:GetUp() * -18, enePos_Eye, true) then
											finalAnim = anim_crouch
										-- Standing fire
										else
											finalAnim = self:TranslateActivity(PICK(self.AnimTbl_WeaponAttack))
										end
									end
									if finalAnim && VJ.AnimExists(self, finalAnim) && (!VJ.IsCurrentAnim(self, finalAnim) or !self.WeaponAttackState) then
										VJ.EmitSound(self, wep.NPC_BeforeFireSound, wep.NPC_BeforeFireSoundLevel, math.Rand(wep.NPC_BeforeFireSoundPitch.a, wep.NPC_BeforeFireSoundPitch.b))
										self:PlayAnim(finalAnim, false, 0, true)
										self.WeaponAttackAnim = finalAnim
										self.WeaponAttackState = VJ.WEP_ATTACK_STATE_FIRE_STAND
										self.NextWeaponAttackT_Base = curTime + 0.2
									end
								end
							end
						end
						-- Move randomly when shooting
						if self.Weapon_StrafeWhileFiring && !inCover && !self.IsGuard && !self.IsFollowing && (!wep.IsMeleeWeapon) && (!wep.NPC_StandingOnly) && self.WeaponAttackState == VJ.WEP_ATTACK_STATE_FIRE_STAND && curTime > self.NextWeaponStrafeWhileFiringT && (curTime - self.EnemyData.TimeSinceAcquired) > 2 && (self.LatestEnemyDistance < (self.Weapon_FiringDistanceFar / 1.25)) then
							if self:OnWeaponStrafeWhileFiring() != false then
								local moveCheck = PICK(VJ.TraceDirections(self, "Radial", math.random(150, 400), true, false, 12, true))
								if moveCheck then
									self:StopMoving()
									self:SetLastPosition(moveCheck)
									self:SCHEDULE_GOTO_POSITION(math.random(1, 2) == 1 and "TASK_RUN_PATH" or "TASK_WALK_PATH", function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.CanShootWhenMoving = true x.FaceData = {Type = VJ.FACE_ENEMY} end)
								end
							end
							self.NextWeaponStrafeWhileFiringT = curTime + math.Rand(self.Weapon_StrafeWhileFiringDelay.a, self.Weapon_StrafeWhileFiringDelay.b)
						end
					else -- None VJ Base weapons
						self:SetTurnTarget("Enemy")
						self.WeaponAttackState = VJ.WEP_ATTACK_STATE_FIRE_STAND
						self:OnWeaponAttack()
						self.WeaponLastShotTime = curTime
						//wep:SetClip1(99999)
						self:SetSchedule(SCHED_RANGE_ATTACK1)
					end
				end
			end
		end
	end
	
	::goto_conditions::
	-- Handle move away behavior
	if hasCond(self, COND_PLAYER_PUSHING) && curTime > self.TakingCoverT && !self:BusyWithActivity() then
		self:PlaySoundSystem("MoveOutOfPlayersWay")
		if eneValid then -- Face current enemy
			schedule_player_move.FaceData.Type = VJ.FACE_ENEMY_VISIBLE
			schedule_player_move.FaceData.Target = nil
		elseif IsValid(self:GetTarget()) then -- Face current target
			schedule_player_move.FaceData.Type = VJ.FACE_ENTITY_VISIBLE
			schedule_player_move.FaceData.Target = self:GetTarget()
		else -- Reset if both others fail! (Remember this is a localized table shared between all NPCs!)
			schedule_player_move.FaceData.Type = nil
			schedule_player_move.FaceData.Target = nil
		end
		self:StartSchedule(schedule_player_move)
		self.TakingCoverT = curTime + 2
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ResetEnemy(checkAllies, checkVis)
	if self.Dead or (self.VJ_IsBeingControlled && self.VJ_TheControllerBullseye == self:GetEnemy()) then self.EnemyData.Reset = false return false end
	local ene = self:GetEnemy()
	local eneValid = IsValid(ene)
	local eneData = self.EnemyData
	if checkAllies then
		local getAllies = self:Allies_Check(1000)
		if getAllies != false then
			for _, ally in ipairs(getAllies) do
				local allyEne = ally:GetEnemy()
				if IsValid(allyEne) && (CurTime() - ally.EnemyData.LastVisibleTime) < self.TimeUntilEnemyLost && allyEne:Alive() && self:CheckRelationship(allyEne) == D_HT then
					self.AllowWeaponWaitOnOcclusion = false
					self:ForceSetEnemy(allyEne, false)
					eneData.Reset = false
					return false
				end
			end
		end
	end
	if checkVis then
		-- If the current number of reachable enemies is higher then 1, then don't reset
		local curEnemies = eneData.VisibleCount //self.CurrentReachableEnemies
		if (eneValid && (curEnemies - 1) >= 1) or (!eneValid && curEnemies >= 1) then
			self:MaintainRelationships() -- Select a new enemy
			-- Check that the reset enemy wasn't the only visible enemy
			-- If we don't this, it will call "ResetEnemy" again!
			if eneData.VisibleCount > 0 then
				eneData.Reset = false
				return false
			end
		end
	end
	
	if self.VJ_DEBUG && GetConVar("vj_npc_debug_resetenemy"):GetInt() == 1 then VJ.DEBUG_Print(self, "ResetEnemy", tostring(ene)) end
	eneData.Reset = true
	self:SetNPCState(NPC_STATE_ALERT)
	timer.Create("timer_alerted_reset"..self:EntIndex(), math.Rand(self.AlertedToIdleTime.a, self.AlertedToIdleTime.b), 1, function() if !IsValid(self:GetEnemy()) then self.Alerted = false self:SetNPCState(NPC_STATE_IDLE) end end)
	self:OnResetEnemy()
	local moveToEnemy = false
	if eneValid then
		if !self.IsFollowing && !self.IsGuard && !self.IsVJBaseSNPC_Tank && !self.VJ_IsBeingControlled && self.LastHiddenZone_CanWander == true && !self.Weapon_UnarmedBehavior_Active && self.Behavior != VJ_BEHAVIOR_PASSIVE && self.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE && !self:IsBusy() && !self:Visible(ene) && self:GetEnemyLastKnownPos() != defPos then
			moveToEnemy = self:GetEnemyLastKnownPos()
		end
		self:MarkEnemyAsEluded(ene)
		//self:ClearEnemyMemory(ene) // Completely resets the enemy memory
		self:AddEntityRelationship(ene, D_NU, 10)
	end
	
	self.LastHiddenZone_CanWander = CurTime() > self.LastHiddenZoneT and true or false
	self.LastHiddenZoneT = 0
	
	-- Clear memory of the enemy if it's not a player AND it's dead
	if eneValid && !ene:IsPlayer() && !ene:Alive() then
		//print("Clear memory", ene)
		self:ClearEnemyMemory(ene)
	end
	-- This is needed for the human base because when taking cover from enemy, the AI can get stuck in a loop (EX: When self.Weapon_UnarmedBehavior_Active is true!)
	if self.CurrentScheduleName == "SCHEDULE_COVER_ENEMY" or self.CurrentScheduleName == "SCHEDULE_COVER_ENEMY_FAIL" then
		self:StopMoving()
	end
	self.NextWanderTime = CurTime() + math.Rand(3, 5)
	self:SetEnemy(NULL)
	if moveToEnemy then
		self:SetLastPosition(moveToEnemy)
		self:SCHEDULE_GOTO_POSITION("TASK_WALK_PATH", function(schedule)
			//if eneValid then schedule:EngTask("TASK_FORGET", ene) end
			//schedule:EngTask("TASK_IGNORE_OLD_ENEMIES", 0)
			schedule.ResetOnFail = true
			schedule.CanShootWhenMoving = true
			schedule.CanBeInterrupted = true
			schedule.FaceData = {Type = VJ.FACE_ENEMY}
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage(dmginfo)
	local dmgAttacker = dmginfo:GetAttacker()
	if !IsValid(dmgAttacker) then dmgAttacker = false end
	
	-- Don't take bullet damage from friendly NPCs
	if dmgAttacker && dmginfo:IsBulletDamage() && dmgAttacker:IsNPC() && dmgAttacker:Disposition(self) != D_HT && (dmgAttacker:GetClass() == self:GetClass() or self:Disposition(dmgAttacker) == D_LI) then return 0 end
	
	local dmgInflictor = dmginfo:GetInflictor()
	if !IsValid(dmgInflictor) then dmgInflictor = false end
	
	-- Attempt to avoid taking damage when walking on ragdolls
	if dmgInflictor && dmgInflictor:GetClass() == "prop_ragdoll" && dmgInflictor:GetVelocity():Length() <= 100 then return 0 end
	
	local hitgroup = self:GetLastDamageHitGroup()
	self:OnDamaged(dmginfo, hitgroup, "Initial")
	if self.GodMode or dmginfo:GetDamage() <= 0 then return 0 end
	
	local dmgType = dmginfo:GetDamageType()
	local curTime = CurTime()
	local isFireEnt = false
	if self:IsOnFire() then
		isFireEnt = dmgInflictor && dmgAttacker && dmgInflictor:GetClass() == "entityflame" && dmgAttacker:GetClass() == "entityflame"
		if self:WaterLevel() > 1 then self:Extinguish() end -- If we are in water, then extinguish the fire
	end
	
	-- If it should always take damage from huge monsters, then skip immunity checks!
	if dmgAttacker && self.ForceDamageFromBosses && dmgAttacker.VJ_ID_Boss then
		goto skip_immunity
	end
	
	-- Immunity checks
	if isFireEnt && !self.AllowIgnition then self:Extinguish() return 0 end
	if (self.Immune_Fire && (dmgType == DMG_BURN or dmgType == DMG_SLOWBURN or isFireEnt)) or (self.Immune_AcidPoisonRadiation && (dmgType == DMG_ACID or dmgType == DMG_RADIATION or dmgType == DMG_POISON or dmgType == DMG_NERVEGAS or dmgType == DMG_PARALYZE)) or (self.Immune_Bullet && (dmginfo:IsBulletDamage() or dmgType == DMG_BULLET or dmgType == DMG_AIRBOAT or dmgType == DMG_BUCKSHOT)) or (self.Immune_Blast && (dmgType == DMG_BLAST or dmgType == DMG_BLAST_SURFACE)) or (self.Immune_Dissolve && dmgType == DMG_DISSOLVE) or (self.Immune_Electricity && (dmgType == DMG_SHOCK or dmgType == DMG_ENERGYBEAM or dmgType == DMG_PHYSGUN)) or (self.Immune_Melee && (dmgType == DMG_CLUB or dmgType == DMG_SLASH)) or (self.Immune_Sonic && dmgType == DMG_SONIC) then return 0 end
	
	-- Make sure combine ball does reasonable damage and doesn't spam!
	if (dmgInflictor && dmgInflictor:GetClass() == "prop_combine_ball") or (dmgAttacker && dmgAttacker:GetClass() == "prop_combine_ball") then
		if self.Immune_Dissolve then return 0 end
		if curTime > self.NextCombineBallDmgT then
			dmginfo:SetDamage(math.random(400, 500))
			dmginfo:SetDamageType(DMG_DISSOLVE)
			self.NextCombineBallDmgT = curTime + 0.2
		else
			return 0
		end
	end
	::skip_immunity::
	
	local function DoBleed()
		if self.Bleeds then
			self:OnBleed(dmginfo, hitgroup)
			-- Spawn the blood particle only if it's not caused by the default fire entity [Causes the damage position to be at Vector(0, 0, 0)]
			if self.HasBloodParticle && !isFireEnt then self:SpawnBloodParticles(dmginfo, hitgroup) end
			if self.HasBloodDecal then self:SpawnBloodDecal(dmginfo, hitgroup) end
			self:PlaySoundSystem("Impact", nil, VJ.EmitSound)
		end
	end
	if self.Dead then DoBleed() return 0 end -- If dead then just bleed but take no damage
	
	self:OnDamaged(dmginfo, hitgroup, "PreDamage")
	if dmginfo:GetDamage() <= 0 then return 0 end -- Only take damage if it's above 0!
	-- Why? Because GMod resets/randomizes dmginfo after a tick...
	self.SavedDmgInfo = {
		dmginfo = dmginfo, -- The actual CTakeDamageInfo object | WARNING: Can be corrupted after a tick, recommended not to use this!
		attacker = dmginfo:GetAttacker(),
		inflictor = dmginfo:GetInflictor(),
		amount = dmginfo:GetDamage(),
		pos = dmginfo:GetDamagePosition(),
		type = dmginfo:GetDamageType(),
		force = dmginfo:GetDamageForce(),
		ammoType = dmginfo:GetAmmoType(),
		hitgroup = hitgroup,
	}
	self:SetHealth(self:Health() - dmginfo:GetDamage())
	if self.VJ_DEBUG && GetConVar("vj_npc_debug_damage"):GetInt() == 1 then VJ.DEBUG_Print(self, "OnTakeDamage", "Amount = ", dmginfo:GetDamage(), " | Attacker = ", dmgAttacker, " | Inflictor = ", dmgInflictor) end
	if self.HasHealthRegeneration && self.HealthRegenerationResetOnDmg then
		self.HealthRegenerationDelayT = curTime + (math.Rand(self.HealthRegenerationDelay.a, self.HealthRegenerationDelay.b) * 1.5)
	end
	self:SetSaveValue("m_iDamageCount", self:GetTotalDamageCount() + 1)
	self:SetSaveValue("m_flLastDamageTime", curTime)
	self:OnDamaged(dmginfo, hitgroup, "PostDamage")
	DoBleed()
	
	-- I/O events, from: https://github.com/ValveSoftware/source-sdk-2013/blob/0d8dceea4310fde5706b3ce1c70609d72a38efdf/sp/src/game/server/ai_basenpc.cpp#L764
	if dmgAttacker then
		self:TriggerOutput("OnDamaged", dmgAttacker)
		self:MarkTookDamageFromEnemy(dmgAttacker)
	else
		self:TriggerOutput("OnDamaged", self)
	end
	
	local stillAlive = self:Health() > 0
	if stillAlive then self:PlaySoundSystem("Pain") end

	if VJ_CVAR_AI_ENABLED && self:GetState() != VJ_STATE_FREEZE then
		if stillAlive then
			if !isFireEnt then
				self:Flinch(dmginfo, hitgroup)
			end
			
			-- React to damage by a player
				-- 0 = Run it every time | 1 = Run it only when friendly to player | 2 = Run it only when enemy to player
			if dmgAttacker && self.HasDamageByPlayerSounds && dmgAttacker:IsPlayer() && curTime > self.NextDamageByPlayerSoundT && self:Visible(dmgAttacker) then
				local dispLvl = self.DamageByPlayerDispositionLevel
				if (dispLvl == 0 or (dispLvl == 1 && self:Disposition(dmgAttacker) == D_LI) or (dispLvl == 2 && self:Disposition(dmgAttacker) != D_HT)) then
					self:PlaySoundSystem("DamageByPlayer")
				end
			end
			
			self:PlaySoundSystem("Pain")
			
			-- Move or hide when damaged while enemy is valid | RESULT: May play a hiding animation OR may move to take cover from enemy
			if self.MoveOrHideOnDamageByEnemy && self.Behavior != VJ_BEHAVIOR_PASSIVE && self.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE && IsValid(self:GetEnemy()) && curTime > self.NextMoveOrHideOnDamageByEnemyT && !self.IsFollowing && !self.AttackType && curTime > self.TakingCoverT && self.EnemyData.IsVisible && self:GetWeaponState() != VJ.WEP_STATE_RELOADING && self.LatestEnemyDistance < self.Weapon_FiringDistanceFar then
				local wep = self:GetActiveWeapon()
				if !self.MoveOrHideOnDamageByEnemy_OnlyMove && self:DoCoverTrace(self:GetPos() + self:OBBCenter(), self:GetEnemy():EyePos()) then
					local anim = self:TranslateActivity(PICK(self.AnimTbl_TakingCover))
					if VJ.AnimExists(self, anim) then
						local hideTime = math.Rand(self.MoveOrHideOnDamageByEnemy_HideTime.a, self.MoveOrHideOnDamageByEnemy_HideTime.b)
						self:PlayAnim(anim, false, hideTime, false) -- Don't set lockAnim because we want it to shoot if an enemy is suddenly visible!
						self.NextChaseTime = curTime + hideTime
						self.TakingCoverT = curTime + hideTime
						self.WeaponAttackState = VJ.WEP_ATTACK_STATE_NONE
					end
					self.NextMoveOrHideOnDamageByEnemyT = curTime + math.random(self.MoveOrHideOnDamageByEnemy_NextTime.a, self.MoveOrHideOnDamageByEnemy_NextTime.b)
				elseif !self:IsMoving() && (!IsValid(wep) or (IsValid(wep) && !wep.IsMeleeWeapon)) then -- Run away if not moving AND has a non-melee weapon
					self:SCHEDULE_COVER_ENEMY("TASK_RUN_PATH", function(x) x.CanShootWhenMoving = true x.FaceData = {Type = VJ.FACE_ENEMY} end)
					self.NextMoveOrHideOnDamageByEnemyT = curTime + math.random(self.MoveOrHideOnDamageByEnemy_NextTime.a, self.MoveOrHideOnDamageByEnemy_NextTime.b)
				end
			end

			-- Call for back on damage | RESULT: May play an animation OR it may move away, AND it may bring allies to its location
			if self.CallForBackUpOnDamage && curTime > self.NextCallForBackUpOnDamageT && self.AttackType != VJ.ATTACK_TYPE_GRENADE && !IsValid(self:GetEnemy()) && self.IsFollowing == false && self.Behavior != VJ_BEHAVIOR_PASSIVE && self.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE && !isFireEnt then
				local allies = self:Allies_Check(self.CallForBackUpOnDamageDistance)
				if allies != false then
					self:DoReadyAlert()
					self:Allies_Bring("Diamond", self.CallForBackUpOnDamageDistance, allies, self.CallForBackUpOnDamageLimit)
					for _, ally in ipairs(allies) do
						ally:DoReadyAlert()
					end
					self:ClearSchedule()
					self.NextFlinchT = curTime + 1
					local playedAnim = !self.DisableCallForBackUpOnDamageAnimation and self:PlayAnim(self.CallForBackUpOnDamageAnimation, true, false, true) or false
					if !playedAnim && !self:BusyWithActivity() then
						self:SCHEDULE_COVER_ORIGIN("TASK_RUN_PATH", function(x) x.CanShootWhenMoving = true x.FaceData = {Type = VJ.FACE_ENEMY} end)
					end
					self.NextCallForBackUpOnDamageT = curTime + math.Rand(self.NextCallForBackUpOnDamageTime.a, self.NextCallForBackUpOnDamageTime.b)
				end
			end

			-- Become enemy to a friendly player | RESULT: May become alerted
			if dmgAttacker && self.BecomeEnemyToPlayer && dmgAttacker:IsPlayer() && self:CheckRelationship(dmgAttacker) == D_LI then
				local relationMemory = self.RelationshipMemory[dmgAttacker]
				self:SetRelationshipMemory(dmgAttacker, VJ.MEM_HOSTILITY_LEVEL, relationMemory[VJ.MEM_HOSTILITY_LEVEL] and relationMemory[VJ.MEM_HOSTILITY_LEVEL] + 1 or 1)
				if relationMemory[VJ.MEM_HOSTILITY_LEVEL] > self.BecomeEnemyToPlayer && self:Disposition(dmgAttacker) != D_HT then
					self:OnBecomeEnemyToPlayer(dmginfo, hitgroup)
					if self.IsFollowing && self.FollowData.Ent == dmgAttacker then self:ResetFollowBehavior() end
					self:SetRelationshipMemory(dmgAttacker, VJ.MEM_OVERRIDE_DISPOSITION, D_HT)
					self:AddEntityRelationship(dmgAttacker, D_HT, 2)
					self.TakingCoverT = curTime + 2
					self:PlaySoundSystem("BecomeEnemyToPlayer")
					if !IsValid(self:GetEnemy()) then
						self:StopMoving()
						self:SetTarget(dmgAttacker)
						self:SCHEDULE_FACE("TASK_FACE_TARGET")
					end
					if self.CanChatMessage then
						dmgAttacker:PrintMessage(HUD_PRINTTALK, self:GetName().." no longer likes you.")
					end
				end
			end

			-- Attempt to find who damaged me | RESULT: May become alerted if attacker is visible OR it may hide if it didn't find the attacker
			if !self.DisableTakeDamageFindEnemy && !self:BusyWithActivity() && !IsValid(self:GetEnemy()) && curTime > self.TakingCoverT && self.Behavior != VJ_BEHAVIOR_PASSIVE && self.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE then // self.Alerted == false
				local eneFound = false
				if dmgAttacker then
					local sightDist = self:GetMaxLookDistance()
					sightDist = math_min(math_max(sightDist / 2, sightDist <= 1000 and sightDist or 1000), sightDist)
					-- IF normal sight dist is less than 1000 then change nothing, OR ELSE use half the distance with 1000 as minimum
					if self:GetPos():Distance(dmgAttacker:GetPos()) <= sightDist && self:Visible(dmgAttacker) && self:CheckRelationship(dmgAttacker) == D_HT then
						//self:AddEntityRelationship(dmgAttacker, D_HT, 10)
						self:OnSetEnemyFromDamage(dmginfo, hitgroup)
						self.NextCallForHelpT = curTime + 1
						self:ForceSetEnemy(dmgAttacker, true)
						self:MaintainAlertBehavior()
						eneFound = true
					end
				end
				if !eneFound && self.HideOnUnknownDamage && !self.IsFollowing && self.MovementType != VJ_MOVETYPE_STATIONARY && dmginfo:GetDamageCustom() != VJ.DMG_BLEED then
					self:SCHEDULE_COVER_ORIGIN("TASK_RUN_PATH", function(x) x.CanShootWhenMoving = true x.FaceData = {Type = VJ.FACE_ENEMY} end)
					self.TakingCoverT = curTime + self.HideOnUnknownDamage
				end
			end
		end
		
		-- Make passive NPCs move away | RESULT: May move away AND may cause other passive NPCs to move as well
		if (self.Behavior == VJ_BEHAVIOR_PASSIVE or self.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE) && curTime > self.TakingCoverT then
			if stillAlive && self.Passive_RunOnDamage && !self:IsBusy() then
				self:SCHEDULE_COVER_ORIGIN("TASK_RUN_PATH")
			end
			if self.Passive_AlliesRunOnDamage then -- Make passive allies run too!
				local allies = self:Allies_Check(self.Passive_AlliesRunOnDamageDistance)
				if allies != false then
					for _, ally in ipairs(allies) do
						ally.TakingCoverT = curTime + math.Rand(ally.Passive_NextRunOnDamageTime.b, ally.Passive_NextRunOnDamageTime.a)
						ally:SCHEDULE_COVER_ORIGIN("TASK_RUN_PATH")
						ally:PlaySoundSystem("Alert")
					end
				end
			end
			self.TakingCoverT = curTime + math.Rand(self.Passive_NextRunOnDamageTime.a, self.Passive_NextRunOnDamageTime.b)
		end
	end
	
	-- If eating, stop!
	if self.CanEat && self.VJ_ST_Eating then
		self.EatingData.NextCheck = curTime + 15
		self:ResetEatingBehavior("Injured")
	end
	
	if self:Health() <= 0 && !self.Dead then
		self:RemoveEFlags(EFL_NO_DISSOLVE)
		if (dmginfo:IsDamageType(DMG_DISSOLVE)) or (dmgInflictor && dmgInflictor:GetClass() == "prop_combine_ball") then
			local dissolve = DamageInfo()
			dissolve:SetDamage(self:Health())
			dissolve:SetAttacker(dmginfo:GetAttacker())
			dissolve:SetDamageType(DMG_DISSOLVE)
			self:TakeDamageInfo(dissolve)
		end
		self:BeginDeath(dmginfo, hitgroup)
	end
	return 1
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vecZ500 = Vector(0, 0, 500)
local vecZ4 = Vector(0, 0, 4)
--
function ENT:BeginDeath(dmginfo, hitgroup)
	self.Dead = true
	self:SetSaveValue("m_lifeState", 1) -- LIFE_DYING
	self:OnDeath(dmginfo, hitgroup, "Initial")
	if self.Medic_Status then self:ResetMedicBehavior() end
	if self.IsFollowing then self:ResetFollowBehavior() end
	local dmgInflictor = dmginfo:GetInflictor()
	local dmgAttacker = dmginfo:GetAttacker()
	
	if VJ_CVAR_AI_ENABLED then
		local allies = self:Allies_Check(math_max(800, self.BringFriendsOnDeathDistance, self.AlertFriendsOnDeathDistance))
		if allies != false then
			local noAlert = true -- Don't run the AlertFriendsOnDeath if we have BringFriendsOnDeath enabled!
			if self.BringFriendsOnDeath then
				self:Allies_Bring("Diamond", self.BringFriendsOnDeathDistance, allies, self.BringFriendsOnDeathLimit, true)
				noAlert = false
			end
			local doBecomeEnemyToPlayer = (self.BecomeEnemyToPlayer && dmgAttacker:IsPlayer() && !VJ_CVAR_IGNOREPLAYERS) or false
			local it = 0 -- Number of allies that have been alerted
			for _, ally in ipairs(allies) do
				ally:DoReadyAlert()
				ally:OnAllyKilled(self)
				ally:PlaySoundSystem("AllyDeath")
				
				-- AlertFriendsOnDeath
				if noAlert && self.AlertFriendsOnDeath && !IsValid(ally:GetEnemy()) && ally.AlertFriendsOnDeath && it != self.AlertFriendsOnDeathLimit && self:GetPos():Distance(ally:GetPos()) < self.AlertFriendsOnDeathDistance && (!IsValid(ally:GetActiveWeapon()) or (IsValid(ally:GetActiveWeapon()) && !(ally:GetActiveWeapon().IsMeleeWeapon))) then
					it = it + 1
					local faceTime = math.Rand(5, 8)
					ally:SetTurnTarget(self:GetPos(), faceTime, true)
					ally.NextIdleTime = CurTime() + faceTime
				end
				
				-- BecomeEnemyToPlayer
				if doBecomeEnemyToPlayer && ally.BecomeEnemyToPlayer && ally:Disposition(dmgAttacker) == D_LI then
					local relationMemory = ally.RelationshipMemory[dmgAttacker]
					ally:SetRelationshipMemory(dmgAttacker, VJ.MEM_HOSTILITY_LEVEL, relationMemory[VJ.MEM_HOSTILITY_LEVEL] and relationMemory[VJ.MEM_HOSTILITY_LEVEL] + 1 or 1)
					if relationMemory[VJ.MEM_HOSTILITY_LEVEL] > ally.BecomeEnemyToPlayer then
						if ally:Disposition(dmgAttacker) != D_HT then
							ally:OnBecomeEnemyToPlayer(dmginfo, hitgroup)
							if ally.IsFollowing && ally.FollowData.Ent == dmgAttacker then ally:ResetFollowBehavior() end
							ally:SetRelationshipMemory(dmgAttacker, VJ.MEM_OVERRIDE_DISPOSITION, D_HT)
							ally:AddEntityRelationship(dmgAttacker, D_HT, 2)
							if ally.CanChatMessage then
								dmgAttacker:PrintMessage(HUD_PRINTTALK, ally:GetName().." no longer likes you.")
							end
							ally:PlaySoundSystem("BecomeEnemyToPlayer")
						end
						ally.Alerted = true
					end
				end
			end
		end
	end
	
	-- Blood decal on the ground
	if self.Bleeds && self.HasBloodDecal then
		local bloodDecal = PICK(self.BloodDecal)
		if bloodDecal then
			local decalPos = self:GetPos() + vecZ4
			self:SetLocalPos(decalPos) -- NPC is too close to the ground, we need to move it up a bit
			local tr = util.TraceLine({start = decalPos, endpos = decalPos - vecZ500, filter = self})
			util.Decal(bloodDecal, tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
		end
	end
	
	self:RemoveTimers()
	self:StopAllSounds()
	self.AttackType = VJ.ATTACK_TYPE_NONE
	self.HasMeleeAttack = false
	if IsValid(dmgAttacker) then
		if dmgAttacker:GetClass() == "npc_barnacle" then self.HasDeathCorpse = false end -- Don't make a corpse if it's killed by a barnacle!
		if vj_npc_ply_frag:GetInt() == 1 && dmgAttacker:IsPlayer() then dmgAttacker:AddFrags(1) end
		if IsValid(dmgInflictor) then
			gamemode.Call("OnNPCKilled", self, dmgAttacker, dmgInflictor, dmginfo)
		end
	end
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:GibOnDeath(dmginfo, hitgroup)
	self:PlaySoundSystem("Death")
	//if (self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC) then self:AA_StopMoving() end
	
	-- I/O events, from: https://github.com/ValveSoftware/source-sdk-2013/blob/0d8dceea4310fde5706b3ce1c70609d72a38efdf/mp/src/game/server/basecombatcharacter.cpp#L1582
	if IsValid(dmgAttacker) then -- Someone else killed me
		self:TriggerOutput("OnDeath", dmgAttacker)
		dmgAttacker:Fire("KilledNPC", "", 0, self, self) -- Allows player companions (npc_citizen) to respond to kill
	else
		self:TriggerOutput("OnDeath", self)
	end
	
	-- Handle death animation, death delay, and the final death phase
	local deathTime = self.DeathDelayTime
	if IsValid(dmgInflictor) && dmgInflictor:GetClass() == "prop_combine_ball" then self.HasDeathAnimation = false end
	if self.HasDeathAnimation && VJ_CVAR_AI_ENABLED && !dmginfo:IsDamageType(DMG_REMOVENORAGDOLL) && !dmginfo:IsDamageType(DMG_DISSOLVE) && self:GetNavType() != NAV_CLIMB && math.random(1, self.DeathAnimationChance) == 1 then
		self:RemoveAllGestures()
		self:OnDeath(dmginfo, hitgroup, "DeathAnim")
		local chosenAnim = PICK(self.AnimTbl_Death)
		local animTime = self:DecideAnimationLength(chosenAnim, self.DeathAnimationTime) - self.DeathAnimationDecreaseLengthAmount
		self:PlayAnim(chosenAnim, true, animTime, false, 0, {PlayBackRateCalculated=true})
		deathTime = deathTime + animTime
		self.DeathAnimationCodeRan = true
	else
		-- If no death anim then just set the NPC to dead even if it has a delayed remove
		self:SetSaveValue("m_lifeState", 2) -- LIFE_DEAD
	end
	if deathTime > 0 then
		timer.Simple(deathTime, function()
			if IsValid(self) then
				self:FinishDeath(dmginfo, hitgroup)
			end
		end)
	else
		self:FinishDeath(dmginfo, hitgroup)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FinishDeath(dmginfo, hitgroup)
	if self.VJ_DEBUG && GetConVar("vj_npc_debug_damage"):GetInt() == 1 then VJ.DEBUG_Print(self, "FinishDeath", "Attacker = ", self.SavedDmgInfo.attacker, " | Inflictor = ", self.SavedDmgInfo.inflictor) end
	self:SetSaveValue("m_lifeState", 2) -- LIFE_DEAD
	//self:SetNPCState(NPC_STATE_DEAD)
	self:OnDeath(dmginfo, hitgroup, "Finish")
	if self.DropDeathLoot then
		self:CreateDeathLoot(dmginfo, hitgroup)
	end
	if bit.band(self.SavedDmgInfo.type, DMG_REMOVENORAGDOLL) == 0 then self:DeathWeaponDrop(dmginfo, hitgroup) self:CreateDeathCorpse(dmginfo, hitgroup) end
	self:Remove()
end
---------------------------------------------------------------------------------------------------------------------------------------------
local colorGrey = Color(90, 90, 90)
--
function ENT:CreateDeathCorpse(dmginfo, hitgroup)
	-- In case it was not set
		-- NOTE: dmginfo at this point can be incorrect/corrupted, but its better than leaving the self.SavedDmgInfo empty!
	if !self.SavedDmgInfo then
		self.SavedDmgInfo = {
			dmginfo = dmginfo, -- The actual CTakeDamageInfo object | WARNING: Can be corrupted after a tick, recommended not to use this!
			attacker = dmginfo:GetAttacker(),
			inflictor = dmginfo:GetInflictor(),
			amount = dmginfo:GetDamage(),
			pos = dmginfo:GetDamagePosition(),
			type = dmginfo:GetDamageType(),
			force = dmginfo:GetDamageForce(),
			ammoType = dmginfo:GetAmmoType(),
			hitgroup = hitgroup,
		}
	end
	
	if self.HasDeathCorpse && self.HasDeathRagdoll != false then
		local corpseMdl = self:GetModel()
		local corpseMdlCustom = PICK(self.DeathCorpseModel)
		if corpseMdlCustom then corpseMdl = corpseMdlCustom end
		local corpseClass = "prop_physics"
		if self.DeathCorpseEntityClass then
			corpseClass = self.DeathCorpseEntityClass
		else
			if util.IsValidRagdoll(corpseMdl) then
				corpseClass = "prop_ragdoll"
			elseif !util.IsValidProp(corpseMdl) or !util.IsValidModel(corpseMdl) then
				if IsValid(self.WeaponEntity) then self.WeaponEntity:Remove() end
				return false
			end
		end
		self.Corpse = ents.Create(corpseClass)
		local corpse = self.Corpse
		corpse:SetModel(corpseMdl)
		corpse:SetPos(self:GetPos())
		corpse:SetAngles(self:GetAngles())
		corpse:Spawn()
		corpse:Activate()
		corpse:SetSkin(self:GetSkin())
		for i = 0, self:GetNumBodyGroups() do
			corpse:SetBodygroup(i, self:GetBodygroup(i))
		end
		corpse:SetColor(self:GetColor())
		corpse:SetMaterial(self:GetMaterial())
		if corpseMdlCustom == false && self.DeathCorpseSubMaterials != nil then -- Take care of sub materials
			for _, x in ipairs(self.DeathCorpseSubMaterials) do
				if self:GetSubMaterial(x) != "" then
					corpse:SetSubMaterial(x, self:GetSubMaterial(x))
				end
			end
			 -- This causes lag, not a very good way to do it.
			/*for x = 0, #self:GetMaterials() do
				if self:GetSubMaterial(x) != "" then
					corpse:SetSubMaterial(x, self:GetSubMaterial(x))
				end
			end*/
		end
		//corpse:SetName("corpse" .. self:EntIndex())
		//corpse:SetModelScale(self:GetModelScale())
		corpse.FadeCorpseType = (corpse:GetClass() == "prop_ragdoll" and "FadeAndRemove") or "kill"
		corpse.IsVJBaseCorpse = true
		corpse.DamageInfo = dmginfo
		corpse.ChildEnts = self.DeathCorpse_ChildEnts or {}
		corpse.BloodData = {Color = self.BloodColor, Particle = self.BloodParticle, Decal = self.BloodDecal}

		if self.Bleeds && self.HasBloodPool && vj_npc_blood_pool:GetInt() == 1 then
			self:SpawnBloodPool(dmginfo, hitgroup, corpse)
		end
		
		-- Collision
		corpse:SetCollisionGroup(self.DeathCorpseCollisionType)
		if ai_serverragdolls:GetInt() == 1 then
			undo.ReplaceEntity(self, corpse)
		else -- Keep corpses is not enabled...
			VJ.Corpse_Add(corpse)
			if vj_npc_corpse_undo:GetInt() == 1 then undo.ReplaceEntity(self, corpse) end -- Undoable
		end
		cleanup.ReplaceEntity(self, corpse) -- Delete on cleanup
		
		-- On fire
		if self:IsOnFire() then
			corpse:Ignite(math.Rand(8, 10), 0)
			if !self.Immune_Fire then -- Don't darken the corpse if we are immune to fire!
				corpse:SetColor(colorGrey)
				//corpse:SetMaterial("models/props_foliage/tree_deciduous_01a_trunk")
			end
		end
		
		-- Dissolve
		if (bit.band(self.SavedDmgInfo.type, DMG_DISSOLVE) != 0) or (IsValid(self.SavedDmgInfo.inflictor) && self.SavedDmgInfo.inflictor:GetClass() == "prop_combine_ball") then
			corpse:Dissolve(0, 1)
		end
		
		-- Bone and Angle
		-- If it's a bullet, it will use localized velocity on each bone depending on how far away the bone is from the dmg position
		local useLocalVel = (bit.band(self.SavedDmgInfo.type, DMG_BULLET) != 0 and self.SavedDmgInfo.pos != defPos) or false
		local dmgForce = (self.SavedDmgInfo.force / 40) + self:GetMoveVelocity() + self:GetVelocity()
		if self.DeathAnimationCodeRan then
			useLocalVel = false
			dmgForce = self:GetMoveVelocity() == defPos and self:GetGroundSpeedVelocity() or self:GetMoveVelocity()
		end
		local totalSurface = 0
		local physCount = corpse:GetPhysicsObjectCount()
		for childNum = 0, physCount - 1 do -- 128 = Bone Limit
			local childPhysObj = corpse:GetPhysicsObjectNum(childNum)
			if IsValid(childPhysObj) then
				totalSurface = totalSurface + childPhysObj:GetSurfaceArea()
				local childPhysObj_BonePos, childPhysObj_BoneAng = self:GetBonePosition(corpse:TranslatePhysBoneToBone(childNum))
				if childPhysObj_BonePos then
					if self.DeathCorpseSetBoneAngles then childPhysObj:SetAngles(childPhysObj_BoneAng) end
					childPhysObj:SetPos(childPhysObj_BonePos)
					if self.DeathCorpseApplyForce then
						childPhysObj:SetVelocity(dmgForce / math_max(1, (useLocalVel and childPhysObj_BonePos:Distance(self.SavedDmgInfo.pos) / 12) or 1))
					end
				-- If it's 1, then it's likely a regular physics model with no bones
				elseif physCount == 1 then
					if self.DeathCorpseApplyForce then
						childPhysObj:SetVelocity(dmgForce / math_max(1, (useLocalVel and corpse:GetPos():Distance(self.SavedDmgInfo.pos) / 12) or 1))
					end
				end
			end
		end
		
		-- Health & stink system
		if corpse:Health() <= 0 then
			local hpCalc = totalSurface / 60
			corpse:SetMaxHealth(hpCalc)
			corpse:SetHealth(hpCalc)
		end
		VJ.Corpse_AddStinky(corpse, true)
		
		if IsValid(self.WeaponEntity) then corpse.ChildEnts[#corpse.ChildEnts + 1] = self.WeaponEntity end
		if self.DeathCorpseFade then corpse:Fire(corpse.FadeCorpseType, "", self.DeathCorpseFade) end
		if vj_npc_corpse_fade:GetInt() == 1 then corpse:Fire(corpse.FadeCorpseType, "", vj_npc_corpse_fadetime:GetInt()) end
		self:OnCreateDeathCorpse(dmginfo, hitgroup, corpse)
		if corpse:IsFlagSet(FL_DISSOLVING) then
			if IsValid(self.WeaponEntity) then
				self.WeaponEntity:Dissolve(0, 1)
			end
			if corpse.ChildEnts then
				for _, child in ipairs(corpse.ChildEnts) do
					child:Dissolve(0, 1)
				end
			end
		end
		corpse:CallOnRemove("vj_" .. corpse:EntIndex(), function(ent, childPieces)
			for _, child in ipairs(childPieces) do
				if IsValid(child) then
					if child:GetClass() == "prop_ragdoll" then -- Make ragdolls fade
						child:Fire("FadeAndRemove", "", 0)
					else
						child:Fire("kill", "", 0)
					end
				end
			end
		end, corpse.ChildEnts)
		hook.Call("CreateEntityRagdoll", nil, self, corpse)
		return corpse
	else
		if IsValid(self.WeaponEntity) then self.WeaponEntity:Remove() end -- Remove dropped weapon
		-- Remove child entities | No fade effects as it will look weird, remove it instantly!
		if self.DeathCorpse_ChildEnts then
			for _, child in ipairs(self.DeathCorpse_ChildEnts) do
				child:Remove()
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeathWeaponDrop(dmginfo, hitgroup)
	local activeWep = self:GetActiveWeapon()
	if !self.DropWeaponOnDeath or !IsValid(activeWep) then return end
	
	-- Save its original pos & ang in case the weapon uses custom world model pos & ang
	-- because doing DropWeapon will mess up its spawn pos and ang, example: K-3 will spawn floating above the NPC
	local orgPos, orgAng = activeWep:GetPos(), activeWep:GetAngles()
	self:DropWeapon(activeWep, nil, self:GetForward()) -- Override the velocity so it doesn't throw the weapon (default source behavior)
	if activeWep.WorldModel_UseCustomPosition then
		activeWep:SetPos(orgPos)
		activeWep:SetAngles(orgAng)
	end
	local phys = activeWep:GetPhysicsObject()
	if IsValid(phys) then
		if (bit.band(self.SavedDmgInfo.type, DMG_DISSOLVE) != 0) or (IsValid(self.SavedDmgInfo.inflictor) && self.SavedDmgInfo.inflictor:GetClass() == "prop_combine_ball") then
			phys:EnableGravity(false)
			phys:SetVelocity(self:GetForward()*-150 + self:GetRight()*math.Rand(100, -100) + self:GetUp()*50)
		else
			local dmgForce = (self.SavedDmgInfo.force / 40) + self:GetMoveVelocity() + self:GetVelocity()
			if self.DeathAnimationCodeRan then
				dmgForce = self:GetMoveVelocity() == defPos and self:GetGroundSpeedVelocity() or self:GetMoveVelocity()
			end
			phys:SetMass(1)
			phys:ApplyForceCenter(dmgForce)
		end
	end
	self.WeaponEntity = activeWep
	
	self:OnDeathWeaponDrop(dmginfo, hitgroup, activeWep)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PlaySoundSystem(sdSet, customSD, sdType)
	if !self.HasSounds or !sdSet then return end
	sdType = sdType or VJ.CreateSound
	customSD = PICK(customSD)
	
	if sdSet == "FollowPlayer" then
		if self.HasFollowPlayerSounds then
			local pickedSD = PICK(self.SoundTbl_FollowPlayer)
			if (math.random(1, self.FollowPlayerSoundChance) == 1 && pickedSD) or customSD then
				if customSD then pickedSD = customSD end
				StopSound(self.CurrentSpeechSound)
				StopSound(self.CurrentIdleSound)
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(3, 4)
				self.CurrentSpeechSound = sdType(self, pickedSD, self.FollowPlayerSoundLevel, self:GetSoundPitch(self.FollowPlayerPitch.a, self.FollowPlayerPitch.b))
			end
		end
	elseif sdSet == "UnFollowPlayer" then
		if self.HasFollowPlayerSounds then
			local pickedSD = PICK(self.SoundTbl_UnFollowPlayer)
			if (math.random(1, self.FollowPlayerSoundChance) == 1 && pickedSD) or customSD then
				if customSD then pickedSD = customSD end
				StopSound(self.CurrentSpeechSound)
				StopSound(self.CurrentIdleSound)
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(3, 4)
				self.CurrentSpeechSound = sdType(self, pickedSD, self.FollowPlayerSoundLevel, self:GetSoundPitch(self.FollowPlayerPitch.a, self.FollowPlayerPitch.b))
			end
		end
	elseif sdSet == "OnReceiveOrder" then
		if self.HasOnReceiveOrderSounds then
			local pickedSD = PICK(self.SoundTbl_OnReceiveOrder)
			if (math.random(1, self.OnReceiveOrderSoundChance) == 1 && pickedSD) or customSD then
				if customSD then pickedSD = customSD end
				StopSound(self.CurrentSpeechSound)
				StopSound(self.CurrentIdleSound)
				self.NextIdleSoundT = self.NextIdleSoundT + 2
				self.NextAlertSoundT = CurTime() + 2
				self.CurrentSpeechSound = sdType(self, pickedSD, self.OnReceiveOrderSoundLevel, self:GetSoundPitch(self.OnReceiveOrderSoundPitch.a, self.OnReceiveOrderSoundPitch.b))
			end
		end
	elseif sdSet == "MoveOutOfPlayersWay" then
		if self.HasMoveOutOfPlayersWaySounds then
			local pickedSD = PICK(self.SoundTbl_MoveOutOfPlayersWay)
			if (math.random(1, self.MoveOutOfPlayersWaySoundChance) == 1 && pickedSD) or customSD then
				if customSD then pickedSD = customSD end
				StopSound(self.CurrentSpeechSound)
				StopSound(self.CurrentIdleSound)
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(3, 4)
				self.CurrentSpeechSound = sdType(self, pickedSD, self.MoveOutOfPlayersWaySoundLevel, self:GetSoundPitch(self.MoveOutOfPlayersWaySoundPitch.a, self.MoveOutOfPlayersWaySoundPitch.b))
			end
		end
	elseif sdSet == "MedicBeforeHeal" then
		if self.HasMedicSounds_BeforeHeal then
			local pickedSD = PICK(self.SoundTbl_MedicBeforeHeal)
			if (math.random(1, self.MedicBeforeHealSoundChance) == 1 && pickedSD) or customSD then
				if customSD then pickedSD = customSD end
				StopSound(self.CurrentSpeechSound)
				StopSound(self.CurrentIdleSound)
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(3, 4)
				self.CurrentSpeechSound = sdType(self, pickedSD, self.BeforeHealSoundLevel, self:GetSoundPitch(self.BeforeHealSoundPitch.a, self.BeforeHealSoundPitch.b))
			end
		end
	elseif sdSet == "MedicOnHeal" then
		if self.HasMedicSounds_AfterHeal then
			local pickedSD = PICK(self.SoundTbl_MedicAfterHeal) or "items/smallmedkit1.wav"
			if (math.random(1, self.MedicAfterHealSoundChance) == 1 && pickedSD) or customSD then
				if customSD then pickedSD = customSD end
				StopSound(self.CurrentSpeechSound)
				StopSound(self.CurrentIdleSound)
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(3, 4)
				self.CurrentMedicAfterHealSound = sdType(self, pickedSD, self.AfterHealSoundLevel, self:GetSoundPitch(self.AfterHealSoundPitch.a, self.AfterHealSoundPitch.b))
			end
		end
	elseif sdSet == "MedicReceiveHeal" then
		if self.HasMedicSounds_ReceiveHeal then
			local pickedSD = PICK(self.SoundTbl_MedicReceiveHeal)
			if (math.random(1, self.MedicReceiveHealSoundChance) == 1 && pickedSD) or customSD then
				if customSD then pickedSD = customSD end
				StopSound(self.CurrentSpeechSound)
				StopSound(self.CurrentIdleSound)
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(3, 4)
				self.CurrentSpeechSound = sdType(self, pickedSD, self.MedicReceiveHealSoundLevel, self:GetSoundPitch(self.MedicReceiveHealSoundPitch.a, self.MedicReceiveHealSoundPitch.b))
			end
		end
	elseif sdSet == "OnPlayerSight" then
		if self.HasOnPlayerSightSounds then
			local pickedSD = PICK(self.SoundTbl_OnPlayerSight)
			if (math.random(1, self.OnPlayerSightSoundChance) == 1 && pickedSD) or customSD then
				if customSD then pickedSD = customSD end
				StopSound(self.CurrentSpeechSound)
				StopSound(self.CurrentIdleSound)
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(3, 4)
				self.NextAlertSoundT = CurTime() + math.random(1,2)
				self.CurrentSpeechSound = sdType(self, pickedSD, self.OnPlayerSightSoundLevel, self:GetSoundPitch(self.OnPlayerSightSoundPitch.a, self.OnPlayerSightSoundPitch.b))
			end
		end
	elseif sdSet == "InvestigateSound" then
		if self.HasInvestigateSounds && CurTime() > self.NextInvestigateSoundT then
			local pickedSD = PICK(self.SoundTbl_Investigate)
			if (math.random(1, self.InvestigateSoundChance) == 1 && pickedSD) or customSD then
				if customSD then pickedSD = customSD end
				StopSound(self.CurrentSpeechSound)
				StopSound(self.CurrentIdleSound)
				self.NextIdleSoundT = self.NextIdleSoundT + 2
				self.CurrentSpeechSound = sdType(self, pickedSD, self.InvestigateSoundLevel, self:GetSoundPitch(self.InvestigateSoundPitch.a, self.InvestigateSoundPitch.b))
			end
			self.NextInvestigateSoundT = CurTime() + math.Rand(self.NextSoundTime_Investigate.a, self.NextSoundTime_Investigate.b)
		end
	elseif sdSet == "LostEnemy" then
		if self.HasLostEnemySounds && CurTime() > self.NextLostEnemySoundT then
			local pickedSD = PICK(self.SoundTbl_LostEnemy)
			if (math.random(1, self.LostEnemySoundChance) == 1 && pickedSD) or customSD then
				if customSD then pickedSD = customSD end
				StopSound(self.CurrentSpeechSound)
				StopSound(self.CurrentIdleSound)
				self.NextIdleSoundT = self.NextIdleSoundT + 2
				self.CurrentSpeechSound = sdType(self, pickedSD, self.LostEnemySoundLevel, self:GetSoundPitch(self.LostEnemySoundPitch.a, self.LostEnemySoundPitch.b))
			end
			self.NextLostEnemySoundT = CurTime() + math.Rand(self.NextSoundTime_LostEnemy.a, self.NextSoundTime_LostEnemy.b)
		end
	elseif sdSet == "Alert" then
		if self.HasAlertSounds then
			local pickedSD = PICK(self.SoundTbl_Alert)
			if (math.random(1, self.AlertSoundChance) == 1 && pickedSD) or customSD then
				if customSD then pickedSD = customSD end
				StopSound(self.CurrentSpeechSound)
				StopSound(self.CurrentIdleSound)
				local dur = CurTime() + ((((SoundDuration(pickedSD) > 0) and SoundDuration(pickedSD)) or 2) + 1)
				self.NextIdleSoundT = dur
				self.NextPainSoundT = dur
				self.NextSuppressingSoundT = CurTime() + 4
				self.NextAlertSoundT = CurTime() + math.Rand(self.NextSoundTime_Alert.a, self.NextSoundTime_Alert.b)
				self.CurrentSpeechSound = sdType(self, pickedSD, self.AlertSoundLevel, self:GetSoundPitch(self.AlertSoundPitch.a, self.AlertSoundPitch.b))
			end
		end
	elseif sdSet == "CallForHelp" then
		if self.HasCallForHelpSounds then
			local pickedSD = PICK(self.SoundTbl_CallForHelp)
			if (math.random(1, self.CallForHelpSoundChance) == 1 && pickedSD) or customSD then
				if customSD then pickedSD = customSD end
				StopSound(self.CurrentSpeechSound)
				StopSound(self.CurrentIdleSound)
				self.NextIdleSoundT = self.NextIdleSoundT + 2
				self.NextSuppressingSoundT = CurTime() + math.random(2.5, 4)
				self.CurrentSpeechSound = sdType(self, pickedSD, self.CallForHelpSoundLevel, self:GetSoundPitch(self.CallForHelpSoundPitch.a, self.CallForHelpSoundPitch.b))
			end
		end
	elseif sdSet == "BecomeEnemyToPlayer" then
		if self.HasBecomeEnemyToPlayerSounds then
			local pickedSD = PICK(self.SoundTbl_BecomeEnemyToPlayer)
			if (math.random(1, self.BecomeEnemyToPlayerChance) == 1 && pickedSD) or customSD then
				if customSD then pickedSD = customSD end
				StopSound(self.CurrentSpeechSound)
				StopSound(self.CurrentIdleSound)
				local dur = CurTime() + ((((SoundDuration(pickedSD) > 0) and SoundDuration(pickedSD)) or 2) + 1)
				self.NextPainSoundT = dur
				self.NextAlertSoundT = dur
				self.NextInvestigateSoundT = CurTime() + 2
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(2, 3)
				self.NextSuppressingSoundT = CurTime() + math.random(2.5, 4)
				self.CurrentSpeechSound = sdType(self, pickedSD, self.BecomeEnemyToPlayerSoundLevel, self:GetSoundPitch(self.BecomeEnemyToPlayerPitch.a, self.BecomeEnemyToPlayerPitch.b))
			end
		end
	elseif sdSet == "OnKilledEnemy" then
		if self.HasOnKilledEnemySound && CurTime() > self.NextOnKilledEnemySoundT then
			local pickedSD = PICK(self.SoundTbl_OnKilledEnemy)
			if (math.random(1, self.OnKilledEnemySoundChance) == 1 && pickedSD) or customSD then
				if customSD then pickedSD = customSD end
				StopSound(self.CurrentSpeechSound)
				StopSound(self.CurrentIdleSound)
				self.NextIdleSoundT = self.NextIdleSoundT + 2
				self.CurrentSpeechSound = sdType(self, pickedSD, self.OnKilledEnemySoundLevel, self:GetSoundPitch(self.OnKilledEnemySoundPitch.a, self.OnKilledEnemySoundPitch.b))
			end
			self.NextOnKilledEnemySoundT = CurTime() + math.Rand(self.NextSoundTime_OnKilledEnemy.a, self.NextSoundTime_OnKilledEnemy.b)
		end
	elseif sdSet == "AllyDeath" then
		if self.HasOnKilledEnemySound && CurTime() > self.NextAllyDeathSoundT then
			local pickedSD = PICK(self.SoundTbl_AllyDeath)
			if (math.random(1, self.AllyDeathSoundChance) == 1 && pickedSD) or customSD then
				if customSD then pickedSD = customSD end
				StopSound(self.CurrentSpeechSound)
				StopSound(self.CurrentIdleSound)
				self.NextIdleSoundT = self.NextIdleSoundT + 2
				self.CurrentSpeechSound = sdType(self, pickedSD, self.AllyDeathSoundLevel, self:GetSoundPitch(self.AllyDeathSoundPitch.a, self.AllyDeathSoundPitch.b))
			end
			self.NextAllyDeathSoundT = CurTime() + math.Rand(self.NextSoundTime_AllyDeath.a, self.NextSoundTime_AllyDeath.b)
		end
	elseif sdSet == "Pain" then
		if self.HasPainSounds && CurTime() > self.NextPainSoundT then
			local pickedSD = PICK(self.SoundTbl_Pain)
			local sdDur = 2
			if (math.random(1, self.PainSoundChance) == 1 && pickedSD) or customSD then
				if customSD then pickedSD = customSD end
				StopSound(self.CurrentSpeechSound)
				StopSound(self.CurrentIdleSound)
				self.NextIdleSoundT_RegularChange = CurTime() + 1
				self.CurrentSpeechSound = sdType(self, pickedSD, self.PainSoundLevel, self:GetSoundPitch(self.PainSoundPitch.a, self.PainSoundPitch.b))
				sdDur = (SoundDuration(pickedSD) > 0 and SoundDuration(pickedSD)) or sdDur
			end
			self.NextPainSoundT = CurTime() + sdDur
		end
	elseif sdSet == "Impact" then
		if self.HasImpactSounds then
			local pickedSD = PICK(self.SoundTbl_Impact) or "Flesh.BulletImpact"
			if (math.random(1, self.ImpactSoundChance) == 1 && pickedSD) or customSD then
				if customSD then pickedSD = customSD end
				self.CurrentImpactSound = sdType(self, pickedSD, self.ImpactSoundLevel, self:GetSoundPitch(self.ImpactSoundPitch.a, self.ImpactSoundPitch.b))
			end
		end
	elseif sdSet == "DamageByPlayer" then
		//if self.HasDamageByPlayerSounds && CurTime() > self.NextDamageByPlayerSoundT then -- This is done in the call instead
			local pickedSD = PICK(self.SoundTbl_DamageByPlayer)
			local sdDur = 2
			if (math.random(1, self.DamageByPlayerSoundChance) == 1 && pickedSD) or customSD then
				if customSD then pickedSD = customSD end
				StopSound(self.CurrentSpeechSound)
				StopSound(self.CurrentIdleSound)
				sdDur = (SoundDuration(pickedSD) > 0 and SoundDuration(pickedSD)) or sdDur
				self.NextPainSoundT = CurTime() + sdDur
				self.NextIdleSoundT_RegularChange = CurTime() + sdDur
				self.CurrentSpeechSound = sdType(self, pickedSD, self.DamageByPlayerSoundLevel, self:GetSoundPitch(self.DamageByPlayerPitch.a, self.DamageByPlayerPitch.b))
			end
			self.NextDamageByPlayerSoundT = CurTime() + sdDur
		//end
	elseif sdSet == "Death" then
		if self.HasDeathSounds then
			local pickedSD = PICK(self.SoundTbl_Death)
			if (math.random(1, self.DeathSoundChance) == 1 && pickedSD) or customSD then
				if customSD then pickedSD = customSD end
				self.CurrentDeathSound = sdType(self, pickedSD, self.DeathSoundLevel, self:GetSoundPitch(self.DeathSoundPitch.a, self.DeathSoundPitch.b))
			end
		end
	elseif sdSet == "Gib" then
		if self.HasGibOnDeathSounds then
			sdType = VJ.EmitSound
			if customSD then
				sdType(self, customSD, 80, math.random(80, 100))
			else
				sdType(self, "vj_base/gib/splat.wav", 80, math.random(85, 100))
				sdType(self, "vj_base/gib/break1.wav", 80, math.random(85, 100))
				sdType(self, "vj_base/gib/break2.wav", 80, math.random(85, 100))
				sdType(self, "vj_base/gib/break3.wav", 80, math.random(85, 100))
			end
		end
	--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-- Base-Specific Sound Tables --=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
	elseif sdSet == "Suppressing" then
		if self.HasSuppressingSounds && CurTime() > self.NextSuppressingSoundT then
			local pickedSD = PICK(self.SoundTbl_Suppressing)
			if (math.random(1, self.SuppressingSoundChance) == 1 && pickedSD) or customSD then
				if customSD then pickedSD = customSD end
				StopSound(self.CurrentSpeechSound)
				StopSound(self.CurrentIdleSound)
				self.NextIdleSoundT_RegularChange = CurTime() + 2
				self.CurrentSpeechSound = sdType(self, pickedSD, self.SuppressingSoundLevel, self:GetSoundPitch(self.SuppressingPitch.a, self.SuppressingPitch.b))
			end
			self.NextSuppressingSoundT = CurTime() + math.Rand(self.NextSoundTime_Suppressing.a, self.NextSoundTime_Suppressing.b)
		end
	elseif sdSet == "WeaponReload" then
		if self.HasWeaponReloadSounds then
			local pickedSD = PICK(self.SoundTbl_WeaponReload)
			if (math.random(1, self.WeaponReloadSoundChance) == 1 && pickedSD) or customSD then
				if customSD then pickedSD = customSD end
				StopSound(self.CurrentSpeechSound)
				StopSound(self.CurrentIdleSound)
				self.NextIdleSoundT_RegularChange = CurTime() + ((SoundDuration(pickedSD) > 0 and SoundDuration(pickedSD)) or 3.5)
				self.CurrentSpeechSound = sdType(self, pickedSD, self.WeaponReloadSoundLevel, self:GetSoundPitch(self.WeaponReloadSoundPitch.a, self.WeaponReloadSoundPitch.b))
			end
		end
	elseif sdSet == "BeforeMeleeAttack" then
		if self.HasMeleeAttackSounds then
			local pickedSD = PICK(self.SoundTbl_BeforeMeleeAttack)
			if (math.random(1, self.BeforeMeleeAttackSoundChance) == 1 && pickedSD) or customSD then
				if customSD then pickedSD = customSD end
				StopSound(self.CurrentSpeechSound)
				StopSound(self.CurrentExtraSpeechSound)
				if self.IdleSounds_PlayOnAttacks == false then StopSound(self.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
				self.NextIdleSoundT_RegularChange = CurTime() + 1
				self.CurrentExtraSpeechSound = sdType(self, pickedSD, self.BeforeMeleeAttackSoundLevel, self:GetSoundPitch(self.BeforeMeleeAttackSoundPitch.a, self.BeforeMeleeAttackSoundPitch.b))
			end
		end
	elseif sdSet == "MeleeAttack" then
		if self.HasMeleeAttackSounds then
			local pickedSD = PICK(self.SoundTbl_MeleeAttack)
			if pickedSD == false then pickedSD = PICK(self.DefaultSoundTbl_MeleeAttack) end -- Default table
			if (math.random(1, self.MeleeAttackSoundChance) == 1 && pickedSD) or customSD then
				if customSD then pickedSD = customSD end
				StopSound(self.CurrentSpeechSound)
				if self.IdleSounds_PlayOnAttacks == false then StopSound(self.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
				self.NextIdleSoundT_RegularChange = CurTime() + 1
				self.CurrentSpeechSound = sdType(self, pickedSD, self.MeleeAttackSoundLevel, self:GetSoundPitch(self.MeleeAttackSoundPitch.a, self.MeleeAttackSoundPitch.b))
			end
			if self.HasExtraMeleeAttackSounds then
				pickedSD = PICK(self.SoundTbl_MeleeAttackExtra)
				if (math.random(1, self.ExtraMeleeSoundChance) == 1 && pickedSD) or customSD then
					if self.IdleSounds_PlayOnAttacks == false then StopSound(self.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
					VJ.EmitSound(self, pickedSD, self.ExtraMeleeAttackSoundLevel, self:GetSoundPitch(self.ExtraMeleeSoundPitch.a, self.ExtraMeleeSoundPitch.b))
				end
			end
		end
	elseif sdSet == "MeleeAttackMiss" then
		if self.HasMeleeAttackMissSounds then
			local pickedSD = PICK(self.SoundTbl_MeleeAttackMiss) or "Zombie.AttackMiss"
			if (math.random(1, self.MeleeAttackMissSoundChance) == 1 && pickedSD) or customSD then
				if customSD then pickedSD = customSD end
				if self.IdleSounds_PlayOnAttacks == false then StopSound(self.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
				StopSound(self.CurrentMeleeAttackMissSound)
				self.NextIdleSoundT_RegularChange = CurTime() + 1
				self.CurrentMeleeAttackMissSound = sdType(self, pickedSD, self.MeleeAttackMissSoundLevel, self:GetSoundPitch(self.MeleeAttackMissSoundPitch.a, self.MeleeAttackMissSoundPitch.b))
			end
		end
	elseif sdSet == "GrenadeAttack" then
		if self.HasGrenadeAttackSounds && CurTime() > self.NextGrenadeAttackSoundT then
			local pickedSD = PICK(self.SoundTbl_GrenadeAttack)
			if (math.random(1, self.GrenadeAttackSoundChance) == 1 && pickedSD) or customSD then
				if customSD then pickedSD = customSD end
				StopSound(self.CurrentSpeechSound)
				if self.IdleSounds_PlayOnAttacks == false then StopSound(self.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(3, 4)
				self.CurrentSpeechSound = sdType(self, pickedSD, self.GrenadeAttackSoundLevel, self:GetSoundPitch(self.GrenadeAttackSoundPitch.a, self.GrenadeAttackSoundPitch.b))
			end
		end
	elseif sdSet == "OnGrenadeSight" then
		if self.HasOnGrenadeSightSounds && CurTime() > self.NextOnGrenadeSightSoundT then
			local pickedSD = PICK(self.SoundTbl_OnGrenadeSight)
			local sdDur = 3
			if (math.random(1, self.OnGrenadeSightSoundChance) == 1 && pickedSD) or customSD then
				if customSD then pickedSD = customSD end
				StopSound(self.CurrentSpeechSound)
				StopSound(self.CurrentIdleSound)
				sdDur = (SoundDuration(pickedSD) > 0 and SoundDuration(pickedSD)) or sdDur
				self.NextIdleSoundT_RegularChange = CurTime() + sdDur
				self.CurrentSpeechSound = sdType(self, pickedSD, self.OnGrenadeSightSoundLevel, self:GetSoundPitch(self.OnGrenadeSightSoundPitch.a, self.OnGrenadeSightSoundPitch.b))
			end
			self.NextOnGrenadeSightSoundT = CurTime() + sdDur
		end
	elseif sdSet == "OnDangerSight" then
		if self.HasOnDangerSightSounds && CurTime() > self.NextOnDangerSightSoundT then
			local pickedSD = PICK(self.SoundTbl_OnDangerSight)
			local sdDur = 3
			if (math.random(1, self.OnDangerSightSoundChance) == 1 && pickedSD) or customSD then
				if customSD then pickedSD = customSD end
				StopSound(self.CurrentSpeechSound)
				StopSound(self.CurrentIdleSound)
				sdDur = (SoundDuration(pickedSD) > 0 and SoundDuration(pickedSD)) or sdDur
				self.NextIdleSoundT_RegularChange = CurTime() + sdDur
				self.CurrentSpeechSound = sdType(self, pickedSD, self.OnDangerSightSoundLevel, self:GetSoundPitch(self.OnDangerSightSoundPitch.a, self.OnDangerSightSoundPitch.b))
			end
			self.NextOnDangerSightSoundT = CurTime() + sdDur
		end
	else -- Such as "Speech"
		if customSD then
			StopSound(self.CurrentSpeechSound)
			StopSound(self.CurrentIdleSound)
			self.NextIdleSoundT_RegularChange = CurTime() + ((((SoundDuration(customSD) > 0) and SoundDuration(customSD)) or 2) + 1)
			self.CurrentSpeechSound = sdType(self, customSD, 80, self:GetSoundPitch(self.GeneralSoundPitch1, self.GeneralSoundPitch2))
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FootStepSoundCode(customSD)
	if self.HasSounds && self.HasFootStepSound && self.MovementType != VJ_MOVETYPE_STATIONARY && self:IsOnGround() then
		if self.DisableFootStepSoundTimer then
			-- Use custom table if available, if none found then use the footstep sound table, if again none found then use the backup default footstep sounds
			local pickedSD = (customSD and PICK(customSD)) or PICK(self.SoundTbl_FootStep) or DefaultSoundTbl_FootStep
			if pickedSD then
				VJ.EmitSound(self, pickedSD, self.FootStepSoundLevel, self:GetSoundPitch(self.FootStepPitch.a, self.FootStepPitch.b))
				local funcCustom = self.OnFootstepSound; if funcCustom then funcCustom(self, "Event", pickedSD) end
			end
		elseif self:IsMoving() && CurTime() > self.NextFootstepSoundT && self:GetMoveDelay() <= 0 then
			-- Use custom table if available, if none found then use the footstep sound table, if again none found then use the backup default footstep sounds
			local pickedSD = (customSD and PICK(customSD)) or PICK(self.SoundTbl_FootStep) or DefaultSoundTbl_FootStep
			if pickedSD then
				if self.FootStepTimeRun && self:GetMovementActivity() == ACT_RUN then
					VJ.EmitSound(self, pickedSD, self.FootStepSoundLevel, self:GetSoundPitch(self.FootStepPitch.a, self.FootStepPitch.b))
					local funcCustom = self.OnFootstepSound; if funcCustom then funcCustom(self, "Run", pickedSD) end
					self.NextFootstepSoundT = CurTime() + self.FootStepTimeRun
				elseif self.FootStepTimeWalk && self:GetMovementActivity() == ACT_WALK then
					VJ.EmitSound(self, pickedSD, self.FootStepSoundLevel, self:GetSoundPitch(self.FootStepPitch.a, self.FootStepPitch.b))
					local funcCustom = self.OnFootstepSound; if funcCustom then funcCustom(self, "Walk", pickedSD) end
					self.NextFootstepSoundT = CurTime() + self.FootStepTimeWalk
				end
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetAttackSpread(wep, target)
	return
end