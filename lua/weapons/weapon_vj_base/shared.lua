if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
IncludeCS("ai_translations.lua")
---------------------------------------------------------------------------------------------------------------------------------------------
//SWEP.Base 					= "weapon_base"
SWEP.PrintName					= "VJ Weapon Base"
SWEP.Author 					= "DrVrej"
SWEP.Contact					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose					= "This weapon is made for Players and NPCs"
SWEP.Instructions				= "Controls are like a regular weapon."
SWEP.Category					= "VJ Base"
SWEP.IsVJBaseWeapon				= true
	-- Client Settings ---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
SWEP.Slot						= 2 -- Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6)
SWEP.SlotPos					= 4 -- Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6)
SWEP.SwayScale 					= 1 -- Default is 1, The scale of the viewmodel sway
SWEP.CSMuzzleFlashes 			= false -- Use CS:S Muzzle flash?
SWEP.DrawAmmo					= true -- Draw regular Garry's Mod HUD?
SWEP.DrawCrosshair				= true -- Draw Crosshair?
SWEP.DrawWeaponInfoBox 			= true -- Should the information box show in the weapon selection menu?
SWEP.BounceWeaponIcon 			= true -- Should the icon bounce in the weapon selection menu?
SWEP.RenderGroup 				= RENDERGROUP_OPAQUE
//SWEP.UseHands					= true
end
	-- Server Settings ---------------------------------------------------------------------------------------------------------------------------------------------
if (SERVER) then
SWEP.Weight						= 30 -- Decides whether we should switch from/to this
SWEP.AutoSwitchTo				= false -- Auto switch to this weapon when it's picked up
SWEP.AutoSwitchFrom				= false -- Auto switch weapon when the owner picks up a better weapon
end
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
	-- Set this fault to disable the timer automatically running the firing code, this allows for event-based SNPCs to fire at their own pace:
SWEP.NPC_NextPrimaryFire 		= 0.1 -- Next time it can use primary fire
SWEP.NPC_TimeUntilFire	 		= 0.1 -- How much time until the bullet/projectile is fired?
SWEP.NPC_TimeUntilFireExtraTimers = {} -- Extra timers, which will make the gun fire again! | The seconds are counted after the self.NPC_TimeUntilFire!
SWEP.NPC_AllowCustomSpread		= true -- Should the weapon be able to change the NPC's spread?
SWEP.NPC_CustomSpread	 		= 1 -- This is added on top of the custom spread that's set inside the SNPC! | Starting from 1: Closer to 0 = better accuracy, Farther than 1 = worse accuracy
SWEP.NPC_BulletSpawnAttachment 	= "" -- The attachment that the bullet spawns on, leave empty for base to decide!
SWEP.NPC_AnimationTbl_Custom 	= {} -- Can be activity or sequence
SWEP.NPC_AnimationTbl_General 	= {ACT_RANGE_ATTACK1,ACT_RANGE_ATTACK1_LOW,ACT_IDLE_AGITATED,ACT_IDLE_AIM_AGITATED,ACT_RUN_AIM,ACT_WALK_AIM}
SWEP.NPC_AnimationTbl_Rifle 	= {ACT_WALK_AIM_RIFLE,ACT_RUN_AIM_RIFLE,ACT_RANGE_ATTACK_AR2,ACT_RANGE_ATTACK_AR2_LOW,ACT_IDLE_ANGRY_SMG1,ACT_RANGE_ATTACK_SMG1,ACT_RANGE_ATTACK_SMG1_LOW}
SWEP.NPC_AnimationTbl_Pistol 	= {ACT_RANGE_ATTACK_PISTOL,ACT_WALK_PISTOL,ACT_RANGE_ATTACK_PISTOL_LOW}
SWEP.NPC_AnimationTbl_Shotgun 	= {ACT_RANGE_ATTACK_SHOTGUN,ACT_RANGE_ATTACK_SHOTGUN_LOW,ACT_IDLE_SHOTGUN_AGITATED}
SWEP.NPC_ReloadAnimationTbl_Custom = {} -- Can be activity or sequence
SWEP.NPC_ReloadAnimationTbl		= {ACT_RELOAD,ACT_RELOAD_START,ACT_RELOAD_FINISH,ACT_RELOAD_LOW,ACT_GESTURE_RELOAD,ACT_GESTURE_RELOAD_PISTOL,ACT_GESTURE_RELOAD_SMG1,ACT_GESTURE_RELOAD_SHOTGUN,ACT_SHOTGUN_RELOAD_START,ACT_SHOTGUN_RELOAD_FINISH,ACT_SMG2_RELOAD2,ACT_RELOAD_PISTOL,ACT_RELOAD_PISTOL_LOW,ACT_RELOAD_SMG1,ACT_RELOAD_SMG1_LOW,ACT_RELOAD_SHOTGUN,ACT_RELOAD_SHOTGUN_LOW,ACT_GESTURE_RELOAD,ACT_GESTURE_RELOAD_PISTOL,ACT_GESTURE_RELOAD_SMG1,ACT_GESTURE_RELOAD_SHOTGUN}
SWEP.NPC_HasReloadSound			= true -- Should it play a sound when the base detects the SNPC playing a reload animation?
SWEP.NPC_ReloadSound			= {} -- Sounds it plays when the base detects the SNPC playing a reload animation
SWEP.NPC_ReloadSoundLevel		= 60 -- How far does the sound go?
SWEP.NPC_ExtraFireSound			= {} -- Plays an extra sound after it fires (Example: Bolt action sound)
SWEP.NPC_ExtraFireSoundTime		= 0.4 -- How much time until it plays the sound (After Firing)?
SWEP.NPC_ExtraFireSoundLevel	= 70 -- How far does the sound go?
SWEP.NPC_ExtraFireSoundPitch1	= 90
SWEP.NPC_ExtraFireSoundPitch2	= 100
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.MadeForNPCsOnly 			= false -- Is this weapon meant to be for NPCs only?
SWEP.ViewModel					= "models/weapons/v_rif_ak47.mdl"
SWEP.WorldModel					= "models/weapons/w_rif_ak47.mdl"
SWEP.HoldType 					= "ar2"
SWEP.ViewModelFlip				= false -- Flip the model? Usally used for CS:S models
SWEP.ViewModelFOV				= 55 -- Player FOV for the view model
SWEP.BobScale					= 1.5 -- Bob effect when moving
//SWEP.Spawnable				= false
//SWEP.AdminOnly				= false
SWEP.AnimPrefix					= "python"
	-- World Model ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.WorldModel_UseCustomPosition = false -- Should the gun use custom position? This can be used to fix guns that are in the crotch
