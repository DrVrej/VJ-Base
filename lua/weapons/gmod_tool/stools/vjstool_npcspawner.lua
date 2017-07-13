TOOL.Name = "NPC Spawner"
TOOL.Category = "Tools"
TOOL.Tab = "DrVrej"
TOOL.Command = nil
TOOL.ConfigName = ""

TOOL.ClientConVar["playsound"] = 1
TOOL.ClientConVar["nextspawntime"] = 1
TOOL.ClientConVar["spawnent"] = "None"
TOOL.ClientConVar["spawnentname"] = "Unknown"
TOOL.ClientConVar["spawnpos_forward"] = 0
TOOL.ClientConVar["spawnpos_right"] = 0
TOOL.ClientConVar["spawnpos_up"] = 0
TOOL.ClientConVar["weaponequip"] = "None"
TOOL.ClientConVar["weaponequipname"] = "Unknown"
TOOL.ClientConVar["nextspawntime"] = 3

local DefaultConVars = {}
for k,v in pairs(TOOL.ClientConVar) do
	DefaultConVars["vjstool_npcspawner_"..k] = v
end
---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
	language.Add("tool.vjstool_npcspawner.name", "NPC Spawner")
	language.Add("tool.vjstool_npcspawner.desc", "Creates an spawner")
	language.Add("tool.vjstool_npcspawner.0", "Left-Click to create a spawner, Right-Click to spawn the NPCs once")
	
	//language.Add("vjbase.npctools.health", "Health")
