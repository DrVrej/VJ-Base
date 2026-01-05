/*--------------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
//local SNDLVL_IDLE		= 60
local SNDLVL_NORM 		= 75
//local SNDLVL_TALKING	= 80
local SNDLVL_GUNFIRE	= 140

//local PITCH_LOW 		= 95
local PITCH_NORM 		= 100
//local PITCH_HIGH 		= 120
local PITCH_RANDOM		= {90, 110}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ General ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Explosions
sound.Add({
	name = "VJ.Explosion",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = PITCH_NORM,
	sound = {"^vj_base/ambience/explosion1.wav", "^vj_base/ambience/explosion2.wav", "^vj_base/ambience/explosion3.wav", "^vj_base/ambience/explosion4.wav", "^vj_base/ambience/explosion5.wav"}
})

-- Impacts
sound.Add({
	name = "VJ.Impact.Armor",
	channel = CHAN_BODY,
	volume = 1.0,
	level = SNDLVL_NORM,
	pitch = PITCH_RANDOM,
	sound = {"vj_base/impact/armor1.wav", "vj_base/impact/armor2.wav", "vj_base/impact/armor3.wav", "vj_base/impact/armor4.wav", "vj_base/impact/armor5.wav", "vj_base/impact/armor6.wav", "vj_base/impact/armor7.wav", "vj_base/impact/armor8.wav", "vj_base/impact/armor9.wav", "vj_base/impact/armor10.wav"}
})
sound.Add({
	name = "VJ.Impact.Metal_Crush",
	channel = CHAN_BODY,
	volume = 1.0,
	level = SNDLVL_NORM,
	pitch = PITCH_RANDOM,
	sound = {"vj_base/impact/metal_crush1.wav", "vj_base/impact/metal_crush2.wav", "vj_base/impact/metal_crush3.wav"}
})
sound.Add({
	name = "VJ.Impact.Flesh_Alien",
	channel = CHAN_BODY,
	volume = 1.0,
	level = SNDLVL_NORM,
	pitch = PITCH_RANDOM,
	sound = "vj_base/impact/flesh_alien.wav"
})

-- Gibs
sound.Add({
	name = "VJ.Gib.Bone_Snap",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 80,
	pitch = {80, 100},
	sound = {"vj_base/gib/bone_snap1.wav", "vj_base/gib/bone_snap2.wav", "vj_base/gib/bone_snap3.wav"}
})
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ NPCs ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Tanks
sound.Add({
	name = "VJ.NPC_Tank.Fire",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = PITCH_RANDOM,
	sound = {"^vj_base/vehicles/armored/gun_main_fire1.wav", "^vj_base/vehicles/armored/gun_main_fire2.wav", "^vj_base/vehicles/armored/gun_main_fire3.wav", "^vj_base/vehicles/armored/gun_main_fire4.wav"}
})

sound.Add({
	name = "VJ.Footstep.Human",
	channel = CHAN_AUTO,
	volume = 0.8,
	level = SNDLVL_NORM,
	pitch = {80, 100},
	sound = {"npc/metropolice/gear1.wav", "npc/metropolice/gear2.wav", "npc/metropolice/gear3.wav", "npc/metropolice/gear4.wav", "npc/metropolice/gear5.wav", "npc/metropolice/gear6.wav"}
})
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Weapons - General ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
sound.Add({
	name = "VJ.Weapon.Draw_Pistol",
	channel = CHAN_BODY,
	volume = 1.0,
	level = SNDLVL_NORM,
	pitch = PITCH_NORM,
	sound = "vj_base/weapons/draw_pistol.wav"
})

sound.Add({
	name = "VJ.Weapon.Draw_Rifle",
	channel = CHAN_BODY,
	volume = 1.0,
	level = SNDLVL_NORM,
	pitch = PITCH_NORM,
	sound = "vj_base/weapons/draw_rifle.wav"
})

sound.Add({
	name = "VJ.Weapon.Draw_Shotgun",
	channel = CHAN_BODY,
	volume = 1.0,
	level = SNDLVL_NORM,
	pitch = PITCH_NORM,
	sound = "vj_base/weapons/draw_shotgun.wav"
})
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Weapons ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- AK-47
sound.Add({
	name = "VJ.Weapon_AK47.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = PITCH_RANDOM,
	sound = "^vj_base/weapons/ak47/single.wav"
})

-- AR2
sound.Add({
	name = "VJ.Weapon_AR2.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = PITCH_RANDOM,
	sound = {"^vj_base/weapons/ar2/single1.wav", "^vj_base/weapons/ar2/single2.wav", "^vj_base/weapons/ar2/single3.wav"}
})
sound.Add({
	name = "VJ.Weapon_AR2.Secondary",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = PITCH_RANDOM,
	sound = "^vj_base/weapons/ar2/secondary.wav"
})

-- Blaster
sound.Add({
	name = "VJ.Weapon_Blaster.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = PITCH_RANDOM,
	sound = "^vj_base/weapons/blaster/single.wav"
})

-- Flare Gun
sound.Add({
	name = "VJ.Weapon_FlareGun.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = PITCH_RANDOM,
	sound = "^vj_base/weapons/flaregun/single.wav"
})

-- Glock 17
sound.Add({
	name = "VJ.Weapon_Glock17.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = PITCH_RANDOM,
	sound = "^vj_base/weapons/glock17/single.wav"
})

-- K-3
sound.Add({
	name = "VJ.Weapon_K3.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = PITCH_RANDOM,
	sound = "^vj_base/weapons/k3_armenian/single.wav"
})

-- M4A1
sound.Add({
	name = "VJ.Weapon_M4A1.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = PITCH_RANDOM,
	sound = "^vj_base/weapons/m4a1/single.wav"
})

-- MP 40
sound.Add({
	name = "VJ.Weapon_MP40.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = PITCH_RANDOM,
	sound = "^vj_base/weapons/mp40/single.wav"
})
sound.Add({
	name = "VJ.Weapon_MP40.BoltBack",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = SNDLVL_NORM,
	pitch = PITCH_NORM,
	sound = "vj_base/weapons/mp40/boltback.wav"
})
sound.Add({
	name = "VJ.Weapon_MP40.BoltForward",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = SNDLVL_NORM,
	pitch = PITCH_NORM,
	sound = "vj_base/weapons/mp40/boltforward.wav"
})
sound.Add({
	name = "VJ.Weapon_MP40.ClipIn",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = SNDLVL_NORM,
	pitch = PITCH_NORM,
	sound = "vj_base/weapons/mp40/clipin.wav"
})
sound.Add({
	name = "VJ.Weapon_MP40.ClipOut",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = SNDLVL_NORM,
	pitch = PITCH_NORM,
	sound = "vj_base/weapons/mp40/clipout.wav"
})

-- 9mm Pistol
sound.Add({
	name = "VJ.Weapon_9mmPistol.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = PITCH_RANDOM,
	sound = {"^vj_base/weapons/pistol_9mm/single1.wav", "^vj_base/weapons/pistol_9mm/single2.wav", "^vj_base/weapons/pistol_9mm/single3.wav"}
})

-- .357 Magnum
sound.Add({
	name = "VJ.Weapon_357Magnum.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = PITCH_RANDOM,
	sound = {"^vj_base/weapons/revolver_357/single1.wav", "^vj_base/weapons/revolver_357/single2.wav", "^vj_base/weapons/revolver_357/single3.wav"}
})

-- RPG
sound.Add({
	name = "VJ.Weapon_RPG.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = PITCH_RANDOM,
	sound = "^vj_base/weapons/rpg/single.wav"
})

-- SMG1
sound.Add({
	name = "VJ.Weapon_SMG1.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = PITCH_RANDOM,
	sound = {"^vj_base/weapons/smg1/single1.wav", "^vj_base/weapons/smg1/single2.wav", "^vj_base/weapons/smg1/single3.wav"}
})
sound.Add({
	name = "VJ.Weapon_SMG1.Secondary",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 100, -- Since it's a grenade launcher, make it less than a gun shot!
	pitch = PITCH_RANDOM,
	sound = "^vj_base/weapons/smg1/single_launcher.wav"
})

-- SPAS-12
sound.Add({
	name = "VJ.Weapon_SPAS12.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = PITCH_RANDOM,
	sound = "^vj_base/weapons/spas12/single.wav"
})

-- SSG-08
sound.Add({
	name = "VJ.Weapon_SSG08.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = PITCH_RANDOM,
	sound = {"^vj_base/weapons/ssg08/single1.wav", "^vj_base/weapons/ssg08/single2.wav", "^vj_base/weapons/ssg08/single3.wav"}
})