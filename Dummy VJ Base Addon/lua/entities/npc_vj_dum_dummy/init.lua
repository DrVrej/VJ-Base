AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = {} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 20 -- or you can use a convar: GetConVarNumber("vj_dum_dummy_h")

-- All functions and variables are located inside the base files. It can be found in the GitHub Repository: https://github.com/DrVrej/VJ-Base