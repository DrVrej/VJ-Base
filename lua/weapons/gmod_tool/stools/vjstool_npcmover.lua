TOOL.Name = "NPC Mover"
TOOL.Category = "Tools"
TOOL.Tab = "DrVrej"
TOOL.Command = nil
TOOL.ConfigName = ""

local DefaultConVars = {}
for k,v in pairs(TOOL.ClientConVar) do
	DefaultConVars["vjstool_npcmover_"..k] = v
end
---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
	language.Add("tool.vjstool_npcmover.name", "NPC Mover")
	language.Add("tool.vjstool_npcmover.desc", "Move an NPC or a group of NPCs")
	language.Add("tool.vjstool_npcmover.0", "Left-Click to select, Right-Click to move(Run), Reload-Key to move(walk)")
	
	//language.Add("vjbase.npctools.health", "Health")
---------------------------------------------------------------------------------------------------------------------------------------------
local function DoBuildCPanel_Mover(Panel)
	//PrintTable(DefaultConVars)
	//Panel:AddControl("Header", {Text = "NPC Tool", Description = "Left click to change the NPC's property"})
	TblCurrentValues = TblCurrentValues or {}
	TblCurrentLines = TblCurrentLines or {}
	
	local reset = vgui.Create("DButton") -- Bug Report
	reset:SetFont("DermaDefaultBold")
	reset:SetText("Reset To Default")
	reset:SetSize(150, 25)
	reset:SetColor(Color(0,0,0,255))
	reset.DoClick = function(reset)
		for k,v in pairs(DefaultConVars) do
			LocalPlayer():ConCommand(k.." "..v)
			//LocalPlayer():ConCommand("vjstool_npcproperty_health 100")
			timer.Simple(0.05,function()
			GetPanel = controlpanel.Get("vjstool_npcmover")
			GetPanel:ClearControls()
			DoBuildCPanel_Mover(GetPanel)
			end)
		end
	end
	Panel:AddPanel(reset)
	Panel:AddControl("Label", {Text = "It's recommended to use this tool only for VJ Base SNPCs."})
	local CheckList = vgui.Create("DListView")
		CheckList:SetTooltip(false)
		//CheckList:Center() -- No need since Size does it already
		CheckList:SetSize( 100, 300 ) -- Size
		CheckList:SetMultiSelect(false)
		//CheckList.Paint = function()
		//draw.RoundedBox( 8, 0, 0, CheckList:GetWide(), CheckList:GetTall(), Color( 0, 0, 100, 255 ) )
		//end
		CheckList:AddColumn("Name")
		CheckList:AddColumn("Class")
		//CheckList:AddColumn("Index")
		CheckList:AddColumn("Information")
		//CheckList:AddColumn("Position")
		//CheckList:AddColumn("Equipment")
		for k,v in ipairs(TblCurrentValues) do
			if IsValid(v) then
			local locname = "Unknown"
				for lk,lv in pairs(list.Get("NPC")) do
					if v:GetClass() == lv.Class then locname = lv.Name end
				end
				CheckList:AddLine(locname,v:GetClass(),v) //v:EntIndex()
				//CheckList:AddLine(v)
			end
		end
		CheckList.OnRowSelected = function(rowIndex,row) chat.AddText(Color(0,255,0),"Double click to ",Color(255,100,0),"unselect ",Color(0,255,0),"a NPC") end
		function CheckList:DoDoubleClick(lineID,line)
			chat.AddText(Color(0,255,0),"NPC",Color(255,100,0)," "..line:GetValue(1).." ",Color(0,255,0),"unselected!")
			net.Start("vj_npcmover_removesingle")
			net.WriteEntity(line:GetValue(3))
			net.SendToServer()
			CheckList:RemoveLine(lineID)
			table.Empty(TblCurrentValues)
			for kLine,vLine in pairs(CheckList:GetLines()) do
				table.insert(TblCurrentValues,vLine:GetValue(3))
			end
		end
	Panel:AddItem(CheckList)
	//TblCurrentLines = CheckList:GetLines()
			
	local unselectall = vgui.Create("DButton") -- Bug Report
	unselectall:SetFont("DermaDefaultBold")
	unselectall:SetText("Unselect All NPCs")
	unselectall:SetSize(150, 25)
	unselectall:SetColor(Color(0,0,0,255))
	unselectall.DoClick = function(unselectall)
		local brah = TblCurrentValues
		if table.Count(brah) > 0 then
			chat.AddText(Color(255,100,0),"Unselected all NPCs!")
		else
			chat.AddText(Color(0,255,0),"Nothing to unselect!")
		end
		net.Start("vj_npcmover_removeall")
		net.WriteTable(brah)
		net.SendToServer()
		table.Empty(brah)
		CheckList:Clear()
	end
	Panel:AddPanel(unselectall)
	//Panel:AddControl("Checkbox", {Label = "Kill The Enemy", Command = "vjstool_npccontroller_killenemy"})
