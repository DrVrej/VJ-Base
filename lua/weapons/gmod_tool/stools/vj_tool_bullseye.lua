TOOL.Name = "#tool.vj_tool_bullseye.name"
TOOL.Tab = "DrVrej"
TOOL.Category = "Tools"
TOOL.Information = {
	{name = "left"},
}
TOOL.ClientConVar = {
	type = "Dynamic",
	model = "models/hunter/plates/plate.mdl",
	usecolor = 1,
	startactivate = 1
}

local defaultConvars = TOOL:BuildConVarList()
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	local function ControlPanel(panel)
		local reset = vgui.Create("DButton")
		reset:SetFont("DermaDefaultBold")
		reset:SetText("#vjbase.menu.general.reset.everything")
		reset:SetSize(150,25)
		reset:SetColor(VJ.COLOR_BLACK)
		reset.DoClick = function()
			for k, v in pairs(defaultConvars) do
				LocalPlayer():ConCommand(k .. " " .. v)
			end
			timer.Simple(0.05, function() -- Otherwise it will not update the values in time
				local getPanel = controlpanel.Get("vj_tool_bullseye")
				getPanel:Clear()
				ControlPanel(getPanel)
			end)
		end
		panel:AddPanel(reset)
		
		local tutorial = vgui.Create("DButton")
		tutorial:SetFont("DermaDefaultBold")
		tutorial:SetText("#vjbase.menu.general.tutorial.vid")
		tutorial:SetSize(150, 20)
		tutorial:SetColor(VJ.COLOR_BLUE)
		tutorial.DoClick = function()
			gui.OpenURL("http://www.youtube.com/watch?v=Qf-vrE-BAW4")
		end
		panel:AddPanel(tutorial)
		
		panel:AddControl("Label", {Text = "#vjbase.tool.general.note.recommend"})
		panel:ControlHelp("- "..language.GetPhrase("#tool.vj_tool_bullseye.menu.help1"))
		panel:ControlHelp("- "..language.GetPhrase("#tool.vj_tool_bullseye.menu.help2"))
		panel:AddControl("Label", {Text = language.GetPhrase("#tool.vj_tool_bullseye.menu.label1")..":"})
		local typebox = vgui.Create("DComboBox")
		//typebox:SetConVar("vj_tool_bullseye_type")
		typebox:SetValue(GetConVarString("vj_tool_bullseye_type"))
		typebox:AddChoice("Dynamic")
		typebox:AddChoice("Static")
		typebox:AddChoice("Physics")
		function typebox:OnSelect(index,value,data)
			LocalPlayer():ConCommand("vj_tool_bullseye_type "..value)
		end
		panel:AddPanel(typebox)
		panel:AddControl("Label", {Text = language.GetPhrase("#tool.vj_tool_bullseye.menu.label2")..":"})
		local modeldir = vgui.Create("DTextEntry")
		modeldir:SetConVar("vj_tool_bullseye_model")
		modeldir:SetMultiline(false)
		panel:AddPanel(modeldir)
		panel:AddControl("Checkbox", {Label = "#tool.vj_tool_bullseye.menu.toggleusestatus", Command = "vj_tool_bullseye_usecolor"})
		panel:AddControl("Checkbox", {Label = "#tool.vj_tool_bullseye.menu.togglestartactivated", Command = "vj_tool_bullseye_startactivate"})
	end
---------------------------------------------------------------------------------------------------------------------------------------------
	function TOOL.BuildCPanel(panel)
		ControlPanel(panel)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:LeftClick(tr)
	if CLIENT then return true end
	local spawner = ents.Create("obj_vj_bullseye")
	spawner:SetPos(tr.HitPos)
	spawner:SetModel(GetConVarString("vj_tool_bullseye_model"))
	spawner.SolidMovementType = GetConVarString("vj_tool_bullseye_type")
	spawner.UseActivationSystem = true
	spawner.ActivationSystemStatusColors = GetConVar("vj_tool_bullseye_usecolor"):GetBool()
	spawner.Activated = GetConVar("vj_tool_bullseye_startactivate"):GetBool()
	spawner:Spawn()
	spawner:Activate()
	undo.Create("NPC Bullseye")
	undo.AddEntity(spawner)
	undo.SetPlayer(self:GetOwner())
	undo.Finish()
	return true
end