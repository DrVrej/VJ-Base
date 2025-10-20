TOOL.Name = "#tool.vj_tool_equipment.name"
TOOL.Tab = "DrVrej"
TOOL.Category = "Tools"
TOOL.Information = {
	{name = "left"},
	{name = "right"},
}
TOOL.ClientConVar = {
	weaponclass = "None",
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
					local getPanel = controlpanel.Get("vj_tool_equipment")
					getPanel:Clear()
					ControlPanel(getPanel)
				end)
			end
		panel:AddPanel(reset)
		
		panel:Help("#tool.vj_tool_equipment.label")
		
		local wepText = vgui.Create("DTextEntry")
			wepText:SetEditable(false)
			local equipName = "None"
			local equipClass = GetConVar("vj_tool_equipment_weaponclass"):GetString()
			for _, v in pairs(list.Get("NPCUsableWeapons")) do
				if v.class == equipClass then
					equipName = language.GetPhrase(v.title)
					break
				end
			end
			wepText:SetText(language.GetPhrase("#tool.vj_tool_equipment.selected") .. ": " .. equipName .. " [" .. equipClass .. "]")
			function wepText:OnGetFocus()
				local wepSelFrame = vgui.Create("DFrame")
					wepSelFrame:SetSize(420, 440)
					wepSelFrame:SetPos(ScrW() * 0.6, ScrH() * 0.1)
					wepSelFrame:SetTitle("#tool.vj_tool_equipment.print.doubleclick")
					wepSelFrame:SetFocusTopLevel(true)
					wepSelFrame:ShowCloseButton(true)
					wepSelFrame:MakePopup()
				local wepSelList = vgui.Create("DListView")
					wepSelList:SetParent(wepSelFrame)
					wepSelList:SetPos(10, 30)
					wepSelList:SetSize(400, 400)
					wepSelList:SetMultiSelect(false)
					wepSelList:AddColumn("#tool.vj_tool_equipment.header1")
					wepSelList:AddColumn("#tool.vj_tool_equipment.header2")
					function wepSelList:OnRowSelected(rowIndex, row)
						chat.AddText(VJ.COLOR_GREEN, "#tool.vj_tool_equipment.print.doubleclick")
					end
					function wepSelList:DoDoubleClick(lineID, line)
						chat.AddText(VJ.COLOR_GREEN, "#tool.vj_tool_equipment.print.weaponselected1", VJ.COLOR_ORANGE_VIVID, " " .. language.GetPhrase(line:GetValue(1)) .. " ", VJ.COLOR_GREEN, "#tool.vj_tool_equipment.print.weaponselected2")
						LocalPlayer():ConCommand("vj_tool_equipment_weaponclass " .. line:GetValue(2))
						wepSelFrame:Close()
						wepText:SetText(language.GetPhrase("#tool.vj_tool_equipment.selected") .. ": " .. language.GetPhrase(line:GetValue(1)) .. " [" .. line:GetValue(2) .. "]")
					end
				for _, v in pairs(list.Get("NPCUsableWeapons")) do
					wepSelList:AddLine(v.title, v.class)
				end
				wepSelList:SortByColumn(1, false)
			end
		panel:AddItem(wepText)
	end
---------------------------------------------------------------------------------------------------------------------------------------------
	function TOOL.BuildCPanel(panel)
		ControlPanel(panel)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- For saves and duplications
local function ApplyWeapon(ply, ent, data)
	if data then
		local className = data[1]
		if className then
			ent:Give(className)
			if SERVER then
				duplicator.StoreEntityModifier(ent, "vj_tool_equipment", data)
			end
		end
	end
end
duplicator.RegisterEntityModifier("vj_tool_equipment", ApplyWeapon)
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:LeftClick(tr)
	if CLIENT then return true end
	local ent = tr.Entity
	if !IsValid(ent) or !ent:IsNPC() then return end
	if IsValid(ent:GetActiveWeapon()) then ent:GetActiveWeapon():Remove() end
	local equipment = self:GetClientInfo("weaponclass")
	if equipment != "None" then
		ApplyWeapon(self:GetOwner(), ent, {equipment})
	end
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:RightClick(tr)
	if CLIENT then return true end
	local ent = tr.Entity
	if !IsValid(ent) or !ent:IsNPC() then return end
	if IsValid(ent:GetActiveWeapon()) then ent:GetActiveWeapon():Remove() end
	return true
end