SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "K-3"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Category = "VJ Base"
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.MadeForNPCsOnly = true -- Is this weapon meant to be for NPCs only?
SWEP.WorldModel = "models/vj_base/weapons/w_k3.mdl"
SWEP.HoldType = "ar2"
	-- World Model ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.WorldModel_UseCustomPosition = true -- Should the gun use custom position? This can be used to fix guns that are in the crotch
SWEP.WorldModel_CustomPositionAngle = Vector(-10, 0, 180)
SWEP.WorldModel_CustomPositionOrigin = Vector(-10, -8, -61)
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage = 12 -- Damage
SWEP.Primary.Force = 1 -- Force applied on the object the bullet hits
SWEP.Primary.ClipSize = 45 -- Max amount of rounds per clip
SWEP.Primary.Ammo = "SMG1" -- Ammo type
SWEP.Primary.Sound = "VJ.Weapon_K3.Single"
SWEP.PrimaryEffects_MuzzleAttachment = "muzzle"
SWEP.PrimaryEffects_ShellType = "RifleShellEject"