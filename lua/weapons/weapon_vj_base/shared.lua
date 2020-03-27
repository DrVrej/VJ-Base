if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
IncludeCS("ai_translations.lua")
SWEP.IsVJBaseWeapon = true
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Core & Information-Related Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//SWEP.Base = "weapon_base"
SWEP.PrintName = "VJ Weapon Base"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose = "This weapon is made for Players and NPCs"
SWEP.Instructions = "Controls are like a regular weapon."
SWEP.Category = "VJ Base"
//SWEP.Spawnable = false
//SWEP.AdminOnly = false
SWEP.MadeForNPCsOnly = false -- Is this weapon meant to be for NPCs only?
SWEP.HoldType = "ar2"
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ View Model Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SWEP.ViewModel = "models/weapons/v_flaregun.mdl"
SWEP.UseHands = false -- Should this weapon use Garry's Mod hands? (The model must support it!)
SWEP.ViewModelFlip = false -- Flip the model? Usally used for CS:S models
SWEP.ViewModelFOV = 55 -- Player FOV for the view model
SWEP.BobScale = 1.5 -- Bob effect when moving
SWEP.SwayScale = 1 -- Default is 1, The scale of the viewmodel sway
SWEP.CSMuzzleFlashes = false -- Recommanded to enable for Counter Strike: Source models
SWEP.DrawAmmo = true -- Draw regular Garry's Mod HUD?
SWEP.DrawCrosshair = true -- Draw Crosshair?
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ World Model Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SWEP.WorldModel = "models/weapons/w_rif_ak47.mdl"
SWEP.WorldModel_UseCustomPosition = false -- Should the gun use custom position? This can be used to fix guns that are in the crotch
SWEP.WorldModel_CustomPositionAngle = Vector(-8,1,180)
SWEP.WorldModel_CustomPositionOrigin = Vector(-1,6,1.4)
SWEP.WorldModel_CustomPositionBone = "ValveBiped.Bip01_R_Hand" -- The bone it will use as the main point
SWEP.WorldModel_Invisible = false -- Should the world model be invisible?
SWEP.WorldModel_NoShadow = false -- Should the world model have a shadow?
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ General NPC Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Set this to false to disable the timer automatically running the firing code, this allows for event-based SNPCs to fire at their own pace:
SWEP.NPC_NextPrimaryFire = 0.1 -- Next time it can use primary fire
SWEP.NPC_TimeUntilFire = 0.1 -- How much time until the bullet/projectile is fired?
SWEP.NPC_TimeUntilFireExtraTimers = {} -- Extra timers, which will make the gun fire again! | The seconds are counted after the self.NPC_TimeUntilFire!
SWEP.NPC_AllowCustomSpread = true -- Should the weapon be able to change the NPC's spread?
SWEP.NPC_CustomSpread = 1 -- This is added on top of the custom spread that's set inside the SNPC! | Starting from 1: Closer to 0 = better accuracy, Farther than 1 = worse accuracy
SWEP.NPC_BulletSpawnAttachment = "" -- The attachment that the bullet spawns on, leave empty for base to decide!
SWEP.NPC_CanBePickedUp = true -- Can this weapon be picked up by NPCs? (Ex: Rebels)
	-- ====== Reload Variables ====== --
SWEP.NPC_HasReloadSound = true -- Should it play a sound when the base detects the SNPC playing a reload animation?
SWEP.NPC_ReloadSound = {} -- Sounds it plays when the base detects the SNPC playing a reload animation
SWEP.NPC_ReloadSoundLevel = 60 -- How far does the sound go?
	-- ====== Extra Firing Sound Variables ====== --
SWEP.NPC_ExtraFireSound = {} -- Plays an extra sound after it fires (Example: Bolt action sound)
SWEP.NPC_ExtraFireSoundTime = 0.4 -- How much time until it plays the sound (After Firing)?
SWEP.NPC_ExtraFireSoundLevel = 70 -- How far does the sound go?
SWEP.NPC_ExtraFireSoundPitch = VJ_Set(90,100) -- How much time until the secondary fire can be used again?
	-- ====== Secondary Fire Variables ====== --
SWEP.NPC_HasSecondaryFire = false -- Can the weapon have a secondary fire?
SWEP.NPC_SecondaryFireChance = 3 -- Chance that the secondary fire is used | 1 = always
SWEP.NPC_SecondaryFireNext = VJ_Set(12,15) -- How much time until the secondary fire can be used again?
SWEP.NPC_SecondaryFireDistance = 1000 -- How close does the owner's enemy have to be for it to fire?
SWEP.NPC_HasSecondaryFireSound = true -- Can the secondary fire sound be played?
SWEP.NPC_SecondaryFireSound = {} -- The sound it plays when the secondary fire is used
SWEP.NPC_SecondaryFireSoundLevel = 90 -- The sound level to use for the secondary firing sound
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ General Player Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- ====== Inventory-Related Variables ====== --
SWEP.Slot = 2 -- Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6)
SWEP.SlotPos = 4 -- Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6)
SWEP.Weight = 30 -- Decides whether we should switch from/to this
SWEP.AutoSwitchTo = false -- Auto switch to this weapon when it's picked up
SWEP.AutoSwitchFrom = false -- Auto switch weapon when the owner picks up a better weapon
SWEP.DrawWeaponInfoBox = true -- Should the information box show in the weapon selection menu?
SWEP.BounceWeaponIcon = true -- Should the icon bounce in the weapon selection menu?
	-- ====== Deployment Variables ====== --
SWEP.DelayOnDeploy = 1 -- Time until it can shoot again after deploying the weapon
SWEP.AnimTbl_Deploy = {ACT_VM_DRAW}
SWEP.HasDeploySound = true -- Does the weapon have a deploy sound?
SWEP.DeploySound = {} -- Sound played when the weapon is deployed
	-- ====== Idle Variables ====== --
