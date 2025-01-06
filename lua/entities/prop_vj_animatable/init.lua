AddCSLuaFile("shared.lua")
include("shared.lua")
/*--------------------------------------------------
	=============== VJ Prop Animatable Entity ===============
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to make simple props and animate them, since prop_dynamic doesn't work properly in Garry's Mod...
--------------------------------------------------*/
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetSolid(SOLID_OBB)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	self:NextThink(CurTime())
	return true
end
