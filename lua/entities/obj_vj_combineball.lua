/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Combine Ball"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Category		= "VJ Base"

ENT.VJ_ID_Danger = true
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	VJ.AddKillIcon("obj_vj_combineball", ENT.PrintName, VJ.KILLICON_TYPE_ALIAS, "prop_combine_ball")

	function ENT:Draw()
		self:DrawModel()
		self:SetAngles((LocalPlayer():EyePos() - self:GetPos()):Angle())
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = "models/effects/combineball.mdl"
ENT.CollisionBehavior = VJ.PROJ_COLLISION_PERSIST
ENT.CollisionDecal = "FadingScorch"
ENT.DirectDamage = 200
ENT.DirectDamageType = bit.bor(DMG_DISSOLVE, DMG_BLAST, DMG_SHOCK)
ENT.SoundTbl_Idle = "weapons/physcannon/energy_sing_loop4.wav"
ENT.SoundTbl_OnCollide = "NPC_CombineBall.Impact"

ENT.IdleSoundPitch = VJ.SET(100, 100)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:InitPhys()
	self:PhysicsInitSphere(1, "metal_bouncy")
	construct.SetPhysProp(self:GetOwner(), self, 0, self:GetPhysicsObject(), {GravityToggle = false, Material = "metal_bouncy"})
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetCoreType(capture)
	if capture then
		self:SetSubMaterial(0, "models/effects/comball_glow1")
	else
		self:SetSubMaterial(0, "vj_base/effects/comball_glow2")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local colorWhite = Color(255, 255, 255, 255)
--
function ENT:Init()
	timer.Simple(4, function() if IsValid(self) then self:Destroy() end end)

	self:DrawShadow(false)
	self:ResetSequence("idle")
	self:SetCoreType(false)
	
	local owner = self:GetOwner()
	if IsValid(owner) && owner:IsPlayer() then
		self.DirectDamage = 400
	end

	util.SpriteTrail(self, 0, colorWhite, true, 15, 0, 0.1, 1 / 6 * 0.5, "sprites/combineball_trail_black_1.vmt")

	hook.Add("GravGunOnPickedUp", self, function(_, ply, ent)
		if ent == self then
			self:SetCoreType(true)
		end
	end)

	hook.Add("GravGunOnDropped", self, function(_, ply, ent)
		if ent == self then
			self:SetCoreType(false)
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnBounce(data, phys)
	local owner = self:GetOwner()
	if !IsValid(owner) then return end
	local myPos = self:GetPos()
	
	-- Find the closest enemy
	local ownerIsVJ = owner.IsVJBaseSNPC
	local closestDist = 1024
	local target = false
	for _, v in ipairs(ents.FindInSphere(myPos, closestDist)) do
		if v.VJ_ID_Living && v != owner then
			if ownerIsVJ && owner:CheckRelationship(v) != D_HT then continue end
			local dist = v:GetPos():Distance(myPos)
			if dist < closestDist && dist > 20 then
				closestDist = dist
				target = v
			end
		end
	end
	
	if target then
		local norm = ((target:GetPos() + target:OBBCenter()) - myPos):GetNormalized()
		if self:GetForward():Dot(norm) < 0.75 then -- Lowered the visual range from 0.95, too accurate
			phys:SetVelocity(norm * math.max(phys:GetVelocity():GetNormal():Length(), math.max(data.OurOldVelocity:Length(), data.Speed)))
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------\
function ENT:OnCollision(data, phys)
	self.NextPersistCollisionT = 0 -- We don't want any delays for this projectile
	local owner = self:GetOwner()
	local ent = data.HitEntity
	if IsValid(owner) then
		if IsValid(ent) && ((!ent:IsNPC() && !ent:IsPlayer()) or (ent:IsNPC() && ent:GetClass() != owner:GetClass() && (owner:IsPlayer() or (owner:IsNPC() && owner:Disposition(ent) != D_LI))) or (ent:IsPlayer() && ent:Alive() && (owner:IsPlayer() or (!VJ_CVAR_IGNOREPLAYERS && !ent:IsFlagSet(FL_NOTARGET))))) then
			VJ.EmitSound(ent, "NPC_CombineBall.KillImpact")
			local dmgInfo = DamageInfo()
			dmgInfo:SetDamage(self.DirectDamage)
			dmgInfo:SetDamageType(self.DirectDamageType)
			dmgInfo:SetAttacker(owner)
			dmgInfo:SetInflictor(self)
			dmgInfo:SetDamagePosition(data.HitPos)
			VJ.DamageSpecialEnts(owner, ent, dmgInfo)
			ent:TakeDamageInfo(dmgInfo, self)
		end
	else
		VJ.EmitSound(ent, "NPC_CombineBall.KillImpact")
		local dmgInfo = DamageInfo()
		dmgInfo:SetDamage(self.DirectDamage)
		dmgInfo:SetDamageType(self.DirectDamageType)
		dmgInfo:SetAttacker(self)
		dmgInfo:SetInflictor(self)
		dmgInfo:SetDamagePosition(data.HitPos)
		VJ.DamageSpecialEnts(self, ent, dmgInfo)
		ent:TakeDamageInfo(dmgInfo, self)
	end

	if (ent:IsNPC() or ent:IsPlayer()) then return end
	
	self:OnBounce(data, phys)

	local effectData = EffectData()
	effectData:SetOrigin(data.HitPos)
	effectData:SetNormal(data.HitNormal)
	effectData:SetRadius(16)
	util.Effect("cball_bounce", effectData)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GravGunPunt(ply)
	self:SetCoreType(false)
	self:GetPhysicsObject():EnableMotion(true)
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
local color1 = Color(255, 255, 225, 32)
local color2 = Color(255, 255, 225, 64)
--
function ENT:OnDestroy(data, phys)
	local myPos = self:GetPos()
	effects.BeamRingPoint(myPos, 0.2, 12, 1024, 64, 0, color1, {material = "sprites/lgtning.vmt", framerate = 2, flags = 0, speed = 0, delay = 0, spread = 0})
	effects.BeamRingPoint(myPos, 0.5, 12, 1024, 64, 0, color2, {material = "sprites/lgtning.vmt", framerate = 2, flags = 0, speed = 0, delay = 0, spread = 0})
	util.ScreenShake(myPos, 20, 150, 1, 1250)
	VJ.ApplyRadiusDamage(self, self, myPos, 400, 25, bit.bor(DMG_SONIC, DMG_BLAST), true, true, {DisableVisibilityCheck = true, Force = 80})
	VJ.EmitSound(self, "NPC_CombineBall.Explosion")
	sound.EmitHint(bit.bor(SOUND_COMBAT, SOUND_CONTEXT_EXPLOSION), myPos, 512, 0.5)

	local effectData = EffectData()
	effectData:SetOrigin(myPos)
	util.Effect("cball_explode", effectData)
end