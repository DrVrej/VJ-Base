AddCSLuaFile()

SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "RPG"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Category = "VJ Base"
SWEP.Spawnable = true

if CLIENT then
	VJ.AddKillIcon("weapon_vj_rpg", SWEP.PrintName, VJ.KILLICON_TYPE_ALIAS, "rpg_missile")
end

SWEP.ViewModel = "models/vj_base/weapons/c_rpg7.mdl" // "models/weapons/c_rpg.mdl"
SWEP.WorldModel = "models/vj_base/weapons/w_rpg7.mdl" // "models/weapons/w_rocket_launcher.mdl"
SWEP.WorldModel_UseCustomPosition = true
SWEP.WorldModel_CustomPositionAngle = Vector(-10, 0, 180)
SWEP.WorldModel_CustomPositionOrigin = Vector(-1.5, -0.5, 1)
SWEP.HoldType = "rpg"
SWEP.ViewModelFOV = 60
SWEP.Slot = 4
SWEP.SlotPos = 4
SWEP.UseHands = true

SWEP.NPC_NextPrimaryFire = 5
SWEP.NPC_TimeUntilFire = 0.8
SWEP.NPC_BulletSpawnAttachment = "missile"
SWEP.NPC_FiringDistanceScale = 2.5
SWEP.NPC_StandingOnly = true

SWEP.Primary.Damage = 5
SWEP.Primary.Force = 5
SWEP.Primary.ClipSize = 1
SWEP.Primary.Recoil = 0.6
SWEP.Primary.Delay = 0.3
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "RPG_Round"
SWEP.Primary.Sound = "VJ.Weapon_RPG.Single"
SWEP.Primary.DisableBulletCode = true
SWEP.PrimaryEffects_MuzzleAttachment = 1
SWEP.PrimaryEffects_SpawnShells = false

SWEP.HasReloadSound = true
SWEP.Reload_TimeUntilAmmoIsSet = 0.8
SWEP.ReloadSound = "vj_base/weapons/reload_rpg.wav"
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OnPrimaryAttack(status, statusData)
	if status == "Init" then
		if CLIENT then return end
		local owner = self:GetOwner()
		local projectile = ents.Create("obj_vj_rocket")
		local spawnPos = self:GetBulletPos()
		if owner:IsPlayer() then
			local plyAng = owner:GetAimVector():Angle()
			projectile:SetPos(owner:GetShootPos() + plyAng:Forward()*-20 + plyAng:Up()*-9 + plyAng:Right()*10)
			owner:GetViewModel():SetBodygroup(1, 1)
		else
			projectile:SetPos(spawnPos)
		end
		projectile:SetOwner(owner)
		projectile:Activate()
		projectile:Spawn()
		
		local phys = projectile:GetPhysicsObject()
		if IsValid(phys) then
			if owner.IsVJBaseSNPC then
				phys:SetVelocity(VJ.CalculateTrajectory(owner, owner:GetEnemy(), "Line", spawnPos, 1, 2500))
			elseif owner:IsPlayer() then
				phys:SetVelocity(owner:GetAimVector() * 2500)
			else
				phys:SetVelocity(VJ.CalculateTrajectory(owner, owner:GetEnemy(), "Line", spawnPos, owner:GetEnemy():GetPos() + owner:GetEnemy():OBBCenter(), 2500))
			end
			projectile:SetAngles(projectile:GetVelocity():GetNormal():Angle())
		end
		
		self:SetBodygroup(1, 1)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:PrimaryAttackEffects(owner)
	ParticleEffectAttach("smoke_exhaust_01a", PATTACH_POINT_FOLLOW, self, 2)
	ParticleEffectAttach("smoke_exhaust_01a", PATTACH_POINT_FOLLOW, self, 2)
	ParticleEffectAttach("smoke_exhaust_01a", PATTACH_POINT_FOLLOW, self, 2)
	timer.Simple(4, function() if IsValid(self) then self:StopParticles() end end)
	self.BaseClass.PrimaryAttackEffects(self, owner)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OnReload(status)
	if status == "Finish" then
		self:SetBodygroup(1, 0)
		
		local owner = self:GetOwner()
		if IsValid(owner) && owner:IsPlayer() then
			owner:GetViewModel():SetBodygroup(1, 0)
		end
	end
end