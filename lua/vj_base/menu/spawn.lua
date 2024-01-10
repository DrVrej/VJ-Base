/*--------------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Hooks ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	local function VJ_PopulateTrees(pnlContent, tree, node, vjTreeName, vjIcon, vjList)
		local roottree = tree:AddNode(vjTreeName, vjIcon)
		if vjTreeName == "NPCs" then
			roottree:MoveToFront() -- Make this the main tree
		end
		roottree.PropPanel = vgui.Create("ContentContainer", pnlContent)
		roottree.PropPanel:SetVisible(false)
		roottree.PropPanel:SetTriggerSpawnlistChange(false)
		
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
			local icon = vjIcon -- Make the default icon the category icon
			if CategoryName == "Default" then
				icon = "vj_base/icons/vrejgaming.png"
			elseif list.HasEntry("VJBASE_CATEGORY_INFO", CategoryName) then
				icon = CatInfoList[CategoryName].icon
			end
			
			local node = roottree:AddNode(CategoryName, icon)
			local CatPropPanel = vgui.Create("ContentContainer", pnlContent)
			CatPropPanel:SetVisible(false)
			
			-- Write the name of the categories in both the general menu and in its own menu
			local generalHeader = vgui.Create("ContentHeader", roottree.PropPanel)
			generalHeader:SetText(CategoryName)
			roottree.PropPanel:Add(generalHeader)
			local catHeader = vgui.Create("ContentHeader", CatPropPanel)
			catHeader:SetText(CategoryName)
			CatPropPanel:Add(catHeader)
			
			if vjTreeName == "NPCs" then
				for name, ent in SortedPairsByMemberValue(v, "Name") do
					local t = {
						nicename	= ent.Name or name,
						spawnname	= name,
						material	= "entities/" .. name .. ".png",
						weapon		= ent.Weapons,
						admin		= ent.AdminOnly
					}
					spawnmenu.CreateContentIcon("npc", CatPropPanel, t)
					spawnmenu.CreateContentIcon("npc", roottree.PropPanel, t)
				end
			elseif vjTreeName == "Weapons" then
				for _, ent in SortedPairsByMemberValue(v, "PrintName") do
					local t = { 
						nicename	= ent.PrintName or ent.ClassName,
						spawnname	= ent.ClassName,
						material	= "entities/" .. ent.ClassName .. ".png",
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
						material	= "entities/" .. ent.ClassName .. ".png",
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
		if (ToolList) then
			for _, nv in pairs(ToolList) do
				if nv.Name == "DrVrej" then
					for _, nv2 in pairs(nv.Items) do
						if nv2.ItemName == "Tools" then
							//local node = tooltree:AddNode("Default", "icon16/bullet_wrench.png")
							local CatPropPanel = vgui.Create("ContentContainer", pnlContent)
							CatPropPanel:SetVisible(false)
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
	
		return ctrl
	end, "vj_base/icons/vrejgaming.png", 60, "All VJ Base entities are located here!") // icon16/plugin.png
	
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

		self:AddCheckbox("#vjbase.spawn.menu.npc.disablethinking", "ai_disabled")
		self:AddCheckbox("#vjbase.spawn.menu.npc.ignoreplayers", "ai_ignoreplayers")
		self:AddCheckbox("#vjbase.spawn.menu.npc.keepcorpses", "ai_serverragdolls")
		self:AddCheckbox("#vjbase.spawn.menu.npc.guard", "vj_npc_spawn_guard")
		
		local label = vgui.Create("DLabel", self)
		label:Dock(TOP)
		label:DockMargin(0, 5, 0, 0)
		label:SetDark(true)
		label:SetText("#menubar.npcs.weapon")

		local DComboBox = vgui.Create( "DComboBox", self )
		DComboBox:Dock( TOP )
		DComboBox:DockMargin(0, 0, 0, 0)
		DComboBox:SetConVar("gmod_npcweapon")
		DComboBox:SetSortItems(false)

		DComboBox:AddChoice("#menubar.npcs.defaultweapon", "")
		DComboBox:AddChoice("#menubar.npcs.noweapon", "none")
		DComboBox:AddSpacer()

			-- Sort the items by name, and group by category
		local groupedWeps = {}
		for _, v in pairs( list.Get( "VJBASE_SPAWNABLE_NPC_WEAPON" ) ) do
			local cat = (v.category or ""):lower()
			groupedWeps[ cat ] = groupedWeps[ cat ] or {}
			groupedWeps[ cat ][ v.class ] = language.GetPhrase( v.title )
		end

		for _, items in SortedPairs( groupedWeps ) do
			DComboBox:AddSpacer()
			for class, title in SortedPairsByValue( items ) do
				DComboBox:AddChoice( title, class )
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
------ Spawn Functions ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function CreateInternal_NPC(Player, Position, Normal, Class, Equipment, SpawnFlagsSaved)
	if CLIENT then return end
	print("Running VJ Base NPC duplicator internal...")
	local NPCList = list.Get("NPC") //VJBASE_SPAWNABLE_NPC
	local NPCData = NPCList[Class]
	if NPCData == nil then print("ERROR! VJ Base NPC duplicator internal failed, NPC not listed in the NPC menu!") return end
	//PrintTable(NPCData)
	//if !IsValid(NPCData) then print("VJ Base NPC Internal was unable to spawn the NPC, it didn't find any NPC Data to use") return end
	print("VJ Base NPC duplicator internal creating: " .. NPCData.Name .. " ( ".. NPCData.Class .. " ) --> ".. NPCData.Category)

	-- Don't let them spawn this entity if it isn't in our NPC Spawn list.
	/*if (!NPCData) then 
		if (!IsValid(Player)) then
			Player:SendLua("Derma_Message(\"Hey, stop trying to spawn it, your not allowed to!\")")
		end
	return end*/

	local isValidPly = IsValid(Player)

	if ( NPCData.AdminOnly && isValidPly && !Player:IsAdmin() ) then return end

	local bDropToFloor = false
	if ( NPCData.OnCeiling && Vector( 0, 0, -1 ):Dot( Normal ) < 0.95 ) then -- This NPC has to be spawned on a ceiling (Barnacle)
		return nil
	end
	if ( NPCData.OnFloor && Vector( 0, 0, 1 ):Dot( Normal ) < 0.95 ) then -- This NPC has to be spawned on a floor (Turrets)
		return nil
	else
		bDropToFloor = true
	end
	if ( NPCData.NoDrop ) then bDropToFloor = false end

	-- Offset the position
	local Offset = NPCData.Offset or 32
	Position = Position + Normal * Offset

	-- Create NPC
	local NPC = ents.Create(NPCData.Class)
	if (!IsValid(NPC)) then print("ERROR! VJ Base NPC duplicator internal failed, NPC class does not exist!") return end
	NPC:SetPos(Position)
	
	-- Rotate to face player (expected behavior)
	local Angles = Angle( 0, 0, 0 )
		if ( isValidPly ) then
			Angles = Player:GetAngles()
		end
		Angles.pitch = 0
		Angles.roll = 0
		Angles.yaw = Angles.yaw + 180
	if ( NPCData.Rotate ) then Angles = Angles + NPCData.Rotate end
	NPC:SetAngles( Angles )

	-- This NPC has a special model we want to define
	if ( NPCData.Model ) then NPC:SetModel( NPCData.Model ) end

	-- This NPC has a special texture we want to define
	if ( NPCData.Material ) then NPC:SetMaterial( NPCData.Material ) end

	-- Spawn Flags
	local SpawnFlags = bit.bor( SF_NPC_FADE_CORPSE, SF_NPC_ALWAYSTHINK )
	if ( NPCData.SpawnFlags ) then SpawnFlags = bit.bor( SpawnFlags, NPCData.SpawnFlags ) end
	if ( NPCData.TotalSpawnFlags ) then SpawnFlags = NPCData.TotalSpawnFlags end
	if ( SpawnFlagsSaved ) then SpawnFlags = SpawnFlagsSaved end
	NPC:SetKeyValue( "spawnflags", SpawnFlags )

	-- Optional Key Values
	if ( NPCData.KeyValues ) then
		for k, v in pairs( NPCData.KeyValues ) do
			NPC:SetKeyValue( k, v )
		end		
	end

	-- This NPC has a special skin we want to define
	if ( NPCData.Skin ) then NPC:SetSkin( NPCData.Skin ) end
	
	-- Body groups
	if (NPCData.BodyGroups) then
		for k, v in pairs(NPCData.BodyGroups) do
			NPC:SetBodygroup(k, v)
		end
	end

	-- Check if this is a valid entity from the list, or the user is trying to fool us.
	local valid = false
	for _, v in pairs( list.Get( "NPCUsableWeapons" ) ) do
		if v.class == Equipment then valid = true break end
	end

	if ( Equipment && Equipment != "none" && valid ) then
		NPC:SetKeyValue( "additionalequipment", Equipment )
		NPC.Equipment = Equipment 
	end

	DoPropSpawnedEffect(NPC)
	NPC:Spawn()
	NPC:Activate()
	
	if ( bDropToFloor && !NPCData.OnCeiling ) then NPC:DropToFloor() end
	print("VJ Base NPC duplicator internal successfully created the NPC!")
	return NPC
