TOOL.Name = "Entity Scanner"
TOOL.Category = "Tools"
TOOL.Tab = "DrVrej"
TOOL.Command = nil
TOOL.ConfigName = ""

local DefaultConVars = {}
for k,v in pairs(TOOL.ClientConVar) do
	DefaultConVars["vjstool_entityscanner_"..k] = v
end
---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
	language.Add("tool.vjstool_entityscanner.name", "Entity Scanner")
	language.Add("tool.vjstool_entityscanner.desc", "Get information about an entity")
	language.Add("tool.vjstool_entityscanner.0", "Left-Click to print information about the entity in console")
---------------------------------------------------------------------------------------------------------------------------------------------
local function DoBuildCPanel_EntityScanner(Panel)
	Panel:AddControl("Label", {Text = "Left-Click to print information about the entity in the console"})
end
---------------------------------------------------------------------------------------------------------------------------------------------
	function TOOL.BuildCPanel(Panel)
		DoBuildCPanel_EntityScanner(Panel)
	end
else -- If SERVER
	// Nothing...
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:LeftClick(tr)
	if (CLIENT) then return true end
	if !IsValid(tr.Entity)then return false end
	local Ply = self:GetOwner()
	local Ent = tr.Entity
	local Phys = Ent:GetPhysicsObject()
	PrintMessage(HUD_PRINTCONSOLE,"------------------- Name = "..Ent:GetName().." ||| Class = "..Ent:GetClass().." ||| Index = "..Ent:EntIndex().." -------------------")
	PrintMessage(HUD_PRINTCONSOLE,"MODEL: File Path = "..Ent:GetModel().." ||| Skin = "..Ent:GetSkin())
	PrintMessage(HUD_PRINTCONSOLE,"POSITION: Vector("..Ent:GetPos().x..", "..Ent:GetPos().y..", "..Ent:GetPos().z..") ||| X = "..Ent:GetPos().x.." , Y = "..Ent:GetPos().y.." , Z = "..Ent:GetPos().z)
	PrintMessage(HUD_PRINTCONSOLE,"ANGLE: Angle("..Ent:GetAngles().p..", "..Ent:GetAngles().y..", "..Ent:GetAngles().r..") ||| Pitch = "..Ent:GetAngles().p.." , Yaw = "..Ent:GetAngles().y.." , Roll = "..Ent:GetAngles().r)
	PrintMessage(HUD_PRINTCONSOLE,"SEQUENCE: ID = "..Ent:GetSequence().." ||| Name = "..Ent:GetSequenceName(Ent:GetSequence()).." ||| Duration = "..VJ_GetSequenceDuration(Ent,Ent:GetSequenceName(Ent:GetSequence())))
	PrintMessage(HUD_PRINTCONSOLE,"VELOCITY: Vector("..Phys:GetVelocity().x..", "..Phys:GetVelocity().y..", "..Phys:GetVelocity().z..") ||| X = "..Phys:GetVelocity().x.." , Y = "..Phys:GetVelocity().y.." , Z = "..Phys:GetVelocity().z.." ||| Length = "..Phys:GetVelocity():Length())
	PrintMessage(HUD_PRINTCONSOLE,"COLOR: Color("..Ent:GetColor().r..", "..Ent:GetColor().g..", "..Ent:GetColor().b..", "..Ent:GetColor().a..") ||| Red = "..Ent:GetColor().r.." , Green = "..Ent:GetColor().g.." , Blue = "..Ent:GetColor().b.." , Alpha = "..Ent:GetColor().a)
	PrintMessage(HUD_PRINTCONSOLE,"PHYSICS: Mass = "..Phys:GetMass().." ||| Surface Area = "..Phys:GetSurfaceArea().." ||| Volume = "..Phys:GetVolume())
	PrintMessage(HUD_PRINTCONSOLE,"")
	PrintMessage(HUD_PRINTCONSOLE,"")
	PrintMessage(HUD_PRINTCONSOLE,"")
	PrintMessage(HUD_PRINTCONSOLE,"")
	PrintMessage(HUD_PRINTCONSOLE,"")
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
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:Holster()
	
end