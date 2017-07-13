TOOL.Name = "NPC Bullseye"
TOOL.Category = "Tools"
TOOL.Tab = "DrVrej"
TOOL.Command = nil
TOOL.ConfigName = ""

TOOL.ClientConVar["type"] = "Dynamic"
TOOL.ClientConVar["modeldirectory"] = "models/hunter/plates/plate.mdl"
TOOL.ClientConVar["usecolor"] = 1
TOOL.ClientConVar["startactivate"] = 1

local DefaultConVars = {}
for k,v in pairs(TOOL.ClientConVar) do
	DefaultConVars["vjstool_bullseye_"..k] = v
end
---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
	language.Add("tool.vjstool_bullseye.name", "NPC Bullseye")
	language.Add("tool.vjstool_bullseye.desc", "Creates a bullseye that NPCs will target")
	language.Add("tool.vjstool_bullseye.0", "Left-Click to create a bullseye")
	
	//language.Add("vjbase.npctools.health", "Health")
---------------------------------------------------------------------------------------------------------------------------------------------
	local function DoBuildCPanel_VJ_BullseyeSpawner(Panel)
		local reset = vgui.Create("DButton")
		reset:SetFont("DermaDefaultBold")
		reset:SetText("Reset To Default")
		reset:SetSize(150,25)
		reset:SetColor(Color(0,0,0,255))
		reset.DoClick = function(reset)
			for k,v in pairs(DefaultConVars) do
				if v == "" then LocalPlayer():ConCommand(k.." ".."None") else
				LocalPlayer():ConCommand(k.." "..v) end
				timer.Simple(0.05,function()
				GetPanel = controlpanel.Get("vjstool_bullseye")
				GetPanel:ClearControls()
				DoBuildCPanel_VJ_BullseyeSpawner(GetPanel)
				end)
			end
		end
		Panel:AddPanel(reset)
		
		local tutorial = vgui.Create("DButton")
		tutorial:SetFont("DermaDefaultBold")
		tutorial:SetText("Tutorial Video")
		tutorial:SetSize(150, 20)
		tutorial:SetColor(Color(0,0,255,255))
		tutorial.DoClick = function(tutorial)
			gui.OpenURL("http://www.youtube.com/watch?v=Qf-vrE-BAW4")
		end
		Panel:AddPanel(tutorial)
		
		Panel:AddControl("Label", {Text = "It's recommended to use this tool only for VJ Base SNPCs."})
		Panel:ControlHelp("- Press USE on the entity to activate/deactivate.")
		Panel:ControlHelp("- When deactivated, NPCs will no longer target it.")
		Panel:AddControl("Label", {Text = "Select Solid/Movement Type:"})
		local typebox = vgui.Create("DComboBox")
		//typebox:SetConVar("vjstool_bullseye_type")
		typebox:SetValue(GetConVarString("vjstool_bullseye_type"))
		typebox:AddChoice("Dynamic")
		typebox:AddChoice("Static")
		typebox:AddChoice("Physics")
		function typebox:OnSelect(index,value,data)
			LocalPlayer():ConCommand("vjstool_bullseye_type "..value)
		end
		Panel:AddPanel(typebox)
		Panel:AddControl("Label", {Text = "Model Directory:"})
		local modeldir = vgui.Create("DTextEntry")
		modeldir:SetConVar("vjstool_bullseye_modeldirectory")
		modeldir:SetMultiline(false)
		Panel:AddPanel(modeldir)
		Panel:AddControl("Checkbox", {Label = "Use Status Colors (Activated/Deactivated)", Command = "vjstool_bullseye_usecolor"})
		Panel:AddControl("Checkbox", {Label = "Start Activated", Command = "vjstool_bullseye_startactivate"})
	end
---------------------------------------------------------------------------------------------------------------------------------------------
	function TOOL.BuildCPanel(Panel)
		DoBuildCPanel_VJ_BullseyeSpawner(Panel)
	end
else -- If SERVER
	-- Yayyyy nothing.....for now...
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:LeftClick(tr)
	if (CLIENT) then return true end
		local spawner = ents.Create("ob_vj_bullseye")
		spawner:SetPos(tr.HitPos)
		spawner:SetModel(GetConVarString("vjstool_bullseye_modeldirectory"))
		spawner.SolidMovementType = GetConVarString("vjstool_bullseye_type")
		spawner.UserStatusColors = GetConVar("vjstool_bullseye_usecolor"):GetBool()
		spawner.Activated = GetConVar("vjstool_bullseye_startactivate"):GetBool()
		spawner:Spawn()
		spawner:Activate()
		undo.Create("NPC Bullseye")
		undo.AddEntity(spawner)
		undo.SetPlayer(self:GetOwner())
		undo.Finish()
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:RightClick(tr)
	if (CLIENT) then return true end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:Reload(tr)
	if (CLIENT) then return true end
end