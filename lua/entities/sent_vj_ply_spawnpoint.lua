/*--------------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Base 			= "base_gmodentity"
ENT.Type 			= "anim"
ENT.PrintName 		= "Player Spawnpoint"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Sets the spawnpoint for all the players in the map!"
ENT.Instructions 	= "Don't change anything."
ENT.Category		= "VJ Base"

ENT.Spawnable = true
ENT.AdminOnly = true
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Active = true -- Is this spawnpoint active?

local colorGreen = Color(0, 255, 0)
local colorRed = Color(255, 0, 0)

local sdActivated = Sound("hl1/fvox/activated.wav")
local sdDeactivated = Sound("hl1/fvox/deactivated.wav")
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetModel("models/props_junk/sawblade001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	if phys and IsValid(phys) then
		phys:Wake()
	end

	self:SetColor(colorGreen)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Use(activator, caller)
	if activator:IsPlayer() && activator:IsAdmin() then
		if (self.Active == true) then
			self.Active = false
			self:EmitSound(sdDeactivated, 70, 100)
			self:SetColor(colorRed)
			activator:PrintMessage(HUD_PRINTTALK, "#vjbase.print.plyspawnpoint.deactivated")
		else
			self.Active = true
			self:EmitSound(sdActivated, 70, 100)
			self:SetColor(colorGreen)
			activator:PrintMessage(HUD_PRINTTALK, "#vjbase.print.plyspawnpoint.activated")
		end
	end
end