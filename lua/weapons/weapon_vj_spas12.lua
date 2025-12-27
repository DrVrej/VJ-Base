AddCSLuaFile()

SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "SPAS-12"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Category = "VJ Base"
SWEP.Spawnable = true

if CLIENT then
	VJ.AddKillIcon("weapon_vj_spas12", SWEP.PrintName, VJ.KILLICON_TYPE_ALIAS, "weapon_shotgun")
end

SWEP.ViewModel = "models/weapons/c_shotgun.mdl"
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"
SWEP.HoldType = "shotgun"
SWEP.Slot = 3
SWEP.SlotPos = 4
SWEP.UseHands = true

SWEP.NPC_NextPrimaryFire = 0.9
SWEP.NPC_TimeUntilFire = 0.2
SWEP.NPC_CustomSpread = 2.5
SWEP.NPC_ExtraFireSound = "vj_base/weapons/cycle_shotgun_pump.wav"
SWEP.NPC_FiringDistanceScale = 0.5

SWEP.Primary.Damage = 4
SWEP.Primary.PlayerDamage = "Double"
SWEP.Primary.Force = 1
SWEP.Primary.NumberOfShots = 7
SWEP.Primary.ClipSize = 6
SWEP.Primary.Cone = 12
SWEP.Primary.Delay = 0.8
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "Buckshot"
SWEP.Primary.Sound = "VJ.Weapon_SPAS12.Single"
SWEP.PrimaryEffects_MuzzleAttachment = 1
SWEP.PrimaryEffects_ShellAttachment = 2
SWEP.PrimaryEffects_ShellType = "ShotgunShellEject"

SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "Buckshot"

SWEP.HasReloadSound = true
SWEP.ReloadSound = {"weapons/shotgun/shotgun_reload1.wav", "weapons/shotgun/shotgun_reload2.wav", "weapons/shotgun/shotgun_reload3.wav"}
SWEP.Reload_TimeUntilAmmoIsSet = 0.3
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OnPrimaryAttack(status, statusData)
	if status == "PostFire" then
		local owner = self:GetOwner()
		if IsValid(owner) && owner:IsPlayer() then
			timer.Simple(0.2, function()
				if IsValid(self) && IsValid(owner) && owner:IsPlayer() then
					-- Play at CHAN_AUTO to not interrupt the firing sound
					self:EmitSound("weapons/shotgun/shotgun_cock.wav", 80, nil, nil, CHAN_AUTO)
					local animTime = VJ.AnimDuration(owner:GetViewModel(), ACT_SHOTGUN_PUMP)
					self:SendWeaponAnim(ACT_SHOTGUN_PUMP)
					self.PLY_NextIdleAnimT = CurTime() + animTime
					self.PLY_NextReloadT = CurTime() + animTime
				end
			end)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OnSecondaryAttack()
	if self:Clip1() > 1 then
		self.Primary.Delay = 1
		self.Primary.Cone = 20
		self.Primary.NumberOfShots = 14
		self.Primary.TakeAmmo = 2
		self.NextIdle_PrimaryAttack = 1
		self.AnimTbl_PrimaryFire = ACT_VM_SECONDARYATTACK
	end
	self:PrimaryAttack()
	self.Primary.Delay = 0.8
	self.Primary.Cone = 12
	self.Primary.NumberOfShots = 7
	self.Primary.TakeAmmo = 1
	self.NextIdle_PrimaryAttack = 0.8
	self.AnimTbl_PrimaryFire = ACT_VM_PRIMARYATTACK
	
	self:SetNextSecondaryFire(CurTime() + 1)
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OnReload(status)
	if status == "Finish" then
		local owner = self:GetOwner()
		if !owner:IsPlayer() then return true end
		self:GetOwner():RemoveAmmo(1, self.Primary.Ammo)
		self:SetClip1(self:Clip1() + 1)
		if self.Primary.ClipSize > self:Clip1() then
			timer.Simple(0.1, function()
				if IsValid(self) && IsValid(self:GetOwner()) then
					self.Reloading = false
					self:Reload()
				end
			end)
		end
		return true
	end
end
