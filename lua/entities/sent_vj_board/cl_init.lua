local VJExists = "lua/autorun/vj_base_autorun.lua"
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
include("shared.lua")
/*--------------------------------------------------
	=============== Board Entity ===============
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used for defending a certain area from enemies, SNPCs will attack it when close.
--------------------------------------------------*/

function ENT:Draw()
	self.Entity:DrawModel()
end