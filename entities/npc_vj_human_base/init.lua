if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')
include('schedules.lua')
/*--------------------------------------------------
	=============== Human SNPC Base ===============
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used as a base for human SNPCs.
--------------------------------------------------*/
AccessorFunc(ENT,"m_iClass","NPCClass",FORCE_NUMBER)
AccessorFunc(ENT,"m_fMaxYawSpeed","MaxYawSpeed",FORCE_NUMBER)
ENT.IsVJBaseSNPC = true -- Is it a VJ Base SNPC?
ENT.IsVJBaseSNPC_Human = true -- Is it a VJ Base human?

	-- General ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Model = {} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = GetConVarNumber("vj_snpchealth")
ENT.MoveType = MOVETYPE_STEP
ENT.HullType = HULL_TINY
ENT.HasHull = true -- Set to false to disable HULL
ENT.HullSizeNormal = true -- set to false to cancel out the self:SetHullSizeNormal()
ENT.HasSetSolid = true -- set to false to disable SetSolid
ENT.SightDistance = 10000 -- How far it can see
ENT.SightAngle = 80 -- The sight angle | Example: 180 would make the it see all around it | Measured in degrees and then converted to radians
ENT.TurningSpeed = 20 -- How fast it can turn
ENT.VJ_IsHugeMonster = false -- Is this a huge monster?
ENT.VJ_IsStationary = false -- Is this a stationary SNPC?
ENT.CanTurnWhileStationary = false -- If set to true, the SNPC will be able to turn while it's a stationary SNPC
	-- Blood & Damages ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.GodMode = false -- Immune to everything
ENT.Bleeds = true -- Does the SNPC bleed? (Blood decal, particle and etc.)
ENT.HasBloodParticle = true -- Does it spawn a particle when damaged?
ENT.HasBloodPool = true -- Does it have a blood pool?
ENT.HasBloodDecal = true -- Does it spawn a decal when damaged?
ENT.BloodParticle = {"blood_impact_red_01"} -- Particle that the SNPC spawns when it's damaged
ENT.BloodPoolParticle = {} -- Leave empty for the base to decide which pool blood it should use
ENT.BloodDecal = {"Blood"} -- Leave blank for none | Commonly used: Red = Blood, Yellow Blood = YellowBlood
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
ENT.DisableCallForBackUpOnDamageAnimation = false -- Disables the animation when the CallForBackUpOnDamage function is called
ENT.CallForBackUpOnDamageAnimation = ACT_SIGNAL_HALT -- Animation used if the SNPC does the CallForBackUpOnDamage function
ENT.CallForBackUpOnDamageAnimationTime = 2 -- How much time until it can use activities
ENT.CallForBackUpOnDamageUseSCHED = false -- Should it use a Schedule when CallForBackUpOnDamage function is called?
ENT.CallForBackUpOnDamageUseSCHEDID = SCHED_RUN_FROM_ENEMY -- The schedule ID for CallForBackUpOnDamageUseSCHED
ENT.NextBackUpOnDamageTime1 = 9 -- Next time it use the CallForBackUpOnDamage function | The first # in math.random
ENT.NextBackUpOnDamageTime2 = 11 -- Next time it use the CallForBackUpOnDamage function | The second # in math.random
ENT.MoveOrHideOnDamageByEnemy = true -- Should the SNPC move or hide when being damaged by an enemy?
ENT.MoveOrHideOnDamageByEnemy_MoveSchedules = {SCHED_FORCED_GO_RUN} -- The schedule it plays when the SNPC was unable to find a hiding spot, and needs to move
ENT.MoveOrHideOnDamageByEnemy_OnlyMove = false -- If set to true, it will only play the moving schedules and will not try to hide	
ENT.MoveOrHideOnDamageByEnemy_CustomActivites = {} -- The activities it plays when it finds a hiding spot
ENT.MoveOrHideOnDamageByEnemy_HideTime1 = 5 -- How long should it hide? | First number in math.random
ENT.MoveOrHideOnDamageByEnemy_HideTime2 = 5 -- How long should it hide? | Second number in math.random
ENT.NextMoveOrHideOnDamageByEnemy1 = 3 -- How much time until it moves or hides on damage by enemy? | The first # in math.random
ENT.NextMoveOrHideOnDamageByEnemy2 = 3.5 -- How much time until it moves or hides on damage by enemy? | The second # in math.random
ENT.HasDamageByPlayer = true -- Should the SNPC do something when it's hit by a player? Example: Play a sound or animation
ENT.DamageByPlayerDispositionLevel = 0 -- 0 = Run it every time | 1 = Run it only when friendly to player | 2 = Run it only when enemy to player
ENT.DamageByPlayerNextTime1 = 2 -- How much time should it pass until it runs the code again? | First number in math.random
ENT.DamageByPlayerNextTime2 = 2 -- How much time should it pass until it runs the code again? | Second number in math.random
	-- ====== Flinching Code ====== --
ENT.Flinches = 0 -- 0 = No Flinch | 1 = Flinches at any damage | 2 = Flinches only from certain damages
ENT.FlinchCustomDMGs = {DMG_BLAST} -- The types of damages it will flinch from if self.Flinches is set to custom
ENT.FlinchingChance = 1 -- chance of it flinching from 1 to x | 1 will make it always flinch
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
ENT.NextEntityCheckTime = 1 -- Time until it runs the NPC check
ENT.NextHardEntityCheck1 = 80 -- Next time it will do hard entity check | The first # in math.random
ENT.NextHardEntityCheck2 = 100 -- Next time it will do hard entity check | The second # in math.random
ENT.NextFindEnemyTime = 1 -- Time until it runs FindEnemy again
ENT.HasSquad = true -- Does it have a squad?
ENT.SquadName = "SquadName" -- Squad name, console error will happen if two groups that are enemy and try to squad!
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
ENT.AnimTbl_CallForHelp = {ACT_SIGNAL_ADVANCE,ACT_SIGNAL_FORWARD} -- Call For Help Animations
ENT.CallForHelpAnimationDelay = 0.1 -- It will wait certain amount of time before playing the animation
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
ENT.AnimTbl_Death = {ACT_DIESIMPLE} -- Death Animations
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
ENT.DropWeaponOnDeath = true -- Should it drop its weapon on death?
ENT.DropWeaponOnDeathAttachment = "anim_attachment_RH" -- Which attachment should it use for the weapon's position
ENT.HasItemDropsOnDeath = true -- Should it drop items on death?
ENT.ItemDropChance = 6 -- If set to 1, it will always drop it
ENT.ItemDrop_HasDefaultItems = true -- Does it drop the default items?
ENT.ItemDropChance_DefaultItems = 6 -- If set to 1, it will always drop it
-- Human Base uses AlertFriendsOnDeath instead of BringFriendsOnDeath, because humans use more logic then creatures, therefore they wouldn't just walk to their friend that just died, but you can always use the creature system
ENT.AlertFriendsOnDeath = true -- Should the SNPC's friends come to its position before it dies?
ENT.AlertFriendsOnDeathDistance = 800 -- How far away does the signal go? | Counted in World Units
ENT.AlertFriendsOnDeathUseCertainAmountNumber = 50 -- How many people should it call?
ENT.AlertFriendsOnDeathCustomAnimations = {ACT_IDLE_ANGRY} -- Animations it plays when an ally dies | AlertFriendsOnDeath Has to be enabled!
ENT.BringFriendsOnDeath = false -- Should the SNPC's friends come to its position before it dies?
ENT.BringFriendsOnDeathDistance = 800 -- How far away does the signal go? | Counted in World Units
ENT.BringFriendsOnDeathUseCertainAmount = true -- Should the SNPC only call certain amount of people?
ENT.BringFriendsOnDeathUseCertainAmountNumber = 3 -- How many people should it call if certain amount is enabled?
	-- Melee Attack ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.MeleeAttackDamage = GetConVarNumber("vj_snpcdamage")
ENT.DisableMeleeAttackAnimation = false -- if true, it will disable the animation code
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- Melee Attack Animations
ENT.MeleeAttackAnimationDelay = 0 -- It will wait certain amount of time before playing the animation
ENT.MeleeAttackAnimationFaceEnemy = true -- Should it face the enemy while playing the melee attack animation?
ENT.MeleeAttackAnimationDecreaseLengthAmount = 0.2 -- This will decrease the time until starts chasing again. Use it to fix animation pauses until it chases the enemy.
ENT.MeleeAttackDistance = 30 -- How close does it have to be until it attacks?
ENT.MeleeAttackAngleRadius = 100 -- What is the attack angle radius? | 100 = In front of the SNPC | 180 = All around the SNPC
ENT.MeleeAttackDamageDistance = 70 -- How far does the damage go?
ENT.MeleeAttackDamageAngleRadius = 100 -- What is the damage angle radius? | 100 = In front of the SNPC | 180 = All around the SNPC
ENT.TimeUntilMeleeAttackDamage = 0.5 -- This counted in seconds | This calculates the time until it hits something
ENT.NextAnyAttackTime_Melee = 0.5 -- How much time until it can use a attack again? | Counted in Seconds
	-- Weapon Attack ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.ShootDistance = 2000 -- How far it can shoot, Default: 2000
ENT.ShootDistanceClose = 100 -- How close until it stops shooting, Default: 200
ENT.WeaponSpread = 55 -- What's the spread of the weapon? The more it is, the more spread it will have
ENT.AnimTbl_WeaponAttack = {ACT_RANGE_ATTACK1} -- Animation played when the SNPC does weapon attack | For VJ Weapons
ENT.WeaponAttackSchedule = {SCHED_RANGE_ATTACK1} -- Schedule played when the SNPC does weapon attack | For None-VJ Weapons
ENT.CanCrouchOnWeaponAttack = true -- Should the SNPC crouching while shooting?
ENT.CanCrouchOnWeaponAttackChance = 2 -- The greater the number is, the less chance it will have to crouch when shooting | 1 = crouch everytime
ENT.AnimTbl_WeaponAttackCrouch = {ACT_RANGE_ATTACK1_LOW} -- Animation played when the SNPC does weapon attack while crouching | For VJ Weapons
ENT.HasUnlimitedClip = true -- Set false to turn off unlimited ammo
ENT.DisableWeapons = false -- If true, SNPC can't use weapons
ENT.DisableCAP_USE_WEAPON = false -- Disables CAP_USE_WEAPON | Useful if you want to make a SNPC spawn with the same weapon all the time
ENT.DisableUSE_SHOT_REGULATOR = false -- Set to true to disable CAP_USE_SHOT_REGULATOR
ENT.AllowReloading = true -- If false, the SNPC will no longer reload
ENT.DisableWeaponReloadAnimation = false -- if true, it will disable the animation code when reloading
ENT.WeaponReloadActivites_BehindCover = {ACT_RELOAD_LOW} -- Animations that it plays when the SNPC is able to reload behind a cover
ENT.WeaponReloadSchedule_Regular = {SCHED_HIDE_AND_RELOAD} -- Schedule played when the SNPC reloads its weapon when it's NOT following something (Most likely player)
ENT.WeaponReloadSchedule_Following = {SCHED_RELOAD} -- Schedule played when the SNPC reloads its weapon when it's following something (Most likely player)
ENT.NextReloadTime = 15 -- Time until it can reload again
ENT.ReloadChance = 5 -- The second number in the math.random
ENT.WaitForEnemyToComeOut = true -- Should it wait for the enemy to come out from hiding?
ENT.WaitForEnemyToComeCustomAnimations = {} -- Leave empty to use the default animations from the base | The base will detect if it's a combine or citizen animation, and it will play ACT_IDLE_ANGRY if there is no animations found
ENT.WaitForEnemyToComeOutTime1 = 5 -- How much time should it wait until it starts chasing the enemy? | First number in math.random
ENT.WaitForEnemyToComeOutTime2 = 7 -- How much time should it wait until it starts chasing the enemy? | Second number in math.random
ENT.WaitForEnemyToComeOutDistance = 500 -- If it's this close to the enemy, it won't do it
	-- Grenade Attack ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasGrenadeAttack = false -- Should the SNPC have a grenade attack?
ENT.NextThrowGrenadeTime1 = 10 -- Time until it runs the throw grenade code again | The first # in math.random
ENT.NextThrowGrenadeTime2 = 15 -- Time until it runs the throw grenade code again | The second # in math.random
ENT.ThrowGrenadeChance = 4 -- Chance that it will throw the grenade | Set to 1 to throw all the time
ENT.GrenadeAttackThrowDistance = 1000 -- How far it can throw grenades
ENT.GrenadeAttackThrowDistanceClose = 500 -- How close until it stops throwing grenades
ENT.GrenadeAttackAttachment = "anim_attachment_LH" -- The attachment that the grenade will spawn at
ENT.DisableGrenadeAttackAnimation = false -- if true, it will disable the animation code when doing grenade attack
ENT.AnimTbl_GrenadeAttack = {"grenThrow"} -- Grenade Attack Animations
ENT.GrenadeAttackAnimationDelay = 0 -- It will wait certain amount of time before playing the animation
ENT.GrenadeAttackAnimationStopAttacks = true -- Should it stop attacks for a certain amount of time?
ENT.GrenadeAttackAnimationStopAttacksTime = 1 -- How long should it stop attacks?
ENT.GrenadeAttackAnimationFaceEnemy = true -- Should it face the enemy while playing the grenade attack animation?
ENT.TimeUntilGrenadeIsReleased = 0.8 -- Time until the grenade is released
ENT.GrenadeAttackFussTime = 3 -- Time until the grenade explodes
ENT.GrenadeAttackEntity = "obj_vj_grenade" -- The entity that the SNPC throws | Half Life 2 Grenade: "npc_grenade_frag"
ENT.GrenadeAttackModel = "models/vj_weapons/w_grenade.mdl" -- The model for the grenade entity
ENT.GrenadeAttackVelUp1 = 200 -- Grenade attack velocity up | The first # in math.random
ENT.GrenadeAttackVelUp2 = 200 -- Grenade attack velocity up | The second # in math.random
ENT.GrenadeAttackVelForward1 = 500 -- Grenade attack velocity up | The first # in math.random
ENT.GrenadeAttackVelForward2 = 500 -- Grenade attack velocity up | The second # in math.random
ENT.GrenadeAttackVelRight1 = -20 -- Grenade attack velocity right | The first # in math.random
ENT.GrenadeAttackVelRight2 = 20 -- Grenade attack velocity right | The second # in math.random
	-- Miscellaneous ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.UseSphereForFindEnemy = false -- Should the SNPC use FindInSphere for find enemy?
