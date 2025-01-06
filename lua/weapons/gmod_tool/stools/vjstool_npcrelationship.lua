TOOL.Name = "#tool.vjstool_npcrelationship.name"
TOOL.Tab = "DrVrej"
TOOL.Category = "Tools"
TOOL.Command = nil -- The console command to execute upon being selected in the Q menu.

TOOL.Information = {
	{name = "left"},
	{name = "right"},
	{name = "reload"},
}

//TOOL.ClientConVar["playerinteract"] = 1
TOOL.ClientConVar["allytoplyallies"] = 1

-- Just to make it easier to reset everything to default
local DefaultConVars = {}
for k,v in pairs(TOOL.ClientConVar) do
	DefaultConVars["vjstool_npcrelationship_"..k] = v
end
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	local function DoBuildCPanel_Relationship(Panel)
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
					local GetPanel = controlpanel.Get("vjstool_npcrelationship")
					GetPanel:ClearControls()
					DoBuildCPanel_Relationship(GetPanel)
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
			gui.OpenURL("http://www.youtube.com/watch?v=SnuQU8Sc4cg")
		end
		Panel:AddPanel(tutorial)

		Panel:AddControl("Label", {Text = "#tool.vjstool.menu.label.recommendation"})
		Panel:ControlHelp("#tool.vjstool_npcrelationship.label1")
		
		VJ_NPCRELATION_TblCurrentValues = VJ_NPCRELATION_TblCurrentValues or {}
		local CheckList = vgui.Create("DListView")
			CheckList:SetTooltip(false)
			//CheckList:Center() -- No need since Size does it already
			CheckList:SetSize( 100, 300 ) -- Size
			CheckList:SetMultiSelect(false)
			CheckList:AddColumn("#tool.vjstool_npcrelationship.header")
			CheckList.OnRowSelected = function(rowIndex,row) chat.AddText(Color(0,255,0),"Double click to ",Color(255,100,0),"remove ",Color(0,255,0),"a class") end
			function CheckList:DoDoubleClick(lineID,line)
				chat.AddText(Color(255,100,0)," "..line:GetValue(1).." ",Color(0,255,0),"removed!")
				CheckList:RemoveLine(lineID)
				table.Empty(VJ_NPCRELATION_TblCurrentValues)
				for _,vLine in pairs(CheckList:GetLines()) do
					table.insert(VJ_NPCRELATION_TblCurrentValues,vLine:GetValue(1))
				end
			end
		Panel:AddItem(CheckList)
		for _,v in pairs(VJ_NPCRELATION_TblCurrentValues) do
			CheckList:AddLine(v)
		end
		
		local function InsertToTable(val)
			if string.len(val) > 0 then
				val = string.upper(val)
				if VJ.HasValue(VJ_NPCRELATION_TblCurrentValues,val) then
					chat.AddText(Color(220,20,60),"ERROR! ",Color(255,100,0),val.." ",Color(220,20,60),"already exists in the table!")
				else
					chat.AddText(Color(0,255,0),"Added",Color(255,100,0)," "..val.." ",Color(0,255,0),"to the class list!")
					table.insert(VJ_NPCRELATION_TblCurrentValues,val)
					timer.Simple(0.05,function()
						local GetPanel = controlpanel.Get("vjstool_npcrelationship")
						GetPanel:ClearControls()
						DoBuildCPanel_Relationship(GetPanel)
					end)
				end
			end
		end
		local TextEntry = vgui.Create("DTextEntry")
		//TextEntry:SetText("Press enter to add class...")
		TextEntry.OnEnter = function()
			InsertToTable(TextEntry:GetValue())
		end
		Panel:AddItem(TextEntry)
		Panel:ControlHelp("#tool.vjstool_npcrelationship.label2")
		
		local button = vgui.Create("DButton")
		button:SetFont("DermaDefaultBold")
		button:SetText("#tool.vjstool_npcrelationship.button.combine")
		button:SetSize(50,20)
		button:SetColor(Color(0,0,0,255))
		button.DoClick = function()
			InsertToTable("CLASS_COMBINE")
		end
		Panel:AddPanel(button)
		
		button = vgui.Create("DButton")
		button:SetFont("DermaDefaultBold")
		button:SetText("#tool.vjstool_npcrelationship.button.antlion")
		button:SetSize(50,20)
		button:SetColor(Color(0,0,0,255))
		button.DoClick = function()
			InsertToTable("CLASS_ANTLION")
		end
		Panel:AddPanel(button)
		
		button = vgui.Create("DButton")
		button:SetFont("DermaDefaultBold")
		button:SetText("#tool.vjstool_npcrelationship.button.zombie")
		button:SetSize(50,20)
		button:SetColor(Color(0,0,0,255))
		button.DoClick = function()
			InsertToTable("CLASS_ZOMBIE")
		end
		Panel:AddPanel(button)
		
		button = vgui.Create("DButton")
		button:SetFont("DermaDefaultBold")
		button:SetText("#tool.vjstool_npcrelationship.button.player")
		button:SetSize(50,20)
		button:SetColor(Color(0,0,0,255))
		button.DoClick = function()
			InsertToTable("CLASS_PLAYER_ALLY")
		end
		Panel:AddPanel(button)
		Panel:AddControl("Checkbox", {Label = "#tool.vjstool_npcrelationship.togglealliedply", Command = "vjstool_npcrelationship_allytoplyallies"})
		Panel:ControlHelp(language.GetPhrase("#tool.vjstool_npcrelationship.label3").." CLASS_PLAYER_ALLY")
		
		//Panel:AddControl("Label", {Text = "For PLAYER entities Only:"})
		//Panel:AddControl("Checkbox", {Label = "Make NPCs interact with friendly player", Command = "vjstool_npcspawner_playerinteract"})
		//Panel:ControlHelp("Make NPCs be able to interact with friendly player, such follow when pressed E or get out of their way")
	end
