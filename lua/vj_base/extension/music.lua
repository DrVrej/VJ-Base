/*--------------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
local IsValid = IsValid
local table_remove = table.remove

if SERVER then
	util.AddNetworkString("vj_music_run")
elseif CLIENT then
	if !VJ then VJ = {} end -- If VJ isn't initialized, initialize it!
	
	VJ.Music_Queue = {}
	
	net.Receive("vj_music_run", function(len)
		local ent = net.ReadEntity()
		local sdFile = net.ReadString()
		local sdVol = net.ReadFloat()
		local sdPlayback = net.ReadFloat()
		-- Flags: "noplay" = Forces the sound not to play as soon as this function is called
		sound.PlayFile("sound/" .. sdFile, "noplay", function(sdChan, errorID, errorName)
			if IsValid(sdChan) then
				if #VJ.Music_Queue <= 0 then sdChan:Play() end
				sdChan:EnableLooping(true)
				sdChan:SetVolume(sdVol)
				sdChan:SetPlaybackRate(sdPlayback)
				table.insert(VJ.Music_Queue, {npc=ent, channel=sdChan})
			else
				print("[VJ Base Music] Error adding sound track!", errorID, errorName)
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
					if IsValid(v.npc) && IsValid(v.channel) then
						v.channel:Play()
						break
					end
				end
			end
		end)
	end)
end