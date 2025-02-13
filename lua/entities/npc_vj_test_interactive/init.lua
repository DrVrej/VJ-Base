AddCSLuaFile("shared.lua")
include("shared.lua")
/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
ENT.Model = false
ENT.StartHealth = 50
ENT.BloodColor = VJ.BLOOD_COLOR_RED
ENT.Behavior = VJ_BEHAVIOR_PASSIVE
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"}
ENT.AlliedWithPlayerAllies = true
ENT.YieldToAlliedPlayers = false
ENT.FollowPlayer = false

ENT.HasFootStepSound = false
ENT.SoundTbl_Pain = {"vo/npc/male01/pain01.wav", "vo/npc/male01/pain02.wav", "vo/npc/male01/pain03.wav", "vo/npc/male01/pain04.wav", "vo/npc/male01/pain05.wav", "vo/npc/male01/pain06.wav", "vo/npc/male01/pain07.wav", "vo/npc/male01/pain08.wav", "vo/npc/male01/pain09.wav"}

util.AddNetworkString("vj_testentity_onmenuopen")
util.AddNetworkString("vj_testentity_runtextsd")
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
	self.Model = "models/humans/group01/male_0" .. math.random(1, 9) .. ".mdl"
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	if key == "Use" && IsValid(activator) && activator:IsPlayer() && activator:Alive() then
		net.Start("vj_testentity_onmenuopen")
		net.Send(activator)
		activator:EmitSound("vj_base/player/illuminati.mp3", 75)
		self:PlaySoundSystem("Speech", "vo/npc/male01/hi0"..math.random(1, 2)..".wav")
		self:StopMoving()
		self:SetTarget(activator)
		self:SetTurnTarget(activator, -1)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
net.Receive("vj_testentity_runtextsd", function(len, ply)
	local msgType = net.ReadBool()
	if (ply:IsPlayer() && ply:SteamID() == "STEAM_0:0:22688298") or game.SinglePlayer() then
		local msg = (msgType == true and "Are you thirsty?") or "DrVrej is in this server, be aware!"
		local sdFile = (msgType == true and "vj_base/player/areyouthristy.wav") or "vj_base/player/illuminati.mp3"
		PrintMessage(HUD_PRINTTALK, msg)
		PrintMessage(HUD_PRINTCENTER, msg)
		local sd = CreateSound(game.GetWorld(), sdFile, VJ_RecipientFilter)
		sd:SetSoundLevel(0)
		sd:Play()
	end
end)