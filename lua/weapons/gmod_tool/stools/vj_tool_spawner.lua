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
	weaponequip = "None",
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
		reset.DoClick = function()
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
		
		local tutorial = vgui.Create("DButton")
		tutorial:SetFont("DermaDefaultBold")
		tutorial:SetText("#vjbase.menu.general.tutorial.vid")
		tutorial:SetSize(150, 20)
		tutorial:SetColor(VJ.COLOR_BLUE)
		tutorial.DoClick = function()
			gui.OpenURL("http://www.youtube.com/watch?v=5H_hIz35W90")
		end
		panel:AddPanel(tutorial)
		
		VJ_NPCSPAWNER_TblCurrentValues = VJ_NPCSPAWNER_TblCurrentValues or {}
		VJ_NPCSPAWNER_TblCurrentLines = VJ_NPCSPAWNER_TblCurrentLines or {}
		VJ_NPCSPAWNER_TblCurrentLinesUsable = VJ_NPCSPAWNER_TblCurrentLinesUsable or {}
		
		panel:Help("#vjbase.tool.general.note.recommend")
		local selectnpc = vgui.Create("DTextEntry")
			selectnpc:SetEditable(false)
			local npcName = list.Get("NPC")[GetConVarString("vj_tool_spawner_spawnent")]
			selectnpc:SetText(language.GetPhrase("#tool.vj_tool_spawner.selectednpc")..": "..(npcName and npcName.Name or "None").." ["..GetConVarString("vj_tool_spawner_spawnent").."]")
			selectnpc.OnGetFocus = function() LocalPlayer():ConCommand("vj_npcspawner_opennpcselect") end
		panel:AddItem(selectnpc)
		panel:TextEntry("#tool.vj_tool_spawner.spawnpos.forward", "vj_tool_spawner_spawnpos_forward")
		panel:TextEntry("#tool.vj_tool_spawner.spawnpos.right", "vj_tool_spawner_spawnpos_right")
		panel:TextEntry("#tool.vj_tool_spawner.spawnpos.up", "vj_tool_spawner_spawnpos_up")
		local selectwep = vgui.Create("DTextEntry")
			selectwep:SetEditable(false)
			local equipName = list.Get("NPCUsableWeapons")[GetConVarString("vj_tool_spawner_weaponequip")]
			selectwep:SetText(language.GetPhrase("#tool.vj_tool_spawner.selectweapon")..": "..(equipName and equipName.Name or "None").." ["..GetConVarString("vj_tool_spawner_weaponequip").."]")
			selectwep.OnGetFocus = function() LocalPlayer():ConCommand("vj_npcspawner_openwepselect") end
		panel:AddItem(selectwep)
		panel:TextEntry("#tool.vj_tool_spawner.spawnnpclass", "vj_tool_spawner_spawnnpclass")
		panel:CheckBox("#tool.vj_tool_spawner.fritoplyallies", "vj_tool_spawner_fritoplyallies")
		panel:ControlHelp("#tool.vj_tool_spawner.label.fritoplyallies")
		panel:Button("#tool.vj_tool_spawner.button.updatelist", "vj_npcspawner_updatelist")
		panel:ControlHelp("#tool.vj_tool_spawner.label1")
		local CheckList = vgui.Create("DListView")
			CheckList:SetTooltip(false)
			CheckList:SetSize(100, 307) -- Size
			CheckList:SetMultiSelect(false)
			CheckList:AddColumn("#tool.vj_tool_spawner.header1")
			CheckList:AddColumn("#tool.vj_tool_spawner.header2")
			CheckList:AddColumn("#tool.vj_tool_spawner.header3")
			CheckList.OnRowSelected = function(rowIndex, row) chat.AddText(Color(0, 255, 0), "Double click to ", Color(255, 100, 0), "remove ", Color(0, 255, 0), "a NPC") end
			function CheckList:DoDoubleClick(lineID, line)
				chat.AddText(Color(0, 255, 0), "NPC", Color(255, 100, 0), " "..line:GetValue(1).." ", Color(0, 255, 0), "removed!")
				CheckList:RemoveLine(lineID)
				table.Empty(VJ_NPCSPAWNER_TblCurrentLinesUsable)
				for _, vLine in pairs(VJ_NPCSPAWNER_TblCurrentLines) do
					table.insert(VJ_NPCSPAWNER_TblCurrentLinesUsable, {Entities=vLine:GetValue(4), SpawnPosition=vLine:GetValue(2), WeaponsList=vLine:GetValue(3), Relationship=vLine:GetValue(5)})
				end
			end
		panel:AddItem(CheckList)
		for k, v in pairs(VJ_NPCSPAWNER_TblCurrentValues) do
			if v.Entities == "" or v.Entities == "none" or v.Entities == {} then table.remove(VJ_NPCSPAWNER_TblCurrentValues, k) continue end
			if v.Entities != "" && v.Entities != "none" && v.Entities != {} then
				npcName = list.Get("NPC")[v.Entities]
				CheckList:AddLine(npcName and npcName.Name or "None", v.SpawnPosition, v.WeaponsList, v.Entities, v.Relationship)
				//CheckList:AddLine(v.Entities, "x:"..v.SpawnPosition.vForward.." y:"..v.SpawnPosition.vRight.." z:"..v.SpawnPosition.vUp)
			end
		end
		table.Empty(VJ_NPCSPAWNER_TblCurrentValues)
		for _, vLine in pairs(VJ_NPCSPAWNER_TblCurrentLines) do
			CheckList:AddLine(vLine:GetValue(1), vLine:GetValue(2), vLine:GetValue(3), vLine:GetValue(4), vLine:GetValue(5))
		end
		VJ_NPCSPAWNER_TblCurrentLines = CheckList:GetLines()
		table.Empty(VJ_NPCSPAWNER_TblCurrentLinesUsable)
		for _, vLine in pairs(VJ_NPCSPAWNER_TblCurrentLines) do
			table.insert(VJ_NPCSPAWNER_TblCurrentLinesUsable, {Entities=vLine:GetValue(4), SpawnPosition=vLine:GetValue(2), WeaponsList=vLine:GetValue(3), Relationship=vLine:GetValue(5)})
		end
		panel:Help(language.GetPhrase("#tool.vj_tool_spawner.label2")..":")
		panel:CheckBox("#tool.vj_tool_spawner.toggle.spawnsound", "vj_tool_spawner_playsound")
		panel:NumSlider("#tool.vj_tool_spawner.nextspawntime", "vj_tool_spawner_nextspawntime", 0, 1000, 0)
	end
