SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "Blaster"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose = "This weapon is made for Players and NPCs"
SWEP.Instructions = "Controls are like a regular weapon."
SWEP.Category = "VJ Base"
	-- Client Settings ---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
SWEP.Slot = 2 -- Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6) 
SWEP.SlotPos = 4 -- Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6)
SWEP.UseHands = true
end
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire = 0.3 -- RPM of the weapon in seconds | Calculation: 60 / RPM
SWEP.NPC_ReloadSound = "vj_base/weapons/blaster/blaster_reload.wav" -- Sounds it plays when the base detects the SNPC playing a reload animation
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.ViewModel = "models/vj_base/weapons/c_e5.mdl"
SWEP.WorldModel = "models/vj_base/weapons/w_e5.mdl"
SWEP.HoldType = "ar2"
SWEP.Spawnable = true
SWEP.AdminSpawnable = false
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage = 10 -- Damage
SWEP.Primary.Force = 5 -- Force applied on the object the bullet hits
SWEP.Primary.ClipSize = 30 -- Max amount of rounds per clip
SWEP.Primary.Recoil = 0.6 -- How much recoil does the player get?
SWEP.Primary.Delay = 0.3 -- Time until it can shoot again
SWEP.Primary.TracerType = "VJ_Laserrod_Red" -- Tracer type (Examples: AR2, laster, 9mm)
SWEP.Primary.Automatic = true -- Should the weapon continue firing as long as the attack button is held down?
SWEP.Primary.Ammo = "SMG1" -- Ammo type
SWEP.Primary.Sound = "VJ.Weapon_Blaster.Single" // npc/roller/mine/rmine_explode_shock1.wav
//SWEP.Primary.DisableBulletCode = true -- The bullet won't spawn, this can be used when creating a projectile-based weapon
SWEP.PrimaryEffects_MuzzleParticles = {"vj_muzzle_blaster_red"}
SWEP.PrimaryEffects_MuzzleParticlesAsOne = true -- Should all the particles spawn together instead of picking only one?
SWEP.PrimaryEffects_MuzzleAttachment = "muzzle"
SWEP.PrimaryEffects_SpawnShells = false
SWEP.PrimaryEffects_DynamicLightColor = Color(255, 0, 0)
	-- Reload Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasReloadSound = true -- Does it have a reload sound? Remember even if this is set to false, the animation sound will still play!
SWEP.ReloadSound = "vj_base/weapons/blaster/blaster_reload.wav"
SWEP.Reload_TimeUntilAmmoIsSet = 0.8 -- Time until ammo is set to the weapon