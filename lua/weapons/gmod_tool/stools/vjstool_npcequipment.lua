TOOL.Name = "NPC Equipment"
TOOL.Category = "Tools"
TOOL.Tab = "DrVrej"
TOOL.Command = nil
TOOL.ConfigName = ""

TOOL.ClientConVar["weaponclass"] = "None"
TOOL.ClientConVar["weaponname"] = "Unknown"

local DefaultConVars = {}
for k,v in pairs(TOOL.ClientConVar) do
	DefaultConVars["vjstool_npcequipment_"..k] = v
end
---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
	language.Add("tool.vjstool_npcequipment.name", "NPC Equipment")
	language.Add("tool.vjstool_npcequipment.desc", "Changes the NPC's equipment")
	language.Add("tool.vjstool_npcequipment.0", "Left-Click to change the NPC's equipment, Right-Click to remove the NPC's equipment")
	
	//language.Add("vjbase.npctools.health", "Health")
---------------------------------------------------------------------------------------------------------------------------------------------
	local function DoBuildCPanel_VJ_NPCEquipment(Panel)
		local reset = vgui.Create("DButton")
		reset:SetFont("DermaDefaultBold")
		reset:SetText("Reset To Default")
		reset:SetSize(150,25)
		reset:SetColor(Color(0,0,0,255))
		reset.DoClick = function(reset)
			for k,v in pairs(DefaultConVars) do
				if v == "" then LocalPlayer():ConCommand(k.." ".."None") else
				LocalPlayer():ConCommand(k.." "..v) end
				timer.Simple(0.05,function()
				GetPanel = controlpanel.Get("vjstool_npcequipment")
				GetPanel:ClearControls()
				DoBuildCPanel_VJ_NPCEquipment(GetPanel)
				end)
			end
		end
		Panel:AddPanel(reset)
		
		Panel:AddControl("Label", {Text = "It's recommended to use this tool only for VJ Base SNPCs."})
		Panel:ControlHelp("- Left-Click to change the NPC's equipment.")
		Panel:ControlHelp("- Right-Click to remove the NPC's equipment.")
		
		local selectwep = vgui.Create("DTextEntry")
		selectwep:SetEditable(false)
		selectwep:SetText("Selected Weapon: "..GetConVarString("vjstool_npcequipment_weaponname").." ["..GetConVarString("vjstool_npcequipment_weaponclass").."]")
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
		MenuFrame:SetTitle("Double click to select a weapon")
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
			CheckList:AddColumn("Name")
			CheckList:AddColumn("Class")
			CheckList.OnRowSelected = function() chat.AddText(Color(0,255,0),"Double click to select a weapon") end
			function CheckList:DoDoubleClick(lineID,line)
				chat.AddText(Color(0,255,0),"Weapon",Color(255,100,0)," "..line:GetValue(1).." ",Color(0,255,0),"selected!")
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
else -- If SERVER
	-- Yayyyy nothing.....for now...
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