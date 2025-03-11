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
------ Main & Misc ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.Model = false -- Model(s) to spawn with | Picks a random one if it's a table
ENT.CanChatMessage = true -- Is it allowed to post in a player's chat? | Example: "Blank no longer likes you."
	-- ====== Health ====== --
ENT.StartHealth = 50
ENT.HealthRegenParams = {
	Enabled = false, -- Can it regenerate its health?
	Amount = 4, -- How much should the health increase after every delay?
	Delay = VJ.SET(2, 4), -- How much time until the health increases
	ResetOnDmg = true, -- Should the delay reset when it receives damage?
}
	-- ====== Collision ====== --
ENT.HullType = HULL_HUMAN -- List of Hull types: https://wiki.facepunch.com/gmod/Enums/HULL
ENT.EntitiesToNoCollide = false -- Set to a table of entity class names for it to not collide with otherwise leave it to false
	-- ====== NPC Controller ====== --
ENT.ControllerParams = {
	CameraMode = 1, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
	ThirdP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in third person
	FirstP_Bone = "ValveBiped.Bip01_Head1", -- If left empty, the base will attempt to calculate a position for first person
	FirstP_Offset = Vector(0, 0, 5), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = true, -- Should the bone shrink? Useful if the bone is obscuring the player's view
	FirstP_CameraBoneAng = 0, -- Should the camera's angle be affected by the bone's angle? | 0 = No, 1 = Pitch, 2 = Yaw, 3 = Roll
	FirstP_CameraBoneAng_Offset = 0, -- How much should the camera's angle be rotated by? | Useful for weird bone angles
}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Movement ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.SightDistance = 6500 -- Initial sight distance | To retrieve: "self:GetMaxLookDistance()" | To change: "self:SetMaxLookDistance(distance)"
ENT.SightAngle = 177 -- Initial field of view | To retrieve: "self:GetFOV()" | To change: "self:SetFOV(degree)" | 360 = See all around
ENT.TurningSpeed = 20 -- How fast it can turn
ENT.TurningUseAllAxis = false -- If set to true, angles will not be restricted to y-axis, it will change all axes (plural axis)
ENT.CanTurnWhileMoving = true -- Can it turn while moving? | EX: GoldSrc NPCs, Facing enemy while running to cover, Facing the player while moving out of the way
ENT.MovementType = VJ_MOVETYPE_GROUND -- Types: VJ_MOVETYPE_GROUND | VJ_MOVETYPE_AERIAL | VJ_MOVETYPE_AQUATIC | VJ_MOVETYPE_STATIONARY | VJ_MOVETYPE_PHYSICS
ENT.UsePoseParameterMovement = false -- Sets the model's "move_x" and "move_y" pose parameters while moving | Required for player models to move properly!
	-- ====== JUMPING ====== --
	-- Requires "CAP_MOVE_JUMP" capability
	-- Applied automatically by the base if "ACT_JUMP" is valid on the NPC's model
	-- Example scenario:
	--      [A]       <- Apex
	--     /   \
	--    /     [S]   <- Start
	--  [E]           <- End
ENT.JumpParams = {
	Enabled = true, -- Can it do movement jumps?
	MaxRise = 80, -- How high it can jump up ((S -> A) AND (S -> E))
	MaxDrop = 230, -- How low it can jump down (E -> S)
	MaxDistance = 275, -- Maximum distance between Start and End
}
	-- ====== STATIONARY ====== --
ENT.CanTurnWhileStationary = true -- Can it turn while using stationary move type?
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ AI & Relationship ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.Behavior = VJ_BEHAVIOR_AGGRESSIVE -- What type of AI behavior is it?
ENT.IsGuard = false -- Should it guard its position? | Will attempt to stay around its guarding position
ENT.NextProcessTime = 1 -- Time until it runs the essential performance-heavy AI components
ENT.EnemyDetection = true -- Can it search and detect for enemies?
ENT.EnemyTouchDetection = true -- Can it turn and detect enemies that collide with it?
ENT.EnemyXRayDetection = false -- Can it detect enemies through walls & objects?
ENT.EnemyTimeout = 15 -- Time until the enemy target is reset if it's not visible
ENT.AlertTimeout = VJ.SET(14, 16) -- Time until it transitions from alerted state to idle state assuming it has no enemy
ENT.IdleAlwaysWander = false -- Should it constantly wander while idle?
ENT.DisableWandering = false
ENT.DisableChasingEnemy = false
ENT.CanOpenDoors = true -- Can it open doors?
	-- ====== Alliances ====== --
ENT.CanAlly = true -- Can it ally with other entities?
ENT.VJ_NPC_Class = {} -- Relationship classes, any entity with the same class will be seen as an ally
	-- Common Classes:
		-- Players / Resistance / Black Mesa = "CLASS_PLAYER_ALLY" || HECU = "CLASS_UNITED_STATES" || Portal = "CLASS_APERTURE"
		-- Combine = "CLASS_COMBINE" || Zombie = "CLASS_ZOMBIE" || Antlions = "CLASS_ANTLION" || Xen = "CLASS_XEN" || Black-Ops = "CLASS_BLACKOPS"
ENT.AlliedWithPlayerAllies = false -- Should it be allied with other player allies? | Both entities must have "CLASS_PLAYER_ALLY"
ENT.YieldToAlliedPlayers = true -- Should it give space to allied players?
ENT.BecomeEnemyToPlayer = false -- Should it become enemy towards an allied player if it's damaged by them or it witnesses another ally killed by them?
	-- false = Don't turn hostile to allied players | number = Threshold, where each negative event increases it by 1, if it passes this number it will become hostile
ENT.CanReceiveOrders = true -- Can it receive orders from allies? | Ex: Allies calling for help, allies requesting backup on damage, etc.
	-- false = Will not receive the following: "CallForHelp", "DamageAllyResponse", "DeathAllyResponse", "Passive_AlliesRunOnDamage"
	-- ====== Passive Behaviors ====== --
ENT.Passive_RunOnTouch = true -- Should it run and make a alert sound when something collides with it?
ENT.Passive_AlliesRunOnDamage = true -- Should its allies (other passive NPCs) also run when it's damaged?
	-- ====== On Player Sight ====== --
ENT.HasOnPlayerSight = false -- Should do something when it a player?
ENT.OnPlayerSightDistance = 200 -- How close should the player be until it runs the code?
ENT.OnPlayerSightDispositionLevel = 1 -- 0 = Run it every time | 1 = Run it only when friendly to player | 2 = Run it only when enemy to player
ENT.OnPlayerSightOnlyOnce = true -- If true, it will only run it once | Sets "self.HasOnPlayerSight" to false after it runs!
ENT.OnPlayerSightNextTime = VJ.SET(15, 20) -- How much time should it pass until it runs the code again?
	-- ====== Call For Help ====== --
ENT.CallForHelp = true -- Can it request allies for help while in combat?
ENT.CallForHelpDistance = 2000 -- Max distance its request for help travels
ENT.CallForHelpCooldown = 4 -- Time until it calls for help again
ENT.AnimTbl_CallForHelp = {ACT_SIGNAL_ADVANCE, ACT_SIGNAL_FORWARD} -- Call for help animations | false = Don't play an animation
ENT.CallForHelpAnimFaceEnemy = true -- Should it face the enemy while playing the animation?
ENT.CallForHelpAnimCooldown = 30 -- How much time until it can play an animation again?
	-- ====== Medic ====== --
	-- Medics only heal allied entities that are tagged with "self.VJ_ID_Healable", by default it includes VJ NPCs and players
ENT.IsMedic = false -- Should it heal allied entities?
ENT.Medic_CheckDistance = 600 -- Max distance to check for injured allies
ENT.Medic_HealDistance = 30 -- How close does it have to be until it stops moving and heals its ally?
ENT.Medic_TimeUntilHeal = false -- Time until the ally receives health | false = Base auto calculates the duration
ENT.AnimTbl_Medic_GiveHealth = ACT_SPECIAL_ATTACK1 -- Animations to play when it heals an ally | false = Don't play an animation
ENT.Medic_HealAmount = 25 -- How health does it give?
ENT.Medic_NextHealTime = VJ.SET(10, 15) -- How much time until it can give health to an ally again
ENT.Medic_SpawnPropOnHeal = true -- Should it spawn a prop, such as small health vial at a attachment when healing an ally?
ENT.Medic_SpawnPropOnHealModel = "models/healthvial.mdl" -- The model that it spawns
ENT.Medic_SpawnPropOnHealAttachment = "anim_attachment_LH" -- The attachment it spawns on
	-- ====== Follow System ====== --
	-- Associated variables: self.FollowData, self.IsFollowing
	-- NOTE: Stationary NPCs can't use follow system!
ENT.FollowPlayer = true -- Should it follow allied players when the player presses the USE key?
ENT.FollowMinDistance = 100 -- Minimum distance it should come when following something | The base automatically adds the NPC's size to this variable to account for different sizes!
	-- ====== Constantly Face Enemy ====== --
ENT.ConstantlyFaceEnemy = false -- Should it face the enemy constantly?
ENT.ConstantlyFaceEnemy_IfVisible = true -- Should it only face the enemy if it's visible?
ENT.ConstantlyFaceEnemy_IfAttacking = false -- Should it face the enemy when attacking?
ENT.ConstantlyFaceEnemy_Postures = "Both" -- "Both" = Moving or standing | "Moving" = Only when moving | "Standing" = Only when standing
ENT.ConstantlyFaceEnemy_MinDistance = 2500 -- How close does it have to be until it starts to face the enemy?
	-- ====== Pose Parameter Tracking ====== --
ENT.HasPoseParameterLooking = true -- Does it look at its enemy using pose parameters?
ENT.PoseParameterLooking_Names = {pitch = {}, yaw = {}, roll = {}} -- Custom pose parameters to use, can put as many as needed
ENT.PoseParameterLooking_InvertPitch = false -- Inverts the pitch pose parameters (X)
ENT.PoseParameterLooking_InvertYaw = false -- Inverts the yaw pose parameters (Y)
ENT.PoseParameterLooking_InvertRoll = false -- Inverts the roll pose parameters (Z)
ENT.PoseParameterLooking_TurningSpeed = 10 -- How fast does the parameter turn?
ENT.PoseParameterLooking_CanReset = true -- Should it reset its pose parameters if there is no enemies?
	-- ====== Investigation ====== --
	-- Showcase: https://www.youtube.com/watch?v=cCqoqSDFyC4
ENT.CanInvestigate = true -- Can it detect and investigate disturbances? | EX: Sounds, movement, flashlight, bullet hits
ENT.InvestigateSoundMultiplier = 9 -- Max sound hearing distance multiplier | This multiplies the calculated volume of the sound
	-- ====== Danger & Grenade Detection ====== --
	-- Showcase: https://www.youtube.com/watch?v=XuaMWPTe6rA
	-- EXAMPLES: Props that are one fire, especially objects like barrels that are about to explode, Combine mine that is triggered and about to explode, The location that the Antlion Worker's spit is going to hit, Combine Flechette that is about to explode,
	-- Antlion Guard that is charging towards the NPC, Player that is driving a vehicle at high speed towards the NPC, Manhack that has opened its blades, Rollermine that is about to self-destruct, Combine Helicopter that is about to drop bombs or is firing a turret near the NPC,
	-- Combine Gunship's is about to fire its belly cannon near the NPC, Turret impact locations fired by Combine Gunships, or Combine Dropships, or Striders, The location that a Combine Dropship is going to deploy soldiers, Strider is moving on top of the NPC,
	-- The location that the Combine or HECU mortar is going to hit, SMG1 grenades that are flying close by, A Combine soldier that is rappelling on top of the NPC, Stalker's laser impact location, Combine APC that is driving towards the NPC
ENT.CanDetectDangers = true -- Can it detect dangers? | Ex: Grenades, fire, bombs, explosives, etc.
ENT.DangerDetectionDistance = 400 -- Max danger detection distance | WARNING: Most of the non-grenade dangers ignore this max value
ENT.CanRedirectGrenades = true -- Can it pick up detected grenades and throw it away or to the enemy?
	-- NOTE: Can only throw grenades away if it has a grenade attack AND can detect dangers
	-- ====== Taking Cover ====== --
ENT.AnimTbl_TakingCover = ACT_COVER_LOW -- Animations it plays when hiding behind a covered position
ENT.AnimTbl_MoveToCover = ACT_RUN_CROUCH -- Movement animations it plays when moving to a covered position
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Damaged / Injured ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- ====== Blood ====== --
	-- Leave blood tables empty to let the base decide depending on the blood type
ENT.Bleeds = true -- Can it bleed? Controls all bleeding related components such blood decal, particle, pool, etc.
ENT.BloodColor = VJ.BLOOD_COLOR_NONE -- Its blood type, this will determine the blood decal, particle, etc.
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
ENT.ForceDamageFromBosses = false -- Should it receive damage by bosses regardless of its immunities? | Bosses are attackers tagged with "VJ_ID_Boss"
ENT.AllowIgnition = true -- Can it be set on fire?
ENT.Immune_Bullet = false -- Immune to bullet damages
ENT.Immune_Melee = false -- Immune to melee damages (Ex: Slashes, stabs, punches, claws, crowbar, blunt attacks)
ENT.Immune_Explosive = false -- Immune to explosive damages (Ex: Grenades, rockets, bombs, missiles)
ENT.Immune_Dissolve = false -- Immune to dissolving damage (Ex: Combine ball)
ENT.Immune_Toxic = false -- Immune to toxic effect damages (Ex: Acid, poison, radiation, gas)
ENT.Immune_Fire = false -- Immune to fire / flame damages
ENT.Immune_Electricity = false -- Immune to electrical damages (Ex: Shocks, lasers, gravity gun)
ENT.Immune_Sonic = false -- Immune to sonic damages (Ex: Sound blasts)
	-- ====== Flinching ====== --
ENT.CanFlinch = false -- Can it flinch? | false = Don't flinch | true = Always flinch | "DamageTypes" = Flinch only from certain damages types
ENT.FlinchDamageTypes = {DMG_BLAST} -- Which types of damage types should it flinch from when "DamageTypes" is used?
ENT.FlinchChance = 16 -- Chance of flinching from 1 to x | 1 = Always flinch
ENT.FlinchCooldown = 5 -- How much time until it can flinch again? | false = Base auto calculates the duration
ENT.AnimTbl_Flinch = ACT_FLINCH_PHYSICS
ENT.FlinchHitGroupMap = false -- EXAMPLES: {{HitGroup = {HITGROUP_HEAD}, Animation = {ACT_FLINCH_HEAD}}, {HitGroup = {HITGROUP_LEFTARM}, Animation = {ACT_FLINCH_LEFTARM}}, {HitGroup = {HITGROUP_RIGHTARM}, Animation = {ACT_FLINCH_RIGHTARM}}, {HitGroup = {HITGROUP_LEFTLEG}, Animation = {ACT_FLINCH_LEFTLEG}}, {HitGroup = {HITGROUP_RIGHTLEG}, Animation = {ACT_FLINCH_RIGHTLEG}}}
ENT.FlinchHitGroupPlayDefault = true -- Should it play "self.AnimTbl_Flinch" when none of the mapped hit groups hit?
	-- ====== Non-Combat Damage Response Behaviors ====== --
	-- For passive behavior NPC, these responses will run regardless if it has an active enemy or not
ENT.DamageResponse = true -- Should it respond to damages while it has no enemy?
	-- true = Search for enemies or run to a covered position | "OnlyMove" = Will only run to a covered position | "OnlySearch" = Will only search for enemies
ENT.DamageAllyResponse = true -- Should allies respond when it's damaged while it has no enemy?
ENT.AnimTbl_DamageAllyResponse = ACT_SIGNAL_GROUP -- Animations to play when it calls allies to respond | false = Don't play an animation
ENT.DamageAllyResponse_Cooldown = VJ.SET(9, 12) -- How long until it can call allies again?
	-- ====== Combat Damage Response Behaviors ====== --
	-- Hiding behind objects uses "self.AnimTbl_TakingCover"
ENT.CombatDamageResponse = true -- Should it respond to damages while it has an active enemy? | true = Hide behind an object if possible otherwise run to a covered position
ENT.CombatDamageResponse_CoverTime = VJ.SET(3, 5) -- If it found an object to hide behind, how long should it stay hidden?
ENT.CombatDamageResponse_Cooldown = VJ.SET(3, 3.5) -- How long until it can do any combat damage response?
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Death & Corpse ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.DeathDelayTime = 0 -- Time until it spawns the corpse, removes itself, etc.
	-- ====== Ally Responses ====== --
	-- An ally must have "self.CanReceiveOrders" enabled to respond!
ENT.DeathAllyResponse = "OnlyAlert" -- How should allies response when it dies?
	-- false = No reactions | true = Allies respond by becoming alert and moving to its location | "OnlyAlert" = Allies respond by becoming alert
ENT.DeathAllyResponse_MoveLimit = 4 -- Max number of allies that can move to its location when responding to its death
	-- ====== Death Animation ====== --
	-- NOTE: This is added on top of "self.DeathDelayTime"
ENT.HasDeathAnimation = false -- Should it play death animations?
ENT.AnimTbl_Death = {}
ENT.DeathAnimationTime = false -- How long should the death animation play? | false = Base auto calculates the duration
ENT.DeathAnimationChance = 1 -- Put 1 if you want it to play the animation all the time
ENT.DeathAnimationDecreaseLengthAmount = 0 -- This will decrease the time until it turns into a corpse
	-- ====== Corpse ====== --
ENT.HasDeathCorpse = true -- Should a corpse spawn when it's killed?
ENT.DeathCorpseEntityClass = false -- Corpse's class | false = Let the base automatically detect the class
ENT.DeathCorpseModel = false -- Model(s) to use as the corpse | false = Use its current model | Can be a string or a table of strings
ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS -- Collision type for the corpse | NPC Options Menu can only override this value if it's set to COLLISION_GROUP_DEBRIS!
ENT.DeathCorpseFade = false -- Should the corpse fade after the given amount of seconds? | false = Don't fade | number = Fade out time
ENT.DeathCorpseSetBoneAngles = true -- This can be used to stop the corpse glitching or flying on death
ENT.DeathCorpseApplyForce = true -- Should the force of the damage be applied to the corpse?
ENT.DeathCorpseSubMaterials = nil -- Apply a table of indexes that correspond to a sub material index, this will cause the base to copy the NPC's sub material to the corpse.
	-- ====== Dismemberment / Gib ====== --
ENT.CanGib = true -- Can it dismember? | Makes "CreateGibEntity" fail and overrides "CanGibOnDeath" to false
ENT.CanGibOnDeath = true -- Can it dismember on death?
ENT.GibOnDeathFilter = true -- Should it only gib and call "self:HandleGibOnDeath" when it's killed by a specific damage types? | false = Call "self:HandleGibOnDeath" from any damage type
ENT.HasGibOnDeathSounds = true -- Does it have gib sounds? | Mostly used for the settings menu
ENT.HasGibOnDeathEffects = true -- Does it spawn particles on death or when it gibs? | Mostly used for the settings menu
	-- ====== Drops On Death ====== --
