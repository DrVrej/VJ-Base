SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "Glock 17"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose = "This weapon is made for Players and NPCs"
SWEP.Instructions = "Controls are like a regular weapon."
SWEP.Category = "VJ Base"
	-- Client Settings ---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
SWEP.Slot = 1 -- Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6) 
SWEP.SlotPos = 1 -- Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6)
SWEP.SwayScale = 2 -- Default is 1, The scale of the viewmodel sway
end
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire = 0.3 -- RPM of the weapon in seconds | Calculation: 60 / RPM
SWEP.NPC_CustomSpread = 0.8 -- This is added on top of the custom spread that's set inside the SNPC! | Starting from 1: Closer to 0 = better accuracy, Farther than 1 = worse accuracy
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.ViewModel = "models/vj_weapons/v_glock.mdl"
SWEP.WorldModel = "models/vj_weapons/w_glock.mdl"
SWEP.HoldType = "pistol"
SWEP.ViewModelFOV = 70 -- Player FOV for the view model
SWEP.Spawnable = true
SWEP.AdminSpawnable = false
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.AllowInWater = true -- Can it be fired in water?
SWEP.Primary.Damage = 25 -- Damage
SWEP.Primary.PlayerDamage = 15 -- For players only | "Same" = Same as self.Primary.Damage | "Double" = Double the self.Primary.Damage | number = Overrides self.Primary.Damage
SWEP.Primary.Force = 5 -- Force applied on the object the bullet hits
SWEP.Primary.ClipSize = 17 -- Max amount of bullets per clip
SWEP.Primary.Recoil = 0.3 -- How much recoil does the player get?
SWEP.Primary.Cone = 5 -- How accurate is the bullet? (Players)
SWEP.Primary.Delay = 0.25 -- Time until it can shoot again
SWEP.Primary.Automatic = true -- Should the weapon continue firing as long as the attack button is held down?
SWEP.Primary.Ammo = "Pistol" -- Ammo type
SWEP.Primary.Sound = "vj_weapons/glock_17/glock17_single.wav"
SWEP.Primary.DistantSound = "vj_weapons/glock_17/glock17_single_dist.wav"
SWEP.PrimaryEffects_MuzzleAttachment = 1
SWEP.PrimaryEffects_ShellAttachment = "ejectbrass"
SWEP.PrimaryEffects_ShellType = "ShellEject"
	-- ====== Secondary Fire Variables ====== --
SWEP.Secondary.Automatic = true -- Should the weapon continue firing as long as the attack button is held down?
SWEP.Secondary.Ammo = "Pistol" -- Ammo type
	-- Deployment Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.AnimTbl_Deploy = ACT_VM_IDLE_TO_LOWERED
	-- Reload Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasReloadSound = true -- Does it have a reload sound? Remember even if this is set to false, the animation sound will still play!
SWEP.ReloadSound = "vj_weapons/glock_17/reload.wav"
SWEP.Reload_TimeUntilAmmoIsSet = 1.5 -- Time until ammo is set to the weapon
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnSecondaryAttack()
	self.Primary.Delay = 0.175
	self.Primary.Cone = 20
	self:PrimaryAttack()
	self.Primary.Delay = 0.25
	self.Primary.Cone = 5
	
	self:SetNextSecondaryFire(CurTime() + 0.175)
	return false
end