SWEP.HasIdleAnimation = false -- Does it have a idle animation?
SWEP.AnimTbl_Idle = {ACT_VM_IDLE}
SWEP.NextIdle_Deploy = 0.5 -- How much time until it plays the idle animation after the weapon gets deployed
SWEP.NextIdle_PrimaryAttack = 0.1 -- How much time until it plays the idle animation after attacking(Primary)
	-- ====== Reload Variables ====== --
SWEP.HasReloadSound = false -- Does it have a reload sound? Remember even if this is set to false, the animation sound will still play!
SWEP.ReloadSound = {}
SWEP.AnimTbl_Reload = {ACT_VM_RELOAD}
SWEP.Reload_TimeUntilAmmoIsSet = 1 -- Time until ammo is set to the weapon
SWEP.Reload_TimeUntilFinished = 2 -- How much time until the player can play idle animation, shoot, etc.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Dry Fire Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Examples: Under water, out of ammo
SWEP.HasDryFireSound = true -- Should it play a sound when it's out of ammo?
SWEP.DryFireSound = {} -- The sound that it plays when the weapon is out of ammo
SWEP.DryFireSoundLevel = 50 -- Dry fire sound level
SWEP.DryFireSoundPitch1 = 90 -- Dry fire sound pitch 1
SWEP.DryFireSoundPitch2 = 100 -- Dry fire sound pitch 2
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Primary Fire Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.DisableBulletCode = false -- The bullet won't spawn, this can be used when creating a projectile-based weapon
SWEP.Primary.AllowFireInWater = false -- If true, you will be able to use primary fire in water
SWEP.Primary.Damage = 5 -- Damage
SWEP.Primary.PlayerDamage = "Same" -- Only applies for players | "Same" = Same as self.Primary.Damage, "Double" = Double the self.Primary.Damage OR put a number to be different from self.Primary.Damage
SWEP.Primary.Force = 5 -- Force applied on the object the bullet hits
SWEP.Primary.NumberOfShots = 1 -- How many shots per attack?
SWEP.Primary.ClipSize = 30 -- Max amount of bullets per clip
SWEP.Primary.PickUpAmmoAmount = "Default" -- How much ammo should the player get the gun is picked up? | "Default" = 3 Clips
SWEP.Primary.Recoil = 0.3 -- How much recoil does the player get?
SWEP.Primary.Cone = 7 -- How accurate is the bullet? (Players)
SWEP.Primary.Delay = 0.1 -- Time until it can shoot again
SWEP.Primary.Tracer = 1
SWEP.Primary.TracerType = "Tracer" -- Tracer type (Examples: AR2)
SWEP.Primary.TakeAmmo = 1 -- How much ammo should it take on each shot?
SWEP.Primary.Automatic = true -- Is it automatic?
SWEP.Primary.Ammo = "SMG1" -- Ammo type
SWEP.AnimTbl_PrimaryFire = {ACT_VM_PRIMARYATTACK}
	-- ====== Sound Variables ====== --
SWEP.Primary.Sound = {}
SWEP.Primary.DistantSound = {}
SWEP.Primary.HasDistantSound = true -- Does it have a distant sound when the gun is shot?
SWEP.Primary.DistantSoundLevel = 140 -- Distant sound level
SWEP.Primary.DistantSoundPitch1	= 90 -- Distant sound pitch 1
SWEP.Primary.DistantSoundPitch2	= 110 -- Distant sound pitch 2
SWEP.Primary.DistantSoundVolume	= 1 -- Distant sound volume
	-- ====== Effect Variables ====== --
SWEP.PrimaryEffects_MuzzleFlash = true
SWEP.PrimaryEffects_MuzzleParticles = {"vj_rifle_full"}
SWEP.PrimaryEffects_MuzzleParticlesAsOne = false -- If set to true, the base will spawn all the given particles instead of picking one
SWEP.PrimaryEffects_MuzzleAttachment = "muzzle"
SWEP.PrimaryEffects_SpawnShells = true
SWEP.PrimaryEffects_ShellAttachment = "shell"
SWEP.PrimaryEffects_ShellType = "VJ_Weapon_RifleShell1" -- VJ_Weapon_RifleShell1 | VJ_Weapon_PistolShell1 | VJ_Weapon_ShotgunShell1
SWEP.PrimaryEffects_SpawnDynamicLight = true
SWEP.PrimaryEffects_DynamicLightBrightness = 4
SWEP.PrimaryEffects_DynamicLightDistance = 120
SWEP.PrimaryEffects_DynamicLightColor = Color(255, 150, 60)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Customization Functions ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Use the functions below to customize certain parts of the base or to add new custom systems
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnInitialize() end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnThink() end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnNPC_ServerThink() end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnNPC_Reload() end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttack_BeforeShoot() end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttack_AfterShoot() end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttack_BulletCallback(attacker,tr,dmginfo) end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttackEffects() return true end -- Return false to disable the base effects
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:NPC_SecondaryFire()
	/* An example:
	local pos = self:GetNWVector("VJ_CurBulletPos")
	local proj = ents.Create("prop_combine_ball")
	proj:SetPos(pos)
	proj:SetAngles(self:GetOwner():GetAngles())
	proj:SetOwner(self)
	proj:Spawn()
	proj:Activate()
	proj:Fire("Explode","",4)
	local phys = proj:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:SetVelocity(self:GetOwner():CalculateProjectile("Line", pos, self:GetOwner():GetEnemy():GetPos() + self:GetOwner():GetEnemy():OBBCenter(), 2000))
	end
	VJ_EmitSound(self:GetOwner(),"weapons/ar2/npc_ar2_altfire.wav",90) // "weapons/cguard/charging.wav"
	*/
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomBulletSpawnPosition() return false end -- Return a position to override the bullet spawn position
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnFireAnimationEvent(pos,ang,event,options) return false end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnDrawWorldModel()return true end -- Return false to not draw the world model | This is client side only!
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnDeploy() end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnIdle() end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnReload() end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnRemove() end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ ///// WARNING: Don't touch anything below this line! \\\\\ ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SWEP.RenderGroup = RENDERGROUP_OPAQUE

