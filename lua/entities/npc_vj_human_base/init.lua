if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')
include('schedules.lua')
/*--------------------------------------------------
	=============== Human SNPC Base ===============
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
	INFO: Used as a base for human SNPCs.
--------------------------------------------------*/
AccessorFunc(ENT,"m_iClass","NPCClass",FORCE_NUMBER)
AccessorFunc(ENT,"m_fMaxYawSpeed","MaxYawSpeed",FORCE_NUMBER)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Core Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.Model = {} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.VJ_IsHugeMonster = false -- Is this a huge monster?
	-- This is mostly used for massive or boss SNPCs, it affects certain part of the SNPC, for example the SNPC won't receive any knock back
	-- ====== Health ====== --
ENT.StartHealth = 50
ENT.HasHealthRegeneration = false -- Can the SNPC regenerate its health?
ENT.HealthRegenerationAmount = 4 -- How much should the health increase after every delay?
ENT.HealthRegenerationDelay = VJ_Set(8,10) -- How much time until the health increases
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
	-- ====== Movement Variables ====== --
	-- Types: VJ_MOVETYPE_GROUND | VJ_MOVETYPE_AERIAL | VJ_MOVETYPE_AQUATIC | VJ_MOVETYPE_STATIONARY | VJ_MOVETYPE_PHYSICS
ENT.MovementType = VJ_MOVETYPE_GROUND -- How does the SNPC move?
ENT.CanTurnWhileStationary = true -- If set to true, the SNPC will be able to turn while it's a stationary SNPC
ENT.Stationary_UseNoneMoveType = false -- Technical variable, use this if there is any issues with the SNPC's position, though it does have its downsides, so use it only when needed
ENT.MaxJumpLegalDistance = VJ_Set(120,150) -- The max distance the NPC can jump (Usually from one node to another) | ( UP, DOWN )
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
ENT.OnPlayerSightOnlyOnce = true -- Should it only run the code once?
ENT.OnPlayerSightNextTime1 = 15 -- How much time should it pass until it runs the code again? | First number in math.random
ENT.OnPlayerSightNextTime2 = 20 -- How much time should it pass until it runs the code again? | Second number in math.random
	-- ====== Call For Help Variables ====== --
ENT.CallForHelp = true -- Does the SNPC call for help?
ENT.CallForHelpDistance = 2000 -- -- How far away the SNPC's call for help goes | Counted in World Units
ENT.NextCallForHelpTime = 4 -- Time until it calls for help again
ENT.HasCallForHelpAnimation = true -- if true, it will play the call for help animation
ENT.AnimTbl_CallForHelp = {ACT_SIGNAL_ADVANCE,ACT_SIGNAL_FORWARD} -- Call For Help Animations
ENT.CallForHelpAnimationDelay = 0 -- It will wait certain amount of time before playing the animation
ENT.CallForHelpAnimationPlayBackRate = 0.5 -- How fast should the animation play? | Currently only for gestures!
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
ENT.Medic_NextHealTime1 = 10 -- How much time until it can give health to an ally again | First number in the math.random
ENT.Medic_NextHealTime2 = 15 -- How much time until it can give health to an ally again | Second number in the math.random
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
ENT.NextFollowPlayerTime = 1 -- Time until it runs to the player again
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
	-- ====== Taking Cover Variables ====== --
ENT.AnimTbl_TakingCover = {} -- The animation it plays when hiding in a covered position, leave empty to let the base decide
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
ENT.LastSeenEnemyTimeUntilReset = 15 -- Time until it resets its enemy if its current enemy is not visible
ENT.NextProcessTime = 1 -- Time until it runs the essential part of the AI, which can be performance heavy!
	-- ====== Miscellaneous Variables ====== --
ENT.DisableInitializeCapabilities = false -- If enabled, all of the Capabilities will be disabled, allowing you to add your own
ENT.AttackTimersCustom = {}
ENT.RunFromEnemy_Distance = 150 -- When the enemy is this close, the SNPC will back away | Put to 0, to never back away
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Damaged / Injured Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- ====== Blood-Related Variables ====== --
ENT.Bleeds = true -- Does the SNPC bleed? (Blood decal, particle, etc.)
ENT.BloodColor = "" -- The blood type, this will determine what it should use (decal, particle, etc.)
	-- Types: "Red" || "Yellow" || "Green" || "Orange" || "Blue" || "Purple" || "White" || "Oil"
ENT.HasBloodParticle = true -- Does it spawn a particle when damaged?
ENT.HasBloodDecal = true -- Does it spawn a decal when damaged?
ENT.HasBloodPool = true -- Does it have a blood pool?
ENT.CustomBlood_Particle = {} -- Particles to spawn when it's damaged
ENT.CustomBlood_Decal = {} -- Decals to spawn when it's damaged
ENT.CustomBlood_Pool = {} -- Blood pool types after it dies
ENT.BloodPoolSize = "Normal" -- What's the size of the blood pool?
	-- Sizes: "Normal" || "Small" || "Tiny"
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
ENT.CallForBackUpOnDamageAnimation = {ACT_SIGNAL_GROUP} -- Animation used if the SNPC does the CallForBackUpOnDamage function
	-- To let the base automatically detect the animation duration, set this to false:
ENT.CallForBackUpOnDamageAnimationTime = false -- How much time until it can use activities
ENT.NextCallForBackUpOnDamageTime = VJ_Set(9,11) -- Next time it use the CallForBackUpOnDamage function
ENT.DisableCallForBackUpOnDamageAnimation = false -- Disables the animation when the CallForBackUpOnDamage function is called
	-- ====== Move Or Hide On Damage Variables ====== --
ENT.MoveOrHideOnDamageByEnemy = true -- Should the SNPC move or hide when being damaged by an enemy?
ENT.MoveOrHideOnDamageByEnemy_OnlyMove = false -- Should it only move and not hide?
ENT.AnimTbl_MoveOrHideOnDamageByEnemy = {} -- The activities it plays when it finds a hiding spot | This will override self.AnimTbl_TakingCover and and the base animations
ENT.MoveOrHideOnDamageByEnemy_HideTime = VJ_Set(3,4) -- How long should it hide?
ENT.NextMoveOrHideOnDamageByEnemy1 = 3 -- How much time until it moves or hides on damage by enemy? | The first # in math.random
ENT.NextMoveOrHideOnDamageByEnemy2 = 3.5 -- How much time until it moves or hides on damage by enemy? | The second # in math.random
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Killed & Corpse Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- ====== Corpse Variables ====== --
ENT.HasDeathRagdoll = true -- If set to false, it will not spawn the regular ragdoll of the SNPC
ENT.DeathCorpseEntityClass = "UseDefaultBehavior" -- The entity class it creates | "UseDefaultBehavior" = Let the base automatically detect the type
ENT.DeathCorpseModel = {} -- The corpse model that it will spawn when it dies | Leave empty to use the NPC's model | Put as many models as desired, the base will pick a random one.
ENT.DeathCorpseSkin = -1 -- Used to override the death skin | -1 = Use the skin that the SNPC had before it died
ENT.DeathCorpseSetBodyGroup = true -- Should it get the models bodygroups and set it to the corpse? When set to false, it uses the model's default bodygroups
ENT.DeathCorpseBodyGroup = VJ_Set(-1,-1) -- #1 = the category of the first bodygroup | #2 = the value of the second bodygroup | Set -1 for #1 to let the base decide the corpse's bodygroup
ENT.DeathCorpseAlwaysCollide = false -- Should the corpse always collide?
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
ENT.DropWeaponOnDeath = true -- Should it drop its weapon on death?
ENT.DropWeaponOnDeathAttachment = "anim_attachment_RH" -- Which attachment should it use for the weapon's position
ENT.HasItemDropsOnDeath = true -- Should it drop items on death?
ENT.ItemDropsOnDeathChance = 14 -- If set to 1, it will always drop it
ENT.ItemDropsOnDeath_EntityList = {"weapon_frag","item_healthvial"} -- List of items it will randomly pick from | Leave it empty to drop nothing or to make your own dropping code (Using CustomOn...)
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
	-- ====== Miscellaneous Variables ====== --
ENT.HasDeathNotice = false -- Set to true if you want it show a message after it dies
ENT.DeathNoticePosition = HUD_PRINTCENTER -- Were you want the message to show. Examples: HUD_PRINTCENTER, HUD_PRINTCONSOLE, HUD_PRINTTALK
ENT.DeathNoticeWriting = "Example: Spider Queen Has Been Defeated!" -- Message that will appear
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Melee Attack Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.MeleeAttackDamage = 10
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
ENT.MeleeAttackExtraTimers = {/* Ex: 1,1.4 */} -- Extra melee attack timers | it will run the damage code after the given amount of seconds
ENT.StopMeleeAttackAfterFirstHit = false -- Should it stop the melee attack from running rest of timers when it hits an enemy?
	-- ====== Control Variables ====== --
ENT.DisableMeleeAttackAnimation = false -- if true, it will disable the animation code
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Weapon Attack Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.WeaponSpread = 1 -- What's the spread of the weapon? | Closer to 0 = better accuracy, Farther than 1 = worse accuracy
ENT.DisableWeapons = false -- If set to true, it won't be able to use weapons
ENT.Weapon_NoSpawnMenu = false -- If set to true, the NPC weapon setting in the spawnmenu will not be applied for this SNPC
	-- ====== Distance Variables ====== --
ENT.Weapon_FiringDistanceFar = 3000 -- How far away it can shoot
ENT.Weapon_FiringDistanceClose = 10 -- How close until it stops shooting
	-- ====== Standing-Firing Variables ====== --
ENT.AnimTbl_WeaponAttack = {ACT_RANGE_ATTACK1} -- Animation played when the SNPC does weapon attack | For VJ Weapons
ENT.WeaponAttackSchedule = {SCHED_RANGE_ATTACK1} -- Schedule played when the SNPC does weapon attack | For None-VJ Weapons
ENT.CanCrouchOnWeaponAttack = true -- Can it crouch while shooting?
ENT.AnimTbl_WeaponAttackCrouch = {ACT_RANGE_ATTACK1_LOW} -- Animation played when the SNPC does weapon attack while crouching | For VJ Weapons
ENT.CanCrouchOnWeaponAttackChance = 2 -- How much chance of crouching? | 1 = Crouch every time
ENT.AnimTbl_WeaponAttackFiringGesture = {} -- Firing Gesture animations used when the SNPC is firing the weapon | Leave empty for the base to decide
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
	-- ====== Move Randomly While Firing Variables ====== --
ENT.MoveRandomlyWhenShooting = true -- Should it move randomly when shooting?
ENT.NextMoveRandomlyWhenShootingTime1 = 3 -- How much time until it can move randomly when shooting? | First number in math.random
ENT.NextMoveRandomlyWhenShootingTime2 = 6 -- How much time until it can move randomly when shooting? | Second number in math.random
	-- ====== Wait For Enemy To Come Out Variables ====== --
ENT.WaitForEnemyToComeOut = true -- Should it wait for the enemy to come out from hiding?
ENT.WaitForEnemyToComeOutTime = VJ_Set(5,7) -- How much time should it wait until it starts chasing the enemy?
ENT.WaitForEnemyToComeOutDistance = 100 -- If it's this close to the enemy, it won't do it
ENT.HasLostWeaponSightAnimation = false -- Set to true if you would like the SNPC to play a different animation when it has lost sight of the enemy and can't fire at it
ENT.AnimTbl_LostWeaponSight = {ACT_IDLE_ANGRY} -- The animations that it will play if the variable above is set to true
	-- ====== Scared Behavior Variables ====== --
ENT.NoWeapon_UseScaredBehavior = true -- Should it use the scared behavior when it sees an enemy and doesn't have a weapon?
ENT.AnimTbl_ScaredBehaviorStand = {ACT_COWER} -- The animation it will when it's just standing still | Replaces the idle stand animation
ENT.AnimTbl_ScaredBehaviorMovement = {} -- The movement animation it will play | Leave empty for the base to decide the animation
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Grenade Attack Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasGrenadeAttack = false -- Should the SNPC have a grenade attack?
ENT.GrenadeAttackEntity = "obj_vj_grenade" -- The entity that the SNPC throws | Half Life 2 Grenade: "npc_grenade_frag"
ENT.GrenadeAttackModel = "models/vj_weapons/w_grenade.mdl" -- The model for the grenade entity
	-- ====== Animation Variables ====== --
ENT.AnimTbl_GrenadeAttack = {"grenThrow"} -- Grenade Attack Animations
ENT.GrenadeAttackAnimationDelay = 0 -- It will wait certain amount of time before playing the animation
ENT.GrenadeAttackAnimationFaceEnemy = true -- Should it face the enemy while playing the grenade attack animation?
	-- ====== Distance & Chance Variables ====== --
ENT.NextThrowGrenadeTime1 = 10 -- Time until it runs the throw grenade code again | The first # in math.random
ENT.NextThrowGrenadeTime2 = 15 -- Time until it runs the throw grenade code again | The second # in math.random
ENT.ThrowGrenadeChance = 4 -- Chance that it will throw the grenade | Set to 1 to throw all the time
ENT.GrenadeAttackThrowDistance = 1500 -- How far it can throw grenades
ENT.GrenadeAttackThrowDistanceClose = 400 -- How close until it stops throwing grenades
	-- ====== Timer Variables ====== --
ENT.TimeUntilGrenadeIsReleased = 0.72 -- Time until the grenade is released
	-- To let the base automatically detect the attack duration, set this to false:
ENT.GrenadeAttackAnimationStopAttacks = true -- Should it stop attacks for a certain amount of time?
ENT.GrenadeAttackAnimationStopAttacksTime = false -- How long should it stop attacks?
ENT.GrenadeAttackFussTime = 3 -- Time until the grenade explodes
	-- ====== Projectile Spawn & Velocity Variables ====== --
ENT.GrenadeAttackAttachment = "anim_attachment_LH" -- The attachment that the grenade will spawn at, set to false to use a custom position instead
ENT.GrenadeAttackSpawnPosition = Vector(0,0,0) -- The position to use if the attachment variable is set to false for spawning
ENT.GrenadeAttackVelUp1 = 200 -- Grenade attack velocity up | The first # in math.random
ENT.GrenadeAttackVelUp2 = 200 -- Grenade attack velocity up | The second # in math.random
ENT.GrenadeAttackVelForward1 = 500 -- Grenade attack velocity up | The first # in math.random
ENT.GrenadeAttackVelForward2 = 500 -- Grenade attack velocity up | The second # in math.random
ENT.GrenadeAttackVelRight1 = -20 -- Grenade attack velocity right | The first # in math.random
ENT.GrenadeAttackVelRight2 = 20 -- Grenade attack velocity right | The second # in math.random
	-- ====== Grenade Detection & Throwing Back Variables ====== --
ENT.CanDetectGrenades = true -- Set to false to disable the SNPC from running away from grenades
ENT.RunFromGrenadeDistance = 400 -- If the entity is this close to the it, then run!
	-- NOTE: The ability to throw grenades back only work if the SNPC can detect grenades AND has a grenade attack!
ENT.CanThrowBackDetectedGrenades = true -- Should it try to pick up the detected grenade and throw it back to the enemy?
	-- ====== Control Variables ====== --
ENT.DisableGrenadeAttackAnimation = false -- if true, it will disable the animation code when doing grenade attack
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Sound Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasSounds = true -- Put to false to disable ALL sounds
	-- ====== Footstep Sound Variables ====== --
ENT.DisableFootStepSoundTimer = false -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
ENT.FootStepTimeRun = 0.5 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 1 -- Next foot step sound when it is walking
ENT.DisableFootStepOnRun = false -- It will not play the footstep sound when running
ENT.DisableFootStepOnWalk = false -- It will not play the footstep sound when walking
ENT.HasWorldShakeOnMove = false -- Should the world shake when it's moving?
ENT.NextWorldShakeOnRun = 0.5 -- How much time until the world shakes while it's running
ENT.NextWorldShakeOnWalk = 1 -- How much time until the world shakes while it's walking
ENT.WorldShakeOnMoveAmplitude = 10 -- How much the screen will shake | From 1 to 16, 1 = really low 16 = really high
ENT.WorldShakeOnMoveRadius = 1000 -- How far the screen shake goes, in world units
ENT.WorldShakeOnMoveDuration = 0.4 -- How long the screen shake will last, in seconds
ENT.WorldShakeOnMoveFrequency = 100 -- Just leave it to 100
ENT.DisableWorldShakeOnMoveWhileRunning = false -- It will not shake the world when it's running
ENT.DisableWorldShakeOnMoveWhileWalking = false -- It will not shake the world when it's walking
	-- The following custom variables are used for timer-based footstep & world shake
	-- Add any animations that should be used to trigger a sound or shake the world, only add animations if the base doesn't recognize an animation as a movement!
ENT.CustomWalkActivites = {} -- Custom walk activities
ENT.CustomRunActivites = {} -- Custom run activities
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
ENT.OnlyDoKillEnemyWhenClear = true -- When there is no enemy in sight
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
ENT.SoundTbl_OnKilledEnemy = {}
ENT.SoundTbl_AllyDeath = {}
ENT.SoundTbl_Pain = {}
ENT.SoundTbl_Impact = {}
ENT.SoundTbl_DamageByPlayer = {}
ENT.SoundTbl_Death = {}
ENT.SoundTbl_SoundTrack = {}
	-- ====== Default File Path Variables ====== --
	-- It's recommended not to edit these tables, instead override them using the tables above
ENT.DefaultSoundTbl_FootStep = {"npc/metropolice/gear1.wav","npc/metropolice/gear2.wav","npc/metropolice/gear3.wav","npc/metropolice/gear4.wav","npc/metropolice/gear5.wav","npc/metropolice/gear6.wav"}
ENT.DefaultSoundTbl_MedicAfterHeal = {"items/smallmedkit1.wav"}
ENT.DefaultSoundTbl_MeleeAttack = {"physics/body/body_medium_impact_hard1.wav","physics/body/body_medium_impact_hard2.wav","physics/body/body_medium_impact_hard3.wav","physics/body/body_medium_impact_hard4.wav","physics/body/body_medium_impact_hard5.wav","physics/body/body_medium_impact_hard6.wav"}
ENT.DefaultSoundTbl_MeleeAttackMiss = {"npc/zombie/claw_miss1.wav","npc/zombie/claw_miss2.wav"}
ENT.DefaultSoundTbl_Impact = {"physics/flesh/flesh_impact_bullet1.wav","physics/flesh/flesh_impact_bullet2.wav","physics/flesh/flesh_impact_bullet3.wav","physics/flesh/flesh_impact_bullet4.wav","physics/flesh/flesh_impact_bullet5.wav"}
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
ENT.NextSoundTime_Breath_BaseDecide = true -- Let the base decide the next sound time, if it can't it will use the numbers below
ENT.NextSoundTime_Breath1 = 1
ENT.NextSoundTime_Breath2 = 1
ENT.NextSoundTime_Idle1 = 8
ENT.NextSoundTime_Idle2 = 25
ENT.NextSoundTime_Investigate1 = 5
ENT.NextSoundTime_Investigate2 = 5
ENT.NextSoundTime_LostEnemy1 = 5
ENT.NextSoundTime_LostEnemy2 = 6
ENT.NextSoundTime_Alert1 = 2
ENT.NextSoundTime_Alert2 = 3
ENT.NextSoundTime_OnGrenadeSight1 = 3
ENT.NextSoundTime_OnGrenadeSight2 = 3
ENT.NextSoundTime_Suppressing1 = 7
ENT.NextSoundTime_Suppressing2 = 15
ENT.NextSoundTime_WeaponReload1 = 3
ENT.NextSoundTime_WeaponReload2 = 5
ENT.NextSoundTime_OnKilledEnemy1 = 3
ENT.NextSoundTime_OnKilledEnemy2 = 5
ENT.NextSoundTime_AllyDeath1 = 3
ENT.NextSoundTime_AllyDeath2 = 5
ENT.NextSoundTime_Pain1 = 2
ENT.NextSoundTime_Pain2 = 2
ENT.NextSoundTime_DamageByPlayer1 = 2
ENT.NextSoundTime_DamageByPlayer2 = 2.3
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
ENT.OnKilledEnemySoundLevel = 80
ENT.AllyDeathSoundLevel = 80
ENT.PainSoundLevel = 80
ENT.ImpactSoundLevel = 60
ENT.DamageByPlayerSoundLevel = 75
ENT.DeathSoundLevel = 80
//ENT.SoundTrackLevel = 0.9
	-- ====== Sound Pitch Variables ====== --
	-- Higher number = Higher pitch | Lower number = Lower pitch
	-- Highest acceptable number is 254
ENT.UseTheSameGeneralSoundPitch = true
	-- If set to true, it will make the game decide a number when the SNPC is created and use it for all sound pitches set to "UseGeneralPitch"
	-- It picks the number between these two variables below:
ENT.GeneralSoundPitch1 = 90
ENT.GeneralSoundPitch2 = 100
	-- These two variables control any sound pitch variable that is set to "UseGeneralPitch"
	-- To not use these variables for a certain sound pitch, just put the desired number in the specific sound pitch
