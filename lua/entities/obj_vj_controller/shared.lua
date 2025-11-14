ENT.Base 			= "base_entity"
ENT.Type 			= "anim"
ENT.PrintName 		= "VJ Base NPC Controller"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Category		= "VJ Base"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetupDataTables()
	-- Entities
	self:NetworkVar("Entity", "Bullseye")
	self:NetworkVar("Entity", "Camera")
	self:NetworkVar("Entity", "Player")
	self:NetworkVar("Entity", "NPC")
	
	-- Camera values
	self:NetworkVar("Int", "CameraMode")
	self:NetworkVar("Vector", "CameraTP_Offset")
	self:NetworkVar("Vector", "CameraFP_Offset")
	self:NetworkVar("Int", "CameraFP_Bone")
	self:NetworkVar("Bool", "CameraFP_ShrinkBone")
	self:NetworkVar("Int", "CameraFP_BoneAng")
	self:NetworkVar("Int", "CameraFP_BoneAngOffset")
	
	-- NPC values
	self:NetworkVar("String", "NPCName")
	self:NetworkVar("Float", "NPCHealth")
	self:NetworkVar("Float", "NPCMaxHealth")
	self:NetworkVar("Int", "NPCAttackMelee")
	self:NetworkVar("Int", "NPCRangeAttack")
	self:NetworkVar("Int", "NPCLeapAttack")
	self:NetworkVar("Int", "NPCGrenadeAttack")
	self:NetworkVar("Entity", "NPCWeapon")
	self:NetworkVar("Int", "NPCWeaponAmmo")
	
	-- HUD values
	self:NetworkVar("Bool", "HUDEnabled")
end
---------------------------------------------------------------------------------------------------------------------------------------------
if !CLIENT then return end

ENT.VJC_Camera_Zoom = 100