ENT.DropWeaponOnDeath = true -- Should it drop its weapon on death?
ENT.DropDeathLoot = true -- Should it drop loot on death?
ENT.DeathLoot = {"weapon_frag", "item_healthvial"} -- List of entities it will randomly pick to drop | Leave it empty to drop nothing
ENT.DeathLootChance = 14 -- If set to 1, it will always drop loot
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Melee Attack ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasMeleeAttack = true -- Can it melee attack?
ENT.MeleeAttackDamage = 10
ENT.MeleeAttackDamageType = DMG_CLUB
ENT.HasMeleeAttackKnockBack = true -- Should knockback be applied on melee hit? | Use "MeleeAttackKnockbackVelocity" function to edit the velocity
ENT.DisableDefaultMeleeAttackCode = false -- Completely disable the default melee attack code
ENT.DisableDefaultMeleeAttackDamageCode = false -- Disables the default melee attack damage code
	-- ====== Animation ====== --
ENT.AnimTbl_MeleeAttack = ACT_MELEE_ATTACK1 -- Animations to play when it melee attacks | false = Don't play an animation
ENT.MeleeAttackAnimationFaceEnemy = true -- Should it face the enemy while playing the melee attack animation?
ENT.MeleeAttackAnimationDecreaseLengthAmount = 0 -- Decreases animation time | Use it to fix animations that have extra frames at the end
	-- ====== Distance ====== --
ENT.MeleeAttackDistance = false -- How close an enemy has to be to trigger a melee attack | false = Auto calculate on initialize based on its collision bounds
ENT.MeleeAttackAngleRadius = 100 -- What is the attack angle radius? | 100 = In front of it | 180 = All around it
ENT.MeleeAttackDamageDistance = false -- How far does the damage go? | false = Auto calculate on initialize based on its collision bounds
ENT.MeleeAttackDamageAngleRadius = 100 -- What is the damage angle radius? | 100 = In front of it | 180 = All around it
	-- ====== Timer ====== --
ENT.TimeUntilMeleeAttackDamage = 0.5 -- How much time until it executes the damage? | false = Make the attack event-based
ENT.NextMeleeAttackTime = 0 -- How much time until it can use a melee attack? | number = Specific time | VJ.SET = Randomized between the 2 numbers
ENT.NextAnyAttackTime_Melee = false -- How much time until it can do any attack again? | false = Base auto calculates the duration | number = Specific time | VJ.SET = Randomized between the 2 numbers
ENT.MeleeAttackReps = 1 -- How many times does it run the melee attack code?
ENT.MeleeAttackExtraTimers = false -- Extra melee attack timers, EX: {1, 1.4}
ENT.MeleeAttackStopOnHit = false -- Should it stop executing the melee attack after it hits an enemy?
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Grenade Attack ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasGrenadeAttack = false -- Does it have a grenade attack?
ENT.GrenadeAttackEntity = "obj_vj_grenade" -- Entities that it can spawn when throwing a grenade | If set as a table, it picks a random entity | VJ: "obj_vj_grenade" | HL2: "npc_grenade_frag"
ENT.GrenadeAttackMinDistance = 400 -- Min distance it can throw a grenade
ENT.GrenadeAttackMaxDistance = 1500 -- Max distance it can throw a grenade
ENT.GrenadeAttackChance = 4 -- 1 in x chance that it will throw a grenade when all the requirements are met | 1 = Throw it every time
ENT.GrenadeAttackModel = false -- Overrides the grenade model | Can be string or table | Does NOT apply to picked up grenades and forced grenade attacks with custom entity
ENT.GrenadeAttackAttachment = "anim_attachment_LH" -- The attachment that the grenade will be set to | -1 = Skip to use "self.GrenadeAttackBone" instead
ENT.GrenadeAttackBone = "ValveBiped.Bip01_L_Finger1" -- The bone that the grenade will be set to | -1 = Skip to use fail safe instead
	-- ====== Animation ====== --
ENT.AnimTbl_GrenadeAttack = "grenThrow" -- Animations to play when it throws a grenade | false = Don't play an animation
ENT.GrenadeAttackAnimationFaceEnemy = true -- Should it face the enemy while playing the grenade attack animation?
	-- ====== Timer ====== --
ENT.GrenadeAttackThrowTime = 0.72 -- Time until the grenade is thrown | false = Make the attack event-based
ENT.NextGrenadeAttackTime = VJ.SET(10, 15) -- Time until it can do a grenade attack again | number = Specific time | VJ.SET = Randomized between the 2 numbers
ENT.NextAnyAttackTime_Grenade = false -- How much time until it can do any attack again? | false = Base auto calculates the duration | number = Specific time | VJ.SET = Randomized between the 2 numbers
ENT.GrenadeAttackFuseTime = 3 -- Grenade's fuse time after it's thrown
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Weapon Attack ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.Weapon_Disabled = false -- Disable the ability for it to use weapons
ENT.Weapon_IgnoreSpawnMenu = false -- Should it ignore weapon overrides from the spawn menu?
ENT.Weapon_UnarmedBehavior = true -- Should it flee from enemies when it's unarmed?
ENT.Weapon_Accuracy = 1 -- Its accuracy with weapons, affects bullet spread! | x < 1 = Better accuracy | x > 1 = Worse accuracy
ENT.Weapon_CanMoveFire = true -- Can it fire its weapon while it's moving?
ENT.Weapon_Strafe = true -- Should it strafe around while firing a weapon?
ENT.Weapon_StrafeCooldown = VJ.SET(3, 6) -- How much time until it can strafe again?
ENT.Weapon_OcclusionDelay = true -- Should it wait before leaving its position to pursue the enemy after its been occluded?
ENT.Weapon_OcclusionDelayTime = VJ.SET(3, 5) -- How long should it wait before it starts to pursue?
ENT.Weapon_OcclusionDelayMinDist = 100 -- Skip this behavior if the occluded enemy is within this distance
	-- ====== Distance ====== --
ENT.Weapon_MinDistance = 10 -- Min distance it can fire a weapon
ENT.Weapon_MaxDistance = 3000 -- Max distance it can fire a weapon
ENT.Weapon_RetreatDistance = 150 -- Minimum distance an enemy has to be for it to retreat back | 0 = Never retreat
ENT.Weapon_AimTurnDiff = false -- Weapon aim turning threshold between 0 and 1 | "self.HasPoseParameterLooking" must be set to true!
	-- EXAMPLES: 0.707106781187 = 45 degrees | 0.866025403784 = 30 degrees | 1 = 0 degrees, always turn!
	-- false = Let base decide based on animation set and weapon hold type
	-- ====== Primary Fire ====== --
ENT.AnimTbl_WeaponAttack = ACT_RANGE_ATTACK1 -- Animations to play while firing a weapon
ENT.AnimTbl_WeaponAttackGesture = ACT_GESTURE_RANGE_ATTACK1 -- Gesture animations to play while firing a weapon | false = Don't play an animation
ENT.Weapon_CanCrouchAttack = true -- Can it crouch while firing a weapon?
ENT.Weapon_CrouchAttackChance = 2 -- What is the chance of it crouching? | 1 = Crouch whenever possible
ENT.AnimTbl_WeaponAttackCrouch = ACT_RANGE_ATTACK1_LOW -- Animations to play while firing a weapon in crouched position
	-- ====== Secondary Fire ====== --
ENT.Weapon_CanSecondaryFire = true -- Can it use a weapon's secondary fire if it's available?
ENT.Weapon_SecondaryFireTime = false -- How much time until the secondary fire's projectile is released | false = Base auto calculates the duration
ENT.AnimTbl_WeaponAttackSecondary = ACT_RANGE_ATTACK2 -- Animations to play while firing the weapon's secondary attack
	-- ====== Reloading ====== --
ENT.Weapon_CanReload = true -- Can it reload weapons?
ENT.Weapon_FindCoverOnReload = true -- Should it attempt to find cover before proceeding to reload?
ENT.AnimTbl_WeaponReload = ACT_RELOAD
ENT.AnimTbl_WeaponReloadCovered = ACT_RELOAD_LOW
ENT.DisableWeaponReloadAnimation = false -- Disables the default reload animation code
	-- ====== Weapon Inventory ====== --
	-- Weapons are given on spawn and it will only switch to those if the requirements are met
	-- All are stored in "self.WeaponInventory" with the following keys:
		-- Primary		: Default weapon
		-- AntiArmor	: Enemy is an armored tank/vehicle or a boss
		-- Melee		: Enemy is (very close and the NPC is out of ammo) OR (in melee attack distance) + NPC must have more than 25% health
ENT.WeaponInventory_AntiArmorList = false -- Anti-armor weapons to give on spawn | Can be table or string
ENT.WeaponInventory_MeleeList = false -- Melee weapons to give on spawn | Can be table or string
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Sound ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasSounds = true -- Can it play sounds? | false = Disable ALL sounds
ENT.DamageByPlayerDispositionLevel = 1 -- When should it play "DamageByPlayer" sounds? | 0 = Always | 1 = ONLY when friendly to player | 2 = ONLY when enemy to player
	-- ====== Footstep Sound ====== --
ENT.HasFootstepSounds = true -- Can it play footstep sounds?
ENT.DisableFootStepSoundTimer = false -- Disables the timer system, allowing to utilize model events
ENT.FootstepSoundTimerWalk = 0.5 -- Delay between footstep sounds while it is walking | false = Disable while walking
ENT.FootstepSoundTimerRun = 0.25 -- Delay between footstep sounds while it is running | false = Disable while running
	-- ====== Idle Sound ====== --
ENT.HasIdleSounds = true -- Can it play idle sounds? | Controls "self.SoundTbl_Idle", "self.SoundTbl_IdleDialogue", "self.SoundTbl_CombatIdle"
ENT.IdleSoundsWhileAttacking = false -- Can it play idle sounds while performing an attack?
ENT.IdleSoundsRegWhileAlert = false -- Should it disable playing regular idle sounds when combat idle sound is empty?
	-- ====== Idle Dialogue Sound ====== --
	-- When an allied NPC or player is within range, it will play these sounds rather than regular idle sounds
	-- If the ally is a VJ NPC and has dialogue answer sounds, it will respond back
ENT.HasIdleDialogueSounds = true -- Can it play idle dialogue sounds?
ENT.HasIdleDialogueAnswerSounds = true -- Can it play idle dialogue answer sounds?
ENT.IdleDialogueDistance = 400 -- How close should an ally be for it to initiate a dialogue
ENT.IdleDialogueCanTurn = true -- Should it turn to to face its dialogue target?
	-- ====== On Killed Enemy ====== --
ENT.HasKilledEnemySounds = true -- Can it play sounds when it kills an enemy?
ENT.KilledEnemySoundLast = true -- Should it only play "self.SoundTbl_KilledEnemy" if there is no enemies left?
	-- ====== Sound Track ====== --
ENT.HasSoundTrack = false -- Can it play sound tracks?
ENT.SoundTrackVolume = 1 -- Volume of the sound track | 1 = Normal | 2 = 200% | 0.5 = 50%
ENT.SoundTrackPlaybackRate = 1 -- Playback speed of sound tracks | 1 = Normal | 2 = Twice the speed | 0.5 = Half the speed
	-- ====== Other Sound Controls ====== --
ENT.HasBreathSound = true -- Can it play breathing sounds?
ENT.HasReceiveOrderSounds = true -- Can it play sounds when it receives an order?
ENT.HasFollowPlayerSounds = true -- Can it play follow and unfollow player sounds? | Controls "self.SoundTbl_FollowPlayer", "self.SoundTbl_UnFollowPlayer"
ENT.HasYieldToPlayerSounds = true -- Can it play sounds when it yields to an allied player?
ENT.HasMedicSounds = true -- Can it play medic sounds? | Controls "self.SoundTbl_MedicBeforeHeal", "self.SoundTbl_MedicOnHeal", "self.SoundTbl_MedicReceiveHeal"
ENT.HasOnPlayerSightSounds = true -- Can it play sounds when it sees a player?
ENT.HasInvestigateSounds = true -- Can it play sounds when it investigates something?
ENT.HasLostEnemySounds = true -- Can it play sounds when it looses its enemy?
ENT.HasAlertSounds = true -- Can it play alert sounds?
ENT.HasCallForHelpSounds = true -- Can it play sounds when it call allies for help?
ENT.HasBecomeEnemyToPlayerSounds = true -- Can it play sounds when it becomes hostile to an allied player?
ENT.HasSuppressingSounds = true -- Can it play weapon suppressing sounds?
ENT.HasWeaponReloadSounds = true -- Can it play weapon reload sounds?
ENT.HasMeleeAttackSounds = true -- Can it play melee attack sounds? | Controls "self.SoundTbl_BeforeMeleeAttack", "self.SoundTbl_MeleeAttack", "self.SoundTbl_MeleeAttackExtra"
ENT.HasExtraMeleeAttackSounds = true -- Can it play extra melee attack sound effects?
ENT.HasMeleeAttackMissSounds = true -- Can it play melee attack miss sounds?
ENT.HasGrenadeAttackSounds = true -- Can it play grenade attack sounds?
ENT.HasDangerSightSounds = true -- Can it play sounds with detects a danger? | Controls "self.SoundTbl_DangerSight", "self.SoundTbl_GrenadeSight"
ENT.HasAllyDeathSounds = true -- Can it play sounds when an ally dies?
ENT.HasPainSounds = true -- Can it play pain sounds?
ENT.HasImpactSounds = true -- Can it play impact sound effects?
ENT.HasDamageByPlayerSounds = true -- Can it play sounds when it's damaged by a player?
ENT.HasDeathSounds = true -- Can it play death sounds?
	-- ====== Sound Paths ====== --
	-- There are 2 types of sounds: "Speech" and "EFFECT" | Most sound tables are "SPEECH" unless stated
		-- SPEECH : Mostly play speech sounds | Will stop when another speech sound is played
		-- EFFECT : Mostly play sound effects | EX: Movement sound, impact sound, attack swipe sound, etc.
ENT.SoundTbl_SoundTrack = false
ENT.SoundTbl_FootStep = "VJ.Footstep.Human" -- EFFECT
ENT.SoundTbl_Breath = false -- EFFECT
ENT.SoundTbl_Idle = false
ENT.SoundTbl_IdleDialogue = false
ENT.SoundTbl_IdleDialogueAnswer = false
ENT.SoundTbl_CombatIdle = false
ENT.SoundTbl_ReceiveOrder = false
ENT.SoundTbl_FollowPlayer = false
ENT.SoundTbl_UnFollowPlayer = false
ENT.SoundTbl_YieldToPlayer = false
ENT.SoundTbl_MedicBeforeHeal = false
ENT.SoundTbl_MedicOnHeal = "items/smallmedkit1.wav" -- EFFECT
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
ENT.SoundTbl_MeleeAttackExtra = "Flesh.ImpactHard" -- EFFECT
ENT.SoundTbl_MeleeAttackMiss = "Zombie.AttackMiss" -- EFFECT
ENT.SoundTbl_GrenadeAttack = false
ENT.SoundTbl_DangerSight = false
ENT.SoundTbl_GrenadeSight = false -- If empty it will play "self.SoundTbl_DangerSight"
ENT.SoundTbl_KilledEnemy = false
ENT.SoundTbl_AllyDeath = false
ENT.SoundTbl_Pain = false
ENT.SoundTbl_Impact = "Flesh.BulletImpact" -- EFFECT
ENT.SoundTbl_DamageByPlayer = false
ENT.SoundTbl_Death = false
	-- ====== Sound Chance ====== --
	-- Higher number = less chance of playing | 1 = Always play
ENT.IdleSoundChance = 3
ENT.IdleDialogueAnswerSoundChance = 1
ENT.CombatIdleSoundChance = 1
ENT.ReceiveOrderSoundChance = 1
ENT.FollowPlayerSoundChance = 1 -- Controls "self.SoundTbl_FollowPlayer", "self.SoundTbl_UnFollowPlayer"
ENT.YieldToPlayerSoundChance = 2
ENT.MedicBeforeHealSoundChance = 1
ENT.MedicOnHealSoundChance = 1
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
ENT.DangerSightSoundChance = 1 -- Controls "self.SoundTbl_DangerSight", "self.SoundTbl_GrenadeSight"
ENT.SuppressingSoundChance = 2
ENT.WeaponReloadSoundChance = 1
ENT.KilledEnemySoundChance = 1
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
ENT.NextSoundTime_KilledEnemy = VJ.SET(3, 5)
ENT.NextSoundTime_AllyDeath = VJ.SET(3, 5)
	-- ====== Sound Level ====== --
	-- The proper number are usually range from 0 to 180, though it can go as high as 511
	-- More Information: https://developer.valvesoftware.com/wiki/Soundscripts#SoundLevel_Flags
ENT.FootstepSoundLevel = 70
ENT.BreathSoundLevel = 60
ENT.IdleSoundLevel = 75
ENT.IdleDialogueSoundLevel = 75 -- Controls "self.SoundTbl_IdleDialogue", "self.SoundTbl_IdleDialogueAnswer"
ENT.CombatIdleSoundLevel = 80
ENT.ReceiveOrderSoundLevel = 80
ENT.FollowPlayerSoundLevel = 75 -- Controls "self.SoundTbl_FollowPlayer", "self.SoundTbl_UnFollowPlayer"
ENT.YieldToPlayerSoundLevel = 75
ENT.MedicBeforeHealSoundLevel = 75
ENT.MedicOnHealSoundLevel = 75
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
ENT.DangerSightSoundLevel = 80 -- Controls "self.SoundTbl_DangerSight", "self.SoundTbl_GrenadeSight"
ENT.KilledEnemySoundLevel = 80
ENT.AllyDeathSoundLevel = 80
ENT.PainSoundLevel = 80
ENT.ImpactSoundLevel = 60
ENT.DamageByPlayerSoundLevel = 75
ENT.DeathSoundLevel = 80
	-- ====== Sound Pitch ====== --
	-- Range: 0 - 255 | Lower pitch < x > Higher pitch
