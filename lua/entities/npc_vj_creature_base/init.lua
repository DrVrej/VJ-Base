if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
include("schedules.lua")
include("movetype_aa.lua")
/*--------------------------------------------------
	=============== Creature SNPC Base ===============
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
	INFO: Used as a base for creature SNPCs.
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
ENT.CanTurnWhileStationary = true -- If set to true, the SNPC will be able to turn while it's a stationary SNPC
ENT.Stationary_UseNoneMoveType = false -- Technical variable, use this if there is any issues with the SNPC's position, though it does have its downsides, so use it only when needed
ENT.MaxJumpLegalDistance = VJ_Set(400,550) -- The max distance the NPC can jump (Usually from one node to another) | ( UP, DOWN )
	-- Aerial Move type Variables:
ENT.Aerial_FlyingSpeed_Calm = 80 -- The speed it should fly with, when it's wandering, moving slowly, etc. | Basically walking compared to ground SNPCs
ENT.Aerial_FlyingSpeed_Alerted = 200 -- The speed it should fly with, when it's chasing an enemy, moving away quickly, etc. | Basically running compared to ground SNPCs
ENT.Aerial_AnimTbl_Calm = {} -- Animations it plays when it's wandering around while idle
ENT.Aerial_AnimTbl_Alerted = {} -- Animations it plays when it's moving while alerted
	-- Aquatic Move type Variables:
ENT.Aquatic_SwimmingSpeed_Calm = 80 -- The speed it should swim with, when it's wandering, moving slowly, etc. | Basically walking compared to ground SNPCs
ENT.Aquatic_SwimmingSpeed_Alerted = 200 -- The speed it should swim with, when it's chasing an enemy, moving away quickly, etc. | Basically running compared to ground SNPCs
ENT.Aquatic_AnimTbl_Calm = {} -- Animations it plays when it's wandering around while idle
ENT.Aquatic_AnimTbl_Alerted = {} -- Animations it plays when it's moving while alerted
	-- Aerial & Aquatic Variables:
ENT.AA_EnableDebug = false -- Used for testing aerial and aquatic SNPCs
ENT.AA_ConstantlyMove = false -- Used for aerial and aquatic SNPCs, makes them constantly move
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
ENT.BecomeEnemyToPlayer = false -- Should the friendly SNPC become enemy towards the player if it's damaged by a player?
ENT.BecomeEnemyToPlayerLevel = 2 -- How many times does the player have to hit the SNPC for it to become enemy?
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
ENT.AnimTbl_IdleStand = {ACT_IDLE} -- The idle animation when AI is enabled
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
ENT.PoseParameterLooking_Names = {pitch={},yaw={},roll={}} -- Custom pose parameters to use, can put as many as needed
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
ENT.HasHitGroupFlinching = false -- It will flinch when hit in certain hitgroups | It can also have certain animations to play in certain hitgroups
ENT.HitGroupFlinching_DefaultWhenNotHit = true -- If it uses hitgroup flinching, should it do the regular flinch if it doesn't hit any of the specified hitgroups?
ENT.HitGroupFlinching_Values = {/* EXAMPLES: {HitGroup = {HITGROUP_LEFTLEG}, Animation = {ACT_FLINCH_LEFTLEG}}, {HitGroup = {HITGROUP_RIGHTLEG}, Animation = {ACT_FLINCH_RIGHTLEG}} */}
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
------ Killed & Corpse Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- ====== Corpse Variables ====== --
ENT.HasDeathRagdoll = true -- If set to false, it will not spawn the regular ragdoll of the SNPC
ENT.DeathCorpseEntityClass = "UseDefaultBehavior" -- The entity class it creates | "UseDefaultBehavior" = Let the base automatically detect the type
ENT.DeathCorpseModel = {} -- The corpse model that it will spawn when it dies | Leave empty to use the NPC's model | Put as many models as desired, the base will pick a random one.
ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS -- Collision type for the corpse | SNPC Options Menu can only override this value if it's set to COLLISION_GROUP_DEBRIS!
ENT.DeathCorpseSkin = -1 -- Used to override the death skin | -1 = Use the skin that the SNPC had before it died
ENT.DeathCorpseSetBodyGroup = true -- Should it get the models bodygroups and set it to the corpse? When set to false, it uses the model's default bodygroups
ENT.DeathCorpseBodyGroup = VJ_Set(-1,-1) -- #1 = the category of the first bodygroup | #2 = the value of the second bodygroup | Set -1 for #1 to let the base decide the corpse's bodygroup
ENT.DeathCorpseSubMaterials = nil -- Apply a table of indexes that correspond to a sub material index, this will cause the base to copy the NPC's sub material to the corpse.
ENT.FadeCorpse = false -- Fades the ragdoll on death
ENT.FadeCorpseTime = 10 -- How much time until the ragdoll fades | Unit = Seconds
ENT.SetCorpseOnFire = false -- Sets the corpse on fire when the SNPC dies
ENT.UsesBoneAngle = true -- This can be used to stop the corpse glitching or flying on death
ENT.UsesDamageForceOnDeath = true -- Disables the damage force on death | Useful for SNPCs with Death Animations
ENT.WaitBeforeDeathTime = 0 -- Time until the SNPC spawns its corpse and gets removed
	-- ====== Death Animation Variables ====== --
ENT.HasDeathAnimation = false -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {} -- Death Animations
	-- To let the base automatically detect the animation duration, set this to false:
ENT.DeathAnimationTime = false -- Time until the SNPC spawns its corpse and gets removed
ENT.DeathAnimationChance = 1 -- Put 1 if you want it to play the animation all the time
ENT.DeathAnimationDecreaseLengthAmount = 0 -- This will decrease the time until it turns into a corpse
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
	-- ====== Miscellaneous Variables ====== --
ENT.HasDeathNotice = false -- Set to true if you want it show a message after it dies
ENT.DeathNoticePosition = HUD_PRINTCENTER -- Were you want the message to show. Examples: HUD_PRINTCENTER, HUD_PRINTCONSOLE, HUD_PRINTTALK
ENT.DeathNoticeWriting = "Example: Spider Queen Has Been Defeated!" -- Message that will appear
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
ENT.MeleeAttackExtraTimers = {/* Ex: 1,1.4 */} -- Extra melee attack timers | it will run the damage code after the given amount of seconds
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
ENT.MeleeAttackSetEnemyOnFire = false -- Sets the enemy on fire when it does the melee attack
ENT.MeleeAttackSetEnemyOnFireTime = 6 -- For how long should the enemy be set on fire || Counted in seconds
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
ENT.RangeAttackExtraTimers = {/* Ex: 1,1.4 */} -- Extra range attack timers | it will run the projectile code after the given amount of seconds
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
ENT.LeapAttackAnimationFaceEnemy = false -- Should it face the enemy while playing the leap attack animation?
ENT.LeapAttackAnimationDecreaseLengthAmount = 0 -- This will decrease the time until starts chasing again. Use it to fix animation pauses until it chases the enemy.
	-- ====== Distance Variables ====== --
ENT.LeapDistance = 500 -- The distance of the leap, for example if it is set to 500, when the SNPC is 500 Unit away, it will jump
ENT.LeapToMeleeDistance = 200 -- How close does it have to be until it uses melee?
ENT.LeapAttackDamageDistance = 100 -- How far does the damage go?
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
ENT.LeapAttackExtraTimers = {/* Ex: 1,1.4 */} -- Extra leap attack timers | it will run the damage code after the given amount of seconds
ENT.StopLeapAttackAfterFirstHit = true -- Should it stop the leap attack from running rest of timers when it hits an enemy?
	-- ====== Velocity Variables ====== --
ENT.LeapAttackVelocityForward = 2000 -- How much forward force should it apply?
ENT.LeapAttackVelocityUp = 200 -- How much upward force should it apply?
ENT.LeapAttackVelocityRight = 0 -- How much right force should it apply?
	-- ====== Control Variables ====== --
ENT.DisableLeapAttackAnimation = false -- if true, it will disable the animation code
ENT.LeapAttackUseCustomVelocity = false -- Should it disable the default velocity system?
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
ENT.DisableWorldShakeOnMoveWhileRunning = false -- It will not shake the world when it's running
ENT.DisableWorldShakeOnMoveWhileWalking = false -- It will not shake the world when it's walking
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
ENT.MoveOutOfPlayersWaySoundChance = 1
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
ENT.NextSoundTime_Idle1 = 4
ENT.NextSoundTime_Idle2 = 11
ENT.NextSoundTime_Investigate = VJ_Set(5, 5)
ENT.NextSoundTime_LostEnemy = VJ_Set(5, 6)
ENT.NextSoundTime_Alert1 = 2
ENT.NextSoundTime_Alert2 = 3
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
ENT.PainSoundLevel = 75
ENT.ImpactSoundLevel = 60
ENT.DamageByPlayerSoundLevel = 75
ENT.DeathSoundLevel = 75
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
ENT.ExtraMeleeSoundPitch1 = 80
ENT.ExtraMeleeSoundPitch2 = 100
ENT.MeleeAttackMissSoundPitch = VJ_Set(80, 100)
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
function ENT:CustomOnMedic_OnHeal() end
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
function ENT:CustomOnMeleeAttack_AfterChecks(hitEnt) return false end -- return true to disable the attack and move onto the next entity!
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_BleedEnemy(hitEnt) end
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
function ENT:RangeAttackCode_GetShootPos(projectile) return (self:GetEnemy():GetPos() - self:LocalToWorld(Vector(0,0,0)))*2 + self:GetUp()*1 end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MultipleLeapAttacks() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomAttackCheck_LeapAttack() return true end -- Not returning true will not let the leap attack code run!
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnLeapAttackVelocityCode() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnLeapAttack_BeforeStartTimer(seed) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnLeapAttack_AfterStartTimer(seed) end
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
function ENT:Controller_Initialize(ply) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_IntMsg(ply)
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
ENT.ResetedEnemy = true
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
ENT.DoneLastHiddenZone_CanWander = false
ENT.FollowPlayer_Entity = NULL
ENT.VJ_TheController = NULL
ENT.VJ_TheControllerEntity = NULL
ENT.VJ_TheControllerBullseye = NULL
ENT.Medic_CurrentEntToHeal = NULL
ENT.Medic_SpawnedProp = NULL
ENT.LastPlayedVJSound = nil
ENT.LatestDmgInfo = nil
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
ENT.Passive_NextRunOnTouchT = 0
ENT.Passive_NextRunOnDamageT = 0
ENT.NextWanderTime = 0
ENT.TakingCoverT = 0
ENT.NextInvestigateSoundMove = 0
ENT.NextInvestigateSoundT = 0
ENT.NextCallForHelpSoundT = 0
ENT.LostEnemySoundT = 0
ENT.NextDoAnyAttackT = 0
ENT.NearestPointToEnemyDistance = 0
ENT.JumpLegalLandingTime = 0
ENT.ReachableEnemyCount = 0
ENT.LatestEnemyDistance = 0
ENT.HealthRegenerationDelayT = 0
ENT.CurAttackSeed = 0
ENT.LatestVisibleEnemyPosition = Vector(0,0,0)
ENT.GuardingPosition = nil
ENT.GuardingFacePosition = nil
ENT.AA_CurrentTurnAng = false
ENT.SelectedDifficulty = 1
ENT.AIState = 0
ENT.TimersToRemove = {"timer_state_reset","timer_act_seq_wait","timer_face_position","timer_face_enemy","timer_act_flinching","timer_act_playingattack","timer_act_stopattacks","timer_melee_finished","timer_melee_start","timer_melee_finished_abletomelee","timer_range_start","timer_range_finished","timer_range_finished_abletorange","timer_leap_start_jump","timer_leap_start","timer_leap_finished","timer_leap_finished_abletoleap"}
ENT.EntitiesToDestroyClass = {func_breakable=true,func_physbox=true,prop_door_rotating=true} // func_breakable_surf
ENT.DefaultGibDamageTypes = {DMG_ALWAYSGIB,DMG_ENERGYBEAM,DMG_BLAST,DMG_VEHICLE,DMG_CRUSH,DMG_DIRECT,DMG_DISSOLVE,DMG_AIRBOAT,DMG_SLOWBURN,DMG_PHYSGUN,DMG_PLASMA,DMG_SONIC}

-- Localized static values
local NPCTbl_Animals = {npc_barnacle=true,npc_crow=true,npc_pigeon=true,npc_seagull=true,monster_cockroach=true}
local NPCTbl_Resistance = {npc_magnusson=true,npc_vortigaunt=true,npc_mossman=true,npc_monk=true,npc_kleiner=true,npc_fisherman=true,npc_eli=true,npc_dog=true,npc_barney=true,npc_alyx=true,npc_citizen=true,monster_scientist=true,monster_barney=true}
local NPCTbl_Combine = {npc_stalker=true,npc_rollermine=true,npc_turret_ground=true,npc_turret_floor=true,npc_turret_ceiling=true,npc_strider=true,npc_sniper=true,npc_metropolice=true,npc_hunter=true,npc_breen=true,npc_combine_camera=true,npc_combine_s=true,npc_combinedropship=true,npc_combinegunship=true,npc_cscanner=true,npc_clawscanner=true,npc_helicopter=true,npc_manhack=true}
local NPCTbl_Zombies = {npc_fastzombie_torso=true,npc_zombine=true,npc_zombie_torso=true,npc_zombie=true,npc_poisonzombie=true,npc_headcrab_fast=true,npc_headcrab_black=true,npc_headcrab=true,npc_fastzombie=true,monster_zombie=true,monster_headcrab=true,monster_babycrab=true}
local NPCTbl_Antlions = {npc_antlion=true,npc_antlionguard=true,npc_antlion_worker=true}
local NPCTbl_Xen = {monster_bullchicken=true,monster_alien_grunt=true,monster_alien_slave=true,monster_alien_controller=true,monster_houndeye=true,monster_gargantua=true,monster_nihilanth=true}
local vec_worigin = Vector(0, 0, 0)
local ang_worigin = Angle(0, 0, 0)

local CurTime = CurTime
local IsValid = IsValid
local GetConVarNumber = GetConVarNumber
local istable = istable
local isstring = isstring
local isnumber = isnumber
local tonumber = tonumber
local string_find = string.find
local string_Replace = string.Replace
local table_remove = table.remove
local varCPly = "CLASS_PLAYER_ALLY"
local varCAnt = "CLASS_ANTLION"
local varCCom = "CLASS_COMBINE"
local varCXen = "CLASS_XEN"
local varCZom = "CLASS_ZOMBIE"

