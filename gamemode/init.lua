AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("custom_menu.lua")
AddCSLuaFile("map_menu.lua")
AddCSLuaFile("raid_summary_menu.lua")
AddCSLuaFile("tutorial_menu.lua")
AddCSLuaFile("cl_scoreboard.lua")
AddCSLuaFile("sh_party_system.lua")
AddCSLuaFile("tutorial_popup.lua")

include("shared.lua")
include("concommands.lua")
include("init_spawns.lua")
include("sv_stash.lua")
include("sv_tasks.lua")
include("sv_skills.lua")
include("sv_party_system.lua")
include("sv_pdata.lua")
include("sv_dailytasks.lua")
include("sh_party_system.lua")

--Player stats.

function GM:PlayerSpawn(ply)
	local walkSpeed = ply:GetNWInt("enduranceEffect") / 2.10
	local runSpeed = ply:GetNWInt("enduranceEffect") / 1.38
	local jumpHeight = ply:GetNWInt("strengthEffect") / 1.70
	local climbSpeed = ply:GetNWInt("strengthEffect") * 1.2
	local crouchSpeed = ply:GetNWInt("covertEffect") / 1.65

	ply:SetGravity(.72)
	ply:SetMaxHealth(100)
	ply:SetRunSpeed(207 + runSpeed)
	ply:SetWalkSpeed(127 + walkSpeed)
	ply:SetJumpPower(125 + jumpHeight)

	ply:SetLadderClimbSpeed(66 + climbSpeed)
	ply:SetSlowWalkSpeed(78)

	ply:SetCrouchedWalkSpeed(0.45 + crouchSpeed)
	ply:SetDuckSpeed(0.53)
	ply:SetUnDuckSpeed(0.53)

	local playerModels = {"models/player/eft/pmc/eft_bear/models/eft_bear_pm_summer.mdl", "models/player/eft/pmc/eft_bear/models/eft_bear_pm_redux.mdl", "models/player/eft/pmc/eft_usec/models/eft_usec_pm_hoody.mdl"}
	local playerFaces = {0, 1, 2, 3}
	local spawningWeapon = {"arccw_eft_1911", "arccw_waw_nambu", "arccw_waw_tt33"}
	local spawningMelee = {"arccw_bo1_sog_knife"}

	ply:SetModel(playerModels[math.random(#playerModels)])
	ply:SetBodygroup(0, playerFaces[math.random(#playerFaces)])
	ply:SetBodygroup(1, playerFaces[math.random(#playerFaces)])
	hook.Call("PlayerLoadout", GAMEMODE, ply)
	ply:Give(spawningWeapon[math.random(#spawningWeapon)])
	ply:Give(spawningMelee[math.random(#spawningMelee)])
	ply:Give("fas2_ifak")
	ply:SetupHands()

	if (ply:GetNWInt("firstSpawn") == 0) then
		ply:ConCommand("open_raid_summary_menu")
	end

end

function GM:PlayerInitialSpawn(ply)

	--In Raid Check
	ply:SetNWBool("inRaid", false)

	--First Spawn Check
	if ply:GetPData("wipeFirstSpawn") == nil then
		ply:SetNWBool("wipeFirstSpawn", true)
	else
		ply:SetNWBool("wipeFirstSpawn", ply:GetPData("wipeFirstSpawn"))
	end

	--Stash Limiting
	if ply:GetPData("StashLimit") == nil then
		ply:SetNWInt("playerStashLimit", 6)
	else
		ply:SetNWInt("playerStashLimit", ply:GetPData("StashLimit"))
	end

	--Stash Leveling
	if (ply:GetPData("playerStashLevel") == nil) then
		ply:SetNWInt("playerStashLevel", 1)
	else
		ply:SetNWInt("playerStashLevel", tonumber(ply:GetPData("playerStashLevel")))
	end

	if (ply:GetPData("playerRoubleForStashUpgrade") == nil) then
		ply:SetNWInt("playerRoubleForStashUpgrade", 10000)
	else
		ply:SetNWInt("playerRoubleForStashUpgrade", tonumber(ply:GetPData("playerRoubleForStashUpgrade")))
	end

	if (ply:GetPData("stashMaxed") == nil) then
		ply:SetNWInt("stashMaxed", 0)
	else
		ply:SetNWInt("stashMaxed", tonumber(ply:GetPData("stashMaxed")))
	end

	--Overleveled check (support for prestige during mid-wipes)
	if (ply:GetNWInt("playerLvl") >= 32) then
		ply:SetNWInt("playerLvl", 32)
		ply:SetNWInt("playerExp", 0)
	end

	--tasks hehe
	if ply:GetPData("PlayerStartedTasks") == false then

		AssignStartingTasks(ply)
		ply:SetPData("PlayerStartedTasks", true)

	end

	--Progression/Stats
	if (ply:GetPData("playerLvl") == nil) then
		ply:SetNWInt("playerLvl", 1)
	else
		ply:SetNWInt("playerLvl", tonumber(ply:GetPData("playerLvl")))
	end

	if (ply:GetPData("playerPrestige") == nil) then
		ply:SetNWInt("playerPrestige", 0)
	else
		ply:SetNWInt("playerPrestige", tonumber(ply:GetPData("playerPrestige")))
	end

	if (ply:GetPData("playerRoubleMulti") == nil) then
		ply:SetNWInt("playerRoubleMulti", 1.00)
	else
		ply:SetNWInt("playerRoubleMulti", tonumber(ply:GetPData("playerRoubleMulti")))
	end

	if (ply:GetPData("playerExp") == nil) then
		ply:SetNWInt("playerExp", 0)
	else
		ply:SetNWInt("playerExp", tonumber(ply:GetPData("playerExp")))
	end

	if (ply:GetPData("playerMoney") == nil) then
		ply:SetNWInt("playerMoney", 10000)
	else
		ply:SetNWInt("playerMoney", tonumber(ply:GetPData("playerMoney")))
	end

	if (ply:GetPData("playerKills") == nil) then
		ply:SetNWInt("playerKills", 0)
	else
		ply:SetNWInt("playerKills", tonumber(ply:GetPData("playerKills")))
	end

	if (ply:GetPData("playerDeaths") == nil) then
		ply:SetNWInt("playerDeaths", 0)
	else
		ply:SetNWInt("playerDeaths", tonumber(ply:GetPData("playerDeaths")))
	end

	if (ply:GetPData("playerKDR") == nil) then
		ply:SetNWInt("playerKDR", 1)
	else
		ply:SetNWInt("playerKDR", tonumber(ply:GetPData("playerKDR")))
	end

	if (ply:GetPData("playerTotalEarned") == nil) then
		ply:SetNWInt("playerTotalEarned", 0)
	else
		ply:SetNWInt("playerTotalEarned", tonumber(ply:GetPData("playerTotalEarned")))
	end

	if (ply:GetPData("playerTotalEarnedKill") == nil) then
		ply:SetNWInt("playerTotalEarnedKill", 0)
	else
		ply:SetNWInt("playerTotalEarnedKill", tonumber(ply:GetPData("playerTotalEarnedKill")))
	end

	if (ply:GetPData("playerTotalEarnedSell") == nil) then
		ply:SetNWInt("playerTotalEarnedSell", 0)
	else
		ply:SetNWInt("playerTotalEarnedSell", tonumber(ply:GetPData("playerTotalEarnedSell")))
	end

	if (ply:GetPData("playerTotalXpEarned") == nil) then
		ply:SetNWInt("playerTotalXpEarned", 0)
	else
		ply:SetNWInt("playerTotalXpEarned", tonumber(ply:GetPData("playerTotalXpEarned")))
	end

	if (ply:GetPData("playerTotalXpEarnedKill") == nil) then
		ply:SetNWInt("playerTotalXpEarnedKill", 0)
	else
		ply:SetNWInt("playerTotalXpEarnedKill", tonumber(ply:GetPData("playerTotalXpEarnedKill")))
	end

	if (ply:GetPData("playerTotalXpEarnedExplore") == nil) then
		ply:SetNWInt("playerTotalXpEarnedExplore", 0)
	else
		ply:SetNWInt("playerTotalXpEarnedExplore", tonumber(ply:GetPData("playerTotalXpEarnedExplore")))
	end

	if (ply:GetPData("playerDeathsSuicide") == nil) then
		ply:SetNWInt("playerDeathsSuicide", 0)
	else
		ply:SetNWInt("playerDeathsSuicide", tonumber(ply:GetPData("playerDeathsSuicide")))
	end

	if (ply:GetPData("playerDamageGiven") == nil) then
		ply:SetNWInt("playerDamageGiven", 0)
	else
		ply:SetNWInt("playerDamageGiven", tonumber(ply:GetPData("playerDamageGiven")))
	end

	if (ply:GetPData("playerDamageRecieved") == nil) then
		ply:SetNWInt("playerDamageRecieved", 0)
	else
		ply:SetNWInt("playerDamageRecieved", tonumber(ply:GetPData("playerDamageRecieved")))
	end

	if (ply:GetPData("playerDamageHealed") == nil) then
		ply:SetNWInt("playerDamageHealed", 0)
	else
		ply:SetNWInt("playerDamageHealed", tonumber(ply:GetPData("playerDamageHealed")))
	end

	if (ply:GetPData("playerItemsPickedUp") == nil) then
		ply:SetNWInt("playerItemsPickedUp", 0)
	else
		ply:SetNWInt("playerItemsPickedUp", tonumber(ply:GetPData("playerItemsPickedUp")))
	end

	if (ply:GetPData("playerDistance") == nil) then
		ply:SetNWInt("playerDistance", 0)
	else
		ply:SetNWInt("playerDistance", tonumber(ply:GetPData("playerDistance")))
	end

	--Streaks
	if (ply:GetPData("killStreak") == nil) then
		ply:SetNWInt("killStreak", 0)
	else
		ply:SetNWInt("killStreak", tonumber(ply:GetPData("killStreak")))
	end

	if (ply:GetPData("extractionStreak") == nil) then
		ply:SetNWInt("extractionStreak", 0)
	else
		ply:SetNWInt("extractionStreak", tonumber(ply:GetPData("extractionStreak")))
	end

	if (ply:GetPData("highestKillStreak") == nil) then
		ply:SetNWInt("highestKillStreak", 0)
	else
		ply:SetNWInt("highestKillStreak", tonumber(ply:GetPData("highestKillStreak")))
	end

	if (ply:GetPData("highestExtractionStreak") == nil) then
		ply:SetNWInt("highestExtractionStreak", 0)
	else
		ply:SetNWInt("highestExtractionStreak", tonumber(ply:GetPData("highestExtractionStreak")))
	end

	--Raids
	if (ply:GetPData("expMulti") == nil) then
		ply:SetNWInt("expMulti", 1)
	else
		ply:SetNWInt("expMulti", tonumber(ply:GetPData("expMulti")))
	end

	if (ply:GetPData("raidsPlayed") == nil) then
		ply:SetNWInt("raidsPlayed", 0)
	else
		ply:SetNWInt("raidsPlayed", tonumber(ply:GetPData("raidsPlayed")))
	end

	if (ply:GetPData("raidsExtracted") == nil) then
		ply:SetNWInt("raidsExtracted", 0)
	else
		ply:SetNWInt("raidsExtracted", tonumber(ply:GetPData("raidsExtracted")))
	end

	if (ply:GetPData("raidsRanThrough") == nil) then
		ply:SetNWInt("raidsRanThrough", 0)
	else
		ply:SetNWInt("raidsRanThrough", tonumber(ply:GetPData("raidsRanThrough")))
	end

	if (ply:GetPData("raidsDied") == nil) then
		ply:SetNWInt("raidsDied", 0)
	else
		ply:SetNWInt("raidsDied", tonumber(ply:GetPData("raidsDied")))
	end

	--Raid Stat Tracking
	ply:SetNWInt("raidKill", 0)
	ply:SetNWInt("raidXP", 0)
	ply:SetNWInt("raidMoney", 0)
	ply:SetNWInt("raidDamageGiven", 0)
	ply:SetNWInt("raidDamageTaken", 0)
	ply:SetNWInt("raidItemsPicked", 0)

	ply:SetNWInt("raidSuccess", 1)
	ply:SetNWInt("firstSpawn", 1)
	ply:SetNWInt("runThrough", 1)

	--Skills Fatigue
	ply:SetNWInt("enduranceFatigue", 0)
	ply:SetNWInt("strengthFatigue", 0)
	ply:SetNWInt("covertFatigue", 0)

	--Daily Tasks
	ply:SetNWInt("mapKills", 0)
	ply:SetNWInt("mapExtracts", 0)

	ply:SetNWInt("eliminationComplete", 0)
	ply:SetNWInt("successfulOperationsComplete", 0)

	--Weekly Tasks
	if (ply:GetPData("weeklyDistance") == nil) then
		ply:SetNWInt("weeklyDistance", 0)
	else
		ply:SetNWInt("weeklyDistance", tonumber(ply:GetPData("weeklyDistance")))
	end

	if (ply:GetPData("weeklyExtracts") == nil) then
		ply:SetNWInt("weeklyExtracts", 0)
	else
		ply:SetNWInt("weeklyExtracts", tonumber(ply:GetPData("weeklyExtracts")))
	end

	if (ply:GetPData("weeklyNuclear") == nil) then
		ply:SetNWInt("weeklyNuclear", 0)
	else
		ply:SetNWInt("weeklyNuclear", tonumber(ply:GetPData("weeklyNuclear")))
	end

	if (ply:GetPData("weeklyAddict") == nil) then
		ply:SetNWInt("weeklyAddict", 0)
	else
		ply:SetNWInt("weeklyAddict", tonumber(ply:GetPData("weeklyAddict")))
	end

	if (ply:GetPData("weeklyDistanceComplete") == nil) then
		ply:SetNWInt("weeklyDistanceComplete", 0)
	else
		ply:SetNWInt("weeklyDistanceComplete", tonumber(ply:GetPData("weeklyDistanceComplete")))
	end

	if (ply:GetPData("weeklyExtractsComplete") == nil) then
		ply:SetNWInt("weeklyExtractsComplete", 0)
	else
		ply:SetNWInt("weeklyExtractsComplete", tonumber(ply:GetPData("weeklyExtractsComplete")))
	end

	if (ply:GetPData("weeklyNuclearComplete") == nil) then
		ply:SetNWInt("weeklyNuclearComplete", 0)
	else
		ply:SetNWInt("weeklyNuclearComplete", tonumber(ply:GetPData("weeklyNuclearComplete")))
	end

	if (ply:GetPData("weeklyAddictComplete") == nil) then
		ply:SetNWInt("weeklyAddictComplete", 0)
	else
		ply:SetNWInt("weeklyAddictComplete", tonumber(ply:GetPData("weeklyAddictComplete")))
	end

	--Skills

	--Endurance
	if (ply:GetPData("enduranceLevel") == nil) then
		ply:SetNWInt("enduranceLevel", 1)
	else
		ply:SetNWInt("enduranceLevel", tonumber(ply:GetPData("enduranceLevel")))
	end

	if (ply:GetPData("enduranceExperience") == nil) then
		ply:SetNWInt("enduranceExperience", 0)
	else
		ply:SetNWInt("enduranceExperience", tonumber(ply:GetPData("enduranceExperience")))
	end

	if (ply:GetPData("enduranceEffect") == nil) then
		ply:SetNWInt("enduranceEffect", 0)
	else
		ply:SetNWInt("enduranceEffect", tonumber(ply:GetPData("enduranceEffect")))
	end

	--Strength
	if (ply:GetPData("strengthLevel") == nil) then
		ply:SetNWInt("strengthLevel", 1)
	else
		ply:SetNWInt("strengthLevel", tonumber(ply:GetPData("strengthLevel")))
	end

	if (ply:GetPData("strengthExperience") == nil) then
		ply:SetNWInt("strengthExperience", 0)
	else
		ply:SetNWInt("strengthExperience", tonumber(ply:GetPData("strengthExperience")))
	end

	if (ply:GetPData("strengthEffect") == nil) then
		ply:SetNWInt("strengthEffect", 0)
	else
		ply:SetNWInt("strengthEffect", tonumber(ply:GetPData("strengthEffect")))
	end

	--Charisma
	if (ply:GetPData("charismaLevel") == nil) then
		ply:SetNWInt("charismaLevel", 1)
	else
		ply:SetNWInt("charismaLevel", tonumber(ply:GetPData("charismaLevel")))
	end

	if (ply:GetPData("charismaExperience") == nil) then
		ply:SetNWInt("charismaExperience", 0)
	else
		ply:SetNWInt("charismaExperience", tonumber(ply:GetPData("charismaExperience")))
	end

	if (ply:GetPData("charismaEffect") == nil) then
		ply:SetNWInt("charismaEffect", 1)
	else
		ply:SetNWInt("charismaEffect", tonumber(ply:GetPData("charismaEffect")))
	end

	--Covert Movement
	if (ply:GetPData("covertLevel") == nil) then
		ply:SetNWInt("covertLevel", 1)
	else
		ply:SetNWInt("covertLevel", tonumber(ply:GetPData("covertLevel")))
	end

	if (ply:GetPData("covertExperience") == nil) then
		ply:SetNWInt("covertExperience", 0)
	else
		ply:SetNWInt("covertExperience", tonumber(ply:GetPData("covertExperience")))
	end

	if (ply:GetPData("covertEffect") == nil) then
		ply:SetNWInt("covertEffect", 0)
	else
		ply:SetNWInt("covertEffect", tonumber(ply:GetPData("covertEffect")))
	end
end

function GM:PlayerDeath(victim, inflictor, attacker)
	if (victim == attacker) then

		local deathGained = 1

		victim:SetNWInt("playerDeathsSuicide", victim:GetNWInt("playerDeathsSuicide") + 1)
		victim:SetNWInt("playerDeaths", victim:GetNWInt("playerDeaths") + deathGained)
		victim:SetNWInt("playerKDR", victim:GetNWInt("playerKills") / victim:GetNWInt("playerDeaths"))

		victim:SetNWInt("raidSuccess", 0)

		victim:SetNWInt("killStreak", 0)
		victim:SetNWInt("extractionStreak", 0)
	else
		local moneyGained = math.random(1000, 2500)
		local expGained = math.random(425, 675)
		local killGained = 1
		local deathGained = 1

		if (victim:GetNWBool("inRaid") == true) then
			victim:SetNWInt("raidsDied", victim:GetNWInt("raidsDied") + 1)
		end

		attacker:SetNWInt("playerMoney", attacker:GetNWInt("playerMoney") + moneyGained * attacker:GetNWInt("playerRoubleMulti"))
		attacker:SetNWInt("raidMoney", attacker:GetNWInt("raidMoney") + moneyGained * attacker:GetNWInt("playerRoubleMulti"))

		if (attacker:GetNWInt("playerLvl") < 32) then
			attacker:SetNWInt("playerExp", math.Round(attacker:GetNWInt("playerExp") + (expGained * attacker:GetNWInt("expMulti"))), 1)
			attacker:SetNWInt("raidXP", math.Round(attacker:GetNWInt("raidXP") + (expGained * attacker:GetNWInt("expMulti"))), 1)
		end

		if (attacker:GetNWInt("eliminationComplete") == 0) then
			attacker:SetNWInt("mapKills", attacker:GetNWInt("mapKills") + killGained)
		end

		attacker:SetNWInt("playerKills", attacker:GetNWInt("playerKills") + killGained)
		attacker:SetNWInt("raidKill", attacker:GetNWInt("raidKill") + killGained)

		victim:SetNWInt("playerDeaths", victim:GetNWInt("playerDeaths") + deathGained)
		victim:SetNWInt("playerKDR", victim:GetNWInt("playerKills") / victim:GetNWInt("playerDeaths"))

		attacker:SetNWInt("playerKDR", attacker:GetNWInt("playerKills") / attacker:GetNWInt("playerDeaths"))

		attacker:SetNWInt("playerTotalEarned", attacker:GetNWInt("playerTotalEarned") + moneyGained * attacker:GetNWInt("playerRoubleMulti"))
		attacker:SetNWInt("playerTotalXpEarned", attacker:GetNWInt("playerTotalXpEarned") + expGained)
		attacker:SetNWInt("playerTotalEarnedKill", attacker:GetNWInt("playerTotalEarnedKill") + moneyGained * attacker:GetNWInt("playerRoubleMulti"))

		victim:SetNWInt("raidSuccess", 0)

		attacker:SetNWInt("killStreak", attacker:GetNWInt("killStreak") + 1)

		if attacker:GetNWInt("killStreak") >= attacker:GetNWInt("highestKillStreak") then
			attacker:SetNWInt("highestKillStreak", attacker:GetNWInt("killStreak"))
		end

		victim:SetNWInt("killStreak", 0)
		victim:SetNWInt("extractionStreak", 0)
		victim:SetNWInt("expMulti", 1)

		checkForLevel(attacker)
		checkForElimination(attacker)
	end
end

hook.Add("PlayerDeath", "DeathMessage", function(victim, inflictor, attacker)
	if victim == attacker or attacker == nil or victim == nil then
		victim:PrintMessage(HUD_PRINTCENTER, "You committed suicide.")
	else
		local weaponInfo = weapons.Get( attacker:GetActiveWeapon():GetClass() )
		local rawDistance = victim:GetPos():Distance(attacker:GetPos())

		local distance = (math.Round(rawDistance * 0.01905 * 10) / 10)

		victim:PrintMessage(HUD_PRINTCENTER, attacker:Name() .. " killed you from " .. distance .. "m away.")
		victim:PrintMessage(HUD_PRINTCENTER, "They had an " .. weaponInfo["PrintName"]  .. ".")

		print(victim:LastHitGroup())

		attacker:SetNWInt("weeklyDistance", attacker:GetNWInt("weeklyDistance") + distance)
		checkForWeekly(attacker)
	end
end)

hook.Add("GetFallDamage", "DamageChange", function(ply, speed)
	return math.max(0, math.ceil( 0.350 * speed - 141.75 ))
end)

hook.Add("PlayerHurt", "playerDamage", function(victim, attacker, remainingHealth, dmgTaken)
	attacker:SetNWInt("playerDamageGiven", attacker:GetNWInt("playerDamageGiven") + math.Round(dmgTaken, 0))
	attacker:SetNWInt("raidDamageGiven", attacker:GetNWInt("raidDamageGiven") + math.Round(dmgTaken, 0))
	attacker:SetNWInt("runThrough", 0)

	victim:SetNWInt("playerDamageRecieved", victim:GetNWInt("playerDamageRecieved") + math.Round(dmgTaken, 0))
	victim:SetNWInt("raidDamageTaken", victim:GetNWInt("raidDamageTaken") + math.Round(dmgTaken, 0))
	victim:SetNWInt("runThrough", 0)
end)

hook.Add("HUDWeaponPickedUp", "WeaponPickedUp", function(weapon)
	ply:SetNWInt("playerItemsPickedUp", ply:GetNWInt("playerItemsPickedUp") + 1)
	ply:SetNWInt("raidItemsPicked", ply:GetNWInt("raidItemsPicked") + 1)
end)

function checkForLevel(ply)
	if (ply:GetNWInt("playerLvl") < 32) then
		local expToLevel = (ply:GetNWInt("playerLvl") * 140) * 5.15
		local curExp = ply:GetNWInt("playerExp")
		local curLvl = ply:GetNWInt("playerLvl")

		if (curExp >= expToLevel) then
			curExp = curExp - expToLevel

			ply:SetNWInt("playerExp", curExp)
			ply:SetNWInt("playerLvl", curLvl + 1)

			ply:PrintMessage(HUD_PRINTCENTER, "You have leveled up to level " .. (curLvl + 1) .. ".", Color(85, 0, 255, 255), 0)
		end
	end
end

util.AddNetworkString("MenuInRaid")
util.AddNetworkString("TeamMenu")

function GM:ShowHelp(ply)
	ply:ConCommand("open_tutorial_menu")
end

function GM:ShowTeam(ply)
	net.Start("TeamMenu")
	net.Send(ply)
end

function GM:ShowSpare1(ply)
	ply:ConCommand("jmod_ez_inv")
end

function GM:ShowSpare2(ply)
	net.Start("MenuInRaid")
	net.WriteBool(ply:GetNWBool("inRaid"))
	net.Send(ply)
	ply:ConCommand("open_game_menu")
end

function GM:PlayerDisconnected(ply)
	--Statistics
	ply:SetPData("playerLvl", ply:GetNWInt("playerLvl"))
	ply:SetPData("playerPrestige", ply:GetNWInt("playerPrestige"))
	ply:SetPData("playerRoubleMulti", ply:GetNWInt("playerRoubleMulti"))
	ply:SetPData("playerExp", ply:GetNWInt("playerExp"))
	ply:SetPData("playerMoney", ply:GetNWInt("playerMoney"))
	ply:SetPData("playerKills", ply:GetNWInt("playerKills"))
	ply:SetPData("playerDeaths", ply:GetNWInt("playerDeaths"))
	ply:SetPData("playerKDR", ply:GetNWInt("playerKDR"))
	ply:SetPData("playerTotalEarned", ply:GetNWInt("playerTotalEarned"))
	ply:SetPData("playerTotalEarnedKill", ply:GetNWInt("playerTotalEarnedKill"))
	ply:SetPData("playerTotalEarnedSell", ply:GetNWInt("playerTotalEarnedSell"))
	ply:SetPData("playerTotalXpEarned", ply:GetNWInt("playerTotalXpEarned"))
	ply:SetPData("playerTotalXpEarnedKill", ply:GetNWInt("playerTotalXpEarnedKill"))
	ply:SetPData("playerTotalXpEarnedExplore", ply:GetNWInt("playerTotalXpEarnedExplore"))
	ply:SetPData("playerTotalMoneySpent", ply:GetNWInt("playerTotalMoneySpent"))
	ply:SetPData("playerTotalMoneySpentWep", ply:GetNWInt("playerTotalMoneySpentWep"))
	ply:SetPData("playerTotalMoneySpentItem", ply:GetNWInt("playerTotalMoneySpentItem"))
	ply:SetPData("playerDeathsSuicide", ply:GetNWInt("playerDeathsSuicide"))
	ply:SetPData("playerDamageGiven", ply:GetNWInt("playerDamageGiven"))
	ply:SetPData("playerDamageRecieved", ply:GetNWInt("playerDamageRecieved"))
	ply:SetPData("playerDamageHealed", ply:GetNWInt("playerDamageHealed"))
	ply:SetPData("playerItemsPickedUp", ply:GetNWInt("playerItemsPickedUp"))
	ply:SetPData("playerDistance", ply:GetNWInt("playerDistance"))
	ply:SetPData("playerStashLevel", ply:GetNWInt("playerStashLevel"))
	ply:SetPData("playerRoubleForStashUpgrade", ply:GetNWInt("playerRoubleForStashUpgrade"))
	ply:SetPData("StashLimit", ply:GetNWInt("playerStashLimit"))
	ply:SetPData("stashMaxed", ply:GetNWInt("stashMaxed"))
	ply:SetPData("wipeFirstSpawn", ply:GetNWBool("wipeFirstSpawn"))

	--Skills
	ply:SetPData("enduranceLevel", ply:GetNWInt("enduranceLevel"))
	ply:SetPData("enduranceExperience", ply:GetNWInt("enduranceExperience"))
	ply:SetPData("enduranceEffect", ply:GetNWInt("enduranceEffect"))
	ply:SetPData("strengthLevel", ply:GetNWInt("strengthLevel"))
	ply:SetPData("strengthExperience", ply:GetNWInt("strengthExperience"))
	ply:SetPData("strengthEffect", ply:GetNWInt("strengthEffect"))
	ply:SetPData("charismaLevel", ply:GetNWInt("charismaLevel"))
	ply:SetPData("charismaExperience", ply:GetNWInt("charismaExperience"))
	ply:SetPData("charismaEffect", ply:GetNWInt("charismaEffect"))
	ply:SetPData("covertLevel", ply:GetNWInt("covertLevel"))
	ply:SetPData("covertExperience", ply:GetNWInt("covertExperience"))
	ply:SetPData("covertEffect", ply:GetNWInt("covertEffect"))

	--Streaks
	ply:SetPData("killStreak", ply:GetNWInt("killStreak"))
	ply:SetPData("extractionStreak", ply:GetNWInt("extractionStreak"))
	ply:SetPData("highestKillStreak", ply:GetNWInt("highestKillStreak"))
	ply:SetPData("highestExtractionStreak", ply:GetNWInt("highestExtractionStreak"))
	ply:SetPData("expMulti", ply:GetNWInt("expMulti"))

	--Tasks
	ply:SetPData("weeklyDistance", ply:GetNWInt("weeklyDistance"))
	ply:SetPData("weeklyExtracts", ply:GetNWInt("weeklyExtracts"))
	ply:SetPData("weeklyNuclear", ply:GetNWInt("weeklyNuclear"))
	ply:SetPData("weeklyAddict", ply:GetNWInt("weeklyAddict"))

	ply:SetPData("weeklyDistanceComplete", ply:GetNWInt("weeklyDistanceComplete"))
	ply:SetPData("weeklyExtractsComplete", ply:GetNWInt("weeklyExtractsComplete"))
	ply:SetPData("weeklyNuclearComplete", ply:GetNWInt("weeklyNuclearComplete"))
	ply:SetPData("weeklyAddictComplete", ply:GetNWInt("weeklyAddictComplete"))

	--Raids
	ply:SetPData("raidsPlayed", ply:GetNWInt("raidsPlayed"))
	ply:SetPData("raidsExtracted", ply:GetNWInt("raidsExtracted"))
	ply:SetPData("raidsRanThrough", ply:GetNWInt("raidsRanThrough"))
	ply:SetPData("raidsDied", ply:GetNWInt("raidsDied"))
end

function GM:ShutDown()
	for k, v in pairs(player.GetHumans()) do
		--Statistics
		v:SetPData("playerLvl", v:GetNWInt("playerLvl"))
		v:SetPData("playerPrestige", v:GetNWInt("playerPrestige"))
		v:SetPData("playerRoubleMulti", v:GetNWInt("playerRoubleMulti"))
		v:SetPData("playerExp", v:GetNWInt("playerExp"))
		v:SetPData("playerMoney", v:GetNWInt("playerMoney"))
		v:SetPData("playerKills", v:GetNWInt("playerKills"))
		v:SetPData("playerDeaths", v:GetNWInt("playerDeaths"))
		v:SetPData("playerKDR", v:GetNWInt("playerKDR"))
		v:SetPData("playerTotalEarned", v:GetNWInt("playerTotalEarned"))
		v:SetPData("playerTotalEarnedKill", v:GetNWInt("playerTotalEarnedKill"))
		v:SetPData("playerTotalEarnedSell", v:GetNWInt("playerTotalEarnedSell"))
		v:SetPData("playerTotalXpEarned", v:GetNWInt("playerTotalXpEarned"))
		v:SetPData("playerTotalXpEarnedKill", v:GetNWInt("playerTotalXpEarnedKill"))
		v:SetPData("playerTotalXpEarnedExplore", v:GetNWInt("playerTotalXpEarnedExplore"))
		v:SetPData("playerTotalMoneySpent", v:GetNWInt("playerTotalMoneySpent"))
		v:SetPData("playerTotalMoneySpentWep", v:GetNWInt("playerTotalMoneySpentWep"))
		v:SetPData("playerTotalMoneySpentItem", v:GetNWInt("playerTotalMoneySpentItem"))
		v:SetPData("playerDeathsSuicide", v:GetNWInt("playerDeathsSuicide"))
		v:SetPData("playerDamageGiven", v:GetNWInt("playerDamageGiven"))
		v:SetPData("playerDamageRecieved", v:GetNWInt("playerDamageRecieved"))
		v:SetPData("playerDamageHealed", v:GetNWInt("playerDamageHealed"))
		v:SetPData("playerItemsPickedUp", v:GetNWInt("playerItemsPickedUp"))
		v:SetPData("playerDistance", v:GetNWInt("playerDistance"))
		v:SetPData("playerStashLevel", v:GetNWInt("playerStashLevel"))
		v:SetPData("playerRoubleForStashUpgrade", v:GetNWInt("playerRoubleForStashUpgrade"))
		v:SetPData("StashLimit", v:GetNWInt("playerStashLimit"))
		v:SetPData("stashMaxed", v:GetNWInt("stashMaxed"))
		v:SetPData("wipeFirstSpawn", v:GetNWBool("wipeFirstSpawn"))

		--Skills
		v:SetPData("enduranceLevel", v:GetNWInt("enduranceLevel"))
		v:SetPData("enduranceExperience", v:GetNWInt("enduranceExperience"))
		v:SetPData("enduranceEffect", v:GetNWInt("enduranceEffect"))
		v:SetPData("strengthLevel", v:GetNWInt("strengthLevel"))
		v:SetPData("strengthExperience", v:GetNWInt("strengthExperience"))
		v:SetPData("strengthEffect", v:GetNWInt("strengthEffect"))
		v:SetPData("charismaLevel", v:GetNWInt("charismaLevel"))
		v:SetPData("charismaExperience", v:GetNWInt("charismaExperience"))
		v:SetPData("charismaEffect", v:GetNWInt("charismaEffect"))
		v:SetPData("covertLevel", v:GetNWInt("covertLevel"))
		v:SetPData("covertExperience", v:GetNWInt("covertExperience"))
		v:SetPData("covertEffect", v:GetNWInt("covertEffect"))

		--Streaks
		v:SetPData("killStreak", v:GetNWInt("killStreak"))
		v:SetPData("extractionStreak", v:GetNWInt("extractionStreak"))
		v:SetPData("expMulti", v:GetNWInt("expMulti"))

		--Tasks
		v:SetPData("weeklyDistance", v:GetNWInt("weeklyDistance"))
		v:SetPData("weeklyExtracts", v:GetNWInt("weeklyExtracts"))
		v:SetPData("weeklyNuclear", v:GetNWInt("weeklyNuclear"))
		v:SetPData("weeklyAddict", v:GetNWInt("weeklyAddict"))

		v:SetPData("weeklyDistanceComplete", v:GetNWInt("weeklyDistanceComplete"))
		v:SetPData("weeklyExtractsComplete", v:GetNWInt("weeklyExtractsComplete"))
		v:SetPData("weeklyNuclearComplete", v:GetNWInt("weeklyNuclearComplete"))
		v:SetPData("weeklyAddictComplete", v:GetNWInt("weeklyAddictComplete"))
	end
end

function GM:GravGunPunt(player, entity)
	return false
end

--What da dog doin?