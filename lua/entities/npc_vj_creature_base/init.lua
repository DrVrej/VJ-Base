if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
AddCSLuaFile("shared.lua")
include("vj_base/npc_general.lua")
include("vj_base/npc_schedules.lua")
include("vj_base/npc_movetype_aa.lua")
include("shared.lua")
/*--------------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AccessorFunc(ENT, "m_iClass", "NPCClass", FORCE_NUMBER)
AccessorFunc(ENT, "m_fMaxYawSpeed", "MaxYawSpeed", FORCE_NUMBER)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Core Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.Model = {} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.VJ_IsHugeMonster = false -- Is this a huge monster?
	-- This is mostly used for massive or boss SNPCs, it affects certain part of the SNPC, for example the SNPC won't receive any knock back
	-- ====== Health ====== --
ENT.StartHealth = 50 -- The starting health of the NPC
ENT.HasHealthRegeneration = false -- Can the SNPC regenerate its health?
ENT.HealthRegenerationAmount = 4 -- How much should the health increase after every delay?
ENT.HealthRegenerationDelay = VJ_Set(2,4) -- How much time until the health increases
ENT.HealthRegenerationResetOnDmg = true -- Should the delay reset when it receives damage?
	-- ====== Collision / Hitbox Variables ====== --
ENT.HullType = HULL_HUMAN
ENT.HasHull = true -- Set to false to disable HULL
ENT.HullSizeNormal = true -- set to false to cancel out the self:SetHullSizeNormal()
ENT.HasSetSolid = true -- set to false to disable SetSolid
	-- ====== Sight & Speed Variables ====== --
ENT.SightDistance = 10000 -- How far it can see
ENT.SightAngle = 80 -- The sight angle | Example: 180 would make the it see all around it | Measured in degrees and then converted to radians
ENT.TurningSpeed = 20 -- How fast it can turn
ENT.TurningUseAllAxis = false -- If set to true, angles will not be restricted to y-axis, it will change all axes (plural axis)
ENT.AnimationPlaybackRate = 1 -- Controls the playback rate of all the animations
	-- ====== Movement Variables ====== --
	-- Types: VJ_MOVETYPE_GROUND | VJ_MOVETYPE_AERIAL | VJ_MOVETYPE_AQUATIC | VJ_MOVETYPE_STATIONARY | VJ_MOVETYPE_PHYSICS
ENT.MovementType = VJ_MOVETYPE_GROUND -- How does the SNPC move?
ENT.MaxJumpLegalDistance = VJ_Set(400, 550) -- The max distance the NPC can jump (Usually from one node to another) | ( UP, DOWN )
	-- Stationary Move Type Variables:
ENT.CanTurnWhileStationary = true -- If true, the NPC will be able to turn while it's stationary
ENT.Stationary_UseNoneMoveType = false -- Technical variable, used if there is any issues with the NPC's position (It has its downsides, use only when needed!)
	-- Aerial Move Type Variables:
ENT.Aerial_FlyingSpeed_Calm = 80 -- The speed it should fly with, when it's wandering, moving slowly, etc. | Basically walking compared to ground SNPCs
ENT.Aerial_FlyingSpeed_Alerted = 200 -- The speed it should fly with, when it's chasing an enemy, moving away quickly, etc. | Basically running compared to ground SNPCs
ENT.Aerial_AnimTbl_Calm = {} -- Animations it plays when it's wandering around while idle
ENT.Aerial_AnimTbl_Alerted = {} -- Animations it plays when it's moving while alerted
	-- Aquatic Move Type Variables:
ENT.Aquatic_SwimmingSpeed_Calm = 80 -- The speed it should swim with, when it's wandering, moving slowly, etc. | Basically walking compared to ground SNPCs
ENT.Aquatic_SwimmingSpeed_Alerted = 200 -- The speed it should swim with, when it's chasing an enemy, moving away quickly, etc. | Basically running compared to ground SNPCs
ENT.Aquatic_AnimTbl_Calm = {} -- Animations it plays when it's wandering around while idle
ENT.Aquatic_AnimTbl_Alerted = {} -- Animations it plays when it's moving while alerted
	-- Aerial & Aquatic Move Type Variables:
ENT.AA_GroundLimit = 100 -- If the NPC's distance from itself to the ground is less than this, it will attempt to move up
ENT.AA_MinWanderDist = 150 -- Minimum distance that the NPC should go to when wandering
ENT.AA_MoveAccelerate = 5 -- The NPC will gradually speed up to the max movement speed as it moves towards its destination | Calculation = FrameTime * x
	-- 0 = Constant max speed | 1 = Increase very slowly | 50 = Increase very quickly
ENT.AA_MoveDecelerate = 5 -- The NPC will slow down as it approaches its destination | Calculation = MaxSpeed / x
	-- 1 = Constant max speed | 2 = Slow down slightly | 5 = Slow down normally | 50 = Slow down extremely slow
ENT.AA_EnableDebug = false -- Technical variable, used for testing and debugging aerial or aquatic NPCs
	-- ====== Controller Data ====== --
ENT.VJC_Data = {
	CameraMode = 1, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
	ThirdP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in third person
	FirstP_Bone = "ValveBiped.Bip01_Head1", -- If left empty, the base will attempt to calculate a position for first person
	FirstP_Offset = Vector(0, 0, 5), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = true, -- Should the bone shrink? Useful if the bone is obscuring the player's view
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
	-- VJ_BEHAVIOR_PASSIVE = Doesn't attack, but can attacked by others || VJ_BEHAVIOR_PASSIVE_NATURE = Doesn't attack and is allied with everyone
ENT.IsGuard = false -- If set to false, it will attempt to stick to its current position at all times
ENT.MoveOutOfFriendlyPlayersWay = true -- Should the SNPC move out of the way when a friendly player comes close to it?
ENT.BecomeEnemyToPlayer = false -- Should the friendly SNPC become enemy towards the player if it's damaged by it or it witnesses another ally killed by it
ENT.BecomeEnemyToPlayerLevel = 2 -- Any time the player does something bad, the NPC's anger level raises by 1, if it surpasses this, it will become enemy!
	-- ====== Old Variables (Can still be used, but it's recommended not to use them) ====== --
ENT.PlayerFriendly = false -- Makes the SNPC friendly to the player and HL2 Resistance
	-- ====== Passive Behavior Variables ====== --
ENT.Passive_RunOnTouch = true -- Should it run away and make a alert sound when something collides with it?
ENT.Passive_NextRunOnTouchTime = VJ_Set(3,4) -- How much until it can run away again when something collides with it?
ENT.Passive_RunOnDamage = true -- Should it run when it's damaged? | This doesn't impact how self.Passive_AlliesRunOnDamage works
ENT.Passive_AlliesRunOnDamage = true -- Should its allies (other passive SNPCs) also run when it's damaged?
ENT.Passive_AlliesRunOnDamageDistance = 800 -- Any allies within this distance will run when it's damaged
ENT.Passive_NextRunOnDamageTime = VJ_Set(6,7) -- How much until it can run the code again?
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
ENT.AnimTbl_CallForHelp = {} -- Call For Help Animations
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
	-- ====== Follow Player Variables ====== --
	-- Will only follow a player that's friendly to it!
ENT.FollowPlayer = true -- Should the SNPC follow the player when the player presses a certain key?
ENT.FollowPlayerChat = true -- Should the SNPCs say things like "Blank stopped following you" | self.AllowPrintingInChat overrides this variable!
ENT.FollowPlayerKey = "Use" -- The key that the player presses to make the SNPC follow them
ENT.FollowPlayerCloseDistance = 150 -- If the SNPC is that close to the player then stand still until the player goes farther away
ENT.NextFollowPlayerTime = 0.5 -- Time until it runs to the player again
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
ENT.CombatFaceEnemy = true -- If enemy is exists and is visible
	-- ====== Pose Parameter Variables ====== --
ENT.HasPoseParameterLooking = true -- Does it look at its enemy using poseparameters?
ENT.PoseParameterLooking_CanReset = true -- Should it reset its pose parameters if there is no enemies?
ENT.PoseParameterLooking_InvertPitch = false -- Inverts the pitch poseparameters (X)
ENT.PoseParameterLooking_InvertYaw = false -- Inverts the yaw poseparameters (Y)
ENT.PoseParameterLooking_InvertRoll = false -- Inverts the roll poseparameters (Z)
ENT.PoseParameterLooking_TurningSpeed = 10 -- How fast does the parameter turn?
ENT.PoseParameterLooking_Names = {pitch={}, yaw={}, roll={}} -- Custom pose parameters to use, can put as many as needed
	-- ====== Sound Detection Variables ====== --
ENT.InvestigateSoundDistance = 9 -- How far away can the SNPC hear sounds? | This number is timed by the calculated volume of the detectable sound.
	-- ====== No Chase After Certain Distance Variables ====== --
ENT.NoChaseAfterCertainRange = false -- Should the SNPC not be able to chase when it's between number x and y?
ENT.NoChaseAfterCertainRange_FarDistance = 2000 -- How far until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_CloseDistance = 300 -- How near until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_Type = "Regular" -- "Regular" = Default behavior | "OnlyRange" = Only does it if it's able to range attack
	-- ====== Miscellaneous Variables ====== --
ENT.AttackProps = true -- Should it attack props when trying to move?
ENT.PushProps = true -- Should it push props when trying to move?
ENT.PropAP_MaxSize = 1 -- This is a scale number for the max size it can attack/push | x < 1  = Smaller props & x > 1  = Larger props | Default base value: 1
	-- ====== Control Variables ====== --
	-- Use these variables very careful! One wrong change can mess up the whole SNPC!
ENT.FindEnemy_UseSphere = false -- Should the SNPC be able to see all around him? (360) | Objects and walls can still block its sight!
ENT.FindEnemy_CanSeeThroughWalls = false -- Should it be able to see through walls and objects? | Can be useful if you want to make it know where the enemy is at all times
ENT.DisableFindEnemy = false -- Disables FindEnemy code, friendly code still works though
ENT.DisableSelectSchedule = false -- Disables Schedule code, Custom Schedule can still work
ENT.DisableTakeDamageFindEnemy = false -- Disable the SNPC finding the enemy when being damaged
ENT.DisableTouchFindEnemy = false -- Disable the SNPC finding the enemy when being touched
ENT.DisableMakingSelfEnemyToNPCs = false -- Disables the "AddEntityRelationship" that runs in think
ENT.LastSeenEnemyTimeUntilReset = 15 -- Time until it resets its enemy if its current enemy is not visible
ENT.NextProcessTime = 1 -- Time until it runs the essential part of the AI, which can be performance heavy!
	-- ====== Miscellaneous Variables ====== --
ENT.DisableInitializeCapabilities = false -- If enabled, all of the Capabilities will be disabled, allowing you to add your own
ENT.AttackTimersCustom = {}
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
ENT.DamageByPlayerTime = VJ_Set(2,2) -- How much time until it can run the Damage By Player code?
	-- ====== Run Away On Unknown Damage Variables ====== --
ENT.RunAwayOnUnknownDamage = true -- Should run away on damage
ENT.NextRunAwayOnDamageTime = 5 -- Until next run after being shot when not alerted
	-- ====== Call For Back On Damage Variables ====== --
ENT.CallForBackUpOnDamage = true -- Should the SNPC call for help when damaged? (Only happens if the SNPC hasn't seen a enemy)
ENT.CallForBackUpOnDamageDistance = 800 -- How far away the SNPC's call for help goes | Counted in World Units
ENT.CallForBackUpOnDamageLimit = 4 -- How many people should it call? | 0 = Unlimited
ENT.CallForBackUpOnDamageAnimation = {} -- Animation used if the SNPC does the CallForBackUpOnDamage function
	-- To let the base automatically detect the animation duration, set this to false:
ENT.CallForBackUpOnDamageAnimationTime = false -- How much time until it can use activities
ENT.NextCallForBackUpOnDamageTime = VJ_Set(9,11) -- Next time it use the CallForBackUpOnDamage function
ENT.DisableCallForBackUpOnDamageAnimation = false -- Disables the animation when the CallForBackUpOnDamage function is called
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Death & Corpse Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- ====== Ally Reaction On Death Variables ====== --
	-- Default: Creature base uses BringFriends and Human base uses AlertFriends
	-- BringFriendsOnDeath takes priority over AlertFriendsOnDeath!
ENT.BringFriendsOnDeath = true -- Should the SNPC's friends come to its position before it dies?
ENT.BringFriendsOnDeathDistance = 800 -- How far away does the signal go? | Counted in World Units
ENT.BringFriendsOnDeathLimit = 3 -- How many people should it call? | 0 = Unlimited
ENT.AlertFriendsOnDeath = false -- Should the SNPCs allies get alerted when it dies? | Its allies will also need to have this variable set to true!
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
ENT.DeathCorpseApplyForce = true -- Disables the damage force on death | Useful for SNPCs with Death Animations
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
ENT.ItemDropsOnDeath_EntityList = {} -- List of items it will randomly pick from | Leave it empty to drop nothing or to make your own dropping code (Using CustomOn...)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Melee Attack Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.MeleeAttackDamage = 10
ENT.MeleeAttackDamageType = DMG_SLASH -- Type of Damage
	-- ====== Animation Variables ====== --
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- Melee Attack Animations
ENT.MeleeAttackAnimationDelay = 0 -- It will wait certain amount of time before playing the animation
ENT.MeleeAttackAnimationFaceEnemy = true -- Should it face the enemy while playing the melee attack animation?
ENT.MeleeAttackAnimationDecreaseLengthAmount = 0 -- This will decrease the time until starts chasing again. Use it to fix animation pauses until it chases the enemy.
ENT.MeleeAttackAnimationAllowOtherTasks = false -- If set to true, the animation will not stop other tasks from playing, such as chasing | Useful for gesture attacks!
	-- ====== Distance Variables ====== --
ENT.MeleeAttackDistance = 60 -- How close does it have to be until it attacks?
ENT.MeleeAttackAngleRadius = 100 -- What is the attack angle radius? | 100 = In front of the SNPC | 180 = All around the SNPC
ENT.MeleeAttackDamageDistance = 80 -- How far does the damage go?
ENT.MeleeAttackDamageAngleRadius = 100 -- What is the damage angle radius? | 100 = In front of the SNPC | 180 = All around the SNPC
	-- ====== Timer Variables ====== --
	-- To use event-based attacks, set this to false:
ENT.TimeUntilMeleeAttackDamage = 0.6 -- This counted in seconds | This calculates the time until it hits something
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
	-- ====== Knock Back Variables ====== --
ENT.HasMeleeAttackKnockBack = false -- If true, it will cause a knockback to its enemy
ENT.MeleeAttackKnockBack_Forward1 = 100 -- How far it will push you forward | First in math.random
ENT.MeleeAttackKnockBack_Forward2 = 100 -- How far it will push you forward | Second in math.random
ENT.MeleeAttackKnockBack_Up1 = 10 -- How far it will push you up | First in math.random
ENT.MeleeAttackKnockBack_Up2 = 10 -- How far it will push you up | Second in math.random
ENT.MeleeAttackKnockBack_Right1 = 0 -- How far it will push you right | First in math.random
ENT.MeleeAttackKnockBack_Right2 = 0 -- How far it will push you right | Second in math.random
	-- ====== Bleed Enemy Variables ====== --
	-- Causes the affected enemy to continue taking damage after the attack for x amount of time
ENT.MeleeAttackBleedEnemy = false -- Should the enemy bleed when attacked by melee?
ENT.MeleeAttackBleedEnemyChance = 3 -- Chance that the enemy bleeds | 1 = always
ENT.MeleeAttackBleedEnemyDamage = 1 -- How much damage per repetition
ENT.MeleeAttackBleedEnemyTime = 1 -- How much time until the next repetition?
ENT.MeleeAttackBleedEnemyReps = 4 -- How many repetitions?
	-- ====== Slow Player Variables ====== --
	-- Causes the affected player to slow down
ENT.SlowPlayerOnMeleeAttack = false -- If true, then the player will slow down
ENT.SlowPlayerOnMeleeAttack_WalkSpeed = 100 -- Walking Speed when Slow Player is on
ENT.SlowPlayerOnMeleeAttack_RunSpeed = 100 -- Running Speed when Slow Player is on
ENT.SlowPlayerOnMeleeAttackTime = 5 -- How much time until player's Speed resets
	-- ====== World Shake On Miss Variables ====== --
ENT.MeleeAttackWorldShakeOnMiss = false -- Should it shake the world when it misses during melee attack?
ENT.MeleeAttackWorldShakeOnMissAmplitude = 16 -- How much the screen will shake | From 1 to 16, 1 = really low 16 = really high
ENT.MeleeAttackWorldShakeOnMissRadius = 2000 -- How far the screen shake goes, in world units
ENT.MeleeAttackWorldShakeOnMissDuration = 1 -- How long the screen shake will last, in seconds
ENT.MeleeAttackWorldShakeOnMissFrequency = 100 -- Just leave it to 100
	-- ====== Digital Signal Processor (DSP) Variables ====== --
	-- Applies a DSP (Digital Signal Processor) to the player(s) that got hit
	-- DSP Presents: https://developer.valvesoftware.com/wiki/Dsp_presets
ENT.MeleeAttackDSPSoundType = 32 -- DSP type | false = Disables this system
ENT.MeleeAttackDSPSoundUseDamage = true -- Limits it to only past certain damage amount | true = If damage is x or greater | false = No limit, always applies DSP!
ENT.MeleeAttackDSPSoundUseDamageAmount = 60 -- Any damage that is greater than or equal to this number will cause the DSP effect to apply
	-- ====== Miscellaneous Variables ====== --
ENT.MeleeAttack_NoProps = false -- If set to true, it won't attack or push any props (Mostly used with multiple melee attacks)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Range Attack Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasRangeAttack = false -- Should the SNPC have a range attack?
ENT.RangeAttackEntityToSpawn = "grenade_spit" -- The entity that is spawned when range attacking
	-- ====== Animation Variables ====== --
ENT.AnimTbl_RangeAttack = {ACT_RANGE_ATTACK1} -- Range Attack Animations
ENT.RangeAttackAnimationDelay = 0 -- It will wait certain amount of time before playing the animation
ENT.RangeAttackAnimationFaceEnemy = true -- Should it face the enemy while playing the range attack animation?
ENT.RangeAttackAnimationDecreaseLengthAmount = 0 -- This will decrease the time until starts chasing again. Use it to fix animation pauses until it chases the enemy.
ENT.RangeAttackAnimationStopMovement = true -- Should it stop moving when performing a range attack?
	-- ====== Distance Variables ====== --
ENT.RangeDistance = 2000 -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 800 -- How close does it have to be until it uses melee?
ENT.RangeAttackAngleRadius = 100 -- What is the attack angle radius? | 100 = In front of the SNPC | 180 = All around the SNPC
	-- ====== Timer Variables ====== --
	-- To use event-based attacks, set this to false:
ENT.TimeUntilRangeAttackProjectileRelease = 1.5 -- How much time until the projectile code is ran?
ENT.NextRangeAttackTime = 3 -- How much time until it can use a range attack?
ENT.NextRangeAttackTime_DoRand = false -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer
	-- To let the base automatically detect the attack duration, set this to false:
ENT.NextAnyAttackTime_Range = false -- How much time until it can use any attack again? | Counted in Seconds
ENT.NextAnyAttackTime_Range_DoRand = false -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer
ENT.RangeAttackReps = 1 -- How many times does it run the projectile code?
ENT.RangeAttackExtraTimers = nil -- Extra range attack timers, EX: {1, 1.4} | it will run the projectile code after the given amount of seconds
	-- ====== Projectile Spawn Position Variables ====== --
ENT.RangeUseAttachmentForPos = false -- Should the projectile spawn on a attachment?
ENT.RangeUseAttachmentForPosID = "muzzle" -- The attachment used on the range attack if RangeUseAttachmentForPos is set to true
ENT.RangeAttackPos_Up = 20 -- Up/Down spawning position for range attack
ENT.RangeAttackPos_Forward = 0 -- Forward/Backward spawning position for range attack
ENT.RangeAttackPos_Right = 0 -- Right/Left spawning position for range attack
	-- ====== Control Variables ====== --
ENT.DisableRangeAttackAnimation = false -- if true, it will disable the animation code
ENT.DisableDefaultRangeAttackCode = false -- When true, it won't spawn the range attack entity, allowing you to make your own
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Leap Attack Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasLeapAttack = false -- Should the SNPC have a leap attack?
ENT.LeapAttackDamage = 15
ENT.LeapAttackDamageType = DMG_SLASH -- Type of Damage
	-- ====== Animation Variables ====== --
ENT.AnimTbl_LeapAttack = {ACT_SPECIAL_ATTACK1} -- Melee Attack Animations
ENT.LeapAttackAnimationDelay = 0 -- It will wait certain amount of time before playing the animation
ENT.LeapAttackAnimationFaceEnemy = 2 -- true = Face the enemy the entire time! | 2 = Face the enemy UNTIL it jumps! | false = Don't face the enemy AT ALL!
ENT.LeapAttackAnimationDecreaseLengthAmount = 0 -- This will decrease the time until starts chasing again. Use it to fix animation pauses until it chases the enemy.
	-- ====== Distance Variables ====== --
ENT.LeapDistance = 500 -- The distance of the leap, for example if it is set to 500, when the SNPC is 500 Unit away, it will jump
ENT.LeapToMeleeDistance = 200 -- How close does it have to be until it uses melee?
ENT.LeapAttackDamageDistance = 100 -- How far does the damage go?
ENT.LeapAttackAngleRadius = 60 -- What is the attack angle radius? | 100 = In front of the SNPC | 180 = All around the SNPC
	-- ====== Timer Variables ====== --
	-- To use event-based attacks, set this to false:
ENT.TimeUntilLeapAttackDamage = 0.2 -- How much time until it runs the leap damage code?
ENT.TimeUntilLeapAttackVelocity = 0.1 -- How much time until it runs the velocity code?
ENT.NextLeapAttackTime = 3 -- How much time until it can use a leap attack?
ENT.NextLeapAttackTime_DoRand = false -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer
	-- To let the base automatically detect the attack duration, set this to false:
ENT.NextAnyAttackTime_Leap = false -- How much time until it can use any attack again? | Counted in Seconds
ENT.NextAnyAttackTime_Leap_DoRand = false -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer
ENT.LeapAttackReps = 1 -- How many times does it run the leap attack code?
ENT.LeapAttackExtraTimers = nil -- Extra leap attack timers, EX: {1, 1.4} | it will run the damage code after the given amount of seconds
ENT.StopLeapAttackAfterFirstHit = true -- Should it stop the leap attack from running rest of timers when it hits an enemy?
	-- ====== Velocity Variables ====== --
ENT.LeapAttackVelocityForward = 2000 -- How much forward force should it apply?
ENT.LeapAttackVelocityUp = 200 -- How much upward force should it apply?
ENT.LeapAttackVelocityRight = 0 -- How much right force should it apply?
	-- ====== Control Variables ====== --
ENT.DisableLeapAttackAnimation = false -- if true, it will disable the animation code
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
ENT.HasMeleeAttackSounds = true -- If set to false, it won't play the melee attack sound
ENT.HasExtraMeleeAttackSounds = false -- Set to true to use the extra melee attack sounds
ENT.HasMeleeAttackMissSounds = true -- If set to false, it won't play the melee attack miss sound
ENT.HasMeleeAttackSlowPlayerSound = true -- Does it have a sound when it slows down the player?
ENT.HasBeforeRangeAttackSound = true -- If set to false, it won't play the before range attack sounds
ENT.HasRangeAttackSound = true -- If set to false, it won't play the range attack sounds
ENT.HasBeforeLeapAttackSound = true -- If set to false, it won't play any sounds before leap attack code is ran
ENT.HasLeapAttackJumpSound = true -- If set to false, it won't play any sounds when it leaps at the enemy while leap attacking
ENT.HasLeapAttackDamageSound = true -- If set to false, it won't play any sounds when it successfully hits the enemy while leap attacking
ENT.HasLeapAttackDamageMissSound = true -- If set to false, it won't play any sounds when it misses the enemy while leap attacking
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
ENT.SoundTbl_BeforeMeleeAttack = {}
ENT.SoundTbl_MeleeAttack = {}
ENT.SoundTbl_MeleeAttackExtra = {}
ENT.SoundTbl_MeleeAttackMiss = {}
ENT.SoundTbl_MeleeAttackSlowPlayer = {"vj_player/heartbeat.wav"}
ENT.SoundTbl_BeforeRangeAttack = {}
ENT.SoundTbl_RangeAttack = {}
ENT.SoundTbl_BeforeLeapAttack = {}
ENT.SoundTbl_LeapAttackJump = {}
ENT.SoundTbl_LeapAttackDamage = {}
ENT.SoundTbl_LeapAttackDamageMiss = {}
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
local DefaultSoundTbl_MedicAfterHeal = {"items/smallmedkit1.wav"}
local DefaultSoundTbl_MeleeAttackExtra = {"npc/zombie/claw_strike1.wav","npc/zombie/claw_strike2.wav","npc/zombie/claw_strike3.wav"}
local DefaultSoundTbl_Impact = {"vj_flesh/alien_flesh1.wav"}
------ ///// WARNING: Don't change anything in this box! \\\\\ ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- ====== Fade Out Time Variables ====== --
	-- Put to 0 if you want it to stop instantly
ENT.MeleeAttackSlowPlayerSoundFadeOutTime = 1
ENT.SoundTrackFadeOutTime = 2
	-- ====== Sound Chance Variables ====== --
	-- Higher number = less chance of playing | 1 = Always play
ENT.IdleSoundChance = 2
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
ENT.BeforeRangeAttackSoundChance = 1
ENT.RangeAttackSoundChance = 1
ENT.BeforeLeapAttackSoundChance = 1
ENT.LeapAttackJumpSoundChance = 1
ENT.LeapAttackDamageSoundChance = 1
ENT.LeapAttackDamageMissSoundChance = 1
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
ENT.NextSoundTime_Idle = VJ_Set(4, 11)
ENT.NextSoundTime_Investigate = VJ_Set(5, 5)
ENT.NextSoundTime_LostEnemy = VJ_Set(5, 6)
ENT.NextSoundTime_Alert = VJ_Set(2, 3)
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
ENT.MeleeAttackSlowPlayerSoundLevel = 100
ENT.BeforeRangeAttackSoundLevel = 75
ENT.RangeAttackSoundLevel = 75
ENT.BeforeLeapAttackSoundLevel = 75
ENT.LeapAttackJumpSoundLevel = 75
ENT.LeapAttackDamageSoundLevel = 75
ENT.LeapAttackDamageMissSoundLevel = 75
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
ENT.MeleeAttackSoundPitch = VJ_Set(false, false)
ENT.ExtraMeleeSoundPitch = VJ_Set(80, 100)
ENT.MeleeAttackMissSoundPitch = VJ_Set(90, 100)
ENT.BeforeRangeAttackPitch = VJ_Set(false, false)
ENT.RangeAttackPitch1 = false
ENT.RangeAttackPitch2 = false
ENT.BeforeLeapAttackSoundPitch = VJ_Set(false, false)
ENT.LeapAttackJumpSoundPitch = VJ_Set(false, false)
ENT.LeapAttackDamageSoundPitch = VJ_Set(false, false)
ENT.LeapAttackDamageMissSoundPitch = VJ_Set(false, false)
ENT.OnKilledEnemySoundPitch = VJ_Set(false, false)
ENT.AllyDeathSoundPitch = VJ_Set(false, false)
ENT.PainSoundPitch1 = false
ENT.PainSoundPitch2 = false
ENT.ImpactSoundPitch = VJ_Set(80, 100)
ENT.DamageByPlayerPitch = VJ_Set(false, false)
ENT.DeathSoundPitch1 = false
ENT.DeathSoundPitch2 = false
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
function ENT:CustomOnInitialize() /* -- Example: self:SetCollisionBounds(Vector(50, 50, 100), Vector(-50, -50, 0)) */ end
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
function ENT:CustomOnFollowPlayer(key, activator, caller, data) end
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
function ENT:SetNearestPointToEntityPosition()
	return self:GetPos() + self:GetForward() -- Override this to use a different position
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomAttack() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MultipleMeleeAttacks() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomAttackCheck_MeleeAttack() return true end -- Not returning true will not let the melee attack code run!
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_BeforeStartTimer(seed) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_AfterStartTimer(seed) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_BeforeChecks() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetMeleeAttackDamagePosition()
	return self:GetPos() + self:GetForward() -- Override this to use a different position
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_AfterChecks(hitEnt, isProp) return false end -- return true to disable the attack and move onto the next entity!
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_BleedEnemy(hitEnt) end -- Runs if the self.MeleeAttackBleedEnemy code runs
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_SlowPlayer(hitEnt) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_Miss() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MultipleRangeAttacks() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomAttackCheck_RangeAttack() return true end -- Not returning true will not let the range attack code run!
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRangeAttack_BeforeStartTimer(seed) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRangeAttack_AfterStartTimer(seed) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode_BeforeProjectileSpawn(projectile) end -- This is ran before Spawn() is called
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode_AfterProjectileSpawn(projectile) end -- Called after Spawn()
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackCode_OverrideProjectilePos(projectile) return 0 end -- return other value then 0 to override the projectile's position
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackCode_GetShootPos(projectile) return (self:GetEnemy():GetPos() - self:LocalToWorld(Vector(0, 0, 0)))*2 + self:GetUp()*1 end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MultipleLeapAttacks() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomAttackCheck_LeapAttack() return true end -- Not returning true will not let the leap attack code run!
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnLeapAttack_BeforeStartTimer(seed) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnLeapAttack_AfterStartTimer(seed) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnLeapAttackVelocityCode() end -- Return true here to override the default velocity code
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnLeapAttack_BeforeChecks() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnLeapAttack_AfterChecks(hitEnt) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnLeapAttack_Miss() end
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
ENT.MeleeAttacking = false
ENT.RangeAttacking = false
ENT.LeapAttacking = false
ENT.Alerted = false
ENT.Dead = false
ENT.Flinching = false
ENT.vACT_StopAttacks = false
ENT.FollowingPlayer = false
ENT.FollowPlayer_GoingAfter = false
ENT.EnemyReset = true
ENT.VJ_IsBeingControlled = false
ENT.VJ_PlayingSequence = false
ENT.VJ_IsPlayingSoundTrack = false
ENT.PlayingAttackAnimation = false
ENT.VJDEBUG_SNPC_ENABLED = false
ENT.MeleeAttack_DoingPropAttack = false
ENT.Medic_IsHealingAlly = false
ENT.AlreadyDoneMedicThinkCode = false
ENT.AlreadyBeingHealedByMedic = false
ENT.VJFriendly = false
ENT.AlreadyDoneMeleeAttackFirstHit = false
ENT.AlreadyDoneLeapAttackFirstHit = false
ENT.IsAbleToMeleeAttack = true
ENT.IsAbleToRangeAttack = true
ENT.IsAbleToLeapAttack = true
ENT.RangeAttack_DisableChasingEnemy = false
ENT.IsDoingFaceEnemy = false
ENT.IsDoingFacePosition = false
ENT.VJ_PlayingInterruptSequence = false
ENT.AlreadyDoneFirstMeleeAttack = false
ENT.CanDoSelectScheduleAgain = true
ENT.HasBeenGibbedOnDeath = false
ENT.DeathAnimationCodeRan = false
ENT.FollowPlayer_DoneSelectSchedule = false
ENT.AlreadyDoneRangeAttackFirstProjectile = false
ENT.AlreadyDoneFirstLeapAttack = false
ENT.VJ_IsBeingControlled_Tool = false
ENT.LastHiddenZone_CanWander = true
ENT.AlreadyDoneLeapAttackJump = false
ENT.CurIdleStandMove = false
ENT.FollowPlayer_Entity = NULL
ENT.VJ_TheController = NULL
ENT.VJ_TheControllerEntity = NULL
ENT.VJ_TheControllerBullseye = NULL
ENT.Medic_CurrentEntToHeal = NULL
ENT.Medic_SpawnedProp = NULL
ENT.LastPlayedVJSound = nil
ENT.NextFollowPlayerT = 0
ENT.AngerLevelTowardsPlayer = 0
ENT.NextBreathSoundT = 0
ENT.FootStepT = 0
ENT.PainSoundT = 0
ENT.AllyDeathSoundT = 0
ENT.WorldShakeWalkT = 0
ENT.NextSetEnemyOnDamageT = 0
ENT.NextRunAwayOnDamageT = 0
ENT.NextIdleSoundT = 0
ENT.NextProcessT = 0
ENT.NextCallForHelpT = 0
ENT.NextCallForBackUpOnDamageT = 0
ENT.NextAlertSoundT = 0
ENT.LastSeenEnemyTime = 0
ENT.NextCallForHelpAnimationT = 0
ENT.NextResetEnemyT = 0
ENT.CurrentAttackAnimation = 0
ENT.CurrentAttackAnimationDuration = 0
ENT.NextIdleTime = 0
ENT.NextChaseTime = 0
ENT.OnPlayerSightNextT = 0
ENT.NextDamageByPlayerT = 0
ENT.NextDamageByPlayerSoundT = 0
ENT.TimeSinceLastSeenEnemy = 0
ENT.TimeSinceEnemyAcquired = 0
ENT.Medic_NextHealT = 0
ENT.CurrentAnim_IdleStand = 0
ENT.NextFlinchT = 0
ENT.NextCanGetCombineBallDamageT = 0
ENT.UseTheSameGeneralSoundPitch_PickedNumber = 0
ENT.OnKilledEnemySoundT = 0
ENT.LastHiddenZoneT = 0
ENT.NextIdleStandTime = 0
ENT.NextWanderTime = 0
ENT.TakingCoverT = 0
ENT.NextInvestigateSoundMove = 0
ENT.NextInvestigateSoundT = 0
ENT.NextCallForHelpSoundT = 0
ENT.LostEnemySoundT = 0
ENT.NextDoAnyAttackT = 0
ENT.NearestPointToEnemyDistance = 0
ENT.ReachableEnemyCount = 0
ENT.LatestEnemyDistance = 0
ENT.HealthRegenerationDelayT = 0
ENT.CurAttackSeed = 0
ENT.CurAnimationSeed = 0
ENT.LatestVisibleEnemyPosition = Vector(0, 0, 0)
ENT.GuardingPosition = nil
ENT.GuardingFacePosition = nil
ENT.SelectedDifficulty = 1
ENT.AIState = 0
ENT.TimersToRemove = {"timer_state_reset","timer_act_seqreset","timer_face_position","timer_face_enemy","timer_act_flinching","timer_act_playingattack","timer_act_stopattacks","timer_melee_finished","timer_melee_start","timer_melee_finished_abletomelee","timer_range_start","timer_range_finished","timer_range_finished_abletorange","timer_leap_start_jump","timer_leap_start","timer_leap_finished","timer_leap_finished_abletoleap"}
ENT.EntitiesToDestroyClass = {func_breakable=true,func_physbox=true,prop_door_rotating=true} // func_breakable_surf
ENT.DefaultGibDamageTypes = {DMG_ALWAYSGIB,DMG_ENERGYBEAM,DMG_BLAST,DMG_VEHICLE,DMG_CRUSH,DMG_DISSOLVE,DMG_SLOWBURN,DMG_PHYSGUN,DMG_PLASMA,DMG_SONIC} -- !!!!!!!!!!!!!! DO NOT USE THIS VARIABLE !!!!!!!!!!!!!! [Backwards Compatibility!]
//ENT.DefaultGibOnDeathDamageTypes = {[DMG_ALWAYSGIB]=true,[DMG_ENERGYBEAM]=true,[DMG_BLAST]=true,[DMG_VEHICLE]=true,[DMG_CRUSH]=true,[DMG_DISSOLVE]=true,[DMG_SLOWBURN]=true,[DMG_PHYSGUN]=true,[DMG_PLASMA]=true,[DMG_SONIC]=true}
//ENT.SavedDmgInfo = {} -- Set later

