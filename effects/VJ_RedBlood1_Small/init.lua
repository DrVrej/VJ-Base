if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
/*--------------------------------------------------
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
function EFFECT:Init(data)
	
	self.Origin = data:GetOrigin()
	self.DirVec = data:GetNormal()
	self.Scale = 1
	self.Emitter = ParticleEmitter( self.Origin )

	for buzz = 0, 10 * self.Scale do
	local Mist = self.Emitter:Add( "particle/smokesprites_000"..math.random(1,9), self.Origin )
	if (Mist) then
		Mist:SetVelocity(Vector(math.random(-50,60),math.random(-50,60),math.random(-50,60)))
		Mist:SetDieTime( math.Rand( 1.8 , 2 ) )
		Mist:SetStartAlpha( 255 )
		Mist:SetEndAlpha( 0 )
		Mist:SetStartSize( 10*self.Scale )
		Mist:SetEndSize( 40*self.Scale )
		Mist:SetRoll( math.Rand(150, 360) )
		Mist:SetRollDelta( math.Rand(-2, 2) )			
		Mist:SetAirResistance( 300 ) 			 
		Mist:SetGravity( Vector( math.Rand(-50, 50) * self.Scale, math.Rand(-50, 50) * self.Scale, math.Rand(-100, -100) ) ) 			
		Mist:SetColor( 70,7,0 )
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
/*--------------------------------------------------
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
