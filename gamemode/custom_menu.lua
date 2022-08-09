local Menu

local isSellMenu = false
local clientPlayer

local isPlayerInRaid = false

local stashClient

local stashTable

if ScrH() <= 720 then
	below720 = true
else
	below720 = false
end

net.Receive("SendTaskInfo",function (len, ply)

	local taskInfo = net.ReadTable()

	PrintTable(taskInfo)

	Menu:Hide()
	Menu:Show()

	DrawTasks(taskInfo)

end)

net.Receive("MenuInRaid",function (len, ply)

	isPlayerInRaid = net.ReadBool()

end)

net.Receive("OpenSellMenu",function(len, ply)

	OpenSellMenu()

end)

net.Receive("OpenStashGUI",function (len, ply)

	tempTable = net.ReadTable()

	stashClient = tempTable[1]

	MenuInit()
	DoInventory()

end)

net.Receive("CloseStashGUI",function (len, ply)

	StashMenu:Close()

end)

net.Receive("SendStash",function (len, ply)

	stashTable = net.ReadTable()

	ShowStashTable()

end)

net.Receive("StashMenuReload", function (len, ply) ResetMenu() end)

function gameShopMenu(ply, cmd, args)

	-- This part just makes sure the client is the one viewing the hud. This is so some logic can work, it's complicated.

	local client = LocalPlayer()

	if not client:Alive() then return end

	-- Moving on

	if (inPlayerMenu == false) then
		Menu = vgui.Create("DFrame")

		if below720 == true then
			Menu:SetSize(800, 720)
		else
			Menu:SetSize(800, 768)
		end

		Menu:Center()
		Menu:SetTitle("Escape From Garry's Mod")
		Menu:SetDraggable(false)
		Menu:ShowCloseButton(true)
		Menu:SetDeleteOnClose(false)
		Menu:MakePopup()
		Menu.Paint = function()
			surface.SetDrawColor(90, 90, 90, 50)
			surface.DrawRect(0, 0, Menu:GetWide(), Menu:GetTall())

			surface.SetDrawColor(40, 40, 40, 50)
			surface.DrawRect(0, 24, Menu:GetWide(), 1)
		end

		addButtons(Menu, isSellMenu, isPlayerInRaid, clientPlayer)

		inPlayerMenu = true

		gui.EnableScreenClicker(true)
		surface.PlaySound("common/wpn_select.wav")

		Menu.OnClose = function()

			if (inStashMenu == false) and (inMapVoteMenu == false) and (inRaidSummaryMenu == false) then
				inPlayerMenu = false

				gui.EnableScreenClicker(false)
				surface.PlaySound("common/wpn_denyselect.wav")

				inPlayerMenu = false

				clientPlayer = nil
				isSellMenu = false
				seller = nil
			else
				surface.PlaySound("common/wpn_denyselect.wav")

				inPlayerMenu = false

				clientPlayer = nil
				isSellMenu = false
				seller = nil
			end
		end
	end
end
concommand.Add("open_game_menu", gameShopMenu)

