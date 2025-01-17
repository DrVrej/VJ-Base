TOOL.Name = "#tool.vj_tool_notarget.name"
TOOL.Tab = "DrVrej"
TOOL.Category = "Tools"
TOOL.Command = nil -- The console command to execute upon being selected in the Q menu.

TOOL.Information = {
	{name = "left"},
	{name = "right"},
}
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	local function DoBuildCPanel_NoTarget(Panel)
		Panel:AddControl("Label", {Text = "#tool.vj_tool_notarget.label"})
	end
---------------------------------------------------------------------------------------------------------------------------------------------
	function TOOL.BuildCPanel(Panel)
		DoBuildCPanel_NoTarget(Panel)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:LeftClick(tr)
	if CLIENT then return true end
	local Ply = self:GetOwner()
	if Ply:IsFlagSet(FL_NOTARGET) != true then
		Ply:ChatPrint("#tool.vj_tool_notarget.print.yourselfon")
		Ply:AddFlags(FL_NOTARGET)
		return true
	else
		Ply:ChatPrint("#tool.vj_tool_notarget.print.yourselfoff")
		Ply:RemoveFlags(FL_NOTARGET)
		return true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:RightClick(tr)
	if CLIENT then return true end
	if !IsValid(tr.Entity) then return false end
	local Ply = self:GetOwner()
	local Ent = tr.Entity
	
	local name = Ent:IsPlayer() and Ent:Nick() or Ent:GetClass()
	if Ent:IsFlagSet(FL_NOTARGET) != true then
		Ply:ChatPrint("Set no target to "..name..": ON")
		Ent:AddFlags(FL_NOTARGET)
		return true
	else
		Ply:ChatPrint("Set no target to "..name..": OFF")
		Ent:RemoveFlags(FL_NOTARGET)
		return true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:Reload(tr)
	if CLIENT then return true end
	return false
end