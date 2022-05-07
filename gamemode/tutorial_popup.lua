function tutorialMenu(ply, cmd, args)

	if (tutorialMenu == false) then
		local tutorialPopup = vgui.Create("DFrame")

		tutorialPopup:SetSize(250, 500)
		tutorialPopup:Center()
		tutorialPopup:SetBackgroundBlur(true)
		tutorialPopup:SetTitle("")
		tutorialPopup:SetDraggable(true)
		tutorialPopup:ShowCloseButton(true)
		tutorialPopup:SetDeleteOnClose(false)
		tutorialPopup.Paint = function()
			surface.SetDrawColor(90, 90, 90, 50)
			surface.DrawRect(0, 0, tutorialPopup:GetWide(), tutorialPopup:GetTall())

			surface.SetDrawColor(40, 40, 40, 50)
			surface.DrawRect(0, 24, tutorialPopup:GetWide(), 1)

			surface.SetTextColor(255, 255, 255, 255)
			surface.SetFont("Trebuchet24")
			surface.SetTextPos(95, 50)
			surface.DrawText(LocalPlayer():GetName())

			-- Stats for the raid

			surface.SetTextColor(255, 255, 255, 255)
			surface.SetFont("Trebuchet24")
			surface.SetTextPos(20, 220)
			surface.DrawText("Raid Stats:")
		end

		gui.EnableScreenClicker(true)

		inRaidSummaryMenu = true

		SummaryMenu.OnClose = function()
			if (inPlayerMenu == false) and (inMapVoteMenu == false) and (inStashMenu == false) then

				gui.EnableScreenClicker(false)
				surface.PlaySound( "common/wpn_select.wav" )
				inRaidSummaryMenu = false

			else

				surface.PlaySound( "common/wpn_select.wav" )
				inRaidSummaryMenu = false

			end
		end
	end
end
concommand.Add("open_tutorial", tutorialMenu)