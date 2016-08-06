if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= "MP 40"
SWEP.Author 					= "DrVrej"
SWEP.Contact					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose					= "This weapon is made for Players and NPCs"
SWEP.Instructions				= "Controls are like a regular weapon."
SWEP.Category					= "VJ Base"
	-- Client Settings ---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
SWEP.Slot						= 2 -- Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6) 
SWEP.SlotPos					= 4 -- Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6)
SWEP.SwayScale 					= 1 -- Default is 1, The scale of the viewmodel sway
SWEP.UseHands					= true
end
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.ViewModel					= "models/weapons/v_mp40.mdl"
SWEP.WorldModel					= "models/weapons/w_mp40_n.mdl"
SWEP.HoldType 					= "smg"
SWEP.Spawnable					= true
SWEP.AdminSpawnable				= false
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage				= 5 -- Damage
SWEP.Primary.PlayerDamage		= "Double" -- Only applies for players | "Same" = Same as self.Primary.Damage, "Double" = Double the self.Primary.Damage OR put a number to be different from self.Primary.Damage
SWEP.Primary.Force				= 5 -- Force applied on the object the bullet hits
SWEP.Primary.ClipSize			= 32 -- Max amount of bullets per clip
SWEP.Primary.Recoil				= 0.3 -- How much recoil does the player get?
SWEP.Primary.Delay				= 0.1 -- Time until it can shoot again
SWEP.Primary.Automatic			= true -- Is it automatic?
SWEP.Primary.Ammo				= "SMG1" -- Ammo type
SWEP.Primary.Sound				= {"vj_weapons/mp_40/mp40_single.wav"}
SWEP.Primary.HasDistantSound	= true -- Does it have a distant sound when the gun is shot?
SWEP.Primary.DistantSound		= {"vj_weapons/mp_40/mp40_single_dist.wav"}
	-- Deployment Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.DelayOnDeploy 				= 1.4 -- Time until it can shoot again after deploying the weapon
SWEP.HasDeploySound				= false -- Does the weapon have a deploy sound?
	-- Reload Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Reload_TimeUntilAmmoIsSet	= 2.1 -- Time until ammo is set to the weapon
SWEP.Reload_TimeUntilFinished	= 3.4 -- How much time until the player can play idle animation, shoot, etc.
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:PrimaryAttackEffects()
	local vjeffectmuz = EffectData()
	vjeffectmuz:SetOrigin(self.Owner:GetShootPos())
	vjeffectmuz:SetEntity(self.Weapon)
	vjeffectmuz:SetStart(self.Owner:GetShootPos())
	vjeffectmuz:SetNormal(self.Owner:GetAimVector())
	vjeffectmuz:SetAttachment(1)
	vjeffectmuz:SetMagnitude(15)
	util.Effect("VJ_Weapon_RifleMuzzle1",vjeffectmuz)
	
	if !self.Owner:IsPlayer() && GetConVarNumber("vj_wep_nobulletshells") == 0 then
		local vjeffect = EffectData()
		vjeffect:SetEntity(self.Weapon)
		vjeffect:SetOrigin(self.Owner:GetShootPos())
		vjeffect:SetNormal(self.Owner:GetAimVector())
		vjeffect:SetAttachment(2)
		util.Effect("VJ_Weapon_RifleShell1",vjeffect)
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