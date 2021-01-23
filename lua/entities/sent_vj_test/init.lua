if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
AddCSLuaFile("shared.lua")
include('shared.lua')
/*--------------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
ENT.PainSoundT = 0

util.AddNetworkString("vj_testentity_onmenuopen")
util.AddNetworkString("vj_testentity_runtextsd")
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetModel("models/humans/group01/male_0"..math.random(1,9)..".mdl")
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE) -- Makes the ENT.Use hook only get called once at every use.
	self:DropToFloor()
	self:SetMaxYawSpeed(20)
	self:CapabilitiesAdd(bit.bor(CAP_ANIMATEDFACE, CAP_TURN_HEAD, CAP_MOVE_GROUND, CAP_OPEN_DOORS, CAP_AUTO_DOORS, CAP_MOVE_JUMP))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SelectSchedule()
	local nearbyEnts = ents.FindInSphere(self:GetPos(),150)
	if (!nearbyEnts) then return end
	for _,v in pairs(nearbyEnts) do
		if v:IsPlayer() && v:Alive() then
			self:SetSchedule(SCHED_IDLE_STAND)
			self:SetSchedule(SCHED_TARGET_FACE)
			return
		end
	end
	self:SetSchedule(SCHED_IDLE_WANDER)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage()
	if CurTime() > self.PainSoundT then
		self:EmitSound("vo/npc/male01/pain0"..math.random(1,9)..".wav")
		self.PainSoundT = CurTime() + 1
		self:SetSchedule(SCHED_RUN_FROM_ENEMY)
	end
	return 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AcceptInput(key, activator, caller)
	if key == "Use" && activator:IsPlayer() && activator:IsValid() && activator:Alive() then
		net.Start("vj_testentity_onmenuopen")
		net.Send(activator)
		self:EmitSound("vj_illuminati/Illuminati Confirmed.mp3", 75)
		self:EmitSound("vo/npc/male01/hi0"..math.random(1,2)..".wav")
		self:SetTarget(activator)
		self:SetSchedule(SCHED_IDLE_STAND)
		self:SetSchedule(SCHED_TARGET_FACE)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
net.Receive("vj_testentity_runtextsd", function(len, ply)
	local msgType = net.ReadBool()
	if (ply:IsPlayer() && ply:SteamID() == "STEAM_0:0:22688298") or (game.SinglePlayer() == true) then
		msg = (msgType == true and "Are you thirsty?") or "DrVrej is in this server, be aware!"
		sdFile = (msgType == true and "vj_illuminati/areyouthristy.wav") or "vj_illuminati/Illuminati Confirmed.mp3"
		PrintMessage(HUD_PRINTTALK, msg)
		PrintMessage(HUD_PRINTCENTER, msg)
		local filter = RecipientFilter()
		filter:AddAllPlayers()
		local sd = CreateSound(game.GetWorld(), sdFile, filter)
		sd:SetSoundLevel(0)
		sd:Play()
	end
end)