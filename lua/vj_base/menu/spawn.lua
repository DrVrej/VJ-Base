/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Hooks ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	local function VJ_PopulateTrees(pnlContent, tree, nodeMain, vjTreeName, vjIcon, vjList)
		local roottree = tree:AddNode(vjTreeName, vjIcon)
		if vjTreeName == "NPCs" then
			roottree:MoveToFront() -- Make this the main tree
		end
		roottree.PropPanel = vgui.Create("ContentContainer", pnlContent)
		roottree.PropPanel:SetVisible(false)
		roottree.PropPanel:SetTriggerSpawnlistChange(false) -- Make it read-only so it can't be edited
		
		function roottree:DoClick()
			pnlContent:SwitchPanel(self.PropPanel)
		end
		
		local EntList = list.Get(vjList)
		local CatInfoList = list.Get("VJBASE_CATEGORY_INFO")
		
		-- Categorize them
		local Categories = {}
		for k, v in pairs(EntList) do
			local Category = v.Category or "Uncategorized"
			if Category == "VJ Base" then Category = "Default" end
			local Tab = Categories[Category] or {}
			Tab[k] = v
			Categories[Category] = Tab
		end
		
		-- Create an icon for each one and put them on the panel
		for CategoryName, v in SortedPairs(Categories) do
			-- Category icon
			local icon = list.HasEntry("VJBASE_CATEGORY_INFO", CategoryName) and CatInfoList[CategoryName].icon or vjIcon
			if CategoryName == "Default" then
				icon = "vj_base/icons/vrejgaming.png"
			end
			
			local node = roottree:AddNode(CategoryName, icon)
			local CatPropPanel = vgui.Create("ContentContainer", pnlContent)
			CatPropPanel:SetVisible(false)
			CatPropPanel:SetTriggerSpawnlistChange(false) -- Make it read-only so it can't be edited
			
			-- Post the name of the category in the all entities menu
			local generalHeader = vgui.Create("ContentHeader", roottree.PropPanel)
			generalHeader:SetText(CategoryName)
			roottree.PropPanel:Add(generalHeader)
			
			-- Post the name of the category in the specific tree
			//local catHeader = vgui.Create("ContentHeader", CatPropPanel)
			//catHeader:SetText(CategoryName)
			//CatPropPanel:Add(catHeader)
			
			if vjTreeName == "NPCs" then
				for name, ent in SortedPairsByMemberValue(v, "Name") do
					local t = {
						nicename	= ent.Name or name,
						spawnname	= name,
						material	= ent.IconOverride or "entities/" .. name .. ".png",
						weapon		= ent.Weapons,
						admin		= ent.AdminOnly
					}
					spawnmenu.CreateContentIcon(ent.ScriptedEntityType or "npc", CatPropPanel, t)
					spawnmenu.CreateContentIcon(ent.ScriptedEntityType or "npc", roottree.PropPanel, t)
				end
			elseif vjTreeName == "Weapons" then
				for _, ent in SortedPairsByMemberValue(v, "PrintName") do
					local t = {
						nicename	= ent.PrintName or ent.ClassName,
						spawnname	= ent.ClassName,
						material	= ent.IconOverride or "entities/" .. ent.ClassName .. ".png",
						admin		= ent.AdminOnly
					}
					spawnmenu.CreateContentIcon(ent.ScriptedEntityType or "weapon", CatPropPanel, t)
					spawnmenu.CreateContentIcon(ent.ScriptedEntityType or "weapon", roottree.PropPanel, t)
				end
			elseif vjTreeName == "Entities" then
				for _, ent in SortedPairsByMemberValue(v, "PrintName") do
					local t = {
						nicename	= ent.PrintName or ent.ClassName,
						spawnname	= ent.ClassName,
						material	= ent.IconOverride or "entities/" .. ent.ClassName .. ".png",
						admin		= ent.AdminOnly
					}
					spawnmenu.CreateContentIcon(ent.ScriptedEntityType or "entity", CatPropPanel, t)
					spawnmenu.CreateContentIcon(ent.ScriptedEntityType or "entity", roottree.PropPanel, t)
				end
			end
			function node:DoClick()
				pnlContent:SwitchPanel(CatPropPanel)
			end
		end
		roottree:SetExpanded(true)
		if vjTreeName == "NPCs" then
			roottree:InternalDoClick() -- Automatically select this folder when the menu first opens
		end
	end
	--[-------------------------------------------------------]--
	/*
	hook.Add("PopulateVJBaseHome", "AddVJBaseSpawnMenu_Home", function(pnlContent, tree, node)
		local hometree = tree:AddNode("Home", "icon16/monkey.png")
		hometree.PropPanel = vgui.Create("ContentContainer", pnlContent)
		hometree.PropPanel:SetVisible(false)
		hometree.PropPanel:SetTriggerSpawnlistChange(false)
		//hometree.PropPanel:MoveToFront()
		
		function hometree:DoClick()
			pnlContent:SwitchPanel(self.PropPanel)
		end
		
		local Header1 = vgui.Create("DLabel")
		Header1:SetPos(40, 40)
		Header1:SetSize(200, 70)
		Header1:SetTextColor(Color(255, 102, 0, 255))
		Header1:SetText("Welcome to VJ Base!")
		hometree.PropPanel:Add(Header1)
		
		local Text1 = vgui.Create("DLabel")
		Header1:SetPos(80, 80)
		Text1:SetSize(100, 35)
		Text1:SetTextColor(Color(102, 204, 255, 255))
		Text1:SetText("By: DrVrej")
		hometree.PropPanel:Add(Text1)
		
		hometree:InternalDoClick()
	end)
	*/
	--[-------------------------------------------------------]--
	hook.Add("PopulateVJBaseMain", "PopulateVJBaseMain", function(pnlContent, tree, node)
		VJ_PopulateTrees(pnlContent, tree, node, "NPCs", "icon16/monkey.png", "VJBASE_SPAWNABLE_NPC")
		VJ_PopulateTrees(pnlContent, tree, node, "Weapons", "icon16/gun.png", "VJBASE_SPAWNABLE_WEAPON")
		VJ_PopulateTrees(pnlContent, tree, node, "Entities", "icon16/bricks.png", "VJBASE_SPAWNABLE_ENTITIES")
		
		-- START of tools category
		local tooltree = tree:AddNode("Tools", "icon16/bullet_wrench.png")
		tooltree.PropPanel = vgui.Create("ContentContainer", pnlContent)
		tooltree.PropPanel:SetVisible(false)
		tooltree.PropPanel:SetTriggerSpawnlistChange(false)
		function tooltree:DoClick()
			pnlContent:SwitchPanel(self.PropPanel)
		end
		local ToolList = spawnmenu.GetTools()
		if ToolList then
			for _, nv in pairs(ToolList) do
				if nv.Name == "DrVrej" then
					for _, nv2 in pairs(nv.Items) do
						if nv2.ItemName == "Tools" then
							//local node = tooltree:AddNode("Default", "icon16/bullet_wrench.png")
							local CatPropPanel = vgui.Create("ContentContainer", pnlContent)
							CatPropPanel:SetVisible(false)
							CatPropPanel:SetTriggerSpawnlistChange(false) -- Make it read-only so it can't be edited
							local Header = vgui.Create("ContentHeader", tooltree.PropPanel)
							Header:SetText("Tools")
							tooltree.PropPanel:Add(Header)
							for _, nv3 in pairs(nv2) do
								if !istable(nv3) then continue end
									local t = {
										nicename	= nv3.Text,
										spawnname	= nv3.ItemName,
										//material	= "entities/" .. ent.ClassName .. ".png",
										//admin		= ent.AdminOnly
									}
									spawnmenu.CreateContentIcon("tool", CatPropPanel, t)
									spawnmenu.CreateContentIcon("tool", tooltree.PropPanel, t)
								end
							function tooltree:DoClick()
								pnlContent:SwitchPanel(CatPropPanel)
							end
						end
					end
				end
			end
		end
		tooltree:SetExpanded(true)
		-- END of tools category
	end)
	
	--[-------------------------------------------------------]--
	-- Adds the searching functionality for the VJ Base spawn menu.
	-- Note: This is based on the default GMod code.
	search.AddProvider(function(str)
		local results = {}
		local entities = {}
		
		local function searchList(lname, lctype)
			for k, v in pairs(list.Get(lname)) do
				v.ClassName = k
				v.PrintName = v.PrintName or v.Name
				v.ScriptedEntityType = lctype
				table.insert(entities, v)
			end
		end
		searchList("VJBASE_SPAWNABLE_NPC", "npc")
		searchList("VJBASE_SPAWNABLE_WEAPON", "weapon")
		searchList("VJBASE_SPAWNABLE_ENTITIES", "entity")
		// searchList("VJBASE_SPAWNABLE_VEHICLES", "vehicle") -- vehicle (Not yet lol)

		for _, v in pairs(entities) do
			local name = v.PrintName
			local name_c = v.ClassName
			if (!name && !name_c) then continue end
			
			if ((name && name:lower():find(str, nil, true)) or (name_c && name_c:lower():find(str, nil, true))) then
				local entry = {
					text = v.PrintName or v.ClassName,
					icon = spawnmenu.CreateContentIcon(v.ScriptedEntityType or "entity", nil, {
						nicename = v.PrintName or v.ClassName,
						spawnname = v.ClassName,
						material = "entities/" .. v.ClassName .. ".png",
						admin = v.AdminOnly
					}),
					words = {v}
				}

				table.insert(results, entry)
			end
		end
		table.SortByMember(results, "text", true)
		return results
	end, "vjbase_npcs")

	--[-------------------------------------------------------]--
	-- Create the main spawn menu tab, set it to be placed after the default "Vehicles" tab
	if VJBASE_DISABLE_MENU_SPAWN != true then
		spawnmenu.AddCreationTab("VJ Base", function()
			local ctrl = vgui.Create("SpawnmenuContentPanel")
			ctrl:EnableSearch("vjbase_npcs", "PopulateVJBaseMain")
			ctrl:CallPopulateHook("PopulateVJBaseMain")
			//ctrl:CallPopulateHook("PopulateVJBaseHome")
			//ctrl:CallPopulateHook("PopulateVJBaseNPC")
			//ctrl:CallPopulateHook("PopulateVJBaseWeapons")
			//ctrl:CallPopulateHook("PopulateVJBaseEntities")
			//ctrl:CallPopulateHook("PopulateVJBaseTools")
			
			local sidebar = ctrl.ContentNavBar
			sidebar.Options = vgui.Create( "VJ_SpawnmenuNPCSidebarToolbox", sidebar )
			sidebar.Options:Dock( BOTTOM )
		
			return ctrl
		end, "vj_base/icons/vrejgaming.png", 60, "All VJ Base entities are located here!") // icon16/plugin.png
	end
	
	--[-------------------------------------------------------]--
	-- Based on GMod's SpawnmenuNPCSidebarToolbox but with some changes
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
-- Taken from: https://github.com/Facepunch/garrysmod/blob/master/garrysmod/gamemodes/sandbox/gamemode/commands.lua
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
	if ( NPCData.Model ) then
		NPC:SetModel( NPCData.Model )
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
	if ( NPCData.Model && NPC:GetModel():lower() != NPCData.Model:lower() ) then
		NPC:SetModel( NPCData.Model )
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
-- Taken from: https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/autorun/game_hl2.lua
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