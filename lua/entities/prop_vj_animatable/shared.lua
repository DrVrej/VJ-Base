ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "VJ Base Animatable Prop"
ENT.Author = "DrVrej"
ENT.Contact = "http://steamcommunity.com/groups/vrejgaming"
ENT.Category = "VJ Base"
ENT.AutomaticFrameAdvance = true

if CLIENT then
	VJ.AddKillIcon("prop_vj_animatable", ENT.PrintName, VJ.KILLICON_TYPE_ALIAS, "prop_physics")
end