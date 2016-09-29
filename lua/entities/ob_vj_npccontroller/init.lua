AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')
/*--------------------------------------------------
	=============== NPC Controller Base ===============
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to control NPCs. Mainly for VJ Base SNPCs.
--------------------------------------------------*/
ENT.PlayingAnimation = false
ENT.PlayingAttackAnimation = false
ENT.PlayingRangeAttackAnimation = false
ENT.PlayingGrenadeAttackAnimation = false
ENT.PlayingRangeAttackHumanAnimation = false
ENT.VJControllerEntityIsRemoved = false
ENT.CurrentAttackAnimation = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnSetControlledNPC() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnStopControlling() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetModel("models/props_junk/watermelon01_chunk02c.mdl")
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
	//self:StartControlling()
	self:CustomOnInitialize()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartControlling()
	//self.TheController = self.Owner
	//if (self.TheController) then return end
	//print(self.TheController)
	self.TheController.IsControlingNPC = true

	self.PropCamera = ents.Create("prop_dynamic")
	self.PropCamera:SetPos(self.ControlledNPC:GetPos() +Vector(0,0,self.ControlledNPC:OBBMaxs().z +20)) //self.ControlledNPC:EyePos()
	self.PropCamera:SetModel("models/props_junk/watermelon01_chunk02c.mdl")
	self.PropCamera:SetParent(self.ControlledNPC)
	self.PropCamera:SetRenderMode(RENDERMODE_TRANSALPHA)
	self.PropCamera:Spawn()
	self.PropCamera:SetColor(Color(0,0,0,0))
	self.PropCamera:SetNoDraw(false)
	self.PropCamera:DrawShadow(false)
	//self:DeleteOnRemove(self.PropCamera)

	self.TheController:Spectate(OBS_MODE_CHASE)
	self.TheController:SpectateEntity(self.PropCamera)
	self.TheController:SetNoTarget(true)
	self.TheController:DrawShadow(false)
	self.TheController:SetNoDraw(true)
	self.TheController:SetMoveType(MOVETYPE_OBSERVER)
	self.TheController:DrawViewModel(false)
	self.TheController:DrawWorldModel(false)
	self.ControllerHealth = self.TheController:Health()
	self.ControllerArmor = self.TheController:Armor()
	if (IsValid(self.TheController:GetActiveWeapon())) then 
	self.ControllerActiveWeapon = self.TheController:GetActiveWeapon():GetClass() end
	self.ControllerCurrentWeapons = {}
	for k, v in pairs(self.TheController:GetWeapons()) do
	table.insert(self.ControllerCurrentWeapons,v:GetClass()) end
	self.TheController:StripWeapons()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetControlledNPC(GetEntity)
	self.ControlledNPC = GetEntity
	self.ControlledNPC.VJ_IsBeingControlled = true
	self.ControlledNPC.VJ_TheController = self.TheController
	self.ControlledNPC.VJ_TheControllerEntity = self
	self.ControlledNPC:SetEnemy(NULL)
	self.ControlledNPC.MyEnemy = NULL
	self.ControlledNPC.Enemy = NULL
	if self.ControlledNPC.IsVJBaseSNPC == true then
		self.VJNPC_DisableWandering = self.ControlledNPC.DisableWandering
		self.VJNPC_DisableChasingEnemy = self.ControlledNPC.DisableChasingEnemy
		//self.VJNPC_DisableFindEnemy = self.ControlledNPC.DisableFindEnemy
		self.VJNPC_DisableTakeDamageFindEnemy = self.ControlledNPC.DisableTakeDamageFindEnemy
		self.VJNPC_DisableTouchFindEnemy = self.ControlledNPC.DisableTouchFindEnemy
		self.VJNPC_DisableSelectSchedule = self.ControlledNPC.DisableSelectSchedule
		self.VJNPC_HasMeleeAttack = self.ControlledNPC.HasMeleeAttack
		self.VJNPC_HasRangeAttack = self.ControlledNPC.HasRangeAttack
		self.VJNPC_HasLeapAttack = self.ControlledNPC.HasLeapAttack
		self.VJNPC_HasGrenadeAttack = self.ControlledNPC.HasGrenadeAttack
		self.VJNPC_CallForHelp = self.ControlledNPC.CallForHelp
		self.VJNPC_CallForBackUpOnDamage = self.ControlledNPC.CallForBackUpOnDamage
		self.VJNPC_FollowPlayer = self.ControlledNPC.FollowPlayer
		self.VJNPC_BringFriendsOnDeath = self.ControlledNPC.BringFriendsOnDeath
		self.VJNPC_RunsAwayFromGrenades = self.ControlledNPC.CanDetectGrenades
		self.VJNPC_RunOnTouch = self.ControlledNPC.RunOnTouch
		self.VJNPC_RunOnHit = self.ControlledNPC.RunOnHit
		self.ControlledNPC:ClearSchedule()
		self.ControlledNPC.DisableSelectSchedule = true
		//self.ControlledNPC.DisableFindEnemy = true
		self.ControlledNPC.DisableTakeDamageFindEnemy = true
		self.ControlledNPC.DisableTouchFindEnemy = true
		self.ControlledNPC.HasMeleeAttack = false
		self.ControlledNPC.HasRangeAttack = false
		self.ControlledNPC.HasLeapAttack = false
		self.ControlledNPC.HasGrenadeAttack = false
		self.ControlledNPC.CallForHelp = false
		self.ControlledNPC.CallForBackUpOnDamage = false
		self.ControlledNPC.BringFriendsOnDeath = false
		self.ControlledNPC.FollowPlayer = false
		self.ControlledNPC.DisableWandering = true
		self.ControlledNPC.DisableChasingEnemy = true
		self.ControlledNPC.CanDetectGrenades = false
		self.ControlledNPC.vACT_StopAttacks = true
		if self.ControlledNPC.IsVJBaseSNPC_Animal != true then
			self.ControlledNPC:ResetEnemy() else
			self.ControlledNPC.RunOnTouch = false
			self.ControlledNPC.RunOnHit = false
		end
		if self.ControlledNPC.IsVJBaseSNPC_Human == true then
			if self.ControlledNPC.DisableWeapons == false then 
				self.ControlledNPC:CapabilitiesRemove(bit.bor(CAP_MOVE_SHOOT))
				self.ControlledNPC:CapabilitiesRemove(bit.bor(CAP_AIM_GUN))
			end
		end
	end
	self.ControlledNPC:StopMoving()
	self.ControlledNPC:ClearSchedule()
	//self.ControlledNPC:VJ_SetSchedule(SCHED_IDLE_STAND)
	self.PlayingAttackAnimation = true
	self.PlayingRangeAttackAnimation = true
	timer.Simple(0.2,function()
		if IsValid(self.ControlledNPC) then
			self.PlayingAttackAnimation = false
			self.PlayingRangeAttackAnimation = false
			self.ControlledNPC.vACT_StopAttacks = false
		end
	end)
	self:CustomOnSetControlledNPC()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	if (!self.PropCamera:IsValid()) then self:StopControlling() return end
	if !IsValid(self.TheController) or self.TheController:KeyDown(IN_USE) or self.TheController:Health() <= 0 or (!self.TheController.IsControlingNPC) or !IsValid(self.ControlledNPC) or self.ControlledNPC:Health() <= 0 then self:StopControlling() return end
		if self.TheController.IsControlingNPC != true then return end
		if (self.TheController.IsControlingNPC) && IsValid(self.ControlledNPC) then
		if self.PlayingRangeAttackAnimation == false then //self.PlayingAnimation == false && self.PlayingAttackAnimation == false && self.PlayingRangeAttackAnimation == false /*&& !self.ControlledNPC:IsMoving()*/ then
		if self.ControlledNPC:IsMoving() then
			self.ControlledNPC:SetAngles(Angle(0,math.ApproachAngle(self.ControlledNPC:GetAngles().y,self.TheController:GetAimVector():Angle().y,4),0)) else
			self.ControlledNPC:SetAngles(Angle(0,math.ApproachAngle(self.ControlledNPC:GetAngles().y,self.TheController:GetAimVector():Angle().y,360),0))
			end
		end
		if #self.TheController:GetWeapons() > 0 then self.TheController:StripWeapons() end
		//self.ControlledNPC:SetEnemy(self)
		if self.PlayingAttackAnimation == true then return end
		
		self:CustomOnThink()
		
		if self.ControlledNPC.IsVJBaseSNPC_Animal != true && self.ControlledNPC.IsVJBaseSNPC == true then
		if self.TheController:KeyDown(IN_ATTACK) then
			if self.VJNPC_HasMeleeAttack == true then
			if self.ControlledNPC.IsVJBaseSNPC_Creature == true && self.ControlledNPC:GetEnemy() == nil then self.ControlledNPC:SetEnemy(self) end //timer.Simple(0.15, if IsValid(self) && IsValid(self.ControlledNPC) then self.ControlledNPC:SetEnemy(NULL) end end) end
			if self.ControlledNPC.IsVJBaseSNPC_Creature == true && self.ControlledNPC:GetEnemy() != nil then self.ControlledNPC:MultipleMeleeAttacks() end
			self.ControlledNPC:CustomOnMeleeAttack_BeforeStartTimer()
			self.PlayingAnimation = true
			self.PlayingAttackAnimation = true
			self.ControlledNPC:StopMoving()
			//self.ControlledNPC:ClearSchedule()
			self.CurrentAttackAnimation = VJ_PICKRANDOMTABLE(self.ControlledNPC.AnimTbl_MeleeAttack)
			self.ControlledNPC:VJ_ACT_PLAYACTIVITY(VJ_PICKRANDOMTABLE(self.ControlledNPC.AnimTbl_MeleeAttack),false,0,false,self.ControlledNPC.MeleeAttackAnimationDelay)
			timer.Simple(VJ_GetSequenceDuration(self.ControlledNPC,self.CurrentAttackAnimation) -0.2,function()
				if IsValid(self.ControlledNPC) then
				self.ControlledNPC:VJ_SetSchedule(SCHED_IDLE_STAND)
				end
			end)
			if self.ControlledNPC.IsVJBaseSNPC_Creature == true then
				for tk, tv in ipairs(self.ControlledNPC.MeleeAttackExtraTimers) do
					self.ControlledNPC:DoAddExtraAttackTimers("timer_melee_start_"..self.ControlledNPC:GetClass().."_"..math.random(1,999999),tv,1,"MeleeAttack")
				end
			end
			timer.Simple(self.ControlledNPC.TimeUntilMeleeAttackDamage,function()
			if IsValid(self.ControlledNPC) then
			self.ControlledNPC:MeleeAttackCode()
			timer.Simple(self.ControlledNPC.NextAnyAttackTime_Melee +0.4,function()
				if IsValid(self.ControlledNPC) then
				self.PlayingAnimation = false
				self.PlayingAttackAnimation = false
				end
			end)
		  end
		 end)
		 self.ControlledNPC:CustomOnMeleeAttack_AfterStartTimer()
		end
		elseif self.TheController:KeyDown(IN_ATTACK2) then
			if self.ControlledNPC.IsVJBaseSNPC_Creature == true then
			if self.VJNPC_HasRangeAttack == true && self.PlayingRangeAttackAnimation == false then
			if self.ControlledNPC:GetEnemy() == nil then self.TheController:PrintMessage(HUD_PRINTCENTER,"It can only do range attack if it sees an enemy!") else
			self.ControlledNPC:CustomOnRangeAttack_BeforeStartTimer()
			self.PlayingAnimation = true
			self.PlayingAttackAnimation = true
			self.PlayingRangeAttackAnimation = true
			self.ControlledNPC:StopMoving()
			//self.ControlledNPC:ClearSchedule()
			self.CurrentAttackAnimation = VJ_PICKRANDOMTABLE(self.ControlledNPC.AnimTbl_RangeAttack)
			self.ControlledNPC:VJ_ACT_PLAYACTIVITY(VJ_PICKRANDOMTABLE(self.ControlledNPC.AnimTbl_RangeAttack),false,0,false,self.ControlledNPC.RangeAttackAnimationDelay)
			self.ControlledNPC:CustomOnRangeAttack_AfterStartTimer()
			timer.Simple(VJ_GetSequenceDuration(self.ControlledNPC,self.CurrentAttackAnimation) -0.2,function()
				if IsValid(self.ControlledNPC) then
				self.PlayingAnimation = false
				self.PlayingAttackAnimation = false
				self.ControlledNPC:VJ_SetSchedule(SCHED_IDLE_STAND)
				end
			end)
			timer.Create( "timer_range_start"..self.ControlledNPC.Entity:EntIndex(), self.ControlledNPC.TimeUntilRangeAttackProjectileRelease, self.ControlledNPC.RangeAttackReps, function()
			//timer.Simple(self.ControlledNPC.TimeUntilRangeAttackProjectileRelease,function()
			if IsValid(self.ControlledNPC) then
			self.ControlledNPC:RangeAttackCode()
			timer.Simple(self.ControlledNPC.NextAnyAttackTime_Range,function()
				if IsValid(self.ControlledNPC) then
				self.PlayingRangeAttackAnimation = false end end)
				end
			end)
			self.ControlledNPC:CustomOnRangeAttack_AfterStartTimer()
		 end
		end
		elseif self.ControlledNPC.DisableWeapons == false then
			self.ControlledNPC:WeaponAimPoseParameters()
			if self.PlayingRangeAttackHumanAnimation == false then
			self.PlayingRangeAttackHumanAnimation = true
			self.ControlledNPC:VJ_ACT_PLAYACTIVITY(VJ_PICKRANDOMTABLE(self.ControlledNPC.AnimTbl_WeaponAttack),false,2,false)
			end
		  end
		 end
		end
		
		if !self.TheController:KeyDown(IN_ATTACK2) then
			if self.ControlledNPC.IsVJBaseSNPC_Human == true && self.ControlledNPC.DisableWeapons == false && !self.ControlledNPC:IsMoving() then
			if self.PlayingRangeAttackHumanAnimation == true then
				self.PlayingRangeAttackHumanAnimation = false
				self.ControlledNPC:VJ_SetSchedule(SCHED_IDLE_STAND)
			end
			if self.PlayingRangeAttackAnimation == true then
				self.PlayingRangeAttackAnimation = false
				self.ControlledNPC:VJ_SetSchedule(SCHED_IDLE_STAND)
			end
		 end
		end

		if self.PlayingAnimation == true then return end
		if self.TheController:KeyDown(IN_RELOAD) then
			if self.ControlledNPC.IsVJBaseSNPC_Human == true && self.ControlledNPC.DisableWeapons == false then
				self.ControlledNPC.HasDoneReloadAnimation = false
				self.PlayingAnimation = true
				//self.ControlledNPC:VJ_SetSchedule(SCHED_RELOAD)
				self.ControlledNPC:VJ_ACT_PLAYACTIVITY(ACT_RELOAD,false,0,false)
				timer.Simple(2,function() if IsValid(self.ControlledNPC) then self.PlayingAnimation = false end end)
			end
		elseif self.TheController:KeyDown(IN_JUMP) then
			if self.ControlledNPC.IsVJBaseSNPC_Human == true then
			if self.VJNPC_HasGrenadeAttack == true && self.PlayingGrenadeAttackAnimation == false then
			if self.ControlledNPC:GetEnemy() == nil then self.TheController:PrintMessage(HUD_PRINTCENTER,"It only can throw grenade if it sees an enemy!") else
			self.ControlledNPC:StopMoving()
			self.PlayingAnimation = true
			self.PlayingGrenadeAttackAnimation = true
			self.CurrentAttackAnimation = VJ_PICKRANDOMTABLE(self.ControlledNPC.AnimTbl_GrenadeAttack)
			self.ControlledNPC:VJ_ACT_PLAYACTIVITY(VJ_PICKRANDOMTABLE(self.ControlledNPC.AnimTbl_GrenadeAttack),false,0,false,self.ControlledNPC.GrenadeAttackAnimationDelay)
			self.ControlledNPC:ThrowGrenadeCode()
			timer.Simple(VJ_GetSequenceDuration(self.ControlledNPC,self.CurrentAttackAnimation) -0.2,function()
				if IsValid(self.ControlledNPC) then
				self.ControlledNPC:VJ_SetSchedule(SCHED_IDLE_STAND)
				end
			end)
			timer.Simple(self.ControlledNPC.TimeUntilGrenadeIsReleased,function()
			if IsValid(self.ControlledNPC) then
			self.PlayingAnimation = false
				timer.Simple(self.ControlledNPC.NextThrowGrenadeTime2,function()
				if IsValid(self.ControlledNPC) then
				self.PlayingGrenadeAttackAnimation = false
				  end
				 end)
				end
			   end)
			  end
			 end
			end
			if self.ControlledNPC.IsVJBaseSNPC_Creature == true then
			if self.VJNPC_HasLeapAttack == true then
			if self.ControlledNPC:GetEnemy() == nil then self.TheController:PrintMessage(HUD_PRINTCENTER,"It can only do leap attack if it sees an enemy!") else
			self.ControlledNPC:StopMoving()
			self.PlayingAnimation = true
			self.PlayingAttackAnimation = true
			self.CurrentAttackAnimation = VJ_PICKRANDOMTABLE(self.ControlledNPC.AnimTbl_LeapAttack)
			self.ControlledNPC:VJ_ACT_PLAYACTIVITY(VJ_PICKRANDOMTABLE(self.ControlledNPC.AnimTbl_LeapAttack),false,0,false,self.ControlledNPC.LeapAttackAnimationDelay)
			self.ControlledNPC:LeapAttackVelocityCode()
			timer.Simple(VJ_GetSequenceDuration(self.ControlledNPC,self.CurrentAttackAnimation) -0.2,function()
				if IsValid(self.ControlledNPC) then
				self.ControlledNPC:VJ_SetSchedule(SCHED_IDLE_STAND)
				end
			end)
			timer.Simple(self.ControlledNPC.TimeUntilLeapAttackDamage,function()
			if IsValid(self.ControlledNPC) then
			self.ControlledNPC:LeapDamageCode()
			timer.Simple(self.ControlledNPC.NextAnyAttackTime_Leap,function()
				if IsValid(self.ControlledNPC) then
				self.PlayingAnimation = false
				self.PlayingAttackAnimation = false
				end
			  end)
			 end
			end)
		   end
		  end
		 end
		end
		
		-- Movement
		if (self.TheController:KeyDown(IN_FORWARD)) then
			self.PlayingAnimation = true
			self.ControlledNPC:SetAngles(Angle(0,math.ApproachAngle(self.ControlledNPC:GetAngles().y,self.TheController:GetAimVector():Angle().y,100),0))
			local plysaimvec = self.ControlledNPC:GetForward() *1 //TheController:GetAimVector()
			plysaimvec.z = 0
			local testcenter = self.ControlledNPC:OBBCenter():Distance(self.ControlledNPC:OBBMins()) + 20
			local npcspos = self.ControlledNPC:GetPos() +Vector(0,0,testcenter) // 35
			local forwardtr = util.TraceLine({start = npcspos, endpos = npcspos +plysaimvec *500, filter = {self, self.ControlledNPC}})
			//print(npcspos:Distance(forwardtr.HitPos))
			local npcvel = self.ControlledNPC:GetGroundSpeedVelocity()
			//if self.ControlledNPC:GetMovementActivity() > 0 then print(self.ControlledNPC:GetSequenceGroundSpeed(self.ControlledNPC:SelectWeightedSequence(self.ControlledNPC:GetMovementActivity()))) end
			//self.ControlledNPC:GetSequenceGroundSpeed(self.ControlledNPC:SelectWeightedSequence(self.ControlledNPC:GetActivity()))
			//Vector(math.abs(npcvel.x),math.abs(npcvel.y),math.abs(npcvel.z))
			local CalculateWallToNPC = npcspos:Distance(forwardtr.HitPos) - 40
			//local CalculateWallToNPC_X = npcspos:Distance(forwardtr.HitPos) - 400
			//local CalculateWallToNPC_Y = npcspos:Distance(forwardtr.HitPos) - 400
			//if math.abs(npcvel.x) > 51 then CalculateWallToNPC_X = math.abs(npcvel.x) end
			//if math.abs(npcvel.y) > 51 then CalculateWallToNPC_Y = math.abs(npcvel.y) end
			if npcspos:Distance(forwardtr.HitPos) >= 51 then
				//print(CalculateWallToNPC)
				local thepos = Vector((self.ControlledNPC:GetPos()+self.ControlledNPC:GetForward()*CalculateWallToNPC).x,(self.ControlledNPC:GetPos()+self.ControlledNPC:GetForward()*CalculateWallToNPC).y,forwardtr.HitPos.z)
				local downtr = util.TraceLine({start = thepos, endpos = thepos + self:GetUp()*-300, filter = {self, self.ControlledNPC}})
				local CalculateDownDistance = thepos.z - downtr.HitPos.z
				//print(CalculateDownDistance)
				if CalculateDownDistance >= 300 then CalculateWallToNPC = CalculateWallToNPC - 300 end
				thepos = Vector((self.ControlledNPC:GetPos()+self.ControlledNPC:GetForward()*CalculateWallToNPC).x,(self.ControlledNPC:GetPos()+self.ControlledNPC:GetForward()*CalculateWallToNPC).y,forwardtr.HitPos.z)
				-- Down Trace
				/*local nig = ents.Create("prop_dynamic") -- Run in Console: lua_run for k,v in ipairs(ents.GetAll()) do if v:GetClass() == "prop_dynamic" then v:Remove() end end
				nig:SetModel("models/hunter/blocks/cube025x025x025.mdl")
				nig:SetPos(downtr.HitPos)
				nig:SetAngles(self:GetAngles())
				nig:SetColor(Color(0,255,0))
				nig:Spawn()
				nig:Activate()
				timer.Simple(3,function() if IsValid(nig) then nig:Remove() end end)*/
				self.ControlledNPC:SetLastPosition(thepos) // self.ControlledNPC:GetPos()+self.ControlledNPC:GetForward()*CalculateWallToNPC
				if (self.TheController:KeyDown(IN_SPEED)) then self.ControlledNPC:VJ_SetSchedule(SCHED_FORCED_GO_RUN) else self.ControlledNPC:VJ_SetSchedule(SCHED_FORCED_GO) end
				-- Final Move Position
				/*local nig = ents.Create("prop_dynamic") -- Run in Console: lua_run for k,v in ipairs(ents.GetAll()) do if v:GetClass() == "prop_dynamic" then v:Remove() end end
				nig:SetModel("models/hunter/blocks/cube025x025x025.mdl")
				nig:SetPos(thepos)
				nig:SetAngles(self:GetAngles())
				nig:SetColor(Color(255,0,0))
				nig:Spawn()
				nig:Activate()
				timer.Simple(3,function() if IsValid(nig) then nig:Remove() end end)*/
			end
			//if self.ControlledNPC:GetPos():Distance(forwardtr.HitPos) >= 298 then
				//self.ControlledNPC:SetLastPosition(self.ControlledNPC:GetPos()+self.ControlledNPC:GetForward()*300)
			//elseif (self.ControlledNPC:GetPos():Distance(forwardtr.HitPos) <= 297 && self.ControlledNPC:GetPos():Distance(forwardtr.HitPos) >= 127) then
				//self.ControlledNPC:SetLastPosition(self.ControlledNPC:GetPos()+self.ControlledNPC:GetForward()*100)
			//elseif (self.ControlledNPC:GetPos():Distance(forwardtr.HitPos) <= 126) then
				//self.ControlledNPC:SetLastPosition(self.ControlledNPC:GetPos()+self.ControlledNPC:GetForward()*40)
			//end
			//if (self.TheController:KeyDown(IN_SPEED)) then self.ControlledNPC:VJ_SetSchedule(SCHED_FORCED_GO_RUN) else self.ControlledNPC:VJ_SetSchedule(SCHED_FORCED_GO) end
			timer.Simple(0.4,function() if IsValid(self.ControlledNPC) then self.PlayingAnimation = false end end)
		elseif (self.TheController:KeyDown(IN_BACK)) then
			self.PlayingAnimation = true
			local PlayersVectorBack = self.TheController:GetAimVector()*-1 -- Since we are going backwards
			PlayersVectorBack.z = 0 -- Make it zero, so you can set your desired number.
			self.ControlledNPC:SetLastPosition(self.ControlledNPC:GetPos()+(PlayersVectorBack*300))
			if (self.TheController:KeyDown(IN_SPEED)) then self.ControlledNPC:VJ_SetSchedule(SCHED_FORCED_GO_RUN) else self.ControlledNPC:VJ_SetSchedule(SCHED_FORCED_GO) end
			timer.Simple(0.3,function() if IsValid(self.ControlledNPC) then self.PlayingAnimation = false end end)
		elseif (self.TheController:KeyDown(IN_MOVELEFT)) then
			self.PlayingAnimation = true
			//self.ControlledNPC:SetAngles(Angle(0,1,0))
			self.ControlledNPC:SetLastPosition(self.ControlledNPC:GetPos()+(self.TheController:GetRight()*-300))
			self.ControlledNPC:VJ_SetSchedule(SCHED_FORCED_GO)
			timer.Simple(0.3,function() if IsValid(self.ControlledNPC) then self.PlayingAnimation = false end end)
		elseif (self.TheController:KeyDown(IN_MOVERIGHT)) then
			self.PlayingAnimation = true
			self.ControlledNPC:SetLastPosition(self.ControlledNPC:GetPos()+(self.TheController:GetRight()*300))
			self.ControlledNPC:VJ_SetSchedule(SCHED_FORCED_GO)
			timer.Simple(0.3,function() if IsValid(self.ControlledNPC) then self.PlayingAnimation = false end end)
		elseif (!self.TheController:KeyDown(IN_SPEED) && !self.TheController:KeyDown(IN_MOVERIGHT) && !self.TheController:KeyDown(IN_MOVELEFT) && !self.TheController:KeyDown(IN_BACK) && !self.TheController:KeyDown(IN_FORWARD)) then
			self.ControlledNPC:StopMoving()
		end
		if (self.TheController:KeyDown(IN_USE)) then
			self.ControlledNPC:StopMoving()
			self:StopControlling()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StopControlling()
	//if !IsValid(self.TheController) then return self:Remove() end
	self:CustomOnStopControlling()
	
	if IsValid(self.TheController) then
		local playerpos = self.TheController:GetPos()
		self.TheController:UnSpectate()
		self.TheController:KillSilent() -- If we don't, we will get bugs like no being able to pick up weapons when walking over them.
		self.TheController:Spawn()
		if IsValid(self.PropCamera) then
		self.TheController:SetPos(self.PropCamera:GetPos() +self.PropCamera:GetUp()*100) else
		self.TheController:SetPos(playerpos) end
		for k, v in pairs(self.ControllerCurrentWeapons) do
		self.TheController:Give(v) end
		if (self.ControllerActiveWeapon) then self.TheController:SelectWeapon(self.ControllerActiveWeapon) end
		self.TheController:SetNoDraw(false)
		self.TheController:DrawShadow(true)
		self.TheController:SetNoTarget(false)
		//self.TheController:Spectate(OBS_MODE_NONE)
		self.TheController:DrawViewModel(true)
		self.TheController:DrawWorldModel(true)
		//self.TheController:SetMoveType(MOVETYPE_WALK)
		self.TheController:SetHealth(self.ControllerHealth)
		self.TheController:SetArmor(self.ControllerArmor)
		self.TheController.IsControlingNPC = false
	end
	self.TheController = NULL
	
	if IsValid(self.ControlledNPC) then
		//self.ControlledNPC:StopMoving()
		self.ControlledNPC.VJ_IsBeingControlled = false
		self.ControlledNPC.VJ_TheController = NULL
		self.ControlledNPC.VJ_TheControllerEntity = NULL
		//self.ControlledNPC:ClearSchedule()
		if self.ControlledNPC.IsVJBaseSNPC == true then
			self.ControlledNPC.DisableWandering = self.VJNPC_DisableWandering
			self.ControlledNPC.DisableChasingEnemy = self.VJNPC_DisableChasingEnemy
			//self.ControlledNPC.DisableFindEnemy = self.VJNPC_DisableFindEnemy
			self.ControlledNPC.DisableTakeDamageFindEnemy = self.VJNPC_DisableTakeDamageFindEnemy
			self.ControlledNPC.DisableTouchFindEnemy = self.VJNPC_DisableTouchFindEnemy
			self.ControlledNPC.DisableSelectSchedule = self.VJNPC_DisableSelectSchedule
			self.ControlledNPC.HasMeleeAttack = self.VJNPC_HasMeleeAttack
			self.ControlledNPC.HasRangeAttack = self.VJNPC_HasRangeAttack
			self.ControlledNPC.HasLeapAttack = self.VJNPC_HasLeapAttack
			self.ControlledNPC.CallForHelp = self.VJNPC_CallForHelp
			self.ControlledNPC.CallForBackUpOnDamage = self.VJNPC_CallForBackUpOnDamage
			self.ControlledNPC.FollowPlayer = self.VJNPC_FollowPlayer
			self.ControlledNPC.BringFriendsOnDeath = self.VJNPC_BringFriendsOnDeath
			self.ControlledNPC.CanDetectGrenades = self.VJNPC_RunsAwayFromGrenades
			self.ControlledNPC.RunOnTouch = self.VJNPC_RunOnTouch
			self.ControlledNPC.RunOnHit = self.VJNPC_RunOnHit
			if self.ControlledNPC.IsVJBaseSNPC_Human == true then
				if self.ControlledNPC.DisableWeapons == false then 
					self.ControlledNPC:CapabilitiesAdd(bit.bor(CAP_MOVE_SHOOT))
					self.ControlledNPC:CapabilitiesAdd(bit.bor(CAP_AIM_GUN))
				end
			end
		end
	end
	//self.PropCamera:Remove()
	self.VJControllerEntityIsRemoved = true
	self:Remove()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	self:CustomOnRemove()
	if self.VJControllerEntityIsRemoved == false then
		self:StopControlling()
	end
end
/*--------------------------------------------------
	=============== NPC Controler Base ===============
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to controll NPCs. Mainly for VJ Base SNPCs.
--------------------------------------------------*/