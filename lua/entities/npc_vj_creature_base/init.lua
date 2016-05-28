if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')
include('schedules.lua')
/*--------------------------------------------------
	=============== Creature SNPC Base ===============
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used as a base for creature SNPCs.
--------------------------------------------------*/
AccessorFunc(ENT,"m_iClass","NPCClass",FORCE_NUMBER)
AccessorFunc(ENT,"m_fMaxYawSpeed","MaxYawSpeed",FORCE_NUMBER)
ENT.IsVJBaseSNPC = true -- Is it a VJ Base SNPC?
ENT.IsVJBaseSNPC_Creature = true -- Is it a VJ Base creature?

	-- General ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Model = {} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = GetConVarNumber("vj_snpchealth")
ENT.HullType = HULL_HUMAN
ENT.HasHull = true -- Set to false to disable HULL
ENT.HullSizeNormal = true -- set to false to cancel out the self:SetHullSizeNormal()
ENT.HasSetSolid = true -- set to false to disable SetSolid
ENT.SightDistance = 10000 -- How far it can see
ENT.SightAngle = 80 -- The sight angle | Example: 180 would make the it see all around it | Measured in degrees and then converted to radians
ENT.TurningSpeed = 20 -- How fast it can turn
ENT.VJ_IsHugeMonster = false -- Is this a huge monster?
	-- ====== Movement Code ====== --
	-- Types: VJ_MOVETYPE_GROUND | VJ_MOVETYPE_AERIAL | VJ_MOVETYPE_AQUATIC | VJ_MOVETYPE_STATIONARY | VJ_MOVETYPE_PHYSICS
ENT.MovementType = VJ_MOVETYPE_GROUND -- How does the SNPC move?
ENT.CanTurnWhileStationary = true -- If set to true, the SNPC will be able to turn while it's a stationary SNPC
	-- Blood & Damages ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.GodMode = false -- Immune to everything
