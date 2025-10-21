/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
if !VJ then VJ = {} end

if !VJ.Plugins then VJ.Plugins = {} end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Registers the addon to the VJ Base plugin list
		- name = Addon name
		- type = Type of addon | EX: NPC, Weapon, etc.
		- version = Plugin version | DEFAULT = "N/A"
-----------------------------------------------------------]]
VJ.AddPlugin = function(name, type, version)
	table.insert(VJ.Plugins, {Name = name or "Unknown", Type = type or "N/A", Version = version or "N/A"})
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Registers spawn menu category information
		- name = Category name
		- options = Table that holds all possible options
			- Icon = Category icon
-----------------------------------------------------------]]
VJ.AddCategoryInfo = function(category, options)
	if options.Icon then -- To support default GMod icon list
		list.Set("ContentCategoryIcons", category, options.Icon)
	end
	list.Set("VJBASE_CATEGORY_INFO", category, {
		icon = options.Icon or "icon16/monkey.png",
	})
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Helper function to add kill icons
		- class = Entity class to assign this kill icon to
		- name = Name to display in the kill icon
		- texture = Path to the texture to use for the kill icon | DEFAULT = VJ.KILLICON_DEFAULT
			- Direct path to a texture OR predefined VJ.KILLICON_* enums
			- Use VJ.KILLICON_TYPE_ALIAS to set it to an existing class's kill icon
			- Use VJ.KILLICON_TYPE_FONT to set using a font
		- data = Parameter changes depending on the call type
			- VJ.KILLICON_TYPE_ALIAS : The alias class to use | DEFAULT = "prop_physics"
			- VJ.KILLICON_TYPE_FONT : Table of data | DEFAULT = nil
				- font = Font name
				- symbol = Font symbol to use as the kill icon
				- color = Color of the kill icon | DEFAULT = Color(255, 80, 0, 255)
				- heightScale = Height scale of the kill icon | DEFAULT = 1
			- Everything else : Color of the kill icon | DEFAULT = Color(255, 80, 0, 255)
-----------------------------------------------------------]]
local killIconDefColor = Color(255, 80, 0, 255)
local KILLICON_DEFAULT = VJ.KILLICON_DEFAULT
local KILLICON_TYPE_ALIAS = VJ.KILLICON_TYPE_ALIAS
local KILLICON_TYPE_FONT = VJ.KILLICON_TYPE_FONT
--
local function addKillIcon(class, name, texture, data)
	language.Add(class, name)
	if texture == KILLICON_TYPE_ALIAS then
		killicon.AddAlias(class, data or "prop_physics")
	elseif data && texture == KILLICON_TYPE_FONT then
		killicon.Add(class, data.font, data.symbol, data.color or killIconDefColor, data.heightScale or 1)
	else	
		killicon.Add(class, texture or KILLICON_DEFAULT, data or killIconDefColor)
	end
end
--
VJ.AddKillIcon = addKillIcon
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Adds an NPC to the spawn menu
		- name = NPC's name
		- class = NPC's class
		- category = The spawn menu category it should be in
		- adminOnly = Is this an admin only NPC?
		- customFunc(property) = Used to apply more options (Located in GMod's source code) | EX: OnCeiling, Offset, etc.
-----------------------------------------------------------]]
VJ.AddNPC = function(name, class, category, adminOnly, customFunc)
	local property = {Name = name, Class = class, Category = category, AdminOnly = adminOnly}
	if (customFunc) then customFunc(property) end
	list.Set("NPC", class, property)
	list.Set("VJBASE_SPAWNABLE_NPC", class, property)
	if CLIENT && !killicon.Exists(class) then
		addKillIcon(class, name, KILLICON_DEFAULT)
	end
	duplicator.RegisterEntityClass(class, VJ.CreateDupe_NPC, "Model", "Class", "Equipment", "SpawnFlags", "Data")
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Adds a human NPC to the spawn menu
		- name = NPC's name
		- class = NPC's class
		- weapons = Default weapon list for this NPC
		- category = The spawn menu category it should be in
		- adminOnly = Is this an admin only NPC?
		- customFunc(property) = Used to apply more options (Located in GMod's source code) | EX: OnCeiling, Offset, etc.
-----------------------------------------------------------]]
VJ.AddNPC_HUMAN = function(name, class, weapons, category, adminOnly, customFunc)
	local property = {Name = name, Class = class, Weapons = weapons, Category = category, AdminOnly = adminOnly}
	if (customFunc) then customFunc(property) end
	list.Set("NPC", class, property)
	list.Set("VJBASE_SPAWNABLE_NPC", class, property)
	if CLIENT && !killicon.Exists(class) then
		addKillIcon(class, name, KILLICON_DEFAULT)
	end
	duplicator.RegisterEntityClass(class, VJ.CreateDupe_NPC, "Model", "Class", "Equipment", "SpawnFlags", "Data")
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Adds a weapon to the NPC weapon override list
		- name = Weapon's name
		- class = Weapon's class
		- category = The category group it should be in
