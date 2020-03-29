/*--------------------------------------------------
	=============== Entity Stuff ===============
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
include('autorun/vj_controls.lua')

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Spawn Menu Creation ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- ====== NPCs ====== --
local vCat = "VJ Base"
VJ.AddNPC("VJ Test NPC","sent_vj_test",vCat)
VJ.AddNPC("Mortar Synth","npc_vj_mortarsynth",vCat)

	-- ====== Entities ====== --
VJ.AddEntity("Admin Health Kit","sent_vj_adminhealthkit","DrVrej",true,0,true,vCat)
VJ.AddEntity("Player Spawnpoint","sent_vj_ply_spawnpoint","DrVrej",true,0,true,vCat)
VJ.AddEntity("Fireplace","sent_vj_fireplace","DrVrej",false,0,true,vCat)
VJ.AddEntity("Wooden Board","sent_vj_board","DrVrej",false,0,true,vCat)
VJ.AddEntity("Grenade","obj_vj_grenade","DrVrej",false,0,true,vCat)
VJ.AddEntity("Flare Round","obj_vj_flareround","DrVrej",false,0,true,vCat)
VJ.AddEntity("Flag","prop_vj_flag","DrVrej",false,0,true,vCat)
//VJ.AddEntity("HL2 Grenade","npc_grenade_frag","DrVrej",false,50,true,vCat)
//VJ.AddEntity("Supply Box","item_dynamic_resupply","DrVrej",false,0,true,vCat)
//VJ.AddEntity("Supply Crate","item_ammo_crate","DrVrej",false,0,true,vCat)

	-- ====== NPC Weapons ====== --
//VJ.AddNPCWeapon("VJ_Package","weapon_citizenpackage")
//VJ.AddNPCWeapon("VJ_Suitcase","weapon_citizensuitcase")
VJ.AddNPCWeapon("VJ_AK-47","weapon_vj_ak47")
VJ.AddNPCWeapon("VJ_M16A1","weapon_vj_m16a1")
VJ.AddNPCWeapon("VJ_Glock17","weapon_vj_glock17")
VJ.AddNPCWeapon("VJ_MP40","weapon_vj_mp40")
VJ.AddNPCWeapon("VJ_Blaster","weapon_vj_blaster")
VJ.AddNPCWeapon("VJ_AR2","weapon_vj_ar2")
VJ.AddNPCWeapon("VJ_SMG1","weapon_vj_smg1")
VJ.AddNPCWeapon("VJ_9mmPistol","weapon_vj_9mmpistol")
VJ.AddNPCWeapon("VJ_SPAS-12","weapon_vj_spas12")
VJ.AddNPCWeapon("VJ_357","weapon_vj_357")
VJ.AddNPCWeapon("VJ_FlareGun","weapon_vj_flaregun")
VJ.AddNPCWeapon("VJ_RPG","weapon_vj_rpg")
VJ.AddNPCWeapon("VJ_K-3","weapon_vj_k3")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Global Functions ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if (SERVER) then
	util.AddNetworkString("vj_music_run")
	
	require("ai_vj_schedule")
	local getsched = ai_vj_schedule.New -- Prevent stack overflow
	function ai_vj_schedule.New(name)
		local actualsched = getsched(name)
		actualsched.Name = name
		return actualsched
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_PICKRANDOMTABLE(tbl)
	if not tbl then return false end -- Yete table pame choone meche, veratartsour false!
	if istable(tbl) then
		if #tbl < 1 then return false end -- Yete table barabe (meg en aveli kich), getsoor!
		tbl = tbl[math.random(1,#tbl)]
		return tbl
	else
		return tbl -- Yete table che, veratartsour abranke
	end
	return false
end
--------- Same ---------
function VJ_PICK(tbl)
	if not tbl then return false end -- Yete table pame choone meche, veratartsour false!
	if istable(tbl) then
		if #tbl < 1 then return false end -- Yete table barabe (meg en aveli kich), getsoor!
		tbl = tbl[math.random(1,#tbl)]
		return tbl
	else
		return tbl -- Yete table che, veratartsour abranke
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_STOPSOUND(vsoundname)
	if vsoundname then vsoundname:Stop() end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_Set(a,b) -- A set of 2 numbers: a, b
	return {a=a, b=b}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_HasValue(tbl,val)
	if !istable(tbl) then return false end
	for x=1, #tbl do
		if tbl[x] == val then
			return true
		end
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_RoundToMultiple(number,multiple) -- Credits to Bizzclaw for pointing me to the right direction!
	if math.Round(number/multiple) == number/multiple then
		return number
	else
		return math.Round(number/multiple) * multiple
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_FindInCone(Position,Direction,Distance,Degrees,Tbl_Features)
	local vTbl_Features = Tbl_Features or {}
		local vTbl_AllEntities = vTbl_Features.AllEntities or false -- Should it detect all types of entities? | False = NPCs and Players only!
	local EntitiesFound = ents.FindInSphere(Position,Distance)
	local Foundents = {}
	local CosineDegrees = math.cos(math.rad(Degrees))
	for _,v in pairs(EntitiesFound) do
	if ((vTbl_AllEntities == true) or (vTbl_AllEntities == false && (v:IsNPC() or v:IsPlayer()))) && (Direction:Dot((v:GetPos() -Position):GetNormalized()) > CosineDegrees) then
			Foundents[#Foundents+1] = v
		end
	end
	return Foundents
end
---------------------------------------------------------------------------------------------------------------------------------------------
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
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_EmitSound(argent,sound,soundlevel,soundpitch,volume,channel)
	local sd = VJ_PICK(sound)
	if sd == false then return end
	argent:EmitSound(sd,soundlevel,soundpitch,volume,channel)
	argent.LastPlayedVJSound = sd
	if argent.IsVJBaseSNPC == true then argent:OnPlayEmitSound(sd) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_AnimationExists(argent,actname)
	if actname == nil or isbool(actname) then return false end
	if string.find(actname, "vjges_") then actname = string.Replace(actname,"vjges_","") if argent:LookupSequence(actname) == -1 then actname = tonumber(actname) end end
	if type(actname) == "number" then
		if (argent:SelectWeightedSequence(actname) == -1 or argent:SelectWeightedSequence(actname) == 0) && (argent:GetSequenceName(argent:SelectWeightedSequence(actname)) == "Not Found!" or argent:GetSequenceName(argent:SelectWeightedSequence(actname)) == "No model!") then
		return false end
	end
	if type(actname) == "string" then
		if string.find(actname, "vjseq_") then actname = string.Replace(actname,"vjseq_","") end
		if argent:LookupSequence(actname) == -1 then
		return false end
	end
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_GetSequenceDuration(argent,actname)
	if VJ_AnimationExists(argent,actname) == false then return 0 end
	if string.find(actname, "vjges_") then actname = string.Replace(actname,"vjges_","") if argent:LookupSequence(actname) == -1 then actname = tonumber(actname) end end
	if type(actname) == "number" then return argent:SequenceDuration(argent:SelectWeightedSequence(actname)) end
	if type(actname) == "string" then if string.find(actname, "vjseq_") then actname = string.Replace(actname,"vjseq_","") end return argent:SequenceDuration(argent:LookupSequence(actname)) end
	return 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_GetSequenceName(argent,actname)
	if VJ_AnimationExists(argent,actname) == false then return nil end
	if string.find(actname, "vjges_") then actname = string.Replace(actname,"vjges_","") if argent:LookupSequence(actname) == -1 then actname = tonumber(actname) end end
	if type(actname) == "number" then return argent:GetSequenceName(argent:SelectWeightedSequence(actname)) end
	if type(actname) == "string" then if string.find(actname, "vjseq_") then actname = string.Replace(actname,"vjseq_","") end return argent:GetSequenceName(argent:LookupSequence(actname)) end
	return nil
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_SequenceToActivity(argent,seq)
	if type(seq) == "string" then
		local checkanim = argent:GetSequenceActivity(argent:LookupSequence(seq))
		if checkanim == nil or checkanim == -1 then
			return false
		else
			return checkanim
		end
	elseif type(seq) == "number" then
		return seq
	else
		return false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_IsCurrentAnimation(argent,actname)
	local gotit = false
	local actname = actname or {}
	if istable(actname) then
		if #actname < 1 then return false end -- If the table is empty then end it
	else
		actname = {actname}
	end

	for k,v in ipairs(actname) do
		if type(v) == "number" && v != -1 then v = argent:GetSequenceName(argent:SelectWeightedSequence(v)) end
		if v == argent:GetSequenceName(argent:GetSequence()) then
			gotit = true
		end
	end
	if gotit == true then return true end
	//if actname == argent:GetSequenceName(argent:GetSequence()) then return true end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_IsProp(argent)
	if argent:GetClass() == "prop_physics" or argent:GetClass() == "prop_physics_multiplayer" or argent:GetClass() == "prop_physics_respawnable" then return true end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_IsAlive(argent)
	if argent.Dead == true then return false end
	return argent:Health() > 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_DestroyCombineTurret(vSelf,argent)
	if !IsValid(argent) then return false end
	if argent:GetClass() == "npc_turret_floor" && !argent.VJ_TurretDestroyed then
		argent:Fire("selfdestruct", "", 0)
		local phys = argent:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableMotion(true)
			phys:ApplyForceCenter(vSelf:GetForward() *10000)
		end
		argent.VJ_TurretDestroyed = true
		return true
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_Color2Byte(color)
	return bit.lshift(math.floor(color.r*7/255),5)+bit.lshift(math.floor(color.g*7/255),2)+math.floor(color.b*3/255)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_Color8Bit2Color(bits)
	return Color(bit.rshift(bits,5)*255/7,bit.band(bit.rshift(bits,2),0x07)*255/7,bit.band(bits,0x03)*255/3)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_CreateTestObject(pos,ang,color,rtime,mdl)
	local ang = ang or Angle(0,0,0)
	local color = color or Color(255,0,0)
	local rtime = rtime or 3
	local mdl = mdl or "models/hunter/blocks/cube025x025x025.mdl"
	local obj = ents.Create("prop_dynamic")
	obj:SetModel(mdl)
	obj:SetPos(pos)
	obj:SetAngles(ang)
	obj:SetColor(color)
	obj:Spawn()
	obj:Activate()
	timer.Simple(rtime,function() if IsValid(obj) then obj:Remove() end end)
	return obj
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ NPC / Player Functions ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local NPC_MetaTable = FindMetaTable("NPC")
local Player_MetaTable = FindMetaTable("Player")
local Entity_MetaTable = FindMetaTable("Entity")

//NPC_MetaTable.VJ_NoTarget = false
//Player_MetaTable.VJ_NoTarget = false
NPC_MetaTable.AlreadyBeingHealedByMedic = false
Player_MetaTable.AlreadyBeingHealedByMedic = false

//NPC_MetaTable.VJ_NPC_Class = {}
---------------------------------------------------------------------------------------------------------------------------------------------
function NPC_MetaTable:VJ_Controller_InitialMessage(ply)
	if !IsValid(ply) then return end
	if self.IsVJBaseSNPC == true then
		if self.IsVJBaseSNPC_Creature then
			ply:ChatPrint("=-=-=-= Default Controls (May differ between NPCs!) =-=-=-=")
			ply:ChatPrint("MOUSE1: Melee Attack | MOUSE2: Range Attack")
			ply:ChatPrint("JUMP: Leap Attack")
			ply:ChatPrint("=-=-=-= Custom Controls (Written by the developers) =-=-=-=")
		elseif self.IsVJBaseSNPC_Human == true then
			ply:ChatPrint("=-=-=-= Default Controls (May differ between NPCs!) =-=-=-=")
			ply:ChatPrint("MOUSE1: Melee Attack | MOUSE2: Weapon Attack")
			ply:ChatPrint("JUMP: Grenade Attack | RELOAD: Reload Weapon")
			ply:ChatPrint("=-=-=-= Custom Controls (Written by the developers) =-=-=-=")
		//else
			-- None...
		end
		self:Controller_IntMsg(ply)
	//else
		-- None...
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function NPC_MetaTable:VJ_HasNoTarget(argent)
	if argent:GetClass() == "obj_vj_bullseye" && (argent.EnemyToIndividual == true) && (argent.EnemyToIndividualEnt == self) then
		return false, "Bullseye"
	end
	if (argent.VJ_NoTarget == true) or (argent:IsFlagSet(FL_NOTARGET) == true) then
		return true, ""
	else
		return false, ""
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function NPC_MetaTable:VJ_DecideSoundPitch(Pitch1,Pitch2)
	//if pitch1 == nil then return end
	local getpitch1 = self.GeneralSoundPitch1
	local getpitch2 = self.GeneralSoundPitch2
	local picknum = self.UseTheSameGeneralSoundPitch_PickedNumber
	if self.UseTheSameGeneralSoundPitch == true && picknum != 0 then
		getpitch1 = picknum
		getpitch2 = picknum
	end
	if Pitch1 != "UseGeneralPitch" && isnumber(Pitch1) then getpitch1 = Pitch1 end
	if Pitch2 != "UseGeneralPitch" && isnumber(Pitch2) then getpitch2 = Pitch2 end
	return math.random(getpitch1,getpitch2)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function NPC_MetaTable:DecideAnimationLength(Anim,Value,Decrease)
	local result = 0
	Decrease = Decrease or 0
	if isbool(Anim) then return result end
	if Value == false then -- Used internally by the base, recommanded to just leave it to false
		result = VJ_GetSequenceDuration(self,Anim) - Decrease
	elseif isnumber(Value) then
		result = Value
	end
	return result
end
---------------------------------------------------------------------------------------------------------------------------------------------
function NPC_MetaTable:VJ_PlaySequence(SequenceID,PlayBackRate,Wait,WaitTime,Interruptible)
	if not SequenceID then return end
	if Interruptible == true then self.VJ_IsPlayingInterruptSequence = true self.VJ_PlayingSequence = false else self.VJ_PlayingSequence = true self.VJ_IsPlayingInterruptSequence = false end
	//self:ClearSchedule()
	//timer.Simple(0.2,function()
		//if IsValid(self) then
			//print(self:SequenceDuration(SequenceID))
			//if Interruptible == true then self.VJ_IsPlayingInterruptSequence = true self.VJ_PlayingSequence = false else self.VJ_PlayingSequence = true self.VJ_IsPlayingInterruptSequence = false end
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
		//end
	//end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function NPC_MetaTable:VJ_TranslateWeaponActivity(ActAnim)
	if !IsValid(self:GetActiveWeapon()) or self:GetActiveWeapon().IsVJBaseWeapon != true then return ActAnim end
	if self:GetActiveWeapon():TranslateActivity(ActAnim) == -1 then return ActAnim else
	return self:GetActiveWeapon():TranslateActivity(ActAnim) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function NPC_MetaTable:VJ_GetAllPoseParameters(prt)
	local result = {}
	local prt = prt or false
	for i = 0, self:GetNumPoseParameters() - 1 do
		local min, max = self:GetPoseParameterRange(i)
		if prt == true then
			print(self:GetPoseParameterName(i)..' '..min.." / "..max)
		end
		table.insert(result,self:GetPoseParameterName(i))
	end
	return result
end
---------------------------------------------------------------------------------------------------------------------------------------------
function NPC_MetaTable:VJ_ReturnAngle(ang)
	if self.TurningUseAllAxis == true then
		return Angle(ang.x, ang.y, ang.z)
	end
	return Angle(0, ang.y, 0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function NPC_MetaTable:FaceCertainPosition(pos)
	pos = pos or Vector(0,0,0)
	local setang = Angle(0,(pos-self:GetPos()):Angle().y,0)
	self:SetAngles(setang)
	return setang
end
---------------------------------------------------------------------------------------------------------------------------------------------
function NPC_MetaTable:FaceCertainEntity(argent,OnlyIfSeenEnemy,FaceEnemyTime)
	if !IsValid(argent) or GetConVarNumber("ai_disabled") == 1 then return false end
	if self.MovementType == VJ_MOVETYPE_STATIONARY && self.CanTurnWhileStationary == false then return false end
	FaceEnemyTime = FaceEnemyTime or 0
	if OnlyIfSeenEnemy == true && IsValid(self:GetEnemy()) then
		local setangs = self:VJ_ReturnAngle((argent:GetPos()-self:GetPos()):Angle())
		self.IsDoingFaceEnemy = true
		timer.Simple(FaceEnemyTime,function() if IsValid(self) then self.IsDoingFaceEnemy = false end end)
		self:SetAngles(setangs)
		return setangs //SetLocalAngles
	else
		local setangs = self:VJ_ReturnAngle((argent:GetPos()-self:GetPos()):Angle())
		self:SetAngles(setangs)
		return setangs
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function NPC_MetaTable:VJ_GetNearestPointToVector(pos,SameZ)
	local SameZ = SameZ or false -- Should the Z of the pos be the same as the NPC's?
	local NearestPositions = {MyPosition=Vector(0,0,0), PointPosition=Vector(0,0,0)}
	local Pos_Point, Pos_Self = pos, self:NearestPoint(pos +self:OBBCenter())
	Pos_Point.z, Pos_Self.z = pos.z, self:GetPos().z
	if SameZ == true then Pos_Point.z = self:GetPos().z end
	NearestPositions.MyPosition = Pos_Self
	NearestPositions.PointPosition = Pos_Point
	return NearestPositions
end
---------------------------------------------------------------------------------------------------------------------------------------------
function NPC_MetaTable:VJ_GetNearestPointToEntity(argent,SameZ)
	if !IsValid(argent) then return end
	local SameZ = SameZ or false -- Should the Z of the pos be the same as the NPC's?
	local NearestPositions = {MyPosition=Vector(0,0,0), EnemyPosition=Vector(0,0,0)}
	local Pos_Enemy, Pos_Self = argent:NearestPoint(self:SetNearestPointToEntityPosition() + argent:OBBCenter()), self:NearestPoint(argent:GetPos() + self:OBBCenter())
	Pos_Enemy.z, Pos_Self.z = argent:GetPos().z, self:SetNearestPointToEntityPosition().z
	if SameZ == true then
		Pos_Enemy = Vector(Pos_Enemy.x,Pos_Enemy.y,self:SetNearestPointToEntityPosition().z)
		Pos_Self = Vector(Pos_Self.x,Pos_Self.y,self:SetNearestPointToEntityPosition().z)
	end
	NearestPositions.MyPosition = Pos_Self
	NearestPositions.EnemyPosition = Pos_Enemy
	//local Pos_Distance = Pos_Enemy:Distance(Pos_Self)
	return NearestPositions
end
---------------------------------------------------------------------------------------------------------------------------------------------
function NPC_MetaTable:VJ_GetNearestPointToEntityDistance(argent,OnlySelfGetPos)
	if !IsValid(argent) then return end
	OnlySelfGetPos = OnlySelfGetPos or false -- Should it only do its self position for the local entity?
	local Pos_Enemy = argent:NearestPoint(self:SetNearestPointToEntityPosition() + argent:OBBCenter())
	local Pos_Self = self:NearestPoint(argent:GetPos() + self:OBBCenter())
	if OnlySelfGetPos == true then Pos_Self = self:SetNearestPointToEntityPosition() end
	Pos_Enemy.z, Pos_Self.z = argent:GetPos().z, self:SetNearestPointToEntityPosition().z
	//local Pos_Distance = Pos_Enemy:Distance(Pos_Self)
	return Pos_Enemy:Distance(Pos_Self) // math.Distance(Pos_Enemy.x,Pos_Enemy.y,Pos_Self.x,Pos_Self.y)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function NPC_MetaTable:VJ_ForwardIsHidingZone(StartPos,EndPos,AcceptWorld,Tbl_Features)
	if !IsValid(self:GetEnemy()) then return false end
	StartPos = StartPos or self:NearestPoint(self:GetPos() + self:OBBCenter())
	EndPos = EndPos or self:GetEnemy():EyePos()
	AcceptWorld = AcceptWorld or false
	local vTbl_Features = Tbl_Features or {}
		local vTbl_SetLastHiddenTime = vTbl_Features.SetLastHiddenTime or false -- Should it set the last hidden time? (Mostly used for humans)
		local vTbl_SpawnTestCube = vTbl_Features.SpawnTestCube or false -- Should it spawn a cube where the trace hit?
	local hitent = false
	tr = util.TraceLine({
		start = StartPos,
		endpos = EndPos,
		filter = self
	})
	//print("--------------------------------------------")
	//print(tr.Entity)
	//PrintTable(tr)
	if vTbl_SpawnTestCube == true then
		-- Run in Console: lua_run for k,v in ipairs(ents.GetAll()) do if v:GetClass() == "prop_dynamic" then v:Remove() end end
		local cube = ents.Create("prop_dynamic")
		cube:SetModel("models/hunter/blocks/cube025x025x025.mdl")
		cube:SetPos(tr.HitPos)
		cube:SetAngles(self:GetAngles())
		cube:SetColor(Color(255,0,0))
		cube:Spawn()
		cube:Activate()
		timer.Simple(3,function() if IsValid(cube) then cube:Remove() end end)
	end

	for k,v in ipairs(ents.FindInSphere(tr.HitPos,5)) do
		//if vTbl_SpawnTestCube == true then print(v) end
		if v == self:GetEnemy() or self:Disposition(v) == 1 or self:Disposition(v) == 2 then
			hitent = true
			//if vTbl_SpawnTestCube == true then print("it hit") end
		end
	end

	if hitent == true then if vTbl_SetLastHiddenTime == true then self.LastHiddenZoneT = 0 end return false, tr end
	if EndPos:Distance(tr.HitPos) <= 10 then if vTbl_SetLastHiddenTime == true then self.LastHiddenZoneT = 0 end return false end
	if tr.HitWorld == true && self:GetPos():Distance(tr.HitPos) < 200 then if vTbl_SetLastHiddenTime == true then self.LastHiddenZoneT = CurTime() + 20 end return true, tr end
	if /*tr.Entity == NULL or tr.Entity:IsNPC() or tr.Entity:IsPlayer() or*/ tr.Entity == self:GetEnemy() or (AcceptWorld == false && tr.HitWorld == true) then
	if vTbl_SetLastHiddenTime == true then self.LastHiddenZoneT = 0 end return false, tr else if vTbl_SetLastHiddenTime == true then self.LastHiddenZoneT = CurTime() + 20 end return true, tr end
