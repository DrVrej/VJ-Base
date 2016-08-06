/*--------------------------------------------------
	=============== Entity Stuff ===============
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to load Entity autorun codes for VJ Base
	=-=-=-= NOTES =-=-=-=
- Relationships cause lag!
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
include('autorun/vj_controls.lua')

-- NPC Weapons ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
VJ.AddNPCWeapon("VJ_Package", "weapon_citizenpackage")
VJ.AddNPCWeapon("VJ_Suitcase", "weapon_citizensuitcase")
VJ.AddNPCWeapon("VJ_AK-47", "weapon_vj_ak47")
VJ.AddNPCWeapon("VJ_M16A1", "weapon_vj_m16a1")
VJ.AddNPCWeapon("VJ_Glock17", "weapon_vj_glock17")
VJ.AddNPCWeapon("VJ_MP40", "weapon_vj_mp40")
VJ.AddNPCWeapon("VJ_Blaster", "weapon_vj_blaster")
VJ.AddNPCWeapon("VJ_AR2","weapon_vj_ar2")
VJ.AddNPCWeapon("VJ_SMG1","weapon_vj_smg1")
VJ.AddNPCWeapon("VJ_9mmPistol","weapon_vj_9mmpistol")
VJ.AddNPCWeapon("VJ_SPAS-12","weapon_vj_spas12")
VJ.AddNPCWeapon("VJ_357","weapon_vj_357")
VJ.AddNPCWeapon("VJ_FlareGun","weapon_vj_flaregun")
VJ.AddNPCWeapon("VJ_RPG","weapon_vj_rpg")

-- Add S/NPCs ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local vCat = "VJ Base"
VJ.AddNPC("VJ Test NPC","sent_vj_test",vCat)
VJ.AddNPC("VJ Test Aerial NPC","npc_vj_aerialtest",vCat)

-- Add Entities ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local vCat = "VJ Base"
VJ.AddEntity("Admin Health Kit","sent_vj_adminhealthkit","DrVrej",true,0,true,vCat)
//VJ.AddEntity("HL2 Grenade","npc_grenade_frag","DrVrej",false,50,true,vCat)
VJ.AddEntity("Fireplace","sent_vj_fireplace","DrVrej",false,0,true,vCat)
VJ.AddEntity("Wooden Board","sent_vj_board","DrVrej",false,0,true,vCat)
VJ.AddEntity("Grenade","obj_vj_grenade","DrVrej",false,0,true,vCat)
VJ.AddEntity("Flare Round","obj_vj_flareround","DrVrej",false,0,true,vCat)
//VJ.AddEntity("Supply Box","item_dynamic_resupply","DrVrej",false,0,true,vCat)
//VJ.AddEntity("Supply Crate","item_ammo_crate","DrVrej",false,0,true,vCat)
//VJ.AddEntity("Teleport Point 1","obj_vj_teleportex1","DrVrej",true,0,true,vCat)
//VJ.AddEntity("Teleport Point 2","obj_vj_teleportex2","DrVrej",true,0,true,vCat)

-- Global Functions ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function VJ_FindInCone(Position,Direction,Distance,Degrees)
	local EntitiesFound = ents.FindInSphere(Position,Distance)
	local Ret = {}
	local CosineDegrees = math.cos(math.rad(Degrees))
	for _,v in pairs(EntitiesFound) do
	if v:IsNPC() or v:IsPlayer() then
		if (Direction:Dot((v:GetPos() -Position):GetNormalized()) > CosineDegrees) then
			Ret[#Ret+1] = v
		end
	 end
	end
	return Ret
end
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function VJ_CreateSound(argent,sound,soundlevel,soundpitch,stoplatestsound,sounddsp)
	if not sound then return end
	if istable(sound) then
		if #sound < 1 then return end -- If the table is empty then end it
		sound = sound[math.random(1,#sound)]
	end
	if stoplatestsound == true then -- If stopsounds is true, then the current sound
		//if argent.CurrentSound then argent.CurrentSound:Stop() end
		if soundid then
		soundid:Stop()
		soundid = nil
		end
	end
	//print(sound)
	soundid = CreateSound(argent, sound)
	soundid:SetSoundLevel(soundlevel or 75)
	soundid:PlayEx(1,soundpitch or 100)
	if sounddsp then -- For modulation, like helmets(?)
		soundid:SetDSP(sounddsp)
	end
	argent.LastPlayedVJSound = soundid
	if argent.IsVJBaseSNPC == true then argent:OnPlayCreateSound(soundid,sound) end
	return soundid
end
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function VJ_EmitSound(argent,sound,soundlevel,soundpitch,volume,channel)
	if not sound then return end
	if istable(sound) then
		if #sound < 1 then return end -- If the table is empty then end it
		sound = sound[math.random(1,#sound)]
	end
	argent:EmitSound(sound,soundlevel,soundpitch,volume,channel)
	argent.LastPlayedVJSound = sound
	if argent.IsVJBaseSNPC == true then argent:OnPlayEmitSound(sound) end
end
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function VJ_STOPSOUND(vsoundname)
	if vsoundname then vsoundname:Stop() end
end
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function VJ_PICKRANDOMTABLE(tbl)
	if not tbl then return false end
	if !istable(tbl) then return tbl end
	if istable(tbl) then
		if #tbl < 1 then return false end -- If the table is empty then end it
		tbl = tbl[math.random(1,#tbl)]
	return tbl
	end
	return false
end
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function VJ_GetSequenceDuration(argent,actname)
	if VJ_AnimationExists(argent,actname) == false then return 0 end
	if string.find(actname, "vjges_") then actname = string.Replace(actname,"vjges_","") if argent:LookupSequence(actname) == -1 then actname = tonumber(actname) end end
	if type(actname) == "number" then return argent:SequenceDuration(argent:SelectWeightedSequence(actname)) end
	if type(actname) == "string" then if string.find(actname, "vjseq_") then actname = string.Replace(actname,"vjseq_","") end return argent:SequenceDuration(argent:LookupSequence(actname)) end
	return 0
end
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function VJ_AnimationExists(argent,actname)
	if string.find(actname, "vjges_") then actname = string.Replace(actname,"vjges_","") if argent:LookupSequence(actname) == -1 then actname = tonumber(actname) end end
	if type(actname) == "number" then
		if (argent:SelectWeightedSequence(actname) == -1 && argent:GetSequenceName(argent:SelectWeightedSequence(actname)) == "Not Found!") then 
		return false end
	end
	if type(actname) == "string" then
		if string.find(actname, "vjseq_") then actname = string.Replace(actname,"vjseq_","") end
		if argent:LookupSequence(actname) == -1 then
		return false end
	end
	return true
end
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function VJ_IsCurrentAnimation(argent,actname)
	local gotit = false
	local actname = actname or {}
	if istable(actname) then
		if #actname < 1 then return false end -- If the table is empty then end it
	else
		actname = {actname}
	end

	for k,v in ipairs(actname) do
		if type(v) == "number" then v = argent:GetSequenceName(argent:SelectWeightedSequence(v)) end
		if v == argent:GetSequenceName(argent:GetSequence()) then
			gotit = true
		end
	end
	if gotit == true then return true end
	//if actname == argent:GetSequenceName(argent:GetSequence()) then return true end
	return false
end
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function VJ_IsAlive(argent)
	return argent:Health() > 0
end
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function VJ_DestroyCombineTurret(vSelf,argent)
	if argent == NULL or argent == nil then return false end
	if argent:GetClass() == "npc_turret_floor" && !argent.VJ_TurretDestroyed then
		argent:Fire("selfdestruct", "", 0)
		local phys = argent:GetPhysicsObject()
		if phys:IsValid() && phys != nil && phys != NULL then
			if vSelf:IsNPC() == true && vSelf:GetEnemy() != nil then
				phys:EnableMotion(true)
				phys:ApplyForceCenter(vSelf:GetForward() *10000)
			else
				//if vSelf:IsPlayer() then
					phys:EnableMotion(true)
					phys:ApplyForceCenter(vSelf:GetForward() *10000)
				//end
			end
		end
		argent.VJ_TurretDestroyed = true
		return true
	end
	return false
end
-- NPC/Entity/Player Functions ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local Entity_MetaTable = FindMetaTable("Entity")
local NPC_MetaTable = FindMetaTable("NPC")
local Player_MetaTable = FindMetaTable("Player")

//NPC_MetaTable.VJ_NoTarget = false
//Player_MetaTable.VJ_NoTarget = false
//Entity_MetaTable.VJ_NoTarget = false
NPC_MetaTable.AlreadyBeingHealedByMedic = false
Player_MetaTable.AlreadyBeingHealedByMedic = false
Entity_MetaTable.AlreadyBeingHealedByMedic = false

VJ_MOVETYPE_GROUND = 1
VJ_MOVETYPE_AERIAL = 2
VJ_MOVETYPE_AQUATIC = 3 
VJ_MOVETYPE_STATIONARY = 4

//VJ_MUSIC_PLAYING = false
//VJ_MUSIC_CURRENTNPCS = {}

//NPC_MetaTable.VJ_NPC_Class = {}

//SetNetworkedBool
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function NPC_MetaTable:VJ_HasActiveWeapon()
	if self.DisableWeapons == false && self:GetActiveWeapon() != NULL then return true end
	return false
end
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function NPC_MetaTable:VJ_PlaySequence(SequenceID,PlayBackRate,Wait,WaitTime,Interruptible)
	if not SequenceID then return end
	if Interruptible == true then self.VJ_IsPlayingInterruptSequence = true self.VJ_PlayingSequence = false else self.VJ_PlayingSequence = true self.VJ_IsPlayingInterruptSequence = false end
	self:ClearSchedule()
	timer.Simple(0.2,function() if self:IsValid() then
	//print(self:SequenceDuration(SequenceID))
	if Interruptible == true then self.VJ_IsPlayingInterruptSequence = true self.VJ_PlayingSequence = false else self.VJ_PlayingSequence = true self.VJ_IsPlayingInterruptSequence = false end
	//self.vACT_StopAttacks = true
	self:ClearSchedule()
	self:StopMoving()
	if istable(SequenceID) then
		if #SequenceID < 1 then return end
		SequenceID = tostring(table.Random(SequenceID))
	end
	local animid = self:LookupSequence(SequenceID)
	self:ResetSequence(animid)
	self:ResetSequenceInfo()
	self:SetCycle(0)
	if PlayBackRate then self:SetPlaybackRate(PlayBackRate) end
	if Wait == true then
		timer.Simple(WaitTime,function() //self:SequenceDuration(animid)
		if IsValid(self) then
		self.VJ_IsPlayingInterruptSequence = false
		self.VJ_PlayingSequence = false
		//self.vACT_StopAttacks = false
		end
	 end)
	end
  end
 end)
end
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function NPC_MetaTable:VJ_TranslateWeaponActivity(ActAnim)
	if self:GetActiveWeapon():TranslateActivity(ActAnim) == -1 then return ActAnim else
	return self:GetActiveWeapon():TranslateActivity(ActAnim) end
end
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function NPC_MetaTable:VJ_SetSchedule(scheduleid)
	if self.VJ_PlayingSequence == true then return end
	self.VJ_IsPlayingInterruptSequence = false
	//if self.MovementType == VJ_MOVETYPE_AERIAL then return end
	//print(self:GetName().." - "..scheduleid)
	self:SetSchedule(scheduleid)
end
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function NPC_MetaTable:VJ_GetCurrentSchedule()
	for s = 0, LAST_SHARED_SCHEDULE-1 do
		if (self:IsCurrentSchedule(s)) then return s end
	end
	return 0
end
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function NPC_MetaTable:VJ_IsCurrentSchedule(idcheck)
	if istable(idcheck) == true then
		for k,v in ipairs(idcheck) do
		if self:IsCurrentSchedule(v) == true then
		return true end
		end
	else
		if self:IsCurrentSchedule(idcheck) == true then return true end
	end
	return false
end
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function NPC_MetaTable:VJ_GetAllParameters(PrintIt)
	local Paras = {}
	for i=0, self:GetNumPoseParameters() - 1 do
		local min, max = self:GetPoseParameterRange(i)
		if PrintIt == true then
			print(self:GetPoseParameterName(i)..' '..min.." / "..max)
		end
		table.insert(Paras,self:GetPoseParameterName(i))
	end
	return Paras
end
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function NPC_MetaTable:FaceCertainPosition(pos)
	pos = pos or Vector(0,0,0)
	local setang = Angle(0,(pos-self:GetPos()):Angle().y,0)
	self:SetAngles(setang)
	return setang
end
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function NPC_MetaTable:FaceCertainEntity(argent,OnlyIfSeenEnemy,FaceEnemyTime)
	if GetConVarNumber("ai_disabled") == 1 then return false end
	if !IsValid(argent) then return false end
	FaceEnemyTime = FaceEnemyTime or 0
	if OnlyIfSeenEnemy == true && self:GetEnemy() != nil then
		local setangs = Angle(0,(argent:GetPos()-self:GetPos()):Angle().y,0)
		self.IsDoingFaceEnemy = true
		timer.Simple(FaceEnemyTime,function() if IsValid(self) then self.IsDoingFaceEnemy = false end end)
		self:SetAngles(setangs)
		return setangs //SetLocalAngles
	else
		self:SetAngles(Angle(0,(argent:GetPos()-self:GetPos()):Angle().y,0))
		return Angle(0,(argent:GetPos()-self:GetPos()):Angle().y,0)
	end
	return false
end
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function NPC_MetaTable:VJ_GetNearestPointToEntity(argent)
	if !IsValid(argent) then return end
	local NearestPositions = {MyPosition=Vector(0,0,0), EnemyPosition=Vector(0,0,0)}
	local Pos_Enemy, Pos_Self = argent:NearestPoint(self:GetPos() +argent:OBBCenter()), self:NearestPoint(argent:GetPos() +self:OBBCenter())
	Pos_Enemy.z, Pos_Self.z = argent:GetPos().z, self:GetPos().z
	NearestPositions.MyPosition = Pos_Self
	NearestPositions.EnemyPosition = Pos_Enemy
	//local Pos_Distance = Pos_Enemy:Distance(Pos_Self)
	return NearestPositions
end
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function NPC_MetaTable:VJ_GetNearestPointToEntityDistance(argent,OnlySelfGetPos)
	if !IsValid(argent) then return end
	OnlySelfGetPos = OnlySelfGetPos or false -- Should it only do self:GetPos() for the local entity?
	local Pos_Enemy = argent:NearestPoint(self:GetPos() +argent:OBBCenter())
	local Pos_Self = self:NearestPoint(argent:GetPos() +self:OBBCenter())
	if OnlySelfGetPos == true then Pos_Self = self:GetPos() end
	Pos_Enemy.z, Pos_Self.z = argent:GetPos().z, self:GetPos().z
	//local Pos_Distance = Pos_Enemy:Distance(Pos_Self)
	return Pos_Enemy:Distance(Pos_Self)
end
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function NPC_MetaTable:VJ_ForwardIsHidingZone(StartPos,EndPos,AcceptWorld,SpawnTestCube)
	if self:GetEnemy() == nil then return end
	StartPos = StartPos or self:NearestPoint(self:GetPos() +self:OBBCenter())
	EndPos = EndPos or self:GetEnemy():EyePos()
	AcceptWorld = AcceptWorld or false
	SpawnTestCube = SpawnTestCube or false
	local hitent = false
	tr = util.TraceLine({
		start = StartPos,
		endpos = EndPos,
		filter = self
	})
	//print("--------------------------------------------")
	//print(tr.Entity)
	//PrintTable(tr)
	if SpawnTestCube == true then
		local nig = ents.Create("prop_dynamic") -- Run in Console: lua_run for k,v in ipairs(ents.GetAll()) do if v:GetClass() == "prop_dynamic" then v:Remove() end end
		nig:SetModel("models/hunter/blocks/cube025x025x025.mdl")
		nig:SetPos(tr.HitPos)
		nig:SetAngles(self:GetAngles())
		nig:SetColor(Color(255,0,0))
		nig:Spawn()
		nig:Activate()
		timer.Simple(3,function() if IsValid(nig) then nig:Remove() end end)
	end
	
	for k,v in ipairs(ents.FindInSphere(tr.HitPos,5)) do
		//if SpawnTestCube == true then print(v) end
		if v == self:GetEnemy() or self:Disposition(v) == 1 or self:Disposition(v) == 2 then
			hitent = true
			//if SpawnTestCube == true then print("it hit") end
		end
	end
	
	if hitent == true then return false end
	if EndPos:Distance(tr.HitPos) <= 10 then return false end
	if tr.HitWorld == true && self:GetPos():Distance(tr.HitPos) < 200 then return true end
	if /*tr.Entity == NULL or tr.Entity:IsNPC() or tr.Entity:IsPlayer() or*/ tr.Entity == self:GetEnemy() or (AcceptWorld == false && tr.HitWorld == true) then
	return false else return true end
