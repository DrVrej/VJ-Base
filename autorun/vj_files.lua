/*--------------------------------------------------
	=============== Files ===============
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to load Files for VJ Base
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
include('autorun/vj_controls.lua')

-- Add Decals -------------------------------------------------------------------------------------------------------------------------
game.AddDecal("VJ_AcidSlime1",{"VJ_Base/decals/vj_acidslime1","VJ_Base/decals/vj_acidslime2","VJ_Base/decals/vj_acidslime3","VJ_Base/decals/vj_acidslime4"})
//game.AddDecal("vj_acidslime2","VJ_Base/decals/vj_acidslime2")
//game.AddDecal("vj_acidslime3","VJ_Base/decals/vj_acidslime3")
//game.AddDecal("vj_acidslime4","VJ_Base/decals/vj_acidslime4")
game.AddDecal("VJ_BlueBlood1","VJ_Base/decals/vj_blueblood1")
game.AddDecal("VJ_GreenBlood1","VJ_Base/decals/vj_greenblood1")
game.AddDecal("VJ_OrangeBlood1","VJ_Base/decals/vj_orangeblood1")
game.AddDecal("VJ_PurpleBlood1","VJ_Base/decals/vj_purpleblood1")

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

-- Menu Language Code -------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
	language.Add("vjbase.menugeneral.default", "Default")
	language.Add("vjbase.menudifficulty.easy", "Easy | -50% Health and Damage")
	language.Add("vjbase.menudifficulty.normal", "Normal | Original Health and Damage")
	language.Add("vjbase.menudifficulty.hard", "Hard | +50% Health and Damage")
	language.Add("vjbase.menudifficulty.hellonearth", "Hell On Earth | +150% Health and Damage")
end