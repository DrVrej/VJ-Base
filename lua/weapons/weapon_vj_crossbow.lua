AddCSLuaFile()

SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "Crossbow"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Category = "VJ Base"

if CLIENT then
	VJ.AddKillIcon("weapon_vj_crossbow", SWEP.PrintName, VJ.KILLICON_TYPE_ALIAS, "crossbow_bolt")
end

SWEP.WorldModel = "models/weapons/w_crossbow.mdl"
SWEP.HoldType = "crossbow"

SWEP.MadeForNPCsOnly = true
SWEP.ReplacementWeapon = "weapon_crossbow"
SWEP.NPC_NextPrimaryFire = 1
SWEP.NPC_TimeUntilFire = 0.15
SWEP.NPC_ReloadSound = "weapons/crossbow/reload1.wav"
SWEP.NPC_FiringDistanceScale = 2.5
SWEP.NPC_StandingOnly = true

SWEP.Primary.ClipSize = 1
SWEP.Primary.Ammo = "XBowBolt"
SWEP.Primary.Sound = "weapons/crossbow/fire1.wav"
SWEP.Primary.DisableBulletCode = true
SWEP.PrimaryEffects_MuzzleParticles = {"vj_rifle_smoke", "vj_rifle_smoke_dark", "vj_rifle_smoke_flash", "vj_rifle_sparks2"}
SWEP.PrimaryEffects_MuzzleParticlesAsOne = true
SWEP.PrimaryEffects_MuzzleAttachment = "muzzle"
SWEP.PrimaryEffects_SpawnShells = false
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OnPrimaryAttack(status, statusData)
	if status == "Init" then
		if CLIENT then return end
		local projectile = ents.Create("obj_vj_crossbowbolt")
		local spawnPos = self:GetBulletPos()
		local owner = self:GetOwner()
		projectile:SetPos(spawnPos)
		projectile:SetOwner(owner)
		projectile:Activate()
		projectile:Spawn()
		
		local phys = projectile:GetPhysicsObject()
		if owner.IsVJBaseSNPC then
			phys:SetVelocity(VJ.CalculateTrajectory(owner, owner:GetEnemy(), "Line", spawnPos + Vector(math.Rand(-30, 30), math.Rand(-30, 30), math.Rand(-30, 30)), 1, 4000))
		else
			phys:SetVelocity(VJ.CalculateTrajectory(owner, owner:GetEnemy(), "Line", spawnPos, owner:GetEnemy():GetPos() + owner:GetEnemy():OBBCenter(), 4000))
		end
		projectile:SetAngles(projectile:GetVelocity():GetNormal():Angle())
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local sdLoadDone = {"weapons/crossbow/bolt_load1.wav", "weapons/crossbow/bolt_load2.wav"}
--
function SWEP:OnReload(status)
	if status == "Start" then
		timer.Simple(SoundDuration("weapons/crossbow/reload1.wav"), function()
			if IsValid(self) && IsValid(self:GetOwner()) then
				VJ.EmitSound(self:GetOwner(), sdLoadDone, self.NPC_ReloadSoundLevel)
			end
		end)
	end
end