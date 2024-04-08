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
SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.UseHands = false -- Should this weapon use Garry's Mod hands? (The model must support it!)
SWEP.ViewModelFlip = false -- Flip the model? Usually used for CS:S models
SWEP.ViewModelFOV = 55 -- Player FOV for the view model
SWEP.BobScale = 1.5 -- Bob effect when moving
SWEP.SwayScale = 1 -- Default is 1, The scale of the viewmodel sway
SWEP.CSMuzzleFlashes = false -- Recommended to enable for Counter Strike: Source models
SWEP.DrawAmmo = true -- Draw regular Garry's Mod HUD?
SWEP.DrawCrosshair = true -- Draw Crosshair?
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ World Model Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SWEP.WorldModel = "models/weapons/w_rif_ak47.mdl"
SWEP.WorldModel_UseCustomPosition = false -- Should the gun use custom position? This can be used to fix guns that are in the crotch
SWEP.WorldModel_CustomPositionAngle = Vector(0, 0, 0)
SWEP.WorldModel_CustomPositionOrigin = Vector(0, 0, 0)
SWEP.WorldModel_CustomPositionBone = "ValveBiped.Bip01_R_Hand" -- The bone it will use as the main point (Owner's bone)
SWEP.WorldModel_Invisible = false -- Should the world model be invisible?
SWEP.WorldModel_NoShadow = false -- Should the world model have a shadow?
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ General NPC Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Set this to false to disable the timer automatically running the firing code, this allows for event-based SNPCs to fire at their own pace:
SWEP.NPC_NextPrimaryFire = 0.1 -- Next time it can use primary fire
	-- Note: Melee weapons automatically change this number!
SWEP.NPC_TimeUntilFire = 0.1 -- How much time until the bullet/projectile is fired?
SWEP.NPC_TimeUntilFireExtraTimers = {} -- Extra timers, which will make the gun fire again! | The seconds are counted after the self.NPC_TimeUntilFire!
SWEP.NPC_CustomSpread = 1 -- This is added on top of the custom spread that's set inside the SNPC! | Starting from 1: Closer to 0 = better accuracy, Farther than 1 = worse accuracy
SWEP.NPC_BulletSpawnAttachment = "" -- The attachment that the bullet spawns on, leave empty for base to decide!
SWEP.NPC_CanBePickedUp = true -- Can this weapon be picked up by NPCs? (Ex: Rebels)
SWEP.NPC_StandingOnly = false -- If true, the weapon can only be fired if the NPC is standing still
	-- ====== Firing Distance ====== --
SWEP.NPC_FiringDistanceScale = 1 -- Changes how far the NPC can fire | 1 = No change, x < 1 = closer, x > 1 = farther
SWEP.NPC_FiringDistanceMax = 100000 -- Maximum firing distance | Clamped at the maximum sight distance of the NPC
	-- ====== Reload Variables ====== --
SWEP.NPC_HasReloadSound = true -- Should it play a sound when the base detects the SNPC playing a reload animation?
SWEP.NPC_ReloadSound = {} -- Sounds it plays when the base detects the SNPC playing a reload animation
SWEP.NPC_ReloadSoundLevel = 60 -- How far does the sound go?
	-- ====== Before Fire Sound Variables ====== --
	-- NOTE: This only works with VJ Human SNPCs!
SWEP.NPC_BeforeFireSound = {} -- Plays a sound before the firing code is ran, usually in the beginning of the animation
SWEP.NPC_BeforeFireSoundLevel = 70 -- How far does the sound go?
SWEP.NPC_BeforeFireSoundPitch = VJ.SET(90, 100) -- How much time until the secondary fire can be used again?
	-- ====== Extra Firing Sound Variables ====== --
SWEP.NPC_ExtraFireSound = {} -- Plays an extra sound after it fires (Example: Bolt action sound)
SWEP.NPC_ExtraFireSoundTime = 0.4 -- How much time until it plays the sound (After Firing)?
SWEP.NPC_ExtraFireSoundLevel = 70 -- How far does the sound go?
SWEP.NPC_ExtraFireSoundPitch = VJ.SET(90, 100) -- How much time until the secondary fire can be used again?
	-- ====== Secondary Fire Variables ====== --
SWEP.NPC_HasSecondaryFire = false -- Can the weapon have a secondary fire?
SWEP.NPC_SecondaryFireEnt = "obj_vj_grenade_rifle" -- The entity to fire, this only applies if self:NPC_SecondaryFire() has NOT been overridden!
SWEP.NPC_SecondaryFireChance = 3 -- Chance that the secondary fire is used | 1 = always
SWEP.NPC_SecondaryFireNext = VJ.SET(12, 15) -- How much time until the secondary fire can be used again?
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
SWEP.AnimTbl_Deploy = {ACT_VM_DRAW}
SWEP.HasDeploySound = true -- Does the weapon have a deploy sound?
SWEP.DeploySound = {} -- Sound played when the weapon is deployed
	-- ====== Idle Variables ====== --
SWEP.HasIdleAnimation = true -- Does it have a idle animation?
SWEP.AnimTbl_Idle = {ACT_VM_IDLE}
	-- ====== Reload Variables ====== --
SWEP.HasReloadSound = false -- Does it have a reload sound? Remember even if this is set to false, the animation sound will still play!
SWEP.ReloadSound = {}
SWEP.AnimTbl_Reload = {ACT_VM_RELOAD}
SWEP.Reload_TimeUntilAmmoIsSet = 1 -- Time until ammo is set to the weapon
	-- ====== Secondary Fire Variables ====== --
SWEP.Secondary.Automatic = false -- Is it automatic?
SWEP.Secondary.Ammo = "none" -- Ammo type
SWEP.Secondary.TakeAmmo = 1 -- How much ammo should it take on each shot?
	-- To let the base automatically detect the animation duration, set this to false:
SWEP.Secondary.Delay = false -- Time until it can shoot again
SWEP.AnimTbl_SecondaryFire = {ACT_VM_SECONDARYATTACK}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Dry Fire Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Examples: Under water, out of ammo
SWEP.HasDryFireSound = true -- Should it play a sound when it's out of ammo?
SWEP.DryFireSound = {} -- The sound that it plays when the weapon is out of ammo
SWEP.DryFireSoundLevel = 50 -- Dry fire sound level
SWEP.DryFireSoundPitch = VJ.SET(90, 100) -- Dry fire sound pitch
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
SWEP.Primary.Tracer = 1 -- Show tracer for every x bullets
SWEP.Primary.TracerType = "Tracer" -- Tracer type (Examples: AR2)
SWEP.Primary.TakeAmmo = 1 -- How much ammo should it take from the clip after each shot? | 0 = Unlimited clip
SWEP.Primary.Automatic = true -- Is it automatic?
SWEP.Primary.Ammo = "SMG1" -- Ammo type
SWEP.AnimTbl_PrimaryFire = {ACT_VM_PRIMARYATTACK}
	-- ====== Sound Variables ====== --
SWEP.Primary.Sound = {}
SWEP.Primary.SoundLevel = 80
SWEP.Primary.SoundPitch	= VJ.SET(90, 100)
SWEP.Primary.SoundVolume = 1
SWEP.Primary.DistantSound = {}
SWEP.Primary.HasDistantSound = true -- Does it have a distant sound when the gun is shot?
SWEP.Primary.DistantSoundLevel = 140 -- Distant sound level
SWEP.Primary.DistantSoundPitch	= VJ.SET(90, 110) -- Distant sound pitch
SWEP.Primary.DistantSoundVolume	= 1 -- Distant sound volume
	-- ====== Effect Variables ====== --
SWEP.PrimaryEffects_MuzzleFlash = true
SWEP.PrimaryEffects_MuzzleParticles = {"vj_rifle_full"}
SWEP.PrimaryEffects_MuzzleParticlesAsOne = false -- If set to true, the base will spawn all the given particles instead of picking one
SWEP.PrimaryEffects_MuzzleAttachment = "muzzle"
SWEP.PrimaryEffects_SpawnShells = true
SWEP.PrimaryEffects_ShellAttachment = "shell"
SWEP.PrimaryEffects_ShellType = "RifleShellEject" -- Pistol = ShellEject | Rifle = RifleShellEject | Shotgun = ShotgunShellEject
SWEP.PrimaryEffects_SpawnDynamicLight = true
SWEP.PrimaryEffects_DynamicLightBrightness = 4
SWEP.PrimaryEffects_DynamicLightDistance = 120
SWEP.PrimaryEffects_DynamicLightColor = Color(255, 150, 60)
	-- ====== Melee Variables ====== --
SWEP.IsMeleeWeapon = false -- Should this weapon be a melee weapon?
SWEP.MeleeWeaponDistance = 100 -- If it's this close, it will attack
SWEP.MeleeWeaponSound_Hit = {"physics/flesh/flesh_impact_bullet1.wav"} -- Sound it plays when it hits something
SWEP.MeleeWeaponSound_Miss = {"weapons/iceaxe/iceaxe_swing1.wav"} -- Sound it plays when it misses (Doesn't hit anything)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Customization Functions ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Use the functions below to customize certain parts of the base or to add new custom systems
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnInitialize() end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnEquip(newOwner) end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnThink() end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnReload() end
---------------------------------------------------------------------------------------------------------------------------------------------
-- Unlike CustomOnReload(), this is called AFTER the reload animation has finished
-- This only works for players and VJ Humans!
function SWEP:CustomOnReload_Finish() return true end -- Return false to to override base code
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttack_BeforeShoot() end -- Return true to not run rest of the firing code
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttack_AfterShoot() end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttack_MeleeHit(ent) end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttack_BulletCallback(attacker, tr, dmginfo) end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttackEffects(owner) return true end -- Return false to disable the base effects
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:NPC_SecondaryFire_BeforeTimer(eneEnt, fireTime) end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:NPC_SecondaryFire()
	-- Override this function if you want to make your own secondary attack!
	local owner = self:GetOwner()
	local spawnPos = self:GetNW2Vector("VJ_CurBulletPos")
	local projectile = ents.Create(self.NPC_SecondaryFireEnt)
	projectile:SetPos(spawnPos)
	projectile:SetAngles(owner:GetAngles())
	projectile:SetOwner(owner)
	projectile:Spawn()
	projectile:Activate()
	local phys = projectile:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		local vel = owner:CalculateProjectile("Line", spawnPos, owner:GetAimPosition(owner:GetEnemy(), spawnPos, 1, 1000), 1000)
		phys:SetVelocity(vel)
		projectile:SetAngles(vel:GetNormal():Angle())
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnSecondaryAttack() return true end -- Players only! | Return false to override base code
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomBulletSpawnPosition() return false end -- Return a position to override the bullet spawn position
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnFireAnimationEvent(pos, ang, event, options) return false end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnDrawWorldModel() return true end -- Return false to not draw the world model | This is client side only!
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnDeploy() end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnIdle() end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnHolster(newWep) return true end -- Return false to disallow the weapon from switching
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
SWEP.NextReloadT = 0
SWEP.NextIdleT = 0
SWEP.InitHasIdleAnimation = false
SWEP.Primary.DefaultClip = 0
SWEP.NextNPCDrySoundT = 0
SWEP.NPC_NextPrimaryFireT = 0
SWEP.NPC_AnimationSet = VJ.ANIM_SET_CUSTOM
SWEP.NPC_SecondaryFireNextT = 0
SWEP.LastOwner = NULL
SWEP.InitTime = 0 -- Holds the CurTime that it was spawned at, used to make sure spawned weapons can be given to the player without needing to press USE on it

local cv_muszzleflash = GetConVar("vj_wep_nomuszzleflash")
local cv_dynamiclight = GetConVar("vj_wep_nomuszzleflash_dynamiclight")
local cv_bulletshells = GetConVar("vj_wep_nobulletshells")
---------------------------------------------------------------------------------------------------------------------------------------------
-- !!!!!!!!!!!!!! DO NOT USE THIS VARIABLE !!!!!!!!!!!!!! [Backwards Compatibility!]
	-- Basically if someone is retrieving "VJ_CurBulletPos" using NW, it will convert it to NW2 otherwise it just runs the regular code
local wepMETA = FindMetaTable("Weapon")
local old_GetNWVector = FindMetaTable("Entity").GetNWVector
function wepMETA:GetNWVector(name, default)
	if name == "VJ_CurBulletPos" then
		return self:GetNW2Vector("VJ_CurBulletPos", default)
	end
	return old_GetNWVector(self, name, default)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:GetCapabilities()
	return bit.bor(CAP_WEAPON_RANGE_ATTACK1, CAP_INNATE_RANGE_ATTACK1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local oldShells = {VJ_Weapon_PistolShell1 = "ShellEject", VJ_Weapon_RifleShell1 = "RifleShellEject", VJ_Weapon_ShotgunShell1 = "ShotgunShellEject"} -- !!!!!!!!!!!!!! DO NOT USE THESE VALUES !!!!!!!!!!!!!! [Backwards Compatibility!]
--
function SWEP:Initialize()
	self.InitTime = CurTime()
	self.PrimaryEffects_ShellType = oldShells[self.PrimaryEffects_ShellType] or self.PrimaryEffects_ShellType -- !!!!!!!!!!!!!! DO NOT USE THESE VALUES !!!!!!!!!!!!!! [Backwards Compatibility!]
	self:SetNW2Vector("VJ_CurBulletPos", self:GetPos())
	self:SetHoldType(self.HoldType)
	if self.HasIdleAnimation == true then self.InitHasIdleAnimation = true end
	self.NPC_SecondaryFireNextT = CurTime() + math.Rand(self.NPC_SecondaryFireNext.a, self.NPC_SecondaryFireNext.b)
	self:CustomOnInitialize()
	if SERVER then
		//self:SetWeaponHoldType(self.HoldType)
		self:SetNPCMinBurst(10)
		self:SetNPCMaxBurst(20)
		self:SetNPCFireRate(10)
	end
	self:SetDefaultValues(self.HoldType)
	//self:SetKeyValue("spawnflags", bit.bor(SF_WEAPON_NO_PLAYER_PICKUP))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:Equip(newOwner)
	-- Do NOT set the clip if this is simply a weapon switch (Specifically for VJ NPCs)
	if self.LastOwner == NULL then
		self:SetClip1(self.Primary.ClipSize)
	end
	if newOwner:IsPlayer() then
		if self.Primary.PickUpAmmoAmount == "Default" then
			newOwner:GiveAmmo(self.Primary.ClipSize * 2, self.Primary.Ammo)
		elseif isnumber(self.Primary.PickUpAmmoAmount) then
			newOwner:GiveAmmo(self.Primary.PickUpAmmoAmount, self.Primary.Ammo)
		end
		//newOwner:RemoveAmmo(self.Primary.DefaultClip,self.Primary.Ammo)
		if self.MadeForNPCsOnly == true then
			newOwner:PrintMessage(HUD_PRINTTALK, self.PrintName.." removed! It's made for NPCs only!")
			self:Remove()
		end
	elseif newOwner:IsNPC() then
		-- For default HL2 NPCs
		if VJ.AnimExists(newOwner,ACT_WALK_AIM_PISTOL) == true && VJ.AnimExists(newOwner,ACT_RUN_AIM_PISTOL) == true && VJ.AnimExists(newOwner,ACT_POLICE_HARASS1) == true then
			self.NPC_AnimationSet = VJ.ANIM_SET_METROCOP
		elseif VJ.AnimExists(newOwner,"cheer1") == true && VJ.AnimExists(newOwner,"wave_smg1") == true && VJ.AnimExists(newOwner,ACT_BUSY_SIT_GROUND) == true then
			self.NPC_AnimationSet = VJ.ANIM_SET_REBEL
		elseif VJ.AnimExists(newOwner,"signal_takecover") == true && VJ.AnimExists(newOwner,"grenthrow") == true && VJ.AnimExists(newOwner,"bugbait_hit") == true then
			self.NPC_AnimationSet = VJ.ANIM_SET_COMBINE
		end

		if newOwner:GetClass() == "npc_citizen" then newOwner:Fire("DisableWeaponPickup") end -- If it's a citizen, disable them picking up weapons from the ground
		newOwner:SetKeyValue("spawnflags", "256") -- Long Visibility Shooting since HL2 NPCs are blind
		hook.Add("Think", self, self.NPC_ServerNextFire)
		
		if newOwner.IsVJBaseSNPC && newOwner.IsVJBaseSNPC_Human == true then
			newOwner.Weapon_OriginalFiringDistanceFar = newOwner.Weapon_OriginalFiringDistanceFar or newOwner.Weapon_FiringDistanceFar
			if self.IsMeleeWeapon == true then
				newOwner.Weapon_FiringDistanceFar = self.MeleeWeaponDistance
			else
				newOwner.Weapon_FiringDistanceFar = math.Clamp(newOwner.Weapon_OriginalFiringDistanceFar * self.NPC_FiringDistanceScale, newOwner.Weapon_FiringDistanceClose, self.NPC_FiringDistanceMax)
			end
		end
	end
	self:CustomOnEquip(newOwner)
	self.LastOwner = newOwner
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:SetDefaultValues(holdType)
	holdType = holdType or "ar2"
	if holdType == "pistol" then
		if VJ.PICK(self.DeploySound) == false then self.DeploySound = {"weapons/draw_pistol.wav"} end
		if VJ.PICK(self.DryFireSound) == false then self.DryFireSound = {"vj_weapons/dryfire_pistol.wav"} end
		if VJ.PICK(self.NPC_ReloadSound) == false then self.NPC_ReloadSound = {"vj_weapons/reload_pistol.wav"} end
	elseif holdType == "revolver" then
		if VJ.PICK(self.DeploySound) == false then self.DeploySound = {"weapons/draw_pistol.wav"} end
		if VJ.PICK(self.DryFireSound) == false then self.DryFireSound = {"vj_weapons/dryfire_revolver.wav"} end
		if VJ.PICK(self.NPC_ReloadSound) == false then self.NPC_ReloadSound = {"vj_weapons/reload_revolver.wav"} end
	elseif holdType == "shotgun" or holdType == "crossbow" then
		if VJ.PICK(self.DeploySound) == false then self.DeploySound = {"weapons/draw_rifle.wav"} end
		if VJ.PICK(self.DryFireSound) == false then self.DryFireSound = {"vj_weapons/dryfire_rifle.wav"} end
		if VJ.PICK(self.NPC_ReloadSound) == false then self.NPC_ReloadSound = {"vj_weapons/reload_shotgun.wav"} end
	elseif holdType == "rpg" then
		if VJ.PICK(self.DeploySound) == false then self.DeploySound = {"weapons/draw_rifle.wav"} end
		if VJ.PICK(self.DryFireSound) == false then self.DryFireSound = {"vj_weapons/dryfire_rifle.wav"} end
		if VJ.PICK(self.NPC_ReloadSound) == false then self.NPC_ReloadSound = {"vj_weapons/reload_rpg.wav"} end
	elseif holdType == "smg" or holdType == "ar2" then
		if VJ.PICK(self.DeploySound) == false then self.DeploySound = {"weapons/draw_rifle.wav"} end
		if VJ.PICK(self.DryFireSound) == false then self.DryFireSound = {"vj_weapons/dryfire_rifle.wav"} end
		if VJ.PICK(self.NPC_ReloadSound) == false then self.NPC_ReloadSound = {"vj_weapons/reload_rifle.wav"} end
	elseif holdType == "melee" or holdType == "melee2" or holdType == "knife" then
		self.DeploySound = {"weapons/draw_rifle.wav"}
		self.HasDryFireSound = false
		self.NPC_HasReloadSound = false
	else
		self.DeploySound = {"weapons/draw_rifle.wav"}
		self.DryFireSound = {"vj_weapons/dryfire_rifle.wav"}
		self.NPC_ReloadSound = {"vj_weapons/reload_rifle.wav"}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:TranslateActivity(act)
	local owner = self:GetOwner()
	if (owner:IsNPC()) then
		if owner.IsVJBaseSNPC == true then
			local wepT = owner.AnimationTranslations[act]
			if (wepT) then
				if istable(wepT) then
					return VJ.PICK(wepT)
				end
				return wepT
			end
		elseif (self.ActivityTranslateAI[act]) then -- For non-VJ NPCs
			return self.ActivityTranslateAI[act]
		end
		return -1
	end
	
	-- For non-NPCs
	if (self.ActivityTranslate[act] != nil) then
		return self.ActivityTranslate[act]
	end
	return -1
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CanBePickedUpByNPCs()
	return self.NPC_CanBePickedUp
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:NPC_ServerNextFire()
	if !IsValid(self) then return end
	local owner = self:GetOwner()
	if !IsValid(owner) or !owner:IsNPC() or owner:GetActiveWeapon() != self then return end
	
	if !self.IsMeleeWeapon then
		local pos = self:DecideBulletPosition()
		if pos != nil then
			self:SetNW2Vector("VJ_CurBulletPos", pos)
		end
	end
	
	if !owner:GetActivity() then return end
	
	//print("------------------")
	//print(CurTime())
	//VJ.DEBUG_TempEnt(self:DecideBulletPosition(), self:GetAngles(), Color(255,0,255), 1)
	//VJ.DEBUG_TempEnt(self:GetNW2Vector("VJ_CurBulletPos"), self:GetAngles(), Color(0,0,255), 1)

	self:RunWorldModelThink()
	self:CustomOnThink()
	
	if self.NPC_NextPrimaryFire != false && self:NPCAbleToShoot() == true then
		self:NPCShoot_Primary() -- Panpoushde zarg
		hook.Remove("Think", self)
		//print(self.NPC_NextPrimaryFire)
		local nxt = self.NPC_NextPrimaryFire
		if nxt > 0.15 then nxt = 0.15 end -- Yete nxt aveli medz e 0.15, ere vor 0.15 ela
		timer.Simple(nxt, function()
			-- Had to add "isfunction" check because after GMod devs applied this: https://github.com/Facepunch/garrysmod/pull/1344
			-- It will VERY rarely think self.NPC_ServerNextFire is nil, why? No one knows, the error never appeared for me, but it has appeared 1-2 for some people.
			-- I would rather have a function that fails silently then fail 1 in 999,999 times without actual reason, so does this check avoid it? (I don't know...)
			if IsValid(self) then
				hook.Add("Think", self, function()
					if isfunction(self.NPC_ServerNextFire) then
						self:NPC_ServerNextFire()
					end
				end)
			end
		end)
		//self.NPC_NextPrimaryFireT = CurTime() + self.NPC_NextPrimaryFire
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:NPCAbleToShoot()
	local owner = self:GetOwner()
	if IsValid(owner) && owner:IsNPC() then
		local ene = owner:GetEnemy()
		if (owner.IsVJBaseSNPC_Human && IsValid(ene) && owner:IsAbleToShootWeapon(true, true) == false) or (self.NPC_StandingOnly == true && owner:IsMoving()) then
			return false
		end
		if owner:GetActivity() != nil && ((owner.IsVJBaseSNPC_Human && owner.DoingWeaponAttack && (VJ.IsCurrentAnimation(owner, owner:TranslateActivity(owner.CurrentWeaponAnimation)) or (!owner.DoingWeaponAttack_Standing))) or (!owner.IsVJBaseSNPC_Human)) then
			-- For VJ Humans only, ammo check
			if owner.IsVJBaseSNPC_Human && owner.AllowWeaponReloading == true && self:Clip1() <= 0 then -- No ammo!
				if owner.VJ_IsBeingControlled == true then owner.VJ_TheController:PrintMessage(HUD_PRINTCENTER, "Press R to reload!") end
				if self.IsMeleeWeapon == false && self.HasDryFireSound == true && CurTime() > self.NextNPCDrySoundT then
					local sdTbl = VJ.PICK(self.DryFireSound)
					if sdTbl != false then owner:EmitSound(sdTbl, 80, math.random(self.DryFireSoundPitch.a, self.DryFireSoundPitch.b)) end
					if self.NPC_NextPrimaryFire != false then
						self.NextNPCDrySoundT = CurTime() + self.NPC_NextPrimaryFire
					end
				end
				return false
			end
			if IsValid(ene) && ((!owner.VJ_IsBeingControlled) or (owner.VJ_IsBeingControlled && owner.VJ_TheController:KeyDown(IN_ATTACK2))) then
				return true
			end
		end
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:NPCShoot_Primary()
	local owner = self:GetOwner()
	if !IsValid(owner) then return end
	local ene = owner:GetEnemy()
	if !owner.VJ_IsBeingControlled && (!IsValid(ene) or (!owner:Visible(ene))) then return end
	if owner.IsVJBaseSNPC == true then
		owner:DoPoseParameterLooking()
	end
	
	-- Secondary Fire
	if self.NPC_HasSecondaryFire && owner.CanUseSecondaryOnWeaponAttack && CurTime() > self.NPC_SecondaryFireNextT && ene:GetPos():Distance(owner:GetPos()) <= self.NPC_SecondaryFireDistance then
		if math.random(1, self.NPC_SecondaryFireChance) == 1 then
			local anim, animDur = owner:VJ_ACT_PLAYACTIVITY(VJ.PICK(owner.AnimTbl_WeaponAttackSecondary), true, false, true)
			local fireTime = (anim == ACT_INVALID and 0) or owner.WeaponAttackSecondaryTimeUntilFire or animDur
				-- If no animation was found then fireTime is 0, otherwise if "WeaponAttackSecondaryTimeUntilFire" is false then use animation time
			self:NPC_SecondaryFire_BeforeTimer(ene, fireTime)
			timer.Simple(fireTime, function()
				if IsValid(self) && IsValid(owner) && IsValid(owner:GetEnemy()) && CurTime() > self.NPC_SecondaryFireNextT && (anim == ACT_INVALID or (anim && VJ.IsCurrentAnimation(owner, anim))) then -- ONLY check for cur anim IF it even had one!
					self:NPC_SecondaryFire()
					if self.NPC_HasSecondaryFireSound == true then VJ.EmitSound(owner, self.NPC_SecondaryFireSound, self.NPC_SecondaryFireSoundLevel) end
					self.NPC_SecondaryFireNextT = CurTime() + math.Rand(self.NPC_SecondaryFireNext.a, self.NPC_SecondaryFireNext.b)
				end
			end)
			return
		else
			self.NPC_SecondaryFireNextT = CurTime() + math.Rand(self.NPC_SecondaryFireNext.a, self.NPC_SecondaryFireNext.b)
		end
	end
	
	-- Primary Fire
	timer.Simple(self.NPC_TimeUntilFire, function()
		if IsValid(self) && IsValid(owner) && self:NPCAbleToShoot() == true && CurTime() > self.NPC_NextPrimaryFireT then
			self:PrimaryAttack()
			if self.NPC_NextPrimaryFire != false then -- Support for animation events
				self.NPC_NextPrimaryFireT = CurTime() + self.NPC_NextPrimaryFire
				for _, tv in ipairs(self.NPC_TimeUntilFireExtraTimers) do
					timer.Simple(tv, function() if IsValid(self) && IsValid(owner) && self:NPCAbleToShoot() == true then self:PrimaryAttack() end end)
				end
			end
			if owner.IsVJBaseSNPC == true then owner.Weapon_TimeSinceLastShot = CurTime() end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:NPC_Reload()
	local owner = self:GetOwner()
	owner.NextThrowGrenadeT = owner.NextThrowGrenadeT + 2
	self:CustomOnReload()
	if self.NPC_HasReloadSound == true then VJ.EmitSound(owner, self.NPC_ReloadSound, self.NPC_ReloadSoundLevel) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:PrimaryAttack(UseAlt)
	//if self:GetOwner():KeyDown(IN_RELOAD) then return end
	//self:GetOwner():SetFOV(45, 0.3)
	//if !IsFirstTimePredicted() then return end
	
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	local owner = self:GetOwner()
	local isNPC = owner:IsNPC()
	local isPly = owner:IsPlayer()
	
	if self.Reloading or self:GetNextSecondaryFire() > CurTime() then return end
	if isNPC && owner.VJ_IsBeingControlled == false && !IsValid(owner:GetEnemy()) then return end -- If the NPC owner isn't being controlled and doesn't have an enemy, then return end
	if self.IsMeleeWeapon == false && ((isPly && self.Primary.AllowFireInWater == false && owner:WaterLevel() == 3) or (self:Clip1() <= 0)) then
		if SERVER then
			owner:EmitSound(VJ.PICK(self.DryFireSound),self.DryFireSoundLevel,math.random(self.DryFireSoundPitch.a, self.DryFireSoundPitch.b))
		end
		return
	end
	if (!self:CanPrimaryAttack()) then return end
	if self:CustomOnPrimaryAttack_BeforeShoot() == true then return end
	
	if isNPC && owner.IsVJBaseSNPC == true then
		timer.Simple(self.NPC_ExtraFireSoundTime, function()
			if IsValid(self) && IsValid(owner) then
				VJ.EmitSound(owner, self.NPC_ExtraFireSound, self.NPC_ExtraFireSoundLevel, math.Rand(self.NPC_ExtraFireSoundPitch.a, self.NPC_ExtraFireSoundPitch.b))
			end
		end)
	end
	
	-- Firing Sounds
	if SERVER then
		local fireSd = VJ.PICK(self.Primary.Sound)
		if fireSd != false then
			sound.Play(fireSd, owner:GetPos(), self.Primary.SoundLevel, math.random(self.Primary.SoundPitch.a, self.Primary.SoundPitch.b), self.Primary.SoundVolume)
			//self:EmitSound(fireSd, 80, math.random(90,100))
		end
		if self.Primary.HasDistantSound == true then
			local fireFarSd = VJ.PICK(self.Primary.DistantSound)
			if fireFarSd != false then
				sound.Play(fireFarSd, owner:GetPos(), self.Primary.DistantSoundLevel, math.random(self.Primary.DistantSoundPitch.a, self.Primary.DistantSoundPitch.b), self.Primary.DistantSoundVolume)
			end
		end
	end
	
	-- Firing Gesture
	if owner.IsVJBaseSNPC_Human == true && owner.DisableWeaponFiringGesture != true then
		owner:VJ_ACT_PLAYACTIVITY(owner:TranslateActivity(VJ.PICK(owner.AnimTbl_WeaponAttackFiringGesture)), false, false, false, 0, {AlwaysUseGesture=true})
	end
	
	-- MELEE WEAPON
	if self.IsMeleeWeapon == true then
		local meleeHitEnt = false
		for _,v in ipairs(ents.FindInSphere(owner:GetPos(), self.MeleeWeaponDistance)) do
			if (v.IsVJBaseBullseye && v.VJ_IsBeingControlled) or (v:IsPlayer() && v.VJTag_IsControllingNPC == true) then continue end -- If it's a bullseye and is controlled OR it's a player controlling then don't damage!
			if (isPly && v:EntIndex() != owner:EntIndex()) or (isNPC && (v:IsNPC() or (v:IsPlayer() && v:Alive() && !VJ_CVAR_IGNOREPLAYERS) or v:IsNextBot()) && (owner:Disposition(v) != D_LI) && (v != owner) && (v:GetClass() != owner:GetClass()) or (v:GetClass() == "prop_physics") or v.VJTag_IsAttackable == true or v.VJTag_IsDamageable == true && (owner:GetForward():Dot((v:GetPos() - owner:GetPos()):GetNormalized()) > math.cos(math.rad(owner.MeleeAttackDamageAngleRadius)))) then
				local dmginfo = DamageInfo()
				dmginfo:SetDamage(isNPC and owner:VJ_GetDifficultyValue(self.Primary.Damage) or self.Primary.Damage)
				if v:IsNPC() or v:IsPlayer() then dmginfo:SetDamageForce(owner:GetForward() * ((dmginfo:GetDamage() + 100) * 70)) end
				dmginfo:SetInflictor(owner)
				dmginfo:SetAttacker(owner)
				dmginfo:SetDamageType(DMG_CLUB)
				VJ.DamageSpecialEnts(owner, v, dmginfo)
				v:TakeDamageInfo(dmginfo, owner)
				if v:IsPlayer() then
					v:ViewPunch(Angle(math.random(-1, 1)*10, math.random(-1, 1)*10, math.random(-1, 1)*10))
				end
				self:CustomOnPrimaryAttack_MeleeHit(v)
				meleeHitEnt = true
			end
		end
		if meleeHitEnt == true then
			local meleeSd = VJ.PICK(self.MeleeWeaponSound_Hit)
			if meleeSd != false then
				self:EmitSound(meleeSd, 70, math.random(90, 100))
			end
		else
			if owner.IsVJBaseSNPC == true then owner:CustomOnMeleeAttack_Miss() end
			local meleeSd = VJ.PICK(self.MeleeWeaponSound_Miss)
			if meleeSd != false then
				self:EmitSound(meleeSd, 70, math.random(90, 100))
			end
		end
	-- REGULAR WEAPON (NON-MELEE)
	else
		if self.Primary.DisableBulletCode == false then
			local bullet = {}
				bullet.Num = self.Primary.NumberOfShots
				bullet.Tracer = self.Primary.Tracer
				bullet.TracerName = self.Primary.TracerType
				bullet.Force = self.Primary.Force
				bullet.AmmoType = self.Primary.Ammo
				
				-- Bullet spawn position & spread & damage
				if isPly then
					bullet.Spread = Vector((self.Primary.Cone / 60) / 4, (self.Primary.Cone / 60) / 4, 0)
					bullet.Src = owner:GetShootPos()
					bullet.Dir = owner:GetAimVector()
					local plyDmg = self.Primary.PlayerDamage
					if plyDmg == "Same" then
						bullet.Damage = self.Primary.Damage
					elseif plyDmg == "Double" then
						bullet.Damage = self.Primary.Damage * 2
					elseif isnumber(plyDmg) then
						bullet.Damage = plyDmg
					end
				elseif owner.IsVJBaseSNPC then
					local ene = owner:GetEnemy()
					local spawnPos = self:GetNW2Vector("VJ_CurBulletPos")
					local aimPos = owner:GetAimPosition(ene, spawnPos, 0)
					local spread = owner:CalcAimSpread(ene, aimPos, self.NPC_CustomSpread or 1) // owner:GetPos():Distance(owner.VJ_TheController:GetEyeTrace().HitPos) -- Was used when NPC was being controlled
					bullet.Spread = Vector(spread, spread, 0)
					bullet.Dir = (aimPos - spawnPos):GetNormal()
					bullet.Src = spawnPos
					bullet.Damage = owner:VJ_GetDifficultyValue(self.Primary.Damage)
				else
					local spawnPos = self:GetNW2Vector("VJ_CurBulletPos")
					bullet.Spread = Vector(0.05, 0.05, 0)
					bullet.Dir = (owner:GetEnemy():BodyTarget(spawnPos) - spawnPos):GetNormal()
					bullet.Src = spawnPos
					bullet.Damage = self.Primary.Damage
				end
				
				-- Callback
				bullet.Callback = function(attacker, tr, dmginfo)
					self:CustomOnPrimaryAttack_BulletCallback(attacker, tr, dmginfo)
					/*local laserhit = EffectData()
					laserhit:SetOrigin(tr.HitPos)
					laserhit:SetNormal(tr.HitNormal)
					laserhit:SetScale(25)
					util.Effect("AR2Impact", laserhit)
					tr.HitPos:Ignite(8,0)*/
				end
			owner:FireBullets(bullet)
		end
		if cv_muszzleflash:GetInt() == 0 then owner:MuzzleFlash() end
	end
	
	if !self.IsMeleeWeapon then -- Melee weapons shouldn't consume ammo!
		if isPly then -- "TakePrimaryAmmo" calls "Ammo1" and "RemoveAmmo" which do NOT exist in NPCs!
			self:TakePrimaryAmmo(self.Primary.TakeAmmo)
		else
			self:SetClip1(self:Clip1() - self.Primary.TakeAmmo)
		end
	end
	
	self:PrimaryAttackEffects(owner)
	
	if isPly then
		//self:ShootEffects("ToolTracer") -- Deprecated
		owner:ViewPunch(Angle(-self.Primary.Recoil, 0, 0))
		owner:SetAnimation(PLAYER_ATTACK1)
		local anim = VJ.PICK(self.AnimTbl_PrimaryFire)
		local animTime = VJ.AnimDuration(owner:GetViewModel(), anim)
		self:SendWeaponAnim(anim)
		self.NextIdleT = CurTime() + animTime
		self.NextReloadT = CurTime() + animTime
	end
	self:CustomOnPrimaryAttack_AfterShoot()
	//self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CanSecondaryAttack()
	return self:Clip2() > 0 && self:GetNextSecondaryFire() < CurTime() && self.Secondary.Ammo != "none"
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:SecondaryAttack()
	if !self:CanSecondaryAttack() or self.Reloading then return end
	if self:CustomOnSecondaryAttack() == false then return end
	
	local owner = self:GetOwner()
	self:TakePrimaryAmmo(self.Secondary.TakeAmmo)
	owner:SetAnimation(PLAYER_ATTACK1)
	local anim = VJ.PICK(self.AnimTbl_SecondaryFire)
	local animTime = VJ.AnimDuration(owner:GetViewModel(), anim)
	self:SendWeaponAnim(anim)
	self.NextIdleT = CurTime() + animTime
	self.NextReloadT = CurTime() + animTime
	
	self:SetNextSecondaryFire(CurTime() + (self.Secondary.Delay == false and animTime or self.Secondary.Delay))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:DoIdleAnimation()
	if !self.HasIdleAnimation or CurTime() < self.NextIdleT then return end
	self:CustomOnIdle()
	local owner = self:GetOwner()
	if IsValid(owner) then
		owner:SetAnimation(PLAYER_IDLE)
		local anim = VJ.PICK(self.AnimTbl_Idle)
		local animTime = VJ.AnimDuration(owner:GetViewModel(), anim)
		self:SendWeaponAnim(anim)
		self.NextIdleT = CurTime() + animTime
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:PrimaryAttackEffects(owner)
	if self:CustomOnPrimaryAttackEffects(owner) != true or self.IsMeleeWeapon == true then return end
	owner = owner or self:GetOwner()
	
	if cv_muszzleflash:GetInt() == 0 then
		-- MUZZLE FLASH
		if self.PrimaryEffects_MuzzleFlash == true then
			local muzzleAttach = self.PrimaryEffects_MuzzleAttachment
			if !isnumber(muzzleAttach) then muzzleAttach = self:LookupAttachment(muzzleAttach) end
			-- Players
			if owner:IsPlayer() && owner:GetViewModel() != nil then
				local muzzleFlashEffect = EffectData()
				muzzleFlashEffect:SetOrigin(owner:GetShootPos())
				muzzleFlashEffect:SetEntity(self)
				muzzleFlashEffect:SetStart(owner:GetShootPos())
				muzzleFlashEffect:SetNormal(owner:GetAimVector())
				muzzleFlashEffect:SetAttachment(muzzleAttach)
				util.Effect("VJ_Weapon_PlayerMuzzle", muzzleFlashEffect)
			else -- NPCs
				if self.PrimaryEffects_MuzzleParticlesAsOne == true then -- Combine all of the particles in the table!
					for _, v in ipairs(self.PrimaryEffects_MuzzleParticles) do
						ParticleEffectAttach(v, PATTACH_POINT_FOLLOW, self, muzzleAttach)
					end
				else
					ParticleEffectAttach(VJ.PICK(self.PrimaryEffects_MuzzleParticles), PATTACH_POINT_FOLLOW, self, muzzleAttach)
				end
			end
		end
		
		-- MUZZLE DYNAMIC LIGHT
		if SERVER && self.PrimaryEffects_SpawnDynamicLight == true && cv_dynamiclight:GetInt() == 0 then
			local muzzleLight = ents.Create("light_dynamic")
			muzzleLight:SetKeyValue("brightness", self.PrimaryEffects_DynamicLightBrightness)
			muzzleLight:SetKeyValue("distance", self.PrimaryEffects_DynamicLightDistance)
			if owner:IsPlayer() then muzzleLight:SetLocalPos(owner:GetShootPos() +self:GetForward()*40 + self:GetUp()*-10) else muzzleLight:SetLocalPos(self:GetNW2Vector("VJ_CurBulletPos")) end
			muzzleLight:SetLocalAngles(self:GetAngles())
			muzzleLight:Fire("Color", self.PrimaryEffects_DynamicLightColor.r.." "..self.PrimaryEffects_DynamicLightColor.g.." "..self.PrimaryEffects_DynamicLightColor.b)
			//muzzleLight:SetParent(self)
			muzzleLight:Spawn()
			muzzleLight:Activate()
			muzzleLight:Fire("TurnOn", "", 0)
			muzzleLight:Fire("Kill", "", 0.07)
			self:DeleteOnRemove(muzzleLight)
		end
	end

	-- SHELL CASING
	if !owner:IsPlayer() && self.PrimaryEffects_SpawnShells == true && cv_bulletshells:GetInt() == 0 then
		local shellAttach = self.PrimaryEffects_ShellAttachment
		if !isnumber(shellAttach) then shellAttach = self:LookupAttachment(shellAttach) end
		shellAttach = self:GetAttachment(shellAttach)
		if !shellAttach then -- No attachment found, so just use some default pos & ang
			shellAttach = {Pos = owner:GetShootPos(), Ang = self:GetAngles()}
		end
		local effectData = EffectData()
		effectData:SetEntity(self)
		effectData:SetOrigin(shellAttach.Pos)
		effectData:SetAngles(shellAttach.Ang)
		util.Effect(self.PrimaryEffects_ShellType, effectData, true, true)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:FireAnimationEvent(pos, ang, event, options)
	if self:CustomOnFireAnimationEvent(pos, ang, event, options) == true then return true end
	
	if (event == 22 or event == 6001) then return true end
	
	if cv_muszzleflash:GetInt() == 1 && (event == 21 or event == 22 or event == 5001 or event == 5003) then
		return true
	end

	if cv_bulletshells:GetInt() == 1 && event == 20 then
		return true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:Think() -- NOTE: Works only in players hands. does NOT work in NPCs hands!
	self:CustomOnThink()
	if SERVER then
		self:RunWorldModelThink()
		self:DoIdleAnimation()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:Reload()
	if !IsValid(self) then return end
	local owner = self:GetOwner()
	if !IsValid(owner) or !owner:IsPlayer() or !owner:Alive() or owner:GetAmmoCount(self.Primary.Ammo) == 0 or self.Reloading or CurTime() < self.NextReloadT then return end // or !owner:KeyDown(IN_RELOAD)
	if self:Clip1() < self.Primary.ClipSize then
		self.Reloading = true
		self:CustomOnReload()
		if SERVER && self.HasReloadSound == true then owner:EmitSound(VJ.PICK(self.ReloadSound), 50, math.random(90, 100)) end
		-- Handle clip
		timer.Simple(self.Reload_TimeUntilAmmoIsSet, function()
			if IsValid(self) && self:CustomOnReload_Finish() != false then
				local ammoUsed = math.Clamp(self.Primary.ClipSize - self:Clip1(), 0, owner:GetAmmoCount(self:GetPrimaryAmmoType())) -- Amount of ammo that it will use (Take from the reserve)
				owner:RemoveAmmo(ammoUsed, self.Primary.Ammo)
				self:SetClip1(self:Clip1() + ammoUsed)
				self:CustomOnReload_Finish()
			end
		end)
		-- Handle animation
		owner:SetAnimation(PLAYER_RELOAD)
		local anim = VJ.PICK(self.AnimTbl_Reload)
		local animTime = VJ.AnimDuration(owner:GetViewModel(), anim)
		self:SendWeaponAnim(anim)
		self.NextIdleT = CurTime() + animTime
		timer.Simple(animTime, function()
			if IsValid(self) then
				self.Reloading = false
			end
		end)
		return true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:Deploy()
	if self.InitHasIdleAnimation == true then self.HasIdleAnimation = true end
	local owner = self:GetOwner()
	if owner:IsPlayer() then
		self:CustomOnDeploy()
		if self.HasDeploySound == true then self:EmitSound(VJ.PICK(self.DeploySound), 50, math.random(90, 100)) end
		
		local curTime = CurTime()
		local anim = VJ.PICK(self.AnimTbl_Deploy)
		local animTime = VJ.AnimDuration(owner:GetViewModel(), anim)
		self:SendWeaponAnim(anim)
		self:SetNextPrimaryFire(curTime + animTime)
		self:SetNextSecondaryFire(curTime + animTime)
		self.NextIdleT = curTime + animTime
		self.NextReloadT = curTime + animTime
	end
	return true -- Or else the player won't be able to get the weapon!
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:Holster(newWep)
	//if CLIENT then return end
	if self == newWep or self.Reloading == true then return end
	self.HasIdleAnimation = false
	//self:SendWeaponAnim(ACT_VM_HOLSTER)
	return self:CustomOnHolster(newWep)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:EquipAmmo(ply)
	if ply:IsPlayer() then
		ply:GiveAmmo(self.Primary.ClipSize, self.Primary.Ammo)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OnRemove()
	self:StopParticles()
	self:CustomOnRemove()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:GetWeaponCustomPosition(owner)
	if owner:LookupBone(self.WorldModel_CustomPositionBone) == nil then return nil end
	local pos, ang = owner:GetBonePosition(owner:LookupBone(self.WorldModel_CustomPositionBone))
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
	if self:GetNW2Bool("VJ_WorldModel_Invisible") != self.WorldModel_Invisible then
		self:SetNW2Bool("VJ_WorldModel_Invisible", self.WorldModel_Invisible)
	end
	
	local owner = self:GetOwner()
	if IsValid(owner) && self.WorldModel_UseCustomPosition == true then
		local wepPos = self:GetWeaponCustomPosition(owner)
		if wepPos == nil then return end
		self:SetPos(wepPos.pos)
		self:SetAngles(wepPos.ang)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:DecideBulletPosition()
	local owner = self:GetOwner()
	if !IsValid(owner) then return nil end
	if !owner:IsNPC() then return owner:GetShootPos() end
	
	-- Custom Position
	local customPos = self:CustomBulletSpawnPosition()
	if customPos != false then
		return customPos
	end
	
	-- Custom Attachment
	if self.NPC_BulletSpawnAttachment != "" && self:LookupAttachment(self.NPC_BulletSpawnAttachment) != 0 && self:LookupAttachment(self.NPC_BulletSpawnAttachment) != -1 then
		return self:GetAttachment(self:LookupAttachment(self.NPC_BulletSpawnAttachment)).Pos
	end
	
	-- Nothing found, try to find a common attachment
	local commonAttach = nil;
	local attachments = self:GetAttachments()
	for i = 1, #attachments do
		if attachments[i].name == "muzzle" then
			commonAttach = "muzzle"; break
		elseif attachments[i].name == "muzzleA" then
			commonAttach = "muzzleA"; break
		elseif attachments[i].name == "muzzle_flash" then
			commonAttach = "muzzle_flash"; break
		elseif attachments[i].name == "muzzle_flash1" then
			commonAttach = "muzzle_flash1"; break
		elseif attachments[i].name == "muzzle_flash2" then
			commonAttach = "muzzle_flash2"; break
		elseif attachments[i].name == "ValveBiped.muzzle" then
			commonAttach = "ValveBiped.muzzle"; break
		end
	end
	
	-- Not even a common attachment was found! Try to find a common bone!
	if !commonAttach then
		if owner:LookupBone("ValveBiped.Bip01_R_Hand") != nil then
			return owner:GetBonePosition(owner:LookupBone("ValveBiped.Bip01_R_Hand"))
		else -- Everything else has failed, post a warning and use eye position
			print("WARNING: "..self:GetClass().." doesn't have a proper attachment or bone for bullet spawn! Using EyePos!")
			return owner:EyePos()
		end
	-- Common attachment found!
	else
		return self:GetAttachment(self:LookupAttachment(commonAttach)).Pos
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
/*if SERVER then -- No longer needed, disabling sv_pvsskipanimation fixes it!
	util.AddNetworkString("vj_weapon_curbulletpos")
	
	net.Receive("vj_weapon_curbulletpos", function(len,pl)
		local vec = net.ReadVector()
		local ent = ents.GetByIndex(net.ReadInt(15))
		if IsValid(ent) then
			ent.worldupdate = ent.worldupdate or 0
			if ent.worldupdate <= CurTime() then
				ent:SetNW2Vector("VJ_CurBulletPos",vec)
				ent.worldupdate = CurTime() + 0.33
			end
		end
	end)
end*/
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	function SWEP:DrawWorldModel()
		if !IsValid(self) then return end
		
		local noDraw = false
		if !self:CustomOnDrawWorldModel() or self:GetNW2Bool("VJ_WorldModel_Invisible") == true or self.WorldModel_Invisible == true then noDraw = true end
		
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
			local owner = self:GetOwner()
			if IsValid(owner) then
				if owner:IsPlayer() && owner:InVehicle() then return end
				local wepPos = self:GetWeaponCustomPosition(owner)
				if wepPos == nil then return end
				self:SetRenderOrigin(wepPos.pos)
				self:SetRenderAngles(wepPos.ang)
				self:FrameAdvance(FrameTime())
				self:SetupBones()
				if noDraw == false then self:DrawModel() end
			else
				self:SetRenderOrigin(nil)
				self:SetRenderAngles(nil)
				if noDraw == false then self:DrawModel() end
			end
		else
			if noDraw == false then self:DrawModel() end
		end
	end
end