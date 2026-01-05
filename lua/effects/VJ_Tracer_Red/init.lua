/*--------------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
-- Based off of the GMod lasertracer
local beamMat = Material("effects/spark")
local beamLength = 0.1
local beamColor = Color(255, 0, 0, 255)
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Init(data)
	self.StartPos = data:GetStart()
	self.EndPos = data:GetOrigin()
	local ent = data:GetEntity()
	local att = data:GetAttachment()

	if IsValid(ent) && att > 0 then
		if ent:GetOwner() == LocalPlayer() && LocalPlayer():GetViewModel() != LocalPlayer() then ent = ent:GetOwner():GetViewModel() end
		att = ent:GetAttachment(att)
		if att then
			self.StartPos = att.Pos
		end
	end

	self:SetRenderBoundsWS(self.StartPos, self.EndPos)
	self.Dir = self.EndPos - self.StartPos
	self.TracerTime = math.min(1, self.StartPos:Distance(self.EndPos) / 10000) -- Calculate death time
	self.DieTime = CurTime() + self.TracerTime -- Time until it dies (when it reaches its target)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Think()
	if CurTime() > self.DieTime then -- If it's dead then...
		local dirNormalized = self.Dir:GetNormalized()
		util.Decal("fadingscorch", self.EndPos + dirNormalized, self.EndPos - dirNormalized)

		local effectData = EffectData()
		effectData:SetOrigin(self.EndPos + dirNormalized * -2)
		effectData:SetNormal(dirNormalized * -3)
		effectData:SetMagnitude(0.1)
		effectData:SetScale(0.8)
		effectData:SetRadius(5)
		util.Effect("Sparks", effectData)
		return false
	end
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Render()
	local fDelta = math.sqrt(math.Clamp((self.DieTime - CurTime()) / self.TracerTime, 0, 1))
	local sinWave = math.sin(fDelta * math.pi)
	local offset = sinWave * beamLength
	render.SetMaterial(beamMat)
	render.DrawBeam(
		self.EndPos - self.Dir * (fDelta - offset), -- Start
		self.EndPos - self.Dir * (fDelta + offset), -- End
		5 + sinWave * 35, 1, 0, beamColor
	)
end
