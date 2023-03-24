if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Base 			= "base_entity"
ENT.Type 			= "ai"
ENT.PrintName 		= "VJ Human SNPC Base"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "To make SNPCs."
ENT.Instructions 	= "Don't change anything."
ENT.Category		= "VJ Base"

ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.AutomaticFrameAdvance = false

ENT.IsVJBaseSNPC = true -- Is it a VJ Base SNPC?
ENT.IsVJBaseSNPC_Human = true -- Is it a VJ Base human?
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetAutomaticFrameAdvance(val)
	self.AutomaticFrameAdvance = val
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MatFootStepQCEvent(data)
	-- Return true to apply all changes done to the data table.
	-- Return false to prevent the sound from playing.
	-- Return nil or nothing to play the sound without altering it.
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	//ENT.RenderGroup = RENDERGROUP_BOTH
	function ENT:Initialize() end
	function ENT:Draw() self:DrawModel() self:CustomOnDraw() end
	function ENT:DrawTranslucent() self:Draw() end
	function ENT:BuildBonePositions(NumBones,NumPhysBones) end
	function ENT:SetRagdollBones(bIn) self.m_bRagdollSetup = bIn end
	function ENT:DoRagdollBone(PhysBoneNum,BoneNum) /*self:SetBonePosition(BoneNum,Pos,Angle)*/ end
	//function ENT:CalcAbsolutePosition(pos, ang) end
	-- Custom functions ---------------------------------------------------------------------------------------------------------------------------------------------
	function ENT:CustomOnDraw() end
	-- function ENT:Controller_CalcView(ply, pos, ang, fov, origin, angles, cameraMode) end -- Uncomment to use this function!
		-- Override the NPC Controller's view by returning a table that can take the following values: {pos, ang, fov, speed}
end