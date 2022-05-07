local Menu

local isSellMenu = false
local clientPlayer

local isPlayerInRaid = false

local stashClient

local stashTable

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

net.Receive("SellMenuTable",function (len, ply)

	tempTable = net.ReadTable()

	clientPlayer = tempTable[1]
	seller = tempTable[2]

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

	if clientPlayer != nil then
		isSellMenu = true
		--print (clientPlayer:GetName().." is not nil")
	end

	-- Moving on

	if (inPlayerMenu == false) then
		Menu = vgui.Create("DFrame")
		Menu:SetSize(860, 1080)
		Menu:Center()
		Menu:SetTitle("Escape From Garry's Mod")
		Menu:SetDraggable(false)
		Menu:ShowCloseButton(true)
		Menu:SetDeleteOnClose(false)
		Menu.Paint = function()
			surface.SetDrawColor(90, 90, 90, 50)
			surface.DrawRect(0, 0, Menu:GetWide(), Menu:GetTall())

			surface.SetDrawColor(40, 40, 40, 50)
			surface.DrawRect(0, 24, Menu:GetWide(), 1)
		end

		addButtons(Menu, isSellMenu, isPlayerInRaid, clientPlayer)

		inPlayerMenu = true

		gui.EnableScreenClicker(true)
		surface.PlaySound( "common/wpn_select.wav" )

		Menu.OnClose = function()

			if (inStashMenu == false) and (inMapVoteMenu == false) and (inRaidSummaryMenu == false) then
				inPlayerMenu = false

				gui.EnableScreenClicker(false)
				surface.PlaySound( "common/wpn_denyselect.wav" )

				inPlayerMenu = false

				clientPlayer = nil
				isSellMenu = false
				seller = nil
			else
				surface.PlaySound( "common/wpn_denyselect.wav" )

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
		draw.DrawText(LocalPlayer():GetName(), "DermaLarge", playerButton:GetWide() / 2.1, 10, Color(255, 255, 255, 255), 1)
	end
	playerButton.DoClick = function(playerButton)
		local playerPanel = Menu:Add("PlayerPanel")

		playerPanel.Paint = function()
			surface.SetDrawColor(50, 50, 50, 255)
			surface.DrawRect(0, 0, playerPanel:GetWide(), playerPanel:GetTall())
			surface.SetTextColor(255, 255, 255)

			-- Player Name
			surface.SetFont("Trebuchet24")
			surface.SetTextPos(5, 0)
			surface.DrawText(LocalPlayer():GetName())

			-- Stats Text
			surface.SetFont("Trebuchet24")
			surface.SetTextPos(5, 320)
			surface.DrawText("Your Stats")

			-- Player EXP and level
			local expToLevel = (LocalPlayer():GetNWInt("playerLvl") * 140) * 5.15

			surface.SetFont("Default")
			surface.SetTextPos(8, 35)
			surface.SetTextColor(228, 255, 0, 255)
			surface.DrawText("Level " .. LocalPlayer():GetNWInt("playerLvl"))

			surface.SetTextPos(58, 35)
			surface.SetTextColor(0, 255, 209 , 255)
			surface.DrawText("Experience " .. LocalPlayer():GetNWInt("playerExp") .. "/" .. expToLevel)

			-- Balance
			surface.SetTextPos(8, 55)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Roubles/Balance: " .. LocalPlayer():GetNWInt("playerMoney"))

			-- Stats (Kills)
			surface.SetTextPos(8, 350)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Total Kills: " .. LocalPlayer():GetNWInt("playerKills"))

			-- Stats (Deaths)
			surface.SetTextPos(8, 370)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Total Deaths: " .. LocalPlayer():GetNWInt("playerDeaths"))

			-- Stats (KDR)
			surface.SetTextPos(8, 390)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Kill/Death Ratio: " .. LocalPlayer():GetNWInt("playerKDR"))

			-- Stats (Total Earned)
			surface.SetTextPos(8, 410)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Total Roubles Earned: " .. LocalPlayer():GetNWInt("playerTotalEarned"))

			-- Stats (Total Roubles From Kills)
			surface.SetTextPos(8, 430)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Total Roubles Earned From Kills: " .. LocalPlayer():GetNWInt("playerTotalEarnedKill"))

			-- Stats (Total Roubles From Selling)
			surface.SetTextPos(8, 450)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Total Roubles Earned From Selling: " .. LocalPlayer():GetNWInt("playerTotalEarnedSell"))

			-- Stats (Total Experience Gained)
			surface.SetTextPos(252, 350)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Total Experience Gained: " .. LocalPlayer():GetNWInt("playerTotalXpEarned"))

			-- Stats (Total Experience Gained From Killing)
			surface.SetTextPos(252, 370)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Total Experience Gained From Kills: " .. LocalPlayer():GetNWInt("playerTotalXpEarnedKill"))

			-- Stats (Total Experience Gained From Exploration)
			surface.SetTextPos(252, 390)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Total Experience Gained From Exploration: " .. LocalPlayer():GetNWInt("playerTotalXpEarnedExplore"))

			-- Stats (Total Money Spent)
			surface.SetTextPos(252, 410)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Total Money Spent: " .. LocalPlayer():GetNWInt("playerTotalMoneySpent"))

			-- Stats (Total Money Spent On Weapons)
			surface.SetTextPos(252, 430)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Total Money Spent On Weapons: " .. LocalPlayer():GetNWInt("playerTotalMoneySpentWep"))

			-- Stats (Total Money Spent On Ammo/Armor)
			surface.SetTextPos(252, 450)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Total Money Spent On Ammo/Armor: " .. LocalPlayer():GetNWInt("playerTotalMoneySpentItem"))

			-- Stats (Deaths By Suicide)
			surface.SetTextPos(496, 350)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Total Deaths By Suicide: " .. LocalPlayer():GetNWInt("playerDeathsSuicide"))

			-- Stats (Damage Given)
			surface.SetTextPos(496, 370)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Damage Given: " .. LocalPlayer():GetNWInt("playerDamageGiven"))

			-- Stats (Damage Recieved)
			surface.SetTextPos(496, 390)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Damage Recieved: " .. LocalPlayer():GetNWInt("playerDamageRecieved"))

			-- Stats (Damage Healed)
			surface.SetTextPos(496, 410)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Damage Healed: " .. LocalPlayer():GetNWInt("playerDamageHealed"))

			-- Stats (Items Picked Up)
			surface.SetTextPos(496, 430)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Weapons Picked Up: " .. LocalPlayer():GetNWInt("playerItemsPickedUp"))

			-- Stats (Distance Travelled)
			surface.SetTextPos(496, 450)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Distance Travelled: " .. LocalPlayer():GetNWInt("playerDistance"))

		end
	end

	local playerButton = vgui.Create("DButton")
	playerButton:SetParent(Menu)
	playerButton:SetText("")
	playerButton:SetSize(100, 300)
	playerButton:SetPos(0, 400)
	playerButton.Paint = function()
		--Color of entire button
		surface.SetDrawColor(50, 50, 50, 255)
		surface.DrawRect(0, 0, playerButton:GetWide(), playerButton:GetTall())


		--Draw/write text
		draw.DrawText("HELP", "DermaLarge", playerButton:GetWide() / 2.1, 125, Color(80, 255, 255, 255), 1)
	end
	playerButton.DoClick = function(playerButton)
		local playerPanel = Menu:Add("PlayerPanel")

		playerPanel.Paint = function()
			surface.SetDrawColor(50, 50, 50, 255)
			surface.DrawRect(0, 0, playerPanel:GetWide(), playerPanel:GetTall())
			surface.SetTextColor(255, 255, 255, 255)

			-- Player Name
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 0)
			surface.DrawText("Welcome to Escape From Garry's Mod!")

			-- Help Text One
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 50)
			surface.DrawText("For the best experience, input these into your console.")

			-- Help Text Two
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 90)
			surface.DrawText("bind q +alt1    (Let's you lean to the left.)")

			-- Help Text Three
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 120)
			surface.DrawText("bind e +alt2    (Let's you lean to the right.)")

			-- Help Text Five
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 200)
			surface.DrawText("The button on the table at the end of the lobby will put you into")

			-- Help Text Six
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 225)
			surface.DrawText("the raid, if one is ongoing. If no raid is found, one will start.")

			-- Help Text Seven
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 275)
			surface.DrawText("The buttons on the computer terminals will let you access your")

			-- Help Text Eight
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 300)
			surface.DrawText("stash, you can store your weapons/items here safely.")

			-- Help Text Nine
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 350)
			surface.DrawText("The buttons on the wall near the spawn let you sell gear.")

			-- Help Text Ten
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 400)
			surface.DrawText("While in the lobby, press (F4) to access the shop!")

			-- Help Text Eleven
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 425)
			surface.DrawText("You can buy guns, ammo, armor, and other goodies from here!")

			-- Help Text Twelve
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 475)
			surface.DrawText("Your goal in raid is to go in, get loot, fight others, and get out.")

			-- Help Text Thirteen
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 500)
			surface.DrawText("You will lose any gear that you had if you die in a raid.")

			-- Help Text Fourteen
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 525)
			surface.DrawText("You can find loot anywhere around the map.")

			-- Help Text Fifteen
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 575)
			surface.DrawText("To exit a raid and stay alive, you need to find an extract.")

			-- Help Text Fifteen
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 600)
			surface.DrawText("Press your spawn menu key to check your list of extracts.")

			-- Help Text Sixteen
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 625)
			surface.DrawText("If you can extract from a raid, you can then put the loot you")

			-- Help Text Seventeen
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 650)
			surface.DrawText("found in your stash, or sell it for even more money.")

			-- Help Text Eighteen
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 700)
			surface.DrawText("Raids will last a total of 30 minutes, and you need to get out by")

			-- Help Text Ninteen
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 725)
			surface.DrawText("the end of the raid to survive! Anyone still in the raid when it")

			-- Help Text Twenty
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 750)
			surface.DrawText("ends will be killed, and will lose anything they had.")

			-- Help Text Twenty One
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 800)
			surface.DrawText("Most maps have special events that can be triggered by doing")

			-- Help Text Twenty One
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 825)
			surface.DrawText("specific things around the map!")

			-- Help Text Twenty Two
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 875)
			surface.DrawText("And while teaming is allowed, be aware that you can be")

			-- Help Text Twenty Three
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 900)
			surface.DrawText("betrayed at any time!")

			-- Help Text Twenty Four
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 950)
			surface.DrawText("EFGM is currently in BETA, and we appreciate you for")

			-- Help Text Twenty Five
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 975)
			surface.DrawText("trying it out, if you have any issues, contact us on discord.")

			-- Help Text Twenty Six
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 1020)
			surface.DrawText("          Portator#6582                                          Penial#3298")

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

		draw.DrawText("SKILLS", "DermaLarge", skillButton:GetWide() / 2.1, 10, Color(0, 165, 255, 255), 1)

	end

	skillButton.DoClick = function()

		local skillPanel = Menu:Add("SkillPanel")

		skillPanel.Paint = function()
			local enduranceExpToLevel = (LocalPlayer():GetNWInt("enduranceLevel") * 3)
			local strengthExpToLevel = (LocalPlayer():GetNWInt("strengthLevel") * 2)
			local charismaExpToLevel = (LocalPlayer():GetNWInt("charismaLevel") * 5)
			local covertExpToLevel = (LocalPlayer():GetNWInt("covertLevel") * 2)

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

			surface.SetDrawColor(50, 50, 50, 255)
			surface.DrawRect(0, 0, skillPanel:GetWide(), skillPanel:GetTall())
			surface.SetTextColor(255, 255, 255, 255)

			--Endurance
			surface.SetFont("DermaLarge")
			surface.SetTextPos(50, 50)
			surface.DrawText("Endurance : " .. " Level " .. LocalPlayer():GetNWInt("enduranceLevel"))

			surface.SetDrawColor(100, 100, 100, 255)
			surface.DrawRect(50, 100, 500, 30)

			surface.SetDrawColor(0, 255, 50, 255)
			surface.DrawRect(51, 102.5, 500 * (LocalPlayer():GetNWInt("enduranceExperience") / enduranceExpToLevel), 25)

			surface.SetTextPos(260, 100)
			surface.DrawText(enduranceProgressText)

			--Strength
			surface.SetFont("DermaLarge")
			surface.SetTextPos(50, 200)
			surface.DrawText("Strength : " .. " Level " .. LocalPlayer():GetNWInt("strengthLevel"))

			surface.SetDrawColor(100, 100, 100, 255)
			surface.DrawRect(50, 250, 500, 30)

			surface.SetDrawColor(0, 255, 50, 255)
			surface.DrawRect(51, 252.5, 500 * (LocalPlayer():GetNWInt("strengthExperience") / strengthExpToLevel), 25)

			surface.SetTextPos(260, 250)
			surface.DrawText(strengthProgressText)

			--Charisma
			surface.SetFont("DermaLarge")
			surface.SetTextPos(50, 350)
			surface.DrawText("Charisma : " .. "  Level " .. LocalPlayer():GetNWInt("charismaLevel"))

			surface.SetDrawColor(100, 100, 100, 255)
			surface.DrawRect(50, 400, 500, 30)

			surface.SetDrawColor(0, 255, 50, 255)
			surface.DrawRect(51, 402.5, 500 * (LocalPlayer():GetNWInt("charismaExperience") / charismaExpToLevel), 25)

			surface.SetTextPos(260, 400)
			surface.DrawText(charismaProgressText)

			--Covert Movement
			surface.SetFont("DermaLarge")
			surface.SetTextPos(50, 500)
			surface.DrawText("Covert Movement : " .. "  Level " .. LocalPlayer():GetNWInt("covertLevel"))

			surface.SetDrawColor(100, 100, 100, 255)
			surface.DrawRect(50, 550, 500, 30)

			surface.SetDrawColor(0, 255, 50, 255)
			surface.DrawRect(51, 552.5, 500 * (LocalPlayer():GetNWInt("covertExperience") / covertExpToLevel), 25)

			surface.SetTextPos(260, 550)
			surface.DrawText(covertProgressText)

			--Text below the skill progression stuffs

			surface.SetTextColor(255, 255, 255, 255)

			surface.SetTextPos(50, 140)
			surface.DrawText("Increases your walking and running speed.")

			surface.SetTextPos(50, 290)
			surface.DrawText("Increases your jump height.")

			surface.SetTextPos(50, 440)
			surface.DrawText("Decreases the prices of items in the shop.")

			surface.SetTextPos(50, 590)
			surface.DrawText("Increases your crouch walking speed.")
		end
	end

	local taskButton = vgui.Create("DButton")
	taskButton:SetParent(Menu)
	taskButton:SetText("")
	taskButton:SetSize(100, 50)
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

		net.Start("RequestTaskInfo")
		net.SendToServer()

		local taskPanel = Menu:Add("TaskPanel")

		function DrawTasks(taskInfo)

			taskPanel:Clear()

			local panelGap = 30

			local textColor = Color(0,0,0,255)

			local taskIncompleteColor = Color(90, 60, 60, 255)
			local taskCompleteColor = Color(90, 90, 120, 255)

			for k, v in pairs(taskInfo) do

				local taskCollapsible = vgui.Create("DCollapsibleCategory", taskPanel)
				taskCollapsible:Dock( TOP )
				taskCollapsible:SetSize( taskPanel:GetWide(), 450 )
				taskCollapsible:SetLabel(v[1])
				taskCollapsible:SetExpanded( true )	-- Start collapsed

				local taskInfoPanel = vgui.Create("DPanel", taskPanel)

				taskCollapsible:SetContents( taskInfoPanel )

				taskInfoPanel:Dock( FILL )
				taskInfoPanel:SetSize( taskPanel:GetWide(), 450 )

				taskInfoPanel.Paint = function()

					surface.SetDrawColor(80,80,80,255)
					surface.DrawRect(0, 0, taskInfoPanel:GetWide(), taskInfoPanel:GetTall())

					draw.SimpleText( v[1], "DermaLarge", taskInfoPanel:GetWide() / 2, 30, textColor, 1 )

					draw.SimpleText( v[2], "DermaDefaultBold", taskInfoPanel:GetWide() / 2, 70, textColor, 1 )

					draw.SimpleText( "Client:", "DermaLarge", taskInfoPanel:GetWide() / 2, 100, textColor, 1 )

					draw.SimpleText( v[4], "DermaDefaultBold", taskInfoPanel:GetWide() / 2, 130, textColor, 1 )

					draw.SimpleText( "Mission Rewards:", "DermaLarge", taskInfoPanel:GetWide() / 2, 160, textColor, 1 )

					draw.SimpleText( v[5], "DermaDefaultBold", taskInfoPanel:GetWide() / 2, 190, textColor, 1 )

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

						draw.SimpleText( taskObjectivesExploded[l], "DermaDefaultBold", objectivePanel:GetWide() / 2, objectivePanel:GetTall() / 2, textColor, 1 )

					end

					completeButtonPosition = panelOffset

				end

				completeButtonPosition = completeButtonPosition + 110

				if tonumber(v[8]) == 1 then

					print("Task completed = " .. v[8])

					local taskCompleteButton = vgui.Create("DButton", taskInfoPanel)
					taskCompleteButton:SetText( "Complete Task" )
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

			local entityCategory

			local entityList

			if sellMenuBool == false then


				entityCategory = vgui.Create("DCollapsibleCategory", shopPanel)
				-- entityCategory:SetPos(0, 0)
				-- entityCategory:SetSize(shopPanel:GetWide(), 100)
				entityCategory:Dock( TOP )
				entityCategory:SetLabel("Ammo/Armor/Crates")

				entityList = vgui.Create("DIconLayout", entityCategory)
				-- entityList:SetPos(0, 20)
				-- entityList:SetSize(entityCategory:GetWide(), entityCategory:GetTall())
				entityList:Dock( TOP )
				entityList:SetSpaceY(5)
				entityList:SetSpaceX(5)
			end

			local weaponCategory = vgui.Create("DCollapsibleCategory", shopPanel)
			-- weaponCategory:SetPos(0, 230)
			-- weaponCategory:SetSize(shopPanel:GetWide(), 200)
			weaponCategory:Dock( TOP )
			weaponCategory:SetLabel("Firearms/Weapons")

			local weaponList = vgui.Create("DIconLayout", weaponCategory)
			-- weaponList:SetPos(0, 20)
			-- weaponList:SetSize(weaponCategory:GetWide(), weaponCategory:GetTall())
			weaponList:Dock( TOP )
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
					icon:SetToolTip(v[3] .. "\nCategory: " .. v[7] .. "\nRarity: " .. v[6] .. "\nSell Price: " .. math.Round(v[4] * sellPriceMultiplier, 0))

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

					icon:SetModel(v["Model"])
					icon:SetToolTip(v["PrintName"] .. "\nCost: " .. v["Cost"])
					entityList:Add(icon)

					icon.DoClick = function(icon)
						LocalPlayer():ConCommand("buy_entity " .. v["ClassName"])
					end
				end

				for k, v in pairs(weaponsArr) do

					-- Creates buttons for the weapons

					local icon = vgui.Create("SpawnIcon", weaponList)
					icon:SetModel(v[1])
					icon:SetToolTip(v[3] .. "\nCategory: " .. v[7] .. "\nRarity: " .. v[6] .. "\nCost: " .. math.Round(v[4] *  LocalPlayer():GetNWInt("charismaEffect"), 0) .. "\nLevel Req: " .. v[5])
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
	
			stashMenuPanel.Paint = function()
				surface.SetDrawColor(50, 50, 50, 255)
				surface.DrawRect(0, 0, stashMenuPanel:GetWide(), stashMenuPanel:GetTall())
				surface.SetTextColor(255, 255, 255, 255)
	
				surface.SetFont("DermaLarge")
				surface.SetTextPos(260, 250)
				surface.DrawText("Upgrade Stash")

				surface.SetTextPos(40, 300)
				surface.DrawText("For each level, you gain an addition 6 slots in your stash!")

				surface.SetTextPos(230, 375)
				surface.DrawText("Current stash level: " .. LocalPlayer():GetNWInt("playerStashLevel"))

				surface.SetTextPos(230, 415)
				surface.DrawText("Current ₽ Count: " .. LocalPlayer():GetNWInt("playerMoney"))

				if (LocalPlayer():GetNWInt("stashMaxed") == 0) then
					surface.SetTextPos(200, 600)
					surface.DrawText("Required ₽ to upgrade: " .. LocalPlayer():GetNWInt("playerRoubleForStashUpgrade"))
				end

				surface.SetTextPos(200, 640)
				surface.DrawText("Current stash limt : " .. LocalPlayer():GetNWInt("playerStashLimit") .. " / " .. "60")

			end

			if (LocalPlayer():GetNWInt("stashMaxed") == 0) then
				local doStashUpgrade = vgui.Create("DButton")
				doStashUpgrade:SetParent(Menu)
				doStashUpgrade:SetText("")
				doStashUpgrade:SetSize(225, 50)
				doStashUpgrade:SetPos(340, 500)
				doStashUpgrade.Paint = function()
					--Color of entire button
					surface.SetDrawColor(150, 150, 150, 10)
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

			prestigePanel.Paint = function()
				surface.SetDrawColor(50, 50, 50, 255)
				surface.DrawRect(0, 0, prestigePanel:GetWide(), prestigePanel:GetTall())

				surface.SetTextColor(255, 0, 0, 255)

				surface.SetFont("DermaLarge")
				surface.SetTextPos(290, 360)
				surface.DrawText("PRESTIGE")

				surface.SetTextColor(255, 255, 255, 255)

				surface.SetFont("DermaLarge")
				surface.SetTextPos(100, 410)
				surface.DrawText("Once you hit level 32, you can prestige, which")

				surface.SetTextPos(25, 440)
				surface.DrawText("resets your level to get a permanent rouble boost until wipe!")

				surface.SetTextPos(195, 600)
				surface.DrawText("Current ₽ Multiplier:")

				surface.SetTextColor(255, 255, 0, 255)
				surface.SetTextPos(440, 600)
				surface.DrawText(LocalPlayer():GetNWInt("playerRoubleMulti") .. "x")

				surface.SetTextColor(255, 255, 255, 255)
				surface.SetTextPos(195, 650)
				surface.DrawText("Current Prestige: " .. (LocalPlayer():GetNWInt("playerPrestige")))

				surface.SetTextPos(195, 700)
				surface.DrawText("Current Level: " .. (LocalPlayer():GetNWInt("playerLvl")))
			end

			local doPrestigeButton = vgui.Create("DButton")
			doPrestigeButton:SetParent(Menu)
			doPrestigeButton:SetText("")
			doPrestigeButton:SetSize(225, 50)
			doPrestigeButton:SetPos(340, 550)
			doPrestigeButton.Paint = function()
				--Color of entire button
				surface.SetDrawColor(150, 150, 150, 10)
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

		end
	end


