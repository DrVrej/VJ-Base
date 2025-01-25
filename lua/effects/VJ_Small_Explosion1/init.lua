/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
function EFFECT:Init(data)
	local origin = data:GetOrigin()
	local emitter = ParticleEmitter(origin)
	
	-- Smoke screen
	for _ = 1, 5 do
		local smoke = emitter:Add("particles/smokey", origin)
		if smoke then
			smoke:SetVelocity(Vector(math.random(-40, 40), math.random(-40, 40), math.random(5, 15)))
			smoke:SetDieTime(math.Rand(8, 9))
			smoke:SetStartAlpha(math.Rand(200, 230))
			smoke:SetEndAlpha(0)
			smoke:SetStartSize(math.Rand(80, 100))
			smoke:SetEndSize(math.Rand(130, 150))
			smoke:SetRoll(math.Rand(480, 540))
			smoke:SetRollDelta(math.Rand(-0.2, 0.2))
			smoke:SetColor(50, 50, 50)
			smoke:SetGravity(Vector(0,  0,  0))
			smoke:SetAirResistance(15)
			smoke:SetCollide(true)
		end
	end
	
	-- Cloud of smoke that goes up
	for _ = 1, 5 do
		local smoke = emitter:Add("particles/smokey", origin)
		if smoke then
			smoke:SetVelocity(Vector(math.random(-60, 70), math.random(-60, 70), math.random(70, 80)))
			smoke:SetDieTime(math.Rand(3, 4))
			smoke:SetStartAlpha(math.Rand(150, 190))
			smoke:SetEndAlpha(0)
			smoke:SetStartSize(math.Rand(80, 100))
			smoke:SetEndSize(math.Rand(130, 150))
			smoke:SetRoll(math.Rand(480, 540))
			smoke:SetRollDelta(math.Rand(-0.2, 0.2))
			smoke:SetColor(50, 50, 50)
			smoke:SetGravity(Vector(0, 0, math.random(-30, -10)))
			smoke:SetCollide(true)
		end
	end
	
	-- Flames
	for _ = 1, 3 do
		local flame = emitter:Add("particles/flamelet1", origin)
		if flame then
			flame:SetVelocity(Vector(math.random(-30, 30), math.random(-30, 30), math.random(30, 40)))
			flame:SetDieTime(math.Rand(0.4, 0.6))
			flame:SetStartAlpha(math.Rand(90, 100))
			flame:SetEndAlpha(0)
			flame:SetStartSize(math.Rand(60, 80))
			flame:SetEndSize(math.Rand(100, 120))
			flame:SetRoll(math.Rand(480, 540))
			flame:SetRollDelta(0)
			flame:SetColor(255, 255, 255)
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