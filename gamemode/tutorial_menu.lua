function tutorialMenu(ply, cmd, args)

	if (inRaidSummaryMenu == false) then
		local helpMenu = vgui.Create("DFrame")

		helpMenu:SetSize(1000, 500)
		helpMenu:Center()
		helpMenu:SetBackgroundBlur(true)
		helpMenu:SetTitle("")
		helpMenu:SetDraggable(true)
		helpMenu:ShowCloseButton(true)
		helpMenu:SetDeleteOnClose(false)
		helpMenu.Paint = function()
			surface.SetDrawColor(90, 90, 90, 50)
			surface.DrawRect(0, 0, helpMenu:GetWide(), helpMenu:GetTall())

			surface.SetDrawColor(40, 40, 40, 50)
			surface.DrawRect(0, 24, helpMenu:GetWide(), 1)

			surface.SetTextColor(255, 255, 255, 255)
			surface.SetFont("Trebuchet24")
			surface.SetTextPos(10, 0)
			surface.DrawText("HELP")

			surface.SetTextColor(255, 255, 255, 255)
			surface.SetFont("CloseCaption_Bold")
			surface.SetTextPos(285, 75)
			surface.DrawText("Welcome to Escape From Garry's Mod!")

			surface.SetTextPos(40, 300)
			surface.DrawText("Enter Raids")

			surface.SetTextPos(250, 300)
			surface.DrawText("Find Loot")

			surface.SetTextPos(440, 300)
			surface.DrawText("Kill Others")

			surface.SetTextPos(660, 300)
			surface.DrawText("Extract")

			surface.SetTextPos(820, 300)
			surface.DrawText("Stash Your Loot")

			surface.SetTextPos(5, 450)
			surface.DrawText("Get Help")

			surface.SetTextPos(120, 450)
			surface.DrawText("Patch Notes")

			surface.SetTextPos(5, 475)
			surface.DrawText("Wipe Info")

			surface.SetTextPos(120, 475)
			surface.DrawText("Teasers")

			surface.SetTextPos(625, 450)
			surface.DrawText("Guide on every extract for all maps")
		end

		local enterImage = vgui.Create("DImage", Frame)
		enterImage:SetParent(helpMenu)
		enterImage:SetPos(25, 150)
		enterImage:SetSize(150, 150)
		enterImage:SetImage("tut/enter.png")

		local lootImage = vgui.Create("DImage", Frame)
		lootImage:SetParent(helpMenu)
		lootImage:SetPos(225, 150)
		lootImage:SetSize(150, 150)
		lootImage:SetImage("tut/loot.png")

		local pvpImage = vgui.Create("DImage", Frame)
		pvpImage:SetParent(helpMenu)
		pvpImage:SetPos(425, 150)
		pvpImage:SetSize(150, 150)
		pvpImage:SetImage("tut/pvp.png")

		local extractImage = vgui.Create("DImage", Frame)
		extractImage:SetParent(helpMenu)
		extractImage:SetPos(625, 150)
		extractImage:SetSize(150, 150)
		extractImage:SetImage("tut/extract.png")

		local stashImage = vgui.Create("DImage", Frame)
		stashImage:SetParent(helpMenu)
		stashImage:SetPos(825, 150)
		stashImage:SetSize(150, 150)
		stashImage:SetImage("tut/stash.png")

		gui.EnableScreenClicker(true)

		addAdButtons(helpMenu)

		inRaidSummaryMenu = true

		helpMenu.OnClose = function()
			if (inPlayerMenu == false) and (inMapVoteMenu == false) and (inStashMenu == false) then

				gui.EnableScreenClicker(false)
				surface.PlaySound("common/wpn_select.wav")
				inRaidSummaryMenu = false
				ply:SetNWBool("wipeFirstSpawn", false)

			else

				surface.PlaySound("common/wpn_select.wav")
				inRaidSummaryMenu = false
				ply:SetNWBool("wipeFirstSpawn", false)

			end
		end
	end
end
concommand.Add("open_tutorial_menu", tutorialMenu)

function addAdButtons(helpMenu)

    local serverButton = vgui.Create("DButton")
	serverButton:SetParent(helpMenu)
	serverButton:SetText("")
	serverButton:SetSize(200, 50)
	serverButton:SetPos(25, 400)
	serverButton.Paint = function()
		--Color of entire button
		surface.SetDrawColor(50, 50, 50, 255)
		surface.DrawRect(0, 0, serverButton:GetWide(), serverButton:GetTall())

		--Draw bottom and Right borders
		surface.SetDrawColor(40, 40, 40, 255)
		surface.DrawRect(0, 49, serverButton:GetWide(), 1)
		surface.DrawRect(199, 0, 1, serverButton:GetTall())

		--Draw/write text
		draw.DrawText("Discord", "Trebuchet24", serverButton:GetWide() / 2, 10, Color(255, 0, 255), 1)
    end

    serverButton.DoClick = function(serverButton)
		gui.OpenURL("https://discord.gg/GRfvt27uGF")
	end

	local extractButton = vgui.Create("DButton")
	extractButton:SetParent(helpMenu)
	extractButton:SetText("")
	extractButton:SetSize(200, 50)
	extractButton:SetPos(775, 400)
	extractButton.Paint = function()
		--Color of entire button
		surface.SetDrawColor(50, 50, 50, 255)
		surface.DrawRect(0, 0, extractButton:GetWide(), extractButton:GetTall())

		--Draw bottom and Right borders
		surface.SetDrawColor(40, 40, 40, 255)
		surface.DrawRect(0, 49, extractButton:GetWide(), 1)
		surface.DrawRect(199, 0, 1, extractButton:GetTall())

		--Draw/write text
		draw.DrawText("Extracts", "Trebuchet24", extractButton:GetWide() / 2, 10, Color(0, 255, 0), 1)
    end

    extractButton.DoClick = function(extractButton)
		gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=2799844989")
	end
end