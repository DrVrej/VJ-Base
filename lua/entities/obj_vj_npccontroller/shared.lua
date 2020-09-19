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
if (CLIENT) then
	function ENT:Draw() end
	
	local vec0 = Vector(0, 0, 0)
	local vec1 = Vector(1, 1, 1)
	local viewLerpVec = Vector(0, 0, 0)
	local viewLerpAng = Angle(0, 0, 0)
	---------------------------------------------------------------------------------------------------------------------------------------------
	hook.Add("CalcView", "VJ_MyCalcView", function(ply, origin, angles, fov)
		if !ply.IsControlingNPC then return end
		local camera = ply.VJCE_Camera -- Camera entity
		local npc = ply.VJCE_NPC -- The NPC that's being controlled
		if !IsValid(ply.VJCE_Camera) or !IsValid(ply.VJCE_NPC) then return end
		
		local pos = origin -- The position that will be set
		if ply.VJC_Camera_Mode == 2 then -- First person
			local setPos = npc:EyePos() + npc:GetForward()*20
			local offset = ply.VJC_FP_Offset
			//camera:SetLocalPos(camera:GetLocalPos() + ply.VJC_TP_Offset) -- Help keep the camera stable
			if ply.VJC_FP_Bone != -1 then -- If the bone does exist, then use the bone position
				setPos = npc:GetBonePosition(ply.VJC_FP_Bone)
				npc:ManipulateBoneScale(ply.VJC_FP_Bone, vec0) -- Bone manipulate to make it easier to see
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
		
		-- Lerp the position and the angle
		local lerpSpeed = ply:GetInfoNum("vj_npc_cont_cam_speed", 6)
		viewLerpVec = (ply.VJC_Camera_Mode == 2 and pos) or LerpVector(FrameTime()*lerpSpeed, viewLerpVec, pos)
        viewLerpAng = LerpAngle(FrameTime()*lerpSpeed, viewLerpAng, ply:EyeAngles())
		
		-- Send the player's hit position to the controller entity
		local tr = util.TraceLine({start = viewLerpVec, endpos = viewLerpVec + viewLerpAng:Forward()*32768, filter = {ply, camera, npc}})
		//ParticleEffect("vj_impact1_centaurspit", tr.HitPos, Angle(0,0,0), npc)
		net.Start("vj_controller_cldata")
			net.WriteVector(tr.HitPos)
		net.SendToServer()
		
		local view = {
			origin = viewLerpVec,
			angles = viewLerpAng,
			fov = fov,
			drawviewer = (ply.VJC_Camera_Mode == 2 and true) or false
		}
		return view
	end)
	---------------------------------------------------------------------------------------------------------------------------------------------
	hook.Add("PlayerBindPress", "vj_controller_PlayerBindPress", function(ply, bind, pressed)
		-- For scroll wheel zooming
		if (bind == "invprev" or bind == "invnext") && ply.IsControlingNPC && IsValid(ply.VJCE_Camera) then
			ply.VJCE_Camera.Zoom = ply.VJCE_Camera.Zoom or 90
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
		ply.IsControlingNPC = net.ReadBool()
		ply.VJCE_Camera = ents.GetByIndex(net.ReadUInt(14))
		ply.VJCE_Camera.Zoom = ply.VJCE_Camera.Zoom or 90
		-- If the controller has stopped then reset the NPC's bone manipulation!
		if ply.IsControlingNPC == false && IsValid(ply.VJCE_NPC) && ply.VJC_FP_Bone != -1 then
			ply.VJCE_NPC:ManipulateBoneScale(ply.VJC_FP_Bone, vec1)
		end
		ply.VJCE_NPC = ents.GetByIndex(net.ReadUInt(14))
		ply.VJC_Camera_Mode = net.ReadUInt(2)
		ply.VJC_TP_Offset = net.ReadVector()
		ply.VJC_FP_Offset = net.ReadVector()
		ply.VJC_FP_Bone = net.ReadInt(10)
	end)
	---------------------------------------------------------------------------------------------------------------------------------------------
	local lerp_hp = 0
	net.Receive("vj_controller_hud", function(len)
		//print(len)
		local enabled = net.ReadBool()
		local maxhp = net.ReadFloat()
		local hp = net.ReadFloat()
		local name = net.ReadString()
		local AtkTbl = net.ReadTable()
		hook.Add("HUDPaint","VJ_Controller",function()
			draw.RoundedBox(1, ScrW() / 2.25, ScrH()-120, 220, 80, Color(0, 0, 0, 150))
			draw.SimpleText(name, "VJFont_Trebuchet24_SmallMedium", ScrW() / 2.21, ScrH()-115, Color(255,255,255,255), 0, 0)
			
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
			draw.SimpleText(finalhp, "VJFont_Trebuchet24_SmallMedium", ScrW() / (2-move), ScrH()-94, Color(255,255,255,255), 0, 0)
			
			-- Attack Icons
			local atk_col_red = Color(255, 60, 60, 255)
			
			local atk_col_melee = Color(255, 255, 255, 255)
			if AtkTbl["MeleeAttack"] == false then atk_col_melee = atk_col_red end
			surface.SetMaterial(Material("vj_base/hud_controller/claw.png"))
			surface.SetDrawColor(atk_col_melee)
			surface.DrawTexturedRect(ScrW() / 2.21, ScrH()-73, 28, 28)
			
			local atk_col_range = Color(255, 255, 255, 255)
			if AtkTbl["RangeAttack"] == false then atk_col_range = atk_col_red end
			surface.SetMaterial(Material("vj_base/hud_controller/proj.png"))
			surface.SetDrawColor(atk_col_range)
			surface.DrawTexturedRect(ScrW() / 2.14, ScrH()-73, 28, 28)
			
			local atk_col_leap = Color(255, 255, 255, 255)
			if AtkTbl["LeapAttack"] == false then atk_col_leap = atk_col_red end
			surface.SetMaterial(Material("vj_base/hud_controller/leap.png"))
			surface.SetDrawColor(atk_col_leap)
			surface.DrawTexturedRect(ScrW() / 2.065, ScrH()-73, 28, 28)
			
			local atk_col_grenade = Color(255, 255, 255, 255)
			if AtkTbl["GrenadeAttack"] == false then atk_col_grenade = atk_col_red end
			surface.SetMaterial(Material("vj_base/hud_controller/grenade.png"))
			surface.SetDrawColor(atk_col_grenade)
			surface.DrawTexturedRect(ScrW() / 2.005, ScrH()-73, 28, 28)
			
			local atk_col_gun = Color(255, 255, 255, 255)
			if AtkTbl["WeaponAttack"] == false then atk_col_gun = atk_col_red end
			surface.SetMaterial(Material("vj_base/hud_controller/gun.png"))
			surface.SetDrawColor(atk_col_gun)
			surface.DrawTexturedRect(ScrW() / 1.94, ScrH()-73, 28, 28) // 1.865
			draw.SimpleText(AtkTbl["Ammo"], "VJFont_Trebuchet24_Medium", ScrW() / 1.885, ScrH()-70, atk_col_gun, 0, 0)
		end)
		if enabled != true then hook.Remove("HUDPaint", "VJ_Controller") end
	end)
end