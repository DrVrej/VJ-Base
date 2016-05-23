if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")
/*--------------------------------------------------
	=============== Normal Gib Base ===============
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used as a base for Normal gibs
--------------------------------------------------*/
ENT.IdleSound1 = Sound("rrrrrrrr/rrrrrrrr.wav")
//ENT.TouchSound = Sound("physics/flesh/flesh_squishy_impact_hard"..math.random(1,4)..".wav")
ENT.TouchSoundv = 60
ENT.TouchSoundPitch = math.random(80,100)
ENT.Decal = "Blood"
ENT.DecalChance = 3
ENT.IsVJBaseCorpse = true
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	//self:SetModel("models/spitball_medium.mdl")
	self:PhysicsInit(MOVETYPE_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS) -- Use MOVETYPE_NONE for testing
	self:SetSolid(MOVETYPE_VPHYSICS)
	if GetConVarNumber("vj_npc_gibcollidable") == 0 then self:SetCollisionGroup(1) end

	-- Physics Functions
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		//phys:EnableGravity(false)
		//phys:EnableDrag(false)
		//phys:SetBuoyancyRatio(0)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
if GetConVarNumber("vj_npc_fadegibs") == 1 then
	if self:IsValid() then
	timer.Simple(GetConVarNumber("vj_npc_fadegibstime"),function()
	if self:IsValid() then
	self:Remove()
	end
  end)
 end
end

/*if self:IsValid() then
	self.idlesoundc = CreateSound(self, self.IdleSound1)
	self.idlesoundc:Play()

	ParticleEffectAttach("antlion_spit", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	end*/
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PhysicsCollide(data)
	-- Effects
	if GetConVarNumber("vj_npc_sd_gibbing") == 0 then
		self.touchsound = CreateSound(self, "physics/flesh/flesh_squishy_impact_hard"..math.random(1,4)..".wav")
		self.touchsound:SetSoundLevel(self.TouchSoundv)
		self.touchsound:PlayEx(1, self.TouchSoundPitch) 
	end
	
	if GetConVarNumber("vj_npc_nogibdecals") == 0 then
		//local start = data.HitPos + data.HitNormal 
		//local endpos = data.HitPos - data.HitNormal
		if !data.Entity then
		if math.random(1,self.DecalChance) == 1 then
			self:SetLocalPos(Vector(self:GetPos().x,self:GetPos().y,self:GetPos().z +4)) -- Because the entity is too close to the ground
			local tr = util.TraceLine({
			start = self:GetPos(),
			endpos = self:GetPos() - Vector(0, 0, 30),
			filter = self //function( ent ) if ( ent:GetClass() == "prop_physics" ) then return true end end
			})
			util.Decal(self.Decal,tr.HitPos+tr.HitNormal,tr.HitPos-tr.HitNormal)
			//util.Decal(self.Decal,start,endpos)
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage(dmginfo)
	self:GetPhysicsObject():AddVelocity(dmginfo:GetDamageForce() *0.1)
end
/*--------------------------------------------------
	=============== Normal Gib Base ===============
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used as a base for Normal gibs
--------------------------------------------------*/