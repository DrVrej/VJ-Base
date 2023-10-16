/*--------------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Base 			= "base_gmodentity"
ENT.Type 			= "anim"
ENT.PrintName 		= "Admin Health Kit"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Gives a lot of health when taken."
ENT.Instructions 	= "Don't change anything."
ENT.Category		= "VJ Base"

ENT.Spawnable = true
ENT.AdminOnly = true
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	local textColor = Color(0, 255, 0, 255)
	local vec = Vector(90, 90, 90)
	
	function ENT:Draw()
		self:DrawModel()
		
		local angs = self:GetAngles()
		angs:RotateAroundAxis(angs:Right(), vec.x)
		angs:RotateAroundAxis(angs:Up(), vec.y)
		angs:RotateAroundAxis(angs:Forward(), vec.z)
		cam.Start3D2D(self:GetPos() + self:GetForward()*7 + self:GetUp()*6 + self:GetRight()*2, angs, 0.07)
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
	//self:SetCollisionGroup(COLLISION_GROUP_NONE)
	self:SetUseType(SIMPLE_USE)
	
	local phys = self:GetPhysicsObject()
	if phys and IsValid(phys) then
		phys:Wake()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PhysicsCollide(data, physobj)
	//self:EmitSound("physics/cardboard/cardboard_box_impact_soft"..math.random(1,5)..".wav")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Use(activator, caller)
	if activator:IsPlayer() then
		self:EmitSound("items/smallmedkit1.wav", 70, 100)
		activator:SetHealth(activator:Health() + 1000000)
		activator:PrintMessage(HUD_PRINTTALK, "#vjbase.print.adminhealth.pickup")
		self:Remove()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage(dmginfo)
	self:GetPhysicsObject():AddVelocity(dmginfo:GetDamageForce() * 0.1)
end