end
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function NPC_MetaTable:VJ_CheckAllFourSides(CheckDistance)
	CheckDistance = CheckDistance or 200
	local SidesThatAreGood = {Forward=false, Backward=false, Right=false, Left=false}
	local i = 0
	for k,v in ipairs({self:GetForward(),-self:GetForward(),self:GetRight(),-self:GetRight()}) do
		i = i +1
		tr = util.TraceLine({
			start = self:GetPos() +self:OBBCenter(),
			endpos = self:GetPos() +self:OBBCenter() +v *CheckDistance,
			filter = self
		})
		if self:GetPos():Distance(tr.HitPos) >= CheckDistance then
			if i == 1 then SidesThatAreGood.Forward = true end
			if i == 2 then SidesThatAreGood.Backward = true end
			if i == 3 then SidesThatAreGood.Right = true end
			if i == 4 then SidesThatAreGood.Left = true  end
		end
	end
	return SidesThatAreGood
end
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function NPC_MetaTable:VJ_DoPlayerFlashLightCheck(argent,lookang)
	if argent:IsPlayer() && argent:FlashlightIsOn() == true && (argent:GetForward():Dot((self:GetPos() -argent:GetPos()):GetNormalized()) > math.cos(math.rad(lookang))) then
		return true else return false
	end
	return false
