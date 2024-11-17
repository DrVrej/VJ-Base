AddCSLuaFile("shared.lua")
include("shared.lua")
/*--------------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
ENT.VJC_Player_CanExit = true -- Can the player exit the controller?
ENT.VJC_Player_CanRespawn = true -- If false, the player will die when the NPC dies!
ENT.VJC_Player_DrawHUD = true -- Should the controller HUD be displayed?
ENT.VJC_Bullseye_RefreshPos = true -- Should bullseye's position update every tick?
ENT.VJC_NPC_CanTurn = true -- Should the NPC be allowed to turn while idle?
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
ENT.VJC_Data_Player = nil -- A hash table to hold all the values that need to be reset after the player stops controlling
ENT.VJC_Data_NPC = nil -- A hash table to hold all the values that need to be reset after the NPC is uncontrolled
ENT.VJC_Camera_Mode = 1 -- Current camera mode | 1 = Third, 2 = First
ENT.VJC_Camera_CurZoom = Vector(0, 0, 0)
ENT.VJC_Key_Last = BUTTON_CODE_NONE -- The last button the user pressed
ENT.VJC_Key_LastTime = 0 -- Time since the user last pressed a key
ENT.VJC_NPC_LastPos = Vector(0, 0, 0)
ENT.VJC_Removed = false

/* Important entities:
	- self.VJCE_Bullseye	The bullseye entity used for the NPC to target
	- self.VJCE_Camera		The camera object
	- self.VJCE_Player		The player that's controlling
	- self.VJCE_NPC			The NPC that's being controlled
*/

util.AddNetworkString("vj_controller_data")
util.AddNetworkString("vj_controller_cldata")
util.AddNetworkString("vj_controller_hud")

