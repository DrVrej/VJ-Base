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
------ Movement & Sight ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.SightDistance = 6500 -- Initial sight distance | To retrieve: "self:GetMaxLookDistance()" | To change: "self:SetMaxLookDistance(distance)"
ENT.SightAngle = 156 -- Initial field of view | To retrieve: "self:GetFOV()" | To change: "self:SetFOV(degree)" | 360 = See all around
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
	MaxRise = 220, -- How high it can jump up ((S -> A) AND (S -> E))
	MaxDrop = 384, -- How low it can jump down (E -> S)
	MaxDistance = 512, -- Maximum distance between Start and End
}
	-- ====== STATIONARY ====== --
ENT.CanTurnWhileStationary = true -- Can it turn while using stationary move type?
	-- ====== AERIAL & AQUATIC ====== --
ENT.AA_GroundLimit = 100 -- If the NPC's distance from itself to the ground is less than this, it will attempt to move up
ENT.AA_MinWanderDist = 150 -- Minimum distance that it should move when wandering
ENT.AA_MoveAccelerate = 5 -- It will gradually speed up to the max movement speed as it moves towards its destination | Calculation = FrameTime * x
	-- 0 = Constant max speed | 1 = Slight acceleration | 50 = Rapid acceleration
ENT.AA_MoveDecelerate = 5 -- It will slow down as it approaches its destination | Calculation = MaxSpeed / x
	-- 1 = Constant max speed | 2 = Slight deceleration | 50 = Rapid deceleration
	-- AERIAL --
ENT.Aerial_FlyingSpeed_Calm = 80 -- Speed it should fly with, when it's wandering, moving slowly, etc. | Basically walking compared to ground NPCs
ENT.Aerial_FlyingSpeed_Alerted = 200 -- Speed it should fly with, when it's chasing an enemy, moving away quickly, etc. | Basically running compared to ground NPCs
ENT.Aerial_AnimTbl_Calm = ACT_FLY -- Flying animations to play while idle | Equivalent to "walking" | Unlike other movements, sequences are allowed!
ENT.Aerial_AnimTbl_Alerted = ACT_FLY -- Flying animations to play while alert | Equivalent to "Running" | Unlike other movements, sequences are allowed!
	-- AQUATIC --
ENT.Aquatic_SwimmingSpeed_Calm = 80 -- The speed it should swim with, when it's wandering, moving slowly, etc. | Basically walking compared to ground NPCs
ENT.Aquatic_SwimmingSpeed_Alerted = 200 -- The speed it should swim with, when it's chasing an enemy, moving away quickly, etc. | Basically running compared to ground NPCs
ENT.Aquatic_AnimTbl_Calm = ACT_SWIM -- Swimming animations to play while idle | Equivalent to "walking" | Unlike other movements, sequences are allowed!
ENT.Aquatic_AnimTbl_Alerted = ACT_SWIM -- Swimming animations to play while alert | Equivalent to "Running" | Unlike other movements, sequences are allowed!
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
ENT.CanEat = false -- Can it search and eat organic stuff?
ENT.EatCooldown = 30 -- How much time until it can eat again after devouring something?
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
ENT.AnimTbl_CallForHelp = false -- Call for help animations | false = Don't play an animation
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
	-- ====== Limit Chase Distance Behavior ====== --
ENT.LimitChaseDistance = false -- Should it limit chasing when between certain distances? | true = Always limit | "OnlyRange" = Only limit if it's able to range attack
ENT.LimitChaseDistance_Min = 300 -- Min distance from the enemy to limit its chasing | "UseRangeDistance" = Use range attack's min distance
ENT.LimitChaseDistance_Max = 2000 -- Max distance from the enemy to limit its chasing | "UseRangeDistance" = Use range attack's max distance
	-- ====== Prop Damaging & Pushing Behavior ====== --
	-- By default this requires the NPC to have a melee attack, unless coded otherwise
ENT.PropInteraction = true -- Controls how it should interact with props
	-- false = Disable both damaging and pushing | true = Damage and push | "OnlyDamage" = Damage but don't push | "OnlyPush" = Push but don't damage
ENT.PropInteraction_MaxScale = 1 -- Max prop size multiplier | x < 1  = Smaller props | x > 1  = Larger props
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
ENT.FlinchChance = 14 -- Chance of flinching from 1 to x | 1 = Always flinch
ENT.FlinchCooldown = 5 -- How much time until it can flinch again? | false = Base auto calculates the duration
ENT.AnimTbl_Flinch = ACT_FLINCH_PHYSICS
ENT.FlinchHitGroupMap = false -- EXAMPLES: {{HitGroup = {HITGROUP_HEAD}, Animation = {ACT_FLINCH_HEAD}}, {HitGroup = {HITGROUP_LEFTARM}, Animation = {ACT_FLINCH_LEFTARM}}, {HitGroup = {HITGROUP_RIGHTARM}, Animation = {ACT_FLINCH_RIGHTARM}}, {HitGroup = {HITGROUP_LEFTLEG}, Animation = {ACT_FLINCH_LEFTLEG}}, {HitGroup = {HITGROUP_RIGHTLEG}, Animation = {ACT_FLINCH_RIGHTLEG}}}
ENT.FlinchHitGroupPlayDefault = true -- Should it play "self.AnimTbl_Flinch" when none of the mapped hit groups hit?
	-- ====== Non-Combat Damage Response Behaviors ====== --
	-- For passive behavior NPC, these responses will run regardless if it has an active enemy or not
ENT.DamageResponse = true -- Should it respond to damages while it has no enemy?
	-- true = Search for enemies or run to a covered position | "OnlyMove" = Will only run to a covered position | "OnlySearch" = Will only search for enemies
ENT.DamageAllyResponse = true -- Should allies respond when it's damaged while it has no enemy?
ENT.AnimTbl_DamageAllyResponse = false -- Animations to play when it calls allies to respond | false = Don't play an animation
ENT.DamageAllyResponse_Cooldown = VJ.SET(9, 12) -- How long until it can call allies again?
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Death & Corpse ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.DeathDelayTime = 0 -- Time until it spawns the corpse, removes itself, etc.
	-- ====== Ally Responses ====== --
	-- An ally must have "self.CanReceiveOrders" enabled to respond!
ENT.DeathAllyResponse = true -- How should allies response when it dies?
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
ENT.DropDeathLoot = true -- Should it drop loot on death?
ENT.DeathLoot = {} -- List of entities it will randomly pick to drop | Leave it empty to drop nothing
ENT.DeathLootChance = 14 -- If set to 1, it will always drop loot
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Melee Attack ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasMeleeAttack = true -- Can it melee attack?
ENT.MeleeAttackDamage = 10
ENT.MeleeAttackDamageType = DMG_SLASH
ENT.HasMeleeAttackKnockBack = false -- Should knockback be applied on melee hit? | Use "MeleeAttackKnockbackVelocity" function to edit the velocity
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
ENT.TimeUntilMeleeAttackDamage = 0.6 -- How much time until it executes the damage? | false = Make the attack event-based
ENT.NextMeleeAttackTime = 0 -- How much time until it can use a melee attack? | number = Specific time | VJ.SET = Randomized between the 2 numbers
ENT.NextAnyAttackTime_Melee = false -- How much time until it can do any attack again? | false = Base auto calculates the duration | number = Specific time | VJ.SET = Randomized between the 2 numbers
ENT.MeleeAttackReps = 1 -- How many times does it run the melee attack code?
ENT.MeleeAttackExtraTimers = false -- Extra melee attack timers, EX: {1, 1.4}
ENT.MeleeAttackStopOnHit = false -- Should it stop executing the melee attack after it hits an enemy?
	-- ====== Bleeding System ====== --
	-- Causes the enemy to continue taking damage after it's hit based on the given parameters:
ENT.MeleeAttackBleedEnemy = false -- Should it bleed enemies it hits?
ENT.MeleeAttackBleedEnemyChance = 3 -- Chance that the enemy bleeds | 1 = always
ENT.MeleeAttackBleedEnemyDamage = 1 -- How much damage per repetition
ENT.MeleeAttackBleedEnemyTime = 1 -- How much time until the next repetition?
ENT.MeleeAttackBleedEnemyReps = 4 -- How many repetitions?
	-- ====== Player Speed Modifier ====== --
ENT.MeleeAttackPlayerSpeed = false -- Should it modify the movement speed of players that got damaged?
ENT.MeleeAttackPlayerSpeedWalk = 100
ENT.MeleeAttackPlayerSpeedRun = 100
ENT.MeleeAttackPlayerSpeedTime = 5 -- How much time until player's speed resets back to normal
	-- ====== Digital Signal Processor (DSP) Effect ====== --
	-- DSP ID Presents: https://wiki.facepunch.com/gmod/DSP_Presets AND https://developer.valvesoftware.com/wiki/Dsp_presets
ENT.MeleeAttackDSP = 32 -- Should it apply a DSP effect to players? | false = Disable applying DSP effect | number = DSP effect ID
ENT.MeleeAttackDSPLimit = 60 -- Should it only apply if the damage surpasses the given number? | false = Always apply | number = Only apply when damage is greater than or equal to this number
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Range Attack ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasRangeAttack = false -- Can it range attack?
ENT.RangeAttackProjectiles = "obj_vj_rocket" -- Entities that it can spawn when range attacking | table = Picks randomly
	-- ====== Animation ====== --
ENT.AnimTbl_RangeAttack = ACT_RANGE_ATTACK1 -- Animations to play when it range attacks | false = Don't play an animation
ENT.RangeAttackAnimationDelay = 0 -- It will wait certain amount of time before playing the animation
ENT.RangeAttackAnimationFaceEnemy = true -- Should it face the enemy while playing the range attack animation?
ENT.RangeAttackAnimationDecreaseLengthAmount = 0 -- Decreases animation time | Use it to fix animations that have extra frames at the end
	-- ====== Distance ====== --
ENT.RangeAttackMinDistance = 800 -- Min range attack distance
ENT.RangeAttackMaxDistance = 2000 -- Max range attack distance
ENT.RangeAttackAngleRadius = 100 -- What is the attack angle radius? | 100 = In front of it | 180 = All around it
	-- ====== Timer ====== --
ENT.TimeUntilRangeAttackProjectileRelease = 1.5 -- How much time until the projectile is thrown? | false = Make the attack event-based
ENT.NextRangeAttackTime = 3 -- How much time until it can use a range attack? | number = Specific time | VJ.SET = Randomized between the 2 numbers
ENT.NextAnyAttackTime_Range = false -- How much time until it can do any attack again? | false = Base auto calculates the duration | number = Specific time | VJ.SET = Randomized between the 2 numbers
ENT.RangeAttackReps = 1 -- How many times does it throw a projectile?
ENT.RangeAttackExtraTimers = false -- Extra range attack timers, EX: {1, 1.4}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Leap Attack ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasLeapAttack = false -- Can it leap attack?
ENT.LeapAttackDamage = 15
ENT.LeapAttackDamageType = DMG_SLASH
ENT.DisableDefaultLeapAttackDamageCode = false -- Disables the default leap attack damage code
	-- ====== Animation ====== --