end
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function NPC_MetaTable:VJ_GetEnemy(CheckForController)
	CheckForController = CheckForController or false
	if CheckForController == true && self.VJ_IsBeingControlled == true then return 1 end
	return self:GetEnemy()
end
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function NPC_MetaTable:VJ_DoSetEnemy(argent,ShouldStopActs,DoSmallWhenActiveEnemy)
	if !IsValid(argent) then return end
	if argent:Health() <= 0 then return end
	if argent:IsPlayer() && (!argent:Alive() or GetConVarNumber("ai_ignoreplayers") == 1) then return end
	DoSmallWhenActiveEnemy = DoSmallWhenActiveEnemy or false
	if IsValid(self.Medic_CurrentEntToHeal) && self.Medic_CurrentEntToHeal == argent then self:DoMedicCode_Reset() end
	if DoSmallWhenActiveEnemy == true && self:GetEnemy() != nil then
		self:AddEntityRelationship(argent,D_HT,99)
		//self:SetEnemy(argent)
		self.MyEnemy = argent
		self:UpdateEnemyMemory(argent,argent:GetPos())
	else
		self.NextResetEnemyT = CurTime() + 0.5 //2
		self:AddEntityRelationship(argent,D_HT,99)
		self:SetEnemy(argent)
		self.MyEnemy = argent
		self:UpdateEnemyMemory(argent,argent:GetPos())
		if ShouldStopActs == true then
			self:ClearGoal()
			self:StopMoving()
		end
		if self.Alerted == false then
			self:DoAlert()
			self.NextChaseTime = self.NextChaseTime + self.NextChaseTimeOnSetEnemy
			timer.Simple(self.NextChaseTimeOnSetEnemy,function()
				if IsValid(self) then
					self:DoChaseAnimation()
				end
			end)
		end
	end
