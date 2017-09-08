/*--------------------------------------------------
	=============== Files ===============
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to load Files for VJ Base
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
include('autorun/vj_controls.lua')

-- Add Decals -------------------------------------------------------------------------------------------------------------------------
game.AddDecal("VJ_AcidSlime1",{"vj_base/decals/vj_acidslime1","vj_base/decals/vj_acidslime2","vj_base/decals/vj_acidslime3","vj_base/decals/vj_acidslime4"})
game.AddDecal("VJ_Blood_Red",{"vj_base/decals/blood/vj_redblood1","vj_base/decals/blood/vj_redblood2","vj_base/decals/blood/vj_redblood3","vj_base/decals/blood/vj_redblood4","vj_base/decals/blood/vj_redblood5","vj_base/decals/blood/vj_redblood6"})
game.AddDecal("VJ_Blood_Yellow",{"vj_base/decals/blood/vj_yellowblood1","vj_base/decals/blood/vj_yellowblood2","vj_base/decals/blood/vj_yellowblood3","vj_base/decals/blood/vj_yellowblood4","vj_base/decals/blood/vj_yellowblood5","vj_base/decals/blood/vj_yellowblood6"})
game.AddDecal("VJ_Blood_Green",{"vj_base/decals/blood/vj_greenblood1","vj_base/decals/blood/vj_greenblood2","vj_base/decals/blood/vj_greenblood3","vj_base/decals/blood/vj_greenblood4","vj_base/decals/blood/vj_greenblood5","vj_base/decals/blood/vj_greenblood6"})
game.AddDecal("VJ_Blood_Orange",{"vj_base/decals/blood/vj_orangeblood1","vj_base/decals/blood/vj_orangeblood2","vj_base/decals/blood/vj_orangeblood3","vj_base/decals/blood/vj_orangeblood4","vj_base/decals/blood/vj_orangeblood5","vj_base/decals/blood/vj_orangeblood6"})
game.AddDecal("VJ_Blood_Blue",{"vj_base/decals/blood/vj_blueblood1","vj_base/decals/blood/vj_blueblood2","vj_base/decals/blood/vj_blueblood3","vj_base/decals/blood/vj_blueblood4","vj_base/decals/blood/vj_blueblood5","vj_base/decals/blood/vj_blueblood6"})
game.AddDecal("VJ_Blood_Purple",{"vj_base/decals/blood/vj_purpleblood1","vj_base/decals/blood/vj_purpleblood2","vj_base/decals/blood/vj_purpleblood3","vj_base/decals/blood/vj_purpleblood4","vj_base/decals/blood/vj_purpleblood5","vj_base/decals/blood/vj_purpleblood6"})
game.AddDecal("VJ_Blood_White",{"vj_base/decals/blood/vj_whiteblood1","vj_base/decals/blood/vj_whiteblood2","vj_base/decals/blood/vj_whiteblood3","vj_base/decals/blood/vj_whiteblood4","vj_base/decals/blood/vj_whiteblood5","vj_base/decals/blood/vj_whiteblood6"})
game.AddDecal("VJ_Blood_Oil",{"vj_base/decals/blood/vj_oilblood1","vj_base/decals/blood/vj_oilblood2","vj_base/decals/blood/vj_oilblood3","vj_base/decals/blood/vj_oilblood4","vj_base/decals/blood/vj_oilblood5","vj_base/decals/blood/vj_oilblood6"})
-- Precache Models -------------------------------------------------------------------------------------------------------------------------
	-- Alien Gibs --
util.PrecacheModel("models/gibs/xenians/mgib_01.mdl")
util.PrecacheModel("models/gibs/xenians/mgib_02.mdl")
util.PrecacheModel("models/gibs/xenians/mgib_03.mdl")
util.PrecacheModel("models/gibs/xenians/mgib_04.mdl")
util.PrecacheModel("models/gibs/xenians/mgib_05.mdl")
util.PrecacheModel("models/gibs/xenians/mgib_06.mdl")
util.PrecacheModel("models/gibs/xenians/sgib_01.mdl")
util.PrecacheModel("models/gibs/xenians/sgib_02.mdl")
util.PrecacheModel("models/gibs/xenians/sgib_03.mdl")
	-- Human Gibs --
util.PrecacheModel("models/gibs/humans/brain_gib.mdl")
util.PrecacheModel("models/gibs/humans/eye_gib.mdl")
util.PrecacheModel("models/gibs/humans/heart_gib.mdl")
util.PrecacheModel("models/gibs/humans/liver_gib.mdl")
util.PrecacheModel("models/gibs/humans/lung_gib.mdl")
util.PrecacheModel("models/gibs/humans/mgib_01.mdl")
util.PrecacheModel("models/gibs/humans/mgib_02.mdl")
util.PrecacheModel("models/gibs/humans/mgib_03.mdl")
util.PrecacheModel("models/gibs/humans/mgib_04.mdl")
util.PrecacheModel("models/gibs/humans/mgib_05.mdl")
util.PrecacheModel("models/gibs/humans/mgib_06.mdl")
util.PrecacheModel("models/gibs/humans/mgib_07.mdl")
util.PrecacheModel("models/gibs/humans/sgib_01.mdl")
util.PrecacheModel("models/gibs/humans/sgib_02.mdl")
util.PrecacheModel("models/gibs/humans/sgib_03.mdl")
	-- Projectiles --
util.PrecacheModel("models/grub_nugget_large.mdl")
util.PrecacheModel("models/grub_nugget_medium.mdl")
util.PrecacheModel("models/grub_nugget_small.mdl")
util.PrecacheModel("models/spitball_large.mdl")
util.PrecacheModel("models/spitball_medium.mdl")
util.PrecacheModel("models/spitball_small.mdl")

-- Menu Language -------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
	language.Add("vjbase.menugeneral.default", "Default")
	language.Add("vjbase.menudifficulty.easy", "Easy | -50% Health and Damage")
	language.Add("vjbase.menudifficulty.normal", "Normal | Original Health and Damage")
	language.Add("vjbase.menudifficulty.hard", "Hard | +50% Health and Damage")
	language.Add("vjbase.menudifficulty.hellonearth", "Hell On Earth | +150% Health and Damage")
end

-- Fonts -------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
	surface.CreateFont( "VJFont_Trebuchet24_Large",{
		font = "Trebuchet24",
		size = 34, -- Size
		weight = 600, -- Boldness
		blursize = 0, -- Blurness, should be 1 or 0
		antialias = true, -- Is it smooth?
		italic = false, -- Is it Italic?
	})

	surface.CreateFont( "VJFont_Trebuchet24_MediumLarge",{
		font = "Trebuchet24",
		size = 26, -- Size
		weight = 600, -- Boldness
		blursize = 0, -- Blurness, should be 1 or 0
		antialias = true, -- Is it smooth?
		italic = false, -- Is it Italic?
	})

	surface.CreateFont( "VJFont_Trebuchet24_Medium",{
		font = "Trebuchet24",
		size = 24, -- Size
		weight = 600, -- Boldness
		blursize = 0, -- Blurness, should be 1 or 0
		antialias = true, -- Is it smooth?
		italic = false, -- Is it Italic?
	})

	surface.CreateFont( "VJFont_Trebuchet24_SmallMedium",{
		font = "Trebuchet24",
		size = 17, -- Size
		weight = 600, -- Boldness
		blursize = 0, -- Blurness, should be 1 or 0
		antialias = true, -- Is it smooth?
		italic = false, -- Is it Italic?
	})

	surface.CreateFont( "VJFont_Trebuchet24_Small",{
		font = "Trebuchet24",
		size = 16, -- Size
		weight = 600, -- Boldness
		blursize = 0, -- Blurness, should be 1 or 0
		antialias = true, -- Is it smooth?
		italic = false, -- Is it Italic?
	})

	surface.CreateFont( "VJFont_Trebuchet24_Tiny",{
		font = "Trebuchet24",
		size = 11, -- Size
		weight = 600, -- Boldness
		blursize = 0, -- Blurness, should be 1 or 0
		antialias = true, -- Is it smooth?
		italic = false, -- Is it Italic?
	})

	surface.CreateFont( "VJFont_Trebuchet24_TinyItalic",{
		font = "Trebuchet24",
		size = 11, -- Size
		weight = 600, -- Boldness
		blursize = 0, -- Blurness, should be 1 or 0
		antialias = true, -- Is it smooth?
		italic = true, -- Is it Italic?
	})
end