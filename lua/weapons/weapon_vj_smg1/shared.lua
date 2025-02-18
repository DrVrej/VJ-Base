SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "SMG1"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Category = "VJ Base"
	-- Client Settings ---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	VJ.AddKillIcon("weapon_vj_smg1", SWEP.PrintName, VJ.KILLICON_TYPE_ALIAS, "weapon_smg1")
	
	SWEP.Slot = 2 -- Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6) 
	SWEP.SlotPos = 4 -- Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6)
	SWEP.UseHands = true
end
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.ViewModel = "models/weapons/c_smg1.mdl"
SWEP.WorldModel = "models/weapons/w_smg1.mdl"
SWEP.HoldType = "smg"
SWEP.Spawnable = true
SWEP.AdminSpawnable = false
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_HasSecondaryFire = true -- Can the weapon have a secondary fire?
SWEP.NPC_SecondaryFireSound = "VJ.Weapon_SMG1.Secondary" -- The sound it plays when the secondary fire is used
SWEP.NPC_ReloadSound = "vj_base/weapons/smg1/reload.wav" -- Sounds it plays when the base detects the SNPC playing a reload animation
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage = 5 -- Damage
SWEP.Primary.ClipSize = 45 -- Max amount of rounds per clip
SWEP.Primary.Delay = 0.09 -- Time until it can shoot again
SWEP.Primary.Automatic = true -- Should the weapon continue firing as long as the attack button is held down?
SWEP.Primary.Ammo = "SMG1" -- Ammo type
SWEP.Primary.Sound = "VJ.Weapon_SMG1.Single"
SWEP.PrimaryEffects_MuzzleAttachment = 1
SWEP.PrimaryEffects_ShellAttachment = 2
SWEP.PrimaryEffects_ShellType = "ShellEject"
	-- ====== Secondary Fire Variables ====== --
SWEP.Secondary.Automatic = true -- Should the weapon continue firing as long as the attack button is held down?
SWEP.Secondary.Ammo = "SMG1_Grenade" -- Ammo type
	-- Reload Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasReloadSound = true -- Does it have a reload sound? Remember even if this is set to false, the animation sound will still play!
SWEP.ReloadSound = "weapons/smg1/smg1_reload.wav"
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OnSecondaryAttack()
	local owner = self:GetOwner()
	owner:ViewPunch(Angle(-self.Primary.Recoil * 3, 0, 0))
	VJ.EmitSound(self, "weapons/ar2/ar2_altfire.wav", 85)

	if SERVER then
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
	end
end