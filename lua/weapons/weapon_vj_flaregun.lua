AddCSLuaFile()

SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "Flare Gun"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Category = "VJ Base"
SWEP.Spawnable = true

SWEP.ViewModel = "models/vj_base/weapons/v_flaregun.mdl"
SWEP.WorldModel = "models/vj_base/weapons/w_flaregun.mdl"
SWEP.HoldType = "revolver"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.SwayScale = 4
SWEP.UseHands = true

SWEP.NPC_NextPrimaryFire = 0.9
SWEP.NPC_TimeUntilFire = 0.5

SWEP.Primary.Damage = 20
SWEP.Primary.Force = 1
SWEP.Primary.ClipSize = 1
SWEP.Primary.Recoil = 2
SWEP.Primary.Delay = 0.2
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357"
SWEP.Primary.Sound = "VJ.Weapon_FlareGun.Single"
SWEP.PrimaryEffects_MuzzleParticles = {"vj_rifle_smoke", "vj_rifle_smoke_dark", "vj_rifle_smoke_flash", "vj_rifle_sparks2"}
SWEP.PrimaryEffects_MuzzleParticlesAsOne = true
SWEP.Primary.DisableBulletCode = true
SWEP.PrimaryEffects_MuzzleAttachment = 1
SWEP.PrimaryEffects_SpawnShells = false
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OnPrimaryAttack(status, statusData)
	if status == "Init" then
		if CLIENT then return end
		local owner = self:GetOwner()
		local projectile = ents.Create("obj_vj_flareround")
		local spawnPos = self:GetBulletPos()
		if owner:IsPlayer() then
			projectile:SetPos(owner:GetShootPos())
		else
			projectile:SetPos(spawnPos)
		end
		projectile:SetOwner(owner)
		projectile:Activate()
		projectile:Spawn()
		
		local phys = projectile:GetPhysicsObject()
		if IsValid(phys) then
			if owner.IsVJBaseSNPC then
				phys:SetVelocity(VJ.CalculateTrajectory(owner, owner:GetEnemy(), "Line", spawnPos, 1, 15000))
			elseif owner:IsPlayer() then
				phys:SetVelocity(owner:GetAimVector() * 15000)
			else
				phys:SetVelocity(VJ.CalculateTrajectory(owner, owner:GetEnemy(), "Line", spawnPos, owner:GetEnemy():GetPos() + owner:GetEnemy():OBBCenter(), 15000))
			end
			projectile:SetAngles(projectile:GetVelocity():GetNormal():Angle())
		end
	end
end