AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
--
-- INFO: Used to make simple objects that can be also be animated, works similar to "prop_dynamic"
--
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetSolid(SOLID_OBB)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	self:NextThink(CurTime())
	return true
end