ENT.MainSoundPitch = VJ.SET(90, 100) -- Can be a number or VJ.SET
ENT.MainSoundPitchStatic = true -- Should it decide a number on spawn and use it as the main pitch?
-- false = Use main pitch | number = Use a specific pitch | VJ.SET = Pick randomly between numbers every time it plays
ENT.FootstepSoundPitch = VJ.SET(80, 100)
ENT.BreathSoundPitch = 100
ENT.IdleSoundPitch = false
ENT.IdleDialogueSoundPitch = false -- Controls "self.SoundTbl_IdleDialogue", "self.SoundTbl_IdleDialogueAnswer"
ENT.CombatIdleSoundPitch = false
ENT.ReceiveOrderSoundPitch = false
ENT.FollowPlayerPitch = false -- Controls "self.SoundTbl_FollowPlayer", "self.SoundTbl_UnFollowPlayer"
ENT.YieldToPlayerSoundPitch = false
ENT.MedicBeforeHealSoundPitch = false
ENT.MedicOnHealSoundPitch = 100
ENT.MedicReceiveHealSoundPitch = false
ENT.OnPlayerSightSoundPitch = false
ENT.InvestigateSoundPitch = false
ENT.LostEnemySoundPitch = false
ENT.AlertSoundPitch = false
ENT.CallForHelpSoundPitch = false
ENT.BecomeEnemyToPlayerPitch = false
ENT.BeforeMeleeAttackSoundPitch = false
ENT.MeleeAttackSoundPitch = VJ.SET(95, 100)
ENT.ExtraMeleeSoundPitch = VJ.SET(80, 100)
ENT.MeleeAttackMissSoundPitch = VJ.SET(90, 100)
ENT.SuppressingPitch = false
ENT.WeaponReloadSoundPitch = false
ENT.GrenadeAttackSoundPitch = false
ENT.DangerSightSoundPitch = false -- Controls "self.SoundTbl_DangerSight", "self.SoundTbl_GrenadeSight"
ENT.KilledEnemySoundPitch = false
ENT.AllyDeathSoundPitch = false
ENT.PainSoundPitch = false
ENT.ImpactSoundPitch = VJ.SET(80, 100)
ENT.DamageByPlayerPitch = false
ENT.DeathSoundPitch = false
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Customization Functions ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Use the functions below to customize parts of the NPC or add new systems without overriding parts of the base
-- Some base functions don't have a hook because you can simply override them | Call "self.BaseClass.FuncName(self)" or "baseclass.Get(baseName)" to run the base code as well
--
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	-- Collision bounds of the NPC | NOTE: Both Xs and Ys should be the same! | To view: "cl_ent_bbox"
	-- self:SetCollisionBounds(Vector(50, 50, 100), Vector(-50, -50, 0))
	
	-- Damage bounds of the NPC | NOTE: Both Xs and Ys should be the same! | To view: "cl_ent_absbox"
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
		- status = Type of update that is occurring, holds one of the following states:
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
--[[---------------------------------------------------------
	UNCOMMENT TO USE | Called constantly on think as long as it can attack and has an enemy
	This can be used to create a completely new attack system OR switch between multiple attacks (such as multiple melee attacks with varying distances)
		1. isAttacking [boolean] : Whether or not the base has detected that performing an attacking
		2. enemy [entity] : Current active enemy
-----------------------------------------------------------]]
function ENT:OnThinkAttack(isAttacking, enemy) end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[
Called when melee attack is triggered

=-=-=| PARAMETERS |=-=-=
	1. status [string] : Type of update that is occurring, holds one of the following states:
		-> "Init" : When the attack initially starts | Before sound, timers, and animations are set!
			RETURNS
				-> [nil]
		-> "PostInit" : After the sound, timers, and animations are set!
			RETURNS
				-> [nil]
	2. enemy [entity] : Enemy that caused the attack to trigger

=-=-=| RETURNS |=-=-=
	-> [nil]
--]]
function ENT:OnMeleeAttack(status, enemy) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_BeforeChecks() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MeleeAttackTraceOrigin()
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
function ENT:OnWeaponStrafe() end -- Return false to disable default behavior, cooldown will still apply!
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnWeaponReload() end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[
Called when grenade attack is triggered or grenade position is requested

=-=-=| PARAMETERS |=-=-=
	1. status [string] : Type of update that is occurring, holds one of the following states:
		-> "Init" : When the attack initially starts | Before sound, timers, and animations are set!
			USAGE EXAMPLES -> Change grenade attack sounds or make changes to "self.GrenadeAttackThrowTime"
			RETURNS
				-> [nil | boolean] : Return true to disallow throwing a grenade
		-> "PostInit" : After the sound, timers, and animations are set!
			RETURNS
				-> [nil]
		-> "SpawnPos" : When the spawn position is requested
			USAGE EXAMPLES -> Override the spawn position if needed by returning a vector
			RETURNS
				-> [nil] : Do NOT override the spawn position
				-> [vector] : Override the spawn position
	2. overrideEnt [nil | string | entity] : string or entity if the grenade attack was triggered through an override
		-> [nil] : Using the default grenade class set by "self.GrenadeAttackEntity" | DEFAULT
		-> [string] : Using the given class name as an override
		-> [entity] : Using an existing entity as an override | EX: When the NPC is throwing back an enemy grenade
	3. landDir [string | vector] : Direction the grenade should land, used to align where the grenade should land
		-> "Enemy" : Use enemy's position
		-> "EnemyLastVis" : Use enemy's last visible position
		-> "FindBest" : Find the best random position
		-> [vector] : Use given vector

=-=-=| RETURNS |=-=-=
	-> [nil | vector | boolean] : Depends on `status` value, refer to it for more details
--]]
function ENT:OnGrenadeAttack(status, overrideEnt, landDir) end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[
Called when grenade attack is executed

=-=-=| PARAMETERS |=-=-=
	1. status [string] : Type of update that is occurring, holds one of the following states:
		-> "PreSpawn" : Right before "Spawn()" is called on the grenade | Not called for grenade entity overrides, such as throwing back an enemy grenade
			RETURNS
				-> [nil]
		-> "PostSpawn" : After "Spawn()" is called on the grenade | Can be used to override the throw velocity or not apply it at all
			RETURNS
				-> [nil] : Apply the default velocity
				-> [vector] : Override the velocity to the given vector
				-> [boolean] : Return true to not apply any velocity
	2. grenade [nil | entity] : The grenade entity that is being thrown
	3. overrideEnt [nil | string | entity] : string or entity if the grenade attack was triggered through an override
		-> [nil] : Using the default grenade class set by "self.GrenadeAttackEntity" | DEFAULT
		-> [string] : Using the given class name as an override
		-> [entity] : Using an existing entity as an override | EX: When the NPC is throwing back an enemy grenade
	4. landDir [string | vector] : Direction the grenade should land, used to align where the grenade should land
		-> "Enemy" : Use enemy's position
		-> "EnemyLastVis" : Use enemy's last visible position
		-> "FindBest" : Find the best random position
		-> [vector] : Use given vector
	5. landingPos [nil | vector] : The position the grenade is aimed to land

=-=-=| RETURNS |=-=-=
	-> [nil | vector | boolean] : Depends on `status` value, refer to it for more details
--]]
function ENT:OnGrenadeAttackExecute(status, grenade, overrideEnt, landDir, landingPos) end
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
		-> "Init" : First call on take damage, even before immune checks
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
		-> "Init" : Before the animation is played or any values are set
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
		-> "Init" : First call when it dies before anything is changed or reset
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
		self.AnimationTranslations[ACT_RANGE_ATTACK2] 				= VJ.SequenceToActivity(self, "shootAR2alt")
		
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
		
		//self.AnimationTranslations[ACT_RANGE_ATTACK2] 					= VJ.SequenceToActivity(self, "shootAR2alt") -- They don't have secondary animation!
		
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
		
		self.AnimationTranslations[ACT_RANGE_ATTACK2] 					= VJ.SequenceToActivity(self, "shoot_ar2_alt")
		
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

local StopSD = VJ.STOPSOUND
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

local metaEntity = FindMetaTable("Entity")
local funcGetPoseParameter = metaEntity.GetPoseParameter
local funcSetPoseParameter = metaEntity.SetPoseParameter
--
local metaNPC = FindMetaTable("NPC")
local funcHasCondition = metaNPC.HasCondition

