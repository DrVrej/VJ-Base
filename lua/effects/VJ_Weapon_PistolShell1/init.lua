if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
/*--------------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
function EFFECT:Init(data)
	local ent = data:GetEntity()
	if !IsValid(ent) then return end
	local effectData = EffectData()
	effectData:SetOrigin(self:GetTracerShootPos(data:GetOrigin(), ent, data:GetAttachment()))
	util.Effect("ShellEject", effectData, true, true)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Think()
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Render()
end