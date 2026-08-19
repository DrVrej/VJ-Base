/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
AddCSLuaFile()

ENT.Base 			= "base_entity"
ENT.Type 			= "ai"
ENT.PrintName 		= "VJ Base Bullseye"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Information 	= "Target for VJ Base NPCs."
ENT.Category		= "VJ Base"

ENT.IsVJBaseBullseye = true
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.SolidMovementType = "Dynamic" -- Physics type to use | Applied on initialize
ENT.CanToggle = false -- Can it be activated/deactivated by players by interacting with it? | EX: Bullseye tool
ENT.ToggleColors = true -- Should it color the bullseye based on the toggle state?
ENT.ForceEntAsEnemy = false -- Set this to an NPC that should always override all other enemies and target this bullseye instead | EX: NPC Controller
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ ///// BASE IMPLEMENTATION BELOW — Override with caution and only when necessary! \\\\\ ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.Active = true

local sdActivated = "hl1/fvox/activated.wav"
local sdDeactivated = "hl1/fvox/deactivated.wav"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	//self:SetModel("models/hunter/plates/plate.mdl")
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
	self:SetHealth(999999) -- So NPCs won't think it's dead
	self:SetActive(self.Active) -- Make sure everything is applied
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetActive(active)
	if active != false && active != true then error("bad argument #1 to 'SetActive' (boolean expected, got " .. type(active).. ")") end
	self.Active = active
	if active then
		self:RemoveFlags(FL_NOTARGET)
		if self.ToggleColors then self:SetColor(VJ.COLOR_GREEN) end
	else
		self:AddFlags(FL_NOTARGET)
		if self.ToggleColors then self:SetColor(VJ.COLOR_RED) end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Use(activator)
	if !activator:IsPlayer() or self.ForceEntAsEnemy or !self.CanToggle then return end
	if !self.Active then
		self:SetActive(true)
		activator:PrintMessage(HUD_PRINTTALK, "#vjbase.bullseye.print.activated")
		self:EmitSound(sdActivated, 70)
	else
		self:SetActive(false)
		activator:PrintMessage(HUD_PRINTTALK, "#vjbase.bullseye.print.deactivated")
		self:EmitSound(sdDeactivated, 70)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage(dmginfo)
	return 0 -- Take no damage
end