end
---------------------------------------------------------------------------------------------------------------------------------------------
	net.Receive("vj_npcmover_cl_create",function(len,pl)
		sventity = net.ReadEntity()
		sventname = net.ReadString()
		TblCurrentValues = TblCurrentValues or {}
		//if svchangetype == "AddNPC" then table.insert(TblCurrentValues,sventity) end
		local changetype = "None"
		for k,v in ipairs(TblCurrentValues) do
			if !IsValid(v) then table.remove(TblCurrentValues,k) continue end
			if v == sventity then
				chat.AddText(Color(0,255,0),"NPC",Color(255,100,0)," "..sventname.." ",Color(0,255,0),"unselected!")
				changetype = "RemoveNPC"
				table.remove(TblCurrentValues,k)
			//else
				//print("Added to the table")
				//changetype = "AddNPC"
				//table.insert(TblCurrentValues,sventity)
			end
		end
		//if table.Count(TblCurrentValues) == 0 && changetype != "RemoveNPC" then
		//if (changetype == "AddNPC") or (table.Count(TblCurrentValues) == 0 && changetype != "RemoveNPC") then
		if changetype != "RemoveNPC" then
			chat.AddText(Color(0,255,0),"NPC",Color(255,100,0)," "..sventname.." ",Color(0,255,0),"selected!")
			changetype = "AddNPC"
			table.insert(TblCurrentValues,sventity)
		end
		GetPanel = controlpanel.Get("vjstool_npcmover")
		GetPanel:ClearControls()
		DoBuildCPanel_Mover(GetPanel)
		net.Start("vj_npcmover_sv_create")
		net.WriteEntity(sventity)
		net.WriteString(changetype)
		net.SendToServer()
		//print("Current Entity: ",sventity)
		//print("--------------")
		//PrintTable(TblCurrentValues)
		//print("--------------")
	end)
