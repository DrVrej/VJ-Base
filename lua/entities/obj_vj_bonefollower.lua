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
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	function ENT:Draw()
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
    self:AddEFlags(EFL_DONTBLOCKLOS)
    self:SetCustomCollisionCheck(true)

    self:CustomOnInitialize()
    self.BoneFollowers = {}

    local hookName = "VJ_BoneFollower_" .. self:EntIndex()
    hook.Add("OnEntityCreated", hookName, function(ent)
        if !IsValid(self) then
            hook.Remove("OnEntityCreated", hookName)
            return
        end
        if ent:GetClass() == "phys_bone_follower" then
            table.insert(self.BoneFollowers,ent)
        end
    end)
    hook.Add("PhysgunPickup", hookName, function(ply,ent)
        if !IsValid(self) then
            hook.Remove("PhysgunPickup", hookName)
            return
        end
        if ent:GetClass() == "phys_bone_follower" or ent == self then
            return false
        end
    end)

    timer.Simple(0.1,function()
        if IsValid(self) then
            self:CreateBoneFollowers()
            self.SetToRemove = true
            //PrintTable(self.BoneFollowers)
            for _,v in pairs(self.BoneFollowers) do
                v:AddEFlags(EFL_DONTBLOCKLOS)
            end
        end
    end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
    self:UpdateBoneFollowers()
    self:NextThink(CurTime() + (0.069696968793869 + FrameTime()))
    if self.SetToRemove then
        self.SetToRemove = false
        hook.Remove("OnEntityCreated", "VJ_BoneFollower_" .. self:EntIndex())
    end
    return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Remove()
	self:DestroyBoneFollowers()
end