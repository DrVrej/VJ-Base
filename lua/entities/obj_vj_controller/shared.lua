ENT.Base 			= "base_entity"
ENT.Type 			= "anim"
ENT.PrintName 		= "NPC Controller Base"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "To make my (S)NPCs controllable."
ENT.Instructions 	= "Don't change anything."
ENT.Category		= "VJ Base"

ENT.Spawnable 		= false
ENT.AdminSpawnable 	= false
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	function ENT:Draw()
		return false
	end
	
	local vec0 = Vector(0, 0, 0)
	local vec1 = Vector(1, 1, 1)
	local viewLerpVec = Vector(0, 0, 0)
	local viewLerpAng = Angle(0, 0, 0)
	---------------------------------------------------------------------------------------------------------------------------------------------
	hook.Add("CalcView", "vj_controller_CalcView", function(ply, origin, angles, fov)
		if !ply.VJ_IsControllingNPC then return end
		local camera = ply.VJCE_Camera -- Camera entity
		local npc = ply.VJCE_NPC -- NPC that is being controlled
		if !IsValid(camera) or !IsValid(npc) then return end
		if IsValid(ply:GetViewEntity()) && ply:GetViewEntity():GetClass() == "gmod_cameraprop" then return end
		local cameraMode = ply.VJC_Camera_Mode
		local customData = npc.Controller_CalcView and npc:Controller_CalcView(ply, origin, angles, fov, camera, cameraMode) or false
		local lerpSpeed = ply:GetInfoNum("vj_npc_cont_cam_speed", 6)
	
		local pos = origin -- The position that will be set
		local ang = ply:EyeAngles()
		if customData then -- More direct control over the calc view, where as before we were limited to alterations of the below code
			if istable(customData) then -- Make sure it is a table
				pos = customData.origin or origin
				ang = customData.angles or angles
				fov = customData.fov or fov
				lerpSpeed = customData.speed or lerpSpeed
			end
		else
			if cameraMode == 2 then -- First person
				local setPos = npc:EyePos() + npc:GetForward()*20
				local offset = ply.VJC_FP_Offset
				//camera:SetLocalPos(camera:GetLocalPos() + ply.VJC_TP_Offset) -- Help keep the camera stable
				if ply.VJC_FP_Bone != -1 then -- If the bone does exist, then use the bone position
					local bonePos, boneAng = npc:GetBonePosition(ply.VJC_FP_Bone)
					setPos = bonePos
					if ply.VJC_FP_CameraBoneAng > 0 then
						ang[3] = boneAng[ply.VJC_FP_CameraBoneAng] + ply.VJC_FP_CameraBoneAng_Offset
					end
					if ply.VJC_FP_ShrinkBone then
						npc:ManipulateBoneScale(ply.VJC_FP_Bone, vec0) -- Bone manipulate to make it easier to see
					end
				end
				pos = setPos + (npc:GetForward()*offset.x + npc:GetRight()*offset.y + npc:GetUp()*offset.z)
			else -- Third person
				if ply.VJC_FP_Bone != -1 then -- Reset the NPC's bone manipulation!
					ply.VJCE_NPC:ManipulateBoneScale(ply.VJC_FP_Bone, vec1)
				end
				local offset = ply.VJC_TP_Offset + Vector(0, 0, npc:OBBMaxs().z - npc:OBBMins().z) // + vectp
				//camera:SetLocalPos(camera:GetLocalPos() + ply.VJC_TP_Offset) -- Help keep the camera stable
				local tr = util.TraceHull({
					start = npc:GetPos() + npc:OBBCenter(),
					endpos = npc:GetPos() + npc:OBBCenter() + angles:Forward()*-camera.Zoom + (npc:GetForward()*offset.x + npc:GetRight()*offset.y + npc:GetUp()*offset.z),
					filter = {ply, camera, npc},
					mins = Vector(-5, -5, -5),
					maxs = Vector(5, 5, 5),
					mask = MASK_SHOT,
				})
				pos = tr.HitPos + tr.HitNormal*2
			end
		end

		-- Lerp the position and the angle
		viewLerpVec = (cameraMode == 2 and pos) or (lerpSpeed != 0 && LerpVector(FrameTime()*lerpSpeed, viewLerpVec, pos) or pos)
        viewLerpAng = (lerpSpeed != 0 && LerpAngle(FrameTime()*lerpSpeed, viewLerpAng, ang) or ang)
		
		-- Send the player's hit position to the controller entity
		local tr = util.TraceLine({start = viewLerpVec, endpos = viewLerpVec + viewLerpAng:Forward()*32768, filter = {ply, camera, npc}})
		//ParticleEffect("vj_impact_dirty", tr.HitPos, Angle(0,0,0), npc)
		net.Start("vj_controller_cldata")
			net.WriteVector(tr.HitPos)
		net.SendToServer()
		
		local view = {
			origin = viewLerpVec,
			angles = viewLerpAng,
			fov = fov,
			drawviewer = false, //(cameraMode == 2 and true) or false
		}
		return view
	end)
	---------------------------------------------------------------------------------------------------------------------------------------------
	hook.Add("PlayerBindPress", "vj_controller_PlayerBindPress", function(ply, bind, pressed)
		-- For scroll wheel zooming
		if (bind == "invprev" or bind == "invnext") && ply.VJ_IsControllingNPC && IsValid(ply.VJCE_Camera) && ply.VJC_Camera_Mode != 2 then
			ply.VJCE_Camera.Zoom = ply.VJCE_Camera.Zoom or 100
			if bind == "invprev" then
				ply.VJCE_Camera.Zoom = math.Clamp(ply.VJCE_Camera.Zoom - ply:GetInfoNum("vj_npc_cont_cam_zoomspeed", 10), 0, 500)
			else
				ply.VJCE_Camera.Zoom = math.Clamp(ply.VJCE_Camera.Zoom + ply:GetInfoNum("vj_npc_cont_cam_zoomspeed", 10), 0, 500)
			end
		end
	end)
	---------------------------------------------------------------------------------------------------------------------------------------------
	net.Receive("vj_controller_data", function(len)
		//print("Data Sent!")
		//print(len)
		local ply = LocalPlayer()
		ply.VJ_IsControllingNPC = net.ReadBool()
		ply.VJCE_Camera = ents.GetByIndex(net.ReadUInt(14))
		ply.VJCE_Camera.Zoom = ply.VJCE_Camera.Zoom or 100
		-- If the controller has stopped then reset the NPC's bone manipulation!
		if ply.VJ_IsControllingNPC == false && IsValid(ply.VJCE_NPC) && ply.VJC_FP_Bone != -1 then
			ply.VJCE_NPC:ManipulateBoneScale(ply.VJC_FP_Bone, vec1)
		end
		ply.VJCE_NPC = ents.GetByIndex(net.ReadUInt(14))
		ply.VJC_Camera_Mode = net.ReadUInt(2)
		ply.VJC_TP_Offset = net.ReadVector()
		ply.VJC_FP_Offset = net.ReadVector()
		ply.VJC_FP_Bone = net.ReadInt(10)
		ply.VJC_FP_ShrinkBone = net.ReadBool()
		ply.VJC_FP_CameraBoneAng = net.ReadUInt(2) or 0
		ply.VJC_FP_CameraBoneAng_Offset = net.ReadInt(10) or 0
	end)
	---------------------------------------------------------------------------------------------------------------------------------------------
	local lerp_hp = 0
	local atk_col_red = Color(255, 60, 60, 255)
	local atk_col_orange = Color(204, 123, 60, 255)
	local atk_col_green = Color(60, 220, 60, 255)
	local mat_icon_melee = Material("vj_base/hud_controller/melee.png")
	local mat_icon_range = Material("vj_base/hud_controller/range.png")
	local mat_icon_leap = Material("vj_base/hud_controller/leap.png")
	local mat_icon_grenade = Material("vj_base/hud_controller/grenade.png")
	local mat_icon_gun = Material("vj_base/hud_controller/gun.png")
	local mat_icon_camera = Material("vj_base/hud_controller/camera.png")
	local mat_icon_zoom = Material("vj_base/hud_controller/camera_zoom.png")
	net.Receive("vj_controller_hud", function(len)
		//print(len)
		local enabled = net.ReadBool()
		local maxhp = net.ReadFloat()
		local hp = net.ReadFloat()
		local name = net.ReadString()
		local atkMelee = net.ReadInt(3)
		local atkRange = net.ReadInt(3)
		local atkLeap = net.ReadInt(3)
		local atkWeapon = net.ReadBool()
		local atkWeaponAmmo = net.ReadInt(32)
		local atkGrenade = net.ReadInt(3)
		local ply = LocalPlayer()
		hook.Add("HUDPaint", "vj_controller_HUD", function()
			draw.RoundedBox(1, ScrW() / 2.25, ScrH()-120, 220, 100, Color(0, 0, 0, 150))
			draw.SimpleText(name, "VJBaseSmallMedium", ScrW() / 2.21, ScrH()-115, Color(255,255,255,255), 0, 0)
			
			local hp_r = 255
			local hp_g = 153
			local hp_b = 0
			lerp_hp = Lerp(5*FrameTime(),lerp_hp,hp)
			draw.RoundedBox(0, ScrW() / 2.21, ScrH()-95, 180, 20, Color(hp_r,hp_g,hp_b,40))
			draw.RoundedBox(0, ScrW() / 2.21, ScrH()-95, (190*math.Clamp(lerp_hp,0,maxhp))/maxhp,20, Color(hp_r,hp_g,hp_b,255))
			surface.SetDrawColor(hp_r,hp_g,hp_b,255)
			surface.DrawOutlinedRect( ScrW() / 2.21, ScrH()-95,180,20)
			
			local finalhp = tostring(string.format("%.0f", lerp_hp).."/"..maxhp)
			local distlen = string.len(finalhp)
			local move = 0
			if distlen > 1 then
				move = move - (0.009*(distlen-1))
			end
			draw.SimpleText(finalhp, "VJBaseSmallMedium", ScrW() / (2-move), ScrH()-94, Color(255,255,255,255), 0, 0)
			
			-- Attack Icons
			surface.SetMaterial(mat_icon_melee)
			surface.SetDrawColor((atkMelee == 0 and atk_col_red) or ((atkMelee == 2 and atk_col_orange) or atk_col_green))
			surface.DrawTexturedRect(ScrW() / 2.21, ScrH()-73, 28, 28)
			
			surface.SetMaterial(mat_icon_range)
			surface.SetDrawColor((atkRange == 0 and atk_col_red) or ((atkRange == 2 and atk_col_orange) or atk_col_green))
			surface.DrawTexturedRect(ScrW() / 2.14, ScrH()-73, 28, 28)
			
			surface.SetMaterial(mat_icon_leap)
			surface.SetDrawColor((atkLeap == 0 and atk_col_red) or ((atkLeap == 2 and atk_col_orange) or atk_col_green))
			surface.DrawTexturedRect(ScrW() / 2.065, ScrH()-73, 28, 28)
			
			surface.SetMaterial(mat_icon_grenade)
			surface.SetDrawColor((atkGrenade == 0 and atk_col_red) or ((atkGrenade == 2 and atk_col_orange) or atk_col_green))
			surface.DrawTexturedRect(ScrW() / 2.005, ScrH()-73, 28, 28)
			
			surface.SetMaterial(mat_icon_gun)
			surface.SetDrawColor((!atkWeapon and atk_col_red) or ((atkWeaponAmmo <= 0 and atk_col_orange) or atk_col_green))
			surface.DrawTexturedRect(ScrW() / 1.94, ScrH()-73, 28, 28) // 1.865
			draw.SimpleText(atkWeaponAmmo, "VJBaseMedium", ScrW() / 1.885, ScrH()-70, (!atkWeapon and atk_col_red) or ((atkWeaponAmmo <= 0 and atk_col_orange) or atk_col_green), 0, 0)
			
			-- Camera
			surface.SetMaterial(mat_icon_camera)
			surface.SetDrawColor(Color(255, 255, 255, 255))
			surface.DrawTexturedRect(ScrW() / 2.21, ScrH()-45, 22, 22)
			draw.SimpleText((ply.VJC_Camera_Mode == 1 and "Third") or "First", "VJBaseSmallMedium", ScrW() / 2.155, ScrH()-43, Color(255, 255, 255, 255), 0, 0) // VJBaseSmallMedium
			
			-- Zoom Camera
			surface.SetMaterial(mat_icon_zoom)
			surface.SetDrawColor(Color(255, 255, 255, 255))
			surface.DrawTexturedRect(ScrW() / 2.065, ScrH()-45, 22, 22)
			draw.SimpleText(ply.VJCE_Camera.Zoom, "VJBaseMedium", ScrW() / 2.005, ScrH()-45, Color(255, 255, 255, 255), 0, 0) // VJBaseSmallMedium
		end)
		if enabled != true then hook.Remove("HUDPaint", "vj_controller_HUD") end
	end)
end