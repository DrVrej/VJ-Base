ENT.Base 			= "npc_vj_human_base"
ENT.Type 			= "ai"
ENT.PrintName 		= "Player NPC"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Category		= "VJ Base"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetupDataTables()
    self:NetworkVar("Vector", 0, "PlayerColor")
end