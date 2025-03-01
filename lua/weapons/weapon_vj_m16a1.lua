AddCSLuaFile()

SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "M4A1"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Category = "VJ Base"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/cstrike/c_rif_m4a1.mdl"
SWEP.WorldModel = "models/vj_base/weapons/w_m4a1_s.mdl"
SWEP.WorldModel_UseCustomPosition = true
SWEP.WorldModel_CustomPositionAngle = Vector(0, 90, 180)
SWEP.WorldModel_CustomPositionOrigin = Vector(-3.4, -1, 0)
SWEP.HoldType = "ar2"
SWEP.ViewModelFlip = false
SWEP.Slot = 2
SWEP.SlotPos = 4
SWEP.SwayScale = 1
SWEP.UseHands = true

SWEP.Primary.Damage = 5
SWEP.Primary.PlayerDamage = "Double"
SWEP.Primary.Force = 5
SWEP.Primary.ClipSize = 30
SWEP.Primary.Recoil = 0.3
SWEP.Primary.Delay = 0.1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "SMG1"
SWEP.Primary.Sound = "VJ.Weapon_M4A1.Single"
SWEP.PrimaryEffects_MuzzleAttachment = 1
SWEP.PrimaryEffects_ShellType = "RifleShellEject"

SWEP.Reload_TimeUntilAmmoIsSet	= 1.8
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OnAnimEvent(pos, ang, event, options)
	if event == 5001 then return true end  -- Asiga hose vor shtke gedervadz flash-e
end