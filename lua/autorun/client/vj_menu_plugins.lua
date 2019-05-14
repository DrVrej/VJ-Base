/*--------------------------------------------------
	=============== VJ Base Plugins ===============
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
if VJBASE_PLUGINS != nil then VJBASE_TOTALPLUGINS = table.Count(VJBASE_PLUGINS) else VJBASE_TOTALPLUGINS = 0 end
---------------------------------------------------------------------------------------------------------------------------------------------
-- Add the addons to the table --
	// Alphabetical Order \\
-- A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z --
/*if (file.Exists("autorun/vj_as_autorun.lua","LUA")) then table.insert(VJBASE_PLUGINS,"aliensw") end
if (file.Exists("autorun/vj_bms_autorun.lua","LUA")) then table.insert(VJBASE_PLUGINS,"bms") end
if (file.Exists("autorun/vj_cof_autorun.lua","LUA")) then table.insert(VJBASE_PLUGINS,"cof") end
if (file.Exists("autorun/vj_dms_autorun.lua","LUA")) then table.insert(VJBASE_PLUGINS,"dm") end
if (file.Exists("autorun/vj_eye_autorun.lua","LUA")) then table.insert(VJBASE_PLUGINS,"eye") end
if (file.Exists("autorun/vj_fo3_autorun.lua","LUA")) then table.insert(VJBASE_PLUGINS,"fo3") end
if (file.Exists("autorun/halo_autorun.lua","LUA")) then table.insert(VJBASE_PLUGINS,"halo2") end
if (file.Exists("autorun/vj_hl2_autorun.lua","LUA")) then table.insert(VJBASE_PLUGINS,"hl2snpc") end
if (file.Exists("autorun/vj_kf_autorun.lua","LUA")) then table.insert(VJBASE_PLUGINS,"kf") end
if (file.Exists("autorun/vj_miliru_autorun.lua","LUA")) then table.insert(VJBASE_PLUGINS,"miliru") end
if (file.Exists("autorun/vj_milius_autorun.lua","LUA")) then table.insert(VJBASE_PLUGINS,"milius") end
if (file.Exists("autorun/vj_milisurg_autorun.lua","LUA")) then table.insert(VJBASE_PLUGINS,"milisurg") end
if (file.Exists("autorun/vj_miliger_autorun.lua","LUA")) then table.insert(VJBASE_PLUGINS,"miliger") end
if (file.Exists("autorun/vj_nmrih_autorun.lua","LUA")) then table.insert(VJBASE_PLUGINS,"nmrih") end
if (file.Exists("autorun/vj_hud_autorun.lua","LUA")) then table.insert(VJBASE_PLUGINS,"vjhud") end
if (file.Exists("autorun/vj_zss_autorun.lua","LUA")) then table.insert(VJBASE_PLUGINS,"zss") end*/
//PrintTable(VJBASE_PLUGINS)
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_PLUGINS(Panel)
	Panel:AddControl( "Label", {Text = "List of downloaded addons that use VJ Base."})
	Panel:ControlHelp("Version: "..VJBASE_VERSION) -- Main Number/Version/Quick Fixes
	Panel:ControlHelp("Total Plugins: "..VJBASE_TOTALPLUGINS)
	local CheckList = vgui.Create("DListView")
	CheckList:SetTooltip(false)
	//CheckList:Center() -- No need since Size does it already
	CheckList:SetSize(100, 300) -- Size
	CheckList:SetMultiSelect(false)
	//CheckList.Paint = function()
	//draw.RoundedBox( 8, 0, 0, CheckList:GetWide(), CheckList:GetTall(), Color( 0, 0, 100, 255 ) )
	//end
	CheckList:AddColumn("Name") -- Add column
	CheckList:AddColumn("Type") -- Add colum
	----========----=========----
	// Alphabetical Order \\
	-- A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z --
	if VJBASE_PLUGINS != nil then
		for k,v in SortedPairsByMemberValue(VJBASE_PLUGINS,"Name") do
			CheckList:AddLine(v.Name,v.Type)
		end else
		CheckList:AddLine("No Plugins Found","")
	end
	/*
	if table.KeyFromValue(VJBASE_PLUGINS, "aliensw") then CheckList:AddLine( "Alien Swarm","SNPC" ) end
	if table.KeyFromValue(VJBASE_PLUGINS, "bms") then CheckList:AddLine( "Black Mesa","SNPC" ) end
	if table.KeyFromValue(VJBASE_PLUGINS, "cof") then CheckList:AddLine( "Cry Of Fear","SNPC" ) end
	if table.KeyFromValue(VJBASE_PLUGINS, "dm") then CheckList:AddLine( "Dark Messiah","SNPC" ) end
	if table.KeyFromValue(VJBASE_PLUGINS, "eye") then CheckList:AddLine( "E.Y.E Divine Cybermancy","SNPC" ) end
	if table.KeyFromValue(VJBASE_PLUGINS, "fo3") then CheckList:AddLine( "Fallout 3","SNPC" ) end
	if table.KeyFromValue(VJBASE_PLUGINS, "halo2") then CheckList:AddLine( "Halo 2","SNPC" ) end
	if table.KeyFromValue(VJBASE_PLUGINS, "hl2snpc") then CheckList:AddLine( "Half Life 2","SNPC" ) end
	if table.KeyFromValue(VJBASE_PLUGINS, "kf") then CheckList:AddLine( "Killing Floor","SNPC" ) end
	if table.KeyFromValue(VJBASE_PLUGINS, "miliger") then CheckList:AddLine( "Military - Nazi Germany","SNPC" ) end
	if table.KeyFromValue(VJBASE_PLUGINS, "milisurg") then CheckList:AddLine( "Military - Insurgents","SNPC" ) end
	if table.KeyFromValue(VJBASE_PLUGINS, "nmrih") then CheckList:AddLine( "No More Room In Hell","SNPC" ) end
	if table.KeyFromValue(VJBASE_PLUGINS, "miliru") then CheckList:AddLine( "Military - Soviet Union","SNPC" ) end
	if table.KeyFromValue(VJBASE_PLUGINS, "milius") then CheckList:AddLine( "Military - United States","SNPC" ) end
	if table.KeyFromValue(VJBASE_PLUGINS, "vjhud") then CheckList:AddLine( "VJ HUD","HUD" ) end
	if table.KeyFromValue(VJBASE_PLUGINS, "zss") then CheckList:AddLine( "Zombie","SNPC" ) end
	*/
	//Panel:SetName("Test") -- Renames the blue label
	CheckList.OnRowSelected = function()
	surface.PlaySound(Sound("vj_illuminati/Illuminati Confirmed.mp3"))
	chat.AddText(Color(255,255,0),"-=-=-=-=-=-=-=-=- ", Color(255,100,0),VJBASE_GETNAME, Color(255,255,0)," -=-=-=-=-=-=-=-=-=-=-=-")
	chat.AddText(Color(0,255,0),"Version: "..VJBASE_VERSION)
	chat.AddText(Color(0,255,0),"Total Plugins: "..VJBASE_TOTALPLUGINS) end
	Panel:AddItem(CheckList)
	----========----=========----
	local changelog = vgui.Create("DButton") -- Changelog for VJ Base
	changelog:SetFont("TargetID")
	changelog:SetText("Changelog")
	changelog:SetSize(150,25)
	changelog:SetColor(Color(39, 174, 96, 255))
	changelog.DoClick = function(changelog)
		gui.OpenURL("http://steamcommunity.com/sharedfiles/filedetails/changelog/131759821")
	end
	Panel:AddPanel(changelog)
	
	local github = vgui.Create("DButton") -- Github
	github:SetFont("TargetID")
	github:SetText("Want to make an addon? Click Here!")
	github:SetSize(150,25)
	github:SetColor(Color(52, 152, 219, 255))
	github.DoClick = function(github)
		gui.OpenURL("https://github.com/DrVrej/VJ-Base/wiki")
	end
	Panel:AddPanel(github)
	
	if (LocalPlayer():SteamID() == "STEAM_0:0:22688298") then
		local lennyface = vgui.Create("DButton") -- *insert lenny face* ¯\_(?)_/¯
		lennyface:SetFont("TargetID")
		lennyface:SetText("I AM HERE")
		lennyface:SetSize(150, 25)
		lennyface:SetColor(Color(52, 152, 219, 255))
		lennyface.DoClick = function(lennyface)
			net.Start("VJSay")
			net.SendToServer()
		end
		Panel:AddPanel(lennyface)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PopulateToolMenu", "VJ_ADDTOMENU_INSTALLATIONS", function()
	spawnmenu.AddToolMenuOption("DrVrej", "Main Menu", "Installed Plugins", "Installed Plugins", "", "", VJ_PLUGINS)
