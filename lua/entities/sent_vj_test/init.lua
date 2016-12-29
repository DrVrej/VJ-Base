if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile("shared.lua")
include('shared.lua')
/*--------------------------------------------------
	=============== Test Entity ===============
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to Test Things
--------------------------------------------------*/
ENT.PainSoundT = 0
ENT.MenuOpen = false

util.AddNetworkString("vj_testentity_onmenuopen")
util.AddNetworkString("vj_testentity_runtextsd")
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetModel("models/humans/group01/male_0"..math.random(1,9)..".mdl")
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:SetInitializeCapabilities()
	self:SetUseType(SIMPLE_USE) -- Makes the ENT.Use hook only get called once at every use.
	self:DropToFloor()
	self:SetMaxYawSpeed(25)
	for k, v in pairs(player.GetAll()) do
		self:SetTarget(v)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInitializeCapabilities()
	self:CapabilitiesAdd(bit.bor(CAP_ANIMATEDFACE))
	self:CapabilitiesAdd(bit.bor(CAP_TURN_HEAD))
	self:CapabilitiesAdd(bit.bor(CAP_MOVE_GROUND))
	self:CapabilitiesAdd(bit.bor(CAP_OPEN_DOORS))
	self:CapabilitiesAdd(bit.bor(CAP_AUTO_DOORS))
	self:CapabilitiesAdd(bit.bor(CAP_MOVE_JUMP))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SelectSchedule()
	self:VJ_SetSchedule(SCHED_IDLE_WANDER)
	local MyNearbyTargets = ents.FindInSphere(self:GetPos(),150)
	if (!MyNearbyTargets) then return end
	for k,v in pairs(MyNearbyTargets) do
		if v:IsPlayer() then
			self:VJ_SetSchedule(SCHED_IDLE_STAND)
			self:VJ_SetSchedule(SCHED_TARGET_FACE)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage()
	if CurTime() > self.PainSoundT then
		self:EmitSound("vo/npc/male01/pain0"..math.random(1,9)..".wav")
		self.PainSoundT = CurTime() + 1
	end
	//self:VJ_SetSchedule(SCHED_COWER)
	self:VJ_SetSchedule(SCHED_RUN_FROM_ENEMY)
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AcceptInput(key, activator, caller)
	if key == "Use" && activator:IsPlayer() then
		if activator:IsValid() && activator:Alive() then
			self:SetTarget(activator)
			self:EmitSound(Sound("vj_illuminati/Illuminati Confirmed.mp3"),0)
			umsg.Start("vj_testentity_onmenuopen", activator)
			umsg.End()
			self:EmitSound("vo/npc/male01/hi0"..math.random(1,2)..".wav")
			self:VJ_SetSchedule(SCHED_IDLE_STAND)
			self:VJ_SetSchedule(SCHED_TARGET_FACE)
			self.MenuOpen = true
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
net.Receive("vj_testentity_runtextsd",function(len,pl)
	ply = net.ReadEntity()
	msg = net.ReadString()
	soundfile = net.ReadString()
	PrintMessage(HUD_PRINTTALK,msg)
	PrintMessage(HUD_PRINTCENTER,msg)
	local sd = CreateSound(game.GetWorld(),soundfile)
	sd:SetSoundLevel(0)
	sd:Play()
end)