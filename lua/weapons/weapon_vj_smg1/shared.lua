if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= "SMG1"
SWEP.Author 					= "DrVrej"
SWEP.Contact					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose					= "This weapon is made for Players and NPCs"
SWEP.Instructions				= "Controls are like a regular weapon."
SWEP.Category					= "VJ Base"
	-- Client Settings ---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
SWEP.Slot						= 2 -- Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6) 
SWEP.SlotPos					= 4 -- Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6)
SWEP.UseHands					= true
end
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.ViewModel					= "models/weapons/c_smg1.mdl"
SWEP.WorldModel					= "models/weapons/w_smg1.mdl"
SWEP.HoldType 					= "smg"
SWEP.Spawnable					= true
SWEP.AdminSpawnable				= false
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_HasSecondaryFire = true -- Can the weapon have a secondary fire?
SWEP.NPC_SecondaryFireSound = {"weapons/ar2/ar2_altfire.wav"} -- The sound it plays when the secondary fire is used
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage				= 5 -- Damage
SWEP.Primary.ClipSize			= 45 -- Max amount of bullets per clip
SWEP.Primary.Delay				= 0.09 -- Time until it can shoot again
SWEP.Primary.Automatic			= true -- Is it automatic?
SWEP.Primary.Ammo				= "SMG1" -- Ammo type
SWEP.Primary.Sound				= {"vj_weapons/hl2_smg1/smg1_single1.wav","vj_weapons/hl2_smg1/smg1_single2.wav","vj_weapons/hl2_smg1/smg1_single3.wav"}
SWEP.Primary.DistantSound		= {"Weapon_SMG1.NPC_Single"}
SWEP.PrimaryEffects_MuzzleAttachment = 1
SWEP.PrimaryEffects_ShellAttachment = 2
SWEP.PrimaryEffects_ShellType = "VJ_Weapon_PistolShell1"
	-- Idle Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasIdleAnimation			= true -- Does it have a idle animation?
SWEP.AnimTbl_Idle				= {ACT_VM_IDLE}
SWEP.NextIdle_Deploy			= 0.5 -- How much time until it plays the idle animation after the weapon gets deployed
SWEP.NextIdle_PrimaryAttack		= 0.1 -- How much time until it plays the idle animation after attacking(Primary)
	-- Reload Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasReloadSound				= true -- Does it have a reload sound? Remember even if this is set to false, the animation sound will still play!
SWEP.ReloadSound				= {"weapons/smg1/smg1_reload.wav"}

SWEP.Secondary.Ammo = "SMG1_Grenade"
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttack_BeforeShoot()
	if self:GetNextSecondaryFire() > CurTime() then -- In the middle of secondary fire
		return true
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CanSecondaryAttack()
	return self:Clip2() > 0 && self:GetNextSecondaryFire() < CurTime()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:SecondaryAttack()
	if (!self:CanSecondaryAttack()) then return end

	if self.Reloading == true then return end

	local owner = self:GetOwner()
	local fireTime = VJ_GetSequenceDuration(owner:GetViewModel(), ACT_VM_SECONDARYATTACK)
	self:SetNextSecondaryFire(CurTime() + fireTime)
	self.Reloading = true -- Compatibiliy as VJ Base has no custom reload check

	self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	VJ_EmitSound(self, "weapons/ar2/ar2_altfire.wav", 85)

	local pos = owner:GetShootPos()
	local proj = ents.Create(self.NPC_SecondaryFireEnt)
	proj:SetPos(pos)
	proj:SetAngles(owner:GetAimVector():Angle())
	proj:SetOwner(owner)
	proj:Spawn()
	proj:Activate()
	local phys = proj:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:SetVelocity(owner:GetAimVector() * 2000)
	end

	owner:SetAnimation(PLAYER_ATTACK1)
	owner:ViewPunch(Angle(-self.Primary.Recoil *3, 0, 0))
	self:TakeSecondaryAmmo(1)

	timer.Simple(fireTime, function()
		if IsValid(self) then
			self.Reloading = false -- Compatibiliy as VJ Base has no custom reload check
			self:SetClip2(self:Ammo2())
			self:DoIdleAnimation()
		end
	end)
end