/*--------------------------------------------------
	=============== VJ Controls ===============
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ VJ Spawnmenu Controls ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local killIconColor = Color(255, 80, 0, 255)

if !VJ then VJ = {} end -- If VJ isn't initialized, initialize it!

-- Variables ----------------------------------------------------------------------------------------------------
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

/*
if CLIENT then
local gmod_npcweapon = CreateConVar("gmod_npcweapon","",{FCVAR_ARCHIVE})
spawnmenu.AddContentType( "vjbase_npc", function( container, obj )
	if ( !obj.material ) then return end
	if ( !obj.nicename ) then return end
	if ( !obj.spawnname ) then return end
	if ( !obj.weapon ) then obj.weapon = { "" } end
	local icon = vgui.Create( "ContentIcon", container )
		icon:SetContentType( "vjbase_npc" )
		icon:SetSpawnName( obj.spawnname )
		icon:SetName( obj.nicename )
		icon:SetMaterial( obj.material )
		icon:SetAdminOnly( obj.admin )
		icon:SetNPCWeapon( obj.weapon )
		icon:SetColor(Color(244,164,96,255))
		icon.DoClick = function() 
			local weapon = table.Random( obj.weapon )
			if ( gmod_npcweapon:GetString() != "" ) then weapon = gmod_npcweapon:GetString() end
			RunConsoleCommand( "vjbase_spawnnpc", obj.spawnname, weapon ) 
			surface.PlaySound( "ui/buttonclickrelease.wav" )
		end
		icon.OpenMenu = function( icon ) 
			local menu = DermaMenu()
			local weapon = table.Random( obj.weapon )
			if ( gmod_npcweapon:GetString() != "" ) then weapon = gmod_npcweapon:GetString() end
			menu:AddOption( "Copy to Clipboard", function() SetClipboardText( obj.spawnname ) end )
			menu:AddOption( "Spawn Using Toolgun", function() RunConsoleCommand( "gmod_tool", "creator" ) RunConsoleCommand( "creator_type", "2" ) RunConsoleCommand( "creator_name", obj.spawnname ) RunConsoleCommand( "creator_arg", weapon ) end )
			menu:AddSpacer()
			menu:AddOption( "Delete", function() icon:Remove() hook.Run( "SpawnlistContentChanged", icon ) end )
			menu:Open()
		end
	if (IsValid(container)) then
		container:Add(icon)
	end
	return icon
end)
-------------------------------------------------------------------------------------------------------------------------
hook.Add("PopulateVJBaseWeapons","AddVJBaseSpawnMenu_weapon",function(pnlContent,tree,node)
	local weapontree = tree:AddNode("Weapons", "icon16/gun.png")
	local Weapons = list.Get("VJBASE_SPAWNABLE_WEAPON")  -- Get a list of available Weapons
	local WeaponCatagory = {}
	for k, weapon in pairs( Weapons ) do
		if ( !weapon.Spawnable ) then continue end
		WeaponCatagory[ weapon.Category ] = WeaponCatagory[ weapon.Category ] or {}
		table.insert( WeaponCatagory[ weapon.Category ], weapon )
	end
	Weapons = nil
	for CategoryName, v in SortedPairs(WeaponCatagory) do -- Create an icon for each one and put them on the panel
		local node = weapontree:AddNode(CategoryName,"icon16/page_white_go.png") -- Add a node to the tree
		node.DoPopulate = function(self) -- When we click on the node - populate it using this function
			if ( self.PropPanel ) then return end -- If we've already populated it - forget it.
			self.PropPanel = vgui.Create("ContentContainer", pnlContent) -- Create the container panel
			self.PropPanel:SetVisible( false )
			self.PropPanel:SetTriggerSpawnlistChange( false )
			for k, ent in SortedPairsByMemberValue( v, "PrintName" ) do
				spawnmenu.CreateContentIcon( ent.ScriptedEntityType or "weapon", self.PropPanel, 
				{ 
					nicename	= ent.PrintName or ent.ClassName,
					spawnname	= ent.ClassName,
					material	= "entities/"..ent.ClassName..".png",
					admin		= ent.AdminOnly
				})
			end
		end
		node.DoClick = function(self) -- If we click on the node populate it and switch to it.
			self:DoPopulate()		
			pnlContent:SwitchPanel( self.PropPanel );
		end
	end
	//local FirstNode = tree:Root():GetChildNode(0) -- Select the first node
	//if ( IsValid( FirstNode ) ) then
		//FirstNode:InternalDoClick()
	//end
	weapontree:SetExpanded(true)
end)
-------------------------------------------------------------------------------------------------------------------------
hook.Add("PopulateVJBaseEntities","AddVJBaseSpawnMenu_Entity",function(pnlContent,tree,node)
	local entitytree = tree:AddNode("Entities", "icon16/bricks.png")
	local EntitiesCategories = {}
	local EntitiesList = list.Get("VJBASE_SPAWNABLE_ENTITIES") -- Get a list of available Entities
	if (EntitiesList) then
		for k, v in pairs(EntitiesList) do
			v.SpawnName = k
			v.Category = v.Category or "Other"
			EntitiesCategories[ v.Category ] = EntitiesCategories[ v.Category ] or {}
			table.insert( EntitiesCategories[ v.Category ], v )
		end
	end
	for CategoryName, v in SortedPairs(EntitiesCategories) do -- Create an icon for each one and put them on the panel
		local node = entitytree:AddNode(CategoryName,"icon16/page_white_go.png") -- Add a node to the tree
		node.DoPopulate = function(self) -- When we click on the node - populate it using this function
			if ( self.PropPanel ) then return end -- If we've already populated it - forget it.
			self.PropPanel = vgui.Create("ContentContainer", pnlContent) -- Create the container panel
			self.PropPanel:SetVisible( false )
			self.PropPanel:SetTriggerSpawnlistChange( false )
			for k, ent in SortedPairsByMemberValue( v, "PrintName" ) do
				spawnmenu.CreateContentIcon( ent.ScriptedEntityType or "entity", self.PropPanel, 
				{ 
					nicename	= ent.PrintName or ent.ClassName,
					spawnname	= ent.SpawnName,
					material	= "entities/"..ent.SpawnName..".png",
					admin		= ent.AdminOnly
				})
			end
		end
		node.DoClick = function(self) -- If we click on the node populate it and switch to it.
			self:DoPopulate()		
			pnlContent:SwitchPanel( self.PropPanel );
		end
	end
	//local FirstNode = tree:Root():GetChildNode(0) -- Select the first node
	//if ( IsValid( FirstNode ) ) then
		//FirstNode:InternalDoClick()
	//end
	entitytree:SetExpanded(true)
end)
-------------------------------------------------------------------------------------------------------------------------
hook.Add("PopulateVJBaseNPC","AddVJBaseSpawnMenu_NPC",function(pnlContent,tree,node)
	local npctree = tree:AddNode("NPCs", "icon16/monkey.png")
	local NPCList = list.Get("VJBASE_SPAWNABLE_NPC") -- Get a list of available NPCs
	local NPCCategories = {} -- Categorize them
	for k, v in pairs(NPCList) do
		local Category = v.Category or "Other"
		local Tab = NPCCategories[Category] or {}
		Tab[ k ] = v
		NPCCategories[Category] = Tab
	end
	for CategoryName, v in SortedPairs(NPCCategories) do -- Create an icon for each one and put them on the panel
		local node = npctree:AddNode(CategoryName,"icon16/page_white_go.png") -- Add a node to the tree
		node.DoPopulate = function(self) -- When we click on the node - populate it using this function
			if ( self.PropPanel ) then return end -- If we've already populated it - forget it.
			self.PropPanel = vgui.Create("ContentContainer", pnlContent) -- Create the container panel
			self.PropPanel:SetVisible( false )
			self.PropPanel:SetTriggerSpawnlistChange( false )
			for name, ent in SortedPairsByMemberValue( v, "Name" ) do
				spawnmenu.CreateContentIcon( "vjbase_npc", self.PropPanel, 
				{ 
					nicename	= ent.Name or name,
					spawnname	= name,
					material	= "entities/"..name..".png",
					weapon		= ent.Weapons,
					admin		= ent.AdminOnly
				})
			end
		end
		node.DoClick = function(self) -- If we click on the node populate it and switch to it.
			self:DoPopulate()		
			pnlContent:SwitchPanel(self.PropPanel)
		end	
	end
	//local FirstNode = tree:Root():GetChildNode(0) -- Select the first node
	//if (IsValid(FirstNode)) then
		//FirstNode:InternalDoClick()
	//end
	npctree:SetExpanded(true)
end)
-------------------------------------------------------------------------------------------------------------------------
spawnmenu.AddCreationTab("VJ Base",function()
	local ctrl = vgui.Create("SpawnmenuContentPanel")
	ctrl:CallPopulateHook("PopulateVJBaseWeapons")
	ctrl:CallPopulateHook("PopulateVJBaseEntities")
	ctrl:CallPopulateHook("PopulateVJBaseNPC")
	return ctrl
end, "icon16/plugin.png", 60 )
*/