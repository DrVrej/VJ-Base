AddCSLuaFile("shared.lua")
include("shared.lua")
/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
ENT.BloodType = "Red" -- Uses the same values as a VJ NPC
ENT.Collide_Decal = "Default"
ENT.Collide_DecalChance = 3
ENT.CollideSound = "Default" -- Make it a table to use custom sounds!
ENT.CollideSoundLevel = 60
ENT.CollideSoundPitch = VJ.SET(90, 100)
ENT.IsStinky = false -- Is this a disgusting stinky gib??

ENT.NextStinkyTime = 0

local stinkyMatTypes = {alienflesh=true, antlion=true, armorflesh=true, bloodyflesh=true, flesh=true, zombieflesh=true, player=true}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:PhysicsInit(MOVETYPE_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS) -- Use MOVETYPE_NONE for testing, makes the entity freeze!
	self:SetSolid(MOVETYPE_VPHYSICS)
	if GetConVar("vj_npc_gibcollidable"):GetInt() == 0 then self:SetCollisionGroup(1) end

	-- Physics Functions
	local physObj = self:GetPhysicsObject()
	if IsValid(physObj) then
		physObj:Wake()
		
		-- Stinky system
		if stinkyMatTypes[physObj:GetMaterial()] then
			self.IsStinky = true
		end
	end
	
	local hp = self:OBBMaxs():Distance(self:OBBMins())
	self:SetMaxHealth(hp)
	self:SetHealth(hp)

	-- Setup
	self:InitialSetup()
	
	-- Used to correct the blood data (Ex: Eating system uses this!)
	local bloodData = self.BloodData
	if bloodData then
		bloodData.Decal = self.Collide_Decal
	else
		self.BloodData = {Decal = self.Collide_Decal}
	end
	
	if GetConVar("vj_npc_sd_gibbing"):GetInt() == 1 then self.CollideSound = "" end
	if GetConVar("vj_npc_novfx_gibdeath"):GetInt() == 1 then self.Collide_Decal = "" end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local defCollideSds = {"physics/flesh/flesh_squishy_impact_hard1.wav","physics/flesh/flesh_squishy_impact_hard2.wav","physics/flesh/flesh_squishy_impact_hard3.wav","physics/flesh/flesh_squishy_impact_hard4.wav"}
local defDecals = {
	["Red"] = "VJ_Blood_Red",
	["Yellow"] = "VJ_Blood_Yellow",
	["Green"] = "VJ_Blood_Green",
	["Orange"] = "VJ_Blood_Orange",
	["Blue"] = "VJ_Blood_Blue",
	["Purple"] = "VJ_Blood_Purple",
	["White"] = "VJ_Blood_White",
	["Oil"] = "VJ_Blood_Oil",
}
local strDefault = "Default"
--
function ENT:InitialSetup()
	if self.CollideSound == strDefault then
		self.CollideSound = defCollideSds
	end
	
	if self.Collide_Decal == strDefault then
		self.Collide_Decal = defDecals[self.BloodType] or ""
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	-- Stinky gib! yuck!
	if self.IsStinky && self.NextStinkyTime < CurTime() then
		sound.EmitHint(SOUND_CARCASS, self:GetPos(), 400, 0.15, self) // SOUND_MEAT = Do NOT use this because we would need to call "GetLoudestSoundHint" twice for each sound type!
		self.NextStinkyTime = CurTime() + 2
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PhysicsCollide(data, phys)
	-- Effects
	local velSpeed = phys:GetVelocity():Length()
	local randCollideSd = VJ.PICK(self.CollideSound)
	if randCollideSd != false && velSpeed > 18 then
		self:EmitSound(randCollideSd, self.CollideSoundLevel, math.random(self.CollideSoundPitch.a, self.CollideSoundPitch.b))
	end

	if self.Collide_Decal != "" && velSpeed > 18 && !data.Entity && math.random(1, self.Collide_DecalChance) == 1 then
		local myPos = self:GetPos()
		self:SetLocalPos(myPos + self:GetUp() * 4) -- Because the entity is too close to the ground
		local tr = util.TraceLine({
			start = myPos,
			endpos = myPos - (data.HitNormal * -30),
			filter = self
		})
		util.Decal(self.Collide_Decal, tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
		//util.Decal(self.Collide_Decal, start, endpos)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage(dmginfo)
	self:GetPhysicsObject():AddVelocity(dmginfo:GetDamageForce() * 0.1)
end