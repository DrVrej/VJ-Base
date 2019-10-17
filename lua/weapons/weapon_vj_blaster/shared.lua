if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= "Blaster"
SWEP.Author 					= "DrVrej"
SWEP.Contact					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose					= "This weapon is made for Players and NPCs"
SWEP.Instructions				= "Controls are like a regular weapon."
SWEP.Category					= "VJ Base"
	-- Client Settings ---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
SWEP.Slot						= 2 -- Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6) 
SWEP.SlotPos					= 4 -- Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6)
SWEP.UseHands					= true
end
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire 		= 0.3 -- Next time it can use primary fire
SWEP.NPC_ReloadSound			= {"vj_weapons/blaster/blaster_reload.wav"} -- Sounds it plays when the base detects the SNPC playing a reload animation
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.ViewModel					= "models/vj_weapons/c_e5.mdl"
SWEP.WorldModel					= "models/vj_weapons/w_e5.mdl"
SWEP.HoldType 					= "ar2"
SWEP.Spawnable					= true
SWEP.AdminSpawnable				= false
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage				= 10 -- Damage
SWEP.Primary.Force				= 5 -- Force applied on the object the bullet hits
SWEP.Primary.ClipSize			= 30 -- Max amount of bullets per clip
SWEP.Primary.Recoil				= 0.6 -- How much recoil does the player get?
SWEP.Primary.Delay				= 0.3 -- Time until it can shoot again
SWEP.Primary.TracerType			= "VJ_Laserrod_Red" -- Tracer type (Examples: AR2, laster, 9mm)
SWEP.Primary.Automatic			= true -- Is it automatic?
SWEP.Primary.Ammo				= "SMG1" -- Ammo type
SWEP.Primary.Sound				= {"vj_weapons/blaster/blaster_fire.wav"} -- npc/roller/mine/rmine_explode_shock1.wav
SWEP.Primary.HasDistantSound	= false -- Does it have a distant sound when the gun is shot?
//SWEP.Primary.DisableBulletCode	= true -- The bullet won't spawn, this can be used when creating a projectile-based weapon
SWEP.PrimaryEffects_MuzzleParticles = {"vj_rifle_smoke","vj_rifle_smoke_dark","vj_rifle_smoke_flash","vj_rifle_sparks2"}
SWEP.PrimaryEffects_MuzzleParticlesAsOne = true -- If set to true, the base will spawn all the given particles instead of picking one
SWEP.PrimaryEffects_MuzzleAttachment = "muzzle"
SWEP.PrimaryEffects_SpawnShells = false
SWEP.PrimaryEffects_DynamicLightColor = Color(255, 0, 0)
	-- Deployment Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.DelayOnDeploy 				= 0.2 -- Time until it can shoot again after deploying the weapon
	-- Reload Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasReloadSound				= true -- Does it have a reload sound? Remember even if this is set to false, the animation sound will still play!
SWEP.ReloadSound				= {"vj_weapons/blaster/blaster_reload.wav"}
SWEP.Reload_TimeUntilAmmoIsSet	= 0.8 -- Time until ammo is set to the weapon
SWEP.Reload_TimeUntilFinished	= 1.8 -- How much time until the player can play idle animation, shoot, etc.
	-- Idle Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasIdleAnimation			= true -- Does it have a idle animation?
SWEP.AnimTbl_Idle				= {ACT_VM_IDLE}
SWEP.NextIdle_Deploy			= 0.5 -- How much time until it plays the idle animation after the weapon gets deployed
SWEP.NextIdle_PrimaryAttack		= 0.1 -- How much time until it plays the idle animation after attacking(Primary)
---------------------------------------------------------------------------------------------------------------------------------------------
/*function SWEP:CustomOnPrimaryAttack_BeforeShoot()
	if (CLIENT) then return end
	local SpawnBlaserRod = ents.Create("obj_vj_blasterrod")
	local OwnerPos = self:GetOwner():GetShootPos()
	local OwnerAng = self:GetOwner():GetAimVector():Angle()
	OwnerPos = OwnerPos + OwnerAng:Forward()*-33 + OwnerAng:Up()*-5 + OwnerAng:Right()*6
	if self:GetOwner():IsPlayer() then SpawnBlaserRod:SetPos(OwnerPos) else SpawnBlaserRod:SetPos(self:GetAttachment(self:LookupAttachment("muzzle")).Pos) end
	if self:GetOwner():IsPlayer() then SpawnBlaserRod:SetAngles(OwnerAng) else SpawnBlaserRod:SetAngles(self:GetOwner():GetAngles()) end
	SpawnBlaserRod:SetOwner(self:GetOwner())
	SpawnBlaserRod:Activate()
	SpawnBlaserRod:Spawn()
	
	local phy = SpawnBlaserRod:GetPhysicsObject()
	if phy:IsValid() then
		if self:GetOwner():IsPlayer() then
		phy:ApplyForceCenter(self:GetOwner():GetAimVector() * 4000) else //200000
		phy:ApplyForceCenter((self:GetOwner():GetEnemy():GetPos() - self:GetOwner():GetPos()) * 4000)
		end
	end
end*/