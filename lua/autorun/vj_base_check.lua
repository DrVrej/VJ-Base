/*--------------------------------------------------
Checks if VJ Base is installed.
	- File name can be kept as is and don't edit this file.
	- Check the VJ Base GitHub dummy branch to make sure this file is up-to-date.
--------------------------------------------------*/
if VJBASE_INSTALLED_CHECK then return end
VJBASE_INSTALLED_CHECK = true

hook.Add("InitPostEntity", "VJBASE_INSTALLED_CHECK", function()
	timer.Simple(1, function()
		if not VJBASE_INSTALLED and not VJBASE_ERROR_MISSING then
			VJBASE_ERROR_MISSING = true
			if CLIENT then
				if VJF and type(VJF) == "Panel" then VJF:Close() end; VJF = true -- Delete error messages from outdated plugins
				
				local frame = vgui.Create("DFrame")
				frame:SetSize(600, 160)
				frame:SetPos((ScrW() - frame:GetWide()) / 2, (ScrH() - frame:GetTall()) / 2)
				frame:SetTitle("Error: VJ Base is missing!")
				frame:SetBackgroundBlur(true)
				frame:MakePopup()

				local labelTitle = vgui.Create("DLabel", frame)
				labelTitle:SetPos(250, 30)
				labelTitle:SetText("VJ BASE IS MISSING!")
				labelTitle:SetTextColor(Color(255, 128, 128))
				labelTitle:SizeToContents()
				
				local label1 = vgui.Create("DLabel", frame)
				label1:SetPos(170, 50)
				label1:SetText("Garry's Mod was unable to find VJ Base in your files!")
				label1:SizeToContents()
				
				local label2 = vgui.Create("DLabel", frame)
				label2:SetPos(10, 70)
				label2:SetText("You have an addon installed that requires VJ Base but VJ Base is missing. To install VJ Base, click on the link below. Once\n                                                   installed, make sure it is enabled and then restart your game.")
				label2:SizeToContents()
				
				local link = vgui.Create("DLabelURL", frame)
				link:SetSize(300, 20)
				link:SetPos(195, 100)
				link:SetText("VJ_Base_Download_Link_(Steam_Workshop)")
				link:SetURL("https://steamcommunity.com/sharedfiles/filedetails/?id=131759821")
				
				local buttonClose = vgui.Create("DButton", frame)
				buttonClose:SetText("CLOSE")
				buttonClose:SetPos(260, 120)
				buttonClose:SetSize(80, 35)
				buttonClose.DoClick = function()
					frame:Close()
				end
			elseif SERVER then
				timer.Remove("VJBASEMissing"); VJF = true -- Delete error messages from outdated plugins
				timer.Create("VJBASE_ERROR_MISSING", 5, 0, function()
					print("VJ Base is missing! Download it from the Steam Workshop! --> https://steamcommunity.com/sharedfiles/filedetails/?id=131759821")
				end)
			end
		end
	end)
end)