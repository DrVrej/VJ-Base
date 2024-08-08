SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "Crowbar"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose = "This weapon is made for Players and NPCs"
SWEP.Instructions = "Controls are like a regular weapon."
SWEP.Category = "VJ Base"
SWEP.MadeForNPCsOnly = true -- Is this weapon meant to be for NPCs only?
SWEP.ReplacementWeapon = "weapon_crowbar"
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire = 1 -- RPM of the weapon in seconds | Calculation: 60 / RPM
SWEP.NPC_TimeUntilFire = 0.4 -- How much time until the bullet/projectile is fired?
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.HoldType = "melee"
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage = 20 -- Damage
SWEP.IsMeleeWeapon = true -- Should this weapon be a melee weapon?