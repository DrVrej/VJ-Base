TOOL.Name = "#tool.vj_tool_equipment.name"
TOOL.Tab = "DrVrej"
TOOL.Category = "Tools"
TOOL.Information = {
	{name = "left"},
	{name = "right"},
}
TOOL.ClientConVar = {
	weaponclass = "None",
	weaponname = "Unknown"
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
				local getPanel = controlpanel.Get("vj_tool_equipment")
				getPanel:Clear()
				ControlPanel(getPanel)
			end)
		end
		panel:AddPanel(reset)
		
		panel:AddControl("Label", {Text = "#tool.vj_tool_equipment.label"})
		
		local selectwep = vgui.Create("DTextEntry")
		selectwep:SetEditable(false)
		selectwep:SetText(language.GetPhrase("#tool.vj_tool_equipment.selectedequipment")..": "..GetConVarString("vj_tool_equipment_weaponname").." ["..GetConVarString("vj_tool_equipment_weaponclass").."]")
		selectwep.OnGetFocus = function() LocalPlayer():ConCommand("vj_npcequipment_openwepselect") end
		panel:AddItem(selectwep)
	end
---------------------------------------------------------------------------------------------------------------------------------------------
	function TOOL.BuildCPanel(panel)
		ControlPanel(panel)
	end
---------------------------------------------------------------------------------------------------------------------------------------------
	concommand.Add("vj_npcequipment_openwepselect",function(pl,cmd,args)
		local MenuFrame = vgui.Create('DFrame')
		MenuFrame:SetSize(420, 440)
		MenuFrame:SetPos(ScrW()*0.6, ScrH()*0.1)
		MenuFrame:SetTitle("#tool.vj_tool_equipment.print.doubleclick")
		//MenuFrame:SetBackgroundBlur(true)
		MenuFrame:SetFocusTopLevel(true)
		MenuFrame:SetSizable(true)
		MenuFrame:ShowCloseButton(true)
		//MenuFrame:SetDeleteOnClose(false)
		MenuFrame:MakePopup()
		
		local CheckList = vgui.Create("DListView")
			CheckList:SetTooltip(false)
			CheckList:SetParent(MenuFrame)
			CheckList:SetPos(10,30)
			CheckList:SetSize(400,400) -- Size
			CheckList:SetMultiSelect(false)
			CheckList:AddColumn("#tool.vj_tool_equipment.header1")
			CheckList:AddColumn("#tool.vj_tool_equipment.header2")
			CheckList.OnRowSelected = function() chat.AddText(Color(0,255,0), "#tool.vj_tool_equipment.print.doubleclick") end
			function CheckList:DoDoubleClick(lineID,line)
				chat.AddText(Color(0,255,0), "#tool.vj_tool_equipment.print.weaponselected1", Color(255,100,0), " "..line:GetValue(1).." ", Color(0,255,0), "#tool.vj_tool_equipment.print.weaponselected2")
				LocalPlayer():ConCommand("vj_tool_equipment_weaponname "..line:GetValue(1))
				LocalPlayer():ConCommand("vj_tool_equipment_weaponclass "..line:GetValue(2))
				MenuFrame:Close()
				timer.Simple(0.05, function() -- Otherwise it will not update the values in time
					local getPanel = controlpanel.Get("vj_tool_equipment")
					getPanel:Clear()
					ControlPanel(getPanel)
				end)
			end
		//MenuFrame:AddItem(CheckList)
		//CheckList:SizeToContents()
		for _,v in pairs(list.Get("NPCUsableWeapons")) do
			CheckList:AddLine(v.title,v.class)
		end
		CheckList:SortByColumn(1,false)
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:LeftClick(tr)
	if CLIENT then return true end
	
	local ent = tr.Entity
	if !IsValid(ent) or !ent:IsNPC() then return end
	local equipment = GetConVarString("vj_tool_equipment_weaponclass")
	
	if IsValid(ent:GetActiveWeapon()) then ent:GetActiveWeapon():Remove() end
	if equipment != "None" then
		ent:Give(equipment)
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