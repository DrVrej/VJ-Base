if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= "RPG"
SWEP.Author 					= "DrVrej"
SWEP.Contact					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose					= "This weapon is made for Players and NPCs"
SWEP.Instructions				= "Controls are like a regular weapon."
SWEP.Category					= "VJ Base"
	-- Client Settings ---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
SWEP.Slot						= 4 -- Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6) 
SWEP.SlotPos					= 4 -- Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6)
SWEP.UseHands					= true
end
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire 		= 5 -- Next time it can use primary fire
SWEP.NPC_TimeUntilFire	 		= 0.8 -- How much time until the bullet/projectile is fired?
SWEP.NPC_ReloadSound			= {"vj_weapons/reload_rpg.wav"}
SWEP.NPC_BulletSpawnAttachment = "missile" -- The attachment that the bullet spawns on, leave empty for base to decide!
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.ViewModel					= "models/vj_weapons/c_rpg7.mdl" // "models/weapons/c_rpg.mdl"
SWEP.WorldModel					= "models/vj_weapons/w_rpg7.mdl" // "models/weapons/w_rocket_launcher.mdl"
SWEP.HoldType 					= "ar2"
SWEP.ViewModelFOV				= 60 -- Player FOV for the view model
SWEP.Spawnable					= true
SWEP.AdminSpawnable				= false
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage				= 5 -- Damage
SWEP.Primary.Force				= 5 -- Force applied on the object the bullet hits
SWEP.Primary.ClipSize			= 1 -- Max amount of bullets per clip
SWEP.Primary.Recoil				= 0.6 -- How much recoil does the player get?
SWEP.Primary.Delay				= 0.3 -- Time until it can shoot again
SWEP.Primary.Automatic			= true -- Is it automatic?
SWEP.Primary.Ammo				= "RPG_Round" -- Ammo type
SWEP.Primary.Sound				= {"vj_weapons/rpg/rpg_fire.wav"}
SWEP.Primary.DistantSound		= {"vj_weapons/rpg/rpg_fire_far.wav"}
SWEP.Primary.DisableBulletCode	= true -- The bullet won't spawn, this can be used when creating a projectile-based weapon
SWEP.PrimaryEffects_MuzzleAttachment = 1
SWEP.PrimaryEffects_SpawnShells = false
	-- Deployment Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.DelayOnDeploy 				= 1 -- Time until it can shoot again after deploying the weapon
	-- Reload Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasReloadSound				= true -- Does it have a reload sound? Remember even if this is set to false, the animation sound will still play!
SWEP.Reload_TimeUntilAmmoIsSet	= 0.8 -- Time until ammo is set to the weapon
SWEP.Reload_TimeUntilFinished	= 1.8 -- How much time until the player can play idle animation, shoot, etc.
SWEP.ReloadSound				= "vj_weapons/reload_rpg.wav"
	-- Idle Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasIdleAnimation			= true -- Does it have a idle animation?
SWEP.AnimTbl_Idle				= {ACT_VM_IDLE}
SWEP.NextIdle_Deploy			= 0.5 -- How much time until it plays the idle animation after the weapon gets deployed
SWEP.NextIdle_PrimaryAttack		= 0.1 -- How much time until it plays the idle animation after attacking(Primary)
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttack_BeforeShoot()
	if (CLIENT) then return end
	local proj = ents.Create("obj_vj_tank_shell")
	local ply_Ang = self:GetOwner():GetAimVector():Angle()
	local ply_Pos = self:GetOwner():GetShootPos() + ply_Ang:Forward()*-20 + ply_Ang:Up()*-9 + ply_Ang:Right()*10
	if self:GetOwner():IsPlayer() then proj:SetPos(ply_Pos) else proj:SetPos(self:GetNWVector("VJ_CurBulletPos")) end
	if self:GetOwner():IsPlayer() then proj:SetAngles(ply_Ang) else proj:SetAngles(self:GetOwner():GetAngles()) end
	proj:SetOwner(self:GetOwner())
	proj:Activate()
	proj:Spawn()
	
	local phys = proj:GetPhysicsObject()
	if phys:IsValid() then
		if self:GetOwner():IsPlayer() then
			phys:SetVelocity(self:GetOwner():GetAimVector() * 2500)
		else
			phys:SetVelocity(self:GetOwner():CalculateProjectile("Line", self:GetNWVector("VJ_CurBulletPos"), self:GetOwner():GetEnemy():GetPos() + self:GetOwner():GetEnemy():OBBCenter(), 2500))
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttackEffects()
	//ParticleEffect("vj_rpg2_smoke1", self:GetAttachment(3).Pos, Angle(0,0,0), self)
	ParticleEffectAttach("smoke_exhaust_01a", PATTACH_POINT_FOLLOW, self, 3)
	ParticleEffectAttach("smoke_exhaust_01a", PATTACH_POINT_FOLLOW, self, 3)
	ParticleEffectAttach("smoke_exhaust_01a", PATTACH_POINT_FOLLOW, self, 3)
	timer.Simple(4,function() if IsValid(self) then self:StopParticles() end end)
	return true
end