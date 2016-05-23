if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Base 			= "obj_vj_teleport_base"
ENT.Type 			= "anim"
ENT.PrintName 		= "VJ Teleportion Example 1"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "To make teleports."
ENT.Instructions 	= "Don't change anything."
ENT.Category		= "VJ Bases"

if (CLIENT) then
	local Name = "VJ Teleportion Example 1"
	local LangName = "obj_bms_hornet"
	language.Add(LangName, Name)
	killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
	language.Add("#"..LangName, Name)
	killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))
end