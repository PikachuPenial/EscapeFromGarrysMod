ENT.Type = "point"
ENT.Base = "base_point"

ENT.RaidStarted = false
ENT.RaidTime = 1200

local isRaidJoinTime = false

local pmcClass = "PMC"
local playerScavClass = "PlayerScav"
local noClass = "NotInRaid"

local knownRaidTime

local raidStartSpawnTable = {}

local isRaidEnded = false

-- Classes: "PMC", "PlayerScav", "NotInRaid"

-- {player, spawnGroup, class}
local playerStatusTable = {}

function ENT:KeyValue(key, value)
	-- This not only receives the keyvalue of raid_time, but also converts it into seconds which can be used in the timers.
	if key == "raid_time" then
      self.RaidTime = tonumber(value) * 60
	end

	if key == "OnRaidEnd" then
		self:StoreOutput(key, value)
	end
end

function SetPlayerStatus(player, spawnGroup, status)
	for iter, v in pairs( playerStatusTable ) do

		if v[1] == player then

			v[2] = spawnGroup

			v[3] = status

		end

	end
end

function RemoveFromTable(ply)

	for k, v in pairs(playerStatusTable) do

		if v[1] == ply then

			table.remove(playerStatusTable, k)

		end

	end

end

function SpawnPlayer(player, spawnGroup, status, pos, angles)

	player:SetPos(pos)
	player:SetAngles(angles)

	SetPlayerStatus(player, spawnGroup, status)

end

function PrintStatus(ply, cmd, args)

	local spawnGroup
	local status

	for k, v in pairs(playerStatusTable) do
		if v[1] == ply then
			spawnGroup = v[2]
			status = v[3]
		end
	end

	print(ply:GetName().."\n"..tostring(spawnGroup).."\n"..tostring(status))

end
concommand.Add("efgm_print_status", PrintStatus)

function CheckSpawnGroup(ply)

	local spawnGroup

	for k, v in pairs(playerStatusTable) do

		if v[1] == ply then

			spawnGroup = v[2]

		end

	end

	return spawnGroup

end

util.AddNetworkString("RaidTimeLeft")

function RaidTimeLeft()

	local raidTimeLeft

	if timer.Exists("RaidTimer") then
		raidTimeLeft = timer.TimeLeft("RaidTimer")
	else
		return "Raid is over!"
	end

	local minsLeft = math.Truncate(raidTimeLeft / 60, 0)

	local secsLeft = math.Truncate(raidTimeLeft - (minsLeft * 60), 0)

	local secondsText

	if secsLeft < 10 then
		secondsText = "0" .. secsLeft
	else
		secondsText = secsLeft
	end

	local timeLeftClean = tostring(minsLeft..":"..secondsText)

	if raidTimeLeft == 0 or raidTimeLeft == nil then
		return "Raid is over!"
	else
		return tostring(timeLeftClean)
	end
end

function ENT:Think()

	if timer.TimeLeft("RaidTimer") != knownRaidTime then

		net.Start("RaidTimeLeft")
		net.WriteString(RaidTimeLeft())
		net.WriteBool(isRaidEnded)
		net.Broadcast()

		knownRaidTime = timer.TimeLeft("RaidTimer")
	end
end

function ENT:EndRaid()

	isRaidEnded = true

	for k, v in pairs(playerStatusTable) do

		if v[3] != noClass then
			v[1]:KillSilent()
			
			SetPlayerStatus(v[1], nil, noClass)
		end

	end

	for k, v in pairs( player.GetHumans() ) do

		v:PrintMessage( HUD_PRINTCENTER, "The raid is over!\nIf you did not exit the raid in time, you have lost everything you brought in." )

	end

	self:TriggerOutput("OnRaidEnd", self, nil)

	timer.Create("RaidTimer", 120, 1, function()
	
		local mapName = game.GetMap()

		RunConsoleCommand("map", mapName)
	
	end)

end

