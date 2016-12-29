if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
/*--------------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
function EFFECT:Init(data)
	if !IsValid(data:GetEntity()) then return end
	self.Pos = self:GetTracerShootPos(data:GetOrigin(),data:GetEntity(),data:GetAttachment())
	local effectdata = EffectData()
	//effectdata:SetEntity(self.Weapon)
	effectdata:SetOrigin(self.Pos)
	effectdata:SetNormal(Vector(0,0,0))
	util.Effect("ShotgunShellEject",effectdata,true,true)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Think()
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Render()
end
/*--------------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/