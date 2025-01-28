/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
function EFFECT:Init(data)
	local ent = data:GetEntity()
	local origin = data:GetOrigin()
	local scale = data:GetScale()
	local emitter = ParticleEmitter(origin)
	
	-- Dust
	local dust = emitter:Add("particles/smokey", origin)
	if dust then
		dust:SetVelocity(ent:GetVelocity() + ent:GetForward() * math.Rand(100, 200) + Vector(math.Rand(5, -5), math.Rand(5, -5),math.Rand(5, -5)))
		dust:SetDieTime(4)
		dust:SetStartAlpha(50)
		dust:SetEndAlpha(0)
		dust:SetStartSize(math.Rand(12, 20))
		dust:SetEndSize(math.Rand(80, 100) * scale)
		dust:SetRoll(math.Rand(-0.2, 0.2))
		dust:SetColor(80, 60, 20)
		dust:SetAirResistance(300)
		dust:SetGravity(Vector(0, 0, 50))
	end
	emitter:Finish()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Think()
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Render() end -- To avoid "ERROR" from appearing for single tick