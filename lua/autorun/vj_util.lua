/*--------------------------------------------------
	=============== Utils ===============
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
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
	------------------------
	local Finaldmg = vDamage
	local Foundents = {}
	local Findents = ents.FindInSphere(vPosition,vDamageRadius)
	if (!Findents) then return end
	for k,v in pairs(Findents) do
		if v:EntIndex() == vAttacker:EntIndex() or v:EntIndex() == vAttacker:EntIndex() then continue end
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
			if (v:IsNPC() && (v:Disposition(vAttacker) == 1 or v:Disposition(vAttacker) == 2) && v:Health() > 0 && (v != vAttacker) && (v:GetClass() != vAttacker:GetClass())) or (v:IsPlayer() && GetConVarNumber("ai_ignoreplayers") == 0 && v:Alive() && v:Health() > 0) then
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
	local getweapon = GetClassEntity:GetActiveWeapon()
	local getmuzzle
	local numattachments = getweapon:GetAttachments()
	local numattachments = #getweapon:GetAttachments()
	
	if (getweapon:IsValid()) then
	for i = 1,numattachments do
	if getweapon:GetAttachments()[i].name == "muzzle" then
		getmuzzle = "muzzle" break
	elseif getweapon:GetAttachments()[i].name == "muzzleA" then
		getmuzzle = "muzzleA" break
	elseif getweapon:GetAttachments()[i].name == "muzzle_flash" then
		getmuzzle = "muzzle_flash" break
	elseif getweapon:GetAttachments()[i].name == "muzzle_flash1" then
		getmuzzle = "muzzle_flash1" break
	elseif getweapon:GetAttachments()[i].name == "muzzle_flash2" then
		getmuzzle = "muzzle_flash2" break
	elseif getweapon:GetAttachments()[i].name == "ValveBiped.muzzle" then
		getmuzzle = "ValveBiped.muzzle" break
	else 
		getmuzzle = false
		end
	end
		if (getmuzzle == false) or getmuzzle == nil then
		print("WARNING: "..GetClassEntity:GetName().."'s weapon doesn't have a proper attachment!")
		return GetClassEntity:EyePos() end
		//print("It has a proper attachment.")
		return getweapon:GetAttachment(getweapon:LookupAttachment(getmuzzle)).Pos //+ GetClassEntity:GetUp()*-45
	end
end