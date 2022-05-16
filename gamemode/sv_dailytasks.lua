--Tracks and rewards people who complete daily/weekly tasks

function checkForElimination(ply)
	local expToLevel = (ply:GetNWInt("playerLvl") * 140) * 5.15
	local expReward = math.Round(expToLevel / 6), 1
	local curKills = ply:GetNWInt("mapKills")

	if (ply:GetNWInt("playerLvl") < 32) and (curKills >= 6) and (ply:GetNWInt("eliminationComplete") == 0) then
		ply:SetNWInt("playerExp", ply:GetNWInt("playerExp") + expReward)
		ply:SetNWInt("playerMoney", ply:GetNWInt("playerMoney") + 2500)
		ply:SetNWInt("eliminationComplete", 1)

		checkForLevel(ply)
		ply:PrintMessage(HUD_PRINTCENTER, "You have completed the Elimination task.", Color(85, 0, 255, 255), 0)
	end
end

function checkForSuccessfulOperations(ply)
	local expToLevel = (ply:GetNWInt("playerLvl") * 140) * 5.15
	local expReward = math.Round(expToLevel / 6), 1
	local curExtracts = ply:GetNWInt("mapExtracts")

	if (ply:GetNWInt("playerLvl") < 32) and (curExtracts >= 2) and (ply:GetNWInt("successfulOperationsComplete") == 0) then
		ply:SetNWInt("playerExp", ply:GetNWInt("playerExp") + expReward)
		ply:SetNWInt("playerMoney", ply:GetNWInt("playerMoney") + 2500)
		ply:SetNWInt("successfulOperationsComplete", 1)

		checkForLevel(ply)
		ply:PrintMessage(HUD_PRINTCENTER, "You have completed the Successful Operations task.", Color(85, 0, 255, 255), 0)
	end
end

function checkForWeekly(ply)
	local curWeekly = ply:GetNWInt("weeklyDistance")

	if (curWeekly >= 3000) and (ply:GetNWInt("weeklyDistanceComplete") == 0) then
		ply:SetNWInt("playerMoney", ply:GetNWInt("playerMoney") + 50000)
		ply:SetNWInt("weeklyDistanceComplete", 1)

		checkForLevel(ply)
		ply:PrintMessage(HUD_PRINTCENTER, "You have completed the Rangefinder task.", Color(85, 0, 255, 255), 0)
	end
end

function checkForWeeklyTwo(ply)
	local curWeeklyTwo = ply:GetNWInt("weeklyExtracts")

	if (curWeeklyTwo >= 15) and (ply:GetNWInt("weeklyExtractsComplete") == 0) then
		ply:SetNWInt("playerMoney", ply:GetNWInt("playerMoney") + 60000)
		ply:SetNWInt("weeklyExtractsComplete", 1)

		checkForLevel(ply)
		ply:PrintMessage(HUD_PRINTCENTER, "You have completed the Wanted task.", Color(85, 0, 255, 255), 0)
	end
end

function checkForWeeklyThree(ply)
	local curWeeklyThree = ply:GetNWInt("weeklyNuclear")

	if (curWeeklyThree >= 1) and (ply:GetNWInt("weeklyNuclearComplete") == 0) then
		ply:SetNWInt("playerMoney", ply:GetNWInt("playerMoney") + 70000)
		ply:SetNWInt("weeklyNuclearComplete", 1)

		checkForLevel(ply)
		ply:PrintMessage(HUD_PRINTCENTER, "You have completed the Nuclear task.", Color(85, 0, 255, 255), 0)
	end
end

function checkForWeeklyFour(ply)
	local curWeeklyFour = ply:GetNWInt("weeklyAddict")

	if (curWeeklyFour >= 10) and (ply:GetNWInt("weeklyAddictComplete") == 0) then
		ply:SetNWInt("playerMoney", ply:GetNWInt("playerMoney") + 40000)
		ply:SetNWInt("weeklyAddictComplete", 1)

		checkForLevel(ply)
		ply:PrintMessage(HUD_PRINTCENTER, "You have completed the Addiction task.", Color(85, 0, 255, 255), 0)
	end
end