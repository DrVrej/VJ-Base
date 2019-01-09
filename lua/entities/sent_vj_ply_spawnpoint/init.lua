if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
AddCSLuaFile("shared.lua")
include("shared.lua")
/*--------------------------------------------------
	=============== Player Spawnpoint Kit ===============
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to set the spawnpoint for all players
--------------------------------------------------*/
ENT.Active = true -- Is this spawnpoint active?
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetModel("models/props_junk/sawblade001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	if phys and phys:IsValid() then
		phys:Wake()
	end

	self:SetColor(Color(0,255,0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Use(activator, caller)
	if activator:IsPlayer() && activator:IsAdmin() then
		if (self.Active == true) then
			self.Active = false
			self:EmitSound(Sound("hl1/fvox/deactivated.wav"),70,100)
			self:SetColor(Color(255,0,0))
			activator:PrintMessage(HUD_PRINTTALK, "Deactivated this spawnpoint!")
		else
			self.Active = true
			self:EmitSound(Sound("hl1/fvox/activated.wav"),70,100)
			self:SetColor(Color(0,255,0))
			activator:PrintMessage(HUD_PRINTTALK, "Activated this spawnpoint!")
		end
	end
end
/*--------------------------------------------------
	=============== Admin Health Kit ===============
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to quickly give admins a lot health
--------------------------------------------------*/
