ENT.Base 			= "base_anim"
ENT.Type 			= "anim"
ENT.PrintName 		= "VJ Base Projectile"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Category		= "VJ Base"

ENT.IsVJBaseProjectile = true
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	local metaEntity = FindMetaTable("Entity")
	local funcDrawModel = metaEntity.DrawModel
	function ENT:Draw() funcDrawModel(self) end
end