AddCSLuaFile()

SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "NPC Controller"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose = "Made to control VJ NPCs."
SWEP.Instructions = "Press PRIMARY FIRE to control the NPC you are looking at."
SWEP.Category = "VJ Base"
SWEP.Spawnable = true

SWEP.ViewModel = "models/vj_base/weapons/c_controller.mdl"
SWEP.WorldModel = "models/vj_base/gibs/human/brain.mdl"
SWEP.WorldModel_UseCustomPosition = true
SWEP.WorldModel_CustomPositionAngle = Vector(0, 0, 0)
SWEP.WorldModel_CustomPositionOrigin = Vector(0, 4, -1.1)
SWEP.HoldType = "pistol"
SWEP.Slot = 5
SWEP.SlotPos = 7
SWEP.UseHands = true

SWEP.Primary.Sound = {"physics/flesh/flesh_squishy_impact_hard1.wav", "physics/flesh/flesh_squishy_impact_hard2.wav", "physics/flesh/flesh_squishy_impact_hard3.wav", "physics/flesh/flesh_squishy_impact_hard4.wav"}
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.DeploySound = {"physics/flesh/flesh_squishy_impact_hard1.wav", "physics/flesh/flesh_squishy_impact_hard2.wav", "physics/flesh/flesh_squishy_impact_hard3.wav", "physics/flesh/flesh_squishy_impact_hard4.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:PrimaryAttack()
	local owner = self:GetOwner()
	if CLIENT or owner:IsNPC() then return end
	
	owner:SetAnimation(PLAYER_ATTACK1)
	local delayTime = CurTime() + VJ.AnimDuration(owner:GetViewModel(), ACT_VM_SECONDARYATTACK)
	self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	self.PLY_NextIdleAnimT = delayTime
	self.PLY_NextReloadT = delayTime
	self:SetNextPrimaryFire(delayTime)
	self:EmitSound(VJ.PICK(self.Primary.Sound), 80, 140, 1, CHAN_WEAPON, 0, 0, VJ_RecipientFilter)
	
	local ent = util.TraceLine(util.GetPlayerTrace(owner)).Entity
	if IsValid(ent) then
		if ent:IsPlayer() then
			owner:ChatPrint("That's a player dumbass.")
			return
		elseif ent:GetClass() == "prop_ragdoll" then
			owner:ChatPrint("You are about to become that corpse.")
			return
		elseif ent:GetClass() == "prop_physics" then
			owner:ChatPrint("Uninstall your game. Now.")
			return
		elseif !ent:IsNPC() then
			owner:ChatPrint("This isn't an NPC, therefore you can't control it.")
			return
		elseif ent.VJ_IsBeingControlled then
			owner:ChatPrint("You can't control this NPC, it's already being controlled by someone else.")
			return
		end
		if !ent.IsVJBaseSNPC then
			owner:ChatPrint("NOTE: NPC Controller is mainly made for VJ Base NPCs!")
		end
		local controller = ents.Create("obj_vj_controller")
		controller.VJCE_Player = owner
		controller:SetControlledNPC(ent)
		controller:Spawn()
		controller:StartControlling()
	end
end