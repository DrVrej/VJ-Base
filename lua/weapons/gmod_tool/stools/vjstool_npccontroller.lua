TOOL.Name = "NPC Controller"
TOOL.Category = "Tools"
TOOL.Tab = "DrVrej"
TOOL.Command = nil
TOOL.ConfigName = ""

TOOL.ClientConVar["killenemy"] = "true"

local DefaultConVars = {}
for k,v in pairs(TOOL.ClientConVar) do
	DefaultConVars["vjstool_npccontroller_"..k] = v
end

if (CLIENT) then
	language.Add("tool.vjstool_npccontroller.name", "NPC Controller")
	language.Add("tool.vjstool_npccontroller.desc", "Control an NPC or a group of NPCs")
	language.Add("tool.vjstool_npccontroller.0", "Left-Click to select, Right-Click to move(Run), Reload-Key to move(walk)")
	
	//language.Add("vjbase.npctools.health", "Health")
else
	util.AddNetworkString("vj_npcontroller_removeall")
	
	net.Receive("vj_npcontroller_removeall",function(len,pl)
		print(self.Entity)
		for k,v in pairs(TOOL.TblCurrentNPCs) do
			TOOL:RemoveNPC(v)
		end
	end)
end

function TOOL.BuildCPanel(Panel)
	//PrintTable(DefaultConVars)
	//Panel:AddControl("Header", {Text = "NPC Tool", Description = "Left click to change the NPC's property"})
	
	local reset = vgui.Create("DButton") -- Bug Report
	reset:SetFont("CloseCaption")
	reset:SetText("Reset To Default")
	reset:SetSize(150, 25)
	reset:SetColor(Color(0,0,0,255))
	reset.DoClick = function(reset)
		for k,v in pairs(DefaultConVars) do
			LocalPlayer():ConCommand(k.." "..v)
			//LocalPlayer():ConCommand("vjstool_npcproperty_health 100")
		end
	end
	Panel:AddPanel(reset)
	
	Panel:AddControl("Label", {Text = "It's recommanded to use this tool only for VJ Base SNPCs."})
	local unselectall = vgui.Create("DButton") -- Bug Report
	unselectall:SetFont("CloseCaption")
	unselectall:SetText("Unselect All NPCs")
	unselectall:SetSize(150, 25)
	unselectall:SetColor(Color(0,0,0,255))
	unselectall.DoClick = function(unselectall)
		net.Start("vj_npcontroller_removeall")
		net.SendToServer()
	end
	Panel:AddPanel(unselectall)
	//Panel:AddControl("Checkbox", {Label = "Kill The Enemy", Command = "vjstool_npccontroller_killenemy"})
end

function TOOL:AddNPC(ent)
	table.insert(self.TblCurrentNPCs,ent)
	ent.ControlledByVJTool = true
	ent:StopMoving()
	if ent.IsVJBaseSNPC == true then
		ent.DisableWandering = true
		ent.DisableChasingEnemy = true
	end
end

function TOOL:RemoveNPC(ent)
	for k,v in ipairs(self.TblCurrentNPCs) do
		if v == ent then
			table.remove(self.TblCurrentNPCs,k)
			ent.ControlledByVJTool = false
			if ent.IsVJBaseSNPC == true then
				ent.DisableWandering = false
				ent.DisableChasingEnemy = false
			end
			break
		end
	end
end

function TOOL:LeftClick(tr)
	if (CLIENT) then return true end
	if IsValid(tr.Entity) && tr.Entity:IsNPC() then
		self.TblCurrentNPCs = self.TblCurrentNPCs or {}
		if table.HasValue(self.TblCurrentNPCs,tr.Entity) then self:RemoveNPC(tr.Entity) return true end
		if (!tr.Entity.ControlledByVJTool) then self:AddNPC(tr.Entity) return true end
		//return false
	end
end

function TOOL:RightClick(tr)
	if (CLIENT) then return true end
	self.TblCurrentNPCs = self.TblCurrentNPCs or {}
	if table.Count(self.TblCurrentNPCs) > 0 then
		for k,v in ipairs(self.TblCurrentNPCs) do
			if !IsValid(v) then table.remove(self.TblCurrentNPCs,k) continue end
			v:StopMoving()
			v:SetLastPosition(tr.HitPos)
			v:SetSchedule(SCHED_FORCED_GO_RUN)
		end
		return true
	end
end

function TOOL:Reload(tr)
	if (CLIENT) then return true end
	self.TblCurrentNPCs = self.TblCurrentNPCs or {}
	if table.Count(self.TblCurrentNPCs) > 0 then
		for k,v in ipairs(self.TblCurrentNPCs) do
			if !IsValid(v) then table.remove(self.TblCurrentNPCs,k) continue end
			v:StopMoving()
			v:SetLastPosition(tr.HitPos)
			v:SetSchedule(SCHED_FORCED_GO)
		end
		return true
	end
end

function TOOL:Holster()
	if(CLIENT) then return end
	self.TblCurrentNPCs = self.TblCurrentNPCs or {}
	for k,v in pairs(self.TblCurrentNPCs) do
		self:RemoveNPC(v)
	end
end