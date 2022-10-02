if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
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
SWEP.NPC_NextPrimaryFire = 0.9 -- Next time it can use primary fire
SWEP.NPC_CustomSpread = 2.5 -- This is added on top of the custom spread that's set inside the SNPC! | Starting from 1: Closer to 0 = better accuracy, Farther than 1 = worse accuracy
SWEP.NPC_ExtraFireSound = {"vj_weapons/perform_shotgunpump.wav"} -- Plays an extra sound after it fires (Example: Bolt action sound)
SWEP.NPC_FiringDistanceScale = 0.5 -- Changes how far the NPC can fire | 1 = No change, x < 1 = closer, x > 1 = farther
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.ViewModel = "models/weapons/c_shotgun.mdl"
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"
SWEP.HoldType = "shotgun"
SWEP.Spawnable = true
SWEP.AdminSpawnable = false
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage = 4 -- Damage
SWEP.Primary.PlayerDamage = "Double" -- Only applies for players | "Same" = Same as self.Primary.Damage, "Double" = Double the self.Primary.Damage OR put a number to be different from self.Primary.Damage
SWEP.Primary.Force = 1 -- Force applied on the object the bullet hits
SWEP.Primary.NumberOfShots = 7 -- How many shots per attack?
SWEP.Primary.ClipSize = 6 -- Max amount of bullets per clip
SWEP.Primary.Cone = 12 -- How accurate is the bullet? (Players)
SWEP.Primary.Delay = 0.8 -- Time until it can shoot again
SWEP.Primary.Automatic = false -- Is it automatic?
SWEP.Primary.Ammo = "Buckshot" -- Ammo type
SWEP.Primary.Sound = {"vj_weapons/hl2_shotgun/shotgun_single1.wav"}
SWEP.Primary.DistantSound = {"vj_weapons/hl2_shotgun/shotgun_single_dist.wav"}
SWEP.PrimaryEffects_MuzzleAttachment = 1
SWEP.PrimaryEffects_ShellAttachment = 2
SWEP.PrimaryEffects_ShellType = "VJ_Weapon_ShotgunShell1"
SWEP.Secondary.Automatic		= true -- Is it automatic?
	-- Reload Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasReloadSound = true -- Does it have a reload sound? Remember even if this is set to false, the animation sound will still play!
SWEP.ReloadSound = {"weapons/shotgun/shotgun_reload1.wav","weapons/shotgun/shotgun_reload2.wav","weapons/shotgun/shotgun_reload3.wav"}
SWEP.Reload_TimeUntilAmmoIsSet = 0.3 -- Time until ammo is set to the weapon
SWEP.Reload_TimeUntilFinished = 0.5 -- How much time until the player can play idle animation, shoot, etc.
	-- Idle Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasIdleAnimation = true -- Does it have a idle animation?
SWEP.AnimTbl_Idle = {ACT_VM_IDLE}
SWEP.NextIdle_Deploy = 0.5 -- How much time until it plays the idle animation after the weapon gets deployed
SWEP.NextIdle_PrimaryAttack = 0.8 -- How much time until it plays the idle animation after attacking(Primary)
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttack_AfterShoot()
	timer.Simple(0.2, function()
		if IsValid(self) && IsValid(self:GetOwner()) && self:GetOwner():IsPlayer() then
			self:EmitSound(Sound("weapons/shotgun/shotgun_cock.wav"), 80, 100)
			self:SendWeaponAnim(ACT_SHOTGUN_PUMP)
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:SecondaryAttack()
	if self:Clip1() > 1 then
		self.Primary.Delay = 1
		self.Primary.Cone = 20
		self.Primary.NumberOfShots = 14
		self.Primary.TakeAmmo = 2
		self.NextIdle_PrimaryAttack = 1
		self.AnimTbl_PrimaryFire = {ACT_VM_SECONDARYATTACK}
	end
	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	self:PrimaryAttack()
	self.Primary.Delay = 0.8
	self.Primary.Cone = 12
	self.Primary.NumberOfShots = 7
	self.Primary.TakeAmmo = 1
	self.NextIdle_PrimaryAttack = 0.8
	self.AnimTbl_PrimaryFire = {ACT_VM_PRIMARYATTACK}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnThink()
	local owner = self:GetOwner()
	if self.Reloading then
		if self:Clip1() < self.Primary.ClipSize && owner:GetAmmoCount(self.Primary.Ammo) > 0 then
			if CurTime() > self.NextReloadAnimT then
				local animT = VJ_GetSequenceDuration(owner:GetViewModel(), ACT_VM_RELOAD)
				self.NextReloadAnimT = CurTime() + animT

				self:SendWeaponAnim(ACT_VM_RELOAD)
				owner:SetAnimation(PLAYER_RELOAD)
				timer.Simple(animT * 0.5,function()
					if IsValid(self) && IsValid(owner) && owner:GetActiveWeapon() == self && self.Reloading && self:Clip1() < self.Primary.ClipSize && owner:GetAmmoCount(self.Primary.Ammo) > 0 then
						self:SetClip1(self:Clip1() + 1)
						owner:RemoveAmmo(1, self.Primary.Ammo)
					end
				end)

				if SERVER && self.HasReloadSound == true then
					owner:EmitSound(VJ_PICK(self.ReloadSound), 50, math.random(90, 100))
				end
			end
		elseif self:Clip1() == self.Primary.ClipSize or owner:GetAmmoCount(self.Primary.Ammo) == 0 then
			self:CustomOnReload_Finish()
			self.Reloading = false
			self:DoIdleAnimation()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:Reload() -- Please add a custom reload function for overriding the way it reloads the clip <3
	if !IsValid(self) then return end
	local owner = self:GetOwner()
	if !IsValid(owner) or !owner:IsPlayer() or !owner:Alive() or owner:GetAmmoCount(self.Primary.Ammo) == 0 or !owner:KeyDown(IN_RELOAD) or self.Reloading == true then return end
	if self:Clip1() < self.Primary.ClipSize then
		self.Reloading = true

		self.NextReloadAnimT = 0

		self:CustomOnReload()

		return true
	end
end