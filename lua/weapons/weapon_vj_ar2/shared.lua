if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "AR2"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose = "This weapon is made for Players and NPCs"
SWEP.Instructions = "Controls are like a regular weapon."
SWEP.Category = "VJ Base"
	-- Client Settings ---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
SWEP.Slot = 2 -- Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6) 
SWEP.SlotPos = 4 -- Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6)
SWEP.UseHands = true
end
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_HasSecondaryFire = true -- Can the weapon have a secondary fire?
SWEP.NPC_SecondaryFireEnt = "obj_vj_combineball"
SWEP.NPC_SecondaryFireDistance = 3000 -- How close does the owner's enemy have to be for it to fire?
SWEP.NPC_SecondaryFireChance = 4 -- Chance that the secondary fire is used | 1 = always
SWEP.NPC_SecondaryFireNext = VJ_Set(15, 20) -- How much time until the secondary fire can be used again?
SWEP.NPC_NextPrimaryFire = 0.9 -- Next time it can use primary fire
SWEP.NPC_TimeUntilFire = 0.1 -- How much time until the bullet/projectile is fired?
SWEP.NPC_TimeUntilFireExtraTimers = {0.1, 0.2, 0.3, 0.4, 0.5, 0.6} -- Extra timers, which will make the gun fire again! | The seconds are counted after the self.NPC_TimeUntilFire!
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.ViewModel = "models/weapons/c_irifle.mdl"
SWEP.WorldModel = "models/weapons/w_irifle.mdl"
SWEP.HoldType = "ar2"
SWEP.Spawnable = true
SWEP.AdminSpawnable = false
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage = 12 -- Damage
SWEP.Primary.Force = 10 -- Force applied on the object the bullet hits
SWEP.Primary.ClipSize = 30 -- Max amount of bullets per clip
SWEP.Primary.Delay = 0.1 -- Time until it can shoot again
SWEP.Primary.TracerType = "AR2Tracer" -- Tracer type (Examples: AR2, laster, 9mm)
SWEP.Primary.Automatic = true -- Is it automatic?
SWEP.Primary.Ammo = "AR2" -- Ammo type
SWEP.Primary.Sound = {"vj_weapons/hl2_ar2/ar2_single1.wav","vj_weapons/hl2_ar2/ar2_single2.wav","vj_weapons/hl2_ar2/ar2_single3.wav"}
SWEP.Primary.DistantSound = {"^weapons/ar1/ar1_dist1.wav","^weapons/ar1/ar1_dist2.wav"}
SWEP.PrimaryEffects_MuzzleParticles = {"vj_rifle_full_blue"}
SWEP.PrimaryEffects_SpawnShells = false
SWEP.PrimaryEffects_DynamicLightColor = Color(0, 31, 225)
	-- ====== Secondary Fire Variables ====== --
SWEP.Secondary.Ammo = "AR2AltFire" -- Ammo type

SWEP.DryFireSound = {"weapons/ar2/ar2_empty.wav"}
	-- Reload Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasReloadSound				= false -- Does it have a reload sound? Remember even if this is set to false, the animation sound will still play!
SWEP.ReloadSound				= "weapons/ar2/ar2_reload.wav"
SWEP.Reload_TimeUntilAmmoIsSet	= 0.8 -- Time until ammo is set to the weapon
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:NPC_SecondaryFire_BeforeTimer(eneEnt, fireTime)
	VJ_EmitSound(self, "weapons/cguard/charging.wav", 70)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:NPC_SecondaryFire()
	local owner = self:GetOwner()
	local pos = self:GetNW2Vector("VJ_CurBulletPos")
	local proj = ents.Create(self.NPC_SecondaryFireEnt)
	proj:SetPos(pos)
	proj:SetAngles(owner:GetAngles())
	proj:SetOwner(owner)
	proj:Spawn()
	proj:Activate()
	local phys = proj:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:SetVelocity(owner:CalculateProjectile("Line", pos, owner.LastEnemyVisiblePos, 2000))
	end

	VJ_CreateSound(self, "weapons/irifle/irifle_fire2.wav", 90)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnSecondaryAttack()
	local owner = self:GetOwner()
	local vm = owner:GetViewModel()
	local fidgetTime = VJ_GetSequenceDuration(vm, ACT_VM_FIDGET)
	local fireTime = VJ_GetSequenceDuration(vm, ACT_VM_SECONDARYATTACK)
	local totalTime = fidgetTime + fireTime
	local curTime = CurTime()
	self:SetNextSecondaryFire(curTime + totalTime)
	self.NextIdleT = curTime + totalTime
	self.NextReloadT = curTime + totalTime
	self:SendWeaponAnim(ACT_VM_FIDGET)
	VJ_CreateSound(self, "weapons/cguard/charging.wav", 85)
	
	timer.Simple(fidgetTime, function()
		if IsValid(self) && IsValid(owner) && owner:GetActiveWeapon() == self then
			VJ_CreateSound(self, "weapons/irifle/irifle_fire2.wav", 90)

			local proj = ents.Create(self.NPC_SecondaryFireEnt)
			proj:SetPos(owner:GetShootPos())
			proj:SetAngles(owner:GetAimVector():Angle())
			proj:SetOwner(owner)
			proj:Spawn()
			proj:Activate()
			local phys = proj:GetPhysicsObject()
			if IsValid(phys) then
				phys:Wake()
				phys:SetVelocity(owner:GetAimVector() * 2000)
			end

			owner:ViewPunch(Angle(-self.Primary.Recoil *3, 0, 0))
			owner:SetAnimation(PLAYER_ATTACK1)
			self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
			self:TakeSecondaryAmmo(1)
		end
	end)
	return false
end