ENT.FootStepPitch1 = 80
ENT.FootStepPitch2 = 100
ENT.BreathSoundPitch1 = 100
ENT.BreathSoundPitch2 = 100
ENT.IdleSoundPitch1 = "UseGeneralPitch"
ENT.IdleSoundPitch2 = "UseGeneralPitch"
ENT.IdleDialogueSoundPitch = VJ_Set("UseGeneralPitch","UseGeneralPitch")
ENT.IdleDialogueAnswerSoundPitch = VJ_Set("UseGeneralPitch","UseGeneralPitch")
ENT.CombatIdleSoundPitch1 = "UseGeneralPitch"
ENT.CombatIdleSoundPitch2 = "UseGeneralPitch"
ENT.OnReceiveOrderSoundPitch1 = "UseGeneralPitch"
ENT.OnReceiveOrderSoundPitch2 = "UseGeneralPitch"
ENT.FollowPlayerPitch1 = "UseGeneralPitch"
ENT.FollowPlayerPitch2 = "UseGeneralPitch"
ENT.UnFollowPlayerPitch1 = "UseGeneralPitch"
ENT.UnFollowPlayerPitch2 = "UseGeneralPitch"
ENT.MoveOutOfPlayersWaySoundPitch1 = "UseGeneralPitch"
ENT.MoveOutOfPlayersWaySoundPitch2 = "UseGeneralPitch"
ENT.BeforeHealSoundPitch1 = "UseGeneralPitch"
ENT.BeforeHealSoundPitch2 = "UseGeneralPitch"
ENT.AfterHealSoundPitch1 = 100
ENT.AfterHealSoundPitch2 = 100
ENT.MedicReceiveHealSoundPitch1 = "UseGeneralPitch"
ENT.MedicReceiveHealSoundPitch2 = "UseGeneralPitch"
ENT.OnPlayerSightSoundPitch1 = "UseGeneralPitch"
ENT.OnPlayerSightSoundPitch2 = "UseGeneralPitch"
ENT.InvestigateSoundPitch1 = "UseGeneralPitch"
ENT.InvestigateSoundPitch2 = "UseGeneralPitch"
ENT.LostEnemySoundPitch1 = "UseGeneralPitch"
ENT.LostEnemySoundPitch2 = "UseGeneralPitch"
ENT.AlertSoundPitch1 = "UseGeneralPitch"
ENT.AlertSoundPitch2 = "UseGeneralPitch"
ENT.CallForHelpSoundPitch1 = "UseGeneralPitch"
ENT.CallForHelpSoundPitch2 = "UseGeneralPitch"
ENT.BecomeEnemyToPlayerPitch1 = "UseGeneralPitch"
ENT.BecomeEnemyToPlayerPitch2 = "UseGeneralPitch"
ENT.BeforeMeleeAttackSoundPitch1 = "UseGeneralPitch"
ENT.BeforeMeleeAttackSoundPitch2 = "UseGeneralPitch"
ENT.MeleeAttackSoundPitch1 = 95
ENT.MeleeAttackSoundPitch2 = 100
ENT.ExtraMeleeSoundPitch1 = 80
ENT.ExtraMeleeSoundPitch2 = 100
ENT.MeleeAttackMissSoundPitch1 = 90
ENT.MeleeAttackMissSoundPitch2 = 100
ENT.SuppressingPitch1 = "UseGeneralPitch"
ENT.SuppressingPitch2 = "UseGeneralPitch"
ENT.WeaponReloadSoundPitch1 = "UseGeneralPitch"
ENT.WeaponReloadSoundPitch2 = "UseGeneralPitch"
ENT.GrenadeAttackSoundPitch1 = "UseGeneralPitch"
ENT.GrenadeAttackSoundPitch2 = "UseGeneralPitch"
ENT.OnGrenadeSightSoundPitch1 = "UseGeneralPitch"
ENT.OnGrenadeSightSoundPitch2 = "UseGeneralPitch"
ENT.OnKilledEnemySoundPitch1 = "UseGeneralPitch"
ENT.OnKilledEnemySoundPitch2 = "UseGeneralPitch"
ENT.AllyDeathSoundPitch1 = "UseGeneralPitch"
ENT.AllyDeathSoundPitch2 = "UseGeneralPitch"
ENT.PainSoundPitch1 = "UseGeneralPitch"
ENT.PainSoundPitch2 = "UseGeneralPitch"
ENT.ImpactSoundPitch1 = 80
ENT.ImpactSoundPitch2 = 100
ENT.DamageByPlayerPitch1 = "UseGeneralPitch"
ENT.DamageByPlayerPitch2 = "UseGeneralPitch"
ENT.DeathSoundPitch1 = "UseGeneralPitch"
ENT.DeathSoundPitch2 = "UseGeneralPitch"
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
function ENT:CustomOnChangeMovementType(SetType) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnIsJumpLegal(startPos,apex,endPos) end -- Return nothing to let base decide, return true to make it jump, return false to disallow jumping
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnSchedule() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ExpressionFinished(strExp) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPlayCreateSound(SoundData,SoundFile) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPlayEmitSound(SoundData) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnFireBullet(ent,data) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTouch(entity) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnCondition(iCondition) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnHandleAnimEvent(ev,evTime,evCycle,evType,evOptions) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnFollowPlayer(key,activator,caller,data) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnIdleDialogue(argent, CanAnswer) return true end -- argent = An entity that it can talk to | CanAnswer = If the entity can answer back | Return false to not run the code!
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnIdleDialogueAnswer() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMedic_BeforeHeal() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMedic_OnHeal() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMedic_OnReset() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPlayerSight(argent) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnFootStepSound() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnFootStepSound_Run() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnFootStepSound_Walk() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnWorldShakeOnMove() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnWorldShakeOnMove_Run() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnWorldShakeOnMove_Walk() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDoChangeWeapon(NewWeapon,OldWeapon) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInvestigate(argent) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnResetEnemy() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(argent) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnCallForHelp(ally) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetNearestPointToEntityPosition()
	return self:GetPos() + self:GetForward() -- Override this to use a different position
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomAttack() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetMeleeAttackDamagePosition()
	return self:GetPos() + self:GetForward() -- Override this to use a different position
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_Miss() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_BeforeStartTimer() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_AfterStartTimer() end
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
function ENT:CustomOnGrenadeAttack_BeforeThrowTime() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnGrenadeAttack_OnThrow(GrenadeEntity) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDoKilledEnemy(argent,attacker,inflictor) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeImmuneChecks(dmginfo,hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_AfterDamage(dmginfo,hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo,hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnFlinch_BeforeFlinch(dmginfo,hitgroup) end -- Return false to disallow the flinch from playing
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnFlinch_AfterFlinch(dmginfo,hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDamageByPlayer(dmginfo,hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomWhenBecomingEnemyTowardsPlayer(dmginfo,hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnSetEnemyOnDamage(dmginfo,hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetUpGibesOnDeath(dmginfo,hitgroup)
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
function ENT:CustomGibOnDeathSounds(dmginfo,hitgroup) return true end -- returning false will make the default gibbing sounds not play
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAllyDeath(argent) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialKilled(dmginfo,hitgroup) end -- Ran the moment the NPC dies!
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPriorToKilled(dmginfo,hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomDeathAnimationCode(dmginfo,hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRareDropsOnDeathCode(dmginfo,hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDropWeapon(dmginfo,hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDropWeapon_AfterWeaponSpawned(dmginfo,hitgroup,GetWeapon) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_BeforeCorpseSpawned(dmginfo,hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo,hitgroup,GetCorpse) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_IntMsg(ply)
	ply:ChatPrint("None specified...") -- Remove this line!
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ ///// WARNING: Don't touch anything below this line! \\\\\ ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.MeleeAttacking = false
ENT.HasSeenGrenade = false
ENT.Alerted = false
ENT.Dead = false
ENT.Flinching = false
ENT.vACT_StopAttacks = false
ENT.FollowingPlayer = false
ENT.FollowPlayer_GoingAfter = false
ENT.FollowPlayer_WanderValue = false
ENT.FollowPlayer_ChaseValue = false
ENT.ThrowingGrenade = false
ENT.ResetedEnemy = true
ENT.VJ_IsBeingControlled = false
ENT.VJ_PlayingSequence = false
ENT.VJ_IsPlayingSoundTrack = false
ENT.HasDone_PlayAlertSoundOnlyOnce = false
ENT.PlayingAttackAnimation = false
ENT.DoingWeaponAttack = false
ENT.DoingWeaponAttack_Standing = false
ENT.WaitingForEnemyToComeOut = false
ENT.OnPlayerSight_AlreadySeen = false
ENT.VJDEBUG_SNPC_ENABLED = false
ENT.DidWeaponAttackAimParameter = false
ENT.Medic_IsHealingAlly = false
ENT.Medic_WanderValue = false
ENT.Medic_ChaseValue = false
ENT.AlreadyDoneMedicThinkCode = false
ENT.AlreadyBeingHealedByMedic = false
ENT.VJFriendly = false
ENT.IsReloadingWeapon = false
ENT.IsDoingFaceEnemy = false
ENT.VJ_IsPlayingInterruptSequence = false
ENT.IsAbleToMeleeAttack = true
ENT.AlreadyDoneFirstMeleeAttack = false
ENT.CanDoSelectScheduleAgain = true
ENT.AllowToDo_WaitForEnemyToComeOut = true
ENT.DoingVJDeathDissolve = false
ENT.HasBeenGibbedOnDeath = false
ENT.DeathAnimationCodeRan = false
ENT.AlreadyDone_RunSelectSchedule_FollowPlayer = false
ENT.VJ_IsBeingControlled_Tool = false
ENT.WeaponUseEnemyEyePos = false
ENT.LastHiddenZone_CanWander = true
ENT.DoneLastHiddenZone_CanWander = false
ENT.AlreadyDoneMeleeAttackFirstHit = false
ENT.NoWeapon_UseScaredBehavior_Active = false
ENT.FollowPlayer_Entity = NULL
ENT.VJ_TheController = NULL
ENT.VJ_TheControllerEntity = NULL
ENT.VJ_TheControllerBullseye = NULL
ENT.Medic_CurrentEntToHeal = NULL
ENT.Medic_SpawnedProp = NULL
ENT.CurrentWeaponEntity = NULL
ENT.LastPlayedVJSound = nil
ENT.LatestEnemyClass = nil
ENT.LatestDmgInfo = nil
ENT.Weapon_ShotsSinceLastReload = 0
ENT.TestT = 0
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
ENT.NextNoWeaponT = 0
ENT.NextCallForHelpT = 0
ENT.NextProcessT = 0
ENT.NextFindEnemyT = 0
ENT.NextThrowGrenadeT = 0
ENT.NextCallForBackUpOnDamageT = 0
ENT.NextOnGrenadeSightSoundT = 0
ENT.NextMoveOrHideOnDamageByEnemyT = 0
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
ENT.NextWeaponAttackAimPoseParametersReset = 0
ENT.NextWeaponReloadSoundT = 0
ENT.TimeSinceLastSeenEnemy = 0
ENT.TimeSinceSeenEnemy = 0
ENT.Medic_NextHealT = 0
ENT.Weapon_TimeSinceLastShot = 5
ENT.CurrentAnim_WeaponReload = 0
ENT.NextMoveRandomlyWhenShootingT = 0
ENT.NextWeaponAttackT = 0
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
ENT.Passive_NextRunOnTouchT = 0
ENT.Passive_NextRunOnDamageT = 0
ENT.NextWanderTime = 0
ENT.Weapon_DoingCrouchAttackT = 0
ENT.NextInvestigateSoundMove = 0
ENT.NextInvestigateSoundT = 0
ENT.LostEnemySoundT = 0
ENT.NextDoAnyAttackT = 0
ENT.NearestPointToEnemyDistance = 0
ENT.ReachableEnemyCount = 0
ENT.LatestEnemyDistance = 0
ENT.HealthRegenerationDelayT = 0
ENT.LatestEnemyPosition = Vector(0,0,0)
ENT.LatestVisibleEnemyPosition = Vector(0,0,0)
ENT.SelectedDifficulty = 1
ENT.VJ_AddCertainEntityAsEnemy = {}
ENT.VJ_AddCertainEntityAsFriendly = {}
ENT.AttackTimers = {"timer_act_stopattacks","timer_melee_finished","timer_melee_start","timer_melee_finished_abletomelee"}
ENT.DefaultGibDamageTypes = {DMG_ALWAYSGIB,DMG_ENERGYBEAM,DMG_BLAST,DMG_VEHICLE,DMG_CRUSH,DMG_DIRECT,DMG_DISSOLVE,DMG_AIRBOAT,DMG_SLOWBURN,DMG_PHYSGUN,DMG_PLASMA,DMG_SONIC}
ENT.EntitiesToRunFrom = {obj_spore=true,obj_vj_grenade=true,obj_grenade=true,obj_handgrenade=true,npc_grenade_frag=true,doom3_grenade=true,fas2_thrown_m67=true,cw_grenade_thrown=true,obj_cpt_grenade=true,cw_flash_thrown=true,ent_hl1_grenade=true}
ENT.EntitiesToThrowBack = {obj_spore=true,obj_vj_grenade=true,obj_handgrenade=true,npc_grenade_frag=true,obj_cpt_grenade=true,cw_grenade_thrown=true,cw_flash_thrown=true,cw_smoke_thrown=true,ent_hl1_grenade=true}
//ENT.Weapons_UseRegulate = {weapon_shotgun=true,weapon_crossbow=true,weapon_annabelle=true,weapon_pistol=true}
//ENT.Weapons_DontUseRegulate = {weapon_smg1=true,weapon_ar2=true}
ENT.NPCTbl_Animals = {npc_barnacle=true,npc_crow=true,npc_pigeon=true,npc_seagull=true,monster_cockroach=true}
ENT.NPCTbl_Resistance = {npc_magnusson=true,npc_vortigaunt=true,npc_mossman=true,npc_monk=true,npc_kleiner=true,npc_fisherman=true,npc_eli=true,npc_dog=true,npc_barney=true,npc_alyx=true,npc_citizen=true,monster_scientist=true,monster_barney=true}
ENT.NPCTbl_Combine = {npc_stalker=true,npc_rollermine=true,npc_turret_ground=true,npc_turret_floor=true,npc_turret_ceiling=true,npc_strider=true,npc_sniper=true,npc_metropolice=true,npc_hunter=true,npc_breen=true,npc_combine_camera=true,npc_combine_s=true,npc_combinedropship=true,npc_combinegunship=true,npc_cscanner=true,npc_clawscanner=true,npc_helicopter=true,npc_manhack=true}
ENT.NPCTbl_Zombies = {npc_fastzombie_torso=true,npc_zombine=true,npc_zombie_torso=true,npc_zombie=true,npc_poisonzombie=true,npc_headcrab_fast=true,npc_headcrab_black=true,npc_headcrab=true,npc_fastzombie=true,monster_zombie=true,monster_headcrab=true,monster_babycrab=true}
ENT.NPCTbl_Antlions = {npc_antlion=true,npc_antlionguard=true,npc_antlion_worker=true}
ENT.NPCTbl_Xen = {monster_bullchicken=true,monster_alien_grunt=true,monster_alien_slave=true,monster_alien_controller=true,monster_houndeye=true,monster_gargantua=true,monster_nihilanth=true}

//util.AddNetworkString("vj_human_onthememusic")
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:CustomOnPreInitialize()
	self:SetSpawnEffect(false)
	self:SetRenderMode(RENDERMODE_NORMAL)
	//self:SetRenderMode(RENDERMODE_TRANSALPHA)
	self:VJ_DoSelectDifficulty()
	self:SetModel(VJ_PICK(self.Model))
	self:SetMaxYawSpeed(self.TurningSpeed)
	if self.HasHull == true then self:SetHullType(self.HullType) end
	if self.HullSizeNormal == true then self:SetHullSizeNormal() end
	self:SetCustomCollisionCheck()
	if self.HasSetSolid == true then self:SetSolid(SOLID_BBOX) end // SOLID_OBB
	//self:SetMoveType(self.MoveType)
	self:ConvarsOnInit()
	self:DoChangeMovementType()
	self.CurrentChoosenBlood_Particle = {}
	self.CurrentChoosenBlood_Decal = {}
	self.CurrentChoosenBlood_Pool = {}
	self.ExtraCorpsesToRemove_Transition = {}
	if self.BloodColor == "" then -- Backwards Compatibility!
		if VJ_PICK(self.BloodDecal) == "Blood" then
			self.BloodColor = "Red"
		elseif  VJ_PICK(self.BloodDecal) == "YellowBlood" then
			self.BloodColor = "Yellow"
		end
	end
	self:DoChangeBloodColor(self.BloodColor)
	if self.Behavior == VJ_BEHAVIOR_PASSIVE or self.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE then
		self.DisableWeapons = true
		self.Weapon_NoSpawnMenu = true
	end
	if self.DisableInitializeCapabilities == false then self:SetInitializeCapabilities() end
	self:SetCollisionGroup(COLLISION_GROUP_NPC)
	self.VJ_ScaleHitGroupDamage = 0
	self.NextThrowGrenadeT = CurTime() + math.Rand(1,5)
	self.NextIdleSoundT_RegularChange = CurTime() + 0
	self.NextIdleSoundT = CurTime() + math.Rand(1,12)
	//self.NextChaseTime = CurTime() + math.random(4,5)
	if GetConVarNumber("vj_npc_allhealth") == 0 then
		self:SetHealth(self:VJ_GetDifficultyValue(self.StartHealth))
	else
		self:SetHealth(GetConVarNumber("vj_npc_allhealth"))
	end
	self.StartHealth = self:Health()
	//if self.HasSquad == true then self:Fire("setsquad",self.SquadName,0) end
	if self.PrintName == "" then
		self:SetName(list.Get("NPC")[self:GetClass()].Name)
	else
		self:SetName(self.PrintName)
	end
	//self:SetEnemy(nil)
	self:SetUseType(SIMPLE_USE)
	//self.Corpse = ents.Create(self.DeathCorpseEntityClass)
	if self.UseTheSameGeneralSoundPitch == true then self.UseTheSameGeneralSoundPitch_PickedNumber = math.random(self.GeneralSoundPitch1,self.GeneralSoundPitch2) end
	self:CustomOnInitialize()
	self:CustomInitialize() -- !!!!!!!!!!!!!! DO NOT USE THIS FUNCTION !!!!!!!!!!!!!! [Backwards Compatibility!]
	timer.Simple(0.15,function()
		if IsValid(self) then
			if math.random(1,self.SoundTrackChance) == 1 then self:StartSoundTrack() end
		end
	end)
	duplicator.RegisterEntityClass(self:GetClass(),VJSPAWN_SNPC_DUPE,"Model","Class","Equipment","SpawnFlags","Data")
	//if self.Immune_Dissolve == true or self.GodMode == true then self:AddEFlags(EFL_NO_DISSOLVE) end
	self:AddEFlags(EFL_NO_DISSOLVE)
	self.VJ_AddCertainEntityAsEnemy = {}
	self.VJ_AddCertainEntityAsFriendly = {}
	self.CurrentPossibleEnemies = {}
	if GetConVarNumber("vj_npc_seedistance") == 0 then self.SightDistance = self.SightDistance else self.SightDistance = GetConVarNumber("vj_npc_seedistance") end
	timer.Simple(0.1,function()
		if IsValid(self) then
			//self.CurrentPossibleEnemies = self:DoHardEntityCheck()
			if self:VJ_HasActiveWeapon() == true then
				self.Weapon_StartingAmmoAmount = self:GetActiveWeapon():Clip1()
				if self.Weapon_UnlimitedAmmo == true then self:GetActiveWeapon():SetClip1(99999) end
			end
			if IsValid(self:GetCreator()) && self.DisableWeapons == false && GetConVarNumber("vj_npc_nosnpcchat") == 0 then
				if self:GetActiveWeapon() == NULL && self.Weapon_NoSpawnMenu == false then self:GetCreator():PrintMessage(HUD_PRINTTALK, "WARNING: "..self:GetName().." needs a weapon!") end
				if !self:GetActiveWeapon().IsVJBaseWeapon && self:GetActiveWeapon() != NULL then self:GetCreator():PrintMessage(HUD_PRINTTALK, "NOTE: "..self:GetName().." needs a weapon that runs on VJ Base to work properly!") end
			end
		end
	end)
	//if self.MovementType == VJ_MOVETYPE_GROUND then self:VJ_SetSchedule(SCHED_FALL_TO_GROUND) end
	/*if self.VJ_IsStationary == true then
		self.HasFootStepSound = false
		self.HasWorldShakeOnMove = false
		self.RunAwayOnUnknownDamage = false
		self.DisableWandering = true
		self.DisableChasingEnemy = true
	end*/
end
function ENT:CustomInitialize() end -- !!!!!!!!!!!!!! DO NOT USE THIS FUNCTION !!!!!!!!!!!!!! [Backwards Compatibility!]
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInitializeCapabilities()
-- Add as many as you want --
	self:CapabilitiesAdd(bit.bor(CAP_ANIMATEDFACE))
	self:CapabilitiesAdd(bit.bor(CAP_TURN_HEAD))
	//if self.VJ_IsStationary == false then self:CapabilitiesAdd(bit.bor(CAP_MOVE_GROUND)) end
	if self.CanOpenDoors == true then
		self:CapabilitiesAdd(bit.bor(CAP_OPEN_DOORS))
		self:CapabilitiesAdd(bit.bor(CAP_AUTO_DOORS))
		self:CapabilitiesAdd(bit.bor(CAP_USE))
	end
	//self:CapabilitiesAdd(bit.bor(CAP_MOVE_JUMP))
	self:CapabilitiesAdd(bit.bor(CAP_DUCK))
	//if self.HasSquad == true then self:CapabilitiesAdd(bit.bor(CAP_SQUAD)) end
	if self.DisableWeapons == false then
		if self.Weapon_NoSpawnMenu == false then
			self:CapabilitiesAdd(bit.bor(CAP_USE_WEAPONS))
			self:CapabilitiesAdd(bit.bor(CAP_WEAPON_RANGE_ATTACK1))
		end
		//if self.DisableUSE_SHOT_REGULATOR == false then self:CapabilitiesAdd(bit.bor(CAP_USE_SHOT_REGULATOR)) end
	//if self.VJ_IsStationary == false then self:CapabilitiesAdd(bit.bor(CAP_MOVE_SHOOT)) end
	//self:CapabilitiesAdd(bit.bor(CAP_AIM_GUN))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoChangeMovementType(SetType)
	SetType = SetType or "None"
	if SetType != "None" then self.MovementType = SetType end
	if self.MovementType == VJ_MOVETYPE_GROUND then
		self:SetMoveType(MOVETYPE_STEP)
		self:CapabilitiesAdd(bit.bor(CAP_MOVE_GROUND))
		if VJ_AnimationExists(self,ACT_JUMP) == true && GetConVarNumber("vj_npc_human_canjump") == 1 then self:CapabilitiesAdd(bit.bor(CAP_MOVE_JUMP)) end
		//if VJ_AnimationExists(self,ACT_CLIMB_UP) == true then self:CapabilitiesAdd(bit.bor(CAP_MOVE_CLIMB)) end
		if self.DisableWeapons == false then self:CapabilitiesAdd(bit.bor(CAP_MOVE_SHOOT)) end
		self:CapabilitiesRemove(CAP_MOVE_FLY)
		//self:CapabilitiesRemove(CAP_SKIP_NAV_GROUND_CHECK)
		self:CapabilitiesAdd(bit.bor(CAP_SKIP_NAV_GROUND_CHECK))
	end
	if self.MovementType == VJ_MOVETYPE_AERIAL then
		self:SetMoveType(MOVETYPE_FLY)
		self:CapabilitiesAdd(bit.bor(CAP_MOVE_FLY))
		self:CapabilitiesAdd(bit.bor(CAP_SKIP_NAV_GROUND_CHECK))
		self:CapabilitiesRemove(CAP_MOVE_GROUND)
		self:CapabilitiesRemove(CAP_MOVE_JUMP)
		self:CapabilitiesRemove(CAP_MOVE_CLIMB)
		self:CapabilitiesRemove(CAP_MOVE_SHOOT)
	end
	if self.MovementType == VJ_MOVETYPE_AQUATIC then
		self:SetMoveType(MOVETYPE_FLY)
		self:CapabilitiesAdd(bit.bor(CAP_MOVE_FLY))
		self:CapabilitiesAdd(bit.bor(CAP_SKIP_NAV_GROUND_CHECK))
		self:CapabilitiesRemove(CAP_MOVE_GROUND)
		self:CapabilitiesRemove(CAP_MOVE_JUMP)
		self:CapabilitiesRemove(CAP_MOVE_CLIMB)
		self:CapabilitiesRemove(CAP_MOVE_SHOOT)
	end
	if self.MovementType == VJ_MOVETYPE_STATIONARY then
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
		self:CapabilitiesRemove(CAP_SKIP_NAV_GROUND_CHECK)
	end
	if self.MovementType == VJ_MOVETYPE_PHYSICS then
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:CapabilitiesRemove(CAP_MOVE_GROUND)
		self:CapabilitiesRemove(CAP_MOVE_JUMP)
		self:CapabilitiesRemove(CAP_MOVE_CLIMB)
		self:CapabilitiesRemove(CAP_MOVE_SHOOT)
		self:CapabilitiesRemove(CAP_MOVE_FLY)
		self:CapabilitiesRemove(CAP_SKIP_NAV_GROUND_CHECK)
	end
	self:CustomOnChangeMovementType(SetType)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoSchedule(schedule)
	if self:TaskFinished() then self:NextTask(schedule) end
	if self.CurrentTask then self:RunTask(self.CurrentTask) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTaskComplete()
	self.bTaskComplete = true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IsJumpLegal(startPos,apex,endPos)
	/*print("---------------------")
	print(startPos)
	print(apex)
	print(endPos)*/
	local result = self:CustomOnIsJumpLegal(startPos,apex,endPos)
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
function ENT:VJ_ACT_PLAYACTIVITY(vACT_Name,vACT_StopActivities,vACT_StopActivitiesTime,vACT_FaceEnemy,vACT_DelayAnim,vACT_AdvancedFeatures,vACT_CustomCode)
	if vACT_Name == nil or vACT_Name == false then return end
	vACT_StopActivities = vACT_StopActivities or false
	if vACT_StopActivitiesTime == nil then
		vACT_StopActivitiesTime = 0 -- Set this value to false to let the base calculate the time
	end
	vACT_FaceEnemy = vACT_FaceEnemy or false
	vACT_DelayAnim = vACT_DelayAnim or 0
	vACT_AdvancedFeatures = vACT_AdvancedFeatures or {}
	vTbl_AlwaysUseSequence = vACT_AdvancedFeatures.AlwaysUseSequence or false
	vTbl_SequenceDuration = vACT_AdvancedFeatures.SequenceDuration -- Done automatically
	vTbl_SequenceInterruptible = vACT_AdvancedFeatures.SequenceInterruptible or false -- Can it be Interrupted? (Mostly used for idle animations)
	vTbl_AlwaysUseGesture = vACT_AdvancedFeatures.AlwaysUseGesture or false
	vTbl_PlayBackRate = vACT_AdvancedFeatures.PlayBackRate or 0.5
	//vACT_CustomCode = vACT_CustomCode or function() end
	if istable(vACT_Name) then vACT_Name = VJ_PICK(vACT_Name) end
	local IsGesture = false
	local IsSequence = false
	if string.find(vACT_Name, "vjges_") then
		IsGesture = true
		vACT_Name = string.Replace(vACT_Name,"vjges_","")
		if string.find(vACT_Name, "vjseq_") then
			IsSequence = true
			vACT_Name = string.Replace(vACT_Name,"vjseq_","")
		end
		if self:LookupSequence(vACT_Name) == -1 then vACT_Name = tonumber(vACT_Name) end
		//vACT_Name = tonumber(string.Replace(vACT_Name,"vjges_",""))
	end
	
	if vACT_StopActivitiesTime == false then
		vACT_StopActivitiesTime = self:DecideAnimationLength(vACT_Name,false)
	end
	
	if type(vACT_Name) != "string" && VJ_AnimationExists(self,vACT_Name) == false then
		if self:GetActiveWeapon() != NULL then
			if self:GetActiveWeapon().IsVJBaseWeapon && VJ_HasValue(table.GetKeys(self:GetActiveWeapon().ActivityTranslateAI),vACT_Name) != true then return end
		else
			return
		end
	end
	if type(vACT_Name) == "string" && VJ_AnimationExists(self,vACT_Name) == false then return end

	local vsched = ai_vj_schedule.New("vj_act_"..vACT_Name)
	if vTbl_AlwaysUseSequence == true then
		IsSequence = true
		if type(vACT_Name) == "number" then
			vACT_Name = self:GetSequenceName(self:SelectWeightedSequence(vACT_Name))
		end
	end
	if vTbl_AlwaysUseGesture == true then
		IsGesture = true
		if type(vACT_Name) == "number" then
			vACT_Name = self:GetSequenceName(self:SelectWeightedSequence(vACT_Name))
		end
	end
	//vsched:EngTask("TASK_RESET_ACTIVITY", 0)
	if vACT_StopActivities == true then
		self:StopAttacks(true)
		self.vACT_StopAttacks = true
		self.NextChaseTime = CurTime() + vACT_StopActivitiesTime
		self.NextIdleTime = CurTime() + vACT_StopActivitiesTime
		if timer.Exists("timer_act_stopattacks") then
			timer.Adjust("timer_act_stopattacks"..self:EntIndex(),vACT_StopActivitiesTime,1,function() self.vACT_StopAttacks = false end)
		else
			timer.Create("timer_act_stopattacks"..self:EntIndex(),vACT_StopActivitiesTime,1,function() self.vACT_StopAttacks = false end)
		end
		//timer.Simple(vACT_StopActivitiesTime,function() self.vACT_StopAttacks = false end)
	end
	self.NextIdleStandTime = 0
	if (vACT_CustomCode) then vACT_CustomCode(vsched) end

	if vTbl_AlwaysUseSequence == false && type(vACT_Name) == "string" then
		local checkanim = self:GetSequenceActivity(self:LookupSequence(vACT_Name))
		if string.find(vACT_Name, "vjseq_") then
			IsSequence = true
			vACT_Name = string.Replace(vACT_Name,"vjseq_","")
		else
			if checkanim == nil or checkanim == -1 then
				IsSequence = true
			else
				vACT_Name = checkanim
			end
		end
	end
	if IsSequence == false then self.VJ_PlayingSequence = false end
	if self.VJ_IsPlayingInterruptSequence == true then self.VJ_IsPlayingInterruptSequence = false end

	if !isnumber(vACT_DelayAnim) then vACT_DelayAnim = 0 end
	timer.Simple(vACT_DelayAnim,function()
	if IsValid(self) then
		if IsGesture == true then
			local gesttest = false
			if IsSequence == false then gesttest = self:AddGesture(vACT_Name) end
			if IsSequence == true then gesttest = self:AddGestureSequence(self:LookupSequence(vACT_Name)) end
			if gesttest != false then
				//self:ClearSchedule()
				//self:SetLayerBlendIn(1,0)
				//self:SetLayerBlendOut(1,0)
				self:SetLayerPriority(gesttest,1) // 2
				//self:SetLayerWeight(gesttest,1)
				self:SetLayerPlaybackRate(gesttest,vTbl_PlayBackRate)
				//self:SetLayerDuration(gesttest,3)
				//print(self:GetLayerDuration(gesttest))
			end
		end
		if IsSequence == true && IsGesture == false then
			seqwait = true
			if vTbl_SequenceDuration == false then seqwait = false end
			vTbl_SequenceDuration = vTbl_SequenceDuration or self:SequenceDuration(self:LookupSequence(vACT_Name))
			if vACT_FaceEnemy == true then self:FaceCertainEntity(self:GetEnemy(),true,vTbl_SequenceDuration) end
			self:VJ_PlaySequence(vACT_Name,1,seqwait,vTbl_SequenceDuration,vTbl_SequenceInterruptible)
		end
		if IsGesture == false then
			self:StartEngineTask(GetTaskList("TASK_RESET_ACTIVITY"), 0)
			//vsched:EngTask("TASK_RESET_ACTIVITY", 0)
			//if self.Dead == true then vsched:EngTask("TASK_STOP_MOVING", 0) end
			//vsched:EngTask("TASK_STOP_MOVING", 0)
			//vsched:EngTask("TASK_STOP_MOVING", 0)
			//self:FrameAdvance(0)
			self:StopMoving()
			self:ClearSchedule()
			///self:ClearGoal()
			if IsSequence == false then
				self.VJ_PlayingSequence = false
				if self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then
					vsched:EngTask("TASK_SET_ACTIVITY",vACT_Name) -- To avoid AutoMovement stopping the velocity
				else
					if vACT_FaceEnemy == true then
						vsched:EngTask("TASK_PLAY_SEQUENCE_FACE_ENEMY",vACT_Name)
					else
						vsched:EngTask("TASK_PLAY_SEQUENCE",vACT_Name)
					end
				end
			end
			//self:ClearSchedule()
			//self:StartEngineTask(GetTaskList("TASK_RESET_ACTIVITY"), 0)
			self:StartSchedule(vsched)
			//self:MaintainActivity()
		end
	 end
	end)
	//self:MaintainActivity()
	//self:TaskComplete()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_TASK_FACE_X(FaceType,CustomCode)
	-- Types: TASK_FACE_TARGET | TASK_FACE_ENEMY | TASK_FACE_PLAYER | TASK_FACE_LASTPOSITION | TASK_FACE_SAVEPOSITION | TASK_FACE_PATH | TASK_FACE_HINTNODE | TASK_FACE_IDEAL | TASK_FACE_REASONABLE
	if self.MovementType == VJ_MOVETYPE_STATIONARY && self.CanTurnWhileStationary == false or (self.IsVJBaseSNPC_Tank == true) then return end
	FaceType = FaceType or "TASK_FACE_TARGET"
	self.NextIdleStandTime = CurTime() + 1.2
	local vschedFaceX = ai_vj_schedule.New("vj_face_x")
	vschedFaceX:EngTask(FaceType, 0)
	if (CustomCode) then CustomCode(vschedFaceX) end
	self:StartSchedule(vschedFaceX)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_TASK_GOTO_LASTPOS(MoveType,CustomCode)
	MoveType = MoveType or "TASK_RUN_PATH"
	local vsched = ai_vj_schedule.New("vj_goto_lastpos")
	vsched:EngTask("TASK_GET_PATH_TO_LASTPOSITION", 0)
	//vsched:EngTask(MoveType, 0)
	vsched:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
	vsched.IsMovingTask = true
	if MoveType == "TASK_RUN_PATH" then self:SetMovementActivity(VJ_PICK(self.AnimTbl_Run)) vsched.IsMovingTask_Run = true else self:SetMovementActivity(VJ_PICK(self.AnimTbl_Walk)) vsched.IsMovingTask_Walk = true end
	//self.CanDoSelectScheduleAgain = false
	//vsched.RunCode_OnFinish = function()
		//self.CanDoSelectScheduleAgain = true
	//end
	if (CustomCode) then CustomCode(vsched) end
	self:StartSchedule(vsched)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_TASK_GOTO_TARGET(MoveType,CustomCode)
	MoveType = MoveType or "TASK_RUN_PATH"
	local vsched = ai_vj_schedule.New("vj_goto_target")
	vsched:EngTask("TASK_GET_PATH_TO_TARGET", 0)
	//vsched:EngTask(MoveType, 0)
	vsched:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
	vsched:EngTask("TASK_FACE_TARGET", 1)
	vsched.IsMovingTask = true
	if MoveType == "TASK_RUN_PATH" then self:SetMovementActivity(VJ_PICK(self.AnimTbl_Run)) vsched.IsMovingTask_Run = true else self:SetMovementActivity(VJ_PICK(self.AnimTbl_Walk)) vsched.IsMovingTask_Walk = true end
	if (CustomCode) then CustomCode(vsched) end
	self:StartSchedule(vsched)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_TASK_GOTO_PLAYER(MoveType,CustomCode)
	MoveType = MoveType or "TASK_RUN_PATH"
	local vsched = ai_vj_schedule.New("vj_goto_player")
	vsched:EngTask("TASK_GET_PATH_TO_PLAYER", 0)
	//vsched:EngTask(MoveType, 0)
	vsched:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
	vsched.IsMovingTask = true
	if MoveType == "TASK_RUN_PATH" then self:SetMovementActivity(VJ_PICK(self.AnimTbl_Run)) vsched.IsMovingTask_Run = true else self:SetMovementActivity(VJ_PICK(self.AnimTbl_Walk)) vsched.IsMovingTask_Walk = true end
	if (CustomCode) then CustomCode(vsched) end
	self:StartSchedule(vsched)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_TASK_COVER_FROM_ENEMY(MoveType,CustomCode)
	if self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then self:AAMove_Wander(true) return end
	MoveType = MoveType or "TASK_RUN_PATH"
	local vsched = ai_vj_schedule.New("vj_cover_from_enemy")
	vsched:EngTask("TASK_FIND_COVER_FROM_ENEMY", 0)
	//vsched:EngTask(MoveType, 0)
	vsched:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
	vsched.IsMovingTask = true
	if MoveType == "TASK_RUN_PATH" then self:SetMovementActivity(VJ_PICK(self.AnimTbl_Run)) vsched.IsMovingTask_Run = true else self:SetMovementActivity(VJ_PICK(self.AnimTbl_Walk)) vsched.IsMovingTask_Walk = true end
	vsched.RunCode_OnFail = function()
		local vschedFail = ai_vj_schedule.New("vj_cover_from_enemy_fail")
		vschedFail:EngTask("TASK_SET_ROUTE_SEARCH_TIME", 1)
		vschedFail:EngTask("TASK_GET_PATH_TO_RANDOM_NODE", 500)
		//vschedFail:EngTask(MoveType, 0)
		vschedFail:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
		vschedFail.IsMovingTask = true
		if MoveType == "TASK_RUN_PATH" then self:SetMovementActivity(VJ_PICK(self.AnimTbl_Run)) vschedFail.IsMovingTask_Run = true else self:SetMovementActivity(VJ_PICK(self.AnimTbl_Walk)) vschedFail.IsMovingTask_Walk = true end
		if (CustomCode) then CustomCode(vschedFail) end
		self:StartSchedule(vschedFail)
	end
	if (CustomCode) then CustomCode(vsched) end
	self:StartSchedule(vsched)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_TASK_IDLE_WANDER()
	self:SetMovementActivity(VJ_PICK(self.AnimTbl_Walk))
	local vsched = ai_vj_schedule.New("vj_idle_wander")
	//self:SetLastPosition(self:GetPos() + self:GetForward() * 300)
	//vsched:EngTask("TASK_SET_ROUTE_SEARCH_TIME", 0)
	//vsched:EngTask("TASK_GET_PATH_TO_LASTPOSITION", 0)
	vsched:EngTask("TASK_GET_PATH_TO_RANDOM_NODE", 350)
	//vsched:EngTask("TASK_WALK_PATH", 0)
	vsched:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
	vsched.ResetOnFail = true
	vsched.CanBeInterrupted = true
	vsched.IsMovingTask = true
	vsched.IsMovingTask_Walk = true
	self:StartSchedule(vsched)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_TASK_CHASE_ENEMY(UseLOSChase)
	UseLOSChase = UseLOSChase or false
	//if self.CurrentSchedule != nil && self.CurrentSchedule.Name == "vj_chase_enemy" then return end
	if self.LatestEnemyPosition == self:GetEnemy():GetPos() && self.CurrentSchedule != nil && self.CurrentSchedule.Name == "vj_chase_enemy" then return end
	if self:GetActivity() == ACT_JUMP or self:GetActivity() == ACT_GLIDE or self:GetActivity() == ACT_LAND or self:GetActivity() == ACT_CLIMB_UP or self:GetActivity() == ACT_CLIMB_DOWN or self:GetActivity() == ACT_CLIMB_DISMOUNT then return end
	self:SetMovementActivity(VJ_PICK(self.AnimTbl_Run))
	if UseLOSChase == true then
		local vsched = ai_vj_schedule.New("vj_chase_enemy")
		vsched:EngTask("TASK_GET_PATH_TO_ENEMY_LOS", 0)
		//vsched:EngTask("TASK_RUN_PATH", 0)
		vsched:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
		//vsched:EngTask("TASK_FACE_ENEMY", 0)
		vsched.ResetOnFail = true
		vsched.CanShootWhenMoving = true
		vsched.CanBeInterrupted = true
		vsched.IsMovingTask = true
		vsched.IsMovingTask_Run = true
		self:StartSchedule(vsched)
	else
		local vsched = ai_vj_schedule.New("vj_chase_enemy")
		vsched:EngTask("TASK_GET_PATH_TO_ENEMY", 0)
		//vsched:EngTask("TASK_RUN_PATH", 0)
		vsched:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
		//vsched:EngTask("TASK_FACE_ENEMY", 0)
		vsched.ResetOnFail = true
		vsched.CanShootWhenMoving = true
		//vsched.StopScheduleIfNotMoving = true
		vsched.CanBeInterrupted = true
		vsched.IsMovingTask = true
		vsched.IsMovingTask_Run = true
		self:StartSchedule(vsched)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_TASK_IDLE_STAND()
	if self:IsMoving() or (self.NextIdleTime > CurTime()) /*or self.CurrentSchedule != nil*/ then return end
	//if (self.CurrentSchedule != nil && self.CurrentSchedule.Name == "vj_idle_stand") or (self.CurrentAnim_CustomIdle != 0 && VJ_IsCurrentAnimation(self,self.CurrentAnim_CustomIdle) == true) then return end
	//local vsched = ai_vj_schedule.New("vj_act_idlestand")
	//vsched:EngTask("TASK_WAIT", waittime)
	//self:StartSchedule(vsched)
	//print(self:GetSequenceName(self:GetSequence()))
	//local idletbl = self.AnimTbl_IdleStand
	//if table.Count(idletbl) > 0 /*&& self:GetSequenceName(self:GetSequence()) != ideanimrand_act*/ then
	//	if VJ_IsCurrentAnimation(self,self.CurrentAnim_IdleStand) != true /*&& VJ_IsCurrentAnimation(self,ACT_IDLE) && self.VJ_PlayingSequence == false && self.VJ_IsPlayingInterruptSequence == false*/ then
	//		self.CurrentAnim_IdleStand = VJ_PICK({idletbl})
	//		self:VJ_ACT_PLAYACTIVITY(self.CurrentAnim_IdleStand,false,0,true,0,{AlwaysUseSequence=true,SequenceDuration=false,SequenceInterruptible=true})
	//	end
	//else
		-- Before --------
		//if self:IsCurrentSchedule(SCHED_IDLE_STAND) != true then
		//	self:VJ_SetSchedule(SCHED_IDLE_STAND)
		//end
		-----------------
	//end
	//if (self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC) && self:GetVelocity():Length() > 0 then return end
	//if self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then self:AAMove_Stop() return end

	/*local vschedIdleStand = ai_vj_schedule.New("vj_idle_stand")
	//vschedIdleStand:EngTask("TASK_FACE_REASONABLE")
	vschedIdleStand:EngTask("TASK_STOP_MOVING")
	vschedIdleStand:EngTask("TASK_WAIT_INDEFINITE")
	vschedIdleStand.CanBeInterrupted = true
	self:StartSchedule(vschedIdleStand)*/

	local animtbl = self.AnimTbl_IdleStand
	if self.NoWeapon_UseScaredBehavior_Active == true then animtbl = self.AnimTbl_ScaredBehaviorStand end
	//local checkedtbl = {}
	local hasanim = false
	for k,v in ipairs(animtbl) do -- Amen animation-nere ara
		v = VJ_SequenceToActivity(self,v) -- Nayir yete animation e sequence e, activity tartsoor
		if v != false then -- Yete v-en false che, sharnage!
			if hasanim == false && self.CurrentAnim_IdleStand == v then -- Yete animation-e IdleStand table-en meche che, ooremen sharnage!
				hasanim = true
			end
			//if self:GetActivity() != v then
				//table.insert(checkedtbl,v)
			//end
		end
	end
	if #animtbl > 1 then -- Yete IdleStand table-e meg en aveli e, sharnage!
		if hasanim == true && self.NextIdleStandTime > CurTime() then return end
		//animtbl = checkedtbl
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
			self:VJ_ACT_PLAYACTIVITY(finaltbl,false,0,false,0,{AlwaysUseSequence=true,SequenceDuration=false,SequenceInterruptible=true})
		end
		if self.CurrentSchedule == nil then -- Yete ooresh pame chenergor 
			self:StartEngineTask(GetTaskList("TASK_RESET_ACTIVITY"), 0) -- Asiga chi tenesne yerp vor nouyn animation-e enen ne yedev yedevi, ge sarin
		end
		self:StartEngineTask(GetTaskList("TASK_PLAY_SEQUENCE"),finaltbl)
		timer.Simple(0.1,function() -- 0.1 hedvargyan espase minchevor khaghe pokhe animation e
			if IsValid(self) then
				local curseq = self:GetSequence()
				local seqtoact = VJ_SequenceToActivity(self,self:GetSequenceName(curseq))
				if seqtoact == finaltbl or seqtoact == self:VJ_TranslateWeaponActivity(finaltbl) then -- Nayir yete himagva animation e nooynene
					self.NextIdleStandTime = CurTime() + (self:SequenceDuration(curseq) - 0.15) -- Yete nooynene ooremen jamanage tir animation-en yergarootyan chap!
				end
			end
		end)
		self.NextIdleStandTime = CurTime() + 0.15 //self:SequenceDuration(self:SelectWeightedSequence(finaltbl))
	end
	//self:StartEngineTask(GetTaskList("TASK_PLAY_SEQUENCE"),finaltbl)
end
---------------------------------------------------------------------------------------------------------------------------------------------
/*function ENT:DoCustomIdleAnimation()
	self.CurrentAnim_CustomIdle = VJ_PICK(self.AnimTbl_IdleStand)
	if self.CurrentAnim_CustomIdle == false then self.CurrentAnim_CustomIdle = 0 return end
	if self:GetActivity() == ACT_IDLE then
		if type(self.CurrentAnim_CustomIdle) == "string" then
			local checkanim = self:GetSequenceActivity(self:LookupSequence(self.CurrentAnim_CustomIdle))
			if checkanim == nil or checkanim == -1 then
				return false
			else
				self.CurrentAnim_CustomIdle = checkanim
			end
		end
		self:StartEngineTask(GetTaskList("TASK_PLAY_SEQUENCE"), self.CurrentAnim_CustomIdle)
	end
end*/
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoIdleAnimation(RestrictNumber,OverrideWander)
	if /*self.VJ_PlayingSequence == true or*/ self.VJ_IsBeingControlled == true /*or self.FollowingPlayer == true*/ or self.PlayingAttackAnimation == true or self.Dead == true or (self.NextIdleTime > CurTime()) or (self.CurrentSchedule != nil && self.CurrentSchedule.Name == "vj_act_resetenemy") then return end
	-- 0 = Random | 1 = Wander | 2 = Idle Stand /\ OverrideWander = Wander no matter what
	RestrictNumber = RestrictNumber or 0
	OverrideWander = OverrideWander or false
	if self.IdleAlwaysWander == true then RestrictNumber = 1 end
	if (self.MovementType == VJ_MOVETYPE_STATIONARY) or (self.IsVJBaseSNPC_Tank == true) or (self.LastHiddenZone_CanWander == false) or (self.NextWanderTime > CurTime()) then RestrictNumber = 2 end
	if OverrideWander == false && (self.DisableWandering == true or self.IsGuard == true) && (RestrictNumber == 1 or RestrictNumber == 0) then
		RestrictNumber = 2
	end
	if RestrictNumber == 0 then -- kharen: gam ge bidedi, gam ge gena
		if math.random(1,3) == 1 then
			/*self:VJ_SetSchedule(VJ_PICK(self.IdleSchedule_Wander))*/ self:VJ_TASK_IDLE_WANDER() else self:VJ_TASK_IDLE_STAND()
		end
	elseif RestrictNumber == 1 then -- bideder
		//self:VJ_SetSchedule(VJ_PICK(self.IdleSchedule_Wander))
		self:VJ_TASK_IDLE_WANDER()
	elseif RestrictNumber == 2 then -- deghed getser
		self:VJ_TASK_IDLE_STAND()
	end
	if RestrictNumber != 2 then
		self.NextWanderTime = CurTime() + math.Rand(3,6) // self.NextIdleTime
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoChaseAnimation(OverrideChasing,ChaseSched)
	if !IsValid(self:GetEnemy()) then return end
	if self.VJ_IsBeingControlled == true or self.IsVJBaseSNPC_Tank == true or /*self.VJ_PlayingSequence == true or*/ self.FollowingPlayer == true or self.PlayingAttackAnimation == true or self.Dead == true or (self.NextChaseTime > CurTime()) or CurTime() < self.TakingCoverT then return end
	if self:VJ_GetNearestPointToEntityDistance(self:GetEnemy()) < self.MeleeAttackDistance && self:GetEnemy():Visible(self) && (self:GetForward():Dot((self:GetEnemy():GetPos() -self:GetPos()):GetNormalized()) > math.cos(math.rad(self.MeleeAttackAngleRadius))) then self:VJ_TASK_IDLE_STAND() return end
	-- OverrideChasing = Chase no matter what
	OverrideChasing = OverrideChasing or false
	//ChaseSched = ChaseSched or VJ_PICK(self.ChaseSchedule)
	local DoScheduleBasedChase = false
	if (self.Behavior == VJ_BEHAVIOR_PASSIVE or self.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE) then
		self:VJ_TASK_COVER_FROM_ENEMY("TASK_RUN_PATH",function(x) end)
		self.NextChaseTime = CurTime() + 3
		return
	end
	if self.MovementType == VJ_MOVETYPE_STATIONARY then self:VJ_TASK_IDLE_STAND() return end
	if self:HasCondition(31) && self:VJ_HasActiveWeapon() == true then DoScheduleBasedChase = true end
	if OverrideChasing == false && (self.DisableChasingEnemy == true or self.IsGuard == true) then self:VJ_TASK_IDLE_STAND() return end
	//if self.HasWalkingCapability == false then self:VJ_TASK_IDLE_STAND() else
	if DoScheduleBasedChase == true then
		//self:VJ_SetSchedule(SCHED_ESTABLISH_LINE_OF_FIRE)
		self:VJ_TASK_CHASE_ENEMY(true)
	else
		self:VJ_TASK_CHASE_ENEMY(false)
	end
	//if self:VJ_HasActiveWeapon() == true then self:VJ_TASK_CHASE_ENEMY(true) else self:VJ_TASK_CHASE_ENEMY(false) end
	if self.NextChaseTime > CurTime() then return end
	if self.LatestEnemyDistance > 2000 then
		self.NextChaseTime = CurTime() + 1
	else
		self.NextChaseTime = CurTime() + 0.1
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BusyWithActivity()
	if self.vACT_StopAttacks == true or self.PlayingAttackAnimation == true then 
		return true
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_ACT_TAKE_COVER(CustomAnimTbl,StopActs,StopActsTime,FaceEnemy)
	CustomAnimTbl = CustomAnimTbl or {}
	StopActs = StopActs or "Partial"
		-- "Full" = Stops all activities and prevents the SNPC from moving or attacking
		-- "Partial" = Stops the SNPC from chasing the enemy and performing attacks unless the enemy is fully visible and in sight
	StopActsTime = StopActsTime or 3
	FaceEnemy = FaceEnemy or false
	local didanim = false
	local pickcust = VJ_PICK(CustomAnimTbl)
	local pickcustb = VJ_PICK(self.AnimTbl_TakingCover)
	
	if pickcust != false then
		self:VJ_ACT_PLAYACTIVITY(pickcust,StopActs,StopActsTime,FaceEnemy,0,{SequenceDuration=StopActsTime})
		didanim = true
	elseif pickcustb != false then
		self:VJ_ACT_PLAYACTIVITY(pickcustb,StopActs,StopActsTime,FaceEnemy,0,{SequenceDuration=StopActsTime})
		didanim = true
	elseif VJ_AnimationExists(self,"Leanwall_CrouchLeft_A_idle") == true then -- Combine
		// "Leanwall_CrouchLeft_A_idle", "Leanwall_CrouchLeft_B_idle", "Leanwall_CrouchLeft_C_idle", "Leanwall_CrouchLeft_D_idle"
		self:VJ_ACT_PLAYACTIVITY(VJ_PICK({"vjseq_Leanwall_CrouchLeft_A_idle", "vjseq_Leanwall_CrouchLeft_B_idle", "vjseq_Leanwall_CrouchLeft_C_idle", "vjseq_Leanwall_CrouchLeft_D_idle"}),StopActs,StopActsTime,FaceEnemy,0,{SequenceDuration=StopActsTime,SequenceInterruptible=true})
		didanim = true
	elseif VJ_AnimationExists(self,"Crouch_idle_pistol") == true then -- Metro Police
		// "Crouch_idle_pistol", "Crouch_idle_smg1"
		if self:GetActiveWeapon().HoldType == "pistol" or self:GetActiveWeapon().HoldType == "revolver" then
			self:VJ_ACT_PLAYACTIVITY("vjseq_Crouch_idle_pistol",StopActs,StopActsTime,FaceEnemy,0,{SequenceDuration=StopActsTime})
			didanim = true
		else
			self:VJ_ACT_PLAYACTIVITY("vjseq_Crouch_idle_smg1",StopActs,StopActsTime,FaceEnemy,0,{SequenceDuration=StopActsTime})
			didanim = true
		end
	elseif VJ_AnimationExists(self,"CoverLow_L") == true then -- Rebel
		// "CoverLow_L", "CoverLow_R", "Crouch_Idle_RPG"
		self:VJ_ACT_PLAYACTIVITY(VJ_PICK({"vjseq_CoverLow_L", "vjseq_CoverLow_R", "vjseq_Crouch_Idle_RPG"}),StopActs,StopActsTime,FaceEnemy,0,{SequenceDuration=StopActsTime})
		didanim = true
	end
	
	if didanim == true then
		self.NextChaseTime = CurTime() + StopActsTime
		self.TakingCoverT = CurTime() + StopActsTime
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Touch(entity)
	if self.VJDEBUG_SNPC_ENABLED == true then if GetConVarNumber("vj_npc_printontouch") == 1 then print(self:GetClass().." Has Touched "..entity:GetClass()) end end
	self:CustomOnTouch(entity)
	if GetConVarNumber("ai_disabled") == 1 then return end
	if self.Behavior == VJ_BEHAVIOR_PASSIVE or self.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE then
		if self.Passive_RunOnTouch == true && self.VJ_IsBeingControlled == false && (entity.Behavior != VJ_BEHAVIOR_PASSIVE or entity.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE) && CurTime() > self.Passive_NextRunOnTouchT then
			if entity:IsNPC() or entity:IsPlayer() then
				if self:DoRelationshipCheck(entity) then
					self:VJ_TASK_COVER_FROM_ENEMY("TASK_RUN_PATH",function(x) end)
					self:AlertSoundCode()
				end
			end
			self.Passive_NextRunOnTouchT = CurTime() + math.Rand(self.Passive_NextRunOnTouchTime.a, self.Passive_NextRunOnTouchTime.b)
		end
	elseif /*self.Alerted == false && */ self.DisableTouchFindEnemy == false && entity:IsNPC() or entity:IsPlayer() && !IsValid(self:GetEnemy()) && self.FollowingPlayer == false && self.VJ_IsBeingControlled == false then
		if self:DoRelationshipCheck(entity) == true then
			//self:FaceCertainEntity(entity)
			self:SetTarget(entity)
			self:VJ_TASK_FACE_X("TASK_FACE_TARGET")
			//self:VJ_SetSchedule(SCHED_TARGET_FACE)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AcceptInput(key,activator,caller,data)
	self:CustomOnAcceptInput(key,activator,caller,data)
	self:FollowPlayerCode(key,activator,caller,data)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleAnimEvent(ev,evTime,evCycle,evType,evOptions)
	self:CustomOnHandleAnimEvent(ev,evTime,evCycle,evType,evOptions)
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
function ENT:OnCondition(iCondition)
	self:CustomOnCondition(iCondition)
	//if iCondition == 36 then print("sched done!") end
	//if iCondition != 15 && iCondition != 60 then
	//if iCondition != 1 then
		//print(self," Condition: ",iCondition," - ",self:ConditionName(iCondition))
	//end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FollowPlayerReset()
	if self.AllowPrintingInChat == true && self.FollowPlayerChat == true then self.FollowPlayer_Entity:PrintMessage(HUD_PRINTTALK, self:GetName().." is no longer following you.") end
	self.FollowingPlayer = false
	self.FollowPlayer_GoingAfter = false
	self.FollowPlayer_Entity = NULL
	self.DisableWandering = self.FollowPlayer_WanderValue
	self.DisableChasingEnemy = self.FollowPlayer_ChaseValue
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FollowPlayerCode(key,activator,caller,data)
	if self.FollowPlayer == false or GetConVarNumber("ai_disabled") == 1 or GetConVarNumber("ai_ignoreplayers") == 1 then return end
	if key == self.FollowPlayerKey && activator:IsValid() && activator:Alive() && activator:IsPlayer() then
		if self:Disposition(activator) == D_HT then
			if self.AllowPrintingInChat == true && self.FollowPlayerChat == true then
				activator:PrintMessage(HUD_PRINTTALK, self:GetName().." doesn't like you, therefore it won't follow you.")
			end
			return
		elseif self:Disposition(activator) == D_NU then
			if self.AllowPrintingInChat == true && self.FollowPlayerChat == true then
				activator:PrintMessage(HUD_PRINTTALK, self:GetName().." is neutral to you, therefore it won't follow you.")
			end
			return
		end
		self:CustomOnFollowPlayer(key,activator,caller,data)
		if self.MovementType == VJ_MOVETYPE_STATIONARY or self.MovementType == VJ_MOVETYPE_PHYSICS then
			if self.AllowPrintingInChat == true && self.FollowPlayerChat == true then
				activator:PrintMessage(HUD_PRINTTALK, self:GetName().." is currently stationary, therefore it's unable follow you.")
			end
			return
		end
		if self.FollowingPlayer == false then
			//self:FaceCertainEntity(activator,false)
			if self.AllowPrintingInChat == true && self.FollowPlayerChat == true then
			activator:PrintMessage(HUD_PRINTTALK, self:GetName().." is now following you.") end
			self.FollowPlayer_WanderValue = self.DisableWandering
			self.FollowPlayer_ChaseValue = self.DisableChasingEnemy
			self.DisableWandering = true
			self.DisableChasingEnemy = true
			self:SetTarget(activator)
			self.FollowPlayer_Entity = activator
			if self:BusyWithActivity() == false then
				self:StopMoving()
				self:VJ_TASK_FACE_X("TASK_FACE_TARGET",function(x) x.RunCode_OnFinish = function()
					local DistanceToPly = self:GetPos():Distance(self.FollowPlayer_Entity:GetPos())
					local movetype = "TASK_RUN_PATH"
					if DistanceToPly < 220 then
						movetype = "TASK_WALK_PATH"
					end
					self:VJ_TASK_GOTO_TARGET(movetype,function(x) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true end) 
				end end)
			end
			//timer.Simple(0.15,function() if self:IsValid() && self.VJ_PlayingSequence == false then self:VJ_SetSchedule(SCHED_TARGET_FACE) end end)
			//if self.VJ_PlayingSequence == false then self:VJ_SetSchedule(SCHED_IDLE_STAND) end
			//timer.Simple(0.1,function() if self:IsValid() then self:VJ_TASK_GOTO_TARGET() end end)
			self:FollowPlayerSoundCode()
			self.FollowingPlayer = true
		else
			self:UnFollowPlayerSoundCode()
			if self:BusyWithActivity() == false then
				self:VJ_TASK_FACE_X("TASK_FACE_TARGET")
			end
			//if self.VJ_PlayingSequence == false then self:VJ_SetSchedule(SCHED_TARGET_FACE) end
			self:FollowPlayerReset()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoMedicCode_Reset()
	self:CustomOnMedic_OnReset()
	if IsValid(self.Medic_CurrentEntToHeal) then self.Medic_CurrentEntToHeal.AlreadyBeingHealedByMedic = false end
	if IsValid(self.Medic_SpawnedProp) then self.Medic_SpawnedProp:Remove() end
	self.Medic_IsHealingAlly = false
	self.AlreadyDoneMedicThinkCode = false
	self.Medic_CurrentEntToHeal = NULL
	self.DisableWandering = self.Medic_WanderValue
	self.DisableChasingEnemy = self.Medic_ChaseValue
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoMedicCode_FindAllies()
	-- for k,v in ipairs(player.GetAll()) do v.AlreadyBeingHealedByMedic = false end
	if self.IsMedicSNPC == false or self.Medic_IsHealingAlly == true or CurTime() < self.Medic_NextHealT or self.VJ_IsBeingControlled == true then return false end
	local findallies = ents.FindInSphere(self:GetPos(),self.Medic_CheckDistance)
	for k,v in ipairs(findallies) do
		if !v:IsNPC() && !v:IsPlayer() then continue end
		if v:EntIndex() != self:EntIndex() && v.AlreadyBeingHealedByMedic == false && (!v.IsVJBaseSNPC_Tank) && v:Health() <= v:GetMaxHealth() * 0.75 && ((v.IsVJBaseSNPC == true && v.Medic_CanBeHealed == true && !IsValid(self:GetEnemy()) && !IsValid(v:GetEnemy())) or (v:IsPlayer() && GetConVarNumber("ai_ignoreplayers") == 0)) then
			if /*self:Disposition(v) == D_LI &&*/ self:DoRelationshipCheck(v) == false then
				self.Medic_NextHealT = CurTime() + math.Rand(self.Medic_NextHealTime1,self.Medic_NextHealTime2)
				self.NextIdleTime = CurTime() + 5
				self.NextChaseTime = CurTime() + 5
				self.Medic_WanderValue = self.DisableWandering
				self.Medic_ChaseValue = self.DisableChasingEnemy
				self.DisableWandering = true
				self.DisableChasingEnemy = true
				self.Medic_CurrentEntToHeal = v
				self.Medic_IsHealingAlly = true
				self.AlreadyDoneMedicThinkCode = false
				v.AlreadyBeingHealedByMedic = true
				//self:SelectSchedule()
				//self:VJ_SetSchedule(SCHED_IDLE_STAND)
				self:SelectSchedule()
				self:StopMoving()
				self:StopMoving()
				self:SetTarget(v)
				self:VJ_TASK_GOTO_TARGET()
			return true
			end
		end
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoMedicCode_HealAlly()
	if self.IsMedicSNPC == true && self.Medic_IsHealingAlly == true && self.AlreadyDoneMedicThinkCode == false then
		if !IsValid(self.Medic_CurrentEntToHeal) or VJ_IsAlive(self.Medic_CurrentEntToHeal) != true then self:DoMedicCode_Reset() return false end
		//print(self.FollowPlayer_Entity)
		if IsValid(self.Medic_CurrentEntToHeal) && VJ_IsAlive(self.Medic_CurrentEntToHeal) == true then
			if self.Medic_CurrentEntToHeal:Health() > self.Medic_CurrentEntToHeal:GetMaxHealth() * 0.75 then self:DoMedicCode_Reset() return false end
			if self:GetPos():Distance(self.Medic_CurrentEntToHeal:GetPos()) <= self.Medic_HealDistance then
				self.AlreadyDoneMedicThinkCode = true
				self:CustomOnMedic_BeforeHeal()
				self:MedicSoundCode_BeforeHeal()
				if self.Medic_SpawnPropOnHeal == true && self:LookupAttachment(self.Medic_SpawnPropOnHealAttachment) != 0 then
					self.Medic_SpawnedProp = ents.Create("prop_physics")
					self.Medic_SpawnedProp:SetModel(self.Medic_SpawnPropOnHealModel)
					self.Medic_SpawnedProp:SetLocalPos(self:GetPos())
					self.Medic_SpawnedProp:SetOwner(self)
					self.Medic_SpawnedProp:SetParent(self)
					self.Medic_SpawnedProp:Fire("SetParentAttachment",self.Medic_SpawnPropOnHealAttachment)
					self.Medic_SpawnedProp:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
					self.Medic_SpawnedProp:Spawn()
					self.Medic_SpawnedProp:Activate()
					self.Medic_SpawnedProp:SetSolid(SOLID_NONE)
					//self.Medic_SpawnedProp:AddEffects(EF_BONEMERGE)
					self.Medic_SpawnedProp:SetRenderMode(RENDERMODE_TRANSALPHA)
					self:DeleteOnRemove(self.Medic_SpawnedProp)
				end
				local anim = VJ_PICK(self.AnimTbl_Medic_GiveHealth)
				local dontdoturn = false
				self:FaceCertainEntity(self.Medic_CurrentEntToHeal,false)
				if self.Medic_DisableAnimation != true then
					self:VJ_ACT_PLAYACTIVITY(anim,true,false,false)
				end
				if self.Medic_CurrentEntToHeal.MovementType == VJ_MOVETYPE_STATIONARY && self.Medic_CurrentEntToHeal.CanTurnWhileStationary == true then dontdoturn = true end
				if !self.Medic_CurrentEntToHeal:IsPlayer() && dontdoturn == false then
					self.NextWanderTime = CurTime() + 2
					self.Medic_CurrentEntToHeal:StopMoving()
					self.Medic_CurrentEntToHeal:SetTarget(self)
					self.Medic_CurrentEntToHeal:VJ_TASK_FACE_X("TASK_FACE_TARGET")
					//self.Medic_CurrentEntToHeal:VJ_SetSchedule(SCHED_TARGET_FACE)
				end
				timer.Simple(self:DecideAnimationLength(anim,self.Medic_TimeUntilHeal,0),function()
					if IsValid(self) then -- Yete NPC ter hos e...
						if IsValid(self.Medic_CurrentEntToHeal) then -- Yete NPC vor meng bidi aghektsnenk hos e...
							if self:GetPos():Distance(self.Medic_CurrentEntToHeal:GetPos()) <= self.Medic_HealDistance then
								self:CustomOnMedic_OnHeal()
								self:MedicSoundCode_OnHeal()
								if self.Medic_CurrentEntToHeal:IsNPC() && self.Medic_CurrentEntToHeal.IsVJBaseSNPC == true && self.Medic_CurrentEntToHeal.IsVJBaseSNPC_Animal != true then
									self.Medic_CurrentEntToHeal:MedicSoundCode_ReceiveHeal()
								end
								self.Medic_CurrentEntToHeal:RemoveAllDecals()
								local frimaxhp = self.Medic_CurrentEntToHeal:GetMaxHealth()
								local fricurhp = self.Medic_CurrentEntToHeal:Health()
								self.Medic_CurrentEntToHeal:SetHealth(math.Clamp(fricurhp + self.Medic_HealthAmount,fricurhp,frimaxhp))
								self:DoMedicCode_Reset()
							else -- Ere vor NPC yed yerta mouys NPC-en yedeven
								self.AlreadyDoneMedicThinkCode = false
								if IsValid(self.Medic_SpawnedProp) then self.Medic_SpawnedProp:Remove() end
								self:CustomOnMedic_OnReset()
							end
						else -- Yete NPC vor meng bidi aghektsnenk hos che, amen inch yed normaltsoor
							self:DoMedicCode_Reset()
						end
					end
				end)
			else -- Ere vor NPC yed yerta mouys NPC-en yedeven
				self.NextIdleTime = CurTime() + 4
				self.NextChaseTime = CurTime() + 4
				self:SetTarget(self.Medic_CurrentEntToHeal)
				self:VJ_TASK_GOTO_TARGET()
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoConstantlyFaceEnemyCode()
	if self.Dead == true or self.VJ_IsBeingControlled == true then return false end
	if self.ConstantlyFaceEnemy == true && self:GetEnemy():GetPos():Distance(self:GetPos()) < self.ConstantlyFaceEnemyDistance then
		if self.ConstantlyFaceEnemy_IfVisible == true && !self:Visible(self:GetEnemy()) then return false end
		if self.ConstantlyFaceEnemy_IfAttacking == false && (self.MeleeAttacking == true or self.LeapAttacking == true or self.RangeAttacking == true or self.ThrowingGrenade == true) then return false end
		if self.ConstantlyFaceEnemy_Postures != "Both" then
			if self.ConstantlyFaceEnemy_Postures == "Moving" && !self:IsMoving() then return false end
			if self.ConstantlyFaceEnemy_Postures == "Standing" && self:IsMoving() then return false end
		end
		self:SetAngles(self:VJ_ReturnAngle((self:GetEnemy():GetPos()-self:GetPos()):Angle()))
		return true
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoChangeWeapon(SetType)
	SetType = SetType or "None"
	if SetType != "None" then
		if IsValid(self:GetActiveWeapon()) then self:GetActiveWeapon():Remove() end
		self:Give(SetType)
	end
	self.Weapon_ShotsSinceLastReload = 0
	/*if self:VJ_HasActiveWeapon() == true then
		if self.Weapons_UseRegulate[self:GetActiveWeapon():GetClass()] then // self.DisableUSE_SHOT_REGULATOR == false
			self:CapabilitiesAdd(bit.bor(CAP_USE_SHOT_REGULATOR))
		end
		if self.Weapons_DontUseRegulate[self:GetActiveWeapon():GetClass()] then //or self:GetActiveWeapon().NPC_EnableDontUseRegulate == true then
			self:CapabilitiesRemove(CAP_USE_SHOT_REGULATOR)
		end
	end*/
	self:CustomOnDoChangeWeapon(self:GetActiveWeapon(),self.CurrentWeaponEntity)
end
//ENT.TurningLerp = nil
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	self:SetCondition(1) -- Fix attachments, bones, positions, angles etc. being broken in NPCs! This condition is used as a backup in case sv_pvsskipanimation isn't disabled!
	
	/*if self.FollowingPlayer == true then
		if self.TurningLerp == nil then self.TurningLerp = Angle(0,self:GetAngles().y,0) end
		self.TurningLerp = LerpAngle(math.Clamp(FrameTime() * 5, 0.2, 1), self.TurningLerp, Angle(0,(self.FollowPlayer_Entity:GetPos() - self:GetPos()):Angle().y, 0))
		print("------------")
		print((self.FollowPlayer_Entity:GetPos() - self:GetPos()):Angle().y)
		print("Mine: ", self:GetAngles())
		print("Target: ", self.FollowPlayer_Entity:GetAngles())
		print("Lerp: ", self.TurningLerp)
		print(math.abs(math.AngleDifference(self:GetAngles().y, self.TurningLerp.y)))
		print(math.abs(math.AngleDifference(self:GetAngles().y, self.TurningLerp.y)) / (0.5))
		//print(self.TurningLerp)
		self:SetAngles(self.TurningLerp)
	end*/
	//if self.CurrentSchedule != nil then PrintTable(self.CurrentSchedule) end
	//if self.CurrentTask != nil then PrintTable(self.CurrentTask) end
	if self:GetVelocity():Length() <= 0 && self.MovementType == VJ_MOVETYPE_GROUND /*&& CurSched.IsMovingTask == true*/ then self:DropToFloor() end

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
		if CurSched.StopScheduleIfNotMoving == true && (!self:IsMoving() or (self:GetBlockingEntity() != nil && self:GetBlockingEntity():IsNPC())) then // (self:GetGroundSpeedVelocity():Length() <= 0) == true
			self:ScheduleFinished(CurSched)
			//self:SetCondition(35)
			//self:StopMoving()
		end
		if self:HasCondition(35) && CurSched.AlreadyRanCode_OnFail == false then
			if self:DoRunCode_OnFail(CurSched) == true then
				self:ClearCondition(35)
			end
		end
		if CurSched.ResetOnFail == true && self:HasCondition(35) == true then
			self:StopMoving()
			//self:SelectSchedule()
			self:ClearCondition(35)
			//print("VJ Base: Task Failed Condition Identified! "..self:GetName())
		end
	end
	if self.DoingWeaponAttack == false then self.DoingWeaponAttack_Standing = false end
	//if CurTime() > self.TestT then
	//self:VJ_ACT_PLAYACTIVITY(ACT_SIGNAL_ADVANCE,true,2,true,0.5)
	//self.TestT = CurTime() + 200 end
	//if self:GetActiveWeapon():GetClass() == "weapon_smg1" then print("SMG1") end
	//self:SetColor(Color(0,1000,0))

	if self.CurrentWeaponEntity != self:GetActiveWeapon() then self:DoChangeWeapon() end
	self.CurrentWeaponEntity = self:GetActiveWeapon()

	//self:ConvarsOnThink()
	self:CustomOnThink()

	if self.HasSounds == false or self.Dead == true then VJ_STOPSOUND(self.CurrentBreathSound) end
	if self.Dead == false && self.HasBreathSound == true && self.HasSounds == true then
		if CurTime() > self.NextBreathSoundT then
			local brsd = VJ_PICK(self.SoundTbl_Breath)
			local dur = math.Rand(self.NextSoundTime_Breath1,self.NextSoundTime_Breath2)
			if brsd != false then
				VJ_STOPSOUND(self.CurrentBreathSound)
				if self.NextSoundTime_Breath_BaseDecide == true then
					dur = SoundDuration(brsd)
				end
				self.CurrentBreathSound = VJ_CreateSound(self,brsd,self.BreathSoundLevel,self:VJ_DecideSoundPitch(self.BreathSoundPitch1,self.BreathSoundPitch2))
			end
			self.NextBreathSoundT = CurTime() + dur
		end
	end
	--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
	if GetConVarNumber("ai_disabled") == 0 then
		if self:GetArrivalActivity() == -1 then
			self:SetArrivalActivity(self.CurrentAnim_IdleStand)
		end
		
		self:CustomOnThink_AIEnabled()
		//self:DoCustomIdleAnimation()
		//if IsValid(self:GetEnemy()) then self.Alerted = true else self.Alerted = false end
		if self.VJDEBUG_SNPC_ENABLED == true then
			if GetConVarNumber("vj_npc_printcurenemy") == 1 then print(self:GetClass().."'s Enemy: ",self:GetEnemy()," Alerted? ",self.Alerted) end
			if GetConVarNumber("vj_npc_printtakingcover") == 1 then if CurTime() > self.TakingCoverT == true then print(self:GetClass().." Is Not Taking Cover") else print(self:GetClass().." Is Taking Cover ("..self.TakingCoverT-CurTime()..")") end end
			if GetConVarNumber("vj_npc_printlastseenenemy") == 1 then PrintMessage(HUD_PRINTTALK, self.LastSeenEnemyTime.." ("..self:GetName()..")") end
			if self:VJ_HasActiveWeapon() == true then
				if GetConVarNumber("vj_npc_printaccuracy") == 1 then print(self:GetClass().."'s Accuracy (Weapon Spread, Proficiency) = "..self.WeaponSpread.." | "..self:GetCurrentWeaponProficiency()) end
				if GetConVarNumber("vj_npc_printammo") == 1 then print(self:GetClass().."'s Ammo = VJ Ammo: "..self.Weapon_ShotsSinceLastReload.."/"..self.Weapon_StartingAmmoAmount.." | GMod Ammo: "..self:GetActiveWeapon():Clip1()) end
				if GetConVarNumber("vj_npc_printweapon") == 1 then print(self:GetClass().."'s",self:GetActiveWeapon()) end
			end
		end

		if self.DisableFootStepSoundTimer == false then self:FootStepSoundCode() end
		self:WorldShakeOnMoveCode()
		
		if self.HasHealthRegeneration == true && self.Dead == false && CurTime() > self.HealthRegenerationDelayT then
			self:SetHealth(math.Clamp(self:Health() + self.HealthRegenerationAmount, self:Health(), self:GetMaxHealth()))
			self.HealthRegenerationDelayT = CurTime() + math.Rand(self.HealthRegenerationDelay.a, self.HealthRegenerationDelay.b)
		end
		
		if self:GetActiveWeapon() != NULL then self.Weapon_TimeSinceLastShot = self.Weapon_TimeSinceLastShot + 0.1 end

		/*if self:GetActiveWeapon() == NULL then
			self.AnimTbl_IdleStand = {"Idle_Unarmed"}
			self:SetMovementActivity(self:GetSequenceActivity(self:LookupSequence("WalkUnarmed_all")))
		end*/

		if self.FollowingPlayer == true then
			//print(self:GetTarget())
			//print(self.FollowPlayer_Entity)
			if GetConVarNumber("ai_ignoreplayers") == 0 then
				if !IsValid(self.FollowPlayer_Entity) or !self.FollowPlayer_Entity:Alive() or self:Disposition(self.FollowPlayer_Entity) != D_LI then self:FollowPlayerReset() end
				if CurTime() > self.NextFollowPlayerT && IsValid(self.FollowPlayer_Entity) && self.FollowPlayer_Entity:Alive() && self.AlreadyBeingHealedByMedic == false then
					local DistanceToPly = self:GetPos():Distance(self.FollowPlayer_Entity:GetPos())
					local busy = self:BusyWithActivity()
					local abletomove = true
					self:SetTarget(self.FollowPlayer_Entity)
					if busy == true && DistanceToPly < (self.FollowPlayerCloseDistance * 4) then
						abletomove = false
					end
					if DistanceToPly > self.FollowPlayerCloseDistance then
						if abletomove == true then
							self.FollowPlayer_GoingAfter = true
							self.AlreadyDone_RunSelectSchedule_FollowPlayer = false
							if busy == false then
								local movetype = "TASK_RUN_PATH"
								if DistanceToPly < 220 then
									movetype = "TASK_WALK_PATH"
								end
								self:VJ_TASK_GOTO_TARGET(movetype,function(x)
									x.CanShootWhenMoving = true
									if self:VJ_HasActiveWeapon() == true then
										x.ConstantlyFaceEnemyVisible = true
									end
								end)
							end
						end
					elseif self.AlreadyDone_RunSelectSchedule_FollowPlayer == false then
						if busy == false then
							self:StopMoving()
							self:SelectSchedule()
						end
						self.FollowPlayer_GoingAfter = false
						self.AlreadyDone_RunSelectSchedule_FollowPlayer = true
					end
					self.NextFollowPlayerT = CurTime() + self.NextFollowPlayerTime
				end
			else
				self:FollowPlayerReset()
			end
		end

		//print(self:GetPathTimeToGoal())
		//print(self:GetPathDistanceToGoal())
		/*if self.PlayedResetEnemyRunSchedule == true && !self:IsCurrentSchedule(SCHED_FORCED_GO_RUN) == true && (!self.IsVJBaseSNPC_Tank) then
			self.PlayedResetEnemyRunSchedule = false
			if self.Alerted == false then
				//self:VJ_SetSchedule(SCHED_ALERT_SCAN)
				//self:VJ_ACT_PLAYACTIVITY(ACT_RANGE_ATTACK1,true,2,false)
				timer.Simple(5,function()
					if self:IsValid() && self.DisableWandering == false then
						self:DoIdleAnimation(1)
					end
				end)
			end
		end*/
		
		local ene = self:GetEnemy()
		
		//print(self.Weapon_ShotsSinceLastReload)
		//print(self.Weapon_StartingAmmoAmount)
		if self.Weapon_StartingAmmoAmount == nil then
			self.Weapon_StartingAmmoAmount = 30
		end
		//print(self:HasCondition(13))
		if self.Dead == false && self.AllowWeaponReloading == true && self.CurrentWeaponEntity == self:GetActiveWeapon() && self.IsReloadingWeapon == false && self:VJ_HasActiveWeapon() == true && self.FollowPlayer_GoingAfter == false && self.ThrowingGrenade == false && self.MeleeAttacking == false && self.VJ_PlayingSequence == false && (!self.IsVJBaseSNPC_Tank) then
			local teshnami = IsValid(ene) -- Teshnami ooni, gam voch?
			//if CurTime() > self.NextReloadT then
			//if math.random(1,self.ReloadChance) < 3 then
			if (teshnami == false && self.Weapon_ShotsSinceLastReload > 0 && self.TimeSinceLastSeenEnemy > math.random(3,8) && !self:IsMoving()) or (teshnami == true && self.Weapon_ShotsSinceLastReload >= self.Weapon_StartingAmmoAmount) or (self.VJ_IsBeingControlled == true && self.VJ_TheController:KeyDown(IN_RELOAD) && self.Weapon_ShotsSinceLastReload > 0) then
				if self.Weapon_UnlimitedAmmo == true then self:GetActiveWeapon():SetClip1(99999) end
				//self.Weapon_ShotsSinceLastReload = 0
				self.DoingWeaponAttack = false
				self.DoingWeaponAttack_Standing = false
				if self.VJ_IsBeingControlled == false then self.IsReloadingWeapon = true end
				self.NextChaseTime = CurTime() + 2
				//timer.Simple(5,function() if IsValid(self) then self.IsReloadingWeapon = false end end)
				if teshnami == true then self:WeaponReloadSoundCode() end
				self:CustomOnWeaponReload()
				if self.DisableWeaponReloadAnimation == false then
					local function DoReloadAnimation(animtbl)
						self:GetActiveWeapon():NPC_ReloadWeapon()
						self.CurrentAnim_WeaponReload = VJ_PICK(animtbl)
						local translateact = self:VJ_TranslateWeaponActivity(self.CurrentAnim_WeaponReload)
						if VJ_AnimationExists(self,translateact) == true then
							self.CurrentAnim_WeaponReload = translateact
						end
						self.CurrentAnimDuration_WeaponReload = VJ_GetSequenceDuration(self,self.CurrentAnim_WeaponReload) - self.WeaponReloadAnimationDecreaseLengthAmount
						timer.Simple(self.CurrentAnimDuration_WeaponReload,function() if IsValid(self) then self.IsReloadingWeapon = false self.Weapon_ShotsSinceLastReload = 0 end end)
						self:VJ_ACT_PLAYACTIVITY(self.CurrentAnim_WeaponReload,true,self.CurrentAnimDuration_WeaponReload,self.WeaponReloadAnimationFaceEnemy,self.WeaponReloadAnimationDelay,{SequenceDuration=self.CurrentAnimDuration_WeaponReload})
					end
					if self.VJ_IsBeingControlled == true then
						if self.VJ_TheController:KeyDown(IN_RELOAD) then -- When being controlled
							self.IsReloadingWeapon = true
							DoReloadAnimation(self.AnimTbl_WeaponReload)
						end
					else -- If not being controlled...
						if teshnami == true && self:VJ_ForwardIsHidingZone(self:NearestPoint(self:GetPos()+self:OBBCenter()),ene:EyePos(),false,{SetLastHiddenTime=true}) == true then -- Behvedadz
							self.CurrentAnim_WeaponReload = VJ_PICK(self.AnimTbl_WeaponReloadBehindCover)
							if VJ_AnimationExists(self,self.CurrentAnim_WeaponReload) == true or VJ_AnimationExists(self,self:VJ_TranslateWeaponActivity(self.CurrentAnim_WeaponReload)) then
								DoReloadAnimation(self.CurrentAnim_WeaponReload)
							else -- Yete animation chouni...
								DoReloadAnimation(self.AnimTbl_WeaponReload)
							end
						else -- Yete bahvedadz che...
							if self.IsGuard == true or self.FollowingPlayer == true or self.VJ_IsBeingControlled_Tool == true or teshnami == false then -- Getsadz letsenel togh ene (Mi vazer!)
								DoReloadAnimation(self.AnimTbl_WeaponReload)
							else -- Togh vaz e
								self:SetMovementActivity(VJ_PICK(self.AnimTbl_Run))
								local vschedWeaponReload = ai_vj_schedule.New("vj_weapon_reload")
								vschedWeaponReload:EngTask("TASK_FIND_COVER_FROM_ENEMY", 0)
								//vschedWeaponReload:EngTask("TASK_RUN_PATH", 0)
								vschedWeaponReload:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
								vschedWeaponReload.StopScheduleIfNotMoving = true
								vschedWeaponReload.IsMovingTask = true
								vschedWeaponReload.IsMovingTask_Run = true
								vschedWeaponReload.RunCode_OnFinish = function()
									-- Yete teshnamin modig e, zenke mi letsener!
									if self.HasRunFromEnemy == true && (self:GetPos():Distance(self:GetEnemy():GetPos()) <= self.RunFromEnemy_Distance) then
										self.IsReloadingWeapon = false
									else
										DoReloadAnimation(self.AnimTbl_WeaponReload)
										self:CustomOnWeaponReload_AfterRanToCover()
									end
								end
								self:StartSchedule(vschedWeaponReload)
							end
						end
					end
				else
					self.Weapon_ShotsSinceLastReload = 0
					self.IsReloadingWeapon = false
					self:GetActiveWeapon():NPC_ReloadWeapon()
				end
			end
			//self.NextReloadT = CurTime() + self.NextReloadTime end end end
		end
		
		if self.DoingWeaponAttack == true then self:CapabilitiesRemove(CAP_TURN_HEAD) else self:CapabilitiesAdd(bit.bor(CAP_TURN_HEAD)) end
		if IsValid(ene) then
			if self.DoingWeaponAttack == true then self:SuppressingSoundCode() end
			if self.IsDoingFaceEnemy == true /*&& self.VJ_IsBeingControlled == false*/ then self:SetAngles(self:VJ_ReturnAngle((ene:GetPos()-self:GetPos()):Angle())) end
			self:DoConstantlyFaceEnemyCode()
			if (self.CurrentSchedule != nil && ((self.CurrentSchedule.ConstantlyFaceEnemy == true) or (self.CurrentSchedule.ConstantlyFaceEnemyVisible == true && self:Visible(ene))) /*&& self.VJ_IsBeingControlled == false*/) then self:SetAngles(self:VJ_ReturnAngle((ene:GetPos()-self:GetPos()):Angle())) end
			self.ResetedEnemy = false
			self:UpdateEnemyMemory(ene,ene:GetPos())
			self.LatestEnemyPosition = ene:GetPos()
			self.LatestEnemyDistance = self:GetPos():Distance(ene:GetPos())
			self.LatestEnemyClass = ene
			self.TimeSinceLastSeenEnemy = 0
			self.TimeSinceSeenEnemy = self.TimeSinceSeenEnemy + 0.1
			if (self:GetForward():Dot((ene:GetPos() - self:GetPos()):GetNormalized()) > math.cos(math.rad(self.SightAngle))) && (self.LatestEnemyDistance < self.SightDistance) then
				local seentr = util.TraceLine({start = self:NearestPoint(self:GetPos() +self:OBBCenter()),endpos = ene:EyePos(),filter = function(ent) if (ent:GetClass() == self:GetClass() or self:Disposition(ent) == D_LI) then return false end end})
				if (ene:Visible(self) or (IsValid(seentr.Entity) && seentr.Entity:GetClass() == ene)) then
					self.LastSeenEnemyTime = 0
					self.LatestVisibleEnemyPosition = ene:GetPos()
				else
					if (self.LatestEnemyDistance < 4000) then self.LastSeenEnemyTime = self.LastSeenEnemyTime + 0.1 else self.LastSeenEnemyTime = self.LastSeenEnemyTime + 0.5 end
				end
			else
				if (self.LatestEnemyDistance < 4000) then self.LastSeenEnemyTime = self.LastSeenEnemyTime + 0.1 else self.LastSeenEnemyTime = self.LastSeenEnemyTime + 0.5 end
			end

			if self.ThrowingGrenade == false && self.CallForHelp == true && self.Dead == false then
				if CurTime() > self.NextCallForHelpT then
					self:CallForHelpCode(self.CallForHelpDistance)
					self.NextCallForHelpT = CurTime() + self.NextCallForHelpTime
				end
			end

			if self.HasGrenadeAttack == true && self.IsReloadingWeapon == false && self.vACT_StopAttacks == false && CurTime() > self.NextThrowGrenadeT && CurTime() > self.TakingCoverT then
				if self.VJ_IsBeingControlled == true && self.VJ_TheController:KeyDown(IN_JUMP) then
					self:ThrowGrenadeCode()
					self.NextThrowGrenadeT = CurTime() + math.random(self.NextThrowGrenadeTime1,self.NextThrowGrenadeTime2)
				elseif self.VJ_IsBeingControlled == false then
					local chance = self.ThrowGrenadeChance
					local finalc = math.random(1,chance)
					if chance != 1 && chance != 2 && chance != 3 && (ene.IsVJBaseSNPC_Tank or !self:Visible(ene)) then -- Shede misd meg gela!
						finalc = math.random(1,math.floor(chance / 2))
					end
					if finalc == 1 then
						if self.LatestEnemyDistance < self.GrenadeAttackThrowDistance && self.LatestEnemyDistance > self.GrenadeAttackThrowDistanceClose then
							self:ThrowGrenadeCode()
						end
					end
					self.NextThrowGrenadeT = CurTime() + math.random(self.NextThrowGrenadeTime1,self.NextThrowGrenadeTime2)
				end
			end
		end

		if CurTime() > self.NextProcessT then
			self:DoEntityRelationshipCheck()
			self:CheckForGrenades()
			self:DoMedicCode_FindAllies()
			self:DoMedicCode_HealAlly()
			/*if IsValid(self:GetEnemy()) && self:Visible(self:GetEnemy()) && (self:GetActiveWeapon().IsVJBaseWeapon) && self.DoingWeaponAttack == false then
				//self:FaceCertainEntity(self:GetEnemy(),true)
				if !VJ_HasValue(self.AnimTbl_WeaponAttack,self:GetActivity()) && !VJ_HasValue(self.AnimTbl_WeaponAttackCrouch,self:GetActivity()) then
				self:SelectSchedule()
				end
			end*/
			self.NextProcessT = CurTime() + self.NextProcessTime
		end

		if self.ResetedEnemy == false then
			if self.LastSeenEnemyTime > self.LastSeenEnemyTimeUntilReset && (!self.IsVJBaseSNPC_Tank) then
				self:LostEnemySoundCode()
				self.ResetedEnemy = true
				self:ResetEnemy(true)
			end

			if (!IsValid(self:GetEnemy())) or (IsValid(self:GetEnemy()) && self:GetEnemy():Health() <= 0) then
				self.ResetedEnemy = true
				self:ResetEnemy(true)
			end
		end

		//if self:HasCondition(4) then print("conf worked") self:GetActiveWeapon():SetClip1(45) end

		/*if CurTime() > self.NextCallForHelpT then
		local SequenceID = self:LookupSequence("shootAR2s")
		self:SetSequence(SequenceID)
		self:SetPlaybackRate(0.01)
		self:SetNPCState(NPC_STATE_COMBAT)
		//self:MaintainActivity()
		//self:ResetSequence(SequenceID)
		self.NextCallForHelpT = CurTime() + 0.1 end*/
		//self:SetNPCState(NPC_STATE_COMBAT)

		/*if IsValid(self:GetEnemy()) then
			print(self:Visible(self:GetEnemy()))
			if self:Visible(self:GetEnemy()) == false then
			if self:GetMovementActivity() == ACT_WALK then
				self:SetMovementActivity(ACT_WALK_AIM_RIFLE)
			end
			self:SetLastPosition(self:GetEnemy():GetPos())
			self:VJ_SetSchedule(SCHED_FORCED_GO)
			end
		end*/

		--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
			-- Attack Timers --
		ene = self:GetEnemy()
		if IsValid(ene) then
			self.DoneLastHiddenZone_CanWander = false
			if self:VJ_HasActiveWeapon() == false && self.NoWeapon_UseScaredBehavior == true && self.VJ_IsBeingControlled == false then
				local anim = VJ_PICK(self.AnimTbl_ScaredBehaviorMovement)
				if anim != false then
					self:SetMovementActivity(anim)
				else
					if VJ_AnimationExists(self,ACT_RUN_PROTECTED) == true then
						self:SetMovementActivity(ACT_RUN_PROTECTED)
					elseif VJ_AnimationExists(self,ACT_RUN_CROUCH_RIFLE) == true then
						self:SetMovementActivity(ACT_RUN_CROUCH_RIFLE)
					end
				end
				self:SetArrivalActivity(VJ_PICK(self.AnimTbl_ScaredBehaviorStand))
			end
			self:WeaponAimPoseParameters()
			if (self:Visible(ene) == false or (!VJ_HasValue(self.AnimTbl_WeaponAttack,self:GetActivity()) && !VJ_HasValue(self.AnimTbl_WeaponAttackCrouch,self:GetActivity()))) then
				self.DoingWeaponAttack = false
				self.DoingWeaponAttack_Standing = false
			end
			self:DoWeaponAttackMovementCode()
			//if self.VJ_IsBeingControlled == false then
				if self.Dead == false && self.MovementType == VJ_MOVETYPE_STATIONARY && self.CanTurnWhileStationary == true then self:FaceCertainEntity(ene,true) end
				if self.MeleeAttackAnimationFaceEnemy == true && self.Dead == false && timer.Exists("timer_melee_start"..self:EntIndex()) && timer.TimeLeft("timer_melee_start"..self:EntIndex()) > 0 then self:FaceCertainEntity(ene,true) end
				if self.GrenadeAttackAnimationFaceEnemy == true && self.Dead == false && self.ThrowingGrenade == true && self:Visible(ene) == true then self:FaceCertainEntity(ene,true) end
			//end
			//if self.PlayingAttackAnimation == true then self:FaceCertainEntity(ene,true) end
			self.ResetedEnemy = false
			self.NearestPointToEnemyDistance = self:VJ_GetNearestPointToEntityDistance(ene)

			-- Melee Attack Timer --
			if self.HasMeleeAttack == true then
				//print(self:NearestPoint(ene:GetPos() +self:OBBCenter()):Distance(ene:NearestPoint(self:GetPos() +ene:OBBCenter())))
				// ene:GetPos():Distance(self:GetPos())
				if self:CanDoCertainAttack("MeleeAttack") == true then
					local isbeingcontrolled = false
					local isbeingcontrolled_attack = false
					if self.VJ_IsBeingControlled == true then isbeingcontrolled = true end
					if isbeingcontrolled == true && self.VJ_TheController:KeyDown(IN_ATTACK) then isbeingcontrolled_attack = true end
					if (isbeingcontrolled == true && isbeingcontrolled_attack == true) or (isbeingcontrolled == false && (self.NearestPointToEnemyDistance < self.MeleeAttackDistance && ene:Visible(self)) /*&& self.VJ_PlayingSequence == false*/ && (self:GetForward():Dot((ene:GetPos() -self:GetPos()):GetNormalized()) > math.cos(math.rad(self.MeleeAttackAngleRadius)))) then
						self.MeleeAttacking = true
						self.AlreadyDoneMeleeAttackFirstHit = false
						self.IsAbleToMeleeAttack = false
						self.AlreadyDoneFirstMeleeAttack = false
						/*if self.VJ_IsBeingControlled == false then*/ self:FaceCertainEntity(ene,true) //end
						self:CustomOnMeleeAttack_BeforeStartTimer()
						timer.Simple(self.BeforeMeleeAttackSounds_WaitTime,function() if IsValid(self) then self:BeforeMeleeAttackSoundCode() end end)
						self.NextAlertSoundT = CurTime() + 0.4
						if self.DisableMeleeAttackAnimation == false then
							self.CurrentAttackAnimation = VJ_PICK(self.AnimTbl_MeleeAttack)
							self.CurrentAttackAnimationDuration = VJ_GetSequenceDuration(self,self.CurrentAttackAnimation) -self.MeleeAttackAnimationDecreaseLengthAmount
							if self.MeleeAttackAnimationAllowOtherTasks == false then
								self.PlayingAttackAnimation = true
								timer.Simple(self.CurrentAttackAnimationDuration,function()
									if IsValid(self) then
										self.PlayingAttackAnimation = false
									end
								end)
							end
							self:VJ_ACT_PLAYACTIVITY(self.CurrentAttackAnimation,false,0,false,self.MeleeAttackAnimationDelay,{SequenceDuration=self.CurrentAttackAnimationDuration})
						end
						if self.TimeUntilMeleeAttackDamage == false then
							self:MeleeAttackCode_DoFinishTimers()
						else
							timer.Create( "timer_melee_start"..self:EntIndex(), self.TimeUntilMeleeAttackDamage, self.MeleeAttackReps, function() self:MeleeAttackCode() end)
							for tk, tv in ipairs(self.MeleeAttackExtraTimers) do
								self:DoAddExtraAttackTimers("timer_melee_start_"..math.Round(CurTime())+math.random(1,99999999),tv,1,"MeleeAttack")
							end
						end
						self:CustomOnMeleeAttack_AfterStartTimer()
					end
				end
			end
		else
			self.DoingWeaponAttack = false
			self.DoingWeaponAttack_Standing = false
			if CurTime() > self.NextWeaponAttackAimPoseParametersReset && self.DidWeaponAttackAimParameter == true && self.DoingWeaponAttack == false && self.VJ_IsBeingControlled == false then
				self:ClearPoseParameters()
				self.DidWeaponAttackAimParameter = false
			end
			
			if self:GetArrivalActivity() == self.CurrentWeaponAnimation then
				self:SetArrivalActivity(self.CurrentAnim_IdleStand)
			end
			
			if self.DoneLastHiddenZone_CanWander == false then
				self.DoneLastHiddenZone_CanWander = true
				if CurTime() > self.LastHiddenZoneT then
					self.LastHiddenZone_CanWander = true
				else
					self.LastHiddenZone_CanWander = false
				end
			end
			
			self.TimeSinceSeenEnemy = 0
			self.TimeSinceLastSeenEnemy = self.TimeSinceLastSeenEnemy + 0.1
			if self.ResetedEnemy == false && (!self.IsVJBaseSNPC_Tank) then self:LostEnemySoundCode() self.ResetedEnemy = true self:ResetEnemy(true) end
			/*if CurTime() > self.NextFindEnemyT then
			if self.DisableFindEnemy == false then self:FindEnemy() end
			self.NextFindEnemyT = CurTime() + self.NextFindEnemyTime end*/
			//self.MeleeAttacking = false
		end
	else
		//self:SelectSchedule()
		self.DoingWeaponAttack = false
	end
	self:NextThink(CurTime()+(0.069696968793869+FrameTime()))
	return true
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CanDoCertainAttack(AttackName)
	AttackName = AttackName or "MeleeAttack"
	-- Attack Names: "MeleeAttack"
	if self.NextDoAnyAttackT > CurTime() or self.FollowPlayer_GoingAfter == true or self.vACT_StopAttacks == true or self.Flinching == true or self.Behavior == VJ_BEHAVIOR_PASSIVE or self.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE or self.IsReloadingWeapon == true /*or self.VJ_IsBeingControlled == true*/ then return false end

	if AttackName == "MeleeAttack" then
		if self.IsAbleToMeleeAttack == true && self.MeleeAttacking == false /*&& self.VJ_PlayingSequence == false*/ then
		// if self.VJ_IsBeingControlled == true then if self.VJ_TheController:KeyDown(IN_ATTACK) then return true else return false end end
			return true
		end
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MeleeAttackCode()
	if self.Dead == true or self.vACT_StopAttacks == true or self.Flinching == true or self.ThrowingGrenade == true then return end
	if self.StopMeleeAttackAfterFirstHit == true && self.AlreadyDoneMeleeAttackFirstHit == true then return end
	if /*self.VJ_IsBeingControlled == false &&*/ self.MeleeAttackAnimationFaceEnemy == true then self:FaceCertainEntity(self:GetEnemy(),true) end
	//self.MeleeAttacking = true
	local FindEnts = ents.FindInSphere(self:SetMeleeAttackDamagePosition(),self.MeleeAttackDamageDistance)
	local hitentity = false
	local HasHitNonPropEnt = false
	if FindEnts != nil then
		for _,v in pairs(FindEnts) do
			if (self.VJ_IsBeingControlled == true && self.VJ_TheControllerBullseye == v) or (v:IsPlayer() && v.IsControlingNPC == true) then continue end
			if (v:IsNPC() or (v:IsPlayer() && v:Alive() && GetConVarNumber("ai_ignoreplayers") == 0)) && (self:Disposition(v) != D_LI) && (v != self) && (v:GetClass() != self:GetClass()) or (v:GetClass() == "prop_physics") or v:GetClass() == "func_breakable_surf" or v:GetClass() == "func_breakable" then
				if (self:GetForward():Dot((v:GetPos() -self:GetPos()):GetNormalized()) > math.cos(math.rad(self.MeleeAttackDamageAngleRadius))) then
					local doactualdmg = DamageInfo()
					doactualdmg:SetDamage(self:VJ_GetDifficultyValue(self.MeleeAttackDamage))
					if v:IsNPC() or v:IsPlayer() then doactualdmg:SetDamageForce(self:GetForward()*((doactualdmg:GetDamage()+100)*70)) end
					doactualdmg:SetInflictor(self)
					doactualdmg:SetAttacker(self)
					v:TakeDamageInfo(doactualdmg, self)
				if v:IsPlayer() then
					v:ViewPunch(Angle(math.random(-1,1)*10,math.random(-1,1)*10,math.random(-1,1)*10))
				end
				VJ_DestroyCombineTurret(self,v)
				if v:GetClass() != "prop_physics" then HasHitNonPropEnt = true end
				if v:GetClass() == "prop_physics" && HasHitNonPropEnt == false then
					//if VJ_HasValue(self.EntitiesToDestoryModel,v:GetModel()) or VJ_HasValue(self.EntitiesToPushModel,v:GetModel()) then
					//hitentity = true else hitentity = false end
					hitentity = false
				else
					hitentity = true
					end
				end
			end
		end
	end
	if hitentity == true then
		self:MeleeAttackSoundCode()
		if self.StopMeleeAttackAfterFirstHit == true then self.AlreadyDoneMeleeAttackFirstHit = true /*self:StopMoving()*/ end
	else
		self:CustomOnMeleeAttack_Miss()
		self:MeleeAttackMissSoundCode()
	end
	if self.AlreadyDoneFirstMeleeAttack == false && self.TimeUntilMeleeAttackDamage != false then
		self:MeleeAttackCode_DoFinishTimers()
	end
	self.AlreadyDoneFirstMeleeAttack = true
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoAddExtraAttackTimers(vName,vTime,vReps,vFunction)
	vName = vName or "timer_unknown"
	vTime = vTime or 0.5
	vReps = vReps or 1
	vFunction = vFunction or print("VJ Base: No Attack Timer Function! "..self:GetName())
	local function DoAttack()
		if vFunction == "MeleeAttack" then self:MeleeAttackCode() end
	end
	
	self.AttackTimers[#self.AttackTimers+1] = vName
	timer.Create(vName..self:EntIndex(), vTime, vReps, function() DoAttack() end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MeleeAttackCode_DoFinishTimers()
	timer.Create("timer_melee_finished"..self:EntIndex(), self:DecideAttackTimer(self.NextAnyAttackTime_Melee,self.NextAnyAttackTime_Melee_DoRand,self.TimeUntilMeleeAttackDamage,self.CurrentAttackAnimationDuration), 1, function()
		self:StopAttacks()
		self:DoChaseAnimation()
	end)
	timer.Create("timer_melee_finished_abletomelee"..self:EntIndex(), self:DecideAttackTimer(self.NextMeleeAttackTime,self.NextMeleeAttackTime_DoRand), 1, function()
		self.IsAbleToMeleeAttack = true
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StopAttacks(CheckTimers)
	if self:Health() <= 0 then return end
	if self.VJDEBUG_SNPC_ENABLED == true then if GetConVarNumber("vj_npc_printstoppedattacks") == 1 then print(self:GetClass().." Stopped all Attacks!") end end
	if CheckTimers == true then
		if self.MeleeAttacking == true && self.AlreadyDoneFirstMeleeAttack == false then self:MeleeAttackCode_DoFinishTimers() end
	end
	self.MeleeAttacking = false
	self.AlreadyDoneMeleeAttackFirstHit = false
	self.AlreadyDoneFirstMeleeAttack = false
	self:DoChaseAnimation()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ThrowGrenadeCode(CustomEnt,NoOwner)
	if self.Dead == true or self.Flinching == true or self.MeleeAttacking == true /*or (IsValid(self:GetEnemy()) && !self:Visible(self:GetEnemy()))*/ then return end
	//if self:VJ_ForwardIsHidingZone(self:NearestPoint(self:GetPos() +self:OBBCenter()),self:GetEnemy():EyePos()) == true then return end
	local NoOwner = NoOwner or false
	local getIsCustom = false
	local gerModel = self.GrenadeAttackModel
	local gerClass = self.GrenadeAttackEntity
	local gerFussTime = self.GrenadeAttackFussTime
	
	if IsValid(self:GetEnemy()) && !self:Visible(self:GetEnemy()) then
		if self:VisibleVec(self.LatestVisibleEnemyPosition) && self:GetEnemy():GetPos():Distance(self.LatestVisibleEnemyPosition) <= 600 then
			self:FaceCertainPosition(self.LatestVisibleEnemyPosition)
		else
			return
		end
	end
	
	local getSpawnPos = self.GrenadeAttackAttachment
	local getSpawnAngle;
	if getSpawnPos == false then
		getSpawnPos = self:GetPos() + self.GrenadeAttackSpawnPosition
		getSpawnAngle = getSpawnPos:Angle()
	else
		getSpawnPos = self:GetAttachment(self:LookupAttachment(self.GrenadeAttackAttachment)).Pos
		getSpawnAngle = self:GetAttachment(self:LookupAttachment(self.GrenadeAttackAttachment)).Ang
	end
	
	if IsValid(CustomEnt) then -- Custom nernagner gamal nernagner vor yete bidi nede
		getIsCustom = true
		gerModel = CustomEnt:GetModel()
		gerClass = CustomEnt:GetClass()
		CustomEnt:SetMoveType(MOVETYPE_NONE)
		CustomEnt:SetParent(self)
		if self.GrenadeAttackAttachment == false then
			CustomEnt:SetPos(getSpawnPos)
		else
			CustomEnt:Fire("SetParentAttachment",self.GrenadeAttackAttachment)
		end
		CustomEnt:SetAngles(getSpawnAngle)
		if gerClass == "obj_vj_grenade" then
			gerFussTime = math.abs(CustomEnt.FussTime - CustomEnt.TimeSinceSpawn)
		elseif gerClass == "obj_handgrenade" or gerClass == "obj_spore" then
			gerFussTime = 1
		elseif gerClass == "npc_grenade_frag" or gerClass == "doom3_grenade" or gerClass == "fas2_thrown_m67" or gerClass == "cw_grenade_thrown" or gerClass == "cw_flash_thrown" or gerClass == "cw_smoke_thrown" then
			gerFussTime = 1.5
		elseif gerClass == "obj_cpt_grenade" then
			gerFussTime = 2
		end
	end

	self.ThrowingGrenade = true
	self:CustomOnGrenadeAttack_BeforeThrowTime()
	self:GrenadeAttackSoundCode()

	if self.DisableGrenadeAttackAnimation == false then
		self.CurrentAttackAnimation = VJ_PICK(self.AnimTbl_GrenadeAttack)
		self.PlayingAttackAnimation = true
		timer.Simple(VJ_GetSequenceDuration(self,self.CurrentAttackAnimation) - 0.2,function()
			if IsValid(self) then
				self.PlayingAttackAnimation = false
			end
		end)
		self:VJ_ACT_PLAYACTIVITY(self.CurrentAttackAnimation,self.GrenadeAttackAnimationStopAttacks,self:DecideAnimationLength(self.CurrentAttackAnimation,self.GrenadeAttackAnimationStopAttacksTime),false,self.GrenadeAttackAnimationDelay)
	end

	timer.Simple(self.TimeUntilGrenadeIsReleased,function()
		if getIsCustom == true && !IsValid(CustomEnt) then return end
		if IsValid(CustomEnt) then CustomEnt.VJHumanTossingAway = false CustomEnt:Remove() end
		if IsValid(self) && self.Dead == false /*&& IsValid(self:GetEnemy())*/ then -- Yete SNPC ter artoon e...
			local gerThrowPos = self:GetPos() + self:GetForward()*200
			if IsValid(self:GetEnemy()) then
				if !self:Visible(self:GetEnemy()) && self:VisibleVec(self.LatestVisibleEnemyPosition) && self:GetEnemy():GetPos():Distance(self.LatestVisibleEnemyPosition) <= 600 then
					gerThrowPos = self.LatestVisibleEnemyPosition
					self:FaceCertainPosition(gerThrowPos)
				else
					gerThrowPos = self:GetEnemy():GetPos()
				end
			else -- Yete teshnami chooni, nede amenan lav goghme
				local iamarmo = self:VJ_CheckAllFourSides()
				if iamarmo.Forward then gerThrowPos = self:GetPos() + self:GetForward()*200; self:FaceCertainPosition(gerThrowPos)
					elseif iamarmo.Right then gerThrowPos = self:GetPos() + self:GetRight()*200; self:FaceCertainPosition(gerThrowPos)
					elseif iamarmo.Left then gerThrowPos = self:GetPos() + self:GetRight()*-200; self:FaceCertainPosition(gerThrowPos)
					elseif iamarmo.Backward then gerThrowPos = self:GetPos() + self:GetForward()*-200; self:FaceCertainPosition(gerThrowPos)
				end
			end
			local gent = ents.Create(gerClass)
			local getThrowVel = (gerThrowPos - getSpawnPos) + (self:GetUp()*math.random(self.GrenadeAttackVelUp1,self.GrenadeAttackVelUp2) + self:GetForward()*math.Rand(self.GrenadeAttackVelForward1,self.GrenadeAttackVelForward2) + self:GetRight()*math.Rand(self.GrenadeAttackVelRight1,self.GrenadeAttackVelRight2))
			if NoOwner == false then gent:SetOwner(self) end
			gent:SetPos(getSpawnPos)
			gent:SetAngles(getSpawnAngle)
			gent:SetModel(Model(gerModel))
			-- Set the timers for all the different grenade entities
				if gerClass == "obj_vj_grenade" then
					gent.FussTime = gerFussTime
				elseif gerClass == "obj_cpt_grenade" then
					gent:SetTimer(gerFussTime)
				elseif gerClass == "obj_spore" then
					gent:SetGrenade(true)
				elseif gerClass == "ent_hl1_grenade" then
					gent:ShootTimed(CustomEnt, getThrowVel, gerFussTime)
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
			if (phys:IsValid()) then
				phys:Wake()
				phys:AddAngleVelocity(Vector(math.Rand(500,500),math.Rand(500,500),math.Rand(500,500)))
				phys:SetVelocity(getThrowVel)
			end
			self:CustomOnGrenadeAttack_OnThrow(gent)
		end
		self.ThrowingGrenade = false
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:WeaponAimPoseParameters(ResetPoses)
	if (self.HasPoseParameterLooking == false) or (self.VJ_IsBeingControlled == false && self.DoingWeaponAttack == false) then return end
	ResetPoses = ResetPoses or false
	//self:VJ_GetAllPoseParameters(true)
	local ent = NULL
	if self.VJ_IsBeingControlled == true then ent = self.VJ_TheController else ent = self:GetEnemy() end
	local p_enemy = 0 -- Pitch
	local y_enemy = 0 -- Yaw
	local r_enemy = 0 -- Roll
	local ang_dif = math.AngleDifference
	local ang_app = math.ApproachAngle
	if IsValid(ent) && ResetPoses == false then
		local self_pos = self:GetPos() + self:OBBCenter()
		local enemy_pos = false //Vector(0,0,0)
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
		local enemy_ang = (enemy_pos - self_pos):Angle()
		p_enemy = ang_dif(enemy_ang.p,self_ang.p)
		if self.PoseParameterLooking_InvertPitch == true then p_enemy = -p_enemy end
		y_enemy = ang_dif(enemy_ang.y,self_ang.y)
		if self.PoseParameterLooking_InvertYaw == true then y_enemy = -y_enemy end
		r_enemy = ang_dif(enemy_ang.z,self_ang.z)
		if self.PoseParameterLooking_InvertRoll == true then r_enemy = -r_enemy end
	elseif self.PoseParameterLooking_CanReset == false then
		return
	end
	
	local names = self.PoseParameterLooking_Names
	for x=1, #names.pitch do
		self:SetPoseParameter(names.pitch[x],ang_app(self:GetPoseParameter(names.pitch[x]),p_enemy,self.PoseParameterLooking_TurningSpeed))
	end
	for x=1, #names.yaw do
		self:SetPoseParameter(names.yaw[x],ang_app(self:GetPoseParameter(names.yaw[x]),y_enemy,self.PoseParameterLooking_TurningSpeed))
	end
	for x=1, #names.roll do
		self:SetPoseParameter(names.roll[x],ang_app(self:GetPoseParameter(names.roll[x]),r_enemy,self.PoseParameterLooking_TurningSpeed))
	end
	
	self:SetPoseParameter("aim_pitch",ang_app(self:GetPoseParameter("aim_pitch"),p_enemy,self.PoseParameterLooking_TurningSpeed))
	self:SetPoseParameter("head_pitch",ang_app(self:GetPoseParameter("head_pitch"),p_enemy,self.PoseParameterLooking_TurningSpeed))
	self:SetPoseParameter("aim_yaw",ang_app(self:GetPoseParameter("aim_yaw"),y_enemy,self.PoseParameterLooking_TurningSpeed))
	self:SetPoseParameter("head_yaw",ang_app(self:GetPoseParameter("head_yaw"),y_enemy,self.PoseParameterLooking_TurningSpeed))
	self:SetPoseParameter("aim_roll",ang_app(self:GetPoseParameter("aim_roll"),r_enemy,self.PoseParameterLooking_TurningSpeed))
	self:SetPoseParameter("head_roll",ang_app(self:GetPoseParameter("head_roll"),r_enemy,self.PoseParameterLooking_TurningSpeed))
	self.DidWeaponAttackAimParameter = true
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoWeaponAttackMovementCode(override)
	local override = override or false -- Overrides some of the checks, only used for the internal task system!
	if self.HasShootWhileMoving == true then
		if self:Visible(self:GetEnemy()) && self:IsAbleToShootWeapon(true,false) == true && ((self:IsMoving() && ((self.CurrentSchedule != nil && self.CurrentSchedule.CanShootWhenMoving == true) or (self:VJ_GetCurrentSchedule() == 35))) or (override == true)) then
			if ((self.CurrentSchedule != nil && self.CurrentSchedule.IsMovingTask_Run == true) or self:VJ_GetCurrentSchedule() == 35) or (override == true) then
				local anim = VJ_PICK(self.AnimTbl_ShootWhileMovingRun)
				if VJ_AnimationExists(self,anim) == true or VJ_AnimationExists(self,self:VJ_TranslateWeaponActivity(anim)) then
					self.DoingWeaponAttack = true
					self.DoingWeaponAttack_Standing = false
					self:CapabilitiesAdd(bit.bor(CAP_MOVE_SHOOT))
					self:SetMovementActivity(anim)
					self:SetArrivalActivity(self.CurrentWeaponAnimation)
				end
			elseif self.CurrentSchedule != nil && self.CurrentSchedule.IsMovingTask_Walk == true then
				local anim = VJ_PICK(self.AnimTbl_ShootWhileMovingWalk)
				if VJ_AnimationExists(self,anim) == true or VJ_AnimationExists(self,self:VJ_TranslateWeaponActivity(anim)) then
					self.DoingWeaponAttack = true
					self.DoingWeaponAttack_Standing = false
					self:CapabilitiesAdd(bit.bor(CAP_MOVE_SHOOT))
					self:SetMovementActivity(anim)
					self:SetArrivalActivity(self.CurrentWeaponAnimation)
				end
			end
		end
	else
		self:CapabilitiesRemove(CAP_MOVE_SHOOT)
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CanDoWeaponAttack()
	if self:VJ_HasActiveWeapon() == false then return false end
	if self.AllowWeaponReloading == true && self.Weapon_ShotsSinceLastReload >= self.Weapon_StartingAmmoAmount then
		return false,"NoAmmo"
	end
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IsAbleToShootWeapon(CheckDistance,CheckDistanceOnly,EnemyDistance)
	CheckDistance = CheckDistance or false -- Check for distance and weapon time as well?
	CheckDistanceOnly = CheckDistanceOnly or false -- Should it only check the above statment?
	EnemyDistance = EnemyDistance or self:EyePos():Distance(self:GetEnemy():EyePos()) -- Distance used for CheckDistance
	if self:CustomOnIsAbleToShootWeapon() == false then return end
	local havedist = false
	local havechecks = false
	if self.VJ_IsBeingControlled == true then CheckDistance = false CheckDistanceOnly = false end
	if CheckDistance == true then
		if CurTime() > self.NextWeaponAttackT && EnemyDistance < self.Weapon_FiringDistanceFar && EnemyDistance > self.Weapon_FiringDistanceClose then
			havedist = true
		end
	end
	if CheckDistanceOnly == true then
		if havedist == true then
			return true
		else
			return false
		end
	end
	if self.IsReloadingWeapon == false && self:VJ_HasActiveWeapon() == true && self.MeleeAttacking == false && self.ThrowingGrenade == false && self.vACT_StopAttacks == false && self:VJ_GetNearestPointToEntityDistance(self:GetEnemy()) > self.MeleeAttackDistance then
		havechecks = true
		if CheckDistance == false then return true end
	end
	if CheckDistanceOnly == false && havedist == true && havechecks == true then return true end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SelectSchedule(iNPCState)
	if self.VJ_IsBeingControlled == true then return end
	self:CustomOnSchedule()
	if self.DisableSelectSchedule == true then return end
	/*if self:GetActiveWeapon():Clip1() == 1 then
		self:GetActiveWeapon():SetClip1(10)
		self:VJ_SetSchedule(SCHED_RELOAD)
	end*/
	-- Idle Behavior --
	if !IsValid(self:GetEnemy()) then
		//if self.PlayerFriendly == true then self:PlayerAllies() end
		//self:HLRelationshops()
		//self:FindEnemy()
		if /*self:VJ_HasActiveWeapon() == true && */self.ThrowingGrenade == false then self:DoIdleAnimation() end
		if self.Alerted == false then
			self.TakingCoverT = 0
		end
		self:IdleSoundCode()
		self.NoWeapon_UseScaredBehavior_Active = false
	else
	-- Combat Behavior --
		self.LatestEnemyDistance = self:GetEnemy():GetPos():Distance(self:GetPos())
		if (self.LatestEnemyDistance < self.SightDistance) then
			self:IdleSoundCode()
			if self:VJ_HasActiveWeapon() == false && CurTime() > self.NextChaseTime && self.NoWeapon_UseScaredBehavior == true && self.VJ_IsBeingControlled == false then
				//self.AnimTbl_IdleStand = self.AnimTbl_ScaredBehaviorStand
				self.NoWeapon_UseScaredBehavior_Active = true
				if self.FollowingPlayer == false then
					if self:Visible(self:GetEnemy()) then
						self:VJ_TASK_COVER_FROM_ENEMY("TASK_RUN_PATH",function(x) end)
					else
						self:DoIdleAnimation(2)
					end
				end
			else
				self.NoWeapon_UseScaredBehavior_Active = false
			end
			local EnemyPos = self:GetEnemy():EyePos()
			local SelfToEnemyDistance = self:EyePos():Distance(EnemyPos)
			local dontshoot = false
			if self.HasRunFromEnemy == true && self.LatestEnemyDistance <= self.RunFromEnemy_Distance && CurTime() > self.TakingCoverT && CurTime() > self.NextChaseTime && self.MeleeAttacking == false && self:VJ_HasActiveWeapon() == true && self.FollowingPlayer == false && self.ThrowingGrenade == false && self.VJ_PlayingSequence == false && self:VJ_ForwardIsHidingZone(self:NearestPoint(self:GetPos()+self:OBBCenter()),self:GetEnemy():EyePos()) == false then
				local checkdist = self:VJ_CheckAllFourSides(200)
				local randmove = {}
				if checkdist.Backward == true then randmove[#randmove+1] = "Backward" end
				if checkdist.Right == true then randmove[#randmove+1] = "Right" end
				if checkdist.Left == true then randmove[#randmove+1] = "Left" end
				local pickmove = VJ_PICK(randmove)
				if pickmove == "Backward" then self:SetLastPosition(self:GetPos() + self:GetForward()*math.random(-200,-200)) end
				if pickmove == "Right" then self:SetLastPosition(self:GetPos() + self:GetRight()*math.random(200,200)) end
				if pickmove == "Left" then self:SetLastPosition(self:GetPos() + self:GetRight()*math.random(-200,-200)) end
				if pickmove == "Backward" or pickmove == "Right" or pickmove == "Left" then
					self.IsReloadingWeapon = false
					self.TakingCoverT = CurTime() + 2
					dontshoot = true
					self:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH",function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true end)
				end
			end
			/*if SelfToEnemyDistance < 300 && SelfToEnemyDistance > 151 then
			if self:VJ_HasActiveWeapon() == true && self.FollowPlayer_GoingAfter == false && self.FollowingPlayer == false && self.ThrowingGrenade == false && self.VJ_PlayingSequence == false then
			self:SetLastPosition(self:GetPos() + self:GetForward()*math.random(-200,-200))
			self:VJ_SetSchedule(SCHED_FORCED_GO) end end*/
			//if self.IsReloadingWeapon == false && self:VJ_HasActiveWeapon() == true && self.MeleeAttacking == false && self.FollowPlayer_GoingAfter == false && self.ThrowingGrenade == false && self.vACT_StopAttacks == false && self:VJ_GetNearestPointToEntityDistance(self:GetEnemy()) > self.MeleeAttackDistance then
			if dontshoot == false && self:IsAbleToShootWeapon(false,false,SelfToEnemyDistance) == true then
				if SelfToEnemyDistance > self.Weapon_FiringDistanceFar or CurTime() < self.NextWeaponAttackT then
					self:DoChaseAnimation()
					self.AllowToDo_WaitForEnemyToComeOut = false
				//elseif SelfToEnemyDistance < self.Weapon_FiringDistanceFar && SelfToEnemyDistance > self.Weapon_FiringDistanceClose then -- If shoot distance is bigger than the enemy position and if the enemy position is bigger than the shoot distance close
				elseif self:IsAbleToShootWeapon(true,true,SelfToEnemyDistance) == true then
					if self.DoingWeaponAttack_Standing == true && CurTime() > self.TakingCoverT then -- Move if ally in line of fire, then move
						local hitent = false
						tr = util.TraceLine({
							start = self:NearestPoint(self:GetPos() +self:OBBCenter()),
							endpos = self:GetEnemy():EyePos(),
							filter = self
						})
						for k,v in ipairs(ents.FindInSphere(tr.HitPos,5)) do
							if v:IsNPC() && v != self && (self:Disposition(v) == D_LI or self:Disposition(v) == D_NU) then
								hitent = true
							end
						end
						-- Move when way blocked
						if hitent == true && tr.HitPos:Distance(tr.StartPos) <= 3000 then
							local checkdist = self:VJ_CheckAllFourSides(40)
							local randmove = {}
							if checkdist.Right == true then randmove[#randmove+1] = "Right" end
							if checkdist.Left == true then randmove[#randmove+1] = "Left" end
							local pickmove = VJ_PICK(randmove)
							if pickmove == "Right" then self:SetLastPosition(self:GetPos() + self:GetRight()*math.random(30,40)) end
							if pickmove == "Left" then self:SetLastPosition(self:GetPos() + self:GetRight()*math.random(-40,-30)) end
							if pickmove == "Right" or pickmove == "Left" then
								self:StopMoving()
								self.NextChaseTime = CurTime() + 1
								self:VJ_TASK_GOTO_LASTPOS("TASK_WALK_PATH",function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true end)
							end
						end
					end
					// (self:VJ_ForwardIsHidingZone(self:NearestPoint(self:GetPos() +self:OBBCenter()) +self:GetUp()*30,self:GetEnemy():EyePos() +self:GetUp()*30,true,{SpawnTestCube=true})
					if (self:VJ_ForwardIsHidingZone(self:EyePos(),self:GetEnemy():EyePos(),true) == true) && self:VJ_ForwardIsHidingZone(self:NearestPoint(self:GetPos() +self:OBBCenter()) +self:GetUp()*30,self:GetEnemy():EyePos() +self:GetUp()*30,true) /*or self:VJ_ForwardIsHidingZone(util.VJ_GetWeaponPos(self),self:GetEnemy():EyePos()) == true*/ /*or (!self:Visible(self:GetEnemy()))*/ then -- Chase enemy or wait for enemy if hiding
						//if self:VJ_IsCurrentSchedule(self.WeaponAttackSchedule) != true then
						if self.WaitForEnemyToComeOut == true && self.AllowToDo_WaitForEnemyToComeOut == true && self.IsReloadingWeapon == false && self.Weapon_TimeSinceLastShot <= 5 && self.WaitingForEnemyToComeOut == false && (SelfToEnemyDistance < self.Weapon_FiringDistanceFar) && (SelfToEnemyDistance > self.WaitForEnemyToComeOutDistance) && self:VJ_IsCurrentSchedule(self.WeaponAttackSchedule) != true then
							self.WaitingForEnemyToComeOut = true
							if self.HasLostWeaponSightAnimation == true then
								self:VJ_ACT_PLAYACTIVITY(self.AnimTbl_LostWeaponSight,false,0,true)
							end
							self.NextChaseTime = CurTime() + math.Rand(self.WaitForEnemyToComeOutTime.a, self.WaitForEnemyToComeOutTime.b)
						elseif self.DisableChasingEnemy == false && self.IsReloadingWeapon == false && CurTime() > self.LastHiddenZoneT then
							self.DoingWeaponAttack = false
							self.DoingWeaponAttack_Standing = false
							self:DoChaseAnimation()
						end
					else
						self.AllowToDo_WaitForEnemyToComeOut = true
						// CurTime() > self.TakingCoverT
						//if self:Visible(self:GetEnemy()) /*&& (self:GetForward():Dot((self:GetEnemy():GetPos() -self:GetPos()):GetNormalized()) > math.cos(math.rad(self.SightAngle)))*/ then
						if (self:GetActiveWeapon().IsVJBaseWeapon) then -- VJ Base weapons
							self:FaceCertainEntity(self:GetEnemy(),true)
							local dontattack = false
							// self:DoChaseAnimation()
							-- if covered, try to move forward by calculating the distance between the prop and the snpc
							local iscovered, covertr = self:VJ_ForwardIsHidingZone(self:NearestPoint(self:GetPos() +self:OBBCenter()),self:GetEnemy():EyePos(),false,{SetLastHiddenTime=true})
							local guncovered, guncovertr = self:VJ_ForwardIsHidingZone(self:GetActiveWeapon():GetNWVector("VJ_CurBulletPos"),self:GetEnemy():EyePos(),false)
							//print("Is covered? ",iscovered)
							//print("Is gun covered? ",guncovered)
							if iscovered == true then
								if CurTime() < self.TakingCoverT then dontattack = true end
								self.WeaponUseEnemyEyePos = true
								if dontattack == false && guncovered == true && !guncovertr.Entity:IsNPC() && !guncovertr.Entity:IsPlayer() && self.TimeSinceSeenEnemy > 0.5 && CurTime() > self.NextMoveOnGunCoveredT then
									self.WeaponUseEnemyEyePos = true
									local calc;
									local mypos;
									if IsValid(covertr.Entity) then
										calc = self:VJ_GetNearestPointToEntity(covertr.Entity,true)
										mypos = calc.MyPosition
										enepos = calc.EnemyPosition - self:GetForward()*15
									else
										calc = self:VJ_GetNearestPointToVector(tr.HitPos,true)
										mypos = calc.MyPosition
										enepos = calc.PointPosition - self:GetForward()*15
									end
									if mypos:Distance(enepos) <= 1000 then
										//enepos = enepos - self:GetForward()*5
										self:SetLastPosition(enepos)
										//VJ_CreateTestObject(enepos,self:GetAngles(),Color(0,255,255))
										local vsched = ai_vj_schedule.New("vj_goto_cover")
										vsched:EngTask("TASK_GET_PATH_TO_LASTPOSITION", 0)
										vsched:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
										vsched.IsMovingTask = true
										vsched.ConstantlyFaceEnemy = true
										local coveranim = VJ_PICK(self.AnimTbl_MoveToCover)
										if VJ_AnimationExists(self,self:VJ_TranslateWeaponActivity(coveranim)) == true then
											self:SetMovementActivity(ACT_RUN_CROUCH)
										else
											vsched.CanShootWhenMoving = true
											vsched.IsMovingTask_Run = true
										end
										self:StartSchedule(vsched)
										//self:VJ_TASK_GOTO_LASTPOS("TASK_WALK_PATH",function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true end)
									end
									self.NextMoveOnGunCoveredT = CurTime() + 2
								end
							end
							if dontattack == false && CurTime() > self.NextWeaponAttackT /*&& self.DoingWeaponAttack == false*/ then
								local currentattackanim_translate = VJ_IsCurrentAnimation(self,self:VJ_TranslateWeaponActivity(self.CurrentWeaponAnimation))
								local currentattackanim_reg = VJ_IsCurrentAnimation(self,self.AnimTbl_WeaponAttack)
								local currentattackanim_crouch = VJ_IsCurrentAnimation(self,self.AnimTbl_WeaponAttackCrouch)
								if currentattackanim_translate == true or currentattackanim_reg == true or currentattackanim_crouch == true then self.DoingWeaponAttack = true self.DoingWeaponAttack_Standing = true end
								if self:GetActivity() != self.CurrentWeaponAnimation && self:GetActivity() != ACT_TRANSITION && (currentattackanim_translate == false && currentattackanim_reg == false && currentattackanim_crouch == false) then
									self.WaitingForEnemyToComeOut = false
									timer.Simple(0.3,function() if IsValid(self) then self.DoingWeaponAttack = true self.DoingWeaponAttack_Standing = true end end)
									//self:StopMoving()
									self:CustomOnWeaponAttack()
									self.Weapon_TimeSinceLastShot = 0
									//self.NextMoveRandomlyWhenShootingT = CurTime() + 2
									if self.CanCrouchOnWeaponAttack == true && guncovered == false && self:VJ_ForwardIsHidingZone(self:GetActiveWeapon():GetNWVector("VJ_CurBulletPos")+self:GetUp()*-18,self:GetEnemy():EyePos(),false) == false then
										local curanim;
										local crouchanim = VJ_PICK(self.AnimTbl_WeaponAttackCrouch)
										local crouchchance = math.random(1,self.CanCrouchOnWeaponAttackChance)
										if ((crouchchance == 1) or (CurTime() <= self.Weapon_DoingCrouchAttackT)) && VJ_AnimationExists(self,self:VJ_TranslateWeaponActivity(crouchanim)) == true && iscovered == false && SelfToEnemyDistance > 500 then
											curanim = crouchanim
											//local actualanim = curanim
											if type(curanim) != "string" then curanim = self:VJ_TranslateWeaponActivity(curanim) end
											if VJ_AnimationExists(self,curanim) == false then curanim = self.CurrentWeaponAnimation end
											self.CurrentWeaponAnimation = curanim
											self.Weapon_DoingCrouchAttackT = CurTime() + 2 -- Asiga bedke vor vestah elank yed votgi cheler hemen
											if VJ_IsCurrentAnimation(self,curanim) == false then self:VJ_ACT_PLAYACTIVITY(curanim,false,0,true) end
										else
											curanim = VJ_PICK(self.AnimTbl_WeaponAttack)
											//local actualanim = curanim
											self.CurrentWeaponAnimation = curanim
											if type(curanim) != "string" then curanim = self:VJ_TranslateWeaponActivity(curanim) end
											if VJ_AnimationExists(self,curanim) == false then curanim = self.CurrentWeaponAnimation end
											if VJ_IsCurrentAnimation(self,curanim) == false then self:VJ_ACT_PLAYACTIVITY(curanim,false,0,true) end
										end
									else
										curanim = VJ_PICK(self.AnimTbl_WeaponAttack)
										//local actualanim = curanim
										self.CurrentWeaponAnimation = curanim
										if type(curanim) != "string" then curanim = self:VJ_TranslateWeaponActivity(curanim) end
										if VJ_AnimationExists(self,curanim) == false then curanim = self.CurrentWeaponAnimation end
										if VJ_IsCurrentAnimation(self,curanim) == false then self:VJ_ACT_PLAYACTIVITY(curanim,false,0,true) end
									end
								end
							end
							-- Move randomly when shooting
							if self.FollowingPlayer == false && self.MoveRandomlyWhenShooting == true && self.DoingWeaponAttack == true && self.DoingWeaponAttack_Standing == true && CurTime() > self.NextMoveRandomlyWhenShootingT && self.TimeSinceSeenEnemy > 2 && (SelfToEnemyDistance < (self.Weapon_FiringDistanceFar /1.25)) then
								if self:VJ_ForwardIsHidingZone(self:NearestPoint(self:GetPos() +self:OBBCenter()),self:GetEnemy():EyePos()) == false then
									//self:SetMovementActivity(ACT_RUN_AIM)
									if self:CustomOnMoveRandomlyWhenShooting() != false then
										local randpos = math.random(150,400)
										local checkdist = self:VJ_CheckAllFourSides(randpos)
										local randmove = {}
										if checkdist.Backward == true then randmove[#randmove+1] = "Backward" end
										if checkdist.Right == true then randmove[#randmove+1] = "Right" end
										if checkdist.Left == true then randmove[#randmove+1] = "Left"end
										local pickmove = VJ_PICK(randmove)
										if pickmove == "Backward" then self:SetLastPosition(self:GetPos() + self:GetForward()*-randpos) end
										if pickmove == "Right" then self:SetLastPosition(self:GetPos() + self:GetRight()*randpos) end
										if pickmove == "Left" then self:SetLastPosition(self:GetPos() + self:GetRight()*-randpos) end
										if pickmove == "Backward" or pickmove == "Right" or pickmove == "Left" then
											self:StopMoving()
											self:VJ_TASK_GOTO_LASTPOS(VJ_PICK({"TASK_RUN_PATH","TASK_WALK_PATH"}),function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true end)
										end
										self.NextMoveRandomlyWhenShootingT = CurTime() + math.Rand(self.NextMoveRandomlyWhenShootingTime1,self.NextMoveRandomlyWhenShootingTime2)
									end
								end
							end
						else -- None VJ Base weapons
							self:FaceCertainEntity(self:GetEnemy(),true)
							self.WaitingForEnemyToComeOut = false
							timer.Simple(0.3,function() if IsValid(self) then self.DoingWeaponAttack = true self.DoingWeaponAttack_Standing = true end end)
							self:CustomOnWeaponAttack()
							self.Weapon_TimeSinceLastShot = 0
							self.Weapon_ShotsSinceLastReload = 0
							self:GetActiveWeapon():SetClip1(99999)
							self:VJ_SetSchedule(VJ_PICK(self.WeaponAttackSchedule))
						end
						//end
						//else self.DoingWeaponAttack = false end
					end
					-- Wait for enemy to come out
					/*if !self:Visible(self:GetEnemy()) then
						if self.IsReloadingWeapon == false && self.AllowToDo_WaitForEnemyToComeOut == true && self.Weapon_TimeSinceLastShot <= 5 && self.WaitingForEnemyToComeOut == false && (SelfToEnemyDistance < (self.Weapon_FiringDistanceFar)) && SelfToEnemyDistance > self.WaitForEnemyToComeOutDistance && self:VJ_IsCurrentSchedule(self.WeaponAttackSchedule) != true then
							if self.WaitForEnemyToComeOut == true then
								self:StopMoving()
								self.DoingWeaponAttack_Standing = false
								self.NextChaseTime = CurTime() + math.Rand(self.WaitForEnemyToComeOutTime.a, self.WaitForEnemyToComeOutTime.b)
								self:CustomOnWaitForEnemyToComeOut()
								local myanim = VJ_PICK(self.AnimTbl_CustomWaitForEnemyToComeOut)
								if myanim == true then // !VJ_IsCurrentAnimation(self,self.CurrentWeaponAnimation)
									self:VJ_ACT_PLAYACTIVITY(myanim,false,2,true)
								elseif !VJ_IsCurrentAnimation(self,self.CurrentWeaponAnimation) then
									self:VJ_ACT_PLAYACTIVITY(self.CurrentWeaponAnimation,false,2,true)
								end
								//local wepanim = self.CurrentWeaponAnimation
								//local actualanim = wepanim
								//if type(wepanim) != "string" then wepanim = self:VJ_TranslateWeaponActivity(wepanim) end
								//if VJ_IsCurrentAnimation(self,wepanim) == false then self:VJ_ACT_PLAYACTIVITY(actualanim,false,2,true) end
								//self:VJ_ACT_TAKE_COVER(self.AnimTbl_CustomWaitForEnemyToComeOut,{ACT_IDLE_ANGRY},false,2,true)
							end
							self.WaitingForEnemyToComeOut = true
						end
					end*/

					/*if self:VJ_EyeTrace() == true then
					if self.AllowWeaponReloading == true then
					if CurTime() > self.NextReloadT then
					if math.random(1,self.ReloadChance) < 3 then
					if self.FollowingPlayer == false then
					self:VJ_SetSchedule(SCHED_HIDE_AND_RELOAD) else
					self:VJ_SetSchedule(SCHED_RELOAD) end end end
					self.NextReloadT = CurTime() + self.NextReloadTime end end*/
				end
			end
		end
		if IsValid(self:GetEnemy()) && self.LatestEnemyDistance > self.SightDistance then
			self:ResetEnemy(false)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPlayerSightCode(argent)
	if self.HasOnPlayerSight == false or !argent:Alive() or (self.OnPlayerSightOnlyOnce == true && self.OnPlayerSight_AlreadySeen == true) then return end
	if (CurTime() > self.OnPlayerSightNextT) && argent:IsPlayer() && (argent:GetPos():Distance(self:GetPos()) < self.OnPlayerSightDistance) && self:Visible(argent) && (self:GetForward():Dot((argent:GetPos() -self:GetPos()):GetNormalized()) > math.cos(math.rad(self.SightAngle))) then
		if self.OnPlayerSightDispositionLevel == 1 && self:Disposition(argent) != D_LI && self:Disposition(argent) != D_NU then return end
		if self.OnPlayerSightDispositionLevel == 2 && (self:Disposition(argent) == D_LI) then return end
		self.OnPlayerSight_AlreadySeen = true
		self:CustomOnPlayerSight(argent)
		self:OnPlayerSightSoundCode()
		if self.OnPlayerSightOnlyOnce == false then self.OnPlayerSightNextT = CurTime() + math.Rand(self.OnPlayerSightNextTime1,self.OnPlayerSightNextTime2) end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DamageByPlayerCode(dmginfo,hitgroup)
	if self.HasDamageByPlayer == true && CurTime() > self.NextDamageByPlayerT && GetConVarNumber("ai_disabled") == 0 then
		local theattack = dmginfo:GetAttacker()
		if theattack:IsPlayer() && self:Visible(theattack) then
			if self.DamageByPlayerDispositionLevel == 1 && self:Disposition(theattack) != D_LI && self:Disposition(theattack) != D_NU then return end
			if self.DamageByPlayerDispositionLevel == 2 && (self:Disposition(theattack) == D_LI or self:Disposition(theattack) == D_NU) then return end
			self:CustomOnDamageByPlayer(dmginfo,hitgroup)
			self:DamageByPlayerSoundCode()
			self.NextDamageByPlayerT = CurTime() + math.Rand(self.DamageByPlayerTime.a,self.DamageByPlayerTime.b)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CheckForGrenades()
	if self.CanDetectGrenades == false or self.ThrowingGrenade == true or self.HasSeenGrenade == true or self.VJ_IsBeingControlled == true then return end
	local FindNearbyGrenades = ents.FindInSphere(self:GetPos(),self.RunFromGrenadeDistance)
	for k,v in pairs(FindNearbyGrenades) do
		local IsFriendlyGrenade = false
		if self.EntitiesToRunFrom[v:GetClass()] && self:Visible(v) then
			if IsValid(v:GetOwner()) && v:GetOwner().IsVJBaseSNPC == true && (self:Disposition(v:GetOwner()) == D_LI or self:Disposition(v:GetOwner()) == D_NU) then
				IsFriendlyGrenade = true
			end
			if IsFriendlyGrenade == false then
				self:OnGrenadeSightSoundCode()
				self.HasSeenGrenade = true
				self.TakingCoverT = CurTime() + 4
				if /*IsValid(self:GetEnemy()) &&*/v.VJHumanNoPickup != true && v.VJHumanTossingAway != true && self.CanThrowBackDetectedGrenades == true && self.HasGrenadeAttack == true && v:GetVelocity():Length() < 400 && self:VJ_GetNearestPointToEntityDistance(v) < 100 && self.EntitiesToThrowBack[v:GetClass()] then
					self.NextGrenadeAttackSoundT = CurTime() + 3
					self:ThrowGrenadeCode(v,true)
					v.VJHumanTossingAway = true
					//v:Remove()
				end
				//if self.VJ_PlayingSequence == false then self:VJ_SetSchedule(SCHED_RUN_FROM_ENEMY) end
				self:VJ_TASK_COVER_FROM_ENEMY("TASK_RUN_PATH",function(x) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true end)
				timer.Simple(4,function() if IsValid(self) then self.HasSeenGrenade = false end end)
				break;
				//else
				//self.HasSeenGrenade = false
				//return
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJFriendlyCode(argent)
	argent:AddEntityRelationship(self,D_LI,99)
	self:AddEntityRelationship(argent,D_LI,99)
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CombineFriendlyCode(argent)
	if self.NPCTbl_Combine[argent:GetClass()] then
	//if VJ_HasValue(self.NPCTbl_Combine,argent:GetClass()) then
		argent:AddEntityRelationship(self,D_LI,99)
		self:AddEntityRelationship(argent,D_LI,99)
		return true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ZombieFriendlyCode(argent)
	if self.NPCTbl_Zombies[argent:GetClass()] then
	//if VJ_HasValue(self.NPCTbl_Zombies,argent:GetClass()) then
		argent:AddEntityRelationship(self,D_LI,99)
		self:AddEntityRelationship(argent,D_LI,99)
		return true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AntlionFriendlyCode(argent)
	if self.NPCTbl_Antlions[argent:GetClass()] then
	//if VJ_HasValue(self.NPCTbl_Antlions,argent:GetClass()) then
		argent:AddEntityRelationship(self,D_LI,99)
		self:AddEntityRelationship(argent,D_LI,99)
		return true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:XenFriendlyCode(argent)
	if self.NPCTbl_Xen[argent:GetClass()] then
	//if VJ_HasValue(self.NPCTbl_Xen,argent:GetClass()) then
		argent:AddEntityRelationship(self,D_LI,99)
		self:AddEntityRelationship(argent,D_LI,99)
		return true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PlayerAllies(argent)
	if self.NPCTbl_Resistance[argent:GetClass()] then
	//if VJ_HasValue(self.NPCTbl_Resistance,argent:GetClass()) then
		argent:AddEntityRelationship(self,D_LI,99)
		self:AddEntityRelationship(argent,D_LI,99)
		return true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_ACT_RESETENEMY(RunToEnemyOnReset)
	local RunToEnemyOnReset = RunToEnemyOnReset or false
	local vsched = ai_vj_schedule.New("vj_act_resetenemy")
	if IsValid(self:GetEnemy()) then vsched:EngTask("TASK_FORGET", self:GetEnemy()) end
	//vsched:EngTask("TASK_IGNORE_OLD_ENEMIES", 0)
	self.NextWanderTime = CurTime() + math.Rand(3,5)
	if self.IsGuard == false && self.Behavior != VJ_BEHAVIOR_PASSIVE && self.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE && self.VJ_IsBeingControlled == false && RunToEnemyOnReset == true && CurTime() > self.LastHiddenZoneT && self.LastHiddenZone_CanWander == true && self.MeleeAttacking != true && self.RangeAttacking != true && self.LeapAttacking != true then
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
function ENT:ResetEnemy(NoResetAlliesSeeEnemy)
	if self.NextResetEnemyT > CurTime() or self.Dead == true then self.ResetedEnemy = false return false end
	NoResetAlliesSeeEnemy = NoResetAlliesSeeEnemy or false
	local RunToEnemyOnReset = false
	if NoResetAlliesSeeEnemy == true then
		local checkallies = self:CheckAlliesAroundMe(1000)
		if checkallies != nil then
			for k,v in ipairs(checkallies) do
				if IsValid(v:GetEnemy()) && v.LastSeenEnemyTime < self.LastSeenEnemyTimeUntilReset && VJ_IsAlive(v:GetEnemy()) == true && self:VJ_HasNoTarget(v:GetEnemy()) == false && self:GetPos():Distance(v:GetEnemy():GetPos()) <= self.SightDistance then
					self:VJ_DoSetEnemy(v:GetEnemy(),true)
					self.ResetedEnemy = false
					return false
				end
			end
		end
		local curenes = self.ReachableEnemyCount //self.CurrentReachableEnemies
		//if istable(curenes) then
			//for k,v in ipairs(curenes) do
				//if IsValid(v) && ((!IsValid(self:GetEnemy())) or (IsValid(self:GetEnemy()) && self:GetEnemy() != v)) then
				if (IsValid(self:GetEnemy()) && (curenes - 1) >= 1) or (!IsValid(self:GetEnemy()) && curenes >= 1) then
					self:VJ_DoSetEnemy(v,false,true)
					self.ResetedEnemy = false
					return false
				end
			//end
		//end
	end
	
	//print(self.LatestEnemyPosition)
	if self.VJDEBUG_SNPC_ENABLED == true then if GetConVarNumber("vj_npc_printresetenemy") == 1 then print(self:GetName().." has reseted its enemy") end end
	if IsValid(self:GetEnemy()) then
		if self.FollowingPlayer == false && self.VJ_PlayingSequence == false && (!self.IsVJBaseSNPC_Tank) && self.LatestEnemyPosition != Vector(0,0,0) then
			self:SetLastPosition(self.LatestEnemyPosition)
			RunToEnemyOnReset = true
			/*timer.Simple(0.15,function()
			if self:IsValid() then
			if self.FollowingPlayer == false && self.VJ_PlayingSequence == false && (!self.IsVJBaseSNPC_Tank) && self.LatestEnemyPosition != Vector(0,0,0) then // && self.DisableWandering == false
			self:VJ_SetSchedule(SCHED_FORCED_GO_RUN)
			self.PlayedResetEnemyRunSchedule = true
			//self:DoIdleAnimation()
			end
		  end
		 end)*/
		end
		//table.remove(self.CurrentPossibleEnemies,tonumber(self:GetEnemy()))
		//table.Empty(self.CurrentPossibleEnemies)
		self:AddEntityRelationship(self:GetEnemy(),4,10)
	end
	
	if IsValid(self.LatestEnemyClass) && self.LatestEnemyClass:IsPlayer() then self:AddEntityRelationship(self.LatestEnemyClass,4,10) end
	self.Alerted = false
	self:SetEnemy(NULL)
	self:ClearEnemyMemory()
	//self:UpdateEnemyMemory(self,self:GetPos())
	self:VJ_ACT_RESETENEMY(RunToEnemyOnReset)
	self:CustomOnResetEnemy()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoAlert(argent)
	if !IsValid(self:GetEnemy()) or self.Alerted == true then return end
	self.Alerted = true
	self.LastSeenEnemyTime = 0
	self:CustomOnAlert(argent)
	if CurTime() > self.NextAlertSoundT then
		if self.AlertSounds_OnlyOnce == true then
			if self.HasDone_PlayAlertSoundOnlyOnce == false then
				self:AlertSoundCode()
				self.HasDone_PlayAlertSoundOnlyOnce = true
			end
		else
			self:AlertSoundCode()
		end
		self.NextAlertSoundT = CurTime() + math.Rand(self.NextSoundTime_Alert1,self.NextSoundTime_Alert2)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoRelationshipCheck(argent)
	-- false = Tematsine pari e
	-- "Neutral" = Tematsine ne keshe ne pari e
	-- true == Tematsine tsnami e
	local nt_bool, nt_str = self:VJ_HasNoTarget(argent)
	if nt_str == "Bullseye" then return true end
	if nt_bool == true or self.NPCTbl_Animals[argent:GetClass()] then return "Neutral" end
	if self:GetClass() == argent:GetClass() then return false end
	if argent:Health() > 0 && self:Disposition(argent) != D_LI then
		if argent:IsPlayer() && GetConVarNumber("ai_ignoreplayers") == 1 then return "Neutral" end
		if VJ_HasValue(self.VJ_AddCertainEntityAsFriendly,argent) then return false end
		if VJ_HasValue(self.VJ_AddCertainEntityAsEnemy,argent) then return true end
		if (argent:IsNPC() && !argent.FriendlyToVJSNPCs && ((argent:Disposition(self) == D_HT) or (argent:Disposition(self) == D_NU && argent.VJ_IsBeingControlled == true))) or (argent:IsPlayer() && self.PlayerFriendly == false && argent:Alive()) then
			//if argent.VJ_NoTarget == false then
			//if (argent.VJ_NoTarget) then if argent.VJ_NoTarget == false then continue end end
			return true
		else
			return "Neutral"
		end
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoHardEntityCheck(CustomTbl)
	/*local GetNPCs = {}
	GetNPCs = ents.FindByClass("npc_*")
	GetNPCs = table.Add(GetNPCs,ents.FindByClass("monster_*"))
	if GetConVarNumber("ai_ignoreplayers") == 0 then
	GetNPCs = table.Add(GetNPCs,player.GetAll()) end
	if (!ents) then return end
	for _, x in pairs(GetNPCs) do
	if (x:GetClass() == self:GetClass() or x:GetClass() == "npc_grenade_frag" or (x.IsVJBaseSNPC_Animal)) then
		if VJ_HasValue(GetNPCs,x:GetClass()) then
		table.remove(GetNPCs,x:GetClass()) end
		end
	end
	return GetNPCs*/
	local EntsTbl = CustomTbl or ents.GetAll()
	local EntsFinal = {}
	local count = 1
	//for k, v in ipairs(CustomTbl) do //ents.FindInSphere(self:GetPos(),30000)
	for x=1, #EntsTbl do
		if !EntsTbl[x]:IsNPC() && !EntsTbl[x]:IsPlayer() then continue end
		local v = EntsTbl[x]
		self:EntitiesToNoCollideCode(v)
		if (v:IsNPC() && v:GetClass() != self:GetClass() && v:GetClass() != "npc_grenade_frag" && v:GetClass() != "bullseye_strider_focus" && v:GetClass() != "npc_bullseye" && v:GetClass() != "npc_enemyfinder" && v:GetClass() != "hornet" && (!v.IsVJBaseSNPC_Animal) && (v.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE) && v:Health() > 0) or (v:IsPlayer() && GetConVarNumber("ai_ignoreplayers") == 0 /*&& v:Alive()*/) then
			EntsFinal[count] = v
			count = count + 1
		end
	end
	//table.Merge(EntsFinal,self.CurrentPossibleEnemies)
	return EntsFinal
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoEntityRelationshipCheck()
	if self.Dead == true or self.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE /*or self.Behavior == VJ_BEHAVIOR_PASSIVE*/ then return false end
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
	local closestdist = nil
	local enemyseen = false
	local MyPos = self:GetPos()
	local sightdist = self.SightDistance
	local it = 1
	//for k, v in ipairs(posenemies) do
	while it <= #posenemies do
		local v = posenemies[it]
		if !IsValid(v) then
			table.remove(posenemies,it)
		else
			it = it + 1
			//if !IsValid(v) then table.remove(self.CurrentPossibleEnemies,tonumber(v)) continue end
			//if !IsValid(v) then continue end
			if self:VJ_HasNoTarget(v) == true then
				if IsValid(self:GetEnemy()) && self:GetEnemy() == v then
					self:ResetEnemy(false)
				end
				continue
			end
			//if v:Health() <= 0 then table.remove(self.CurrentPossibleEnemies,k) continue end
			local entisfri = false
			local vPos = v:GetPos()
			local vDistanceToMy = vPos:Distance(MyPos)
			if vDistanceToMy > sightdist then continue end
			local vClass = v:GetClass()
			local vNPC = v:IsNPC()
			local vPlayer = v:IsPlayer()
			local radiusoverride = 0
			local seethroughwall = false
			if vClass != self:GetClass() && (vNPC or vPlayer) && (!v.IsVJBaseSNPC_Animal) && (v.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE) /*&& MyVisibleTov && self:Disposition(v) != D_LI*/ then
				local inEneTbl = VJ_HasValue(self.VJ_AddCertainEntityAsEnemy,v)
				if self.HasAllies == true && inEneTbl == false then
					for _,friclass in ipairs(self.VJ_NPC_Class) do
						if friclass == "CLASS_PLAYER_ALLY" && self.PlayerFriendly == false then self.PlayerFriendly = true end
						if friclass == "CLASS_COMBINE" then if self:CombineFriendlyCode(v) == true then entisfri = true end end
						if friclass == "CLASS_ZOMBIE" then if self:ZombieFriendlyCode(v) == true then entisfri = true end end
						if friclass == "CLASS_ANTLION" then if self:AntlionFriendlyCode(v) == true then entisfri = true end end
						if friclass == "CLASS_XEN" then if self:XenFriendlyCode(v) == true then entisfri = true end end
						if (v.VJ_NPC_Class /*&& friclass != "CLASS_PLAYER_ALLY"*/ && VJ_HasValue(v.VJ_NPC_Class,friclass)) or (entisfri == true) then
							if friclass == "CLASS_PLAYER_ALLY" then
								if self.FriendsWithAllPlayerAllies == true && v.FriendsWithAllPlayerAllies == true then
									entisfri = true
									if vNPC then v:AddEntityRelationship(self,D_LI,99) end
									self:AddEntityRelationship(v,D_LI,99)
								end
							else
								entisfri = true
								if IsValid(self:GetEnemy()) && self:GetEnemy() == v then
									self.ResetedEnemy = true
									self:ResetEnemy(false)
								end
								if vNPC then v:AddEntityRelationship(self,D_LI,99) end
								self:AddEntityRelationship(v,D_LI,99)
							end
						end
					end
					if vNPC then
						/*for _,fritbl in ipairs(self.VJ_FriendlyNPCsGroup) do
							//for k,v in ipairs(ents.FindByClass(fritbl)) do
							if string.find(vClass, fritbl) then
								entisfri = true
								v:AddEntityRelationship(self,D_LI,99)
								self:AddEntityRelationship(v,D_LI,99)
							end
						end
						if VJ_HasValue(self.VJ_FriendlyNPCsSingle,vClass) then
							entisfri = true
							v:AddEntityRelationship(self,D_LI,99)
							self:AddEntityRelationship(v,D_LI,99)
						end*/
						if self.PlayerFriendly == true then
							if self:PlayerAllies(v) == true then entisfri = true end
							if self.FriendsWithAllPlayerAllies == true && v.PlayerFriendly == true && v.FriendsWithAllPlayerAllies == true then
								entisfri = true
								v:AddEntityRelationship(self,D_LI,99)
								self:AddEntityRelationship(v,D_LI,99)
							end
						end
						if v.IsVJBaseSNPC == true && self.VJFriendly == true then if self:VJFriendlyCode(v) == true then entisfri = true end end
					end
				end
				if entisfri == false && vNPC /*&& MyVisibleTov*/ && self.DisableMakingSelfEnemyToNPCs == false && (v.VJ_IsBeingControlled != true) then v:AddEntityRelationship(self,D_HT,99) end
				if vPlayer then
					if (self.PlayerFriendly == true or entisfri == true/* or self:Disposition(v) == D_LI*/) then
						if inEneTbl == false then
							entisfri = true
							self:AddEntityRelationship(v,D_LI,99)
							//DoPlayerSight()
						else
							entisfri = false
						end
					end
					if (!self.IsVJBaseSNPC_Tank) && !IsValid(self:GetEnemy()) && entisfri == false then
						if entisfri == false then self:AddEntityRelationship(v,D_NU,99) end
						if v:Crouching() && v:GetMoveType() != MOVETYPE_NOCLIP then if self.VJ_IsHugeMonster == true then sightdist = 5000 else sightdist = 2000 end end
						if vDistanceToMy < (self.InvestigateSoundDistance * v.VJ_LastInvestigateSdLevel) && ((CurTime() - v.VJ_LastInvestigateSd) <= 1) then
							if self.NextInvestigateSoundMove < CurTime() then
								if self:Visible(v) then
									self:StopMoving()
									self:SetTarget(v)
									self:VJ_TASK_FACE_X("TASK_FACE_TARGET")
								elseif self.FollowingPlayer == false then
									self:SetLastPosition(v:GetPos())
									self:VJ_TASK_GOTO_LASTPOS("TASK_WALK_PATH")
								end
								self:CustomOnInvestigate(v)
								self:InvestigateSoundCode()
								self.NextInvestigateSoundMove = CurTime() + 2
							end
						elseif vDistanceToMy < 350 && ((self:VJ_DoPlayerFlashLightCheck(v,20) == true)) then
							//			   Asiga hoser ^ (!v:Crouching() && v:GetVelocity():Length() > 0 && v:GetMoveType() != MOVETYPE_NOCLIP && ((!v:KeyDown(IN_WALK) && (v:KeyDown(IN_FORWARD) or v:KeyDown(IN_BACK) or v:KeyDown(IN_MOVELEFT) or v:KeyDown(IN_MOVERIGHT))) or (v:KeyDown(IN_SPEED) or v:KeyDown(IN_JUMP)))) or
							self:SetTarget(v)
							self:VJ_TASK_FACE_X("TASK_FACE_TARGET")
						end
					end
				end
			end
			//local distlist_closest = false
			//local distlist_inserted = false
			local closestdist_do = false
			/*if entisfri == false then
				local distlist_num = #distlist
				if (distlist_num != 0 && vDistanceToMy < math.min(unpack(distlist))) or (distlist_num == 0) then
					distlist_closest = true
				end
				//table.insert(distlist,vDistanceToMy)
				if IsValid(self:GetEnemy()) && v == self:GetEnemy() then
					distlist[distlist_num+1] = vDistanceToMy
					distlist_inserted = true
				end
			elseif entisfri == true then
				distlist_closest = true
			end*/
			if self.VJ_IsBeingControlled == true then
				if self.VJ_TheControllerBullseye != v then
					//self:AddEntityRelationship(v,D_NU,99)
					v = self.VJ_TheControllerBullseye
					vPlayer = false
				end
			end
			if self.FindEnemy_CanSeeThroughWalls == true then seethroughwall = true end
			if ((self.Behavior == VJ_BEHAVIOR_NEUTRAL && self.Alerted == true) or self.Behavior != VJ_BEHAVIOR_NEUTRAL) && self.DisableFindEnemy == false then
				if (seethroughwall == true) or (self:Visible(v) && (vDistanceToMy < sightdist)) then
					if (self.FindEnemy_UseSphere == false && radiusoverride == 0 && (self:GetForward():Dot((vPos - MyPos):GetNormalized()) > math.cos(math.rad(self.SightAngle)))) or (self.FindEnemy_UseSphere == true or radiusoverride == 1) then
						local check = self:DoRelationshipCheck(v)
						if check == true then
						//if (v.VJ_NoTarget && v.VJ_NoTarget != true) then continue end
							self:AddEntityRelationship(v,D_HT,99)
							//if distlist_inserted == false then distlist[#distlist+1] = vDistanceToMy end
							if (closestdist == nil) or (vDistanceToMy < closestdist) then closestdist = vDistanceToMy; closestdist_do = true end
							//self.CurrentReachableEnemies[#self.CurrentReachableEnemies+1] = v
							self.ReachableEnemyCount = self.ReachableEnemyCount + 1
							enemyseen = true
							if closestdist_do == true then // distlist_closest == true
								self:VJ_DoSetEnemy(v,true,true)
								self:SetEnemy(v)
							end
							//self:VJ_DoSetEnemy(v,true,true)
							//if !IsValid(self:GetEnemy()) then
								//self:VJ_DoSetEnemy(v,true)
							//end
						elseif check == false && vPlayer then
							if IsValid(self:GetEnemy()) && self:GetEnemy() == v then
								self.ResetedEnemy = true
								self:ResetEnemy(false)
							end
						end
					end
				end
			end
			if vPlayer then
				if entisfri == true && self.MoveOutOfFriendlyPlayersWay == true && !self:IsMoving() && CurTime() > self.TakingCoverT && self.VJ_IsBeingControlled == false && (!self.IsVJBaseSNPC_Tank) && self:BusyWithActivity() == false then
					local dist = 20
					if self.FollowingPlayer == true then dist = 10 end
					if /*self:Disposition(v) == D_LI &&*/ (self:VJ_GetNearestPointToEntityDistance(v) < dist) && v:GetVelocity():Length() > 0 && v:GetMoveType() != MOVETYPE_NOCLIP then
						self.NextFollowPlayerT = CurTime() + 2
						self:MoveOutOfPlayersWaySoundCode()
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
				if self.HasOnPlayerSight == true then self:OnPlayerSightCode(v) end
			end
		end
		//return true
	end
	if enemyseen == true then return true else return false end
	//return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CallForHelpCode(SeeDistance)
	if self.CallForHelp == false or self.ThrowingGrenade == true then return false end
	local findents = ents.FindInSphere(self:GetPos(),SeeDistance)
	if (!findents) then return false end
	for _,x in pairs(findents) do
		if x:IsNPC() && x != self && x.IsVJBaseSNPC == true && VJ_IsAlive(x) == true /*&& x:GetClass() == self:GetClass()*/ && x:Disposition(self) != 1 && x:Disposition(self) != 2 && x.IsVJBaseSNPC_Animal != false /*&& x.Behavior != VJ_BEHAVIOR_PASSIVE*/ && x.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE /*&& x.FollowingPlayer == false*/ && x.VJ_IsBeingControlled == false && (!x.IsVJBaseSNPC_Tank) && (x:GetClass() == self:GetClass() or x:Disposition(self) != 4) then
			if x.BringFriendsOnDeath == true or x.CallForBackUpOnDamage == true or x.CallForHelp == true then
				local ene = self:GetEnemy()
				if IsValid(ene) /*&& x.MovementType == VJ_MOVETYPE_STATIONARY*/ && x:GetPos():Distance(ene:GetPos()) > x.SightDistance then continue end -- Yete teshnamin shad herou e, mi sharnager
				//if x:DoRelationshipCheck(ene) == true then
				if !IsValid(x:GetEnemy()) && ((!ene:IsPlayer() && x:Disposition(ene) != D_LI) or (ene:IsPlayer())) /*&& !self:IsCurrentSchedule(SCHED_FORCED_GO_RUN) == true && !self:IsCurrentSchedule(SCHED_FORCED_GO) == true*/ then
					local goingtomove = false
					self:CustomOnCallForHelp(x)
					self:CallForHelpSoundCode()
					//timer.Simple(1,function() if IsValid(self) && IsValid(x) then x:OnReceiveOrderSoundCode() end end)
					if self.HasCallForHelpAnimation == true && CurTime() > self.NextCallForHelpAnimationT then
						local pickanim = VJ_PICK(self.AnimTbl_CallForHelp)
						self:VJ_ACT_PLAYACTIVITY(pickanim,self.CallForHelpStopAnimations,self:DecideAnimationLength(pickanim,self.CallForHelpStopAnimationsTime),self.CallForHelpAnimationFaceEnemy,self.CallForHelpAnimationDelay,{PlayBackRate=self.CallForHelpAnimationPlayBackRate})
						self.NextCallForHelpAnimationT = CurTime() + self.NextCallForHelpAnimationTime
					end
					if self:GetPos():Distance(x:GetPos()) < SeeDistance then
						if (CurTime() > x.NextChaseTime) then
							if IsValid(ene) then
								if ene:IsPlayer() && x.PlayerFriendly == true then
									x.VJ_AddCertainEntityAsEnemy[#x.VJ_AddCertainEntityAsEnemy+1] = ene
								end
								x:VJ_DoSetEnemy(ene,true)
								if x.Behavior != VJ_BEHAVIOR_PASSIVE then
									if x:Visible(ene) then
										x:SetTarget(ene)
										x:VJ_TASK_FACE_X("TASK_FACE_TARGET")
									else
										goingtomove = true
										x:DoChaseAnimation()
									end
								end
							else
								if x.Behavior == VJ_BEHAVIOR_PASSIVE then
									x:DoChaseAnimation()
								else
									goingtomove = true
									local randpos = math.random(1,4)
									if randpos == 1 then x:SetLastPosition(self:GetPos() + self:GetRight()*math.random(20,50))
									elseif randpos == 2 then x:SetLastPosition(self:GetPos() + self:GetRight()*math.random(-20,-50))
									elseif randpos == 3 then x:SetLastPosition(self:GetPos() + self:GetForward()*math.random(20,50))
									elseif randpos == 4 then x:SetLastPosition(self:GetPos() + self:GetForward()*math.random(-20,-50)) end
									self:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH",function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true end)
								end
							end
						end
					end
					if goingtomove == true then x:OnReceiveOrderSoundCode() end
				end
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CheckAlliesAroundMe(SeeDistance)
	SeeDistance = SeeDistance or 800
	local findents = ents.FindInSphere(self:GetPos(),SeeDistance)
	if (!findents) then return end
	local FoundAlliesTbl = {}
	local it = 0
	for _,x in pairs(findents) do
		if (x:IsNPC() or x:GetClass() == self:GetClass()) && x != self /*&& x:GetClass() == self:GetClass()*/ && x:Disposition(self) != 1 && x:Disposition(self) != 2 && (x:GetClass() == self:GetClass() or x:Disposition(self) != 4 or (self.Behavior == VJ_BEHAVIOR_PASSIVE or self.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE)) && VJ_IsAlive(x) == true && x.IsVJBaseSNPC_Animal != false then
			if x.BringFriendsOnDeath == true or x.CallForBackUpOnDamage == true or x.CallForHelp == true then
				if (self.Behavior == VJ_BEHAVIOR_PASSIVE or self.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE) then
					if (x.Behavior == VJ_BEHAVIOR_PASSIVE or x.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE) then
						it = it + 1
						FoundAlliesTbl[it] = x
					end
				elseif (x.Behavior != VJ_BEHAVIOR_PASSIVE  or x.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE) then
					it = it + 1
					FoundAlliesTbl[it] = x
				end
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
function ENT:BringAlliesToMe(Type,SeeDistance,EntsTable,LimitNumber,VisibleOnly)
	//if self.CallForBackUpOnDamage == false then return end
	Type = Type or "Random" -- Types:   "Random" || "Diamond"
	SeeDistance = SeeDistance or 800
	VisibleOnly = VisibleOnly or false
	EntsTable = EntsTable or ents.FindInSphere(self:GetPos(),SeeDistance)
	LimitNumber = LimitNumber or 3 -- 0 for none
	if (!EntsTable) then return false end
	local it = 0
	for _,x in pairs(EntsTable) do
		if VJ_IsAlive(x) == true && x:IsNPC() && x != self /*&& x:GetClass() == self:GetClass()*/ && x:Disposition(self) != 1 && x:Disposition(self) != 2 && (x:GetClass() == self:GetClass() or x:Disposition(self) != 4) && x.IsVJBaseSNPC_Animal != false && x.Behavior != VJ_BEHAVIOR_PASSIVE && x.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE && x.FollowingPlayer == false && x.VJ_IsBeingControlled == false && (!x.IsVJBaseSNPC_Tank) then
			if x.BringFriendsOnDeath == true or x.CallForBackUpOnDamage == true or x.CallForHelp == true then
				if VisibleOnly == true then if x:Visible(self) == false then continue end end
				if !IsValid(x:GetEnemy()) && self:GetPos():Distance(x:GetPos()) < SeeDistance then
					self.NextWanderTime = CurTime() + 8
					x.NextWanderTime = CurTime() + 8
					if Type == "Random" then
						local randpos = math.random(1,4)
						if randpos == 1 then x:SetLastPosition(self:GetPos() + self:GetRight()*math.random(20,50)) end
						if randpos == 2 then x:SetLastPosition(self:GetPos() + self:GetRight()*math.random(-20,-50)) end
						if randpos == 3 then x:SetLastPosition(self:GetPos() + self:GetForward()*math.random(20,50)) end
						if randpos == 4 then x:SetLastPosition(self:GetPos() + self:GetForward()*math.random(-20,-50)) end
					elseif Type == "Diamond" then
						self:DoFormation_Diamond(x,it)
					end
					if x:VJ_HasActiveWeapon() == false then
						x:VJ_TASK_COVER_FROM_ENEMY("TASK_RUN_PATH")
					else
						x:VJ_TASK_GOTO_LASTPOS("TASK_WALK_PATH",function(x) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true end)
					end
					it = it + 1
				end
				if LimitNumber != 0 && it == LimitNumber then return true end
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoKilledEnemy(argent,attacker,inflictor)
	if !IsValid(argent) then return end
	-- If it can only do it if there is no enemies left then check --> (If there no valid enemy) OR (The number of enemies is 1 or less)
	if (self.OnlyDoKillEnemyWhenClear == false) or (self.OnlyDoKillEnemyWhenClear == true && (!IsValid(self:GetEnemy()) or (self.ReachableEnemyCount <= 1))) then
		self:OnKilledEnemySoundCode()
		self:CustomOnDoKilledEnemy(argent,attacker,inflictor)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage(dmginfo,data,hitgroup)
	if self.DoingVJDeathDissolve == true then self.DoingVJDeathDissolve = false return true end
	if self.GodMode == true then return false end
	if dmginfo:GetDamage() <= 0 then return false end

	local DamageInflictor = dmginfo:GetInflictor()
	local DamageAttacker = dmginfo:GetAttacker()
	local DamageType = dmginfo:GetDamageType()
	local hitgroup = self.VJ_ScaleHitGroupDamage
	if IsValid(DamageInflictor) && DamageInflictor:GetClass() == "prop_ragdoll" && DamageInflictor:GetVelocity():Length() <= 100 then return false end
	self:CustomOnTakeDamage_BeforeImmuneChecks(dmginfo,hitgroup)

	if self.GetDamageFromIsHugeMonster == true then
		if DamageAttacker.VJ_IsHugeMonster == true then
			self:SetHealth(self:Health() - dmginfo:GetDamage())
		end
		if self:Health() <= 0 && self.Dead == false then
			self:PriorToKilled(dmginfo,hitgroup)
		end
	end

	if self:IsOnFire() && self:WaterLevel() == 2 then self:Extinguish() end
	
	if VJ_HasValue(self.ImmuneDamagesTable,DamageType) then return end
	if self.AllowIgnition == false && (self:IsOnFire() && IsValid(DamageInflictor) && IsValid(DamageAttacker) && DamageInflictor:GetClass() == "entityflame" && DamageAttacker:GetClass() == "entityflame") then self:Extinguish() return false end
	if self.Immune_Fire == true && (DamageType == DMG_BURN or DamageType == DMG_SLOWBURN or (self:IsOnFire() && IsValid(DamageInflictor) && IsValid(DamageAttacker) && DamageInflictor:GetClass() == "entityflame" && DamageAttacker:GetClass() == "entityflame")) then return false end
	if self.Immune_AcidPoisonRadiation == true && (DamageType == DMG_ACID or DamageType == DMG_RADIATION or DamageType == DMG_POISON or DamageType == DMG_NERVEGAS or DamageType == DMG_PARALYZE) then return false end
	if self.Immune_Bullet == true && (dmginfo:IsBulletDamage() or DamageType == DMG_AIRBOAT or DamageType == DMG_BUCKSHOT) then return false end
	if self.Immune_Blast == true && (DamageType == DMG_BLAST or DamageType == DMG_BLAST_SURFACE) then return false end
	if self.Immune_Dissolve == true then if DamageType == DMG_DISSOLVE then return false end end
	if self.Immune_Electricity == true && (DamageType == DMG_SHOCK or DamageType == DMG_ENERGYBEAM or DamageType == DMG_PHYSGUN) then return false end
	if self.Immune_Melee == true && (DamageType == DMG_CLUB or DamageType == DMG_SLASH) then return false end
	if self.Immune_Physics == true && DamageType == DMG_CRUSH then return false end
	if self.Immune_Sonic == true && DamageType == DMG_SONIC then return false end
	if (IsValid(DamageInflictor) && DamageInflictor:GetClass() == "prop_combine_ball") or (IsValid(DamageAttacker) && DamageAttacker:GetClass() == "prop_combine_ball") then
		if self.Immune_Dissolve == true then return false end
		if CurTime() > self.NextCanGetCombineBallDamageT then
			dmginfo:SetDamage(math.random(400,500))
			dmginfo:SetDamageType(DMG_DISSOLVE)
			self.NextCanGetCombineBallDamageT = CurTime() + 0.2
		else
			dmginfo:SetDamage(1)
		end
	end
	
	local function DoBleed()
		if self.Bleeds == true && dmginfo:GetDamage() > 0 then
			self:CustomOnTakeDamage_OnBleed(dmginfo,hitgroup)
			if self.HasBloodParticle == true && ((!self:IsOnFire()) or (self:IsOnFire() && IsValid(DamageInflictor) && IsValid(DamageAttacker) && DamageInflictor:GetClass() != "entityflame" && DamageAttacker:GetClass() != "entityflame")) then self:SpawnBloodParticles(dmginfo,hitgroup) end
			if self.HasBloodDecal == true then self:SpawnBloodDecal(dmginfo,hitgroup) end
			self:ImpactSoundCode()
		end
	end
	if self.Dead == true then DoBleed() return false end
	
	self:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup)
	if dmginfo:GetDamage() <= 0 then return false end
	self.LatestDmgInfo = dmginfo
	self:SetHealth(self:Health() - dmginfo:GetDamage())
	if self.HasHealthRegeneration == true && self.HealthRegenerationResetOnDmg == true then
		self.HealthRegenerationDelayT = CurTime() + (math.Rand(self.HealthRegenerationDelay.a, self.HealthRegenerationDelay.b) * 1.5)
	end
	if self.VJDEBUG_SNPC_ENABLED == true then if GetConVarNumber("vj_npc_printondamage") == 1 then print(self:GetClass().." Got Damaged! | Amount = "..dmginfo:GetDamage()) end end
	self:CustomOnTakeDamage_AfterDamage(dmginfo,hitgroup)
	DoBleed()

	if self:Health() >= 0 then
		self:DoFlinch(dmginfo,hitgroup)
		self:DamageByPlayerCode(dmginfo,hitgroup)
		self:PainSoundCode()

		if (self.Behavior == VJ_BEHAVIOR_PASSIVE or self.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE) && CurTime() > self.Passive_NextRunOnDamageT then
			if self.Passive_RunOnDamage == true then
				self:VJ_TASK_COVER_FROM_ENEMY("TASK_RUN_PATH",function(x) end)
			end
			if self.Passive_AlliesRunOnDamage then
				local checka = self:CheckAlliesAroundMe(self.Passive_AlliesRunOnDamageDistance)
				if checka != nil then
					for k,v in ipairs(checka) do
						v.Passive_NextRunOnDamageT = CurTime() + math.Rand(v.Passive_NextRunOnDamageTime.b, v.Passive_NextRunOnDamageTime.a)
						v:VJ_TASK_COVER_FROM_ENEMY("TASK_RUN_PATH",function(x) end)
						//v:AlertSoundCode() -- Miyan gentaninaroon hamar!
					end
				end
			end
			self.Passive_NextRunOnDamageT = CurTime() + math.Rand(self.Passive_NextRunOnDamageTime.a, self.Passive_NextRunOnDamageTime.b)
		end

		if self.MoveOrHideOnDamageByEnemy == true && self.Behavior != VJ_BEHAVIOR_PASSIVE && self.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE && IsValid(self:GetEnemy()) && CurTime() > self.NextMoveOrHideOnDamageByEnemyT && self:EyePos():Distance(self:GetEnemy():EyePos()) < self.Weapon_FiringDistanceFar && IsValid(self:GetEnemy()) && self.FollowingPlayer == false && self.Behavior != VJ_BEHAVIOR_PASSIVE && self.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE && self.ThrowingGrenade == false && CurTime() > self.TakingCoverT && self:Visible(self:GetEnemy()) && self.VJ_IsBeingControlled == false && self.MeleeAttacking == false && self.IsReloadingWeapon == false then
			local rancode = false
			if self:VJ_ForwardIsHidingZone(self:NearestPoint(self:GetPos() +self:OBBCenter()),self:GetEnemy():EyePos()) == true && self.MoveOrHideOnDamageByEnemy_OnlyMove == false then
				self:VJ_ACT_TAKE_COVER(self.AnimTbl_MoveOrHideOnDamageByEnemy,false,math.Rand(self.MoveOrHideOnDamageByEnemy_HideTime.a, self.MoveOrHideOnDamageByEnemy_HideTime.b),false)
				rancode = true
			elseif !self:IsMoving() then
				self:VJ_TASK_COVER_FROM_ENEMY("TASK_RUN_PATH",function(x) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true end)
				rancode = true
			end
			if rancode == true then
				self.NextMoveOrHideOnDamageByEnemyT = CurTime() + math.random(self.NextMoveOrHideOnDamageByEnemy1,self.NextMoveOrHideOnDamageByEnemy2)
			end
		end

		if self.CallForBackUpOnDamage == true && CurTime() > self.NextCallForBackUpOnDamageT && self.ThrowingGrenade == false && !IsValid(self:GetEnemy()) && self.FollowingPlayer == false && self.Behavior != VJ_BEHAVIOR_PASSIVE && self.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE && ((!IsValid(DamageInflictor)) or (IsValid(DamageInflictor) && DamageInflictor:GetClass() != "entityflame")) && IsValid(DamageAttacker) && DamageAttacker:GetClass() != "entityflame" then
			local allies = self:CheckAlliesAroundMe(self.CallForBackUpOnDamageDistance)
			if allies != nil then
				self:BringAlliesToMe("Random",self.CallForBackUpOnDamageDistance,allies,self.CallForBackUpOnDamageLimit)
				self:ClearSchedule()
				self.NextFlinchT = CurTime() + 1
				local pickanim = VJ_PICK(self.CallForBackUpOnDamageAnimation)
				if VJ_AnimationExists(self,pickanim) == true && self.DisableCallForBackUpOnDamageAnimation == false then
					self:VJ_ACT_PLAYACTIVITY(pickanim,true,self:DecideAnimationLength(pickanim,self.CallForBackUpOnDamageAnimationTime),true)
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

		if self.BecomeEnemyToPlayer == true && self.VJ_IsBeingControlled == false && DamageAttacker:IsPlayer() && GetConVarNumber("ai_disabled") == 0 && GetConVarNumber("ai_ignoreplayers") == 0 && (self:Disposition(DamageAttacker) == D_LI or self:Disposition(DamageAttacker) == D_NU) then
			if self.AngerLevelTowardsPlayer <= self.BecomeEnemyToPlayerLevel then
				self.AngerLevelTowardsPlayer = self.AngerLevelTowardsPlayer + 1
			end
			if self.AngerLevelTowardsPlayer > self.BecomeEnemyToPlayerLevel then
				if self:Disposition(DamageAttacker) != D_HT then
					self:CustomWhenBecomingEnemyTowardsPlayer(dmginfo,hitgroup)
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
					self:BecomeEnemyToPlayerSoundCode()
				end
				self.Alerted = true
			end
		end

		if self.DisableTakeDamageFindEnemy == false && !IsValid(self:GetEnemy()) && CurTime() > self.TakingCoverT && self.VJ_IsBeingControlled == false && self.Behavior != VJ_BEHAVIOR_PASSIVE && self.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE /*&& self.Alerted == false*/ && GetConVarNumber("ai_disabled") == 0 then
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
			for k,v in pairs(Targets) do
				if CurTime() > self.NextSetEnemyOnDamageT && self:Visible(v) && self:DoRelationshipCheck(v) == true then
					self:CustomOnSetEnemyOnDamage(dmginfo,hitgroup)
					self.NextCallForHelpT = CurTime() + 1
					self:VJ_DoSetEnemy(v,true)
					self:DoChaseAnimation()
					self.NextSetEnemyOnDamageT = CurTime() + 1
				else
					//self:CallForHelpCode(self.CallForHelpDistance)
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
			self.DoingVJDeathDissolve = true
			self:TakeDamageInfo(dissolve)
		end
		self:PriorToKilled(dmginfo,hitgroup)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoFlinch(dmginfo,hitgroup)
	if self.CanFlinch == 0 or self.Flinching == true or CurTime() < self.TakingCoverT or (self.NextFlinchT > CurTime()) or (IsValid(dmginfo:GetInflictor()) && IsValid(dmginfo:GetAttacker()) && dmginfo:GetInflictor():GetClass() == "entityflame" && dmginfo:GetAttacker():GetClass() == "entityflame") then return end

	local function RunFlinchCode(HitBoxInfo)
		self.Flinching = true
		self:StopAttacks(true)
		self.PlayingAttackAnimation = false
		local animtbl = self.AnimTbl_Flinch
		if HitBoxInfo != nil then animtbl = HitBoxInfo.Animation end
		local anim = VJ_PICK(animtbl)
		local animdur = VJ_GetSequenceDuration(self,anim) - self.FlinchAnimationDecreaseLengthAmount
		if self.NextMoveAfterFlinchTime != "LetBaseDecide" && self.NextMoveAfterFlinchTime != false then animdur = self.NextMoveAfterFlinchTime end -- "LetBaseDecide" = Backwards compatibility
		self:VJ_ACT_PLAYACTIVITY(anim,true,animdur,false,0,{SequenceDuration=animdur})
		timer.Simple(animdur,function() if IsValid(self) then self.Flinching = false if IsValid(self:GetEnemy()) then self:DoChaseAnimation() else self:DoIdleAnimation() end end end)
		self:CustomOnFlinch_AfterFlinch(dmginfo,hitgroup)
		self.NextFlinchT = CurTime() + self.NextFlinchTime
	end

	local randflinch = math.random(1,self.FlinchChance)
	if randflinch == 1 then
		if (self.CanFlinch == 2 && VJ_HasValue(self.FlinchDamageTypes,dmginfo:GetDamageType())) or (self.CanFlinch == 1) then
			local allow = self:CustomOnFlinch_BeforeFlinch(dmginfo,hitgroup)
			if allow == false then return end
			if self.HasHitGroupFlinching == true then
				local HitGroupFound = false
				for k,v in ipairs(self.HitGroupFlinching_Values) do
					if VJ_HasValue(v.HitGroup,hitgroup) then
					//if v.HitGroup == hitgroup then
						HitGroupFound = true
						RunFlinchCode(v)
					end
				end
				if HitGroupFound == false && self.HitGroupFlinching_DefaultWhenNotHit == true then
					RunFlinchCode(nil)
				end
			else
				RunFlinchCode(nil)
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoChangeBloodColor(Type)
	local Type = Type or "None"
	if Type == "" then Type = "None" end

	local usegmoddecals = false
	if self.BloodDecalUseGMod == true then usegmoddecals = true end

	local changeparticle = true
	local changedecal = true
	local changepool = true
	if VJ_PICK(self.CustomBlood_Particle) != false then self.CurrentChoosenBlood_Particle = self.CustomBlood_Particle changeparticle = false end
	if VJ_PICK(self.CustomBlood_Decal) != false then self.CurrentChoosenBlood_Decal = self.CustomBlood_Decal changedecal = false end
	if VJ_PICK(self.CustomBlood_Pool) != false then self.CurrentChoosenBlood_Pool = self.CustomBlood_Pool changepool = false end

	if Type == "Red" then
		if changeparticle == true then self.CurrentChoosenBlood_Particle = {"blood_impact_red_01"} end // vj_impact1_red
		if changedecal == true then
			if usegmoddecals == true then
				self.CurrentChoosenBlood_Decal = {"Blood"}
			else
				self.CurrentChoosenBlood_Decal = {"VJ_Blood_Red"}
			end
		end
		if changepool == true then
			if self.BloodPoolSize == "Small" then
				self.CurrentChoosenBlood_Pool = {"vj_bleedout_red_small"}
			elseif self.BloodPoolSize == "Tiny" then
				self.CurrentChoosenBlood_Pool = {"vj_bleedout_red_tiny"}
			else
				self.CurrentChoosenBlood_Pool = {"vj_bleedout_red"}
			end
		end
	elseif Type == "Yellow" then
		if changeparticle == true then self.CurrentChoosenBlood_Particle = {"blood_impact_yellow_01"} end // vj_impact1_yellow
		if changedecal == true then
			if usegmoddecals == true then
				self.CurrentChoosenBlood_Decal = {"YellowBlood"}
			else
				self.CurrentChoosenBlood_Decal = {"VJ_Blood_Yellow"}
			end
		end
		if changepool == true then
			if self.BloodPoolSize == "Small" then
				self.CurrentChoosenBlood_Pool = {"vj_bleedout_yellow_small"}
			elseif self.BloodPoolSize == "Tiny" then
				self.CurrentChoosenBlood_Pool = {"vj_bleedout_yellow_tiny"}
			else
				self.CurrentChoosenBlood_Pool = {"vj_bleedout_yellow"}
			end
		end
	elseif Type == "Green" then
		if changeparticle == true then self.CurrentChoosenBlood_Particle = {"vj_impact1_green"} end
		if changedecal == true then self.CurrentChoosenBlood_Decal = {"VJ_Blood_Green"} end
		if changepool == true then
			if self.BloodPoolSize == "Small" then
				self.CurrentChoosenBlood_Pool = {"vj_bleedout_green_small"}
			elseif self.BloodPoolSize == "Tiny" then
				self.CurrentChoosenBlood_Pool = {"vj_bleedout_green_tiny"}
			else
				self.CurrentChoosenBlood_Pool = {"vj_bleedout_green"}
			end
		end
	elseif Type == "Orange" then
		if changeparticle == true then self.CurrentChoosenBlood_Particle = {"vj_impact1_orange"} end
		if changedecal == true then self.CurrentChoosenBlood_Decal = {"VJ_Blood_Orange"} end
		if changepool == true then
			if self.BloodPoolSize == "Small" then
				self.CurrentChoosenBlood_Pool = {"vj_bleedout_orange_small"}
			elseif self.BloodPoolSize == "Tiny" then
				self.CurrentChoosenBlood_Pool = {"vj_bleedout_orange_tiny"}
			else
				self.CurrentChoosenBlood_Pool = {"vj_bleedout_orange"}
			end
		end
	elseif Type == "Blue" then
		if changeparticle == true then self.CurrentChoosenBlood_Particle = {"vj_impact1_blue"} end
		if changedecal == true then self.CurrentChoosenBlood_Decal = {"VJ_Blood_Blue"} end
		if changepool == true then
			if self.BloodPoolSize == "Small" then
				self.CurrentChoosenBlood_Pool = {"vj_bleedout_blue_small"}
			elseif self.BloodPoolSize == "Tiny" then
				self.CurrentChoosenBlood_Pool = {"vj_bleedout_blue_tiny"}
			else
				self.CurrentChoosenBlood_Pool = {"vj_bleedout_blue"}
			end
		end
	elseif Type == "Purple" then
		if changeparticle == true then self.CurrentChoosenBlood_Particle = {"vj_impact1_purple"} end
		if changedecal == true then self.CurrentChoosenBlood_Decal = {"VJ_Blood_Purple"} end
		if changepool == true then
			if self.BloodPoolSize == "Small" then
				self.CurrentChoosenBlood_Pool = {"vj_bleedout_purple_small"}
			elseif self.BloodPoolSize == "Tiny" then
				self.CurrentChoosenBlood_Pool = {"vj_bleedout_purple_tiny"}
			else
				self.CurrentChoosenBlood_Pool = {"vj_bleedout_purple"}
			end
		end
	elseif Type == "White" then
		if changeparticle == true then self.CurrentChoosenBlood_Particle = {"vj_impact1_white"} end
		if changedecal == true then self.CurrentChoosenBlood_Decal = {"VJ_Blood_White"} end
		if changepool == true then
			if self.BloodPoolSize == "Small" then
				self.CurrentChoosenBlood_Pool = {"vj_bleedout_white_small"}
			elseif self.BloodPoolSize == "Tiny" then
				self.CurrentChoosenBlood_Pool = {"vj_bleedout_white_tiny"}
			else
				self.CurrentChoosenBlood_Pool = {"vj_bleedout_white"}
			end
		end
	elseif Type == "Oil" then
		if changeparticle == true then self.CurrentChoosenBlood_Particle = {"vj_impact1_black"} end
		if changedecal == true then self.CurrentChoosenBlood_Decal = {"VJ_Blood_Oil"} end
		if changepool == true then
			if self.BloodPoolSize == "Small" then
				self.CurrentChoosenBlood_Pool = {"vj_bleedout_oil_small"}
			elseif self.BloodPoolSize == "Tiny" then
				self.CurrentChoosenBlood_Pool = {"vj_bleedout_oil_tiny"}
			else
				self.CurrentChoosenBlood_Pool = {"vj_bleedout_oil"}
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SpawnBloodParticles(dmginfo,hitgroup)
	local p_name = VJ_PICK(self.CurrentChoosenBlood_Particle)
	if p_name == false then return end
	
	local dmg_pos = dmginfo:GetDamagePosition()
	if dmg_pos == Vector(0,0,0) then dmg_pos = self:GetPos() + self:OBBCenter() end
	
	local spawnparticle = ents.Create("info_particle_system")
	spawnparticle:SetKeyValue("effect_name",p_name)
	spawnparticle:SetPos(dmg_pos)
	spawnparticle:Spawn()
	spawnparticle:Activate()
	spawnparticle:Fire("Start","",0)
	spawnparticle:Fire("Kill","",0.1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SpawnBloodDecal(dmginfo,hitgroup)
	if VJ_PICK(self.CurrentChoosenBlood_Decal) == false then return end
	local dmg_force = dmginfo:GetDamageForce()
	local dmg_pos = dmginfo:GetDamagePosition()
	if dmg_pos == Vector(0,0,0) then dmg_pos = self:GetPos() + self:OBBCenter() end
	
	-- Badi verayi ayroun-e
	local tr = util.TraceLine({start = dmg_pos, endpos = (dmg_pos + dmg_force:GetNormal() * math.Clamp(dmg_force:Length() * 10, 100, self.BloodDecalDistance)), filter = self})
	//if !tr.HitWorld then return end
	util.Decal(VJ_PICK(self.CurrentChoosenBlood_Decal), tr.HitPos+tr.HitNormal, tr.HitPos-tr.HitNormal, self)
	for i = 1, 2 do
		if math.random(1,2) == 1 then util.Decal(VJ_PICK(self.CurrentChoosenBlood_Decal), tr.HitPos + tr.HitNormal + Vector(math.random(-70,70), math.random(-70,70),0), tr.HitPos - tr.HitNormal, self) end
	end
	
	-- Kedni verayi ayroun-e
	if math.random(1,2) == 1 then
		local d2_endpos = dmg_pos + Vector(0, 0, -math.Clamp(dmg_force:Length() * 10, 100, self.BloodDecalDistance))
		util.Decal(VJ_PICK(self.CurrentChoosenBlood_Decal), dmg_pos, d2_endpos, self)
		if math.random(1,2) == 1 then util.Decal(VJ_PICK(self.CurrentChoosenBlood_Decal), dmg_pos, d2_endpos + Vector(math.random(-120,120), math.random(-120,120),0),self) end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SpawnBloodPool(dmginfo,hitgroup)
	if !IsValid(self.Corpse) then return end
	local GetCorpse = self.Corpse
	local GetBloodPool = VJ_PICK(self.CurrentChoosenBlood_Pool)
	if GetBloodPool == false then return end
	timer.Simple(2.2,function()
		if IsValid(GetCorpse) then
			local tr = util.TraceLine({
				start = GetCorpse:GetPos()+GetCorpse:OBBCenter(),
				endpos = GetCorpse:GetPos()+GetCorpse:OBBCenter()-Vector(0,0,30),
				filter = GetCorpse, //function( ent ) if ( ent:GetClass() == "prop_physics" ) then return true end end
				mask = CONTENTS_SOLID
			})
			-- (X,Y,Z) | (Ver, Var, Goghme)
			if tr.HitWorld && (tr.HitNormal == Vector(0.0,0.0,1.0)) then // (tr.Fraction <= 0.405)
				ParticleEffect(GetBloodPool,tr.HitPos,Angle(0,0,0),nil)
			end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PriorToKilled(dmginfo,hitgroup)
	self:CustomOnInitialKilled(dmginfo,hitgroup)
	if self.Medic_IsHealingAlly == true then self:DoMedicCode_Reset() end
	
	local checkdist = 800 -- Nayir vormeg tive amenan medzen e, adiga ere vor poon tive ela
	if self.BringFriendsOnDeathDistance > 800 then checkdist = self.BringFriendsOnDeathDistance end
	if self.AlertFriendsOnDeathDistance > 800 then checkdist = self.AlertFriendsOnDeathDistance end
	local allies = self:CheckAlliesAroundMe(checkdist)
	if allies != nil then
		local noalert = true -- Don't run the AlertFriendsOnDeath if we have BringFriendsOnDeath enabled!
		if self.BringFriendsOnDeath == true then
			self:BringAlliesToMe("Random",self.BringFriendsOnDeathDistance,allies,self.BringFriendsOnDeathLimit,true)
			noalert = false
		end
		local it = 0
		for k,v in ipairs(allies) do
			v:CustomOnAllyDeath(self)
			v:AllyDeathSoundCode()
			
			if self.AlertFriendsOnDeath == true && noalert == true && !IsValid(v:GetEnemy()) && v.AlertFriendsOnDeath == true && it != self.AlertFriendsOnDeathLimit && self:GetPos():Distance(v:GetPos()) < self.AlertFriendsOnDeathDistance then
				it = it + 1
				v:FaceCertainEntity(self,false)
				v:VJ_ACT_PLAYACTIVITY(VJ_PICK(v.AnimTbl_AlertFriendsOnDeath),false,0,false)
				v.NextIdleTime = CurTime() + math.Rand(5,8)
			end
		end
	end

	local function DoKilled()
		if IsValid(self) then
			if self.WaitBeforeDeathTime == 0 then
				self:OnKilled(dmginfo,hitgroup)
			else
				timer.Simple(self.WaitBeforeDeathTime,function() if IsValid(self) then self:OnKilled(dmginfo,hitgroup) end end)
			end
		end
	end

	-- Blood decal on the ground
	if self.Bleeds == true && self.HasBloodDecal == true then
		local pickdecal = VJ_PICK(self.CurrentChoosenBlood_Decal)
		if pickdecal != false then
			self:SetLocalPos(Vector(self:GetPos().x,self:GetPos().y,self:GetPos().z +4)) -- Because the NPC is too close to the ground
			local tr = util.TraceLine({
				start = self:GetPos(),
				endpos = self:GetPos() - Vector(0, 0, 500),
				filter = self //function( ent ) if ( ent:GetClass() == "prop_physics" ) then return true end end
			})
			util.Decal(pickdecal,tr.HitPos+tr.HitNormal,tr.HitPos-tr.HitNormal)
		end
	end

	self.Dead = true
	self:RemoveAttackTimers()
	self.MeleeAttacking = false
	self.HasMeleeAttack = false
	self:StopAllCommonSounds()
	self:DeathNotice_PlayerPoints(dmginfo,hitgroup)
	self:CustomOnPriorToKilled(dmginfo,hitgroup)
	self:SetCollisionGroup(1)
	self:RunGibOnDeathCode(dmginfo,hitgroup)
	self:DeathSoundCode()
	//self:AAMove_Stop()
	if self.HasDeathAnimation != true then DoKilled() return end
	if self.HasDeathAnimation == true then
		if GetConVarNumber("vj_npc_nodeathanimation") == 1 or GetConVarNumber("ai_disabled") == 1 or ((dmginfo:GetDamageType() == DMG_DISSOLVE) or (IsValid(dmginfo:GetInflictor()) && dmginfo:GetInflictor():GetClass() == "prop_combine_ball")) then DoKilled() return end
		if dmginfo:GetDamageType() != DMG_DISSOLVE then
			local randanim = math.random(1,self.DeathAnimationChance)
			if randanim != 1 then DoKilled() return end
			if randanim == 1 then
				self:CustomDeathAnimationCode(dmginfo,hitgroup)
				local pickanim = VJ_PICK(self.AnimTbl_Death)
				local seltime = self:DecideAnimationLength(pickanim,self.DeathAnimationTime) - self.DeathAnimationDecreaseLengthAmount
				self:RemoveAllGestures()
				self:VJ_ACT_PLAYACTIVITY(pickanim,true,seltime,false)
				self.DeathAnimationCodeRan = true
				timer.Simple(seltime,DoKilled)
			end
		else
			DoKilled()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RunGibOnDeathCode(dmginfo,hitgroup,Tbl_Features)
	if self.AllowedToGib == false or self.HasGibOnDeath == false or self.HasBeenGibbedOnDeath == true then return end
	vTbl_Features = Tbl_Features or {}
	local DamageType = dmginfo:GetDamageType()
	local dmgtbl = vTbl_Features.CustomDmgTbl or self.GibOnDeathDamagesTable
	local dmgtblempty = false
	local usedefault = false
	local defualtdmgs = self.DefaultGibDamageTypes
	if VJ_HasValue(dmgtbl,"UseDefault") then usedefault = true end
	if usedefault == false && (#dmgtbl <= 0 or VJ_HasValue(dmgtbl,"All")) then dmgtblempty = true end
	if (dmgtblempty == true) or (usedefault == true && VJ_HasValue(defualtdmgs,DamageType)) or (usedefault == false && VJ_HasValue(dmgtbl,DamageType)) then
		local setupgib, setupgib_extra = self:SetUpGibesOnDeath(dmginfo,hitgroup)
		if setupgib_extra == nil then setupgib_extra = {} end
		if setupgib == true then
			if setupgib_extra.AllowCorpse != true then self.HasDeathRagdoll = false end
			if setupgib_extra.DeathAnim != true then self.HasDeathAnimation = false end
			self.HasBeenGibbedOnDeath = true
			self:PlayGibOnDeathSounds(dmginfo,hitgroup)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PlayGibOnDeathSounds(dmginfo,hitgroup)
	if self.HasGibOnDeathSounds == false then return end
	local custom = self:CustomGibOnDeathSounds(dmginfo,hitgroup)
	if custom == true then
		VJ_EmitSound(self,"vj_gib/default_gib_splat.wav",90,math.random(80,100))
		VJ_EmitSound(self,"vj_gib/gibbing1.wav",90,math.random(80,100))
		VJ_EmitSound(self,"vj_gib/gibbing2.wav",90,math.random(80,100))
		VJ_EmitSound(self,"vj_gib/gibbing3.wav",90,math.random(80,100))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CreateGibEntity(Ent,Models,Tbl_Features,CustomCode)
	// self:CreateGibEntity("prop_ragdoll","",{Pos=self:LocalToWorld(Vector(0,3,0)),Ang=self:GetAngles(),Vel=})
	if self.AllowedToGib == false then return end
	Ent = Ent or "prop_ragdoll"
	if Models == "UseAlien_Small" then Models = {"models/gibs/xenians/sgib_01.mdl","models/gibs/xenians/sgib_02.mdl","models/gibs/xenians/sgib_03.mdl"} end
	if Models == "UseAlien_Big" then Models = {"models/gibs/xenians/mgib_01.mdl","models/gibs/xenians/mgib_02.mdl","models/gibs/xenians/mgib_03.mdl","models/gibs/xenians/mgib_04.mdl","models/gibs/xenians/mgib_05.mdl","models/gibs/xenians/mgib_06.mdl","models/gibs/xenians/mgib_07.mdl"} end
	if Models == "UseHuman_Small" then Models = {"models/gibs/humans/sgib_01.mdl","models/gibs/humans/sgib_02.mdl","models/gibs/humans/sgib_03.mdl"} end
	if Models == "UseHuman_Big" then Models = {"models/gibs/humans/mgib_01.mdl","models/gibs/humans/mgib_02.mdl","models/gibs/humans/mgib_03.mdl","models/gibs/humans/mgib_04.mdl","models/gibs/humans/mgib_05.mdl","models/gibs/humans/mgib_06.mdl","models/gibs/humans/mgib_07.mdl"} end
	Models = VJ_PICK(Models)
	local vTbl_BloodType = "Red"
	if VJ_HasValue({"models/gibs/xenians/sgib_01.mdl","models/gibs/xenians/sgib_02.mdl","models/gibs/xenians/sgib_03.mdl","models/gibs/xenians/mgib_01.mdl","models/gibs/xenians/mgib_02.mdl","models/gibs/xenians/mgib_03.mdl","models/gibs/xenians/mgib_04.mdl","models/gibs/xenians/mgib_05.mdl","models/gibs/xenians/mgib_06.mdl","models/gibs/xenians/mgib_07.mdl"},Models) then
		vTbl_BloodType = "Yellow"
	end
	vTbl_Features = Tbl_Features or {}
	vTbl_Position = vTbl_Features.Pos or self:GetPos() +self:OBBCenter()
	vTbl_Angle = vTbl_Features.Ang or Angle(math.Rand(-180,180),math.Rand(-180,180),math.Rand(-180,180)) //self:GetAngles()
	vTbl_Velocity_NoDamageForce = vTbl_Features.Vel_NoDmgForce or false -- If set to true, it won't add the damage force to the given velocity
	vTbl_Velocity = vTbl_Features.Vel or Vector(math.Rand(-100,100),math.Rand(-100,100),math.Rand(150,250)) -- Used to set the velocity | "UseDamageForce" = To use the damage's force only
	if self.LatestDmgInfo != nil then
		local dmgforce = self.LatestDmgInfo:GetDamageForce()/70
		if vTbl_Velocity_NoDamageForce == false && vTbl_Features.Vel != "UseDamageForce" then
			vTbl_Velocity = vTbl_Velocity + dmgforce
		end
		if vTbl_Features.Vel == "UseDamageForce" then
			vTbl_Velocity = dmgforce
		end
	end
	vTbl_AngleVelocity = vTbl_Features.AngVel or Vector(math.Rand(-200,200),math.Rand(-200,200),math.Rand(-200,200)) -- Angle velocity, how fast it rotates as it's flying
	vTbl_BloodType = vTbl_Features.BloodType or vTbl_BloodType -- Certain entities such as the VJ Gib entity, you can use this to set its gib type
	vTbl_BloodDecal = vTbl_Features.BloodDecal or "Default" -- The decal it spawns when it collides with something, leave empty to let the base decide
	vTbl_CollideSound = vTbl_Features.CollideSound or "Default" -- The sound it plays when it collides with something, leave empty to let the base decide
	vTbl_NoFade = vTbl_Features.NoFade or false -- Should it fade away and delete?
	vTbl_RemoveOnCorpseDelete = vTbl_Features.RemoveOnCorpseDelete or false -- Should the entity get removed if the corpse is removed?
	local gib = ents.Create(Ent)
	gib:SetModel(Models)
	gib:SetPos(vTbl_Position)
	gib:SetAngles(vTbl_Angle)
	if gib:GetClass() == "obj_vj_gib" then
		gib.BloodType = vTbl_BloodType
		gib.Collide_Decal = vTbl_BloodDecal
		gib.CollideSound = vTbl_CollideSound
	end
	gib:Spawn()
	gib:Activate()
	gib.IsVJBase_Gib = true
	gib.RemoveOnCorpseDelete = vTbl_RemoveOnCorpseDelete
	if GetConVarNumber("vj_npc_gibcollidable") == 0 then gib:SetCollisionGroup(1) end
	local phys = gib:GetPhysicsObject()
	if IsValid(phys) then
		//phys:SetMass(60)
		phys:AddVelocity(vTbl_Velocity)
		phys:AddAngleVelocity(vTbl_AngleVelocity)
	end
	cleanup.ReplaceEntity(gib)
	if GetConVarNumber("vj_npc_fadegibs") == 1 && vTbl_NoFade == false then
		if gib:GetClass() == "prop_ragdoll" then gib:Fire("FadeAndRemove","",GetConVarNumber("vj_npc_fadegibstime")) end
		if gib:GetClass() == "prop_physics" then gib:Fire("kill","",GetConVarNumber("vj_npc_fadegibstime")) end
	end
	if vTbl_RemoveOnCorpseDelete == true then//self.Corpse:DeleteOnRemove(extraent)
		self.ExtraCorpsesToRemove_Transition[#self.ExtraCorpsesToRemove_Transition+1] = gib
	end
	if (CustomCode) then CustomCode(gib) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeathNotice_PlayerPoints(dmginfo,hitgroup)
	local DamageInflictor = dmginfo:GetInflictor()
	local DamageAttacker = dmginfo:GetAttacker()
	if GetConVarNumber("vj_npc_showhudonkilled") == 1 then gamemode.Call("OnNPCKilled",self,DamageAttacker,DamageInflictor,dmginfo) end
	if GetConVarNumber("vj_npc_addfrags") == 1 && DamageAttacker:IsPlayer() then DamageAttacker:AddFrags(1) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnKilled(dmginfo,hitgroup)
	if self.VJDEBUG_SNPC_ENABLED == true then if GetConVarNumber("vj_npc_printdied") == 1 then print(self:GetClass().." Died!") end end
	self:CustomOnKilled(dmginfo,hitgroup)
	self:DropWeaponOnDeathCode(dmginfo,hitgroup)
	if math.random(1,self.ItemDropsOnDeathChance) == 1 then self:RunItemDropsOnDeathCode(dmginfo,hitgroup) end -- Item drops on death
	if self.HasDeathNotice == true then PrintMessage(self.DeathNoticePosition, self.DeathNoticeWriting) end -- Death notice on death
	self:ClearEnemyMemory()
	self:ClearSchedule()
	//self:SetNPCState(NPC_STATE_DEAD)
	self:CreateDeathCorpse(dmginfo,hitgroup)
	self:Remove()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CreateDeathCorpse(dmginfo,hitgroup)
	self:CustomOnDeath_BeforeCorpseSpawned(dmginfo,hitgroup)
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
		//self.Corpse:SetName("self.Corpse" .. self:EntIndex())
		//self.Corpse:SetModelScale(self:GetModelScale())
		local fadetype = "kill"
		if self.Corpse:GetClass() == "prop_ragdoll" then fadetype = "FadeAndRemove" end
		self.Corpse.FadeCorpseType = fadetype
		self.Corpse.IsVJBaseCorpse = true
		self.Corpse.DamageInfo = dmginfo
		self.Corpse.ExtraCorpsesToRemove = self.ExtraCorpsesToRemove_Transition

		if self.Bleeds == true && self.HasBloodPool == true && GetConVarNumber("vj_npc_nobloodpool") == 0 then
			self:SpawnBloodPool(dmginfo,hitgroup)
		end

		-- Miscellaneous --
		if GetConVarNumber("ai_serverragdolls") == 0 then self.Corpse:SetCollisionGroup(1) hook.Call("VJ_CreateSNPCCorpse",nil,self.Corpse,self) else undo.ReplaceEntity(self,self.Corpse) end
		if self.DeathCorpseAlwaysCollide == true then self.Corpse:SetCollisionGroup(0) end
		
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
		
		cleanup.ReplaceEntity(self,self.Corpse) -- Delete on cleanup
		if GetConVarNumber("vj_npc_undocorpse") == 1 then undo.ReplaceEntity(self,self.Corpse) end -- Undoable
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
	
		if IsValid(self.TheDroppedWeapon) then self.Corpse.ExtraCorpsesToRemove[#self.Corpse.ExtraCorpsesToRemove+1] = self.TheDroppedWeapon end
		if self.FadeCorpse == true then self.Corpse:Fire(self.Corpse.FadeCorpseType,"",self.FadeCorpseTime) end
		if GetConVarNumber("vj_npc_corpsefade") == 1 then self.Corpse:Fire(self.Corpse.FadeCorpseType,"",GetConVarNumber("vj_npc_corpsefadetime")) end
		self:CustomOnDeath_AfterCorpseSpawned(dmginfo,hitgroup,self.Corpse)
		self.Corpse:CallOnRemove("vj_"..self.Corpse:EntIndex(),function(ent,exttbl)
			for k,v in ipairs(exttbl) do
				if IsValid(v) then
					if v:GetClass() == "prop_ragdoll" then v:Fire("FadeAndRemove","",0) else v:Fire("kill","",0) end
				end
			end
		end,self.Corpse.ExtraCorpsesToRemove)
		return self.Corpse
	else
		if IsValid(self.TheDroppedWeapon) then self.TheDroppedWeapon:Remove() end
		for k,v in ipairs(self.ExtraCorpsesToRemove_Transition) do
			if v.IsVJBase_Gib == true && v.RemoveOnCorpseDelete == true then
				v:Remove()
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CreateExtraDeathCorpse(Ent,Models,Tbl_Features,CustomCode)
	-- Should only be ran after self.Corpse has been created!
	if !IsValid(self.Corpse) then return end
	local dmginfo = self.Corpse.DamageInfo
	if dmginfo == nil then return end
	local dmgforce = dmginfo:GetDamageForce()
	Ent = Ent or "prop_ragdoll"
	vTbl_Features = Tbl_Features or {}
	vTbl_Position = vTbl_Features.Pos or self:GetPos()
	vTbl_Angle = vTbl_Features.Ang or self:GetAngles()
	vTbl_HasVelocity = vTbl_Features.HasVel
		if vTbl_HasVelocity == nil then vTbl_HasVelocity = true end
	vTbl_Velocity = vTbl_Features.Vel or dmgforce /37
	vTbl_ShouldFade = vTbl_Features.ShouldFade or false -- Should it get removed after certain time?
	vTbl_ShouldFadeTime = vTbl_Features.ShouldFadeTime or 0 -- How much time until the entity gets removed?
	vTbl_RemoveOnCorpseDelete = vTbl_Features.RemoveOnCorpseDelete -- Should the entity get removed if the corpse is removed?
		if vTbl_RemoveOnCorpseDelete == nil then vTbl_RemoveOnCorpseDelete = true end
	local extraent = ents.Create(Ent)
	if Models != "None" then extraent:SetModel(VJ_PICK(Models)) end
	extraent:SetPos(vTbl_Position)
	extraent:SetAngles(vTbl_Angle)
	extraent:Spawn()
	extraent:Activate()
	extraent:SetColor(self.Corpse:GetColor())
	extraent:SetMaterial(self.Corpse:GetMaterial())
	if GetConVarNumber("ai_serverragdolls") == 0 then extraent:SetCollisionGroup(1) end
	if self.Corpse:IsOnFire() then
		extraent:Ignite(math.Rand(8,10),0)
		extraent:SetColor(Color(90,90,90))
	end
	if vTbl_HasVelocity == true then extraent:GetPhysicsObject():AddVelocity(vTbl_Velocity) end
	if vTbl_ShouldFade == true then
		if extraent:GetClass() == "prop_ragdoll" then
			extraent:Fire("FadeAndRemove","",vTbl_ShouldFadeTime)
		else
			extraent:Fire("kill","",vTbl_ShouldFadeTime)
		end
	end
	if vTbl_RemoveOnCorpseDelete == true then//self.Corpse:DeleteOnRemove(extraent)
		self.Corpse.ExtraCorpsesToRemove[#self.Corpse.ExtraCorpsesToRemove+1] = extraent
	end
	if (CustomCode) then CustomCode(extraent) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	self:CustomOnRemove()
	self.Dead = true
	-- Stop Things --
	if self.Medic_IsHealingAlly == true then self:DoMedicCode_Reset() end
	self:StopAllCommonSounds()
	self:RemoveAttackTimers()
	self:StopParticles()

	//if self.HasSoundTrack == true then
	//if self.HasSounds == true then
	//if GetConVarNumber("vj_npc_sd_soundtrack") == 0 then
	//if self.thememusicsd:IsPlaying() == true then
	//if self.thememusicsd then self.thememusicsd:FadeOut(self.SoundTrackFadeOutTime) end
	//end
   //end
  //end
 //end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DropWeaponOnDeathCode(dmginfo,hitgroup)
	if self.DropWeaponOnDeath != true or self:VJ_HasActiveWeapon() != true /*or dmginfo:GetDamageType() == DMG_DISSOLVE*/ then return end
	
	self:CustomOnDropWeapon(dmginfo,hitgroup)

	local gunang = Angle(0,0,0)
	if self:GetActiveWeapon():GetClass() == "weapon_ar2" or self:GetActiveWeapon():GetClass() == "weapon_vj_ar2" or self:GetActiveWeapon():GetClass() == "weapon_vj_blaster" then gunang = Angle(0,180,0) end
	if self:GetActiveWeapon():GetClass() == "weapon_pistol" or self:GetActiveWeapon():GetClass() == "weapon_vj_9mmpistol" or self:GetActiveWeapon():GetClass() == "weapon_vj_357" then gunang = Angle(0,180,0) end
	if self:GetActiveWeapon():GetClass() == "weapon_shotgun" or self:GetActiveWeapon():GetClass() == "weapon_vj_spas12" then gunang = Angle(0,180,0) end
	if self:GetActiveWeapon():GetClass() == "weapon_annabelle" then gunang = Angle(0,180,0) end
	if self:GetActiveWeapon():GetClass() == "weapon_rpg" then gunang = Angle(0,180,0) end
	if self:GetActiveWeapon():GetClass() == "weapon_citizenpackage" then gunang = Angle(0,180,0) end
	if self:GetActiveWeapon():GetClass() == "weapon_crowbar" then gunang = Angle(90,0,0) end
	if self:GetActiveWeapon():GetClass() == "weapon_stunstick" then gunang = Angle(90,0,0) end

	local nohandattach = true
	for k,v in ipairs(self:GetAttachments()) do
		if v.name == self.DropWeaponOnDeathAttachment then
			nohandattach = false
		end
	end
	if self:GetActiveWeapon().WorldModel_UseCustomPosition == true then nohandattach = true end
	//local gunpos = self:GetAttachment(self:LookupAttachment("gun"))

	self.TheDroppedWeapon = ents.Create(self:GetActiveWeapon():GetClass())
	if nohandattach == false then
	self.TheDroppedWeapon:SetPos(self:GetAttachment(self:LookupAttachment(self.DropWeaponOnDeathAttachment)).Pos) else
	self.TheDroppedWeapon:SetPos(self:GetActiveWeapon():GetPos()) end
	if nohandattach == false then
	self.TheDroppedWeapon:SetAngles(self:GetAttachment(self:LookupAttachment(self.DropWeaponOnDeathAttachment)).Ang + gunang) else
	self.TheDroppedWeapon:SetAngles(self:GetActiveWeapon():GetAngles() + gunang) end
	self.TheDroppedWeapon:Spawn()
	self.TheDroppedWeapon:Activate()
	local noforce = false
	local phys = self.TheDroppedWeapon:GetPhysicsObject()
	if IsValid(dmginfo:GetInflictor()) && dmginfo:GetInflictor():GetClass() == "prop_combine_ball" then
		noforce = true
	end
	if noforce == false && IsValid(phys) then
		phys:SetMass(60)
		phys:ApplyForceCenter(dmginfo:GetDamageForce())
	end
	
	self:CustomOnDropWeapon_AfterWeaponSpawned(dmginfo,hitgroup,self.TheDroppedWeapon)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RunItemDropsOnDeathCode(dmginfo,hitgroup)
	if self.HasItemDropsOnDeath == false then return end
	self:CustomRareDropsOnDeathCode(dmginfo,hitgroup)
	local entlist = VJ_PICK(self.ItemDropsOnDeath_EntityList)
	if entlist != false then
		local randdrop = ents.Create(entlist)
		randdrop:SetPos(self:GetPos() +self:OBBCenter())
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
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FollowPlayerSoundCode(CustomTbl,Type)
	if self.HasSounds == false or self.HasFollowPlayerSounds_Follow == false then return end
	Type = Type or VJ_CreateSound
	local ctbl = VJ_PICK(CustomTbl)
	local sdtbl = VJ_PICK(self.SoundTbl_FollowPlayer)
	if (math.random(1,self.FollowPlayerSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
		if ctbl != false then sdtbl = ctbl end
		self:StopAllCommonSpeechSounds()
		self.NextIdleSoundT_RegularChange = CurTime() + math.random(3,4)
		self.CurrentFollowPlayerSound = Type(self,sdtbl,self.FollowPlayerSoundLevel,self:VJ_DecideSoundPitch(self.FollowPlayerPitch1,self.FollowPlayerPitch2))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:UnFollowPlayerSoundCode(CustomTbl,Type)
	if self.HasSounds == false or self.HasFollowPlayerSounds_UnFollow == false then return end
	Type = Type or VJ_CreateSound
	local ctbl = VJ_PICK(CustomTbl)
	local sdtbl = VJ_PICK(self.SoundTbl_UnFollowPlayer)
	if (math.random(1,self.UnFollowPlayerSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
		if ctbl != false then sdtbl = ctbl end
		self:StopAllCommonSpeechSounds()
		self.NextIdleSoundT_RegularChange = CurTime() + math.random(3,4)
		self.CurrentUnFollowPlayerSound = Type(self,sdtbl,self.UnFollowPlayerSoundLevel,self:VJ_DecideSoundPitch(self.UnFollowPlayerPitch1,self.UnFollowPlayerPitch2))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MoveOutOfPlayersWaySoundCode(CustomTbl,Type)
	if self.HasSounds == false or self.HasMoveOutOfPlayersWaySounds == false then return end
	Type = Type or VJ_CreateSound
	local ctbl = VJ_PICK(CustomTbl)
	local sdtbl = VJ_PICK(self.SoundTbl_MoveOutOfPlayersWay)
	if (math.random(1,self.MoveOutOfPlayersWaySoundChance) == 1 && sdtbl != false) or (ctbl != false) then
		if ctbl != false then sdtbl = ctbl end
		self:StopAllCommonSpeechSounds()
		self.NextIdleSoundT_RegularChange = CurTime() + math.random(3,4)
		self.CurrentMoveOutOfPlayersWaySound = Type(self,sdtbl,self.MoveOutOfPlayersWaySoundLevel,self:VJ_DecideSoundPitch(self.MoveOutOfPlayersWaySoundPitch1,self.MoveOutOfPlayersWaySoundPitch2))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MedicSoundCode_BeforeHeal(CustomTbl,Type)
	if self.HasSounds == false or self.HasMedicSounds_BeforeHeal == false then return end
	Type = Type or VJ_CreateSound
	local ctbl = VJ_PICK(CustomTbl)
	local sdtbl = VJ_PICK(self.SoundTbl_MedicBeforeHeal)
	if (math.random(1,self.MedicBeforeHealSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
		if ctbl != false then sdtbl = ctbl end
		self:StopAllCommonSpeechSounds()
		self.NextIdleSoundT_RegularChange = CurTime() + math.random(3,4)
		self.CurrentMedicBeforeHealSound = Type(self,sdtbl,self.BeforeHealSoundLevel,self:VJ_DecideSoundPitch(self.BeforeHealSoundPitch1,self.BeforeHealSoundPitch2))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MedicSoundCode_OnHeal(CustomTbl,Type)
	if self.HasSounds == false or self.HasMedicSounds_AfterHeal == false then return end
	Type = Type or VJ_CreateSound
	local ctbl = VJ_PICK(CustomTbl)
	local sdtbl = VJ_PICK(self.SoundTbl_MedicAfterHeal)
	if sdtbl == false then sdtbl = VJ_PICK(self.DefaultSoundTbl_MedicAfterHeal) end -- Default table
	if (math.random(1,self.MedicAfterHealSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
		if ctbl != false then sdtbl = ctbl end
		self:StopAllCommonSpeechSounds()
		self.NextIdleSoundT_RegularChange = CurTime() + math.random(3,4)
		self.CurrentMedicAfterHealSound = Type(self,sdtbl,self.AfterHealSoundLevel,self:VJ_DecideSoundPitch(self.AfterHealSoundPitch1,self.AfterHealSoundPitch2))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MedicSoundCode_ReceiveHeal(CustomTbl,Type)
	if self.HasSounds == false or self.HasMedicSounds_ReceiveHeal == false then return end
	Type = Type or VJ_CreateSound
	local ctbl = VJ_PICK(CustomTbl)
	local sdtbl = VJ_PICK(self.SoundTbl_MedicReceiveHeal)
	if (math.random(1,self.MedicReceiveHealSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
		if ctbl != false then sdtbl = ctbl end
		self:StopAllCommonSpeechSounds()
		self.NextIdleSoundT_RegularChange = CurTime() + math.random(3,4)
		self.CurrentMedicReceiveHealSound = Type(self,sdtbl,self.MedicReceiveHealSoundLevel,self:VJ_DecideSoundPitch(self.MedicReceiveHealSoundPitch1,self.MedicReceiveHealSoundPitch2))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPlayerSightSoundCode(CustomTbl,Type)
	if self.HasSounds == false or self.HasOnPlayerSightSounds == false then return end
	Type = Type or VJ_CreateSound
	local ctbl = VJ_PICK(CustomTbl)
	local sdtbl = VJ_PICK(self.SoundTbl_OnPlayerSight)
	if (math.random(1,self.OnPlayerSightSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
		if ctbl != false then sdtbl = ctbl end
		self:StopAllCommonSpeechSounds()
		self.NextIdleSoundT_RegularChange = CurTime() + math.random(3,4)
		self.NextAlertSoundT = CurTime() + math.random(1,2)
		self.CurrentOnPlayerSightSound = Type(self,sdtbl,self.OnPlayerSightSoundLevel,self:VJ_DecideSoundPitch(self.OnPlayerSightSoundPitch1,self.OnPlayerSightSoundPitch2))
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
		if hasenemy == true then
			local sdtbl = VJ_PICK(self.SoundTbl_CombatIdle)
			if (math.random(1,self.CombatIdleSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
				if ctbl != false then sdtbl = ctbl end
				self.CurrentIdleSound = Type(self,sdtbl,self.CombatIdleSoundLevel,self:VJ_DecideSoundPitch(self.CombatIdleSoundPitch1,self.CombatIdleSoundPitch2))
			end
		else
			local sdtbl = VJ_PICK(self.SoundTbl_Idle)
			local sdtbl2 = VJ_PICK(self.SoundTbl_IdleDialogue)
			local sdrand = math.random(1,self.IdleSoundChance)
			local function RegularIdle()
				if (sdrand == 1 && sdtbl != false) or (ctbl != false) then
					if ctbl != false then sdtbl = ctbl end
					self.CurrentIdleSound = Type(self,sdtbl,self.IdleSoundLevel,self:VJ_DecideSoundPitch(self.IdleSoundPitch1,self.IdleSoundPitch2))
				end
			end
			if sdtbl2 != false && sdrand == 1 && self.HasIdleDialogueSounds == true && math.random(1,2) == 1 then
				local testent, testsd = self:IdleDialogueSoundCodeTest()
				if testent != false then
					if self:CustomOnIdleDialogue(testent, testsd) == false then
						RegularIdle()
					else
						self.CurrentIdleSound = Type(self,sdtbl2,self.IdleDialogueSoundLevel,self:VJ_DecideSoundPitch(self.IdleDialogueSoundPitch.a,self.IdleDialogueSoundPitch.b))
						if testsd == true then
							local dur = SoundDuration(sdtbl2)
							if dur == 0 then dur = 3 end
							testent.NextIdleSoundT = CurTime() + dur + 0.5
							self.NextIdleTime = CurTime() + 1
							self.NextWanderTime = CurTime() + (dur + 1.5)
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
							timer.Simple(dur + 0.3, function()
								if IsValid(self) && IsValid(testent) then
									testent:IdleDialogueAnswerSoundCode()
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
		self.NextIdleSoundT = CurTime() + math.Rand(self.NextSoundTime_Idle1,self.NextSoundTime_Idle2)
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IdleDialogueSoundCodeTest()
	local ret = false
	for k,v in ipairs(ents.FindInSphere(self:GetPos(),self.IdleDialogueDistance)) do
		if v:IsPlayer() && self:DoRelationshipCheck(v) == false then
			ret = v
		elseif v != self && ((self:GetClass() == v:GetClass()) or (v:IsNPC() && self:DoRelationshipCheck(v) == false)) && self:Visible(v) then
			ret = v
			if v.IsVJBaseSNPC == true && VJ_PICK(v.SoundTbl_IdleDialogueAnswer) != false then
				return v, true -- Yete VJ NPC e, ere vor function-e gena
			end
		end
	end
	return ret, false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IdleDialogueAnswerSoundCode(CustomTbl,Type)
	if self.HasSounds == false or self.HasIdleDialogueAnswerSounds == false then return end
	Type = Type or VJ_CreateSound
	local ctbl = VJ_PICK(CustomTbl)
	local sdtbl = VJ_PICK(self.SoundTbl_IdleDialogueAnswer)
	if (math.random(1,self.IdleDialogueAnswerSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
		if ctbl != false then sdtbl = ctbl end
		self:CustomOnIdleDialogueAnswer()
		self:StopAllCommonSpeechSounds()
		self.NextIdleSoundT_RegularChange = CurTime() + math.random(2,3)
		self.CurrentIdleDialogueAnswerSound = Type(self,sdtbl,self.IdleDialogueAnswerSoundLevel,self:VJ_DecideSoundPitch(self.IdleDialogueAnswerSoundPitch.a,self.IdleDialogueAnswerSoundPitch.b))
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:InvestigateSoundCode(CustomTbl,Type)
	if self.HasSounds == false or self.HasInvestigateSounds == false then return end
	if CurTime() > self.NextInvestigateSoundT then
		Type = Type or VJ_CreateSound
		local ctbl = VJ_PICK(CustomTbl)
		local sdtbl = VJ_PICK(self.SoundTbl_Investigate)
		if (math.random(1,self.InvestigateSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
			if ctbl != false then sdtbl = ctbl end
			self:StopAllCommonSpeechSounds()
			self.NextIdleSoundT = self.NextIdleSoundT + 2
			self.CurrentInvestigateSound = Type(self,sdtbl,self.InvestigateSoundLevel,self:VJ_DecideSoundPitch(self.InvestigateSoundPitch1,self.InvestigateSoundPitch2))
		end
		self.NextInvestigateSoundT = CurTime() + math.Rand(self.NextSoundTime_Investigate1,self.NextSoundTime_Investigate2)
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:LostEnemySoundCode(CustomTbl,Type)
	if self.HasSounds == false or self.HasLostEnemySounds == false then return end
	if CurTime() > self.LostEnemySoundT then
		Type = Type or VJ_CreateSound
		local ctbl = VJ_PICK(CustomTbl)
		local sdtbl = VJ_PICK(self.SoundTbl_LostEnemy)
		if (math.random(1,self.LostEnemySoundChance) == 1 && sdtbl != false) or (ctbl != false) then
			if ctbl != false then sdtbl = ctbl end
			self:StopAllCommonSpeechSounds()
			self.NextIdleSoundT = self.NextIdleSoundT + 2
			self.CurrentLostEnemySound = Type(self,sdtbl,self.LostEnemySoundLevel,self:VJ_DecideSoundPitch(self.LostEnemySoundPitch1,self.LostEnemySoundPitch2))
		end
		self.LostEnemySoundT = CurTime() + math.Rand(self.NextSoundTime_LostEnemy1,self.NextSoundTime_LostEnemy2)
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnReceiveOrderSoundCode(CustomTbl,Type)
	if self.HasSounds == false or self.HasOnReceiveOrderSounds == false then return end
	Type = Type or VJ_CreateSound
	local ctbl = VJ_PICK(CustomTbl)
	local sdtbl = VJ_PICK(self.SoundTbl_OnReceiveOrder)
	if (math.random(1,self.OnReceiveOrderSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
		if ctbl != false then sdtbl = ctbl end
		self:StopAllCommonSpeechSounds()
		self.NextIdleSoundT = self.NextIdleSoundT + 2
		self.NextAlertSoundT = CurTime() + 2
		self.CurrentOnReceiveOrderSound = Type(self,sdtbl,self.OnReceiveOrderSoundLevel,self:VJ_DecideSoundPitch(self.OnReceiveOrderSoundPitch1,self.OnReceiveOrderSoundPitch2))
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AlertSoundCode(CustomTbl,Type)
	if self.HasSounds == false or self.HasAlertSounds == false then return end
	Type = Type or VJ_CreateSound
	local ctbl = VJ_PICK(CustomTbl)
	local sdtbl = VJ_PICK(self.SoundTbl_Alert)
	if (math.random(1,self.AlertSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
		if ctbl != false then sdtbl = ctbl end
		self:StopAllCommonSpeechSounds()
		self.NextIdleSoundT = self.NextIdleSoundT + 3
		self.NextSuppressingSoundT = self.NextSuppressingSoundT + 4
		self.CurrentAlertSound = Type(self,sdtbl,self.AlertSoundLevel,self:VJ_DecideSoundPitch(self.AlertSoundPitch1,self.AlertSoundPitch2))
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CallForHelpSoundCode(CustomTbl,Type)
	if self.HasSounds == false or self.HasCallForHelpSounds == false then return end
	Type = Type or VJ_CreateSound
	local ctbl = VJ_PICK(CustomTbl)
	local sdtbl = VJ_PICK(self.SoundTbl_CallForHelp)
	if (math.random(1,self.CallForHelpSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
		if ctbl != false then sdtbl = ctbl end
		self:StopAllCommonSpeechSounds()
		self.NextIdleSoundT = self.NextIdleSoundT + 2
		self.NextSuppressingSoundT = self.NextSuppressingSoundT + 2.5
		self.CurrentCallForHelpSound = Type(self,sdtbl,self.CallForHelpSoundLevel,self:VJ_DecideSoundPitch(self.CallForHelpSoundPitch1,self.CallForHelpSoundPitch2))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnKilledEnemySoundCode(CustomTbl,Type)
	if self.HasSounds == false or self.HasOnKilledEnemySound == false then return end
	if CurTime() > self.OnKilledEnemySoundT then
		Type = Type or VJ_CreateSound
		local ctbl = VJ_PICK(CustomTbl)
		local sdtbl = VJ_PICK(self.SoundTbl_OnKilledEnemy)
		if (math.random(1,self.OnKilledEnemySoundChance) == 1 && sdtbl != false) or (ctbl != false) then
			if ctbl != false then sdtbl = ctbl end
			self:StopAllCommonSpeechSounds()
			self.NextIdleSoundT = self.NextIdleSoundT + 2
			self.CurrentOnKilledEnemySound = Type(self,sdtbl,self.OnKilledEnemySoundLevel,self:VJ_DecideSoundPitch(self.OnKilledEnemySoundPitch1,self.OnKilledEnemySoundPitch2))
		end
		self.OnKilledEnemySoundT = CurTime() + math.Rand(self.NextSoundTime_OnKilledEnemy1,self.NextSoundTime_OnKilledEnemy2)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DamageByPlayerSoundCode(CustomTbl,Type)
	if self.HasSounds == false or self.HasDamageByPlayerSounds == false then return end
	if CurTime() > self.NextDamageByPlayerSoundT then
		Type = Type or VJ_CreateSound
		local ctbl = VJ_PICK(CustomTbl)
		local sdtbl = VJ_PICK(self.SoundTbl_DamageByPlayer)
		if (math.random(1,self.DamageByPlayerSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
			if ctbl != false then sdtbl = ctbl end
			self:StopAllCommonSpeechSounds()
			self.NextIdleSoundT_RegularChange = CurTime() + 1
			timer.Simple(0.05,function() if IsValid(self) then VJ_STOPSOUND(self.CurrentPainSound) end end)
			self.CurrentDamageByPlayerSound = Type(self,sdtbl,self.DamageByPlayerSoundLevel,self:VJ_DecideSoundPitch(self.DamageByPlayerPitch1,self.DamageByPlayerPitch2))
		end
		self.NextDamageByPlayerSoundT = CurTime() + math.Rand(self.NextSoundTime_DamageByPlayer1,self.NextSoundTime_DamageByPlayer2)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BeforeMeleeAttackSoundCode(CustomTbl,Type)
	if self.HasSounds == false or self.HasMeleeAttackSounds == false then return end
	Type = Type or VJ_CreateSound
	local ctbl = VJ_PICK(CustomTbl)
	local sdtbl = VJ_PICK(self.SoundTbl_BeforeMeleeAttack)
	if (math.random(1,self.BeforeMeleeAttackSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
		if ctbl != false then sdtbl = ctbl end
		if self.IdleSounds_PlayOnAttacks == false then VJ_STOPSOUND(self.CurrentIdleSound) end
		self.NextIdleSoundT_RegularChange = CurTime() + 1
		self.CurrentBeforeMeleeAttackSound = Type(self,sdtbl,self.BeforeMeleeAttackSoundLevel,self:VJ_DecideSoundPitch(self.BeforeMeleeAttackSoundPitch1,self.BeforeMeleeAttackSoundPitch2))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MeleeAttackSoundCode(CustomTbl,Type)
	if self.HasSounds == false or self.HasMeleeAttackSounds == false then return end
	Type = Type or VJ_CreateSound
	local ctbl = VJ_PICK(CustomTbl)
	local sdtbl = VJ_PICK(self.SoundTbl_MeleeAttack)
	if sdtbl == false then sdtbl = VJ_PICK(self.DefaultSoundTbl_MeleeAttack) end -- Default table
	if (math.random(1,self.MeleeAttackSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
		if ctbl != false then sdtbl = ctbl end
		if self.IdleSounds_PlayOnAttacks == false then VJ_STOPSOUND(self.CurrentIdleSound) end
		self.NextIdleSoundT_RegularChange = CurTime() + 1
		self.CurrentMeleeAttackSound = Type(self,sdtbl,self.MeleeAttackSoundLevel,self:VJ_DecideSoundPitch(self.MeleeAttackSoundPitch1,self.MeleeAttackSoundPitch2))
	end
	
	if self.HasExtraMeleeAttackSounds == true then
		local sdtbl = VJ_PICK(self.SoundTbl_MeleeAttackExtra)
		if (math.random(1,self.ExtraMeleeSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
			VJ_STOPSOUND(self.CurrentIdleSound)
			self.CurrentExtraMeleeAttackSound = VJ_EmitSound(self,sdtbl,self.ExtraMeleeAttackSoundLevel,self:VJ_DecideSoundPitch(self.ExtraMeleeSoundPitch1,self.ExtraMeleeSoundPitch2))
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MeleeAttackMissSoundCode(CustomTbl,Type)
	if self.HasSounds == false or self.HasMeleeAttackMissSounds == false then return end
	Type = Type or VJ_EmitSound
	local ctbl = VJ_PICK(CustomTbl)
	local sdtbl = VJ_PICK(self.SoundTbl_MeleeAttackMiss)
	if sdtbl == false then sdtbl = VJ_PICK(self.DefaultSoundTbl_MeleeAttackMiss) end -- Default table
	if (math.random(1,self.MeleeAttackMissSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
		if ctbl != false then sdtbl = ctbl end
		VJ_STOPSOUND(self.CurrentIdleSound)
		self.NextIdleSoundT_RegularChange = CurTime() + 1
		self.CurrentMeleeAttackMissSound = Type(self,sdtbl,self.MeleeAttackMissSoundLevel,self:VJ_DecideSoundPitch(self.MeleeAttackMissSoundPitch1,self.MeleeAttackMissSoundPitch2))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SuppressingSoundCode(CustomTbl,Type)
	if self.HasSounds == false or self.HasSuppressingSounds == false then return end
	if CurTime() > self.NextSuppressingSoundT then
		Type = Type or VJ_CreateSound
		local ctbl = VJ_PICK(CustomTbl)
		local sdtbl = VJ_PICK(self.SoundTbl_Suppressing)
		if (math.random(1,self.SuppressingSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
			if ctbl != false then sdtbl = ctbl end
			self:StopAllCommonSpeechSounds()
			self.NextIdleSoundT_RegularChange = CurTime() + 2
			self.CurrentSuppressingSound = Type(self,sdtbl,self.SuppressingSoundLevel,self:VJ_DecideSoundPitch(self.SuppressingPitch1,self.SuppressingPitch2))
		end
		self.NextSuppressingSoundT = CurTime() + math.Rand(self.NextSoundTime_Suppressing1,self.NextSoundTime_Suppressing2)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:WeaponReloadSoundCode(CustomTbl,Type)
	if self.HasSounds == false or self.HasWeaponReloadSounds == false then return end
	if CurTime() > self.NextWeaponReloadSoundT then
		Type = Type or VJ_CreateSound
		local ctbl = VJ_PICK(CustomTbl)
		local sdtbl = VJ_PICK(self.SoundTbl_WeaponReload)
		if (math.random(1,self.WeaponReloadSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
			if ctbl != false then sdtbl = ctbl end
			self:StopAllCommonSpeechSounds()
			self.NextIdleSoundT_RegularChange = CurTime() + math.random(3,4)
			self.CurrentWeaponReloadSound = Type(self,sdtbl,self.WeaponReloadSoundLevel,self:VJ_DecideSoundPitch(self.WeaponReloadSoundPitch1,self.WeaponReloadSoundPitch2))
		end
		self.NextWeaponReloadSoundT = CurTime() + math.Rand(self.NextSoundTime_WeaponReload1,self.NextSoundTime_WeaponReload2)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GrenadeAttackSoundCode(CustomTbl,Type)
	if self.HasSounds == false or self.HasGrenadeAttackSounds == false then return end
	if CurTime() > self.NextGrenadeAttackSoundT then
		Type = Type or VJ_CreateSound
		local ctbl = VJ_PICK(CustomTbl)
		local sdtbl = VJ_PICK(self.SoundTbl_GrenadeAttack)
		if (math.random(1,self.GrenadeAttackSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
			if ctbl != false then sdtbl = ctbl end
			if self.IdleSounds_PlayOnAttacks == false then self:StopAllCommonSpeechSounds() end
			self.NextIdleSoundT_RegularChange = CurTime() + math.random(3,4)
			self.CurrentGrenadeAttackSound = Type(self,sdtbl,self.GrenadeAttackSoundLevel,self:VJ_DecideSoundPitch(self.GrenadeAttackSoundPitch1,self.GrenadeAttackSoundPitch2))
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnGrenadeSightSoundCode(CustomTbl,Type)
	if self.HasSounds == false or self.HasOnGrenadeSightSounds == false then return end
	if CurTime() > self.NextOnGrenadeSightSoundT then
		Type = Type or VJ_CreateSound
		local ctbl = VJ_PICK(CustomTbl)
		local sdtbl = VJ_PICK(self.SoundTbl_OnGrenadeSight)
		if (math.random(1,self.OnGrenadeSightSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
			if ctbl != false then sdtbl = ctbl end
			self:StopAllCommonSpeechSounds()
			self.NextIdleSoundT_RegularChange = CurTime() + math.random(3,4)
			self.CurrentOnGrenadeSightSound = Type(self,sdtbl,self.OnGrenadeSightSoundLevel,self:VJ_DecideSoundPitch(self.OnGrenadeSightSoundPitch1,self.OnGrenadeSightSoundPitch2))
		end
		self.NextOnGrenadeSightSoundT = CurTime() + math.Rand(self.NextSoundTime_OnGrenadeSight1,self.NextSoundTime_OnGrenadeSight2)
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BecomeEnemyToPlayerSoundCode(CustomTbl,Type)
	if self.HasSounds == false or self.HasBecomeEnemyToPlayerSounds == false then return end
	Type = Type or VJ_CreateSound
	local ctbl = VJ_PICK(CustomTbl)
	local sdtbl = VJ_PICK(self.SoundTbl_BecomeEnemyToPlayer)
	if (math.random(1,self.BecomeEnemyToPlayerChance) == 1 && sdtbl != false) or (ctbl != false) then
		if ctbl != false then sdtbl = ctbl end
		self:StopAllCommonSpeechSounds()
		timer.Simple(0.05,function() if IsValid(self) then VJ_STOPSOUND(self.CurrentPainSound) end end)
		timer.Simple(1.3,function() if IsValid(self) then VJ_STOPSOUND(self.CurrentAlertSound) end end)
		self.NextAlertSoundT = CurTime() + 1
		self.NextInvestigateSoundT = CurTime() + 2
		self.NextIdleSoundT_RegularChange = CurTime() + math.random(2,3)
		self.CurrentBecomeEnemyToPlayerSound = Type(self,sdtbl,self.BecomeEnemyToPlayerSoundLevel,self:VJ_DecideSoundPitch(self.BecomeEnemyToPlayerPitch1,self.BecomeEnemyToPlayerPitch2))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AllyDeathSoundCode(CustomTbl,Type)
	if self.HasSounds == false or self.HasAllyDeathSound == false then return end
	if CurTime() > self.AllyDeathSoundT then
		Type = Type or VJ_CreateSound
		local ctbl = VJ_PICK(CustomTbl)
		local sdtbl = VJ_PICK(self.SoundTbl_AllyDeath)
		if (math.random(1,self.AllyDeathSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
			if ctbl != false then sdtbl = ctbl end
			self:StopAllCommonSpeechSounds()
			self.NextIdleSoundT = self.NextIdleSoundT + 2
			self.CurrentAllyDeathSound = Type(self,sdtbl,self.AllyDeathSoundLevel,self:VJ_DecideSoundPitch(self.AllyDeathSoundPitch1,self.AllyDeathSoundPitch2))
		end
		self.AllyDeathSoundT = CurTime() + math.Rand(self.NextSoundTime_AllyDeath1,self.NextSoundTime_AllyDeath2)
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PainSoundCode(CustomTbl,Type)
	if self.HasSounds == false or self.HasPainSounds == false then return end
	if CurTime() > self.PainSoundT then
		Type = Type or VJ_CreateSound
		local ctbl = VJ_PICK(CustomTbl)
		local sdtbl = VJ_PICK(self.SoundTbl_Pain)
		if (math.random(1,self.PainSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
			if ctbl != false then sdtbl = ctbl end
			VJ_STOPSOUND(self.CurrentIdleSound)
			self.NextIdleSoundT_RegularChange = CurTime() + 1
			self.CurrentPainSound = Type(self,sdtbl,self.PainSoundLevel,self:VJ_DecideSoundPitch(self.PainSoundPitch1,self.PainSoundPitch2))
		end
		self.PainSoundT = CurTime() + math.Rand(self.NextSoundTime_Pain1,self.NextSoundTime_Pain2)
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeathSoundCode(CustomTbl,Type)
	if self.HasSounds == false or self.HasDeathSounds == false then return end
	Type = Type or VJ_CreateSound
	local ctbl = VJ_PICK(CustomTbl)
	local sdtbl = VJ_PICK(self.SoundTbl_Death)
	if (math.random(1,self.DeathSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
		if ctbl != false then sdtbl = ctbl end
		self.CurrentDeathSound = Type(self,sdtbl,self.DeathSoundLevel,self:VJ_DecideSoundPitch(self.DeathSoundPitch1,self.DeathSoundPitch2))
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
			//if VJ_PICK(soundtbl) != false then
			if VJ_PICK(soundtbl) == false then
				VJ_EmitSound(self,self.DefaultSoundTbl_FootStep,self.FootStepSoundLevel,self:VJ_DecideSoundPitch(self.FootStepPitch1,self.FootStepPitch2))
			else
				VJ_EmitSound(self,soundtbl,self.FootStepSoundLevel,self:VJ_DecideSoundPitch(self.FootStepPitch1,self.FootStepPitch2))
			end
			//end
		end
		if self.DisableFootStepSoundTimer == false && self:IsMoving() && CurTime() > self.FootStepT then
			self:CustomOnFootStepSound()
			local soundtbl = self.SoundTbl_FootStep
			if CustomTbl != nil && #CustomTbl != 0 then soundtbl = CustomTbl end
			//if VJ_PICK(soundtbl) != false then
				//VJ_EmitSound(self,soundtbl,self.FootStepSoundLevel,self:VJ_DecideSoundPitch(self.FootStepPitch1,self.FootStepPitch2))
				if self.DisableFootStepOnRun == false && (VJ_HasValue(VJ_RunActivites,self:GetMovementActivity()) or VJ_HasValue(self.CustomRunActivites,self:GetMovementActivity())) then
					self:CustomOnFootStepSound_Run()
					if VJ_PICK(soundtbl) == false then
						VJ_EmitSound(self,self.DefaultSoundTbl_FootStep,self.v,self:VJ_DecideSoundPitch(self.FootStepPitch1,self.FootStepPitch2))
					else
						VJ_EmitSound(self,soundtbl,self.FootStepSoundLevel,self:VJ_DecideSoundPitch(self.FootStepPitch1,self.FootStepPitch2))
					end
					self.FootStepT = CurTime() + self.FootStepTimeRun
				elseif self.DisableFootStepOnWalk == false && (VJ_HasValue(VJ_WalkActivites,self:GetMovementActivity()) or VJ_HasValue(self.CustomWalkActivites,self:GetMovementActivity())) then
					self:CustomOnFootStepSound_Walk()
					if VJ_PICK(soundtbl) == false then
						VJ_EmitSound(self,self.DefaultSoundTbl_FootStep,self.FootStepSoundLevel,self:VJ_DecideSoundPitch(self.FootStepPitch1,self.FootStepPitch2))
					else
						VJ_EmitSound(self,soundtbl,self.FootStepSoundLevel,self:VJ_DecideSoundPitch(self.FootStepPitch1,self.FootStepPitch2))
					end
					self.FootStepT = CurTime() + self.FootStepTimeWalk
				end
			//end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ImpactSoundCode(CustomTbl,Type)
	if self.HasSounds == false or self.HasImpactSounds == false then return end
	Type = Type or VJ_EmitSound
	local ctbl = VJ_PICK(CustomTbl)
	local sdtbl = VJ_PICK(self.SoundTbl_Impact)
	if sdtbl == false then sdtbl = VJ_PICK(self.DefaultSoundTbl_Impact) end -- Default table
	if (math.random(1,self.ImpactSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
		if ctbl != false then sdtbl = ctbl end
		self.CurrentImpactSound = Type(self,sdtbl,self.ImpactSoundLevel,self:VJ_DecideSoundPitch(self.ImpactSoundPitch1,self.ImpactSoundPitch2))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartSoundTrack()
	if self.HasSounds == false or self.HasSoundTrack == false then return end
	self.VJ_IsPlayingSoundTrack = true
	net.Start("vj_music_run")
	net.WriteEntity(self)
	net.WriteTable(self.SoundTbl_SoundTrack)
	net.WriteFloat(self.SoundTrackVolume)
	net.WriteFloat(self.SoundTrackPlaybackRate)
	net.WriteFloat(self.SoundTrackFadeOutTime)
	net.Broadcast()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StopAllCommonSpeechSounds()
	VJ_STOPSOUND(self.CurrentIdleSound)
	VJ_STOPSOUND(self.CurrentIdleDialogueAnswerSound)
	VJ_STOPSOUND(self.CurrentInvestigateSound)
	VJ_STOPSOUND(self.CurrentLostEnemySound)
	VJ_STOPSOUND(self.CurrentFollowPlayerSound)
	VJ_STOPSOUND(self.CurrentUnFollowPlayerSound)
	VJ_STOPSOUND(self.CurrentMoveOutOfPlayersWaySound)
	VJ_STOPSOUND(self.CurrentBecomeEnemyToPlayerSound)
	VJ_STOPSOUND(self.CurrentOnPlayerSightSound)
	VJ_STOPSOUND(self.CurrentDamageByPlayerSound)
	VJ_STOPSOUND(self.CurrentOnGrenadeSightSound)
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
function ENT:RemoveAttackTimers()
	for _,v in ipairs(self.AttackTimers) do
		timer.Remove(v..self:EntIndex())
	end
	for _,v in ipairs(self.AttackTimersCustom) do
		timer.Remove(v..self:EntIndex())
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:WorldShakeOnMoveCode()
	if self.HasWorldShakeOnMove == false or self.MovementType == VJ_MOVETYPE_STATIONARY then return end
	if self:IsOnGround() && self:IsMoving() && CurTime() > self.WorldShakeWalkT then
		self:CustomOnWorldShakeOnMove()
		if self.DisableWorldShakeOnMoveWhileRunning == false && (VJ_HasValue(VJ_RunActivites,self:GetMovementActivity()) or VJ_HasValue(self.CustomRunActivites,self:GetMovementActivity())) then
			self:CustomOnWorldShakeOnMove_Run()
			util.ScreenShake(self:GetPos(),self.WorldShakeOnMoveAmplitude,self.WorldShakeOnMoveFrequency,self.WorldShakeOnMoveDuration,self.WorldShakeOnMoveRadius)
			self.WorldShakeWalkT = CurTime() + self.NextWorldShakeOnRun
		elseif self.DisableWorldShakeOnMoveWhileWalking == false && (VJ_HasValue(VJ_WalkActivites,self:GetMovementActivity()) or VJ_HasValue(self.CustomWalkActivites,self:GetMovementActivity())) then
			self:CustomOnWorldShakeOnMove_Walk()
			util.ScreenShake(self:GetPos(),self.WorldShakeOnMoveAmplitude,self.WorldShakeOnMoveFrequency,self.WorldShakeOnMoveDuration,self.WorldShakeOnMoveRadius)
			self.WorldShakeWalkT = CurTime() + self.NextWorldShakeOnWalk
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:NoCollide_CombineBall()
	for k, v in pairs (ents.GetAll()) do
		if v:GetClass() == "prop_combine_ball" then
			constraint.NoCollide(self, v, 0, 0)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:EntitiesToNoCollideCode(argent)
	if self.HasEntitiesToNoCollide != true or !istable(self.EntitiesToNoCollide) or !IsValid(argent) then return end
	for x=1, #self.EntitiesToNoCollide do
		if self.EntitiesToNoCollide[x] == argent:GetClass() then
			constraint.NoCollide(self,argent,0,0)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetAttackSpread(Weapon,Target)
	//print(Weapon)
	//print(Target)
	//return self.WeaponSpread -- If used, put 3
	return
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ConvarsOnInit()
--<>-- Convars that run on Initialize --<>--
	if GetConVarNumber("vj_npc_usedevcommands") == 1 then self.VJDEBUG_SNPC_ENABLED = true end
	self.NextProcessTime = GetConVarNumber("vj_npc_processtime")
	if GetConVarNumber("vj_npc_sd_nosounds") == 1 then self.HasSounds = false end
	if GetConVarNumber("vj_npc_vjfriendly") == 1 then self.VJFriendly = true end
	if GetConVarNumber("vj_npc_playerfriendly") == 1 then self.PlayerFriendly = true end
	if GetConVarNumber("vj_npc_antlionfriendly") == 1 then self.VJ_NPC_Class[#self.VJ_NPC_Class + 1] = "CLASS_ANTLION" end
	if GetConVarNumber("vj_npc_combinefriendly") == 1 then self.VJ_NPC_Class[#self.VJ_NPC_Class + 1] = "CLASS_COMBINE" end
	if GetConVarNumber("vj_npc_zombiefriendly") == 1 then self.VJ_NPC_Class[#self.VJ_NPC_Class + 1] = "CLASS_ZOMBIE" end
	if GetConVarNumber("vj_npc_noallies") == 1 then
		self.HasAllies = false
		self.PlayerFriendly = false
	end
	if GetConVarNumber("vj_npc_nocorpses") == 1 then self.HasDeathRagdoll = false end
	if GetConVarNumber("vj_npc_itemdrops") == 0 then self.HasItemDropsOnDeath = false end
	if GetConVarNumber("vj_npc_nowandering") == 1 then self.DisableWandering = true end
	if GetConVarNumber("vj_npc_nochasingenemy") == 1 then self.DisableChasingEnemy = true end
	if GetConVarNumber("vj_npc_noflinching") == 1 then self.CanFlinch = false end
	if GetConVarNumber("vj_npc_nomelee") == 1 then self.HasMeleeAttack = false end
	if GetConVarNumber("vj_npc_nobleed") == 1 then self.Bleeds = false end
	if GetConVarNumber("vj_npc_godmodesnpc") == 1 then self.GodMode = true end
	if GetConVarNumber("vj_npc_noreload") == 1 then self.AllowWeaponReloading = false end
	if GetConVarNumber("vj_npc_nobecomeenemytoply") == 1 then self.BecomeEnemyToPlayer = false end
	if GetConVarNumber("vj_npc_nofollowplayer") == 1 then self.FollowPlayer = false end
	if GetConVarNumber("vj_npc_nosnpcchat") == 1 then self.AllowPrintingInChat = false self.FollowPlayerChat = false end
	if GetConVarNumber("vj_npc_noweapon") == 1 then self.DisableWeapons = true end
	//if GetConVarNumber("vj_npc_noforeverammo") == 1 then self.Weapon_UnlimitedAmmo = false end
	if GetConVarNumber("vj_npc_nothrowgrenade") == 1 then self.HasGrenadeAttack = false end
	//if GetConVarNumber("vj_npc_nouseregulator") == 1 then self.DisableUSE_SHOT_REGULATOR = true end
	if GetConVarNumber("vj_npc_noscarednade") == 1 then self.CanDetectGrenades = false end
	if GetConVarNumber("vj_npc_dropweapon") == 0 then self.DropWeaponOnDeath = false end
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
	if GetConVarNumber("vj_npc_sd_ongrenadesight") == 1 then self.HasOnGrenadeSightSounds = false end
	if GetConVarNumber("vj_npc_sd_meleeattack") == 1 then self.HasMeleeAttackSounds = false self.HasExtraMeleeAttackSounds = false end
	if GetConVarNumber("vj_npc_sd_meleeattackmiss") == 1 then self.HasMeleeAttackMissSounds = false end
	if GetConVarNumber("vj_npc_sd_pain") == 1 then self.HasPainSounds = false end
	if GetConVarNumber("vj_npc_sd_death") == 1 then self.HasDeathSounds = false end
	if GetConVarNumber("vj_npc_sd_followplayer") == 1 then self.HasFollowPlayerSounds_Follow = false self.HasFollowPlayerSounds_UnFollow = false end
	if GetConVarNumber("vj_npc_sd_becomenemytoply") == 1 then self.HasBecomeEnemyToPlayerSounds = false end
	if GetConVarNumber("vj_npc_sd_damagebyplayer") == 1 then self.HasDamageByPlayerSounds = false end
	if GetConVarNumber("vj_npc_sd_onplayersight") == 1 then self.HasOnPlayerSightSounds = false end
	if GetConVarNumber("vj_npc_sd_medic") == 1 then self.HasMedicSounds_BeforeHeal = false self.HasMedicSounds_AfterHeal = false self.HasMedicSounds_ReceiveHeal = false end
	if GetConVarNumber("vj_npc_sd_reload") == 1 then self.HasWeaponReloadSounds = false end
	if GetConVarNumber("vj_npc_sd_grenadeattack") == 1 then self.HasGrenadeAttackSounds = false end
	if GetConVarNumber("vj_npc_sd_suppressing") == 1 then self.HasSuppressingSounds = false end
	if GetConVarNumber("vj_npc_sd_callforhelp") == 1 then self.HasCallForHelpSounds = false end
	if GetConVarNumber("vj_npc_sd_onreceiveorder") == 1 then self.HasOnReceiveOrderSounds = false end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ ///// OBSOLETE FUNCTIONS | Recommanded not to use! \\\\\ ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*function ENT:ConvarsOnThink() -- Obsolete! | Causes lag!
end/*
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
	//if self.CombineFriendly == true then if VJ_HasValue(self.NPCTbl_Combine,v:GetClass()) then return end end
	//if self.ZombieFriendly == true then if VJ_HasValue(self.NPCTbl_Zombies,v:GetClass()) then return end end
	//if self.AntlionFriendly == true then if VJ_HasValue(self.NPCTbl_Antlions,v:GetClass()) then return end end
	//if self.PlayerFriendly == true then if VJ_HasValue(self.NPCTbl_Resistance,v:GetClass()) then return end end
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
/*function ENT:VJ_EyeTrace(GetUpNum)
	GetUpNum = GetUpNum or 50
	if IsValid(self:GetEnemy()) && self.Dead == false then
		local tr = util.TraceLine({
			start = self:NearestPoint(self:GetEnemy():GetPos() +self:GetEnemy():OBBCenter() +self:GetUp()*GetUpNum),
			endpos = self:GetEnemy():GetPos() +self:GetEnemy():OBBCenter(),
			filter = self
		})
		//if tr.Entity != NULL then print(tr.Entity) end
		//print(tr.Entity)
		//local testprop = ents.Create("prop_dynamic")
		//testprop:SetModel("models/props_wasteland/dockplank01b.mdl")
		//testprop:SetPos(self:NearestPoint(self:GetEnemy():GetPos() +self:GetEnemy():OBBMaxs() +self:GetUp()*50))
		//testprop:Spawn()
		//if tr.HitWorld == false && tr.Entity != NULL && tr.Entity:GetClass() != "prop_physics" then
		//print("true") return true else
		//print("false") return false end
		//print("false") return false
		if tr.HitWorld == true then return false end
		if tr.Entity != NULL then
			return tr
		else
			return false
		end
	 end
	 return false
end*/
---------------------------------------------------------------------------------------------------------------------------------------------
/*function ENT:ThemeMusicCode()
if GetConVarNumber("vj_npc_sd_nosounds") == 0 then
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
/*--------------------------------------------------
	=============== Human SNPC Base ===============
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
	INFO: Used to make human SNPCs
--------------------------------------------------*/