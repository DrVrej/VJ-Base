AddCSLuaFile()

SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "SSG-08"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Category = "VJ Base"

SWEP.MadeForNPCsOnly = true
SWEP.WorldModel = "models/vj_base/weapons/w_ssg08.mdl"
SWEP.WorldModelOffsetParams = {
	Enabled = true,
	Pos = Vector(4.427, -1, -0.117),
	Ang = Angle(0, 90, -172)
}
SWEP.HoldType = "ar2"

SWEP.NPC_NextPrimaryFire = 2
SWEP.NPC_TimeUntilFire = 0.5
SWEP.NPC_CustomSpread = 0.5
SWEP.NPC_FiringDistanceScale = 2.5
SWEP.NPC_StandingOnly = true
SWEP.NPC_ReloadSound = "vj_base/weapons/reload_rifle_bolt.wav"
SWEP.NPC_ExtraFireSound = "vj_base/weapons/cycle_rifle_bolt.wav"
SWEP.NPC_ExtraFireSoundTime = 0.4

SWEP.Primary.Damage = 80
SWEP.Primary.Force = 1
SWEP.Primary.ClipSize = 10
SWEP.Primary.Ammo = "SniperRound"
SWEP.Primary.Sound = "VJ.Weapon_SSG08.Single"