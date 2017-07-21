/*--------------------------------------------------
	=============== Utils ===============
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to load utils for VJ Base
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end

-- Add Utils -------------------------------------------------------------------------------------------------------------------------
function util.VJ_SphereDamage(vAttacker,vInflictor,vPosition,vDamageRadius,vDamage,vDamageType,vBlockCertainEntities,vUseRealisticRadius,Tbl_Features,CustomCode)
	local vPosition = vPosition or vAttacker:GetPos()
	local vDamageRadius = vDamageRadius or 150
	local vDamage = vDamage or 15
	local vDamageType = vDamageType or DMG_BLAST
	local vTbl_Features = Tbl_Features or {}
		local vTbl_Force = vTbl_Features.Force or false -- The general force | false = Don't use any force
		local vTbl_UpForce = vTbl_Features.UpForce or false -- How much up force should it have? | false = Use vTbl_Force
		local vTbl_DamageAttacker = vTbl_Features.DamageAttacker or false -- Should it damage the attacker as well?
		local vTbl_UseCone = vTbl_Features.UseCone or false -- Should it detect entities using a cone?
		local vTbl_DirectionPos = vTbl_Features.DirectionPos or vAttacker:GetForward() -- The position it starts the cone degree from
		local vTbl_UseConeDegree = vTbl_Features.UseConeDegree or 90 -- The degrees it should use for the cone finding
	------------------------
	local Finaldmg = vDamage
	local Foundents = {}
	local Findents = nil
	if vTbl_UseCone == true then
		Findents = VJ_FindInCone(vPosition,vTbl_DirectionPos,vDamageRadius,vTbl_UseConeDegree,{AllEntities=true})
	else
		Findents = ents.FindInSphere(vPosition,vDamageRadius)
	end
	if (!Findents) then return end
	for k,v in pairs(Findents) do
		if (vAttacker.VJ_IsBeingControlled == true && vAttacker.VJ_TheControllerBullseye == v) or (v:IsPlayer() && v.IsControlingNPC == true) then continue end
		if v:EntIndex() == vAttacker:EntIndex() && vTbl_DamageAttacker == false then continue end
		local vtoself = v:NearestPoint(vPosition) -- From the enemy position to the given position
		if vUseRealisticRadius == true then
			Finaldmg = math.Clamp(Finaldmg*((vDamageRadius-vPosition:Distance(vtoself))+150)/vDamageRadius, vDamage/2, Finaldmg) -- Decrease damage from the nearest point all the way to the enemy point then clamp it!
		end
		
		local function DoDamageCode(v2)
			table.insert(Foundents,v)
			if (v2:GetClass() == "npc_strider" or v2:GetClass() == "npc_combinedropship" or v2:GetClass() == "npc_combinegunship" or v2:GetClass() == "npc_helicopter") then
				v2:TakeDamage(Finaldmg,vAttacker,vInflictor)
			else
				local doactualdmg = DamageInfo()
				doactualdmg:SetDamage(Finaldmg)
				doactualdmg:SetAttacker(vAttacker)
				doactualdmg:SetInflictor(vInflictor)
				doactualdmg:SetDamageType(vDamageType)
				doactualdmg:SetDamagePosition(vtoself)
				v2:TakeDamageInfo(doactualdmg)
				VJ_DestroyCombineTurret(vAttacker,v2)
			end
		end
		
		if vBlockCertainEntities == true then
			if (v:IsNPC() && (v:Disposition(vAttacker) != D_LI) && v:Health() > 0 && (v != vAttacker) && (v:GetClass() != vAttacker:GetClass())) or (v:IsPlayer() && GetConVarNumber("ai_ignoreplayers") == 0 && v:Alive() && v:Health() > 0 && v.VJ_NoTarget != true) then
				//if ((v:IsNPC() && v:Disposition(vAttacker) == 1 or v:Disposition(vAttacker) == 2) or (v:IsPlayer() && v:Alive())) && (v != vAttacker) && (v:GetClass() != vAttacker:GetClass()) then -- entity check
				DoDamageCode(v)
			elseif !v:IsNPC() && !v:IsPlayer() then
				DoDamageCode(v)
			end
		else
			DoDamageCode(v)
		end
		
		if vTbl_Force != false then
			local phys = v:GetPhysicsObject()
			if phys:IsValid() && phys != nil && phys != NULL then
				//v:SetVelocity(v:GetUp()*100000)
				//if v:GetClass() == "prop_ragdoll" then 
					//v:GetPhysicsObject():ApplyForceCenter(v:GetUp()*vForceRagdoll)
				if VJ_IsProp(v) == true or v:GetClass() == "prop_ragdoll" then
					//v:GetPhysicsObject():ApplyForceCenter(v:GetUp()*vForcePropPhysics)
					local force = vTbl_Force
					local upforce = vTbl_UpForce
					if v:GetClass() == "prop_ragdoll" then force = force * 1.5 end
					if upforce == false then upforce = force/9.4 end
					phys:ApplyForceCenter(((v:GetPos()+v:OBBCenter()+v:GetUp()*upforce)-vPosition)*force) //+vAttacker:GetForward()*vForcePropPhysics
				end
			end
		end
		if (CustomCode) then CustomCode(v) end
	end
	return Foundents
end
---------------------------------------------------------------------------------------------------------------------------------------------
function util.VJ_GetSNPCsWithActiveSoundTracks() -- !!!!! Deprecated Function !!!!! --
	local TableEntities = {}
	for k,v in ipairs(ents.GetAll()) do
		if v:IsNPC() then
			if v:GetNetworkedBool("VJ_IsPlayingSoundTrack") == true then
				table.insert(TableEntities,v)
			end
		end
	end
	return TableEntities
end
---------------------------------------------------------------------------------------------------------------------------------------------
function util.VJ_GetWeaponPos(GetClassEntity)
	if GetClassEntity:GetActiveWeapon() == NULL then return false end
	local wep = GetClassEntity:GetActiveWeapon()
	local getmuzzle;
	local numattachments = wep:GetAttachments()
	local numattachments = #wep:GetAttachments()
	if (wep:IsValid()) then
		for i = 1,numattachments do
			if wep:GetAttachments()[i].name == "muzzle" then
				getmuzzle = "muzzle" break
			elseif wep:GetAttachments()[i].name == "muzzleA" then
				getmuzzle = "muzzleA" break
			elseif wep:GetAttachments()[i].name == "muzzle_flash" then
				getmuzzle = "muzzle_flash" break
			elseif wep:GetAttachments()[i].name == "muzzle_flash1" then
				getmuzzle = "muzzle_flash1" break
			elseif wep:GetAttachments()[i].name == "muzzle_flash2" then
				getmuzzle = "muzzle_flash2" break
			elseif wep:GetAttachments()[i].name == "ValveBiped.muzzle" then
				getmuzzle = "ValveBiped.muzzle" break
			else 
				getmuzzle = false
			end
		end
		if (getmuzzle == false) or getmuzzle == nil then
			if GetClassEntity:LookupBone("ValveBiped.Bip01_R_Hand") != nil then
				return GetClassEntity:GetBonePosition(GetClassEntity:LookupBone("ValveBiped.Bip01_R_Hand"))
			else
				print("WARNING: "..GetClassEntity:GetName().."'s weapon doesn't have a proper attachment or bone!")
				return GetClassEntity:EyePos()
			end
		end
		//print("It has a proper attachment.")
		return wep:GetAttachment(wep:LookupAttachment(getmuzzle)).Pos //+ GetClassEntity:GetUp()*-45
	end
end