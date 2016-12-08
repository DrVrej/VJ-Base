local VJExists = "lua/autorun/vj_base_autorun.lua"
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end

ENT.Base 			= "base_gmodentity"
ENT.Type 			= "anim"
ENT.PrintName 		= "FirePlace"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Gives a warm feeling, specially in snowy maps."
ENT.Instructions 	= "Don't change anything."
ENT.Category		= "VJ Base"

ENT.Spawnable = true
ENT.AdminOnly = false
---------------------------------------------------------------------------------------------------------------------------------------------
net.Receive("vj_fireplace_turnon1", function()
local ent = net.ReadEntity()
//if ent.FirePlaceOn == true then
ent.FireLight1 = DynamicLight(ent:EntIndex())
if ( ent.FireLight1 ) then
	ent.FireLight1.Pos = ent:GetPos() +ent:GetUp()*15
	ent.FireLight1.r = 255
	ent.FireLight1.g = 100
	ent.FireLight1.b = 0
	ent.FireLight1.Brightness = 2
	ent.FireLight1.Size = 400
	ent.FireLight1.Decay = 400
	ent.FireLight1.DieTime = CurTime() + 1
	//end
 end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
net.Receive("vj_fireplace_turnon2", function()
local ent = net.ReadEntity()
	ParticleEffectAttach("env_fire_tiny_smoke",PATTACH_ABSORIGIN_FOLLOW,ent,0)
	ParticleEffectAttach("env_embers_large",PATTACH_ABSORIGIN_FOLLOW,ent,0)
end)