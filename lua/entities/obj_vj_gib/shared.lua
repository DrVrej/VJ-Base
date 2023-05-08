ENT.Base 			= "base_gmodentity"
ENT.Type 			= "anim"
ENT.PrintName		= "Gib Base"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Information		= "Gibs for SNPCs"
ENT.Category		= "VJ Base"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false

ENT.IsVJBaseCorpse = true
ENT.IsVJBaseCorpse_Gib = true
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	function ENT:Draw() self:DrawModel() end
end