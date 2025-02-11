/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("CanProperty", "VJ_PLY_CAN_PROPERTY", function(ply, property, ent)
	if GetConVar("vj_npc_admin_properties"):GetInt() == 1 && !ply:IsAdmin() && property == "vj_npc_properties" then ply:ChatPrint("#vjbase.menu.context.print.adminonly") return false end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ NPC Controlling ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
properties.Add("vj_pr_npc_control",{
	MenuLabel = "#vjbase.menu.context.control",
	MenuIcon = "icon16/controller.png",
	Order = 50000,
	PrependSpacer = true, -- Adds a spacer before this property

	Filter = function(self, ent, ply) -- decide whether this property should be shown for an entity (Client)
		if IsValid(ent) && ent:IsNPC() && ent.IsVJBaseSNPC && gamemode.Call("CanProperty", ply, "vj_npc_properties", ent) then
			return true
		end
		return false
	end,
	
	Action = function(self, ent) -- Called when the property is clicked (Client)
		self:MsgStart()
			net.WriteEntity(ent)
		self:MsgEnd()
	end,
	
	Receive = function(self, length, ply) -- Called when "Action" sends a message (Server)
		local ent = net.ReadEntity()
		if (!self:Filter(ent, ply)) then return end
		if !ply:Alive() then return end -- Keep the player from becoming a zombie =)
		if ply.VJ_IsControllingNPC then ply:ChatPrint("Can't control "..ent:GetName().." because you are already controlling another NPC!") return end
		if !ent.VJ_IsBeingControlled then
			if ent:Health() > 0 then
				local obj = ents.Create("obj_vj_controller")
				obj.VJCE_Player = ply
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
------ NPC Guarding ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
properties.Add("vj_pr_npc_guard",{
	MenuLabel = "#vjbase.menu.context.guard",
	MenuIcon = "icon16/shield.png",
	Order = 50001,
	PrependSpacer = true, -- Adds a spacer before this property

	Filter = function(self, ent, ply) -- decide whether this property should be shown for an entity (Client)
		if IsValid(ent) && ent:IsNPC() && ent.IsVJBaseSNPC && gamemode.Call("CanProperty", ply, "vj_npc_properties", ent) then
			return true
		end
		return false
	end,
	
	Action = function(self, ent) -- Called when the property is clicked (Client)
		self:MsgStart()
			net.WriteEntity(ent)
		self:MsgEnd()
	end,
	
	Receive = function(self, length, ply) -- Called when "Action" sends a message (Server)
		local ent = net.ReadEntity()
		if (!self:Filter(ent, ply)) then return end
		if !ent.VJ_IsBeingControlled then
			if ent.IsGuard then
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
------ NPC Wandering ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
properties.Add("vj_pr_npc_wander",{
	MenuLabel = "#vjbase.menu.context.wander",
	MenuIcon = "icon16/arrow_rotate_clockwise.png",
	Order = 50002,

	Filter = function(self, ent, ply) -- decide whether this property should be shown for an entity (Client)
		if IsValid(ent) && ent:IsNPC() && ent.IsVJBaseSNPC && gamemode.Call("CanProperty", ply, "vj_npc_properties", ent) then
			return true
		end
		return false
	end,
	
	Action = function(self, ent) -- Called when the property is clicked (Client)
		self:MsgStart()
			net.WriteEntity(ent)
		self:MsgEnd()
	end,
	
	Receive = function(self, length, ply) -- Called when "Action" sends a message (Server)
		local ent = net.ReadEntity()
		if (!self:Filter(ent, ply)) then return end
		if !ent.VJ_IsBeingControlled then
			if ent.DisableWandering then
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
------ NPC Toggle Medic ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
properties.Add("vj_pr_npc_medic",{
	MenuLabel = "#vjbase.menu.context.medic",
	MenuIcon = "icon16/asterisk_yellow.png",
	Order = 50003,

	Filter = function(self, ent, ply) -- decide whether this property should be shown for an entity (Client)
		if IsValid(ent) && ent:IsNPC() && ent.IsVJBaseSNPC && gamemode.Call("CanProperty", ply, "vj_npc_properties", ent) then
			return true
		end
		return false
	end,
	
	Action = function(self, ent) -- Called when the property is clicked (Client)
		self:MsgStart()
			net.WriteEntity(ent)
		self:MsgEnd()
	end,
	
	Receive = function(self, length, ply) -- Called when "Action" sends a message (Server)
		local ent = net.ReadEntity()
		if (!self:Filter(ent, ply)) then return end
		if ent.IsMedic then
			ply:ChatPrint(ent:GetName().." Is no longer a medic.")
			ent.IsMedic = false
		else
			ply:ChatPrint(ent:GetName().." Is now a medic.")
			ent.IsMedic = true
		end
	end
})
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ NPC Ally Me ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
properties.Add("vj_pr_npc_allyme",{
	MenuLabel = "#vjbase.menu.context.allyme",
	MenuIcon = "icon16/heart_add.png",
	Order = 50004,

	Filter = function(self, ent, ply) -- decide whether this property should be shown for an entity (Client)
		if IsValid(ent) && ent:IsNPC() && ent.IsVJBaseSNPC && gamemode.Call("CanProperty", ply, "vj_npc_properties", ent) then
			return true
		end
		return false
	end,
	
	Action = function(self, ent) -- Called when the property is clicked (Client)
		self:MsgStart()
			net.WriteEntity(ent)
		self:MsgEnd()
	end,
	
	Receive = function(self, length, ply) -- Called when "Action" sends a message (Server)
		local ent = net.ReadEntity()
		if (!self:Filter(ent, ply)) then return end
		ent:SetRelationshipMemory(ply, VJ.MEM_OVERRIDE_DISPOSITION, D_LI)
		ply:ChatPrint(ent:GetName().." Became an ally to you.")
	end
})
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ NPC Hostile Me ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
properties.Add("vj_pr_npc_hostileme",{
	MenuLabel = "#vjbase.menu.context.hostileme",
	MenuIcon = "icon16/heart_delete.png",
	Order = 50005,

	Filter = function(self, ent, ply) -- decide whether this property should be shown for an entity (Client)
		if IsValid(ent) && ent:IsNPC() && ent.IsVJBaseSNPC && gamemode.Call("CanProperty", ply, "vj_npc_properties", ent) then
			return true
		end
		return false
	end,
	
	Action = function(self, ent) -- Called when the property is clicked (Client)
		self:MsgStart()
			net.WriteEntity(ent)
		self:MsgEnd()
	end,
	
	Receive = function(self, length, ply) -- Called when "Action" sends a message (Server)
		local ent = net.ReadEntity()
		if (!self:Filter(ent, ply)) then return end
		ent:SetRelationshipMemory(ply, VJ.MEM_OVERRIDE_DISPOSITION, D_HT)
		ply:ChatPrint(ent:GetName().." Became hostile to you.")
	end
})
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ NPC Slay ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
properties.Add("vj_pr_npc_slay",{
	MenuLabel = "#vjbase.menu.context.slay",
	MenuIcon = "icon16/cancel.png",
	Order = 50006,

	Filter = function(self, ent, ply) -- decide whether this property should be shown for an entity (Client)
		if IsValid(ent) && ent:IsNPC() && ent.IsVJBaseSNPC && gamemode.Call("CanProperty", ply, "vj_npc_properties", ent) then
			return true
		end
		return false
	end,
	
	Action = function(self, ent) -- Called when the property is clicked (Client)
		self:MsgStart()
			net.WriteEntity(ent)
		self:MsgEnd()
	end,
	
	Receive = function(self, length, ply) -- Called when "Action" sends a message (Server)
		local ent = net.ReadEntity()
		if (!self:Filter(ent, ply)) then return end
		ent:SetHealth(0)
		ent:TakeDamage(ent:Health() + 99999,ply,ply)
		ply:ChatPrint("Slayed "..ent:GetName()..".")
	end
})
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ NPC Gib ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
properties.Add("vj_pr_npc_gib",{
	MenuLabel = "#vjbase.menu.context.gib",
	MenuIcon = "icon16/bomb.png",
	Order = 50007,

	Filter = function(self, ent, ply) -- decide whether this property should be shown for an entity (Client)
		if IsValid(ent) && ent:IsNPC() && ent.IsVJBaseSNPC && gamemode.Call("CanProperty", ply, "vj_npc_properties", ent) then
			return true
		end
		return false
	end,
	
	Action = function(self, ent) -- Called when the property is clicked (Client)
		self:MsgStart()
			net.WriteEntity(ent)
		self:MsgEnd()
	end,
	
	Receive = function(self, length, ply) -- Called when "Action" sends a message (Server)
		local ent = net.ReadEntity()
		if (!self:Filter(ent, ply)) then return end
		ent:SetHealth(0)
		local dmg = DamageInfo()
		dmg:SetDamage(ent:Health() + 999)
		dmg:SetDamageType(DMG_ALWAYSGIB)
		dmg:SetAttacker(ply)
		dmg:SetInflictor(ply)
		ent:TakeDamageInfo(dmg)
		ply:ChatPrint("Gibbed " .. ent:GetName() .. ".")
	end
})
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ NPC Developer Mode ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
properties.Add("vj_pr_npc_devmode",{
	MenuLabel = "#vjbase.menu.context.devmode",
	MenuIcon = "icon16/tag.png",
	Order = 50008,

	Filter = function(self, ent, ply) -- decide whether this property should be shown for an entity (Client)
		if IsValid(ent) && ent:IsNPC() && ent.IsVJBaseSNPC && gamemode.Call("CanProperty", ply, "vj_npc_properties", ent) then
			return true
		end
		return false
	end,
	
	Action = function(self, ent) -- Called when the property is clicked (Client)
		self:MsgStart()
			net.WriteEntity(ent)
		self:MsgEnd()
	end,
	
	Receive = function(self, length, ply) -- Called when "Action" sends a message (Server)
		local ent = net.ReadEntity()
		if (!self:Filter(ent, ply)) then return end
		if ent.VJ_DEBUG then
			ply:ChatPrint("Disabled Developer Mode for "..ent:GetName()..".")
			ent.VJ_DEBUG = false
		else
			ply:ChatPrint("Enabled Developer Mode for "..ent:GetName()..". Navigate to the NPC developer menu to toggle items you want.")
			ent.VJ_DEBUG = true
		end
	end
})