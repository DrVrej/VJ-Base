TOOL.Name = "#tool.vj_tool_scanner.name"
TOOL.Tab = "DrVrej"
TOOL.Category = "Tools"
TOOL.Information = {
	{name = "left"},
}
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	function TOOL.BuildCPanel(panel)
		panel:Help("#tool.vj_tool_scanner.menu.label")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:LeftClick(tr)
	if CLIENT then return true end
	local ent = tr.Entity
	if !IsValid(ent) then return false end
	local ply = self:GetOwner()
	local phys = ent:GetPhysicsObject()
	ply:PrintMessage(HUD_PRINTCONSOLE, "-----------------------------------------------------------------------------------------------")
	ply:PrintMessage(HUD_PRINTCONSOLE, "====> " .. tostring(ent) .. " / " .. VJ.GetName(ent) .. " <==== \n\n")
	ply:PrintMessage(HUD_PRINTCONSOLE, "MODEL    ==> " .. ent:GetModel() .. " ;;; Skin = " .. ent:GetSkin() .. "\n\n")
	ply:PrintMessage(HUD_PRINTCONSOLE, "POSITION ==> Vector(" .. ent:GetPos().x .. ", " .. ent:GetPos().y .. ", " .. ent:GetPos().z .. ")\n\n")
	ply:PrintMessage(HUD_PRINTCONSOLE, "ANGLE    ==> Angle(" .. ent:GetAngles().p .. ", " .. ent:GetAngles().y .. ", " .. ent:GetAngles().r .. ")\n\n")
	ply:PrintMessage(HUD_PRINTCONSOLE, "SEQUENCE ==> \"" .. ent:GetSequenceName(ent:GetSequence()) .. "\" [" .. ent:GetSequence() .. "] ;;; Duration = " .. VJ.AnimDuration(ent, ent:GetSequenceName(ent:GetSequence())) .. "\n\n")
	if IsValid(phys) then
		ply:PrintMessage(HUD_PRINTCONSOLE, "VELOCITY ==> Vector(" .. phys:GetVelocity().x .. ", " .. phys:GetVelocity().y .. ", " .. phys:GetVelocity().z .. ") ;;; Length = " .. phys:GetVelocity():Length() .. "\n\n")
		ply:PrintMessage(HUD_PRINTCONSOLE, "PHYSICS  ==> Mass = " .. phys:GetMass() .. " ;;; Surface Area = " .. phys:GetSurfaceArea() .. " ;;; Volume = " .. phys:GetVolume() .. "\n\n")
	else
		ply:PrintMessage(HUD_PRINTCONSOLE, "VELOCITY ==> Model doesn't have a physics object!\n\n")
		ply:PrintMessage(HUD_PRINTCONSOLE, "PHYSICS  ==> Model doesn't have a physics object!\n\n")
	end
	ply:PrintMessage(HUD_PRINTCONSOLE, "COLOR    ==> Color(" .. ent:GetColor().r .. ", " .. ent:GetColor().g .. ", " .. ent:GetColor().b .. ", " .. ent:GetColor().a .. ")")
	ply:PrintMessage(HUD_PRINTCONSOLE, "-----------------------------------------------------------------------------------------------")
	return true
end