function ENT:InitializeRaid()

	local baseSpawnTable = ents.FindByClass( "efgm_raid_spawn" )

	for k, v in pairs(baseSpawnTable) do
		if v.SpawnType != 1 then

			table.insert(raidStartSpawnTable, v)

		end
	end

	for k, v in pairs( player.GetHumans() ) do

		local randomSpawnInt = math.random(#raidStartSpawnTable)

		v:SetPos(raidStartSpawnTable[randomSpawnInt]:GetPos())
		v:SetAngles(raidStartSpawnTable[randomSpawnInt]:GetAngles())

		SetPlayerStatus(v, raidStartSpawnTable[randomSpawnInt].SpawnGroup, pmcClass)

		table.remove(raidStartSpawnTable, randomSpawnInt)

	end

	self.RaidStarted = true

	timer.Create("RaidTimer", self.RaidTime, 1, function() self:EndRaid() end)

	knownRaidTime = self.RaidTime

	print("A new raid has started, good luck!")

end

function ENT:DetermineSpawnTable(class)

	local baseSpawnTable = ents.FindByClass( "efgm_raid_spawn" )
	local spawnTable = {}

	for k, v in pairs(baseSpawnTable) do

		-- 0 is universal, 1 is a PMC spawn, 2 is a Player Scav spawn.

		if class == "PMC" then

			if v.SpawnType != 2 then

				table.insert(spawnTable, v)
	
			end

		end

		if class == "PlayerScav" then

			if v.SpawnType != 1 then

				table.insert(spawnTable, v)
	
			end

		end

	end

	return spawnTable

end

function ENT:IndividualSpawn(ply, class, raidHasStarted)

	spawnTable = self:DetermineSpawnTable(class)

	local randomSpawn = spawnTable[math.random(#spawnTable)]

	if raidHasStarted == true then

		local playerSpawnInt = math.random(#raidStartSpawnTable)

		SpawnPlayer(ply, raidStartSpawnTable[playerSpawnInt].SpawnGroup, class, raidStartSpawnTable[playerSpawnInt]:GetPos(), raidStartSpawnTable[playerSpawnInt]:GetAngles())

		table.remove(raidStartSpawnTable, playerSpawnInt)

	else

		SpawnPlayer(ply, randomSpawn.SpawnGroup, class, randomSpawn:GetPos(), randomSpawn:GetAngles())

	end

end

function ENT:PartySpawn(players, class)

	spawnTable = self:DetermineSpawnTable(class)
	teamSpawnTable = {}

	local mainSpawn = spawnTable[math.random(#spawnTable)]

	local spawnName = mainSpawn.SpawnName

	for k, v in pairs(ents.FindByClass( "efgm_team_spawn" )) do

		if v.MainSpawnName == spawnName then
			table.insert(teamSpawnTable, v)
		end

	end

	for k, v in pairs(players) do

		local spawnInt = math.random(#teamSpawnTable)

		SpawnPlayer(v, mainSpawn.SpawnGroup, class, teamSpawnTable[spawnInt]:GetPos(), teamSpawnTable[spawnInt]:GetAngles())

		table.remove(teamSpawnTable, spawnInt)

	end
end

hook.Add("PlayerDisconnected", "PlayerLeave", function(ply) RemoveFromTable(ply) end)

hook.Add( "PlayerDeath", "PlayerDie", function( victim, inflictor, attacker )

	SetPlayerStatus(victim, nil, noClass)

end )

hook.Add("PlayerInitialSpawn", "PlayerFirstSpawn", function(ply)

	local tableContents = {ply, nil, noClass}
	table.insert(playerStatusTable, tableContents)

	--SetPlayerStatus(ply, nil, noClass)

end)

hook.Add( "PlayerShouldTakeDamage", "AntiLobbyKill", function( ply, attacker )
	
	for k, v in pairs(playerStatusTable) do
		if v[1] == ply then
			if v[3] == noClass then
				return false
			elseif v[3] != noClass then
				return true
			end
		end
	end

end )

function AssignTeam(ply, cmd, args)

	local teamName = args[1]

	ply:SetNWString("playerTeam", tostring(teamName))

end
concommand.Add("efgm_join_team", AssignTeam)

function ENT:AcceptInput(name, ply, caller, data)
	if name == "StartRaid" then

		if isRaidEnded == true then return end

		if self.RaidStarted == false then

			self:InitializeRaid()

			self:IndividualSpawn(ply, "PMC", false)

		else

			self:IndividualSpawn(ply, "PMC", false)

		end

		
	end
end