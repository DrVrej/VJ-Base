TOOL.Name = "#tool.vj_tool_health.name"
TOOL.Tab = "DrVrej"
TOOL.Category = "Tools"
TOOL.Information = {
	{name = "left"},
	{name = "right"},
	{name = "reload"},
}
TOOL.ClientConVar = {
	health = "100",
	godmode = 0,
	healthregen = 0,
	healthregen_amt = 4,
	healthregen_delay = 5
}

local defaultConvars = TOOL:BuildConVarList()
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	local function ControlPanel(panel)
		local reset = vgui.Create("DButton")
		reset:SetFont("DermaDefaultBold")
		reset:SetText("#vjbase.menu.general.reset.everything")
		reset:SetSize(150, 25)
		reset:SetColor(VJ.COLOR_BLACK)
		reset.DoClick = function()
			for k, v in pairs(defaultConvars) do
				LocalPlayer():ConCommand(k .. " " .. v)
			end
			timer.Simple(0.05, function() -- Otherwise it will not update the values in time
				local getPanel = controlpanel.Get("vj_tool_health")
				getPanel:Clear()
				ControlPanel(getPanel)
			end)
		end
		panel:AddPanel(reset)
		
		local tutorial = vgui.Create("DButton")
		tutorial:SetFont("DermaDefaultBold")
		tutorial:SetText("#vjbase.menu.general.tutorial.vid")
		tutorial:SetSize(150, 20)
		tutorial:SetColor(VJ.COLOR_BLUE)
		tutorial.DoClick = function()
			gui.OpenURL("http://www.youtube.com/watch?v=kLygPP-vbHY")
		end
		panel:AddPanel(tutorial)
		
		panel:AddControl("Label", {Text = "#tool.vj_tool_health.adminonly"})
		panel:AddControl("Slider", {Label = "#tool.vj_tool_health.sliderhealth", min = 0, max = 10000, Command = "vj_tool_health_health"})
		panel:AddControl("Label", {Text = "#tool.vj_tool_health.label1"})
		panel:AddControl("Checkbox", {Label = "#tool.vj_tool_health.togglegodmode", Command = "vj_tool_health_godmode"})
		panel:AddControl("Checkbox", {Label = "#tool.vj_tool_health.togglehealthregen", Command = "vj_tool_health_healthregen"})
		panel:AddControl("Slider", {Label = "#tool.vj_tool_health.sliderhealthregenamt", min = 0, max = 10000, Command = "vj_tool_health_healthregen_amt"})
		panel:AddControl("Slider", {Label = "#tool.vj_tool_health.sliderhealthregendelay", min = 0, max = 10000, Command = "vj_tool_health_healthregen_delay"})
	end
---------------------------------------------------------------------------------------------------------------------------------------------
	function TOOL.BuildCPanel(panel)
		ControlPanel(panel)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:LeftClick(tr)
	if CLIENT then return true end
	
	local ent = tr.Entity
	if !IsValid(ent) then return end
	local ply = self:GetOwner()
	local heal = true
	
	if (ent:Health() != 0) or (ent:IsNPC() or ent:IsPlayer() or ent:IsNextBot()) then
		if ent:IsPlayer() && !ply:IsAdmin() then
			heal = false
		end
		if heal then
			ent:SetHealth(self:GetClientNumber("health"))
			ply:ChatPrint("Set "..ent:GetClass().."'s health to "..self:GetClientNumber("health"))
			if ent:IsNPC() then
				if self:GetClientNumber("godmode") == 1 then ent.GodMode = true else ent.GodMode = false end
				if ent.IsVJBaseSNPC && self:GetClientNumber("healthregen") == 1 then
					local healthRegen = ent.HealthRegenParams
					healthRegen.Enabled = true
					healthRegen.Amount = self:GetClientNumber("healthregen_amt")
					healthRegen.Delay = VJ.SET(self:GetClientNumber("healthregen_delay"), self:GetClientNumber("healthregen_delay"))
				end
			end
			return true
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:RightClick(tr)
	if CLIENT then return true end
	
	local ent = tr.Entity
	if !IsValid(ent) then return end
	local ply = self:GetOwner()
	local heal = true
	
	if (ent:Health() != 0) or (ent:IsNPC() or ent:IsPlayer()) then
		if ent:IsPlayer() && !ply:IsAdmin() then
			heal = false
		end
		if heal then
			ent:SetHealth(self:GetClientNumber("health"))
			ent:SetMaxHealth(self:GetClientNumber("health"))
			ply:ChatPrint("Set "..ent:GetClass().."'s health and max health to "..self:GetClientNumber("health"))
			if ent:IsNPC() then
				if self:GetClientNumber("godmode") == 1 then ent.GodMode = true else ent.GodMode = false end
				if ent.IsVJBaseSNPC && self:GetClientNumber("healthregen") == 1 then
					local healthRegen = ent.HealthRegenParams
					healthRegen.Enabled = true
					healthRegen.Amount = self:GetClientNumber("healthregen_amt")
					healthRegen.Delay = VJ.SET(self:GetClientNumber("healthregen_delay"), self:GetClientNumber("healthregen_delay"))
				end
			end
			return true
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:Reload(tr)
	if CLIENT then return true end
	
	local ent = tr.Entity
	if !IsValid(ent) then return end
	local ply = self:GetOwner()
	local heal = true
	
	if (ent:Health() != 0) or (ent:IsNPC() or ent:IsPlayer()) then
		if ent:IsPlayer() && !ply:IsAdmin() then
			heal = false
		end
		if heal then
			ent:SetHealth(ent:GetMaxHealth())
			ply:ChatPrint("Healed "..ent:GetClass().." to its max health ("..ent:GetMaxHealth()..")")
			return true
		end
	end
end