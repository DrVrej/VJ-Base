AddCSLuaFile("shared.lua")
include('shared.lua')
/*--------------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
ENT.VJC_Player_CanExit = true -- Can the player exit the controller?
ENT.VJC_Player_CanRespawn = true -- If false, the player will die when the NPC dies!
ENT.VJC_Player_DrawHUD = true -- Should the controller HUD be displayed?
ENT.VJC_BullseyeTracking = false -- Activates bullseye tracking (Will not turn to the move location!)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Customization Functions ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Use the functions below to customize certain parts of the base or to add new custom systems
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnSetControlledNPC() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink() end
---------------------------------------------------------------------------------------------------------------------------------------------
-- Different from self:CustomOnKeyBindPressed(), this uses: https://wiki.facepunch.com/gmod/Enums/KEY
function ENT:CustomOnKeyPressed(key) end
---------------------------------------------------------------------------------------------------------------------------------------------
-- Different from self:CustomOnKeyPressed(), this uses: https://wiki.facepunch.com/gmod/Enums/IN
function ENT:CustomOnKeyBindPressed(key) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnStopControlling() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove() end
---------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ ///// WARNING: Don't touch anything below this line! \\\\\ ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJC_Data_Player = nil -- A hash table to hold all the values that need to be reset after the player stops controlling
ENT.VJC_Data_NPC = nil -- A hash table to hold all the values that need to be reset after the NPC is uncontrolled
ENT.VJC_Camera_Mode = 1 -- Current camera mode | 1 = Third, 2 = First
ENT.VJC_Camera_CurZoom = Vector(0, 0, 0)
ENT.VJC_Key_Last = BUTTON_CODE_NONE -- The last button the user pressed
ENT.VJC_Key_LastTime = 0 -- Time since the user last pressed a key
ENT.VJC_NPC_LastPos = Vector(0, 0, 0)
ENT.VJC_NPC_LastIdleAngle = 0
ENT.VJC_Removed = false

/* Important entities:
	- self.VJCE_Camera		The camera object
	- self.VJCE_Player		The player that's controlling
	- self.VJCE_Bullseye	The bullseye entity used for the NPC to target
	- self.VJCE_NPC			The NPC that's being controlled
*/

if SERVER then
	util.AddNetworkString("vj_controller_data")
	util.AddNetworkString("vj_controller_cldata")
	util.AddNetworkString("vj_controller_hud")
end

local vecDef = Vector(0, 0, 0)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
	self:CustomOnInitialize()
