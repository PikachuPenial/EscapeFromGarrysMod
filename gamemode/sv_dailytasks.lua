--Tracks and rewards people who complete daily/weekly tasks

function checkForElimination(ply)
	local expToLevel = (ply:GetNWInt("playerLvl") * 140) * 5.15
	local expReward = math.Round(expToLevel / 6), 1
	local curKills = ply:GetNWInt("mapKills")

	if (curKills >= 6) and (ply:GetNWInt("eliminationComplete") == 0) then
		if (ply:GetNWInt("playerLvl") < 26) then
			ply:SetNWInt("playerExp", (ply:GetNWInt("playerExp") + expReward) * (ply:GetNWInt("loyaltyEffect")))
			ply:SetNWInt("playerMoney", (ply:GetNWInt("playerMoney") + 5000) * (ply:GetNWInt("loyaltyEffect")))
			ply:SetNWInt("dailiesCompleted", ply:GetNWInt("dailiesCompleted") + 1)
			ply:SetNWInt("eliminationComplete", 1)
		else
			ply:SetNWInt("playerMoney", (ply:GetNWInt("playerMoney") + 5000) * (ply:GetNWInt("loyaltyEffect")))
			ply:SetNWInt("dailiesCompleted", ply:GetNWInt("dailiesCompleted") + 1)
			ply:SetNWInt("eliminationComplete", 1)
		end

		checkForLevel(ply)
		dailyLeveling(ply)
		ply:PrintMessage(HUD_PRINTCENTER, "You have completed the Elimination task.", Color(85, 0, 255, 255), 0)
	end
end

function checkForSuccessfulOperations(ply)
	local expToLevel = (ply:GetNWInt("playerLvl") * 140) * 5.15
	local expReward = math.Round(expToLevel / 6), 1
	local curExtracts = ply:GetNWInt("mapExtracts")

	if (curExtracts >= 2) and (ply:GetNWInt("successfulOperationsComplete") == 0) then
		if (ply:GetNWInt("playerLvl") < 26) then
			ply:SetNWInt("playerExp", (ply:GetNWInt("playerExp") + expReward) * (ply:GetNWInt("loyaltyEffect")))
			ply:SetNWInt("playerMoney", (ply:GetNWInt("playerMoney") + 5000) * (ply:GetNWInt("loyaltyEffect")))
			ply:SetNWInt("dailiesCompleted", ply:GetNWInt("dailiesCompleted") + 1)
			ply:SetNWInt("successfulOperationsComplete", 1)
		else
			ply:SetNWInt("playerMoney", (ply:GetNWInt("playerMoney") + 5000) * (ply:GetNWInt("loyaltyEffect")))
			ply:SetNWInt("dailiesCompleted", ply:GetNWInt("dailiesCompleted") + 1)
			ply:SetNWInt("successfulOperationsComplete", 1)
		end

		checkForLevel(ply)
		dailyLeveling(ply)
		ply:PrintMessage(HUD_PRINTCENTER, "You have completed the Successful Operations task.", Color(85, 0, 255, 255), 0)
	end
end

function checkForWeekly(ply)
	local curWeekly = ply:GetNWInt("weeklyDistance")

	if (curWeekly >= 3000) and (ply:GetNWInt("weeklyDistanceComplete") == 0) then
		ply:SetNWInt("playerMoney", (ply:GetNWInt("playerMoney") + 50000) * ply:GetNWInt("loyaltyEffect"))
		ply:SetNWInt("weeklyDistanceComplete", 1)
		ply:SetNWInt("specialsCompleted", ply:GetNWInt("specialsCompleted") + 1)

		checkForLevel(ply)
		weeklyLeveling(ply)
		checkForKappa(ply)
		ply:PrintMessage(HUD_PRINTCENTER, "You have completed the Rangefinder task.", Color(85, 0, 255, 255), 0)
	end
end

function checkForWeeklyTwo(ply)
	local curWeeklyTwo = ply:GetNWInt("weeklyExtracts")

	if (curWeeklyTwo >= 10) and (ply:GetNWInt("weeklyExtractsComplete") == 0) then
		ply:SetNWInt("playerMoney", (ply:GetNWInt("playerMoney") + 60000) * ply:GetNWInt("loyaltyEffect"))
		ply:SetNWInt("weeklyExtractsComplete", 1)
		ply:SetNWInt("specialsCompleted", ply:GetNWInt("specialsCompleted") + 1)
		ply:SetNWInt("kappaProgress", ply:GetNWInt("kappaProgress") + 1)

		checkForLevel(ply)
		weeklyLeveling(ply)
		checkForKappa(ply)
		ply:PrintMessage(HUD_PRINTCENTER, "You have completed the Wanted task.", Color(85, 0, 255, 255), 0)
	end
end

function checkForWeeklyThree(ply)
	local curWeeklyThree = ply:GetNWInt("weeklyNuclear")

	if (curWeeklyThree >= 1) and (ply:GetNWInt("weeklyNuclearComplete") == 0) then
		ply:SetNWInt("playerMoney", (ply:GetNWInt("playerMoney") + 70000) * ply:GetNWInt("loyaltyEffect"))
		ply:SetNWInt("weeklyNuclearComplete", 1)
		ply:SetNWInt("specialsCompleted", ply:GetNWInt("specialsCompleted") + 1)
		ply:SetNWInt("kappaProgress", ply:GetNWInt("kappaProgress") + 1)

		checkForLevel(ply)
		weeklyLeveling(ply)
		checkForKappa(ply)
		ply:PrintMessage(HUD_PRINTCENTER, "You have completed the Nuclear task.", Color(85, 0, 255, 255), 0)
	end
