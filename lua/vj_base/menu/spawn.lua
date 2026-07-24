/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Hooks ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	local translatedCategories = {
		["VJ Base"] = "Default",
		["Other"] = "#spawnmenu.category.other",
		["Animals"] = "#spawnmenu.category.animals",
		["Combine"] = "#spawnmenu.category.combine",
		["Humans + Resistance"] = "#spawnmenu.category.humans_resistance",
		["Zombies + Enemy Aliens"] = "#spawnmenu.category.zombies_aliens",
		["Fun + Games"] = "#spawnmenu.category.fun_games",
	}
	--
	local function populateTree(pnlContent, tree, browseNode, rootName, rootIcon, spawnList)
		local rootTree = tree:AddNode(rootName, rootIcon)
		timer.Simple(0.4, function() rootTree:SetExpanded(true, true) end) -- Timer is needed otherwise top folder will be minimized
		local rootPropPanel = vgui.Create("ContentContainer", pnlContent)
			rootPropPanel:SetVisible(false)
			rootPropPanel:SetTriggerSpawnlistChange(false) -- Make it read-only so it can't be edited
		rootTree.PropPanel = rootPropPanel
		function rootTree:Root() -- "DTree_Node" doesn't have this method, make it pretend to be a "DTree"
			return pnlContent.ContentNavBar.Tree.RootNode
		end
		function rootTree:DoClick()
			pnlContent:SwitchPanel(self.PropPanel)
		end
		
		-- Build each category and its content icons
		if rootName == "NPCs" then
			pnlContent:PopulateFromList(spawnList, rootTree, {
				SortName = "Name",
				CategoryIcon = rootIcon,
				TranslateNames = translatedCategories,
				CreateIconFunc = function(ent, propPanel)
					return spawnmenu.CreateContentIcon(ent.ScriptedEntityType or "npc", propPanel, {
						nicename	= ent.Name or ent.SpawnName,
						spawnname	= ent.SpawnName,
						material	= ent.IconOverride or ("entities/" .. ent.SpawnName .. ".png"),
						weapon		= ent.Weapons,
						admin		= ent.AdminOnly
					})
				end
			})
		elseif rootName == "Weapons" then
			pnlContent:PopulateFromList(spawnList, rootTree, {
				SortName = "PrintName",
				CategoryIcon = rootIcon,
				TranslateNames = translatedCategories,
				CreateIconFunc = function(ent, propPanel)
					return spawnmenu.CreateContentIcon(ent.ScriptedEntityType or "weapon", propPanel, {
						nicename	= ent.PrintName or ent.ClassName,
						spawnname	= ent.ClassName,
						material	= ent.IconOverride or ("entities/" .. ent.ClassName .. ".png"),
						admin		= ent.AdminOnly
					})
				end
			})
		elseif rootName == "Entities" then
			pnlContent:PopulateFromList(spawnList, rootTree, {
				SortName = "PrintName",
				CategoryIcon = rootIcon,
				TranslateNames = translatedCategories,
				CreateIconFunc = function(ent, propPanel)
					return spawnmenu.CreateContentIcon(ent.ScriptedEntityType or "entity", propPanel, {
						nicename	= ent.PrintName or ent.SpawnName,
						spawnname	= ent.SpawnName,
						material	= ent.IconOverride or ("entities/" .. ent.SpawnName .. ".png"),
						admin		= ent.AdminOnly
					})
				end
			})
		end
		
		-- Build root folders
			-- catName [string]   |   catNode [DTree_Node]
			-- catNode.PropPanel [ContentContainer]   |   catNode.PropPanel.IconList [DTileLayout]   |   catNode.PropPanel.IconList child [ContentIcon]
		for catName, catNode in pairs(rootTree.Categories) do
			catNode:DoPopulate() -- Force it to generate now otherwise "catNode.PropPanel" will be nil!
			if catName == "Default" then
				catNode:SetIcon("vj_base/icons/vrejgaming.png")
			end
			if !catNode.PropPanel then return end
			local catHeader = vgui.Create("ContentHeader", rootPropPanel) -- Add each category as a header
				catHeader:SetText(catName)
			rootPropPanel:Add(catHeader)
			for _, child in ipairs(catNode.PropPanel.IconList:GetChildren()) do -- Add all the icons from each category
				rootPropPanel:Add(child:Copy())
			end
		end
	end
	--[-------------------------------------------------------]--
	hook.Add("VJBASE_MENU_SPAWN", "VJBASE_MENU_SPAWN", function(pnlContent, tree, browseNode)
		populateTree(pnlContent, tree, browseNode, "NPCs", "icon16/monkey.png", "VJBASE_SPAWNABLE_NPC")
		populateTree(pnlContent, tree, browseNode, "Weapons", "icon16/gun.png", "VJBASE_SPAWNABLE_WEAPON")
		populateTree(pnlContent, tree, browseNode, "Entities", "icon16/bricks.png", "VJBASE_SPAWNABLE_ENTITIES")
		
		-- START: Tools category
		local toolTree = tree:AddNode("Tools", "icon16/bullet_wrench.png")
		local toolList = spawnmenu.GetTools()
		if toolList then
			for _, nv in pairs(toolList) do
				if nv.Name == "DrVrej" then
					for _, nv2 in pairs(nv.Items) do
						if nv2.ItemName == "Tools" then
							//local node = toolTree:AddNode("Default", "icon16/bullet_wrench.png")
							local catPropPanel = vgui.Create("ContentContainer", pnlContent)
							catPropPanel:SetVisible(false)
							catPropPanel:SetTriggerSpawnlistChange(false) -- Make it read-only so it can't be edited
							for _, tool in pairs(nv2) do
								if !istable(tool) then continue end
								spawnmenu.CreateContentIcon("tool", catPropPanel, {
									nicename	= tool.Text,
									spawnname	= tool.ItemName,
								})
							end
							function toolTree:DoClick()
								pnlContent:SwitchPanel(catPropPanel)
							end
						end
					end
				end
			end
		end
		-- END: Tools category
	end)
	
	--[-------------------------------------------------------]--
	-- Adds the searching functionality for the VJ Base spawn menu.
	-- Based on: https://github.com/Facepunch/garrysmod/blob/master/garrysmod/gamemodes/sandbox/gamemode/cl_search_models.lua
	search.AddProvider( function( str )

		local results = {}
		
		local function AddSearchProvider( listname, ctype )
			for name_c, v in pairs( list.Get( listname ) ) do
				if ( !istable( v ) ) then continue end -- Some mod doing something wrong
				if ( listname == "VJBASE_SPAWNABLE_WEAPON" and !v.Spawnable ) then continue end

				local name = v.PrintName or v.Name
				if ( !isstring( name ) and !isstring( name_c ) ) then continue end

				local name_lang = ( isstring( name ) and language.GetPhrase( name ) or name )
				if ( ( isstring( name_lang ) and name_lang:lower():find( str, nil, true ) ) or
					( isstring( name_c ) and name_c:lower():find( str, nil, true ) ) ) then

					local contentIconData = {
						nicename = name or name_c,
						spawnname = name_c,
						material = "entities/" .. name_c .. ".png",
						admin = v.AdminOnly
					}

					if ( listname == "VJBASE_SPAWNABLE_NPC" ) then contentIconData.weapon = v.Weapons end

					local entry = {
						text = name or name_c,
						icon = spawnmenu.CreateContentIcon( ctype or "entity", nil, contentIconData ),
						words = { v }
					}

					table.insert( results, entry )

				end

				//if ( #results >= sbox_search_maxresults:GetInt() / 4 ) then break end

			end
		end
		AddSearchProvider("VJBASE_SPAWNABLE_NPC", "npc")
		AddSearchProvider("VJBASE_SPAWNABLE_WEAPON", "weapon")
		AddSearchProvider("VJBASE_SPAWNABLE_ENTITIES", "entity")

		table.SortByMember( results, "text", true )
		return results

	end, "vjbase" )

	--[-------------------------------------------------------]--
	-- Create the main spawn menu tab, set it to be placed after the default "Vehicles" tab
	if VJBASE_DISABLE_MENU_SPAWN != true then
		spawnmenu.AddCreationTab("VJ Base", function()
			local ctrl = vgui.Create("SpawnmenuContentPanel")
			ctrl:EnableSearch("vjbase", "VJBASE_MENU_SPAWN")
			ctrl:CallPopulateHook("VJBASE_MENU_SPAWN")
			
			local sidebar = ctrl.ContentNavBar
			sidebar.Options = vgui.Create("VJ_SpawnmenuNPCSidebarToolbox", sidebar)
			sidebar.Options:Dock(BOTTOM)
		
			return ctrl
		end, "vj_base/icons/vrejgaming.png", 60, "All VJ Base entities are located here!") // icon16/plugin.png
	end
	
	--[-------------------------------------------------------]--
	-- Based on: https://github.com/Facepunch/garrysmod/blob/master/garrysmod/gamemodes/sandbox/gamemode/spawnmenu/creationmenu/content/contenttypes/npcs.lua
	local PANEL = {}
	Derma_Hook(PANEL, "Paint", "Paint", "Tree")
	PANEL.m_bBackground = true -- Hack for above

	function PANEL:AddCheckbox(text, cvar)
		local DermaCheckbox = self:Add("DCheckBoxLabel", self)
		DermaCheckbox:Dock(TOP)
		DermaCheckbox:SetText(text)
		DermaCheckbox:SetDark(true)
		DermaCheckbox:SetConVar(cvar)
		DermaCheckbox:SizeToContents()
		DermaCheckbox:DockMargin(0, 5, 0, 0)
	end

	function PANEL:Init()
		self:SetOpenSize(150)
		self:DockPadding(15, 10, 15, 10)

		self:AddCheckbox("#vjbase.menu.spawn.npc.disablethinking", "ai_disabled")
		self:AddCheckbox("#vjbase.menu.spawn.npc.ignoreplayers", "ai_ignoreplayers")
		self:AddCheckbox("#vjbase.menu.spawn.npc.keepcorpses", "ai_serverragdolls")
		self:AddCheckbox("#vjbase.menu.spawn.npc.guard", "vj_npc_spawn_guard")
		
		local label = vgui.Create( "DLabel", self )
		label:Dock( TOP )
		label:DockMargin( 0, 5, 0, 0 )
		label:SetDark( true )
		label:SetText( "#menubar.npcs.weapon" )

		local DComboBox = vgui.Create( "DComboBox", self )
		DComboBox:Dock( TOP )
		DComboBox:DockMargin( 0, 0, 0, 0 )
		DComboBox:SetConVar( "gmod_npcweapon" )
		DComboBox:SetSortItems( false )

		DComboBox:AddChoice( "#menubar.npcs.defaultweapon", "", false, "icon16/gun.png" )
		DComboBox:AddChoice( "#menubar.npcs.noweapon", "none", false, "icon16/cross.png" )
		DComboBox:AddSpacer()

		local CustomIcons = list.Get( "ContentCategoryIcons" )
		-- Sort the items by name, and group by category
		local groupedWeps = {}
		for _, v in pairs( list.Get( "VJBASE_SPAWNABLE_NPC_WEAPON" ) ) do
			local cat = (v.category or ""):lower()
			groupedWeps[ cat ] = groupedWeps[ cat ] or {}
			groupedWeps[ cat ][ v.class ] = { title = language.GetPhrase( v.title ), icon = CustomIcons[ v.category or "" ] or "icon16/gun.png" }
		end

		for _, items in SortedPairs( groupedWeps ) do
			DComboBox:AddSpacer()
			for class, info in SortedPairsByMemberValue( items, "title" ) do
				DComboBox:AddChoice( info.title, class, false, info.icon )
			end
		end

		function DComboBox:OnSelect( index, value )
			self:ConVarChanged( self.Data[ index ] )
		end

		self:Open()
	end
	vgui.Register("VJ_SpawnmenuNPCSidebarToolbox", PANEL, "DDrawer")
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ NPC Duplicator & Save Support ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Based on: https://github.com/Facepunch/garrysmod/blob/master/garrysmod/gamemodes/sandbox/gamemode/commands.lua
--
local function InternalSpawnNPC( NPCData, ply, Position, Normal, Class, Equipment, SpawnFlagsSaved, NoDropToFloor )

	-- Don't let them spawn this entity if it isn't in our NPC Spawn list.
	-- We don't want them spawning any entity they like!
	if ( !NPCData ) then return NULL end

	local isAdmin = ( IsValid( ply ) && ply:IsAdmin() ) or game.SinglePlayer()
	if ( NPCData.AdminOnly && !isAdmin ) then return NULL end

	local bDropToFloor = false
	local wasSpawnedOnCeiling = false
	local wasSpawnedOnFloor = false

	--
	-- This NPC has to be spawned on a ceiling (Barnacle) or a floor (Turrets)
	--
	if ( NPCData.OnCeiling or NPCData.OnFloor ) then
		local isOnCeiling	= Vector( 0, 0, -1 ):Dot( Normal ) >= 0.95
		local isOnFloor		= Vector( 0, 0,  1 ):Dot( Normal ) >= 0.95

		-- Not on ceiling, and we can't be on floor
		if ( !isOnCeiling && !NPCData.OnFloor ) then return NULL end

		-- Not on floor, and we can't be on ceiling
		if ( !isOnFloor && !NPCData.OnCeiling ) then return NULL end

		-- We can be on either, and we are on neither
		if ( !isOnFloor && !isOnCeiling ) then return NULL end

		wasSpawnedOnCeiling = isOnCeiling
		wasSpawnedOnFloor = isOnFloor
	else
		bDropToFloor = true
	end

	if ( NPCData.NoDrop or NoDropToFloor ) then bDropToFloor = false end

	-- Create NPC
	local NPC = ents.Create( NPCData.Class )
	if ( !IsValid( NPC ) ) then return NULL end

	--
	-- Offset the position
	--
	local Offset = NPCData.Offset or 32
	NPC:SetPos( Position + Normal * Offset )

	-- Rotate to face player (expected behaviour)
	local Angles = Angle( 0, 0, 0 )

	if ( IsValid( ply ) ) then
		Angles = ply:GetAngles()
	end

	Angles.pitch = 0
	Angles.roll = 0
	Angles.yaw = Angles.yaw + 180

	if ( NPCData.Rotate ) then Angles = Angles + NPCData.Rotate end

	NPC:SetAngles( Angles )

	if ( NPCData.SnapToNormal ) then
		NPC:SetAngles( Normal:Angle() )
	end

	--
	-- Does this NPC have a specified model? If so, use it.
	--
	local NPCModel = NPCData.Model
	if ( istable( NPCModel ) ) then NPCModel = NPCModel[ math.random( #NPCModel ) ] end
	if ( NPCModel ) then
		NPC:SetModel( NPCModel )
	end

	--
	-- Does this NPC have a specified material? If so, use it.
	--
	if ( NPCData.Material ) then
		NPC:SetMaterial( NPCData.Material )
	end

	--
	-- Spawn Flags
	--
	local SpawnFlags = bit.bor( SF_NPC_FADE_CORPSE, SF_NPC_ALWAYSTHINK )
	if ( NPCData.SpawnFlags ) then SpawnFlags = bit.bor( SpawnFlags, NPCData.SpawnFlags ) end
	if ( NPCData.TotalSpawnFlags ) then SpawnFlags = NPCData.TotalSpawnFlags end
	if ( SpawnFlagsSaved ) then SpawnFlags = SpawnFlagsSaved end
	NPC:SetKeyValue( "spawnflags", SpawnFlags )
	NPC.SpawnFlags = SpawnFlags

	--
	-- Optional Key Values
	--
	local squadName = nil
	if ( NPCData.KeyValues ) then
		for k, v in pairs( NPCData.KeyValues ) do
			NPC:SetKeyValue( k, v )

			if ( string.lower( k ) == "squadname" ) then squadName = v end
		end
	end

	--
	-- Handle squads being overflown.
	--
	local MAX_SQUAD_MEMBERS	= 16
	if ( squadName and ai.GetSquadMemberCount( squadName ) >= MAX_SQUAD_MEMBERS ) then

		-- Find first open squad
		local sqNum = 0
		while ( ai.GetSquadMemberCount( squadName .. sqNum ) >= MAX_SQUAD_MEMBERS ) do
			sqNum = sqNum + 1
		end

		NPC:SetKeyValue( "SquadName", squadName .. sqNum )
	end

	--
	-- Does this NPC have a specified skin? If so, use it.
	--
	if ( NPCData.Skin ) then
		NPC:SetSkin( NPCData.Skin )
	end

	--
	-- What weapon this NPC should be carrying
	--

	-- Check if this is a valid weapon from the list, or the user is trying to fool us.
	local valid = false
	for _, v in pairs( list.Get( "NPCUsableWeapons" ) ) do
		if ( v.class == Equipment ) then valid = true break end
	end
	for _, v in pairs( NPCData.Weapons or {} ) do
		if ( v == Equipment ) then valid = true break end
	end

	if ( Equipment && Equipment != "none" && valid ) then
		NPC:SetKeyValue( "additionalequipment", Equipment )
		NPC.Equipment = Equipment
	end

	if ( wasSpawnedOnCeiling && isfunction( NPCData.OnCeiling ) ) then
		NPCData.OnCeiling( NPC )
	elseif ( wasSpawnedOnFloor && isfunction( NPCData.OnFloor ) ) then
		NPCData.OnFloor( NPC )
	end

	-- Allow special case for duplicator stuff
	if ( isfunction( NPCData.OnDuplicated ) ) then
		NPC.OnDuplicated = NPCData.OnDuplicated
	end

	DoPropSpawnedEffect( NPC )

	NPC:Spawn()
	NPC:Activate()

	-- Store spawnmenu data for addons and stuff
	NPC.NPCName = Class
	NPC._wasSpawnedOnCeiling = wasSpawnedOnCeiling

	-- For those NPCs that set their model/skin in Spawn function
	-- We have to keep the call above for NPCs that want a model set by Spawn() time
	-- BAD: They may adversly affect entity collision bounds
	if ( NPCModel && NPC:GetModel():lower() != NPCModel:lower() ) then
		NPC:SetModel( NPCModel )
	end
	if ( NPCData.Skin ) then
		NPC:SetSkin( NPCData.Skin )
	end

	if ( bDropToFloor ) then
		NPC:DropToFloor()
	end

	if ( NPCData.Health ) then
		NPC:SetHealth( NPCData.Health )
		NPC:SetMaxHealth( NPCData.Health )
	end

	-- Body groups
	if ( NPCData.BodyGroups ) then
		for k, v in pairs( NPCData.BodyGroups ) do
			NPC:SetBodygroup( k, v )
		end
	end

	return NPC

end
-------------------------------------------------------------------------------------------------------------------------
VJ.CreateDupe_NPC = function( ply, mdl, class, equipment, spawnflags, data )

	-- Match the behavior of Spawn_NPC above - class should be the one in the list, NOT the entity class!
	if ( data.NPCName ) then class = data.NPCName end

	if ( IsValid( ply ) && !gamemode.Call( "PlayerSpawnNPC", ply, class, equipment ) ) then return NULL end

	local NPCData = list.GetEntry( "NPC", class )

	local normal = Vector( 0, 0, 1 )
	if ( NPCData && NPCData.OnCeiling && ( NPCData.OnFloor && data._wasSpawnedOnCeiling or !NPCData.OnFloor ) ) then
		normal = Vector( 0, 0, -1 )
	end

	local ent = InternalSpawnNPC( NPCData, ply, data.Pos, normal, class, equipment, spawnflags, true )
	if ( IsValid( ent ) ) then

		local pos = ent:GetPos() -- Hack! Prevents the NPCs from falling through the floor

		duplicator.DoGeneric( ent, data )

		if ( NPCData && !NPCData.OnCeiling && !NPCData.NoDrop ) then
			ent:SetPos( pos )
		end

		if ( IsValid( ply ) ) then
			ent:SetCreator( ply )
			gamemode.Call( "PlayerSpawnedNPC", ply, ent )
			ply:AddCleanup( "npcs", ent )
		end

		if ( data.CurHealth ) then ent:SetHealth( data.CurHealth ) end
		if ( data.MaxHealth ) then ent:SetMaxHealth( data.MaxHealth ) end

		-- Here to allow old saves to work properly
		local onCopy = ent.OnEntityCopyTableFinish
		if onCopy then
			onCopy(ent, data)
		end
		
		table.Merge( ent:GetTable(), data )

	end

	return ent

end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Entity & Weapon Duplicator & Save Support ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Based on: https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/autorun/game_hl2.lua
--
VJ.CreateDupe_Entity = function( ply, data )
	if ( IsValid( ply ) && !gamemode.Call( "PlayerSpawnSENT", ply, data.Class ) ) then return NULL end

	local ent = ents.Create( data.Class )
	if ( !IsValid( ent ) ) then return NULL end -- Must've hit edict limit

	-- Remove certain fields we do not want dupes to manipulate
	data.Model = nil

	-- Restore the keyvalues
	local entTable = list.GetEntry( "SpawnableEntities", data.EntityName )
	if ( entTable && entTable.ClassName == data.Class && entTable.KeyValues ) then
		for k, v in pairs( entTable.KeyValues ) do
			ent:SetKeyValue( k, v )
		end
	end

	duplicator.DoGeneric( ent, data )

	ent:Spawn()

	--duplicator.DoGenericPhysics( ent, ply, data )

	ent:Activate()

	ent.EntityName = data.EntityName

	-- For hacked combine mines, they reset their skin
	if ( data.Skin ) then ent:SetSkin( data.Skin ) end

	if ( IsValid( ply ) ) then
		ent:SetCreator( ply )
		gamemode.Call( "PlayerSpawnedSENT", ply, ent )
	end

	return ent
end
-------------------------------------------------------------------------------------------------------------------------
VJ.CreateDupe_Weapon = function( ply, data )
	if ( IsValid( ply ) && !gamemode.Call( "PlayerSpawnSWEP", ply, data.Class, list.GetEntry( "Weapon", data.Class ) ) ) then return NULL end

	local ent = ents.Create( data.Class )
	if ( !IsValid( ent ) ) then return NULL end -- Must've hit edict limit

	-- Remove certain fields we do not want dupes to manipulate
	data.Model = nil

	duplicator.DoGeneric( ent, data )

	ent:Spawn()

	--duplicator.DoGenericPhysics( ent, ply, data )

	ent:Activate()

	ent.EntityName = data.EntityName

	if ( IsValid( ply ) ) then
		ent:SetCreator( ply )
		gamemode.Call( "PlayerSpawnedSWEP", ply, ent )
	end

	return ent
end