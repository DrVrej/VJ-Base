/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
/*-- Information ---------------------
	-- Common Blood Types --
	Red 		= Color(130, 19, 10)
	Yellow 		= Color(255, 221, 35)

	-- Code Implementation --
	local blcolor = Color(130, 19, 10)
	effectBlood:SetColor(VJ.Color2Byte(blcolor))
-------------------------------------- */
local bAND = bit.band
local bShiftR = bit.rshift
--
local function Color8Bit2Color(bits)
	return Color(bShiftR(bits, 5) * 255 / 7, bAND(bShiftR(bits, 2), 0x07) * 255 / 7, bAND(bits, 0x03) * 255 / 3)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Init(data)
	local origin = data:GetOrigin()
	local scale = data:GetScale()
	local color = Color8Bit2Color(data:GetColor())
	local emitter = ParticleEmitter(origin)
	
	-- Blood mist
	for _ = 0, 6 do
		local mist = emitter:Add("particle/smokesprites_000" .. math.random(1, 9), origin)
		if mist then
			mist:SetVelocity(Vector(math.random(-20, 20), math.random(-20, 20), math.random(-30, 30)))
			mist:SetDieTime(math.Rand(2.2, 2.4))
			mist:SetStartAlpha(150)
			mist:SetEndAlpha(0)
			mist:SetStartSize(scale / 2)
			mist:SetEndSize(scale)
			mist:SetRoll(1)
			mist:SetRollDelta(0)
			mist:SetAirResistance(1)
			mist:SetGravity(Vector(math.Rand(-20, 20), math.Rand(-20, 20), math.Rand(10, -10)))
			mist:SetColor(color.r, color.g, color.b)
			mist:SetCollide(true)
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