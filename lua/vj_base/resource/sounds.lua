/*--------------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
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
local PITCH_VJ_RAND		= {90, 110}
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
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Weapons ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- AK-47
sound.Add({
	name = "VJ.Weapon_AK47.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = PITCH_VJ_RAND,
	sound = "^vj_base/weapons/ak47/ak47_single.wav"
})

-- AR2
sound.Add({
	name = "VJ.Weapon_AR2.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = PITCH_VJ_RAND,
	sound = {"^vj_base/weapons/ar2/ar2_single1.wav", "^vj_base/weapons/ar2/ar2_single2.wav", "^vj_base/weapons/ar2/ar2_single3.wav"}
})
sound.Add({
	name = "VJ.Weapon_AR2.Secondary",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = PITCH_VJ_RAND,
	sound = "^vj_base/weapons/ar2/ar2_secondary.wav"
})

-- Blaster
sound.Add({
	name = "VJ.Weapon_Blaster.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = PITCH_VJ_RAND,
	sound = "^vj_base/weapons/blaster/blaster_single.wav"
})

-- Flare Gun
sound.Add({
	name = "VJ.Weapon_FlareGun.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = PITCH_VJ_RAND,
	sound = "^vj_base/weapons/flaregun/flaregun_single.wav"
})

-- Glock 17
sound.Add({
	name = "VJ.Weapon_Glock17.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = PITCH_VJ_RAND,
	sound = "^vj_base/weapons/glock17/glock17_single.wav"
})

-- K-3
sound.Add({
	name = "VJ.Weapon_K3.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = PITCH_VJ_RAND,
	sound = "^vj_base/weapons/k3_armenian/k3_single.wav"
})

-- M4A1
sound.Add({
	name = "VJ.Weapon_M4A1.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = PITCH_VJ_RAND,
	sound = "^vj_base/weapons/m4a1/m4a1_single.wav"
})

-- MP 40
sound.Add({
	name = "VJ.Weapon_MP40.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = PITCH_VJ_RAND,
	sound = "^vj_base/weapons/mp40/mp40_single.wav"
})
sound.Add({
	name = "VJ.Weapon_MP40.BoltBack",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = SNDLVL_NORM,
	pitch = PITCH_NORM,
	sound = "vj_base/weapons/mp40/mp40_boltback.wav"
})
sound.Add({
	name = "VJ.Weapon_MP40.BoltForward",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = SNDLVL_NORM,
	pitch = PITCH_NORM,
	sound = "vj_base/weapons/mp40/mp40_boltforward.wav"
})
sound.Add({
	name = "VJ.Weapon_MP40.ClipIn",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = SNDLVL_NORM,
	pitch = PITCH_NORM,
	sound = "vj_base/weapons/mp40/mp40_clipin.wav"
})
sound.Add({
	name = "VJ.Weapon_MP40.ClipOut",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = SNDLVL_NORM,
	pitch = PITCH_NORM,
	sound = "vj_base/weapons/mp40/mp40_clipout.wav"
})

-- 9mm Pistol
sound.Add({
	name = "VJ.Weapon_9mmPistol.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = PITCH_VJ_RAND,
	sound = {"^vj_base/weapons/pistol_9mm/9mm_single1.wav", "^vj_base/weapons/pistol_9mm/9mm_single2.wav", "^vj_base/weapons/pistol_9mm/9mm_single3.wav"}
})

-- .357 Magnum
sound.Add({
	name = "VJ.Weapon_357Magnum.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = PITCH_VJ_RAND,
	sound = {"^vj_base/weapons/revolver_357/357_single1.wav", "^vj_base/weapons/revolver_357/357_single2.wav", "^vj_base/weapons/revolver_357/357_single3.wav"}
})

-- RPG
sound.Add({
	name = "VJ.Weapon_RPG.Single1",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = PITCH_VJ_RAND,
	sound = "^vj_base/weapons/rpg/rpg1_single.wav"
})
sound.Add({
	name = "VJ.Weapon_RPG.Single2",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = PITCH_VJ_RAND,
	sound = "^vj_base/weapons/rpg/rpg2_single.wav"
})

-- SMG1
sound.Add({
	name = "VJ.Weapon_SMG1.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = PITCH_VJ_RAND,
	sound = {"^vj_base/weapons/smg1/smg1_single1.wav", "^vj_base/weapons/smg1/smg1_single2.wav", "^vj_base/weapons/smg1/smg1_single3.wav"}
})
sound.Add({
	name = "VJ.Weapon_SMG1.Secondary",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 100, -- Since it's a grenade launcher, make it less than a gun shot!
	pitch = PITCH_VJ_RAND,
	sound = "^vj_base/weapons/smg1/smg1_glauncher.wav"
})

-- SPAS-12
sound.Add({
	name = "VJ.Weapon_SPAS12.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = PITCH_VJ_RAND,
	sound = "^vj_base/weapons/spas12/spas12_single.wav"
})

-- SSG-08
sound.Add({
	name = "VJ.Weapon_SSG08.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = PITCH_VJ_RAND,
	sound = {"^vj_base/weapons/ssg08/ssg08_single1.wav", "^vj_base/weapons/ssg08/ssg08_single2.wav", "^vj_base/weapons/ssg08/ssg08_single3.wav"}
})