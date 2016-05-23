/*--------------------------------------------------
	=============== Utils ===============
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to load utils for VJ Base
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end

-- Add Utils -------------------------------------------------------------------------------------------------------------------------
function util.VJ_SphereDamage(vSelfEntity,vInflictor,vAttacker,vPosition,vDamageRadius,vDamage,vDamageType,vBlockCertainEntities,vUseRealisticRadius,vUseForce,vForceRagdoll,vForcePropPhysics)
	local entities = {}
	local damageamount = vDamage
	for k, v in pairs(ents.FindInSphere(vPosition,vDamageRadius)) do -- Around it
	local enemytoself = v:NearestPoint(vPosition) -- From the enemy position to the given position
	if vUseRealisticRadius == true then
		damageamount = math.Clamp(damageamount *((vDamageRadius -vPosition:Distance(enemytoself)) +150) /vDamageRadius,vDamage/2,damageamount) -- Decrease damage from the nearest point all the way to the enemy point
	end
	if vBlockCertainEntities == true then
		if (v:IsNPC() && (v:Disposition(vSelfEntity) == 1 or v:Disposition(vSelfEntity) == 2) && v:Health() > 0 && (v != vSelfEntity) && (v:GetClass() != vSelfEntity:GetClass())) or (v:IsPlayer() && GetConVarNumber("ai_ignoreplayers") == 0 && v:Alive() && v:Health() > 0) then
		//if ((v:IsNPC() && v:Disposition(vSelfEntity) == 1 or v:Disposition(vSelfEntity) == 2) or (v:IsPlayer() && v:Alive())) && (v != vSelfEntity) && (v:GetClass() != vSelfEntity:GetClass()) then -- entity check
		if (v:GetClass() == "npc_strider" or v:GetClass() == "npc_combinedropship" or v:GetClass() == "npc_combinegunship" or v:GetClass() == "npc_helicopter") then
			v:TakeDamage(damageamount,vAttacker,vInflictor)
		else
			local doactualdmg = DamageInfo() -- DMG Code
			doactualdmg:SetDamage(damageamount)
			doactualdmg:SetAttacker(vAttacker)
			doactualdmg:SetInflictor(vInflictor)
			doactualdmg:SetDamageType(vDamageType)
			doactualdmg:SetDamagePosition(enemytoself)
			v:TakeDamageInfo(doactualdmg) -- Do the damage code
			VJ_DestroyCombineTurret(vSelfEntity,v)
			end
		end
	else
		if (v:GetClass() == "npc_strider" or v:GetClass() == "npc_combinedropship" or v:GetClass() == "npc_combinegunship" or v:GetClass() == "npc_helicopter") then
			v:TakeDamage(damageamount,vAttacker,vInflictor)
		else
			local doactualdmg = DamageInfo() -- DMG Code
			doactualdmg:SetDamage(damageamount)
			doactualdmg:SetAttacker(vAttacker)
			doactualdmg:SetInflictor(vInflictor)
			doactualdmg:SetDamageType(vDamageType)
			doactualdmg:SetDamagePosition(enemytoself)
			v:TakeDamageInfo(doactualdmg) -- Do the damage code
			VJ_DestroyCombineTurret(vSelfEntity,v)
		end
	end
	
	if v:GetClass() == "prop_physics" && (v != vSelfEntity) && (v:GetClass() != vSelfEntity:GetClass()) then
		local doactualdmg = DamageInfo() -- DMG Code
		doactualdmg:SetDamage(damageamount)
		doactualdmg:SetAttacker(vAttacker)
		doactualdmg:SetInflictor(vInflictor)
		doactualdmg:SetDamageType(vDamageType)
		doactualdmg:SetDamagePosition(enemytoself)
		v:TakeDamageInfo(doactualdmg) -- Do the damage code
	end

	if vUseForce == true then -- Force
	local phys = v:GetPhysicsObject()
	if phys:IsValid() && phys != nil && phys != NULL then
	//v:SetVelocity(v:GetUp()*100000)
	if v:GetClass() == "prop_ragdoll" then v:GetPhysicsObject():ApplyForceCenter(v:GetUp()*vForceRagdoll) else
	if v:GetClass() == "prop_physics" then v:GetPhysicsObject():ApplyForceCenter(v:GetUp()*vForcePropPhysics) end
	end
   end
  end
 end
 return entities
end
---------------------------------------------------------------------------------------------------------------------------------------------
function util.VJ_GetSNPCsWithActiveSoundTracks()
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