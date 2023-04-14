TOOL.Name = "#tool.vjstool_npcmover.name"
TOOL.Tab = "DrVrej"
TOOL.Category = "Tools"
TOOL.Command = nil -- The console command to execute upon being selected in the Q menu.

TOOL.Information = {
	{name = "left"},
	{name = "right"},
	{name = "reload"},
}

-- Just to make it easier to reset everything to default
local DefaultConVars = {}
for k,v in pairs(TOOL.ClientConVar) do
	DefaultConVars["vjstool_npcmover_"..k] = v
end
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	local function DoBuildCPanel_Mover(Panel)
		VJ_MOVE_TblCurrentValues = VJ_MOVE_TblCurrentValues or {}
		VJ_MOVE_TblCurrentLines = VJ_MOVE_TblCurrentLines or {}
		
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
					local GetPanel = controlpanel.Get("vjstool_npcmover")
					GetPanel:ClearControls()
					DoBuildCPanel_Mover(GetPanel)
				end)
			end
		end
		Panel:AddPanel(reset)
		
		Panel:AddControl("Label", {Text = "#tool.vjstool.menu.label.recommendation"})
		local CheckList = vgui.Create("DListView")
			CheckList:SetTooltip(false)
			//CheckList:Center() -- No need since Size does it already
			CheckList:SetSize(100, 300) -- Size
			CheckList:SetMultiSelect(false)
			//CheckList.Paint = function()
			//draw.RoundedBox(8, 0, 0, CheckList:GetWide(), CheckList:GetTall(), Color(0, 0, 100, 255))
			//end
			CheckList:AddColumn("#tool.vjstool_npcmover.header1")
			CheckList:AddColumn("#tool.vjstool_npcmover.header2")
			//CheckList:AddColumn("Index")
			CheckList:AddColumn("#tool.vjstool_npcmover.header3")
			//CheckList:AddColumn("Position")
			//CheckList:AddColumn("Equipment")
			for _,v in ipairs(VJ_MOVE_TblCurrentValues) do
				if IsValid(v) then
				local locname = "Unknown"
					for _,lv in pairs(list.Get("NPC")) do
						if v:GetClass() == lv.Class then locname = lv.Name end
					end
					CheckList:AddLine(locname,v:GetClass(),v) //v:EntIndex()
					//CheckList:AddLine(v)
				end
			end
			CheckList.OnRowSelected = function(rowIndex,row) chat.AddText(Color(0,255,0),"Double click to ",Color(255,100,0),"unselect ",Color(0,255,0),"a NPC") end
			function CheckList:DoDoubleClick(lineID,line)
				chat.AddText(Color(0,255,0),"NPC",Color(255,100,0)," "..line:GetValue(1).." ",Color(0,255,0),"unselected!")
				net.Start("vj_npcmover_remove")
				net.WriteTable({line:GetValue(3)})
				net.SendToServer()
				CheckList:RemoveLine(lineID)
				table.Empty(VJ_MOVE_TblCurrentValues)
				for _,vLine in pairs(CheckList:GetLines()) do
					table.insert(VJ_MOVE_TblCurrentValues,vLine:GetValue(3))
				end
			end
		Panel:AddItem(CheckList)
		//VJ_MOVE_TblCurrentLines = CheckList:GetLines()
				
		local unselectall = vgui.Create("DButton")
		unselectall:SetFont("DermaDefaultBold")
		unselectall:SetText("#tool.vjstool_npcmover.buttonunselectall")
		unselectall:SetSize(150, 25)
		unselectall:SetColor(Color(0,0,0,255))
		unselectall.DoClick = function()
			local brah = VJ_MOVE_TblCurrentValues
			if table.Count(brah) > 0 then
				chat.AddText(Color(255,100,0), "#tool.vjstool_npcmover.print.unselectedall")
			else
				chat.AddText(Color(0,255,0), "#tool.vjstool_npcmover.print.unselectedall.error")
			end
			net.Start("vj_npcmover_remove")
			net.WriteTable(brah)
			net.SendToServer()
			table.Empty(brah)
			CheckList:Clear()
		end
		Panel:AddPanel(unselectall)
		//Panel:AddControl("Checkbox", {Label = "Kill The Enemy", Command = "vjstool_npccontroller_killenemy"})
	end