end
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function NPC_MetaTable:DecideAttackTimer(Timer1,Timer2)
	if isnumber(Timer2) then
		return math.Rand(Timer1,Timer2)
	end
	return Timer1
end
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function NPC_MetaTable:VJ_DoSelectDifficulty()
	if GetConVarNumber("vj_npc_dif_easy") == 1 then self.SelectedDifficulty = 0 return 0 end -- Easy
	if GetConVarNumber("vj_npc_dif_normal") == 1 then self.SelectedDifficulty = 1 return 1 end -- Normal
	if GetConVarNumber("vj_npc_dif_hard") == 1 then self.SelectedDifficulty = 2 return 2 end -- Hard
	if GetConVarNumber("vj_npc_dif_hellonearth") == 1 then self.SelectedDifficulty = 3 return 3 end -- Hell On Earth
	return false
end
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*function NPC_MetaTable:VJ_StopSoundTable(tbl)
	if not tbl then return end
	if istable(tbl) then
	for k, v in ipairs(tbl) do
		if string.find(tostring(self.CurrentSound), v) then self.CurrentSound:Stop() end
		end
	end
end*/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Broken, don't use!
/*function NPC_MetaTable:VJ_IsPlayingSoundFromTable(tbl) -- Get whether if a sound is playing from a certain table
	if not tbl then return false end
	if istable(tbl) then
	for k, v in ipairs(tbl) do
		if string.find(tostring(self.CurrentSound), v) then
		return true end
		end
	end
	return false
end*/

