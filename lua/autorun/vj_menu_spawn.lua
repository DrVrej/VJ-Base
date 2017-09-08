/*--------------------------------------------------
	=============== VJ Controls ===============
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to load Controls for VJ Base
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end

AddCSLuaFile()

if (CLIENT) then
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
hook.Add("PopulateVJBaseNPC","AddVJBaseSpawnMenu_NPC",function(pnlContent,tree,node)
	local npctree = tree:AddNode("SNPCs", "icon16/monkey.png")
	npctree:MoveToFront()
	npctree.PropPanel = vgui.Create("ContentContainer", pnlContent)
	npctree.PropPanel:SetVisible(false)
	npctree.PropPanel:SetTriggerSpawnlistChange(false)
	
	function npctree:DoClick()
		pnlContent:SwitchPanel(self.PropPanel)
	end

	local NPCCategories = {}
	local NPCList = list.Get("VJBASE_SPAWNABLE_NPC")
	for k, v in pairs(NPCList) do
		local Category = v.Category or "Uncategorized"
		if Category == "VJ Base" then Category = "Default" end
		local Tab = NPCCategories[Category] or {}
		Tab[k] = v
		NPCCategories[Category] = Tab
	end
	for CategoryName, v in SortedPairs(NPCCategories) do
		local node = npctree:AddNode(CategoryName, "icon16/monkey.png")
		local CatPropPanel = vgui.Create("ContentContainer", pnlContent)
		CatPropPanel:SetVisible(false)
		local Header = vgui.Create("ContentHeader", npctree.PropPanel)
		Header:SetText(CategoryName)
		npctree.PropPanel:Add(Header)
		for name, ent in SortedPairsByMemberValue(v,"Name") do
			local t = {
				nicename	= ent.Name or name,
				spawnname	= name,
				material	= "entities/" .. name .. ".png",
				weapon		= ent.Weapons,
				admin		= ent.AdminOnly
			}
			spawnmenu.CreateContentIcon("npc",CatPropPanel,t)
			spawnmenu.CreateContentIcon("npc",npctree.PropPanel,t)
		end
		function node:DoClick()	
			pnlContent:SwitchPanel(CatPropPanel)
		end
	end
	npctree:SetExpanded(true)
	npctree:InternalDoClick()
end)
--[-------------------------------------------------------]--
hook.Add("PopulateVJBaseWeapons","AddVJBaseSpawnMenu_Weapon",function(pnlContent,tree,node)
	local weapontree = tree:AddNode("Weapons", "icon16/gun.png")
	weapontree.PropPanel = vgui.Create("ContentContainer", pnlContent)
	weapontree.PropPanel:SetVisible(false)
	weapontree.PropPanel:SetTriggerSpawnlistChange(false)

	function weapontree:DoClick()
		pnlContent:SwitchPanel( self.PropPanel )
	end

	local WeaponCategories = {}
	local WeaponList = list.Get("VJBASE_SPAWNABLE_WEAPON")
	for k, v in pairs(WeaponList) do
		if (!v.Spawnable && !v.AdminSpawnable) then continue end
		v.Category = v.Category or "Uncategorized"
		if v.Category == "VJ Base" then v.Category = "Default" end
		WeaponCategories[v.Category] = WeaponCategories[v.Category] or {}
		table.insert(WeaponCategories[v.Category], v)
	end
	for CategoryName, v in SortedPairs(WeaponCategories) do
		local node = weapontree:AddNode(CategoryName, "icon16/gun.png")
		local CatPropPanel = vgui.Create("ContentContainer", pnlContent)
		CatPropPanel:SetVisible(false)
		local Header = vgui.Create("ContentHeader", weapontree.PropPanel)
		Header:SetText(CategoryName)
		weapontree.PropPanel:Add(Header)
		for k, ent in SortedPairsByMemberValue(v, "PrintName") do
			local t = { 
				nicename	= ent.PrintName or ent.ClassName,
				spawnname	= ent.ClassName,
				material	= "entities/" .. ent.ClassName .. ".png",
				admin		= ent.AdminOnly
			}
			spawnmenu.CreateContentIcon(ent.ScriptedEntityType or "weapon", CatPropPanel, t)
			spawnmenu.CreateContentIcon(ent.ScriptedEntityType or "weapon", weapontree.PropPanel, t)
		end
		function node:DoClick()	
			pnlContent:SwitchPanel(CatPropPanel)
		end
	end
	weapontree:SetExpanded(true)
end)
--[-------------------------------------------------------]--
hook.Add("PopulateVJBaseEntities","AddVJBaseSpawnMenu_Entity",function(pnlContent,tree,node)
	local entitytree = tree:AddNode("Entities", "icon16/bricks.png")
	entitytree.PropPanel = vgui.Create("ContentContainer", pnlContent)
	entitytree.PropPanel:SetVisible(false)
	entitytree.PropPanel:SetTriggerSpawnlistChange(false)

	function entitytree:DoClick()
		pnlContent:SwitchPanel(self.PropPanel)
	end

	local EntityCategories = {}
	local SpawnableEntitiesList = list.Get("VJBASE_SPAWNABLE_ENTITIES")
	if (SpawnableEntitiesList) then
		for k, v in pairs(SpawnableEntitiesList) do
			v.Category = v.Category or "Uncategorized"
			if v.Category == "VJ Base" then v.Category = "Default" end
			EntityCategories[v.Category] = EntityCategories[v.Category] or {}
			table.insert(EntityCategories[v.Category], v)
		end
	end
	for CategoryName, v in SortedPairs(EntityCategories) do
		local node = entitytree:AddNode(CategoryName, "icon16/bricks.png")
		local CatPropPanel = vgui.Create("ContentContainer", pnlContent)
		CatPropPanel:SetVisible(false)
		local Header = vgui.Create("ContentHeader", entitytree.PropPanel)
		Header:SetText(CategoryName)
		entitytree.PropPanel:Add(Header)
		for k, ent in SortedPairsByMemberValue(v, "PrintName") do
			local t = { 
				nicename	= ent.PrintName or ent.ClassName,
				spawnname	= ent.ClassName,
				material	= "entities/" .. ent.ClassName .. ".png",
				admin		= ent.AdminOnly
			}
			spawnmenu.CreateContentIcon(ent.ScriptedEntityType or "entity", CatPropPanel, t)
			spawnmenu.CreateContentIcon(ent.ScriptedEntityType or "entity", entitytree.PropPanel, t)
		end
		function node:DoClick()	
			pnlContent:SwitchPanel(CatPropPanel)
		end
	end
	entitytree:SetExpanded(true)
end)
--[-------------------------------------------------------]--
hook.Add("PopulateVJBaseTools","AddVJBaseSpawnMenu_Tool",function(pnlContent,tree,node)
	local tooltree = tree:AddNode("Tools", "icon16/bullet_wrench.png")
	tooltree.PropPanel = vgui.Create("ContentContainer", pnlContent)
	tooltree.PropPanel:SetVisible(false)
	tooltree.PropPanel:SetTriggerSpawnlistChange(false)

	function tooltree:DoClick()
		pnlContent:SwitchPanel(self.PropPanel)
	end
	
	local ToolList = spawnmenu.GetTools()
	if (ToolList) then
		for nk, nv in pairs(ToolList) do
			if nv.Name == "DrVrej" then
				for nk2, nv2 in pairs(nv.Items) do
					if nv2.Text == "Tools" then
						//local node = tooltree:AddNode("Default", "icon16/bullet_wrench.png")
						local CatPropPanel = vgui.Create("ContentContainer", pnlContent)
						CatPropPanel:SetVisible(false)
						local Header = vgui.Create("ContentHeader", tooltree.PropPanel)
						Header:SetText("Tools")
						tooltree.PropPanel:Add(Header)
						for nk3, nv3 in pairs(nv2) do
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
spawnmenu.AddCreationTab("VJ Base",function()
	local ctrl = vgui.Create("SpawnmenuContentPanel")
	//ctrl:CallPopulateHook("PopulateVJBaseHome")
	ctrl:CallPopulateHook("PopulateVJBaseNPC")
	ctrl:CallPopulateHook("PopulateVJBaseWeapons")
	ctrl:CallPopulateHook("PopulateVJBaseEntities")
	ctrl:CallPopulateHook("PopulateVJBaseTools")
	return ctrl
 end,"icon16/plugin.png",60,"All VJ Base related stuff is located here!")
end
-------------------------------------------------------------------------------------------------------------------------
local function VJSPAWN_NPCINTERNAL(Player,Position,Normal,Class,Equipment)
	if (CLIENT) then return end
	print("Running VJ Base SNPC Internal...")
	local NPCList = list.Get("NPC") //VJBASE_SPAWNABLE_NPC
	local NPCData = NPCList[Class]
	if NPCList[Class] == nil then print("VJ Base SNPC Internal canceled an NPC from spawning, because it's not listed in the NPC menu.") return end
	PrintTable(NPCList[Class])
	///if !IsValid(NPCData) then print("VJ Base SNPC Internal was unable to spawn the SNPC, it didn't find any NPC Data to use") return end
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
	
	-- Rotate to face player (expected behaviour)
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
	NPC:SetKeyValue( "spawnflags", SpawnFlags )

	-- Optional Key Values
	if ( NPCData.KeyValues ) then
		for k, v in pairs( NPCData.KeyValues ) do
			NPC:SetKeyValue( k, v )
		end		
	end

	-- This NPC has a special skin we want to define
	if ( NPCData.Skin ) then NPC:SetSkin( NPCData.Skin ) end
	
	if ( NPCData.Skin ) then for i = 0,18 do self.Corpse:SetBodygroup(i,self:GetBodygroup(i)) end end

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
function VJSPAWN_NPC( player, NPCClassName, WeaponName, tr )
	if (CLIENT) then return end
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
concommand.Add( "vjbase_spawnnpc",function(ply,cmd,args) VJSPAWN_NPC(ply,args[1],args[2]) end)
-------------------------------------------------------------------------------------------------------------------------
function VJSPAWN_SNPC_DUPE( Player, Model, Class, Equipment, SpawnFlags, Data )
	if (!gamemode.Call("PlayerSpawnNPC",Player,Class,Equipment)) then return end
	local Entity = VJSPAWN_NPCINTERNAL(Player,Data.Pos,Vector(0,0,1),Class,Equipment,SpawnFlags)
	if (IsValid(Entity)) then
		duplicator.DoGeneric(Entity,Data)
		if (IsValid(Player)) then
			gamemode.Call("PlayerSpawnedNPC",Player,Entity)
			Player:AddCleanup("npcs",Entity)
		end
		table.Add(Entity:GetTable(),Data)
	end
	return Entity
end