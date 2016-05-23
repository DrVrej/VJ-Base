if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Base 			= "obj_vj_teleport_base"
ENT.Type 			= "anim"
ENT.PrintName 		= "VJ Teleportion Example 2"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "To make teleports."
ENT.Instructions 	= "Don't change anything."
ENT.Category		= "VJ Bases"

if (CLIENT) then
	local Name = "VJ Teleportion Example 2"
	local LangName = "obj_vj_teleportex1"
	language.Add(LangName, Name)
	killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
	language.Add("#"..LangName, Name)
	killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))
end