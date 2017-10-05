if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
//SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= "VJ NPC Controller"
SWEP.Author 					= "DrVrej"
SWEP.Contact					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose					= "This weapon is made to control NPCs. Mostly VJ SNPCs"
SWEP.Instructions				= "Press Fire to control the NPC you are looking at."
SWEP.Category					= "VJ Base"
	-- Client Settings ---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
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
if (SERVER) then
SWEP.Weight						= 30 -- Decides whether we should switch from/to this
SWEP.AutoSwitchTo				= false -- Auto switch to this weapon when it's picked up
SWEP.AutoSwitchFrom				= false -- Auto switch weapon when the owner picks up a better weapon
end
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.ViewModel					= "models/vj_weapons/v_glock.mdl"
SWEP.WorldModel					= "models/weapons/w_glock.mdl"
SWEP.HoldType 					= "pistol"
SWEP.Spawnable					= true
SWEP.AdminSpawnable				= false
	-- Primary/Secondary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.ClipSize 			= -1
SWEP.Primary.DefaultClip		= -1
SWEP.Primary.Automatic 			= false
SWEP.Primary.Ammo 				= "none"
SWEP.Secondary.ClipSize 		= -1
SWEP.Secondary.DefaultClip 		= -1
SWEP.Secondary.Automatic 		= false
SWEP.Secondary.Ammo 			= "none"
	-- Independent Variables ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Deleted					= false
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:PrimaryAttack()
	if CLIENT or self.Owner:IsNPC() then return end
	local tracedata = {}
	tracedata.start = self.Owner:EyePos()
	tracedata.endpos = self.Owner:EyePos() + self.Owner:GetAimVector()*32768
	tracedata.filter = {self.Owner}
	local tr =  util.TraceLine(util.GetPlayerTrace(self.Owner))
	if tr.Entity && IsValid(tr.Entity) then
		if tr.Entity:IsPlayer() then
			self.Owner:ChatPrint("That's a player dumbass.")
			return
		elseif tr.Entity:GetClass() == "prop_ragdoll" then
			self.Owner:ChatPrint("That's a ragdoll you retard.")
			return
		elseif tr.Entity:GetClass() == "prop_physics" then
			self.Owner:ChatPrint("Uninstall your game. Now.")
			return
		elseif !tr.Entity:IsNPC() then
			self.Owner:ChatPrint("This isn't an NPC, therefore you can't control it.")
			return
		elseif tr.Entity:IsNPC() && tr.Entity:Health() <= 0 then
			self.Owner:ChatPrint("This NPC's health is 0 or below, therefore you can't control.")
			return
		//elseif tr.Entity.IsVJBaseSNPC_Tank == true then
			//tr.Entity = tr.Entity.Gunner
			//self.Owner:ChatPrint("Tank are not controllable yet, sorry!")
			//return
		elseif tr.Entity.VJ_IsBeingControlled == true then
			self.Owner:ChatPrint("You can't control this NPC, it's already being controlled by someone else.")
			return
		end
		if (!tr.Entity.IsVJBaseSNPC) then
			self.Owner:ChatPrint("NOTE: VJ NPC controller is mainly made for VJ Base SNPCs!")
		end
		local SpawnControllerObject = ents.Create("ob_vj_npccontroller")
		SpawnControllerObject.TheController = self.Owner
		SpawnControllerObject:SetControlledNPC(tr.Entity)
		SpawnControllerObject:Spawn()
		//SpawnControllerObject:Activate()
		SpawnControllerObject:StartControlling()
	end
	self:SetNextPrimaryFire(CurTime() + 0.5)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:SecondaryAttack() return false end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:Think() end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:Reload() end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OnRemove() self.Deleted = true end