SWEP.WorldModel_CustomPositionAngle = Vector(-8,1,180)
SWEP.WorldModel_CustomPositionOrigin = Vector(-1,6,1.4)
SWEP.WorldModel_CustomPositionBone = "ValveBiped.Bip01_R_Hand" -- The bone it will use as the main point
SWEP.WorldModel_Invisible = false -- Should the world model be invisible?
SWEP.WorldModel_NoShadow = false -- Should the world model have a shadow?
	-- General Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.DryFireSound				= {} -- The sound that it plays when the weapon is out of ammo
SWEP.DryFireSoundLevel 			= 50 -- Dry fire sound level
SWEP.DryFireSoundPitch1 		= 90 -- Dry fire sound pitch 1
SWEP.DryFireSoundPitch2 		= 100 -- Dry fire sound pitch 2
	-- Deployment Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.DelayOnDeploy 				= 1 -- Time until it can shoot again after deploying the weapon
SWEP.AnimTbl_Deploy				= {ACT_VM_DRAW}
SWEP.HasDeploySound				= true -- Does the weapon have a deploy sound?
SWEP.DeploySound				= {} -- Sound played when the weapon is deployed
	-- Idle Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasIdleAnimation			= false -- Does it have a idle animation?
SWEP.AnimTbl_Idle				= {ACT_VM_IDLE}
SWEP.NextIdle_Deploy			= 0.5 -- How much time until it plays the idle animation after the weapon gets deployed
SWEP.NextIdle_PrimaryAttack		= 0.1 -- How much time until it plays the idle animation after attacking(Primary)
	-- Reload Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasReloadSound				= false -- Does it have a reload sound? Remember even if this is set to false, the animation sound will still play!
SWEP.ReloadSound				= {}
SWEP.AnimTbl_Reload				= {ACT_VM_RELOAD}
SWEP.Reload_TimeUntilAmmoIsSet	= 1 -- Time until ammo is set to the weapon
SWEP.Reload_TimeUntilFinished	= 2 -- How much time until the player can play idle animation, shoot, etc.
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.DisableBulletCode	= false -- The bullet won't spawn, this can be used when creating a projectile-based weapon
SWEP.Primary.AllowFireInWater	= false -- If true, you will be able to use primary fire in water
SWEP.Primary.Damage				= 5 -- Damage
SWEP.Primary.PlayerDamage		= "Same" -- Only applies for players | "Same" = Same as self.Primary.Damage, "Double" = Double the self.Primary.Damage OR put a number to be different from self.Primary.Damage
SWEP.Primary.Force				= 5 -- Force applied on the object the bullet hits
SWEP.Primary.NumberOfShots		= 1 -- How many shots per attack?
SWEP.Primary.ClipSize			= 30 -- Max amount of bullets per clip
SWEP.Primary.PickUpAmmoAmount 	= "Default" -- How much ammo should the player get the gun is picked up? | "Default" = 3 Clips
SWEP.Primary.Recoil				= 0.3 -- How much recoil does the player get?
SWEP.Primary.Cone				= 7 -- How accurate is the bullet? (Players)
SWEP.Primary.Delay				= 0.1 -- Time until it can shoot again
SWEP.Primary.Tracer				= 1
SWEP.Primary.TracerType			= "Tracer" -- Tracer type (Examples: AR2, laster, 9mm)
SWEP.Primary.TakeAmmo			= 1 -- How much ammo should it take on each shot?
SWEP.Primary.Automatic			= true -- Is it automatic?
SWEP.Primary.Ammo				= "SMG1" -- Ammo type
SWEP.AnimTbl_PrimaryFire		= {ACT_VM_PRIMARYATTACK}
SWEP.Primary.Sound				= {}
SWEP.Primary.DistantSound		= {}
SWEP.Primary.HasDistantSound	= true -- Does it have a distant sound when the gun is shot?
SWEP.Primary.DistantSoundLevel	= 140 -- Distant sound level
SWEP.Primary.DistantSoundPitch1	= 90 -- Distant sound pitch 1
SWEP.Primary.DistantSoundPitch2	= 110 -- Distant sound pitch 2
SWEP.Primary.DistantSoundVolume	= 1 -- Distant sound volume
SWEP.PrimaryEffects_MuzzleFlash = true
SWEP.PrimaryEffects_MuzzleParticles = {"vj_rifle_full"}
SWEP.PrimaryEffects_MuzzleParticlesAsOne = false -- If set to true, the base will spawn all the given particles instead of picking one
SWEP.PrimaryEffects_MuzzleAttachment = "muzzle"
SWEP.PrimaryEffects_SpawnShells = true
SWEP.PrimaryEffects_ShellAttachment = "shell"
SWEP.PrimaryEffects_ShellType 	= "VJ_Weapon_RifleShell1"
	-- VJ_Weapon_RifleShell1 | VJ_Weapon_PistolShell1 | VJ_Weapon_ShotgunShell1
SWEP.PrimaryEffects_SpawnDynamicLight = true
SWEP.PrimaryEffects_DynamicLightBrightness = 4
SWEP.PrimaryEffects_DynamicLightDistance = 120
SWEP.PrimaryEffects_DynamicLightColor = Color(255, 150, 60)
	-- Secondary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Secondary.Damage			= 5 -- Damage