-----------------------------------------------------------]]
VJ.AddNPCWeapon = function(name, class, category)
	local property = {title = name, class = class, category = category or "VJ Base"}
	list.Add("NPCUsableWeapons", property)
	list.Add("VJBASE_SPAWNABLE_NPC_WEAPON", property)
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Adds a weapon to the weapon spawn list
		- name = Weapon's name
		- class = Weapon's class
		- adminOnly = Is this an admin only weapon?
		- category = The spawn menu category it should be in
		- customFunc(property) = Used to apply more options (Located in GMod's source code)
-----------------------------------------------------------]]
VJ.AddWeapon = function(name, class, adminOnly, category, customFunc)
	local property = {PrintName = name, ClassName = class, Category = category, AdminOnly = adminOnly, Spawnable = true}
	if (customFunc) then customFunc(property) end
	list.Set("Weapon", class, property)
	list.Set("VJBASE_SPAWNABLE_WEAPON", class, property)
	duplicator.RegisterEntityClass(class, VJ.CreateDupe_Weapon, "Data")
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Adds an entity to the weapon spawn list
		- name = Entity's name
		- class = Entity's class
		- author = Author's name
		- adminOnly = Is this an admin only entity?
		- offset = Spawn offset
		- dropToFloor = Should it drop to the floor on spawn?
		- category = The spawn menu category it should be in
		- customFunc(property) = Used to apply more options (Located in GMod's source code)
-----------------------------------------------------------]]
VJ.AddEntity = function(name, class, author, adminOnly, offset, dropToFloor, category, customFunc)
	local Ent = {PrintName = name, ClassName = class, Author = author, AdminOnly = adminOnly, NormalOffset = offset, DropToFloor = dropToFloor, Category = category, Spawnable = true}
	if (customFunc) then customFunc(Ent) end
	list.Set("SpawnableEntities", class, Ent)
	list.Set("VJBASE_SPAWNABLE_ENTITIES", class, Ent)
	duplicator.RegisterEntityClass(class, VJ.CreateDupe_Entity, "Data")
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Adds and registers a particle file
		- fileName = Addon name | EX: "particles/explosion.pcf"
		- particleList = List of particles to precache from the given particle file
-----------------------------------------------------------]]
VJ.AddParticle = function(fileName, particleList)
	game.AddParticles(fileName)
	for _, name in ipairs(particleList) do
		PrecacheParticleSystem(name)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Registers a ConVar
		- name = Convar name
		- defValue = Default value
		- flags = Convar's flags | Can be a bit flag or a table | Flag List: https://wiki.facepunch.com/gmod/Enums/FCVAR
		- helpText = Help text to display in the console
		- min = If set, the ConVar cannot be changed to a number lower than this value
		- max = If set, the ConVar cannot be changed to a number higher than this value
-----------------------------------------------------------]]
VJ.AddConVar = function(name, defValue, flags, helpText, min, max)
	return CreateConVar(name, defValue, flags or FCVAR_NONE, helpText or "", min, max)
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Registers a client ConVar
		- name = ConVar name
		- defValue = Default value
		- helpText = Help text to display in the console
		- min = If set, the ConVar cannot be changed to a number lower than this value
		- max = If set, the ConVar cannot be changed to a number higher than this value
-----------------------------------------------------------]]
VJ.AddClientConVar = function(name, defValue, helpText, min, max)
	return CreateClientConVar(name, defValue, true, true, helpText or "", min, max)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Backwards Compatibility ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- !!!!!!!!!!!!!! DO NOT USE THESE !!!!!!!!!!!!!!
VJ.AddAddonProperty = VJ.AddPlugin