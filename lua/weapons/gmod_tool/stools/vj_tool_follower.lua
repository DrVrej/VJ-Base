TOOL.Name = "#tool.vj_tool_follower.name"
TOOL.Tab = "DrVrej"
TOOL.Category = "Tools"
TOOL.Information = {
	{name = "left"},
	{name = "right"},
	{name = "reload"},
}
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	function TOOL.BuildCPanel(panel)
		panel:Help("#vjbase.tool.general.note.recommend")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:LeftClick(tr)
	if CLIENT then return true end
	local ent = tr.Entity
	if !IsValid(ent) or !ent:IsNPC() or !ent.IsVJBaseSNPC then return end
	local ply = self:GetOwner()
	local selectedNPC = self:GetEnt(1)
	local npcName = list.Get("NPC")[ent:GetClass()].Name
	
	-- Unselect the NPC
	if IsValid(selectedNPC) && selectedNPC == ent then
		self:ClearObjects()
		ply:ChatPrint(npcName .. " Has been unselected!")
	-- Select the NPC
	else
		self:ClearObjects()
		self:SetObject(1, ent, tr.HitPos, nil, tr.PhysicsBone, tr.HitNormal)
		ply:ChatPrint(npcName .. " Has been selected!")
	end
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:RightClick(tr)
	if CLIENT then return true end
	local ent = tr.Entity
	if !IsValid(ent) then return end
	local ply = self:GetOwner()
	local selectedNPC = self:GetEnt(1)
	
	if IsValid(selectedNPC) then
		local npcName = list.Get("NPC")[selectedNPC:GetClass()].Name
		local followed, failureReason = selectedNPC:Follow(ent, false)
		
		-- SUCCESS
		if followed then
			self:ClearObjects()
			ply:ChatPrint(npcName .. " is now following " .. ent:GetClass())
		-- FAILURES
		elseif failureReason == 1 then
			ply:ChatPrint("ERROR: " .. npcName .. " NPC is stationary and currently unable to follow!")
		elseif failureReason == 2 then
			ply:ChatPrint("ERROR: " .. npcName .. " is already following another entity!")
		elseif failureReason == 3 then
			ply:ChatPrint("ERROR: " .. npcName .. " is NOT friendly to the other entity!")
		else
			ply:ChatPrint("ERROR: " .. npcName .. " is currently unable to follow!")
		end
	else
		ply:ChatPrint("#tool.vj_tool_follower.print.noselection")
	end
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:Reload(tr)
	if CLIENT then return true end
	local ent = tr.Entity
	if !IsValid(ent) or !ent:IsNPC() or !ent.IsVJBaseSNPC then return end
	ent:ResetFollowBehavior()
	self:GetOwner():ChatPrint("#tool.vj_tool_follower.print.reset")
	return true
end