if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
/*--------------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
function EFFECT:Init(data)
	if !IsValid(data:GetEntity()) then return end
	self.Pos = self:GetTracerShootPos(data:GetOrigin(),data:GetEntity(),data:GetAttachment())
	local Emitter = ParticleEmitter(self.Pos)
	if Emitter == nil then return end
	
	LocalPlayerMagnitude = 0
	if IsValid(data:GetEntity()) && IsValid(data:GetEntity():GetOwner()) && data:GetEntity():GetOwner():IsPlayer() && data:GetEntity().Owner == LocalPlayer() then
		LocalPlayerMagnitude = data:GetMagnitude() else
		LocalPlayerMagnitude = 0
	end

	//local effectdata = EffectData()
	//effectdata:SetEntity(self.Weapon)
	//effectdata:SetOrigin(self.Pos)
	//effectdata:SetNormal( Vector(0,0,0) )
	//util.Effect("RifleShellEject",effectdata,true,true)

	-- Muzzle Flash
	if GetConVarNumber("vj_wep_nomuszzleflash") == 0 && IsValid(data:GetEntity()) then
	for i = 1,3 do //4
		local EffectCode = Emitter:Add("effects/muzzleflash"..math.random(1,4),self.Pos + LocalPlayerMagnitude * data:GetNormal())
		EffectCode:SetVelocity(data:GetNormal() + 1.1 * data:GetEntity():GetOwner():GetVelocity())
		//EffectCode:SetAirResistance(200)
		EffectCode:SetDieTime(math.Rand(0.05,0.05)) -- How much time until it dies
		EffectCode:SetStartAlpha(math.Rand(200,255)) -- Transparency
		EffectCode:SetStartSize(math.Rand(5,6)) -- Size of the effect
		EffectCode:SetEndSize(math.Rand(16,20)) -- Size of the effect at the end (The effect slowly trasnsforms to this size)
		EffectCode:SetRoll(math.Rand(480,540))
		EffectCode:SetRollDelta(math.Rand(-1,1)) -- How fast it rolls
		EffectCode:SetColor(255,255,255) -- The color of the effect
		//EffectCode:SetGravity(Vector(0,0,100)) -- The Gravity
		end
		local EffectCode = Emitter:Add("effects/yellowflare", self.Pos)
		EffectCode:SetVelocity(data:GetNormal() + 1.1 * data:GetEntity():GetOwner():GetVelocity())
		EffectCode:SetAirResistance(160)
		EffectCode:SetDieTime(0.05)
		EffectCode:SetStartAlpha(255)
		EffectCode:SetEndAlpha(0)
		EffectCode:SetStartSize(.5)
		EffectCode:SetEndSize(15)
		EffectCode:SetRoll(math.Rand(180, 480))
		EffectCode:SetRollDelta(math.Rand(-1, 1))
		EffectCode:SetColor(255, 255, 255)
	end

	-- Heat wave
	if GetConVarNumber("vj_wep_nomuzzleheatwave") == 0 && IsValid(data:GetEntity()) then
		local EffectCode = Emitter:Add("sprites/heatwave",self.Pos + LocalPlayerMagnitude * data:GetNormal())
		EffectCode:SetVelocity(data:GetNormal() + 1.1 * data:GetEntity():GetOwner():GetVelocity())
		EffectCode:SetDieTime(math.Rand(0.15,0.2)) -- How much time until it dies
		//EffectCode:SetStartAlpha(math.Rand(90,100)) -- Transparency
		EffectCode:SetStartSize(math.Rand(7,9)) -- Size of the effect
		EffectCode:SetEndSize(math.Rand(4,6)) -- Size of the effect at the end (The effect slowly trasnsforms to this size)
		EffectCode:SetRoll(math.Rand(480,540))
		EffectCode:SetRollDelta(math.Rand(-1,1)) -- How fast it rolls
		//EffectCode:SetColor(255,255,255) -- The color of the effect
		//EffectCode:SetGravity(Vector(0,0,100)) -- The Gravity
	end

	-- Smoke
	if GetConVarNumber("vj_wep_nomuszzlesmoke") == 0 && IsValid(data:GetEntity()) then
	local smokeinum = 2
	if IsValid(data:GetEntity():GetOwner()) then
		if data:GetEntity():GetOwner():IsNPC() then smokeinum = 1 else smokeinum = 2 end
	end
	local smokediet = 0.5,0.5
	if IsValid(data:GetEntity():GetOwner()) then
		if data:GetEntity():GetOwner():IsNPC() then smokediet = 0.2,0.2 else smokediet = 0.4,0.4 end
	end
	for i = 1,smokeinum do //4
		local EffectCode = Emitter:Add("particles/smokey",self.Pos + LocalPlayerMagnitude * data:GetNormal())
		EffectCode:SetVelocity(data:GetNormal() + Vector(math.random(-30,30),math.random(-30,30),math.random(-30,30)))
		EffectCode:SetDieTime(math.Rand(smokediet,smokediet)) -- How much time until it dies
		EffectCode:SetStartAlpha(math.Rand(40,60)) -- Transparency
		EffectCode:SetEndAlpha(0) -- Transparency
		EffectCode:SetStartSize(math.Rand(2,3)) -- Size of the effect
		EffectCode:SetEndSize(math.Rand(13,15)) -- Size of the effect at the end (The effect slowly trasnsforms to this size)
		EffectCode:SetRoll(math.Rand(480,540))
		EffectCode:SetRollDelta(math.Rand(-1,1)) -- How fast it rolls
		EffectCode:SetColor(150,150,150) -- The color of the effect
		//EffectCode:SetGravity(Vector(0,0,math.random(-30,-10))) -- The Gravity
		EffectCode:SetAirResistance(300)
		end
	end

	-- Small Smoke
	/*for i = 1,4 do
		local EffectCode = Emitter:Add("particle/particle_smokegrenade",self.Pos)
		EffectCode:SetVelocity(Vector(math.random(-30,30),math.random(-30,30),math.random(20,30)))
		EffectCode:SetAirResistance(200)
		EffectCode:SetDieTime(math.Rand(0.5,1)) -- How much time until it dies
		EffectCode:SetStartAlpha(math.Rand(100,150)) -- Transparency
		EffectCode:SetStartSize(math.Rand(3,4)) -- Size of the effect
		EffectCode:SetEndSize(math.Rand(6,8)) -- Size of the effect at the end (The effect slowly trasnsforms to this size)
		EffectCode:SetRoll(math.Rand(480,540))
		EffectCode:SetRollDelta(math.Rand(-1,1)) -- How fast it rolls
		EffectCode:SetColor(255,255,255) -- The color of the effect
		//EffectCode:SetGravity(Vector(0,0,100)) -- The Gravity
	end*/
		//local EffectCode = Emitter:Add("effects/muzzleflash"..math.random(1,4),self.Pos + LocalPlayerMagnitude * data:GetNormal())
		//EffectCode:SetVelocity(data:GetNormal() + 1.1 * data:GetEntity():GetOwner():GetVelocity())

	if GetConVarNumber("vj_wep_nomuszzleflash") == 0 && IsValid(data:GetEntity()) then
  	if IsValid(data:GetEntity():GetOwner()) then
	 if data:GetEntity():GetOwner():IsPlayer() then
	  for i = 1,4 do
		local EffectCode = Emitter:Add("effects/yellowflare",self.Pos)
		EffectCode:SetVelocity(((data:GetNormal() + VectorRand() * 0.5) * math.Rand(150, 200)))
		EffectCode:SetDieTime(math.Rand(0.5, 0.8))
		EffectCode:SetStartAlpha(255)
		EffectCode:SetStartSize(.5)
		EffectCode:SetEndSize(2)
		EffectCode:SetRoll(0)
		EffectCode:SetGravity(Vector(0, 0, -1))
		EffectCode:SetBounce(.8)
		EffectCode:SetAirResistance(400)
		EffectCode:SetStartLength(0.01)
		EffectCode:SetEndLength(0)
		EffectCode:SetVelocityScale(true)
		EffectCode:SetCollide(false)
		end
	 end
	end
  end
  
  /*
    		local EffectCode = Emitter:Add("effects/muzzleflare_01",self.Pos + LocalPlayerMagnitude * data:GetNormal())
		EffectCode:SetVelocity(data:GetNormal() + 1.1 * data:GetEntity():GetOwner():GetVelocity())
		//EffectCode:SetAirResistance(200)
		EffectCode:SetDieTime(math.Rand(0.05,0.05)) -- How much time until it dies
		EffectCode:SetStartAlpha(math.Rand(200,255)) -- Transparency
		EffectCode:SetStartSize(math.Rand(5,6)) -- Size of the effect
		EffectCode:SetEndSize(math.Rand(16,20)) -- Size of the effect at the end (The effect slowly trasnsforms to this size)
		EffectCode:SetRoll(math.Rand(480,540))
		EffectCode:SetRollDelta(math.Rand(-1,1)) -- How fast it rolls
		EffectCode:SetColor(245,164,53) -- The color of the effect
		//EffectCode:SetGravity(Vector(0,0,100)) -- The Gravity
		
 		local EffectCode = Emitter:Add("effects/muzzlestarlarge_01",self.Pos + LocalPlayerMagnitude * data:GetNormal())
		EffectCode:SetVelocity(data:GetNormal() + 1.1 * data:GetEntity():GetOwner():GetVelocity())
		//EffectCode:SetAirResistance(200)
		EffectCode:SetDieTime(math.Rand(0.05,0.05)) -- How much time until it dies
		EffectCode:SetStartAlpha(math.Rand(200,255)) -- Transparency
		EffectCode:SetStartSize(math.Rand(5,6)) -- Size of the effect
		EffectCode:SetEndSize(math.Rand(16,20)) -- Size of the effect at the end (The effect slowly trasnsforms to this size)
		EffectCode:SetRoll(math.Rand(480,540))
		EffectCode:SetRollDelta(math.Rand(-1,1)) -- How fast it rolls
		EffectCode:SetColor(248,241,200) -- The color of the effect
		//EffectCode:SetGravity(Vector(0,0,100)) -- The Gravity
		
		local EffectCode = Emitter:Add("particle/bm_whispysmoke_001",self.Pos + LocalPlayerMagnitude * data:GetNormal())
		EffectCode:SetVelocity(data:GetNormal() + Vector(math.random(-30,30),math.random(-30,30),math.random(-30,30)))
		EffectCode:SetDieTime(math.Rand(0.5,0.5)) -- How much time until it dies
		EffectCode:SetStartAlpha(math.Rand(40,60)) -- Transparency
		EffectCode:SetEndAlpha(0) -- Transparency
		EffectCode:SetStartSize(math.Rand(2,3)) -- Size of the effect
		EffectCode:SetEndSize(math.Rand(13,15)) -- Size of the effect at the end (The effect slowly trasnsforms to this size)
		EffectCode:SetRoll(math.Rand(480,540))
		EffectCode:SetRollDelta(math.Rand(-1,1)) -- How fast it rolls
		EffectCode:SetColor(255,255,255) -- The color of the effect
		//EffectCode:SetGravity(Vector(0,0,math.random(-30,-10))) -- The Gravity
		EffectCode:SetAirResistance(300)
  */
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