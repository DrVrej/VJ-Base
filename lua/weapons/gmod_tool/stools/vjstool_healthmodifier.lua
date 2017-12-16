TOOL.Name = "Health Modifier"
TOOL.Category = "Tools"
TOOL.Tab = "DrVrej"
TOOL.Command = nil
TOOL.ConfigName = ""

TOOL.ClientConVar["health"] = "100"
TOOL.ClientConVar["godmode"] = 0

local DefaultConVars = {}
for k,v in pairs(TOOL.ClientConVar) do
	DefaultConVars["vjstool_healthmodifier_"..k] = v
end
---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
	language.Add("tool.vjstool_healthmodifier.name", "Health Modifier")
	language.Add("tool.vjstool_healthmodifier.desc", "Modify the health of an entity")
	language.Add("tool.vjstool_healthmodifier.0", "Left-Click to set its health, Right-Click to set its health & max health, Reload-Key to heal the entity's to its max health")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL.BuildCPanel(Panel)
	//PrintTable(DefaultConVars)
	//Panel:AddControl("Header", {Text = "NPC Tool", Description = "Left click to change the NPC's property"})
	
	local reset = vgui.Create("DButton")
	reset:SetFont("DermaDefaultBold")
	reset:SetText("Reset To Default")
	reset:SetSize(150, 25)
	reset:SetColor(Color(0,0,0,255))
	reset.DoClick = function(reset)
		for k,v in pairs(DefaultConVars) do
			LocalPlayer():ConCommand(k.." "..v)
			//LocalPlayer():ConCommand("vjstool_healthmodifier_health 100")
		end
	end
	Panel:AddPanel(reset)
	
	Panel:AddControl("Label", {Text = "Only admins can change or heal another player's health"})
	Panel:ControlHelp("- Left click to set its health.")
	Panel:ControlHelp("- Right click to set its health & max health.")
	Panel:ControlHelp("- Reload-key to heal the entity's to its max health.")
	Panel:AddControl("Slider", {Label = "Health",min = 0,max = 10000,Command = "vjstool_healthmodifier_health"})
	Panel:AddControl("Checkbox", {Label = "God Mode (invincible)", Command = "vjstool_healthmodifier_godmode"})
	Panel:ControlHelp("Currently only for VJ Base SNPCs")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:LeftClick(tr)
	if (CLIENT) then return true end
	if IsValid(tr.Entity) then
		local Ply = self:GetOwner()
		local trent = tr.Entity
		local canheal = true
		if (trent:Health() != 0 or (trent:IsNPC() or trent:IsPlayer())) then
			if (trent:IsPlayer() && (!Ply:IsAdmin() && !Ply:IsSuperAdmin())) then
				canheal = false
			end
			if canheal == true then
				trent:SetHealth(self:GetClientNumber("health"))
				Ply:ChatPrint("Set "..trent:GetClass().."'s health to "..self:GetClientNumber("health"))
				if trent:IsNPC() then
					if self:GetClientNumber("godmode") == 1 then trent.GodMode = true else trent.GodMode = false end
				end
				return true
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:RightClick(tr)
	if (CLIENT) then return true end
	if IsValid(tr.Entity) then
		local Ply = self:GetOwner()
		local trent = tr.Entity
		local canheal = true
		if (trent:Health() != 0 or (trent:IsNPC() or trent:IsPlayer())) then
			if (trent:IsPlayer() && (!Ply:IsAdmin() && !Ply:IsSuperAdmin())) then
				canheal = false
			end
			if canheal == true then
				trent:SetHealth(self:GetClientNumber("health"))
				trent:SetMaxHealth(self:GetClientNumber("health"))
				Ply:ChatPrint("Set "..trent:GetClass().."'s health and max health to "..self:GetClientNumber("health"))
				if trent:IsNPC() then
					if self:GetClientNumber("godmode") == 1 then trent.GodMode = true else trent.GodMode = false end
				end
				return true
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:Reload(tr)
	if (CLIENT) then return true end
	if IsValid(tr.Entity) then
		local Ply = self:GetOwner()
		local trent = tr.Entity
		local canheal = true
		if (trent:Health() != 0 or (trent:IsNPC() or trent:IsPlayer())) then
			if (trent:IsPlayer() && (!Ply:IsAdmin() && !Ply:IsSuperAdmin())) then
				canheal = false
			end
			if canheal == true then
				trent:SetHealth(trent:GetMaxHealth())
				Ply:ChatPrint("Healed "..trent:GetClass().." to its max health ("..trent:GetMaxHealth()..")")
				return true
			end
		end
	end
end