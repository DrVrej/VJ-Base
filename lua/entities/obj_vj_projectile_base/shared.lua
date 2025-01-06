ENT.Base 			= "base_anim"
ENT.Type 			= "anim"
ENT.PrintName 		= "VJ Projectile Base"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "To make projectiles."
ENT.Instructions 	= "Don't change anything."
ENT.Category		= "VJ Base"

ENT.Spawnable 		= false
ENT.AdminSpawnable	= false

ENT.IsVJBaseProjectile = true
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	function ENT:Draw() self:DrawModel() end
end