end
-------------------------------------------------------------------------------------------------------------------------
if !VJ then VJ = {} end -- If VJ isn't initialized, initialize it!
--
local vecZ1 = Vector(0, 0, 1)
--
VJ.CreateDupe_NPC = function(ply, class, equipment, spawnflags, data) -- Based on the GMod NPCs, had to recreate it here because it's not a global function
	//PrintTable(data)
	if IsValid(ply) && !gamemode.Call("PlayerSpawnNPC", ply, class, equipment) then return end -- Don't create if this player isn't allowed to spawn NPCs!

	local normal = vecZ1
	local NPCList = list.Get("NPC")
	local NPCData = NPCList[class]
	if (NPCData && NPCData.OnCeiling) then normal = Vector(0, 0, -1) end

	local ent = CreateInternal_NPC(ply, data.Pos, normal, class, equipment, spawnflags)
	if (IsValid(ent)) then
		local pos = ent:GetPos() -- Prevents the NPCs from falling through the floor
		duplicator.DoGeneric(ent, data) -- Applies generic every-day entity stuff for ent from table data (wiki)
		if (!NPCData.OnCeiling && !NPCData.NoDrop) then
			ent:SetPos(pos)
			ent:DropToFloor()
		end
		if (IsValid(ply)) then
			gamemode.Call("PlayerSpawnedNPC", ply, ent)
			ply:AddCleanup("npcs", ent)
		end
		table.Add(ent:GetTable(), data)
	end
	return ent
end