ENT.DisableTakeDamageFindEnemy = false -- Disable the SNPC finding the enemy when being damaged
ENT.DisableTouchFindEnemy = false -- Disable the SNPC finding the enemy when being touched
ENT.IdleSchedule_Wander = {SCHED_IDLE_WANDER} -- Animation played when the SNPC is idle, when called to wander
ENT.AnimTbl_IdleStand = {} -- Leave empty to use schedule | Only works when AI is enabled
ENT.ChaseSchedule = {SCHED_CHASE_ENEMY} -- Animation played when the SNPC is trying to chase the enemy
ENT.LastSeenEnemyTimeUntilReset = 15 -- Time until it resets its enemy if its current enemy is not visible
ENT.DistanceToRunFromEnemy = 150 -- When the enemy is this close, the SNPC will back away | Put to 0, to never back away
ENT.HasEntitiesToNoCollide = true -- If set to false, it won't run the EntitiesToNoCollide code
ENT.EntitiesToNoCollide = {} -- Entities to not collide with when HasEntitiesToNoCollide is set to true
ENT.DisableWandering = false -- Disables wandering when the SNPC is idle
ENT.DisableChasingEnemy = false -- Disables the SNPC chasing the enemy
ENT.DisableFindEnemy = false -- Disables FindEnemy code, friendly code still works though
ENT.DisableSelectSchedule = false -- Disables Schedule code, Custom Schedule can still work
ENT.DisableCapabilities = false -- If enabled, all of the CAPs will be disabled, allowing you to add your own
ENT.HasWorldShakeOnMove = false -- Should the world shake when it's moving?
ENT.NextWorldShakeOnRun = 0.5 -- How much time until the world shakes while it's running
ENT.NextWorldShakeOnWalk = 1 -- How much time until the world shakes while it's walking
ENT.WorldShakeOnMoveAmplitude = 10 -- How much the screen will shake | From 1 to 16, 1 = really low 16 = really high
ENT.WorldShakeOnMoveRadius = 1000 -- How far the screen shake goes, in world units
ENT.WorldShakeOnMoveDuration = 0.4 -- How long the screen shake will last, in seconds
ENT.WorldShakeOnMoveFrequency = 100 -- Just leave it to 100
ENT.DisableWorldShakeOnMoveWhileRunning = false -- It will not shake the world when it's running
ENT.DisableWorldShakeOnMoveWhileWalking = false -- It will not shake the world when it's walking
ENT.RunFromGrenades = true -- Set to false to disable the SNPC from running away from grenades
ENT.RunFromGrenadeDistance = 400 -- If the entity is this close to the it, then run!
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
ENT.HasExtraMeleeAttackSounds = false -- Set to true to use the extra melee attack sounds
ENT.HasMeleeAttackMissSounds = true -- If set to false, it won't play the melee attack miss sound
ENT.HasIdleSounds = true -- If set to false, it won't play the idle sounds
ENT.PlayNothingWhenCombatIdleSoundTableEmpty = false -- TRUE will disable: the base plays the regular idle sounds when the combat idle sound table is empty while the SNPC is in combat
ENT.HasPainSounds = true -- If set to false, it won't play the pain sounds
ENT.HasDeathSounds = true -- If set to false, it won't play the death sounds
ENT.HasGrenadeAttackSounds = true -- If set to false, it won't play any sound when doing grenade attack
ENT.HasOnGrenadeSightSounds = true -- If set to false, it won't play any sounds when it sees a grenade
ENT.HasWeaponReloadSounds = true -- If set to false, it won't play any sound when reloading
ENT.HasBecomeEnemyToPlayerSounds = true -- If set to false, it won't play the become enemy to player sounds
ENT.HasFollowPlayerSounds_Follow = true -- If set to false, it won't play the follow player sounds
ENT.HasFollowPlayerSounds_UnFollow = true -- If set to false, it won't play the unfollow player sounds
ENT.HasMedicSounds_BeforeHeal = true -- If set to false, it won't play any sounds before it gives a med kit to an ally
ENT.HasMedicSounds_AfterHeal = true -- If set to false, it won't play any sounds after it gives a med kit to an ally
ENT.HasOnPlayerSightSounds = true -- If set to false, it won't play the saw player sounds
ENT.HasDamageByPlayerSounds = true -- If set to false, it won't play the stupid player sounds
ENT.HasFootStepSound = true -- Should the SNPC make a footstep sound when it's moving?
ENT.FootStepTimeRun = 0.5 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 1 -- Next foot step sound when it is walking
ENT.HasBreathSound = true -- Should it make a breathing sound?
ENT.DisableFootStepOnRun = false -- It will not play the footstep sound when running
ENT.DisableFootStepOnWalk = false -- It will not play the footstep sound when walking
ENT.HasSoundTrack = false -- Does the SNPC have a sound track?
ENT.SoundTrackFadeOutTime = 2  -- Put to 0 if you want it to stop instantly
ENT.PlayAlertSoundOnlyOnce = false -- After it plays it once, it will never play it again
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {}
ENT.SoundTbl_Breath = {}
ENT.SoundTbl_Idle = {}
ENT.SoundTbl_CombatIdle = {}
ENT.SoundTbl_FollowPlayer = {}
ENT.SoundTbl_UnFollowPlayer = {}
ENT.SoundTbl_MedicBeforeHeal = {}
ENT.SoundTbl_MedicAfterHeal = {}
ENT.SoundTbl_OnPlayerSight = {}
ENT.SoundTbl_Alert = {}
ENT.SoundTbl_BecomeEnemyToPlayer = {}
ENT.SoundTbl_BeforeMeleeAttack = {}
ENT.SoundTbl_WeaponReload = {}
ENT.SoundTbl_MeleeAttack = {}
ENT.SoundTbl_MeleeAttackExtra = {}
ENT.SoundTbl_MeleeAttackMiss = {}
ENT.SoundTbl_GrenadeAttack = {}
ENT.SoundTbl_OnGrenadeSight = {}
ENT.SoundTbl_Pain = {}
ENT.SoundTbl_Impact = {}
ENT.SoundTbl_DamageByPlayer = {}
ENT.SoundTbl_Death = {}
ENT.SoundTbl_SoundTrack = {}

ENT.DefaultSoundTbl_MedicAfterHeal = {"items/smallmedkit1.wav"}
ENT.DefaultSoundTbl_MeleeAttack = {"physics/body/body_medium_impact_hard1.wav","physics/body/body_medium_impact_hard2.wav","physics/body/body_medium_impact_hard3.wav","physics/body/body_medium_impact_hard4.wav","physics/body/body_medium_impact_hard5.wav","physics/body/body_medium_impact_hard6.wav"}
ENT.DefaultSoundTbl_MeleeAttackMiss = {"npc/zombie/claw_miss1.wav","npc/zombie/claw_miss2.wav"}
ENT.DefaultSoundTbl_Impact = {"physics/flesh/flesh_impact_bullet1.wav","physics/flesh/flesh_impact_bullet2.wav","physics/flesh/flesh_impact_bullet3.wav","physics/flesh/flesh_impact_bullet4.wav","physics/flesh/flesh_impact_bullet5.wav"}
	-- ====== Sound Chances ====== --
-- Higher number = less chance of playing | 1 = Always play
-- This are all counted in seconds
ENT.IdleSoundChance = 3
ENT.CombatIdleSoundChance = 1
ENT.FollowPlayerSoundChance = 1
ENT.UnFollowPlayerSoundChance = 1
ENT.MedicBeforeHealSoundChance = 1
ENT.MedicAfterHealSoundChance = 1
ENT.OnPlayerSightSoundChance = 1
ENT.AlertSoundChance = 1
ENT.BecomeEnemyToPlayerChance = 1
ENT.BeforeMeleeAttackSoundChance = 1
ENT.MeleeAttackSoundChance = 1
ENT.ExtraMeleeSoundChance = 1
ENT.MeleeAttackMissSoundChance = 1
ENT.GrenadeAttackSoundChance = 1
ENT.OnGrenadeSightSoundChance = 1
ENT.WeaponReloadSoundChance = 1
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
ENT.NextSoundTime_Idle1 = 10
ENT.NextSoundTime_Idle2 = 30
ENT.NextSoundTime_Alert1 = 2
ENT.NextSoundTime_Alert2 = 3
ENT.NextSoundTime_OnGrenadeSight1 = 3
ENT.NextSoundTime_OnGrenadeSight2 = 3
ENT.NextSoundTime_WeaponReload1 = 3
ENT.NextSoundTime_WeaponReload2 = 5
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
ENT.FollowPlayerSoundLevel = 75
ENT.UnFollowPlayerSoundLevel = 75
ENT.BeforeHealSoundLevel = 75
ENT.AfterHealSoundLevel = 75
ENT.OnPlayerSightSoundLevel = 75
ENT.AlertSoundLevel = 80
ENT.BecomeEnemyToPlayerSoundLevel = 75
ENT.BeforeMeleeAttackSoundLevel = 75
ENT.MeleeAttackSoundLevel = 75
ENT.ExtraMeleeAttackSoundLevel = 75
ENT.MeleeAttackMissSoundLevel = 75
ENT.WeaponReloadSoundLevel = 80
ENT.GrenadeAttackSoundLevel = 80
ENT.OnGrenadeSightSoundLevel = 80
ENT.PainSoundLevel = 80
ENT.ImpactSoundLevel = 60
ENT.DamageByPlayerSoundLevel = 75
ENT.DeathSoundLevel = 80
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
ENT.BecomeEnemyToPlayerPitch1 = 80
ENT.BecomeEnemyToPlayerPitch2 = 100
ENT.BeforeMeleeAttackSoundPitch1 = 80
ENT.BeforeMeleeAttackSoundPitch2 = 100
ENT.MeleeAttackSoundPitch1 = 95
ENT.MeleeAttackSoundPitch2 = 100
ENT.ExtraMeleeSoundPitch1 = 80
ENT.ExtraMeleeSoundPitch2 = 100
ENT.MeleeAttackMissSoundPitch1 = 90
ENT.MeleeAttackMissSoundPitch2 = 100
ENT.WeaponReloadSoundPitch1 = 80
ENT.WeaponReloadSoundPitch2 = 100
ENT.GrenadeAttackSoundPitch1 = 80
ENT.GrenadeAttackSoundPitch2 = 100
ENT.OnGrenadeSightSoundPitch1 = 80
ENT.OnGrenadeSightSoundPitch2 = 100
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
ENT.HasSeenGrenade = false
ENT.SawPlayer = false
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
ENT.ThrowingGrenade = false
ENT.ResetedEnemy = true
ENT.VJ_IsBeingControlled = false
ENT.VJ_PlayingSequence = false
ENT.PlayedResetEnemyRunSchedule = false
ENT.Weapon_AlreadyReloadedWithNoAnim = false
ENT.VJ_IsPlayingSoundTrack = false
ENT.HasDone_PlayAlertSoundOnlyOnce = false
ENT.PlayingAttackAnimation = false
ENT.DoingWeaponAttack = false
ENT.WaitingForEnemyToComeOut = false
ENT.OnPlayerSight_AlreadySeen = false
ENT.VJDEBUG_SNPC_ENABLED = false
ENT.DoingMoveOutOfFriendlyPlayersWay = false
ENT.DidWeaponAttackAimParameter = false
ENT.Medic_IsHealingAlly = false
ENT.Medic_WanderValue = false
ENT.Medic_ChaseValue = false
ENT.AlreadyDoneMedicThinkCode = false
ENT.AlreadyBeingHealedByMedic = false
ENT.ZombieFriendly = false
ENT.AntlionFriendly = false
ENT.CombineFriendly = false
ENT.ShouldBeFlying = false
ENT.FollowingPlayerName = NULL
ENT.MyEnemy = NULL
ENT.VJ_TheController = NULL
ENT.Medic_CurrentEntToHeal = NULL
ENT.Medic_SpawnedProp = NULL
ENT.LastPlayedVJSound = nil
ENT.LatestEnemyClass = nil
ENT.NextMoveOutOfFriendlyPlayersWayT = 0
ENT.Weapon_ShotsSinceLastReload = 0
ENT.TestT = 0
ENT.NextFollowPlayerT = 0
ENT.AngerLevelTowardsPlayer = 0
ENT.NextBreathSoundT = 0
ENT.FootStepT = 0
ENT.PainSoundT = 0
ENT.WorldShakeWalkT = 0
ENT.NextRunAwayOnDamageT = 0
ENT.NextIdleSoundT = 0
ENT.NextReloadT = 1
ENT.NextNoWeaponT = 0
ENT.NextCallForHelpT = 0
ENT.NextEntityCheckT = 0
ENT.NextFindEnemyT = 0
ENT.NextThrowGrenadeT = 0
ENT.NextBackUpOnDamageT = 0
ENT.NextOnGrenadeSightSoundT = 0
ENT.NextMoveOrHideOnDamageByEnemyT = 0
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
ENT.NextWeaponAttackAimPoseParametersReset = 0
ENT.NextWeaponReloadSoundT = 0
ENT.TimeSinceSeenEnemy = 0
ENT.Medic_NextHealT = 0
ENT.Weapon_TimeSinceLastShot = 5
ENT.LatestEnemyPosition = Vector(0,0,0)
	-- Tables ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HL2_Animals = {"npc_barnacle", "npc_crow", "npc_pigeon", "npc_seagull", "monster_cockroach"}
ENT.HL2_Resistance = {"npc_magnusson", "npc_vortigaunt", "npc_mossman", "npc_monk", "npc_kleiner", "npc_fisherman", "npc_eli", "npc_dog", "npc_barney", "npc_alyx", "npc_citizen"}
ENT.HL2_Combine = {"npc_stalker", "npc_rollermine", "npc_turret_ground", "npc_turret_floor", "npc_turret_ceiling", "npc_strider", "npc_sniper", "npc_metropolice", "npc_hunter", "npc_breen", "npc_combine_camera", "npc_combine_s", "npc_combinedropship", "npc_combinegunship", "npc_cscanner", "npc_clawscanner", "npc_helicopter", "npc_manhack"}
ENT.HL2_Zombies = {"npc_fastzombie_torso", "npc_zombine", "npc_zombie_torso", "npc_zombie", "npc_poisonzombie", "npc_headcrab_fast", "npc_headcrab_black", "npc_headcrab", "npc_fastzombie", "monster_zombie", "monster_headcrab", "monster_babycrab"}
ENT.HL2_Antlions = {"npc_antlion", "npc_antlionguard", "npc_antlion_worker"}
ENT.AttackTimers = {"timer_melee_finished","timer_melee_start"}
ENT.AttackTimersCustom = {}
ENT.EntitiesToRunFrom = {"obj_vj_grenade","npc_grenade_frag","doom3_grenade","fas2_thrown_m67","cw_grenade_thrown","obj_cpt_grenade"}
ENT.Weapons_UseRegulate = {"weapon_shotgun","weapon_crossbow","weapon_annabelle","weapon_pistol"}
ENT.Weapons_DontUseRegulate = {"weapon_smg1","weapon_ar2"}
ENT.VJ_AddCertainEntityAsEnemy = {}
ENT.VJ_AddCertainEntityAsFriendly = {}
	
function VJ_TABLERANDOM(vtblname) return vtblname[math.random(1,table.Count(vtblname))] end
//function VJ_STOPSOUND(vsoundname) if vsoundname then vsoundname:Stop() end end