-- Localized static values
local defPos = Vector(0, 0, 0)

local CurTime = CurTime
local IsValid = IsValid
local GetConVar = GetConVar
local isstring = isstring
local isnumber = isnumber
local tonumber = tonumber
local varCAnt = "CLASS_ANTLION"
local varCCom = "CLASS_COMBINE"
local varCZom = "CLASS_ZOMBIE"

---------------------------------------------------------------------------------------------------------------------------------------------
local function ConvarsOnInit(self)
	--<>-- Convars that run on Initialize --<>--
	if GetConVar("vj_npc_usedevcommands"):GetInt() == 1 then self.VJDEBUG_SNPC_ENABLED = true self.AA_EnableDebug = true end
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
	if GetConVar("vj_npc_noproppush"):GetInt() == 1 then self.PushProps = false end
	if GetConVar("vj_npc_nopropattack"):GetInt() == 1 then self.AttackProps = false end
	if GetConVar("vj_npc_bleedenemyonmelee"):GetInt() == 1 then self.MeleeAttackBleedEnemy = false end
	if GetConVar("vj_npc_slowplayer"):GetInt() == 1 then self.SlowPlayerOnMeleeAttack = false end
	if GetConVar("vj_npc_nowandering"):GetInt() == 1 then self.DisableWandering = true end
	if GetConVar("vj_npc_nochasingenemy"):GetInt() == 1 then self.DisableChasingEnemy = true end
	if GetConVar("vj_npc_noflinching"):GetInt() == 1 then self.CanFlinch = false end
	if GetConVar("vj_npc_nomelee"):GetInt() == 1 then self.HasMeleeAttack = false end
	if GetConVar("vj_npc_norange"):GetInt() == 1 then self.HasRangeAttack = false end
	if GetConVar("vj_npc_noleap"):GetInt() == 1 then self.HasLeapAttack = false end
	if GetConVar("vj_npc_nobleed"):GetInt() == 1 then self.Bleeds = false end
	if GetConVar("vj_npc_godmodesnpc"):GetInt() == 1 then self.GodMode = true end
	if GetConVar("vj_npc_nobecomeenemytoply"):GetInt() == 1 then self.BecomeEnemyToPlayer = false end
	if GetConVar("vj_npc_nofollowplayer"):GetInt() == 1 then self.FollowPlayer = false end
	if GetConVar("vj_npc_nosnpcchat"):GetInt() == 1 then self.AllowPrintingInChat = false self.FollowPlayerChat = false end
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
	if GetConVar("vj_npc_sd_meleeattack"):GetInt() == 1 then self.HasMeleeAttackSounds = false self.HasExtraMeleeAttackSounds = false end
	if GetConVar("vj_npc_sd_meleeattackmiss"):GetInt() == 1 then self.HasMeleeAttackMissSounds = false end
	if GetConVar("vj_npc_sd_slowplayer"):GetInt() == 1 then self.HasMeleeAttackSlowPlayerSound = false end
	if GetConVar("vj_npc_sd_rangeattack"):GetInt() == 1 then self.HasBeforeRangeAttackSound = false self.HasRangeAttackSound = false end
	if GetConVar("vj_npc_sd_leapattack"):GetInt() == 1 then self.HasBeforeLeapAttackSound = false self.HasLeapAttackJumpSound = false self.HasLeapAttackDamageSound = false self.HasLeapAttackDamageMissSound = false end
	if GetConVar("vj_npc_sd_pain"):GetInt() == 1 then self.HasPainSounds = false end
	if GetConVar("vj_npc_sd_death"):GetInt() == 1 then self.HasDeathSounds = false end
	if GetConVar("vj_npc_sd_followplayer"):GetInt() == 1 then self.HasFollowPlayerSounds_Follow = false self.HasFollowPlayerSounds_UnFollow = false end
	if GetConVar("vj_npc_sd_becomenemytoply"):GetInt() == 1 then self.HasBecomeEnemyToPlayerSounds = false end
	if GetConVar("vj_npc_sd_onplayersight"):GetInt() == 1 then self.HasOnPlayerSightSounds = false end
	if GetConVar("vj_npc_sd_medic"):GetInt() == 1 then self.HasMedicSounds_BeforeHeal = false self.HasMedicSounds_AfterHeal = false self.HasMedicSounds_ReceiveHeal = false end
	if GetConVar("vj_npc_sd_callforhelp"):GetInt() == 1 then self.HasCallForHelpSounds = false end
	if GetConVar("vj_npc_sd_onreceiveorder"):GetInt() == 1 then self.HasOnReceiveOrderSounds = false end
	if GetConVar("vj_npc_creatureopendoor"):GetInt() == 0 then self.CanOpenDoors = false end
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
--
function ENT:Initialize()
	if self.AnimTbl_IdleStand == nil then self.AnimTbl_IdleStand = defIdleTbl end
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
	self:SetCustomCollisionCheck()
	self:SetMaxYawSpeed(self.TurningSpeed)
	ConvarsOnInit(self)
	self:DoChangeMovementType()
	self.ExtraCorpsesToRemove_Transition = {}
	self.VJ_AddCertainEntityAsEnemy = {}
	self.VJ_AddCertainEntityAsFriendly = {}
	self.CurrentPossibleEnemies = {}
	self.VJ_ScaleHitGroupDamage = 0
	self.NextIdleSoundT_RegularChange = CurTime() + math.random(0.3, 6)
	self.UseTheSameGeneralSoundPitch_PickedNumber = (self.UseTheSameGeneralSoundPitch and math.random(self.GeneralSoundPitch1, self.GeneralSoundPitch2)) or 0
	self:SetupBloodColor()
	if self.DisableInitializeCapabilities == false then self:SetInitializeCapabilities() end
	self:SetHealth((GetConVar("vj_npc_allhealth"):GetInt() > 0) and GetConVar("vj_npc_allhealth"):GetInt() or self:VJ_GetDifficultyValue(self.StartHealth))
	self.StartHealth = self:Health()
	self:CustomOnInitialize()
	self:CustomInitialize() -- !!!!!!!!!!!!!! DO NOT USE THIS FUNCTION !!!!!!!!!!!!!! [Backwards Compatibility!]
	self.NextWanderTime = ((self.NextWanderTime != 0) and self.NextWanderTime) or (CurTime() + (self.IdleAlwaysWander and 0 or 1)) -- If self.NextWanderTime isn't given a value THEN if self.IdleAlwaysWander isn't true, wait at least 1 sec before wandering
	self.SightDistance = (GetConVar("vj_npc_seedistance"):GetInt() > 0) and GetConVar("vj_npc_seedistance"):GetInt() or self.SightDistance
	timer.Simple(0.15, function()
		if IsValid(self) then
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
	duplicator.RegisterEntityClass(self:GetClass(), VJSPAWN_SNPC_DUPE, "Class", "Equipment", "SpawnFlags", "Data")
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- !!!!!!!!!!!!!! DO NOT USE THESE FUNCTIONS OR VARIABLES !!!!!!!!!!!!!! [Backwards Compatibility!]
-- Most of these will most likely be removed in the future!
ENT.DeathSkin = 0
function ENT:CustomInitialize() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInitializeCapabilities()
	self:CapabilitiesAdd(bit.bor(CAP_SKIP_NAV_GROUND_CHECK))
	//self:CapabilitiesAdd(bit.bor(CAP_ANIMATEDFACE)) -- Breaks some SNPCs, avoid using it!
	self:CapabilitiesAdd(bit.bor(CAP_TURN_HEAD))
	if self.CanOpenDoors == true then
		self:CapabilitiesAdd(bit.bor(CAP_OPEN_DOORS))
		self:CapabilitiesAdd(bit.bor(CAP_AUTO_DOORS))
		self:CapabilitiesAdd(bit.bor(CAP_USE))
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
		if VJ_AnimationExists(self,ACT_JUMP) == true then self:CapabilitiesAdd(bit.bor(CAP_MOVE_JUMP)) end
		if VJ_AnimationExists(self,ACT_CLIMB_UP) == true then self:CapabilitiesAdd(bit.bor(CAP_MOVE_CLIMB)) end
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
		Nothing at the moment
-----------------------------------------------------------]]
local varGes = "vjges_"
local varSeq = "vjseq_"
--
function ENT:VJ_ACT_PLAYACTIVITY(animation, stopActivities, stopActivitiesTime, faceEnemy, animDelay, extraOptions, customFunc)
	animation = VJ_PICK(animation)
	if animation == false then return end
	
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
		return -- This isn't a human SNPC, no need to check for weapon translation
		/*if !isString && IsValid(self:GetActiveWeapon()) then -- If it's an activity and has a valid weapon then check for weapon translation
			-- If it returns the same activity as animation, then there isn't even a translation for it so don't play any animation =(
			if self:GetActiveWeapon().IsVJBaseWeapon && self:TranslateToWeaponAnim(animation) == animation then return end
		else
			return -- No animation =(
		end*/
	end
	
	-- Seed the current animation, used for animation delaying & on complete check
	local seed = CurTime(); self.CurAnimationSeed = seed
	local function PlayAct()
		if stopActivities == true then
			if stopActivitiesTime == false then -- false = Let the base calculate the time
				stopActivitiesTime = self:DecideAnimationLength(animation, false)
			elseif !extraOptions.PlayBackRateCalculated then -- Make sure not to calculate the playback rate when it already has!
				stopActivitiesTime = stopActivitiesTime / self:GetPlaybackRate()
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
						self:FaceCertainEntity(self:GetEnemy(), true, (stopActivities and stopActivitiesTime) or self:DecideAnimationLength(animation, false))
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
			timer.Simple((stopActivities and stopActivitiesTime) or self:DecideAnimationLength(animation, false), function()
				if IsValid(self) && !self.Dead then
					extraOptions.OnFinish(self.CurAnimationSeed != seed, animation)
				end
			end)
		end
	end
	
	-- For delay system
	if animDelay > 0 then
		timer.Simple(animDelay, function()
			if IsValid(self) && self.CurAnimationSeed == seed then
				PlayAct()
			end
		end)
	else
		PlayAct()
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
		task_chaseEnemy.RunCode_OnFail = function() self:VJ_TASK_IDLE_STAND() end
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
	
	local idleAnimTbl = self.AnimTbl_IdleStand
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
				if VJ_SequenceToActivity(self,self:GetSequenceName(getSeq)) == pickedAnim then -- Nayir yete himagva animation e nooynene
					self.NextIdleStandTime = CurTime() + ((self:SequenceDuration(getSeq) - 0.01) / self:GetPlaybackRate()) -- Yete nooynene ooremen jamanage tir animation-en yergarootyan chap!
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
	if self.DisableWandering == true or self.IsGuard == true or self.MovementType == VJ_MOVETYPE_STATIONARY or self.IsVJBaseSNPC_Tank == true or self.LastHiddenZone_CanWander == false or self.NextWanderTime > CurTime() or self.FollowingPlayer == true or self.Medic_IsHealingAlly == true then
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
	if self:GetState() == VJ_STATE_ONLY_ANIMATION_CONSTANT or self.Dead == true or self.VJ_IsBeingControlled == true or self.Flinching == true or self.IsVJBaseSNPC_Tank == true or !IsValid(ene) or (self.NextChaseTime > CurTime()) or (CurTime() < self.TakingCoverT) or (self.PlayingAttackAnimation == true && self.MovementType != VJ_MOVETYPE_AERIAL && self.MovementType != VJ_MOVETYPE_AQUATIC) then return end
	if self:VJ_GetNearestPointToEntityDistance(ene) < self.MeleeAttackDistance && ene:Visible(self) && (self:GetSightDirection():Dot((ene:GetPos() - self:GetPos()):GetNormalized()) > math.cos(math.rad(self.MeleeAttackAngleRadius))) then if (self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC) then self:AA_StopMoving() end self:VJ_TASK_IDLE_STAND() return end -- Not melee attacking yet but it is in range, so stop moving!
	
	alwaysChase = alwaysChase or false -- true = Chase no matter what
	
	-- Things that override can't bypass, Forces the NPC to ONLY idle stand!
	if self.MovementType == VJ_MOVETYPE_STATIONARY or self.FollowingPlayer == true or self.Medic_IsHealingAlly == true or self:GetState() == VJ_STATE_ONLY_ANIMATION then
		self:VJ_TASK_IDLE_STAND()
		return
	end
	
	-- For non-aggressive SNPCs
	if self.Behavior == VJ_BEHAVIOR_PASSIVE or self.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE then
		self:VJ_TASK_COVER_FROM_ENEMY("TASK_RUN_PATH")
		self.NextChaseTime = CurTime() + 3
		return
	end
	
	if alwaysChase == false && (self.DisableChasingEnemy == true or self.IsGuard == true or self.RangeAttack_DisableChasingEnemy == true) then self:VJ_TASK_IDLE_STAND() return end
	
	-- If the enemy is not reachable then wander around
	if self:IsUnreachable(ene) == true then
		self:RememberUnreachable(ene, 2)
		if self.HasRangeAttack == true then -- Ranged NPCs
			self:VJ_TASK_CHASE_ENEMY(true)
		elseif math.random(1, 30) == 1 then
			if !self:IsMoving() then
				self.NextWanderTime = 0
			end
			self:DoIdleAnimation(1)
		else
			self:VJ_TASK_IDLE_STAND()
		end
	else -- Is reachable, so chase the enemy!
		self:VJ_TASK_CHASE_ENEMY()
	end
	
	-- Set the next chase time
	if self.NextChaseTime > CurTime() then return end -- Don't set it if it's already set!
	self.NextChaseTime = CurTime() + (((self.LatestEnemyDistance > 2000) and 1) or 0.1) -- If the enemy is far, increase the delay!
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	-- Climbing Test
	/*print(self:GetNavType())
	self.NextIdleStandTime = 0
	self:SetNavType(NAV_CLIMB)
	climbDest = self:GetPos()+self:GetUp()*5000
	climbDir = climbDest - self:GetPos()
	climbDist = climbDir:GetNormalized()
	print(climbDir)
	self:NavSetGoal(climbDest, 100, climbDir)
	self:MoveClimbStart(climbDest, climbDir, 100, 100)
	self:MoveClimbExec(climbDest, climbDir, climbDist:Length(), 100, 4)
	self:SetNavType(NAV_CLIMB)
	if self:GetNavType() == NAV_CLIMB then
		climbDest = self:GetPos()+self:GetUp()*500
		climbDir = climbDest - self:GetPos()
		climbDist = climbDir:GetNormalized()
		local result = self:MoveClimbExec(climbDest, climbDir, climbDist:Length(), 100, 4)
		print("RESULT:", result)
	end*/
	
	self:SetCondition(1) -- Fix attachments, bones, positions, angles etc. being broken in NPCs! This condition is used as a backup in case sv_pvsskipanimation isn't disabled!
	
	//self:SetPoseParameter("move_yaw",180)
	
	// if self:IsUnreachable(self:GetEnemy()) && enemy noclipping then...
	
	//if self.CurrentSchedule != nil then PrintTable(self.CurrentSchedule) end
	//if self.CurrentTask != nil then PrintTable(self.CurrentTask) end
	if self.MovementType == VJ_MOVETYPE_GROUND && self:GetVelocity():Length() <= 0 && !self:IsEFlagSet(EFL_IS_BEING_LIFTED_BY_BARNACLE) /*&& curSched.IsMovingTask == true*/ then self:DropToFloor() end

	local curSched = self.CurrentSchedule
	if curSched != nil then
		if self:IsMoving() then
			if curSched.MoveType == 0 && !VJ_HasValue(self.AnimTbl_Walk,self:GetMovementActivity()) then
				self:SetMovementActivity(VJ_PICK(self.AnimTbl_Walk))
			elseif curSched.MoveType == 1 && !VJ_HasValue(self.AnimTbl_Run,self:GetMovementActivity()) then
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
			//self:SetCondition(35)
			//self:StopMoving()
		end
		-- No longer needed, self:OnMovementFailed() now handles it
		/*if self:HasCondition(35) then
			if curSched.AlreadyRanCode_OnFail == false && self:DoRunCode_OnFail(curSched) == true then
				self:ClearCondition(35)
			end
			if curSched.ResetOnFail == true then
				self:StopMoving()
				//self:SelectSchedule()
				self:ClearCondition(35)
				//print("VJ Base: Task Failed Condition Identified! "..self:GetName())
			end
		end*/
	end
	
	self:CustomOnThink()
	
	if self.Dead == false && self.HasBreathSound == true && self.HasSounds == true && CurTime() > self.NextBreathSoundT then
		local sdtbl = VJ_PICK(self.SoundTbl_Breath)
		local dur = 1
		if sdtbl != false then
			VJ_STOPSOUND(self.CurrentBreathSound)
			dur = (self.NextSoundTime_Breath == true and SoundDuration(sdtbl)) or math.Rand(self.NextSoundTime_Breath.a, self.NextSoundTime_Breath.b)
			self.CurrentBreathSound = VJ_CreateSound(self, sdtbl, self.BreathSoundLevel, self:VJ_DecideSoundPitch(self.BreathSoundPitch.a, self.BreathSoundPitch.b))
		end
		self.NextBreathSoundT = CurTime() + dur
	end
	--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
	if GetConVar("ai_disabled"):GetInt() == 0 && self:GetState() != VJ_STATE_FREEZE && !self:IsEFlagSet(EFL_IS_BEING_LIFTED_BY_BARNACLE) then
		if self.VJDEBUG_SNPC_ENABLED == true then
			if GetConVar("vj_npc_printcurenemy"):GetInt() == 1 then print(self:GetClass().."'s Enemy: ",self:GetEnemy()," Alerted? ",self.Alerted) end
			if GetConVar("vj_npc_printtakingcover"):GetInt() == 1 then if CurTime() > self.TakingCoverT == true then print(self:GetClass().." Is Not Taking Cover") else print(self:GetClass().." Is Taking Cover ("..self.TakingCoverT-CurTime()..")") end end
			if GetConVar("vj_npc_printlastseenenemy"):GetInt() == 1 then PrintMessage(HUD_PRINTTALK, self.LastSeenEnemyTime.." ("..self:GetName()..")") end
		end
		
		self:SetPlaybackRate(self.AnimationPlaybackRate)
		if self:GetArrivalActivity() == -1 then
			self:SetArrivalActivity(self.CurrentAnim_IdleStand)
		end
		
		self:CustomOnThink_AIEnabled()

		self:IdleSoundCode()
		if self.DisableFootStepSoundTimer == false then self:FootStepSoundCode() end
		
		if self.HasHealthRegeneration == true && self.Dead == false && CurTime() > self.HealthRegenerationDelayT then
			self:SetHealth(math.Clamp(self:Health() + self.HealthRegenerationAmount, self:Health(), self:GetMaxHealth()))
			self.HealthRegenerationDelayT = CurTime() + math.Rand(self.HealthRegenerationDelay.a, self.HealthRegenerationDelay.b)
		end
		
		-- For AA move types
		if self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then
			local myVelLen = self:GetVelocity():Length()
			if myVelLen > 0 then
				if self.AA_CurrentMovePos then
					local dist = self.AA_CurrentMovePos:Distance(self:GetPos())
					-- Make sure we are making progress so we don't get stuck in a infinite movement!
					if self.AA_CurrentMoveDist == -1 or self.AA_CurrentMoveDist >= dist then
						self.AA_CurrentMoveDist = dist
						local moveSpeed = self.AA_CurrentMoveMaxSpeed;
						-- Only decelerate if the distance is smaller than the max speed!
						if self.AA_MoveDecelerate > 1 && dist < moveSpeed then
							moveSpeed = math.Clamp(dist, self.AA_CurrentMoveMaxSpeed / self.AA_MoveDecelerate, moveSpeed)
						elseif self.AA_MoveAccelerate > 0 then
							moveSpeed = Lerp(FrameTime()*self.AA_MoveAccelerate, myVelLen, moveSpeed)
						end
						local velPos = self.AA_CurrentMovePosDir:GetNormal()*moveSpeed
						local velTimeCur = CurTime() + (dist / velPos:Length())
						if velTimeCur == velTimeCur then -- Check for NaN
							self.AA_CurrentMoveTime = velTimeCur
						end
						self:SetLocalVelocity(velPos)
					-- We are NOT making any progress, stop the movement
					else
						self:AA_StopMoving()
					end
				end
				-- Is aquatic and is NOT completely in water then attempt to go down!
				if self.MovementType == VJ_MOVETYPE_AQUATIC && self:WaterLevel() <= 2 then
					self:AA_IdleWander()
				end
				if self.CurrentAnim_AAMovement != false then
					self:AA_MoveAnimation()
				end
			-- Not moving, reset its move time!
			else
				self.AA_CurrentMoveTime = 0
			end
		end
		
		-- Player Following
		if self.FollowingPlayer == true then
			//print(self:GetTarget())
			//print(self.FollowPlayer_Entity)
			if IsValid(self.FollowPlayer_Entity) && self.FollowPlayer_Entity:Alive() && self:Disposition(self.FollowPlayer_Entity) == D_LI then 
				if CurTime() > self.NextFollowPlayerT && self.AlreadyBeingHealedByMedic != true then
					local distToPly = self:GetPos():Distance(self.FollowPlayer_Entity:GetPos())
					local busy = self:BusyWithActivity()
					self:SetTarget(self.FollowPlayer_Entity)
					if distToPly > self.FollowPlayerCloseDistance then -- If the player is far then move
						-- If we are not very far and busy with another activity (ex: attacking) then don't move to the player yet!
						if !(busy == true and (distToPly < (self.FollowPlayerCloseDistance * 4))) && busy == false then
							self.FollowPlayer_GoingAfter = true
							self.FollowPlayer_DoneSelectSchedule = false
							-- If player is close, then just walk towards it instead of running
							local movetype = (distToPly < 220 and "TASK_WALK_PATH") or "TASK_RUN_PATH"
							self:VJ_TASK_GOTO_TARGET(movetype, function(x)
								x.CanShootWhenMoving = true
								x.ConstantlyFaceEnemyVisible = (IsValid(self:GetActiveWeapon()) and true) or false
							end)
						end
					elseif self.FollowPlayer_DoneSelectSchedule == false then -- If it's close to the player...
						if busy == false then -- If we aren't busy with a schedule, make it stop moving and do something
							self:StopMoving()
							self:SelectSchedule()
						end
						self.FollowPlayer_GoingAfter = false
						self.FollowPlayer_DoneSelectSchedule = true
					end
					self.NextFollowPlayerT = CurTime() + self.NextFollowPlayerTime
				end
			else
				self:FollowPlayerReset()
			end
		end

		//print(self:GetPathTimeToGoal())
		//print(self:GetPathDistanceToGoal())
		local ene = self:GetEnemy()
		
		-- Used for AA SNPCs
		/*if self.AA_CurrentTurnAng then
			local setAngs = self.AA_CurrentTurnAng
			self:SetAngles(Angle(setAngs.p, self:GetAngles().y, setAngs.r))
			self:SetIdealYawAndUpdate(setAngs.y)
			//self:SetAngles(Angle(math.ApproachAngle(self:GetAngles().p, self.AA_CurrentTurnAng.p, self.TurningSpeed),math.ApproachAngle(self:GetAngles().y, self.AA_CurrentTurnAng.y, self.TurningSpeed),math.ApproachAngle(self:GetAngles().r, self.AA_CurrentTurnAng.r, self.TurningSpeed)))
		end*/

		-- Turn to the current face position
		if self.IsDoingFacePosition != false then
			local setAngs = self.IsDoingFacePosition
			if self.TurningUseAllAxis == true then self:SetAngles(LerpAngle(FrameTime()*self.TurningSpeed, self:GetAngles(), Angle(setAngs.p, self:GetAngles().y, setAngs.r))) end
			self:SetIdealYawAndUpdate(setAngs.y)
		end
		
		if self.Dead == false then
			if IsValid(ene) then
				self:DoConstantlyFaceEnemyCode()
				if self.IsDoingFaceEnemy == true or (self.CombatFaceEnemy == true && self.CurrentSchedule != nil && ((self.CurrentSchedule.ConstantlyFaceEnemy == true) or (self.CurrentSchedule.ConstantlyFaceEnemyVisible == true && self:Visible(ene)))) then
					local setAngs = self:GetFaceAngle((ene:GetPos() - self:GetPos()):Angle())
					if self.TurningUseAllAxis == true then self:SetAngles(LerpAngle(FrameTime()*self.TurningSpeed, self:GetAngles(), Angle(setAngs.p, self:GetAngles().y, setAngs.r))) end
					self:SetIdealYawAndUpdate(setAngs.y)
				end
				-- Set the enemy variables
				self.EnemyReset = false
				self:UpdateEnemyMemory(ene, ene:GetPos())
				self.LatestEnemyDistance = self:GetPos():Distance(ene:GetPos())
				if (self:GetSightDirection():Dot((ene:GetPos() - self:GetPos()):GetNormalized()) > math.cos(math.rad(self.SightAngle))) && (self.LatestEnemyDistance < self.SightDistance) then
					local seentr = util.TraceLine({
						start = self:NearestPoint(self:GetPos() + self:OBBCenter()),
						endpos = ene:EyePos(),
						filter = function(ent) if (ent:GetClass() == self:GetClass() or self:Disposition(ent) == D_LI) then return false end end -- Ignore allies
					})
					if (ene:Visible(self) or (IsValid(seentr.Entity) && seentr.Entity:GetClass() == ene)) then
						self.LastSeenEnemyTime = 0
						self.LatestVisibleEnemyPosition = ene:GetPos()
					else
						self.LastSeenEnemyTime = self.LastSeenEnemyTime + 0.1
					end
				else
					self.LastSeenEnemyTime = self.LastSeenEnemyTime + 0.1
				end

				-- Call for help
				if self.CallForHelp == true && CurTime() > self.NextCallForHelpT then
					self:Allies_CallHelp(self.CallForHelpDistance)
					self.NextCallForHelpT = CurTime() + self.NextCallForHelpTime
				end
				
				-- Stop chasing at certain distance
				if self.NoChaseAfterCertainRange == true && self.VJ_IsBeingControlled != true && ((self.NoChaseAfterCertainRange_Type == "OnlyRange" && self.HasRangeAttack == true) or (self.NoChaseAfterCertainRange_Type == "Regular")) then
					local eneDist = self.LatestEnemyDistance
					local farDist = self.NoChaseAfterCertainRange_FarDistance
					local closeDist = self.NoChaseAfterCertainRange_CloseDistance
					if farDist == "UseRangeDistance" then farDist = self.RangeDistance end
					if closeDist == "UseRangeDistance" then closeDist = self.RangeToMeleeDistance end
					if (eneDist < farDist) && (eneDist > closeDist) && ene:Visible(self) /*&& self:CanDoCertainAttack("RangeAttack") == true*/ then
						local moveType = self.MovementType
						curSched = self.CurrentSchedule -- Already defined
						self.RangeAttack_DisableChasingEnemy = true
						if curSched != nil && curSched.Name == "vj_chase_enemy" then self:StopMoving() end
						if moveType == VJ_MOVETYPE_GROUND && !self:IsMoving() && self:OnGround() then self:FaceCertainEntity(self:GetEnemy()) end
						if (moveType == VJ_MOVETYPE_AERIAL or moveType == VJ_MOVETYPE_AQUATIC) then
							if self.AA_CurrentMoveType == 3 then self:AA_StopMoving() end -- Interrupt enemy chasing because we are in range!
							if CurTime() > self.AA_CurrentMoveTime then self:AA_IdleWander(true, "Calm", {FaceDest = !self.ConstantlyFaceEnemy}) /*self:AA_StopMoving()*/ end -- Only face the position if self.ConstantlyFaceEnemy is false!
						end
					else
						self.RangeAttack_DisableChasingEnemy = false
						if self.CurrentSchedule != nil && self.CurrentSchedule.Name != "vj_chase_enemy" then self:DoChaseAnimation() end
					end
				end
			end

			if CurTime() > self.NextProcessT then
				self:DoEntityRelationshipCheck()
				self:DoMedicCode()
				self.NextProcessT = CurTime() + self.NextProcessTime
			end

			if self.EnemyReset == false then
				-- Reset enemy if it doesn't exist or it's dead
				ene = self:GetEnemy()
				if (!IsValid(ene)) or (IsValid(ene) && ene:Health() <= 0) then
					self.EnemyReset = true
					self:ResetEnemy(true)
				end
				-- Reset enemy if it has been unseen for a while
				if self.LastSeenEnemyTime > self.LastSeenEnemyTimeUntilReset && (!self.IsVJBaseSNPC_Tank) then
					self:PlaySoundSystem("LostEnemy")
					self.EnemyReset = true
					self:ResetEnemy(true)
				end
			end

			--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
				-- Attack Timers --
			if self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then
				if IsValid(ene) && self.PlayingAttackAnimation == true && self:VJ_GetNearestPointToEntityDistance(ene) < self.MeleeAttackDistance then
					self:AA_StopMoving()
				else
					self:SelectSchedule()
				end
			end
			ene = self:GetEnemy()
			if IsValid(ene) then
				self:DoPoseParameterLooking()
				if (self.MovementType == VJ_MOVETYPE_STATIONARY && self.CanTurnWhileStationary == true) or (self.MeleeAttackAnimationFaceEnemy == true && self.MeleeAttack_DoingPropAttack == false && self.MeleeAttacking == true) or (self.RangeAttackAnimationFaceEnemy == true && self.RangeAttacking == true) or ((self.LeapAttackAnimationFaceEnemy == true or (self.LeapAttackAnimationFaceEnemy == 2 && !self.AlreadyDoneLeapAttackJump)) && self.LeapAttacking == true) then
					self:FaceCertainEntity(ene, true)
				end
				self.EnemyReset = false
				self.NearestPointToEnemyDistance = self:VJ_GetNearestPointToEntityDistance(ene)

				self:CustomAttack() -- Custom attack

				-- Melee Attack --------------------------------------------------------------------------------------------------------------------------------------------
				if self.HasMeleeAttack == true && self:CanDoCertainAttack("MeleeAttack") == true then
					self:MultipleMeleeAttacks()
					local atkType = 0 -- 0 = No attack | 1 = Normal attack | 2 = Prop attack
					if (self.VJ_IsBeingControlled == true && self.VJ_TheController:KeyDown(IN_ATTACK)) or (self.VJ_IsBeingControlled == false && self.NearestPointToEnemyDistance < self.MeleeAttackDistance && ene:Visible(self)) then
						atkType = 1
					elseif self:PushOrAttackPropsCode() == true && self.MeleeAttack_NoProps == false then
						atkType = 2
					end
					if self:CustomAttackCheck_MeleeAttack() == true && ((self.VJ_IsBeingControlled == true && atkType == 1) or (self.VJ_IsBeingControlled == false && atkType != 0 && (self:GetSightDirection():Dot((ene:GetPos() - self:GetPos()):GetNormalized()) > math.cos(math.rad(self.MeleeAttackAngleRadius))))) then
						local seed = CurTime(); self.CurAttackSeed = seed
						self.MeleeAttacking = true
						self.IsAbleToMeleeAttack = false
						self.AlreadyDoneMeleeAttackFirstHit = false
						self.AlreadyDoneFirstMeleeAttack = false
						self.RangeAttacking = false
						self.NextAlertSoundT = CurTime() + 0.4
						if atkType == 2 then
							self.MeleeAttack_DoingPropAttack = true
						else
							self:FaceCertainEntity(ene, true)
							self.MeleeAttack_DoingPropAttack = false
						end
						self:CustomOnMeleeAttack_BeforeStartTimer(seed)
						timer.Simple(self.BeforeMeleeAttackSounds_WaitTime, function() if IsValid(self) then self:PlaySoundSystem("BeforeMeleeAttack") end end)
						if self.DisableMeleeAttackAnimation == false then
							self.CurrentAttackAnimation = VJ_PICK(self.AnimTbl_MeleeAttack)
							self.CurrentAttackAnimationDuration = self:DecideAnimationLength(self.CurrentAttackAnimation, false, self.MeleeAttackAnimationDecreaseLengthAmount)
							if self.MeleeAttackAnimationAllowOtherTasks == false then -- Useful for gesture-based attacks
								self.PlayingAttackAnimation = true
								timer.Create("timer_act_playingattack"..self:EntIndex(), self.CurrentAttackAnimationDuration, 1, function() self.PlayingAttackAnimation = false end)
							end
							self:VJ_ACT_PLAYACTIVITY(self.CurrentAttackAnimation, false, 0, false, self.MeleeAttackAnimationDelay, {SequenceDuration=self.CurrentAttackAnimationDuration})
						end
						if self.TimeUntilMeleeAttackDamage == false then 
							self:MeleeAttackCode_DoFinishTimers()
						else -- If it's not event based...
							timer.Create("timer_melee_start"..self:EntIndex(), self.TimeUntilMeleeAttackDamage / self:GetPlaybackRate(), self.MeleeAttackReps, function() if self.CurAttackSeed == seed then
									if atkType == 2 then
										self:MeleeAttackCode(true)
									else
										self:MeleeAttackCode()
									end
							end end)
							for k, t in pairs(self.MeleeAttackExtraTimers or {}) do
								self:DoAddExtraAttackTimers("timer_melee_start_"..CurTime() + k, t, function() if self.CurAttackSeed == seed then if atkType == 2 then
										self:MeleeAttackCode(true)
									else
										self:MeleeAttackCode()
									end
								end end)
							end
						end
						self:CustomOnMeleeAttack_AfterStartTimer(seed)
					end
				end

				-- Range Attack --------------------------------------------------------------------------------------------------------------------------------------------
				if self.HasRangeAttack == true && self:CanDoCertainAttack("RangeAttack") == true then
					self:MultipleRangeAttacks()
					if self:CustomAttackCheck_RangeAttack() == true && ((self.VJ_IsBeingControlled == true && self.VJ_TheController:KeyDown(IN_ATTACK2)) or (self.VJ_IsBeingControlled == false && (self.LatestEnemyDistance < self.RangeDistance) && (self.LatestEnemyDistance > self.RangeToMeleeDistance) && (self:GetSightDirection():Dot((ene:GetPos() -self:GetPos()):GetNormalized()) > math.cos(math.rad(self.RangeAttackAngleRadius))))) then
						local seed = CurTime(); self.CurAttackSeed = seed
						self.RangeAttacking = true
						self.IsAbleToRangeAttack = false
						self.AlreadyDoneRangeAttackFirstProjectile = false
						if self.RangeAttackAnimationStopMovement == true then self:StopMoving() end
						self:CustomOnRangeAttack_BeforeStartTimer(seed)
						self:PlaySoundSystem("BeforeRangeAttack")
						if self.DisableRangeAttackAnimation == false then
							self.CurrentAttackAnimation = VJ_PICK(self.AnimTbl_RangeAttack)
							self.CurrentAttackAnimationDuration = self:DecideAnimationLength(self.CurrentAttackAnimation, false, self.RangeAttackAnimationDecreaseLengthAmount)
							self.PlayingAttackAnimation = true
							timer.Create("timer_act_playingattack"..self:EntIndex(), self.CurrentAttackAnimationDuration, 1, function() self.PlayingAttackAnimation = false end)
							self:VJ_ACT_PLAYACTIVITY(self.CurrentAttackAnimation, false, 0, false, self.RangeAttackAnimationDelay, {SequenceDuration=self.CurrentAttackAnimationDuration})
						end
						if self.TimeUntilRangeAttackProjectileRelease == false then
							self:RangeAttackCode_DoFinishTimers()
						else -- If it's not event based...
							timer.Create("timer_range_start"..self:EntIndex(), self.TimeUntilRangeAttackProjectileRelease / self:GetPlaybackRate(), self.RangeAttackReps, function() if self.CurAttackSeed == seed then self:RangeAttackCode() end end)
							for k, t in pairs(self.RangeAttackExtraTimers or {}) do
								self:DoAddExtraAttackTimers("timer_range_start_"..CurTime() + k, t, function() if self.CurAttackSeed == seed then self:RangeAttackCode() end end)
							end
						end
						self:CustomOnRangeAttack_AfterStartTimer(seed)
					end
				end

				-- Leap Attack --------------------------------------------------------------------------------------------------------------------------------------------
				if self.HasLeapAttack == true && self:CanDoCertainAttack("LeapAttack") == true then
					self:MultipleLeapAttacks()
					if self:CustomAttackCheck_LeapAttack() == true && ((self.VJ_IsBeingControlled == true && self.VJ_TheController:KeyDown(IN_JUMP)) or (self.VJ_IsBeingControlled == false && (self:IsOnGround() && self.LatestEnemyDistance < self.LeapDistance) && (self.LatestEnemyDistance > self.LeapToMeleeDistance) && (self:GetSightDirection():Dot((ene:GetPos() -self:GetPos()):GetNormalized()) > math.cos(math.rad(self.LeapAttackAngleRadius))))) then
						local seed = CurTime(); self.CurAttackSeed = seed
						self.LeapAttacking = true
						self.IsAbleToLeapAttack = false
						self.AlreadyDoneLeapAttackFirstHit = false
						self.AlreadyDoneFirstLeapAttack = false
						self.AlreadyDoneLeapAttackJump = false
						//self.JumpLegalLandingTime = 0
						self:CustomOnLeapAttack_BeforeStartTimer(seed)
						self:PlaySoundSystem("BeforeRangeAttack")
						timer.Create( "timer_leap_start_jump"..self:EntIndex(), self.TimeUntilLeapAttackVelocity / self:GetPlaybackRate(), 1, function() self:LeapAttackVelocityCode() end)
						if self.DisableLeapAttackAnimation == false then
							self.CurrentAttackAnimation = VJ_PICK(self.AnimTbl_LeapAttack)
							self.CurrentAttackAnimationDuration = self:DecideAnimationLength(self.CurrentAttackAnimation, false, self.LeapAttackAnimationDecreaseLengthAmount)
							self.PlayingAttackAnimation = true
							timer.Create("timer_act_playingattack"..self:EntIndex(), self.CurrentAttackAnimationDuration, 1, function() self.PlayingAttackAnimation = false end)
							self:VJ_ACT_PLAYACTIVITY(self.CurrentAttackAnimation, false, 0, false, self.LeapAttackAnimationDelay, {SequenceDuration=self.CurrentAttackAnimationDuration})
						end
						if self.TimeUntilLeapAttackDamage == false then
							self:LeapAttackCode_DoFinishTimers()
						else -- If it's not event based...
							timer.Create( "timer_leap_start"..self:EntIndex(), self.TimeUntilLeapAttackDamage / self:GetPlaybackRate(), self.LeapAttackReps, function() if self.CurAttackSeed == seed then self:LeapDamageCode() end end)
							for k, t in pairs(self.LeapAttackExtraTimers or {}) do
								self:DoAddExtraAttackTimers("timer_leap_start_"..CurTime() + k, t, function() if self.CurAttackSeed == seed then self:LeapDamageCode() end end)
							end
						end
						self:CustomOnLeapAttack_AfterStartTimer(seed)
					end
				end
			else -- No enemy
				if self.VJ_IsBeingControlled == false then
					self:DoPoseParameterLooking(true)
					//self:ClearPoseParameters()
				end
				self.TimeSinceEnemyAcquired = 0
				self.TimeSinceLastSeenEnemy = self.TimeSinceLastSeenEnemy + 0.1
				if self.EnemyReset == false && (!self.IsVJBaseSNPC_Tank) then self:PlaySoundSystem("LostEnemy") self.EnemyReset = true self:ResetEnemy(true) end
			end
			
			-- Guarding Position
			if self.IsGuard == true && self.FollowingPlayer == false then
				if self.GuardingPosition == nil then -- If it hasn't been set then set the guard position to its current position
					self.GuardingPosition = self:GetPos()
					self.GuardingFacePosition = self:GetPos() + self:GetForward()*51
				end
				-- If it's far from the guarding position, then go there!
				if !self:IsMoving() && self:BusyWithActivity() == false then
					local dist = self:GetPos():Distance(self.GuardingPosition) -- Distance to the guard position
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
		if (self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC) then self:AA_StopMoving() end
	end
	self:NextThink(CurTime() + (0.069696968793869 + FrameTime()))
	return true
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CanDoCertainAttack(atkName)
	atkName = atkName or "MeleeAttack"
	-- Attack Names: "MeleeAttack" || "RangeAttack" || "LeapAttack"
	if self.MeleeAttacking == true or self.LeapAttacking == true or self.RangeAttacking == true or self.NextDoAnyAttackT > CurTime() or self.FollowPlayer_GoingAfter == true or self.vACT_StopAttacks == true or self.Flinching == true or self.Behavior == VJ_BEHAVIOR_PASSIVE or self.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE or self:GetState() == VJ_STATE_ONLY_ANIMATION_NOATTACK /*or self.VJ_IsBeingControlled == true*/ then return false end
	
	if atkName == "MeleeAttack" && self.IsAbleToMeleeAttack == true /*&& self.VJ_PlayingSequence == false*/ then
		// if self.VJ_IsBeingControlled == true then if self.VJ_TheController:KeyDown(IN_ATTACK) then return true else return false end end
		return true
	elseif atkName == "RangeAttack" && self.IsAbleToRangeAttack == true && self:GetEnemy():Visible(self) /*&& self.VJ_PlayingSequence == false*/ then
		return true
	elseif atkName == "LeapAttack" && self.IsAbleToLeapAttack == true && self:GetEnemy():Visible(self) /*&& self.VJ_PlayingSequence == false*/ then
		return true
	end
	return false
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoPropVisibility(propEnt)
	local tr = util.TraceLine({
		start = self:GetPos(),
		endpos = propEnt:GetPos() + propEnt:GetUp()*10,
		filter = self
	})
	return IsValid(tr.Entity) && !tr.HitWorld && !tr.HitSky
