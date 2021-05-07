/*--------------------------------------------------
	=============== VJ Spawn Menu ===============
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end

AddCSLuaFile()
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Hooks ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	hook.Add("PopulateVJBaseHome","AddVJBaseSpawnMenu_Home",function(pnlContent,tree,node)
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
	--[-------------------------------------------------------]--
	local function VJ_PopulateTrees(pnlContent, tree, node, vjTreeName, vjIcon, vjList)
		local roottree = tree:AddNode(vjTreeName, vjIcon)
		if vjTreeName == "SNPCs" then
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
		
		local Categories = {}
		for k, v in pairs(EntList) do
			local Category = v.Category or "Uncategorized"
			if Category == "VJ Base" then Category = "#vjbase.menu.tabs.default" end
			local Tab = Categories[Category] or {}
			Tab[k] = v
			Categories[Category] = Tab
		end
		
		for CategoryName, v in SortedPairs(Categories) do
			local icon = vjIcon
			if list.HasEntry("VJBASE_CATEGORY_INFO", CategoryName) then
				icon = CatInfoList[CategoryName].icon
			end
			if CategoryName == "#vjbase.menu.tabs.default" then
				icon = "vj_base/icons/vjbase.png"
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
			
			if vjTreeName == "SNPCs" then
				for name, ent in SortedPairsByMemberValue(v,"Name") do
					local t = {
						nicename	= ent.Name or name,
						spawnname	= name,
						material	= "entities/" .. name .. ".png",
						weapon		= ent.Weapons,
						admin		= ent.AdminOnly
					}
					spawnmenu.CreateContentIcon("npc",CatPropPanel,t)
					spawnmenu.CreateContentIcon("npc",roottree.PropPanel,t)
				end
			elseif vjTreeName == "#spawnmenu.category.weapons" then
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
			elseif vjTreeName == "#spawnmenu.category.entities" then
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
		if vjTreeName == "SNPCs" then
			roottree:InternalDoClick() -- Automatically select this folder when the menu first opens
		end
	end
	--[-------------------------------------------------------]--
	hook.Add("PopulateVJBaseNPC", "AddVJBaseSpawnMenu_NPC", function(pnlContent, tree, node)
		VJ_PopulateTrees(pnlContent, tree, node, "SNPCs", "icon16/monkey.png", "VJBASE_SPAWNABLE_NPC")
	end)
	--[-------------------------------------------------------]--
	hook.Add("PopulateVJBaseWeapons","AddVJBaseSpawnMenu_Weapon", function(pnlContent, tree, node)
		VJ_PopulateTrees(pnlContent, tree, node, "#spawnmenu.category.weapons", "icon16/gun.png", "VJBASE_SPAWNABLE_WEAPON")
	end)
	--[-------------------------------------------------------]--
	hook.Add("PopulateVJBaseEntities","AddVJBaseSpawnMenu_Entity",function(pnlContent,tree,node)
		VJ_PopulateTrees(pnlContent, tree, node, "#spawnmenu.category.entities", "icon16/bricks.png", "VJBASE_SPAWNABLE_ENTITIES")
	end)
	--[-------------------------------------------------------]--
	hook.Add("PopulateVJBaseTools","AddVJBaseSpawnMenu_Tool",function(pnlContent,tree,node)
		local tooltree = tree:AddNode("#spawnmenu.tools_tab", "icon16/bullet_wrench.png")
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
						if nv2.ItemName == "#spawnmenu.tools_tab" then
							//local node = tooltree:AddNode("#vjbase.menu.tabs.default", "icon16/bullet_wrench.png")
							local CatPropPanel = vgui.Create("ContentContainer", pnlContent)
							CatPropPanel:SetVisible(false)
							local Header = vgui.Create("ContentHeader", tooltree.PropPanel)
							Header:SetText("#spawnmenu.tools_tab")
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
	end)
	
	--[-------------------------------------------------------]--
	-- Adds the searching functionality for the VJ Base spawn menu. Note: This algorithm is based on the base GMod algorithm.
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
	spawnmenu.AddCreationTab("VJ Base", function()
		local ctrl = vgui.Create("SpawnmenuContentPanel")
		ctrl:EnableSearch("vjbase_npcs", "PopulateVJBaseNPC")
		//ctrl:CallPopulateHook("PopulateVJBaseHome")
		ctrl:CallPopulateHook("PopulateVJBaseNPC")
		ctrl:CallPopulateHook("PopulateVJBaseWeapons")
		ctrl:CallPopulateHook("PopulateVJBaseEntities")
		ctrl:CallPopulateHook("PopulateVJBaseTools")
		
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

		-- Sort the items by name, also has the benefit of deduplication
		local weaponsForSort = {}
		for _, v in pairs(list.Get("VJBASE_SPAWNABLE_NPC_WEAPON")) do
			weaponsForSort[language.GetPhrase( v.title )] = v.class
		end
		
		-- Now actually add the weapons to the choices
		for title, class in SortedPairs(weaponsForSort) do
			DComboBox:AddChoice(title, class)
		end
		
		function DComboBox:OnSelect(index, value)
			self:ConVarChanged(self.Data[index])
		end

		self:Open()
	end
	vgui.Register("VJ_SpawnmenuNPCSidebarToolbox", PANEL, "DDrawer")
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Spawn Functions ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function VJSPAWN_NPCINTERNAL(Player, Position, Normal, Class, Equipment, SpawnFlagsSaved)
	if CLIENT then return end
	print("Running VJ Base SNPC Internal...")
	local NPCList = list.Get("NPC") //VJBASE_SPAWNABLE_NPC
	local NPCData = NPCList[Class]
	if NPCList[Class] == nil then print("VJ Base SNPC Internal canceled an NPC from spawning, because it's not listed in the NPC menu.") return end
	PrintTable(NPCList[Class])
	//if !IsValid(NPCData) then print("VJ Base SNPC Internal was unable to spawn the SNPC, it didn't find any NPC Data to use") return end
	print("VJ Base SNPC Internal is spawning: "..NPCData.Class)

	-- Don't let them spawn this entity if it isn't in our NPC Spawn list.
	/*if (!NPCData) then 
		if (!IsValid(Player)) then
			Player:SendLua("Derma_Message(\"Hey, stop trying to spawn it, your not allowed to!\")")
		end
	return end*/
	if (NPCData.AdminOnly && !Player:IsAdmin()) then return end

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
	if (!IsValid(NPC)) then return print("VJ Base SNPC Internal was unable to spawn the SNPC, the class didn't exist!") end
	NPC:SetPos(Position)
	
	-- Rotate to face player (expected behavior)
	local Angles = Angle( 0, 0, 0 )
		if ( IsValid( Player ) ) then
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
	print("VJ Base SNPC Internal successfully created the SNPC.")
	return NPC
