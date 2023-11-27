AddCSLuaFile("shared.lua")
include("vj_base/ai/core.lua")
include("vj_base/ai/schedules.lua")
include("vj_base/ai/move_aa.lua")
include("shared.lua")
/*--------------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
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
ENT.HealthRegenerationDelay = VJ.SET(2, 4) -- How much time until the health increases
ENT.HealthRegenerationResetOnDmg = true -- Should the delay reset when it receives damage?
	-- ====== Collision / Hitbox Variables ====== --
ENT.HullType = HULL_HUMAN -- List of Hull types: https://wiki.facepunch.com/gmod/Enums/HULL
ENT.HullSizeNormal = true -- set to false to cancel out the self:SetHullSizeNormal()
ENT.HasSetSolid = true -- set to false to disable SetSolid
	-- ====== Sight & Speed Variables ====== --
ENT.SightDistance = 10000 -- How far it can see | This is just a starting value! | To retrieve: "self:GetMaxLookDistance()" | To change: "self:SetMaxLookDistance(sight)"
ENT.SightAngle = 80 -- The sight angle | Example: 180 would make the it see all around it | Measured in degrees and then converted to radians
ENT.TurningSpeed = 20 -- How fast it can turn
ENT.TurningUseAllAxis = false -- If set to true, angles will not be restricted to y-axis, it will change all axes (plural axis)
ENT.CanTurnWhileMoving = true -- Can the NPC turn while moving? | EX: GoldSrc NPCs, Facing enemy while running to cover, Facing the player while moving out of the way
ENT.AnimationPlaybackRate = 1 -- Controls the playback rate of all animations
	-- ====== Movement Variables ====== --
	-- Types: VJ_MOVETYPE_GROUND | VJ_MOVETYPE_AERIAL | VJ_MOVETYPE_AQUATIC | VJ_MOVETYPE_STATIONARY | VJ_MOVETYPE_PHYSICS
ENT.MovementType = VJ_MOVETYPE_GROUND -- How does the SNPC move?
ENT.UsePlayerModelMovement = false -- If true, it will allow the NPC to use player models properly by calculating the direction it needs to go to and setting the appropriate values
	-- Movement: JUMP --
	-- NOTE: Requires "CAP_MOVE_JUMP" capability
	-- Applied automatically by the base if "ACT_JUMP" is valid on the NPC's model
ENT.AllowMovementJumping = true -- Should the NPC be allowed to jump from one node to another?
-- Example scenario:
--      [A]       <- Apex
--     /   \
--    /     [S]   <- Start
--  [E]           <- End
ENT.JumpVars = {
	MaxRise = 220, -- How high it can jump up ((S -> A) AND (S -> E))
	MaxDrop = 384, -- How low it can jump down (E -> S)
	MaxDistance = 512, -- Maximum distance between Start and End
}
	-- Movement: STATIONARY --
ENT.CanTurnWhileStationary = true -- Can the NPC turn while it's stationary?
	-- Movement: AERIAL --
ENT.Aerial_FlyingSpeed_Calm = 80 -- The speed it should fly with, when it's wandering, moving slowly, etc. | Basically walking compared to ground SNPCs
ENT.Aerial_FlyingSpeed_Alerted = 200 -- The speed it should fly with, when it's chasing an enemy, moving away quickly, etc. | Basically running compared to ground SNPCs
ENT.Aerial_AnimTbl_Calm = {} -- Animations it plays when it's wandering around while idle
ENT.Aerial_AnimTbl_Alerted = {} -- Animations it plays when it's moving while alerted
	-- Movement: AQUATIC --
ENT.Aquatic_SwimmingSpeed_Calm = 80 -- The speed it should swim with, when it's wandering, moving slowly, etc. | Basically walking compared to ground SNPCs
ENT.Aquatic_SwimmingSpeed_Alerted = 200 -- The speed it should swim with, when it's chasing an enemy, moving away quickly, etc. | Basically running compared to ground SNPCs
ENT.Aquatic_AnimTbl_Calm = {} -- Animations it plays when it's wandering around while idle
ENT.Aquatic_AnimTbl_Alerted = {} -- Animations it plays when it's moving while alerted
	-- Movement: AERIAL & AQUATIC --
ENT.AA_GroundLimit = 100 -- If the NPC's distance from itself to the ground is less than this, it will attempt to move up
ENT.AA_MinWanderDist = 150 -- Minimum distance that the NPC should go to when wandering
ENT.AA_MoveAccelerate = 5 -- The NPC will gradually speed up to the max movement speed as it moves towards its destination | Calculation = FrameTime * x
	-- 0 = Constant max speed | 1 = Increase very slowly | 50 = Increase very quickly
ENT.AA_MoveDecelerate = 5 -- The NPC will slow down as it approaches its destination | Calculation = MaxSpeed / x
	-- 1 = Constant max speed | 2 = Slow down slightly | 5 = Slow down normally | 50 = Slow down extremely slow
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
	-- ====== Miscellaneous Variables ====== --
ENT.HasEntitiesToNoCollide = true -- If set to false, it won't run the EntitiesToNoCollide code
ENT.EntitiesToNoCollide = {} -- Entities to not collide with when HasEntitiesToNoCollide is set to true
ENT.AllowPrintingInChat = true -- Should this SNPC be allowed to post in player's chat? Example: "Blank no longer likes you."
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ AI & Relationship Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.CanOpenDoors = true -- Can it open doors?
ENT.HasAllies = true -- Put to false if you want it not to have any allies
ENT.VJ_NPC_Class = {} -- NPCs with the same class with be allied to each other
	-- Common Classes: Combine = CLASS_COMBINE || Zombie = CLASS_ZOMBIE || Antlions = CLASS_ANTLION || Xen = CLASS_XEN || Player Friendly = CLASS_PLAYER_ALLY
ENT.FriendsWithAllPlayerAllies = false -- Should this NPC be friends with other player allies?
ENT.Behavior = VJ_BEHAVIOR_AGGRESSIVE -- The behavior of the SNPC
	-- VJ_BEHAVIOR_AGGRESSIVE = Default behavior, attacks enemies || VJ_BEHAVIOR_NEUTRAL = Neutral to everything, unless provoked
	-- VJ_BEHAVIOR_PASSIVE = Doesn't attack, but can be attacked by others || VJ_BEHAVIOR_PASSIVE_NATURE = Doesn't attack and is allied with everyone
ENT.IsGuard = false -- If set to false, it will attempt to stick to its current position at all times
ENT.AlertedToIdleTime = VJ.SET(4, 6) -- How much time until it calms down after the enemy has been killed/disappeared | Sets self.Alerted to false after the timer expires
ENT.MoveOutOfFriendlyPlayersWay = true -- Should the SNPC move out of the way when a friendly player comes close to it?
ENT.BecomeEnemyToPlayer = false -- Should the friendly SNPC become enemy towards the player if it's damaged by it or it witnesses another ally killed by it
ENT.BecomeEnemyToPlayerLevel = 2 -- Any time the player does something bad, the NPC's anger level raises by 1, if it surpasses this, it will become enemy!
	-- ====== Old Variables (Can still be used, but it's recommended not to use them) ====== --
ENT.PlayerFriendly = false -- Makes the SNPC friendly to the player and HL2 Resistance
	-- ====== Passive Behavior Variables ====== --
ENT.Passive_RunOnTouch = true -- Should it run away and make a alert sound when something collides with it?
ENT.Passive_NextRunOnTouchTime = VJ.SET(3, 4) -- How much until it can run away again when something collides with it?
ENT.Passive_RunOnDamage = true -- Should it run when it's damaged? | This doesn't impact how self.Passive_AlliesRunOnDamage works
ENT.Passive_AlliesRunOnDamage = true -- Should its allies (other passive SNPCs) also run when it's damaged?
ENT.Passive_AlliesRunOnDamageDistance = 800 -- Any allies within this distance will run when it's damaged
ENT.Passive_NextRunOnDamageTime = VJ.SET(6, 7) -- How much until it can run the code again?
	-- ====== On Player Sight Variables ====== --
ENT.HasOnPlayerSight = false -- Should do something when it sees the enemy? Example: Play a sound
ENT.OnPlayerSightDistance = 200 -- How close should the player be until it runs the code?
ENT.OnPlayerSightDispositionLevel = 1 -- 0 = Run it every time | 1 = Run it only when friendly to player | 2 = Run it only when enemy to player
ENT.OnPlayerSightOnlyOnce = true -- If true, it will only run the code once | Sets self.HasOnPlayerSight to false once it runs!
ENT.OnPlayerSightNextTime = VJ.SET(15, 20) -- How much time should it pass until it runs the code again?
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
	-- To let the base automatically detect the animation duration, set this to false:
ENT.Medic_TimeUntilHeal = false -- Time until the ally receives health
ENT.Medic_CheckDistance = 600 -- How far does it check for allies that are hurt? | World units
ENT.Medic_HealDistance = 30 -- How close does it have to be until it stops moving and heals its ally?
ENT.Medic_HealthAmount = 25 -- How health does it give?
ENT.Medic_NextHealTime = VJ.SET(10, 15) -- How much time until it can give health to an ally again
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
	-- ====== Eating Variables ====== --
ENT.CanEat = false -- Should it search and eat organic stuff when idle?
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
ENT.DisableTakeDamageFindEnemy = false -- Disable the SNPC finding the enemy when being damaged
ENT.DisableTouchFindEnemy = false -- Disable the SNPC finding the enemy when being touched
ENT.DisableMakingSelfEnemyToNPCs = false -- Disables the "AddEntityRelationship" that runs in think
ENT.TimeUntilEnemyLost = 15 -- Time until it resets its enemy if the enemy is not visible
ENT.NextProcessTime = 1 -- Time until it runs the essential part of the AI, which can be performance heavy!
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Damaged / Injured Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- ====== Blood-Related Variables ====== --
	-- Leave custom blood tables empty to let the base decide depending on the blood type
ENT.Bleeds = true -- Does the SNPC bleed? (Blood decal, particle, etc.)
ENT.BloodColor = "" -- The blood type, this will determine what it should use (decal, particle, etc.)
	-- Types: "Red" || "Yellow" || "Green" || "Orange" || "Blue" || "Purple" || "White" || "Oil"
ENT.HasBloodParticle = true -- Does it spawn a particle when damaged?
ENT.CustomBlood_Particle = {} -- Particles to spawn when it's damaged | Leave empty for the base to decide
ENT.HasBloodPool = true -- Does it have a blood pool?
ENT.CustomBlood_Pool = {} -- Blood pool types after it dies | Leave empty for the base to decide
ENT.HasBloodDecal = true -- Does it spawn a decal when damaged?
ENT.CustomBlood_Decal = {} -- Decals to spawn when it's damaged | Leave empty for the base to decide
ENT.BloodDecalUseGMod = false -- Should use the current default decals defined by Garry's Mod? (This only applies for certain blood types only!)
ENT.BloodDecalDistance = 150 -- Max distance blood decals can splatter
	-- ====== Immunity Variables ====== --
ENT.GodMode = false -- Immune to everything
ENT.Immune_AcidPoisonRadiation = false -- Immune to Acid, Poison and Radiation
ENT.Immune_Bullet = false -- Immune to bullet type damages
ENT.Immune_Blast = false -- Immune to explosive-type damages
ENT.Immune_Dissolve = false -- Immune to dissolving | Example: Combine Ball
ENT.Immune_Electricity = false -- Immune to electrical-type damages | Example: shock or laser
ENT.Immune_Fire = false -- Immune to fire-type damages
ENT.Immune_Melee = false -- Immune to melee-type damage | Example: Crowbar, slash damages
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
	-- ====== Call For Back On Damage Variables ====== --
	-- NOTE: This AI component only runs when there is NO enemy detected!
ENT.CallForBackUpOnDamage = true -- Should the NPC call for help when damaged?
ENT.CallForBackUpOnDamageDistance = 800 -- How far away does the call for help go?
ENT.CallForBackUpOnDamageLimit = 4 -- How many allies should it call? | 0 = Unlimited
ENT.NextCallForBackUpOnDamageTime = VJ.SET(9, 11) -- How much time until it can run this AI component again
ENT.CallForBackUpOnDamageAnimation = {} -- Animations played when it calls for help on damage
ENT.CallForBackUpOnDamageAnimationTime = false -- How much time until it can use activities | false = Base automatically decides the animation duration
ENT.DisableCallForBackUpOnDamageAnimation = false -- Disables the animations from playing
	-- ====== Miscellaneous Variables ====== --
ENT.HideOnUnknownDamage = 5 -- number = Hide on unknown damage, defines the time until it can hide again | false = Disable this AI component
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Death & Corpse Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- ====== Ally Reaction On Death Variables ====== --
	-- Default: Creature base uses "BringFriends" and Human base uses "AlertFriends"
	-- "BringFriendsOnDeath" takes priority over "AlertFriendsOnDeath"!
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
ENT.DeathCorpseBodyGroup = VJ.SET(-1, -1) -- #1 = the category of the first bodygroup | #2 = the value of the second bodygroup | Set -1 for #1 to let the base decide the corpse's bodygroup
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
ENT.HasMeleeAttackKnockBack = false -- Should knockback be applied on melee hit? | Use self:MeleeAttackKnockbackVelocity() to edit the velocity
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
	-- Set this to false to make the attack event-based:
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
	-- ====== Digital Signal Processor (DSP) Variables ====== --
	-- Applies a DSP (Digital Signal Processor) to the player(s) that got hit
	-- DSP Presents: https://developer.valvesoftware.com/wiki/Dsp_presets
ENT.MeleeAttackDSPSoundType = 32 -- DSP type | false = Disables the system completely
ENT.MeleeAttackDSPSoundUseDamage = true -- true = Only apply the DSP effect past certain damage| false = Always apply the DSP effect!
ENT.MeleeAttackDSPSoundUseDamageAmount = 60 -- Any damage that is greater than or equal to this number will cause the DSP effect to apply
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Range Attack Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasRangeAttack = false -- Should the SNPC have a range attack?
ENT.RangeAttackEntityToSpawn = "obj_vj_tank_shell" -- Entities that it can spawn when range attacking | If set as a table, it picks a random entity
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
	-- Set this to false to make the attack event-based:
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
	-- Set this to false to make the attack event-based:
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
ENT.DisableDefaultLeapAttackDamageCode = false -- Disables the default leap attack damage code
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
ENT.DamageByPlayerDispositionLevel = 1 -- At which disposition levels it should play the damage by player sounds | 0 = Always | 1 = ONLY when friendly to player | 2 = ONLY when enemy to player
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
-- Default sound file paths for certain sound tables | Base will play these if the corresponding table is left empty
local DefaultSoundTbl_MedicAfterHeal = {"items/smallmedkit1.wav"}
local DefaultSoundTbl_MeleeAttackExtra = {"npc/zombie/claw_strike1.wav", "npc/zombie/claw_strike2.wav", "npc/zombie/claw_strike3.wav"}
local DefaultSoundTbl_Impact = {"vj_flesh/alien_flesh1.wav"}
------ ///// WARNING: Don't change anything in this box! \\\\\ ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- ====== Fade Out Time Variables ====== --
	-- Put to 0 if you want it to stop instantly
ENT.MeleeAttackSlowPlayerSoundFadeOutTime = 1
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
ENT.NextSoundTime_Breath = false -- false = Base will decide the time
ENT.NextSoundTime_Idle = VJ.SET(4, 11)
ENT.NextSoundTime_Investigate = VJ.SET(5, 5)
ENT.NextSoundTime_LostEnemy = VJ.SET(5, 6)
ENT.NextSoundTime_Alert = VJ.SET(2, 3)
ENT.NextSoundTime_OnKilledEnemy = VJ.SET(3, 5)
ENT.NextSoundTime_AllyDeath = VJ.SET(3, 5)
ENT.NextSoundTime_Pain = false -- false = Base will decide the time
ENT.NextSoundTime_DamageByPlayer = VJ.SET(2, 2.3)
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
	-- ====== Sound Pitch Variables ====== --
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
ENT.FollowPlayerPitch = VJ.SET(false, false)
ENT.UnFollowPlayerPitch = VJ.SET(false, false)
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
ENT.MeleeAttackSoundPitch = VJ.SET(false, false)
ENT.ExtraMeleeSoundPitch = VJ.SET(80, 100)
ENT.MeleeAttackMissSoundPitch = VJ.SET(90, 100)
ENT.BeforeRangeAttackPitch = VJ.SET(false, false)
ENT.RangeAttackPitch = VJ.SET(false, false)
ENT.BeforeLeapAttackSoundPitch = VJ.SET(false, false)
ENT.LeapAttackJumpSoundPitch = VJ.SET(false, false)
ENT.LeapAttackDamageSoundPitch = VJ.SET(false, false)
ENT.LeapAttackDamageMissSoundPitch = VJ.SET(false, false)
ENT.OnKilledEnemySoundPitch = VJ.SET(false, false)
ENT.AllyDeathSoundPitch = VJ.SET(false, false)
ENT.PainSoundPitch = VJ.SET(false, false)
ENT.ImpactSoundPitch = VJ.SET(80, 100)
ENT.DamageByPlayerPitch = VJ.SET(false, false)
ENT.DeathSoundPitch = VJ.SET(false, false)
	-- ====== Playback Rate Variables ====== --
	-- Decides how fast the sound should play
	-- Examples: 1 = normal, 2 = twice the normal speed, 0.5 = half the normal speed
ENT.SoundTrackPlaybackRate = 1
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Customization Functions ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Use the functions below to customize parts of the base or to add new custom systems
-- Some functions don't have a custom function because you can simply override the base function and call "self.BaseClass.FuncName(self)" to run the base code as well
-- 
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPreInitialize() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	-- Collision bounds of the NPC | NOTE: All 4 Xs and Ys should be the same! | To view: "cl_ent_bbox"
	-- self:SetCollisionBounds(Vector(50, 50, 100), Vector(-50, -50, 0))
	
	-- Damage bounds of the NPC | NOTE: All 4 Xs and Ys should be the same! | To view: "cl_ent_absbox"
	--self:SetSurroundingBounds(Vector(-150, -150, 0), Vector(150, 150, 200))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled() end
---------------------------------------------------------------------------------------------------------------------------------------------
-- UNCOMMENT TO USE | Called at the end of every entity it checks every process time
-- function ENT:CustomOnMaintainRelationships(ent, entFri, entDist) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOn_PoseParameterLookingCode(pitch, yaw, roll) end
---------------------------------------------------------------------------------------------------------------------------------------------
-- UNCOMMENT TO USE | Called from the engine
-- function ENT:ExpressionFinished(strExp) end
---------------------------------------------------------------------------------------------------------------------------------------------
-- UNCOMMENT TO USE | Called whenever VJ.CreateSound or VJ.EmitSound is called | return a new file path to replace the one that is about to play
-- function ENT:OnPlaySound(sdFile) return "example/sound.wav" end
---------------------------------------------------------------------------------------------------------------------------------------------
-- UNCOMMENT TO USE | Called whenever a sound starts playing through VJ.CreateSound
-- function ENT:OnPlayCreateSound(sdData, sdFile) end
---------------------------------------------------------------------------------------------------------------------------------------------
-- UNCOMMENT TO USE | Called whenever a sound starts playing through VJ.EmitSound
-- function ENT:OnPlayEmitSound(sdFile) end
---------------------------------------------------------------------------------------------------------------------------------------------
-- UNCOMMENT TO USE | Called every time "self:FireBullets" is called
-- function ENT:OnFireBullet(data) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTouch(ent) end
---------------------------------------------------------------------------------------------------------------------------------------------
-- UNCOMMENT TO USE | Called from the engine
-- function ENT:OnCondition(cond) print(self, " Condition: ", cond, " - ", self:ConditionName(cond)) end
---------------------------------------------------------------------------------------------------------------------------------------------
-- UNCOMMENT TO USE
-- function ENT:CustomOnAcceptInput(key, activator, caller, data) end
---------------------------------------------------------------------------------------------------------------------------------------------
-- UNCOMMENT TO USE
-- function ENT:CustomOnHandleAnimEvent(ev, evTime, evCycle, evType, evOptions) end
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
			- "CheckEnt"	= Possible friendly entity found, should we speak to it? | return anything other than nil or "false" to skip and not speak to this entity!
			- "Speak"		= Everything passed, start speaking
			- "Answer"		= Another entity has spoken to me, answer back! | return anything other than nil or "false" to not play an answer back dialogue!
		- statusInfo = Some status may have extra info, possible infos:
			- For "CheckEnt"	= Boolean value, whether or not the entity can answer back
			- For "Speak"		= Duration of our sentence
	Returns
		- ONLY used for "CheckEnt" & "Answer" | Check above for what each status return does
-----------------------------------------------------------]]
function ENT:CustomOnIdleDialogue(ent, status, statusInfo) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMedic_BeforeHeal() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMedic_OnHeal(ent) return true end -- Return false to NOT update its ally's health and NOT clear its decals, allowing to custom code it
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMedic_OnReset() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPlayerSight(ent) end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	UNCOMMENT TO USE | Called every time footstep sound plays
		- moveType = Type of movement | Types: "Walk", "Run", "Event"
		- sdFile = Sound that it just played
-----------------------------------------------------------]]
-- function ENT:CustomOnFootStepSound(moveType, sdFile) end
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
-- UNCOMMENT TO USE | Use this to create a completely new attack system!
-- function ENT:CustomAttack(ene, eneVisible) end
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
function ENT:RangeAttackCode_GetShootPos(projectile) local projPos = projectile:GetPos() return self:CalculateProjectile("Line", projPos, self:GetAimPosition(self:GetEnemy(), projPos, 0.5, 1500), 1500) end
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
function ENT:CustomOnBecomeEnemyToPlayer(dmginfo, hitgroup) end
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
function ENT:Controller_Initialize(ply, controlEnt)
	//ply:ChatPrint("CTRL + MOUSE2: Rocket Attack") -- Example key binding message
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
ENT.VJ_IsBeingControlled = false
ENT.VJ_DEBUG = false
ENT.MeleeAttack_DoingPropAttack = false
ENT.Medic_Status = false -- false = Not active | "Active" = Attempting to heal ally (Going after etc.) | "Healing" = Has reached ally and is healing it
ENT.IsAbleToMeleeAttack = true
ENT.IsAbleToRangeAttack = true
ENT.IsAbleToLeapAttack = true
ENT.HasBeenGibbedOnDeath = false
ENT.DeathAnimationCodeRan = false
ENT.VJ_IsBeingControlled_Tool = false
ENT.LastHiddenZone_CanWander = true
ENT.LeapAttackHasJumped = false
ENT.PropAP_IsVisible = false
ENT.VJ_TheController = NULL
ENT.VJ_TheControllerEntity = NULL
ENT.VJ_TheControllerBullseye = NULL
ENT.Medic_CurrentEntToHeal = NULL
ENT.Medic_SpawnedProp = NULL
ENT.LastPlayedVJSound = nil
ENT.NextFollowUpdateT = 0
ENT.AngerLevelTowardsPlayer = 0
ENT.NextBreathSoundT = 0
ENT.FootStepT = 0
ENT.PainSoundT = 0
ENT.AllyDeathSoundT = 0
ENT.NextIdleSoundT = 0
ENT.NextProcessT = 0
ENT.NextPropAPCheckT = 0
ENT.NextCallForHelpT = 0
ENT.NextCallForBackUpOnDamageT = 0
ENT.NextAlertSoundT = 0
ENT.NextCallForHelpAnimationT = 0
ENT.CurrentAttackAnimation = ACT_INVALID
ENT.CurrentAttackAnimationDuration = 0
ENT.CurrentAttackAnimationTime = 0
ENT.NextIdleTime = 0
ENT.NextChaseTime = 0
ENT.OnPlayerSightNextT = 0
ENT.NextDamageByPlayerSoundT = 0
ENT.Medic_NextHealT = 0
ENT.CurrentIdleAnimation = 0
ENT.NextFlinchT = 0
ENT.NextCanGetCombineBallDamageT = 0
ENT.UseTheSameGeneralSoundPitch_PickedNumber = 0
ENT.OnKilledEnemySoundT = 0
ENT.LastHiddenZoneT = 0
ENT.NextIdleStandTime = 0
ENT.NextWanderTime = 0
ENT.TakingCoverT = 0
ENT.NextInvestigationMove = 0
ENT.NextInvestigateSoundT = 0
ENT.NextCallForHelpSoundT = 0
ENT.LostEnemySoundT = 0
ENT.NextDoAnyAttackT = 0
ENT.NearestPointToEnemyDistance = 0
ENT.LatestEnemyDistance = 0
ENT.HealthRegenerationDelayT = 0
ENT.CurAttackSeed = 0
ENT.CurAnimationSeed = 0
ENT.GuardingPosition = nil
ENT.GuardingFacePosition = nil
ENT.SelectedDifficulty = 1
ENT.AIState = VJ_STATE_NONE
ENT.AttackType = VJ.ATTACK_TYPE_NONE
ENT.AttackState = VJ.ATTACK_STATE_NONE
ENT.TimersToRemove = {"timer_state_reset","timer_turning","timer_act_flinching","timer_act_stopattacks","timer_melee_finished","timer_melee_start","timer_melee_finished_abletomelee","timer_range_start","timer_range_finished","timer_range_finished_abletorange","timer_leap_start_jump","timer_leap_start","timer_leap_finished","timer_leap_finished_abletoleap","timer_alerted_reset"}
ENT.TurnData = {Type = VJ.NPC_FACE_NONE, Target = nil, StopOnFace = false, IsSchedule = false, LastYaw = 0}
ENT.FollowData = {Ent = NULL, MinDist = 0, Moving = false, StopAct = false, IsLiving = false}
ENT.EnemyData = {
	TimeSet = 0, -- Last time an enemy was set | Updated whenever "VJ_DoSetEnemy" is ran successfully
	TimeSinceAcquired = 0, -- Time since it acquired an enemy (Switching enemies does NOT reset this!)
	IsVisible = false, -- Is the enemy visible? | Updated every "Think" run!
	LastVisibleTime = 0, -- Last time it saw the enemy
	LastVisiblePos = Vector(0, 0, 0), -- Last visible position of the enemy, based on "EyePos", for origin call "self:GetEnemyLastSeenPos()"
	LastVisiblePosReal = Vector(0, 0, 0), -- Last calculated visible position of the enemy, it's often wrong! | WARNING: Avoid using this, it's mostly used internally by the base!
	VisibleCount = 0, -- Number of visible enemies
	SightDiff = 0, -- Difference between enemy's position and NPC's sight direction | Examples: Determine if the enemy is within the NPC's sight angle or melee attack radius
	Reset = true, -- Enemy has reset | Mostly a backend variable
}
ENT.EatingData = nil
//ENT.DefaultGibOnDeathDamageTypes = {[DMG_ALWAYSGIB]=true,[DMG_ENERGYBEAM]=true,[DMG_BLAST]=true,[DMG_VEHICLE]=true,[DMG_CRUSH]=true,[DMG_DISSOLVE]=true,[DMG_SLOWBURN]=true,[DMG_PHYSGUN]=true,[DMG_PLASMA]=true,[DMG_SONIC]=true}
//ENT.SavedDmgInfo = {} -- Set later

-- Localized static values
local destructibleEnts = {func_breakable=true, func_physbox=true, prop_door_rotating=true} // func_breakable_surf

local defPos = Vector(0, 0, 0)

local IsProp = VJ.IsProp
local StopSound = VJ.STOPSOUND
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
local string_find = string.find
local string_sub = string.sub
local table_remove = table.remove
local table_concat = table.concat

---------------------------------------------------------------------------------------------------------------------------------------------
local function ConvarsOnInit(self)
	--<>-- Convars that run on Initialize --<>--
	if GetConVar("vj_npc_usedevcommands"):GetInt() == 1 then self.VJ_DEBUG = true end
	self.NextProcessTime = GetConVar("vj_npc_processtime"):GetInt()
	if GetConVar("vj_npc_sd_nosounds"):GetInt() == 1 then self.HasSounds = false end
	if GetConVar("vj_npc_vjfriendly"):GetInt() == 1 then self.VJTag_IsBaseFriendly = true end
	if GetConVar("vj_npc_playerfriendly"):GetInt() == 1 then self.PlayerFriendly = true end
	if GetConVar("vj_npc_antlionfriendly"):GetInt() == 1 then self.VJ_NPC_Class[#self.VJ_NPC_Class + 1] = "CLASS_ANTLION" end
	if GetConVar("vj_npc_combinefriendly"):GetInt() == 1 then self.VJ_NPC_Class[#self.VJ_NPC_Class + 1] = "CLASS_COMBINE" end
	if GetConVar("vj_npc_zombiefriendly"):GetInt() == 1 then self.VJ_NPC_Class[#self.VJ_NPC_Class + 1] = "CLASS_ZOMBIE" end
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
	if GetConVar("vj_npc_nocallhelp"):GetInt() == 1 then self.CallForHelp = false end
	if GetConVar("vj_npc_noeating"):GetInt() == 1 then self.CanEat = false end
	if GetConVar("vj_npc_nofollowplayer"):GetInt() == 1 then self.FollowPlayer = false end
	if GetConVar("vj_npc_nosnpcchat"):GetInt() == 1 then self.AllowPrintingInChat = false end
	if GetConVar("vj_npc_nomedics"):GetInt() == 1 then self.IsMedicSNPC = false end
	if GetConVar("vj_npc_novfx_gibdeath"):GetInt() == 1 then self.HasGibDeathParticles = false end
	if GetConVar("vj_npc_nogib"):GetInt() == 1 then self.AllowedToGib = false self.HasGibOnDeath = false end
	if GetConVar("vj_npc_usegmoddecals"):GetInt() == 1 then self.BloodDecalUseGMod = true end
	if GetConVar("vj_npc_knowenemylocation"):GetInt() == 1 then self.FindEnemy_UseSphere = true self.FindEnemy_CanSeeThroughWalls = true end
	if GetConVar("vj_npc_sd_gibbing"):GetInt() == 1 then self.HasGibOnDeathSounds = false end
	if GetConVar("vj_npc_sd_soundtrack"):GetInt() == 1 then self.HasSoundTrack = false end
	if GetConVar("vj_npc_sd_footstep"):GetInt() == 1 then self.HasFootStepSound = false end
	if GetConVar("vj_npc_sd_idle"):GetInt() == 1 then self.HasIdleSounds = false end
	if GetConVar("vj_npc_sd_breath"):GetInt() == 1 then self.HasBreathSound = false end
	if GetConVar("vj_npc_sd_alert"):GetInt() == 1 then self.HasAlertSounds = false end
	if GetConVar("vj_npc_sd_meleeattack"):GetInt() == 1 then self.HasMeleeAttackSounds = false self.HasExtraMeleeAttackSounds = false self.HasMeleeAttackMissSounds = false end
	if GetConVar("vj_npc_sd_slowplayer"):GetInt() == 1 then self.HasMeleeAttackSlowPlayerSound = false end
	if GetConVar("vj_npc_sd_rangeattack"):GetInt() == 1 then self.HasBeforeRangeAttackSound = false self.HasRangeAttackSound = false end
	if GetConVar("vj_npc_sd_leapattack"):GetInt() == 1 then self.HasBeforeLeapAttackSound = false self.HasLeapAttackJumpSound = false self.HasLeapAttackDamageSound = false self.HasLeapAttackDamageMissSound = false end
	if GetConVar("vj_npc_sd_pain"):GetInt() == 1 then self.HasPainSounds = false end
	if GetConVar("vj_npc_sd_death"):GetInt() == 1 then self.HasDeathSounds = false end
	if GetConVar("vj_npc_sd_followplayer"):GetInt() == 1 then self.HasFollowPlayerSounds_Follow = false self.HasFollowPlayerSounds_UnFollow = false end
	if GetConVar("vj_npc_sd_becomenemytoply"):GetInt() == 1 then self.HasBecomeEnemyToPlayerSounds = false end
	if GetConVar("vj_npc_sd_damagebyplayer"):GetInt() == 1 then self.HasDamageByPlayerSounds = false end
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
local defShootVec = Vector(0, 0, 55)
--
function ENT:Initialize()
	if self.AnimTbl_IdleStand == nil then self.AnimTbl_IdleStand = defIdleTbl end
	self:CustomOnPreInitialize()
	self:SetSpawnEffect(false)
	self:SetRenderMode(RENDERMODE_NORMAL) // RENDERMODE_TRANSALPHA
	self:AddEFlags(EFL_NO_DISSOLVE)
	self:SetUseType(SIMPLE_USE)
	if self:GetName() == "" then
		self:SetName((self.PrintName == "" and list.Get("NPC")[self:GetClass()].Name) or self.PrintName)
	end
	self.SelectedDifficulty = GetConVar("vj_npc_difficulty"):GetInt()
	if VJ.PICK(self.Model) != false then self:SetModel(VJ.PICK(self.Model)) end
	self:SetHullType(self.HullType)
	if self.HullSizeNormal == true then self:SetHullSizeNormal() end
	if self.HasSetSolid == true then self:SetSolid(SOLID_BBOX) end // SOLID_OBB
	self:SetCollisionGroup(COLLISION_GROUP_NPC)
	//self:SetCustomCollisionCheck() -- Used for the hook GM:ShouldCollide, not reliable!
	self:SetMaxYawSpeed(self.TurningSpeed)
	ConvarsOnInit(self)
	self:DoChangeMovementType()
	self.VJ_AddCertainEntityAsEnemy = {}
	self.VJ_AddCertainEntityAsFriendly = {}
	self.CurrentPossibleEnemies = {}
	self.NextIdleSoundT_RegularChange = CurTime() + math.random(0.3, 6)
	self.UseTheSameGeneralSoundPitch_PickedNumber = (self.UseTheSameGeneralSoundPitch and math.random(self.GeneralSoundPitch1, self.GeneralSoundPitch2)) or 0
	self:CapabilitiesAdd(bit.bor(CAP_SKIP_NAV_GROUND_CHECK, CAP_TURN_HEAD))
	//self:CapabilitiesAdd(CAP_ANIMATEDFACE) -- Breaks some NPCs because during high velocity, the model tilts (EX: leap attacks)
	if self.CanOpenDoors == true then
		self:CapabilitiesAdd(bit.bor(CAP_OPEN_DOORS, CAP_AUTO_DOORS, CAP_USE))
	end
	self:SetHealth((GetConVar("vj_npc_allhealth"):GetInt() > 0) and GetConVar("vj_npc_allhealth"):GetInt() or self:VJ_GetDifficultyValue(self.StartHealth))
	self.StartHealth = self:Health()
	self:SetSaveValue("m_HackedGunPos", defShootVec) -- Overrides the location of self:GetShootPos()
	self:CustomOnInitialize()
	if self.CustomInitialize then self:CustomInitialize() end -- !!!!!!!!!!!!!! DO NOT USE THIS FUNCTION !!!!!!!!!!!!!! [Backwards Compatibility!]
	-- Auto compute damage bounds if the damage bounds == collision bounds then the developer has NOT changed it | Call after "CustomOnInitialize"
	if self:GetSurroundingBounds() == self:WorldSpaceAABB() then
		local collisionMin, collisionMax = self:GetCollisionBounds()
		self:SetSurroundingBounds(Vector(collisionMin.x * 1.8, collisionMin.y * 1.8, collisionMin.z * 1.2), Vector(collisionMax.x * 1.8, collisionMax.y * 1.8, collisionMax.z * 1.2))
	end
	//self:SetSurroundingBoundsType(BOUNDS_HITBOXES) -- AVOID! Has to constantly recompute the bounds! | Issues: Entities get stuck inside the NPC, movements failing, unable to grab the NPC with physgun
	self:SetupBloodColor(self.BloodColor) -- Collision bounds dependent, call after "CustomOnInitialize"
	self.NextWanderTime = ((self.NextWanderTime != 0) and self.NextWanderTime) or (CurTime() + (self.IdleAlwaysWander and 0 or 1)) -- If self.NextWanderTime isn't given a value THEN if self.IdleAlwaysWander isn't true, wait at least 1 sec before wandering
	self.SightDistance = (GetConVar("vj_npc_seedistance"):GetInt() > 0) and GetConVar("vj_npc_seedistance"):GetInt() or self.SightDistance
	if self.Immune_Physics then self:SetImpactEnergyScale(0) end -- !!!!!!!!!!!!!! DO NOT USE THIS VARIABLE !!!!!!!!!!!!!! [Backwards Compatibility!]
	if self.MaxJumpLegalDistance then self.JumpVars.MaxRise = self.MaxJumpLegalDistance.a; self.JumpVars.MaxDrop = self.MaxJumpLegalDistance.b; end -- !!!!!!!!!!!!!! DO NOT USE THIS VARIABLE !!!!!!!!!!!!!! [Backwards Compatibility!]
	timer.Simple(0.15, function()
		if IsValid(self) then
			self:SetMaxLookDistance(self.SightDistance)
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
	//self:SetSaveValue("m_debugOverlays", 1) -- Enables source engine debug overlays (some commands like 'npc_conditions' need it)
end
-- !!!!!!!!!!!!!! DO NOT USE THESE !!!!!!!!!!!!!! [Backwards Compatibility!]
ENT.MeleeAttacking = false
ENT.RangeAttacking = false
ENT.LeapAttacking = false
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoChangeMovementType(movType)
	movType = movType or -1
	if movType != -1 then self.MovementType = movType end
	if self.MovementType == VJ_MOVETYPE_GROUND then
		self:RemoveFlags(FL_FLY)
		self:CapabilitiesRemove(CAP_MOVE_FLY)
		self:SetNavType(NAV_GROUND)
		self:SetMoveType(MOVETYPE_STEP)
		self:CapabilitiesAdd(CAP_MOVE_GROUND)
		if VJ.AnimExists(self, ACT_JUMP) == true or self.UsePlayerModelMovement == true then self:CapabilitiesAdd(CAP_MOVE_JUMP) end
		if VJ.AnimExists(self, ACT_CLIMB_UP) == true then self:CapabilitiesAdd(CAP_MOVE_CLIMB) end
	elseif self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then
		self:CapabilitiesRemove(bit.bor(CAP_MOVE_GROUND, CAP_MOVE_JUMP, CAP_MOVE_CLIMB, CAP_MOVE_SHOOT))
		self:SetGroundEntity(NULL)
		self:AddFlags(FL_FLY)
		self:SetNavType(NAV_FLY)
		self:SetMoveType(MOVETYPE_STEP) // MOVETYPE_FLY, causes issues like Lerp functions not being smooth
		self:CapabilitiesAdd(CAP_MOVE_FLY)
	elseif self.MovementType == VJ_MOVETYPE_STATIONARY then
		self:RemoveFlags(FL_FLY)
		self:CapabilitiesRemove(bit.bor(CAP_MOVE_GROUND, CAP_MOVE_JUMP, CAP_MOVE_CLIMB, CAP_MOVE_SHOOT, CAP_MOVE_FLY))
		self:SetNavType(NAV_NONE)
		if !IsValid(self:GetParent()) then -- Only set move type if it does NOT have a parent!
			self:SetMoveType(MOVETYPE_FLY)
		end
	elseif self.MovementType == VJ_MOVETYPE_PHYSICS then
		self:RemoveFlags(FL_FLY)
		self:CapabilitiesRemove(bit.bor(CAP_MOVE_GROUND, CAP_MOVE_JUMP, CAP_MOVE_CLIMB, CAP_MOVE_SHOOT, CAP_MOVE_FLY))
		self:SetNavType(NAV_NONE)
		self:SetMoveType(MOVETYPE_VPHYSICS)
	end
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
				- NOTE: Combining "AlwaysUseSequence" and "AlwaysUseGesture" will force it to play a gesture-sequence
			- PlayBackRate = How fast should the animation play? | DEFAULT: self.AnimationPlaybackRate
			- PlayBackRateCalculated = If the playback rate is already calculated in the stopActivitiesTime, then set this to true! | DEFAULT: false
		- customFunc() = TODO: NOT FINISHED
	Returns
		- Animation, this may be an activity number or a string depending on how the animation played
			- ACT_INVALID = No animation was played or found
		- Number, Accurate animation play time after taking everything in account
			- WARNING: If "animDelay" parameter is used, result may be inaccurate!
-----------------------------------------------------------]]
local varGes = "vjges_"
local varSeq = "vjseq_"
--
function ENT:VJ_ACT_PLAYACTIVITY(animation, stopActivities, stopActivitiesTime, faceEnemy, animDelay, extraOptions, customFunc)
	animation = VJ.PICK(animation)
	if animation == false then return ACT_INVALID, 0 end
	
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
		local finalString; -- Only define a table if we need to!
		local posCur = 1
		for i = 1, #animation do
			local posStartGes, posEndGes = string_find(animation, varGes, posCur) -- Check for "vjges_"
			local posStartSeq, posEndSeq = string_find(animation, varSeq, posCur) -- Check for "vjges_"
			if !posStartGes && !posStartSeq then -- No ges or seq was found, end the loop!
				if finalString then
					finalString[#finalString + 1] = string_sub(animation, posCur)
				end
				break
			end
			if !finalString then finalString = {} end -- Found a match, create table if needed
			if posStartGes then
				isGesture = true
				finalString[i] = string_sub(animation, posCur, posStartGes - 1)
				posCur = posEndGes + 1
			end
			if posStartSeq then
				isSequence = true
				finalString[i] = string_sub(animation, posCur, posStartSeq - 1)
				posCur = posEndSeq + 1
			end
		end
		if finalString then
			animation = table_concat(finalString)
		end
		-- If animation is -1 then it's probably an activity, so turn it into an activity
		-- EX: "vjges_"..ACT_MELEE_ATTACK1
		if isGesture && !isSequence && self:LookupSequence(animation) == -1 then
			animation = tonumber(animation)
			isString = false
		end
	end
	
	if extraOptions.AlwaysUseGesture == true then isGesture = true end -- Must play as a gesture
	if extraOptions.AlwaysUseSequence == true then -- Must play as a sequence
		//isGesture = false -- Leave this alone to allow gesture-sequences to play even when "AlwaysUseSequence" is true!
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
	if VJ.AnimExists(self, animation) == false then
		return ACT_INVALID, 0 -- This isn't a human SNPC, no need to check for weapon translation
	end
	
	-- Seed the current animation, used for animation delaying & on complete check
	local seed = CurTime(); self.CurAnimationSeed = seed
	local function PlayAct()
		local animTime = self:DecideAnimationLength(animation, false)
		
		if stopActivities == true then
			if isbool(stopActivitiesTime) then -- false = Let the base calculate the time
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
		
		self.NextIdleStandTime = 0
		
		self.AnimationPlaybackRate = finalPlayBackRate
		self:SetPlaybackRate(finalPlayBackRate)
		
		if isGesture == true then
			-- If it's an activity gesture AND it's already playing it, then remove it! Fixes same activity gestures bugging out when played right after each other!
			if !isSequence && self:IsPlayingGesture(animation) then
				self:RemoveGesture(animation)
				//self:RemoveAllGestures() -- Disallows the ability to layer multiple gestures!
			end
			local gesture = isSequence and self:AddGestureSequence(self:LookupSequence(animation)) or self:AddGesture(animation)
			//print(gesture)
			if gesture != -1 then
				self:SetLayerPriority(gesture, 1) // 2
				//self:SetLayerWeight(gesture, 1)
				self:SetLayerPlaybackRate(gesture, finalPlayBackRate * 0.5)
			end
		else -- Sequences & Activities
			local schedPlayAct = vj_ai_schedule.New("vj_act_"..animation)
			
			-- For humans NPCs, internally the base will set these variables back to true after this function if it's called by weapon attack animations!
			self.DoingWeaponAttack = false
			self.DoingWeaponAttack_Standing = false
			
			//self:StartEngineTask(ai.GetTaskID("TASK_RESET_ACTIVITY"), 0) //schedPlayAct:EngTask("TASK_RESET_ACTIVITY", 0)
			//if self.Dead then schedPlayAct:EngTask("TASK_STOP_MOVING", 0) end
			//self:FrameAdvance(0)
			self:TaskComplete()
			self:StopMoving()
			self:ClearSchedule()
			self:ClearGoal()
			
			if isSequence == true then
				local seqID = self:LookupSequence(animation)
				--
				-- START: Experimental transition system for sequences
				local transitionAnim = self:FindTransitionSequence(self:GetSequence(), seqID) -- Find the transition sequence
				local transitionAnimTime = 0
				if transitionAnim != -1 && seqID != transitionAnim then -- If it exists AND it's not the same as the animation
					transitionAnimTime = self:SequenceDuration(transitionAnim) / self.AnimationPlaybackRate
					schedPlayAct:AddTask("TASK_VJ_PLAY_SEQUENCE", {
						animation = transitionAnim,
						playbackRate = finalPlayBackRate,
						duration = transitionAnimTime
					})
				end
				-- END: Experimental transition system for sequences
				--
				schedPlayAct:AddTask("TASK_VJ_PLAY_SEQUENCE", {
					animation = animation,
					playbackRate = finalPlayBackRate,
					duration = animTime
				})
				//self:VJ_PlaySequence(animation, finalPlayBackRate, extraOptions.SequenceDuration != false, dur)
				animTime = animTime + transitionAnimTime -- Adjust the animation time in case we have a transition animation!
			else -- Only if activity
				//self:SetActivity(ACT_RESET)
				schedPlayAct:AddTask("TASK_VJ_PLAY_ACTIVITY", {
					animation = animation,
					duration = animTime
				})
				-- Old engine task animation system
				/*if self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then
					self:ResetIdealActivity(animation)
					//schedPlayAct:EngTask("TASK_SET_ACTIVITY", animation) -- To avoid AutoMovement stopping the velocity
				//elseif faceEnemy == true then
					//schedPlayAct:EngTask("TASK_PLAY_SEQUENCE_FACE_ENEMY", animation)
				else
					-- Engine's default animation task
					-- REQUIRED FOR TASK_PLAY_SEQUENCE: It fixes animations NOT applying walk frames if the previous animation was the same!
					if self:GetActivity() == animation then
						self:ResetSequenceInfo()
						self:SetSaveValue("sequence", 0)
					end
					schedPlayAct:EngTask("TASK_PLAY_SEQUENCE", animation)
				end*/
			end
			if faceEnemy == true then
				self:SetTurnTarget("Enemy", animTime)
			end
			schedPlayAct.IsPlayActivity = true
			schedPlayAct.CanBeInterrupted = !stopActivities
			if (customFunc) then customFunc(schedPlayAct, animation) end
			self:StartSchedule(schedPlayAct)
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
		return animation, animDelay + self:DecideAnimationLength(animation, false) -- Approximation, this may be inaccurate!
	else
		return animation, PlayAct()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local task_chaseEnemyLOS = vj_ai_schedule.New("vj_chase_enemy_los")
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
local task_chaseEnemy = vj_ai_schedule.New("vj_chase_enemy")
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
	self:SetMovementActivity(VJ.PICK(self.AnimTbl_Run))
	if doLOSChase == true then
		task_chaseEnemyLOS.RunCode_OnFinish = function()
			local ene = self:GetEnemy()
			if IsValid(ene) then
				//self:RememberUnreachable(ene, 0)
				self:VJ_TASK_CHASE_ENEMY(false)
			end
		end
		self:StartSchedule(task_chaseEnemyLOS)
	else
		task_chaseEnemy.RunCode_OnFail = function() if self.VJ_TASK_IDLE_STAND then self:VJ_TASK_IDLE_STAND() end end
		self:StartSchedule(task_chaseEnemy)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_TASK_IDLE_STAND()
	if self:IsMoving() or (self.NextIdleTime > CurTime()) or (self.AA_CurrentMoveTime > CurTime()) or self:GetNavType() == NAV_JUMP or self:GetNavType() == NAV_CLIMB then return end // self.CurrentSchedule != nil
	if (self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC) && self:BusyWithActivity() then return end
	//if (self.CurrentSchedule != nil && self.CurrentSchedule.Name == "vj_idle_stand") or (self.CurrentAnim_CustomIdle != 0 && VJ.IsCurrentAnimation(self,self.CurrentAnim_CustomIdle) == true) then return end
	//if (self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC) && self:GetVelocity():Length() > 0 then return end
	//if self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then self:AA_StopMoving() return end
	
	local idleAnimTbl = self.AnimTbl_IdleStand
	local posIdlesTbl = {}
	local posIdlesTblIndex = 1
	local sameAnimFound = false -- If true then it one of the animations in the table is the same as the current!
	local curAnim = self.CurrentIdleAnimation
	for k, v in ipairs(idleAnimTbl) do
		v = VJ.SequenceToActivity(self, v) -- Translate any sequence to activity
		if v != false then -- Its a valid activity
			//idleAnimTbl[k] = v -- In case it was a sequence, override it with the translated activity number
			posIdlesTbl[posIdlesTblIndex] = v
			posIdlesTblIndex = posIdlesTblIndex + 1
			-- Check if its the current idle animation...
			if sameAnimFound == false && curAnim == v then
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
	
	local pickedAnim = VJ.PICK(posIdlesTbl) or ACT_IDLE -- If no animation was found, then use ACT_IDLE
	
	-- If sequence and it has no activity, then don't continue!
	//pickedAnim = VJ.SequenceToActivity(self,pickedAnim)
	//if pickedAnim == false then return false end
	
	if (!sameAnimFound /*or (sameAnimFound && numOfAnims == 1 && CurTime() > self.NextIdleStandTime)*/) or (CurTime() > self.NextIdleStandTime) then
		self.CurrentIdleAnimation = pickedAnim
		//self.CurIdleStandMove = false
		-- Old system
		/*if (self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC) then
			if self:BusyWithActivity() == true then return end // self:GetSequence() == 0
			self:AA_StopMoving()
			self:VJ_ACT_PLAYACTIVITY(pickedAnim, false, 0, false, 0, {SequenceDuration=false, SequenceInterruptible=true}) // AlwaysUseSequence=true
		end
		if self.CurrentSchedule == nil then -- If it's not doing a schedule then reset the activity to make sure it's not already playing the same idle activity!
			self:StartEngineTask(ai.GetTaskID("TASK_RESET_ACTIVITY"), 0)
			//self:SetIdealActivity(ACT_RESET)
		end*/
		//self:StartEngineTask(ai.GetTaskID("TASK_PLAY_SEQUENCE"),pickedAnim)
		if (self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC) then self:AA_StopMoving() end
		self.CurAnimationSeed = 0
		self:ResetIdealActivity(pickedAnim)
		timer.Simple(0.01, function() -- So we can make sure the engine has enough time to set the animation
			if IsValid(self) && self.NextIdleStandTime != 0 then
				local getSeq = self:GetSequence()
				//self.CurIdleStandMove = self:GetSequenceMoveDist(getSeq) > 0
				if VJ.SequenceToActivity(self, self:GetSequenceName(getSeq)) == pickedAnim then -- Nayir yete himagva animation e nooynene
					self.NextIdleStandTime = CurTime() + ((self:SequenceDuration(getSeq) - 0.01) / self:GetPlaybackRate()) -- Yete nooynene ooremen jamanage tir animation-en yergarootyan chap!
				end
			end
		end)
		self.NextIdleStandTime = CurTime() + 0.15 -- This is temp, timer above overrides it
	//elseif self.CurIdleStandMove && !self:IsSequenceFinished() then
		//self:AutoMovement(self:GetAnimTimeInterval())
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoIdleAnimation(idleType) -- idleType: nil = Random | 1 = Wander | 2 = Idle Stand
	if self:GetState() == VJ_STATE_ONLY_ANIMATION_CONSTANT or self.Dead or self.VJ_IsBeingControlled or (self.CurrentAttackAnimationTime > CurTime()) or (self.NextIdleTime > CurTime()) or (self.AA_CurrentMoveTime > CurTime()) or (self.CurrentSchedule != nil && self.CurrentSchedule.Name == "vj_act_resetenemy") then return end
	
	if self.IdleAlwaysWander == true then idleType = 1 end
	
	-- Things that override can't bypass, Forces the NPC to ONLY idle stand!
	if self.DisableWandering == true or self.IsGuard == true or self.MovementType == VJ_MOVETYPE_STATIONARY or self.IsVJBaseSNPC_Tank == true or self.LastHiddenZone_CanWander == false or self.NextWanderTime > CurTime() or self.IsFollowing == true or self.Medic_Status then
		idleType = 2
	end
	
	if !idleType then -- Random (Wander & Idle Stand)
		if math.random(1, 3) == 1 then
			self:VJ_TASK_IDLE_WANDER() else self:VJ_TASK_IDLE_STAND()
		end
	elseif idleType == 1 then -- Wander
		self:VJ_TASK_IDLE_WANDER()
	elseif idleType == 2 then -- Idle Stand
		self:VJ_TASK_IDLE_STAND()
		return -- Don't set self.NextWanderTime below
	end
	
	self.NextWanderTime = CurTime() + math.Rand(3, 6) // self.NextIdleTime
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoChaseAnimation(alwaysChase) -- alwaysChase: true = Override to always make the NPC chase
	local ene = self:GetEnemy()
	if self:GetState() == VJ_STATE_ONLY_ANIMATION_CONSTANT or self.Dead or self.VJ_IsBeingControlled or self.Flinching == true or self.IsVJBaseSNPC_Tank == true or !IsValid(ene) or (self.NextChaseTime > CurTime()) or (CurTime() < self.TakingCoverT) or (self.CurrentAttackAnimationTime > CurTime() && self.MovementType != VJ_MOVETYPE_AERIAL && self.MovementType != VJ_MOVETYPE_AQUATIC) then return end
	if self:VJ_GetNearestPointToEntityDistance(ene) < self.MeleeAttackDistance && self.EnemyData.IsVisible && (self.EnemyData.SightDiff > math_cos(math_rad(self.MeleeAttackAngleRadius))) then if (self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC) then self:AA_StopMoving() end self:VJ_TASK_IDLE_STAND() return end -- Not melee attacking yet but it is in range, so stop moving!
	
	-- Things that override can't bypass, Forces the NPC to ONLY idle stand!
	if self.MovementType == VJ_MOVETYPE_STATIONARY or self.IsFollowing == true or self.Medic_Status or self:GetState() == VJ_STATE_ONLY_ANIMATION then
		self:VJ_TASK_IDLE_STAND()
		return
	end
	
	-- For non-aggressive SNPCs
	if self.Behavior == VJ_BEHAVIOR_PASSIVE or self.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE then
		self:VJ_TASK_COVER_FROM_ENEMY("TASK_RUN_PATH")
		self.NextChaseTime = CurTime() + 3
		return
	end
	
	if !alwaysChase && (self.DisableChasingEnemy == true or self.IsGuard == true) then self:VJ_TASK_IDLE_STAND() return end
	
	-- If the enemy is not reachable then wander around
	if self:IsUnreachable(ene) == true then
		if self.HasRangeAttack == true then -- Ranged NPCs
			self:VJ_TASK_CHASE_ENEMY(true)
		elseif math.random(1, 30) == 1 && !self:IsMoving() then
			self.NextWanderTime = 0
			self:DoIdleAnimation(1)
			self:RememberUnreachable(ene, 4)
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
local finishAttack = {
	[VJ.ATTACK_TYPE_MELEE] = function(self, skipStopAttacks)
		if skipStopAttacks != true then
			timer.Create("timer_melee_finished"..self:EntIndex(), self:DecideAttackTimer(self.NextAnyAttackTime_Melee, self.NextAnyAttackTime_Melee_DoRand, self.TimeUntilMeleeAttackDamage, self.CurrentAttackAnimationDuration), 1, function()
				self:StopAttacks()
				self:DoChaseAnimation()
			end)
		end
		timer.Create("timer_melee_finished_abletomelee"..self:EntIndex(), self:DecideAttackTimer(self.NextMeleeAttackTime, self.NextMeleeAttackTime_DoRand), 1, function()
			self.IsAbleToMeleeAttack = true
		end)
	end,
	[VJ.ATTACK_TYPE_RANGE] = function(self, skipStopAttacks)
		if skipStopAttacks != true then
			timer.Create("timer_range_finished"..self:EntIndex(), self:DecideAttackTimer(self.NextAnyAttackTime_Range, self.NextAnyAttackTime_Range_DoRand, self.TimeUntilRangeAttackProjectileRelease, self.CurrentAttackAnimationDuration), 1, function()
				self:StopAttacks()
				self:DoChaseAnimation()
			end)
		end
		timer.Create("timer_range_finished_abletorange"..self:EntIndex(), self:DecideAttackTimer(self.NextRangeAttackTime, self.NextRangeAttackTime_DoRand), 1, function()
			self.IsAbleToRangeAttack = true
		end)
	end,
	[VJ.ATTACK_TYPE_LEAP] = function(self, skipStopAttacks)
		if skipStopAttacks != true then
			timer.Create("timer_leap_finished"..self:EntIndex(), self:DecideAttackTimer(self.NextAnyAttackTime_Leap, self.NextAnyAttackTime_Leap_DoRand, self.TimeUntilLeapAttackDamage, self.CurrentAttackAnimationDuration), 1, function()
				self:StopAttacks()
				self:DoChaseAnimation()
			end)
		end
		timer.Create("timer_leap_finished_abletoleap"..self:EntIndex(), self:DecideAttackTimer(self.NextLeapAttackTime, self.NextLeapAttackTime_DoRand), 1, function()
			self.IsAbleToLeapAttack = true
		end)
	end
}
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
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	//self:SetPoseParameter("move_yaw", 180)
	
	//if self.CurrentSchedule != nil then PrintTable(self.CurrentSchedule) end
	//if self.CurrentTask != nil then PrintTable(self.CurrentTask) end
	
	//self:SetCondition(1) -- Probably not needed as "sv_pvsskipanimation" handles it | Fix attachments, bones, positions, angles etc. being broken in NPCs! This condition is used as a backup in case "sv_pvsskipanimation" isn't disabled!
	//if self.MovementType == VJ_MOVETYPE_GROUND && self:GetVelocity():Length() <= 0 && !self:IsEFlagSet(EFL_IS_BEING_LIFTED_BY_BARNACLE) /*&& curSched.IsMovingTask == true*/ then self:DropToFloor() end -- No need, already handled by the engine

	local curSched = self.CurrentSchedule
	if curSched != nil then
		if self:IsMoving() then
			if curSched.MoveType == 0 && !VJ.HasValue(self.AnimTbl_Walk, self:GetMovementActivity()) then
				self:SetMovementActivity(VJ.PICK(self.AnimTbl_Walk))
			elseif curSched.MoveType == 1 && !VJ.HasValue(self.AnimTbl_Run, self:GetMovementActivity()) then
				self:SetMovementActivity(VJ.PICK(self.AnimTbl_Run))
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
	
	local curTime = CurTime()
	
	-- Breath sound system
	if !self.Dead && self.HasBreathSound && self.HasSounds && curTime > self.NextBreathSoundT then
		local sdTbl = VJ.PICK(self.SoundTbl_Breath)
		local dur = 1
		if sdTbl then
			StopSound(self.CurrentBreathSound)
			dur = (self.NextSoundTime_Breath == false and SoundDuration(sdTbl)) or math.Rand(self.NextSoundTime_Breath.a, self.NextSoundTime_Breath.b)
			self.CurrentBreathSound = VJ.CreateSound(self, sdTbl, self.BreathSoundLevel, self:VJ_DecideSoundPitch(self.BreathSoundPitch.a, self.BreathSoundPitch.b))
		end
		self.NextBreathSoundT = curTime + dur
	end
	
	self:CustomOnThink()
	--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
	if GetConVar("ai_disabled"):GetInt() == 0 && self:GetState() != VJ_STATE_FREEZE && !self:IsEFlagSet(EFL_IS_BEING_LIFTED_BY_BARNACLE) then
		if self.VJ_DEBUG == true then
			if GetConVar("vj_npc_printcurenemy"):GetInt() == 1 then print(self:GetClass().."'s Enemy: ",self:GetEnemy()," Alerted? ",self.Alerted) end
			if GetConVar("vj_npc_printtakingcover"):GetInt() == 1 then if curTime > self.TakingCoverT == true then print(self:GetClass().." Is Not Taking Cover") else print(self:GetClass().." Is Taking Cover ("..self.TakingCoverT-curTime..")") end end
			if GetConVar("vj_npc_printlastseenenemy"):GetInt() == 1 then PrintMessage(HUD_PRINTTALK, (curTime - self.EnemyData.LastVisibleTime).." ("..self:GetName()..")") end
		end
		
		local eneData = self.EnemyData
		local didTurn = false -- Did the NPC do any turning?
		
		self:SetPlaybackRate(self.AnimationPlaybackRate)
		if self:GetArrivalActivity() == -1 then
			self:SetArrivalActivity(self.CurrentIdleAnimation)
		end
		
		self:CustomOnThink_AIEnabled()

		self:IdleSoundCode()
		if self.DisableFootStepSoundTimer == false then self:FootStepSoundCode() end
		
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
							moveSpeed = math_clamp(dist, self.AA_CurrentMoveMaxSpeed / self.AA_MoveDecelerate, moveSpeed)
						elseif self.AA_MoveAccelerate > 0 then
							moveSpeed = Lerp(FrameTime()*self.AA_MoveAccelerate, myVelLen, moveSpeed)
						end
						local velPos = self.AA_CurrentMovePosDir:GetNormal()*moveSpeed
						local velTimeCur = curTime + (dist / velPos:Length())
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
				if self.AA_CurrentMoveAnimation != -1 then
					self:AA_MoveAnimation()
				end
			-- Not moving, reset its move time!
			else
				self.AA_CurrentMoveTime = 0
			end
		end
		
		-- Update follow system's data
		//print("------------------")
		//PrintTable(self.FollowData)
		if self.IsFollowing == true && self:GetNavType() != NAV_JUMP && self:GetNavType() != NAV_CLIMB then
			local followData = self.FollowData
			local followEnt = followData.Ent
			local followIsLiving = followData.IsLiving
			//print(self:GetTarget())
			if IsValid(followEnt) && (!followIsLiving or (followIsLiving && (self:Disposition(followEnt) == D_LI or self:GetClass() == followEnt:GetClass()) && VJ.IsAlive(followEnt))) then
				if curTime > self.NextFollowUpdateT && !self.VJTag_IsHealing then
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
							self:VJ_TASK_GOTO_TARGET((distToPly < (followData.MinDist * 1.5) and "TASK_WALK_PATH") or "TASK_RUN_PATH", function(schedule)
								schedule.CanShootWhenMoving = true
								if IsValid(self:GetActiveWeapon()) then
									schedule.FaceData = {Type = VJ.NPC_FACE_ENEMY_VISIBLE}
								end
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
		
		-- Used for AA SNPCs (Deprecated)
		/*if self.AA_CurrentTurnAng then
			local setAngs = self.AA_CurrentTurnAng
			self:SetAngles(Angle(setAngs.p, self:GetAngles().y, setAngs.r))
			self:SetIdealYawAndUpdate(setAngs.y)
			//self:SetAngles(Angle(math_angApproach(self:GetAngles().p, self.AA_CurrentTurnAng.p, self.TurningSpeed),math_angApproach(self:GetAngles().y, self.AA_CurrentTurnAng.y, self.TurningSpeed),math_angApproach(self:GetAngles().r, self.AA_CurrentTurnAng.r, self.TurningSpeed)))
		end*/

		-- Handle main parts of the turning system
		local turnData = self.TurnData
		if turnData.Type != VJ.NPC_FACE_NONE then
			-- If StopOnFace flag is set AND (Something has requested to take over by checking "ideal yaw != last set yaw") OR (we are facing ideal) then finish it!
			if turnData.StopOnFace && (self:GetIdealYaw() != turnData.LastYaw or self:IsFacingIdealYaw()) then
				self:ResetTurnTarget()
			else
				local turnTarget = turnData.Target
				if turnData.Type == VJ.NPC_FACE_POSITION or (turnData.Type == VJ.NPC_FACE_POSITION_VISIBLE && self:VisibleVec(turnTarget)) then
					local resultAng = self:GetFaceAngle((turnTarget - self:GetPos()):Angle())
					if self.TurningUseAllAxis == true then
						local myAng = self:GetAngles()
						self:SetAngles(LerpAngle(FrameTime()*self.TurningSpeed, myAng, Angle(resultAng.p, myAng.y, resultAng.r)))
					end
					self:SetIdealYawAndUpdate(resultAng.y)
					self.TurnData.LastYaw = resultAng.y
					didTurn = true
				elseif IsValid(turnTarget) && (turnData.Type == VJ.NPC_FACE_ENTITY or (turnData.Type == VJ.NPC_FACE_ENTITY_VISIBLE && self:Visible(turnTarget))) then
					local resultAng = self:GetFaceAngle((turnTarget:GetPos() - self:GetPos()):Angle())
					if self.TurningUseAllAxis == true then
						local myAng = self:GetAngles()
						self:SetAngles(LerpAngle(FrameTime()*self.TurningSpeed, myAng, Angle(resultAng.p, myAng.y, resultAng.r)))
					end
					self:SetIdealYawAndUpdate(resultAng.y)
					self.TurnData.LastYaw = resultAng.y
					didTurn = true
				end
			end
		end
		
		if !self.Dead then
			-- Health Regeneration System
			if self.HasHealthRegeneration == true && curTime > self.HealthRegenerationDelayT then
				local myHP = self:Health()
				self:SetHealth(math_clamp(myHP + self.HealthRegenerationAmount, myHP, self:GetMaxHealth()))
				self.HealthRegenerationDelayT = curTime + math.Rand(self.HealthRegenerationDelay.a, self.HealthRegenerationDelay.b)
			end
			
			-- Run the heavy processes
			if curTime > self.NextProcessT then
				self:MaintainRelationships()
				self:MaintainMedicBehavior()
				self.NextProcessT = curTime + self.NextProcessTime
			end

			local plyControlled = self.VJ_IsBeingControlled
			local myPos = self:GetPos()
			local ene = self:GetEnemy()
			local eneValid = IsValid(ene)
			if eneData.Reset == false then
				-- Reset enemy if it doesn't exist or it's dead
				if (!eneValid) or (eneValid && ene:Health() <= 0) then
					eneData.Reset = true
					self:ResetEnemy(true)
					ene = self:GetEnemy()
					eneValid = IsValid(ene)
				end
				-- Reset enemy if it has been unseen for a while
				if (curTime - eneData.LastVisibleTime) > self.TimeUntilEnemyLost && (!self.IsVJBaseSNPC_Tank) then
					self:PlaySoundSystem("LostEnemy")
					eneData.Reset = true
					self:ResetEnemy(true)
					ene = self:GetEnemy()
					eneValid = IsValid(ene)
				end
			end
			
			-- Eating system
			if self.CanEat && !plyControlled then
				local eatingData = self.EatingData
				if !eatingData then -- Eating data has NOT been initialized, so initialize it!
					self.EatingData = {Ent = NULL, NextCheck = 0, AnimStatus = "None", OldIdleTbl = nil}
						-- AnimStatus: "None" = Not prepared (Probably moving to food location) | "Prepared" = Prepared (Ex: Played crouch down anim) | "Eating" = Prepared and is actively eating
					eatingData = self.EatingData
				end
				if eneValid or self.Alerted then
					if self.VJTag_IsEating then
						eatingData.NextCheck = curTime + 15
						self:EatingReset("Enemy")
					end
				elseif curTime > eatingData.NextCheck then
					if self.VJTag_IsEating then
						local food = eatingData.Ent
						if !IsValid(food) then -- Food no longer exists, reset!
							eatingData.NextCheck = curTime + 10
							self:EatingReset("Unspecified")
						elseif !self:IsMoving() then
							local foodDist = self:VJ_GetNearestPointToEntityDistance(food) // myPos:Distance(food:GetPos())
							if foodDist > 400 then -- Food too far away, reset!
								eatingData.NextCheck = curTime + 10
								self:EatingReset("Unspecified")
							elseif foodDist > 30 then -- Food moved a bit, go to new location
								if self:IsBusy() then -- Something else has come up, stop eating completely!
									eatingData.NextCheck = curTime + 15
									self:EatingReset("Unspecified")
								else
									if eatingData.AnimStatus != "None" then -- We need to play get up anim first!
										eatingData.AnimStatus = "None"
										self:SetIdleAnimation(eatingData.OldIdleTbl, true) -- Reset the idle animation table in case it changed!
										eatingData.NextCheck = curTime + (self:CustomOnEat("StopEating", "HaltOnly") or 1)
									else
										self.NextWanderTime = CurTime() + math.Rand(3, 5)
										self:SetState(VJ_STATE_NONE)
										self:SetLastPosition(select(2, self:VJ_GetNearestPointToEntity(food)))
										self:VJ_TASK_GOTO_LASTPOS("TASK_WALK_PATH")
										//self:SetTarget(food)
										//self:VJ_TASK_GOTO_TARGET("TASK_WALK_PATH")
										eatingData.NextCheck = curTime + 1
									end
								end
							else -- No changes, continue eating
								self:SetTurnTarget(food, 1)
								self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK)
								if eatingData.AnimStatus != "None" then -- We are already prepared, so eat!
									eatingData.AnimStatus = "Eating"
									eatingData.NextCheck = curTime + self:CustomOnEat("Eat")
									if food:Health() <= 0 then -- Finished eating!
										eatingData.NextCheck = curTime + 30
										self:EatingReset("Devoured")
										food:TakeDamage(100, self, self) -- For entities that react to dmg, Ex: HLR corpses
										food:Remove()
									end
								else -- We need to first prepare before eating! (Ex: Crouch-down animation
									eatingData.AnimStatus = "Prepared"
									eatingData.NextCheck = curTime + (self:CustomOnEat("BeginEating") or 1)
								end
							end
						end
					elseif self:HasCondition(COND_SMELL) && !self:IsMoving() && !self:IsBusy() then
						local hint = sound.GetLoudestSoundHint(SOUND_CARCASS, myPos) // GetBestSoundHint = Do NOT use, completely broken!
						if hint then
							local food = hint.owner
							if IsValid(food) /*&& !food.VJTag_IsBeingEaten*/ then
								if !food.FoodData then
									local size = food:OBBMaxs():Distance(food:OBBMins()) * 2
									food.FoodData = {
										NumConsumers = 0,
										Size = size,
										SizeRemaining = size,
									}
								end
								//print("food", food, self)
								if food.FoodData.SizeRemaining > 0 && self:CustomOnEat("CheckFood", hint) then
									local foodData = food.FoodData
									foodData.NumConsumers = foodData.NumConsumers + 1
									foodData.SizeRemaining = foodData.SizeRemaining - self:OBBMaxs():Distance(self:OBBMins())
									//PrintTable(hint)
									self.VJTag_IsEating = true
									food.VJTag_IsBeingEaten = true
									self.EatingData.OldIdleTbl = self.AnimTbl_IdleStand -- Save the current idle anim table in case we gonna change it while eating!
									eatingData.Ent = food
									self:CustomOnEat("StartBehavior")
									self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK)
									self.NextWanderTime = CurTime() + math.Rand(3, 5)
								end
							end
						end
					//else -- No food was found OR it's not eating
						//eatingData.NextCheck = curTime + 3
					end
				end
			end
		
			if eneValid then
				local enePos = ene:GetPos()
				
				-- Set latest enemy information
				self:UpdateEnemyMemory(ene, enePos)
				eneData.Reset = false
				eneData.IsVisible = plyControlled and self:VisibleVec(enePos) or self:Visible(ene) -- Need to use VisibleVec when controlled because "Visible" will return false randomly
				eneData.SightDiff = self:GetSightDirection():Dot((enePos - myPos):GetNormalized())
				self.LatestEnemyDistance = myPos:Distance(enePos)
				self.NearestPointToEnemyDistance = self:VJ_GetNearestPointToEntityDistance(ene)
				if (eneData.SightDiff > math_cos(math_rad(self.SightAngle))) && (self.LatestEnemyDistance < self:GetMaxLookDistance()) && eneData.IsVisible then
					eneData.LastVisibleTime = curTime
					-- Why 2 vars? Because the last "Visible" tick is usually not updated in time, causing the engine to give false positive, thinking the enemy IS visible
					eneData.LastVisiblePos = eneData.LastVisiblePosReal
					eneData.LastVisiblePosReal = ene:EyePos() -- Use EyePos because "Visible" uses it to run the trace in the engine! | For origin, use "self:GetEnemyLastSeenPos()"
				end
				
				-- Turning / Facing Enemy
				if self.ConstantlyFaceEnemy && self:DoConstantlyFaceEnemy() then didTurn = true end
				turnData = self.TurnData
				if turnData.Type == VJ.NPC_FACE_ENEMY or (turnData.Type == VJ.NPC_FACE_ENEMY_VISIBLE && eneData.IsVisible) then
					local faceAng = self:GetFaceAngle((enePos - myPos):Angle())
					if self.TurningUseAllAxis == true then
						local myAng = self:GetAngles()
						self:SetAngles(LerpAngle(FrameTime()*self.TurningSpeed, myAng, Angle(faceAng.p, myAng.y, faceAng.r)))
					end
					self:SetIdealYawAndUpdate(faceAng.y)
					didTurn = true
				end

				-- Call for help
				if self.CallForHelp == true && curTime > self.NextCallForHelpT then
					self:Allies_CallHelp(self.CallForHelpDistance)
					self.NextCallForHelpT = curTime + self.NextCallForHelpTime
				end
				
				-- Stop chasing at certain distance
				if self.NoChaseAfterCertainRange && !plyControlled && ((self.NoChaseAfterCertainRange_Type == "OnlyRange" && self.HasRangeAttack) or (self.NoChaseAfterCertainRange_Type == "Regular")) && eneData.IsVisible then
					local farDist = self.NoChaseAfterCertainRange_FarDistance
					local closeDist = self.NoChaseAfterCertainRange_CloseDistance
					if farDist == "UseRangeDistance" then farDist = self.RangeDistance end
					if closeDist == "UseRangeDistance" then closeDist = self.RangeToMeleeDistance end
					if (self.LatestEnemyDistance < farDist) && (self.LatestEnemyDistance > closeDist) then
						-- If the self.NextChaseTime is about to expire, then give it 0.5 delay so it does NOT chase!
						if (self.NextChaseTime - curTime) < 0.1 then
							self.NextChaseTime = curTime + 0.5
						end
						local moveType = self.MovementType
						curSched = self.CurrentSchedule -- Already defined
						if curSched != nil && curSched.Name == "vj_chase_enemy" then self:StopMoving() end -- Interrupt enemy chasing because we are in range!
						if moveType == VJ_MOVETYPE_GROUND && !self:IsMoving() && self:OnGround() then self:SetTurnTarget("Enemy") end
						if (moveType == VJ_MOVETYPE_AERIAL or moveType == VJ_MOVETYPE_AQUATIC) then
							if self.AA_CurrentMoveType == 3 then self:AA_StopMoving() end -- Interrupt enemy chasing because we are in range!
							if curTime > self.AA_CurrentMoveTime then self:AA_IdleWander(true, "Calm", {FaceDest = !self.ConstantlyFaceEnemy}) /*self:AA_StopMoving()*/ end -- Only face the position if self.ConstantlyFaceEnemy is false!
						end
					else
						if self.CurrentSchedule != nil && self.CurrentSchedule.Name != "vj_chase_enemy" then self:DoChaseAnimation() end
					end
				end
				
				self:DoPoseParameterLooking()
				
				-- Face enemy for stationary types OR attacks
				if (self.MovementType == VJ_MOVETYPE_STATIONARY && self.CanTurnWhileStationary == true) or (self.MeleeAttackAnimationFaceEnemy == true && self.MeleeAttack_DoingPropAttack == false && self.AttackType == VJ.ATTACK_TYPE_MELEE) or (self.RangeAttackAnimationFaceEnemy == true && self.AttackType == VJ.ATTACK_TYPE_RANGE) or ((self.LeapAttackAnimationFaceEnemy == true or (self.LeapAttackAnimationFaceEnemy == 2 && !self.LeapAttackHasJumped)) && self.AttackType == VJ.ATTACK_TYPE_LEAP) then
					self:SetTurnTarget("Enemy")
				end
				
				-- Attacks
				if !self.vACT_StopAttacks && self:GetState() != VJ_STATE_ONLY_ANIMATION_NOATTACK && self.Behavior != VJ_BEHAVIOR_PASSIVE && self.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE && curTime > self.NextDoAnyAttackT then
					local funcCustomAtk = self.CustomAttack; if funcCustomAtk then funcCustomAtk(self, ene, eneData.IsVisible) end
					
					if !self.Flinching && !self.FollowData.StopAct && self.AttackType == VJ.ATTACK_TYPE_NONE then
						-- Melee Attack
						if self.HasMeleeAttack == true && self.IsAbleToMeleeAttack then
							-- Check for possible props that we can attack/push
							if curTime > self.NextPropAPCheckT then
								self.PropAP_IsVisible = self:DoPropAPCheck()
								self.NextPropAPCheckT = curTime + 0.5
							end
							self:MultipleMeleeAttacks()
							local atkType = 0 -- 0 = No attack | 1 = Normal attack | 2 = Prop attack
							if (plyControlled == true && self.VJ_TheController:KeyDown(IN_ATTACK)) or (plyControlled == false && self.NearestPointToEnemyDistance < self.MeleeAttackDistance && eneData.IsVisible) then
								atkType = 1
							elseif self.PropAP_IsVisible then -- Check for props to attack/push
								atkType = 2
							end
							if self:CustomAttackCheck_MeleeAttack() == true && ((plyControlled == true && atkType == 1) or (plyControlled == false && atkType != 0 && (eneData.SightDiff > math_cos(math_rad(self.MeleeAttackAngleRadius))))) then
								local seed = curTime; self.CurAttackSeed = seed
								self.AttackType = VJ.ATTACK_TYPE_MELEE
								self.AttackState = VJ.ATTACK_STATE_STARTED
								self.MeleeAttacking = true
								self.IsAbleToMeleeAttack = false
								self.RangeAttacking = false
								self.NextAlertSoundT = curTime + 0.4
								if atkType == 2 then
									self.MeleeAttack_DoingPropAttack = true
								else
									self:SetTurnTarget("Enemy")
									self.MeleeAttack_DoingPropAttack = false
								end
								self:CustomOnMeleeAttack_BeforeStartTimer(seed)
								timer.Simple(self.BeforeMeleeAttackSounds_WaitTime, function() if IsValid(self) then self:PlaySoundSystem("BeforeMeleeAttack") end end)
								if self.DisableMeleeAttackAnimation == false then
									local anim, animDur = self:VJ_ACT_PLAYACTIVITY(self.AnimTbl_MeleeAttack, false, 0, false, self.MeleeAttackAnimationDelay)
									if anim != ACT_INVALID then
										self.CurrentAttackAnimation = anim
										self.CurrentAttackAnimationDuration = animDur - (self.MeleeAttackAnimationDecreaseLengthAmount / self:GetPlaybackRate())
										if self.MeleeAttackAnimationAllowOtherTasks == false then -- Useful for gesture-based attacks
											self.CurrentAttackAnimationTime = curTime + self.CurrentAttackAnimationDuration
										end
									end
								end
								if self.TimeUntilMeleeAttackDamage == false then 
									finishAttack[VJ.ATTACK_TYPE_MELEE](self)
								else -- If it's not event based...
									timer.Create("timer_melee_start"..self:EntIndex(), self.TimeUntilMeleeAttackDamage / self:GetPlaybackRate(), self.MeleeAttackReps, function() if self.CurAttackSeed == seed then
											if atkType == 2 then
												self:MeleeAttackCode(true)
											else
												self:MeleeAttackCode()
											end
									end end)
									if self.MeleeAttackExtraTimers then
										for k, t in ipairs(self.MeleeAttackExtraTimers) do
											self:DoAddExtraAttackTimers("timer_melee_start_"..curTime + k, t, function() if self.CurAttackSeed == seed then
												if atkType == 2 then
													self:MeleeAttackCode(true)
												else
													self:MeleeAttackCode()
												end
											end end)
										end
									end
								end
								self:CustomOnMeleeAttack_AfterStartTimer(seed)
							end
						end

						-- Range Attack
						if self.HasRangeAttack == true && self.IsAbleToRangeAttack && eneData.IsVisible then
							self:MultipleRangeAttacks()
							if self:CustomAttackCheck_RangeAttack() == true && ((plyControlled == true && self.VJ_TheController:KeyDown(IN_ATTACK2)) or (plyControlled == false && (self.LatestEnemyDistance < self.RangeDistance) && (self.LatestEnemyDistance > self.RangeToMeleeDistance) && (eneData.SightDiff > math_cos(math_rad(self.RangeAttackAngleRadius))))) then
								local seed = curTime; self.CurAttackSeed = seed
								self.AttackType = VJ.ATTACK_TYPE_RANGE
								self.AttackState = VJ.ATTACK_STATE_STARTED
								self.RangeAttacking = true
								self.IsAbleToRangeAttack = false
								if self.RangeAttackAnimationStopMovement == true then self:StopMoving() end
								self:CustomOnRangeAttack_BeforeStartTimer(seed)
								self:PlaySoundSystem("BeforeRangeAttack")
								if self.DisableRangeAttackAnimation == false then
									local anim, animDur = self:VJ_ACT_PLAYACTIVITY(self.AnimTbl_RangeAttack, false, 0, false, self.RangeAttackAnimationDelay)
									if anim != ACT_INVALID then
										self.CurrentAttackAnimation = anim
										self.CurrentAttackAnimationDuration = animDur - (self.RangeAttackAnimationDecreaseLengthAmount / self:GetPlaybackRate())
										self.CurrentAttackAnimationTime = curTime + self.CurrentAttackAnimationDuration
									end
								end
								if self.TimeUntilRangeAttackProjectileRelease == false then
									finishAttack[VJ.ATTACK_TYPE_RANGE](self)
								else -- If it's not event based...
									timer.Create("timer_range_start"..self:EntIndex(), self.TimeUntilRangeAttackProjectileRelease / self:GetPlaybackRate(), self.RangeAttackReps, function() if self.CurAttackSeed == seed then self:RangeAttackCode() end end)
									if self.RangeAttackExtraTimers then
										for k, t in ipairs(self.RangeAttackExtraTimers) do
											self:DoAddExtraAttackTimers("timer_range_start_"..curTime + k, t, function() if self.CurAttackSeed == seed then self:RangeAttackCode() end end)
										end
									end
								end
								self:CustomOnRangeAttack_AfterStartTimer(seed)
							end
						end

						-- Leap Attack
						if self.HasLeapAttack == true && self.IsAbleToLeapAttack && eneData.IsVisible then
							self:MultipleLeapAttacks()
							if self:CustomAttackCheck_LeapAttack() == true && ((plyControlled == true && self.VJ_TheController:KeyDown(IN_JUMP)) or (plyControlled == false && (self:IsOnGround() && self.LatestEnemyDistance < self.LeapDistance) && (self.LatestEnemyDistance > self.LeapToMeleeDistance) && (eneData.SightDiff > math_cos(math_rad(self.LeapAttackAngleRadius))))) then
								local seed = curTime; self.CurAttackSeed = seed
								self.AttackType = VJ.ATTACK_TYPE_LEAP
								self.AttackState = VJ.ATTACK_STATE_STARTED
								self.LeapAttacking = true
								self.IsAbleToLeapAttack = false
								self.LeapAttackHasJumped = false
								//self.JumpLegalLandingTime = 0
								self:CustomOnLeapAttack_BeforeStartTimer(seed)
								self:PlaySoundSystem("BeforeRangeAttack")
								timer.Create("timer_leap_start_jump"..self:EntIndex(), self.TimeUntilLeapAttackVelocity / self:GetPlaybackRate(), 1, function() self:LeapAttackVelocityCode() end)
								if self.DisableLeapAttackAnimation == false then
									local anim, animDur = self:VJ_ACT_PLAYACTIVITY(self.AnimTbl_LeapAttack, false, 0, false, self.LeapAttackAnimationDelay)
									if anim != ACT_INVALID then
										self.CurrentAttackAnimation = anim
										self.CurrentAttackAnimationDuration = animDur - (self.LeapAttackAnimationDecreaseLengthAmount / self:GetPlaybackRate())
										self.CurrentAttackAnimationTime = curTime + self.CurrentAttackAnimationDuration
									end
								end
								if self.TimeUntilLeapAttackDamage == false then
									finishAttack[VJ.ATTACK_TYPE_LEAP](self)
								else -- If it's not event based...
									timer.Create("timer_leap_start"..self:EntIndex(), self.TimeUntilLeapAttackDamage / self:GetPlaybackRate(), self.LeapAttackReps, function() if self.CurAttackSeed == seed then self:LeapDamageCode() end end)
									if self.LeapAttackExtraTimers then
										for k, t in ipairs(self.LeapAttackExtraTimers) do
											self:DoAddExtraAttackTimers("timer_leap_start_"..curTime + k, t, function() if self.CurAttackSeed == seed then self:LeapDamageCode() end end)
										end
									end
								end
								self:CustomOnLeapAttack_AfterStartTimer(seed)
							end
						end
					end
				end
			else -- No enemy
				if !plyControlled then
					self:DoPoseParameterLooking(true)
					//self:ClearPoseParameters()
				end
				eneData.TimeSinceAcquired = 0
				if eneData.Reset == false && (!self.IsVJBaseSNPC_Tank) then self:PlaySoundSystem("LostEnemy") eneData.Reset = true self:ResetEnemy(true) end
			end
			
			if self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then
				if IsValid(ene) && self.CurrentAttackAnimationTime > CurTime() && self:VJ_GetNearestPointToEntityDistance(ene) < self.MeleeAttackDistance then
					self:AA_StopMoving()
				else
					self:SelectSchedule()
				end
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
						self:VJ_TASK_GOTO_LASTPOS(dist <= 800 and "TASK_WALK_PATH" or "TASK_RUN_PATH", function(x)
							x.CanShootWhenMoving = true
							x.FaceData = {Type = VJ.NPC_FACE_ENEMY}
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
		
		-- Handle the unique movement system for player models
		if self.UsePlayerModelMovement == true && self.MovementType == VJ_MOVETYPE_GROUND then
            local moveDir = self:GetMoveDirection(true)
            if moveDir then
                self:SetPoseParameter("move_x", moveDir.x)
                self:SetPoseParameter("move_y", moveDir.y)
                if !didTurn then -- Only face move direction if I have NOT faced anything else!
                    self:SetTurnTarget(self:GetCurWaypointPos())
                end
            else -- I am not moving, reset the pose parameters, otherwise I will run in place!
                self:SetPoseParameter("move_x", 0)
                self:SetPoseParameter("move_y", 0)
            end
        end
	else -- AI Not enabled
		if (self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC) then self:AA_StopMoving() end
	end
	self:NextThink(curTime + (0.069696968793869 + FrameTime()))
	return true
end
--------------------------------------------------------------------------------------------------------------------------------------------
local propColBlacklist = {[COLLISION_GROUP_DEBRIS]=true, [COLLISION_GROUP_DEBRIS_TRIGGER]=true, [COLLISION_GROUP_DISSOLVING]=true, [COLLISION_GROUP_IN_VEHICLE]=true, [COLLISION_GROUP_WORLD]=true}
--
function ENT:DoPropAPCheck(customEnts, customMeleeDistance)
	if !self.PushProps && !self.AttackProps then return false end
	local myPos = self:GetPos()
	for _, v in ipairs(customEnts or ents.FindInSphere(self:GetMeleeAttackDamageOrigin(), customMeleeDistance or math_clamp(self.MeleeAttackDamageDistance - 30, self.MeleeAttackDistance, self.MeleeAttackDamageDistance))) do
		local verifiedEnt = ((destructibleEnts[v:GetClass()] or v.VJTag_ID_Prop == true) and true) or false -- Whether or not it's a prop or an entity to attack
		if v:GetClass() == "prop_door_rotating" && v:Health() <= 0 then verifiedEnt = false end -- If it's a door and it has no health, then don't attack it!
		if IsProp(v) or verifiedEnt then --If it's a prop or a entity then attack
			local phys = v:GetPhysicsObject()
			-- Serpevadz abrankner: self:VJ_GetNearestPointToEntityDistance(v) < (customMeleeDistance) && self:Visible(v)
			if IsValid(phys) && !propColBlacklist[v:GetCollisionGroup()] then
				local vPos = v:GetPos()
				local tr = util.TraceLine({
					start = myPos,
					endpos = vPos + v:GetUp()*10,
					filter = self
				})
				if (IsValid(tr.Entity) && !tr.HitWorld && !tr.HitSky) && (self:GetSightDirection():Dot((vPos - myPos):GetNormalized()) > math_cos(math_rad(self.MeleeAttackAngleRadius / 1.3))) then
					if verifiedEnt then return true end -- Since it's an entity, no need to check for size etc.
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
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MeleeAttackCode(isPropAttack, attackDist, customEnt)
	if self.Dead or self.vACT_StopAttacks or self.Flinching or (self.StopMeleeAttackAfterFirstHit && self.AttackState == VJ.ATTACK_STATE_EXECUTED_HIT) then return end
	isPropAttack = isPropAttack or self.MeleeAttack_DoingPropAttack -- Is this a prop attack?
	attackDist = attackDist or self.MeleeAttackDamageDistance -- How far should the attack go?
	local curEnemy = customEnt or self:GetEnemy()
	if self.MeleeAttackAnimationFaceEnemy && !isPropAttack then self:SetTurnTarget("Enemy") end
	//self.MeleeAttacking = true
	self:CustomOnMeleeAttack_BeforeChecks()
	if self.DisableDefaultMeleeAttackCode then return end
	local myPos = self:GetPos()
	local hitRegistered = false
	for _, v in ipairs(ents.FindInSphere(self:GetMeleeAttackDamageOrigin(), attackDist)) do
		if (self.VJ_IsBeingControlled && self.VJ_TheControllerBullseye == v) or (v:IsPlayer() && v.VJTag_IsControllingNPC == true) then continue end -- If controlled and v is the bullseye OR it's a player controlling then don't damage!
		if v != self && v:GetClass() != self:GetClass() && (((v:IsNPC() or (v:IsPlayer() && v:Alive() && !VJ_CVAR_IGNOREPLAYERS)) && self:Disposition(v) != D_LI) or IsProp(v) == true or v:GetClass() == "func_breakable_surf" or destructibleEnts[v:GetClass()] or v.VJTag_ID_Prop == true) && self:GetSightDirection():Dot((Vector(v:GetPos().x, v:GetPos().y, 0) - Vector(myPos.x, myPos.y, 0)):GetNormalized()) > math_cos(math_rad(self.MeleeAttackDamageAngleRadius)) then
			if isPropAttack == true && (v:IsPlayer() or v:IsNPC()) && self:VJ_GetNearestPointToEntityDistance(v) > self.MeleeAttackDistance then continue end //if (self:GetPos():Distance(v:GetPos()) <= self:VJ_GetNearestPointToEntityDistance(v) && self:VJ_GetNearestPointToEntityDistance(v) <= self.MeleeAttackDistance) == false then
			local vProp = IsProp(v)
			if self:CustomOnMeleeAttack_AfterChecks(v, vProp) == true then continue end
			-- Remove prop constraints and push it (If possible)
			if vProp then
				local phys = v:GetPhysicsObject()
				if IsValid(phys) && self:DoPropAPCheck({v}, attackDist) then
					hitRegistered = true
					phys:EnableMotion(true)
					//phys:EnableGravity(true)
					phys:Wake()
					//constraint.RemoveAll(v)
					//if util.IsValidPhysicsObject(v, 1) then
					constraint.RemoveConstraints(v, "Weld") //end
					if self.PushProps then
						phys:ApplyForceCenter((curEnemy != nil and curEnemy:GetPos() or myPos) + self:GetForward()*(phys:GetMass() * 700) + self:GetUp()*(phys:GetMass() * 200))
					end
				end
			end
			-- Knockback
			if self.HasMeleeAttackKnockBack && v.MovementType != VJ_MOVETYPE_STATIONARY && (!v.VJ_IsHugeMonster or v.IsVJBaseSNPC_Tank) then
				v:SetGroundEntity(NULL)
				-- !!!!!!!!!!!!!! DO NOT USE THESE !!!!!!!!!!!!!! [Backwards Compatibility!]
				if self.MeleeAttackKnockBack_Forward1 or self.MeleeAttackKnockBack_Forward2 or self.MeleeAttackKnockBack_Up1 or self.MeleeAttackKnockBack_Up2 then
					v:SetVelocity(self:GetForward()*math.random(self.MeleeAttackKnockBack_Forward1 or 100, self.MeleeAttackKnockBack_Forward2 or 100) + self:GetUp()*math.random(self.MeleeAttackKnockBack_Up1 or 10, self.MeleeAttackKnockBack_Up2 or 10) + self:GetRight()*math.random(self.MeleeAttackKnockBack_Right1 or 0, self.MeleeAttackKnockBack_Right2 or 0))
				else
				-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!
					v:SetVelocity(self:MeleeAttackKnockbackVelocity(v))
				end
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
				VJ.DamageSpecialEnts(self, v, applyDmg)
				v:TakeDamageInfo(applyDmg, self)
			end
			-- Bleed Enemy
			if self.MeleeAttackBleedEnemy == true && math.random(1, self.MeleeAttackBleedEnemyChance) == 1 && ((v:IsNPC() && (!VJ_IsHugeMonster)) or v:IsPlayer()) then
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
				v:ViewPunch(Angle(math.random(-1, 1) * self.MeleeAttackDamage, math.random(-1, 1) * self.MeleeAttackDamage, math.random(-1, 1) * self.MeleeAttackDamage))
				-- Slow Player
				if self.SlowPlayerOnMeleeAttack == true then
					self:VJ_DoSlowPlayer(v, self.SlowPlayerOnMeleeAttack_WalkSpeed, self.SlowPlayerOnMeleeAttack_RunSpeed, self.SlowPlayerOnMeleeAttackTime, {PlaySound=self.HasMeleeAttackSlowPlayerSound, SoundTable=self.SoundTbl_MeleeAttackSlowPlayer, SoundLevel=self.MeleeAttackSlowPlayerSoundLevel, FadeOutTime=self.MeleeAttackSlowPlayerSoundFadeOutTime})
				end
			end
			if !vProp then -- Only for non-props...
				hitRegistered = true
			end
		end
	end
	if self.AttackState < VJ.ATTACK_STATE_EXECUTED then
		self.AttackState = VJ.ATTACK_STATE_EXECUTED
		if self.TimeUntilMeleeAttackDamage != false then
			finishAttack[VJ.ATTACK_TYPE_MELEE](self)
		end
	end
	if hitRegistered == true then
		self:PlaySoundSystem("MeleeAttack")
		self.AttackState = VJ.ATTACK_STATE_EXECUTED_HIT
	else
		self:CustomOnMeleeAttack_Miss()
		-- !!!!!!!!!!!!!! DO NOT USE THESE !!!!!!!!!!!!!! [Backwards Compatibility!]
		if self.MeleeAttackWorldShakeOnMiss then util.ScreenShake(myPos, self.MeleeAttackWorldShakeOnMissAmplitude or 16, 100, self.MeleeAttackWorldShakeOnMissDuration or 1, self.MeleeAttackWorldShakeOnMissRadius or 2000) end
		-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!
		self:PlaySoundSystem("MeleeAttackMiss", {}, VJ.EmitSound)
	end
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
		local vEF_NoInterrupt = ExtraFeatures.NoInterrupt or false -- If set to true, the player's speed won't change by another instance of this code
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
		self.CurrentSlowPlayerSound = CreateSound(ent,VJ.PICK(vSD_SoundTable))
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
function ENT:RangeAttackCode()
	if self.Dead or self.vACT_StopAttacks or self.Flinching or self.AttackType == VJ.ATTACK_TYPE_MELEE then return end
	local ene = self:GetEnemy()
	if IsValid(ene) then
		self.AttackType = VJ.ATTACK_TYPE_RANGE
		self.RangeAttacking = true
		self:PlaySoundSystem("RangeAttack")
		if self.RangeAttackAnimationStopMovement == true then self:StopMoving() end
		if self.RangeAttackAnimationFaceEnemy == true then self:SetTurnTarget("Enemy") end
		//self:PointAtEntity(ene)
		self:CustomRangeAttackCode()
		-- Default projectile code
		if self.DisableDefaultRangeAttackCode == false then
			local projectile = ents.Create(VJ.PICK(self.RangeAttackEntityToSpawn))
			local spawnPosOverride = self:RangeAttackCode_OverrideProjectilePos(projectile)
			if spawnPosOverride == 0 then -- 0 = Let base decide
				if self.RangeUseAttachmentForPos == false then
					projectile:SetPos(self:GetPos() + self:GetUp()*self.RangeAttackPos_Up + self:GetForward()*self.RangeAttackPos_Forward + self:GetRight()*self.RangeAttackPos_Right)
				else
					projectile:SetPos(self:GetAttachment(self:LookupAttachment(self.RangeUseAttachmentForPosID)).Pos)
				end
			else -- Custom position
				projectile:SetPos(spawnPosOverride)
			end
			projectile:SetAngles((ene:GetPos() - projectile:GetPos()):Angle())
			self:CustomRangeAttackCode_BeforeProjectileSpawn(projectile)
			projectile:SetOwner(self)
			projectile:SetPhysicsAttacker(self)
			projectile:Spawn()
			projectile:Activate()
			//constraint.NoCollide(self, projectile, 0, 0)
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
	if self.AttackState < VJ.ATTACK_STATE_EXECUTED then
		self.AttackState = VJ.ATTACK_STATE_EXECUTED
		if self.TimeUntilRangeAttackProjectileRelease != false then
			finishAttack[VJ.ATTACK_TYPE_RANGE](self)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:LeapDamageCode()
	if self.Dead or self.vACT_StopAttacks or self.Flinching or (self.StopLeapAttackAfterFirstHit && self.AttackState == VJ.ATTACK_STATE_EXECUTED_HIT) then return end
	self:CustomOnLeapAttack_BeforeChecks()
	local hitRegistered = false
	for _,v in ipairs(ents.FindInSphere(self:GetPos(), self.LeapAttackDamageDistance)) do
		if (self.VJ_IsBeingControlled && self.VJ_TheControllerBullseye == v) or (v:IsPlayer() && v.VJTag_IsControllingNPC == true) then continue end
		if (v:IsNPC() or (v:IsPlayer() && v:Alive()) && !VJ_CVAR_IGNOREPLAYERS) && (self:Disposition(v) != D_LI) && (v != self) && (v:GetClass() != self:GetClass()) or IsProp(v) == true or v:GetClass() == "func_breakable_surf" or v:GetClass() == "func_breakable" then
			self:CustomOnLeapAttack_AfterChecks(v)
			-- Damage
			if self.DisableDefaultLeapAttackDamageCode == false then
				local leapdmg = DamageInfo()
				leapdmg:SetDamage(self:VJ_GetDifficultyValue(self.LeapAttackDamage))
				leapdmg:SetInflictor(self)
				leapdmg:SetDamageType(self.LeapAttackDamageType)
				leapdmg:SetAttacker(self)
				if v:IsNPC() or v:IsPlayer() then leapdmg:SetDamageForce(self:GetForward() * ((leapdmg:GetDamage() + 100) * 70)) end
				v:TakeDamageInfo(leapdmg, self)
			end
			if v:IsPlayer() then
				v:ViewPunch(Angle(math.random(-1,1 ) * self.LeapAttackDamage, math.random(-1, 1) * self.LeapAttackDamage,math.random(-1, 1) * self.LeapAttackDamage))
			end
			hitRegistered = true
		end
	end
	if self.AttackState < VJ.ATTACK_STATE_EXECUTED then
		self.AttackState = VJ.ATTACK_STATE_EXECUTED
		if self.TimeUntilLeapAttackDamage != false then
			finishAttack[VJ.ATTACK_TYPE_LEAP](self)
		end
	end
	if hitRegistered == true then
		self:PlaySoundSystem("LeapAttackDamage")
		self.AttackState = VJ.ATTACK_STATE_EXECUTED_HIT
	else
		self:CustomOnLeapAttack_Miss()
		self:PlaySoundSystem("LeapAttackDamageMiss", nil, VJ.EmitSound)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:LeapAttackVelocityCode()
	local ene = self:GetEnemy()
	if !IsValid(ene) then return end
	self:SetGroundEntity(NULL)
	if self.LeapAttackAnimationFaceEnemy == true then self:SetTurnTarget("Enemy") end
	self.LeapAttackHasJumped = true
	if self:CustomOnLeapAttackVelocityCode() != true then
		self:SetLocalVelocity(((ene:GetPos() + ene:OBBCenter()) - (self:GetPos() + self:OBBCenter())):GetNormal()*400 + self:GetForward()*self.LeapAttackVelocityForward + self:GetUp()*self.LeapAttackVelocityUp + self:GetRight()*self.LeapAttackVelocityRight)
	end 
	self:PlaySoundSystem("LeapAttackJump")
end
---------------------------------------------------------------------------------------------------------------------------------------------
local stopAtkTypes = {
	[VJ.ATTACK_TYPE_MELEE] = function(self) finishAttack[VJ.ATTACK_TYPE_MELEE](self, true) end,
	[VJ.ATTACK_TYPE_RANGE] = function(self) finishAttack[VJ.ATTACK_TYPE_RANGE](self, true) end,
	[VJ.ATTACK_TYPE_LEAP] = function(self) finishAttack[VJ.ATTACK_TYPE_LEAP](self, true) end
}
--
function ENT:StopAttacks(checkTimers)
	if self:Health() <= 0 then return end
	if self.VJ_DEBUG == true && GetConVar("vj_npc_printstoppedattacks"):GetInt() == 1 then print(self:GetClass().." Stopped all Attacks!") end
	
	if checkTimers == true && stopAtkTypes[self.AttackType] && self.AttackState < VJ.ATTACK_STATE_EXECUTED then
		stopAtkTypes[self.AttackType](self)
	end
	
	self.AttackType = VJ.ATTACK_TYPE_NONE
	self.AttackState = VJ.ATTACK_STATE_DONE
	self.CurAttackSeed = 0
	
	self.MeleeAttacking = false
	self.RangeAttacking = false
	self.LeapAttacking = false
	self.LeapAttackHasJumped = false

	self:DoChaseAnimation()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoPoseParameterLooking(resetPoses)
	if !self.HasPoseParameterLooking then return end
	//self:GetPoseParameters(true)
	local ene = self:GetEnemy()
	local newPitch = 0 -- Pitch
	local newYaw = 0 -- Yaw
	local newRoll = 0 -- Roll
	if IsValid(ene) && !resetPoses then
		local myEyePos = self:EyePos()
		local myAng = self:GetAngles()
		local enePos = self:GetAimPosition(ene, myEyePos)
		local eneAng = (enePos - myEyePos):Angle()
		newPitch = math_angDif(eneAng.p, myAng.p)
		if self.PoseParameterLooking_InvertPitch == true then newPitch = -newPitch end
		newYaw = math_angDif(eneAng.y, myAng.y)
		if self.PoseParameterLooking_InvertYaw == true then newYaw = -newYaw end
		newRoll = math_angDif(eneAng.z, myAng.z)
		if self.PoseParameterLooking_InvertRoll == true then newRoll = -newRoll end
	elseif !self.PoseParameterLooking_CanReset then -- Should it reset its pose parameters if there is no enemies?
		return
	end
	
	self:CustomOn_PoseParameterLookingCode(newPitch, newYaw, newRoll)
	
	local names = self.PoseParameterLooking_Names
	for x = 1, #names.pitch do
		self:SetPoseParameter(names.pitch[x], math_angApproach(self:GetPoseParameter(names.pitch[x]), newPitch, self.PoseParameterLooking_TurningSpeed))
	end
	for x = 1, #names.yaw do
		self:SetPoseParameter(names.yaw[x], math_angApproach(self:GetPoseParameter(names.yaw[x]), newYaw, self.PoseParameterLooking_TurningSpeed))
	end
	for x = 1, #names.roll do
		self:SetPoseParameter(names.roll[x], math_angApproach(self:GetPoseParameter(names.roll[x]), newRoll, self.PoseParameterLooking_TurningSpeed))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local schedMoveAway = vj_ai_schedule.New("vj_move_away")
	schedMoveAway:EngTask("TASK_MOVE_AWAY_PATH", 120)
	schedMoveAway:EngTask("TASK_RUN_PATH", 0)
	schedMoveAway:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
	schedMoveAway.IsMovingTask = true
	schedMoveAway.MoveType = 1
	schedMoveAway.CanShootWhenMoving = true
	schedMoveAway.FaceData = {} -- This is constantly edited!
--
function ENT:SelectSchedule()
	if self.VJ_IsBeingControlled or self.Dead then return end
	
	local eneValid = IsValid(self:GetEnemy())
	
	-- Handle move away behavior
	if self:HasCondition(COND_PLAYER_PUSHING) && CurTime() > self.TakingCoverT && !self:BusyWithActivity() then
		self:PlaySoundSystem("MoveOutOfPlayersWay")
		self:SetMovementActivity(VJ.PICK(self.AnimTbl_Run))
		if eneValid then -- Face current enemy
			schedMoveAway.FaceData.Type = VJ.NPC_FACE_ENEMY_VISIBLE
			schedMoveAway.FaceData.Target = nil
		elseif IsValid(self:GetTarget()) then -- Face current target
			schedMoveAway.FaceData.Type = VJ.NPC_FACE_ENTITY_VISIBLE
			schedMoveAway.FaceData.Target = self:GetTarget()
		else -- Reset if both others fail! (Remember this is a localized table shared between all NPCs!)
			schedMoveAway.FaceData.Type = nil
			schedMoveAway.FaceData.Target = nil
		end
		self:StartSchedule(schedMoveAway)
		self.TakingCoverT = CurTime() + 2
	end
	
	-- If the enemy is out of reach, then reset enemy!
	if eneValid && (self.LatestEnemyDistance > self:GetMaxLookDistance()) then
		self.TakingCoverT = 0
		self:DoIdleAnimation()
		self:ResetEnemy()
	-- Otherwise do default idle or combat behaviors
	else
		if eneValid then -- Chase the enemy
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
	if /*self.NextResetEnemyT > CurTime() or*/ self.Dead then self.EnemyData.Reset = false return false end
	checkAlliesEnemy = checkAlliesEnemy or false
	local moveToEnemy = false
	local ene = self:GetEnemy()
	local eneValid = IsValid(ene)
	if checkAlliesEnemy == true then
		local eneData = self.EnemyData
		local getAllies = self:Allies_Check(1000)
		if getAllies != false then
			for _, v in ipairs(getAllies) do
				local allyEne = v:GetEnemy()
				if IsValid(allyEne) && (CurTime() - v.EnemyData.LastVisibleTime) < self.TimeUntilEnemyLost && VJ.IsAlive(allyEne) && self:CheckRelationship(allyEne) == D_HT && self:GetPos():Distance(allyEne:GetPos()) <= self:GetMaxLookDistance() then
					self:VJ_DoSetEnemy(allyEne, false)
					eneData.Reset = false
					return false
				end
			end
		end
		local curEnemies = eneData.VisibleCount //self.CurrentReachableEnemies
		-- If the current number of reachable enemies is higher then 1, then don't reset
		if (eneValid && (curEnemies - 1) >= 1) or (!eneValid && curEnemies >= 1) then
			//self:VJ_DoSetEnemy(v, false, true)
			self:MaintainRelationships() -- Select a new enemy
			self.NextProcessT = CurTime() + self.NextProcessTime
			eneData.Reset = false
			return false
		end
	end
	
	self:SetNPCState(NPC_STATE_ALERT)
	timer.Create("timer_alerted_reset"..self:EntIndex(), math.Rand(self.AlertedToIdleTime.a, self.AlertedToIdleTime.b), 1, function() if !IsValid(self:GetEnemy()) then self.Alerted = false self:SetNPCState(NPC_STATE_IDLE) end end)
	self:CustomOnResetEnemy()
	if self.VJ_DEBUG == true && GetConVar("vj_npc_printresetenemy"):GetInt() == 1 then print(self:GetName().." has reseted its enemy") end
	if eneValid then
		if self.IsFollowing == false && (!self.IsVJBaseSNPC_Tank) && !self:Visible(ene) && self:GetEnemyLastKnownPos() != defPos then
			self:SetLastPosition(self:GetEnemyLastKnownPos())
			moveToEnemy = true
		end
		self:MarkEnemyAsEluded(ene)
		//self:ClearEnemyMemory(ene) // Completely resets the enemy memory
		self:AddEntityRelationship(ene, D_NU, 10)
	end
	
	-- Clear memory of the enemy if it's not a player AND it's dead
	if eneValid && !ene:IsPlayer() && !VJ.IsAlive(ene) then
		//print("Clear memory", ene)
		self:ClearEnemyMemory(ene)
	end
	//self:UpdateEnemyMemory(self,self:GetPos())
	//local schedResetEnemy = vj_ai_schedule.New("vj_act_resetenemy")
	//if eneValid then schedResetEnemy:EngTask("TASK_FORGET", ene) end
	//schedResetEnemy:EngTask("TASK_IGNORE_OLD_ENEMIES", 0)
	self.NextWanderTime = CurTime() + math.Rand(3, 5)
	if moveToEnemy && !self:IsBusy() && !self.IsGuard && self.Behavior != VJ_BEHAVIOR_PASSIVE && self.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE && self.VJ_IsBeingControlled == false && self.LastHiddenZone_CanWander == true then
		//ParticleEffect("explosion_turret_break", self.LatestEnemyPosition, Angle(0,0,0))
		self:SetMovementActivity(VJ.PICK(self.AnimTbl_Walk))
		local schedResetEnemy = vj_ai_schedule.New("vj_act_resetenemy")
		schedResetEnemy:EngTask("TASK_GET_PATH_TO_LASTPOSITION", 0)
		//schedResetEnemy:EngTask("TASK_WALK_PATH", 0)
		schedResetEnemy:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
		schedResetEnemy.ResetOnFail = true
		schedResetEnemy.CanShootWhenMoving = true
		schedResetEnemy.FaceData = {Type = VJ.NPC_FACE_ENEMY}
		schedResetEnemy.CanBeInterrupted = true
		schedResetEnemy.IsMovingTask = true
		schedResetEnemy.MoveType = 0
		//self.NextIdleTime = CurTime() + 10
		self:StartSchedule(schedResetEnemy)
	end
	//if schedResetEnemy.TaskCount > 0 then
		//self:StartSchedule(schedResetEnemy)
	//end
	self:SetEnemy(NULL)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage(dmginfo)
	local dmgInflictor = dmginfo:GetInflictor()
	local hitgroup = self:GetLastDamageHitGroup()
	if IsValid(dmgInflictor) && dmgInflictor:GetClass() == "prop_ragdoll" && dmgInflictor:GetVelocity():Length() <= 100 then return 0 end -- Avoid taking damage when walking on ragdolls
	self:CustomOnTakeDamage_BeforeImmuneChecks(dmginfo, hitgroup)
	if self.GodMode or dmginfo:GetDamage() <= 0 then return 0 end
	if self:IsOnFire() && self:WaterLevel() == 2 then self:Extinguish() end -- If we are in water, then extinguish the fire
	local dmgAttacker = dmginfo:GetAttacker()
	local dmgType = dmginfo:GetDamageType()
	local curTime = CurTime()
	local isFireDmg = self:IsOnFire() && IsValid(dmgInflictor) && IsValid(dmgAttacker) && dmgInflictor:GetClass() == "entityflame" && dmgAttacker:GetClass() == "entityflame"
	
	-- If it should always take damage from huge monsters, then skip immunity checks!
	if self.GetDamageFromIsHugeMonster && dmgAttacker.VJ_IsHugeMonster then
		goto skip_immunity
	end
	if VJ.HasValue(self.ImmuneDamagesTable, dmgType) then return 0 end
	if self.AllowIgnition == false && isFireDmg then self:Extinguish() return 0 end
	if self.Immune_Fire == true && (dmgType == DMG_BURN or dmgType == DMG_SLOWBURN or isFireDmg) then return 0 end
	if (self.Immune_AcidPoisonRadiation == true && (dmgType == DMG_ACID or dmgType == DMG_RADIATION or dmgType == DMG_POISON or dmgType == DMG_NERVEGAS or dmgType == DMG_PARALYZE)) or (self.Immune_Bullet == true && (dmginfo:IsBulletDamage() or dmgType == DMG_BULLET or dmgType == DMG_AIRBOAT or dmgType == DMG_BUCKSHOT)) or (self.Immune_Blast == true && (dmgType == DMG_BLAST or dmgType == DMG_BLAST_SURFACE)) or (self.Immune_Dissolve == true && dmgType == DMG_DISSOLVE) or (self.Immune_Electricity == true && (dmgType == DMG_SHOCK or dmgType == DMG_ENERGYBEAM or dmgType == DMG_PHYSGUN)) or (self.Immune_Melee == true && (dmgType == DMG_CLUB or dmgType == DMG_SLASH)) or (self.Immune_Sonic == true && dmgType == DMG_SONIC) then return 0 end
	if (IsValid(dmgInflictor) && dmgInflictor:GetClass() == "prop_combine_ball") or (IsValid(dmgAttacker) && dmgAttacker:GetClass() == "prop_combine_ball") then
		if self.Immune_Dissolve == true then return 0 end
		-- Make sure combine ball does reasonable damage and doesn't spam it!
		if curTime > self.NextCanGetCombineBallDamageT then
			dmginfo:SetDamage(math.random(400, 500))
			dmginfo:SetDamageType(DMG_DISSOLVE)
			self.NextCanGetCombineBallDamageT = curTime + 0.2
		else
			return 0
		end
	end

	::skip_immunity::
	local function DoBleed()
		if self.Bleeds == true then
			self:CustomOnTakeDamage_OnBleed(dmginfo, hitgroup)
			-- Spawn the blood particle only if it's not caused by the default fire entity [Causes the damage position to be at Vector(0, 0, 0)]
			if self.HasBloodParticle == true && !isFireDmg then self:SpawnBloodParticles(dmginfo, hitgroup) end
			if self.HasBloodDecal == true then self:SpawnBloodDecal(dmginfo, hitgroup) end
			self:PlaySoundSystem("Impact", nil, VJ.EmitSound)
		end
	end
	if self.Dead then DoBleed() return 0 end -- If dead then just bleed but take no damage
	
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
	if self.VJ_DEBUG == true && GetConVar("vj_npc_printondamage"):GetInt() == 1 then print(self:GetClass().." Got Damaged! | Amount = "..dmginfo:GetDamage()) end
	if self.HasHealthRegeneration == true && self.HealthRegenerationResetOnDmg == true then
		self.HealthRegenerationDelayT = curTime + (math.Rand(self.HealthRegenerationDelay.a, self.HealthRegenerationDelay.b) * 1.5)
	end
	self:SetSaveValue("m_iDamageCount", self:GetSaveTable().m_iDamageCount + 1)
	self:SetSaveValue("m_flLastDamageTime", curTime)
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
		-- Make passive NPCs move away | RESULT: May move away AND may cause other passive NPCs to move as well
		if (self.Behavior == VJ_BEHAVIOR_PASSIVE or self.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE) && curTime > self.TakingCoverT then
			if stillAlive && self.Passive_RunOnDamage then
				self:VJ_TASK_COVER_FROM_ORIGIN("TASK_RUN_PATH")
			end
			if self.Passive_AlliesRunOnDamage then -- Make passive allies run too!
				local allies = self:Allies_Check(self.Passive_AlliesRunOnDamageDistance)
				if allies != false then
					for _, v in ipairs(allies) do
						v.TakingCoverT = curTime + math.Rand(v.Passive_NextRunOnDamageTime.b, v.Passive_NextRunOnDamageTime.a)
						v:VJ_TASK_COVER_FROM_ORIGIN("TASK_RUN_PATH")
						v:PlaySoundSystem("Alert")
					end
				end
			end
			self.TakingCoverT = curTime + math.Rand(self.Passive_NextRunOnDamageTime.a, self.Passive_NextRunOnDamageTime.b)
		end

		if stillAlive then
			self:DoFlinch(dmginfo, hitgroup)
			
			-- React to damage by a player
				-- 0 = Run it every time | 1 = Run it only when friendly to player | 2 = Run it only when enemy to player
			if self.HasDamageByPlayerSounds && dmgAttacker:IsPlayer() && curTime > self.NextDamageByPlayerSoundT && self:Visible(dmgAttacker) then
				local dispLvl = self.DamageByPlayerDispositionLevel
				if (dispLvl == 0 or (dispLvl == 1 && self:Disposition(dmgAttacker) == D_LI) or (dispLvl == 2 && self:Disposition(dmgAttacker) != D_HT)) then
					self:PlaySoundSystem("DamageByPlayer")
				end
			end
			
			self:PlaySoundSystem("Pain")

			-- Call for back on damage | RESULT: May play an animation OR it may move away, AND it may bring allies to its location
			if self.CallForBackUpOnDamage && curTime > self.NextCallForBackUpOnDamageT && !IsValid(self:GetEnemy()) && self.IsFollowing == false && self.Behavior != VJ_BEHAVIOR_PASSIVE && self.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE && !isFireDmg then
				local allies = self:Allies_Check(self.CallForBackUpOnDamageDistance)
				if allies != false then
					self:Allies_Bring("Random", self.CallForBackUpOnDamageDistance, allies, self.CallForBackUpOnDamageLimit)
					self:ClearSchedule()
					self.NextFlinchT = curTime + 1
					local chosenAnim = VJ.PICK(self.CallForBackUpOnDamageAnimation)
					local playedAnim = !self.DisableCallForBackUpOnDamageAnimation and self:VJ_ACT_PLAYACTIVITY(chosenAnim, true, self:DecideAnimationLength(chosenAnim, self.CallForBackUpOnDamageAnimationTime), true, 0, {PlayBackRateCalculated=true}) or 0
					if playedAnim == 0 && !self:BusyWithActivity() then
						self:VJ_TASK_COVER_FROM_ORIGIN("TASK_RUN_PATH", function(x) x.CanShootWhenMoving = true x.FaceData = {Type = VJ.NPC_FACE_ENEMY} end)
					end
					self.NextCallForBackUpOnDamageT = curTime + math.Rand(self.NextCallForBackUpOnDamageTime.a, self.NextCallForBackUpOnDamageTime.b)
				end
			end

			-- Become enemy to a friendly player | RESULT: May become alerted
			if self.BecomeEnemyToPlayer == true && self.VJ_IsBeingControlled == false && dmgAttacker:IsPlayer() && self:CheckRelationship(dmgAttacker) == D_LI then
				self.AngerLevelTowardsPlayer = self.AngerLevelTowardsPlayer + 1
				if self.AngerLevelTowardsPlayer > self.BecomeEnemyToPlayerLevel then
					if self:Disposition(dmgAttacker) != D_HT then
						self:CustomOnBecomeEnemyToPlayer(dmginfo, hitgroup)
						if self.IsFollowing == true && self.FollowData.Ent == dmgAttacker then self:FollowReset() end
						self.VJ_AddCertainEntityAsEnemy[#self.VJ_AddCertainEntityAsEnemy + 1] = dmgAttacker
						self:AddEntityRelationship(dmgAttacker, D_HT, 2)
						self.TakingCoverT = curTime + 2
						self:PlaySoundSystem("BecomeEnemyToPlayer")
						if !IsValid(self:GetEnemy()) then
							self:StopMoving()
							self:SetTarget(dmgAttacker)
							self:VJ_TASK_FACE_X("TASK_FACE_TARGET")
						end
						if self.AllowPrintingInChat == true then
							dmgAttacker:PrintMessage(HUD_PRINTTALK, self:GetName().." no longer likes you.")
						end
					end
					self.Alerted = true
					self:SetNPCState(NPC_STATE_ALERT)
				end
			end

			-- Attempt to find who damaged me | RESULT: May become alerted if enemy is visible OR it may move away
			if !self.DisableTakeDamageFindEnemy && !self:BusyWithActivity() && !IsValid(self:GetEnemy()) && curTime > self.TakingCoverT && self.VJ_IsBeingControlled == false && self.Behavior != VJ_BEHAVIOR_PASSIVE && self.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE then // self.Alerted == false
				local eneFound = false
				local sightDist = self:GetMaxLookDistance()
				sightDist = math_clamp(sightDist / 2, sightDist <= 1000 and sightDist or 1000, sightDist)
				-- IF normal sight dist is less than 1000 then change nothing, OR ELSE use half the distance with 1000 as minimum
				for _, v in ipairs(ents.FindInSphere(self:GetPos(), sightDist)) do
					if (curTime - self.EnemyData.TimeSet) > 2 && self:Visible(v) && self:CheckRelationship(v) == D_HT then
						self:CustomOnSetEnemyOnDamage(dmginfo, hitgroup)
						self.NextCallForHelpT = curTime + 1
						self:VJ_DoSetEnemy(v, true)
						self:DoChaseAnimation()
						eneFound = true
						break
					end
				end
				if !eneFound && self.HideOnUnknownDamage && !self.IsFollowing && self.MovementType != VJ_MOVETYPE_STATIONARY then
					self:VJ_TASK_COVER_FROM_ORIGIN("TASK_RUN_PATH", function(x) x.CanShootWhenMoving = true x.FaceData = {Type = VJ.NPC_FACE_ENEMY} end)
					self.TakingCoverT = curTime + self.HideOnUnknownDamage
				end
			end
			
			-- Test that makes crossbow bolts stick to the NPC's model
			/*if dmgInflictor:GetClass() == "crossbow_bolt" then
				local mdlBolt = ents.Create("prop_dynamic_override")
				mdlBolt:SetPos(dmginfo:GetDamagePosition())
				mdlBolt:SetAngles(dmgAttacker:GetAngles())
				mdlBolt:SetModel("models/crossbow_bolt.mdl")
				mdlBolt:SetParent(self)
				mdlBolt:Spawn()
				mdlBolt:Activate()
			end*/
		end
	end
	
	-- If eating, stop!
	if self.CanEat && self.VJTag_IsEating then
		self.EatingData.NextCheck = curTime + 15
		self:EatingReset("Injured")
	end
	
	if self:Health() <= 0 && !self.Dead then
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
	if self.Medic_Status then self:DoMedicReset() end
	local dmgInflictor = dmginfo:GetInflictor()
	local dmgAttacker = dmginfo:GetAttacker()
	
	local allies = self:Allies_Check(math.max(800, self.BringFriendsOnDeathDistance, self.AlertFriendsOnDeathDistance))
	if allies != false then
		local noAlert = true -- Don't run the AlertFriendsOnDeath if we have BringFriendsOnDeath enabled!
		if self.BringFriendsOnDeath == true then
			self:Allies_Bring("Random", self.BringFriendsOnDeathDistance, allies, self.BringFriendsOnDeathLimit, true)
			noAlert = false
		end
		local doBecomeEnemyToPlayer = (self.BecomeEnemyToPlayer == true && dmgAttacker:IsPlayer() && GetConVar("ai_disabled"):GetInt() == 0 && !VJ_CVAR_IGNOREPLAYERS) or false
		local it = 0 -- Number of allies that have been alerted
		for _, v in ipairs(allies) do
			v:CustomOnAllyDeath(self)
			v:PlaySoundSystem("AllyDeath")
			
			-- AlertFriendsOnDeath
			if noAlert == true && self.AlertFriendsOnDeath == true && !IsValid(v:GetEnemy()) && v.AlertFriendsOnDeath == true && it != self.AlertFriendsOnDeathLimit && self:GetPos():Distance(v:GetPos()) < self.AlertFriendsOnDeathDistance then
				it = it + 1
				local faceTime = math.Rand(5, 8)
				v:SetTurnTarget(self:GetPos(), faceTime, true)
				v:VJ_ACT_PLAYACTIVITY(VJ.PICK(v.AnimTbl_AlertFriendsOnDeath))
				v.NextIdleTime = CurTime() + faceTime
			end
			
			-- BecomeEnemyToPlayer
			if doBecomeEnemyToPlayer && v.BecomeEnemyToPlayer == true && v:Disposition(dmgAttacker) == D_LI then
				v.AngerLevelTowardsPlayer = v.AngerLevelTowardsPlayer + 1
				if v.AngerLevelTowardsPlayer > v.BecomeEnemyToPlayerLevel then
					if v:Disposition(dmgAttacker) != D_HT then
						v:CustomOnBecomeEnemyToPlayer(dmginfo, hitgroup)
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
		local bloodDecal = VJ.PICK(self.CustomBlood_Decal)
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
	self.AttackType = VJ.ATTACK_TYPE_NONE
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
	//if (self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC) then self:AA_StopMoving() end
	
	-- I/O events, from: https://github.com/ValveSoftware/source-sdk-2013/blob/0d8dceea4310fde5706b3ce1c70609d72a38efdf/mp/src/game/server/basecombatcharacter.cpp#L1582
	if IsValid(dmgAttacker) then -- Someone else killed me
		self:TriggerOutput("OnDeath", dmgAttacker)
		dmgAttacker:Fire("KilledNPC", "", 0, self, self) -- Allows player companions (npc_citizen) to respond to kill
	else
		self:TriggerOutput("OnDeath", self)
	end
	
	if self.HasDeathAnimation == true && !dmginfo:IsDamageType(DMG_REMOVENORAGDOLL) && self:GetNavType() != NAV_CLIMB then
		if IsValid(dmgInflictor) && dmgInflictor:GetClass() == "prop_combine_ball" then DoKilled() return end
		if GetConVar("vj_npc_nodeathanimation"):GetInt() == 0 && GetConVar("ai_disabled"):GetInt() == 0 && !dmginfo:IsDamageType(DMG_DISSOLVE) && math.random(1, self.DeathAnimationChance) == 1 then
			self:RemoveAllGestures()
			self:CustomDeathAnimationCode(dmginfo, hitgroup)
			local chosenAnim = VJ.PICK(self.AnimTbl_Death)
			local animTime = self:DecideAnimationLength(chosenAnim, self.DeathAnimationTime) - self.DeathAnimationDecreaseLengthAmount
			self:VJ_ACT_PLAYACTIVITY(chosenAnim, true, animTime, false, 0, {PlayBackRateCalculated=true})
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
	if self.VJ_DEBUG == true && GetConVar("vj_npc_printdied"):GetInt() == 1 then print(self:GetClass().." Died!") end
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
		local corpseMdlCustom = VJ.PICK(self.DeathCorpseModel)
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
		self.Corpse = ents.Create(corpseType)
		local corpse = self.Corpse
		corpse:SetModel(corpseMdl)
		corpse:SetPos(self:GetPos())
		corpse:SetAngles(self:GetAngles())
		corpse:Spawn()
		corpse:Activate()
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
		corpse.BloodData = {Color = self.BloodColor, Particle = self.CustomBlood_Particle, Decal = self.CustomBlood_Decal}

		if self.Bleeds == true && self.HasBloodPool == true && GetConVar("vj_npc_nobloodpool"):GetInt() == 0 then
			self:SpawnBloodPool(dmginfo, hitgroup)
		end
		
		-- Collision --
		corpse:SetCollisionGroup(self.DeathCorpseCollisionType)
		if GetConVar("ai_serverragdolls"):GetInt() == 1 then
			undo.ReplaceEntity(self, corpse)
		else -- Keep corpses is not enabled...
			VJ.Corpse_Add(corpse)
			//hook.Call("VJ_CreateSNPCCorpse", nil, corpse, self)
			if GetConVar("vj_npc_undocorpse"):GetInt() == 1 then undo.ReplaceEntity(self, corpse) end -- Undoable
		end
		cleanup.ReplaceEntity(self, corpse) -- Delete on cleanup
		
		-- Miscellaneous --
		corpse:SetSkin((self.DeathCorpseSkin == -1 and self:GetSkin()) or self.DeathCorpseSkin)
		
		if self.DeathCorpseSetBodyGroup == true then -- Yete asega true-e, ooremen gerna bodygroup tenel
			for i = 0, self:GetNumBodyGroups() do
				corpse:SetBodygroup(i, self:GetBodygroup(i))
			end
			if self.DeathCorpseBodyGroup.a != -1 then -- Yete asiga nevaz meg chene, user-in teradz tevere kordzadze
				corpse:SetBodygroup(self.DeathCorpseBodyGroup.a, self.DeathCorpseBodyGroup.b)
			end
		end
		
		if self:IsOnFire() then -- If was on fire then...
			corpse:Ignite(math.Rand(8, 10), 0)
			corpse:SetColor(colorGrey)
			//corpse:SetMaterial("models/props_foliage/tree_deciduous_01a_trunk")
		end
		//gamemode.Call("CreateEntityRagdoll",self,corpse)
		
		-- Dissolve --
		if (bit.band(self.SavedDmgInfo.type, DMG_DISSOLVE) != 0) or (IsValid(self.SavedDmgInfo.inflictor) && self.SavedDmgInfo.inflictor:GetClass() == "prop_combine_ball") then
			corpse:SetName("vj_dissolve_corpse")
			local dissolver = ents.Create("env_entity_dissolver")
			dissolver:SetPos(corpse:GetPos())
			dissolver:Spawn()
			dissolver:Activate()
			//dissolver:SetKeyValue("target","vj_dissolve_corpse")
			dissolver:SetKeyValue("magnitude",100)
			dissolver:SetKeyValue("dissolvetype",0)
			dissolver:Fire("Dissolve","vj_dissolve_corpse")
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
		local physCount = corpse:GetPhysicsObjectCount()
		for boneLimit = 0, physCount - 1 do -- 128 = Bone Limit
			local childPhysObj = corpse:GetPhysicsObjectNum(boneLimit)
			if IsValid(childPhysObj) then
				totalSurface = totalSurface + childPhysObj:GetSurfaceArea()
				local childPhysObj_BonePos, childPhysObj_BoneAng = self:GetBonePosition(corpse:TranslatePhysBoneToBone(boneLimit))
				if (childPhysObj_BonePos) then
					//if math.Round(math.abs(childPhysObj_BoneAng.r)) != 90 then -- Fixes ragdolls rotating, no longer needed!    --->    sv_pvsskipanimation 0
						if self.DeathCorpseSetBoneAngles == true then childPhysObj:SetAngles(childPhysObj_BoneAng) end
						childPhysObj:SetPos(childPhysObj_BonePos)
					//end
					if corpse:GetName() == "vj_dissolve_corpse" then
						childPhysObj:EnableGravity(false)
						childPhysObj:SetVelocity(self:GetForward()*-150 + self:GetRight()*math.Rand(100,-100) + self:GetUp()*50)
					else
						if self.DeathCorpseApplyForce == true /*&& self.DeathAnimationCodeRan == false*/ then
							childPhysObj:SetVelocity(dmgForce / math.max(1, (useLocalVel and childPhysObj_BonePos:Distance(self.SavedDmgInfo.pos)/12) or 1))
						end
					end
				elseif physCount == 1 then -- If it's only 1, then it's likely a regular physics model with no bones
					if corpse:GetName() == "vj_dissolve_corpse" then
						childPhysObj:EnableGravity(false)
						childPhysObj:SetVelocity(self:GetForward()*-150 + self:GetRight()*math.Rand(100,-100) + self:GetUp()*50)
					else
						if self.DeathCorpseApplyForce == true /*&& self.DeathAnimationCodeRan == false*/ then
							childPhysObj:SetVelocity(dmgForce / math.max(1, (useLocalVel and corpse:GetPos():Distance(self.SavedDmgInfo.pos)/12) or 1))
						end
					end
				end
			end
		end
		
		if corpse:Health() <= 0 then
			local hpCalc = totalSurface / 60 // corpse:OBBMaxs():Distance(corpse:OBBMins())
			corpse:SetMaxHealth(hpCalc)
			corpse:SetHealth(hpCalc)
		end
		VJ.Corpse_AddStinky(corpse, true)
		
		if self.DeathCorpseFade == true then corpse:Fire(corpse.FadeCorpseType, "", self.DeathCorpseFadeTime) end
		if GetConVar("vj_npc_corpsefade"):GetInt() == 1 then corpse:Fire(corpse.FadeCorpseType, "", GetConVar("vj_npc_corpsefadetime"):GetInt()) end
		self:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpse)
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
		-- Remove child entities | No fade effects as it will look weird, remove it instantly!
		if self.DeathCorpse_ChildEnts then
			for _, v in ipairs(self.DeathCorpse_ChildEnts) do
				v:Remove()
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PlaySoundSystem(sdSet, customSd, sdType)
	if self.HasSounds == false or sdSet == nil then return end
	sdType = sdType or VJ.CreateSound
	local customTbl = VJ.PICK(customSd)
	
	if sdSet == "GeneralSpeech" then -- Used to just play general speech sounds (Custom by developers)
		if customTbl then
			self:StopAllCommonSpeechSounds()
			self.NextIdleSoundT_RegularChange = CurTime() + ((((SoundDuration(customTbl) > 0) and SoundDuration(customTbl)) or 2) + 1)
			self.CurrentGeneralSpeechSound = sdType(self, customTbl, 80, self:VJ_DecideSoundPitch(self.GeneralSoundPitch1, self.GeneralSoundPitch2))
		end
		return
	elseif sdSet == "FollowPlayer" then
		if self.HasFollowPlayerSounds_Follow == true then
			local sdtbl = VJ.PICK(self.SoundTbl_FollowPlayer)
			if (math.random(1, self.FollowPlayerSoundChance) == 1 && sdtbl) or customTbl then
				if customTbl then sdtbl = customTbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(3, 4)
				self.CurrentFollowPlayerSound = sdType(self, sdtbl, self.FollowPlayerSoundLevel, self:VJ_DecideSoundPitch(self.FollowPlayerPitch.a, self.FollowPlayerPitch.b))
			end
		end
		return
	elseif sdSet == "UnFollowPlayer" then
		if self.HasFollowPlayerSounds_UnFollow == true then
			local sdtbl = VJ.PICK(self.SoundTbl_UnFollowPlayer)
			if (math.random(1, self.UnFollowPlayerSoundChance) == 1 && sdtbl) or customTbl then
				if customTbl then sdtbl = customTbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(3, 4)
				self.CurrentUnFollowPlayerSound = sdType(self, sdtbl, self.UnFollowPlayerSoundLevel, self:VJ_DecideSoundPitch(self.UnFollowPlayerPitch.a, self.UnFollowPlayerPitch.b))
			end
		end
		return
	elseif sdSet == "OnReceiveOrder" then
		if self.HasOnReceiveOrderSounds == true then
			local sdtbl = VJ.PICK(self.SoundTbl_OnReceiveOrder)
			if (math.random(1, self.OnReceiveOrderSoundChance) == 1 && sdtbl) or customTbl then
				if customTbl then sdtbl = customTbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT = self.NextIdleSoundT + 2
				self.NextAlertSoundT = CurTime() + 2
				self.CurrentOnReceiveOrderSound = sdType(self, sdtbl, self.OnReceiveOrderSoundLevel, self:VJ_DecideSoundPitch(self.OnReceiveOrderSoundPitch.a, self.OnReceiveOrderSoundPitch.b))
			end
		end
		return
	elseif sdSet == "MoveOutOfPlayersWay" then
		if self.HasMoveOutOfPlayersWaySounds == true then
			local sdtbl = VJ.PICK(self.SoundTbl_MoveOutOfPlayersWay)
			if (math.random(1, self.MoveOutOfPlayersWaySoundChance) == 1 && sdtbl) or customTbl then
				if customTbl then sdtbl = customTbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(3, 4)
				self.CurrentMoveOutOfPlayersWaySound = sdType(self, sdtbl, self.MoveOutOfPlayersWaySoundLevel, self:VJ_DecideSoundPitch(self.MoveOutOfPlayersWaySoundPitch.a, self.MoveOutOfPlayersWaySoundPitch.b))
			end
		end
		return
	elseif sdSet == "MedicBeforeHeal" then
		if self.HasMedicSounds_BeforeHeal == true then
			local sdtbl = VJ.PICK(self.SoundTbl_MedicBeforeHeal)
			if (math.random(1, self.MedicBeforeHealSoundChance) == 1 && sdtbl) or customTbl then
				if customTbl then sdtbl = customTbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(3, 4)
				self.CurrentMedicBeforeHealSound = sdType(self, sdtbl, self.BeforeHealSoundLevel, self:VJ_DecideSoundPitch(self.BeforeHealSoundPitch.a, self.BeforeHealSoundPitch.b))
			end
		end
		return
	elseif sdSet == "MedicOnHeal" then
		if self.HasMedicSounds_AfterHeal == true then
			local sdtbl = VJ.PICK(self.SoundTbl_MedicAfterHeal)
			if sdtbl == false then sdtbl = VJ.PICK(DefaultSoundTbl_MedicAfterHeal) end -- Default table
			if (math.random(1, self.MedicAfterHealSoundChance) == 1 && sdtbl) or customTbl then
				if customTbl then sdtbl = customTbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(3, 4)
				self.CurrentMedicAfterHealSound = sdType(self, sdtbl, self.AfterHealSoundLevel, self:VJ_DecideSoundPitch(self.AfterHealSoundPitch.a, self.AfterHealSoundPitch.b))
			end
		end
		return
	elseif sdSet == "MedicReceiveHeal" then
		if self.HasMedicSounds_ReceiveHeal == true then
			local sdtbl = VJ.PICK(self.SoundTbl_MedicReceiveHeal)
			if (math.random(1, self.MedicReceiveHealSoundChance) == 1 && sdtbl) or customTbl then
				if customTbl then sdtbl = customTbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(3, 4)
				self.CurrentMedicReceiveHealSound = sdType(self, sdtbl, self.MedicReceiveHealSoundLevel, self:VJ_DecideSoundPitch(self.MedicReceiveHealSoundPitch.a, self.MedicReceiveHealSoundPitch.b))
			end
		end
		return
	elseif sdSet == "OnPlayerSight" then
		if self.HasOnPlayerSightSounds == true then
			local sdtbl = VJ.PICK(self.SoundTbl_OnPlayerSight)
			if (math.random(1, self.OnPlayerSightSoundChance) == 1 && sdtbl) or customTbl then
				if customTbl then sdtbl = customTbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(3, 4)
				self.NextAlertSoundT = CurTime() + math.random(1,2)
				self.CurrentOnPlayerSightSound = sdType(self, sdtbl, self.OnPlayerSightSoundLevel, self:VJ_DecideSoundPitch(self.OnPlayerSightSoundPitch.a, self.OnPlayerSightSoundPitch.b))
			end
		end
		return
	elseif sdSet == "InvestigateSound" then
		if self.HasInvestigateSounds == true && CurTime() > self.NextInvestigateSoundT then
			local sdtbl = VJ.PICK(self.SoundTbl_Investigate)
			if (math.random(1, self.InvestigateSoundChance) == 1 && sdtbl) or customTbl then
				if customTbl then sdtbl = customTbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT = self.NextIdleSoundT + 2
				self.CurrentInvestigateSound = sdType(self, sdtbl, self.InvestigateSoundLevel, self:VJ_DecideSoundPitch(self.InvestigateSoundPitch.a, self.InvestigateSoundPitch.b))
			end
			self.NextInvestigateSoundT = CurTime() + math.Rand(self.NextSoundTime_Investigate.a, self.NextSoundTime_Investigate.b)
		end
		return
	elseif sdSet == "LostEnemy" then
		if self.HasLostEnemySounds == true && CurTime() > self.LostEnemySoundT then
			local sdtbl = VJ.PICK(self.SoundTbl_LostEnemy)
			if (math.random(1, self.LostEnemySoundChance) == 1 && sdtbl) or customTbl then
				if customTbl then sdtbl = customTbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT = self.NextIdleSoundT + 2
				self.CurrentLostEnemySound = sdType(self, sdtbl, self.LostEnemySoundLevel, self:VJ_DecideSoundPitch(self.LostEnemySoundPitch.a, self.LostEnemySoundPitch.b))
			end
			self.LostEnemySoundT = CurTime() + math.Rand(self.NextSoundTime_LostEnemy.a, self.NextSoundTime_LostEnemy.b)
		end
		return
	elseif sdSet == "Alert" then
		if self.HasAlertSounds == true then
			local sdtbl = VJ.PICK(self.SoundTbl_Alert)
			if (math.random(1, self.AlertSoundChance) == 1 && sdtbl) or customTbl then
				if customTbl then sdtbl = customTbl end
				self:StopAllCommonSpeechSounds()
				local dur = CurTime() + ((((SoundDuration(sdtbl) > 0) and SoundDuration(sdtbl)) or 2) + 1)
				self.NextIdleSoundT = dur
				self.PainSoundT = dur
				self.NextAlertSoundT = CurTime() + math.Rand(self.NextSoundTime_Alert.a, self.NextSoundTime_Alert.b)
				self.CurrentAlertSound = sdType(self, sdtbl, self.AlertSoundLevel, self:VJ_DecideSoundPitch(self.AlertSoundPitch.a, self.AlertSoundPitch.b))
			end
		end
		return
	elseif sdSet == "CallForHelp" then
		if self.HasCallForHelpSounds == true && CurTime() > self.NextCallForHelpSoundT then
			local sdtbl = VJ.PICK(self.SoundTbl_CallForHelp)
			if (math.random(1, self.CallForHelpSoundChance) == 1 && sdtbl) or customTbl then
				if customTbl then sdtbl = customTbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT = self.NextIdleSoundT + 2
				self.CurrentCallForHelpSound = sdType(self, sdtbl, self.CallForHelpSoundLevel, self:VJ_DecideSoundPitch(self.CallForHelpSoundPitch.a, self.CallForHelpSoundPitch.b))
				self.NextCallForHelpSoundT = CurTime() + 2
			end
		end
		return
	elseif sdSet == "BecomeEnemyToPlayer" then
		if self.HasBecomeEnemyToPlayerSounds == true then
			local sdtbl = VJ.PICK(self.SoundTbl_BecomeEnemyToPlayer)
			if (math.random(1, self.BecomeEnemyToPlayerChance) == 1 && sdtbl) or customTbl then
				if customTbl then sdtbl = customTbl end
				self:StopAllCommonSpeechSounds()
				timer.Simple(0.05,function() if IsValid(self) then StopSound(self.CurrentPainSound) end end)
				timer.Simple(1.3,function() if IsValid(self) then StopSound(self.CurrentAlertSound) end end)
				local dur = CurTime() + ((((SoundDuration(sdtbl) > 0) and SoundDuration(sdtbl)) or 2) + 1)
				self.PainSoundT = dur
				self.NextAlertSoundT = dur
				self.NextInvestigateSoundT = CurTime() + 2
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(2, 3)
				self.CurrentBecomeEnemyToPlayerSound = sdType(self, sdtbl, self.BecomeEnemyToPlayerSoundLevel, self:VJ_DecideSoundPitch(self.BecomeEnemyToPlayerPitch.a, self.BecomeEnemyToPlayerPitch.b))
			end
		end
		return
	elseif sdSet == "OnKilledEnemy" then
		if self.HasOnKilledEnemySound == true && CurTime() > self.OnKilledEnemySoundT then
			local sdtbl = VJ.PICK(self.SoundTbl_OnKilledEnemy)
			if (math.random(1, self.OnKilledEnemySoundChance) == 1 && sdtbl) or customTbl then
				if customTbl then sdtbl = customTbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT = self.NextIdleSoundT + 2
				self.CurrentOnKilledEnemySound = sdType(self, sdtbl, self.OnKilledEnemySoundLevel, self:VJ_DecideSoundPitch(self.OnKilledEnemySoundPitch.a, self.OnKilledEnemySoundPitch.b))
			end
			self.OnKilledEnemySoundT = CurTime() + math.Rand(self.NextSoundTime_OnKilledEnemy.a, self.NextSoundTime_OnKilledEnemy.b)
		end
		return
	elseif sdSet == "AllyDeath" then
		if self.HasOnKilledEnemySound == true && CurTime() > self.AllyDeathSoundT then
			local sdtbl = VJ.PICK(self.SoundTbl_AllyDeath)
			if (math.random(1, self.AllyDeathSoundChance) == 1 && sdtbl) or customTbl then
				if customTbl then sdtbl = customTbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT = self.NextIdleSoundT + 2
				self.CurrentAllyDeathSound = sdType(self, sdtbl, self.AllyDeathSoundLevel, self:VJ_DecideSoundPitch(self.AllyDeathSoundPitch.a, self.AllyDeathSoundPitch.b))
			end
			self.AllyDeathSoundT = CurTime() + math.Rand(self.NextSoundTime_AllyDeath.a, self.NextSoundTime_AllyDeath.b)
		end
		return
	elseif sdSet == "Pain" then
		if self.HasPainSounds == true && CurTime() > self.PainSoundT then
			local sdtbl = VJ.PICK(self.SoundTbl_Pain)
			local sdDur = 2
			if (math.random(1, self.PainSoundChance) == 1 && sdtbl) or customTbl then
				if customTbl then sdtbl = customTbl end
				self:StopAllCommonSpeechSounds()
				StopSound(self.CurrentIdleSound)
				self.NextIdleSoundT_RegularChange = CurTime() + 1
				self.CurrentPainSound = sdType(self, sdtbl, self.PainSoundLevel, self:VJ_DecideSoundPitch(self.PainSoundPitch.a, self.PainSoundPitch.b))
				sdDur = (SoundDuration(sdtbl) > 0 and SoundDuration(sdtbl)) or sdDur
			end
			self.PainSoundT = CurTime() + ((self.NextSoundTime_Pain == false and sdDur) or math.Rand(self.NextSoundTime_Pain.a, self.NextSoundTime_Pain.b))
		end
		return
	elseif sdSet == "Impact" then
		if self.HasImpactSounds == true then
			local sdtbl = VJ.PICK(self.SoundTbl_Impact)
			if sdtbl == false then sdtbl = VJ.PICK(DefaultSoundTbl_Impact) end -- Default table
			if (math.random(1, self.ImpactSoundChance) == 1 && sdtbl) or customTbl then
				if customTbl then sdtbl = customTbl end
				self.CurrentImpactSound = sdType(self, sdtbl, self.ImpactSoundLevel, self:VJ_DecideSoundPitch(self.ImpactSoundPitch.a, self.ImpactSoundPitch.b))
			end
		end
		return
	elseif sdSet == "DamageByPlayer" then
		//if self.HasDamageByPlayerSounds == true && CurTime() > self.NextDamageByPlayerSoundT then -- This is done in the call instead
			local sdtbl = VJ.PICK(self.SoundTbl_DamageByPlayer)
			local sdDur = 2
			if (math.random(1, self.DamageByPlayerSoundChance) == 1 && sdtbl) or customTbl then
				if customTbl then sdtbl = customTbl end
				self:StopAllCommonSpeechSounds()
				sdDur = (SoundDuration(sdtbl) > 0 and SoundDuration(sdtbl)) or sdDur
				self.PainSoundT = CurTime() + sdDur
				self.NextIdleSoundT_RegularChange = CurTime() + sdDur
				timer.Simple(0.05, function() if IsValid(self) then StopSound(self.CurrentPainSound) end end)
				self.CurrentDamageByPlayerSound = sdType(self, sdtbl, self.DamageByPlayerSoundLevel, self:VJ_DecideSoundPitch(self.DamageByPlayerPitch.a, self.DamageByPlayerPitch.b))
			end
			self.NextDamageByPlayerSoundT = CurTime() + ((self.NextSoundTime_DamageByPlayer == false and sdDur) or math.Rand(self.NextSoundTime_DamageByPlayer.a, self.NextSoundTime_DamageByPlayer.b))
		//end
		return
	elseif sdSet == "Death" then
		if self.HasDeathSounds == true then
			local sdtbl = VJ.PICK(self.SoundTbl_Death)
			if (math.random(1, self.DeathSoundChance) == 1 && sdtbl) or customTbl then
				if customTbl then sdtbl = customTbl end
				self.CurrentDeathSound = sdType(self, sdtbl, self.DeathSoundLevel, self:VJ_DecideSoundPitch(self.DeathSoundPitch.a, self.DeathSoundPitch.b))
			end
		end
		return
	--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-- Base-Specific Sound Tables --=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
	elseif sdSet == "BeforeMeleeAttack" then
		if self.HasMeleeAttackSounds == true then
			local sdtbl = VJ.PICK(self.SoundTbl_BeforeMeleeAttack)
			if (math.random(1, self.BeforeMeleeAttackSoundChance) == 1 && sdtbl) or customTbl then
				if customTbl then sdtbl = customTbl end
				if self.IdleSounds_PlayOnAttacks == false then StopSound(self.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
				self.NextIdleSoundT_RegularChange = CurTime() + 1
				self.CurrentBeforeMeleeAttackSound = sdType(self, sdtbl, self.BeforeMeleeAttackSoundLevel, self:VJ_DecideSoundPitch(self.BeforeMeleeAttackSoundPitch.a, self.BeforeMeleeAttackSoundPitch.b))
			end
		end
		return
	elseif sdSet == "MeleeAttack" then
		if self.HasMeleeAttackSounds == true then
			local sdtbl = VJ.PICK(self.SoundTbl_MeleeAttack)
			if (math.random(1, self.MeleeAttackSoundChance) == 1 && sdtbl) or customTbl then
				if customTbl then sdtbl = customTbl end
				if self.IdleSounds_PlayOnAttacks == false then StopSound(self.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
				self.NextIdleSoundT_RegularChange = CurTime() + 1
				self.CurrentMeleeAttackSound = sdType(self, sdtbl, self.MeleeAttackSoundLevel, self:VJ_DecideSoundPitch(self.MeleeAttackSoundPitch.a, self.MeleeAttackSoundPitch.b))
			end
			if self.HasExtraMeleeAttackSounds == true then
				sdtbl = VJ.PICK(self.SoundTbl_MeleeAttackExtra)
				if sdtbl == false then sdtbl = VJ.PICK(DefaultSoundTbl_MeleeAttackExtra) end -- Default table
				if (math.random(1, self.ExtraMeleeSoundChance) == 1 && sdtbl) or customTbl then
					if self.IdleSounds_PlayOnAttacks == false then StopSound(self.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
					self.CurrentExtraMeleeAttackSound = VJ.EmitSound(self, sdtbl, self.ExtraMeleeAttackSoundLevel, self:VJ_DecideSoundPitch(self.ExtraMeleeSoundPitch.a, self.ExtraMeleeSoundPitch.b))
				end
			end
		end
		return
	elseif sdSet == "MeleeAttackMiss" then
		if self.HasMeleeAttackMissSounds == true then
			local sdtbl = VJ.PICK(self.SoundTbl_MeleeAttackMiss)
			if (math.random(1, self.MeleeAttackMissSoundChance) == 1 && sdtbl) or customTbl then
				if customTbl then sdtbl = customTbl end
				if self.IdleSounds_PlayOnAttacks == false then StopSound(self.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
				self.NextIdleSoundT_RegularChange = CurTime() + 1
				self.CurrentMeleeAttackMissSound = sdType(self, sdtbl, self.MeleeAttackMissSoundLevel, self:VJ_DecideSoundPitch(self.MeleeAttackMissSoundPitch.a, self.MeleeAttackMissSoundPitch.b))
			end
		end
		return
	elseif sdSet == "BeforeRangeAttack" then
		if self.HasBeforeRangeAttackSound == true then
			local sdtbl = VJ.PICK(self.SoundTbl_BeforeRangeAttack)
			if (math.random(1, self.BeforeRangeAttackSoundChance) == 1 && sdtbl) or customTbl then
				if customTbl then sdtbl = customTbl end
				if self.IdleSounds_PlayOnAttacks == false then StopSound(self.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
				self.NextIdleSoundT_RegularChange = CurTime() + 1
				self.CurrentBeforeRangeAttackSound = sdType(self, sdtbl, self.BeforeRangeAttackSoundLevel, self:VJ_DecideSoundPitch(self.BeforeRangeAttackPitch.a, self.BeforeRangeAttackPitch.b))
			end
		end
		return
	elseif sdSet == "RangeAttack" then
		if self.HasRangeAttackSound == true then
			local sdtbl = VJ.PICK(self.SoundTbl_RangeAttack)
			if (math.random(1, self.RangeAttackSoundChance) == 1 && sdtbl) or customTbl then
				if customTbl then sdtbl = customTbl end
				if self.IdleSounds_PlayOnAttacks == false then StopSound(self.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
				self.NextIdleSoundT_RegularChange = CurTime() + 1
				self.CurrentRangeAttackSound = sdType(self, sdtbl, self.RangeAttackSoundLevel, self:VJ_DecideSoundPitch(self.RangeAttackPitch.a, self.RangeAttackPitch.b))
			end
		end
		return
	elseif sdSet == "BeforeLeapAttack" then
		if self.HasBeforeLeapAttackSound == true then
			local sdtbl = VJ.PICK(self.SoundTbl_BeforeLeapAttack)
			if (math.random(1, self.BeforeLeapAttackSoundChance) == 1 && sdtbl) or customTbl then
				if customTbl then sdtbl = customTbl end
				if self.IdleSounds_PlayOnAttacks == false then StopSound(self.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
				self.NextIdleSoundT_RegularChange = CurTime() + 1
				self.CurrentBeforeLeapAttackSound = sdType(self, sdtbl, self.BeforeLeapAttackSoundLevel, self:VJ_DecideSoundPitch(self.BeforeLeapAttackSoundPitch.a, self.BeforeLeapAttackSoundPitch.b))
			end
		end
		return
	elseif sdSet == "LeapAttackJump" then
		if self.HasLeapAttackJumpSound == true then
			local sdtbl = VJ.PICK(self.SoundTbl_LeapAttackJump)
			if (math.random(1, self.LeapAttackJumpSoundChance) == 1 && sdtbl) or customTbl then
				if customTbl then sdtbl = customTbl end
				if self.IdleSounds_PlayOnAttacks == false then StopSound(self.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
				self.NextIdleSoundT_RegularChange = CurTime() + 1
				self.CurrentLeapAttackJumpSound = sdType(self, sdtbl, self.LeapAttackJumpSoundLevel, self:VJ_DecideSoundPitch(self.LeapAttackJumpSoundPitch.a, self.LeapAttackJumpSoundPitch.b))
			end
		end
		return
	elseif sdSet == "LeapAttackDamage" then
		if self.HasLeapAttackDamageSound == true then
			local sdtbl = VJ.PICK(self.SoundTbl_LeapAttackDamage)
			if (math.random(1, self.LeapAttackDamageSoundChance) == 1 && sdtbl) or customTbl then
				if customTbl then sdtbl = customTbl end
				if self.IdleSounds_PlayOnAttacks == false then StopSound(self.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
				self.NextIdleSoundT_RegularChange = CurTime() + 1
				self.CurrentLeapAttackDamageSound = sdType(self, sdtbl, self.LeapAttackDamageSoundLevel, self:VJ_DecideSoundPitch(self.LeapAttackDamageSoundPitch.a, self.LeapAttackDamageSoundPitch.b))
			end
		end
		return
	elseif sdSet == "LeapAttackDamageMiss" then
		if self.HasLeapAttackDamageMissSound == true then
			local sdtbl = VJ.PICK(self.SoundTbl_LeapAttackDamageMiss)
			if (math.random(1, self.LeapAttackDamageMissSoundChance) == 1 && sdtbl) or customTbl then
				if customTbl then sdtbl = customTbl end
				if self.IdleSounds_PlayOnAttacks == false then StopSound(self.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
				self.NextIdleSoundT_RegularChange = CurTime() + 1
				self.CurrentLeapAttackDamageMissSound = sdType(self, sdtbl, self.LeapAttackDamageMissSoundLevel, self:VJ_DecideSoundPitch(self.LeapAttackDamageMissSoundPitch.a, self.LeapAttackDamageMissSoundPitch.b))
			end
		end
		return
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FootStepSoundCode(customSd)
	if self.HasSounds == false or self.HasFootStepSound == false or self.MovementType == VJ_MOVETYPE_STATIONARY then return end
	if self:IsOnGround() && self:GetGroundEntity() != NULL then
		if self.DisableFootStepSoundTimer then
			local customTbl = VJ.PICK(customSd)
			local sdtbl = VJ.PICK(self.SoundTbl_FootStep)
			if customTbl then sdtbl = customTbl end
			if sdtbl then
				VJ.EmitSound(self, sdtbl, self.FootStepSoundLevel, self:VJ_DecideSoundPitch(self.FootStepPitch.a, self.FootStepPitch.b))
				local funcCustom = self.CustomOnFootStepSound; if funcCustom then funcCustom(self, "Event", sdtbl) end
			end
			if self.HasWorldShakeOnMove then util.ScreenShake(self:GetPos(), self.WorldShakeOnMoveAmplitude or 10, self.WorldShakeOnMoveFrequency or 100, self.WorldShakeOnMoveDuration or 0.4, self.WorldShakeOnMoveRadius or 1000) end -- !!!!!!!!!!!!!! DO NOT USE THESE !!!!!!!!!!!!!! [Backwards Compatibility!]
			return
		elseif self:IsMoving() && CurTime() > self.FootStepT && self:GetInternalVariable("m_flMoveWaitFinished") <= 0 then
			local customTbl = VJ.PICK(customSd)
			local sdtbl = VJ.PICK(self.SoundTbl_FootStep)
			if customTbl then sdtbl = customTbl end
			if !sdtbl then return end
			local curSched = self.CurrentSchedule
			if !self.DisableFootStepOnRun && ((VJ.HasValue(self.AnimTbl_Run, self:GetMovementActivity())) or (curSched != nil && curSched.MoveType == 1)) then
				VJ.EmitSound(self, sdtbl, self.FootStepSoundLevel, self:VJ_DecideSoundPitch(self.FootStepPitch.a, self.FootStepPitch.b))
				local funcCustom = self.CustomOnFootStepSound; if funcCustom then funcCustom(self, "Run", sdtbl) end
				if self.HasWorldShakeOnMove then util.ScreenShake(self:GetPos(), self.WorldShakeOnMoveAmplitude or 10, self.WorldShakeOnMoveFrequency or 100, self.WorldShakeOnMoveDuration or 0.4, self.WorldShakeOnMoveRadius or 1000) end -- !!!!!!!!!!!!!! DO NOT USE THESE !!!!!!!!!!!!!! [Backwards Compatibility!]
				self.FootStepT = CurTime() + self.FootStepTimeRun
				return
			elseif !self.DisableFootStepOnWalk && (VJ.HasValue(self.AnimTbl_Walk, self:GetMovementActivity()) or (curSched != nil && curSched.MoveType == 0)) then
				VJ.EmitSound(self, sdtbl, self.FootStepSoundLevel, self:VJ_DecideSoundPitch(self.FootStepPitch.a, self.FootStepPitch.b))
				local funcCustom = self.CustomOnFootStepSound; if funcCustom then funcCustom(self, "Walk", sdtbl) end
				if self.HasWorldShakeOnMove then util.ScreenShake(self:GetPos(), self.WorldShakeOnMoveAmplitude or 10, self.WorldShakeOnMoveFrequency or 100, self.WorldShakeOnMoveDuration or 0.4, self.WorldShakeOnMoveRadius or 1000) end -- !!!!!!!!!!!!!! DO NOT USE THESE !!!!!!!!!!!!!! [Backwards Compatibility!]
				self.FootStepT = CurTime() + self.FootStepTimeWalk
				return
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StopAllCommonSpeechSounds()
	StopSound(self.CurrentGeneralSpeechSound)
	StopSound(self.CurrentIdleSound)
	StopSound(self.CurrentIdleDialogueAnswerSound)
	StopSound(self.CurrentInvestigateSound)
	StopSound(self.CurrentLostEnemySound)
	StopSound(self.CurrentAlertSound)
	StopSound(self.CurrentFollowPlayerSound)
	StopSound(self.CurrentUnFollowPlayerSound)
	StopSound(self.CurrentMoveOutOfPlayersWaySound)
	StopSound(self.CurrentBecomeEnemyToPlayerSound)
	StopSound(self.CurrentOnPlayerSightSound)
	StopSound(self.CurrentDamageByPlayerSound)
	StopSound(self.CurrentMedicBeforeHealSound)
	StopSound(self.CurrentMedicAfterHealSound)
	StopSound(self.CurrentMedicReceiveHealSound)
	StopSound(self.CurrentCallForHelpSound)
	StopSound(self.CurrentOnReceiveOrderSound)
	StopSound(self.CurrentOnKilledEnemySound)
	StopSound(self.CurrentAllyDeathSound)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StopAllCommonSounds()
	StopSound(self.CurrentGeneralSpeechSound)
	StopSound(self.CurrentBreathSound)
	StopSound(self.CurrentIdleSound)
	StopSound(self.CurrentIdleDialogueAnswerSound)
	StopSound(self.CurrentInvestigateSound)
	StopSound(self.CurrentAlertSound)
	StopSound(self.CurrentBeforeMeleeAttackSound)
	StopSound(self.CurrentMeleeAttackSound)
	StopSound(self.CurrentExtraMeleeAttackSound)
	//StopSound(self.CurrentMeleeAttackMissSound)
	StopSound(self.CurrentBeforeRangeAttackSound)
	StopSound(self.CurrentRangeAttackSound)
	StopSound(self.CurrentBeforeLeapAttackSound)
	StopSound(self.CurrentLeapAttackJumpSound)
	StopSound(self.CurrentLeapAttackDamageSound)
	StopSound(self.CurrentPainSound)
	StopSound(self.CurrentFollowPlayerSound)
	StopSound(self.CurrentUnFollowPlayerSound)
	StopSound(self.CurrentMoveOutOfPlayersWaySound)
	StopSound(self.CurrentBecomeEnemyToPlayerSound)
	StopSound(self.CurrentOnPlayerSightSound)
	StopSound(self.CurrentDamageByPlayerSound)
	StopSound(self.CurrentMedicBeforeHealSound)
	StopSound(self.CurrentMedicAfterHealSound)
	StopSound(self.CurrentMedicReceiveHealSound)
	StopSound(self.CurrentCallForHelpSound)
	StopSound(self.CurrentOnReceiveOrderSound)
	StopSound(self.CurrentOnKilledEnemySound)
	StopSound(self.CurrentAllyDeathSound)
end