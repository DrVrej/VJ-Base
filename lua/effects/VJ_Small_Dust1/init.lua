if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
/*--------------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
function EFFECT:Init(data)
	self.Pos = data:GetOrigin()
	local Emitter = ParticleEmitter(self.Pos)
	if Emitter == nil then return end
	
	-- Cloud of smoke that goes up
	for i = 1,8 do
		local EffectCode = Emitter:Add("particles/smokey",self.Pos)
		EffectCode:SetVelocity(Vector(math.random(-40,40),math.random(-40,40),math.random(5,15)))
		EffectCode:SetDieTime(math.Rand(7,9)) -- How much time until it dies
		EffectCode:SetStartAlpha(150) -- Transparency
		EffectCode:SetStartSize(math.Rand(20,40)) -- Size of the effect
		EffectCode:SetEndSize(math.Rand(100,120)) -- Size of the effect at the end (The effect slowly trasnsforms to this size)
		EffectCode:SetRoll(math.Rand(480,540))
		EffectCode:SetRollDelta(math.Rand(-0.2,0.2)) -- How fast it rolls
		EffectCode:SetColor(80,60,20) -- The color of the effect
		EffectCode:SetGravity(Vector(0, 0, 0)) -- The Gravity
		EffectCode:SetAirResistance(15)
	end
	Emitter:Finish()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Think()
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Render()
end