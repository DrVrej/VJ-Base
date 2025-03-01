ENT.Base 			= "base_anim"
ENT.Type 			= "anim"
ENT.PrintName		= "Gib Base"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Category		= "VJ Base"

ENT.IsVJBaseCorpse = true
ENT.IsVJBaseCorpse_Gib = true
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	VJ.AddKillIcon("obj_vj_gib", ENT.PrintName, VJ.KILLICON_TYPE_ALIAS, "prop_physics")
	
	local metaEntity = FindMetaTable("Entity")
	local funcDrawModel = metaEntity.DrawModel
	function ENT:Draw() funcDrawModel(self) end
end