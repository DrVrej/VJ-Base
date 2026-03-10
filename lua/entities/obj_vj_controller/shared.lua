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
local math_clamp = math.Clamp
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Draw()
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	hook.Add("CalcView", self, self.CalcView)
	hook.Add("PlayerBindPress", self, self.PlayerBindPress)
	hook.Add("HUDPaint", self, self.HUD)
	
	local ply = self:GetPlayer()
	if IsValid(ply) then
		ply.VJ_IsControllingNPC = true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	local ply = self:GetPlayer()
	if IsValid(ply) then
		ply.VJ_IsControllingNPC = false
	end
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
			self.VJC_Camera_Zoom = math_clamp(self.VJC_Camera_Zoom - ply:GetInfoNum("vj_npc_cont_cam_zoom_speed", 10), 0, 500)
		else
			self.VJC_Camera_Zoom = math_clamp(self.VJC_Camera_Zoom + ply:GetInfoNum("vj_npc_cont_cam_zoom_speed", 10), 0, 500)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- Settings
local box_roundness = 6
local box_border_thickness = 2

-- Colors
local color_red = VJ.COLOR_RED
local color_orange = VJ.COLOR_ORANGE_VIVID
local color_green = VJ.COLOR_GREEN
local color_cyan_muted = Color(0, 255, 255, 125)
local color_box = Color(0, 0, 0, 150)
local color_box_under = Color(0, 0, 0, 180)
local color_white = VJ.COLOR_WHITE

-- Materials
local mat_icon_melee = Material("vj_base/hud/melee.png")
local mat_icon_range = Material("vj_base/hud/range.png")
local mat_icon_leap = Material("vj_base/hud/leap.png")
local mat_icon_grenade = Material("vj_base/hud/grenade.png")
local mat_icon_gun = Material("vj_base/hud/gun.png")
local mat_icon_camera = Material("vj_base/hud/camera.png")
local mat_icon_zoom = Material("vj_base/hud/camera_zoom.png")