---------------------------------------------------------------------------------------------------------------------------------------------
	net.Receive("vj_npcmover_cl_create", function(len, ply)
		local wep = LocalPlayer():GetActiveWeapon()
		if wep:IsValid() && wep:GetClass() == "gmod_tool" && wep:GetMode() == "vjstool_npcmover" then
			local sventity = net.ReadEntity()
			local sventname = net.ReadString()
			VJ_MOVE_TblCurrentValues = VJ_MOVE_TblCurrentValues or {}
			//if svchangetype == "AddNPC" then table.insert(VJ_MOVE_TblCurrentValues,sventity) end
			local changetype = 0 -- Check if we are removing or adding an NPC | 0 = Add, 1 = Remove
			for k,v in ipairs(VJ_MOVE_TblCurrentValues) do
				if !IsValid(v) then table.remove(VJ_MOVE_TblCurrentValues,k) continue end -- Remove any NPCs that no longer exist!
				if v == sventity then -- If the selected NPC already exists then unselect it!
					chat.AddText(Color(0,255,0),"NPC",Color(255,100,0)," "..sventname.." ",Color(0,255,0),"unselected!")
					changetype = 1
					table.remove(VJ_MOVE_TblCurrentValues, k)
				end
			end
			if changetype == 0 then -- Only if we are adding
				chat.AddText(Color(0,255,0),"NPC",Color(255,100,0)," "..sventname.." ",Color(0,255,0),"selected!")
				table.insert(VJ_MOVE_TblCurrentValues,sventity)
			end
			-- Refresh the tool menu
			local GetPanel = controlpanel.Get("vjstool_npcmover")
			GetPanel:ClearControls()
			DoBuildCPanel_Mover(GetPanel)
			net.Start("vj_npcmover_sv_create")
			net.WriteEntity(sventity)
			net.WriteBit(changetype)
			net.SendToServer()
			//print("Current Entity: ",sventity)
			//print("--------------")
			//PrintTable(VJ_MOVE_TblCurrentValues)
			//print("--------------")
		end
	end)
---------------------------------------------------------------------------------------------------------------------------------------------
	net.Receive("vj_npcmover_cl_startmove", function(len, ply)
		local svwalktype = net.ReadBit()
		local svvector = net.ReadVector()
		local wep = LocalPlayer():GetActiveWeapon()
		if wep:IsValid() && wep:GetClass() == "gmod_tool" && wep:GetMode() == "vjstool_npcmover" then
			for k,v in ipairs(VJ_MOVE_TblCurrentValues) do
				if !IsValid(v) then -- Remove any NPCs that no longer exist!
					table.remove(VJ_MOVE_TblCurrentValues,k)
					local GetPanel = controlpanel.Get("vjstool_npcmover")
					GetPanel:ClearControls()
					DoBuildCPanel_Mover(GetPanel)
				end
			end
			net.Start("vj_npcmover_sv_startmove")
			net.WriteTable(VJ_MOVE_TblCurrentValues)
			net.WriteBit(svwalktype)
			net.WriteVector(svvector)
			net.SendToServer()
		end
	end)
---------------------------------------------------------------------------------------------------------------------------------------------
	function TOOL.BuildCPanel(Panel)
		DoBuildCPanel_Mover(Panel)
	end
else -- If SERVER
	util.AddNetworkString("vj_npcmover_cl_create")
	util.AddNetworkString("vj_npcmover_sv_create")
	util.AddNetworkString("vj_npcmover_cl_startmove")
	util.AddNetworkString("vj_npcmover_sv_startmove")
	util.AddNetworkString("vj_npcmover_remove")
