SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "Flare Gun"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose = "This weapon is made for Players and NPCs"
SWEP.Instructions = "Controls are like a regular weapon."
SWEP.Category = "VJ Base"
	-- Client Settings ---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
SWEP.Slot = 1 -- Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6) 
SWEP.SlotPos = 1 -- Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6)
SWEP.SwayScale = 4 -- Default is 1, The scale of the viewmodel sway
SWEP.UseHands = true
end
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire = 0.9 -- RPM of the weapon in seconds | Calculation: 60 / RPMs
SWEP.NPC_TimeUntilFire = 0.5 -- How much time until the bullet/projectile is fired?
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.ViewModel = "models/vj_weapons/v_flaregun.mdl"
SWEP.WorldModel = "models/vj_weapons/w_flaregun.mdl"
SWEP.HoldType = "revolver"
SWEP.Spawnable = true
SWEP.AdminSpawnable = false
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage = 20 -- Damage
SWEP.Primary.Force = 1 -- Force applied on the object the bullet hits
SWEP.Primary.ClipSize = 1 -- Max amount of rounds per clip
SWEP.Primary.Recoil = 2 -- How much recoil does the player get?
SWEP.Primary.Delay = 0.2 -- Time until it can shoot again
SWEP.Primary.Automatic = false -- Should the weapon continue firing as long as the attack button is held down?
SWEP.Primary.Ammo = "357" -- Ammo type
SWEP.Primary.Sound = "VJ.Weapon_FlareGun.Single"
SWEP.PrimaryEffects_MuzzleParticles = {"vj_rifle_smoke", "vj_rifle_smoke_dark", "vj_rifle_smoke_flash", "vj_rifle_sparks2"}
SWEP.PrimaryEffects_MuzzleParticlesAsOne = true -- Should all the particles spawn together instead of picking only one?
SWEP.Primary.DisableBulletCode = true -- The bullet won't spawn, this can be used when creating a projectile-based weapon
SWEP.PrimaryEffects_MuzzleAttachment = 1
SWEP.PrimaryEffects_SpawnShells = false
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttack_BeforeShoot()
	if CLIENT then return end
	local owner = self:GetOwner()
	local projectile = ents.Create("obj_vj_flareround")
	local spawnPos = self:GetBulletPos()
	if owner:IsPlayer() then
		projectile:SetPos(owner:GetShootPos())
	else
		projectile:SetPos(spawnPos)
	end
	projectile:SetOwner(owner)
	projectile:Activate()
	projectile:Spawn()
	
	local phys = projectile:GetPhysicsObject()
	if IsValid(phys) then
		if owner.IsVJBaseSNPC then
			phys:SetVelocity(owner:CalculateProjectile("Line", spawnPos, owner:GetAimPosition(owner:GetEnemy(), spawnPos, 1, 15000), 15000))
		elseif owner:IsPlayer() then
			phys:SetVelocity(owner:GetAimVector() * 15000)
		else
			phys:SetVelocity(owner:CalculateProjectile("Line", spawnPos, owner:GetEnemy():GetPos() + owner:GetEnemy():OBBCenter(), 15000))
		end
		projectile:SetAngles(projectile:GetVelocity():GetNormal():Angle())
	end
end