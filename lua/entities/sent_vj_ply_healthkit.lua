/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
AddCSLuaFile()

ENT.Base 			= "base_anim"
ENT.Type 			= "anim"
ENT.PrintName 		= "Admin Health Kit"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Information 	= "Gives players 1000000 health when picked up."
ENT.Category		= "VJ Base"
ENT.Spawnable		= true
ENT.AdminOnly		= true

ENT.PhysicsSounds = true
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	local textColor = Color(0, 255, 0, 255)
	local vecOffset = Vector(7, -2, 6)
	local angOffset = Angle(0, 90, 0)
	
	function ENT:Draw()
		self:DrawModel()
		cam.Start3D2D(self:LocalToWorld(vecOffset), self:LocalToWorldAngles(angOffset), 0.07)
			draw.SimpleText("Admin Health Kit", "DermaLarge", 31, -22, textColor, 1, 1)
		cam.End3D2D()
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

function ENT:Initialize()
	self:SetModel("models/items/healthkit.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Use(activator, caller)
	if activator:IsPlayer() then
		self:EmitSound("HealthKit.Touch")
		activator:SetHealth(activator:Health() + 1000000)
		activator:PrintMessage(HUD_PRINTTALK, "#vjbase.adminhealth.print.pickup")
		self:Remove()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage(dmginfo)
	self:GetPhysicsObject():AddVelocity(dmginfo:GetDamageForce() * 0.1)
end