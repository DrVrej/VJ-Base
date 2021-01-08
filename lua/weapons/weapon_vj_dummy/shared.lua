if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "A Dummy Weapon"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose = "This weapon is made for Players and NPCs"
SWEP.Instructions = "Controls are like a regular weapon."
SWEP.Category = "VJ Base Dummies"
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.ViewModel = "" -- The view model (First person)
SWEP.WorldModel = "" -- The world model (Third person, when a NPC is holding it, on ground, etc.)
SWEP.HoldType = "" -- List of holdtypes are in the GMod wiki

/*
-- Pick one of the following options! Delete the option that you have not selected!

-- To allow ONLY NPCs to use it:
SWEP.MadeForNPCsOnly = true -- Is this weapon meant to be for NPCs only?

-- OR Allow both players and NPCs to use this weapon:
SWEP.Spawnable = true
SWEP.AdminOnly = false -- Is this weapon admin only?
*/

-- All functions and variables are located inside the base files. It can be found in the GitHub Repository: https://github.com/DrVrej/VJ-Base