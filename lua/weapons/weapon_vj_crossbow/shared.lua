SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "Crossbow"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose = "This weapon is made for Players and NPCs"
SWEP.Instructions = "Controls are like a regular weapon."
SWEP.Category = "VJ Base"
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.MadeForNPCsOnly = true
SWEP.NPC_NextPrimaryFire = 1 -- Next time it can use primary fire
SWEP.NPC_TimeUntilFire = 0.15 -- How much time until the bullet/projectile is fired?
SWEP.NPC_ReloadSound = {"weapons/crossbow/reload1.wav"}
SWEP.NPC_FiringDistanceScale = 2.5 -- Changes how far the NPC can fire | 1 = No change, x < 1 = closer, x > 1 = farther
SWEP.NPC_StandingOnly = true -- If true, the weapon can only be fired if the NPC is standing still
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.WorldModel = "models/weapons/w_crossbow.mdl"
SWEP.HoldType = "crossbow"
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.ClipSize = 1 -- Max amount of bullets per clip
SWEP.Primary.Ammo = "XBowBolt" -- Ammo type
SWEP.Primary.Sound = {"weapons/crossbow/fire1.wav"}
SWEP.Primary.DisableBulletCode = true -- The bullet won't spawn, this can be used when creating a projectile-based weapon
SWEP.PrimaryEffects_MuzzleParticles = {"vj_rifle_smoke","vj_rifle_smoke_dark","vj_rifle_smoke_flash","vj_rifle_sparks2"}
SWEP.PrimaryEffects_MuzzleParticlesAsOne = true -- If set to true, the base will spawn all the given particles instead of picking one
SWEP.PrimaryEffects_MuzzleAttachment = "muzzle"
SWEP.PrimaryEffects_SpawnShells = false
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttack_BeforeShoot()
	if CLIENT then return end
	local projectile = ents.Create("obj_vj_crossbowbolt")
	local spawnPos = self:GetNW2Vector("VJ_CurBulletPos")
	local owner = self:GetOwner()
	projectile:SetPos(spawnPos)
	projectile:SetOwner(owner)
	projectile:Activate()
	projectile:Spawn()
	
	local phys = projectile:GetPhysicsObject()
	if owner.IsVJBaseSNPC then
		spawnPos = spawnPos + Vector(math.Rand(-30,30), math.Rand(-30,30), math.Rand(-30,30))
		phys:SetVelocity(owner:CalculateProjectile("Line", spawnPos, owner:GetAimPosition(owner:GetEnemy(), spawnPos, 1, 4000), 4000))
	else
		phys:SetVelocity(owner:CalculateProjectile("Line", spawnPos, owner:GetEnemy():GetPos() + owner:GetEnemy():OBBCenter(), 4000))
	end
	projectile:SetAngles(projectile:GetVelocity():GetNormal():Angle())
end
---------------------------------------------------------------------------------------------------------------------------------------------
local sdLoadDone = {"weapons/crossbow/bolt_load1.wav", "weapons/crossbow/bolt_load2.wav"}
--
function SWEP:CustomOnReload()
	timer.Simple(SoundDuration("weapons/crossbow/reload1.wav"), function()
		if IsValid(self) && IsValid(self:GetOwner()) then
			VJ.EmitSound(self:GetOwner(), sdLoadDone, self.NPC_ReloadSoundLevel)
		end
	end)
end