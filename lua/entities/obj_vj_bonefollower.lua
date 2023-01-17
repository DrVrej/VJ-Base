/*--------------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
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

ENT.VJ_BoneFollower = true
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	function ENT:Draw()
		//self:DrawModel()
	end
---------------------------------------------------------------------------------------------------------------------------------------------
	function ENT:DrawTranslucent()
		//self:DrawModel()
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
    self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
    self:SetCustomCollisionCheck(true)
    self:AddEFlags(EFL_DONTBLOCKLOS)

    self:CustomOnInitialize()
    self.BoneFollowers = {}

    hook.Add("OnEntityCreated", self, function(self,ent)
        if ent:GetClass() == "phys_bone_follower" then
            table.insert(self.BoneFollowers, ent)
        end
    end)
    hook.Add("PhysgunPickup", self, function(self,ply,ent)
        if ent:GetClass() == "phys_bone_follower" or ent == self then
            return false
        end
    end)

    timer.Simple(0.1, function()
        if IsValid(self) then
            self:CreateBoneFollowers()
            self.SetToRemove = true
            for _, v in ipairs(self.BoneFollowers) do
                v.VJ_BoneFollower = true
                v:SetCollisionGroup(COLLISION_GROUP_NONE)
                v:SetCustomCollisionCheck(true)
                v:AddEFlags(EFL_DONTBLOCKLOS)
                self:DeleteOnRemove(v)
            end
        end
    end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage(dmginfo)
	-- Make its owner entity (usually an NPC) take damage as if it was its own body
    local owner = self:GetOwner()
    if IsValid(owner) then
        owner:TakeDamageInfo(dmginfo)
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
    self:UpdateBoneFollowers()
    self:NextThink(CurTime() + (0.069696968793869 + FrameTime()))
    if self.SetToRemove then
        self.SetToRemove = false
        hook.Remove("OnEntityCreated", self)
    end
    return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	self:DestroyBoneFollowers()
end