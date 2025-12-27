AddCSLuaFile()

SWEP.Base = "weapon_vj_base"
SWEP.PrintName = ".357 Magnum"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Category = "VJ Base"
SWEP.Spawnable = true

if CLIENT then
	VJ.AddKillIcon("weapon_vj_357", SWEP.PrintName, VJ.KILLICON_TYPE_ALIAS, "weapon_357")
end

SWEP.ViewModel = "models/weapons/c_357.mdl"
SWEP.WorldModel = "models/weapons/w_357.mdl"
SWEP.HoldType = "revolver"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.SwayScale = 4
SWEP.UseHands = true

SWEP.NPC_NextPrimaryFire = 0.95
SWEP.NPC_CustomSpread = 0.5

SWEP.Primary.Damage = 20
SWEP.Primary.PlayerDamage = "Double"
SWEP.Primary.Force = 1
SWEP.Primary.ClipSize = 6
SWEP.Primary.Recoil = 2
SWEP.Primary.Cone = 1
SWEP.Primary.Delay = .3 -- This is a double action revolver, dammit!
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357"
SWEP.Primary.Sound = "VJ.Weapon_357Magnum.Single"
SWEP.PrimaryEffects_MuzzleAttachment = 1
SWEP.PrimaryEffects_SpawnShells = false

SWEP.HasReloadSound = false
SWEP.Reload_TimeUntilAmmoIsSet = 2.7