util.AddNetworkString("vj_human_onthememusic")
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
function ENT:CustomOnTouch(entity) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key, activator, caller) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnFollowPlayer(key, activator, caller) end
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
function ENT:CustomOnMeleeAttack_Miss() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_BeforeStartTimer() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_AfterStartTimer() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnWeaponAttack() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnWaitForEnemyToComeOut() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnWeaponReload() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnGrenadeAttack() end
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
function ENT:CustomOnDropWeapon(dmginfo,hitgroup) end
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
	gib:GetPhysicsObject():AddVelocity(Vector(500,500,100)) -- Make things fly
	cleanup.ReplaceEntity(gib) -- Make it remove on map cleanup
	if GetConVarNumber("vj_npc_fadegibs") == 1 then -- Make the ragdoll fade through menu
	gib:Fire( "FadeAndRemove", "", GetConVarNumber("vj_npc_fadegibstime") ) end
	*/
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetSpawnEffect(false)
	//if GetConVarNumber("vj_npc_noweapon") == 0 then
	//if self.DisableWeapons == false then
	//self:Give("weapon_citizensuitcase") end end
	self:SetModel(VJ_PICKRANDOMTABLE(self.Model))
	self:SetMaxYawSpeed(self.TurningSpeed)
	if self.HasHull == true then self:SetHullType(self.HullType) end
	if self.HullSizeNormal == true then self:SetHullSizeNormal() end
	self:SetCustomCollisionCheck()
	if self.HasSetSolid == true then self:SetSolid(SOLID_BBOX) end
	self:SetMoveType(self.MoveType)
	if self.DisableCapabilities == false then self:SetInitializeCapabilities() end
	self:SetCollisionGroup(COLLISION_GROUP_NPC)
	self.NextThrowGrenadeT = CurTime() + math.Rand(1,5)
	self.NextIdleSoundT_UnChanged = CurTime() + 0
	self.NextIdleSoundT = CurTime() + math.random(1,20)
	//self.NextChaseTime = CurTime() + math.random(4,5)
	self:SetEnemy(nil)
	self:SetUseType(SIMPLE_USE)
	if GetConVarNumber("vj_npc_allhealth") == 0 then
	if GetConVarNumber("vj_npc_dif_normal") == 1 then self:SetHealth(self.StartHealth) end -- Normal
	if GetConVarNumber("vj_npc_dif_easy") == 1 then self:SetHealth(self.StartHealth/2) end -- Easy
	if GetConVarNumber("vj_npc_dif_hard") == 1 then self:SetHealth(self.StartHealth*1.5) end -- Hard
	if GetConVarNumber("vj_npc_dif_hellonearth") == 1 then self:SetHealth(self.StartHealth*2.5) end else -- Hell On Earth
	self:SetHealth(GetConVarNumber("vj_npc_allhealth")) end
	self.StartHealth = self:Health()
	if self.HasSquad == true then self:Fire("setsquad",self.SquadName,0) end
	self:SetName(self.PrintName)
	//self.Corpse = ents.Create(self.DeathEntityType)
	self:CustomOnInitialize()
	self:CustomInitialize() -- Backwards Compatibility! DO NOT USE!
	self:ConvarsOnInit()
	if math.random(1,self.SoundTrackChance) == 1 then self:StartSoundTrack() end
	self:SetRenderMode(RENDERMODE_NORMAL)
	//self:SetRenderMode(RENDERMODE_TRANSALPHA)
	duplicator.RegisterEntityClass(self:GetClass(),VJSPAWN_SNPC_DUPE,"Model","Class","Equipment","SpawnFlags","Data")
	timer.Simple(0.1,function()
	if IsValid(self) then
	if self.DisableWeapons == false && self:GetActiveWeapon() != NULL then
		self.Weapon_StartingAmmoAmount = self:GetActiveWeapon():Clip1()
		if self.HasUnlimitedClip == true then self:GetActiveWeapon():SetClip1(99999) end
	end
	if GetConVarNumber("vj_npc_nosnpcchat") == 0 && IsValid(self:GetCreator()) && self.DisableWeapons == false then
		if self:GetActiveWeapon() == NULL then self:GetCreator():PrintMessage(HUD_PRINTTALK, "WARNING: "..self:GetName().." needs a weapon!") end
		if !(self:GetActiveWeapon().IsVJBaseWeapon) && self:GetActiveWeapon() != NULL then self:GetCreator():PrintMessage(HUD_PRINTTALK, "NOTE: "..self:GetName().." needs a weapon that runs on VJ Base to work properly!") end
		end
	 end
	end)
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
	self:VJ_SetSchedule(SCHED_FALL_TO_GROUND)
	if self.VJ_IsStationary == true then
		self.HasFootStepSound = false
		self.HasWorldShakeOnMove = false
		self.RunAwayOnUnknownDamage = false
		self.DisableWandering = true
		self.DisableChasingEnemy = true
	end
end
function ENT:CustomInitialize() end -- Backwards Compatibility! DO NOT USE!
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInitializeCapabilities()
-- Add as many as you want --
	self:CapabilitiesAdd(bit.bor(CAP_ANIMATEDFACE))
	self:CapabilitiesAdd(bit.bor(CAP_TURN_HEAD))
	if self.VJ_IsStationary == false then self:CapabilitiesAdd(bit.bor(CAP_MOVE_GROUND)) end
	self:CapabilitiesAdd(bit.bor(CAP_OPEN_DOORS))
	self:CapabilitiesAdd(bit.bor(CAP_AUTO_DOORS))
	self:CapabilitiesAdd(bit.bor(CAP_USE))
	//self:CapabilitiesAdd(bit.bor(CAP_MOVE_JUMP))
	self:CapabilitiesAdd(bit.bor(CAP_DUCK))
	if self.HasSquad == true then self:CapabilitiesAdd(bit.bor(CAP_SQUAD)) end
	if self.DisableWeapons == false then
	if self.DisableCAP_USE_WEAPON == false then 
	self:CapabilitiesAdd(bit.bor(CAP_USE_WEAPONS))
	self:CapabilitiesAdd(bit.bor(CAP_WEAPON_RANGE_ATTACK1)) end
	if self.DisableUSE_SHOT_REGULATOR == false then
	self:CapabilitiesAdd(bit.bor(CAP_USE_SHOT_REGULATOR)) end
	if self.VJ_IsStationary == false then self:CapabilitiesAdd(bit.bor(CAP_MOVE_SHOOT)) end
	//self:CapabilitiesAdd(bit.bor(CAP_AIM_GUN))
 end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:WorldShakeOnMoveCode()
if self.HasWorldShakeOnMove == false then return end
	if self:IsOnGround() && self:IsMoving() && CurTime() > self.WorldShakeWalkT then
		self:CustomOnWorldShakeOnMove()
		if self.DisableWorldShakeOnMoveWhileRunning == false && table.HasValue(VJ_RunActivites,self:GetMovementActivity()) then
		self:CustomOnWorldShakeOnMove_Run()
		util.ScreenShake(self:GetPos(),self.WorldShakeOnMoveAmplitude,self.WorldShakeOnMoveFrequency,self.WorldShakeOnMoveDuration,self.WorldShakeOnMoveRadius)
		self.WorldShakeWalkT = CurTime() + self.NextWorldShakeOnRun
		elseif self.DisableWorldShakeOnMoveWhileWalking == false && table.HasValue(VJ_WalkActivites,self:GetMovementActivity()) then
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
ENT.LatestTaskName = nil
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
function ENT:VJ_ACT_DOCROUCH(CustomAnimTbl,CustomAnimTblForDefault,StopActs,StopActsTime,FaceEnemy)
	local ShouldUseCustomAnimTblForDefault = false
	CustomAnimTbl = CustomAnimTbl or {}
	CustomAnimTblForDefault = CustomAnimTblForDefault or {}
	StopActs = StopActs or false
	StopActsTime = StopActsTime or 2
	FaceEnemy = FaceEnemy or false
	if table.Count(CustomAnimTblForDefault) != 0 then ShouldUseCustomAnimTblForDefault = true end
	if table.Count(CustomAnimTbl) != 0 then self:VJ_ACT_PLAYACTIVITY(VJ_PICKRANDOMTABLE(CustomAnimTbl),StopActs,StopActsTime,FaceEnemy) else
		if self:SelectWeightedSequence(ACT_CROUCHIDLE) != -1 then -- Combine animations
			if ShouldUseCustomAnimTblForDefault == true then
			self:VJ_ACT_PLAYACTIVITY(VJ_PICKRANDOMTABLE({VJ_PICKRANDOMTABLE(CustomAnimTblForDefault),VJ_PICKRANDOMTABLE({ACT_RANGE_AIM_LOW})}),StopActs,StopActsTime,FaceEnemy) else
			self:VJ_ACT_PLAYACTIVITY(VJ_PICKRANDOMTABLE({ACT_RANGE_AIM_LOW}),StopActs,StopActsTime,FaceEnemy) end
		elseif self:SelectWeightedSequence(ACT_PICKUP_RACK) != -1 or self:SelectWeightedSequence(ACT_POLICE_HARASS1) != -1 then -- Citizen/Metrocop animations
			if self:GetActiveWeapon().HoldType == "shotgun" or self:GetActiveWeapon().HoldType == "crossbow" then
				if ShouldUseCustomAnimTblForDefault == true then
				self:VJ_ACT_PLAYACTIVITY(VJ_PICKRANDOMTABLE({VJ_PICKRANDOMTABLE(CustomAnimTblForDefault),VJ_PICKRANDOMTABLE({ACT_IDLE_AIM_RIFLE_STIMULATED})}),StopActs,StopActsTime,FaceEnemy)
				self:VJ_ACT_PLAYACTIVITY(VJ_PICKRANDOMTABLE({ACT_IDLE_AIM_RIFLE_STIMULATED}),StopActs,StopActsTime,FaceEnemy) end
			elseif self:GetActiveWeapon().HoldType == "ar2" then
				if ShouldUseCustomAnimTblForDefault == true then
				self:VJ_ACT_PLAYACTIVITY(VJ_PICKRANDOMTABLE({VJ_PICKRANDOMTABLE(CustomAnimTblForDefault),VJ_PICKRANDOMTABLE({ACT_RANGE_AIM_SMG1_LOW})}),StopActs,StopActsTime,FaceEnemy)
				self:VJ_ACT_PLAYACTIVITY(VJ_PICKRANDOMTABLE({ACT_RANGE_AIM_SMG1_LOW}),StopActs,StopActsTime,FaceEnemy) end
			else
				if ShouldUseCustomAnimTblForDefault == true then
				self:VJ_ACT_PLAYACTIVITY(VJ_PICKRANDOMTABLE({VJ_PICKRANDOMTABLE(CustomAnimTblForDefault),VJ_PICKRANDOMTABLE({ACT_RANGE_AIM_LOW})}),StopActs,StopActsTime,FaceEnemy)
				self:VJ_ACT_PLAYACTIVITY(VJ_PICKRANDOMTABLE({ACT_RANGE_AIM_LOW}),StopActs,StopActsTime,FaceEnemy) end
			end
		else -- Unknown, recommanded to use custom animations or disable WaitForEnemyToComeOut in situations like this
			self:VJ_ACT_PLAYACTIVITY(VJ_PICKRANDOMTABLE({ACT_IDLE_ANGRY}),StopActs,StopActsTime,FaceEnemy)
		end
	end
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
function ENT:VJ_ACT_PLAYACTIVITY(vACT_Name,vACT_StopActivities,vACT_StopActivitiesTime,vACT_FaceEnemy,vACT_DelayAnim,vACT_AlwaysUseSequence,vACT_SequenceDuration)
	if vACT_Name == nil or vACT_Name == false then return end
	vACT_StopActivities = vACT_StopActivities or false
	vACT_StopActivitiesTime = vACT_StopActivitiesTime or 0
	vACT_FaceEnemy = vACT_FaceEnemy or false
	vACT_DelayAnim = vACT_DelayAnim or 0
	vACT_AlwaysUseSequence = vACT_AlwaysUseSequence or false
	
	if type(vACT_Name) != "string" && self:SelectWeightedSequence(vACT_Name) == -1 && self:GetSequenceName(self:SelectWeightedSequence(vACT_Name)) == "Not Found!" then
		if self:GetActiveWeapon() != NULL then
			if table.HasValue(table.GetKeys(self:GetActiveWeapon().ActivityTranslateAI),vACT_Name) != true then return end
		else
			return
		end
	end
	
	local vsched = ai_vj_schedule.New("vj_act_"..vACT_Name)
	local NonACTSeq = false
	if vACT_AlwaysUseSequence == true then
		NonACTSeq = true
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
	if vACT_AlwaysUseSequence == false && type(vACT_Name) == "string" then
		local checkanim = self:GetSequenceActivity(self:LookupSequence(vACT_Name))
		if string.find(vACT_Name, "vjseq_") then
			NonACTSeq = true
			vACT_Name = string.Replace(vACT_Name,"vjseq_","")
		else
			if checkanim == nil or checkanim == -1 then
				NonACTSeq = true
			else
				vACT_Name = self:GetSequenceActivity(self:LookupSequence(vACT_Name))
			end
		end
	end
	if NonACTSeq == false then self.VJ_PlayingSequence = false end
	
	timer.Simple(vACT_DelayAnim,function()
	if IsValid(self) then
		if NonACTSeq  == true then
			vACT_SequenceDuration = vACT_SequenceDuration or self:SequenceDuration(self:LookupSequence(vACT_Name))
			if vACT_FaceEnemy == true then self:FaceCertainEntity(self:GetEnemy(),true) end
			self:VJ_PlaySequence(vACT_Name,1,true,vACT_SequenceDuration)
		end
		vsched:EngTask("TASK_STOP_MOVING", 0)
		vsched:EngTask("TASK_STOP_MOVING", 0)
		self:StopMoving()
		self:ClearSchedule()
		if NonACTSeq == false then
			if vACT_FaceEnemy == true then
			vsched:EngTask("TASK_PLAY_SEQUENCE_FACE_ENEMY",vACT_Name) else
			vsched:EngTask("TASK_PLAY_SEQUENCE",vACT_Name) end
		end
		//self:ClearSchedule()
		//self:StartEngineTask(GetTaskList("TASK_RESET_ACTIVITY"), 0)
		self:StartSchedule(vsched)
		self:MaintainActivity()
		end
	end)
	//self:MaintainActivity()
	//self:TaskComplete()
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
	local idleanim_tbl = self.AnimTbl_IdleStand
	local ideanimrand_act = VJ_PICKRANDOMTABLE(idleanim_tbl)
	if type(ideanimrand_act) == "number" then ideanimrand_act = self:GetSequenceName(self:SelectWeightedSequence(ideanimrand_act)) end
	if table.Count(idleanim_tbl) > 0 /*&& self:GetSequenceName(self:GetSequence()) != ideanimrand_act*/ then
		self:VJ_ACT_PLAYACTIVITY(ideanimrand_act,false,0,true,0)
	else
		if self:IsCurrentSchedule(SCHED_IDLE_STAND) != true then
		self:VJ_SetSchedule(SCHED_IDLE_STAND)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoIdleAnimation(RestrictNumber,OverrideWander)
	if self.IsVJBaseSNPC_Tank == true then return end
	if self.VJ_PlayingSequence == true or self.FollowingPlayer == true or self.PlayingAttackAnimation == true or self.Dead == true or (self.NextIdleTime > CurTime()) then return end
	-- 0 = Random | 1 = Wander | 2 = Idle Stand /\ OverrideWander = Wander no matter what
	RestrictNumber = RestrictNumber or 0
	OverrideWander = OverrideWander or false
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
function ENT:DoChaseAnimation(OverrideChasing)
	if !IsValid(self:GetEnemy()) or self:GetEnemy() == nil then return end
	if self.IsVJBaseSNPC_Tank == true or self.VJ_PlayingSequence == true or self.FollowingPlayer == true or self.PlayingAttackAnimation == true or self.Dead == true or (self.NextChaseTime > CurTime()) then return end
	if self:VJ_GetNearestPointToEntityDistance(self:GetEnemy()) < self.MeleeAttackDistance && self:GetEnemy():Visible(self) then return end
	-- OverrideChasing = Chase no matter what
	OverrideChasing = OverrideChasing or false
	if OverrideChasing == false && self.DisableChasingEnemy == true then self:VJ_ACT_IDLESTAND(math.Rand(6,12)) return end
	//if self.HasWalkingCapability == false then self:VJ_ACT_IDLESTAND(0.1) else
	self:VJ_SetSchedule(VJ_PICKRANDOMTABLE(self.ChaseSchedule))
	self.NextChaseTime = CurTime() + 0.1
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetAttackSpread(Weapon, Target)
	//print(Weapon)
	//print(Target)
	//return self.WeaponSpread -- If used, put 3
	return
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
function ENT:FollowPlayerCode(key, activator, caller)
if self.FollowPlayer == false then return end
if GetConVarNumber("ai_disabled") == 1 then return end
if GetConVarNumber("ai_ignoreplayers") == 1 then return end
	if key == self.FollowPlayerKey && activator:IsPlayer() then
	if activator:IsValid() && activator:Alive() then
	if self:Disposition(activator) == D_HT then
	if self.FollowPlayerChat == true then
	activator:PrintMessage(HUD_PRINTTALK, self:GetName().." doesn't like you, therefore it won't follow you.") end return end
	self:CustomOnFollowPlayer(key, activator, caller)
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
function ENT:DoMedicCode_HealAlly()
	-- for k,v in ipairs(player.GetAll()) do v.AlreadyBeingHealedByMedic = false end
	if self.IsMedicSNPC == false then return end
	if self.Medic_IsHealingAlly == true then return end
	if CurTime() < self.Medic_NextHealT then return end
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
function ENT:AcceptInput(key, activator, caller)
	self:CustomOnAcceptInput(key, activator, caller)
	self:FollowPlayerCode(key, activator, caller)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FaceCertainEntity(argent,OnlyIfSeenEnemy)
	if GetConVarNumber("ai_disabled") == 0 then
	if OnlyIfSeenEnemy == true then
	if self:GetEnemy() != nil then
	//local getenemytoself = self:GetEnemy():GetAngles().y -self:GetAngles().y
	self:SetAngles(Angle(0,(argent:GetPos()-self:GetPos()):Angle().y,0)) //SetLocalAngles
	end else
	self:SetAngles(Angle(0,(argent:GetPos()-self:GetPos()):Angle().y,0))
  end
 end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	//if CurTime() > self.TestT then
	//self:VJ_ACT_PLAYACTIVITY(ACT_SIGNAL_ADVANCE,true,2,true,0.5)
	//self.TestT = CurTime() + 200 end
	//if self:GetActiveWeapon():GetClass() == "weapon_smg1" then print("SMG1") end
	//self.Entity:SetColor(Color(0,1000,0))
	
	if self.DisableWeapons == false && self:GetActiveWeapon() != NULL then
		if self.DisableUSE_SHOT_REGULATOR == false && table.HasValue(self.Weapons_UseRegulate,self:GetActiveWeapon():GetClass()) then
			self:CapabilitiesAdd(bit.bor(CAP_USE_SHOT_REGULATOR))
		end
		if table.HasValue(self.Weapons_DontUseRegulate,self:GetActiveWeapon():GetClass()) or self:GetActiveWeapon().NPC_EnableDontUseRegulate == true then
			self:CapabilitiesRemove(CAP_USE_SHOT_REGULATOR)
		end
	end
	
	self:ConvarsOnThink()
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
	self:CustomOnThink_AIEnabled()
	//if self:GetEnemy() != nil then self.Alerted = true else self.Alerted = false end
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

	self:FootStepSoundCode()
	self:WorldShakeOnMoveCode()
	if self:GetActiveWeapon() != NULL then self.Weapon_TimeSinceLastShot = self.Weapon_TimeSinceLastShot + 0.1 end

