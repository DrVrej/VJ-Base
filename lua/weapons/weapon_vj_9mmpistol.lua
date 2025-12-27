AddCSLuaFile()

SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "9mm Pistol"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Category = "VJ Base"
SWEP.Spawnable = true

if CLIENT then
	VJ.AddKillIcon("weapon_vj_9mmpistol", SWEP.PrintName, VJ.KILLICON_TYPE_ALIAS, "weapon_pistol")
end

SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.HoldType = "pistol"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.SwayScale = 4
SWEP.UseHands = true

SWEP.NPC_NextPrimaryFire = 0.3
SWEP.NPC_CustomSpread = 0.8

SWEP.Primary.Damage = 8
SWEP.Primary.ClipSize = 18
SWEP.Primary.Delay = .133
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "Pistol"
SWEP.Primary.Sound = "VJ.Weapon_9mmPistol.Single"
SWEP.Primary.AllowInWater = true
SWEP.PrimaryEffects_MuzzleAttachment = 1
SWEP.PrimaryEffects_ShellAttachment = 2
SWEP.PrimaryEffects_ShellType = "ShellEject"

SWEP.HasReloadSound = true
SWEP.ReloadSound = "weapons/pistol/pistol_reload1.wav"
SWEP.Reload_TimeUntilAmmoIsSet= 1
