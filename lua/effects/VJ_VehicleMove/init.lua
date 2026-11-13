/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
function EFFECT:Init(data)
	local ent = data:GetEntity()
	if !IsValid(ent) then return end
	local origin = data:GetOrigin()
	local scale = data:GetScale()
	local emitter = ParticleEmitter(origin)
	
	-- Dust
	local dust = emitter:Add("particles/smokey", origin)
	if dust then
		local tempVec = ent:GetForward()
		tempVec:Mul(math.Rand(100, 200))
		tempVec:Add(ent:GetVelocity())
		tempVec:SetUnpacked(tempVec.x + math.Rand(5, -5), tempVec.y + math.Rand(5, -5), tempVec.z + math.Rand(5, -5))
		dust:SetVelocity(tempVec)
		dust:SetDieTime(4)
		dust:SetStartAlpha(50)
		dust:SetEndAlpha(0)
		dust:SetStartSize(math.Rand(12, 20))
		dust:SetEndSize(math.Rand(80, 100) * scale)
		dust:SetRoll(math.Rand(-0.2, 0.2))
		dust:SetColor(80, 60, 20)
		dust:SetAirResistance(300)
		tempVec:SetUnpacked(0, 0, 50)
		dust:SetGravity(tempVec)
	end
	emitter:Finish()
end

function EFFECT:Think() return false end

function EFFECT:Render() end -- Avoid "ERROR" from appearing for single a tick