---------------------------------------------------------------------------------------------------------------------------------------------
	concommand.Add("vj_npcspawner_opennpcselect", function(ply, cmd, args)
		local MenuFrame = vgui.Create('DFrame')
		MenuFrame:SetSize(420, 440)
		MenuFrame:SetPos(ScrW()*0.6, ScrH()*0.1)
		MenuFrame:SetTitle("#tool.vj_tool_spawner.title1")
		//MenuFrame:SetBackgroundBlur(true)
		MenuFrame:SetFocusTopLevel(true)
		MenuFrame:SetSizable(true)
		MenuFrame:ShowCloseButton(true)
		//MenuFrame:SetDeleteOnClose(false)
		MenuFrame:MakePopup()
		
		local CheckList = vgui.Create("DListView")
			CheckList:SetTooltip(false)
			//CheckList:Center() -- No need since Size does it already
			CheckList:SetParent(MenuFrame)
			CheckList:SetPos(10, 30)
			CheckList:SetSize(400, 400) -- Size
			CheckList:SetMultiSelect(false)
			CheckList:AddColumn("#tool.vj_tool_spawner.popup.header1")
			CheckList:AddColumn("#tool.vj_tool_spawner.popup.header2")
			CheckList:AddColumn("#tool.vj_tool_spawner.popup.header3")
			CheckList.OnRowSelected = function() chat.AddText(Color(0, 255, 0), "#tool.vj_tool_spawner.title1") end
			function CheckList:DoDoubleClick(lineID, line)
				chat.AddText(Color(0, 255, 0), "NPC", Color(255, 100, 0), " "..line:GetValue(1).." ", Color(0, 255, 0), "selected!")
				LocalPlayer():ConCommand("vj_tool_spawner_spawnent "..line:GetValue(2))
				MenuFrame:Close()
				timer.Simple(0.05, function() -- Otherwise it will not update the values in time
					local getPanel = controlpanel.Get("vj_tool_spawner")
					getPanel:Clear()
					ControlPanel(getPanel)
				end)
			end
		//MenuFrame:AddItem(CheckList)
		//CheckList:SizeToContents()
		for _, v in pairs(list.Get("NPC")) do
			local getcat = v.Category
			if v.Category == "" then getcat = "Unknown" end
			CheckList:AddLine(v.Name, v.Class, getcat)
		end
		CheckList:SortByColumn(1, false)
	end)
