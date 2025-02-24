AddCSLuaFile("shared.lua")
include("shared.lua")
/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
ENT.IsStinky = false -- Is this a disgusting stinky gib??
ENT.BloodType = VJ.BLOOD_COLOR_RED -- Uses the same values as a VJ NPC
ENT.CollisionDecal = "Default"
ENT.CollisionDecalChance = 3
	-- ====== Sound ====== --
ENT.CollisionSound = {"physics/flesh/flesh_squishy_impact_hard1.wav", "physics/flesh/flesh_squishy_impact_hard2.wav", "physics/flesh/flesh_squishy_impact_hard3.wav", "physics/flesh/flesh_squishy_impact_hard4.wav"}
ENT.CollisionSoundLevel = 60
ENT.CollisionSoundPitch = VJ.SET(90, 100)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ ///// WARNING: Don't touch anything below this line! \\\\\ ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.NextStinkyTime = 0

local stinkyMatTypes = {alienflesh=true, antlion=true, armorflesh=true, bloodyflesh=true, flesh=true, zombieflesh=true, player=true}
local defDecals = {
	[VJ.BLOOD_COLOR_RED] = "VJ_Blood_Red",
	[VJ.BLOOD_COLOR_YELLOW] = "VJ_Blood_Yellow",
	[VJ.BLOOD_COLOR_GREEN] = "VJ_Blood_Green",
	[VJ.BLOOD_COLOR_ORANGE] = "VJ_Blood_Orange",
	[VJ.BLOOD_COLOR_BLUE] = "VJ_Blood_Blue",
	[VJ.BLOOD_COLOR_PURPLE] = "VJ_Blood_Purple",
	[VJ.BLOOD_COLOR_WHITE] = "VJ_Blood_White",
	[VJ.BLOOD_COLOR_OIL] = "VJ_Blood_Oil",
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:PhysicsInit(MOVETYPE_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS) -- Use MOVETYPE_NONE for testing, makes the entity freeze!
	self:SetSolid(MOVETYPE_VPHYSICS)
	if GetConVar("vj_npc_gib_collision"):GetInt() == 0 then self:SetCollisionGroup(COLLISION_GROUP_DEBRIS) end

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
	
	if self.CollisionDecal == "Default" then
		self.CollisionDecal = defDecals[self.BloodType] or false
	end
	
	-- Used to correct the blood data (Ex: Eating system uses this!)
	local bloodData = self.BloodData
	if bloodData then
		bloodData.Decal = self.CollisionDecal
	else
		self.BloodData = {Decal = self.CollisionDecal}
	end
	
	if GetConVar("vj_npc_snd_gib"):GetInt() == 0 then self.CollisionSound = false end
	if GetConVar("vj_npc_gib_vfx"):GetInt() == 0 then self.CollisionDecal = false end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	local selfData = self:GetTable()
	
	-- Stinky gib! yuck!
	if selfData.IsStinky && selfData.NextStinkyTime < CurTime() then
		sound.EmitHint(SOUND_CARCASS, self:GetPos(), 400, 0.15, self) // SOUND_MEAT = Do NOT use this because we would need to call "GetLoudestSoundHint" twice for each sound type!
		selfData.NextStinkyTime = CurTime() + 2
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PhysicsCollide(data, phys)
	local selfData = self:GetTable()
	
	-- Collision Sound
	local velSpeed = phys:GetVelocity():Length()
	local collideSD = VJ.PICK(selfData.CollisionSound)
	if collideSD && velSpeed > 18 then
		self:EmitSound(collideSD, selfData.CollisionSoundLevel, math.random(selfData.CollisionSoundPitch.a, selfData.CollisionSoundPitch.b))
	end

	-- Collision Decal
	local collideDecal = VJ.PICK(selfData.CollisionDecal)
	if collideDecal && velSpeed > 18 && !data.Entity && math.random(1, selfData.CollisionDecalChance) == 1 then
		local myPos = self:GetPos()
		self:SetLocalPos(myPos + self:GetUp() * 4) -- Because the entity is too close to the ground
		local tr = util.TraceLine({
			start = myPos,
			endpos = myPos - (data.HitNormal * -30),
			filter = self
		})
		util.Decal(collideDecal, tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage(dmginfo)
	self:GetPhysicsObject():AddVelocity(dmginfo:GetDamageForce() * 0.1)
end