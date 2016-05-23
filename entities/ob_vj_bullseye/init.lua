AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')
/*--------------------------------------------------
	=============== Bullseye Entity ===============
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to place a target in certain situations for VJ Base SNPCs.
--------------------------------------------------*/
ENT.VJBULLSEYE_TheAttacker = nil
ENT.Alreadydoneit = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetModel("models/hunter/blocks/cube025x025x025.mdl")
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
	//self:StartControlling()
	self:SetColor(Color(255,0,0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	if IsValid(self.VJBULLSEYE_TheAttacker) && self.Alreadydoneit == false then
		table.insert(self.VJBULLSEYE_TheAttacker.CurrentPossibleEnemies,self)
		//print(self.VJBULLSEYE_TheAttacker)
		//self.Alreadydoneit = true
		self:AddEntityRelationship(self.VJBULLSEYE_TheAttacker,D_HT,99)
		self.VJBULLSEYE_TheAttacker:VJ_DoSetEnemy(self)
	end
end
/*--------------------------------------------------
	=============== Bullseye Entity ===============
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to place a target in certain situations for VJ Base SNPCs.
--------------------------------------------------*/