--Button Code
function addButtons(Menu, sellMenuBool, menuInRaid, ply)

	--print("isSellMenu is "..tostring(isSellMenu))

	local playerButton = vgui.Create("DButton")
	playerButton:SetParent(Menu)
	playerButton:SetText("")
	playerButton:SetSize(100, 50)
	playerButton:SetPos(0, 25)
	playerButton.Paint = function()
		--Color of entire button
		surface.SetDrawColor(50, 50, 50, 255)
		surface.DrawRect(0, 0, playerButton:GetWide(), playerButton:GetTall())

		--Draw bottom and Right borders
		surface.SetDrawColor(40, 40, 40, 255)
		surface.DrawRect(0, 49, playerButton:GetWide(), 1)
		surface.DrawRect(99, 0, 1, playerButton:GetTall())

		--Draw/write text
		draw.DrawText("STATS", "DermaLarge", playerButton:GetWide() / 2.1, 10, Color(255, 255, 255, 255), 1)
	end

	playerButton.DoClick = function()
		local playerPanel = Menu:Add("PlayerPanel")

		local whiteColor = 		Color(250, 250, 250, 255)
		local primaryColor =	Color(30, 30, 30, 255)
		local secondaryColor =	Color(100, 100, 100, 255)

		local margin = 			math.Round( ScrH() * 0.01 )

		local kdResetText = 0
		local srResetText = 0

		playerPanel.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, primaryColor)
		end

		local scrollPanel = vgui.Create("DScrollPanel", playerPanel)
		scrollPanel:Dock(FILL)

		local namePanel = vgui.Create("DPanel", scrollPanel)
		namePanel:Dock(TOP)
		namePanel:DockMargin(margin, margin, margin, margin)
		namePanel:SetSize(0, 90)

		namePanel.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, secondaryColor)
			local expToLevel = (LocalPlayer():GetNWInt("playerLvl") * 140) * 5.15

			draw.SimpleText(LocalPlayer():GetName(), "CloseCaption_Bold", w / 2, 15, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			draw.SimpleText("Prestige " .. LocalPlayer():GetNWInt("playerPrestige") .. ", " .. "Level " .. LocalPlayer():GetNWInt("playerLvl"), "CloseCaption_Bold", w / 2, 35, Color(228, 255, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("Experience: " .. math.Round(LocalPlayer():GetNWInt("playerExp")) .. "/" .. expToLevel, "CloseCaption_Bold", w / 2, 55, Color(0, 255, 209 , 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("Roubles: ₽" .. math.Round(LocalPlayer():GetNWInt("playerMoney")), "CloseCaption_Bold", w / 2, 75, Color(255, 0, 95), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		local personalStatsPanel = vgui.Create("DPanel", scrollPanel)
		personalStatsPanel:Dock(TOP)
		personalStatsPanel:DockMargin(margin, margin, margin, margin)
		personalStatsPanel:SetSize(0, 355)

		personalStatsPanel.Paint = function(self, w, h)

			draw.RoundedBox(0, 0, 0, w, h, secondaryColor)
			draw.SimpleText("General Statistics", "DermaLarge", w / 2, 10, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

			draw.SimpleText("Total Kills: " .. LocalPlayer():GetNWInt("playerKills"), "CloseCaption_Bold", w / 2, 40, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText("Total Deaths: " .. LocalPlayer():GetNWInt("playerDeaths"), "CloseCaption_Bold", w / 2, 60, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText("K/D Ratio: " .. math.Round(LocalPlayer():GetNWInt("playerKDR"), 2), "CloseCaption_Bold", w / 2, 80, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText("Total Roubles Earned: ₽" .. LocalPlayer():GetNWInt("playerTotalEarned"), "CloseCaption_Bold", w / 2, 100, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText("Roubles Earned From Kills: ₽" .. LocalPlayer():GetNWInt("playerTotalEarnedKill"), "CloseCaption_Bold", w / 2, 120, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText("Roubles Earned From Selling: ₽" .. LocalPlayer():GetNWInt("playerTotalEarnedSell"), "CloseCaption_Bold", w / 2, 140, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText("Total EXP Gained: " .. math.Round(LocalPlayer():GetNWInt("playerTotalXpEarned"), 0), "CloseCaption_Bold", w / 2, 160, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText("EXP Gained From Kills: " .. math.Round(LocalPlayer():GetNWInt("playerTotalXpEarnedKill"), 0), "CloseCaption_Bold", w / 2, 180, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText("EXP Gained From Extracting: " .. math.Round(LocalPlayer():GetNWInt("playerTotalXpEarnedExplore"), 0), "CloseCaption_Bold", w / 2, 200, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText("Total Money Spent: ₽" .. LocalPlayer():GetNWInt("playerTotalMoneySpent"), "CloseCaption_Bold", w / 2, 220, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText("Money Spent On Weapons: ₽" .. LocalPlayer():GetNWInt("playerTotalMoneySpentWep"), "CloseCaption_Bold", w / 2, 240, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText("Money Spent On Ammo & Armor: ₽" .. LocalPlayer():GetNWInt("playerTotalMoneySpentItem"), "CloseCaption_Bold", w / 2, 260, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText("Deaths By Suicide: " .. LocalPlayer():GetNWInt("playerDeathsSuicide"), "CloseCaption_Bold", w / 2, 280, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText("Damage Inflicted: " .. LocalPlayer():GetNWInt("playerDamageGiven"), "CloseCaption_Bold", w / 2, 300, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText("Damage Received: " .. LocalPlayer():GetNWInt("playerDamageRecieved"), "CloseCaption_Bold", w / 2, 320, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end

		local raidingStatsPanel = vgui.Create("DPanel", scrollPanel)
		raidingStatsPanel:Dock(TOP)
		raidingStatsPanel:DockMargin(margin, margin, margin, margin)
		raidingStatsPanel:SetSize(0, 160)

		raidingStatsPanel.Paint = function(self, w, h)

			draw.RoundedBox(0, 0, 0, w, h, secondaryColor)
			draw.SimpleText("Raiding Statistics", "DermaLarge", w / 2, 10, Color(50, 255, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

			draw.SimpleText("Survival Rate: " .. math.Round(LocalPlayer():GetNWInt("survivalRate"), 0) .. "%", "CloseCaption_Bold", w / 2, 40, Color(50, 255, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText("Raids Played: " .. LocalPlayer():GetNWInt("raidsPlayed"), "CloseCaption_Bold", w / 2, 60, Color(50, 255, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText("Extractions: " .. LocalPlayer():GetNWInt("raidsExtracted"), "CloseCaption_Bold", w / 2, 80, Color(50, 255, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText("Run Throughs: " .. LocalPlayer():GetNWInt("raidsRanThrough"), "CloseCaption_Bold", w / 2, 100, Color(50, 255, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText("Killed In Actions: " .. LocalPlayer():GetNWInt("raidsDied"), "CloseCaption_Bold", w / 2, 120, Color(50, 255, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end

		local pvpStatsPanel = vgui.Create("DPanel", scrollPanel)
		pvpStatsPanel:Dock(TOP)
		pvpStatsPanel:DockMargin(margin, margin, margin, margin)
		pvpStatsPanel:SetSize(0, 160)

		pvpStatsPanel.Paint = function(self, w, h)

			draw.RoundedBox(0, 0, 0, w, h, secondaryColor)
			draw.SimpleText("PvP Statistics", "DermaLarge", w / 2, 10, Color(255, 160, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

			draw.SimpleText("AVG Kills Per Raid: " .. math.Round(LocalPlayer():GetNWInt("killsPerRaid"), 2), "CloseCaption_Bold", w / 2, 40, Color(255, 160, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText("Current Kill Streak: " .. LocalPlayer():GetNWInt("killStreak"), "CloseCaption_Bold", w / 2, 60, Color(255, 160, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText("Current Extract Streak: " .. LocalPlayer():GetNWInt("extractionStreak"), "CloseCaption_Bold", w / 2, 80, Color(255, 160, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText("Highest Kill Streak: " .. LocalPlayer():GetNWInt("highestKillStreak"), "CloseCaption_Bold", w / 2, 100, Color(255, 160, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText("Highest Extract Streak: " .. LocalPlayer():GetNWInt("highestExtractionStreak"), "CloseCaption_Bold", w / 2, 120, Color(255, 160, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end

		local taskingStatsPanel = vgui.Create("DPanel", scrollPanel)
		taskingStatsPanel:Dock(TOP)
		taskingStatsPanel:DockMargin(margin, margin, margin, margin)
		taskingStatsPanel:SetSize(0, 120)

		taskingStatsPanel.Paint = function(self, w, h)

			draw.RoundedBox(0, 0, 0, w, h, secondaryColor)
			draw.SimpleText("Tasking Statistics", "DermaLarge", w / 2, 10, Color(255, 0, 95), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

			draw.SimpleText("Total Tasks Finished: " .. LocalPlayer():GetNWInt("dailiesCompleted") + LocalPlayer():GetNWInt("specialsCompleted"), "CloseCaption_Bold", w / 2, 40, Color(255, 0, 95), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText("Daily Tasks Finished: " .. LocalPlayer():GetNWInt("dailiesCompleted"), "CloseCaption_Bold", w / 2, 60, Color(255, 0, 95), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText("Special Tasks Finished: " .. LocalPlayer():GetNWInt("specialsCompleted"), "CloseCaption_Bold", w / 2, 80, Color(255, 0, 95), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end

		local playerExportStats = vgui.Create("DButton", scrollPanel)
		playerExportStats:Dock(TOP)
		playerExportStats:DockMargin(margin, margin, margin, margin)
		playerExportStats:SetSize(250, 50)
		playerExportStats:SetText("")

		playerExportStats.Paint = function()
			--Color of entire button
			surface.SetDrawColor(100, 100, 100, 255)
			surface.DrawRect(0, 0, playerExportStats:GetWide(), playerExportStats:GetTall())

			--Draw/write text
			draw.DrawText("Export Player Stats to clipboard", "Trebuchet24", playerExportStats:GetWide() / 2, 12.5, Color(255, 255, 0), 1)
		end

		playerExportStats.DoClick = function()
			ply = LocalPlayer()
			SetClipboardText("Player " .. ply:GetName() .. " | " .. "Total Kills: " .. ply:GetNWInt("playerKills") .. " | " .. "Total Deaths: " .. ply:GetNWInt("playerDeaths") .. " | " .. "K/D Ratio: " .. ply:GetNWInt("playerKDR") .. " | " .. "Total Roubles Earned: " .. ply:GetNWInt("playerTotalEarned") .. " | " .. "Roubles Earned From Kills: " .. ply:GetNWInt("playerTotalEarnedKill") .. " | " .. "Roubles Earned From Selling: " .. ply:GetNWInt("playerTotalEarnedSell") .. " | " .. "Total EXP Gained: " .. ply:GetNWInt("playerTotalXpEarned") .. " | " .. "Total EXP From Kills: " .. ply:GetNWInt("playerTotalXpEarnedKill") .. " | " .. "Total EXP From Extracting: " .. ply:GetNWInt("playerTotalXpEarnedExplore") .. " | " .. "Total Money Spent: " .. ply:GetNWInt("playerTotalMoneySpent") .. " | " .. "Total Money Spent On Weapons: " .. ply:GetNWInt("playerTotalMoneySpentWep") .. " | " .. "Total Money Spent On Ammo/Armor: " .. ply:GetNWInt("playerTotalMoneySpentItem") .. " | " .. "Deaths By Suicide: " .. ply:GetNWInt("playerDeathsSuicide") .. " | " .. "Damage Inflicted: " .. ply:GetNWInt("playerDamageGiven") .. " | " .. "Damage Received: " .. ply:GetNWInt("playerDamageRecieved") .. " | " .. "Raids Played: " .. ply:GetNWInt("raidsPlayed") .. " | " .. "Extractions: " .. ply:GetNWInt("raidsExtracted") .. " | " .. "Run Throughs: " .. ply:GetNWInt("raidsRanThrough") .. " | " .. "Killed In Actions: " .. ply:GetNWInt("raidsDied") .. " | " .. "Current Kill Streak: " .. ply:GetNWInt("killStreak") .. " | " .. "Current Extract Streak: " .. ply:GetNWInt("extractionStreak") .. " | " .. "Highest Kill Streak: " .. ply:GetNWInt("highestKillStreak") .. " | " .. "Highest Extract Streak: " .. ply:GetNWInt("highestExtractionStreak"))
		end

		local resetKDButton = vgui.Create("DButton", scrollPanel)
		resetKDButton:Dock(TOP)
		resetKDButton:DockMargin(margin, margin, margin, margin)
		resetKDButton:SetSize(250, 50)
		resetKDButton:SetText("")

		resetKDButton.Paint = function()
			--Color of entire button
			surface.SetDrawColor(100, 100, 100, 255)
			surface.DrawRect(0, 0, resetKDButton:GetWide(), resetKDButton:GetTall())

			--Draw/write text
			if (kdResetText == 0) then
				draw.DrawText("Reset K/D Ratio | " .. math.Round(LocalPlayer():GetNWInt("playerKDR"), 2) .. " > " .. "1.00", "Trebuchet24", resetKDButton:GetWide() / 2, 12.5, Color(255, 0, 0, 255), 1)
			else
				draw.DrawText("Are you sure? This can not be reverted.", "Trebuchet24", resetKDButton:GetWide() / 2, 12.5, Color(255, 0, 0, 255), 1)
			end
		end

		resetKDButton.DoClick = function()
			if (kdResetText == 0) then
				kdResetText = 1
			else
				RunConsoleCommand("efgm_reset_kd")
				kdResetText = 0
			end
		end

		local resetSRButton = vgui.Create("DButton", scrollPanel)
		resetSRButton:Dock(TOP)
		resetSRButton:DockMargin(margin, margin, margin, margin)
		resetSRButton:SetSize(250, 50)
		resetSRButton:SetText("")

		resetSRButton.Paint = function()
			--Color of entire button
			surface.SetDrawColor(100, 100, 100, 255)
			surface.DrawRect(0, 0, resetSRButton:GetWide(), resetSRButton:GetTall())

			--Draw/write text
			if (srResetText == 0) then
				draw.DrawText("Reset SR% | " .. math.Round(LocalPlayer():GetNWInt("survivalRate"), 0) .. "%" .. " > " .. "0%", "Trebuchet24", resetSRButton:GetWide() / 2, 12.5, Color(0, 255, 0, 255), 1)
			else
				draw.DrawText("Are you sure? This can not be reverted.", "Trebuchet24", resetSRButton:GetWide() / 2, 12.5, Color(0, 255, 0, 255), 1)
			end
		end

		resetSRButton.DoClick = function()
			if (srResetText == 0) then
				srResetText = 1
			else
				RunConsoleCommand("efgm_reset_sr")
				srResetText = 0
			end
		end

		local endPanel = vgui.Create("DPanel", scrollPanel)
		endPanel:Dock(TOP)
		endPanel:DockMargin(margin, margin, margin, margin)
		endPanel:SetSize(0, 60)

		endPanel.Paint = function(self, w, h)
			draw.SimpleText("(reset stats cannot currently be reverted by any admin)", "CloseCaption_Bold", w / 2, h / 5, Color(255, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end

	local skillButton = vgui.Create("DButton")
	skillButton:SetParent(Menu)
	skillButton:SetText("")
	skillButton:SetSize(100, 50)
	skillButton:SetPos(0, 125)
	skillButton.Paint = function()
			--Color of entire button
			surface.SetDrawColor(50, 50, 50, 255)
			surface.DrawRect(0, 0, skillButton:GetWide(), skillButton:GetTall())

			--Draw bottom and Right borders
			surface.SetDrawColor(40, 40, 40, 255)
			surface.DrawRect(0, 49, skillButton:GetWide(), 1)
			surface.DrawRect(99, 0, 1, skillButton:GetTall())

			--Draw/write text
			draw.DrawText("SKILLS", "DermaLarge", skillButton:GetWide() / 2, 10, Color(35, 255, 255, 255), 1)
	end

	skillButton.DoClick = function()
		local skillPanel = Menu:Add("SkillPanel")

		local whiteColor = 		Color(250, 250, 250, 255)
		local primaryColor =	Color(30, 30, 30, 255)
		local secondaryColor =	Color(100, 100, 100, 255)

		local margin = 			math.Round( ScrH() * 0.01 )

		local enduranceExpToLevel = (LocalPlayer():GetNWInt("enduranceLevel") * 3)
		local strengthExpToLevel = (LocalPlayer():GetNWInt("strengthLevel") * 2)
		local charismaExpToLevel = (LocalPlayer():GetNWInt("charismaLevel") * 5)
		local covertExpToLevel = (LocalPlayer():GetNWInt("covertLevel") * 2)
		local loyaltyExpToLevel = (LocalPlayer():GetNWInt("loyaltyLevel"))

		skillPanel.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, primaryColor)
		end

		local scrollPanel = vgui.Create("DScrollPanel", skillPanel)
		scrollPanel:Dock(FILL)

		local skillInfoPanel = vgui.Create("DPanel", scrollPanel)
		skillInfoPanel:Dock(TOP)
		skillInfoPanel:DockMargin(margin, margin, margin, margin)
		skillInfoPanel:SetSize(0, 50)

		skillInfoPanel.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, secondaryColor)

			draw.SimpleText("SKILLS", "CloseCaption_BoldItalic", w / 2, h / 2, Color(35, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			if (LocalPlayer():GetNWInt("enduranceLevel") == 40) then
				enduranceProgressText = "Maxed"
			else
				enduranceProgressText = math.Round(LocalPlayer():GetNWInt("enduranceExperience"), 2) .. " / " .. enduranceExpToLevel
			end

			if (LocalPlayer():GetNWInt("strengthLevel") == 30) then
				strengthProgressText = "Maxed"
			else
				strengthProgressText = math.Round(LocalPlayer():GetNWInt("strengthExperience"), 2) .. " / " .. strengthExpToLevel
			end

			if (LocalPlayer():GetNWInt("charismaLevel") == 40) then
				charismaProgressText = "Maxed"
			else
				charismaProgressText = math.Round(LocalPlayer():GetNWInt("charismaExperience"), 2) .. " / " .. charismaExpToLevel
			end

			if (LocalPlayer():GetNWInt("covertLevel") == 20) then
				covertProgressText = "Maxed"
			else
				covertProgressText = math.Round(LocalPlayer():GetNWInt("covertExperience"), 2) .. " / " .. covertExpToLevel
			end

			if (LocalPlayer():GetNWInt("loyaltyLevel") == 25) then
				loyaltyProgressText = "Maxed"
			else
				loyaltyProgressText = math.Round(LocalPlayer():GetNWInt("loyaltyExperience"), 2) .. " / " .. loyaltyExpToLevel
			end
		end

		local endurancePanel = vgui.Create("DPanel", scrollPanel)
		endurancePanel:Dock(TOP)
		endurancePanel:DockMargin(margin, margin, margin, margin)
		endurancePanel:SetSize(0, 150)

		endurancePanel.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, secondaryColor)

			draw.SimpleText("Endurance : " .. "Level " .. LocalPlayer():GetNWInt("enduranceLevel"), "DermaLarge", w / 2, 10, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

			surface.SetDrawColor(50, 50, 50, 255)
			surface.DrawRect(40, 50, 600, 30)

			surface.SetDrawColor(0, 255, 50, 255)
			surface.DrawRect(41, 52.5, 598.5 * (LocalPlayer():GetNWInt("enduranceExperience") / enduranceExpToLevel), 25)

			draw.SimpleText("Increases your walking and running speed.", "DermaLarge", w / 2, 90, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText("Level up by sprinting.", "CloseCaption_Normal", w / 2, 120, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText(enduranceProgressText, "DermaLarge", w / 2, 50, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end

		local strengthPanel = vgui.Create("DPanel", scrollPanel)
		strengthPanel:Dock(TOP)
		strengthPanel:DockMargin(margin, margin, margin, margin)
		strengthPanel:SetSize(0, 150)

		strengthPanel.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, secondaryColor)

			draw.SimpleText("Strength : " .. "Level " .. LocalPlayer():GetNWInt("strengthLevel"), "DermaLarge", w / 2, 10, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

			surface.SetDrawColor(50, 50, 50, 255)
			surface.DrawRect(40, 50, 600, 30)

			surface.SetDrawColor(0, 255, 50, 255)
			surface.DrawRect(41, 52.5, 598.5 * (LocalPlayer():GetNWInt("strengthExperience") / strengthExpToLevel), 25)

			draw.SimpleText("Increases your jump height.", "DermaLarge", w / 2, 90, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText("Level up by jumping or being mid-air.", "CloseCaption_Normal", w / 2, 120, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText(strengthProgressText, "DermaLarge", w / 2, 50, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end

		local charismaPanel = vgui.Create("DPanel", scrollPanel)
		charismaPanel:Dock(TOP)
		charismaPanel:DockMargin(margin, margin, margin, margin)
		charismaPanel:SetSize(0, 150)

		charismaPanel.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, secondaryColor)

			draw.SimpleText("Charisma : " .. "Level " .. LocalPlayer():GetNWInt("charismaLevel"), "DermaLarge", w / 2, 10, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

			surface.SetDrawColor(50, 50, 50, 255)
			surface.DrawRect(40, 50, 600, 30)

			surface.SetDrawColor(0, 255, 50, 255)
			surface.DrawRect(41, 52.5, 598.5 * (LocalPlayer():GetNWInt("charismaExperience") / charismaExpToLevel), 25)

			draw.SimpleText("Decreases the prices of items in the shop.", "DermaLarge", w / 2, 90, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText("Level up by buying items in the shop.", "CloseCaption_Normal", w / 2, 120, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText(charismaProgressText, "DermaLarge", w / 2, 50, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end

		local covertPanel = vgui.Create("DPanel", scrollPanel)
		covertPanel:Dock(TOP)
		covertPanel:DockMargin(margin, margin, margin, margin)
		covertPanel:SetSize(0, 150)

		covertPanel.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, secondaryColor)

			draw.SimpleText("Covert Movement : " .. "Level " .. LocalPlayer():GetNWInt("covertLevel"), "DermaLarge", w / 2, 10, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

			surface.SetDrawColor(50, 50, 50, 255)
			surface.DrawRect(40, 50, 600, 30)

			surface.SetDrawColor(0, 255, 50, 255)
			surface.DrawRect(41, 52.5, 598.5 * (LocalPlayer():GetNWInt("covertExperience") / covertExpToLevel), 25)

			draw.SimpleText("Increases your crouch walking speed.", "DermaLarge", w / 2, 90, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText("Level up by crouching.", "CloseCaption_Normal", w / 2, 120, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText(covertProgressText, "DermaLarge", w / 2, 50, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end

		local loyaltyPanel = vgui.Create("DPanel", scrollPanel)
		loyaltyPanel:Dock(TOP)
		loyaltyPanel:DockMargin(margin, margin, margin, margin)
		loyaltyPanel:SetSize(0, 150)

		loyaltyPanel.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, secondaryColor)

			draw.SimpleText("Loyalty : " .. "Level " .. LocalPlayer():GetNWInt("loyaltyLevel"), "DermaLarge", w / 2, 10, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

			surface.SetDrawColor(50, 50, 50, 255)
			surface.DrawRect(40, 50, 600, 30)

			surface.SetDrawColor(0, 255, 50, 255)
			surface.DrawRect(41, 52.5, 598.5 * (LocalPlayer():GetNWInt("loyaltyExperience") / loyaltyExpToLevel), 25)

			draw.SimpleText("Increases rewards from daily/special tasks.", "DermaLarge", w / 2, 90, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText("Level up by completing tasks.", "CloseCaption_Normal", w / 2, 120, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText(loyaltyProgressText, "DermaLarge", w / 2, 50, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end

		local endPanel = vgui.Create("DPanel", scrollPanel)
		endPanel:Dock(TOP)
		endPanel:DockMargin(margin, margin, margin, margin)
		endPanel:SetSize(0, 60)

		endPanel.Paint = function(self, w, h)
			draw.SimpleText("(leveling a skill too much in a raid will slow down the xp gain)", "CloseCaption_Bold", w / 2, h / 5, Color(255, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end

	local extractsButton = vgui.Create("DButton")
	extractsButton:SetParent(Menu)
	extractsButton:SetText("")
	extractsButton:SetSize(100, 100)
	extractsButton:SetPos(0, 520)

	if below720 == true then
		extractsButton:SetPos(0, 520)
	else
		extractsButton:SetPos(0, 568)
	end

	extractsButton.Paint = function()
		--Color of entire button
		surface.SetDrawColor(50, 50, 50, 255)
		surface.DrawRect(0, 0, extractsButton:GetWide(), extractsButton:GetTall())

		--Draw bottom and Right borders
		surface.SetDrawColor(40, 40, 40, 255)
		surface.DrawRect(0, 99, extractsButton:GetWide(), 1)
		surface.DrawRect(99, 0, 1, extractsButton:GetTall())

		--Draw/write text

		draw.DrawText("EXTRACTS", "CloseCaption_Normal", extractsButton:GetWide() / 2.1, 35, Color(0, 255, 76), 1)

	end

	extractsButton.DoClick = function()
		gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=2799844989")
	end

	local serverButton = vgui.Create("DButton")
	serverButton:SetParent(Menu)
	serverButton:SetText("")
	serverButton:SetSize(100, 50)

	if below720 == true then
		serverButton:SetPos(0, 620)
	else
		serverButton:SetPos(0, 668)
	end

	serverButton.Paint = function()
		--Color of entire button
		surface.SetDrawColor(50, 50, 50, 255)
		surface.DrawRect(0, 0, serverButton:GetWide(), serverButton:GetTall())

		--Draw bottom and Right borders
		surface.SetDrawColor(40, 40, 40, 255)
		surface.DrawRect(0, 49, serverButton:GetWide(), 1)
		surface.DrawRect(99, 0, 1, serverButton:GetTall())

		--Draw/write text

		draw.DrawText("DISCORD", "CloseCaption_Normal", serverButton:GetWide() / 2.1, 10, Color(90, 0, 255), 1)

	end

	serverButton.DoClick = function()
		gui.OpenURL("https://discord.gg/GRfvt27uGF")
	end

	local supportButton = vgui.Create("DButton")
	supportButton:SetParent(Menu)
	supportButton:SetText("")
	supportButton:SetSize(100, 50)

	if below720 == true then
		supportButton:SetPos(0, 670)
	else
		supportButton:SetPos(0, 718)
	end

	supportButton.Paint = function()
		--Color of entire button
		surface.SetDrawColor(50, 50, 50, 255)
		surface.DrawRect(0, 0, supportButton:GetWide(), supportButton:GetTall())

		--Draw bottom and Right borders
		surface.SetDrawColor(40, 40, 40, 255)
		surface.DrawRect(0, 49, supportButton:GetWide(), 1)
		surface.DrawRect(99, 0, 1, supportButton:GetTall())

		--Draw/write text

		draw.DrawText("SUPPORT", "CloseCaption_Normal", supportButton:GetWide() / 2.1, 10, Color(0, 0, 0), 1)

	end

	supportButton.DoClick = function()
		gui.OpenURL("https://discord.gg/GRfvt27uGF")
	end

	local settingsButton = vgui.Create("DButton")
	settingsButton:SetParent(Menu)
	settingsButton:SetText("")
	settingsButton:SetSize(100, 50)
	settingsButton:SetPos(0, 325)
	settingsButton.Paint = function()
		--Color of entire button
		surface.SetDrawColor(50, 50, 50, 255)
		surface.DrawRect(0, 0, settingsButton:GetWide(), settingsButton:GetTall())

		--Draw bottom and Right borders
		surface.SetDrawColor(40, 40, 40, 255)
		surface.DrawRect(0, 49, settingsButton:GetWide(), 1)
		surface.DrawRect(99, 0, 1, settingsButton:GetTall())

		--Draw/write text

		draw.DrawText("SETTINGS", "CloseCaption_Normal", settingsButton:GetWide() / 2, 10, Color(255, 0, 255), 1)

	end

	settingsButton.DoClick = function()
		local settingsPanel = Menu:Add("SettingsPanel")

		local whiteColor = 		Color(250, 250, 250, 255)
		local primaryColor =	Color(30, 30, 30, 255)
		local secondaryColor =	Color(100, 100, 100, 255)

		local margin = 			math.Round( ScrH() * 0.01 )

		settingsPanel.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, primaryColor)
		end

		local scrollPanel = vgui.Create("DScrollPanel", settingsPanel)
		scrollPanel:Dock(FILL)

		local settingsTextPanel = vgui.Create("DPanel", scrollPanel)
		settingsTextPanel:Dock(TOP)
		settingsTextPanel:DockMargin(margin, margin, margin, margin)
		settingsTextPanel:SetSize(0, 50)

		settingsTextPanel.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, secondaryColor)

			draw.SimpleText("SETTINGS", "CloseCaption_BoldItalic", w / 2, h / 2, Color(255, 0, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		local hudPanel = vgui.Create("DPanel", scrollPanel)
		hudPanel:Dock(TOP)
		hudPanel:DockMargin(margin, margin, margin, margin)
		hudPanel:SetSize(0, 90)

		hudPanel.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, secondaryColor)

			draw.SimpleText("HUD and Menus", "CloseCaption_Bold", w / 2, 15, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		local hideUIButton = hudPanel:Add("DCheckBoxLabel")
		hideUIButton:SetPos(305, 40)
		hideUIButton:SetText("Hide UI")
		hideUIButton:SetConVar("efgm_hideui")
		hideUIButton:SetValue(true)
		hideUIButton:SizeToContents()

		local hideControlHintsButton = hudPanel:Add("DCheckBoxLabel")
		hideControlHintsButton:SetPos(257, 60)
		hideControlHintsButton:SetText("Hide Control Hints In Lobby")
		hideControlHintsButton:SetConVar("efgm_hidebinds")
		hideControlHintsButton:SetValue(true)
		hideControlHintsButton:SizeToContents()

		local tasksPanel = vgui.Create("DPanel", scrollPanel)
		tasksPanel:Dock(TOP)
		tasksPanel:DockMargin(margin, margin, margin, margin)
		tasksPanel:SetSize(0, 90)

		tasksPanel.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, secondaryColor)

			draw.SimpleText("Tasks", "CloseCaption_Bold", w / 2, 15, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		local completedDailyTasksHidden = tasksPanel:Add("DCheckBoxLabel")
		completedDailyTasksHidden:SetPos(260, 40)
		completedDailyTasksHidden:SetText("Hide Completed Daily Tasks")
		completedDailyTasksHidden:SetConVar("efgm_hide_daily_completed_tasks")
		completedDailyTasksHidden:SetValue(true)
		completedDailyTasksHidden:SizeToContents()

		local completedSpecialTasksHidden = tasksPanel:Add("DCheckBoxLabel")
		completedSpecialTasksHidden:SetPos(257, 60)
		completedSpecialTasksHidden:SetText("Hide Completed Special Tasks")
		completedSpecialTasksHidden:SetConVar("efgm_hide_special_completed_tasks")
		completedSpecialTasksHidden:SetValue(true)
		completedSpecialTasksHidden:SizeToContents()

		local keybindsPanel = vgui.Create("DPanel", scrollPanel)
		keybindsPanel:Dock(TOP)
		keybindsPanel:DockMargin(margin, margin, margin, margin)
		keybindsPanel:SetSize(0, 120)

		keybindsPanel.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, secondaryColor)

			draw.SimpleText("Keybinds", "CloseCaption_Bold", w / 2, 15, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("Check Extracts", "CloseCaption_Normal", w / 2, 45, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		local checkExtractsBindingButton = vgui.Create("DBinder", keybindsPanel)
		checkExtractsBindingButton:SetSize(100, 50)
		checkExtractsBindingButton:SetPos(290, 60)
		checkExtractsBindingButton:SetSelectedNumber(GetConVar("efgm_check_extracts_bind"):GetInt())

		function checkExtractsBindingButton:OnChange(num)
			extractBinding = checkExtractsBindingButton:GetSelectedNumber()
			RunConsoleCommand("efgm_check_extracts_bind", extractBinding)
		end

		function checkExtractsBindingButton:OnChange()

		end

		local endPanel = vgui.Create("DPanel", scrollPanel)
		endPanel:Dock(TOP)
		endPanel:DockMargin(margin, margin, margin, margin)
		endPanel:SetSize(0, 60)

		endPanel.Paint = function(self, w, h)
			draw.SimpleText("(a rejoin is required to use updated keybinds)", "CloseCaption_Bold", w / 2, h / 5, Color(255, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end

	local dailyButton = vgui.Create("DButton")
	dailyButton:SetParent(Menu)
	dailyButton:SetText("")
	dailyButton:SetSize(100, 50)
	dailyButton:SetPos(0, 75)
	dailyButton.Paint = function()
		--Color of entire button
		surface.SetDrawColor(50, 50, 50, 255)
		surface.DrawRect(0, 0, dailyButton:GetWide(), dailyButton:GetTall())

		--Draw bottom and Right borders
		surface.SetDrawColor(40, 40, 40, 255)
		surface.DrawRect(0, 49, dailyButton:GetWide(), 1)
		surface.DrawRect(99, 0, 1, dailyButton:GetTall())

		--Draw/write text

		draw.DrawText("TASKS", "DermaLarge", dailyButton:GetWide() / 2.1, 10, Color(255, 165, 0, 255), 1)

	end

	dailyButton.DoClick = function(tasksButtonDoClick)
		refreshTasks()
	end

	function refreshTasks()
		local dailyPanel = Menu:Add("DailyPanel")

		local whiteColor = 		Color(250, 250, 250, 255)
		local primaryColor =	Color(30, 30, 30, 255)
		local secondaryColor =	Color(100, 100, 100, 255)

		local margin = 			math.Round( ScrH() * 0.01 )

		local expToLevel = (math.Round(LocalPlayer():GetNWInt("playerLvl") * 140) * 5.15)
		local dailyRewardXP = (math.Round(expToLevel / 6, 1)) * math.Round(LocalPlayer():GetNWInt("loyaltyEffect"))

		local eliminationText = LocalPlayer():GetNWInt("mapKills") .. " / " .. "6"
		local extractText = LocalPlayer():GetNWInt("mapExtracts") .. " / " .. "2"

		local dailyPayment = ("₽ " .. math.Round(5000 * LocalPlayer():GetNWInt("loyaltyEffect")))

		local distancePayment = ("₽ " .. math.Round(50000 * LocalPlayer():GetNWInt("loyaltyEffect")))
		local securedPerimeterPayment = ("₽ " .. math.Round(35000 * LocalPlayer():GetNWInt("loyaltyEffect")))
		local weeklyExtractPayment = ("₽ " .. math.Round(60000 * LocalPlayer():GetNWInt("loyaltyEffect")))
		local shooterBornPayment = ("₽ " .. math.Round(70000 * LocalPlayer():GetNWInt("loyaltyEffect")))
		local deadeyePayment = ("₽ " .. math.Round(60000 * LocalPlayer():GetNWInt("loyaltyEffect")))
		local nuclearPayment = ("₽ " .. math.Round(40000 * LocalPlayer():GetNWInt("loyaltyEffect")))
		local addictPayment = ("₽ " .. math.Round(70000 * LocalPlayer():GetNWInt("loyaltyEffect")))
		local consistencyPayment = ("₽ " .. math.Round(50000 * LocalPlayer():GetNWInt("loyaltyEffect")))

		local distanceText = math.Round(LocalPlayer():GetNWInt("weeklyDistance"), 2) .. " / " .. "3000m"
		local securedPerimeterText = LocalPlayer():GetNWInt("secPerimeter") .. " / " .. "8"
		local weeklyExtractText = LocalPlayer():GetNWInt("weeklyExtracts") .. " / " .. "10"
		local shooterBornText = LocalPlayer():GetNWInt("shooterBorn") .. " / " .. "2"
		local deadeyeText = LocalPlayer():GetNWInt("deadeyeProgress") .. " / " .. "1"
		local nuclearText = LocalPlayer():GetNWInt("raidKill") .. " / " .. "12"
		local addictText = LocalPlayer():GetNWInt("weeklyAddict") .. " / " .. "10"
		local consistencyText = LocalPlayer():GetNWInt("extractionStreak") .. " / " .. "4"
		dailyPanel.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, primaryColor)
		end

		local scrollPanel = vgui.Create("DScrollPanel", dailyPanel)
		scrollPanel:Dock(FILL)

		local dailyTaskPanel = vgui.Create("DPanel", scrollPanel)
		dailyTaskPanel:Dock(TOP)
		dailyTaskPanel:DockMargin(margin, margin, margin, margin)
		dailyTaskPanel:SetSize(0, 60)

		dailyTaskPanel.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, secondaryColor)

			draw.SimpleText("Dailies : Reset at the beginning of each map.", "CloseCaption_BoldItalic", w / 2, h / 2.5, Color(255, 255, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		--DAILY TASKS

		if CLIENT and GetConVar("efgm_hide_daily_completed_tasks"):GetInt() == 1 then
			if LocalPlayer():GetNWInt("eliminationComplete") == 0 then
				local dailyKillPanel = vgui.Create("DPanel", scrollPanel)
				dailyKillPanel:Dock(TOP)
				dailyKillPanel:DockMargin(margin, margin, margin, margin)
				dailyKillPanel:SetSize(0, 120)

				dailyKillPanel.Paint = function(self, w, h)

					draw.RoundedBox(0, 0, 0, w, h, secondaryColor)

					--Elimination

					draw.SimpleText("Elimination : Get kills on other players", "DermaLarge", w / 2, 10, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

					draw.SimpleText("Rewards: " .. dailyRewardXP .. " EXP, " .. dailyPayment, "DermaDefaultBold", w / 2, 40, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

					surface.SetDrawColor(65, 65, 65)
					surface.DrawRect(w / 2 - 250, 60, 500, 30)

					surface.SetDrawColor(0, 255, 50, 255)
					surface.DrawRect(w / 2 - 247.5, 62.5, 495 * (LocalPlayer():GetNWInt("mapKills") / "6"), 25)

					if LocalPlayer():GetNWInt("eliminationComplete") == 0 then
						draw.SimpleText(eliminationText, "DermaDefaultBold", w / 2, 100, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
					else
						draw.SimpleText("Task Completed", "DermaDefaultBold", w / 2, 100, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
					end

				end
			end
		else
			local dailyKillPanel = vgui.Create("DPanel", scrollPanel)
			dailyKillPanel:Dock(TOP)
			dailyKillPanel:DockMargin(margin, margin, margin, margin)
			dailyKillPanel:SetSize(0, 120)

			dailyKillPanel.Paint = function(self, w, h)

				draw.RoundedBox(0, 0, 0, w, h, secondaryColor)

				--Elimination

				draw.SimpleText("Elimination : Get kills on other players", "DermaLarge", w / 2, 10, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

				draw.SimpleText("Rewards: " .. dailyRewardXP .. " EXP, " .. dailyPayment, "DermaDefaultBold", w / 2, 40, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

				surface.SetDrawColor(65, 65, 65)
				surface.DrawRect(w / 2 - 250, 60, 500, 30)

				surface.SetDrawColor(0, 255, 50, 255)
				surface.DrawRect(w / 2 - 247.5, 62.5, 495 * (LocalPlayer():GetNWInt("mapKills") / "6"), 25)

				if LocalPlayer():GetNWInt("eliminationComplete") == 0 then
					draw.SimpleText(eliminationText, "DermaDefaultBold", w / 2, 100, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				else
					draw.SimpleText("Task Completed", "DermaDefaultBold", w / 2, 100, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				end

			end
		end

		if CLIENT and GetConVar("efgm_hide_daily_completed_tasks"):GetInt() == 1 then
			if LocalPlayer():GetNWInt("successfulOperationsComplete") == 0 then
				local dailyExtractPanel = vgui.Create("DPanel", scrollPanel)
				dailyExtractPanel:Dock(TOP)
				dailyExtractPanel:DockMargin(margin, margin, margin, margin)
				dailyExtractPanel:SetSize(0, 120)

				dailyExtractPanel.Paint = function(self, w, h)

					draw.RoundedBox(0, 0, 0, w, h, secondaryColor)

					--Successful Operations

					draw.SimpleText("Successful Operations : Extract from raids", "DermaLarge", w / 2, 10, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

					draw.SimpleText("Rewards: " .. dailyRewardXP .. " EXP, " .. dailyPayment, "DermaDefaultBold", w / 2, 40, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

					surface.SetDrawColor(65, 65, 65)
					surface.DrawRect(w / 2 - 250, 60, 500, 30)

					surface.SetDrawColor(0, 255, 50, 255)
					surface.DrawRect(w / 2 - 247.5, 62.5, 495 * (LocalPlayer():GetNWInt("mapExtracts") / "2"), 25)

					if LocalPlayer():GetNWInt("successfulOperationsComplete") == 0 then
						draw.SimpleText(extractText, "DermaDefaultBold", w / 2, 100, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
					else
						draw.SimpleText("Task Completed", "DermaDefaultBold", w / 2, 100, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
					end
				end
			end
		else
			local dailyExtractPanel = vgui.Create("DPanel", scrollPanel)
			dailyExtractPanel:Dock(TOP)
			dailyExtractPanel:DockMargin(margin, margin, margin, margin)
			dailyExtractPanel:SetSize(0, 120)

			dailyExtractPanel.Paint = function(self, w, h)

				draw.RoundedBox(0, 0, 0, w, h, secondaryColor)

				--Successful Operations

				draw.SimpleText("Successful Operations : Extract from raids", "DermaLarge", w / 2, 10, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

				draw.SimpleText("Rewards: " .. dailyRewardXP .. " EXP, " .. dailyPayment, "DermaDefaultBold", w / 2, 40, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

				surface.SetDrawColor(65, 65, 65)
				surface.DrawRect(w / 2 - 250, 60, 500, 30)

				surface.SetDrawColor(0, 255, 50, 255)
				surface.DrawRect(w / 2 - 247.5, 62.5, 495 * (LocalPlayer():GetNWInt("mapExtracts") / "2"), 25)

				if LocalPlayer():GetNWInt("successfulOperationsComplete") == 0 then
					draw.SimpleText(extractText, "DermaDefaultBold", w / 2, 100, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				else
					draw.SimpleText("Task Completed", "DermaDefaultBold", w / 2, 100, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				end
			end
		end

		local weeklyTaskPanel = vgui.Create("DPanel", scrollPanel)
		weeklyTaskPanel:Dock(TOP)
		weeklyTaskPanel:DockMargin(margin, margin, margin, margin)
		weeklyTaskPanel:SetSize(0, 60)

		weeklyTaskPanel.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, secondaryColor)

			draw.SimpleText("Specials : Reset at the beginning of each wipe.", "CloseCaption_BoldItalic", w / 2, h / 2.5, Color(0, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		--SPECIAL TASKS

		if CLIENT and GetConVar("efgm_hide_special_completed_tasks"):GetInt() == 1 then
			if LocalPlayer():GetNWInt("weeklyDistanceComplete") == 0 then
				local weeklyKillPanel = vgui.Create("DPanel", scrollPanel)
				weeklyKillPanel:Dock(TOP)
				weeklyKillPanel:DockMargin(margin, margin, margin, margin)
				weeklyKillPanel:SetSize(0, 120)

				weeklyKillPanel.Paint = function(self, w, h)

					draw.RoundedBox(0, 0, 0, w, h, secondaryColor)

					--Rangefinder

					draw.SimpleText("Rangefinder : Total kill distance in meters", "DermaLarge", w / 2, 10, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

					draw.SimpleText("Rewards: " .. distancePayment, "DermaDefaultBold", w / 2, 40, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

					surface.SetDrawColor(65, 65, 65)
					surface.DrawRect(w / 2 - 250, 60, 500, 30)

					surface.SetDrawColor(0, 255, 50, 255)
					surface.DrawRect(w / 2 - 247.5, 62.5, 495 * (LocalPlayer():GetNWInt("weeklyDistance") / "3000"), 25)

					if LocalPlayer():GetNWInt("weeklyDistanceComplete") == 0 then
						draw.SimpleText(distanceText, "DermaDefaultBold", w / 2, 100, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
					else
						draw.SimpleText("Task Completed", "DermaDefaultBold", w / 2, 100, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
					end
				end
			end
		else
			local weeklyKillPanel = vgui.Create("DPanel", scrollPanel)
			weeklyKillPanel:Dock(TOP)
			weeklyKillPanel:DockMargin(margin, margin, margin, margin)
			weeklyKillPanel:SetSize(0, 120)

			weeklyKillPanel.Paint = function(self, w, h)

				draw.RoundedBox(0, 0, 0, w, h, secondaryColor)

				--Rangefinder

				draw.SimpleText("Rangefinder : Total kill distance in meters", "DermaLarge", w / 2, 10, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

				draw.SimpleText("Rewards: " .. distancePayment, "DermaDefaultBold", w / 2, 40, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

				surface.SetDrawColor(65, 65, 65)
				surface.DrawRect(w / 2 - 250, 60, 500, 30)

				surface.SetDrawColor(0, 255, 50, 255)
				surface.DrawRect(w / 2 - 247.5, 62.5, 495 * (LocalPlayer():GetNWInt("weeklyDistance") / "3000"), 25)

				if LocalPlayer():GetNWInt("weeklyDistanceComplete") == 0 then
					draw.SimpleText(distanceText, "DermaDefaultBold", w / 2, 100, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				else
					draw.SimpleText("Task Completed", "DermaDefaultBold", w / 2, 100, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				end
			end
		end

		if CLIENT and GetConVar("efgm_hide_special_completed_tasks"):GetInt() == 1 then
			if LocalPlayer():GetNWInt("secPerimeterComplete") == 0 then
				local securedPerimeterPanel = vgui.Create("DPanel", scrollPanel)
				securedPerimeterPanel:Dock(TOP)
				securedPerimeterPanel:DockMargin(margin, margin, margin, margin)
				securedPerimeterPanel:SetSize(0, 120)

				securedPerimeterPanel.Paint = function(self, w, h)

					draw.RoundedBox(0, 0, 0, w, h, secondaryColor)

					--Secured Perimeter

					draw.SimpleText("Secured Perimeter : Kill 8 players within 8m on Factory", "DermaLarge", w / 2, 10, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

					draw.SimpleText("Rewards: " .. securedPerimeterPayment, "DermaDefaultBold", w / 2, 40, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

					surface.SetDrawColor(65, 65, 65)
					surface.DrawRect(w / 2 - 250, 60, 500, 30)

					surface.SetDrawColor(0, 255, 50, 255)
					surface.DrawRect(w / 2 - 247.5, 62.5, 495 * (LocalPlayer():GetNWInt("secPerimeter") / "8"), 25)

					if LocalPlayer():GetNWInt("secPerimeterComplete") == 0 then
						draw.SimpleText(securedPerimeterText, "DermaDefaultBold", w / 2, 100, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
					else
						draw.SimpleText("Task Completed", "DermaDefaultBold", w / 2, 100, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
					end
				end
			end
		else
			local securedPerimeterPanel = vgui.Create("DPanel", scrollPanel)
			securedPerimeterPanel:Dock(TOP)
			securedPerimeterPanel:DockMargin(margin, margin, margin, margin)
			securedPerimeterPanel:SetSize(0, 120)

			securedPerimeterPanel.Paint = function(self, w, h)

				draw.RoundedBox(0, 0, 0, w, h, secondaryColor)

				--Secured Perimeter

				draw.SimpleText("Secured Perimeter : Kill 8 players within 8m on Factory", "DermaLarge", w / 2, 10, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

				draw.SimpleText("Rewards: " .. securedPerimeterPayment, "DermaDefaultBold", w / 2, 40, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

				surface.SetDrawColor(65, 65, 65)
				surface.DrawRect(w / 2 - 250, 60, 500, 30)

				surface.SetDrawColor(0, 255, 50, 255)
				surface.DrawRect(w / 2 - 247.5, 62.5, 495 * (LocalPlayer():GetNWInt("secPerimeter") / "8"), 25)

				if LocalPlayer():GetNWInt("secPerimeterComplete") == 0 then
					draw.SimpleText(securedPerimeterText, "DermaDefaultBold", w / 2, 100, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				else
					draw.SimpleText("Task Completed", "DermaDefaultBold", w / 2, 100, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				end
			end
		end

		if CLIENT and GetConVar("efgm_hide_special_completed_tasks"):GetInt() == 1 then
			if LocalPlayer():GetNWInt("weeklyExtractsComplete") == 0 then
				local weeklyExtractPanel = vgui.Create("DPanel", scrollPanel)
				weeklyExtractPanel:Dock(TOP)
				weeklyExtractPanel:DockMargin(margin, margin, margin, margin)
				weeklyExtractPanel:SetSize(0, 120)

				weeklyExtractPanel.Paint = function(self, w, h)

					draw.RoundedBox(0, 0, 0, w, h, secondaryColor)

					--Wanted

					draw.SimpleText("Wanted : Extract from raids with more than 3 kills", "DermaLarge", w / 2, 10, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

					draw.SimpleText("Rewards: " .. weeklyExtractPayment, "DermaDefaultBold", w / 2, 40, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

					surface.SetDrawColor(65, 65, 65)
					surface.DrawRect(w / 2 - 250, 60, 500, 30)

					surface.SetDrawColor(0, 255, 50, 255)
					surface.DrawRect(w / 2 - 247.5, 62.5, 495 * (LocalPlayer():GetNWInt("weeklyExtracts") / "10"), 25)

					if LocalPlayer():GetNWInt("weeklyExtractsComplete") == 0 then
						draw.SimpleText(weeklyExtractText, "DermaDefaultBold", w / 2, 100, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
					else
						draw.SimpleText("Task Completed", "DermaDefaultBold", w / 2, 100, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
					end
				end
			end
		else
			local weeklyExtractPanel = vgui.Create("DPanel", scrollPanel)
			weeklyExtractPanel:Dock(TOP)
			weeklyExtractPanel:DockMargin(margin, margin, margin, margin)
			weeklyExtractPanel:SetSize(0, 120)

			weeklyExtractPanel.Paint = function(self, w, h)

				draw.RoundedBox(0, 0, 0, w, h, secondaryColor)

				--Wanted

				draw.SimpleText("Wanted : Extract from raids with more than 3 kills", "DermaLarge", w / 2, 10, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

				draw.SimpleText("Rewards: " .. weeklyExtractPayment, "DermaDefaultBold", w / 2, 40, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

				surface.SetDrawColor(65, 65, 65)
				surface.DrawRect(w / 2 - 250, 60, 500, 30)

				surface.SetDrawColor(0, 255, 50, 255)
				surface.DrawRect(w / 2 - 247.5, 62.5, 495 * (LocalPlayer():GetNWInt("weeklyExtracts") / "10"), 25)

				if LocalPlayer():GetNWInt("weeklyExtractsComplete") == 0 then
					draw.SimpleText(weeklyExtractText, "DermaDefaultBold", w / 2, 100, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				else
					draw.SimpleText("Task Completed", "DermaDefaultBold", w / 2, 100, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				end
			end
		end

		if CLIENT and GetConVar("efgm_hide_special_completed_tasks"):GetInt() == 1 then
			if LocalPlayer():GetNWInt("shooterBornComplete") == 0 then
				local shooterBornPanel = vgui.Create("DPanel", scrollPanel)
				shooterBornPanel:Dock(TOP)
				shooterBornPanel:DockMargin(margin, margin, margin, margin)
				shooterBornPanel:SetSize(0, 120)

				shooterBornPanel.Paint = function(self, w, h)

					draw.RoundedBox(0, 0, 0, w, h, secondaryColor)

					--Shooter Born

					draw.SimpleText("Shooter Born : Kill 2 players past 100m on Customs", "DermaLarge", w / 2, 10, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

					draw.SimpleText("Rewards: " .. shooterBornPayment, "DermaDefaultBold", w / 2, 40, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

					surface.SetDrawColor(65, 65, 65)
					surface.DrawRect(w / 2 - 250, 60, 500, 30)

					surface.SetDrawColor(0, 255, 50, 255)
					surface.DrawRect(w / 2 - 247.5, 62.5, 495 * (LocalPlayer():GetNWInt("shooterBorn") / "2"), 25)

					if LocalPlayer():GetNWInt("shooterBornComplete") == 0 then
						draw.SimpleText(shooterBornText, "DermaDefaultBold", w / 2, 100, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
					else
						draw.SimpleText("Task Completed", "DermaDefaultBold", w / 2, 100, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
					end
				end
			end
		else
			local shooterBornPanel = vgui.Create("DPanel", scrollPanel)
			shooterBornPanel:Dock(TOP)
			shooterBornPanel:DockMargin(margin, margin, margin, margin)
			shooterBornPanel:SetSize(0, 120)

			shooterBornPanel.Paint = function(self, w, h)

				draw.RoundedBox(0, 0, 0, w, h, secondaryColor)

				--Shooter Born

				draw.SimpleText("Shooter Born : Kill 2 players past 100m on Customs", "DermaLarge", w / 2, 10, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

				draw.SimpleText("Rewards: " .. shooterBornPayment, "DermaDefaultBold", w / 2, 40, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

				surface.SetDrawColor(65, 65, 65)
				surface.DrawRect(w / 2 - 250, 60, 500, 30)

				surface.SetDrawColor(0, 255, 50, 255)
				surface.DrawRect(w / 2 - 247.5, 62.5, 495 * (LocalPlayer():GetNWInt("shooterBorn") / "2"), 25)

				if LocalPlayer():GetNWInt("shooterBornComplete") == 0 then
					draw.SimpleText(shooterBornText, "DermaDefaultBold", w / 2, 100, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				else
					draw.SimpleText("Task Completed", "DermaDefaultBold", w / 2, 100, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				end
			end
		end

		if CLIENT and GetConVar("efgm_hide_special_completed_tasks"):GetInt() == 1 then
			if LocalPlayer():GetNWInt("deadeyeComplete") == 0 then
				local deadeyePanel = vgui.Create("DPanel", scrollPanel)
				deadeyePanel:Dock(TOP)
				deadeyePanel:DockMargin(margin, margin, margin, margin)
				deadeyePanel:SetSize(0, 120)

				deadeyePanel.Paint = function(self, w, h)

					draw.RoundedBox(0, 0, 0, w, h, secondaryColor)

					--Deadeye

					draw.SimpleText("Deadeye : Kill a player past 140m", "DermaLarge", w / 2, 10, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

					draw.SimpleText("Rewards: " .. deadeyePayment, "DermaDefaultBold", w / 2, 40, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

					surface.SetDrawColor(65, 65, 65)
					surface.DrawRect(w / 2 - 250, 60, 500, 30)

					surface.SetDrawColor(0, 255, 50, 255)
					surface.DrawRect(w / 2 - 247.5, 62.5, 495 * (LocalPlayer():GetNWInt("deadeyeProgress") / "1"), 25)

					if LocalPlayer():GetNWInt("deadeyeComplete") == 0 then
						draw.SimpleText(deadeyeText, "DermaDefaultBold", w / 2, 100, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
					else
						draw.SimpleText("Task Completed", "DermaDefaultBold", w / 2, 100, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
					end
				end
			end
		else
			local deadeyePanel = vgui.Create("DPanel", scrollPanel)
			deadeyePanel:Dock(TOP)
			deadeyePanel:DockMargin(margin, margin, margin, margin)
			deadeyePanel:SetSize(0, 120)

			deadeyePanel.Paint = function(self, w, h)

				draw.RoundedBox(0, 0, 0, w, h, secondaryColor)

				--Deadeye

				draw.SimpleText("Deadeye : Kill a player past 140m", "DermaLarge", w / 2, 10, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

				draw.SimpleText("Rewards: " .. deadeyePayment, "DermaDefaultBold", w / 2, 40, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

				surface.SetDrawColor(65, 65, 65)
				surface.DrawRect(w / 2 - 250, 60, 500, 30)

				surface.SetDrawColor(0, 255, 50, 255)
				surface.DrawRect(w / 2 - 247.5, 62.5, 495 * (LocalPlayer():GetNWInt("deadeyeProgress") / "1"), 25)

				if LocalPlayer():GetNWInt("deadeyeComplete") == 0 then
					draw.SimpleText(deadeyeText, "DermaDefaultBold", w / 2, 100, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				else
					draw.SimpleText("Task Completed", "DermaDefaultBold", w / 2, 100, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				end
			end
		end

		if CLIENT and GetConVar("efgm_hide_special_completed_tasks"):GetInt() == 1 then
			if LocalPlayer():GetNWInt("consistencyComplete") == 0 then
				local consistencyPanel = vgui.Create("DPanel", scrollPanel)
				consistencyPanel:Dock(TOP)
				consistencyPanel:DockMargin(margin, margin, margin, margin)
				consistencyPanel:SetSize(0, 120)

				consistencyPanel.Paint = function(self, w, h)

					draw.RoundedBox(0, 0, 0, w, h, secondaryColor)

					--Consistency

					draw.SimpleText("Consistency : Survive and Extract from 4 raids in a row", "DermaLarge", w / 2, 10, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

					draw.SimpleText("Rewards: " .. consistencyPayment, "DermaDefaultBold", w / 2, 40, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

					surface.SetDrawColor(65, 65, 65)
					surface.DrawRect(w / 2 - 250, 60, 500, 30)

					surface.SetDrawColor(0, 255, 50, 255)

					if LocalPlayer():GetNWInt("consistencyComplete") == 0 then
						surface.DrawRect(w / 2 - 247.5, 62.5, 495 * (LocalPlayer():GetNWInt("extractionStreak") / "4"), 25)
						draw.SimpleText(consistencyText, "DermaDefaultBold", w / 2, 100, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
					else
						surface.DrawRect(w / 2 - 247.5, 62.5, 495, 25)
						draw.SimpleText("Task Completed", "DermaDefaultBold", w / 2, 100, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
					end
				end
			end
		else
			local consistencyPanel = vgui.Create("DPanel", scrollPanel)
			consistencyPanel:Dock(TOP)
			consistencyPanel:DockMargin(margin, margin, margin, margin)
			consistencyPanel:SetSize(0, 120)

			consistencyPanel.Paint = function(self, w, h)

				draw.RoundedBox(0, 0, 0, w, h, secondaryColor)

				--Consistency

				draw.SimpleText("Consistency : Survive and Extract from 4 raids in a row", "DermaLarge", w / 2, 10, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

				draw.SimpleText("Rewards: " .. consistencyPayment, "DermaDefaultBold", w / 2, 40, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

				surface.SetDrawColor(65, 65, 65)
				surface.DrawRect(w / 2 - 250, 60, 500, 30)

				surface.SetDrawColor(0, 255, 50, 255)

				if LocalPlayer():GetNWInt("consistencyComplete") == 0 then
					surface.DrawRect(w / 2 - 247.5, 62.5, 495 * (LocalPlayer():GetNWInt("extractionStreak") / "4"), 25)
					draw.SimpleText(consistencyText, "DermaDefaultBold", w / 2, 100, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				else
					surface.DrawRect(w / 2 - 247.5, 62.5, 495, 25)
					draw.SimpleText("Task Completed", "DermaDefaultBold", w / 2, 100, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				end
			end
		end

		if CLIENT and GetConVar("efgm_hide_special_completed_tasks"):GetInt() == 1 then
			if LocalPlayer():GetNWInt("weeklyAddictComplete") == 0 then
				local addictPanel = vgui.Create("DPanel", scrollPanel)
				addictPanel:Dock(TOP)
				addictPanel:DockMargin(margin, margin, margin, margin)
				addictPanel:SetSize(0, 120)

				addictPanel.Paint = function(self, w, h)

					draw.RoundedBox(0, 0, 0, w, h, secondaryColor)

					--Addiction

					draw.SimpleText("Addiction : Play through 10 maps", "DermaLarge", w / 2, 10, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

					draw.SimpleText("Rewards: " .. addictPayment, "DermaDefaultBold", w / 2, 40, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

					surface.SetDrawColor(65, 65, 65)
					surface.DrawRect(w / 2 - 250, 60, 500, 30)

					surface.SetDrawColor(0, 255, 50, 255)
					surface.DrawRect(w / 2 - 247.5, 62.5, 495 * (LocalPlayer():GetNWInt("weeklyAddict") / "10"), 25)

					if LocalPlayer():GetNWInt("weeklyAddictComplete") == 0 then
						draw.SimpleText(addictText, "DermaDefaultBold", w / 2, 100, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
					else
						draw.SimpleText("Task Completed", "DermaDefaultBold", w / 2, 100, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
					end
				end
			end
		else
			local addictPanel = vgui.Create("DPanel", scrollPanel)
			addictPanel:Dock(TOP)
			addictPanel:DockMargin(margin, margin, margin, margin)
			addictPanel:SetSize(0, 120)

			addictPanel.Paint = function(self, w, h)

				draw.RoundedBox(0, 0, 0, w, h, secondaryColor)

				--Addiction

				draw.SimpleText("Addiction : Play through 10 maps", "DermaLarge", w / 2, 10, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

				draw.SimpleText("Rewards: " .. addictPayment, "DermaDefaultBold", w / 2, 40, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

				surface.SetDrawColor(65, 65, 65)
				surface.DrawRect(w / 2 - 250, 60, 500, 30)

				surface.SetDrawColor(0, 255, 50, 255)
				surface.DrawRect(w / 2 - 247.5, 62.5, 495 * (LocalPlayer():GetNWInt("weeklyAddict") / "10"), 25)

				if LocalPlayer():GetNWInt("weeklyAddictComplete") == 0 then
					draw.SimpleText(addictText, "DermaDefaultBold", w / 2, 100, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				else
					draw.SimpleText("Task Completed", "DermaDefaultBold", w / 2, 100, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				end
			end
		end

		if CLIENT and GetConVar("efgm_hide_special_completed_tasks"):GetInt() == 1 then
			if LocalPlayer():GetNWInt("weeklyNuclearComplete") == 0 then
				local nuclearPanel = vgui.Create("DPanel", scrollPanel)
				nuclearPanel:Dock(TOP)
				nuclearPanel:DockMargin(margin, margin, margin, margin)
				nuclearPanel:SetSize(0, 120)

				nuclearPanel.Paint = function(self, w, h)

					draw.RoundedBox(0, 0, 0, w, h, secondaryColor)

					--Nuclear

					draw.SimpleText("Nuclear : Extract from a raid with 12 or more kills", "DermaLarge", w / 2, 10, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

					draw.SimpleText("Rewards: " .. nuclearPayment, "DermaDefaultBold", w / 2, 40, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

					surface.SetDrawColor(65, 65, 65)
					surface.DrawRect(w / 2 - 250, 60, 500, 30)

					surface.SetDrawColor(0, 255, 50, 255)

					if LocalPlayer():GetNWInt("weeklyNuclearComplete") == 0 then
						surface.DrawRect(w / 2 - 247.5, 62.5, 495 * (LocalPlayer():GetNWInt("raidKill") / "12"), 25)
						draw.SimpleText(nuclearText, "DermaDefaultBold", w / 2, 100, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
					else
						surface.DrawRect(w / 2 - 247.5, 62.5, 495, 25)
						draw.SimpleText("Task Completed", "DermaDefaultBold", w / 2, 100, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
					end
				end
			end
		else
			local nuclearPanel = vgui.Create("DPanel", scrollPanel)
			nuclearPanel:Dock(TOP)
			nuclearPanel:DockMargin(margin, margin, margin, margin)
			nuclearPanel:SetSize(0, 120)

			nuclearPanel.Paint = function(self, w, h)

				draw.RoundedBox(0, 0, 0, w, h, secondaryColor)

				--Nuclear

				draw.SimpleText("Nuclear : Extract from a raid with 12 or more kills", "DermaLarge", w / 2, 10, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

				draw.SimpleText("Rewards: " .. nuclearPayment, "DermaDefaultBold", w / 2, 40, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

				surface.SetDrawColor(65, 65, 65)
				surface.DrawRect(w / 2 - 250, 60, 500, 30)

				surface.SetDrawColor(0, 255, 50, 255)

				if LocalPlayer():GetNWInt("weeklyNuclearComplete") == 0 then
					surface.DrawRect(w / 2 - 247.5, 62.5, 495 * (LocalPlayer():GetNWInt("raidKill") / "12"), 25)
					draw.SimpleText(nuclearText, "DermaDefaultBold", w / 2, 100, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				else
					surface.DrawRect(w / 2 - 247.5, 62.5, 495, 25)
					draw.SimpleText("Task Completed", "DermaDefaultBold", w / 2, 100, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				end
			end
		end

		local endPanel = vgui.Create("DPanel", scrollPanel)
		endPanel:Dock(TOP)
		endPanel:DockMargin(margin, margin, margin, margin)
		endPanel:SetSize(0, 60)

		endPanel.Paint = function(self, w, h)
			draw.SimpleText("(leaving the server will reset your current daily task progress!)", "CloseCaption_Bold", w / 2, h / 5, Color(255, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end

	local taskButton = vgui.Create("DButton")
	taskButton:SetParent(Menu)
	taskButton:SetText("")
	taskButton:SetSize(0, 0)
	taskButton:SetPos(0, 75)
	taskButton.Paint = function()
		--Color of entire button
		surface.SetDrawColor(50, 50, 50, 255)
		surface.DrawRect(0, 0, taskButton:GetWide(), taskButton:GetTall())

		--Draw bottom and Right borders
		surface.SetDrawColor(40, 40, 40, 255)
		surface.DrawRect(0, 49, taskButton:GetWide(), 1)
		surface.DrawRect(99, 0, 1, taskButton:GetTall())

		--Draw/write text

		draw.DrawText("TASKS", "DermaLarge", taskButton:GetWide() / 2.1, 10, Color(255, 165, 0, 255), 1)

	end

	taskButton.DoClick = function()

		-- net.Start("RequestTaskInfo")
		-- net.SendToServer()

		local taskPanel = Menu:Add("TaskPanel")

		function DrawTasks(taskInfo)

			taskPanel:Clear()

			local panelGap = 30

			local textColor = Color(0,0,0,255)

			local taskIncompleteColor = Color(90, 60, 60, 255)
			local taskCompleteColor = Color(90, 90, 120, 255)

			for k, v in pairs(taskInfo) do

				local taskCollapsible = vgui.Create("DCollapsibleCategory", taskPanel)
				taskCollapsible:Dock(TOP)
				taskCollapsible:SetSize(taskPanel:GetWide(), 450)
				taskCollapsible:SetLabel(v[1])
				taskCollapsible:SetExpanded(true)	-- Start collapsed

				local taskInfoPanel = vgui.Create("DPanel", taskPanel)

				taskCollapsible:SetContents(taskInfoPanel)

				taskInfoPanel:Dock(FILL)
				taskInfoPanel:SetSize(taskPanel:GetWide(), 450)

				taskInfoPanel.Paint = function()

					surface.SetDrawColor(80,80,80,255)
					surface.DrawRect(0, 0, taskInfoPanel:GetWide(), taskInfoPanel:GetTall())

					draw.SimpleText(v[1], "DermaLarge", taskInfoPanel:GetWide() / 2, 30, textColor, 1)

					draw.SimpleText(v[2], "DermaDefaultBold", taskInfoPanel:GetWide() / 2, 70, textColor, 1)

					draw.SimpleText("Client:", "DermaLarge", taskInfoPanel:GetWide() / 2, 100, textColor, 1)

					draw.SimpleText(v[4], "DermaDefaultBold", taskInfoPanel:GetWide() / 2, 130, textColor, 1)

					draw.SimpleText("Mission Rewards:", "DermaLarge", taskInfoPanel:GetWide() / 2, 160, textColor, 1)

					draw.SimpleText(v[5], "DermaDefaultBold", taskInfoPanel:GetWide() / 2, 190, textColor, 1)

				end

				local tasksCompletedExploded = string.Explode(" ", tostring( v[7] ))
				local taskObjectivesExploded = string.Explode("|", tostring( v[3] ))

				local completeButtonPosition = 0

				for l, b in pairs(tasksCompletedExploded) do

					print(b)

					local panelOffset = 190 + (l * (panelGap + 80))

					local objectivePanel = vgui.Create("DPanel", taskInfoPanel)
					objectivePanel:SetPos(taskInfoPanel:GetWide() / 2 - 150, panelOffset)
					objectivePanel:SetSize(300, 80)

					objectivePanel.Paint = function()

						if tasksCompletedExploded[l] == "complete" then
							surface.SetDrawColor(taskCompleteColor)
						else
							surface.SetDrawColor(taskIncompleteColor)
						end

						surface.DrawRect(0, 0, objectivePanel:GetWide(), objectivePanel:GetTall())

						draw.SimpleText(taskObjectivesExploded[l], "DermaDefaultBold", objectivePanel:GetWide() / 2, objectivePanel:GetTall() / 2, textColor, 1)

					end

					completeButtonPosition = panelOffset

				end

				completeButtonPosition = completeButtonPosition + 110

				if tonumber(v[8]) == 1 then

					print("Task completed = " .. v[8])

					local taskCompleteButton = vgui.Create("DButton", taskInfoPanel)
					taskCompleteButton:SetText("Complete Task")
					taskCompleteButton:SetPos( taskInfoPanel:GetWide() / 2 - 125, completeButtonPosition)
					taskCompleteButton:SetSize( 250, 50 )

					function taskCompleteButton:DoClick() -- Defines what should happen when the label is clicked
						net.Start("TaskComplete")
						net.WriteInt(v[6], 12)
						net.SendToServer()


					end

				end

			end

		end

	end

	if menuInRaid == false then
		local shopButton = vgui.Create("DButton")
		shopButton:SetParent(Menu)
		shopButton:SetText("")
		shopButton:SetSize(100, 50)
		shopButton:SetPos(0, 175)
		shopButton.Paint = function()
			--Color of entire button
			surface.SetDrawColor(50, 50, 50, 255)
			surface.DrawRect(0, 0, shopButton:GetWide(), shopButton:GetTall())

			--Draw bottom and Right borders
			surface.SetDrawColor(40, 40, 40, 255)
			surface.DrawRect(0, 49, shopButton:GetWide(), 1)
			surface.DrawRect(99, 0, 1, shopButton:GetTall())

			--Draw/write text

			local shopText

			if sellMenuBool == true then shopText = "SELL" else shopText = "SHOP" end

			draw.DrawText(shopText, "DermaLarge", shopButton:GetWide() / 2.1, 10, Color(102, 255, 102, 255), 1)
		end

		shopButton.DoClick = function(shopButton)
			local shopPanel = Menu:Add("ShopPanel")

			local scroller = vgui.Create("DScrollPanel", shopPanel)
			scroller:Dock(FILL)

			local entityCategory

			local entityList

			if sellMenuBool == false then


				entityCategory = vgui.Create("DCollapsibleCategory", scroller)
				-- entityCategory:SetPos(0, 0)
				-- entityCategory:SetSize(shopPanel:GetWide(), 100)
				entityCategory:Dock(TOP)
				entityCategory:SetLabel("Ammo/Armor/Crates")

				entityList = vgui.Create("DIconLayout", entityCategory)
				-- entityList:SetPos(0, 20)
				-- entityList:SetSize(entityCategory:GetWide(), entityCategory:GetTall())
				entityList:Dock(TOP)
				entityList:SetSpaceY(5)
				entityList:SetSpaceX(5)
			end

			local weaponCategory = vgui.Create("DCollapsibleCategory", scroller)
			-- weaponCategory:SetPos(0, 230)
			-- weaponCategory:SetSize(shopPanel:GetWide(), 200)
			weaponCategory:Dock(TOP)
			weaponCategory:SetLabel("Firearms/Weapons")

			local weaponList = vgui.Create("DIconLayout", weaponCategory)
			-- weaponList:SetPos(0, 20)
			-- weaponList:SetSize(weaponCategory:GetWide(), weaponCategory:GetTall())
			weaponList:Dock(TOP)
			weaponList:SetSpaceY(5)
			weaponList:SetSpaceX(5)

			-- testing if this is the shop menu or sell menu, code will be vastly different for each

			if sellMenuBool == true then

				-- if this is the sell menu

				for k, v in pairs(weaponsArr) do

					for l, b in pairs(sellBlacklist) do
						if v[2] == b[1] then
							return
						end
					end

					-- Creates buttons for the weapons

					local icon = vgui.Create("SpawnIcon", weaponList)
					icon:SetModel(v[1])
					icon:SetTooltip(v[3] .. "\nCategory: " .. v[7] .. "\nRarity: " .. v[6] .. "\nSell Price: " .. math.Round(v[4] * sellPriceMultiplier, 0))

					-- this lets players visually distinguish items they can sell

					if not clientPlayer:HasWeapon(v[2]) then

						function icon:Paint(w, h)
							draw.RoundedBox( 0, 5, 5, w - 10, h - 10, Color( 40, 40, 40, 255 ) )
							draw.RoundedBox( 0, 8, 8, w - 16, h - 16, Color( 50, 50, 50, 255 ) )
						end

					elseif clientPlayer:HasWeapon(v[2]) then

						function icon:Paint(w, h)
							draw.RoundedBox( 0, 5, 5, w - 10, h - 10, Color( 210, 210, 210, 255 ) )
							draw.RoundedBox( 0, 8, 8, w - 16, h - 16, Color( 230, 230, 230, 255 ) )
						end

					end

					weaponList:Add(icon)

					icon.DoClick = function(icon)

						if clientPlayer:HasWeapon(v[2]) then

							local tempTable = {clientPlayer, v[2], math.Round(v[4] * sellPriceMultiplier, 0), v[3]}

							net.Start("SellItem")
							net.WriteTable(tempTable)
							net.SendToServer()

							surface.PlaySound("common/wpn_select.wav")
							surface.PlaySound("items/ammo_pickup.wav")

							-- draws the icon black after selling

							function icon:Paint(w, h)
								draw.RoundedBox( 0, 5, 5, w - 10, h - 10, Color( 40, 40, 40, 255 ) )
								draw.RoundedBox( 0, 8, 8, w - 16, h - 16, Color( 50, 50, 50, 255 ) )
							end

						elseif not clientPlayer:HasWeapon(v[2]) then

							ply:PrintMessage(HUD_PRINTTALK, "You do not have a " .. v[3] .. "!")

							surface.PlaySound( "common/wpn_denyselect.wav" )
						end
					end
				end

			else

				-- if this is the regular shop

				for k, v in pairs(entsArr) do
					local icon = vgui.Create("SpawnIcon", entityList)

					icon:SetModel(v[1])
					icon:SetTooltip(v[3] .. "\nCategory: " .. v[7] .. "\nRarity: " .. v[6] .. "\nCost: " .. math.Round(v[4] *  LocalPlayer():GetNWInt("charismaEffect"), 0) .. "\nLevel Req: " .. v[5])
					entityList:Add(icon)

					icon.DoClick = function(icon)
						LocalPlayer():ConCommand("buy_entity " .. v[2])
					end
				end

				for k, v in pairs(weaponsArr) do

					-- Creates buttons for the weapons

					local icon = vgui.Create("SpawnIcon", weaponList)
					icon:SetModel(v[1])
					icon:SetTooltip(v[3] .. "\nCategory: " .. v[7] .. "\nRarity: " .. v[6] .. "\nCost: " .. math.Round(v[4] *  LocalPlayer():GetNWInt("charismaEffect"), 0) .. "\nLevel Req: " .. v[5])
					weaponList:Add(icon)

					icon.DoClick = function(icon)
						LocalPlayer():ConCommand("buy_gun " .. v[2])
					end
				end

			end
		end

	end

	if menuInRaid == false then
		local stashMenuButton = vgui.Create("DButton")
		stashMenuButton:SetParent(Menu)
		stashMenuButton:SetText("")
		stashMenuButton:SetSize(100, 50)
		stashMenuButton:SetPos(0, 225)
		stashMenuButton.Paint = function()
				--Color of entire button
				surface.SetDrawColor(50, 50, 50, 255)
				surface.DrawRect(0, 0, stashMenuButton:GetWide(), stashMenuButton:GetTall())

				--Draw bottom and Right borders
				surface.SetDrawColor(40, 40, 40, 255)
				surface.DrawRect(0, 49, stashMenuButton:GetWide(), 1)
				surface.DrawRect(99, 0, 1, stashMenuButton:GetTall())

				--Draw/write text
				draw.DrawText("STASH", "DermaLarge", stashMenuButton:GetWide() / 2, 10, Color(255, 255, 0, 255), 1)
		end

		stashMenuButton.DoClick = function(stashMenuButton)
			local stashMenuPanel = Menu:Add("StashMenuPanel")
	
			local whiteColor = 		Color(250, 250, 250, 255)
			local primaryColor =	Color(30, 30, 30, 255)
			local secondaryColor =	Color(100, 100, 100, 255)
	
			local margin = 			math.Round( ScrH() * 0.01 )
	
			stashMenuPanel.Paint = function(self, w, h)
				draw.RoundedBox(0, 0, 0, w, h, primaryColor)
			end
	
			local scrollPanel = vgui.Create("DScrollPanel", stashMenuPanel)
			scrollPanel:Dock(FILL)
	
			local stashInfoPanel = vgui.Create("DPanel", scrollPanel)
			stashInfoPanel:Dock(TOP)
			stashInfoPanel:DockMargin(margin, margin, margin, margin)
			stashInfoPanel:SetSize(0, 50)
	
			stashInfoPanel.Paint = function(self, w, h)
				draw.RoundedBox(0, 0, 0, w, h, secondaryColor)
	
				draw.SimpleText("STASH", "CloseCaption_BoldItalic", w / 2, h / 2, Color(255, 255, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
	
			local StashInfoPanel = vgui.Create("DPanel", scrollPanel)
			StashInfoPanel:Dock(TOP)
			StashInfoPanel:DockMargin(margin, margin, margin, margin)
			StashInfoPanel:SetSize(0, 180)
	
			StashInfoPanel.Paint = function(self, w, h)
	
				draw.RoundedBox(0, 0, 0, w, h, secondaryColor)
	
				draw.SimpleText("For each stash level, you gain an addition", "DermaLarge", w / 2, 10, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				draw.SimpleText(" 6 slots for your stash!", "DermaLarge", w / 2, 40, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				draw.SimpleText("Current Stash Level: " .. LocalPlayer():GetNWInt("playerStashLevel") .. "/10", "DermaLarge", w / 2, 80, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				draw.SimpleText("Current ₽ Count: " .. math.Round(LocalPlayer():GetNWInt("playerMoney")), "DermaLarge", w / 2, 110, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				draw.SimpleText("Current Stash Limt: " .. LocalPlayer():GetNWInt("playerStashLimit") .. "/" .. "60", "DermaLarge", w / 2, 140, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

				if (LocalPlayer():GetNWInt("stashMaxed") == 0) then
					draw.SimpleText("Required ₽ to upgrade: " .. LocalPlayer():GetNWInt("playerRoubleForStashUpgrade"), "DermaLarge", w / 2, 170, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				end
			end

			if (LocalPlayer():GetNWInt("stashMaxed") == 0) then
				local StashButtonHolder = vgui.Create("DPanel", scrollPanel)
				StashButtonHolder:Dock(TOP)
				StashButtonHolder:DockMargin(margin, margin, margin, margin)
				StashButtonHolder:SetSize(0, 70)
			end

			if (LocalPlayer():GetNWInt("stashMaxed") == 0) then
				local doStashUpgrade = vgui.Create("DButton")
				doStashUpgrade:SetParent(Menu)
				doStashUpgrade:SetText("")
				doStashUpgrade:SetSize(225, 50)
				doStashUpgrade:SetPos(340, 350)
				doStashUpgrade.Paint = function()
					--Color of entire button
					surface.SetDrawColor(30, 30, 30, 255)
					surface.DrawRect(0, 0, doStashUpgrade:GetWide(), doStashUpgrade:GetTall())

					--Draw bottom and Right borders
					surface.SetDrawColor(40, 40, 40, 255)
					surface.DrawRect(0, 49, doStashUpgrade:GetWide(), 1)
					surface.DrawRect(224, 0, 1, doStashUpgrade:GetTall())

					--Draw/write text
					draw.DrawText("Upgrade Stash!", "Trebuchet24", doStashUpgrade:GetWide() / 2, 10, Color(0, 255, 255, 255), 1)
				end

				doStashUpgrade.DoClick = function()
					RunConsoleCommand("efgm_stash_upgrade")
				end

				StashButtonHolder.Paint = function(self, w, h)
					draw.RoundedBox(0, 0, 0, w, h, secondaryColor)
				end
			end
		end
	end

	if menuInRaid == false then
		local prestigeButton = vgui.Create("DButton")
		prestigeButton:SetParent(Menu)
		prestigeButton:SetText("")
		prestigeButton:SetSize(100, 50)
		prestigeButton:SetPos(0, 275)
		prestigeButton.Paint = function()
				--Color of entire button
				surface.SetDrawColor(50, 50, 50, 255)
				surface.DrawRect(0, 0, prestigeButton:GetWide(), prestigeButton:GetTall())

				--Draw bottom and Right borders
				surface.SetDrawColor(40, 40, 40, 255)
				surface.DrawRect(0, 49, prestigeButton:GetWide(), 1)
				surface.DrawRect(99, 0, 1, prestigeButton:GetTall())

				--Draw/write text
				draw.DrawText("PRESTIGE", "CloseCaption_Normal", prestigeButton:GetWide() / 2, 10, Color(255, 0, 0, 255), 1)
		end

		prestigeButton.DoClick = function(prestigeButton)
			local prestigePanel = Menu:Add("PrestigePanel")
	
			local whiteColor = 		Color(250, 250, 250, 255)
			local primaryColor =	Color(30, 30, 30, 255)
			local secondaryColor =	Color(100, 100, 100, 255)
	
			local margin = 			math.Round( ScrH() * 0.01 )
	
			prestigePanel.Paint = function(self, w, h)
				draw.RoundedBox(0, 0, 0, w, h, primaryColor)
			end
	
			local scrollPanel = vgui.Create("DScrollPanel", prestigePanel)
			scrollPanel:Dock(FILL)
	
			local prestigeInfoPanel = vgui.Create("DPanel", scrollPanel)
			prestigeInfoPanel:Dock(TOP)
			prestigeInfoPanel:DockMargin(margin, margin, margin, margin)
			prestigeInfoPanel:SetSize(0, 50)
	
			prestigeInfoPanel.Paint = function(self, w, h)
				draw.RoundedBox(0, 0, 0, w, h, secondaryColor)
	
				draw.SimpleText("PRESTIGE", "CloseCaption_BoldItalic", w / 2, h / 2, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
	
			local PrestigeInfoPanel = vgui.Create("DPanel", scrollPanel)
			PrestigeInfoPanel:Dock(TOP)
			PrestigeInfoPanel:DockMargin(margin, margin, margin, margin)
			PrestigeInfoPanel:SetSize(0, 180)
	
			PrestigeInfoPanel.Paint = function(self, w, h)
	
				draw.RoundedBox(0, 0, 0, w, h, secondaryColor)
	
				draw.SimpleText("Prestiging resets your level to get a permanent", "DermaLarge", w / 2, 10, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				draw.SimpleText(" rouble boost and to reset your special tasks", "DermaLarge", w / 2, 40, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				draw.SimpleText("Current ₽ Multiplier: " .. LocalPlayer():GetNWInt("playerRoubleMulti") .. "x", "DermaLarge", w / 2, 80, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				draw.SimpleText("Current Prestige: " .. LocalPlayer():GetNWInt("playerPrestige"), "DermaLarge", w / 2, 110, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				draw.SimpleText("Current Level: " .. LocalPlayer():GetNWInt("playerLvl"), "DermaLarge", w / 2, 140, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			end

			local PrestigeButtonHolder = vgui.Create("DPanel", scrollPanel)
			PrestigeButtonHolder:Dock(TOP)
			PrestigeButtonHolder:DockMargin(margin, margin, margin, margin)
			PrestigeButtonHolder:SetSize(0, 70)

			local doPrestigeButton = vgui.Create("DButton")
			doPrestigeButton:SetParent(Menu)
			doPrestigeButton:SetText("")
			doPrestigeButton:SetSize(225, 50)
			doPrestigeButton:SetPos(340, 320)
			doPrestigeButton.Paint = function()
				--Color of entire button
				surface.SetDrawColor(30, 30, 30, 255)
				surface.DrawRect(0, 0, doPrestigeButton:GetWide(), doPrestigeButton:GetTall())

				--Draw bottom and Right borders
				surface.SetDrawColor(40, 40, 40, 255)
				surface.DrawRect(0, 49, doPrestigeButton:GetWide(), 1)
				surface.DrawRect(224, 0, 1, doPrestigeButton:GetTall())

				--Draw/write text
				draw.DrawText("Prestige Now!", "Trebuchet24", doPrestigeButton:GetWide() / 2, 10, Color(0, 255, 0, 255), 1)
			end

			doPrestigeButton.DoClick = function()
				RunConsoleCommand("efgm_prestige")
			end

			PrestigeButtonHolder.Paint = function(self, w, h)

				draw.RoundedBox(0, 0, 0, w, h, secondaryColor)

			end

			local endPanel = vgui.Create("DPanel", scrollPanel)
			endPanel:Dock(TOP)
			endPanel:DockMargin(margin, margin, margin, margin)
			endPanel:SetSize(0, 60)
	
			endPanel.Paint = function(self, w, h)
				draw.SimpleText("(the rouble boost does not persits between server wipes)", "CloseCaption_Bold", w / 2, h / 5, Color(255, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
	end
end

--Player Panel

PANEL = {} --Creates empty panel

function PANEL:Init() -- initializes the panel
	if below720 == true then
		self:SetSize(700, 720)
	else
		self:SetSize(700, 768)
	end
	self:SetPos(100, 25)
end

function PANEL:Paint(w, h)
	draw.RoundedBox(0, 0, 0, w, h, Color(125, 125, 125, 0))
end

vgui.Register("PlayerPanel", PANEL, "Panel")

--End player panel


--Shop Panel

PANEL = {} --Creates empty panel

function PANEL:Init() -- initializes the panel
	if below720 == true then
		self:SetSize(700, 694)
	else
		self:SetSize(700, 746)
	end
	self:SetPos(100, 25)
end

function PANEL:Paint(w, h)
	draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50))
end

vgui.Register("ShopPanel", PANEL, "Panel")

--Task Panel

PANEL = {} --Creates empty panel

function PANEL:Init() -- initializes the panel
	if below720 == true then
		self:SetSize(700, 720)
	else
		self:SetSize(700, 768)
	end
	self:SetPos(100, 25)
end

function PANEL:Paint(w, h)
	draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50))
end

vgui.Register("TaskPanel", PANEL, "Panel")

--End task panel

--Dailies Panel

PANEL = {} --Creates empty panel

function PANEL:Init() -- initializes the panel
	if below720 == true then
		self:SetSize(700, 720)
	else
		self:SetSize(700, 768)
	end
	self:SetPos(100, 25)
end

function PANEL:Paint(w, h)
	draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50))
end

vgui.Register("DailyPanel", PANEL, "DPanel")

--End dailes panel


--Skills Panel

PANEL = {} --Creates empty panel

function PANEL:Init() -- initializes the panel
	if below720 == true then
		self:SetSize(700, 720)
	else
		self:SetSize(700, 768)
	end
	self:SetPos(100, 25)
end

function PANEL:Paint(w, h)
	draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50))
end

vgui.Register("SkillPanel", PANEL, "Panel")

--End skills panel

--Prestige Panel

PANEL = {} --Creates empty panel

function PANEL:Init() -- initializes the panel
	if below720 == true then
		self:SetSize(700, 720)
	else
		self:SetSize(700, 768)
	end
	self:SetPos(100, 25)
end

function PANEL:Paint(w, h)
	draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50))
end

vgui.Register("PrestigePanel", PANEL, "Panel")

--End prestige panel

--Stash menu panel

PANEL = {} --Creates empty panel

function PANEL:Init() -- initializes the panel
	if below720 == true then
		self:SetSize(700, 720)
	else
		self:SetSize(700, 768)
	end
	self:SetPos(100, 25)
end

function PANEL:Paint(w, h)
	draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50))
end

vgui.Register("StashMenuPanel", PANEL, "Panel")

--End stash meun panel

--Settings menu panel

PANEL = {} --Creates empty panel

function PANEL:Init() -- initializes the panel
	if below720 == true then
		self:SetSize(700, 720)
	else
		self:SetSize(700, 768)
	end
	self:SetPos(100, 25)
end

function PANEL:Paint(w, h)
	draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50))
end

vgui.Register("SettingsPanel", PANEL, "Panel")

--End settings meun panel

-- wow this is why i had to merge the fucking stash menu into this jesus christ im dumb
-- actually maybe not idk, im autistic not a rocket scientist

function OpenSellMenu()

	-- Constants for easy use

	clientPlayer = LocalPlayer()

	local blackColor = 		Color(10, 10, 10, 255)
	local whiteColor = 		Color(250, 250, 250, 255)
	local offWhiteColor = 	Color(200, 200, 200, 255)
	local redColor = 	Color(255, 0, 0)

	local primaryColor =	Color(30, 30, 30, 255)
	local secondaryColor =	Color(100, 100, 100, 255)

	local width =			math.Round(912)
	local height =			math.Round(972)

	-- Basic menu shit

	sellMenuFrame = vgui.Create( "DFrame" )
	sellMenuFrame:SetSize( width, height )
	sellMenuFrame:Center()
	sellMenuFrame:SetTitle("Sell Menu")
	sellMenuFrame:SetVisible( true )
	sellMenuFrame:SetDraggable( false )
	sellMenuFrame:ShowCloseButton( true )
	sellMenuFrame:MakePopup()

	-- Other shit

	sellMenuFrame.Paint = function(self, w, h)
		draw.RoundedBox( 0, 0, 0, w, h, blackColor )
	end

	local menuPanel = vgui.Create( "DPanel", sellMenuFrame )
	menuPanel:Dock( FILL )
	menuPanel:DockMargin(5, 5, 5, 5)

	local totalSellValue = 0

	local sellPanel = vgui.Create( "DPanel", menuPanel )
	sellPanel:Dock( FILL )
	sellPanel:DockMargin(20, 120, 20, 20)

	sellPanel.Paint = function(self, w, h)

		draw.RoundedBox( 0, 0, 0, w, h, secondaryColor )

	end

	-- TODO:
	-- Create icon layout
	-- Each icon should clearly show the gun model, name, price, and rarity
	-- "Sell all" button

	local sellIconLayout = vgui.Create( "DIconLayout", sellPanel)
	sellIconLayout:Dock(FILL)
	sellIconLayout:DockMargin(10, 10, 10, 10)
	sellIconLayout:SetSpaceY(10)
	sellIconLayout:SetSpaceX(10)

	local allPlayerWeapons = clientPlayer:GetWeapons()

	for k, v in pairs( allPlayerWeapons ) do

		local isWeaponValid = false
		local weaponSellInfo = {}

		for l, b in pairs(weaponsArr) do

			if b[2] == v:GetClass() then

				isWeaponValid = true
				weaponSellInfo = b

			end

		end

		for l, b in pairs(sellBlacklist) do

			if b[1] == v:GetClass() then

				isWeaponValid = false

			end

		end

		if isWeaponValid == true then

			if weapons.Get(v:GetClass()) == nil then return end

			local weaponInfo = weapons.Get(v:GetClass())

			local wepName

			if weaponInfo["TrueName"] == nil then wepName = weaponInfo["PrintName"] else wepName = weaponInfo["TrueName"] end

			local sellPrice = math.Round( weaponSellInfo[4] * sellPriceMultiplier )

			local icon = vgui.Create("SpawnIcon", stashIconLayout)
			icon:SetModel(weaponInfo["WorldModel"])
			icon:SetTooltip("Sell " .. wepName .. " for " .. sellPrice .. "₽?")
			icon:SetSize(200, 200)

			icon.Paint = function(self, w, h)

				surface.SetDrawColor(whiteColor)
				surface.DrawRect(0, 0, w, h)

				surface.SetDrawColor(offWhiteColor)
				surface.DrawRect(0, 0, w, 30)
				surface.DrawRect(0, h - 30, w, 30)

				draw.SimpleText(wepName, "DermaLarge", w / 2, 15, blackColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("₽ " .. sellPrice, "DermaLarge", w / 2, h - 15, blackColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			end

			icon.DoClick = function(self)

				local tempTable = {v:GetClass(), sellPrice, wepName}

				net.Start("SellItem")
				net.WriteTable(tempTable)
				net.SendToServer()

				surface.PlaySound("common/wpn_select.wav")
				surface.PlaySound("items/ammo_pickup.wav")

				-- draws the icon black after selling

				icon:SetSize(0, 0)

				totalSellValue = totalSellValue - sellPrice

				DrawTotalSellValue()

			end

			totalSellValue = totalSellValue + sellPrice

			sellIconLayout:Add(icon)

		end

	end

	function DrawTotalSellValue()

		menuPanel.Paint = function(self, w, h)

			draw.RoundedBox( 0, 0, 0, w, h, primaryColor )
			draw.SimpleText("TOTAL INVENTORY VALUE: ₽ " .. totalSellValue, "DermaLarge", w / 2, 40, whiteColor, TEXT_ALIGN_CENTER)
			draw.SimpleText("(if you can not see your items, check in your backpack by pressing [I])", "CloseCaption_Normal", w / 2, 75, redColor, TEXT_ALIGN_CENTER)

		end

	end

	DrawTotalSellValue()

end

function MenuInit()

	local client = LocalPlayer()

	local expToLevel = (client:GetNWInt("playerLvl") * 140) * 5.15

	if !client:Alive() then
		return
	end

	if (inStashMenu == false) then
		StashMenu = vgui.Create("DFrame")
		StashMenu:SetSize(917, ScrH() - 41)
		StashMenu:Center()
		StashMenu:SetTitle("")
		StashMenu:SetDraggable(false)
		StashMenu:ShowCloseButton(true)
		StashMenu:SetDeleteOnClose(false)
		StashMenu.Paint = function()
			surface.SetDrawColor(30, 30, 30, 255)
			surface.DrawRect(0, 0, StashMenu:GetWide(), StashMenu:GetTall())

			surface.SetTextColor(255, 255, 255, 255)
			surface.SetFont("Trebuchet24")

			surface.SetTextPos(5, 0)
			surface.DrawText("YOUR ITEMS")

			surface.SetTextPos(360, 0)
			surface.DrawText("STASHED ITEMS")

			surface.SetTextPos(525, 0)
			surface.DrawText(client:GetNWInt("ItemsInStash") .. " / " .. client:GetNWInt("playerStashLimit"))
		end

		gui.EnableScreenClicker(true)
		surface.PlaySound("common/wpn_select.wav")

		inStashMenu = true

		StashMenu.OnClose = function()
			if (inPlayerMenu == false) and (inMapVoteMenu == false) and (inRaidSummaryMenu == false) then
				inStashMenu = false

				gui.EnableScreenClicker(false)
				surface.PlaySound("common/wpn_denyselect.wav")
			else
				inStashMenu = false

				surface.PlaySound("common/wpn_denyselect.wav")
			end
		end

		inventoryTable = stashClient:GetWeapons()

		local playerInventoryPanel = vgui.Create("DPanel", StashMenu)
		playerInventoryPanel:Dock(LEFT)
		playerInventoryPanel:SetSize(96, 0)

		local playerInventoryPanelScroller = vgui.Create("DScrollPanel", playerInventoryPanel)
		playerInventoryPanelScroller:Dock(FILL)

		function playerInventoryPanel:Paint(w, h)

			draw.RoundedBox(0, 0, 0, w, h, Color(120, 120, 120, 255))

		end

		local optionsPanel = vgui.Create("DPanel", StashMenu)

		optionsPanel:Dock(RIGHT)
		optionsPanel:SetSize(150, 50)

		function optionsPanel:Paint(w, h)

			draw.RoundedBox(0, 0, 0, w, 150, Color(120, 120, 120, 255))


			local Avatar = vgui.Create("AvatarImage", optionsPanel)
			Avatar:SetSize(140, 140)
			Avatar:SetPos(5, 5)
			Avatar:SetPlayer(LocalPlayer(), 140)


			draw.DrawText(client:GetName(), "DermaLarge", 0, 200, Color(255, 255, 255, 255))

			if (client:GetNWInt("playerPrestige") >= 1) then
				draw.DrawText("Prestige: " .. client:GetNWInt("playerPrestige"), "DermaLarge", 0, 300, Color(255, 255, 255, 255))
			end

			draw.DrawText("Level: " .. client:GetNWInt("playerLvl"), "DermaLarge", 0, 300, Color(255, 255, 255, 255))
			draw.DrawText("EXP: \n" .. math.Round(client:GetNWInt("playerExp")) .. "/" .. expToLevel, "DermaLarge", 0, 340, Color(255, 255, 255, 255))
			draw.DrawText("₽ " .. math.Round(client:GetNWInt("playerMoney")), "DermaLarge", 0, 420, Color(255, 255, 255, 255))

			draw.DrawText("Kills: " .. client:GetNWInt("playerKills"), "DermaLarge", 0, 460, Color(255, 255, 255, 255))
			draw.DrawText("Deaths:" .. client:GetNWInt("playerDeaths"),"DermaLarge", 0, 500, Color(255, 255, 255, 255))
			draw.DrawText("KDR: " .. math.Round(client:GetNWInt("playerKDR"), 2), "DermaLarge", 0, 540, Color(255, 255, 255, 255))

			draw.DrawText("Stash Level " .. client:GetNWInt("playerStashLevel"), "Trebuchet24", 0, 610, Color(255, 255, 255, 255))
			draw.DrawText(" Upgrade your \n stash in the F4 \n menu!", "Trebuchet24", -5, 650, Color(255, 255, 255, 255))

			draw.RoundedBox(0, 0, 750, w, 350, Color(120, 120, 120, 255))
			draw.RoundedBox(0, 145, 150, 5, 650, Color(120, 120, 120, 255))

		end

		local separatePanel = vgui.Create("DPanel", StashMenu)
		separatePanel:Dock(LEFT)
		separatePanel:SetSize(30, 0)

		function separatePanel:Paint(w, h)

			draw.RoundedBox(0, 0, 0, w, h, Color(30, 30, 30, 255))

		end

		local separateTwoPanel = vgui.Create("DPanel", StashMenu)
		separateTwoPanel:Dock(RIGHT)
		separateTwoPanel:SetSize(30, 0)

		function separateTwoPanel:Paint(w, h)

			draw.RoundedBox(0, 0, 0, w, h, Color(30, 30, 30, 255))

		end

		local stashScroller = vgui.Create("DScrollPanel", StashMenu)
		stashScroller:Dock(FILL)

		local stashPanel = vgui.Create("DPanel", StashMenu)
		stashPanel:Dock(FILL)

		function stashPanel:Paint(w, h)

			draw.RoundedBox(0, 0, 0, w, h, Color(120, 120, 120, 255))

		end

		local stashIconLayout = vgui.Create("DIconLayout", stashPanel)
		stashIconLayout:Dock(FILL)
		stashIconLayout:SetSpaceY(5)
		stashIconLayout:SetSpaceX(5)

		local inventoryIconLayout = vgui.Create("DIconLayout", playerInventoryPanelScroller)
		inventoryIconLayout:Dock(FILL)
		inventoryIconLayout:SetSpaceY(5)
		inventoryIconLayout:SetSpaceX(5)

		local ammoIconLayout = vgui.Create("DIconLayout", ammoInventoryPanel)
		ammoIconLayout:Dock(FILL)
		ammoIconLayout:SetSpaceY(5)
		ammoIconLayout:SetSpaceX(5)

		function DoInventory()

			--local avatar = vgui.Create("AvatarImage")

			--avatar:SetSize(96, 96)
			--avatar:SetPos(101, 635)
			--avatar:SetPlayer(LocalPlayer(), 96)

			for k, v in pairs(stashClient:GetWeapons()) do
				-- Creates buttons for the weapons

				local isWeaponValid = true

				for l, b in pairs(inventoryBlacklist) do

					if b == v:GetClass() then isWeaponValid = false end

				end

				if isWeaponValid == true then

					if weapons.Get(v:GetClass()) == nil then return end

					local weaponInfo = weapons.Get(v:GetClass())

					-- PrintTable(stashClient:GetWeapons())

					local wepName

					if weaponInfo["TrueName"] == nil then wepName = weaponInfo["PrintName"] else wepName = weaponInfo["TrueName"] end

					local icon = vgui.Create("SpawnIcon", stashIconLayout)
					icon:SetModel(weaponInfo["WorldModel"])
					icon:SetTooltip(wepName)
					icon:SetSize(96, 96)

					function icon:Paint(w, h)

						draw.RoundedBox(0, 0, 0, w, h, Color(80, 80, 80, 255))
						draw.RoundedBox(0, 0, 75, w, h - 75, Color(40, 40, 40, 255 ))
						draw.SimpleText(wepName, "DermaDefault", w / 2, 80, Color(255, 255, 255, 255), 1)

						local currentItemPrice = nil
						local currentItemLevel = nil
						local currentItemTier = nil
						local currentItemCategory = nil

						local currentItemSellPrice = nil

						for l, b in pairs(weaponsArr) do

							-- if names match (v.ItemName is same as v["ItemName"])
							if b[2] == v.ItemName then

								currentItemPrice = tostring(b[4])
								currentItemLevel = tostring(b[5])
								currentItemTier = tostring(b[6])
								currentItemCategory = tostring(b[7])

								currentItemSellPrice = (currentItemPrice * sellPriceMultiplier)

								break

							end

						end

						if currentItemPrice != nil then
							draw.SimpleText("₽", "DermaDefault", 5, 0, Color(255, 255, 0, 255), 0)
							draw.SimpleText(currentItemSellPrice, "DermaDefault", 15, 0, Color(255, 255, 255, 255), 0)

							draw.SimpleText("Sell Price", "HudHintTextSmall", 5, 10, Color(255, 255, 255, 255), 0)
							draw.SimpleText("Rarity", "HudHintTextSmall", w / 1.05, 10, Color(255, 255, 255, 255), 2)
						end

						if currentItemTier == "LOW" then
							draw.SimpleText("LOW", "DermaDefault", w / 1.05, 0, Color(255, 0, 0, 255), 2)
						end

						if currentItemTier == "MID" then
							draw.SimpleText("MID", "DermaDefault", w / 1.05, 0, Color(255, 255, 0, 255), 2)
						end

						if currentItemTier == "HIGH" then
							draw.SimpleText("HIGH", "DermaDefault", w / 1.05, 0, Color(0, 255, 0, 255), 2)
						end

						if currentItemTier == "UTIL" then
							draw.SimpleText("UTIL", "DermaDefault", w / 1.05, 0, Color(0, 0, 255, 255), 2)
						end

					end

					inventoryIconLayout:Add(icon)

					icon.DoClick = function(icon)

						net.Start("PutWepInStash")
						net.WriteString(v:GetClass())
						net.SendToServer()

						surface.PlaySound("UI/buttonclick.wav")

					end

				end

			end

			net.Start("RequestStash")
			net.SendToServer()

			function ShowStashTable()

				for k, v in pairs(stashTable) do

					if v["ItemOwner"] != LocalPlayer():SteamID64() then	print(LocalPlayer():SteamID64() .. " does not equal " .. v["ItemOwner"])	return end
					if v["ItemType"] != "wep" then						print("ammo bad")															return end

					local weaponInfo = weapons.Get( v["ItemName"] )

					local wepName

					if weaponInfo["TrueName"] == nil then wepName = weaponInfo["PrintName"] else wepName = weaponInfo["TrueName"] end

					local icon = vgui.Create("SpawnIcon", stashIconLayout)
					icon:SetModel(weaponInfo["WorldModel"])
					icon:SetTooltip(wepName)
					icon:SetSize(96, 96)

					function icon:Paint(w, h)

						-- Weapon Name
						draw.RoundedBox(0, 0, 0, w, h, Color(80, 80, 80, 255))
						draw.RoundedBox(0, 0, 75, w, h - 75, Color(40, 40, 40, 255))
						draw.SimpleText(wepName, "DermaDefault", w / 2, 80, Color(255, 255, 255, 255), 1)

						local currentItemPrice = nil
						local currentItemLevel = nil
						local currentItemTier = nil
						local currentItemCategory = nil

						local currentItemSellPrice = nil

						for l, b in pairs(weaponsArr) do

							-- if names match (v.ItemName is same as v["ItemName"])
							if b[2] == v.ItemName then

								currentItemPrice = tostring(b[4])
								currentItemLevel = tostring(b[5])
								currentItemTier = tostring(b[6])
								currentItemCategory = tostring(b[7])

								currentItemSellPrice = (currentItemPrice * sellPriceMultiplier)

							end

						end

						if currentItemPrice != nil then
							-- Weapon Sell Price
							draw.SimpleText("₽", "DermaDefault", 5, 0, Color(255, 255, 0, 255), 0)
							draw.SimpleText(currentItemSellPrice, "DermaDefault", 15, 0, Color(255, 255, 255, 255), 0)
							draw.SimpleText(currentItemCategory, "HudHintTextSmall", 5, 64, Color(255, 255, 255, 255), 0)

							draw.SimpleText("Sell Price", "HudHintTextSmall", 5, 10, Color(255, 255, 255, 255), 0)
							draw.SimpleText("Rarity", "HudHintTextSmall", w / 1.05, 10, Color(255, 255, 255, 255), 2)
						end

						if currentItemTier == "LOW" then
							draw.SimpleText("LOW", "DermaDefault", w / 1.05, 0, Color(255, 0, 0, 255), 2)
						end

						if currentItemTier == "MID" then
							draw.SimpleText("MID", "DermaDefault", w / 1.05, 0, Color(255, 255, 0, 255), 2)
						end

						if currentItemTier == "HIGH" then
							draw.SimpleText("HIGH", "DermaDefault", w / 1.05, 0, Color(0, 255, 0, 255), 2)
						end

						if currentItemTier == "UTIL" then
							draw.SimpleText("UTIL", "DermaDefault", w / 1.05, 0, Color(0, 0, 255, 255), 2)
						end

					end

					stashIconLayout:Add(icon)

					icon.DoClick = function(icon)

						if LocalPlayer():HasWeapon( v["ItemName"] ) == false then

							net.Start("TakeFromStash")
							net.WriteString(v["ItemName"])
							net.SendToServer()

						else

							surface.PlaySound( "common/wpn_denyselect.wav" )

						end

					end

				end

			end

			function ResetMenu()

				stashIconLayout:Clear()
				inventoryIconLayout:Clear()
				ammoIconLayout:Clear()

				DoInventory()

			end

		end

	end
end

local teamMenuFrame

net.Receive("TeamMenu",function (len, ply)

	CustomTeamMenu()
	DrawTeamMenu()

end)

function CustomTeamMenu()

	-- Constants for easy use

	local client = LocalPlayer()

	local blackColor = 		Color(10, 10, 10, 255)
	local whiteColor = 		Color(250, 250, 250, 255)
	local offWhiteColor = 	Color(200, 200, 200, 255)

	local primaryColor =	Color(30, 30, 30, 255)
	local secondaryColor =	Color(100, 100, 100, 255)

	local inRaidColor = 	Color(50, 255, 50, 255)		-- Red
	local outRaidColor = 	Color(255, 255, 255, 255)		-- Green
	local deadColor = 		Color(255, 50, 50, 255)	-- Gray

	local width =			math.Round( ScrW() * 0.8 )	-- Around 1520 for normal people
	local height =			math.Round( ScrH() * 0.9 )	-- Around 980

	local margin = 			math.Round( ScrH() * 0.01 )

	-- Basic menu shit

	teamMenuFrame = vgui.Create( "DFrame" )
	-- teamMenuFrame:SetPos( (ScrW() / 2) - (width / 2), (ScrH() / 2) - (height / 2) ) 
	teamMenuFrame:SetSize( width, height )
	teamMenuFrame:Center()
	teamMenuFrame:SetTitle("Team Menu")
	teamMenuFrame:SetVisible( true )
	teamMenuFrame:SetDraggable( false )
	teamMenuFrame:ShowCloseButton( true )
	teamMenuFrame:MakePopup()

	-- Other shit

	teamMenuFrame.Paint = function(self, w, h)
		draw.RoundedBox( 0, 0, 0, w, h, blackColor )
	end

	local menuPanel = vgui.Create( "DPanel", teamMenuFrame )
	menuPanel:Dock( BOTTOM )
	menuPanel:SetSize(0, height - 40)

	menuPanel.Paint = function(self, w, h)

		draw.RoundedBox( 0, 0, 0, w, h, primaryColor )

	end

	-- MAIN PANEL: Browser Panel (View available teams)

	local teamBrowserPanel = vgui.Create( "DPanel", menuPanel )
	teamBrowserPanel:Dock( LEFT )
	teamBrowserPanel:SetSize(math.Round( ScrW() * 0.2 ), 0 )
	teamBrowserPanel:DockMargin( margin, margin, margin, margin )

	teamBrowserPanel.Paint = function(self, w, h)
		draw.RoundedBox( 0, 0, 0, w, h, primaryColor )
	end

	-- MAIN PANEL: Member Panel (View your current team, teammates, and their statuses)

	local teamMemberPanel = vgui.Create( "DPanel", menuPanel )
	teamMemberPanel:Dock( FILL )
	teamMemberPanel:DockMargin( margin, margin, margin, margin )

	teamMemberPanel.Paint = function(self, w, h)
		draw.RoundedBox( 0, 0, 0, w, h, primaryColor )
	end

	function DrawTeamMenu()

		local currentTeamName = client:GetNWInt("playerTeam")

		-- FUCK ME THIS FIXED THE REFRESHING I HAD IT BEFORE THE FUCKING DRAWTEAMMENU IM SO PISSED AT MYSELF AUGHHHHHHHHHH ):<



		-- SUB PANEL: Team Name Panel (See your team's name and number of members)

		local teamNamePanel = vgui.Create( "DPanel", teamMemberPanel )
		teamNamePanel:Dock( TOP )
		teamNamePanel:SetSize(0, 70)
		teamNamePanel:DockMargin( margin, margin, margin, margin )

		teamNamePanel.Paint = function(self, w, h)

			draw.RoundedBox( 0, 0, 0, w, h, secondaryColor )

			if currentTeamName == "" then

				draw.SimpleText("Join or create a team here.", "DermaLarge", w / 2, h / 2, offWhiteColor, 1, 1)

			elseif currentTeamName != nil then

				draw.SimpleText(string.Replace(currentTeamName, "_", " "), "DermaLarge", w / 2, h / 3, whiteColor, 1, 1)

				local members = #FindAllInTeam(currentTeamName)

				if members <= 1 then

					draw.SimpleText( members .. " Member", "DermaDefault", w / 2, (h / 3) * 2, offWhiteColor, 1, 1)

				elseif members > 1 then

					draw.SimpleText( members .. " Members", "DermaDefault", w / 2, (h / 3) * 2, offWhiteColor, 1, 1)

				end

			end

		end

		-- SUB PANEL: Team Info Panel (See your team's members and their statuses, leave your team, or create a team)

		local teamInfoPanel = vgui.Create( "DPanel", teamMemberPanel )
		teamInfoPanel:Dock( FILL )
		teamInfoPanel:DockMargin( margin, margin, margin, margin )

		teamInfoPanel.Paint = function(self, w, h)

			draw.RoundedBox( 0, 0, 0, w, h, secondaryColor )

			if currentTeamName == "" then

				draw.SimpleText("You are not currently in a team.", "DermaLarge", w / 2, h / 8, offWhiteColor, 1, 1)

			elseif currentTeamName != nil then

				local members = FindAllInTeam(currentTeamName)

				if members == nil or table.IsEmpty(members) == true then

					teamExamplePanel.Think = function()

						members = FindAllInTeam(v)

					end

				elseif members != nil or table.IsEmpty(members) == false then

					if #members <= 1 then

						draw.SimpleText("Current Team Member:", "DermaLarge", 40, h / 16, whiteColor, 0, 1)

					elseif #members > 1 then

						draw.SimpleText("Current Team Members:", "DermaLarge", 40, h / 16, whiteColor, 0, 1)

					end

				end

				local startingHeight = (h / 16) + 30
				local increment = 15

				for k, v in pairs(members) do

					local currentHeight = startingHeight + ((k - 1) * increment)

					local color = deadColor

					if v:GetNWInt("inRaid") == true and v:Alive() == true then 

						color = inRaidColor

					elseif v:GetNWInt("inRaid") == false and v:Alive() == true then

						color = outRaidColor

					end

					if v:GetNWBool("teamLeader") == true then

						draw.SimpleText("- " .. v:GetName() .. " (Leader)", "DermaDefaultBold", 40, currentHeight, color, 0, 1)

					elseif v:GetNWBool("teamLeader") == false then

						draw.SimpleText("- " .. v:GetName(), "DermaDefaultBold", 40, currentHeight, color, 0, 1)

					end

				end

			end

		end

		if currentTeamName == "" then

			-- If the player does not belong to a team

			local createTeamPanel = vgui.Create( "DPanel", teamInfoPanel )
			createTeamPanel:Dock(BOTTOM)
			createTeamPanel:DockMargin( margin, margin, margin, margin )
			createTeamPanel:SetSize(0, 210)

			createTeamPanel.Paint = function(self, w, h)

				draw.RoundedBox( 0, 0, 0, w, h, primaryColor )

			end

			local teamNameEntry = vgui.Create("DTextEntry", createTeamPanel)
			teamNameEntry:Dock(TOP)
			teamNameEntry:DockMargin(margin, margin, margin, margin)
			teamNameEntry:SetSize(0, 50)
			teamNameEntry:SetPlaceholderText("Team name")

			local teamPasswordEntry = vgui.Create("DTextEntry", createTeamPanel)
			teamPasswordEntry:Dock(TOP)
			teamPasswordEntry:DockMargin(margin, margin, margin, margin)
			teamPasswordEntry:SetSize(0, 50)
			teamPasswordEntry:SetPlaceholderText("Team Password (Leave blank to make the team public!)")

			local createTeamButton = vgui.Create("DButton", createTeamPanel)
			createTeamButton:Dock(TOP)
			createTeamButton:DockMargin(margin, margin, margin, margin)
			createTeamButton:SetSize(0, 50)
			createTeamButton:SetText("Create Team")

			createTeamButton.DoClick = function(self)

				local teamName = teamNameEntry:GetText()
				local teamPassword = teamPasswordEntry:GetText()
				if teamName == "" then teamName = client:GetName() .. "'s_Team" end

				teamName = string.Replace(teamName, " ", "_")
				teamPassword = string.Replace(teamPassword, " ", "_")

				teamName = string.Replace(teamName, [["]], "")
				teamPassword = string.Replace(teamPassword, [["]], "")

				teamName = string.Replace(teamName, [[']], "")
				teamPassword = string.Replace(teamPassword, [[']], "")

				teamName = string.Replace(teamName, "[", "")
				teamPassword = string.Replace(teamPassword, "[", "")

				teamName = string.Replace(teamName, "]", "")
				teamPassword = string.Replace(teamPassword, "]", "")

				client:ConCommand("party_create " .. teamName .. " " .. teamPassword .. "")

				surface.PlaySound("UI/buttonclick.wav")

			end

		elseif currentTeamName != "" then

			-- If the player is already in a team

			local leaveTeamPanel = vgui.Create("DPanel", teamInfoPanel)
			leaveTeamPanel:Dock(BOTTOM)
			leaveTeamPanel:DockMargin(margin, margin, margin, margin)
			leaveTeamPanel:SetSize(0, 70)

			leaveTeamPanel.Paint = function(self, w, h)
				draw.RoundedBox(0, 0, 0, w, h, primaryColor)
			end

			local leaveTeamButton = vgui.Create("DButton", leaveTeamPanel)
			leaveTeamButton:Dock(BOTTOM)
			leaveTeamButton:DockMargin(margin, margin, margin, margin)
			leaveTeamButton:SetSize(0, 50)
			leaveTeamButton:SetText("Leave Team")

			leaveTeamButton.DoClick = function(self)

				client:ConCommand("party_leave")

				surface.PlaySound("UI/buttonclick.wav")

			end

		end


		-- SUB PANEL: Search Panel (Search for teams)

		local searchPanel = vgui.Create("DPanel", teamBrowserPanel)
		searchPanel:Dock(TOP)
		searchPanel:SetSize(0, 90)
		searchPanel:DockMargin(margin, margin, margin, margin)

		searchPanel.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, secondaryColor)
		end

		local searchEntry = vgui.Create("DTextEntry", searchPanel)
		searchEntry:Dock(TOP)
		searchEntry:SetSize(0, 30)
		searchEntry:DockMargin(margin, margin, margin, margin)
		searchEntry:SetPlaceholderText("Search Teams (Placeholder, doesn't work yet)")

		searchEntry.OnEnter = function()

			client:PrintMessage(3, "Can you read???")

		end

		local refreshButton = vgui.Create("DButton", searchPanel)
		refreshButton:Dock(FILL)
		refreshButton:DockMargin(margin, margin, margin, margin)
		refreshButton:SetText("Refresh")

		-- SUB PANEL: Team Display Panel (Shows the teams you can join)

		local teamDisplayPanel = vgui.Create("DPanel", teamBrowserPanel)
		teamDisplayPanel:Dock(FILL)
		teamDisplayPanel:SetSize(0, 250)
		teamDisplayPanel:DockMargin(margin, margin, margin, margin)

		teamDisplayPanel.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, secondaryColor)
		end

		local teamDisplayScroller = vgui.Create("DScrollPanel", teamDisplayPanel)
		teamDisplayScroller:Dock(FILL)

		refreshButton.DoClick = function()

			teamDisplayScroller:Clear()

			DrawTeamPanels()

		end

		function DrawTeamPanels()

			if FindAllTeams() != nil then

				for k, v in pairs(FindAllTeams()) do
					local teamExamplePanel = vgui.Create("DPanel", teamDisplayScroller)
					teamExamplePanel:Dock(TOP)
					teamExamplePanel:DockMargin(5, 5, 5, 5)
					teamExamplePanel:SetSize(0, 70)

					teamExamplePanel.Paint = function(self, w, h)
						draw.RoundedBox(0, 0, 0, w, h, primaryColor)
						draw.SimpleText(string.Replace(tostring(v), "_", " "), "DermaLarge", 5, 5, whiteColor)

						local members = FindAllInTeam(v)

						if members == nil or table.IsEmpty(members) == true then

							teamExamplePanel.Think = function()

								members = FindAllInTeam(v)

							end

						elseif members != nil or table.IsEmpty(members) == false then

							if #members <= 1 then

								draw.SimpleText(#members .. " Member", "DermaDefault", w - 5, 5, offWhiteColor, 2)

							elseif #members > 1 then

								draw.SimpleText(#members .. " Members", "DermaDefault", w - 5, 5, offWhiteColor, 2)

							end

						end

					end

					if v == client:GetNWString("playerTeam") then

						-- If they are already in this team

						local joinTeamPanel = vgui.Create("DPanel", teamExamplePanel)
						joinTeamPanel:Dock(BOTTOM)
						joinTeamPanel:DockMargin(5, 5, 5, 5)
						joinTeamPanel:SetSize(0, 25)

						joinTeamPanel.Paint = function(self, w, h)
							draw.RoundedBox(0, 0, 0, w, h, primaryColor)
							draw.SimpleText("You are in this team", "DermaDefault", w / 2, h / 2, whiteColor, 1, 1)
						end

					elseif v != client:GetNWString("playerTeam") then

						-- If they are not in this team

						local teamLeader = FindTeamLeader(v)

						print("Team leader = " .. teamLeader:GetName())

						if teamLeader:GetNWString("teamPassword") == "" then

							-- If they don't have a password

							local joinTeamButton = vgui.Create("DButton", teamExamplePanel)
							joinTeamButton:Dock(BOTTOM)
							joinTeamButton:DockMargin(5, 5, 5, 5)
							joinTeamButton:SetSize(0, 25)
							joinTeamButton:SetText("Join " .. v)

							joinTeamButton.DoClick = function(self)

								client:ConCommand("party_join " .. v)

								surface.PlaySound("UI/buttonclick.wav")

							end

						elseif teamLeader:GetNWString("teamPassword") != "" then

							-- If they use a password

							local joinTeamPassword = vgui.Create("DTextEntry", teamExamplePanel)
							joinTeamPassword:Dock(BOTTOM)
							joinTeamPassword:DockMargin(5, 5, 5, 5)
							joinTeamPassword:SetSize(0, 25)
							joinTeamPassword:SetPlaceholderText("Password for " .. string.Replace(v, "_", " "))

							joinTeamPassword.OnEnter = function(self)

								client:ConCommand("party_join " .. v .. " " .. string.Replace(self:GetText(), " ", "_"))

								surface.PlaySound("UI/buttonclick.wav")

							end

						end

					end

				end

			end

		end

		DrawTeamPanels()

		teamMenuFrame.Think = function()

			local newTeamName = client:GetNWInt("playerTeam")

			if newTeamName != currentTeamName then

				teamBrowserPanel:Clear()
				teamMemberPanel:Clear()

				DrawTeamMenu()

			end

		end

	end

end

net.Receive("EnterRaidMenu",function (len, ply)

	EnterRaidMenu()

end)

function EnterRaidMenu()

	-- Constants for easy use

	local client = LocalPlayer()

	local blackColor = 		Color(10, 10, 10, 255)

	local primaryColor =	Color(30, 30, 30, 255)
	local secondaryColor =	Color(100, 100, 100, 255)

	local width =			600
	local height =			600

	local margin = 			10

	local raidMenuFrame = vgui.Create("DFrame")
	raidMenuFrame:SetPos((ScrW() / 2) - (width / 2), (ScrH() / 2) - (height / 2))
	raidMenuFrame:SetSize(width, height)
	raidMenuFrame:SetTitle("Raid Menu")
	raidMenuFrame:SetVisible(true)
	raidMenuFrame:SetDraggable(false)
	raidMenuFrame:ShowCloseButton(true)
	raidMenuFrame:MakePopup()

	-- Other shit

	raidMenuFrame.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, blackColor)
	end

	local raidMenuPanel = vgui.Create("DPanel", raidMenuFrame)
	raidMenuPanel:Dock(BOTTOM)
	raidMenuPanel:SetSize(0, height - 40)

	raidMenuPanel.Paint = function(self, w, h)

		draw.RoundedBox(0, 0, 0, w, h, primaryColor)

	end

	-- MAIN PANEL: The time has come text lol. Idk, it builds suspense or something. Fuck dude, get off my back man, tarky does it, im gonna do it. Fuck you, and fuck off, and leave me to my luas

	local topTextPanel = vgui.Create("DPanel", raidMenuPanel)
	topTextPanel:Dock(TOP)
	topTextPanel:DockMargin(margin, margin, margin, margin)
	topTextPanel:SetSize(0, 80)

	currentMap = game.GetMap()

	if currentMap == "efgm_factory" then
		mapName = "Factory"
	end

	if currentMap == "efgm_concrete" then
		mapName = "Concrete"
	end

	if currentMap == "efgm_customs" then
		mapName = "Customs"
	end

	if currentMap == "efgm_belmont" then
		mapName = "Belmont"
	end

	topTextPanel.Paint = function(self, w, h)

		draw.RoundedBox(0, 0, 0, w, h, secondaryColor)

		draw.SimpleText("THE TIME HAS COME", "DermaLarge", w / 2, h / 2.8, primaryColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		if mapName == "Factory" or mapName == "Concrete" or mapName == "Customs" or mapName == "Belmont" then
			draw.SimpleText("Exfiltration into the " .. mapName .. " location.", "DermaLarge", w / 2, h / 1.4, primaryColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

	end

	-- MAIN PANEL: Raid Info Panel (shit like your team, raid time, your pmc, and a big ol' button for entering the raid)

	local raidInfoPanel = vgui.Create("DPanel", raidMenuPanel)
	raidInfoPanel:Dock(FILL)
	raidInfoPanel:DockMargin(margin, margin, margin, margin)

	raidInfoPanel.Paint = function(self, w, h)

		draw.RoundedBox(0, 0, 0, w, h, secondaryColor)

		if client:GetNWBool("teamLeader") == true and client:GetNWString("playerTeam") then

			draw.SimpleText(client:GetName(), "DermaLarge", w / 2, 50, primaryColor, TEXT_ALIGN_CENTER)
			draw.SimpleText("You are the party leader", "DermaDefault", w / 2, 30, primaryColor, TEXT_ALIGN_CENTER)

		elseif client:GetNWBool("teamLeader") == false then

			draw.SimpleText(client:GetName(), "DermaLarge", w / 2, 50, primaryColor, TEXT_ALIGN_CENTER)
			draw.SimpleText("You are a member of a party", "DermaDefault", w / 2, 30, primaryColor, TEXT_ALIGN_CENTER)

		end

		draw.RoundedBox(0, 290 - 64 - 15, 100 - 15, 128 + 30, 128 + 30, primaryColor)

	end

	local playerAvatar = vgui.Create("AvatarImage", raidInfoPanel)
	playerAvatar:SetSize(128, 128)
	playerAvatar:SetPos(290 - 64, 100)
	playerAvatar:SetPlayer(LocalPlayer(), 128)

	local playerModelDisplay = vgui.Create("DModelPanel", raidInfoPanel)
	playerModelDisplay:SetSize(350, 350)
	playerModelDisplay:SetPos(120 - 180, -30)
	playerModelDisplay:SetModel( client:GetModel() )

	local enterRaidButton = vgui.Create("DButton", raidInfoPanel)

	if client:GetNWBool("teamLeader") == true and client:GetNWString("playerTeam") then

		enterRaidButton:Dock(BOTTOM)
		enterRaidButton:DockMargin(margin, margin, margin, margin)
		enterRaidButton:SetSize(0, 70)
		enterRaidButton:SetText("Enter the Raid")

	elseif client:GetNWBool("teamLeader") == false then

		enterRaidButton:Dock(BOTTOM)
		enterRaidButton:DockMargin(margin, margin, margin, margin)
		enterRaidButton:SetSize(0, 70)
		enterRaidButton:SetText("Enter the Raid alone.")

	end

	enterRaidButton.DoClick = function(self)

		-- enter raid blah blah blah

		surface.PlaySound("UI/buttonclick.wav")

		net.Start("EnterRaidProper")
		net.WriteUInt(0, 4) -- 0 for PMC, 1 for Scav, thats it really, I guess 2 for error?
		net.SendToServer()



	end

	enterRaidButton.Think = function()

		if client:GetNWBool("inRaid") == true then

			raidMenuFrame:Close()

		end

	end

end