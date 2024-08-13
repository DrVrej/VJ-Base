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

-- 
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