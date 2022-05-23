/*--------------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Combine Ball"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Information		= "Projectiles for my addons"
ENT.Category		= "Projectiles"

ENT.VJ_IsDetectableDanger = true

if CLIENT then
	local Name = "Combine Ball"
	local LangName = "obj_vj_combineball"
	language.Add(LangName, Name)
	killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
	language.Add("#"..LangName, Name)
	killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))

	function ENT:Draw()
		self:DrawModel()
		self:SetAngles((LocalPlayer():EyePos() - self:GetPos()):Angle())
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = {"models/effects/combineball.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.MoveCollideType = MOVECOLLIDE_FLY_BOUNCE
ENT.RemoveOnHit = false -- Should it remove itself when it touches something? | It will run the hit sound, place a decal, etc.
ENT.DoesDirectDamage = false -- Should it do a direct damage when it hits something?
ENT.DirectDamage = 200 -- How much damage should it do when it hits something
ENT.DirectDamageType = bit.bor(DMG_DISSOLVE, DMG_BLAST, DMG_SHOCK) -- Damage type
ENT.CollideCodeWithoutRemoving = true -- If RemoveOnHit is set to false, you can still make the projectile deal damage, place a decal, etc.
ENT.DecalTbl_DeathDecals = {"Scorch"}
ENT.SoundTbl_Idle = {"weapons/physcannon/energy_sing_loop4.wav"}
ENT.SoundTbl_OnCollide = {"weapons/physcannon/energy_bounce1.wav","weapons/physcannon/energy_bounce2.wav"}

ENT.IdleSoundPitch = VJ_Set(100, 100)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomPhysicsObjectOnInitialize(phys)
	phys:Wake()
	phys:SetMass(1)
	phys:SetBuoyancyRatio(0)
	phys:EnableDrag(false)
	phys:EnableGravity(false)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitializeBeforePhys()
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
function ENT:CustomOnInitialize()
	timer.Simple(5, function() if IsValid(self) then self:DeathEffects() end end)

	self:DrawShadow(false)
	self:ResetSequence("idle")
	self:SetCoreType(false)
	VJ_CreateSound(self, "weapons/irifle/irifle_fire2.wav", 85)

	util.SpriteTrail(self, 0, colorWhite, true, 15, 0, 0.1, 1 / 6 * 0.5, "sprites/combineball_trail_black_1.vmt")

	local hookName = "VJ_CombineBall_" .. self:EntIndex() .. "_PickedUp"
	hook.Add("GravGunOnPickedUp", hookName, function(ply,ent)
		if !IsValid(self) then
			hook.Remove("GravGunOnPickedUp", hookName)
			return
		end
		self:SetCoreType(true)
	end)

	hookName = "VJ_CombineBall_" .. self:EntIndex() .. "_Dropped"
	hook.Add("GravGunOnDropped", hookName, function(ply,ent)
		if !IsValid(self) then
			hook.Remove("GravGunOnDropped", hookName)
			return
		end
		self:SetCoreType(false)
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnBounce(data, phys)
	local myPos = self:GetPos()
	local owner = self:GetOwner()
	local newVel = phys:GetVelocity():GetNormal()
	local lastVel = math.max(newVel:Length(), math.max(data.OurOldVelocity:Length(), data.Speed)) -- Get the last velocity and speed
	phys:SetVelocity(newVel * lastVel * 0.95)

	if !IsValid(owner) then return end
	local closestDist = 1024
	local target = NULL
	for _, v in pairs(ents.FindInSphere(myPos, 1024)) do
		if (!v:IsNPC() && !v:IsPlayer()) then continue end
		if !owner:DoRelationshipCheck(v) then continue end
		local dist = v:GetPos():Distance(myPos)
		if dist < closestDist && dist > 20 then
			closestDist = dist
			target = v
		end
	end
	
	if IsValid(target) then
		local targetPos = target:GetPos() + target:OBBCenter()
		local norm = (targetPos - myPos):GetNormalized()
		if self:GetForward():DotProduct(norm) < 0.95 then
			phys:SetVelocity(norm * lastVel)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPhysicsCollide(data, phys)
	local owner = self:GetOwner()
	local hitEnt = data.HitEntity
	if IsValid(owner) then
		if (VJ_IsProp(hitEnt)) or (owner:DoRelationshipCheck(hitEnt) && (hitEnt != owner)) then
			self:CustomOnDoDamage_Direct(data, phys, hitEnt)
			local dmgInfo = DamageInfo()
			dmgInfo:SetDamage(self.DirectDamage)
			dmgInfo:SetDamageType(self.DirectDamageType)
			dmgInfo:SetAttacker(owner)
			dmgInfo:SetInflictor(self)
			dmgInfo:SetDamagePosition(data.HitPos)
			hitEnt:TakeDamageInfo(dmgInfo, self)
			VJ_DestroyCombineTurret(owner, hitEnt)
		end
	else
		self:CustomOnDoDamage_Direct(data, phys, hitEnt)
		local dmgInfo = DamageInfo()
		dmgInfo:SetDamage(self.DirectDamage)
		dmgInfo:SetDamageType(self.DirectDamageType)
		dmgInfo:SetAttacker(self)
		dmgInfo:SetInflictor(self)
		dmgInfo:SetDamagePosition(data.HitPos)
		hitEnt:TakeDamageInfo(dmgInfo, self)
		VJ_DestroyCombineTurret(self, hitEnt)
	end

	if (hitEnt:IsNPC() or hitEnt:IsPlayer()) then return end
	
	self:OnBounce(data,phys)

	local dataF = EffectData()
	dataF:SetOrigin(data.HitPos)
	util.Effect("cball_bounce", dataF)

	dataF = EffectData()
	dataF:SetOrigin(data.HitPos)
	dataF:SetNormal(data.HitNormal)
	dataF:SetScale(50)
	util.Effect("AR2Impact", dataF)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GravGunPunt(ply)
	self:SetCoreType(false)
	self:GetPhysicsObject():EnableMotion(true)
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
local sdHit = {"weapons/physcannon/energy_disintegrate4.wav", "weapons/physcannon/energy_disintegrate5.wav"}
--
function ENT:CustomOnDoDamage_Direct(data, phys, hitEnt)
	VJ_CreateSound(hitEnt, VJ_PICK(sdHit), 80)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local color1 = Color(255, 255, 225, 32)
local color2 = Color(255, 255, 225, 64)
--
function ENT:DeathEffects(data, phys)
	local myPos = self:GetPos()
	effects.BeamRingPoint(myPos, 0.2, 12, 1024, 64, 0, color1, {material="sprites/lgtning.vmt", framerate=2, flags=0, speed=0, delay=0, spread=0})
	effects.BeamRingPoint(myPos, 0.5, 12, 1024, 64, 0, color2, {material="sprites/lgtning.vmt", framerate=2, flags=0, speed=0, delay=0, spread=0})

	local effectData = EffectData()
	effectData:SetOrigin(myPos)
	util.Effect("cball_explode", effectData)

	VJ_EmitSound(self, "weapons/physcannon/energy_sing_explosion2.wav", 150)
	util.ScreenShake(myPos, 20, 150, 1, 1250)
	util.VJ_SphereDamage(self, self, myPos, 400, 25, bit.bor(DMG_SONIC, DMG_BLAST), true, true, {DisableVisibilityCheck=true, Force=80})

	self:Remove()
end