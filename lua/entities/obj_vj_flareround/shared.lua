ENT.Type 			= "anim"
ENT.Base 			= "base_gmodentity"
ENT.PrintName		= "Flare Round"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Information		= "Projectiles for my addons"
ENT.Category		= "VJ Base"

ENT.Spawnable = true
ENT.AdminOnly = false

if (CLIENT) then
	language.Add("obj_vj_flareround", "Flare Round")
	killicon.Add("obj_vj_flareround","HUD/killicons/default",Color(255,80,0,255))

	language.Add("#obj_vj_flareround", "Flare Round")
	killicon.Add("#obj_vj_flareround","HUD/killicons/default",Color(255,80,0,255))
	
	function ENT:Draw() self:DrawModel() end
end