---------------------------------------------------------------------------------------------------------------------------------------------
	concommand.Add("vj_npcspawner_openwepselect", function(ply, cmd, args)
		local MenuFrame = vgui.Create('DFrame')
		MenuFrame:SetSize(420, 440)
		MenuFrame:SetPos(ScrW()*0.6, ScrH()*0.1)
		MenuFrame:SetTitle("#tool.vj_tool_spawner.title2")
		//MenuFrame:SetBackgroundBlur(true)
		MenuFrame:SetFocusTopLevel(true)
		MenuFrame:SetSizable(true)
		MenuFrame:ShowCloseButton(true)
		//MenuFrame:SetDeleteOnClose(false)
		MenuFrame:MakePopup()
		
		local CheckList = vgui.Create("DListView")
			CheckList:SetTooltip(false)
			//CheckList:Center() -- No need since Size does it already
			CheckList:SetParent(MenuFrame)
			CheckList:SetPos(10, 30)
			CheckList:SetSize(400, 400) -- Size
			CheckList:SetMultiSelect(false)
			CheckList:AddColumn("#tool.vj_tool_spawner.popup.header1")
			CheckList:AddColumn("#tool.vj_tool_spawner.popup.header2")
			CheckList.OnRowSelected = function() chat.AddText(Color(0, 255, 0), "#tool.vj_tool_spawner.title2") end
			function CheckList:DoDoubleClick(lineID, line)
				chat.AddText(Color(0, 255, 0), "Weapon", Color(255, 100, 0), " "..line:GetValue(1).." ", Color(0, 255, 0), "selected!")
				//LocalPlayer():ConCommand("vj_tool_spawner_weaponequipname "..line:GetValue(1))
				LocalPlayer():ConCommand("vj_tool_spawner_weaponequip "..line:GetValue(2))
				MenuFrame:Close()
				timer.Simple(0.05, function() -- Otherwise it will not update the values in time
					local getPanel = controlpanel.Get("vj_tool_spawner")
					getPanel:Clear()
					ControlPanel(getPanel)
				end)
			end
		//MenuFrame:AddItem(CheckList)
		//CheckList:SizeToContents()
		for _, v in pairs(list.Get("NPCUsableWeapons")) do
			CheckList:AddLine(v.title, v.class)
		end
		CheckList:SortByColumn(1, false)
		CheckList:AddLine("None", "None")
		CheckList:AddLine("Default", "Default")
	end)
---------------------------------------------------------------------------------------------------------------------------------------------
	concommand.Add("vj_npcspawner_updatelist", function(ply, cmd, args)
		local spawnent = string.lower(GetConVarString("vj_tool_spawner_spawnent"))
		local spawnposfor = GetConVarString("vj_tool_spawner_spawnpos_forward")
		local spawnposright = GetConVarString("vj_tool_spawner_spawnpos_right")
		local spawnposup = GetConVarString("vj_tool_spawner_spawnpos_up")
		local spawnnpclass = GetConVarString("vj_tool_spawner_spawnnpclass")
		local spawnfritoplyallies = GetConVarString("vj_tool_spawner_fritoplyallies")
		local spawnequip = string.lower(GetConVarString("vj_tool_spawner_weaponequip"))
		table.insert(VJ_NPCSPAWNER_TblCurrentValues, {Entities=spawnent, SpawnPosition=Vector(spawnposfor, spawnposright, spawnposup), WeaponsList=spawnequip, Relationship={Class = spawnnpclass, FriToPlyAllies = spawnfritoplyallies}})
		local getPanel = controlpanel.Get("vj_tool_spawner")
		getPanel:Clear()
		ControlPanel(getPanel)
	end)