local lerp_hp = 0
local attack_icon_color = {[0] = color_red, [1] = color_green, [2] = color_orange}
local draw_RoundedBox = draw.RoundedBox
local draw_SimpleText = draw.SimpleText
local surface_SetMaterial = surface.SetMaterial
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawTexturedRect = surface.DrawTexturedRect
local surface_SetFont = surface.SetFont
local surface_GetTextSize = surface.GetTextSize
local math_max = math.max
local ScrW, ScrH = ScrW, ScrH
--
function ENT:HUD()
	local ply = LocalPlayer()
	if !IsValid(self) or self:GetPlayer() != ply then return end
	if !self:GetHUDEnabled() or ply:GetInfoNum("vj_npc_cont_hud", 1) == 0 then return end
	local srcW, srcH = ScrW(), ScrH()
	local health = self:GetNPCHealth()
	local healthMax = self:GetNPCMaxHealth()
	local atkMelee = self:GetNPCAttackMelee()
	local atkRange = self:GetNPCRangeAttack()
	local atkLeap = self:GetNPCLeapAttack()
	local atkGrenade = self:GetNPCGrenadeAttack()
	local atkWeapon = IsValid(self:GetNPCWeapon())
	local atkWeaponAmmo = self:GetNPCWeaponAmmo()
	
	-- Calculate NPC Name Width
	local npcName = self:GetNPCName()
	surface_SetFont("VJBaseSmallMedium")
	local nameWidth, _ = surface_GetTextSize(npcName)
	local boxWidth = math_max(215, nameWidth + 35) -- Automatically adapt if text is longer than 215 width
	
	local boxX = srcW / 2.24
	local boxCenterX = boxX + (boxWidth / 2)
	
	-- Background Panel
	draw_RoundedBox(box_roundness, boxX, srcH - 130, boxWidth, 100, color_box)
	draw_SimpleText(npcName, "VJBaseSmallMedium", boxCenterX, srcH - 125, color_white, 1, 0)
	
	-- Health
	lerp_hp = Lerp(8 * FrameTime(), lerp_hp, health)
	local hpBarWidth = 190
	local hpBarX = boxCenterX - (hpBarWidth / 2)
	draw_RoundedBox(box_roundness, hpBarX, srcH - 105, hpBarWidth, 20, color_cyan_muted)
	draw_RoundedBox(box_roundness, hpBarX + box_border_thickness, srcH - 105 + box_border_thickness, hpBarWidth - box_border_thickness * 2, 20 - box_border_thickness * 2, color_box_under)
	draw_RoundedBox(box_roundness, hpBarX + box_border_thickness, srcH - 105 + box_border_thickness, ((hpBarWidth * math_clamp(lerp_hp, 0, healthMax)) / healthMax) - box_border_thickness * 2, 20 - box_border_thickness * 2, color_cyan_muted)
	draw_SimpleText(string.format("%.0f",  lerp_hp) .. "/" .. healthMax,  "VJBaseSmallMedium", boxCenterX, srcH - 103, color_white, 1, 0)
	
	-- Attack Icons
	surface_SetFont("VJBaseMedium")
	local ammoText = tostring(atkWeaponAmmo)
	local ammoWidth = 0
	if atkWeapon then
		ammoWidth, _ = surface_GetTextSize(ammoText)
		ammoWidth = ammoWidth + 5 -- Add padding
	end
	
	local iconSize = 28
	local iconGap = 6
	local totalIconWidth = (iconSize * 5) + (iconGap * 4) + ammoWidth
	local iconStartX = boxCenterX - (totalIconWidth / 2)
	
	surface_SetMaterial(mat_icon_melee)
	surface_SetDrawColor(attack_icon_color[atkMelee] or color_green)
	surface_DrawTexturedRect(iconStartX, srcH - 83, iconSize, iconSize)
	
	surface_SetMaterial(mat_icon_range)
	surface_SetDrawColor(attack_icon_color[atkRange] or color_green)
	surface_DrawTexturedRect(iconStartX + (iconSize + iconGap), srcH - 83, iconSize, iconSize)
	
	surface_SetMaterial(mat_icon_leap)
	surface_SetDrawColor(attack_icon_color[atkLeap] or color_green)
	surface_DrawTexturedRect(iconStartX + (iconSize + iconGap) * 2, srcH - 83, iconSize, iconSize)
	
	surface_SetMaterial(mat_icon_grenade)
	surface_SetDrawColor(attack_icon_color[atkGrenade] or color_green)
	surface_DrawTexturedRect(iconStartX + (iconSize + iconGap) * 3, srcH - 83, iconSize, iconSize)
	
	surface_SetMaterial(mat_icon_gun)
	surface_SetDrawColor((!atkWeapon and color_red) or ((atkWeaponAmmo <= 0 and color_orange) or color_green))
	surface_DrawTexturedRect(iconStartX + (iconSize + iconGap) * 4, srcH - 83, iconSize, iconSize)
	if atkWeapon then
		draw_SimpleText(ammoText, "VJBaseMedium", iconStartX + (iconSize + iconGap) * 4 + iconSize + 5, srcH - 80, (atkWeaponAmmo <= 0 and color_orange) or color_green, 0, 0)
	end
	
	-- Camera Mode & Zoom
	local modeText = (self:GetCameraMode() == 1 and "Third") or "First"
	local zoomText = tostring(self.VJC_Camera_Zoom)
	local modeWidth, _ = surface_GetTextSize(modeText)
	local zoomWidth, _ = surface_GetTextSize(zoomText)
	local camIconSize = 22
	local camTextGap = 5
	local camSectionGap = 20
	
	local totalCamWidth = camIconSize + camTextGap + modeWidth + camSectionGap + camIconSize + camTextGap + zoomWidth
	local camStartX = boxCenterX - (totalCamWidth / 2)
	
	surface_SetMaterial(mat_icon_camera)
	surface_SetDrawColor(color_white)
	surface_DrawTexturedRect(camStartX, srcH - 55, camIconSize, camIconSize)
	draw_SimpleText(modeText, "VJBaseMedium", camStartX + camIconSize + camTextGap, srcH - 55, color_white, 0, 0)
	
	local zoomStartX = camStartX + camIconSize + camTextGap + modeWidth + camSectionGap
	surface_SetMaterial(mat_icon_zoom)
	surface_SetDrawColor(color_white)
	surface_DrawTexturedRect(zoomStartX, srcH - 55, camIconSize, camIconSize)
	draw_SimpleText(zoomText, "VJBaseMedium", zoomStartX + camIconSize + camTextGap, srcH - 55, color_white, 0, 0)
end