ENT.AnimTbl_LeapAttack = ACT_SPECIAL_ATTACK1 -- Animations to play when it leap attacks | false = Don't play an animation
ENT.LeapAttackAnimationFaceEnemy = 2 -- true = Face the enemy the entire time! | 2 = Face the enemy UNTIL it jumps! | false = Don't face the enemy AT ALL!
ENT.LeapAttackAnimationDecreaseLengthAmount = 0 -- Decreases animation time | Use it to fix animations that have extra frames at the end
	-- ====== Distance ====== --
ENT.LeapAttackMinDistance = 200 -- Min distance that it can leap from
ENT.LeapAttackMaxDistance = 500 -- Max distance that it can leap from
ENT.LeapAttackDamageDistance = 100 -- How far does the damage go?
ENT.LeapAttackAngleRadius = 60 -- What is the attack angle radius? | 100 = In front of it | 180 = All around it
	-- ====== Timer ====== --
ENT.TimeUntilLeapAttackDamage = 0.2 -- How much time until it executes the damage? | false = Make the attack event-based
ENT.TimeUntilLeapAttackVelocity = 0.1 -- How much time until it runs the velocity code?
ENT.NextLeapAttackTime = 3 -- How much time until it can use a leap attack? | number = Specific time | VJ.SET = Randomized between the 2 numbers
ENT.NextAnyAttackTime_Leap = false -- How much time until it can do any attack again? | false = Base auto calculates the duration | number = Specific time | VJ.SET = Randomized between the 2 numbers
ENT.LeapAttackReps = 1 -- How many times does it run the leap attack code?
ENT.LeapAttackExtraTimers = false -- Extra leap attack timers, EX: {1, 1.4}
ENT.LeapAttackStopOnHit = true -- Should it stop executing the leap attack after it hits an enemy?
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Sound ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasSounds = true -- Can it play sounds? | false = Disable ALL sounds
ENT.DamageByPlayerDispositionLevel = 1 -- When should it play "DamageByPlayer" sounds? | 0 = Always | 1 = ONLY when friendly to player | 2 = ONLY when enemy to player
	-- ====== Footstep Sound ====== --
ENT.HasFootstepSounds = true -- Can it play footstep sounds?
ENT.DisableFootStepSoundTimer = false -- Disables the timer system, allowing to utilize model events
ENT.FootstepSoundTimerWalk = 1 -- Delay between footstep sounds while it is walking | false = Disable while walking
ENT.FootstepSoundTimerRun = 0.5 -- Delay between footstep sounds while it is running | false = Disable while running
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
ENT.HasMeleeAttackSounds = true -- Can it play melee attack sounds? | Controls "self.SoundTbl_BeforeMeleeAttack", "self.SoundTbl_MeleeAttack", "self.SoundTbl_MeleeAttackExtra"
ENT.HasExtraMeleeAttackSounds = false -- Can it play extra melee attack sound effects?
ENT.HasMeleeAttackMissSounds = true -- Can it play melee attack miss sounds?
ENT.HasMeleeAttackPlayerSpeedSounds = true -- Does it have a sound when it slows down the player?
ENT.HasRangeAttackSounds = true -- Can it play range attack sounds? | Controls "self.SoundTbl_BeforeRangeAttack", "self.SoundTbl_RangeAttack"
ENT.HasBeforeLeapAttackSounds = true -- Can it play leap attack before jump sounds?
ENT.HasLeapAttackJumpSounds = true -- Can it play leap attack jump sounds?
ENT.HasLeapAttackDamageSounds = true -- Can it play leap attack damage sounds?
ENT.HasLeapAttackDamageMissSounds = true -- Can it play leap attack miss sounds?
ENT.HasAllyDeathSounds = true -- Can it play sounds when an ally dies?
ENT.HasPainSounds = true -- Can it play pain sounds?
ENT.HasImpactSounds = true -- Can it play impact sound effects?
ENT.HasDamageByPlayerSounds = true -- Can it play sounds when it's damaged by a player?
ENT.HasDeathSounds = true -- Can it play death sounds?
	-- ====== Sound Paths ====== --
	-- There are 2 types of sounds: "SPEECH" and "EFFECT" | Most sound tables are "SPEECH" unless stated
		-- SPEECH : Mostly play speech sounds | Will stop when another speech sound is played
		-- EFFECT : Mostly play sound effects | EX: Movement sound, impact sound, attack swipe sound, etc.
ENT.SoundTbl_SoundTrack = false
ENT.SoundTbl_FootStep = false -- EFFECT
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
ENT.SoundTbl_BeforeMeleeAttack = false
ENT.SoundTbl_MeleeAttack = false
ENT.SoundTbl_MeleeAttackExtra = "Zombie.AttackHit" -- EFFECT
ENT.SoundTbl_MeleeAttackMiss = false -- EFFECT
ENT.SoundTbl_MeleeAttackPlayerSpeed = "vj_base/player/heartbeat_loop.wav"
ENT.SoundTbl_BeforeRangeAttack = false
ENT.SoundTbl_RangeAttack = false
ENT.SoundTbl_BeforeLeapAttack = false
ENT.SoundTbl_LeapAttackJump = false
ENT.SoundTbl_LeapAttackDamage = false -- EFFECT
ENT.SoundTbl_LeapAttackDamageMiss = false -- EFFECT
ENT.SoundTbl_KilledEnemy = false
ENT.SoundTbl_AllyDeath = false
ENT.SoundTbl_Pain = false
ENT.SoundTbl_Impact = "VJ.Impact.Flesh_Alien" -- EFFECT
ENT.SoundTbl_DamageByPlayer = false
ENT.SoundTbl_Death = false
	-- ====== Sound Chance ====== --
	-- Higher number = less chance of playing | 1 = Always play
ENT.IdleSoundChance = 2
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
ENT.BeforeRangeAttackSoundChance = 1
ENT.RangeAttackSoundChance = 1
ENT.BeforeLeapAttackSoundChance = 1
ENT.LeapAttackJumpSoundChance = 1
ENT.LeapAttackDamageSoundChance = 1
ENT.LeapAttackDamageMissSoundChance = 1
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
ENT.NextSoundTime_Idle = VJ.SET(4, 11)
ENT.NextSoundTime_Investigate = VJ.SET(5, 5)
ENT.NextSoundTime_LostEnemy = VJ.SET(5, 6)
ENT.NextSoundTime_Alert = VJ.SET(2, 3)
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
ENT.MeleeAttackPlayerSpeedSoundLevel = 100
ENT.BeforeRangeAttackSoundLevel = 75
ENT.RangeAttackSoundLevel = 75
ENT.BeforeLeapAttackSoundLevel = 75
ENT.LeapAttackJumpSoundLevel = 75
ENT.LeapAttackDamageSoundLevel = 75
ENT.LeapAttackDamageMissSoundLevel = 75
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
ENT.MeleeAttackSoundPitch = false
ENT.ExtraMeleeSoundPitch = VJ.SET(80, 100)
ENT.MeleeAttackMissSoundPitch = VJ.SET(90, 100)
ENT.BeforeRangeAttackPitch = false
ENT.RangeAttackPitch = false
ENT.BeforeLeapAttackSoundPitch = false
ENT.LeapAttackJumpSoundPitch = false
ENT.LeapAttackDamageSoundPitch = false
ENT.LeapAttackDamageMissSoundPitch = false
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
-- UNCOMMENT TO USE | Called whenever VJ.CreateSound or VJ.EmitSound is called | return a new file path to replace the one that is about to play
-- function ENT:OnPlaySound(sdFile) return "example/sound.wav" end
---------------------------------------------------------------------------------------------------------------------------------------------
-- UNCOMMENT TO USE | Called whenever a sound starts playing through VJ.CreateSound
-- function ENT:OnCreateSound(sdData, sdFile) end
---------------------------------------------------------------------------------------------------------------------------------------------
-- UNCOMMENT TO USE | Called whenever a sound starts playing through VJ.EmitSound
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
-- function ENT:OnThinkAttack(isAttacking, enemy) end
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
function ENT:CustomAttackCheck_RangeAttack() return true end -- Not returning true will not let the range attack code run!
---------------------------------------------------------------------------------------------------------------------------------------------
--[[
Called when range attack is triggered

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
function ENT:OnRangeAttack(status, enemy) end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[
Called when range attack is executed

=-=-=| PARAMETERS |=-=-=
	1. status [string] : Type of update that is occurring, holds one of the following states:
		-> "Init" : When the attack initially executed | Before entities are checked and damaged
			RETURNS
				-> [nil | boolean] : Return true to skip spawning the projectile
		-> "PreProjSpawn" : Right before "Spawn()" is called on the projectile
			PARAMETERS
				3. projectile [entity] : The projectile entity that is about to spawn
			RETURNS
				-> [nil]
		-> "PostProjSpawn" : After "Spawn()" is called and velocity is set on the projectile
			PARAMETERS
				3. projectile [entity] : The projectile entity that just spawned
			RETURNS
				-> [nil]
	2. enemy [entity] : Enemy that it's about to fire at
	3. projectile [nil | entity] : Depends on `status` value, refer to it for more details

=-=-=| RETURNS |=-=-=
	-> [nil | boolean] : Depends on `status` value, refer to it for more details
--]]
function ENT:OnRangeAttackExecute(status, enemy, projectile) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjPos(projectile)
	// return self:GetAttachment(self:LookupAttachment("muzzle")).Pos -- Attachment example
	return self:GetPos() + self:GetUp() * 20
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjVel(projectile)
	-- Use curve if the projectile has physics, otherwise use a simple line
	local phys = projectile:GetPhysicsObject()
	if IsValid(phys) && phys:IsGravityEnabled() then
		return VJ.CalculateTrajectory(self, self:GetEnemy(), "Curve", projectile:GetPos(), 1, 10)
	end
	return VJ.CalculateTrajectory(self, self:GetEnemy(), "Line", projectile:GetPos(), 1, 1500)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomAttackCheck_LeapAttack() return true end -- Not returning true will not let the leap attack code run!
---------------------------------------------------------------------------------------------------------------------------------------------
--[[
Called when leap attack is triggered

=-=-=| PARAMETERS |=-=-=
	1. status [string] : Type of update that is occurring, holds one of the following states:
		-> "Init" : When the attack initially starts | Before sound, timers, and animations are set!
			RETURNS
				-> [nil]
		-> "PostInit" : After the sound, timers, and animations are set!
			RETURNS
				-> [nil]
		-> "Jump" : When the leap velocity is about to apply
			RETURNS
				-> [nil | vector] : Return a vector to override the velocity
	2. enemy [entity] : Enemy that caused the attack to trigger

=-=-=| RETURNS |=-=-=
	-> [nil | vector] : Depends on `status` value, refer to it for more details
--]]
function ENT:OnLeapAttack(status, enemy) end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[
Called when leap attack is executed

=-=-=| PARAMETERS |=-=-=
	1. status [string] : Type of update that is occurring, holds one of the following states:
		-> "Init" : When the attack initially executed | Before entities are checked and damaged
			RETURNS
				-> [nil]
		-> "PreDamage" : Right before the damage is applied to an entity
			PARAMETERS
				2. ent [entity] : The entity that is about to be damaged
			RETURNS
				-> [nil | boolean] : Return true to skip hitting this entity
		-> "Miss" : When the attack misses and doesn't hit anything
			RETURNS
				-> [nil]
	2. ent [nil | entity] : Depends on `status` value, refer to it for more details

=-=-=| RETURNS |=-=-=
	-> [nil | boolean] : Depends on `status` value, refer to it for more details
--]]
function ENT:OnLeapAttackExecute(status, ent) end
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
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpseEnt) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt)
	//ply:ChatPrint("CTRL + MOUSE2: Rocket Attack") -- Example key binding message
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetAnimationTranslations(wepHoldType) end
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
local VJ_STATE_NONE = VJ_STATE_NONE
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

