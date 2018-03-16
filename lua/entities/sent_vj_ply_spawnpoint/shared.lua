if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end

ENT.Base 			= "base_gmodentity"
ENT.Type 			= "anim"
ENT.PrintName 		= "Player Spawnpoint"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Sets the spawnpoint for all the players in the map!"
ENT.Instructions 	= "Don't change anything."
ENT.Category		= "VJ Base"

ENT.Spawnable = true
ENT.AdminOnly = true
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Draw()
	self:DrawModel()

	/*local ledcolor = Color(0,255,0,255)
  	local Position = self:GetPos() +self:GetForward()*7 +self:GetUp()*6 +self:GetRight()*2
	local Angles = self:GetAngles()
	Angles:RotateAroundAxis(Angles:Right(), Vector(90, 90, 90).x)
	Angles:RotateAroundAxis(Angles:Up(), Vector(90, 90, 90).y)
	Angles:RotateAroundAxis(Angles:Forward(), Vector(90, 90, 90).z)
	cam.Start3D2D(Position, Angles, 0.07)
	draw.SimpleText("Admin Health Kit", "DermaLarge", 31, -22, ledcolor, 1, 1)
	cam.End3D2D()*/
end