if self.FollowingPlayer == true then
	//print(self:GetTarget())
	//print(self.FollowingPlayerName)
	if GetConVarNumber("ai_ignoreplayers") == 1 then
	self:FollowPlayerReset() end
	if GetConVarNumber("ai_ignoreplayers") == 0 then
	if !self.FollowingPlayerName:Alive() then
	self:FollowPlayerReset() end
	if CurTime() > self.NextFollowPlayerT then
	if IsValid(self.FollowingPlayerName) && self.FollowingPlayerName:Alive() then
	local DistanceToPlayer = self:GetPos():Distance(self.FollowingPlayerName:GetPos())
	//print(DistanceToPlayer)
	if DistanceToPlayer > self.FollowPlayerCloseDistance then
	self.DontStartShooting_FollowPlayer = true
	self:VJ_ACT_FOLLOWTARGET() else
	self:StopMoving()
	self.DontStartShooting_FollowPlayer = false end
	self.NextFollowPlayerT = CurTime() + self.NextFollowPlayerTime
	end
  end
 end
end

	if self.PlayerFriendly == true && self.MoveOutOfFriendlyPlayersWay == true && (!self.IsVJBaseSNPC_Tank) && CurTime() > self.NextMoveOutOfFriendlyPlayersWayT && GetConVarNumber("ai_ignoreplayers") == 0 /*&& self:GetEnemy() == nil*/ then
	for k,v in ipairs(player.GetAll()) do
		local nigersarenigs = 30
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

//print(self.Weapon_ShotsSinceLastReload)
//print(self.Weapon_AlreadyReloadedWithNoAnim)
//print(self.Weapon_StartingAmmoAmount)
if self.Weapon_StartingAmmoAmount == nil then
	self.Weapon_StartingAmmoAmount = 30
end

if self:GetEnemy() != nil then
	self.ResetedEnemy = false
	self:UpdateEnemyMemory(self:GetEnemy(),self:GetEnemy():GetPos())
	self.LatestEnemyPosition = self:GetEnemy():GetPos()
	self.LatestEnemyClass = self:GetEnemy()
	self.TimeSinceSeenEnemy = 0
	if self:GetEnemy():Visible(self) && (self:GetForward():Dot((self:GetEnemy():GetPos() -self:GetPos()):GetNormalized()) > math.cos(math.rad(self.SightAngle))) && (self:GetEnemy():GetPos():Distance(self:GetPos()) < self.SightDistance) then
	//self.LatestEnemyPosition = self:GetEnemy():GetPos()
		self.LastSeenEnemyTime = 0 else
		if (self:GetEnemy():GetPos():Distance(self:GetPos()) < 4000) then
		self.LastSeenEnemyTime = self.LastSeenEnemyTime + 0.1 else self.LastSeenEnemyTime = self.LastSeenEnemyTime + 0.5 end
	end

	// if self:VJ_ForwardIsHidingZone(self:NearestPoint(self:GetPos() +self:OBBCenter()),self:GetEnemy():EyePos()) == true then
	
	if self.AllowReloading == true && self.DisableWeapons == false && self:GetActiveWeapon() != NULL && self.DontStartShooting_FollowPlayer == false && self.ThrowingGrenade == false && self.VJ_PlayingSequence == false && (!self.IsVJBaseSNPC_Tank) && self.VJ_IsBeingControlled == false then
		//if CurTime() > self.NextReloadT then
		//if math.random(1,self.ReloadChance) < 3 then
		if self.Weapon_ShotsSinceLastReload > self.Weapon_StartingAmmoAmount then
		if self.HasUnlimitedClip == true then self:GetActiveWeapon():SetClip1(99999) end
		self:CustomOnWeaponReload()
		self.Weapon_ShotsSinceLastReload = 0
		if self.Weapon_AlreadyReloadedWithNoAnim == true then
			self.Weapon_AlreadyReloadedWithNoAnim = false
			if self.DisableWeaponReloadAnimation == false then
				self.DoingWeaponAttack = false
				self.WaitingForEnemyToComeOut = true
				self:WeaponReloadSoundCode()
				if self.FollowingPlayer == false then
				local niganim = VJ_PICKRANDOMTABLE(self.WeaponReloadActivites_BehindCover)
				if self:VJ_ForwardIsHidingZone(self:NearestPoint(self:GetPos() +self:OBBCenter()),self:GetEnemy():EyePos()) == true && self:SelectWeightedSequence(niganim) != -1 then
					self:VJ_ACT_PLAYACTIVITY(niganim,false,0,false) else
					self:VJ_SetSchedule(VJ_PICKRANDOMTABLE(self.WeaponReloadSchedule_Regular)) end
				else
					self:VJ_SetSchedule(VJ_PICKRANDOMTABLE(self.WeaponReloadSchedule_Following)) 
				end
			end
		else
			local randreloadthing = math.random(1,2)
			if randreloadthing == 1 then
				self:CapabilitiesRemove(CAP_MOVE_SHOOT)
				timer.Simple(2,function() if IsValid(self) then
					self:CapabilitiesAdd(bit.bor(CAP_MOVE_SHOOT))
					end
				end)
				if self.DisableWeaponReloadAnimation == false then
					self.DoingWeaponAttack = false
					self.WaitingForEnemyToComeOut = true
					self:WeaponReloadSoundCode()
					if self.FollowingPlayer == false then
					local niganim = VJ_PICKRANDOMTABLE(self.WeaponReloadActivites_BehindCover)
					if self:VJ_ForwardIsHidingZone(self:NearestPoint(self:GetPos() +self:OBBCenter()),self:GetEnemy():EyePos()) == true && self:SelectWeightedSequence(niganim) != -1 then
						self:VJ_ACT_PLAYACTIVITY(niganim,false,0,false) else
						self:VJ_SetSchedule(VJ_PICKRANDOMTABLE(self.WeaponReloadSchedule_Regular)) end
					else
						self:VJ_SetSchedule(VJ_PICKRANDOMTABLE(self.WeaponReloadSchedule_Following)) 
					end
				end
			else
				self.Weapon_AlreadyReloadedWithNoAnim = true
				//self:VJ_SetSchedule(SCHED_RELOAD)
				end
			end
		end
		//self.NextReloadT = CurTime() + self.NextReloadTime end end end
	end
 
	if self.ThrowingGrenade == false && self.CallForHelp == true then
		if CurTime() > self.NextCallForHelpT then
		self:CallForHelpCode(self.CallForHelpDistance)
		self.NextCallForHelpT = CurTime() + self.NextCallForHelpTime
		end
	end
	
	if self.HasGrenadeAttack == true && self.VJ_IsBeingControlled == false then
		if CurTime() > self.NextThrowGrenadeT then
		local grenchance = math.random(1,self.ThrowGrenadeChance)
		local EnemyDistance = self:GetPos():Distance(self:GetEnemy():GetPos())
		if grenchance == 1 then
		if EnemyDistance < self.GrenadeAttackThrowDistance && EnemyDistance > self.GrenadeAttackThrowDistanceClose then
		self:ThrowGrenadeCode() end end
		self.NextThrowGrenadeT = CurTime() + math.random(self.NextThrowGrenadeTime1,self.NextThrowGrenadeTime2)
		end
	end
end

if CurTime() > self.NextEntityCheckT then
	self:DoEntityRelationshipCheck()
	self:CheckForGrenades()
	self:DoMedicCode_HealAlly()
	
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

	/*if self:GetEnemy() != nil && self:Visible(self:GetEnemy()) && (self:GetActiveWeapon().IsVJBaseWeapon) && self.DoingWeaponAttack == false then
		//self:FaceCertainEntity(self:GetEnemy(),true)
		if !table.HasValue(self.AnimTbl_WeaponAttack,self:GetActivity()) && !table.HasValue(self.AnimTbl_WeaponAttackCrouch,self:GetActivity()) then
		self:SelectSchedule()
		end
	end*/
	
	if self:GetEnemy() != nil && self.DoingWeaponAttack == true then
		StartPos = self:NearestPoint(self:GetPos() +self:OBBCenter())
		EndPos = self:GetEnemy():EyePos()
		tr = util.TraceLine({
			start = StartPos,
			endpos = EndPos,
			filter = self
		})
		if tr.Entity:IsNPC() && tr.HitPos:Distance(tr.StartPos) <= 3000 && (self:Disposition(tr.Entity) == D_LI or self:Disposition(tr.Entity) == D_NU) then
			local checkdist = self:VJ_CheckAllFourSides(40)
			if checkdist.Right == true && checkdist.Left == true then
				local cptisrand = math.random(1,2)
				if cptisrand == 1 then
					self:SetLastPosition(self:GetPos() + self:GetRight()*math.random(30,40))
					self:VJ_SetSchedule(SCHED_FORCED_GO)
				end
				if cptisrand == 2 then
					self:SetLastPosition(self:GetPos() + self:GetRight()*math.random(-40,-30))
					self:VJ_SetSchedule(SCHED_FORCED_GO)
				end
			else
			if checkdist.Right == true then
				self:SetLastPosition(self:GetPos() + self:GetRight()*math.random(30,40))
				self:VJ_SetSchedule(SCHED_FORCED_GO)
			end
			if checkdist.Left == true then
				self:SetLastPosition(self:GetPos() + self:GetRight()*math.random(-40,-30))
				self:VJ_SetSchedule(SCHED_FORCED_GO)
			end
		 end
		end
	end
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

//if self.TakingCover == false then
	
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
	
	/*if self:GetEnemy() != nil then
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
if self:GetEnemy() == nil then
	self.DoingWeaponAttack = false
	if CurTime() > self.NextWeaponAttackAimPoseParametersReset && self.DidWeaponAttackAimParameter == true && self.DoingWeaponAttack == false then
		self:ClearPoseParameters()
		self.DidWeaponAttackAimParameter = false
	end
end

if self:GetEnemy() != nil then
	self:WeaponAimPoseParameters()
	if (self:Visible(self:GetEnemy()) == false or (!table.HasValue(self.AnimTbl_WeaponAttack,self:GetActivity()) && !table.HasValue(self.AnimTbl_WeaponAttackCrouch,self:GetActivity()))) then
		self.DoingWeaponAttack = false
	end
	if self.VJ_IsBeingControlled == false then
		if self.VJ_IsStationary == true && self.CanTurnWhileStationary == true then self:FaceCertainEntity(self:GetEnemy(),true) end
		if self.MeleeAttackAnimationFaceEnemy == true && self.Dead == false && timer.Exists("timer_melee_start"..self.Entity:EntIndex()) && timer.TimeLeft("timer_melee_start"..self.Entity:EntIndex()) > 0 then self:FaceCertainEntity(self:GetEnemy(),true) end
		if self.GrenadeAttackAnimationFaceEnemy == true && self.Dead == false && self.ThrowingGrenade == true then self:FaceCertainEntity(self:GetEnemy(),true) end
	end
	//if self.PlayingAttackAnimation == true then self:FaceCertainEntity(self:GetEnemy(),true) end
	if self.ResetedEnemy == true then
	self.ResetedEnemy = false end
	-- Melee Attack Timer --
	if self.HasMeleeAttack == true then
	//print(self:NearestPoint(self:GetEnemy():GetPos() +self:OBBCenter()):Distance(self:GetEnemy():NearestPoint(self:GetPos() +self:GetEnemy():OBBCenter())))
	//PrintMessage(HUD_PRINTTALK,self:VJ_GetNearestPointToEntityDistance(self:GetEnemy()))
	// self:GetEnemy():GetPos():Distance(self:GetPos())
	if (self:VJ_GetNearestPointToEntityDistance(self:GetEnemy()) < self.MeleeAttackDistance && self:GetEnemy():Visible(self)) && self.VJ_IsBeingControlled == false /*&& self.VJ_PlayingSequence == false*/ && (self:GetForward():Dot((self:GetEnemy():GetPos() -self:GetPos()):GetNormalized()) > math.cos(math.rad(self.MeleeAttackAngleRadius))) then
	if self.MeleeAttacking == false && self.vACT_StopAttacks == false && self.Flinching == false then
	self:CustomOnMeleeAttack_BeforeStartTimer()
	self:BeforeMeleeAttackSoundCode()
	self.NextAlertSoundT = CurTime() + 0.4
	if self.DisableMeleeAttackAnimation == false then
		self.CurrentAttackAnimation = VJ_PICKRANDOMTABLE(self.AnimTbl_MeleeAttack)
		self.CurrentAttackAnimationDuration = VJ_GetSequenceDuration(self,self.CurrentAttackAnimation) -self.MeleeAttackAnimationDecreaseLengthAmount
		self.PlayingAttackAnimation = true
		timer.Simple(VJ_GetSequenceDuration(self,self.CurrentAttackAnimation) -self.MeleeAttackAnimationDecreaseLengthAmount,function()
			if IsValid(self) then
			self.PlayingAttackAnimation = false
			end
		end)
		self:VJ_ACT_PLAYACTIVITY(self.CurrentAttackAnimation,false,0,false,self.MeleeAttackAnimationDelay,false,self.CurrentAttackAnimationDuration)
	end
	timer.Create( "timer_melee_start"..self.Entity:EntIndex(), self.TimeUntilMeleeAttackDamage, 1, function() self:MeleeAttackCode() end)
	self:CustomOnMeleeAttack_AfterStartTimer()
	self.MeleeAttacking = true
	end
   end
  end