-- Hooks ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("ScaleNPCDamage", "VJ_ScaleHitGroupHook",function(ent,hitgroup,dmginfo)
	//print(hitgroup)
	//print(ent)
	ent.VJ_ScaleHitGroupDamage = hitgroup
end) 
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*if SERVER then
local function VJShouldCollideHook( ent1, ent2 )
	if ent1:vj_NoCollide(ent2) == false then return false end
end
hook.Add( "ShouldCollide", "VJShouldCollideHook", VJShouldCollideHook )
end*/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*local function VJ_NPC_THEMEMUSIC(data,Entity,SoundName)
	//print("regular code running")
		local vjanimalcleanup = ents.FindByClass("npc_vjanimal_*")
		local cleandatsnpc = ents.FindByClass("npc_vj_*")
		table.Add(cleandatsnpc,vjanimalcleanup)
		for _, x in pairs(cleandatsnpc,vjanimalcleanup) do
		if x == data.Entity then
		//x:VJ_STOPSOUND(x.Theme)
		//print("IT WORKED!")
	return false
	end end
end
hook.Add("EntityEmitSound","VJ_NPC_THEMEMUSIC",VJ_NPC_THEMEMUSIC)*/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*local function VJ_NPC_ENTITYSOUND(data,Entity,SoundName)
	PrintTable(data)
