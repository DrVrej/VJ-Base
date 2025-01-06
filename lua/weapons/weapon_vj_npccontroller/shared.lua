SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= "VJ NPC Controller"
SWEP.Author 					= "DrVrej"
SWEP.Contact					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose					= "This weapon is made to control NPCs. Mostly VJ SNPCs"
SWEP.Instructions				= "Press Fire to control the NPC you are looking at."
SWEP.Category					= "VJ Base"
	-- Client Settings ---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
SWEP.Slot						= 5 -- Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6) 
SWEP.SlotPos					= 7 -- Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6)
SWEP.SwayScale 					= 1 -- Default is 1, The scale of the viewmodel sway
SWEP.CSMuzzleFlashes 			= false -- Use CS:S Muzzle flash?
SWEP.DrawAmmo					= true -- Draw regular Garry's Mod HUD?
SWEP.DrawCrosshair				= true -- Draw Crosshair?
SWEP.DrawWeaponInfoBox 			= true -- Should the information box show in the weapon selection menu?
SWEP.BounceWeaponIcon 			= true -- Should the icon bounce in the weapon selection menu?
SWEP.RenderGroup 				= RENDERGROUP_OPAQUE
end
	-- Server Settings ---------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
SWEP.Weight = 30 -- Decides whether we should switch from/to this
SWEP.AutoSwitchTo = false -- Auto switch to this weapon when it's picked up
SWEP.AutoSwitchFrom = false -- Auto switch weapon when the owner picks up a better weapon
end
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.ViewModel = "models/vj_base/weapons/c_controller.mdl"
SWEP.WorldModel = "models/vj_base/gibs/human/brain.mdl"
SWEP.HoldType = "pistol"
SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.UseHands = true -- Should this weapon use Garry's Mod hands? (The model must support it!)
	-- Primary/Secondary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
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

SWEP.WorldModel_UseCustomPosition = true -- Should the gun use custom position? This can be used to fix guns that are in the crotch
SWEP.WorldModel_CustomPositionAngle = Vector(0, 0, 0)
SWEP.WorldModel_CustomPositionOrigin = Vector(0, 4, -1.1)
SWEP.WorldModel_CustomPositionBone = "ValveBiped.Bip01_R_Hand" -- The bone it will use as the main point (Owner's bone)

SWEP.DeploySound = {"physics/flesh/flesh_squishy_impact_hard1.wav","physics/flesh/flesh_squishy_impact_hard2.wav","physics/flesh/flesh_squishy_impact_hard3.wav","physics/flesh/flesh_squishy_impact_hard4.wav"} -- Sound played when the weapon is deployed
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:PrimaryAttack()
	local owner = self:GetOwner()
	if CLIENT or owner:IsNPC() then return end
	
	owner:SetAnimation(PLAYER_ATTACK1)
	local anim = ACT_VM_SECONDARYATTACK
	local animTime = VJ.AnimDuration(owner:GetViewModel(), anim)
	self:SendWeaponAnim(anim)
	self.NextIdleT = CurTime() + animTime
	self.NextReloadT = CurTime() + animTime
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
		elseif tr.Entity:IsNPC() && tr.Entity:Health() <= 0 then
			owner:ChatPrint("This NPC's health is 0 or below, therefore you can't control.")
			return
		elseif tr.Entity.VJ_IsBeingControlled == true then
			owner:ChatPrint("You can't control this NPC, it's already being controlled by someone else.")
			return
		end
		if (!tr.Entity.IsVJBaseSNPC) then
			owner:ChatPrint("NOTE: VJ NPC controller is mainly made for VJ Base SNPCs!")
		end
		local SpawnControllerObject = ents.Create("obj_vj_npccontroller")
		SpawnControllerObject.VJCE_Player = owner
		SpawnControllerObject:SetControlledNPC(tr.Entity)
		SpawnControllerObject:Spawn()
		//SpawnControllerObject:Activate()
		SpawnControllerObject:StartControlling()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:SecondaryAttack() return false end