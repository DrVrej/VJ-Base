/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
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
VJ.AddAddonProperty = VJ.AddPlugin -- !!!!!!!!!!!!!! DO NOT USE !!!!!!!!!!!!!! [Backwards Compatibility!]
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
	//list.Set("VJBASE_CATEGORY_INFO", category, {icon = options.Icon or "icon16/monkey.png"})
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
--
local function addKillIcon(class, name, texture, data)
	language.Add(class, name)
	if texture == VJ.KILLICON_TYPE_ALIAS then
		killicon.AddAlias(class, data or "prop_physics")
	elseif  texture == VJ.KILLICON_TYPE_FONT then
		if !data then return end
		killicon.AddFont(class, data.font, data.symbol, data.color or killIconDefColor, data.heightScale or 1)
	else
		killicon.Add(class, texture or VJ.KILLICON_DEFAULT, data or killIconDefColor)
	end
end
--
VJ.AddKillIcon = addKillIcon
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Adds an entity to the NPC spawn list
		- name = NPC's name
		- class = NPC's class
		- category = Spawn menu category it should be in
		- extra = Extra options to set to the entity | EX: AdminOnly, OnCeiling, Offset, etc.
-----------------------------------------------------------]]
VJ.AddNPC = function(name, class, category, extra, old1)
	local data = {Name = name, Class = class, Category = category}
	if extra != nil then
		if type(extra) == "boolean" then  -- !!!!!!!!!!!!!! DO NOT USE !!!!!!!!!!!!!! [Backwards Compatibility!]
			data.AdminOnly = extra; if old1 then old1(data) end
		else
			table.Merge(data, extra)
		end
	end
	list.Set("NPC", class, data)
	list.Set("VJBASE_SPAWNABLE_NPC", class, data)
	if CLIENT && !killicon.Exists(class) then
		addKillIcon(class, name, VJ.KILLICON_DEFAULT)
	end
	duplicator.RegisterEntityClass(class, VJ.CreateDupe_NPC, "Model", "Class", "Equipment", "SpawnFlags", "Data")
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Adds an entity with weapons to the NPC spawn list
		- name = NPC's name
		- class = NPC's class
		- weapons = Default weapon list for this NPC
		- category = Spawn menu category it should be in
		- extra = Extra options to set to the entity | EX: AdminOnly, OnCeiling, Offset, etc.
-----------------------------------------------------------]]
VJ.AddNPC_HUMAN = function(name, class, weapons, category, extra, old1)
	VJ.AddNPC(name, class, category, table.Merge({Weapons = weapons}, extra or {}), old1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Adds an entity to the NPC weapon override list
		- name = Weapon's name
		- class = Weapon's class
		- category = Group it should be in
-----------------------------------------------------------]]
VJ.AddNPCWeapon = function(name, class, category)
	local data = {title = name, class = class, category = category or "VJ Base"}
	list.Add("NPCUsableWeapons", data)
	list.Add("VJBASE_SPAWNABLE_NPC_WEAPON", data)
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Adds an entity to the weapon spawn list
		- name = Weapon's name
		- class = Weapon's class
		- category = Spawn menu category it should be in
		- extra = Extra options to set to the entity | EX: AdminOnly, etc.
-----------------------------------------------------------]]
VJ.AddWeapon = function(name, class, category, extra, old1)
	local data = {PrintName = name, ClassName = class, Category = category, Spawnable = true}
	if extra != nil then
		if type(category) == "boolean" && type(extra) == "string" then  -- !!!!!!!!!!!!!! DO NOT USE !!!!!!!!!!!!!! [Backwards Compatibility!]
			data.AdminOnly = category; data.Category = extra; if old1 then old1(data) end
		else
			table.Merge(data, extra)
		end
	end
	list.Set("Weapon", class, data)
	list.Set("VJBASE_SPAWNABLE_WEAPON", class, data)
	duplicator.RegisterEntityClass(class, VJ.CreateDupe_Weapon, "Data")
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Adds an entity to the entity spawn list
		- name = Entity's name
		- class = Entity's class
		- category = Spawn menu category it should be in
		- extra = Extra options to set to the entity | EX: AdminOnly, etc.
-----------------------------------------------------------]]
VJ.AddEntity = function(name, class, category, extra, old1, old2, old3, old4)
	local data = {PrintName = name, ClassName = class, Category = category, Spawnable = true, DropToFloor = true}
	if extra != nil then
		if type(category) == "string" && type(extra) == "boolean" && type(old1) == "number" && type(old2) == "boolean" then  -- !!!!!!!!!!!!!! DO NOT USE !!!!!!!!!!!!!! [Backwards Compatibility!]
			data.Author = category; data.AdminOnly = extra; data.NormalOffset = old1; data.DropToFloor = old2; data.Category = old3; if old4 then old4(data) end
		else
			table.Merge(data, extra)
		end
	end
	list.Set("SpawnableEntities", class, data)
	list.Set("VJBASE_SPAWNABLE_ENTITIES", class, data)
	duplicator.RegisterEntityClass(class, VJ.CreateDupe_Entity, "Data")
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Registers a particle file
		- fileName = Particle directory | EX: "particles/explosion.pcf"
		- particleList = List of particles to precache from the given particle file
-----------------------------------------------------------]]
VJ.AddParticle = function(fileDir, particleList)
	game.AddParticles(fileDir)
	if !particleList then return end
	for _, name in ipairs(particleList) do
		PrecacheParticleSystem(name)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Registers a ConVar
		- name = ConVar name
		- defValue = Default value
		- flags = ConVar's flags | Can be a bit flag or a table | Flag List: https://wiki.facepunch.com/gmod/Enums/FCVAR
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
		- save = Whether the ConVar should be saved or reset between sessions
-----------------------------------------------------------]]
VJ.AddClientConVar = function(name, defValue, helpText, min, max, save)
	return CreateClientConVar(name, defValue, save != false, true, helpText or "", min, max)
end