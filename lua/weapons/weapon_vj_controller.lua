AddCSLuaFile()

SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "NPC Controller"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose = "Made to control VJ Base NPCs."
SWEP.Instructions = "Press PRIMARY FIRE to control the NPC you are looking at."
SWEP.Category = "VJ Base"
SWEP.Spawnable = true

SWEP.ViewModel = "models/vj_base/weapons/c_controller.mdl"
SWEP.WorldModel = "models/vj_base/gibs/human/brain.mdl"
SWEP.WorldModelOffsetParams = {
	Enabled = true,
	Pos = Vector(4, 0, -1.1)
}
SWEP.HoldType = "pistol"
SWEP.Slot = 5
SWEP.SlotPos = 7
SWEP.UseHands = true

local sdMain = {"physics/flesh/flesh_squishy_impact_hard1.wav", "physics/flesh/flesh_squishy_impact_hard2.wav", "physics/flesh/flesh_squishy_impact_hard3.wav", "physics/flesh/flesh_squishy_impact_hard4.wav"}
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.DeploySound = sdMain

local msg_player = {"You know NPC stands for Non-Player-Character, right?", "Looks like a player is already controlling this entity.", "You're about to become an NPC if you do that again."}
local msg_ragdoll = {"You're being as productive as that corpse.", "Maybe try controlling it before it died?"}
local msg_prop = {"This isn't prop hunt.", "Do you know how to turn the stove on?"}
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:PrimaryAttack()
	local owner = self:GetOwner()
	if CLIENT or !owner:IsPlayer() then return end
	
	local delayTime = CurTime() + VJ.AnimDuration(owner:GetViewModel(), ACT_VM_SECONDARYATTACK)
	owner:SetAnimation(PLAYER_ATTACK1)
	self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	self.PLY_NextIdleAnimT = delayTime
	self.PLY_NextReloadT = delayTime
	self:SetNextPrimaryFire(delayTime)
	self:EmitSound(VJ.PICK(sdMain), 80, 140, 1, CHAN_WEAPON, 0, 0, VJ_RecipientFilter)
	
	local ent = owner:GetEyeTrace().Entity
	if !IsValid(ent) then return end
	if ent:IsPlayer() then
		owner:ChatPrint(VJ.PICK(msg_player))
	elseif ent:GetClass() == "prop_ragdoll" then
		owner:ChatPrint(VJ.PICK(msg_ragdoll))
	elseif ent.VJ_ID_Prop then
		owner:ChatPrint(VJ.PICK(msg_prop))
	elseif !ent:IsNPC() then
		owner:ChatPrint("This isn't an NPC, therefore you can't control it.")
	elseif ent.VJ_IsBeingControlled then
		owner:ChatPrint("NPC is currently controlled by someone else.")
	else
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