if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Base 			= "base_entity"
ENT.Type 			= "ai"
ENT.PrintName 		= "VJ Creature SNPC Base"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "To make SNPCs."
ENT.Instructions 	= "Don't change anything."
ENT.Category		= "VJ Base"

ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.AutomaticFrameAdvance = false

ENT.IsVJBaseSNPC = true -- Is it a VJ Base SNPC?
ENT.IsVJBaseSNPC_Creature = true -- Is it a VJ Base creature?
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
	-- function ENT:CustomOnCalcView(ply, origin, angles, fov, camera, cameraMode) return false end -- Return true, as well as a table of data to override the default camera calculations
	/*
		Example:
		function ENT:CustomOnCalcView(ply, origin, angles, fov, camera, cameraMode)
			if cameraMode == 1 then -- We're in third-person, use our cool new view!
				return true, {origin = origin - (angles:Forward() * 300)}
			end
			return false
		end

		Return table values are origin, angles, fov, speed
		All table values are optional, but be careful as the default values that will be used instead are not good!
	*/
end