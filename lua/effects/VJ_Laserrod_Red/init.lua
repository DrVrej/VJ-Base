if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
/*--------------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
-- Based off of the GMod lasertracer
EFFECT.MainMat = Material("effects/spark")

function EFFECT:Init( data )
	self.StartPos = data:GetStart()
	self.EndPos = data:GetOrigin()
	local ent = data:GetEntity()
	local att = data:GetAttachment()

	if ( IsValid( ent ) && att > 0 ) then
		if (ent.Owner == LocalPlayer() && !LocalPlayer():GetViewModel() != LocalPlayer()) then ent = ent.Owner:GetViewModel() end
		local att = ent:GetAttachment(att)
		if (att) then
			self.StartPos = att.Pos
		end
	end

	self.Dir = self.EndPos - self.StartPos
	self:SetRenderBoundsWS(self.StartPos, self.EndPos)
	self.TracerTime = math.min(1, self.StartPos:Distance(self.EndPos) / 10000) -- Calculate death time
	self.Length = 0.1

	-- Die when it reaches its target
	self.DieTime = CurTime() + self.TracerTime
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Think()
	if (CurTime() > self.DieTime) then -- If it's dead then...
		util.Decal("fadingscorch", self.EndPos +self.Dir:GetNormalized(), self.EndPos -self.Dir:GetNormalized())
		
		local effectdata = EffectData()
		effectdata:SetOrigin(self.EndPos + self.Dir:GetNormalized() * -2)
		effectdata:SetNormal(self.Dir:GetNormalized() * -3)
		effectdata:SetMagnitude(0.1)
		effectdata:SetScale(0.8)
		effectdata:SetRadius(5)
		util.Effect("Sparks", effectdata)
		return false
	end
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Render()
	local fDelta = (self.DieTime - CurTime()) / self.TracerTime
	fDelta = math.Clamp(fDelta, 0, 1) ^ 0.5
	render.SetMaterial(self.MainMat)
	local sinWave = math.sin(fDelta * math.pi)
	render.DrawBeam(
		self.EndPos - self.Dir * (fDelta - sinWave * self.Length),
		self.EndPos - self.Dir * (fDelta + sinWave * self.Length),
		5 + sinWave * 35, 1, 0, Color(255, 0, 0, 255)
	)
end
/*--------------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/