end
---------------------------------------------------------------------------------------------------------------------------------------------
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
---------------------------------------------------------------------------------------------------------------------------------------------
function NPC_MetaTable:VJ_DoPlayerFlashLightCheck(argent,lookang)
	if argent:IsPlayer() && argent:FlashlightIsOn() == true && (argent:GetForward():Dot((self:GetPos() - argent:GetPos()):GetNormalized()) > math.cos(math.rad(lookang))) then
		return true
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function NPC_MetaTable:VJ_GetEnemy(CheckForController)
	CheckForController = CheckForController or false
	if CheckForController == true && self.VJ_IsBeingControlled == true then return 1 end
	return self:GetEnemy()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function NPC_MetaTable:VJ_DoSetEnemy(argent,ShouldStopActs,DoSmallWhenActiveEnemy)
	if !IsValid(argent) or self.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE then return end
	if argent:Health() <= 0 then return end
	if argent:IsPlayer() && (!argent:Alive() or GetConVarNumber("ai_ignoreplayers") == 1) then return end
	DoSmallWhenActiveEnemy = DoSmallWhenActiveEnemy or false
	if IsValid(self.Medic_CurrentEntToHeal) && self.Medic_CurrentEntToHeal == argent then self:DoMedicCode_Reset() end
	if DoSmallWhenActiveEnemy == true && IsValid(self:GetEnemy()) then
		self:AddEntityRelationship(argent,D_HT,99)
		//self:SetEnemy(argent)
		self:UpdateEnemyMemory(argent,argent:GetPos())
		//if self.MovementType == VJ_MOVETYPE_STATIONARY or self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then
			//self:SetEnemy(argent)
		//end
	else
		self.NextResetEnemyT = CurTime() + 0.5 //2
		self:AddEntityRelationship(argent,D_HT,99)
		self:SetEnemy(argent)
		self:UpdateEnemyMemory(argent,argent:GetPos())
		if ShouldStopActs == true then
			self:ClearGoal()
			self:StopMoving()
		end
		if self.Alerted == false then
			self:DoAlert(argent)
			/*self.NextChaseTime = self.NextChaseTime + self.NextChaseTimeOnSetEnemy
			timer.Simple(self.NextChaseTimeOnSetEnemy,function()
				if IsValid(self) then
					self:DoChaseAnimation()
				end
			end)*/
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Entity_MetaTable:CalculateProjectile(Type, StartPos, EndPos, Vel)
	if Type == "Line" then -- Suggested to disable gravity!
		return ((EndPos - StartPos):GetNormal()) * Vel
	elseif Type == "Curve" then
		-- Oknoutyoun: https://gamedev.stackexchange.com/questions/53552/how-can-i-find-a-projectiles-launch-angle
		-- Negar: https://wikimedia.org/api/rest_v1/media/math/render/svg/4db61cb4c3140b763d9480e51f90050967288397
		local result = Vector(EndPos.x - StartPos.x, EndPos.y - StartPos.y, 0) -- Verchnagan deghe
		local pos_x = result:Length()
		local pos_y = EndPos.z - StartPos.z
		local grav = physenv.GetGravity():Length()
		local sqrtcalc1 = (Vel * Vel * Vel * Vel)
		local sqrtcalc2 = grav * ((grav * (pos_x * pos_x)) + (2 * pos_y * (Vel * Vel)))
		local calcsum = sqrtcalc1 - sqrtcalc2 -- Yergou tevere aveltsour
		if calcsum < 0 then -- Yete teve nevas e, ooremen sharnage
			calcsum = math.abs(calcsum)
		end
		local angsqrt =  math.sqrt(calcsum)
		local angpos = math.atan(((Vel * Vel) + angsqrt) / (grav * pos_x))
		local angneg = math.atan(((Vel * Vel) - angsqrt) / (grav * pos_x))
		local pitch = 1
		if angpos > angneg then
			pitch = angneg -- Yete asiga angpos enes ne, aveli veregele
		else
			pitch = angpos
		end
		result.z = math.tan(pitch) * pos_x
		return result:GetNormal() * Vel
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function NPC_MetaTable:VJ_HasActiveWeapon()
	if self.DisableWeapons == false && self:GetActiveWeapon() != NULL then return true end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function NPC_MetaTable:DecideAttackTimer(Timer1,Timer2,UntilDamage,AnimDuration)
	local result = Timer1
	if Timer1 == false then
		if UntilDamage == false then -- Event-based
			result = AnimDuration
		else -- Timer-based
			result = AnimDuration - UntilDamage
		end
	end
	if isnumber(Timer2) then
		result = math.Rand(result,Timer2)
	end
	//print(result)
	return result