end
-------------------------------------------------------------------------------------------------------------------------
/*
function VJSPAWN_NPC( player, NPCClassName, WeaponName, tr )
	if CLIENT then return end
	//if ( !NPCClassName ) then return end
	-- Give the gamemode an opportunity to deny spawning
	print(player)
	//print(NPCClassName)
	//print(WeaponName)
	//if ( !gamemode.Call( "PlayerSpawnNPC", player, NPCClassName, WeaponName ) ) then return end
	if ( !tr ) then
		local vStart = player:GetShootPos()
		local vForward = player:GetAimVector()
		local trace = {}
			trace.start = vStart
			trace.endpos = vStart + vForward * 2048
			trace.filter = player
		tr = util.TraceLine( trace )
	end
	
	-- Create the NPC is you can.
	local SpawnedNPC = VJSPAWN_NPCINTERNAL(player, tr.HitPos, tr.HitNormal, NPCClassName, WeaponName)
	//if ( !IsValid( SpawnedNPC ) ) then return end

	-- Give the gamemode an opportunity to do whatever
	if ( IsValid( player ) ) then gamemode.Call("PlayerSpawnedNPC", player, SpawnedNPC) end
	
	-- See if we can find a nice name for this NPC..
	local NPCList = list.Get( "VJBASE_SPAWNABLE_NPC" )
	local NiceName = nil
	if ( NPCList[ NPCClassName ] ) then 
		NiceName = NPCList[ NPCClassName ].Name
	end
	print("VJ Base SNPC successfully spawned the SNPC.")
	-- Add to undo list
	undo.Create("NPC")
		undo.SetPlayer( player )
		undo.AddEntity( SpawnedNPC )
		if ( NiceName ) then
			undo.SetCustomUndoText( "Undone "..NiceName )
		end
	undo.Finish( "NPC ("..tostring(NPCClassName)..")" )
	
	-- And cleanup
	player:AddCleanup( "npcs", SpawnedNPC )
	player:SendLua( "achievements.SpawnedNPC()" )
	print("VJ Base successfully created the SNPC.")
	//end
end
concommand.Add("vjbase_spawnnpc", function(ply,cmd,args) VJSPAWN_NPC(ply,args[1],args[2]) end)
*/
-------------------------------------------------------------------------------------------------------------------------
function VJSPAWN_SNPC_DUPE(ply, class, equipment, spawnflags, data) -- Based on the GMod NPCs, had to recreate it here because it's not a global function
	PrintTable(data)
	if (!gamemode.Call("PlayerSpawnNPC", ply, class, equipment)) then return end -- Don't create if this player isn't allowed to spawn NPCs!

	local normal = Vector(0, 0, 1)
	local NPCList = list.Get("NPC")
	local NPCData = NPCList[class]
	if (NPCData && NPCData.OnCeiling) then normal = Vector(0, 0, -1) end

	local ent = VJSPAWN_NPCINTERNAL(ply, data.Pos, normal, class, equipment, spawnflags)
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