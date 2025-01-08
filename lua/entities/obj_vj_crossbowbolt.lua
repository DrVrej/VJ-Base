/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Crossbow Bolt"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Information		= "Projectile, usually used for NPCs & Weapons"
ENT.Category		= "VJ Base"

ENT.PhysicsSolidMask = MASK_SHOT
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	VJ.AddKillIcon("obj_vj_crossbowbolt", ENT.PrintName, VJ.KILLICON_PROJECTILE)
	// VJ.AddKillIcon("obj_vj_crossbowbolt", ENT.PrintName, VJ.KILLICON_TYPE_ALIAS, "crossbow_bolt")
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = "models/crossbow_bolt.mdl" -- Model(s) to spawn with | Picks a random one if it's a table
ENT.DoesDirectDamage = true -- Should it deal direct damage when it collides with something?
ENT.DirectDamage = 90
ENT.CollisionDecal = "Impact.Concrete"
ENT.SoundTbl_Idle = "weapons/fx/nearmiss/bulletltor03.wav"
ENT.SoundTbl_OnCollide = "weapons/crossbow/hit1.wav"

ENT.IdleSoundLevel = 60

local sdHitEnt = {"weapons/crossbow/hitbod1.wav", "weapons/crossbow/hitbod2.wav"} // weapons/crossbow/bolt_skewer1.wav
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:InitPhys()
	self:PhysicsInitSphere(1, "metal_bouncy")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCollision(data, phys)
	if IsValid(data.HitEntity) then
		self.SoundTbl_OnCollide = sdHitEnt
		-- Ignite small entities
		if data.HitEntity:IsNPC() && data.HitEntity:GetHullType() == HULL_TINY then
			data.HitEntity:Ignite(3)
		end
	else
		local bolt = ents.Create("prop_dynamic")
		bolt:SetModel("models/crossbow_bolt.mdl")
		bolt:SetPos(data.HitPos + data.HitNormal + self:GetForward()*-15)
		bolt:SetAngles(self:GetAngles())
		bolt:Activate()
		bolt:Spawn()
		timer.Simple(15, function() if IsValid(bolt) then bolt:Remove() end end)
	end
end