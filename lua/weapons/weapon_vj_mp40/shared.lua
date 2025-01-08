SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "MP 40"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose = "This weapon is made for Players and NPCs"
SWEP.Instructions = "Controls are like a regular weapon."
SWEP.Category = "VJ Base"
	-- Client Settings ---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	SWEP.Slot = 2 -- Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6) 
	SWEP.SlotPos = 4 -- Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6)
	SWEP.SwayScale = 1 -- Default is 1, The scale of the viewmodel sway
	SWEP.UseHands = true
end
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.ViewModel = "models/vj_base/weapons/c_mp40.mdl"
SWEP.WorldModel = "models/vj_base/weapons/w_mp40.mdl"
SWEP.HoldType = "smg"
SWEP.ViewModelFOV = 45 -- Player FOV for the view model
SWEP.Spawnable = true
SWEP.AdminSpawnable = false
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage = 5 -- Damage
SWEP.Primary.PlayerDamage = "Double" -- For players only | "Same" = Same as self.Primary.Damage | "Double" = Double the self.Primary.Damage | number = Overrides self.Primary.Damage
SWEP.Primary.Force = 5 -- Force applied on the object the bullet hits
SWEP.Primary.ClipSize = 32 -- Max amount of rounds per clip
SWEP.Primary.Recoil = 0.3 -- How much recoil does the player get?
SWEP.Primary.Delay = 0.1 -- Time until it can shoot again
SWEP.Primary.Automatic = true -- Should the weapon continue firing as long as the attack button is held down?
SWEP.Primary.Ammo = "SMG1" -- Ammo type
SWEP.Primary.Sound = "VJ.Weapon_MP40.Single"
SWEP.PrimaryEffects_MuzzleAttachment = 1
SWEP.PrimaryEffects_ShellType = "RifleShellEject"
	-- Deployment Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasDeploySound = false -- Does the weapon have a deploy sound?
	-- Reload Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Reload_TimeUntilAmmoIsSet	= 2.1 -- Time until ammo is set to the weapon