local VJExists = "lua/autorun/vj_base_autorun.lua"
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
include("shared.lua")
/*--------------------------------------------------
	=============== Admin Health Kit ===============
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to quickly give admins a lot health
--------------------------------------------------*/

function ENT:Draw() 
	self:DrawModel()

	local ledcolor = Color(0,255,0,255)
  	local Position = self.Entity:GetPos() +self.Entity:GetForward()*7 +self.Entity:GetUp()*6 +self.Entity:GetRight()*2
	local Angles = self.Entity:GetAngles()
	Angles:RotateAroundAxis(Angles:Right(), Vector(90, 90, 90).x)
	Angles:RotateAroundAxis(Angles:Up(), Vector(90, 90, 90).y)
	Angles:RotateAroundAxis(Angles:Forward(), Vector(90, 90, 90).z)
	cam.Start3D2D(Position, Angles, 0.07)
	draw.SimpleText("Admin Health Kit", "DermaLarge", 31, -22, ledcolor, 1, 1)
	cam.End3D2D()
end