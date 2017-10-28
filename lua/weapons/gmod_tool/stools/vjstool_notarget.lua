TOOL.Name = "No Target"
TOOL.Category = "Tools"
TOOL.Tab = "DrVrej"
TOOL.Command = nil
TOOL.ConfigName = ""

local DefaultConVars = {}
for k,v in pairs(TOOL.ClientConVar) do
	DefaultConVars["vjstool_notarget_"..k] = v
end
---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
	language.Add("tool.vjstool_notarget.name", "No Target")
	language.Add("tool.vjstool_notarget.desc", "Setting no target will make all NPCs not see a certain player or NPC")
	language.Add("tool.vjstool_notarget.0", "Left-Click to toggle no target to yourself, Right-Click to toggle no target to the current player or NPC")
---------------------------------------------------------------------------------------------------------------------------------------------
local function DoBuildCPanel_NoTarget(Panel)
	Panel:AddControl("Label", {Text = "Left-Click to set no target to yourself, Right-Click to set no target to the current player or NPC"})
end
---------------------------------------------------------------------------------------------------------------------------------------------
	function TOOL.BuildCPanel(Panel)
		DoBuildCPanel_NoTarget(Panel)
	end
else -- If SERVER
	// Nothing...
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:LeftClick(tr)
	if (CLIENT) then return true end
	local Ply = self:GetOwner()
	if Ply:IsFlagSet(FL_NOTARGET) != true then
		Ply:ChatPrint("Set no target to yourself: ON")
		Ply:SetNoTarget(true)
		Ply.VJ_NoTarget = true
		return true
	else
		Ply:ChatPrint("Set no target to yourself: OFF")
		Ply:SetNoTarget(false)
		Ply.VJ_NoTarget = false
		return true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:RightClick(tr)
	if (CLIENT) then return true end
	if !IsValid(tr.Entity) then return false end
	local Ply = self:GetOwner()
	local Ent = tr.Entity
	
	if Ent:IsPlayer() then
		if Ent:IsFlagSet(FL_NOTARGET) != true then
			Ply:ChatPrint("Set no target to "..Ent:Nick()..": ON")
			Ent:SetNoTarget(true)
			Ent.VJ_NoTarget = true
			return true
		else
			Ply:ChatPrint("Set no target to "..Ent:Nick()..": OFF")
			Ent:SetNoTarget(false)
			Ent.VJ_NoTarget = false
			return true
		end
	end
	
	if Ent:IsNPC() then
		if Ent.VJ_NoTarget != true then
			Ply:ChatPrint("Set no target to "..Ent:GetClass()..": ON")
			Ent.VJ_NoTarget = true
			return true
		else
			Ply:ChatPrint("Set no target to "..Ent:GetClass()..": OFF")
			Ent.VJ_NoTarget = false
			return true
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:Reload(tr)
	if (CLIENT) then return true end
	return false
end