ENT.MeleeAttack_IsPropAttack = false
ENT.PropInteraction_Found = false
ENT.PropInteraction_NextCheckT = 0
ENT.IsAbleToRangeAttack = true
ENT.IsAbleToLeapAttack = true
ENT.LeapAttackHasJumped = false
//ENT.EatingData = {} -- Set later

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
local vj_npc_melee_bleed = GetConVar("vj_npc_melee_bleed")
local vj_npc_melee_ply_speed = GetConVar("vj_npc_melee_ply_speed")
local vj_npc_wander = GetConVar("vj_npc_wander")
local vj_npc_chase = GetConVar("vj_npc_chase")
local vj_npc_flinch = GetConVar("vj_npc_flinch")
local vj_npc_melee = GetConVar("vj_npc_melee")
local vj_npc_range = GetConVar("vj_npc_range")
local vj_npc_leap = GetConVar("vj_npc_leap")
local vj_npc_blood = GetConVar("vj_npc_blood")
local vj_npc_god = GetConVar("vj_npc_god")
local vj_npc_ply_betray = GetConVar("vj_npc_ply_betray")
local vj_npc_callhelp = GetConVar("vj_npc_callhelp")
local vj_npc_investigate = GetConVar("vj_npc_investigate")
local vj_npc_eat = GetConVar("vj_npc_eat")
local vj_npc_ply_follow = GetConVar("vj_npc_ply_follow")
local vj_npc_ply_chat = GetConVar("vj_npc_ply_chat")
local vj_npc_medic = GetConVar("vj_npc_medic")
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
local vj_npc_snd_melee = GetConVar("vj_npc_snd_melee")
local vj_npc_snd_plyspeed = GetConVar("vj_npc_snd_plyspeed")
local vj_npc_snd_range = GetConVar("vj_npc_snd_range")
local vj_npc_snd_leap = GetConVar("vj_npc_snd_leap")
local vj_npc_snd_pain = GetConVar("vj_npc_snd_pain")
local vj_npc_snd_death = GetConVar("vj_npc_snd_death")
local vj_npc_snd_plyfollow = GetConVar("vj_npc_snd_plyfollow")
local vj_npc_snd_plybetrayal = GetConVar("vj_npc_snd_plybetrayal")
local vj_npc_snd_plydamage = GetConVar("vj_npc_snd_plydamage")
local vj_npc_snd_plysight = GetConVar("vj_npc_snd_plysight")
local vj_npc_snd_medic = GetConVar("vj_npc_snd_medic")
local vj_npc_snd_callhelp = GetConVar("vj_npc_snd_callhelp")
local vj_npc_snd_receiveorder = GetConVar("vj_npc_snd_receiveorder")
local vj_npc_creature_opendoor = GetConVar("vj_npc_creature_opendoor")
local vj_npc_melee_propint = GetConVar("vj_npc_melee_propint")
local vj_npc_corpse_collision = GetConVar("vj_npc_corpse_collision")
local vj_npc_debug_engine = GetConVar("vj_npc_debug_engine")
local vj_npc_difficulty = GetConVar("vj_npc_difficulty")
local vj_npc_sight_distance = GetConVar("vj_npc_sight_distance")
local vj_npc_health = GetConVar("vj_npc_health")
local vj_npc_melee_ply_dsp = GetConVar("vj_npc_melee_ply_dsp")
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
	if vj_npc_melee_bleed:GetInt() == 0 then self.MeleeAttackBleedEnemy = false end
	if vj_npc_melee_ply_dsp:GetInt() == 0 then self.MeleeAttackDSP = false end
	if vj_npc_melee_ply_speed:GetInt() == 0 then self.MeleeAttackPlayerSpeed = false end
	if vj_npc_wander:GetInt() == 0 then self.DisableWandering = true end
	if vj_npc_chase:GetInt() == 0 then self.DisableChasingEnemy = true end
	if vj_npc_flinch:GetInt() == 0 then self.CanFlinch = false end
	if vj_npc_melee:GetInt() == 0 then self.HasMeleeAttack = false end
	if vj_npc_range:GetInt() == 0 then self.HasRangeAttack = false end
	if vj_npc_leap:GetInt() == 0 then self.HasLeapAttack = false end
	if vj_npc_blood:GetInt() == 0 then self.Bleeds = false end
	if vj_npc_god:GetInt() == 1 then self.GodMode = true end
	if vj_npc_ply_betray:GetInt() == 0 then self.BecomeEnemyToPlayer = false end
	if vj_npc_callhelp:GetInt() == 0 then self.CallForHelp = false end
	if vj_npc_investigate:GetInt() == 0 then self.CanInvestigate = false end
	if vj_npc_eat:GetInt() == 0 then self.CanEat = false end
	if vj_npc_ply_follow:GetInt() == 0 then self.FollowPlayer = false end
	if vj_npc_ply_chat:GetInt() == 0 then self.CanChatMessage = false end
	if vj_npc_medic:GetInt() == 0 then self.IsMedic = false end
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
	if vj_npc_snd_melee:GetInt() == 0 then self.HasMeleeAttackSounds = false self.HasExtraMeleeAttackSounds = false self.HasMeleeAttackMissSounds = false end
	if vj_npc_snd_plyspeed:GetInt() == 0 then self.HasMeleeAttackPlayerSpeedSounds = false end
	if vj_npc_snd_range:GetInt() == 0 then self.HasRangeAttackSounds = false end
	if vj_npc_snd_leap:GetInt() == 0 then self.HasBeforeLeapAttackSounds = false self.HasLeapAttackJumpSounds = false self.HasLeapAttackDamageSounds = false self.HasLeapAttackDamageMissSounds = false end
	if vj_npc_snd_pain:GetInt() == 0 then self.HasPainSounds = false end
	if vj_npc_snd_death:GetInt() == 0 then self.HasDeathSounds = false end
	if vj_npc_snd_plyfollow:GetInt() == 0 then self.HasFollowPlayerSounds = false end
	if vj_npc_snd_plybetrayal:GetInt() == 0 then self.HasBecomeEnemyToPlayerSounds = false end
	if vj_npc_snd_plydamage:GetInt() == 0 then self.HasDamageByPlayerSounds = false end
	if vj_npc_snd_plysight:GetInt() == 0 then self.HasOnPlayerSightSounds = false end
	if vj_npc_snd_medic:GetInt() == 0 then self.HasMedicSounds = false end
	if vj_npc_snd_callhelp:GetInt() == 0 then self.HasCallForHelpSounds = false end
	if vj_npc_snd_receiveorder:GetInt() == 0 then self.HasReceiveOrderSounds = false end
	if vj_npc_creature_opendoor:GetInt() == 0 then self.CanOpenDoors = false end
	local propAPType = vj_npc_melee_propint:GetInt()
	if propAPType != 1 then
		if propAPType == 0 then -- Disable
			self.PropInteraction = false
		elseif propAPType == 2 && self.PropInteraction != "OnlyPush" then -- Only damage
			if self.PropInteraction == "OnlyDamage" then
				self.PropInteraction = false
			else
				self.PropInteraction = "OnlyDamage"
			end
		elseif propAPType == 3 && self.PropInteraction != "OnlyDamage" then -- Only push
			if self.PropInteraction == "OnlyPush" then
				self.PropInteraction = false
			else
				self.PropInteraction = "OnlyPush"
			end
		end
	end
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
	if self.CustomOnAcceptInput then self.OnInput = function(_, key, activator, caller, data) self:CustomOnAcceptInput(key, activator, caller, data) end end
	if self.CustomOnHandleAnimEvent then self.OnAnimEvent = function(_, ev, evTime, evCycle, evType, evOptions) self:CustomOnHandleAnimEvent(ev, evTime, evCycle, evType, evOptions) end end
	if self.CustomOnDeath_AfterCorpseSpawned then self.OnCreateDeathCorpse = function(_, dmginfo, hitgroup, corpseEnt) self:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt) end end
	if self.HasHealthRegeneration then self.HealthRegenParams.Enabled = true end
	if self.HealthRegenerationAmount then self.HealthRegenParams.Amount = self.HealthRegenerationAmount end
	if self.HealthRegenerationDelay then self.HealthRegenParams.Delay = self.HealthRegenerationDelay end
	if self.HealthRegenerationResetOnDmg then self.HealthRegenParams.ResetOnDmg = self.HealthRegenerationResetOnDmg end
	if self.FriendsWithAllPlayerAllies != nil then self.AlliedWithPlayerAllies = self.FriendsWithAllPlayerAllies end
	if self.Medic_CanBeHealed == false then self.VJ_ID_Healable = false end
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
	if self.SoundTbl_MedicAfterHeal != nil then self.SoundTbl_MedicOnHeal = self.SoundTbl_MedicAfterHeal end
	if self.MedicAfterHealSoundChance != nil then self.MedicOnHealSoundChance = self.MedicAfterHealSoundChance end
	if self.BeforeHealSoundLevel != nil then self.MedicBeforeHealSoundLevel = self.BeforeHealSoundLevel end
	if self.AfterHealSoundLevel != nil then self.MedicOnHealSoundLevel = self.AfterHealSoundLevel end
	if self.BeforeHealSoundPitch != nil then self.MedicBeforeHealSoundPitch = self.BeforeHealSoundPitch end
	if self.AfterHealSoundPitch != nil then self.MedicOnHealSoundPitch = self.AfterHealSoundPitch end
	if self.Immune_Physics then self:SetPhysicsDamageScale(0) end
	if self.SlowPlayerOnMeleeAttack then self.MeleeAttackPlayerSpeed = true end
	if self.SlowPlayerOnMeleeAttack_WalkSpeed then self.MeleeAttackPlayerSpeedWalk = self.SlowPlayerOnMeleeAttack_WalkSpeed end
	if self.SlowPlayerOnMeleeAttack_RunSpeed then self.MeleeAttackPlayerSpeedRun = self.SlowPlayerOnMeleeAttack_RunSpeed end
	if self.SlowPlayerOnMeleeAttackTime then self.MeleeAttackPlayerSpeedTime = self.SlowPlayerOnMeleeAttackTime end
	if self.HasMeleeAttackSlowPlayerSound != nil then self.HasMeleeAttackPlayerSpeedSounds = self.HasMeleeAttackSlowPlayerSound end
	if self.SoundTbl_MeleeAttackSlowPlayer != nil then self.SoundTbl_MeleeAttackPlayerSpeed = self.SoundTbl_MeleeAttackSlowPlayer end
	if self.MeleeAttackSlowPlayerSoundLevel != nil then self.MeleeAttackPlayerSpeedSoundLevel = self.MeleeAttackSlowPlayerSoundLevel end
	if self.StopMeleeAttackAfterFirstHit != nil then self.MeleeAttackStopOnHit = self.StopMeleeAttackAfterFirstHit end
	if self.StopLeapAttackAfterFirstHit != nil then self.LeapAttackStopOnHit = self.StopLeapAttackAfterFirstHit end
	if self.NextLeapAttackTime_DoRand then self.NextLeapAttackTime = VJ.SET(self.NextLeapAttackTime, self.NextLeapAttackTime_DoRand) end
	if self.NextAnyAttackTime_Leap_DoRand then self.NextAnyAttackTime_Leap = VJ.SET(self.NextAnyAttackTime_Leap, self.NextAnyAttackTime_Leap_DoRand) end
	if self.NextRangeAttackTime_DoRand then self.NextRangeAttackTime = VJ.SET(self.NextRangeAttackTime, self.NextRangeAttackTime_DoRand) end
	if self.NextAnyAttackTime_Range_DoRand then self.NextAnyAttackTime_Range = VJ.SET(self.NextAnyAttackTime_Range, self.NextAnyAttackTime_Range_DoRand) end
	if self.MeleeAttackDSPSoundType != nil then self.MeleeAttackDSP = self.MeleeAttackDSPSoundType end
	if self.MeleeAttackDSPSoundUseDamage == false then self.MeleeAttackDSPLimit = false end
	if self.MeleeAttackDSPSoundUseDamageAmount then self.MeleeAttackDSPLimit = self.MeleeAttackDSPSoundUseDamageAmount end
	if self.DisableMeleeAttackAnimation == true then self.AnimTbl_MeleeAttack = false end
	if self.DisableRangeAttackAnimation == true then self.AnimTbl_RangeAttack = false end
	if self.DisableLeapAttackAnimation == true then self.AnimTbl_LeapAttack = false end
	if self.RangeAttackEntityToSpawn then self.RangeAttackProjectiles = self.RangeAttackEntityToSpawn end
	if self.RangeDistance then self.RangeAttackMaxDistance = self.RangeDistance end
	if self.RangeToMeleeDistance then self.RangeAttackMinDistance = self.RangeToMeleeDistance end
	if self.LeapDistance then self.LeapAttackMaxDistance = self.LeapDistance end
	if self.LeapToMeleeDistance then self.LeapAttackMinDistance = self.LeapToMeleeDistance end
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
	if self.PropAP_MaxSize then self.PropInteraction_MaxScale = self.PropAP_MaxSize end
	if self.AttackProps == false or self.PushProps == false then
		if self.AttackProps == false && self.PushProps == false then
			self.PropInteraction = false
		elseif self.AttackProps == false then
			self.PropInteraction = "OnlyPush"
		elseif self.PushProps == false then
			self.PropInteraction = "OnlyDamage"
		end
	end
	if self.NoChaseAfterCertainRange then self.LimitChaseDistance = self.NoChaseAfterCertainRange end
	if self.NoChaseAfterCertainRange_CloseDistance then self.LimitChaseDistance_Min = self.NoChaseAfterCertainRange_CloseDistance end
	if self.NoChaseAfterCertainRange_FarDistance then self.LimitChaseDistance_Max = self.NoChaseAfterCertainRange_FarDistance end
	if self.NoChaseAfterCertainRange_Type then
		if self.NoChaseAfterCertainRange_Type == "Regular" then
			self.LimitChaseDistance = true
		elseif self.NoChaseAfterCertainRange_Type == "OnlyRange" then
			self.LimitChaseDistance = "OnlyRange"
		end
	end
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
	if self.OnlyDoKillEnemyWhenClear != nil then self.KilledEnemySoundLast = self.OnlyDoKillEnemyWhenClear end
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
		-- Only do this if "self.OnFootstepSound" isn't already being used
		self.OnFootstepSound = function()
			util.ScreenShake(self:GetPos(), self.WorldShakeOnMoveAmplitude or 10, self.WorldShakeOnMoveFrequency or 100, self.WorldShakeOnMoveDuration or 0.4, self.WorldShakeOnMoveRadius or 1000)
		end
	end
	if self.MeleeAttackWorldShakeOnMiss then
		local orgFunc = self.CustomOnMeleeAttack_Miss -- If it already exists then override it
		self.CustomOnMeleeAttack_Miss = function()
			orgFunc(self)
			util.ScreenShake(self:GetPos(), self.MeleeAttackWorldShakeOnMissAmplitude or 16, 100, self.MeleeAttackWorldShakeOnMissDuration or 1, self.MeleeAttackWorldShakeOnMissRadius or 2000)
		end
	end
	if self.MeleeAttackKnockBack_Forward1 or self.MeleeAttackKnockBack_Forward2 or self.MeleeAttackKnockBack_Up1 or self.MeleeAttackKnockBack_Up2 then
		self.MeleeAttackKnockbackVelocity = function()
			return self:GetForward()*math.random(self.MeleeAttackKnockBack_Forward1 or 100, self.MeleeAttackKnockBack_Forward2 or 100) + self:GetUp()*math.random(self.MeleeAttackKnockBack_Up1 or 10, self.MeleeAttackKnockBack_Up2 or 10) + self:GetRight()*math.random(self.MeleeAttackKnockBack_Right1 or 0, self.MeleeAttackKnockBack_Right2 or 0)
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
	if self.RangeUseAttachmentForPos then
		self.RangeAttackProjPos = function(_, projectile)
			return self:GetAttachment(self:LookupAttachment(self.RangeUseAttachmentForPosID)).Pos
		end
	elseif self.RangeAttackPos_Up or self.RangeAttackPos_Forward or self.RangeAttackPos_Right then
		self.RangeAttackProjPos = function(_, projectile)
			return self:GetPos() + self:GetUp()*(self.RangeAttackPos_Up or 20) + self:GetForward()*(self.RangeAttackPos_Forward or 0) + self:GetRight()*(self.RangeAttackPos_Right or 0)
		end
	end
	if self.RangeAttackCode_GetShootPos then
		self.RangeAttackProjVel = function(_, projectile)
			return self.RangeAttackCode_GetShootPos(self, projectile)
		end
	end
	if self.LeapAttackVelocityForward or self.LeapAttackVelocityUp or self.CustomOnLeapAttack_BeforeStartTimer or self.CustomOnLeapAttack_AfterStartTimer then
		self.OnLeapAttack = function(_, status, enemy)
			if status == "Init" && self.CustomOnLeapAttack_BeforeStartTimer then
				self:CustomOnLeapAttack_BeforeStartTimer(self.AttackSeed)
			elseif status == "PostInit" && self.CustomOnLeapAttack_AfterStartTimer then
				self:CustomOnLeapAttack_AfterStartTimer(self.AttackSeed)
			elseif status == "Jump" && (self.LeapAttackVelocityForward or self.LeapAttackVelocityUp) then
				local ene = self:GetEnemy()
				return ((ene:GetPos() + ene:OBBCenter()) - (self:GetPos() + self:OBBCenter())):GetNormal()*400 + self:GetForward()*(self.LeapAttackVelocityForward or 2000) + self:GetUp()*(self.LeapAttackVelocityUp or 200)
			end
		end
	end
	if self.CustomOnLeapAttack_BeforeChecks or self.CustomOnLeapAttack_AfterChecks or self.CustomOnLeapAttack_Miss then
		self.OnLeapAttackExecute = function(_, status, ent)
			if status == "Init" && self.CustomOnLeapAttack_BeforeChecks then
				self:CustomOnLeapAttack_BeforeChecks()
			elseif status == "PreDamage" && self.CustomOnLeapAttack_AfterChecks then
				self:CustomOnLeapAttack_AfterChecks(ent)
			elseif status == "Miss" && self.CustomOnLeapAttack_Miss then
				self:CustomOnLeapAttack_Miss()
			end
		end
	end
	if self.CustomAttack or self.MultipleMeleeAttacks or self.MultipleRangeAttacks or self.MultipleLeapAttacks then
		self.OnThinkAttack = function(_, isAttacking, enemy)
			if self.CustomAttack then self:CustomAttack(enemy, self.EnemyData.Visible) end
			if isAttacking then return end
			if self.MultipleMeleeAttacks then self:MultipleMeleeAttacks() end
			if self.MultipleRangeAttacks then self:MultipleRangeAttacks() end
			if self.MultipleLeapAttacks then self:MultipleLeapAttacks() end
		end
	end
	if self.CustomOnRangeAttack_BeforeStartTimer or self.CustomOnRangeAttack_AfterStartTimer then
		self.OnRangeAttack = function(_, status, enemy)
			if status == "Init" && self.CustomOnRangeAttack_BeforeStartTimer then
				self:CustomOnRangeAttack_BeforeStartTimer(self.AttackSeed)
			elseif status == "PostInit" && self.CustomOnRangeAttack_AfterStartTimer then
				self:CustomOnRangeAttack_AfterStartTimer(self.AttackSeed)
			end
		end
	end
	if self.DisableDefaultRangeAttackCode or self.CustomRangeAttackCode or self.CustomRangeAttackCode_BeforeProjectileSpawn or self.CustomRangeAttackCode_AfterProjectileSpawn then
		self.OnRangeAttackExecute = function(_, status, enemy, projectile)
			if status == "Init" && (self.CustomRangeAttackCode or self.DisableDefaultRangeAttackCode) then
				if self.CustomRangeAttackCode then
					self:CustomRangeAttackCode()
				end
				if self.DisableDefaultRangeAttackCode then
					return true
				end
			elseif status == "PreProjSpawn" && self.CustomRangeAttackCode_BeforeProjectileSpawn then
				self:CustomRangeAttackCode_BeforeProjectileSpawn(projectile)
			elseif status == "PostProjSpawn" && self.CustomRangeAttackCode_AfterProjectileSpawn then
				self:CustomRangeAttackCode_AfterProjectileSpawn(projectile)
			end
		end
	end
	-- !!!!!!!!!!!!!! DO NOT USE ANY OF THESE !!!!!!!!!!!!!! [Backwards Compatibility!]
