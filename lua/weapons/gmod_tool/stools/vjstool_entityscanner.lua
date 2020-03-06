TOOL.Name = "#tool.vjstool_entityscanner.name"
TOOL.Tab = "DrVrej"
TOOL.Category = "Tools"
TOOL.Command = nil -- The console command to execute upon being selected in the Q menu.

TOOL.Information = {
	{name = "left"},
}

-- Just to make it easier to reset everything to default
local DefaultConVars = {}
for k,v in pairs(TOOL.ClientConVar) do
	DefaultConVars["vjstool_entityscanner_"..k] = v
end
---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
	local function DoBuildCPanel_EntityScanner(Panel)
		Panel:AddControl("Label", {Text = "#tool.vjstool_entityscanner.label"})
	end
---------------------------------------------------------------------------------------------------------------------------------------------
	function TOOL.BuildCPanel(Panel)
		DoBuildCPanel_EntityScanner(Panel)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:LeftClick(tr)
	if (CLIENT) then return true end
	if !IsValid(tr.Entity) then return false end
	local Ply = self:GetOwner()
	local Ent = tr.Entity
	local Phys = Ent:GetPhysicsObject()
	PrintMessage(HUD_PRINTCONSOLE,"------------------- Name = "..Ent:GetName().." ||| Class = "..Ent:GetClass().." ||| Index = "..Ent:EntIndex().." -------------------")
	PrintMessage(HUD_PRINTCONSOLE,"MODEL: File Path = "..Ent:GetModel().." ||| Skin = "..Ent:GetSkin())
	PrintMessage(HUD_PRINTCONSOLE,"POSITION: Vector("..Ent:GetPos().x..", "..Ent:GetPos().y..", "..Ent:GetPos().z..") ||| X = "..Ent:GetPos().x.." , Y = "..Ent:GetPos().y.." , Z = "..Ent:GetPos().z)
	PrintMessage(HUD_PRINTCONSOLE,"ANGLE: Angle("..Ent:GetAngles().p..", "..Ent:GetAngles().y..", "..Ent:GetAngles().r..") ||| Pitch = "..Ent:GetAngles().p.." , Yaw = "..Ent:GetAngles().y.." , Roll = "..Ent:GetAngles().r)
	PrintMessage(HUD_PRINTCONSOLE,"SEQUENCE: ID = "..Ent:GetSequence().." ||| Name = "..Ent:GetSequenceName(Ent:GetSequence()).." ||| Duration = "..VJ_GetSequenceDuration(Ent,Ent:GetSequenceName(Ent:GetSequence())))
	if IsValid(Phys) then
		PrintMessage(HUD_PRINTCONSOLE,"VELOCITY: Vector("..Phys:GetVelocity().x..", "..Phys:GetVelocity().y..", "..Phys:GetVelocity().z..") ||| X = "..Phys:GetVelocity().x.." , Y = "..Phys:GetVelocity().y.." , Z = "..Phys:GetVelocity().z.." ||| Length = "..Phys:GetVelocity():Length())
		PrintMessage(HUD_PRINTCONSOLE,"PHYSICS: Mass = "..Phys:GetMass().." ||| Surface Area = "..Phys:GetSurfaceArea().." ||| Volume = "..Phys:GetVolume())
	else
		PrintMessage(HUD_PRINTCONSOLE,"VELOCITY: Can't display this information! Reason: Model doesn't have proper physics!")
		PrintMessage(HUD_PRINTCONSOLE,"PHYSICS: Can't display this information! Reason: Model doesn't have proper physics!")
	end
	PrintMessage(HUD_PRINTCONSOLE,"COLOR: Color("..Ent:GetColor().r..", "..Ent:GetColor().g..", "..Ent:GetColor().b..", "..Ent:GetColor().a..") ||| Red = "..Ent:GetColor().r.." , Green = "..Ent:GetColor().g.." , Blue = "..Ent:GetColor().b.." , Alpha = "..Ent:GetColor().a)
	PrintMessage(HUD_PRINTCONSOLE,"-----------------------------------------------------------------------------------------------")
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:RightClick(tr)
	if (CLIENT) then return true end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:Reload(tr)
	if (CLIENT) then return true end
	return false
end