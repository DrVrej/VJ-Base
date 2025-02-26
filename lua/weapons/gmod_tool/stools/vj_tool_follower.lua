TOOL.Name = "#tool.vj_tool_follower.name"
TOOL.Tab = "DrVrej"
TOOL.Category = "Tools"
TOOL.Information = {
	{name = "left"},
	{name = "right"},
	{name = "reload"},
}

-- Just to make it easier to reset everything to default
local DefaultConVars = {}
for k,v in pairs(TOOL.ClientConVar) do
	DefaultConVars["vj_tool_follower_"..k] = v
end

local strNoSelection = "No NPC selected"
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	local function DoBuildCPanel_NPCFollower(Panel, curEntName)
		curEntName = curEntName or strNoSelection
		local reset = vgui.Create("DButton")
		reset:SetFont("DermaDefaultBold")
		reset:SetText("#vjbase.menu.general.reset.everything")
		reset:SetSize(150, 25)
		reset:SetColor(VJ.COLOR_BLACK)
		reset.DoClick = function()
			for k, v in pairs(DefaultConVars) do
				if v == "" then
					LocalPlayer():ConCommand(k.." ".."None")
				else
					LocalPlayer():ConCommand(k.." "..v)
				end
				timer.Simple(0.05,function()
					local GetPanel = controlpanel.Get("vj_tool_follower")
					GetPanel:ClearControls()
					DoBuildCPanel_NPCFollower(GetPanel)
				end)
			end
		end
		Panel:AddPanel(reset)
		
		Panel:AddControl("Label", {Text = "#tool.vjstool.menu.label.recommendation"})
		Panel:AddControl("Label", {Text = "Selected NPC: " .. curEntName})
	end
---------------------------------------------------------------------------------------------------------------------------------------------
	net.Receive("vj_npcfollower_cl_update", function(len, ply)
		local wep = LocalPlayer():GetActiveWeapon()
		if wep:IsValid() && wep:GetClass() == "gmod_tool" && wep:GetMode() == "vj_tool_follower" then
			local entName = net.ReadString()
			local GetPanel = controlpanel.Get("vj_tool_follower")
			GetPanel:ClearControls()
			DoBuildCPanel_NPCFollower(GetPanel, entName)
		end
	end)
---------------------------------------------------------------------------------------------------------------------------------------------
	function TOOL.BuildCPanel(Panel)
		DoBuildCPanel_NPCFollower(Panel)
	end
else -- If SERVER
	util.AddNetworkString("vj_npcfollower_cl_update")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:LeftClick(tr)
	if CLIENT then return true end
	local ent = tr.Entity
	if (!IsValid(ent)) or !ent:IsNPC() or !ent.IsVJBaseSNPC then return end
	
	local npcName = list.Get("NPC")[ent:GetClass()].Name
	local ply = self:GetOwner()
	local selectedEnt = self:GetEnt(1)
	-- If we are selecting the NPC then unselected it
	if IsValid(selectedEnt) && selectedEnt == ent then
		self:ClearObjects()
		ply:ChatPrint(npcName .. " Has been unselected!")
		net.Start("vj_npcfollower_cl_update")
		net.WriteString(strNoSelection)
		net.Send(ply)
	else -- Select new NPC
		self:ClearObjects()
		self:SetObject(1, ent, tr.HitPos, Phys, tr.PhysicsBone, tr.HitNormal)
		ply:ChatPrint(npcName .. " Has been selected!")
		net.Start("vj_npcfollower_cl_update")
		net.WriteString(npcName .. " " .. tostring(ent))
		net.Send(ply)
	end
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:RightClick(tr)
	if CLIENT then return true end
	local ent = tr.Entity
	if (!IsValid(ent)) then return end
	
	local ply = self:GetOwner()
	local selectedEnt = self:GetEnt(1)
	if IsValid(selectedEnt) then
		local followed, failureReason = selectedEnt:Follow(ent, false)
		if followed then -- Follow attempt successful
			self:ClearObjects()
			ply:ChatPrint(list.Get("NPC")[selectedEnt:GetClass()].Name .. " is now following " .. ent:GetClass())
		elseif failureReason == 1 then
			ply:ChatPrint("ERROR: " .. list.Get("NPC")[selectedEnt:GetClass()].Name .. " NPC is stationary and currently unable to follow!")
		elseif failureReason == 2 then
			ply:ChatPrint("ERROR: " .. list.Get("NPC")[selectedEnt:GetClass()].Name .. " is already following another entity!")
		elseif failureReason == 3 then
			ply:ChatPrint("ERROR: " .. list.Get("NPC")[selectedEnt:GetClass()].Name .. " is NOT friendly to the other entity!")
		else -- Follow failed!
			ply:ChatPrint("ERROR: " .. list.Get("NPC")[selectedEnt:GetClass()].Name .. " is currently unable to follow!")
		end
	else
		ply:ChatPrint("#tool.vj_tool_follower.print.noselection")
	end
	net.Start("vj_npcfollower_cl_update")
	net.WriteString(strNoSelection)
	net.Send(ply)
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:Reload(tr)
	if CLIENT then return true end
	local ent = tr.Entity
	if (!IsValid(ent)) or !ent:IsNPC() or !ent.IsVJBaseSNPC then return end
	
	ent:ResetFollowBehavior()
	self:GetOwner():ChatPrint("#tool.vj_tool_follower.print.reset")
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
/*function TOOL:Holster()
	self:ClearObjects()
	if SERVER then
		net.Start("vj_npcfollower_cl_update")
		net.WriteString(strNoSelection)
		net.Send(self:GetOwner())
	end
end*/