---------------------------------------------------------------------------------------------------------------------------------------------
	local function DoBuildCPanel_Spawner(Panel)
		//PrintTable(DefaultConVars)
		//Panel:AddControl("Header", {Text = "NPC Tool", Description = "Left click to change the NPC's property"})
		
		local reset = vgui.Create("DButton")
		reset:SetFont("DermaDefaultBold")
		reset:SetText("Reset To Default")
		reset:SetSize(150,25)
		reset:SetColor(Color(0,0,0,255))
		reset.DoClick = function(reset)
			for k,v in pairs(DefaultConVars) do
				if v == "" then LocalPlayer():ConCommand(k.." ".."None") else
				LocalPlayer():ConCommand(k.." "..v) end
				//LocalPlayer():ConCommand("vjstool_npcproperty_health 100")
				timer.Simple(0.05,function()
				GetPanel = controlpanel.Get("vjstool_npcspawner")
				GetPanel:ClearControls()
				DoBuildCPanel_Spawner(GetPanel)
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
			gui.OpenURL("http://www.youtube.com/watch?v=5H_hIz35W90")
		end
		Panel:AddPanel(tutorial)
		
		TblCurrentValues = TblCurrentValues or {}
		TblCurrentLines = TblCurrentLines or {}
		TblCurrentLinesUsable = TblCurrentLinesUsable or {}
		Panel:AddControl("Label", {Text = "It's recommended to use this tool only for VJ Base SNPCs."})
		/*local textbox = vgui.Create("DTextEntry")
			textbox:SetSize(10,20)
			//textbox:SetPos(5,27)
			textbox:SetText("Test")
			textbox:SetConVar("vjstool_npcspawner_spawnent")
			textbox:SetMultiline(false)
		Panel:AddPanel(textbox)*/
		local selectnpc = vgui.Create("DTextEntry")
			selectnpc:SetEditable(false)
			selectnpc:SetText("Selected NPC: "..GetConVarString("vjstool_npcspawner_spawnentname").." ["..GetConVarString("vjstool_npcspawner_spawnent").."]")
			selectnpc.OnGetFocus = function() LocalPlayer():ConCommand("vj_npcspawner_opennpcselect") end
		Panel:AddItem(selectnpc)
		//Panel:AddControl("Button",{Label = "Select NPC",Command = "vj_npcspawner_opennpcselect"})
		//Panel:AddControl("Label", {Text = "Selected NPC:"..GetConVarString("vjstool_npcspawner_spawnent")})
		//Panel:AddControl("TextBox",{Label = "Selected NPC:",MaxLength = 40,Type = "String",WaitForEnter = false,Command = "vjstool_npcspawner_spawnent"})
		Panel:AddControl("TextBox",{Label = "Spawn Pos(Forward)",MaxLength = 10,Type = "Float",WaitForEnter = false,Command = "vjstool_npcspawner_spawnpos_forward"})
		Panel:AddControl("TextBox",{Label = "Spawn Pos(Right)",MaxLength = 10,Type = "Float",WaitForEnter = false,Command = "vjstool_npcspawner_spawnpos_right"})
		Panel:AddControl("TextBox",{Label = "Spawn Pos(Up)",MaxLength = 10,Type = "Float",WaitForEnter = false,Command = "vjstool_npcspawner_spawnpos_up"})
		local selectwep = vgui.Create("DTextEntry")
		selectwep:SetEditable(false)
		selectwep:SetText("Selected Weapon: "..GetConVarString("vjstool_npcspawner_weaponequipname").." ["..GetConVarString("vjstool_npcspawner_weaponequip").."]")
		selectwep.OnGetFocus = function() LocalPlayer():ConCommand("vj_npcspawner_openwepselect") end
		Panel:AddItem(selectwep)
		//Panel:AddControl("TextBox",{Label = "Equipment",MaxLength = 40,Type = "String",WaitForEnter = false,Command = "vjstool_npcspawner_weaponequip"})
		Panel:AddControl("Button",{Label = "Update List",Command = "vj_npcspawner_updatelist"})
		Panel:ControlHelp("Double click on an item to remove it")
		local CheckList = vgui.Create("DListView")
			CheckList:SetTooltip(false)
			//CheckList:Center() -- No need since Size does it already
			CheckList:SetSize( 100, 300 ) -- Size
			CheckList:SetMultiSelect(false)
			//CheckList.Paint = function()
			//draw.RoundedBox( 8, 0, 0, CheckList:GetWide(), CheckList:GetTall(), Color( 0, 0, 100, 255 ) )
			//end
			CheckList:AddColumn("Name")
			CheckList:AddColumn("Position")
			CheckList:AddColumn("Equipment")
			CheckList.OnRowSelected = function(rowIndex,row) chat.AddText(Color(0,255,0),"Double click to ",Color(255,100,0),"remove ",Color(0,255,0),"a NPC") end
			function CheckList:DoDoubleClick(lineID,line)
				chat.AddText(Color(0,255,0),"NPC",Color(255,100,0)," "..line:GetValue(1).." ",Color(0,255,0),"removed!")
				CheckList:RemoveLine(lineID)
				table.Empty(TblCurrentLinesUsable)
				for kLine,vLine in pairs(TblCurrentLines) do
					table.insert(TblCurrentLinesUsable,{Entities=vLine:GetValue(4),SpawnPosition=vLine:GetValue(2),WeaponsList=vLine:GetValue(3),EntityName=vLine:GetValue(1)})
				end
			end
		Panel:AddItem(CheckList)
		for k,v in pairs(TblCurrentValues) do
			if v.Entities == "" or v.Entities == "none" or v.Entities == {} then table.remove(TblCurrentValues,k) continue end
			if v.Entities != "" && v.Entities != "none" && v.Entities != {} then
				CheckList:AddLine(v.EntityName,Vector(v.SpawnPosition.vForward,v.SpawnPosition.vRight,v.SpawnPosition.vUp),v.WeaponsList,v.Entities)
				//CheckList:AddLine(v.Entities,"x:"..v.SpawnPosition.vForward.." y:"..v.SpawnPosition.vRight.." z:"..v.SpawnPosition.vUp)
			end
		end
		table.Empty(TblCurrentValues)
		for kLine,vLine in pairs(TblCurrentLines) do
			CheckList:AddLine(vLine:GetValue(1),vLine:GetValue(2),vLine:GetValue(3),vLine:GetValue(4))
		end
		TblCurrentLines = CheckList:GetLines()
		table.Empty(TblCurrentLinesUsable)
		for kLine,vLine in pairs(TblCurrentLines) do
			table.insert(TblCurrentLinesUsable,{Entities=vLine:GetValue(4),SpawnPosition=vLine:GetValue(2),WeaponsList=vLine:GetValue(3),EntityName=vLine:GetValue(1)})
		end
		Panel:AddControl("Label", {Text = "Extra Options:"})
		Panel:AddControl("Checkbox", {Label = "Play NPC Spawning Sound?", Command = "vjstool_npcspawner_playsound"})
		Panel:AddControl("Slider", {Label = "Next Spawn Time",min = 0,max = 1000,Command = "vjstool_npcspawner_nextspawntime"})
	end
---------------------------------------------------------------------------------------------------------------------------------------------
	concommand.Add("vj_npcspawner_opennpcselect",function(pl,cmd,args)
		local MenuFrame = vgui.Create('DFrame')
		MenuFrame:SetSize(420, 440)
		MenuFrame:SetPos(ScrW()*0.6, ScrH()*0.1)
		MenuFrame:SetTitle("Double click to select an NPC")
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
			CheckList:SetPos(10,30)
			CheckList:SetSize(400,400) -- Size
			CheckList:SetMultiSelect(false)
			CheckList:AddColumn("Name")
			CheckList:AddColumn("Class")
			CheckList:AddColumn("Category")
			CheckList.OnRowSelected = function() chat.AddText(Color(0,255,0),"Double click to select an NPC") end
			function CheckList:DoDoubleClick(lineID,line)
				chat.AddText(Color(0,255,0),"NPC",Color(255,100,0)," "..line:GetValue(1).." ",Color(0,255,0),"selected!")
				LocalPlayer():ConCommand("vjstool_npcspawner_spawnentname "..line:GetValue(1))
				LocalPlayer():ConCommand("vjstool_npcspawner_spawnent "..line:GetValue(2))
				MenuFrame:Close()
				timer.Simple(0.05,function()
				GetPanel = controlpanel.Get("vjstool_npcspawner")
				GetPanel:ClearControls()
				DoBuildCPanel_Spawner(GetPanel)
				end)
			end
		//MenuFrame:AddItem(CheckList)
		//CheckList:SizeToContents()
		for k,v in pairs(list.Get("NPC")) do
			getcat = v.Category
			if v.Category == "" then getcat = "Unknown" end
			CheckList:AddLine(v.Name,v.Class,getcat)
		end
		CheckList:SortByColumn(1,false)
	end)
---------------------------------------------------------------------------------------------------------------------------------------------
	concommand.Add("vj_npcspawner_openwepselect",function(pl,cmd,args)
		local MenuFrame = vgui.Create('DFrame')
		MenuFrame:SetSize(420, 440)
		MenuFrame:SetPos(ScrW()*0.6, ScrH()*0.1)
		MenuFrame:SetTitle("Double click to select a weapon")
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
			CheckList:SetPos(10,30)
			CheckList:SetSize(400,400) -- Size
			CheckList:SetMultiSelect(false)
			CheckList:AddColumn("Name")
			CheckList:AddColumn("Class")
			CheckList.OnRowSelected = function() chat.AddText(Color(0,255,0),"Double click to select a weapon") end
			function CheckList:DoDoubleClick(lineID,line)
				chat.AddText(Color(0,255,0),"Weapon",Color(255,100,0)," "..line:GetValue(1).." ",Color(0,255,0),"selected!")
				LocalPlayer():ConCommand("vjstool_npcspawner_weaponequipname "..line:GetValue(1))
				LocalPlayer():ConCommand("vjstool_npcspawner_weaponequip "..line:GetValue(2))
				MenuFrame:Close()
				timer.Simple(0.05,function()
				GetPanel = controlpanel.Get("vjstool_npcspawner")
				GetPanel:ClearControls()
				DoBuildCPanel_Spawner(GetPanel)
				end)
			end
		//MenuFrame:AddItem(CheckList)
		//CheckList:SizeToContents()
		for k,v in pairs(list.Get("NPCUsableWeapons")) do
			CheckList:AddLine(v.title,v.class)
		end
		CheckList:SortByColumn(1,false)
	end)
---------------------------------------------------------------------------------------------------------------------------------------------
	concommand.Add("vj_npcspawner_updatelist",function(pl,cmd,args)
		local spawnent = string.lower(GetConVarString("vjstool_npcspawner_spawnent"))
		local spawnentname = GetConVarString("vjstool_npcspawner_spawnentname")
		local spawnposfor = GetConVarString("vjstool_npcspawner_spawnpos_forward")
		local spawnposright = GetConVarString("vjstool_npcspawner_spawnpos_right")
		local spawnposup = GetConVarString("vjstool_npcspawner_spawnpos_up")
		local spawnequip = string.lower(GetConVarString("vjstool_npcspawner_weaponequip"))
		table.insert(TblCurrentValues,{EntityName=spawnentname,Entities=spawnent,SpawnPosition={vForward=spawnposfor,vRight=spawnposright,vUp=spawnposup},WeaponsList=spawnequip})
		GetPanel = controlpanel.Get("vjstool_npcspawner")
		GetPanel:ClearControls()
		DoBuildCPanel_Spawner(GetPanel)
	end)
---------------------------------------------------------------------------------------------------------------------------------------------
	net.Receive("vj_npcspawner_cl_create",function(len,pl)
		svowner = net.ReadEntity()
		svpos = net.ReadVector()
		svang = net.ReadFloat()
		svclicktype = net.ReadString()
		local convartbl = {}
		for k,v in pairs(DefaultConVars) do
			convartbl[k] = GetConVarNumber(k)
		end
		net.Start("vj_npcspawner_sv_create")
		net.WriteTable(convartbl)
		net.WriteEntity(svowner)
		net.WriteVector(svpos)
		net.WriteFloat(svang)
		net.WriteType(TblCurrentLinesUsable)
		net.WriteString(svclicktype)
		net.SendToServer()
	end)
---------------------------------------------------------------------------------------------------------------------------------------------
	function TOOL.BuildCPanel(Panel)
		DoBuildCPanel_Spawner(Panel)
	end
else -- If SERVER
	util.AddNetworkString("vj_npcspawner_cl_create")
	util.AddNetworkString("vj_npcspawner_sv_create")
---------------------------------------------------------------------------------------------------------------------------------------------
	net.Receive("vj_npcspawner_sv_create",function(len,pl)
		convartbl = net.ReadTable()
		svowner = net.ReadEntity()
		svpos = net.ReadVector()
		svang = net.ReadFloat()
		svgetlines = net.ReadType()
		svgettype = net.ReadString()
		if !IsValid(svowner) then return false end
		if table.Count(svgetlines) <= 0 then svowner:ChatPrint("Nothing to spawn!") return false end
		local spawner = ents.Create("obj_vj_spawner_base")
		spawner.EntitiesToSpawn = {}
		spawner:SetPos(svpos)
		spawner:SetAngles(Angle(0,svang,0))
		for k,v in pairs(svgetlines) do
			if v.IsVJBaseSpawner == true then svowner:ChatPrint("FUCK YOU") end //chat.AddText(Color(255,100,0)," Can't be spawned because it's a spawner") end
			table.insert(spawner.EntitiesToSpawn,{EntityName = "NPC"..math.random(1,99999999),SpawnPosition = {vForward=v.SpawnPosition.x,vRight=v.SpawnPosition.y,vUp=v.SpawnPosition.z},Entities = {v.Entities},WeaponsList={v.WeaponsList}})
		end
		//spawner.EntitiesToSpawn = {entitiestospawntbl}
		if convartbl.vjstool_npcspawner_playsound == 1 then
			spawner.SoundTbl_SpawnEntity = {"garrysmod/save_load1.wav","garrysmod/save_load2.wav","garrysmod/save_load3.wav","garrysmod/save_load4.wav"}
		end
		spawner.TimedSpawn_Time = convartbl.vjstool_npcspawner_nextspawntime //GetConVarNumber("vjstool_npcspawner_nextspawntime")
		if svgettype == "RightClick" then spawner.SingleSpawner = true end
		spawner:SetCreator(svowner)
		spawner:Spawn()
		spawner:Activate()
		undo.Create("NPC Spawner")
		undo.AddEntity(spawner)
		undo.SetPlayer(svowner)
		undo.Finish()
		for vpk,vpv in pairs(spawner.CurrentEntities) do
			if IsValid(vpv.TheEntity) && vpv.TheEntity.IsVJBaseSpawner == true && vpv.TheEntity.SingleSpawner == true then
				vpv.TheEntity:SetCreator(svowner)
				table.remove(spawner.CurrentEntities,vpk)
				if table.Count(spawner.CurrentEntities) <= 0 then spawner:Remove() end
			end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:LeftClick(tr)
	if (CLIENT) then return true end
	net.Start("vj_npcspawner_cl_create")
	net.WriteEntity(self:GetOwner())
	net.WriteVector(tr.HitPos)
	net.WriteFloat(self:GetOwner():GetAimVector():Angle().y)
	net.WriteString("LeftClick")
	net.Send(self:GetOwner())
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:RightClick(tr)
	if (CLIENT) then return true end
	net.Start("vj_npcspawner_cl_create")
	net.WriteEntity(self:GetOwner())
	net.WriteVector(tr.HitPos)
	net.WriteFloat(self:GetOwner():GetAimVector():Angle().y)
	net.WriteString("RightClick")
	net.Send(self:GetOwner())
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:Reload(tr)
	if (CLIENT) then return true end
end