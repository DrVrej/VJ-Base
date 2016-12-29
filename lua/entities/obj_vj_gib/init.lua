if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")
/*--------------------------------------------------
	=============== Gib Base ===============
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used as a base for gibs
--------------------------------------------------*/
ENT.BloodType = "Red"
ENT.Collide_Decal = "Blood"
ENT.Collide_DecalChance = 3
ENT.CollideSound = {"physics/flesh/flesh_squishy_impact_hard1.wav","physics/flesh/flesh_squishy_impact_hard2.wav","physics/flesh/flesh_squishy_impact_hard3.wav","physics/flesh/flesh_squishy_impact_hard4.wav"}
ENT.CollideSoundLevel = 60
ENT.CollideSoundPitch1 = 80
ENT.CollideSoundPitch2 = 100
ENT.Collide_Decal = "Blood"

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
	
	-- Misc
	self:SetUpInitializeBloodType()
	if GetConVarNumber("vj_npc_fadegibs") == 1 then
		timer.Simple(GetConVarNumber("vj_npc_fadegibstime"),function() if IsValid(self) then self:Remove() end end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetUpInitializeBloodType()
	local bloodtype = self.BloodType
	if bloodtype == "Red" then
		self.Collide_Decal = "VJ_Blood_Red"
	elseif bloodtype == "Yellow" then
		self.Collide_Decal = "VJ_Blood_Yellow"
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	//print(self.BloodType)
	/*if self:IsValid() then
		self.idlesoundc = CreateSound(self, self.IdleSound1)
		self.idlesoundc:Play()

		ParticleEffectAttach("antlion_spit", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	end*/
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PhysicsCollide(data,phys)
	-- Effects
	local velocityspeed = phys:GetVelocity():Length()
	local pickcollidesd = VJ_PICKRANDOMTABLE(self.CollideSound)
	if GetConVarNumber("vj_npc_sd_gibbing") == 0 && pickcollidesd != false && velocityspeed > 20 then
		self.collidesd = CreateSound(self,pickcollidesd)
		self.collidesd:SetSoundLevel(self.CollideSoundLevel)
		self.collidesd:PlayEx(1,math.random(self.CollideSoundPitch1,self.CollideSoundPitch2)) 
	end
	
	if GetConVarNumber("vj_npc_nogibdecals") == 0 then
		//local start = data.HitPos + data.HitNormal 
		//local endpos = data.HitPos - data.HitNormal
		if !data.Entity && math.random(1,self.Collide_DecalChance) == 1 then
			self:SetLocalPos(Vector(self:GetPos().x,self:GetPos().y,self:GetPos().z +4)) -- Because the entity is too close to the ground
			local tr = util.TraceLine({
				start = self:GetPos(),
				endpos = self:GetPos() - Vector(0, 0, 30),
				filter = self //function( ent ) if ( ent:GetClass() == "prop_physics" ) then return true end end
			})
			util.Decal(self.Collide_Decal,tr.HitPos+tr.HitNormal,tr.HitPos-tr.HitNormal)
			//util.Decal(self.Collide_Decal,start,endpos)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage(dmginfo)
	self:GetPhysicsObject():AddVelocity(dmginfo:GetDamageForce()*0.1)
end
/*--------------------------------------------------
	=============== Gib Base ===============
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used as a base for gibs
--------------------------------------------------*/