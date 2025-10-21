TOOL.Name = "#tool.vj_tool_relationship.name"
TOOL.Tab = "DrVrej"
TOOL.Category = "Tools"
TOOL.Information = {
	{name = "left"},
	{name = "right"},
	{name = "reload"},
}
TOOL.ClientConVar = {
	allytoplyallies = 1
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
					local getPanel = controlpanel.Get("vj_tool_relationship")
					getPanel:Clear()
					ControlPanel(getPanel)
				end)
			end
		panel:AddPanel(reset)

		-- Tutorial button
		local tutorial = vgui.Create("DButton")
			tutorial:SetFont("DermaDefaultBold")
			tutorial:SetText("#vjbase.menu.general.tutorial.vid")
			tutorial:SetSize(150, 20)
			tutorial:SetColor(VJ.COLOR_BLUE)
			function tutorial:DoClick()
				gui.OpenURL("http://www.youtube.com/watch?v=SnuQU8Sc4cg")
			end
		panel:AddPanel(tutorial)

		panel:Help("#tool.vj_tool_relationship.menu.header")
		panel:ControlHelp("#tool.vj_tool_relationship.menu.header.help")
		
		VJ_TOOL_RELATIONSHIP_LIST = VJ_TOOL_RELATIONSHIP_LIST or {}
		
		local classList = vgui.Create("DListView")
			//classList:Center() -- No need since Size does it already
			classList:SetSize( 100, 300 )
			classList:SetMultiSelect(false)
			classList:AddColumn("#tool.vj_tool_relationship.menu.list.header")
			classList:SetHideHeaders(true)
			function classList:OnRowSelected(rowIndex, row)
				chat.AddText(VJ.COLOR_GREEN, "Double click to ", VJ.COLOR_ORANGE_VIVID, "remove ", VJ.COLOR_GREEN, "a class")
			end
			function classList:DoDoubleClick(lineID, line)
				chat.AddText(VJ.COLOR_ORANGE_VIVID, line:GetValue(1) .. " ", VJ.COLOR_GREEN, "removed!")
				classList:RemoveLine(lineID)
				VJ_TOOL_RELATIONSHIP_LIST = {}
				for _, vLine in pairs(classList:GetLines()) do
					table.insert(VJ_TOOL_RELATIONSHIP_LIST, vLine:GetValue(1))
				end
			end
		panel:AddItem(classList)
		for _, v in pairs(VJ_TOOL_RELATIONSHIP_LIST) do
			classList:AddLine(v)
		end
		
		local function InsertToTable(val)
			if string.len(val) > 0 then
				val = string.upper(val)
				if VJ.HasValue(VJ_TOOL_RELATIONSHIP_LIST, val) then -- Fail
					chat.AddText(Color(220, 20, 60), "ERROR! ", VJ.COLOR_ORANGE_VIVID, val .. " ", Color(220, 20, 60), "already exists in the table!")
				else -- Success
					chat.AddText(VJ.COLOR_GREEN, "Added", VJ.COLOR_ORANGE_VIVID, " " .. val .. " ", VJ.COLOR_GREEN, "to the class list!")
					table.insert(VJ_TOOL_RELATIONSHIP_LIST, val)
					timer.Simple(0.05, function() -- Otherwise it will not update the values in time
						local getPanel = controlpanel.Get("vj_tool_relationship")
						getPanel:Clear()
						ControlPanel(getPanel)
					end)
				end
			end
		end
		
		local classTextEntry = vgui.Create("DTextEntry")
			classTextEntry:SetPlaceholderText(language.GetPhrase("#tool.vj_tool_relationship.menu.text.help") .. "...")
			function classTextEntry:OnEnter(value)
				InsertToTable(value)
			end
		panel:AddItem(classTextEntry)
		
		local button = vgui.Create("DButton")
			button:SetFont("DermaDefaultBold")
			button:SetText("#tool.vj_tool_relationship.menu.button.antlion")
			button:SetSize(50, 20)
			button:SetColor(VJ.COLOR_BLACK)
			function button:DoClick()
				InsertToTable("CLASS_ANTLION")
			end
		panel:AddPanel(button)
		
		button = vgui.Create("DButton")
			button:SetFont("DermaDefaultBold")
			button:SetText("#tool.vj_tool_relationship.menu.button.combine")
			button:SetSize(50, 20)
			button:SetColor(VJ.COLOR_BLACK)
			function button:DoClick()
				InsertToTable("CLASS_COMBINE")
			end
		panel:AddPanel(button)
		
		button = vgui.Create("DButton")
			button:SetFont("DermaDefaultBold")
			button:SetText("#tool.vj_tool_relationship.menu.button.hecu")
			button:SetSize(50, 20)
			button:SetColor(VJ.COLOR_BLACK)
			function button:DoClick()
				InsertToTable("CLASS_UNITED_STATES")
			end
		panel:AddPanel(button)
		
		button = vgui.Create("DButton")
			button:SetFont("DermaDefaultBold")
			button:SetText("#tool.vj_tool_relationship.menu.button.xen")
			button:SetSize(50, 20)
			button:SetColor(VJ.COLOR_BLACK)
			function button:DoClick()
				InsertToTable("CLASS_XEN")
			end
		panel:AddPanel(button)
		
		button = vgui.Create("DButton")
			button:SetFont("DermaDefaultBold")
			button:SetText("#tool.vj_tool_relationship.menu.button.zombie")
			button:SetSize(50, 20)
			button:SetColor(VJ.COLOR_BLACK)
			function button:DoClick()
				InsertToTable("CLASS_ZOMBIE")
			end
		panel:AddPanel(button)
		
		button = vgui.Create("DButton")
			button:SetFont("DermaDefaultBold")
			button:SetText("#tool.vj_tool_relationship.menu.button.player")
			button:SetSize(50, 20)
			button:SetColor(VJ.COLOR_BLACK)
			function button:DoClick()
				InsertToTable("CLASS_PLAYER_ALLY")
			end
		panel:AddPanel(button)
		
		panel:CheckBox("#tool.vj_tool_relationship.menu.toggle.plyallied", "vj_tool_relationship_allytoplyallies")
		panel:ControlHelp(language.GetPhrase("#tool.vj_tool_relationship.menu.toggle.plyallied.help"))
	end