local vecDef = Vector(0, 0, 0)
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
	plyEnt.VJTag_IsControllingNPC = true
	plyEnt.VJ_TheControllerEntity = self
	plyEnt:Spectate(OBS_MODE_CHASE)
	plyEnt:SpectateEntity(camEnt)
	plyEnt:DrawShadow(false)
	plyEnt:SetNoDraw(true)
	plyEnt:SetMoveType(MOVETYPE_OBSERVER)
	plyEnt:DrawViewModel(false)
	plyEnt:DrawWorldModel(false)
	local weps = {}
	for _, v in ipairs(plyEnt:GetWeapons()) do
		weps[#weps + 1] = v:GetClass()
	end
	self.VJC_Data_Player = {
		health = plyEnt:Health(),
		armor = plyEnt:Armor(),
		weapons = weps,
		activeWep = (IsValid(plyEnt:GetActiveWeapon()) and plyEnt:GetActiveWeapon():GetClass()) or "",
		godMode = plyEnt:HasGodMode(), -- Maintain the player's God mode status after exiting the controller
		noTarget = plyEnt:IsFlagSet(FL_NOTARGET)
	}
	plyEnt:SetNoTarget(true)
	plyEnt:StripWeapons()
	if plyEnt:GetInfoNum("vj_npc_cont_diewithnpc", 0) == 1 then self.VJC_Player_CanRespawn = false end

	hook.Add("PlayerButtonDown", self, function(ent, ply, button)
		if ply.VJTag_IsControllingNPC == true && IsValid(ply.VJ_TheControllerEntity) then
			local cent = ply.VJ_TheControllerEntity
			cent.VJC_Key_Last = button
			cent.VJC_Key_LastTime = CurTime()
			cent:OnKeyPressed(button)
			
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

	hook.Add("KeyPress", self, function(ent, ply, key)
		//print(key)
		if ply.VJTag_IsControllingNPC == true && IsValid(ply.VJ_TheControllerEntity) then
			local cent = ply.VJ_TheControllerEntity
			cent:OnKeyBindPressed(key)
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetControlledNPC(npcEnt)
	-- Set the bullseye entity values
	local bullseyeEnt = ents.Create("obj_vj_bullseye")
	bullseyeEnt:SetPos(npcEnt:GetPos() + npcEnt:GetForward()*100 + npcEnt:GetUp()*50) //Vector(npcEnt:OBBMaxs().x +20,0,npcEnt:OBBMaxs().z +20))
	bullseyeEnt:SetModel("models/hunter/blocks/cube025x025x025.mdl")
	//bullseyeEnt:SetParent(npcEnt)
	bullseyeEnt:SetRenderMode(RENDERMODE_NONE)
	bullseyeEnt:Spawn()
	bullseyeEnt:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	bullseyeEnt:SetColor(color0000)
	bullseyeEnt:SetNoDraw(false)
	bullseyeEnt:DrawShadow(false)
	bullseyeEnt.ForceEntAsEnemy = npcEnt
	bullseyeEnt.VJ_IsBeingControlled = true
	self:DeleteOnRemove(bullseyeEnt)
	self.VJCE_Bullseye = bullseyeEnt

	-- Set the NPC values
	if !npcEnt.VJC_Data then
		npcEnt.VJC_Data = {
			CameraMode = 1, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
			ThirdP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in third person
			FirstP_Bone = "ValveBiped.Bip01_Head1", -- If left empty, the base will attempt to calculate a position for first person
			FirstP_Offset = Vector(0, 0, 5), -- The offset for the controller when the camera is in first person
			FirstP_ShrinkBone = true, -- Should the bone shrink? Useful if the bone is obscuring the player's view
		}
	end
	local plyEnt = self.VJCE_Player
	self.VJC_Camera_Mode = npcEnt.VJC_Data.CameraMode -- Get the NPC's default camera mode
	self.VJC_NPC_LastPos = npcEnt:GetPos()
	npcEnt.VJ_IsBeingControlled = true
	npcEnt.VJ_TheController = plyEnt
	npcEnt.VJ_TheControllerEntity = self
	npcEnt.VJ_TheControllerBullseye = bullseyeEnt
	npcEnt:SetEnemy(NULL)
	plyEnt:ChatPrint("#vjbase.print.npccontroller.entrance")
	if npcEnt.IsVJBaseSNPC == true then
		local funcCustom = npcEnt.Controller_IntMsg; if funcCustom then funcCustom(npcEnt, plyEnt, self) end -- !!!!!!!!!!!!!! DO NOT USE THIS FUNCTION !!!!!!!!!!!!!! [Backwards Compatibility!]
		npcEnt:Controller_Initialize(plyEnt, self)
		local EntityEnemy = npcEnt:GetEnemy()
		if IsValid(EntityEnemy) then
			npcEnt:AddEntityRelationship(EntityEnemy, D_NU, 10)
			EntityEnemy:AddEntityRelationship(npcEnt, D_NU, 10)
			npcEnt:ResetEnemy(false)
			npcEnt:SetEnemy(bullseyeEnt)
		end
		self.VJC_Data_NPC = {
			[1] = npcEnt.DisableWandering,
			[2] = npcEnt.DisableChasingEnemy,
			[3] = npcEnt.DisableTakeDamageFindEnemy,
			[4] = npcEnt.DisableTouchFindEnemy,
			[5] = npcEnt.CallForHelp,
			[6] = npcEnt.CallForBackUpOnDamage,
			[7] = npcEnt.BringFriendsOnDeath,
			[8] = npcEnt.FollowPlayer,
			[9] = npcEnt.CanDetectDangers,
			[10] = npcEnt.Passive_RunOnTouch,
			[11] = npcEnt.Passive_RunOnDamage,
			[12] = npcEnt.IsGuard,
			[13] = npcEnt.CanReceiveOrders,
		}
		npcEnt.DisableWandering = true
		npcEnt.DisableChasingEnemy = true
		npcEnt.DisableTakeDamageFindEnemy = true
		npcEnt.DisableTouchFindEnemy = true
		npcEnt.CallForHelp = false
		npcEnt.CallForBackUpOnDamage = false
		npcEnt.BringFriendsOnDeath = false
		npcEnt.FollowPlayer = false
		npcEnt.CanDetectDangers = false
		npcEnt.Passive_RunOnTouch = false
		npcEnt.Passive_RunOnDamage = false
		npcEnt.IsGuard = false
		npcEnt.vACT_StopAttacks = true
		npcEnt.NextThrowGrenadeT = 0
		if npcEnt.Medic_Status then npcEnt:ResetMedicBehavior() end
		if npcEnt.VJTag_IsEating then
			npcEnt:OnEat("StopEating", "Unspecified") -- So it plays the get up animation
			npcEnt:EatingReset("Unspecified")
		end
	end
	-- !!!!!!!!!!!!!! DO NOT USE ANY OF THESE !!!!!!!!!!!!!! [Backwards Compatibility!]
	if self.CustomOnKeyPressed then self.OnKeyPressed = function(_, key) self:CustomOnKeyPressed(key) end end
	if self.CustomOnKeyBindPressed then print("wtf?") self.OnKeyBindPressed = function(_, key) self:CustomOnKeyBindPressed(key) end end
	if self.CustomOnStopControlling then self.OnStopControlling = function(_, keyPressed) self:CustomOnStopControlling(keyPressed) end end
	--
	npcEnt:ClearSchedule()
	npcEnt:StopMoving()
	self.VJCE_NPC = npcEnt
	timer.Simple(0, function() -- This only needs to be 0 seconds because we just need a tick to pass
		if IsValid(self) && IsValid(self.VJCE_NPC) then
			self.VJCE_NPC.vACT_StopAttacks = false
			self.VJCE_NPC:SetEnemy(self.VJCE_Bullseye)
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- Sadly no other way, this is the most reliable way to sync the position from client to server in time
	-- Also avoids garbage positions that output from other methods
net.Receive("vj_controller_cldata", function(len, ply)
	-- Set the controller's bullseye position if the player is controlling an NPC AND controller entity exists AND Bullseye exists --> Protect against spam ?
	if ply.VJTag_IsControllingNPC == true && IsValid(ply.VJ_TheControllerEntity) && ply.VJ_TheControllerEntity.VJC_Bullseye_RefreshPos == true && IsValid(ply.VJ_TheControllerEntity.VJCE_Bullseye) then -- Added a var for toggling the bullseye positioning, this way if one wants to override it they can
		ply.VJ_TheControllerEntity.VJCE_Bullseye:SetPos(net.ReadVector())
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SendDataToClient(reset)
	local ply = self.VJCE_Player
	local npc = self.VJCE_NPC
	local npcData = npc.VJC_Data

	net.Start("vj_controller_data")
		net.WriteBool(ply.VJTag_IsControllingNPC)
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
--
function ENT:Think()
	local ply = self.VJCE_Player
	local npc = self.VJCE_NPC
	local camera = self.VJCE_Camera
	if (!camera:IsValid()) then self:StopControlling() return end
	if !IsValid(ply) /*or ply:KeyDown(IN_USE)*/ or ply:Health() <= 0 or (!ply.VJTag_IsControllingNPC) or !IsValid(npc) or (npc:Health() <= 0) then self:StopControlling() return end
	if ply.VJTag_IsControllingNPC != true then return end
	local curTime = CurTime()
	if ply.VJTag_IsControllingNPC && IsValid(npc) then
		local npcWeapon = npc:GetActiveWeapon()
		self.VJC_NPC_LastPos = npc:GetPos()
		ply:SetPos(self.VJC_NPC_LastPos + vecZ20) -- Set the player's location
		self:SendDataToClient()
		
		-- HUD
		if self.VJC_Player_DrawHUD then
			net.Start("vj_controller_hud")
				net.WriteBool(ply:GetInfoNum("vj_npc_cont_hud", 1) == 1)
				net.WriteFloat(npc:GetMaxHealth())
				net.WriteFloat(npc:Health())
				net.WriteString(npc:GetName())
				net.WriteInt(npc.HasMeleeAttack == true && (((npc.IsAbleToMeleeAttack != true or npc.AttackType == VJ.ATTACK_TYPE_MELEE) and 2) or 1) or 0, 3)
				net.WriteInt(npc.HasRangeAttack == true && (((npc.IsAbleToRangeAttack != true or npc.AttackType == VJ.ATTACK_TYPE_RANGE) and 2) or 1) or 0, 3)
				net.WriteInt(npc.HasLeapAttack == true && (((npc.IsAbleToLeapAttack != true or npc.AttackType == VJ.ATTACK_TYPE_LEAP) and 2) or 1) or 0, 3)
				net.WriteBool(IsValid(npcWeapon))
				net.WriteInt(IsValid(npcWeapon) && npcWeapon:Clip1() or 0, 32)
				net.WriteInt(npc.HasGrenadeAttack == true && ((curTime <= npc.NextThrowGrenadeT and 2) or 1) or 0, 3)
			net.Send(ply)
		end
		
		if #ply:GetWeapons() > 0 then ply:StripWeapons() end

		local bullseyePos = self.VJCE_Bullseye:GetPos()
		if ply:GetInfoNum("vj_npc_cont_devents", 0) == 1 then
			VJ.DEBUG_TempEnt(ply:GetPos(), self:GetAngles(), Color(0,109,160)) -- Player's position
			VJ.DEBUG_TempEnt(camera:GetPos(), self:GetAngles(), Color(255,200,260)) -- Camera's position
			VJ.DEBUG_TempEnt(bullseyePos, self:GetAngles(), Color(255,0,0)) -- Bullseye's position
		end
		
		self:OnThink()

		local canTurn = true
		if npc.Flinching == true or (((npc.CurrentSchedule && !npc.CurrentSchedule.IsPlayActivity) or npc.CurrentSchedule == nil) && npc:GetNavType() == NAV_JUMP) then return end

		-- Weapon attack
		if npc.IsVJBaseSNPC_Human == true then
			if IsValid(npcWeapon) && !npc:IsMoving() && npcWeapon.IsVJBaseWeapon == true && ply:KeyDown(IN_ATTACK2) && npc.AttackType == VJ.ATTACK_TYPE_NONE && npc.vACT_StopAttacks == false && npc:GetWeaponState() == VJ.NPC_WEP_STATE_READY then
				//npc:SetAngles(Angle(0,math.ApproachAngle(npc:GetAngles().y,ply:GetAimVector():Angle().y,100),0))
				npc:SetTurnTarget(bullseyePos, 0.2)
				canTurn = false
				if VJ.IsCurrentAnimation(npc, npc:TranslateActivity(npc.CurrentWeaponAnimation)) == false && VJ.IsCurrentAnimation(npc, npc.AnimTbl_WeaponAttack) == false then
					npc:OnWeaponAttack()
					npc.CurrentWeaponAnimation = VJ.PICK(npc.AnimTbl_WeaponAttack)
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
		
		if npc.IsVJBaseSNPC && npc.CurrentAttackAnimationTime < CurTime() && curTime > npc.NextChaseTime && npc.IsVJBaseSNPC_Tank != true then
			-- Turning
			if !npc:IsMoving() && canTurn && npc.MovementType != VJ_MOVETYPE_PHYSICS && ((npc.IsVJBaseSNPC_Human && npc:GetWeaponState() != VJ.NPC_WEP_STATE_RELOADING) or (!npc.IsVJBaseSNPC_Human)) then
				npc:VJ_TASK_IDLE_STAND()
				if self.VJC_NPC_CanTurn == true then
					local turnData = npc.TurnData
					if turnData.Target != self.VJCE_Bullseye then
						npc:SetTurnTarget(self.VJCE_Bullseye, 1)
					elseif npc:GetActivity() == ACT_IDLE && npc:GetIdealActivity() == ACT_IDLE then -- Check both current act AND ideal act because certain activities only change the current act (Ex: UpdateTurnActivity function)
						npc:UpdateTurnActivity()
						if npc:GetIdealActivity() != ACT_IDLE then -- If ideal act is no longer idle, then we have selected a turn activity!
							npc.NextIdleTime = CurTime() + npc:DecideAnimationLength(npc:GetIdealActivity())
						end
					end
				end
				//self.TestLerp = npc:GetAngles().y
				//npc:SetAngles(Angle(0,Lerp(100*FrameTime(),self.TestLerp,ply:GetAimVector():Angle().y),0))
			end
			
			-- Movement
			npc:Controller_Movement(self, ply, bullseyePos)
			
			//if (ply:KeyDown(IN_USE)) then
				//npc:StopMoving()
				//self:StopControlling()
			//end
		end
	end
	self:NextThink(curTime)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartMovement(Dir, Rot)
	local npc = self.VJCE_NPC
	local ply = self.VJCE_Player
	if npc:GetState() != VJ_STATE_NONE then return end

	local DEBUG = ply:GetInfoNum("vj_npc_cont_devents", 0) == 1
	local plyAimVec = Dir
	plyAimVec.z = 0
	plyAimVec:Rotate(Rot)
	local selfPos = npc:GetPos()
	local centerToPos = npc:OBBCenter():Distance(npc:OBBMins()) + 20 // npc:OBBMaxs().z
	local NPCPos = selfPos + npc:GetUp()*centerToPos
	local groundSpeed = math.Clamp(npc:GetSequenceGroundSpeed(npc:GetSequence()), 300, 9999)
	local defaultFilter = {self, npc, ply}
	local forwardTr = util.TraceLine({start = NPCPos, endpos = NPCPos + plyAimVec * groundSpeed, filter = defaultFilter})
	local forwardDist = NPCPos:Distance(forwardTr.HitPos)
	local wallToSelf = forwardDist - (npc:OBBMaxs().y) -- Use Y instead of X because X is left/right whereas Y is forward/backward
	if DEBUG then
		VJ.DEBUG_TempEnt(NPCPos, self:GetAngles(), Color(0, 255, 255)) -- NPC's calculated position
		VJ.DEBUG_TempEnt(forwardTr.HitPos, self:GetAngles(), Color(255, 255, 0)) -- forward trace position
	end
	if forwardDist >= 25 then
		local finalPos = Vector((selfPos + plyAimVec * wallToSelf).x, (selfPos + plyAimVec * wallToSelf).y, forwardTr.HitPos.z)
		local downTr = util.TraceLine({start = finalPos, endpos = finalPos + self:GetUp()*-(200 + centerToPos), filter = defaultFilter})
		local downDist = (finalPos.z - centerToPos) - downTr.HitPos.z
		if downDist >= 150 then -- If the drop is this big, then don't move!
			//wallToSelf = wallToSelf - downDist -- No need, we are returning anyway
			return
		end
		finalPos = Vector((selfPos + plyAimVec * wallToSelf).x, (selfPos + plyAimVec * wallToSelf).y, forwardTr.HitPos.z)
		if DEBUG then
			VJ.DEBUG_TempEnt(downTr.HitPos, self:GetAngles(), Color(255, 0, 255)) -- Down trace position
			VJ.DEBUG_TempEnt(finalPos, self:GetAngles(), Color(0, 255, 0)) -- Final move position
		end
		npc:SetLastPosition(finalPos)
		npc:VJ_TASK_GOTO_LASTPOS(ply:KeyDown(IN_SPEED) and "TASK_RUN_PATH" or "TASK_WALK_PATH", function(x)
			if ply:KeyDown(IN_ATTACK2) && npc.IsVJBaseSNPC_Human then
				x.FaceData = {Type = VJ.NPC_FACE_ENEMY}
				x.CanShootWhenMoving = true
			else
				if self.VJC_BullseyeTracking then
					x.FaceData = {Type = VJ.NPC_FACE_ENEMY}
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
function ENT:StopControlling(keyPressed)
	//if !IsValid(self.VJCE_Player) then return self:Remove() end
	keyPressed = keyPressed or false
	self:OnStopControlling(keyPressed)

	local npc = self.VJCE_NPC
	local ply = self.VJCE_Player
	if IsValid(ply) then
		local plyData = self.VJC_Data_Player
		ply:UnSpectate()
		ply:KillSilent() -- If we don't, we will get bugs like no being able to pick up weapons when walking over them.
		if self.VJC_Player_CanRespawn == true or keyPressed == true then
			ply:Spawn()
			ply:SetHealth(plyData.health)
			ply:SetArmor(plyData.armor)
			for _, v in ipairs(plyData.weapons) do
				ply:Give(v)
			end
			ply:SelectWeapon(plyData.activeWep)
			if plyData.godMode == true then
				ply:GodEnable()
			end
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
		ply:SetNoTarget(plyData.noTarget)
		//ply:Spectate(OBS_MODE_NONE)
		ply:DrawViewModel(true)
		ply:DrawWorldModel(true)
		//ply:SetMoveType(MOVETYPE_WALK)
		ply.VJTag_IsControllingNPC = false
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
			npc.CallForHelp = npcData[5]
			npc.CallForBackUpOnDamage = npcData[6]
			npc.BringFriendsOnDeath = npcData[7]
			npc.FollowPlayer = npcData[8]
			npc.CanDetectDangers = npcData[9]
			npc.Passive_RunOnTouch = npcData[10]
			npc.Passive_RunOnDamage = npcData[11]
			npc.IsGuard = npcData[12]
			npc.CanReceiveOrders = npcData[13]
		end
	end
	//self.VJCE_Camera:Remove()
	self.VJC_Removed = true
	self:Remove()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	if !self.VJC_Removed then
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