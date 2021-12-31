if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
/*--------------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/

/*-- Information ---------------------
	-- Common Blood Types --
	Red 		= Color(130, 19, 10)
	Yellow 		= Color(255, 221, 35)

	-- Code Implementation --
	local blcolor = Color(130, 19, 10)
	effectBlood:SetColor(VJ_Color2Byte(Color(r, g, b)))
-------------------------------------- */
function EFFECT:Init(data)
	local origin = data:GetOrigin()
	local scale = data:GetScale()
	local color = VJ_Color8Bit2Color(data:GetColor())
	
	self.Emitter = ParticleEmitter(origin)
	for _ = 0,6 do
		local mist = self.Emitter:Add("particle/smokesprites_000"..math.random(1, 9), origin)
		if (mist) then
			mist:SetVelocity(Vector(math.random(-30, 30), math.random(-30, 30), math.random(-50, 50)))
			mist:SetDieTime(math.Rand(1.8, 2))
			mist:SetStartAlpha(150)
			mist:SetEndAlpha(0)
			mist:SetStartSize(scale / 2)
			mist:SetEndSize(scale)
			mist:SetRoll(1)
			mist:SetRollDelta(0)
			mist:SetAirResistance(1)
			mist:SetGravity(Vector(math.Rand(-10, 10), math.Rand(-10, 10), math.Rand(-100, -100)))
			mist:SetColor(color.r, color.g, color.b)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Think()
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Render()
end
