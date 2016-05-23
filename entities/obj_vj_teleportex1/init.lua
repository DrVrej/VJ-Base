if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
AddCSLuaFile("shared.lua")
include("shared.lua")
/*--------------------------------------------------
	=============== Spawner Base ===============
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to make spawners.
--------------------------------------------------*/
	-- General ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Model = {"models/props_c17/door01_left.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.HasInvisibleModel = false -- Should the entity spawn with a invisible model?
ENT.EntityToTeleportTo = "obj_vj_teleportex2"
/*--------------------------------------------------
	=============== Spawner Base ===============
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to make spawners.
--------------------------------------------------*/