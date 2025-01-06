/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Base 			= "prop_vj_animatable"
ENT.Type 			= "anim"
ENT.PrintName 		= "Flag"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Used for flags."
ENT.Instructions 	= "Don't change anything."
ENT.Category		= "VJ Base"

ENT.PhysicsSounds = true
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

function ENT:Initialize()
	self:SetModel("models/vj_base/flag_armenia.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:ResetSequence("Idle")
	
	self.WaveSound = VJ.CreateSound(self, "vj_base/ambience/flag_loop.wav", 60)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	VJ.STOPSOUND(self.WaveSound)
end
