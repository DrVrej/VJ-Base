/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Grenade"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Information		= "Projectile, usually used for NPCs & Weapons"
ENT.Category		= "VJ Base"

ENT.Spawnable = true
ENT.AdminOnly = false

ENT.VJ_ID_Grenade = true
ENT.VJ_ID_Grabbable = true
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	local Name = "Grenade"
	local LangName = "obj_vj_grenade"
	language.Add(LangName, Name)
	killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
	language.Add("#"..LangName, Name)
	killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = "models/vj_base/weapons/w_grenade.mdl" -- Model(s) to spawn with | Picks a random one if it's a table
ENT.ProjectileType = VJ.PROJ_TYPE_PROP
ENT.DoesRadiusDamage = true -- Should it deal radius damage when it collides with something?
ENT.RadiusDamageRadius = 250
ENT.RadiusDamage = 80
ENT.RadiusDamageUseRealisticRadius = true -- Should the damage decrease the farther away the hit entity is from the radius origin?
ENT.RadiusDamageType = DMG_BLAST
ENT.RadiusDamageForce = 90 -- Damage force to apply to the hit entity | false = Don't apply any force
ENT.CollisionBehavior = VJ.PROJ_COLLISION_NONE
ENT.CollisionDecals = "Scorch"
ENT.SoundTbl_OnCollide = "weapons/hegrenade/he_bounce-1.wav"

-- Custom
ENT.FuseTime = 3
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	timer.Simple(self.FuseTime, function()
		if IsValid(self) then
			self:Destroy()
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDamaged(dmginfo)
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:AddVelocity(dmginfo:GetDamageForce() * 0.1)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCollision(data, phys)
	local getVel = phys:GetVelocity()
	local curVelSpeed = getVel:Length()
	//print(curVelSpeed)
	if curVelSpeed > 500 then -- Or else it will go flying!
		phys:SetVelocity(getVel * 0.9)
	end
	
	if curVelSpeed > 100 then -- If the grenade is going faster than 100, then play the touch sound
		self:PlaySound("OnCollide")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local defAngle = Angle(0, 0, 0)
local vecZ4 = Vector(0, 0, 4)
local vezZ100 = Vector(0, 0, 100)
--
function ENT:OnDestroy()
	local myPos = self:GetPos()
	
	VJ.EmitSound(self, "VJ.Explosion")
	ParticleEffect("vj_explosion1", myPos, defAngle)
	util.ScreenShake(myPos, 100, 200, 1, 2500)
	
	local effectData = EffectData()
	effectData:SetOrigin(myPos)
	//effectData:SetScale(500)
	//util.Effect("HelicopterMegaBomb", effectData)
	//util.Effect("ThumperDust", effectData)
	//util.Effect("Explosion", effectData)
	util.Effect("VJ_Small_Explosion1", effectData)

	local expLight = ents.Create("light_dynamic")
	expLight:SetKeyValue("brightness", "4")
	expLight:SetKeyValue("distance", "300")
	expLight:SetLocalPos(myPos)
	expLight:SetLocalAngles(self:GetAngles())
	expLight:Fire("Color", "255 150 0")
	expLight:SetParent(self)
	expLight:Spawn()
	expLight:Activate()
	expLight:Fire("TurnOn", "", 0)
	self:DeleteOnRemove(expLight)

	self:SetLocalPos(myPos + vecZ4) -- Because the entity is too close to the ground
	local tr = util.TraceLine({
		start = myPos,
		endpos = myPos - vezZ100,
		filter = self
	})
	util.Decal(VJ.PICK(self.CollisionDecals), tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
	
	self:DealDamage()
end