end
---------------------------------------------------------------------------------------------------------------------------------------------
function NPC_MetaTable:DoFormation_Diamond(ent,it,spacing)
	it = it or 0
	spacing = spacing or 50
	if it == 0 then
		ent:SetLastPosition(self:GetPos() + self:GetForward()*spacing + self:GetRight()*spacing)
	elseif it == 1 then
		ent:SetLastPosition(self:GetPos() + self:GetForward()*-spacing + self:GetRight()*spacing)
	elseif it == 2 then
		ent:SetLastPosition(self:GetPos() + self:GetForward()*spacing + self:GetRight()*-spacing)
	elseif it == 3 then
		ent:SetLastPosition(self:GetPos() + self:GetForward()*-spacing + self:GetRight()*-spacing)
	else
		ent:SetLastPosition(self:GetPos() + self:GetForward()*(spacing + (3 * it)) + self:GetRight()*(spacing + (3 * it)))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function NPC_MetaTable:VJ_DoSelectDifficulty()
	self.SelectedDifficulty = GetConVarNumber("vj_npc_difficulty")
	return self.SelectedDifficulty
end
---------------------------------------------------------------------------------------------------------------------------------------------
function NPC_MetaTable:VJ_GetDifficultyValue(int)
	if self.SelectedDifficulty == -3 then
		return math.Clamp(int - (int * 0.99),1,int)
	elseif self.SelectedDifficulty == -2 then
		return math.Clamp(int - (int * 0.75),1,int)
	elseif self.SelectedDifficulty == -1 then
		return int / 2
	elseif self.SelectedDifficulty == 0 then -- Normal
		return int
	elseif self.SelectedDifficulty == 1 then
		return int + (int * 0.5)
	elseif self.SelectedDifficulty == 2 then
		return int * 2
	elseif self.SelectedDifficulty == 3 then
		return int + (int * 1.5)
	elseif self.SelectedDifficulty == 4 then
		return int + (int * 2.5)
	elseif self.SelectedDifficulty == 5 then
		return int + (int * 3.5)
	elseif self.SelectedDifficulty == 6 then
		return int + (int * 5.0)
	end
	return int
