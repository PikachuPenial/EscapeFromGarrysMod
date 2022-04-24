function raidSummaryMenu(ply, cmd, args)

	if (inRaidSummaryMenu == false) then
		local SummaryMenu = vgui.Create("DFrame")

		--if (ply:GetNWInt("raidSuccess") == 0) then
		--	SummaryMenu:SetSize(500, 400)
		--else
		--	SummaryMenu:SetSize(250, 400)
		--end

		SummaryMenu:SetSize(250, 400)
		SummaryMenu:Center()
		SummaryMenu:SetBackgroundBlur(true)
		SummaryMenu:SetTitle("")
		SummaryMenu:SetDraggable(true)
		SummaryMenu:ShowCloseButton(true)
		SummaryMenu:SetDeleteOnClose(false)
		SummaryMenu.Paint = function()
			surface.SetDrawColor(90, 90, 90, 50)
			surface.DrawRect(0, 0, SummaryMenu:GetWide(), SummaryMenu:GetTall())

			surface.SetDrawColor(40, 40, 40, 50)
			surface.DrawRect(0, 24, SummaryMenu:GetWide(), 1)

			surface.SetTextColor(255, 255, 255, 255)
			surface.SetFont("Trebuchet24")
			surface.SetTextPos(10, 0)
			surface.DrawText("RAID SUMMARY")

			surface.SetTextColor(255, 255, 255, 255)
			surface.SetFont("Trebuchet24")
			surface.SetTextPos(95, 50)
			surface.DrawText(LocalPlayer():GetName())

			local Avatar = vgui.Create("AvatarImage", SummaryMenu)
			Avatar:SetSize(100, 100)
			Avatar:SetPos(75, 75)
			Avatar:SetPlayer(LocalPlayer(), 64)

			-- Stats for the raid

			surface.SetTextColor(255, 255, 255, 255)
			surface.SetFont("Trebuchet24")
			surface.SetTextPos(20, 220)
			surface.DrawText("Raid Stats:")

			surface.SetTextColor(255, 255, 255, 255)
			surface.SetFont("Trebuchet24")

			surface.SetTextPos(20, 250)
			surface.DrawText("Kills: " .. LocalPlayer():GetNWInt("raidKill"))

			surface.SetTextPos(20, 275)
			surface.DrawText("XP Earned:" .. LocalPlayer():GetNWInt("raidXP"))

			surface.SetTextPos(20, 300)
			surface.DrawText("Money Earned: " .. LocalPlayer():GetNWInt("raidMoney"))

			surface.SetTextPos(20, 325)
			surface.DrawText("Damage Inflicted: " .. LocalPlayer():GetNWInt("raidDamageGiven"))

			surface.SetTextPos(20, 350)
			surface.DrawText("Damage Taken: " .. LocalPlayer():GetNWInt("raidDamageTaken"))
		end

		if (ply:GetNWInt("raidSuccess") == 1) then
			surface.PlaySound("taskfinished.wav")
		else
			surface.PlaySound("taskfailed.wav")
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
concommand.Add("open_raid_summary_menu", raidSummaryMenu)