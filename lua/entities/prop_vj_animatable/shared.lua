ENT.Base 			= "base_anim"
ENT.Type 			= "anim"
ENT.PrintName 		= "VJ Base Animatable Prop"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Category		= "VJ Base"
ENT.AutomaticFrameAdvance = true
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	local metaEntity = FindMetaTable("Entity")
	local funcDrawModel = metaEntity.DrawModel
	function ENT:Draw() funcDrawModel(self) end
	function ENT:DrawTranslucent() self:Draw() end
end
