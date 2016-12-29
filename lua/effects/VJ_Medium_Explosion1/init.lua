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
	
	/*local effectdata = EffectData()
	effectdata:SetOrigin( self.Pos )
	effectdata:SetNormal( Vector(0,0,0) )
	effectdata:SetMagnitude( 2.6 )
	effectdata:SetScale( 2.6 )
	effectdata:SetRadius( 93 )
	util.Effect( "Sparks", effectdata, true, true )*/
	
	-- Fire
	for i=1,8 do
		local EffectCode = Emitter:Add("particles/flamelet1",self.Pos)
		EffectCode:SetVelocity(Vector(math.random(-30,30),math.random(-30,30),math.random(30,40)))
		EffectCode:SetDieTime(math.Rand(1,2)) -- How much time until it dies
		EffectCode:SetStartAlpha(math.Rand(90,100)) -- Transparency
		EffectCode:SetStartSize(math.Rand(300,300)) -- Size of the effect
		EffectCode:SetEndSize(math.Rand(300,300)) -- Size of the effect at the end (The effect slowly trasnsforms to this size)
		EffectCode:SetRoll(math.Rand(480,540))
		EffectCode:SetRollDelta(0) -- How fast it rolls
		EffectCode:SetColor(170,170,170) -- The color of the effect
		EffectCode:SetGravity(Vector(0,0,math.random(-30,-10))) -- The Gravity
	end

	-- Smoke screen
	for i = 1,12 do
		local EffectCode = Emitter:Add("particles/smokey",self.Pos)
		EffectCode:SetVelocity(Vector(math.random(-40,40),math.random(-40,40),math.random(5,15)))
		EffectCode:SetDieTime(math.Rand(15,17)) -- How much time until it dies
		EffectCode:SetStartAlpha(math.Rand(220,230)) -- Transparency
		EffectCode:SetStartSize(math.Rand(130,170)) -- Size of the effect
		EffectCode:SetEndSize(math.Rand(300,350)) -- Size of the effect at the end (The effect slowly trasnsforms to this size)
		EffectCode:SetRoll(math.Rand(480,540))
		EffectCode:SetRollDelta(0) -- How fast it rolls
		EffectCode:SetColor(100,100,100) -- The color of the effect
		EffectCode:SetGravity(Vector(0,0,0)) -- The Gravity
		EffectCode:SetAirResistance(15)
	end

	-- Cloud of smoke that goes up
	for i = 1,8 do
		local EffectCode = Emitter:Add("particles/smokey",self.Pos)
		EffectCode:SetVelocity(Vector(math.random(-60,70),math.random(-100,70),math.random(70,180)))
		EffectCode:SetDieTime(math.Rand(4,5)) -- How much time until it dies
		EffectCode:SetStartAlpha(math.Rand(220,230)) -- Transparency
		EffectCode:SetStartSize(math.Rand(55,66)) -- Size of the effect
		EffectCode:SetEndSize(math.Rand(192,256)) -- Size of the effect at the end (The effect slowly trasnsforms to this size)
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