end

--Player Panel

PANEL = {} --Creates empty panel

function PANEL:Init() -- initializes the panel
	self:SetSize(760, 1080)
	self:SetPos(100, 25)
end

function PANEL:Paint(w, h)
	draw.RoundedBox(0, 0, 0, w, h, Color(125, 125, 125, 255))
end

vgui.Register("PlayerPanel", PANEL, "Panel")

--End player panel


--Shop Panel

PANEL = {} --Creates empty panel

function PANEL:Init() -- initializes the panel
	self:SetSize(760, 1080)
	self:SetPos(100, 25)
end

function PANEL:Paint(w, h)
	draw.RoundedBox(0, 0, 0, w, h, Color(125, 125, 125, 255))
end

vgui.Register("ShopPanel", PANEL, "Panel")

--Task Panel

PANEL = {} --Creates empty panel

function PANEL:Init() -- initializes the panel
	self:SetSize(760, 1080)
	self:SetPos(100, 25)
end

function PANEL:Paint(w, h)
	draw.RoundedBox(0, 0, 0, w, h, Color(125, 125, 125, 255))
end

vgui.Register("TaskPanel", PANEL, "Panel")

--End task panel

--Skills Panel

PANEL = {} --Creates empty panel

function PANEL:Init() -- initializes the panel
	self:SetSize(760, 1080)
	self:SetPos(100, 25)