ENT.UpdatedPoseParam = false
ENT.Weapon_UnarmedBehavior_Active = false
ENT.WeaponEntity = NULL
ENT.WeaponState = VJ.WEP_STATE_READY
ENT.WeaponInventoryStatus = VJ.WEP_INVENTORY_NONE
ENT.AllowWeaponOcclusionDelay = true
ENT.WeaponLastShotTime = 0
ENT.WeaponAttackState = VJ.WEP_ATTACK_STATE_NONE
ENT.WeaponAttackAnim = ACT_INVALID
ENT.Weapon_AimTurnDiff_Def = 1 -- Default value to use when "self.Weapon_AimTurnDiff" false, this is auto calculated depending on anim set and weapon hold type
ENT.NextWeaponAttackT = 0
ENT.NextWeaponAttackT_Base = 0 -- Handled by the base, used to avoid running shoot animation twice
ENT.NextWeaponStrafeT = 0
ENT.NextMeleeWeaponAttackT = 0
ENT.NextMoveOnGunCoveredT = 0
ENT.NextThrowGrenadeT = 0
ENT.NextGrenadeAttackSoundT = 0
ENT.NextSuppressingSoundT = 0
ENT.NextDangerDetectionT = 0
ENT.NextDangerSightSoundT = 0
ENT.NextCombatDamageResponseT = 0

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
	if vj_npc_allies:GetInt() == 0 then self.CanAlly = false end
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
	if vj_npc_wep:GetInt() == 0 then self.Weapon_Disabled = true end
	if vj_npc_grenade:GetInt() == 0 then self.HasGrenadeAttack = false end
	if vj_npc_dangerdetection:GetInt() == 0 then self.CanDetectDangers = false end
	if vj_npc_wep_drop:GetInt() == 0 then self.DropWeaponOnDeath = false end
	if vj_npc_gib_vfx:GetInt() == 0 then self.HasGibOnDeathEffects = false end
	if vj_npc_gib:GetInt() == 0 then self.CanGib = false self.CanGibOnDeath = false end
	if vj_npc_blood_gmod:GetInt() == 1 then self.BloodDecalUseGMod = true end
	if vj_npc_sight_xray:GetInt() == 1 then self.SightAngle = 360 self.EnemyXRayDetection = true end
	if vj_npc_snd_gib:GetInt() == 0 then self.HasGibOnDeathSounds = false end
	if vj_npc_snd_track:GetInt() == 0 then self.HasSoundTrack = false end
	if vj_npc_snd_footstep:GetInt() == 0 then self.HasFootstepSounds = false end
	if vj_npc_snd_idle:GetInt() == 0 then self.HasIdleSounds = false end
	if vj_npc_snd_breath:GetInt() == 0 then self.HasBreathSound = false end
	if vj_npc_snd_alert:GetInt() == 0 then self.HasAlertSounds = false end
	if vj_npc_snd_danger:GetInt() == 0 then self.HasDangerSightSounds = false end
	if vj_npc_snd_melee:GetInt() == 0 then self.HasMeleeAttackSounds = false self.HasExtraMeleeAttackSounds = false self.HasMeleeAttackMissSounds = false end
	if vj_npc_snd_pain:GetInt() == 0 then self.HasPainSounds = false end
	if vj_npc_snd_death:GetInt() == 0 then self.HasDeathSounds = false end
	if vj_npc_snd_plyfollow:GetInt() == 0 then self.HasFollowPlayerSounds = false end
	if vj_npc_snd_plybetrayal:GetInt() == 0 then self.HasBecomeEnemyToPlayerSounds = false end
	if vj_npc_snd_plydamage:GetInt() == 0 then self.HasDamageByPlayerSounds = false end
	if vj_npc_snd_plysight:GetInt() == 0 then self.HasOnPlayerSightSounds = false end
	if vj_npc_snd_medic:GetInt() == 0 then self.HasMedicSounds = false end
	if vj_npc_snd_wep_reload:GetInt() == 0 then self.HasWeaponReloadSounds = false end
	if vj_npc_snd_grenade:GetInt() == 0 then self.HasGrenadeAttackSounds = false end
	if vj_npc_snd_wep_suppressing:GetInt() == 0 then self.HasSuppressingSounds = false end
	if vj_npc_snd_callhelp:GetInt() == 0 then self.HasCallForHelpSounds = false end
	if vj_npc_snd_receiveorder:GetInt() == 0 then self.HasReceiveOrderSounds = false end
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
	if self.CustomOnMoveRandomlyWhenShooting then self.OnWeaponStrafe = function() return self:CustomOnMoveRandomlyWhenShooting() end end
	if self.CustomOnAcceptInput then self.OnInput = function(_, key, activator, caller, data) self:CustomOnAcceptInput(key, activator, caller, data) end end
	if self.CustomOnHandleAnimEvent then self.OnAnimEvent = function(_, ev, evTime, evCycle, evType, evOptions) self:CustomOnHandleAnimEvent(ev, evTime, evCycle, evType, evOptions) end end
	if self.CustomOnWeaponReload then self.OnWeaponReload = function() self:CustomOnWeaponReload() end end
	if self.CustomOnWeaponAttack then self.OnWeaponAttack = function() self:CustomOnWeaponAttack() end end
	if self.CustomOnDropWeapon then self.OnDeathWeaponDrop = function(_, dmginfo, hitgroup, wepEnt) self:CustomOnDropWeapon(dmginfo, hitgroup, wepEnt) end end
	if self.CustomOnDeath_AfterCorpseSpawned then self.OnCreateDeathCorpse = function(_, dmginfo, hitgroup, corpseEnt) self:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt) end end
	if self.HasHealthRegeneration then self.HealthRegenParams.Enabled = true end
	if self.HealthRegenerationAmount then self.HealthRegenParams.Amount = self.HealthRegenerationAmount end
	if self.HealthRegenerationDelay then self.HealthRegenParams.Delay = self.HealthRegenerationDelay end
	if self.HealthRegenerationResetOnDmg then self.HealthRegenParams.ResetOnDmg = self.HealthRegenerationResetOnDmg end
	if self.FriendsWithAllPlayerAllies != nil then self.AlliedWithPlayerAllies = self.FriendsWithAllPlayerAllies end
	if self.MoveRandomlyWhenShooting != nil then self.Weapon_Strafe = self.MoveRandomlyWhenShooting end
	if self.GrenadeAttackThrowDistance then self.GrenadeAttackMaxDistance = self.GrenadeAttackThrowDistance end
	if self.GrenadeAttackThrowDistanceClose then self.GrenadeAttackMinDistance = self.GrenadeAttackThrowDistanceClose end
	if self.NextThrowGrenadeTime != nil then self.NextGrenadeAttackTime = self.NextThrowGrenadeTime end
	if self.TimeUntilGrenadeIsReleased != nil then self.GrenadeAttackThrowTime = self.TimeUntilGrenadeIsReleased end
	if self.NextMoveRandomlyWhenShootingTime1 or self.NextMoveRandomlyWhenShootingTime2 then self.Weapon_StrafeCooldown = VJ.SET(self.NextMoveRandomlyWhenShootingTime1 or 3, self.NextMoveRandomlyWhenShootingTime2 or 6) end
	if self.WaitForEnemyToComeOut != nil then self.Weapon_OcclusionDelay = self.WaitForEnemyToComeOut end
	if self.WaitForEnemyToComeOutTime then self.Weapon_OcclusionDelayTime = self.WaitForEnemyToComeOutTime end
	if self.MoveOrHideOnDamageByEnemy != nil then self.CombatDamageResponse = self.MoveOrHideOnDamageByEnemy end
	if self.MoveOrHideOnDamageByEnemy_HideTime then self.CombatDamageResponse_CoverTime = self.MoveOrHideOnDamageByEnemy_HideTime end
	if self.Medic_CanBeHealed == false then self.VJ_ID_Healable = false end
	if self.DisableWeaponFiringGesture == true then self.AnimTbl_WeaponAttackGesture = false end
	if self.Immune_AcidPoisonRadiation != nil then self.Immune_Toxic = self.Immune_AcidPoisonRadiation end
	if self.Immune_Blast != nil then self.Immune_Explosive = self.Immune_Blast end
	if self.FindEnemy_CanSeeThroughWalls == true then self.EnemyXRayDetection = true end
	if self.DisableFindEnemy == true then self.EnemyDetection = false end
	if self.DisableTouchFindEnemy == true then self.EnemyTouchDetection = false end
	if self.HasFootStepSound then self.HasFootstepSounds = self.HasFootStepSound end
	if self.FootStepPitch then self.FootstepSoundPitch = self.FootStepPitch end
	if self.FootStepSoundLevel then self.FootstepSoundLevel = self.FootStepSoundLevel end
	if self.FootStepTimeWalk then self.FootstepSoundTimerWalk = self.FootStepTimeWalk end
	if self.FootStepTimeRun then self.FootstepSoundTimerRun = self.FootStepTimeRun end
	if self.HitGroupFlinching_Values then self.FlinchHitGroupMap = self.HitGroupFlinching_Values end
	if self.HitGroupFlinching_DefaultWhenNotHit != nil then self.FlinchHitGroupPlayDefault = self.HitGroupFlinching_DefaultWhenNotHit end
	if self.NextFlinchTime != nil then self.FlinchCooldown = self.NextFlinchTime end
	if self.NextCallForHelpTime then self.CallForHelpCooldown = self.NextCallForHelpTime end
	if self.CallForHelpAnimationFaceEnemy != nil then self.CallForHelpAnimFaceEnemy = self.CallForHelpAnimationFaceEnemy end
	if self.NextCallForHelpAnimationTime != nil then self.CallForHelpAnimCooldown = self.NextCallForHelpAnimationTime end
	if self.InvestigateSoundDistance != nil then self.InvestigateSoundMultiplier = self.InvestigateSoundDistance end
	if self.CanThrowBackDetectedGrenades != nil then self.CanRedirectGrenades = self.CanThrowBackDetectedGrenades end
	if self.SoundTbl_OnKilledEnemy != nil then self.SoundTbl_KilledEnemy = self.SoundTbl_OnKilledEnemy end
	if self.HasOnKilledEnemySounds != nil then self.HasKilledEnemySounds = self.HasOnKilledEnemySounds end
	if self.OnKilledEnemySoundChance then self.OnKilledEnemySoundChance = self.OnKilledEnemySoundChance end
	if self.NextSoundTime_OnKilledEnemy then self.NextSoundTime_KilledEnemy = self.NextSoundTime_OnKilledEnemy end
	if self.OnKilledEnemySoundLevel then self.KilledEnemySoundLevel = self.OnKilledEnemySoundLevel end
	if self.OnKilledEnemySoundPitch != nil then self.KilledEnemySoundPitch = self.OnKilledEnemySoundPitch end
	if self.IdleSounds_PlayOnAttacks != nil then self.IdleSoundsWhileAttacking = self.IdleSounds_PlayOnAttacks end
	if self.IdleSounds_NoRegularIdleOnAlerted != nil then self.IdleSoundsRegWhileAlert = self.IdleSounds_NoRegularIdleOnAlerted end
	if self.HasOnReceiveOrderSounds != nil then self.HasReceiveOrderSounds = self.HasOnReceiveOrderSounds end
	if self.SoundTbl_OnReceiveOrder != nil then self.SoundTbl_ReceiveOrder = self.SoundTbl_OnReceiveOrder end
	if self.OnReceiveOrderSoundChance != nil then self.ReceiveOrderSoundChance = self.OnReceiveOrderSoundChance end
	if self.OnReceiveOrderSoundLevel != nil then self.ReceiveOrderSoundLevel = self.OnReceiveOrderSoundLevel end
	if self.OnReceiveOrderSoundPitch != nil then self.ReceiveOrderSoundPitch = self.OnReceiveOrderSoundPitch end
	if self.OnGrenadeSightSoundLevel != nil then self.DangerSightSoundLevel = self.OnGrenadeSightSoundLevel end
	if self.SoundTbl_OnDangerSight != nil then self.SoundTbl_DangerSight = self.SoundTbl_OnDangerSight end
	if self.SoundTbl_OnGrenadeSight != nil then self.SoundTbl_GrenadeSight = self.SoundTbl_OnGrenadeSight end
	if self.SoundTbl_MedicAfterHeal != nil then self.SoundTbl_MedicOnHeal = self.SoundTbl_MedicAfterHeal end
	if self.MedicAfterHealSoundChance != nil then self.MedicOnHealSoundChance = self.MedicAfterHealSoundChance end
	if self.BeforeHealSoundLevel != nil then self.MedicBeforeHealSoundLevel = self.BeforeHealSoundLevel end
	if self.AfterHealSoundLevel != nil then self.MedicOnHealSoundLevel = self.AfterHealSoundLevel end
	if self.BeforeHealSoundPitch != nil then self.MedicBeforeHealSoundPitch = self.BeforeHealSoundPitch end
	if self.AfterHealSoundPitch != nil then self.MedicOnHealSoundPitch = self.AfterHealSoundPitch end
	if self.Immune_Physics then self:SetPhysicsDamageScale(0) end
	if self.StopMeleeAttackAfterFirstHit != nil then self.MeleeAttackStopOnHit = self.StopMeleeAttackAfterFirstHit end
	if self.DisableMeleeAttackAnimation == true then self.AnimTbl_MeleeAttack = false end
	if self.Weapon_FiringDistanceClose then self.Weapon_MinDistance = self.Weapon_FiringDistanceClose end
	if self.Weapon_FiringDistanceFar then self.Weapon_MaxDistance = self.Weapon_FiringDistanceFar end
	if self.DisableWeapons != nil then self.Weapon_Disabled = self.DisableWeapons end
	if self.Passive_RunOnDamage == false then self.DamageResponse = false end
	if self.HideOnUnknownDamage == false then self.DamageResponse = "OnlySearch" end
	if self.DisableTakeDamageFindEnemy == true then if self.HideOnUnknownDamage == false then self.DamageResponse = false else self.DamageResponse = "OnlyMove" end end
	if self.CanFlinch == 0 then self.CanFlinch = false end
	if self.CanFlinch == 1 then self.CanFlinch = true end
	if self.CanFlinch == 2 then self.CanFlinch = "DamageTypes" end
	if self.BringFriendsOnDeath != nil or self.AlertFriendsOnDeath != nil then
		if self.AlertFriendsOnDeath == true && (self.BringFriendsOnDeath == false or self.BringFriendsOnDeath == nil) then
			self.DeathAllyResponse = "OnlyAlert"
		elseif self.BringFriendsOnDeath == false && self.AlertFriendsOnDeath == false then
			self.DeathAllyResponse = false
		end
	end
	if self.BringFriendsOnDeathLimit then self.DeathAllyResponse_MoveLimit = self.BringFriendsOnDeathLimit end
	if self.VJC_Data then self.ControllerParams = self.VJC_Data end
	if self.HasCallForHelpAnimation == false then self.AnimTbl_CallForHelp = false end
	if self.Medic_DisableAnimation == true then self.AnimTbl_Medic_GiveHealth = false end
	if self.ConstantlyFaceEnemyDistance then self.ConstantlyFaceEnemy_MinDistance = self.ConstantlyFaceEnemyDistance end
	if self.CallForBackUpOnDamage != nil then self.DamageAllyResponse = self.CallForBackUpOnDamage end
	if self.NextCallForBackUpOnDamageTime then self.DamageAllyResponse_Cooldown = self.NextCallForBackUpOnDamageTime end
	if self.CallForBackUpOnDamageAnimation then self.AnimTbl_DamageAllyResponse = self.CallForBackUpOnDamageAnimation end
	if self.UseTheSameGeneralSoundPitch != nil then self.MainSoundPitchStatic = self.UseTheSameGeneralSoundPitch end
	if self.GeneralSoundPitch1 or self.GeneralSoundPitch2 then self.MainSoundPitch = VJ.SET(self.GeneralSoundPitch1 or 90, self.GeneralSoundPitch2 or 100) end
	if self.AlertedToIdleTime then self.AlertTimeout = self.AlertedToIdleTime end
	if self.SoundTbl_MoveOutOfPlayersWay then self.SoundTbl_YieldToPlayer = self.SoundTbl_MoveOutOfPlayersWay end
	if self.MaxJumpLegalDistance then self.JumpParams.MaxRise = self.MaxJumpLegalDistance.a; self.JumpParams.MaxDrop = self.MaxJumpLegalDistance.b end
	if self.VJ_IsHugeMonster then self.VJ_ID_Boss = self.VJ_IsHugeMonster end
	if self.Medic_HealthAmount then self.Medic_HealAmount = self.Medic_HealthAmount end
	if self.UsePlayerModelMovement then self.UsePoseParameterMovement = true end
	if self.MoveOutOfFriendlyPlayersWay != nil then self.YieldToAlliedPlayers = self.MoveOutOfFriendlyPlayersWay end
	if self.WaitBeforeDeathTime then self.DeathDelayTime = self.WaitBeforeDeathTime end
	if self.HasDeathRagdoll != nil then self.HasDeathCorpse = self.HasDeathRagdoll end
	if self.AllowedToGib != nil then self.CanGib = self.AllowedToGib end
	if self.HasGibOnDeath != nil then self.CanGibOnDeath = self.HasGibOnDeath end
	if self.HasGibDeathParticles != nil then self.HasGibOnDeathEffects = self.HasGibDeathParticles else self.HasGibDeathParticles = self.HasGibOnDeathEffects end
	if self.HasItemDropsOnDeath != nil then self.DropDeathLoot = self.HasItemDropsOnDeath end
	if self.ItemDropsOnDeathChance != nil then self.DeathLootChance = self.ItemDropsOnDeathChance end
	if self.ItemDropsOnDeath_EntityList != nil then self.DeathLoot = self.ItemDropsOnDeath_EntityList end
	if self.AllowMovementJumping != nil then self.JumpParams.Enabled = self.AllowMovementJumping end
	if self.HasShootWhileMoving == false then self.Weapon_CanMoveFire = false end
	if self.HasWeaponBackAway == false then self.Weapon_RetreatDistance = 0 end
	if self.WeaponBackAway_Distance then self.Weapon_RetreatDistance = self.WeaponBackAway_Distance end
	if self.WeaponSpread then self.Weapon_Accuracy = self.WeaponSpread end
	if self.AllowWeaponReloading != nil then self.Weapon_CanReload = self.AllowWeaponReloading end
	if self.WeaponReload_FindCover != nil then self.Weapon_FindCoverOnReload = self.WeaponReload_FindCover end
	if self.ThrowGrenadeChance then self.GrenadeAttackChance = self.ThrowGrenadeChance end
	if self.OnlyDoKillEnemyWhenClear != nil then self.KilledEnemySoundLast = self.OnlyDoKillEnemyWhenClear end
	if self.NoWeapon_UseScaredBehavior != nil then self.Weapon_UnarmedBehavior = self.NoWeapon_UseScaredBehavior end
	if self.CanCrouchOnWeaponAttack != nil then self.Weapon_CanCrouchAttack = self.CanCrouchOnWeaponAttack end
	if self.CanCrouchOnWeaponAttackChance != nil then self.Weapon_CrouchAttackChance = self.CanCrouchOnWeaponAttackChance end
	if self.AnimTbl_WeaponAttackFiringGesture != nil then self.AnimTbl_WeaponAttackGesture = self.AnimTbl_WeaponAttackFiringGesture end
	if self.CanUseSecondaryOnWeaponAttack != nil then self.Weapon_CanSecondaryFire = self.CanUseSecondaryOnWeaponAttack end
	if self.WeaponAttackSecondaryTimeUntilFire != nil then self.Weapon_SecondaryFireTime = self.WeaponAttackSecondaryTimeUntilFire end
	if self.DisableFootStepOnWalk then self.FootstepSoundTimerWalk = false end
	if self.DisableFootStepOnRun then self.FootstepSoundTimerRun = false end
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
			if (self.KilledEnemySoundLast == false) or (self.KilledEnemySoundLast == true && wasLast) then
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
			if status == "Init" && self.CustomOnTakeDamage_BeforeImmuneChecks then
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
			if status == "Init" then
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
			if status == "Init" then
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
	if self.CustomAttack then
		self.OnThinkAttack = function(_, isAttacking, enemy)
			if self.CustomAttack then self:CustomAttack(enemy, self.EnemyData.Visible) end
		end
	end
	if self.CustomOnMeleeAttack_BeforeStartTimer or self.CustomOnMeleeAttack_AfterStartTimer then
		self.OnMeleeAttack = function(_, status, enemy)
			if status == "Init" && self.CustomOnMeleeAttack_BeforeStartTimer then
				self:CustomOnMeleeAttack_BeforeStartTimer(self.AttackSeed)
			elseif status == "PostInit" && self.CustomOnMeleeAttack_AfterStartTimer then
				self:CustomOnMeleeAttack_AfterStartTimer(self.AttackSeed)
			end
		end
	end
	if self.GetMeleeAttackDamageOrigin then
		self.MeleeAttackTraceOrigin = function()
			return self:GetMeleeAttackDamageOrigin()
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
	if !self:GetModel() then
		local models = PICK(self.Model)
		if models then
			self:SetModel(models)
		end
	end
	self:SetHullType(self.HullType)
	self:SetHullSizeNormal()
	self:SetSolid(SOLID_BBOX)
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
	self.NextIdleSoundT_Reg = CurTime() + math.random(0.3, 6)
	self.MainSoundPitchValue = (self.MainSoundPitchStatic and (istable(self.MainSoundPitch) and math.random(self.MainSoundPitch.a, self.MainSoundPitch.b) or self.MainSoundPitch)) or 0
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
		self.Weapon_Disabled = true
		self.Weapon_IgnoreSpawnMenu = true
	elseif !self.Weapon_Disabled && !self.Weapon_IgnoreSpawnMenu then
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
			if self.Weapon_Disabled then
				self:UpdateAnimationTranslations()
			else
				local wep = self:GetActiveWeapon()
				if IsValid(wep) then
					self.WeaponEntity = self:DoChangeWeapon() -- Setup the weapon
					self.WeaponInventory.Primary = wep
					if !wep.IsVJBaseWeapon && self.CanChatMessage && IsValid(self:GetCreator()) then
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
					if IsValid(self:GetCreator()) && self.CanChatMessage && !self.Weapon_IgnoreSpawnMenu then
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
				local idleFunc = self.MaintainIdleAnimation
				if #self:GetBoneFollowers() > 0 then
					hook.Add("Think", self, function()
						if VJ_CVAR_AI_ENABLED then
							idleFunc(self)
						end
						self:UpdateBoneFollowers()
					end)
				else
					hook.Add("Think", self, function()
						if VJ_CVAR_AI_ENABLED then
							idleFunc(self)
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
			if !self.Weapon_Disabled && self.Weapon_CanMoveFire then self:CapabilitiesAdd(CAP_MOVE_SHOOT) end
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
	local moveType = self.MovementType; if moveType == VJ_MOVETYPE_AERIAL or moveType == VJ_MOVETYPE_AQUATIC then self:AA_ChaseEnemy() return end
	if self.CurrentScheduleName == "SCHEDULE_ALERT_CHASE" then return end // && (self:GetEnemyLastKnownPos():Distance(self:GetEnemy():GetPos()) <= 12)
	local navType = self:GetNavType(); if navType == NAV_JUMP or navType == NAV_CLIMB then return end
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
	local curTime = CurTime()
	local selfData = self:GetTable()
	if selfData.NextChaseTime > curTime or selfData.Dead or selfData.VJ_IsBeingControlled or selfData.Flinching or self:GetState() == VJ_STATE_ONLY_ANIMATION_CONSTANT then return end
	local ene = self:GetEnemy()
	local moveType = selfData.MovementType
	if !IsValid(ene) or selfData.TakingCoverT > curTime or (selfData.AttackAnimTime > curTime && moveType != VJ_MOVETYPE_AERIAL && moveType != VJ_MOVETYPE_AQUATIC) then return end
	
	-- Not melee attacking yet but it is in range, so don't chase the enemy!
	local eneData = selfData.EnemyData
	if selfData.HasMeleeAttack && eneData.DistanceNearest < selfData.MeleeAttackDistance && eneData.Visible && (self:GetHeadDirection():Dot((ene:GetPos() - self:GetPos()):GetNormalized()) > math_cos(math_rad(selfData.MeleeAttackAngleRadius))) then
		if moveType == VJ_MOVETYPE_AERIAL or moveType == VJ_MOVETYPE_AQUATIC then
			self:AA_StopMoving()
		end
		self:SCHEDULE_IDLE_STAND()
		return
	end
	
	-- Things that override can't bypass, Forces the NPC to ONLY idle stand!
	if moveType == VJ_MOVETYPE_STATIONARY or selfData.IsFollowing or selfData.MedicData.Status or self:GetState() == VJ_STATE_ONLY_ANIMATION then
		self:SCHEDULE_IDLE_STAND()
		return
	end
	
	-- Non-aggressive NPCs
	local behaviorType = selfData.Behavior
	if behaviorType == VJ_BEHAVIOR_PASSIVE or behaviorType == VJ_BEHAVIOR_PASSIVE_NATURE then
		self:SCHEDULE_COVER_ENEMY("TASK_RUN_PATH")
		selfData.NextChaseTime = curTime + 3
		return
	end
	
	if !alwaysChase && (selfData.DisableChasingEnemy or selfData.IsGuard) then self:SCHEDULE_IDLE_STAND() return end
	
	-- If the enemy is not reachable
	if (funcHasCondition(self, COND_ENEMY_UNREACHABLE) or self:IsUnreachable(ene)) && (IsValid(self:GetActiveWeapon()) && (!self:GetActiveWeapon().IsMeleeWeapon)) then
		self:SCHEDULE_ALERT_CHASE(true)
		self:RememberUnreachable(ene, 2)
	else -- Is reachable, so chase the enemy!
		self:SCHEDULE_ALERT_CHASE(false)
	end
	
	-- Set the next chase time
	if selfData.NextChaseTime > curTime then return end -- Don't set it if it's already set!
	selfData.NextChaseTime = curTime + (((eneData.Distance > 2000) and 1) or 0.1) -- If the enemy is far, increase the delay!
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
	local selfData = self:GetTable()
	-- Handle idle scared and angry animations
	if act == ACT_IDLE then
		if selfData.Weapon_UnarmedBehavior_Active then
			//return PICK(selfData.AnimTbl_ScaredBehaviorStand)
			return ACT_COWER
		elseif selfData.Alerted && self:GetWeaponState() != VJ.WEP_STATE_HOLSTERED && IsValid(self:GetActiveWeapon()) then
			//return PICK(selfData.AnimTbl_WeaponAim)
			return ACT_IDLE_ANGRY
		end
	-- Handle running while scared animation
	elseif act == ACT_RUN && selfData.Weapon_UnarmedBehavior_Active && !selfData.VJ_IsBeingControlled then
		// PICK(selfData.AnimTbl_ScaredBehaviorMovement)
		return ACT_RUN_PROTECTED
	elseif (act == ACT_RUN or act == ACT_WALK) && selfData.Alerted then
		-- Handle aiming while moving animations
		if selfData.Weapon_CanMoveFire && IsValid(self:GetEnemy()) && (selfData.EnemyData.Visible or (selfData.EnemyData.VisibleTime + 5) > CurTime()) && selfData.CurrentSchedule && selfData.CurrentSchedule.CanShootWhenMoving && self:CanFireWeapon(true, false) then
			local anim = self:TranslateActivity(act == ACT_RUN and ACT_RUN_AIM or ACT_WALK_AIM)
			if VJ.AnimExists(self, anim) then
				if selfData.EnemyData.Visible then
					selfData.WeaponAttackState = VJ.WEP_ATTACK_STATE_FIRE
				else -- Not visible but keep aiming
					selfData.WeaponAttackState = VJ.WEP_ATTACK_STATE_AIM_MOVE
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
	local translation = selfData.AnimationTranslations[act]
	if translation then
		if istable(translation) then
			if act == ACT_IDLE then
				return self:ResolveAnimation(translation)
			end
			return translation[math.random(1, #translation)] or act -- "or act" = To make sure it doesn't return nil when the table is empty!
		end
		return translation
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
	if self.Weapon_Disabled && IsValid(curWep) then
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
		timer.Create("wep_state_reset" .. self:EntIndex(), time, 1, function()
			self:SetWeaponState()
		end)
	else
		timer.Remove("wep_state_reset" .. self:EntIndex())
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetWeaponState()
	return self.WeaponState
end
---------------------------------------------------------------------------------------------------------------------------------------------
local attackTimers = {
	[VJ.ATTACK_TYPE_MELEE] = function(self, skipStopAttacks)
		if !skipStopAttacks then
			timer.Create("attack_melee_reset" .. self:EntIndex(), self:GetAttackTimer(self.NextAnyAttackTime_Melee, self.TimeUntilMeleeAttackDamage, self.AttackAnimDuration), 1, function()
				self:StopAttacks()
				self:MaintainAlertBehavior()
			end)
		end
		timer.Create("attack_melee_reset_able" .. self:EntIndex(), self:GetAttackTimer(self.NextMeleeAttackTime), 1, function()
			self.IsAbleToMeleeAttack = true
		end)
	end,
	[VJ.ATTACK_TYPE_GRENADE] = function(self, skipStopAttacks)
		if !skipStopAttacks then
			timer.Create("attack_grenade_reset" .. self:EntIndex(), self:GetAttackTimer(self.NextAnyAttackTime_Grenade, self.GrenadeAttackThrowTime, self.AttackAnimDuration), 1, function()
				self:StopAttacks()
				self:MaintainAlertBehavior()
			end)
		end
		//timer.Create("attack_grenade_reset_able" .. self:EntIndex(), self:GetAttackTimer(self.NextGrenadeAttackTime), 1, function()
			//self.IsAbleToGrenadeAttack = true
		//end)
		self.NextThrowGrenadeT = CurTime() + self:GetAttackTimer(self.NextGrenadeAttackTime)
	end
}
---------------------------------------------------------------------------------------------------------------------------------------------
local function playReloadAnimation(self, anims)
	local anim, animDur, animType = self:PlayAnim(anims, true, false, "Visible")
	if anim != ACT_INVALID then
		local wep = self.WeaponEntity
		if wep.IsVJBaseWeapon then wep:NPC_Reload() end
		timer.Create("wep_reload_reset" .. self:EntIndex(), animDur, 1, function()
			if IsValid(self) && IsValid(wep) && self:GetWeaponState() == VJ.WEP_STATE_RELOADING then
				wep:SetClip1(wep:GetMaxClip1())
				if wep.IsVJBaseWeapon then wep:OnReload("Finish") end
				self:SetWeaponState()
			end
		end)
		self.AllowWeaponOcclusionDelay = false
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
	local selfData = self:GetTable()
	
	-- This is here to make sure the initialized process time stays in place...
	-- otherwise if AI is disabled then reenabled, all the NPCs will now start processing at the same exact CurTime!
	local doHeavyProcesses = curTime > selfData.NextProcessT
	if doHeavyProcesses then
		selfData.NextProcessT = curTime + selfData.NextProcessTime
	end
	
	if !selfData.Dead then
		-- Detect any weapon change, unless the NPC is dead because the variable is used by self:DeathWeaponDrop()
		if selfData.WeaponEntity != self:GetActiveWeapon() then
			selfData.WeaponEntity = self:DoChangeWeapon()
		end
		
		-- Breath sound system
		if selfData.HasBreathSound && selfData.HasSounds && curTime > selfData.NextBreathSoundT then
			local pickedSD = PICK(selfData.SoundTbl_Breath)
			local dur = 10 -- Make the default value large so we don't check it too much!
			if pickedSD then
				StopSD(selfData.CurrentBreathSound)
				dur = (selfData.NextSoundTime_Breath == false and SoundDuration(pickedSD)) or math.Rand(selfData.NextSoundTime_Breath.a, selfData.NextSoundTime_Breath.b)
				selfData.CurrentBreathSound = VJ.CreateSound(self, pickedSD, selfData.BreathSoundLevel, self:GetSoundPitch(selfData.BreathSoundPitch))
			end
			selfData.NextBreathSoundT = curTime + dur
		end
	end
	
	self:OnThink()
	--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
	if VJ_CVAR_AI_ENABLED && self:GetState() != VJ_STATE_FREEZE && !self:IsEFlagSet(EFL_IS_BEING_LIFTED_BY_BARNACLE) then
		if selfData.VJ_DEBUG then
			if GetConVar("vj_npc_debug_enemy"):GetInt() == 1 then VJ.DEBUG_Print(self, false, "Enemy -> " .. tostring(self:GetEnemy() or "NULL") .. " | Alerted? " .. tostring(selfData.Alerted))  end
			if GetConVar("vj_npc_debug_takingcover"):GetInt() == 1 then if curTime > selfData.TakingCoverT then VJ.DEBUG_Print(self, false, "NOT taking cover") else VJ.DEBUG_Print(self, false, "Taking cover ("..selfData.TakingCoverT - curTime..")") end end
			if GetConVar("vj_npc_debug_lastseenenemytime"):GetInt() == 1 then PrintMessage(HUD_PRINTTALK, (curTime - selfData.EnemyData.VisibleTime).." ("..self:GetName()..")") end
			if IsValid(selfData.WeaponEntity) && GetConVar("vj_npc_debug_weapon"):GetInt() == 1 then VJ.DEBUG_Print(self, false, " : Weapon -> " .. tostring(selfData.WeaponEntity) .. " | Ammo: "..selfData.WeaponEntity:Clip1().." / "..selfData.WeaponEntity:GetMaxClip1().." | Accuracy: "..selfData.Weapon_Accuracy) end
		end
		
		//self:SetPlaybackRate(self.AnimationPlaybackRate)
		self:OnThinkActive()
		
		-- Update follow system's data
		//print("------------------")
		//PrintTable(selfData.FollowData)
		if selfData.IsFollowing && self:GetNavType() != NAV_JUMP && self:GetNavType() != NAV_CLIMB then
			local followData = selfData.FollowData
			local followEnt = followData.Target
			local followIsLiving = followEnt.VJ_ID_Living
			//print(self:GetTarget())
			if IsValid(followEnt) && (!followIsLiving or (followIsLiving && (self:Disposition(followEnt) == D_LI or self:GetClass() == followEnt:GetClass()) && followEnt:Alive())) then
				if curTime > followData.NextUpdateT && !selfData.VJ_ST_Healing then
					local distToPly = self:GetPos():Distance(followEnt:GetPos())
					local busy = self:IsBusy("Activities")
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
							if selfData.MovementType == VJ_MOVETYPE_AERIAL or selfData.MovementType == VJ_MOVETYPE_AQUATIC then
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
									schedule.TurnData = {Type = VJ.FACE_ENEMY_VISIBLE}
								end
								self:StartSchedule(schedule)
								//else
								//	self:ClearGoal()
								//end
								/*self:SCHEDULE_GOTO_TARGET((distToPly < (followData.MinDist * 1.5) and "TASK_WALK_PATH") or "TASK_RUN_PATH", function(schedule)
									schedule.CanShootWhenMoving = true
									if IsValid(self:GetActiveWeapon()) then
										schedule.TurnData = {Type = VJ.FACE_ENEMY_VISIBLE}
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
					followData.NextUpdateT = curTime + 0.5
				end
			else
				self:ResetFollowBehavior()
			end
		end

		-- Handle main parts of the turning system
		local turnData = selfData.TurnData
		if turnData.Type then
			-- If StopOnFace flag is set AND (Something has requested to take over by checking "ideal yaw != last set yaw") OR (we are facing ideal) then finish it!
			if turnData.StopOnFace && (self:GetIdealYaw() != turnData.LastYaw or self:IsFacingIdealYaw()) then
				self:ResetTurnTarget()
			else
				turnData.LastYaw = 0 -- To make sure the turning maintain works correctly
				local turnTarget = turnData.Target
				if turnData.Type == VJ.FACE_POSITION or (turnData.Type == VJ.FACE_POSITION_VISIBLE && self:VisibleVec(turnTarget)) then
					local resultAng = self:GetTurnAngle((turnTarget - self:GetPos()):Angle())
					if selfData.TurningUseAllAxis then
						local myAng = self:GetAngles()
						self:SetAngles(LerpAngle(FrameTime()*selfData.TurningSpeed, myAng, Angle(resultAng.p, myAng.y, resultAng.r)))
					end
					self:SetIdealYawAndUpdate(resultAng.y)
					turnData.LastYaw = resultAng.y
				elseif IsValid(turnTarget) && (turnData.Type == VJ.FACE_ENTITY or (turnData.Type == VJ.FACE_ENTITY_VISIBLE && self:Visible(turnTarget))) then
					local resultAng = self:GetTurnAngle((turnTarget:GetPos() - self:GetPos()):Angle())
					if selfData.TurningUseAllAxis then
						local myAng = self:GetAngles()
						self:SetAngles(LerpAngle(FrameTime()*selfData.TurningSpeed, myAng, Angle(resultAng.p, myAng.y, resultAng.r)))
					end
					self:SetIdealYawAndUpdate(resultAng.y)
					turnData.LastYaw = resultAng.y
				end
			end
		end
		
		//print("MAX CLIP: ", selfData.WeaponEntity:GetMaxClip1())
		//print("CLIP: ", selfData.WeaponEntity:Clip1())
			
		if !selfData.Dead then
			-- Health Regeneration System
			local healthRegen = selfData.HealthRegenParams
			if healthRegen.Enabled && curTime > selfData.HealthRegenDelayT then
				local myHP = self:Health()
				self:SetHealth(math_min(math_max(myHP + healthRegen.Amount, myHP), self:GetMaxHealth()))
				selfData.HealthRegenDelayT = curTime + math.Rand(healthRegen.Delay.a, healthRegen.Delay.b)
			end
			
			-- Run the heavy processes
			if doHeavyProcesses then
				self:MaintainRelationships()
				self:CheckForDangers()
				if selfData.IsMedic then self:MaintainMedicBehavior() end
				//selfData.NextProcessT = curTime + selfData.NextProcessTime
			end
			
			local plyControlled = selfData.VJ_IsBeingControlled
			local myPos = self:GetPos()
			local ene = self:GetEnemy()
			local eneValid = IsValid(ene)
			local eneData = selfData.EnemyData
			if !eneData.Reset then
				-- Reset enemy if it doesn't exist or it's dead
				if !eneValid then
					self:ResetEnemy(true, true)
					ene = self:GetEnemy()
					eneValid = IsValid(ene)
				-- Reset enemy if it has been unseen for a while
				elseif (curTime - eneData.VisibleTime) > ((eneData.Distance < 4000 and selfData.EnemyTimeout) or (selfData.EnemyTimeout / 2)) && !selfData.IsVJBaseSNPC_Tank then
					self:PlaySoundSystem("LostEnemy")
					self:ResetEnemy(true, true)
					ene = self:GetEnemy()
					eneValid = IsValid(ene)
				end
			end
			
			local curWep = selfData.WeaponEntity
			//if selfData.WeaponAttackState then self:CapabilitiesRemove(CAP_TURN_HEAD) else self:CapabilitiesAdd(CAP_TURN_HEAD) end -- Fixes their heads breaking
			-- If we have a valid weapon...
			if IsValid(curWep) && !self:IsBusy("Activities") then
				-- Weapon Inventory System
				if !plyControlled then
					if eneValid then
						-- Switch to melee
						if !selfData.IsGuard && IsValid(selfData.WeaponInventory.Melee) && ((eneData.Distance < selfData.MeleeAttackDistance) or (eneData.Distance < 300 && curWep:Clip1() <= 0)) && (self:Health() > self:GetMaxHealth() * 0.25) && curWep != selfData.WeaponInventory.Melee then
							if self:GetWeaponState() == VJ.WEP_STATE_RELOADING then self:SetWeaponState() end -- Since the reloading can be cut off, reset it back to false, or else it can mess up its behavior!
							//timer.Remove("wep_reload_reset" .. self:EntIndex()) -- No longer needed
							selfData.WeaponInventoryStatus = VJ.WEP_INVENTORY_MELEE
							self:DoChangeWeapon(selfData.WeaponInventory.Melee, true)
							curWep = selfData.WeaponEntity
						-- Switch to anti-armor
						elseif self:GetWeaponState() != VJ.WEP_STATE_RELOADING && IsValid(selfData.WeaponInventory.AntiArmor) && (ene.IsVJBaseSNPC_Tank or ene.VJ_ID_Boss) && curWep != selfData.WeaponInventory.AntiArmor then
							selfData.WeaponInventoryStatus = VJ.WEP_INVENTORY_ANTI_ARMOR
							self:DoChangeWeapon(selfData.WeaponInventory.AntiArmor, true)
							curWep = selfData.WeaponEntity
						end
					end
					if self:GetWeaponState() != VJ.WEP_STATE_RELOADING then
						-- Reset weapon status from melee to primary
						if selfData.WeaponInventoryStatus == VJ.WEP_INVENTORY_MELEE && (!eneValid or (eneValid && eneData.Distance >= 300)) then
							selfData.WeaponInventoryStatus = VJ.WEP_INVENTORY_PRIMARY
							self:DoChangeWeapon(selfData.WeaponInventory.Primary, true)
							curWep = selfData.WeaponEntity
						-- Reset weapon status from anti-armor to primary
						elseif selfData.WeaponInventoryStatus == VJ.WEP_INVENTORY_ANTI_ARMOR && (!eneValid or (eneValid && !ene.IsVJBaseSNPC_Tank && !ene.VJ_ID_Boss)) then
							selfData.WeaponInventoryStatus = VJ.WEP_INVENTORY_PRIMARY
							self:DoChangeWeapon(selfData.WeaponInventory.Primary, true)
							curWep = selfData.WeaponEntity
						end
					end
				end
				
				-- Weapon Reloading
				if selfData.Weapon_CanReload && !selfData.AttackType && !curWep.IsMeleeWeapon && self:GetWeaponState() == VJ.WEP_STATE_READY && ((!plyControlled && ((!eneValid && curWep:GetMaxClip1() > curWep:Clip1() && (curTime - eneData.TimeSet) > math.random(3, 8) && !self:IsMoving()) or (eneValid && curWep:Clip1() <= 0))) or (plyControlled && selfData.VJ_TheController:KeyDown(IN_RELOAD) && curWep:GetMaxClip1() > curWep:Clip1())) then
					selfData.WeaponAttackState = VJ.WEP_ATTACK_STATE_NONE
					selfData.NextChaseTime = curTime + 2
					if !plyControlled then self:SetWeaponState(VJ.WEP_STATE_RELOADING) end
					if eneValid then self:PlaySoundSystem("WeaponReload") end -- tsayn han e minag yete teshnami ga!
					self:OnWeaponReload()
					if selfData.DisableWeaponReloadAnimation then -- Reload animation is disabled
						if self:GetWeaponState() == VJ.WEP_STATE_RELOADING then self:SetWeaponState() end
						curWep:SetClip1(curWep:GetMaxClip1())
						if curWep.IsVJBaseWeapon then curWep:NPC_Reload() end
					else
						-- Controlled by a player...
						if plyControlled then
							self:SetWeaponState(VJ.WEP_STATE_RELOADING)
							playReloadAnimation(self, self:TranslateActivity(PICK(selfData.AnimTbl_WeaponReload)))
						-- NOT controlled by a player...
						else
							-- NPC is hidden, so attempt to crouch reload
							if eneValid && self:DoCoverTrace(myPos + self:OBBCenter(), ene:EyePos(), false, {SetLastHiddenTime = true}) then
								-- if It does NOT have a cover reload animation, then just play the regular standing reload animation
								if !playReloadAnimation(self, self:TranslateActivity(PICK(selfData.AnimTbl_WeaponReloadCovered))) then
									playReloadAnimation(self, self:TranslateActivity(PICK(selfData.AnimTbl_WeaponReload)))
								end
							-- NPC is NOT hidden...
							else
								-- Under certain situations, simply do standing reload without running to a hiding spot
								if !selfData.Weapon_FindCoverOnReload or selfData.IsGuard or selfData.IsFollowing or selfData.VJ_IsBeingControlled_Tool or !eneValid or selfData.MovementType == VJ_MOVETYPE_STATIONARY or eneData.Distance < 650 then
									playReloadAnimation(self, self:TranslateActivity(PICK(selfData.AnimTbl_WeaponReload)))
								else -- If all is good, then run to a hiding spot and reload!
									local schedule = vj_ai_schedule.New("SCHEDULE_COVER_RELOAD")
									schedule:EngTask("TASK_FIND_COVER_FROM_ENEMY", 0)
									schedule:EngTask("TASK_RUN_PATH", 0)
									schedule:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
									schedule.RunCode_OnFinish = function()
										if self:GetWeaponState() == VJ.WEP_STATE_RELOADING then
											-- If the current situation isn't favorable, then abandon the current reload, and try again!
											if self.AttackType or (IsValid(self:GetEnemy()) && eneData.Distance <= self.Weapon_RetreatDistance) then
												self:SetWeaponState()
												//timer.Remove("wep_reload_reset" .. self:EntIndex()) -- Remove the timer to make sure it doesn't set reloading to false at a random time (later on)
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
				eneData.Visible = eneIsVisible
				eneData.Distance = eneDist
				eneData.DistanceNearest = eneDistNear
				local firingWep = selfData.WeaponAttackState && selfData.WeaponAttackState >= VJ.WEP_ATTACK_STATE_FIRE
				if eneIsVisible then
					if self:IsInViewCone(enePos) && (eneDist < self:GetMaxLookDistance()) then
						eneData.VisibleTime = curTime
						-- Why 2 vars? Because the last "Visible" tick is usually not updated in time, causing the engine to give false positive, thinking the enemy IS visible
						eneData.VisiblePos = eneData.VisiblePosReal
						eneData.VisiblePosReal = ene:EyePos() -- Use EyePos because "Visible" uses it to run the trace in the engine! | For origin, use "self:GetEnemyLastSeenPos()"
					end
					if firingWep then self:PlaySoundSystem("Suppressing") end
				elseif firingWep then
					selfData.WeaponAttackState = VJ.WEP_ATTACK_STATE_NONE
				end
				
				-- Turning / Facing Enemy
				if selfData.ConstantlyFaceEnemy then self:MaintainConstantlyFaceEnemy() end
				if turnData.Type == VJ.FACE_ENEMY or (turnData.Type == VJ.FACE_ENEMY_VISIBLE && eneIsVisible) then
					local resultAng = self:GetTurnAngle((enePos - myPos):Angle())
					if selfData.TurningUseAllAxis then
						local myAng = self:GetAngles()
						self:SetAngles(LerpAngle(FrameTime()*selfData.TurningSpeed, myAng, Angle(resultAng.p, myAng.y, resultAng.r)))
					end
					self:SetIdealYawAndUpdate(resultAng.y)
					turnData.LastYaw = resultAng.y
				end

				-- Call for help
				if selfData.CallForHelp && curTime > selfData.NextCallForHelpT && !selfData.AttackType then
					self:Allies_CallHelp(selfData.CallForHelpDistance)
					selfData.NextCallForHelpT = curTime + selfData.CallForHelpCooldown
				end
				
				self:UpdatePoseParamTracking()
				
				-- Attacks
				if !selfData.PauseAttacks && !selfData.Flinching && !selfData.FollowData.StopAct && curTime > selfData.NextDoAnyAttackT && self:GetState() != VJ_STATE_ONLY_ANIMATION_NOATTACK && selfData.Behavior != VJ_BEHAVIOR_PASSIVE && selfData.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE then
					-- Attack priority in order: Custom --> Melee --> Grenade
					local funcThinkAtk = self.OnThinkAttack; if funcThinkAtk then funcThinkAtk(self, !!selfData.AttackType, ene) end
					
					-- Melee Attack
					if selfData.HasMeleeAttack && selfData.IsAbleToMeleeAttack && !selfData.AttackType && (!IsValid(curWep) or (IsValid(curWep) && (!curWep.IsMeleeWeapon))) && ((plyControlled && selfData.VJ_TheController:KeyDown(IN_ATTACK)) or (!plyControlled && (eneDistNear < selfData.MeleeAttackDistance && eneIsVisible) && (self:GetHeadDirection():Dot((enePos - myPos):GetNormalized()) > math_cos(math_rad(selfData.MeleeAttackAngleRadius))))) then
						local seed = curTime; selfData.AttackSeed = seed
						selfData.IsAbleToMeleeAttack = false
						selfData.AttackType = VJ.ATTACK_TYPE_MELEE
						selfData.AttackState = VJ.ATTACK_STATE_STARTED
						selfData.AttackAnim = ACT_INVALID
						selfData.AttackAnimDuration = 0
						selfData.AttackAnimTime = 0
						self:SetTurnTarget("Enemy") -- Always turn towards the enemy at the start
						self:OnMeleeAttack("Init", ene)
						self:PlaySoundSystem("BeforeMeleeAttack")
						selfData.NextAlertSoundT = curTime + 0.4
						if selfData.AnimTbl_MeleeAttack then
							local anim, animDur, animType = self:PlayAnim(selfData.AnimTbl_MeleeAttack, false, 0, false)
							if anim != ACT_INVALID then
								selfData.AttackAnim = anim
								selfData.AttackAnimDuration = animDur - (selfData.MeleeAttackAnimationDecreaseLengthAmount / selfData.AnimPlaybackRate)
								if animType != ANIM_TYPE_GESTURE then -- Allow things like chasing to continue for gestures
									selfData.AttackAnimTime = curTime + selfData.AttackAnimDuration
								end
							end
						end
						if !selfData.TimeUntilMeleeAttackDamage then
							attackTimers[VJ.ATTACK_TYPE_MELEE](self)
						else -- NOT event based...
							timer.Create("attack_melee_start" .. self:EntIndex(), selfData.TimeUntilMeleeAttackDamage / selfData.AnimPlaybackRate, selfData.MeleeAttackReps, function() if selfData.AttackSeed == seed then self:ExecuteMeleeAttack() end end)
							if selfData.MeleeAttackExtraTimers then
								for k, t in ipairs(selfData.MeleeAttackExtraTimers) do
									self:AddExtraAttackTimer("attack_melee_start"..curTime + k, t, function() if selfData.AttackSeed == seed then self:ExecuteMeleeAttack() end end)
								end
							end
						end
						self:OnMeleeAttack("PostInit", ene)
					end
					
					-- Grenade attack
					if selfData.HasGrenadeAttack && curTime > selfData.NextThrowGrenadeT && curTime > selfData.TakingCoverT && self:GetWeaponState() != VJ.WEP_STATE_RELOADING && !self:IsBusy("Activities") then
						if plyControlled then
							if selfData.VJ_TheController:KeyDown(IN_JUMP) then
								self:GrenadeAttack()
								selfData.NextThrowGrenadeT = curTime + self:GetAttackTimer(selfData.NextGrenadeAttackTime)
							end
						else
							local chance = selfData.GrenadeAttackChance
							-- If chance is above 4, then half it by 2 if the enemy is a tank OR not visible
							if math.random(1, (chance > 3 && (ene.IsVJBaseSNPC_Tank or !eneIsVisible) and math.floor(chance / 2)) or chance) == 1 && eneDist < selfData.GrenadeAttackMaxDistance && eneDist > selfData.GrenadeAttackMinDistance then
								self:GrenadeAttack()
							end
							selfData.NextThrowGrenadeT = curTime + self:GetAttackTimer(selfData.NextGrenadeAttackTime)
						end
					end
				end
				
				-- Face enemy for stationary types OR attacks
				if (selfData.MovementType == VJ_MOVETYPE_STATIONARY && selfData.CanTurnWhileStationary) or (selfData.AttackType && ((selfData.MeleeAttackAnimationFaceEnemy && selfData.AttackType == VJ.ATTACK_TYPE_MELEE) or (selfData.GrenadeAttackAnimationFaceEnemy && selfData.AttackType == VJ.ATTACK_TYPE_GRENADE && eneIsVisible))) then
					self:SetTurnTarget("Enemy")
				end
			else -- No Enemy
				selfData.WeaponAttackState = VJ.WEP_ATTACK_STATE_NONE
				if !selfData.Alerted && selfData.UpdatedPoseParam && !plyControlled then
					self:ClearPoseParameters()
					selfData.UpdatedPoseParam = false
				end
				eneData.TimeAcquired = 0
			end
			
			-- Guarding Behavior
			if selfData.IsGuard && !selfData.IsFollowing then
				local guardData = selfData.GuardData
				if !guardData.Position then -- If we don't have a position, then set it!
					guardData.Position = myPos
					guardData.Direction = myPos + self:GetForward() * 51
				end
				-- If it's far from the guarding position, then go there!
				if !self:IsMoving() && !self:IsBusy("Activities") then
					local dist = myPos:Distance(guardData.Position) -- Distance to the guard position
					if dist > 50 then
						self:SetLastPosition(guardData.Position)
						self:SCHEDULE_GOTO_POSITION(dist <= 800 and "TASK_WALK_PATH" or "TASK_RUN_PATH", function(x)
							x.CanShootWhenMoving = true
							x.TurnData = {Type = VJ.FACE_ENEMY}
							x.RunCode_OnFinish = function()
								timer.Simple(0.01, function()
									if IsValid(self) && !self:IsMoving() && !self:IsBusy("Activities") && selfData.IsGuard && guardData.Position then
										self:SetLastPosition(guardData.Direction)
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
		if selfData.UsePoseParameterMovement && selfData.MovementType == VJ_MOVETYPE_GROUND then
			local moveDir = VJ.GetMoveDirection(self, true)
			if moveDir then
				funcSetPoseParameter(self, "move_x", moveDir.x)
				funcSetPoseParameter(self, "move_y", moveDir.y)
			else -- I am not moving, reset the pose parameters, otherwise I will run in place!
				funcSetPoseParameter(self, "move_x", 0)
				funcSetPoseParameter(self, "move_y", 0)
			end
		end
	else -- AI Not enabled
		selfData.WeaponAttackState = VJ.WEP_ATTACK_STATE_NONE
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
function ENT:ExecuteMeleeAttack()
	local selfData = self:GetTable()
	if selfData.Dead or selfData.PauseAttacks or selfData.Flinching or selfData.AttackType == VJ.ATTACK_TYPE_GRENADE or (selfData.MeleeAttackStopOnHit && selfData.AttackState == VJ.ATTACK_STATE_EXECUTED_HIT) then return end
	self:CustomOnMeleeAttack_BeforeChecks()
	if selfData.DisableDefaultMeleeAttackCode then return end
	local myPos = self:GetPos()
	local myClass = self:GetClass()
	local hitRegistered = false
	for _, ent in ipairs(ents.FindInSphere(self:MeleeAttackTraceOrigin(), selfData.MeleeAttackDamageDistance)) do
		if ent == self or ent:GetClass() == myClass or (ent.IsVJBaseBullseye && ent.VJ_IsBeingControlled) then continue end
		if ent:IsPlayer() && (ent.VJ_IsControllingNPC or !ent:Alive() or VJ_CVAR_IGNOREPLAYERS) then continue end
		if ((ent.VJ_ID_Living && self:Disposition(ent) != D_LI) or ent.VJ_ID_Attackable or ent.VJ_ID_Destructible) && self:GetHeadDirection():Dot((Vector(ent:GetPos().x, ent:GetPos().y, 0) - Vector(myPos.x, myPos.y, 0)):GetNormalized()) > math_cos(math_rad(selfData.MeleeAttackDamageAngleRadius)) then
			local isProp = ent.VJ_ID_Attackable
			if self:CustomOnMeleeAttack_AfterChecks(ent, isProp) == true then continue end
			local dmgAmount = self:ScaleByDifficulty(selfData.MeleeAttackDamage)
			-- Knockback (Don't push things like doors, trains, elevators as it will make them fly when activated)
			if selfData.HasMeleeAttackKnockBack && ent:GetMoveType() != MOVETYPE_PUSH && ent.MovementType != VJ_MOVETYPE_STATIONARY && (!ent.VJ_ID_Boss or ent.IsVJBaseSNPC_Tank) then
				ent:SetGroundEntity(NULL)
				ent:SetVelocity(self:MeleeAttackKnockbackVelocity(ent))
			end
			-- Apply actual damage
			if !selfData.DisableDefaultMeleeAttackDamageCode then
				local applyDmg = DamageInfo()
				applyDmg:SetDamage(dmgAmount)
				applyDmg:SetDamageType(selfData.MeleeAttackDamageType)
				if ent.VJ_ID_Living then applyDmg:SetDamageForce(self:GetForward() * ((applyDmg:GetDamage() + 100) * 70)) end
				applyDmg:SetInflictor(self)
				applyDmg:SetAttacker(self)
				VJ.DamageSpecialEnts(self, ent, applyDmg)
				ent:TakeDamageInfo(applyDmg, self)
			end
			if ent:IsPlayer() then
				ent:ViewPunch(Angle(math.random(-1, 1) * dmgAmount, math.random(-1, 1) * dmgAmount, math.random(-1, 1) * dmgAmount))
			end
			if !isProp then -- Only for non-props...
				hitRegistered = true
				if selfData.MeleeAttackStopOnHit then break end
			end
		end
	end
	if selfData.AttackState < VJ.ATTACK_STATE_EXECUTED then
		selfData.AttackState = VJ.ATTACK_STATE_EXECUTED
		if selfData.TimeUntilMeleeAttackDamage then
			attackTimers[VJ.ATTACK_TYPE_MELEE](self)
		end
	end
	if hitRegistered then
		self:PlaySoundSystem("MeleeAttack")
		selfData.AttackState = VJ.ATTACK_STATE_EXECUTED_HIT
	else
		self:CustomOnMeleeAttack_Miss()
		self:PlaySoundSystem("MeleeAttackMiss")
	end
end

---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Triggers a grenade attack
		- customEnt = What entity it should throw | DEFAULT: nil
			- nil = Spawn the NPC's default grenade class usually set by "self.GrenadeAttackEntity"
			- string = Override to use given entity class
			- entity = Override to use the given entity as the grenade by changing its parent to the NPC and altering its position
		- disableOwner = If true, the NPC will not be set as the owner of the grenade, allowing it to damage itself and its allies when applicable!
	Returns
		- [boolean] = Whether or not it successfully triggered the attack
-----------------------------------------------------------]]
function ENT:GrenadeAttack(customEnt, disableOwner)
	if self.Dead or self.Flinching or self.AttackType == VJ.ATTACK_TYPE_MELEE then return false end
	local eneData = self.EnemyData
	local ene = self:GetEnemy()
	local isLiveEnt = IsValid(customEnt)
	local landDir = "FindBest"

	-- Handle possible destinations:
		-- Enemy not valid --> Best position away from the NPC and allies
		-- Enemy valid AND Enemy visible --> Enemy's position
		-- Enemy valid AND Enemy not visible AND last seen position is visible --> Enemy's last visible position
		-- Enemy valid AND Enemy not visible AND last seen position is not visible --> Cancel attack
		-- Enemy valid AND Enemy not visible AND last seen position is not visible AND grenade is live throw back --> Best position away from the NPC and allies
	if IsValid(ene) then
		-- If enemy is visible then face them!
		if eneData.Visible then
			landDir = "Enemy" -- Do NOT face random pos, even if "self.GrenadeAttackAnimationFaceEnemy" is disabled!
		else -- We have a hidden enemy...
			-- Attempt to flush the enemy out of hiding
			if self:VisibleVec(eneData.VisiblePos) && ene:GetPos():Distance(eneData.VisiblePos) <= self.GrenadeAttackMaxDistance then // self.GrenadeAttackMaxDistance
				landDir = "EnemyLastVis" -- We are going to face flush position, do NOT face random pos!
			-- If can't flush the enemy, then face random open position ONLY if we are given a live entity, otherwise...
			-- If live entity is NOT given and it's allowed to continue, it will cause the NPC to throw a grenade when both the enemy and its flush position are hidden!
			elseif !isLiveEnt then
				return false
			end
		end
	end
	
	if self:OnGrenadeAttack("Init", customEnt) then return false end
	local seed = CurTime(); self.AttackSeed = seed
	
	-- Handle animations
	self.AttackAnim = ACT_INVALID
	self.AttackAnimDuration = 0
	self.AttackAnimTime = 0
	if self.AnimTbl_GrenadeAttack then
		local anim, animDur = self:PlayAnim(self.AnimTbl_GrenadeAttack, false, 0, false)
		if anim != ACT_INVALID then
			self.AttackAnim = anim
			self.AttackAnimDuration = animDur
			self.AttackAnimTime = seed + self.AttackAnimDuration
		end
	end
	
	if landDir == "Enemy" then -- Face enemy
		if self.GrenadeAttackAnimationFaceEnemy then
			self:SetTurnTarget("Enemy")
		end
	elseif landDir == "EnemyLastVis" then -- Face enemy's last visible pos
		self:SetTurnTarget(eneData.VisiblePos, self.AttackAnimDuration or 1.5)
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
		local customPos = self:OnGrenadeAttack("SpawnPos", customEnt, landDir)
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
	self:PlaySoundSystem("GrenadeAttack")
	
	local releaseTime = self.GrenadeAttackThrowTime
	if !releaseTime then -- Call this right away for event-based attacks!
		attackTimers[VJ.ATTACK_TYPE_GRENADE](self)
	end
	-- "attack_grenade_start" is still called on event-based attacks unlike other attacks because we need to retain the data (customEnt, disableOwner, landDir)...
	-- ...But the timer will be based off of "attack_grenade_reset" to be used as a fail safe in case the animation is cut off!
	-- Call "timer.Adjust("attack_grenade_start" .. self:EntIndex(), 0)" in the event code to make it throw the grenade
	timer.Create("attack_grenade_start" .. self:EntIndex(), (!releaseTime and timer.TimeLeft("attack_grenade_reset" .. self:EntIndex())) or releaseTime / self.AnimPlaybackRate, 1, function()
		if self.AttackSeed == seed then
			if isLiveEnt && !IsValid(customEnt) then return end
			self:ExecuteGrenadeAttack(customEnt, disableOwner, landDir)
		end
	end)
	self:OnGrenadeAttack("PostInit", customEnt, landDir)
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
			- "Enemy" = Use enemy's position
			- "EnemyLastVis" = Use enemy's last visible position
			- vector = Use given vector's position
			- "FindBest" or nil = Find a best random position
	Returns
		- false, Grenade attack was canceled
		- entity, Grenade entity that was thrown
-----------------------------------------------------------]]
function ENT:ExecuteGrenadeAttack(customEnt, disableOwner, landDir)
	if self.Dead or self.PauseAttacks or self.Flinching or self.AttackType == VJ.ATTACK_TYPE_MELEE then return false end
	local grenade;
	local isLiveEnt = IsValid(customEnt) -- Whether or not the given custom entity is live
	local fuseTime = self.GrenadeAttackFuseTime
	
	-- Handle the grenade's spawn position and angle, in order with priority:
		-- 1. CUSTOM 		If custom position is given then use that, otherwise...
		-- 2. ATTACHMENT 	If a valid attachment is given then use that, otherwise...
		-- 3. BONE 			If a valid bone is given then use that, otherwise...
		-- 4. FAIL 			Use the NPC's shoot position (fail safe)
	local spawnPos = self:OnGrenadeAttack("SpawnPos", customEnt, landDir)
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
	if landDir == "Enemy" then -- Use enemy's position
		landingPos = self:GetEnemyLastKnownPos()
		//if self.GrenadeAttackAnimationFaceEnemy then self:SetTurnTarget("Enemy") end
	elseif landDir == "EnemyLastVis" then -- Use enemy's last visible position
		local eneData = self.EnemyData
		landingPos = eneData.VisiblePos
		//self:SetTurnTarget(eneData.VisiblePos, self.AttackAnimDuration - self.GrenadeAttackThrowTime)
	elseif isvector(landDir) then -- Use given vector's position
		landingPos = landDir
	else -- Find a best random position | Includes "FindBest"
		local bestPos = PICK(VJ.TraceDirections(self, "Quick", 200, true, false, 8))
		if bestPos then
			landingPos = bestPos
			//self:SetTurnTarget(bestPos, self.AttackAnimDuration - self.GrenadeAttackThrowTime)
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
		
		self:OnGrenadeAttackExecute("PreSpawn", grenade, customEnt, landDir, landingPos)
		grenade:Spawn()
		grenade:Activate()
	end
	
	-- Handle throw velocity
	local postSpawnResult = self:OnGrenadeAttackExecute("PostSpawn", grenade, customEnt, landDir, landingPos)
	if postSpawnResult != true then
		local vel = postSpawnResult or ((landingPos - grenade:GetPos()) + (self:GetUp()*200 + self:GetForward()*500 + self:GetRight()*math.Rand(-20, 20)))
		local phys = grenade:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			phys:AddAngleVelocity(Vector(math.Rand(500, 500), math.Rand(500, 500), math.Rand(500, 500)))
			phys:SetVelocity(vel)
		else -- If we don't have a physics object, then attempt to set the entity's velocity directly
			grenade:SetVelocity(vel)
		end
	end
	
	if self.AttackState < VJ.ATTACK_STATE_EXECUTED then
		self.AttackState = VJ.ATTACK_STATE_EXECUTED
		if self.GrenadeAttackThrowTime then
			attackTimers[VJ.ATTACK_TYPE_GRENADE](self)
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
- NPC Conditions
	- Detected as a danger
	- Distance based on the sound hint's volume/distance
	- Does NOT ignore, is detected by everyone that catches the hint, including allies
	- BEST USE: Sounds that should scare the owner's allies
-----------------------------------------------------------]]
function ENT:CheckForDangers()
	local selfData = self:GetTable()
	if !selfData.CanDetectDangers or selfData.AttackType == VJ.ATTACK_TYPE_GRENADE or selfData.NextDangerDetectionT > CurTime() then return end
	local regDangerDetected = false -- A regular non-grenade danger has been found (This is done to make sure grenades take priority over other dangers!)
	for _, ent in ipairs(ents.FindInSphere(self:GetPos(), selfData.DangerDetectionDistance)) do
		if (ent.VJ_ID_Danger or ent.VJ_ID_Grenade) && self:Visible(ent) then
			local owner = ent:GetOwner()
			if !(IsValid(owner) && owner.IsVJBaseSNPC && ((self:GetClass() == owner:GetClass()) or (self:Disposition(owner) == D_LI))) then
				if ent.VJ_ID_Danger then regDangerDetected = ent continue end -- If it's a regular danger then just skip it for now
				local funcCustom = self.OnDangerDetected; if funcCustom then funcCustom(self, VJ.DANGER_TYPE_GRENADE, ent) end
				local curTime = CurTime()
				if !self:PlaySoundSystem("GrenadeSight") then self:PlaySoundSystem("DangerSight") end -- No grenade sight sounds? See if we have danger sight sounds
				selfData.NextDangerDetectionT = curTime + 4
				selfData.TakingCoverT = curTime + 4
				-- If has the ability to throw it back, then throw the grenade!
				if selfData.CanRedirectGrenades && selfData.HasGrenadeAttack && ent.VJ_ID_Grabbable && !ent.VJ_ST_Grabbed && ent:GetVelocity():Length() < 400 && VJ.GetNearestDistance(self, ent) < 100 && self:GrenadeAttack(ent, true) then
					selfData.NextGrenadeAttackSoundT = curTime + 3
					return
				end
				-- Was not able to throw back the grenade, so take cover instead!
				self:SCHEDULE_COVER_ORIGIN("TASK_RUN_PATH", function(x)
					x.CanShootWhenMoving = true
					x.TurnData = {Type = VJ.FACE_ENEMY}
				end)
				return
			end
		end
	end
	if regDangerDetected or funcHasCondition(self, COND_HEAR_DANGER) or funcHasCondition(self, COND_HEAR_PHYSICS_DANGER) or funcHasCondition(self, COND_HEAR_MOVE_AWAY) then
		local funcCustom = self.OnDangerDetected
		if funcCustom then
			if regDangerDetected then
				funcCustom(self, VJ.DANGER_TYPE_ENTITY, regDangerDetected)
			else
				funcCustom(self, VJ.DANGER_TYPE_HINT, nil)
			end
		end
		self:PlaySoundSystem("DangerSight")
		local curTime = CurTime()
		selfData.NextDangerDetectionT = curTime + 4
		selfData.TakingCoverT = curTime + 4
		self:SCHEDULE_COVER_ORIGIN("TASK_RUN_PATH", function(x)
			x.CanShootWhenMoving = true
			x.TurnData = {Type = VJ.FACE_ENEMY}
		end)
		return
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StopAttacks(checkTimers)
	if !self:Alive() then return end
	local selfData = self:GetTable()
	if selfData.VJ_DEBUG && GetConVar("vj_npc_debug_attack"):GetInt() == 1 then VJ.DEBUG_Print(self, "StopAttacks", "Attack type = " .. selfData.AttackType) end
	
	if checkTimers && selfData.AttackType == VJ.ATTACK_TYPE_MELEE && selfData.AttackState < VJ.ATTACK_STATE_EXECUTED then
		attackTimers[VJ.ATTACK_TYPE_MELEE](self, true)
	end
	
	selfData.AttackType = VJ.ATTACK_TYPE_NONE
	selfData.AttackState = VJ.ATTACK_STATE_DONE
	selfData.AttackSeed = 0
	
	self:MaintainAlertBehavior()
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function math_angDif(diff)
    diff = diff % 360
    return diff > 180 and (diff - 360) or diff
end
--
function ENT:UpdatePoseParamTracking(resetPoses)
	local selfData = self:GetTable()
	if !selfData.HasPoseParameterLooking or (!selfData.VJ_IsBeingControlled && (!selfData.WeaponAttackState or (!selfData.EnemyData.Visible && selfData.WeaponAttackState < VJ.WEP_ATTACK_STATE_FIRE))) then return end
	//VJ.GetPoseParameters(self)
	local ene = self:GetEnemy()
	local newPitch = 0
	local newYaw = 0
	local newRoll = 0
	if !resetPoses && IsValid(ene) then
		local myEyePos = self:EyePos()
		local myAng = self:GetAngles()
		local eneAng = (self:GetAimPosition(ene, myEyePos) - myEyePos):Angle()
		newPitch = math_angDif(eneAng.p - myAng.p)
		if selfData.PoseParameterLooking_InvertPitch then newPitch = -newPitch end
		newYaw = math_angDif(eneAng.y - myAng.y)
		if selfData.PoseParameterLooking_InvertYaw then newYaw = -newYaw end
		newRoll = math_angDif(eneAng.z - myAng.z)
		if selfData.PoseParameterLooking_InvertRoll then newRoll = -newRoll end
	elseif !selfData.PoseParameterLooking_CanReset then
		return -- Should it reset its pose parameters if there is no enemies?
	end
	
	local funcCustom = self.OnUpdatePoseParamTracking; if funcCustom then funcCustom(self, newPitch, newYaw, newRoll) end
	local names = selfData.PoseParameterLooking_Names
	local namesPitch = names.pitch
	local namesYaw = names.yaw
	local namesRoll = names.roll
	local speed = selfData.PoseParameterLooking_TurningSpeed
	for x = 1, #namesPitch do
		local pose = namesPitch[x]
		funcSetPoseParameter(self, pose, math_angApproach(funcGetPoseParameter(self, pose), newPitch, speed))
	end
	for x = 1, #namesYaw do
		local pose = namesYaw[x]
		funcSetPoseParameter(self, pose, math_angApproach(funcGetPoseParameter(self, pose), newYaw, speed))
	end
	for x = 1, #namesRoll do
		local pose = namesRoll[x]
		funcSetPoseParameter(self, pose, math_angApproach(funcGetPoseParameter(self, pose), newRoll, speed))
	end
	selfData.UpdatedPoseParam = true
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
	local selfData = self:GetTable()
	local curWep = selfData.WeaponEntity
	
	if selfData.PauseAttacks or !IsValid(curWep) or self:GetWeaponState() != VJ.WEP_STATE_READY then return false end
	if selfData.VJ_IsBeingControlled then
		checkDistance = false
	else
		local enemyDist = selfData.EnemyData.Distance
		if checkDistance && CurTime() > selfData.NextWeaponAttackT && enemyDist < selfData.Weapon_MaxDistance && ((enemyDist > selfData.Weapon_MinDistance) or curWep.IsMeleeWeapon) then
			hasDist = true
		end
		if checkDistanceOnly then
			return hasDist
		end
	end
	if !selfData.AttackType && !self:IsBusy("Activities") then
		hasChecks = true
		if !checkDistance then return true end
	end
	return hasDist && hasChecks
end
---------------------------------------------------------------------------------------------------------------------------------------------
local schedule_yield_player = vj_ai_schedule.New("SCHEDULE_YIELD_PLAYER")
	schedule_yield_player:EngTask("TASK_MOVE_AWAY_PATH", 120)
	schedule_yield_player:EngTask("TASK_RUN_PATH", 0)
	schedule_yield_player:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
	schedule_yield_player.CanShootWhenMoving = true
	schedule_yield_player.TurnData = {} -- This is constantly edited!
local bitsDanger = bit.bor(SOUND_BULLET_IMPACT, SOUND_COMBAT, SOUND_WORLD, SOUND_DANGER) // SOUND_PLAYER, SOUND_PLAYER_VEHICLE
--
function ENT:SelectSchedule()
	local selfData = self:GetTable()
	if selfData.VJ_IsBeingControlled or selfData.Dead then return end
	
	local curTime = CurTime()
	local ene = self:GetEnemy()
	local eneValid = IsValid(ene)
	self:PlayIdleSound(nil, nil, eneValid)
	
	-- Idle Behavior --
	if !eneValid then
		if selfData.AttackType != VJ.ATTACK_TYPE_GRENADE then
			self:MaintainIdleBehavior()
		end
		if !selfData.Alerted then
			selfData.TakingCoverT = 0
		end
		selfData.Weapon_UnarmedBehavior_Active = false
		
		-- Investigation: Conditions // funcHasCondition(self, COND_HEAR_PLAYER)
		if selfData.CanInvestigate && (funcHasCondition(self, COND_HEAR_BULLET_IMPACT) or funcHasCondition(self, COND_HEAR_COMBAT) or funcHasCondition(self, COND_HEAR_WORLD) or funcHasCondition(self, COND_HEAR_DANGER)) && selfData.NextInvestigationMove < curTime && selfData.TakingCoverT < curTime && !self:IsBusy() then
			local sdSrc = self:GetBestSoundHint(bitsDanger)
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
					self:PlaySoundSystem("Investigate")
					selfData.TakingCoverT = curTime + 1
				end
			end
		end
		
	-- Combat Behavior --
	else
		local wep = self:GetActiveWeapon()
		local eneData = selfData.EnemyData
		
		-- Check for weapon validity
		if !IsValid(wep) then
			-- Scared behavior system
			if selfData.Weapon_UnarmedBehavior then
				if !self:IsBusy() && curTime > selfData.NextChaseTime then
					selfData.Weapon_UnarmedBehavior_Active = true -- Tells the idle system to use the scared behavior animation
					if !selfData.IsFollowing && eneData.Visible then
						self:SCHEDULE_COVER_ENEMY("TASK_RUN_PATH")
						return
					end
				end
			-- If it doesn't do scared behavior, then make it chase the enemy if it can melee!
			elseif selfData.HasMeleeAttack then
				selfData.Weapon_UnarmedBehavior_Active = false -- In case it was scared, return it back to normal
				selfData.NextDangerDetectionT = curTime + 4 -- Ignore dangers while chasing!
				self:MaintainAlertBehavior()
				return
			end
			self:MaintainIdleBehavior(2)
			//return -- Allow other behaviors like "COND_PLAYER_PUSHING", etc to run
		else
			selfData.Weapon_UnarmedBehavior_Active = false -- In case it was scared, return it back to normal
			
			local enePos_Eye = ene:EyePos()
			local myPos = self:GetPos()
			local myPosCentered = myPos + self:OBBCenter()
			
			-- Retreat from enemy if it's to close
			if eneData.Distance <= selfData.Weapon_RetreatDistance && !wep.IsMeleeWeapon && curTime > selfData.TakingCoverT && curTime > selfData.NextChaseTime && !selfData.AttackType && !selfData.IsFollowing && ene.Behavior != VJ_BEHAVIOR_PASSIVE && !self:DoCoverTrace(myPosCentered, enePos_Eye) then
				local moveCheck = PICK(VJ.TraceDirections(self, "Quick", 200, true, false, 8, true))
				if moveCheck then
					self:SetLastPosition(moveCheck)
					if self:GetWeaponState() == VJ.WEP_STATE_RELOADING then self:SetWeaponState() end
					selfData.TakingCoverT = curTime + 2
					self:SCHEDULE_GOTO_POSITION("TASK_RUN_PATH", function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.CanShootWhenMoving = true x.TurnData = {Type = VJ.FACE_ENEMY} end)
					goto goto_conditions
				end
			end
			
			if self:CanFireWeapon(false, false) && self:GetState() != VJ_STATE_ONLY_ANIMATION_NOATTACK then
				-- Enemy to far away or not allowed to fire a weapon
				if eneData.Distance > selfData.Weapon_MaxDistance or curTime < selfData.NextWeaponAttackT then
					self:MaintainAlertBehavior()
					selfData.AllowWeaponOcclusionDelay = false
				-- Check if enemy is in sight, then continue...
				elseif self:CanFireWeapon(true, true) then
					-- I can't see the enemy from my eyes
					if self:DoCoverTrace(self:EyePos(), enePos_Eye, true) then // or (!eneData.Visible)
						if selfData.TakingCoverT > curTime then return end -- Do NOT interrupt when taking cover (such as "CombatDamageResponse")
						if self:GetWeaponState() != VJ.WEP_STATE_RELOADING then
							-- Wait when enemy is occluded
							if selfData.Weapon_OcclusionDelay && selfData.WeaponAttackState != VJ.WEP_ATTACK_STATE_AIM_OCCLUSION && !wep.IsMeleeWeapon && selfData.AllowWeaponOcclusionDelay && (curTime - selfData.WeaponLastShotTime) <= 4.5 && eneData.Distance > selfData.Weapon_OcclusionDelayMinDist then
								selfData.WeaponAttackState = VJ.WEP_ATTACK_STATE_AIM_OCCLUSION
								self:MaintainIdleBehavior(2) -- Make it play idle stand (Which will turn into ACT_IDLE_ANGRY)
								selfData.NextChaseTime = curTime + math.Rand(selfData.Weapon_OcclusionDelayTime.a, selfData.Weapon_OcclusionDelayTime.b)
							-- I am hidden, so stand up in case I am crouching if I had detected to be in a hidden position and the enemy may be visible!
							elseif curTime < selfData.LastHiddenZoneT && !self:DoCoverTrace(myPosCentered + self:GetUp()*30, enePos_Eye + self:GetUp()*30, true) then
								self:MaintainIdleBehavior(2) -- Make it play idle stand (Which will turn into ACT_IDLE_ANGRY)
								goto goto_checkwep
							else
								-- Everything failed, go after the enemy!
								if selfData.WeaponAttackState && selfData.WeaponAttackState >= VJ.WEP_ATTACK_STATE_FIRE && selfData.CurrentScheduleName != "SCHEDULE_ALERT_CHASE" && selfData.CurrentScheduleName != "SCHEDULE_ALERT_CHASE_LOS" then
									selfData.WeaponAttackState = VJ.WEP_ATTACK_STATE_NONE
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
						if !selfData.HasPoseParameterLooking then -- Pose parameter looking is disabled then always face
							self:SetTurnTarget("Enemy")
						else
							local wepDif = selfData.Weapon_AimTurnDiff or selfData.Weapon_AimTurnDiff_Def
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
						// self:MaintainAlertBehavior()
						-- if covered, try to move forward by calculating the distance between the prop and the NPC
						local inCover, inCoverTrace = self:DoCoverTrace(myPosCentered, enePos_Eye, false, {SetLastHiddenTime = true})
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
							if inCoverEntLiving && selfData.WeaponAttackState == VJ.WEP_ATTACK_STATE_FIRE_STAND && curTime > selfData.TakingCoverT && IsValid(wepInCoverEnt) && wepInCoverEnt:IsNPC() && wepInCoverEnt != self && (self:Disposition(wepInCoverEnt) == D_LI or self:Disposition(wepInCoverEnt) == D_NU) && wepInCoverTrace.HitPos:Distance(wepInCoverTrace.StartPos) <= 3000 then
								local moveCheck = PICK(VJ.TraceDirections(self, "Quick", 50, true, false, 4, true, true))
								if moveCheck then
									self:StopMoving()
									if selfData.IsGuard then self.GuardData.Position = moveCheck; self.GuardData.Direction = moveCheck + self:GetForward() * 51 end -- Set the guard position to this new position that avoids friendly fire
									self:SetLastPosition(moveCheck)
									selfData.NextChaseTime = curTime + 1
									self:SCHEDULE_GOTO_POSITION("TASK_WALK_PATH", function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.CanShootWhenMoving = true x.TurnData = {Type = VJ.FACE_ENEMY} end)
								end
							end
							
							-- NPC is behind cover...
							if inCover then
								-- Behind cover and I am taking cover, don't fire!
								if curTime < selfData.TakingCoverT then
									goto goto_conditions
								elseif curTime > selfData.NextMoveOnGunCoveredT && ((inCoverTrace.HitPos:Distance(myPos) > 150 && !inCoverEntLiving) or (wepInCover && !wepInCoverEnt.VJ_ID_Living)) then
									selfData.AllowWeaponOcclusionDelay = false
									local nearestPos;
									local nearestEntPos;
									if IsValid(inCoverEnt) then
										nearestPos, nearestEntPos = VJ.GetNearestPositions(self, inCoverEnt)
										nearestPos.z = myPos.z; nearestEntPos.z = myPos.z -- Floor the Z-axis as it can be used for a movement position!
									else
										nearestPos, nearestEntPos = self:NearestPoint(inCoverTrace.HitPos), inCoverTrace.HitPos
									end
									nearestEntPos = nearestEntPos - self:GetForward()*15
									if nearestPos:Distance(nearestEntPos) <= (selfData.IsGuard and 100 or 1000) then
										if selfData.IsGuard then self.GuardData.Position = nearestEntPos; self.GuardData.Direction = nearestEntPos + self:GetForward() * 51 end -- Set the guard position to this new position that provides cover
										self:SetLastPosition(nearestEntPos)
										//VJ.DEBUG_TempEnt(nearestEntPos, self:GetAngles(), Color(0,255,255))
										local schedule = vj_ai_schedule.New("SCHEDULE_GOTO_POSITION")
										schedule:EngTask("TASK_GET_PATH_TO_LASTPOSITION", 0)
										local coverRunAnim = self:TranslateActivity(PICK(selfData.AnimTbl_MoveToCover))
										if VJ.AnimExists(self, coverRunAnim) then
											self:SetMovementActivity(coverRunAnim)
										else -- Only shoot if we aren't crouching running!
											schedule.CanShootWhenMoving = true
										end
										schedule:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
										schedule.TurnData = {Type = VJ.FACE_ENEMY}
										//schedule.StopScheduleIfNotMoving_Any = true
										self:StartSchedule(schedule)
										//self:SCHEDULE_GOTO_POSITION("TASK_WALK_PATH",function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.CanShootWhenMoving = true x.TurnData = {Type = VJ.FACE_ENEMY} end)
									end
									selfData.NextMoveOnGunCoveredT = curTime + 2
									return
								end
							//else -- NPC is NOT behind cover
							end
						end
						
						if curTime > selfData.NextWeaponAttackT && curTime > selfData.NextWeaponAttackT_Base then
							-- Melee weapons
							if wep.IsMeleeWeapon then
								self:OnWeaponAttack()
								local finalAnim = self:TranslateActivity(PICK(selfData.AnimTbl_WeaponAttack))
								if curTime > selfData.NextMeleeWeaponAttackT && VJ.AnimExists(self, finalAnim) then // && !VJ.IsCurrentAnim(self, finalAnim)
									local animDur = VJ.AnimDuration(self, finalAnim)
									wep.NPC_NextPrimaryFire = animDur -- Make melee weapons dynamically change the next primary fire
									VJ.EmitSound(self, wep.NPC_BeforeFireSound, wep.NPC_BeforeFireSoundLevel, math.Rand(wep.NPC_BeforeFireSoundPitch.a, wep.NPC_BeforeFireSoundPitch.b))
									selfData.NextMeleeWeaponAttackT = curTime + animDur
									selfData.WeaponAttackAnim = finalAnim
									self:PlayAnim(finalAnim, false, false, true)
									selfData.WeaponAttackState = VJ.WEP_ATTACK_STATE_FIRE_STAND
								end
							-- Ranged weapons
							else
								selfData.AllowWeaponOcclusionDelay = true
								local hasAmmo = wep:Clip1() > 0 -- Does it have ammo?
								if !hasAmmo && selfData.WeaponAttackState != VJ.WEP_ATTACK_STATE_AIM then
									selfData.WeaponAttackAnim = ACT_INVALID
								end
								-- If it's already doing a firing animation, then do NOT restart the animation
								if VJ.IsCurrentAnim(self, self:TranslateActivity(selfData.WeaponAttackAnim)) then
									selfData.WeaponAttackState = VJ.WEP_ATTACK_STATE_FIRE_STAND
								-- If the current activity isn't the last weapon animation and it's not a transition, then continue
								elseif self:GetActivity() != selfData.WeaponAttackAnim && self:GetActivity() != ACT_TRANSITION then
									self:OnWeaponAttack()
									if selfData.WeaponAttackState == VJ.WEP_ATTACK_STATE_AIM_OCCLUSION then
										selfData.WeaponAttackState = VJ.WEP_ATTACK_STATE_NONE
									end
									selfData.WeaponLastShotTime = curTime
									//selfData.NextWeaponStrafeT = curTime + 2
									local finalAnim = false
									-- Check if the NPC has ammo
									if !hasAmmo then
										self:MaintainIdleBehavior(2) -- Make it play idle stand (Which will turn into ACT_IDLE_ANGRY)
										//finalAnim = self:TranslateActivity(PICK(selfData.AnimTbl_WeaponAim))
										selfData.WeaponAttackState = VJ.WEP_ATTACK_STATE_AIM
									else
										-- Crouch fire
										local anim_crouch = self:TranslateActivity(PICK(selfData.AnimTbl_WeaponAttackCrouch))
										if selfData.Weapon_CanCrouchAttack && !inCover && !wepInCover && eneData.Distance > 500 && VJ.AnimExists(self, anim_crouch) && math.random(1, selfData.Weapon_CrouchAttackChance) == 1 && !self:DoCoverTrace(wep:GetBulletPos() + self:GetUp() * -18, enePos_Eye, true) then
											finalAnim = anim_crouch
										-- Standing fire
										else
											finalAnim = self:TranslateActivity(PICK(selfData.AnimTbl_WeaponAttack))
										end
									end
									if finalAnim && VJ.AnimExists(self, finalAnim) && (!VJ.IsCurrentAnim(self, finalAnim) or !selfData.WeaponAttackState) then
										VJ.EmitSound(self, wep.NPC_BeforeFireSound, wep.NPC_BeforeFireSoundLevel, math.Rand(wep.NPC_BeforeFireSoundPitch.a, wep.NPC_BeforeFireSoundPitch.b))
										self:PlayAnim(finalAnim, false, 0, true)
										selfData.WeaponAttackAnim = finalAnim
										selfData.WeaponAttackState = VJ.WEP_ATTACK_STATE_FIRE_STAND
										selfData.NextWeaponAttackT_Base = curTime + 0.2
									end
								end
							end
						end
						-- Move randomly when shooting
						if selfData.Weapon_Strafe && !inCover && !selfData.IsGuard && !selfData.IsFollowing && !wep.IsMeleeWeapon && (!wep.NPC_StandingOnly) && selfData.WeaponAttackState == VJ.WEP_ATTACK_STATE_FIRE_STAND && curTime > selfData.NextWeaponStrafeT && (curTime - eneData.TimeAcquired) > 2 && (eneData.Distance < (selfData.Weapon_MaxDistance / 1.25)) then
							if self:OnWeaponStrafe() != false then
								local moveCheck = PICK(VJ.TraceDirections(self, "Radial", math.random(150, 400), true, false, 12, true))
								if moveCheck then
									self:StopMoving()
									self:SetLastPosition(moveCheck)
									self:SCHEDULE_GOTO_POSITION(math.random(1, 2) == 1 and "TASK_RUN_PATH" or "TASK_WALK_PATH", function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.CanShootWhenMoving = true x.TurnData = {Type = VJ.FACE_ENEMY} end)
								end
							end
							selfData.NextWeaponStrafeT = curTime + math.Rand(selfData.Weapon_StrafeCooldown.a, selfData.Weapon_StrafeCooldown.b)
						end
					else -- None VJ Base weapons
						self:SetTurnTarget("Enemy")
						selfData.WeaponAttackState = VJ.WEP_ATTACK_STATE_FIRE_STAND
						self:OnWeaponAttack()
						selfData.WeaponLastShotTime = curTime
						//wep:SetClip1(99999)
						self:SetSchedule(SCHED_RANGE_ATTACK1)
					end
				end
			end
		end
	end
	
	::goto_conditions::
	-- Handle move away behavior
	if funcHasCondition(self, COND_PLAYER_PUSHING) && curTime > selfData.TakingCoverT && !self:IsBusy("Activities") then
		self:PlaySoundSystem("YieldToPlayer")
		if eneValid then -- Face current enemy
			schedule_yield_player.TurnData.Type = VJ.FACE_ENEMY_VISIBLE
			schedule_yield_player.TurnData.Target = nil
		elseif IsValid(self:GetTarget()) then -- Face current target
			schedule_yield_player.TurnData.Type = VJ.FACE_ENTITY_VISIBLE
			schedule_yield_player.TurnData.Target = self:GetTarget()
		else -- Reset if both others fail! (Remember this is a localized table shared between all NPCs!)
			schedule_yield_player.TurnData.Type = nil
			schedule_yield_player.TurnData.Target = nil
		end
		self:StartSchedule(schedule_yield_player)
		selfData.TakingCoverT = curTime + 2
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ResetEnemy(checkAllies, checkVis)
	local selfData = self:GetTable()
	if selfData.Dead or (selfData.VJ_IsBeingControlled && selfData.VJ_TheControllerBullseye == self:GetEnemy()) then selfData.EnemyData.Reset = false return false end
	local ene = self:GetEnemy()
	local eneValid = IsValid(ene)
	local eneData = selfData.EnemyData
	local curTime = CurTime()
	if checkAllies then
		local getAllies = self:Allies_Check(1000)
		if getAllies then
			for _, ally in ipairs(getAllies) do
				local allyEne = ally:GetEnemy()
				if IsValid(allyEne) && (curTime - ally.EnemyData.VisibleTime) < selfData.EnemyTimeout && allyEne:Alive() && self:CheckRelationship(allyEne) == D_HT then
					selfData.AllowWeaponOcclusionDelay = false
					self:ForceSetEnemy(allyEne, false)
					eneData.VisibleTime = curTime -- Reset the time otherwise it will run "ResetEnemy" none-stop!
					eneData.Reset = false
					return false
				end
			end
		end
	end
	if checkVis then
		-- If the current number of reachable enemies is higher then 1, then don't reset
		local curEnemies = eneData.VisibleCount //selfData.CurrentReachableEnemies
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
	
	if selfData.VJ_DEBUG && GetConVar("vj_npc_debug_resetenemy"):GetInt() == 1 then VJ.DEBUG_Print(self, "ResetEnemy", tostring(ene)) end
	eneData.Reset = true
	self:SetNPCState(NPC_STATE_ALERT)
	timer.Create("alert_reset" .. self:EntIndex(), math.Rand(selfData.AlertTimeout.a, selfData.AlertTimeout.b), 1, function() if !IsValid(self:GetEnemy()) then selfData.Alerted = false self:SetNPCState(NPC_STATE_IDLE) end end)
	self:OnResetEnemy()
	local moveToEnemy = false
	if eneValid then
		if !selfData.IsFollowing && !selfData.IsGuard && !selfData.IsVJBaseSNPC_Tank && !selfData.VJ_IsBeingControlled && selfData.LastHiddenZone_CanWander == true && !selfData.Weapon_UnarmedBehavior_Active && selfData.Behavior != VJ_BEHAVIOR_PASSIVE && selfData.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE && !self:IsBusy() && !self:Visible(ene) && self:GetEnemyLastKnownPos() != defPos then
			moveToEnemy = self:GetEnemyLastKnownPos()
		end
		self:MarkEnemyAsEluded(ene)
		//self:ClearEnemyMemory(ene) // Completely resets the enemy memory
		self:AddEntityRelationship(ene, D_NU, 10)
	end
	
	selfData.LastHiddenZone_CanWander = curTime > selfData.LastHiddenZoneT and true or false
	selfData.LastHiddenZoneT = 0
	
	-- Clear memory of the enemy if it's not a player AND it's dead
	if eneValid && !ene:IsPlayer() && !ene:Alive() then
		//print("Clear memory", ene)
		self:ClearEnemyMemory(ene)
	end
	-- This is needed for the human base because when taking cover from enemy, the AI can get stuck in a loop (EX: When selfData.Weapon_UnarmedBehavior_Active is true!)
	if selfData.CurrentScheduleName == "SCHEDULE_COVER_ENEMY" or selfData.CurrentScheduleName == "SCHEDULE_COVER_ENEMY_FAIL" then
		self:StopMoving()
	end
	selfData.NextWanderTime = curTime + math.Rand(3, 5)
	self:SetEnemy(NULL)
	if moveToEnemy then
		self:SetLastPosition(moveToEnemy)
		self:SCHEDULE_GOTO_POSITION("TASK_WALK_PATH", function(schedule)
			//if eneValid then schedule:EngTask("TASK_FORGET", ene) end
			//schedule:EngTask("TASK_IGNORE_OLD_ENEMIES", 0)
			schedule.ResetOnFail = true
			schedule.CanShootWhenMoving = true
			schedule.CanBeInterrupted = true
			schedule.TurnData = {Type = VJ.FACE_ENEMY}
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
	
	local selfData = self:GetTable()
	local hitgroup = self:GetLastDamageHitGroup()
	self:OnDamaged(dmginfo, hitgroup, "Init")
	if selfData.GodMode or dmginfo:GetDamage() <= 0 then return 0 end
	
	local dmgType = dmginfo:GetDamageType()
	local curTime = CurTime()
	local isFireEnt = false
	if self:IsOnFire() then
		isFireEnt = dmgInflictor && dmgAttacker && dmgInflictor:GetClass() == "entityflame" && dmgAttacker:GetClass() == "entityflame"
		if self:WaterLevel() > 1 then self:Extinguish() end -- If we are in water, then extinguish the fire
	end
	
	-- If it should always take damage from huge monsters, then skip immunity checks!
	if dmgAttacker && selfData.ForceDamageFromBosses && dmgAttacker.VJ_ID_Boss then
		goto skip_immunity
	end
	
	-- Immunity checks
	if isFireEnt && !selfData.AllowIgnition then self:Extinguish() return 0 end
	if (selfData.Immune_Fire && (dmgType == DMG_BURN or dmgType == DMG_SLOWBURN or isFireEnt)) or (selfData.Immune_Toxic && (dmgType == DMG_ACID or dmgType == DMG_RADIATION or dmgType == DMG_POISON or dmgType == DMG_NERVEGAS or dmgType == DMG_PARALYZE)) or (selfData.Immune_Bullet && (dmginfo:IsBulletDamage() or dmgType == DMG_BULLET or dmgType == DMG_AIRBOAT or dmgType == DMG_BUCKSHOT or dmgType == DMG_SNIPER)) or (selfData.Immune_Explosive && (dmgType == DMG_BLAST or dmgType == DMG_BLAST_SURFACE or dmgType == DMG_MISSILEDEFENSE)) or (selfData.Immune_Dissolve && dmgType == DMG_DISSOLVE) or (selfData.Immune_Electricity && (dmgType == DMG_SHOCK or dmgType == DMG_ENERGYBEAM or dmgType == DMG_PHYSGUN)) or (selfData.Immune_Melee && (dmgType == DMG_CLUB or dmgType == DMG_SLASH)) or (selfData.Immune_Sonic && dmgType == DMG_SONIC) then return 0 end
	
	-- Make sure combine ball does reasonable damage and doesn't spam!
	if (dmgInflictor && dmgInflictor:GetClass() == "prop_combine_ball") or (dmgAttacker && dmgAttacker:GetClass() == "prop_combine_ball") then
		if selfData.Immune_Dissolve then return 0 end
		if curTime > selfData.NextCombineBallDmgT then
			dmginfo:SetDamage(math.random(400, 500))
			dmginfo:SetDamageType(DMG_DISSOLVE)
			selfData.NextCombineBallDmgT = curTime + 0.2
		else
			return 0
		end
	end
	::skip_immunity::
	
	local function DoBleed()
		if selfData.Bleeds then
			self:OnBleed(dmginfo, hitgroup)
			-- Spawn the blood particle only if it's not caused by the default fire entity [Causes the damage position to be at Vector(0, 0, 0)]
			if selfData.HasBloodParticle && !isFireEnt then self:SpawnBloodParticles(dmginfo, hitgroup) end
			if selfData.HasBloodDecal then self:SpawnBloodDecals(dmginfo, hitgroup) end
			self:PlaySoundSystem("Impact")
		end
	end
	if selfData.Dead then DoBleed() return 0 end -- If dead then just bleed but take no damage
	
	self:OnDamaged(dmginfo, hitgroup, "PreDamage")
	if dmginfo:GetDamage() <= 0 then return 0 end -- Only take damage if it's above 0!
	-- Why? Because GMod resets/randomizes dmginfo after a tick...
	selfData.SavedDmgInfo = {
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
	if selfData.VJ_DEBUG && GetConVar("vj_npc_debug_damage"):GetInt() == 1 then VJ.DEBUG_Print(self, "OnTakeDamage", "Amount = ", dmginfo:GetDamage(), " | Attacker = ", dmgAttacker, " | Inflictor = ", dmgInflictor) end
	local healthRegen = selfData.HealthRegenParams
	if healthRegen.Enabled && healthRegen.ResetOnDmg then
		selfData.HealthRegenDelayT = curTime + (math.Rand(healthRegen.Delay.a, healthRegen.Delay.b) * 1.5)
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
		local isPassive = selfData.Behavior == VJ_BEHAVIOR_PASSIVE or selfData.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE
		if stillAlive then
			if !isFireEnt then
				self:Flinch(dmginfo, hitgroup)
			end
			
			-- Player attackers
			if dmgAttacker && dmgAttacker:IsPlayer() then
				-- Become enemy to a friendly player | RESULT: May become hostile to an allied player
				if selfData.BecomeEnemyToPlayer && self:CheckRelationship(dmgAttacker) == D_LI then
					local relationMemory = selfData.RelationshipMemory[dmgAttacker]
					self:SetRelationshipMemory(dmgAttacker, VJ.MEM_HOSTILITY_LEVEL, relationMemory[VJ.MEM_HOSTILITY_LEVEL] and relationMemory[VJ.MEM_HOSTILITY_LEVEL] + 1 or 1)
					if relationMemory[VJ.MEM_HOSTILITY_LEVEL] > selfData.BecomeEnemyToPlayer && self:Disposition(dmgAttacker) != D_HT then
						self:OnBecomeEnemyToPlayer(dmginfo, hitgroup)
						if selfData.IsFollowing && selfData.FollowData.Target == dmgAttacker then self:ResetFollowBehavior() end
						self:SetRelationshipMemory(dmgAttacker, VJ.MEM_OVERRIDE_DISPOSITION, D_HT)
						self:AddEntityRelationship(dmgAttacker, D_HT, 2)
						selfData.TakingCoverT = curTime + 2
						self:PlaySoundSystem("BecomeEnemyToPlayer")
						if !IsValid(self:GetEnemy()) then
							self:StopMoving()
							self:SetTarget(dmgAttacker)
							self:SCHEDULE_FACE("TASK_FACE_TARGET")
						end
						if selfData.CanChatMessage then
							dmgAttacker:PrintMessage(HUD_PRINTTALK, self:GetName().." no longer likes you.")
						end
					end
				end
			
				-- React to damage by a player
					-- 0 = Run it every time | 1 = Run it only when friendly to player | 2 = Run it only when enemy to player
				if selfData.HasDamageByPlayerSounds && curTime > selfData.NextDamageByPlayerSoundT && self:Visible(dmgAttacker) then
					local dispLvl = selfData.DamageByPlayerDispositionLevel
					if (dispLvl == 0 or (dispLvl == 1 && self:Disposition(dmgAttacker) == D_LI) or (dispLvl == 2 && self:Disposition(dmgAttacker) != D_HT)) then
						self:PlaySoundSystem("DamageByPlayer")
					end
				end
			end
			
			self:PlaySoundSystem("Pain")
			
			-- Move or hide when damaged while enemy is valid | RESULT: May play a hiding animation OR move to take cover from enemy
			local eneData = selfData.EnemyData
			if !isPassive && selfData.CombatDamageResponse && IsValid(self:GetEnemy()) && curTime > selfData.NextCombatDamageResponseT && !selfData.IsFollowing && !selfData.AttackType && curTime > selfData.TakingCoverT && eneData.Visible && self:GetWeaponState() != VJ.WEP_STATE_RELOADING && eneData.Distance < selfData.Weapon_MaxDistance then
				local wep = self:GetActiveWeapon()
				local canMove = true
				if self:DoCoverTrace(self:GetPos() + self:OBBCenter(), self:GetEnemy():EyePos()) then
					local hideTime = math.Rand(selfData.CombatDamageResponse_CoverTime.a, selfData.CombatDamageResponse_CoverTime.b)
					local anim = self:PlayAnim(selfData.AnimTbl_TakingCover, false, hideTime, false) -- Don't set lockAnim because we want it to shoot if an enemy is suddenly visible!
					if anim != ACT_INVALID then
						selfData.NextChaseTime = curTime + hideTime
						selfData.TakingCoverT = curTime + hideTime
						selfData.WeaponAttackState = VJ.WEP_ATTACK_STATE_NONE
						selfData.NextCombatDamageResponseT = curTime + math.random(selfData.CombatDamageResponse_Cooldown.a, selfData.CombatDamageResponse_Cooldown.b)
						canMove = false
					end
				end
				if canMove && !self:IsMoving() && (!IsValid(wep) or (IsValid(wep) && !wep.IsMeleeWeapon)) then -- Run away if not moving AND has a non-melee weapon
					self:SCHEDULE_COVER_ENEMY("TASK_RUN_PATH", function(x) x.CanShootWhenMoving = true x.TurnData = {Type = VJ.FACE_ENEMY} end)
					selfData.NextCombatDamageResponseT = curTime + math.random(selfData.CombatDamageResponse_Cooldown.a, selfData.CombatDamageResponse_Cooldown.b)
				end
			end
			
			if !isPassive && !IsValid(self:GetEnemy()) then
				local canMove = true
				
				-- How allies respond when it's damaged
				if selfData.DamageAllyResponse && curTime > selfData.NextDamageAllyResponseT && !selfData.IsFollowing then
					local responseDist = math_max(800, self:OBBMaxs():Distance(self:OBBMins()) * 12)
					local allies = self:Allies_Check(responseDist)
					if allies != false then
						if !isFireEnt then
							self:Allies_Bring("Diamond", responseDist, allies, 4)
						end
						for _, ally in ipairs(allies) do
							ally:DoReadyAlert()
						end
						if !isFireEnt && !self:IsBusy("Activities") then
							self:DoReadyAlert()
							local anim = self:PlayAnim(selfData.AnimTbl_DamageAllyResponse, true, false, true)
							if anim != ACT_INVALID then
								canMove = false
								selfData.NextFlinchT = curTime + 1
							end
						end
						selfData.NextDamageAllyResponseT = curTime + math.Rand(selfData.DamageAllyResponse_Cooldown.a, selfData.DamageAllyResponse_Cooldown.b)
					end
				end
				
				local dmgResponse = selfData.DamageResponse
				if dmgResponse && curTime > selfData.TakingCoverT && !self:IsBusy("Activities") then
					-- Attempt to find who damaged me | RESULT: May become alerted if attacker is visible OR it may hide if it didn't find the attacker
					if dmgAttacker && (dmgResponse == true or dmgResponse == "OnlySearch") then
						local sightDist = self:GetMaxLookDistance()
						sightDist = math_min(math_max(sightDist / 2, sightDist <= 1000 and sightDist or 1000), sightDist)
						-- IF normal sight dist is less than 1000 then change nothing, OR ELSE use half the distance with 1000 as minimum
						if self:GetPos():Distance(dmgAttacker:GetPos()) <= sightDist && self:Visible(dmgAttacker) && self:CheckRelationship(dmgAttacker) == D_HT then
							//self:AddEntityRelationship(dmgAttacker, D_HT, 10)
							self:OnSetEnemyFromDamage(dmginfo, hitgroup)
							selfData.NextCallForHelpT = curTime + 1
							self:ForceSetEnemy(dmgAttacker, true)
							self:MaintainAlertBehavior()
							canMove = false
						end
					end
					
					-- If all else failed then take cover!
					if canMove && (dmgResponse == true or dmgResponse == "OnlyMove") && !selfData.IsFollowing && selfData.MovementType != VJ_MOVETYPE_STATIONARY && dmginfo:GetDamageCustom() != VJ.DMG_BLEED then
						self:SCHEDULE_COVER_ORIGIN("TASK_RUN_PATH", function(x) x.CanShootWhenMoving = true x.TurnData = {Type = VJ.FACE_ENEMY} end)
						selfData.TakingCoverT = curTime + 5
					end
				end
			-- Passive NPCs
			elseif isPassive && curTime > selfData.TakingCoverT then
				if selfData.DamageResponse && !self:IsBusy() then
					self:SCHEDULE_COVER_ORIGIN("TASK_RUN_PATH")
				end
			end
		end
		
		-- Make passive NPCs move away | RESULT: May move away AND may cause other passive NPCs to move as well
		if isPassive && curTime > selfData.TakingCoverT then
			if selfData.Passive_AlliesRunOnDamage then -- Make passive allies run too!
				local allies = self:Allies_Check(math_max(800, self:OBBMaxs():Distance(self:OBBMins()) * 20))
				if allies != false then
					for _, ally in ipairs(allies) do
						ally.TakingCoverT = curTime + math.Rand(6, 7)
						ally:SCHEDULE_COVER_ORIGIN("TASK_RUN_PATH")
						ally:PlaySoundSystem("Alert")
					end
				end
			end
			selfData.TakingCoverT = curTime + math.Rand(6, 7)
		end
	end
	
	-- If eating, stop!
	if selfData.CanEat && selfData.VJ_ST_Eating then
		selfData.EatingData.NextCheck = curTime + 15
		self:ResetEatingBehavior("Injured")
	end
	
	if self:Health() <= 0 && !selfData.Dead then
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
	self:OnDeath(dmginfo, hitgroup, "Init")
	if self.MedicData.Status then self:ResetMedicBehavior() end
	if self.IsFollowing then self:ResetFollowBehavior() end
	local dmgInflictor = dmginfo:GetInflictor()
	local dmgAttacker = dmginfo:GetAttacker()
	local myPos = self:GetPos()
	
	if VJ_CVAR_AI_ENABLED then
		local responseDist = math_max(800, self:OBBMaxs():Distance(self:OBBMins()) * 12)
		local allies = self:Allies_Check(responseDist)
		if allies then
			local doBecomeEnemyToPlayer = (self.BecomeEnemyToPlayer && dmgAttacker:IsPlayer() && !VJ_CVAR_IGNOREPLAYERS) or false
			local responseType = self.DeathAllyResponse
			local movedAllyNum = 0 -- Number of allies that have moved
			for _, ally in ipairs(allies) do
				ally:OnAllyKilled(self)
				ally:PlaySoundSystem("AllyDeath")
				
				if responseType && myPos:Distance(ally:GetPos()) < responseDist then
					local moved = false
					-- Bring ally
					if responseType == true && movedAllyNum < self.DeathAllyResponse_MoveLimit then
						moved = self:Allies_Bring("Random", responseDist, {ally}, 0, true)
						if moved then
							movedAllyNum = movedAllyNum + 1
						end
					end
					-- Alert ally
					if (responseType == true or responseType == "OnlyAlert") && !IsValid(ally:GetEnemy()) then
						ally:DoReadyAlert()
						if !moved then
							local faceTime = math.Rand(5, 8)
							ally:SetTurnTarget(myPos, faceTime, true)
							ally.NextIdleTime = CurTime() + faceTime
						end
					end
				end
				
				-- BecomeEnemyToPlayer
				if doBecomeEnemyToPlayer && ally.BecomeEnemyToPlayer && ally:Disposition(dmgAttacker) == D_LI then
					local relationMemory = ally.RelationshipMemory[dmgAttacker]
					ally:SetRelationshipMemory(dmgAttacker, VJ.MEM_HOSTILITY_LEVEL, relationMemory[VJ.MEM_HOSTILITY_LEVEL] and relationMemory[VJ.MEM_HOSTILITY_LEVEL] + 1 or 1)
					if relationMemory[VJ.MEM_HOSTILITY_LEVEL] > ally.BecomeEnemyToPlayer then
						if ally:Disposition(dmgAttacker) != D_HT then
							ally:OnBecomeEnemyToPlayer(dmginfo, hitgroup)
							if ally.IsFollowing && ally.FollowData.Target == dmgAttacker then ally:ResetFollowBehavior() end
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
			local decalPos = myPos + vecZ4
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
		self:PlayAnim(chosenAnim, true, animTime, false, 0, {PlayBackRateCalculated = true})
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
function ENT:GetAttackSpread(wep, target) return end