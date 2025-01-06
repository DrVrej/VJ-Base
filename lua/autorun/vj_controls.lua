/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
local killIconColor = Color(255, 80, 0, 255)

if !VJ then VJ = {} end -- If VJ isn't initialized, initialize it!

if !VJ.Plugins then VJ.Plugins = {} end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Registers the addon to the VJ plugin list
		- name = Addon name
		- type = Type of addon | EX: NPC, Weapon, etc.
-----------------------------------------------------------]]
VJ.AddAddonProperty = function(name, type)
	table.insert(VJ.Plugins, {Name = name, Type = type})
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
	if CLIENT then
		language.Add(class, name)
		killicon.Add(class, "HUD/killicons/default", killIconColor)
		language.Add("#" .. class, name)
		killicon.Add("#" .. class, "HUD/killicons/default", killIconColor)
	end
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
	if CLIENT then
		language.Add(class, name)
		killicon.Add(class, "HUD/killicons/default", killIconColor)
		language.Add("#" .. class, name)
		killicon.Add("#" .. class, "HUD/killicons/default", killIconColor)
	end
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
	duplicator.Allow(class)
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
	duplicator.Allow(class)
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
		- flags = Convar's flags | Can be a bitflag or a table | Flag List: https://wiki.facepunch.com/gmod/Enums/FCVAR
		- helpText = Help text to display in the console
		- min = If set, the ConVar cannot be changed to a number lower than this value
		- max = If set, the ConVar cannot be changed to a number higher than this value
-----------------------------------------------------------]]
VJ.AddConVar = function(name, defValue, flags, helpText, min, max)
	if !ConVarExists(name) then
		CreateConVar(name, defValue, flags or FCVAR_NONE, helpText or "", min, max)
	end
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
	if !ConVarExists(name) then
		CreateClientConVar(name, defValue, true, true, helpText or "", min, max)
	end
end