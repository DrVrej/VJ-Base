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
//function ENT:FireAnimationEvent(pos, ang, event, name)
	//print(pos, ang, event, name)
//end
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	//ENT.RenderGroup = RENDERGROUP_BOTH
	function ENT:Initialize()
		if GetConVar("vj_npc_ikchains"):GetInt() == 0 then self:SetIK(false) end
		if GetConVar("vj_npc_forcelowlod"):GetInt() == 1 then self:SetLOD(8) end
		if self.CustomOnDraw then -- !!!!!!!!!!!!!! DO NOT USE THIS FUNCTION !!!!!!!!!!!!!! [Backwards Compatibility!]
			function self:Draw()
				self:DrawModel()
				self:CustomOnDraw()
			end
		end
		self:Init()
	end
	function ENT:Draw() self:DrawModel() end
	function ENT:DrawTranslucent() self:Draw() end
	function ENT:BuildBonePositions(NumBones ,NumPhysBones) end
	function ENT:SetRagdollBones(bIn) self.m_bRagdollSetup = bIn end
	function ENT:DoRagdollBone(PhysBoneNum, BoneNum) end // self:SetBonePosition(BoneNum,Pos,Angle)
	//function ENT:CalcAbsolutePosition(pos, ang) end
	-- Custom functions ---------------------------------------------------------------------------------------------------------------------------------------------
	function ENT:Init() end
	--[[---------------------------------------------------------
		UNCOMMENT TO USE | Overrides the camera calculations for the NPC Controller
			- ply = Player that is controlling the NPC
			- origin = Current view position
			- angles = Current view angles
			- fov = Current field of view
			- camera = Camera entity
			- cameraMode = Camera mode | 1 = Third, 2 = First
		Returns
			- false or nothing = Run base code
			- Table: Override base code, possible values --> {origin, ang, fov, speed}, "speed" = Camera lerp speed
		Example Code:
			Use a new cool view origin!
			--
			if cameraMode == 1 then -- Only if we are in third person
				return {origin = origin - (angles:Forward() * 300)}
			end
			return false
			--
	-----------------------------------------------------------]]
	-- function ENT:Controller_CalcView(ply, origin, angles, fov, camera, cameraMode) end
end