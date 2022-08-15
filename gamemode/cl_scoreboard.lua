local ScoreboardDerma = nil
local PlayerList = nil

function GM:ScoreboardShow()

	if !IsValid(ScoreboardDerma) then
		ScoreboardDerma = vgui.Create("DFrame")
		ScoreboardDerma:SetSize(210, 420)
		ScoreboardDerma:Center()
		ScoreboardDerma:SetTitle("Escape From Garry's Mod | Player List", Color(85, 0, 255, 255))
		ScoreboardDerma:SetDraggable(false)
		ScoreboardDerma:ShowCloseButton(false)
		ScoreboardDerma.Paint = function()
			draw.RoundedBox(5, 0, 0, ScoreboardDerma:GetWide(), ScoreboardDerma:GetTall(), Color(60, 60, 60, 255))
		end

		local PlayerScrollPanel = vgui.Create("DScrollPanel", ScoreboardDerma)
		PlayerScrollPanel:SetSize(ScoreboardDerma:GetWide(), ScoreboardDerma:GetTall() - 20)
		PlayerScrollPanel:SetPos(0, 20)

		PlayerList = vgui.Create("DListLayout", PlayerScrollPanel)
		PlayerList:SetSize(PlayerScrollPanel:GetWide(), PlayerScrollPanel:GetTall())
		PlayerList:SetPos(0, 0)
	end

	if IsValid(ScoreboardDerma) then
		PlayerList:Clear()

		for k, v in pairs(player.GetAll()) do
			local PlayerPanel = vgui.Create("DPanel", PlayerList)
			PlayerPanel:SetSize(PlayerList:GetWide(), 50)
			PlayerPanel:SetPos(0, 0)
			PlayerPanel.Paint = function()
				draw.RoundedBox(0, 0, 0, PlayerPanel:GetWide(), PlayerPanel:GetTall(), Color(35, 35, 35, 255))
				draw.RoundedBox(0, 0, 49, PlayerPanel:GetWide(), 1, Color(35, 35, 35, 255))

				draw.SimpleText(v:GetName() .. " - " .. v:Ping() .. "ms", "DermaDefault", 50, 5, Color(255, 255, 255))

				draw.SimpleText("K/D: " .. math.Round(v:GetNWInt("playerKDR"), 1), "DermaDefault", 50, 35, Color(255, 0, 0))
				draw.SimpleText("SR: " .. math.Round(v:GetNWInt("survivalRate"), 0) .. "%", "DermaDefault", 105, 35, Color(0, 255, 0))
				draw.SimpleText("TC: " .. LocalPlayer():GetNWInt("dailiesCompleted") + LocalPlayer():GetNWInt("specialsCompleted"), "DermaDefault", 160, 35, Color(255, 165, 0))

				if (v:GetNWInt("playerPrestige") >= 1) then
					draw.SimpleText("Prestige: " .. v:GetNWInt("playerPrestige") .. "  |  " .. "Level: " .. v:GetNWInt("playerLvl"), "DermaDefault", 50, 20, Color(255, 195, 0))
				else
					draw.SimpleText("Level " .. v:GetNWInt("playerLvl"), "DermaDefault", 50, 20, Color(255, 195, 0))
				end
			end

			playerProfilePicture = vgui.Create("AvatarImage", PlayerPanel)
			playerProfilePicture:SetPos(5, 5)
			playerProfilePicture:SetSize(40, 40)
			playerProfilePicture:SetPlayer(v, 184)

			playerProfilePicture.OnMousePressed = function(self)
				local Menu = DermaMenu()
				local expToLevel = (v:GetNWInt("playerLvl") * 140) * 5.15

				local profileButton = Menu:AddOption("View Steam Profile", function() gui.OpenURL("http://steamcommunity.com/profiles/" .. v:SteamID64()) end)
				profileButton:SetIcon("icon16/page_find.png")

				local statsButton = Menu:AddSubMenu("View Stats")

				local personalStats = statsButton:AddSubMenu("Personal Stats")
				personalStats:AddOption("Level: " .. v:GetNWInt("playerLvl"))
				personalStats:AddOption("EXP: " .. math.Round(v:GetNWInt("playerExp")) .. "/" .. expToLevel)
				personalStats:AddOption("Roubles: ₽" .. math.Round(v:GetNWInt("playerMoney")))

				local generalStats = statsButton:AddSubMenu("General Stats")
				generalStats:AddOption("Kills: " .. v:GetNWInt("playerKills"))
				generalStats:AddOption("Deaths: " .. v:GetNWInt("playerDeaths"))
				generalStats:AddOption("K/D Ratio: " .. math.Round(v:GetNWInt("playerKDR"), 2))
				generalStats:AddOption("Roubles Earned: ₽" .. v:GetNWInt("playerTotalEarned"))
				generalStats:AddOption("Roubles Earned From Kills: ₽" .. v:GetNWInt("playerTotalEarnedKill"))
				generalStats:AddOption("Roubles Earned From Selling: ₽" .. v:GetNWInt("playerTotalEarnedSell"))
				generalStats:AddOption("EXP Earned: " .. math.Round(v:GetNWInt("playerTotalXpEarned"), 0))
				generalStats:AddOption("EXP Earned From Kills: " .. math.Round(v:GetNWInt("playerTotalXpEarnedKill"), 0))
				generalStats:AddOption("EXP Earned From Extracting: " .. math.Round(v:GetNWInt("playerTotalXpEarnedExplore"), 0))
				generalStats:AddOption("Money Spent: ₽" .. v:GetNWInt("playerTotalMoneySpent"))
				generalStats:AddOption("Money Spent On Weapons: ₽" .. v:GetNWInt("playerTotalMoneySpentWep"))
				generalStats:AddOption("Money Spent On Ammo/Armor: ₽" .. v:GetNWInt("playerTotalMoneySpentItem"))
				generalStats:AddOption("Deaths By Suicide: " .. v:GetNWInt("playerDeathsSuicide"))
				generalStats:AddOption("Damage Inflicted: " .. v:GetNWInt("playerDamageGiven"))
				generalStats:AddOption("Damage Recieved: " .. v:GetNWInt("playerDamageRecieved"))

				local raidingStats = statsButton:AddSubMenu("Raiding Stats")
				raidingStats:AddOption("Survival Rate: " .. math.Round(v:GetNWInt("survivalRate"), 0) .. "%")
				raidingStats:AddOption("Raids Played: " .. v:GetNWInt("raidsPlayed"))
				raidingStats:AddOption("Extractions: " .. v:GetNWInt("raidsExtracted"))
				raidingStats:AddOption("Run Throughs: " .. v:GetNWInt("raidsRanThrough"))
				raidingStats:AddOption("Killed In Action: " .. v:GetNWInt("raidsDied"))

				local pvpStats = statsButton:AddSubMenu("PvP Stats")
				pvpStats:AddOption("AVG Kills Per Raid: " .. math.Round(v:GetNWInt("killsPerRaid"), 2))
				pvpStats:AddOption("Current Kill Streak: " .. v:GetNWInt("killStreak"))
				pvpStats:AddOption("Current Extract Streak: " .. v:GetNWInt("extractionStreak"))
				pvpStats:AddOption("Highest Kill Streak: " .. v:GetNWInt("highestKillStreak"))
				pvpStats:AddOption("Highest Extract Streak: " .. v:GetNWInt("highestExtractionStreak"))

				local taskingStats = statsButton:AddSubMenu("Tasking Stats")
				taskingStats:AddOption("Tasks Finished: " .. v:GetNWInt("dailiesCompleted") + v:GetNWInt("specialsCompleted"))
				taskingStats:AddOption("Daily Tasks Finished: " .. v:GetNWInt("dailiesCompleted"))
				taskingStats:AddOption("Special Tasks Finished: " .. v:GetNWInt("specialsCompleted"))

				Menu:AddSpacer()

				local copyMenu = Menu:AddSubMenu("Copy...")
				copyMenu:AddOption("Copy Name", function() SetClipboardText(v:GetName()) end):SetIcon("icon16/cut.png")
				copyMenu:AddOption("Copy SteamID", function() SetClipboardText(v:SteamID64()) end):SetIcon("icon16/cut.png")

				Menu:Open()
			end
		end

		ScoreboardDerma:Show()
		ScoreboardDerma:MakePopup()
		ScoreboardDerma:SetKeyboardInputEnabled(false)
	end
end

function GM:ScoreboardHide()
	if IsValid(ScoreboardDerma) then
		ScoreboardDerma:Hide()
	end
end