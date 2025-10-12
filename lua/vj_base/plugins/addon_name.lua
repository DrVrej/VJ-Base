/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
VJ.AddPlugin("Addon name, Example: Dummy SNPCs", "Addon type(s), Example: NPC", "Version, Example: 1.0.0 OR just remove this parameter to not have a version")

local spawnCategory = "VJ Dummy Category" -- Category, you can also set a category individually by replacing the spawnCategory with a string value
	
/* -- Example Registrations
-- For full list of registration functions and options, navigate to the "lua/autorun/vj_controls.lua" file in VJ Base

-- Entities --
VJ.AddNPC("Dummy NPC", "npc_vj_dum_dummy", spawnCategory) -- Adds a NPC to the spawnmenu
	-- Parameters:
		-- First is the name
		-- Second is the class name
		-- Third is the category that it should be in
		-- Fourth is optional, which is a boolean that defines whether or not it's an admin-only entity
VJ.AddNPC_HUMAN("Dummy Human NPC", "npc_vj_dum_dummy", {"weapon_vj_dummy"}, spawnCategory) -- Adds a NPC to the spawnmenu but with a list of default weapons it spawns with
	-- Parameters:
		-- First is the name
		-- Second is the class name
		-- Third is a table of weapon, the base will pick a random one from the table and give it to the SNPC when "Default Weapon" is selected
		-- Fourth is the category that it should be in
		-- Fifth is optional, which is a boolean that defines whether or not it's an admin-only entity
VJ.AddWeapon("Dummy Weapon", "weapon_vj_dummy", false, spawnCategory) -- Adds a player weapon to the spawnmenu
	-- Parameters:
		-- First is the name
		-- Second is the class name
		-- Third is a boolean that defines whether or not it's an admin-only entity
		-- Fourth is the category that it should be in
VJ.AddNPCWeapon("VJ_Dummy", "weapon_vj_dummy", spawnCategory) -- Adds a weapon to the NPC weapon list
	-- Parameters:
		-- First is the name
		-- Second is the class name
		-- Third is the category that it should be in
VJ.AddEntity("Dummy Entity", "sent_vj_dummy", "Author Name", false, 0, true, spawnCategory) -- Adds an entity to the spawnmenu
	-- Parameters: 
		-- First is the name
		-- Second is the class name
		-- Third is the author name	
		-- Fourth is a boolean that defines whether or not it's an admin-only entity
		-- Fifth is an integer that defines the offset of the entity (When it spawns)
		-- Sixth is a boolean that defines whether or not it should drop to the floor when it spawns
		-- Seventh is the category that it should be in

-- Particles --
VJ.AddParticle("particles/dummy_particle.pcf", {
	"dummy_particle1",
	"dummy_particle2",
})

-- Precache Models --
util.PrecacheModel("models/dummy_model.mdl")

-- ConVars --
VJ.AddConVar("vj_dummy_convar", 100)

*/
