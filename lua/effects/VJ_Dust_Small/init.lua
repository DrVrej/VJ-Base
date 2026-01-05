/*--------------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
function EFFECT:Init(data)
	local origin = data:GetOrigin()
	local emitter = ParticleEmitter(origin)
	
	-- Cloud of dust that goes up
	for _ = 1, 8 do
		local dust = emitter:Add("particles/smokey", origin)
		if dust then
			dust:SetVelocity(Vector(math.random(-40, 40), math.random(-40, 40), math.random(5, 15)))
			dust:SetDieTime(math.Rand(7, 9))
			dust:SetStartAlpha(150)
			dust:SetEndAlpha(0)
			dust:SetStartSize(math.Rand(20, 40))
			dust:SetEndSize(math.Rand(100, 120))
			dust:SetRoll(math.Rand(480, 540))
			dust:SetRollDelta(math.Rand(-0.2, 0.2))
			dust:SetColor(80, 60, 20)
			dust:SetGravity(Vector(0, 0, 0))
			dust:SetAirResistance(15)
			dust:SetCollide(true)
		end
	end
	emitter:Finish()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Think()
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Render() end -- To avoid "ERROR" from appearing for single a tick