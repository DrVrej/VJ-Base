ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "VJ Base Projectile"
ENT.Author = "DrVrej"
ENT.Contact = "http://steamcommunity.com/groups/vrejgaming"
ENT.Category = "VJ Base"
ENT.AutomaticFrameAdvance = true

ENT.IsVJBaseProjectile = true
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	local metaEntity = FindMetaTable("Entity")
	local fDrawModel = metaEntity.DrawModel
	function ENT:Draw() fDrawModel(self) end
end