end
--------------------------------------------------------------------------------------------------------------------------------------------
local propColBlacklist = {[COLLISION_GROUP_DEBRIS]=true, [COLLISION_GROUP_DEBRIS_TRIGGER]=true, [COLLISION_GROUP_DISSOLVING]=true, [COLLISION_GROUP_IN_VEHICLE]=true, [COLLISION_GROUP_WORLD]=true}
local IsProp = VJ_IsProp
--
function ENT:PushOrAttackPropsCode(customEnts, customMeleeDistance)
	if self.PushProps == false && self.AttackProps == false then return end
	for _,v in pairs(customEnts or ents.FindInSphere(self:SetMeleeAttackDamagePosition(), customMeleeDistance or math.Clamp(self.MeleeAttackDamageDistance - 30, self.MeleeAttackDistance, self.MeleeAttackDamageDistance))) do
		local isEnt = (self.EntitiesToDestroyClass[v:GetClass()] or v.VJ_AddEntityToSNPCAttackList == true) and true or false -- Whether or not it's a prop or an entity to attack
		if v:GetClass() == "prop_door_rotating" && v:Health() <= 0 then isEnt = false end -- If it's a door and it has no health, then don't attack it!
		if IsProp(v) == true or isEnt == true then --If it's a prop or a entity then atttack
			//print(self:DoPropVisibility(v))
			local phys = v:GetPhysicsObject()
			-- Serpevadz abrankner: self:VJ_GetNearestPointToEntityDistance(v) < (customMeleeDistance) && self:Visible(v)
			if IsValid(phys) && !propColBlacklist[v:GetCollisionGroup()] && self:DoPropVisibility(v) && (self:GetSightDirection():Dot((v:GetPos() - self:GetPos()):GetNormalized()) > math.cos(math.rad(self.MeleeAttackAngleRadius / 1.3))) then
				if isEnt == true then return true end -- Since it's an entity, no need to check for size etc.
				-- Attacking: Make sure it has health
				if self.AttackProps == true && v:Health() > 0 then
					return true
				end
				-- Pushing: Make sure it's not a small object and the NPC is appropriately sized to push the object
				if self.PushProps == true && phys:GetMass() > 4 && phys:GetSurfaceArea() > 800 then
					local selfPhys = self:GetPhysicsObject()
					if IsValid(selfPhys) && (selfPhys:GetSurfaceArea() * self.PropAP_MaxSize) >= phys:GetSurfaceArea() then
						return true
					end
				end
			end
		end
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MeleeAttackCode(isPropAttack, attackDist, customEnt)
	if self.Dead == true or self.vACT_StopAttacks == true or self.Flinching == true or (self.StopMeleeAttackAfterFirstHit == true && self.AlreadyDoneMeleeAttackFirstHit == true) then return end
	isPropAttack = isPropAttack or self.MeleeAttack_DoingPropAttack -- Is this a prop attack?
	attackDist = attackDist or self.MeleeAttackDamageDistance -- How far should the attack go?
	local curEnemy = customEnt or self:GetEnemy()
	if self.MeleeAttackAnimationFaceEnemy == true && isPropAttack == false then self:FaceCertainEntity(curEnemy, true) end
	//self.MeleeAttacking = true
	self:CustomOnMeleeAttack_BeforeChecks()
	if self.DisableDefaultMeleeAttackCode == true then return end
	local myPos = self:GetPos()
	local hitRegistered = false
	for _,v in pairs(ents.FindInSphere(self:SetMeleeAttackDamagePosition(), attackDist)) do
		if (self.VJ_IsBeingControlled == true && self.VJ_TheControllerBullseye == v) or (v:IsPlayer() && v.IsControlingNPC == true) then continue end -- If controlled and v is the bullseye OR it's a player controlling then don't damage!
		if v != self && v:GetClass() != self:GetClass() && (((v:IsNPC() or (v:IsPlayer() && v:Alive() && GetConVar("ai_ignoreplayers"):GetInt() == 0)) && self:Disposition(v) != D_LI) or VJ_IsProp(v) == true or v:GetClass() == "func_breakable_surf" or self.EntitiesToDestroyClass[v:GetClass()] or v.VJ_AddEntityToSNPCAttackList == true) && self:GetSightDirection():Dot((Vector(v:GetPos().x, v:GetPos().y, 0) - Vector(myPos.x, myPos.y, 0)):GetNormalized()) > math.cos(math.rad(self.MeleeAttackDamageAngleRadius)) then
			if isPropAttack == true && (v:IsPlayer() or v:IsNPC()) && self:VJ_GetNearestPointToEntityDistance(v) > self.MeleeAttackDistance then continue end //if (self:GetPos():Distance(v:GetPos()) <= self:VJ_GetNearestPointToEntityDistance(v) && self:VJ_GetNearestPointToEntityDistance(v) <= self.MeleeAttackDistance) == false then
			local vProp = VJ_IsProp(v)
			if self:CustomOnMeleeAttack_AfterChecks(v, vProp) == true then continue end
			-- Remove prop constraints and push it (If possbile)
			if vProp == true then
				local phys = v:GetPhysicsObject()
				if IsValid(phys) && self:PushOrAttackPropsCode({v}, attackDist) then
					hitRegistered = true
					phys:EnableMotion(true)
					//phys:EnableGravity(true)
					phys:Wake()
					//constraint.RemoveAll(v)
					//if util.IsValidPhysicsObject(v, 1) then
					constraint.RemoveConstraints(v, "Weld") //end
					if self.PushProps == true then
						phys:ApplyForceCenter((curEnemy != nil and curEnemy:GetPos() or myPos) + self:GetForward()*(phys:GetMass() * 700) + self:GetUp()*(phys:GetMass() * 200))
					end
				end
			end
			-- Knockback
			if self.HasMeleeAttackKnockBack == true && v.MovementType != VJ_MOVETYPE_STATIONARY && (v.VJ_IsHugeMonster != true or v.IsVJBaseSNPC_Tank == true) then
				v:SetGroundEntity(NULL)
				v:SetVelocity(self:GetForward()*math.random(self.MeleeAttackKnockBack_Forward1, self.MeleeAttackKnockBack_Forward2) + self:GetUp()*math.random(self.MeleeAttackKnockBack_Up1, self.MeleeAttackKnockBack_Up2) + self:GetRight()*math.random(self.MeleeAttackKnockBack_Right1, self.MeleeAttackKnockBack_Right2))
			end
			-- Damage
			if self.DisableDefaultMeleeAttackDamageCode == false then
				local applyDmg = DamageInfo()
				applyDmg:SetDamage(self:VJ_GetDifficultyValue(self.MeleeAttackDamage))
				applyDmg:SetDamageType(self.MeleeAttackDamageType)
				//applyDmg:SetDamagePosition(self:VJ_GetNearestPointToEntity(v).MyPosition)
				if v:IsNPC() or v:IsPlayer() then applyDmg:SetDamageForce(self:GetForward()*((applyDmg:GetDamage()+100)*70)) end
				applyDmg:SetInflictor(self)
				applyDmg:SetAttacker(self)
				v:TakeDamageInfo(applyDmg, self)
			end
			-- Bleed Enemy
			if self.MeleeAttackBleedEnemy == true && math.random(1, self.MeleeAttackBleedEnemyChance) == 1 && ((v:IsNPC() && (!VJ_IsHugeMonster)) or v:IsPlayer()) then
				self:CustomOnMeleeAttack_BleedEnemy(v)
				local tName = "timer_melee_bleedply"..v:EntIndex() -- Timer's name
				local tDmg = self.MeleeAttackBleedEnemyDamage -- How much damage each rep does
				timer.Create(tName, self.MeleeAttackBleedEnemyTime, self.MeleeAttackBleedEnemyReps, function()
					if IsValid(v) && v:Health() > 0 then
						v:TakeDamage(tDmg, self, self)
					else -- Remove the timer if the entity is dead in attempt to remove it before the entity respawns (Essential for players)
						timer.Remove(tName)
					end
				end)
			end
			if v:IsPlayer() then
				-- Apply DSP
				if self.MeleeAttackDSPSoundType != false && ((self.MeleeAttackDSPSoundUseDamage == false) or (self.MeleeAttackDSPSoundUseDamage == true && self.MeleeAttackDamage >= self.MeleeAttackDSPSoundUseDamageAmount && GetConVar("vj_npc_nomeleedmgdsp"):GetInt() == 0)) then
					v:SetDSP(self.MeleeAttackDSPSoundType, false)
				end
				v:ViewPunch(Angle(math.random(-1, 1)*self.MeleeAttackDamage, math.random(-1, 1)*self.MeleeAttackDamage, math.random(-1, 1)*self.MeleeAttackDamage))
				-- Slow Player
				if self.SlowPlayerOnMeleeAttack == true then
					self:VJ_DoSlowPlayer(v, self.SlowPlayerOnMeleeAttack_WalkSpeed, self.SlowPlayerOnMeleeAttack_RunSpeed, self.SlowPlayerOnMeleeAttackTime, {PlaySound=self.HasMeleeAttackSlowPlayerSound, SoundTable=self.SoundTbl_MeleeAttackSlowPlayer, SoundLevel=self.MeleeAttackSlowPlayerSoundLevel, FadeOutTime=self.MeleeAttackSlowPlayerSoundFadeOutTime})
					self:CustomOnMeleeAttack_SlowPlayer(v)
				end
			end
			VJ_DestroyCombineTurret(self,v)
			if !vProp then -- Only for non-props...
				hitRegistered = true
			end
		end
	end
	if hitRegistered == true then
		self:PlaySoundSystem("MeleeAttack")
		if self.StopMeleeAttackAfterFirstHit == true then self.AlreadyDoneMeleeAttackFirstHit = true /*self:StopMoving()*/ end
	else
		self:CustomOnMeleeAttack_Miss()
		if self.MeleeAttackWorldShakeOnMiss == true then util.ScreenShake(myPos,self.MeleeAttackWorldShakeOnMissAmplitude,self.MeleeAttackWorldShakeOnMissFrequency,self.MeleeAttackWorldShakeOnMissDuration,self.MeleeAttackWorldShakeOnMissRadius) end
		self:PlaySoundSystem("MeleeAttackMiss", {}, VJ_EmitSound)
	end
	//if self.VJ_IsBeingControlled == false && self.MeleeAttackAnimationFaceEnemy == true then self:FaceCertainEntity(curEnemy,true) end
	if self.AlreadyDoneFirstMeleeAttack == false && self.TimeUntilMeleeAttackDamage != false then
		self:MeleeAttackCode_DoFinishTimers()
	end
	self.AlreadyDoneFirstMeleeAttack = true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_DoSlowPlayer(ent, WalkSpeed, RunSpeed, SlowTime, sdData, ExtraFeatures, customFunc)
	WalkSpeed = WalkSpeed or 50
	RunSpeed = RunSpeed or 50
	SlowTime = SlowTime or 5
	sdData = sdData or {}
		local vSD_PlaySound = sdData.PlaySound or false -- Should it play a sound?
		local vSD_SoundTable = sdData.SoundTable or {} -- Sounds it should play (Picks randomly)
		local vSD_SoundLevel = sdData.SoundLevel or 100 -- How loud should the sound play?
		local vSD_FadeOutTime = sdData.FadeOutTime or 1 -- How long until it the sound fully fades out?
	ExtraFeatures = ExtraFeatures or {}
		vEF_NoInterrupt = ExtraFeatures.NoInterrupt or false -- If set to true, the player's speed won't change by another instance of this code
	local walkspeed_before = ent:GetWalkSpeed()
	local runspeed_before = ent:GetRunSpeed()
	if ent.VJ_HasAlreadyBeenSlowedDown == true && ent.VJ_HasAlreadyBeenSlowedDown_NoInterrupt == true then return end
	if (!ent.VJ_HasAlreadyBeenSlowedDown) then
		ent.VJ_HasAlreadyBeenSlowedDown = true
		if vEF_NoInterrupt == true then ent.VJ_HasAlreadyBeenSlowedDown_NoInterrupt = true end
		ent.VJ_SlowDownPlayerWalkSpeed = walkspeed_before
		ent.VJ_SlowDownPlayerRunSpeed = runspeed_before
	end
	ent:SetWalkSpeed(WalkSpeed)
	ent:SetRunSpeed(RunSpeed)
	if (customFunc) then customFunc() end
	if self.HasSounds == true && vSD_PlaySound == true then
		self.CurrentSlowPlayerSound = CreateSound(ent,VJ_PICK(vSD_SoundTable))
		self.CurrentSlowPlayerSound:Play()
		self.CurrentSlowPlayerSound:SetSoundLevel(vSD_SoundLevel)
		if !ent:Alive() && self.CurrentSlowPlayerSound then self.CurrentSlowPlayerSound:FadeOut(vSD_FadeOutTime) end
	end
	local slowplysd = self.CurrentSlowPlayerSound
	local slowplysd_fade = vSD_FadeOutTime
	local timername = "timer_melee_slowply"..ent:EntIndex()
	
	if timer.Exists(timername) && timer.TimeLeft(timername) > SlowTime then
		return
	end
	timer.Create(timername, SlowTime, 1, function()
		ent:SetWalkSpeed(ent.VJ_SlowDownPlayerWalkSpeed)
		ent:SetRunSpeed(ent.VJ_SlowDownPlayerRunSpeed)
		ent.VJ_HasAlreadyBeenSlowedDown = false
		ent.VJ_HasAlreadyBeenSlowedDown_NoInterrupt = false
		if slowplysd then slowplysd:FadeOut(slowplysd_fade) end
		if !IsValid(ent) then timer.Remove(timername) end
	end)
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
function ENT:RangeAttackCode()
	if self.Dead == true or self.vACT_StopAttacks == true or self.Flinching == true or self.MeleeAttacking == true then return end
	if IsValid(self:GetEnemy()) then
		self.RangeAttacking = true
		self:PlaySoundSystem("RangeAttack")
		if self.RangeAttackAnimationStopMovement == true then self:StopMoving() end
		if self.RangeAttackAnimationFaceEnemy == true then self:FaceCertainEntity(self:GetEnemy(), true) end
		//self:PointAtEntity(self:GetEnemy())
		self:CustomRangeAttackCode()
		-- Default projectile code
		if self.DisableDefaultRangeAttackCode == false then
			local projectile = ents.Create(self.RangeAttackEntityToSpawn)
			local spawnpos_override = self:RangeAttackCode_OverrideProjectilePos(projectile)
			if spawnpos_override == 0 then -- 0 = Let base decide
				if self.RangeUseAttachmentForPos == false then
					projectile:SetPos(self:GetPos() + self:GetUp()*self.RangeAttackPos_Up + self:GetForward()*self.RangeAttackPos_Forward + self:GetRight()*self.RangeAttackPos_Right)
				else
					projectile:SetPos(self:GetAttachment(self:LookupAttachment(self.RangeUseAttachmentForPosID)).Pos)
				end
			else -- Custom position
				projectile:SetPos(spawnpos_override)
			end
			projectile:SetAngles((self:GetEnemy():GetPos() - projectile:GetPos()):Angle())
			self:CustomRangeAttackCode_BeforeProjectileSpawn(projectile)
			projectile:SetOwner(self)
			projectile:SetPhysicsAttacker(self)
			projectile:Spawn()
			projectile:Activate()
			//constraint.NoCollide(self,projectile,0,0)
			local phys = projectile:GetPhysicsObject()
			if IsValid(phys) then
				phys:Wake()
				local vel = self:RangeAttackCode_GetShootPos(projectile)
				phys:SetVelocity(vel) //ApplyForceCenter
				projectile:SetAngles(vel:GetNormal():Angle())
			end
			self:CustomRangeAttackCode_AfterProjectileSpawn(projectile)
		end
	end
	if self.AlreadyDoneRangeAttackFirstProjectile == false && self.TimeUntilRangeAttackProjectileRelease != false then
		self:RangeAttackCode_DoFinishTimers()
	end
	self.AlreadyDoneRangeAttackFirstProjectile = true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackCode_DoFinishTimers(skipStopAttacks)
	if skipStopAttacks != true then
		timer.Create("timer_range_finished"..self:EntIndex(), self:DecideAttackTimer(self.NextAnyAttackTime_Range,self.NextAnyAttackTime_Range_DoRand,self.TimeUntilRangeAttackProjectileRelease,self.CurrentAttackAnimationDuration), 1, function()
			self:StopAttacks()
			self:DoChaseAnimation()
		end)
	end
	timer.Create("timer_range_finished_abletorange"..self:EntIndex(), self:DecideAttackTimer(self.NextRangeAttackTime,self.NextRangeAttackTime_DoRand), 1, function()
		self.IsAbleToRangeAttack = true
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:LeapDamageCode()
	if self.Dead == true or self.vACT_StopAttacks == true or self.Flinching == true then return end
	if self.StopLeapAttackAfterFirstHit == true && self.AlreadyDoneLeapAttackFirstHit == true then return end
	self:CustomOnLeapAttack_BeforeChecks()
	local hitRegistered = false
	local FindEnts = ents.FindInSphere(self:GetPos(),self.LeapAttackDamageDistance)
	if FindEnts != nil then
		for _,v in pairs(FindEnts) do
			if (self.VJ_IsBeingControlled == true && self.VJ_TheControllerBullseye == v) or (v:IsPlayer() && v.IsControlingNPC == true) then continue end
			if (v:IsNPC() or (v:IsPlayer() && v:Alive()) && GetConVar("ai_ignoreplayers"):GetInt() == 0) && (self:Disposition(v) != D_LI) && (v != self) && (v:GetClass() != self:GetClass()) or VJ_IsProp(v) == true or v:GetClass() == "func_breakable_surf" or v:GetClass() == "func_breakable" then
				self:CustomOnLeapAttack_AfterChecks(v)
				local leapdmg = DamageInfo()
				leapdmg:SetDamage(self:VJ_GetDifficultyValue(self.LeapAttackDamage))
				leapdmg:SetInflictor(self)
				leapdmg:SetDamageType(self.LeapAttackDamageType)
				leapdmg:SetAttacker(self)
				if v:IsNPC() or v:IsPlayer() then leapdmg:SetDamageForce(self:GetForward()*((leapdmg:GetDamage()+100)*70)) end
				v:TakeDamageInfo(leapdmg, self)
				if v:IsPlayer() then
					v:ViewPunch(Angle(math.random(-1,1)*self.LeapAttackDamage,math.random(-1,1)*self.LeapAttackDamage,math.random(-1,1)*self.LeapAttackDamage))
				end
				hitRegistered = true
			end
		end
	end
 	if hitRegistered == false then
		self:CustomOnLeapAttack_Miss()
		self:PlaySoundSystem("LeapAttackDamageMiss", nil, VJ_EmitSound)
	else
		self:PlaySoundSystem("LeapAttackDamage")
		if self.StopLeapAttackAfterFirstHit == true then self.AlreadyDoneLeapAttackFirstHit = true /*self:SetLocalVelocity(Vector(0, 0, 0))*/ end
	end
	if self.AlreadyDoneFirstLeapAttack == false && self.TimeUntilLeapAttackDamage != false then
		self:LeapAttackCode_DoFinishTimers()
	end
	self.AlreadyDoneFirstLeapAttack = true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:LeapAttackCode_DoFinishTimers(skipStopAttacks)
	if skipStopAttacks != true then
		timer.Create("timer_leap_finished"..self:EntIndex(), self:DecideAttackTimer(self.NextAnyAttackTime_Leap,self.NextAnyAttackTime_Leap_DoRand,self.TimeUntilLeapAttackDamage,self.CurrentAttackAnimationDuration), 1, function()
			self:StopAttacks()
			self:DoChaseAnimation()
		end)
	end
	timer.Create("timer_leap_finished_abletoleap"..self:EntIndex(), self:DecideAttackTimer(self.NextLeapAttackTime,self.NextLeapAttackTime_DoRand), 1, function()
		self.IsAbleToLeapAttack = true
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:LeapAttackVelocityCode()
	if !IsValid(self:GetEnemy()) then return end
	self:SetGroundEntity(NULL)
	if self.LeapAttackAnimationFaceEnemy == true then self:FaceCertainEntity(self:GetEnemy(), true) end
	self.AlreadyDoneLeapAttackJump = true
	if self:CustomOnLeapAttackVelocityCode() != true then
		self:SetLocalVelocity(((self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter()) - (self:GetPos() + self:OBBCenter())):GetNormal()*400 + self:GetForward()*self.LeapAttackVelocityForward + self:GetUp()*self.LeapAttackVelocityUp + self:GetRight()*self.LeapAttackVelocityRight)
	end 
	self:PlaySoundSystem("LeapAttackJump")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StopAttacks(checkTimers)
	if self:Health() <= 0 then return end
	if self.VJDEBUG_SNPC_ENABLED == true && GetConVar("vj_npc_printstoppedattacks"):GetInt() == 1 then print(self:GetClass().." Stopped all Attacks!") end
	
	if checkTimers == true then
		if self.MeleeAttacking == true && self.AlreadyDoneFirstMeleeAttack == false then self:MeleeAttackCode_DoFinishTimers(true) end
		if self.RangeAttacking == true && self.AlreadyDoneRangeAttackFirstProjectile == false then self:RangeAttackCode_DoFinishTimers(true) end
		if self.LeapAttacking == true && self.AlreadyDoneFirstLeapAttack == false then self:LeapAttackCode_DoFinishTimers(true) end
	end
	
	self.CurAttackSeed = 0
	-- Melee
	self.MeleeAttacking = false
	self.AlreadyDoneMeleeAttackFirstHit = false
	self.AlreadyDoneFirstMeleeAttack = false
	-- Range
	self.RangeAttacking = false
	self.AlreadyDoneRangeAttackFirstProjectile = false
	-- Leap
	self.LeapAttacking = false
	self.AlreadyDoneLeapAttackFirstHit = false
	self.AlreadyDoneFirstLeapAttack = false
	self.AlreadyDoneLeapAttackJump = false

	self:DoChaseAnimation()
end
---------------------------------------------------------------------------------------------------------------------------------------------
local ang_app = math.ApproachAngle
--
function ENT:DoPoseParameterLooking(resetPoses)
	if self.HasPoseParameterLooking == false then return end
	resetPoses = resetPoses or false
	//self:GetPoseParameters(true)
	local ent = (self.VJ_IsBeingControlled == true and self.VJ_TheController) or self:GetEnemy()
	local p_enemy = 0 -- Pitch
	local y_enemy = 0 -- Yaw
	local r_enemy = 0 -- Roll
	if IsValid(ent) && resetPoses == false then
		local enemy_pos = (self.VJ_IsBeingControlled == true and self.VJ_TheControllerBullseye:GetPos()) or ent:GetPos() + ent:OBBCenter()
		local self_ang = self:GetAngles()
		local enemy_ang = (enemy_pos - (self:GetPos() + self:OBBCenter())):Angle()
		p_enemy = math.AngleDifference(enemy_ang.p, self_ang.p)
		if self.PoseParameterLooking_InvertPitch == true then p_enemy = -p_enemy end
		y_enemy = math.AngleDifference(enemy_ang.y, self_ang.y)
		if self.PoseParameterLooking_InvertYaw == true then y_enemy = -y_enemy end
		r_enemy = math.AngleDifference(enemy_ang.z, self_ang.z)
		if self.PoseParameterLooking_InvertRoll == true then r_enemy = -r_enemy end
	elseif self.PoseParameterLooking_CanReset == false then -- Should it reset its pose parameters if there is no enemies?
		return
	end
	
	self:CustomOn_PoseParameterLookingCode(p_enemy, y_enemy, r_enemy)
	
	local names = self.PoseParameterLooking_Names
	for x = 1, #names.pitch do
		self:SetPoseParameter(names.pitch[x], ang_app(self:GetPoseParameter(names.pitch[x]), p_enemy, self.PoseParameterLooking_TurningSpeed))
	end
	for x = 1, #names.yaw do
		self:SetPoseParameter(names.yaw[x], ang_app(self:GetPoseParameter(names.yaw[x]), y_enemy, self.PoseParameterLooking_TurningSpeed))
	end
	for x = 1, #names.roll do
		self:SetPoseParameter(names.roll[x], ang_app(self:GetPoseParameter(names.roll[x]), r_enemy, self.PoseParameterLooking_TurningSpeed))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SelectSchedule()
	if self.VJ_IsBeingControlled == true then return end
	self:CustomOnSchedule()
	if self.DisableSelectSchedule == true or self.Dead == true then return end
	
	local ene = self:GetEnemy()
	if IsValid(ene) && (self.LatestEnemyDistance > self.SightDistance) then -- If the enemy is out of reach, then reset the enemy!
		self.TakingCoverT = 0
		self:DoIdleAnimation()
		self:ResetEnemy()
	elseif self.PlayingAttackAnimation == false or self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then
		if IsValid(ene) then -- Chase the enemy
			self:DoChaseAnimation()
		/*elseif self.Alerted == true then -- No enemy, but alerted
			self.TakingCoverT = 0
			self:DoIdleAnimation()*/
		else -- Idle
			self.TakingCoverT = 0
			self:DoIdleAnimation()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ResetEnemy(checkAlliesEnemy)
	if self.NextResetEnemyT > CurTime() or self.Dead == true then self.EnemyReset = false return false end
	checkAlliesEnemy = checkAlliesEnemy or false
	local RunToEnemyOnReset = false
	if checkAlliesEnemy == true then
		local getAllies = self:Allies_Check(1000)
		if getAllies != nil then
			for _,v in pairs(getAllies) do
				if IsValid(v:GetEnemy()) && v.LastSeenEnemyTime < self.LastSeenEnemyTimeUntilReset && VJ_IsAlive(v:GetEnemy()) == true && self:VJ_HasNoTarget(v:GetEnemy()) == false && self:GetPos():Distance(v:GetEnemy():GetPos()) <= self.SightDistance then
					self:VJ_DoSetEnemy(v:GetEnemy(), true)
					self.EnemyReset = false
					return false
				end
			end
		end
		local curEnemies = self.ReachableEnemyCount //self.CurrentReachableEnemies
		-- If the current number of reachable enemies is higher then 1, then don't reset
		if (IsValid(self:GetEnemy()) && (curEnemies - 1) >= 1) or (!IsValid(self:GetEnemy()) && curEnemies >= 1) then
			//self:VJ_DoSetEnemy(v, false, true)
			self:DoEntityRelationshipCheck() -- Select a new enemy
			self.NextProcessT = CurTime() + self.NextProcessTime
			self.EnemyReset = false
			return false
		end
	end
	
	self.Alerted = false
	self:CustomOnResetEnemy()
	if self.VJDEBUG_SNPC_ENABLED == true && GetConVar("vj_npc_printresetenemy"):GetInt() == 1 then print(self:GetName().." has reseted its enemy") end
	if IsValid(self:GetEnemy()) then
		if self.FollowingPlayer == false && self.VJ_PlayingSequence == false && (!self.IsVJBaseSNPC_Tank) && self:GetEnemyLastKnownPos() != defPos then
			self:SetLastPosition(self:GetEnemyLastKnownPos())
			RunToEnemyOnReset = true
		end
		
		self:MarkEnemyAsEluded(self:GetEnemy())
		//self:ClearEnemyMemory(self:GetEnemy()) // Completely resets the enemy memory
		self:AddEntityRelationship(self:GetEnemy(), 4, 10)
	end
	
	self:SetEnemy(NULL)
	self:ClearEnemyMemory()
	//self:UpdateEnemyMemory(self,self:GetPos())
	local vsched = ai_vj_schedule.New("vj_act_resetenemy")
	if IsValid(self:GetEnemy()) then vsched:EngTask("TASK_FORGET", self:GetEnemy()) end
	//vsched:EngTask("TASK_IGNORE_OLD_ENEMIES", 0)
	self.NextWanderTime = CurTime() + math.Rand(3, 5)
	if !self:BusyWithActivity() && self.IsGuard == false && self.Behavior != VJ_BEHAVIOR_PASSIVE && self.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE && self.VJ_IsBeingControlled == false && RunToEnemyOnReset == true && self.LastHiddenZone_CanWander == true then
		//ParticleEffect("explosion_turret_break", self.LatestEnemyPosition, Angle(0,0,0))
		self:SetMovementActivity(VJ_PICK(self.AnimTbl_Walk))
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
	end
	if vsched.TaskCount > 0 then
		self:StartSchedule(vsched)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage(dmginfo)
	if self.GodMode == true or dmginfo:GetDamage() <= 0 then return 0 end
	local dmgInflictor = dmginfo:GetInflictor()
	local dmgAttacker = dmginfo:GetAttacker()
	local dmgType = dmginfo:GetDamageType()
	local hitgroup = self.VJ_ScaleHitGroupDamage
	if IsValid(dmgInflictor) && dmgInflictor:GetClass() == "prop_ragdoll" && dmgInflictor:GetVelocity():Length() <= 100 then return 0 end
	self:CustomOnTakeDamage_BeforeImmuneChecks(dmginfo, hitgroup)
	if self:IsOnFire() && self:WaterLevel() == 2 then self:Extinguish() end -- If we are in water, then extinguish the fire

	-- If it should always take damage from huge monsters, then skip immunity checks!
	if self.GetDamageFromIsHugeMonster == true && dmgAttacker.VJ_IsHugeMonster == true then
		goto skip_immunity
	end
	if VJ_HasValue(self.ImmuneDamagesTable, dmgType) then return 0 end
	if self.AllowIgnition == false && self:IsOnFire() && IsValid(dmgInflictor) && IsValid(dmgAttacker) && dmgInflictor:GetClass() == "entityflame" && dmgAttacker:GetClass() == "entityflame" then self:Extinguish() return 0 end
	if self.Immune_Fire == true && (dmgType == DMG_BURN or dmgType == DMG_SLOWBURN or (self:IsOnFire() && IsValid(dmgInflictor) && IsValid(dmgAttacker) && dmgInflictor:GetClass() == "entityflame" && dmgAttacker:GetClass() == "entityflame")) then return 0 end
	if (self.Immune_AcidPoisonRadiation == true && (dmgType == DMG_ACID or dmgType == DMG_RADIATION or dmgType == DMG_POISON or dmgType == DMG_NERVEGAS or dmgType == DMG_PARALYZE)) or (self.Immune_Bullet == true && (dmginfo:IsBulletDamage() or dmgType == DMG_AIRBOAT or dmgType == DMG_BUCKSHOT)) or (self.Immune_Blast == true && (dmgType == DMG_BLAST or dmgType == DMG_BLAST_SURFACE)) or (self.Immune_Dissolve == true && dmgType == DMG_DISSOLVE) or (self.Immune_Electricity == true && (dmgType == DMG_SHOCK or dmgType == DMG_ENERGYBEAM or dmgType == DMG_PHYSGUN)) or (self.Immune_Melee == true && (dmgType == DMG_CLUB or dmgType == DMG_SLASH)) or (self.Immune_Physics == true && dmgType == DMG_CRUSH) or (self.Immune_Sonic == true && dmgType == DMG_SONIC) then return 0 end
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
	self:CustomOnTakeDamage_AfterDamage(dmginfo, hitgroup)
	DoBleed()

	-- Make passive NPCs run and their allies as well
	if (self.Behavior == VJ_BEHAVIOR_PASSIVE or self.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE) && CurTime() > self.TakingCoverT then
		if self.Passive_RunOnDamage == true && self:Health() > 0 then -- Don't run if not allowed or dead
			self:VJ_TASK_COVER_FROM_ENEMY("TASK_RUN_PATH")
		end
		if self.Passive_AlliesRunOnDamage == true then -- Make passive allies run
			local allies = self:Allies_Check(self.Passive_AlliesRunOnDamageDistance)
			if allies != nil then
				for _,v in pairs(allies) do
					v.TakingCoverT = CurTime() + math.Rand(v.Passive_NextRunOnDamageTime.b, v.Passive_NextRunOnDamageTime.a)
					v:VJ_TASK_COVER_FROM_ENEMY("TASK_RUN_PATH")
					v:PlaySoundSystem("Alert")
				end
			end
		end
		self.TakingCoverT = CurTime() + math.Rand(self.Passive_NextRunOnDamageTime.a, self.Passive_NextRunOnDamageTime.b)
	end

	if self:Health() > 0 then
		self:DoFlinch(dmginfo, hitgroup)
		
		-- Damage by Player
			-- 0 = Run it every time | 1 = Run it only when friendly to player | 2 = Run it only when enemy to player
		if self.HasDamageByPlayer && dmgAttacker:IsPlayer() && CurTime() > self.NextDamageByPlayerT && GetConVar("ai_disabled"):GetInt() == 0 && self:Visible(dmgAttacker) && (self.DamageByPlayerDispositionLevel == 0 or (self.DamageByPlayerDispositionLevel == 1 && (self:Disposition(dmgAttacker) == D_LI or self:Disposition(dmgAttacker) == D_NU)) or (self.DamageByPlayerDispositionLevel == 2 && self:Disposition(dmgAttacker) != D_LI && self:Disposition(dmgAttacker) != D_NU)) then
			self:CustomOnDamageByPlayer(dmginfo, hitgroup)
			self:PlaySoundSystem("DamageByPlayer")
			self.NextDamageByPlayerT = CurTime() + math.Rand(self.DamageByPlayerTime.a, self.DamageByPlayerTime.b)
		end
		
		self:PlaySoundSystem("Pain")

		if self.CallForBackUpOnDamage == true && CurTime() > self.NextCallForBackUpOnDamageT && !IsValid(self:GetEnemy()) && self.FollowingPlayer == false && self.Behavior != VJ_BEHAVIOR_PASSIVE && self.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE && ((!IsValid(dmgInflictor)) or (IsValid(dmgInflictor) && dmgInflictor:GetClass() != "entityflame")) && IsValid(dmgAttacker) && dmgAttacker:GetClass() != "entityflame" then
			local allies = self:Allies_Check(self.CallForBackUpOnDamageDistance)
			if allies != nil then
				self:Allies_Bring("Random",self.CallForBackUpOnDamageDistance,allies,self.CallForBackUpOnDamageLimit)
				self:ClearSchedule()
				self.NextFlinchT = CurTime() + 1
				local pickanim = VJ_PICK(self.CallForBackUpOnDamageAnimation)
				if VJ_AnimationExists(self,pickanim) == true && self.DisableCallForBackUpOnDamageAnimation == false then
					self:VJ_ACT_PLAYACTIVITY(pickanim,true,self:DecideAnimationLength(pickanim,self.CallForBackUpOnDamageAnimationTime),true, 0, {PlayBackRateCalculated=true})
				elseif !self:BusyWithActivity() then
					self:VJ_TASK_COVER_FROM_ENEMY("TASK_RUN_PATH",function(x) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true end)
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
		
		/*if dmgInflictor:GetClass() == "crossbow_bolt" then
			print("test")
			local mdlBolt = ents.Create("prop_dynamic_override")
			mdlBolt:SetPos(dmginfo:GetDamagePosition())
			mdlBolt:SetAngles(dmgAttacker:GetAngles())
			mdlBolt:SetModel("models/crossbow_bolt.mdl")
			mdlBolt:SetParent(self)
			mdlBolt:Spawn()
			mdlBolt:Activate()
		end*/

		if self.BecomeEnemyToPlayer == true && self.VJ_IsBeingControlled == false && dmgAttacker:IsPlayer() && GetConVar("ai_disabled"):GetInt() == 0 && GetConVar("ai_ignoreplayers"):GetInt() == 0 && self:Disposition(dmgAttacker) == D_LI then
			self.AngerLevelTowardsPlayer = self.AngerLevelTowardsPlayer + 1
			if self.AngerLevelTowardsPlayer > self.BecomeEnemyToPlayerLevel then
				if self:Disposition(dmgAttacker) != D_HT then
					self:CustomWhenBecomingEnemyTowardsPlayer(dmginfo, hitgroup)
					if self.FollowingPlayer == true && self.FollowPlayer_Entity == dmgAttacker then self:FollowPlayerReset() end
					self.VJ_AddCertainEntityAsEnemy[#self.VJ_AddCertainEntityAsEnemy+1] = dmgAttacker
					self:AddEntityRelationship(dmgAttacker,D_HT,99)
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
			end
		end

		if self.DisableTakeDamageFindEnemy == false && self:BusyWithActivity() == false && !IsValid(self:GetEnemy()) && CurTime() > self.TakingCoverT && self.VJ_IsBeingControlled == false && self.Behavior != VJ_BEHAVIOR_PASSIVE && self.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE /*&& self.Alerted == false*/ && GetConVar("ai_disabled"):GetInt() == 0 then
			local sightdist = self.SightDistance / 2 -- Gesvadz tive
			-- Yete gesvadz tive hazaren aveli kich e, ere vor chi ges e tive...
			-- Yete tive 2000 - 4000 mechene, ere vor mishd 2000 ela...
			-- Yete 4000 aveli e, ere vor gesvadz tive kordzadz e
			if sightdist <= 1000 then
				sightdist = self.SightDistance
			else
				sightdist = math.Clamp(sightdist,2000,self.SightDistance)
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
						if self.FollowingPlayer == false && self.RunAwayOnUnknownDamage == true && self.MovementType != VJ_MOVETYPE_STATIONARY then
							self:VJ_TASK_COVER_FROM_ENEMY("TASK_RUN_PATH",function(x) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true end)
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
	if self.Medic_IsHealingAlly == true then self:DoMedicCode_Reset() end
	local dmgInflictor = dmginfo:GetInflictor()
	local dmgAttacker = dmginfo:GetAttacker()
	
	local allies = self:Allies_Check(math.max(800, self.BringFriendsOnDeathDistance, self.AlertFriendsOnDeathDistance))
	if allies != nil then
		local noAlert = true -- Don't run the AlertFriendsOnDeath if we have BringFriendsOnDeath enabled!
		if self.BringFriendsOnDeath == true then
			self:Allies_Bring("Random", self.BringFriendsOnDeathDistance, allies, self.BringFriendsOnDeathLimit, true)
			noAlert = false
		end
		local doBecomeEnemyToPlayer = (self.BecomeEnemyToPlayer == true && dmgAttacker:IsPlayer() && GetConVar("ai_disabled"):GetInt() == 0 && GetConVar("ai_ignoreplayers"):GetInt() == 0) or false
		local it = 0 -- Number of allies that have been alerted
		for _,v in pairs(allies) do
			v:CustomOnAllyDeath(self)
			v:PlaySoundSystem("AllyDeath")
			
			-- AlertFriendsOnDeath
			if noAlert == true && self.AlertFriendsOnDeath == true && !IsValid(v:GetEnemy()) && v.AlertFriendsOnDeath == true && it != self.AlertFriendsOnDeathLimit && self:GetPos():Distance(v:GetPos()) < self.AlertFriendsOnDeathDistance then
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
						if v.FollowingPlayer == true && v.FollowPlayer_Entity == dmgAttacker then v:FollowPlayerReset() end
						v.VJ_AddCertainEntityAsEnemy[#v.VJ_AddCertainEntityAsEnemy+1] = dmgAttacker
						v:AddEntityRelationship(dmgAttacker,D_HT,99)
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
	if self.FollowingPlayer == true then self:FollowPlayerReset() end
	self:RemoveAttackTimers()
	self.MeleeAttacking = false
	self.RangeAttacking = false
	self.LeapAttacking = false
	self.HasMeleeAttack = false
	self.HasRangeAttack = false
	self.HasLeapAttack = false
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
	if (self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC) then self:AA_StopMoving() end
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
	if bit.band(self.SavedDmgInfo.type, DMG_REMOVENORAGDOLL) == 0 then self:CreateDeathCorpse(dmginfo, hitgroup) end
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

		if self.Bleeds == true && self.HasBloodPool == true && GetConVar("vj_npc_nobloodpool"):GetInt() == 0 then
			self:SpawnBloodPool(dmginfo, hitgroup)
		end
		
		-- Collision --
		self.Corpse:SetCollisionGroup(self.DeathCorpseCollisionType)
		if GetConVar("ai_serverragdolls"):GetInt() == 1 then
			undo.ReplaceEntity(self, self.Corpse)
		else -- Keep corpses is not enabled...
			hook.Call("VJ_CreateSNPCCorpse", nil, self.Corpse, self)
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
		for boneLimit = 0, self.Corpse:GetPhysicsObjectCount() - 1 do -- 128 = Bone Limit
			local childphys = self.Corpse:GetPhysicsObjectNum(boneLimit)
			if IsValid(childphys) then
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
		for _,v in ipairs(self.ExtraCorpsesToRemove_Transition) do
			if v.IsVJBase_Gib == true && v.RemoveOnCorpseDelete == true then
				v:Remove()
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackSoundCode(CustomTbl, Type) self:PlaySoundSystem("RangeAttack", CustomTbl, Type) end -- !!!!!!!!!!!!!! DO NOT USE THIS FUNCTION !!!!!!!!!!!!!! [Backwards Compatibility!]
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
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(3,4)
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
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(3,4)
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
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(3,4)
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
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(3,4)
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
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(3,4)
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
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(3,4)
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
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(3,4)
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
				self.NextIdleSoundT = CurTime() + ((((SoundDuration(sdtbl) > 0) and SoundDuration(sdtbl)) or 2) + 1)
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
				timer.Simple(1.3,function() if IsValid(self) then VJ_STOPSOUND(self.CurrentAlertSound) end end)
				self.NextAlertSoundT = CurTime() + 1
				self.NextInvestigateSoundT = CurTime() + 2
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(2,3)
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
				VJ_STOPSOUND(self.CurrentIdleSound)
				self.NextIdleSoundT_RegularChange = CurTime() + 1
				self.CurrentPainSound = sdType(self, sdtbl, self.PainSoundLevel, self:VJ_DecideSoundPitch(self.PainSoundPitch1, self.PainSoundPitch2))
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
				self.NextIdleSoundT_RegularChange = CurTime() + 1
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
				self.CurrentDeathSound = sdType(self, sdtbl, self.DeathSoundLevel, self:VJ_DecideSoundPitch(self.DeathSoundPitch1, self.DeathSoundPitch2))
			end
		end
		return
	--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-- Base-Specific Sound Tables --=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
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
			if (math.random(1, self.MeleeAttackSoundChance) == 1 && sdtbl != false) or (cTbl != false) then
				if cTbl != false then sdtbl = cTbl end
				if self.IdleSounds_PlayOnAttacks == false then VJ_STOPSOUND(self.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
				self.NextIdleSoundT_RegularChange = CurTime() + 1
				self.CurrentMeleeAttackSound = sdType(self, sdtbl, self.MeleeAttackSoundLevel, self:VJ_DecideSoundPitch(self.MeleeAttackSoundPitch.a, self.MeleeAttackSoundPitch.b))
			end
			if self.HasExtraMeleeAttackSounds == true then
				sdtbl = VJ_PICK(self.SoundTbl_MeleeAttackExtra)
				if sdtbl == false then sdtbl = VJ_PICK(DefaultSoundTbl_MeleeAttackExtra) end -- Default table
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
			if (math.random(1, self.MeleeAttackMissSoundChance) == 1 && sdtbl != false) or (cTbl != false) then
				if cTbl != false then sdtbl = cTbl end
				if self.IdleSounds_PlayOnAttacks == false then VJ_STOPSOUND(self.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
				self.NextIdleSoundT_RegularChange = CurTime() + 1
				self.CurrentMeleeAttackMissSound = sdType(self, sdtbl, self.MeleeAttackMissSoundLevel, self:VJ_DecideSoundPitch(self.MeleeAttackMissSoundPitch.a, self.MeleeAttackMissSoundPitch.b))
			end
		end
		return
	elseif sdSet == "BeforeRangeAttack" then
		if self.HasBeforeRangeAttackSound == true then
			local sdtbl = VJ_PICK(self.SoundTbl_BeforeRangeAttack)
			if (math.random(1, self.BeforeRangeAttackSoundChance) == 1 && sdtbl != false) or (cTbl != false) then
				if cTbl != false then sdtbl = cTbl end
				if self.IdleSounds_PlayOnAttacks == false then VJ_STOPSOUND(self.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
				self.NextIdleSoundT_RegularChange = CurTime() + 1
				self.CurrentBeforeRangeAttackSound = sdType(self, sdtbl, self.BeforeRangeAttackSoundLevel, self:VJ_DecideSoundPitch(self.BeforeRangeAttackPitch.a, self.BeforeRangeAttackPitch.b))
			end
		end
		return
	elseif sdSet == "RangeAttack" then
		if self.HasRangeAttackSound == true then
			local sdtbl = VJ_PICK(self.SoundTbl_RangeAttack)
			if (math.random(1, self.RangeAttackSoundChance) == 1 && sdtbl != false) or (cTbl != false) then
				if cTbl != false then sdtbl = cTbl end
				if self.IdleSounds_PlayOnAttacks == false then VJ_STOPSOUND(self.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
				self.NextIdleSoundT_RegularChange = CurTime() + 1
				self.CurrentRangeAttackSound = sdType(self, sdtbl, self.RangeAttackSoundLevel, self:VJ_DecideSoundPitch(self.RangeAttackPitch1, self.RangeAttackPitch2))
			end
		end
		return
	elseif sdSet == "BeforeLeapAttack" then
		if self.HasBeforeLeapAttackSound == true then
			local sdtbl = VJ_PICK(self.SoundTbl_BeforeLeapAttack)
			if (math.random(1, self.BeforeLeapAttackSoundChance) == 1 && sdtbl != false) or (cTbl != false) then
				if cTbl != false then sdtbl = cTbl end
				if self.IdleSounds_PlayOnAttacks == false then VJ_STOPSOUND(self.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
				self.NextIdleSoundT_RegularChange = CurTime() + 1
				self.CurrentBeforeLeapAttackSound = sdType(self, sdtbl, self.BeforeLeapAttackSoundLevel, self:VJ_DecideSoundPitch(self.BeforeLeapAttackSoundPitch.a, self.BeforeLeapAttackSoundPitch.b))
			end
		end
		return
	elseif sdSet == "LeapAttackJump" then
		if self.HasLeapAttackJumpSound == true then
			local sdtbl = VJ_PICK(self.SoundTbl_LeapAttackJump)
			if (math.random(1, self.LeapAttackJumpSoundChance) == 1 && sdtbl != false) or (cTbl != false) then
				if cTbl != false then sdtbl = cTbl end
				if self.IdleSounds_PlayOnAttacks == false then VJ_STOPSOUND(self.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
				self.NextIdleSoundT_RegularChange = CurTime() + 1
				self.CurrentLeapAttackJumpSound = sdType(self, sdtbl, self.LeapAttackJumpSoundLevel, self:VJ_DecideSoundPitch(self.LeapAttackJumpSoundPitch.a, self.LeapAttackJumpSoundPitch.b))
			end
		end
		return
	elseif sdSet == "LeapAttackDamage" then
		if self.HasLeapAttackDamageSound == true then
			local sdtbl = VJ_PICK(self.SoundTbl_LeapAttackDamage)
			if (math.random(1, self.LeapAttackDamageSoundChance) == 1 && sdtbl != false) or (cTbl != false) then
				if cTbl != false then sdtbl = cTbl end
				if self.IdleSounds_PlayOnAttacks == false then VJ_STOPSOUND(self.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
				self.NextIdleSoundT_RegularChange = CurTime() + 1
				self.CurrentLeapAttackDamageSound = sdType(self, sdtbl, self.LeapAttackDamageSoundLevel, self:VJ_DecideSoundPitch(self.LeapAttackDamageSoundPitch.a, self.LeapAttackDamageSoundPitch.b))
			end
		end
		return
	elseif sdSet == "LeapAttackDamageMiss" then
		if self.HasLeapAttackDamageMissSound == true then
			local sdtbl = VJ_PICK(self.SoundTbl_LeapAttackDamageMiss)
			if (math.random(1, self.LeapAttackDamageMissSoundChance) == 1 && sdtbl != false) or (cTbl != false) then
				if cTbl != false then sdtbl = cTbl end
				if self.IdleSounds_PlayOnAttacks == false then VJ_STOPSOUND(self.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
				self.NextIdleSoundT_RegularChange = CurTime() + 1
				self.CurrentLeapAttackDamageMissSound = sdType(self, sdtbl, self.LeapAttackDamageMissSoundLevel, self:VJ_DecideSoundPitch(self.LeapAttackDamageMissSoundPitch.a, self.LeapAttackDamageMissSoundPitch.b))
			end
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
			if VJ_PICK(soundtbl) != false then
				VJ_EmitSound(self,soundtbl,self.FootStepSoundLevel,self:VJ_DecideSoundPitch(self.FootStepPitch.a,self.FootStepPitch.b))
			end
			if self.HasWorldShakeOnMove == true then util.ScreenShake(self:GetPos(), self.WorldShakeOnMoveAmplitude, self.WorldShakeOnMoveFrequency, self.WorldShakeOnMoveDuration, self.WorldShakeOnMoveRadius) end
			return
		elseif self:IsMoving() && CurTime() > self.FootStepT && self:GetInternalVariable("m_flMoveWaitFinished") <= 0 then
			self:CustomOnFootStepSound()
			local soundtbl = self.SoundTbl_FootStep
			if CustomTbl != nil && #CustomTbl != 0 then soundtbl = CustomTbl end
			if VJ_PICK(soundtbl) != false then
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
	VJ_STOPSOUND(self.CurrentAlertSound)
	VJ_STOPSOUND(self.CurrentBeforeMeleeAttackSound)
	VJ_STOPSOUND(self.CurrentMeleeAttackSound)
	VJ_STOPSOUND(self.CurrentExtraMeleeAttackSound)
	//VJ_STOPSOUND(self.CurrentMeleeAttackMissSound)
	VJ_STOPSOUND(self.CurrentBeforeRangeAttackSound)
	VJ_STOPSOUND(self.CurrentRangeAttackSound)
	VJ_STOPSOUND(self.CurrentBeforeLeapAttackSound)
	VJ_STOPSOUND(self.CurrentLeapAttackJumpSound)
	VJ_STOPSOUND(self.CurrentLeapAttackDamageSound)
	VJ_STOPSOUND(self.CurrentPainSound)
	VJ_STOPSOUND(self.CurrentFollowPlayerSound)
	VJ_STOPSOUND(self.CurrentUnFollowPlayerSound)
	VJ_STOPSOUND(self.CurrentMoveOutOfPlayersWaySound)
	VJ_STOPSOUND(self.CurrentBecomeEnemyToPlayerSound)
	VJ_STOPSOUND(self.CurrentOnPlayerSightSound)
	VJ_STOPSOUND(self.CurrentDamageByPlayerSound)
	VJ_STOPSOUND(self.CurrentMedicBeforeHealSound)
	VJ_STOPSOUND(self.CurrentMedicAfterHealSound)
	VJ_STOPSOUND(self.CurrentMedicReceiveHealSound)
	VJ_STOPSOUND(self.CurrentCallForHelpSound)
	VJ_STOPSOUND(self.CurrentOnReceiveOrderSound)
	VJ_STOPSOUND(self.CurrentOnKilledEnemySound)
	VJ_STOPSOUND(self.CurrentAllyDeathSound)
end