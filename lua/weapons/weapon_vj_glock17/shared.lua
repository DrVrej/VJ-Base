if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= "Glock 17"
SWEP.Author 					= "DrVrej"
SWEP.Contact					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose					= "This weapon is made for Players and NPCs"
SWEP.Instructions				= "Controls are like a regular weapon."
SWEP.Category					= "VJ Base"
	-- Client Settings ---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
SWEP.Slot						= 1 -- Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6) 
SWEP.SlotPos					= 1 -- Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6)
SWEP.SwayScale 					= 5 -- Default is 1, The scale of the viewmodel sway
end
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_EnableDontUseRegulate 	= false -- Used for VJ Base SNPCs, if enabled the SNPC will remove use regulate
SWEP.NPC_NextPrimaryFire 		= 0.25 -- Next time it can use primary fire
SWEP.NPC_CustomSpread	 		= 0.8 -- This is added on top of the custom spread that's set inside the SNPC! | Starting from 1: Closer to 0 = better accuracy, Farther than 1 = worse accuracy
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.ViewModel					= "models/vj_weapons/v_glock.mdl"
SWEP.WorldModel					= "models/weapons/w_glock.mdl"
SWEP.HoldType 					= "pistol"
SWEP.Spawnable					= true
SWEP.AdminSpawnable				= false
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage				= 25 -- Damage
SWEP.Primary.PlayerDamage		= 15 -- Only applies for players | "Same" = Same as self.Primary.Damage, "Double" = Double the self.Primary.Damage OR put a number to be different from self.Primary.Damage
SWEP.Primary.Force				= 5 -- Force applied on the object the bullet hits
SWEP.Primary.ClipSize			= 17 -- Max amount of bullets per clip
SWEP.Primary.Recoil				= 0.3 -- How much recoil does the player get?
SWEP.Primary.Cone				= 5 -- How accurate is the bullet? (Players)
SWEP.Primary.Delay				= 0.25 -- Time until it can shoot again
SWEP.Primary.Automatic			= true -- Is it automatic?
SWEP.Primary.Ammo				= "Pistol" -- Ammo type
SWEP.Primary.Sound				= {"vj_weapons/glock_17/glock17_single.wav"}
SWEP.Primary.HasDistantSound	= true -- Does it have a distant sound when the gun is shot?
SWEP.Primary.DistantSound		= {"vj_weapons/glock_17/glock17_single_dist.wav"}
	-- Deployment Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.DelayOnDeploy 				= 0.4 -- Time until it can shoot again after deploying the weapon
SWEP.AnimTbl_Deploy				= {ACT_VM_IDLE_TO_LOWERED}
	-- Reload Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasReloadSound				= true -- Does it have a reload sound? Remember even if this is set to false, the animation sound will still play!
SWEP.ReloadSound				= "vj_weapons/glock_17/reload.wav"
SWEP.Reload_TimeUntilAmmoIsSet	= 1.5 -- Time until ammo is set to the weapon
SWEP.Reload_TimeUntilFinished	= 2 -- How much time until the player can play idle animation, shoot, etc.
	-- Idle Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasIdleAnimation			= true -- Does it have a idle animation?
SWEP.AnimTbl_Idle				= {ACT_VM_IDLE}
SWEP.NextIdle_Deploy			= 0.5 -- How much time until it plays the idle animation after the weapon gets deployed
SWEP.NextIdle_PrimaryAttack		= 0.1 -- How much time until it plays the idle animation after attacking(Primary)
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:PrimaryAttackEffects()
	if self.Owner:GetClass() == "npc_vj_bmssec_assassin" then return end
	local vjeffectmuz = EffectData()
	vjeffectmuz:SetOrigin(self.Owner:GetShootPos())
	vjeffectmuz:SetEntity(self.Weapon)
	vjeffectmuz:SetStart(self.Owner:GetShootPos())
	vjeffectmuz:SetNormal(self.Owner:GetAimVector())
	vjeffectmuz:SetAttachment(1)
	util.Effect("VJ_Weapon_PistolMuzzle1",vjeffectmuz)
	
	if !self.Owner:IsPlayer() && GetConVarNumber("vj_wep_nobulletshells") == 0 then
		local vjeffect = EffectData()
		vjeffect:SetEntity(self.Weapon)
		vjeffect:SetOrigin(self.Owner:GetShootPos())
		vjeffect:SetNormal(self.Owner:GetAimVector())
		vjeffect:SetAttachment(1)
		util.Effect("VJ_Weapon_PistolShell1",vjeffect)
	end
	
	if (SERVER) && GetConVarNumber("vj_wep_nomuszzleflash") == 0 && GetConVarNumber("vj_wep_nomuszzleflash_dynamiclight") == 0 then
		local FireLight1 = ents.Create("light_dynamic")
		FireLight1:SetKeyValue("brightness", "4")
		FireLight1:SetKeyValue("distance", "120")
		if self.Owner:IsPlayer() then FireLight1:SetLocalPos(self.Owner:GetShootPos() +self:GetForward()*40 + self:GetUp()*-10) else FireLight1:SetLocalPos(self:GetAttachment(1).Pos) end
		FireLight1:SetLocalAngles(self:GetAngles())
		FireLight1:Fire("Color", "255 150 60")
		FireLight1:SetParent(self)
		FireLight1:Spawn()
		FireLight1:Activate()
		FireLight1:Fire("TurnOn","",0)
		FireLight1:Fire("Kill","",0.07)
		self:DeleteOnRemove(FireLight1)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnFireAnimationEvent(pos,ang,event,options)
	if event == 32 then return true end 
end