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
			reset:SetSize(150, 25)
			reset:SetColor(VJ.COLOR_BLACK)
			function reset:DoClick()
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
			function tutorial:DoClick()
				gui.OpenURL("http://www.youtube.com/watch?v=Qf-vrE-BAW4")
			end
		panel:AddPanel(tutorial)
		
		panel:Help("#vjbase.tool.general.note.recommend")
		panel:ControlHelp("- " .. language.GetPhrase("#tool.vj_tool_bullseye.menu.help1"))
		panel:ControlHelp("- " .. language.GetPhrase("#tool.vj_tool_bullseye.menu.help2"))
		
		panel:Help(language.GetPhrase("#tool.vj_tool_bullseye.menu.movetype") .. ":")
		local typeCombo = vgui.Create("DComboBox")
			typeCombo:SetConVar("vj_tool_bullseye_type")
			typeCombo:AddChoice("Dynamic")
			typeCombo:AddChoice("Static")
			typeCombo:AddChoice("Physics")
			function typeCombo:OnSelect(index, value, data)
				LocalPlayer():ConCommand("vj_tool_bullseye_type " .. value)
			end
		panel:AddPanel(typeCombo)
		
		panel:Help(language.GetPhrase("#tool.vj_tool_bullseye.menu.modeldir") .. ":")
		local modelDir = vgui.Create("DTextEntry")
			modelDir:SetPlaceholderText(language.GetPhrase("#tool.vj_tool_bullseye.menu.modeldir.text") .. "...")
			modelDir:SetConVar("vj_tool_bullseye_model")
			modelDir:SetMultiline(false)
		panel:AddPanel(modelDir)
		
		panel:CheckBox("#tool.vj_tool_bullseye.menu.toggle.color", "vj_tool_bullseye_usecolor")
		panel:CheckBox("#tool.vj_tool_bullseye.menu.toggle.startactivated", "vj_tool_bullseye_startactivate")
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
	spawner:SetModel(self:GetClientInfo("model"))
	spawner.SolidMovementType = self:GetClientInfo("type")
	spawner.CanToggle = true
	spawner.ToggleDisplayColors = self:GetClientBool("usecolor")
	spawner.Activated = self:GetClientBool("startactivate")
	spawner:Spawn()
	spawner:Activate()
	undo.Create("NPC Bullseye")
		undo.AddEntity(spawner)
		undo.SetPlayer(self:GetOwner())
	undo.Finish()
	return true
end