/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Decals ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
game.AddDecal("VJ_Splat_Acid", {"vj_base/decals/splat_acid1", "vj_base/decals/splat_acid2", "vj_base/decals/splat_acid3", "vj_base/decals/splat_acid4"})
game.AddDecal("VJ_Blood_Red", {"vj_base/decals/blood/red1", "vj_base/decals/blood/red2", "vj_base/decals/blood/red3", "vj_base/decals/blood/red4", "vj_base/decals/blood/red5", "vj_base/decals/blood/red6"})
game.AddDecal("VJ_Blood_Yellow", {"vj_base/decals/blood/yellow1", "vj_base/decals/blood/yellow2", "vj_base/decals/blood/yellow3", "vj_base/decals/blood/yellow4", "vj_base/decals/blood/yellow5", "vj_base/decals/blood/yellow6"})
game.AddDecal("VJ_Blood_Green", {"vj_base/decals/blood/green1", "vj_base/decals/blood/green2", "vj_base/decals/blood/green3", "vj_base/decals/blood/green4", "vj_base/decals/blood/green5", "vj_base/decals/blood/green6"})
game.AddDecal("VJ_Blood_Orange", {"vj_base/decals/blood/orange1", "vj_base/decals/blood/orange2", "vj_base/decals/blood/orange3", "vj_base/decals/blood/orange4", "vj_base/decals/blood/orange5", "vj_base/decals/blood/orange6"})
game.AddDecal("VJ_Blood_Blue", {"vj_base/decals/blood/blue1", "vj_base/decals/blood/blue2", "vj_base/decals/blood/blue3", "vj_base/decals/blood/blue4", "vj_base/decals/blood/blue5", "vj_base/decals/blood/blue6"})
game.AddDecal("VJ_Blood_Purple", {"vj_base/decals/blood/purple1", "vj_base/decals/blood/purple2", "vj_base/decals/blood/purple3", "vj_base/decals/blood/purple4", "vj_base/decals/blood/purple5", "vj_base/decals/blood/purple6"})
game.AddDecal("VJ_Blood_White", {"vj_base/decals/blood/white1", "vj_base/decals/blood/white2", "vj_base/decals/blood/white3", "vj_base/decals/blood/white4", "vj_base/decals/blood/white5", "vj_base/decals/blood/white6"})
game.AddDecal("VJ_Blood_Oil", {"vj_base/decals/blood/oil1", "vj_base/decals/blood/oil2", "vj_base/decals/blood/oil3", "vj_base/decals/blood/oil4", "vj_base/decals/blood/oil5", "vj_base/decals/blood/oil6"})

-- Add to paint tool
list.Add("PaintMaterials", "VJ_Splat_Acid")
list.Add("PaintMaterials", "VJ_Blood_Red")
list.Add("PaintMaterials", "VJ_Blood_Yellow")
list.Add("PaintMaterials", "VJ_Blood_Green")
list.Add("PaintMaterials", "VJ_Blood_Orange")
list.Add("PaintMaterials", "VJ_Blood_Blue")
list.Add("PaintMaterials", "VJ_Blood_Purple")
list.Add("PaintMaterials", "VJ_Blood_White")
list.Add("PaintMaterials", "VJ_Blood_Oil")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Model Precaching ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Alien Gibs
util.PrecacheModel("models/vj_base/gibs/alien/gib1.mdl")
util.PrecacheModel("models/vj_base/gibs/alien/gib2.mdl")
util.PrecacheModel("models/vj_base/gibs/alien/gib3.mdl")
util.PrecacheModel("models/vj_base/gibs/alien/gib4.mdl")
util.PrecacheModel("models/vj_base/gibs/alien/gib5.mdl")
util.PrecacheModel("models/vj_base/gibs/alien/gib6.mdl")
util.PrecacheModel("models/vj_base/gibs/alien/gib7.mdl")
util.PrecacheModel("models/vj_base/gibs/alien/gib_small1.mdl")
util.PrecacheModel("models/vj_base/gibs/alien/gib_small2.mdl")
util.PrecacheModel("models/vj_base/gibs/alien/gib_small3.mdl")
	-- Human Gibs
util.PrecacheModel("models/vj_base/gibs/human/brain.mdl")
util.PrecacheModel("models/vj_base/gibs/human/eye.mdl")
util.PrecacheModel("models/vj_base/gibs/human/heart.mdl")
util.PrecacheModel("models/vj_base/gibs/human/liver.mdl")
util.PrecacheModel("models/vj_base/gibs/human/lung.mdl")
util.PrecacheModel("models/vj_base/gibs/human/gib1.mdl")
util.PrecacheModel("models/vj_base/gibs/human/gib2.mdl")
util.PrecacheModel("models/vj_base/gibs/human/gib3.mdl")
util.PrecacheModel("models/vj_base/gibs/human/gib4.mdl")
util.PrecacheModel("models/vj_base/gibs/human/gib5.mdl")
util.PrecacheModel("models/vj_base/gibs/human/gib6.mdl")
util.PrecacheModel("models/vj_base/gibs/human/gib7.mdl")
util.PrecacheModel("models/vj_base/gibs/human/gib_small1.mdl")
util.PrecacheModel("models/vj_base/gibs/human/gib_small2.mdl")
util.PrecacheModel("models/vj_base/gibs/human/gib_small3.mdl")
	-- Projectiles
util.PrecacheModel("models/vj_base/projectiles/spit_acid_large.mdl")
util.PrecacheModel("models/vj_base/projectiles/spit_acid_medium.mdl")
util.PrecacheModel("models/vj_base/projectiles/spit_acid_small.mdl")

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Fonts ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	local fontName = "Roboto"
	-- Tahoma | Helvetica | Roboto | Arial
	
	surface.CreateFont("VJBaseLarge", {
		font = fontName,
		size = 34,
		weight = 600,
		antialias = true,
	})

	surface.CreateFont("VJBaseMediumLarge", {
		font = fontName,
		size = 26,
		weight = 600,
		antialias = true,
	})

	surface.CreateFont("VJBaseMedium", {
		font = fontName,
		size = 24,
		weight = 600,
		antialias = true,
	})

	surface.CreateFont("VJBaseSmallMedium", {
		font = fontName,
		size = 17,
		weight = 600,
		antialias = true,
	})

	surface.CreateFont("VJBaseSmall", {
		font = fontName,
		size = 16,
		weight = 600,
		antialias = true,
	})
	
	surface.CreateFont("VJBaseTinySmall", {
		font = fontName,
		size = 14,
		weight = 600,
		antialias = true,
	})

	surface.CreateFont("VJBaseTiny", {
		font = fontName,
		size = 11,
		weight = 600,
		antialias = true,
	})
end