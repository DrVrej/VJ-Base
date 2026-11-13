/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
--[[---------------------------------------------------------
	-- Common Blood Types --
	Red 		= Color(130, 19, 10)
	Yellow 		= Color(255, 221, 35)

	-- Example --
	effectBlood:SetColor(VJ.Color2Byte(Color(130, 19, 10)))
-----------------------------------------------------------]]

local bAND = bit.band
local bShiftR = bit.rshift
--
function EFFECT:Init(data)
	local origin = data:GetOrigin()
	local scale = data:GetScale()
	local cBits = data:GetColor()
	local cR, cG, cB = bShiftR(cBits, 5) * 255 / 7, bAND(bShiftR(cBits, 2), 0x07) * 255 / 7, bAND(cBits, 0x03) * 85
	local emitter = ParticleEmitter(origin)
	local tempVec = Vector()
	
	-- Blood mist
	for _ = 0, 6 do
		local mist = emitter:Add("particle/smokesprites_000" .. math.random(1, 9), origin)
		if mist then
			tempVec:SetUnpacked(math.random(-20, 20), math.random(-20, 20), math.random(-30, 30))
			mist:SetVelocity(tempVec)
			mist:SetDieTime(math.Rand(2.2, 2.4))
			mist:SetStartAlpha(150)
			mist:SetEndAlpha(0)
			mist:SetStartSize(scale / 2)
			mist:SetEndSize(scale)
			mist:SetRoll(1)
			mist:SetRollDelta(0)
			mist:SetAirResistance(1)
			tempVec:SetUnpacked(math.Rand(-20, 20), math.Rand(-20, 20), math.Rand(10, -10))
			mist:SetGravity(tempVec)
			mist:SetColor(cR, cG, cB)
			mist:SetCollide(true)
		end
	end
	emitter:Finish()
end

function EFFECT:Think() return false end

function EFFECT:Render() end -- Avoid "ERROR" from appearing for single a tick