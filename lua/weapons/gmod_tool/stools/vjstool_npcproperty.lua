TOOL.Name = "NPC Property Modifier"
TOOL.Category = "Tools"
TOOL.Tab = "DrVrej"
TOOL.Command = nil
TOOL.ConfigName = ""

TOOL.ClientConVar["health"] = "100"
TOOL.ClientConVar["godmode"] = 0

local DefaultConVars = {}
for k,v in pairs(TOOL.ClientConVar) do
	DefaultConVars["vjstool_npcproperty_"..k] = v
end

if (CLIENT) then
	language.Add("tool.vjstool_npcproperty.name", "NPC Property Modifier")
	language.Add("tool.vjstool_npcproperty.desc", "Modify a NPC's properties")
	language.Add("tool.vjstool_npcproperty.0", "Left-Click to apply properties")
	
	//language.Add("vjbase.npctools.health", "Health")
end

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
			//LocalPlayer():ConCommand("vjstool_npcproperty_health 100")
		end
	end
	Panel:AddPanel(reset)
	
	Panel:AddControl("Label", {Text = "It's recommended to use this tool only for VJ Base SNPCs."})
	Panel:AddControl("Slider", {Label = "Health",min = 0,max = 10000,Command = "vjstool_npcproperty_health"})
	Panel:AddControl("Checkbox", {Label = "God Mode (invincible)", Command = "vjstool_npcproperty_godmode"})
end

function TOOL:LeftClick(tr)
	if (CLIENT) then return true end
	if IsValid(tr.Entity) then
		local trent = tr.Entity
		trent:SetHealth(self:GetClientNumber("health"))
		if tr.Entity:IsNPC() then
			if self:GetClientNumber("godmode") == 1 then trent.GodMode = true else trent.GodMode = false end
		end
		return true
	end
end

function TOOL:Reload(tr)
	if (CLIENT) then return true end
	if IsValid(tr.Entity) && tr.Entity:IsNPC() then
		//tr.Entity:SetHealth(self:GetClientNumber("health"))
		return false
	end
end