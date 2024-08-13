SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "SPAS-12"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose = "This weapon is made for Players and NPCs"
SWEP.Instructions = "Controls are like a regular weapon."
SWEP.Category = "VJ Base"
	-- Client Settings ---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	SWEP.Slot = 3 -- Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6) 
	SWEP.SlotPos = 4 -- Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6)
	SWEP.UseHands = true
end
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire = 0.9 -- RPM of the weapon in seconds | Calculation: 60 / RPM
SWEP.NPC_TimeUntilFire = 0.2 -- How much time until the bullet/projectile is fired?
SWEP.NPC_CustomSpread = 2.5 -- This is added on top of the custom spread that's set inside the SNPC! | Starting from 1: Closer to 0 = better accuracy, Farther than 1 = worse accuracy
SWEP.NPC_ExtraFireSound = "vj_base/weapons/cycle_shotgun_pump.wav" -- Plays an extra sound after it fires (Example: Bolt action sound)
SWEP.NPC_FiringDistanceScale = 0.5 -- Changes how far the NPC can fire | 1 = No change, x < 1 = closer, x > 1 = farther
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.ViewModel = "models/weapons/c_shotgun.mdl"
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"
SWEP.HoldType = "shotgun"
SWEP.Spawnable = true
SWEP.AdminSpawnable = false
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage = 4 -- Damage
SWEP.Primary.PlayerDamage = "Double" -- For players only | "Same" = Same as self.Primary.Damage | "Double" = Double the self.Primary.Damage | number = Overrides self.Primary.Damage
SWEP.Primary.Force = 1 -- Force applied on the object the bullet hits
SWEP.Primary.NumberOfShots = 7 -- How many shots per attack?
SWEP.Primary.ClipSize = 6 -- Max amount of bullets per clip
SWEP.Primary.Cone = 12 -- How accurate is the bullet? (Players)
SWEP.Primary.Delay = 0.8 -- Time until it can shoot again
SWEP.Primary.Automatic = true -- Should the weapon continue firing as long as the attack button is held down?
SWEP.Primary.Ammo = "Buckshot" -- Ammo type
SWEP.Primary.Sound = "vj_base/weapons/spas12/spas12_single.wav"
SWEP.Primary.DistantSound = "vj_base/weapons/spas12/spas12_single_dist.wav"
SWEP.PrimaryEffects_MuzzleAttachment = 1
SWEP.PrimaryEffects_ShellAttachment = 2
SWEP.PrimaryEffects_ShellType = "ShotgunShellEject"
	-- ====== Secondary Fire Variables ====== --
SWEP.Secondary.Automatic = true -- Should the weapon continue firing as long as the attack button is held down?
SWEP.Secondary.Ammo = "Buckshot" -- Ammo type
	-- Reload Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasReloadSound = true -- Does it have a reload sound? Remember even if this is set to false, the animation sound will still play!
SWEP.ReloadSound = {"weapons/shotgun/shotgun_reload1.wav", "weapons/shotgun/shotgun_reload2.wav", "weapons/shotgun/shotgun_reload3.wav"}
SWEP.Reload_TimeUntilAmmoIsSet = 0.3 -- Time until ammo is set to the weapon
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttack_AfterShoot()
	local owner = self:GetOwner()
	if IsValid(owner) && owner:IsPlayer() then
		timer.Simple(0.2, function()
			if IsValid(self) && IsValid(owner) && owner:IsPlayer() then
				self:EmitSound("weapons/shotgun/shotgun_cock.wav", 80, 100)
				local animTime = VJ.AnimDuration(owner:GetViewModel(), ACT_SHOTGUN_PUMP)
				self:SendWeaponAnim(ACT_SHOTGUN_PUMP)
				self.NextIdleT = CurTime() + animTime
				self.NextReloadT = CurTime() + animTime
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnSecondaryAttack()
	if self:Clip1() > 1 then
		self.Primary.Delay = 1
		self.Primary.Cone = 20
		self.Primary.NumberOfShots = 14
		self.Primary.TakeAmmo = 2
		self.NextIdle_PrimaryAttack = 1
		self.AnimTbl_PrimaryFire = {ACT_VM_SECONDARYATTACK}
	end
	self:PrimaryAttack()
	self.Primary.Delay = 0.8
	self.Primary.Cone = 12
	self.Primary.NumberOfShots = 7
	self.Primary.TakeAmmo = 1
	self.NextIdle_PrimaryAttack = 0.8
	self.AnimTbl_PrimaryFire = {ACT_VM_PRIMARYATTACK}
	
	self:SetNextSecondaryFire(CurTime() + 1)
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnReload_Finish()
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
	return false
end