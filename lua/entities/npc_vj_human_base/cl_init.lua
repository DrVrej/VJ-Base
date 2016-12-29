if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
include('shared.lua')
/*--------------------------------------------------
	=============== Human SNPC Base ===============
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to make human SNPCs
--------------------------------------------------*/
require('sound_vj_track')

ENT.RenderGroup = RENDERGROUP_BOTH
function ENT:Initialize() end
function ENT:Draw() self.Entity:DrawModel() self:CustomOnDraw() end
function ENT:DrawTranslucent() self:Draw() end
function ENT:BuildBonePositions(NumBones,NumPhysBones) end
function ENT:SetRagdollBones(bIn) self.m_bRagdollSetup = bIn end
function ENT:DoRagdollBone(PhysBoneNum,BoneNum) /*self:SetBonePosition(BoneNum,Pos,Angle)*/ end
-- Custom functions ---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDraw() end
---------------------------------------------------------------------------------------------------------------------------------------------
/*net.Receive("vj_human_onthememusic",function(len)
	//BroadcastLua(print("Theme music net code is running!"))
	local selfEntity = net.ReadEntity()
	if !IsValid(selfEntity) then return end
	//print(selfEntity)
	selfEntity.VJ_IsPlayingSoundTrack = true
	selfEntity:SetNetworkedBool("VJ_IsPlayingSoundTrack",true)
	local TracksTable = net.ReadTable()
	local entSoundLevel = net.ReadFloat()
	if !sound_vj_track.IsPlaying(1) then
		sound_vj_track.Play(1,TracksTable,entSoundLevel)
	end
	local t = sound_vj_track.Duration(1)
	if !t then return end
	local tCurTime = RealTime()
	local tmEnd = t + tCurTime

hook.Add("Think","thememusic_client_runtrack",function()
	//local numEnts = #util.VJ_GetSNPCsWithActiveSoundTracks()
	local fadeouttime = net.ReadFloat()
	if RealTime() >= tmEnd && IsValid(selfEntity) then
		tmEnd = RealTime() + sound_vj_track.Duration(1)
		sound_vj_track.Play(1,TracksTable,entSoundLevel)
	end
	//print(#util.VJ_GetSNPCsWithActiveSoundTracks())
	if (!selfEntity:IsValid()) then
	if #util.VJ_GetSNPCsWithActiveSoundTracks() <= 0 then
		sound_vj_track.FadeOut(1,fadeouttime)
		hook.Remove("Think","thememusic_client_runtrack")
		end
	end
 end)
end)*/