SWEP.Secondary.PlayerDamage		= 2 -- Only applies for players | "Same" = Same as self.Primary.Damage, "Double" = Double the self.Primary.Damage OR put a number to be different from self.Primary.Damage
SWEP.Secondary.Force			= 5 -- Force applied on the object the bullet hits
SWEP.Secondary.NumberOfShots	= 1 -- How many shots per attack?
SWEP.Secondary.ClipSize			= -1 -- Max amount of bullets per clip
SWEP.Secondary.DefaultClip		= -1 -- How much ammo do you get when you first pick up the weapon?
SWEP.Secondary.Recoil			= 0.3 -- How much recoil does the player get?
SWEP.Secondary.Cone				= 7 -- How accurate is the bullet? (Players)
SWEP.Secondary.Delay			= 0.1 -- Time until it can shoot again
SWEP.Secondary.Tracer			= 1
SWEP.Secondary.TakeAmmo			= 1 -- How much ammo should it take on each shot?
SWEP.Secondary.Automatic		= false -- Is it automatic?
SWEP.Secondary.Ammo				= "none" -- Ammo type
SWEP.Secondary.Sound			= {"vj_weapons/ak47/ak47_single.wav"}
SWEP.AnimTbl_SecondaryFire		= {ACT_VM_SECONDARYATTACK}
SWEP.Secondary.DistantSound		= {"vj_weapons/ak47/ak47_single_dist.wav"}
	-- Independent Variables ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Reloading 					= false
