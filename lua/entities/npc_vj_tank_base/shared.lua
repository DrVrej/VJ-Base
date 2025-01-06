ENT.Base 			= "npc_vj_creature_base"
ENT.Type 			= "ai"
ENT.PrintName 		= "VJ Tank Base"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "To make SNPCs."
ENT.Instructions 	= "Don't change anything."
ENT.Category		= "VJ Base"

ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.IsVJBaseSNPC_Tank = true
ENT.VJ_ID_Vehicle = true
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PhysicsCollide(data, physobj) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PhysicsUpdate(physobj) end