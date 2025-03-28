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
SWEP.Primary.SoundPitch	= VJ.SET(140, 140)
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DeploySound = {"physics/flesh/flesh_squishy_impact_hard1.wav", "physics/flesh/flesh_squishy_impact_hard2.wav", "physics/flesh/flesh_squishy_impact_hard3.wav", "physics/flesh/flesh_squishy_impact_hard4.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:PrimaryAttack()
	local owner = self:GetOwner()
	if CLIENT or owner:IsNPC() then return end
	
	owner:SetAnimation(PLAYER_ATTACK1)
	local anim = ACT_VM_SECONDARYATTACK
	local animTime = VJ.AnimDuration(owner:GetViewModel(), anim)
	self:SendWeaponAnim(anim)
	self.PLY_NextIdleAnimT = CurTime() + animTime
	self.PLY_NextReloadT = CurTime() + animTime
	self:SetNextPrimaryFire(CurTime() + animTime)
	
	local fireSd = VJ.PICK(self.Primary.Sound)
	if fireSd != false then
		sound.Play(fireSd, owner:GetPos(), self.Primary.SoundLevel, math.random(self.Primary.SoundPitch.a, self.Primary.SoundPitch.b), self.Primary.SoundVolume)
	end
	
	local tr =  util.TraceLine(util.GetPlayerTrace(owner))
	if tr.Entity && IsValid(tr.Entity) then
		if tr.Entity:IsPlayer() then
			owner:ChatPrint("That's a player dumbass.")
			return
		elseif tr.Entity:GetClass() == "prop_ragdoll" then
			owner:ChatPrint("You are about to become that corpse.")
			return
		elseif tr.Entity:GetClass() == "prop_physics" then
			owner:ChatPrint("Uninstall your game. Now.")
			return
		elseif !tr.Entity:IsNPC() then
			owner:ChatPrint("This isn't an NPC, therefore you can't control it.")
			return
		elseif tr.Entity.VJ_IsBeingControlled == true then
			owner:ChatPrint("You can't control this NPC, it's already being controlled by someone else.")
			return
		end
		if !tr.Entity.IsVJBaseSNPC then
			owner:ChatPrint("NOTE: NPC Controller is mainly made for VJ Base NPCs!")
		end
		local SpawnControllerObject = ents.Create("obj_vj_controller")
		SpawnControllerObject.VJCE_Player = owner
		SpawnControllerObject:SetControlledNPC(tr.Entity)
		SpawnControllerObject:Spawn()
		//SpawnControllerObject:Activate()
		SpawnControllerObject:StartControlling()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:SecondaryAttack() return false end