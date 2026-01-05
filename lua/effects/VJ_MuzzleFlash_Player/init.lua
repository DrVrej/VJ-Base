/*--------------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
function EFFECT:Init(data)
	local ent = data:GetEntity()
	if !IsValid(ent) then return end
	local owner = ent:GetOwner()
	if !IsValid(owner) then return end
	
	-- (if the owner is NOT the local player OR in third person, then use world model) OR (Use the owner's viewmodel)
	local muzEnt = ((owner != LocalPlayer()) or owner:ShouldDrawLocalPlayer()) && ent or owner:GetViewModel()
	ParticleEffectAttach(VJ.PICK(ent.PrimaryEffects_MuzzleParticles), PATTACH_POINT_FOLLOW, muzEnt, data:GetAttachment())
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Think()
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Render() end -- To avoid "ERROR" from appearing for single a tick