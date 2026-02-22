/*--------------------------------------------------
	** VJ Base Dependency Check **
	Last Updated: Feb-22-2026

	Notes:
	- Verifies that VJ Base is installed.
	- Do not modify its contents to maintain compatibility.
	- The file name is irrelevant and can be changed.
	- Ensure it matches the latest version from the VJ Base GitHub repository.
--------------------------------------------------*/
if VJBASE_INSTALLED_CHECK then return end
VJBASE_INSTALLED_CHECK = true

hook.Add("InitPostEntity", "VJBASE_INSTALLED_CHECK", function()
	timer.Simple(1, function()
		if not VJBASE_INSTALLED and not VJBASE_ERROR_MISSING then
			VJBASE_ERROR_MISSING = true
			if CLIENT then
				if VJF and type(VJF) == "Panel" then VJF:Close() end; VJF = true -- Delete errors from outdated plugins
				
				local frame = vgui.Create("DFrame")
				frame:SetSize(320, 160)
				frame:Center()
				frame:SetTitle("Missing Dependency: VJ Base")
				frame:SetBackgroundBlur(true)
				frame:DockPadding(12, 34, 12, 12)
				frame:MakePopup()
				
				local panel = vgui.Create("DPanel", frame)
				panel:Dock(FILL)
				panel:SetPaintBackground(false)
				
				local labelTitle = vgui.Create("DLabel", panel)
				labelTitle:Dock(TOP)
				labelTitle:SetText("VJ BASE REQUIRED")
				labelTitle:SetTextColor(Color(255, 128, 128))
				labelTitle:SetFont("DermaLarge")
				labelTitle:SetContentAlignment(5)
				labelTitle:SetTall(30)
				
				local labelBody = vgui.Create("DLabel", panel)
				labelBody:Dock(TOP)
				labelBody:SetText(" One or more installed mods require VJ Base, but it is missing.\n                     Install VJ Base using the link below.\nAfter installation, ensure it is enabled and restart your game.")
				labelBody:SetContentAlignment(5)
				labelBody:SetAutoStretchVertical(true)
				
				local buttonWorkshop = vgui.Create("DButton", panel)
				buttonWorkshop:Dock(LEFT)
				buttonWorkshop:DockMargin(10, 8, 10, 0)
				buttonWorkshop:SetFont("DermaDefaultBold")
				buttonWorkshop:SetText("WORKSHOP PAGE")
				buttonWorkshop:SetWide(120)
				buttonWorkshop:SetTall(35)
				function buttonWorkshop:DoClick()
					gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=131759821")
				end
				
				local buttonClose = vgui.Create("DButton", panel)
				buttonClose:Dock(RIGHT)
				buttonClose:DockMargin(10, 8, 10, 0)
				buttonClose:SetFont("DermaDefaultBold")
				buttonClose:SetText("CLOSE")
				buttonClose:SetWide(120)
				buttonClose:SetTall(35)
				function buttonClose:DoClick()
					frame:Close()
				end
			elseif SERVER then
				timer.Remove("VJBASEMissing"); VJF = true -- Delete errors from outdated plugins
				MsgC(Color(255, 165, 0), "Missing dependency: VJ Base. ", Color(255, 255, 255), "Install it from the Steam Workshop: ", Color(100, 200, 255), "https://steamcommunity.com/sharedfiles/filedetails/?id=131759821\n")
			end
		end
	end)
end)