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
	
	-- Smoke
	local smoke = emitter:Add("particles/smokey", origin)
	if smoke then
		smoke:SetVelocity(ent:GetVelocity() + ent:GetForward() * -30)
		smoke:SetDieTime(0.6)
		smoke:SetStartAlpha(80)
		smoke:SetEndAlpha(0)
		smoke:SetStartSize(5)
		smoke:SetEndSize(40 * scale)
		smoke:SetRoll(math.Rand(-0.2, 0.2))
		smoke:SetColor(150, 150, 150, 255)
		smoke:SetAirResistance(100)
	end

	-- Heat wave
	local heatwave = emitter:Add("sprites/heatwave", origin)
	if heatwave then
		heatwave:SetVelocity(ent:GetVelocity() + ent:GetForward() * math.Rand(0, 50) + Vector(math.Rand(5, -5), math.Rand(5, -5), math.Rand(5, -5)))
		heatwave:SetDieTime(0.1)
		heatwave:SetStartAlpha(255)
		heatwave:SetEndAlpha(255)
		heatwave:SetStartSize(10 * scale)
		heatwave:SetEndSize(5)
		heatwave:SetRoll(math.Rand(-50, 50))
		heatwave:SetColor(255, 255, 255)
	end
	emitter:Finish()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Think()
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Render() end -- To avoid "ERROR" from appearing for single tick