else
	self.TimeSinceSeenEnemy = self.TimeSinceSeenEnemy + 0.1
	if self.ResetedEnemy == false && (!self.IsVJBaseSNPC_Tank) then self.ResetedEnemy = true self:ResetEnemy() end
	/*if CurTime() > self.NextFindEnemyT then
	if self.DisableFindEnemy == false then self:FindEnemy() end
	self.NextFindEnemyT = CurTime() + self.NextFindEnemyTime end*/
	//self.MeleeAttacking = false
end
else
	//self:SelectSchedule()
	self.DoingWeaponAttack = false
 end
 self:NextThink(CurTime() +0.1)
 return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:WeaponAimPoseParameters()
	if self.DoingWeaponAttack == false then return end
	//local lol = self:VJ_GetAllParameters(true)
	local ent = self:GetEnemy()
	local x_enemy = 0
	local y_enemy = 0
	if(IsValid(ent)) then
		local self_pos = self:GetPos() + self:OBBCenter()
		local enemy_pos = ent:GetPos() + ent:OBBCenter()
		local self_ang = self:GetAngles()
		local enemy_ang = (enemy_pos - self_pos):Angle()
		x_enemy = math.AngleDifference(enemy_ang.p,self_ang.p)
		y_enemy = math.AngleDifference(enemy_ang.y,self_ang.y)
	end
	self:SetPoseParameter("aim_yaw",math.ApproachAngle(self:GetPoseParameter("aim_yaw"),y_enemy,10))
	self:SetPoseParameter("aim_pitch",math.ApproachAngle(self:GetPoseParameter("aim_pitch"),x_enemy,10))
	self:SetPoseParameter("head_yaw",math.ApproachAngle(self:GetPoseParameter("head_yaw"),y_enemy,10))
	self.DidWeaponAttackAimParameter = true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MeleeAttackCode()
	if self:Health() <= 0 then return end
	if self.vACT_StopAttacks == true then return end
	if self.Flinching == true then return end
	if self.ThrowingGrenade == true then return end
	if self.VJ_IsBeingControlled == false && self.MeleeAttackAnimationFaceEnemy == true then self:FaceCertainEntity(self:GetEnemy(),true) end
	self.MeleeAttacking = true
	local attackthev = ents.FindInSphere(self:GetPos() + self:GetForward(),self.MeleeAttackDamageDistance)
	local hitentity = false
	local HasHitNonPropEnt = false
	if attackthev != nil then
	for _,v in pairs(attackthev) do
		if (v:IsNPC() || (v:IsPlayer() && v:Alive())) && (self:Disposition(v) == 1 or self:Disposition(v) == 2) && (v != self) && (v:GetClass() != self:GetClass()) or (v:GetClass() == "prop_physics") or v:GetClass() == "func_breakable_surf" or v:GetClass() == "func_breakable" then
		if (self:GetForward():Dot((v:GetPos() -self:GetPos()):GetNormalized()) > math.cos(math.rad(self.MeleeAttackDamageAngleRadius))) then
			if GetConVarNumber("vj_npc_dif_normal") == 1 then v:TakeDamage(self.MeleeAttackDamage,self) end -- Normal
			if GetConVarNumber("vj_npc_dif_easy") == 1 then v:TakeDamage(self.MeleeAttackDamage/2,self) end -- Easy
			if GetConVarNumber("vj_npc_dif_hard") == 1 then v:TakeDamage(self.MeleeAttackDamage*1.5,self) end -- Hard
			if GetConVarNumber("vj_npc_dif_hellonearth") == 1 then v:TakeDamage(self.MeleeAttackDamage*2.5,self) end  -- Hell On Earth
		if v:IsPlayer() then
			v:ViewPunch(Angle(math.random(-1,1)*10,math.random(-1,1)*10,math.random(-1,1)*10))
		end
		VJ_DestroyCombineTurret(self,v)
		if v:GetClass() != "prop_physics" then HasHitNonPropEnt = true end
		if v:GetClass() == "prop_physics" && HasHitNonPropEnt == false then
			//if table.HasValue(self.EntitiesToDestoryModel,v:GetModel()) or table.HasValue(self.EntitiesToPushModel,v:GetModel()) then
			//hitentity = true else hitentity = false end
			hitentity = false
		else
			hitentity = true
			end
		end
	  end
	 end
	end
	if hitentity == false then
		self:CustomOnMeleeAttack_Miss()
		self:MeleeAttackMissSoundCode()
	else
		self:MeleeAttackSoundCode()
	end
	timer.Create( "timer_melee_finished" .. self.Entity:EntIndex(), self.NextAnyAttackTime_Melee, 1, function()
		self:StopAttacks()
		self:DoChaseAnimation()
	end)
