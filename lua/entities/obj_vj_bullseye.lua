/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Base 			= "base_entity"
ENT.Type 			= "ai"
ENT.PrintName 		= "Bullseye"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Information 	= "Target for VJ NPCs."
ENT.Category		= "VJ Base"

ENT.Spawnable 		= false
ENT.AdminSpawnable 	= false

ENT.IsVJBaseBullseye = true
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.SolidMovementType = "Dynamic" -- Physics type to use (Set in initialize)
ENT.UseActivationSystem = false -- Mostly used for the Bullseye tool, allows you to activate/deactivate the bullseye
ENT.ActivationSystemStatusColors = true -- Should it draw the status colors?
ENT.ForceEntAsEnemy = false -- Set this to an NPC that should always override all other enemies and target this bullseye instead
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ ///// WARNING: Don't touch anything below this line! \\\\\ ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.Activated = true

local sdActivated = "hl1/fvox/activated.wav"
local sdDeactivated = "hl1/fvox/deactivated.wav"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	//self:SetModel("models/hunter/plates/plate.mdl")
	//self:SetMoveType(MOVETYPE_NONE)
	//self:SetSolid(SOLID_NONE)
	if self.SolidMovementType == "Dynamic" then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_NONE)
		self:SetSolid(SOLID_VPHYSICS)
	elseif self.SolidMovementType == "Static" then
		self:PhysicsInit(SOLID_NONE)
		self:SetMoveType(MOVETYPE_NONE)
		self:SetSolid(SOLID_NONE)
	elseif self.SolidMovementType == "Physics" then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
	end
	self:SetUseType(SIMPLE_USE)
	self:SetMaxHealth(999999)
	self:SetHealth(999999) -- So SNPCs won't think it's dead
	//self:SetColor(Color(255, 0, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AcceptInput(key, activator, caller, data)
	if !activator:IsPlayer() then return end
	if !self.Activated then
		self.Activated = true
		activator:PrintMessage(HUD_PRINTTALK, "#vjbase.bullseye.print.activated")
		self:EmitSound(sdActivated, 70, 100)
	elseif self.Activated then
		self.Activated = false
		activator:PrintMessage(HUD_PRINTTALK, "#vjbase.bullseye.print.deactivated")
		self:EmitSound(sdDeactivated, 70, 100)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	local selfData = self:GetTable()
	if selfData.ForceEntAsEnemy then return end
	if selfData.UseActivationSystem then
		if !selfData.Activated then
			self:AddFlags(FL_NOTARGET)
			if selfData.ActivationSystemStatusColors then self:SetColor(Color(255, 0, 0)) end
		elseif selfData.Activated then
			self:RemoveFlags(FL_NOTARGET)
			if selfData.ActivationSystemStatusColors then self:SetColor(Color(0, 255, 0)) end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage(dmginfo)
	return 0 -- Take no damage
end