local vec0 = Vector(0, 0, 0)
local vec1 = Vector(1, 1, 1)
local viewLerpVec = Vector(0, 0, 0)
local viewLerpAng = Angle(0, 0, 0)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Draw()
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	hook.Add("CalcView", self, self.CalcView)
	hook.Add("PlayerBindPress", self, self.PlayerBindPress)
	hook.Add("HUDPaint", self, self.HUD)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	-- Reset the NPC's bone manipulation!
	local npc = self:GetNPC()
	if IsValid(npc) then
		npc:ManipulateBoneScale(self:GetCameraFP_Bone(), vec1)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CalcView(ply, origin, angles, fov)
	if !IsValid(self) or self:GetPlayer() != ply then return end
	local camera = self:GetCamera()
	local npc = self:GetNPC()
	if !IsValid(camera) or !IsValid(npc) then return end
	local viewEnt = ply:GetViewEntity()
	if IsValid(viewEnt) && viewEnt:GetClass() == "gmod_cameraprop" then return end
	local cameraMode = self:GetCameraMode()
	local customData = npc.Controller_OnCalcView and npc:Controller_OnCalcView(self, ply, origin, angles, fov) or false
	-- !!!!!!!!!!!!!! DO NOT USE THESE !!!!!!!!!!!!!! [Backwards Compatibility!]
	if npc.Controller_CalcView then
		ply.VJCE_Camera = camera
		ply.VJCE_Camera.Zoom = self.VJC_Camera_Zoom
		ply.VJCE_NPC = self:GetNPC()
		ply.VJC_Camera_Mode = self:GetCameraMode()
		ply.VJC_TP_Offset = self:GetCameraTP_Offset()
		ply.VJC_FP_Offset = self:GetCameraFP_Offset()
		ply.VJC_FP_Bone = self:GetCameraFP_Bone()
		ply.VJC_FP_ShrinkBone = self:GetCameraFP_ShrinkBone()
		ply.VJC_FP_CameraBoneAng = self:GetCameraFP_BoneAng()
		ply.VJC_FP_CameraBoneAng_Offset = self:GetCameraFP_BoneAngOffset()
		local oldFunc = npc:Controller_CalcView(ply, origin, angles, fov, camera, cameraMode)
		if oldFunc then
			customData = oldFunc
		end
	end
	--
	local lerpSpeed = ply:GetInfoNum("vj_npc_cont_cam_speed", 6)
	local pos = origin -- The position that will be set
	local ang = ply:EyeAngles()
	
	-- MODE: Custom
	if customData then
		if istable(customData) then
			pos = customData.origin or origin
			ang = customData.angles or angles
			fov = customData.fov or fov
			lerpSpeed = customData.speed or lerpSpeed
		end
	-- MODE: First person
	elseif cameraMode == 2 then
		local setPos = npc:EyePos() + npc:GetForward() * 20
		local offset = self:GetCameraFP_Offset()
		//camera:SetLocalPos(camera:GetLocalPos() + self:GetCameraTP_Offset()) -- Help keep the camera stable
		if self:GetCameraFP_Bone() != -1 then -- If the bone does exist, then use the bone position
			local bonePos, boneAng = npc:GetBonePosition(self:GetCameraFP_Bone())
			setPos = bonePos
			if self:GetCameraFP_BoneAng() > 0 then
				ang[3] = boneAng[self:GetCameraFP_BoneAng()] + self:GetCameraFP_BoneAngOffset()
			end
			if self:GetCameraFP_ShrinkBone() then
				npc:ManipulateBoneScale(self:GetCameraFP_Bone(), vec0) -- Bone manipulate to make it easier to see
			end
		end
		pos = setPos + (npc:GetForward() * offset.x + npc:GetRight() * offset.y + npc:GetUp() * offset.z)
	-- MODE: Third person
	else
		if self:GetCameraFP_Bone() != -1 then -- Reset the NPC's bone manipulation
			npc:ManipulateBoneScale(self:GetCameraFP_Bone(), vec1)
		end
		local offset = self:GetCameraTP_Offset() + Vector(0, 0, npc:OBBMaxs().z - npc:OBBMins().z)
		//camera:SetLocalPos(camera:GetLocalPos() + self:GetCameraTP_Offset()) -- Help keep the camera stable
		local tr = util.TraceHull({
			start = npc:GetPos() + npc:OBBCenter(),
			endpos = npc:GetPos() + npc:OBBCenter() + angles:Forward() * -self.VJC_Camera_Zoom + (npc:GetForward() * offset.x + npc:GetRight() * offset.y + npc:GetUp() * offset.z),
			filter = {ply, camera, npc},
			mins = Vector(-5, -5, -5),
			maxs = Vector(5, 5, 5),
			mask = MASK_BLOCKLOS,
		})
		pos = tr.HitPos + tr.HitNormal * 2
	end

	-- Lerp the position and the angle
	viewLerpVec = (cameraMode == 2 and pos) or (lerpSpeed != 0 && LerpVector(FrameTime() * lerpSpeed, viewLerpVec, pos) or pos)
	viewLerpAng = (lerpSpeed != 0 && LerpAngle(FrameTime() * lerpSpeed, viewLerpAng, ang) or ang)
	
	-- Send the player's hit position to the controller entity
	local tr = util.TraceLine({
		start = viewLerpVec,
		endpos = viewLerpVec + viewLerpAng:Forward() * 32768,
		filter = function(ent) //{ply, camera, npc}
			if ent == ply or ent == camera or ent == npc then return false end
			if ent:GetClass() == "phys_bone_follower" && ent:GetOwner() == npc then return false end
			return true
		end,
	})
	//ParticleEffect("vj_impact_dirty", tr.HitPos, Angle(0, 0, 0), npc)
	net.Start("vj_controller_sv")
		net.WriteVector(tr.HitPos)
	net.SendToServer()
	
	return {
		origin = viewLerpVec,
		angles = viewLerpAng,
		fov = fov,
		drawviewer = false, //(cameraMode == 2 and true) or false
	}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PlayerBindPress(ply, bind, pressed)
	-- Scroll wheel zooming
	if IsValid(self) && self:GetPlayer() == ply && (bind == "invprev" or bind == "invnext") && IsValid(self:GetCamera()) && self:GetCameraMode() != 2 then
		if bind == "invprev" then
			self.VJC_Camera_Zoom = math.Clamp(self.VJC_Camera_Zoom - ply:GetInfoNum("vj_npc_cont_cam_zoom_speed", 10), 0, 500)
		else
			self.VJC_Camera_Zoom = math.Clamp(self.VJC_Camera_Zoom + ply:GetInfoNum("vj_npc_cont_cam_zoom_speed", 10), 0, 500)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local lerp_hp = 0