SWEP.InitHasIdleAnimation		= false
SWEP.AlreadyPlayedNPCReloadSound = false
SWEP.NPC_NextPrimaryFireT		= 0
SWEP.Primary.DefaultClip 		= 0
SWEP.NextNPCDrySoundT 			= 0
SWEP.NPC_AnimationSet 			= "Custom"
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnInitialize() end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnThink() end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttack_BeforeShoot() end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttack_AfterShoot() end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttack_BulletCallback(attacker,tr,dmginfo) end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttackEffects()
	-- Not returning to true will make the base effects not to spawn
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomBulletSpawnPosition()
	-- Return a position to override the bullet spawn position
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnFireAnimationEvent(pos,ang,event,options) return false end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnDrawWorldModel() -- This is client only!
	return true -- return false to not draw the world model
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnDeploy() end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnIdle() end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnReload() end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnRemove() end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnNPC_ServerThink() end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnNPC_Reload() end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:Initialize()
	self:SetNWVector("VJ_CurBulletPos",self:GetPos())
	self:SetHoldType(self.HoldType)
	if self.HasIdleAnimation == true then self.InitHasIdleAnimation = true end
	self:CustomOnInitialize()
	if IsValid(self.Owner) then
		if VJ_AnimationExists(self.Owner,ACT_WALK_AIM_PISTOL) == true && VJ_AnimationExists(self.Owner,ACT_RUN_AIM_PISTOL) == true && VJ_AnimationExists(self.Owner,ACT_POLICE_HARASS1) == true then
			self.NPC_AnimationSet = "Metrocop"
		elseif VJ_AnimationExists(self.Owner,"cheer1") == true && VJ_AnimationExists(self.Owner,"wave_smg1") == true && VJ_AnimationExists(self.Owner,ACT_BUSY_SIT_GROUND) == true then
			self.NPC_AnimationSet = "Rebel"
		elseif VJ_AnimationExists(self.Owner,"signal_takecover") == true && VJ_AnimationExists(self.Owner,"grenthrow") == true && VJ_AnimationExists(self.Owner,"bugbait_hit") == true then
			self.NPC_AnimationSet = "Combine"
		end
	end
	if (SERVER) then
		self:SetNPCMinBurst(10)
		self:SetNPCMaxBurst(20)
		self:SetNPCFireRate(10)

		if self.Owner:IsNPC() then
			//self:SetWeaponHoldType(self.HoldType)
			if self.Owner:GetClass() == "npc_citizen" then self.Owner:Fire("DisableWeaponPickup") end
			self.Owner:SetKeyValue("spawnflags","256") -- Long Visibility Shooting since HL2 NPCs are blind
			if self.Owner:GetClass() != "npc_citizen" then
				hook.Add("Think",self,self.NPC_ServerThink)
				hook.Add("AlwaysThink",self,self.NPC_ServerThinkAlways)
			end
		end
	end
	if self.Owner:IsNPC() && self.Owner.IsVJBaseSNPC then
		self.Owner.Weapon_StartingAmmoAmount = self.Primary.ClipSize
	end
	self:SetDefaultValues(self.HoldType)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:SetDefaultValues(curtype,force)
	curtype = curtype or "ar2"
	force = force or false
	if curtype == "pistol" then
		if VJ_PICKRANDOMTABLE(self.DeploySound) == false or force == true then self.DeploySound = {"weapons/draw_pistol.wav"} end
		if VJ_PICKRANDOMTABLE(self.DryFireSound) == false or force == true then self.DryFireSound = {"vj_weapons/dryfire_pistol.wav"} end
		if VJ_PICKRANDOMTABLE(self.NPC_ReloadSound) == false or force == true then self.NPC_ReloadSound = {"vj_weapons/reload_pistol.wav"} end
	elseif curtype == "revolver" then
		if VJ_PICKRANDOMTABLE(self.DeploySound) == false or force == true then self.DeploySound = {"weapons/draw_pistol.wav"} end
		if VJ_PICKRANDOMTABLE(self.DryFireSound) == false or force == true then self.DryFireSound = {"vj_weapons/dryfire_revolver.wav"} end
		if VJ_PICKRANDOMTABLE(self.NPC_ReloadSound) == false or force == true then self.NPC_ReloadSound = {"vj_weapons/reload_revolver.wav"} end
	elseif curtype == "shotgun" or curtype == "crossbow" then
		if VJ_PICKRANDOMTABLE(self.DeploySound) == false or force == true then self.DeploySound = {"weapons/draw_rifle.wav"} end
		if VJ_PICKRANDOMTABLE(self.DryFireSound) == false or force == true then self.DryFireSound = {"vj_weapons/dryfire_rifle.wav"} end
		if VJ_PICKRANDOMTABLE(self.NPC_ReloadSound) == false or force == true then self.NPC_ReloadSound = {"vj_weapons/reload_shotgun.wav"} end
	elseif curtype == "rpg" then
		if VJ_PICKRANDOMTABLE(self.DeploySound) == false or force == true then self.DeploySound = {"weapons/draw_rifle.wav"} end
		if VJ_PICKRANDOMTABLE(self.DryFireSound) == false or force == true then self.DryFireSound = {"vj_weapons/dryfire_rifle.wav"} end
		if VJ_PICKRANDOMTABLE(self.NPC_ReloadSound) == false or force == true then self.NPC_ReloadSound = {"vj_weapons/reload_rpg.wav"} end
	elseif curtype == "smg" or curtype == "ar2" then
		if VJ_PICKRANDOMTABLE(self.DeploySound) == false or force == true then self.DeploySound = {"weapons/draw_rifle.wav"} end
		if VJ_PICKRANDOMTABLE(self.DryFireSound) == false or force == true then self.DryFireSound = {"vj_weapons/dryfire_rifle.wav"} end
		if VJ_PICKRANDOMTABLE(self.NPC_ReloadSound) == false or force == true then self.NPC_ReloadSound = {"vj_weapons/reload_rifle.wav"} end
	else
		self.DryFireSound = {"vj_weapons/dryfire_rifle.wav"}
		self.NPC_ReloadSound = {"vj_weapons/reload_rifle.wav"}
		self.DeploySound = {"weapons/draw_rifle.wav"}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:TranslateActivity(act)
	if (self.Owner:IsNPC()) then
		if (self.ActivityTranslateAI[act]) && ((!self.Owner.IsVJBaseSNPC) or (self.Owner.IsVJBaseSNPC == true && self.Owner.WeaponHolstered == false)) then
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
function SWEP:NPC_ServerThinkAlways()
	if (CLIENT) then return end
	if !self:IsValid() or !self.Owner:IsValid() then return end
	hook.Remove("AlwaysThink", self)
	hook.Add("AlwaysThink",self,self.NPC_ServerThinkAlways)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:NPC_ServerThink()
	if (CLIENT) then return end
	if !self:IsValid() or !self.Owner:IsValid() then return end
	self:NPC_ServerNextFire()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:NPC_ServerNextFire()
	if (CLIENT) then return end
	if !self:IsValid() && !IsValid(self.Owner) && !self.Owner:IsNPC() then return end
	if self:IsValid() && IsValid(self.Owner) && self.Owner:IsNPC() && self.Owner:GetActivity() == nil then return end

	self:RunWorldModelThink()
	self:CustomOnThink()
	self:CustomOnNPC_ServerThink()

	if self.Owner.IsReloadingWeapon_ServerNextFire == false && self.AlreadyPlayedNPCReloadSound == false && (VJ_IsCurrentAnimation(self.Owner,self.CurrentAnim_WeaponReload) or VJ_IsCurrentAnimation(self.Owner,self.CurrentAnim_ReloadBehindCover) or VJ_IsCurrentAnimation(self.Owner,self.NPC_ReloadAnimationTbl) or VJ_IsCurrentAnimation(self.Owner,self.NPC_ReloadAnimationTbl_Custom) or VJ_IsCurrentAnimation(self.Owner,self.Owner.AnimTbl_WeaponReload)) then
		self.Owner.NextThrowGrenadeT = self.Owner.NextThrowGrenadeT + 2
		self.Owner.IsReloadingWeapon_ServerNextFire = true
		//self.Owner.IsReloadingWeapon = false
		self:CustomOnNPC_Reload()
		self.AlreadyPlayedNPCReloadSound = true
		if self.NPC_HasReloadSound == true then VJ_EmitSound(self.Owner,self.NPC_ReloadSound,self.NPC_ReloadSoundLevel) end
		timer.Simple(3,function() if IsValid(self) then self.AlreadyPlayedNPCReloadSound = false end end)
	end

	local function FireCode()
		self:NPCShoot_Primary(ShootPos,ShootDir)
		//timer.Simple(0.1,function() if self:IsValid() && IsValid(self.Owner) && self.Owner:IsValid() && self.Owner:IsNPC() then self:NPCShoot_Primary(ShootPos,ShootDir) end end)
		//timer.Simple(0.2,function() if self:IsValid() && IsValid(self.Owner) && self.Owner:IsValid() && self.Owner:IsNPC() then self:NPCShoot_Primary(ShootPos,ShootDir) end end)
		hook.Remove("Think", self)
		//print(self.NPC_NextPrimaryFire)
		local nxt = self.NPC_NextPrimaryFire
		if nxt > 0.15 then nxt = 0.15 end
		timer.Simple(nxt, function() hook.Add("Think",self,self.NPC_ServerNextFire) end)
		//self.NPC_NextPrimaryFireT = CurTime() + self.NPC_NextPrimaryFire
		/*if self:IsValid() && self.Owner:IsValid() && self.Owner.IsVJBaseSNPC == true && self.Owner.Weapon_ChangeIdleAnimToShoot == true then
			if IsValid(self.Owner:GetEnemy()) then
				print("CHANGED HOlDTYPE")
				local htype = self:GetHoldType()
				self.ActivityTranslateAI[ACT_IDLE] = ACT_RANGE_ATTACK_PISTOL
				if htype == "ar2" then
					self.ActivityTranslateAI[ACT_IDLE] = ACT_RANGE_ATTACK_AR2
				end
				if htype == "smg" then
					self.ActivityTranslateAI[ACT_IDLE] = ACT_RANGE_ATTACK_SMG1
				end
				if htype == "crossbow" or htype == "shotgun" then
					self.ActivityTranslateAI[ACT_IDLE] = ACT_RANGE_ATTACK_SHOTGUN
				end
				if htype == "rpg" then
					self.ActivityTranslateAI[ACT_IDLE] = ACT_CROUCHIDLE
				end
			end
		else
			print("CHANGED TO NORMAL HOLDTYPE")
			self:SetupWeaponHoldTypeForAI(self:GetHoldType())
		end*/
	end
	//self.Owner:Weapon_TranslateActivity(self.Owner:GetActivity())
	//print(self:TranslateActivity(self.Owner:GetActivity()))
	//print(self.Owner:GetActivity())
	//if self.NPC_UsePistolBehavior == true then
	/*if self:IsValid() && IsValid(self.Owner) && self.Owner:IsValid() && self.Owner:IsNPC() then if self.Owner:GetActivity() != nil then
		if self.Owner:SelectWeightedSequence(self.Owner:GetActivity()) == -1 && self.Owner:GetActivity() != ACT_RANGE_ATTACK1 then
			print("ERROR: VJ Weapon Base was unable to get a correct animation for its owner")
			//self.Owner.DoingWeaponAttack = true
			//self.Owner:VJ_ACT_PLAYACTIVITY(VJ_PICKRANDOMTABLE(self.Owner.AnimTbl_WeaponAttack),false,0,true)
			//return
			end
		end
	end*/
	if self.NPC_NextPrimaryFire != false && self:NPCAbleToShoot() == true then FireCode() end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:NPCAbleToShoot()
	if self:IsValid() && IsValid(self.Owner) && self.Owner:IsValid() && self.Owner:IsNPC() then
		if (self.Owner.IsVJBaseSNPC_Human) then
			local check, ammo = self.Owner:CanDoWeaponAttack()
			if check == false && ammo != "NoAmmo" then return false end
			if IsValid(self.Owner:GetEnemy()) && self.Owner:IsAbleToShootWeapon(true,true) == false then return false end
		end
		if self.Owner:GetActivity() != nil && (VJ_HasValue(self.NPC_AnimationTbl_General,self.Owner:GetActivity()) or VJ_HasValue(self.NPC_AnimationTbl_Rifle,self.Owner:GetActivity()) or VJ_HasValue(self.NPC_AnimationTbl_Pistol,self.Owner:GetActivity()) or VJ_HasValue(self.NPC_AnimationTbl_Shotgun,self.Owner:GetActivity()) or VJ_IsCurrentAnimation(self.Owner,self.NPC_AnimationTbl_Custom)) then
			if (self.Owner.IsVJBaseSNPC_Human) then
				local check, ammo = self.Owner:CanDoWeaponAttack()
				if ammo == "NoAmmo" then
					if self.Owner.VJ_IsBeingControlled == true then self.Owner.VJ_TheController:PrintMessage(HUD_PRINTCENTER,"Press R to reload!") end
					if CurTime() > self.NextNPCDrySoundT then
						local sdtbl = VJ_PICKRANDOMTABLE(self.DryFireSound)
						if sdtbl != false then self.Owner:EmitSound(sdtbl,80,math.random(self.DryFireSoundPitch1,self.DryFireSoundPitch2)) end
						if self.NPC_NextPrimaryFire != false then
							self.NextNPCDrySoundT = CurTime() + self.NPC_NextPrimaryFire
						end
					end
					return false
				else
					if self.Owner:VJ_GetEnemy(true) != nil then
						return true
					end
				end
			else
				if self.Owner:VJ_GetEnemy(true) != nil then
					return true
				end
			end
		end
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:NPC_PlayFiringGesture()
	local customg = VJ_PICKRANDOMTABLE(self.Owner.AnimTbl_WeaponAttackFiringGesture)
	local anim = ""
	if customg != false then
		anim = customg
		anim = VJ_GetSequenceName(self.Owner,anim)
	else
		anim = "gesture_shoot_ar2"
		if self.HoldType == "ar2" then
			anim = "gesture_shoot_ar2"
		elseif self.HoldType == "smg" then
			anim = "gesture_shoot_smg2"
		elseif self.HoldType == "pistol" or self.HoldType == "revolver" then
			if self.Owner:LookupSequence("gesture_shoot_pistol") == -1 then
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
	local gest = self.Owner:AddGestureSequence(self.Owner:LookupSequence(anim))
	self.Owner:SetLayerPriority(gest,2)
	self.Owner:SetLayerPlaybackRate(gest,0.5)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:NPCShoot_Primary(ShootPos,ShootDir)
	//self:SetClip1(self:Clip1() -1)
	//if CurTime() > self.NPC_NextPrimaryFireT then
	//self.NPC_NextPrimaryFireT = CurTime() + self.NPC_NextPrimaryFire
	if (!self:IsValid()) or (!self.Owner:IsValid()) then return end
	if self.Owner.VJ_IsBeingControlled == false && !IsValid(self.Owner:GetEnemy()) then return end
	if self.Owner.VJ_IsBeingControlled == false && (!self.Owner:Visible(self.Owner:GetEnemy())) then return end
	if self.Owner.IsVJBaseSNPC == true then
		//self.Owner.Weapon_TimeSinceLastShot = 0
		self.Owner.NextWeaponAttackAimPoseParametersReset = CurTime() + 1
		self.Owner:WeaponAimPoseParameters()
		//if self.Owner.IsVJBaseSNPC == true then self.Owner.Weapon_TimeSinceLastShot = 0 end
	end
	timer.Simple(self.NPC_TimeUntilFire,function()
		if IsValid(self) && IsValid(self.Owner) && self:NPCAbleToShoot() == true && CurTime() > self.NPC_NextPrimaryFireT then
			if self.Owner.DisableWeaponFiringGesture != true then
				self:NPC_PlayFiringGesture()
			end
			self:PrimaryAttack()
			if self.NPC_NextPrimaryFire != false then
				self.NPC_NextPrimaryFireT = CurTime() + self.NPC_NextPrimaryFire
				for tk, tv in ipairs(self.NPC_TimeUntilFireExtraTimers) do
					timer.Simple(tv, function() if IsValid(self) && IsValid(self.Owner) && self:NPCAbleToShoot() == true then self:PrimaryAttack() end end)
				end
			end
			if self.Owner.IsVJBaseSNPC == true then self.Owner.Weapon_TimeSinceLastShot = 0 end
		end
	end)
	//end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:Precache()
	util.PrecacheSound(self.Primary.Sound)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:GetCapabilities()
	return bit.bor(CAP_WEAPON_RANGE_ATTACK1,CAP_INNATE_RANGE_ATTACK1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:PrimaryAttack(ShootPos,ShootDir)
	//if self.Owner:KeyDown(IN_RELOAD) then return end
	//self.Owner:SetFOV(45, 0.3)
	//if !IsFirstTimePredicted() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	if self.Reloading == true then return end
	if self.Owner:IsNPC() && self.Owner.VJ_IsBeingControlled == false && !IsValid(self.Owner:GetEnemy()) then return end
	if self.Owner:IsPlayer() && self.Primary.AllowFireInWater == false && self.Owner:WaterLevel() == 3 && self.Reloading == false then self.Owner:EmitSound(VJ_PICKRANDOMTABLE(self.DryFireSound),self.DryFireSoundLevel,math.random(self.DryFireSoundPitch1,self.DryFireSoundPitch2)) return end
	if self:Clip1() <= 0 && self.Reloading == false then self.Owner:EmitSound(VJ_PICKRANDOMTABLE(self.DryFireSound),self.DryFireSoundLevel,math.random(self.DryFireSoundPitch1,self.DryFireSoundPitch2)) return end
	if (!self:CanPrimaryAttack()) then return end
	self:CustomOnPrimaryAttack_BeforeShoot()
	if (SERVER) then
		if self.Owner:IsNPC() then
			timer.Simple(self.NPC_ExtraFireSoundTime,function()
				if IsValid(self) && IsValid(self.Owner) then
					VJ_EmitSound(self.Owner,self.NPC_ExtraFireSound,self.NPC_ExtraFireSoundLevel,math.Rand(self.NPC_ExtraFireSoundPitch1,self.NPC_ExtraFireSoundPitch2))
				end
			end)
		end
		local firesd = VJ_PICKRANDOMTABLE(self.Primary.Sound)
		if firesd != false then
			self:EmitSound(firesd, 80, math.random(90,100))
			//sound.Play(firesd,self:GetPos(),80,math.random(90,100))
		end
		if self.Primary.HasDistantSound == true then
			local farsd = VJ_PICKRANDOMTABLE(self.Primary.DistantSound)
			if farsd != false then
				sound.Play(farsd,self:GetPos(),self.Primary.DistantSoundLevel,math.random(self.Primary.DistantSoundPitch1,self.Primary.DistantSoundPitch2),self.Primary.DistantSoundVolume)
			end
		end
	end
	//self:EmitSound(Sound(self.Primary.Sound),80,self.Primary.SoundPitch)
	if self.Primary.DisableBulletCode == false then
		local bullet = {}
			bullet.Num = self.Primary.NumberOfShots
			local spawnpos = self.Owner:GetShootPos()
			if self.Owner:IsNPC() then
				spawnpos = self:GetNWVector("VJ_CurBulletPos")
			end
			//print(spawnpos)
			//VJ_CreateTestObject(spawnpos,self:GetAngles(),Color(0,0,255))
			bullet.Src = spawnpos
			bullet.Dir = self.Owner:GetAimVector()
			bullet.Callback = function(attacker,tr,dmginfo)
				self:CustomOnPrimaryAttack_BulletCallback(attacker,tr,dmginfo)
			end
				/*bullet.Callback = function(attacker, tr, dmginfo)
				local laserhit = EffectData()
				laserhit:SetOrigin(tr.HitPos)
				laserhit:SetNormal(tr.HitNormal)
				laserhit:SetScale(80)
				util.Effect("VJ_Small_Explosion1", laserhit)

				bullet.Callback = function(attacker, tr, dmginfo)
				local laserhit = EffectData()
				laserhit:SetOrigin(tr.HitPos)
				laserhit:SetNormal(tr.HitNormal)
				laserhit:SetScale(25)
				util.Effect("AR2Impact", laserhit)
				end*/
				//tr.HitPos:Ignite(8,0)
				//return true end
			if self.Owner:IsPlayer() then
				bullet.Spread = Vector((self.Primary.Cone /60)/4,(self.Primary.Cone /60)/4,0)
			end
			bullet.Tracer = self.Primary.Tracer
			bullet.TracerName = self.Primary.TracerType
			bullet.Force = self.Primary.Force
			if self.Owner:IsPlayer() then
				if self.Primary.PlayerDamage == "Same" then
					bullet.Damage = self.Primary.Damage
				elseif self.Primary.PlayerDamage == "Double" then
					bullet.Damage = self.Primary.Damage *2
				elseif isnumber(self.Primary.PlayerDamage) then
					bullet.Damage = self.Primary.PlayerDamage
				end
			else
				if self.Owner.IsVJBaseSNPC == true then
					bullet.Damage = self.Owner:VJ_GetDifficultyValue(self.Primary.Damage)
				else
					bullet.Damage = self.Primary.Damage
				end
			end
			bullet.AmmoType = self.Primary.Ammo
			self.Owner:FireBullets(bullet)
	else
		if self.Owner:IsNPC() && self.Owner.IsVJBaseSNPC == true then
			self.Owner.Weapon_ShotsSinceLastReload = self.Owner.Weapon_ShotsSinceLastReload + 1
		end
	end
	if GetConVarNumber("vj_wep_nomuszzleflash") == 0 then self.Owner:MuzzleFlash() end
	self:PrimaryAttackEffects()
	if self.Owner:IsPlayer() then
	self:ShootEffects("ToolTracer")
	self:SendWeaponAnim(VJ_PICKRANDOMTABLE(self.AnimTbl_PrimaryFire))
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Owner:ViewPunch(Angle(-self.Primary.Recoil,0,0)) end
	if !self.Owner:IsNPC() then
		self:TakePrimaryAmmo(self.Primary.TakeAmmo)
	end
	self:CustomOnPrimaryAttack_AfterShoot()
	//self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	timer.Simple(self.NextIdle_PrimaryAttack,function() if self:IsValid() then self:DoIdleAnimation() end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:SecondaryAttack()
	return false -- We don't want a secondary shot
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:DoIdleAnimation()
	if self.HasIdleAnimation == false then return end
	if self.Reloading == true then return end
	self:CustomOnIdle()
	self:SendWeaponAnim(VJ_PICKRANDOMTABLE(self.AnimTbl_Idle))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:PrimaryAttackEffects()
	local customeffects = self:CustomOnPrimaryAttackEffects()
	if customeffects != true then return end
	/*local vjeffectmuz = EffectData()
	vjeffectmuz:SetOrigin(self.Owner:GetShootPos())
	vjeffectmuz:SetEntity(self)
	vjeffectmuz:SetStart(self.Owner:GetShootPos())
	vjeffectmuz:SetNormal(self.Owner:GetAimVector())
	vjeffectmuz:SetAttachment(1)
	util.Effect("VJ_Weapon_RifleMuzzle1",vjeffectmuz)*/

	if self.PrimaryEffects_MuzzleFlash == true && GetConVarNumber("vj_wep_nomuszzleflash") == 0 then
		local muzzleattach = self.PrimaryEffects_MuzzleAttachment
		if isnumber(muzzleattach) == false then muzzleattach = self:LookupAttachment(muzzleattach) end
		if self.Owner:IsPlayer() && self.Owner:GetViewModel() != nil then
			local vjeffectmuz = EffectData()
			vjeffectmuz:SetOrigin(self.Owner:GetShootPos())
			vjeffectmuz:SetEntity(self)
			vjeffectmuz:SetStart(self.Owner:GetShootPos())
			vjeffectmuz:SetNormal(self.Owner:GetAimVector())
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
				ParticleEffectAttach(VJ_PICKRANDOMTABLE(self.PrimaryEffects_MuzzleParticles),PATTACH_POINT_FOLLOW,self,muzzleattach)
			end
		end
	end

	if self.PrimaryEffects_SpawnShells == true && !self.Owner:IsPlayer() && GetConVarNumber("vj_wep_nobulletshells") == 0 then
		local shellattach = self.PrimaryEffects_ShellAttachment
		if isnumber(shellattach) == false then shellattach = self:LookupAttachment(shellattach) end
		local vjeffect = EffectData()
		vjeffect:SetEntity(self)
		vjeffect:SetOrigin(self.Owner:GetShootPos())
		vjeffect:SetNormal(self.Owner:GetAimVector())
		vjeffect:SetAttachment(shellattach)
		util.Effect(self.PrimaryEffects_ShellType,vjeffect)
	end

	if SERVER && self.PrimaryEffects_SpawnDynamicLight == true && GetConVarNumber("vj_wep_nomuszzleflash") == 0 && GetConVarNumber("vj_wep_nomuszzleflash_dynamiclight") == 0 then
		local FireLight1 = ents.Create("light_dynamic")
		FireLight1:SetKeyValue("brightness", self.PrimaryEffects_DynamicLightBrightness)
		FireLight1:SetKeyValue("distance", self.PrimaryEffects_DynamicLightDistance)
		if self.Owner:IsPlayer() then FireLight1:SetLocalPos(self.Owner:GetShootPos() +self:GetForward()*40 + self:GetUp()*-10) else FireLight1:SetLocalPos(self:GetAttachment(1).Pos) end
		FireLight1:SetLocalAngles(self:GetAngles())
		FireLight1:Fire("Color", self.PrimaryEffects_DynamicLightColor.r.." "..self.PrimaryEffects_DynamicLightColor.g.." "..self.PrimaryEffects_DynamicLightColor.b)
		FireLight1:SetParent(self)
		FireLight1:Spawn()
		FireLight1:Activate()
		FireLight1:Fire("TurnOn","",0)
		FireLight1:Fire("Kill","",0.07)
		self:DeleteOnRemove(FireLight1)
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
	//if CurTime() > self.NextIdleT then
	//self:SendWeaponAnim(ACT_VM_IDLE)
	//self.NextIdleT = CurTime() + self.NextIdleTime
	//end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:Reload()
if !IsValid(self) or !IsValid(self.Owner) or !self.Owner:Alive() or !self.Owner:IsPlayer() or self.Owner:GetAmmoCount(self.Primary.Ammo) == 0 or !self.Owner:KeyDown(IN_RELOAD) or self.Reloading == true then return end
	local smallerthanthis = self.Primary.ClipSize - 1
	if self:Clip1() <= smallerthanthis then
		local setcorrectnum = self.Primary.ClipSize - self:Clip1()
		local test = setcorrectnum + self:Clip1()
		self.Reloading = true
		self:CustomOnReload()
		if self.HasReloadSound == true then self.Owner:EmitSound(VJ_PICKRANDOMTABLE(self.ReloadSound),50,math.random(90,100)) end
		if self.Owner:IsPlayer() then
			self:SendWeaponAnim(VJ_PICKRANDOMTABLE(self.AnimTbl_Reload)) //self:SendWeaponAnim(VJ_PICKRANDOMTABLE(self.AnimTbl_Reload))
			self.Owner:SetAnimation(PLAYER_RELOAD)
			timer.Simple(self.Reload_TimeUntilAmmoIsSet,function() if self:IsValid() then self.Owner:RemoveAmmo(setcorrectnum,self.Primary.Ammo) self:SetClip1(test) end end)
			timer.Simple(self.Reload_TimeUntilFinished,function() if self:IsValid() then self.Reloading = false self:DoIdleAnimation() end end)
		end
		return true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:Deploy()
	if self.InitHasIdleAnimation == true then self.HasIdleAnimation = true end
	if self.Owner:IsPlayer() then
	self:CustomOnDeploy()
	self:SendWeaponAnim(VJ_PICKRANDOMTABLE(self.AnimTbl_Deploy))
	if self.HasDeploySound == true then
	self:EmitSound(VJ_PICKRANDOMTABLE(self.DeploySound),50,math.random(90,100)) end
	self:SetNextPrimaryFire(CurTime() +self.DelayOnDeploy) end
	timer.Simple(self.NextIdle_Deploy,function() if self:IsValid() then self:DoIdleAnimation() end end)
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
	if self.Owner:IsPlayer() then
		if self.Primary.PickUpAmmoAmount == "Default" then
			self.Owner:GiveAmmo(self.Primary.ClipSize*2,self.Primary.Ammo)
		elseif isnumber(self.Primary.PickUpAmmoAmount) then
			self.Owner:GiveAmmo(self.Primary.PickUpAmmoAmount,self.Primary.Ammo)
		end
		//self.Owner:RemoveAmmo(self.Primary.DefaultClip,self.Primary.Ammo)
		if self.MadeForNPCsOnly == true then
			self.Owner:PrintMessage(HUD_PRINTTALK,self.PrintName.." removed! It's made for NPCs only!")
			self:Remove()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:EquipAmmo(ply)
	if ply:IsPlayer() then
		ply:GiveAmmo(self.Primary.ClipSize,self.Primary.Ammo)
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
	if self.Owner:LookupBone(self.WorldModel_CustomPositionBone) == nil then return nil end
	pos, ang = self.Owner:GetBonePosition(self.Owner:LookupBone(self.WorldModel_CustomPositionBone))
	ang:RotateAroundAxis(ang:Right(), self.WorldModel_CustomPositionAngle.x)
	ang:RotateAroundAxis(ang:Up(), self.WorldModel_CustomPositionAngle.y)
	ang:RotateAroundAxis(ang:Forward(), self.WorldModel_CustomPositionAngle.z)
	pos = pos + self.WorldModel_CustomPositionOrigin.x * ang:Right()
	pos = pos + self.WorldModel_CustomPositionOrigin.y * ang:Forward()
	pos = pos + self.WorldModel_CustomPositionOrigin.z * ang:Up()
	return {pos=pos,ang=ang}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:RunWorldModelThink()
	self:SetNWBool("VJ_WorldModel_Invisible",self.WorldModel_Invisible)
	
	if self.WorldModel_UseCustomPosition == true then
		local weppos = self:GetWeaponCustomPosition()
		if weppos == nil then return end
		self:SetPos(weppos.pos)
		self:SetAngles(weppos.ang)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:DecideBulletPosition()
	if !IsValid(self.Owner) then return nil end
	if !self.Owner:IsNPC() then return self.Owner:GetShootPos() end
	local customPos = self:CustomBulletSpawnPosition()
	if customPos != false then
		return customPos
	end
	if self.NPC_BulletSpawnAttachment != "" then
		if self:LookupAttachment(self.NPC_BulletSpawnAttachment) == 0 or self:LookupAttachment(self.NPC_BulletSpawnAttachment) == -1 then
			-- blah
		else
			hascustom = true
			return self:GetAttachment(self:LookupAttachment(self.NPC_BulletSpawnAttachment)).Pos
		end
	end
	local getmuzzle;
	//local numattachments = self:GetAttachments()
	local numattachments = #self:GetAttachments()
	if (self:IsValid()) then
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
			if self.Owner:LookupBone("ValveBiped.Bip01_R_Hand") != nil then
				return self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
			else
				print("WARNING: "..self:GetClass().." doesn't have a proper attachment or bone for bullet spawn!")
				return self.Owner:EyePos()
			end
		end
		//print("It has a proper attachment.")
		return self:GetAttachment(self:LookupAttachment(getmuzzle)).Pos //+ self.Owner:GetUp()*-45
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
if (SERVER) then
	util.AddNetworkString("vj_weapon_curbulletpos")

	net.Receive("vj_weapon_curbulletpos",function(len,pl)
		vec = net.ReadVector()
		ent = net.ReadEntity()
		ent:SetNWVector("VJ_CurBulletPos",vec)
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
	function SWEP:DrawWorldModel()
		if !IsValid(self) then return end
		
		if self:CustomOnDrawWorldModel() == false then return end
		
		if self:GetNWBool("VJ_WorldModel_Invisible") == true then return end
		
		if self.WorldModel_NoShadow == true then
			self:DrawShadow(false)
		end
		//self:DrawModel()
		local pos = self:DecideBulletPosition()
		if pos != nil && IsValid(self.Owner) then
			net.Start("vj_weapon_curbulletpos")
			net.WriteVector(pos)
			net.WriteEntity(self)
			net.SendToServer()
		end
		//self:SetNWVector("VJ_CurBulletPos",self:GetAttachment(self:LookupAttachment("muzzle")).Pos)
		if self.WorldModel_UseCustomPosition == true then
			if IsValid(self.Owner) then
				if self.Owner:IsPlayer() && self.Owner:InVehicle() then return end
				local weppos = self:GetWeaponCustomPosition()
				if weppos == nil then return end
				self:SetRenderOrigin(weppos.pos)
				self:SetRenderAngles(weppos.ang)
				self:FrameAdvance(FrameTime())
				self:SetupBones()
				self:DrawModel()
			else
				self:SetRenderOrigin(nil)
				self:SetRenderAngles(nil)
				self:DrawModel()
			end
		else
			self:DrawModel()
		end
	end
end