---------------------------------------------------------------------------------------------------------------------------------------------
	net.Receive("vj_npcmover_cl_startmove",function(len,pl)
		svwalktype = net.ReadString()
		svvector = net.ReadVector()
		for k,v in ipairs(TblCurrentValues) do
			if !IsValid(v) then 
				table.remove(TblCurrentValues,k)
				GetPanel = controlpanel.Get("vjstool_npcmover")
				GetPanel:ClearControls()
				DoBuildCPanel_Mover(GetPanel)
			end
		end
		net.Start("vj_npcmover_sv_startmove")
		net.WriteTable(TblCurrentValues)
		net.WriteString(svwalktype)
		net.WriteVector(svvector)
		net.SendToServer()
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
	util.AddNetworkString("vj_npcmover_removesingle")
	util.AddNetworkString("vj_npcmover_removeall")
---------------------------------------------------------------------------------------------------------------------------------------------
	net.Receive("vj_npcmover_sv_create",function(len,pl)
		sventity = net.ReadEntity()
		svchangetype = net.ReadString()
		if svchangetype == "AddNPC" then
			//print("fully added")
			sventity.VJ_IsBeingControlled_Tool = true
			sventity:StopMoving()
			if sventity.IsVJBaseSNPC == true then
				sventity.DisableWandering = true
				sventity.DisableChasingEnemy = true
			end
			//self:AddNPC(v)
		elseif svchangetype == "RemoveNPC" then
			//print("fully removed")
			//self:RemoveNPC(v)
			sventity.VJ_IsBeingControlled_Tool = false
			if sventity.IsVJBaseSNPC == true then
				sventity.DisableWandering = false
				sventity.DisableChasingEnemy = false
			end
		end
	end)
	net.Receive("vj_npcmover_sv_startmove",function(len,pl)
		sventtable = net.ReadTable()
		svwalktype = net.ReadString()
		svvector = net.ReadVector()
		for k,v in ipairs(sventtable) do
			if IsValid(v) then
				v:StopMoving()
				v:SetLastPosition(svvector)
				if svwalktype == "Run" then
					if v.IsVJBaseSNPC == true && (v.IsVJBaseSNPC_Creature == true or v.IsVJBaseSNPC_Human == true) then
						//v:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH")
						v:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH",function(x) 
							if v:GetEnemy() != nil && v:Visible(v:GetEnemy()) then
								x:EngTask("TASK_FACE_ENEMY", 0) 
								x.CanShootWhenMoving = true 
								x.ConstantlyFaceEnemy = true
							end
						end)
					else
						v:SetSchedule(SCHED_FORCED_GO_RUN)
					end
				elseif svwalktype == "Walk" then
					if v.IsVJBaseSNPC == true && (v.IsVJBaseSNPC_Creature == true or v.IsVJBaseSNPC_Human == true) then
						//v:VJ_TASK_GOTO_LASTPOS("TASK_WALK_PATH")
						v:VJ_TASK_GOTO_LASTPOS("TASK_WALK_PATH",function(x) 
							if v:GetEnemy() != nil && v:Visible(v:GetEnemy()) then
								x:EngTask("TASK_FACE_ENEMY", 0) 
								x.CanShootWhenMoving = true 
								x.ConstantlyFaceEnemy = true
							end
						end)
					else
						v:SetSchedule(SCHED_FORCED_GO)
					end
				end
			end
		end
		//self:MoveNPC(sventity,svvector,svwalktype)
	end)
	net.Receive("vj_npcmover_removesingle",function(len,pl)
		brahent = net.ReadEntity()
		//TOOL:RemoveNPC(brahent)
		brahent.VJ_IsBeingControlled_Tool = false
		if brahent.IsVJBaseSNPC == true then
			brahent.DisableWandering = false
			brahent.DisableChasingEnemy = false
			brahent:SelectSchedule()
		end
	end)
	net.Receive("vj_npcmover_removeall",function(len,pl)
		brahtbl = net.ReadTable()
		for k,v in ipairs(brahtbl) do
			//TOOL:RemoveNPC(v)
			v.VJ_IsBeingControlled_Tool = false
			if v.IsVJBaseSNPC == true then
				v.DisableWandering = false
				v.DisableChasingEnemy = false
				v:SelectSchedule()
			end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
/*function TOOL:AddNPC(ent)
	ent.VJ_IsBeingControlled_Tool = true
	ent:StopMoving()
	if ent.IsVJBaseSNPC == true then
		ent.DisableWandering = true
		ent.DisableChasingEnemy = true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:RemoveNPC(ent)
	ent.VJ_IsBeingControlled_Tool = false
	if ent.IsVJBaseSNPC == true then
		ent.DisableWandering = false
		ent.DisableChasingEnemy = false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:MoveNPC(ent,pos,movetype)
	if !IsValid(ent) then return end
	ent:StopMoving()
	ent:SetLastPosition(pos)
	if movetype == "Run" then
		if ent.IsVJBaseSNPC == true && (ent.IsVJBaseSNPC_Creature == true or ent.IsVJBaseSNPC_Human == true) then
			ent:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH")
		else
			ent:SetSchedule(SCHED_FORCED_GO_RUN)
		end
	elseif movetype == "Walk" then
		if ent.IsVJBaseSNPC == true && (ent.IsVJBaseSNPC_Creature == true or ent.IsVJBaseSNPC_Human == true) then
			ent:VJ_TASK_GOTO_LASTPOS("TASK_WALK_PATH")
		else
			ent:SetSchedule(SCHED_FORCED_GO)
		end
	end
end*/
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:LeftClick(tr)
	if (CLIENT) then return true end
	if !tr.Entity:IsNPC() then return end
	net.Start("vj_npcmover_cl_create")
	net.WriteEntity(tr.Entity)
	net.WriteString(tr.Entity:GetName())
	net.Send(self:GetOwner())
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:RightClick(tr)
	if (CLIENT) then return true end
	net.Start("vj_npcmover_cl_startmove")
	net.WriteString("Run")
	net.WriteVector(tr.HitPos)
	net.Send(self:GetOwner())
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:Reload(tr)
	if (CLIENT) then return true end
	net.Start("vj_npcmover_cl_startmove")
	net.WriteString("Walk")
	net.WriteVector(tr.HitPos)
	net.Send(self:GetOwner())
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:Holster()
	/*if (CLIENT) then return end
	self.TblCurrentNPCs = self.TblCurrentNPCs or {}
	for k,v in pairs(self.TblCurrentNPCs) do
		self:RemoveNPC(v)
	end*/
end