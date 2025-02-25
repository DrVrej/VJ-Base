TOOL.Name = "#tool.vj_tool_health.name"
TOOL.Tab = "DrVrej"
TOOL.Category = "Tools"
TOOL.Command = nil -- The console command to execute upon being selected in the Q menu.

TOOL.Information = {
	{name = "left"},
	{name = "right"},
	{name = "reload"},
}

TOOL.ClientConVar["health"] = "100"
TOOL.ClientConVar["godmode"] = 0
TOOL.ClientConVar["healthregen"] = 0
TOOL.ClientConVar["healthregen_amt"] = 4
TOOL.ClientConVar["healthregen_delay"] = 5

-- Just to make it easier to reset everything to default
local DefaultConVars = {}
for k,v in pairs(TOOL.ClientConVar) do
	DefaultConVars["vj_tool_health_"..k] = v
end
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	local function DoBuildCPanel_VJ_HealthModifier(Panel)
		local reset = vgui.Create("DButton")
		reset:SetFont("DermaDefaultBold")
		reset:SetText("#vjbase.menu.general.reset.everything")
		reset:SetSize(150,25)
		reset:SetColor(Color(0,0,0,255))
		reset.DoClick = function()
			for k,v in pairs(DefaultConVars) do
				if v == "" then
				LocalPlayer():ConCommand(k.." ".."None")
			else
				LocalPlayer():ConCommand(k.." "..v) end
				timer.Simple(0.05,function()
					local GetPanel = controlpanel.Get("vj_tool_health")
					GetPanel:ClearControls()
					DoBuildCPanel_VJ_HealthModifier(GetPanel)
				end)
			end
		end
		Panel:AddPanel(reset)
		
		local tutorial = vgui.Create("DButton")
		tutorial:SetFont("DermaDefaultBold")
		tutorial:SetText("#tool.vjstool.menu.tutorialvideo")
		tutorial:SetSize(150, 20)
		tutorial:SetColor(Color(0,0,255,255))
		tutorial.DoClick = function()
			gui.OpenURL("http://www.youtube.com/watch?v=kLygPP-vbHY")
		end
		Panel:AddPanel(tutorial)
		
		Panel:AddControl("Label", {Text = "#tool.vj_tool_health.adminonly"})
		Panel:AddControl("Slider", {Label = "#tool.vj_tool_health.sliderhealth", min = 0, max = 10000, Command = "vj_tool_health_health"})
		Panel:AddControl("Label", {Text = "#tool.vj_tool_health.label1"})
		Panel:AddControl("Checkbox", {Label = "#tool.vj_tool_health.togglegodmode", Command = "vj_tool_health_godmode"})
		Panel:AddControl("Checkbox", {Label = "#tool.vj_tool_health.togglehealthregen", Command = "vj_tool_health_healthregen"})
		Panel:AddControl("Slider", {Label = "#tool.vj_tool_health.sliderhealthregenamt", min = 0, max = 10000, Command = "vj_tool_health_healthregen_amt"})
		Panel:AddControl("Slider", {Label = "#tool.vj_tool_health.sliderhealthregendelay", min = 0, max = 10000, Command = "vj_tool_health_healthregen_delay"})
	end
---------------------------------------------------------------------------------------------------------------------------------------------
	function TOOL.BuildCPanel(Panel)
		DoBuildCPanel_VJ_HealthModifier(Panel)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:LeftClick(tr)
	if CLIENT then return true end
	if IsValid(tr.Entity) then
		local Ply = self:GetOwner()
		local trent = tr.Entity
		local canheal = true
		if (trent:Health() != 0 or (trent:IsNPC() or trent:IsPlayer())) then
			if trent:IsPlayer() && !Ply:IsAdmin() then
				canheal = false
			end
			if canheal == true then
				trent:SetHealth(self:GetClientNumber("health"))
				Ply:ChatPrint("Set "..trent:GetClass().."'s health to "..self:GetClientNumber("health"))
				if trent:IsNPC() then
					if self:GetClientNumber("godmode") == 1 then trent.GodMode = true else trent.GodMode = false end
					if trent.IsVJBaseSNPC && self:GetClientNumber("healthregen") == 1 then
						local healthRegen = trent.HealthRegenParams
						healthRegen.Enabled = true
						healthRegen.Amount = self:GetClientNumber("healthregen_amt")
						healthRegen.Delay = VJ.SET(self:GetClientNumber("healthregen_delay"), self:GetClientNumber("healthregen_delay"))
					end
				end
				return true
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:RightClick(tr)
	if CLIENT then return true end
	if IsValid(tr.Entity) then
		local Ply = self:GetOwner()
		local trent = tr.Entity
		local canheal = true
		if (trent:Health() != 0 or (trent:IsNPC() or trent:IsPlayer())) then
			if trent:IsPlayer() && !Ply:IsAdmin() then
				canheal = false
			end
			if canheal == true then
				trent:SetHealth(self:GetClientNumber("health"))
				trent:SetMaxHealth(self:GetClientNumber("health"))
				Ply:ChatPrint("Set "..trent:GetClass().."'s health and max health to "..self:GetClientNumber("health"))
				if trent:IsNPC() then
					if self:GetClientNumber("godmode") == 1 then trent.GodMode = true else trent.GodMode = false end
					if trent.IsVJBaseSNPC && self:GetClientNumber("healthregen") == 1 then
						local healthRegen = trent.HealthRegenParams
						healthRegen.Enabled = true
						healthRegen.Amount = self:GetClientNumber("healthregen_amt")
						healthRegen.Delay = VJ.SET(self:GetClientNumber("healthregen_delay"), self:GetClientNumber("healthregen_delay"))
					end
				end
				return true
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:Reload(tr)
	if CLIENT then return true end
	if IsValid(tr.Entity) then
		local Ply = self:GetOwner()
		local trent = tr.Entity
		local canheal = true
		if (trent:Health() != 0 or (trent:IsNPC() or trent:IsPlayer())) then
			if trent:IsPlayer() && !Ply:IsAdmin() then
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