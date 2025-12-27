AddCSLuaFile()

SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "Glock 17"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Category = "VJ Base"
SWEP.Spawnable = true

SWEP.ViewModel = "models/vj_base/weapons/v_glock.mdl"
SWEP.WorldModel = "models/vj_base/weapons/w_glock.mdl"
SWEP.HoldType = "pistol"
SWEP.ViewModelFOV = 70
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.SwayScale = 2

SWEP.NPC_NextPrimaryFire = 0.3
SWEP.NPC_CustomSpread = 0.8

SWEP.Primary.AllowInWater = true
SWEP.Primary.Damage = 25
SWEP.Primary.PlayerDamage = 15
SWEP.Primary.Force = 5
SWEP.Primary.ClipSize = 17
SWEP.Primary.Recoil = 0.3
SWEP.Primary.Cone = 5
SWEP.Primary.Delay = .133 -- What is funny is that the realistic rate would be .075
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "Pistol"
SWEP.Primary.Sound = "VJ.Weapon_Glock17.Single"
SWEP.PrimaryEffects_MuzzleAttachment = 1
SWEP.PrimaryEffects_ShellType = "ShellEject"

SWEP.AnimTbl_Deploy = ACT_VM_IDLE_TO_LOWERED
SWEP.HasReloadSound = true
SWEP.ReloadSound = "vj_base/weapons/glock17/reload.wav"
SWEP.Reload_TimeUntilAmmoIsSet = 1.5
