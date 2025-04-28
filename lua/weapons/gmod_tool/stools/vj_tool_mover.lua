TOOL.Name = "#tool.vj_tool_mover.name"
TOOL.Tab = "DrVrej"
TOOL.Category = "Tools"
TOOL.Information = {
	{name = "left"},
	{name = "right"},
	{name = "reload"},
}
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	local function ControlPanel(panel)
		VJ_MOVE_TblCurrentValues = VJ_MOVE_TblCurrentValues or {}
		VJ_MOVE_TblCurrentLines = VJ_MOVE_TblCurrentLines or {}
		
		panel:Help("#vjbase.tool.general.note.recommend")
		
		-- List of selected NPCs
		local selectedList = vgui.Create("DListView")
			selectedList:SetTooltip(false)
			selectedList:SetSize(100, 300)
			selectedList:SetMultiSelect(false)
			selectedList:AddColumn("#tool.vj_tool_mover.list.name")
			selectedList:AddColumn("#tool.vj_tool_mover.list.class")
			selectedList:AddColumn("#tool.vj_tool_mover.list.info")
			for _, npc in ipairs(VJ_MOVE_TblCurrentValues) do
				if IsValid(npc) then
					selectedList:AddLine(list.Get("NPC")[npc:GetClass()].Name or "Unknown", npc:GetClass(), npc)
				end
			end
			selectedList.OnRowSelected = function(rowIndex, row)
				chat.AddText(Color(0, 255, 0), "Double click to ", Color(255, 100, 0), "unselect ", Color(0, 255, 0), "a NPC")
			end
			selectedList.DoDoubleClick = function(lineID, line)
				chat.AddText(Color(0, 255, 0), "NPC", Color(255, 100, 0), " " .. line:GetValue(1) .. " ", Color(0, 255, 0), "unselected!")
				net.Start("vj_tool_mover_sv_remove")
				net.WriteTable({line:GetValue(3)})
				net.SendToServer()
				selectedList:RemoveLine(lineID)
				table.Empty(VJ_MOVE_TblCurrentValues)
				for _, vLine in pairs(selectedList:GetLines()) do
					table.insert(VJ_MOVE_TblCurrentValues, vLine:GetValue(3))
				end
			end
		panel:AddItem(selectedList)
		
		-- Unselect all button
		local unselectButton = vgui.Create("DButton")
		unselectButton:SetFont("DermaDefaultBold")
		unselectButton:SetText("#tool.vj_tool_mover.button.unselectall")
		unselectButton:SetSize(150, 25)
		unselectButton:SetColor(VJ.COLOR_BLACK)
		unselectButton.DoClick = function()
			if !table.IsEmpty(VJ_MOVE_TblCurrentValues) then
				chat.AddText(Color(255, 100, 0), "#tool.vj_tool_mover.print.unselectedall")
			else
				chat.AddText(Color(0, 255, 0), "#tool.vj_tool_mover.print.unselectedall.error")
			end
			net.Start("vj_tool_mover_sv_remove")
			net.WriteTable(VJ_MOVE_TblCurrentValues)
			net.SendToServer()
			selectedList:Clear()
			VJ_MOVE_TblCurrentValues = {}
		end
		panel:AddPanel(unselectButton)
	end
---------------------------------------------------------------------------------------------------------------------------------------------
	net.Receive("vj_tool_mover_cl_create", function(len)
		local wep = LocalPlayer():GetActiveWeapon()
		if wep:IsValid() && wep:GetClass() == "gmod_tool" && wep:GetMode() == "vj_tool_mover" && hook.Run("CanTool", LocalPlayer(), LocalPlayer():GetEyeTrace(), "vj_tool_mover") then
			local ent = net.ReadEntity()
			local entName = net.ReadString()
			VJ_MOVE_TblCurrentValues = VJ_MOVE_TblCurrentValues or {}
			local editType = 0 -- Check if we are removing or adding an NPC | 0 = Add, 1 = Remove
			for k, v in ipairs(VJ_MOVE_TblCurrentValues) do
				if !IsValid(v) then table.remove(VJ_MOVE_TblCurrentValues, k) continue end -- Remove any NPCs that no longer exist!
				if v == ent then -- If the selected NPC already exists then unselect it!
					chat.AddText(Color(0, 255, 0), "NPC", Color(255, 100, 0), " " .. entName .. " ", Color(0, 255, 0), "unselected!")
					editType = 1
					table.remove(VJ_MOVE_TblCurrentValues, k)
				end
			end
			if editType == 0 then -- Only if we are adding
				chat.AddText(Color(0, 255, 0), "NPC", Color(255, 100, 0), " " .. entName .. " ", Color(0, 255, 0), "selected!")
				table.insert(VJ_MOVE_TblCurrentValues, ent)
			end
			-- Refresh the tool menu
			local getPanel = controlpanel.Get("vj_tool_mover")
			getPanel:Clear()
			ControlPanel(getPanel)
			net.Start("vj_tool_mover_sv_create")
			net.WriteEntity(ent)
			net.WriteBit(editType)
			net.SendToServer()
			//print("Current Entity: ", ent)
			//print("--------------")
			//PrintTable(VJ_MOVE_TblCurrentValues)
			//print("--------------")
		end
	end)
