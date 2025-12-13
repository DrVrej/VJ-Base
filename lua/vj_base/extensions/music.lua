/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
if !CLIENT then return end

local IsValid = IsValid
local table_remove = table.remove

local vj_npc_snd_track_volume = GetConVar("vj_npc_snd_track_volume")

VJ.Music_Queue = {}

net.Receive("vj_music_cl", function(len)
	local ent = net.ReadEntity()
	local sdFile = net.ReadString()
	local sdVol = net.ReadFloat()
	local sdPlayback = net.ReadFloat()
	-- Flags: "noplay" = Forces the sound not to play as soon as this function is called
	sound.PlayFile("sound/" .. sdFile, "noplay", function(sdChan, errorID, errorName)
		if IsValid(sdChan) then
			if #VJ.Music_Queue <= 0 then sdChan:Play() end
			sdChan:EnableLooping(true)
			sdChan:SetPlaybackRate(sdPlayback)
			table.insert(VJ.Music_Queue, {npc = ent, channel = sdChan, npcVolume = sdVol})
		else
			print("[VJ Base Music] Error adding soundtrack!", errorID, errorName)
		end
	end)
	timer.Create("vj_music_think", 1, 0, function()
		//PrintTable(VJ.Music_Queue)
		for k, v in pairs(VJ.Music_Queue) do
			//PrintTable(v)
			if !IsValid(v.npc) then
				v.channel:Stop()
				v.channel = nil
				table_remove(VJ.Music_Queue, k)
			end
		end
		-- No music exists, so stop the thinking
		if #VJ.Music_Queue <= 0 then
			timer.Remove("vj_music_think")
			VJ.Music_Queue = {}
		else
			for _, v in pairs(VJ.Music_Queue) do
				local chan = v.channel
				if IsValid(v.npc) && IsValid(chan) then
					local volOverride = vj_npc_snd_track_volume:GetFloat()
					chan:SetVolume(volOverride == 1 and v.npcVolume or volOverride)
					chan:Play()
					break
				end
			end
		end
	end)
end)