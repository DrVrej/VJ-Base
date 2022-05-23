TOOL.Name = "#tool.vjstool_npcfollower.name"
TOOL.Tab = "DrVrej"
TOOL.Category = "Tools"
TOOL.Command = nil -- The console command to execute upon being selected in the Q menu.

TOOL.Information = {
	{name = "left"},
	{name = "right"},
	{name = "reload"},
}

-- Just to make it easier to reset everything to default
local DefaultConVars = {}
for k,v in pairs(TOOL.ClientConVar) do
	DefaultConVars["vjstool_npcfollower_"..k] = v
end
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	NPC_FOLLOWER_ENT_NAME = "None"
	local function DoBuildCPanel_NPCFollower(Panel)
		local reset = vgui.Create("DButton")
		reset:SetFont("DermaDefaultBold")
		reset:SetText("#vjbase.menu.general.reset.everything")
		reset:SetSize(150, 25)
		reset:SetColor(Color(0,0,0,255))
		reset.DoClick = function()
			for k, v in pairs(DefaultConVars) do
				if v == "" then
					LocalPlayer():ConCommand(k.." ".."None")
				else
					LocalPlayer():ConCommand(k.." "..v)
				end
				timer.Simple(0.05,function()
					GetPanel = controlpanel.Get("vjstool_npcfollower")
					GetPanel:ClearControls()
					DoBuildCPanel_NPCFollower(GetPanel)
				end)
			end
		end
		Panel:AddPanel(reset)
		
		Panel:AddControl("Label", {Text = "#tool.vjstool.menu.label.recommendation"})
		Panel:AddControl("Label", {Text = "Selected NPC: " .. NPC_FOLLOWER_ENT_NAME})
		
	end
---------------------------------------------------------------------------------------------------------------------------------------------
	net.Receive("vj_npcfollower_cl_update", function(len, ply)
		local wep = LocalPlayer():GetActiveWeapon()
		if wep:IsValid() && wep:GetClass() == "gmod_tool" && wep:GetMode() == "vjstool_npcfollower" then
			local entName = net.ReadString()
			NPC_FOLLOWER_ENT_NAME = entName
			GetPanel = controlpanel.Get("vjstool_npcfollower")
			GetPanel:ClearControls()
			DoBuildCPanel_NPCFollower(GetPanel)
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
	if (!IsValid(ent)) then return end
	if !ent:IsNPC() then return end
	if !ent.IsVJBaseSNPC then return end
	
	local NPCname = list.Get("NPC")[ent:GetClass()].Name
	local ply = self:GetOwner()
	self:ClearObjects()
	self:SetObject(1, ent, tr.HitPos, Phys, tr.PhysicsBone, tr.HitNormal)
	//if CLIENT then return true end
	ply:ChatPrint(NPCname .. " Has been selected!")
	
	net.Start("vj_npcfollower_cl_update")
	net.WriteString(NPCname)
	net.Send(ply)
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:RightClick(tr)
	if CLIENT then return true end
	local ent = tr.Entity
	if (!IsValid(ent)) then return end
	
	local iNum = self:NumObjects()
	local ply = self:GetOwner()
	if iNum >= 1 then
		local selectedEnt = self:GetEnt(1)
		if IsValid(selectedEnt) then
			if selectedEnt:Follow(ent, false) then
				self:ClearObjects()
				ply:ChatPrint(list.Get("NPC")[selectedEnt:GetClass()].Name .. " is now following " .. ent:GetClass())
			else
				ply:ChatPrint(list.Get("NPC")[selectedEnt:GetClass()].Name .. " is currently unable to follow!")
			end
		else
			ply:ChatPrint("#tool.vjstool_npcfollower.print.noselection")
		end
	else
		ply:ChatPrint("#tool.vjstool_npcfollower.print.noselection")
	end
	//if CLIENT then return true end
	net.Start("vj_npcfollower_cl_update")
	net.WriteString("None")
	net.Send(ply)
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:Reload(tr)
	if CLIENT then return true end
	local ent = tr.Entity
	if (!IsValid(ent)) then return end
	if !ent:IsNPC() then return end
	if !ent.IsVJBaseSNPC then return end
	
	ent:FollowReset()
	local ply = self:GetOwner()
	ply:ChatPrint("#tool.vjstool_npcfollower.print.reset")
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:Holster()
	if SERVER then
		net.Start("vj_npcfollower_cl_update")
		net.WriteString("None")
		net.Send(self:GetOwner())
	end
	self:ClearObjects()
end