end

function checkForWeeklyFour(ply)
	local curWeeklyFour = ply:GetNWInt("weeklyAddict")

	if (curWeeklyFour >= 10) and (ply:GetNWInt("weeklyAddictComplete") == 0) then
		ply:SetNWInt("playerMoney", (ply:GetNWInt("playerMoney") + 40000) * ply:GetNWInt("loyaltyEffect"))
		ply:SetNWInt("weeklyAddictComplete", 1)
		ply:SetNWInt("specialsCompleted", ply:GetNWInt("specialsCompleted") + 1)
		ply:SetNWInt("kappaProgress", ply:GetNWInt("kappaProgress") + 1)

		checkForLevel(ply)
		weeklyLeveling(ply)
		checkForKappa(ply)
		ply:PrintMessage(HUD_PRINTCENTER, "You have completed the Addiction task.", Color(85, 0, 255, 255), 0)
	end
end

function checkForWeeklyFive(ply)
	local curWeeklyFive = ply:GetNWInt("shooterBorn")

	if (curWeeklyFive >= 2) and (ply:GetNWInt("shooterBornComplete") == 0) then
		ply:SetNWInt("playerMoney", (ply:GetNWInt("playerMoney") + 70000) * ply:GetNWInt("loyaltyEffect"))
		ply:SetNWInt("shooterBornComplete", 1)
		ply:SetNWInt("specialsCompleted", ply:GetNWInt("specialsCompleted") + 1)
		ply:SetNWInt("kappaProgress", ply:GetNWInt("kappaProgress") + 1)

		checkForLevel(ply)
		weeklyLeveling(ply)
		checkForKappa(ply)
		ply:PrintMessage(HUD_PRINTCENTER, "You have completed the Shooter Born task.", Color(85, 0, 255, 255), 0)
	end
end

function checkForWeeklySix(ply)
	local curWeeklySix = ply:GetNWInt("secPerimeter")

	if (curWeeklySix >= 8) and (ply:GetNWInt("secPerimeterComplete") == 0) then
		ply:SetNWInt("playerMoney", (ply:GetNWInt("playerMoney") + 35000) * ply:GetNWInt("loyaltyEffect"))
		ply:SetNWInt("secPerimeterComplete", 1)
		ply:SetNWInt("specialsCompleted", ply:GetNWInt("specialsCompleted") + 1)
		ply:SetNWInt("kappaProgress", ply:GetNWInt("kappaProgress") + 1)

		checkForLevel(ply)
		weeklyLeveling(ply)
		checkForKappa(ply)
		ply:PrintMessage(HUD_PRINTCENTER, "You have completed the Secured Perimeter task.", Color(85, 0, 255, 255), 0)
	end
end

function checkForWeeklySeven(ply)
	local curWeeklySeven = ply:GetNWInt("deadeyeProgress")

	if (curWeeklySeven >= 1) and (ply:GetNWInt("deadeyeComplete") == 0) then
		ply:SetNWInt("playerMoney", (ply:GetNWInt("playerMoney") + 60000) * ply:GetNWInt("loyaltyEffect"))
		ply:SetNWInt("deadeyeComplete", 1)
		ply:SetNWInt("specialsCompleted", ply:GetNWInt("specialsCompleted") + 1)
		ply:SetNWInt("kappaProgress", ply:GetNWInt("kappaProgress") + 1)

		checkForLevel(ply)
		weeklyLeveling(ply)
		checkForKappa(ply)
		ply:PrintMessage(HUD_PRINTCENTER, "You have completed the Deadeye task.", Color(85, 0, 255, 255), 0)
	end
end

function checkForWeeklyEight(ply)
	local curWeeklyEight = ply:GetNWInt("extractionStreak")

	if (curWeeklyEight >= 4) and (ply:GetNWInt("consistencyComplete") == 0) then
		ply:SetNWInt("playerMoney", (ply:GetNWInt("playerMoney") + 50000) * ply:GetNWInt("loyaltyEffect"))
		ply:SetNWInt("consistencyComplete", 1)
		ply:SetNWInt("specialsCompleted", ply:GetNWInt("specialsCompleted") + 1)
		ply:SetNWInt("kappaProgress", ply:GetNWInt("kappaProgress") + 1)

		checkForLevel(ply)
		weeklyLeveling(ply)
		checkForKappa(ply)
		ply:PrintMessage(HUD_PRINTCENTER, "You have completed the Consistency task.", Color(85, 0, 255, 255), 0)
	end
end

function dailyLeveling(ply)
	value = math.random(50, 100) / 100
	local loyalExpGain = (ply:GetNWInt("loyaltyExperience") + value)

	if (ply:GetNWInt("loyaltyLevel") < 25) then
		ply:SetNWInt("loyaltyExperience", ply:GetNWInt("loyaltyExperience") + loyalExpGain)
		checkForLoyalty(ply)
	end
end

function weeklyLeveling(ply)
	value = math.random(200, 400) / 100
	local loyalExpGain = (ply:GetNWInt("loyaltyExperience") + value)

	if (ply:GetNWInt("loyaltyLevel") < 25) then
		ply:SetNWInt("loyaltyExperience", ply:GetNWInt("loyaltyExperience") + loyalExpGain)
		checkForLoyalty(ply)
	end
end

function checkForKappa(ply)
	if (ply:GetNWInt("kappaProgress") >=  8) then
		ply:SetNWInt("kappaComplete", 1)
	end
end