if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
/*--------------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
function EFFECT:Init(data)
	self.Pos = data:GetOrigin()
	local Emitter = ParticleEmitter(self.Pos)
	if Emitter == nil then return end
	
	-- Fire
	for i=1,3 do
		local EffectCode = Emitter:Add("particles/flamelet1",self.Pos)
		EffectCode:SetVelocity(Vector(math.random(-30,30),math.random(-30,30),math.random(30,40)))
		EffectCode:SetDieTime(math.Rand(0.4,0.6)) -- How much time until it dies
		EffectCode:SetStartAlpha(math.Rand(90,100)) -- Transparency
		EffectCode:SetStartSize(math.Rand(60,80)) -- Size of the effect
		EffectCode:SetEndSize(math.Rand(100,100)) -- Size of the effect at the end (The effect slowly trasnsforms to this size)
		EffectCode:SetRoll(math.Rand(480,540))
		EffectCode:SetRollDelta(math.Rand(0,0)) -- How fast it rolls
		EffectCode:SetColor(255,255,255) -- The color of the effect
		EffectCode:SetGravity(Vector(0,0,math.random(-30,-10))) -- The Gravity
	end

	-- Smoke screen
	for i = 1,5 do
		local EffectCode = Emitter:Add("particles/smokey",self.Pos)
		EffectCode:SetVelocity(Vector(math.random(-40,40),math.random(-40,40),math.random(5,15)))
		EffectCode:SetDieTime(math.Rand(7,9)) -- How much time until it dies
		EffectCode:SetStartAlpha(math.Rand(200,230)) -- Transparency
		EffectCode:SetStartSize(math.Rand(80,100)) -- Size of the effect
		EffectCode:SetEndSize(math.Rand(130,150)) -- Size of the effect at the end (The effect slowly trasnsforms to this size)
		EffectCode:SetRoll(math.Rand(480,540))
		EffectCode:SetRollDelta(math.Rand(-0.2,0.2)) -- How fast it rolls
		EffectCode:SetColor(50,50,50) -- The color of the effect
		EffectCode:SetGravity(Vector(0,0,0)) -- The Gravity
		EffectCode:SetAirResistance(15)
	end

	-- Cloud of smoke that goes up
	for i = 1,5 do
		local EffectCode = Emitter:Add("particles/smokey",self.Pos)
		EffectCode:SetVelocity(Vector(math.random(-60,70),math.random(-60,70),math.random(70,100)))
		EffectCode:SetDieTime(math.Rand(3,4)) -- How much time until it dies
		EffectCode:SetStartAlpha(math.Rand(150,190)) -- Transparency
		EffectCode:SetStartSize(math.Rand(80,100)) -- Size of the effect
		EffectCode:SetEndSize(math.Rand(130,150)) -- Size of the effect at the end (The effect slowly trasnsforms to this size)
		EffectCode:SetRoll(math.Rand(480,540))
		EffectCode:SetRollDelta(math.Rand(-1,1)) -- How fast it rolls
		EffectCode:SetColor(50,50,50) -- The color of the effect
		EffectCode:SetGravity(Vector(0,0,math.random(-30,-10))) -- The Gravity
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
/*--------------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/