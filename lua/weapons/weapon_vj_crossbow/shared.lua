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
	local bolt = ents.Create("obj_vj_crossbowbolt")
	local spawnpos = self:GetNW2Vector("VJ_CurBulletPos")
	bolt:SetPos(spawnpos)
	bolt:SetAngles(self:GetOwner():GetAngles())
	bolt:SetOwner(self:GetOwner())
	bolt:Activate()
	bolt:Spawn()
	
	local phys = bolt:GetPhysicsObject()
	if IsValid(phys) then
		phys:ApplyForceCenter(bolt:CalculateProjectile("Line", spawnpos, self:GetOwner():GetEnemy():GetPos() + self:GetOwner():GetEnemy():OBBCenter(), 4000) + Vector(math.Rand(-30,30), math.Rand(-30,30), math.Rand(-30,30)))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnReload()
	timer.Simple(SoundDuration("weapons/crossbow/reload1.wav"), function()
		if IsValid(self) && IsValid(self:GetOwner()) then
			VJ_EmitSound(self:GetOwner(), {"weapons/crossbow/bolt_load1.wav","weapons/crossbow/bolt_load2.wav"}, self.NPC_ReloadSoundLevel)
		end
	end)
end