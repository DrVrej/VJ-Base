/*--------------------------------------------------
	=============== Installed Addons ===============
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to Check what addons are installed that use VJ Base
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
VJBASE_GETADDONS = InstalledVJBaseAddons
if VJBASE_GETADDONS != nil then VJBASE_GETADDONAMOUNT = table.Count(VJBASE_GETADDONS) else VJBASE_GETADDONAMOUNT = 0 end
---------------------------------------------------------------------------------------------------------------------------------------------
-- Add the addons to the table --
	// Alphabetical Order \\
-- A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z --
/*if (file.Exists("autorun/vj_as_autorun.lua","LUA")) then table.insert(VJBASE_GETADDONS,"aliensw") end
if (file.Exists("autorun/vj_bms_autorun.lua","LUA")) then table.insert(VJBASE_GETADDONS,"bms") end
if (file.Exists("autorun/vj_cof_autorun.lua","LUA")) then table.insert(VJBASE_GETADDONS,"cof") end
if (file.Exists("autorun/vj_dms_autorun.lua","LUA")) then table.insert(VJBASE_GETADDONS,"dm") end
if (file.Exists("autorun/vj_eye_autorun.lua","LUA")) then table.insert(VJBASE_GETADDONS,"eye") end
if (file.Exists("autorun/vj_fo3_autorun.lua","LUA")) then table.insert(VJBASE_GETADDONS,"fo3") end
if (file.Exists("autorun/halo_autorun.lua","LUA")) then table.insert(VJBASE_GETADDONS,"halo2") end
if (file.Exists("autorun/vj_hl2_autorun.lua","LUA")) then table.insert(VJBASE_GETADDONS,"hl2snpc") end
if (file.Exists("autorun/vj_kf_autorun.lua","LUA")) then table.insert(VJBASE_GETADDONS,"kf") end
if (file.Exists("autorun/vj_miliru_autorun.lua","LUA")) then table.insert(VJBASE_GETADDONS,"miliru") end
if (file.Exists("autorun/vj_milius_autorun.lua","LUA")) then table.insert(VJBASE_GETADDONS,"milius") end
if (file.Exists("autorun/vj_milisurg_autorun.lua","LUA")) then table.insert(VJBASE_GETADDONS,"milisurg") end
if (file.Exists("autorun/vj_miliger_autorun.lua","LUA")) then table.insert(VJBASE_GETADDONS,"miliger") end
if (file.Exists("autorun/vj_nmrih_autorun.lua","LUA")) then table.insert(VJBASE_GETADDONS,"nmrih") end
if (file.Exists("autorun/vj_hud_autorun.lua","LUA")) then table.insert(VJBASE_GETADDONS,"vjhud") end
if (file.Exists("autorun/vj_zss_autorun.lua","LUA")) then table.insert(VJBASE_GETADDONS,"zss") end*/
//PrintTable(InstalledVJBaseAddons)
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_INSTALLATIONS(Panel)
	Panel:AddControl( "Label", {Text = "List of downloaded addons that use VJ Base"})
	Panel:ControlHelp("Version: "..VJBASE_VERSION) -- Main Number/Version/Quick Fixes
	Panel:ControlHelp("Total Addons: "..VJBASE_GETADDONAMOUNT)
	local CheckList = vgui.Create("DListView")
	CheckList:SetTooltip(false)
	//CheckList:Center() -- No need since Size does it already
	CheckList:SetSize( 100, 300 ) -- Size
	CheckList:SetMultiSelect(false)
	//CheckList.Paint = function()
	//draw.RoundedBox( 8, 0, 0, CheckList:GetWide(), CheckList:GetTall(), Color( 0, 0, 100, 255 ) )
	//end
	CheckList:AddColumn("Name") -- Add column
	CheckList:AddColumn("Type") -- Add colum
	----========----=========----
	// Alphabetical Order \\
	-- A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z --
	if VJBASE_GETADDONS != nil then
		for k,v in SortedPairsByMemberValue(VJBASE_GETADDONS,"Name") do
			CheckList:AddLine(v.Name,v.Type)
		end else
		CheckList:AddLine("No Addons Found","")
	end
	/*
	if table.KeyFromValue(VJBASE_GETADDONS, "aliensw") then CheckList:AddLine( "Alien Swarm","SNPC" ) end
	if table.KeyFromValue(VJBASE_GETADDONS, "bms") then CheckList:AddLine( "Black Mesa","SNPC" ) end
	if table.KeyFromValue(VJBASE_GETADDONS, "cof") then CheckList:AddLine( "Cry Of Fear","SNPC" ) end
	if table.KeyFromValue(VJBASE_GETADDONS, "dm") then CheckList:AddLine( "Dark Messiah","SNPC" ) end
	if table.KeyFromValue(VJBASE_GETADDONS, "eye") then CheckList:AddLine( "E.Y.E Divine Cybermancy","SNPC" ) end
	if table.KeyFromValue(VJBASE_GETADDONS, "fo3") then CheckList:AddLine( "Fallout 3","SNPC" ) end
	if table.KeyFromValue(VJBASE_GETADDONS, "halo2") then CheckList:AddLine( "Halo 2","SNPC" ) end
	if table.KeyFromValue(VJBASE_GETADDONS, "hl2snpc") then CheckList:AddLine( "Half Life 2","SNPC" ) end
	if table.KeyFromValue(VJBASE_GETADDONS, "kf") then CheckList:AddLine( "Killing Floor","SNPC" ) end
	if table.KeyFromValue(VJBASE_GETADDONS, "miliger") then CheckList:AddLine( "Military - Nazi Germany","SNPC" ) end
	if table.KeyFromValue(VJBASE_GETADDONS, "milisurg") then CheckList:AddLine( "Military - Insurgents","SNPC" ) end
	if table.KeyFromValue(VJBASE_GETADDONS, "nmrih") then CheckList:AddLine( "No More Room In Hell","SNPC" ) end
	if table.KeyFromValue(VJBASE_GETADDONS, "miliru") then CheckList:AddLine( "Military - Soviet Union","SNPC" ) end
	if table.KeyFromValue(VJBASE_GETADDONS, "milius") then CheckList:AddLine( "Military - United States","SNPC" ) end
	if table.KeyFromValue(VJBASE_GETADDONS, "vjhud") then CheckList:AddLine( "VJ HUD","HUD" ) end
	if table.KeyFromValue(VJBASE_GETADDONS, "zss") then CheckList:AddLine( "Zombie","SNPC" ) end
	*/
	//Panel:SetName("Test") -- Renames the blue label
	CheckList.OnRowSelected = function()
	surface.PlaySound(Sound("vj_illuminati/Illuminati Confirmed.mp3"))
	chat.AddText(Color(255,255,0),"-=-=-=-=-=-=-=-=- ", Color(255,100,0),VJBASE_GETNAME, Color(255,255,0)," -=-=-=-=-=-=-=-=-=-=-=-")
	chat.AddText(Color(0,255,0),"Version: "..VJBASE_VERSION)
	chat.AddText(Color(0,255,0),"Total Addons: "..VJBASE_GETADDONAMOUNT) end
	Panel:AddItem(CheckList)
	----========----=========----
	local changelog = vgui.Create("DButton") -- Changelog for VJ Base
	changelog:SetFont("TargetID")
	changelog:SetText("Changelog")
	changelog:SetSize(150,25)
	changelog:SetColor(Color(0,255,0,255))
	changelog.DoClick = function( changelog )
		gui.OpenURL("http://steamcommunity.com/sharedfiles/filedetails/changelog/131759821")
	end
	Panel:AddPanel(changelog)
	
	local ilovedrvrej = vgui.Create("DButton") -- I LOVE DRVREJ
	ilovedrvrej:SetFont("TargetID")
	ilovedrvrej:SetText("Do You Love DrVrej?")
	ilovedrvrej:SetSize(150, 25)
	ilovedrvrej:SetColor(Color(76,153,255,255))
	ilovedrvrej.DoClick = function(ilovedrvrej)
		//LocalPlayer():ConCommand("say I LOVE DRVREJ!")
		net.Start("VJSay")
		net.WriteEntity(LocalPlayer())
		net.WriteString("I LOVE DRVREJ!")
		net.WriteString("vj_illuminati/Illuminati Confirmed.mp3")
		net.SendToServer()
		//surface.PlaySound(Sound("vj_illuminati/Illuminati Confirmed.mp3"))
	end
	Panel:AddPanel(ilovedrvrej)
	
	if (LocalPlayer():SteamID() == "STEAM_0:0:22688298") then
		local lennyface = vgui.Create("DButton") -- *insert lenny face*
		lennyface:SetFont("TargetID")
		lennyface:SetText("I AM HERE")
		lennyface:SetSize(150, 25)
		lennyface:SetColor(Color(76,153,255,255))
		lennyface.DoClick = function(lennyface)
			net.Start("VJSay")
			net.WriteEntity(LocalPlayer())
			net.WriteString("The creator of VJ Base, DrVrej is in the server!")
			net.WriteString("vj_illuminati/Illuminati Confirmed.mp3")
			net.SendToServer()
		end
		Panel:AddPanel(lennyface)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_ADDTOMENU_INSTALLATIONS()
	spawnmenu.AddToolMenuOption("DrVrej", "VJ Base", "Installed Addons", "Installed Addons", "", "", VJ_INSTALLATIONS)