---------------------------------------------------------------------------------------------------------------------------------------------
	net.Receive("vj_tool_spawner_cl_create", function(len)
		local wep = LocalPlayer():GetActiveWeapon()
		if wep:IsValid() && wep:GetClass() == "gmod_tool" && wep:GetMode() == "vj_tool_spawner" && hook.Run("CanTool", LocalPlayer(), LocalPlayer():GetEyeTrace(), "vj_tool_spawner") then
			local svpos = net.ReadVector()
			local svclicktype = net.ReadString()
			local convartbl = {}
			for k, _ in pairs(defaultConvars) do
				convartbl[k] = GetConVarNumber(k)
			end
			net.Start("vj_tool_spawner_sv_create")
			net.WriteTable(convartbl)
			net.WriteVector(svpos)
			net.WriteType(VJ_NPCSPAWNER_TblCurrentLinesUsable)
			net.WriteString(svclicktype)
			net.SendToServer()
		end
	end)
---------------------------------------------------------------------------------------------------------------------------------------------
	function TOOL.BuildCPanel(panel)
		ControlPanel(panel)
	end
else
	util.AddNetworkString("vj_tool_spawner_cl_create")
	util.AddNetworkString("vj_tool_spawner_sv_create")
---------------------------------------------------------------------------------------------------------------------------------------------
	local spawnSounds = {"garrysmod/save_load1.wav", "garrysmod/save_load2.wav", "garrysmod/save_load3.wav", "garrysmod/save_load4.wav"}
	--
	net.Receive("vj_tool_spawner_sv_create", function(len, ply)
		local wep = ply:GetActiveWeapon()
		if wep:IsValid() && wep:GetClass() == "gmod_tool" && wep:GetMode() == "vj_tool_spawner" && hook.Run("CanTool", ply, ply:GetEyeTrace(), "vj_tool_spawner") then
			local convartbl = net.ReadTable()
			local svpos = net.ReadVector()
			local svgetlines = net.ReadType()
			local svgettype = net.ReadString()
			if !IsValid(ply) then return false end
			if table.IsEmpty(svgetlines) then ply:ChatPrint("#tool.vj_tool_spawner.print.nothingspawn") return false end
			local spawner = ents.Create("obj_vj_spawner_base")
			spawner.EntitiesToSpawn = {}
			spawner:SetPos(svpos)
			local angs = Angle(0, 0, 0)
			if IsValid(ply) then
				angs = ply:GetAngles()
				angs.pitch = 0
				angs.roll = 0
				angs.yaw = angs.yaw + 180
			end
			spawner:SetAngles(angs)
			for _, v in pairs(svgetlines) do
				//if v.IsVJBaseSpawner == true then ply:ChatPrint("Can't be spawned because it's a spawner") end
				table.insert(spawner.EntitiesToSpawn, {SpawnPosition=v.SpawnPosition, Entities={v.Entities}, WeaponsList={v.WeaponsList}, NPC_Class = v.Relationship.Class, FriToPlyAllies = tobool(v.Relationship.FriToPlyAllies)})
			end
			if convartbl.vj_tool_spawner_playsound == 1 then
				spawner.SoundTbl_SpawnEntity = spawnSounds
			end
			spawner.RespawnCooldown = convartbl.vj_tool_spawner_nextspawntime //GetConVarNumber("vj_tool_spawner_nextspawntime")
			if svgettype == "RightClick" then spawner.SingleSpawner = true end
			spawner:SetCreator(ply)
			spawner:Spawn()
			spawner:Activate()
			undo.Create("NPC Spawner")
			undo.AddEntity(spawner)
			undo.SetPlayer(ply)
			undo.Finish()
			for vpk, vpv in pairs(spawner.CurrentEntities) do
				if IsValid(vpv.TheEntity) && vpv.TheEntity.IsVJBaseSpawner == true && vpv.TheEntity.SingleSpawner == true then
					vpv.TheEntity:SetCreator(ply)
					table.remove(spawner.CurrentEntities, vpk)
					if table.IsEmpty(spawner.CurrentEntities) then spawner:Remove() end
				end
			end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:LeftClick(tr)
	if CLIENT then return true end
	net.Start("vj_tool_spawner_cl_create")
	net.WriteVector(tr.HitPos)
	net.WriteString("LeftClick")
	net.Send(self:GetOwner())
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:RightClick(tr)
	if CLIENT then return true end
	net.Start("vj_tool_spawner_cl_create")
	net.WriteVector(tr.HitPos)
	net.WriteString("RightClick")
	net.Send(self:GetOwner())
	return true
end