ENT.Bleeds = true -- Does the SNPC bleed? (Blood decal, particle and etc.)
ENT.HasBloodParticle = true -- Does it spawn a particle when damaged?
ENT.HasBloodPool = true -- Does it have a blood pool?
ENT.HasBloodDecal = true -- Does it spawn a decal when damaged?
ENT.BloodParticle = {"blood_impact_yellow_01"} -- Particle that the SNPC spawns when it's damaged
ENT.BloodPoolParticle = {} -- Leave empty for the base to decide which pool blood it should use
ENT.BloodDecal = {"YellowBlood"} -- Leave blank for none | Commonly used: Red = Blood, Yellow Blood = YellowBlood
ENT.BloodDecalRate = 1000 -- The bigger the number, the more chance it has of spawning the decal | Remember to use 5 or 10 when using big decals (Ex: Antlion Splat)
ENT.BloodDecalDistance = 300 -- How far the decal can spawn
ENT.GetDamageFromIsHugeMonster = false -- Should it get damaged no matter what by SNPCs that are tagged as VJ_IsHugeMonster?
ENT.AllowIgnition = true -- Can this SNPC be set on fire?
ENT.Immune_CombineBall = false -- Immune to Combine Ball
ENT.Immune_AcidPoisonRadiation = false -- Immune to Acid, Poison and Radiation
ENT.Immune_Bullet = false -- Immune to Bullets
ENT.Immune_Blast = false -- Immune to Explosives
ENT.Immune_Electricity = false -- Immune to Electrical
ENT.Immune_Freeze = false -- Immune to Freezing
ENT.Immune_Physics = false -- Immune to Physics
ENT.ImmuneDamagesTable = {} -- You can set Specific types of damages for the SNPC to be immune to
ENT.RunAwayOnUnknownDamage = true -- Should run away on damage
ENT.NextRunAwayOnDamageTime = 5 -- Until next run after being shot when not alerted
ENT.CallForBackUpOnDamage = true -- Should the SNPC call for help when damaged? (Only happens if the SNPC hasn't seen a enemy)
ENT.CallForBackUpOnDamageDistance = 800 -- How far away the SNPC's call for help goes | Counted in World Units
ENT.CallForBackUpOnDamageUseCertainAmount = true -- Should the SNPC only call certain amount of people?
ENT.CallForBackUpOnDamageUseCertainAmountNumber = 3 -- How many people should it call if certain amount is enabled?
ENT.DisableCallForBackUpOnDamageAnimation = true -- Disables the animation when the CallForBackUpOnDamage function is called
ENT.CallForBackUpOnDamageAnimation = {ACT_SIGNAL_HALT} -- Animation used if the SNPC does the CallForBackUpOnDamage function
ENT.CallForBackUpOnDamageAnimationTime = 2 -- How much time until it can use activities
ENT.CallForBackUpOnDamageUseSCHED = true -- Should it use a Schedule when CallForBackUpOnDamage function is called?
ENT.CallForBackUpOnDamageUseSCHEDID = SCHED_RUN_FROM_ENEMY -- The schedule ID for CallForBackUpOnDamageUseSCHED
ENT.NextBackUpOnDamageTime1 = 9 -- Next time it use the CallForBackUpOnDamage function | The first # in math.random
ENT.NextBackUpOnDamageTime2 = 11 -- Next time it use the CallForBackUpOnDamage function | The second # in math.random
ENT.HasDamageByPlayer = true -- Should the SNPC do something when it's hit by a player? Example: Play a sound or animation
ENT.DamageByPlayerDispositionLevel = 0 -- 0 = Run it every time | 1 = Run it only when friendly to player | 2 = Run it only when enemy to player
ENT.DamageByPlayerNextTime1 = 2 -- How much time should it pass until it runs the code again? | First number in math.random
ENT.DamageByPlayerNextTime2 = 2 -- How much time should it pass until it runs the code again? | Second number in math.random
	-- ====== Flinching Code ====== --
ENT.Flinches = 0 -- 0 = No Flinch | 1 = Flinches at any damage | 2 = Flinches only from certain damages
ENT.FlinchCustomDMGs = {DMG_BLAST} -- The types of damages it will flinch from if self.Flinches is set to custom
ENT.FlinchingChance = 16 -- chance of it flinching from 1 to x | 1 will make it always flinch
ENT.NextFlinch = 0.6 -- How much time until it can attack, move and flinch again
ENT.FlinchUseACT = false -- false = SCHED_ | true = ACT_
ENT.FlinchingSchedules = {SCHED_FLINCH_PHYSICS} -- If self.FlinchUseACT is false the it uses this | Common: SCHED_BIG_FLINCH, SCHED_SMALL_FLINCH, SCHED_FLINCH_PHYSICS
ENT.AnimTbl_Flinch = {ACT_BIG_FLINCH} -- Used to make the SNPC play an ACT_ when flinching instead of SCHED_ | self.FlinchUseACT needs to be true!
ENT.HasHitGroupFlinching = false -- It will flinch when hit in certain hitgroups | It can also have certain animations to play in certain hitgroups
ENT.DefaultFlinchingWhenNoHitGroup = true -- If it uses hitgroup flinching, should it do the regular flinch if it doesn't hit any of the specified hitgroups?
ENT.FlinchHitGroupTable = {/* EXAMPLES: {HitGroup = {1}, IsSchedule = true, Animation = {SCHED_BIG_FLINCH}},{HitGroup = {4}, IsSchedule = false, Animation = {ACT_FLINCH_STOMACH}} */} -- "Animation" should be an "SCHED_" if IsSchedule is true, if not then "ACT_" | If it doesn't get hit in any of this hitgroups, it will use the regular schedule or activity (Depending on what self.FlinchUseACT is set on)
	-- Relationships ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasAllies = true -- Put to false if you want it not to have any allies
ENT.VJ_NPC_Class = {} -- NPCs with the same class will be friendly to each other | Combine: CLASS_COMBINE, Zombie: CLASS_ZOMBIE, Antlions = CLASS_ANTLION
ENT.VJ_FriendlyNPCsSingle = {}
ENT.VJ_FriendlyNPCsGroup = {}
ENT.NextChaseTimeOnSetEnemy = 0.1 -- Time until it starts chasing, after seeing an enemy
ENT.PlayerFriendly = false -- Makes the SNPC friendly to the player and HL2 Resistance
ENT.FriendsWithAllPlayerAllies = false -- Should this SNPC be friends with all other player allies that are running on VJ Base?
ENT.NextEntityCheckTime = 0.05 -- Time until it runs the NPC check
ENT.NextHardEntityCheck1 = 80 -- Next time it will do hard entity check | The first # in math.random
ENT.NextHardEntityCheck2 = 100 -- Next time it will do hard entity check | The second # in math.random
ENT.NextFindEnemyTime = 1 -- Time until it runs FindEnemy again
ENT.BecomeEnemyToPlayer = false -- Should the friendly SNPC become enemy towards the player if it's damaged by a player?
ENT.BecomeEnemyToPlayerLevel = 2 -- How many times does the player have to hit the SNPC for it to become enemy?
ENT.BecomeEnemyToPlayerSetPlayerFriendlyFalse = true -- Should it set PlayerFriendly to false?
ENT.HasOnPlayerSight = false -- Should do something when it sees the enemy? Example: Play a sound
ENT.OnPlayerSightDistance = 200 -- How close should the player be until it runs the code?
ENT.OnPlayerSightDispositionLevel = 0 -- 0 = Run it every time | 1 = Run it only when friendly to player | 2 = Run it only when enemy to player
ENT.OnPlayerSightOnlyOnce = true -- Should it only run the code once?
ENT.OnPlayerSightNextTime1 = 15 -- How much time should it pass until it runs the code again? | First number in math.random
ENT.OnPlayerSightNextTime2 = 20 -- How much time should it pass until it runs the code again? | Second number in math.random
ENT.MoveOutOfFriendlyPlayersWay = true -- Should the SNPC move out of the way when a friendly player comes close to it?
ENT.NextMoveOutOfFriendlyPlayersWayTime = 1 -- How much time until it can moves out of the player's way?
ENT.MoveOutOfFriendlyPlayersWaySchedules = {SCHED_MOVE_AWAY} -- Schedules it will play when the SNPC attempts to get out of the player's way
ENT.CallForHelp = true -- Does the SNPC call for help?
ENT.CallForHelpDistance = 2000 -- -- How far away the SNPC's call for help goes | Counted in World Units
ENT.NextCallForHelpTime = 4 -- Time until it calls for help again
ENT.HasCallForHelpAnimation = true -- if true, it will play the call for help animation
ENT.AnimTbl_CallForHelp = {} -- Call For Help Animations
ENT.CallForHelpAnimationDelay = 0.1 -- It will wait certain amount of time before playing the animation
ENT.CallForHelpAnimationPlayBackRate = 0.5 -- How fast should the animation play? | Currently only for gestures!
ENT.CallForHelpStopAnimations = true -- Should it stop attacks for a certain amount of time?
ENT.CallForHelpStopAnimationsTime = 1.5 -- How long should it stop attacks?
ENT.CallForHelpAnimationFaceEnemy = true -- Should it face the enemy when playing the animation?
ENT.NextCallForHelpAnimationTime = 30 -- How much time until it can play the animation again?
ENT.DisableMakingSelfEnemyToNPCs = false -- Disables the "AddEntityRelationship" that runs in think
	-- ====== Medic Code ====== --
ENT.IsMedicSNPC = false -- Is this SNPC a medic? Does it heal other friendly friendly SNPCs, and players(If friendly)
ENT.AnimTbl_Medic_GiveHealth = {ACT_SPECIAL_ATTACK1} -- Animations is plays when giving health to an ally
ENT.Medic_CheckDistance = 600 -- How far does it check for allies that are hurt? | World units
ENT.Medic_HealDistance = 100 -- How close does it have to be until it stops moving and heals its ally?
ENT.Medic_HealthAmount = 25 -- How health does it give?
ENT.Medic_NextHealTime1 = 10 -- How much time until it can give health to an ally again | First number in the math.random
ENT.Medic_NextHealTime2 = 15 -- How much time until it can give health to an ally again | Second number in the math.random
ENT.Medic_SpawnPropOnHeal = true -- Should it spawn a prop, such as small health vial at a attachment when healing an ally?
ENT.Medic_SpawnPropOnHealModel = "models/healthvial.mdl" -- The model that it spawns
ENT.Medic_SpawnPropOnHealAttachment = "anim_attachment_LH" -- The attachment it spawns on
	-- Death ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasDeathRagdoll = true -- If set to false, it will not spawn the regular ragdoll of the SNPC
ENT.DeathEntityType = "prop_ragdoll" -- Type entity the death ragdoll uses
ENT.CorpseAlwaysCollide = false -- Should the corpse always collide?
ENT.HasDeathBodyGroup = true -- Set to true if you want to put a bodygroup when it dies
ENT.CustomBodyGroup = false -- Set true if you want to set custom bodygroup
ENT.DeathBodyGroupA = 0 -- Used for Custom Bodygroup | Group = A
ENT.DeathBodyGroupB = 0 -- Used for Custom Bodygroup | Group = B
ENT.DeathSkin = 0 -- Used to override the death skin | 0 = Use the skin that the SNPC had before it died
ENT.FadeCorpse = false -- Fades the ragdoll on death
ENT.FadeCorpseTime = 10 -- How much time until the ragdoll fades | Unit = Seconds
ENT.FadeCorpseType = "FadeAndRemove" -- The type of "Fire" is used to fade the corpse, can be used to make prop_physics fade since FadeAndRemove doesn't work on them
ENT.HasDeathAnimation = false -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {} -- Death Animations
ENT.DeathAnimationTime = 1 -- Time until the SNPC spawns its corpse and gets removed
ENT.DeathAnimationChance = 1 -- Put 1 if you want it to play the animation all the time
ENT.DisableDeathAnimationSCHED = false -- If set to true, it will disable the setschedule code
ENT.WaitBeforeDeathTime = 0 -- Time until the SNPC spawns its corpse and gets removed
ENT.SetCorpseOnFire = false -- Sets the corpse on fire when the SNPC dies
ENT.HasDeathNotice = false -- Set to true if you want it show a message after it dies
ENT.DeathNoticePosition = HUD_PRINTCENTER -- Were you want the message to show. Examples: HUD_PRINTCENTER, HUD_PRINTCONSOLE, HUD_PRINTTALK
ENT.DeathNoticeWriting = "Example: Spider Queen Has Been Defeated!" -- Message that will appear
ENT.UsesBoneAngle = true -- This can be used to stop the corpse glitching or flying on death
ENT.UsesDamageForceOnDeath = true -- Disables the damage force on death | Useful for SNPCs with Death Animations
ENT.IgnoreCBDeath = false -- Ignores the combine ball death | useful for SNPCs that have gibs on death, example: Boomer
ENT.HasItemDropsOnDeath = true -- Should it drop items on death?
ENT.ItemDropChance = 6 -- If set to 1, it will always drop it
ENT.BringFriendsOnDeath = true -- Should the SNPC's friends come to its position before it dies?
ENT.BringFriendsOnDeathDistance = 800 -- How far away does the signal go? | Counted in World Units
ENT.BringFriendsOnDeathUseCertainAmount = true -- Should the SNPC only call certain amount of people?
ENT.BringFriendsOnDeathUseCertainAmountNumber = 3 -- How many people should it call if certain amount is enabled?
	-- Melee Attack ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.MeleeAttackDamage = GetConVarNumber("vj_snpcdamage")
ENT.MeleeAttackDamageType = DMG_SLASH -- Type of Damage
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- Melee Attack Animations
ENT.MeleeAttackAnimationDelay = 0 -- It will wait certain amount of time before playing the animation
ENT.MeleeAttackAnimationFaceEnemy = true -- Should it face the enemy while playing the melee attack animation?
ENT.MeleeAttackAnimationDecreaseLengthAmount = 0.2 -- This will decrease the time until starts chasing again. Use it to fix animation pauses until it chases the enemy.
ENT.MeleeAttackDistance = 60 -- How close does it have to be until it attacks?
ENT.MeleeAttackAngleRadius = 100 -- What is the attack angle radius? | 100 = In front of the SNPC | 180 = All around the SNPC
ENT.MeleeAttackDamageDistance = 80 -- How far does the damage go?
ENT.MeleeAttackDamageAngleRadius = 100 -- What is the damage angle radius? | 100 = In front of the SNPC | 180 = All around the SNPC
	-- To use event-based attacks, set this to false:
ENT.TimeUntilMeleeAttackDamage = 0.6 -- This counted in seconds | This calculates the time until it hits something
ENT.NextMeleeAttackTime = 0 -- How much time until it can use a melee attack?
ENT.NextMeleeAttackTime_DoRand = false -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer
ENT.NextAnyAttackTime_Melee = 0.5 -- How much time until it can use a attack again? | Counted in Seconds
ENT.NextAnyAttackTime_Melee_DoRand = false -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer
ENT.MeleeAttackReps = 1 -- How many times does it run the melee attack code?
ENT.MeleeAttackExtraTimers = {/* Ex: 1,1.4 */} -- Extra melee attack timers | it will run the damage code after the given amount of seconds
ENT.StopMeleeAttackAfterFirstHit = false -- Should it stop the melee attack from running rest of timers when it hits an enemy?
ENT.HasMeleeAttackKnockBack = false -- If true, it will cause a knockback to its enemy
ENT.MeleeAttackKnockBack_Forward1 = 100 -- How far it will push you forward | First in math.random
ENT.MeleeAttackKnockBack_Forward2 = 100 -- How far it will push you forward | Second in math.random
ENT.MeleeAttackKnockBack_Up1 = 10 -- How far it will push you up | First in math.random
ENT.MeleeAttackKnockBack_Up2 = 10 -- How far it will push you up | Second in math.random
ENT.MeleeAttackKnockBack_Right1 = 0 -- How far it will push you right | First in math.random
ENT.MeleeAttackKnockBack_Right2 = 0 -- How far it will push you right | Second in math.random
ENT.MeleeAttackWorldShakeOnMiss = false -- Should it shake the world when it misses during melee attack?
ENT.MeleeAttackWorldShakeOnMissAmplitude = 16 -- How much the screen will shake | From 1 to 16, 1 = really low 16 = really high
ENT.MeleeAttackWorldShakeOnMissRadius = 2000 -- How far the screen shake goes, in world units
ENT.MeleeAttackWorldShakeOnMissDuration = 1 -- How long the screen shake will last, in seconds
ENT.MeleeAttackWorldShakeOnMissFrequency = 100 -- Just leave it to 100
ENT.MeleeAttackSetEnemyOnFire = false -- Sets the enemy on fire when it does the melee attack
ENT.MeleeAttackSetEnemyOnFireTime = 6 -- For how long should the enemy be set on fire || Counted in seconds
ENT.HasMeleeAttackDSPSound = false -- Applies a DSP (Digital Signal Processor) to the player
ENT.MeleeAttackDSPSoundType = 34 -- What type? Search online for the types
ENT.SlowPlayerOnMeleeAttack = false -- If true, then the player will slow down
ENT.SlowPlayerOnMeleeAttack_WalkSpeed = 100 -- Walking Speed when Slow Player is on
ENT.SlowPlayerOnMeleeAttack_RunSpeed = 100 -- Running Speed when Slow Player is on
ENT.SlowPlayerOnMeleeAttackTime = 5 -- How much time until player's Speed resets
ENT.MeleeAttackBleedEnemy = false -- Should the enemy bleed when attacked by melee?
ENT.MeleeAttackBleedEnemyChance = 4 -- How much chance there is that the enemy will bleed? | 1 = always
ENT.MeleeAttackBleedEnemyDamage = 1 -- How much damage will the enemy get on every rep?
ENT.MeleeAttackBleedEnemyTime = 1 -- How much time until the next rep?
ENT.MeleeAttackBleedEnemyReps = 4 -- How many reps?
ENT.DisableMeleeAttackAnimation = false -- if true, it will disable the animation code
ENT.DisableDefaultMeleeAttackDamageCode = false -- Disables the default melee attack damage code
ENT.DisableDefaultMeleeAttackCode = false -- When set to true, it will compeletly dsiable the melee attack code
	-- Range Attack ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.NoChaseWhenAbleToRangeAttack = false -- When set to true, the SNPC will not chase the enemy when its distance is good for range attack, instead it will keep standing there and range attacking
ENT.HasRangeAttack = false -- Should the SNPC have a range attack?
ENT.RangeAttackEntityToSpawn = "grenade_spit" -- The entity that is spawned when range attacking
ENT.AnimTbl_RangeAttack = {ACT_RANGE_ATTACK1} -- Range Attack Animations
ENT.RangeAttackAnimationDelay = 0 -- It will wait certain amount of time before playing the animation
ENT.RangeAttackAnimationFaceEnemy = true -- Should it face the enemy while playing the range attack animation?
ENT.RangeAttackAnimationDecreaseLengthAmount = 0.2 -- This will decrease the time until starts chasing again. Use it to fix animation pauses until it chases the enemy.
ENT.RangeDistance = 2000 -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 800 -- How close does it have to be until it uses melee?
ENT.RangeUseAttachmentForPos = false -- Should the projectile spawn on a attachment?
ENT.RangeUseAttachmentForPosID = "muzzle" -- The attachment used on the range attack if RangeUseAttachmentForPos is set to true
ENT.RangeUpPos = 20 -- Spawning Position for range attack | + = up, - = down
ENT.TimeUntilRangeAttackProjectileRelease = 1.5 -- How much time until the projectile code is ran?
ENT.NextRangeAttackTime = 3 -- How much time until it can use a range attack?
ENT.NextRangeAttackTime_DoRand = false -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer
ENT.NextAnyAttackTime_Range = 0.1 -- How much time until it can use a attack again? | Counted in Seconds
ENT.NextAnyAttackTime_Range_DoRand = false -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer
ENT.RangeAttackReps = 1 -- How many times does it run the projectile code?
ENT.RangeAttackExtraTimers = {/* Ex: 1,1.4 */} -- Extra range attack timers | it will run the projectile code after the given amount of seconds
ENT.DisableDefaultRangeAttackCode = false -- When true, it won't spawn the range attack entity, allowing you to make your own
ENT.DisableRangeAttackAnimation = false -- if true, it will disable the animation code
	-- Leap Attack ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasLeapAttack = false -- Should the SNPC have a leap attack?
ENT.AnimTbl_LeapAttack = {ACT_SPECIAL_ATTACK1} -- Melee Attack Animations
ENT.LeapAttackAnimationDelay = 0 -- It will wait certain amount of time before playing the animation
ENT.LeapAttackAnimationFaceEnemy = true -- Should it face the enemy while playing the leap attack animation?
ENT.LeapAttackAnimationDecreaseLengthAmount = 0.2 -- This will decrease the time until starts chasing again. Use it to fix animation pauses until it chases the enemy.
ENT.LeapDistance = 5000 -- The distance of the leap, for example if it is set to 500, when the SNPC is 500 Unit away, it will jump
ENT.LeapToMeleeDistance = 300 -- How close does it have to be until it uses melee?
ENT.TimeUntilLeapAttackDamage = 10 -- How much time until it runs the leap damage code?
ENT.NextLeapAttackTime = 3 -- How much time until it can use a leap attack?
ENT.NextLeapAttackTime_DoRand = false -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer
ENT.NextAnyAttackTime_Leap = 1 -- How much time until it can use a attack again? | Counted in Seconds
ENT.NextAnyAttackTime_Leap_DoRand = false -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer
ENT.LeapAttackReps = 1 -- How many times does it run the leap attack code?
ENT.LeapAttackExtraTimers = {/* Ex: 1,1.4 */} -- Extra leap attack timers | it will run the damage code after the given amount of seconds
ENT.StopLeapAttackAfterFirstHit = true -- Should it stop the leap attack from running rest of timers when it hits an enemy?
ENT.LeapAttackUseCustomVelocity = false -- Should it disable the default velocity system?
ENT.LeapAttackVelocityForward = 2000 -- How much forward force should it apply?
ENT.LeapAttackVelocityUp = 200 -- How much upward force should it apply?
ENT.LeapAttackVelocityRight = 0 -- How much right force should it apply?
ENT.LeapAttackDamage = GetConVarNumber("vj_snpcleapdamage")
ENT.LeapAttackDamageDistance = 100 -- How far does the damage go?
ENT.LeapAttackDamageType = DMG_SLASH -- Type of Damage
ENT.DisableLeapAttackAnimation = false -- if true, it will disable the animation code
	-- Miscellaneous ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.UseSphereForFindEnemy = false -- Should the SNPC use FindInSphere for find enemy?
ENT.DisableTakeDamageFindEnemy = false -- Disable the SNPC finding the enemy when being damaged
ENT.DisableTouchFindEnemy = false -- Disable the SNPC finding the enemy when being touched
ENT.LastSeenEnemyTimeUntilReset = 15 -- Time until it resets its enemy if its current enemy is not visible
ENT.IdleSchedule_Wander = {SCHED_IDLE_WANDER} -- Animation played when the SNPC is idle, when called to wander
ENT.AnimTbl_IdleStand = {} -- Leave empty to use schedule | Only works when AI is enabled
ENT.ChaseSchedule = {SCHED_CHASE_ENEMY} -- Animation played when the SNPC is trying to chase the enemy
ENT.ConstantlyFaceEnemy = false -- Should it face the enemy constantly?
ENT.ConstantlyFaceEnemy_IfVisible = true -- Should it only face the enemy if it's visible?
ENT.ConstantlyFaceEnemy_IfAttacking = false -- Should it face the enemy when attacking?
ENT.ConstantlyFaceEnemy_Postures = "Both" -- "Both" = Moving or standing | "Moving" = Only when moving | "Standing" = Only when standing
ENT.ConstantlyFaceEnemyDistance = 2500 -- How close does it have to be until it starts to face the enemy?
ENT.HasEntitiesToNoCollide = true -- If set to false, it won't run the EntitiesToNoCollide code
ENT.EntitiesToNoCollide = {} -- Entities to not collide with when HasEntitiesToNoCollide is set to true
ENT.DisableWandering = false -- Disables wandering when the SNPC is idle
ENT.DisableChasingEnemy = false -- Disables the SNPC chasing the enemy
ENT.DisableFindEnemy = false -- Disables FindEnemy code, friendly code still works though
ENT.DisableSelectSchedule = false -- Disables Schedule code, Custom Schedule can still work
ENT.DisableCapabilities = false -- If enabled, all of the Capabilities will be disabled, allowing you to add your own
ENT.CustomWalkActivites = {} -- Custom walk activities
ENT.CustomRunActivites = {} -- Custom run activities
ENT.HasWorldShakeOnMove = false -- Should the world shake when it's moving?
ENT.NextWorldShakeOnRun = 0.5 -- How much time until the world shakes while it's running
ENT.NextWorldShakeOnWalk = 1 -- How much time until the world shakes while it's walking
ENT.WorldShakeOnMoveAmplitude = 10 -- How much the screen will shake | From 1 to 16, 1 = really low 16 = really high
ENT.WorldShakeOnMoveRadius = 1000 -- How far the screen shake goes, in world units
ENT.WorldShakeOnMoveDuration = 0.4 -- How long the screen shake will last, in seconds
ENT.WorldShakeOnMoveFrequency = 100 -- Just leave it to 100
ENT.DisableWorldShakeOnMoveWhileRunning = false -- It will not shake the world when it's running
ENT.DisableWorldShakeOnMoveWhileWalking = false -- It will not shake the world when it's walking
ENT.PushProps = true -- Should it push props when trying to move?
ENT.AttackProps = true -- Should it attack props when trying to move?
ENT.FollowPlayer = false -- Should the SNPC follow the player when the player presses a certain key?
ENT.FollowPlayerChat = true -- Should the SNPCs say things like "They stopped following you"
ENT.FollowPlayerKey = "Use" -- The key that the player presses to make the SNPC follow them
ENT.FollowPlayerCloseDistance = 150 -- If the SNPC is that close to the player then stand still until the player goes farther away
ENT.NextFollowPlayerTime = 1 -- Time until it runs to the player again
ENT.BringFriendsToMeSCHED1 = SCHED_FORCED_GO -- The Schedule that its friends play when BringAlliesToMe code is ran | First in math.random
ENT.BringFriendsToMeSCHED2 = SCHED_FORCED_GO -- The Schedule that its friends play when BringAlliesToMe code is ran | Second in math.random
	-- Sounds ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasSounds = true -- Put to false to disable ALL sounds
ENT.HasImpactSounds = true -- If set to false, it won't play the impact sounds
ENT.HasAlertSounds = true -- If set to false, it won't play the alert sounds
ENT.HasMeleeAttackSounds = true -- If set to false, it won't play the melee attack sound
ENT.WaitTime_BeforeMeleeAttackSound = 0 -- Time until it starts playing the sound
ENT.HasExtraMeleeAttackSounds = false -- Set to true to use the extra melee attack sounds
ENT.HasMeleeAttackMissSounds = true -- If set to false, it won't play the melee attack miss sound
ENT.HasLeapAttackSound = true -- If set to false, it won't play the leaping sounds
ENT.HasRangeAttackSound = true -- If set to false, it won't play the range attack sounds
ENT.HasIdleSounds = true -- If set to false, it won't play the idle sounds
ENT.PlayNothingWhenCombatIdleSoundTableEmpty = false -- if set to true, it will not play the regular idle sound table if the combat idle sound table is empty
ENT.HasPainSounds = true -- If set to false, it won't play the pain sounds
ENT.HasDeathSounds = true -- If set to false, it won't play the death sounds
ENT.HasBecomeEnemyToPlayerSounds = true -- If set to false, it won't play the become enemy to player sounds
ENT.HasFollowPlayerSounds_Follow = true -- If set to false, it won't play the follow player sounds
ENT.HasFollowPlayerSounds_UnFollow = true -- If set to false, it won't play the unfollow player sounds
ENT.HasMedicSounds_BeforeHeal = true -- If set to false, it won't play any sounds before it gives a med kit to an ally
ENT.HasMedicSounds_AfterHeal = true -- If set to false, it won't play any sounds after it gives a med kit to an ally
ENT.HasOnPlayerSightSounds = true -- If set to false, it won't play the saw player sounds
ENT.HasDamageByPlayerSounds = true -- If set to false, it won't play the stupid player sounds
ENT.HasCallForHelpSounds = true -- If set to false, it won't play any sounds when it calls for help
ENT.HasOnReceiveOrderSounds = true -- If set to false, it won't play any sound when it receives an order from an ally
ENT.HasFootStepSound = true -- Should the SNPC make a footstep sound when it's moving?
ENT.FootStepTimeRun = 0.5 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 1 -- Next foot step sound when it is walking
ENT.DisableFootStepSoundTimer = false -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
ENT.HasBreathSound = true -- Should it make a breathing sound?
ENT.HasSlowPlayerSound = true -- Does it have a sound when it slows down the player?
ENT.DisableFootStepOnRun = false -- It will not play the footstep sound when running
ENT.DisableFootStepOnWalk = false -- It will not play the footstep sound when walking
ENT.HasSoundTrack = false -- Does the SNPC have a sound track?
ENT.SoundTrackFadeOutTime = 2  -- Put to 0 if you want it to stop instantly
ENT.PlayAlertSoundOnlyOnce = false -- After it plays it once, it will never play it again
ENT.ContinuePlayingIdleSoundsOnAttacks = false -- It won't stop the idle sounds when the it performs a attack
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {}
ENT.SoundTbl_Breath = {}
ENT.SoundTbl_Idle = {}
ENT.SoundTbl_CombatIdle = {}
ENT.SoundTbl_OnReceiveOrder = {}
ENT.SoundTbl_FollowPlayer = {}
ENT.SoundTbl_UnFollowPlayer = {}
ENT.SoundTbl_MedicBeforeHeal = {}
ENT.SoundTbl_MedicAfterHeal = {}
ENT.SoundTbl_OnPlayerSight = {}
ENT.SoundTbl_Alert = {}
ENT.SoundTbl_CallForHelp = {}
ENT.SoundTbl_BecomeEnemyToPlayer = {}
ENT.SoundTbl_BeforeMeleeAttack = {}
ENT.SoundTbl_MeleeAttack = {}
ENT.SoundTbl_MeleeAttackExtra = {}
ENT.SoundTbl_MeleeAttackMiss = {}
ENT.SoundTbl_RangeAttack = {}
ENT.SoundTbl_LeapAttack = {}
ENT.SoundTbl_Pain = {}
ENT.SoundTbl_Impact = {}
ENT.SoundTbl_DamageByPlayer = {}
ENT.SoundTbl_Death = {}
ENT.SoundTbl_SoundTrack = {}

ENT.DefaultSoundTbl_MedicAfterHeal = {"items/smallmedkit1.wav"}
ENT.DefaultSoundTbl_MeleeAttackExtra = {"npc/zombie/claw_strike1.wav","npc/zombie/claw_strike2.wav","npc/zombie/claw_strike3.wav"}
ENT.DefaultSoundTbl_Impact = {"vj_flesh/alien_flesh1.wav"}

ENT.SlowPly = Sound("vj_player/heartbeat.wav")
	-- ====== Sound Chances ====== --
-- Higher number = less chance of playing | 1 = Always play
-- This are all counted in seconds
ENT.IdleSoundChance = 2
ENT.CombatIdleSoundChance = 1
ENT.OnReceiveOrderSoundChance = 1
ENT.FollowPlayerSoundChance = 1
ENT.UnFollowPlayerSoundChance = 1
ENT.MedicBeforeHealSoundChance = 1
ENT.MedicAfterHealSoundChance = 1
ENT.OnPlayerSightSoundChance = 1
ENT.AlertSoundChance = 1
ENT.CallForHelpSoundChance = 1
ENT.BecomeEnemyToPlayerChance = 1
ENT.BeforeMeleeAttackSoundChance = 1
ENT.MeleeAttackSoundChance = 1
ENT.ExtraMeleeSoundChance = 1
ENT.MeleeAttackMissSoundChance = 1
ENT.SlowPlySoundFadeTime = 1
ENT.RangeAttackSoundChance = 1
ENT.LeapAttackSoundChance = 1
ENT.PainSoundChance = 1
ENT.ImpactSoundChance = 1
ENT.DamageByPlayerSoundChance = 1
ENT.DeathSoundChance = 1
ENT.SoundTrackChance = 1
	-- ====== Sound Timer ====== --
-- Randomized time between the two variables, x amount of time has to pass for the sound to play again
-- This are all counted in seconds
ENT.NextSoundTime_Breath1 = 1
ENT.NextSoundTime_Breath2 = 1
ENT.NextSoundTime_Idle1 = 4
ENT.NextSoundTime_Idle2 = 11
ENT.NextSoundTime_Alert1 = 2
ENT.NextSoundTime_Alert2 = 3
ENT.NextSoundTime_Pain1 = 2
ENT.NextSoundTime_Pain2 = 2
ENT.NextSoundTime_DamageByPlayer1 = 2
ENT.NextSoundTime_DamageByPlayer2 = 2.3
	-- ====== Sound Levels ====== --
-- EmitSound is from 0 to 511 | CreateSound is from 0 to 180
-- More Information: https://developer.valvesoftware.com/wiki/Soundscripts#SoundLevel_Flags
ENT.FootStepSoundLevel = 70
ENT.BreathSoundLevel = 60
ENT.IdleSoundLevel = 75
ENT.CombatIdleSoundLevel = 80
ENT.OnReceiveOrderSoundLevel = 80
ENT.FollowPlayerSoundLevel = 75
ENT.UnFollowPlayerSoundLevel = 75
ENT.BeforeHealSoundLevel = 75
ENT.AfterHealSoundLevel = 75
ENT.OnPlayerSightSoundLevel = 75
ENT.AlertSoundLevel = 80
ENT.CallForHelpSoundLevel = 80
ENT.BecomeEnemyToPlayerSoundLevel = 75
ENT.BeforeMeleeAttackSoundLevel = 75
ENT.MeleeAttackSoundLevel = 75
ENT.ExtraMeleeAttackSoundLevel = 75
ENT.MeleeAttackMissSoundLevel = 75
ENT.RangeAttackSoundLevel = 75
ENT.LeapAttackSoundLevel = 75
ENT.PainSoundLevel = 75
ENT.ImpactSoundLevel = 60
ENT.DamageByPlayerSoundLevel = 75
ENT.DeathSoundLevel = 75
ENT.SoundTrackLevel = 0.9
	-- ====== Sound Pitch ====== --
-- Higher number = Higher pitch | Lower number = Lower pitch
-- Highest number is 254
ENT.FootStepPitch1 = 80
ENT.FootStepPitch2 = 100
ENT.BreathSoundPitch1 = 100
ENT.BreathSoundPitch2 = 100
ENT.IdleSoundPitch1 = 80
ENT.IdleSoundPitch2 = 100
ENT.CombatIdleSoundPitch1 = 80
ENT.CombatIdleSoundPitch2 = 100
ENT.OnReceiveOrderSoundPitch1 = 80
ENT.OnReceiveOrderSoundPitch2 = 100
ENT.FollowPlayerPitch1 = 80
ENT.FollowPlayerPitch2 = 100
ENT.UnFollowPlayerPitch1 = 80
ENT.UnFollowPlayerPitch2 = 100
ENT.BeforeHealSoundPitch1 = 80
ENT.BeforeHealSoundPitch2 = 100
ENT.AfterHealSoundPitch1 = 100
ENT.AfterHealSoundPitch2 = 100
ENT.OnPlayerSightSoundPitch1 = 80
ENT.OnPlayerSightSoundPitch2 = 100
ENT.AlertSoundPitch1 = 80
ENT.AlertSoundPitch2 = 100
ENT.CallForHelpSoundPitch1 = 80
ENT.CallForHelpSoundPitch2 = 100
ENT.BecomeEnemyToPlayerPitch1 = 80
ENT.BecomeEnemyToPlayerPitch2 = 100
ENT.BeforeMeleeAttackSoundPitch1 = 80
ENT.BeforeMeleeAttackSoundPitch2 = 100
ENT.MeleeAttackSoundPitch1 = 80
ENT.MeleeAttackSoundPitch2 = 100
ENT.ExtraMeleeSoundPitch1 = 80
ENT.ExtraMeleeSoundPitch2 = 100
ENT.MeleeAttackMissSoundPitch1 = 80
ENT.MeleeAttackMissSoundPitch2 = 100
ENT.RangeAttackPitch1 = 80
ENT.RangeAttackPitch2 = 100
ENT.LeapAttackPitch1 = 80
ENT.LeapAttackPitch2 = 100
ENT.PainSoundPitch1 = 80
ENT.PainSoundPitch2 = 100
ENT.ImpactSoundPitch1 = 80
ENT.ImpactSoundPitch2 = 100
ENT.DamageByPlayerPitch1 = 80
ENT.DamageByPlayerPitch2 = 100
ENT.DeathSoundPitch1 = 80
ENT.DeathSoundPitch2 = 100
	-- Independent Variables ---------------------------------------------------------------------------------------------------------------------------------------------
-- These should be left as they are
ENT.MeleeAttacking = false
ENT.RangeAttacking = false
ENT.LeapAttacking = false
ENT.Alerted = false
ENT.Dead = false
ENT.Flinching = false
ENT.TakingCover = false
ENT.VJCorpseDeleted = false
ENT.vACT_StopAttacks = false
ENT.NoLongerLikesThePlayer = false
ENT.FollowingPlayer = false
ENT.DontStartShooting_FollowPlayer = false
ENT.FollowingPlayer_WanderValue = false
ENT.FollowingPlayer_ChaseValue = false
ENT.ResetedEnemy = true
ENT.VJ_IsBeingControlled = false
ENT.VJ_PlayingSequence = false
ENT.PlayedResetEnemyRunSchedule = false
ENT.VJ_IsPlayingSoundTrack = false
ENT.HasDone_PlayAlertSoundOnlyOnce = false
ENT.PlayingAttackAnimation = false
ENT.OnPlayerSight_AlreadySeen = false
ENT.VJDEBUG_SNPC_ENABLED = false
ENT.DoingMoveOutOfFriendlyPlayersWay = false
ENT.MeleeAttack_DoingPropAttack = false
ENT.Medic_IsHealingAlly = false
ENT.Medic_WanderValue = false
ENT.Medic_ChaseValue = false
ENT.AlreadyDoneMedicThinkCode = false
ENT.AlreadyBeingHealedByMedic = false
ENT.ZombieFriendly = false
ENT.AntlionFriendly = false
ENT.CombineFriendly = false
ENT.AlreadyDoneMeleeAttackFirstHit = false
ENT.AlreadyDoneLeapAttackFirstHit = false
ENT.IsAbleToMeleeAttack = true
ENT.IsAbleToRangeAttack = true
ENT.IsAbleToLeapAttack = true
ENT.RangeAttack_DisableChasingEnemy = false
ENT.IsDoingFaceEnemy = false
ENT.VJ_IsPlayingInterruptSequence = false
ENT.FollowingPlayerName = NULL
ENT.MyEnemy = NULL
ENT.VJ_TheController = NULL
ENT.VJ_TheControllerEntity = NULL
ENT.Medic_CurrentEntToHeal = NULL
ENT.Medic_SpawnedProp = NULL
ENT.LastPlayedVJSound = nil
ENT.LatestEnemyClass = nil
ENT.LatestTaskName = nil
ENT.NextMoveOutOfFriendlyPlayersWayT = 0
ENT.TestT = 0
ENT.NextFollowPlayerT = 0
ENT.AngerLevelTowardsPlayer = 0
ENT.NextBreathSoundT = 0
ENT.FootStepT = 0
ENT.PainSoundT = 0
ENT.WorldShakeWalkT = 0
ENT.NextRunAwayOnDamageT = 0
ENT.NextIdleSoundT = 0
ENT.NextEntityCheckT = 0
ENT.NextFindEnemyT = 0
ENT.NextCallForHelpT = 0
ENT.NextBackUpOnDamageT = 0
ENT.NextAlertSoundT = 0
ENT.LastSeenEnemyTime = 0
ENT.NextCallForHelpAnimationT = 0
ENT.NextResetEnemyT = 0
ENT.CurrentAttackAnimation = 0
ENT.CurrentAttackAnimationDuration = 0
ENT.NextHardEntityCheckT = 0
ENT.NextIdleTime = 0
ENT.NextChaseTime = 0
ENT.OnPlayerSightNextT = 0
ENT.NextDamageByPlayerT = 0
ENT.NextDamageByPlayerSoundT = 0
ENT.TimeSinceLastSeenEnemy = 0
ENT.TimeSinceSeenEnemy = 0
ENT.Medic_NextHealT = 0
ENT.CurrentAnim_IdleStand = 0
ENT.LatestEnemyPosition = Vector(0,0,0)
ENT.SelectedDifficulty = 1
	-- Tables ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HL2_Animals = {"npc_barnacle", "npc_crow", "npc_pigeon", "npc_seagull", "monster_cockroach"}
ENT.HL2_Resistance = {"npc_magnusson", "npc_vortigaunt", "npc_mossman", "npc_monk", "npc_kleiner", "npc_fisherman", "npc_eli", "npc_dog", "npc_barney", "npc_alyx", "npc_citizen"}
ENT.HL2_Combine = {"npc_stalker", "npc_rollermine", "npc_turret_ground", "npc_turret_floor", "npc_turret_ceiling", "npc_strider", "npc_sniper", "npc_metropolice", "npc_hunter", "npc_breen", "npc_combine_camera", "npc_combine_s", "npc_combinedropship", "npc_combinegunship", "npc_cscanner", "npc_clawscanner", "npc_helicopter", "npc_manhack"}
ENT.HL2_Zombies = {"npc_fastzombie_torso", "npc_zombine", "npc_zombie_torso", "npc_zombie", "npc_poisonzombie", "npc_headcrab_fast", "npc_headcrab_black", "npc_headcrab", "npc_fastzombie", "monster_zombie", "monster_headcrab", "monster_babycrab"}
ENT.HL2_Antlions = {"npc_antlion", "npc_antlionguard", "npc_antlion_worker"}
ENT.AttackTimers = {"timer_melee_finished","timer_melee_start","timer_range_finished_abletomelee","timer_range_start","timer_range_finished","timer_range_finished_abletorange","timer_leap_start","timer_leap_finished","timer_leap_finished_abletoleap"}
ENT.AttackTimersCustom = {}
ENT.EntitiesToDestoryModel = {"models/props_phx/construct/wood/wood_wire_angle360x2.mdl","models/props_phx/construct/wood/wood_wire_angle360x1.mdl","models/props_phx/construct/wood/wood_wire_angle180x2.mdl","models/props_phx/construct/wood/wood_wire_angle180x1.mdl","models/props_phx/construct/wood/wood_wire_angle90x2.mdl","models/props_phx/construct/wood/wood_wire_angle90x1.mdl","models/props_phx/construct/wood/wood_wire2x2b.mdl","models/props_phx/construct/wood/wood_wire2x2x2b.mdl","models/props_phx/construct/wood/wood_wire2x2.mdl","models/props_phx/construct/wood/wood_wire1x2x2b.mdl","models/props_phx/construct/wood/wood_wire1x2b.mdl","models/props_phx/construct/wood/wood_wire1x2.mdl","models/props_phx/construct/wood/wood_wire1x1x2b.mdl","models/props_phx/construct/wood/wood_wire1x1x2.mdl","models/props_phx/construct/wood/wood_wire1x1x1.mdl","models/props_phx/construct/wood/wood_wire1x1.mdl","models/props_phx/construct/wood/wood_dome360.mdl","models/props_phx/construct/wood/wood_dome180.mdl","models/props_phx/construct/wood/wood_dome90.mdl","models/props_phx/construct/wood/wood_curve90x2.mdl","models/props_phx/construct/wood/wood_curve90x1.mdl","models/props_phx/construct/wood/wood_curve360x2.mdl","models/props_phx/construct/wood/wood_curve360x1.mdl","models/props_phx/construct/wood/wood_curve180x2.mdl","models/props_phx/construct/wood/wood_curve180x1.mdl","models/props_phx/construct/wood/wood_angle360.mdl","models/props_phx/construct/wood/wood_angle180.mdl","models/props_phx/construct/wood/wood_angle90.mdl","models/props_phx/construct/wood/wood_panel4x4.mdl","models/props_phx/construct/wood/wood_panel2x4.mdl","models/props_phx/construct/wood/wood_panel2x2.mdl" ,"models/props_phx/construct/wood/wood_panel1x2.mdl","models/props_phx/construct/wood/wood_panel1x1.mdl","models/props_phx/construct/wood/wood_boardx4.mdl","models/props_phx/construct/wood/wood_boardx2.mdl" ,"models/props_phx/construct/wood/wood_boardx1.mdl","models/props_debris/wood_board07a.mdl","models/props_debris/wood_board06a.mdl","models/props_debris/wood_board05a.mdl","models/props_debris/wood_board04a.mdl","models/props_debris/wood_board03a.mdl","models/props_debris/wood_board01a.mdl","models/props_debris/wood_board02a.mdl","models/props_junk/wood_pallet001a.mdl","models/props_wasteland/barricade002a.mdl","models/props_wasteland/barricade001a.mdl","models/props_junk/wood_crate002a.mdl","models/props_junk/wood_crate001a.mdl","models/props_junk/wood_crate001a_damaged.mdl","models/props_junk/wood_crate001a_damagedmax.mdl","models/props_wasteland/dockplank01a.mdl","models/props_wasteland/dockplank01b.mdl","models/props_wasteland/wood_fence01a.mdl","models/props_wasteland/wood_fence02a.mdl","models/props_interiors/furniture_shelf01a.mdl","models/props_c17/shelfunit01a.mdl","models/props_c17/furnituredresser001a.mdl","models/props_wasteland/cafeteria_table001a.mdl","models/props_c17/furnituretable001a.mdl","models/props_c17/furnituretable002a.mdl","models/props_c17/furnituredrawer001a.mdl"}
ENT.EntitiesToDestroyClass = {"func_breakable","func_physbox"} //"func_breakable_surf"
ENT.EntitiesToPushModel = {"models/props_c17/oildrum001.mdl","models/props_borealis/bluebarrel001.mdl"}
ENT.VJ_AddCertainEntityAsEnemy = {}
ENT.VJ_AddCertainEntityAsFriendly = {}

/*vSound = {}
vSound.Test = {}
for k,v in pairs(vSound) do
	for c,d in pairs(vSound[k]) do
	util.PrecacheSound(d)
	end
end*/

function VJ_TABLERANDOM(vtblname) return vtblname[math.random(1,table.Count(vtblname))] end
//function VJ_STOPSOUND(vsoundname) if vsoundname then vsoundname:Stop() end end

util.AddNetworkString("vj_creature_onthememusic")
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize() /* -- Example: self:SetCollisionBounds(Vector(50, 50, 100), Vector(-50, -50, 0)) */ end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnSchedule() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ExpressionFinished(strExp) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPlayCreateSound(SoundData,SoundFile) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPlayEmitSound(SoundData) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTouch(entity) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnCondition(iCondition) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnFollowPlayer(key,activator,caller,data) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMedic_BeforeHeal() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMedic_AftereHeal() end
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
function ENT:CustomOnAlert() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnCallForHelp() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomAttack() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MultipleMeleeAttacks() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_BeforeStartTimer() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_AfterStartTimer() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_BeforeChecks() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_AfterChecks(TheHitEntity) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_BleedEnemy(TheHitEntity) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_SlowPlayer(TheHitEntity) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_Miss() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MultipleRangeAttacks() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRangeAttack_BeforeStartTimer() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRangeAttack_AfterStartTimer() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode_AfterProjectileSpawn(TheProjectile) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackCode_OverrideProjectilePos(TheProjectile) return 0 end -- return other value then 0 to override the projectile's position
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackCode_GetShootPos(TheProjectile) return (self:GetEnemy():GetPos() - self:LocalToWorld(Vector(0,0,0)))*2 + self:GetUp()*1 end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MultipleLeapAttacks() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnLeapAttackVelocityCode() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnLeapAttack_BeforeStartTimer() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnLeapAttack_AfterStartTimer() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnLeapAttack_BeforeChecks() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnLeapAttack_AfterChecks(TheHitEntity) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeImmuneChecks(dmginfo) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeGetDamage(dmginfo,hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo,hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnFlinch_BeforeFlinch(dmginfo,hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnFlinch_AfterFlinch(dmginfo,hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDamageByPlayer(dmginfo) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_AfterImmuneChecks(dmginfo,hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomWhenBecomingEnemyTowardsPlayer(dmginfo,hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPriorToKilled(dmginfo,hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomDeathAnimationCode(dmginfo,hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRareDropsOnDeathCode(dmginfo,hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_BeforeCorpseSpawned(dmginfo,hitgroup) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo,hitgroup,GetCorpse) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GibCode(dmginfo,hitgroup)
-- Add as many as you want --
	/*
	-- Default Damage types for the gib|you can add more
	local explodegib = dmginfo:GetDamageType()
	if explodegib == DMG_BLAST or explodegib == DMG_DIRECT or explodegib == DMG_DISSOLVE or explodegib == DMG_AIRBOAT or explodegib == DMG_SLOWBURN or explodegib == DMG_PHYSGUN or explodegib == DMG_PLASMA or explodegib == DMG_SHOCK or explodegib == DMG_SONIC or explodegib == DMG_VEHICLE or explodegib == DMG_CRUSH then
	self.HasDeathRagdoll = false -- Disable ragdoll
	self.HasDeathAnimation = false -- Disable death animation
	
	-- Most used gib sounds
	if GetConVarNumber("vj_npc_sd_gibbing") == 0 then
	self:EmitSound( "vj_gib/default_gib_splat.wav",90,math.random(80,100))
	self:EmitSound( "vj_gib/gibbing1.wav",90,math.random(80,100))
	self:EmitSound( "vj_gib/gibbing2.wav",90,math.random(80,100))
	self:EmitSound( "vj_gib/gibbing3.wav",90,math.random(80,100))
	end
	
	-- Particles and Effects
	if GetConVarNumber("vj_npc_nogibdeathparticles") == 0 then
	local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos() + Vector(0,0,10)) -- the vector of were you want the effect to spawn
	effectdata:SetScale( 1 ) -- how big the particles are, can even be 0.1 or 0.6
	util.Effect( "StriderBlood", effectdata ) -- Add as many as you want
	util.Effect( "StriderBlood", effectdata )
	ParticleEffect("antlion_gib_02_gas", self:GetPos(), Angle(0,0,0), nil)
	ParticleEffect("antlion_gib_02_gas", self:GetPos(), Angle(0,0,0), nil)
	ParticleEffect("antlion_gib_02_gas", self:GetPos(), Angle(0,0,0), nil)
	ParticleEffect("antlion_spit", self:GetPos(), Angle(0,0,0), nil)
	ParticleEffect("antlion_gib_02", self:GetPos(), Angle(0,0,0), nil)
	end
	
	-- Entity Gib
	local gib = ents.Create( "obj_vj_gib_alien" )
	gib:SetModel( "models/gibs/xenians/mgib_01.mdl" ) -- The Entity
	gib:SetPos( self:LocalToWorld(Vector(math.Rand(1,8),0,40))) -- The Postion the model spawns
	gib:SetAngles( self:GetAngles() )
	gib:Spawn()
	gib:Activate()
	gib:GetPhysicsObject():AddVelocity(Vector( math.Rand( -500, 500 ),math.Rand( -500, 500 ), 200 ))
	cleanup.ReplaceEntity(gib)
	
	-- Each one needs a different name|Change "FadeAndRemove" to "kill" if it is prop_physics
	local gib = ents.Create( "prop_ragdoll" ) -- prop_ragdoll or prop_physics
	gib:SetModel( "models/rrrrrrrr/rrrrrrrr.mdl" ) -- The Model
	gib:SetPos( self:LocalToWorld(Vector(1,0,60))) -- The Postion the model spawns
	gib:SetAngles( self:GetAngles() )
	gib:Spawn()
	gib:SetSkin( self:GetSkin() )
	gib:SetColor( self:GetColor() )
	gib:SetMaterial( self:GetMaterial() )
	if GetConVarNumber("vj_npc_gibcollidable") == 0 then gib:SetCollisionGroup( 1 ) end
	gib:GetPhysicsObject():AddVelocity(Vector( math.Rand( -500, 500 ),math.Rand( -500, 500 ), 200 )) -- Make things fly
	cleanup.ReplaceEntity(gib) -- Make it remove on map cleanup
	if GetConVarNumber("vj_npc_fadegibs") == 1 then -- Make the ragdoll fade through menu
	gib:Fire( "FadeAndRemove", "", GetConVarNumber("vj_npc_fadegibstime") ) end
	*/
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:VJ_DoSelectDifficulty()
	self:SetSpawnEffect(false)
	if VJ_PICKRANDOMTABLE(self.Model) != false then self:SetModel(Model(VJ_PICKRANDOMTABLE(self.Model))) end
	self:SetMaxYawSpeed(self.TurningSpeed)
	if self.HasHull == true then self:SetHullType(self.HullType) end
	self:SetCustomCollisionCheck()
	if self.HullSizeNormal == true then self:SetHullSizeNormal() end
	if self.HasSetSolid == true then self:SetSolid(SOLID_BBOX) end
	//self:SetMoveType(self.MoveType)
	self:DoChangeMovementType()
	if self.DisableCapabilities == false then self:SetInitializeCapabilities() end
	self:SetCollisionGroup(COLLISION_GROUP_NPC)
	self.VJ_ScaleHitGroupDamage = 0
	self.NextIdleSoundT_UnChanged = CurTime() + math.random(0.3,6)
	//self:SetHealth(self.StartHealth)
	self:SetEnemy(nil)
	self:SetUseType(SIMPLE_USE)
	//self:AddEFlags(EFL_NO_DISSOLVE)
	if GetConVarNumber("vj_npc_allhealth") == 0 then
	if self.SelectedDifficulty == 0 then self:SetHealth(self.StartHealth/2) end -- Easy
	if self.SelectedDifficulty == 1 then self:SetHealth(self.StartHealth) end -- Normal
	if self.SelectedDifficulty == 2 then self:SetHealth(self.StartHealth*1.5) end -- Hard
	if self.SelectedDifficulty == 3 then self:SetHealth(self.StartHealth*2.5) end else -- Hell On Earth
	self:SetHealth(GetConVarNumber("vj_npc_allhealth")) end
	self.StartHealth = self:Health()
	self:SetName(self.PrintName)
	//self.Corpse = ents.Create(self.DeathEntityType)
	self:CustomOnInitialize()
	self:CustomInitialize() -- Backwards Compatibility! DO NOT USE!
	self:ConvarsOnInit()
	if math.random(1,self.SoundTrackChance) == 1 then self:StartSoundTrack() end
	self:SetRenderMode(RENDERMODE_NORMAL)
	//self:SetRenderMode(RENDERMODE_TRANSALPHA)
	self:DrawShadow(true)
	duplicator.RegisterEntityClass(self:GetClass(),VJSPAWN_SNPC_DUPE,"Model","Class","Equipment","SpawnFlags","Data")
	//table.insert(self.VJ_FriendlyNPCsGroup,"npc_vj_mili*")
	//print(table.Count(self.VJ_FriendlyNPCsGroup))
	if self.Immune_CombineBall == true or self.GodMode == true then self:AddEFlags(EFL_NO_DISSOLVE) end
	self.VJ_AddCertainEntityAsEnemy = {}
	self.VJ_AddCertainEntityAsFriendly = {}
	self.CurrentPossibleEnemies = {}
	if GetConVarNumber("vj_npc_seedistance") == 0 then self.SightDistance = self.SightDistance else self.SightDistance = GetConVarNumber("vj_npc_seedistance") end
	timer.Simple(0.1,function()
		if IsValid(self) then
			self.CurrentPossibleEnemies = self:DoHardEntityCheck()
		end
	end)
	if self.MovementType == VJ_MOVETYPE_GROUND then self:VJ_SetSchedule(SCHED_FALL_TO_GROUND) end
	/*if self.VJ_IsStationary == true then
		self.HasFootStepSound = false
		self.HasWorldShakeOnMove = false
		self.RunAwayOnUnknownDamage = false
		self.DisableWandering = true
		self.DisableChasingEnemy = true
	end*/
	//self:SetModelScale(self:GetModelScale()*1.5)
end
function ENT:CustomInitialize() end -- Backwards Compatibility! DO NOT USE!
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInitializeCapabilities()
-- Add as many as you want --
	//self:CapabilitiesAdd(bit.bor(CAP_ANIMATEDFACE)) -- Breaks some SNPCs, avoid using it!
	self:CapabilitiesAdd(bit.bor(CAP_TURN_HEAD))
	//if self.VJ_IsStationary == false && self.MovementType != VJ_MOVETYPE_AERIAL then self:CapabilitiesAdd(bit.bor(CAP_MOVE_GROUND)) end
	if GetConVarNumber("vj_npc_creatureopendoor") == 1 then
	self:CapabilitiesAdd(bit.bor(CAP_OPEN_DOORS))
	self:CapabilitiesAdd(bit.bor(CAP_AUTO_DOORS))
	self:CapabilitiesAdd(bit.bor(CAP_USE)) end
	//self:CapabilitiesAdd(bit.bor(CAP_MOVE_JUMP))
	//self:CapabilitiesAdd(bit.bor(CAP_MOVE_SHOOT))
	//self:CapabilitiesAdd(bit.bor(CAP_AIM_GUN))
	//if self.MovementType == VJ_MOVETYPE_AERIAL then
	//	self:CapabilitiesAdd(bit.bor(CAP_MOVE_FLY))
	//	self:CapabilitiesAdd(bit.bor(CAP_SKIP_NAV_GROUND_CHECK))
	//end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoChangeMovementType(SetType)
	SetType = SetType or "None"
	if SetType != "None" then self.MovementType = SetType end
	if self.MovementType == VJ_MOVETYPE_GROUND then
		self:SetMoveType(MOVETYPE_STEP)
		self:CapabilitiesAdd(bit.bor(CAP_MOVE_GROUND))
		self:CapabilitiesRemove(CAP_MOVE_FLY)
		self:CapabilitiesRemove(CAP_SKIP_NAV_GROUND_CHECK)
	end
	if self.MovementType == VJ_MOVETYPE_AERIAL then
		self:SetMoveType(MOVETYPE_FLY)
		self:CapabilitiesAdd(bit.bor(CAP_MOVE_FLY))
		self:CapabilitiesAdd(bit.bor(CAP_SKIP_NAV_GROUND_CHECK))
		self:CapabilitiesRemove(CAP_MOVE_GROUND)
	end
	if self.MovementType == VJ_MOVETYPE_AQUATIC then
		self:SetMoveType(MOVETYPE_FLY)
		self:CapabilitiesAdd(bit.bor(CAP_MOVE_FLY))
		self:CapabilitiesAdd(bit.bor(CAP_SKIP_NAV_GROUND_CHECK))
		self:CapabilitiesRemove(CAP_MOVE_GROUND)
	end
	if self.MovementType == VJ_MOVETYPE_STATIONARY then
		self:SetMoveType(MOVETYPE_NONE)
		self:CapabilitiesRemove(CAP_MOVE_GROUND)
		self:CapabilitiesRemove(CAP_MOVE_FLY)
		self:CapabilitiesRemove(CAP_SKIP_NAV_GROUND_CHECK)
	end
	if self.MovementType == VJ_MOVETYPE_PHYSICS then
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:CapabilitiesRemove(CAP_MOVE_GROUND)
		self:CapabilitiesRemove(CAP_MOVE_FLY)
		self:CapabilitiesRemove(CAP_SKIP_NAV_GROUND_CHECK)
		self:CapabilitiesRemove(CAP_MOVE_SHOOT)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoSchedule(schedule)
	self.LatestTaskName = schedule.Name
	if self:TaskFinished() then self:NextTask(schedule) end
	if self.CurrentTask then self:RunTask(self.CurrentTask) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTaskComplete()
	self.bTaskComplete = true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_ACT_PLAYACTIVITY(vACT_Name,vACT_StopActivities,vACT_StopActivitiesTime,vACT_FaceEnemy,vACT_DelayAnim,vACT_AdvancedFeatures,vACT_CustomCode)
	if vACT_Name == nil or vACT_Name == false then return end
	vACT_StopActivities = vACT_StopActivities or false
	vACT_StopActivitiesTime = vACT_StopActivitiesTime or 0
	vACT_FaceEnemy = vACT_FaceEnemy or false
	vACT_DelayAnim = vACT_DelayAnim or 0
	vACT_AdvancedFeatures = vACT_AdvancedFeatures or {}
	vTbl_AlwaysUseSequence = vACT_AdvancedFeatures.AlwaysUseSequence or false
	vTbl_SequenceDuration = vACT_AdvancedFeatures.SequenceDuration -- Done automatically
	vTbl_SequenceInterruptible = vACT_AdvancedFeatures.SequenceInterruptible or false -- Can it be Interrupted? (Mostly used for idle animations)
	vTbl_PlayBackRate = vACT_AdvancedFeatures.PlayBackRate or 0.5
	//vACT_CustomCode = vACT_CustomCode or function() end
	if istable(vACT_Name) then vACT_Name = VJ_PICKRANDOMTABLE(vACT_Name) end
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

	if type(vACT_Name) != "string" && VJ_AnimationExists(self,vACT_Name) == false then
		if self:GetActiveWeapon() != NULL then
			if table.HasValue(table.GetKeys(self:GetActiveWeapon().ActivityTranslateAI),vACT_Name) != true then return end
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
	//vsched:EngTask("TASK_RESET_ACTIVITY", 0)
	if vACT_StopActivities == true then
		self:StopAttacks()
		self.vACT_StopAttacks = true
		self.NextChaseTime = CurTime() + vACT_StopActivitiesTime
		self.NextIdleTime = CurTime() + vACT_StopActivitiesTime
		timer.Simple(vACT_StopActivitiesTime,function() self.vACT_StopAttacks = false end)
	end
	if (vACT_CustomCode) then vACT_CustomCode() end
	
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
	
	timer.Simple(vACT_DelayAnim,function()
	if IsValid(self) then
		if IsGesture == true then
			local gesttest = false
			if IsSequence == false then gesttest = self:AddGesture(vACT_Name) end
			if IsSequence == true then gesttest = self:AddGestureSequence(vACT_Name) end
			if gesttest != false then
				self:SetLayerPriority(gesttest,2)
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
			vsched:EngTask("TASK_STOP_MOVING", 0)
			vsched:EngTask("TASK_STOP_MOVING", 0)
			self:StopMoving()
			self:ClearSchedule()
			if IsSequence == false then
				self.VJ_PlayingSequence = false
				if vACT_FaceEnemy == true then
				vsched:EngTask("TASK_PLAY_SEQUENCE_FACE_ENEMY",vACT_Name) else
				vsched:EngTask("TASK_PLAY_SEQUENCE",vACT_Name) end
			end
			//self:ClearSchedule()
			//self:StartEngineTask(GetTaskList("TASK_RESET_ACTIVITY"), 0)
			self:StartSchedule(vsched)
			self:MaintainActivity()
		end
	 end
	end)
	//self:MaintainActivity()
	//self:TaskComplete()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_ACT_FOLLOWTARGET() 
	local vsched = ai_vj_schedule.New("vj_act_followtarget")
	vsched:EngTask("TASK_GET_PATH_TO_TARGET", 0)
	vsched:EngTask("TASK_RUN_PATH", 0)
	self:StartSchedule(vsched)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_ACT_GOTOPLAYER()
	local vsched = ai_vj_schedule.New("vj_act_gotoplayer")
	vsched:EngTask("TASK_GET_PATH_TO_PLAYER", 0)
	vsched:EngTask("TASK_RUN_PATH", 0)
	self:StartSchedule(vsched)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_ACT_WANDER()
	local vsched = ai_vj_schedule.New("vj_act_idlewander")
	//self:SetLastPosition(self:GetPos() + self:GetForward() * 300)
	//vsched:EngTask("TASK_SET_ROUTE_SEARCH_TIME", 0)
	//vsched:EngTask("TASK_GET_PATH_TO_LASTPOSITION", 0)
	vsched:EngTask("TASK_GET_PATH_TO_RANDOM_NODE", 200)
	vsched:EngTask("TASK_WALK_PATH", 0)
	vsched:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
	self:StartSchedule(vsched)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_ACT_IDLESTAND(waittime)
	//if self.LatestTaskName == "vj_act_idlestand" then return end
	//local vsched = ai_vj_schedule.New("vj_act_idlestand")
	//vsched:EngTask("TASK_WAIT", waittime)
	//self:StartSchedule(vsched)
	//print(self:GetSequenceName(self:GetSequence()))
	//local idletbl = self.AnimTbl_IdleStand
	//if table.Count(idletbl) > 0 /*&& self:GetSequenceName(self:GetSequence()) != ideanimrand_act*/ then
	//	if VJ_IsCurrentAnimation(self,self.CurrentAnim_IdleStand) != true /*&& VJ_IsCurrentAnimation(self,ACT_IDLE) && self.VJ_PlayingSequence == false && self.VJ_IsPlayingInterruptSequence == false*/ then
	//		self.CurrentAnim_IdleStand = VJ_PICKRANDOMTABLE({idletbl})
	//		self:VJ_ACT_PLAYACTIVITY(self.CurrentAnim_IdleStand,false,0,true,0,{AlwaysUseSequence=true,SequenceDuration=false,SequenceInterruptible=true})
	//	end
	//else
		if self:IsCurrentSchedule(SCHED_IDLE_STAND) != true then
			self:VJ_SetSchedule(SCHED_IDLE_STAND)
		end
	//end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoCustomIdleAnimation()
	local idletbl = self.AnimTbl_IdleStand
	local idletblrand = VJ_PICKRANDOMTABLE(idletbl)
	if idletblrand == false then return end
	if self:GetActivity() == ACT_IDLE then
		if type(idletblrand) == "string" then
			local checkanim = self:GetSequenceActivity(self:LookupSequence(idletblrand))
			if checkanim == nil or checkanim == -1 then
				return false
			else
				idletblrand = checkanim
			end
		end
		self:StartEngineTask(GetTaskList("TASK_PLAY_SEQUENCE"), idletblrand)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoIdleAnimation(RestrictNumber,OverrideWander)
	if self.IsVJBaseSNPC_Tank == true then return end
	if self.VJ_PlayingSequence == true or self.FollowingPlayer == true or self.PlayingAttackAnimation == true or self.Dead == true or (self.NextIdleTime > CurTime()) then return end
	-- 0 = Random | 1 = Wander | 2 = Idle Stand /\ OverrideWander = Wander no matter what
	RestrictNumber = RestrictNumber or 0
	OverrideWander = OverrideWander or false
	if self.MovementType == VJ_MOVETYPE_STATIONARY then self:VJ_ACT_IDLESTAND(math.Rand(6,12)) return end
	if OverrideWander == false && self.DisableWandering == true && (RestrictNumber == 1 or RestrictNumber == 0) then self:VJ_ACT_IDLESTAND(math.Rand(6,12)) return end
	if RestrictNumber == 0 then
		if math.random(1,3) == 1 then
			self:VJ_SetSchedule(VJ_PICKRANDOMTABLE(self.IdleSchedule_Wander)) else self:VJ_ACT_IDLESTAND(math.Rand(6,12))
		end
	end
	if RestrictNumber == 1 then
		self:VJ_SetSchedule(VJ_PICKRANDOMTABLE(self.IdleSchedule_Wander))
	end
	if RestrictNumber == 2 then
		self:VJ_ACT_IDLESTAND(math.Rand(6,12))
	end
	self.NextIdleTime = CurTime() + math.random(2,6)
end
---------------------------------------------------------------------------------------------------------------------------------------------
/*function ENT:VJ_ACT_CHASE_ENEMY() 
	local vsched = ai_vj_schedule.New("vj_act_chasenemy")
	vsched:EngTask("TASK_GET_PATH_TO_ENEMY", 0)
	vsched:EngTask("TASK_RUN_PATH", 0)
	self:StartSchedule(vsched)
end*/
ENT.MyLastPosOnFailedChaseEnemy = Vector(0,0,0)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoChaseAnimation(OverrideChasing,ChaseSched)
	if !IsValid(self:GetEnemy()) or self:GetEnemy() == nil then return end
	if self.IsVJBaseSNPC_Tank == true or self.VJ_PlayingSequence == true or self.FollowingPlayer == true or self.PlayingAttackAnimation == true or self.Dead == true or (self.NextChaseTime > CurTime()) then return end
	if self:VJ_GetNearestPointToEntityDistance(self:GetEnemy()) < self.MeleeAttackDistance && self:GetEnemy():Visible(self) && (self:GetForward():Dot((self:GetEnemy():GetPos() -self:GetPos()):GetNormalized()) > math.cos(math.rad(self.MeleeAttackAngleRadius))) then return end
	-- OverrideChasing = Chase no matter what
	OverrideChasing = OverrideChasing or false
	ChaseSched = ChaseSched or VJ_PICKRANDOMTABLE(self.ChaseSchedule)
	//if self:HasCondition(31) && (!self:Visible(self:GetEnemy())) then ChaseSched = SCHED_ESTABLISH_LINE_OF_FIRE end
	if self.MovementType == VJ_MOVETYPE_STATIONARY then self:VJ_ACT_IDLESTAND(math.Rand(6,12)) return end
	if OverrideChasing == false && (self.DisableChasingEnemy == true or self.RangeAttack_DisableChasingEnemy == true) then self:VJ_ACT_IDLESTAND(math.Rand(6,12)) return end
	//if self.HasWalkingCapability == false then self:VJ_ACT_IDLESTAND(0.1) else
	//if self:HasCondition(31) then self.MyLastPosOnFailedChaseEnemy = self:GetPos() end
	if self.MovementType == VJ_MOVETYPE_AERIAL then 
		self:AerialMove_ChaseEnemy(true)
	else
		//if self:HasCondition(31) && self.MyLastPosOnFailedChaseEnemy == self:GetPos() then
			//self:VJ_SetSchedule(SCHED_NONE)
		//else
			self:VJ_SetSchedule(ChaseSched)
		//end
	end
	//self.MyLastPosOnFailedChaseEnemy = self:GetPos()
	//self:VJ_ACT_CHASE_ENEMY()
	self.NextChaseTime = CurTime() + 0.1
end

// MOVETYPE_FLY | MOVETYPE_FLYGRAVITY

ENT.AerialFlyingSpeed_Calm = 20 -- The speed it should fly with, when it's wandering, moving slowly, etc. | Basically walking campared to ground SNPCs
ENT.AerialFlyingSpeed_Alerted = 40 -- The speed it should fly with, when it's chasing an enemy, moving away quickly, etc. | Basically running campared to ground SNPCs
ENT.AerialRunAnims = {ACT_RUN}
ENT.AerialCurrentAnim = nil
ENT.IsFlying = false
ENT.ShouldBeFlying = false
ENT.NextFlyAnim = 0
function ENT:AerialMove_ChaseEnemy(ShouldPlayAnim)
	if self.Dead == true or (self.NextChaseTime > CurTime()) then return end
	ShouldPlayAnim = ShouldPlayAnim or false
	self:FaceCertainEntity(self:GetEnemy(),true)
	self.ShouldBeFlying = false
	
	if ShouldPlayAnim == true && self:GetSequence() != self.AerialCurrentAnim /*&& self:GetActivity() == ACT_IDLE*/ && CurTime() > self.NextFlyAnim && (self.NextChaseTime < CurTime()) then
	local idleanim = self.AerialRunAnims
	local ideanimrand = VJ_PICKRANDOMTABLE(idleanim)
	if type(ideanimrand) == "number" then ideanimrand = self:GetSequenceName(self:SelectWeightedSequence(ideanimrand)) end
	local ildeanimid = self:LookupSequence(ideanimrand)
		//self.ShouldBeFlying = true
		self.AerialCurrentAnim = ildeanimid
		//self:AddGestureSequence(ildeanimid)
		self:VJ_ACT_PLAYACTIVITY(ideanimrand,false,0,false,0,{AlwaysUseSequence=true,SequenceDuration=false})
		self.NextFlyAnim = CurTime() + 0.3
	end
				local getupvel = 30
				local getenemyz = "None"
				
				local tr = {}
				tr.start = self:GetPos()
				tr.endpos = self:GetEnemy():GetPos()
				tr.filter = self
				tr.mins = self:OBBMins()
				tr.maxs = self:OBBMaxs()
				local tr = util.TraceHull(tr)

				/*if self:GetEnemy():GetPos().z > self:GetPos().z then
					print("UP")
					getenemyz = "Up"
					getupvel = 100
				elseif self:GetEnemy():GetPos().z < self:GetPos().z then
					print("DOWN")
					getenemyz = "Down"
					getupvel = -100
				end*/
				
				/*if tr.HitWorld && tr.HitPos:Distance(self:GetPos()) < (self:OBBMaxs():Distance(self:OBBMins())) * 3 then
					if self:GetEnemy():GetPos().z < tr.HitPos.z then
					getupvel = 231
					print("up")
				elseif self:GetEnemy():GetPos().z > tr.HitPos.z then
					getupvel = -231
					print("down")
					end
				end*/


				/*if tr.HitWorld && tr.HitPos:Distance(self:GetPos()) < (self:OBBMaxs():Distance(self:OBBMins())) * 3 then
					getupvel = -21
					print("-21")
				elseif self:GetEnemy():GetPos().z > tr.HitPos.z then
					getupvel = -231
					print("-231")
				end*/
				
		util.ParticleTracerEx("Weapon_Combine_Ion_Cannon_Beam",tr.StartPos,tr.HitPos,false,self:EntIndex(),0) //vortigaunt_beam
		ParticleEffect("vj_impact1_centaurspit", tr.HitPos, Angle(0,0,0), self)
		/*local nig = ents.Create("prop_dynamic") -- Run in Console: lua_run for k,v in ipairs(ents.GetAll()) do if v:GetClass() == "prop_dynamic" then v:Remove() end end
		nig:SetModel("models/hunter/blocks/cube025x025x025.mdl")
		nig:SetPos(tr.HitPos)
		nig:SetAngles(self:GetAngles())
		nig:SetColor(Color(255,0,0))
		nig:Spawn()
		nig:Activate()
		timer.Simple(3,function() nig:Remove() end)*/
	
	myvel = self:GetVelocity()
	enevel = self:GetEnemy():GetVelocity()
	local jumpyaw
	local jumpcode = ((self:GetEnemy():GetPos() + self:OBBCenter()) -(self:GetPos() + self:OBBCenter())):GetNormal() *400 +self:GetUp() *getupvel +self:GetForward() *-200
	jumpyaw = jumpcode:Angle().y
	self:SetLocalVelocity(jumpcode)
	//self.NextChaseTime = CurTime() + 0.1
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Touch(entity)
	if self.VJDEBUG_SNPC_ENABLED == true then if GetConVarNumber("vj_npc_printontouch") == 1 then print(self:GetClass().." Has Touched "..entity:GetClass()) end end
	self:CustomOnTouch(entity)
	//if self.Alerted == false then
	if self.DisableTouchFindEnemy == false then
	if entity:IsNPC() or entity:IsPlayer() then
	if self:GetEnemy() == nil then
	if self:DoRelationshipCheck(entity) == true then
		//self:FaceCertainEntity(entity)
		self:SetTarget(entity)
		self:VJ_SetSchedule(SCHED_TARGET_FACE)
		end
	end
  end
 end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AcceptInput(key,activator,caller,data)
	self:CustomOnAcceptInput(key,activator,caller,data)
	self:FollowPlayerCode(key,activator,caller,data)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCondition(iCondition)
	self:CustomOnCondition(iCondition)
	//if iCondition == 36 then print("sched done!") end
	//if iCondition != 15 && iCondition != 60 then
	//	print(self," Condition: ",iCondition," - ",self:ConditionName(iCondition))
	//end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FollowPlayerReset()
	if self.FollowPlayerChat == true then
	self.FollowingPlayerName:PrintMessage(HUD_PRINTTALK, self:GetName().." is no longer following you.") end
	self.FollowingPlayer = false
	self.DontStartShooting_FollowPlayer = false
	self.FollowingPlayerName = NULL
	self.DisableWandering = self.FollowingPlayer_WanderValue
	self.DisableChasingEnemy = self.FollowingPlayer_ChaseValue
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FollowPlayerCode(key,activator,caller,data)
if self.FollowPlayer == false then return end
if GetConVarNumber("ai_disabled") == 1 then return end
if GetConVarNumber("ai_ignoreplayers") == 1 then return end
	if key == self.FollowPlayerKey && activator:IsPlayer() then
	if activator:IsValid() && activator:Alive() then
	if self:Disposition(activator) == D_HT then
	if self.FollowPlayerChat == true then
	activator:PrintMessage(HUD_PRINTTALK, self:GetName().." doesn't like you, therefore it won't follow you.") end return end
	self:CustomOnFollowPlayer(key,activator,caller,data)
	if self.FollowingPlayer == false then
		//self:FaceCertainEntity(activator,false)
		if self.FollowPlayerChat == true then
		activator:PrintMessage(HUD_PRINTTALK, self:GetName().." is now following you.") end
		self.FollowingPlayer_WanderValue = self.DisableWandering
		self.FollowingPlayer_ChaseValue = self.DisableChasingEnemy
		self.DisableWandering = true
		self.DisableChasingEnemy = true
		self:SetTarget(activator)
		self.FollowingPlayerName = activator
		self:StopMoving()
		timer.Simple(0.15,function() if self:IsValid() && self.VJ_PlayingSequence == false then self:VJ_SetSchedule(SCHED_TARGET_FACE) end end)
		//if self.VJ_PlayingSequence == false then self:VJ_SetSchedule(SCHED_IDLE_STAND) end
		timer.Simple(0.1,function()
		if self:IsValid() then
		self:VJ_ACT_FOLLOWTARGET() end end)
		self:FollowPlayerSoundCode()
		self.FollowingPlayer = true else
		self:UnFollowPlayerSoundCode()
		if self.VJ_PlayingSequence == false then self:VJ_SetSchedule(SCHED_TARGET_FACE) end
		self:FollowPlayerReset()
		end
	end
 end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoMedicCode_Reset()
	self.Medic_CurrentEntToHeal.AlreadyBeingHealedByMedic = false
	self.Medic_IsHealingAlly = false
	self.AlreadyDoneMedicThinkCode = false
	self.Medic_CurrentEntToHeal = NULL
	self.DisableWandering = self.Medic_WanderValue
	self.DisableChasingEnemy = self.Medic_ChaseValue
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoMedicCode_FindAllies()
	-- for k,v in ipairs(player.GetAll()) do v.AlreadyBeingHealedByMedic = false end
	if self.IsMedicSNPC == false or self.Medic_IsHealingAlly == true or CurTime() < self.Medic_NextHealT then return end
	local findnigas = ents.FindInSphere(self:GetPos(),self.Medic_CheckDistance)
	for k,v in ipairs(findnigas) do
	if (v.IsVJBaseSNPC == true && self:GetEnemy() == nil && v:GetEnemy() == nil or v:IsPlayer() && GetConVarNumber("ai_ignoreplayers") == 0) && v:EntIndex() != self:EntIndex() && v.AlreadyBeingHealedByMedic == false then
	if (!v.IsVJBaseSNPC_Tank) && self:DoRelationshipCheck(v) == false && v:Health() <= v:GetMaxHealth() * 0.75 then
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
	self:VJ_ACT_FOLLOWTARGET()
	return true
   end
  end
 end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoMedicCode_HealAlly()
	if self.IsMedicSNPC == true && self.Medic_IsHealingAlly == true && self.AlreadyDoneMedicThinkCode == false then
		//print(self.FollowingPlayerName)
		if IsValid(self.Medic_CurrentEntToHeal) && VJ_IsAlive(self.Medic_CurrentEntToHeal) == true then
		if self:GetPos():Distance(self.Medic_CurrentEntToHeal:GetPos()) <= self.Medic_HealDistance then
			self.AlreadyDoneMedicThinkCode = true
			if self.Medic_SpawnPropOnHeal == true then
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
			self:MedicSoundCode_BeforeHeal()
			local lolcptlook = VJ_PICKRANDOMTABLE(self.AnimTbl_Medic_GiveHealth)
			local animtime = VJ_GetSequenceDuration(self,lolcptlook)
			self:FaceCertainEntity(self.Medic_CurrentEntToHeal,false)
			self:VJ_ACT_PLAYACTIVITY(lolcptlook,true,animtime,false)
			if !self.Medic_CurrentEntToHeal:IsPlayer() then
				self.Medic_CurrentEntToHeal:SetTarget(self)
				self.Medic_CurrentEntToHeal:VJ_SetSchedule(SCHED_TARGET_FACE)
			end
			timer.Simple(animtime,function() if IsValid(self) && IsValid(self.Medic_CurrentEntToHeal) then
				self.Medic_CurrentEntToHeal.AlreadyBeingHealedByMedic = false
				self.Medic_IsHealingAlly = false
				if IsValid(self.Medic_SpawnedProp) then self.Medic_SpawnedProp:Remove() end
				if self:GetPos():Distance(self.Medic_CurrentEntToHeal:GetPos()) <= self.Medic_HealDistance then
					self:MedicSoundCode_AfterHeal()
					self:VJ_SetSchedule(SCHED_IDLE_STAND)
					self.Medic_CurrentEntToHeal:RemoveAllDecals()
					local frimaxhp = self.Medic_CurrentEntToHeal:GetMaxHealth()
					local fricurhp = self.Medic_CurrentEntToHeal:Health()
					self.Medic_CurrentEntToHeal:SetHealth(math.Clamp(fricurhp + self.Medic_HealthAmount,fricurhp,frimaxhp))
				end
				-- items/smallmedkit1.wav
				self:DoMedicCode_Reset()
				end
			end)
			else self.NextIdleTime = CurTime() + 4 self.NextChaseTime = CurTime() + 4 self:SetTarget(self.Medic_CurrentEntToHeal) self:VJ_ACT_FOLLOWTARGET()
		 end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoConstantlyFaceEnemyCode()
	if self.Dead == true then return false end
	if self.ConstantlyFaceEnemy == true && self:GetEnemy():GetPos():Distance(self:GetPos()) < self.ConstantlyFaceEnemyDistance then
		if self.ConstantlyFaceEnemy_IfVisible == true && !self:Visible(self:GetEnemy()) then return false end
		if self.ConstantlyFaceEnemy_IfAttacking == false && (self.MeleeAttacking == true or self.LeapAttacking == true or self.RangeAttacking == true) then return false end
		if self.ConstantlyFaceEnemy_Postures != "Both" then
			if self.ConstantlyFaceEnemy_Postures == "Moving" && !self:IsMoving() then return false end
			if self.ConstantlyFaceEnemy_Postures == "Standing" && self:IsMoving() then return false end
		end
		self:SetAngles(Angle(0,(self:GetEnemy():GetPos()-self:GetPos()):Angle().y,0))
		return true
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	/*if CurTime() > self.TestT then
		self:AddLayeredSequence(self:SelectWeightedSequence(ACT_IDLE),1)
		self:SetLayerPlaybackRate(1,0.1)
		self:SetLayerLooping(1,true)
		timer.Simple(0.5,function() print(self:IsValidLayer(1)) end)
	self.TestT = CurTime() + 2 end*/
	//self:SetPlaybackRate(1)
	//self:AddGesture(ACT_IDLE)
	//print(self:IsPlayingGesture(ACT_IDLE))
	//print(self:GetArrivalActivity())
	//self:SetArrivalActivity(ACT_MELEE_ATTACK1)
	
	/*if CurTime() > self.OldMeleeTimer then
	for _, backwards in ipairs({"_as_*", "_dmvj_", "_eye_", "_zss_", "_nmrih_"}) do
	if string.find(self:GetClass(), backwards) then
	self.IsUsingOldMeleeAttackSystem = true
	print("found string") else
	if self.IsUsingOldMeleeAttackSystem == false then
	print("didn't find string")
	self.IsUsingOldMeleeAttackSystem = false end
	end end
	self.OldMeleeTimer = CurTime() + 999999999999999999 *999999999999999999 +999999999999999 *99
	end*/

	//print(self.CurrentTask)
	//self:GetBonePosition(self:LookupBone("Bip01 R Hand")
	//print(#util.VJ_GetSNPCsWithActiveSoundTracks())
	//util.ParticleTracerEx( "vortigaunt_beam", self:GetPos(), lpos, false, self:EntIndex(), 2)
	//self.Entity:SetColor(Color(0,0,0))
	//self:ConvarsOnThink()
	self:CustomOnThink()
	
	if self.HasEntitiesToNoCollide == true then self:EntitiesToNoCollideCode() end -- Collison between something
	
	if self.HasSounds == false or self.Dead == true then VJ_STOPSOUND(self.CurrentBreathSound) end
	if self.Dead == false && self.HasBreathSound == true && self.HasSounds == true then
		if CurTime() > self.NextBreathSoundT then
		self.CurrentBreathSound = VJ_CreateSound(self,self.SoundTbl_Breath,self.BreathSoundLevel,math.random(self.BreathSoundPitch1,self.BreathSoundPitch2))
		self.NextBreathSoundT = CurTime() + math.Rand(self.NextSoundTime_Breath1,self.NextSoundTime_Breath2)
		end
	end
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
if GetConVarNumber("ai_disabled") == 0 then
	//if !self:IsOnGround() then self:ClearGoal() end
	self:CustomOnThink_AIEnabled()
	self:DoCustomIdleAnimation()
	//if self:GetEnemy() == nil then self.Alerted = false end
	if self.VJDEBUG_SNPC_ENABLED == true then
		if GetConVarNumber("vj_npc_printenemyclass") == 1 then
		if self:GetEnemy() != nil then print(self:GetClass().."'s Enemy: "..self:GetEnemy():GetClass()) else print(self:GetClass().."'s Enemy: None") end end
		if GetConVarNumber("vj_npc_printseenenemy") == 1 then
		if self:GetEnemy() != nil then print(self:GetClass().." Has Seen an Enemy!") else print(self:GetClass().." Has NOT Seen an Enemy!") end end
		if GetConVarNumber("vj_npc_printalerted") == 1 then
		if self.Alerted == true then print(self:GetClass().." Is Alerted!") else print(self:GetClass().." Is Not Alerted!") end end
		if GetConVarNumber("vj_npc_printtakingcover") == 1 then
		if self.TakingCover == true then print(self:GetClass().." Is Taking Cover") else print(self:GetClass().." Is Not Taking Cover") end end
		if GetConVarNumber("vj_npc_printlastseenenemy") == 1 then PrintMessage(HUD_PRINTTALK, self.LastSeenEnemyTime.." ("..self:GetName()..")") end
	end
	
	self:IdleSoundCode()
	if self.DisableFootStepSoundTimer == false then self:FootStepSoundCode() end
	self:WorldShakeOnMoveCode()

if self.FollowingPlayer == true then
	//print(self:GetTarget())
	//print(self.FollowingPlayerName)
	if GetConVarNumber("ai_ignoreplayers") == 0 then
	if !self.FollowingPlayerName:Alive() then self:FollowPlayerReset() end
	if CurTime() > self.NextFollowPlayerT && IsValid(self.FollowingPlayerName) && self.FollowingPlayerName:Alive() && self.AlreadyBeingHealedByMedic == false then
		local DistanceToPly = self:GetPos():Distance(self.FollowingPlayerName:GetPos())
		self:SetTarget(self.FollowingPlayerName)
		//print(DistanceToPly)
		if DistanceToPly > self.FollowPlayerCloseDistance then
			self.DontStartShooting_FollowPlayer = true
			self:VJ_ACT_FOLLOWTARGET()
		else
			self:StopMoving()
			self.DontStartShooting_FollowPlayer = false
		end
		self.NextFollowPlayerT = CurTime() + self.NextFollowPlayerTime
		end
	else
		self:FollowPlayerReset()
	end
end

/*
//if CurTime() > self.TestT then
	//if type(vACT_Name) != "string" && self:SelectWeightedSequence(vACT_Name) == -1 && self:GetSequenceName(self:SelectWeightedSequence(vACT_Name)) == "Not Found!" then
	//print(self:GetSequenceName(self:GetSequence()))
	//print(self:VJ_GetNPCSchedule())
	local idleanim = self.AnimTbl_IdleStand
	local ideanimrand = VJ_PICKRANDOMTABLE(idleanim)
	if type(ideanimrand) == "number" then ideanimrand = self:GetSequenceName(self:SelectWeightedSequence(ideanimrand)) end
	print(ideanimrand)
	// self:IsCurrentSchedule(SCHED_IDLE_STAND) == true &&
	if self:GetEnemy() == nil && !self:IsMoving() && !self.CurrentSchedule && table.Count(idleanim) > 0 && self:GetSequenceName(self:SelectWeightedSequence(ACT_IDLE)) == self:GetSequenceName(self:GetSequence()) && self:GetSequenceName(self:GetSequence()) != ideanimrand then
		//print("Should Change Anim!")
		self:VJ_ACT_PLAYACTIVITY(ideanimrand,false,0,true,0)
	end
//self.TestT = CurTime() + VJ_GetSequenceDuration(self,ideanimrand)
//end
*/

	if self.PlayerFriendly == true && self.MoveOutOfFriendlyPlayersWay == true && self.VJ_IsBeingControlled == false && (!self.IsVJBaseSNPC_Tank) && CurTime() > self.NextMoveOutOfFriendlyPlayersWayT && GetConVarNumber("ai_ignoreplayers") == 0 /*&& self:GetEnemy() == nil*/ then
	for k,v in ipairs(player.GetAll()) do
		local nigersarenigs = 20
		if self.FollowingPlayer == true then nigersarenigs = 10 end
		if (self:VJ_GetNearestPointToEntityDistance(v)) < nigersarenigs && v:GetVelocity():Length() > 0 && v:GetMoveType() != MOVETYPE_NOCLIP then
			self.NextFollowPlayerT = CurTime() + 2
			self.DoingMoveOutOfFriendlyPlayersWay = true
			//self:SetLastPosition(self:GetPos() + self:GetRight()*math.random(-50,-50))
			self:VJ_SetSchedule(VJ_PICKRANDOMTABLE(self.MoveOutOfFriendlyPlayersWaySchedules))
			timer.Simple(2,function() if IsValid(self) then self.DoingMoveOutOfFriendlyPlayersWay = false end end)
			self.NextMoveOutOfFriendlyPlayersWayT = CurTime() + self.NextMoveOutOfFriendlyPlayersWayTime
			end
		end
	end

/*if self:GetEnemy() != nil then
if self:GetEnemy():GetClass() == "player" then
//if !self:GetEnemy():Alive() then
	self:SetEnemy(NULL)
	self.MyEnemy = NULL
	//self:AddEntityRelationship(self:GetEnemy(),4,10)
	print("Working")
	end
 //end
end*/

//print(self:GetPathTimeToGoal())
//print(self:GetPathDistanceToGoal())
if self.PlayedResetEnemyRunSchedule == true && !self:IsCurrentSchedule(SCHED_FORCED_GO_RUN) == true && (!self.IsVJBaseSNPC_Tank) then
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
end

if self:GetEnemy() != nil then
	if self.IsDoingFaceEnemy == true && self.VJ_IsBeingControlled == false then self:SetAngles(Angle(0,(self:GetEnemy():GetPos()-self:GetPos()):Angle().y,0)) end
	self:DoConstantlyFaceEnemyCode()
	//ENT.ConstantlyFaceEnemy_IfVisible = true -- Should it only face the enemy if it's visible?
	//ENT.ConstantlyFaceEnemy_IfStanding = true -- Should it face the enemy if it's standing?
	//ENT.ConstantlyFaceEnemy_IfMoving = true -- Should it face the enemy if it's moving?
	//ENT.ConstantlyFaceEnemy_IfAttacking = true -- Should it face the enemy when attacking?

	self.ResetedEnemy = false
	self:UpdateEnemyMemory(self:GetEnemy(),self:GetEnemy():GetPos())
	self.LatestEnemyPosition = self:GetEnemy():GetPos()
	self.LatestEnemyClass = self:GetEnemy()
	self.TimeSinceLastSeenEnemy = 0
	if self:GetEnemy():Visible(self) && (self:GetForward():Dot((self:GetEnemy():GetPos() -self:GetPos()):GetNormalized()) > math.cos(math.rad(self.SightAngle))) && (self:GetEnemy():GetPos():Distance(self:GetPos()) < self.SightDistance) then
		self.LastSeenEnemyTime = 0 else
		self.LastSeenEnemyTime = self.LastSeenEnemyTime + 0.1
	end
	
	if self.CallForHelp == true then
		if CurTime() > self.NextCallForHelpT then
		self:CallForHelpCode(self.CallForHelpDistance)
		self.NextCallForHelpT = CurTime() + self.NextCallForHelpTime
		end
	end
end

if CurTime() > self.NextEntityCheckT then
	self:DoEntityRelationshipCheck()
	self:DoMedicCode_FindAllies()
	self:DoMedicCode_HealAlly()
self.NextEntityCheckT = CurTime() + self.NextEntityCheckTime end

if self.ResetedEnemy == false && self.LastSeenEnemyTime > self.LastSeenEnemyTimeUntilReset && (!self.IsVJBaseSNPC_Tank) then
	self.ResetedEnemy = true
	self:ResetEnemy(true)
end

if self:GetEnemy() != nil && self.ResetedEnemy == false then
	if self:GetEnemy():Health() <= 0 or !IsValid(self:GetEnemy()) then
		self.ResetedEnemy = true
		self:ResetEnemy(false)
	end
end

/*if CurTime() > self.TestT then
	self.VJ_PlayingSequence = true
	self:ClearSchedule()
	timer.Simple(0.2,function()
	if self:IsValid() then
	self:VJ_PlaySequence("infectionrise",1,true,self:SequenceDuration(self:LookupSequence("specialidle_sleep")) +3) end end)
self.TestT = CurTime() + self:SequenceDuration("specialidle_sleep") +10 end*/


/*if CurTime() > self.NextEntityCheckT then
local GetNPCs = ents.FindByClass("npc_*")
GetNPCs = table.Add(GetNPCs,ents.FindByClass("monster_*"))
for _, x in ipairs(GetNPCs) do
	if (!ents) then return end
	if (x:GetClass() != self:GetClass() && x:GetClass() != "npc_grenade_frag" && x:IsNPC() && self:Visible(x)) then
	if self:Visible(x) && self.DisableMakingSelfEnemyToNPCs == false then 
		x:AddEntityRelationship(self,D_HT,99) 
	end
	
	if self.HasAllies == true then
	for _,fritbl in ipairs(self.VJ_FriendlyNPCsGroup) do
		//for k,v in ipairs(ents.FindByClass(fritbl)) do
		if string.find(x:GetClass(), fritbl) then
		x:AddEntityRelationship(self,D_LI,99)
		self:AddEntityRelationship(x,D_LI,99)
		end
	 end
	end
	
	if self.HasAllies == true then
	if table.HasValue(self.VJ_FriendlyNPCsSingle,x:GetClass()) then
		x:AddEntityRelationship(self,D_LI,99)
		self:AddEntityRelationship(x,D_LI,99)
		end
	end
	
	if self.CombineFriendly == true then self:CombineFriendlyCode(x) end
	if self.ZombieFriendly == true then self:ZombieFriendlyCode(x) end
	if self.AntlionFriendly == true then self:AntlionFriendlyCode(x) end
	if self.PlayerFriendly == true then self:PlayerAllies(x) end
	if GetConVarNumber("vj_npc_vjfriendly") == 1 then
	if (x.IsVJBaseSNPC) then
		self:VJFriendlyCode(x)
		end
	end
	if self:Visible(x) && self.DisableMakingSelfEnemyToNPCs == false then 
		if x:Visible(self) && (self:GetForward():Dot((x:GetPos() -self:GetPos()):GetNormalized()) > math.cos(math.rad(self.SightAngle))) && x:Disposition(self) == 1 && (x:GetPos():Distance(self:GetPos()) < self.SightDistance) then
		self:DoAlert()
		end
	end
  end
 end
self.NextEntityCheckT = CurTime() + self.NextEntityCheckTime end*/

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
	-- Attack Timers --
if self:GetEnemy() != nil then
	if self.MovementType == VJ_MOVETYPE_AERIAL then self:AerialMove_ChaseEnemy() end
	
	if self.VJ_IsBeingControlled == false then
		if self.MovementType == VJ_MOVETYPE_STATIONARY && self.CanTurnWhileStationary == true then self:FaceCertainEntity(self:GetEnemy(),true) end
		if self.MeleeAttackAnimationFaceEnemy == true && self.MeleeAttack_DoingPropAttack == false && self.Dead == false && timer.Exists("timer_melee_start"..self.Entity:EntIndex()) && timer.TimeLeft("timer_melee_start"..self.Entity:EntIndex()) > 0 then self:FaceCertainEntity(self:GetEnemy(),true) end
		if self.RangeAttackAnimationFaceEnemy == true && self.Dead == false && timer.Exists("timer_range_start"..self.Entity:EntIndex()) && timer.TimeLeft("timer_range_start"..self.Entity:EntIndex()) > 0 then self:FaceCertainEntity(self:GetEnemy(),true) end
		if self.LeapAttackAnimationFaceEnemy == true && self.Dead == false && timer.Exists("timer_leap_start"..self.Entity:EntIndex()) && timer.TimeLeft("timer_leap_start"..self.Entity:EntIndex()) > 0 then self:FaceCertainEntity(self:GetEnemy(),true) end
	end
	//if self.PlayingAttackAnimation == true then self:FaceCertainEntity(self:GetEnemy(),true) end
	self.ResetedEnemy = false
	//self:SetMovementActivity(6.5)
	//self:SetMovementActivity(ACT_WALK)
	self:CustomAttack() -- Custom attack
	-- Melee Attack --------------------------------------------------------------------------------------------------------------------------------------------
if self.HasMeleeAttack == true then
	//print(self:NearestPoint(self:GetEnemy():GetPos() +self:OBBCenter()):Distance(self:GetEnemy():NearestPoint(self:GetPos() +self:GetEnemy():OBBCenter())))
	//PrintMessage(HUD_PRINTTALK,self:VJ_GetNearestPointToEntityDistance(self:GetEnemy()))
	// self:GetEnemy():GetPos():Distance(self:GetPos())
	if self:CanDoCertainAttack("MeleeAttack") == true then
	self:MultipleMeleeAttacks()
	local getproppushorattack = self:PushOrAttackPropsCode()
	local ispropattack = false
	local isnormalattack = false
	if getproppushorattack == true then ispropattack = true end
	if (self:VJ_GetNearestPointToEntityDistance(self:GetEnemy()) < self.MeleeAttackDistance && self:GetEnemy():Visible(self)) then ispropattack = false isnormalattack = true end
	if (isnormalattack == true or ispropattack == true) && (self:GetForward():Dot((self:GetEnemy():GetPos() -self:GetPos()):GetNormalized()) > math.cos(math.rad(self.MeleeAttackAngleRadius))) then
	self.MeleeAttacking = true
	self.RangeAttacking = false
	self.AlreadyDoneMeleeAttackFirstHit = false
	self.IsAbleToMeleeAttack = false
	if self.VJ_IsBeingControlled == false && ispropattack == false then self:FaceCertainEntity(self:GetEnemy(),true) end
	self:CustomOnMeleeAttack_BeforeStartTimer()
	timer.Simple(self.WaitTime_BeforeMeleeAttackSound,function() if IsValid(self) then self:BeforeMeleeAttackSoundCode() end end)
	self.NextAlertSoundT = CurTime() + 0.4
	if self.DisableMeleeAttackAnimation == false then
		self.CurrentAttackAnimation = VJ_PICKRANDOMTABLE(self.AnimTbl_MeleeAttack)
		self.CurrentAttackAnimationDuration = VJ_GetSequenceDuration(self,self.CurrentAttackAnimation) -self.MeleeAttackAnimationDecreaseLengthAmount
		self.PlayingAttackAnimation = true
		timer.Simple(self.CurrentAttackAnimationDuration,function()
			if IsValid(self) then
				self.PlayingAttackAnimation = false
				if self.TimeUntilMeleeAttackDamage == false then self:StopAttacks() end
			end
		end)
		self:VJ_ACT_PLAYACTIVITY(self.CurrentAttackAnimation,false,0,false,self.MeleeAttackAnimationDelay,{SequenceDuration=self.CurrentAttackAnimationDuration})
	end
	if ispropattack == true then self.MeleeAttack_DoingPropAttack = true else self.MeleeAttack_DoingPropAttack = false end
	if self.TimeUntilMeleeAttackDamage == false then
		timer.Create( "timer_range_finished_abletomelee"..self.Entity:EntIndex(), self:DecideAttackTimer(self.NextMeleeAttackTime,self.NextMeleeAttackTime_DoRand), 1, function()
			self.IsAbleToMeleeAttack = true
		end)
	else
		timer.Create( "timer_melee_start"..self.Entity:EntIndex(), self.TimeUntilMeleeAttackDamage, self.MeleeAttackReps, function() if ispropattack == true then self:MeleeAttackCode(true) else self:MeleeAttackCode() end end)
		for tk, tv in ipairs(self.MeleeAttackExtraTimers) do
			self:DoAddExtraAttackTimers("timer_melee_start_"..self:GetClass().."_"..math.random(1,999999),tv,1,"MeleeAttack")
		end
	end
	self:CustomOnMeleeAttack_AfterStartTimer()
  end
 end
end

	-- Range Attack --------------------------------------------------------------------------------------------------------------------------------------------
	if self.NoChaseWhenAbleToRangeAttack == true && (self:GetEnemy():GetPos():Distance(self:GetPos()) < self.RangeDistance) && (self:GetEnemy():GetPos():Distance(self:GetPos()) > self.RangeToMeleeDistance) && self:GetEnemy():Visible(self) /*&& self:CanDoCertainAttack("RangeAttack") == true*/ then
		self.RangeAttack_DisableChasingEnemy = true else
		self.RangeAttack_DisableChasingEnemy = false
		//if GetConVarNumber("vj_npc_nochasingenemy") == 0 then self.DisableChasingEnemy = true end else
		//if GetConVarNumber("vj_npc_nochasingenemy") == 0 then self.DisableChasingEnemy = false end
	end
	
if self.HasRangeAttack == true then
	if self:CanDoCertainAttack("RangeAttack") == true then
	self:MultipleRangeAttacks()
	self:StopMoving()
	self.RangeAttacking = true
	self.IsAbleToRangeAttack = false
	self:CustomOnRangeAttack_BeforeStartTimer()
	if self.DisableRangeAttackAnimation == false then
		self:ClearSchedule()
		self:StopMoving()
		self.CurrentAttackAnimation = VJ_PICKRANDOMTABLE(self.AnimTbl_RangeAttack)
		self.CurrentAttackAnimationDuration = VJ_GetSequenceDuration(self,self.CurrentAttackAnimation) -self.RangeAttackAnimationDecreaseLengthAmount
		self.PlayingAttackAnimation = true
		timer.Simple(self.CurrentAttackAnimationDuration,function()
			if IsValid(self) then
			self.PlayingAttackAnimation = false
			//if self.RangeAttacking == true then self:VJ_SetSchedule(SCHED_CHASE_ENEMY) end
			if self.TimeUntilRangeAttackProjectileRelease == false then self:StopAttacks() end
			end
		end)
		self:VJ_ACT_PLAYACTIVITY(self.CurrentAttackAnimation,false,0,false,self.RangeAttackAnimationDelay,{SequenceDuration=self.CurrentAttackAnimationDuration})
	end
	if self.TimeUntilRangeAttackProjectileRelease == false then
		timer.Create( "timer_range_finished_abletorange"..self.Entity:EntIndex(), self:DecideAttackTimer(self.NextRangeAttackTime,self.NextRangeAttackTime_DoRand), 1, function()
			self.IsAbleToRangeAttack = true
		end)
	else
		timer.Create( "timer_range_start"..self.Entity:EntIndex(), self.TimeUntilRangeAttackProjectileRelease, self.RangeAttackReps, function() self:RangeAttackCode() end)
		for tk, tv in ipairs(self.RangeAttackExtraTimers) do
			self:DoAddExtraAttackTimers("timer_range_start_"..self:GetClass().."_"..math.random(1,999999),tv,1,"RangeAttack")
		end
	end
	self:CustomOnRangeAttack_AfterStartTimer()
 end
end

	-- Leap Attack --------------------------------------------------------------------------------------------------------------------------------------------
if self.HasLeapAttack == true then
	if self:CanDoCertainAttack("LeapAttack") == true then
	self:MultipleLeapAttacks()
	self.LeapAttacking = true
	self.AlreadyDoneLeapAttackFirstHit = false
	self.IsAbleToLeapAttack = false
	if self.LeapAttackAnimationFaceEnemy == true then self:FaceCertainEntity(self:GetEnemy(),true) end
	self:LeapAttackVelocityCode()
	self:CustomOnLeapAttack_BeforeStartTimer()
	self:LeapAttackSoundCode()
	if self.DisableLeapAttackAnimation == false then
		self.CurrentAttackAnimation = VJ_PICKRANDOMTABLE(self.AnimTbl_LeapAttack)
		self.CurrentAttackAnimationDuration = VJ_GetSequenceDuration(self,self.CurrentAttackAnimation) -self.LeapAttackAnimationDecreaseLengthAmount
		self.PlayingAttackAnimation = true
		timer.Simple(self.CurrentAttackAnimationDuration,function()
			if IsValid(self) then
			self.PlayingAttackAnimation = false
			if self.TimeUntilLeapAttackDamage == false then self:StopAttacks() end
			end
		end)
		self:VJ_ACT_PLAYACTIVITY(self.CurrentAttackAnimation,false,0,false,self.LeapAttackAnimationDelay,{SequenceDuration=self.CurrentAttackAnimationDuration})
	end
	if self.TimeUntilLeapAttackDamage == false then
		timer.Create( "timer_leap_finished_abletoleap"..self.Entity:EntIndex(), self:DecideAttackTimer(self.NextLeapAttackTime,self.NextLeapAttackTime_DoRand), 1, function()
			self.IsAbleToLeapAttack = true
		end)
	else
		timer.Create( "timer_leap_start"..self.Entity:EntIndex(), self.TimeUntilLeapAttackDamage, self.LeapAttackReps, function() self:LeapDamageCode() end)
		for tk, tv in ipairs(self.LeapAttackExtraTimers) do
			self:DoAddExtraAttackTimers("timer_leap_start_"..self:GetClass().."_"..math.random(1,999999),tv,1,"LeapAttack")
		end
	 end
	self:CustomOnLeapAttack_AfterStartTimer()
 end
end
else
	self.TimeSinceLastSeenEnemy = self.TimeSinceLastSeenEnemy + 0.1
	if self.ResetedEnemy == false && (!self.IsVJBaseSNPC_Tank) then self.ResetedEnemy = true self:ResetEnemy() end
	//self:NextThink(CurTime()+10)
	/*if CurTime() > self.NextFindEnemyT then
	if self.DisableFindEnemy == false then self:FindEnemy() end
	self.NextFindEnemyT = CurTime() + self.NextFindEnemyTime end*/
	//self.LeapAttacking = false
	//self.MeleeAttacking = false
	//self.RangeAttacking = false
	end
else
	if self.MovementType == VJ_MOVETYPE_AERIAL && self:GetVelocity():Length() > 0 then self:SetLocalVelocity(Vector(0,0,0)) end
	//self:StopAttacks()
	//self:SelectSchedule()
 end
 self:NextThink(CurTime() +0.1)
 return true
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoAddExtraAttackTimers(vName,vTime,vReps,vFunction)
	vName = vName or "timer_unknown"
	vTime = vTime or 0.5
	vReps = vReps or 1
	vFunction = vFunction or print("No Timer Function!")
	local function NigTest()
		if vFunction == "MeleeAttack" then self:MeleeAttackCode() end
		if vFunction == "RangeAttack" then self:RangeAttackCode() end
		if vFunction == "LeapAttack" then self:LeapDamageCode() end
	end

	table.insert(self.AttackTimers,vName)
	timer.Create(vName..self.Entity:EntIndex(), vTime, vReps, function() NigTest() end)
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CanDoCertainAttack(AttackName)
	AttackName = AttackName or "MeleeAttack"
	-- Attack Names: "MeleeAttack" || "RangeAttack" || "LeapAttack"
	if self.vACT_StopAttacks == true or self.Flinching == true or self.VJ_IsBeingControlled == true then return false end
	
	if AttackName == "MeleeAttack" then
		if self.IsAbleToMeleeAttack == true && self.MeleeAttacking == false && self.LeapAttacking == false && self.RangeAttacking == false /*&& self.VJ_PlayingSequence == false*/ then
		// if self.VJ_IsBeingControlled == true then if self.VJ_TheController:KeyDown(IN_ATTACK) then return true else return false end end
		return true
		end
	end

	if AttackName == "RangeAttack" then
		// (self:GetForward():Dot((self:GetEnemy():GetPos() -self:GetPos()):GetNormalized()) > math.cos(math.rad(self.SightAngle)))
		if self.IsAbleToRangeAttack == true && (self:GetEnemy():GetPos():Distance(self:GetPos()) < self.RangeDistance) && (self:GetEnemy():GetPos():Distance(self:GetPos()) > self.RangeToMeleeDistance) && self:GetEnemy():Visible(self) && self.RangeAttacking == false && self.MeleeAttacking == false /*&& self.VJ_PlayingSequence == false*/ then
		return true
		end
	end

	if AttackName == "LeapAttack" then
		if self.IsAbleToLeapAttack == true && self:IsOnGround() && self:GetPos():Distance(self:GetEnemy():GetPos()) < self.LeapDistance && (self:GetPos():Distance(self:GetEnemy():GetPos()) > self.LeapToMeleeDistance) && self:GetEnemy():Visible(self) && self.RangeAttacking == false && self.LeapAttacking == false /*&& self.VJ_PlayingSequence == false*/ then
		return true
		end
	end
	return false
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoPropVisibiltyCheckForPushAttackProps(CheckEnt)
	// argent:NearestPoint(self:GetPos() +argent:OBBCenter()), self:NearestPoint(argent:GetPos() +self:OBBCenter())
	// start = self:NearestPoint(self:GetPos() +self:OBBCenter()),
	// endpos = CheckEnt:NearestPoint(CheckEnt:GetPos() +CheckEnt:OBBCenter()),
	if CheckEnt == NULL or CheckEnt == nil then return end
	tr = util.TraceLine({
		start = self:GetPos(),
		endpos = CheckEnt:GetPos() + CheckEnt:GetUp()*10,
		filter = self
	})
	//print(tr.Entity)
	/*local nig = ents.Create("prop_dynamic") -- Run in Console: lua_run for k,v in ipairs(ents.GetAll()) do if v:GetClass() == "prop_dynamic" then v:Remove() end end
	nig:SetModel("models/hunter/blocks/cube025x025x025.mdl")
	nig:SetPos(tr.HitPos)
	nig:SetAngles(self:GetAngles())
	nig:SetColor(Color(255,0,0))
	nig:Spawn()
	nig:Activate()
	timer.Simple(2,function() nig:Remove() end)*/

	if tr.Entity == NULL or tr.HitWorld == true or tr.HitSky == true then
	return false else return true end
end
// lua_run for k,v in ipairs(player.GetAll()) do v:GetEyeTrace().Entity:SetHealth(100) end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PushOrAttackPropsCode(CustomValuesTbl)
	CustomValuesTbl = CustomValuesTbl or {}
	IsSingleValue = CustomValuesTbl.IsSingleValue or 0
	CustomMeleeDistance = CustomValuesTbl.CustomMeleeDistance or self.MeleeAttackDistance *1.2

	local isanentitytoattack = false
	if self.PushProps == false && self.AttackProps == false then return end
	local valuestoattack
	local dist = Vector(0,0,self:OBBMins().x):Distance(Vector(0,0,self:OBBMaxs().x)) // self:GetCollisionBounds()
	local halfdist = dist /2
	if IsSingleValue == 0 then
		valuestoattack = ents.FindInSphere(self:GetPos(),halfdist + self.MeleeAttackDistance*2) // self.MeleeAttackDistance *5
	else
		valuestoattack = {IsSingleValue}
	end
	for k,v in pairs(valuestoattack) do
	local phys = v:GetPhysicsObject()
	if table.HasValue(self.EntitiesToDestroyClass,v:GetClass()) or v.VJ_AddEntityToSNPCAttackList == true then isanentitytoattack = true end
	if v:GetClass() == "prop_physics" or isanentitytoattack == true then
	//print(self:VJ_GetNearestPointToEntityDistance(v,1))
	//print(self:DoPropVisibiltyCheckForPushAttackProps(v))
	if self:VJ_GetNearestPointToEntityDistance(v,true) < (halfdist+CustomMeleeDistance) && self:DoPropVisibiltyCheckForPushAttackProps(v) /*&& self:Visible(v)*/ && (self:GetForward():Dot((v:GetPos() -self:GetPos()):GetNormalized()) > math.cos(math.rad(self.MeleeAttackAngleRadius / 1.5))) && phys:IsValid() && phys != nil && phys != NULL && v:GetCollisionGroup() != COLLISION_GROUP_DEBRIS && v:GetCollisionGroup() != COLLISION_GROUP_DEBRIS_TRIGGER && v:GetCollisionGroup() != COLLISION_GROUP_DISSOLVING && v:GetCollisionGroup() != COLLISION_GROUP_IN_VEHICLE then
	if isanentitytoattack == true then return true end
	//print("IT SHOULD WORK "..v:GetClass())
	if phys:GetMass() > 4 && phys:GetSurfaceArea() > 800 then
		local selfphys = self:GetPhysicsObject()
		if self.PushProps == true && selfphys:IsValid() && selfphys != nil && selfphys != NULL && selfphys:GetSurfaceArea() >= phys:GetSurfaceArea() && !table.HasValue(self.EntitiesToDestroyClass,v:GetClass()) then
			return true
		end
		if self.AttackProps == true then
		if v:Health() > 0 /*(table.HasValue(self.EntitiesToDestoryModel,v:GetModel()) or table.HasValue(self.EntitiesToDestroyClass,v:GetClass())) &&*/ then
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
function ENT:MeleeAttackCode(IsPropAttack,AttackDist,CustomEnt)
	if self:Health() <= 0 then return end
	if self.vACT_StopAttacks == true then return end
	if self.Flinching == true then return end
	if self.StopMeleeAttackAfterFirstHit == true && self.AlreadyDoneMeleeAttackFirstHit == true then return end
	local IsPropAttack = IsPropAttack or false
	if self.MeleeAttack_DoingPropAttack == true then IsPropAttack = true end
	local MyEnemy = CustomEnt or self:GetEnemy()
	local AttackDist = AttackDist or self.MeleeAttackDamageDistance
	if IsPropAttack == true then AttackDist = (self.MeleeAttackDamageDistance *1.2)/* + 50*/ end
	if self.VJ_IsBeingControlled == false && self.MeleeAttackAnimationFaceEnemy == true && self.MeleeAttack_DoingPropAttack == false then self:FaceCertainEntity(MyEnemy,true) end
	self.MeleeAttacking = true
	self:CustomOnMeleeAttack_BeforeChecks()
	if self.DisableDefaultMeleeAttackCode == true then return end
	local attackthev = ents.FindInSphere(self:GetPos() + self:GetForward(), AttackDist)
	local hitentity = false
	local HasHitGoodProp = false
	if attackthev != nil then
	for _,v in pairs(attackthev) do
	if (v:IsNPC() or (v:IsPlayer() && v:Alive())) && (self:Disposition(v) == 1 or self:Disposition(v) == 2) && (v != self) && (v:GetClass() != self:GetClass()) or v:GetClass() == "prop_physics" or v:GetClass() == "func_breakable_surf" or table.HasValue(self.EntitiesToDestroyClass,v:GetClass()) or v.VJ_AddEntityToSNPCAttackList == true then
	if (self:GetForward():Dot((v:GetPos() -self:GetPos()):GetNormalized()) > math.cos(math.rad(self.MeleeAttackDamageAngleRadius))) then
		//if IsPropAttack == true && self:GetPos():Distance(v:GetPos()) <= AttackDist /2 && v:GetClass() != "prop_physics" && v:GetClass() != "func_breakable_surf" && v:GetClass() != "func_breakable" then continue end
		if IsPropAttack == true && (v:IsPlayer() or v:IsNPC()) then
			//print(self:GetPos():Distance(v:GetPos()))
			//print(self.MeleeAttackDistance)
			//print(self:GetPos():Distance(v:GetPos()) >= self:VJ_GetNearestPointToEntityDistance(v))
			//print(self:VJ_GetNearestPointToEntityDistance(v) <= self.MeleeAttackDistance)
		//if (self:GetPos():Distance(v:GetPos()) <= self:VJ_GetNearestPointToEntityDistance(v) && self:VJ_GetNearestPointToEntityDistance(v) <= self.MeleeAttackDistance) == false then
		if self:VJ_GetNearestPointToEntityDistance(v) > self.MeleeAttackDistance then
		continue end end
		if v:GetClass() == "prop_physics" then
			local phys = v:GetPhysicsObject()
			if phys:IsValid() && phys != nil && phys != NULL then
			//if table.HasValue(self.EntitiesToDestoryModel,v:GetModel()) or table.HasValue(self.EntitiesToDestroyClass,v:GetClass()) or table.HasValue(self.EntitiesToPushModel,v:GetModel()) then
			if self:PushOrAttackPropsCode({IsSingleValue=v,CustomMeleeDistance=AttackDist}) then
			HasHitGoodProp = true
			phys:EnableMotion(true)
			//phys:EnableGravity(true)
			phys:Wake()
			//constraint.RemoveAll(v)
			//if util.IsValidPhysicsObject(v,1) then
			constraint.RemoveConstraints(v,"Weld") //end
			if self.PushProps == true then
			local phys = v:GetPhysicsObject()
			if MyEnemy != nil then
			local niger = phys:GetMass() * 700
			local nigerup = phys:GetMass() * 200
			phys:ApplyForceCenter(MyEnemy:GetPos()+self:GetForward() *niger +self:GetUp()*nigerup)
			//phys:ApplyForceCenter(MyEnemy:GetPos()+self:GetForward() *25000 +self:GetUp()*7000)
			/*if v:GetModel() == "models/props_c17/oildrum001.mdl" then
			phys:ApplyForceCenter(MyEnemy:GetPos()+self:GetForward() *25000 +self:GetUp()*7000) end
			if v:GetModel() == "models/props_borealis/bluebarrel001.mdl" then
			phys:ApplyForceCenter(MyEnemy:GetPos()+self:GetForward() *55000 +self:GetUp()*10000) end*/
			end
		   end
		  end
		 end
		end
		self:CustomOnMeleeAttack_AfterChecks(v)
		if self.DisableDefaultMeleeAttackDamageCode == false then
			local doactualdmg = DamageInfo()
			if self.SelectedDifficulty == 0 then doactualdmg:SetDamage(self.MeleeAttackDamage/2) end -- Easy
			if self.SelectedDifficulty == 1 then doactualdmg:SetDamage(self.MeleeAttackDamage) end -- Normal
			if self.SelectedDifficulty == 2 then doactualdmg:SetDamage(self.MeleeAttackDamage*1.5) end -- Hard
			if self.SelectedDifficulty == 3 then doactualdmg:SetDamage(self.MeleeAttackDamage*2.5) end  -- Hell On Earth
			doactualdmg:SetInflictor(self)
			doactualdmg:SetDamageType(self.MeleeAttackDamageType)
			//doactualdmg:SetDamagePosition(attackthev)
			doactualdmg:SetAttacker(self)
			v:TakeDamageInfo(doactualdmg, self)
		end
			if self.MeleeAttackSetEnemyOnFire == true then v:Ignite(self.MeleeAttackSetEnemyOnFireTime,0) end
			if self.HasMeleeAttackKnockBack == true then v:SetVelocity(self:GetForward()*math.random(self.MeleeAttackKnockBack_Forward1,self.MeleeAttackKnockBack_Forward2) +self:GetUp()*math.random(self.MeleeAttackKnockBack_Up1,self.MeleeAttackKnockBack_Up2) +self:GetRight()*math.random(self.MeleeAttackKnockBack_Right1,self.MeleeAttackKnockBack_Right2)) end
		if (v:IsNPC() && (!VJ_IsHugeMonster)) or (v:IsPlayer()) then
			if self.MeleeAttackBleedEnemy == true then
			self:CustomOnMeleeAttack_BleedEnemy(v)
			local randbleed = math.random(1,self.MeleeAttackBleedEnemyChance) if randbleed == 1 then
			timer.Create("timer_melee_bleedply",self.MeleeAttackBleedEnemyTime,self.MeleeAttackBleedEnemyReps,function() if IsValid(v) then v:TakeDamage(self.MeleeAttackBleedEnemyDamage,self,self) end end) end
			if !v:IsValid() then timer.Remove("timer_melee_bleedply") end
			if v:IsPlayer() then if !v:Alive() then timer.Remove("timer_melee_bleedply") end end
			end
		end
		if v:IsPlayer() then
			v:ViewPunch(Angle(math.random(-1,1)*self.MeleeAttackDamage,math.random(-1,1)*self.MeleeAttackDamage,math.random(-1,1)*self.MeleeAttackDamage))
			if self.HasMeleeAttackDSPSound == true then v:SetDSP(self.MeleeAttackDSPSoundType,false) end
			if self.SlowPlayerOnMeleeAttack == true then
			local walkspeed_before = v:GetWalkSpeed()
			local runspeed_before = v:GetRunSpeed()
			if (!v.VJ_HasAlreadyBeenSlowedDown) then
			v.VJ_HasAlreadyBeenSlowedDown = true
			v.VJ_SlowDownPlayerWalkSpeed = walkspeed_before
			v.VJ_SlowDownPlayerRunSpeed = runspeed_before end
			v:SetWalkSpeed(self.SlowPlayerOnMeleeAttack_WalkSpeed) 
			v:SetRunSpeed(self.SlowPlayerOnMeleeAttack_RunSpeed)
			self:CustomOnMeleeAttack_SlowPlayer(v)
			if self.HasSounds == true then if self.HasSlowPlayerSound == true then
			self.slowplys = CreateSound(v,self.SlowPly) self.slowplys:Play() self.slowplys:SetSoundLevel(100)
			if !v:Alive() then if self.slowplys then self.slowplys:FadeOut(self.SlowPlySoundFadeTime) end end end end
			//timer.Simple(self.SlowPlayerOnMeleeAttackTime,function() v:SetWalkSpeed(255) v:SetRunSpeed(500)
			local slowplayersd_name = self.slowplys
			local slowplayersd_fade = self.SlowPlySoundFadeTime
			timer.Create( "timer_melee_slowply"..self.Entity:EntIndex(), self.SlowPlayerOnMeleeAttackTime, 1, function()
			v:SetWalkSpeed(v.VJ_SlowDownPlayerWalkSpeed) v:SetRunSpeed(v.VJ_SlowDownPlayerRunSpeed)
			v.VJ_HasAlreadyBeenSlowedDown = false
			if slowplayersd_name then slowplayersd_name:FadeOut(slowplayersd_fade) end
			if !IsValid(v) then timer.Remove("timer_melee_slowply") end
			end)
		 end
		end
		VJ_DestroyCombineTurret(self,v)
		if v:GetClass() == "prop_physics" then
			if HasHitGoodProp == true then
			hitentity = true /*else hitentity = false*/ end
		else
			hitentity = true
			end
		end
	  end
	 end
	end
	if hitentity == false then
		self:CustomOnMeleeAttack_Miss()
		if self.MeleeAttackWorldShakeOnMiss == true then util.ScreenShake(self:GetPos(),self.MeleeAttackWorldShakeOnMissAmplitude,self.MeleeAttackWorldShakeOnMissFrequency,self.MeleeAttackWorldShakeOnMissDuration,self.MeleeAttackWorldShakeOnMissRadius) end
		self:MeleeAttackMissSoundCode()
	else
		self:MeleeAttackSoundCode()
		if self.StopMeleeAttackAfterFirstHit == true then self.AlreadyDoneMeleeAttackFirstHit = true /*self:StopMoving()*/ end
	end
	self.MeleeAttacking = true
	//if self.VJ_IsBeingControlled == false && self.MeleeAttackAnimationFaceEnemy == true then self:FaceCertainEntity(MyEnemy,true) end
	timer.Create( "timer_melee_finished"..self.Entity:EntIndex(), self:DecideAttackTimer(self.NextAnyAttackTime_Melee,self.NextAnyAttackTime_Melee_DoRand), 1, function()
		self:StopAttacks()
		//if self.VJ_IsBeingControlled == false then self:FaceCertainEntity(MyEnemy,true) end
		self:DoChaseAnimation()
	end)
	timer.Create( "timer_range_finished_abletomelee"..self.Entity:EntIndex(), self:DecideAttackTimer(self.NextMeleeAttackTime,self.NextMeleeAttackTime_DoRand), 1, function()
		self.IsAbleToMeleeAttack = true
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackCode()
	if self:Health() <= 0 then return end
	if self.vACT_StopAttacks == true then return end
	if self.Flinching == true then return end
	if self.MeleeAttacking == true then return end
	self:StopMoving()
	if self:GetEnemy() != nil then
		self:StopMoving()
		self:RangeAttackSoundCode()
		self.RangeAttacking = true
		self:CustomRangeAttackCode()
		if self.VJ_IsBeingControlled == false && self.RangeAttackAnimationFaceEnemy == true then self:FaceCertainEntity(self:GetEnemy(),true) end
		//if self.VJ_PlayingSequence == false then self:VJ_SetSchedule(SCHED_COMBAT_STAND) end
		//self:PointAtEntity(self:GetEnemy())
		if self.DisableDefaultRangeAttackCode == false then
			local rangeprojectile = ents.Create(self.RangeAttackEntityToSpawn)
			local getposoverride = self:RangeAttackCode_OverrideProjectilePos(rangeprojectile)
			if getposoverride == 0 then
				if self.RangeUseAttachmentForPos == false then
				rangeprojectile:SetPos(self:GetPos()+Vector(0,-8,self.RangeUpPos)) else //self:GetAttachment(self:LookupAttachment("muzzle")).Pos
				rangeprojectile:SetPos(self:GetAttachment(self:LookupAttachment(self.RangeUseAttachmentForPosID)).Pos) end else
				rangeprojectile:SetPos(getposoverride)
			end
			rangeprojectile:SetAngles((self:GetEnemy():GetPos()-rangeprojectile:GetPos()):Angle())
			rangeprojectile:Spawn()
			rangeprojectile:Activate()
			rangeprojectile:SetOwner(self)
			rangeprojectile:SetPhysicsAttacker(self)
			//constraint.NoCollide(self,rangeprojectile,0,0)
			//if self:GetEnemy() != nil then
			local phys = rangeprojectile:GetPhysicsObject()
			if (phys:IsValid()) then
			local ShootPos = self:RangeAttackCode_GetShootPos(rangeprojectile)
			phys:Wake() //:GetNormal() *self.RangeDistance
			phys:SetVelocity(ShootPos)
			end
			self:CustomRangeAttackCode_AfterProjectileSpawn(rangeprojectile)
		end
	end
	timer.Create( "timer_range_finished"..self.Entity:EntIndex(), self:DecideAttackTimer(self.NextAnyAttackTime_Range,self.NextAnyAttackTime_Range_DoRand), 1, function()
		self:StopAttacks()
		self:DoChaseAnimation()
	end)
	timer.Create( "timer_range_finished_abletorange"..self.Entity:EntIndex(), self:DecideAttackTimer(self.NextRangeAttackTime,self.NextRangeAttackTime_DoRand), 1, function()
		self.IsAbleToRangeAttack = true
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:LeapDamageCode()
	if self:Health() <= 0 then return end
	if self.vACT_StopAttacks == true then return end
	if self.Flinching == true then return end
	if self.StopLeapAttackAfterFirstHit == true && self.AlreadyDoneLeapAttackFirstHit == true then return end
	self:CustomOnLeapAttack_BeforeChecks()
	local attackthev = ents.FindInSphere(self:GetPos(),self.LeapAttackDamageDistance)
	if attackthev != nil then
		for _,v in pairs(attackthev) do
		if (v:IsNPC() || (v:IsPlayer() && v:Alive())) && (self:Disposition(v) == 1 or self:Disposition(v) == 2) && (v != self) && (v:GetClass() != self:GetClass()) or (v:GetClass() == "prop_physics") or v:GetClass() == "func_breakable_surf" or v:GetClass() == "func_breakable" then
		self:CustomOnLeapAttack_AfterChecks(v)
		local leapdmg = DamageInfo()
		if self.SelectedDifficulty == 0 then leapdmg:SetDamage(self.LeapAttackDamage/2) end -- Easy
		if self.SelectedDifficulty == 1 then leapdmg:SetDamage(self.LeapAttackDamage) end -- Normal
		if self.SelectedDifficulty == 2 then leapdmg:SetDamage(self.LeapAttackDamage*1.5) end -- Hard
		if self.SelectedDifficulty == 3 then leapdmg:SetDamage(self.LeapAttackDamage*2.5) end  -- Hell On Earth
		leapdmg:SetInflictor(self)
		leapdmg:SetDamageType(self.LeapAttackDamageType)
		leapdmg:SetAttacker(self)
		v:TakeDamageInfo(leapdmg, self)
		if v:IsPlayer() then
			v:ViewPunch(Angle(math.random(-1,1)*self.LeapAttackDamage,math.random(-1,1)*self.LeapAttackDamage,math.random(-1,1)*self.LeapAttackDamage))
		end
		self:MeleeAttackSoundCode()
		if self.StopLeapAttackAfterFirstHit == true then self.AlreadyDoneLeapAttackFirstHit = true /*self:SetLocalVelocity(Vector(0,0,0))*/ end
	end
  end
 end
	timer.Create( "timer_leap_finished"..self.Entity:EntIndex(), self:DecideAttackTimer(self.NextAnyAttackTime_Leap,self.NextAnyAttackTime_Leap_DoRand), 1, function()
		self:StopAttacks()
		self:DoChaseAnimation()
	end)
	timer.Create( "timer_leap_finished_abletoleap"..self.Entity:EntIndex(), self:DecideAttackTimer(self.NextLeapAttackTime,self.NextLeapAttackTime_DoRand), 1, function()
		self.IsAbleToLeapAttack = true
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:LeapAttackVelocityCode()
	self:CustomOnLeapAttackVelocityCode()
	if self.LeapAttackUseCustomVelocity == true then return end
	/*local jumpyaw
	local jumpcode = (self:GetEnemy():GetPos() -self:GetPos()):GetNormal() *500 +self:GetUp() *200 +self:GetForward() *1000
	jumpyaw = jumpcode:Angle().y
	self:SetLocalVelocity(jumpcode)*/

	if self.LeapAttackAnimationFaceEnemy == true then self:FaceCertainEntity(self:GetEnemy(),true) end
	local jumpcode = ((self:GetEnemy():GetPos() + self:OBBCenter()) -(self:GetPos() + self:OBBCenter())):GetNormal()*400 +self:GetForward()*self.LeapAttackVelocityForward +self:GetUp()*self.LeapAttackVelocityUp + self:GetRight()*self.LeapAttackVelocityRight
	self:SetLocalVelocity(jumpcode)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StopAttacks()
	if self:Health() <= 0 then return end
	//self:TaskComplete()
	if self.VJDEBUG_SNPC_ENABLED == true then if GetConVarNumber("vj_npc_printstoppedattacks") == 1 then print(self:GetClass().." Stopped all Attacks!") end end
	self.MeleeAttacking = false
	self.RangeAttacking = false
	self.LeapAttacking = false
	self.AlreadyDoneMeleeAttackFirstHit = false
	self.AlreadyDoneLeapAttackFirstHit = false
	self:DoChaseAnimation()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SelectSchedule()
if self.VJ_IsBeingControlled == true then return end
self:CustomOnSchedule()
if self.DisableSelectSchedule == true then return end
-- If the enemy is out of reach, then make it NULL
if self:GetEnemy() != nil then -- If seen enemy
	if (self:GetEnemy():GetPos():Distance(self:GetPos()) > self.SightDistance) then
		self.TakingCover = false
		self:DoIdleAnimation()
		self:SetEnemy(NULL)
		self:ResetEnemy()
	end
end
if self.PlayingAttackAnimation == false then
-- If the enemy is less than the see distance, then make it chase the enemy
if self:GetEnemy() != nil then
	if (self:GetEnemy():GetPos():Distance(self:GetPos()) < self.SightDistance) then
		//print("schedule = chase")
		//self:UpdateEnemyMemory(self:GetEnemy(),self:GetEnemy():GetPos())
		self:DoChaseAnimation()
	else -- If not then wander
		self.TakingCover = false
		//print("schedule = idle 1")
		self:DoIdleAnimation()
	end
	elseif self.Alerted == true then -- But if it's alerted then...
		self.TakingCover = false
		//print("schedule = idle 2")
		self:DoIdleAnimation()
	else -- Or else...
		self.TakingCover = false
		//print("schedule = idle 3")
		self:DoIdleAnimation()
	end
 end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPlayerSightCode(argent)
	if self.HasOnPlayerSight == false then return end
	if self.OnPlayerSightOnlyOnce == true then if self.OnPlayerSight_AlreadySeen == true then return end end
	if GetConVarNumber("ai_ignoreplayers") == 1 then return end
	if (CurTime() > self.OnPlayerSightNextT) && (argent:IsPlayer()) && (argent:GetPos():Distance(self:GetPos()) < self.OnPlayerSightDistance) && (self:Visible(argent)) && (self:GetForward():Dot((argent:GetPos() -self:GetPos()):GetNormalized()) > math.cos(math.rad(self.SightAngle))) then
	if self.OnPlayerSightDispositionLevel == 1 && self:Disposition(argent) != D_LI && self:Disposition(argent) != D_NU then return end
	if self.OnPlayerSightDispositionLevel == 2 && (self:Disposition(argent) == D_LI or self:Disposition(argent) == D_NU) then return end
	self.OnPlayerSight_AlreadySeen = true
	self:CustomOnPlayerSight(argent)
	self:OnPlayerSightSoundCode()
	if self.OnPlayerSightOnlyOnce == false then self.OnPlayerSightNextT = CurTime() + math.Rand(self.OnPlayerSightNextTime1,self.OnPlayerSightNextTime2) end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DamageByPlayerCode(dmginfo)
if self.HasDamageByPlayer == false then return end
if GetConVarNumber("ai_disabled") == 1 then return end
local theattack = dmginfo:GetAttacker()
	if CurTime() > self.NextDamageByPlayerT then
	if theattack:IsPlayer() && (self:Visible(theattack)) then
	if self.DamageByPlayerDispositionLevel == 1 && self:Disposition(theattack) != D_LI && self:Disposition(theattack) != D_NU then return end
	if self.DamageByPlayerDispositionLevel == 2 && (self:Disposition(theattack) == D_LI or self:Disposition(theattack) == D_NU) then return end
	self:CustomOnDamageByPlayer(dmginfo)
	self:DamageByPlayerSoundCode()
	self.NextDamageByPlayerT = CurTime() + math.Rand(self.DamageByPlayerNextTime1,self.DamageByPlayerNextTime2)
	end
 end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJFriendlyCode(argent)
if self.HasAllies == false then return false end
if GetConVarNumber("vj_npc_vjfriendly") == 0 then return false end
	argent:AddEntityRelationship(self,D_LI,99)
	self:AddEntityRelationship(argent,D_LI,99)
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CombineFriendlyCode(argent)
if self.HasAllies == false then return end
	if table.HasValue(self.HL2_Combine,argent:GetClass()) then
	argent:AddEntityRelationship(self,D_LI,99)
	self:AddEntityRelationship(argent,D_LI,99)
	return true end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ZombieFriendlyCode(argent)
if self.HasAllies == false then return end
	if table.HasValue(self.HL2_Zombies,argent:GetClass()) then
	argent:AddEntityRelationship(self,D_LI,99)
	self:AddEntityRelationship(argent,D_LI,99)
	return true end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AntlionFriendlyCode(argent)
if self.HasAllies == false then return end
	if table.HasValue(self.HL2_Antlions,argent:GetClass()) then
	argent:AddEntityRelationship(self,D_LI,99)
	self:AddEntityRelationship(argent,D_LI,99)
	return true end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PlayerAllies(argent)
if self.HasAllies == false then return end
	if table.HasValue(self.HL2_Resistance,argent:GetClass()) then
	argent:AddEntityRelationship(self,D_LI,99)
	self:AddEntityRelationship(argent,D_LI,99)
	return true end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_ACT_RESETENEMY()
	local vsched = ai_vj_schedule.New("vj_act_resetenemy")
	if self:GetEnemy() != nil then
	vsched:EngTask("TASK_FORGET", self:GetEnemy()) end
	vsched:EngTask("TASK_IGNORE_OLD_ENEMIES", 0)
	self:StartSchedule(vsched)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ResetEnemy(NoResetAlliesSeeEnemy)
	if self.NextResetEnemyT > CurTime() or self:VJ_IsCurrentSchedule(SCHED_ESTABLISH_LINE_OF_FIRE) == true then return end
	local NoResetAlliesSeeEnemy = NoResetAlliesSeeEnemy or false
	if NoResetAlliesSeeEnemy == true then
		local cptisgay = self:CheckAlliesAroundMe(1000)
		if cptisgay.ItFoundAllies == true then
		 for k,v in ipairs(cptisgay.FoundAllies) do
			if v:GetEnemy() != nil && v.LastSeenEnemyTime < self.LastSeenEnemyTimeUntilReset then
				self.ResetedEnemy = false
				return false
				end
			end
		end
	end
	//print(self.LatestEnemyPosition)
	if self.VJDEBUG_SNPC_ENABLED == true then if GetConVarNumber("vj_npc_printresteenemy") == 1 then print(self:GetName().." has reseted its enemy") end end
	if self:GetEnemy() != nil then
	if self.FollowingPlayer == false && self.VJ_PlayingSequence == false && (!self.IsVJBaseSNPC_Tank) && self.LatestEnemyPosition != Vector(0,0,0) then
		self:SetLastPosition(self.LatestEnemyPosition)
		timer.Simple(0.15,function()
		if self:IsValid() then
		if /*self.DisableWandering == false &&*/ self.FollowingPlayer == false && self.VJ_PlayingSequence == false && (!self.IsVJBaseSNPC_Tank) && self.LatestEnemyPosition != Vector(0,0,0) then
		self:VJ_SetSchedule(SCHED_FORCED_GO_RUN)
		self.PlayedResetEnemyRunSchedule = true
		//self:DoIdleAnimation()
		end
	  end
	 end)
	end
	//table.remove(self.CurrentPossibleEnemies,tonumber(self:GetEnemy()))
	//table.Empty(self.CurrentPossibleEnemies)
	self:AddEntityRelationship(self:GetEnemy(),4,10) end
	if IsValid(self.LatestEnemyClass) && self.LatestEnemyClass:IsPlayer() then self:AddEntityRelationship(self.LatestEnemyClass,4,10) end
	self.Alerted = false
	self:SetEnemy(NULL)
	self:SetEnemy(nil)
	self:ClearEnemyMemory()
	self.MyEnemy = NULL
	//self:UpdateEnemyMemory(self,self:GetPos())
	self:VJ_ACT_RESETENEMY()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoAlert()
if self:GetEnemy() == nil then return end
if self.Alerted == true then return end
	self.Alerted = true
	self:CustomOnAlert()
	if CurTime() > self.NextAlertSoundT then
		if self.PlayAlertSoundOnlyOnce == true then
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
	if table.HasValue(self.HL2_Animals,argent:GetClass()) then return false end
	if (argent.VJ_NoTarget) && argent.VJ_NoTarget == true then return end
	if argent:Health() > 0 && self:Disposition(argent) != D_LI then
	if argent:IsPlayer() && GetConVarNumber("ai_ignoreplayers") == 1 then return false end
	if table.HasValue(self.VJ_AddCertainEntityAsFriendly,argent) then return false end
	if table.HasValue(self.VJ_AddCertainEntityAsEnemy,argent) then return true end
	if (argent:IsNPC() && !(argent.FriendlyToVJSNPCs) && argent:Disposition(self) == 1 && argent:Health() > 0) or (argent:IsPlayer() && self.PlayerFriendly == false && GetConVarNumber("ai_ignoreplayers") == 0 && argent:Alive()) then
	//if argent.VJ_NoTarget == false then
	//if (argent.VJ_NoTarget) then if argent.VJ_NoTarget == false then continue end end
	return true else
	return false
	end
 end
 return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoHardEntityCheck()
	/*local GetNPCs = {}
	GetNPCs = ents.FindByClass("npc_*")
	GetNPCs = table.Add(GetNPCs,ents.FindByClass("monster_*"))
	if GetConVarNumber("ai_ignoreplayers") == 0 then
	GetNPCs = table.Add(GetNPCs,player.GetAll()) end
	if (!ents) then return end
	for _, x in pairs(GetNPCs) do
	if (x:GetClass() == self:GetClass() or x:GetClass() == "npc_grenade_frag" or (x.IsVJBaseSNPC_Animal)) then
		if table.HasValue(GetNPCs,x:GetClass()) then
		table.remove(GetNPCs,x:GetClass()) end
		end
	end
	return GetNPCs*/

  local GetEnts = {}
  local k, v
  for k, v in ipairs(ents.GetAll()) do //ents.FindInSphere(self:GetPos(),30000)
  if !v:IsNPC() && !v:IsPlayer() then continue end
    if v:IsNPC() && (v:GetClass() != self:GetClass() && v:GetClass() != "npc_grenade_frag" && v:GetClass() != "bullseye_strider_focus" && (!v.IsVJBaseSNPC_Animal)) && v:Health() > 0 then
      GetEnts[#GetEnts + 1] = v
    end
    if v:IsPlayer() && GetConVarNumber( "ai_ignoreplayers" ) == 0 /*&& v:Alive()*/ then
      GetEnts[#GetEnts + 1] = v
    end
  end
  //table.Merge(GetEnts,self.CurrentPossibleEnemies)
  return GetEnts
end

/*
workshop/lua/entities/npc_vj_creature_base/init.lua:2231: bad argument #1 to 'ipairs' (table expected, got nil)
  1. ipairs - [C]:-1
   2. DoEntityRelationshipCheck - workshop/lua/entities/npc_vj_creature_base/init.lua:2231
    3. unknown - workshop/lua/entities/npc_vj_creature_base/init.lua:1388
*/	
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoEntityRelationshipCheck()
if GetConVarNumber("ai_disabled") == 1 or self.Dead == true then return end
local curposenem = self.CurrentPossibleEnemies
if curposenem == nil then return end
//if CurTime() > self.NextHardEntityCheckT then
	//self.CurrentPossibleEnemies = self:DoHardEntityCheck()
//self.NextHardEntityCheckT = CurTime() + math.random(self.NextHardEntityCheck1,self.NextHardEntityCheck2) end
//print(self:GetName().."'s Enemies:")
//PrintTable(self.CurrentPossibleEnemies)

/*if table.Count(self.CurrentPossibleEnemies) == 0 && CurTime() > self.NextHardEntityCheckT then
	self.CurrentPossibleEnemies = self:DoHardEntityCheck()
self.NextHardEntityCheckT = CurTime() + math.random(50,70) end*/

for k, v in ipairs(curposenem) do
	if !IsValid(v) then table.remove(curposenem,k) continue end
	//if !IsValid(v) then table.remove(self.CurrentPossibleEnemies,tonumber(v)) continue end
	if !IsValid(v) then continue end
	//if v:Health() <= 0 then table.remove(self.CurrentPossibleEnemies,k) continue end
	local entisfri = false
	local vPos = v:GetPos()
	local vClass = v:GetClass()
	local MyPos = self:GetPos()
	local vDistanceToMy = vPos:Distance(MyPos)
	local MyVisibleTov = self:Visible(v)
	if vDistanceToMy > self.SightDistance then continue end
	if self.HasOnPlayerSight == true && v:IsPlayer() then self:OnPlayerSightCode(v) end
	if self.PlayerFriendly == true && v:IsPlayer() && !table.HasValue(self.VJ_AddCertainEntityAsEnemy,v) then entisfri = true continue end
	local sightdistancenum = self.SightDistance
	local radiusoverride = 0
	if (!self.IsVJBaseSNPC_Tank) && v:IsPlayer() && self:GetEnemy() == nil then
		if v:KeyDown(IN_DUCK) && v:GetMoveType() != MOVETYPE_NOCLIP then if self.VJ_IsHugeMonster == true then sightdistancenum = 5000 else sightdistancenum = 2000 end end
		if vDistanceToMy < 350 && ((!v:KeyDown(IN_DUCK) && v:GetVelocity():Length() > 0 && v:GetMoveType() != MOVETYPE_NOCLIP && ((!v:KeyDown(IN_WALK) && (v:KeyDown(IN_FORWARD) or v:KeyDown(IN_BACK) or v:KeyDown(IN_MOVELEFT) or v:KeyDown(IN_MOVERIGHT))) or (v:KeyDown(IN_SPEED) or v:KeyDown(IN_JUMP)))) or (self:VJ_DoPlayerFlashLightCheck(v,20) == true)) then self:SetTarget(v) self:VJ_SetSchedule(SCHED_TARGET_FACE) end
	end
	if (vClass != self:GetClass() && v:IsNPC() /*&& MyVisibleTov*/ && (!v.IsVJBaseSNPC_Animal)) && self:Disposition(v) != D_LI then
	if MyVisibleTov && self.DisableMakingSelfEnemyToNPCs == false then v:AddEntityRelationship(self,D_HT,99) end
	if self.HasAllies == true then
		for _,friclass in ipairs(self.VJ_NPC_Class) do
			if friclass == "CLASS_COMBINE" then entisfri = self:CombineFriendlyCode(v) end
			if friclass == "CLASS_ZOMBIE" then entisfri = self:ZombieFriendlyCode(v) end
			if friclass == "CLASS_ANTLION" then entisfri = self:AntlionFriendlyCode(v) end
			if v:IsNPC() == true && (v.VJ_NPC_Class) && table.HasValue(v.VJ_NPC_Class,friclass) then
				//print("SHOULD WORK:"..v:GetClass())
				entisfri = true
				v:AddEntityRelationship(self,D_LI,99)
				self:AddEntityRelationship(v,D_LI,99)
			end
		end
	
		for _,fritbl in ipairs(self.VJ_FriendlyNPCsGroup) do
			//for k,v in ipairs(ents.FindByClass(fritbl)) do
			if string.find(vClass, fritbl) then
				entisfri = true
				v:AddEntityRelationship(self,D_LI,99)
				self:AddEntityRelationship(v,D_LI,99)
			end
		end
		if table.HasValue(self.VJ_FriendlyNPCsSingle,vClass) then
			entisfri = true
			v:AddEntityRelationship(self,D_LI,99)
			self:AddEntityRelationship(v,D_LI,99)
		end
		if self.CombineFriendly == true then self:CombineFriendlyCode(v) end
		if self.ZombieFriendly == true then self:ZombieFriendlyCode(v) end
		if self.AntlionFriendly == true then self:AntlionFriendlyCode(v) end
		if self.PlayerFriendly == true then
			self:PlayerAllies(v)
			if self.FriendsWithAllPlayerAllies == true && v.PlayerFriendly == true && v.FriendsWithAllPlayerAllies == true then
				v:AddEntityRelationship(self,D_LI,99)
				self:AddEntityRelationship(v,D_LI,99)
			end
		end
		if v.IsVJBaseSNPC == true then self:VJFriendlyCode(v) end
		end
	end
	if self.DisableFindEnemy == false then
	if self.UseSphereForFindEnemy == false && radiusoverride == 0 then
	if MyVisibleTov && (self:GetForward():Dot((vPos -MyPos):GetNormalized()) > math.cos(math.rad(self.SightAngle))) && (vDistanceToMy < sightdistancenum) then
	if self:DoRelationshipCheck(v) == true then
	//if (v.VJ_NoTarget && v.VJ_NoTarget != true) then continue end
		self:AddEntityRelationship(v,D_HT,99)
		self:VJ_DoSetEnemy(v,true,true)
		//if self:GetEnemy() == nil then
			//self:VJ_DoSetEnemy(v,true)
			//end
		end
	 end
	end
	if self.UseSphereForFindEnemy == true or radiusoverride == 1 then
	if MyVisibleTov && (vDistanceToMy < sightdistancenum) then
	if self:DoRelationshipCheck(v) == true then
		self:AddEntityRelationship(v,D_HT,99)
		self:VJ_DoSetEnemy(v,true,true)
		//if self:GetEnemy() == nil then
			//self:VJ_DoSetEnemy(v,true)
			//end
		end
	end
   end
  end
  //return true
 end
//return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
/*function ENT:Distance(entity)
	return self:GetPos():Distance(entity:GetPos())
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetClosestInTable(tb)
	local nt = {}
	for k,v in ipairs(tb) do
	nt[self:Distance(v)] = self:Distance( v )
	end
 return table.SortByKey(nt,true)[1]
end*/
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FindEnemy()
//self:AddRelationship( "npc_barnacle  D_LI  99" )
if self.UseSphereForFindEnemy == true then
	self:FindEnemySphere()
end
//if self.UseConeForFindEnemy == false then return end -- NOTE: This function got crossed out because the option at the top got deleted!
local EnemyTargets = VJ_FindInCone(self:GetPos(),self:GetForward(),self.SightDistance,self.SightAngle)
//local LocalTargetTable = {}
if (!EnemyTargets) then return end
//table.Add(EnemyTargets)
for k,v in pairs(EnemyTargets) do
	/*if (v:GetClass() != self:GetClass() && v:GetClass() != "npc_grenade_frag") && v:IsNPC() or (v:IsPlayer() && self.PlayerFriendly == false && GetConVarNumber("ai_ignoreplayers") == 0) && self:Visible(v) then
	if self.CombineFriendly == true then if table.HasValue(self.HL2_Combine,v:GetClass()) then return end end
	if self.ZombieFriendly == true then if table.HasValue(self.HL2_Zombies,v:GetClass()) then return end end
	if self.AntlionFriendly == true then if table.HasValue(self.HL2_Antlions,v:GetClass()) then return end end
	if self.PlayerFriendly == true then if table.HasValue(self.HL2_Resistance,v:GetClass()) then return end end
	if GetConVarNumber("vj_npc_vjfriendly") == 1 then
	local frivj = ents.FindByClass("npc_vj_*") table.Add(frivj) for _, x in pairs(frivj) do return end end
	local vjanimalfriendly = ents.FindByClass("npc_vjanimal_*") table.Add(vjanimalfriendly) for _, x in pairs(vjanimalfriendly) do return end
	//self:AddEntityRelationship( v, D_HT, 99 )
	if !v:IsPlayer() then if self:Visible(v) then v:AddEntityRelationship( self, D_HT, 99 ) end end*/
	if self:DoRelationshipCheck(v) == true && self:Visible(v) then
	self.ResetedEnemy = true
	self:AddEntityRelationship(v,D_HT,99)
	self:SetEnemy(v) //self:GetClosestInTable(EnemyTargets)
	self.MyEnemy = v
	self:UpdateEnemyMemory(v,v:GetPos())
	//table.insert(LocalTargetTable,v)
	//self.EnemyTable = LocalTargetTable
	self:DoAlert()
	//return
  end
 end
 //self:ResetEnemy()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FindEnemySphere()
local EnemyTargets = ents.FindInSphere(self:GetPos(),self.SightDistance)
if (!EnemyTargets) then return end
table.Add(EnemyTargets)
for k,v in pairs(EnemyTargets) do
	if self:DoRelationshipCheck(v) == true && self:Visible(v) then
	self.ResetedEnemy = true
	self:AddEntityRelationship(v,D_HT,99)
	self:SetEnemy(v)
	self.MyEnemy = v
	self:UpdateEnemyMemory(v,v:GetPos())
	self:DoAlert()
	//return
  end
 end
end
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
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CallForHelpCode(SeeDistance)
if self.ThrowingGrenade == true then return end
if self.CallForHelp == false then return end
	local getselfclass = ents.FindInSphere(self:GetPos(),SeeDistance)
	local LocalTargetTable = {}
	if (!getselfclass) then return end
	for _,x in pairs(getselfclass) do
	if x:IsNPC() && x != self /*&& x:GetClass() == self:GetClass()*/ && x:Disposition(self) != 1 && x:Disposition(self) != 2 && x.IsVJBaseSNPC == true && x.IsVJBaseSNPC_Animal != false && x.FollowingPlayer == false && x.VJ_IsBeingControlled == false && (!x.IsVJBaseSNPC_Tank) && (x:GetClass() == self:GetClass() or x:Disposition(self) != 4) then
	if x.BringFriendsOnDeath == true or x.CallForBackUpOnDamage == true or x.CallForHelp == true then
	//if x:DoRelationshipCheck(self:GetEnemy()) == true then
	table.insert(LocalTargetTable,x)
	if x:GetEnemy() == nil && x:Disposition(self:GetEnemy()) != D_LI /*&& !self:IsCurrentSchedule(SCHED_FORCED_GO_RUN) == true && !self:IsCurrentSchedule(SCHED_FORCED_GO) == true*/ then
	self:CustomOnCallForHelp()
	self:CallForHelpSoundCode()
	//timer.Simple(1,function() if IsValid(self) && IsValid(x) then x:OnReceiveOrderSoundCode() end end)
	x:OnReceiveOrderSoundCode()
	if self.HasCallForHelpAnimation == true && CurTime() > self.NextCallForHelpAnimationT then
		self:VJ_ACT_PLAYACTIVITY(VJ_PICKRANDOMTABLE(self.AnimTbl_CallForHelp),self.CallForHelpStopAnimations,self.CallForHelpStopAnimationsTime,self.CallForHelpAnimationFaceEnemy,self.CallForHelpAnimationDelay,{PlayBackRate=self.CallForHelpAnimationPlayBackRate})
	self.NextCallForHelpAnimationT = CurTime() + self.NextCallForHelpAnimationTime end
	if self:GetPos():Distance(x:GetPos()) < SeeDistance then
	//PrintTable(LocalTargetTable)
	if (CurTime() > x.NextChaseTime) then
		if IsValid(self:GetEnemy()) && self:GetEnemy() != nil then
			if self:GetEnemy():IsPlayer() && x.PlayerFriendly == true then
				table.insert(x.VJ_AddCertainEntityAsEnemy,self:GetEnemy())
			end
			x:VJ_DoSetEnemy(self:GetEnemy(),true)
			x:SetTarget(self:GetEnemy())
			if x:Visible(self:GetEnemy()) then
			x:VJ_SetSchedule(SCHED_TARGET_FACE) else
			x:DoChaseAnimation() end 
		else
			local randompostogo = math.random(1,4)
				if randompostogo == 1 then x:SetLastPosition(self:GetPos() + self:GetRight()*math.random(20,50)) else
				if randompostogo == 2 then x:SetLastPosition(self:GetPos() + self:GetRight()*math.random(-20,-50)) end
				if randompostogo == 3 then x:SetLastPosition(self:GetPos() + self:GetForward()*math.random(20,50)) end
				if randompostogo == 4 then x:SetLastPosition(self:GetPos() + self:GetForward()*math.random(-20,-50)) end
			end
			x:VJ_SetSchedule(SCHED_FORCED_GO_RUN)
			end
		//end
	  end
	 end
	end
   end
  end
 end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CheckAlliesAroundMe(SeeDistance)
	SeeDistance = SeeDistance or 800
	local FoundEntitiesTbl = {}
	local getselfclass = ents.FindInSphere(self:GetPos(),SeeDistance)
	if (!getselfclass) then return end
	for _,x in pairs(getselfclass) do
	if (x:IsNPC() or x:GetClass() == self:GetClass()) && x != self /*&& x:GetClass() == self:GetClass()*/ && x:Disposition(self) != 1 && x:Disposition(self) != 2 && (x:GetClass() == self:GetClass() or x:Disposition(self) != 4) && x.IsVJBaseSNPC_Animal != false then
	if x.BringFriendsOnDeath == true or x.CallForBackUpOnDamage == true or x.CallForHelp == true then
	table.insert(FoundEntitiesTbl,x)
	//print(x:GetClass())
	end
  end
 end
 if table.Count(FoundEntitiesTbl) > 0 then
 return {ItFoundAllies = true, FoundAllies = FoundEntitiesTbl} else
 return {ItFoundAllies = false, FoundAllies = nil} end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BringAlliesToMe(SeeDistance,CertainAmount,CertainAmountNumber,EnemyVisibleOnly)
	//if self.CallForBackUpOnDamage == false then return end
	SeeDistance = SeeDistance or 800
	EnemyVisibleOnly = EnemyVisibleOnly or false
	CertainAmountNumber = CertainAmountNumber or 3
	local getselfclass = ents.FindInSphere(self:GetPos(),SeeDistance)
	local LocalTargetTable = {}
	if (!getselfclass) then return end
	for _,x in pairs(getselfclass) do
	if x:IsNPC() && x != self /*&& x:GetClass() == self:GetClass()*/ && x:Disposition(self) != 1 && x:Disposition(self) != 2 && (x:GetClass() == self:GetClass() or x:Disposition(self) != 4) && x.IsVJBaseSNPC_Animal != false && x.FollowingPlayer == false && x.VJ_IsBeingControlled == false && (!x.IsVJBaseSNPC_Tank) then
	if x.BringFriendsOnDeath == true or x.CallForBackUpOnDamage == true or x.CallForHelp == true then
	if EnemyVisibleOnly == true then if x:Visible(self) == false then continue end end
	table.insert(LocalTargetTable,x)
	if x:GetEnemy() == nil then
	if self:GetPos():Distance(x:GetPos()) < SeeDistance then
	//print(table.ToString(LocalTargetTable,"stupid table",true)) //end
	local randompostogo = math.random(1,4)
		if randompostogo == 1 then x:SetLastPosition(self:GetPos() + self:GetRight()*math.random(20,50)) else
		if randompostogo == 2 then x:SetLastPosition(self:GetPos() + self:GetRight()*math.random(-20,-50)) end
		if randompostogo == 3 then x:SetLastPosition(self:GetPos() + self:GetForward()*math.random(20,50)) end
		if randompostogo == 4 then x:SetLastPosition(self:GetPos() + self:GetForward()*math.random(-20,-50)) end
	end
	if x.VJ_PlayingSequence == false then
	local randommovesched = math.random(1,2)
	if randommovesched == 1 then x:VJ_SetSchedule(self.BringFriendsToMeSCHED1) end
	if randommovesched == 2 then x:VJ_SetSchedule(self.BringFriendsToMeSCHED2) end
	end
	//return true -- It will only pick one if returning false or true
	end
   end
   if CertainAmount == true then
   if table.Count(LocalTargetTable) == CertainAmountNumber then 
   return true end
	end
   end
  end
 end
 //print(table.ToString(LocalTargetTable,"stupid table",true))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage(dmginfo,data)
if self.Dead == true then return false end
if self.GodMode == true then return false end
if dmginfo:GetDamage() <= 0 then return false end
	self:CustomOnTakeDamage_BeforeImmuneChecks(dmginfo)

if self.GetDamageFromIsHugeMonster == true then
	local DamageInflictor = dmginfo:GetInflictor()
	local DamageAttacker = dmginfo:GetAttacker()
		if DamageAttacker.VJ_IsHugeMonster == true then
		self:SetHealth(self:Health() -dmginfo:GetDamage())
	end
	if self:Health() <= 0 && self.Dead == false then
		self:PriorToKilled(dmginfo,hitgroup)
	end
end

local DamageInflictor = dmginfo:GetInflictor()
local DamageAttacker = dmginfo:GetAttacker()
local DamageType = dmginfo:GetDamageType()
local DamageAttackerClass = DamageAttacker:GetClass()
local hitgroup = self.VJ_ScaleHitGroupDamage

	if (self:IsOnFire()) && self:WaterLevel() == 3 then self:Extinguish() end

	if table.HasValue(self.ImmuneDamagesTable,DamageType) then return end
	if self.AllowIgnition == false then if (self:IsOnFire()) then self:Extinguish() return false end end
	if self.Immune_Bullet == true then if dmginfo:IsBulletDamage() then return false end end
	if self.Immune_Physics == true then if DamageType == DMG_CRUSH then return false end end
	if self.Immune_Blast == true then if DamageType == DMG_BLAST then return false end end
	if self.Immune_Freeze == true then
		if DamageType == DMG_SLOWFREEZE then return false end
		if DamageType == DMG_FREEZE then return false end
	end
	if self.Immune_Electricity == true then
		if DamageType == DMG_SHOCK then return false end
		if DamageType == DMG_SONIC then return false end
		if DamageType == DMG_ENERGYBEAM then return false end
	end
	if self.Immune_AcidPoisonRadiation == true then
		if DamageType == DMG_ACID then return false end
		if DamageType == DMG_RADIATION then return false end
		if DamageType == DMG_POISON then return false end
		if DamageType == DMG_NERVEGAS then return false end
	end
	if IsValid(DamageInflictor) && DamageAttackerClass == "prop_combine_ball" && self.Immune_CombineBall == true then return false end

self:CustomOnTakeDamage_BeforeGetDamage(dmginfo,hitgroup)
//if ( hitgroup == HITGROUP_HEAD ) then
/*local hitgroup = self.VJ_ScaleHitGroupDamage
if hitgroup == 11 then
	//print("Hitgroup code ran!")
	dmginfo:ScaleDamage(0)
end*/

if self.Bleeds == true && dmginfo:GetDamage() > 0 then -- If it bleeds then do this functions
	self:CustomOnTakeDamage_OnBleed(dmginfo,hitgroup)
	if self.HasBloodParticle == true then self:SpawnBloodParticles(dmginfo,hitgroup) end
	if self.HasBloodDecal == true then self:SpawnBloodDecal(dmginfo,hitgroup) end
	self:ImpactSoundCode()
end

self:SetHealth(self:Health() -dmginfo:GetDamage())

if self:Health() >= 0 then
if self.CallForBackUpOnDamage == true then
if CurTime() > self.NextBackUpOnDamageT then
if self:GetEnemy() == nil && self.FollowingPlayer == false then
if self:CheckAlliesAroundMe(self.CallForBackUpOnDamageDistance).ItFoundAllies == true then
	self:BringAlliesToMe(self.CallForBackUpOnDamageDistance,self.CallForBackUpOnDamageUseCertainAmount,self.CallForBackUpOnDamageUseCertainAmountNumber)
	self:ClearSchedule()
	//self.TakingCover = true
	self.Flinching = true
	if self.DisableCallForBackUpOnDamageAnimation == false then
	timer.Simple(0.1,function()
		if IsValid(self) then self:VJ_ACT_PLAYACTIVITY(VJ_PICKRANDOMTABLE(self.CallForBackUpOnDamageAnimation),true,self.CallForBackUpOnDamageAnimationTime,true) end end)
	end
	if self.CallForBackUpOnDamageUseSCHED == true && self.VJ_PlayingSequence == false then
		self:VJ_SetSchedule(self.CallForBackUpOnDamageUseSCHEDID)
	end
	timer.Simple(1,function()
		if self:IsValid() then
		//self.TakingCover = false
		self.Flinching = false
		end
	end)
   end
  end
 self.NextBackUpOnDamageT = CurTime() + math.random(self.NextBackUpOnDamageTime1,self.NextBackUpOnDamageTime2)
 end
end

	if self.VJDEBUG_SNPC_ENABLED == true then if GetConVarNumber("vj_npc_printondamage") == 1 then print(self:GetClass().." Got Damaged! | Amount = "..dmginfo:GetDamage()) end end
    self:CustomOnTakeDamage_AfterImmuneChecks(dmginfo,hitgroup)
	self:DoFlinch(dmginfo,hitgroup)
	self:PainSoundCode()
	
	/*if (dmginfo:GetAttacker():IsPlayer() or dmginfo:GetAttacker():IsNPC()) and dmginfo:GetAttacker():GetActiveWeapon():GetClass() == "weapon_crossbow" then --GetInflictor seems not to work in this case.
	local mdlBolt = ents.Create("prop_dynamic_override")
	mdlBolt:SetAngles(dmginfo:GetAttacker():GetAngles())
	mdlBolt:SetModel("models/crossbow_bolt.mdl")
	mdlBolt:Spawn()
	mdlBolt:SetParent(self)
	mdlBolt:SetPos(dmginfo:GetDamagePosition())
	end*/
	
if self.BecomeEnemyToPlayer == true && DamageAttacker:IsPlayer() && GetConVarNumber("ai_disabled") == 0 && GetConVarNumber("ai_ignoreplayers") == 0 && (self:Disposition(DamageAttacker) == D_LI or self:Disposition(DamageAttacker) == D_NU) then
	if self.AngerLevelTowardsPlayer <= self.BecomeEnemyToPlayerLevel then
	self.AngerLevelTowardsPlayer = self.AngerLevelTowardsPlayer + 1 end
	if self.AngerLevelTowardsPlayer > self.BecomeEnemyToPlayerLevel then
	if self:Disposition(DamageAttacker) != D_HT then
	self:CustomWhenBecomingEnemyTowardsPlayer(dmginfo,hitgroup)
	if self.FollowingPlayer == true then self:FollowPlayerReset() end
	table.insert(self.VJ_AddCertainEntityAsEnemy,dmginfo:GetAttacker())
	if GetConVarNumber("vj_npc_nosnpcchat") == 0 then
	dmginfo:GetAttacker():PrintMessage(HUD_PRINTTALK, self:GetName().." no longer likes you.") end
	self:BecomeEnemyToPlayerSoundCode() end
	//self.NoLongerLikesThePlayer = true
	self.Alerted = true
	if self.BecomeEnemyToPlayerSetPlayerFriendlyFalse == true then
	/*self.PlayerFriendly = false*/ end
	end
end

if self.DisableTakeDamageFindEnemy == false && self.TakingCover == false && self.VJ_IsBeingControlled == false && GetConVarNumber("ai_disabled") == 0 then
//if self.Alerted == false then
if self:GetEnemy() == nil then
local MyNearbyTargetssp = ents.FindInSphere(self:GetPos(),5000)
if (!MyNearbyTargetssp) then return end
	for k,v in pairs(MyNearbyTargetssp) do
	    if self:DoRelationshipCheck(v) == true then
   		self:VJ_DoSetEnemy(v,true)
		self:DoChaseAnimation() else
		if CurTime() > self.NextRunAwayOnDamageT then
		if self.FollowingPlayer == false && self.VJ_PlayingSequence == false && self.RunAwayOnUnknownDamage == true && self.MovementType != VJ_MOVETYPE_STATIONARY then
		self:VJ_SetSchedule(SCHED_RUN_FROM_ENEMY) end
		self.NextRunAwayOnDamageT = CurTime() + self.NextRunAwayOnDamageTime
	 end
	end
   end
  end
 end
end

if self:Health() <= 0 && self.Dead == false then
	self:PriorToKilled(dmginfo,hitgroup)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoFlinch(dmginfo,hitgroup)
	if self.Flinches == 0 then return end
	if self.Flinching == true then return end
	local function FlinchMotherFucka()
		if self.HasHitGroupFlinching == true then
			local HitGroupHit = false
			for k,v in ipairs(self.FlinchHitGroupTable) do
				if table.HasValue(v.HitGroup,hitgroup) then
				//if v.HitGroup == hitgroup then
					HitGroupHit = true
					self.Flinching = true
					self:StopAttacks()
					if v.IsSchedule == true then self:VJ_SetSchedule(VJ_PICKRANDOMTABLE(v.Animation)) else self:VJ_ACT_PLAYACTIVITY(VJ_PICKRANDOMTABLE(v.Animation),false,0,false,0) end
					timer.Simple(self.NextFlinch,function() if IsValid(self) then self.Flinching = false if self:GetEnemy() != nil then self:DoChaseAnimation() else self:DoIdleAnimation() end end end)
					self:CustomOnFlinch_AfterFlinch(dmginfo,hitgroup)
					end
				end
				if HitGroupHit == false && self.DefaultFlinchingWhenNoHitGroup == true then
					self.Flinching = true
					self:StopAttacks()
					if self.FlinchUseACT == false then self:VJ_SetSchedule(VJ_PICKRANDOMTABLE(self.FlinchingSchedules)) else self:VJ_ACT_PLAYACTIVITY(VJ_PICKRANDOMTABLE(self.AnimTbl_Flinch),false,0,false,0) end
					timer.Simple(self.NextFlinch,function() if IsValid(self) then self.Flinching = false if self:GetEnemy() != nil then self:DoChaseAnimation() else self:DoIdleAnimation() end end end)
					self:CustomOnFlinch_AfterFlinch(dmginfo,hitgroup)
				end
			else
				self.Flinching = true
				self:StopAttacks()
				if self.FlinchUseACT == false then self:VJ_SetSchedule(VJ_PICKRANDOMTABLE(self.FlinchingSchedules)) else self:VJ_ACT_PLAYACTIVITY(VJ_PICKRANDOMTABLE(self.AnimTbl_Flinch),false,0,false,0) end
				timer.Simple(self.NextFlinch,function() if IsValid(self) then self.Flinching = false if self:GetEnemy() != nil then self:DoChaseAnimation() else self:DoIdleAnimation() end end end)
				self:CustomOnFlinch_AfterFlinch(dmginfo,hitgroup)
			end
	end
	local randflinchchance = math.random(1,self.FlinchingChance)
	if randflinchchance == 1 then
	self:CustomOnFlinch_BeforeFlinch(dmginfo,hitgroup)
	if self.Flinches == 2 && table.HasValue(self.FlinchCustomDMGs,dmginfo:GetDamageType()) then
		FlinchMotherFucka()
	elseif self.Flinches == 1 then
		FlinchMotherFucka()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SpawnBloodDecal(dmginfo,hitgroup)
	local dmgforce = dmginfo:GetDamageForce()
	local length = math.Clamp(dmgforce:Length() *10, 100, self.BloodDecalDistance)
	local paintit = tobool(math.random(10, math.Round(length *0.125)) <= self.BloodDecalRate)
	if !paintit then return end
	local startpos = dmginfo:GetDamagePosition()
	local posEnd = startpos +dmgforce:GetNormal() *length
	local tr = util.TraceLine({start = startpos, endpos = posEnd, filter = self})
	if !tr.HitWorld then return end
	util.Decal(VJ_PICKRANDOMTABLE(self.BloodDecal),tr.HitPos +tr.HitNormal,tr.HitPos -tr.HitNormal)
	if math.random(1,2) == 1 then
	util.Decal(VJ_PICKRANDOMTABLE(self.BloodDecal),tr.HitPos +tr.HitNormal +Vector(0,math.random(-100,100),0),tr.HitPos -tr.HitNormal) end
	if math.random(1,2) == 1 then
	util.Decal(VJ_PICKRANDOMTABLE(self.BloodDecal),tr.HitPos +tr.HitNormal +Vector(math.random(-100,100),0,0),tr.HitPos -tr.HitNormal) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SpawnBloodParticles(dmginfo,hitgroup)
	local DamageType = dmginfo:GetDamageType()
	if DamageType == DMG_ACID then self:DamageParticleCodes(dmginfo) return false end
	if DamageType == DMG_RADIATION then self:DamageParticleCodes(dmginfo) return false end
	if DamageType == DMG_POISON then self:DamageParticleCodes(dmginfo) return false end
	if DamageType == DMG_CRUSH then self:DamageParticleCodes(dmginfo) return false end
	if DamageType == DMG_SLASH then self:DamageParticleCodes(dmginfo) return false end
	if DamageType == DMG_GENERIC then self:DamageParticleCodes(dmginfo) return false end
	if ( self:IsOnFire() ) then self:DamageParticleCodes(dmginfo) return false end

	local bloodeffect = ents.Create("info_particle_system")
	bloodeffect:SetKeyValue("effect_name",VJ_PICKRANDOMTABLE(self.BloodParticle))
	bloodeffect:SetPos(dmginfo:GetDamagePosition()) 
	bloodeffect:Spawn()
	bloodeffect:Activate() 
	bloodeffect:Fire("Start","",0)
	bloodeffect:Fire("Kill","",0.1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DamageParticleCodes(dmginfo)
	local bloodeffect = ents.Create("info_particle_system")
	bloodeffect:SetKeyValue("effect_name",VJ_PICKRANDOMTABLE(self.BloodParticle))
	bloodeffect:SetPos(self:GetPos() + self:OBBCenter()) // + Vector(self.BrokenBloodSpawnRight, self.BrokenBloodSpawnBack, self.BrokenBloodSpawnUp)
	bloodeffect:Spawn()
	bloodeffect:Activate() 
	bloodeffect:Fire("Start", "", 0)
	bloodeffect:Fire("Kill", "", 0.1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PriorToKilled(dmginfo,hitgroup)
	if self.BringFriendsOnDeath == true then
		self:BringAlliesToMe(self.BringFriendsOnDeathDistance,self.BringFriendsOnDeathUseCertainAmount,self.BringFriendsOnDeathUseCertainAmountNumber,true)
	end

	if self.Medic_IsHealingAlly == true then self:DoMedicCode_Reset() end
	
	local function DoKilled()
		if IsValid(self) then
		if self.WaitBeforeDeathTime == 0 then self:Killed(dmginfo,hitgroup) else
		timer.Simple(self.WaitBeforeDeathTime,function() if IsValid(self) then self:Killed(dmginfo,hitgroup) end end)
		end
	 end
	end

	-- Blood decal on the ground
	if self.Bleeds == true then
		self:SetLocalPos(Vector(self:GetPos().x,self:GetPos().y,self:GetPos().z +4)) -- Because the NPC is too close to the ground
		local tr = util.TraceLine({
		start = self:GetPos(),
		endpos = self:GetPos() - Vector(0, 0, 500),
		filter = self //function( ent ) if ( ent:GetClass() == "prop_physics" ) then return true end end
		})
		util.Decal(VJ_PICKRANDOMTABLE(self.BloodDecal),tr.HitPos+tr.HitNormal,tr.HitPos-tr.HitNormal)
	end

	self.Dead = true
		self:RemoveAttackTimers()
		self.MeleeAttacking = false
		self.RangeAttacking = false
		self.LeapAttacking = false
		self.HasRangeAttack = false
		self.HasMeleeAttack = false
		self:StopAllCommonSounds()
	self:DeathNotice_PlayerPoints(dmginfo,hitgroup)
	self:CustomOnPriorToKilled(dmginfo,hitgroup)
	self:SetCollisionGroup(1)
	if GetConVarNumber("vj_npc_nogib") == 0 then self:GibCode(dmginfo,hitgroup) end
	self:DeathSoundCode()
	if self.HasDeathAnimation != true then DoKilled() return end
	if self.HasDeathAnimation == true then
		if GetConVarNumber("vj_npc_nodeathanimation") == 1 or GetConVarNumber("ai_disabled") == 1 or dmginfo:GetDamageType() == 67108865 then DoKilled() return end
			if dmginfo:GetDamageType() != 67108865 then
			local randanim = math.random(1,self.DeathAnimationChance)
			if randanim != 1 then DoKilled() return end
			if randanim == 1 then
				self:CustomDeathAnimationCode(dmginfo,hitgroup)
				self:VJ_ACT_PLAYACTIVITY(VJ_PICKRANDOMTABLE(self.AnimTbl_Death),true,2,false)
				timer.Simple(self.DeathAnimationTime,DoKilled)
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeathNotice_PlayerPoints(dmginfo,hitgroup)
	local DamageInflictor = dmginfo:GetInflictor()
	local dmgowner = dmginfo:GetAttacker()
	if GetConVarNumber("vj_npc_showhudonkilled") == 1 then
	gamemode.Call("OnNPCKilled",self,dmgowner,DamageInflictor,dmginfo) end
	if GetConVarNumber("vj_npc_addfrags") == 1 then
	if dmgowner:IsPlayer() then dmgowner:AddFrags(1) end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Killed(dmginfo,hitgroup)
	if self.VJDEBUG_SNPC_ENABLED == true then if GetConVarNumber("vj_npc_printdied") == 1 then print(self:GetClass().." Died!") end end
	self:CustomOnKilled(dmginfo,hitgroup)

	-- Item drops on death
	if self.HasItemDropsOnDeath == true then
	local randshoulddrop = math.random(1,self.ItemDropChance)
		if randshoulddrop == 1 then
		self:RareDropsOnDeathCode(dmginfo,hitgroup)
		end
	end

	-- MISC Stuff --
	if self.HasDeathNotice == true then PrintMessage(self.DeathNoticePosition, self.DeathNoticeWriting) end -- Death Notice on Death
	self:ClearEnemyMemory()
	self:ClearSchedule()

	-- Combine Ball check
	if dmginfo:GetDamageType() == 67108865 then self:ClearSchedule() self:SetNPCState(NPC_STATE_DEAD) end
	if self.IgnoreCBDeath == false then
	if dmginfo:GetDamageType() != 67108865 then
	self:DeathCorpse(dmginfo,hitgroup)
	self:Remove()
	end else
	self:DeathCorpse(dmginfo,hitgroup)
	self:Remove()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeathCorpse(dmginfo,hitgroup)
	self:CustomOnDeath_BeforeCorpseSpawned(dmginfo,hitgroup)
	if self.HasDeathRagdoll == true then
	//if self.VJCorpseDeleted == true then
	self.Corpse = ents.Create(self.DeathEntityType) //end
	self.Corpse:SetModel(self:GetModel())
	self.Corpse:SetPos(self:GetPos())
	self.Corpse:SetAngles(self:GetAngles())
	self.Corpse:Spawn()
	self.Corpse:SetColor(self:GetColor())
	self.Corpse:SetMaterial(self:GetMaterial())
	//self.Corpse:SetName("self.Corpse" .. self:EntIndex())
	//self.Corpse:SetModelScale(self:GetModelScale())
	/*local dissolve = ents.Create("env_entity_dissolver") 
	dissolve:SetPos(self.Corpse:GetPos()) 
	dissolve:SetKeyValue("target", self.Corpse:GetName())
	dissolve:Spawn() 
	dissolve:Fire("Dissolve", "", 0) 
	dissolve:Fire("kill", "", 0.3)*/
	self.Corpse.FadeCorpseType = self.FadeCorpseType
	self.Corpse.IsVJBaseCorpse = true
	
	local GetCorpse = self.Corpse
	local GetBloodDecal = self.BloodDecal
	local GetCustomBloodParticles = self.BloodPoolParticle
	if self.Bleeds == true && GetConVarNumber("vj_npc_nobloodpool") == 0 then
	if self.HasBloodPool == true then
	timer.Simple(2.2,function()
		if GetCorpse:IsValid() then
		local tr = util.TraceLine({
			start = GetCorpse:GetPos() +GetCorpse:OBBCenter(),
			endpos = GetCorpse:GetPos() +GetCorpse:OBBCenter() - Vector(0,0,30),
			filter = GetCorpse, //function( ent ) if ( ent:GetClass() == "prop_physics" ) then return true end end
			mask = CONTENTS_SOLID
		})
		-- (X,Y,Z),(front,up,side)
		//print(tr.Fraction)
		//print(tr.HitNormal)
		if (tr.HitWorld) then
		if tr.HitNormal == Vector(0.0,0.0,1.0) then
		//if (tr.Fraction <= 0.405) then
		if table.Count(GetCustomBloodParticles) <= 0 then // GetBloodDecal == "YellowBlood"
		local blooddecalistbl = true
		if istable(GetBloodDecal) then blooddecalistbl = true else blooddecalistbl = false end
			if (blooddecalistbl == true && table.HasValue(GetBloodDecal,"YellowBlood")) or (blooddecalistbl == false && GetBloodDecal == "YellowBlood") then
				ParticleEffect("vj_bleedout_yellow",tr.HitPos,Angle(0,0,0),nil) else
			if (blooddecalistbl == true && table.HasValue(GetBloodDecal,"Blood")) or (blooddecalistbl == false && GetBloodDecal == "Blood") then
				ParticleEffect("vj_bleedout_red",tr.HitPos,Angle(0,0,0),nil)
				end
			end
		else
			ParticleEffect(VJ_PICKRANDOMTABLE(GetCustomBloodParticles),tr.HitPos,Angle(0,0,0),nil) 
		 end
		end
	   end
	  end
	 end)
	end
   end
	
	-- MISC Stuff --
	if GetConVarNumber("ai_serverragdolls") == 0 then self.Corpse:SetCollisionGroup(1) hook.Call("VJ_CreateSNPCCorpse",nil,self.Corpse,self) else undo.ReplaceEntity(self,self.Corpse) end
	if self.CorpseAlwaysCollide == true then self.Corpse:SetCollisionGroup(0) end
	self.Corpse:SetSkin( self.DeathSkin )
	if self.DeathSkin == 0 then self.Corpse:SetSkin( self:GetSkin() ) end
	if self.HasDeathBodyGroup == true then for i = 0,18 do self.Corpse:SetBodygroup(i,self:GetBodygroup(i)) end -- 18 = Bodygroup limit
	if self.CustomBodyGroup == true then self.Corpse:SetBodygroup( self.DeathBodyGroupA, self.DeathBodyGroupB ) end end -- Custom Bodygroup
	cleanup.ReplaceEntity(self,self.Corpse) -- Delete on cleanup
	if GetConVarNumber("vj_npc_undocorpse") == 1 then undo.ReplaceEntity(self,self.Corpse) end -- Undoable
	if self.SetCorpseOnFire == true then self.Corpse:Ignite( math.Rand( 8, 10 ), 0 ) end -- Set it on fire when it dies
	if self:IsOnFire() then  -- If was on fire then...
		self.Corpse:Ignite( math.Rand( 8, 10 ), 0 )
		self.Corpse:SetColor(Color(90,90,90))
		//self.Corpse:SetMaterial("models/props_foliage/tree_deciduous_01a_trunk")
	end
	//gamemode.Call("CreateEntityRagdoll",self,self.Corpse)
	
	-- Bone and Angle --
    for i=1,128 do -- 128 = Bone Limit
	local dmgforce = dmginfo:GetDamageForce()
	local FindBone = self.Corpse:GetPhysicsObjectNum(i)
		if IsValid(FindBone) then
		local BonePostion, BoneAngle = self:GetBonePosition(self.Corpse:TranslatePhysBoneToBone(i))
		if(BonePostion) then FindBone:SetPos(BonePostion)
		if self.UsesBoneAngle == true then FindBone:SetAngles(BoneAngle) end
		if self.UsesDamageForceOnDeath == true then FindBone:SetVelocity(dmgforce /40) end
	  end
	 end
	end
	if self.FadeCorpse == true then self.Corpse:Fire(self.FadeCorpseType, "", self.FadeCorpseTime) end
	if GetConVarNumber("vj_npc_corpsefade") == 1 then self.Corpse:Fire(self.FadeCorpseType, "", GetConVarNumber("vj_npc_corpsefadetime")) end
	self:CustomOnDeath_AfterCorpseSpawned(dmginfo,hitgroup,GetCorpse)
 end
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
function ENT:RareDropsOnDeathCode(dmginfo,hitgroup)
	self:CustomRareDropsOnDeathCode(dmginfo,hitgroup)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FollowPlayerSoundCode(CustomTbl)
if self.HasSounds == false then return end
if self.HasFollowPlayerSounds_Follow == false then return end
	local randomplayersound = math.random(1,self.FollowPlayerSoundChance)
	local soundtbl = self.SoundTbl_FollowPlayer
	if CustomTbl != nil && #CustomTbl != 0 then soundtbl = CustomTbl end
	if randomplayersound == 1 && VJ_PICKRANDOMTABLE(soundtbl) != false then
		VJ_STOPSOUND(self.CurrentIdleSound)
		VJ_STOPSOUND(self.CurrentFollowPlayerSound)
		VJ_STOPSOUND(self.CurrentUnFollowPlayerSound)
		self.NextIdleSoundT_UnChanged = CurTime() + math.random(3,4)
		self.CurrentFollowPlayerSound = VJ_CreateSound(self,soundtbl,self.FollowPlayerSoundLevel,math.random(self.FollowPlayerPitch1,self.FollowPlayerPitch2))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:UnFollowPlayerSoundCode(CustomTbl)
if self.HasSounds == false then return end
if self.HasFollowPlayerSounds_UnFollow == false then return end
	local randomplayersound = math.random(1,self.UnFollowPlayerSoundChance)
	local soundtbl = self.SoundTbl_UnFollowPlayer
	if CustomTbl != nil && #CustomTbl != 0 then soundtbl = CustomTbl end
	if randomplayersound == 1 && VJ_PICKRANDOMTABLE(soundtbl) != false then
		VJ_STOPSOUND(self.CurrentIdleSound)
		VJ_STOPSOUND(self.CurrentFollowPlayerSound)
		VJ_STOPSOUND(self.CurrentUnFollowPlayerSound)
		self.NextIdleSoundT_UnChanged = CurTime() + math.random(3,4)
		self.CurrentUnFollowPlayerSound = VJ_CreateSound(self,soundtbl,self.UnFollowPlayerSoundLevel,math.random(self.UnFollowPlayerPitch1,self.UnFollowPlayerPitch2))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MedicSoundCode_BeforeHeal(CustomTbl)
if self.HasSounds == false then return end
if self.HasMedicSounds_BeforeHeal == false then return end
	local randsd = math.random(1,self.MedicBeforeHealSoundChance)
	local soundtbl = self.SoundTbl_MedicBeforeHeal
	if CustomTbl != nil && #CustomTbl != 0 then soundtbl = CustomTbl end
	if randsd == 1 && VJ_PICKRANDOMTABLE(soundtbl) != false then
		VJ_STOPSOUND(self.CurrentIdleSound)
		VJ_STOPSOUND(self.CurrentFollowPlayerSound)
		VJ_STOPSOUND(self.CurrentUnFollowPlayerSound)
		self.NextIdleSoundT_UnChanged = CurTime() + math.random(3,4)
		self.CurrentMedicBeforeHealSound = VJ_CreateSound(self,soundtbl,self.BeforeHealSoundLevel,math.random(self.BeforeHealSoundPitch1,self.BeforeHealSoundPitch2))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MedicSoundCode_AfterHeal(CustomTbl)
if self.HasSounds == false then return end
if self.HasMedicSounds_AfterHeal == false then return end
	local randsd = math.random(1,self.MedicAfterHealSoundChance)
	local soundtbl = self.SoundTbl_MedicAfterHeal
	if CustomTbl != nil && #CustomTbl != 0 then soundtbl = CustomTbl end
	if randsd == 1 /*&& VJ_PICKRANDOMTABLE(soundtbl) != false*/ then
		VJ_STOPSOUND(self.CurrentIdleSound)
		VJ_STOPSOUND(self.CurrentFollowPlayerSound)
		VJ_STOPSOUND(self.CurrentUnFollowPlayerSound)
		self.NextIdleSoundT_UnChanged = CurTime() + math.random(3,4)
		if VJ_PICKRANDOMTABLE(soundtbl) == false then
		self.CurrentMedicAfterHealSound = VJ_CreateSound(self,self.DefaultSoundTbl_MedicAfterHeal,self.AfterHealSoundLevel,math.random(self.AfterHealSoundPitch1,self.AfterHealSoundPitch2)) else
		self.CurrentMedicAfterHealSound = VJ_CreateSound(self,soundtbl,self.AfterHealSoundLevel,math.random(self.AfterHealSoundPitch1,self.AfterHealSoundPitch2)) end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPlayerSightSoundCode(CustomTbl)
if self.HasSounds == false then return end
if self.HasOnPlayerSightSounds == false then return end
	local randomplayersound = math.random(1,self.OnPlayerSightSoundChance)
	local soundtbl = self.SoundTbl_OnPlayerSight
	if CustomTbl != nil && #CustomTbl != 0 then soundtbl = CustomTbl end
	if randomplayersound == 1 && VJ_PICKRANDOMTABLE(soundtbl) != false then
		VJ_STOPSOUND(self.CurrentIdleSound)
		VJ_STOPSOUND(self.CurrentOnPlayerSightSound)
		self.NextIdleSoundT_UnChanged = CurTime() + math.random(3,4)
		self.NextAlertSoundT = CurTime() + math.random(1,2)
		self.CurrentOnPlayerSightSound = VJ_CreateSound(self,soundtbl,self.OnPlayerSightSoundLevel,math.random(self.OnPlayerSightSoundPitch1,self.OnPlayerSightSoundPitch2))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IdleSoundCode(CustomTbl)
if self.HasSounds == false then return end
if self.HasIdleSounds == false then return end
if self.Dead == true then return end

if (self.NextIdleSoundT_UnChanged < CurTime()) then
if CurTime() > self.NextIdleSoundT then

local PlayCombatIdleSds = false
if self:GetEnemy() != nil then PlayCombatIdleSds = true else PlayCombatIdleSds = false end
if VJ_PICKRANDOMTABLE(self.SoundTbl_CombatIdle) == false then
	if self.PlayNothingWhenCombatIdleSoundTableEmpty == false then
		PlayCombatIdleSds = false
	end
end

	if PlayCombatIdleSds == false then
	local randomidlesound = math.random(1,self.IdleSoundChance)
	local soundtbl = self.SoundTbl_Idle
	if CustomTbl != nil && #CustomTbl != 0 then soundtbl = CustomTbl end
	if randomidlesound == 1 && VJ_PICKRANDOMTABLE(soundtbl) != false /*&& self:VJ_IsPlayingSoundFromTable(self.SoundTbl_Idle) == false*/ then
		self.CurrentIdleSound = VJ_CreateSound(self,soundtbl,self.IdleSoundLevel,math.random(self.IdleSoundPitch1,self.IdleSoundPitch2))
		end
	end
	
	if PlayCombatIdleSds == true then
	local randomenemytalksound = math.random(1,self.CombatIdleSoundChance)
	local soundtbl = self.SoundTbl_CombatIdle
	if CustomTbl != nil && #CustomTbl != 0 then soundtbl = CustomTbl end
	if randomenemytalksound == 1 && VJ_PICKRANDOMTABLE(soundtbl) != false then
		//VJ_STOPSOUND(self.CurrentIdleSound)
		self.CurrentIdleSound = VJ_CreateSound(self,soundtbl,self.CombatIdleSoundLevel,math.random(self.CombatIdleSoundPitch1,self.CombatIdleSoundPitch2))
		end
	end
	self.NextIdleSoundT = CurTime() + math.Rand(self.NextSoundTime_Idle1,self.NextSoundTime_Idle2)
  end
 end
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnReceiveOrderSoundCode(CustomTbl)
if self.HasSounds == false then return end
if self.HasOnReceiveOrderSounds == false then return end
	local randomalertsound = math.random(1,self.OnReceiveOrderSoundChance)
	local soundtbl = self.SoundTbl_OnReceiveOrder
	if CustomTbl != nil && #CustomTbl != 0 then soundtbl = CustomTbl end
	if randomalertsound == 1 && VJ_PICKRANDOMTABLE(soundtbl) != false then
		VJ_STOPSOUND(self.CurrentIdleSound)
		self.NextIdleSoundT = self.NextIdleSoundT + 2
		self.NextAlertSoundT = CurTime() + 2
		self.CurrentOnReceiveOrderSound = VJ_CreateSound(self,soundtbl,self.OnReceiveOrderSoundLevel,math.random(self.OnReceiveOrderSoundPitch1,self.OnReceiveOrderSoundPitch2))
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AlertSoundCode(CustomTbl)
if self.HasSounds == false then return end
if self.HasAlertSounds == false then return end
	local randomalertsound = math.random(1,self.AlertSoundChance)
	local soundtbl = self.SoundTbl_Alert
	if CustomTbl != nil && #CustomTbl != 0 then soundtbl = CustomTbl end
	if randomalertsound == 1 && VJ_PICKRANDOMTABLE(soundtbl) != false then
		VJ_STOPSOUND(self.CurrentIdleSound)
		self.NextIdleSoundT = self.NextIdleSoundT + 2
		self.CurrentAlertSound = VJ_CreateSound(self,soundtbl,self.AlertSoundLevel,math.random(self.AlertSoundPitch1,self.AlertSoundPitch2))
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CallForHelpSoundCode(CustomTbl)
if self.HasSounds == false then return end
if self.HasCallForHelpSounds == false then return end
	local randomalertsound = math.random(1,self.CallForHelpSoundChance)
	local soundtbl = self.SoundTbl_CallForHelp
	if CustomTbl != nil && #CustomTbl != 0 then soundtbl = CustomTbl end
	if randomalertsound == 1 && VJ_PICKRANDOMTABLE(soundtbl) != false then
		VJ_STOPSOUND(self.CurrentIdleSound)
		self.NextIdleSoundT = self.NextIdleSoundT + 2
		self.NextSuppressingSoundT = self.NextSuppressingSoundT + 2.5
		self.CurrentCallForHelpSound = VJ_CreateSound(self,soundtbl,self.CallForHelpSoundLevel,math.random(self.CallForHelpSoundPitch1,self.CallForHelpSoundPitch2))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DamageByPlayerSoundCode(CustomTbl)
if self.HasSounds == false then return end
if self.HasDamageByPlayerSounds == false then return end
if CurTime() > self.NextDamageByPlayerSoundT then
	local randomplayersound = math.random(1,self.DamageByPlayerSoundChance)
	local soundtbl = self.SoundTbl_DamageByPlayer
	if CustomTbl != nil && #CustomTbl != 0 then soundtbl = CustomTbl end
	if randomplayersound == 1 && VJ_PICKRANDOMTABLE(soundtbl) != false then
		self.NextIdleSoundT_UnChanged = CurTime() + 1
		VJ_STOPSOUND(self.CurrentIdleSound)
		VJ_STOPSOUND(self.CurrentOnPlayerSightSound)
		timer.Simple(0.05,function() if IsValid(self) then VJ_STOPSOUND(self.CurrentPainSound) end end)
		self.CurrentDamageByPlayerSound = VJ_CreateSound(self,soundtbl,self.DamageByPlayerSoundLevel,math.random(self.DamageByPlayerPitch1,self.DamageByPlayerPitch2))
	end
	self.NextDamageByPlayerSoundT = CurTime() + math.Rand(self.NextSoundTime_DamageByPlayer1,self.NextSoundTime_DamageByPlayer2)
 end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BeforeMeleeAttackSoundCode(CustomTbl)
if self.HasSounds == false then return end
if self.HasMeleeAttackSounds == false then return end
	local randomattacksound = math.random(1,self.BeforeMeleeAttackSoundChance)
	local soundtbl = self.SoundTbl_BeforeMeleeAttack
	if CustomTbl != nil && #CustomTbl != 0 then soundtbl = CustomTbl end
	if randomattacksound == 1 && VJ_PICKRANDOMTABLE(soundtbl) != false then
		if self.ContinuePlayingIdleSoundsOnAttacks == false then VJ_STOPSOUND(self.CurrentIdleSound) end
		self.NextIdleSoundT_UnChanged = CurTime() + 1
		self.CurrentBeforeMeleeAttackSound = VJ_CreateSound(self,soundtbl,self.BeforeMeleeAttackSoundLevel,math.random(self.BeforeMeleeAttackSoundPitch1,self.BeforeMeleeAttackSoundPitch2))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MeleeAttackSoundCode(CustomTbl,CustomTblExtra)
if self.HasSounds == false then return end
if self.HasMeleeAttackSounds == false then return end
	local randomattacksound = math.random(1,self.MeleeAttackSoundChance)
	local soundtbl = self.SoundTbl_MeleeAttack
	if CustomTbl != nil && #CustomTbl != 0 then soundtbl = CustomTbl end
	if randomattacksound == 1 && VJ_PICKRANDOMTABLE(soundtbl) != false then
		if self.ContinuePlayingIdleSoundsOnAttacks == false then VJ_STOPSOUND(self.CurrentIdleSound) end
		self.NextIdleSoundT_UnChanged = CurTime() + 1
		self.CurrentMeleeAttackSound = VJ_CreateSound(self,soundtbl,self.MeleeAttackSoundLevel,math.random(self.MeleeAttackSoundPitch1,self.MeleeAttackSoundPitch2))
   end
	if self.HasExtraMeleeAttackSounds == true then
	//self:EmitSound( "npc/zombie/claw_strike"..math.random(1,3)..".wav", 70, 100)
	local randextraattacks = math.random(1,self.ExtraMeleeSoundChance)
	local soundtbl = self.SoundTbl_MeleeAttackExtra
	if CustomTblExtra != nil && #CustomTblExtra != 0 then soundtbl = CustomTblExtra end
	if randextraattacks == 1 /*&& VJ_PICKRANDOMTABLE(soundtbl) != false*/ then
		if self.ContinuePlayingIdleSoundsOnAttacks == false then VJ_STOPSOUND(self.CurrentIdleSound) end
		if VJ_PICKRANDOMTABLE(soundtbl) == false then
		VJ_EmitSound(self,self.DefaultSoundTbl_MeleeAttackExtra,self.ExtraMeleeAttackSoundLevel,math.random(self.ExtraMeleeSoundPitch1,self.ExtraMeleeSoundPitch2)) else
		VJ_EmitSound(self,soundtbl,self.ExtraMeleeAttackSoundLevel,math.random(self.ExtraMeleeSoundPitch1,self.ExtraMeleeSoundPitch2))
		//self.CurrentExtraMeleeAttackSound = VJ_CreateSound(self,self.DefaultSoundTbl_MeleeAttackExtra,self.ExtraMeleeAttackSoundLevel,math.random(self.ExtraMeleeSoundPitch1,self.ExtraMeleeSoundPitch2)) else
		//self.CurrentExtraMeleeAttackSound = VJ_CreateSound(self,soundtbl,self.ExtraMeleeAttackSoundLevel,math.random(self.ExtraMeleeSoundPitch1,self.ExtraMeleeSoundPitch2))
		end
	end
 end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MeleeAttackMissSoundCode(CustomTbl)
if self.HasSounds == false then return end
if self.HasMeleeAttackMissSounds == false then return end
local randommisssound = math.random(1,self.MeleeAttackMissSoundChance)
	local soundtbl = self.SoundTbl_MeleeAttackMiss
	if CustomTbl != nil && #CustomTbl != 0 then soundtbl = CustomTbl end
	if randommisssound == 1 && VJ_PICKRANDOMTABLE(soundtbl) != false then
		if self.ContinuePlayingIdleSoundsOnAttacks == false then VJ_STOPSOUND(self.CurrentIdleSound) end
		self.NextIdleSoundT_UnChanged = CurTime() + 1
		//self.CurrentMeleeAttackMissSound = VJ_CreateSound(self,soundtbl,self.MeleeAttackMissSoundLevel,math.random(self.MeleeAttackMissSoundPitch1,self.MeleeAttackMissSoundPitch2))
		VJ_EmitSound(self,soundtbl,self.MeleeAttackMissSoundLevel,math.random(self.MeleeAttackMissSoundPitch1,self.MeleeAttackMissSoundPitch2))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackSoundCode(CustomTbl)
if self.HasSounds == false then return end
if self.HasRangeAttackSound == false then return end
	local randomrangesound = math.random(1,self.RangeAttackSoundChance)
	local soundtbl = self.SoundTbl_RangeAttack
	if CustomTbl != nil && #CustomTbl != 0 then soundtbl = CustomTbl end
	if randomrangesound == 1 && VJ_PICKRANDOMTABLE(soundtbl) != false then
		if self.ContinuePlayingIdleSoundsOnAttacks == false then VJ_STOPSOUND(self.CurrentIdleSound) end
		self.NextIdleSoundT_UnChanged = CurTime() + 1
		self.CurrentRangeAttackSound = VJ_CreateSound(self,soundtbl,self.RangeAttackSoundLevel,math.random(self.RangeAttackPitch1,self.RangeAttackPitch2))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:LeapAttackSoundCode(CustomTbl)
if self.HasSounds == false then return end
if self.HasLeapAttackSound == false then return end
	local randomleapsound = math.random(1,self.LeapAttackSoundChance)
	local soundtbl = self.SoundTbl_LeapAttack
	if CustomTbl != nil && #CustomTbl != 0 then soundtbl = CustomTbl end
	if randomleapsound == 1 && VJ_PICKRANDOMTABLE(soundtbl) != false then
		if self.ContinuePlayingIdleSoundsOnAttacks == false then VJ_STOPSOUND(self.CurrentIdleSound) end
		self.NextIdleSoundT_UnChanged = CurTime() + 1
		self.CurrentLeapAttackSound = VJ_CreateSound(self,soundtbl,self.LeapAttackSoundLevel,math.random(self.LeapAttackPitch1,self.LeapAttackPitch2))
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BecomeEnemyToPlayerSoundCode(CustomTbl)
if self.HasSounds == false then return end
if self.HasBecomeEnemyToPlayerSounds == false then return end
local randomenemyplysound = math.random(1,self.BecomeEnemyToPlayerChance)
	local soundtbl = self.SoundTbl_BecomeEnemyToPlayer
	if CustomTbl != nil && #CustomTbl != 0 then soundtbl = CustomTbl end
	if randomenemyplysound == 1 && VJ_PICKRANDOMTABLE(soundtbl) != false then
		self.NextAlertSoundT = CurTime() + 1
		timer.Simple(1.3,function() if IsValid(self) then VJ_STOPSOUND(self.CurrentAlertSound) end end)
		self.NextIdleSoundT_UnChanged = CurTime() + 1
		VJ_STOPSOUND(self.CurrentIdleSound)
		VJ_STOPSOUND(self.CurrentAlertSound)
		VJ_STOPSOUND(self.CurrentFollowPlayerSound)
		VJ_STOPSOUND(self.CurrentUnFollowPlayerSound)
		VJ_STOPSOUND(self.CurrentOnPlayerSightSound)
		timer.Simple(0.05,function() if IsValid(self) then VJ_STOPSOUND(self.CurrentPainSound) end end)
		self.CurrentBecomeEnemyToPlayerSound = VJ_CreateSound(self,soundtbl,self.BecomeEnemyToPlayerSoundLevel,math.random(self.BecomeEnemyToPlayerPitch1,self.BecomeEnemyToPlayerPitch2))
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PainSoundCode(CustomTbl)
if self.HasSounds == false then return end
if self.HasPainSounds == false then return end
if CurTime() > self.PainSoundT then
local randompainsound = math.random(1,self.PainSoundChance)
	local soundtbl = self.SoundTbl_Pain
	if CustomTbl != nil && #CustomTbl != 0 then soundtbl = CustomTbl end
	if randompainsound == 1 && VJ_PICKRANDOMTABLE(soundtbl) != false then
		VJ_STOPSOUND(self.CurrentIdleSound)
		self.NextIdleSoundT_UnChanged = CurTime() + 1
		self.CurrentPainSound = VJ_CreateSound(self,soundtbl,self.PainSoundLevel,math.random(self.PainSoundPitch1,self.PainSoundPitch2))
		end
	self.PainSoundT = CurTime() + math.Rand(self.NextSoundTime_Pain1,self.NextSoundTime_Pain2)
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeathSoundCode(CustomTbl)
if self.HasSounds == false then return end
if self.HasDeathSounds == false then return end
local deathsound = math.random(1,self.DeathSoundChance)
	local soundtbl = self.SoundTbl_Death
	if CustomTbl != nil && #CustomTbl != 0 then soundtbl = CustomTbl end
	if deathsound == 1 && VJ_PICKRANDOMTABLE(soundtbl) != false then
		self.CurrentDeathSound = VJ_CreateSound(self,soundtbl,self.DeathSoundLevel,math.random(self.DeathSoundPitch1,self.DeathSoundPitch2))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FootStepSoundCode(CustomTbl)
if self.HasSounds == false then return end
if self.HasFootStepSound == false or self.MovementType == VJ_MOVETYPE_STATIONARY then return end
if self:IsOnGround() && self:GetGroundEntity() != NULL && self:IsMoving() then
	if self.DisableFootStepSoundTimer == true then
		self:CustomOnFootStepSound()
		local soundtbl = self.SoundTbl_FootStep
		if CustomTbl != nil && #CustomTbl != 0 then soundtbl = CustomTbl end
		if VJ_PICKRANDOMTABLE(soundtbl) != false then
		VJ_EmitSound(self,soundtbl,self.FootStepSoundLevel,math.random(self.FootStepPitch1,self.FootStepPitch2))
		end
	end
	if self.DisableFootStepSoundTimer == false && CurTime() > self.FootStepT then
		self:CustomOnFootStepSound()
		local soundtbl = self.SoundTbl_FootStep
		if CustomTbl != nil && #CustomTbl != 0 then soundtbl = CustomTbl end
		if VJ_PICKRANDOMTABLE(soundtbl) != false then
		//VJ_EmitSound(self,soundtbl,self.FootStepSoundLevel,math.random(self.FootStepPitch1,self.FootStepPitch2))
		if self.DisableFootStepOnRun == false && (table.HasValue(VJ_RunActivites,self:GetMovementActivity()) or table.HasValue(self.CustomRunActivites,self:GetMovementActivity())) then
		self:CustomOnFootStepSound_Run()
		VJ_EmitSound(self,soundtbl,self.FootStepSoundLevel,math.random(self.FootStepPitch1,self.FootStepPitch2))
		self.FootStepT = CurTime() + self.FootStepTimeRun
		elseif self.DisableFootStepOnWalk == false && (table.HasValue(VJ_WalkActivites,self:GetMovementActivity()) or table.HasValue(self.CustomWalkActivites,self:GetMovementActivity())) then
		self:CustomOnFootStepSound_Walk()
		VJ_EmitSound(self,soundtbl,self.FootStepSoundLevel,math.random(self.FootStepPitch1,self.FootStepPitch2))
		self.FootStepT = CurTime() + self.FootStepTimeWalk
		end
	 end
	end
 end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ImpactSoundCode(CustomTbl)
if self.HasSounds == false then return end
if self.HasImpactSounds == false then return end
local randomimpactsound = math.random(1,self.ImpactSoundChance)
	local soundtbl = self.SoundTbl_Impact
	if CustomTbl != nil && #CustomTbl != 0 then soundtbl = CustomTbl end
	if randomimpactsound == 1 then
	if VJ_PICKRANDOMTABLE(soundtbl) == false then
	VJ_EmitSound(self,self.DefaultSoundTbl_Impact,self.ImpactSoundLevel,math.random(self.ImpactSoundPitch1,self.ImpactSoundPitch2)) else
	VJ_EmitSound(self,soundtbl,self.ImpactSoundLevel,math.random(self.ImpactSoundPitch1,self.ImpactSoundPitch2))
	end
 end
end
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
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartSoundTrack()
	if self.HasSounds == false then return end
	if self.HasSoundTrack == false then return end
	self.VJ_IsPlayingSoundTrack = true
	self:SetNetworkedBool("VJ_IsPlayingSoundTrack",true)
	net.Start("vj_creature_onthememusic")
	net.WriteEntity(self)
	net.WriteTable(self.SoundTbl_SoundTrack)
	net.WriteFloat(self.SoundTrackLevel)
	net.WriteFloat(self.SoundTrackFadeOutTime)
	net.Broadcast()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StopAllCommonSounds()
	VJ_STOPSOUND(self.CurrentBreathSound)
	VJ_STOPSOUND(self.CurrentIdleSound)
	VJ_STOPSOUND(self.CurrentAlertSound)
	VJ_STOPSOUND(self.CurrentBeforeMeleeAttackSound)
	VJ_STOPSOUND(self.CurrentMeleeAttackSound)
	VJ_STOPSOUND(self.CurrentExtraMeleeAttackSound)
	//VJ_STOPSOUND(self.CurrentMeleeAttackMissSound)
	VJ_STOPSOUND(self.CurrentRangeAttackSound)
	VJ_STOPSOUND(self.CurrentLeapAttackSound)
	VJ_STOPSOUND(self.CurrentPainSound)
	VJ_STOPSOUND(self.CurrentFollowPlayerSound)
	VJ_STOPSOUND(self.CurrentUnFollowPlayerSound)
	VJ_STOPSOUND(self.CurrentBecomeEnemyToPlayerSound)
	VJ_STOPSOUND(self.CurrentOnPlayerSightSound)
	VJ_STOPSOUND(self.CurrentDamageByPlayerSound)
	VJ_STOPSOUND(self.CurrentMedicBeforeHealSound)
	VJ_STOPSOUND(self.CurrentMedicAfterHealSound)
	VJ_STOPSOUND(self.CurrentCallForHelpSound)
	VJ_STOPSOUND(self.CurrentOnReceiveOrderSound)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RemoveAttackTimers()
	for _,v in ipairs(self.AttackTimers) do
		timer.Destroy(v..self.Entity:EntIndex())
	end
	for _,v in ipairs(self.AttackTimersCustom) do
		timer.Destroy(v..self.Entity:EntIndex())
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:NoCollide_CombineBall()
	for k, v in pairs (ents.GetAll()) do
	if v:GetClass() == "prop_combine_ball" then
		constraint.NoCollide( self, v, 0, 0 )
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:WorldShakeOnMoveCode()
if self.HasWorldShakeOnMove == false or self.MovementType == VJ_MOVETYPE_STATIONARY then return end
	if self:IsOnGround() && self:IsMoving() && CurTime() > self.WorldShakeWalkT then
		self:CustomOnWorldShakeOnMove()
		if self.DisableWorldShakeOnMoveWhileRunning == false && (table.HasValue(VJ_RunActivites,self:GetMovementActivity()) or table.HasValue(self.CustomRunActivites,self:GetMovementActivity())) then
		self:CustomOnWorldShakeOnMove_Run()
		util.ScreenShake(self:GetPos(),self.WorldShakeOnMoveAmplitude,self.WorldShakeOnMoveFrequency,self.WorldShakeOnMoveDuration,self.WorldShakeOnMoveRadius)
		self.WorldShakeWalkT = CurTime() + self.NextWorldShakeOnRun
		elseif self.DisableWorldShakeOnMoveWhileWalking == false && (table.HasValue(VJ_WalkActivites,self:GetMovementActivity()) or table.HasValue(self.CustomWalkActivites,self:GetMovementActivity())) then
		self:CustomOnWorldShakeOnMove_Walk()
		util.ScreenShake(self:GetPos(),self.WorldShakeOnMoveAmplitude,self.WorldShakeOnMoveFrequency,self.WorldShakeOnMoveDuration,self.WorldShakeOnMoveRadius)
		self.WorldShakeWalkT = CurTime() + self.NextWorldShakeOnWalk
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:EntitiesToNoCollideCode()
	if !istable(self.EntitiesToNoCollide) then return end
	if #self.EntitiesToNoCollide < 1 then return end
	for k, v in pairs (ents.GetAll()) do
		if table.HasValue(self.EntitiesToNoCollide,v:GetClass()) then
		constraint.NoCollide(self,v,0,0)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ConvarsOnInit()
--<>-- Convars that run on Initialize --<>--
	if GetConVarNumber("vj_npc_usedevcommands") == 1 then self.VJDEBUG_SNPC_ENABLED = true end
	self.NextEntityCheckTime = GetConVarNumber("vj_npc_processtime")
	if GetConVarNumber("vj_npc_sd_nosounds") == 1 then self.HasSounds = false end
	if GetConVarNumber("vj_npc_playerfriendly") == 1 then self.PlayerFriendly = true end
	if GetConVarNumber("vj_npc_zombiefriendly") == 1 then self.ZombieFriendly = true end
	if GetConVarNumber("vj_npc_antlionfriendly") == 1 then self.AntlionFriendly = true end
	if GetConVarNumber("vj_npc_combinefriendly") == 1 then self.CombineFriendly = true end
	if GetConVarNumber("vj_npc_noallies") == 1 then
		self.HasAllies = false
		self.ZombieFriendly = false
		self.AntlionFriendly = false
		self.CombineFriendly = false
		self.PlayerFriendly = false
	end
	if GetConVarNumber("vj_npc_nocorpses") == 1 then self.HasDeathRagdoll = false end
	if GetConVarNumber("vj_npc_itemdrops") == 1 then self.HasItemDropsOnDeath = false end
	if GetConVarNumber("vj_npc_noproppush") == 1 then self.PushProps = false end
	if GetConVarNumber("vj_npc_nopropattack") == 1 then self.AttackProps = false end
	if GetConVarNumber("vj_npc_bleedenemyonmelee") == 1 then self.MeleeAttackBleedEnemy = false end
	if GetConVarNumber("vj_npc_slowplayer") == 1 then self.SlowPlayerOnMeleeAttack = false end
	if GetConVarNumber("vj_npc_nowandering") == 1 then self.DisableWandering = true end
	if GetConVarNumber("vj_npc_nochasingenemy") == 1 then self.DisableChasingEnemy = true end
	if GetConVarNumber("vj_npc_noflinching") == 1 then self.Flinches = false end
	if GetConVarNumber("vj_npc_nomelee") == 1 then self.HasMeleeAttack = false end
	if GetConVarNumber("vj_npc_norange") == 1 then self.HasRangeAttack = false end
	if GetConVarNumber("vj_npc_noleap") == 1 then self.HasLeapAttack = false end
	if GetConVarNumber("vj_npc_nobleed") == 1 then self.Bleeds = false end
	if GetConVarNumber("vj_npc_godmodesnpc") == 1 then self.GodMode = true end
	if GetConVarNumber("vj_npc_nobecomeenemytoply") == 1 then self.BecomeEnemyToPlayer = false end
	if GetConVarNumber("vj_npc_nofollowplayer") == 1 then self.FollowPlayer = false end
	if GetConVarNumber("vj_npc_nosnpcchat") == 1 then self.FollowPlayerChat = false end
	if GetConVarNumber("vj_npc_nomedics") == 1 then self.IsMedicSNPC = false end
	if GetConVarNumber("vj_npc_sd_soundtrack") == 1 then self.HasSoundTrack = false end
	if GetConVarNumber("vj_npc_sd_footstep") == 1 then self.HasFootStepSound = false end
	if GetConVarNumber("vj_npc_sd_idle") == 1 then self.HasIdleSounds = false end
	if GetConVarNumber("vj_npc_sd_breath") == 1 then self.HasBreathSound = false end
	if GetConVarNumber("vj_npc_sd_alert") == 1 then self.HasAlertSounds = false end
	if GetConVarNumber("vj_npc_sd_meleeattack") == 1 then self.HasMeleeAttackSounds = false self.HasExtraMeleeAttackSounds = false end
	if GetConVarNumber("vj_npc_sd_meleeattackmiss") == 1 then self.HasMeleeAttackMissSounds = false end
	if GetConVarNumber("vj_npc_sd_slowplayer") == 1 then self.HasSlowPlayerSound = false end
	if GetConVarNumber("vj_npc_sd_rangeattack") == 1 then self.HasRangeAttackSound = false end
	if GetConVarNumber("vj_npc_sd_leapattack") == 1 then self.HasLeapAttackSound = false end
	if GetConVarNumber("vj_npc_sd_pain") == 1 then self.HasPainSounds = false end
	if GetConVarNumber("vj_npc_sd_death") == 1 then self.HasDeathSounds = false end
	if GetConVarNumber("vj_npc_sd_followplayer") == 1 then self.HasFollowPlayerSounds_Follow = false self.HasFollowPlayerSounds_UnFollow = false end
	if GetConVarNumber("vj_npc_sd_becomenemytoply") == 1 then self.HasBecomeEnemyToPlayerSounds = false end
	if GetConVarNumber("vj_npc_sd_onplayersight") == 1 then self.HasOnPlayerSightSounds = false end
	if GetConVarNumber("vj_npc_sd_medic") == 1 then self.HasMedicSounds_BeforeHeal = false self.HasMedicSounds_AfterHeal = false end
	if GetConVarNumber("vj_npc_sd_callforhelp") == 1 then self.HasCallForHelpSounds = false end
	if GetConVarNumber("vj_npc_sd_onreceiveorder") == 1 then self.HasOnReceiveOrderSounds = false end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ConvarsOnThink() -- Obsolete! | Causes lag!
end
/*--------------------------------------------------
	=============== Creature SNPC Base ===============
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to make creature SNPCs
--------------------------------------------------*/