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
		panel:Help("#tool.vj_tool_notarget.menu.label")
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
	if ent:IsFlagSet(FL_NOTARGET) != true then
		self:GetOwner():ChatPrint("Set no target to " .. VJ.GetName(ent) .. ": ON")
		ent:AddFlags(FL_NOTARGET)
		return true
	else
		self:GetOwner():ChatPrint("Set no target to " .. VJ.GetName(ent) .. ": OFF")
		ent:RemoveFlags(FL_NOTARGET)
		return true
	end
end