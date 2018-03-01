include('shared.lua')

language.Add("obj_vj_flareround", "Flare Round")
killicon.Add("obj_vj_flareround","HUD/killicons/default",Color(255,80,0,255))

language.Add("#obj_vj_flareround", "Flare Round")
killicon.Add("#obj_vj_flareround","HUD/killicons/default",Color(255,80,0,255))

function ENT:Draw()
	self.Entity:DrawModel()
end