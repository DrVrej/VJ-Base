AddCSLuaFile("shared.lua")
include('shared.lua')
/*--------------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
ENT.VJC_Player_CanExit = true -- Can the player exit the controller?
ENT.VJC_Player_CanRespawn = true -- If false, the player will die when the NPC dies!
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

util.AddNetworkString("vj_controller_data")
util.AddNetworkString("vj_controller_cldata")
util.AddNetworkString("vj_controller_hud")
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetModel("models/props_junk/watermelon01_chunk02c.mdl")
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
	//self:StartControlling()
	self:CustomOnInitialize()
end
---------------------------------------------------------------------------------------------------------------------------------------------
local color0000 = Color(0, 0, 0, 0)
function ENT:StartControlling()
	-- Set up the camera entity
	self.VJCE_Camera = ents.Create("prop_dynamic")
	self.VJCE_Camera:SetPos(self.VJCE_NPC:GetPos() + Vector(0, 0, self.VJCE_NPC:OBBMaxs().z)) //self.VJCE_NPC:EyePos()
	self.VJCE_Camera:SetModel("models/props_junk/watermelon01_chunk02c.mdl")
	self.VJCE_Camera:SetParent(self.VJCE_NPC)
	self.VJCE_Camera:SetRenderMode(RENDERMODE_NONE)
	self.VJCE_Camera:Spawn()
	self.VJCE_Camera:SetColor(color0000)
	self.VJCE_Camera:SetNoDraw(false)
	self.VJCE_Camera:DrawShadow(false)
	self:DeleteOnRemove(self.VJCE_Camera)
	
	-- Set up the player
	self.VJCE_Player.IsControlingNPC = true
	self.VJCE_Player.VJ_TheControllerEntity = self
	self.VJCE_Player:Spectate(OBS_MODE_CHASE)
	//self.VJCE_Player:SetPos(self.VJCE_Camera:GetPos())
	self.VJCE_Player:SpectateEntity(self.VJCE_Camera)
	self.VJCE_Player:SetNoTarget(true)
	self.VJCE_Player:DrawShadow(false)
	self.VJCE_Player:SetNoDraw(true)
	self.VJCE_Player:SetMoveType(MOVETYPE_OBSERVER)
	self.VJCE_Player:DrawViewModel(false)
	self.VJCE_Player:DrawWorldModel(false)
	local weps = {}
	for _, v in pairs(self.VJCE_Player:GetWeapons()) do
		weps[#weps+1] = v:GetClass()
	end
	self.VJC_Data_Player = {
		[1] = self.VJCE_Player:Health(),
		[2] =self.VJCE_Player:Armor(),
		[3] = weps,
		[4] = (IsValid(self.VJCE_Player:GetActiveWeapon()) and self.VJCE_Player:GetActiveWeapon():GetClass()) or "",
	}
	self.VJCE_Player:StripWeapons()
	if self.VJCE_Player:GetInfoNum("vj_npc_cont_diewithnpc", 0) == 1 then self.VJC_Player_CanRespawn =false end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetControlledNPC(GetEntity)
	-- Set the bullseye entity values
	self.VJCE_Bullseye = ents.Create("obj_vj_bullseye")
	self.VJCE_Bullseye:SetPos(GetEntity:GetPos() + GetEntity:GetForward()*100 + GetEntity:GetUp()*50)//Vector(GetEntity:OBBMaxs().x +20,0,GetEntity:OBBMaxs().z +20))
	self.VJCE_Bullseye:SetModel("models/hunter/blocks/cube025x025x025.mdl")
	//self.VJCE_Bullseye:SetParent(GetEntity)
	self.VJCE_Bullseye:SetRenderMode(RENDERMODE_NONE)
	self.VJCE_Bullseye:Spawn()
	self.VJCE_Bullseye:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	self.VJCE_Bullseye.EnemyToIndividual = true
	self.VJCE_Bullseye.EnemyToIndividualEnt = GetEntity
	self.VJCE_Bullseye:SetColor(color0000)
	self.VJCE_Bullseye:SetNoDraw(false)
	self.VJCE_Bullseye:DrawShadow(false)
	self:DeleteOnRemove(self.VJCE_Bullseye)

	-- Set the NPC values
	self.VJCE_NPC = GetEntity
	if !self.VJCE_NPC.VJC_Data then
		self.VJCE_NPC.VJC_Data ={
			CameraMode = 1, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
			ThirdP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in third person
			FirstP_Bone = "ValveBiped.Bip01_Head1", -- If left empty, the base will attempt to calculate a position for first person
			FirstP_Offset = Vector(0, 0, 5), -- The offset for the controller when the camera is in first person
			FirstP_ShrinkBone = true, -- Should the bone shrink? Useful if the bone is obscuring the player's view
		}
	end
	self.VJC_Camera_Mode = self.VJCE_NPC.VJC_Data.CameraMode -- Get the NPC's default camera mode
	self.VJC_NPC_LastPos = self.VJCE_NPC:GetPos()
	self.VJCE_NPC.VJ_IsBeingControlled = true
	self.VJCE_NPC.VJ_TheController = self.VJCE_Player
	self.VJCE_NPC.VJ_TheControllerEntity = self
	self.VJCE_NPC.VJ_TheControllerBullseye = self.VJCE_Bullseye
	self.VJCE_NPC:SetEnemy(NULL)
	self.VJCE_NPC.Enemy = NULL
	self.VJCE_NPC:VJ_Controller_InitialMessage(self.VJCE_Player, self)
	if self.VJCE_NPC.IsVJBaseSNPC == true then
		self.VJCE_NPC:Controller_Initialize(self.VJCE_Player, self)
		if IsValid(self.VJCE_NPC:GetEnemy()) then
			self.VJCE_NPC:AddEntityRelationship(self.VJCE_NPC:GetEnemy(), D_NU, 99)
			self.VJCE_NPC:GetEnemy():AddEntityRelationship(self.VJCE_NPC, D_NU, 99)
			self.VJCE_NPC:ResetEnemy(false)
			self.VJCE_NPC:SetEnemy(self.VJCE_Bullseye)
		end
		self.VJC_Data_NPC = {
			[1] = self.VJCE_NPC.DisableWandering,
			[2] = self.VJCE_NPC.DisableChasingEnemy,
			[3] = self.VJCE_NPC.DisableTakeDamageFindEnemy,
			[4] = self.VJCE_NPC.DisableTouchFindEnemy,
			[5] = self.VJCE_NPC.DisableSelectSchedule,
			[6] = self.VJCE_NPC.CallForHelp,
			[7] = self.VJCE_NPC.CallForBackUpOnDamage,
			[8] = self.VJCE_NPC.BringFriendsOnDeath,
			[9] = self.VJCE_NPC.FollowPlayer,
			[10] = self.VJCE_NPC.CanDetectGrenades,
			[11] = self.VJCE_NPC.Passive_RunOnTouch,
			[12] = self.VJCE_NPC.Passive_RunOnDamage,
			[13] = self.VJCE_NPC.IsGuard,
		}
		self.VJCE_NPC.DisableWandering = true
		self.VJCE_NPC.DisableChasingEnemy = true
		self.VJCE_NPC.DisableTakeDamageFindEnemy = true
		self.VJCE_NPC.DisableTouchFindEnemy = true
		self.VJCE_NPC.DisableSelectSchedule = true
		self.VJCE_NPC.CallForHelp = false
		self.VJCE_NPC.CallForBackUpOnDamage = false
		self.VJCE_NPC.BringFriendsOnDeath = false
		self.VJCE_NPC.FollowPlayer = false
		self.VJCE_NPC.CanDetectGrenades = false
		self.VJCE_NPC.Passive_RunOnTouch = false
		self.VJCE_NPC.Passive_RunOnDamage = false
		self.VJCE_NPC.IsGuard = false
		
		self.VJCE_NPC.vACT_StopAttacks = true
		self.VJCE_NPC.NextThrowGrenadeT = 0
	end
	self.VJCE_NPC:ClearSchedule()
	self.VJCE_NPC:StopMoving()
	timer.Simple(0.2, function()
		if IsValid(self.VJCE_NPC) then
			self.VJCE_NPC.vACT_StopAttacks = false
			self.VJCE_NPC:SetEnemy(self.VJCE_Bullseye)
		end
	end)
	self:CustomOnSetControlledNPC()
end
local vecr = Vector(0, 0, 0)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerButtonDown", "vj_controller_PlayerButtonDown", function(ply, button)
	//print(button)
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
			cent.VJC_Camera_CurZoom = vecr
		end
	end
end)
hook.Add("KeyPress", "vj_controller_KeyPress", function(ply, key)
	//print(key)
	if ply.IsControlingNPC == true && IsValid(ply.VJ_TheControllerEntity) then
		local cent = ply.VJ_TheControllerEntity
		cent:CustomOnKeyBindPressed(key)
	end
end)
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
	net.Start("vj_controller_data")
	net.WriteBool(self.VJCE_Player.IsControlingNPC)
	net.WriteUInt((reset == true and nil) or self.VJCE_Camera:EntIndex(), 14)
	net.WriteUInt((reset == true and nil) or self.VJCE_NPC:EntIndex(), 14)
	net.WriteUInt((reset == true and 1) or self.VJC_Camera_Mode, 2)
	net.WriteVector((reset == true and vecr) or (self.VJCE_NPC.VJC_Data.ThirdP_Offset + self.VJC_Camera_CurZoom))
	net.WriteVector((reset == true and vecr) or self.VJCE_NPC.VJC_Data.FirstP_Offset)
	local bone = -1
	if reset != true then
		bone = self.VJCE_NPC:LookupBone(self.VJCE_NPC.VJC_Data.FirstP_Bone) or -1
	end
	net.WriteInt(bone, 10)
	net.WriteBool((reset != true and self.VJCE_NPC.VJC_Data.FirstP_ShrinkBone) or false)
	net.WriteUInt((reset != true and self.VJCE_NPC.VJC_Data.FirstP_CameraBoneAng) or 0, 2)
	net.WriteInt((reset != true and self.VJCE_NPC.VJC_Data.FirstP_CameraBoneAng_Offset) or 0, 10)
	net.Send(self.VJCE_Player)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	if (!self.VJCE_Camera:IsValid()) then self:StopControlling() return end
	if !IsValid(self.VJCE_Player) /*or self.VJCE_Player:KeyDown(IN_USE)*/ or self.VJCE_Player:Health() <= 0 or (!self.VJCE_Player.IsControlingNPC) or !IsValid(self.VJCE_NPC) or (self.VJCE_NPC:Health() <= 0) then self:StopControlling() return end
	if self.VJCE_Player.IsControlingNPC != true then return end
	if self.VJCE_Player.IsControlingNPC && IsValid(self.VJCE_NPC) then
		self.VJC_NPC_LastPos = self.VJCE_NPC:GetPos()
		self.VJCE_Player:SetPos(self.VJC_NPC_LastPos + Vector(0, 0, 20)) -- Set the player's location
		self:SendDataToClient()
		
		-- HUD
		local AttackTypes = {MeleeAttack=false, RangeAttack=false, LeapAttack=false, WeaponAttack=false, GrenadeAttack=false, Ammo="---"}
		if self.VJCE_NPC.IsVJBaseSNPC == true then
			if self.VJCE_NPC.HasMeleeAttack == true then AttackTypes["MeleeAttack"] = ((self.VJCE_NPC.IsAbleToMeleeAttack != true or self.VJCE_NPC.MeleeAttacking == true) and 2) or true end
			if self.VJCE_NPC.HasRangeAttack == true then AttackTypes["RangeAttack"] = ((self.VJCE_NPC.IsAbleToRangeAttack != true or self.VJCE_NPC.RangeAttacking == true) and 2) or true end
			if self.VJCE_NPC.HasLeapAttack == true then AttackTypes["LeapAttack"] = ((self.VJCE_NPC.IsAbleToLeapAttack != true or self.VJCE_NPC.LeapAttacking == true) and 2) or true end
			if IsValid(self.VJCE_NPC:GetActiveWeapon()) then AttackTypes["WeaponAttack"] = true AttackTypes["Ammo"] = self.VJCE_NPC:GetActiveWeapon():Clip1() end
			if self.VJCE_NPC.HasGrenadeAttack == true then AttackTypes["GrenadeAttack"] = (CurTime() <= self.VJCE_NPC.NextThrowGrenadeT and 2) or true end
		end
		net.Start("vj_controller_hud")
		net.WriteBool(self.VJCE_Player:GetInfoNum("vj_npc_cont_hud", 1) == 1)
		net.WriteFloat(self.VJCE_NPC:GetMaxHealth())
		net.WriteFloat(self.VJCE_NPC:Health())
		net.WriteString(self.VJCE_NPC:GetName())
		net.WriteTable(AttackTypes)
		net.Send(self.VJCE_Player)
		
		if #self.VJCE_Player:GetWeapons() > 0 then self.VJCE_Player:StripWeapons() end
		-- Depreciated, the hit position is now sent by the net message
		/*local tr_ply = util.TraceLine({start = self.VJCE_Player:EyePos(), endpos = self.VJCE_Player:EyePos() + (self.VJCE_Player:GetAimVector() * 32768), filter = {self.VJCE_Player,self.VJCE_NPC}})
		if IsValid(self.VJCE_Bullseye) then
			self.VJCE_Bullseye:SetPos(tr_ply.HitPos)
		end*/
		local pos_beye = self.VJCE_Bullseye:GetPos()
		if self.VJCE_Player:GetInfoNum("vj_npc_cont_devents", 0) == 1 then
			VJ_CreateTestObject(self.VJCE_Player:GetPos(), self:GetAngles(), Color(0,109,160))
			VJ_CreateTestObject(self.VJCE_Camera:GetPos(), self:GetAngles(), Color(255,200,260))
			VJ_CreateTestObject(pos_beye, self:GetAngles(), Color(255,0,0)) -- Bullseye's position
		end
		
		self:CustomOnThink()
		local canTurn = true

		-- Weapon attack
		if IsValid(self.VJCE_NPC:GetActiveWeapon()) && self.VJCE_NPC.IsVJBaseSNPC == true && self.VJCE_NPC.IsVJBaseSNPC_Human == true && !self.VJCE_NPC:IsMoving() && self.VJCE_NPC:GetActiveWeapon().IsVJBaseWeapon == true && self.VJCE_Player:KeyDown(IN_ATTACK2) && self.VJCE_NPC.IsReloadingWeapon == false && self.VJCE_NPC.MeleeAttacking == false && self.VJCE_NPC.ThrowingGrenade == false && self.VJCE_NPC.vACT_StopAttacks == false && self.VJCE_NPC:GetWeaponState() != VJ_WEP_STATE_HOLSTERED then
			//self.VJCE_NPC:SetAngles(Angle(0,math.ApproachAngle(self.VJCE_NPC:GetAngles().y,self.VJCE_Player:GetAimVector():Angle().y,100),0))
			self.VJCE_NPC:FaceCertainPosition(pos_beye, 0.2)
			canTurn = false
			if VJ_IsCurrentAnimation(self.VJCE_NPC, self.VJCE_NPC:TranslateToWeaponAnim(self.VJCE_NPC.CurrentWeaponAnimation)) == false && VJ_IsCurrentAnimation(self.VJCE_NPC, self.VJCE_NPC.AnimTbl_WeaponAttack) == false then
				self.VJCE_NPC.CurrentWeaponAnimation = VJ_PICK(self.VJCE_NPC.AnimTbl_WeaponAttack)
				self.VJCE_NPC:VJ_ACT_PLAYACTIVITY(self.VJCE_NPC.CurrentWeaponAnimation, false, 2, false)
				self.VJCE_NPC.DoingWeaponAttack = true
				self.VJCE_NPC.DoingWeaponAttack_Standing = true
			end
		end
		
		if self.VJCE_NPC.Flinching == true or (((self.VJCE_NPC.CurrentSchedule && self.VJCE_NPC.CurrentSchedule.IsPlayActivity != true) or self.VJCE_NPC.CurrentSchedule == nil) && self.VJCE_NPC:GetNavType() == NAV_JUMP) then return end
		
		-- Turning
		if !self.VJCE_NPC:IsMoving() && self.VJCE_NPC.PlayingAttackAnimation == false && canTurn && self.VJCE_NPC.IsReloadingWeapon != true && CurTime() > self.VJCE_NPC.NextChaseTime && self.VJCE_NPC.IsVJBaseSNPC_Tank != true && self.VJCE_NPC.MovementType != VJ_MOVETYPE_PHYSICS then
			//self.VJCE_NPC:SetAngles(Angle(0,self.VJCE_Player:GetAimVector():Angle().y,0))
			local angdif = math.abs(math.AngleDifference(self.VJCE_Player:EyeAngles().y, self.VJC_NPC_LastIdleAngle))
			self.VJC_NPC_LastIdleAngle = self.VJCE_NPC:EyeAngles().y //tr_ply.HitPos
			self.VJCE_NPC:VJ_TASK_IDLE_STAND()
			if ((self.VJCE_NPC.MovementType != VJ_MOVETYPE_STATIONARY) or (self.VJCE_NPC.MovementType == VJ_MOVETYPE_STATIONARY && self.VJCE_NPC.CanTurnWhileStationary == true)) then
				if (VJ_AnimationExists(self.VJCE_NPC, ACT_TURN_LEFT) == false && VJ_AnimationExists(self.VJCE_NPC, ACT_TURN_RIGHT) == false) or (angdif <= 50 && self.VJCE_NPC:GetActivity() != ACT_TURN_LEFT && self.VJCE_NPC:GetActivity() != ACT_TURN_RIGHT) then
					//self.VJCE_NPC:VJ_TASK_IDLE_STAND()
					self.VJCE_NPC:FaceCertainPosition(pos_beye, 0.1)
				else
					self.NextIdleStandTime = 0
					self.VJCE_NPC:SetLastPosition(pos_beye) // self.VJCE_Player:GetEyeTrace().HitPos
					self.VJCE_NPC:VJ_TASK_FACE_X("TASK_FACE_LASTPOSITION")
				end
			end
			//self.TestLerp = self.VJCE_NPC:GetAngles().y
			//self.VJCE_NPC:SetAngles(Angle(0,Lerp(100*FrameTime(),self.TestLerp,self.VJCE_Player:GetAimVector():Angle().y),0))
		end
		
		-- Movement
		if self.VJCE_NPC.MovementType != VJ_MOVETYPE_STATIONARY && self.VJCE_NPC.PlayingAttackAnimation == false && CurTime() > self.VJCE_NPC.NextChaseTime && self.VJCE_NPC.IsVJBaseSNPC_Tank != true then
			local gerta_for = self.VJCE_Player:KeyDown(IN_FORWARD)
			local gerta_bac = self.VJCE_Player:KeyDown(IN_BACK)
			local gerta_lef = self.VJCE_Player:KeyDown(IN_MOVELEFT)
			local gerta_rig = self.VJCE_Player:KeyDown(IN_MOVERIGHT)
			local gerta_arak = self.VJCE_Player:KeyDown(IN_SPEED)
			
			if gerta_for then
				if self.VJCE_NPC.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then
					self.VJCE_NPC:AA_MoveTo(self.VJCE_Bullseye, true, gerta_arak and "Alert" or "Calm", {IgnoreGround=true})
				else
					if gerta_lef then
						self:StartMovement(self.VJCE_Player:GetAimVector(), Angle(0,45,0))
					elseif gerta_rig then
						self:StartMovement(self.VJCE_Player:GetAimVector(), Angle(0,-45,0))
					else
						self:StartMovement(self.VJCE_Player:GetAimVector(), Angle(0,0,0))
					end
				end
			elseif gerta_bac then
				if gerta_lef then
					self:StartMovement(self.VJCE_Player:GetAimVector()*-1, Angle(0,-45,0))
				elseif gerta_rig then
					self:StartMovement(self.VJCE_Player:GetAimVector()*-1, Angle(0,45,0))
				else
					self:StartMovement(self.VJCE_Player:GetAimVector()*-1, Angle(0,0,0))
				end
			elseif gerta_lef then
				self:StartMovement(self.VJCE_Player:GetAimVector(), Angle(0,90,0))
			elseif gerta_rig then
				self:StartMovement(self.VJCE_Player:GetAimVector(), Angle(0,-90,0))
			else
				self.VJCE_NPC:StopMoving()
				if self.VJCE_NPC.MovementType == VJ_MOVETYPE_AERIAL or self.VJCE_NPC.MovementType == VJ_MOVETYPE_AQUATIC then self.VJCE_NPC:AA_StopMoving() end
			end
			/*if (self.VJCE_Player:KeyDown(IN_USE)) then
				self.VJCE_NPC:StopMoving()
				self:StopControlling()
			end*/
		end
	end
	self:NextThink(CurTime() + (0.069696968793869 + FrameTime()))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartMovement(Dir, Rot)
	if self.VJCE_NPC:GetState() != VJ_STATE_NONE then return end
	local DontMove = false
	local PlyAimVec = Dir
	PlyAimVec.z = 0
	PlyAimVec:Rotate(Rot)
	local CenterToPos = self.VJCE_NPC:OBBCenter():Distance(self.VJCE_NPC:OBBMins()) + 20 // self.VJCE_NPC:OBBMaxs().z
	local NPCPos = self.VJCE_NPC:GetPos() + self.VJCE_NPC:GetUp()*CenterToPos
	local groundSpeed = math.Clamp(self.VJCE_NPC:GetSequenceGroundSpeed(self.VJCE_NPC:GetSequence()), 300, 9999)
	local forwardtr = util.TraceLine({start = NPCPos, endpos = NPCPos + PlyAimVec*groundSpeed, filter = {self,self.VJCE_Player,self.VJCE_NPC}})
	//local npcvel = self.VJCE_NPC:GetGroundSpeedVelocity()
	//if self.VJCE_NPC:GetMovementActivity() > 0 then print(self.VJCE_NPC:GetSequenceGroundSpeed(self.VJCE_NPC:SelectWeightedSequence(self.VJCE_NPC:GetMovementActivity()))) end
	//self.VJCE_NPC:GetSequenceGroundSpeed(self.VJCE_NPC:SelectWeightedSequence(self.VJCE_NPC:GetActivity()))
	//Vector(math.abs(npcvel.x),math.abs(npcvel.y),math.abs(npcvel.z))
	local CalculateWallToNPC = NPCPos:Distance(forwardtr.HitPos) - (self.VJCE_NPC:OBBMaxs().x * 2)
	if self.VJCE_Player:GetInfoNum("vj_npc_cont_devents", 0) == 1 then
		VJ_CreateTestObject(NPCPos, self:GetAngles(), Color(0,255,255)) -- NPC's calculated position
		VJ_CreateTestObject(forwardtr.HitPos, self:GetAngles(), Color(255,255,0)) -- forward trace position
	end
	if NPCPos:Distance(forwardtr.HitPos) >= 51 then
		local FinalPos = Vector((self.VJCE_NPC:GetPos()+PlyAimVec*CalculateWallToNPC).x,(self.VJCE_NPC:GetPos()+PlyAimVec*CalculateWallToNPC).y,forwardtr.HitPos.z)
		local downtr = util.TraceLine({start = FinalPos, endpos = FinalPos + self:GetUp()*-(200+CenterToPos), filter = {self,self.VJCE_Player,self.VJCE_NPC}})
		local CalculateDownDistance = (FinalPos.z-CenterToPos) - downtr.HitPos.z
		if CalculateDownDistance >= 150 then -- If the drop is this big, then don't move!
			DontMove = true
			CalculateWallToNPC = CalculateWallToNPC - CalculateDownDistance
		end
		FinalPos = Vector((self.VJCE_NPC:GetPos()+PlyAimVec*CalculateWallToNPC).x, (self.VJCE_NPC:GetPos()+PlyAimVec*CalculateWallToNPC).y, forwardtr.HitPos.z)
		if self.VJCE_Player:GetInfoNum("vj_npc_cont_devents", 0) == 1 then
			VJ_CreateTestObject(downtr.HitPos, self:GetAngles(), Color(255,0,255)) -- Down trace position
			VJ_CreateTestObject(FinalPos, self:GetAngles(), Color(0,255,0)) -- Final move position
		end
		if DontMove == false then
			self.VJCE_NPC:SetLastPosition(FinalPos)
			local movetype = "TASK_WALK_PATH"
			if (self.VJCE_Player:KeyDown(IN_SPEED)) then movetype = "TASK_RUN_PATH" end
			self.VJCE_NPC:VJ_TASK_GOTO_LASTPOS(movetype,function(x)
				//self.VJCE_NPC:SetLastPosition(self.VJCE_Player:GetEyeTrace().HitPos)
				if self.VJCE_Player:KeyDown(IN_ATTACK2) && self.VJCE_NPC.IsVJBaseSNPC_Human == true then
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

	if IsValid(self.VJCE_Player) then
		self.VJCE_Player:UnSpectate()
		self.VJCE_Player:KillSilent() -- If we don't, we will get bugs like no being able to pick up weapons when walking over them.
		if self.VJC_Player_CanRespawn == true or endKey == true then
			self.VJCE_Player:Spawn()
			self.VJCE_Player:SetHealth(self.VJC_Data_Player[1])
			self.VJCE_Player:SetArmor(self.VJC_Data_Player[2])
			for _, v in pairs(self.VJC_Data_Player[3]) do
				self.VJCE_Player:Give(v)
			end
			self.VJCE_Player:SelectWeapon(self.VJC_Data_Player[4])
		end
		if IsValid(self.VJCE_NPC) then
			self.VJCE_Player:SetPos(self.VJCE_NPC:GetPos() + self.VJCE_NPC:OBBMaxs() + Vector(0, 0, 20))
		else
			self.VJCE_Player:SetPos(self.VJC_NPC_LastPos)
		end
		/*if IsValid(self.VJCE_Camera) then
		self.VJCE_Player:SetPos(self.VJCE_Camera:GetPos() +self.VJCE_Camera:GetUp()*100) else
		self.VJCE_Player:SetPos(self.VJCE_Player:GetPos()) end*/
		self.VJCE_Player:SetNoDraw(false)
		self.VJCE_Player:DrawShadow(true)
		self.VJCE_Player:SetNoTarget(false)
		//self.VJCE_Player:Spectate(OBS_MODE_NONE)
		self.VJCE_Player:DrawViewModel(true)
		self.VJCE_Player:DrawWorldModel(true)
		//self.VJCE_Player:SetMoveType(MOVETYPE_WALK)
		self.VJCE_Player.IsControlingNPC = false
		self.VJCE_Player.VJ_TheControllerEntity = NULL
		self:SendDataToClient(true)
	end
	self.VJCE_Player = NULL

	if IsValid(self.VJCE_NPC) then
		//self.VJCE_NPC:StopMoving()
		self.VJCE_NPC.VJ_IsBeingControlled = false
		self.VJCE_NPC.VJ_TheController = NULL
		self.VJCE_NPC.VJ_TheControllerEntity = NULL
		//self.VJCE_NPC:ClearSchedule()
		if self.VJCE_NPC.IsVJBaseSNPC == true then
			self.VJCE_NPC.DisableWandering = self.VJC_Data_NPC[1]
			self.VJCE_NPC.DisableChasingEnemy = self.VJC_Data_NPC[2]
			self.VJCE_NPC.DisableTakeDamageFindEnemy = self.VJC_Data_NPC[3]
			self.VJCE_NPC.DisableTouchFindEnemy = self.VJC_Data_NPC[4]
			self.VJCE_NPC.DisableSelectSchedule = self.VJC_Data_NPC[5]
			self.VJCE_NPC.CallForHelp = self.VJC_Data_NPC[6]
			self.VJCE_NPC.CallForBackUpOnDamage = self.VJC_Data_NPC[7]
			self.VJCE_NPC.BringFriendsOnDeath = self.VJC_Data_NPC[8]
			self.VJCE_NPC.FollowPlayer = self.VJC_Data_NPC[9]
			self.VJCE_NPC.CanDetectGrenades = self.VJC_Data_NPC[10]
			self.VJCE_NPC.Passive_RunOnTouch = self.VJC_Data_NPC[11]
			self.VJCE_NPC.Passive_RunOnDamage = self.VJC_Data_NPC[12]
			self.VJCE_NPC.IsGuard = self.VJC_Data_NPC[13]
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
