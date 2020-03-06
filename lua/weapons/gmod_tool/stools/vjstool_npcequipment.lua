TOOL.Name = "#tool.vjstool_npcequipment.name"
TOOL.Tab = "DrVrej"
TOOL.Category = "Tools"
TOOL.Command = nil -- The console command to execute upon being selected in the Q menu.

TOOL.Information = {
	{name = "left"},
	{name = "right"},
}

TOOL.ClientConVar["weaponclass"] = "None"
TOOL.ClientConVar["weaponname"] = "Unknown"

-- Just to make it easier to reset everything to default
local DefaultConVars = {}
for k,v in pairs(TOOL.ClientConVar) do
	DefaultConVars["vjstool_npcequipment_"..k] = v
end
---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
	local function DoBuildCPanel_VJ_NPCEquipment(Panel)
		local reset = vgui.Create("DButton")
		reset:SetFont("DermaDefaultBold")
		reset:SetText("#vjbase.menu.general.reset.everything")
		reset:SetSize(150,25)
		reset:SetColor(Color(0,0,0,255))
		reset.DoClick = function(reset)
			for k,v in pairs(DefaultConVars) do
				if v == "" then
				LocalPlayer():ConCommand(k.." ".."None")
			else
				LocalPlayer():ConCommand(k.." "..v) end
				timer.Simple(0.05,function()
					GetPanel = controlpanel.Get("vjstool_npcequipment")
					GetPanel:ClearControls()
					DoBuildCPanel_VJ_NPCEquipment(GetPanel)
				end)
			end
		end
		Panel:AddPanel(reset)
		
		Panel:AddControl("Label", {Text = "#tool.vjstool.menu.label.recommendation"})
		Panel:ControlHelp("#tool.vjstool_npcequipment.label")
		
		local selectwep = vgui.Create("DTextEntry")
		selectwep:SetEditable(false)
		selectwep:SetText(language.GetPhrase("#tool.vjstool_npcequipment.selectedequipment")..": "..GetConVarString("vjstool_npcequipment_weaponname").." ["..GetConVarString("vjstool_npcequipment_weaponclass").."]")
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
		MenuFrame:SetTitle("#tool.vjstool_npcequipment.print.doubleclick")
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
			CheckList:AddColumn("#tool.vjstool_npcequipment.header1")
			CheckList:AddColumn("#tool.vjstool_npcequipment.header2")
			CheckList.OnRowSelected = function() chat.AddText(Color(0,255,0), "#tool.vjstool_npcequipment.print.doubleclick") end
			function CheckList:DoDoubleClick(lineID,line)
				chat.AddText(Color(0,255,0), "#tool.vjstool_npcequipment.print.weaponselected1", Color(255,100,0), " "..line:GetValue(1).." ", Color(0,255,0), "#tool.vjstool_npcequipment.print.weaponselected2")
				LocalPlayer():ConCommand("vjstool_npcequipment_weaponname "..line:GetValue(1))
				LocalPlayer():ConCommand("vjstool_npcequipment_weaponclass "..line:GetValue(2))
				MenuFrame:Close()
				timer.Simple(0.05,function()
					GetPanel = controlpanel.Get("vjstool_npcequipment")
					GetPanel:ClearControls()
					DoBuildCPanel_VJ_NPCEquipment(GetPanel)
				end)
			end
		//MenuFrame:AddItem(CheckList)
		//CheckList:SizeToContents()
		for k,v in pairs(list.Get("NPCUsableWeapons")) do
			CheckList:AddLine(v.title,v.class)
		end
		CheckList:SortByColumn(1,false)
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:LeftClick(tr)
	if (CLIENT) then return true end
	if !tr.Entity:IsNPC() then return end
	if IsValid(tr.Entity:GetActiveWeapon()) then tr.Entity:GetActiveWeapon():Remove() end
	tr.Entity:Give(GetConVarString("vjstool_npcequipment_weaponclass"))
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:RightClick(tr)
	if (CLIENT) then return true end
	if !tr.Entity:IsNPC() then return end
	if IsValid(tr.Entity:GetActiveWeapon()) then tr.Entity:GetActiveWeapon():Remove() end
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:Reload(tr)
	if (CLIENT) then return true end
end