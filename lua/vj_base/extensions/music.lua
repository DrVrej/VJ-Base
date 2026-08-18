/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
if !CLIENT then return end

VJ.Music_Queue = {}
--
local IsValid = IsValid
local table_remove = table.remove
local vj_npc_snd_track_volume = GetConVar("vj_npc_snd_track_volume")
--
local function VJ_Music_Tick()
	//PrintTable(VJ.Music_Queue)
	-- Clean up the music queue by removing any entries that have an invalid NPC
	local queue = VJ.Music_Queue
	for i = #queue, 1, -1 do
		local v = queue[i]
		local chan = v.channel
		if !IsValid(v.npc) or !IsValid(chan) then
			if IsValid(chan) then chan:Stop() end
			table_remove(queue, i)
		end
	end
	local v = queue[1]
	if !v then -- No music exists, so stop the thinking
		timer.Remove("vj_music_think")
	else
		local volOverride = vj_npc_snd_track_volume:GetFloat()
		v.channel:SetVolume(volOverride == 1 and v.npcVolume or volOverride)
		v.channel:Play()
	end
end
--
net.Receive("vj_music_cl", function(len)
	local ent = net.ReadEntity()
	local sdFile = net.ReadString()
	local sdVol = net.ReadFloat()
	local sdPlayback = net.ReadFloat()
	-- Flags: "noplay" = Forces the sound not to play as soon as this function is called
	sound.PlayFile("sound/" .. sdFile, "noplay", function(sdChan, errorID, errorName)
		if IsValid(sdChan) then
			//if #VJ.Music_Queue <= 0 then sdChan:Play() end -- Plays too soon for menu volume setting to be applied
			sdChan:EnableLooping(true)
			sdChan:SetPlaybackRate(sdPlayback)
			table.insert(VJ.Music_Queue, {npc = ent, channel = sdChan, npcVolume = sdVol})
			timer.Create("vj_music_think", 1, 0, VJ_Music_Tick)
			VJ_Music_Tick()
		else
			print("[VJ Base Music] Error adding soundtrack!", errorID, errorName)
		end
	end)
end)