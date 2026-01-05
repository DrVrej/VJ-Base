AddCSLuaFile("shared.lua")
include("shared.lua")
/*--------------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
ENT.VJC_Player_CanExit = true -- Can the player exit the controller?
ENT.VJC_Player_CanRespawn = true -- If false, the player will die when the NPC dies!
ENT.VJC_Player_CanChatMessage = true -- Can the controller be allowed to send chat messages to the player?
ENT.VJC_Player_DrawHUD = true -- Should the controller HUD be displayed?
ENT.VJC_NPC_CanTurn = true -- Should the NPC be allowed to turn while idle?
ENT.VJC_Bullseye_RefreshPos = true -- Should bullseye's position update every tick?
ENT.VJC_BullseyeTracking = false -- Activates bullseye tracking (Will not turn to the move location!)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Customization Functions ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Use the functions below to customize certain parts of the base or to add new custom systems
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink() end
---------------------------------------------------------------------------------------------------------------------------------------------
-- Different from self:OnKeyBindPressed(), this uses: https://wiki.facepunch.com/gmod/Enums/KEY
function ENT:OnKeyPressed(key) end
---------------------------------------------------------------------------------------------------------------------------------------------
-- Different from self:OnKeyPressed(), this uses: https://wiki.facepunch.com/gmod/Enums/IN
function ENT:OnKeyBindPressed(key) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnStopControlling(keyPressed) end
---------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ ///// WARNING: Don't touch anything below this line! \\\\\ ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJC_SavedVars_PLY = nil -- A hash table to hold all the values that need to be reset after the player stops controlling
ENT.VJC_SavedVars_NPC = nil -- A hash table to hold all the values that need to be reset after the NPC is uncontrolled
ENT.VJC_Camera_Mode = 1 -- Current camera mode | 1 = Third, 2 = First
ENT.VJC_Camera_CurZoom = Vector(0, 0, 0)
ENT.VJC_Key_Last = BUTTON_CODE_NONE -- The last button the user pressed
ENT.VJC_Key_LastTime = 0 -- Time since the user last pressed a key
ENT.VJC_NPC_LastPos = Vector(0, 0, 0)
ENT.VJC_Removed = false

/* Important entities:
	- self.VJCE_Player		The player that's controlling
	- self.VJCE_NPC			The NPC that's being controlled
	- self.VJCE_Bullseye	The bullseye entity used for the NPC to target
	- self.VJCE_Camera		The camera entity used for the player
*/

