/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Player Spawn Point"
ENT.Author = "DrVrej"
ENT.Contact = "http://steamcommunity.com/groups/vrejgaming"
ENT.Information = "Sets an spawn point for all the players.\nPress USE to toggle it."
ENT.Category = "VJ Base"
ENT.Spawnable = true
ENT.AdminOnly = true

scripted_ents.Alias("sent_vj_ply_spawnpoint", "sent_vj_ply_spawn") -- !! Backwards Compatibility !!
--------------------------------------------------------------------------------
if !SERVER then return end

ENT.Active = true

function ENT:Initialize()
	self:SetModel("models/props_junk/sawblade001a.mdl")
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_BBOX)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:SetUseType(SIMPLE_USE)
	self:SetColor(VJ.COLOR_GREEN)
end

function ENT:Use(activator)
	if !activator:IsPlayer() or !activator:IsAdmin() then return end
	self.Active = !self.Active
	self:EmitSound(self.Active and "hl1/fvox/activated.wav" or "hl1/fvox/deactivated.wav")
	self:SetColor(self.Active and VJ.COLOR_GREEN or VJ.COLOR_RED)
	activator:PrintMessage(HUD_PRINTTALK, self.Active and "#vjbase.spawnpoint.print.activated" or "#vjbase.spawnpoint.print.deactivated")
end

function ENT:PhysgunPickup(ply)
	return ply:IsAdmin()
end