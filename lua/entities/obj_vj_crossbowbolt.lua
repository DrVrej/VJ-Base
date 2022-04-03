/*--------------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Crossbow Bolt"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Information		= "Projectiles for my addons"
ENT.Category		= "Projectiles"
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	local Name = "Crossbow Bolt"
	local LangName = "obj_vj_crossbowbolt"
	language.Add(LangName, Name)
	killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
	language.Add("#"..LangName, Name)
	killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = {"models/crossbow_bolt.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.DoesDirectDamage = true -- Should it do a direct damage when it hits something?
ENT.DirectDamage = 90 -- How much damage should it do when it hits something
ENT.DecalTbl_DeathDecals = {"Impact.Concrete"}
ENT.SoundTbl_Idle = {"weapons/fx/nearmiss/bulletltor03.wav"}
ENT.SoundTbl_OnCollide = {"weapons/crossbow/hit1.wav"}

ENT.IdleSoundLevel = 60
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitializeBeforePhys()
	self:PhysicsInitSphere(1, "metal_bouncy")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomPhysicsObjectOnInitialize(phys)
	phys:SetMass(1)
	phys:EnableGravity(false)
	phys:EnableDrag(false)
	phys:SetBuoyancyRatio(0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPhysicsCollide(data, phys)
	if IsValid(data.HitEntity) then
		self.SoundTbl_OnCollide = {"weapons/crossbow/hitbod1.wav","weapons/crossbow/hitbod2.wav"} // weapons/crossbow/bolt_skewer1.wav
		if (data.HitEntity:IsNPC() or data.HitEntity:IsNextBot()) && data.HitEntity:GetHullType() == HULL_TINY then
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