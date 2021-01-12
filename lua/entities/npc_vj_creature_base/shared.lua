if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Base 			= "base_entity"
ENT.Type 			= "ai"
ENT.PrintName 		= "VJ Creature SNPC Base"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "To make SNPCs."
ENT.Instructions 	= "Don't change anything."
ENT.Category		= "VJ Base"

ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.AutomaticFrameAdvance = false

ENT.IsVJBaseSNPC = true -- Is it a VJ Base SNPC?
ENT.IsVJBaseSNPC_Creature = true -- Is it a VJ Base creature?
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetAutomaticFrameAdvance(val)
	self.AutomaticFrameAdvance = val
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MatFootStepQCEvent(data)
	-- Return true to apply all changes done to the data table.
	-- Return false to prevent the sound from playing.
	-- Return nil or nothing to play the sound without altering it.
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
/*if (CLIENT) then
	local Name = "rrrrrrrrrrrrrrrrrr"
	local LangName = "rrrrrrrrrrrrrrrrrr"
	language.Add(LangName, Name)
	killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
	language.Add("#"..LangName, Name)
	killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))
end*/