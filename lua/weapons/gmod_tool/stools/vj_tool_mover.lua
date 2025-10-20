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
		VJ_TOOL_MOVER_ENTS = VJ_TOOL_MOVER_ENTS or {}
		
		panel:Help("#vjbase.tool.general.note.recommend")
		
		-- List of selected NPCs
		local selectedList = vgui.Create("DListView")
			selectedList:SetSize(100, 300)
			selectedList:SetMultiSelect(false)
			selectedList:AddColumn("#tool.vj_tool_mover.list.name")
			selectedList:AddColumn("#tool.vj_tool_mover.list.info")
			for _, npc in ipairs(VJ_TOOL_MOVER_ENTS) do
				if IsValid(npc) then
					selectedList:AddLine(list.Get("NPC")[npc:GetClass()].Name or "Unknown", npc)
				end
			end
			-- Help text on single click
			function selectedList:OnRowSelected(rowIndex, row)
				chat.AddText(VJ.COLOR_GREEN, "Double click to ", VJ.COLOR_ORANGE_VIVID, "unselect ", VJ.COLOR_GREEN, "a NPC")
			end
			-- Double click to remove an entity from the list
			function selectedList:DoDoubleClick(lineID, line)
				chat.AddText(VJ.COLOR_GREEN, "NPC", VJ.COLOR_ORANGE_VIVID, " " .. line:GetValue(1) .. " ", VJ.COLOR_GREEN, "unselected!")
				net.Start("vj_tool_mover_sv_select")
					net.WriteBit(1)
					net.WriteUInt(1, MAX_EDICT_BITS)
					net.WriteEntity(line:GetValue(2))
				net.SendToServer()
				selectedList:RemoveLine(lineID)
				VJ_TOOL_MOVER_ENTS = {}
				for _, vLine in pairs(selectedList:GetLines()) do
					table.insert(VJ_TOOL_MOVER_ENTS, vLine:GetValue(2))
				end
			end
		panel:AddItem(selectedList)
		
		-- Unselect all button
		local unselectButton = vgui.Create("DButton")
			unselectButton:SetFont("DermaDefaultBold")
			unselectButton:SetText("#tool.vj_tool_mover.button.unselectall")
			unselectButton:SetSize(150, 25)
			unselectButton:SetColor(VJ.COLOR_BLACK)
			function unselectButton:DoClick()
				local entsCount = #VJ_TOOL_MOVER_ENTS
				if entsCount > 0 then
					chat.AddText(VJ.COLOR_ORANGE_VIVID, "#tool.vj_tool_mover.print.unselectedall")
					net.Start("vj_tool_mover_sv_select")
						net.WriteBit(1)
						net.WriteUInt(entsCount, MAX_EDICT_BITS)
						for i = 1, entsCount do
							net.WriteEntity(VJ_TOOL_MOVER_ENTS[i])
						end
					net.SendToServer()
				else
					chat.AddText(VJ.COLOR_GREEN, "#tool.vj_tool_mover.print.unselectedall.error")
				end
				selectedList:Clear()
				VJ_TOOL_MOVER_ENTS = {}
			end
		panel:AddPanel(unselectButton)
	end
---------------------------------------------------------------------------------------------------------------------------------------------
	net.Receive("vj_tool_mover_cl_select", function(len)
		local wep = LocalPlayer():GetActiveWeapon()
		if wep:IsValid() && wep:GetClass() == "gmod_tool" && wep:GetMode() == "vj_tool_mover" && hook.Run("CanTool", LocalPlayer(), LocalPlayer():GetEyeTrace(), "vj_tool_mover") then
			local ent = net.ReadEntity()
			local entName = net.ReadString()
			VJ_TOOL_MOVER_ENTS = VJ_TOOL_MOVER_ENTS or {}
			local editType = 0 -- Check if we are removing or adding an NPC | 0 = Add, 1 = Remove
			for k, v in ipairs(VJ_TOOL_MOVER_ENTS) do
				if !IsValid(v) then table.remove(VJ_TOOL_MOVER_ENTS, k) continue end -- Remove any NPCs that no longer exist!
				if v == ent then -- If the selected NPC already exists then unselect it!
					chat.AddText(VJ.COLOR_GREEN, "NPC", VJ.COLOR_ORANGE_VIVID, " " .. entName .. " ", VJ.COLOR_GREEN, "unselected!")
					editType = 1
					table.remove(VJ_TOOL_MOVER_ENTS, k)
				end
			end
			if editType == 0 then -- Only if we are adding
				chat.AddText(VJ.COLOR_GREEN, "NPC", VJ.COLOR_ORANGE_VIVID, " " .. entName .. " ", VJ.COLOR_GREEN, "selected!")
				table.insert(VJ_TOOL_MOVER_ENTS, ent)
			end
			-- Refresh the tool menu
			local getPanel = controlpanel.Get("vj_tool_mover")
			getPanel:Clear()
			ControlPanel(getPanel)
			net.Start("vj_tool_mover_sv_select")
				net.WriteBit(editType)
				net.WriteUInt(1, MAX_EDICT_BITS)
				net.WriteEntity(ent)
			net.SendToServer()
		end
	end)