end
hook.Add("EntityEmitSound","VJ_NPC_ENTITYSOUND",VJ_NPC_ENTITYSOUND)*/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
local function VJ_NPC_FIREBULLET(Entity,data,Attacker)
	//print(Entity)
	if IsValid(Entity) && !Entity:IsPlayer() && Entity.IsVJBaseSNPC == true && Entity:GetActiveWeapon() != NULL && Entity:VJ_GetEnemy(true) != nil then
		local GetCurrentWeapon = Entity:GetActiveWeapon()
		local EnemyDistance = 100
		if Entity.VJ_IsBeingControlled == true then
		EnemyDistance = Entity:GetPos():Distance(Entity.VJ_TheController:GetEyeTrace().HitPos) else
		EnemyDistance = Entity:GetPos():Distance(Entity:GetEnemy():GetPos()) end
		//GetCurrentWeapon:SetClip1(GetCurrentWeapon:Clip1() -1)
		//PrintTable(data)
		//data.Callback = function(tr)
		//print(tr)
		//if tr.Entity:GetClass() == "prop_ragdoll" then
		//print(tr.Entity) end
		//end
		if Entity.VJ_IsBeingControlled == false then
			data.Src = util.VJ_GetWeaponPos(Entity)
		elseif Entity.VJ_IsBeingControlled == true && IsValid(Entity.VJ_TheController) then
			data.Src = Entity.VJ_TheController:GetShootPos()
		end
		//if Entity:GetEnemy():GetHullType() == HULL_TINY then
		//data.Spread = Vector(25,25,0) else
		if Entity.VJ_IsBeingControlled == false then
			local fSpread = ((EnemyDistance/23)*Entity.WeaponSpread)
			if GetCurrentWeapon.IsVJBaseWeapon == true && GetCurrentWeapon.NPC_AllowCustomSpread == true then fSpread = fSpread *GetCurrentWeapon.NPC_CustomSpread end
			data.Spread = Vector(fSpread,fSpread,0)
			/*if EnemyDistance < 400 then
			//self:CapabilitiesRemove(CAP_AIM_GUN)
			data.Spread = Vector(30,30,0) else //end //Entity:GetEnemy():GetPos()
			if EnemyDistance < 600 && EnemyDistance > 400 then
			data.Spread = Vector(40,40,0) else
			data.Spread = Vector(Entity.WeaponSpread,Entity.WeaponSpread,0) end end*/
		elseif Entity.VJ_IsBeingControlled == true && IsValid(Entity.VJ_TheController) then
			//data.Spread = Vector(1,1,0)
		end
		if Entity.VJ_IsBeingControlled == false then
			//data.Dir =		Entity:GetEnemy():GetPos()-(Entity:GetEnemy():OBBMaxs():Distance(Entity:GetEnemy():OBBMins())/2)
			//if GetCurrentWeapon:GetClass() != "weapon_shotgun" or GetCurrentWeapon:GetClass() != "weapon_annabelle" then
			if Entity:GetEnemy():IsNPC() then
			-- Very old System
			//if Entity:GetEnemy():GetHullType() == HULL_TINY then
				//data.Dir = (Entity:GetEnemy():GetPos()+Entity:GetEnemy():GetUp()*-50)-Entity:GetPos() else
				//data.Dir = (Entity:GetEnemy():GetPos()+Entity:GetEnemy():GetUp()*-20)-Entity:GetPos()
			//end
			data.Dir = (Entity:GetEnemy():GetPos()+Entity:GetEnemy():OBBCenter()+Entity:GetEnemy():GetUp()*-45) -Entity:GetPos()+Entity:OBBCenter()+Entity:GetEnemy():GetUp()*-45
			-- Just a test
			//data.Dir = (Entity:GetEnemy():GetPos()+Entity:GetEnemy():GetUp()*-50) -Entity:GetPos()
			end
			if Entity:GetEnemy():IsPlayer() then
			//if GetCurrentWeapon:GetClass() != "weapon_shotgun" then
			data.Dir = (Entity:GetEnemy():GetPos()+Entity:GetEnemy():OBBCenter()+Entity:GetEnemy():GetUp()*-45) -Entity:GetPos() end
		elseif Entity.VJ_IsBeingControlled == true && IsValid(Entity.VJ_TheController) then
			data.Dir = Entity.VJ_TheController:GetAimVector()
		end
		
		/*data.Callback = function(attacker, tr, dmginfo)
			local laserhit = EffectData()
			laserhit:SetOrigin(tr.HitPos)
			laserhit:SetNormal(tr.HitNormal)
			laserhit:SetScale(80)
			util.Effect("effect_fo3_laserhit", laserhit)
			//tr.HitPos:Ignite( 8, 0 )
		return true end*/
	//	end
		//data.Src = util.VJ_GetWeaponPos(Entity) //Entity:EyePos() + Entity:GetUp()*-40
		Entity.Weapon_ShotsSinceLastReload = Entity.Weapon_ShotsSinceLastReload + 1
		//Entity.Weapon_TimeSinceLastShot = 0
		return true
	end
	//if Entity:GetClass() == "npc_vj_mili_marine" then
	//for k, v in pairs (ents.GetAll()) do
end
hook.Add("EntityFireBullets","VJ_NPC_FIREBULLET",VJ_NPC_FIREBULLET)
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
local function VJ_NPC_SPAWNED(ply,ent)
	if ent.IsVJBaseSNPC == true or ent.IsVJBaseSpawner == true then
		ent:SetCreator(ply)
	end
end
hook.Add("PlayerSpawnedNPC","VJ_NPC_SPAWNED",VJ_NPC_SPAWNED)
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
local function VJ_PLAYER_INITIALSPAWN(ply)
	for k,v in ipairs(ents.GetAll()) do
	if v.IsVJBaseSNPC == true && (v.IsVJBaseSNPC_Human == true or v.IsVJBaseSNPC_Creature == true) then
		v.CurrentPossibleEnemies = v:DoHardEntityCheck()
		end
	end