---------------------------------------------------------------------------------------------------------------------------------------------
	function TOOL.BuildCPanel(panel)
		ControlPanel(panel)
	end
---------------------------------------------------------------------------------------------------------------------------------------------
	net.Receive("vj_tool_relationship_cl_select", function(len)
		local wep = LocalPlayer():GetActiveWeapon()
		if wep:IsValid() && wep:GetClass() == "gmod_tool" && wep:GetMode() == "vj_tool_relationship" && hook.Run("CanTool", LocalPlayer(), LocalPlayer():GetEyeTrace(), "vj_tool_relationship") then
			local entName = language.GetPhrase(net.ReadString())
			local classCount = net.ReadUInt(9)
			chat.AddText(VJ.COLOR_GREEN, "Obtained", VJ.COLOR_ORANGE_VIVID, " " .. entName .. "'s ", VJ.COLOR_GREEN, "relationship class list!")
			VJ_TOOL_RELATIONSHIP_LIST = {}
			for _ = 1, classCount do
				table.insert(VJ_TOOL_RELATIONSHIP_LIST, net.ReadString())
			end
			timer.Simple(0.05, function() -- Otherwise it will not update the values in time
				local getPanel = controlpanel.Get("vj_tool_relationship")
				getPanel:Clear()
				ControlPanel(getPanel)
			end)
		end
	end)
---------------------------------------------------------------------------------------------------------------------------------------------
	net.Receive("vj_tool_relationship_cl_apply", function(len)
		local wep = LocalPlayer():GetActiveWeapon()
		if wep:IsValid() && wep:GetClass() == "gmod_tool" && wep:GetMode() == "vj_tool_relationship" && hook.Run("CanTool", LocalPlayer(), LocalPlayer():GetEyeTrace(), "vj_tool_relationship") then
			local ent = net.ReadEntity()
			local entName = language.GetPhrase(net.ReadString())
			local applyType = net.ReadBit()
			chat.AddText(VJ.COLOR_GREEN, "#tool.vj_tool_relationship.print.applied", VJ.COLOR_ORANGE_VIVID, " " .. (applyType == 1 and "Yourself" or entName))
			net.Start("vj_tool_relationship_sv_apply")
				net.WriteEntity(ent)
				net.WriteTable(VJ_TOOL_RELATIONSHIP_LIST)
			net.SendToServer()
		end
	end)
else
	util.AddNetworkString("vj_tool_relationship_cl_select")
	util.AddNetworkString("vj_tool_relationship_cl_apply")
	util.AddNetworkString("vj_tool_relationship_sv_apply")
---------------------------------------------------------------------------------------------------------------------------------------------
	net.Receive("vj_tool_relationship_sv_apply", function(len, ply)
		local wep = ply:GetActiveWeapon()
		if wep:IsValid() && wep:GetClass() == "gmod_tool" && wep:GetMode() == "vj_tool_relationship" && hook.Run("CanTool", ply, ply:GetEyeTrace(), "vj_tool_relationship") then
			local ent = net.ReadEntity()
			local classtbl = net.ReadTable()
			if #classtbl > 0 then
				ent.VJ_NPC_Class = classtbl
				if ent:IsNPC() && table.HasValue(classtbl, "CLASS_PLAYER_ALLY") && ply:GetInfoNum("vj_tool_relationship_allytoplyallies", 1) == 1 then
					ent.AlliedWithPlayerAllies = true
				end
			else
				ent.VJ_NPC_Class = {nil}
			end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:LeftClick(tr)
	if CLIENT then return true end
	local ent = tr.Entity
	if IsValid(ent) && ent.VJ_ID_Living then
		net.Start("vj_tool_relationship_cl_apply")
			net.WriteEntity(ent)
			net.WriteString(VJ.GetName(ent))
			net.WriteBit(0)
		net.Send(self:GetOwner())
		return true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:RightClick(tr)
	if CLIENT then return true end
	local ent = tr.Entity
	if IsValid(ent) && ent.VJ_ID_Living then
		local owner = self:GetOwner()
		local entName = VJ.GetName(ent)
		local entClasses = ent.VJ_NPC_Class
		if !entClasses then
			owner:ChatPrint("ERROR! Failed to get " .. entName .. "'s class list!")
			return false
		elseif #entClasses <= 0 then
			owner:ChatPrint("ERROR! " .. entName .. " has no classes assigned!")
			return false
		end
		net.Start("vj_tool_relationship_cl_select")
			net.WriteString(entName)
			net.WriteUInt(#entClasses, 9)
			for _, v in ipairs(ent.VJ_NPC_Class) do
				net.WriteString(v)
			end
		net.Send(owner)
		return true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:Reload(tr)
	if CLIENT then return true end
	net.Start("vj_tool_relationship_cl_apply")
		net.WriteEntity(self:GetOwner())
		net.WriteString("Me")
		net.WriteBit(1)
	net.Send(self:GetOwner())
	return true
end