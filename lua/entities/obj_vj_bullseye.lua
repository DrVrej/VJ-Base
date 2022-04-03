/*--------------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end

ENT.Base 			= "base_entity"
ENT.Type 			= "ai"
ENT.PrintName 		= "Bullseye"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "To make my a target for NPCs"
ENT.Instructions 	= "Don't change anything."
ENT.Category		= "VJ Base"

ENT.Spawnable 		= false
ENT.AdminSpawnable 	= false
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

//ENT.VJBULLSEYE_TheAttacker = nil
//ENT.Alreadydoneit = false
ENT.SolidMovementType = "Dynamic"
ENT.UseActivationSystem = false -- Mostly used for the Bullseye tool, allows you to activate/deactivate the bullseye
ENT.Activated = true
ENT.UserStatusColors = true
ENT.EnemyToIndividual = false
ENT.EnemyToIndividualEnt = NULL

local sdActivated = Sound("hl1/fvox/activated.wav")
local sdDeactivated = Sound("hl1/fvox/deactivated.wav")
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
	//self:SetColor(Color(255,0,0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AcceptInput(key, activator, caller, data)
	if !activator:IsPlayer() then return end
	if self.Activated == false then
		self.Activated = true
		activator:PrintMessage(HUD_PRINTTALK, "#vjbase.print.bullseye.activated")
		self:EmitSound(sdActivated, 70, 100)
	elseif self.Activated == true then
		self.Activated = false
		activator:PrintMessage(HUD_PRINTTALK, "#vjbase.print.bullseye.deactivated")
		self:EmitSound(sdDeactivated, 70, 100)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	if self.EnemyToIndividual == true then
		self:AddFlags(FL_NOTARGET)
		if IsValid(self.EnemyToIndividualEnt) && (self.EnemyToIndividualEnt:IsNPC() or self.EnemyToIndividualEnt:IsNextBot()) then
			self.EnemyToIndividualEnt:AddEntityRelationship(self,D_HT,99)
			self:AddEntityRelationship(self.EnemyToIndividualEnt,D_HT,99)
			if self.EnemyToIndividualEnt.IsVJBaseSNPC then
				self.EnemyToIndividualEnt:VJ_DoSetEnemy(self,false,false)
			end
			self.EnemyToIndividualEnt:SetEnemy(self)
		end
	elseif self.UseActivationSystem == true then
		if self.Activated == false then
			self:AddFlags(FL_NOTARGET)
			if self.UserStatusColors == true then self:SetColor(Color(255,0,0)) end
		elseif self.Activated == true then
			self:RemoveFlags(FL_NOTARGET)
			if self.UserStatusColors == true then self:SetColor(Color(0,255,0)) end
		end
	end
	/*if IsValid(self.VJBULLSEYE_TheAttacker) && self.Alreadydoneit == false then
		table.insert(self.VJBULLSEYE_TheAttacker.CurrentPossibleEnemies,self)
		//print(self.VJBULLSEYE_TheAttacker)
		//self.Alreadydoneit = true
		self:AddEntityRelationship(self.VJBULLSEYE_TheAttacker,D_HT,99)
		self.VJBULLSEYE_TheAttacker:VJ_DoSetEnemy(self)
	end*/
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage(dmginfo)
	return 0 -- Take no damage
end