end
hook.Add( "PopulateToolMenu", "VJ_ADDTOMENU_INSTALLATIONS", VJ_ADDTOMENU_INSTALLATIONS )
---------------------------------------------------------------------------------------------------------------------------------------------
function VJWelcomeCode()
	print("Console: This server is running VJ Base.")
	chat.AddText(Color(255,255,0),"-=-=-=-=-=-=-=-=- ", Color(255,100,0),VJBASE_GETNAME.." - "..VJBASE_VERSION, Color(255,255,0)," -=-=-=-=-=-=-=-=-")
	chat.AddText(Color(0,255,0),"Total ", Color(0,255,0),"Addons: "..VJBASE_GETADDONAMOUNT)
	chat.AddText(Color(255,150,0),"NOTICE: ", Color(0,255,0),"To configure ", Color(255,100,0),VJBASE_GETNAME..", ", Color(0,255,0),"click on 'DrVrej' in the spawnmenu.")
	chat.AddText(Color(255,255,0),"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-")
end
concommand.Add("vj_welcome", VJWelcomeCode)
net.Receive("VJWelcome", VJWelcomeCode)
---------------------------------------------------------------------------------------------------------------------------------------------
concommand.Add("vj_iamhere", function(ply,cmd,args)
	local plynull = false
	local cansendmsg = false
	local plyid = NULL
	if ply == NULL then plynull = true end
	if plynull == false && ply:SteamID() == "STEAM_0:0:22688298" then cansendmsg = true plyid = ply end
	if IsValid(LocalPlayer()) && LocalPlayer():SteamID() == "STEAM_0:0:22688298" then cansendmsg = true plyid = LocalPlayer() end
	if cansendmsg == true then
		net.Start("VJSay")
		net.WriteEntity(plyid)
		net.WriteString("The creator of VJ Base, DrVrej is in the server!")
		net.WriteString("vj_illuminati/Illuminati Confirmed.mp3")
		net.SendToServer()
	end
end)