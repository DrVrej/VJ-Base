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
		reset.DoClick = function()
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

		local tutorial = vgui.Create("DButton")
		tutorial:SetFont("DermaDefaultBold")
		tutorial:SetText("#vjbase.menu.general.tutorial.vid")
		tutorial:SetSize(150, 20)
		tutorial:SetColor(VJ.COLOR_BLUE)
		tutorial.DoClick = function()
			gui.OpenURL("http://www.youtube.com/watch?v=SnuQU8Sc4cg")
		end
		panel:AddPanel(tutorial)

		panel:Help("#tool.vj_tool_relationship.header")
		panel:ControlHelp("#tool.vj_tool_relationship.header.help")
		
		VJ_NPCRELATION_TblCurrentValues = VJ_NPCRELATION_TblCurrentValues or {}
		local CheckList = vgui.Create("DListView")
			CheckList:SetTooltip(false)
			//CheckList:Center() -- No need since Size does it already
			CheckList:SetSize( 100, 300 ) -- Size
			CheckList:SetMultiSelect(false)
			CheckList:AddColumn("#tool.vj_tool_relationship.tableheader")
			CheckList.OnRowSelected = function(rowIndex, row) chat.AddText(Color(0, 255, 0), "Double click to ", Color(255, 100, 0), "remove ", Color(0, 255, 0), "a class") end
			function CheckList:DoDoubleClick(lineID, line)
				chat.AddText(Color(255, 100, 0), " "..line:GetValue(1).." ", Color(0, 255, 0), "removed!")
				CheckList:RemoveLine(lineID)
				table.Empty(VJ_NPCRELATION_TblCurrentValues)
				for _, vLine in pairs(CheckList:GetLines()) do
					table.insert(VJ_NPCRELATION_TblCurrentValues, vLine:GetValue(1))
				end
			end
		panel:AddItem(CheckList)
		for _, v in pairs(VJ_NPCRELATION_TblCurrentValues) do
			CheckList:AddLine(v)
		end
		
		local function InsertToTable(val)
			if string.len(val) > 0 then
				val = string.upper(val)
				if VJ.HasValue(VJ_NPCRELATION_TblCurrentValues, val) then
					chat.AddText(Color(220, 20, 60), "ERROR! ", Color(255, 100, 0), val.." ", Color(220, 20, 60), "already exists in the table!")
				else
					chat.AddText(Color(0, 255, 0), "Added", Color(255, 100, 0), " "..val.." ", Color(0, 255, 0), "to the class list!")
					table.insert(VJ_NPCRELATION_TblCurrentValues, val)
					timer.Simple(0.05, function() -- Otherwise it will not update the values in time
						local getPanel = controlpanel.Get("vj_tool_relationship")
						getPanel:Clear()
						ControlPanel(getPanel)
					end)
				end
			end
		end
		local TextEntry = vgui.Create("DTextEntry")
		//TextEntry:SetText("Press enter to add class...")
		TextEntry.OnEnter = function()
			InsertToTable(TextEntry:GetValue())
		end
		panel:AddItem(TextEntry)
		panel:ControlHelp("#tool.vj_tool_relationship.label2")
		
		local button = vgui.Create("DButton")
		button:SetFont("DermaDefaultBold")
		button:SetText("#tool.vj_tool_relationship.button.antlion")
		button:SetSize(50, 20)
		button:SetColor(VJ.COLOR_BLACK)
		button.DoClick = function()
			InsertToTable("CLASS_ANTLION")
		end
		panel:AddPanel(button)
		
		button = vgui.Create("DButton")
		button:SetFont("DermaDefaultBold")
		button:SetText("#tool.vj_tool_relationship.button.combine")
		button:SetSize(50, 20)
		button:SetColor(VJ.COLOR_BLACK)
		button.DoClick = function()
			InsertToTable("CLASS_COMBINE")
		end
		panel:AddPanel(button)
		
		button = vgui.Create("DButton")
		button:SetFont("DermaDefaultBold")
		button:SetText("#tool.vj_tool_relationship.button.hecu")
		button:SetSize(50, 20)
		button:SetColor(VJ.COLOR_BLACK)
		button.DoClick = function()
			InsertToTable("CLASS_UNITED_STATES")
		end
		panel:AddPanel(button)
		
		button = vgui.Create("DButton")
		button:SetFont("DermaDefaultBold")
		button:SetText("#tool.vj_tool_relationship.button.xen")
		button:SetSize(50, 20)
		button:SetColor(VJ.COLOR_BLACK)
		button.DoClick = function()
			InsertToTable("CLASS_XEN")
		end
		panel:AddPanel(button)
		
		button = vgui.Create("DButton")
		button:SetFont("DermaDefaultBold")
		button:SetText("#tool.vj_tool_relationship.button.zombie")
		button:SetSize(50, 20)
		button:SetColor(VJ.COLOR_BLACK)
		button.DoClick = function()
			InsertToTable("CLASS_ZOMBIE")
		end
		panel:AddPanel(button)
		
		button = vgui.Create("DButton")
		button:SetFont("DermaDefaultBold")
		button:SetText("#tool.vj_tool_relationship.button.player")
		button:SetSize(50, 20)
		button:SetColor(VJ.COLOR_BLACK)
		button.DoClick = function()
			InsertToTable("CLASS_PLAYER_ALLY")
		end
		panel:AddPanel(button)
		panel:CheckBox("#tool.vj_tool_relationship.togglealliedply", "vj_tool_relationship_allytoplyallies")
		panel:ControlHelp(language.GetPhrase("#tool.vj_tool_relationship.label3"))
	end
