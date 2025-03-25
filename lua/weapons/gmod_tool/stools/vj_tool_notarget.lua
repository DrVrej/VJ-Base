TOOL.Name = "#tool.vj_tool_notarget.name"
TOOL.Tab = "DrVrej"
TOOL.Category = "Tools"
TOOL.Information = {
	{name = "left"},
	{name = "right"},
}
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	function TOOL.BuildCPanel(panel)
		panel:Help("#tool.vj_tool_notarget.label")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:LeftClick(tr)
	if CLIENT then return true end
	local owner = self:GetOwner()
	if owner:IsFlagSet(FL_NOTARGET) != true then
		owner:ChatPrint("#tool.vj_tool_notarget.print.yourselfon")
		owner:AddFlags(FL_NOTARGET)
		return true
	else
		owner:ChatPrint("#tool.vj_tool_notarget.print.yourselfoff")
		owner:RemoveFlags(FL_NOTARGET)
		return true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:RightClick(tr)
	if CLIENT then return true end
	local ent = tr.Entity
	if !IsValid(ent) then return false end
	local owner = self:GetOwner()
	local name = ent:IsPlayer() and ent:Nick() or ent:GetClass()
	if ent:IsFlagSet(FL_NOTARGET) != true then
		owner:ChatPrint("Set no target to " .. name .. ": ON")
		ent:AddFlags(FL_NOTARGET)
		return true
	else
		owner:ChatPrint("Set no target to " .. name .. ": OFF")
		ent:RemoveFlags(FL_NOTARGET)
		return true
	end
end