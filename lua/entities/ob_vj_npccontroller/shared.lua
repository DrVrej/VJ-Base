ENT.Base 			= "base_entity"
ENT.Type 			= "anim"
ENT.PrintName 		= "NPC Controller Base"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "To make my (S)NPCs controllable."
ENT.Instructions 	= "Don't change anything."
ENT.Category		= "VJ Bases"

ENT.Spawnable 		= false
ENT.AdminSpawnable 	= false

if (CLIENT) then
	function ENT:Draw() end
	
	local lerp_hp = 0
	net.Receive("vj_controller_hud",function(len,pl)
		local delete = net.ReadBool()
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
		if delete == true then hook.Remove("HUDPaint","VJ_Controller") end
	end)
end