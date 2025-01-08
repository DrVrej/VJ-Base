SWEP.Base= "weapon_vj_base"
SWEP.PrintName = "9mm Pistol"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose = "This weapon is made for Players and NPCs"
SWEP.Instructions = "Controls are like a regular weapon."
SWEP.Category = "VJ Base"
	-- Client Settings ---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	VJ.AddKillIcon("weapon_vj_9mmpistol", SWEP.PrintName, VJ.KILLICON_TYPE_ALIAS, "weapon_pistol")

	SWEP.Slot = 1 -- Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6) 
	SWEP.SlotPos = 1 -- Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6)
	SWEP.SwayScale = 4 -- Default is 1, The scale of the viewmodel sway
	SWEP.UseHands = true
end
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire = 0.3 -- RPM of the weapon in seconds | Calculation: 60 / RPM
SWEP.NPC_CustomSpread = 0.8 -- This is added on top of the custom spread that's set inside the SNPC! | Starting from 1: Closer to 0 = better accuracy, Farther than 1 = worse accuracy
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.HoldType = "pistol"
SWEP.Spawnable = true
SWEP.AdminSpawnable = false
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage = 8 -- Damage
SWEP.Primary.ClipSize = 18 -- Max amount of rounds per clip
SWEP.Primary.Delay = 0.25 -- Time until it can shoot again
SWEP.Primary.Automatic = true -- Should the weapon continue firing as long as the attack button is held down?
SWEP.Primary.Ammo = "Pistol" -- Ammo type
SWEP.Primary.Sound = "VJ.Weapon_9mmPistol.Single"
SWEP.Primary.AllowInWater = true -- Can it be fired in water?
SWEP.PrimaryEffects_MuzzleAttachment = 1
SWEP.PrimaryEffects_ShellAttachment = 2
SWEP.PrimaryEffects_ShellType = "ShellEject"
	-- Reload Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasReloadSound = true -- Does it have a reload sound? Remember even if this is set to false, the animation sound will still play!
SWEP.ReloadSound = "weapons/pistol/pistol_reload1.wav"
SWEP.Reload_TimeUntilAmmoIsSet	= 1 -- Time until ammo is set to the weapon