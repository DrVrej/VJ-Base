/*--------------------------------------------------
	=============== VJ Controls ===============
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ VJ Spawnmenu Controls ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local killIconColor = Color(255, 80, 0, 255)

if !VJ then VJ = {} end -- If VJ isn't initialized, initialize it!

-- Variables ----------------------------------------------------------------------------------------------------
if !VJ.Plugins then VJ.Plugins = {} end
-- Addon Property ----------------------------------------------------------------------------------------------------
VJ.AddAddonProperty = function(aAddonName, aAddonType)
	table.insert(VJ.Plugins, {Name = aAddonName, Type = aAddonType})
end
-- Regular NPC ----------------------------------------------------------------------------------------------------
VJ.AddCategoryInfo = function(acName, acFeatures)
	list.Set("VJBASE_CATEGORY_INFO", acName, {
		icon = acFeatures.Icon or "icon16/monkey.png",
	})
end
-- Regular NPC ----------------------------------------------------------------------------------------------------
VJ.AddNPC = function(nName,nClass,vCat,nAdmin,nFunc)
	local NPC = {Name = nName, Class = nClass, Category = vCat, AdminOnly = nAdmin}
	if (nFunc) then nFunc(NPC) end
	list.Set("NPC", NPC.Class, NPC)
	list.Set("VJBASE_SPAWNABLE_NPC", NPC.Class, NPC)
	if CLIENT then
		language.Add(NPC.Class, NPC.Name)
		killicon.Add(NPC.Class,"HUD/killicons/default",killIconColor)
		language.Add("#"..NPC.Class, NPC.Name)
		killicon.Add("#"..NPC.Class,"HUD/killicons/default",killIconColor)
	end
end
-- Human NPC ----------------------------------------------------------------------------------------------------
VJ.AddNPC_HUMAN = function(nhName,nhClass,nhWeapons,vCat,nhAdmin,nhFunc)
	local NPCH = {Name = nhName, Class = nhClass, Weapons = nhWeapons, Category = vCat, AdminOnly = nhAdmin}
	if (nhFunc) then nhFunc(NPCH) end
	list.Set("NPC", NPCH.Class, NPCH)
	list.Set("VJBASE_SPAWNABLE_NPC", NPCH.Class, NPCH)
	if CLIENT then
		language.Add(NPCH.Class, NPCH.Name)
		killicon.Add(NPCH.Class,"HUD/killicons/default",killIconColor)
		language.Add("#"..NPCH.Class, NPCH.Name)
		killicon.Add("#"..NPCH.Class,"HUD/killicons/default",killIconColor)
	end
end
-- NPC Weapon ----------------------------------------------------------------------------------------------------
VJ.AddNPCWeapon = function(nwName,nwClass)
	local NPCW = {title = nwName, class = nwClass}
	list.Set("NPCUsableWeapons", NPCW.class, NPCW)
	list.Set("VJBASE_SPAWNABLE_NPC_WEAPON", NPCW.class, NPCW)
end
-- Weapon ----------------------------------------------------------------------------------------------------
VJ.AddWeapon = function(wName,wClass,wAdmin,vCat,wFunc)
	local Weapon = {ClassName = wClass, PrintName = wName, Category = vCat, AdminOnly = wAdmin, Spawnable = true}
	if (wFunc) then wFunc(Weapon) end
	list.Set("Weapon", wClass, Weapon)
	list.Set("VJBASE_SPAWNABLE_WEAPON", wClass, Weapon)
	duplicator.Allow(wClass)
end
-- Entity ----------------------------------------------------------------------------------------------------
VJ.AddEntity = function(eName,eClass,eAuthor,eAdmin,eOffSet,eDropToFloor,vCat,eFunc)
	local Ent = {PrintName = eName, ClassName = eClass, Author = eAuthor, AdminOnly = eAdmin, NormalOffset = eOffSet, DropToFloor = eDropToFloor, Category = vCat, Spawnable = true}
	if (eFunc) then eFunc(Ent) end
	list.Set("SpawnableEntities", eClass, Ent)
	list.Set("VJBASE_SPAWNABLE_ENTITIES", eClass, Ent)
	duplicator.Allow(eClass)
end
-- Particle ----------------------------------------------------------------------------------------------------
VJ.AddParticle = function(pFileName,pParticleList)
	game.AddParticles(pFileName)
	for _,v in ipairs(pParticleList) do PrecacheParticleSystem(v) end
end
-- ConVar ----------------------------------------------------------------------------------------------------
VJ.AddConVar = function(cName,cValue,cFlags)
	if !ConVarExists(cName) then
		cFlags = cFlags or {FCVAR_NONE}
		CreateConVar(cName,cValue,cFlags)
	end
end
-- Client ConVar ----------------------------------------------------------------------------------------------------
VJ.AddClientConVar = function(cName,cValue,cHelpText)
	if !ConVarExists(cName) then
		cHelpText = cHelpText or ""
		CreateClientConVar(cName,cValue,true,true,cHelpText)
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