---------------------------------------------------------------------------------------------------------------------------------------------
	function TOOL.BuildCPanel(Panel)
		DoBuildCPanel_Relationship(Panel)
	end
	
---------------------------------------------------------------------------------------------------------------------------------------------
	net.Receive("vj_npcrelationship_cl_select", function(len, ply)
		local wep = LocalPlayer():GetActiveWeapon()
		if wep:IsValid() && wep:GetClass() == "gmod_tool" && wep:GetMode() == "vjstool_npcrelationship" then
			//local ent = net.ReadEntity()
			local entname = net.ReadString()
			//local hasclasstbl = net.ReadBool()
			local classtbl = net.ReadTable()
			chat.AddText(Color(0,255,0),"Obtained",Color(255,100,0)," "..entname.."'s ",Color(0,255,0),"relationship class list!")
			//print(ent)
			//print(hasclasstbl)
			//PrintTable(classtbl)
			//print(#classtbl)
			VJ_NPCRELATION_TblCurrentValues = classtbl
			timer.Simple(0.05,function()
				local GetPanel = controlpanel.Get("vjstool_npcrelationship")
				GetPanel:ClearControls()
				DoBuildCPanel_Relationship(GetPanel)
			end)
		end
	end)
---------------------------------------------------------------------------------------------------------------------------------------------
	net.Receive("vj_npcrelationship_cl_leftclick", function(len, ply)
		local wep = LocalPlayer():GetActiveWeapon()
		if wep:IsValid() && wep:GetClass() == "gmod_tool" && wep:GetMode() == "vjstool_npcrelationship" then
			local ent = net.ReadEntity()
			local entname = net.ReadString()
			local clicktype = net.ReadString()
			local allynum = net.ReadFloat()
			if clicktype == "ReloadClick" then entname = "Yourself" end
			chat.AddText(Color(0,255,0),"#tool.vjstool_npcrelationship.print.applied",Color(255,100,0)," "..entname)
			net.Start("vj_npcrelationship_sr_leftclick")
			net.WriteEntity(ent)
			//net.WriteTable(self)
			//net.WriteString(clicktype)
			net.WriteTable(VJ_NPCRELATION_TblCurrentValues)
			net.WriteFloat(allynum)
			net.SendToServer()
		end
	end)
else
	util.AddNetworkString("vj_npcrelationship_cl_select")
	util.AddNetworkString("vj_npcrelationship_cl_leftclick")
	util.AddNetworkString("vj_npcrelationship_sr_leftclick")
---------------------------------------------------------------------------------------------------------------------------------------------
	net.Receive("vj_npcrelationship_sr_leftclick", function(len, ply)
		local wep = ply:GetActiveWeapon()
		if wep:IsValid() && wep:GetClass() == "gmod_tool" && wep:GetMode() == "vjstool_npcrelationship" then
			local ent = net.ReadEntity()
			//local clicktype = net.ReadString()
			local classtbl = net.ReadTable()
			local allynum = net.ReadFloat()
			if #classtbl > 0 then
				ent.VJ_NPC_Class = classtbl
				if ent.IsVJBaseSNPC == true then
					if table.HasValue(classtbl,"CLASS_PLAYER_ALLY") then
						if allynum == 1 then ent.FriendsWithAllPlayerAllies = true end
						ent.PlayerFriendly = true
					else
						ent.PlayerFriendly = false
					end
				end
			else
				ent.VJ_NPC_Class = {nil}
				ent.PlayerFriendly = false
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
		net.Start("vj_npcrelationship_cl_leftclick")
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
			for _,v in ipairs(ent.VJ_NPC_Class) do
				table.insert(classtbl,v)
			end
			//if (classtbl.BaseClass) then table.remove(classtbl,BaseClass) end
		end
		//PrintTable(ent.VJ_NPC_Class)
		net.Start("vj_npcrelationship_cl_select")
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
	net.Start("vj_npcrelationship_cl_leftclick")
	net.WriteEntity(self:GetOwner())
	net.WriteString("Me")
	net.WriteString("ReloadClick")
	net.Send(self:GetOwner())
	return true
end