---------------------------------------------------------------------------------------------------------------------------------------------
	net.Receive("vj_npcmover_sv_create", function(len, ply)
		local wep = ply:GetActiveWeapon()
		if wep:IsValid() && wep:GetClass() == "gmod_tool" && wep:GetMode() == "vjstool_npcmover" then
			local sventity = net.ReadEntity()
			local svchangetype = net.ReadBit()
			if svchangetype == 0 then
				//print("fully added")
				sventity.VJ_IsBeingControlled_Tool = true
				sventity:StopMoving()
				if sventity.IsVJBaseSNPC == true then
					sventity.DisableWandering = true
					sventity.DisableChasingEnemy = true
				end
			elseif svchangetype == 1 then
				//print("fully removed")
				sventity.VJ_IsBeingControlled_Tool = false
				if sventity.IsVJBaseSNPC == true then
					sventity.DisableWandering = false
					sventity.DisableChasingEnemy = false
					sventity:SelectSchedule()
				end
			end
		end
	end)
	
	net.Receive("vj_npcmover_remove", function(len, ply)
		local wep = ply:GetActiveWeapon()
		if wep:IsValid() && wep:GetClass() == "gmod_tool" && wep:GetMode() == "vjstool_npcmover" then
			local brahtbl = net.ReadTable()
			for _,v in ipairs(brahtbl) do
				v.VJ_IsBeingControlled_Tool = false
				if v.IsVJBaseSNPC == true then
					v.DisableWandering = false
					v.DisableChasingEnemy = false
					v:SelectSchedule()
				end
			end
		end
	end)
	
	net.Receive("vj_npcmover_sv_startmove", function(len, ply)
		local wep = ply:GetActiveWeapon()
		if wep:IsValid() && wep:GetClass() == "gmod_tool" && wep:GetMode() == "vjstool_npcmover" then
			local sventtable = net.ReadTable()
			local svwalktype = net.ReadBit()
			local svvector = net.ReadVector()
			local type_task = "TASK_WALK_PATH"
			local type_sched = SCHED_FORCED_GO
			if svwalktype == 1 then
				type_task = "TASK_RUN_PATH"
				type_sched = SCHED_FORCED_GO_RUN
			end
			for k, v in ipairs(sventtable) do
				if IsValid(v) then -- Move the NPC if it's valid!
					v:StopMoving()
					v:SetLastPosition(svvector)
					if v.IsVJBaseSNPC == true then
						if k == 1 or math.random(1, 5) == 1 then v:PlaySoundSystem("OnReceiveOrder") end
						v:VJ_TASK_GOTO_LASTPOS(type_task, function(x)
							if IsValid(v:GetEnemy()) && v:Visible(v:GetEnemy()) then
								x:EngTask("TASK_FACE_ENEMY", 0)
								x.CanShootWhenMoving = true
								x.ConstantlyFaceEnemy = true
							end
						end)
					else -- For non-VJ NPCs
						v:SetSchedule(type_sched)
					end
				end
			end
			//self:MoveNPC(sventity,svvector,svwalktype)
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:LeftClick(tr)
	if CLIENT then return true end
	if !tr.Entity:IsNPC() then return end
	net.Start("vj_npcmover_cl_create")
	net.WriteEntity(tr.Entity)
	if tr.Entity:GetName() == "" then
		net.WriteString(list.Get("NPC")[tr.Entity:GetClass()].Name)
	else
		net.WriteString(tr.Entity:GetName())
	end
	net.Send(self:GetOwner())
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:RightClick(tr)
	if CLIENT then return true end
	net.Start("vj_npcmover_cl_startmove")
	net.WriteBit(1)
	net.WriteVector(tr.HitPos)
	net.Send(self:GetOwner())
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:Reload(tr)
	if CLIENT then return true end
	net.Start("vj_npcmover_cl_startmove")
	net.WriteBit(0)
	net.WriteVector(tr.HitPos)
	net.Send(self:GetOwner())
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:Holster()
	/*if CLIENT then return end
	self.TblCurrentNPCs = self.TblCurrentNPCs or {}
	for k,v in pairs(self.TblCurrentNPCs) do
		self:RemoveNPC(v)
	end*/
end