end
---------------------------------------------------------------------------------------------------------------------------------------------
function NPC_MetaTable:VJ_SetSchedule(scheduleid)
	if self.VJ_PlayingSequence == true then return end
	self.VJ_IsPlayingInterruptSequence = false
	//if self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then return end
	//print(self:GetName().." - "..scheduleid)
	self:SetSchedule(scheduleid)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function NPC_MetaTable:VJ_GetCurrentSchedule()
	for s = 0, LAST_SHARED_SCHEDULE-1 do
		if (self:IsCurrentSchedule(s)) then return s end
	end
	return 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function NPC_MetaTable:VJ_IsCurrentSchedule(idcheck)
	if istable(idcheck) == true then
		for k,v in ipairs(idcheck) do
			if self:IsCurrentSchedule(v) == true then
				return true
			end
		end
	else
		if self:IsCurrentSchedule(idcheck) == true then return true end
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
 -- !!!!! Deprecated Function !!!!! --
/*function NPC_MetaTable:VJ_StopSoundTable(tbl)
	if not tbl then return end
	if istable(tbl) then
	for k, v in ipairs(tbl) do
		if string.find(tostring(self.CurrentSound), v) then self.CurrentSound:Stop() end
		end
	end
end*/
---------------------------------------------------------------------------------------------------------------------------------------------
 -- !!!!! Deprecated Function | Broken! !!!!! --
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
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Hooks ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("ScaleNPCDamage", "VJ_ScaleHitGroupHook", function(npc, hitgroup, dmginfo)
	//print(npc)
	//print(hitgroup)
	npc.VJ_ScaleHitGroupDamage = hitgroup
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("EntityEmitSound","VJ_NPC_ENTITYSOUND",function(data)
	local ent = data.Entity
	if IsValid(ent) then
		//PrintTable(data)
		if (SERVER) && ent:IsPlayer() && data.SoundLevel >= 75 then
			//print("---------------------------")
			//PrintTable(data)
			if string.StartWith(data.OriginalSoundName, "player/footsteps") && (ent:Crouching() or ent:KeyDown(IN_WALK)) then
				// Pamenal mi ener
			else
				ent.VJ_LastInvestigateSd = CurTime()
				local volex = 0
				if data.Volume <= 0.4 then volex = 15 end
				ent.VJ_LastInvestigateSdLevel = (data.SoundLevel * (data.Volume)) + volex
			end
		end
		if ent:IsNPC() && ent.IsVJBaseSNPC == true then
			if string.EndsWith(data.OriginalSoundName,"stepleft") or string.EndsWith(data.OriginalSoundName,"stepright") then
				return false
			end
		end
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("EntityFireBullets","VJ_NPC_FIREBULLET", function(ent,data)
	if IsValid(ent) && !ent:IsPlayer() && ent.IsVJBaseSNPC == true then
		local ret = nil
		if ent:GetActiveWeapon() != NULL && ent:VJ_GetEnemy(true) != nil then
			local Wep = ent:GetActiveWeapon()
			local ene = ent:GetEnemy()
			local EnemyDistance = 100
			if ent.VJ_IsBeingControlled == true then
				EnemyDistance = ent:GetPos():Distance(ent.VJ_TheController:GetEyeTrace().HitPos)
			else
				EnemyDistance = ent:GetPos():Distance(ene:GetPos())
			end
			//Wep:SetClip1(Wep:Clip1() -1)
			//PrintTable(data)
			//data.Callback = function(tr)
				//print(tr)
				//if tr.ent:GetClass() == "prop_ragdoll" then
				//print(tr.ent) end
			//end
			if ent.VJ_IsBeingControlled == false && Wep.IsVJBaseWeapon != true then
				data.Src = util.VJ_GetWeaponPos(ent)
			elseif ent.VJ_IsBeingControlled == true && IsValid(ent.VJ_TheController) then
				data.Src = ent.VJ_TheController:GetShootPos()
			end
			//if ene:GetHullType() == HULL_TINY then
			//data.Spread = Vector(25,25,0) else
			if ent.VJ_IsBeingControlled == false then
				local fSpread = (EnemyDistance/28) * ent.WeaponSpread
				if Wep.IsVJBaseWeapon == true && Wep.NPC_AllowCustomSpread == true then fSpread = fSpread * Wep.NPC_CustomSpread end
				//fSpread = math.Clamp(fSpread,1,65)
				data.Spread = Vector(fSpread,fSpread,0)
				/*if EnemyDistance < 400 then
				//self:CapabilitiesRemove(CAP_AIM_GUN)
				data.Spread = Vector(30,30,0) else //end //ene:GetPos()
				if EnemyDistance < 600 && EnemyDistance > 400 then
				data.Spread = Vector(40,40,0) else
				data.Spread = Vector(ent.WeaponSpread,ent.WeaponSpread,0) end end*/
			elseif ent.VJ_IsBeingControlled == true && IsValid(ent.VJ_TheController) then
				//data.Spread = Vector(1,1,0)
			end
			if ent.VJ_IsBeingControlled == false then
				//data.Dir =		ene:GetPos()-(ene:OBBMaxs():Distance(ene:OBBMins())/2)
				//if Wep:GetClass() != "weapon_shotgun" or Wep:GetClass() != "weapon_annabelle" then
				//if ene:IsNPC() then
				-- Very old System
				//if ene:GetHullType() == HULL_TINY then
					//data.Dir = (ene:GetPos()+ene:GetUp()*-50)-ent:GetPos() else
					//data.Dir = (ene:GetPos()+ene:GetUp()*-20)-ent:GetPos()
				//end
				//data.Dir = (ene:GetPos()+ene:OBBCenter()+ene:GetUp()*-45) -ent:GetPos()+ent:OBBCenter()+ene:GetUp()*-45
				if ent.WeaponUseEnemyEyePos == true then
					data.Dir = (ene:EyePos()+ene:GetUp()*-5)-data.Src
				else
					data.Dir = (ene:GetPos()+ene:OBBCenter())-data.Src
				end
				ent.WeaponUseEnemyEyePos = false
				-- Just a test
				//data.Dir = (ene:GetPos()+ene:GetUp()*-50) -ent:GetPos()
				//end
				//if ene:IsPlayer() then
				//if Wep:GetClass() != "weapon_shotgun" then
				//data.Dir = (ene:GetPos()+ene:OBBCenter()+ene:GetUp()*-45) -ent:GetPos() end
			elseif ent.VJ_IsBeingControlled == true && IsValid(ent.VJ_TheController) then
				data.Dir = ent.VJ_TheController:GetAimVector()
			end
			/*data.Callback = function(attacker, tr, dmginfo)
				local laserhit = EffectData()
				laserhit:SetOrigin(tr.HitPos)
				laserhit:SetNormal(tr.HitNormal)
				laserhit:SetScale(80)
				util.Effect("effect_fo3_laserhit", laserhit)
				//tr.HitPos:Ignite( 8, 0 )
			return true end*/
			//end
			//data.Src = util.VJ_GetWeaponPos(ent) //ent:EyePos() + ent:GetUp()*-40
			if Wep.IsVJBaseWeapon == true then
				ent.Weapon_ShotsSinceLastReload = ent.Weapon_ShotsSinceLastReload + 1
				//Wep:SetClip1(ent.Weapon_StartingAmmoAmount - ent.Weapon_ShotsSinceLastReload)
			end
			//ent.Weapon_TimeSinceLastShot = 0
			ret = true
		end
		if ent.IsVJBaseSNPC == true then
			ent:OnFireBullet(ent,data)
		end
		if ret == true then return true end
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("Initialize","VJ_Initialize",function()
	RunConsoleCommand("sv_pvsskipanimation", "0") -- Fix attachments, bones, positions, angles etc. being broken in NPCs!
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerSpawnedNPC","VJ_NPC_SPAWNED",function(ply,ent)
	if ent.IsVJBaseSNPC == true or ent.IsVJBaseSpawner == true then
		ent:SetCreator(ply)
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerInitialSpawn","VJ_PLAYER_INITIALSPAWN",function(ply)
	if IsValid(ply) then
		ply.VJ_LastInvestigateSd = 0
		ply.VJ_LastInvestigateSdLevel = 0
		local EntsTbl = ents.GetAll()
		for x=1, #EntsTbl do
			local v = EntsTbl[x]
			if v:IsNPC() && v.IsVJBaseSNPC == true && (v.IsVJBaseSNPC_Human == true or v.IsVJBaseSNPC_Creature == true) then
				v.CurrentPossibleEnemies[#v.CurrentPossibleEnemies+1] = ply
			end
		end
	end
	/*local getall = ents.GetAll()
	for k,v in ipairs(getall) do
		v.VJ_LastInvestigateSd = 0
		v.VJ_LastInvestigateSdLevel = 0
		if v.IsVJBaseSNPC == true && (v.IsVJBaseSNPC_Human == true or v.IsVJBaseSNPC_Creature == true) then
			v.CurrentPossibleEnemies = v:DoHardEntityCheck(getall)
		end
	end*/
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerSelectSpawn","VJ_PLAYER_SELECTSPAWN",function(ply)
	local points = {}
	for k,v in ipairs(ents.FindByClass("sent_vj_ply_spawnpoint")) do
		if (v.Active == true) then
			points[#points+1] = v
		end
	end
	local result = VJ_PICK(points)
	if result != false then
		return result
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PhysgunPickup","VJ_PLAYER_PHYSGUN_PICKUP",function(ply,ent)
	if ent:GetClass() == "sent_vj_ply_spawnpoint" then
		if ply:IsAdmin() then
			return true
		else
			return false
		end
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
/* -- Obsolete! | Has many problems and doesn't solve lag
local VJ_TblNPCs = {}
local function VJ_ENTITYCREATED(entity)
	if entity:IsNPC() then
		table.insert(VJ_TblNPCs,entity)
	end
end
hook.Add("OnEntityCreated","VJ_ENTITYCREATED",VJ_ENTITYCREATED)*/
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("OnEntityCreated","VJ_ENTITYCREATED",function(entity)
	if (CLIENT) or !entity:IsNPC() then return end
	if (entity:IsNPC() && entity:GetClass() != "npc_grenade_frag" && entity:GetClass() != "bullseye_strider_focus" && entity:GetClass() != "npc_bullseye" && entity:GetClass() != "npc_enemyfinder" && entity:GetClass() != "hornet" && (!entity.IsVJBaseSNPC_Animal)) or (entity:IsPlayer() && GetConVarNumber("ai_ignoreplayers") == 0) then
		timer.Simple(0.1,function()
			if IsValid(entity) then
				if entity.CurrentPossibleEnemies == nil then entity.CurrentPossibleEnemies = {} end
				local EntsTbl = ents.GetAll()
				local count = 1
				for x=1, #EntsTbl do
					if !EntsTbl[x]:IsNPC() && !EntsTbl[x]:IsPlayer() then continue end
					
					local v = EntsTbl[x]
					if entity.IsVJBaseSNPC == true then
						entity:EntitiesToNoCollideCode(v)
						if (v:IsNPC() && (v:GetClass() != entity:GetClass() && v:GetClass() != "npc_grenade_frag" && v:GetClass() != "bullseye_strider_focus" && v:GetClass() != "npc_bullseye" && v:GetClass() != "npc_enemyfinder" && v:GetClass() != "hornet" && (!v.IsVJBaseSNPC_Animal) && (v.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE)) && v:Health() > 0) or (v:IsPlayer() && GetConVarNumber("ai_ignoreplayers") == 0 /*&& v:Alive()*/) then
							entity.CurrentPossibleEnemies[count] = v
							count = count + 1
						end
					end
	
					if v != entity && entity:GetClass() != v:GetClass() && v.IsVJBaseSNPC == true && (v.IsVJBaseSNPC_Human == true or v.IsVJBaseSNPC_Creature == true) && (entity:IsNPC() && entity:Health() > 0 && (entity.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE)) or (entity:IsPlayer()) then
						v.CurrentPossibleEnemies[#v.CurrentPossibleEnemies+1] = entity //v.CurrentPossibleEnemies = v:DoHardEntityCheck(getall)
					end
				end
			end
		end)
	end
	/*if entity:GetClass() != "npc_grenade_frag" && entity:GetClass() != "bullseye_strider_focus" && entity:GetClass() != "npc_bullseye" && entity:GetClass() != "npc_enemyfinder" && entity:GetClass() != "hornet" then
		timer.Simple(0.15,function()
			if IsValid(entity) then
				local getall = ents.GetAll()
				for k,v in pairs(getall) do
					if IsValid(v) && v != entity && v.IsVJBaseSNPC == true && (v.IsVJBaseSNPC_Human == true or v.IsVJBaseSNPC_Creature == true) then
						v.CurrentPossibleEnemies = v:DoHardEntityCheck(getall)
					end
				end
			end
		end)
	end*/
end)
---------------------------------------------------------------------------------------------------------------------------------------------
local function VJ_NPCPLY_DEATH(npc,attacker,inflictor)
	if attacker.IsVJBaseSNPC == true && (attacker.IsVJBaseSNPC_Human == true or attacker.IsVJBaseSNPC_Creature == true) then
		attacker:DoKilledEnemy(npc,attacker,inflictor)
	end
end
local function VJ_PLY_DEATH(victim,inflictor,attacker) VJ_NPCPLY_DEATH(victim,attacker,inflictor) end -- Arguments are flipped between the hooks for some reason...
hook.Add("OnNPCKilled","VJ_NPC_DEATH",VJ_NPCPLY_DEATH)
hook.Add("PlayerDeath","VJ_PLY_DEATH",VJ_PLY_DEATH)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("EntityTakeDamage","VJ_NPC_TAKEDAMAGE",function(target,dmginfo)
	if IsValid(target) && IsValid(dmginfo:GetAttacker()) then
		if target.IsVJBaseSNPC == true && dmginfo:GetAttacker():IsNPC() && dmginfo:IsBulletDamage() && (dmginfo:GetAttacker():GetClass() == target:GetClass() or target:Disposition(dmginfo:GetAttacker()) == 3 /*or target:Disposition(dmginfo:GetAttacker()) == 4*/) && dmginfo:GetAttacker():Disposition(target) != 1 then
			dmginfo:SetDamage(0)
		end
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
VJCorpseTbl = {}
hook.Add("VJ_CreateSNPCCorpse","VJ_NPC_CORPSELIMIT",function(Corpse,Owner)
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
end)
---------------------------------------------------------------------------------------------------------------------------------------------
/*if (SERVER) then -- An old test that can be ignored
	VJ_CurrentPossibleEnemies = {}
	VJ_CurrentVJSNPCs = {}
	VJ_NextRelationCheck = 0
	hook.Add("Think","VJ_SNPC_THINK",function()
		if CurTime() > VJ_NextRelationCheck then
			local it = 1
			while it <= #VJ_CurrentPossibleEnemies do
				local v = VJ_CurrentPossibleEnemies[it]
				if !IsValid(v) then
					table.remove(VJ_CurrentPossibleEnemies,it)
				else
					it = it + 1
					local it2 = 1
					while it2 <= #VJ_CurrentVJSNPCs do
						local v2 = VJ_CurrentVJSNPCs[it2]
						if IsValid(v2) then
							it2 = it2 + 1
							if (v2 != v) && (v2:GetClass() != v:GetClass()) && IsValid(v) && (v:GetPos():Distance(v2:GetPos()) <= v2.SightDistance) then
								if v2:VJ_HasNoTarget(v) == true then
									if IsValid(v2:GetEnemy()) && v2:GetEnemy() == v then
										v2:ResetEnemy(false)
									end
								else
									v2:DoEntityRelationshipCheck(v)
								end
							end
						end
					end
				end
			end
			VJ_NextRelationCheck = CurTime() + 1
		end
	end)
	
	hook.Add("EntityRemoved","VJ_SNPC_ENTITYREMOVED",function(ent)
		if !ent:IsNPC() then return end
		table.RemoveByValue(VJ_CurrentPossibleEnemies,ent)
		if ent.IsVJBaseSNPC == true then
			table.RemoveByValue(VJ_CurrentVJSNPCs,ent)
		end
		print("removed")
	end)
	
	hook.Add("OnEntityCreated","VJ_ENTITYCREATED",function(entity)
		if (CLIENT) or !entity:IsNPC() then return end
		if entity:GetClass() != "npc_grenade_frag" && entity:GetClass() != "bullseye_strider_focus" && entity:GetClass() != "npc_bullseye" && entity:GetClass() != "npc_enemyfinder" && entity:GetClass() != "hornet" then
			if IsValid(entity) then
				VJ_CurrentPossibleEnemies[#VJ_CurrentPossibleEnemies+1] = entity
				if entity.IsVJBaseSNPC == true then
					VJ_CurrentVJSNPCs[#VJ_CurrentVJSNPCs+1] = entity
				end
			end
		end
	end)
end*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Convar Callbacks ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
cvars.AddChangeCallback("ai_ignoreplayers",function(convar_name,oldValue,newValue)
	local getall = ents.GetAll()
	for k, v in pairs(getall) do
		if v.IsVJBaseSNPC == true && (v.IsVJBaseSNPC_Human == true or v.IsVJBaseSNPC_Creature == true) then
			for pk, pv in pairs(player.GetAll()) do
				v:AddEntityRelationship(pv,4,10)
				if IsValid(v:GetEnemy()) && v:GetEnemy() == pv then v:ResetEnemy() end
				v.CurrentPossibleEnemies = v:DoHardEntityCheck(getall)
			end
		end
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Net Messages ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
	net.Receive("vj_music_run",function(len)
		VJ_CL_MUSIC_CURRENT = VJ_CL_MUSIC_CURRENT or {}
		local ent = net.ReadEntity()
		local sdtbl = net.ReadTable()
		local sdvol = net.ReadFloat()
		local sdspeed = net.ReadFloat()
		local sdfadet = net.ReadFloat()
		//local entindex = ent:EntIndex()
		//print(ent)
		sound.PlayFile("sound/"..VJ_PICK(sdtbl),"noplay",function(soundchannel,errorID,errorName)
			if IsValid(soundchannel) then
				if #(VJ_CL_MUSIC_CURRENT) <= 0 then soundchannel:Play() end
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
			if #(VJ_CL_MUSIC_CURRENT) <= 0 then
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
---------------------------------------------------------------------------------------------------------------------------------------------
/*if (CLIENT) then
	require("sound_vj_track")
	sound_vj_track.Add("VJ_SpiderQueenThemeMusic","vj_dm_spidermonster/Dark Messiah - Avatar of the Spider Goddess.wav",161)
end*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Global Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
VJ_MOVETYPE_GROUND = 1
VJ_MOVETYPE_AERIAL = 2
VJ_MOVETYPE_AQUATIC = 3
VJ_MOVETYPE_STATIONARY = 4
VJ_MOVETYPE_PHYSICS = 5

VJ_BEHAVIOR_AGGRESSIVE = 1
VJ_BEHAVIOR_NEUTRAL = 2
VJ_BEHAVIOR_PASSIVE = 3
VJ_BEHAVIOR_PASSIVE_NATURE = 4

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