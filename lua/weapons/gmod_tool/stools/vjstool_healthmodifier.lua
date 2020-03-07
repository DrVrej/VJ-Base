TOOL.Name = "#tool.vjstool_healthmodifier.name"
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
TOOL.ClientConVar["healthregen_delay"] = 8

-- Just to make it easier to reset everything to default
local DefaultConVars = {}
for k,v in pairs(TOOL.ClientConVar) do
	DefaultConVars["vjstool_healthmodifier_"..k] = v
end
---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
	function DoBuildCPanel_VJ_HealthModifier(Panel)
		local reset = vgui.Create("DButton")
		reset:SetFont("DermaDefaultBold")
		reset:SetText("#vjbase.menu.general.reset.everything")
		reset:SetSize(150,25)
		reset:SetColor(Color(0,0,0,255))
		reset.DoClick = function(reset)
			for k,v in pairs(DefaultConVars) do
				if v == "" then
				LocalPlayer():ConCommand(k.." ".."None")
			else
				LocalPlayer():ConCommand(k.." "..v) end
				timer.Simple(0.05,function()
					GetPanel = controlpanel.Get("vjstool_healthmodifier")
					GetPanel:ClearControls()
					DoBuildCPanel_VJ_HealthModifier(GetPanel)
				end)
			end
		end
		Panel:AddPanel(reset)
		
		Panel:AddControl("Label", {Text = "#tool.vjstool_healthmodifier.adminonly"})
		Panel:AddControl("Slider", {Label = "#tool.vjstool_healthmodifier.sliderhealth", min = 0, max = 10000, Command = "vjstool_healthmodifier_health"})
		Panel:AddControl("Label", {Text = "#tool.vjstool_healthmodifier.label1"})
		Panel:AddControl("Checkbox", {Label = "#tool.vjstool_healthmodifier.togglegodmode", Command = "vjstool_healthmodifier_godmode"})
		Panel:AddControl("Checkbox", {Label = "#tool.vjstool_healthmodifier.togglehealthregen", Command = "vjstool_healthmodifier_healthregen"})
		Panel:AddControl("Slider", {Label = "#tool.vjstool_healthmodifier.sliderhealthregenamt", min = 0, max = 10000, Command = "vjstool_healthmodifier_healthregen_amt"})
		Panel:AddControl("Slider", {Label = "#tool.vjstool_healthmodifier.sliderhealthregendelay", min = 0, max = 10000, Command = "vjstool_healthmodifier_healthregen_delay"})
	end
---------------------------------------------------------------------------------------------------------------------------------------------
	function TOOL.BuildCPanel(Panel)
		DoBuildCPanel_VJ_HealthModifier(Panel)
	end
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
					if trent.IsVJBaseSNPC == true then
						if self:GetClientNumber("healthregen") == 1 then
							trent.HasHealthRegeneration = true
							trent.HealthRegenerationAmount = self:GetClientNumber("healthregen_amt")
							trent.HealthRegenerationDelay = VJ_Set(self:GetClientNumber("healthregen_delay"), self:GetClientNumber("healthregen_delay"))
						end
					end
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
					if trent.IsVJBaseSNPC == true then
						if self:GetClientNumber("healthregen") == 1 then
							trent.HasHealthRegeneration = true
							trent.HealthRegenerationAmount = self:GetClientNumber("healthregen_amt")
							trent.HealthRegenerationDelay = VJ_Set(self:GetClientNumber("healthregen_delay"), self:GetClientNumber("healthregen_delay"))
						end
					end
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