end
hook.Add("PlayerInitialSpawn","VJ_PLAYER_INITIALSPAWN",VJ_PLAYER_INITIALSPAWN)
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/* -- Obsolete! | Has many problems and doesn't solve lag
local VJ_TblNPCs = {}
local function VJ_ENTITYCREATED(entity)
	if entity:IsNPC() then
		table.insert(VJ_TblNPCs,entity)
	end
end
hook.Add("OnEntityCreated","VJ_ENTITYCREATED",VJ_ENTITYCREATED)*/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
local function VJ_ENTITYCREATED(entity)
	if (CLIENT) then return end
	if !entity:IsNPC() then return end
	timer.Simple(0.15,function()
	if IsValid(entity) then
	for k,v in ipairs(ents.GetAll()) do
	if IsValid(v) && v.IsVJBaseSNPC == true && (v.IsVJBaseSNPC_Human == true or v.IsVJBaseSNPC_Creature == true) then
		v.CurrentPossibleEnemies = v:DoHardEntityCheck()
		end
	  end
	 end
	end)
end
hook.Add("OnEntityCreated","VJ_ENTITYCREATED",VJ_ENTITYCREATED)
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
local function VJ_NPC_TAKEDAMAGE(target,dmginfo)
	if IsValid(target) && IsValid(dmginfo:GetAttacker()) then
		if target.IsVJBaseSNPC == true && dmginfo:GetAttacker():IsNPC() && dmginfo:IsBulletDamage() && (target:Disposition(dmginfo:GetAttacker()) == 3 or target:Disposition(dmginfo:GetAttacker()) == 4) && dmginfo:GetAttacker():Disposition(target) != 1 then
			dmginfo:SetDamage(0)
		end
	end
end
hook.Add("EntityTakeDamage","VJ_NPC_TAKEDAMAGE",VJ_NPC_TAKEDAMAGE)
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
VJCorpseTbl = {}
local function VJ_NPC_CORPSELIMIT(Corpse,Owner)
	if IsValid(Corpse) then
		if Corpse.IsVJBaseCorpse == true then
			for k, v in pairs(VJCorpseTbl) do
			if !IsValid(v) or v == NULL or v == nil then table.remove(VJCorpseTbl,k) end end
			//print("Corpse Owner: "..Owner:GetName())
			table.insert(VJCorpseTbl,Corpse)
			//PrintTable(VJCorpseTbl)
			if table.Count(VJCorpseTbl) > GetConVarNumber("vj_npc_globalcorpselimit") then
				GetTheFirstKey = table.GetFirstKey(VJCorpseTbl)
				GetTheFirstValue = table.GetFirstValue(VJCorpseTbl)
				table.remove(VJCorpseTbl,GetTheFirstKey)
				if IsValid(GetTheFirstValue) && GetTheFirstValue != NULL && GetTheFirstValue != nil then
				GetTheFirstValue:Fire(GetTheFirstValue.FadeCorpseType, "", 0.5)
				timer.Simple(1, function() if IsValid(GetTheFirstValue) then GetTheFirstValue:Remove() end end)
				end
			end
		end
	end
end
hook.Add("VJ_CreateSNPCCorpse","VJ_NPC_CORPSELIMIT",VJ_NPC_CORPSELIMIT)

-- Convar Call Backs ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
cvars.AddChangeCallback("ai_ignoreplayers",function(convar_name,oldValue,newValue)
	for k, v in pairs(ents.GetAll()) do
	for pk, pv in pairs(player.GetAll()) do
	if v.IsVJBaseSNPC == true then
		v:AddEntityRelationship(pv,4,10)
		if (v.IsVJBaseSNPC_Human == true or v.IsVJBaseSNPC_Creature == true) then
			v.CurrentPossibleEnemies = v:DoHardEntityCheck()
		end
	end
  end
 end
end)
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
cvars.AddChangeCallback("vj_npc_drvrejfriendly",function(convar_name,oldValue,newValue)
	//print(newValue)
	if newValue == "1" then
		//print("They no longer detect DrVrej!")
		for k,v in pairs(ents.GetAll()) do
			if game.SinglePlayer() then
			if v:IsPlayer() then
			v:SetNoTarget(true)
		end else
			if (v:IsPlayer() && v:SteamID() == "STEAM_0:0:22688298") then
			v:SetNoTarget(true)
			v.VJ_NoTarget = true
		end
	  end
	 end
	end
	if newValue == "0" then
		//print("They now detect DrVrej!")
		for k,v in pairs(ents.GetAll()) do
		if (v:IsPlayer() && v:SteamID() == "STEAM_0:0:22688298") then 
		v:SetNoTarget(false)
		v.VJ_NoTarget = false
		end
	 end
	end
end)

