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
	
	-- Unselect the NPC
	if IsValid(selectedNPC) && selectedNPC == ent then
		self:ClearObjects()
		ply:ChatPrint(VJ.GetName(ent) .. " Has been unselected!")
	-- Select the NPC
	else
		self:ClearObjects()
		self:SetObject(1, ent, tr.HitPos, nil, tr.PhysicsBone, tr.HitNormal)
		ply:ChatPrint(VJ.GetName(ent) .. " Has been selected!")
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
		local followed, failureReason = selectedNPC:Follow(ent, false)
		
		-- SUCCESS
		if followed then
			self:ClearObjects()
			ply:ChatPrint(VJ.GetName(selectedNPC) .. " is now following " .. VJ.GetName(ent))
		-- FAILURES
		elseif failureReason == 1 then
			ply:ChatPrint("ERROR: " .. VJ.GetName(selectedNPC) .. " NPC is stationary and currently unable to follow!")
		elseif failureReason == 2 then
			ply:ChatPrint("ERROR: " .. VJ.GetName(selectedNPC) .. " is already following another entity!")
		elseif failureReason == 3 then
			ply:ChatPrint("ERROR: " .. VJ.GetName(selectedNPC) .. " is NOT friendly to the other entity!")
		else
			ply:ChatPrint("ERROR: " .. VJ.GetName(selectedNPC) .. " is currently unable to follow!")
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