---------------------------------------------------------------------------------------------------------------------------------------------
	function TOOL.BuildCPanel(panel)
		ControlPanel(panel)
	end
---------------------------------------------------------------------------------------------------------------------------------------------
	net.Receive("vj_tool_relationship_cl_select", function(len)
		local wep = LocalPlayer():GetActiveWeapon()
		if wep:IsValid() && wep:GetClass() == "gmod_tool" && wep:GetMode() == "vj_tool_relationship" && hook.Run("CanTool", LocalPlayer(), LocalPlayer():GetEyeTrace(), "vj_tool_relationship") then
			//local ent = net.ReadEntity()
			local entname = net.ReadString()
			//local hasclasstbl = net.ReadBool()
			local classtbl = net.ReadTable()
			chat.AddText(Color(0, 255, 0), "Obtained", Color(255, 100, 0), " "..entname.."'s ", Color(0, 255, 0), "relationship class list!")
			//print(ent)
			//print(hasclasstbl)
			//PrintTable(classtbl)
			//print(#classtbl)
			VJ_NPCRELATION_TblCurrentValues = classtbl
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
			local entname = net.ReadString()
			local clicktype = net.ReadString()
			local allynum = net.ReadFloat()
			if clicktype == "ReloadClick" then entname = "Yourself" end
			chat.AddText(Color(0, 255, 0), "#tool.vj_tool_relationship.print.applied", Color(255, 100, 0), " "..entname)
			net.Start("vj_tool_relationship_sv_apply")
			net.WriteEntity(ent)
			//net.WriteTable(self)
			//net.WriteString(clicktype)
			net.WriteTable(VJ_NPCRELATION_TblCurrentValues)
			net.WriteFloat(allynum)
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
			//local clicktype = net.ReadString()
			local classtbl = net.ReadTable()
			local allynum = net.ReadFloat()
			if #classtbl > 0 then
				ent.VJ_NPC_Class = classtbl
				if ent:IsNPC() && table.HasValue(classtbl, "CLASS_PLAYER_ALLY") && allynum == 1 then
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
		local entname = ent:GetName()
		if entname == "" then entname = ent:GetClass() end
		net.Start("vj_tool_relationship_cl_apply")
		net.WriteEntity(ent)
		net.WriteString(entname)
		net.WriteString("LeftClick")
		net.WriteFloat(self:GetClientNumber("allytoplyallies"))
		net.Send(self:GetOwner())
		return true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:RightClick(tr)
	if CLIENT then return true end
	local ent = tr.Entity
	if IsValid(ent) && ent.VJ_ID_Living then
		//local hasclasstbl = false
		local classtbl = {nil}
		local entname = ent:GetName()
		if entname == "" then entname = ent:GetClass() end
		if (ent.VJ_NPC_Class) then
			//hasclasstbl = true
			//classtbl = ent.VJ_NPC_Class
			for _, v in ipairs(ent.VJ_NPC_Class) do
				table.insert(classtbl, v)
			end
			//if (classtbl.BaseClass) then table.remove(classtbl, BaseClass) end
		end
		//PrintTable(ent.VJ_NPC_Class)
		net.Start("vj_tool_relationship_cl_select")
		//net.WriteEntity(ent)
		net.WriteString(entname)
		//net.WriteBool(hasclasstbl)
		net.WriteTable(classtbl)
		net.Send(self:GetOwner())
		return true
	end
	/*	local trent = tr.Entity
		trent:SetHealth(self:GetClientNumber("health"))
		if tr.Entity:IsNPC() then
			if self:GetClientNumber("godmode") == 1 then trent.GodMode = true else trent.GodMode = false end
		end
		return true
	end*/
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:Reload(tr)
	if CLIENT then return true end
	net.Start("vj_tool_relationship_cl_apply")
	net.WriteEntity(self:GetOwner())
	net.WriteString("Me")
	net.WriteString("ReloadClick")
	net.Send(self:GetOwner())
	return true
end