---------------------------------------------------------------------------------------------------------------------------------------------
	net.Receive("vj_tool_mover_cl_move", function(len)
		local moveType = net.ReadBit()
		local movePos = net.ReadVector()
		local wep = LocalPlayer():GetActiveWeapon()
		if wep:IsValid() && wep:GetClass() == "gmod_tool" && wep:GetMode() == "vj_tool_mover" && hook.Run("CanTool", LocalPlayer(), LocalPlayer():GetEyeTrace(), "vj_tool_mover") then
			for k, v in ipairs(VJ_MOVE_TblCurrentValues) do
				if !IsValid(v) then -- Remove any NPCs that no longer exist!
					table.remove(VJ_MOVE_TblCurrentValues, k)
					local getPanel = controlpanel.Get("vj_tool_mover")
					getPanel:Clear()
					ControlPanel(getPanel)
				end
			end
			net.Start("vj_tool_mover_sv_move")
			net.WriteTable(VJ_MOVE_TblCurrentValues)
			net.WriteBit(moveType)
			net.WriteVector(movePos)
			net.SendToServer()
		end
	end)
---------------------------------------------------------------------------------------------------------------------------------------------
	function TOOL.BuildCPanel(panel)
		ControlPanel(panel)
	end
else
	util.AddNetworkString("vj_tool_mover_cl_create")
	util.AddNetworkString("vj_tool_mover_cl_move")
	util.AddNetworkString("vj_tool_mover_sv_create")
	util.AddNetworkString("vj_tool_mover_sv_move")
	util.AddNetworkString("vj_tool_mover_sv_remove")
---------------------------------------------------------------------------------------------------------------------------------------------
	net.Receive("vj_tool_mover_sv_create", function(len, ply)
		local wep = ply:GetActiveWeapon()
		if wep:IsValid() && wep:GetClass() == "gmod_tool" && wep:GetMode() == "vj_tool_mover" && hook.Run("CanTool", ply, ply:GetEyeTrace(), "vj_tool_mover") then
			local ent = net.ReadEntity()
			local editType = net.ReadBit()
			if editType == 0 then -- Add
				ent.VJ_IsBeingControlled_Tool = true
				ent:StopMoving()
				ent.VJ_MoverToolOrg_Wander = ent.DisableWandering
				ent.VJ_MoverToolOrg_Chase = ent.DisableChasingEnemy
				if ent.IsVJBaseSNPC then
					ent.DisableWandering = true
					ent.DisableChasingEnemy = true
				end
			elseif editType == 1 then -- Remove
				ent.VJ_IsBeingControlled_Tool = false
				if ent.IsVJBaseSNPC then
					ent.DisableWandering = ent.VJ_MoverToolOrg_Wander != nil and ent.VJ_MoverToolOrg_Wander or false
					ent.DisableChasingEnemy = ent.VJ_MoverToolOrg_Chase != nil and ent.VJ_MoverToolOrg_Chase or false
					ent:SelectSchedule()
				end
			end
		end
	end)
	
	net.Receive("vj_tool_mover_sv_remove", function(len, ply)
		local wep = ply:GetActiveWeapon()
		if wep:IsValid() && wep:GetClass() == "gmod_tool" && wep:GetMode() == "vj_tool_mover" && hook.Run("CanTool", ply, ply:GetEyeTrace(), "vj_tool_mover") then
			local entTable = net.ReadTable()
			for _, npc in ipairs(entTable) do
				npc.VJ_IsBeingControlled_Tool = false
				if npc.IsVJBaseSNPC then
					npc.DisableWandering = npc.VJ_MoverToolOrg_Wander != nil and npc.VJ_MoverToolOrg_Wander or false
					npc.DisableChasingEnemy = npc.VJ_MoverToolOrg_Chase != nil and npc.VJ_MoverToolOrg_Chase or false
					npc:SelectSchedule()
				end
			end
		end
	end)
	
	net.Receive("vj_tool_mover_sv_move", function(len, ply)
		local wep = ply:GetActiveWeapon()
		if wep:IsValid() && wep:GetClass() == "gmod_tool" && wep:GetMode() == "vj_tool_mover" && hook.Run("CanTool", ply, ply:GetEyeTrace(), "vj_tool_mover") then
			local entTable = net.ReadTable()
			local moveType = net.ReadBit()
			local movePos = net.ReadVector()
			local moveTypeVJ = "TASK_WALK_PATH"
			local moveTypeReg = SCHED_FORCED_GO
			if moveType == 1 then
				moveTypeVJ = "TASK_RUN_PATH"
				moveTypeReg = SCHED_FORCED_GO_RUN
			end
			for k, npc in ipairs(entTable) do
				if IsValid(npc) then
					npc:StopMoving()
					npc:SetLastPosition(movePos)
					if npc.IsVJBaseSNPC then
						if k == 1 or math.random(1, 5) == 1 then npc:PlaySoundSystem("ReceiveOrder") end
						npc:SCHEDULE_GOTO_POSITION(moveTypeVJ, function(schedule)
							schedule.CanShootWhenMoving = true
							schedule.TurnData = {Type = VJ.FACE_ENEMY_VISIBLE}
						end)
					else -- For non-VJ NPCs
						npc:SetSchedule(moveTypeReg)
					end
				end
			end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:LeftClick(tr)
	if CLIENT then return true end
	if !tr.Entity:IsNPC() then return end
	net.Start("vj_tool_mover_cl_create")
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
	net.Start("vj_tool_mover_cl_move")
	net.WriteBit(1)
	net.WriteVector(tr.HitPos)
	net.Send(self:GetOwner())
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:Reload(tr)
	if CLIENT then return true end
	net.Start("vj_tool_mover_cl_move")
	net.WriteBit(0)
	net.WriteVector(tr.HitPos)
	net.Send(self:GetOwner())
	return true
end