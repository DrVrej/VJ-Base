/*--------------------------------------------------
	=============== Particles ===============
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to load Particles for VJ Base
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end

	-- Add the file --
-- Half Life 2 Episode 2
game.AddParticles("particles/antlion_gib_01.pcf")
game.AddParticles("particles/antlion_gib_02.pcf")
game.AddParticles("particles/antlion_worker.pcf")
game.AddParticles("particles/grub_blood.pcf")
game.AddParticles("particles/fire_01.pcf")
game.AddParticles("particles/Advisor_FX.pcf")
game.AddParticles("particles/striderbuster.pcf")
game.AddParticles("particles/aurora_sphere2.pcf")
game.AddParticles("particles/steampuff.pcf")
game.AddParticles("particles/weapon_fx.pcf")
game.AddParticles("particles/aurora.pcf")
-- Black Mesa Source
game.AddParticles("particles/grenade_hornet.pcf")
-- VJ Particles
game.AddParticles("particles/vj_blood1.pcf")
game.AddParticles("particles/vj_impact1.pcf")
game.AddParticles("particles/vj_explosions1.pcf")
game.AddParticles("particles/vj_rpgtrails1.pcf")
game.AddParticles("particles/vj_rpgtrails2.pcf")
game.AddParticles("particles/vj_weaponfx_rifle.pcf")
--------------------------------------------------------------------------
	-- Add the particle name --
local particlename = {
	"vj_bleedout_red",
	"vj_bleedout_red_small",
	"vj_bleedout_red_tiny",
	"vj_bleedout_yellow",
	"vj_bleedout_yellow_small",
	"vj_bleedout_yellow_tiny",
-- vj_impact
	"vj_impact1_black",
	"vj_impact1_blue",
	"vj_impact1_green",
	"vj_impact1_orange",
	"vj_impact1_purple",
	"vj_impact1_red",
	"vj_impact1_white",
	"vj_impact1_yellow",
	"vj_impact1_centaurspit",
-- vj_explosions1
	"vj_explosion1",
	"vj_explosion2",
	"vj_explosion3",
	"vj_explosionfire1",
	"vj_explosionfire2",
	"vj_explosionfire3",
	"vj_explosionfire4",
	"vj_explosionfire5",
	"vj_explosionflash1",
	"vj_explosionflash2",
	"vj_explosionspark1",
	"vj_explosionspark2",
	"vj_explosionspark3",
	"vj_explosionspark4",
	"vj_shockwave1",
	"vj_shockwave2",
	"vj_smoke1",
	"vj_smoke2",
	"vj_smokespike1",
	"vj_rocks1",
	"vj_rocks2",
	"vj_debris1",
	"vj_dirt1",
-- vj_rpgtrails1
	"vj_rpg1_fulltrail",
	"vj_rpg1_flare",
	"vj_rpg1_smoke",
-- vj_rpgtrails2
	"vj_rpg2_fulltail",
	"vj_rpg2_smoke1",
	"vj_rpg2_smoke2",
	"vj_rpg2_fire",
	"vj_rpg2_flare",
	"vj_rpg2_glow",
-- antlion_gib_01
	"antlion_gib_01",
	"antlion_gib_01_juice",
	"antlion_gib_01_trailsA",
	"antlion_gib_01_trailsb",
-- antlion_gib_02
	"antlion_gib_02",
	"antlion_gib_02_blood",
	"antlion_gib_02_floaters",
	"antlion_gib_02_gas",
	"antlion_gib_02_juice",
	"antlion_gib_02_slime",
	"antlion_gib_02_trailsA",
	"antlion_gib_02_trailsB",
-- antlion_worker
	"antlion_spit",
	"antlion_spit_02",
	"antlion_spit_03",
	"antlion_spit_05",
	"antlion_spit_player",
	"antlion_spit_player_splat",
	"antlion_spit_trail",
-- grub_blood
	"GrubBlood",
	"GrubSquashBlood",
	"GrubSquashBlood2",
-- fire_01
	"burning_engine_01",
	"burning_engine_fire",
	"burning_gib_01",
	"burning_gib_01_drag",
	"burning_gib_01_follower1",
	"burning_gib_01_follower2",
	"burning_gib_01b",
	"burning_vehicle",
	"burning_wood_01",
	"burning_wood_01b",
	"burning_wood_01c",
	"embers_large_01",
	"embers_large_02",
	"embers_medium_01",
	"embers_medium_03",
	"embers_small_01",
	"env_embers_large",
	"env_embers_medium",
	"env_embers_medium_spread",
	"env_embers_small",
	"env_embers_small_spread",
	"env_embers_tiny",
	"env_fire_large",
	"env_fire_tiny_smoke",
	"explosion_huge",
	"explosion_huge_b",
	"explosion_silo",
	"fire_jet_01",
	"fire_jet_01_flame",
	"fire_large_01",
	"fire_large_02",
	"fire_large_02_filler",
	"fire_large_02_fillerb",
	"fire_large_base",
	"fire_medium_01",
	"fire_medium_01_glow",
	"fire_medium_02",
	"fire_medium_02_nosmoke",
	"fire_medium_heatwave",
	"fire_small_01",
	"fire_small_02",
	"fire_small_03",
	"fire_small_base",
	"fire_small_flameouts",
	"fire_verysmall_01",
	"smoke_burning_engine_01",
	"smoke_exhaust_01",
	"smoke_exhaust_01a",
	"smoke_exhaust_01b",
	"smoke_gib_01",
	"smoke_large_01",
	"smoke_large_01b",
	"smoke_large_02",
	"smoke_large_02b",
	"smoke_medium_01",
	"smoke_medium_02",
	"smoke_medium_02 Version #2",
	"smoke_medium_02b",
	"smoke_medium_02b Version #2",
	"smoke_medium_02c",
	"smoke_medium_02d",
	"smoke_small_01",
	"smoke_small_01b",
-- grenade_hornet
	"grenade_hornet_bloop",
	"grenade_hornet_detonate",
	"grenade_hornet_detonate_chucks",
	"grenade_hornet_flash",
	"grenade_hornet_glow",
	"grenade_hornet_trail",
	"grenade_hornet_trail_glow",
	"hornet_trail",
-- Advisor_FX
	"Advisor_Pod_Steam_Continuous",
-- StriderBuster
	"striderbuster_attach",
	"striderbuster_break",
	"striderbuster_break_explode",
	"striderbuster_explode_core",
-- Aurora
	"aurora_01",
	"aurora_02",
	"aurora_02b",
-- Aurora Sphere2
	"aurora_shockwave",
	"aurora_shockwave_debris",
	"aurora_shockwave_ring",
	"demo_aurora_01",
-- Steampuff
	"steam_jet_50",
	"steam_jet_50_steam",
	"steam_jet_80",
	"steam_jet_80_drops",
	"steam_jet_80_dropsteam",
	"steam_jet_80_steam",
	"steam_large_01",
	"steampuff",
-- WEAPON_FX
	"Rocket_Smoke",
	"explosion_turret_break",
	"explosion_turret_fizzle",
	"explosion_turret_break_b",
	"explosion_turret_break_chunks",
	"explosion_turret_break_embers",
	"explosion_turret_break_fire",
	"explosion_turret_break_fire_over",
	"explosion_turret_break_flash",
	"explosion_turret_break_pre_flash",
	"explosion_turret_break_pre_smoke",
	"explosion_turret_break_pre_smoke Version #2",
	"explosion_turret_break_pre_sparks",
	"explosion_turret_break_sparks",
	"Weapon_Combine_Ion_Cannon",
	"Weapon_Combine_Ion_Cannon_a",
	"Weapon_Combine_Ion_Cannon_b",
	"Weapon_Combine_Ion_Cannon_c",
	"Weapon_Combine_Ion_Cannon_d",
	"Weapon_Combine_Ion_Cannon_e",
	"Weapon_Combine_Ion_Cannon_Backup",
	"Weapon_Combine_Ion_Cannon_Beam",
	"Weapon_Combine_Ion_Cannon_Black",
	"Weapon_Combine_Ion_Cannon_Explosion",
	"Weapon_Combine_Ion_Cannon_Explosion_b",
	"Weapon_Combine_Ion_Cannon_Exlposion_c",
	"Weapon_Combine_Ion_Cannon_Explosion_d",
	"Weapon_Combine_Ion_Cannon_Explosion_e",
	"Weapon_Combine_Ion_Cannon_Explosion_f",
	"Weapon_Combine_Ion_Cannon_Explosion_g",
	"Weapon_Combine_Ion_Cannon_Explosion_h",
	"Weapon_Combine_Ion_Cannon_Explosion_i",
	"Weapon_Combine_Ion_Cannon_Explosion_j",
	"Weapon_Combine_Ion_Cannon_Explosion_k",
	"Weapon_Combine_Ion_Cannon_f",
	"Weapon_Combine_Ion_Cannon_g",
	"Weapon_Combine_Ion_Cannon_h",
	"Weapon_Combine_Ion_Cannon_h Version #2",
	"Weapon_Combine_Ion_Cannon_i",
	"Weapon_Combine_Ion_Cannon_Intake",
	"Weapon_Combine_Ion_Cannon_Intake_b",
}
for _,v in ipairs(particlename) do PrecacheParticleSystem(v) end