---------------------------------------------------------------------------------------------------------------------------------------------
local function ConvarsOnInit(self)
	--<>-- Convars that run on Initialize --<>--
	if GetConVarNumber("vj_npc_usedevcommands") == 1 then self.VJDEBUG_SNPC_ENABLED = true self.AA_EnableDebug = true end
	self.NextProcessTime = GetConVarNumber("vj_npc_processtime")
	if GetConVarNumber("vj_npc_sd_nosounds") == 1 then self.HasSounds = false end
	if GetConVarNumber("vj_npc_vjfriendly") == 1 then self.VJFriendly = true end
	if GetConVarNumber("vj_npc_playerfriendly") == 1 then self.PlayerFriendly = true end
	if GetConVarNumber("vj_npc_antlionfriendly") == 1 then self.VJ_NPC_Class[#self.VJ_NPC_Class + 1] = varCAnt end
	if GetConVarNumber("vj_npc_combinefriendly") == 1 then self.VJ_NPC_Class[#self.VJ_NPC_Class + 1] = varCCom end
	if GetConVarNumber("vj_npc_zombiefriendly") == 1 then self.VJ_NPC_Class[#self.VJ_NPC_Class + 1] = varCZom end
	if GetConVarNumber("vj_npc_noallies") == 1 then self.HasAllies = false self.PlayerFriendly = false end
	if GetConVarNumber("vj_npc_nocorpses") == 1 then self.HasDeathRagdoll = false end
	if GetConVarNumber("vj_npc_itemdrops") == 0 then self.HasItemDropsOnDeath = false end
	if GetConVarNumber("vj_npc_noproppush") == 1 then self.PushProps = false end
	if GetConVarNumber("vj_npc_nopropattack") == 1 then self.AttackProps = false end
	if GetConVarNumber("vj_npc_bleedenemyonmelee") == 1 then self.MeleeAttackBleedEnemy = false end
	if GetConVarNumber("vj_npc_slowplayer") == 1 then self.SlowPlayerOnMeleeAttack = false end
	if GetConVarNumber("vj_npc_nowandering") == 1 then self.DisableWandering = true end
	if GetConVarNumber("vj_npc_nochasingenemy") == 1 then self.DisableChasingEnemy = true end
	if GetConVarNumber("vj_npc_noflinching") == 1 then self.CanFlinch = false end
	if GetConVarNumber("vj_npc_nomelee") == 1 then self.HasMeleeAttack = false end
	if GetConVarNumber("vj_npc_norange") == 1 then self.HasRangeAttack = false end
	if GetConVarNumber("vj_npc_noleap") == 1 then self.HasLeapAttack = false end
	if GetConVarNumber("vj_npc_nobleed") == 1 then self.Bleeds = false end
	if GetConVarNumber("vj_npc_godmodesnpc") == 1 then self.GodMode = true end
	if GetConVarNumber("vj_npc_nobecomeenemytoply") == 1 then self.BecomeEnemyToPlayer = false end
	if GetConVarNumber("vj_npc_nofollowplayer") == 1 then self.FollowPlayer = false end
	if GetConVarNumber("vj_npc_nosnpcchat") == 1 then self.AllowPrintingInChat = false self.FollowPlayerChat = false end
	if GetConVarNumber("vj_npc_nomedics") == 1 then self.IsMedicSNPC = false end
	if GetConVarNumber("vj_npc_nogibdeathparticles") == 1 then self.HasGibDeathParticles = false end
	if GetConVarNumber("vj_npc_nogib") == 1 then self.AllowedToGib = false self.HasGibOnDeath = false end
	if GetConVarNumber("vj_npc_usegmoddecals") == 1 then self.BloodDecalUseGMod = true end
	if GetConVarNumber("vj_npc_knowenemylocation") == 1 then self.FindEnemy_UseSphere = true self.FindEnemy_CanSeeThroughWalls = true end
	if GetConVarNumber("vj_npc_sd_gibbing") == 1 then self.HasGibOnDeathSounds = false end
	if GetConVarNumber("vj_npc_sd_soundtrack") == 1 then self.HasSoundTrack = false end
	if GetConVarNumber("vj_npc_sd_footstep") == 1 then self.HasFootStepSound = false end
	if GetConVarNumber("vj_npc_sd_idle") == 1 then self.HasIdleSounds = false end
	if GetConVarNumber("vj_npc_sd_breath") == 1 then self.HasBreathSound = false end
	if GetConVarNumber("vj_npc_sd_alert") == 1 then self.HasAlertSounds = false end
	if GetConVarNumber("vj_npc_sd_meleeattack") == 1 then self.HasMeleeAttackSounds = false self.HasExtraMeleeAttackSounds = false end
	if GetConVarNumber("vj_npc_sd_meleeattackmiss") == 1 then self.HasMeleeAttackMissSounds = false end
	if GetConVarNumber("vj_npc_sd_slowplayer") == 1 then self.HasMeleeAttackSlowPlayerSound = false end
	if GetConVarNumber("vj_npc_sd_rangeattack") == 1 then self.HasBeforeRangeAttackSound = false self.HasRangeAttackSound = false end
	if GetConVarNumber("vj_npc_sd_leapattack") == 1 then self.HasBeforeLeapAttackSound = false self.HasLeapAttackJumpSound = false self.HasLeapAttackDamageSound = false self.HasLeapAttackDamageMissSound = false end
	if GetConVarNumber("vj_npc_sd_pain") == 1 then self.HasPainSounds = false end
	if GetConVarNumber("vj_npc_sd_death") == 1 then self.HasDeathSounds = false end
	if GetConVarNumber("vj_npc_sd_followplayer") == 1 then self.HasFollowPlayerSounds_Follow = false self.HasFollowPlayerSounds_UnFollow = false end
	if GetConVarNumber("vj_npc_sd_becomenemytoply") == 1 then self.HasBecomeEnemyToPlayerSounds = false end
	if GetConVarNumber("vj_npc_sd_onplayersight") == 1 then self.HasOnPlayerSightSounds = false end
	if GetConVarNumber("vj_npc_sd_medic") == 1 then self.HasMedicSounds_BeforeHeal = false self.HasMedicSounds_AfterHeal = false self.HasMedicSounds_ReceiveHeal = false end
	if GetConVarNumber("vj_npc_sd_callforhelp") == 1 then self.HasCallForHelpSounds = false end
	if GetConVarNumber("vj_npc_sd_onreceiveorder") == 1 then self.HasOnReceiveOrderSounds = false end
	local corpseCollision = GetConVarNumber("vj_npc_corpsecollision")
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
function ENT:Initialize()
	self:CustomOnPreInitialize()
	self:SetSpawnEffect(false)
	self:SetRenderMode(RENDERMODE_NORMAL) // RENDERMODE_TRANSALPHA
	self:AddEFlags(EFL_NO_DISSOLVE)
	self:SetUseType(SIMPLE_USE)
	self:SetName((self.PrintName == "" and list.Get("NPC")[self:GetClass()].Name) or self.PrintName)
	self.SelectedDifficulty = GetConVarNumber("vj_npc_difficulty")
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
	if self.BloodColor == "" then -- Backwards Compatibility!
		if self.BloodDecal == "Blood" then
			self.BloodColor = "Red"
		elseif self.BloodDecal == "YellowBlood" then
			self.BloodColor = "Yellow"
		end
	end
	self:SetupBloodColor()
	if self.DisableInitializeCapabilities == false then self:SetInitializeCapabilities() end
	self:SetHealth((GetConVarNumber("vj_npc_allhealth") > 0) and GetConVarNumber("vj_npc_allhealth") or self:VJ_GetDifficultyValue(self.StartHealth))
	self.StartHealth = self:Health()
	self:CustomOnInitialize()
	self:CustomInitialize() -- !!!!!!!!!!!!!! DO NOT USE THIS FUNCTION !!!!!!!!!!!!!! [Backwards Compatibility!]
	self.NextWanderTime = ((self.NextWanderTime != 0) and self.NextWanderTime) or (CurTime() + (self.IdleAlwaysWander and 0 or 1)) -- If self.NextWanderTime isn't given a value THEN if self.IdleAlwaysWander isn't true, wait at least 1 sec before wandering
	self.SightDistance = (GetConVarNumber("vj_npc_seedistance") > 0) and GetConVarNumber("vj_npc_seedistance") or self.SightDistance
	timer.Simple(0.15, function()
		if IsValid(self) then
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
	if GetConVarNumber("vj_npc_creatureopendoor") == 1 && self.CanOpenDoors == true then
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
		self:SetMoveType(MOVETYPE_STEP)
		self:CapabilitiesAdd(bit.bor(CAP_MOVE_GROUND))
		if VJ_AnimationExists(self,ACT_JUMP) == true then self:CapabilitiesAdd(bit.bor(CAP_MOVE_JUMP)) end
		if VJ_AnimationExists(self,ACT_CLIMB_UP) == true then self:CapabilitiesAdd(bit.bor(CAP_MOVE_CLIMB)) end
		self:CapabilitiesRemove(CAP_MOVE_FLY)
	elseif self.MovementType == VJ_MOVETYPE_AERIAL then
		self:SetMoveType(MOVETYPE_FLY)
		self:CapabilitiesAdd(bit.bor(CAP_MOVE_FLY))
		self:CapabilitiesRemove(CAP_MOVE_GROUND)
		self:CapabilitiesRemove(CAP_MOVE_JUMP)
		self:CapabilitiesRemove(CAP_MOVE_CLIMB)
		self:CapabilitiesRemove(CAP_MOVE_SHOOT)
	elseif self.MovementType == VJ_MOVETYPE_AQUATIC then
		self:SetMoveType(MOVETYPE_FLY)
		self:CapabilitiesAdd(bit.bor(CAP_MOVE_FLY))
		self:CapabilitiesRemove(CAP_MOVE_GROUND)
		self:CapabilitiesRemove(CAP_MOVE_JUMP)
		self:CapabilitiesRemove(CAP_MOVE_CLIMB)
		self:CapabilitiesRemove(CAP_MOVE_SHOOT)
	elseif self.MovementType == VJ_MOVETYPE_STATIONARY then
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
function ENT:IsJumpLegal(startPos, apex, endPos)
	/*print("---------------------")
	print(startPos)
	print(apex)
	print(endPos)*/
	local result = self:CustomOnIsJumpLegal(startPos, apex, endPos)
	if result != nil then if result == true then self.JumpLegalLandingTime = CurTime() + (endPos:Distance(startPos) / 190) end return result end
	local dist_apex = startPos:Distance(apex)
	local dist_end = startPos:Distance(endPos)
	local maxdist = self.MaxJumpLegalDistance.a -- Var gam Ver | Arachin tive varva hamar ter
	-- Aravel = Ver, Nevaz = Var
	if endPos.z - startPos.z <= 0 then maxdist = self.MaxJumpLegalDistance.b end -- Ver bidi tsadke
	/*print("---------------------")
	print(endPos.z - startPos.z)
	print("Apex: "..dist_apex)
	print("End Pos: "..dist_end)*/
	if dist_apex > maxdist then return nil end
	if dist_end > maxdist then return nil end
	self.JumpLegalLandingTime = CurTime() + (endPos:Distance(startPos) / 190)
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnChangeActivity(newAct)
	//print(newAct)
	self:CustomOnChangeActivity(newAct)
	if newAct == ACT_TURN_LEFT or newAct == ACT_TURN_RIGHT then
		self.NextIdleStandTime = CurTime() + VJ_GetSequenceDuration(self, self:GetSequenceName(self:GetSequence()))
		//self.NextIdleStandTime = CurTime() + 1.2
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local varGes = "vjges_"
local varSeq = "vjseq_"
--
function ENT:VJ_ACT_PLAYACTIVITY(vACT_Name, vACT_StopActivities, vACT_StopActivitiesTime, vACT_FaceEnemy, vACT_DelayAnim, vACT_AdvancedFeatures, vACT_CustomCode)
	vACT_Name = VJ_PICK(vACT_Name)
	if vACT_Name == false then return end
	
	vACT_StopActivities = vACT_StopActivities or false
	if vACT_StopActivitiesTime == nil then -- If user didn't put anything, then default it to 0
		vACT_StopActivitiesTime = 0 -- Set this value to false to let the base calculate the time
	end
	vACT_FaceEnemy = vACT_FaceEnemy or false -- Should it face the enemy while playing this animation?
	vACT_DelayAnim = tonumber(vACT_DelayAnim) or 0 -- How much time until it starts playing the animation (seconds)
	vACT_AdvancedFeatures = vACT_AdvancedFeatures or {}
		local vTbl_AlwaysUseSequence = vACT_AdvancedFeatures.AlwaysUseSequence or false -- Will force the animation to use sequence
		local vTbl_SequenceDuration = vACT_AdvancedFeatures.SequenceDuration -- How long is the sequence? This is done automatically, so recommended to not change it
		local vTbl_SequenceInterruptible = vACT_AdvancedFeatures.SequenceInterruptible or false -- Can it be Interrupted? (Mostly used for idle animations)
		local vTbl_AlwaysUseGesture = vACT_AdvancedFeatures.AlwaysUseGesture or false -- Will force the animation to use gesture
		local vTbl_PlayBackRate = vACT_AdvancedFeatures.PlayBackRate or self.AnimationPlaybackRate -- How fast should the animation play?
		local vTbl_PlayBackRateCalculated = vACT_AdvancedFeatures.PlayBackRateCalculated or false -- Has vACT_StopActivitiesTime already been calculated for the playback rate?
	
	local IsGesture = false
	local IsSequence = false
	local IsString = isstring(vACT_Name)
	
	-- Gesture handling
	if string_find(vACT_Name, varGes) then -- Gesture string-fixing
		IsGesture = true
		vACT_Name = string_Replace(vACT_Name, varGes, "") -- Delete the gesture prefix
		if string_find(vACT_Name, varSeq) then -- If the 2nd prefix is a sequence, then this is a gesture-sequence
			IsSequence = true
			vACT_Name = string_Replace(vACT_Name, varSeq, "") -- Delete the second prefix
		elseif self:LookupSequence(vACT_Name) == -1 then -- Check if it's a number by looking up the string. If it's not, then it will later be converted to an activity
			vACT_Name = tonumber(vACT_Name)
		end
	end
	if vTbl_AlwaysUseGesture == true then -- If we must always use a gesture
		IsGesture = true
		if isnumber(vACT_Name) then -- If it's an activity, then convert it to a string
			vACT_Name = self:GetSequenceName(self:SelectWeightedSequence(vACT_Name))
		end
	end
	
	-- Sequence handling
	if vTbl_AlwaysUseSequence == true then -- If we must always use a sequence
		IsSequence = true
		if isnumber(vACT_Name) then -- If it's an activity, then convert it to a string
			vACT_Name = self:GetSequenceName(self:SelectWeightedSequence(vACT_Name))
		end
	elseif IsString then -- Sequence string-fixing
		if string_find(vACT_Name, varSeq) then -- If the sequence prefix is given...
			IsSequence = true
			vACT_Name = string_Replace(vACT_Name, varSeq, "") -- Delete the sequence prefix
		else -- If prefix isn't given then check if it can be converted to an activity or else just play it as a sequence
			local checkanim = self:GetSequenceActivity(self:LookupSequence(vACT_Name))
			if checkanim == nil or checkanim == -1 then
				IsSequence = true
			else
				vACT_Name = checkanim -- Play it as an activity
			end
		end
	end
	
	-- If the given animation doesn't exist, then check to see if it does in the weapon translation list
	if VJ_AnimationExists(self, vACT_Name) == false then
		return -- This isn't a human SNPC, no need to check for weapon translation
		/*if !IsString && IsValid(self:GetActiveWeapon()) then -- If it's an activity and has a valid weapon then check for weapon translation
			-- If it returns the same activity as vACT_Name, then there isn't even a translation for it so don't play any animation =(
			if self:GetActiveWeapon().IsVJBaseWeapon && self:TranslateToWeaponAnim(vACT_Name) == vACT_Name then return end
		else
			return -- No animation =(
		end*/
	end
	
	if vACT_StopActivities == true then
		if vACT_StopActivitiesTime == false then -- if it's false, then let the base calculate the time
			vACT_StopActivitiesTime = self:DecideAnimationLength(vACT_Name, false)
		elseif vTbl_PlayBackRateCalculated == false then -- Make sure not to calculate the playback rate when it already has!
			vACT_StopActivitiesTime = vACT_StopActivitiesTime / self:GetPlaybackRate()
		end
		
		self:StopAttacks(true)
		self.vACT_StopAttacks = true
		self.NextChaseTime = CurTime() + vACT_StopActivitiesTime
		self.NextIdleTime = CurTime() + vACT_StopActivitiesTime
		
		-- If there is already a timer, then adjust it instead of creating a new one
		if timer.Exists("timer_act_stopattacks") then
			timer.Adjust("timer_act_stopattacks"..self:EntIndex(), vACT_StopActivitiesTime, 1, function() self.vACT_StopAttacks = false end)
		else
			timer.Create("timer_act_stopattacks"..self:EntIndex(), vACT_StopActivitiesTime, 1, function() self.vACT_StopAttacks = false end)
		end
	end
	
	local vsched = ai_vj_schedule.New("vj_act_"..vACT_Name)
	if (vACT_CustomCode) then vACT_CustomCode(vsched, vACT_Name) end
	
	self.NextIdleStandTime = 0
	if IsSequence == false then self.VJ_PlayingSequence = false end
	if self.VJ_PlayingInterruptSequence == true then self.VJ_PlayingInterruptSequence = false end
	
	timer.Simple(vACT_DelayAnim, function()
		if IsValid(self) then
			self.AnimationPlaybackRate = vTbl_PlayBackRate
			self:SetPlaybackRate(vTbl_PlayBackRate)
			if IsGesture == true then
				local gesture = false
				if IsSequence == true or isstring(vACT_Name) then
					gesture = self:AddGestureSequence(self:LookupSequence(vACT_Name))
				else
					gesture = self:AddGesture(vACT_Name)
				end
				if gesture != false then
					//self:ClearSchedule()
					//self:SetLayerBlendIn(1, 0)
					//self:SetLayerBlendOut(1, 0)
					self:SetLayerPriority(gesture, 1) // 2
					//self:SetLayerWeight(gesture, 1)
					self:SetLayerPlaybackRate(gesture, vTbl_PlayBackRate * 0.5)
					//self:SetLayerDuration(gesture, 3)
					//print(self:GetLayerDuration(gesture))
				end
			elseif IsSequence == true then
				seqwait = true
				if vTbl_SequenceDuration == false then seqwait = false end
				vTbl_SequenceDuration = (vTbl_SequenceDuration or self:SequenceDuration(self:LookupSequence(vACT_Name))) / self.AnimationPlaybackRate
				if vACT_FaceEnemy == true then
					self:FaceCertainEntity(self:GetEnemy(), true, vTbl_SequenceDuration)
				end
				self:VJ_PlaySequence(vACT_Name, vTbl_PlayBackRate, seqwait, vTbl_SequenceDuration, vTbl_SequenceInterruptible)
			end
			if IsGesture == false then -- If it's sequence or activity
				self:StartEngineTask(GetTaskList("TASK_RESET_ACTIVITY"), 0) //vsched:EngTask("TASK_RESET_ACTIVITY", 0)
				//if self.Dead == true then vsched:EngTask("TASK_STOP_MOVING", 0) end
				//vsched:EngTask("TASK_STOP_MOVING", 0)
				//self:FrameAdvance(0)
				self:StopMoving()
				self:ClearSchedule()
				//self:ClearGoal()
				
				if IsSequence == false then -- Only if activity
					self.VJ_PlayingSequence = false
					if self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then
						vsched:EngTask("TASK_SET_ACTIVITY", vACT_Name) -- To avoid AutoMovement stopping the velocity
					elseif vACT_FaceEnemy == true then
						vsched:EngTask("TASK_PLAY_SEQUENCE_FACE_ENEMY", vACT_Name)
					else
						vsched:EngTask("TASK_PLAY_SEQUENCE", vACT_Name)
					end
				end
				
				//self:StartEngineTask(GetTaskList("TASK_RESET_ACTIVITY"), 0)
				vsched.IsPlayActivity = true
				self:StartSchedule(vsched)
			end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_TASK_FACE_X(faceType, customFunc)
	-- Types: TASK_FACE_TARGET | TASK_FACE_ENEMY | TASK_FACE_PLAYER | TASK_FACE_LASTPOSITION | TASK_FACE_SAVEPOSITION | TASK_FACE_PATH | TASK_FACE_HINTNODE | TASK_FACE_IDEAL | TASK_FACE_REASONABLE
	if (self.MovementType == VJ_MOVETYPE_STATIONARY && self.CanTurnWhileStationary == false) or (self.IsVJBaseSNPC_Tank == true) then return end
	//self.NextIdleStandTime = CurTime() + 1.2
	local vschedFaceX = ai_vj_schedule.New("vj_face_x")
	vschedFaceX:EngTask(faceType or "TASK_FACE_TARGET", 0)
	if (customFunc) then customFunc(vschedFaceX) end
	self:StartSchedule(vschedFaceX)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_TASK_GOTO_LASTPOS(moveType, customFunc)
	local vsched = ai_vj_schedule.New("vj_goto_lastpos")
	vsched:EngTask("TASK_GET_PATH_TO_LASTPOSITION", 0)
	//vsched:EngTask(moveType, 0)
	vsched:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
	vsched.IsMovingTask = true
	if (moveType or "TASK_RUN_PATH") == "TASK_RUN_PATH" then self:SetMovementActivity(VJ_PICK(self.AnimTbl_Run)) vsched.IsMovingTask_Run = true else self:SetMovementActivity(VJ_PICK(self.AnimTbl_Walk)) vsched.IsMovingTask_Walk = true end
	//self.CanDoSelectScheduleAgain = false
	//vsched.RunCode_OnFinish = function()
		//self.CanDoSelectScheduleAgain = true
	//end
	if (customFunc) then customFunc(vsched) end
	self:StartSchedule(vsched)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_TASK_GOTO_TARGET(moveType, customFunc)
	local vsched = ai_vj_schedule.New("vj_goto_target")
	vsched:EngTask("TASK_GET_PATH_TO_TARGET", 0)
	//vsched:EngTask(moveType, 0)
	vsched:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
	vsched:EngTask("TASK_FACE_TARGET", 1)
	vsched.IsMovingTask = true
	if (moveType or "TASK_RUN_PATH") == "TASK_RUN_PATH" then self:SetMovementActivity(VJ_PICK(self.AnimTbl_Run)) vsched.IsMovingTask_Run = true else self:SetMovementActivity(VJ_PICK(self.AnimTbl_Walk)) vsched.IsMovingTask_Walk = true end
	if (customFunc) then customFunc(vsched) end
	self:StartSchedule(vsched)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_TASK_GOTO_PLAYER(moveType, customFunc)
	local vsched = ai_vj_schedule.New("vj_goto_player")
	vsched:EngTask("TASK_GET_PATH_TO_PLAYER", 0)
	//vsched:EngTask(moveType, 0)
	vsched:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
	vsched.IsMovingTask = true
	if (moveType or "TASK_RUN_PATH") == "TASK_RUN_PATH" then self:SetMovementActivity(VJ_PICK(self.AnimTbl_Run)) vsched.IsMovingTask_Run = true else self:SetMovementActivity(VJ_PICK(self.AnimTbl_Walk)) vsched.IsMovingTask_Walk = true end
	if (customFunc) then customFunc(vsched) end
	self:StartSchedule(vsched)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_TASK_COVER_FROM_ENEMY(moveType, customFunc)
	if self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then self:AAMove_Wander(true) return end
	moveType = moveType or "TASK_RUN_PATH"
	local vsched = ai_vj_schedule.New("vj_cover_from_enemy")
	vsched:EngTask("TASK_FIND_COVER_FROM_ENEMY", 0)
	//vsched:EngTask(moveType, 0)
	vsched:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
	vsched.IsMovingTask = true
	if moveType == "TASK_RUN_PATH" then self:SetMovementActivity(VJ_PICK(self.AnimTbl_Run)) vsched.IsMovingTask_Run = true else self:SetMovementActivity(VJ_PICK(self.AnimTbl_Walk)) vsched.IsMovingTask_Walk = true end
	vsched.RunCode_OnFail = function()
		local vschedFail = ai_vj_schedule.New("vj_cover_from_enemy_fail")
		vschedFail:EngTask("TASK_SET_ROUTE_SEARCH_TIME", 1)
		vschedFail:EngTask("TASK_GET_PATH_TO_RANDOM_NODE", 500)
		//vschedFail:EngTask(moveType, 0)
		vschedFail:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
		vschedFail.IsMovingTask = true
		if moveType == "TASK_RUN_PATH" then self:SetMovementActivity(VJ_PICK(self.AnimTbl_Run)) vschedFail.IsMovingTask_Run = true else self:SetMovementActivity(VJ_PICK(self.AnimTbl_Walk)) vschedFail.IsMovingTask_Walk = true end
		if (customFunc) then customFunc(vschedFail) end
		self:StartSchedule(vschedFail)
	end
	if (customFunc) then customFunc(vsched) end
	self:StartSchedule(vsched)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local task_idleWander = ai_vj_schedule.New("vj_idle_wander")
	//task_idleWander:EngTask("TASK_SET_ROUTE_SEARCH_TIME", 0)
	//task_idleWander:EngTask("TASK_GET_PATH_TO_LASTPOSITION", 0)
	task_idleWander:EngTask("TASK_GET_PATH_TO_RANDOM_NODE", 350)
	//task_idleWander:EngTask("TASK_WALK_PATH", 0)
	task_idleWander:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
	task_idleWander.ResetOnFail = true
	task_idleWander.CanBeInterrupted = true
	task_idleWander.IsMovingTask = true
	task_idleWander.IsMovingTask_Walk = true
	
function ENT:VJ_TASK_IDLE_WANDER()
	if self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then self:AAMove_Wander(true) return end
	self:SetMovementActivity(VJ_PICK(self.AnimTbl_Walk))
	//self:SetLastPosition(self:GetPos() + self:GetForward() * 300)
	self:StartSchedule(task_idleWander)
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
	task_chaseEnemyLOS.IsMovingTask_Run = true
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
	task_chaseEnemy.IsMovingTask_Run = true
--
local varChaseEnemy = "vj_chase_enemy"
function ENT:VJ_TASK_CHASE_ENEMY(doLOSChase)
	doLOSChase = doLOSChase or false
	if self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then self:AAMove_ChaseEnemy(true) return end
	//if self.CurrentSchedule != nil && self.CurrentSchedule.Name == "vj_chase_enemy" then return end
	if (self:GetEnemyLastKnownPos():Distance(self:GetEnemy():GetPos()) <= 12) && self.CurrentSchedule != nil && self.CurrentSchedule.Name == varChaseEnemy then return end
	if (CurTime() <= self.JumpLegalLandingTime && (self:GetActivity() == ACT_JUMP or self:GetActivity() == ACT_GLIDE or self:GetActivity() == ACT_LAND)) or self:GetActivity() == ACT_CLIMB_UP or self:GetActivity() == ACT_CLIMB_DOWN or self:GetActivity() == ACT_CLIMB_DISMOUNT then return end
	self:SetMovementActivity(VJ_PICK(self.AnimTbl_Run))
	if doLOSChase == true then
		task_chaseEnemyLOS.RunCode_OnFinish = function()
			if IsValid(self:GetEnemy()) then
				self:RememberUnreachable(self:GetEnemy(), 0)
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
function ENT:VJ_TASK_IDLE_STAND()
	if self:IsMoving() or (self.NextIdleTime > CurTime()) /*or self.CurrentSchedule != nil*/ then return end
	//if (self.CurrentSchedule != nil && self.CurrentSchedule.Name == "vj_idle_stand") or (self.CurrentAnim_CustomIdle != 0 && VJ_IsCurrentAnimation(self,self.CurrentAnim_CustomIdle) == true) then return end
	//if (self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC) && self:GetVelocity():Length() > 0 then return end
	//if self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then self:AAMove_Stop() return end

	/*local vschedIdleStand = ai_vj_schedule.New("vj_idle_stand")
	//vschedIdleStand:EngTask("TASK_FACE_REASONABLE")
	vschedIdleStand:EngTask("TASK_STOP_MOVING")
	vschedIdleStand:EngTask("TASK_WAIT_INDEFINITE")
	vschedIdleStand.CanBeInterrupted = true
	self:StartSchedule(vschedIdleStand)*/
	
	local animtbl = self.AnimTbl_IdleStand
	local hasanim = false
	for _,v in ipairs(animtbl) do -- Amen animation-nere ara
		v = VJ_SequenceToActivity(self,v) -- Nayir yete animation e sequence e, activity tartsoor
		if v != false && hasanim == false && self.CurrentAnim_IdleStand == v then -- Yete animation-e IdleStand table-en meche che, ooremen sharnage!
			hasanim = true
		end
	end
	-- Yete IdleStand table-e meg en aveli e, sharnage!
	if #animtbl > 1 && hasanim == true && self.NextIdleStandTime > CurTime() then
		return
	end
	local finaltbl = VJ_PICK(animtbl)
	if finaltbl == false then finaltbl = ACT_IDLE hasanim = true end -- Yete animation-me chi kedav, ter barz animation e
	finaltbl = VJ_SequenceToActivity(self,finaltbl)
	if finaltbl == false then return false end -- Vesdah yegher vor minag tevov animation-er e gernan antsnel!
	self.CurrentAnim_IdleStand = finaltbl
	if (hasanim == true && CurTime() > self.NextIdleStandTime) then
		if (self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC) then
			if /*self:GetSequence() == 0 or*/ self:BusyWithActivity() == true then return end
			self:AAMove_Stop()
			self:VJ_ACT_PLAYACTIVITY(finaltbl, false, 0, false, 0, {SequenceDuration=false, SequenceInterruptible=true}) // AlwaysUseSequence=true
		end
		if self.CurrentSchedule == nil then -- Yete ooresh pame chenergor
			self:StartEngineTask(GetTaskList("TASK_RESET_ACTIVITY"), 0) -- Asiga chi tenesne yerp vor nouyn animation-e enen ne yedev yedevi, ge sarin
		end
		self:StartEngineTask(GetTaskList("TASK_PLAY_SEQUENCE"),finaltbl)
		timer.Simple(0.1,function() -- 0.1 hedvargyan espase minchevor khaghe pokhe animation e
			if IsValid(self) then
				local curseq = self:GetSequence()
				if VJ_SequenceToActivity(self,self:GetSequenceName(curseq)) == finaltbl then -- Nayir yete himagva animation e nooynene
					self.NextIdleStandTime = CurTime() + ((self:SequenceDuration(curseq) - 0.15) / self:GetPlaybackRate()) -- Yete nooynene ooremen jamanage tir animation-en yergarootyan chap!
				end
			end
		end)
		self.NextIdleStandTime = CurTime() + 0.15 //self:SequenceDuration(self:SelectWeightedSequence(finaltbl))
	end
	//self:StartEngineTask(GetTaskList("TASK_PLAY_SEQUENCE"),finaltbl)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoIdleAnimation(iType)
	if self:GetState() == VJ_STATE_ONLY_ANIMATION_CONSTANT or self.Dead == true or self.VJ_IsBeingControlled == true or self.PlayingAttackAnimation == true or (self.NextIdleTime > CurTime()) or (self.CurrentSchedule != nil && self.CurrentSchedule.Name == "vj_act_resetenemy") then return end
	iType = iType or 0 -- 0 = Random | 1 = Wander | 2 = Idle Stand
	
	if self.IdleAlwaysWander == true then iType = 1 end
	
	-- Things that override can't bypass, Forces the NPC to ONLY idle stand!
	if self.DisableWandering == true or self.IsGuard == true or self.MovementType == VJ_MOVETYPE_STATIONARY or self.IsVJBaseSNPC_Tank == true or self.LastHiddenZone_CanWander == false or self.NextWanderTime > CurTime() or self.FollowingPlayer == true or self.Medic_IsHealingAlly == true then
		iType = 2
	end
	
	if iType == 0 then -- Random (Wander & Idle Stand)
		if math.random(1,3) == 1 then
			self:VJ_TASK_IDLE_WANDER() else self:VJ_TASK_IDLE_STAND()
		end
	elseif iType == 1 then -- Wander
		self:VJ_TASK_IDLE_WANDER()
	elseif iType == 2 then -- Idle Stand
		self:VJ_TASK_IDLE_STAND()
		return -- Don't set self.NextWanderTime below
	end
	
	if self.AA_ConstantlyMove != true then
		self.NextWanderTime = CurTime() + math.Rand(3,6) // self.NextIdleTime
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoChaseAnimation(alwaysChase)
	local ene = self:GetEnemy()
	if self:GetState() == VJ_STATE_ONLY_ANIMATION_CONSTANT or self.Dead == true or self.VJ_IsBeingControlled == true or self.Flinching == true or self.IsVJBaseSNPC_Tank == true or !IsValid(ene) or (self.NextChaseTime > CurTime()) or (CurTime() < self.TakingCoverT) or (self.PlayingAttackAnimation == true && self.MovementType != VJ_MOVETYPE_AERIAL && self.MovementType != VJ_MOVETYPE_AQUATIC) then return end
	if self:VJ_GetNearestPointToEntityDistance(ene) < self.MeleeAttackDistance && ene:Visible(self) && (self:GetSightDirection():Dot((ene:GetPos() - self:GetPos()):GetNormalized()) > math.cos(math.rad(self.MeleeAttackAngleRadius))) then self:AAMove_Stop() self:VJ_TASK_IDLE_STAND() return end -- Not melee attacking yet but it is in range, so stop moving!
	
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
	if self:IsUnreachable(ene) == true && (self.HasRangeAttack == true or math.random(1, 30) == 1) then
		self:RememberUnreachable(ene, 2)
		if self.HasRangeAttack == true then -- Ranged NPCs
			self:VJ_TASK_CHASE_ENEMY(true)
		else -- Non-range NPCs
			if !self:IsMoving() then
				self.NextWanderTime = 0
			end
			self:DoIdleAnimation(1)
		end
	else -- Is reachable, so chase the enemy!
		self:VJ_TASK_CHASE_ENEMY()
	end
	
	-- Set the next chase time
	if self.NextChaseTime > CurTime() then return end -- Don't set it if it's already set!
	self.NextChaseTime = CurTime() + (((self.LatestEnemyDistance > 2000) and 1) or 0.1) -- If the enemy is far, increase the delay!
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BusyWithActivity()
	return self.vACT_StopAttacks == true or self.PlayingAttackAnimation == true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Touch(entity)
	if self.VJDEBUG_SNPC_ENABLED == true && GetConVarNumber("vj_npc_printontouch") == 1 then print(self:GetClass().." Has Touched "..entity:GetClass()) end
	self:CustomOnTouch(entity)
	if GetConVarNumber("ai_disabled") == 1 or self.VJ_IsBeingControlled == true then return end
	
	-- If it's a passive SNPC...
	if self.Behavior == VJ_BEHAVIOR_PASSIVE or self.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE then
		if self.Passive_RunOnTouch == true && CurTime() > self.Passive_NextRunOnTouchT && entity.Behavior != VJ_BEHAVIOR_PASSIVE && entity.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE && self:DoRelationshipCheck(entity) != false && (entity:IsNPC() or entity:IsPlayer()) then
			self:VJ_TASK_COVER_FROM_ENEMY("TASK_RUN_PATH")
			self:PlaySoundSystem("Alert")
			self.Passive_NextRunOnTouchT = CurTime() + math.Rand(self.Passive_NextRunOnTouchTime.a, self.Passive_NextRunOnTouchTime.b)
		end
	elseif self.DisableTouchFindEnemy == false && !IsValid(self:GetEnemy()) && self.FollowingPlayer == false && (entity:IsNPC() or entity:IsPlayer()) && self:DoRelationshipCheck(entity) != false then
		self:StopMoving()
		self:SetTarget(entity)
		self:VJ_TASK_FACE_X("TASK_FACE_TARGET")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AcceptInput(key, activator, caller, data)
	self:CustomOnAcceptInput(key, activator, caller, data)
	if key == self.FollowPlayerKey then self:FollowPlayerCode(key, activator, caller, data) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleAnimEvent(ev, evTime, evCycle, evType, evOptions)
	self:CustomOnHandleAnimEvent(ev, evTime, evCycle, evType, evOptions)
	/*
	print("----------------------------")
	print(ev)
	print(evTime)
	print(evCycle)
	print(evType)
	print(evOptions)
	*/
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCondition(cond)
	self:CustomOnCondition(cond)
	//if cond == 36 then print("sched done!") end
	//if cond != 15 && cond != 60 then
	//if cond != 1 then
		//print(self," Condition: ",cond," - ",self:ConditionName(cond))
	//end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FollowPlayerReset()
	if self.AllowPrintingInChat == true && self.FollowPlayerChat == true then
		if self.Dead == true then
			self.FollowPlayer_Entity:PrintMessage(HUD_PRINTTALK, self:GetName().." has been killed.")
		else
			self.FollowPlayer_Entity:PrintMessage(HUD_PRINTTALK, self:GetName().." is no longer following you.")
		end
	end
	self.FollowingPlayer = false
	self.FollowPlayer_GoingAfter = false
	self.FollowPlayer_Entity = NULL
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FollowPlayerCode(key, activator, caller, data)
	if self.Dead == true or self.FollowPlayer == false or GetConVarNumber("ai_disabled") == 1 or GetConVarNumber("ai_ignoreplayers") == 1 then return end
	
	if IsValid(activator) && activator:IsPlayer() && activator:Alive() then
		if self:Disposition(activator) == D_HT then -- If it's an enemy
			if self.AllowPrintingInChat == true && self.FollowPlayerChat == true then
				activator:PrintMessage(HUD_PRINTTALK, self:GetName().." is hostile to you, therefore it won't follow you.")
			end
			return
		elseif self:Disposition(activator) == D_NU then -- If it's neutral
			if self.AllowPrintingInChat == true && self.FollowPlayerChat == true then
				activator:PrintMessage(HUD_PRINTTALK, self:GetName().." is neutral to you, therefore it won't follow you.")
			end
			return
		elseif self.FollowingPlayer == true && activator != self.FollowPlayer_Entity then -- Already following a player
			if self.AllowPrintingInChat == true && self.FollowPlayerChat == true then
				activator:PrintMessage(HUD_PRINTTALK, self:GetName().." is already following another player, therefore it won't follow you.")
			end
			return
		end
		
		self:CustomOnFollowPlayer(key, activator, caller, data)
		if self.MovementType == VJ_MOVETYPE_STATIONARY or self.MovementType == VJ_MOVETYPE_PHYSICS then
			if self.AllowPrintingInChat == true && self.FollowPlayerChat == true then
				activator:PrintMessage(HUD_PRINTTALK, self:GetName().." is currently stationary, therefore it's unable follow you.")
			end
			return
		end
		
		if self.FollowingPlayer == false then
			if self.AllowPrintingInChat == true && self.FollowPlayerChat == true then
				activator:PrintMessage(HUD_PRINTTALK, self:GetName().." is now following you.")
			end
			self.GuardingPosition = nil -- Reset the guarding position
			self.GuardingFacePosition = nil
			self.FollowPlayer_Entity = activator
			self.FollowingPlayer = true
			self:PlaySoundSystem("FollowPlayer")
			self:SetTarget(activator)
			if self:BusyWithActivity() == false then -- Face the player and then walk or run to it
				self:StopMoving()
				self:VJ_TASK_FACE_X("TASK_FACE_TARGET", function(x)
					x.RunCode_OnFinish = function()
						local movet = ((self:GetPos():Distance(self.FollowPlayer_Entity:GetPos()) < 220) and "TASK_WALK_PATH") or "TASK_RUN_PATH"
						self:VJ_TASK_GOTO_TARGET(movet, function(y) y.CanShootWhenMoving = true y.ConstantlyFaceEnemy = true end) 
					end
				end)
			end
		else -- Unfollow the player
			self:PlaySoundSystem("UnFollowPlayer")
			self:StopMoving()
			self.NextWanderTime = CurTime() + 2
			if self:BusyWithActivity() == false then
				self:VJ_TASK_FACE_X("TASK_FACE_TARGET")
			end
			self:FollowPlayerReset()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoMedicCode_Reset()
	self:CustomOnMedic_OnReset()
	if IsValid(self.Medic_CurrentEntToHeal) then self.Medic_CurrentEntToHeal.AlreadyBeingHealedByMedic = false end
	if IsValid(self.Medic_SpawnedProp) then self.Medic_SpawnedProp:Remove() end
	self.Medic_NextHealT = CurTime() + math.Rand(self.Medic_NextHealTime.a, self.Medic_NextHealTime.b)
	self.Medic_IsHealingAlly = false
	self.AlreadyDoneMedicThinkCode = false
	self.Medic_CurrentEntToHeal = NULL
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoMedicCode()
	if self.IsMedicSNPC == false then return end
	if self.Medic_IsHealingAlly == false then
		if CurTime() < self.Medic_NextHealT or self.VJ_IsBeingControlled == true then return end
		for _,v in ipairs(ents.FindInSphere(self:GetPos(), self.Medic_CheckDistance)) do
			if v.IsVJBaseSNPC != true && !v:IsPlayer() then continue end -- If it's not a VJ Base SNPC or a player, then move on
			if v:EntIndex() != self:EntIndex() && v.AlreadyBeingHealedByMedic != true && (!v.IsVJBaseSNPC_Tank) && (v:Health() <= v:GetMaxHealth() * 0.75) && ((v.Medic_CanBeHealed == true && !IsValid(self:GetEnemy()) && !IsValid(v:GetEnemy())) or (v:IsPlayer() && GetConVarNumber("ai_ignoreplayers") == 0)) && self:DoRelationshipCheck(v) == false then
				self.Medic_CurrentEntToHeal = v
				self.Medic_IsHealingAlly = true
				self.AlreadyDoneMedicThinkCode = false
				v.AlreadyBeingHealedByMedic = true
				self:StopMoving()
				self:SetTarget(v)
				self:VJ_TASK_GOTO_TARGET()
				return
			end
		end
	elseif self.AlreadyDoneMedicThinkCode == false then
		if !IsValid(self.Medic_CurrentEntToHeal) or VJ_IsAlive(self.Medic_CurrentEntToHeal) != true or (self.Medic_CurrentEntToHeal:Health() > self.Medic_CurrentEntToHeal:GetMaxHealth() * 0.75) then self:DoMedicCode_Reset() return end
		if self:GetPos():Distance(self.Medic_CurrentEntToHeal:GetPos()) <= self.Medic_HealDistance then -- Are we in healing distance?
			self.AlreadyDoneMedicThinkCode = true
			self:CustomOnMedic_BeforeHeal()
			self:PlaySoundSystem("MedicBeforeHeal")
			
			-- Spawn the prop
			if self.Medic_SpawnPropOnHeal == true && self:LookupAttachment(self.Medic_SpawnPropOnHealAttachment) != 0 then
				self.Medic_SpawnedProp = ents.Create("prop_physics")
				self.Medic_SpawnedProp:SetModel(self.Medic_SpawnPropOnHealModel)
				self.Medic_SpawnedProp:SetLocalPos(self:GetPos())
				self.Medic_SpawnedProp:SetOwner(self)
				self.Medic_SpawnedProp:SetParent(self)
				self.Medic_SpawnedProp:Fire("SetParentAttachment", self.Medic_SpawnPropOnHealAttachment)
				self.Medic_SpawnedProp:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
				self.Medic_SpawnedProp:Spawn()
				self.Medic_SpawnedProp:Activate()
				self.Medic_SpawnedProp:SetSolid(SOLID_NONE)
				//self.Medic_SpawnedProp:AddEffects(EF_BONEMERGE)
				self.Medic_SpawnedProp:SetRenderMode(RENDERMODE_TRANSALPHA)
				self:DeleteOnRemove(self.Medic_SpawnedProp)
			end
			
			local anim = VJ_PICK(self.AnimTbl_Medic_GiveHealth)
			self:FaceCertainEntity(self.Medic_CurrentEntToHeal, false)
			if self.Medic_DisableAnimation != true then
				self:VJ_ACT_PLAYACTIVITY(anim, true, false, false)
			end
			
			-- Make the ally turn and look at me
			local noturn = (self.Medic_CurrentEntToHeal.MovementType == VJ_MOVETYPE_STATIONARY and self.Medic_CurrentEntToHeal.CanTurnWhileStationary == false) or false
			if !self.Medic_CurrentEntToHeal:IsPlayer() && noturn == false then
				self.NextWanderTime = CurTime() + 2
				self.NextChaseTime = CurTime() + 2
				self.Medic_CurrentEntToHeal:StopMoving()
				self.Medic_CurrentEntToHeal:SetTarget(self)
				self.Medic_CurrentEntToHeal:VJ_TASK_FACE_X("TASK_FACE_TARGET")
			end
			
			timer.Simple(self:DecideAnimationLength(anim, self.Medic_TimeUntilHeal, 0), function()
				if IsValid(self) then
					if !IsValid(self.Medic_CurrentEntToHeal) then -- Ally doesn't exist anymore, reset
						self:DoMedicCode_Reset()
					else -- If it exists...
						if self:GetPos():Distance(self.Medic_CurrentEntToHeal:GetPos()) <= self.Medic_HealDistance then -- Are we still in healing distance?
							self:CustomOnMedic_OnHeal()
							self:PlaySoundSystem("MedicOnHeal")
							if self.Medic_CurrentEntToHeal.IsVJBaseSNPC == true then
								self.Medic_CurrentEntToHeal:PlaySoundSystem("MedicReceiveHeal")
							end
							self.Medic_CurrentEntToHeal:RemoveAllDecals()
							local fricurhp = self.Medic_CurrentEntToHeal:Health()
							self.Medic_CurrentEntToHeal:SetHealth(math.Clamp(fricurhp + self.Medic_HealthAmount, fricurhp, self.Medic_CurrentEntToHeal:GetMaxHealth()))
							self:DoMedicCode_Reset()
						else -- If we are no longer in healing distance, go after the ally again
							self.AlreadyDoneMedicThinkCode = false
							if IsValid(self.Medic_SpawnedProp) then self.Medic_SpawnedProp:Remove() end
							self:CustomOnMedic_OnReset()
						end
					end
				end
			end)
		else -- If we aren't in healing distance, then go after the ally
			self.NextIdleTime = CurTime() + 4
			self.NextChaseTime = CurTime() + 4
			self:SetTarget(self.Medic_CurrentEntToHeal)
			self:VJ_TASK_GOTO_TARGET()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoConstantlyFaceEnemyCode()
	if self.VJ_IsBeingControlled == true or self.ConstantlyFaceEnemy != true then return false end
	if self:GetEnemy():GetPos():Distance(self:GetPos()) < self.ConstantlyFaceEnemyDistance then
		if self.ConstantlyFaceEnemy_IfVisible == true && !self:Visible(self:GetEnemy()) then return false end -- Only face if the enemy is visible!
		if self.ConstantlyFaceEnemy_IfAttacking == false && (self.MeleeAttacking == true or self.LeapAttacking == true or self.RangeAttacking == true or self.ThrowingGrenade == true) then return false end
		if (self.ConstantlyFaceEnemy_Postures == "Both") or (self.ConstantlyFaceEnemy_Postures == "Moving" && self:IsMoving()) or (self.ConstantlyFaceEnemy_Postures == "Standing" && !self:IsMoving()) then
			self:FaceCertainEntity(self:GetEnemy())
			return true
		end
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	self:SetCondition(1) -- Fix attachments, bones, positions, angles etc. being broken in NPCs! This condition is used as a backup in case sv_pvsskipanimation isn't disabled!
	
	//self:SetPoseParameter("move_yaw",180)
	
	// if self:IsUnreachable(self:GetEnemy()) && enemy noclipping then...

	//if self.AA_TargetPos.x == self:GetPos().x then
		-- to be coded..
	//end
	
	//if self.CurrentSchedule != nil then PrintTable(self.CurrentSchedule) end
	//if self.CurrentTask != nil then PrintTable(self.CurrentTask) end
	if self.MovementType == VJ_MOVETYPE_GROUND && self:GetVelocity():Length() <= 0 /*&& CurSched.IsMovingTask == true*/ then self:DropToFloor() end

	local CurSched = self.CurrentSchedule
	if CurSched != nil then
		if self:IsMoving() then
			if CurSched.IsMovingTask_Walk == true && !VJ_HasValue(self.AnimTbl_Walk,self:GetMovementActivity()) then
				self:SetMovementActivity(VJ_PICK(self.AnimTbl_Walk))
			end
			if CurSched.IsMovingTask_Run == true && !VJ_HasValue(self.AnimTbl_Run,self:GetMovementActivity()) then
				self:SetMovementActivity(VJ_PICK(self.AnimTbl_Run))
			end
		end
		local blockingEnt = self:GetBlockingEntity()
		if self.CanOpenDoors && IsValid(blockingEnt) && (blockingEnt:GetClass() == "func_door" or blockingEnt:GetClass() == "func_door_rotating") && (blockingEnt:HasSpawnFlags(256) or blockingEnt:HasSpawnFlags(1024)) && !blockingEnt:HasSpawnFlags(512) then
			//self:SetSaveValue("m_flMoveWaitFinished", 1)
			blockingEnt:Fire("Open")
		end
		if (CurSched.StopScheduleIfNotMoving == true or CurSched.StopScheduleIfNotMoving_Any == true) && (!self:IsMoving() or (IsValid(blockingEnt) && (blockingEnt:IsNPC() or CurSched.StopScheduleIfNotMoving_Any == true))) then // (self:GetGroundSpeedVelocity():Length() <= 0) == true
			self:ScheduleFinished(CurSched)
			//self:SetCondition(35)
			//self:StopMoving()
		end
		if self:HasCondition(35) then
			if CurSched.AlreadyRanCode_OnFail == false && self:DoRunCode_OnFail(CurSched) == true then
				self:ClearCondition(35)
			end
			if CurSched.ResetOnFail == true then
				self:StopMoving()
				//self:SelectSchedule()
				self:ClearCondition(35)
				//print("VJ Base: Task Failed Condition Identified! "..self:GetName())
			end
		end
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
	if GetConVarNumber("ai_disabled") == 0 && self:GetState() != VJ_STATE_FREEZE then
		if self.VJDEBUG_SNPC_ENABLED == true then
			if GetConVarNumber("vj_npc_printcurenemy") == 1 then print(self:GetClass().."'s Enemy: ",self:GetEnemy()," Alerted? ",self.Alerted) end
			if GetConVarNumber("vj_npc_printalerted") == 1 then if self.Alerted == true then print(self:GetClass().." Is Alerted!") else print(self:GetClass().." Is Not Alerted!") end end
			if GetConVarNumber("vj_npc_printtakingcover") == 1 then if CurTime() > self.TakingCoverT == true then print(self:GetClass().." Is Not Taking Cover") else print(self:GetClass().." Is Taking Cover ("..self.TakingCoverT-CurTime()..")") end end
			if GetConVarNumber("vj_npc_printlastseenenemy") == 1 then PrintMessage(HUD_PRINTTALK, self.LastSeenEnemyTime.." ("..self:GetName()..")") end
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
			-- Yete chouri e YEV leman marmine chourin mech-e che, ere vor gena yev kharen kal e
			if self.MovementType == VJ_MOVETYPE_AQUATIC && self:WaterLevel() <= 2 && self:GetVelocity():Length() > 0 then
				self:AAMove_Wander(true, true)
			end
			if self.AA_CanPlayMoveAnimation == true && self:GetVelocity():Length() > 0 then
				self:AAMove_Animation()
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
		if self.AA_CurrentTurnAng != false then
			local setangs = self.AA_CurrentTurnAng
			self:SetAngles(Angle(setangs.p, self:GetAngles().y, setangs.r))
			self:SetIdealYawAndUpdate(setangs.y)
			//self:SetAngles(Angle(math.ApproachAngle(self:GetAngles().p, self.AA_CurrentTurnAng.p, self.TurningSpeed),math.ApproachAngle(self:GetAngles().y, self.AA_CurrentTurnAng.y, self.TurningSpeed),math.ApproachAngle(self:GetAngles().r, self.AA_CurrentTurnAng.r, self.TurningSpeed)))
		end

		-- Turn to the current face position
		if self.IsDoingFacePosition != false then
			local setangs = self.IsDoingFacePosition
			self:SetAngles(Angle(setangs.p, self:GetAngles().y, setangs.r))
			self:SetIdealYawAndUpdate(setangs.y)
		end
		
		if self.Dead == false then
			if IsValid(ene) then
				self:DoConstantlyFaceEnemyCode()
				if self.IsDoingFaceEnemy == true or (self.CombatFaceEnemy == true && self.CurrentSchedule != nil && ((self.CurrentSchedule.ConstantlyFaceEnemy == true) or (self.CurrentSchedule.ConstantlyFaceEnemyVisible == true && self:Visible(ene)))) then
					local setangs = self:VJ_ReturnAngle((ene:GetPos() - self:GetPos()):Angle())
					self:SetAngles(Angle(setangs.p, self:GetAngles().y, setangs.r))
					self:SetIdealYawAndUpdate(setangs.y)
				end
				-- Set the enemy variables
				self.ResetedEnemy = false
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
				if self.VJ_IsBeingControlled != true && self.NoChaseAfterCertainRange == true && ((self.NoChaseAfterCertainRange_Type == "OnlyRange" && self.HasRangeAttack == true) or (self.NoChaseAfterCertainRange_Type == "Regular")) then
					local fardist = self.NoChaseAfterCertainRange_FarDistance
					local closedist = self.NoChaseAfterCertainRange_CloseDistance
					if fardist == "UseRangeDistance" then fardist = self.RangeDistance end
					if closedist == "UseRangeDistance" then closedist = self.RangeToMeleeDistance end
					if (self.LatestEnemyDistance < fardist) && (self.LatestEnemyDistance > closedist) && ene:Visible(self) /*&& self:CanDoCertainAttack("RangeAttack") == true*/ then
						self.RangeAttack_DisableChasingEnemy = true
						if self.CurrentSchedule != nil && self.CurrentSchedule.Name == "vj_chase_enemy" then self:StopMoving() end
						if self.MovementType == VJ_MOVETYPE_GROUND && !self:IsMoving() then self:FaceCertainEntity(self:GetEnemy()) end
						if (self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC) && CurTime() > self.AA_MoveLength_Wander /*&& ((self.AA_CurrentMoveAnimationType != "Calm") or (self.AA_CurrentMoveAnimationType == "Calm" && self:GetVelocity():Length() > 0))*/ then self:AAMove_Wander(true,false) /*self:AAMove_Stop()*/ end
					else
						self.RangeAttack_DisableChasingEnemy = false
						if self.CurrentSchedule != nil && self.CurrentSchedule.Name != "vj_chase_enemy" then self:DoChaseAnimation() end
						//if GetConVarNumber("vj_npc_nochasingenemy") == 0 then self.DisableChasingEnemy = true end else
						//if GetConVarNumber("vj_npc_nochasingenemy") == 0 then self.DisableChasingEnemy = false end
					end
				end
			end

			if CurTime() > self.NextProcessT then
				self:DoEntityRelationshipCheck()
				self:DoMedicCode()
				self.NextProcessT = CurTime() + self.NextProcessTime
			end

			if self.ResetedEnemy == false then
				-- Reset enemy if it doesn't exist or it's dead
				if (!IsValid(self:GetEnemy())) or (IsValid(self:GetEnemy()) && self:GetEnemy():Health() <= 0) then
					self.ResetedEnemy = true
					self:ResetEnemy(true)
				end

				-- Reset enemy if it has been unseen for a while
				if self.LastSeenEnemyTime > self.LastSeenEnemyTimeUntilReset && (!self.IsVJBaseSNPC_Tank) then
					self:PlaySoundSystem("LostEnemy")
					self.ResetedEnemy = true
					self:ResetEnemy(true)
				end
			end

			--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
				-- Attack Timers --
			if self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then
				if IsValid(ene) && self.PlayingAttackAnimation == true && self:VJ_GetNearestPointToEntityDistance(ene) < self.MeleeAttackDistance then
					self:AAMove_Stop()
				else
					self:SelectSchedule()
				end
			end
			ene = self:GetEnemy()
			if IsValid(ene) then
				self:DoPoseParameterLooking()
				if (self.MovementType == VJ_MOVETYPE_STATIONARY && self.CanTurnWhileStationary == true) or (self.MeleeAttackAnimationFaceEnemy == true && self.MeleeAttack_DoingPropAttack == false && self.MeleeAttacking == true) or (self.RangeAttackAnimationFaceEnemy == true && self.RangeAttacking == true) or (self.LeapAttackAnimationFaceEnemy == true && self.LeapAttacking == true) then
					self:FaceCertainEntity(ene, true)
				end
				self.ResetedEnemy = false
				self.NearestPointToEnemyDistance = self:VJ_GetNearestPointToEntityDistance(ene)

				self:CustomAttack() -- Custom attack

				-- Melee Attack --------------------------------------------------------------------------------------------------------------------------------------------
				if self.HasMeleeAttack == true && self:CanDoCertainAttack("MeleeAttack") == true then
					self:MultipleMeleeAttacks()
					local attacktype = 0 -- 0 = No attack | 1 = Normal attack | 2 = Prop attack
					if (self.VJ_IsBeingControlled == true && self.VJ_TheController:KeyDown(IN_ATTACK)) or (self.VJ_IsBeingControlled == false && self.NearestPointToEnemyDistance < self.MeleeAttackDistance && ene:Visible(self)) then
						attacktype = 1
					elseif self:PushOrAttackPropsCode() == true && self.MeleeAttack_NoProps == false then
						attacktype = 2
					end
					if self:CustomAttackCheck_MeleeAttack() == true && ((self.VJ_IsBeingControlled == true && attacktype == 1) or (self.VJ_IsBeingControlled == false && attacktype != 0 && (self:GetSightDirection():Dot((ene:GetPos() - self:GetPos()):GetNormalized()) > math.cos(math.rad(self.MeleeAttackAngleRadius))))) then
						local seed = CurTime(); self.CurAttackSeed = seed
						self.MeleeAttacking = true
						self.IsAbleToMeleeAttack = false
						self.AlreadyDoneMeleeAttackFirstHit = false
						self.AlreadyDoneFirstMeleeAttack = false
						self.RangeAttacking = false
						self.NextAlertSoundT = CurTime() + 0.4
						if attacktype == 2 then
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
									if attacktype == 2 then
										self:MeleeAttackCode(true)
									else
										self:MeleeAttackCode()
									end
							end end)
							for k, t in ipairs(self.MeleeAttackExtraTimers) do
								self:DoAddExtraAttackTimers("timer_melee_start_"..CurTime() + k, t, function() if self.CurAttackSeed == seed then if attacktype == 2 then
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
							for k, t in ipairs(self.RangeAttackExtraTimers) do
								self:DoAddExtraAttackTimers("timer_range_start_"..CurTime() + k, t, function() if self.CurAttackSeed == seed then self:RangeAttackCode() end end)
							end
						end
						self:CustomOnRangeAttack_AfterStartTimer(seed)
					end
				end

				-- Leap Attack --------------------------------------------------------------------------------------------------------------------------------------------
				if self.HasLeapAttack == true && self:CanDoCertainAttack("LeapAttack") == true then
					self:MultipleLeapAttacks()
					if self:CustomAttackCheck_LeapAttack() == true && ((self.VJ_IsBeingControlled == true && self.VJ_TheController:KeyDown(IN_JUMP)) or (self.VJ_IsBeingControlled == false && (self:IsOnGround() && self.LatestEnemyDistance < self.LeapDistance) && (self.LatestEnemyDistance > self.LeapToMeleeDistance))) then
						local seed = CurTime(); self.CurAttackSeed = seed
						self.LeapAttacking = true
						self.IsAbleToLeapAttack = false
						self.AlreadyDoneLeapAttackFirstHit = false
						self.AlreadyDoneFirstLeapAttack = false
						self.JumpLegalLandingTime = 0
						self:FaceCertainEntity(ene, true)
						self:CustomOnLeapAttack_BeforeStartTimer(seed)
						self:PlaySoundSystem("BeforeRangeAttack")
						timer.Create( "timer_leap_start_jump"..self:EntIndex(), self.TimeUntilLeapAttackVelocity / self:GetPlaybackRate(), 1, function() self:LeapAttackVelocityCode() end)
						if self.DisableLeapAttackAnimation == false then
							self.CurrentAttackAnimation = VJ_PICK(self.AnimTbl_LeapAttack)
							self.CurrentAttackAnimationDuration = self:DecideAnimationLength(self.CurrentAttackAnimation, false, self.LeapAttackAnimationDecreaseLengthAmount)
							self.PlayingAttackAnimation = true
							timer.Create("timer_act_playingattack"..self:EntIndex(), self.CurrentAttackAnimationDuration, 1, function() self.PlayingAttackAnimation = false end)
							self:VJ_ACT_PLAYACTIVITY(self.CurrentAttackAnimation,false,0,false,self.LeapAttackAnimationDelay,{SequenceDuration=self.CurrentAttackAnimationDuration})
						end
						if self.TimeUntilLeapAttackDamage == false then
							self:LeapAttackCode_DoFinishTimers()
						else -- If it's not event based...
							timer.Create( "timer_leap_start"..self:EntIndex(), self.TimeUntilLeapAttackDamage / self:GetPlaybackRate(), self.LeapAttackReps, function() if self.CurAttackSeed == seed then self:LeapDamageCode() end end)
							for k, t in ipairs(self.LeapAttackExtraTimers) do
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
				if self.ResetedEnemy == false && (!self.IsVJBaseSNPC_Tank) then self:PlaySoundSystem("LostEnemy") self.ResetedEnemy = true self:ResetEnemy(true) end
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
		if self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then self:AAMove_Stop() end
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
function ENT:DoAddExtraAttackTimers(name, time, func)
	name = name or "timer_unknown"
	
	self.TimersToRemove[#self.TimersToRemove + 1] = name
	timer.Create(name..self:EntIndex(), (time or 0.5) / self:GetPlaybackRate(), 1, func)
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoPropVisibiltyCheckForPushAttackProps(CheckEnt)
	if CheckEnt == NULL or CheckEnt == nil then return end
	local tr = util.TraceLine({
		start = self:GetPos(),
		endpos = CheckEnt:GetPos() + CheckEnt:GetUp()*10,
		filter = self
	})
	//print(tr.Entity)
	// VJ_CreateTestObject(tr.HitPos)

	if tr.Entity == NULL or tr.HitWorld == true or tr.HitSky == true then
	return false else return true end
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PushOrAttackPropsCode(CustomEnts, CustomMeleeDistance)
	if self.PushProps == false && self.AttackProps == false then return end
	local isprop = VJ_IsProp
	for _,v in pairs(CustomEnts or ents.FindInSphere(self:SetMeleeAttackDamagePosition(), CustomMeleeDistance or math.Clamp(self.MeleeAttackDamageDistance - 30, self.MeleeAttackDistance, self.MeleeAttackDamageDistance))) do
		local isEnt = (self.EntitiesToDestroyClass[v:GetClass()] or v.VJ_AddEntityToSNPCAttackList == true) and true or false -- Whether or not it's a prop or an entity to attack
		if v:GetClass() == "prop_door_rotating" && v:Health() <= 0 then isEnt = false end -- If it's a door and it has no health, then don't attack it!
		if isprop(v) == true or isEnt == true then --If it's a prop or a entity then atttack
			//print(self:DoPropVisibiltyCheckForPushAttackProps(v))
			local phys = v:GetPhysicsObject()
			-- Serpevadz abrankner: self:VJ_GetNearestPointToEntityDistance(v) < (CustomMeleeDistance) && self:Visible(v)
			if IsValid(phys) && self:DoPropVisibiltyCheckForPushAttackProps(v) && (self:GetSightDirection():Dot((v:GetPos() - self:GetPos()):GetNormalized()) > math.cos(math.rad(self.MeleeAttackAngleRadius / 1.3))) && v:GetCollisionGroup() != COLLISION_GROUP_DEBRIS && v:GetCollisionGroup() != COLLISION_GROUP_DEBRIS_TRIGGER && v:GetCollisionGroup() != COLLISION_GROUP_DISSOLVING && v:GetCollisionGroup() != COLLISION_GROUP_IN_VEHICLE then
				if isEnt == true then return true end -- Since it's an entity, no need to check for size etc.
				-- Attack if the prop has health higher than 0
				if self.AttackProps == true && v:Health() > 0 then
					return true
				end
				-- Push the prop if it's not a small object and if the NPC is appropriately sized to push the object
				if self.PushProps == true && phys:GetMass() > 4 && phys:GetSurfaceArea() > 800 then
					local selfphys = self:GetPhysicsObject()
					if IsValid(selfphys) && (selfphys:GetSurfaceArea() * self.PropAP_MaxSize) >= phys:GetSurfaceArea() then
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
		if v != self && v:GetClass() != self:GetClass() && (((v:IsNPC() or (v:IsPlayer() && v:Alive() && GetConVarNumber("ai_ignoreplayers") == 0)) && self:Disposition(v) != D_LI) or VJ_IsProp(v) == true or v:GetClass() == "func_breakable_surf" or self.EntitiesToDestroyClass[v:GetClass()] or v.VJ_AddEntityToSNPCAttackList == true) && self:GetSightDirection():Dot((Vector(v:GetPos().x, v:GetPos().y, 0) - Vector(myPos.x, myPos.y, 0)):GetNormalized()) > math.cos(math.rad(self.MeleeAttackDamageAngleRadius)) then
			if isPropAttack == true && (v:IsPlayer() or v:IsNPC()) && self:VJ_GetNearestPointToEntityDistance(v) > self.MeleeAttackDistance then continue end //if (self:GetPos():Distance(v:GetPos()) <= self:VJ_GetNearestPointToEntityDistance(v) && self:VJ_GetNearestPointToEntityDistance(v) <= self.MeleeAttackDistance) == false then
			if self:CustomOnMeleeAttack_AfterChecks(v) == true then continue end
			local vProp = VJ_IsProp(v)
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
			if self.MeleeAttackSetEnemyOnFire == true then v:Ignite(self.MeleeAttackSetEnemyOnFireTime) end
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
				if self.MeleeAttackDSPSoundType != false && ((self.MeleeAttackDSPSoundUseDamage == false) or (self.MeleeAttackDSPSoundUseDamage == true && self.MeleeAttackDamage >= self.MeleeAttackDSPSoundUseDamageAmount && GetConVarNumber("vj_npc_nomeleedmgdsp") == 0)) then
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
function ENT:VJ_DoSlowPlayer(ent,WalkSpeed,RunSpeed,SlowTime,sdData,ExtraFeatures,customFunc)
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
				phys:SetVelocity(self:RangeAttackCode_GetShootPos(projectile)) //ApplyForceCenter
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
			if (v:IsNPC() or (v:IsPlayer() && v:Alive()) && GetConVarNumber("ai_ignoreplayers") == 0) && (self:Disposition(v) != D_LI) && (v != self) && (v:GetClass() != self:GetClass()) or VJ_IsProp(v) == true or v:GetClass() == "func_breakable_surf" or v:GetClass() == "func_breakable" then
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
		if self.StopLeapAttackAfterFirstHit == true then self.AlreadyDoneLeapAttackFirstHit = true /*self:SetLocalVelocity(Vector(0,0,0))*/ end
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
	self:CustomOnLeapAttackVelocityCode()
	self:PlaySoundSystem("LeapAttackJump")
	self:SetGroundEntity(NULL)
	if self.LeapAttackUseCustomVelocity == true then return end
	if self.LeapAttackAnimationFaceEnemy == true then self:FaceCertainEntity(self:GetEnemy(),true) end
	self:SetLocalVelocity(((self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter()) - (self:GetPos() + self:OBBCenter())):GetNormal()*400 + self:GetForward()*self.LeapAttackVelocityForward + self:GetUp()*self.LeapAttackVelocityUp + self:GetRight()*self.LeapAttackVelocityRight)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StopAttacks(checkTimers)
	if self:Health() <= 0 then return end
	if self.VJDEBUG_SNPC_ENABLED == true && GetConVarNumber("vj_npc_printstoppedattacks") == 1 then print(self:GetClass().." Stopped all Attacks!") end
	
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

	self:DoChaseAnimation()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoPoseParameterLooking(resetPoses)
	if self.HasPoseParameterLooking == false then return end
	resetPoses = resetPoses or false
	//self:VJ_GetAllPoseParameters(true)
	local ent = NULL
	if self.VJ_IsBeingControlled == true then ent = self.VJ_TheController else ent = self:GetEnemy() end
	local p_enemy = 0 -- Pitch
	local y_enemy = 0 -- Yaw
	local r_enemy = 0 -- Roll
	if IsValid(ent) && resetPoses == false then
		local enemy_pos = false
		if self.VJ_IsBeingControlled == true then
			//enemy_pos = self.VJ_TheController:GetEyeTrace().HitPos
			local gettr = util.GetPlayerTrace(self.VJ_TheController) -- Get the player's trace
			local tr = util.TraceLine({start = gettr.start, endpos = gettr.endpos, filter = {self, self.VJ_TheController}}) -- Apply the filter to it (The player and the NPC)
			enemy_pos = tr.HitPos
		else
			enemy_pos = ent:GetPos() + ent:OBBCenter()
		end
		if enemy_pos == false then return end
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
	
	local ang_app = math.ApproachAngle
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
	if IsValid(ene) && (ene:GetPos():Distance(self:GetPos()) > self.SightDistance) then -- If the enemy is out of reach, then reset the enemy!
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
	if self.NextResetEnemyT > CurTime() or self.Dead == true then self.ResetedEnemy = false return false end
	checkAlliesEnemy = checkAlliesEnemy or false
	local RunToEnemyOnReset = false
	if checkAlliesEnemy == true then
		local checkallies = self:Allies_Check(1000)
		if checkallies != nil then
			for _,v in ipairs(checkallies) do
				if IsValid(v:GetEnemy()) && v.LastSeenEnemyTime < self.LastSeenEnemyTimeUntilReset && VJ_IsAlive(v:GetEnemy()) == true && self:VJ_HasNoTarget(v:GetEnemy()) == false && self:GetPos():Distance(v:GetEnemy():GetPos()) <= self.SightDistance then
					self:VJ_DoSetEnemy(v:GetEnemy(),true)
					self.ResetedEnemy = false
					return false
				end
			end
		end
		local curenes = self.ReachableEnemyCount //self.CurrentReachableEnemies
		-- If the current number of reachable enemies is higher then 1, then don't reset
		if (IsValid(self:GetEnemy()) && (curenes - 1) >= 1) or (!IsValid(self:GetEnemy()) && curenes >= 1) then
			//self:VJ_DoSetEnemy(v, false, true)
			self:DoEntityRelationshipCheck() -- Select a new enemy
			self.NextProcessT = CurTime() + self.NextProcessTime
			self.ResetedEnemy = false
			return false
		end
	end
	
	self.Alerted = false
	self:CustomOnResetEnemy()
	if self.VJDEBUG_SNPC_ENABLED == true && GetConVarNumber("vj_npc_printresetenemy") == 1 then print(self:GetName().." has reseted its enemy") end
	if IsValid(self:GetEnemy()) then
		if self.FollowingPlayer == false && self.VJ_PlayingSequence == false && (!self.IsVJBaseSNPC_Tank) && self:GetEnemyLastKnownPos() != vec_worigin then
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
	if !self:BusyWithActivity() && self.IsGuard == false && self.Behavior != VJ_BEHAVIOR_PASSIVE && self.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE && self.VJ_IsBeingControlled == false && RunToEnemyOnReset == true && CurTime() > self.LastHiddenZoneT && self.LastHiddenZone_CanWander == true then
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
		vsched.IsMovingTask_Walk = true
		//self.NextIdleTime = CurTime() + 10
	end
	if vsched.TaskCount > 0 then
		self:StartSchedule(vsched)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoAlert(ent)
	if !IsValid(self:GetEnemy()) or self.Alerted == true then return end
	self.Alerted = true
	self.LastSeenEnemyTime = 0
	self:CustomOnAlert(ent)
	if CurTime() > self.NextAlertSoundT then
		self:PlaySoundSystem("Alert")
		if self.AlertSounds_OnlyOnce == true then
			self.HasAlertSounds = false
		end
		self.NextAlertSoundT = CurTime() + math.Rand(self.NextSoundTime_Alert1,self.NextSoundTime_Alert2)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoRelationshipCheck(ent)
	-- false = Tematsine pari e
	-- "Neutral" = Tematsine ne keshe ne pari e
	-- true == Tematsine tsnami e
	local nt_bool, nt_be = self:VJ_HasNoTarget(ent)
	if nt_be == 1 then return true end
	if nt_bool == true or NPCTbl_Animals[ent:GetClass()] then return "Neutral" end
	if self:GetClass() == ent:GetClass() then return false end
	if ent:Health() > 0 && self:Disposition(ent) != D_LI then
		if ent:IsPlayer() && GetConVarNumber("ai_ignoreplayers") == 1 then return "Neutral" end
		if VJ_HasValue(self.VJ_AddCertainEntityAsFriendly,ent) then return false end
		if VJ_HasValue(self.VJ_AddCertainEntityAsEnemy,ent) then return true end
		if (ent:IsNPC() && !ent.FriendlyToVJSNPCs && ((ent:Disposition(self) == D_HT) or (ent:Disposition(self) == D_NU && ent.VJ_IsBeingControlled == true))) or (ent:IsPlayer() && self.PlayerFriendly == false && ent:Alive()) then
			//if ent.VJ_NoTarget == false then
			//if (ent.VJ_NoTarget) then if ent.VJ_NoTarget == false then continue end end
			return true
		else
			return "Neutral"
		end
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoEntityRelationshipCheck()
	if self.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE /*or self.Behavior == VJ_BEHAVIOR_PASSIVE*/ then return false end
	local posenemies = self.CurrentPossibleEnemies
	if posenemies == nil then return false end
	//if CurTime() > self.NextHardEntityCheckT then
		//self.CurrentPossibleEnemies = self:DoHardEntityCheck()
	//self.NextHardEntityCheckT = CurTime() + math.random(self.NextHardEntityCheck1,self.NextHardEntityCheck2) end
	//print(self:GetName().."'s Enemies:")
	//PrintTable(posenemies)

	/*if table.Count(self.CurrentPossibleEnemies) == 0 && CurTime() > self.NextHardEntityCheckT then
		self.CurrentPossibleEnemies = self:DoHardEntityCheck()
	self.NextHardEntityCheckT = CurTime() + math.random(50,70) end*/
	
	self.ReachableEnemyCount = 0
	//local distlist = {}
	local eneSeen = false
	local myPos = self:GetPos()
	local nearestDist = nil
	local sightDist = self.SightDistance
	local mySDir = self:GetSightDirection()
	local mySAng = math.cos(math.rad(self.SightAngle))
	local it = 1
	//for k, v in ipairs(posenemies) do
	//for it = 1, #posenemies do
	while it <= #posenemies do
		local v = posenemies[it]
		if !IsValid(v) then
			table_remove(posenemies, it)
		else
			it = it + 1
			//if !IsValid(v) then table_remove(self.CurrentPossibleEnemies,tonumber(v)) continue end
			//if !IsValid(v) then continue end
			if self:VJ_HasNoTarget(v) == true then
				if IsValid(self:GetEnemy()) && self:GetEnemy() == v then
					self:ResetEnemy(false)
				end
				continue
			end
			//if v:Health() <= 0 then table_remove(self.CurrentPossibleEnemies,k) continue end
			local vPos = v:GetPos()
			local vDistanceToMy = vPos:Distance(myPos)
			if vDistanceToMy > sightDist then continue end
			local entFri = false
			local vClass = v:GetClass()
			local vNPC = v:IsNPC()
			local vPlayer = v:IsPlayer()
			if vClass != self:GetClass() && (vNPC or vPlayer) && (v.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE) /*&& MyVisibleTov && self:Disposition(v) != D_LI*/ then
				local inEneTbl = VJ_HasValue(self.VJ_AddCertainEntityAsEnemy, v)
				if self.HasAllies == true && inEneTbl == false then
					for _,friclass in ipairs(self.VJ_NPC_Class) do
						if friclass == varCPly && self.PlayerFriendly == false then self.PlayerFriendly = true end -- If player ally then set the PlayerFriendly to true
						if (friclass == varCCom && NPCTbl_Combine[vClass]) or (friclass == varCZom && NPCTbl_Zombies[vClass]) or (friclass == varCAnt && NPCTbl_Antlions[vClass]) or (friclass == varCXen && NPCTbl_Xen[vClass]) then
							v:AddEntityRelationship(self, D_LI, 99)
							self:AddEntityRelationship(v, D_LI, 99)
							entFri = true
						end
						if (v.VJ_NPC_Class && VJ_HasValue(v.VJ_NPC_Class, friclass)) or (entFri == true) then
							if friclass == varCPly then -- If we have the player ally class then check if we both of us are supposed to be friends
								if self.FriendsWithAllPlayerAllies == true && v.FriendsWithAllPlayerAllies == true then
									entFri = true
									if vNPC then v:AddEntityRelationship(self, D_LI, 99) end
									self:AddEntityRelationship(v, D_LI, 99)
								end
							else
								entFri = true
								-- If I am enemy to it, then reset it!
								if IsValid(self:GetEnemy()) && self:GetEnemy() == v then
									self.ResetedEnemy = true
									self:ResetEnemy(false)
								end
								if vNPC then v:AddEntityRelationship(self, D_LI, 99) end
								self:AddEntityRelationship(v, D_LI, 99)
							end
						end
					end
					if vNPC && !entFri then
						-- Deprecated system
						/*for _,fritbl in ipairs(self.VJ_FriendlyNPCsGroup) do
							if string_find(vClass, fritbl) then
								entFri = true
								v:AddEntityRelationship(self, D_LI, 99)
								self:AddEntityRelationship(v, D_LI, 99)
							end
						end
						if VJ_HasValue(self.VJ_FriendlyNPCsSingle,vClass) then
							entFri = true
							v:AddEntityRelationship(self, D_LI, 99)
							self:AddEntityRelationship(v, D_LI, 99)
						end*/
						-- Mostly used for non-VJ friendly NPCs
						if self.PlayerFriendly == true && (NPCTbl_Resistance[vClass] or (self.FriendsWithAllPlayerAllies == true && v.PlayerFriendly == true && v.FriendsWithAllPlayerAllies == true)) then
							v:AddEntityRelationship(self, D_LI, 99)
							self:AddEntityRelationship(v, D_LI, 99)
							entFri = true
						end
						if self.VJFriendly == true && v.IsVJBaseSNPC == true then
							v:AddEntityRelationship(self, D_LI, 99)
							self:AddEntityRelationship(v, D_LI, 99)
							entFri = true
						end
					end
				end
				if entFri == false && vNPC /*&& MyVisibleTov*/ && self.DisableMakingSelfEnemyToNPCs == false && (v.VJ_IsBeingControlled != true) then v:AddEntityRelationship(self, D_HT, 99) end
				if vPlayer then
					if (self.PlayerFriendly == true or entFri == true/* or self:Disposition(v) == D_LI*/) then
						if inEneTbl == false then
							entFri = true
							self:AddEntityRelationship(v, D_LI, 99)
							//DoPlayerSight()
						else
							entFri = false
						end
					end
					if (!self.IsVJBaseSNPC_Tank) && !IsValid(self:GetEnemy()) && entFri == false then
						if entFri == false then self:AddEntityRelationship(v, D_NU, 99) end
						if v:Crouching() && v:GetMoveType() != MOVETYPE_NOCLIP then if self.VJ_IsHugeMonster == true then sightDist = 5000 else sightDist = 2000 end end
						if vDistanceToMy < (self.InvestigateSoundDistance * v.VJ_LastInvestigateSdLevel) && ((CurTime() - v.VJ_LastInvestigateSd) <= 1) then
							if self.NextInvestigateSoundMove < CurTime() then
								if self:Visible(v) then
									self:StopMoving()
									self:SetTarget(v)
									self:VJ_TASK_FACE_X("TASK_FACE_TARGET")
								elseif self.FollowingPlayer == false then
									self:SetLastPosition(vPos)
									self:VJ_TASK_GOTO_LASTPOS("TASK_WALK_PATH")
								end
								self:CustomOnInvestigate(v)
								self:PlaySoundSystem("InvestigateSound")
								self.NextInvestigateSoundMove = CurTime() + 2
							end
						elseif vDistanceToMy < 350 && v:FlashlightIsOn() == true && (v:GetForward():Dot((myPos - vPos):GetNormalized()) > math.cos(math.rad(20))) then
							//			   Asiga hoser ^ (!v:Crouching() && v:GetVelocity():Length() > 0 && v:GetMoveType() != MOVETYPE_NOCLIP && ((!v:KeyDown(IN_WALK) && (v:KeyDown(IN_FORWARD) or v:KeyDown(IN_BACK) or v:KeyDown(IN_MOVELEFT) or v:KeyDown(IN_MOVERIGHT))) or (v:KeyDown(IN_SPEED) or v:KeyDown(IN_JUMP)))) or
							self:SetTarget(v)
							self:VJ_TASK_FACE_X("TASK_FACE_TARGET")
						end
					end
				end
			end
			/*print("----------")
			print(self:HasEnemyEluded(v))
			print(self:HasEnemyMemory(v))
			print(CurTime() - self:GetEnemyLastTimeSeen(v))
			print(CurTime() - self:GetEnemyFirstTimeSeen(v))*/
			-- We have to do this here so we make sure non-VJ NPCs can still target this SNPC!
			if self.VJ_IsBeingControlled == true && self.VJ_TheControllerBullseye != v then
				//self:AddEntityRelationship(v, D_NU, 99)
				v = self.VJ_TheControllerBullseye
				vPlayer = false
			end
			local radiusoverride = 0
			if self.DisableFindEnemy == false && ((self.Behavior == VJ_BEHAVIOR_NEUTRAL && self.Alerted == true) or self.Behavior != VJ_BEHAVIOR_NEUTRAL) && ((self.FindEnemy_CanSeeThroughWalls == true) or (self:Visible(v) && (vDistanceToMy < sightDist))) && ((self.FindEnemy_UseSphere == false && radiusoverride == 0 && (mySDir:Dot((vPos - myPos):GetNormalized()) > mySAng)) or (self.FindEnemy_UseSphere == true or radiusoverride == 1)) then
				local check = self:DoRelationshipCheck(v)
				if check == true then -- Is enemy
					eneSeen = true
					self.ReachableEnemyCount = self.ReachableEnemyCount + 1
					self:AddEntityRelationship(v, D_HT, 99)
					-- If the detected enemy is closer than the previous enemy, the set this as the enemy!
					if (nearestDist == nil) or (vDistanceToMy < nearestDist) then
						nearestDist = vDistanceToMy
						self:VJ_DoSetEnemy(v, true, true)
					end
				-- If the current enemy is a friendly player, then reset the enemy!
				elseif check == false && vPlayer && IsValid(self:GetEnemy()) && self:GetEnemy() == v then
					self.ResetedEnemy = true
					self:ResetEnemy(false)
				end
			end
			if vPlayer then
				if entFri == true && self.MoveOutOfFriendlyPlayersWay == true && self.IsGuard == false && !self:IsMoving() && CurTime() > self.TakingCoverT && self.VJ_IsBeingControlled == false && (!self.IsVJBaseSNPC_Tank) && self:BusyWithActivity() == false then
					local dist = 20
					if self.FollowingPlayer == true then dist = 10 end
					if /*self:Disposition(v) == D_LI &&*/ (self:VJ_GetNearestPointToEntityDistance(v) < dist) && v:GetVelocity():Length() > 0 && v:GetMoveType() != MOVETYPE_NOCLIP then
						self.NextFollowPlayerT = CurTime() + 2
						self:PlaySoundSystem("MoveOutOfPlayersWay")
						//self:SetLastPosition(self:GetPos() + self:GetRight()*math.random(-50,-50))
						self:SetMovementActivity(VJ_PICK(self.AnimTbl_Run))
						local vsched = ai_vj_schedule.New("vj_move_away")
						vsched:EngTask("TASK_MOVE_AWAY_PATH", 120)
						vsched:EngTask("TASK_RUN_PATH", 0)
						vsched:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
						/*vsched.RunCode_OnFinish = function()
							timer.Simple(0.1,function()
								if IsValid(self) then
									self:SetTarget(v)
									local vschedMoveAwayFail = ai_vj_schedule.New("vj_move_away_fail")
									vschedMoveAwayFail:EngTask("TASK_FACE_TARGET", 0)
									self:StartSchedule(vschedMoveAwayFail)
								end
							end)
						end*/
						//vsched.CanShootWhenMoving = true
						//vsched.ConstantlyFaceEnemy = true
						vsched.IsMovingTask = true
						vsched.IsMovingTask_Run = true
						self:StartSchedule(vsched)
						self.TakingCoverT = CurTime() + 0.2
					end
				end
				
				-- HasOnPlayerSight system, used to do certain actions when it sees the player
				if self.HasOnPlayerSight == true && v:Alive() &&(CurTime() > self.OnPlayerSightNextT) && (v:GetPos():Distance(self:GetPos()) < self.OnPlayerSightDistance) && self:Visible(v) && (self:GetSightDirection():Dot((v:GetPos() - self:GetPos()):GetNormalized()) > math.cos(math.rad(self.SightAngle))) then
					-- 0 = Run it every time | 1 = Run it only when friendly to player | 2 = Run it only when enemy to player
					local disp = self.OnPlayerSightDispositionLevel
					if (disp == 0) or (disp == 1 && (self:Disposition(v) == D_LI or self:Disposition(v) == D_NU)) or (disp == 2 && self:Disposition(v) != D_LI) then
						self:CustomOnPlayerSight(v)
						self:PlaySoundSystem("OnPlayerSight")
						if self.OnPlayerSightOnlyOnce == true then -- If it's only suppose to play it once then turn the system off
							self.HasOnPlayerSight = false
						else
							self.OnPlayerSightNextT = CurTime() + math.Rand(self.OnPlayerSightNextTime.a, self.OnPlayerSightNextTime.b)
						end
					end
				end
			end
			self:CustomOnEntityRelationshipCheck(v, entFri, vDistanceToMy)
		end
		//return true
	end
	if eneSeen == true then return true else return false end
	//return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Allies_CallHelp(SeeDistance)
	if self.CallForHelp == false or self.ThrowingGrenade == true then return false end
	local entsTbl = ents.FindInSphere(self:GetPos(), SeeDistance)
	if (!entsTbl) then return false end
	for _,v in pairs(entsTbl) do
		if v:IsNPC() && v != self && v.IsVJBaseSNPC == true && VJ_IsAlive(v) == true && (v:GetClass() == self:GetClass() or v:Disposition(self) == D_LI) && v.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE /*&& v.FollowingPlayer == false*/ && v.VJ_IsBeingControlled == false && (!v.IsVJBaseSNPC_Tank) && v.CallForHelp == true then
			local ene = self:GetEnemy()
			if IsValid(ene) then
				if v:GetPos():Distance(ene:GetPos()) > v.SightDistance then continue end -- Enemy to far away for ally, discontinue!
				//if v:DoRelationshipCheck(ene) == true then
				if !IsValid(v:GetEnemy()) && ((!ene:IsPlayer() && v:Disposition(ene) != D_LI) or (ene:IsPlayer())) then
					if v.IsGuard == true && !v:Visible(ene) then continue end -- If it's guarding and enemy is not visible, then don't call!
					self:CustomOnCallForHelp(v)
					self:PlaySoundSystem("CallForHelp")
					-- Play the animation
					if self.HasCallForHelpAnimation == true && CurTime() > self.NextCallForHelpAnimationT then
						local pickanim = VJ_PICK(self.AnimTbl_CallForHelp)
						self:VJ_ACT_PLAYACTIVITY(pickanim, self.CallForHelpStopAnimations, self:DecideAnimationLength(pickanim, self.CallForHelpStopAnimationsTime), self.CallForHelpAnimationFaceEnemy, self.CallForHelpAnimationDelay, {PlayBackRate=self.CallForHelpAnimationPlayBackRate, PlayBackRateCalculated=true})
						self.NextCallForHelpAnimationT = CurTime() + self.NextCallForHelpAnimationTime
					end
					-- If the enemy is a player and the ally is player-friendly then make that player an enemy to the ally
					if ene:IsPlayer() && v.PlayerFriendly == true then
						v.VJ_AddCertainEntityAsEnemy[#v.VJ_AddCertainEntityAsEnemy + 1] = ene
					end
					v:VJ_DoSetEnemy(ene, true)
					if CurTime() > v.NextChaseTime then
						if v.Behavior != VJ_BEHAVIOR_PASSIVE && v:Visible(ene) then
							v:SetTarget(ene)
							v:VJ_TASK_FACE_X("TASK_FACE_TARGET")
						else
							v:PlaySoundSystem("OnReceiveOrder")
							v:DoChaseAnimation()
						end
					end
				end
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Allies_Check(dist)
	dist = dist or 800 -- How far can it check for allies
	local entsTbl = ents.FindInSphere(self:GetPos(), dist)
	if (!entsTbl) then return end
	local FoundAlliesTbl = {}
	local it = 0
	for _, v in pairs(entsTbl) do
		if VJ_IsAlive(v) == true && v:IsNPC() && v != self && (v:GetClass() == self:GetClass() or (v:Disposition(self) == D_LI or v.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE)) && (v.BringFriendsOnDeath == true or v.CallForBackUpOnDamage == true or v.CallForHelp == true) then
			if self.Behavior == VJ_BEHAVIOR_PASSIVE or self.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE then
				if v.Behavior == VJ_BEHAVIOR_PASSIVE or v.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE then
					it = it + 1
					FoundAlliesTbl[it] = v
				end
			else
				it = it + 1
				FoundAlliesTbl[it] = v
			end
		end
	end
	if it > 0 then
		return FoundAlliesTbl
	else
		return nil
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Allies_Bring(formType, dist, entsTbl, limit, onlyVis)
	formType = formType or "Random" -- Formation type: "Random" || "Diamond"
	dist = dist or 800 -- How far can it check for allies
	entsTbl = entsTbl or ents.FindInSphere(self:GetPos(), dist)
	limit = limit or 3 -- Setting to 0 will automatically become 1
	onlyVis = onlyVis or false -- Check only entities that are visible
	if (!entsTbl) then return false end
	local it = 0
	for _, v in pairs(entsTbl) do
		if VJ_IsAlive(v) == true && v:IsNPC() && v != self && (v:GetClass() == self:GetClass() or v:Disposition(self) == D_LI) && v.Behavior != VJ_BEHAVIOR_PASSIVE && v.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE && v.FollowingPlayer == false && v.VJ_IsBeingControlled == false && (!v.IsVJBaseSNPC_Tank) && (v.BringFriendsOnDeath == true or v.CallForBackUpOnDamage == true or v.CallForHelp == true) then
			if onlyVis == true && !v:Visible(self) then continue end
			if !IsValid(v:GetEnemy()) && self:GetPos():Distance(v:GetPos()) < dist then
				self.NextWanderTime = CurTime() + 8
				v.NextWanderTime = CurTime() + 8
				it = it + 1
				-- Formation
				if formType == "Random" then
					local randpos = math.random(1, 4)
					if randpos == 1 then
						v:SetLastPosition(self:GetPos() + self:GetRight()*math.random(20, 50))
					elseif randpos == 2 then
						v:SetLastPosition(self:GetPos() + self:GetRight()*math.random(-20, -50))
					elseif randpos == 3 then
						v:SetLastPosition(self:GetPos() + self:GetForward()*math.random(20, 50))
					elseif randpos == 4 then
						v:SetLastPosition(self:GetPos() + self:GetForward()*math.random(-20, -50))
					end
				elseif formType == "Diamond" then
					self:DoFormation_Diamond(v,it)
				end
				-- Move type
				if v.IsVJBaseSNPC_Human == true && !IsValid(v:GetActiveWeapon()) then
					v:VJ_TASK_COVER_FROM_ENEMY("TASK_RUN_PATH")
				else
					v:VJ_TASK_GOTO_LASTPOS("TASK_WALK_PATH", function(x) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true end)
				end
			end
			if limit != 0 && it >= limit then return true end -- Return true if it reached the limit
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoKilledEnemy(ent, attacker, inflictor)
	if !IsValid(ent) then return end
	-- If it can only do it if there is no enemies left then check --> (If there no valid enemy) OR (The number of enemies is 1 or less)
	if (self.OnlyDoKillEnemyWhenClear == false) or (self.OnlyDoKillEnemyWhenClear == true && (!IsValid(self:GetEnemy()) or (self.ReachableEnemyCount <= 1))) then
		self:CustomOnDoKilledEnemy(ent, attacker, inflictor)
		self:PlaySoundSystem("OnKilledEnemy")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage(dmginfo)
	if self.GodMode == true or dmginfo:GetDamage() <= 0 then return end
	local DamageInflictor = dmginfo:GetInflictor()
	local DamageAttacker = dmginfo:GetAttacker()
	local DamageType = dmginfo:GetDamageType()
	local hitgroup = self.VJ_ScaleHitGroupDamage
	if IsValid(DamageInflictor) && DamageInflictor:GetClass() == "prop_ragdoll" && DamageInflictor:GetVelocity():Length() <= 100 then return end
	self:CustomOnTakeDamage_BeforeImmuneChecks(dmginfo, hitgroup)
	if self:IsOnFire() && self:WaterLevel() == 2 then self:Extinguish() end -- If we are in water, then extinguish the fire

	-- If it should always take damage from huge monsters, then skip immunity checks!
	if self.GetDamageFromIsHugeMonster == true && DamageAttacker.VJ_IsHugeMonster == true then
		goto skip_immunity
	end
	if VJ_HasValue(self.ImmuneDamagesTable, DamageType) then return end
	if self.AllowIgnition == false && self:IsOnFire() && IsValid(DamageInflictor) && IsValid(DamageAttacker) && DamageInflictor:GetClass() == "entityflame" && DamageAttacker:GetClass() == "entityflame" then self:Extinguish() return end
	if self.Immune_Fire == true && (DamageType == DMG_BURN or DamageType == DMG_SLOWBURN or (self:IsOnFire() && IsValid(DamageInflictor) && IsValid(DamageAttacker) && DamageInflictor:GetClass() == "entityflame" && DamageAttacker:GetClass() == "entityflame")) then return end
	if (self.Immune_AcidPoisonRadiation == true && (DamageType == DMG_ACID or DamageType == DMG_RADIATION or DamageType == DMG_POISON or DamageType == DMG_NERVEGAS or DamageType == DMG_PARALYZE)) or (self.Immune_Bullet == true && (dmginfo:IsBulletDamage() or DamageType == DMG_AIRBOAT or DamageType == DMG_BUCKSHOT)) or (self.Immune_Blast == true && (DamageType == DMG_BLAST or DamageType == DMG_BLAST_SURFACE)) or (self.Immune_Dissolve == true && DamageType == DMG_DISSOLVE) or (self.Immune_Electricity == true && (DamageType == DMG_SHOCK or DamageType == DMG_ENERGYBEAM or DamageType == DMG_PHYSGUN)) or (self.Immune_Melee == true && (DamageType == DMG_CLUB or DamageType == DMG_SLASH)) or (self.Immune_Physics == true && DamageType == DMG_CRUSH) or (self.Immune_Sonic == true && DamageType == DMG_SONIC) then return end
	if (IsValid(DamageInflictor) && DamageInflictor:GetClass() == "prop_combine_ball") or (IsValid(DamageAttacker) && DamageAttacker:GetClass() == "prop_combine_ball") then
		if self.Immune_Dissolve == true then return end
		-- Make sure combine ball does reasonable damage and doesn't spam it!
		if CurTime() > self.NextCanGetCombineBallDamageT then
			dmginfo:SetDamage(math.random(400,500))
			dmginfo:SetDamageType(DMG_DISSOLVE)
			self.NextCanGetCombineBallDamageT = CurTime() + 0.2
		else
			return
		end
	end

	::skip_immunity::
	local function DoBleed()
		if self.Bleeds == true then
			self:CustomOnTakeDamage_OnBleed(dmginfo, hitgroup)
			-- Spawn the blood particle only if it's not caused by the default fire entity [Causes the damage position to be at Vector(0,0,0)]
			if self.HasBloodParticle == true && ((!self:IsOnFire()) or (self:IsOnFire() && IsValid(DamageInflictor) && IsValid(DamageAttacker) && DamageInflictor:GetClass() != "entityflame" && DamageAttacker:GetClass() != "entityflame")) then self:SpawnBloodParticles(dmginfo, hitgroup) end
			if self.HasBloodDecal == true then self:SpawnBloodDecal(dmginfo, hitgroup) end
			self:PlaySoundSystem("Impact", nil, VJ_EmitSound)
		end
	end
	if self.Dead == true then DoBleed() return end -- If dead then just bleed but take no damage
	
	self:CustomOnTakeDamage_BeforeDamage(dmginfo, hitgroup)
	if dmginfo:GetDamage() <= 0 then return end -- Only take damage if it's above 0!
	self.LatestDmgInfo = dmginfo
	self:SetHealth(self:Health() - dmginfo:GetDamage())
	if self.VJDEBUG_SNPC_ENABLED == true && GetConVarNumber("vj_npc_printondamage") == 1 then print(self:GetClass().." Got Damaged! | Amount = "..dmginfo:GetDamage()) end
	if self.HasHealthRegeneration == true && self.HealthRegenerationResetOnDmg == true then
		self.HealthRegenerationDelayT = CurTime() + (math.Rand(self.HealthRegenerationDelay.a, self.HealthRegenerationDelay.b) * 1.5)
	end
	self:CustomOnTakeDamage_AfterDamage(dmginfo, hitgroup)
	DoBleed()

	-- Make passive NPCs run and their allies as well
	if (self.Behavior == VJ_BEHAVIOR_PASSIVE or self.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE) && CurTime() > self.Passive_NextRunOnDamageT then
		if self.Passive_RunOnDamage == true && self:Health() > 0 then -- Don't run if not allowed or dead
			self:VJ_TASK_COVER_FROM_ENEMY("TASK_RUN_PATH")
		end
		if self.Passive_AlliesRunOnDamage == true then -- Make passive allies run
			local allies = self:Allies_Check(self.Passive_AlliesRunOnDamageDistance)
			if allies != nil then
				for _,v in ipairs(allies) do
					v.Passive_NextRunOnDamageT = CurTime() + math.Rand(v.Passive_NextRunOnDamageTime.b, v.Passive_NextRunOnDamageTime.a)
					v:VJ_TASK_COVER_FROM_ENEMY("TASK_RUN_PATH")
					v:PlaySoundSystem("Alert")
				end
			end
		end
		self.Passive_NextRunOnDamageT = CurTime() + math.Rand(self.Passive_NextRunOnDamageTime.a, self.Passive_NextRunOnDamageTime.b)
	end

	if self:Health() > 0 then
		self:DoFlinch(dmginfo, hitgroup)
		
		-- Damage by Player
			-- 0 = Run it every time | 1 = Run it only when friendly to player | 2 = Run it only when enemy to player
		if self.HasDamageByPlayer && DamageAttacker:IsPlayer() && CurTime() > self.NextDamageByPlayerT && GetConVarNumber("ai_disabled") == 0 && self:Visible(DamageAttacker) && (self.DamageByPlayerDispositionLevel == 0 or (self.DamageByPlayerDispositionLevel == 1 && (self:Disposition(DamageAttacker) == D_LI or self:Disposition(DamageAttacker) == D_NU)) or (self.DamageByPlayerDispositionLevel == 2 && self:Disposition(DamageAttacker) != D_LI && self:Disposition(DamageAttacker) != D_NU)) then
			self:CustomOnDamageByPlayer(dmginfo, hitgroup)
			self:PlaySoundSystem("DamageByPlayer")
			self.NextDamageByPlayerT = CurTime() + math.Rand(self.DamageByPlayerTime.a, self.DamageByPlayerTime.b)
		end
		
		self:PlaySoundSystem("Pain")

		if self.CallForBackUpOnDamage == true && CurTime() > self.NextCallForBackUpOnDamageT && !IsValid(self:GetEnemy()) && self.FollowingPlayer == false && self.Behavior != VJ_BEHAVIOR_PASSIVE && self.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE && ((!IsValid(DamageInflictor)) or (IsValid(DamageInflictor) && DamageInflictor:GetClass() != "entityflame")) && IsValid(DamageAttacker) && DamageAttacker:GetClass() != "entityflame" then
			local allies = self:Allies_Check(self.CallForBackUpOnDamageDistance)
			if allies != nil then
				self:Allies_Bring("Random",self.CallForBackUpOnDamageDistance,allies,self.CallForBackUpOnDamageLimit)
				self:ClearSchedule()
				self.NextFlinchT = CurTime() + 1
				local pickanim = VJ_PICK(self.CallForBackUpOnDamageAnimation)
				if VJ_AnimationExists(self,pickanim) == true && self.DisableCallForBackUpOnDamageAnimation == false then
					self:VJ_ACT_PLAYACTIVITY(pickanim,true,self:DecideAnimationLength(pickanim,self.CallForBackUpOnDamageAnimationTime),true, 0, {PlayBackRateCalculated=true})
				else
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
		
		/*if DamageInflictor:GetClass() == "crossbow_bolt" then
			print("test")
			local mdlBolt = ents.Create("prop_dynamic_override")
			mdlBolt:SetPos(dmginfo:GetDamagePosition())
			mdlBolt:SetAngles(DamageAttacker:GetAngles())
			mdlBolt:SetModel("models/crossbow_bolt.mdl")
			mdlBolt:SetParent(self)
			mdlBolt:Spawn()
			mdlBolt:Activate()
		end*/

		if self.BecomeEnemyToPlayer == true && self.VJ_IsBeingControlled == false && DamageAttacker:IsPlayer() && GetConVarNumber("ai_disabled") == 0 && GetConVarNumber("ai_ignoreplayers") == 0 && (self:Disposition(DamageAttacker) == D_LI or self:Disposition(DamageAttacker) == D_NU) then
			if self.AngerLevelTowardsPlayer <= self.BecomeEnemyToPlayerLevel then
				self.AngerLevelTowardsPlayer = self.AngerLevelTowardsPlayer + 1
			end
			if self.AngerLevelTowardsPlayer > self.BecomeEnemyToPlayerLevel then
				if self:Disposition(DamageAttacker) != D_HT then
					self:CustomWhenBecomingEnemyTowardsPlayer(dmginfo, hitgroup)
					if self.FollowingPlayer == true && self.FollowPlayer_Entity == DamageAttacker then self:FollowPlayerReset() end
					self.VJ_AddCertainEntityAsEnemy[#self.VJ_AddCertainEntityAsEnemy+1] = DamageAttacker
					self:AddEntityRelationship(DamageAttacker,D_HT,99)
					self.TakingCoverT = CurTime() + 2
					if !IsValid(self:GetEnemy()) then
						self:StopMoving()
						self:SetTarget(DamageAttacker)
						self:VJ_TASK_FACE_X("TASK_FACE_TARGET")
					end
					if self.AllowPrintingInChat == true then
						DamageAttacker:PrintMessage(HUD_PRINTTALK, self:GetName().." no longer likes you.")
					end
					self:PlaySoundSystem("BecomeEnemyToPlayer")
				end
				self.Alerted = true
			end
		end

		if self.DisableTakeDamageFindEnemy == false && self:BusyWithActivity() == false && !IsValid(self:GetEnemy()) && CurTime() > self.TakingCoverT && self.VJ_IsBeingControlled == false && self.Behavior != VJ_BEHAVIOR_PASSIVE && self.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE /*&& self.Alerted == false*/ && GetConVarNumber("ai_disabled") == 0 then
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
			if (!Targets) then return end
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
		if (dmginfo:GetDamageType() == DMG_DISSOLVE) or (IsValid(DamageInflictor) && DamageInflictor:GetClass() == "prop_combine_ball") then
			local dissolve = DamageInfo()
			dissolve:SetDamage(self:Health())
			dissolve:SetAttacker(DamageAttacker)
			dissolve:SetDamageType(DMG_DISSOLVE)
			self:TakeDamageInfo(dissolve)
		end
		self:PriorToKilled(dmginfo, hitgroup)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoFlinch(dmginfo, hitgroup)
	if self.CanFlinch == 0 or self.Flinching == true or self.TakingCoverT > CurTime() or self.NextFlinchT > CurTime() or (IsValid(dmginfo:GetInflictor()) && IsValid(dmginfo:GetAttacker()) && dmginfo:GetInflictor():GetClass() == "entityflame" && dmginfo:GetAttacker():GetClass() == "entityflame") then return end

	local function RunFlinchCode(HitBoxInfo)
		self.Flinching = true
		self:StopAttacks(true)
		self.PlayingAttackAnimation = false
		local animtbl = self.AnimTbl_Flinch
		if HitBoxInfo != nil then animtbl = HitBoxInfo.Animation end
		local anim = VJ_PICK(animtbl)
		local animdur = self:DecideAnimationLength(anim, false, self.FlinchAnimationDecreaseLengthAmount)
		if self.NextMoveAfterFlinchTime != "LetBaseDecide" && self.NextMoveAfterFlinchTime != false then animdur = self.NextMoveAfterFlinchTime end -- "LetBaseDecide" = Backwards compatibility
		self:VJ_ACT_PLAYACTIVITY(anim, true, animdur, false, 0, {SequenceDuration=animdur, PlayBackRateCalculated=true})
		timer.Create("timer_act_flinching"..self:EntIndex(), animdur, 1, function() self.Flinching = false end)
		self:CustomOnFlinch_AfterFlinch(dmginfo, hitgroup)
		self.NextFlinchT = CurTime() + self.NextFlinchTime
	end

	if math.random(1, self.FlinchChance) == 1 && ((self.CanFlinch == 1) or (self.CanFlinch == 2 && VJ_HasValue(self.FlinchDamageTypes, dmginfo:GetDamageType()))) then
		if self:CustomOnFlinch_BeforeFlinch(dmginfo, hitgroup) == false then return end
		if self.HasHitGroupFlinching == true then -- Hitgroup flinching
			local HitGroupFound = false
			-- Search through the hitgroup tables
			for _, v in ipairs(self.HitGroupFlinching_Values) do
				if VJ_HasValue(v.HitGroup, hitgroup) then
					HitGroupFound = true
					RunFlinchCode(v)
				end
			end
			if HitGroupFound == false && self.HitGroupFlinching_DefaultWhenNotHit == true then
				RunFlinchCode(nil)
			end
		else -- Non-hitgroup
			RunFlinchCode(nil)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetupBloodColor()
	local Type = self.BloodColor
	if Type == "" then return end
	if Type == "Red" then
		if VJ_PICK(self.CustomBlood_Particle) == false then self.CustomBlood_Particle = {"blood_impact_red_01"} end // vj_impact1_red
		if VJ_PICK(self.CustomBlood_Decal) == false then
			if self.BloodDecalUseGMod == true then
				self.CustomBlood_Decal = {"Blood"}
			else
				self.CustomBlood_Decal = {"VJ_Blood_Red"}
			end
		end
		if VJ_PICK(self.CustomBlood_Pool) == false then
			if self.BloodPoolSize == "Small" then
				self.CustomBlood_Pool = {"vj_bleedout_red_small"}
			elseif self.BloodPoolSize == "Tiny" then
				self.CustomBlood_Pool = {"vj_bleedout_red_tiny"}
			else
				self.CustomBlood_Pool = {"vj_bleedout_red"}
			end
		end
	elseif Type == "Yellow" then
		if VJ_PICK(self.CustomBlood_Particle) == false then self.CustomBlood_Particle = {"blood_impact_yellow_01"} end // vj_impact1_yellow
		if VJ_PICK(self.CustomBlood_Decal) == false then
			if self.BloodDecalUseGMod == true then
				self.CustomBlood_Decal = {"YellowBlood"}
			else
				self.CustomBlood_Decal = {"VJ_Blood_Yellow"}
			end
		end
		if VJ_PICK(self.CustomBlood_Pool) == false then
			if self.BloodPoolSize == "Small" then
				self.CustomBlood_Pool = {"vj_bleedout_yellow_small"}
			elseif self.BloodPoolSize == "Tiny" then
				self.CustomBlood_Pool = {"vj_bleedout_yellow_tiny"}
			else
				self.CustomBlood_Pool = {"vj_bleedout_yellow"}
			end
		end
	elseif Type == "Green" then
		if VJ_PICK(self.CustomBlood_Particle) == false then self.CustomBlood_Particle = {"vj_impact1_green"} end
		if VJ_PICK(self.CustomBlood_Decal) == false then self.CustomBlood_Decal = {"VJ_Blood_Green"} end
		if VJ_PICK(self.CustomBlood_Pool) == false then
			if self.BloodPoolSize == "Small" then
				self.CustomBlood_Pool = {"vj_bleedout_green_small"}
			elseif self.BloodPoolSize == "Tiny" then
				self.CustomBlood_Pool = {"vj_bleedout_green_tiny"}
			else
				self.CustomBlood_Pool = {"vj_bleedout_green"}
			end
		end
	elseif Type == "Orange" then
		if VJ_PICK(self.CustomBlood_Particle) == false then self.CustomBlood_Particle = {"vj_impact1_orange"} end
		if VJ_PICK(self.CustomBlood_Decal) == false then self.CustomBlood_Decal = {"VJ_Blood_Orange"} end
		if VJ_PICK(self.CustomBlood_Pool) == false then
			if self.BloodPoolSize == "Small" then
				self.CustomBlood_Pool = {"vj_bleedout_orange_small"}
			elseif self.BloodPoolSize == "Tiny" then
				self.CustomBlood_Pool = {"vj_bleedout_orange_tiny"}
			else
				self.CustomBlood_Pool = {"vj_bleedout_orange"}
			end
		end
	elseif Type == "Blue" then
		if VJ_PICK(self.CustomBlood_Particle) == false then self.CustomBlood_Particle = {"vj_impact1_blue"} end
		if VJ_PICK(self.CustomBlood_Decal) == false then self.CustomBlood_Decal = {"VJ_Blood_Blue"} end
		if VJ_PICK(self.CustomBlood_Pool) == false then
			if self.BloodPoolSize == "Small" then
				self.CustomBlood_Pool = {"vj_bleedout_blue_small"}
			elseif self.BloodPoolSize == "Tiny" then
				self.CustomBlood_Pool = {"vj_bleedout_blue_tiny"}
			else
				self.CustomBlood_Pool = {"vj_bleedout_blue"}
			end
		end
	elseif Type == "Purple" then
		if VJ_PICK(self.CustomBlood_Particle) == false then self.CustomBlood_Particle = {"vj_impact1_purple"} end
		if VJ_PICK(self.CustomBlood_Decal) == false then self.CustomBlood_Decal = {"VJ_Blood_Purple"} end
		if VJ_PICK(self.CustomBlood_Pool) == false then
			if self.BloodPoolSize == "Small" then
				self.CustomBlood_Pool = {"vj_bleedout_purple_small"}
			elseif self.BloodPoolSize == "Tiny" then
				self.CustomBlood_Pool = {"vj_bleedout_purple_tiny"}
			else
				self.CustomBlood_Pool = {"vj_bleedout_purple"}
			end
		end
	elseif Type == "White" then
		if VJ_PICK(self.CustomBlood_Particle) == false then self.CustomBlood_Particle = {"vj_impact1_white"} end
		if VJ_PICK(self.CustomBlood_Decal) == false then self.CustomBlood_Decal = {"VJ_Blood_White"} end
		if VJ_PICK(self.CustomBlood_Pool) == false then
			if self.BloodPoolSize == "Small" then
				self.CustomBlood_Pool = {"vj_bleedout_white_small"}
			elseif self.BloodPoolSize == "Tiny" then
				self.CustomBlood_Pool = {"vj_bleedout_white_tiny"}
			else
				self.CustomBlood_Pool = {"vj_bleedout_white"}
			end
		end
	elseif Type == "Oil" then
		if VJ_PICK(self.CustomBlood_Particle) == false then self.CustomBlood_Particle = {"vj_impact1_black"} end
		if VJ_PICK(self.CustomBlood_Decal) == false then self.CustomBlood_Decal = {"VJ_Blood_Oil"} end
		if VJ_PICK(self.CustomBlood_Pool) == false then
			if self.BloodPoolSize == "Small" then
				self.CustomBlood_Pool = {"vj_bleedout_oil_small"}
			elseif self.BloodPoolSize == "Tiny" then
				self.CustomBlood_Pool = {"vj_bleedout_oil_tiny"}
			else
				self.CustomBlood_Pool = {"vj_bleedout_oil"}
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SpawnBloodParticles(dmginfo, hitgroup)
	local name = VJ_PICK(self.CustomBlood_Particle)
	if name == false then return end
	
	local pos = dmginfo:GetDamagePosition()
	if pos == vec_worigin then pos = self:GetPos() + self:OBBCenter() end
	
	local spawnparticle = ents.Create("info_particle_system")
	spawnparticle:SetKeyValue("effect_name", name)
	spawnparticle:SetPos(pos)
	spawnparticle:Spawn()
	spawnparticle:Activate()
	spawnparticle:Fire("Start")
	spawnparticle:Fire("Kill", "", 0.1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SpawnBloodDecal(dmginfo, hitgroup)
	if VJ_PICK(self.CustomBlood_Decal) == false then return end
	local force = dmginfo:GetDamageForce()
	local pos = dmginfo:GetDamagePosition()
	if pos == vec_worigin then pos = self:GetPos() + self:OBBCenter() end
	
	-- Badi ayroun
	local tr = util.TraceLine({start = pos, endpos = pos + force:GetNormal() * math.Clamp(force:Length() * 10, 100, self.BloodDecalDistance), filter = self})
	//if !tr.HitWorld then return end
	local trNormalP = tr.HitPos + tr.HitNormal
	local trNormalN = tr.HitPos - tr.HitNormal
	util.Decal(VJ_PICK(self.CustomBlood_Decal), trNormalP, trNormalN, self)
	for _ = 1, 2 do
		if math.random(1,2) == 1 then util.Decal(VJ_PICK(self.CustomBlood_Decal), trNormalP + Vector(math.random(-70,70), math.random(-70,70), 0), trNormalN, self) end
	end
	
	-- Kedni ayroun
	if math.random(1,2) == 1 then
		local d2_endpos = pos + Vector(0, 0, -math.Clamp(force:Length() * 10, 100, self.BloodDecalDistance))
		util.Decal(VJ_PICK(self.CustomBlood_Decal), pos, d2_endpos, self)
		if math.random(1,2) == 1 then util.Decal(VJ_PICK(self.CustomBlood_Decal), pos, d2_endpos + Vector(math.random(-120,120), math.random(-120,120), 0), self) end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vecZ30 = Vector(0, 0, 30)
local vecZ1 = Vector(0, 0, 1)
--
function ENT:SpawnBloodPool(dmginfo, hitgroup)
	if !IsValid(self.Corpse) then return end
	local corpseEnt = self.Corpse
	local GetBloodPool = VJ_PICK(self.CustomBlood_Pool)
	if GetBloodPool == false then return end
	timer.Simple(2.2, function()
		if IsValid(corpseEnt) then
			local tr = util.TraceLine({
				start = corpseEnt:GetPos() + corpseEnt:OBBCenter(),
				endpos = corpseEnt:GetPos() + corpseEnt:OBBCenter() - vecZ30,
				filter = corpseEnt, //function( ent ) if ( ent:GetClass() == "prop_physics" ) then return true end end
				mask = CONTENTS_SOLID
			})
			-- (X,Y,Z) | (Ver, Var, Goghme)
			if tr.HitWorld && (tr.HitNormal == vecZ1) then // (tr.Fraction <= 0.405)
				ParticleEffect(GetBloodPool, tr.HitPos, ang_worigin, nil)
			end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vecZ500 = Vector(0, 0, 500)
--
function ENT:PriorToKilled(dmginfo, hitgroup)
	self:CustomOnInitialKilled(dmginfo, hitgroup)
	if self.Medic_IsHealingAlly == true then self:DoMedicCode_Reset() end
	
	local checkdist = 800 -- Nayir vormeg tive amenan medzen e, adiga ere vor poon tive ela
	if self.BringFriendsOnDeathDistance > 800 then checkdist = self.BringFriendsOnDeathDistance end
	if self.AlertFriendsOnDeathDistance > 800 then checkdist = self.AlertFriendsOnDeathDistance end
	local allies = self:Allies_Check(checkdist)
	if allies != nil then
		local noalert = true -- Don't run the AlertFriendsOnDeath if we have BringFriendsOnDeath enabled!
		if self.BringFriendsOnDeath == true then
			self:Allies_Bring("Random",self.BringFriendsOnDeathDistance,allies,self.BringFriendsOnDeathLimit,true)
			noalert = false
		end
		local it = 0
		for _,v in ipairs(allies) do
			v:CustomOnAllyDeath(self)
			v:PlaySoundSystem("AllyDeath")
			
			if self.AlertFriendsOnDeath == true && noalert == true && !IsValid(v:GetEnemy()) && v.AlertFriendsOnDeath == true && it != self.AlertFriendsOnDeathLimit && self:GetPos():Distance(v:GetPos()) < self.AlertFriendsOnDeathDistance then
				it = it + 1
				v:FaceCertainPosition(self:GetPos(), 1)
				v:VJ_ACT_PLAYACTIVITY(VJ_PICK(v.AnimTbl_AlertFriendsOnDeath))
				v.NextIdleTime = CurTime() + math.Rand(5,8)
			end
		end
	end
	
	local function DoKilled()
		if IsValid(self) then
			if self.WaitBeforeDeathTime == 0 then
				self:OnKilled(dmginfo, hitgroup)
			else
				timer.Simple(self.WaitBeforeDeathTime,function() if IsValid(self) then self:OnKilled(dmginfo, hitgroup) end end)
			end
		end
	end

	-- Blood decal on the ground
	if self.Bleeds == true && self.HasBloodDecal == true then
		local pickdecal = VJ_PICK(self.CustomBlood_Decal)
		if pickdecal != false then
			self:SetLocalPos(Vector(self:GetPos().x,self:GetPos().y,self:GetPos().z +4)) -- Because the NPC is too close to the ground
			local tr = util.TraceLine({
				start = self:GetPos(),
				endpos = self:GetPos() - vecZ500,
				filter = self //function( ent ) if ( ent:GetClass() == "prop_physics" ) then return true end end
			})
			util.Decal(pickdecal,tr.HitPos+tr.HitNormal,tr.HitPos-tr.HitNormal)
		end
	end
	
	self.Dead = true
	if self.FollowingPlayer == true then self:FollowPlayerReset() end
	self:RemoveAttackTimers()
	self.MeleeAttacking = false
	self.RangeAttacking = false
	self.LeapAttacking = false
	self.HasRangeAttack = false
	self.HasMeleeAttack = false
	self:StopAllCommonSounds()
	local DamageInflictor = dmginfo:GetInflictor()
	local DamageAttacker = dmginfo:GetAttacker()
	if IsValid(DamageAttacker) then
		if DamageAttacker:GetClass() == "npc_barnacle" then self.HasDeathRagdoll = false end -- Don't make a corpse if it's killed by a barnacle!
		if GetConVarNumber("vj_npc_addfrags") == 1 && DamageAttacker:IsPlayer() then DamageAttacker:AddFrags(1) end
		if IsValid(DamageInflictor) && GetConVarNumber("vj_npc_showhudonkilled") == 1 then
			gamemode.Call("OnNPCKilled", self, DamageAttacker, DamageInflictor, dmginfo)
		end
	end
	self:CustomOnPriorToKilled(dmginfo, hitgroup)
	self:SetCollisionGroup(1)
	self:RunGibOnDeathCode(dmginfo, hitgroup)
	self:PlaySoundSystem("Death")
	self:AAMove_Stop()
	if self.HasDeathAnimation != true then DoKilled() return end
	if self.HasDeathAnimation == true then
		if GetConVarNumber("vj_npc_nodeathanimation") == 1 or GetConVarNumber("ai_disabled") == 1 or ((dmginfo:GetDamageType() == DMG_DISSOLVE) or (IsValid(DamageInflictor) && DamageInflictor:GetClass() == "prop_combine_ball")) then DoKilled() return end
		if dmginfo:GetDamageType() != DMG_DISSOLVE then
			local randanim = math.random(1,self.DeathAnimationChance)
			if randanim != 1 then DoKilled() return end
			if randanim == 1 then
				self:CustomDeathAnimationCode(dmginfo, hitgroup)
				local pickanim = VJ_PICK(self.AnimTbl_Death)
				local seltime = self:DecideAnimationLength(pickanim,self.DeathAnimationTime) - self.DeathAnimationDecreaseLengthAmount
				self:RemoveAllGestures()
				self:VJ_ACT_PLAYACTIVITY(pickanim, true, seltime, false, 0, {PlayBackRateCalculated=true})
				self.DeathAnimationCodeRan = true
				timer.Simple(seltime,DoKilled)
			end
		else
			DoKilled()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RunGibOnDeathCode(dmginfo, hitgroup, extraOptions)
	if self.AllowedToGib == false or self.HasGibOnDeath == false or self.HasBeenGibbedOnDeath == true then return end
	extraOptions = extraOptions or {}
	local dmgTbl = extraOptions.CustomDmgTbl or self.GibOnDeathDamagesTable
	local dmgType = dmginfo:GetDamageType()
	local dmgAny = false
	local useDefault = false
	if VJ_HasValue(dmgTbl,"UseDefault") then useDefault = true end
	if useDefault == false && (#dmgTbl <= 0 or VJ_HasValue(dmgTbl,"All")) then dmgAny = true end
	if (dmgAny == true) or (useDefault == true && VJ_HasValue(self.DefaultGibDamageTypes,dmgType)) or (useDefault == false && VJ_HasValue(dmgTbl,dmgType)) then
		local setupgib, setupgib_extra = self:SetUpGibesOnDeath(dmginfo, hitgroup)
		if setupgib_extra == nil then setupgib_extra = {} end
		if setupgib == true then
			if setupgib_extra.AllowCorpse != true then self.HasDeathRagdoll = false end
			if setupgib_extra.DeathAnim != true then self.HasDeathAnimation = false end
			self.HasBeenGibbedOnDeath = true
			self:PlayGibOnDeathSounds(dmginfo, hitgroup)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local gib_sd1 = "vj_gib/default_gib_splat.wav"
local gib_sd2 = "vj_gib/gibbing1.wav"
local gib_sd3 = "vj_gib/gibbing2.wav"
local gib_sd4 = "vj_gib/gibbing3.wav"
--
function ENT:PlayGibOnDeathSounds(dmginfo, hitgroup)
	if self.HasGibOnDeathSounds == false then return end
	if self:CustomGibOnDeathSounds(dmginfo, hitgroup) == true then
		VJ_EmitSound(self, gib_sd1, 90, math.random(80, 100))
		VJ_EmitSound(self, gib_sd2, 90, math.random(80, 100))
		VJ_EmitSound(self, gib_sd3, 90, math.random(80, 100))
		VJ_EmitSound(self, gib_sd4, 90, math.random(80, 100))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local gib_mdlAAll = {"models/gibs/xenians/sgib_01.mdl","models/gibs/xenians/sgib_02.mdl","models/gibs/xenians/sgib_03.mdl","models/gibs/xenians/mgib_01.mdl","models/gibs/xenians/mgib_02.mdl","models/gibs/xenians/mgib_03.mdl","models/gibs/xenians/mgib_04.mdl","models/gibs/xenians/mgib_05.mdl","models/gibs/xenians/mgib_06.mdl","models/gibs/xenians/mgib_07.mdl"}
local gib_mdlASmall = {"models/gibs/xenians/sgib_01.mdl","models/gibs/xenians/sgib_02.mdl","models/gibs/xenians/sgib_03.mdl"}
local gib_mdlABig = {"models/gibs/xenians/mgib_01.mdl","models/gibs/xenians/mgib_02.mdl","models/gibs/xenians/mgib_03.mdl","models/gibs/xenians/mgib_04.mdl","models/gibs/xenians/mgib_05.mdl","models/gibs/xenians/mgib_06.mdl","models/gibs/xenians/mgib_07.mdl"}
local gib_mdlHSmall = {"models/gibs/humans/sgib_01.mdl","models/gibs/humans/sgib_02.mdl","models/gibs/humans/sgib_03.mdl"}
local gib_mdlHBig = {"models/gibs/humans/mgib_01.mdl","models/gibs/humans/mgib_02.mdl","models/gibs/humans/mgib_03.mdl","models/gibs/humans/mgib_04.mdl","models/gibs/humans/mgib_05.mdl","models/gibs/humans/mgib_06.mdl","models/gibs/humans/mgib_07.mdl"}
-- Creates a gib entity, use this function to create gib!
	-- class = The object class to use, recommended to use "obj_vj_gib", and for ragdoll type of gib use "prop_ragdoll"
	-- models = Model(s) to use, can be a table which it will pick randomly from it OR a string
		-- Defined strings: "UseAlien_Small", "UseAlien_Big", "UseHuman_Small", "UseHuman_Big"
	-- extraOptions = Table that holds extra options to modify parts of the code
		-- Pos = Sets the spawn position
		-- Ang = Sets the spawn angle | DEFAULT = Random angle
		-- Vel = Sets the velocity | "UseDamageForce" = To use the damage's force only | DEFAULT = Random velocity
		-- Vel_ApplyDmgForce = If set to false, it won't add the damage force to the given velocity | DEFAULT = true
		-- AngVel = Angle velocity, basically the speed it rotates as it's flying | DEFAULT = Random velocity
		-- BloodDecal = Decal it spawns when it collides with something | DEFAULT = Base decides
		-- BloodType = Sets the blood type by overriding the BloodDecal option | Works only on "obj_vj_gib" and it uses the same values as a VJ NPC blood types!
		-- CollideSound = The sound it plays when it collides with something | DEFAULT = Base decides
		-- NoFade = Should it let the base make it fade & remove (Adjusted in the SNPC settings menu) | DEFAULT = false
		-- RemoveOnCorpseDelete = Should the entity get removed if the corpse is removed?| DEFAULT = false
	-- customFunc(gib) = Use this to edit the entity which is given as parameter "gib"
function ENT:CreateGibEntity(class, models, extraOptions, customFunc)
	// self:CreateGibEntity("prop_ragdoll", "", {Pos=self:LocalToWorld(Vector(0,3,0)), Ang=self:GetAngles(), Vel=})
	if self.AllowedToGib == false then return end
	local bloodType = "Red"
	class = class or "obj_vj_gib"
	if models == "UseAlien_Small" then
		models =  VJ_PICK(gib_mdlASmall)
		bloodType = "Yellow"
	elseif models == "UseAlien_Big" then
		models =  VJ_PICK(gib_mdlABig)
		bloodType = "Yellow"
	elseif models == "UseHuman_Small" then
		models =  VJ_PICK(gib_mdlHSmall)
	elseif models == "UseHuman_Big" then
		models =  VJ_PICK(gib_mdlHBig)
	else -- Custom models
		models = VJ_PICK(models)
		if VJ_HasValue(gib_mdlAAll, models) then
			bloodType = "Yellow"
		end
	end
	extraOptions = extraOptions or {}
		local vel = extraOptions.Vel or Vector(math.Rand(-100, 100), math.Rand(-100, 100), math.Rand(150, 250))
		if self.LatestDmgInfo != nil then
			local dmgForce = self.LatestDmgInfo:GetDamageForce() / 70
			if extraOptions.Vel_ApplyDmgForce != false && extraOptions.Vel != "UseDamageForce" then -- Use both damage force AND given velocity
				vel = vel + dmgForce
			elseif extraOptions.Vel == "UseDamageForce" then -- Use damage force
				vel = dmgForce
			end
		end
		bloodType = extraOptions.BloodType or bloodType -- Certain entities such as the VJ Gib entity, you can use this to set its gib type
		local removeOnCorpseDelete = extraOptions.RemoveOnCorpseDelete or false -- Should the entity get removed if the corpse is removed?
	local gib = ents.Create(class)
	gib:SetModel(models)
	gib:SetPos(extraOptions.Pos or (self:GetPos() + self:OBBCenter()))
	gib:SetAngles(extraOptions.Ang or Angle(math.Rand(-180, 180), math.Rand(-180, 180), math.Rand(-180, 180)))
	if gib:GetClass() == "obj_vj_gib" then
		gib.BloodType = bloodType
		gib.Collide_Decal = extraOptions.BloodDecal or "Default"
		gib.CollideSound = extraOptions.CollideSound or "Default"
	end
	gib:Spawn()
	gib:Activate()
	gib.IsVJBase_Gib = true
	gib.RemoveOnCorpseDelete = removeOnCorpseDelete
	if GetConVarNumber("vj_npc_gibcollidable") == 0 then gib:SetCollisionGroup(1) end
	local phys = gib:GetPhysicsObject()
	if IsValid(phys) then
		phys:AddVelocity(vel)
		phys:AddAngleVelocity(extraOptions.AngVel or Vector(math.Rand(-200, 200), math.Rand(-200, 200), math.Rand(-200, 200)))
	end
	if extraOptions.NoFade != true && GetConVarNumber("vj_npc_fadegibs") == 1 then
		if gib:GetClass() == "obj_vj_gib" then timer.Simple(GetConVarNumber("vj_npc_fadegibstime"), function() SafeRemoveEntity(gib) end)
		elseif gib:GetClass() == "prop_ragdoll" then gib:Fire("FadeAndRemove", "", GetConVarNumber("vj_npc_fadegibstime"))
		elseif gib:GetClass() == "prop_physics" then gib:Fire("kill", "", GetConVarNumber("vj_npc_fadegibstime")) end
	end
	if removeOnCorpseDelete == true then //self.Corpse:DeleteOnRemove(extraent)
		self.ExtraCorpsesToRemove_Transition[#self.ExtraCorpsesToRemove_Transition + 1] = gib
	end
	if (customFunc) then customFunc(gib) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnKilled(dmginfo, hitgroup)
	if self.VJDEBUG_SNPC_ENABLED == true && GetConVarNumber("vj_npc_printdied") == 1 then print(self:GetClass().." Died!") end
	self:CustomOnKilled(dmginfo, hitgroup)
	self:RunItemDropsOnDeathCode(dmginfo, hitgroup) -- Item drops on death
	if self.HasDeathNotice == true then PrintMessage(self.DeathNoticePosition, self.DeathNoticeWriting) end -- Death notice on death
	self:ClearEnemyMemory()
	self:ClearSchedule()
	//self:SetNPCState(NPC_STATE_DEAD)
	self:CreateDeathCorpse(dmginfo, hitgroup)
	self:Remove()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CreateDeathCorpse(dmginfo, hitgroup)
	self:CustomOnDeath_BeforeCorpseSpawned(dmginfo, hitgroup)
	if self.HasDeathRagdoll == true then
		local corpsemodel = self:GetModel()
		local corpsemodel_custom = VJ_PICK(self.DeathCorpseModel)
		if corpsemodel_custom != false then corpsemodel = corpsemodel_custom end
		local corpsetype = "prop_physics"
		if self.DeathCorpseEntityClass == "UseDefaultBehavior" then
			if util.IsValidRagdoll(corpsemodel) == true then
				corpsetype = "prop_ragdoll"
			elseif util.IsValidProp(corpsemodel) == false or util.IsValidModel(corpsemodel) == false then
				if IsValid(self.TheDroppedWeapon) then self.TheDroppedWeapon:Remove() end
				return false
			end
		else
			corpsetype = self.DeathCorpseEntityClass
		end
		//if self.VJCorpseDeleted == true then
		self.Corpse = ents.Create(corpsetype) //end
		self.Corpse:SetModel(corpsemodel)
		self.Corpse:SetPos(self:GetPos())
		self.Corpse:SetAngles(self:GetAngles())
		self.Corpse:Spawn()
		self.Corpse:Activate()
		self.Corpse:SetColor(self:GetColor())
		self.Corpse:SetMaterial(self:GetMaterial())
		if corpsemodel_custom == false && self.DeathCorpseSubMaterials != nil then -- Take care of sub materials
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
		local fadetype = "kill"
		if self.Corpse:GetClass() == "prop_ragdoll" then fadetype = "FadeAndRemove" end
		self.Corpse.FadeCorpseType = fadetype
		self.Corpse.IsVJBaseCorpse = true
		self.Corpse.DamageInfo = dmginfo
		self.Corpse.ExtraCorpsesToRemove = self.ExtraCorpsesToRemove_Transition

		if self.Bleeds == true && self.HasBloodPool == true && GetConVarNumber("vj_npc_nobloodpool") == 0 then
			self:SpawnBloodPool(dmginfo, hitgroup)
		end
		/*if self.Bleeds == true && self.HasBloodDecal == true then
			local corpseEnt = self.Corpse
			local pickdecal = self.CustomBlood_Decal
			timer.Simple(7,function()
				if IsValid(corpseEnt) then
					local tr = util.TraceLine({
						start = corpseEnt:GetPos()+corpseEnt:OBBCenter(),
						endpos = corpseEnt:GetPos()+corpseEnt:OBBCenter()-Vector(0,0,100),
						filter = corpseEnt, //function( ent ) if ( ent:GetClass() == "prop_physics" ) then return true end end
						//mask = CONTENTS_SOLID
					})
					util.Decal(VJ_PICK(pickdecal),tr.HitPos+tr.HitNormal,tr.HitPos-tr.HitNormal)
					util.Decal(VJ_PICK(pickdecal),tr.HitPos +tr.HitNormal +Vector(25,0,0),tr.HitPos-tr.HitNormal)
					util.Decal(VJ_PICK(pickdecal),tr.HitPos +tr.HitNormal +Vector(-25,0,0),tr.HitPos-tr.HitNormal)
					util.Decal(VJ_PICK(pickdecal),tr.HitPos +tr.HitNormal +Vector(0,25,0),tr.HitPos-tr.HitNormal)
					util.Decal(VJ_PICK(pickdecal),tr.HitPos +tr.HitNormal +Vector(0,-25,0),tr.HitPos-tr.HitNormal)
				end
			end)
		end*/
		
		-- Collision --
		self.Corpse:SetCollisionGroup(self.DeathCorpseCollisionType)
		if GetConVarNumber("ai_serverragdolls") == 1 then
			undo.ReplaceEntity(self, self.Corpse)
		else -- Keep corpses is not enabled...
			hook.Call("VJ_CreateSNPCCorpse", nil, self.Corpse, self)
			if GetConVarNumber("vj_npc_undocorpse") == 1 then undo.ReplaceEntity(self, self.Corpse) end -- Undoable
		end
		cleanup.ReplaceEntity(self, self.Corpse) -- Delete on cleanup
		
		-- Miscellaneous --
		if self.DeathCorpseSkin == -1 then
			self.Corpse:SetSkin(self:GetSkin())
		else
			self.Corpse:SetSkin(self.DeathCorpseSkin)
		end
		
		if self.DeathCorpseSetBodyGroup == true then -- Yete asega true-e, ooremen gerna bodygroup tenel
			for i = 0,18 do -- 18 = Bodygroup limit
				self.Corpse:SetBodygroup(i,self:GetBodygroup(i))
			end
			if self.DeathCorpseBodyGroup.a != -1 then -- Yete asiga nevaz meg chene, user-in teradz tevere kordzadze
				self.Corpse:SetBodygroup(self.DeathCorpseBodyGroup.a, self.DeathCorpseBodyGroup.b)
			end
		end
		
		if self.SetCorpseOnFire == true then self.Corpse:Ignite(math.Rand(8,10),0) end -- Set it on fire when it dies
		if self:IsOnFire() then  -- If was on fire then...
			self.Corpse:Ignite(math.Rand(8,10),0)
			self.Corpse:SetColor(Color(90,90,90))
			//self.Corpse:SetMaterial("models/props_foliage/tree_deciduous_01a_trunk")
		end
		//gamemode.Call("CreateEntityRagdoll",self,self.Corpse)

		-- Dissolve --
		if (dmginfo:GetDamageType() == DMG_DISSOLVE) or (IsValid(dmginfo:GetInflictor()) && dmginfo:GetInflictor():GetClass() == "prop_combine_ball") then
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
			dissolver:Fire("Kill","",0.1)
			//dissolver:Remove()
		end
		
		-- Bone and Angle --		
		local dmgforce = dmginfo:GetDamageForce()
		for bonelim = 0, self.Corpse:GetPhysicsObjectCount() - 1 do -- 128 = Bone Limit
			local childphys = self.Corpse:GetPhysicsObjectNum(bonelim)
			if IsValid(childphys) then
				local childphys_bonepos, childphys_boneang = self:GetBonePosition(self.Corpse:TranslatePhysBoneToBone(bonelim))
				if (childphys_bonepos) then
					//if math.Round(math.abs(childphys_boneang.r)) != 90 then -- Fixes ragdolls rotating, no longer needed!    --->    sv_pvsskipanimation 0
						if self.UsesBoneAngle == true then childphys:SetAngles(childphys_boneang) end
						childphys:SetPos(childphys_bonepos)
					//end
					if self.Corpse:GetName() == "vj_dissolve_corpse" then
						childphys:EnableGravity(false)
						childphys:SetVelocity(self:GetForward()*-150 + self:GetRight()*math.Rand(100,-100) + self:GetUp()*50)
					else
						if self.UsesDamageForceOnDeath == true && self.DeathAnimationCodeRan == false then childphys:SetVelocity(dmgforce /40) end
					end
				end
			end
		end
		
		if self.FadeCorpse == true then self.Corpse:Fire(self.Corpse.FadeCorpseType,"",self.FadeCorpseTime) end
		if GetConVarNumber("vj_npc_corpsefade") == 1 then self.Corpse:Fire(self.Corpse.FadeCorpseType,"",GetConVarNumber("vj_npc_corpsefadetime")) end
		self:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup,self.Corpse)
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
-- Creates a extra corpse entity, use this function to create extra corpse entities when the NPC is killed
	-- class = The object class to use, common types: "prop_ragdoll", "prop_physics"
	-- models = Model(s) to use, can be a table which it will pick randomly from it OR a string | "None" = Doesn't set a model
	-- extraOptions = Table that holds extra options to modify parts of the code
		-- Pos = Sets the spawn position
		-- Ang = Sets the spawn angle
		-- Vel = Sets the velocity | "UseDamageForce" = To use the damage's force only | DEFAULT = Uses damage force
		-- HasVel = If set to false, it won't set any velocity, allowing you to code your own in customFunc | DEFAULT = true
		-- ShouldFade = Should it fade away after certain time | DEFAULT = false
		-- ShouldFadeTime = How much time until the entity fades away | DEFAULT = 0
		-- RemoveOnCorpseDelete = Should the entity get removed if the corpse is removed? | DEFAULT = true
	-- customFunc(gib) = Use this to edit the entity which is given as parameter "gib"
function ENT:CreateExtraDeathCorpse(class, models, extraOptions, customFunc)
	-- Should only be ran after self.Corpse has been created!
	if !IsValid(self.Corpse) then return end
	local dmginfo = self.Corpse.DamageInfo
	if dmginfo == nil then return end
	local dmgforce = dmginfo:GetDamageForce()
	class = class or "prop_ragdoll"
	extraOptions = extraOptions or {}
	local ent = ents.Create(class)
	if models != "None" then ent:SetModel(VJ_PICK(models)) end
	ent:SetPos(extraOptions.Pos or self:GetPos())
	ent:SetAngles(extraOptions.Ang or self:GetAngles())
	ent:Spawn()
	ent:Activate()
	ent:SetColor(self.Corpse:GetColor())
	ent:SetMaterial(self.Corpse:GetMaterial())
	ent:SetCollisionGroup(self.DeathCorpseCollisionType)
	if self.Corpse:IsOnFire() then
		ent:Ignite(math.Rand(8,10),0)
		ent:SetColor(Color(90,90,90))
	end
	if extraOptions.HasVel != false then ent:GetPhysicsObject():AddVelocity(extraOptions.Vel or dmgforce / 40) end
	if extraOptions.ShouldFade == true then
		local fadeTime = extraOptions.ShouldFadeTime or 0 
		if ent:GetClass() == "prop_ragdoll" then
			ent:Fire("FadeAndRemove", "", fadeTime)
		else
			ent:Fire("kill", "", fadeTime)
		end
	end
	if extraOptions.RemoveOnCorpseDelete != false then//self.Corpse:DeleteOnRemove(ent)
		self.Corpse.ExtraCorpsesToRemove[#self.Corpse.ExtraCorpsesToRemove + 1] = ent
	end
	if (customFunc) then customFunc(ent) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	self:CustomOnRemove()
	self.Dead = true
	
	if self.Medic_IsHealingAlly == true then self:DoMedicCode_Reset() end
	self:StopAllCommonSounds()
	self:RemoveAttackTimers()
	self:StopParticles()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RunItemDropsOnDeathCode(dmginfo, hitgroup)
	if self.HasItemDropsOnDeath == false then return end
	if math.random(1,self.ItemDropsOnDeathChance) == 1 then
		self:CustomRareDropsOnDeathCode(dmginfo, hitgroup)
		local entlist = VJ_PICK(self.ItemDropsOnDeath_EntityList)
		if entlist != false then
			local randdrop = ents.Create(entlist)
			randdrop:SetPos(self:GetPos() + self:OBBCenter())
			randdrop:SetAngles(self:GetAngles())
			randdrop:Spawn()
			randdrop:Activate()
			local phys = randdrop:GetPhysicsObject()
			if IsValid(phys) then
				phys:SetMass(60)
				phys:ApplyForceCenter(dmginfo:GetDamageForce())
			end
		end
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AlertSoundCode(CustomTbl,Type) self:PlaySoundSystem("Alert", CustomTbl, Type) end -- !!!!!!!!!!!!!! DO NOT USE THIS FUNCTION !!!!!!!!!!!!!! [Backwards Compatibility!]
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeathSoundCode(CustomTbl,Type) self:PlaySoundSystem("Death", CustomTbl, Type) end -- !!!!!!!!!!!!!! DO NOT USE THIS FUNCTION !!!!!!!!!!!!!! [Backwards Compatibility!]
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BeforeRangeAttackSoundCode(CustomTbl,Type) self:PlaySoundSystem("BeforeRangeAttack", CustomTbl, Type) end -- !!!!!!!!!!!!!! DO NOT USE THIS FUNCTION !!!!!!!!!!!!!! [Backwards Compatibility!]
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackSoundCode(CustomTbl,Type) self:PlaySoundSystem("RangeAttack", CustomTbl, Type) end -- !!!!!!!!!!!!!! DO NOT USE THIS FUNCTION !!!!!!!!!!!!!! [Backwards Compatibility!]
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PlaySoundSystem(Set, CustomSd, Type)
	if self.HasSounds == false or Set == nil then return end
	Type = Type or VJ_CreateSound
	local ctbl = VJ_PICK(CustomSd)
	
	if Set == "GeneralSpeech" then -- Used to just play general speech sounds (Custom by developers)
		if ctbl != false then
			self:StopAllCommonSpeechSounds()
			self.NextIdleSoundT_RegularChange = CurTime() + ((((SoundDuration(ctbl) > 0) and SoundDuration(ctbl)) or 2) + 1)
			self.CurrentGeneralSpeechSound = Type(self, ctbl, 80, self:VJ_DecideSoundPitch(self.GeneralSoundPitch1, self.GeneralSoundPitch2))
		end
		return
	elseif Set == "FollowPlayer" then
		if self.HasFollowPlayerSounds_Follow == true then
			local sdtbl = VJ_PICK(self.SoundTbl_FollowPlayer)
			if (math.random(1, self.FollowPlayerSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
				if ctbl != false then sdtbl = ctbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(3,4)
				self.CurrentFollowPlayerSound = Type(self, sdtbl, self.FollowPlayerSoundLevel, self:VJ_DecideSoundPitch(self.FollowPlayerPitch.a, self.FollowPlayerPitch.b))
			end
		end
		return
	elseif Set == "UnFollowPlayer" then
		if self.HasFollowPlayerSounds_UnFollow == true then
			local sdtbl = VJ_PICK(self.SoundTbl_UnFollowPlayer)
			if (math.random(1, self.UnFollowPlayerSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
				if ctbl != false then sdtbl = ctbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(3,4)
				self.CurrentUnFollowPlayerSound = Type(self, sdtbl, self.UnFollowPlayerSoundLevel, self:VJ_DecideSoundPitch(self.UnFollowPlayerPitch.a, self.UnFollowPlayerPitch.b))
			end
		end
		return
	elseif Set == "OnReceiveOrder" then
		if self.HasOnReceiveOrderSounds == true then
			local sdtbl = VJ_PICK(self.SoundTbl_OnReceiveOrder)
			if (math.random(1, self.OnReceiveOrderSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
				if ctbl != false then sdtbl = ctbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT = self.NextIdleSoundT + 2
				self.NextAlertSoundT = CurTime() + 2
				self.CurrentOnReceiveOrderSound = Type(self, sdtbl, self.OnReceiveOrderSoundLevel, self:VJ_DecideSoundPitch(self.OnReceiveOrderSoundPitch.a, self.OnReceiveOrderSoundPitch.b))
			end
		end
		return
	elseif Set == "MoveOutOfPlayersWay" then
		if self.HasMoveOutOfPlayersWaySounds == true then
			local sdtbl = VJ_PICK(self.SoundTbl_MoveOutOfPlayersWay)
			if (math.random(1, self.MoveOutOfPlayersWaySoundChance) == 1 && sdtbl != false) or (ctbl != false) then
				if ctbl != false then sdtbl = ctbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(3,4)
				self.CurrentMoveOutOfPlayersWaySound = Type(self, sdtbl, self.MoveOutOfPlayersWaySoundLevel, self:VJ_DecideSoundPitch(self.MoveOutOfPlayersWaySoundPitch.a, self.MoveOutOfPlayersWaySoundPitch.b))
			end
		end
		return
	elseif Set == "MedicBeforeHeal" then
		if self.HasMedicSounds_BeforeHeal == true then
			local sdtbl = VJ_PICK(self.SoundTbl_MedicBeforeHeal)
			if (math.random(1, self.MedicBeforeHealSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
				if ctbl != false then sdtbl = ctbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(3,4)
				self.CurrentMedicBeforeHealSound = Type(self, sdtbl, self.BeforeHealSoundLevel, self:VJ_DecideSoundPitch(self.BeforeHealSoundPitch.a, self.BeforeHealSoundPitch.b))
			end
		end
		return
	elseif Set == "MedicOnHeal" then
		if self.HasMedicSounds_AfterHeal == true then
			local sdtbl = VJ_PICK(self.SoundTbl_MedicAfterHeal)
			if sdtbl == false then sdtbl = VJ_PICK(DefaultSoundTbl_MedicAfterHeal) end -- Default table
			if (math.random(1, self.MedicAfterHealSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
				if ctbl != false then sdtbl = ctbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(3,4)
				self.CurrentMedicAfterHealSound = Type(self, sdtbl, self.AfterHealSoundLevel, self:VJ_DecideSoundPitch(self.AfterHealSoundPitch.a, self.AfterHealSoundPitch.b))
			end
		end
		return
	elseif Set == "MedicReceiveHeal" then
		if self.HasMedicSounds_ReceiveHeal == true then
			local sdtbl = VJ_PICK(self.SoundTbl_MedicReceiveHeal)
			if (math.random(1, self.MedicReceiveHealSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
				if ctbl != false then sdtbl = ctbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(3,4)
				self.CurrentMedicReceiveHealSound = Type(self, sdtbl, self.MedicReceiveHealSoundLevel, self:VJ_DecideSoundPitch(self.MedicReceiveHealSoundPitch.a, self.MedicReceiveHealSoundPitch.b))
			end
		end
		return
	elseif Set == "OnPlayerSight" then
		if self.HasOnPlayerSightSounds == true then
			local sdtbl = VJ_PICK(self.SoundTbl_OnPlayerSight)
			if (math.random(1, self.OnPlayerSightSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
				if ctbl != false then sdtbl = ctbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(3,4)
				self.NextAlertSoundT = CurTime() + math.random(1,2)
				self.CurrentOnPlayerSightSound = Type(self, sdtbl, self.OnPlayerSightSoundLevel, self:VJ_DecideSoundPitch(self.OnPlayerSightSoundPitch.a, self.OnPlayerSightSoundPitch.b))
			end
		end
		return
	elseif Set == "InvestigateSound" then
		if self.HasInvestigateSounds == true && CurTime() > self.NextInvestigateSoundT then
			local sdtbl = VJ_PICK(self.SoundTbl_Investigate)
			if (math.random(1, self.InvestigateSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
				if ctbl != false then sdtbl = ctbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT = self.NextIdleSoundT + 2
				self.CurrentInvestigateSound = Type(self, sdtbl, self.InvestigateSoundLevel, self:VJ_DecideSoundPitch(self.InvestigateSoundPitch.a, self.InvestigateSoundPitch.b))
			end
			self.NextInvestigateSoundT = CurTime() + math.Rand(self.NextSoundTime_Investigate.a, self.NextSoundTime_Investigate.b)
		end
		return
	elseif Set == "LostEnemy" then
		if self.HasLostEnemySounds == true && CurTime() > self.LostEnemySoundT then
			local sdtbl = VJ_PICK(self.SoundTbl_LostEnemy)
			if (math.random(1, self.LostEnemySoundChance) == 1 && sdtbl != false) or (ctbl != false) then
				if ctbl != false then sdtbl = ctbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT = self.NextIdleSoundT + 2
				self.CurrentLostEnemySound = Type(self, sdtbl, self.LostEnemySoundLevel, self:VJ_DecideSoundPitch(self.LostEnemySoundPitch.a, self.LostEnemySoundPitch.b))
			end
			self.LostEnemySoundT = CurTime() + math.Rand(self.NextSoundTime_LostEnemy.a, self.NextSoundTime_LostEnemy.b)
		end
		return
	elseif Set == "Alert" then
		if self.HasAlertSounds == true then
			local sdtbl = VJ_PICK(self.SoundTbl_Alert)
			if (math.random(1, self.AlertSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
				if ctbl != false then sdtbl = ctbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT = CurTime() + ((((SoundDuration(sdtbl) > 0) and SoundDuration(sdtbl)) or 2) + 1)
				self.NextAlertSoundT = CurTime() + math.Rand(self.NextSoundTime_Alert1, self.NextSoundTime_Alert2)
				self.CurrentAlertSound = Type(self, sdtbl, self.AlertSoundLevel, self:VJ_DecideSoundPitch(self.AlertSoundPitch.a, self.AlertSoundPitch.b))
			end
		end
		return
	elseif Set == "CallForHelp" then
		if self.HasCallForHelpSounds == true && CurTime() > self.NextCallForHelpSoundT then
			local sdtbl = VJ_PICK(self.SoundTbl_CallForHelp)
			if (math.random(1, self.CallForHelpSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
				if ctbl != false then sdtbl = ctbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT = self.NextIdleSoundT + 2
				self.CurrentCallForHelpSound = Type(self, sdtbl, self.CallForHelpSoundLevel, self:VJ_DecideSoundPitch(self.CallForHelpSoundPitch.a, self.CallForHelpSoundPitch.b))
				self.NextCallForHelpSoundT = CurTime() + 2
			end
		end
		return
	elseif Set == "BecomeEnemyToPlayer" then
		if self.HasBecomeEnemyToPlayerSounds == true then
			local sdtbl = VJ_PICK(self.SoundTbl_BecomeEnemyToPlayer)
			if (math.random(1, self.BecomeEnemyToPlayerChance) == 1 && sdtbl != false) or (ctbl != false) then
				if ctbl != false then sdtbl = ctbl end
				self:StopAllCommonSpeechSounds()
				timer.Simple(0.05,function() if IsValid(self) then VJ_STOPSOUND(self.CurrentPainSound) end end)
				timer.Simple(1.3,function() if IsValid(self) then VJ_STOPSOUND(self.CurrentAlertSound) end end)
				self.NextAlertSoundT = CurTime() + 1
				self.NextInvestigateSoundT = CurTime() + 2
				self.NextIdleSoundT_RegularChange = CurTime() + math.random(2,3)
				self.CurrentBecomeEnemyToPlayerSound = Type(self, sdtbl, self.BecomeEnemyToPlayerSoundLevel, self:VJ_DecideSoundPitch(self.BecomeEnemyToPlayerPitch.a, self.BecomeEnemyToPlayerPitch.b))
			end
		end
		return
	elseif Set == "OnKilledEnemy" then
		if self.HasOnKilledEnemySound == true && CurTime() > self.OnKilledEnemySoundT then
			local sdtbl = VJ_PICK(self.SoundTbl_OnKilledEnemy)
			if (math.random(1, self.OnKilledEnemySoundChance) == 1 && sdtbl != false) or (ctbl != false) then
				if ctbl != false then sdtbl = ctbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT = self.NextIdleSoundT + 2
				self.CurrentOnKilledEnemySound = Type(self, sdtbl, self.OnKilledEnemySoundLevel, self:VJ_DecideSoundPitch(self.OnKilledEnemySoundPitch.a, self.OnKilledEnemySoundPitch.b))
			end
			self.OnKilledEnemySoundT = CurTime() + math.Rand(self.NextSoundTime_OnKilledEnemy.a, self.NextSoundTime_OnKilledEnemy.b)
		end
		return
	elseif Set == "AllyDeath" then
		if self.HasOnKilledEnemySound == true && CurTime() > self.AllyDeathSoundT then
			local sdtbl = VJ_PICK(self.SoundTbl_AllyDeath)
			if (math.random(1, self.AllyDeathSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
				if ctbl != false then sdtbl = ctbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT = self.NextIdleSoundT + 2
				self.CurrentAllyDeathSound = Type(self, sdtbl, self.AllyDeathSoundLevel, self:VJ_DecideSoundPitch(self.AllyDeathSoundPitch.a, self.AllyDeathSoundPitch.b))
			end
			self.AllyDeathSoundT = CurTime() + math.Rand(self.NextSoundTime_AllyDeath.a, self.NextSoundTime_AllyDeath.b)
		end
		return
	elseif Set == "Pain" then
		if self.HasPainSounds == true && CurTime() > self.PainSoundT then
			local sdtbl = VJ_PICK(self.SoundTbl_Pain)
			local sdDur = 2
			if (math.random(1, self.PainSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
				if ctbl != false then sdtbl = ctbl end
				VJ_STOPSOUND(self.CurrentIdleSound)
				self.NextIdleSoundT_RegularChange = CurTime() + 1
				self.CurrentPainSound = Type(self, sdtbl, self.PainSoundLevel, self:VJ_DecideSoundPitch(self.PainSoundPitch1, self.PainSoundPitch2))
				sdDur = (SoundDuration(sdtbl) > 0 and SoundDuration(sdtbl)) or sdDur
			end
			self.PainSoundT = CurTime() + ((self.NextSoundTime_Pain == true and sdDur) or math.Rand(self.NextSoundTime_Pain.a, self.NextSoundTime_Pain.b))
		end
		return
	elseif Set == "Impact" then
		if self.HasImpactSounds == true then
			local sdtbl = VJ_PICK(self.SoundTbl_Impact)
			if sdtbl == false then sdtbl = VJ_PICK(DefaultSoundTbl_Impact) end -- Default table
			if (math.random(1, self.ImpactSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
				if ctbl != false then sdtbl = ctbl end
				self.CurrentImpactSound = Type(self, sdtbl, self.ImpactSoundLevel, self:VJ_DecideSoundPitch(self.ImpactSoundPitch.a, self.ImpactSoundPitch.b))
			end
		end
		return
	elseif Set == "DamageByPlayer" then
		if self.HasDamageByPlayerSounds == true && CurTime() > self.NextDamageByPlayerSoundT then
			local sdtbl = VJ_PICK(self.SoundTbl_DamageByPlayer)
			if (math.random(1, self.DamageByPlayerSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
				if ctbl != false then sdtbl = ctbl end
				self:StopAllCommonSpeechSounds()
				self.NextIdleSoundT_RegularChange = CurTime() + 1
				timer.Simple(0.05, function() if IsValid(self) then VJ_STOPSOUND(self.CurrentPainSound) end end)
				self.CurrentDamageByPlayerSound = Type(self, sdtbl, self.DamageByPlayerSoundLevel, self:VJ_DecideSoundPitch(self.DamageByPlayerPitch.a, self.DamageByPlayerPitch.b))
			end
			self.NextDamageByPlayerSoundT = CurTime() + math.Rand(self.NextSoundTime_DamageByPlayer.a, self.NextSoundTime_DamageByPlayer.b)
		end
		return
	elseif Set == "Death" then
		if self.HasDeathSounds == true then
			local sdtbl = VJ_PICK(self.SoundTbl_Death)
			if (math.random(1, self.DeathSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
				if ctbl != false then sdtbl = ctbl end
				self.CurrentDeathSound = Type(self, sdtbl, self.DeathSoundLevel, self:VJ_DecideSoundPitch(self.DeathSoundPitch1, self.DeathSoundPitch2))
			end
		end
		return
	--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-- Base-Specific Sound Tables --=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
	elseif Set == "BeforeMeleeAttack" then
		if self.HasMeleeAttackSounds == true then
			local sdtbl = VJ_PICK(self.SoundTbl_BeforeMeleeAttack)
			if (math.random(1, self.BeforeMeleeAttackSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
				if ctbl != false then sdtbl = ctbl end
				if self.IdleSounds_PlayOnAttacks == false then VJ_STOPSOUND(self.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
				self.NextIdleSoundT_RegularChange = CurTime() + 1
				self.CurrentBeforeMeleeAttackSound = Type(self, sdtbl, self.BeforeMeleeAttackSoundLevel, self:VJ_DecideSoundPitch(self.BeforeMeleeAttackSoundPitch.a, self.BeforeMeleeAttackSoundPitch.b))
			end
		end
		return
	elseif Set == "MeleeAttack" then
		if self.HasMeleeAttackSounds == true then
			local sdtbl = VJ_PICK(self.SoundTbl_MeleeAttack)
			if (math.random(1, self.MeleeAttackSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
				if ctbl != false then sdtbl = ctbl end
				if self.IdleSounds_PlayOnAttacks == false then VJ_STOPSOUND(self.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
				self.NextIdleSoundT_RegularChange = CurTime() + 1
				self.CurrentMeleeAttackSound = Type(self, sdtbl, self.MeleeAttackSoundLevel, self:VJ_DecideSoundPitch(self.MeleeAttackSoundPitch.a, self.MeleeAttackSoundPitch.b))
			end
			if self.HasExtraMeleeAttackSounds == true then
				sdtbl = VJ_PICK(self.SoundTbl_MeleeAttackExtra)
				if sdtbl == false then sdtbl = VJ_PICK(DefaultSoundTbl_MeleeAttackExtra) end -- Default table
				if (math.random(1, self.ExtraMeleeSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
					if self.IdleSounds_PlayOnAttacks == false then VJ_STOPSOUND(self.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
					self.CurrentExtraMeleeAttackSound = VJ_EmitSound(self, sdtbl, self.ExtraMeleeAttackSoundLevel, self:VJ_DecideSoundPitch(self.ExtraMeleeSoundPitch1, self.ExtraMeleeSoundPitch2))
				end
			end
		end
		return
	elseif Set == "MeleeAttackMiss" then
		if self.HasMeleeAttackMissSounds == true then
			local sdtbl = VJ_PICK(self.SoundTbl_MeleeAttackMiss)
			if (math.random(1, self.MeleeAttackMissSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
				if ctbl != false then sdtbl = ctbl end
				if self.IdleSounds_PlayOnAttacks == false then VJ_STOPSOUND(self.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
				self.NextIdleSoundT_RegularChange = CurTime() + 1
				self.CurrentMeleeAttackMissSound = Type(self, sdtbl, self.MeleeAttackMissSoundLevel, self:VJ_DecideSoundPitch(self.MeleeAttackMissSoundPitch.a, self.MeleeAttackMissSoundPitch.b))
			end
		end
		return
	elseif Set == "BeforeRangeAttack" then
		if self.HasBeforeRangeAttackSound == true then
			local sdtbl = VJ_PICK(self.SoundTbl_BeforeRangeAttack)
			if (math.random(1, self.BeforeRangeAttackSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
				if ctbl != false then sdtbl = ctbl end
				if self.IdleSounds_PlayOnAttacks == false then VJ_STOPSOUND(self.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
				self.NextIdleSoundT_RegularChange = CurTime() + 1
				self.CurrentBeforeRangeAttackSound = Type(self, sdtbl, self.BeforeRangeAttackSoundLevel, self:VJ_DecideSoundPitch(self.BeforeRangeAttackPitch.a, self.BeforeRangeAttackPitch.b))
			end
		end
		return
	elseif Set == "RangeAttack" then
		if self.HasRangeAttackSound == true then
			local sdtbl = VJ_PICK(self.SoundTbl_RangeAttack)
			if (math.random(1, self.RangeAttackSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
				if ctbl != false then sdtbl = ctbl end
				if self.IdleSounds_PlayOnAttacks == false then VJ_STOPSOUND(self.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
				self.NextIdleSoundT_RegularChange = CurTime() + 1
				self.CurrentRangeAttackSound = Type(self, sdtbl, self.RangeAttackSoundLevel, self:VJ_DecideSoundPitch(self.RangeAttackPitch1, self.RangeAttackPitch2))
			end
		end
		return
	elseif Set == "BeforeLeapAttack" then
		if self.HasBeforeLeapAttackSound == true then
			local sdtbl = VJ_PICK(self.SoundTbl_BeforeLeapAttack)
			if (math.random(1, self.BeforeLeapAttackSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
				if ctbl != false then sdtbl = ctbl end
				if self.IdleSounds_PlayOnAttacks == false then VJ_STOPSOUND(self.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
				self.NextIdleSoundT_RegularChange = CurTime() + 1
				self.CurrentBeforeLeapAttackSound = Type(self, sdtbl, self.BeforeLeapAttackSoundLevel, self:VJ_DecideSoundPitch(self.BeforeLeapAttackSoundPitch.a, self.BeforeLeapAttackSoundPitch.b))
			end
		end
		return
	elseif Set == "LeapAttackJump" then
		if self.HasLeapAttackJumpSound == true then
			local sdtbl = VJ_PICK(self.SoundTbl_LeapAttackJump)
			if (math.random(1, self.LeapAttackJumpSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
				if ctbl != false then sdtbl = ctbl end
				if self.IdleSounds_PlayOnAttacks == false then VJ_STOPSOUND(self.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
				self.NextIdleSoundT_RegularChange = CurTime() + 1
				self.CurrentLeapAttackJumpSound = Type(self, sdtbl, self.LeapAttackJumpSoundLevel, self:VJ_DecideSoundPitch(self.LeapAttackJumpSoundPitch.a, self.LeapAttackJumpSoundPitch.b))
			end
		end
		return
	elseif Set == "LeapAttackDamage" then
		if self.HasLeapAttackDamageSound == true then
			local sdtbl = VJ_PICK(self.SoundTbl_LeapAttackDamage)
			if (math.random(1, self.LeapAttackDamageSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
				if ctbl != false then sdtbl = ctbl end
				if self.IdleSounds_PlayOnAttacks == false then VJ_STOPSOUND(self.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
				self.NextIdleSoundT_RegularChange = CurTime() + 1
				self.CurrentLeapAttackDamageSound = Type(self, sdtbl, self.LeapAttackDamageSoundLevel, self:VJ_DecideSoundPitch(self.LeapAttackDamageSoundPitch.a, self.LeapAttackDamageSoundPitch.b))
			end
		end
		return
	elseif Set == "LeapAttackDamageMiss" then
		if self.HasLeapAttackDamageMissSound == true then
			local sdtbl = VJ_PICK(self.SoundTbl_LeapAttackDamageMiss)
			if (math.random(1, self.LeapAttackDamageMissSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
				if ctbl != false then sdtbl = ctbl end
				if self.IdleSounds_PlayOnAttacks == false then VJ_STOPSOUND(self.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
				self.NextIdleSoundT_RegularChange = CurTime() + 1
				self.CurrentLeapAttackDamageMissSound = Type(self, sdtbl, self.LeapAttackDamageMissSoundLevel, self:VJ_DecideSoundPitch(self.LeapAttackDamageMissSoundPitch.a, self.LeapAttackDamageMissSoundPitch.b))
			end
		end
		return
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IdleSoundCode(CustomTbl,Type)
	if self.HasSounds == false or self.HasIdleSounds == false or self.Dead == true then return end
	if (self.NextIdleSoundT_RegularChange < CurTime()) && (CurTime() > self.NextIdleSoundT) then
		Type = Type or VJ_CreateSound
		
		local hasenemy = false -- Ayo yete teshnami ouni
		if IsValid(self:GetEnemy()) then
			hasenemy = true
			-- Yete CombatIdle tsayn chouni YEV gerna barz tsayn hanel, ere vor barz tsayn han e
			if VJ_PICK(self.SoundTbl_CombatIdle) == false && self.IdleSounds_NoRegularIdleOnAlerted == false then
				hasenemy = false
			end
		end
		
		local ctbl = VJ_PICK(CustomTbl)
		local setT = true
		if hasenemy == true then
			local sdtbl = VJ_PICK(self.SoundTbl_CombatIdle)
			if (math.random(1,self.CombatIdleSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
				if ctbl != false then sdtbl = ctbl end
				self.CurrentIdleSound = Type(self,sdtbl,self.CombatIdleSoundLevel,self:VJ_DecideSoundPitch(self.CombatIdleSoundPitch.a,self.CombatIdleSoundPitch.b))
			end
		else
			local sdtbl = VJ_PICK(self.SoundTbl_Idle)
			local sdtbl2 = VJ_PICK(self.SoundTbl_IdleDialogue)
			local sdrand = math.random(1,self.IdleSoundChance)
			local function RegularIdle()
				if (sdrand == 1 && sdtbl != false) or (ctbl != false) then
					if ctbl != false then sdtbl = ctbl end
					self.CurrentIdleSound = Type(self, sdtbl, self.IdleSoundLevel, self:VJ_DecideSoundPitch(self.IdleSoundPitch.a, self.IdleSoundPitch.b))
				end
			end
			if sdtbl2 != false && sdrand == 1 && self.HasIdleDialogueSounds == true && math.random(1,2) == 1 then
				local testent, testvj = self:IdleDialogueSoundCodeTest()
				if testent != false then
					if self:CustomOnIdleDialogue(testent, testvj) == false then
						RegularIdle()
					else
						self.CurrentIdleSound = Type(self, sdtbl2, self.IdleDialogueSoundLevel, self:VJ_DecideSoundPitch(self.IdleDialogueSoundPitch.a, self.IdleDialogueSoundPitch.b))
						if testvj == true then -- If we have a VJ SNPC
							local dur = SoundDuration(sdtbl2)
							if dur == 0 then dur = 3 end -- Since some file types don't return a duration =(
							
							setT = false
							self.NextIdleSoundT = CurTime() + (dur + 0.5)
							self.NextWanderTime = CurTime() + (dur + 0.5)
							testent.NextIdleSoundT = CurTime() + (dur + 0.5)
							testent.NextWanderTime = CurTime() + (dur + 0.5)
							
							if self.IdleDialogueCanTurn == true then
								self:StopMoving()
								self:SetTarget(testent)
								self:VJ_TASK_FACE_X("TASK_FACE_TARGET")
							end
							if testent.IdleDialogueCanTurn == true then
								testent:StopMoving()
								testent:SetTarget(self)
								testent:VJ_TASK_FACE_X("TASK_FACE_TARGET")
							end
							
							-- For the other SNPC to answer back:
							timer.Simple(dur + 0.3, function()
								if IsValid(self) && IsValid(testent) then
									testent:CustomOnIdleDialogueAnswer(self)
									local response = testent:IdleDialogueAnswerSoundCode()
									if response > 0 then -- If the ally responded, then make sure both SNPCs stand still & don't play another idle sound until the whole conversation is finished!
										self.NextIdleSoundT = CurTime() + (response + 0.5)
										self.NextWanderTime = CurTime() + (response + 1)
										testent.NextIdleSoundT = CurTime() + (response + 0.5)
										testent.NextWanderTime = CurTime() + (response + 1)
									end
								end
							end)
						end
					end
				else
					RegularIdle()
				end
			else
				RegularIdle()
			end
		end
		if setT == true then
			self.NextIdleSoundT = CurTime() + math.Rand(self.NextSoundTime_Idle1,self.NextSoundTime_Idle2)
		end
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IdleDialogueSoundCodeTest()
	-- Don't break the loop unless we hit a VJ SNPC
	-- If no VJ SNPC is hit, then just simply return the last checked friendly player or NPC
	local ret = false
	for _, v in ipairs(ents.FindInSphere(self:GetPos(), self.IdleDialogueDistance)) do
		if v:IsPlayer() && self:DoRelationshipCheck(v) == false then
			ret = v
		elseif v != self && ((self:GetClass() == v:GetClass()) or (v:IsNPC() && self:DoRelationshipCheck(v) == false)) && self:Visible(v) then
			ret = v
			if v.IsVJBaseSNPC == true && v.Dead == false && VJ_PICK(v.SoundTbl_IdleDialogueAnswer) != false then
				return v, true -- Yete VJ NPC e, ere vor function-e gena
			end
		end
	end
	return ret, false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IdleDialogueAnswerSoundCode(CustomTbl,Type)
	if self.Dead == true or self.HasSounds == false or self.HasIdleDialogueAnswerSounds == false then return 0 end
	Type = Type or VJ_CreateSound
	local ctbl = VJ_PICK(CustomTbl)
	local sdtbl = VJ_PICK(self.SoundTbl_IdleDialogueAnswer)
	if (math.random(1,self.IdleDialogueAnswerSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
		if ctbl != false then sdtbl = ctbl end
		self:StopAllCommonSpeechSounds()
		self.NextIdleSoundT_RegularChange = CurTime() + math.random(2,3)
		self.CurrentIdleDialogueAnswerSound = Type(self,sdtbl,self.IdleDialogueAnswerSoundLevel,self:VJ_DecideSoundPitch(self.IdleDialogueAnswerSoundPitch.a,self.IdleDialogueAnswerSoundPitch.b))
		return SoundDuration(sdtbl) -- Return the duration of the sound, which will be used to make the other SNPC stand still
	else
		return 0
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
				local CurSched = self.CurrentSchedule
				if self.DisableFootStepOnRun == false && ((VJ_HasValue(self.AnimTbl_Run,self:GetMovementActivity())) or (CurSched != nil  && CurSched.IsMovingTask_Run == true)) /*(VJ_HasValue(VJ_RunActivites,self:GetMovementActivity()) or VJ_HasValue(self.CustomRunActivites,self:GetMovementActivity()))*/ then
					self:CustomOnFootStepSound_Run()
					VJ_EmitSound(self,soundtbl,self.FootStepSoundLevel,self:VJ_DecideSoundPitch(self.FootStepPitch.a,self.FootStepPitch.b))
					if self.HasWorldShakeOnMove == true && self.DisableWorldShakeOnMoveWhileRunning == false then util.ScreenShake(self:GetPos(), self.WorldShakeOnMoveAmplitude, self.WorldShakeOnMoveFrequency, self.WorldShakeOnMoveDuration, self.WorldShakeOnMoveRadius) end
					self.FootStepT = CurTime() + self.FootStepTimeRun
					return
				elseif self.DisableFootStepOnWalk == false && (VJ_HasValue(self.AnimTbl_Walk,self:GetMovementActivity()) or (CurSched != nil  && CurSched.IsMovingTask_Walk == true)) /*(VJ_HasValue(VJ_WalkActivites,self:GetMovementActivity()) or VJ_HasValue(self.CustomWalkActivites,self:GetMovementActivity()))*/ then
					self:CustomOnFootStepSound_Walk()
					VJ_EmitSound(self,soundtbl,self.FootStepSoundLevel,self:VJ_DecideSoundPitch(self.FootStepPitch.a,self.FootStepPitch.b))
					if self.HasWorldShakeOnMove == true && self.DisableWorldShakeOnMoveWhileWalking == false then util.ScreenShake(self:GetPos(), self.WorldShakeOnMoveAmplitude, self.WorldShakeOnMoveFrequency, self.WorldShakeOnMoveDuration, self.WorldShakeOnMoveRadius) end
					self.FootStepT = CurTime() + self.FootStepTimeWalk
					return
				end
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartSoundTrack()
	if self.HasSounds == false or self.HasSoundTrack == false then return end
	if math.random(1, self.SoundTrackChance) == 1 then
		self.VJ_IsPlayingSoundTrack = true
		net.Start("vj_music_run")
		net.WriteEntity(self)
		net.WriteTable(self.SoundTbl_SoundTrack)
		net.WriteFloat(self.SoundTrackVolume)
		net.WriteFloat(self.SoundTrackPlaybackRate)
		//net.WriteFloat(self.SoundTrackFadeOutTime)
		net.Broadcast()
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
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RemoveAttackTimers()
	for _,v in ipairs(self.TimersToRemove) do
		timer.Remove(v..self:EntIndex())
	end
	for _,v in ipairs(self.AttackTimersCustom) do
		timer.Remove(v..self:EntIndex())
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:EntitiesToNoCollideCode(ent)
	if self.HasEntitiesToNoCollide != true or !istable(self.EntitiesToNoCollide) or !IsValid(ent) then return end
	for x=1, #self.EntitiesToNoCollide do
		if self.EntitiesToNoCollide[x] == ent:GetClass() then
			constraint.NoCollide(self,ent,0,0)
		end
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ ///// OBSOLETE FUNCTIONS | Recommended not to use! \\\\\ ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
function ENT:DoHardEntityCheck(CustomTbl)
	local EntsTbl = CustomTbl or ents.GetAll()
	local EntsFinal = {}
	local count = 1
	//for k, v in ipairs(CustomTbl) do //ents.FindInSphere(self:GetPos(),30000)
	for x=1, #EntsTbl do
		if !EntsTbl[x]:IsNPC() && !EntsTbl[x]:IsPlayer() then continue end
		local v = EntsTbl[x]
		self:EntitiesToNoCollideCode(v)
		if (v:IsNPC() && v:GetClass() != self:GetClass() && v:GetClass() != "npc_grenade_frag" && v:GetClass() != "bullseye_strider_focus" && v:GetClass() != "npc_bullseye" && v:GetClass() != "npc_enemyfinder" && v:GetClass() != "hornet" && (!v.IsVJBaseSNPC_Animal) && (v.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE) && v:Health() > 0) or (v:IsPlayer() && GetConVarNumber("ai_ignoreplayers") == 0) then
			EntsFinal[count] = v
			count = count + 1
		end
	end
	//table.Merge(EntsFinal,self.CurrentPossibleEnemies)
	return EntsFinal
end
*/
---------------------------------------------------------------------------------------------------------------------------------------------
/*
function ENT:NoCollide_CombineBall()
	for k, v in pairs (ents.GetAll()) do
		if v:GetClass() == "prop_combine_ball" then
			constraint.NoCollide(self, v, 0, 0)
		end
	end
end
*/
---------------------------------------------------------------------------------------------------------------------------------------------
/*function ENT:FindEnemy()
//self:AddRelationship( "npc_barnacle  D_LI  99" )
if self.FindEnemy_UseSphere == true then
	self:FindEnemySphere()
end
//if self.UseConeForFindEnemy == false then return end -- NOTE: This function got crossed out because the option at the top got deleted!
local EnemyTargets = VJ_FindInCone(self:GetPos(),self:GetForward(),self.SightDistance,self.SightAngle)
//local LocalTargetTable = {}
if (!EnemyTargets) then return end
//table.Add(EnemyTargets)
for k,v in pairs(EnemyTargets) do
	//if (v:GetClass() != self:GetClass() && v:GetClass() != "npc_grenade_frag") && v:IsNPC() or (v:IsPlayer() && self.PlayerFriendly == false && GetConVarNumber("ai_ignoreplayers") == 0) && self:Visible(v) then
	//if self.CombineFriendly == true then if VJ_HasValue(NPCTbl_Combine,v:GetClass()) then return end end
	//if self.ZombieFriendly == true then if VJ_HasValue(NPCTbl_Zombies,v:GetClass()) then return end end
	//if self.AntlionFriendly == true then if VJ_HasValue(NPCTbl_Antlions,v:GetClass()) then return end end
	//if self.PlayerFriendly == true then if VJ_HasValue(NPCTbl_Resistance,v:GetClass()) then return end end
	//if GetConVarNumber("vj_npc_vjfriendly") == 1 then
	//local frivj = ents.FindByClass("npc_vj_*") table.Add(frivj) for _, x in pairs(frivj) do return end end
	//local vjanimalfriendly = ents.FindByClass("npc_vjanimal_*") table.Add(vjanimalfriendly) for _, x in pairs(vjanimalfriendly) do return end
	//self:AddEntityRelationship( v, D_HT, 99 )
	//if !v:IsPlayer() then if self:Visible(v) then v:AddEntityRelationship( self, D_HT, 99 ) end end
	if self:DoRelationshipCheck(v) == true && self:Visible(v) then
	self.ResetedEnemy = true
	self:AddEntityRelationship(v,D_HT,99)
	if !IsValid(self:GetEnemy()) then
		self:SetEnemy(v) //self:GetClosestInTable(EnemyTargets)
		self.MyEnemy = v
		self:UpdateEnemyMemory(v,v:GetPos())
	end
	//table.insert(LocalTargetTable,v)
	//self.EnemyTable = LocalTargetTable
	self:DoAlert()
	//return
  end
 end
 //self:ResetEnemy()
end*/
---------------------------------------------------------------------------------------------------------------------------------------------
/*function ENT:FindEnemySphere()
local EnemyTargets = ents.FindInSphere(self:GetPos(),self.SightDistance)
if (!EnemyTargets) then return end
table.Add(EnemyTargets)
for k,v in pairs(EnemyTargets) do
	if self:DoRelationshipCheck(v) == true && self:Visible(v) then
	self.ResetedEnemy = true
	if !IsValid(self:GetEnemy()) then
		self:SetEnemy(v)
		self.MyEnemy = v
		self:UpdateEnemyMemory(v,v:GetPos())
	end
	self:DoAlert()
	//return
  end
 end
end*/
---------------------------------------------------------------------------------------------------------------------------------------------
/*function ENT:ThemeMusicCode()
/*if GetConVarNumber("vj_npc_sd_nosounds") == 0 then
if GetConVarNumber("vj_npc_sd_soundtrack") == 0 then
	self.thememusicsd = CreateSound( player.GetByID( 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,71,72,73,74,75,76,77,78,79,80,81,82,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100 ), self.Theme )
	self.thememusicsd:Play();
	self.thememusicsd:Stop();
	self.thememusicsd:SetSoundLevel( self.SoundTrackLevel )
	if self.thememusicsd:IsPlaying() == false then self.thememusicsd:Play();
   end
  end
 end
end*/
--------------------------------------------------------------------------------------------------------------------------------------------
/*function ENT:GetRelationship(entity)
	if self.HasAllies == false then return end

	local friendslist = {"", "", "", "", "", ""} -- List
	for _,x in pairs( friendslist ) do
	local hl_friendlys = ents.FindByClass( x )
	for _,x in pairs( hl_friendlys ) do
	if entity == x then
	return D_LI
	end
  end
 end

	local groupone = ents.FindByClass("npc_vj_example_*") -- Group
	table.Add(groupone)
	for _, x in pairs(groupone) do
	if entity == x then
	return D_LI
	end
 end

	local groupone = ents.FindByClass("npc_vj_example") -- Single
	for _, x in pairs(groupone) do
	if entity == x then
	return D_LI
	end
 end
end*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*--------------------------------------------------
	=============== Creature SNPC Base ===============
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
	INFO: Used to make creature SNPCs
--------------------------------------------------*/
