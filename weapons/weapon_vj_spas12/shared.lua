if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= "SPAS-12"
SWEP.Author 					= "DrVrej"
SWEP.Contact					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose					= "This weapon is made for Players and NPCs"
SWEP.Instructions				= "Controls are like a regular weapon."
SWEP.Category					= "VJ Base"
	-- Client Settings ---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
SWEP.Slot						= 3 -- Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6) 
SWEP.SlotPos					= 4 -- Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6)
SWEP.UseHands					= true
end
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_EnableDontUseRegulate 	= true -- Used for VJ Base SNPCs, if enabled the SNPC will remove use regulate
SWEP.NPC_NextPrimaryFire 		= 0.9 -- Next time it can use primary fire
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.ViewModel					= "models/weapons/c_shotgun.mdl"
SWEP.WorldModel					= "models/weapons/w_shotgun.mdl"
SWEP.HoldType 					= "shotgun"
SWEP.Spawnable					= true
SWEP.AdminSpawnable				= false
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage				= 4 -- Damage
SWEP.Primary.PlayerDamage		= 1.5 -- Put 1 to make it the same as above
SWEP.Primary.UseNegativePlayerDamage = false -- Should it use a negative number for the player damage?
SWEP.Primary.Force				= 1 -- Force applied on the object the bullet hits
SWEP.Primary.NumberOfShots		= 7 -- How many shots per attack?
SWEP.Primary.ClipSize			= 6 -- Max amount of bullets per clip
SWEP.Primary.DefaultClip		= 24 -- How much ammo do you get when you first pick up the weapon?
SWEP.Primary.Cone				= 12 -- How accurate is the bullet? (Players)
SWEP.Primary.Delay				= 0.8 -- Time until it can shoot again
SWEP.Primary.Tracer				= 1
SWEP.Primary.TakeAmmo			= 1 -- How much ammo should it take on each shot?
SWEP.Primary.Automatic			= false -- Is it automatic?
SWEP.Primary.Ammo				= "Buckshot" -- Ammo type
SWEP.Primary.Sound				= "weapons/shotgun/shotgun_fire6.wav"
SWEP.Primary.HasDistantSound	= true -- Does it have a distant sound when the gun is shot?
SWEP.Primary.DistantSound		= "weapons/shotgun/shotgun_fire6.wav"
SWEP.Primary.DistantSoundVolume	= 0.55 -- Distant sound volume
	-- Reload Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasReloadSound				= true -- Does it have a reload sound? Remember even if this is set to false, the animation sound will still play!
SWEP.ReloadSound				= "weapons/shotgun/shotgun_reload"..math.random(1,3)..".wav"
SWEP.Reload_TimeUntilAmmoIsSet	= 0.3 -- Time until ammo is set to the weapon
SWEP.Reload_TimeUntilFinished	= 0.5 -- How much time until the player can play idle animation, shoot, etc.
	-- Idle Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasIdleAnimation			= true -- Does it have a idle animation?
SWEP.AnimTbl_Idle				= {ACT_VM_IDLE}
SWEP.NextIdle_Deploy			= 0.5 -- How much time until it plays the idle animation after the weapon gets deployed
SWEP.NextIdle_PrimaryAttack		= 0.8 -- How much time until it plays the idle animation after attacking(Primary)

-- Custom
SWEP.FirstTimeShotShotgun = false
---------------------------------------------------------------------------------------------------------------------------------------------
/*function SWEP:CustomOnNPC_ServerThinkAlways()
	print("debeck")
	if self.Owner:GetActivity() != ACT_RANGE_ATTACK1 then
	print("Fuck")
	self.FirstTimeShotShotgun = false
	end
end*/
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttack_AfterShoot()
	//if self.Owner:IsNPC() && (self.Owner.IsVJBaseSNPC) && self.FirstTimeShotShotgun == true /*&& self.Owner:GetActivity() != ACT_RANGE_ATTACK1*/ then
	//print("nigerian")
	//self.FirstTimeShotShotgun = true
	//self.Owner:VJ_ACT_PLAYACTIVITY(ACT_RANGE_ATTACK_SHOTGUN,false,0,true)
	//end
	//self.FirstTimeShotShotgun = true
	timer.Simple(0.2,function()
	if IsValid(self) then
	if self.Owner:IsValid() && self.Owner:IsPlayer() then
		self.Weapon:EmitSound(Sound("weapons/shotgun/shotgun_cock.wav"),80,100)
		self.Weapon:SendWeaponAnim(ACT_SHOTGUN_PUMP)
		end
	end
 end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:PrimaryAttackEffects()
	local vjeffectmuz = EffectData()
	vjeffectmuz:SetOrigin(self.Owner:GetShootPos())
	vjeffectmuz:SetEntity(self.Weapon)
	vjeffectmuz:SetStart(self.Owner:GetShootPos())
	vjeffectmuz:SetNormal(self.Owner:GetAimVector())
	vjeffectmuz:SetAttachment(1)
	vjeffectmuz:SetMagnitude(0)
	util.Effect("VJ_Weapon_RifleMuzzle1",vjeffectmuz)
	
	if GetConVarNumber("vj_wep_nobulletshells") == 0 then
	if !self.Owner:IsPlayer() then
	local vjeffect = EffectData()
	vjeffect:SetEntity(self.Weapon)
	vjeffect:SetOrigin(self.Owner:GetShootPos())
	vjeffect:SetNormal(self.Owner:GetAimVector())
	vjeffect:SetAttachment(1)
	util.Effect("VJ_Weapon_ShotgunShell1",vjeffect) end
	end

	if (SERVER) then
	if GetConVarNumber("vj_wep_nomuszzleflash") == 0 then
	local FireLight1 = ents.Create("light_dynamic")
	FireLight1:SetKeyValue("brightness", "2")
	if self.Owner:IsPlayer() then
	FireLight1:SetKeyValue("distance", "200") else FireLight1:SetKeyValue("distance", "150") end
	FireLight1:SetLocalPos(self.Owner:GetShootPos() +self:GetForward()*40 + self:GetUp()*-40)
	FireLight1:SetLocalAngles(self:GetAngles())
	FireLight1:Fire("Color", "255 150 60")
	FireLight1:SetParent(self)
	FireLight1:Spawn()
	FireLight1:Activate()
	FireLight1:Fire("TurnOn", "", 0)
	self:DeleteOnRemove(FireLight1)
	timer.Simple(0.07,function() if self:IsValid() then FireLight1:Remove() end end)
	end
 end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:FireAnimationEvent(pos,ang,event,options)
	/*local vjeffect = EffectData()
	vjeffect:SetEntity(self.Weapon)
	vjeffect:SetOrigin(self.Owner:GetShootPos())
	vjeffect:SetNormal(self.Owner:GetAimVector())
	vjeffect:SetAttachment(2)
	util.Effect("VJ_Weapon_RifleShell1",vjeffect)*/
	if GetConVarNumber("vj_wep_nobulletshells") == 1 then
	if event == 20 or event == 6001 then 
		return true end 
	end
end