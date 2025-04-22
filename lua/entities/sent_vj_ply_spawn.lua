/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Base 			= "base_anim"
ENT.Type 			= "anim"
ENT.PrintName 		= "Player Spawnpoint"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Information 	= "Sets an spawn point for all the players.\nPress USE to toggle it."
ENT.Category		= "VJ Base"
ENT.Spawnable		= true
ENT.AdminOnly		= true

scripted_ents.Alias("sent_vj_ply_spawnpoint", "sent_vj_ply_spawn") -- !! Backwards Compatibility !!
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Active = true -- Is this spawn point active?

local colorGreen = Color(0, 255, 0)
local colorRed = Color(255, 0, 0)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetModel("models/props_junk/sawblade001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	if phys && IsValid(phys) then
		phys:Wake()
	end

	self:SetColor(colorGreen)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Use(activator, caller)
	if activator:IsPlayer() && activator:IsAdmin() then
		if self.Active then
			self.Active = false
			self:EmitSound("hl1/fvox/deactivated.wav", 70, 100)
			self:SetColor(colorRed)
			activator:PrintMessage(HUD_PRINTTALK, "#vjbase.spawnpoint.print.deactivated")
		else
			self.Active = true
			self:EmitSound("hl1/fvox/activated.wav", 70, 100)
			self:SetColor(colorGreen)
			activator:PrintMessage(HUD_PRINTTALK, "#vjbase.spawnpoint.print.activated")
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PhysgunPickup(ply)
    return ply:IsAdmin()
end