end
---------------------------------------------------------------------------------------------------------------------------------------------
local color0000 = Color(0, 0, 0, 0)
--
function ENT:StartControlling()
	-- Set up the camera entity
	local npc = self.VJCE_NPC
	local camEnt = ents.Create("prop_dynamic")
	camEnt:SetPos(npc:GetPos() + Vector(0, 0, npc:OBBMaxs().z)) //npc:EyePos()
	camEnt:SetModel("models/props_junk/watermelon01_chunk02c.mdl")
	camEnt:SetParent(npc)
	camEnt:SetRenderMode(RENDERMODE_NONE)
	camEnt:Spawn()
	camEnt:SetColor(color0000)
	camEnt:SetNoDraw(false)
	camEnt:DrawShadow(false)
	self:DeleteOnRemove(camEnt)
	self.VJCE_Camera = camEnt
	
	-- Set up the player
	local plyEnt = self.VJCE_Player
	plyEnt.IsControlingNPC = true
	plyEnt.VJ_TheControllerEntity = self
	plyEnt:Spectate(OBS_MODE_CHASE)
	plyEnt:SpectateEntity(camEnt)
	plyEnt:SetNoTarget(true)
	plyEnt:DrawShadow(false)
	plyEnt:SetNoDraw(true)
	plyEnt:SetMoveType(MOVETYPE_OBSERVER)
	plyEnt:DrawViewModel(false)
	plyEnt:DrawWorldModel(false)
	local weps = {}
	for _, v in pairs(plyEnt:GetWeapons()) do
		weps[#weps+1] = v:GetClass()
	end
	self.VJC_Data_Player = {
		[1] = plyEnt:Health(),
		[2] = plyEnt:Armor(),
		[3] = weps,
		[4] = (IsValid(plyEnt:GetActiveWeapon()) and plyEnt:GetActiveWeapon():GetClass()) or "",
	}
	plyEnt:StripWeapons()
	if plyEnt:GetInfoNum("vj_npc_cont_diewithnpc", 0) == 1 then self.VJC_Player_CanRespawn = false end

	hook.Add("PlayerButtonDown", self, function(self, ply, button)
		if ply.IsControlingNPC == true && IsValid(ply.VJ_TheControllerEntity) then
			local cent = ply.VJ_TheControllerEntity
			cent.VJC_Key_Last = button
			cent.VJC_Key_LastTime = CurTime()
			cent:CustomOnKeyPressed(button)
			
			-- Stop Controlling
			if cent.VJC_Player_CanExit == true and button == KEY_END then
				cent:StopControlling(true)
			end
			
			-- Tracking
			if button == KEY_T then
				cent:ToggleBullseyeTracking()
			end
			
			-- Camera mode
			if button == KEY_H then
				cent.VJC_Camera_Mode = (cent.VJC_Camera_Mode == 1 and 2) or 1
			end
			
			-- Allow movement jumping
			if button == KEY_J then
				cent:ToggleMovementJumping()
			end
			
			-- Zoom
			local zoom = ply:GetInfoNum("vj_npc_cont_zoomdist", 5)
			if button == KEY_LEFT then
				cent.VJC_Camera_CurZoom = cent.VJC_Camera_CurZoom - Vector(0, zoom, 0)
			elseif button == KEY_RIGHT then
				cent.VJC_Camera_CurZoom = cent.VJC_Camera_CurZoom + Vector(0, zoom, 0)
			elseif button == KEY_UP then
				cent.VJC_Camera_CurZoom = cent.VJC_Camera_CurZoom + (ply:KeyDown(IN_SPEED) and Vector(0, 0, zoom) or Vector(zoom, 0, 0))
			elseif button == KEY_DOWN then
				cent.VJC_Camera_CurZoom = cent.VJC_Camera_CurZoom - (ply:KeyDown(IN_SPEED) and Vector(0, 0, zoom) or Vector(zoom, 0, 0))
			end
			if button == KEY_BACKSPACE then
				cent.VJC_Camera_CurZoom = vecDef
			end
		end
	end)

	hook.Add("KeyPress", self, function(self, ply, key)
		//print(key)
		if ply.IsControlingNPC == true && IsValid(ply.VJ_TheControllerEntity) then
			local cent = ply.VJ_TheControllerEntity
			cent:CustomOnKeyBindPressed(key)
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetControlledNPC(GetEntity)
	-- Set the bullseye entity values

	local bullseyeEnt = ents.Create("obj_vj_bullseye")
	bullseyeEnt:SetPos(GetEntity:GetPos() + GetEntity:GetForward()*100 + GetEntity:GetUp()*50)//Vector(GetEntity:OBBMaxs().x +20,0,GetEntity:OBBMaxs().z +20))
	bullseyeEnt:SetModel("models/hunter/blocks/cube025x025x025.mdl")
	//bullseyeEnt:SetParent(GetEntity)
	bullseyeEnt:SetRenderMode(RENDERMODE_NONE)
	bullseyeEnt:Spawn()
	bullseyeEnt:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	bullseyeEnt.VJ_AlwaysEnemyToEnt = GetEntity
	bullseyeEnt:SetColor(color0000)
	bullseyeEnt:SetNoDraw(false)
	bullseyeEnt:DrawShadow(false)
	self:DeleteOnRemove(bullseyeEnt)
	self.VJCE_Bullseye = bullseyeEnt

	-- Set the NPC values
	if !GetEntity.VJC_Data then
		GetEntity.VJC_Data ={
			CameraMode = 1, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
			ThirdP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in third person
			FirstP_Bone = "ValveBiped.Bip01_Head1", -- If left empty, the base will attempt to calculate a position for first person
			FirstP_Offset = Vector(0, 0, 5), -- The offset for the controller when the camera is in first person
			FirstP_ShrinkBone = true, -- Should the bone shrink? Useful if the bone is obscuring the player's view
		}
	end
	local plyEnt = self.VJCE_Player
	self.VJC_Camera_Mode = GetEntity.VJC_Data.CameraMode -- Get the NPC's default camera mode
	self.VJC_NPC_LastPos = GetEntity:GetPos()
	GetEntity.VJ_IsBeingControlled = true
	GetEntity.VJ_TheController = plyEnt
	GetEntity.VJ_TheControllerEntity = self
	GetEntity.VJ_TheControllerBullseye = bullseyeEnt
	GetEntity:SetEnemy(NULL)
	GetEntity:VJ_Controller_InitialMessage(plyEnt, self)
	if GetEntity.IsVJBaseSNPC == true then
		GetEntity:Controller_Initialize(plyEnt, self)
		local EntityEnemy = GetEntity:GetEnemy()
		if IsValid(EntityEnemy) then
			GetEntity:AddEntityRelationship(EntityEnemy, D_NU, 99)
			EntityEnemy:AddEntityRelationship(GetEntity, D_NU, 99)
			GetEntity:ResetEnemy(false)
			GetEntity:SetEnemy(bullseyeEnt)
		end
		self.VJC_Data_NPC = {
			[1] = GetEntity.DisableWandering,
			[2] = GetEntity.DisableChasingEnemy,
			[3] = GetEntity.DisableTakeDamageFindEnemy,
			[4] = GetEntity.DisableTouchFindEnemy,
			[5] = GetEntity.DisableSelectSchedule,
			[6] = GetEntity.CallForHelp,
			[7] = GetEntity.CallForBackUpOnDamage,
			[8] = GetEntity.BringFriendsOnDeath,
			[9] = GetEntity.FollowPlayer,
			[10] = GetEntity.CanDetectDangers,
			[11] = GetEntity.Passive_RunOnTouch,
			[12] = GetEntity.Passive_RunOnDamage,
			[13] = GetEntity.IsGuard,
		}
		GetEntity.DisableWandering = true
		GetEntity.DisableChasingEnemy = true
		GetEntity.DisableTakeDamageFindEnemy = true
		GetEntity.DisableTouchFindEnemy = true
		GetEntity.DisableSelectSchedule = true
		GetEntity.CallForHelp = false
		GetEntity.CallForBackUpOnDamage = false
		GetEntity.BringFriendsOnDeath = false
		GetEntity.FollowPlayer = false
		GetEntity.CanDetectDangers = false
		GetEntity.Passive_RunOnTouch = false
		GetEntity.Passive_RunOnDamage = false
		GetEntity.IsGuard = false
		
		GetEntity.vACT_StopAttacks = true
		GetEntity.NextThrowGrenadeT = 0
	end
	GetEntity:ClearSchedule()
	GetEntity:StopMoving()
	self.VJCE_NPC = GetEntity
	timer.Simple(0, function() -- This only needs to be 0 seconds because we just need a tick to pass
		if IsValid(self) && IsValid(self.VJCE_NPC) then
			self.VJCE_NPC.vACT_StopAttacks = false
			self.VJCE_NPC:SetEnemy(self.VJCE_Bullseye)
		end
	end)
	self:CustomOnSetControlledNPC()
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- Sadly no other way, this is the most reliable way to sync the position from client to server in time
	-- Also avoids garbage positions that output from other methods
net.Receive("vj_controller_cldata", function(len, ply)
	-- Set the controller's bullseye position if the player is controlling an NPC AND controller entity exists AND Bullseye exists --> Protect against spam ?
	if ply.IsControlingNPC == true && IsValid(ply.VJ_TheControllerEntity) && IsValid(ply.VJ_TheControllerEntity.VJCE_Bullseye) then
		ply.VJ_TheControllerEntity.VJCE_Bullseye:SetPos(net.ReadVector())
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SendDataToClient(reset)
	local ply = self.VJCE_Player
	local npc = self.VJCE_NPC
	local npcData = npc.VJC_Data

	net.Start("vj_controller_data")
		net.WriteBool(ply.IsControlingNPC)
		net.WriteUInt((reset == true and nil) or self.VJCE_Camera:EntIndex(), 14)
		net.WriteUInt((reset == true and nil) or npc:EntIndex(), 14)
		net.WriteUInt((reset == true and 1) or self.VJC_Camera_Mode, 2)
		net.WriteVector((reset == true and vecDef) or (npcData.ThirdP_Offset + self.VJC_Camera_CurZoom))
		net.WriteVector((reset == true and vecDef) or npcData.FirstP_Offset)
		local bone = -1
		if reset != true then
			bone = npc:LookupBone(npcData.FirstP_Bone) or -1
		end
		net.WriteInt(bone, 10)
		net.WriteBool((reset != true and npcData.FirstP_ShrinkBone) or false)
		net.WriteUInt((reset != true and npcData.FirstP_CameraBoneAng) or 0, 2)
		net.WriteInt((reset != true and npcData.FirstP_CameraBoneAng_Offset) or 0, 10)
	net.Send(ply)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vecZ20 = Vector(0, 0, 20)
local curTime = CurTime()
local defAttackTypes = {MeleeAttack=false, RangeAttack=false, LeapAttack=false, WeaponAttack=false, GrenadeAttack=false, Ammo="---"}
--
function ENT:Think()
	local ply = self.VJCE_Player
	local npc = self.VJCE_NPC
	local camera = self.VJCE_Camera
	if (!camera:IsValid()) then self:StopControlling() return end
	if !IsValid(ply) /*or ply:KeyDown(IN_USE)*/ or ply:Health() <= 0 or (!ply.IsControlingNPC) or !IsValid(npc) or (npc:Health() <= 0) then self:StopControlling() return end
	if ply.IsControlingNPC != true then return end
	if ply.IsControlingNPC && IsValid(npc) then
		local npcWeapon = npc:GetActiveWeapon()
		self.VJC_NPC_LastPos = npc:GetPos()
		ply:SetPos(self.VJC_NPC_LastPos + vecZ20) -- Set the player's location
		self:SendDataToClient()
		
		-- HUD
		local AttackTypes = defAttackTypes -- Optimization?
		if npc.IsVJBaseSNPC == true then
			if npc.HasMeleeAttack == true then AttackTypes["MeleeAttack"] = ((npc.IsAbleToMeleeAttack != true or npc.AttackType == VJ_ATTACK_MELEE) and 2) or true end
			if npc.HasRangeAttack == true then AttackTypes["RangeAttack"] = ((npc.IsAbleToRangeAttack != true or npc.AttackType == VJ_ATTACK_RANGE) and 2) or true end
			if npc.HasLeapAttack == true then AttackTypes["LeapAttack"] = ((npc.IsAbleToLeapAttack != true or npc.AttackType == VJ_ATTACK_LEAP) and 2) or true end
			if IsValid(npcWeapon) then AttackTypes["WeaponAttack"] = true AttackTypes["Ammo"] = npcWeapon:Clip1() end
			if npc.HasGrenadeAttack == true then AttackTypes["GrenadeAttack"] = (CurTime() <= npc.NextThrowGrenadeT and 2) or true end
		end
		if self.VJC_Player_DrawHUD then
			net.Start("vj_controller_hud")
				net.WriteBool(ply:GetInfoNum("vj_npc_cont_hud", 1) == 1)
				net.WriteFloat(npc:GetMaxHealth())
				net.WriteFloat(npc:Health())
				net.WriteString(npc:GetName())
				net.WriteTable(AttackTypes)
			net.Send(ply)
		end
		
		if #ply:GetWeapons() > 0 then ply:StripWeapons() end
		-- Depreciated, the hit position is now sent by the net message
		/*local tr_ply = util.TraceLine({start = ply:EyePos(), endpos = ply:EyePos() + (ply:GetAimVector() * 32768), filter = {ply,npc}})
		if IsValid(self.VJCE_Bullseye) then
			self.VJCE_Bullseye:SetPos(tr_ply.HitPos)
		end*/
		local pos_beye = self.VJCE_Bullseye:GetPos()
		if ply:GetInfoNum("vj_npc_cont_devents", 0) == 1 then
			VJ_CreateTestObject(ply:GetPos(), self:GetAngles(), Color(0,109,160))
			VJ_CreateTestObject(camera:GetPos(), self:GetAngles(), Color(255,200,260))
			VJ_CreateTestObject(pos_beye, self:GetAngles(), Color(255,0,0)) -- Bullseye's position
		end
		
		self:CustomOnThink()

		local canTurn = true

		-- Weapon attack
		if npc.IsVJBaseSNPC_Human == true then
			if IsValid(npcWeapon) && !npc:IsMoving() && npcWeapon.IsVJBaseWeapon == true && ply:KeyDown(IN_ATTACK2) && npc.AttackType == VJ_ATTACK_NONE && npc.vACT_StopAttacks == false && npc:GetWeaponState() == VJ_WEP_STATE_READY then
				//npc:SetAngles(Angle(0,math.ApproachAngle(npc:GetAngles().y,ply:GetAimVector():Angle().y,100),0))
				npc:FaceCertainPosition(pos_beye, 0.2)
				canTurn = false
				if VJ_IsCurrentAnimation(npc, npc:TranslateToWeaponAnim(npc.CurrentWeaponAnimation)) == false && VJ_IsCurrentAnimation(npc, npc.AnimTbl_WeaponAttack) == false then
					npc.CurrentWeaponAnimation = VJ_PICK(npc.AnimTbl_WeaponAttack)
					npc:VJ_ACT_PLAYACTIVITY(npc.CurrentWeaponAnimation, false, 2, false)
					npc.DoingWeaponAttack = true
					npc.DoingWeaponAttack_Standing = true
				end
			end
			if !ply:KeyDown(IN_ATTACK2) then
				npc.DoingWeaponAttack = false
				npc.DoingWeaponAttack_Standing = false
			end
		end
		
		if npc.Flinching == true or (((npc.CurrentSchedule && npc.CurrentSchedule.IsPlayActivity != true) or npc.CurrentSchedule == nil) && npc:GetNavType() == NAV_JUMP) then return end
		
		-- Turning
		if !npc:IsMoving() && npc.PlayingAttackAnimation == false && canTurn && CurTime() > npc.NextChaseTime && npc.IsVJBaseSNPC_Tank != true && npc.MovementType != VJ_MOVETYPE_PHYSICS && ((npc.IsVJBaseSNPC_Human && npc:GetWeaponState() != VJ_WEP_STATE_RELOADING) or (!npc.IsVJBaseSNPC_Human)) then
			//npc:SetAngles(Angle(0,ply:GetAimVector():Angle().y,0))
			local angdif = math.abs(math.AngleDifference(ply:EyeAngles().y, self.VJC_NPC_LastIdleAngle))
			self.VJC_NPC_LastIdleAngle = npc:EyeAngles().y //tr_ply.HitPos
			npc:VJ_TASK_IDLE_STAND()
			if ((npc.MovementType != VJ_MOVETYPE_STATIONARY) or (npc.MovementType == VJ_MOVETYPE_STATIONARY && npc.CanTurnWhileStationary == true)) then
				if (VJ_AnimationExists(npc, ACT_TURN_LEFT) == false && VJ_AnimationExists(npc, ACT_TURN_RIGHT) == false) or (angdif <= 50 && npc:GetActivity() != ACT_TURN_LEFT && npc:GetActivity() != ACT_TURN_RIGHT) then
					//npc:VJ_TASK_IDLE_STAND()
					npc:FaceCertainPosition(pos_beye, 0.1)
				else
					self.NextIdleStandTime = 0
					npc:SetLastPosition(pos_beye) // ply:GetEyeTrace().HitPos
					npc:VJ_TASK_FACE_X("TASK_FACE_LASTPOSITION")
				end
			end
			//self.TestLerp = npc:GetAngles().y
			//npc:SetAngles(Angle(0,Lerp(100*FrameTime(),self.TestLerp,ply:GetAimVector():Angle().y),0))
		end
		
		-- Movement
		if npc.MovementType != VJ_MOVETYPE_STATIONARY && npc.PlayingAttackAnimation == false && CurTime() > npc.NextChaseTime && npc.IsVJBaseSNPC_Tank != true then
			local gerta_for = ply:KeyDown(IN_FORWARD)
			local gerta_bac = ply:KeyDown(IN_BACK)
			local gerta_lef = ply:KeyDown(IN_MOVELEFT)
			local gerta_rig = ply:KeyDown(IN_MOVERIGHT)
			local gerta_arak = ply:KeyDown(IN_SPEED)
			local aimVector = ply:GetAimVector()
			
			if gerta_for then
				if npc.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then
					npc:AA_MoveTo(self.VJCE_Bullseye, true, gerta_arak and "Alert" or "Calm", {IgnoreGround=true})
				else
					if gerta_lef then
						self:StartMovement(aimVector, Angle(0,45,0))
					elseif gerta_rig then
						self:StartMovement(aimVector, Angle(0,-45,0))
					else
						self:StartMovement(aimVector, Angle(0,0,0))
					end
				end
			elseif gerta_bac then
				if gerta_lef then
					self:StartMovement(aimVector*-1, Angle(0,-45,0))
				elseif gerta_rig then
					self:StartMovement(aimVector*-1, Angle(0,45,0))
				else
					self:StartMovement(aimVector*-1, Angle(0,0,0))
				end
			elseif gerta_lef then
				self:StartMovement(aimVector, Angle(0,90,0))
			elseif gerta_rig then
				self:StartMovement(aimVector, Angle(0,-90,0))
			else
				npc:StopMoving()
				if npc.MovementType == VJ_MOVETYPE_AERIAL or npc.MovementType == VJ_MOVETYPE_AQUATIC then npc:AA_StopMoving() end
			end
			/*if (ply:KeyDown(IN_USE)) then
				npc:StopMoving()
				self:StopControlling()
			end*/
		end
	end
	self:NextThink(curTime + (0.069696968793869 + FrameTime()))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartMovement(Dir, Rot)
	local npc = self.VJCE_NPC
	local ply = self.VJCE_Player
	if npc:GetState() != VJ_STATE_NONE then return end

	local DontMove = false
	local PlyAimVec = Dir
	PlyAimVec.z = 0
	PlyAimVec:Rotate(Rot)
	local NPCOrigin = npc:GetPos()
	local CenterToPos = npc:OBBCenter():Distance(npc:OBBMins()) + 20 // npc:OBBMaxs().z
	local NPCPos = NPCOrigin + npc:GetUp()*CenterToPos
	local groundSpeed = math.Clamp(npc:GetSequenceGroundSpeed(npc:GetSequence()), 300, 9999)
	local defaultFilter = {npc,ply,self}
	local TargetPos = NPCPos + PlyAimVec*groundSpeed
	local forwardtr = util.TraceLine({start = NPCPos, endpos = TargetPos, filter = defaultFilter})
	local forwardDist = NPCPos:Distance(forwardtr.HitPos)
	local CalculateWallToNPC = forwardDist - (npc:OBBMaxs().y) -- Use Y instead of X because X is left/right whereas Y is forward/backward

	if ply:GetInfoNum("vj_npc_cont_devents", 0) == 1 then
		VJ_CreateTestObject(NPCPos, self:GetAngles(), Color(0,255,255)) -- NPC's calculated position
		VJ_CreateTestObject(forwardtr.HitPos, self:GetAngles(), Color(255,255,0)) -- forward trace position
	end
	if forwardDist >= 25 then
		local FinalPos = Vector((NPCOrigin+PlyAimVec*CalculateWallToNPC).x,(NPCOrigin+PlyAimVec*CalculateWallToNPC).y,forwardtr.HitPos.z)
		local downtr = util.TraceLine({start = FinalPos, endpos = FinalPos + self:GetUp()*-(200+CenterToPos), filter = defaultFilter})
		local CalculateDownDistance = (FinalPos.z-CenterToPos) - downtr.HitPos.z
		if CalculateDownDistance >= 150 then -- If the drop is this big, then don't move!
			DontMove = true
			CalculateWallToNPC = CalculateWallToNPC - CalculateDownDistance
		end
		FinalPos = Vector((NPCOrigin+PlyAimVec*CalculateWallToNPC).x, (NPCOrigin+PlyAimVec*CalculateWallToNPC).y, forwardtr.HitPos.z)
		if ply:GetInfoNum("vj_npc_cont_devents", 0) == 1 then
			VJ_CreateTestObject(downtr.HitPos, self:GetAngles(), Color(255,0,255)) -- Down trace position
			VJ_CreateTestObject(FinalPos, self:GetAngles(), Color(0,255,0)) -- Final move position
		end
		if DontMove == false then
			npc:SetLastPosition(FinalPos)
			local movetype = "TASK_WALK_PATH"
			if (ply:KeyDown(IN_SPEED)) then movetype = "TASK_RUN_PATH" end
			npc:VJ_TASK_GOTO_LASTPOS(movetype,function(x)
				if ply:KeyDown(IN_ATTACK2) && npc.IsVJBaseSNPC_Human == true then
					x.ConstantlyFaceEnemy = true
					x.CanShootWhenMoving = true
				else
					if self.VJC_BullseyeTracking == true then
						x.ConstantlyFaceEnemy = true
					else
						x:EngTask("TASK_FACE_LASTPOSITION", 0)
					end
				end
			end)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ToggleBullseyeTracking()
	if !self.VJC_BullseyeTracking then
		self.VJCE_Player:ChatPrint("#vjbase.print.npccontroller.tracking.activated")
		self.VJC_BullseyeTracking = true
	else
		self.VJCE_Player:ChatPrint("#vjbase.print.npccontroller.tracking.deactivated")
		self.VJC_BullseyeTracking = false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ToggleMovementJumping()
	if !self.VJCE_NPC.AllowMovementJumping then
		self.VJCE_Player:ChatPrint("#vjbase.print.npccontroller.movementjump.enable")
		self.VJCE_NPC.AllowMovementJumping = true
	else
		self.VJCE_Player:ChatPrint("#vjbase.print.npccontroller.movementjump.disable")
		self.VJCE_NPC.AllowMovementJumping = false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StopControlling(endKey)
	//if !IsValid(self.VJCE_Player) then return self:Remove() end
	endKey = endKey or false
	self:CustomOnStopControlling()

	local npc = self.VJCE_NPC
	local ply = self.VJCE_Player
	if IsValid(ply) then
		local plyData = self.VJC_Data_Player
		ply:UnSpectate()
		ply:KillSilent() -- If we don't, we will get bugs like no being able to pick up weapons when walking over them.
		if self.VJC_Player_CanRespawn == true or endKey == true then
			ply:Spawn()
			ply:SetHealth(plyData[1])
			ply:SetArmor(plyData[2])
			for _, v in pairs(plyData[3]) do
				ply:Give(v)
			end
			ply:SelectWeapon(plyData[4])
		end
		if IsValid(npc) then
			ply:SetPos(npc:GetPos() + npc:OBBMaxs() + vecZ20)
		else
			ply:SetPos(self.VJC_NPC_LastPos)
		end
		/*if IsValid(self.VJCE_Camera) then
		ply:SetPos(self.VJCE_Camera:GetPos() +self.VJCE_Camera:GetUp()*100) else
		ply:SetPos(ply:GetPos()) end*/
		ply:SetNoDraw(false)
		ply:DrawShadow(true)
		ply:SetNoTarget(false)
		//ply:Spectate(OBS_MODE_NONE)
		ply:DrawViewModel(true)
		ply:DrawWorldModel(true)
		//ply:SetMoveType(MOVETYPE_WALK)
		ply.IsControlingNPC = false
		ply.VJ_TheControllerEntity = NULL
		self:SendDataToClient(true)
	end
	self.VJCE_Player = NULL

	if IsValid(npc) then
		local npcData = self.VJC_Data_NPC
		//npc:StopMoving()
		npc.VJ_IsBeingControlled = false
		npc.VJ_TheController = NULL
		npc.VJ_TheControllerEntity = NULL
		//npc:ClearSchedule()
		if npc.IsVJBaseSNPC == true then
			npc.DisableWandering = npcData[1]
			npc.DisableChasingEnemy = npcData[2]
			npc.DisableTakeDamageFindEnemy = npcData[3]
			npc.DisableTouchFindEnemy = npcData[4]
			npc.DisableSelectSchedule = npcData[5]
			npc.CallForHelp = npcData[6]
			npc.CallForBackUpOnDamage = npcData[7]
			npc.BringFriendsOnDeath = npcData[8]
			npc.FollowPlayer = npcData[9]
			npc.CanDetectDangers = npcData[10]
			npc.Passive_RunOnTouch = npcData[11]
			npc.Passive_RunOnDamage = npcData[12]
			npc.IsGuard = npcData[13]
		end
	end
	//self.VJCE_Camera:Remove()
	self.VJC_Removed = true
	self:Remove()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	self:CustomOnRemove()
	if self.VJC_Removed == false then
		self:StopControlling()
	end
	net.Start("vj_controller_hud")
		net.WriteBool(false)
		net.WriteFloat(0)
		net.WriteFloat(0)
		net.WriteString(" ")
		net.WriteTable({})
	net.Broadcast()
end