end

function PANEL:Paint(w, h)
	draw.RoundedBox(0, 0, 0, w, h, Color(125, 125, 125, 0))
end

vgui.Register("SkillPanel", PANEL, "Panel")

--End skills panel

--Prestige Panel

PANEL = {} --Creates empty panel

function PANEL:Init() -- initializes the panel
	self:SetSize(760, 1080)
	self:SetPos(100, 25)
end

function PANEL:Paint(w, h)
	draw.RoundedBox(0, 0, 0, w, h, Color(125, 125, 125, 255))
end

vgui.Register("PrestigePanel", PANEL, "Panel")

--End prestige panel

--Stash menu panel

PANEL = {} --Creates empty panel

function PANEL:Init() -- initializes the panel
	self:SetSize(760, 1080)
	self:SetPos(100, 25)
end

function PANEL:Paint(w, h)
	draw.RoundedBox(0, 0, 0, w, h, Color(125, 125, 125, 255))
end

vgui.Register("StashMenuPanel", PANEL, "Panel")

--End stash meun panel

-- wow this is why i had to merge the fucking stash menu into this jesus christ im dumb
-- actually maybe not idk, im autistic im not a rocket scientist

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
		surface.PlaySound( "common/wpn_select.wav" )

		inStashMenu = true

		StashMenu.OnClose = function()
			if (inPlayerMenu == false) and (inMapVoteMenu == false) and (inRaidSummaryMenu == false) then
				inStashMenu = false

				gui.EnableScreenClicker(false)
				surface.PlaySound( "common/wpn_denyselect.wav" )
			else
				inStashMenu = false

				surface.PlaySound( "common/wpn_denyselect.wav" )
			end
		end

		inventoryTable = stashClient:GetWeapons()

		local playerInventoryPanel = vgui.Create("DPanel", StashMenu)
		playerInventoryPanel:Dock( LEFT )
		playerInventoryPanel:SetSize(96, 0)

		function playerInventoryPanel:Paint(w, h)

			draw.RoundedBox(0, 0, 0, w, h, Color( 120, 120, 120, 255 ))

		end

		local optionsPanel = vgui.Create("DPanel", StashMenu)

		optionsPanel:Dock( RIGHT )
		optionsPanel:SetSize(150, 50)

		function optionsPanel:Paint(w, h)

			draw.RoundedBox(0, 0, 0, w, 150, Color( 120, 120, 120, 255 ))


			local Avatar = vgui.Create("AvatarImage", optionsPanel)
			Avatar:SetSize(140, 140)
			Avatar:SetPos(5, 5)
			Avatar:SetPlayer(LocalPlayer(), 140)


			draw.DrawText(client:GetName(), "DermaLarge", 0, 200, Color(255, 255, 255, 255))

			if (client:GetNWInt("playerPrestige") >= 1) then
				draw.DrawText("Prestige: " .. client:GetNWInt("playerPrestige"), "DermaLarge", 0, 300, Color(255, 255, 255, 255))
			end

			draw.DrawText("Level: " .. client:GetNWInt("playerLvl"), "DermaLarge", 0, 300, Color(255, 255, 255, 255))
			draw.DrawText("EXP: \n" .. client:GetNWInt("playerExp") .. "/" .. expToLevel, "DermaLarge", 0, 340, Color(255, 255, 255, 255))
			draw.DrawText("₽ " .. client:GetNWInt("playerMoney"), "DermaLarge", 0, 420, Color(255, 255, 255, 255))

			draw.DrawText("Kills: " .. client:GetNWInt("playerKills"), "DermaLarge", 0, 460, Color(255, 255, 255, 255))
			draw.DrawText("Deaths:" .. client:GetNWInt("playerDeaths"),"DermaLarge", 0, 500, Color(255, 255, 255, 255))
			draw.DrawText("KDR: " .. math.Round(client:GetNWInt("playerKDR"), 2), "DermaLarge", 0, 540, Color(255, 255, 255, 255))

			draw.DrawText("Stash Level " .. client:GetNWInt("playerStashLevel"), "Trebuchet24", 0, 610, Color(255, 255, 255, 255))
			draw.DrawText(" Upgrade your \n stash in the F4 \n menu!", "Trebuchet24", -5, 650, Color(255, 255, 255, 255))

			draw.RoundedBox(0, 0, 750, w, 350, Color( 120, 120, 120, 255 ))
			draw.RoundedBox(0, 145, 150, 5, 650, Color( 120, 120, 120, 255 ))

		end

		local separatePanel = vgui.Create("DPanel", StashMenu)
		separatePanel:Dock( LEFT )
		separatePanel:SetSize(30, 0)

		function separatePanel:Paint(w, h)

			draw.RoundedBox(0, 0, 0, w, h, Color( 30, 30, 30, 255 ))

		end

		local separateTwoPanel = vgui.Create("DPanel", StashMenu)
		separateTwoPanel:Dock( RIGHT )
		separateTwoPanel:SetSize(30, 0)

		function separateTwoPanel:Paint(w, h)

			draw.RoundedBox(0, 0, 0, w, h, Color( 30, 30, 30, 255 ))

		end

		local stashPanel = vgui.Create("DPanel", StashMenu)
		stashPanel:Dock( FILL )

		function stashPanel:Paint(w, h)

			draw.RoundedBox(0, 0, 0, w, h, Color( 120, 120, 120, 255 ))

		end

		local stashIconLayout = vgui.Create("DIconLayout", stashPanel)
		stashIconLayout:Dock( FILL )
		stashIconLayout:SetSpaceY(5)
		stashIconLayout:SetSpaceX(5)

		local inventoryIconLayout = vgui.Create("DIconLayout", playerInventoryPanel)
		inventoryIconLayout:Dock( FILL )
		inventoryIconLayout:SetSpaceY(5)
		inventoryIconLayout:SetSpaceX(5)

		local ammoIconLayout = vgui.Create("DIconLayout", ammoInventoryPanel)
		ammoIconLayout:Dock( FILL )
		ammoIconLayout:SetSpaceY(5)
		ammoIconLayout:SetSpaceX(5)

		function DoInventory()

			--local avatar = vgui.Create("AvatarImage")

			--avatar:SetSize(96, 96)
			--avatar:SetPos(101, 635)
			--avatar:SetPlayer(LocalPlayer(), 96)

			for k, v in pairs(stashClient:GetWeapons()) do
				-- Creates buttons for the weapons

				if weapons.Get( v:GetClass() ) == nil then return end

				local weaponInfo = weapons.Get( v:GetClass() )

				-- PrintTable(stashClient:GetWeapons())

				local wepName

				if weaponInfo["TrueName"] == nil then wepName = weaponInfo["PrintName"] else wepName = weaponInfo["TrueName"] end

				local icon = vgui.Create("SpawnIcon", stashIconLayout)
				icon:SetModel(weaponInfo["WorldModel"])
				icon:SetToolTip(wepName)
				icon:SetSize(96, 96)

				function icon:Paint(w, h)

					draw.RoundedBox( 0, 0, 0, w, h, Color( 80, 80, 80, 255 ) )
					draw.RoundedBox( 0, 0, 75, w, h - 75, Color( 40, 40, 40, 255 ) )
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

					surface.PlaySound( "UI/buttonclick.wav" )

					-- icon:Remove()

				end
			end

			-- PrintTable(LocalPlayer():GetAmmo())

			-- for k, v in pairs(LocalPlayer():GetAmmo()) do
			-- 	-- Creates buttons for the weapons

			-- 	if v == nil then print("ammo is nil") return end

			-- 	local ammoName = game.GetAmmoName(v)
			-- 	local ammoAmount = LocalPlayer():GetAmmoCount(v)

			-- 	if ammoName == nil then print("cannot find ammo name") return end

			-- 	print("starting on ammo icon")

			-- 	local icon = vgui.Create("SpawnIcon", ammoIconLayout)
			-- 	icon:SetModel(ammoName["WorldModel"])
			-- 	icon:SetToolTip(ammoName)
			-- 	icon:SetSize(96, 96)

			-- 	function icon:Paint(w, h)

			-- 		draw.RoundedBox( 0, 0, 0, w, h, Color( 80, 80, 80, 255 ) )
			-- 		draw.RoundedBox( 0, 0, 75, w, h - 75, Color( 40, 40, 40, 255 ) )
			-- 		draw.SimpleText(ammoName.." x"..ammoAmount, "DermaDefault", w/2, 80, Color(255, 255, 255, 255), 1)

			-- 	end

			-- 	print("adding ammo to ammo icon layout")
			-- 	ammoIconLayout:Add(icon)

			-- icon.DoClick = function(icon)

			-- end

			-- end

			net.Start( "RequestStash" )
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
					icon:SetToolTip(wepName)
					icon:SetSize(96, 96)

					function icon:Paint(w, h)

						-- Weapon Name
						draw.RoundedBox( 0, 0, 0, w, h, Color( 80, 80, 80, 255 ) )
						draw.RoundedBox( 0, 0, 75, w, h - 75, Color( 40, 40, 40, 255 ) )
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

	local inRaidColor = 	Color(255, 50, 50, 255)		-- Red
	local outRaidColor = 	Color(50, 255, 50, 255)		-- Green
	local deadColor = 		Color(200, 200, 200, 255)	-- Gray

	local width =			1200
	local height =			1000

	local margin = 			10

	-- Basic menu shit

	teamMenuFrame = vgui.Create( "DFrame" )
	teamMenuFrame:SetPos( (ScrW() / 2) - (width / 2), (ScrH() / 2) - (height / 2) ) 
	teamMenuFrame:SetSize( width, height ) 
	teamMenuFrame:SetTitle( "Team Menu" ) 
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
	teamBrowserPanel:SetSize(300, 0 )
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

			local teamNameEntry = vgui.Create( "DTextEntry", createTeamPanel )
			teamNameEntry:Dock(TOP)
			teamNameEntry:DockMargin( margin, margin, margin, margin )
			teamNameEntry:SetSize(0, 50)
			teamNameEntry:SetPlaceholderText(client:GetName() .. "'s Team")

			local teamPasswordEntry = vgui.Create( "DTextEntry", createTeamPanel )
			teamPasswordEntry:Dock(TOP)
			teamPasswordEntry:DockMargin( margin, margin, margin, margin )
			teamPasswordEntry:SetSize(0, 50)
			teamPasswordEntry:SetPlaceholderText(client:GetName() .. "'s Password (Leave blank to make team public!)")

			local createTeamButton = vgui.Create( "DButton", createTeamPanel )
			createTeamButton:Dock(TOP)
			createTeamButton:DockMargin( margin, margin, margin, margin )
			createTeamButton:SetSize(0, 50)
			createTeamButton:SetText("Create Team")

			createTeamButton.DoClick = function(self)

				local teamName = teamNameEntry:GetText()
				local teamPassword = teamPasswordEntry:GetText()
				if teamName == "" then teamName = client:GetName() .. "s_Team" end

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

				print("Name is " .. teamName .. ", password is " .. teamPassword .. ".")

				client:ConCommand("party_create " .. teamName .. " " .. teamPassword .. "")

				surface.PlaySound( "UI/buttonclick.wav" )

			end

		elseif currentTeamName != "" then

			-- If the player is already in a team

			local leaveTeamPanel = vgui.Create( "DPanel", teamInfoPanel )
			leaveTeamPanel:Dock(BOTTOM)
			leaveTeamPanel:DockMargin( margin, margin, margin, margin )
			leaveTeamPanel:SetSize(0, 70)

			leaveTeamPanel.Paint = function(self, w, h)
				draw.RoundedBox( 0, 0, 0, w, h, primaryColor )
			end

			local leaveTeamButton = vgui.Create( "DButton", leaveTeamPanel )
			leaveTeamButton:Dock(BOTTOM)
			leaveTeamButton:DockMargin( margin, margin, margin, margin )
			leaveTeamButton:SetSize(0, 50)
			leaveTeamButton:SetText("Leave Team")

			leaveTeamButton.DoClick = function(self)

				client:ConCommand("party_leave")

				surface.PlaySound( "UI/buttonclick.wav" )

			end

		end


		-- SUB PANEL: Search Panel (Search for teams)

		local searchPanel = vgui.Create( "DPanel", teamBrowserPanel )
		searchPanel:Dock( TOP )
		searchPanel:SetSize( 0, 40 )
		searchPanel:DockMargin( margin, margin, margin, margin )
	
		searchPanel.Paint = function(self, w, h)
			draw.RoundedBox( 0, 0, 0, w, h, secondaryColor )
		end
		
		local searchEntry = vgui.Create( "DTextEntry", searchPanel )
		searchEntry:Dock( FILL )
		searchEntry:SetPlaceholderText( "Search Teams (Placeholder, doesn't work yet)" )

		searchEntry.OnEnter = function()

			client:PrintMessage(3, "Can you read???")

		end
		
		-- SUB PANEL: Team Display Panel (Shows the teams you can join)

		local teamDisplayPanel = vgui.Create( "DPanel", teamBrowserPanel )
		teamDisplayPanel:Dock( FILL )
		teamDisplayPanel:SetSize( 0, 250 )
		teamDisplayPanel:DockMargin( margin, margin, margin, margin )
	
		teamDisplayPanel.Paint = function(self, w, h)
			draw.RoundedBox( 0, 0, 0, w, h, secondaryColor )
		end

		local teamDisplayScroller = vgui.Create( "DScrollPanel", teamDisplayPanel )
		teamDisplayScroller:Dock( FILL )

		if FindAllTeams() != nil then

			for k, v in pairs( FindAllTeams() ) do

				local teamExamplePanel = vgui.Create( "DPanel", teamDisplayScroller )
				teamExamplePanel:Dock( TOP )
				teamExamplePanel:DockMargin(5, 5, 5, 5)
				teamExamplePanel:SetSize( 0, 70 )
	
				teamExamplePanel.Paint = function(self, w, h)
					draw.RoundedBox( 0, 0, 0, w, h, primaryColor )
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

					local joinTeamPanel = vgui.Create( "DPanel", teamExamplePanel )
					joinTeamPanel:Dock( BOTTOM )
					joinTeamPanel:DockMargin( 5, 5, 5, 5 )
					joinTeamPanel:SetSize( 0, 25 )

					joinTeamPanel.Paint = function(self, w, h)
						draw.RoundedBox( 0, 0, 0, w, h, primaryColor )
						draw.SimpleText("You are in this team", "DermaDefault", w / 2, h / 2, whiteColor, 1, 1)
					end
		
					

				elseif v != client:GetNWString("playerTeam") then

					-- If they are not in this team

					local joinTeamPassword = vgui.Create( "DTextEntry", teamExamplePanel )
					joinTeamPassword:Dock( BOTTOM )
					joinTeamPassword:DockMargin( 5, 5, 5, 5 )
					joinTeamPassword:SetSize( 0, 25 )
					joinTeamPassword:SetPlaceholderText("Password for " .. string.Replace(v, "_", " "))
		
					joinTeamPassword.OnEnter = function(self)
		
						client:ConCommand("party_join " .. v .. " " .. string.Replace(self:GetText(), " ", "_"))

						surface.PlaySound( "UI/buttonclick.wav" )
		
					end

				end

			end

		end

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
	local whiteColor = 		Color(250, 250, 250, 255)
	local offWhiteColor = 	Color(200, 200, 200, 255)

	local primaryColor =	Color(30, 30, 30, 255)
	local secondaryColor =	Color(100, 100, 100, 255)

	local inRaidColor = 	Color(255, 50, 50, 255)		-- Red
	local outRaidColor = 	Color(50, 255, 50, 255)		-- Green
	local deadColor = 		Color(200, 200, 200, 255)		-- Gray

	local width =			600
	local height =			1000

	local margin = 			10

	local raidMenuFrame = vgui.Create( "DFrame" )
	raidMenuFrame:SetPos( (ScrW() / 2) - (width / 2), (ScrH() / 2) - (height / 2) ) 
	raidMenuFrame:SetSize( width, height ) 
	raidMenuFrame:SetTitle( "Raid Menu" ) 
	raidMenuFrame:SetVisible( true ) 
	raidMenuFrame:SetDraggable( false ) 
	raidMenuFrame:ShowCloseButton( true ) 
	raidMenuFrame:MakePopup()

	-- Other shit

	raidMenuFrame.Paint = function(self, w, h)
		draw.RoundedBox( 0, 0, 0, w, h, blackColor )
	end

	local raidMenuPanel = vgui.Create( "DPanel", raidMenuFrame )
	raidMenuPanel:Dock( BOTTOM )
	raidMenuPanel:SetSize(0, height - 40)

	raidMenuPanel.Paint = function(self, w, h)

		draw.RoundedBox( 0, 0, 0, w, h, primaryColor )

	end

	-- MAIN PANEL: The time has come text lol. Idk, it builds suspense or something. Fuck dude, get off my back man, tarky does it, im gonna do it. Fuck you, and fuck off, and leave me to my luas

	local topTextPanel = vgui.Create( "DPanel", raidMenuPanel )
	topTextPanel:Dock( TOP )
	topTextPanel:DockMargin(margin, margin, margin, margin)
	topTextPanel:SetSize(0, 80)

	topTextPanel.Paint = function(self, w, h)

		draw.RoundedBox( 0, 0, 0, w, h, secondaryColor )

		draw.SimpleText("THE TIME HAS COME", "DermaLarge", w / 2, h / 2, primaryColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	end

	-- MAIN PANEL: Raid Info Panel (shit like your team, raid time, your pmc, and a big ol' button for entering the raid)

	local raidInfoPanel = vgui.Create( "DPanel", raidMenuPanel )
	raidInfoPanel:Dock( FILL )
	raidInfoPanel:DockMargin(margin, margin, margin, margin)

	raidInfoPanel.Paint = function(self, w, h)

		draw.RoundedBox( 0, 0, 0, w, h, secondaryColor )

		if client:GetNWBool("teamLeader") == true and client:GetNWString("playerTeam") then

			draw.SimpleText(client:GetName(), "DermaLarge", w / 2, 50, primaryColor, TEXT_ALIGN_CENTER)
			draw.SimpleText("You are the party leader", "DermaDefault", w / 2, 30, primaryColor, TEXT_ALIGN_CENTER)
			
		elseif client:GetNWBool("teamLeader") == false then

			draw.SimpleText(client:GetName(), "DermaLarge", w / 2, 50, primaryColor, TEXT_ALIGN_CENTER)
			draw.SimpleText("You are a member of a party", "DermaDefault", w / 2, 30, primaryColor, TEXT_ALIGN_CENTER)

		end

		draw.RoundedBox( 0, 290 - 64 - 15, 100 - 15, 128 + 30, 128 + 30, primaryColor )

	end

	local playerAvatar = vgui.Create( "AvatarImage", raidInfoPanel )
	playerAvatar:SetSize( 128, 128 )
	playerAvatar:SetPos( 290 - 64, 100 )
	playerAvatar:SetPlayer( LocalPlayer(), 128 )

	local playerModelDisplay = vgui.Create( "DModelPanel", raidInfoPanel )
	playerModelDisplay:SetSize(500, 500)
	playerModelDisplay:SetPos(290 - 250, 250)
	playerModelDisplay:SetModel( client:GetModel() )

	local enterRaidButton = vgui.Create("DButton", raidInfoPanel)

	if client:GetNWBool("teamLeader") == true and client:GetNWString("playerTeam") then

		enterRaidButton:Dock( BOTTOM )
		enterRaidButton:DockMargin(margin, margin, margin, margin)
		enterRaidButton:SetSize(0, 70)
		enterRaidButton:SetText("Enter the Raid")
		
	elseif client:GetNWBool("teamLeader") == false then

		enterRaidButton:Dock( BOTTOM )
		enterRaidButton:DockMargin(margin, margin, margin, margin)
		enterRaidButton:SetSize(0, 70)
		enterRaidButton:SetText("Enter the Raid by Yourself")

	end

	enterRaidButton.DoClick = function(self)

		-- enter raid blah blah blah

		surface.PlaySound( "UI/buttonclick.wav" )

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