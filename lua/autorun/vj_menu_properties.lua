/*--------------------------------------------------
	=============== VJ Properties ===============
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end

AddCSLuaFile()

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("CanProperty","VJ_PLY_CAN_PROPERTY",function(ply,property,ent)
	if GetConVarNumber("vj_npc_admin_properties") == 1 && !ply:IsAdmin() && property == "vj_npc_properties" then ply:ChatPrint("These options are restricted to Admin only!") return false end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ SNPC Controlling ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
properties.Add("vj_pr_npc_control",{
	MenuLabel = "#vjbase.menuproperties.control", -- Name to display on the context menu
	Order = 50000, -- The order to display this property relative to other properties
	MenuIcon = "icon16/controller.png", -- The icon to display next to the property
	PrependSpacer = true, -- Whether to add a spacer before this property. This should generally be true for the first property in a group of properties.

	Filter = function(self, ent, ply) -- A function that determines whether an entity is valid for this property
		if (!IsValid(ent)) then return false end
		if (ent:IsPlayer()) or !ent:IsNPC() then return false end
		if (!gamemode.Call("CanProperty", ply, "vj_npc_properties", ent)) then return false end
		if ent.IsVJBaseSNPC != true then return false end
		return true
	end,
	
	Action = function(self, ent) -- The action to perform upon using the property (Clientside)
		self:MsgStart()
			net.WriteEntity(ent)
		self:MsgEnd()
	end,
	
	Receive = function(self, length, ply) -- The action to perform upon using the property (Serverside)
		local ent = net.ReadEntity()
		if (!self:Filter(ent, ply)) then return end
		if ent.VJ_IsBeingControlled != true then
			if ent:Health() > 0 then
				local obj = ents.Create("obj_vj_npccontroller")
				obj.TheController = ply
				obj:SetControlledNPC(ent)
				obj:Spawn()
				obj:StartControlling()
			else
				ply:ChatPrint("Can't control "..ent:GetName().." its health is 0 or below.")
			end
		else
			ply:ChatPrint("Can't control "..ent:GetName().." it's already being controlled.")
		end
	end
})
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ SNPC Guarding ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
properties.Add("vj_pr_npc_guard",{
	MenuLabel = "#vjbase.menuproperties.guard", -- Name to display on the context menu
	Order = 50001, -- The order to display this property relative to other properties
	MenuIcon = "icon16/shield.png", -- The icon to display next to the property
	PrependSpacer = true, -- Whether to add a spacer before this property. This should generally be true for the first property in a group of properties.

	Filter = function(self, ent, ply) -- A function that determines whether an entity is valid for this property
		if (!IsValid(ent)) then return false end
		if (ent:IsPlayer()) or !ent:IsNPC() then return false end
		if (!gamemode.Call("CanProperty", ply, "vj_npc_properties", ent)) then return false end
		if ent.IsVJBaseSNPC != true then return false end
		return true
	end,
	
	Action = function(self, ent) -- The action to perform upon using the property (Clientside)
		self:MsgStart()
			net.WriteEntity(ent)
		self:MsgEnd()
	end,
	
	Receive = function(self, length, ply) -- The action to perform upon using the property (Serverside)
		local ent = net.ReadEntity()
		if (!self:Filter(ent, ply)) then return end
		if ent.VJ_IsBeingControlled != true then
			if ent.IsGuard == true then
				ply:ChatPrint("Disabled Guarding for "..ent:GetName()..".")
				ent.IsGuard = false
			else
				ply:ChatPrint("Enabled Guarding for "..ent:GetName()..".")
				ent:StopMoving()
				ent.IsGuard = true
			end
		else
			ply:ChatPrint("Unable to change setting for "..ent:GetName()..".")
		end
	end
})
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ SNPC Wandering ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
properties.Add("vj_pr_npc_wander",{
	MenuLabel = "#vjbase.menuproperties.wander", -- Name to display on the context menu
	Order = 50002, -- The order to display this property relative to other properties
	MenuIcon = "icon16/arrow_rotate_clockwise.png", -- The icon to display next to the property

	Filter = function(self, ent, ply) -- A function that determines whether an entity is valid for this property
		if (!IsValid(ent)) then return false end
		if (ent:IsPlayer()) or !ent:IsNPC() then return false end
		if (!gamemode.Call("CanProperty", ply, "vj_npc_properties", ent)) then return false end
		if ent.IsVJBaseSNPC != true then return false end
		return true
	end,
	
	Action = function(self, ent) -- The action to perform upon using the property (Clientside)
		self:MsgStart()
			net.WriteEntity(ent)
		self:MsgEnd()
	end,
	
	Receive = function(self, length, ply) -- The action to perform upon using the property (Serverside)
		local ent = net.ReadEntity()
		if (!self:Filter(ent, ply)) then return end
		if ent.VJ_IsBeingControlled != true then
			if ent.DisableWandering == true then
				ply:ChatPrint("Enabled Wandering for "..ent:GetName()..".")
				ent.DisableWandering = false
			else
				ply:ChatPrint("Disabled Wandering for "..ent:GetName()..".")
				ent:StopMoving()
				ent.DisableWandering = true
			end
		else
			ply:ChatPrint("Unable to change setting for "..ent:GetName()..".")
		end
	end
})
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ SNPC Toggle Medic ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
properties.Add("vj_pr_npc_medic",{
	MenuLabel = "#vjbase.menuproperties.medic", -- Name to display on the context menu
	Order = 50003, -- The order to display this property relative to other properties
	MenuIcon = "icon16/asterisk_yellow.png", -- The icon to display next to the property

	Filter = function(self, ent, ply) -- A function that determines whether an entity is valid for this property
		if (!IsValid(ent)) then return false end
		if (ent:IsPlayer()) or !ent:IsNPC() then return false end
		if (!gamemode.Call("CanProperty", ply, "vj_npc_properties", ent)) then return false end
		if ent.IsVJBaseSNPC != true then return false end
		return true
	end,
	
	Action = function(self, ent) -- The action to perform upon using the property (Clientside)
		self:MsgStart()
			net.WriteEntity(ent)
		self:MsgEnd()
	end,
	
	Receive = function(self, length, ply) -- The action to perform upon using the property (Serverside)
		local ent = net.ReadEntity()
		if (!self:Filter(ent, ply)) then return end
		if ent.IsMedicSNPC == true then
			ply:ChatPrint(ent:GetName().." Is no longer a medic.")
			ent.IsMedicSNPC = false
		else
			ply:ChatPrint(ent:GetName().." Is now a medic.")
			ent.IsMedicSNPC = true
		end
	end
})
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ SNPC Ally Me ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
properties.Add("vj_pr_npc_allyme",{
	MenuLabel = "#vjbase.menuproperties.allyme", -- Name to display on the context menu
	Order = 50004, -- The order to display this property relative to other properties
	MenuIcon = "icon16/heart_add.png", -- The icon to display next to the property

	Filter = function(self, ent, ply) -- A function that determines whether an entity is valid for this property
		if (!IsValid(ent)) then return false end
		if (ent:IsPlayer()) or !ent:IsNPC() then return false end
		if (!gamemode.Call("CanProperty", ply, "vj_npc_properties", ent)) then return false end
		if ent.IsVJBaseSNPC != true then return false end
		return true
	end,
	
	Action = function(self, ent) -- The action to perform upon using the property (Clientside)
		self:MsgStart()
			net.WriteEntity(ent)
		self:MsgEnd()
	end,
	
	Receive = function(self, length, ply) -- The action to perform upon using the property (Serverside)
		local ent = net.ReadEntity()
		if (!self:Filter(ent, ply)) then return end
		table.insert(ent.VJ_AddCertainEntityAsFriendly,ply)
		for k,v in ipairs(ent.VJ_AddCertainEntityAsEnemy) do
			if v:IsPlayer() && v:GetName() == ply:GetName() then
				table.remove(ent.VJ_AddCertainEntityAsEnemy,k)
			end
		end
		ply:ChatPrint(ent:GetName().." Became an ally to you.")
	end
})
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ SNPC Hostile Me ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
properties.Add("vj_pr_npc_hostileme",{
	MenuLabel = "#vjbase.menuproperties.hostileme", -- Name to display on the context menu
	Order = 50005, -- The order to display this property relative to other properties
	MenuIcon = "icon16/heart_delete.png", -- The icon to display next to the property

	Filter = function(self, ent, ply) -- A function that determines whether an entity is valid for this property
		if (!IsValid(ent)) then return false end
		if (ent:IsPlayer()) or !ent:IsNPC() then return false end
		if (!gamemode.Call("CanProperty", ply, "vj_npc_properties", ent)) then return false end
		if ent.IsVJBaseSNPC != true then return false end
		return true
	end,
	
	Action = function(self, ent) -- The action to perform upon using the property (Clientside)
		self:MsgStart()
			net.WriteEntity(ent)
		self:MsgEnd()
	end,
	
	Receive = function(self, length, ply) -- The action to perform upon using the property (Serverside)
		local ent = net.ReadEntity()
		if (!self:Filter(ent, ply)) then return end
		table.insert(ent.VJ_AddCertainEntityAsEnemy,ply)
		for k,v in ipairs(ent.VJ_AddCertainEntityAsFriendly) do
			if v:IsPlayer() && v:GetName() == ply:GetName() then
				table.remove(ent.VJ_AddCertainEntityAsFriendly,k)
			end
		end
		ply:ChatPrint(ent:GetName().." Became hostile to you.")
	end
})
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ SNPC Slay ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
properties.Add("vj_pr_npc_slay",{
	MenuLabel = "#vjbase.menuproperties.slay", -- Name to display on the context menu
	Order = 50006, -- The order to display this property relative to other properties
	MenuIcon = "icon16/cancel.png", -- The icon to display next to the property

	Filter = function(self, ent, ply) -- A function that determines whether an entity is valid for this property
		if (!IsValid(ent)) then return false end
		if (ent:IsPlayer()) or !ent:IsNPC() then return false end
		if (!gamemode.Call("CanProperty", ply, "vj_npc_properties", ent)) then return false end
		if ent.IsVJBaseSNPC != true then return false end
		return true
	end,
	
	Action = function(self, ent) -- The action to perform upon using the property (Clientside)
		self:MsgStart()
			net.WriteEntity(ent)
		self:MsgEnd()
	end,
	
	Receive = function(self, length, ply) -- The action to perform upon using the property (Serverside)
		local ent = net.ReadEntity()
		if (!self:Filter(ent, ply)) then return end
		ent:TakeDamage(ent:Health(),ply,ply)
		ply:ChatPrint("Slayed "..ent:GetName()..".")
	end
})
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ SNPC Gib ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
properties.Add("vj_pr_npc_gib",{
	MenuLabel = "#vjbase.menuproperties.gib", -- Name to display on the context menu
	Order = 50007, -- The order to display this property relative to other properties
	MenuIcon = "icon16/bomb.png", -- The icon to display next to the property

	Filter = function(self, ent, ply) -- A function that determines whether an entity is valid for this property
		if (!IsValid(ent)) then return false end
		if (ent:IsPlayer()) or !ent:IsNPC() then return false end
		if (!gamemode.Call("CanProperty", ply, "vj_npc_properties", ent)) then return false end
		if ent.IsVJBaseSNPC != true then return false end
		return true
	end,
	
	Action = function(self, ent) -- The action to perform upon using the property (Clientside)
		self:MsgStart()
			net.WriteEntity(ent)
		self:MsgEnd()
	end,
	
	Receive = function(self, length, ply) -- The action to perform upon using the property (Serverside)
		local ent = net.ReadEntity()
		if (!self:Filter(ent, ply)) then return end
		local dmg = DamageInfo()
		dmg:SetAttacker(ply)
		dmg:SetInflictor(ply)
		dmg:SetDamage(ent:Health())
		dmg:SetDamageType(DMG_ALWAYSGIB)
		ent:TakeDamageInfo(dmg)
		ply:ChatPrint("Gibbed "..ent:GetName()..".")
	end
})
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ SNPC Developer Mode ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
properties.Add("vj_pr_npc_devmode",{
	MenuLabel = "#vjbase.menuproperties.devmode", -- Name to display on the context menu
	Order = 50008, -- The order to display this property relative to other properties
	MenuIcon = "icon16/tag.png", -- The icon to display next to the property

	Filter = function(self, ent, ply) -- A function that determines whether an entity is valid for this property
		if (!IsValid(ent)) then return false end
		if (ent:IsPlayer()) or !ent:IsNPC() then return false end
		if (!gamemode.Call("CanProperty", ply, "vj_npc_properties", ent)) then return false end
		if ent.IsVJBaseSNPC != true then return false end
		return true
	end,
	
	Action = function(self, ent) -- The action to perform upon using the property (Clientside)
		self:MsgStart()
			net.WriteEntity(ent)
		self:MsgEnd()
	end,
	
	Receive = function(self, length, ply) -- The action to perform upon using the property (Serverside)
		local ent = net.ReadEntity()
		if (!self:Filter(ent, ply)) then return end
		if ent.VJDEBUG_SNPC_ENABLED == true then
			ply:ChatPrint("Disabled Developer Mode for "..ent:GetName()..".")
			ent.VJDEBUG_SNPC_ENABLED = false
			ent.AA_EnableDebug = false
		else
			ply:ChatPrint("Enabled Developer Mode for "..ent:GetName()..". Navigate to the SNPC developer menu to toggle items you want.")
			ent.VJDEBUG_SNPC_ENABLED = true
			ent.AA_EnableDebug = true
		end
	end
})