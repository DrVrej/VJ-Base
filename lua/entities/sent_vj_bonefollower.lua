AddCSLuaFile()
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end

ENT.Base 			= "base_anim"
ENT.Type 			= "anim"
ENT.PrintName 		= "Bone Follower"
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Used to make simple props and animate them, since prop_dynamic doesn't work properly in Garry's Mod."
ENT.Instructions 	= "Don't change anything."
ENT.Category		= "VJ Base"

ENT.Spawnable = false
ENT.AdminOnly = false
ENT.AutomaticFrameAdvance = true
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	function ENT:Draw()
		-- self:DrawModel()
	end
---------------------------------------------------------------------------------------------------------------------------------------------
	function ENT:Initialize()
		local ent = self:GetParent()
		if IsValid(ent) then -- For some reason doesn't work?
			ent:SetIK(false) -- Until we can find a way to prevent IK chains from detecting the bone followers, we will have to disable IK on the parent.
		end
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

function ENT:CustomOnInitialize() end -- In case you need to change anything
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetSolid(SOLID_NONE)
	self:AddFlags(FL_NOTARGET)
	self:AddEFlags(EFL_DONTBLOCKLOS)
	self:SetCustomCollisionCheck(true)

	self:CustomOnInitialize()
	self:CreateBoneFollowers()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	self:UpdateBoneFollowers()
	self:NextThink(CurTime() + (0.069696968793869 + FrameTime()))
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Remove()
	self:DestroyBoneFollowers()
end