------------------ Addon Information ------------------
local PublicAddonName = "The public addon name goes here, Example: Dummy SNPCs"
local AddonName = "The addon name goes here, Example: Dummy"
local AddonType = "The addon type(s) Example: SNPC"
local AutorunFile = "autorun/vj_as_autorun.lua"
-------------------------------------------------------
local VJExists = file.Exists("lua/autorun/vj_base_autorun.lua","GAME")
if VJExists == true then
	include('autorun/vj_controls.lua')

	local vCat = "VJ Dummy Category" -- Category, you can also set a category individually by replacing the vCat with a string value
	
	/* -- Comment box start
	NOTE: The following code is commented out so the game doesn't run it! When copying one of the options below, make sure to put it outside of the comment box!
	
	VJ.AddNPC("Dummy SNPC", "npc_vj_dum_dummy", vCat) -- Adds a NPC to the spawnmenu
		-- Parameters:
			-- First is the name, second is the class name
			-- Third is the category that it should be in
			-- Fourth is optional, which is a boolean that defines whether or not it's an admin-only entity
	VJ.AddNPC_HUMAN("Dummy Human SNPC", "npc_vj_dum_dummy", {"weapon_vj_dummy"}, vCat) -- Adds a NPC to the spawnmenu but with a list of weapons it spawns with
		-- Parameters:
			-- First is the name, second is the class name
			-- Third is a table of weapon, the base will pick a random one from the table and give it to the SNPC when "Default Weapon" is selected
			-- Fourth is the category that it should be in
			-- Fifth is optional, which is a boolean that defines whether or not it's an admin-only entity
	VJ.AddWeapon("Dummy Weapon", "weapon_vj_dummy", false, vCat) -- Adds a weapon to the spawnmenu
		-- Parameters:
			-- First is the name, second is the class name
			-- Third is a boolean that defines whether or not it's an admin-only entity
			-- And the last parameter is the category that it should be in
	VJ.AddNPCWeapon("VJ_Dummy", "weapon_vj_dummy") -- Adds a weapon to the NPC weapon list
		-- Parameters:
			-- First is the name, second is the class name
	VJ.AddEntity("Dummy Kit", "sent_vj_dummykit", "Author Name", false, 0, true, vCat) -- Adds an entity to the spawnmenu
		-- Parameters: 
			-- First is the name, second is the class name and the third is its class name	
			-- Fourth is a boolean that defines whether or not it's an admin-only entity
			-- Fifth is an integer that defines the offset of the entity (When it spawns)
			-- Sixth is a boolean that defines whether or not it should drop to the floor when it spawns
			-- And the last parameter is the category that it should be in

	-- Particles --
	VJ.AddParticle("particles/example_particle.pcf",{
		"example_particle_name1",
		"example_particle_name2",
	})
	
	-- Precache Models --
	util.PrecacheModel("models/example_model.mdl")
	
	-- ConVars --
	VJ.AddConVar("vj_dum_dummy_h",100) -- Example 1
	VJ.AddConVar("vj_dum_dummy_d",20) -- Example 2
	
	*/  -- Comment box end
	
-- !!!!!! DON'T TOUCH ANYTHING BELOW THIS !!!!!! -------------------------------------------------------------------------------------------------------------------------
	AddCSLuaFile(AutorunFile)
	VJ.AddAddonProperty(AddonName,AddonType)
else
	if (CLIENT) then
		chat.AddText(Color(0,200,200),PublicAddonName,
		Color(0,255,0)," was unable to install, you are missing ",
		Color(255,100,0),"VJ Base!")
	end
	timer.Simple(1,function()
		if not VJF then
			if (CLIENT) then
				VJF = vgui.Create("DFrame")
				VJF:SetTitle("ERROR!")
				VJF:SetSize(790,560)
				VJF:SetPos((ScrW()-VJF:GetWide())/2,(ScrH()-VJF:GetTall())/2)
				VJF:MakePopup()
				VJF.Paint = function()
					draw.RoundedBox(8,0,0,VJF:GetWide(),VJF:GetTall(),Color(200,0,0,150))
				end
				
				local VJURL = vgui.Create("DHTML",VJF)
				VJURL:SetPos(VJF:GetWide()*0.005, VJF:GetTall()*0.03)
				VJURL:Dock(FILL)
				VJURL:SetAllowLua(true)
				VJURL:OpenURL("https://sites.google.com/site/vrejgaming/vjbasemissing")
			elseif (SERVER) then
				timer.Create("VJBASEMissing",5,0,function() print("VJ Base is Missing! Download it from the workshop!") end)
			end
		end
	end)
end