SWEP.Reloading = false
SWEP.InitHasIdleAnimation = false
SWEP.Primary.DefaultClip = 0
SWEP.NextNPCDrySoundT = 0
SWEP.NPC_NextPrimaryFireT = 0
SWEP.NPC_AnimationSet = "Custom"
SWEP.NPC_SecondaryFireNextT = 0
SWEP.NPC_SecondaryFirePerforming = false
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:Precache()
	util.PrecacheSound(self.Primary.Sound)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:GetCapabilities()
	return bit.bor(CAP_WEAPON_RANGE_ATTACK1,CAP_INNATE_RANGE_ATTACK1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:Initialize()
	self:SetNWVector("VJ_CurBulletPos", self:GetPos())
	self:SetHoldType(self.HoldType)
	if self.HasIdleAnimation == true then self.InitHasIdleAnimation = true end
	self.NPC_SecondaryFireNextT = CurTime() + math.Rand(self.NPC_SecondaryFireNext.a, self.NPC_SecondaryFireNext.b)
	self:CustomOnInitialize()
	if IsValid(self:GetOwner()) then
		if VJ_AnimationExists(self:GetOwner(),ACT_WALK_AIM_PISTOL) == true && VJ_AnimationExists(self:GetOwner(),ACT_RUN_AIM_PISTOL) == true && VJ_AnimationExists(self:GetOwner(),ACT_POLICE_HARASS1) == true then
			self.NPC_AnimationSet = "Metrocop"
		elseif VJ_AnimationExists(self:GetOwner(),"cheer1") == true && VJ_AnimationExists(self:GetOwner(),"wave_smg1") == true && VJ_AnimationExists(self:GetOwner(),ACT_BUSY_SIT_GROUND) == true then
			self.NPC_AnimationSet = "Rebel"
		elseif VJ_AnimationExists(self:GetOwner(),"signal_takecover") == true && VJ_AnimationExists(self:GetOwner(),"grenthrow") == true && VJ_AnimationExists(self:GetOwner(),"bugbait_hit") == true then
			self.NPC_AnimationSet = "Combine"
		end
	end
	if (SERVER) then
		self:SetNPCMinBurst(10)
		self:SetNPCMaxBurst(20)
		self:SetNPCFireRate(10)

		if self:GetOwner():IsNPC() then
			//self:SetWeaponHoldType(self.HoldType)
			if self:GetOwner():GetClass() == "npc_citizen" then self:GetOwner():Fire("DisableWeaponPickup") end -- If it's a citizen, disable them picking up weapons from the ground
			self:GetOwner():SetKeyValue("spawnflags","256") -- Long Visibility Shooting since HL2 NPCs are blind
			//if self:GetOwner():GetClass() != "npc_citizen" then
				hook.Add("Think",self,self.NPC_ServerThink)
				hook.Add("AlwaysThink",self,self.NPC_ServerThinkAlways)
			//end
		end
	end
	if self:GetOwner():IsNPC() && self:GetOwner().IsVJBaseSNPC then
		self:GetOwner().Weapon_StartingAmmoAmount = self.Primary.ClipSize
	end
	self:SetDefaultValues(self.HoldType)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:SetDefaultValues(curtype,force)
	curtype = curtype or "ar2"
	force = force or false
	if curtype == "pistol" then
		if VJ_PICK(self.DeploySound) == false or force == true then self.DeploySound = {"weapons/draw_pistol.wav"} end
		if VJ_PICK(self.DryFireSound) == false or force == true then self.DryFireSound = {"vj_weapons/dryfire_pistol.wav"} end
		if VJ_PICK(self.NPC_ReloadSound) == false or force == true then self.NPC_ReloadSound = {"vj_weapons/reload_pistol.wav"} end
	elseif curtype == "revolver" then
		if VJ_PICK(self.DeploySound) == false or force == true then self.DeploySound = {"weapons/draw_pistol.wav"} end
		if VJ_PICK(self.DryFireSound) == false or force == true then self.DryFireSound = {"vj_weapons/dryfire_revolver.wav"} end
		if VJ_PICK(self.NPC_ReloadSound) == false or force == true then self.NPC_ReloadSound = {"vj_weapons/reload_revolver.wav"} end
	elseif curtype == "shotgun" or curtype == "crossbow" then
		if VJ_PICK(self.DeploySound) == false or force == true then self.DeploySound = {"weapons/draw_rifle.wav"} end
		if VJ_PICK(self.DryFireSound) == false or force == true then self.DryFireSound = {"vj_weapons/dryfire_rifle.wav"} end
		if VJ_PICK(self.NPC_ReloadSound) == false or force == true then self.NPC_ReloadSound = {"vj_weapons/reload_shotgun.wav"} end
	elseif curtype == "rpg" then
		if VJ_PICK(self.DeploySound) == false or force == true then self.DeploySound = {"weapons/draw_rifle.wav"} end
		if VJ_PICK(self.DryFireSound) == false or force == true then self.DryFireSound = {"vj_weapons/dryfire_rifle.wav"} end
		if VJ_PICK(self.NPC_ReloadSound) == false or force == true then self.NPC_ReloadSound = {"vj_weapons/reload_rpg.wav"} end
	elseif curtype == "smg" or curtype == "ar2" then
		if VJ_PICK(self.DeploySound) == false or force == true then self.DeploySound = {"weapons/draw_rifle.wav"} end
		if VJ_PICK(self.DryFireSound) == false or force == true then self.DryFireSound = {"vj_weapons/dryfire_rifle.wav"} end
		if VJ_PICK(self.NPC_ReloadSound) == false or force == true then self.NPC_ReloadSound = {"vj_weapons/reload_rifle.wav"} end
	else
		self.DryFireSound = {"vj_weapons/dryfire_rifle.wav"}
		self.NPC_ReloadSound = {"vj_weapons/reload_rifle.wav"}
		self.DeploySound = {"weapons/draw_rifle.wav"}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:TranslateActivity(act)
	if (self:GetOwner():IsNPC()) then
		if (self.ActivityTranslateAI[act]) && ((!self:GetOwner().IsVJBaseSNPC) or (self:GetOwner().IsVJBaseSNPC == true)) then
			return self.ActivityTranslateAI[act]
		end
		return -1
	end
	if (self.ActivityTranslate[act] != nil) then
		return self.ActivityTranslate[act]
	end
	return -1
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CanBePickedUpByNPCs()
	if self.NPC_CanBePickedUp == false then return end
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:NPC_ServerThinkAlways()
	if (CLIENT) or !IsValid(self) or !IsValid(self:GetOwner()) then return end
	hook.Remove("AlwaysThink", self)
	hook.Add("AlwaysThink",self,self.NPC_ServerThinkAlways)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:NPC_ServerThink()
	if (CLIENT) or !IsValid(self) or !IsValid(self:GetOwner()) then return end
	self:NPC_ServerNextFire()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:NPC_ServerNextFire()
	if (CLIENT) or !IsValid(self) or !IsValid(self:GetOwner()) or !self:GetOwner():IsNPC() then return end
	
	local pos = self:DecideBulletPosition()
	if pos != nil then
		self:SetNWVector("VJ_CurBulletPos", pos)
	end
	
	if self:GetOwner():GetActivity() == nil then return end
	
	//print("------------------")
	//VJ_CreateTestObject(self:DecideBulletPosition(),self:GetAngles(),Color(255,0,255),1)
	//VJ_CreateTestObject(self:GetNWVector("VJ_CurBulletPos"),self:GetAngles(),Color(0,0,255),1)

	self:RunWorldModelThink()
	self:CustomOnThink()
	self:CustomOnNPC_ServerThink()

	local function FireCode()
		self:NPCShoot_Primary(ShootPos,ShootDir) -- Panpoushde zarg
		hook.Remove("Think", self)
		//print(self.NPC_NextPrimaryFire)
		local nxt = self.NPC_NextPrimaryFire
		if nxt > 0.15 then nxt = 0.15 end -- Yete nxt aveli medz e 0.15, ere vor 0.15 ela
		timer.Simple(nxt, function() hook.Add("Think",self,self.NPC_ServerNextFire) end)
		//self.NPC_NextPrimaryFireT = CurTime() + self.NPC_NextPrimaryFire
	end
	if self.NPC_NextPrimaryFire != false && self:NPCAbleToShoot() == true then FireCode() end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:NPCAbleToShoot(CheckSec)
	if !IsValid(self) then return false end
	CheckSec = CheckSec or false -- Make it only check conditions that secondary fire needs
	local owner = self:GetOwner()
	if IsValid(owner) && owner:IsNPC() then
		if (owner.IsVJBaseSNPC_Human) then
			local check, ammo = owner:CanDoWeaponAttack()
			if check == false && ammo != "NoAmmo" then return false end
			if IsValid(owner:GetEnemy()) && owner:IsAbleToShootWeapon(true,true) == false then return false end
		end
		if owner:GetActivity() != nil && (((owner.IsVJBaseSNPC_Human) && ((owner.CurrentWeaponAnimation == owner:GetActivity()) or (owner:GetActivity() == owner:VJ_TranslateWeaponActivity(owner.CurrentWeaponAnimation)) or (owner.DoingWeaponAttack_Standing == false && owner.DoingWeaponAttack == true))) or (!(owner.IsVJBaseSNPC_Human))) then
			if (owner.IsVJBaseSNPC_Human) then
				local check, ammo = owner:CanDoWeaponAttack()
				if ammo == "NoAmmo" then
					if owner.VJ_IsBeingControlled == true then owner.VJ_TheController:PrintMessage(HUD_PRINTCENTER,"Press R to reload!") end
					if self.HasDryFireSound == true && CurTime() > self.NextNPCDrySoundT then
						local sdtbl = VJ_PICK(self.DryFireSound)
						if sdtbl != false then owner:EmitSound(sdtbl,80,math.random(self.DryFireSoundPitch1,self.DryFireSoundPitch2)) end
						if self.NPC_NextPrimaryFire != false then
							self.NextNPCDrySoundT = CurTime() + self.NPC_NextPrimaryFire
						end
					end
					return false
				else
					if owner:VJ_GetEnemy(true) != nil then
						return true
					end
				end
			else
				if owner:VJ_GetEnemy(true) != nil then
					return true
				end
			end
		elseif CheckSec == true then
			return true
		end
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:NPC_PlayFiringGesture()
	local owner = self:GetOwner()
	local customg = VJ_PICK(owner.AnimTbl_WeaponAttackFiringGesture)
	local anim = ""
	if customg != false then
		anim = customg
		anim = VJ_GetSequenceName(owner,anim)
	else
		anim = "gesture_shoot_ar2"
		if self.HoldType == "ar2" then
			anim = "gesture_shoot_ar2"
		elseif self.HoldType == "smg" then
			anim = "gesture_shoot_smg2"
		elseif self.HoldType == "pistol" or self.HoldType == "revolver" then
			if owner:LookupSequence("gesture_shoot_pistol") == -1 then
				anim = "gesture_shootp1"
			else
				anim = "gesture_shoot_pistol"
			end
		elseif self.HoldType == "crossbow" or self.HoldType == "shotgun" then
			anim = "gesture_shoot_shotgun"
		elseif self.HoldType == "rpg" then
			anim = "gesture_shoot_rpg"
		end
	end
	local gest = owner:AddGestureSequence(owner:LookupSequence(anim))
	owner:SetLayerPriority(gest, 2)
	owner:SetLayerPlaybackRate(gest, 0.5)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:NPCShoot_Primary(ShootPos,ShootDir)
	//self:SetClip1(self:Clip1() - 1)
	//if CurTime() > self.NPC_NextPrimaryFireT then
	//self.NPC_NextPrimaryFireT = CurTime() + self.NPC_NextPrimaryFire
	if !IsValid(self) or !IsValid(self:GetOwner()) then return end
	local owner = self:GetOwner()
	if owner.VJ_IsBeingControlled == false && (!IsValid(owner:GetEnemy()) or (!owner:Visible(owner:GetEnemy()))) then return end
	if owner.IsVJBaseSNPC == true then
		//owner.Weapon_TimeSinceLastShot = 0
		owner.NextWeaponAttackAimPoseParametersReset = CurTime() + 1
		owner:WeaponAimPoseParameters()
		//if owner.IsVJBaseSNPC == true then owner.Weapon_TimeSinceLastShot = 0 end
	end
	
	-- Secondary Fire
	if self.NPC_HasSecondaryFire == true && self.NPC_SecondaryFirePerforming == false && CurTime() > self.NPC_SecondaryFireNextT && owner.CanUseSecondaryOnWeaponAttack == true && owner:GetEnemy():GetPos():Distance(owner:GetPos()) <= self.NPC_SecondaryFireDistance then
		if math.random(1, self.NPC_SecondaryFireChance) == 1 then
			owner:VJ_ACT_PLAYACTIVITY(owner.AnimTbl_WeaponAttackSecondary,true,false,true,0)
			self.NPC_SecondaryFirePerforming = true
			timer.Simple(owner.WeaponAttackSecondaryTimeUntilFire,function()
				if IsValid(self) && IsValid(owner) && IsValid(owner:GetEnemy()) && self:NPCAbleToShoot(true) == true && CurTime() > self.NPC_SecondaryFireNextT then
					self.NPC_SecondaryFirePerforming = false
					self:NPC_SecondaryFire()
					if self.NPC_HasSecondaryFireSound == true then VJ_EmitSound(owner,self.NPC_SecondaryFireSound,self.NPC_SecondaryFireSoundLevel) end
					if self.NPC_SecondaryFireNext != false then
						self.NPC_SecondaryFireNextT = CurTime() + math.Rand(self.NPC_SecondaryFireNext.a, self.NPC_SecondaryFireNext.b)
					end
				end
			end)
		else
			self.NPC_SecondaryFireNextT = CurTime() + math.Rand(self.NPC_SecondaryFireNext.a, self.NPC_SecondaryFireNext.b)
		end
	end
	
	-- Primary Fire
	timer.Simple(self.NPC_TimeUntilFire,function()
		if IsValid(self) && IsValid(owner) && self:NPCAbleToShoot() == true && CurTime() > self.NPC_NextPrimaryFireT then
			if owner.DisableWeaponFiringGesture != true then
				self:NPC_PlayFiringGesture()
			end
			self:PrimaryAttack()
			if self.NPC_NextPrimaryFire != false then
				self.NPC_NextPrimaryFireT = CurTime() + self.NPC_NextPrimaryFire
				for tk, tv in ipairs(self.NPC_TimeUntilFireExtraTimers) do
					timer.Simple(tv, function() if IsValid(self) && IsValid(owner) && self:NPCAbleToShoot() == true then self:PrimaryAttack() end end)
				end
			end
			if owner.IsVJBaseSNPC == true then owner.Weapon_TimeSinceLastShot = 0 end
		end
	end)
	//end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:NPC_ReloadWeapon()
	self:GetOwner().NextThrowGrenadeT = self:GetOwner().NextThrowGrenadeT + 2
	self:CustomOnNPC_Reload()
	if self.NPC_HasReloadSound == true then VJ_EmitSound(self:GetOwner(),self.NPC_ReloadSound,self.NPC_ReloadSoundLevel) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:PrimaryAttack(UseAlt)
	//if self:GetOwner():KeyDown(IN_RELOAD) then return end
	//self:GetOwner():SetFOV(45, 0.3)
	//if !IsFirstTimePredicted() then return end
	
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	local owner = self:GetOwner()
	local isnpc = owner:IsNPC()
	local isply = owner:IsPlayer()
	
	if self.Reloading == true then return end
	if isnpc && owner.VJ_IsBeingControlled == false && !IsValid(owner:GetEnemy()) then return end -- If the NPC owner isn't being controlled and doesn't have an enemy, then return end
	if (isply && self.Primary.AllowFireInWater == false && owner:WaterLevel() == 3) or (self:Clip1() <= 0) then owner:EmitSound(VJ_PICK(self.DryFireSound),self.DryFireSoundLevel,math.random(self.DryFireSoundPitch1,self.DryFireSoundPitch2)) return end
	if (!self:CanPrimaryAttack()) then return end
	self:CustomOnPrimaryAttack_BeforeShoot()
	
	if isnpc then
		timer.Simple(self.NPC_ExtraFireSoundTime, function()
			if IsValid(self) && IsValid(owner) then
				VJ_EmitSound(owner,self.NPC_ExtraFireSound,self.NPC_ExtraFireSoundLevel,math.Rand(self.NPC_ExtraFireSoundPitch.a, self.NPC_ExtraFireSoundPitch.b))
			end
		end)
	end
	local firesd = VJ_PICK(self.Primary.Sound)
	if firesd != false then
		self:EmitSound(firesd, 80, math.random(90,100))
		//sound.Play(firesd,self:GetPos(),80,math.random(90,100))
	end
	if self.Primary.HasDistantSound == true then
		local farsd = VJ_PICK(self.Primary.DistantSound)
		if farsd != false then
			sound.Play(farsd,self:GetPos(),self.Primary.DistantSoundLevel,math.random(self.Primary.DistantSoundPitch1,self.Primary.DistantSoundPitch2),self.Primary.DistantSoundVolume)
		end
	end
	
	if self.Primary.DisableBulletCode == false then
		local bullet = {}
			bullet.Num = self.Primary.NumberOfShots
			bullet.Tracer = self.Primary.Tracer
			bullet.TracerName = self.Primary.TracerType
			bullet.Force = self.Primary.Force
			bullet.Dir = owner:GetAimVector()
			bullet.AmmoType = self.Primary.Ammo
			
			-- Spawn Position
			local spawnpos = owner:GetShootPos()
			if isnpc then
				spawnpos = self:GetNWVector("VJ_CurBulletPos")
			end
			//print(spawnpos)
			//VJ_CreateTestObject(spawnpos,self:GetAngles(),Color(0,0,255))
			bullet.Src = spawnpos
			
			-- Callback
			bullet.Callback = function(attacker, tr, dmginfo)
				self:CustomOnPrimaryAttack_BulletCallback(attacker,tr,dmginfo)
				/*local laserhit = EffectData()
				laserhit:SetOrigin(tr.HitPos)
				laserhit:SetNormal(tr.HitNormal)
				laserhit:SetScale(25)
				util.Effect("AR2Impact", laserhit)
				tr.HitPos:Ignite(8,0)*/
			end
			
			-- Damage
			if isply then
				bullet.Spread = Vector((self.Primary.Cone / 60) / 4, (self.Primary.Cone / 60) / 4, 0)
				if self.Primary.PlayerDamage == "Same" then
					bullet.Damage = self.Primary.Damage
				elseif self.Primary.PlayerDamage == "Double" then
					bullet.Damage = self.Primary.Damage * 2
				elseif isnumber(self.Primary.PlayerDamage) then
					bullet.Damage = self.Primary.PlayerDamage
				end
			else
				if owner.IsVJBaseSNPC == true then
					bullet.Damage = owner:VJ_GetDifficultyValue(self.Primary.Damage)
				else
					bullet.Damage = self.Primary.Damage
				end
			end
		owner:FireBullets(bullet)
	else
		if isnpc && owner.IsVJBaseSNPC == true then -- Make sure the VJ SNPC recognizes that it lost a ammunition, even though it was a custom bullet code
			owner.Weapon_ShotsSinceLastReload = owner.Weapon_ShotsSinceLastReload + 1
		end
	end
	
	if GetConVarNumber("vj_wep_nomuszzleflash") == 0 then owner:MuzzleFlash() end
	self:PrimaryAttackEffects()
	if isply then
		//self:ShootEffects("ToolTracer") -- Deprecated
		self:SendWeaponAnim(VJ_PICK(self.AnimTbl_PrimaryFire))
		owner:SetAnimation(PLAYER_ATTACK1)
		owner:ViewPunch(Angle(-self.Primary.Recoil, 0, 0))
		self:TakePrimaryAmmo(self.Primary.TakeAmmo)
	end
	self:CustomOnPrimaryAttack_AfterShoot()
	//self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	timer.Simple(self.NextIdle_PrimaryAttack, function() if IsValid(self) then self:DoIdleAnimation() end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:SecondaryAttack()
	return false -- We don't want a secondary attack
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:DoIdleAnimation()
	if self.HasIdleAnimation == false or self.Reloading == true then return end
	self:CustomOnIdle()
	self:SendWeaponAnim(VJ_PICK(self.AnimTbl_Idle))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:PrimaryAttackEffects()
	local customeffects = self:CustomOnPrimaryAttackEffects()
	if customeffects != true then return end
	local owner = self:GetOwner()
	
	/*local vjeffectmuz = EffectData()
	vjeffectmuz:SetOrigin(self:GetOwner():GetShootPos())
	vjeffectmuz:SetEntity(self)
	vjeffectmuz:SetStart(self:GetOwner():GetShootPos())
	vjeffectmuz:SetNormal(self:GetOwner():GetAimVector())
	vjeffectmuz:SetAttachment(1)
	util.Effect("VJ_Weapon_RifleMuzzle1",vjeffectmuz)*/

	if GetConVarNumber("vj_wep_nomuszzleflash") == 0 then
		if self.PrimaryEffects_MuzzleFlash == true then
			local muzzleattach = self.PrimaryEffects_MuzzleAttachment
			if isnumber(muzzleattach) == false then muzzleattach = self:LookupAttachment(muzzleattach) end
			if owner:IsPlayer() && owner:GetViewModel() != nil then
				local vjeffectmuz = EffectData()
				vjeffectmuz:SetOrigin(owner:GetShootPos())
				vjeffectmuz:SetEntity(self)
				vjeffectmuz:SetStart(owner:GetShootPos())
				vjeffectmuz:SetNormal(owner:GetAimVector())
				vjeffectmuz:SetAttachment(muzzleattach)
				util.Effect("VJ_Weapon_RifleMuzzle1",vjeffectmuz)
			else
				if self.PrimaryEffects_MuzzleParticlesAsOne == true then
					for k,v in pairs(self.PrimaryEffects_MuzzleParticles) do
						if !istable(v) then
							ParticleEffectAttach(v,PATTACH_POINT_FOLLOW,self,muzzleattach)
						end
					end
				else
					ParticleEffectAttach(VJ_PICK(self.PrimaryEffects_MuzzleParticles),PATTACH_POINT_FOLLOW,self,muzzleattach)
				end
			end
		end
		
		if (SERVER) && self.PrimaryEffects_SpawnDynamicLight == true && GetConVarNumber("vj_wep_nomuszzleflash_dynamiclight") == 0 then
			local FireLight1 = ents.Create("light_dynamic")
			FireLight1:SetKeyValue("brightness", self.PrimaryEffects_DynamicLightBrightness)
			FireLight1:SetKeyValue("distance", self.PrimaryEffects_DynamicLightDistance)
			if owner:IsPlayer() then FireLight1:SetLocalPos(owner:GetShootPos() +self:GetForward()*40 + self:GetUp()*-10) else FireLight1:SetLocalPos(self:GetNWVector("VJ_CurBulletPos")) end
			FireLight1:SetLocalAngles(self:GetAngles())
			FireLight1:Fire("Color", self.PrimaryEffects_DynamicLightColor.r.." "..self.PrimaryEffects_DynamicLightColor.g.." "..self.PrimaryEffects_DynamicLightColor.b)
			//FireLight1:SetParent(self)
			FireLight1:Spawn()
			FireLight1:Activate()
			FireLight1:Fire("TurnOn","",0)
			FireLight1:Fire("Kill","",0.07)
			self:DeleteOnRemove(FireLight1)
		end
	end

	if self.PrimaryEffects_SpawnShells == true && !owner:IsPlayer() && GetConVarNumber("vj_wep_nobulletshells") == 0 then
		local shellattach = self.PrimaryEffects_ShellAttachment
		if isnumber(shellattach) == false then shellattach = self:LookupAttachment(shellattach) end
		local vjeffect = EffectData()
		vjeffect:SetEntity(self)
		vjeffect:SetOrigin(owner:GetShootPos())
		vjeffect:SetNormal(owner:GetAimVector())
		vjeffect:SetAttachment(shellattach)
		util.Effect(self.PrimaryEffects_ShellType,vjeffect)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:FireAnimationEvent(pos,ang,event,options)
	local getcustom = self:CustomOnFireAnimationEvent(pos,ang,event,options)
	if getcustom == true then return true end
	
	if event == 22 or event == 6001 then return true end
	
	if GetConVarNumber("vj_wep_nomuszzleflash") == 1 then
		if event == 21 or event == 22 or event == 5001 or event == 5003 then
			return true
		end
	end

	if GetConVarNumber("vj_wep_nobulletshells") == 1 then
		if event == 20 or event == 6001 then
			return true
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:Think()
	self:RunWorldModelThink()
	self:CustomOnThink()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:Reload()
	if !IsValid(self) or !IsValid(self:GetOwner()) or !self:GetOwner():Alive() or !self:GetOwner():IsPlayer() or self:GetOwner():GetAmmoCount(self.Primary.Ammo) == 0 or !self:GetOwner():KeyDown(IN_RELOAD) or self.Reloading == true then return end
	local smallerthanthis = self.Primary.ClipSize - 1
	if self:Clip1() <= smallerthanthis then
		local setcorrectnum = self.Primary.ClipSize - self:Clip1()
		local test = setcorrectnum + self:Clip1()
		self.Reloading = true
		self:CustomOnReload()
		if self.HasReloadSound == true then self:GetOwner():EmitSound(VJ_PICK(self.ReloadSound),50,math.random(90,100)) end
		if self:GetOwner():IsPlayer() then
			self:SendWeaponAnim(VJ_PICK(self.AnimTbl_Reload)) //self:SendWeaponAnim(VJ_PICK(self.AnimTbl_Reload))
			self:GetOwner():SetAnimation(PLAYER_RELOAD)
			timer.Simple(self.Reload_TimeUntilAmmoIsSet,function() if IsValid(self) then self:GetOwner():RemoveAmmo(setcorrectnum,self.Primary.Ammo) self:SetClip1(test) end end)
			timer.Simple(self.Reload_TimeUntilFinished,function() if IsValid(self) then self.Reloading = false self:DoIdleAnimation() end end)
		end
		return true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:Deploy()
	if self.InitHasIdleAnimation == true then self.HasIdleAnimation = true end
	if self:GetOwner():IsPlayer() then
		self:CustomOnDeploy()
		self:SendWeaponAnim(VJ_PICK(self.AnimTbl_Deploy))
		if self.HasDeploySound == true then self:EmitSound(VJ_PICK(self.DeploySound),50,math.random(90,100)) end
		self:SetNextPrimaryFire(CurTime() + self.DelayOnDeploy)
	end
	timer.Simple(self.NextIdle_Deploy,function() if IsValid(self) then self:DoIdleAnimation() end end)
	return true -- Or else the player won't be able to get the weapon!
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:Holster(wep)
	//if CLIENT then return end
	if self == wep or self.Reloading == true then return end
	self.HasIdleAnimation = false
	//self:SendWeaponAnim(ACT_VM_HOLSTER)
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:Equip()
	self:SetClip1(self.Primary.ClipSize)
	if self:GetOwner():IsPlayer() then
		if self.Primary.PickUpAmmoAmount == "Default" then
			self:GetOwner():GiveAmmo(self.Primary.ClipSize*2,self.Primary.Ammo)
		elseif isnumber(self.Primary.PickUpAmmoAmount) then
			self:GetOwner():GiveAmmo(self.Primary.PickUpAmmoAmount,self.Primary.Ammo)
		end
		//self:GetOwner():RemoveAmmo(self.Primary.DefaultClip,self.Primary.Ammo)
		if self.MadeForNPCsOnly == true then
			self:GetOwner():PrintMessage(HUD_PRINTTALK,self.PrintName.." removed! It's made for NPCs only!")
			self:Remove()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:EquipAmmo(ply)
	if ply:IsPlayer() then
		ply:GiveAmmo(self.Primary.ClipSize, self.Primary.Ammo)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OwnerChanged()
	//self:GetOwner()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OnRemove()
	self:CustomOnRemove()
	self:StopParticles()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:GetWeaponCustomPosition()
	if self:GetOwner():LookupBone(self.WorldModel_CustomPositionBone) == nil then return nil end
	local pos, ang = self:GetOwner():GetBonePosition(self:GetOwner():LookupBone(self.WorldModel_CustomPositionBone))
	ang:RotateAroundAxis(ang:Right(), self.WorldModel_CustomPositionAngle.x)
	ang:RotateAroundAxis(ang:Up(), self.WorldModel_CustomPositionAngle.y)
	ang:RotateAroundAxis(ang:Forward(), self.WorldModel_CustomPositionAngle.z)
	pos = pos + self.WorldModel_CustomPositionOrigin.x * ang:Right()
	pos = pos + self.WorldModel_CustomPositionOrigin.y * ang:Forward()
	pos = pos + self.WorldModel_CustomPositionOrigin.z * ang:Up()
	return {pos = pos, ang = ang}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:RunWorldModelThink()
	self:SetNWBool("VJ_WorldModel_Invisible", self.WorldModel_Invisible)
	
	if IsValid(self:GetOwner()) && self.WorldModel_UseCustomPosition == true then
		local weppos = self:GetWeaponCustomPosition()
		if weppos == nil then return end
		self:SetPos(weppos.pos)
		self:SetAngles(weppos.ang)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:DecideBulletPosition()
	if !IsValid(self:GetOwner()) then return nil end
	if !self:GetOwner():IsNPC() then return self:GetOwner():GetShootPos() end
	local customPos = self:CustomBulletSpawnPosition()
	if customPos != false then
		return customPos
	end
	if self.NPC_BulletSpawnAttachment != "" then
		if self:LookupAttachment(self.NPC_BulletSpawnAttachment) == 0 or self:LookupAttachment(self.NPC_BulletSpawnAttachment) == -1 then
			-- Axper jan, Hay es?
		else
			hascustom = true
			return self:GetAttachment(self:LookupAttachment(self.NPC_BulletSpawnAttachment)).Pos
		end
	end
	local getmuzzle;
	//local numattachments = self:GetAttachments()
	local numattachments = #self:GetAttachments()
	if (IsValid(self)) then
		for i = 1,numattachments do
			if self:GetAttachments()[i].name == "muzzle" then
				getmuzzle = "muzzle" break
			elseif self:GetAttachments()[i].name == "muzzleA" then
				getmuzzle = "muzzleA" break
			elseif self:GetAttachments()[i].name == "muzzle_flash" then
				getmuzzle = "muzzle_flash" break
			elseif self:GetAttachments()[i].name == "muzzle_flash1" then
				getmuzzle = "muzzle_flash1" break
			elseif self:GetAttachments()[i].name == "muzzle_flash2" then
				getmuzzle = "muzzle_flash2" break
			elseif self:GetAttachments()[i].name == "ValveBiped.muzzle" then
				getmuzzle = "ValveBiped.muzzle" break
			else
				getmuzzle = false
			end
		end
		if (getmuzzle == false) or getmuzzle == nil then
			if self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand") != nil then
				return self:GetOwner():GetBonePosition(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand"))
			else
				print("WARNING: "..self:GetClass().." doesn't have a proper attachment or bone for bullet spawn!")
				return self:GetOwner():EyePos()
			end
		end
		//print("It has a proper attachment.")
		return self:GetAttachment(self:LookupAttachment(getmuzzle)).Pos //+ self:GetOwner():GetUp()*-45
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
/*if (SERVER) then
	util.AddNetworkString("vj_weapon_curbulletpos") -- No longer needed, disabling sv_pvsskipanimation fixes it!
	
	net.Receive("vj_weapon_curbulletpos", function(len,pl)
		local vec = net.ReadVector()
		local ent = ents.GetByIndex(net.ReadInt(15))
		if IsValid(ent) then
			ent.worldupdate = ent.worldupdate or 0
			if ent.worldupdate <= CurTime() then
				ent:SetNWVector("VJ_CurBulletPos",vec)
				ent.worldupdate = CurTime() + 0.33
			end
		end
	end)
end*/
---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
	function SWEP:DrawWorldModel()
		if !IsValid(self) then return end
		
		local nodraw = false
		if self:CustomOnDrawWorldModel() == false then nodraw = true end
		if self:GetNWBool("VJ_WorldModel_Invisible") == true or self.WorldModel_Invisible == true then nodraw = true end
		
		if self.WorldModel_NoShadow == true then
			self:DrawShadow(false)
		end
		
		-- No longer needed, disabling sv_pvsskipanimation fixes it!
		/*local pos = self:DecideBulletPosition()
		if pos != nil && IsValid(self:GetOwner()) then
			net.Start("vj_weapon_curbulletpos")
			net.WriteVector(pos)
			net.WriteInt(self:EntIndex(), 15)
			net.SendToServer()
		end*/
		
		if self.WorldModel_UseCustomPosition == true then
			if IsValid(self:GetOwner()) then
				if self:GetOwner():IsPlayer() && self:GetOwner():InVehicle() then return end
				local weppos = self:GetWeaponCustomPosition()
				if weppos == nil then return end
				self:SetRenderOrigin(weppos.pos)
				self:SetRenderAngles(weppos.ang)
				self:FrameAdvance(FrameTime())
				self:SetupBones()
				if nodraw == false then self:DrawModel() end
			else
				self:SetRenderOrigin(nil)
				self:SetRenderAngles(nil)
				if nodraw == false then self:DrawModel() end
			end
		else
			if nodraw == false then self:DrawModel() end
		end
	end
end