if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
AddCSLuaFile("shared.lua")
include("shared.lua")
/*--------------------------------------------------
	=============== Gib Base ===============
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used as a base for gibs
--------------------------------------------------*/
ENT.BloodType = "Red"
ENT.Collide_Decal = "Default"
ENT.Collide_DecalChance = 3
ENT.CollideSound = "Default" -- Make it a table to use custom sounds!
ENT.CollideSoundLevel = 60
ENT.CollideSoundPitch1 = 80
ENT.CollideSoundPitch2 = 100

ENT.IsVJBaseCorpse = true
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	//self:SetModel("models/spitball_medium.mdl")
	self:PhysicsInit(MOVETYPE_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS) -- Use MOVETYPE_NONE for testing
	self:SetSolid(MOVETYPE_VPHYSICS)
	if GetConVarNumber("vj_npc_gibcollidable") == 0 then self:SetCollisionGroup(1) end

	-- Physics Functions
	local phys = self:GetPhysicsObject()
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
	if self.CollideSound == "Default" then
		self.CollideSound = {"physics/flesh/flesh_squishy_impact_hard1.wav","physics/flesh/flesh_squishy_impact_hard2.wav","physics/flesh/flesh_squishy_impact_hard3.wav","physics/flesh/flesh_squishy_impact_hard4.wav"}
	end
	
	if self.Collide_Decal == "Default" then
		local bloodtype = self.BloodType
		if bloodtype == "Red" then
			self.Collide_Decal = "VJ_Blood_Red"
		elseif bloodtype == "Yellow" then
			self.Collide_Decal = "VJ_Blood_Yellow"
		elseif bloodtype == "Green" then
			self.Collide_Decal = "VJ_Blood_Green"
		elseif bloodtype == "Orange" then
			self.Collide_Decal = "VJ_Blood_Orange"
		elseif bloodtype == "Blue" then
			self.Collide_Decal = "VJ_Blood_Blue"
		elseif bloodtype == "Purple" then
			self.Collide_Decal = "VJ_Blood_Purple"
		elseif bloodtype == "White" then
			self.Collide_Decal = "VJ_Blood_White"
		elseif bloodtype == "Oil" then
			self.Collide_Decal = "VJ_Blood_Oil"
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
    //if self:GetPhysicsObject():GetVelocity():Length() < 10 then
        //self:GetPhysicsObject():SetVelocity(Vector(0,0,0))
   //end
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
	local pickcollidesd = VJ_PICK(self.CollideSound)
	if GetConVarNumber("vj_npc_sd_gibbing") == 0 && pickcollidesd != false && velocityspeed > 18 then
		self.collidesd = CreateSound(self,pickcollidesd)
		self.collidesd:SetSoundLevel(self.CollideSoundLevel)
		self.collidesd:PlayEx(1,math.random(self.CollideSoundPitch1,self.CollideSoundPitch2))
	end
	
	if GetConVarNumber("vj_npc_nogibdecals") == 0 && velocityspeed > 18 then
		//local start = data.HitPos + data.HitNormal
		//local endpos = data.HitPos - data.HitNormal
		if !data.Entity && math.random(1,self.Collide_DecalChance) == 1 then
			self:SetLocalPos(Vector(self:GetPos().x,self:GetPos().y,self:GetPos().z +4)) -- Because the entity is too close to the ground
			local tr = util.TraceLine({
				start = self:GetPos(),
				endpos = self:GetPos() - (data.HitNormal * -30),
				filter = self //function( ent ) if ( ent:GetClass() == "prop_physics" ) then return true end end
			})
			if self.Collide_Decal != "" then
				util.Decal(self.Collide_Decal,tr.HitPos+tr.HitNormal,tr.HitPos-tr.HitNormal)
				//util.Decal(self.Collide_Decal,start,endpos)
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage(dmginfo)
	self:GetPhysicsObject():AddVelocity(dmginfo:GetDamageForce()*0.1)
end
/*--------------------------------------------------
	=============== Gib Base ===============
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used as a base for gibs
--------------------------------------------------*/
