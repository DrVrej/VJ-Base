AddCSLuaFile()

SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "AR2"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Category = "VJ Base"
SWEP.Spawnable = true

if CLIENT then
	VJ.AddKillIcon("weapon_vj_ar2", SWEP.PrintName, VJ.KILLICON_TYPE_ALIAS, "weapon_ar2")
end

SWEP.ViewModel = "models/weapons/c_irifle.mdl"
SWEP.WorldModel = "models/weapons/w_irifle.mdl"
SWEP.HoldType = "ar2"
SWEP.Slot = 2
SWEP.SlotPos = 4
SWEP.UseHands = true

SWEP.NPC_HasSecondaryFire = true
SWEP.NPC_SecondaryFireEnt = "obj_vj_combineball"
SWEP.NPC_SecondaryFireDistance = 3000
SWEP.NPC_SecondaryFireChance = 4
SWEP.NPC_SecondaryFireNext = VJ.SET(15, 20)
SWEP.NPC_SecondaryFireSound = "VJ.Weapon_AR2.Secondary"
SWEP.NPC_NextPrimaryFire = 0.9
SWEP.NPC_TimeUntilFire = 0.1
SWEP.NPC_TimeUntilFireExtraTimers = {0.1, 0.2, 0.3, 0.4, 0.5, 0.6}
SWEP.NPC_ReloadSound = "vj_base/weapons/ar2/reload.wav"

SWEP.Primary.Damage = 12
SWEP.Primary.Force = 10
SWEP.Primary.ClipSize = 30
SWEP.Primary.Delay = 0.1
SWEP.Primary.TracerType = "AR2Tracer"
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "AR2"
SWEP.Primary.Sound = "VJ.Weapon_AR2.Single"
SWEP.PrimaryEffects_MuzzleParticles = {"vj_rifle_full_blue"}
SWEP.PrimaryEffects_SpawnShells = false
SWEP.PrimaryEffects_DynamicLightColor = Color(0, 31, 225)

SWEP.Secondary.Ammo = "AR2AltFire"

SWEP.DryFireSound = "weapons/ar2/ar2_empty.wav"
SWEP.HasReloadSound = false
SWEP.ReloadSound = "weapons/ar2/ar2_reload.wav"
SWEP.Reload_TimeUntilAmmoIsSet = 0.8
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:NPC_SecondaryFire_BeforeTimer(eneEnt, fireTime)
	VJ.EmitSound(self, "weapons/cguard/charging.wav", 70)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OnSecondaryAttack()
	local owner = self:GetOwner()
	local vm = owner:GetViewModel()
	local fidgetTime = VJ.AnimDuration(vm, ACT_VM_FIDGET)
	local fireTime = VJ.AnimDuration(vm, ACT_VM_SECONDARYATTACK)
	local totalTime = fidgetTime + fireTime
	local curTime = CurTime()
	self:SetNextSecondaryFire(curTime + totalTime)
	self.PLY_NextIdleAnimT = curTime + totalTime
	self.PLY_NextReloadT = curTime + totalTime
	self:SendWeaponAnim(ACT_VM_FIDGET)
	VJ.CreateSound(self, "weapons/cguard/charging.wav", 85)
	
	timer.Simple(fidgetTime, function()
		if IsValid(self) && IsValid(owner) && owner:GetActiveWeapon() == self then
			VJ.CreateSound(self, "weapons/irifle/irifle_fire2.wav", 90)

			if SERVER then
				local projectile = ents.Create(self.NPC_SecondaryFireEnt)
				projectile:SetPos(owner:GetShootPos())
				projectile:SetAngles(owner:GetAimVector():Angle())
				projectile:SetOwner(owner)
				projectile:Spawn()
				projectile:Activate()
				local phys = projectile:GetPhysicsObject()
				if IsValid(phys) then
					phys:Wake()
					phys:SetVelocity(owner:GetAimVector() * 2000)
				end
			end
			
			owner:ViewPunch(Angle(-self.Primary.Recoil * 3, 0, 0))
			owner:SetAnimation(PLAYER_ATTACK1)
			self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
			self:TakeSecondaryAmmo(1)
		end
	end)
	return true
end