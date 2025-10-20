AddCSLuaFile()

SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "Blaster"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Category = "VJ Base"
SWEP.Spawnable = true

SWEP.ViewModel = "models/vj_base/weapons/c_e5.mdl"
SWEP.WorldModel = "models/vj_base/weapons/w_e5.mdl"
SWEP.HoldType = "ar2"
SWEP.Slot = 2
SWEP.SlotPos = 4
SWEP.UseHands = true

SWEP.NPC_NextPrimaryFire = 0.3
SWEP.NPC_ReloadSound = "vj_base/weapons/blaster/reload.wav"

SWEP.Primary.Damage = 10
SWEP.Primary.Force = 5
SWEP.Primary.ClipSize = 30
SWEP.Primary.Recoil = 0.6
SWEP.Primary.Delay = 0.3
SWEP.Primary.TracerType = "VJ_Tracer_Red"
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "SMG1"
SWEP.Primary.Sound = "VJ.Weapon_Blaster.Single" // npc/roller/mine/rmine_explode_shock1.wav
SWEP.PrimaryEffects_MuzzleParticles = {"vj_muzzle_blaster_red"}
SWEP.PrimaryEffects_MuzzleParticlesAsOne = true
SWEP.PrimaryEffects_MuzzleAttachment = "muzzle"
SWEP.PrimaryEffects_SpawnShells = false
SWEP.PrimaryEffects_DynamicLightColor = VJ.COLOR_RED

SWEP.HasReloadSound = true
SWEP.ReloadSound = "vj_base/weapons/blaster/reload.wav"
SWEP.Reload_TimeUntilAmmoIsSet = 0.8