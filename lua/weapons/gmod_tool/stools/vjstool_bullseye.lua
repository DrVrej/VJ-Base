TOOL.Name = "#tool.vjstool_bullseye.name"
TOOL.Tab = "DrVrej"
TOOL.Category = "Tools"
TOOL.Command = nil -- The console command to execute upon being selected in the Q menu.

TOOL.Information = {
	{name = "left"},
}

TOOL.ClientConVar["type"] = "Dynamic"
TOOL.ClientConVar["modeldirectory"] = "models/hunter/plates/plate.mdl"
TOOL.ClientConVar["usecolor"] = 1
TOOL.ClientConVar["startactivate"] = 1

-- Just to make it easier to reset everything to default
local DefaultConVars = {}
for k,v in pairs(TOOL.ClientConVar) do
	DefaultConVars["vjstool_bullseye_"..k] = v
end
---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
	local function DoBuildCPanel_VJ_BullseyeSpawner(Panel)
		local reset = vgui.Create("DButton")
		reset:SetFont("DermaDefaultBold")
		reset:SetText("#vjbase.menu.general.reset.everything")
		reset:SetSize(150,25)
		reset:SetColor(Color(0,0,0,255))
		reset.DoClick = function()
			for k,v in pairs(DefaultConVars) do
				if v == "" then
				LocalPlayer():ConCommand(k.." ".."None")
			else
				LocalPlayer():ConCommand(k.." "..v) end
				timer.Simple(0.05,function()
					GetPanel = controlpanel.Get("vjstool_bullseye")
					GetPanel:ClearControls()
					DoBuildCPanel_VJ_BullseyeSpawner(GetPanel)
				end)
			end
		end
		Panel:AddPanel(reset)
		
		local tutorial = vgui.Create("DButton")
		tutorial:SetFont("DermaDefaultBold")
		tutorial:SetText("#tool.vjstool.menu.tutorialvideo")
		tutorial:SetSize(150, 20)
		tutorial:SetColor(Color(0,0,255,255))
		tutorial.DoClick = function()
			gui.OpenURL("http://www.youtube.com/watch?v=Qf-vrE-BAW4")
		end
		Panel:AddPanel(tutorial)
		
		Panel:AddControl("Label", {Text = "#tool.vjstool.menu.label.recommendation"})
		Panel:ControlHelp("- "..language.GetPhrase("#tool.vjstool_bullseye.menu.help1"))
		Panel:ControlHelp("- "..language.GetPhrase("#tool.vjstool_bullseye.menu.help2"))
		Panel:AddControl("Label", {Text = language.GetPhrase("#tool.vjstool_bullseye.menu.label1")..":"})
		local typebox = vgui.Create("DComboBox")
		//typebox:SetConVar("vjstool_bullseye_type")
		typebox:SetValue(GetConVarString("vjstool_bullseye_type"))
		typebox:AddChoice("Dynamic")
		typebox:AddChoice("Static")
		typebox:AddChoice("Physics")
		function typebox:OnSelect(index,value,data)
			LocalPlayer():ConCommand("vjstool_bullseye_type "..value)
		end
		Panel:AddPanel(typebox)
		Panel:AddControl("Label", {Text = language.GetPhrase("#tool.vjstool_bullseye.menu.label2")..":"})
		local modeldir = vgui.Create("DTextEntry")
		modeldir:SetConVar("vjstool_bullseye_modeldirectory")
		modeldir:SetMultiline(false)
		Panel:AddPanel(modeldir)
		Panel:AddControl("Checkbox", {Label = "#tool.vjstool_bullseye.menu.toggleusestatus", Command = "vjstool_bullseye_usecolor"})
		Panel:AddControl("Checkbox", {Label = "#tool.vjstool_bullseye.menu.togglestartactivated", Command = "vjstool_bullseye_startactivate"})
	end
---------------------------------------------------------------------------------------------------------------------------------------------
	function TOOL.BuildCPanel(Panel)
		DoBuildCPanel_VJ_BullseyeSpawner(Panel)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:LeftClick(tr)
	if (CLIENT) then return true end
		local spawner = ents.Create("obj_vj_bullseye")
		spawner:SetPos(tr.HitPos)
		spawner:SetModel(GetConVarString("vjstool_bullseye_modeldirectory"))
		spawner.SolidMovementType = GetConVarString("vjstool_bullseye_type")
		spawner.UserStatusColors = GetConVar("vjstool_bullseye_usecolor"):GetBool()
		spawner.Activated = GetConVar("vjstool_bullseye_startactivate"):GetBool()
		spawner:Spawn()
		spawner:Activate()
		undo.Create("NPC Bullseye")
		undo.AddEntity(spawner)
		undo.SetPlayer(self:GetOwner())
		undo.Finish()
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:RightClick(tr)
	if (CLIENT) then return true end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:Reload(tr)
	if (CLIENT) then return true end
end