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

-- Just to make it easier to reset everything to default
local DefaultConVars = {}
for k,v in pairs(TOOL.ClientConVar) do
	DefaultConVars["vj_tool_equipment_"..k] = v
end
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	local function DoBuildCPanel_VJ_NPCEquipment(Panel)
		local reset = vgui.Create("DButton")
		reset:SetFont("DermaDefaultBold")
		reset:SetText("#vjbase.menu.general.reset.everything")
		reset:SetSize(150,25)
		reset:SetColor(VJ.COLOR_BLACK)
		reset.DoClick = function()
			for k,v in pairs(DefaultConVars) do
				if v == "" then
				LocalPlayer():ConCommand(k.." ".."None")
			else
				LocalPlayer():ConCommand(k.." "..v) end
				timer.Simple(0.05,function()
					local GetPanel = controlpanel.Get("vj_tool_equipment")
					GetPanel:ClearControls()
					DoBuildCPanel_VJ_NPCEquipment(GetPanel)
				end)
			end
		end
		Panel:AddPanel(reset)
		
		Panel:AddControl("Label", {Text = "#tool.vj_tool_equipment.label"})
		
		local selectwep = vgui.Create("DTextEntry")
		selectwep:SetEditable(false)
		selectwep:SetText(language.GetPhrase("#tool.vj_tool_equipment.selectedequipment")..": "..GetConVarString("vj_tool_equipment_weaponname").." ["..GetConVarString("vj_tool_equipment_weaponclass").."]")
		selectwep.OnGetFocus = function() LocalPlayer():ConCommand("vj_npcequipment_openwepselect") end
		Panel:AddItem(selectwep)
	end
---------------------------------------------------------------------------------------------------------------------------------------------
	function TOOL.BuildCPanel(Panel)
		DoBuildCPanel_VJ_NPCEquipment(Panel)
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
				timer.Simple(0.05, function()
					local GetPanel = controlpanel.Get("vj_tool_equipment")
					GetPanel:ClearControls()
					DoBuildCPanel_VJ_NPCEquipment(GetPanel)
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
	if !tr.Entity:IsNPC() then return end
	if IsValid(tr.Entity:GetActiveWeapon()) then tr.Entity:GetActiveWeapon():Remove() end
	local equipment = GetConVarString("vj_tool_equipment_weaponclass")
	if equipment != "None" then
		tr.Entity:Give(equipment)
	end
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:RightClick(tr)
	if CLIENT then return true end
	if !tr.Entity:IsNPC() then return end
	if IsValid(tr.Entity:GetActiveWeapon()) then tr.Entity:GetActiveWeapon():Remove() end
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:Reload(tr)
	if CLIENT then return true end
end