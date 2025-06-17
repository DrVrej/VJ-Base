AddCSLuaFile()

SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "Crowbar"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Category = "VJ Base"

if CLIENT then
	VJ.AddKillIcon("weapon_vj_crowbar", SWEP.PrintName, VJ.KILLICON_TYPE_ALIAS, "weapon_crowbar")
end

SWEP.MadeForNPCsOnly = true
SWEP.ReplacementWeapon = "weapon_crowbar"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.HoldType = "melee"

SWEP.NPC_TimeUntilFire = 0.4

SWEP.Primary.Damage = 20
SWEP.IsMeleeWeapon = true