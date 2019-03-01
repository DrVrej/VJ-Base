if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= "Flare Gun"
SWEP.Author 					= "DrVrej"
SWEP.Contact					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose					= "This weapon is made for Players and NPCs"
SWEP.Instructions				= "Controls are like a regular weapon."
SWEP.Category					= "VJ Base"
	-- Client Settings ---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
SWEP.Slot						= 1 -- Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6) 
SWEP.SlotPos					= 1 -- Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6)
SWEP.SwayScale 					= 4 -- Default is 1, The scale of the viewmodel sway
SWEP.UseHands					= true
end
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire 		= 0.9 -- Next time it can use primary fires
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.ViewModel					= "models/vj_weapons/v_flaregun.mdl"
SWEP.WorldModel					= "models/vj_weapons/w_flaregun.mdl"
SWEP.HoldType 					= "revolver"
SWEP.Spawnable					= true
SWEP.AdminSpawnable				= false
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage				= 20 -- Damage
SWEP.Primary.Force				= 1 -- Force applied on the object the bullet hits
SWEP.Primary.ClipSize			= 1 -- Max amount of bullets per clip
SWEP.Primary.Recoil				= 2 -- How much recoil does the player get?
SWEP.Primary.Delay				= 0.2 -- Time until it can shoot again
SWEP.Primary.Automatic			= false -- Is it automatic?
SWEP.Primary.Ammo				= "357" -- Ammo type
SWEP.Primary.Sound				= {"vj_weapons/flare/fire.wav"}
SWEP.Primary.DistantSound		= {"vj_weapons/flare/fire_dist.wav"}
//SWEP.Primary.DistantSoundVolume	= 0.25 -- Distant sound volume
SWEP.Primary.DisableBulletCode	= true -- The bullet won't spawn, this can be used when creating a projectile-based weapon
SWEP.PrimaryEffects_MuzzleAttachment = 1
SWEP.PrimaryEffects_SpawnShells = false
	-- Deployment Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.DelayOnDeploy 				= 0.6 -- Time until it can shoot again after deploying the weapon
	-- Idle Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasIdleAnimation			= true -- Does it have a idle animation?
SWEP.AnimTbl_Idle				= {ACT_VM_IDLE}
SWEP.NextIdle_Deploy			= 0.5 -- How much time until it plays the idle animation after the weapon gets deployed
SWEP.NextIdle_PrimaryAttack		= 0.5 -- How much time until it plays the idle animation after attacking(Primary)
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttack_BeforeShoot()
if (CLIENT) then return end
	local flareround = ents.Create("obj_vj_flareround")
	if self.Owner:IsPlayer() then
	flareround:SetPos(self.Owner:GetShootPos()) else
	flareround:SetPos(self:GetAttachment(self:LookupAttachment("muzzle")).Pos) end
	flareround:SetAngles(self.Owner:GetAngles())
	flareround:SetOwner(self.Owner)
	flareround:Activate()
	flareround:Spawn()

	local phy = flareround:GetPhysicsObject()
	if phy:IsValid() then
		if self.Owner:IsPlayer() then
			phy:ApplyForceCenter((self.Owner:GetAimVector() * 15000))
		else
			phy:ApplyForceCenter(((self.Owner:GetEnemy():GetPos() - self.Owner:GetPos()) * 15000))
		end
	end
end