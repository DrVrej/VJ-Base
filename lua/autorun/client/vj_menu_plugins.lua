/*--------------------------------------------------
	=============== VJ Base Plugins ===============
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end

if VJBASE_PLUGINS != nil then VJBASE_TOTALPLUGINS = table.Count(VJBASE_PLUGINS) else VJBASE_TOTALPLUGINS = 0 end
//PrintTable(VJBASE_PLUGINS)
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_PLUGINS(Panel)
	Panel:AddControl("Label", {Text = "#vjbase.menu.plugins.label"})
	Panel:ControlHelp(language.GetPhrase("#vjbase.menu.plugins.version").." "..VJBASE_VERSION) -- Main Number / Version / Patches
	Panel:ControlHelp(language.GetPhrase("#vjbase.menu.plugins.totalplugins").." "..VJBASE_TOTALPLUGINS)
	
	local CheckList = vgui.Create("DListView")
	CheckList:SetTooltip(false)
	//CheckList:Center() -- No need since Size does it already
	CheckList:SetSize(100, 300) -- Size
	CheckList:SetMultiSelect(false)
	CheckList:AddColumn("#vjbase.menu.plugins.header1") -- Add column
	CheckList:AddColumn("#vjbase.menu.plugins.header2"):SetFixedWidth(50) -- Add column
	//Panel:SetName("Test") -- Renames the blue label
	if VJBASE_PLUGINS != nil then
		for _,v in SortedPairsByMemberValue(VJBASE_PLUGINS,"Name") do
			CheckList:AddLine(v.Name,v.Type)
		end
	else
		CheckList:AddLine("#vjbase.menu.plugins.notfound","")
	end
	CheckList.OnRowSelected = function()
		surface.PlaySound(Sound("vj_illuminati/Illuminati Confirmed.mp3"))
		chat.AddText(Color(255,255,0),"-=-=-=-=-=-=-=-=- ", Color(255,100,0),VJBASE_GETNAME, Color(255,255,0)," -=-=-=-=-=-=-=-=-")
		chat.AddText(Color(0,255,0), language.GetPhrase("#vjbase.menu.plugins.version").." "..VJBASE_VERSION)
		chat.AddText(Color(0,255,0), language.GetPhrase("#vjbase.menu.plugins.totalplugins").." "..VJBASE_TOTALPLUGINS)
	end
	Panel:AddItem(CheckList)
	
	-- Changelog for VJ Base
	local changelog = vgui.Create("DButton")
	changelog:SetFont("TargetID")
	changelog:SetText("#vjbase.menu.plugins.changelog")
	changelog:SetSize(150, 25)
	changelog:SetColor(Color(0, 102, 0))
	changelog:SetFont("VJFont_Trebuchet24_SmallMedium")
	changelog.DoClick = function(x)
		gui.OpenURL("http://steamcommunity.com/sharedfiles/filedetails/changelog/131759821")
	end
	Panel:AddPanel(changelog)
	
	-- Github
	local github = vgui.Create("DButton")
	github:SetFont("TargetID")
	github:SetText("#vjbase.menu.plugins.makeaddon")
	github:SetSize(150, 25)
	github:SetColor(Color(0, 0, 102))
	github:SetFont("VJFont_Trebuchet24_SmallMedium")
	github.DoClick = function(x)
		gui.OpenURL("https://github.com/DrVrej/VJ-Base/wiki")
	end
	Panel:AddPanel(github)
	
	-- *insert lenny face*
	if (LocalPlayer():SteamID() == "STEAM_0:0:22688298") then
		local lennyface = vgui.Create("DButton")
		lennyface:SetFont("TargetID")
		lennyface:SetText("HELLO")
		lennyface:SetSize(150, 25)
		lennyface:SetColor(Color(0, 0, 102))
		lennyface:SetFont("VJFont_Trebuchet24_SmallMedium")
		lennyface.DoClick = function(x)
			net.Start("VJSay")
			net.SendToServer()
		end
		Panel:AddPanel(lennyface)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PopulateToolMenu", "VJ_ADDTOMENU_INSTALLATIONS", function()
	spawnmenu.AddToolMenuOption("DrVrej", "Main Menu", "Installed Plugins", "#vjbase.menu.plugins", "", "", VJ_PLUGINS)
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
	for _ = 1,28 do dashes = dashes.."-" end
    
    chat.AddText(Color(255,215,0),"|"..dashes..la, Color(0,255,255), " "..VJBASE_GETNAME.." ", Color(30,200,255), VJBASE_VERSION.." ", Color(255,215,0), ra..dashes.."|")
    chat.AddText(Color(255,215,0),"|- ", Color(255,255,0),"NOTICE! ", Color(255,255,255), "To configure ", Color(0,255,255), VJBASE_GETNAME.." ", Color(255,255,255), "click on ", Color(0,255,255), "DrVrej", Color(255,255,255)," in the spawn menu! ", Color(255,215,0),"-|")
    //chat.AddText(Color(255,215,0),"|"..dashes..la, Color(30,200,255), " "..amt, Color(0,255,255), " VJ Plugins ", Color(255,215,0), ra..dashes.."|")

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