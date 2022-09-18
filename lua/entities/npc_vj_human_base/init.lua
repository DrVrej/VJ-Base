if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
AddCSLuaFile("shared.lua")
include("vj_base/npc_general.lua")
include("vj_base/npc_schedules.lua")
include("vj_base/npc_movetype_aa.lua")
include("shared.lua")
/*--------------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AccessorFunc(ENT, "m_iClass", "NPCClass", FORCE_NUMBER)
AccessorFunc(ENT, "m_fMaxYawSpeed", "MaxYawSpeed", FORCE_NUMBER)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Core Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.Model = {} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.VJ_IsHugeMonster = false -- This is mostly used for massive or boss SNPCs, it affects certain part of the SNPC, for example the SNPC won't receive any knock back
	-- ====== Health ====== --
ENT.StartHealth = 50 -- The starting health of the NPC
ENT.HasHealthRegeneration = false -- Can the SNPC regenerate its health?
ENT.HealthRegenerationAmount = 4 -- How much should the health increase after every delay?
ENT.HealthRegenerationDelay = VJ_Set(2, 4) -- How much time until the health increases
ENT.HealthRegenerationResetOnDmg = true -- Should the delay reset when it receives damage?
	-- ====== Collision / Hitbox Variables ====== --
ENT.HullType = HULL_HUMAN
ENT.HasHull = true -- Set to false to disable HULL
ENT.HullSizeNormal = true -- set to false to cancel out the self:SetHullSizeNormal()
ENT.HasSetSolid = true -- set to false to disable SetSolid
	-- ====== Sight & Speed Variables ====== --
ENT.SightDistance = 10000 -- How far it can see | Remember to call "self:SetSightDistance(dist)" if you want to set a new value after initialize!
ENT.SightAngle = 80 -- The sight angle | Example: 180 would make the it see all around it | Measured in degrees and then converted to radians
ENT.TurningSpeed = 20 -- How fast it can turn
ENT.TurningUseAllAxis = false -- If set to true, angles will not be restricted to y-axis, it will change all axes (plural axis)
ENT.AnimationPlaybackRate = 1 -- Controls the playback rate of all the animations
	-- ====== Movement Variables ====== --
	-- Types: VJ_MOVETYPE_GROUND | VJ_MOVETYPE_AERIAL | VJ_MOVETYPE_AQUATIC | VJ_MOVETYPE_STATIONARY | VJ_MOVETYPE_PHYSICS
ENT.MovementType = VJ_MOVETYPE_GROUND -- How does the SNPC move?
ENT.UsePlayerModelMovement = false -- If true, it will allow the NPC to use player models properly by calculating the direction it needs to go to and setting the appropriate values
	-- Jumping Variables:
	-- Requires "CAP_MOVE_JUMP" | Applied automatically by the base if "ACT_JUMP" is valid on the NPC's model
ENT.AllowMovementJumping = true -- Should the NPC be allowed to jump from one node to another?
ENT.MaxJumpLegalDistance = VJ_Set(150, 280) -- The max distance the NPC can jump (Usually from one node to another) | ( UP, DOWN )
	-- Stationary Move Type Variables:
ENT.CanTurnWhileStationary = true -- If true, the NPC will be able to turn while it's stationary
ENT.Stationary_UseNoneMoveType = false -- Technical variable, used if there is any issues with the NPC's position (It has its downsides, use only when needed!)
	-- ====== Controller Data ====== --
ENT.VJC_Data = {
	CameraMode = 1, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
	ThirdP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in third person
	FirstP_Bone = "ValveBiped.Bip01_Head1", -- If left empty, the base will attempt to calculate a position for first person
	FirstP_Offset = Vector(0, 0, 5), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = true, -- Should the bone shrink? Useful if the bone is obscuring the player's view
	FirstP_CameraBoneAng = 0, -- Should the camera's angle be affected by the bone's angle? | 0 = No, 1 = Pitch, 2 = Yaw, 3 = Roll
	FirstP_CameraBoneAng_Offset = 0, -- How much should the camera's angle be rotated by? | Useful for weird bone angles
}
	-- ====== Miscellaneous Variables ====== --
ENT.HasEntitiesToNoCollide = true -- If set to false, it won't run the EntitiesToNoCollide code
ENT.EntitiesToNoCollide = {} -- Entities to not collide with when HasEntitiesToNoCollide is set to true
ENT.AllowPrintingInChat = true -- Should this SNPC be allowed to post in player's chat? Example: "Blank no longer likes you."
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ AI / Relationship Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.CanOpenDoors = true -- Can it open doors?
ENT.HasAllies = true -- Put to false if you want it not to have any allies
ENT.VJ_NPC_Class = {} -- NPCs with the same class with be allied to each other
	-- Common Classes: Combine = CLASS_COMBINE || Zombie = CLASS_ZOMBIE || Antlions = CLASS_ANTLION || Xen = CLASS_XEN || Player Friendly = CLASS_PLAYER_ALLY
ENT.FriendsWithAllPlayerAllies = false -- Should this SNPC be friends with all other player allies that are running on VJ Base?
ENT.Behavior = VJ_BEHAVIOR_AGGRESSIVE -- The behavior of the SNPC
	-- VJ_BEHAVIOR_AGGRESSIVE = Default behavior, attacks enemies || VJ_BEHAVIOR_NEUTRAL = Neutral to everything, unless provoked
	-- VJ_BEHAVIOR_PASSIVE = Doesn't attack, but can be attacked by others || VJ_BEHAVIOR_PASSIVE_NATURE = Doesn't attack and is allied with everyone
ENT.IsGuard = false -- If set to false, it will attempt to stick to its current position at all times
ENT.AlertedToIdleTime = VJ_Set(4, 6) -- How much time until it calms down after the enemy has been killed/disappeared | Sets self.Alerted to false after the timer expires
ENT.MoveOutOfFriendlyPlayersWay = true -- Should the SNPC move out of the way when a friendly player comes close to it?
ENT.BecomeEnemyToPlayer = false -- Should the friendly SNPC become enemy towards the player if it's damaged by it or it witnesses another ally killed by it
ENT.BecomeEnemyToPlayerLevel = 2 -- Any time the player does something bad, the NPC's anger level raises by 1, if it surpasses this, it will become enemy!
	-- ====== Old Variables (Can still be used, but it's recommended not to use them) ====== --
ENT.PlayerFriendly = false -- Makes the SNPC friendly to the player and HL2 Resistance
	-- ====== Passive Behavior Variables ====== --
ENT.Passive_RunOnTouch = true -- Should it run away and make a alert sound when something collides with it?
ENT.Passive_NextRunOnTouchTime = VJ_Set(3, 4) -- How much until it can run away again when something collides with it?
ENT.Passive_RunOnDamage = true -- Should it run when it's damaged? | This doesn't impact how self.Passive_AlliesRunOnDamage works
ENT.Passive_AlliesRunOnDamage = true -- Should its allies (other passive SNPCs) also run when it's damaged?
ENT.Passive_AlliesRunOnDamageDistance = 800 -- Any allies within this distance will run when it's damaged
ENT.Passive_NextRunOnDamageTime = VJ_Set(6, 7) -- How much until it can run the code again?
	-- ====== On Player Sight Variables ====== --
ENT.HasOnPlayerSight = false -- Should do something when it sees the enemy? Example: Play a sound
ENT.OnPlayerSightDistance = 200 -- How close should the player be until it runs the code?
ENT.OnPlayerSightDispositionLevel = 1 -- 0 = Run it every time | 1 = Run it only when friendly to player | 2 = Run it only when enemy to player
ENT.OnPlayerSightOnlyOnce = true -- If true, it will only run the code once | Sets self.HasOnPlayerSight to false once it runs!
ENT.OnPlayerSightNextTime = VJ_Set(15, 20) -- How much time should it pass until it runs the code again?
	-- ====== Call For Help Variables ====== --
ENT.CallForHelp = true -- Does the SNPC call for help?
ENT.CallForHelpDistance = 2000 -- -- How far away the SNPC's call for help goes | Counted in World Units
ENT.NextCallForHelpTime = 4 -- Time until it calls for help again
ENT.HasCallForHelpAnimation = true -- if true, it will play the call for help animation
ENT.AnimTbl_CallForHelp = {ACT_SIGNAL_ADVANCE, ACT_SIGNAL_FORWARD} -- Call For Help Animations
ENT.CallForHelpAnimationDelay = 0 -- It will wait certain amount of time before playing the animation
ENT.CallForHelpAnimationPlayBackRate = 1 -- How fast should the animation play? | Currently only for gestures!
ENT.CallForHelpStopAnimations = true -- Should it stop attacks for a certain amount of time?
	-- To let the base automatically detect the animation duration, set this to false:
ENT.CallForHelpStopAnimationsTime = false -- How long should it stop attacks?
ENT.CallForHelpAnimationFaceEnemy = true -- Should it face the enemy when playing the animation?
ENT.NextCallForHelpAnimationTime = 30 -- How much time until it can play the animation again?
	-- ====== Medic Variables ====== --
ENT.IsMedicSNPC = false -- Is this SNPC a medic? Does it heal other friendly friendly SNPCs, and players(If friendly)
ENT.AnimTbl_Medic_GiveHealth = {ACT_SPECIAL_ATTACK1} -- Animations is plays when giving health to an ally
ENT.Medic_DisableAnimation = false -- if true, it will disable the animation code
ENT.Medic_TimeUntilHeal = false -- Time until the ally receives health | Set to false to let the base decide the time
ENT.Medic_CheckDistance = 600 -- How far does it check for allies that are hurt? | World units
ENT.Medic_HealDistance = 100 -- How close does it have to be until it stops moving and heals its ally?
ENT.Medic_HealthAmount = 25 -- How health does it give?
ENT.Medic_NextHealTime = VJ_Set(10, 15) -- How much time until it can give health to an ally again
ENT.Medic_SpawnPropOnHeal = true -- Should it spawn a prop, such as small health vial at a attachment when healing an ally?
ENT.Medic_SpawnPropOnHealModel = "models/healthvial.mdl" -- The model that it spawns
ENT.Medic_SpawnPropOnHealAttachment = "anim_attachment_LH" -- The attachment it spawns on
ENT.Medic_CanBeHealed = true -- If set to false, this SNPC can't be healed!
	-- ====== Follow System Variables ====== --
	-- Associated variables: self.FollowData, self.IsFollowing
ENT.FollowMinDistance = 150 -- Minimum distance the NPC should come to the player | The base automatically adds the NPC's size to this variable to account for different sizes!
ENT.NextFollowUpdateTime = 0.5 -- Time until it checks if it should move to the player again | Lower number = More performance loss
ENT.FollowPlayer = true -- Should the NPC follow the player when the player presses a certain key? | Restrictions: Player has to be friendly and the NPC's move type cannot be stationary!
	-- ====== Movement & Idle Variables ====== --
ENT.AnimTbl_IdleStand = nil -- The idle animation table when AI is enabled | DEFAULT: {ACT_IDLE}
ENT.AnimTbl_Walk = {ACT_WALK} -- Set the walking animations | Put multiple to let the base pick a random animation when it moves
ENT.AnimTbl_Run = {ACT_RUN} -- Set the running animations | Put multiple to let the base pick a random animation when it moves
ENT.IdleAlwaysWander = false -- If set to true, it will make the SNPC always wander when idling
ENT.DisableWandering = false -- Disables wandering when the SNPC is idle
ENT.DisableChasingEnemy = false -- Disables the SNPC chasing the enemy
	-- ====== Constantly Face Enemy Variables ====== --
ENT.ConstantlyFaceEnemy = false -- Should it face the enemy constantly?
ENT.ConstantlyFaceEnemy_IfVisible = true -- Should it only face the enemy if it's visible?
ENT.ConstantlyFaceEnemy_IfAttacking = false -- Should it face the enemy when attacking?
ENT.ConstantlyFaceEnemy_Postures = "Both" -- "Both" = Moving or standing | "Moving" = Only when moving | "Standing" = Only when standing
ENT.ConstantlyFaceEnemyDistance = 2500 -- How close does it have to be until it starts to face the enemy?
	-- ====== Combat Face Enemy Variables ====== --
	-- Mostly used by base tasks
ENT.CombatFaceEnemy = true -- If enemy exists and is visible
	-- ====== Pose Parameter Variables ====== --
ENT.HasPoseParameterLooking = true -- Does it look at its enemy using poseparameters?
ENT.PoseParameterLooking_CanReset = true -- Should it reset its pose parameters if there is no enemies?
ENT.PoseParameterLooking_InvertPitch = false -- Inverts the pitch poseparameters (X)
ENT.PoseParameterLooking_InvertYaw = false -- Inverts the yaw poseparameters (Y)
ENT.PoseParameterLooking_InvertRoll = false -- Inverts the roll poseparameters (Z)
ENT.PoseParameterLooking_TurningSpeed = 10 -- How fast does the parameter turn?
ENT.PoseParameterLooking_Names = {pitch={}, yaw={}, roll={}} -- Custom pose parameters to use, can put as many as needed
	-- ====== Investigation Variables ====== --
	-- Showcase: https://www.youtube.com/watch?v=cCqoqSDFyC4
ENT.CanInvestigate = true -- Can it detect and investigate possible enemy disturbances? | EX: Sounds, movement and flashlight
ENT.InvestigateSoundDistance = 9 -- How far can the NPC hear sounds? | This number is multiplied by the calculated volume of the detectable sound
	-- ====== Danger & Grenade Detection Variables ====== --
	-- Showcase: https://www.youtube.com/watch?v=XuaMWPTe6rA
	-- EXAMPLES: Props that are one fire, especially objects like barrels that are about to explode, Combine mine that is triggered and about to explode, The location that the Antlion Worker's spit is going to hit, Combine Flechette that is about to explode,
	-- Antlion Guard that is charging towards the NPC, Player that is driving a vehicle at high speed towards the NPC, Manhack that has opened its blades, Rollermine that is about to self-destruct, Combine Helicopter that is about to drop bombs or is firing a turret near the NPC,
	-- Combine Gunship's is about to fire its belly cannon near the NPC, Turret impact locations fired by Combine Gunships, or Combine Dropships, or Striders, The location that a Combine Dropship is going to deploy soldiers, Strider is moving on top of the NPC,
	-- The location that the Combine or HECU mortar is going to hit, SMG1 grenades that are flying close by, A Combine soldier that is rappelling on top of the NPC, Stalker's laser impact location, Combine APC that is driving towards the NPC
ENT.CanDetectDangers = true -- Should the NPC detect dangers? | This includes grenades!
ENT.DangerDetectionDistance = 400 -- Max danger detection distance | WARNING: Most of the non-grenade dangers ignore this max value
ENT.CanThrowBackDetectedGrenades = true -- Should it pick up the detected grenade and throw it away or to the enemy?
	-- NOTE: Can only throw grenades away if it has a grenade attack AND can detect dangers
	-- ====== Taking Cover Variables ====== --
ENT.AnimTbl_TakingCover = {ACT_COVER_LOW} -- The animation it plays when hiding in a covered position
ENT.AnimTbl_MoveToCover = {ACT_RUN_CROUCH} -- The animation it plays when moving to a covered position
	-- ====== Control Variables ====== --
	-- Use these variables very careful! One wrong change can mess up the whole SNPC!
ENT.FindEnemy_UseSphere = false -- Should the SNPC be able to see all around him? (360) | Objects and walls can still block its sight!
ENT.FindEnemy_CanSeeThroughWalls = false -- Should it be able to see through walls and objects? | Can be useful if you want to make it know where the enemy is at all times
ENT.DisableFindEnemy = false -- Disables FindEnemy code, friendly code still works though
ENT.DisableSelectSchedule = false -- Disables Schedule code, Custom Schedule can still work
ENT.DisableTakeDamageFindEnemy = false -- Disable the SNPC finding the enemy when being damaged
ENT.DisableTouchFindEnemy = false -- Disable the SNPC finding the enemy when being touched
ENT.DisableMakingSelfEnemyToNPCs = false -- Disables the "AddEntityRelationship" that runs in think
ENT.TimeUntilEnemyLost = 15 -- Time until it resets its enemy if the enemy is not visible
ENT.NextProcessTime = 1 -- Time until it runs the essential part of the AI, which can be performance heavy!
	-- ====== Miscellaneous Variables ====== --
ENT.DisableInitializeCapabilities = false -- If enabled, all of the Capabilities will be disabled, allowing you to add your own
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Damaged / Injured Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- ====== Blood-Related Variables ====== --
	-- Leave custom blood tables empty to let the base decide depending on the blood type
ENT.Bleeds = true -- Does the SNPC bleed? (Blood decal, particle, etc.)
ENT.BloodColor = "" -- The blood type, this will determine what it should use (decal, particle, etc.)
	-- Types: "Red" || "Yellow" || "Green" || "Orange" || "Blue" || "Purple" || "White" || "Oil"
ENT.HasBloodParticle = true -- Does it spawn a particle when damaged?
ENT.CustomBlood_Particle = {} -- Particles to spawn when it's damaged
ENT.HasBloodPool = true -- Does it have a blood pool?
ENT.CustomBlood_Pool = {} -- Blood pool types after it dies
ENT.BloodPoolSize = "Normal" -- What's the size of the blood pool? | Sizes: "Normal" || "Small" || "Tiny"
ENT.HasBloodDecal = true -- Does it spawn a decal when damaged?
ENT.CustomBlood_Decal = {} -- Decals to spawn when it's damaged
ENT.BloodDecalUseGMod = false -- Should use the current default decals defined by Garry's Mod? (This only applies for certain blood types only!)
ENT.BloodDecalDistance = 150 -- How far the decal can spawn in world units
	-- ====== Immunity Variables ====== --
ENT.GodMode = false -- Immune to everything
ENT.Immune_AcidPoisonRadiation = false -- Immune to Acid, Poison and Radiation
ENT.Immune_Bullet = false -- Immune to bullet type damages
ENT.Immune_Blast = false -- Immune to explosive-type damages
ENT.Immune_Dissolve = false -- Immune to dissolving | Example: Combine Ball
ENT.Immune_Electricity = false -- Immune to electrical-type damages | Example: shock or laser
ENT.Immune_Fire = false -- Immune to fire-type damages
ENT.Immune_Melee = false -- Immune to melee-type damage | Example: Crowbar, slash damages
ENT.Immune_Physics = false -- Immune to physics impacts, won't take damage from props
ENT.Immune_Sonic = false -- Immune to sonic-type damages
ENT.ImmuneDamagesTable = {} -- Makes the SNPC immune to specific type of damages | Takes DMG_ enumerations
ENT.GetDamageFromIsHugeMonster = false -- Should it get damaged no matter what by SNPCs that are tagged as VJ_IsHugeMonster?
ENT.AllowIgnition = true -- Can this SNPC be set on fire?
	-- ====== Flinching Variables ====== --
ENT.CanFlinch = 0 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.FlinchDamageTypes = {DMG_BLAST} -- If it uses damage-based flinching, which types of damages should it flinch from?
ENT.FlinchChance = 16 -- Chance of it flinching from 1 to x | 1 will make it always flinch
	-- To let the base automatically detect the animation duration, set this to false:
ENT.NextMoveAfterFlinchTime = false -- How much time until it can move, attack, etc.
ENT.NextFlinchTime = 5 -- How much time until it can flinch again?
ENT.AnimTbl_Flinch = {ACT_FLINCH_PHYSICS} -- If it uses normal based animation, use this
ENT.FlinchAnimationDecreaseLengthAmount = 0 -- This will decrease the time it can move, attack, etc. | Use it to fix animation pauses after it finished the flinch animation
ENT.HitGroupFlinching_DefaultWhenNotHit = true -- If it uses hitgroup flinching, should it do the regular flinch if it doesn't hit any of the specified hitgroups?
ENT.HitGroupFlinching_Values = nil -- EXAMPLES: {{HitGroup = {HITGROUP_HEAD}, Animation = {ACT_FLINCH_HEAD}}, {HitGroup = {HITGROUP_LEFTARM}, Animation = {ACT_FLINCH_LEFTARM}}, {HitGroup = {HITGROUP_RIGHTARM}, Animation = {ACT_FLINCH_RIGHTARM}}, {HitGroup = {HITGROUP_LEFTLEG}, Animation = {ACT_FLINCH_LEFTLEG}}, {HitGroup = {HITGROUP_RIGHTLEG}, Animation = {ACT_FLINCH_RIGHTLEG}}}
	-- ====== Damage By Player Variables ====== --
ENT.HasDamageByPlayer = true -- Should the SNPC do something when it's hit by a player? Example: Play a sound or animation
ENT.DamageByPlayerDispositionLevel = 1 -- 0 = Run it every time | 1 = Run it only when friendly to player | 2 = Run it only when enemy to player
ENT.DamageByPlayerTime = VJ_Set(2, 2) -- How much time until it can run the Damage By Player code?
	-- ====== Run Away On Unknown Damage Variables ====== --
ENT.RunAwayOnUnknownDamage = true -- Should run away on damage
ENT.NextRunAwayOnDamageTime = 5 -- Until next run after being shot when not alerted
	-- ====== Call For Back On Damage Variables ====== --
ENT.CallForBackUpOnDamage = true -- Should the SNPC call for help when damaged? (Only happens if the SNPC hasn't seen a enemy)
ENT.CallForBackUpOnDamageDistance = 800 -- How far away the SNPC's call for help goes | Counted in World Units
ENT.CallForBackUpOnDamageLimit = 4 -- How many people should it call? | 0 = Unlimited
ENT.CallForBackUpOnDamageAnimation = {ACT_SIGNAL_GROUP} -- Animation used if the SNPC does the CallForBackUpOnDamage function
	-- To let the base automatically detect the animation duration, set this to false:
ENT.CallForBackUpOnDamageAnimationTime = false -- How much time until it can use activities
ENT.NextCallForBackUpOnDamageTime = VJ_Set(9, 11) -- Next time it use the CallForBackUpOnDamage function
ENT.DisableCallForBackUpOnDamageAnimation = false -- Disables the animation when the CallForBackUpOnDamage function is called
	-- ====== Move Or Hide On Damage Variables ====== --
ENT.MoveOrHideOnDamageByEnemy = true -- Should the SNPC move or hide when being damaged by an enemy?
ENT.MoveOrHideOnDamageByEnemy_OnlyMove = false -- Should it only move and not hide?
ENT.MoveOrHideOnDamageByEnemy_HideTime = VJ_Set(3, 4) -- How long should it hide?
ENT.NextMoveOrHideOnDamageByEnemy1 = 3 -- How much time until it moves or hides on damage by enemy? | The first # in math.random
ENT.NextMoveOrHideOnDamageByEnemy2 = 3.5 -- How much time until it moves or hides on damage by enemy? | The second # in math.random
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Death & Corpse Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- ====== Ally Reaction On Death Variables ====== --
	-- Default: Creature base uses BringFriends and Human base uses AlertFriends
	-- BringFriendsOnDeath takes priority over AlertFriendsOnDeath!
ENT.BringFriendsOnDeath = false -- Should the SNPC's friends come to its position before it dies?
ENT.BringFriendsOnDeathDistance = 800 -- How far away does the signal go? | Counted in World Units
ENT.BringFriendsOnDeathLimit = 3 -- How many people should it call? | 0 = Unlimited
ENT.AlertFriendsOnDeath = true -- Should the SNPCs allies get alerted when it dies? | Its allies will also need to have this variable set to true!
ENT.AlertFriendsOnDeathDistance = 800 -- How far away does the signal go? | Counted in World Units
ENT.AlertFriendsOnDeathLimit = 50 -- How many people should it alert?
ENT.AnimTbl_AlertFriendsOnDeath = {ACT_RANGE_ATTACK1} -- Animations it plays when an ally dies that also has AlertFriendsOnDeath set to true
-- ====== Death Animation Variables ====== --
ENT.HasDeathAnimation = false -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {} -- Death Animations
	-- To let the base automatically detect the animation duration, set this to false:
ENT.DeathAnimationTime = false -- Time until the SNPC spawns its corpse and gets removed
ENT.DeathAnimationChance = 1 -- Put 1 if you want it to play the animation all the time
ENT.DeathAnimationDecreaseLengthAmount = 0 -- This will decrease the time until it turns into a corpse
	-- ====== Corpse Variables ====== --
ENT.HasDeathRagdoll = true -- If set to false, it will not spawn the regular ragdoll of the SNPC
ENT.DeathCorpseEntityClass = "UseDefaultBehavior" -- The entity class it creates | "UseDefaultBehavior" = Let the base automatically detect the type
ENT.DeathCorpseModel = {} -- The corpse model that it will spawn when it dies | Leave empty to use the NPC's model | Put as many models as desired, the base will pick a random one.
ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS -- Collision type for the corpse | SNPC Options Menu can only override this value if it's set to COLLISION_GROUP_DEBRIS!
ENT.DeathCorpseSkin = -1 -- Used to override the death skin | -1 = Use the skin that the SNPC had before it died
ENT.DeathCorpseSetBodyGroup = true -- Should it get the models bodygroups and set it to the corpse? When set to false, it uses the model's default bodygroups
ENT.DeathCorpseBodyGroup = VJ_Set(-1, -1) -- #1 = the category of the first bodygroup | #2 = the value of the second bodygroup | Set -1 for #1 to let the base decide the corpse's bodygroup
ENT.DeathCorpseSubMaterials = nil -- Apply a table of indexes that correspond to a sub material index, this will cause the base to copy the NPC's sub material to the corpse.
ENT.DeathCorpseFade = false -- Fades the ragdoll on death
ENT.DeathCorpseFadeTime = 10 -- How much time until the ragdoll fades | Unit = Seconds
ENT.DeathCorpseSetBoneAngles = true -- This can be used to stop the corpse glitching or flying on death
ENT.DeathCorpseApplyForce = true -- If false, force will not be applied to the corpse
ENT.WaitBeforeDeathTime = 0 -- Time until the SNPC spawns its corpse and gets removed
	-- ====== Dismemberment/Gib Variables ====== --
ENT.AllowedToGib = true -- Is it allowed to gib in general? This can be on death or when shot in a certain place
ENT.HasGibOnDeath = true -- Is it allowed to gib on death?
ENT.GibOnDeathDamagesTable = {"UseDefault"} -- Damages that it gibs from | "UseDefault" = Uses default damage types | "All" = Gib from any damage
ENT.HasGibOnDeathSounds = true -- Does it have gib sounds? | Mostly used for the settings menu
ENT.HasGibDeathParticles = true -- Does it spawn particles on death or when it gibs? | Mostly used for the settings menu
	-- ====== Item Drops On Death Variables ====== --
ENT.HasItemDropsOnDeath = true -- Should it drop items on death?
ENT.ItemDropsOnDeathChance = 14 -- If set to 1, it will always drop it
ENT.ItemDropsOnDeath_EntityList = {"weapon_frag", "item_healthvial"} -- List of items it will randomly pick from | Leave it empty to drop nothing or to make your own dropping code (Using CustomOn...)
ENT.DropWeaponOnDeath = true -- Should it drop its weapon on death?
ENT.DropWeaponOnDeathAttachment = "anim_attachment_RH" -- Which attachment should it use for the weapon's position
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Melee Attack Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.MeleeAttackDamage = 10
ENT.MeleeAttackDamageType = DMG_CLUB -- Type of Damage
ENT.HasMeleeAttackKnockBack = true -- Should knockback be applied on melee hit? | Use self:MeleeAttackKnockbackVelocity() to edit the velocity
	-- ====== Animation Variables ====== --
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- Melee Attack Animations
ENT.MeleeAttackAnimationDelay = 0 -- It will wait certain amount of time before playing the animation
ENT.MeleeAttackAnimationFaceEnemy = true -- Should it face the enemy while playing the melee attack animation?
ENT.MeleeAttackAnimationDecreaseLengthAmount = 0 -- This will decrease the time until starts chasing again. Use it to fix animation pauses until it chases the enemy.
ENT.MeleeAttackAnimationAllowOtherTasks = false -- If set to true, the animation will not stop other tasks from playing, such as chasing | Useful for gesture attacks!
	-- ====== Distance Variables ====== --
ENT.MeleeAttackDistance = 30 -- How close does it have to be until it attacks?
ENT.MeleeAttackAngleRadius = 100 -- What is the attack angle radius? | 100 = In front of the SNPC | 180 = All around the SNPC
ENT.MeleeAttackDamageDistance = 70 -- How far does the damage go?
ENT.MeleeAttackDamageAngleRadius = 100 -- What is the damage angle radius? | 100 = In front of the SNPC | 180 = All around the SNPC
	-- ====== Timer Variables ====== --
	-- To use event-based attacks, set this to false:
ENT.TimeUntilMeleeAttackDamage = 0.5 -- This counted in seconds | This calculates the time until it hits something
ENT.NextMeleeAttackTime = 0 -- How much time until it can use a melee attack?
ENT.NextMeleeAttackTime_DoRand = false -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer
	-- To let the base automatically detect the attack duration, set this to false:
ENT.NextAnyAttackTime_Melee = false -- How much time until it can use any attack again? | Counted in Seconds
ENT.NextAnyAttackTime_Melee_DoRand = false -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer
ENT.MeleeAttackReps = 1 -- How many times does it run the melee attack code?
ENT.MeleeAttackExtraTimers = nil -- Extra melee attack timers, EX: {1, 1.4} | it will run the damage code after the given amount of seconds
ENT.StopMeleeAttackAfterFirstHit = false -- Should it stop the melee attack from running rest of timers when it hits an enemy?
	-- ====== Control Variables ====== --
ENT.DisableMeleeAttackAnimation = false -- if true, it will disable the animation code
ENT.DisableDefaultMeleeAttackCode = false -- When set to true, it will completely disable the melee attack code
ENT.DisableDefaultMeleeAttackDamageCode = false -- Disables the default melee attack damage code
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Weapon Attack Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.WeaponSpread = 1 -- What's the spread of the weapon? | Closer to 0 = better accuracy, Farther than 1 = worse accuracy
ENT.DisableWeapons = false -- If set to true, it won't be able to use weapons
ENT.Weapon_NoSpawnMenu = false -- If set to true, the NPC weapon setting in the spawn menu will not be applied for this SNPC
	-- ====== Distance Variables ====== --
ENT.Weapon_FiringDistanceFar = 3000 -- How far away it can shoot
ENT.Weapon_FiringDistanceClose = 10 -- How close until it stops shooting
ENT.HasWeaponBackAway = true -- Should the SNPC back away if the enemy is close?
ENT.WeaponBackAway_Distance = 150 -- When the enemy is this close, the SNPC will back away | 0 = Never back away
	-- ====== Standing-Firing Variables ====== --
ENT.AnimTbl_WeaponAim = nil -- Animations played when the NPC is supposed to raise/aim its weapon | EX: Gun is out of ammo, combat idle, etc.| DEFAULT: {ACT_IDLE_ANGRY}
ENT.AnimTbl_WeaponAttack = {ACT_RANGE_ATTACK1} -- Animation played when the SNPC does weapon attack
ENT.CanCrouchOnWeaponAttack = true -- Can it crouch while shooting?
ENT.AnimTbl_WeaponAttackCrouch = {ACT_RANGE_ATTACK1_LOW} -- Animation played when the SNPC does weapon attack while crouching | For VJ Weapons
ENT.CanCrouchOnWeaponAttackChance = 2 -- How much chance of crouching? | 1 = Crouch every time
ENT.AnimTbl_WeaponAttackFiringGesture = {ACT_GESTURE_RANGE_ATTACK1} -- Firing Gesture animations used when the SNPC is firing the weapon
ENT.DisableWeaponFiringGesture = false -- If set to true, it will disable the weapon firing gestures
	-- ====== Secondary Fire Variables ====== --
ENT.CanUseSecondaryOnWeaponAttack = true -- Can the NPC use a secondary fire if it's available?
ENT.AnimTbl_WeaponAttackSecondary = {"shootAR2alt"} -- Animations played when the SNPC fires a secondary weapon attack
ENT.WeaponAttackSecondaryTimeUntilFire = 0.9 -- The weapon uses this integer to set the time until the firing code is ran
	-- ====== Moving-Firing Variables ====== --
ENT.HasShootWhileMoving = true -- Can it shoot while moving?
ENT.AnimTbl_ShootWhileMovingRun = {ACT_RUN_AIM} -- Animations it will play when shooting while running | NOTE: Weapon may translate the animation that they see fit!
ENT.AnimTbl_ShootWhileMovingWalk = {ACT_WALK_AIM} -- Animations it will play when shooting while walking | NOTE: Weapon may translate the animation that they see fit!
	-- ====== Reloading Variables ====== --
ENT.AllowWeaponReloading = true -- If false, the SNPC will no longer reload
ENT.DisableWeaponReloadAnimation = false -- if true, it will disable the animation code when reloading
ENT.AnimTbl_WeaponReload = {ACT_RELOAD} -- Animations that play when the SNPC reloads
ENT.AnimTbl_WeaponReloadBehindCover = {ACT_RELOAD_LOW} -- Animations that it plays when the SNPC reloads, but behind cover
ENT.WeaponReloadAnimationFaceEnemy = true -- Should it face the enemy while playing the weapon reload animation?
ENT.WeaponReloadAnimationDecreaseLengthAmount = 0 -- This will decrease the time until it starts moving or attack again. Use it to fix animation pauses until it chases the enemy.
ENT.WeaponReloadAnimationDelay = 0 -- It will wait certain amount of time before playing the animation
	-- ====== Weapon Inventory Variables ====== --
	-- Weapons are given on spawn and the NPC will only switch to those if the requirements are met
	-- The items that are stored in self.WeaponInventory:
		-- Primary - Default weapon
		-- AntiArmor - Current enemy is an armored enemy tank/vehicle or a boss
		-- Melee - Current enemy is (very close and the NPC is out of ammo) OR (in regular melee attack distance) + NPC must have more than 25% health
ENT.WeaponInventory_AntiArmor = false -- If true, the NPC will spawn with one of the given weapons (Will only be given the weapon if it already has another!)
ENT.WeaponInventory_AntiArmorList = {} -- It will randomly be given one of these weapons
ENT.WeaponInventory_Melee = false -- If true, the NPC will spawn with one of the given weapons (Will only be given the weapon if it already has another!)
ENT.WeaponInventory_MeleeList = {} -- It will randomly be given one of these weapons
	-- ====== Move Randomly While Firing Variables ====== --
ENT.MoveRandomlyWhenShooting = true -- Should it move randomly when shooting?
ENT.NextMoveRandomlyWhenShootingTime1 = 3 -- How much time until it can move randomly when shooting? | First number in math.random
ENT.NextMoveRandomlyWhenShootingTime2 = 6 -- How much time until it can move randomly when shooting? | Second number in math.random
	-- ====== Wait For Enemy To Come Out Variables ====== --
ENT.WaitForEnemyToComeOut = true -- Should it wait for the enemy to come out from hiding?
ENT.WaitForEnemyToComeOutTime = VJ_Set(3, 5) -- How much time should it wait until it starts chasing the enemy?
ENT.WaitForEnemyToComeOutDistance = 100 -- If it's this close to the enemy, it won't do it
ENT.HasLostWeaponSightAnimation = false -- Set to true if you would like the SNPC to play a different animation when it has lost sight of the enemy and can't fire at it
	-- ====== Scared Behavior Variables ====== --
ENT.NoWeapon_UseScaredBehavior = true -- Should it use the scared behavior when it sees an enemy and doesn't have a weapon?
ENT.AnimTbl_ScaredBehaviorStand = nil -- Animations it will play while scared and standing | Replaces the idle stand animation | DEFAULT: {ACT_COWER}
ENT.AnimTbl_ScaredBehaviorMovement = {} -- Animations it will play while scared and moving | Leave empty for the base to decide the animation
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Grenade Attack Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasGrenadeAttack = false -- Should the SNPC have a grenade attack?
ENT.GrenadeAttackEntity = "obj_vj_grenade" -- The entity that the SNPC throws | Half Life 2 Grenade: "npc_grenade_frag"
ENT.GrenadeAttackModel = {} -- Picks a random model from this table to override the model of the grenade
ENT.GrenadeAttackAttachment = "anim_attachment_LH" -- The attachment that the grenade will spawn at | false = Custom position
	-- ====== Animation Variables ====== --
ENT.AnimTbl_GrenadeAttack = {"grenThrow"} -- Grenade Attack Animations
ENT.GrenadeAttackAnimationDelay = 0 -- It will wait certain amount of time before playing the animation
ENT.GrenadeAttackAnimationFaceEnemy = true -- Should it face the enemy while playing the grenade attack animation?
	-- ====== Distance & Chance Variables ====== --
ENT.NextThrowGrenadeTime = VJ_Set(10, 15) -- Time until it can throw a grenade again
ENT.ThrowGrenadeChance = 4 -- Chance that it will throw the grenade | Set to 1 to throw all the time
ENT.GrenadeAttackThrowDistance = 1500 -- How far it can throw grenades
ENT.GrenadeAttackThrowDistanceClose = 400 -- How close until it stops throwing grenades
	-- ====== Timer Variables ====== --
ENT.TimeUntilGrenadeIsReleased = 0.72 -- Time until the grenade is released
ENT.GrenadeAttackAnimationStopAttacks = true -- Should it stop attacks for a certain amount of time?
	-- To let the base automatically detect the attack duration, set this to false:
ENT.GrenadeAttackAnimationStopAttacksTime = false -- How long should it stop attacks?
ENT.GrenadeAttackFussTime = 3 -- Time until the grenade explodes
	-- ====== Control Variables ====== --
ENT.DisableGrenadeAttackAnimation = false -- if true, it will disable the animation code when doing grenade attack
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Sound Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasSounds = true -- Put to false to disable ALL sounds!
	-- ====== Footstep Sound / World Shake On Move Variables ====== --
ENT.DisableFootStepSoundTimer = false -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
ENT.FootStepTimeRun = 0.5 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 1 -- Next foot step sound when it is walking
ENT.DisableFootStepOnRun = false -- It will not play the footstep sound when running
ENT.DisableFootStepOnWalk = false -- It will not play the footstep sound when walking
ENT.HasWorldShakeOnMove = false -- Should the world shake when it's moving?
ENT.WorldShakeOnMoveAmplitude = 10 -- How much the screen will shake | From 1 to 16, 1 = really low 16 = really high
ENT.WorldShakeOnMoveRadius = 1000 -- How far the screen shake goes, in world units
ENT.WorldShakeOnMoveDuration = 0.4 -- How long the screen shake will last, in seconds
ENT.WorldShakeOnMoveFrequency = 100 -- Just leave it to 100
	-- ====== Idle Sound Variables ====== --
ENT.IdleSounds_PlayOnAttacks = false -- It will be able to continue and play idle sounds when it performs an attack
ENT.IdleSounds_NoRegularIdleOnAlerted = false -- if set to true, it will not play the regular idle sound table if the combat idle sound table is empty
	-- ====== Idle dialogue Sound Variables ====== --
	-- When an allied SNPC or a allied player is in range, the SNPC will play a different sound table. If the ally is a VJ SNPC and has dialogue answer sounds, it will respond to this SNPC
ENT.HasIdleDialogueSounds = true -- If set to false, it won't play the idle dialogue sounds
ENT.HasIdleDialogueAnswerSounds = true -- If set to false, it won't play the idle dialogue answer sounds
ENT.IdleDialogueDistance = 400 -- How close should the ally be for the SNPC to talk to the ally?
ENT.IdleDialogueCanTurn = true -- If set to false, it won't turn when a dialogue occurs
	-- ====== Miscellaneous Variables ====== --
ENT.AlertSounds_OnlyOnce = false -- After it plays it once, it will never play it again
ENT.BeforeMeleeAttackSounds_WaitTime = 0 -- Time until it starts playing the Before Melee Attack sounds
ENT.OnlyDoKillEnemyWhenClear = true -- If set to true, it will only play the OnKilledEnemy sound when there isn't any other enemies
	-- ====== Main Control Variables ====== --
ENT.HasFootStepSound = true -- Should the SNPC make a footstep sound when it's moving?
ENT.HasBreathSound = true -- Should it make a breathing sound?
ENT.HasIdleSounds = true -- If set to false, it won't play the idle sounds
ENT.HasOnReceiveOrderSounds = true -- If set to false, it won't play any sound when it receives an order from an ally
ENT.HasFollowPlayerSounds_Follow = true -- If set to false, it won't play the follow player sounds
ENT.HasFollowPlayerSounds_UnFollow = true -- If set to false, it won't play the unfollow player sounds
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
ENT.HasSoundTrack = false -- Does the SNPC have a sound track?
	-- ====== File Path Variables ====== --
	-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {}
ENT.SoundTbl_Breath = {}
ENT.SoundTbl_Idle = {}
ENT.SoundTbl_IdleDialogue = {}
ENT.SoundTbl_IdleDialogueAnswer = {}
ENT.SoundTbl_CombatIdle = {}
ENT.SoundTbl_OnReceiveOrder = {}
ENT.SoundTbl_FollowPlayer = {}
ENT.SoundTbl_UnFollowPlayer = {}
ENT.SoundTbl_MoveOutOfPlayersWay = {}
ENT.SoundTbl_MedicBeforeHeal = {}
ENT.SoundTbl_MedicAfterHeal = {}
ENT.SoundTbl_MedicReceiveHeal = {}
ENT.SoundTbl_OnPlayerSight = {}
ENT.SoundTbl_Investigate = {}
ENT.SoundTbl_LostEnemy = {}
ENT.SoundTbl_Alert = {}
ENT.SoundTbl_CallForHelp = {}
ENT.SoundTbl_BecomeEnemyToPlayer = {}
ENT.SoundTbl_Suppressing = {}
ENT.SoundTbl_WeaponReload = {}
ENT.SoundTbl_BeforeMeleeAttack = {}
ENT.SoundTbl_MeleeAttack = {}
ENT.SoundTbl_MeleeAttackExtra = {}
ENT.SoundTbl_MeleeAttackMiss = {}
ENT.SoundTbl_GrenadeAttack = {}
ENT.SoundTbl_OnGrenadeSight = {}
ENT.SoundTbl_OnDangerSight = {}
ENT.SoundTbl_OnKilledEnemy = {}
ENT.SoundTbl_AllyDeath = {}
ENT.SoundTbl_Pain = {}
ENT.SoundTbl_Impact = {}
ENT.SoundTbl_DamageByPlayer = {}
ENT.SoundTbl_Death = {}
ENT.SoundTbl_SoundTrack = {}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ ///// WARNING: Don't change anything in this box! \\\\\ ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- These are the default file paths in case the user doesn't put one (tables above).
local DefaultSoundTbl_FootStep = {"npc/metropolice/gear1.wav","npc/metropolice/gear2.wav","npc/metropolice/gear3.wav","npc/metropolice/gear4.wav","npc/metropolice/gear5.wav","npc/metropolice/gear6.wav"}
local DefaultSoundTbl_MedicAfterHeal = {"items/smallmedkit1.wav"}
ENT.DefaultSoundTbl_MeleeAttack = {"physics/body/body_medium_impact_hard1.wav","physics/body/body_medium_impact_hard2.wav","physics/body/body_medium_impact_hard3.wav","physics/body/body_medium_impact_hard4.wav","physics/body/body_medium_impact_hard5.wav","physics/body/body_medium_impact_hard6.wav"}
local DefaultSoundTbl_MeleeAttackMiss = {"npc/zombie/claw_miss1.wav","npc/zombie/claw_miss2.wav"}
local DefaultSoundTbl_Impact = {"physics/flesh/flesh_impact_bullet1.wav","physics/flesh/flesh_impact_bullet2.wav","physics/flesh/flesh_impact_bullet3.wav","physics/flesh/flesh_impact_bullet4.wav","physics/flesh/flesh_impact_bullet5.wav"}
------ ///// WARNING: Don't change anything in this box! \\\\\ ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- ====== Fade Out Time Variables ====== --
	-- Put to 0 if you want it to stop instantly
ENT.SoundTrackFadeOutTime = 2
	-- ====== Sound Chance Variables ====== --
	-- Higher number = less chance of playing | 1 = Always play
ENT.IdleSoundChance = 3
ENT.IdleDialogueAnswerSoundChance = 1
ENT.CombatIdleSoundChance = 1
ENT.OnReceiveOrderSoundChance = 1
ENT.FollowPlayerSoundChance = 1
ENT.UnFollowPlayerSoundChance = 1
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
	-- ====== Timer Variables ====== --
	-- Randomized time between the two variables, x amount of time has to pass for the sound to play again | Counted in seconds
ENT.NextSoundTime_Breath = true -- true = Base will decide the time | VJ_Set(1, 2) = Custom time
ENT.NextSoundTime_Idle = VJ_Set(8, 25)
ENT.NextSoundTime_Investigate = VJ_Set(5, 5)
ENT.NextSoundTime_LostEnemy = VJ_Set(5, 6)
ENT.NextSoundTime_Alert = VJ_Set(2, 3)
ENT.NextSoundTime_OnGrenadeSight = VJ_Set(3, 3)
ENT.NextSoundTime_OnDangerSight = VJ_Set(3, 3)
ENT.NextSoundTime_Suppressing = VJ_Set(7, 15)
ENT.NextSoundTime_WeaponReload = VJ_Set(3, 5)
ENT.NextSoundTime_OnKilledEnemy = VJ_Set(3, 5)
ENT.NextSoundTime_AllyDeath = VJ_Set(3, 5)
ENT.NextSoundTime_Pain = true -- true = Base will decide the time | VJ_Set(1, 2) = Custom time
ENT.NextSoundTime_DamageByPlayer = VJ_Set(2, 2.3)
	-- ====== Volume Variables ====== --
	-- Number must be between 0 and 1
	-- 0 = No sound, 1 = normal/loudest
ENT.SoundTrackVolume = 1
	-- ====== Sound Level Variables ====== --
	-- The proper number are usually range from 0 to 180, though it can go as high as 511
	-- More Information: https://developer.valvesoftware.com/wiki/Soundscripts#SoundLevel_Flags
ENT.FootStepSoundLevel = 70
ENT.BreathSoundLevel = 60
ENT.IdleSoundLevel = 75
ENT.IdleDialogueSoundLevel = 75
ENT.IdleDialogueAnswerSoundLevel = 75
ENT.CombatIdleSoundLevel = 80
ENT.OnReceiveOrderSoundLevel = 80
ENT.FollowPlayerSoundLevel = 75
ENT.UnFollowPlayerSoundLevel = 75
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
//ENT.SoundTrackLevel = 0.9
	-- ====== Sound Pitch Variables ====== --
	-- Range: 0 - 255 | Lower pitch < x > Higher pitch
ENT.UseTheSameGeneralSoundPitch = true -- If set to true, the base will decide a number when the NPC spawns and uses it for all sound pitches set to false
	-- It picks the number between these two variables below:
		-- These two variables control any sound pitch variable that is set to false
ENT.GeneralSoundPitch1 = 90
ENT.GeneralSoundPitch2 = 100
	-- To not use the variables above, set the pitch to something other than false
ENT.FootStepPitch = VJ_Set(80, 100)
ENT.BreathSoundPitch = VJ_Set(100, 100)
ENT.IdleSoundPitch = VJ_Set(false, false)
ENT.IdleDialogueSoundPitch = VJ_Set(false, false)
ENT.IdleDialogueAnswerSoundPitch = VJ_Set(false, false)
ENT.CombatIdleSoundPitch = VJ_Set(false, false)
ENT.OnReceiveOrderSoundPitch = VJ_Set(false, false)
ENT.FollowPlayerPitch = VJ_Set(false, false)
ENT.UnFollowPlayerPitch = VJ_Set(false, false)
ENT.MoveOutOfPlayersWaySoundPitch = VJ_Set(false, false)
ENT.BeforeHealSoundPitch = VJ_Set(false, false)
ENT.AfterHealSoundPitch = VJ_Set(100, 100)
ENT.MedicReceiveHealSoundPitch = VJ_Set(false, false)
ENT.OnPlayerSightSoundPitch = VJ_Set(false, false)
ENT.InvestigateSoundPitch = VJ_Set(false, false)
ENT.LostEnemySoundPitch = VJ_Set(false, false)
ENT.AlertSoundPitch = VJ_Set(false, false)
ENT.CallForHelpSoundPitch = VJ_Set(false, false)
ENT.BecomeEnemyToPlayerPitch = VJ_Set(false, false)
ENT.BeforeMeleeAttackSoundPitch = VJ_Set(false, false)
ENT.MeleeAttackSoundPitch = VJ_Set(95, 100)
ENT.ExtraMeleeSoundPitch = VJ_Set(80, 100)
ENT.MeleeAttackMissSoundPitch = VJ_Set(90, 100)
ENT.SuppressingPitch = VJ_Set(false, false)
ENT.WeaponReloadSoundPitch = VJ_Set(false, false)
ENT.GrenadeAttackSoundPitch = VJ_Set(false, false)
ENT.OnGrenadeSightSoundPitch = VJ_Set(false, false)
ENT.OnDangerSightSoundPitch = VJ_Set(false, false)
ENT.OnKilledEnemySoundPitch = VJ_Set(false, false)
ENT.AllyDeathSoundPitch = VJ_Set(false, false)
ENT.PainSoundPitch = VJ_Set(false, false)
ENT.ImpactSoundPitch = VJ_Set(80, 100)
ENT.DamageByPlayerPitch = VJ_Set(false, false)
ENT.DeathSoundPitch = VJ_Set(false, false)
	-- ====== Playback Rate Variables ====== --
	-- Decides how fast the sound should play
	-- Examples: 1 = normal, 2 = twice the normal speed, 0.5 = half the normal speed
ENT.SoundTrackPlaybackRate = 1
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Customization Functions ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Use the functions below to customize certain parts of the base or to add new custom systems
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPreInitialize() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	-- self:SetCollisionBounds(Vector(50, 50, 100), Vector(-50, -50, 0)) -- Collision bounds of the NPC | WARNING: All 4 Xs and Ys should be the same!
	-- self:SetSurroundingBounds(Vector(-300, -300, 0), Vector(300, 300, 500)) -- Damage bounds of the NPC, doesn't effect collision or OBB | NOTE: Only set this if the base one is not good enough! | Use "cl_ent_absbox" to view the bounds
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnEntityRelationshipCheck(ent, entFri, entDist) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnChangeMovementType(movType) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnIsJumpLegal(startPos, apex, endPos) end -- Return nothing to let base decide, return true to make it jump, return false to disallow jumping
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOn_PoseParameterLookingCode(pitch, yaw, roll) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnSetupWeaponHoldTypeAnims(hType) return false end -- return true to disable the base code
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnSchedule() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnChangeActivity(newAct) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ExpressionFinished(strExp) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPlayCreateSound(sdData, sdFile) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPlayEmitSound(sdFile) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnFireBullet(ent, data) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTouch(ent) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnCondition(cond) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key, activator, caller, data) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnHandleAnimEvent(ev, evTime, evCycle, evType, evOptions) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnFollowPlayer(ply) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnIdleDialogue(ent, canAnswer) return true end -- ent = An entity that it can talk to | canAnswer = If the entity can answer back | Return false to not run the code!
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnIdleDialogueAnswer(ent) end -- ent = The entity that just talked to this NPC
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMedic_BeforeHeal() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMedic_OnHeal(ent) return true end -- Return false to NOT update its ally's health and NOT clear its decals, allowing to custom code it
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMedic_OnReset() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPlayerSight(ent) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnFootStepSound() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnFootStepSound_Run() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnFootStepSound_Walk() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnWorldShakeOnMove() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDoChangeWeapon(newWeapon, oldWeapon, invSwitch) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInvestigate(ent) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnResetEnemy() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(ent) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnCallForHelp(ally) end
---------------------------------------------------------------------------------------------------------------------------------------------
-- The NPC's sight direction | Used by main sight angle, all attack angle radiuses, etc.
function ENT:GetSightDirection()
	//return self:GetAttachment(self:LookupAttachment("mouth")).Ang:Forward() -- Attachment example
	//return select(2, self:GetBonePosition(self:LookupBone("bip01 head"))):Forward() -- Bone example
	return self:GetForward() -- Make sure to return a direction!
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetDynamicOrigin()
	return self:GetPos() + self:GetForward() -- Override this to use a different position
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomAttack(ene, eneVisible) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_BeforeStartTimer(seed) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_AfterStartTimer(seed) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_BeforeChecks() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetMeleeAttackDamageOrigin()
	return self:GetPos() + self:GetForward() -- Override this to use a different position
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_AfterChecks(hitEnt, isProp) return false end -- return true to disable the attack and move onto the next entity!
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MeleeAttackKnockbackVelocity(hitEnt)
	return self:GetForward()*math.random(100, 140) + self:GetUp()*10
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_Miss() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnIsAbleToShootWeapon()
	return true -- Set this to false to disallow shooting
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnWeaponAttack() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMoveRandomlyWhenShooting() end -- Returning false will disable the base code
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnWaitForEnemyToComeOut() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnWeaponReload() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnWeaponReload_AfterRanToCover() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnGrenadeAttack_BeforeStartTimer() end 
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnGrenadeAttack_SpawnPosition() return self:GetPos() end -- if self.GrenadeAttackAttachment is set to false, it will use the returned position here!
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnGrenadeAttack_ThrowVelocity(grEnt, grTargetPos) return (grTargetPos - grEnt:GetPos()) + (self:GetUp()*200 + self:GetForward()*500 + self:GetRight()*math.Rand(-20, 20)) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnGrenadeAttack_OnThrow(grEnt) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDoKilledEnemy(ent, attacker, inflictor) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeImmuneChecks(dmginfo, hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo, hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_AfterDamage(dmginfo, hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo, hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnFlinch_BeforeFlinch(dmginfo, hitgroup) end -- Return false to disallow the flinch from playing
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnFlinch_AfterFlinch(dmginfo, hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDamageByPlayer(dmginfo, hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomWhenBecomingEnemyTowardsPlayer(dmginfo, hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnSetEnemyOnDamage(dmginfo, hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetUpGibesOnDeath(dmginfo, hitgroup)
	return false -- Return to true if it gibbed!
	/*--------------------------------------
		-- Extra Features --
			Extra features allow you to have more control over the gibbing system.
			--/// Types \\\--
				AllowCorpse -- Should it allow corpse to spawn?
				DeathAnim -- Should it allow death animation?
			--/// Implementing it \\\--
				1. Let's use type DeathAnim as an example. NOTE: You can have as many types as you want!
				2. Put a comma next to return. 		===> return true,
				3. Make a table after the comma. 	===> return true, {}
				4. Put the type(s) that you want.	===> return true, {DeathAnim=true}
				5. And you are done!
				Example with multiple types:		===> return true, {DeathAnim=true,AllowCorpse=true}
	--------------------------------------*/
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomGibOnDeathSounds(dmginfo, hitgroup) return true end -- returning false will make the default gibbing sounds not play
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAllyDeath(ent) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialKilled(dmginfo, hitgroup) end -- Ran the moment the NPC dies!
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPriorToKilled(dmginfo, hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomDeathAnimationCode(dmginfo, hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo, hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRareDropsOnDeathCode(dmginfo, hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDropWeapon(dmginfo, hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDropWeapon_AfterWeaponSpawned(dmginfo, hitgroup, wepEnt) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_BeforeCorpseSpawned(dmginfo, hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_IntMsg(ply, controlEnt)
	//ply:ChatPrint("CTRL + MOUSE2: Rocket Attack") -- Example
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ ///// WARNING: Don't touch anything below this line! \\\\\ ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.Alerted = false
ENT.Dead = false
ENT.Flinching = false
ENT.vACT_StopAttacks = false
ENT.IsFollowing = false
ENT.FollowingPlayer = false
ENT.EnemyReset = true
ENT.VJ_IsBeingControlled = false
ENT.VJ_PlayingSequence = false
ENT.PlayingAttackAnimation = false
ENT.DoingWeaponAttack = false
ENT.DoingWeaponAttack_Standing = false
ENT.WaitingForEnemyToComeOut = false
ENT.VJDEBUG_SNPC_ENABLED = false
ENT.DidWeaponAttackAimParameter = false
ENT.Medic_IsHealingAlly = false
ENT.AlreadyDoneMedicThinkCode = false
ENT.VJFriendly = false
ENT.VJ_PlayingInterruptSequence = false
ENT.IsAbleToMeleeAttack = true
ENT.AllowToDo_WaitForEnemyToComeOut = true
ENT.HasBeenGibbedOnDeath = false
ENT.DeathAnimationCodeRan = false
ENT.VJ_IsBeingControlled_Tool = false
ENT.WeaponUseEnemyEyePos = false
ENT.LastHiddenZone_CanWander = true
ENT.NoWeapon_UseScaredBehavior_Active = false
ENT.CurIdleStandMove = false
ENT.CurrentWeaponAnimationIsAim = false
ENT.LastEnemyVisible = false
ENT.VJ_TheController = NULL
ENT.VJ_TheControllerEntity = NULL
ENT.VJ_TheControllerBullseye = NULL
ENT.Medic_CurrentEntToHeal = NULL
ENT.Medic_SpawnedProp = NULL
ENT.CurrentWeaponEntity = NULL
ENT.LastPlayedVJSound = nil
ENT.NextDangerDetectionT = 0
ENT.NextFollowUpdateT = 0
ENT.AngerLevelTowardsPlayer = 0
ENT.NextBreathSoundT = 0
ENT.FootStepT = 0
ENT.PainSoundT = 0
ENT.AllyDeathSoundT = 0
ENT.WorldShakeWalkT = 0
ENT.NextSetEnemyOnDamageT = 0
ENT.NextRunAwayOnDamageT = 0
ENT.NextIdleSoundT = 0
ENT.NextNoWeaponT = 0
ENT.NextCallForHelpT = 0
ENT.NextProcessT = 0
ENT.NextThrowGrenadeT = 0
ENT.NextCallForBackUpOnDamageT = 0
ENT.NextOnGrenadeSightSoundT = 0
ENT.NextOnDangerSightSoundT = 0
ENT.NextMoveOrHideOnDamageByEnemyT = 0
ENT.NextAlertSoundT = 0
ENT.LastEnemyVisibleTime = 0
ENT.LastEnemyTime = 0
ENT.TimeSinceEnemyAcquired = 0
ENT.NextCallForHelpAnimationT = 0
ENT.CurrentAttackAnimation = 0
ENT.CurrentAttackAnimationDuration = 0
ENT.NextIdleTime = 0
ENT.NextChaseTime = 0
ENT.OnPlayerSightNextT = 0
ENT.NextDamageByPlayerT = 0
ENT.NextDamageByPlayerSoundT = 0
ENT.NextWeaponReloadSoundT = 0
ENT.Medic_NextHealT = 0
ENT.Weapon_TimeSinceLastShot = 0
ENT.NextMoveRandomlyWhenShootingT = 0
ENT.NextWeaponAttackT = 0
ENT.NextMeleeWeaponAttackT = 0
ENT.CurrentWeaponAnimation = -1
ENT.NextGrenadeAttackSoundT = 0
ENT.CurrentAnim_IdleStand = 0
ENT.NextSuppressingSoundT = 0
ENT.TakingCoverT = 0
ENT.NextFlinchT = 0
ENT.NextCanGetCombineBallDamageT = 0
ENT.UseTheSameGeneralSoundPitch_PickedNumber = 0
ENT.OnKilledEnemySoundT = 0
ENT.LastHiddenZoneT = 0
ENT.NextIdleStandTime = 0
ENT.NextMoveOnGunCoveredT = 0
ENT.NextWanderTime = 0
ENT.Weapon_DoingCrouchAttackT = 0
ENT.NextInvestigationMove = 0
ENT.NextInvestigateSoundT = 0
ENT.NextCallForHelpSoundT = 0
ENT.LostEnemySoundT = 0
ENT.NextDoAnyAttackT = 0
ENT.NearestPointToEnemyDistance = 0
ENT.LastEnemySightDiff = 0
ENT.ReachableEnemyCount = 0
ENT.LatestEnemyDistance = 0
ENT.HealthRegenerationDelayT = 0
ENT.NextWeaponAttackT_Base = 0 -- This is handled by the base, used to avoid running shoot animation twice
ENT.CurAttackSeed = 0
ENT.CurAnimationSeed = 0
ENT.LastEnemyVisiblePos = Vector(0, 0, 0)
ENT.GuardingPosition = nil
ENT.GuardingFacePosition = nil
ENT.SelectedDifficulty = 1
ENT.ModelAnimationSet = VJ_MODEL_ANIMSET_NONE
ENT.AIState = VJ_STATE_NONE
ENT.AttackType = VJ_ATTACK_NONE
ENT.AttackStatus = VJ_ATTACK_STATUS_NONE
ENT.WeaponState = VJ_WEP_STATE_READY
ENT.WeaponInventoryStatus = VJ_WEP_INVENTORY_NONE
ENT.FacingStatus = VJ_FACING_NONE
ENT.FacingData = nil
ENT.TimersToRemove = {"timer_weapon_state_reset","timer_state_reset","timer_act_seqreset","timer_facing_end","timer_act_flinching","timer_act_playingattack","timer_act_stopattacks","timer_melee_finished","timer_melee_start","timer_melee_finished_abletomelee","timer_reload_end","timer_alerted_reset"}
ENT.FollowData = {Ent = NULL, MinDist = 0, Moving = false, StopAct = false}
//ENT.DefaultGibOnDeathDamageTypes = {[DMG_ALWAYSGIB]=true,[DMG_ENERGYBEAM]=true,[DMG_BLAST]=true,[DMG_VEHICLE]=true,[DMG_CRUSH]=true,[DMG_DISSOLVE]=true,[DMG_SLOWBURN]=true,[DMG_PHYSGUN]=true,[DMG_PLASMA]=true,[DMG_SONIC]=true}
//ENT.SavedDmgInfo = {} -- Set later

-- Localized static values
local destructibleEnts = {func_breakable=true, func_physbox=true, prop_door_rotating=true} // func_breakable_surf

local defPos = Vector(0, 0, 0)
local defAng = Angle(0, 0, 0)

local IsProp = VJ_IsProp
local CurTime = CurTime
local IsValid = IsValid
local GetConVar = GetConVar
local isstring = isstring
local isnumber = isnumber
local tonumber = tonumber
local math_clamp = math.Clamp
local math_rad = math.rad
local math_cos = math.cos
local math_angApproach = math.ApproachAngle
local math_angDif = math.AngleDifference
local varCAnt = "CLASS_ANTLION"
local varCCom = "CLASS_COMBINE"
local varCZom = "CLASS_ZOMBIE"

---------------------------------------------------------------------------------------------------------------------------------------------
local function ConvarsOnInit(self)
	--<>-- Convars that run on Initialize --<>--
	if GetConVar("vj_npc_usedevcommands"):GetInt() == 1 then self.VJDEBUG_SNPC_ENABLED = true end
	self.NextProcessTime = GetConVar("vj_npc_processtime"):GetInt()
	if GetConVar("vj_npc_sd_nosounds"):GetInt() == 1 then self.HasSounds = false end
	if GetConVar("vj_npc_vjfriendly"):GetInt() == 1 then self.VJFriendly = true end
	if GetConVar("vj_npc_playerfriendly"):GetInt() == 1 then self.PlayerFriendly = true end
	if GetConVar("vj_npc_antlionfriendly"):GetInt() == 1 then self.VJ_NPC_Class[#self.VJ_NPC_Class + 1] = varCAnt end
	if GetConVar("vj_npc_combinefriendly"):GetInt() == 1 then self.VJ_NPC_Class[#self.VJ_NPC_Class + 1] = varCCom end
	if GetConVar("vj_npc_zombiefriendly"):GetInt() == 1 then self.VJ_NPC_Class[#self.VJ_NPC_Class + 1] = varCZom end
	if GetConVar("vj_npc_noallies"):GetInt() == 1 then self.HasAllies = false self.PlayerFriendly = false end
	if GetConVar("vj_npc_nocorpses"):GetInt() == 1 then self.HasDeathRagdoll = false end
	if GetConVar("vj_npc_itemdrops"):GetInt() == 0 then self.HasItemDropsOnDeath = false end
	if GetConVar("vj_npc_nowandering"):GetInt() == 1 then self.DisableWandering = true end
	if GetConVar("vj_npc_nochasingenemy"):GetInt() == 1 then self.DisableChasingEnemy = true end
	if GetConVar("vj_npc_noflinching"):GetInt() == 1 then self.CanFlinch = false end
	if GetConVar("vj_npc_nomelee"):GetInt() == 1 then self.HasMeleeAttack = false end
	if GetConVar("vj_npc_nobleed"):GetInt() == 1 then self.Bleeds = false end
	if GetConVar("vj_npc_godmodesnpc"):GetInt() == 1 then self.GodMode = true end
	if GetConVar("vj_npc_noreload"):GetInt() == 1 then self.AllowWeaponReloading = false end
	if GetConVar("vj_npc_nobecomeenemytoply"):GetInt() == 1 then self.BecomeEnemyToPlayer = false end
	if GetConVar("vj_npc_nocallhelp"):GetInt() == 1 then self.CallForHelp = false end
	if GetConVar("vj_npc_nofollowplayer"):GetInt() == 1 then self.FollowPlayer = false end
	if GetConVar("vj_npc_nosnpcchat"):GetInt() == 1 then self.AllowPrintingInChat = false end
	if GetConVar("vj_npc_noweapon"):GetInt() == 1 then self.DisableWeapons = true end
	if GetConVar("vj_npc_nothrowgrenade"):GetInt() == 1 then self.HasGrenadeAttack = false end
	if GetConVar("vj_npc_nodangerdetection"):GetInt() == 1 then self.CanDetectDangers = false end
	if GetConVar("vj_npc_dropweapon"):GetInt() == 0 then self.DropWeaponOnDeath = false end
	if GetConVar("vj_npc_nomedics"):GetInt() == 1 then self.IsMedicSNPC = false end
	if GetConVar("vj_npc_nogibdeathparticles"):GetInt() == 1 then self.HasGibDeathParticles = false end
	if GetConVar("vj_npc_nogib"):GetInt() == 1 then self.AllowedToGib = false self.HasGibOnDeath = false end
	if GetConVar("vj_npc_usegmoddecals"):GetInt() == 1 then self.BloodDecalUseGMod = true end
	if GetConVar("vj_npc_knowenemylocation"):GetInt() == 1 then self.FindEnemy_UseSphere = true self.FindEnemy_CanSeeThroughWalls = true end
	if GetConVar("vj_npc_sd_gibbing"):GetInt() == 1 then self.HasGibOnDeathSounds = false end
	if GetConVar("vj_npc_sd_soundtrack"):GetInt() == 1 then self.HasSoundTrack = false end
	if GetConVar("vj_npc_sd_footstep"):GetInt() == 1 then self.HasFootStepSound = false end
	if GetConVar("vj_npc_sd_idle"):GetInt() == 1 then self.HasIdleSounds = false end
	if GetConVar("vj_npc_sd_breath"):GetInt() == 1 then self.HasBreathSound = false end
	if GetConVar("vj_npc_sd_alert"):GetInt() == 1 then self.HasAlertSounds = false end
	if GetConVar("vj_npc_sd_ondangersight"):GetInt() == 1 then self.HasOnGrenadeSightSounds = false self.HasOnDangerSightSounds = false end
	if GetConVar("vj_npc_sd_meleeattack"):GetInt() == 1 then self.HasMeleeAttackSounds = false self.HasExtraMeleeAttackSounds = false end
	if GetConVar("vj_npc_sd_meleeattackmiss"):GetInt() == 1 then self.HasMeleeAttackMissSounds = false end
	if GetConVar("vj_npc_sd_pain"):GetInt() == 1 then self.HasPainSounds = false end
	if GetConVar("vj_npc_sd_death"):GetInt() == 1 then self.HasDeathSounds = false end
	if GetConVar("vj_npc_sd_followplayer"):GetInt() == 1 then self.HasFollowPlayerSounds_Follow = false self.HasFollowPlayerSounds_UnFollow = false end
	if GetConVar("vj_npc_sd_becomenemytoply"):GetInt() == 1 then self.HasBecomeEnemyToPlayerSounds = false end
	if GetConVar("vj_npc_sd_damagebyplayer"):GetInt() == 1 then self.HasDamageByPlayerSounds = false end
	if GetConVar("vj_npc_sd_onplayersight"):GetInt() == 1 then self.HasOnPlayerSightSounds = false end
	if GetConVar("vj_npc_sd_medic"):GetInt() == 1 then self.HasMedicSounds_BeforeHeal = false self.HasMedicSounds_AfterHeal = false self.HasMedicSounds_ReceiveHeal = false end
	if GetConVar("vj_npc_sd_reload"):GetInt() == 1 then self.HasWeaponReloadSounds = false end
	if GetConVar("vj_npc_sd_grenadeattack"):GetInt() == 1 then self.HasGrenadeAttackSounds = false end
	if GetConVar("vj_npc_sd_suppressing"):GetInt() == 1 then self.HasSuppressingSounds = false end
	if GetConVar("vj_npc_sd_callforhelp"):GetInt() == 1 then self.HasCallForHelpSounds = false end
	if GetConVar("vj_npc_sd_onreceiveorder"):GetInt() == 1 then self.HasOnReceiveOrderSounds = false end
	local corpseCollision = GetConVar("vj_npc_corpsecollision"):GetInt()
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
end
---------------------------------------------------------------------------------------------------------------------------------------------
local defIdleTbl = {ACT_IDLE}
local defWeaponAimTbl = {ACT_IDLE_ANGRY}
local defScaredStandTbl = {ACT_COWER}
--
function ENT:Initialize()
	if self.AnimTbl_IdleStand == nil then self.AnimTbl_IdleStand = defIdleTbl end
	if self.AnimTbl_WeaponAim == nil then self.AnimTbl_WeaponAim = defWeaponAimTbl end
	if self.AnimTbl_ScaredBehaviorStand == nil then self.AnimTbl_ScaredBehaviorStand = defScaredStandTbl end
	self:CustomOnPreInitialize()
	self:SetSpawnEffect(false)
	self:SetRenderMode(RENDERMODE_NORMAL) // RENDERMODE_TRANSALPHA
	self:AddEFlags(EFL_NO_DISSOLVE)
	self:SetUseType(SIMPLE_USE)
	self:SetName((self.PrintName == "" and list.Get("NPC")[self:GetClass()].Name) or self.PrintName)
	self.SelectedDifficulty = GetConVar("vj_npc_difficulty"):GetInt()
	if VJ_PICK(self.Model) != false then self:SetModel(VJ_PICK(self.Model)) end
	if self.HasHull == true then self:SetHullType(self.HullType) end
	if self.HullSizeNormal == true then self:SetHullSizeNormal() end
	if self.HasSetSolid == true then self:SetSolid(SOLID_BBOX) end // SOLID_OBB
	self:SetCollisionGroup(COLLISION_GROUP_NPC)
	//self:SetCustomCollisionCheck() -- Used for the hook GM:ShouldCollide, not reliable!
	self:SetMaxYawSpeed(self.TurningSpeed)
	ConvarsOnInit(self)
	self:DoChangeMovementType()
	self:SetSurroundingBoundsType(BOUNDS_HITBOXES) // BOUNDS_COLLISION
	self.ExtraCorpsesToRemove_Transition = {}
	self.VJ_AddCertainEntityAsEnemy = {}
	self.VJ_AddCertainEntityAsFriendly = {}
	self.CurrentPossibleEnemies = {}
	self.WeaponAnimTranslations = {}
	self.WeaponInventory = {}
	self.NextThrowGrenadeT = CurTime() + math.Rand(1, 5)
	self.NextIdleSoundT_RegularChange = CurTime() + math.random(0.3, 6)
	self.UseTheSameGeneralSoundPitch_PickedNumber = (self.UseTheSameGeneralSoundPitch and math.random(self.GeneralSoundPitch1, self.GeneralSoundPitch2)) or 0
	self:SetupBloodColor(self.BloodColor)
	if self.Behavior == VJ_BEHAVIOR_PASSIVE or self.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE then
		self.DisableWeapons = true
		self.Weapon_NoSpawnMenu = true
	end
	if self.DisableInitializeCapabilities == false then self:SetInitializeCapabilities() end
	self:SetHealth((GetConVar("vj_npc_allhealth"):GetInt() > 0) and GetConVar("vj_npc_allhealth"):GetInt() or self:VJ_GetDifficultyValue(self.StartHealth))
	self.StartHealth = self:Health()
	//if self.HasSquad == true then self:Fire("setsquad", self.SquadName, 0) end
	self:CustomOnInitialize()
	self:CustomInitialize() -- !!!!!!!!!!!!!! DO NOT USE THIS FUNCTION !!!!!!!!!!!!!! [Backwards Compatibility!]
	self.NextWanderTime = ((self.NextWanderTime != 0) and self.NextWanderTime) or (CurTime() + (self.IdleAlwaysWander and 0 or 1)) -- If self.NextWanderTime isn't given a value THEN if self.IdleAlwaysWander isn't true, wait at least 1 sec before wandering
	self.SightDistance = (GetConVar("vj_npc_seedistance"):GetInt() > 0) and GetConVar("vj_npc_seedistance"):GetInt() or self.SightDistance
	timer.Simple(0.15, function()
		if IsValid(self) then
			self:SetSightDistance(self.SightDistance)
			if self:GetNPCState() <= NPC_STATE_NONE then self:SetNPCState(NPC_STATE_IDLE) end
			if IsValid(self:GetCreator()) && self:GetCreator():GetInfoNum("vj_npc_spawn_guard", 0) == 1 then self.IsGuard = true end
			self:StartSoundTrack()

			-- pitch
			if self:LookupPoseParameter("aim_pitch") then
				self.PoseParameterLooking_Names.pitch[#self.PoseParameterLooking_Names.pitch + 1] = "aim_pitch"
			end
			if self:LookupPoseParameter("head_pitch") then
				self.PoseParameterLooking_Names.pitch[#self.PoseParameterLooking_Names.pitch + 1] = "head_pitch"
			end
			-- yaw
			if self:LookupPoseParameter("aim_yaw") then
				self.PoseParameterLooking_Names.yaw[#self.PoseParameterLooking_Names.yaw + 1] = "aim_yaw"
			end
			if self:LookupPoseParameter("head_yaw") then
				self.PoseParameterLooking_Names.yaw[#self.PoseParameterLooking_Names.yaw + 1] = "head_yaw"
			end
			-- roll
			if self:LookupPoseParameter("aim_roll") then
				self.PoseParameterLooking_Names.roll[#self.PoseParameterLooking_Names.roll + 1] = "aim_roll"
			end
			if self:LookupPoseParameter("head_roll") then
				self.PoseParameterLooking_Names.roll[#self.PoseParameterLooking_Names.roll + 1] = "head_roll"
			end
		end
	end)
	duplicator.RegisterEntityClass(self:GetClass(), VJ.CreateDupe_NPC, "Class", "Equipment", "SpawnFlags", "Data")
	if !self.DisableWeapons then
		timer.Simple(0.1, function()
			if IsValid(self) then
				local wep = self:GetActiveWeapon()
				if IsValid(wep) then
					self.WeaponInventory.Primary = wep
					if IsValid(self:GetCreator()) && self.AllowPrintingInChat == true && !wep.IsVJBaseWeapon then
						self:GetCreator():PrintMessage(HUD_PRINTTALK, "WARNING: "..self:GetName().." requires a VJ Base weapon to work properly!")
					end
					if self.WeaponInventory_AntiArmor == true then
						local antiArmor = VJ_PICK(self.WeaponInventory_AntiArmorList)
						if antiArmor != false && wep:GetClass() != antiArmor then -- If the list isn't empty and it's not the current active weapon
							self.WeaponInventory.AntiArmor = self:Give(antiArmor)
						end
						self:SelectWeapon(wep) -- Change the weapon back to the original weapon
						wep:Equip(self)
					end
					if self.WeaponInventory_Melee == true then
						local melee = VJ_PICK(self.WeaponInventory_MeleeList)
						if melee != false && wep:GetClass() != melee then -- If the list isn't empty and it's not the current active weapon
							self.WeaponInventory.Melee = self:Give(melee)
						end
						self:SelectWeapon(wep) -- Change the weapon back to the original weapon
						wep:Equip(self)
					end
				elseif IsValid(self:GetCreator()) && self.AllowPrintingInChat == true && self.Weapon_NoSpawnMenu == false then
					self:GetCreator():PrintMessage(HUD_PRINTTALK, "WARNING: "..self:GetName().." needs a weapon!")
				end
			end
		end)
	end
	//self:SetSaveValue("m_debugOverlays", 1) -- Enables source engine debug overlays (some commands like 'npc_conditions' need it)
end
-- !!!!!!!!!!!!!! DO NOT USE THESE !!!!!!!!!!!!!! [Backwards Compatibility!]
ENT.MeleeAttacking = false
ENT.ThrowingGrenade = false
function ENT:CustomInitialize() end
function ENT:SetNearestPointToEntityPosition() return self:GetDynamicOrigin() end
function ENT:SetMeleeAttackDamagePosition() return self:GetMeleeAttackDamageOrigin() end
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInitializeCapabilities()
	self:CapabilitiesAdd(bit.bor(CAP_SKIP_NAV_GROUND_CHECK))
	self:CapabilitiesAdd(bit.bor(CAP_ANIMATEDFACE))
	self:CapabilitiesAdd(bit.bor(CAP_TURN_HEAD))
	if self.CanOpenDoors == true then
		self:CapabilitiesAdd(bit.bor(CAP_OPEN_DOORS))
		self:CapabilitiesAdd(bit.bor(CAP_AUTO_DOORS))
		self:CapabilitiesAdd(bit.bor(CAP_USE))
	end
	self:CapabilitiesAdd(bit.bor(CAP_DUCK))
	//if self.HasSquad == true then self:CapabilitiesAdd(bit.bor(CAP_SQUAD)) end
	if self.DisableWeapons == false && self.Weapon_NoSpawnMenu == false then
		self:CapabilitiesAdd(bit.bor(CAP_USE_WEAPONS))
		self:CapabilitiesAdd(bit.bor(CAP_WEAPON_RANGE_ATTACK1))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoChangeMovementType(movType)
	movType = movType or -1
	if movType != -1 then self.MovementType = movType end
	if self.MovementType == VJ_MOVETYPE_GROUND then
		self:RemoveFlags(FL_FLY)
		self:SetNavType(NAV_GROUND)
		self:SetMoveType(MOVETYPE_STEP)
		self:CapabilitiesRemove(CAP_MOVE_FLY)
		self:CapabilitiesAdd(bit.bor(CAP_MOVE_GROUND))
		if (VJ_AnimationExists(self,ACT_JUMP) == true && GetConVar("vj_npc_human_canjump"):GetInt() == 1) or self.UsePlayerModelMovement == true then self:CapabilitiesAdd(bit.bor(CAP_MOVE_JUMP)) end
		//if VJ_AnimationExists(self,ACT_CLIMB_UP) == true then self:CapabilitiesAdd(bit.bor(CAP_MOVE_CLIMB)) end
		if self.DisableWeapons == false then self:CapabilitiesAdd(bit.bor(CAP_MOVE_SHOOT)) end
	elseif self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then
		self:SetGroundEntity(NULL)
		self:AddFlags(FL_FLY)
		self:SetNavType(NAV_FLY)
		self:SetMoveType(MOVETYPE_STEP) // MOVETYPE_FLY, causes issues like Lerp functions not being smooth
		self:CapabilitiesRemove(CAP_MOVE_GROUND)
		self:CapabilitiesRemove(CAP_MOVE_JUMP)
		self:CapabilitiesRemove(CAP_MOVE_CLIMB)
		self:CapabilitiesRemove(CAP_MOVE_SHOOT)
		self:CapabilitiesAdd(bit.bor(CAP_MOVE_FLY))
	elseif self.MovementType == VJ_MOVETYPE_STATIONARY then
		self:RemoveFlags(FL_FLY)
		self:SetNavType(NAV_NONE)
		if self.Stationary_UseNoneMoveType == true then
			self:SetMoveType(MOVETYPE_NONE)
		else
			self:SetMoveType(MOVETYPE_FLY)
		end
		self:CapabilitiesRemove(CAP_MOVE_GROUND)
		self:CapabilitiesRemove(CAP_MOVE_JUMP)
		self:CapabilitiesRemove(CAP_MOVE_CLIMB)
		self:CapabilitiesRemove(CAP_MOVE_SHOOT)
		self:CapabilitiesRemove(CAP_MOVE_FLY)
	elseif self.MovementType == VJ_MOVETYPE_PHYSICS then
		self:RemoveFlags(FL_FLY)
		self:SetNavType(NAV_NONE)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:CapabilitiesRemove(CAP_MOVE_GROUND)
		self:CapabilitiesRemove(CAP_MOVE_JUMP)
		self:CapabilitiesRemove(CAP_MOVE_CLIMB)
		self:CapabilitiesRemove(CAP_MOVE_SHOOT)
		self:CapabilitiesRemove(CAP_MOVE_FLY)
	end
	self:CustomOnChangeMovementType(movType)
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	The main animation function, it can play activities, sequences and gestures
		- animation = The animation to play, it can be a table OR string OR ACT_*
			- Adding "vjseq_" to a string will make it play as a sequence
			- Adding "vjges_" to a string will make it play as a gesture
			- If it's a string AND "vjseq_" or "vjges_" is NOT added:
				- The base will attempt to convert it activity, if it fails, it will play it as a sequence
				- This behavior can be overridden by AlwaysUseSequence & AlwaysUseGesture options
		- stopActivities = If true, it will stop activities such as idle, chasing, attacking, etc. for a given amount of time | DEFAULT: false
		- stopActivitiesTime = How long it will stop the activities such as idle, chasing, attacking, etc. | DEFAULT: 0
			- false = Base calculates the time (recommended)
		- faceEnemy = Should it constantly face the enemy while playing this animation? | DEFAULT: false
		- animDelay = Delays the animation by the given number | DEFAULT: 0
		- extraOptions = Table that holds extra options to modify parts of the code
			- OnFinish(interrupted, anim) = A function that runs when the animation finishes | DEFAULT: nil
				- interrupted = Was the animation cut off? Basically something else stopped it before the animation fully completed
				- anim = The animation it played, it can be a string or an activity enumeration
			- AlwaysUseSequence = The base will force attempt to play this animation as a sequence regardless of the other options | DEFAULT: false
			- AlwaysUseGesture = The base will force attempt to play this animation as a gesture regardless of the other options | DEFAULT: false
			- SequenceInterruptible = Can this sequence be interrupted? | DEFAULT: false
			- SequenceDuration = How long is the sequence? | DEFAULT: Base decides
				- WARNING: Recommended to not change this option, it's mostly used internally by the base!
			- PlayBackRate = How fast should the animation play? | DEFAULT: self.AnimationPlaybackRate
			- PlayBackRateCalculated = If the playback rate is already calculated in the stopActivitiesTime, then set this to true! | DEFAULT: false
		- customFunc() = TODO: NOT FINISHED
	Returns
		- Number, Accurate animation play time after taking everything in account
				- WARNING: If "animDelay" parameter is used, result may be inaccurate!
-----------------------------------------------------------]]
local varGes = "vjges_"
local varSeq = "vjseq_"
--
function ENT:VJ_ACT_PLAYACTIVITY(animation, stopActivities, stopActivitiesTime, faceEnemy, animDelay, extraOptions, customFunc)
	animation = VJ_PICK(animation)
	if animation == false then return 0 end
	
	stopActivities = stopActivities or false
	if stopActivitiesTime == nil then -- If user didn't put anything, then default it to 0
		stopActivitiesTime = 0 -- Set this value to false to let the base calculate the time
	end
	faceEnemy = faceEnemy or false -- Should it face the enemy while playing this animation?
	animDelay = tonumber(animDelay) or 0 -- How much time until it starts playing the animation (seconds)
	extraOptions = extraOptions or {}
		local finalPlayBackRate = extraOptions.PlayBackRate or self.AnimationPlaybackRate -- How fast should the animation play?
	local isGesture = false
	local isSequence = false
	local isString = isstring(animation)
	
	-- Handle "vjges_" and "vjseq_"
	if isString then
		local strExpGes = string.Explode(varGes, animation)
		-- Gestures
		if strExpGes[2] then -- If 2 exists, then vjges_ was found!
			isGesture = true
			animation = strExpGes[2]
			-- If current name is -1 then it's probably han activity, so turn it into an activity | EX: "vjges_"..ACT_MELEE_ATTACK1
			if self:LookupSequence(animation) == -1 then
				animation = tonumber(animation)
				isString = false
			end
		else -- Sequences
			local strExpSeq = string.Explode(varSeq, animation)
			if strExpSeq[2] then -- If 2 exists, then vjseq_ was found!
				isSequence = true
				animation = strExpSeq[2]
			end
		end
	end
	
	if extraOptions.AlwaysUseGesture == true then isGesture = true end -- Must play a gesture
	if extraOptions.AlwaysUseSequence == true then -- Must play a sequence
		isGesture = false
		isSequence = true
		if isnumber(animation) then -- If it's an activity, then convert it to a string
			animation = self:GetSequenceName(self:SelectWeightedSequence(animation))
		end
	elseif isString && !isSequence then -- Only for regular & gesture strings
		-- If it can be played as an activity, then convert it!
		local result = self:GetSequenceActivity(self:LookupSequence(animation))
		if result == nil or result == -1 then -- Leave it as string
			isSequence = true
		else -- Set it as an activity
			animation = result
		end
	end
	
	-- If the given animation doesn't exist, then check to see if it does in the weapon translation list
	if VJ_AnimationExists(self, animation) == false then
		if !isString && IsValid(self:GetActiveWeapon()) then -- If it's an activity and has a valid weapon then check for weapon translation
			-- If it returns the same activity as animation, then there isn't even a translation for it so don't play any animation =(
			if self:GetActiveWeapon().IsVJBaseWeapon && self:TranslateToWeaponAnim(animation) == animation then return 0 end
		else
			return 0 -- No animation =(
		end
	end
	
	-- Seed the current animation, used for animation delaying & on complete check
	local seed = CurTime(); self.CurAnimationSeed = seed
	local function PlayAct()
		local animTime = self:DecideAnimationLength(animation, false)
		
		if stopActivities == true then
			if stopActivitiesTime == false then -- false = Let the base calculate the time
				stopActivitiesTime = animTime
			elseif !extraOptions.PlayBackRateCalculated then -- Make sure not to calculate the playback rate when it already has!
				stopActivitiesTime = stopActivitiesTime / self:GetPlaybackRate()
				animTime = stopActivitiesTime
			end
			
			self:StopAttacks(true)
			self.vACT_StopAttacks = true
			self.NextChaseTime = CurTime() + stopActivitiesTime
			self.NextIdleTime = CurTime() + stopActivitiesTime
			
			-- If there is already a timer, then adjust it instead of creating a new one
			if !timer.Adjust("timer_act_stopattacks"..self:EntIndex(), stopActivitiesTime, 1, function() self.vACT_StopAttacks = false end) then
				timer.Create("timer_act_stopattacks"..self:EntIndex(), stopActivitiesTime, 1, function() self.vACT_StopAttacks = false end)
			end
		end
		self.CurAnimationSeed = seed -- We need to set it again because self:StopAttacks() above will reset it when it calls to chase enemy!
		
		local vsched = ai_vj_schedule.New("vj_act_"..animation)
		if (customFunc) then customFunc(vsched, animation) end
		
		self.NextIdleStandTime = 0
		self.VJ_PlayingSequence = false
		self.VJ_PlayingInterruptSequence = false
		
		self.AnimationPlaybackRate = finalPlayBackRate
		self:SetPlaybackRate(finalPlayBackRate)
		
		if isGesture == true then
			local gesture = false
			if isstring(animation) then
				gesture = self:AddGestureSequence(self:LookupSequence(animation))
			else
				gesture = self:AddGesture(animation)
			end
			if gesture != false then
				//self:ClearSchedule()
				//self:SetLayerBlendIn(1, 0)
				//self:SetLayerBlendOut(1, 0)
				self:SetLayerPriority(gesture, 1) // 2
				//self:SetLayerWeight(gesture, 1)
				self:SetLayerPlaybackRate(gesture, finalPlayBackRate * 0.5)
				//self:SetLayerDuration(gesture, 3)
				//print(self:GetLayerDuration(gesture))
			end
		elseif isSequence == true then
			local dur = (extraOptions.SequenceDuration or self:SequenceDuration(self:LookupSequence(animation))) / self.AnimationPlaybackRate
			if faceEnemy == true then
				self:FaceCertainEntity(self:GetEnemy(), true, dur)
			end
			self:VJ_PlaySequence(animation, finalPlayBackRate, extraOptions.SequenceDuration != false, dur, extraOptions.SequenceInterruptible or false)
		end
		if isGesture == false then -- If it's sequence or activity
			-- For humans, internally the base will set these variables back to true after this function if it's called by weapon attack animations!
			self.DoingWeaponAttack = false
			self.DoingWeaponAttack_Standing = false
			
			//self:StartEngineTask(GetTaskList("TASK_RESET_ACTIVITY"), 0) //vsched:EngTask("TASK_RESET_ACTIVITY", 0)
			//if self.Dead == true then vsched:EngTask("TASK_STOP_MOVING", 0) end
			//self:FrameAdvance(0)
			self:TaskComplete()
			self:StopMoving()
			self:ClearSchedule()
			self:ClearGoal()
			if isSequence == false then -- Only if activity
				//self:SetActivity(ACT_RESET)
				self.VJ_PlayingSequence = false
				if self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then
					self:ResetIdealActivity(animation)
					//vsched:EngTask("TASK_SET_ACTIVITY", animation) -- To avoid AutoMovement stopping the velocity
				//elseif faceEnemy == true then
					//vsched:EngTask("TASK_PLAY_SEQUENCE_FACE_ENEMY", animation)
				else
					if faceEnemy == true then
						self:FaceCertainEntity(self:GetEnemy(), true, animTime)
					end
					-- This fixes: Animation NOT applying walk frames if the previous animation was the same
					if self:GetActivity() == animation then
						self:ResetSequenceInfo()
						self:SetSaveValue("sequence", 0)
					end
					vsched:EngTask("TASK_PLAY_SEQUENCE", animation)
					//self:ResetIdealActivity(animation)
					//self:AutoMovement(self:GetAnimTimeInterval())
				end
			end
			vsched.IsPlayActivity = true
			self:StartSchedule(vsched)
		end
		
		-- If it has a OnFinish function, then set the timer to run it when it finishes!
		if (extraOptions.OnFinish) then
			timer.Simple(animTime, function()
				if IsValid(self) && !self.Dead then
					extraOptions.OnFinish(self.CurAnimationSeed != seed, animation)
				end
			end)
		end
		return animTime
	end
	
	-- For delay system
	if animDelay > 0 then
		timer.Simple(animDelay, function()
			if IsValid(self) && self.CurAnimationSeed == seed then
				PlayAct()
			end
		end)
		return animDelay + self:DecideAnimationLength(animation, false) -- Approximation, this may be inaccurate!
	else
		return PlayAct()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local task_chaseEnemyLOS = ai_vj_schedule.New("vj_chase_enemy_los")
	task_chaseEnemyLOS:EngTask("TASK_GET_PATH_TO_ENEMY_LOS", 0)
	//task_chaseEnemyLOS:EngTask("TASK_RUN_PATH", 0)
	task_chaseEnemyLOS:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
	//task_chaseEnemyLOS:EngTask("TASK_FACE_ENEMY", 0)
	//task_chaseEnemyLOS.ResetOnFail = true
	task_chaseEnemyLOS.CanShootWhenMoving = true
	task_chaseEnemyLOS.CanBeInterrupted = true
	task_chaseEnemyLOS.IsMovingTask = true
	task_chaseEnemyLOS.MoveType = 1
--
local task_chaseEnemy = ai_vj_schedule.New("vj_chase_enemy")
	task_chaseEnemy:EngTask("TASK_GET_PATH_TO_ENEMY", 0)
	//task_chaseEnemy:EngTask("TASK_RUN_PATH", 0)
	task_chaseEnemy:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
	//task_chaseEnemy:EngTask("TASK_FACE_ENEMY", 0)
	//task_chaseEnemy.ResetOnFail = true
	task_chaseEnemy.CanShootWhenMoving = true
	//task_chaseEnemy.StopScheduleIfNotMoving = true
	task_chaseEnemy.CanBeInterrupted = true
	task_chaseEnemy.IsMovingTask = true
	task_chaseEnemy.MoveType = 1
--
local varChaseEnemy = "vj_chase_enemy"
function ENT:VJ_TASK_CHASE_ENEMY(doLOSChase)
	doLOSChase = doLOSChase or false
	self:ClearCondition(COND_ENEMY_UNREACHABLE)
	if self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then self:AA_ChaseEnemy() return end
	//if self.CurrentSchedule != nil && self.CurrentSchedule.Name == "vj_chase_enemy" then return end
	if self:GetNavType() == NAV_JUMP or self:GetNavType() == NAV_CLIMB then return end
	//if (CurTime() <= self.JumpLegalLandingTime && (self:GetActivity() == ACT_JUMP or self:GetActivity() == ACT_GLIDE or self:GetActivity() == ACT_LAND)) or self:GetActivity() == ACT_CLIMB_UP or self:GetActivity() == ACT_CLIMB_DOWN or self:GetActivity() == ACT_CLIMB_DISMOUNT then return end
	if (self:GetEnemyLastKnownPos():Distance(self:GetEnemy():GetPos()) <= 12) && self.CurrentSchedule != nil && self.CurrentSchedule.Name == varChaseEnemy then return end
	self:SetMovementActivity(VJ_PICK(self.AnimTbl_Run))
	if doLOSChase == true then
		task_chaseEnemyLOS.RunCode_OnFinish = function()
			local ene = self:GetEnemy()
			if IsValid(ene) then
				self:RememberUnreachable(ene, 0)
				self:VJ_TASK_CHASE_ENEMY(false)
			end
		end
		self:StartSchedule(task_chaseEnemyLOS)
	else
		self:StartSchedule(task_chaseEnemy)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local table_remove = table.remove
--
function ENT:VJ_TASK_IDLE_STAND()
	if self:IsMoving() or (self.NextIdleTime > CurTime()) or (self.AA_CurrentMoveTime > CurTime()) or self:GetNavType() == NAV_JUMP or self:GetNavType() == NAV_CLIMB then return end // self.CurrentSchedule != nil
	if (self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC) && self:BusyWithActivity() then return end
	//if (self.CurrentSchedule != nil && self.CurrentSchedule.Name == "vj_idle_stand") or (self.CurrentAnim_CustomIdle != 0 && VJ_IsCurrentAnimation(self,self.CurrentAnim_CustomIdle) == true) then return end
	//if (self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC) && self:GetVelocity():Length() > 0 then return end
	//if self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then self:AA_StopMoving() return end

	/*local vschedIdleStand = ai_vj_schedule.New("vj_idle_stand")
	//vschedIdleStand:EngTask("TASK_FACE_REASONABLE")
	vschedIdleStand:EngTask("TASK_STOP_MOVING")
	vschedIdleStand:EngTask("TASK_WAIT_INDEFINITE")
	vschedIdleStand.CanBeInterrupted = true
	self:StartSchedule(vschedIdleStand)*/
	
	local idleAnimTbl = self.NoWeapon_UseScaredBehavior_Active == true and self.AnimTbl_ScaredBehaviorStand or ((self.Alerted && self:GetWeaponState() != VJ_WEP_STATE_HOLSTERED && IsValid(self:GetActiveWeapon())) and self.AnimTbl_WeaponAim or self.AnimTbl_IdleStand)
	local sameAnimFound = false -- If true then it one of the animations in the table is the same as the current!
	//local numOfAnims = 0 -- Number of valid animations found
	for k, v in pairs(idleAnimTbl) do
		v = VJ_SequenceToActivity(self, v) -- Translate any sequence to activity
		if v != false then -- Its a valid activity
			//numOfAnims = numOfAnims + 1
			idleAnimTbl[k] = v -- In case it was a sequence, override it with the translated activity number
			-- Check if its the current idle animation...
			if sameAnimFound == false && self.CurrentAnim_IdleStand == v then
				sameAnimFound = true
				//break
			end
		else -- Get rid of any animations that aren't valid!
			table_remove(idleAnimTbl, k)
		end
	end
	//PrintTable(idleAnimTbl)
	-- If there is more than 1 animation in the table AND one of the animations is the current animation AND time hasn't expired, then return!
	/*if #idleAnimTbl > 1 && sameAnimFound == true && self.NextIdleStandTime > CurTime() then
		return
	end*/
	
	local pickedAnim = VJ_PICK(idleAnimTbl)
	
	-- If no animation was found, then use ACT_IDLE
	if pickedAnim == false then
		pickedAnim = ACT_IDLE
		//sameAnimFound = true
	end
	
	-- If sequence and it has no activity, then don't continue!
	//pickedAnim = VJ_SequenceToActivity(self,pickedAnim)
	//if pickedAnim == false then return false end
	
	if (!sameAnimFound /*or (sameAnimFound && numOfAnims == 1 && CurTime() > self.NextIdleStandTime)*/) or (CurTime() > self.NextIdleStandTime) then
		self.CurrentAnim_IdleStand = pickedAnim
		self.CurIdleStandMove = false
		-- Old system
		/*if (self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC) then
			if self:BusyWithActivity() == true then return end // self:GetSequence() == 0
			self:AA_StopMoving()
			self:VJ_ACT_PLAYACTIVITY(pickedAnim, false, 0, false, 0, {SequenceDuration=false, SequenceInterruptible=true}) // AlwaysUseSequence=true
		end
		if self.CurrentSchedule == nil then -- If it's not doing a schedule then reset the activity to make sure it's not already playing the same idle activity!
			self:StartEngineTask(GetTaskList("TASK_RESET_ACTIVITY"), 0)
			//self:SetIdealActivity(ACT_RESET)
		end*/
		//self:StartEngineTask(GetTaskList("TASK_PLAY_SEQUENCE"),pickedAnim)
		if (self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC) then self:AA_StopMoving() end
		self.CurAnimationSeed = 0
		self.VJ_PlayingSequence = false
		self.VJ_PlayingInterruptSequence = false
		self:ResetIdealActivity(pickedAnim)
		timer.Simple(0.01, function() -- So we can make sure the engine has enough time to set the animation
			if IsValid(self) && self.NextIdleStandTime != 0 then
				local getSeq = self:GetSequence()
				self.CurIdleStandMove = self:GetSequenceMoveDist(getSeq) > 0
				local seqToAct = VJ_SequenceToActivity(self,self:GetSequenceName(getSeq))
				if seqToAct == pickedAnim or (IsValid(self:GetActiveWeapon()) && seqToAct == self:TranslateToWeaponAnim(pickedAnim)) then -- Nayir yete himagva animation e nooynene
					self.NextIdleStandTime = CurTime() + ((self:SequenceDuration(getSeq) - 0.15) / self:GetPlaybackRate()) -- Yete nooynene ooremen jamanage tir animation-en yergarootyan chap!
				end
			end
		end)
		self.NextIdleStandTime = CurTime() + 0.15 -- This is temp, timer above overrides it
	elseif self.CurIdleStandMove && !self:IsSequenceFinished() then
		self:AutoMovement(self:GetAnimTimeInterval())
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoIdleAnimation(iType)
	if self:GetState() == VJ_STATE_ONLY_ANIMATION_CONSTANT or self.Dead == true or self.VJ_IsBeingControlled == true or self.PlayingAttackAnimation == true or (self.NextIdleTime > CurTime()) or (self.AA_CurrentMoveTime > CurTime()) or (self.CurrentSchedule != nil && self.CurrentSchedule.Name == "vj_act_resetenemy") then return end
	iType = iType or 0 -- 0 = Random | 1 = Wander | 2 = Idle Stand
	
	if self.IdleAlwaysWander == true then iType = 1 end
	
	-- Things that override can't bypass, Forces the NPC to ONLY idle stand!
	if self.DisableWandering == true or self.IsGuard == true or self.MovementType == VJ_MOVETYPE_STATIONARY or self.IsVJBaseSNPC_Tank == true or self.LastHiddenZone_CanWander == false or self.NextWanderTime > CurTime() or self.IsFollowing == true or self.Medic_IsHealingAlly == true then
		iType = 2
	end
	
	if iType == 0 then -- Random (Wander & Idle Stand)
		if math.random(1, 3) == 1 then
			self:VJ_TASK_IDLE_WANDER() else self:VJ_TASK_IDLE_STAND()
		end
	elseif iType == 1 then -- Wander
		self:VJ_TASK_IDLE_WANDER()
	elseif iType == 2 then -- Idle Stand
		self:VJ_TASK_IDLE_STAND()
		return -- Don't set self.NextWanderTime below
	end
	
	self.NextWanderTime = CurTime() + math.Rand(3, 6) // self.NextIdleTime
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoChaseAnimation(alwaysChase)
	local ene = self:GetEnemy()
	if self:GetState() == VJ_STATE_ONLY_ANIMATION_CONSTANT or self.Dead == true or self.VJ_IsBeingControlled == true or self.PlayingAttackAnimation == true or self.Flinching == true or self.IsVJBaseSNPC_Tank == true or !IsValid(ene) or (self.NextChaseTime > CurTime()) or (CurTime() < self.TakingCoverT) or (self.PlayingAttackAnimation == true && self.MovementType != VJ_MOVETYPE_AERIAL && self.MovementType != VJ_MOVETYPE_AQUATIC) then return end
	if self:VJ_GetNearestPointToEntityDistance(ene) < self.MeleeAttackDistance && self.LastEnemyVisible && (self.LastEnemySightDiff > math_cos(math_rad(self.MeleeAttackAngleRadius))) then self:VJ_TASK_IDLE_STAND() return end -- Not melee attacking yet but it is in range, so stop moving!
	
	alwaysChase = alwaysChase or false -- true = Chase no matter what
	
	-- Things that override can't bypass, Forces the NPC to ONLY idle stand!
	if self.MovementType == VJ_MOVETYPE_STATIONARY or self.IsFollowing == true or self.Medic_IsHealingAlly == true or self:GetState() == VJ_STATE_ONLY_ANIMATION then
		self:VJ_TASK_IDLE_STAND()
		return
	end
	
	-- For non-aggressive SNPCs
	if self.Behavior == VJ_BEHAVIOR_PASSIVE or self.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE then
		self:VJ_TASK_COVER_FROM_ENEMY("TASK_RUN_PATH")
		self.NextChaseTime = CurTime() + 3
		return
	end
	
	if alwaysChase == false && (self.DisableChasingEnemy == true or self.IsGuard == true) then self:VJ_TASK_IDLE_STAND() return end
	
	-- If the enemy is not reachable
	if (self:HasCondition(COND_ENEMY_UNREACHABLE) or self:IsUnreachable(ene)) && (IsValid(self:GetActiveWeapon()) == true && (!self:GetActiveWeapon().IsMeleeWeapon)) then
		self:VJ_TASK_CHASE_ENEMY(true)
		self:RememberUnreachable(ene, 2)
	else -- Is reachable, so chase the enemy!
		self:VJ_TASK_CHASE_ENEMY(false)
	end
	
	-- Set the next chase time
	if self.NextChaseTime > CurTime() then return end -- Don't set it if it's already set!
	self.NextChaseTime = CurTime() + (((self.LatestEnemyDistance > 2000) and 1) or 0.1) -- If the enemy is far, increase the delay!
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetupWeaponHoldTypeAnims(hType)
	-- Decide what type of animation set it uses
	if VJ_AnimationExists(self, "signal_takecover") == true && VJ_AnimationExists(self, "grenthrow") == true && VJ_AnimationExists(self, "bugbait_hit") == true then
		self.ModelAnimationSet = VJ_MODEL_ANIMSET_COMBINE -- Combine
	elseif VJ_AnimationExists(self, ACT_WALK_AIM_PISTOL) == true && VJ_AnimationExists(self, ACT_RUN_AIM_PISTOL) == true && VJ_AnimationExists(self, ACT_POLICE_HARASS1) == true then
		self.ModelAnimationSet = VJ_MODEL_ANIMSET_METROCOP -- Metrocop
	elseif VJ_AnimationExists(self, "coverlow_r") == true && VJ_AnimationExists(self, "wave_smg1") == true && VJ_AnimationExists(self, ACT_BUSY_SIT_GROUND) == true then
		self.ModelAnimationSet = VJ_MODEL_ANIMSET_REBEL -- Rebel
	elseif VJ_AnimationExists(self, "gmod_breath_layer") == true then
		self.ModelAnimationSet = VJ_MODEL_ANIMSET_PLAYER -- Player
	end
	
	self.WeaponAnimTranslations = {}
	self.NextIdleStandTime = 0
	if self:CustomOnSetupWeaponHoldTypeAnims(hType) == true then return end
	
	if self.ModelAnimationSet == VJ_MODEL_ANIMSET_COMBINE then -- Combine =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
		-- Use rifle animations with minor edits if it's holding a handgun
		local rifle_idle = ACT_IDLE_SMG1
		local rifle_walk = VJ_PICK({ACT_WALK_RIFLE, VJ_SequenceToActivity(self, "walkeasy_all")})
		if hType == "pistol" or hType == "revolver" or hType == "melee" or hType == "melee2" or hType == "knife" then
			rifle_idle = VJ_SequenceToActivity(self, "idle_unarmed")
			rifle_walk = VJ_SequenceToActivity(self, "walkunarmed_all")
		end
		
		-- "Leanwall_CrouchLeft_A_idle", "Leanwall_CrouchLeft_B_idle", "Leanwall_CrouchLeft_C_idle", "Leanwall_CrouchLeft_D_idle"
		self.WeaponAnimTranslations[ACT_COVER_LOW] 							= {ACT_COVER, "vjseq_Leanwall_CrouchLeft_A_idle", "vjseq_Leanwall_CrouchLeft_B_idle", "vjseq_Leanwall_CrouchLeft_C_idle", "vjseq_Leanwall_CrouchLeft_D_idle"}
		if hType == "ar2" or hType == "smg" or hType == "rpg" or hType == "pistol" or hType == "revolver" or hType == "melee" or hType == "melee2" or hType == "knife" then
			if hType == "ar2" or hType == "pistol" or hType == "revolver" then
				self.WeaponAnimTranslations[ACT_RANGE_ATTACK1] 				= ACT_RANGE_ATTACK_AR2
				self.WeaponAnimTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_GESTURE_RANGE_ATTACK_AR2
				self.WeaponAnimTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_RANGE_ATTACK_AR2_LOW
				//self.WeaponAnimTranslations[ACT_RELOAD] 					= ACT_RELOAD_SMG1 -- No need to translate
				//self.WeaponAnimTranslations[ACT_IDLE_ANGRY] 				= ACT_IDLE_ANGRY -- No need to translate, it's already the correct animation
			elseif hType == "smg" or hType == "rpg" then
				self.WeaponAnimTranslations[ACT_RANGE_ATTACK1] 				= ACT_RANGE_ATTACK_SMG1
				self.WeaponAnimTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_GESTURE_RANGE_ATTACK_SMG1
				self.WeaponAnimTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_RANGE_ATTACK_SMG1_LOW
				//self.WeaponAnimTranslations[ACT_RELOAD] 					= ACT_RELOAD_SMG1 -- No need to translate
				self.WeaponAnimTranslations[ACT_IDLE_ANGRY] 				= ACT_IDLE_ANGRY_SMG1
			elseif hType == "melee" or hType == "melee2" or hType == "knife" then
				self.WeaponAnimTranslations[ACT_RANGE_ATTACK1] 				= ACT_MELEE_ATTACK1
				self.WeaponAnimTranslations[ACT_GESTURE_RANGE_ATTACK1] 		= false -- Don't play anything!
				//self.WeaponAnimTranslations[ACT_RANGE_ATTACK1_LOW] 		= ACT_RANGE_ATTACK_SMG1_LOW -- Not used for melee
				//self.WeaponAnimTranslations[ACT_RELOAD] 					= ACT_RELOAD_SMG1 -- Not used for melee
				self.WeaponAnimTranslations[ACT_IDLE_ANGRY] 				= rifle_idle
			end
			//self.WeaponAnimTranslations[ACT_RELOAD_LOW] 					= ACT_RELOAD_SMG1_LOW -- No need to translate
			
			self.WeaponAnimTranslations[ACT_IDLE] 							= rifle_idle
			
			self.WeaponAnimTranslations[ACT_WALK] 							= rifle_walk
			self.WeaponAnimTranslations[ACT_WALK_AIM] 						= ACT_WALK_AIM_RIFLE
			self.WeaponAnimTranslations[ACT_WALK_CROUCH] 					= ACT_WALK_CROUCH_RIFLE
			self.WeaponAnimTranslations[ACT_WALK_CROUCH_AIM] 				= ACT_WALK_CROUCH_AIM_RIFLE
			
			self.WeaponAnimTranslations[ACT_RUN] 							= ACT_RUN_RIFLE
			self.WeaponAnimTranslations[ACT_RUN_AIM] 						= ACT_RUN_AIM_RIFLE
			self.WeaponAnimTranslations[ACT_RUN_CROUCH] 					= ACT_RUN_CROUCH_RIFLE
			self.WeaponAnimTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_RUN_CROUCH_AIM_RIFLE
		elseif hType == "crossbow" or hType == "shotgun" then
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1] 					= ACT_RANGE_ATTACK_SHOTGUN
			if hType == "crossbow" then
				self.WeaponAnimTranslations[ACT_GESTURE_RANGE_ATTACK1] 			= ACT_GESTURE_RANGE_ATTACK_AR2
			else
				self.WeaponAnimTranslations[ACT_GESTURE_RANGE_ATTACK1] 			= ACT_GESTURE_RANGE_ATTACK_SHOTGUN
			end
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1_LOW] 				= ACT_RANGE_ATTACK_SHOTGUN_LOW
			//self.WeaponAnimTranslations[ACT_RELOAD] 						= ACT_RELOAD_SHOTGUN -- No need to translate
			//self.WeaponAnimTranslations[ACT_RELOAD_LOW] 					= ACT_RELOAD_SMG1_LOW -- No need to translate
			
			self.WeaponAnimTranslations[ACT_IDLE] 							= ACT_SHOTGUN_IDLE4
			self.WeaponAnimTranslations[ACT_IDLE_ANGRY] 					= ACT_IDLE_ANGRY_SHOTGUN
			
			self.WeaponAnimTranslations[ACT_WALK] 							= ACT_WALK_AIM_SHOTGUN
			self.WeaponAnimTranslations[ACT_WALK_AIM] 						= ACT_WALK_AIM_SHOTGUN
			self.WeaponAnimTranslations[ACT_WALK_CROUCH] 					= ACT_WALK_CROUCH_RIFLE
			self.WeaponAnimTranslations[ACT_WALK_CROUCH_AIM] 				= ACT_WALK_CROUCH_AIM_RIFLE
			
			self.WeaponAnimTranslations[ACT_RUN] 							= ACT_RUN_RIFLE
			self.WeaponAnimTranslations[ACT_RUN_AIM] 						= ACT_RUN_AIM_SHOTGUN
			self.WeaponAnimTranslations[ACT_RUN_CROUCH] 					= ACT_RUN_CROUCH_RIFLE
			self.WeaponAnimTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_RUN_CROUCH_AIM_RIFLE
		end
	elseif self.ModelAnimationSet == VJ_MODEL_ANIMSET_METROCOP then -- Metrocop =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
		-- Do not translate crouch walking and also make the crouch running a walking one instead
		self.WeaponAnimTranslations[ACT_RUN_CROUCH] 						= ACT_WALK_CROUCH
		
		if hType == "smg" or hType == "rpg" or hType == "ar2" or hType == "crossbow" or hType == "shotgun" then
			-- Note: Metrocops must use smg animation, they don't have any animations for AR2!
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1] 					= ACT_RANGE_ATTACK_SMG1
			self.WeaponAnimTranslations[ACT_GESTURE_RANGE_ATTACK1] 			= ACT_GESTURE_RANGE_ATTACK_SMG1
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1_LOW] 				= ACT_RANGE_ATTACK_SMG1_LOW
			self.WeaponAnimTranslations[ACT_RELOAD] 						= ACT_RELOAD_SMG1
			self.WeaponAnimTranslations[ACT_COVER_LOW] 						= ACT_COVER_SMG1_LOW
			self.WeaponAnimTranslations[ACT_RELOAD_LOW] 					= ACT_RELOAD_SMG1_LOW
			
			self.WeaponAnimTranslations[ACT_IDLE] 							= ACT_IDLE_SMG1
			self.WeaponAnimTranslations[ACT_IDLE_ANGRY] 					= ACT_IDLE_ANGRY_SMG1
			
			self.WeaponAnimTranslations[ACT_WALK] 							= ACT_WALK_RIFLE
			self.WeaponAnimTranslations[ACT_WALK_AIM] 						= ACT_WALK_AIM_RIFLE
			self.WeaponAnimTranslations[ACT_WALK_CROUCH_AIM] 				= ACT_WALK_CROUCH_AIM_RIFLE
			
			self.WeaponAnimTranslations[ACT_RUN] 							= ACT_RUN_RIFLE
			self.WeaponAnimTranslations[ACT_RUN_AIM] 						= ACT_RUN_AIM_RIFLE
			self.WeaponAnimTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_RUN_CROUCH_AIM_RIFLE
		elseif hType == "pistol" or hType == "revolver" then
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1] 					= ACT_RANGE_ATTACK_PISTOL
			self.WeaponAnimTranslations[ACT_GESTURE_RANGE_ATTACK1] 			= ACT_GESTURE_RANGE_ATTACK_PISTOL
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1_LOW] 				= ACT_RANGE_ATTACK_PISTOL_LOW
			self.WeaponAnimTranslations[ACT_COVER_LOW] 						= ACT_COVER_PISTOL_LOW
			self.WeaponAnimTranslations[ACT_RELOAD] 						= ACT_RELOAD_PISTOL
			self.WeaponAnimTranslations[ACT_RELOAD_LOW] 					= ACT_RELOAD_PISTOL_LOW
			
			self.WeaponAnimTranslations[ACT_IDLE] 							= ACT_IDLE_PISTOL
			self.WeaponAnimTranslations[ACT_IDLE_ANGRY] 					= ACT_IDLE_ANGRY_PISTOL
			
			self.WeaponAnimTranslations[ACT_WALK] 							= VJ_PICK({ACT_WALK, ACT_WALK_PISTOL})
			self.WeaponAnimTranslations[ACT_WALK_AIM] 						= ACT_WALK_AIM_PISTOL
			//self.WeaponAnimTranslations[ACT_WALK_CROUCH] 					= ACT_WALK_CROUCH_RIFLE -- No need to translate
			self.WeaponAnimTranslations[ACT_WALK_CROUCH_AIM] 				= ACT_WALK_CROUCH_AIM_RIFLE
			
			self.WeaponAnimTranslations[ACT_RUN] 							= VJ_PICK({ACT_RUN, ACT_RUN_PISTOL})
			self.WeaponAnimTranslations[ACT_RUN_AIM] 						= ACT_RUN_AIM_PISTOL
			//self.WeaponAnimTranslations[ACT_RUN_CROUCH] 					= ACT_RUN_CROUCH_RIFLE -- No need to translate
			self.WeaponAnimTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_RUN_CROUCH_AIM_RIFLE
		elseif hType == "melee" or hType == "melee2" or hType == "knife" then
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1] 					= ACT_MELEE_ATTACK_SWING
			self.WeaponAnimTranslations[ACT_GESTURE_RANGE_ATTACK1] 			= false //ACT_MELEE_ATTACK_SWING_GESTURE -- Don't play anything!
			//self.WeaponAnimTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_RANGE_ATTACK_SMG1_LOW -- Not used for melee
			self.WeaponAnimTranslations[ACT_COVER_LOW] 						= ACT_COWER
			//self.WeaponAnimTranslations[ACT_RELOAD] 						= ACT_RELOAD_SMG1 -- Not used for melee
			//self.WeaponAnimTranslations[ACT_RELOAD_LOW] 					= ACT_RELOAD_SMG1_LOW -- Not used for melee
			
			self.WeaponAnimTranslations[ACT_IDLE] 							= {ACT_IDLE, ACT_IDLE, VJ_SequenceToActivity(self, "plazathreat1")}
			self.WeaponAnimTranslations[ACT_IDLE_ANGRY] 					= ACT_IDLE_ANGRY_MELEE
			
			self.WeaponAnimTranslations[ACT_WALK] 							= VJ_PICK({ACT_WALK, ACT_WALK_ANGRY})
			//self.WeaponAnimTranslations[ACT_WALK_AIM] 					= ACT_WALK_AIM_RIFLE -- Not used for melee
			//self.WeaponAnimTranslations[ACT_WALK_CROUCH] 					= ACT_WALK_CROUCH_RIFLE -- No need to translate
			//self.WeaponAnimTranslations[ACT_WALK_CROUCH_AIM] 				= ACT_WALK_CROUCH_AIM_RIFLE -- Not used for melee
			
			//self.WeaponAnimTranslations[ACT_RUN] 							= ACT_RUN -- No need to translate
			//self.WeaponAnimTranslations[ACT_RUN_AIM] 						= ACT_RUN_AIM_RIFLE -- Not used for melee
			//self.WeaponAnimTranslations[ACT_RUN_CROUCH] 					= ACT_RUN_CROUCH_RIFLE -- No need to translate
			//self.WeaponAnimTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_RUN_CROUCH_AIM_RIFLE -- Not used for melee
		end
	elseif self.ModelAnimationSet == VJ_MODEL_ANIMSET_REBEL then -- Rebel =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
		local isFemale = VJ_AnimationExists(self, ACT_IDLE_ANGRY_PISTOL)
		
		-- handguns use a different set!
		self.WeaponAnimTranslations[ACT_COVER_LOW] 							= {ACT_COVER_LOW_RPG, ACT_COVER_LOW, "vjseq_coverlow_l", "vjseq_coverlow_r"}
		
		if hType == "ar2" then
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1] 					= ACT_RANGE_ATTACK_AR2
			self.WeaponAnimTranslations[ACT_GESTURE_RANGE_ATTACK1] 			= ACT_GESTURE_RANGE_ATTACK_AR2
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1_LOW] 				= ACT_RANGE_ATTACK_AR2_LOW
			self.WeaponAnimTranslations[ACT_RELOAD] 						= VJ_SequenceToActivity(self, "reload_ar2")
			self.WeaponAnimTranslations[ACT_RELOAD_LOW] 					= ACT_RELOAD_SMG1_LOW
			
			self.WeaponAnimTranslations[ACT_IDLE] 							= VJ_PICK({VJ_SequenceToActivity(self, "idle_relaxed_ar2_1"), VJ_SequenceToActivity(self, "idle_alert_ar2_1"), VJ_SequenceToActivity(self, "idle_angry_ar2")})
			self.WeaponAnimTranslations[ACT_IDLE_ANGRY] 					= VJ_SequenceToActivity(self, "idle_ar2_aim")
			
			self.WeaponAnimTranslations[ACT_WALK] 							= VJ_PICK({VJ_SequenceToActivity(self, "walk_ar2_relaxed_all"), VJ_SequenceToActivity(self, "walkalerthold_ar2_all1"), VJ_SequenceToActivity(self, "walkholdall1_ar2")})
			self.WeaponAnimTranslations[ACT_WALK_AIM] 						= VJ_PICK({VJ_SequenceToActivity(self, "walkaimall1_ar2"), VJ_SequenceToActivity(self, "walkalertaim_ar2_all1")})
			self.WeaponAnimTranslations[ACT_WALK_CROUCH] 					= ACT_WALK_CROUCH_RPG
			self.WeaponAnimTranslations[ACT_WALK_CROUCH_AIM] 				= ACT_WALK_CROUCH_AIM_RIFLE
			
			self.WeaponAnimTranslations[ACT_RUN] 							= VJ_PICK({VJ_SequenceToActivity(self, "run_alert_holding_ar2_all"), VJ_SequenceToActivity(self, "run_ar2_relaxed_all"), VJ_SequenceToActivity(self, "run_holding_ar2_all")})
			self.WeaponAnimTranslations[ACT_RUN_AIM] 						= VJ_PICK({ACT_RUN_AIM_RIFLE, VJ_SequenceToActivity(self, "run_alert_aiming_ar2_all")})
			self.WeaponAnimTranslations[ACT_RUN_CROUCH] 					= ACT_RUN_CROUCH_RPG
			self.WeaponAnimTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_RUN_CROUCH_AIM_RIFLE
		elseif hType == "smg" then
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1] 					= ACT_RANGE_ATTACK_SMG1
			self.WeaponAnimTranslations[ACT_GESTURE_RANGE_ATTACK1] 			= ACT_GESTURE_RANGE_ATTACK_SMG1
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1_LOW] 				= ACT_RANGE_ATTACK_SMG1_LOW
			self.WeaponAnimTranslations[ACT_RELOAD] 						= ACT_RELOAD_SMG1
			self.WeaponAnimTranslations[ACT_RELOAD_LOW] 					= ACT_RELOAD_SMG1_LOW
			
			self.WeaponAnimTranslations[ACT_IDLE] 							= VJ_PICK({ACT_IDLE_SMG1_RELAXED, ACT_IDLE_SMG1_STIMULATED, ACT_IDLE_SMG1, VJ_SequenceToActivity(self, "idle_smg1_relaxed")})
			self.WeaponAnimTranslations[ACT_IDLE_ANGRY] 					= ACT_IDLE_ANGRY_SMG1
			
			self.WeaponAnimTranslations[ACT_WALK] 							= VJ_PICK({ACT_WALK_RIFLE, ACT_WALK_RIFLE_RELAXED, ACT_WALK_RIFLE_STIMULATED})
			self.WeaponAnimTranslations[ACT_WALK_AIM] 						= VJ_PICK({ACT_WALK_AIM_RIFLE, ACT_WALK_AIM_RIFLE_STIMULATED})
			self.WeaponAnimTranslations[ACT_WALK_CROUCH] 					= ACT_WALK_CROUCH_RIFLE
			self.WeaponAnimTranslations[ACT_WALK_CROUCH_AIM] 				= ACT_WALK_CROUCH_AIM_RIFLE
			
			self.WeaponAnimTranslations[ACT_RUN] 							= VJ_PICK({ACT_RUN_RIFLE, ACT_RUN_RIFLE_STIMULATED, ACT_RUN_RIFLE_RELAXED})
			self.WeaponAnimTranslations[ACT_RUN_AIM] 						= VJ_PICK({ACT_RUN_AIM_RIFLE, ACT_RUN_AIM_RIFLE_STIMULATED})
			self.WeaponAnimTranslations[ACT_RUN_CROUCH] 					= ACT_RUN_CROUCH_RIFLE
			self.WeaponAnimTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_RUN_CROUCH_AIM_RIFLE
		elseif hType == "crossbow" or hType == "shotgun" then
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1] 					= ACT_RANGE_ATTACK_SHOTGUN
			self.WeaponAnimTranslations[ACT_GESTURE_RANGE_ATTACK1] 			= ACT_GESTURE_RANGE_ATTACK_SHOTGUN
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1_LOW] 				= ACT_RANGE_ATTACK_SMG1_LOW
			self.WeaponAnimTranslations[ACT_RELOAD] 						= ACT_RELOAD_SHOTGUN
			self.WeaponAnimTranslations[ACT_RELOAD_LOW] 					= ACT_RELOAD_SMG1_LOW //ACT_RELOAD_SHOTGUN_LOW
			
			self.WeaponAnimTranslations[ACT_IDLE] 							= VJ_PICK({ACT_IDLE_SHOTGUN_RELAXED, ACT_IDLE_SHOTGUN_STIMULATED})
			self.WeaponAnimTranslations[ACT_IDLE_ANGRY] 					= VJ_SequenceToActivity(self, "idle_ar2_aim")
			
			self.WeaponAnimTranslations[ACT_WALK] 							= VJ_PICK({VJ_SequenceToActivity(self, "walk_ar2_relaxed_all"), VJ_SequenceToActivity(self, "walkalerthold_ar2_all1"), VJ_SequenceToActivity(self, "walkholdall1_ar2")})
			self.WeaponAnimTranslations[ACT_WALK_AIM] 						= VJ_PICK({VJ_SequenceToActivity(self, "walkaimall1_ar2"), VJ_SequenceToActivity(self, "walkalertaim_ar2_all1")})
			self.WeaponAnimTranslations[ACT_WALK_CROUCH] 					= ACT_WALK_CROUCH_RPG
			self.WeaponAnimTranslations[ACT_WALK_CROUCH_AIM] 				= ACT_WALK_CROUCH_AIM_RIFLE
			
			self.WeaponAnimTranslations[ACT_RUN] 							= VJ_PICK({VJ_SequenceToActivity(self, "run_alert_holding_ar2_all"), VJ_SequenceToActivity(self, "run_ar2_relaxed_all"), VJ_SequenceToActivity(self, "run_holding_ar2_all")})
			self.WeaponAnimTranslations[ACT_RUN_AIM] 						= VJ_PICK({ACT_RUN_AIM_RIFLE, VJ_SequenceToActivity(self, "run_alert_aiming_ar2_all")})
			self.WeaponAnimTranslations[ACT_RUN_CROUCH] 					= ACT_RUN_CROUCH_RPG
			self.WeaponAnimTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_RUN_CROUCH_AIM_RIFLE
		elseif hType == "rpg" then
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1] 					= ACT_RANGE_ATTACK_RPG
			self.WeaponAnimTranslations[ACT_GESTURE_RANGE_ATTACK1] 			= ACT_GESTURE_RANGE_ATTACK_RPG
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1_LOW] 				= ACT_RANGE_ATTACK_SMG1_LOW
			self.WeaponAnimTranslations[ACT_RELOAD] 						= ACT_RELOAD_SMG1
			self.WeaponAnimTranslations[ACT_RELOAD_LOW] 					= ACT_RELOAD_SMG1_LOW
			
			self.WeaponAnimTranslations[ACT_IDLE] 							= VJ_PICK({ACT_IDLE_RPG, ACT_IDLE_RPG_RELAXED})
			self.WeaponAnimTranslations[ACT_IDLE_ANGRY] 					= ACT_IDLE_ANGRY_RPG
			
			self.WeaponAnimTranslations[ACT_WALK] 							= VJ_PICK({ACT_WALK_RPG, ACT_WALK_RPG_RELAXED})
			self.WeaponAnimTranslations[ACT_WALK_AIM] 						= VJ_PICK({VJ_SequenceToActivity(self, "walkaimall1_ar2"), VJ_SequenceToActivity(self, "walkalertaim_ar2_all1")})
			self.WeaponAnimTranslations[ACT_WALK_CROUCH] 					= ACT_WALK_CROUCH_RPG
			self.WeaponAnimTranslations[ACT_WALK_CROUCH_AIM] 				= ACT_WALK_CROUCH_AIM_RIFLE
			
			self.WeaponAnimTranslations[ACT_RUN] 							= VJ_PICK({ACT_RUN_RPG, ACT_RUN_RPG_RELAXED})
			self.WeaponAnimTranslations[ACT_RUN_AIM] 						= VJ_PICK({ACT_RUN_AIM_RIFLE, VJ_SequenceToActivity(self, "run_alert_aiming_ar2_all")})
			self.WeaponAnimTranslations[ACT_RUN_CROUCH] 					= ACT_RUN_CROUCH_RPG
			self.WeaponAnimTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_RUN_CROUCH_AIM_RIFLE
		elseif hType == "pistol" or hType == "revolver" then
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1] 					= ACT_RANGE_ATTACK_PISTOL
			self.WeaponAnimTranslations[ACT_GESTURE_RANGE_ATTACK1] 			= ACT_GESTURE_RANGE_ATTACK_PISTOL
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1_LOW] 				= ACT_RANGE_ATTACK_PISTOL_LOW
			self.WeaponAnimTranslations[ACT_COVER_LOW] 						= {"crouchidle_panicked4", "vjseq_crouchidlehide"}
			self.WeaponAnimTranslations[ACT_RELOAD] 						= ACT_RELOAD_PISTOL
			self.WeaponAnimTranslations[ACT_RELOAD_LOW] 					= isFemale and ACT_RELOAD_SMG1_LOW or ACT_RELOAD_PISTOL_LOW -- Only males have covered pistol reload!
			
			self.WeaponAnimTranslations[ACT_IDLE] 							= ACT_IDLE_PISTOL
			self.WeaponAnimTranslations[ACT_IDLE_ANGRY] 					= isFemale and ACT_IDLE_ANGRY_PISTOL or VJ_SequenceToActivity(self, "idle_ar2_aim") -- Only females have angry pistol animation
			
			self.WeaponAnimTranslations[ACT_WALK] 							= ACT_WALK_PISTOL
			self.WeaponAnimTranslations[ACT_WALK_AIM] 						= VJ_PICK({VJ_SequenceToActivity(self, "walkaimall1_ar2"), VJ_SequenceToActivity(self, "walkalertaim_ar2_all1")})
			//self.WeaponAnimTranslations[ACT_WALK_CROUCH] 					= ACT_WALK_CROUCH_RIFLE -- No need to translate
			self.WeaponAnimTranslations[ACT_WALK_CROUCH_AIM] 				= ACT_WALK_CROUCH_AIM_RIFLE
			
			self.WeaponAnimTranslations[ACT_RUN] 							= ACT_RUN_PISTOL
			self.WeaponAnimTranslations[ACT_RUN_AIM] 						= VJ_SequenceToActivity(self, "run_alert_aiming_ar2_all")
			//self.WeaponAnimTranslations[ACT_RUN_CROUCH] 					= ACT_RUN_CROUCH_RIFLE -- No need to translate
			self.WeaponAnimTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_RUN_CROUCH_AIM_RIFLE
		elseif hType == "melee" or hType == "melee2" or hType == "knife" then
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1] 					= ACT_MELEE_ATTACK_SWING
			self.WeaponAnimTranslations[ACT_GESTURE_RANGE_ATTACK1] 			= false -- Don't play anything!
			//self.WeaponAnimTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_RANGE_ATTACK_SMG1_LOW -- Not used for melee
			self.WeaponAnimTranslations[ACT_COVER_LOW] 						= {"crouchidle_panicked4", "vjseq_crouchidlehide"}
			//self.WeaponAnimTranslations[ACT_RELOAD] 						= ACT_RELOAD_SMG1 -- Not used for melee
			//self.WeaponAnimTranslations[ACT_RELOAD_LOW] 					= ACT_RELOAD_SMG1_LOW -- Not used for melee
			
			self.WeaponAnimTranslations[ACT_IDLE] 							= ACT_IDLE
			self.WeaponAnimTranslations[ACT_IDLE_ANGRY] 					= ACT_IDLE_ANGRY_MELEE
			
			//self.WeaponAnimTranslations[ACT_WALK] 						= ACT_WALK -- No need to translate
			//self.WeaponAnimTranslations[ACT_WALK_AIM] 					= ACT_WALK_AIM_RIFLE -- Not used for melee
			//self.WeaponAnimTranslations[ACT_WALK_CROUCH] 					= ACT_WALK_CROUCH_RIFLE -- No need to translate
			//self.WeaponAnimTranslations[ACT_WALK_CROUCH_AIM] 				= ACT_WALK_CROUCH_AIM_RIFLE -- Not used for melee
			
			self.WeaponAnimTranslations[ACT_RUN] 							= VJ_SequenceToActivity(self, "run_all_panicked")
			//self.WeaponAnimTranslations[ACT_RUN_AIM] 						= ACT_RUN_AIM_RIFLE -- Not used for melee
			//self.WeaponAnimTranslations[ACT_RUN_CROUCH] 					= ACT_RUN_CROUCH_RIFLE -- No need to translate
			//self.WeaponAnimTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_RUN_CROUCH_AIM_RIFLE -- Not used for melee
		end
	elseif self.ModelAnimationSet == VJ_MODEL_ANIMSET_PLAYER then -- Player =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
		if hType == "ar2" then
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1] 					= ACT_HL2MP_IDLE_AR2
			self.WeaponAnimTranslations[ACT_GESTURE_RANGE_ATTACK1] 			= ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1_LOW] 				= ACT_HL2MP_IDLE_CROUCH_AR2
			self.WeaponAnimTranslations[ACT_RELOAD] 						= "vjges_reload_ar2"
			self.WeaponAnimTranslations[ACT_RELOAD_LOW] 					= "vjges_reload_ar2"
			self.WeaponAnimTranslations[ACT_COVER_LOW] 						= ACT_HL2MP_IDLE_CROUCH_AR2
			
			self.WeaponAnimTranslations[ACT_IDLE] 							= ACT_HL2MP_IDLE_PASSIVE
			self.WeaponAnimTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_AR2
			self.WeaponAnimTranslations[ACT_JUMP] 							= ACT_HL2MP_JUMP_AR2
			self.WeaponAnimTranslations[ACT_GLIDE] 							= ACT_HL2MP_JUMP_AR2
			self.WeaponAnimTranslations[ACT_LAND] 							= ACT_HL2MP_IDLE_AR2
			
			self.WeaponAnimTranslations[ACT_WALK] 							= ACT_HL2MP_WALK_PASSIVE
			self.WeaponAnimTranslations[ACT_WALK_AIM] 						= ACT_HL2MP_WALK_AR2
			self.WeaponAnimTranslations[ACT_WALK_CROUCH] 					= ACT_HL2MP_WALK_CROUCH_PASSIVE
			self.WeaponAnimTranslations[ACT_WALK_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_AR2
			
			self.WeaponAnimTranslations[ACT_RUN] 							= ACT_HL2MP_RUN_PASSIVE
			self.WeaponAnimTranslations[ACT_RUN_AIM] 						= ACT_HL2MP_RUN_AR2
			self.WeaponAnimTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH_PASSIVE
			self.WeaponAnimTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_AR2
		elseif hType == "pistol" then
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1] 					= ACT_HL2MP_IDLE_PISTOL
			self.WeaponAnimTranslations[ACT_GESTURE_RANGE_ATTACK1] 			= ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1_LOW] 				= ACT_HL2MP_IDLE_CROUCH_PISTOL
			self.WeaponAnimTranslations[ACT_RELOAD] 						= "vjges_reload_pistol"
			self.WeaponAnimTranslations[ACT_RELOAD_LOW] 					= "vjges_reload_pistol"
			self.WeaponAnimTranslations[ACT_COVER_LOW] 						= ACT_HL2MP_IDLE_CROUCH_PISTOL
			
			self.WeaponAnimTranslations[ACT_IDLE] 							= ACT_HL2MP_IDLE
			self.WeaponAnimTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_PISTOL
			self.WeaponAnimTranslations[ACT_JUMP] 							= ACT_HL2MP_JUMP_PISTOL
			self.WeaponAnimTranslations[ACT_GLIDE] 							= ACT_HL2MP_JUMP_PISTOL
			self.WeaponAnimTranslations[ACT_LAND] 							= ACT_HL2MP_IDLE_PISTOL
			
			self.WeaponAnimTranslations[ACT_WALK] 							= ACT_HL2MP_WALK
			self.WeaponAnimTranslations[ACT_WALK_AIM] 						= ACT_HL2MP_WALK_PISTOL
			self.WeaponAnimTranslations[ACT_WALK_CROUCH] 					= ACT_HL2MP_WALK_CROUCH
			self.WeaponAnimTranslations[ACT_WALK_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_PISTOL
			
			self.WeaponAnimTranslations[ACT_RUN] 							= ACT_HL2MP_RUN_FAST
			self.WeaponAnimTranslations[ACT_RUN_AIM] 						= ACT_HL2MP_RUN_PISTOL
			self.WeaponAnimTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH
			self.WeaponAnimTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_PISTOL
		elseif hType == "smg" then
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1] 					= ACT_HL2MP_IDLE_SMG1
			self.WeaponAnimTranslations[ACT_GESTURE_RANGE_ATTACK1] 			= ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1_LOW] 				= ACT_HL2MP_IDLE_CROUCH_SMG1
			self.WeaponAnimTranslations[ACT_RELOAD] 						= "vjges_reload_smg1"
			self.WeaponAnimTranslations[ACT_RELOAD_LOW] 					= "vjges_reload_smg1"
			self.WeaponAnimTranslations[ACT_COVER_LOW] 						= ACT_HL2MP_IDLE_CROUCH_SMG1
			
			self.WeaponAnimTranslations[ACT_IDLE] 							= ACT_HL2MP_IDLE_PASSIVE
			self.WeaponAnimTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_SMG1
			self.WeaponAnimTranslations[ACT_JUMP] 							= ACT_HL2MP_JUMP_SMG1
			self.WeaponAnimTranslations[ACT_GLIDE] 							= ACT_HL2MP_JUMP_SMG1
			self.WeaponAnimTranslations[ACT_LAND] 							= ACT_HL2MP_IDLE_SMG1
			
			self.WeaponAnimTranslations[ACT_WALK] 							= ACT_HL2MP_WALK_PASSIVE
			self.WeaponAnimTranslations[ACT_WALK_AIM] 						= ACT_HL2MP_WALK_SMG1
			self.WeaponAnimTranslations[ACT_WALK_CROUCH] 					= ACT_HL2MP_WALK_CROUCH_PASSIVE
			self.WeaponAnimTranslations[ACT_WALK_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_SMG1
			
			self.WeaponAnimTranslations[ACT_RUN] 							= ACT_HL2MP_RUN_PASSIVE
			self.WeaponAnimTranslations[ACT_RUN_AIM] 						= ACT_HL2MP_RUN_SMG1
			self.WeaponAnimTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH_PASSIVE
			self.WeaponAnimTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_SMG1
		elseif hType == "grenade" then
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1] 					= ACT_HL2MP_IDLE_GRENADE
			self.WeaponAnimTranslations[ACT_GESTURE_RANGE_ATTACK1] 			= ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1_LOW] 				= ACT_HL2MP_IDLE_CROUCH_GRENADE
			-- self.WeaponAnimTranslations[ACT_RELOAD] 						= "vjges_reload_pistol"
			-- self.WeaponAnimTranslations[ACT_RELOAD_LOW] 					= "vjges_reload_pistol"
			self.WeaponAnimTranslations[ACT_COVER_LOW] 						= ACT_HL2MP_IDLE_CROUCH_GRENADE
			
			self.WeaponAnimTranslations[ACT_IDLE] 							= ACT_HL2MP_IDLE
			self.WeaponAnimTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_GRENADE
			self.WeaponAnimTranslations[ACT_JUMP] 							= ACT_HL2MP_JUMP_GRENADE
			self.WeaponAnimTranslations[ACT_GLIDE] 							= ACT_HL2MP_JUMP_GRENADE
			self.WeaponAnimTranslations[ACT_LAND] 							= ACT_HL2MP_IDLE_GRENADE
			
			self.WeaponAnimTranslations[ACT_WALK] 							= ACT_HL2MP_WALK
			self.WeaponAnimTranslations[ACT_WALK_AIM] 						= ACT_HL2MP_WALK_GRENADE
			self.WeaponAnimTranslations[ACT_WALK_CROUCH] 					= ACT_HL2MP_WALK_CROUCH
			self.WeaponAnimTranslations[ACT_WALK_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_GRENADE
			
			self.WeaponAnimTranslations[ACT_RUN] 							= ACT_HL2MP_RUN
			self.WeaponAnimTranslations[ACT_RUN_AIM] 						= ACT_HL2MP_RUN_GRENADE
			self.WeaponAnimTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH
			self.WeaponAnimTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_GRENADE
		elseif hType == "shotgun" then
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1] 					= ACT_HL2MP_IDLE_SHOTGUN
			self.WeaponAnimTranslations[ACT_GESTURE_RANGE_ATTACK1] 			= ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1_LOW] 				= ACT_HL2MP_IDLE_CROUCH_SHOTGUN
			self.WeaponAnimTranslations[ACT_RELOAD] 						= "vjges_reload_shotgun"
			self.WeaponAnimTranslations[ACT_RELOAD_LOW] 					= "vjges_reload_shotgun"
			self.WeaponAnimTranslations[ACT_COVER_LOW] 						= ACT_HL2MP_IDLE_CROUCH_SHOTGUN
			
			self.WeaponAnimTranslations[ACT_IDLE] 							= ACT_HL2MP_IDLE_PASSIVE
			self.WeaponAnimTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_SHOTGUN
			self.WeaponAnimTranslations[ACT_JUMP] 							= ACT_HL2MP_JUMP_SHOTGUN
			self.WeaponAnimTranslations[ACT_GLIDE] 							= ACT_HL2MP_JUMP_SHOTGUN
			self.WeaponAnimTranslations[ACT_LAND] 							= ACT_HL2MP_IDLE_SHOTGUN
			
			self.WeaponAnimTranslations[ACT_WALK] 							= ACT_HL2MP_WALK_PASSIVE
			self.WeaponAnimTranslations[ACT_WALK_AIM] 						= ACT_HL2MP_WALK_SHOTGUN
			self.WeaponAnimTranslations[ACT_WALK_CROUCH] 					= ACT_HL2MP_WALK_CROUCH_PASSIVE
			self.WeaponAnimTranslations[ACT_WALK_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_SHOTGUN
			
			self.WeaponAnimTranslations[ACT_RUN] 							= ACT_HL2MP_RUN_PASSIVE
			self.WeaponAnimTranslations[ACT_RUN_AIM] 						= ACT_HL2MP_RUN_SHOTGUN
			self.WeaponAnimTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH_PASSIVE
			self.WeaponAnimTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_SHOTGUN
		elseif hType == "rpg" then
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1] 					= ACT_HL2MP_IDLE_RPG
			self.WeaponAnimTranslations[ACT_GESTURE_RANGE_ATTACK1] 			= ACT_HL2MP_GESTURE_RANGE_ATTACK_RPG
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1_LOW] 				= ACT_HL2MP_IDLE_CROUCH_RPG
			self.WeaponAnimTranslations[ACT_RELOAD] 						= "vjges_reload_ar2"
			self.WeaponAnimTranslations[ACT_RELOAD_LOW] 					= "vjges_reload_ar2"
			self.WeaponAnimTranslations[ACT_COVER_LOW] 						= ACT_HL2MP_IDLE_CROUCH_RPG
			
			self.WeaponAnimTranslations[ACT_IDLE] 							= ACT_HL2MP_IDLE_PASSIVE
			self.WeaponAnimTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_RPG
			self.WeaponAnimTranslations[ACT_JUMP] 							= ACT_HL2MP_JUMP_RPG
			self.WeaponAnimTranslations[ACT_GLIDE] 							= ACT_HL2MP_JUMP_RPG
			self.WeaponAnimTranslations[ACT_LAND] 							= ACT_HL2MP_IDLE_RPG
			
			self.WeaponAnimTranslations[ACT_WALK] 							= ACT_HL2MP_WALK_PASSIVE
			self.WeaponAnimTranslations[ACT_WALK_AIM] 						= ACT_HL2MP_WALK_RPG
			self.WeaponAnimTranslations[ACT_WALK_CROUCH] 					= ACT_HL2MP_WALK_CROUCH_PASSIVE
			self.WeaponAnimTranslations[ACT_WALK_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_RPG
			
			self.WeaponAnimTranslations[ACT_RUN] 							= ACT_HL2MP_RUN_PASSIVE
			self.WeaponAnimTranslations[ACT_RUN_AIM] 						= ACT_HL2MP_RUN_RPG
			self.WeaponAnimTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH_PASSIVE
			self.WeaponAnimTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_RPG
		elseif hType == "physgun" then
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1] 					= ACT_HL2MP_IDLE_PHYSGUN
			self.WeaponAnimTranslations[ACT_GESTURE_RANGE_ATTACK1] 			= ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1_LOW] 				= ACT_HL2MP_IDLE_CROUCH_PHYSGUN
			self.WeaponAnimTranslations[ACT_RELOAD] 						= "vjges_reload_ar2"
			self.WeaponAnimTranslations[ACT_RELOAD_LOW] 					= "vjges_reload_ar2"
			self.WeaponAnimTranslations[ACT_COVER_LOW] 						= ACT_HL2MP_IDLE_CROUCH_PHYSGUN
			
			self.WeaponAnimTranslations[ACT_IDLE] 							= ACT_HL2MP_IDLE_PASSIVE
			self.WeaponAnimTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_PHYSGUN
			self.WeaponAnimTranslations[ACT_JUMP] 							= ACT_HL2MP_JUMP_PHYSGUN
			self.WeaponAnimTranslations[ACT_GLIDE] 							= ACT_HL2MP_JUMP_PHYSGUN
			self.WeaponAnimTranslations[ACT_LAND] 							= ACT_HL2MP_IDLE_PHYSGUN
			
			self.WeaponAnimTranslations[ACT_WALK] 							= ACT_HL2MP_WALK_PASSIVE
			self.WeaponAnimTranslations[ACT_WALK_AIM] 						= ACT_HL2MP_WALK_PHYSGUN
			self.WeaponAnimTranslations[ACT_WALK_CROUCH] 					= ACT_HL2MP_WALK_CROUCH_PASSIVE
			self.WeaponAnimTranslations[ACT_WALK_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_PHYSGUN
			
			self.WeaponAnimTranslations[ACT_RUN] 							= ACT_HL2MP_RUN_PASSIVE
			self.WeaponAnimTranslations[ACT_RUN_AIM] 						= ACT_HL2MP_RUN_PHYSGUN
			self.WeaponAnimTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH_PASSIVE
			self.WeaponAnimTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_PHYSGUN
		elseif hType == "crossbow" then
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1] 					= ACT_HL2MP_IDLE_CROSSBOW
			self.WeaponAnimTranslations[ACT_GESTURE_RANGE_ATTACK1] 			= ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1_LOW] 				= ACT_HL2MP_IDLE_CROUCH_CROSSBOW
			self.WeaponAnimTranslations[ACT_RELOAD] 						= "vjges_reload_ar2"
			self.WeaponAnimTranslations[ACT_RELOAD_LOW] 					= "vjges_reload_ar2"
			self.WeaponAnimTranslations[ACT_COVER_LOW] 						= ACT_HL2MP_IDLE_CROUCH_CROSSBOW
			
			self.WeaponAnimTranslations[ACT_IDLE] 							= ACT_HL2MP_IDLE_PASSIVE
			self.WeaponAnimTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_CROSSBOW
			self.WeaponAnimTranslations[ACT_JUMP] 							= ACT_HL2MP_JUMP_CROSSBOW
			self.WeaponAnimTranslations[ACT_GLIDE] 							= ACT_HL2MP_JUMP_CROSSBOW
			self.WeaponAnimTranslations[ACT_LAND] 							= ACT_HL2MP_IDLE_CROSSBOW
			
			self.WeaponAnimTranslations[ACT_WALK] 							= ACT_HL2MP_WALK_PASSIVE
			self.WeaponAnimTranslations[ACT_WALK_AIM] 						= ACT_HL2MP_WALK_CROSSBOW
			self.WeaponAnimTranslations[ACT_WALK_CROUCH] 					= ACT_HL2MP_WALK_CROUCH_PASSIVE
			self.WeaponAnimTranslations[ACT_WALK_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_CROSSBOW
			
			self.WeaponAnimTranslations[ACT_RUN] 							= ACT_HL2MP_RUN_PASSIVE
			self.WeaponAnimTranslations[ACT_RUN_AIM] 						= ACT_HL2MP_RUN_CROSSBOW
			self.WeaponAnimTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH_PASSIVE
			self.WeaponAnimTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_CROSSBOW
		elseif hType == "slam" then
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1] 					= ACT_HL2MP_IDLE_SLAM
			self.WeaponAnimTranslations[ACT_GESTURE_RANGE_ATTACK1] 			= ACT_HL2MP_GESTURE_RANGE_ATTACK_SLAM
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1_LOW] 				= ACT_HL2MP_IDLE_CROUCH_SLAM
			-- self.WeaponAnimTranslations[ACT_RELOAD] 						= "vjges_reload_pistol"
			-- self.WeaponAnimTranslations[ACT_RELOAD_LOW] 					= "vjges_reload_pistol"
			self.WeaponAnimTranslations[ACT_COVER_LOW] 						= ACT_HL2MP_IDLE_CROUCH_SLAM
			
			self.WeaponAnimTranslations[ACT_IDLE] 							= ACT_HL2MP_IDLE
			self.WeaponAnimTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_SLAM
			self.WeaponAnimTranslations[ACT_JUMP] 							= ACT_HL2MP_JUMP_SLAM
			self.WeaponAnimTranslations[ACT_GLIDE] 							= ACT_HL2MP_JUMP_SLAM
			self.WeaponAnimTranslations[ACT_LAND] 							= ACT_HL2MP_IDLE_SLAM
			
			self.WeaponAnimTranslations[ACT_WALK] 							= ACT_HL2MP_WALK
			self.WeaponAnimTranslations[ACT_WALK_AIM] 						= ACT_HL2MP_WALK_SLAM
			self.WeaponAnimTranslations[ACT_WALK_CROUCH] 					= ACT_HL2MP_WALK_CROUCH
			self.WeaponAnimTranslations[ACT_WALK_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_SLAM
			
			self.WeaponAnimTranslations[ACT_RUN] 							= ACT_HL2MP_RUN
			self.WeaponAnimTranslations[ACT_RUN_AIM] 						= ACT_HL2MP_RUN_SLAM
			self.WeaponAnimTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH
			self.WeaponAnimTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_SLAM
		elseif hType == "duel" then
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1] 					= ACT_HL2MP_IDLE_DUEL
			self.WeaponAnimTranslations[ACT_GESTURE_RANGE_ATTACK1] 			= ACT_HL2MP_GESTURE_RANGE_ATTACK_DUEL
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1_LOW] 				= ACT_HL2MP_IDLE_CROUCH_DUEL
			self.WeaponAnimTranslations[ACT_RELOAD] 						= "vjges_reload_duel"
			self.WeaponAnimTranslations[ACT_RELOAD_LOW] 					= "vjges_reload_duel"
			self.WeaponAnimTranslations[ACT_COVER_LOW] 						= ACT_HL2MP_IDLE_CROUCH_DUEL
			
			self.WeaponAnimTranslations[ACT_IDLE] 							= ACT_HL2MP_IDLE
			self.WeaponAnimTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_DUEL
			self.WeaponAnimTranslations[ACT_JUMP] 							= ACT_HL2MP_JUMP_DUEL
			self.WeaponAnimTranslations[ACT_GLIDE] 							= ACT_HL2MP_JUMP_DUEL
			self.WeaponAnimTranslations[ACT_LAND] 							= ACT_HL2MP_IDLE_DUEL
			
			self.WeaponAnimTranslations[ACT_WALK] 							= ACT_HL2MP_WALK
			self.WeaponAnimTranslations[ACT_WALK_AIM] 						= ACT_HL2MP_WALK_DUEL
			self.WeaponAnimTranslations[ACT_WALK_CROUCH] 					= ACT_HL2MP_WALK_CROUCH
			self.WeaponAnimTranslations[ACT_WALK_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_DUEL
			
			self.WeaponAnimTranslations[ACT_RUN] 							= ACT_HL2MP_RUN
			self.WeaponAnimTranslations[ACT_RUN_AIM] 						= ACT_HL2MP_RUN_DUEL
			self.WeaponAnimTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH
			self.WeaponAnimTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_DUEL
		elseif hType == "revolver" then
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1] 					= ACT_HL2MP_IDLE_REVOLVER
			self.WeaponAnimTranslations[ACT_GESTURE_RANGE_ATTACK1] 			= ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1_LOW] 				= ACT_HL2MP_IDLE_CROUCH_REVOLVER
			self.WeaponAnimTranslations[ACT_RELOAD] 						= "vjges_reload_revolver"
			self.WeaponAnimTranslations[ACT_RELOAD_LOW] 					= "vjges_reload_revolver"
			self.WeaponAnimTranslations[ACT_COVER_LOW] 						= ACT_HL2MP_IDLE_CROUCH_REVOLVER
			
			self.WeaponAnimTranslations[ACT_IDLE] 							= ACT_HL2MP_IDLE
			self.WeaponAnimTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_REVOLVER
			self.WeaponAnimTranslations[ACT_JUMP] 							= ACT_HL2MP_JUMP_REVOLVER
			self.WeaponAnimTranslations[ACT_GLIDE] 							= ACT_HL2MP_JUMP_REVOLVER
			self.WeaponAnimTranslations[ACT_LAND] 							= ACT_HL2MP_IDLE_REVOLVER
			
			self.WeaponAnimTranslations[ACT_WALK] 							= ACT_HL2MP_WALK
			self.WeaponAnimTranslations[ACT_WALK_AIM] 						= ACT_HL2MP_WALK_REVOLVER
			self.WeaponAnimTranslations[ACT_WALK_CROUCH] 					= ACT_HL2MP_WALK_CROUCH
			self.WeaponAnimTranslations[ACT_WALK_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_REVOLVER
			
			self.WeaponAnimTranslations[ACT_RUN] 							= ACT_HL2MP_RUN
			self.WeaponAnimTranslations[ACT_RUN_AIM] 						= ACT_HL2MP_RUN_REVOLVER
			self.WeaponAnimTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH
			self.WeaponAnimTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_REVOLVER
		elseif hType == "melee" then
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1] 					= ACT_HL2MP_IDLE_MELEE
			self.WeaponAnimTranslations[ACT_GESTURE_RANGE_ATTACK1] 			= ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1_LOW] 				= ACT_HL2MP_IDLE_CROUCH_MELEE
			-- self.WeaponAnimTranslations[ACT_RELOAD] 						= "vjges_reload_pistol"
			-- self.WeaponAnimTranslations[ACT_RELOAD_LOW] 					= "vjges_reload_pistol"
			self.WeaponAnimTranslations[ACT_COVER_LOW] 						= ACT_HL2MP_IDLE_CROUCH_MELEE
			
			self.WeaponAnimTranslations[ACT_IDLE] 							= ACT_HL2MP_IDLE
			self.WeaponAnimTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_MELEE
			self.WeaponAnimTranslations[ACT_JUMP] 							= ACT_HL2MP_JUMP_MELEE
			self.WeaponAnimTranslations[ACT_GLIDE] 							= ACT_HL2MP_JUMP_MELEE
			self.WeaponAnimTranslations[ACT_LAND] 							= ACT_HL2MP_IDLE_MELEE
			
			self.WeaponAnimTranslations[ACT_WALK] 							= ACT_HL2MP_WALK
			self.WeaponAnimTranslations[ACT_WALK_AIM] 						= ACT_HL2MP_WALK_MELEE
			self.WeaponAnimTranslations[ACT_WALK_CROUCH] 					= ACT_HL2MP_WALK_CROUCH
			self.WeaponAnimTranslations[ACT_WALK_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_MELEE
			
			self.WeaponAnimTranslations[ACT_RUN] 							= ACT_HL2MP_RUN
			self.WeaponAnimTranslations[ACT_RUN_AIM] 						= ACT_HL2MP_RUN_MELEE
			self.WeaponAnimTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH
			self.WeaponAnimTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_MELEE
		elseif hType == "melee2" then
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1] 					= ACT_HL2MP_IDLE_MELEE2
			self.WeaponAnimTranslations[ACT_GESTURE_RANGE_ATTACK1] 			= ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1_LOW] 				= ACT_HL2MP_IDLE_CROUCH_MELEE2
			-- self.WeaponAnimTranslations[ACT_RELOAD] 						= "vjges_reload_pistol"
			-- self.WeaponAnimTranslations[ACT_RELOAD_LOW] 					= "vjges_reload_pistol"
			self.WeaponAnimTranslations[ACT_COVER_LOW] 						= ACT_HL2MP_IDLE_CROUCH_MELEE2
			
			self.WeaponAnimTranslations[ACT_IDLE] 							= ACT_HL2MP_IDLE
			self.WeaponAnimTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_MELEE2
			self.WeaponAnimTranslations[ACT_JUMP] 							= ACT_HL2MP_JUMP_MELEE2
			self.WeaponAnimTranslations[ACT_GLIDE] 							= ACT_HL2MP_JUMP_MELEE2
			self.WeaponAnimTranslations[ACT_LAND] 							= ACT_HL2MP_IDLE_MELEE2
			
			self.WeaponAnimTranslations[ACT_WALK] 							= ACT_HL2MP_WALK
			self.WeaponAnimTranslations[ACT_WALK_AIM] 						= ACT_HL2MP_WALK_MELEE2
			self.WeaponAnimTranslations[ACT_WALK_CROUCH] 					= ACT_HL2MP_WALK_CROUCH
			self.WeaponAnimTranslations[ACT_WALK_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_MELEE2
			
			self.WeaponAnimTranslations[ACT_RUN] 							= ACT_HL2MP_RUN
			self.WeaponAnimTranslations[ACT_RUN_AIM] 						= ACT_HL2MP_RUN_MELEE2
			self.WeaponAnimTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH
			self.WeaponAnimTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_MELEE2
		elseif hType == "knife" then
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1] 					= ACT_HL2MP_IDLE_KNIFE
			self.WeaponAnimTranslations[ACT_GESTURE_RANGE_ATTACK1] 			= ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1_LOW] 				= ACT_HL2MP_IDLE_CROUCH_KNIFE
			-- self.WeaponAnimTranslations[ACT_RELOAD] 						= "vjges_reload_pistol"
			-- self.WeaponAnimTranslations[ACT_RELOAD_LOW] 					= "vjges_reload_pistol"
			self.WeaponAnimTranslations[ACT_COVER_LOW] 						= ACT_HL2MP_IDLE_CROUCH_KNIFE
			
			self.WeaponAnimTranslations[ACT_IDLE] 							= ACT_HL2MP_IDLE
			self.WeaponAnimTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_KNIFE
			self.WeaponAnimTranslations[ACT_JUMP] 							= ACT_HL2MP_JUMP_KNIFE
			self.WeaponAnimTranslations[ACT_GLIDE] 							= ACT_HL2MP_JUMP_KNIFE
			self.WeaponAnimTranslations[ACT_LAND] 							= ACT_HL2MP_IDLE_KNIFE
			
			self.WeaponAnimTranslations[ACT_WALK] 							= ACT_HL2MP_WALK
			self.WeaponAnimTranslations[ACT_WALK_AIM] 						= ACT_HL2MP_WALK_KNIFE
			self.WeaponAnimTranslations[ACT_WALK_CROUCH] 					= ACT_HL2MP_WALK_CROUCH
			self.WeaponAnimTranslations[ACT_WALK_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_KNIFE
			
			self.WeaponAnimTranslations[ACT_RUN] 							= ACT_HL2MP_RUN
			self.WeaponAnimTranslations[ACT_RUN_AIM] 						= ACT_HL2MP_RUN_KNIFE
			self.WeaponAnimTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH
			self.WeaponAnimTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_KNIFE
		elseif hType == "camera" then
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1] 					= ACT_HL2MP_IDLE_CAMERA
			-- self.WeaponAnimTranslations[ACT_GESTURE_RANGE_ATTACK1] 			= ACT_HL2MP_GESTURE_RANGE_ATTACK_CAMERA
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1_LOW] 				= ACT_HL2MP_IDLE_CROUCH_CAMERA
			-- self.WeaponAnimTranslations[ACT_RELOAD] 						= "vjges_reload_pistol"
			-- self.WeaponAnimTranslations[ACT_RELOAD_LOW] 					= "vjges_reload_pistol"
			self.WeaponAnimTranslations[ACT_COVER_LOW] 						= ACT_HL2MP_IDLE_CROUCH_CAMERA
			
			self.WeaponAnimTranslations[ACT_IDLE] 							= ACT_HL2MP_IDLE
			self.WeaponAnimTranslations[ACT_IDLE_ANGRY] 					= ACT_HL2MP_IDLE_CAMERA
			self.WeaponAnimTranslations[ACT_JUMP] 							= ACT_HL2MP_JUMP_CAMERA
			self.WeaponAnimTranslations[ACT_GLIDE] 							= ACT_HL2MP_JUMP_CAMERA
			self.WeaponAnimTranslations[ACT_LAND] 							= ACT_HL2MP_IDLE_CAMERA
			
			self.WeaponAnimTranslations[ACT_WALK] 							= ACT_HL2MP_WALK
			self.WeaponAnimTranslations[ACT_WALK_AIM] 						= ACT_HL2MP_WALK_CAMERA
			self.WeaponAnimTranslations[ACT_WALK_CROUCH] 					= ACT_HL2MP_WALK_CROUCH
			self.WeaponAnimTranslations[ACT_WALK_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_CAMERA
			
			self.WeaponAnimTranslations[ACT_RUN] 							= ACT_HL2MP_RUN
			self.WeaponAnimTranslations[ACT_RUN_AIM] 						= ACT_HL2MP_RUN_CAMERA
			self.WeaponAnimTranslations[ACT_RUN_CROUCH] 					= ACT_HL2MP_WALK_CROUCH
			self.WeaponAnimTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_HL2MP_WALK_CROUCH_CAMERA
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateToWeaponAnim(act)
	local translate = self.WeaponAnimTranslations[act]
	if translate == nil then -- If no animation found, then just return the given activity
		return act
	else -- Found an animation!
		return VJ_PICK(translate)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local sdWepSwitch = {"physics/metal/weapon_impact_soft1.wav","physics/metal/weapon_impact_soft2.wav","physics/metal/weapon_impact_soft3.wav"}
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
			VJ_EmitSound(self, sdWepSwitch, 70)
			curWep = wep
		else
			if IsValid(curWep) && self.WeaponInventoryStatus <= VJ_WEP_INVENTORY_PRIMARY then
				curWep:Remove()
			end
			curWep = self:Give(wep)
			self.WeaponInventory.Primary = curWep
		end
	end
	
	-- If we are given a new weapon or switching weapon, then do all of the necessary set up
	if IsValid(curWep) then
		self.CurrentWeaponAnimation = -1
		self:SetWeaponState() -- Reset the weapon state because we do NOT want previous weapon's state to be used!
		if invSwitch then
			if curWep.IsVJBaseWeapon then curWep:Equip(self) end
		else -- If we are not switching weapons, then we know curWep is the primary weapon
			self.WeaponInventoryStatus = VJ_WEP_INVENTORY_PRIMARY
			-- If this is completely new weapon, then set the weapon inventory's primary to this weapon
			local curPrimary = self.WeaponInventory.Primary
			if curWep != self.WeaponInventory.Primary then
				if IsValid(curPrimary) then curPrimary:Remove() end -- Remove the old primary weapon
				self.WeaponInventory.Primary = curWep
			end
		end
		self:SetupWeaponHoldTypeAnims(curWep:GetHoldType())
		self:CustomOnDoChangeWeapon(curWep, self.CurrentWeaponEntity, invSwitch)
		self.CurrentWeaponEntity = curWep
	else
		self.WeaponInventoryStatus = VJ_WEP_INVENTORY_NONE
	end
	return curWep
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetWeaponState(state, time)
	time = time or -1
	self.WeaponState = state or VJ_WEP_STATE_READY
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
//function ENT:OnActiveWeaponChanged(old, new) print(old, new) end
---------------------------------------------------------------------------------------------------------------------------------------------
/* Variable Notes:
	m_flMoveWaitFinished = Current move and wait time, used for things like when opening doors and have to stop for a second
	m_hOpeningDoor = The door entity it's opening
	m_vDefaultEyeOffset = The eye position, it's very close to self:EyePos()
	m_flTimeEnemyAcquired = Every time setenemy is called (including NULL!)  -->  print(math.abs(self:GetInternalVariable("m_flTimeEnemyAcquired")))
	m_flGroundChangeTime = Time since it touched the ground (Must be from high place)
	m_bSequenceFinished = Is it playing a animation?
	m_vecLean = How much it's leaning (ex: Drag around with physgun)
	m_flAnimTime = Changes the self:GetAnimTimeInterval()
	m_bIsMoving = Same as self:IsMoving()
	m_flLastEventCheck = Cycle index of when events were last checked
	m_flGroundSpeed = Computed linear movement rate for current sequence
	m_flOriginalYaw = This is the direction facing when the level designer placed the NPC in the level.
	m_spawnEquipment = Class name of the weapon it spawned with, stays even when weapon is removed or another weapon from its inventory is used!
	m_takedamage = Defines how it can take damage
		#define	DAMAGE_NO				0
		#define DAMAGE_EVENTS_ONLY		1		// Call damage functions, but don't modify health
		#define	DAMAGE_YES				2
		#define	DAMAGE_AIM				3
	m_nWaterType = Type of water the entity is in --> 1 = water, 2 = slime
	
	-- Following is just used for the face and eye looking:
	m_hLookTarget = The entity it's looking at
	m_flNextRandomLookTime = Next time it can look at something (Can be used to set it as well)
	m_flEyeIntegRate = How fast the eyes move
	m_viewtarget = Returns the position the NPC's eye pupils are looking at (Can be used to set it as well)
	m_flBlinktime = Time until it blinks again (Can be used to set it as well)
	
	-- Change movement speed:
	self:SetLocalVelocity(self:GetMoveVelocity() * 1.5)
	
	-- To test sound hints:
	local test = getSdHint(bit.bor(SOUND_DANGER, SOUND_CONTEXT_PLAYER_VEHICLE), self:GetPos())
	if istable(test) then
		print("---------------------")
		print(test.origin:Distance(self:GetPos()))
		PrintTable(test)
	end
*/
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	//PrintTable(self:GetAnimInfo(self:GetActivity()))
	//self:MoveStop()
	//self:ResetMoveCalc()
	//print("---------------------")
	//PrintTable(self:GetSaveTable())
	//print(self:GetInternalVariable("m_flFieldOfView"))
	//print(self:GetInternalVariable("m_flMoveWaitFinished") - CurTime())
	//self:SetSaveValue("m_flMoveWaitFinished", CurTime() + 2)
	self:SetCondition(1) -- Fix attachments, bones, positions, angles etc. being broken in NPCs! This condition is used as a backup in case sv_pvsskipanimation isn't disabled!
	
	//if self.CurrentSchedule != nil then PrintTable(self.CurrentSchedule) end
	//if self.CurrentTask != nil then PrintTable(self.CurrentTask) end
	if self.MovementType == VJ_MOVETYPE_GROUND && self:GetVelocity():Length() <= 0 && !self:IsEFlagSet(EFL_IS_BEING_LIFTED_BY_BARNACLE) /*&& curSched.IsMovingTask == true*/ then self:DropToFloor() end

	local curSched = self.CurrentSchedule
	if curSched != nil then
		if self:IsMoving() then
			if curSched.MoveType == 0 && !VJ_HasValue(self.AnimTbl_Walk, self:GetMovementActivity()) then
				self:SetMovementActivity(VJ_PICK(self.AnimTbl_Walk))
			elseif curSched.MoveType == 1 && !VJ_HasValue(self.AnimTbl_Run, self:GetMovementActivity()) then
				self:SetMovementActivity(VJ_PICK(self.AnimTbl_Run))
			end
		end
		local blockingEnt = self:GetBlockingEntity()
		-- No longer needed as the engine now does detects and opens the doors
		//if self.CanOpenDoors && IsValid(blockingEnt) && (blockingEnt:GetClass() == "func_door" or blockingEnt:GetClass() == "func_door_rotating") && (blockingEnt:HasSpawnFlags(256) or blockingEnt:HasSpawnFlags(1024)) && !blockingEnt:HasSpawnFlags(512) then
			//blockingEnt:Fire("Open")
		//end
		if (curSched.StopScheduleIfNotMoving == true or curSched.StopScheduleIfNotMoving_Any == true) && (!self:IsMoving() or (IsValid(blockingEnt) && (blockingEnt:IsNPC() or curSched.StopScheduleIfNotMoving_Any == true))) then // (self:GetGroundSpeedVelocity():Length() <= 0) == true
			self:ScheduleFinished(curSched)
			//self:SetCondition(COND_TASK_FAILED)
			//self:StopMoving()
		end
		-- self:OnMovementFailed() handles some of them, but we do still need this for non-movement failures (EX: Finding cover area)
		if self:HasCondition(COND_TASK_FAILED) then
			//print("VJ Base: Task Failed Condition Identified! "..self:GetName())
			if self:DoRunCode_OnFail(curSched) == true then
				self:ClearCondition(COND_TASK_FAILED)
			end
			if curSched.ResetOnFail == true then
				self:ClearCondition(COND_TASK_FAILED)
				self:StopMoving()
				//self:SelectSchedule()
			end
		end
	end
	
	//print("------------------")
	//print(self:GetActiveWeapon())
	//PrintTable(self:GetWeapons())
	if self.DoingWeaponAttack == false then self.DoingWeaponAttack_Standing = false end
	if self.CurrentWeaponEntity != self:GetActiveWeapon() then self.CurrentWeaponEntity = self:DoChangeWeapon() end
	
	self:CustomOnThink()
	
	local curTime = CurTime()
	
	if !self.Dead && self.HasBreathSound && self.HasSounds && curTime > self.NextBreathSoundT then
		local sdtbl = VJ_PICK(self.SoundTbl_Breath)
		local dur = 1
		if sdtbl != false then
			VJ_STOPSOUND(self.CurrentBreathSound)
			dur = (self.NextSoundTime_Breath == true and SoundDuration(sdtbl)) or math.Rand(self.NextSoundTime_Breath.a, self.NextSoundTime_Breath.b)
			self.CurrentBreathSound = VJ_CreateSound(self, sdtbl, self.BreathSoundLevel, self:VJ_DecideSoundPitch(self.BreathSoundPitch.a, self.BreathSoundPitch.b))
		end
		self.NextBreathSoundT = curTime + dur
	end
	--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
	if GetConVar("ai_disabled"):GetInt() == 0 && self:GetState() != VJ_STATE_FREEZE && !self:IsEFlagSet(EFL_IS_BEING_LIFTED_BY_BARNACLE) then
		if self.VJDEBUG_SNPC_ENABLED == true then
			if GetConVar("vj_npc_printcurenemy"):GetInt() == 1 then print(self:GetClass().."'s Enemy: ",self:GetEnemy()," Alerted? ",self.Alerted) end
			if GetConVar("vj_npc_printtakingcover"):GetInt() == 1 then if curTime > self.TakingCoverT == true then print(self:GetClass().." Is Not Taking Cover") else print(self:GetClass().." Is Taking Cover ("..self.TakingCoverT-curTime..")") end end
			if GetConVar("vj_npc_printlastseenenemy"):GetInt() == 1 then PrintMessage(HUD_PRINTTALK, (curTime - self.LastEnemyVisibleTime).." ("..self:GetName()..")") end
			if IsValid(self.CurrentWeaponEntity) && GetConVar("vj_npc_dev_printwepinfo"):GetInt() == 1 then print(self:GetName().." -->", self.CurrentWeaponEntity, "Ammo: "..self.CurrentWeaponEntity:Clip1().."/"..self.CurrentWeaponEntity:GetMaxClip1().." | Accuracy: "..self.WeaponSpread) end
		end
		
		self:SetPlaybackRate(self.AnimationPlaybackRate)
		if self:GetArrivalActivity() == -1 then
			self:SetArrivalActivity(self.CurrentAnim_IdleStand)
		end

		if self.UsePlayerModelMovement == true && self.MovementType == VJ_MOVETYPE_GROUND then
			local moveDir = self:GetMoveDirection(true)
			if moveDir != defPos then
				self:SetPoseParameter("move_x", moveDir.x)
				self:SetPoseParameter("move_y", moveDir.y)
				if curSched != nil && !curSched.ConstantlyFaceEnemy then
					self:FaceCertainPosition(self:GetCurWaypointPos())
				end
			end
		end
		
		self:CustomOnThink_AIEnabled()
		
		if self.DisableFootStepSoundTimer == false then self:FootStepSoundCode() end
		
		-- Update follow system's data
		//print("------------------")
		//PrintTable(self.FollowData)
		if self.IsFollowing == true then
			local followData = self.FollowData
			local followEnt = followData.Ent
			local followIsLiving = followData.IsLiving
			//print(self:GetTarget())
			if IsValid(followEnt) && (!followIsLiving or (followIsLiving && (self:Disposition(followEnt) == D_LI or self:GetClass() == followEnt:GetClass()) && VJ_IsAlive(followEnt))) then
				if curTime > self.NextFollowUpdateT && !self.VJTags[VJ_TAG_HEALING] then
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
							-- If we are close then walk otherwise run
							self:VJ_TASK_GOTO_TARGET((distToPly < (followData.MinDist * 1.5) and "TASK_WALK_PATH") or "TASK_RUN_PATH", function(x)
								x.CanShootWhenMoving = true
								x.ConstantlyFaceEnemyVisible = (IsValid(self:GetActiveWeapon()) and true) or false
							end)
						end
					elseif followData.Moving == true then -- Entity is very close, stop moving!
						if !busy then -- If not busy then make it stop moving and do something
							self:StopMoving()
							self:SelectSchedule()
						end
						followData.Moving = false
					end
					self.NextFollowUpdateT = curTime + self.NextFollowUpdateTime
				end
			else
				self:FollowReset()
			end
		end
		
		//print("MAX CLIP: ", self.CurrentWeaponEntity:GetMaxClip1())
		//print("CLIP: ", self.CurrentWeaponEntity:Clip1())

		-- Turn to the current face position or entity
		if self.FacingStatus == VJ_FACING_POSITION then
			local faceAng = self.FacingData
			if self.TurningUseAllAxis == true then
				local myAngs = self:GetAngles()
				self:SetAngles(LerpAngle(FrameTime()*self.TurningSpeed, myAngs, Angle(faceAng.p, myAngs.y, faceAng.r)))
			end
			self:SetIdealYawAndUpdate(faceAng.y)
		elseif self.FacingStatus == VJ_FACING_ENTITY then
			local faceEnt = self.FacingData
			if IsValid(faceEnt) then
				local faceAng = self:GetFaceAngle((faceEnt:GetPos() - self:GetPos()):Angle())
				if self.TurningUseAllAxis == true then
					local myAngs = self:GetAngles()
					self:SetAngles(LerpAngle(FrameTime()*self.TurningSpeed, myAngs, Angle(faceAng.p, myAngs.y, faceAng.r)))
				end
				self:SetIdealYawAndUpdate(faceAng.y)
			end
		end
		
		/*VJ_CreateTestObject(self:GetEnemyLastSeenPos())
		print(self:HasEnemyMemory())
		print(curTime - self:GetEnemyLastTimeSeen())
		print(curTime - self:GetEnemyFirstTimeSeen())*/
			
		if self.Dead == false then
			-- Health Regeneration System
			if self.HasHealthRegeneration == true && curTime > self.HealthRegenerationDelayT then
				local myHP = self:Health()
				self:SetHealth(math_clamp(myHP + self.HealthRegenerationAmount, myHP, self:GetMaxHealth()))
				self.HealthRegenerationDelayT = curTime + math.Rand(self.HealthRegenerationDelay.a, self.HealthRegenerationDelay.b)
			end
			
			-- Run the heavy processes
			if curTime > self.NextProcessT then
				self:DoEntityRelationshipCheck()
				self:CheckForDangers()
				self:DoMedicCheck()
				self.NextProcessT = curTime + self.NextProcessTime
			end
			
			local plyControlled = self.VJ_IsBeingControlled
			local myPos = self:GetPos()
			local ene = self:GetEnemy()
			local eneValid = IsValid(ene)
			if self.EnemyReset == false then
				-- Reset enemy if it doesn't exist or it's dead
				if (!eneValid) or (eneValid && ene:Health() <= 0) then
					self.EnemyReset = true
					self:ResetEnemy(true)
					ene = self:GetEnemy()
					eneValid = IsValid(ene)
				end
				-- Reset enemy if it has been unseen for a while
				if (curTime - self.LastEnemyVisibleTime) > ((self.LatestEnemyDistance < 4000 and self.TimeUntilEnemyLost) or (self.TimeUntilEnemyLost / 2)) && (!self.IsVJBaseSNPC_Tank) then
					self:PlaySoundSystem("LostEnemy")
					self.EnemyReset = true
					self:ResetEnemy(true)
					ene = self:GetEnemy()
					eneValid = IsValid(ene)
				end
			end
			
			if self.DoingWeaponAttack == true then self:CapabilitiesRemove(CAP_TURN_HEAD) else self:CapabilitiesAdd(bit.bor(CAP_TURN_HEAD)) end -- Fixes their heads breaking
			-- If we have a valid weapon...
			if IsValid(self.CurrentWeaponEntity) then
				-- Weapon Inventory System
				if !plyControlled && !self:BusyWithActivity() then // self.IsReloadingWeapon == false
					if eneValid then
						if IsValid(self.WeaponInventory.Melee) && ((self.LatestEnemyDistance < self.MeleeAttackDistance) or (self.LatestEnemyDistance < 300 && self.CurrentWeaponEntity:Clip1() <= 0)) && (self:Health() > self:GetMaxHealth() * 0.25) && self.CurrentWeaponEntity != self.WeaponInventory.Melee then
							if self:GetWeaponState() == VJ_WEP_STATE_RELOADING then self:SetWeaponState() end -- Since the reloading can be cut off, reset it back to false, or else it can mess up its behavior!
							//timer.Remove("timer_reload_end"..self:EntIndex()) -- No longer needed
							self.WeaponInventoryStatus = VJ_WEP_INVENTORY_MELEE
							self:DoChangeWeapon(self.WeaponInventory.Melee, true)
						elseif self:GetWeaponState() != VJ_WEP_STATE_RELOADING && IsValid(self.WeaponInventory.AntiArmor) && (ene.IsVJBaseSNPC_Tank == true or ene.VJ_IsHugeMonster == true) && self.CurrentWeaponEntity != self.WeaponInventory.AntiArmor then
							self.WeaponInventoryStatus = VJ_WEP_INVENTORY_ANTI_ARMOR
							self:DoChangeWeapon(self.WeaponInventory.AntiArmor, true)
						end
					end
					if self:GetWeaponState() != VJ_WEP_STATE_RELOADING then
						-- Reset weapon status from melee to primary
						if self.WeaponInventoryStatus == VJ_WEP_INVENTORY_MELEE && (!eneValid or (eneValid && self.LatestEnemyDistance >= 300)) then
							self.WeaponInventoryStatus = VJ_WEP_INVENTORY_PRIMARY
							self:DoChangeWeapon(self.WeaponInventory.Primary, true)
						-- Reset weapon status from anti-armor to primary
						elseif self.WeaponInventoryStatus == VJ_WEP_INVENTORY_ANTI_ARMOR && (!eneValid or (eneValid && ene.IsVJBaseSNPC_Tank != true && ene.VJ_IsHugeMonster != true)) then
							self.WeaponInventoryStatus = VJ_WEP_INVENTORY_PRIMARY
							self:DoChangeWeapon(self.WeaponInventory.Primary, true)
						end
					end
				end
				
				-- Weapon Reloading
				if self.AllowWeaponReloading && !self:BusyWithActivity() && self:GetWeaponState() == VJ_WEP_STATE_READY && (!self.CurrentWeaponEntity.IsMeleeWeapon) && self.AttackType == VJ_ATTACK_NONE && self.VJ_PlayingSequence == false && ((!plyControlled && ((!eneValid && self.CurrentWeaponEntity:GetMaxClip1() > self.CurrentWeaponEntity:Clip1() && (curTime - self.LastEnemyTime) > math.random(3, 8) && !self:IsMoving()) or (eneValid && self.CurrentWeaponEntity:Clip1() <= 0))) or (plyControlled && self.VJ_TheController:KeyDown(IN_RELOAD) && self.CurrentWeaponEntity:GetMaxClip1() > self.CurrentWeaponEntity:Clip1())) then
					self.DoingWeaponAttack = false
					self.DoingWeaponAttack_Standing = false
					if !plyControlled then self:SetWeaponState(VJ_WEP_STATE_RELOADING) end
					self.NextChaseTime = curTime + 2
					if eneValid == true then self:PlaySoundSystem("WeaponReload") end -- tsayn han e minag yete teshnami ga!
					self:CustomOnWeaponReload()
					if self.DisableWeaponReloadAnimation == false then
						local function DoReloadAnimation(anim)
							if VJ_AnimationExists(self, anim) then -- Only if the given animation actually exists!
								local dur = self:DecideAnimationLength(anim, false, self.WeaponReloadAnimationDecreaseLengthAmount)
								local wep = self.CurrentWeaponEntity
								if wep.IsVJBaseWeapon == true then wep:NPC_Reload() end
								timer.Create("timer_reload_end"..self:EntIndex(), dur, 1, function()
									if IsValid(self) && IsValid(wep) && self:GetWeaponState() == VJ_WEP_STATE_RELOADING then
										wep:SetClip1(wep:GetMaxClip1())
										if wep.IsVJBaseWeapon == true then wep:CustomOnReload_Finish() end
										self:SetWeaponState()
									end
								end)
								self:VJ_ACT_PLAYACTIVITY(anim, true, dur, self.WeaponReloadAnimationFaceEnemy, self.WeaponReloadAnimationDelay, {SequenceDuration=dur, PlayBackRateCalculated=true})
								self.AllowToDo_WaitForEnemyToComeOut = false
								-- If NOT controlled by a player AND is a gesture make it stop moving so it doesn't run after the enemy right away
								if !plyControlled && string.find(anim, "vjges_") then
									self:StopMoving()
								end
								return true -- We have successfully ran the animation!
							end
							return false -- The given animation was invalid!
						end
						-- Controlled by a player...
						if plyControlled == true then
							self:SetWeaponState(VJ_WEP_STATE_RELOADING)
							DoReloadAnimation(self:TranslateToWeaponAnim(VJ_PICK(self.AnimTbl_WeaponReload)))
						-- NOT controlled by a player...
						else
							-- NPC is hidden, so attempt to crouch reload
							if eneValid == true && self:VJ_ForwardIsHidingZone(self:NearestPoint(myPos + self:OBBCenter()), ene:EyePos(), false, {SetLastHiddenTime=true}) == true then -- Behvedadz
								-- if It does NOT have a cover reload animation, then just play the regular standing reload animation
								if !DoReloadAnimation(self:TranslateToWeaponAnim(VJ_PICK(self.AnimTbl_WeaponReloadBehindCover))) then
									DoReloadAnimation(self:TranslateToWeaponAnim(VJ_PICK(self.AnimTbl_WeaponReload)))
								end
							else -- NPC is NOT hidden...
								-- Under certain situations, simply do standing reload without running to a hiding spot
								if self.IsGuard == true or self.IsFollowing == true or self.VJ_IsBeingControlled_Tool == true or eneValid == false or self.MovementType == VJ_MOVETYPE_STATIONARY or self.LatestEnemyDistance < 650 then
									DoReloadAnimation(self:TranslateToWeaponAnim(VJ_PICK(self.AnimTbl_WeaponReload)))
								else -- If all is good, then run to a hiding spot and then reload!
									self:SetMovementActivity(VJ_PICK(self.AnimTbl_Run))
									local vsched = ai_vj_schedule.New("vj_weapon_reload")
									vsched:EngTask("TASK_FIND_COVER_FROM_ENEMY", 0)
									vsched:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
									vsched.StopScheduleIfNotMoving = true
									vsched.IsMovingTask = true
									vsched.MoveType = 1
									vsched.RunCode_OnFinish = function()
										if self:GetWeaponState() == VJ_WEP_STATE_RELOADING then
											-- If the current situation isn't favorable, then abandon the current reload, and try again!
											if (self.AttackType != VJ_ATTACK_NONE) or (IsValid(self:GetEnemy()) && self.HasWeaponBackAway == true && (self:GetPos():Distance(self:GetEnemy():GetPos()) <= self.WeaponBackAway_Distance)) then
												self:SetWeaponState()
												//timer.Remove("timer_reload_end"..self:EntIndex()) -- Remove the timer to make sure it doesn't set reloading to false at a random time (later on)
											else -- Our hiding spot is good, so reload!
												DoReloadAnimation(self:TranslateToWeaponAnim(VJ_PICK(self.AnimTbl_WeaponReload)))
												self:CustomOnWeaponReload_AfterRanToCover()
											end
										end
									end
									self:StartSchedule(vsched)
								end
							end
						end
					else -- If the reload animation is disabled
						if self:GetWeaponState() == VJ_WEP_STATE_RELOADING then self:SetWeaponState() end
						self.CurrentWeaponEntity:SetClip1(self.CurrentWeaponEntity:GetMaxClip1())
						self.CurrentWeaponEntity:NPC_Reload()
					end
				end
			end
		
			if eneValid then
				local enePos = ene:GetPos()
				if self.DoingWeaponAttack then self:PlaySoundSystem("Suppressing") end
				
				-- Set latest enemy information
				self:UpdateEnemyMemory(ene, enePos)
				self.EnemyReset = false
				self.LastEnemyVisible = plyControlled and self:VisibleVec(enePos) or self:Visible(ene) -- Need to use VisibleVec when controlled because "Visible" will return false randomly
				self.LastEnemySightDiff = self:GetSightDirection():Dot((enePos - myPos):GetNormalized())
				self.LatestEnemyDistance = myPos:Distance(enePos)
				self.NearestPointToEnemyDistance = self:VJ_GetNearestPointToEntityDistance(ene)
				if (self.LastEnemySightDiff > math_cos(math_rad(self.SightAngle))) && (self.LatestEnemyDistance < self:GetMaxLookDistance()) && self.LastEnemyVisible then
					self.LastEnemyVisibleTime = curTime
					self.LastEnemyVisiblePos = enePos
				end
				
				-- Turning / Facing Enemy
				if self.ConstantlyFaceEnemy then self:DoConstantlyFaceEnemy() end
				if self.FacingStatus == VJ_FACING_ENEMY or (self.CombatFaceEnemy == true && self.CurrentSchedule != nil && ((self.CurrentSchedule.ConstantlyFaceEnemy == true) or (self.CurrentSchedule.ConstantlyFaceEnemyVisible == true && self.LastEnemyVisible))) then
					local faceAng = self:GetFaceAngle((enePos - myPos):Angle())
					if self.TurningUseAllAxis == true then
						local myAngs = self:GetAngles()
						self:SetAngles(LerpAngle(FrameTime()*self.TurningSpeed, myAngs, Angle(faceAng.p, myAngs.y, faceAng.r)))
					end
					self:SetIdealYawAndUpdate(faceAng.y)
				end

				-- Call for help
				if self.AttackType != VJ_ATTACK_GRENADE && self.CallForHelp == true && curTime > self.NextCallForHelpT then
					self:Allies_CallHelp(self.CallForHelpDistance)
					self.NextCallForHelpT = curTime + self.NextCallForHelpTime
				end
				
				-- Grenade attack
				if self.HasGrenadeAttack && self:GetState() != VJ_STATE_ONLY_ANIMATION_NOATTACK && self:GetWeaponState() != VJ_WEP_STATE_RELOADING && !self:BusyWithActivity() && curTime > self.NextThrowGrenadeT && curTime > self.TakingCoverT then
					if plyControlled && self.VJ_TheController:KeyDown(IN_JUMP) then
						self:ThrowGrenadeCode()
						self.NextThrowGrenadeT = curTime + math.random(self.NextThrowGrenadeTime.a, self.NextThrowGrenadeTime.b)
					elseif !plyControlled then
						local chance = self.ThrowGrenadeChance
						-- If chance is above 4, then half it by 2 if the enemy is a tank OR not visible
						if math.random(1, (chance > 3 && (ene.IsVJBaseSNPC_Tank or !self.LastEnemyVisible) and math.floor(chance / 2)) or chance) == 1 && self.LatestEnemyDistance < self.GrenadeAttackThrowDistance && self.LatestEnemyDistance > self.GrenadeAttackThrowDistanceClose then
							self:ThrowGrenadeCode()
						end
						self.NextThrowGrenadeT = curTime + math.random(self.NextThrowGrenadeTime.a, self.NextThrowGrenadeTime.b)
					end
				end
				
				-- Sets the scared behavior movement activity
				if !IsValid(self.CurrentWeaponEntity) && self.NoWeapon_UseScaredBehavior && !plyControlled then
					local anim = VJ_PICK(self.AnimTbl_ScaredBehaviorMovement)
					if anim != false then
						self:SetMovementActivity(anim)
					else
						if VJ_AnimationExists(self, ACT_RUN_PROTECTED) == true then
							self:SetMovementActivity(ACT_RUN_PROTECTED)
						elseif VJ_AnimationExists(self, ACT_RUN_CROUCH_RIFLE) == true then
							self:SetMovementActivity(ACT_RUN_CROUCH_RIFLE)
						end
					end
					//self:SetArrivalActivity(VJ_PICK(self.AnimTbl_ScaredBehaviorStand)) -- Already done by self.CurrentAnim_IdleStand
				end
				
				if !self.LastEnemyVisible then
					self.DoingWeaponAttack = false
					self.DoingWeaponAttack_Standing = false
				end
				
				self:DoWeaponAttackMovementCode()
				self:DoPoseParameterLooking()
				
				-- Face enemy for stationary types OR attacks
				if (self.MovementType == VJ_MOVETYPE_STATIONARY && self.CanTurnWhileStationary == true) or (self.MeleeAttackAnimationFaceEnemy == true && self.AttackType == VJ_ATTACK_MELEE) or (self.GrenadeAttackAnimationFaceEnemy == true && self.AttackType == VJ_ATTACK_GRENADE && self.LastEnemyVisible == true) then
					self:FaceCertainEntity(ene, true)
				end
				
				if !self.vACT_StopAttacks && self:GetState() != VJ_STATE_ONLY_ANIMATION_NOATTACK && self.Behavior != VJ_BEHAVIOR_PASSIVE && self.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE && curTime > self.NextDoAnyAttackT then
					self:CustomAttack(ene, self.LastEnemyVisible) -- Custom attack
				
					-- Melee Attack
					if self.HasMeleeAttack == true && !self.vACT_StopAttacks && !self.Flinching && !self.FollowData.StopAct && self.AttackType == VJ_ATTACK_NONE && self.IsAbleToMeleeAttack && (!IsValid(self.CurrentWeaponEntity) or (IsValid(self.CurrentWeaponEntity) && (!self.CurrentWeaponEntity.IsMeleeWeapon))) && ((plyControlled == true && self.VJ_TheController:KeyDown(IN_ATTACK)) or (plyControlled == false && (self.NearestPointToEnemyDistance < self.MeleeAttackDistance && self.LastEnemyVisible) && (self.LastEnemySightDiff > math_cos(math_rad(self.MeleeAttackAngleRadius))))) then
						local seed = curTime; self.CurAttackSeed = seed
						self.AttackType = VJ_ATTACK_MELEE
						self.AttackStatus = VJ_ATTACK_STATUS_STARTED
						self.MeleeAttacking = true
						self.IsAbleToMeleeAttack = false
						self:FaceCertainEntity(ene, true)
						self:CustomOnMeleeAttack_BeforeStartTimer(seed)
						timer.Simple(self.BeforeMeleeAttackSounds_WaitTime, function() if IsValid(self) then self:PlaySoundSystem("BeforeMeleeAttack") end end)
						self.NextAlertSoundT = curTime + 0.4
						if self.DisableMeleeAttackAnimation == false then
							self.CurrentAttackAnimation = VJ_PICK(self.AnimTbl_MeleeAttack)
							self.CurrentAttackAnimationDuration = self:DecideAnimationLength(self.CurrentAttackAnimation, false, self.MeleeAttackAnimationDecreaseLengthAmount)
							if self.MeleeAttackAnimationAllowOtherTasks == false then -- Useful for gesture-based attacks
								self.PlayingAttackAnimation = true
								timer.Create("timer_act_playingattack"..self:EntIndex(), self.CurrentAttackAnimationDuration, 1, function() self.PlayingAttackAnimation = false end)
							end
							self:VJ_ACT_PLAYACTIVITY(self.CurrentAttackAnimation,false,0,false,self.MeleeAttackAnimationDelay,{SequenceDuration=self.CurrentAttackAnimationDuration})
						end
						if self.TimeUntilMeleeAttackDamage == false then
							self:MeleeAttackCode_DoFinishTimers()
						else -- If it's not event based...
							timer.Create("timer_melee_start"..self:EntIndex(), self.TimeUntilMeleeAttackDamage / self:GetPlaybackRate(), self.MeleeAttackReps, function() if self.CurAttackSeed == seed then self:MeleeAttackCode() end end)
							for k, t in pairs(self.MeleeAttackExtraTimers or {}) do
								self:DoAddExtraAttackTimers("timer_melee_start"..curTime + k, t, function() if self.CurAttackSeed == seed then self:MeleeAttackCode() end end)
							end
						end
						self:CustomOnMeleeAttack_AfterStartTimer(seed)
					end
				end
			else -- No Enemy
				self.DoingWeaponAttack = false
				self.DoingWeaponAttack_Standing = false
				if !self.Alerted && self.DidWeaponAttackAimParameter && !plyControlled then
					self:ClearPoseParameters()
					self.DidWeaponAttackAimParameter = false
				end
				
				if self:GetArrivalActivity() == self.CurrentWeaponAnimation then
					self:SetArrivalActivity(self.CurrentAnim_IdleStand)
				end
				
				self.TimeSinceEnemyAcquired = 0
				if self.EnemyReset == false && (!self.IsVJBaseSNPC_Tank) then self:PlaySoundSystem("LostEnemy") self.EnemyReset = true self:ResetEnemy(true) end
			end
			
			-- Guarding Position
			if self.IsGuard == true && self.IsFollowing == false then
				if self.GuardingPosition == nil then -- If it hasn't been set then set the guard position to its current position
					self.GuardingPosition = myPos
					self.GuardingFacePosition = myPos + self:GetForward()*51
				end
				-- If it's far from the guarding position, then go there!
				if !self:IsMoving() && self:BusyWithActivity() == false then
					local dist = myPos:Distance(self.GuardingPosition) -- Distance to the guard position
					if dist > 50 then
						self:SetLastPosition(self.GuardingPosition)
						self:VJ_TASK_GOTO_LASTPOS(dist <= 800 and "TASK_WALK_PATH" or "TASK_RUN_PATH", function(x) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true
							x.RunCode_OnFinish = function()
								timer.Simple(0.01, function()
									if IsValid(self) && !self:IsMoving() && self:BusyWithActivity() == false && self.GuardingFacePosition != nil then
										self:SetLastPosition(self.GuardingFacePosition)
										self:VJ_TASK_FACE_X("TASK_FACE_LASTPOSITION")
									end
								end)
							end
						end)
					end
				end
			end
		end
	else -- AI Not enabled
		self.DoingWeaponAttack = false
	end
	self:NextThink(curTime + (0.069696968793869 + FrameTime()))
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MeleeAttackCode(customEnt)
	if self.Dead or self.vACT_StopAttacks or self.Flinching or self.AttackType == VJ_ATTACK_GRENADE or (self.StopMeleeAttackAfterFirstHit && self.AttackStatus == VJ_ATTACK_STATUS_EXECUTED_HIT) then return end
	local curEnemy = customEnt or self:GetEnemy()
	if self.MeleeAttackAnimationFaceEnemy then self:FaceCertainEntity(curEnemy, true) end
	//self.MeleeAttacking = true
	self:CustomOnMeleeAttack_BeforeChecks()
	if self.DisableDefaultMeleeAttackCode then return end
	local myPos = self:GetPos()
	local hitRegistered = false
	for _,v in pairs(ents.FindInSphere(self:GetMeleeAttackDamageOrigin(), self.MeleeAttackDamageDistance)) do
		if (self.VJ_IsBeingControlled == true && self.VJ_TheControllerBullseye == v) or (v:IsPlayer() && v.IsControlingNPC == true) then continue end -- If controlled and v is the bullseye OR it's a player controlling then don't damage!
		if v != self && v:GetClass() != self:GetClass() && (((v:IsNPC() or (v:IsPlayer() && v:Alive() && GetConVar("ai_ignoreplayers"):GetInt() == 0)) && self:Disposition(v) != D_LI) or IsProp(v) == true or v:GetClass() == "func_breakable_surf" or destructibleEnts[v:GetClass()] or v.VJ_AddEntityToSNPCAttackList == true) && self:GetSightDirection():Dot((Vector(v:GetPos().x, v:GetPos().y, 0) - Vector(myPos.x, myPos.y, 0)):GetNormalized()) > math_cos(math_rad(self.MeleeAttackDamageAngleRadius)) then
			local vProp = IsProp(v)
			if self:CustomOnMeleeAttack_AfterChecks(v, vProp) == true then continue end
			-- Knockback
			if self.HasMeleeAttackKnockBack && v.MovementType != VJ_MOVETYPE_STATIONARY && (!v.VJ_IsHugeMonster or v.IsVJBaseSNPC_Tank) then
				v:SetGroundEntity(NULL)
				v:SetVelocity(self:MeleeAttackKnockbackVelocity(v))
			end
			-- Apply actual damage
			if !self.DisableDefaultMeleeAttackDamageCode then
				local applyDmg = DamageInfo()
				applyDmg:SetDamage(self:VJ_GetDifficultyValue(self.MeleeAttackDamage))
				applyDmg:SetDamageType(self.MeleeAttackDamageType)
				//applyDmg:SetDamagePosition(self:VJ_GetNearestPointToEntity(v).MyPosition)
				if v:IsNPC() or v:IsPlayer() then applyDmg:SetDamageForce(self:GetForward() * ((applyDmg:GetDamage() + 100) * 70)) end
				applyDmg:SetInflictor(self)
				applyDmg:SetAttacker(self)
				v:TakeDamageInfo(applyDmg, self)
			end
			if v:IsPlayer() then
				v:ViewPunch(Angle(math.random(-1, 1) * self.MeleeAttackDamage, math.random(-1, 1) * self.MeleeAttackDamage, math.random(-1, 1) * self.MeleeAttackDamage))
			end
			VJ_DestroyCombineTurret(self,v)
			if !vProp then -- Only for non-props...
				hitRegistered = true
			end
		end
	end
	if self.AttackStatus < VJ_ATTACK_STATUS_EXECUTED then
		self.AttackStatus = VJ_ATTACK_STATUS_EXECUTED
		if self.TimeUntilMeleeAttackDamage != false then
			self:MeleeAttackCode_DoFinishTimers()
		end
	end
	if hitRegistered == true then
		self:PlaySoundSystem("MeleeAttack")
		self.AttackStatus = VJ_ATTACK_STATUS_EXECUTED_HIT
	else
		self:CustomOnMeleeAttack_Miss()
		self:PlaySoundSystem("MeleeAttackMiss", {}, VJ_EmitSound)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MeleeAttackCode_DoFinishTimers(skipStopAttacks)
	if skipStopAttacks != true then
		timer.Create("timer_melee_finished"..self:EntIndex(), self:DecideAttackTimer(self.NextAnyAttackTime_Melee,self.NextAnyAttackTime_Melee_DoRand,self.TimeUntilMeleeAttackDamage,self.CurrentAttackAnimationDuration), 1, function()
			self:StopAttacks()
			self:DoChaseAnimation()
		end)
	end
	timer.Create("timer_melee_finished_abletomelee"..self:EntIndex(), self:DecideAttackTimer(self.NextMeleeAttackTime,self.NextMeleeAttackTime_DoRand), 1, function()
		self.IsAbleToMeleeAttack = true
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ThrowGrenadeCode(customEnt, noOwner)
	if self.Dead == true or self.Flinching == true or self.AttackType == VJ_ATTACK_MELEE /*or (IsValid(self:GetEnemy()) && !self:Visible(self:GetEnemy()))*/ then return end
	//if self:VJ_ForwardIsHidingZone(self:NearestPoint(self:GetPos() + self:OBBCenter()),self:GetEnemy():EyePos()) == true then return end
	noOwner = noOwner or false
	local getIsCustom = false
	local gerModel = VJ_PICK(self.GrenadeAttackModel)
	local gerClass = self.GrenadeAttackEntity
	local gerFussTime = self.GrenadeAttackFussTime
	
	if IsValid(self:GetEnemy()) && !self.LastEnemyVisible then
		if self:VisibleVec(self.LastEnemyVisiblePos) && self:GetEnemy():GetPos():Distance(self.LastEnemyVisiblePos) <= 600 then
			self:FaceCertainPosition(self.LastEnemyVisiblePos)
		else
			return
		end
	end
	
	if self.DisableGrenadeAttackAnimation == false then
		self.CurrentAttackAnimation = VJ_PICK(self.AnimTbl_GrenadeAttack)
		self.CurrentAttackAnimationDuration = self:DecideAnimationLength(self.CurrentAttackAnimation, false, 0.2)
		self.PlayingAttackAnimation = true
		timer.Create("timer_act_playingattack"..self:EntIndex(), self.CurrentAttackAnimationDuration, 1, function() self.PlayingAttackAnimation = false end)
		self:VJ_ACT_PLAYACTIVITY(self.CurrentAttackAnimation, self.GrenadeAttackAnimationStopAttacks, self:DecideAnimationLength(self.CurrentAttackAnimation, self.GrenadeAttackAnimationStopAttacksTime), true, self.GrenadeAttackAnimationDelay, {PlayBackRateCalculated=true})
	end

	if IsValid(customEnt) then -- Custom nernagner gamal nernagner vor yete bidi nede
		local getSpawnPos = self.GrenadeAttackAttachment
		local getSpawnAngle;
		if getSpawnPos == false then
			getSpawnPos = self:CustomOnGrenadeAttack_SpawnPosition()
			getSpawnAngle = getSpawnPos:Angle()
		else
			getSpawnPos = self:GetAttachment(self:LookupAttachment(self.GrenadeAttackAttachment)).Pos
			getSpawnAngle = self:GetAttachment(self:LookupAttachment(self.GrenadeAttackAttachment)).Ang
		end
	
		getIsCustom = true
		gerModel = customEnt:GetModel()
		gerClass = customEnt:GetClass()
		customEnt:SetMoveType(MOVETYPE_NONE)
		customEnt:SetParent(self)
		if self.GrenadeAttackAttachment == false then
			customEnt:SetPos(getSpawnPos)
		else
			customEnt:Fire("SetParentAttachment", self.GrenadeAttackAttachment)
		end
		customEnt:SetAngles(getSpawnAngle)
		if gerClass == "obj_vj_grenade" then
			gerFussTime = math.abs(customEnt.FussTime - customEnt.TimeSinceSpawn)
		elseif gerClass == "obj_handgrenade" or gerClass == "obj_spore" then
			gerFussTime = 1
		elseif gerClass == "npc_grenade_frag" or gerClass == "doom3_grenade" or gerClass == "fas2_thrown_m67" or gerClass == "cw_grenade_thrown" or gerClass == "cw_flash_thrown" or gerClass == "cw_smoke_thrown" then
			gerFussTime = 1.5
		elseif gerClass == "obj_cpt_grenade" then
			gerFussTime = 2
		end
	end

	if !IsValid(self:GetEnemy()) then
		local sideCheck = VJ_PICK(self:VJ_CheckAllFourSides(200, true))
		if sideCheck then
			self:FaceCertainPosition(sideCheck, self.CurrentAttackAnimationDuration or 1.5)
			doit = true
		end
	end

	self.AttackType = VJ_ATTACK_GRENADE
	self.ThrowingGrenade = true
	self:CustomOnGrenadeAttack_BeforeStartTimer()
	self:PlaySoundSystem("GrenadeAttack")

	timer.Simple(self.TimeUntilGrenadeIsReleased, function()
		if getIsCustom == true && !IsValid(customEnt) then return end
		if IsValid(customEnt) then customEnt.VJ_IsPickedUpDanger = false customEnt:Remove() end
		if IsValid(self) && self.Dead == false /*&& IsValid(self:GetEnemy())*/ then -- Yete SNPC ter artoon e...
			local getSpawnPos = self.GrenadeAttackAttachment
			local getSpawnAngle;
			if getSpawnPos == false then
				getSpawnPos = self:CustomOnGrenadeAttack_SpawnPosition()
				getSpawnAngle = getSpawnPos:Angle()
			else
				getSpawnPos = self:GetAttachment(self:LookupAttachment(self.GrenadeAttackAttachment)).Pos
				getSpawnAngle = self:GetAttachment(self:LookupAttachment(self.GrenadeAttackAttachment)).Ang
			end
	
			local greTargetPos = self:GetPos() + self:GetForward()*200
			if IsValid(self:GetEnemy()) then
				if !self.LastEnemyVisible && self:VisibleVec(self.LastEnemyVisiblePos) && self:GetEnemy():GetPos():Distance(self.LastEnemyVisiblePos) <= 600 then
					greTargetPos = self.LastEnemyVisiblePos
					self:FaceCertainPosition(greTargetPos, self.CurrentAttackAnimationDuration - self.TimeUntilGrenadeIsReleased)
				else
					greTargetPos = self:GetEnemy():GetPos()
				end
			else -- Yete teshnami chooni, nede amenan lav goghme
				if !IsValid(self:GetEnemy()) then
					local test = self:VJ_CheckAllFourSides(200, true)
					local sideCheck = VJ_PICK(test)
					if sideCheck then
						greTargetPos = sideCheck
						self:FaceCertainPosition(sideCheck, self.CurrentAttackAnimationDuration - self.TimeUntilGrenadeIsReleased)
					end
				end
			end
			local gent = ents.Create(gerClass)
			if noOwner == false then gent:SetOwner(self) end
			gent:SetPos(getSpawnPos)
			gent:SetAngles(getSpawnAngle)
			if gerModel then gent:SetModel(Model(gerModel)) end
			local getThrowVel = self:CustomOnGrenadeAttack_ThrowVelocity(gent, greTargetPos, getSpawnPos)
			-- Set the timers for all the different grenade entities
				if gerClass == "obj_vj_grenade" then
					gent.FussTime = gerFussTime
				elseif gerClass == "obj_cpt_grenade" then
					gent:SetTimer(gerFussTime)
				elseif gerClass == "obj_spore" then
					gent:SetGrenade(true)
				elseif gerClass == "ent_hl1_grenade" then
					gent:ShootTimed(customEnt, getThrowVel, gerFussTime)
				elseif gerClass == "doom3_grenade" or gerClass == "obj_handgrenade" then
					gent:SetExplodeDelay(gerFussTime)
				elseif gerClass == "cw_grenade_thrown" or gerClass == "cw_flash_thrown" or gerClass == "cw_smoke_thrown" then
					gent:SetOwner(self)
					gent:Fuse(gerFussTime)
				end
			gent:Spawn()
			gent:Activate()
			if gerClass == "npc_grenade_frag" then gent:Input("SetTimer",self:GetOwner(),self:GetOwner(),gerFussTime) end
			local phys = gent:GetPhysicsObject()
			if IsValid(phys) then
				phys:Wake()
				phys:AddAngleVelocity(Vector(math.Rand(500, 500), math.Rand(500, 500), math.Rand(500, 500)))
				phys:SetVelocity(getThrowVel)
			end
			self:CustomOnGrenadeAttack_OnThrow(gent)
		end
		if self.AttackType == VJ_ATTACK_GRENADE then
			self.AttackType = VJ_ATTACK_NONE
		end
		self.ThrowingGrenade = false
	end)
end

---------------------------------------------------------------------------------------------------------------------------------------------
/* Old system (Replaced by condition system)
local getSdHint = sound.GetLoudestSoundHint
local sdBitSource = bit.bor(SOUND_DANGER, SOUND_CONTEXT_REACT_TO_SOURCE) ---> Combine dropship impact position, Combine gunship turret impact position, Strider minigun impact position
local sdBitCombine = bit.bor(SOUND_DANGER, SOUND_CONTEXT_EXCLUDE_COMBINE) ---> Flechette impact position, Strider foot impact position
local sdBitPlyVehicle = bit.bor(SOUND_DANGER, SOUND_CONTEXT_PLAYER_VEHICLE) ---> Player driving a vehicle
local sdBitMortar = bit.bor(SOUND_DANGER, SOUND_CONTEXT_MORTAR) ---> Combine mortars impact position
--
function ENT:GetPossibleDangers()
	local myPos = self:GetPos()
	return getSdHint(SOUND_DANGER, myPos) or getSdHint(sdBitSource, myPos) or getSdHint(sdBitCombine, myPos) or getSdHint(sdBitPlyVehicle, myPos) or getSdHint(sdBitMortar, myPos)
end
*/
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
3 types of danger detections:
- ent.VJ_IsDetectableGrenade
	- Detected as a grenade
	- Distance based on self.DangerDetectionDistance
	- Ignores grenades from allies
	- BEST USE: Grenade type of entities
- ent.VJ_IsDetectableDanger
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
	if !self.CanDetectDangers or self.AttackType == VJ_ATTACK_GRENADE or self.NextDangerDetectionT > CurTime() or self.VJ_IsBeingControlled then return end
	local regDangerDetected = false -- A regular non-grenade danger has been found (This is done to make sure grenades take priority over other dangers!)
	for _,v in pairs(ents.FindInSphere(self:GetPos(), self.DangerDetectionDistance)) do
		if (v.VJ_IsDetectableDanger or v.VJ_IsDetectableGrenade) && self:Visible(v) then
			local vOwner = v:GetOwner()
			if !(IsValid(vOwner) && vOwner.IsVJBaseSNPC && ((self:GetClass() == vOwner:GetClass()) or (self:Disposition(vOwner) == D_LI))) then
				if v.VJ_IsDetectableDanger then regDangerDetected = true continue end -- If it's a regular danger then just skip it for now
				self:PlaySoundSystem("OnGrenadeSight")
				self.NextDangerDetectionT = CurTime() + 4
				self.TakingCoverT = CurTime() + 4
				-- If has the ability to throw it back, then throw the grenade!
				if self.CanThrowBackDetectedGrenades && self.HasGrenadeAttack && v.VJ_IsPickupableDanger && !v.VJ_IsPickedUpDanger && v:GetVelocity():Length() < 400 && self:VJ_GetNearestPointToEntityDistance(v) < 100 then
					self.NextGrenadeAttackSoundT = CurTime() + 3
					self:ThrowGrenadeCode(v, true)
					v.VJ_IsPickedUpDanger = true
					//v:Remove()
					return
				end
				self:VJ_TASK_COVER_FROM_ORIGIN("TASK_RUN_PATH", function(x)
					x.CanShootWhenMoving = true
					x.ConstantlyFaceEnemy = true
				end)
				return
			end
		end
	end
	if regDangerDetected or self:HasCondition(COND_HEAR_DANGER) or self:HasCondition(COND_HEAR_PHYSICS_DANGER) or self:HasCondition(COND_HEAR_MOVE_AWAY) then
		self:PlaySoundSystem("OnDangerSight")
		self.NextDangerDetectionT = CurTime() + 4
		self.TakingCoverT = CurTime() + 4
		self:VJ_TASK_COVER_FROM_ORIGIN("TASK_RUN_PATH", function(x)
			x.CanShootWhenMoving = true
			x.ConstantlyFaceEnemy = true
		end)
		return
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StopAttacks(checkTimers)
	if self:Health() <= 0 then return end
	if self.VJDEBUG_SNPC_ENABLED == true && GetConVar("vj_npc_printstoppedattacks"):GetInt() == 1 then print(self:GetClass().." Stopped all Attacks!") end
	
	if checkTimers == true && self.AttackType == VJ_ATTACK_MELEE && self.AttackStatus < VJ_ATTACK_STATUS_EXECUTED then
		self:MeleeAttackCode_DoFinishTimers(true)
	end
	
	self.AttackType = VJ_ATTACK_NONE
	self.AttackStatus = VJ_ATTACK_STATUS_DONE
	self.CurAttackSeed = 0
	
	self.MeleeAttacking = false
	
	self:DoChaseAnimation()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:WeaponAimPoseParameters(resetPoses) self:DoPoseParameterLooking(resetPoses) end -- !!!!!!!!!!!!!! DO NOT USE THIS FUNCTION !!!!!!!!!!!!!! [Backwards Compatibility!]
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoPoseParameterLooking(resetPoses)
	if (self.HasPoseParameterLooking == false) or (self.VJ_IsBeingControlled == false && self.DoingWeaponAttack == false) then return end
	resetPoses = resetPoses or false
	//self:GetPoseParameters(true)
	local ent = (self.VJ_IsBeingControlled == true and self.VJ_TheController) or self:GetEnemy()
	local p_enemy = 0 -- Pitch
	local y_enemy = 0 -- Yaw
	local r_enemy = 0 -- Roll
	if IsValid(ent) && !resetPoses then
		local enemy_pos = (self.VJ_IsBeingControlled == true and self.VJ_TheControllerBullseye:GetPos()) or ent:GetPos() + ent:OBBCenter()
		local self_ang = self:GetAngles()
		local enemy_ang = (enemy_pos - (self:GetPos() + self:OBBCenter())):Angle()
		p_enemy = math_angDif(enemy_ang.p, self_ang.p)
		if self.PoseParameterLooking_InvertPitch == true then p_enemy = -p_enemy end
		y_enemy = math_angDif(enemy_ang.y, self_ang.y)
		if self.PoseParameterLooking_InvertYaw == true then y_enemy = -y_enemy end
		r_enemy = math_angDif(enemy_ang.z, self_ang.z)
		if self.PoseParameterLooking_InvertRoll == true then r_enemy = -r_enemy end
	elseif !self.PoseParameterLooking_CanReset then -- Should it reset its pose parameters if there is no enemies?
		return
	end
	
	self:CustomOn_PoseParameterLookingCode(p_enemy, y_enemy, r_enemy)
	
	local names = self.PoseParameterLooking_Names
	for x = 1, #names.pitch do
		self:SetPoseParameter(names.pitch[x], math_angApproach(self:GetPoseParameter(names.pitch[x]), p_enemy, self.PoseParameterLooking_TurningSpeed))
	end
	for x = 1, #names.yaw do
		self:SetPoseParameter(names.yaw[x], math_angApproach(self:GetPoseParameter(names.yaw[x]), y_enemy, self.PoseParameterLooking_TurningSpeed))
	end
	for x = 1, #names.roll do
		self:SetPoseParameter(names.roll[x], math_angApproach(self:GetPoseParameter(names.roll[x]), r_enemy, self.PoseParameterLooking_TurningSpeed))
	end
	self.DidWeaponAttackAimParameter = true
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoWeaponAttackMovementCode(override, moveType)
	override = override or false -- Overrides some of the checks, only used for the internal task system!
	moveType = moveType or 0 -- This is used with override | 0 = Run, 1 = Walk
	if (self.CurrentWeaponEntity.IsMeleeWeapon) then
		self.DoingWeaponAttack = true
	elseif self.HasShootWhileMoving == true then
		if self.LastEnemyVisible && self:IsAbleToShootWeapon(true, false) == true && ((self:IsMoving() && (self.CurrentSchedule != nil && self.CurrentSchedule.CanShootWhenMoving == true)) or (override == true)) then
			if (override == true && moveType == 0) or (self.CurrentSchedule != nil && self.CurrentSchedule.MoveType == 1) then
				local anim = self:TranslateToWeaponAnim(VJ_PICK(self.AnimTbl_ShootWhileMovingRun))
				if VJ_AnimationExists(self,anim) == true then
					self.DoingWeaponAttack = true
					self.DoingWeaponAttack_Standing = false
					self:CapabilitiesAdd(bit.bor(CAP_MOVE_SHOOT))
					self:SetMovementActivity(anim)
					self:SetArrivalActivity(self.CurrentWeaponAnimation)
				end
			elseif (override == true && moveType == 1) or (self.CurrentSchedule != nil && self.CurrentSchedule.MoveType == 0) then
				local anim = self:TranslateToWeaponAnim(VJ_PICK(self.AnimTbl_ShootWhileMovingWalk))
				if VJ_AnimationExists(self,anim) == true then
					self.DoingWeaponAttack = true
					self.DoingWeaponAttack_Standing = false
					self:CapabilitiesAdd(bit.bor(CAP_MOVE_SHOOT))
					self:SetMovementActivity(anim)
					self:SetArrivalActivity(self.CurrentWeaponAnimation)
				end
			end
		end
	else -- Can't move shoot!
		self:CapabilitiesRemove(CAP_MOVE_SHOOT) -- Remove the capability if it can't even move-shoot
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IsAbleToShootWeapon(checkDistance, checkDistanceOnly, enemyDist)
	checkDistance = checkDistance or false -- Check for distance and weapon time as well?
	checkDistanceOnly = checkDistanceOnly or false -- Should it only check the above statement?
	enemyDist = enemyDist or self:EyePos():Distance(self:GetEnemy():EyePos()) -- Distance used for checkDistance
	if self:CustomOnIsAbleToShootWeapon() == false then return end
	local hasDist = false
	local hasChecks = false
	
	if self:GetWeaponState() == VJ_WEP_STATE_HOLSTERED or self.vACT_StopAttacks then return false end
	if self.VJ_IsBeingControlled == true then checkDistance = false checkDistanceOnly = false end
	if checkDistance == true && CurTime() > self.NextWeaponAttackT && enemyDist < self.Weapon_FiringDistanceFar && ((enemyDist > self.Weapon_FiringDistanceClose) or self.CurrentWeaponEntity.IsMeleeWeapon) then
		hasDist = true
	end
	if checkDistanceOnly == true then
		if hasDist == true then
			return true
		else
			return false
		end
	end
	if IsValid(self:GetActiveWeapon()) && self.AttackType != VJ_ATTACK_GRENADE && self:BusyWithActivity() == false && ((self:GetActiveWeapon().IsMeleeWeapon) or (self:GetWeaponState() != VJ_WEP_STATE_RELOADING && self.AttackType != VJ_ATTACK_MELEE && self.NearestPointToEnemyDistance > self.MeleeAttackDistance)) then
		hasChecks = true
		if checkDistance == false then return true end
	end
	if checkDistanceOnly == false && hasDist == true && hasChecks == true then return true end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SelectSchedule()
	if self.VJ_IsBeingControlled == true then return end
	self:CustomOnSchedule()
	if self.DisableSelectSchedule == true or self.Dead == true then return end
	
	local ene = self:GetEnemy()
	
	-- Idle Behavior --
	if !IsValid(ene) then
		self:IdleSoundCode()
		if self.AttackType != VJ_ATTACK_GRENADE then
			self:DoIdleAnimation()
		end
		if self.Alerted == false then
			self.TakingCoverT = 0
		end
		self.NoWeapon_UseScaredBehavior_Active = false
	-- Combat Behavior --
	else
		local wep = self:GetActiveWeapon()
		local myPos = self:GetPos()
		
		-- If the enemy is in sight then continue
		if self.LatestEnemyDistance < self:GetMaxLookDistance() then
			self:IdleSoundCode()
			
			-- Check for weapon validity
			if !IsValid(wep) then
				-- Scared behavior system
				if self.NoWeapon_UseScaredBehavior then
					if !self:IsBusy() && CurTime() > self.NextChaseTime then
						self.NoWeapon_UseScaredBehavior_Active = true -- Tells the idle system to use the scared behavior animation
						if self.IsFollowing == false && self.LastEnemyVisible then
							self:VJ_TASK_COVER_FROM_ENEMY("TASK_RUN_PATH")
							return
						end
					end
				elseif self.HasMeleeAttack then -- If it doesn't do scared behavior, then make it chase the enemy if it can melee!
					self.NoWeapon_UseScaredBehavior_Active = false -- In case it was scared, return it back to normal
					self.NextDangerDetectionT = CurTime() + 4 -- Ignore dangers while chasing!
					self:DoChaseAnimation()
					return
				end
				self:DoIdleAnimation(2)
				return
			end
			self.NoWeapon_UseScaredBehavior_Active = false -- In case it was scared, return it back to normal
			
			local enePos_Eye = ene:EyePos()
			local eneDist_Eye = self:EyePos():Distance(enePos_Eye)
			local myPosCentered = myPos + self:OBBCenter()
			local canAttack = true
			
			-- Back away from the enemy if it's to close
			if self.HasWeaponBackAway == true && (!wep.IsMeleeWeapon) && self.LatestEnemyDistance <= self.WeaponBackAway_Distance && CurTime() > self.TakingCoverT && CurTime() > self.NextChaseTime && self.AttackType == VJ_ATTACK_NONE && !self.IsFollowing && !self.VJ_PlayingSequence && ene.Behavior != VJ_BEHAVIOR_PASSIVE && self:VJ_ForwardIsHidingZone(self:NearestPoint(myPosCentered), enePos_Eye) == false then
				local moveCheck = VJ_PICK(self:VJ_CheckAllFourSides(200, true, "0111"))
				if moveCheck then
					self:SetLastPosition(moveCheck)
					if self:GetWeaponState() == VJ_WEP_STATE_RELOADING then self:SetWeaponState() end
					self.TakingCoverT = CurTime() + 2
					canAttack = false
					self:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH", function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true end)
				end
			end
			
			if canAttack && self:IsAbleToShootWeapon(false, false, eneDist_Eye) == true && self:GetState() != VJ_STATE_ONLY_ANIMATION_NOATTACK then
				-- Enemy to far away or not allowed to fire a weapon
				if eneDist_Eye > self.Weapon_FiringDistanceFar or CurTime() < self.NextWeaponAttackT then
					self:DoChaseAnimation()
					self.AllowToDo_WaitForEnemyToComeOut = false
				-- Check if enemy is in sight, then continue...
				elseif self:IsAbleToShootWeapon(true, true, eneDist_Eye) == true then
					//self:VJ_ForwardIsHidingZone(self:EyePos(), enePos_Eye, true, {Debug=true})
					-- If I can't see the enemy then either wait for it or charge at the enemy
					if self:VJ_ForwardIsHidingZone(self:EyePos(), enePos_Eye, true) == true && self:VJ_ForwardIsHidingZone(self:NearestPoint(myPosCentered) + self:GetUp()*30, enePos_Eye + self:GetUp()*30, true) /*or self:VJ_ForwardIsHidingZone(util.VJ_GetWeaponPos(self),enePos_Eye) == true*/ /*or (!self.LastEnemyVisible)*/ then
						if self:GetWeaponState() != VJ_WEP_STATE_RELOADING then
							-- Wait for the enemy to come out
							if self.WaitForEnemyToComeOut && !self.WaitingForEnemyToComeOut && (!wep.IsMeleeWeapon) && self.AllowToDo_WaitForEnemyToComeOut && ((CurTime() - self.Weapon_TimeSinceLastShot) <= 4.5) && (eneDist_Eye > self.WaitForEnemyToComeOutDistance) then
								self.WaitingForEnemyToComeOut = true
								if self.HasLostWeaponSightAnimation == true then
									self:VJ_ACT_PLAYACTIVITY(self.AnimTbl_WeaponAim, false, 0, true)
								end
								self.NextChaseTime = CurTime() + math.Rand(self.WaitForEnemyToComeOutTime.a, self.WaitForEnemyToComeOutTime.b)
							-- If I am not supposed to wait for the enemy, then go after the enemy!
							elseif /*self.DisableChasingEnemy == false &&*/ CurTime() > self.LastHiddenZoneT then
								self.DoingWeaponAttack = false
								self.DoingWeaponAttack_Standing = false
								self:DoChaseAnimation()
							end
						end
					else -- I can see the enemy...
						self.AllowToDo_WaitForEnemyToComeOut = true
						if (wep.IsVJBaseWeapon) then -- VJ Base weapons
							self:FaceCertainEntity(ene, true)
							local noAttack = false
							// self:DoChaseAnimation()
							-- if covered, try to move forward by calculating the distance between the prop and the NPC
							local cover_npc, cover_npc_tr = self:VJ_ForwardIsHidingZone(self:NearestPoint(myPosCentered), enePos_Eye, false, {SetLastHiddenTime=true})
							local cover_npc_ent = cover_npc_tr.Entity
							local cover_wep, cover_wep_tr = self:VJ_ForwardIsHidingZone(wep:GetNW2Vector("VJ_CurBulletPos"), enePos_Eye, false)
							local cover_wep_ent = cover_wep_tr.Entity
							//print("Is covered? ", cover_npc)
							//print("Is gun covered? ", cover_wep)
							local cover_npc_isObj = true -- The covered entity is NOT an NPC / Player
							if cover_npc == false or (IsValid(cover_npc_ent) and (cover_npc_ent:IsNPC() or cover_npc_ent:IsPlayer())) then
								cover_npc_isObj = false
							end
							if !wep.IsMeleeWeapon then
								-- If friendly in line of fire, then move!
								if !cover_npc_isObj && self.DoingWeaponAttack_Standing == true && CurTime() > self.TakingCoverT && IsValid(cover_wep_ent) && cover_wep_ent:IsNPC() && cover_wep_ent != self && (self:Disposition(cover_wep_ent) == D_LI or self:Disposition(cover_wep_ent) == D_NU) && cover_wep_tr.HitPos:Distance(cover_wep_tr.StartPos) <= 3000 then
									local moveCheck = VJ_PICK(self:VJ_CheckAllFourSides(50, true, "0011"))
									if moveCheck then
										self:StopMoving()
										if self.IsGuard then self.GuardingPosition = moveCheck end -- Set the guard position to this new position that avoids friendly fire
										self:SetLastPosition(moveCheck)
										self.NextChaseTime = CurTime() + 1
										self:VJ_TASK_GOTO_LASTPOS("TASK_WALK_PATH", function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true end)
									end
								end
								
								-- If the NPC is behind cover...
								if cover_npc == true then
									self.WeaponUseEnemyEyePos = true -- Make the bullet direction go towards the head of the enemy
									-- Behind cover and I am taking cover, don't fire!
									if CurTime() < self.TakingCoverT then
										noAttack = true
									elseif CurTime() > self.NextMoveOnGunCoveredT && ((cover_npc_tr.HitPos:Distance(myPos) > 150 && cover_npc_isObj == true) or (cover_wep == true && !cover_wep_ent:IsNPC() && !cover_wep_ent:IsPlayer())) then
										local nearestPos;
										local enePos;
										if IsValid(cover_npc_ent) then
											nearestPos, nearestEnePos = self:VJ_GetNearestPointToEntity(cover_npc_ent, true)
										else
											nearestPos, nearestEnePos = self:VJ_GetNearestPointToVector(cover_npc_tr.HitPos, true)
										end
										enePos = nearestEnePos - self:GetForward()*15
										if nearestPos:Distance(enePos) <= (self.IsGuard and 60 or 1000) then
											if self.IsGuard then self.GuardingPosition = enePos end -- Set the guard position to this new position that provides cover
											self:SetLastPosition(enePos)
											//VJ_CreateTestObject(enePos, self:GetAngles(), Color(0,255,255))
											local vsched = ai_vj_schedule.New("vj_goto_cover")
											vsched:EngTask("TASK_GET_PATH_TO_LASTPOSITION", 0)
											vsched:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
											vsched.IsMovingTask = true
											vsched.ConstantlyFaceEnemy = true
											vsched.StopScheduleIfNotMoving_Any = true
											local coverRunAnim = self:TranslateToWeaponAnim(VJ_PICK(self.AnimTbl_MoveToCover))
											if VJ_AnimationExists(self, coverRunAnim) == true then
												self:SetMovementActivity(coverRunAnim)
											else
												vsched.CanShootWhenMoving = true
												vsched.MoveType = 1
											end
											self:StartSchedule(vsched)
											//self:VJ_TASK_GOTO_LASTPOS("TASK_WALK_PATH",function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true end)
										end
										self.NextMoveOnGunCoveredT = CurTime() + 2
									end
								else -- NPC not covered
									self.WeaponUseEnemyEyePos = false -- Make the bullet direction go towards the center of the enemy rather then its head
								end
							end
							
							if noAttack == false && CurTime() > self.NextWeaponAttackT && CurTime() > self.NextWeaponAttackT_Base /*&& self.DoingWeaponAttack == false*/ then
								-- Melee weapons
								if (wep.IsMeleeWeapon) then
									self:CustomOnWeaponAttack()
									local finalAnim = self:TranslateToWeaponAnim(VJ_PICK(self.AnimTbl_WeaponAttack))
									if CurTime() > self.NextMeleeWeaponAttackT && VJ_AnimationExists(self, finalAnim) == true /*&& VJ_IsCurrentAnimation(self, finalAnim) == false*/ then
										local animDur = VJ_GetSequenceDuration(self, finalAnim)
										wep.NPC_NextPrimaryFire = animDur -- Make melee weapons dynamically change the next primary fire
										VJ_EmitSound(self, wep.NPC_BeforeFireSound, wep.NPC_BeforeFireSoundLevel, math.Rand(wep.NPC_BeforeFireSoundPitch.a, wep.NPC_BeforeFireSoundPitch.b))
										self.NextMeleeWeaponAttackT = CurTime() + animDur
										self.CurrentWeaponAnimation = finalAnim
										self:VJ_ACT_PLAYACTIVITY(finalAnim, false, false, true)
										self.DoingWeaponAttack = true
									end
								-- Normal ranged weapons
								else
									local hasAmmo = wep:Clip1() > 0 // AllowWeaponReloading
									if !hasAmmo && !self.CurrentWeaponAnimationIsAim then
										self.CurrentWeaponAnimation = -1
									end
									-- If the current animation is already a firing animation, then just tell the base it's already firing and do NOT restart the animation
									if VJ_IsCurrentAnimation(self, self:TranslateToWeaponAnim(self.CurrentWeaponAnimation)) == true then
										self.DoingWeaponAttack = true
										self.DoingWeaponAttack_Standing = true
									-- If the current activity isn't the last weapon animation and it's not a transition, then continue
									elseif self:GetActivity() != self.CurrentWeaponAnimation && self:GetActivity() != ACT_TRANSITION then
										self:CustomOnWeaponAttack()
										self.WaitingForEnemyToComeOut = false
										self.Weapon_TimeSinceLastShot = CurTime()
										//self.NextMoveRandomlyWhenShootingT = CurTime() + 2
										local finalAnim;
										-- Check if the NPC has ammo
										if !hasAmmo then
											finalAnim = self:TranslateToWeaponAnim(VJ_PICK(self.AnimTbl_WeaponAim))
											self.CurrentWeaponAnimationIsAim = true
										else
											local anim_crouch = self:TranslateToWeaponAnim(VJ_PICK(self.AnimTbl_WeaponAttackCrouch))
											if self.CanCrouchOnWeaponAttack == true && cover_npc == false && cover_wep == false && eneDist_Eye > 500 && VJ_AnimationExists(self, anim_crouch) == true && ((math.random(1, self.CanCrouchOnWeaponAttackChance) == 1) or (CurTime() <= self.Weapon_DoingCrouchAttackT)) && self:VJ_ForwardIsHidingZone(wep:GetNW2Vector("VJ_CurBulletPos") + self:GetUp()*-18, enePos_Eye, false) == false then
												finalAnim = anim_crouch
												self.Weapon_DoingCrouchAttackT = CurTime() + 2 -- Asiga bedke vor vestah elank yed votgi cheler hemen
											else -- Not crouching
												finalAnim = self:TranslateToWeaponAnim(VJ_PICK(self.AnimTbl_WeaponAttack))
											end
										end
										if VJ_AnimationExists(self, finalAnim) == true && ((VJ_IsCurrentAnimation(self, finalAnim) == false) or (!self.DoingWeaponAttack)) then
											VJ_EmitSound(self, wep.NPC_BeforeFireSound, wep.NPC_BeforeFireSoundLevel, math.Rand(wep.NPC_BeforeFireSoundPitch.a, wep.NPC_BeforeFireSoundPitch.b))
											self.CurrentWeaponAnimation = finalAnim
											self.NextWeaponAttackT_Base = CurTime() + 0.2
											self:VJ_ACT_PLAYACTIVITY(finalAnim, false, 0, true)
											self.DoingWeaponAttack = true
											self.DoingWeaponAttack_Standing = true
										end
									end
								end
							end
							-- Move randomly when shooting
							if self.MoveRandomlyWhenShooting && cover_npc == false && !self.IsGuard && !self.IsFollowing && (!wep.IsMeleeWeapon) && (!wep.NPC_StandingOnly) && self.DoingWeaponAttack && self.DoingWeaponAttack_Standing && CurTime() > self.NextMoveRandomlyWhenShootingT && (CurTime() - self.TimeSinceEnemyAcquired) > 2 && (eneDist_Eye < (self.Weapon_FiringDistanceFar / 1.25)) && self:VJ_ForwardIsHidingZone(self:NearestPoint(myPosCentered), enePos_Eye) == false then
								if self:CustomOnMoveRandomlyWhenShooting() != false then
									local moveCheck = VJ_PICK(self:VJ_CheckAllFourSides(math.random(150, 400), true, "0111"))
									if moveCheck then
										self:StopMoving()
										self:SetLastPosition(moveCheck)
										self:VJ_TASK_GOTO_LASTPOS(VJ_PICK({"TASK_RUN_PATH", "TASK_WALK_PATH"}), function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true end)
									end
								end
								self.NextMoveRandomlyWhenShootingT = CurTime() + math.Rand(self.NextMoveRandomlyWhenShootingTime1, self.NextMoveRandomlyWhenShootingTime2)
							end
						else -- None VJ Base weapons
							self:FaceCertainEntity(ene, true)
							self.WaitingForEnemyToComeOut = false
							self.DoingWeaponAttack = true
							self.DoingWeaponAttack_Standing = true
							self:CustomOnWeaponAttack()
							self.Weapon_TimeSinceLastShot = CurTime()
							//wep:SetClip1(99999)
							self:VJ_SetSchedule(SCHED_RANGE_ATTACK1)
						end
					end
				end
			end
		else -- Not in sight, reset the enemy
			self:ResetEnemy(false)
		end
		self.LatestEnemyDistance = ene:GetPos():Distance(myPos)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ResetEnemy(checkAlliesEnemy)
	if /*self.NextResetEnemyT > CurTime() or*/ self.Dead == true then self.EnemyReset = false return false end
	checkAlliesEnemy = checkAlliesEnemy or false
	local RunToEnemyOnReset = false
	local ene = self:GetEnemy()
	local eneValid = IsValid(ene)
	if checkAlliesEnemy == true then
		local getAllies = self:Allies_Check(1000)
		if getAllies != nil then
			for _,v in pairs(getAllies) do
				local allyEne = v:GetEnemy()
				if IsValid(allyEne) && (CurTime() - v.LastEnemyVisibleTime) < self.TimeUntilEnemyLost && VJ_IsAlive(allyEne) && self:DoRelationshipCheck(allyEne) && self:GetPos():Distance(allyEne:GetPos()) <= self:GetMaxLookDistance() then
					self:VJ_DoSetEnemy(allyEne, false)
					self.EnemyReset = false
					return false
				end
			end
		end
		local curEnemies = self.ReachableEnemyCount //self.CurrentReachableEnemies
		-- If the current number of reachable enemies is higher then 1, then don't reset
		if (eneValid && (curEnemies - 1) >= 1) or (!eneValid && curEnemies >= 1) then
			//self:VJ_DoSetEnemy(v, false, true)
			self:DoEntityRelationshipCheck() -- Select a new enemy
			self.NextProcessT = CurTime() + self.NextProcessTime
			self.EnemyReset = false
			return false
		end
	end
	
	self:SetNPCState(NPC_STATE_ALERT)
	timer.Create("timer_alerted_reset"..self:EntIndex(), math.Rand(self.AlertedToIdleTime.a, self.AlertedToIdleTime.b), 1, function() if !IsValid(self:GetEnemy()) then self.Alerted = false self:SetNPCState(NPC_STATE_IDLE) end end)
	self:CustomOnResetEnemy()
	if self.VJDEBUG_SNPC_ENABLED == true && GetConVar("vj_npc_printresetenemy"):GetInt() == 1 then print(self:GetName().." has reseted its enemy") end
	if eneValid then
		if self.IsFollowing == false && self.VJ_PlayingSequence == false && (!self.IsVJBaseSNPC_Tank) && self:GetEnemyLastKnownPos() != defPos then
			self:SetLastPosition(self:GetEnemyLastKnownPos())
			RunToEnemyOnReset = true
		end

		self:MarkEnemyAsEluded(ene)
		//self:ClearEnemyMemory(ene) // Completely resets the enemy memory
		self:AddEntityRelationship(ene, D_NU, 10)
	end
	
	self.LastHiddenZone_CanWander = CurTime() > self.LastHiddenZoneT and true or false
	self.LastHiddenZoneT = 0
	
	-- Clear memory of the enemy if it's not a player AND it's dead
	if eneValid && !ene:IsPlayer() && !VJ_IsAlive(ene) then
		//print("Clear memory", ene)
		self:ClearEnemyMemory(ene)
	end
	//self:UpdateEnemyMemory(self,self:GetPos())
	//local vsched = ai_vj_schedule.New("vj_act_resetenemy")
	//if eneValid then vsched:EngTask("TASK_FORGET", ene) end
	//vsched:EngTask("TASK_IGNORE_OLD_ENEMIES", 0)
	self.NextWanderTime = CurTime() + math.Rand(3, 5)
	-- This is needed for the human base because when taking cover from enemy, the AI can get stuck in a loop (EX: When self.NoWeapon_UseScaredBehavior_Active is true!)
	local curSched = self.CurrentSchedule
	if (curSched != nil && (curSched.Name == "vj_cover_from_enemy" or curSched.Name == "vj_cover_from_enemy_fail")) then
		self:StopMoving()
	end
	if !self:IsBusy() && !self.IsGuard && self.Behavior != VJ_BEHAVIOR_PASSIVE && self.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE && self.VJ_IsBeingControlled == false && RunToEnemyOnReset == true && self.LastHiddenZone_CanWander == true && !self.NoWeapon_UseScaredBehavior_Active then
		//ParticleEffect("explosion_turret_break", self.LatestEnemyPosition, Angle(0,0,0))
		self:SetMovementActivity(VJ_PICK(self.AnimTbl_Walk))
		local vsched = ai_vj_schedule.New("vj_act_resetenemy")
		vsched:EngTask("TASK_GET_PATH_TO_LASTPOSITION", 0)
		//vsched:EngTask("TASK_WALK_PATH", 0)
		vsched:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
		vsched.ResetOnFail = true
		vsched.CanShootWhenMoving = true
		vsched.ConstantlyFaceEnemy = true
		vsched.CanBeInterrupted = true
		vsched.IsMovingTask = true
		vsched.MoveType = 0
		//self.NextIdleTime = CurTime() + 10
		self:StartSchedule(vsched)
	end
	//if vsched.TaskCount > 0 then
		//self:StartSchedule(vsched)
	//end
	self:SetEnemy(NULL)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage(dmginfo)
	local dmgInflictor = dmginfo:GetInflictor()
	local dmgAttacker = dmginfo:GetAttacker()
	local dmgType = dmginfo:GetDamageType()
	local hitgroup = self:GetLastDamageHitGroup()
	if IsValid(dmgInflictor) && dmgInflictor:GetClass() == "prop_ragdoll" && dmgInflictor:GetVelocity():Length() <= 100 then return 0 end
	self:CustomOnTakeDamage_BeforeImmuneChecks(dmginfo, hitgroup)
	if self.GodMode == true or dmginfo:GetDamage() <= 0 then return 0 end
	if self:IsOnFire() && self:WaterLevel() == 2 then self:Extinguish() end -- If we are in water, then extinguish the fire
	
	-- If it should always take damage from huge monsters, then skip immunity checks!
	if self.GetDamageFromIsHugeMonster == true && dmgAttacker.VJ_IsHugeMonster == true then
		goto skip_immunity
	end
	if VJ_HasValue(self.ImmuneDamagesTable, dmgType) then return 0 end
	if self.AllowIgnition == false && self:IsOnFire() && IsValid(dmgInflictor) && IsValid(dmgAttacker) && dmgInflictor:GetClass() == "entityflame" && dmgAttacker:GetClass() == "entityflame" then self:Extinguish() return 0 end
	if self.Immune_Fire == true && (dmgType == DMG_BURN or dmgType == DMG_SLOWBURN or (self:IsOnFire() && IsValid(dmgInflictor) && IsValid(dmgAttacker) && dmgInflictor:GetClass() == "entityflame" && dmgAttacker:GetClass() == "entityflame")) then return 0 end
	if (self.Immune_AcidPoisonRadiation == true && (dmgType == DMG_ACID or dmgType == DMG_RADIATION or dmgType == DMG_POISON or dmgType == DMG_NERVEGAS or dmgType == DMG_PARALYZE)) or (self.Immune_Bullet == true && (dmginfo:IsBulletDamage() or dmgType == DMG_BULLET or dmgType == DMG_AIRBOAT or dmgType == DMG_BUCKSHOT)) or (self.Immune_Blast == true && (dmgType == DMG_BLAST or dmgType == DMG_BLAST_SURFACE)) or (self.Immune_Dissolve == true && dmgType == DMG_DISSOLVE) or (self.Immune_Electricity == true && (dmgType == DMG_SHOCK or dmgType == DMG_ENERGYBEAM or dmgType == DMG_PHYSGUN)) or (self.Immune_Melee == true && (dmgType == DMG_CLUB or dmgType == DMG_SLASH)) or (self.Immune_Physics == true && dmgType == DMG_CRUSH) or (self.Immune_Sonic == true && dmgType == DMG_SONIC) then return 0 end
	if (IsValid(dmgInflictor) && dmgInflictor:GetClass() == "prop_combine_ball") or (IsValid(dmgAttacker) && dmgAttacker:GetClass() == "prop_combine_ball") then
		if self.Immune_Dissolve == true then return 0 end
		-- Make sure combine ball does reasonable damage and doesn't spam it!
		if CurTime() > self.NextCanGetCombineBallDamageT then
			dmginfo:SetDamage(math.random(400,500))
			dmginfo:SetDamageType(DMG_DISSOLVE)
			self.NextCanGetCombineBallDamageT = CurTime() + 0.2
		else
			return 0
		end
	end

	::skip_immunity::
	local function DoBleed()
		if self.Bleeds == true then
			self:CustomOnTakeDamage_OnBleed(dmginfo, hitgroup)
			-- Spawn the blood particle only if it's not caused by the default fire entity [Causes the damage position to be at Vector(0, 0, 0)]
			if self.HasBloodParticle == true && ((!self:IsOnFire()) or (self:IsOnFire() && IsValid(dmgInflictor) && IsValid(dmgAttacker) && dmgInflictor:GetClass() != "entityflame" && dmgAttacker:GetClass() != "entityflame")) then self:SpawnBloodParticles(dmginfo, hitgroup) end
			if self.HasBloodDecal == true then self:SpawnBloodDecal(dmginfo, hitgroup) end
			self:PlaySoundSystem("Impact", nil, VJ_EmitSound)
		end
	end
	if self.Dead == true then DoBleed() return 0 end -- If dead then just bleed but take no damage
	
	self:CustomOnTakeDamage_BeforeDamage(dmginfo, hitgroup)
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
	if self.VJDEBUG_SNPC_ENABLED == true && GetConVar("vj_npc_printondamage"):GetInt() == 1 then print(self:GetClass().." Got Damaged! | Amount = "..dmginfo:GetDamage()) end
	if self.HasHealthRegeneration == true && self.HealthRegenerationResetOnDmg == true then
		self.HealthRegenerationDelayT = CurTime() + (math.Rand(self.HealthRegenerationDelay.a, self.HealthRegenerationDelay.b) * 1.5)
	end
	self:SetSaveValue("m_iDamageCount", self:GetSaveTable().m_iDamageCount + 1)
	self:SetSaveValue("m_flLastDamageTime", CurTime())
	self:CustomOnTakeDamage_AfterDamage(dmginfo, hitgroup)
	DoBleed()
	
	-- I/O events, from: https://github.com/ValveSoftware/source-sdk-2013/blob/0d8dceea4310fde5706b3ce1c70609d72a38efdf/sp/src/game/server/ai_basenpc.cpp#L764
	if IsValid(dmgAttacker) then
		self:TriggerOutput("OnDamaged", dmgAttacker)
		self:MarkTookDamageFromEnemy(dmgAttacker)
	else
		self:TriggerOutput("OnDamaged", self)
	end
	
	local stillAlive = self:Health() > 0
	if stillAlive then self:PlaySoundSystem("Pain") end

	if GetConVar("ai_disabled"):GetInt() == 0 && self:GetState() != VJ_STATE_FREEZE then
		-- Make passive NPCs run and their allies as well
		if (self.Behavior == VJ_BEHAVIOR_PASSIVE or self.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE) && CurTime() > self.TakingCoverT then
			if self.Passive_RunOnDamage == true && stillAlive then -- Don't run if not allowed or dead
				self:VJ_TASK_COVER_FROM_ORIGIN("TASK_RUN_PATH")
			end
			if self.Passive_AlliesRunOnDamage == true then -- Make passive allies run
				local allies = self:Allies_Check(self.Passive_AlliesRunOnDamageDistance)
				if allies != nil then
					for _,v in pairs(allies) do
						v.TakingCoverT = CurTime() + math.Rand(v.Passive_NextRunOnDamageTime.b, v.Passive_NextRunOnDamageTime.a)
						v:VJ_TASK_COVER_FROM_ORIGIN("TASK_RUN_PATH")
						v:PlaySoundSystem("Alert")
					end
				end
			end
			self.TakingCoverT = CurTime() + math.Rand(self.Passive_NextRunOnDamageTime.a, self.Passive_NextRunOnDamageTime.b)
		end

		if stillAlive then
			self:DoFlinch(dmginfo, hitgroup)
			
			-- Damage by Player
				-- 0 = Run it every time | 1 = Run it only when friendly to player | 2 = Run it only when enemy to player
			if self.HasDamageByPlayer && dmgAttacker:IsPlayer() && CurTime() > self.NextDamageByPlayerT && self:Visible(dmgAttacker) && (self.DamageByPlayerDispositionLevel == 0 or (self.DamageByPlayerDispositionLevel == 1 && (self:Disposition(dmgAttacker) == D_LI or self:Disposition(dmgAttacker) == D_NU)) or (self.DamageByPlayerDispositionLevel == 2 && self:Disposition(dmgAttacker) != D_LI && self:Disposition(dmgAttacker) != D_NU)) then
				self:CustomOnDamageByPlayer(dmginfo, hitgroup)
				self:PlaySoundSystem("DamageByPlayer")
				self.NextDamageByPlayerT = CurTime() + math.Rand(self.DamageByPlayerTime.a, self.DamageByPlayerTime.b)
			end
			
			self:PlaySoundSystem("Pain")
			
			if self.MoveOrHideOnDamageByEnemy == true && self.Behavior != VJ_BEHAVIOR_PASSIVE && self.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE && IsValid(self:GetEnemy()) && CurTime() > self.NextMoveOrHideOnDamageByEnemyT && self:EyePos():Distance(self:GetEnemy():EyePos()) < self.Weapon_FiringDistanceFar && IsValid(self:GetEnemy()) && self.IsFollowing == false && self.Behavior != VJ_BEHAVIOR_PASSIVE && self.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE && self.AttackType == VJ_ATTACK_NONE && CurTime() > self.TakingCoverT && self.LastEnemyVisible && self.VJ_IsBeingControlled == false && self:GetWeaponState() != VJ_WEP_STATE_RELOADING then
				local wep = self:GetActiveWeapon()
				if self:VJ_ForwardIsHidingZone(self:NearestPoint(self:GetPos() + self:OBBCenter()),self:GetEnemy():EyePos()) == true && self.MoveOrHideOnDamageByEnemy_OnlyMove == false then
					//self:VJ_ACT_TAKE_COVER(self.AnimTbl_MoveOrHideOnDamageByEnemy,false,math.Rand(self.MoveOrHideOnDamageByEnemy_HideTime.a, self.MoveOrHideOnDamageByEnemy_HideTime.b),false)
					local anim = VJ_PICK(self:TranslateToWeaponAnim(VJ_PICK(self.AnimTbl_TakingCover)))
					if VJ_AnimationExists(self, anim) == true then
						local hidet = math.Rand(self.MoveOrHideOnDamageByEnemy_HideTime.a, self.MoveOrHideOnDamageByEnemy_HideTime.b)
						self:VJ_ACT_PLAYACTIVITY(anim, false, hidet, false, 0, {SequenceDuration=hidet}) -- Don't set stopActivities because we want it to shoot if the enemy is suddenly visible!
						self.NextChaseTime = CurTime() + hidet
						self.TakingCoverT = CurTime() + hidet
						self.DoingWeaponAttack = false
					end
					self.NextMoveOrHideOnDamageByEnemyT = CurTime() + math.random(self.NextMoveOrHideOnDamageByEnemy1,self.NextMoveOrHideOnDamageByEnemy2)
				elseif !self:IsMoving() && (!IsValid(wep) or (IsValid(wep) && !wep.IsMeleeWeapon)) then
					self:VJ_TASK_COVER_FROM_ENEMY("TASK_RUN_PATH",function(x) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true end)
					self.NextMoveOrHideOnDamageByEnemyT = CurTime() + math.random(self.NextMoveOrHideOnDamageByEnemy1,self.NextMoveOrHideOnDamageByEnemy2)
				end
			end

			if self.CallForBackUpOnDamage == true && CurTime() > self.NextCallForBackUpOnDamageT && self.AttackType != VJ_ATTACK_GRENADE && !IsValid(self:GetEnemy()) && self.IsFollowing == false && self.Behavior != VJ_BEHAVIOR_PASSIVE && self.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE && ((!IsValid(dmgInflictor)) or (IsValid(dmgInflictor) && dmgInflictor:GetClass() != "entityflame")) && IsValid(dmgAttacker) && dmgAttacker:GetClass() != "entityflame" then
				local allies = self:Allies_Check(self.CallForBackUpOnDamageDistance)
				if allies != nil then
					self:Allies_Bring("Diamond",self.CallForBackUpOnDamageDistance,allies,self.CallForBackUpOnDamageLimit)
					self:ClearSchedule()
					self.NextFlinchT = CurTime() + 1
					local pickanim = VJ_PICK(self.CallForBackUpOnDamageAnimation)
					if VJ_AnimationExists(self,pickanim) == true && self.DisableCallForBackUpOnDamageAnimation == false then
						self:VJ_ACT_PLAYACTIVITY(pickanim,true,self:DecideAnimationLength(pickanim,self.CallForBackUpOnDamageAnimationTime),true, 0, {PlayBackRateCalculated=true})
					elseif !self:BusyWithActivity() then
						self:VJ_TASK_COVER_FROM_ORIGIN("TASK_RUN_PATH",function(x) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true end)
						//self:VJ_SetSchedule(SCHED_RUN_FROM_ENEMY)
						/*local vschedHide = ai_vj_schedule.New("vj_hide_callbackupondamage")
						vschedHide:EngTask("TASK_FIND_COVER_FROM_ENEMY", 0)
						vschedHide:EngTask("TASK_RUN_PATH", 0)
						vschedHide:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
						vschedHide.ResetOnFail = true
						self:StartSchedule(vschedHide)*/
					end
					self.NextCallForBackUpOnDamageT = CurTime() + math.Rand(self.NextCallForBackUpOnDamageTime.a, self.NextCallForBackUpOnDamageTime.b)
				end
			end

			if self.BecomeEnemyToPlayer == true && self.VJ_IsBeingControlled == false && dmgAttacker:IsPlayer() && GetConVar("ai_ignoreplayers"):GetInt() == 0 && self:Disposition(dmgAttacker) == D_LI then
				self.AngerLevelTowardsPlayer = self.AngerLevelTowardsPlayer + 1
				if self.AngerLevelTowardsPlayer > self.BecomeEnemyToPlayerLevel then
					if self:Disposition(dmgAttacker) != D_HT then
						self:CustomWhenBecomingEnemyTowardsPlayer(dmginfo, hitgroup)
						if self.IsFollowing == true && self.FollowData.Ent == dmgAttacker then self:FollowReset() end
						self.VJ_AddCertainEntityAsEnemy[#self.VJ_AddCertainEntityAsEnemy+1] = dmgAttacker
						self:AddEntityRelationship(dmgAttacker,D_HT,2)
						self.TakingCoverT = CurTime() + 2
						if !IsValid(self:GetEnemy()) then
							self:StopMoving()
							self:SetTarget(dmgAttacker)
							self:VJ_TASK_FACE_X("TASK_FACE_TARGET")
						end
						if self.AllowPrintingInChat == true then
							dmgAttacker:PrintMessage(HUD_PRINTTALK, self:GetName().." no longer likes you.")
						end
						self:PlaySoundSystem("BecomeEnemyToPlayer")
					end
					self.Alerted = true
					self:SetNPCState(NPC_STATE_ALERT)
				end
			end

			if self.DisableTakeDamageFindEnemy == false && self:BusyWithActivity() == false && !IsValid(self:GetEnemy()) && CurTime() > self.TakingCoverT && self.VJ_IsBeingControlled == false && self.Behavior != VJ_BEHAVIOR_PASSIVE && self.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE /*&& self.Alerted == false*/ then
				local sightdist = self:GetMaxLookDistance() / 2 -- Gesvadz tive
				-- Yete gesvadz tive hazaren aveli kich e, ere vor chi ges e tive...
				-- Yete tive 2000 - 4000 mechene, ere vor mishd 2000 ela...
				-- Yete 4000 aveli e, ere vor gesvadz tive kordzadz e
				if sightdist <= 1000 then
					sightdist = self:GetMaxLookDistance()
				else
					sightdist = math_clamp(sightdist,2000,self:GetMaxLookDistance())
				end
				local Targets = ents.FindInSphere(self:GetPos(),sightdist)
				for _,v in pairs(Targets) do
					if CurTime() > self.NextSetEnemyOnDamageT && self:Visible(v) && self:DoRelationshipCheck(v) == true then
						self:CustomOnSetEnemyOnDamage(dmginfo, hitgroup)
						self.NextCallForHelpT = CurTime() + 1
						self:VJ_DoSetEnemy(v,true)
						self:DoChaseAnimation()
						self.NextSetEnemyOnDamageT = CurTime() + 1
					else
						//self:Allies_CallHelp(self.CallForHelpDistance)
						if CurTime() > self.NextRunAwayOnDamageT then
							if self.IsFollowing == false && self.RunAwayOnUnknownDamage == true && self.MovementType != VJ_MOVETYPE_STATIONARY then
								self:VJ_TASK_COVER_FROM_ORIGIN("TASK_RUN_PATH",function(x) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true end)
								//self:VJ_SetSchedule(SCHED_RUN_FROM_ENEMY)
								/*local vschedHide = ai_vj_schedule.New("vj_hide_unknowndamage")
								vschedHide:EngTask("TASK_FIND_COVER_FROM_ENEMY", 0)
								vschedHide:EngTask("TASK_RUN_PATH", 0)
								vschedHide:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
								vschedHide.ResetOnFail = true
								self:StartSchedule(vschedHide)*/
							end
							self.NextRunAwayOnDamageT = CurTime() + self.NextRunAwayOnDamageTime
						end
					end
				end
			end
		end
	end
	
	-- If eating, stop!
	if self.CanEat && self.VJTags[VJ_TAG_EATING] then
		self.EatingData.NextCheck = CurTime() + 15
		self:EatingReset("Injured")
	end
	
	if self:Health() <= 0 && self.Dead == false then
		self:RemoveEFlags(EFL_NO_DISSOLVE)
		if (dmginfo:IsDamageType(DMG_DISSOLVE)) or (IsValid(dmgInflictor) && dmgInflictor:GetClass() == "prop_combine_ball") then
			local dissolve = DamageInfo()
			dissolve:SetDamage(self:Health())
			dissolve:SetAttacker(dmgAttacker)
			dissolve:SetDamageType(DMG_DISSOLVE)
			self:TakeDamageInfo(dissolve)
		end
		self:PriorToKilled(dmginfo, hitgroup)
	end
	return 1
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vecZ500 = Vector(0, 0, 500)
local vecZ4 = Vector(0, 0, 4)
--
function ENT:PriorToKilled(dmginfo, hitgroup)
	self:CustomOnInitialKilled(dmginfo, hitgroup)
	if self.Medic_IsHealingAlly == true then self:DoMedicReset() end
	local dmgInflictor = dmginfo:GetInflictor()
	local dmgAttacker = dmginfo:GetAttacker()
	
	local allies = self:Allies_Check(math.max(800, self.BringFriendsOnDeathDistance, self.AlertFriendsOnDeathDistance))
	if allies != nil then
		local noAlert = true -- Don't run the AlertFriendsOnDeath if we have BringFriendsOnDeath enabled!
		if self.BringFriendsOnDeath == true then
			self:Allies_Bring("Diamond", self.BringFriendsOnDeathDistance, allies, self.BringFriendsOnDeathLimit, true)
			noAlert = false
		end
		local doBecomeEnemyToPlayer = (self.BecomeEnemyToPlayer == true && dmgAttacker:IsPlayer() && GetConVar("ai_disabled"):GetInt() == 0 && GetConVar("ai_ignoreplayers"):GetInt() == 0) or false
		local it = 0 -- Number of allies that have been alerted
		for _,v in pairs(allies) do
			v:CustomOnAllyDeath(self)
			v:PlaySoundSystem("AllyDeath")
			
			-- AlertFriendsOnDeath
			if noAlert == true && self.AlertFriendsOnDeath == true && !IsValid(v:GetEnemy()) && v.AlertFriendsOnDeath == true && it != self.AlertFriendsOnDeathLimit && self:GetPos():Distance(v:GetPos()) < self.AlertFriendsOnDeathDistance && (!IsValid(v:GetActiveWeapon()) or (IsValid(v:GetActiveWeapon()) && !(v:GetActiveWeapon().IsMeleeWeapon))) then
				it = it + 1
				v:FaceCertainPosition(self:GetPos(), 1)
				v:VJ_ACT_PLAYACTIVITY(VJ_PICK(v.AnimTbl_AlertFriendsOnDeath))
				v.NextIdleTime = CurTime() + math.Rand(5, 8)
			end
			
			-- BecomeEnemyToPlayer
			if doBecomeEnemyToPlayer && v.BecomeEnemyToPlayer == true && v:Disposition(dmgAttacker) == D_LI then
				v.AngerLevelTowardsPlayer = v.AngerLevelTowardsPlayer + 1
				if v.AngerLevelTowardsPlayer > v.BecomeEnemyToPlayerLevel then
					if v:Disposition(dmgAttacker) != D_HT then
						v:CustomWhenBecomingEnemyTowardsPlayer(dmginfo, hitgroup)
						if v.IsFollowing == true && v.FollowData.Ent == dmgAttacker then v:FollowReset() end
						v.VJ_AddCertainEntityAsEnemy[#v.VJ_AddCertainEntityAsEnemy+1] = dmgAttacker
						v:AddEntityRelationship(dmgAttacker,D_HT,2)
						if v.AllowPrintingInChat == true then
							dmgAttacker:PrintMessage(HUD_PRINTTALK, v:GetName().." no longer likes you.")
						end
						v:PlaySoundSystem("BecomeEnemyToPlayer")
					end
					v.Alerted = true
				end
			end
		end
	end
	
	local function DoKilled()
		if IsValid(self) then
			if self.WaitBeforeDeathTime == 0 then
				self:OnKilled(dmginfo, hitgroup)
			else
				timer.Simple(self.WaitBeforeDeathTime, function()
					if IsValid(self) then
						self:OnKilled(dmginfo, hitgroup)
					end
				end)
			end
		end
	end
	
	-- Blood decal on the ground
	if self.Bleeds == true && self.HasBloodDecal == true then
		local bloodDecal = VJ_PICK(self.CustomBlood_Decal)
		if bloodDecal != false then
			local decalPos = self:GetPos() + vecZ4
			self:SetLocalPos(decalPos) -- NPC is too close to the ground, we need to move it up a bit
			local tr = util.TraceLine({
				start = decalPos,
				endpos = decalPos - vecZ500,
				filter = self
			})
			util.Decal(bloodDecal, tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
		end
	end
	
	self.Dead = true
	if self.IsFollowing == true then self:FollowReset() end
	self:RemoveTimers()
	self.AttackType = VJ_ATTACK_NONE
	self.MeleeAttacking = false
	self.HasMeleeAttack = false
	self:StopAllCommonSounds()
	if IsValid(dmgAttacker) then
		if dmgAttacker:GetClass() == "npc_barnacle" then self.HasDeathRagdoll = false end -- Don't make a corpse if it's killed by a barnacle!
		if GetConVar("vj_npc_addfrags"):GetInt() == 1 && dmgAttacker:IsPlayer() then dmgAttacker:AddFrags(1) end
		if IsValid(dmgInflictor) then
			gamemode.Call("OnNPCKilled", self, dmgAttacker, dmgInflictor, dmginfo)
		end
	end
	self:CustomOnPriorToKilled(dmginfo, hitgroup)
	self:SetCollisionGroup(1)
	self:RunGibOnDeathCode(dmginfo, hitgroup)
	self:PlaySoundSystem("Death")
	//self:AA_StopMoving()
	
	-- I/O events, from: https://github.com/ValveSoftware/source-sdk-2013/blob/0d8dceea4310fde5706b3ce1c70609d72a38efdf/mp/src/game/server/basecombatcharacter.cpp#L1582
	if IsValid(dmgAttacker) then -- Someone else killed me
		self:TriggerOutput("OnDeath", dmgAttacker)
		dmgAttacker:Fire("KilledNPC", "", 0, self, self) -- Allows player companions (npc_citizen) to respond to kill
	else
		self:TriggerOutput("OnDeath", self)
	end
	
	if self.HasDeathAnimation == true && !dmginfo:IsDamageType(DMG_REMOVENORAGDOLL) then
		if IsValid(dmgInflictor) && dmgInflictor:GetClass() == "prop_combine_ball" then DoKilled() return end
		if GetConVar("vj_npc_nodeathanimation"):GetInt() == 0 && GetConVar("ai_disabled"):GetInt() == 0 && !dmginfo:IsDamageType(DMG_DISSOLVE) && math.random(1, self.DeathAnimationChance) == 1 then
			self:RemoveAllGestures()
			self:CustomDeathAnimationCode(dmginfo, hitgroup)
			local pickanim = VJ_PICK(self.AnimTbl_Death)
			local animTime = self:DecideAnimationLength(pickanim, self.DeathAnimationTime) - self.DeathAnimationDecreaseLengthAmount
			self:VJ_ACT_PLAYACTIVITY(pickanim, true, animTime, false, 0, {PlayBackRateCalculated=true})
			self.DeathAnimationCodeRan = true
			timer.Simple(animTime, DoKilled)
		else
			DoKilled()
		end
	else
		DoKilled()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnKilled(dmginfo, hitgroup)
	if self.VJDEBUG_SNPC_ENABLED == true && GetConVar("vj_npc_printdied"):GetInt() == 1 then print(self:GetClass().." Died!") end
	self:CustomOnKilled(dmginfo, hitgroup)
	self:RunItemDropsOnDeathCode(dmginfo, hitgroup) -- Item drops on death
	self:ClearEnemyMemory()
	//self:ClearSchedule()
	//self:SetNPCState(NPC_STATE_DEAD)
	if bit.band(self.SavedDmgInfo.type, DMG_REMOVENORAGDOLL) == 0 then self:DropWeaponOnDeathCode(dmginfo, hitgroup) self:CreateDeathCorpse(dmginfo, hitgroup) end
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
	
	self:CustomOnDeath_BeforeCorpseSpawned(dmginfo, hitgroup)
	if self.HasDeathRagdoll == true then
		local corpseMdl = self:GetModel()
		local corpseMdlCustom = VJ_PICK(self.DeathCorpseModel)
		if corpseMdlCustom != false then corpseMdl = corpseMdlCustom end
		local corpseType = "prop_physics"
		if self.DeathCorpseEntityClass == "UseDefaultBehavior" then
			if util.IsValidRagdoll(corpseMdl) == true then
				corpseType = "prop_ragdoll"
			elseif util.IsValidProp(corpseMdl) == false or util.IsValidModel(corpseMdl) == false then
				if IsValid(self.TheDroppedWeapon) then self.TheDroppedWeapon:Remove() end
				return false
			end
		else
			corpseType = self.DeathCorpseEntityClass
		end
		//if self.VJCorpseDeleted == true then
		self.Corpse = ents.Create(corpseType) //end
		self.Corpse:SetModel(corpseMdl)
		self.Corpse:SetPos(self:GetPos())
		self.Corpse:SetAngles(self:GetAngles())
		self.Corpse:Spawn()
		self.Corpse:Activate()
		self.Corpse:SetColor(self:GetColor())
		self.Corpse:SetMaterial(self:GetMaterial())
		if corpseMdlCustom == false && self.DeathCorpseSubMaterials != nil then -- Take care of sub materials
			for _, x in ipairs(self.DeathCorpseSubMaterials) do
				if self:GetSubMaterial(x) != "" then
					self.Corpse:SetSubMaterial(x, self:GetSubMaterial(x))
				end
			end
			 -- This causes lag, not a very good way to do it.
			/*for x = 0, #self:GetMaterials() do
				if self:GetSubMaterial(x) != "" then
					self.Corpse:SetSubMaterial(x, self:GetSubMaterial(x))
				end
			end*/
		end
		//self.Corpse:SetName("self.Corpse" .. self:EntIndex())
		//self.Corpse:SetModelScale(self:GetModelScale())
		self.Corpse.FadeCorpseType = (self.Corpse:GetClass() == "prop_ragdoll" and "FadeAndRemove") or "kill"
		self.Corpse.IsVJBaseCorpse = true
		self.Corpse.DamageInfo = dmginfo
		self.Corpse.ExtraCorpsesToRemove = self.ExtraCorpsesToRemove_Transition
		self.Corpse.BloodData = {Color = self.BloodColor, Particle = self.CustomBlood_Particle, Decal = self.CustomBlood_Decal}

		if self.Bleeds == true && self.HasBloodPool == true && GetConVar("vj_npc_nobloodpool"):GetInt() == 0 then
			self:SpawnBloodPool(dmginfo, hitgroup)
		end
		
		-- Collision --
		self.Corpse:SetCollisionGroup(self.DeathCorpseCollisionType)
		if GetConVar("ai_serverragdolls"):GetInt() == 1 then
			undo.ReplaceEntity(self, self.Corpse)
		else -- Keep corpses is not enabled...
			VJ_AddCorpse(self.Corpse)
			//hook.Call("VJ_CreateSNPCCorpse", nil, self.Corpse, self)
			if GetConVar("vj_npc_undocorpse"):GetInt() == 1 then undo.ReplaceEntity(self, self.Corpse) end -- Undoable
		end
		cleanup.ReplaceEntity(self, self.Corpse) -- Delete on cleanup
		
		-- Miscellaneous --
		self.Corpse:SetSkin((self.DeathCorpseSkin == -1 and self:GetSkin()) or self.DeathCorpseSkin)
		
		if self.DeathCorpseSetBodyGroup == true then -- Yete asega true-e, ooremen gerna bodygroup tenel
			for i = 0,18 do -- 18 = Bodygroup limit
				self.Corpse:SetBodygroup(i,self:GetBodygroup(i))
			end
			if self.DeathCorpseBodyGroup.a != -1 then -- Yete asiga nevaz meg chene, user-in teradz tevere kordzadze
				self.Corpse:SetBodygroup(self.DeathCorpseBodyGroup.a, self.DeathCorpseBodyGroup.b)
			end
		end
		
		if self:IsOnFire() then -- If was on fire then...
			self.Corpse:Ignite(math.Rand(8, 10), 0)
			self.Corpse:SetColor(colorGrey)
			//self.Corpse:SetMaterial("models/props_foliage/tree_deciduous_01a_trunk")
		end
		//gamemode.Call("CreateEntityRagdoll",self,self.Corpse)

		-- Dissolve --
		if (bit.band(self.SavedDmgInfo.type, DMG_DISSOLVE) != 0) or (IsValid(self.SavedDmgInfo.inflictor) && self.SavedDmgInfo.inflictor:GetClass() == "prop_combine_ball") then
			self.Corpse:SetName("vj_dissolve_corpse")
			local dissolver = ents.Create("env_entity_dissolver")
			dissolver:SetPos(self.Corpse:GetPos())
			dissolver:Spawn()
			dissolver:Activate()
			//dissolver:SetKeyValue("target","vj_dissolve_corpse")
			dissolver:SetKeyValue("magnitude",100)
			dissolver:SetKeyValue("dissolvetype",0)
			dissolver:Fire("Dissolve","vj_dissolve_corpse")
			if IsValid(self.TheDroppedWeapon) then
				self.TheDroppedWeapon:SetName("vj_dissolve_weapon")
				dissolver:Fire("Dissolve","vj_dissolve_weapon")
			end
			dissolver:Fire("Kill", "", 0.1)
			//dissolver:Remove()
		end
		
		-- Bone and Angle --
		-- If it's a bullet, it will use localized velocity on each bone depending on how far away the bone is from the dmg position
		local useLocalVel = (bit.band(self.SavedDmgInfo.type, DMG_BULLET) != 0 and self.SavedDmgInfo.pos != defPos) or false
		local dmgForce = (self.SavedDmgInfo.force / 40) + self:GetMoveVelocity() + self:GetVelocity()
		if self.DeathAnimationCodeRan then
			useLocalVel = false
			dmgForce = self:GetMoveVelocity() == defPos and self:GetGroundSpeedVelocity() or self:GetMoveVelocity()
		end
		local totalSurface = 0
		for boneLimit = 0, self.Corpse:GetPhysicsObjectCount() - 1 do -- 128 = Bone Limit
			local childphys = self.Corpse:GetPhysicsObjectNum(boneLimit)
			if IsValid(childphys) then
				totalSurface = totalSurface + childphys:GetSurfaceArea()
				local childphys_bonepos, childphys_boneang = self:GetBonePosition(self.Corpse:TranslatePhysBoneToBone(boneLimit))
				if (childphys_bonepos) then
					//if math.Round(math.abs(childphys_boneang.r)) != 90 then -- Fixes ragdolls rotating, no longer needed!    --->    sv_pvsskipanimation 0
						if self.DeathCorpseSetBoneAngles == true then childphys:SetAngles(childphys_boneang) end
						childphys:SetPos(childphys_bonepos)
					//end
					if self.Corpse:GetName() == "vj_dissolve_corpse" then
						childphys:EnableGravity(false)
						childphys:SetVelocity(self:GetForward()*-150 + self:GetRight()*math.Rand(100,-100) + self:GetUp()*50)
					else
						if self.DeathCorpseApplyForce == true /*&& self.DeathAnimationCodeRan == false*/ then
							childphys:SetVelocity(dmgForce / math.max(1, (useLocalVel and childphys_bonepos:Distance(self.SavedDmgInfo.pos)/12) or 1))
						end
					end
				end
			end
		end
		
		if self.Corpse:Health() <= 0 then
			local hpCalc = totalSurface / 60 // self.Corpse:OBBMaxs():Distance(self.Corpse:OBBMins())
			self.Corpse:SetMaxHealth(hpCalc)
			self.Corpse:SetHealth(hpCalc)
		end
		VJ_AddStinkyEnt(self.Corpse, true)
	
		if IsValid(self.TheDroppedWeapon) then self.Corpse.ExtraCorpsesToRemove[#self.Corpse.ExtraCorpsesToRemove+1] = self.TheDroppedWeapon end
		if self.DeathCorpseFade == true then self.Corpse:Fire(self.Corpse.FadeCorpseType,"",self.DeathCorpseFadeTime) end
		if GetConVar("vj_npc_corpsefade"):GetInt() == 1 then self.Corpse:Fire(self.Corpse.FadeCorpseType,"",GetConVar("vj_npc_corpsefadetime"):GetInt()) end
		self:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, self.Corpse)
		self.Corpse:CallOnRemove("vj_"..self.Corpse:EntIndex(),function(ent,exttbl)
			for _,v in ipairs(exttbl) do
				if IsValid(v) then
					if v:GetClass() == "prop_ragdoll" then v:Fire("FadeAndRemove","",0) else v:Fire("kill","",0) end
				end
			end
		end,self.Corpse.ExtraCorpsesToRemove)
		hook.Call("CreateEntityRagdoll", nil, self, self.Corpse)
		return self.Corpse
	else
		if IsValid(self.TheDroppedWeapon) then self.TheDroppedWeapon:Remove() end
		for _,v in ipairs(self.ExtraCorpsesToRemove_Transition) do
			if v.IsVJBase_Gib == true && v.RemoveOnCorpseDelete == true then
				v:Remove()
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local wepDropTbl1 = {weapon_ar2=true, weapon_vj_ar2=true, weapon_vj_blaster=true, weapon_pistol=true, weapon_vj_9mmpistol=true, weapon_vj_357=true, weapon_shotgun=true, weapon_vj_spas12=true, weapon_annabelle=true, weapon_rpg = true}
local wepDropTbl2 = {weapon_crowbar=true, weapon_stunstick=true}
local wepAng180y = Angle(0, 180, 0)
local wepAng90x = Angle(90, 0, 0)
--
function ENT:DropWeaponOnDeathCode(dmginfo, hitgroup)
	if self.DropWeaponOnDeath != true or !IsValid(self:GetActiveWeapon()) /*or dmginfo:IsDamageType(DMG_DISSOLVE)*/ then return end
	
	self:CustomOnDropWeapon(dmginfo, hitgroup)
	
	-- Rotate the weapon for certain guns
	self.CurrentWeaponEntity = self:GetActiveWeapon()
	local gunang = defAng
	if wepDropTbl1[self.CurrentWeaponEntity:GetClass()] == true then
		gunang = wepAng180y
	elseif wepDropTbl2[self.CurrentWeaponEntity:GetClass()] == true then
		gunang = wepAng90x
	end

	local getAttach = false -- true = Found an attachment on the NPC's model
	if !self.CurrentWeaponEntity.WorldModel_UseCustomPosition then
		for _,v in ipairs(self:GetAttachments()) do
			if v.name == self.DropWeaponOnDeathAttachment then
				getAttach = self:GetAttachment(self:LookupAttachment(self.DropWeaponOnDeathAttachment))
				break
			end
		end
	end

	self.TheDroppedWeapon = ents.Create(self.CurrentWeaponEntity:GetClass())
	if getAttach != false then
		self.TheDroppedWeapon:SetPos(getAttach.Pos)
	else
		self.TheDroppedWeapon:SetPos(self.CurrentWeaponEntity:GetPos())
	end
	if getAttach != false then
		self.TheDroppedWeapon:SetAngles(getAttach.Ang + gunang)
	else
		self.TheDroppedWeapon:SetAngles(self.CurrentWeaponEntity:GetAngles() + gunang)
	end
	self.TheDroppedWeapon:Spawn()
	self.TheDroppedWeapon:Activate()
	local phys = self.TheDroppedWeapon:GetPhysicsObject()
	if IsValid(phys) then
		if (bit.band(self.SavedDmgInfo.type, DMG_DISSOLVE) != 0) or (IsValid(self.SavedDmgInfo.inflictor) && self.SavedDmgInfo.inflictor:GetClass() == "prop_combine_ball") then
			phys:EnableGravity(false)
			phys:SetVelocity(self:GetForward()*-150 + self:GetRight()*math.Rand(100,-100) + self:GetUp()*50)
		else
			local dmgForce = (self.SavedDmgInfo.force / 40) + self:GetMoveVelocity() + self:GetVelocity()
			if self.DeathAnimationCodeRan then
				dmgForce = self:GetMoveVelocity() == defPos and self:GetGroundSpeedVelocity() or self:GetMoveVelocity()
			end
			phys:SetMass(1)
			phys:ApplyForceCenter(dmgForce)
		end
	end
	self:CustomOnDropWeapon_AfterWeaponSpawned(dmginfo, hitgroup, self.TheDroppedWeapon)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PlaySoundSystem(sdSet, customSd, sdType)
	if self.HasSounds == false or sdSet == nil then return end
	sdType = sdType or VJ_CreateSound
	local cTbl = VJ_PICK(customSd)
	
	if sdSet == "GeneralSpeech" then -- Used to just play general speech sounds (Custom by developers)
		if cTbl != false then
			self:StopAllCommonSpeechSounds()
			self.NextIdleSoundT_RegularChange = CurTime() + ((((SoundDuration(cTbl) > 0) and SoundDuration(cTbl)) or 2) + 1)
			self.CurrentGeneralSpeechSound = sdType(self, cTbl, 80, self:VJ_DecideSoundPitch(self.GeneralSoundPitch1, self.GeneralSoundPitch2))
		end
		return
	elseif sdSet == "FollowPlayer" then
		if self.HasFollowPlayerSounds_Follow == true then
			local sdtbl = VJ_PICK(self.SoundTbl_FollowPlayer)
			if (math.random(1, self.FollowPlayerSoundChance) == 1 && sdtbl != false) or (cTbl != false) then
				if cTbl != false then sdtbl = cTbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(3, 4)
				self.CurrentFollowPlayerSound = sdType(self, sdtbl, self.FollowPlayerSoundLevel, self:VJ_DecideSoundPitch(self.FollowPlayerPitch.a, self.FollowPlayerPitch.b))
			end
		end
		return
	elseif sdSet == "UnFollowPlayer" then
		if self.HasFollowPlayerSounds_UnFollow == true then
			local sdtbl = VJ_PICK(self.SoundTbl_UnFollowPlayer)
			if (math.random(1, self.UnFollowPlayerSoundChance) == 1 && sdtbl != false) or (cTbl != false) then
				if cTbl != false then sdtbl = cTbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(3, 4)
				self.CurrentUnFollowPlayerSound = sdType(self, sdtbl, self.UnFollowPlayerSoundLevel, self:VJ_DecideSoundPitch(self.UnFollowPlayerPitch.a, self.UnFollowPlayerPitch.b))
			end
		end
		return
	elseif sdSet == "OnReceiveOrder" then
		if self.HasOnReceiveOrderSounds == true then
			local sdtbl = VJ_PICK(self.SoundTbl_OnReceiveOrder)
			if (math.random(1, self.OnReceiveOrderSoundChance) == 1 && sdtbl != false) or (cTbl != false) then
				if cTbl != false then sdtbl = cTbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT = self.NextIdleSoundT + 2
				self.NextAlertSoundT = CurTime() + 2
				self.CurrentOnReceiveOrderSound = sdType(self, sdtbl, self.OnReceiveOrderSoundLevel, self:VJ_DecideSoundPitch(self.OnReceiveOrderSoundPitch.a, self.OnReceiveOrderSoundPitch.b))
			end
		end
		return
	elseif sdSet == "MoveOutOfPlayersWay" then
		if self.HasMoveOutOfPlayersWaySounds == true then
			local sdtbl = VJ_PICK(self.SoundTbl_MoveOutOfPlayersWay)
			if (math.random(1, self.MoveOutOfPlayersWaySoundChance) == 1 && sdtbl != false) or (cTbl != false) then
				if cTbl != false then sdtbl = cTbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(3, 4)
				self.CurrentMoveOutOfPlayersWaySound = sdType(self, sdtbl, self.MoveOutOfPlayersWaySoundLevel, self:VJ_DecideSoundPitch(self.MoveOutOfPlayersWaySoundPitch.a, self.MoveOutOfPlayersWaySoundPitch.b))
			end
		end
		return
	elseif sdSet == "MedicBeforeHeal" then
		if self.HasMedicSounds_BeforeHeal == true then
			local sdtbl = VJ_PICK(self.SoundTbl_MedicBeforeHeal)
			if (math.random(1, self.MedicBeforeHealSoundChance) == 1 && sdtbl != false) or (cTbl != false) then
				if cTbl != false then sdtbl = cTbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(3, 4)
				self.CurrentMedicBeforeHealSound = sdType(self, sdtbl, self.BeforeHealSoundLevel, self:VJ_DecideSoundPitch(self.BeforeHealSoundPitch.a, self.BeforeHealSoundPitch.b))
			end
		end
		return
	elseif sdSet == "MedicOnHeal" then
		if self.HasMedicSounds_AfterHeal == true then
			local sdtbl = VJ_PICK(self.SoundTbl_MedicAfterHeal)
			if sdtbl == false then sdtbl = VJ_PICK(DefaultSoundTbl_MedicAfterHeal) end -- Default table
			if (math.random(1, self.MedicAfterHealSoundChance) == 1 && sdtbl != false) or (cTbl != false) then
				if cTbl != false then sdtbl = cTbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(3, 4)
				self.CurrentMedicAfterHealSound = sdType(self, sdtbl, self.AfterHealSoundLevel, self:VJ_DecideSoundPitch(self.AfterHealSoundPitch.a, self.AfterHealSoundPitch.b))
			end
		end
		return
	elseif sdSet == "MedicReceiveHeal" then
		if self.HasMedicSounds_ReceiveHeal == true then
			local sdtbl = VJ_PICK(self.SoundTbl_MedicReceiveHeal)
			if (math.random(1, self.MedicReceiveHealSoundChance) == 1 && sdtbl != false) or (cTbl != false) then
				if cTbl != false then sdtbl = cTbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(3, 4)
				self.CurrentMedicReceiveHealSound = sdType(self, sdtbl, self.MedicReceiveHealSoundLevel, self:VJ_DecideSoundPitch(self.MedicReceiveHealSoundPitch.a, self.MedicReceiveHealSoundPitch.b))
			end
		end
		return
	elseif sdSet == "OnPlayerSight" then
		if self.HasOnPlayerSightSounds == true then
			local sdtbl = VJ_PICK(self.SoundTbl_OnPlayerSight)
			if (math.random(1, self.OnPlayerSightSoundChance) == 1 && sdtbl != false) or (cTbl != false) then
				if cTbl != false then sdtbl = cTbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(3, 4)
				self.NextAlertSoundT = CurTime() + math.random(1,2)
				self.CurrentOnPlayerSightSound = sdType(self, sdtbl, self.OnPlayerSightSoundLevel, self:VJ_DecideSoundPitch(self.OnPlayerSightSoundPitch.a, self.OnPlayerSightSoundPitch.b))
			end
		end
		return
	elseif sdSet == "InvestigateSound" then
		if self.HasInvestigateSounds == true && CurTime() > self.NextInvestigateSoundT then
			local sdtbl = VJ_PICK(self.SoundTbl_Investigate)
			if (math.random(1, self.InvestigateSoundChance) == 1 && sdtbl != false) or (cTbl != false) then
				if cTbl != false then sdtbl = cTbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT = self.NextIdleSoundT + 2
				self.CurrentInvestigateSound = sdType(self, sdtbl, self.InvestigateSoundLevel, self:VJ_DecideSoundPitch(self.InvestigateSoundPitch.a, self.InvestigateSoundPitch.b))
			end
			self.NextInvestigateSoundT = CurTime() + math.Rand(self.NextSoundTime_Investigate.a, self.NextSoundTime_Investigate.b)
		end
		return
	elseif sdSet == "LostEnemy" then
		if self.HasLostEnemySounds == true && CurTime() > self.LostEnemySoundT then
			local sdtbl = VJ_PICK(self.SoundTbl_LostEnemy)
			if (math.random(1, self.LostEnemySoundChance) == 1 && sdtbl != false) or (cTbl != false) then
				if cTbl != false then sdtbl = cTbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT = self.NextIdleSoundT + 2
				self.CurrentLostEnemySound = sdType(self, sdtbl, self.LostEnemySoundLevel, self:VJ_DecideSoundPitch(self.LostEnemySoundPitch.a, self.LostEnemySoundPitch.b))
			end
			self.LostEnemySoundT = CurTime() + math.Rand(self.NextSoundTime_LostEnemy.a, self.NextSoundTime_LostEnemy.b)
		end
		return
	elseif sdSet == "Alert" then
		if self.HasAlertSounds == true then
			local sdtbl = VJ_PICK(self.SoundTbl_Alert)
			if (math.random(1, self.AlertSoundChance) == 1 && sdtbl != false) or (cTbl != false) then
				if cTbl != false then sdtbl = cTbl end
				self:StopAllCommonSpeechSounds()
				local dur = CurTime() + ((((SoundDuration(sdtbl) > 0) and SoundDuration(sdtbl)) or 2) + 1)
				self.NextIdleSoundT = dur
				self.PainSoundT = dur
				self.NextSuppressingSoundT = CurTime() + 4
				self.NextAlertSoundT = CurTime() + math.Rand(self.NextSoundTime_Alert.a, self.NextSoundTime_Alert.b)
				self.CurrentAlertSound = sdType(self, sdtbl, self.AlertSoundLevel, self:VJ_DecideSoundPitch(self.AlertSoundPitch.a, self.AlertSoundPitch.b))
			end
		end
		return
	elseif sdSet == "CallForHelp" then
		if self.HasCallForHelpSounds == true && CurTime() > self.NextCallForHelpSoundT then
			local sdtbl = VJ_PICK(self.SoundTbl_CallForHelp)
			if (math.random(1, self.CallForHelpSoundChance) == 1 && sdtbl != false) or (cTbl != false) then
				if cTbl != false then sdtbl = cTbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT = self.NextIdleSoundT + 2
				self.NextSuppressingSoundT = CurTime() + math.random(2.5, 4)
				self.CurrentCallForHelpSound = sdType(self, sdtbl, self.CallForHelpSoundLevel, self:VJ_DecideSoundPitch(self.CallForHelpSoundPitch.a, self.CallForHelpSoundPitch.b))
				self.NextCallForHelpSoundT = CurTime() + 2
			end
		end
		return
	elseif sdSet == "BecomeEnemyToPlayer" then
		if self.HasBecomeEnemyToPlayerSounds == true then
			local sdtbl = VJ_PICK(self.SoundTbl_BecomeEnemyToPlayer)
			if (math.random(1, self.BecomeEnemyToPlayerChance) == 1 && sdtbl != false) or (cTbl != false) then
				if cTbl != false then sdtbl = cTbl end
				self:StopAllCommonSpeechSounds()
				timer.Simple(0.05,function() if IsValid(self) then VJ_STOPSOUND(self.CurrentPainSound) end end)
				//timer.Simple(1.3,function() if IsValid(self) then VJ_STOPSOUND(self.CurrentAlertSound) end end)
				local dur = CurTime() + ((((SoundDuration(sdtbl) > 0) and SoundDuration(sdtbl)) or 2) + 1)
				self.PainSoundT = dur
				self.NextAlertSoundT = dur
				self.NextInvestigateSoundT = CurTime() + 2
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(2, 3)
				self.NextSuppressingSoundT = CurTime() + math.random(2.5, 4)
				self.CurrentBecomeEnemyToPlayerSound = sdType(self, sdtbl, self.BecomeEnemyToPlayerSoundLevel, self:VJ_DecideSoundPitch(self.BecomeEnemyToPlayerPitch.a, self.BecomeEnemyToPlayerPitch.b))
			end
		end
		return
	elseif sdSet == "OnKilledEnemy" then
		if self.HasOnKilledEnemySound == true && CurTime() > self.OnKilledEnemySoundT then
			local sdtbl = VJ_PICK(self.SoundTbl_OnKilledEnemy)
			if (math.random(1, self.OnKilledEnemySoundChance) == 1 && sdtbl != false) or (cTbl != false) then
				if cTbl != false then sdtbl = cTbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT = self.NextIdleSoundT + 2
				self.CurrentOnKilledEnemySound = sdType(self, sdtbl, self.OnKilledEnemySoundLevel, self:VJ_DecideSoundPitch(self.OnKilledEnemySoundPitch.a, self.OnKilledEnemySoundPitch.b))
			end
			self.OnKilledEnemySoundT = CurTime() + math.Rand(self.NextSoundTime_OnKilledEnemy.a, self.NextSoundTime_OnKilledEnemy.b)
		end
		return
	elseif sdSet == "AllyDeath" then
		if self.HasOnKilledEnemySound == true && CurTime() > self.AllyDeathSoundT then
			local sdtbl = VJ_PICK(self.SoundTbl_AllyDeath)
			if (math.random(1, self.AllyDeathSoundChance) == 1 && sdtbl != false) or (cTbl != false) then
				if cTbl != false then sdtbl = cTbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT = self.NextIdleSoundT + 2
				self.CurrentAllyDeathSound = sdType(self, sdtbl, self.AllyDeathSoundLevel, self:VJ_DecideSoundPitch(self.AllyDeathSoundPitch.a, self.AllyDeathSoundPitch.b))
			end
			self.AllyDeathSoundT = CurTime() + math.Rand(self.NextSoundTime_AllyDeath.a, self.NextSoundTime_AllyDeath.b)
		end
		return
	elseif sdSet == "Pain" then
		if self.HasPainSounds == true && CurTime() > self.PainSoundT then
			local sdtbl = VJ_PICK(self.SoundTbl_Pain)
			local sdDur = 2
			if (math.random(1, self.PainSoundChance) == 1 && sdtbl != false) or (cTbl != false) then
				if cTbl != false then sdtbl = cTbl end
				self:StopAllCommonSpeechSounds()
				VJ_STOPSOUND(self.CurrentIdleSound)
				self.NextIdleSoundT_RegularChange = CurTime() + 1
				self.CurrentPainSound = sdType(self, sdtbl, self.PainSoundLevel, self:VJ_DecideSoundPitch(self.PainSoundPitch.a, self.PainSoundPitch.b))
				sdDur = (SoundDuration(sdtbl) > 0 and SoundDuration(sdtbl)) or sdDur
			end
			self.PainSoundT = CurTime() + ((self.NextSoundTime_Pain == true and sdDur) or math.Rand(self.NextSoundTime_Pain.a, self.NextSoundTime_Pain.b))
		end
		return
	elseif sdSet == "Impact" then
		if self.HasImpactSounds == true then
			local sdtbl = VJ_PICK(self.SoundTbl_Impact)
			if sdtbl == false then sdtbl = VJ_PICK(DefaultSoundTbl_Impact) end -- Default table
			if (math.random(1, self.ImpactSoundChance) == 1 && sdtbl != false) or (cTbl != false) then
				if cTbl != false then sdtbl = cTbl end
				self.CurrentImpactSound = sdType(self, sdtbl, self.ImpactSoundLevel, self:VJ_DecideSoundPitch(self.ImpactSoundPitch.a, self.ImpactSoundPitch.b))
			end
		end
		return
	elseif sdSet == "DamageByPlayer" then
		if self.HasDamageByPlayerSounds == true && CurTime() > self.NextDamageByPlayerSoundT then
			local sdtbl = VJ_PICK(self.SoundTbl_DamageByPlayer)
			if (math.random(1, self.DamageByPlayerSoundChance) == 1 && sdtbl != false) or (cTbl != false) then
				if cTbl != false then sdtbl = cTbl end
				self:StopAllCommonSpeechSounds()
				local dur = CurTime() + ((((SoundDuration(sdtbl) > 0) and SoundDuration(sdtbl)) or 2) + 1)
				self.PainSoundT = dur
				self.NextIdleSoundT_RegularChange = CurTime() + dur
				timer.Simple(0.05, function() if IsValid(self) then VJ_STOPSOUND(self.CurrentPainSound) end end)
				self.CurrentDamageByPlayerSound = sdType(self, sdtbl, self.DamageByPlayerSoundLevel, self:VJ_DecideSoundPitch(self.DamageByPlayerPitch.a, self.DamageByPlayerPitch.b))
			end
			self.NextDamageByPlayerSoundT = CurTime() + math.Rand(self.NextSoundTime_DamageByPlayer.a, self.NextSoundTime_DamageByPlayer.b)
		end
		return
	elseif sdSet == "Death" then
		if self.HasDeathSounds == true then
			local sdtbl = VJ_PICK(self.SoundTbl_Death)
			if (math.random(1, self.DeathSoundChance) == 1 && sdtbl != false) or (cTbl != false) then
				if cTbl != false then sdtbl = cTbl end
				self.CurrentDeathSound = sdType(self, sdtbl, self.DeathSoundLevel, self:VJ_DecideSoundPitch(self.DeathSoundPitch.a, self.DeathSoundPitch.b))
			end
		end
		return
	--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-- Base-Specific Sound Tables --=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
	elseif sdSet == "Suppressing" then
		if self.HasSuppressingSounds == true && CurTime() > self.NextSuppressingSoundT then
			local sdtbl = VJ_PICK(self.SoundTbl_Suppressing)
			if (math.random(1, self.SuppressingSoundChance) == 1 && sdtbl != false) or (cTbl != false) then
				if cTbl != false then sdtbl = cTbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT_RegularChange = CurTime() + 2
				self.CurrentSuppressingSound = sdType(self, sdtbl, self.SuppressingSoundLevel, self:VJ_DecideSoundPitch(self.SuppressingPitch.a, self.SuppressingPitch.b))
			end
			self.NextSuppressingSoundT = CurTime() + math.Rand(self.NextSoundTime_Suppressing.a, self.NextSoundTime_Suppressing.b)
		end
		return
	elseif sdSet == "WeaponReload" then
		if self.HasWeaponReloadSounds == true && CurTime() > self.NextWeaponReloadSoundT then
			local sdtbl = VJ_PICK(self.SoundTbl_WeaponReload)
			if (math.random(1, self.WeaponReloadSoundChance) == 1 && sdtbl != false) or (cTbl != false) then
				if cTbl != false then sdtbl = cTbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(3, 4)
				self.CurrentWeaponReloadSound = sdType(self, sdtbl, self.WeaponReloadSoundLevel, self:VJ_DecideSoundPitch(self.WeaponReloadSoundPitch.a, self.WeaponReloadSoundPitch.b))
			end
			self.NextWeaponReloadSoundT = CurTime() + math.Rand(self.NextSoundTime_WeaponReload.a, self.NextSoundTime_WeaponReload.b)
		end
		return
	elseif sdSet == "BeforeMeleeAttack" then
		if self.HasMeleeAttackSounds == true then
			local sdtbl = VJ_PICK(self.SoundTbl_BeforeMeleeAttack)
			if (math.random(1, self.BeforeMeleeAttackSoundChance) == 1 && sdtbl != false) or (cTbl != false) then
				if cTbl != false then sdtbl = cTbl end
				if self.IdleSounds_PlayOnAttacks == false then VJ_STOPSOUND(self.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
				self.NextIdleSoundT_RegularChange = CurTime() + 1
				self.CurrentBeforeMeleeAttackSound = sdType(self, sdtbl, self.BeforeMeleeAttackSoundLevel, self:VJ_DecideSoundPitch(self.BeforeMeleeAttackSoundPitch.a, self.BeforeMeleeAttackSoundPitch.b))
			end
		end
		return
	elseif sdSet == "MeleeAttack" then
		if self.HasMeleeAttackSounds == true then
			local sdtbl = VJ_PICK(self.SoundTbl_MeleeAttack)
			if sdtbl == false then sdtbl = VJ_PICK(self.DefaultSoundTbl_MeleeAttack) end -- Default table
			if (math.random(1, self.MeleeAttackSoundChance) == 1 && sdtbl != false) or (cTbl != false) then
				if cTbl != false then sdtbl = cTbl end
				if self.IdleSounds_PlayOnAttacks == false then VJ_STOPSOUND(self.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
				self.NextIdleSoundT_RegularChange = CurTime() + 1
				self.CurrentMeleeAttackSound = sdType(self, sdtbl, self.MeleeAttackSoundLevel, self:VJ_DecideSoundPitch(self.MeleeAttackSoundPitch.a, self.MeleeAttackSoundPitch.b))
			end
			if self.HasExtraMeleeAttackSounds == true then
				sdtbl = VJ_PICK(self.SoundTbl_MeleeAttackExtra)
				if (math.random(1, self.ExtraMeleeSoundChance) == 1 && sdtbl != false) or (cTbl != false) then
					if self.IdleSounds_PlayOnAttacks == false then VJ_STOPSOUND(self.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
					self.CurrentExtraMeleeAttackSound = VJ_EmitSound(self, sdtbl, self.ExtraMeleeAttackSoundLevel, self:VJ_DecideSoundPitch(self.ExtraMeleeSoundPitch.a, self.ExtraMeleeSoundPitch.b))
				end
			end
		end
		return
	elseif sdSet == "MeleeAttackMiss" then
		if self.HasMeleeAttackMissSounds == true then
			local sdtbl = VJ_PICK(self.SoundTbl_MeleeAttackMiss)
			if sdtbl == false then sdtbl = VJ_PICK(DefaultSoundTbl_MeleeAttackMiss) end -- Default table
			if (math.random(1, self.MeleeAttackMissSoundChance) == 1 && sdtbl != false) or (cTbl != false) then
				if cTbl != false then sdtbl = cTbl end
				VJ_STOPSOUND(self.CurrentIdleSound)
				self.NextIdleSoundT_RegularChange = CurTime() + 1
				self.CurrentMeleeAttackMissSound = sdType(self, sdtbl, self.MeleeAttackMissSoundLevel, self:VJ_DecideSoundPitch(self.MeleeAttackMissSoundPitch.a, self.MeleeAttackMissSoundPitch.b))
			end
		end
		return
	elseif sdSet == "GrenadeAttack" then
		if self.HasGrenadeAttackSounds == true && CurTime() > self.NextGrenadeAttackSoundT then
			local sdtbl = VJ_PICK(self.SoundTbl_GrenadeAttack)
			if (math.random(1, self.GrenadeAttackSoundChance) == 1 && sdtbl != false) or (cTbl != false) then
				if cTbl != false then sdtbl = cTbl end
				if self.IdleSounds_PlayOnAttacks == false then self:StopAllCommonSpeechSounds() end -- Don't stop idle sounds if we aren't suppose to
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(3, 4)
				self.CurrentGrenadeAttackSound = sdType(self, sdtbl, self.GrenadeAttackSoundLevel, self:VJ_DecideSoundPitch(self.GrenadeAttackSoundPitch.a, self.GrenadeAttackSoundPitch.b))
			end
		end
		return
	elseif sdSet == "OnGrenadeSight" then
		if self.HasOnGrenadeSightSounds == true && CurTime() > self.NextOnGrenadeSightSoundT then
			local sdtbl = VJ_PICK(self.SoundTbl_OnGrenadeSight)
			if (math.random(1, self.OnGrenadeSightSoundChance) == 1 && sdtbl != false) or (cTbl != false) then
				if cTbl != false then sdtbl = cTbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(3, 4)
				self.CurrentOnGrenadeSightSound = sdType(self, sdtbl, self.OnGrenadeSightSoundLevel, self:VJ_DecideSoundPitch(self.OnGrenadeSightSoundPitch.a, self.OnGrenadeSightSoundPitch.b))
			end
			self.NextOnGrenadeSightSoundT = CurTime() + math.Rand(self.NextSoundTime_OnGrenadeSight.a, self.NextSoundTime_OnGrenadeSight.b)
		end
		return
	elseif sdSet == "OnDangerSight" then
		if self.HasOnDangerSightSounds == true && CurTime() > self.NextOnDangerSightSoundT then
			local sdtbl = VJ_PICK(self.SoundTbl_OnDangerSight)
			if (math.random(1, self.OnDangerSightSoundChance) == 1 && sdtbl != false) or (cTbl != false) then
				if cTbl != false then sdtbl = cTbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(3, 4)
				self.CurrentOnDangerSightSound = sdType(self, sdtbl, self.OnDangerSightSoundLevel, self:VJ_DecideSoundPitch(self.OnDangerSightSoundPitch.a, self.OnDangerSightSoundPitch.b))
			end
			self.NextOnDangerSightSoundT = CurTime() + math.Rand(self.NextSoundTime_OnDangerSight.a, self.NextSoundTime_OnDangerSight.b)
		end
		return
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FootStepSoundCode(CustomTbl)
	if self.HasSounds == false or self.HasFootStepSound == false or self.MovementType == VJ_MOVETYPE_STATIONARY then return end
	if self:IsOnGround() && self:GetGroundEntity() != NULL then
		if self.DisableFootStepSoundTimer == true then
			self:CustomOnFootStepSound()
			local soundtbl = self.SoundTbl_FootStep
			if CustomTbl != nil && #CustomTbl != 0 then soundtbl = CustomTbl end
			if VJ_PICK(soundtbl) == false then soundtbl = DefaultSoundTbl_FootStep end
			VJ_EmitSound(self,soundtbl,self.FootStepSoundLevel,self:VJ_DecideSoundPitch(self.FootStepPitch.a,self.FootStepPitch.b))
			if self.HasWorldShakeOnMove == true then util.ScreenShake(self:GetPos(), self.WorldShakeOnMoveAmplitude, self.WorldShakeOnMoveFrequency, self.WorldShakeOnMoveDuration, self.WorldShakeOnMoveRadius) end
			return
		elseif self:IsMoving() && CurTime() > self.FootStepT && self:GetInternalVariable("m_flMoveWaitFinished") <= 0 then
			self:CustomOnFootStepSound()
			local soundtbl = self.SoundTbl_FootStep
			if CustomTbl != nil && #CustomTbl != 0 then soundtbl = CustomTbl end
			if VJ_PICK(soundtbl) == false then soundtbl = DefaultSoundTbl_FootStep end
			local curSched = self.CurrentSchedule
			if self.DisableFootStepOnRun == false && ((VJ_HasValue(self.AnimTbl_Run,self:GetMovementActivity())) or (curSched != nil  && curSched.MoveType == 1)) /*(VJ_HasValue(VJ_RunActivites,self:GetMovementActivity()) or VJ_HasValue(self.CustomRunActivites,self:GetMovementActivity()))*/ then
				self:CustomOnFootStepSound_Run()
				VJ_EmitSound(self,soundtbl,self.FootStepSoundLevel,self:VJ_DecideSoundPitch(self.FootStepPitch.a,self.FootStepPitch.b))
				if self.HasWorldShakeOnMove == true then util.ScreenShake(self:GetPos(), self.WorldShakeOnMoveAmplitude, self.WorldShakeOnMoveFrequency, self.WorldShakeOnMoveDuration, self.WorldShakeOnMoveRadius) end
				self.FootStepT = CurTime() + self.FootStepTimeRun
				return
			elseif self.DisableFootStepOnWalk == false && (VJ_HasValue(self.AnimTbl_Walk,self:GetMovementActivity()) or (curSched != nil  && curSched.MoveType == 0)) /*(VJ_HasValue(VJ_WalkActivites,self:GetMovementActivity()) or VJ_HasValue(self.CustomWalkActivites,self:GetMovementActivity()))*/ then
				self:CustomOnFootStepSound_Walk()
				VJ_EmitSound(self,soundtbl,self.FootStepSoundLevel,self:VJ_DecideSoundPitch(self.FootStepPitch.a,self.FootStepPitch.b))
				if self.HasWorldShakeOnMove == true then util.ScreenShake(self:GetPos(), self.WorldShakeOnMoveAmplitude, self.WorldShakeOnMoveFrequency, self.WorldShakeOnMoveDuration, self.WorldShakeOnMoveRadius) end
				self.FootStepT = CurTime() + self.FootStepTimeWalk
				return
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StopAllCommonSpeechSounds()
	VJ_STOPSOUND(self.CurrentGeneralSpeechSound)
	VJ_STOPSOUND(self.CurrentIdleSound)
	VJ_STOPSOUND(self.CurrentIdleDialogueAnswerSound)
	VJ_STOPSOUND(self.CurrentInvestigateSound)
	VJ_STOPSOUND(self.CurrentLostEnemySound)
	VJ_STOPSOUND(self.CurrentAlertSound)
	VJ_STOPSOUND(self.CurrentFollowPlayerSound)
	VJ_STOPSOUND(self.CurrentUnFollowPlayerSound)
	VJ_STOPSOUND(self.CurrentMoveOutOfPlayersWaySound)
	VJ_STOPSOUND(self.CurrentBecomeEnemyToPlayerSound)
	VJ_STOPSOUND(self.CurrentOnPlayerSightSound)
	VJ_STOPSOUND(self.CurrentDamageByPlayerSound)
	VJ_STOPSOUND(self.CurrentOnGrenadeSightSound)
	VJ_STOPSOUND(self.CurrentOnDangerSightSound)
	VJ_STOPSOUND(self.CurrentWeaponReloadSound)
	VJ_STOPSOUND(self.CurrentMedicBeforeHealSound)
	VJ_STOPSOUND(self.CurrentMedicAfterHealSound)
	VJ_STOPSOUND(self.CurrentMedicReceiveHealSound)
	VJ_STOPSOUND(self.CurrentCallForHelpSound)
	VJ_STOPSOUND(self.CurrentOnReceiveOrderSound)
	VJ_STOPSOUND(self.CurrentOnKilledEnemySound)
	VJ_STOPSOUND(self.CurrentAllyDeathSound)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StopAllCommonSounds()
	VJ_STOPSOUND(self.CurrentGeneralSpeechSound)
	VJ_STOPSOUND(self.CurrentBreathSound)
	VJ_STOPSOUND(self.CurrentIdleSound)
	VJ_STOPSOUND(self.CurrentIdleDialogueAnswerSound)
	VJ_STOPSOUND(self.CurrentInvestigateSound)
	VJ_STOPSOUND(self.CurrentLostEnemySound)
	VJ_STOPSOUND(self.CurrentAlertSound)
	VJ_STOPSOUND(self.CurrentBeforeMeleeAttackSound)
	//VJ_STOPSOUND(self.CurrentMeleeAttackSound)
	//VJ_STOPSOUND(self.CurrentExtraMeleeAttackSound)
	//VJ_STOPSOUND(self.CurrentMeleeAttackMissSound)
	VJ_STOPSOUND(self.CurrentPainSound)
	VJ_STOPSOUND(self.CurrentFollowPlayerSound)
	VJ_STOPSOUND(self.CurrentUnFollowPlayerSound)
	VJ_STOPSOUND(self.CurrentMoveOutOfPlayersWaySound)
	VJ_STOPSOUND(self.CurrentBecomeEnemyToPlayerSound)
	VJ_STOPSOUND(self.CurrentOnPlayerSightSound)
	VJ_STOPSOUND(self.CurrentDamageByPlayerSound)
	VJ_STOPSOUND(self.CurrentGrenadeAttackSound)
	VJ_STOPSOUND(self.CurrentOnGrenadeSightSound)
	VJ_STOPSOUND(self.CurrentOnDangerSightSound)
	VJ_STOPSOUND(self.CurrentSuppressingSound)
	VJ_STOPSOUND(self.CurrentWeaponReloadSound)
	VJ_STOPSOUND(self.CurrentMedicBeforeHealSound)
	VJ_STOPSOUND(self.CurrentMedicAfterHealSound)
	VJ_STOPSOUND(self.CurrentMedicReceiveHealSound)
	VJ_STOPSOUND(self.CurrentCallForHelpSound)
	VJ_STOPSOUND(self.CurrentOnReceiveOrderSound)
	VJ_STOPSOUND(self.CurrentOnKilledEnemySound)
	VJ_STOPSOUND(self.CurrentAllyDeathSound)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetAttackSpread(wep, target)
	return
end