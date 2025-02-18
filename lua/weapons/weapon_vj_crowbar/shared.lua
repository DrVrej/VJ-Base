SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "Crowbar"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Category = "VJ Base"
SWEP.MadeForNPCsOnly = true -- Is this weapon meant to be for NPCs only?
SWEP.ReplacementWeapon = "weapon_crowbar"

if CLIENT then
	VJ.AddKillIcon("weapon_vj_crowbar", SWEP.PrintName, VJ.KILLICON_TYPE_ALIAS, "weapon_crowbar")
end
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire = 1 -- RPM of the weapon in seconds | Calculation: 60 / RPM
SWEP.NPC_TimeUntilFire = 0.4 -- How much time until the bullet/projectile is fired?
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.HoldType = "melee"
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage = 20 -- Damage
SWEP.IsMeleeWeapon = true -- Should this weapon be a melee weapon?