local vecDef = Vector(0, 0, 0)
local math_min = math.min
local math_max = math.max
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
	self:DrawShadow(false)
	self:SetRenderMode(RENDERMODE_NONE) -- Disable shadow for dynamic lights
	self:Init()
	if self.CustomOnInitialize then self:CustomOnInitialize() end -- !!!!!!!!!!!!!! DO NOT USE !!!!!!!!!!!!!! [Backwards Compatibility!]
	if self.CustomOnThink then self.OnThink = function() self:CustomOnThink() end end -- !!!!!!!!!!!!!! DO NOT USE !!!!!!!!!!!!!! [Backwards Compatibility!]
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS -- This entity should always transmit as its client side code is essential!
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetControlledNPC(npc)
	-- Set the bullseye entity values
	local bullseye = ents.Create("obj_vj_bullseye")
	bullseye:SetPos(npc:GetPos() + npc:GetForward()*100 + npc:GetUp()*50) //Vector(npc:OBBMaxs().x + 20, 0, npc:OBBMaxs().z + 20))
	bullseye:SetModel("models/hunter/blocks/cube025x025x025.mdl")
	//bullseye:SetParent(npc)
	bullseye:SetRenderMode(RENDERMODE_NONE)
	bullseye:Spawn()
	bullseye:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	bullseye:SetNoDraw(false)
	bullseye:DrawShadow(false)
	bullseye.ForceEntAsEnemy = npc
	bullseye.HandlePerceivedRelationship = function(_, otherEnt, distance, isFriendly)
		if otherEnt == npc then
			return D_HT
		end
		return D_NU
	end
	bullseye.VJ_IsBeingControlled = true
	self:DeleteOnRemove(bullseye)
	self.VJCE_Bullseye = bullseye
	self:SetBullseye(bullseye)

	-- Set the NPC
	if !npc.ControllerParams then
		npc.ControllerParams = {
			CameraMode = 1,
			ThirdP_Offset = Vector(0, 0, 0),
			FirstP_Bone = "ValveBiped.Bip01_Head1",
			FirstP_Offset = Vector(0, 0, 5),
			FirstP_ShrinkBone = true,
		}
	end
	local ply = self.VJCE_Player
	self.VJC_Camera_Mode = npc.ControllerParams.CameraMode -- Get the NPC's default camera mode
	self.VJC_NPC_LastPos = npc:GetPos()
	npc.VJ_IsBeingControlled = true
	npc.VJ_TheController = ply
	npc.VJ_TheControllerEntity = self
	npc.VJ_TheControllerBullseye = bullseye
	npc:SetEnemy(NULL)
	if npc.IsVJBaseSNPC then
		local funcCustom = npc.Controller_IntMsg; if funcCustom then funcCustom(npc, ply, self) end -- !!!!!!!!!!!!!! DO NOT USE THIS FUNCTION !!!!!!!!!!!!!! [Backwards Compatibility!]
		npc:Controller_Initialize(ply, self)
		local npcEnemy = npc:GetEnemy()
		if IsValid(npcEnemy) then
			npc:AddEntityRelationship(npcEnemy, D_NU, 10)
			npcEnemy:AddEntityRelationship(npc, D_NU, 10)
			npc:ResetEnemy()
			npc:SetEnemy(bullseye)
		end
		self.VJC_SavedVars_NPC = {
			[1] = npc.DisableWandering,
			[2] = npc.DisableChasingEnemy,
			[3] = npc.DamageResponse,
			[4] = npc.EnemyTouchDetection,
			[5] = npc.CallForHelp,
			[6] = npc.DamageAllyResponse,
			[7] = npc.DeathAllyResponse,
			[8] = npc.FollowPlayer,
			[9] = npc.CanDetectDangers,
			[10] = npc.Passive_RunOnTouch,
			//[11] = npc.Passive_RunOnDamage,
			[12] = npc.IsGuard,
			[13] = npc.CanReceiveOrders,
			[14] = npc.EnemyXRayDetection,
			[15] = npc:GetFOV(),
			[16] = npc.CombatDamageResponse,
			[17] = npc.BecomeEnemyToPlayer,
			[18] = npc.CanEat,
			[19] = npc.LimitChaseDistance,
			[20] = npc.ConstantlyFaceEnemy,
			[21] = npc.IsMedic,
			[22] = npc.EnemyDetection,
		}
		npc.DisableWandering = true
		npc.DisableChasingEnemy = true
		npc.DamageResponse = false
		npc.EnemyTouchDetection = false
		npc.CallForHelp = false
		npc.DamageAllyResponse = false
		npc.DeathAllyResponse = npc.DeathAllyResponse == true and "OnlyAlert" or false
		npc.FollowPlayer = false
		npc.CanDetectDangers = false
		npc.Passive_RunOnTouch = false
		npc.IsGuard = false
		npc.CanReceiveOrders = false
		npc.EnemyXRayDetection = true
		npc:SetFOV(360)
		npc.CombatDamageResponse = false
		npc.BecomeEnemyToPlayer = false
		npc.CanEat = false
		npc.LimitChaseDistance = false
		npc.ConstantlyFaceEnemy = false
		npc.IsMedic = false
		npc.PauseAttacks = true
		npc.NextThrowGrenadeT = 0
		npc.EnemyDetection = false
		for _, v in ipairs(npc.RelationshipEnts) do
			if IsValid(v) then
				npc:AddEntityRelationship(v, D_NU)
			end
		end
		 -- Apply a delay to VJ NPCs so they don't attack right away
		if npc.NextDoAnyAttackT < CurTime() then
			npc.NextDoAnyAttackT = CurTime() + 0.5
		end
		if npc.MedicData.Status then npc:ResetMedicBehavior() end
		if npc.VJ_ST_Eating then
			npc:OnEat("StopEating", "Unspecified") -- So it plays the get up animation
			npc:ResetEatingBehavior("Unspecified")
		end
		-- Apply a small delay to assure that the bullseye is in the NPC's "RelationshipEnts"
		timer.Simple(0.1, function()
			if IsValid(self) && IsValid(npc) then
				npc:MaintainRelationships()
			end
		end)
	end
	-- !!!!!!!!!!!!!! DO NOT USE THESE !!!!!!!!!!!!!! [Backwards Compatibility!]
	if self.CustomOnKeyPressed then self.OnKeyPressed = function(_, key) self:CustomOnKeyPressed(key) end end
	if self.CustomOnKeyBindPressed then self.OnKeyBindPressed = function(_, key) self:CustomOnKeyBindPressed(key) end end
	if self.CustomOnStopControlling then self.OnStopControlling = function(_, keyPressed) self:CustomOnStopControlling(keyPressed) end end
	--
	npc:ClearSchedule()
	npc:StopMoving()
	self.VJCE_NPC = npc
	self:SetNPC(npc)
	timer.Simple(0, function() -- This only needs to be 0 seconds because we just need a tick to pass
		if IsValid(self) && IsValid(self.VJCE_NPC) then
			self.VJCE_NPC.PauseAttacks = false
			self.VJCE_NPC:ForceSetEnemy(self.VJCE_Bullseye, false)
			self.VJCE_NPC:SetEnemy(self.VJCE_Bullseye)
		end
	end)
	self:SendDataToClient()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartControlling()
	local npc = self.VJCE_NPC
	
	-- Set up the camera entity
	local camera = ents.Create("prop_dynamic")
	camera:SetPos(npc:GetPos() + Vector(0, 0, npc:OBBMaxs().z)) //npc:EyePos()
	camera:SetModel("models/props_junk/watermelon01_chunk02c.mdl")
	camera:SetParent(npc)
	camera:SetRenderMode(RENDERMODE_NONE)
	camera:Spawn()
	camera:SetNoDraw(false)
	camera:DrawShadow(false)
	self:DeleteOnRemove(camera)
	self.VJCE_Camera = camera
	self:SetCamera(camera)
	
	-- Set up the player
	local ply = self.VJCE_Player
	self:SetPlayer(ply)
	ply.VJ_IsControllingNPC = true
	ply.VJ_TheControllerEntity = self
	ply:Spectate(OBS_MODE_CHASE)
	ply:SpectateEntity(camera)
	ply:DrawShadow(false)
	ply:SetNoDraw(true)
	ply:SetMoveType(MOVETYPE_OBSERVER)
	ply:DrawViewModel(false)
	ply:DrawWorldModel(false)
	local weps = {}
	for _, v in ipairs(ply:GetWeapons()) do
		weps[#weps + 1] = v:GetClass()
	end
	self.VJC_SavedVars_PLY = {
		health = ply:Health(),
		armor = ply:Armor(),
		weapons = weps,
		activeWep = (IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass()) or "",
		godMode = ply:HasGodMode(), -- Maintain the player's God mode status after exiting the controller
		noTarget = ply:IsFlagSet(FL_NOTARGET)
	}
	ply:SetNoTarget(true)
	ply:StripWeapons()
	if ply:GetInfoNum("vj_npc_cont_diewithnpc", 0) == 1 then self.VJC_Player_CanRespawn = false end

	hook.Add("PlayerButtonDown", self, function(ent, ply2, button)
		if IsValid(ent) && ply2.VJ_IsControllingNPC && ent.VJCE_Player == ply2 then
			ent.VJC_Key_Last = button
			ent.VJC_Key_LastTime = CurTime()
			ent:OnKeyPressed(button)
			
			-- Stop Controlling
			if ent.VJC_Player_CanExit and button == KEY_END then
				ent:StopControlling(true)
			end
			
			-- Tracking
			if button == KEY_T then
				ent:ToggleBullseyeTracking()
			end
			
			-- Camera mode
			if button == KEY_H then
				ent.VJC_Camera_Mode = (ent.VJC_Camera_Mode == 1 and 2) or 1
			end
			
			-- Allow movement jumping
			if button == KEY_J then
				ent:ToggleMovementJumping()
			end
			
			-- Zoom
			local zoom = ply2:GetInfoNum("vj_npc_cont_cam_zoom_dist", 5)
			if button == KEY_LEFT then
				ent.VJC_Camera_CurZoom = ent.VJC_Camera_CurZoom - Vector(0, zoom, 0)
			elseif button == KEY_RIGHT then
				ent.VJC_Camera_CurZoom = ent.VJC_Camera_CurZoom + Vector(0, zoom, 0)
			elseif button == KEY_UP then
				ent.VJC_Camera_CurZoom = ent.VJC_Camera_CurZoom + (ply2:KeyDown(IN_SPEED) and Vector(0, 0, zoom) or Vector(zoom, 0, 0))
			elseif button == KEY_DOWN then
				ent.VJC_Camera_CurZoom = ent.VJC_Camera_CurZoom - (ply2:KeyDown(IN_SPEED) and Vector(0, 0, zoom) or Vector(zoom, 0, 0))
			end
			if button == KEY_BACKSPACE then
				ent.VJC_Camera_CurZoom = vecDef
			end
		end
	end)

	hook.Add("KeyPress", self, function(ent, ply2, key)
		//print(key)
		if IsValid(ent) && ply2.VJ_IsControllingNPC && ent.VJCE_Player == ply2 then
			ent:OnKeyBindPressed(key)
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- Sadly no other way, this is the most reliable way to sync the position from client to server in time
	-- Also avoids garbage positions that output from other methods
net.Receive("vj_controller_sv", function(len, ply)
	-- Set the controller's bullseye position if the player is controlling an NPC AND controller entity exists AND Bullseye exists --> Protect against spam ?
	if ply.VJ_IsControllingNPC && IsValid(ply.VJ_TheControllerEntity) && ply.VJ_TheControllerEntity.VJC_Bullseye_RefreshPos && IsValid(ply.VJ_TheControllerEntity.VJCE_Bullseye) then
		ply.VJ_TheControllerEntity.VJCE_Bullseye:SetPos(net.ReadVector())
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SendDataToClient(reset)
	local npc = self.VJCE_NPC
	local npcData = npc.ControllerParams
	self:SetHUDEnabled(self.VJC_Player_DrawHUD)
	self:SetCameraMode((reset and 1) or self.VJC_Camera_Mode)
	self:SetCameraTP_Offset((reset and vecDef) or (npcData.ThirdP_Offset + self.VJC_Camera_CurZoom))
	self:SetCameraFP_Offset((reset and vecDef) or npcData.FirstP_Offset)
	if IsValid(npc) then
		self:SetCameraFP_Bone(npc:LookupBone(npcData.FirstP_Bone) or -1)
	end
	self:SetCameraFP_ShrinkBone((reset != true and npcData.FirstP_ShrinkBone) or false)
	self:SetCameraFP_BoneAng((reset != true and npcData.FirstP_CameraBoneAng) or 0)
	self:SetCameraFP_BoneAngOffset((reset != true and npcData.FirstP_CameraBoneAng_Offset) or 0)
	
	if !reset && IsValid(npc) then
		self:SetNPCName(npc:GetName())
		self:SetNPCHealth(npc:Health())
		self:SetNPCMaxHealth(npc:GetMaxHealth())
		self:SetNPCAttackMelee(npc.HasMeleeAttack && (((npc.IsAbleToMeleeAttack != true or npc.AttackType == VJ.ATTACK_TYPE_MELEE) and 2) or 1) or 0)
		self:SetNPCRangeAttack(npc.HasRangeAttack && (((npc.IsAbleToRangeAttack != true or npc.AttackType == VJ.ATTACK_TYPE_RANGE) and 2) or 1) or 0)
		self:SetNPCLeapAttack(npc.HasLeapAttack && (((npc.IsAbleToLeapAttack != true or npc.AttackType == VJ.ATTACK_TYPE_LEAP) and 2) or 1) or 0)
		self:SetNPCGrenadeAttack(npc.HasGrenadeAttack && ((CurTime() <= npc.NextThrowGrenadeT and 2) or 1) or 0)
		local npcWeapon = npc:GetActiveWeapon()
		if IsValid(npcWeapon) then
			self:SetNPCWeapon(npcWeapon)
			self:SetNPCWeaponAmmo(IsValid(npcWeapon) && npcWeapon:Clip1() or 0)
		else
			self:SetNPCWeapon(NULL)
			self:SetNPCWeaponAmmo(0)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vecZ20 = Vector(0, 0, 20)
--
function ENT:Think()
	local ply = self.VJCE_Player
	local npc = self.VJCE_NPC
	local camera = self.VJCE_Camera
	local bullseye = self.VJCE_Bullseye
	if !IsValid(ply) or !IsValid(npc) or !IsValid(camera) or !IsValid(bullseye) or !ply.VJ_IsControllingNPC or !ply:Alive() or !npc:Alive() then self:StopControlling() return end
	local curTime = CurTime()
	local npcWeapon = npc:GetActiveWeapon()
	local npcEnemy = npc:GetEnemy()
	local bullseyePos = bullseye:GetPos()
	
	-- Keep bullseye as the enemy
	if npcEnemy != bullseye then
		if npc.IsVJBaseSNPC then
			npc:ResetEnemy()
			npc:ForceSetEnemy(bullseye, false)
		end
		npc:AddEntityRelationship(bullseye, D_HT, 99)
		npc:SetEnemy(bullseye)
	end
	
	self.VJC_NPC_LastPos = npc:GetPos()
	ply:SetPos(self.VJC_NPC_LastPos + vecZ20) -- Set player's location
	if #ply:GetWeapons() > 0 then ply:StripWeapons() end
	self:SendDataToClient()
	
	-- Debug
	if ply:GetInfoNum("vj_npc_cont_debug", 0) == 1 then
		debugoverlay.Box(ply:GetPos(), Vector(-2, -2, -2), Vector(2, 2, 2), 1, VJ.COLOR_BLUE)
		debugoverlay.Text(ply:GetPos(), "Player", 1, false)
		debugoverlay.Box(camera:GetPos(), Vector(-2, -2, -2), Vector(2, 2, 2), 1, VJ.COLOR_CYAN)
		debugoverlay.Text(camera:GetPos(), "Camera", 1, false)
		debugoverlay.Box(bullseyePos, Vector(-2, -2, -2), Vector(2, 2, 2), 1, VJ.COLOR_RED)
		debugoverlay.Text(bullseyePos, "Bullseye", 1, false)
	end
	
	self:OnThink()

	local canTurn = true
	if npc.Flinching or (((npc.CurrentSchedule && !npc.CurrentSchedule.IsPlayActivity) or !npc.CurrentSchedule) && npc:GetNavType() == NAV_JUMP) then return end

	-- NPC Weapon attack
	if npc.IsVJBaseSNPC_Human then
		if IsValid(npcWeapon) && !npc:IsMoving() && npcWeapon.IsVJBaseWeapon && ply:KeyDown(IN_ATTACK2) && !npc.AttackType && !npc.PauseAttacks && npc:GetWeaponState() == VJ.WEP_STATE_READY then
			//npc:SetAngles(Angle(0, math.ApproachAngle(npc:GetAngles().y, ply:GetAimVector():Angle().y, 100), 0))
			npc:SetTurnTarget(bullseyePos, 0.2)
			canTurn = false
			if npcWeapon.IsMeleeWeapon then
				if curTime > npc.NextMeleeWeaponAttackT then
					npc:OnWeaponAttack()
					local anim = npc:TranslateActivity(VJ.PICK(npc.AnimTbl_WeaponAttack))
					local animDur = VJ.AnimDuration(npc, anim)
					npc.NextMeleeWeaponAttackT = curTime + animDur
					npc.WeaponAttackAnim = anim
					npc:PlayAnim(anim, "LetAttacks", false, false)
					npc.WeaponAttackState = VJ.WEP_ATTACK_STATE_FIRE_STAND
					npcWeapon.NPC_NextPrimaryFire = animDur -- Make melee weapons dynamically change the next primary fire
					npcWeapon:NPCShoot_Primary()
				end
			elseif !VJ.IsCurrentAnim(npc, npc:TranslateActivity(npc.WeaponAttackAnim)) && !VJ.IsCurrentAnim(npc, npc.AnimTbl_WeaponAttack) then
				npc:OnWeaponAttack()
				local anim = npc:TranslateActivity(VJ.PICK(npc.AnimTbl_WeaponAttack))
				npc.WeaponAttackAnim = anim
				npc:PlayAnim(anim, false, 2, false)
				npc.WeaponAttackState = VJ.WEP_ATTACK_STATE_FIRE_STAND
			end
		end
		if !ply:KeyDown(IN_ATTACK2) then
			npc.WeaponAttackState = VJ.WEP_ATTACK_STATE_NONE
		end
	end
	
	if npc.IsVJBaseSNPC && npc.AttackAnimTime < curTime && curTime > npc.NextChaseTime && !npc.IsVJBaseSNPC_Tank then
		-- NPC Turning
		if !npc:IsMoving() && canTurn && npc.MovementType != VJ_MOVETYPE_PHYSICS && ((npc.IsVJBaseSNPC_Human && npc:GetWeaponState() != VJ.WEP_STATE_RELOADING) or (!npc.IsVJBaseSNPC_Human)) then
			npc:SCHEDULE_IDLE_STAND()
			if self.VJC_NPC_CanTurn then
				local turnData = npc.TurnData
				if turnData.Target != bullseye then
					npc:SetTurnTarget(bullseye, 1)
				elseif npc:GetActivity() == ACT_IDLE && npc:GetIdealActivity() == ACT_IDLE && npc:DeltaIdealYaw() <= -45 or npc:DeltaIdealYaw() >= 45 then -- Check both current act AND ideal act because certain activities only change the current act (Ex: UpdateTurnActivity function)
					npc:UpdateTurnActivity()
					if npc:GetIdealActivity() != ACT_IDLE then -- If ideal act is no longer idle, then we have selected a turn activity!
						npc.NextIdleTime = curTime + VJ.AnimDurationEx(npc, npc:GetIdealActivity())
					end
				end
			end
			//self.TestLerp = npc:GetAngles().y
			//npc:SetAngles(Angle(0, Lerp(100*FrameTime(), self.TestLerp, ply:GetAimVector():Angle().y), 0))
		end
		
		-- NPC Movement
		npc:Controller_Movement(self, ply, bullseyePos)
	end
	self:NextThink(curTime)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartMovement(Dir, Rot)
	local npc = self.VJCE_NPC
	local ply = self.VJCE_Player
	if npc:GetState() != VJ_STATE_NONE then return end

	local DEBUG = ply:GetInfoNum("vj_npc_cont_debug", 0) == 1
	local plyAimVec = Dir
	plyAimVec.z = 0
	plyAimVec:Rotate(Rot)
	local selfPos = npc:GetPos()
	local centerToPos = npc:OBBCenter():Distance(npc:OBBMins()) + 20 // npc:OBBMaxs().z
	local NPCPos = selfPos + npc:GetUp()*centerToPos
	local groundSpeed = math_min(math_max(npc:GetSequenceGroundSpeed(npc:GetSequence()), 300), 9999)
	local defaultFilter = {self, npc, ply}
	local forwardTr = util.TraceLine({start = NPCPos, endpos = NPCPos + plyAimVec * groundSpeed, filter = defaultFilter})
	local forwardDist = NPCPos:Distance(forwardTr.HitPos)
	local wallToSelf = forwardDist - (npc:OBBMaxs().y) -- Use Y instead of X because X is left/right whereas Y is forward/backward
	if DEBUG then
		debugoverlay.Box(NPCPos, Vector(-2, -2, -2), Vector(2, 2, 2), 3, VJ.COLOR_BLUE_SKY) -- NPC's calculated position
		debugoverlay.Text(NPCPos, "NPCPos", 3, false)
		debugoverlay.Box(forwardTr.HitPos, Vector(-2, -2, -2), Vector(2, 2, 2), 3, VJ.COLOR_YELLOW) -- forward trace position
		debugoverlay.Text(forwardTr.HitPos, "forwardTr.HitPos", 3, false)
	end
	if forwardDist >= 25 then
		local finalPos = Vector((selfPos + plyAimVec * wallToSelf).x, (selfPos + plyAimVec * wallToSelf).y, forwardTr.HitPos.z)
		-- Check if ground is valid!
		local downTr = util.TraceLine({start = finalPos, endpos = finalPos + self:GetUp()*-(200 + centerToPos), filter = defaultFilter})
		local downDist = (finalPos.z - centerToPos) - downTr.HitPos.z
		if downDist >= 150 then -- If the drop is this big, then don't move!
			//wallToSelf = wallToSelf - downDist -- No need, we are returning anyway
			return
		end
		if DEBUG then
			debugoverlay.Box(downTr.HitPos, Vector(-2, -2, -2), Vector(2, 2, 2), 3, VJ.COLOR_PINK) -- Down trace position
			debugoverlay.Text(downTr.HitPos, "downTr.HitPos", 3, false)
			debugoverlay.Box(finalPos, Vector(-2, -2, -2), Vector(2, 2, 2), 3, VJ.COLOR_PURPLE) -- Final move position
			debugoverlay.Text(finalPos, "finalPos", 3, false)
		end
		npc:SetLastPosition(finalPos)
		npc:SCHEDULE_GOTO_POSITION(ply:KeyDown(IN_SPEED) and "TASK_RUN_PATH" or "TASK_WALK_PATH", function(x)
			-- Since are constantly setting the schedule, we need to manually update the movement activity every time to avoid stuttering between walk/run
			npc:SetMovementActivity(ply:KeyDown(IN_SPEED) and ACT_RUN or ACT_WALK)
			if ply:KeyDown(IN_ATTACK2) && npc.IsVJBaseSNPC_Human then
				x.TurnData = {Type = VJ.FACE_ENEMY}
				x.CanShootWhenMoving = true
			else
				if self.VJC_BullseyeTracking then
					x.TurnData = {Type = VJ.FACE_ENEMY}
				else
					npc:ResetTurnTarget()
					x:EngTask("TASK_FACE_LASTPOSITION", 0)
				end
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ToggleBullseyeTracking()
	if !self.VJC_BullseyeTracking then
		if self.VJC_Player_CanChatMessage then self.VJCE_Player:ChatPrint("#vjbase.controller.print.tracking.activated") end
		self.VJC_BullseyeTracking = true
	else
		if self.VJC_Player_CanChatMessage then self.VJCE_Player:ChatPrint("#vjbase.controller.print.tracking.deactivated") end
		self.VJC_BullseyeTracking = false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ToggleMovementJumping()
	if !self.VJCE_NPC.JumpParams.Enabled then
		if self.VJC_Player_CanChatMessage then self.VJCE_Player:ChatPrint("#vjbase.controller.print.jump.enable") end
		self.VJCE_NPC.JumpParams.Enabled = true
	else
		if self.VJC_Player_CanChatMessage then self.VJCE_Player:ChatPrint("#vjbase.controller.print.jump.disable") end
		self.VJCE_NPC.JumpParams.Enabled = false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StopControlling(keyPressed)
	//if !IsValid(self.VJCE_Player) then return self:Remove() end
	keyPressed = keyPressed or false

	local npc = self.VJCE_NPC
	local ply = self.VJCE_Player
	if IsValid(ply) then
		local plyData = self.VJC_SavedVars_PLY
		ply:UnSpectate()
		ply:KillSilent() -- If we don't, we will get bugs like not being able to pick up weapons when walking over them
		if self.VJC_Player_CanRespawn or keyPressed then
			ply:Spawn()
			ply:SetHealth(plyData.health)
			ply:SetArmor(plyData.armor)
			for _, v in ipairs(plyData.weapons) do
				ply:Give(v)
			end
			ply:SelectWeapon(plyData.activeWep)
			if plyData.godMode then
				ply:GodEnable()
			end
		end
		if IsValid(npc) then
			ply:SetPos(npc:GetPos() + npc:OBBMaxs() + vecZ20)
		else
			ply:SetPos(self.VJC_NPC_LastPos)
		end
		/*if IsValid(self.VJCE_Camera) then
		ply:SetPos(self.VJCE_Camera:GetPos() + self.VJCE_Camera:GetUp()*100) else
		ply:SetPos(ply:GetPos()) end*/
		ply:SetNoDraw(false)
		ply:DrawShadow(true)
		ply:SetNoTarget(plyData.noTarget)
		//ply:Spectate(OBS_MODE_NONE)
		ply:DrawViewModel(true)
		ply:DrawWorldModel(true)
		//ply:SetMoveType(MOVETYPE_WALK)
		ply.VJ_IsControllingNPC = false
		ply.VJ_TheControllerEntity = NULL
		self:SendDataToClient(true)
	end
	self.VJCE_Player = NULL

	if IsValid(npc) then
		local npcData = self.VJC_SavedVars_NPC
		//npc:StopMoving()
		npc.VJ_IsBeingControlled = false
		npc.VJ_TheController = NULL
		npc.VJ_TheControllerEntity = NULL
		//npc:ClearSchedule()
		if npc.IsVJBaseSNPC then
			npc.DisableWandering = npcData[1]
			npc.DisableChasingEnemy = npcData[2]
			npc.DamageResponse = npcData[3]
			npc.EnemyTouchDetection = npcData[4]
			npc.CallForHelp = npcData[5]
			npc.DamageAllyResponse = npcData[6]
			npc.DeathAllyResponse = npcData[7]
			npc.FollowPlayer = npcData[8]
			npc.CanDetectDangers = npcData[9]
			npc.Passive_RunOnTouch = npcData[10]
			//npc.Passive_RunOnDamage = npcData[11]
			npc.IsGuard = npcData[12]
			npc.CanReceiveOrders = npcData[13]
			npc.EnemyXRayDetection = npcData[14]
			npc:SetFOV(npcData[15])
			npc.CombatDamageResponse = npcData[16]
			npc.BecomeEnemyToPlayer = npcData[17]
			npc.CanEat = npcData[18]
			npc.LimitChaseDistance = npcData[19]
			npc.ConstantlyFaceEnemy = npcData[20]
			npc.IsMedic = npcData[21]
			npc.EnemyDetection = npcData[22]
		end
	end
	self:OnStopControlling(keyPressed)
	//self.VJCE_Camera:Remove()
	self.VJC_Removed = true
	self:Remove()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	if !self.VJC_Removed then
		self:StopControlling()
	end
end