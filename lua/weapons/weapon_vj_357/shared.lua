SWEP.Base = "weapon_vj_base"
SWEP.PrintName = ".357 Magnum"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Category = "VJ Base"
	-- Client Settings ---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	VJ.AddKillIcon("weapon_vj_357", SWEP.PrintName, VJ.KILLICON_TYPE_ALIAS, "weapon_357")
	
	SWEP.Slot = 1 -- Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6) 
	SWEP.SlotPos = 1 -- Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6)
	SWEP.SwayScale = 4 -- Default is 1, The scale of the viewmodel sway
	SWEP.UseHands = true
end
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire = 0.95 -- RPM of the weapon in seconds | Calculation: 60 / RPM
SWEP.NPC_CustomSpread = 0.5 -- This is added on top of the custom spread that's set inside the SNPC! | Starting from 1: Closer to 0 = better accuracy, Farther than 1 = worse accuracy
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.ViewModel = "models/weapons/c_357.mdl"
SWEP.WorldModel = "models/weapons/w_357.mdl"
SWEP.HoldType = "revolver"
SWEP.Spawnable = true
SWEP.AdminSpawnable = false
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage = 20 -- Damage
SWEP.Primary.PlayerDamage = "Double" -- For players only | "Same" = Same as self.Primary.Damage | "Double" = Double the self.Primary.Damage | number = Overrides self.Primary.Damage
SWEP.Primary.Force = 1 -- Force applied on the object the bullet hits
SWEP.Primary.ClipSize = 6 -- Max amount of rounds per clip
SWEP.Primary.Recoil = 2 -- How much recoil does the player get?
SWEP.Primary.Cone = 1 -- How accurate is the bullet? (Players)
SWEP.Primary.Delay = 0.9 -- Time until it can shoot again
SWEP.Primary.Automatic = false -- Should the weapon continue firing as long as the attack button is held down?
SWEP.Primary.Ammo = "357" -- Ammo type
SWEP.Primary.Sound = "VJ.Weapon_357Magnum.Single"
SWEP.PrimaryEffects_MuzzleAttachment = 1
SWEP.PrimaryEffects_SpawnShells = false
	-- Reload Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasReloadSound = false -- Does it have a reload sound? Remember even if this is set to false, the animation sound will still play!
SWEP.Reload_TimeUntilAmmoIsSet = 2.7