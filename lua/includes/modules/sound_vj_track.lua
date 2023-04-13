/*--------------------------------------------------
	=============== VJ Theme Soundtrack Module ===============
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Thanks to Orion for creating the original code
--------------------------------------------------*/
//AddCSLuaFile()
module("vj_sound_track",package.seeall)
//if SERVER then return end
//print("The Module is running!")
//if CLIENT then
local MetatableMusic = {}
MetatableMusic.__index = MetatableMusic
MUSIC_CHANNEL_INDEX = {[1] = {CurTrack = NULL, CurTrackName = "!"}}
---------------------------------------------------------------------------------------------------------------------------------------------
AddChannel = function()
	MUSIC_CHANNEL_INDEX[#MUSIC_CHANNEL_INDEX+1] = {CurTrack = NULL, CurTrackName = "!"}
	return MUSIC_CHANNEL_INDEX[#MUSIC_CHANNEL_INDEX+1]
end
---------------------------------------------------------------------------------------------------------------------------------------------
GetChannel = function(index)
	return MUSIC_CHANNEL_INDEX[index] or Error("WARNING! VJ SOUNDTRACK CHANNEL DOES NOT EXIST: "..index) or Error("INVALID VJ SOUNDTRACK INPUT!")
end
---------------------------------------------------------------------------------------------------------------------------------------------
Add = function(name,path,dur)
	MetatableMusic[name] = {Path = path, Duration = dur}
end
---------------------------------------------------------------------------------------------------------------------------------------------
Get = function(name)
	return MetatableMusic[name]
end
---------------------------------------------------------------------------------------------------------------------------------------------
GetCurrentTrack = function(chn)
	return GetChannel(chn).CurTrack
end
---------------------------------------------------------------------------------------------------------------------------------------------
SetCurrentTrack = function(chn,csp,name)
	GetChannel(chn).CurTrack = csp
	GetChannel(chn).CurTrackName = name
end
---------------------------------------------------------------------------------------------------------------------------------------------
GetCurrentTrackName = function(chn)
	return GetChannel(chn).CurTrackName
end
---------------------------------------------------------------------------------------------------------------------------------------------
Play = function(chn,vj_sound_track,soundlevel)
	if not vj_sound_track then return print("VJ Soundtrack wasn't able to find any sound to play!") end
	if istable(vj_sound_track) then
		if #vj_sound_track < 1 then return print("VJ Soundtrack didn't play any track since the table is empty!") end -- If the table is empty then end it
		vj_sound_track = vj_sound_track[math.random(1,#vj_sound_track)]
	end
	local CSoundPatch = CreateSound(LocalPlayer(),Get(vj_sound_track).Path)
	CSoundPatch:Play()
	CSoundPatch:SetSoundLevel(soundlevel) -- Play the track globally!
	if (GetCurrentTrack(chn) ~= NULL) && IsPlaying(chn) then
		//Stop(chn)
	end
	SetCurrentTrack(chn,CSoundPatch,vj_sound_track)
	GetChannel(chn).bFaded = false
	print("Current VJ Soundtrack track is "..vj_sound_track.." in channel "..chn)
	//print("Current VJ Soundtrack track in channel "..chn.." = "..vj_sound_track)
end
---------------------------------------------------------------------------------------------------------------------------------------------
IsPlaying = function(chn)
	return (GetCurrentTrack(chn) ~= NULL) && GetCurrentTrack(chn):IsPlaying() && GetChannel(chn).bFaded == false
end
---------------------------------------------------------------------------------------------------------------------------------------------
Stop = function(chn)
	if IsPlaying(chn) then
		GetCurrentTrack(chn):Stop()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
FadeOut = function(chn,tm)
	local tm = tm or 2 -- If no number is set then just fadeout in 2 seconds
	if IsPlaying(chn) then
		GetCurrentTrack(chn):FadeOut(tm)
		GetChannel(chn).bFaded = true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
Duration = function(chn)
	if (not chn) or (chn == nil) or (chn == NULL) then return end
	if GetCurrentTrackName(chn) == "!" then return end
	return MetatableMusic[GetCurrentTrackName(chn)].Duration
 end
//end