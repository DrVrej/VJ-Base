TOOL.Name = "#tool.vjstool_notarget.name"
TOOL.Tab = "DrVrej"
TOOL.Category = "Tools"
TOOL.Command = nil -- The console command to execute upon being selected in the Q menu.

TOOL.Information = {
	{name = "left"},
	{name = "right"},
}

-- Just to make it easier to reset everything to default
local DefaultConVars = {}
for k,v in pairs(TOOL.ClientConVar) do
	DefaultConVars["vjstool_notarget_"..k] = v
end
---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
	local function DoBuildCPanel_NoTarget(Panel)
		Panel:AddControl("Label", {Text = "#tool.vjstool_notarget.label"})
	end
---------------------------------------------------------------------------------------------------------------------------------------------
	function TOOL.BuildCPanel(Panel)
		DoBuildCPanel_NoTarget(Panel)
	end
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