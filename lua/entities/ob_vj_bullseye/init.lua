AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')
/*--------------------------------------------------
	=============== Bullseye Entity ===============
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to place a target in certain situations for VJ Base SNPCs.
--------------------------------------------------*/
//ENT.VJBULLSEYE_TheAttacker = nil
//ENT.Alreadydoneit = false
ENT.SolidMovementType = "Dynamic"
ENT.Activated = true
ENT.UserStatusColors = true
ENT.EnemyToIndividual = false
ENT.EnemyToIndividualEnt = NULL
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
	self:SetHealth(999999) -- So SNPCs won't think it's dead
	//self:SetColor(Color(255,0,0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AcceptInput(key,activator,caller,data)
	if !activator:IsPlayer() then return end
	if self.Activated == false then
		self.Activated = true
		activator:PrintMessage(HUD_PRINTTALK, "Activated NPC Bullseye.")
		self:EmitSound(Sound("buttons/button6.wav"),70,100)
	elseif self.Activated == true then
		self.Activated = false
		activator:PrintMessage(HUD_PRINTTALK, "Deactivated NPC Bullseye.")
		self:EmitSound(Sound("buttons/button5.wav"),70,100)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	if self.EnemyToIndividual == true then
		self.VJ_NoTarget = true
		if IsValid(self.EnemyToIndividualEnt) && self.EnemyToIndividualEnt:IsNPC() then
			self.EnemyToIndividualEnt:AddEntityRelationship(self,D_HT,99)
			self:AddEntityRelationship(self.EnemyToIndividualEnt,D_HT,99)
			self.EnemyToIndividualEnt:VJ_DoSetEnemy(self,false,false)
			self.EnemyToIndividualEnt:SetEnemy(self)
		end
	else
		if self.Activated == false then
			self.VJ_NoTarget = true
			if self.UserStatusColors == true then self:SetColor(Color(255,0,0)) end
		elseif self.Activated == true then
			self.VJ_NoTarget = false
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
/*--------------------------------------------------
	=============== Bullseye Entity ===============
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to place a target in certain situations for VJ Base SNPCs.
--------------------------------------------------*/