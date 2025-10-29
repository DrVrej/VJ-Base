TOOL.Name = "#tool.vj_tool_spawner.name"
TOOL.Tab = "DrVrej"
TOOL.Category = "Tools"
TOOL.Information = {
	{name = "left"},
	{name = "right"},
}
TOOL.ClientConVar = {
	playsound = 1,
	spawnent = "None",
	spawnnpclass = "",
	fritoplyallies = 1,
	spawnpos_forward = 0,
	spawnpos_right = 0,
	spawnpos_up = 0,
	weapon = "None",
	nextspawntime = 3
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
			function reset:DoClick()
				for k, v in pairs(defaultConvars) do
					-- Ignore "vj_tool_spawner_spawnnpclass" because we don't want it set to "None", we need it to stay ""
					if k == "vj_tool_spawner_spawnnpclass" then
						LocalPlayer():ConCommand("vj_tool_spawner_spawnnpclass \"\"")
					else
						LocalPlayer():ConCommand(k .. " " .. v)
					end
				end
				timer.Simple(0.05, function() -- Otherwise it will not update the values in time
					local getPanel = controlpanel.Get("vj_tool_spawner")
					getPanel:Clear()
					ControlPanel(getPanel)
				end)
			end
		panel:AddPanel(reset)
		
		-- Tutorial button
		local tutorial = vgui.Create("DButton")
			tutorial:SetFont("DermaDefaultBold")
			tutorial:SetText("#vjbase.menu.general.tutorial.vid")
			tutorial:SetSize(150, 20)
			tutorial:SetColor(VJ.COLOR_BLUE)
			function tutorial:DoClick()
				gui.OpenURL("http://www.youtube.com/watch?v=5H_hIz35W90")
			end
		panel:AddPanel(tutorial)
		
		VJ_TOOL_SPAWNER_LIST = VJ_TOOL_SPAWNER_LIST or {}
		
		panel:Help("#vjbase.tool.general.note.recommend")
		
		-- NPC selection menu
		local selectedNPC = vgui.Create("DTextEntry")
			selectedNPC:SetEditable(false)
			local npcClass = GetConVar("vj_tool_spawner_spawnent"):GetString()
			local npcName = "None"
			local npcInfo = list.GetEntry("NPC", npcClass)
			if npcInfo then
				npcName = language.GetPhrase(npcInfo.Name)
			end
			selectedNPC:SetText(language.GetPhrase("#tool.vj_tool_spawner.menu.selected.npc") .. ": " .. npcName .. " [" .. npcClass .. "]")
			function selectedNPC:OnGetFocus()
				local npcSelFrame = vgui.Create("DFrame")
					npcSelFrame:SetSize(420, 440)
					npcSelFrame:SetPos(ScrW() * 0.6, ScrH() * 0.1)
					npcSelFrame:SetTitle("#tool.vj_tool_spawner.menu.popup.title.npc")
					npcSelFrame:SetFocusTopLevel(true)
					npcSelFrame:ShowCloseButton(true)
					npcSelFrame:MakePopup()
				local npcSelList = vgui.Create("DListView")
					npcSelList:SetParent(npcSelFrame)
					npcSelList:SetPos(10, 30)
					npcSelList:SetSize(400, 400)
					npcSelList:SetMultiSelect(false)
					npcSelList:AddColumn("#tool.vj_tool_spawner.menu.popup.header.name")
					npcSelList:AddColumn("#tool.vj_tool_spawner.menu.popup.header.class")
					npcSelList:AddColumn("#tool.vj_tool_spawner.menu.popup.header.category")
					function npcSelList:OnRowSelected(rowIndex, row)
						chat.AddText(VJ.COLOR_GREEN, "#tool.vj_tool_spawner.menu.popup.title.npc")
					end
					function npcSelList:DoDoubleClick(lineID, line)
						chat.AddText(VJ.COLOR_GREEN, "NPC", VJ.COLOR_ORANGE_VIVID, " " .. language.GetPhrase(line:GetValue(1)) .. " ", VJ.COLOR_GREEN, "selected!")
						LocalPlayer():ConCommand("vj_tool_spawner_spawnent " .. line:GetValue(2))
						npcSelFrame:Close()
						selectedNPC:SetText(language.GetPhrase("#tool.vj_tool_spawner.menu.selected.npc") .. ": " .. language.GetPhrase(line:GetValue(1)) .. " [" .. line:GetValue(2) .. "]")
					end
				for _, v in pairs(list.Get("NPC")) do
					local cat = v.Category
					npcSelList:AddLine(v.Name, v.Class, cat == "" and "Unknown" or cat)
				end
				npcSelList:SortByColumn(1, false)
			end
		panel:AddItem(selectedNPC)
		
		-- Spawn position entries
		panel:TextEntry("#tool.vj_tool_spawner.menu.pos.forward", "vj_tool_spawner_spawnpos_forward")
		panel:TextEntry("#tool.vj_tool_spawner.menu.pos.right", "vj_tool_spawner_spawnpos_right")
		panel:TextEntry("#tool.vj_tool_spawner.menu.pos.up", "vj_tool_spawner_spawnpos_up")
		
		-- Weapon selection menu
		local selectedWep = vgui.Create("DTextEntry")
			selectedWep:SetEditable(false)
			local equipClass = GetConVar("vj_tool_spawner_weapon"):GetString()
			local equipName = "None"
			-- "NPCUsableWeapons" list is just a sequential table, class names are NOT the keys
			for _, v in pairs(list.Get("NPCUsableWeapons")) do
				if v.class == equipClass then
					equipName = language.GetPhrase(v.title)
					break
				end
			end
			selectedWep:SetText(language.GetPhrase("#tool.vj_tool_spawner.menu.selected.wep") .. ": " .. equipName .. " [" .. equipClass .. "]")
			function selectedWep:OnGetFocus()
				local wepSelFrame = vgui.Create("DFrame")
					wepSelFrame:SetSize(420, 440)
					wepSelFrame:SetPos(ScrW() * 0.6, ScrH() * 0.1)
					wepSelFrame:SetTitle("#tool.vj_tool_spawner.menu.popup.title.wep")
					wepSelFrame:SetFocusTopLevel(true)
					wepSelFrame:ShowCloseButton(true)
					wepSelFrame:MakePopup()
				local wepSelList = vgui.Create("DListView")
					wepSelList:SetParent(wepSelFrame)
					wepSelList:SetPos(10, 30)
					wepSelList:SetSize(400, 400)
					wepSelList:SetMultiSelect(false)
					wepSelList:AddColumn("#tool.vj_tool_spawner.menu.popup.header.name")
					wepSelList:AddColumn("#tool.vj_tool_spawner.menu.popup.header.class")
					function wepSelList:OnRowSelected(rowIndex, row)
						chat.AddText(VJ.COLOR_GREEN, "#tool.vj_tool_spawner.menu.popup.title.wep")
					end
					function wepSelList:DoDoubleClick(lineID, line)
						chat.AddText(VJ.COLOR_GREEN, "Weapon", VJ.COLOR_ORANGE_VIVID, " " .. language.GetPhrase(line:GetValue(1)) .. " ", VJ.COLOR_GREEN, "selected!")
						LocalPlayer():ConCommand("vj_tool_spawner_weapon " .. line:GetValue(2))
						wepSelFrame:Close()
						selectedWep:SetText(language.GetPhrase("#tool.vj_tool_spawner.menu.selected.wep") .. ": " .. language.GetPhrase(line:GetValue(1)) .. " [" .. line:GetValue(2) .. "]")
					end
				for _, v in pairs(list.Get("NPCUsableWeapons")) do
					wepSelList:AddLine(v.title, v.class)
				end
				wepSelList:SortByColumn(1, false)
				wepSelList:AddLine("None", "None")
				wepSelList:AddLine("Default", "Default")
			end
		panel:AddItem(selectedWep)
		
		-- Relationship options
		panel:TextEntry("#tool.vj_tool_spawner.menu.relclass", "vj_tool_spawner_spawnnpclass")
		panel:CheckBox("#tool.vj_tool_spawner.menu.toggle.plyallied", "vj_tool_spawner_fritoplyallies")
		panel:ControlHelp("#tool.vj_tool_spawner.menu.toggle.plyallied.help")
		
		-- Add to list button
		local addButton = vgui.Create("DButton")
			addButton:SetFont("DermaDefaultBold")
			addButton:SetText("#tool.vj_tool_spawner.menu.button.add")
			addButton:SetSize(150, 25)
			addButton:SetColor(VJ.COLOR_BLACK)
			function addButton:DoClick()
				table.insert(VJ_TOOL_SPAWNER_LIST, {Ent=string.lower(GetConVar("vj_tool_spawner_spawnent"):GetString()), SpawnPosition=Vector(GetConVar("vj_tool_spawner_spawnpos_forward"):GetString(), GetConVar("vj_tool_spawner_spawnpos_right"):GetString(), GetConVar("vj_tool_spawner_spawnpos_up"):GetString()), Wep=string.lower(GetConVar("vj_tool_spawner_weapon"):GetString()), Relationship={Class = GetConVar("vj_tool_spawner_spawnnpclass"):GetString(), FriToPlyAllies = GetConVar("vj_tool_spawner_fritoplyallies"):GetString()}})
				local getPanel = controlpanel.Get("vj_tool_spawner")
				getPanel:Clear()
				ControlPanel(getPanel)
			end
		panel:AddPanel(addButton)
		
		-- Current NPCs to spawn list
		panel:Help("#tool.vj_tool_spawner.menu.list.help1")
		panel:Help("#tool.vj_tool_spawner.menu.list.help2")
		local spawnList = vgui.Create("DListView")
			spawnList:SetSize(100, 307)
			spawnList:SetMultiSelect(false)
			spawnList:AddColumn("#tool.vj_tool_spawner.menu.list.header.name")
			spawnList:AddColumn("#tool.vj_tool_spawner.menu.list.header.pos")
			spawnList:AddColumn("#tool.vj_tool_spawner.menu.list.header.wep")
			function spawnList:OnRowSelected(rowIndex, row)
				chat.AddText(VJ.COLOR_GREEN, "Double click to ", VJ.COLOR_ORANGE_VIVID, "remove", VJ.COLOR_GREEN, " it")
			end
			function spawnList:DoDoubleClick(lineID, line)
				chat.AddText(VJ.COLOR_GREEN, "NPC ", VJ.COLOR_ORANGE_VIVID, language.GetPhrase(line:GetValue(1)), VJ.COLOR_GREEN, " removed!")
				spawnList:RemoveLine(lineID)
				VJ_TOOL_SPAWNER_LIST = {}
				for _, vLine in pairs(spawnList:GetLines()) do
					table.insert(VJ_TOOL_SPAWNER_LIST, {Ent=vLine:GetValue(4), SpawnPosition=vLine:GetValue(2), Wep=vLine:GetValue(3), Relationship=vLine:GetValue(5)})
				end
			end
		panel:AddItem(spawnList)
		for k, v in pairs(VJ_TOOL_SPAWNER_LIST) do
			if v.Ent == "" or v.Ent == "none" or v.Ent == {} then
				table.remove(VJ_TOOL_SPAWNER_LIST, k)
			else
				npcName = list.GetEntry("NPC", v.Ent)
				local linePanel = spawnList:AddLine(npcName and language.GetPhrase(npcName.Name) or "None", v.SpawnPosition, v.Wep, v.Ent, v.Relationship)
				linePanel:SetTooltip(linePanel:GetValue(1) .. "\nEntity: " .. v.Ent .. "\nPostion: " .. tostring(v.SpawnPosition) .. "\nWeapon: " .. tostring(v.Wep) .. "\nRelationship Class: " .. tostring(v.Relationship.Class) .. "\nFriendly To Player Allies: " .. tostring(tobool(v.Relationship.FriToPlyAllies)))
			end
		end
		
		-- Spawner options
		panel:Help(language.GetPhrase("#tool.vj_tool_spawner.menu.header.options") .. ":")
		panel:CheckBox("#tool.vj_tool_spawner.menu.toggle.sound", "vj_tool_spawner_playsound")
		panel:NumSlider("#tool.vj_tool_spawner.menu.delaytime", "vj_tool_spawner_nextspawntime", 0, 1000, 0)
	end
---------------------------------------------------------------------------------------------------------------------------------------------
	net.Receive("vj_tool_spawner_cl_create", function(len)
		local wep = LocalPlayer():GetActiveWeapon()
		if wep:IsValid() && wep:GetClass() == "gmod_tool" && wep:GetMode() == "vj_tool_spawner" && hook.Run("CanTool", LocalPlayer(), LocalPlayer():GetEyeTrace(), "vj_tool_spawner") then
			local spawnPos = net.ReadVector()
			local spawnType = net.ReadBit()
			net.Start("vj_tool_spawner_sv_create")
				net.WriteVector(spawnPos)
				net.WriteBit(spawnType)
				net.WriteType(VJ_TOOL_SPAWNER_LIST)
			net.SendToServer()
		end
	end)
---------------------------------------------------------------------------------------------------------------------------------------------
	function TOOL.BuildCPanel(panel)
		ControlPanel(panel)
	end
else
	local spawnSounds = {"garrysmod/save_load1.wav", "garrysmod/save_load2.wav", "garrysmod/save_load3.wav", "garrysmod/save_load4.wav"}
	--
	net.Receive("vj_tool_spawner_sv_create", function(len, ply)
		local wep = ply:GetActiveWeapon()
		if wep:IsValid() && wep:GetClass() == "gmod_tool" && wep:GetMode() == "vj_tool_spawner" && hook.Run("CanTool", ply, ply:GetEyeTrace(), "vj_tool_spawner") then
			local spawnPos = net.ReadVector()
			local spawnType = net.ReadBit()
			local spawnEntries = net.ReadType()
			if table.IsEmpty(spawnEntries) then
				ply:ChatPrint("#tool.vj_tool_spawner.print.nothingspawn")
				return
			end
			
			-- Create the spawner
			local spawner = ents.Create("obj_vj_spawner_base")
			spawner:SetPos(spawnPos)
			local spawnAng = ply:GetAngles()
			spawnAng.yaw = spawnAng.yaw + 180
			spawner:SetAngles(spawnAng)
			spawner.EntitiesToSpawn = {}
			for k, v in pairs(spawnEntries) do
				//if v.IsVJBaseSpawner == true then ply:ChatPrint("Can't be spawned because it's a spawner") end
				local relClass = v.Relationship.Class
				if relClass == "" then relClass = nil end
				spawner.EntitiesToSpawn[k] = {SpawnPosition=v.SpawnPosition, Entities={v.Ent}, WeaponsList={v.Wep}, NPC_Class = relClass, FriToPlyAllies = tobool(v.Relationship.FriToPlyAllies)}
			end
			if ply:GetInfoNum("vj_tool_spawner_playsound", 1) == 1 then
				spawner.SoundTbl_SpawnEntity = spawnSounds
			end
			if spawnType == 1 then
				spawner.SingleSpawner = true
			end
			spawner.RespawnCooldown = ply:GetInfoNum("vj_tool_spawner_nextspawntime", 3)
			spawner:SetCreator(ply)
			spawner:Spawn()
			spawner:Activate()
			undo.Create("NPC Spawner")
				undo.AddEntity(spawner)
				undo.SetPlayer(ply)
			undo.Finish()
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:LeftClick(tr)
	if CLIENT then return true end
	net.Start("vj_tool_spawner_cl_create")
		net.WriteVector(tr.HitPos)
		net.WriteBit(0)
	net.Send(self:GetOwner())
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:RightClick(tr)
	if CLIENT then return true end
	net.Start("vj_tool_spawner_cl_create")
		net.WriteVector(tr.HitPos)
		net.WriteBit(1)
	net.Send(self:GetOwner())
	return true
end