-- Net Messages ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
	net.Receive("vj_music_run",function(len)
		VJ_CL_MUSIC_CURRENT = VJ_CL_MUSIC_CURRENT or {}
		local ent = net.ReadEntity()
		local sdtbl = net.ReadTable()
		local sdvol = net.ReadFloat()
		local sdspeed = net.ReadFloat()
		local sdfadet = net.ReadFloat()
		local entindex = ent:EntIndex()
		sound.PlayFile("sound/"..VJ_PICKRANDOMTABLE(sdtbl),"noplay",function(soundchannel,errorID,errorName)
			if IsValid(soundchannel) then
				if table.Count(VJ_CL_MUSIC_CURRENT) <= 0 then soundchannel:Play() end
				soundchannel:EnableLooping(true)
				soundchannel:SetVolume(sdvol)
				soundchannel:SetPlaybackRate(sdspeed)
				table.insert(VJ_CL_MUSIC_CURRENT,{npc=ent,channel=soundchannel})
			end
		end)
		timer.Create("vj_music_think",1,0,function()
			//PrintTable(VJ_CL_MUSIC_CURRENT)
			for k,v in pairs(VJ_CL_MUSIC_CURRENT) do
				//PrintTable(v)
				//if v.npc == entindex then
				if !IsValid(v.npc) then
					v.channel:Stop()
					v.channel = nil
					table.remove(VJ_CL_MUSIC_CURRENT,k)
				end
			end
			if table.Count(VJ_CL_MUSIC_CURRENT) <= 0 then
				timer.Remove("vj_music_think")
				VJ_CL_MUSIC_CURRENT = {}
			else
				for k,v in pairs(VJ_CL_MUSIC_CURRENT) do
					if IsValid(v.npc) && IsValid(v.channel) then
						v.channel:Play() break
					end
				end
			end
		end)
	end)
end

if (SERVER) then
	util.AddNetworkString("vj_music_run")
end

/*if (CLIENT) then
	require("sound_vj_track")
	sound_vj_track.Add("VJ_SpiderQueenThemeMusic","vj_dm_spidermonster/Dark Messiah - Avatar of the Spider Goddess.wav",161)
end*/

-- Add Classes ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//CLASS_VJ_PLAYERFRIENDLY = 1

VJ_WalkActivites = {
	ACT_WALK,
	ACT_WALK_RELAXED,
	ACT_WALK_AGITATED,
	ACT_WALK_STEALTH,
	ACT_WALK_HURT,
	ACT_WALK_SCARED,
	ACT_WALK_ON_FIRE,
	ACT_WALK_CARRY,
	ACT_WALK_ANGRY,
	ACT_WALK_AIM,
	ACT_WALK_AIM_RELAXED,
	ACT_WALK_AIM_STIMULATED,
	ACT_WALK_AIM_AGITATED,
	ACT_WALK_AIM_STEALTH,
	ACT_WALK_CROUCH,
	ACT_WALK_CROUCH_AIM,
	ACT_WALK_PACKAGE,
	ACT_WALK_SUITCASE,
	ACT_WALK_RIFLE_RELAXED,
	ACT_WALK_RIFLE_STIMULATED,
	ACT_WALK_AIM_RIFLE_STIMULATED,
	ACT_WALK_RPG,
	ACT_WALK_CROUCH_RPG,
	ACT_WALK_RPG_RELAXED,
	ACT_WALK_RIFLE,
	ACT_WALK_AIM_RIFLE,
	ACT_WALK_CROUCH_RIFLE,
	ACT_WALK_CROUCH_AIM_RIFLE,
	ACT_WALK_AIM_SHOTGUN,
	ACT_WALK_PISTOL,
	ACT_WALK_AIM_PISTOL,
	ACT_WALK_STEALTH_PISTOL,
	ACT_WALK_AIM_STEALTH_PISTOL,
}

VJ_RunActivites = {
	ACT_RUN,
	ACT_RUN_RELAXED,
	ACT_RUN_AGITATED,
	ACT_RUN_STEALTH,
	ACT_RUN_HURT,
	ACT_RUN_SCARED,
	ACT_RUN_ON_FIRE,
	ACT_RUN_PROTECTED,
	ACT_RUN_AIM,
	ACT_RUN_AIM_RELAXED,
	ACT_RUN_AIM_STIMULATED,
	ACT_RUN_AIM_AGITATED,
	ACT_RUN_AIM_STEALTH,
	ACT_RUN_CROUCH,
	ACT_RUN_CROUCH_AIM,
	ACT_RUN_RIFLE_RELAXED,
	ACT_RUN_RIFLE_STIMULATED,
	ACT_RUN_AIM_RIFLE_STIMULATED,
	ACT_RUN_RPG,
	ACT_RUN_CROUCH_RPG,
	ACT_RUN_RPG_RELAXED,
	ACT_RUN_RIFLE,
	ACT_RUN_AIM_RIFLE,
	ACT_RUN_CROUCH_RIFLE,
	ACT_RUN_CROUCH_AIM_RIFLE,
	ACT_RUN_AIM_SHOTGUN,
	ACT_RUN_PISTOL,
	ACT_RUN_AIM_PISTOL,
	ACT_RUN_STEALTH_PISTOL,
	ACT_RUN_AIM_STEALTH_PISTOL,
}