local box_roundness = 6
local box_border_thickness = 2
local color_red = VJ.COLOR_RED
local color_orange = VJ.COLOR_ORANGE_VIVID
local color_green = VJ.COLOR_GREEN
local color_cyan_muted = Color(0, 255, 255, 125)
local color_under = Color(0, 0, 0, 180)
local color_white = VJ.COLOR_WHITE
local mat_icon_melee = Material("vj_base/hud/melee.png")
local mat_icon_range = Material("vj_base/hud/range.png")
local mat_icon_leap = Material("vj_base/hud/leap.png")
local mat_icon_grenade = Material("vj_base/hud/grenade.png")
local mat_icon_gun = Material("vj_base/hud/gun.png")
local mat_icon_camera = Material("vj_base/hud/camera.png")
local mat_icon_zoom = Material("vj_base/hud/camera_zoom.png")
--
function ENT:HUD()
	local ply = LocalPlayer()
	if !IsValid(self) or self:GetPlayer() != ply then return end
	if !self:GetHUDEnabled() or ply:GetInfoNum("vj_npc_cont_hud", 1) == 0 then return end
	local health = self:GetNPCHealth()
	local healthMax = self:GetNPCMaxHealth()
	local atkMelee = self:GetNPCAttackMelee()
	local atkRange = self:GetNPCRangeAttack()
	local atkLeap = self:GetNPCLeapAttack()
	local atkGrenade = self:GetNPCGrenadeAttack()
	local atkWeapon = IsValid(self:GetNPCWeapon())
	local atkWeaponAmmo = self:GetNPCWeaponAmmo()
	local srcW = ScrW()
	local srcH = ScrH()
	
	draw.RoundedBox(box_roundness, srcW / 2.24, srcH - 130, 215, 100, Color(0, 0, 0, 150))
	draw.SimpleText(self:GetNPCName(), "VJBaseSmallMedium", srcW / 2.21, srcH - 125, color_white, 0, 0)
	
	-- Health
	lerp_hp = Lerp(8 * FrameTime(), lerp_hp, health)
	draw.RoundedBox(box_roundness, srcW / 2.21, srcH - 105, 190, 20, color_cyan_muted)
	draw.RoundedBox(box_roundness, srcW / 2.21 + box_border_thickness, srcH - 105 + box_border_thickness, 190 - box_border_thickness * 2, 20 - box_border_thickness * 2, color_under)
	draw.RoundedBox(box_roundness, srcW / 2.21 + box_border_thickness, srcH - 105 + box_border_thickness, ((190 * math.Clamp(lerp_hp, 0, healthMax)) / healthMax) - box_border_thickness * 2, 20 - box_border_thickness * 2, color_cyan_muted)
	draw.SimpleText(string.format("%.0f",  lerp_hp) .. "/" .. healthMax,  "VJBaseSmallMedium", (srcW / 1.99) - ((surface.GetTextSize(health .. "/" .. healthMax)) / 2), srcH - 103, color_white)
	
	-- Attack Icons
	surface.SetMaterial(mat_icon_melee)
	surface.SetDrawColor((atkMelee == 0 and color_red) or ((atkMelee == 2 and color_orange) or color_green))
	surface.DrawTexturedRect(srcW / 2.21, srcH - 83, 28, 28)
	
	surface.SetMaterial(mat_icon_range)
	surface.SetDrawColor((atkRange == 0 and color_red) or ((atkRange == 2 and color_orange) or color_green))
	surface.DrawTexturedRect(srcW / 2.14, srcH - 83, 28, 28)
	
	surface.SetMaterial(mat_icon_leap)
	surface.SetDrawColor((atkLeap == 0 and color_red) or ((atkLeap == 2 and color_orange) or color_green))
	surface.DrawTexturedRect(srcW / 2.065, srcH - 83, 28, 28)
	
	surface.SetMaterial(mat_icon_grenade)
	surface.SetDrawColor((atkGrenade == 0 and color_red) or ((atkGrenade == 2 and color_orange) or color_green))
	surface.DrawTexturedRect(srcW / 2.005, srcH - 83, 28, 28)
	
	surface.SetMaterial(mat_icon_gun)
	surface.SetDrawColor((!atkWeapon and color_red) or ((atkWeaponAmmo <= 0 and color_orange) or color_green))
	surface.DrawTexturedRect(srcW / 1.94, srcH - 83, 28, 28)
	if atkWeapon then
		draw.SimpleText(atkWeaponAmmo, "VJBaseMedium", srcW / 1.885, srcH - 80, (atkWeaponAmmo <= 0 and color_orange) or color_green, 0, 0)
	end
	
	-- Camera Mode
	surface.SetMaterial(mat_icon_camera)
	surface.SetDrawColor(color_white)
	surface.DrawTexturedRect(srcW / 2.21, srcH - 55, 22, 22)
	draw.SimpleText((self:GetCameraMode() == 1 and "Third") or "First", "VJBaseMedium", srcW / 2.14, srcH - 55, color_white, 0, 0)
	
	-- Camera Zoom
	surface.SetMaterial(mat_icon_zoom)
	surface.SetDrawColor(color_white)
	surface.DrawTexturedRect(srcW / 1.94, srcH - 55, 22, 22)
	draw.SimpleText(self.VJC_Camera_Zoom, "VJBaseMedium", srcW / 1.885, srcH - 55, color_white, 0, 0)
end