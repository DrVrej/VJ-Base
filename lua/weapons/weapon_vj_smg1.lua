AddCSLuaFile()

SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "SMG1"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Category = "VJ Base"
SWEP.Spawnable = true

if CLIENT then
	VJ.AddKillIcon("weapon_vj_smg1", SWEP.PrintName, VJ.KILLICON_TYPE_ALIAS, "weapon_smg1")
end

SWEP.ViewModel = "models/weapons/c_smg1.mdl"
SWEP.WorldModel = "models/weapons/w_smg1.mdl"
SWEP.HoldType = "smg"
SWEP.Slot = 2
SWEP.SlotPos = 4
SWEP.UseHands = true

SWEP.NPC_HasSecondaryFire = true
SWEP.NPC_SecondaryFireSound = "VJ.Weapon_SMG1.Secondary"
SWEP.NPC_ReloadSound = "vj_base/weapons/smg1/reload.wav"

SWEP.Primary.Damage = 5
SWEP.Primary.ClipSize = 45
SWEP.Primary.Delay = 0.09
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "SMG1"
SWEP.Primary.Sound = "VJ.Weapon_SMG1.Single"
SWEP.PrimaryEffects_MuzzleAttachment = 1
SWEP.PrimaryEffects_ShellAttachment = 2
SWEP.PrimaryEffects_ShellType = "ShellEject"

SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "SMG1_Grenade"

SWEP.HasReloadSound = true
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