end)
---------------------------------------------------------------------------------------------------------------------------------------------
function VJWelcomeCode()
	print("Notice: This server is running VJ Base.")

	-- Yete inen ver e, ere vor 0 ten e
	local amt = VJBASE_TOTALPLUGINS
    if amt <= 9 then
		amt = "0"..tostring(amt)
	else
		amt = tostring(amt)
	end
    local ra = "<"
	local la = ">"
    local dashes = ""
	for i= 1,29 do dashes = dashes.."-" end
    
    chat.AddText(Color(255,215,0),"|"..dashes..la, Color(0,255,255), " "..VJBASE_GETNAME.." ", Color(30,200,255), VJBASE_VERSION.." ", Color(255,215,0), ra..dashes.."|")
    chat.AddText(Color(255,215,0),"|- ", Color(255,255,0),"NOTICE! ", Color(255,255,255), "To configure ", Color(0,255,255), VJBASE_GETNAME.." ", Color(255,255,255), " click on ", Color(0,255,255), "DrVrej", Color(255,255,255)," in the spawn menu! ", Color(255,215,0),"-|")
    chat.AddText(Color(255,215,0),"|"..dashes..la, Color(30,200,255), " "..amt, Color(0,255,255), " VJ Plugins ", Color(255,215,0), ra..dashes.."|")

	//chat.AddText(Color(255,255,0),"-=-=-=-=-=-=-=- ", Color(0,200,200), VJBASE_GETNAME.." - "..VJBASE_VERSION, Color(0,255,0), " ("..VJBASE_TOTALPLUGINS.." VJ Addons)",Color(255,255,0)," -=-=-=-=-=-=-=-")
	//chat.AddText(Color(255,150,0),"NOTICE: ", Color(0,255,0),"To configure ", Color(0,200,200),VJBASE_GETNAME..", ", Color(0,255,0),"click on 'DrVrej' in the spawnmenu.")
	//chat.AddText(Color(255,255,0),"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-")
end
concommand.Add("vj_welcome", VJWelcomeCode)
net.Receive("VJWelcome", VJWelcomeCode)
---------------------------------------------------------------------------------------------------------------------------------------------
concommand.Add("vj_iamhere", function(ply,cmd,args)
	net.Start("VJSay")
	net.SendToServer()
end)