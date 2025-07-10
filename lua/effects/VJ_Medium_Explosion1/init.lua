/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
function EFFECT:Init(data)
	local origin = data:GetOrigin()
	local emitter = ParticleEmitter(origin)

	-- Smoke screen
	for _ = 1, 12 do
		local smoke = emitter:Add("particles/smokey", origin)
		if smoke then
			smoke:SetVelocity(Vector(math.random(-40, 40), math.random(-40, 40), math.random(5, 15)))
			smoke:SetDieTime(math.Rand(15, 17))
			smoke:SetStartAlpha(math.Rand(220, 230))
			smoke:SetEndAlpha(0)
			smoke:SetStartSize(math.Rand(130, 170))
			smoke:SetEndSize(math.Rand(300, 350))
			smoke:SetRoll(math.Rand(480, 540))
			smoke:SetRollDelta(math.Rand(-0.2, 0.2))
			smoke:SetColor(100, 100, 100)
			smoke:SetGravity(Vector(0, 0, 0))
			smoke:SetAirResistance(15)
			smoke:SetCollide(true)
		end
	end

	-- Cloud of smoke that goes up
	for _ = 1, 8 do
		local smoke = emitter:Add("particles/smokey", origin)
		if smoke then
			smoke:SetVelocity(Vector(math.random(-60, 70), math.random(-100, 70), math.random(70, 140)))
			smoke:SetDieTime(math.Rand(4, 5))
			smoke:SetStartAlpha(math.Rand(220, 230))
			smoke:SetEndAlpha(0)
			smoke:SetStartSize(math.Rand(55, 66))
			smoke:SetEndSize(math.Rand(192, 256))
			smoke:SetRoll(math.Rand(480, 540))
			smoke:SetRollDelta(math.Rand(-0.2, 0.2))
			smoke:SetColor(50, 50, 50)
			smoke:SetGravity(Vector(0, 0, math.random(-30, -10)))
			smoke:SetCollide(true)
		end
	end
	
	-- Flames
	for _ = 1, 8 do
		local flame = emitter:Add("particles/flamelet1", origin)
		if flame then
			flame:SetVelocity(Vector(math.random(-30, 30), math.random(-30, 30), math.random(30, 40)))
			flame:SetDieTime(math.Rand(0.4, 0.6))
			flame:SetStartAlpha(math.Rand(90, 100))
			flame:SetEndAlpha(0)
			flame:SetStartSize(math.Rand(100, 120))
			flame:SetEndSize(math.Rand(200, 220))
			flame:SetRoll(math.Rand(480, 540))
			flame:SetRollDelta(0)
			flame:SetColor(170, 170, 170)
			flame:SetGravity(Vector(0, 0, math.random(-30, -10)))
			flame:SetCollide(true)
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