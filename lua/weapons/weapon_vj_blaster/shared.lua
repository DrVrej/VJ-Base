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
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.ViewModel					= "models/weapons/c_irifle.mdl"
SWEP.WorldModel					= "models/weapons/w_irifle.mdl"
SWEP.HoldType 					= "ar2"
SWEP.Spawnable					= true
SWEP.AdminSpawnable				= false
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage				= 5 -- Damage
SWEP.Primary.Force				= 5 -- Force applied on the object the bullet hits
SWEP.Primary.ClipSize			= 30 -- Max amount of bullets per clip
SWEP.Primary.Recoil				= 0.6 -- How much recoil does the player get?
SWEP.Primary.Delay				= 0.3 -- Time until it can shoot again
SWEP.Primary.Automatic			= true -- Is it automatic?
SWEP.Primary.Ammo				= "SMG1" -- Ammo type
SWEP.Primary.Sound				= {"vj_weapons/blaster/starwars_fire.wav"} -- npc/roller/mine/rmine_explode_shock1.wav
SWEP.Primary.HasDistantSound	= false -- Does it have a distant sound when the gun is shot?
SWEP.Primary.DisableBulletCode	= true -- The bullet won't spawn, this can be used when creating a projectile-based weapon
	-- Deployment Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.DelayOnDeploy 				= 1 -- Time until it can shoot again after deploying the weapon
	-- Reload Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Reload_TimeUntilAmmoIsSet	= 0.8 -- Time until ammo is set to the weapon
SWEP.Reload_TimeUntilFinished	= 1.8 -- How much time until the player can play idle animation, shoot, etc.
	-- Idle Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasIdleAnimation			= true -- Does it have a idle animation?
SWEP.AnimTbl_Idle				= {ACT_VM_IDLE}
SWEP.NextIdle_Deploy			= 0.5 -- How much time until it plays the idle animation after the weapon gets deployed
SWEP.NextIdle_PrimaryAttack		= 0.1 -- How much time until it plays the idle animation after attacking(Primary)
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttack_BeforeShoot()
if (CLIENT) then return end
	local SpawnBlaserRod = ents.Create("obj_vj_blasterrod")
	local OwnerPos = self.Owner:GetShootPos()
	local OwnerAng = self.Owner:GetAimVector():Angle()
	OwnerPos = OwnerPos + OwnerAng:Forward()*-33 + OwnerAng:Up()*-5 + OwnerAng:Right()*6
	if self.Owner:IsPlayer() then SpawnBlaserRod:SetPos(OwnerPos) else SpawnBlaserRod:SetPos(self:GetAttachment(self:LookupAttachment("muzzle")).Pos) end
	if self.Owner:IsPlayer() then SpawnBlaserRod:SetAngles(OwnerAng) else SpawnBlaserRod:SetAngles(self.Owner:GetAngles()) end
	SpawnBlaserRod:SetOwner(self.Owner)
	SpawnBlaserRod:Activate()
	SpawnBlaserRod:Spawn()
	
	local phy = SpawnBlaserRod:GetPhysicsObject()
	if phy:IsValid() then
		if self.Owner:IsPlayer() then
		phy:ApplyForceCenter(self.Owner:GetAimVector() * 4000) else //200000
		phy:ApplyForceCenter((self.Owner:GetEnemy():GetPos() - self.Owner:GetPos()) * 4000)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:PrimaryAttackEffects()
	if (SERVER) && GetConVarNumber("vj_wep_nomuszzleflash") == 0 && GetConVarNumber("vj_wep_nomuszzleflash_dynamiclight") == 0 then
		local FireLight1 = ents.Create("light_dynamic")
		FireLight1:SetKeyValue("brightness", "4")
		FireLight1:SetKeyValue("distance", "120")
		if self.Owner:IsPlayer() then FireLight1:SetLocalPos(self.Owner:GetShootPos() +self:GetForward()*40 + self:GetUp()*-10) else FireLight1:SetLocalPos(self:GetAttachment(1).Pos) end
		FireLight1:SetLocalAngles(self:GetAngles())
		FireLight1:Fire("Color", "255 0 0")
		FireLight1:SetParent(self)
		FireLight1:Spawn()
		FireLight1:Activate()
		FireLight1:Fire("TurnOn","",0)
		FireLight1:Fire("Kill","",0.07)
		self:DeleteOnRemove(FireLight1)
	end
end