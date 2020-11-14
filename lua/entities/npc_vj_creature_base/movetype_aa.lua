/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
---------------------------------------------------------------------------------------------------------------------------------------------
-- AERIAL & AQUATIC BASE --
// MOVETYPE_FLY | MOVETYPE_FLYGRAVITY
ENT.CurrentAnim_AAMovement = nil
ENT.AA_NextMovementAnimation = 0
ENT.AA_CanPlayMoveAnimation = false
ENT.AA_CurrentMoveAnimationType = "Calm"
ENT.AA_MoveLength_Wander = 0
ENT.AA_MoveLength_Chase = 0
//ENT.AA_TargetPos = Vector(0,0,0)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AAMove_Animation()
	if self:GetSequence() != self.CurrentAnim_AAMovement && self:BusyWithActivity() == false /*&& self:GetActivity() == ACT_IDLE*/ && CurTime() > self.AA_NextMovementAnimation then
		local animtbl = {}
		if self.AA_CurrentMoveAnimationType == "Calm" then
			if self.MovementType == VJ_MOVETYPE_AQUATIC then
				animtbl = self.Aquatic_AnimTbl_Calm
			else
				animtbl = self.Aerial_AnimTbl_Calm
			end
		elseif self.AA_CurrentMoveAnimationType == "Alert" then
			if self.MovementType == VJ_MOVETYPE_AQUATIC then
				animtbl = self.Aquatic_AnimTbl_Alerted
			else
				animtbl = self.Aerial_AnimTbl_Alerted
			end
		end
		local pickedanim = VJ_PICK(animtbl)
		if type(pickedanim) == "number" then pickedanim = self:GetSequenceName(self:SelectWeightedSequence(pickedanim)) end
		local idleanimid = VJ_GetSequenceName(self,pickedanim)
		self.CurrentAnim_AAMovement = idleanimid
		//self:AddGestureSequence(idleanimid)
		self:VJ_ACT_PLAYACTIVITY(pickedanim, false, 0, false, 0, {AlwaysUseSequence=true, SequenceDuration=false, SequenceInterruptible=true})
		self.AA_NextMovementAnimation = CurTime() + self:DecideAnimationLength(self.CurrentAnim_AAMovement, false)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AAMove_Stop()
	if self.MovementType != VJ_MOVETYPE_AERIAL && self.MovementType != VJ_MOVETYPE_AQUATIC then return end
	if self:GetVelocity():Length() > 0 then
		self:SetLocalVelocity(Vector(0,0,0))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AAMove_Wander(playAnim, NoFace)
	local calmspeed = self.Aerial_FlyingSpeed_Calm
	local ForceDown = ForceDown or false
	if self.MovementType == VJ_MOVETYPE_AQUATIC then
		if self:WaterLevel() < 3 then
			self:AAMove_Stop()
			ForceDown = true
			if self:WaterLevel() == 0 then
				return
			end
		end
		calmspeed = self.Aquatic_SwimmingSpeed_Calm
	end
	
	local Debug = self.AA_EnableDebug
	playAnim = playAnim or false
	NoFace = NoFace or false

	if playAnim == true then
		self.AA_CanPlayMoveAnimation = true
		self.AA_CurrentMoveAnimationType = "Calm"
	else
		self.AA_CanPlayMoveAnimation = false
	end
	//if NoFace == false then self:SetLocalAngularVelocity(Angle(0,math.random(0,360),0)) end
	local x_neg = 1
	local y_neg = 1
	local z_neg = 1
	if math.random(1,2) == 1 then x_neg = -1 end
	if math.random(1,2) == 1 then y_neg = -1 end
	if math.random(1,2) == 1 then z_neg = -1 end
	local tr_startpos = self:GetPos()
	local tr_endpos = tr_startpos + self:GetForward()*((self:OBBMaxs().x + math.random(100,200))*x_neg) + self:GetRight()*((self:OBBMaxs().y + math.random(100,200))*y_neg) + self:GetUp()*((self:OBBMaxs().z + math.random(100,200))*z_neg)
	if ForceDown == true then
		tr_endpos = tr_startpos + self:GetUp()*((self:OBBMaxs().z + math.random(100,150))*-1)
	end
	/*local tr_for = math.random(-300,300)
	local tr_up = math.random(-300,300)
	local tr_right = math.random(-300,300)
	local tr = util.TraceLine({start = tr_startpos, endpos = tr_startpos+self:GetForward()*tr_for+self:GetRight()*tr_up+self:GetUp()*tr_right, filter = self})*/
	local tr = util.TraceLine({start = tr_startpos, endpos = tr_endpos, filter = self})
	local finalpos = tr.HitPos
	//PrintTable(tr)
	if ForceDown == false && self.MovementType == VJ_MOVETYPE_AERIAL then -- Yete ches estibergor vor var yerta YEV loghatsough SNPC che, sharnage...
		local tr_check = util.TraceLine({start = finalpos, endpos = finalpos + Vector(0,0,-100), filter = self})
		if tr_check.HitWorld == true then -- Yete askharin zargav, ere vor shad var chishne
			finalpos = finalpos + self:GetUp()*(100 - tr_check.HitPos:Distance(finalpos))
		end
	end
	//self.AA_TargetPos = finalpos
	
	-- Angle time test (PHYSICS)
	/*local test1 = math.AngleDifference(tr.StartPos:Angle().y, self:VJ_ReturnAngle((finalpos-tr.StartPos):Angle()).y)
	local test2 = (math.rad(test1) / math.rad(self:VJ_ReturnAngle((finalpos-tr.StartPos):Angle()).y)) * 20
	self.yep = CurTime() + math.abs(test2)
	self.yep2 = self:VJ_ReturnAngle((finalpos-tr.StartPos):Angle())*/
	
	if NoFace == false then self.AA_CurrentTurnAng = self:VJ_ReturnAngle((finalpos-tr.StartPos):Angle()) end //self:SetLocalAngularVelocity(self:VJ_ReturnAngle((finalpos-tr.StartPos):Angle())) end
	if Debug == true then
		VJ_CreateTestObject(finalpos, self:GetAngles(), Color(0,255,255), 5)
		util.ParticleTracerEx("Weapon_Combine_Ion_Cannon_Beam", tr.StartPos, finalpos, false, self:EntIndex(), 0)
	end

	-- Set the velocity
	//local myvel = self:GetVelocity()
	local vel_set = (finalpos-self:GetPos()):GetNormal()*calmspeed
	local vel_len = CurTime() + (finalpos:Distance(tr_startpos) / vel_set:Length())
	self.AA_MoveLength_Chase = 0
	if vel_len == vel_len then -- Check for NaN
		self.AA_MoveLength_Wander = vel_len
		self.NextIdleTime = vel_len
	end
	self:SetLocalVelocity(vel_set)
	if Debug == true then ParticleEffect("vj_impact1_centaurspit", finalpos, Angle(0,0,0), self) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AAMove_ChaseEnemy(playAnim, moveType)
	if self.Dead == true or (self.NextChaseTime > CurTime()) or !IsValid(self:GetEnemy()) then return end
	self:AAMove_MoveToPos(self:GetEnemy(), playAnim or false, moveType or "Alert", {ChaseEnemy=true})
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AAMove_MoveToPos(Ent, playAnim, moveType, vAdditionalFeatures)
	if self.Dead == true or !IsValid(Ent) then return end
	playAnim = playAnim or false
	moveType = moveType or "Calm" -- "Calm" | "Alert"
	vAd_AdditionalFeatures = vAdditionalFeatures or {}
		vAd_ChaseEnemy = vAd_AdditionalFeatures.ChaseEnemy or false -- Used internally by ChaseEnemy, enables code that's used only for that
		vAd_PosForward = vAd_AdditionalFeatures.PosForward or 1 -- This will add the given value to the set position's forward
		vAd_PosUp = vAd_AdditionalFeatures.PosUp or 1 -- This will add the given value to the set position's up
		vAd_PosRight = vAd_AdditionalFeatures.PosRight or 1 -- This will add the given value to the set position's right
	local MoveSpeed = (moveType == "Calm" and self.Aerial_FlyingSpeed_Calm) or self.Aerial_FlyingSpeed_Alerted
	local Debug = self.AA_EnableDebug
	if self.MovementType == VJ_MOVETYPE_AQUATIC then
		MoveSpeed = (moveType == "Calm" and self.Aquatic_SwimmingSpeed_Calm) or self.Aquatic_SwimmingSpeed_Alerted
		if Debug == true then
			print("----------------")
			print("My WaterLevel: "..self:WaterLevel())
			print("Ent WaterLevel: "..Ent:WaterLevel())
		end
		-- Yete chouri e YEV leman marmine chourin mech-e che, ere vor gena yev kharen kal e
		if self:WaterLevel() <= 2 && self:GetVelocity():Length() > 0 then return end
		if self:WaterLevel() <= 1 && self:GetVelocity():Length() > 0 then self:AAMove_Wander(true,true) return end
		if Ent:WaterLevel() == 0 then self:DoIdleAnimation(1) return end -- Yete teshnamin chouren tours e, getsour
		if Ent:WaterLevel() <= 1 then -- Yete 0-en ver e, ere vor nayi yete gerna teshanmi-in gerna hasnil
			local trene = util.TraceLine({
				start = Ent:GetPos() + self:OBBCenter(),
				endpos = (Ent:GetPos() + self:OBBCenter()) + Ent:GetUp()*-20,
				filter = self,
				mins = self:OBBMins(),
				maxs = self:OBBMaxs()
			})
			//PrintTable(trene)
			//VJ_CreateTestObject(trene.HitPos,self:GetAngles(),Color(0,255,0),5)
			if trene.Hit == true then return end
		end
	end
	
	if vAd_ChaseEnemy == true then
		self:FaceCertainEntity(Ent, true)
	end
	
	if playAnim == true then
		self.AA_CanPlayMoveAnimation = true
		self.AA_CurrentMoveAnimationType = moveType
	else
		self.AA_CanPlayMoveAnimation = false
	end
	
	-- Main Calculations
	local vel_for = 1
	local vel_stop = false
	local nearpos = self:VJ_GetNearestPointToEntity(Ent)
	local startpos = nearpos.MyPosition // self:GetPos()
	local endpos = nearpos.EnemyPosition // Ent:GetPos()+Ent:OBBCenter()
	local tr = util.TraceHull({
		start = startpos,
		endpos = endpos,
		filter = self,
		mins = self:OBBMins(),
		maxs = self:OBBMaxs()
	})
	local tr_hitpos = tr.HitPos
	local dist_selfhit = startpos:Distance(tr_hitpos)
	if Debug == true then util.ParticleTracerEx("Weapon_Combine_Ion_Cannon_Beam",tr.StartPos,tr_hitpos,false,self:EntIndex(),0) end //vortigaunt_beam
	if dist_selfhit <= 16 && tr.HitWorld == true then
		if Debug == true then print("AA: Forward Blocked! [CHASE]") end
		vel_for = 1
		//vel_for = -200
		//vel_stop = true
	end
	local enepos = (Ent:GetPos() + Ent:OBBCenter()) + Ent:GetForward()*vAd_PosForward + Ent:GetUp()*vAd_PosUp + Ent:GetRight()*vAd_PosRight
	-- If the enemy is a bit above water, try to go for its GetPos, which is usually at its feet
	if self.MovementType == VJ_MOVETYPE_AQUATIC && Ent:WaterLevel() < 3 then
		enepos = Ent:GetPos() + Ent:GetForward()*vAd_PosForward + Ent:GetUp()*vAd_PosUp + Ent:GetRight()*vAd_PosRight
	end
	
	-- X Calculations
		-- Coming soon!
	
	-- Z Calculations
	local vel_up = MoveSpeed
	local dist_selfhit_z = enepos.z - startpos.z -- Get the distance between the hit position and the start position
	if dist_selfhit_z > 0 then -- Yete 0-en ver e, ere vor 20-en minchev sahmani tive hasni
		if Debug == true then print("AA: GOING UP [CHASE]") end
		vel_up = math.Clamp(dist_selfhit_z, 20, MoveSpeed)
	elseif dist_selfhit_z < 0 then -- Yete 0-en var e, ere vor nevaz 20-en minchev nevaz sahmani tive hasni
		if Debug == true then print("AA: GOING DOWN [CHASE]") end
		vel_up = -math.Clamp(math.abs(dist_selfhit_z), 20, MoveSpeed)
	else
		vel_up = 0
	end
	
	-- Make it slow down when the approaching the position
	//if dist_selfhit < 100 then
		//MoveSpeed = math.Clamp(dist_selfhit, 100, MoveSpeed)
	//end
	
	-- Deprecated z-calculation code
	/*
	local getenemyz = "None"
	local z_self = (self:GetPos()+self:OBBCenter()).z
	local tr_up_startpos = self:GetPos()+self:OBBCenter()
	//local tr_up = util.TraceLine({start = tr_up_startpos,endpos = self:GetPos()+self:OBBCenter()+self:GetUp()*300,filter = self})
	local tr_down_startpos = self:GetPos()+self:OBBCenter()
	local tr_down = util.TraceLine({start = tr_up_startpos,endpos = self:GetPos()+self:OBBCenter()+self:GetUp()*-300,filter = self})
	//print("UP - ",tr_up_startpos:Distance(tr_up.HitPos))*/
	/*if enepos.z >= z_self then
		if math.abs(enepos.z - z_self) >= 10 then
			if Debug == true then print("AA: UP [CHASE]") end
			getenemyz = "Up"
			//vel_up = 100
		end
	elseif enepos.z <= z_self then
		if math.abs(z_self - enepos.z) >= 10 then
			if Debug == true then print("AA: DOWN [CHASE]") end
			getenemyz = "Down"
			//vel_up = -MoveSpeed
		end
	end*/
	/*if getenemyz == "Up" && tr_down_startpos:Distance(tr_down.HitPos) >= 100 then
		if Debug == true then print("AA: GOING UP [CHASE]") end
		vel_up = MoveSpeed //100
	elseif getenemyz == "Up" && tr_down_startpos:Distance(tr_down.HitPos) >= 100 then
		if Debug == true then print("AA: GOING DOWN [CHASE]") end
		vel_up = -MoveSpeed //-100
	end
	*/
	
	-- Other old code
	/*if tr_up_startpos:Distance(tr_up.HitPos) <= 100 && tr_down_startpos:Distance(tr_down.HitPos) >= 100 then
		print("DOWN - ",tr_up_startpos:Distance(tr_up.HitPos))
		vel_up = -100
	end*/

	-- Set the velocity
	if vel_stop == false then
		if vAd_ChaseEnemy == true then vel_up = vel_up + 30 end -- To make it not the hug the ground when chasing a humanoid
		local vel_set = (enepos - (self:GetPos() + self:OBBCenter())):GetNormal()*MoveSpeed + self:GetUp()*vel_up + self:GetForward()*vel_for
		//local vel_set_yaw = vel_set:Angle().y
		if vAd_ChaseEnemy == true then
			self.AA_CurrentTurnAng = false
		else
			self.AA_CurrentTurnAng = self:VJ_ReturnAngle(self:VJ_ReturnAngle((vel_set):Angle()))
		end
		//self:SetAngles(self:VJ_ReturnAngle((vel_set):Angle()))
		self:SetLocalVelocity(vel_set)
		if vAd_ChaseEnemy == true then
			vel_len = CurTime() + (dist_selfhit / vel_set:Length())
		else
			vel_len = CurTime() + (tr.HitPos:Distance(startpos) / vel_set:Length())
		end
		self.AA_MoveLength_Wander = 0
		if vel_len == vel_len then -- Check for NaN
			self.AA_MoveLength_Chase = vel_len
			self.NextIdleTime = vel_len
		end
		if Debug == true then ParticleEffect("vj_impact1_centaurspit", enepos, Angle(0,0,0), self) end
	else
		self:AAMove_Stop()
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/