end	
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ThrowGrenadeCode()
if self.Dead == true then return end
if self:GetEnemy() == nil then return end
if self.Flinching == true or !self:Visible(self:GetEnemy()) /*or self:VJ_ForwardIsHidingZone(self:NearestPoint(self:GetPos() +self:OBBCenter()),self:GetEnemy():EyePos()) == true*/ then return end
	self.ThrowingGrenade = true
	//print(ACT_COMBINE_THROW_GRENADE)
	//self:VJ_ACT_PLAYACTIVITY(ACT_COMBINE_BUGBAIT,true,2,true)
	self:CustomOnGrenadeAttack()
	self:GrenadeAttackSoundCode()
	if self.VJ_PlayingSequence == false && self.DisableGrenadeAttackAnimation == false then 
		self.CurrentAttackAnimation = VJ_PICKRANDOMTABLE(self.AnimTbl_GrenadeAttack)
		self.PlayingAttackAnimation = true
		timer.Simple(VJ_GetSequenceDuration(self,self.CurrentAttackAnimation) -0.2,function()
			if IsValid(self) then
			self.PlayingAttackAnimation = false
			end
		end)
		self:VJ_ACT_PLAYACTIVITY(self.CurrentAttackAnimation,self.GrenadeAttackAnimationStopAttacks,self.GrenadeAttackAnimationStopAttacksTime,false,self.GrenadeAttackAnimationDelay)
	end
	timer.Simple(self.TimeUntilGrenadeIsReleased,function()
	if self:IsValid() then
	if self.Dead == false && self:GetEnemy() != nil then
	local grenent = ents.Create(self.GrenadeAttackEntity)
	local shoot_vector = self:GetEnemy():GetPos() -self:GetAttachment(self:LookupAttachment(self.GrenadeAttackAttachment)).Pos
	grenent:SetOwner(self)
	grenent:SetPos(self:GetAttachment(self:LookupAttachment(self.GrenadeAttackAttachment)).Pos)
	grenent:SetAngles(self:GetAttachment(self:LookupAttachment(self.GrenadeAttackAttachment)).Ang)
	grenent:SetModel(Model(self.GrenadeAttackModel))
	grenent:Spawn()
	grenent:Activate()
	if self.GrenadeAttackEntity == "npc_grenade_frag" then
	grenent:Input("SetTimer",self:GetOwner(),self:GetOwner(),self.GrenadeAttackFussTime) end
	local phys = grenent:GetPhysicsObject()
		if (phys:IsValid()) then
		phys:Wake()
		phys:SetVelocity(shoot_vector +self:GetUp()*math.random(self.GrenadeAttackVelUp1,self.GrenadeAttackVelUp2) +self:GetForward()*math.Rand(self.GrenadeAttackVelForward1,self.GrenadeAttackVelForward2) +self:GetRight()*math.Rand(self.GrenadeAttackVelRight1,self.GrenadeAttackVelRight2))
		//phys:SetVelocity((self:GetEnemy():GetPos() - self:LocalToWorld(Vector(0,0,20))) + self:GetUp()*300 + self:GetForward()*5)
	end
   end
  end
  self.ThrowingGrenade = false
 end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StopAttacks()
	if self:Health() <= 0 then return end
	if self.VJDEBUG_SNPC_ENABLED == true then if GetConVarNumber("vj_npc_printstoppedattacks") == 1 then print(self:GetClass().." Stopped all Attacks!") end end
	self.MeleeAttacking = false
	self:DoChaseAnimation()
end
//ENT.Weapon_ChangeIdleAnimToShoot = false
ENT.NextMoveOnShootT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SelectSchedule()
if self.VJ_IsBeingControlled == true then return end
self:CustomOnSchedule()
if self.DisableSelectSchedule == true then return end
/*if self:GetActiveWeapon():Clip1() == 1 then
	self:GetActiveWeapon():SetClip1(10)
	self:VJ_SetSchedule(SCHED_RELOAD)
end*/
	-- Idle Postion --
	if self:GetEnemy() == nil then
		//if self.PlayerFriendly == true then self:PlayerAllies() end
		//self:HLRelationshops()
		//self:FindEnemy()
		if self.DisableWeapons == false && self:GetActiveWeapon() != NULL && self.ThrowingGrenade == false then
		self:DoIdleAnimation() end
		self.TakingCover = false
		self:IdleSoundCode()
	else
	-- Attack Postion --
	if (self:GetEnemy():GetPos():Distance(self:GetPos()) < self.SightDistance) then
		self:IdleSoundCode()
		local EnemyPos = self:GetEnemy():EyePos()
		local SelfToEnemyDistance = self:EyePos():Distance(EnemyPos)
		if SelfToEnemyDistance < self.DistanceToRunFromEnemy then
			if self.DisableWeapons == false && self:GetActiveWeapon() != NULL && self.DontStartShooting_FollowPlayer == false && self.FollowingPlayer == false && self.ThrowingGrenade == false && self.VJ_PlayingSequence == false then
				local linchallorions = self:VJ_CheckAllFourSides(200)
				if linchallorions.Backward == true then
					self:SetLastPosition(self:GetPos() + self:GetForward()*math.random(-200,-200))
					self.TakingCover = true
					self:VJ_SetSchedule(SCHED_FORCED_GO_RUN)
					timer.Simple(2,function() if IsValid(self) then self.TakingCover = false end end)
				elseif linchallorions.Right == true then
					self:SetLastPosition(self:GetPos() + self:GetRight()*math.random(200,200))
					self.TakingCover = true
					self:VJ_SetSchedule(SCHED_FORCED_GO_RUN)
					timer.Simple(2,function() if IsValid(self) then self.TakingCover = false end end)
				elseif linchallorions.Left == true then
					self:SetLastPosition(self:GetPos() + self:GetRight()*math.random(-200,-200))
					self.TakingCover = true
					self:VJ_SetSchedule(SCHED_FORCED_GO_RUN)
					timer.Simple(2,function() if IsValid(self) then self.TakingCover = false end end)
				end
			end
		end
		/*if SelfToEnemyDistance < 300 && SelfToEnemyDistance > 151 then
		if self.DisableWeapons == false && self:GetActiveWeapon() != NULL && self.DontStartShooting_FollowPlayer == false && self.FollowingPlayer == false && self.ThrowingGrenade == false && self.VJ_PlayingSequence == false then
		self:SetLastPosition(self:GetPos() + self:GetForward()*math.random(-200,-200))
		self:VJ_SetSchedule(SCHED_FORCED_GO) end end*/
   if self.DisableWeapons == false && self:GetActiveWeapon() != NULL && self.MeleeAttacking == false && self.DontStartShooting_FollowPlayer == false && self.ThrowingGrenade == false && self.VJ_PlayingSequence == false && self.vACT_StopAttacks == false && self:VJ_GetNearestPointToEntityDistance(self:GetEnemy()) > self.MeleeAttackDistance then
	if SelfToEnemyDistance > self.ShootDistance then
		self:DoChaseAnimation()
	elseif SelfToEnemyDistance < self.ShootDistance && SelfToEnemyDistance > self.ShootDistanceClose then -- If shoot distance is bigger than the enemy position but if the enemy position is bigger than the shoot distance close
		
		if (self:VJ_ForwardIsHidingZone(self:NearestPoint(self:GetPos() +self:OBBCenter()) +self:GetUp()*30,self:GetEnemy():EyePos() +self:GetUp()*30) == true) or (!self:Visible(self:GetEnemy())) then
		//if self:VJ_IsCurrentSchedule(self.WeaponAttackSchedule) != true then
		if self.DisableChasingEnemy == false then
			self.DoingWeaponAttack = false
			self:DoChaseAnimation()
			end
		else
		
		if self:Visible(self:GetEnemy()) /*&& (self:GetForward():Dot((self:GetEnemy():GetPos() -self:GetPos()):GetNormalized()) > math.cos(math.rad(self.SightAngle)))*/ then
			if (self:GetActiveWeapon().IsVJBaseWeapon) then
					self:FaceCertainEntity(self:GetEnemy(),true)
				if self.DoingWeaponAttack == false && !table.HasValue(self.AnimTbl_WeaponAttack,self:GetActivity()) && !table.HasValue(self.AnimTbl_WeaponAttackCrouch,self:GetActivity()) then
					self.WaitingForEnemyToComeOut = false
					timer.Simple(0.3,function() if IsValid(self) then self.DoingWeaponAttack = true end end)
					//self:StopMoving()
					self:CustomOnWeaponAttack()
					self.Weapon_TimeSinceLastShot = 0
					if self.CanCrouchOnWeaponAttack == true then
					local nigeranim = VJ_PICKRANDOMTABLE(self.AnimTbl_WeaponAttackCrouch)
					local crouchchance = math.random(1,self.CanCrouchOnWeaponAttackChance)
						if crouchchance == 1 && self:SelectWeightedSequence(self:VJ_TranslateWeaponActivity(nigeranim)) != -1 && self:VJ_ForwardIsHidingZone(self:NearestPoint(self:GetPos() +self:OBBCenter()),self:GetEnemy():EyePos()) == false && SelfToEnemyDistance > 500 then
							self:VJ_ACT_PLAYACTIVITY(VJ_PICKRANDOMTABLE(self.AnimTbl_WeaponAttackCrouch),false,0,true)
						else
							self:VJ_ACT_PLAYACTIVITY(VJ_PICKRANDOMTABLE(self.AnimTbl_WeaponAttack),false,0,true)
						end
					else
						self:VJ_ACT_PLAYACTIVITY(VJ_PICKRANDOMTABLE(self.AnimTbl_WeaponAttack),false,0,true)
						end
					end
					
					if CurTime() > self.NextMoveOnShootT then
						if self:VJ_ForwardIsHidingZone(self:NearestPoint(self:GetPos() +self:OBBCenter()),self:GetEnemy():EyePos()) == false then
						//self:SetMovementActivity(ACT_RUN_AIM)
						local randpos = math.random(150,400)
						local killallcpts = self:VJ_CheckAllFourSides(randpos)
						local movepos_back = self:GetPos() + self:GetForward()*-randpos
						local movepos_right = self:GetPos() + self:GetRight()*-randpos
						local movepos_left = self:GetPos() + self:GetRight()*-randpos
						local movepos = movepos_back
						if killallcpts.Backward == true && killallcpts.Right == true && killallcpts.Left == true then
							self:SetLastPosition(VJ_PICKRANDOMTABLE({movepos_back,movepos_right,movepos_left}))
						else
						if killallcpts.Backward == true then
							self:SetLastPosition(movepos_back)
						elseif killallcpts.Right == true then
							self:SetLastPosition(movepos_right)
						elseif killallcpts.Left == true then
							self:SetLastPosition(movepos_left)
						 end
						end
						if killallcpts.Backward == true or killallcpts.Right == true or killallcpts.Left == true then
							self:VJ_SetSchedule(VJ_PICKRANDOMTABLE({SCHED_FORCED_GO_RUN,SCHED_FORCED_GO}))
							//self.Weapon_ChangeIdleAnimToShoot = true
							//self:GetActiveWeapon().ActivityTranslateAI[ACT_IDLE] = ACT_RANGE_ATTACK_SMG1
							timer.Simple(0.2, function() if IsValid(self) then
								timer.Simple(self:GetPathTimeToGoal(), function() if IsValid(self) then
									self:SelectSchedule()
									//self.Weapon_ChangeIdleAnimToShoot = false
									//self:GetActiveWeapon().ActivityTranslateAI[ACT_IDLE] = ACT_IDLE
									end
								end)
							 end
							end)
						end
						//self:VJ_ACT_PLAYACTIVITY(ACT_WALK,false,0,false)
						/*local vsched = ai_vj_schedule.New("vj_act_nigatest")
						vsched:EngTask("TASK_GET_PATH_TO_LASTPOSITION", 0)
						vsched:EngTask("TASK_RUN_PATH", 0)
						vsched:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
						self:StartSchedule(vsched)*/
						self.NextMoveOnShootT = CurTime() + math.Rand(2,5)
						end
					end
				else
					self:FaceCertainEntity(self:GetEnemy(),true)
					self.WaitingForEnemyToComeOut = false
					timer.Simple(0.3,function() if IsValid(self) then self.DoingWeaponAttack = true end end)
					self:CustomOnWeaponAttack()
					self.Weapon_TimeSinceLastShot = 0
					self:VJ_SetSchedule(VJ_PICKRANDOMTABLE(self.WeaponAttackSchedule))
					end
				 end
				 //else self.DoingWeaponAttack = false end
				end
			if !self:Visible(self:GetEnemy()) then // self.WaitForEnemyToComeOutDistance
			if self.Weapon_TimeSinceLastShot <= 5 && self.WaitingForEnemyToComeOut == false && SelfToEnemyDistance < self.ShootDistance && SelfToEnemyDistance > 10 && !table.HasValue(self.AnimTbl_WeaponAttack,self:GetActivity()) && self:VJ_IsCurrentSchedule(self.WeaponAttackSchedule) != true then
			if self.WaitForEnemyToComeOut == true then
				self.DoingWeaponAttack = false
				self.NextChaseTime = CurTime() + math.Rand(self.WaitForEnemyToComeOutTime1,self.WaitForEnemyToComeOutTime2)
				self:CustomOnWaitForEnemyToComeOut()
				self:VJ_ACT_DOCROUCH(self.WaitForEnemyToComeCustomAnimations,{ACT_IDLE_ANGRY},false,2,true)
			end
			self.WaitingForEnemyToComeOut = true
			end
		end
		
		/*if self:VJ_EyeTrace() == true then
		if self.AllowReloading == true then
		if CurTime() > self.NextReloadT then
		if math.random(1,self.ReloadChance) < 3 then
		if self.FollowingPlayer == false then
		self:VJ_SetSchedule(SCHED_HIDE_AND_RELOAD) else
		self:VJ_SetSchedule(SCHED_RELOAD) end end end
		self.NextReloadT = CurTime() + self.NextReloadTime end end*/
		
		/*if self:Health() <= (self.StartHealth*0.25) then
			self.TakingCover = true
			self:VJ_SetSchedule(SCHED_RUN_FROM_ENEMY)
		else
			self.TakingCover = false 
		end*/
		end
	end
   end
	if (self:GetEnemy():GetPos():Distance(self:GetPos()) > self.SightDistance) then
		self:SetEnemy(NULL)
		self:ResetEnemy(false)
	end
 end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_EyeTrace(GetUpNum)
local GetUpNum = GetUpNum or 50
if self:GetEnemy() != nil && self.Dead == false then
local tr = util.TraceLine({
	start = self:NearestPoint(self:GetEnemy():GetPos() +self:GetEnemy():OBBCenter() +self:GetUp()*GetUpNum),
	endpos = self:GetEnemy():GetPos() +self:GetEnemy():OBBCenter(),
	filter = self
})
	//if tr.Entity != NULL then print(tr.Entity) end
	//print(tr.Entity)
	//local nigoer = ents.Create("prop_dynamic")
	//nigoer:SetModel("models/props_wasteland/dockplank01b.mdl")
	//nigoer:SetPos(self:NearestPoint(self:GetEnemy():GetPos() +self:GetEnemy():OBBMaxs() +self:GetUp()*50))
	//nigoer:Spawn()
	//if tr.HitWorld == false && tr.Entity != NULL && tr.Entity:GetClass() != "prop_physics" then 
	//print("true") return true else 
	//print("false") return false end
	//print("false") return false
	if tr.HitWorld == true then return false end
	if tr.Entity != NULL then
	return tr else return false
	end
 end
 return false
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
function ENT:CheckForGrenades()
if self.ThrowingGrenade == true or self.RunFromGrenades == false or self.TakingCover == true or self.VJ_IsBeingControlled == true then return end
local FindNearbyGrenades = ents.FindInSphere(self:GetPos(),self.RunFromGrenadeDistance)
for k,v in pairs(FindNearbyGrenades) do
	local IsFriendlyGrenade = false
	if table.HasValue(self.EntitiesToRunFrom,v:GetClass()) && self:Visible(v) then
	if v:GetOwner() != nil && v:GetOwner() != NULL && v:GetOwner().IsVJBaseSNPC == true && (self:Disposition(v:GetOwner()) == D_LI or self:Disposition(v:GetOwner()) == D_NU) then
		IsFriendlyGrenade = true
	end
	if IsFriendlyGrenade == false then
	self:OnGrenadeSightSoundCode()
	self.HasSeenGrenade = true
	self.TakingCover = true
	if self.VJ_PlayingSequence == false then self:VJ_SetSchedule(SCHED_RUN_FROM_ENEMY) end
	timer.Simple(4,function() if IsValid(self) then self.TakingCover = false self.HasSeenGrenade = false end end)
	//else
	//self.TakingCover = false
	//self.HasSeenGrenade = false
	//return
	end
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
	if self.NextResetEnemyT > CurTime() then return end
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
	self.LastSeenEnemyTime = 0
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
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoEntityRelationshipCheck()
if GetConVarNumber("ai_disabled") == 1 or self.Dead == true then return end
//if CurTime() > self.NextHardEntityCheckT then
	//self.CurrentPossibleEnemies = self:DoHardEntityCheck()
//self.NextHardEntityCheckT = CurTime() + math.random(self.NextHardEntityCheck1,self.NextHardEntityCheck2) end
//print(self:GetName().."'s Enemies:")
//PrintTable(self.CurrentPossibleEnemies)

/*if table.Count(self.CurrentPossibleEnemies) == 0 && CurTime() > self.NextHardEntityCheckT then
	self.CurrentPossibleEnemies = self:DoHardEntityCheck()
self.NextHardEntityCheckT = CurTime() + math.random(50,70) end*/

for k, v in ipairs(self.CurrentPossibleEnemies) do
	if !IsValid(v) then table.remove(self.CurrentPossibleEnemies,k) continue end
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
		if vDistanceToMy < 350 && ((!v:KeyDown(IN_DUCK) && v:GetVelocity():Length() > 0 && v:GetMoveType() != MOVETYPE_NOCLIP && (/*v:KeyDown(IN_FORWARD) or v:KeyDown(IN_BACK) or */v:KeyDown(IN_SPEED) or v:KeyDown(IN_JUMP))) or (self:VJ_DoPlayerFlashLightCheck(v,20) == true)) then self:SetTarget(v) self:VJ_SetSchedule(SCHED_TARGET_FACE) end
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
	if self:GetEnemy() == nil then
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
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FindEnemySphere()
local EnemyTargets = ents.FindInSphere(self:GetPos(),self.SightDistance)
if (!EnemyTargets) then return end
table.Add(EnemyTargets)
for k,v in pairs(EnemyTargets) do
	if self:DoRelationshipCheck(v) == true && self:Visible(v) then
	self.ResetedEnemy = true
	if self:GetEnemy() == nil then
		self:SetEnemy(v)
		self.MyEnemy = v
		self:UpdateEnemyMemory(v,v:GetPos())
	end
	self:DoAlert()
	//return
  end
 end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CallForHelpCode(SeeDistance)
if self.ThrowingGrenade == true then return end
if self.CallForHelp == false then return end
	local getselfclass = ents.FindInSphere(self:GetPos(),SeeDistance)
	local LocalTargetTable = {}
	if (!getselfclass) then return end
	for _,x in pairs(getselfclass) do
	if x:IsNPC() && x != self /*&& x:GetClass() == self:GetClass()*/ && x:Disposition(self) != 1 && x:Disposition(self) != 2 && x.IsVJBaseSNPC_Animal != false && x.FollowingPlayer == false && x.VJ_IsBeingControlled == false && (!x.IsVJBaseSNPC_Tank) && (x:GetClass() == self:GetClass() or x:Disposition(self) != 4) then
	if x.BringFriendsOnDeath == true or x.CallForBackUpOnDamage == true or x.CallForHelp == true then
	//if x:DoRelationshipCheck(self:GetEnemy()) == true then
	table.insert(LocalTargetTable,x)
	if x:GetEnemy() == nil && x:Disposition(self:GetEnemy()) != D_LI /*&& !self:IsCurrentSchedule(SCHED_FORCED_GO_RUN) == true && !self:IsCurrentSchedule(SCHED_FORCED_GO) == true*/ then
	self:CustomOnCallForHelp()
	if self.HasCallForHelpAnimation == true && CurTime() > self.NextCallForHelpAnimationT then
		self:VJ_ACT_PLAYACTIVITY(VJ_PICKRANDOMTABLE(self.AnimTbl_CallForHelp),self.CallForHelpStopAnimations,self.CallForHelpStopAnimationsTime,self.CallForHelpAnimationFaceEnemy,self.CallForHelpAnimationDelay)
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
function ENT:OnTakeDamage(dmginfo,data,hitgroup)
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

if self.MoveOrHideOnDamageByEnemy == true && self:GetEnemy() != nil then
if CurTime() > self.NextMoveOrHideOnDamageByEnemyT && self:EyePos():Distance(self:GetEnemy():EyePos()) < self.ShootDistance && self:GetEnemy() != nil && self.FollowingPlayer == false && self.ThrowingGrenade == false && self.TakingCover == false && !self:IsCurrentSchedule(SCHED_RELOAD) && self:Visible(self:GetEnemy()) && self.VJ_IsBeingControlled == false && self.MeleeAttacking == false && self:IsMoving() == false then
	if self:VJ_ForwardIsHidingZone(self:NearestPoint(self:GetPos() +self:OBBCenter()),self:GetEnemy():EyePos()) == true && self.MoveOrHideOnDamageByEnemy_OnlyMove == false then
		self.TakingCover = true
		self.NextChaseTime = CurTime() + math.Rand(self.MoveOrHideOnDamageByEnemy_HideTime1,self.MoveOrHideOnDamageByEnemy_HideTime2)
		self:VJ_ACT_DOCROUCH(self.MoveOrHideOnDamageByEnemy_CustomActivites,{},false,2,false)
		timer.Simple(self.MoveOrHideOnDamageByEnemy_HideTime1,function() if IsValid(self) then self.TakingCover = false end end)
	else
		local randpos = math.random(150,250)
		local killallcpts = self:VJ_CheckAllFourSides(randpos)
		local movepos_back = self:GetPos() + self:GetForward()*-randpos
		local movepos_right = self:GetPos() + self:GetRight()*-randpos
		local movepos_left = self:GetPos() + self:GetRight()*-randpos
		local movepos = movepos_back
		if killallcpts.Backward == true && killallcpts.Right == true && killallcpts.Left == true then
			self:SetLastPosition(VJ_PICKRANDOMTABLE({movepos_back,movepos_right,movepos_left}))
		else
		if killallcpts.Backward == true then
			self:SetLastPosition(movepos_back)
		elseif killallcpts.Right == true then
			self:SetLastPosition(movepos_right)
		elseif killallcpts.Left == true then
			self:SetLastPosition(movepos_left)
		 end
		end

		if killallcpts.Backward == true or killallcpts.Right == true or killallcpts.Left == true then
			self:VJ_SetSchedule(VJ_PICKRANDOMTABLE(self.MoveOrHideOnDamageByEnemy_MoveSchedules))
			timer.Simple(0.2, function() if IsValid(self) then
				timer.Simple(self:GetPathTimeToGoal() -0.2, function() if IsValid(self) then
					self:SelectSchedule()
				 end
				end)
			 end
			end)
		end
	end
	self.NextMoveOrHideOnDamageByEnemyT = CurTime() + math.random(self.NextMoveOrHideOnDamageByEnemy1,self.NextMoveOrHideOnDamageByEnemy2)
 end
end

if self.CallForBackUpOnDamage == true then
if CurTime() > self.NextBackUpOnDamageT then
if self:GetEnemy() == nil && self.FollowingPlayer == false && self.ThrowingGrenade == false then
if self:CheckAlliesAroundMe(self.CallForBackUpOnDamageDistance).ItFoundAllies == true then
	self:BringAlliesToMe(self.CallForBackUpOnDamageDistance,self.CallForBackUpOnDamageUseCertainAmount,self.CallForBackUpOnDamageUseCertainAmountNumber)
	self:ClearSchedule()
	//self.TakingCover = true
	self.Flinching = true
	if self.DisableCallForBackUpOnDamageAnimation == false then
	timer.Simple(0.1,function()
		if IsValid(self) then self:VJ_ACT_PLAYACTIVITY(self.CallForBackUpOnDamageAnimation,true,self.CallForBackUpOnDamageAnimationTime,true) end end)
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
	self:DamageByPlayerCode(dmginfo)
	self:PainSoundCode()

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
		//self:CallForHelpCode(self.CallForHelpDistance)
		if CurTime() > self.NextRunAwayOnDamageT then
		if self.FollowingPlayer == false && self.VJ_PlayingSequence == false && self.RunAwayOnUnknownDamage == true then
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
	
	if self.AlertFriendsOnDeath == true then
		local checkents = self:CheckAlliesAroundMe(self.AlertFriendsOnDeathDistance)
		local LocalTargetTable = {}
		if checkents.ItFoundAllies == true then
			for k,v in ipairs(checkents.FoundAllies) do
				if v:GetEnemy() == nil && v.AlertFriendsOnDeath == true && self:GetPos():Distance(v:GetPos()) < self.AlertFriendsOnDeathDistance && table.Count(LocalTargetTable) != self.AlertFriendsOnDeathUseCertainAmountNumber then
				table.insert(LocalTargetTable,v)
				v:FaceCertainEntity(self,false)
				v:VJ_ACT_PLAYACTIVITY(VJ_PICKRANDOMTABLE(self.AlertFriendsOnDeathCustomAnimations),false,0,false)
				v.NextIdleTime = CurTime() + math.Rand(5,8)
				end
			end
		end
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
	
	-- Weapon drop
	if dmginfo:GetDamageType() != 67108865 && self.DisableWeapons == false && self:GetActiveWeapon() != NULL && self.DropWeaponOnDeath == true then
		self:DropWeaponOnDeathCode(dmginfo,hitgroup)
	end
	
	-- MISC Stuff --
	if self.HasDeathNotice == true then PrintMessage(self.DeathNoticePosition, self.DeathNoticeWriting) end -- Death Notice on Death
	self:ClearEnemyMemory()
	self:ClearSchedule()
	
	-- Combine Ball check
	if dmginfo:GetDamageType() == 67108865 then self:SetNPCState(NPC_STATE_DEAD) end
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
	
	/*if IsValid(dmginfo:GetAttacker()) && dmginfo:GetAttacker().IsVJBaseSNPC == true && dmginfo:GetAttacker().IsVJBaseSNPC_Human == true then
		local bullseyeisgay = ents.Create("ob_vj_bullseye")
		bullseyeisgay:SetPos(self.Corpse:GetPos()) //self.Corpse:OBBCenter()
		bullseyeisgay:SetParent(self.Corpse)
		bullseyeisgay.VJBULLSEYE_TheAttacker = dmginfo:GetAttacker()
		bullseyeisgay:Spawn()
		bullseyeisgay:Activate()
	//	table.insert(dmginfo:GetAttacker().CurrentPossibleEnemies,bullseyeisgay)
		dmginfo:GetAttacker():SetEnemy(bullseyeisgay)
	end*/
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
function ENT:DropWeaponOnDeathCode(dmginfo,hitgroup)
	self:CustomOnDropWeapon(dmginfo,hitgroup)
	/*if self:GetActiveWeapon():GetClass() == "weapon_smg1" then print("SMG1") end
	if self:GetActiveWeapon("ai_weapon_ar2") then local weaponhas = "weapon_ar2"
	if self:GetActiveWeapon("ai_weapon_shotgun") then local weaponhas = "weapon_shotgun"
	if self:GetActiveWeapon("ai_weapon_pistol") then local weaponhas = "weapon_pistol"
	if self:GetActiveWeapon("ai_weapon_crossbow") then local weaponhas = "weapon_crossbow"
	if self:GetActiveWeapon("ai_weapon_stunstick") then local weaponhas = "weapon_stunstick"
	if self:GetActiveWeapon("ai_weapon_crowbar") then local weaponhas = "weapon_crowbar"
	if self:GetActiveWeapon("weapon_annabelle") then local weaponhas = "weapon_annabelle"
	if self:GetActiveWeapon("ai_weapon_rpg") then local weaponhas = "weapon_rpg"
	if self:GetActiveWeapon("ai_weapon_357") then local weaponhas = "weapon_357"*/
	
	gunang = Angle(0,0,0)
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
	//local gunpos = self:GetAttachment(self:LookupAttachment("gun"))
	local theweapon = ents.Create(self:GetActiveWeapon():GetClass())
	if nohandattach == false then
	theweapon:SetPos(self:GetAttachment(self:LookupAttachment(self.DropWeaponOnDeathAttachment)).Pos) else
	theweapon:SetPos(self:GetActiveWeapon():GetPos()) end
	//Angle(math.random(-50,50),math.random(-50,50),math.random(-50,50))
	if nohandattach == false then
	theweapon:SetAngles(self:GetAttachment(self:LookupAttachment(self.DropWeaponOnDeathAttachment)).Ang +gunang) else
	theweapon:SetAngles(self:GetActiveWeapon():GetAngles() +gunang) end
	theweapon:Spawn()
	theweapon:Activate()
	local phys = theweapon:GetPhysicsObject()
	if IsValid(phys) then
	phys:SetMass(60)
	phys:ApplyForceCenter(dmginfo:GetDamageForce())
	/*if self:GetActiveWeapon():GetClass() == "weapon_pistol" or self:GetActiveWeapon():GetClass() == "weapon_vj_9mmpistol" or self:GetActiveWeapon():GetClass() == "weapon_vj_357" then phys:ApplyForceCenter(dmginfo:GetDamageForce() /30)
	elseif self:GetActiveWeapon():GetClass() == "weapon_vj_glock17" then phys:ApplyForceCenter(dmginfo:GetDamageForce() /20)
	elseif self:GetActiveWeapon():GetClass() == "weapon_vj_ak47" or self:GetActiveWeapon():GetClass() == "weapon_vj_m16a1" then phys:ApplyForceCenter(dmginfo:GetDamageForce() /50)
	elseif self:GetActiveWeapon():GetClass() == "weapon_vj_mp40" then phys:ApplyForceCenter(dmginfo:GetDamageForce() /12) else
	phys:ApplyForceCenter(dmginfo:GetDamageForce() /6)
	end*/
 end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RareDropsOnDeathCode(dmginfo,hitgroup)
	self:CustomRareDropsOnDeathCode(dmginfo,hitgroup)
	if self.ItemDrop_HasDefaultItems == true then
	local randshoulddrop = math.random(1,self.ItemDropChance_DefaultItems)
	if randshoulddrop == 1 then
	local randdrop = math.random(1,2)
	if randdrop == 1 then
	local dropgrenade = ents.Create("weapon_frag")
	dropgrenade:SetPos(self:LocalToWorld(Vector(10,0,40)))
	dropgrenade:SetAngles(Angle(math.random(-50,50),math.random(-50,50),math.random(-50,50)))
	dropgrenade:Spawn()
	dropgrenade:Activate()
	elseif randdrop == 2 then
	local drophealthvial = ents.Create("item_healthvial")
	drophealthvial:SetPos(self:LocalToWorld(Vector(10,0,40)))
	drophealthvial:SetAngles(Angle(0,0,0))
	drophealthvial:Spawn()
	drophealthvial:Activate()
	end
  end
 end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FollowPlayerSoundCode()
if self.HasSounds == false then return end
if self.HasFollowPlayerSounds_Follow == false then return end
	local randomplayersound = math.random(1,self.FollowPlayerSoundChance)
	local soundtbl = self.SoundTbl_FollowPlayer
	if randomplayersound == 1 && VJ_PICKRANDOMTABLE(soundtbl) != false then
		VJ_STOPSOUND(self.CurrentIdleSound)
		VJ_STOPSOUND(self.CurrentFollowPlayerSound)
		VJ_STOPSOUND(self.CurrentUnFollowPlayerSound)
		VJ_STOPSOUND(self.CurrentWeaponReloadSound)
		self.NextIdleSoundT_UnChanged = CurTime() + math.random(3,4)
		self.CurrentFollowPlayerSound = VJ_CreateSound(self,soundtbl,self.FollowPlayerSoundLevel,math.random(self.FollowPlayerPitch1,self.FollowPlayerPitch2))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:UnFollowPlayerSoundCode()
if self.HasSounds == false then return end
if self.HasFollowPlayerSounds_UnFollow == false then return end
	local randomplayersound = math.random(1,self.UnFollowPlayerSoundChance)
	local soundtbl = self.SoundTbl_UnFollowPlayer
	if randomplayersound == 1 && VJ_PICKRANDOMTABLE(soundtbl) != false then
		VJ_STOPSOUND(self.CurrentIdleSound)
		VJ_STOPSOUND(self.CurrentFollowPlayerSound)
		VJ_STOPSOUND(self.CurrentUnFollowPlayerSound)
		VJ_STOPSOUND(self.CurrentWeaponReloadSound)
		self.NextIdleSoundT_UnChanged = CurTime() + math.random(3,4)
		self.CurrentUnFollowPlayerSound = VJ_CreateSound(self,soundtbl,self.UnFollowPlayerSoundLevel,math.random(self.UnFollowPlayerPitch1,self.UnFollowPlayerPitch2))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MedicSoundCode_BeforeHeal()
if self.HasSounds == false then return end
if self.HasMedicSounds_BeforeHeal == false then return end
	local randsd = math.random(1,self.MedicBeforeHealSoundChance)
	local soundtbl = self.SoundTbl_MedicBeforeHeal
	if randsd == 1 && VJ_PICKRANDOMTABLE(soundtbl) != false then
		VJ_STOPSOUND(self.CurrentIdleSound)
		VJ_STOPSOUND(self.CurrentFollowPlayerSound)
		VJ_STOPSOUND(self.CurrentUnFollowPlayerSound)
		self.NextIdleSoundT_UnChanged = CurTime() + math.random(3,4)
		self.CurrentMedicBeforeHealSound = VJ_CreateSound(self,soundtbl,self.BeforeHealSoundLevel,math.random(self.BeforeHealSoundPitch1,self.BeforeHealSoundPitch2))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MedicSoundCode_AfterHeal()
if self.HasSounds == false then return end
if self.HasMedicSounds_AfterHeal == false then return end
	local randsd = math.random(1,self.MedicAfterHealSoundChance)
	local soundtbl = self.SoundTbl_MedicAfterHeal
	if randsd == 1 /*&& VJ_PICKRANDOMTABLE(soundtbl) != false*/ then
		VJ_STOPSOUND(self.CurrentIdleSound)
		VJ_STOPSOUND(self.CurrentFollowPlayerSound)
		VJ_STOPSOUND(self.CurrentUnFollowPlayerSound)
		self.NextIdleSoundT_UnChanged = CurTime() + math.random(3,4)
		if table.Count(self.SoundTbl_MeleeAttack) == 0 then
		self.CurrentMedicAfterHealSound = VJ_CreateSound(self,self.DefaultSoundTbl_MedicAfterHeal,self.AfterHealSoundLevel,math.random(self.AfterHealSoundPitch1,self.AfterHealSoundPitch2)) else
		self.CurrentMedicAfterHealSound = VJ_CreateSound(self,soundtbl,self.AfterHealSoundLevel,math.random(self.AfterHealSoundPitch1,self.AfterHealSoundPitch2)) end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPlayerSightSoundCode()
if self.HasSounds == false then return end
if self.HasOnPlayerSightSounds == false then return end
	local randomplayersound = math.random(1,self.OnPlayerSightSoundChance)
	local soundtbl = self.SoundTbl_OnPlayerSight
	if randomplayersound == 1 && VJ_PICKRANDOMTABLE(soundtbl) != false then
		VJ_STOPSOUND(self.CurrentIdleSound)
		VJ_STOPSOUND(self.CurrentOnPlayerSightSound)
		VJ_STOPSOUND(self.CurrentWeaponReloadSound)
		self.NextIdleSoundT_UnChanged = CurTime() + math.random(3,4)
		self.CurrentOnPlayerSightSound = VJ_CreateSound(self,soundtbl,self.OnPlayerSightSoundLevel,math.random(self.OnPlayerSightSoundPitch1,self.OnPlayerSightSoundPitch2))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GrenadeAttackSoundCode()
if self.HasSounds == false then return end
if self.HasGrenadeAttackSounds == false then return end
	local randomgrnadesound = math.random(1,self.GrenadeAttackSoundChance)
	local soundtbl = self.SoundTbl_GrenadeAttack
	if randomgrnadesound == 1 && VJ_PICKRANDOMTABLE(soundtbl) != false then
		VJ_STOPSOUND(self.CurrentIdleSound)
		self.NextIdleSoundT_UnChanged = CurTime() + math.random(3,4)
		self.CurrentGrenadeAttackSound = VJ_CreateSound(self,soundtbl,self.GrenadeAttackSoundLevel,math.random(self.GrenadeAttackSoundPitch1,self.GrenadeAttackSoundPitch2))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnGrenadeSightSoundCode()
if self.HasSounds == false then return end
if self.HasOnGrenadeSightSounds == false then return end
	if CurTime() > self.NextOnGrenadeSightSoundT then
	local randomgrnadesound = math.random(1,self.OnGrenadeSightSoundChance)
	local soundtbl = self.SoundTbl_OnGrenadeSight
	if randomgrnadesound == 1 && VJ_PICKRANDOMTABLE(soundtbl) != false then
		VJ_STOPSOUND(self.CurrentIdleSound)
		VJ_STOPSOUND(self.CurrentWeaponReloadSound)
		self.NextIdleSoundT_UnChanged = CurTime() + math.random(3,4)
		self.CurrentOnGrenadeSightSound = VJ_CreateSound(self,soundtbl,self.OnGrenadeSightSoundLevel,math.random(self.OnGrenadeSightSoundPitch1,self.OnGrenadeSightSoundPitch2))
		end
	self.NextOnGrenadeSightSoundT = CurTime() + math.Rand(self.NextSoundTime_OnGrenadeSight1,self.NextSoundTime_OnGrenadeSight2)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:WeaponReloadSoundCode()
if self.HasSounds == false then return end
if self.HasWeaponReloadSounds == false then return end
	if CurTime() > self.NextWeaponReloadSoundT then
	local randsound = math.random(1,self.WeaponReloadSoundChance)
	local soundtbl = self.SoundTbl_WeaponReload
	if randsound == 1 && VJ_PICKRANDOMTABLE(soundtbl) != false then
		VJ_STOPSOUND(self.CurrentIdleSound)
		self.NextIdleSoundT_UnChanged = CurTime() + math.random(3,4)
		self.CurrentWeaponReloadSound = VJ_CreateSound(self,soundtbl,self.WeaponReloadSoundLevel,math.random(self.WeaponReloadSoundPitch1,self.WeaponReloadSoundPitch2))
		end
	self.NextWeaponReloadSoundT = CurTime() + math.Rand(self.NextSoundTime_WeaponReload1,self.NextSoundTime_WeaponReload2)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IdleSoundCode()
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
	if randomidlesound == 1 && VJ_PICKRANDOMTABLE(soundtbl) != false /*&& self:VJ_IsPlayingSoundFromTable(self.SoundTbl_Idle) == false*/ then
		self.CurrentIdleSound = VJ_CreateSound(self,soundtbl,self.IdleSoundLevel,math.random(self.IdleSoundPitch1,self.IdleSoundPitch2))
		end
	end
	
	if PlayCombatIdleSds == true then
	local randomenemytalksound = math.random(1,self.CombatIdleSoundChance)
	local soundtbl = self.SoundTbl_CombatIdle
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
function ENT:AlertSoundCode()
if self.HasSounds == false then return end
if self.HasAlertSounds == false then return end
	local randomalertsound = math.random(1,self.AlertSoundChance)
	local soundtbl = self.SoundTbl_Alert
	if randomalertsound == 1 && VJ_PICKRANDOMTABLE(soundtbl) != false then
		VJ_STOPSOUND(self.CurrentIdleSound)
		self.NextIdleSoundT = self.NextIdleSoundT + 2
		self.CurrentAlertSound = VJ_CreateSound(self,soundtbl,self.AlertSoundLevel,math.random(self.AlertSoundPitch1,self.AlertSoundPitch2))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DamageByPlayerSoundCode()
if self.HasSounds == false then return end
if self.HasDamageByPlayerSounds == false then return end
if CurTime() > self.NextDamageByPlayerSoundT then
	local randomplayersound = math.random(1,self.DamageByPlayerSoundChance)
	local soundtbl = self.SoundTbl_DamageByPlayer
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
function ENT:BeforeMeleeAttackSoundCode()
if self.HasSounds == false then return end
if self.HasMeleeAttackSounds == false then return end
	local randomattacksound = math.random(1,self.BeforeMeleeAttackSoundChance)
	local soundtbl = self.SoundTbl_BeforeMeleeAttack
	if randomattacksound == 1 && VJ_PICKRANDOMTABLE(soundtbl) != false then
		VJ_STOPSOUND(self.CurrentIdleSound)
		self.NextIdleSoundT_UnChanged = CurTime() + 1
		self.CurrentBeforeMeleeAttackSound = VJ_CreateSound(self,soundtbl,self.BeforeMeleeAttackSoundLevel,math.random(self.BeforeMeleeAttackSoundPitch1,self.BeforeMeleeAttackSoundPitch2))
   end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MeleeAttackSoundCode()
if self.HasSounds == false then return end
if self.HasMeleeAttackSounds == false then return end
	local randomattacksound = math.random(1,self.MeleeAttackSoundChance)
	local soundtbl = self.SoundTbl_MeleeAttack
	if randomattacksound == 1 /*&& VJ_PICKRANDOMTABLE(soundtbl) != false*/ then
		VJ_STOPSOUND(self.CurrentIdleSound)
		self.NextIdleSoundT_UnChanged = CurTime() + 1
		if table.Count(self.SoundTbl_MeleeAttack) == 0 then
		self.CurrentMeleeAttackSound = VJ_CreateSound(self,self.DefaultSoundTbl_MeleeAttack,self.MeleeAttackSoundLevel,math.random(self.MeleeAttackSoundPitch1,self.MeleeAttackSoundPitch2)) else
		self.CurrentMeleeAttackSound = VJ_CreateSound(self,soundtbl,self.MeleeAttackSoundLevel,math.random(self.MeleeAttackSoundPitch1,self.MeleeAttackSoundPitch2)) end
   end
	if self.HasExtraMeleeAttackSounds == true then
	//self:EmitSound( "npc/zombie/claw_strike"..math.random(1,3)..".wav", 70, 100)
	local randextraattacks = math.random(1,self.ExtraMeleeSoundChance)
	local soundtbl = self.SoundTbl_MeleeAttackExtra
	if randextraattacks == 1 && VJ_PICKRANDOMTABLE(soundtbl) != false then
		VJ_STOPSOUND(self.CurrentIdleSound)
		//self.CurrentExtraMeleeAttackSound = VJ_CreateSound(self,soundtbl,self.ExtraMeleeAttackSoundLevel,math.random(self.ExtraMeleeSoundPitch1,self.ExtraMeleeSoundPitch2))
		VJ_EmitSound(self,soundtbl,self.ExtraMeleeAttackSoundLevel,math.random(self.ExtraMeleeSoundPitch1,self.ExtraMeleeSoundPitch2))
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MeleeAttackMissSoundCode()
if self.HasSounds == false then return end
if self.HasMeleeAttackMissSounds == false then return end
local randommisssound = math.random(1,self.MeleeAttackMissSoundChance)
	local soundtbl = self.SoundTbl_MeleeAttackMiss
	if randommisssound == 1 /*&& VJ_PICKRANDOMTABLE(soundtbl) != false*/ then
		VJ_STOPSOUND(self.CurrentIdleSound)
		self.NextIdleSoundT_UnChanged = CurTime() + 1
		if table.Count(self.SoundTbl_MeleeAttackMiss) == 0 then
		self.CurrentMeleeAttackMissSound = VJ_CreateSound(self,self.DefaultSoundTbl_MeleeAttackMiss,self.MeleeAttackMissSoundLevel,math.random(self.MeleeAttackMissSoundPitch1,self.MeleeAttackMissSoundPitch2)) else
		self.CurrentMeleeAttackMissSound = VJ_CreateSound(self,soundtbl,self.MeleeAttackMissSoundLevel,math.random(self.MeleeAttackMissSoundPitch1,self.MeleeAttackMissSoundPitch2)) end
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BecomeEnemyToPlayerSoundCode()
if self.HasSounds == false then return end
if self.HasBecomeEnemyToPlayerSounds == false then return end
local randomenemyplysound = math.random(1,self.BecomeEnemyToPlayerChance)
	local soundtbl = self.SoundTbl_BecomeEnemyToPlayer
	if randomenemyplysound == 1 && VJ_PICKRANDOMTABLE(soundtbl) != false then
		self.NextAlertSoundT = CurTime() + 1
		timer.Simple(1.3,function() if IsValid(self) then VJ_STOPSOUND(self.CurrentAlertSound) end end)
		self.NextIdleSoundT_UnChanged = CurTime() + math.random(2,3)
		VJ_STOPSOUND(self.CurrentIdleSound)
		VJ_STOPSOUND(self.CurrentAlertSound)
		VJ_STOPSOUND(self.CurrentFollowPlayerSound)
		VJ_STOPSOUND(self.CurrentUnFollowPlayerSound)
		VJ_STOPSOUND(self.CurrentOnPlayerSightSound)
		VJ_STOPSOUND(self.CurrentDamageByPlayerSound)
		VJ_STOPSOUND(self.CurrentWeaponReloadSound)
		timer.Simple(0.05,function() if IsValid(self) then VJ_STOPSOUND(self.CurrentPainSound) end end)
		self.CurrentBecomeEnemyToPlayerSound = VJ_CreateSound(self,soundtbl,self.BecomeEnemyToPlayerSoundLevel,math.random(self.BecomeEnemyToPlayerPitch1,self.BecomeEnemyToPlayerPitch2))
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PainSoundCode()
if self.HasSounds == false then return end
if self.HasPainSounds == false then return end
if CurTime() > self.PainSoundT then
local randompainsound = math.random(1,self.PainSoundChance)
	local soundtbl = self.SoundTbl_Pain
	if randompainsound == 1 && VJ_PICKRANDOMTABLE(soundtbl) != false then
		VJ_STOPSOUND(self.CurrentIdleSound)
		self.NextIdleSoundT_UnChanged = CurTime() + 1
		self.CurrentPainSound = VJ_CreateSound(self,soundtbl,self.PainSoundLevel,math.random(self.PainSoundPitch1,self.PainSoundPitch2))
		end
	self.PainSoundT = CurTime() + math.Rand(self.NextSoundTime_Pain1,self.NextSoundTime_Pain2)
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeathSoundCode()
if self.HasSounds == false then return end
if self.HasDeathSounds == false then return end
local deathsound = math.random(1,self.DeathSoundChance)
	local soundtbl = self.SoundTbl_Death
	if deathsound == 1 && VJ_PICKRANDOMTABLE(soundtbl) != false then
		self.CurrentDeathSound = VJ_CreateSound(self,soundtbl,self.DeathSoundLevel,math.random(self.DeathSoundPitch1,self.DeathSoundPitch2))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FootStepSoundCode()
if self.HasSounds == false then return end
if self.HasFootStepSound == false then return end
	if self:IsOnGround() && self:GetGroundEntity() != NULL && self:IsMoving() && CurTime() > self.FootStepT then
	self:CustomOnFootStepSound()
	//VJ_EmitSound(self,self.SoundTbl_FootStep,self.FootStepSoundLevel,math.random(self.FootStepPitch1,self.FootStepPitch2))
	if self.DisableFootStepOnRun == false && table.HasValue(VJ_RunActivites,self:GetMovementActivity()) then
	self:CustomOnFootStepSound_Run()
	VJ_EmitSound(self,self.SoundTbl_FootStep,self.FootStepSoundLevel,math.random(self.FootStepPitch1,self.FootStepPitch2))
	self.FootStepT = CurTime() + self.FootStepTimeRun
	elseif self.DisableFootStepOnWalk == false && table.HasValue(VJ_WalkActivites,self:GetMovementActivity()) then
	self:CustomOnFootStepSound_Walk()
	VJ_EmitSound(self,self.SoundTbl_FootStep,self.FootStepSoundLevel,math.random(self.FootStepPitch1,self.FootStepPitch2))
	self.FootStepT = CurTime() + self.FootStepTimeWalk
	end
 end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ImpactSoundCode()
if self.HasSounds == false then return end
if self.HasImpactSounds == false then return end
local randomimpactsound = math.random(1,self.ImpactSoundChance)
	if randomimpactsound == 1 then
	if table.Count(self.SoundTbl_Impact) == 0 then
	VJ_EmitSound(self,self.DefaultSoundTbl_Impact,self.ImpactSoundLevel,math.random(self.ImpactSoundPitch1,self.ImpactSoundPitch2)) else
	VJ_EmitSound(self,self.SoundTbl_Impact,self.ImpactSoundLevel,math.random(self.ImpactSoundPitch1,self.ImpactSoundPitch2))
	end
 end
end
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
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartSoundTrack()
	if self.HasSounds == false then return end
	if self.HasSoundTrack == false then return end
	self.VJ_IsPlayingSoundTrack = true
	self:SetNetworkedBool("VJ_IsPlayingSoundTrack",true)
	net.Start("vj_human_onthememusic")
	net.WriteEntity(self)
	net.WriteTable(self.SoundTbl_SoundTrack)
	net.WriteFloat(self.SoundTrackLevel)
	net.WriteFloat(self.SoundTrackFadeOutTime)
	net.Broadcast("vj_human_onthememusic")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StopAllCommonSounds()
	VJ_STOPSOUND(self.CurrentBreathSound)
	VJ_STOPSOUND(self.CurrentIdleSound)
	VJ_STOPSOUND(self.CurrentAlertSound)
	VJ_STOPSOUND(self.CurrentBeforeMeleeAttackSound)
	//VJ_STOPSOUND(self.CurrentMeleeAttackSound)
	//VJ_STOPSOUND(self.CurrentExtraMeleeAttackSound)
	//VJ_STOPSOUND(self.CurrentMeleeAttackMissSound)
	VJ_STOPSOUND(self.CurrentPainSound)
	VJ_STOPSOUND(self.CurrentFollowPlayerSound)
	VJ_STOPSOUND(self.CurrentUnFollowPlayerSound)
	VJ_STOPSOUND(self.CurrentBecomeEnemyToPlayerSound)
	VJ_STOPSOUND(self.CurrentOnPlayerSightSound)
	VJ_STOPSOUND(self.CurrentDamageByPlayerSound)
	VJ_STOPSOUND(self.CurrentGrenadeAttackSound)
	VJ_STOPSOUND(self.CurrentOnGrenadeSightSound)
	VJ_STOPSOUND(self.CurrentWeaponReloadSound)
	VJ_STOPSOUND(self.CurrentMedicBeforeHealSound)
	VJ_STOPSOUND(self.CurrentMedicAfterHealSound)
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
	if GetConVarNumber("vj_npc_nowandering") == 1 then self.DisableWandering = true end
	if GetConVarNumber("vj_npc_nochasingenemy") == 1 then self.DisableChasingEnemy = true end
	if GetConVarNumber("vj_npc_noflinching") == 1 then self.Flinches = false end
	if GetConVarNumber("vj_npc_nomelee") == 1 then self.HasMeleeAttack = false end
	if GetConVarNumber("vj_npc_nobleed") == 1 then self.Bleeds = false end
	if GetConVarNumber("vj_npc_godmodesnpc") == 1 then self.GodMode = true end
	if GetConVarNumber("vj_npc_noreload") == 1 then self.AllowReloading = false end
	if GetConVarNumber("vj_npc_nobecomeenemytoply") == 1 then self.BecomeEnemyToPlayer = false end
	if GetConVarNumber("vj_npc_nofollowplayer") == 1 then self.FollowPlayer = false end
	if GetConVarNumber("vj_npc_nosnpcchat") == 1 then self.FollowPlayerChat = false end
	if GetConVarNumber("vj_npc_noweapon") == 1 then self.DisableWeapons = true end
	if GetConVarNumber("vj_npc_noforeverammo") == 1 then self.HasUnlimitedClip = false end
	if GetConVarNumber("vj_npc_nothrowgrenade") == 1 then self.HasGrenadeAttack = false end
	if GetConVarNumber("vj_npc_nouseregulator") == 1 then self.DisableUSE_SHOT_REGULATOR = true end
	if GetConVarNumber("vj_npc_noscarednade") == 1 then self.RunFromGrenades = false end
	if GetConVarNumber("vj_npc_dropweapon") == 0 then self.DropWeaponOnDeath = false end
	if GetConVarNumber("vj_npc_nomedics") == 1 then self.IsMedicSNPC = false end
	if GetConVarNumber("vj_npc_sd_soundtrack") == 1 then self.HasSoundTrack = false end
	if GetConVarNumber("vj_npc_sd_footstep") == 1 then self.HasFootStepSound = false end
	if GetConVarNumber("vj_npc_sd_idle") == 1 then self.HasIdleSounds = false end
	if GetConVarNumber("vj_npc_sd_breath") == 1 then self.HasBreathSound = false end
	if GetConVarNumber("vj_npc_sd_alert") == 1 then self.HasAlertSounds = false end
	if GetConVarNumber("vj_npc_sd_ongrenadesight") == 1 then self.HasOnGrenadeSightSounds = false end
	//if GetConVarNumber("vj_npc_sd_combatidle") == 1 then self.HasCombatIdleSounds = false end
	if GetConVarNumber("vj_npc_sd_meleeattack") == 1 then self.HasMeleeAttackSounds = false self.HasExtraMeleeAttackSounds = false end
	if GetConVarNumber("vj_npc_sd_meleeattackmiss") == 1 then self.HasMeleeAttackMissSounds = false end
	if GetConVarNumber("vj_npc_sd_pain") == 1 then self.HasPainSounds = false end
	if GetConVarNumber("vj_npc_sd_death") == 1 then self.HasDeathSounds = false end
	if GetConVarNumber("vj_npc_sd_followplayer") == 1 then self.HasFollowPlayerSounds_Follow = false self.HasFollowPlayerSounds_UnFollow = false end
	if GetConVarNumber("vj_npc_sd_becomenemytoply") == 1 then self.HasBecomeEnemyToPlayerSounds = false end
	if GetConVarNumber("vj_npc_sd_damagebyplayer") == 1 then self.HasDamageByPlayerSounds = false end
	if GetConVarNumber("vj_npc_sd_onplayersight") == 1 then self.HasOnPlayerSightSounds = false end
	if GetConVarNumber("vj_npc_sd_medic") == 1 then self.HasMedicSounds_BeforeHeal = false self.HasMedicSounds_AfterHeal = false end
	if GetConVarNumber("vj_npc_sd_reload") == 1 then self.HasWeaponReloadSounds = false end
	if GetConVarNumber("vj_npc_sd_grenadeattack") == 1 then self.HasGrenadeAttackSounds = false end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ConvarsOnThink() -- Obsolete, only used for print! | Causes lag!
	if self.VJDEBUG_SNPC_ENABLED == false then return end
	if self.DisableWeapons == false && self:GetActiveWeapon() != NULL then
	-- When the SNPC has a weapon then...
	if GetConVarNumber("vj_npc_printaccuracy") == 1 then print(self:GetClass().."'s accuracy = "..self.WeaponSpread.." | "..self:GetCurrentWeaponProficiency()) end
	if GetConVarNumber("vj_npc_printammo") == 1 then print(self:GetClass().."'s Ammo = VJ Ammo: "..self.Weapon_ShotsSinceLastReload.."/"..self.Weapon_StartingAmmoAmount.." | GMod Ammo: "..self:GetActiveWeapon():Clip1()) end
	if GetConVarNumber("vj_npc_printweapon") == 1 then print(self:GetClass().."'s",self:GetActiveWeapon()) end
	end
end
/*--------------------------------------------------
	=============== Human SNPC Base ===============
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to make human SNPCs
--------------------------------------------------*/