---------------------------------------------------------------------------------------------------------------------------------------------
	net.Receive("vj_tool_mover_cl_move", function(len)
		local moveType = net.ReadBit()
		local movePos = net.ReadVector()
		local wep = LocalPlayer():GetActiveWeapon()
		if wep:IsValid() && wep:GetClass() == "gmod_tool" && wep:GetMode() == "vj_tool_mover" && hook.Run("CanTool", LocalPlayer(), LocalPlayer():GetEyeTrace(), "vj_tool_mover") then
			for k, v in ipairs(VJ_TOOL_MOVER_ENTS) do
				if !IsValid(v) then -- Remove any NPCs that no longer exist!
					table.remove(VJ_TOOL_MOVER_ENTS, k)
					local getPanel = controlpanel.Get("vj_tool_mover")
					getPanel:Clear()
					ControlPanel(getPanel)
				end
			end
			local entsCount = #VJ_TOOL_MOVER_ENTS
			if entsCount > 0 then
				net.Start("vj_tool_mover_sv_move")
					net.WriteBit(moveType)
					net.WriteVector(movePos)
					net.WriteUInt(entsCount, MAX_EDICT_BITS)
					for i = 1, entsCount do
						net.WriteEntity(VJ_TOOL_MOVER_ENTS[i])
					end
				net.SendToServer()
			end
		end
	end)
---------------------------------------------------------------------------------------------------------------------------------------------
	function TOOL.BuildCPanel(panel)
		ControlPanel(panel)
	end
else
	util.AddNetworkString("vj_tool_mover_cl_select")
	util.AddNetworkString("vj_tool_mover_cl_move")
	util.AddNetworkString("vj_tool_mover_sv_select")
	util.AddNetworkString("vj_tool_mover_sv_move")
---------------------------------------------------------------------------------------------------------------------------------------------
	net.Receive("vj_tool_mover_sv_select", function(len, ply)
		local wep = ply:GetActiveWeapon()
		if wep:IsValid() && wep:GetClass() == "gmod_tool" && wep:GetMode() == "vj_tool_mover" && hook.Run("CanTool", ply, ply:GetEyeTrace(), "vj_tool_mover") then
			local editType = net.ReadBit()
			local entCount = net.ReadUInt(MAX_EDICT_BITS)
			for _ = 1, entCount do
				local ent = net.ReadEntity()
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
		end
	end)
---------------------------------------------------------------------------------------------------------------------------------------------
	net.Receive("vj_tool_mover_sv_move", function(len, ply)
		local wep = ply:GetActiveWeapon()
		if wep:IsValid() && wep:GetClass() == "gmod_tool" && wep:GetMode() == "vj_tool_mover" && hook.Run("CanTool", ply, ply:GetEyeTrace(), "vj_tool_mover") then
			local moveType = net.ReadBit()
			local movePos = net.ReadVector()
			local moveTypeVJ = moveType == 1 and "TASK_RUN_PATH" or "TASK_WALK_PATH"
			local moveTypeReg = moveType == 1 and SCHED_FORCED_GO_RUN or SCHED_FORCED_GO
			local entCount = net.ReadUInt(MAX_EDICT_BITS)
			for _ = 1, entCount do
				local ent = net.ReadEntity()
				if IsValid(ent) then
					ent:StopMoving()
					ent:SetLastPosition(movePos)
					if ent.IsVJBaseSNPC then
						if k == 1 or math.random(1, 5) == 1 then ent:PlaySoundSystem("ReceiveOrder") end
						ent:SCHEDULE_GOTO_POSITION(moveTypeVJ, function(schedule)
							schedule.CanShootWhenMoving = true
							schedule.TurnData = {Type = VJ.FACE_ENEMY_VISIBLE}
						end)
					else -- For non-VJ NPCs
						ent:SetSchedule(moveTypeReg)
					end
				end
			end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:LeftClick(tr)
	if CLIENT then return true end
	local ent = tr.Entity
	if !ent:IsNPC() then return end
	net.Start("vj_tool_mover_cl_select")
		net.WriteEntity(ent)
		if ent:GetName() == "" then
			net.WriteString(list.Get("NPC")[ent:GetClass()].Name)
		else
			net.WriteString(ent:GetName())
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