end
---------------------------------------------------------------------------------------------------------------------------------------------
local defShootVec = Vector(0, 0, 55)
local capBitsDefault = bit.bor(CAP_SKIP_NAV_GROUND_CHECK, CAP_TURN_HEAD)
local capBitsDoors = bit.bor(CAP_OPEN_DOORS, CAP_AUTO_DOORS, CAP_USE)
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
			
			self:UpdateAnimationTranslations()
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
			if VJ.AnimExists(self, ACT_JUMP) or self.UsePoseParameterMovement then self:CapabilitiesAdd(CAP_MOVE_JUMP) end
			if VJ.AnimExists(self, ACT_CLIMB_UP) then self:CapabilitiesAdd(CAP_MOVE_CLIMB) end
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
				//self:RememberUnreachable(ene, 0)
				self:SCHEDULE_ALERT_CHASE(false)
			end
		end
		self:StartSchedule(schedule_alert_chaseLOS)
	else
		schedule_alert_chase.RunCode_OnFail = function() if self.SCHEDULE_IDLE_STAND then self:SCHEDULE_IDLE_STAND() end end
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
	if selfData.HasMeleeAttack && eneData.DistanceNearest < selfData.MeleeAttackDistance && eneData.Visible && (self:GetInternalVariable("m_latchedHeadDirection"):Dot((ene:GetPos() - self:GetPos()):GetNormalized()) > math_cos(math_rad(selfData.MeleeAttackAngleRadius))) then
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
	
	-- If the enemy is not reachable then wander around
	if self:IsUnreachable(ene) then
		if selfData.HasRangeAttack then -- Ranged NPCs
			self:SCHEDULE_ALERT_CHASE(true)
		elseif math.random(1, 30) == 1 && !self:IsMoving() then
			selfData.NextWanderTime = 0
			self:MaintainIdleBehavior(1)
			self:RememberUnreachable(ene, 4)
		else
			self:SCHEDULE_IDLE_STAND()
		end
	else -- Is reachable, so chase the enemy!
		self:SCHEDULE_ALERT_CHASE()
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
	-- Handle translations table
	local translation = self.AnimationTranslations[act]
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
	[VJ.ATTACK_TYPE_RANGE] = function(self, skipStopAttacks)
		if !skipStopAttacks then
			timer.Create("attack_range_reset" .. self:EntIndex(), self:GetAttackTimer(self.NextAnyAttackTime_Range, self.TimeUntilRangeAttackProjectileRelease, self.AttackAnimDuration), 1, function()
				self:StopAttacks()
				self:MaintainAlertBehavior()
			end)
		end
		timer.Create("attack_range_reset_able" .. self:EntIndex(), self:GetAttackTimer(self.NextRangeAttackTime), 1, function()
			self.IsAbleToRangeAttack = true
		end)
	end,
	[VJ.ATTACK_TYPE_LEAP] = function(self, skipStopAttacks)
		if !skipStopAttacks then
			timer.Create("attack_leap_reset" .. self:EntIndex(), self:GetAttackTimer(self.NextAnyAttackTime_Leap, self.TimeUntilLeapAttackDamage, self.AttackAnimDuration), 1, function()
				self:StopAttacks()
				self:MaintainAlertBehavior()
			end)
		end
		timer.Create("attack_leap_reset_able" .. self:EntIndex(), self:GetAttackTimer(self.NextLeapAttackTime), 1, function()
			self.IsAbleToLeapAttack = true
		end)
	end
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	/*
	local newEyeOffset = self:WorldToLocal(self:GetAttachment(self:LookupAttachment("mouth")).Pos)
	self:SetViewOffset(newEyeOffset)
	self:SetSaveValue("m_vDefaultEyeOffset", newEyeOffset)
	*/
	
	//if self.NextActualThink <= CurTime() then
		//self.NextActualThink = CurTime() + 0.065
	
	-- Schedule debug
	//if self.CurrentSchedule then PrintTable(self.CurrentSchedule) end
	//if self.CurrentTask then PrintTable(self.CurrentTask) end
	
	//self:SetCondition(1) -- Probably not needed as "sv_pvsskipanimation" handles it | Fix attachments, bones, positions, angles etc. being broken in NPCs! This condition is used as a backup in case "sv_pvsskipanimation" isn't disabled!
	//if self.MovementType == VJ_MOVETYPE_GROUND && self:GetVelocity():Length() <= 0 && !self:IsEFlagSet(EFL_IS_BEING_LIFTED_BY_BARNACLE) /*&& curSchedule.HasMovement*/ then self:DropToFloor() end -- No need, already handled by the engine
	
	local curTime = CurTime()
	local selfData = self:GetTable()
	
	-- This is here to make sure the initialized process time stays in place...
	-- otherwise if AI is disabled then reenabled, all the NPCs will now start processing at the same exact CurTime!
	local doHeavyProcesses = curTime > selfData.NextProcessT
	if doHeavyProcesses then
		selfData.NextProcessT = curTime + selfData.NextProcessTime
	end
	
	-- Breath sound system
	if !selfData.Dead && selfData.HasBreathSound && selfData.HasSounds && curTime > selfData.NextBreathSoundT then
		local pickedSD = PICK(selfData.SoundTbl_Breath)
		local dur = 10 -- Make the default value large so we don't check it too much!
		if pickedSD then
			StopSD(selfData.CurrentBreathSound)
			dur = (selfData.NextSoundTime_Breath == false and SoundDuration(pickedSD)) or math.Rand(selfData.NextSoundTime_Breath.a, selfData.NextSoundTime_Breath.b)
			selfData.CurrentBreathSound = VJ.CreateSound(self, pickedSD, selfData.BreathSoundLevel, self:GetSoundPitch(selfData.BreathSoundPitch))
		end
		selfData.NextBreathSoundT = curTime + dur
	end
	
	self:OnThink()
	--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
	local moveType = selfData.MovementType
	local moveTypeAA = moveType == VJ_MOVETYPE_AERIAL or moveType == VJ_MOVETYPE_AQUATIC
	if VJ_CVAR_AI_ENABLED && self:GetState() != VJ_STATE_FREEZE && !self:IsEFlagSet(EFL_IS_BEING_LIFTED_BY_BARNACLE) then
		if selfData.VJ_DEBUG then
			if GetConVar("vj_npc_debug_enemy"):GetInt() == 1 then VJ.DEBUG_Print(self, false, "Enemy -> " .. tostring(self:GetEnemy() or "NULL") .. " | Alerted? " .. tostring(selfData.Alerted))  end
			if GetConVar("vj_npc_debug_takingcover"):GetInt() == 1 then if curTime > selfData.TakingCoverT then VJ.DEBUG_Print(self, false, "NOT taking cover") else VJ.DEBUG_Print(self, false, "Taking cover ("..selfData.TakingCoverT - curTime..")") end end
			if GetConVar("vj_npc_debug_lastseenenemytime"):GetInt() == 1 then PrintMessage(HUD_PRINTTALK, (curTime - selfData.EnemyData.VisibleTime).." ("..self:GetName()..")") end
		end
		
		//self:SetPlaybackRate(self.AnimationPlaybackRate)
		self:OnThinkActive()
		
		-- For AA move types
		if moveTypeAA then
			local myVelLen = self:GetVelocity():Length()
			if myVelLen > 0 then
				if selfData.AA_CurrentMovePos then
					local dist = selfData.AA_CurrentMovePos:Distance(self:GetPos())
					-- Make sure we are making progress so we don't get stuck in a infinite movement!
					if selfData.AA_CurrentMoveDist == -1 or selfData.AA_CurrentMoveDist >= dist then
						selfData.AA_CurrentMoveDist = dist
						local moveSpeed = selfData.AA_CurrentMoveMaxSpeed
						-- Only decelerate if the distance is smaller than the max speed!
						if selfData.AA_MoveDecelerate > 1 && dist < moveSpeed then
							moveSpeed = math_min(math_max(dist, moveSpeed / selfData.AA_MoveDecelerate), moveSpeed)
						elseif selfData.AA_MoveAccelerate > 0 then
							moveSpeed = Lerp(FrameTime() * selfData.AA_MoveAccelerate, myVelLen, moveSpeed)
						end
						local velPos = selfData.AA_CurrentMovePosDir:GetNormal() * moveSpeed
						local velTimeCur = curTime + (dist / velPos:Length())
						if velTimeCur == velTimeCur then -- Check for NaN
							selfData.AA_CurrentMoveTime = velTimeCur
						end
						self:SetLocalVelocity(velPos)
					-- We are NOT making any progress, stop the movement
					else
						self:AA_StopMoving()
					end
				end
				-- Is aquatic and is NOT completely in water then attempt to go down!
				if moveType == VJ_MOVETYPE_AQUATIC && self:WaterLevel() <= 2 then
					self:AA_IdleWander()
				end
				if selfData.AA_CurrentMoveAnim != -1 then
					self:AA_MoveAnimation()
				end
			-- Not moving, reset its move time!
			else
				selfData.AA_CurrentMoveTime = 0
			end
		end
		
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
							if moveTypeAA then
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
				elseif (curTime - eneData.VisibleTime) > selfData.EnemyTimeout && !selfData.IsVJBaseSNPC_Tank then
					self:PlaySoundSystem("LostEnemy")
					self:ResetEnemy(true, true)
					ene = self:GetEnemy()
					eneValid = IsValid(ene)
				end
			end
			
			-- Eating system
			if selfData.CanEat then
				local eatingData = selfData.EatingData
				if !eatingData then -- Eating data has NOT been initialized, so initialize it!
					self.EatingData = {Target = NULL, NextCheck = 0, AnimStatus = "None", OrgIdle = nil}
						-- AnimStatus: "None" = Not prepared (Probably moving to food location) | "Prepared" = Prepared (Ex: Played crouch down anim) | "Eating" = Prepared and is actively eating
					eatingData = self.EatingData
				end
				if eneValid or selfData.Alerted then
					if selfData.VJ_ST_Eating then
						eatingData.NextCheck = curTime + 15
						self:ResetEatingBehavior("Enemy")
					end
				elseif curTime > eatingData.NextCheck then
					if selfData.VJ_ST_Eating then
						local food = eatingData.Target
						if !IsValid(food) then -- Food no longer exists, reset!
							eatingData.NextCheck = curTime + 10
							self:ResetEatingBehavior("Unspecified")
						elseif !self:IsMoving() then
							local foodDist = VJ.GetNearestDistance(self, food) // myPos:Distance(food:GetPos())
							if foodDist > 400 then -- Food too far away, reset!
								eatingData.NextCheck = curTime + 10
								self:ResetEatingBehavior("Unspecified")
							elseif foodDist > 30 then -- Food moved a bit, go to new location
								if self:IsBusy() then -- Something else has come up, stop eating completely!
									eatingData.NextCheck = curTime + 15
									self:ResetEatingBehavior("Unspecified")
								else
									if eatingData.AnimStatus != "None" then -- We need to play get up anim first!
										eatingData.AnimStatus = "None"
										selfData.AnimationTranslations[ACT_IDLE] = eatingData.OrgIdle -- Reset the idle animation table in case it changed!
										eatingData.NextCheck = curTime + (self:OnEat("StopEating", "HaltOnly") or 1)
									else
										selfData.NextWanderTime = CurTime() + math.Rand(3, 5)
										self:SetState(VJ_STATE_NONE)
										self:SetLastPosition(select(2, VJ.GetNearestPositions(self, food)))
										self:SCHEDULE_GOTO_POSITION("TASK_WALK_PATH")
										//self:SetTarget(food)
										//self:SCHEDULE_GOTO_TARGET("TASK_WALK_PATH")
										eatingData.NextCheck = curTime + 1
									end
								end
							else -- No changes, continue eating
								self:SetTurnTarget(food, 1)
								self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK)
								if eatingData.AnimStatus != "None" then -- We are already prepared, so eat!
									eatingData.AnimStatus = "Eating"
									eatingData.NextCheck = curTime + self:OnEat("Eat")
									if food:Health() <= 0 then -- Finished eating!
										eatingData.NextCheck = curTime + selfData.EatCooldown
										self:ResetEatingBehavior("Devoured")
										food:TakeDamage(100, self, self) -- For entities that react to dmg, Ex: HLR corpses
										food:Remove()
									end
								else -- We need to first prepare before eating! (Ex: Crouch-down animation)
									eatingData.AnimStatus = "Prepared"
									eatingData.NextCheck = curTime + (self:OnEat("BeginEating") or 1)
								end
							end
						end
					elseif funcHasCondition(self, COND_SMELL) && !self:IsMoving() && !self:IsBusy() then
						local hint = sound.GetLoudestSoundHint(SOUND_CARCASS, myPos)
						if hint then
							local food = hint.owner
							if IsValid(food) /*&& !food.VJ_ST_BeingEaten*/ then
								if !food.FoodData then
									local size = food:OBBMaxs():Distance(food:OBBMins()) * 2
									food.FoodData = {
										NumConsumers = 0,
										Size = size,
										SizeRemaining = size,
									}
								end
								//print("food", food, self)
								if food.FoodData.SizeRemaining > 0 && self:OnEat("CheckFood", hint) then
									local foodData = food.FoodData
									foodData.NumConsumers = foodData.NumConsumers + 1
									foodData.SizeRemaining = foodData.SizeRemaining - self:OBBMaxs():Distance(self:OBBMins())
									//PrintTable(hint)
									selfData.VJ_ST_Eating = true
									food.VJ_ST_BeingEaten = true
									selfData.EatingData.OrgIdle = selfData.AnimationTranslations[ACT_IDLE] -- Save the current idle anim table in case we gonna change it while eating!
									eatingData.Target = food
									self:OnEat("StartBehavior")
									self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK)
									selfData.NextWanderTime = curTime + math.Rand(3, 5)
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
				local eneDist = myPos:Distance(enePos)
				local eneDistNear = VJ.GetNearestDistance(self, ene, true)
				local eneIsVisible = plyControlled and true or self:Visible(ene)
				
				-- Set latest enemy information
				self:UpdateEnemyMemory(ene, enePos)
				eneData.Reset = false
				eneData.Visible = eneIsVisible
				eneData.Distance = eneDist
				eneData.DistanceNearest = eneDistNear
				if eneIsVisible && self:IsInViewCone(enePos) && (eneDist < self:GetMaxLookDistance()) then
					eneData.VisibleTime = curTime
					-- Why 2 vars? Because the last "Visible" tick is usually not updated in time, causing the engine to give false positive, thinking the enemy IS visible
					eneData.VisiblePos = eneData.VisiblePosReal
					eneData.VisiblePosReal = ene:EyePos() -- Use EyePos because "Visible" uses it to run the trace in the engine! | For origin, use "self:GetEnemyLastSeenPos()"
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
				
				-- Stop chasing at certain distance
				local limitChase = selfData.LimitChaseDistance
				if limitChase && eneIsVisible && ((limitChase == true) or (limitChase == "OnlyRange" && selfData.HasRangeAttack)) then
					local minDist = selfData.LimitChaseDistance_Min
					local maxDist = selfData.LimitChaseDistance_Max
					if minDist == "UseRangeDistance" then minDist = selfData.RangeAttackMinDistance end
					if maxDist == "UseRangeDistance" then maxDist = selfData.RangeAttackMaxDistance end
					if (eneDist < maxDist) && (eneDist > minDist) then
						-- If the selfData.NextChaseTime is about to expire, then give it 0.5 delay so it does NOT chase!
						if (selfData.NextChaseTime - curTime) < 0.1 then
							selfData.NextChaseTime = curTime + 0.5
						end
						self:MaintainIdleBehavior(2) -- Otherwise it won't play the idle animation and will loop the last PlayAct animation if range attack doesn't use animations!
						if selfData.CurrentScheduleName == "SCHEDULE_ALERT_CHASE" then self:StopMoving() end -- Interrupt enemy chasing because we are in range!
						if moveType == VJ_MOVETYPE_GROUND then
							if !self:IsMoving() && self:OnGround() then
								self:SetTurnTarget("Enemy")
							end
						elseif moveTypeAA then
							if selfData.AA_CurrentMoveType == 3 then self:AA_StopMoving() end -- Interrupt enemy chasing because we are in range!
							if curTime > selfData.AA_CurrentMoveTime then self:AA_IdleWander(true, "Calm", {FaceDest = !selfData.ConstantlyFaceEnemy}) /*self:AA_StopMoving()*/ end -- Only face the position if ConstantlyFaceEnemy is false!
						end
					else
						if selfData.CurrentScheduleName != "SCHEDULE_ALERT_CHASE" then self:MaintainAlertBehavior() end
					end
				end
				
				self:UpdatePoseParamTracking()
				
				-- Attacks
				if !selfData.PauseAttacks && !selfData.Flinching && !selfData.FollowData.StopAct && curTime > selfData.NextDoAnyAttackT && self:GetState() != VJ_STATE_ONLY_ANIMATION_NOATTACK && selfData.Behavior != VJ_BEHAVIOR_PASSIVE && selfData.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE then
					-- Attack priority in order: Custom --> Melee --> Range --> Leap
					local funcThinkAtk = self.OnThinkAttack; if funcThinkAtk then funcThinkAtk(self, !!selfData.AttackType, ene) end
					
					-- Melee Attack
					if selfData.HasMeleeAttack && selfData.IsAbleToMeleeAttack && !selfData.AttackType then
						local atkType = false -- false = No attack | 1 = Normal attack | 2 = Prop attack
						if plyControlled then
							if selfData.VJ_TheController:KeyDown(IN_ATTACK) then
								atkType = 1
							end
						else
							-- Regular non-prop attack
							if eneIsVisible && eneDistNear < selfData.MeleeAttackDistance && self:GetInternalVariable("m_latchedHeadDirection"):Dot((enePos - myPos):GetNormalized()) > math_cos(math_rad(selfData.MeleeAttackAngleRadius)) then
								atkType = 1
							-- Check for possible props that we can attack/push
							elseif curTime > selfData.PropInteraction_NextCheckT then
								local propCheck = self:MaintainPropInteraction()
								if propCheck then
									atkType = 2
								end
								selfData.PropInteraction_Found = propCheck
								selfData.PropInteraction_NextCheckT = curTime + 0.5
							end
						end
						if atkType && self:CustomAttackCheck_MeleeAttack() == true then
							local seed = curTime; selfData.AttackSeed = seed
							selfData.IsAbleToMeleeAttack = false
							selfData.AttackType = VJ.ATTACK_TYPE_MELEE
							selfData.AttackState = VJ.ATTACK_STATE_STARTED
							selfData.AttackAnim = ACT_INVALID
							selfData.AttackAnimDuration = 0
							selfData.AttackAnimTime = 0
							selfData.NextAlertSoundT = curTime + 0.4
							if atkType == 2 then
								selfData.MeleeAttack_IsPropAttack = true
							else
								self:SetTurnTarget("Enemy") -- Always turn towards the enemy at the start
								selfData.MeleeAttack_IsPropAttack = false
							end
							self:CustomOnMeleeAttack_BeforeStartTimer(seed)
							self:PlaySoundSystem("BeforeMeleeAttack")
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
								timer.Create("attack_melee_start" .. self:EntIndex(), selfData.TimeUntilMeleeAttackDamage / selfData.AnimPlaybackRate, selfData.MeleeAttackReps, function() if selfData.AttackSeed == seed then self:ExecuteMeleeAttack(atkType == 2) end end)
								if selfData.MeleeAttackExtraTimers then
									for k, t in ipairs(selfData.MeleeAttackExtraTimers) do
										self:AddExtraAttackTimer("timer_melee_start_"..curTime + k, t, function() if selfData.AttackSeed == seed then self:ExecuteMeleeAttack(atkType == 2) end end)
									end
								end
							end
							self:CustomOnMeleeAttack_AfterStartTimer(seed)
						end
					end
					
					-- Range Attack
					if eneIsVisible && selfData.HasRangeAttack && selfData.IsAbleToRangeAttack && !selfData.AttackType && self:CustomAttackCheck_RangeAttack() == true && ((plyControlled && selfData.VJ_TheController:KeyDown(IN_ATTACK2)) or (!plyControlled && (eneDist < selfData.RangeAttackMaxDistance) && (eneDist > selfData.RangeAttackMinDistance) && (self:GetInternalVariable("m_latchedHeadDirection"):Dot((enePos - myPos):GetNormalized()) > math_cos(math_rad(selfData.RangeAttackAngleRadius))))) then
						local seed = curTime; selfData.AttackSeed = seed
						selfData.IsAbleToRangeAttack = false
						selfData.AttackType = VJ.ATTACK_TYPE_RANGE
						selfData.AttackState = VJ.ATTACK_STATE_STARTED
						selfData.AttackAnim = ACT_INVALID
						selfData.AttackAnimDuration = 0
						selfData.AttackAnimTime = 0
						self:OnRangeAttack("Init", ene)
						self:PlaySoundSystem("BeforeRangeAttack")
						if selfData.AnimTbl_RangeAttack then
							local anim, animDur, animType = self:PlayAnim(selfData.AnimTbl_RangeAttack, false, 0, false, selfData.RangeAttackAnimationDelay)
							if anim != ACT_INVALID then
								selfData.AttackAnim = anim
								selfData.AttackAnimDuration = animDur - (selfData.RangeAttackAnimationDecreaseLengthAmount / selfData.AnimPlaybackRate)
								if animType != ANIM_TYPE_GESTURE then -- Allow things like chasing to continue for gestures
									selfData.AttackAnimTime = curTime + selfData.AttackAnimDuration
								end
							end
						end
						if !selfData.TimeUntilRangeAttackProjectileRelease then
							attackTimers[VJ.ATTACK_TYPE_RANGE](self)
						else -- NOT event based...
							timer.Create("attack_range_start" .. self:EntIndex(), selfData.TimeUntilRangeAttackProjectileRelease / selfData.AnimPlaybackRate, selfData.RangeAttackReps, function() if selfData.AttackSeed == seed then self:ExecuteRangeAttack() end end)
							if selfData.RangeAttackExtraTimers then
								for k, t in ipairs(selfData.RangeAttackExtraTimers) do
									self:AddExtraAttackTimer("timer_range_start_"..curTime + k, t, function() if selfData.AttackSeed == seed then self:ExecuteRangeAttack() end end)
								end
							end
						end
						self:OnRangeAttack("PostInit", ene)
					end
					
					-- Leap Attack
					if eneIsVisible && selfData.HasLeapAttack && selfData.IsAbleToLeapAttack && !selfData.AttackType && self:CustomAttackCheck_LeapAttack() == true && ((plyControlled && selfData.VJ_TheController:KeyDown(IN_JUMP)) or (!plyControlled && (self:IsOnGround() && eneDist < selfData.LeapAttackMaxDistance) && (eneDist > selfData.LeapAttackMinDistance) && (self:GetInternalVariable("m_latchedHeadDirection"):Dot((enePos - myPos):GetNormalized()) > math_cos(math_rad(selfData.LeapAttackAngleRadius))))) then
						local seed = curTime; selfData.AttackSeed = seed
						selfData.IsAbleToLeapAttack = false
						selfData.LeapAttackHasJumped = false
						selfData.AttackType = VJ.ATTACK_TYPE_LEAP
						selfData.AttackState = VJ.ATTACK_STATE_STARTED
						selfData.AttackAnim = ACT_INVALID
						selfData.AttackAnimDuration = 0
						selfData.AttackAnimTime = 0
						self:OnLeapAttack("Init", ene)
						self:PlaySoundSystem("BeforeLeapAttack")
						timer.Create("attack_leap_jump" .. self:EntIndex(), selfData.TimeUntilLeapAttackVelocity / selfData.AnimPlaybackRate, 1, function() self:LeapAttackJump() end)
						if selfData.AnimTbl_LeapAttack then
							local anim, animDur, animType = self:PlayAnim(selfData.AnimTbl_LeapAttack, false, 0, false)
							if anim != ACT_INVALID then
								selfData.AttackAnim = anim
								selfData.AttackAnimDuration = animDur - (selfData.LeapAttackAnimationDecreaseLengthAmount / selfData.AnimPlaybackRate)
								if animType != ANIM_TYPE_GESTURE then -- Allow things like chasing to continue for gestures
									selfData.AttackAnimTime = curTime + selfData.AttackAnimDuration
								end
							end
						end
						if !selfData.TimeUntilLeapAttackDamage then
							attackTimers[VJ.ATTACK_TYPE_LEAP](self)
						else -- NOT event based...
							timer.Create("attack_leap_start" .. self:EntIndex(), selfData.TimeUntilLeapAttackDamage / selfData.AnimPlaybackRate, selfData.LeapAttackReps, function() if selfData.AttackSeed == seed then self:ExecuteLeapAttack() end end)
							if selfData.LeapAttackExtraTimers then
								for k, t in ipairs(selfData.LeapAttackExtraTimers) do
									self:AddExtraAttackTimer("timer_leap_start_"..curTime + k, t, function() if selfData.AttackSeed == seed then self:ExecuteLeapAttack() end end)
								end
							end
						end
						self:OnLeapAttack("PostInit", ene)
					end
				end
				
				-- Face enemy for stationary types OR attacks
				if (moveType == VJ_MOVETYPE_STATIONARY && selfData.CanTurnWhileStationary) or (selfData.AttackType && ((selfData.MeleeAttackAnimationFaceEnemy && !selfData.MeleeAttack_IsPropAttack && selfData.AttackType == VJ.ATTACK_TYPE_MELEE) or (selfData.RangeAttackAnimationFaceEnemy && selfData.AttackType == VJ.ATTACK_TYPE_RANGE) or ((selfData.LeapAttackAnimationFaceEnemy or (selfData.LeapAttackAnimationFaceEnemy == 2 && !selfData.LeapAttackHasJumped)) && selfData.AttackType == VJ.ATTACK_TYPE_LEAP))) then
					self:SetTurnTarget("Enemy")
				end
			else -- No enemy
				if !plyControlled then
					self:UpdatePoseParamTracking(true)
					//self:ClearPoseParameters()
				end
				eneData.TimeAcquired = 0
			end
			
			if moveTypeAA then
				if eneValid && selfData.AttackAnimTime > curTime && eneData.DistanceNearest < selfData.MeleeAttackDistance then
					self:AA_StopMoving()
				else
					self:SelectSchedule()
				end
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
		if selfData.UsePoseParameterMovement && moveType == VJ_MOVETYPE_GROUND then
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
		if moveTypeAA then self:AA_StopMoving() end
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
--------------------------------------------------------------------------------------------------------------------------------------------
local propColBlacklist = {[COLLISION_GROUP_DEBRIS] = true, [COLLISION_GROUP_DEBRIS_TRIGGER] = true, [COLLISION_GROUP_DISSOLVING] = true, [COLLISION_GROUP_IN_VEHICLE] = true, [COLLISION_GROUP_WORLD] = true}
--
function ENT:MaintainPropInteraction(customEnts)
	local behavior = self.PropInteraction
	if !behavior then return false end
	local myPos = self:GetPos()
	local myCenter = myPos + self:OBBCenter()
	for _, ent in ipairs(customEnts or ents.FindInSphere(myCenter, self.MeleeAttackDistance * 1.2)) do
		if ent.VJ_ID_Attackable then
			local vPhys = ent:GetPhysicsObject()
			if IsValid(vPhys) && !propColBlacklist[ent:GetCollisionGroup()] && (customEnts or (self:GetInternalVariable("m_latchedHeadDirection"):Dot((ent:GetPos() - myPos):GetNormalized()) > math_cos(math_rad(self.MeleeAttackAngleRadius / 1.3)))) then
				local tr = util.TraceLine({
					start = myCenter,
					endpos = ent:NearestPoint(myCenter),
					filter = self
				})
				if !tr.HitWorld && !tr.HitSky then
					-- Attacking: Make sure it has health
					if (behavior == true or behavior == "OnlyDamage") && ent:Health() > 0 then
						return true
					end
					-- Pushing: Make sure it's not a small object and the NPC is appropriately sized to push the object
					local surfaceArea = vPhys:GetSurfaceArea() or 900
					if (behavior == true or behavior == "OnlyPush") && ent:GetMoveType() != MOVETYPE_PUSH && surfaceArea > 800 then // && vPhys:GetMass() > 4
						local myPhys = self:GetPhysicsObject()
						if IsValid(myPhys) && (myPhys:GetSurfaceArea() * self.PropInteraction_MaxScale) >= surfaceArea then
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
function ENT:ExecuteMeleeAttack(isPropAttack)
	local selfData = self:GetTable()
	if selfData.Dead or selfData.PauseAttacks or selfData.Flinching or (selfData.MeleeAttackStopOnHit && selfData.AttackState == VJ.ATTACK_STATE_EXECUTED_HIT) then return end
	isPropAttack = isPropAttack or selfData.MeleeAttack_IsPropAttack -- Is this a prop attack?
	self:CustomOnMeleeAttack_BeforeChecks()
	if selfData.DisableDefaultMeleeAttackCode then return end
	local myPos = self:GetPos()
	local myClass = self:GetClass()
	local hitRegistered = false
	//debugoverlay.Cross(self:GetMeleeAttackDamageOrigin(), 5, 3, Color(255, 255, 0))
	//debugoverlay.EntityTextAtPosition(self:GetMeleeAttackDamageOrigin(), 0, "Melee damage origin", 3, Color(255, 255, 0))
	//debugoverlay.Cross(self:GetMeleeAttackDamageOrigin() + self:GetForward()*selfData.MeleeAttackDamageDistance, 5, 3, Color(238, 119, 222))
	//debugoverlay.EntityTextAtPosition(self:GetMeleeAttackDamageOrigin() + self:GetForward()*selfData.MeleeAttackDamageDistance, 0, "Melee damage distance", 3, Color(238, 119, 222))
	for _, ent in ipairs(ents.FindInSphere(self:GetMeleeAttackDamageOrigin(), selfData.MeleeAttackDamageDistance)) do
		if ent == self or ent:GetClass() == myClass or (ent.IsVJBaseBullseye && ent.VJ_IsBeingControlled) then continue end
		if ent:IsPlayer() && (ent.VJ_IsControllingNPC or !ent:Alive() or VJ_CVAR_IGNOREPLAYERS) then continue end
		if ((ent.VJ_ID_Living && self:Disposition(ent) != D_LI) or ent.VJ_ID_Attackable or ent.VJ_ID_Destructible) && self:GetInternalVariable("m_latchedHeadDirection"):Dot((Vector(ent:GetPos().x, ent:GetPos().y, 0) - Vector(myPos.x, myPos.y, 0)):GetNormalized()) > math_cos(math_rad(selfData.MeleeAttackDamageAngleRadius)) then
			if isPropAttack && ent.VJ_ID_Living && VJ.GetNearestDistance(self, ent, true) > selfData.MeleeAttackDistance then continue end -- Since this attack initiated as prop attack, its melee distance may be off!
			local applyDmg = true
			local isProp = ent.VJ_ID_Attackable
			if self:CustomOnMeleeAttack_AfterChecks(ent, isProp) == true then continue end
			local dmgAmount = self:ScaleByDifficulty(selfData.MeleeAttackDamage)
			-- Handle prop interaction
			local propBehavior = selfData.PropInteraction
			if isProp then
				if propBehavior then
					if (propBehavior == true or propBehavior == "OnlyDamage") && (ent:Health() > 0 or ent:GetInternalVariable("m_takedamage") == 2) then
						hitRegistered = true
						applyDmg = true
					elseif propBehavior == "OnlyPush" then
						applyDmg = false
					end
					local phys = ent:GetPhysicsObject()
					if IsValid(phys) && self:MaintainPropInteraction({ent}) then
						phys:EnableMotion(true)
						phys:Wake()
						constraint.RemoveConstraints(ent, "Weld") //constraint.RemoveAll(ent)
						if propBehavior == true or propBehavior == "OnlyPush" then
							hitRegistered = true
							local curEnemy = self:GetEnemy()
							local physMass = phys:GetMass()
							phys:ApplyForceCenter((IsValid(curEnemy) and curEnemy:GetPos() or myPos) + self:GetForward() * (physMass * 700) + self:GetUp() * (physMass * 200))
						end
					end
				else -- We can't damage or push props
					applyDmg = false
				end
			end
			if applyDmg then
				-- Knockback | Ignore doors, trains, elevators as it will make them fly when activated
				if selfData.HasMeleeAttackKnockBack && ent:GetMoveType() != MOVETYPE_PUSH && ent.MovementType != VJ_MOVETYPE_STATIONARY && (!ent.VJ_ID_Boss or ent.IsVJBaseSNPC_Tank) then
					ent:SetGroundEntity(NULL)
					ent:SetVelocity(self:MeleeAttackKnockbackVelocity(ent))
				end
				-- Apply damage
				if !selfData.DisableDefaultMeleeAttackDamageCode then
					local dmgInfo = DamageInfo()
					dmgInfo:SetDamage(self:ScaleByDifficulty(dmgAmount))
					dmgInfo:SetDamageType(selfData.MeleeAttackDamageType)
					if ent.VJ_ID_Living then dmgInfo:SetDamageForce(self:GetForward() * ((dmgInfo:GetDamage() + 100) * 70)) end
					dmgInfo:SetInflictor(self)
					dmgInfo:SetAttacker(self)
					VJ.DamageSpecialEnts(self, ent, dmgInfo)
					ent:TakeDamageInfo(dmgInfo, self)
				end
				-- Apply bleeding damage
				if selfData.MeleeAttackBleedEnemy && ent.VJ_ID_Living && (!ent.VJ_ID_Boss or selfData.VJ_ID_Boss) && math.random(1, selfData.MeleeAttackBleedEnemyChance) == 1 then
					local bleedName = "timer_melee_bleed" .. ent:EntIndex() -- Timer's name
					local bleedDmg = self:ScaleByDifficulty(selfData.MeleeAttackBleedEnemyDamage) -- How much damage each rep does
					timer.Create(bleedName, selfData.MeleeAttackBleedEnemyTime, selfData.MeleeAttackBleedEnemyReps, function()
						if IsValid(ent) && ent:Health() > 0 then
							local dmgInfo = DamageInfo()
							dmgInfo:SetDamage(bleedDmg)
							dmgInfo:SetDamageType(DMG_GENERIC)
							dmgInfo:SetDamageCustom(VJ.DMG_BLEED)
							if self:IsValid() then
								dmgInfo:SetInflictor(self)
								dmgInfo:SetAttacker(self)
							end
							ent:TakeDamageInfo(dmgInfo)
						else -- Remove the timer if the entity is dead in attempt to remove it before the entity respawns (Essential for players)
							timer.Remove(bleedName)
						end
					end)
				end
			end
			if ent:IsPlayer() then
				ent:ViewPunch(Angle(math.random(-1, 1) * dmgAmount, math.random(-1, 1) * dmgAmount, math.random(-1, 1) * dmgAmount))
				-- Apply DSP
				if selfData.MeleeAttackDSP && ((!selfData.MeleeAttackDSPLimit) or (dmgAmount >= selfData.MeleeAttackDSPLimit)) then
					ent:SetDSP(selfData.MeleeAttackDSP, false)
				end
				-- Speed modifier
				if selfData.MeleeAttackPlayerSpeed then
					self:DoMeleeAttackPlayerSpeed(ent, selfData.MeleeAttackPlayerSpeedWalk, selfData.MeleeAttackPlayerSpeedRun, selfData.MeleeAttackPlayerSpeedTime, {PlaySound = selfData.HasMeleeAttackPlayerSpeedSounds, SoundTable = selfData.SoundTbl_MeleeAttackPlayerSpeed, SoundLevel = selfData.MeleeAttackPlayerSpeedSoundLevel, FadeOutTime = 1})
				end
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
function ENT:DoMeleeAttackPlayerSpeed(ent, walkSpeed, runSpeed, speedTime, sdData, extraOptions, customFunc)
	speedTime = speedTime or 5
	sdData = sdData or {}
		local vSD_PlaySound = sdData.PlaySound or false -- Should it play a sound?
		local vSD_SoundTable = sdData.SoundTable or {} -- Sounds it should play (Picks randomly)
		local vSD_SoundLevel = sdData.SoundLevel or 100 -- How loud should the sound play?
		local vSD_FadeOutTime = sdData.FadeOutTime or 1 -- How long until it the sound fully fades out?
	extraOptions = extraOptions or {}
		local vEF_NoInterrupt = extraOptions.NoInterrupt or false -- If set to true, the player's speed won't change by another instance of this code
	local walkspeed_before = ent:GetWalkSpeed()
	local runspeed_before = ent:GetRunSpeed()
	if ent.VJ_SpeedModified && ent.VJ_SpeedModified_NoInterrupt then return end
	if (!ent.VJ_SpeedModified) then
		ent.VJ_SpeedModified = true
		if vEF_NoInterrupt then ent.VJ_SpeedModified_NoInterrupt = true end
		ent.VJ_SlowDownPlayerWalkSpeed = walkspeed_before
		ent.VJ_SlowDownPlayerRunSpeed = runspeed_before
	end
	ent:SetWalkSpeed(walkSpeed or 50)
	ent:SetRunSpeed(runSpeed or 50)
	if (customFunc) then customFunc() end
	if self.HasSounds && vSD_PlaySound then
		self.CurrentMeleeAttackPlayerSpeedSound = CreateSound(ent, PICK(vSD_SoundTable))
		self.CurrentMeleeAttackPlayerSpeedSound:Play()
		self.CurrentMeleeAttackPlayerSpeedSound:SetSoundLevel(vSD_SoundLevel)
		if !ent:Alive() && self.CurrentMeleeAttackPlayerSpeedSound then self.CurrentMeleeAttackPlayerSpeedSound:FadeOut(vSD_FadeOutTime) end
	end
	local pickedSD = self.CurrentMeleeAttackPlayerSpeedSound
	local sdFadeTime = vSD_FadeOutTime
	local timerName = "timer_melee_slowply"..ent:EntIndex()
	
	if timer.Exists(timerName) && timer.TimeLeft(timerName) > speedTime then
		return
	end
	timer.Create(timerName, speedTime, 1, function()
		ent:SetWalkSpeed(ent.VJ_SlowDownPlayerWalkSpeed)
		ent:SetRunSpeed(ent.VJ_SlowDownPlayerRunSpeed)
		ent.VJ_SpeedModified = false
		ent.VJ_SpeedModified_NoInterrupt = false
		if pickedSD then pickedSD:FadeOut(sdFadeTime) end
		if !IsValid(ent) then timer.Remove(timerName) end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ExecuteRangeAttack()
	local selfData = self:GetTable()
	if selfData.Dead or selfData.PauseAttacks or selfData.Flinching or selfData.AttackType == VJ.ATTACK_TYPE_MELEE then return end
	local ene = self:GetEnemy()
	local eneValid = IsValid(ene)
	if eneValid then
		selfData.AttackType = VJ.ATTACK_TYPE_RANGE
		//self:PointAtEntity(ene)
		local skipProj = self:OnRangeAttackExecute("Init", ene)
		-- Create projectile
		if !skipProj then
			local projectileClass = PICK(selfData.RangeAttackProjectiles) or PICK(selfData.RangeAttackEntityToSpawn)
			if projectileClass then
				local projectile = ents.Create(projectileClass)
				local spawnPos = self:RangeAttackProjPos(projectile)
				projectile:SetPos(spawnPos)
				projectile:SetAngles((ene:GetPos() - spawnPos):Angle())
				self:OnRangeAttackExecute("PreProjSpawn", ene, projectile)
				projectile:SetOwner(self)
				projectile:SetPhysicsAttacker(self)
				projectile:Spawn()
				projectile:Activate()
				//constraint.NoCollide(self, projectile, 0, 0)
				local phys = projectile:GetPhysicsObject()
				if IsValid(phys) then
					phys:Wake()
					local vel = self:RangeAttackProjVel(projectile)
					phys:SetVelocity(vel) //ApplyForceCenter
					projectile:SetAngles(vel:GetNormal():Angle())
				else
					local vel = self:RangeAttackProjVel(projectile)
					projectile:SetVelocity(vel)
					projectile:SetAngles(vel:GetNormal():Angle())
				end
				self:OnRangeAttackExecute("PostProjSpawn", ene, projectile)
			end
		end
	end
	if selfData.AttackState < VJ.ATTACK_STATE_EXECUTED then
		if eneValid then -- Play range attack only once, otherwise it will spam it for every projectile!
			self:PlaySoundSystem("RangeAttack")
		end
		selfData.AttackState = VJ.ATTACK_STATE_EXECUTED
		if selfData.TimeUntilRangeAttackProjectileRelease then
			attackTimers[VJ.ATTACK_TYPE_RANGE](self)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ExecuteLeapAttack()
	local selfData = self:GetTable()
	if selfData.Dead or selfData.PauseAttacks or selfData.Flinching or (selfData.LeapAttackStopOnHit && selfData.AttackState == VJ.ATTACK_STATE_EXECUTED_HIT) then return end
	self:OnLeapAttackExecute("Init")
	local myClass = self:GetClass()
	local hitRegistered = false
	for _,ent in ipairs(ents.FindInSphere(self:GetPos(), selfData.LeapAttackDamageDistance)) do
		if ent == self or ent:GetClass() == myClass or (ent.IsVJBaseBullseye && ent.VJ_IsBeingControlled) then continue end
		if ent:IsPlayer() && (ent.VJ_IsControllingNPC or !ent:Alive() or VJ_CVAR_IGNOREPLAYERS) then continue end
		if (ent.VJ_ID_Living && self:Disposition(ent) != D_LI) or ent.VJ_ID_Attackable or ent.VJ_ID_Destructible then
			if self:OnLeapAttackExecute("PreDamage", ent) == true then continue end
			local dmgAmount = self:ScaleByDifficulty(selfData.LeapAttackDamage)
			-- Damage
			if !selfData.DisableDefaultLeapAttackDamageCode then
				local dmgInfo = DamageInfo()
				dmgInfo:SetDamage(dmgAmount)
				dmgInfo:SetInflictor(self)
				dmgInfo:SetDamageType(selfData.LeapAttackDamageType)
				dmgInfo:SetAttacker(self)
				if ent.VJ_ID_Living then dmgInfo:SetDamageForce(self:GetForward() * ((dmgInfo:GetDamage() + 100) * 70)) end
				ent:TakeDamageInfo(dmgInfo, self)
			end
			if ent:IsPlayer() then
				ent:ViewPunch(Angle(math.random(-1, 1) * dmgAmount, math.random(-1, 1) * dmgAmount, math.random(-1, 1) * dmgAmount))
			end
			hitRegistered = true
			if selfData.LeapAttackStopOnHit then break end
		end
	end
	if selfData.AttackState < VJ.ATTACK_STATE_EXECUTED then
		selfData.AttackState = VJ.ATTACK_STATE_EXECUTED
		if selfData.TimeUntilLeapAttackDamage then
			attackTimers[VJ.ATTACK_TYPE_LEAP](self)
		end
	end
	if hitRegistered then
		self:PlaySoundSystem("LeapAttackDamage")
		selfData.AttackState = VJ.ATTACK_STATE_EXECUTED_HIT
	else
		self:OnLeapAttackExecute("Miss")
		self:PlaySoundSystem("LeapAttackDamageMiss")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:LeapAttackJump()
	local ene = self:GetEnemy()
	if !IsValid(ene) then return end
	self:SetGroundEntity(NULL)
	self.LeapAttackHasJumped = true
	-- Classic velocity, useful for more straight line type of jumps
	//return ((ene:GetPos() + ene:OBBCenter()) - (self:GetPos() + self:OBBCenter())):GetNormal() * 400 + self:GetForward() * 200 + self:GetUp() * 100
	self:SetLocalVelocity(self:OnLeapAttack("Jump", ene) or VJ.CalculateTrajectory(self, ene, "Curve", self:GetPos() + self:OBBCenter(), ene:GetPos() + ene:OBBCenter(), 1))
	self:PlaySoundSystem("LeapAttackJump")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StopAttacks(checkTimers)
	if !self:Alive() then return end
	local selfData = self:GetTable()
	if selfData.VJ_DEBUG && GetConVar("vj_npc_debug_attack"):GetInt() == 1 then VJ.DEBUG_Print(self, "StopAttacks", "Attack type = " .. selfData.AttackType) end
	
	if checkTimers && attackTimers[selfData.AttackType] && selfData.AttackState < VJ.ATTACK_STATE_EXECUTED then
		attackTimers[selfData.AttackType](self, true)
	end
	
	selfData.AttackType = VJ.ATTACK_TYPE_NONE
	selfData.AttackState = VJ.ATTACK_STATE_DONE
	selfData.AttackSeed = 0
	selfData.LeapAttackHasJumped = false

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
	if !selfData.HasPoseParameterLooking then return end
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
	local speed = selfData.PoseParameterLooking_TurningSpeed
	local names = selfData.PoseParameterLooking_Names
	local namesPitch = names.pitch
	local namesYaw = names.yaw
	local namesRoll = names.roll
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
	local eneValid = IsValid(self:GetEnemy())
	self:PlayIdleSound(nil, nil, eneValid)
	
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
	
	if eneValid then -- Chase the enemy
		self:MaintainAlertBehavior()
	/*elseif selfData.Alerted then -- No enemy, but alerted
		selfData.TakingCoverT = 0
		self:MaintainIdleBehavior()*/
	else -- Idle
		if !selfData.Alerted then
			selfData.TakingCoverT = 0
		end
		
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
		
		self:MaintainIdleBehavior()
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
	
	-- Clear memory of the enemy if it's not a player AND it's dead
	if eneValid && !ene:IsPlayer() && !ene:Alive() then
		//print("Clear memory", ene)
		self:ClearEnemyMemory(ene)
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
	self.HasRangeAttack = false
	self.HasLeapAttack = false
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
		
		if self.DeathCorpseFade then corpse:Fire(corpse.FadeCorpseType, "", self.DeathCorpseFade) end
		if vj_npc_corpse_fade:GetInt() == 1 then corpse:Fire(corpse.FadeCorpseType, "", vj_npc_corpse_fadetime:GetInt()) end
		self:OnCreateDeathCorpse(dmginfo, hitgroup, corpse)
		if corpse:IsFlagSet(FL_DISSOLVING) && corpse.ChildEnts then
			for _, child in ipairs(corpse.ChildEnts) do
				child:Dissolve(0, 1)
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
		-- Remove child entities | No fade effects as it will look weird, remove it instantly!
		if self.DeathCorpse_ChildEnts then
			for _, child in ipairs(self.DeathCorpse_ChildEnts) do
				child:Remove()
			end
		end
	end
end