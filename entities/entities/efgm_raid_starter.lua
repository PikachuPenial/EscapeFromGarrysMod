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

local mapPool = {"efgm_concrete", "efgm_factory", "efgm_customs", "efgm_belmont"}

-- the numbers correspond to the maps of mapPool. mapVotes[1] would be for concrete, etc. 
-- PENIAL ADD A ZERO FOR EACH MAP DONT SCARE ME WITH THESE ERRORS ok thanks lol
local mapVotes = {0, 0, 0, 0}

local voterTable = {}

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

	player:SetNWBool("inRaid", true)

	player:SetNWInt("raidKill", 0)
	player:SetNWInt("raidXP", 0)
	player:SetNWInt("raidMoney", 0)
	player:SetNWInt("raidDamageGiven", 0)
	player:SetNWInt("raidDamageTaken", 0)
	player:SetNWInt("raidItemsPicked", 0)

	player:SetNWInt("raidSuccess", 0)
	player:SetNWInt("firstSpawn", 0)

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

	print(ply:GetName() .. "\n" .. tostring(spawnGroup) .. "\n" .. tostring(status))

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
		return "Raid has not started."
	end

	local minsLeft = math.Truncate(raidTimeLeft / 60, 0)

	local secsLeft = math.Truncate(raidTimeLeft - (minsLeft * 60), 0)

	local secondsText

	if secsLeft < 10 then
		secondsText = "0" .. secsLeft
	else
		secondsText = secsLeft
	end

	local timeLeftClean = tostring(minsLeft .. ":" .. secondsText)

	if raidTimeLeft == 0 or raidTimeLeft == nil then
		return "Raid has not started."
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

	if #player.GetHumans() == 0 then RunConsoleCommand("changelevel", mapPool[math.random(#mapPool)]) return end

	isRaidEnded = true

	for k, v in pairs(playerStatusTable) do

		if v[3] != noClass then
			v[1]:Kill()

			SetPlayerStatus(v[1], nil, noClass)
		end

	end

	for k, v in pairs( player.GetHumans() ) do

		v:PrintMessage( HUD_PRINTCENTER, "The raid is over!\nIf you did not exit the raid in time, you have lost everything you brought in." )

	end

	self:TriggerOutput("OnRaidEnd", self, nil)

	timer.Simple(30, function()

		for k, v in pairs(player.GetHumans()) do

			v:ConCommand("open_map_menu")

		end

	end)

	timer.Create("RaidTimer", 120, 1, function()

		local newMapTable = {}

		local maxVotes = 0

		for k, v in pairs(mapVotes) do

			if v > maxVotes then

				maxVotes = v

			end

		end

		for k, v in pairs(mapPool) do

			-- Does this current map reach the highest number of votes?
			if mapVotes[k] == maxVotes then

				table.insert(newMapTable, v)

			end

		end

		RunConsoleCommand("changelevel", newMapTable[math.random(#newMapTable)])

	end)

end

local function VoteForMap(ply, cmd, args)

	if args[1] == nil then

		local mapNames = string.Implode(", ", mapPool)

		ply:PrintMessage(3, "Valid maps to vote for are: (" .. mapNames .. ")")

	return end

	if voterTable != nil then

		for k, v in pairs(voterTable) do

			if v == ply then return end

		end

	end

	if isRaidEnded == false then print("I appreciate the enthusiasm " .. ply:GetName() .. " but the raid actually isn't done yet.") return end

	local votedMap = tostring( args[1] )

	local validMapVote = false

	-- This checks if the map they voted for actually like, you know, exists, and is supported. For example, loading into efgm_buttsex6969 has a non-zero chance of bricking the entire server, and loading into gm_flatgrass just probably won't be any fun.

	for k, v in pairs(mapPool) do
		if votedMap == "efgm_belmont" and #player.GetHumans() <= 4 then
			validMapVote = true
			print("Stop looking inside the code, you dumb fucko.")
		elseif v == votedMap then 
			validMapVote = true
			mapVotes[k] = mapVotes[k] + 1
			ply:PrintMessage(3, "Your vote for " .. votedMap .. " has been counted successfully!")
		end
	end

	if validMapVote == false then 
		print("Hey, can someone tell " .. ply:GetName() .. " that " .. votedMap .. " isn't actually a map that exists? Thanks.") return 
	end

end
concommand.Add("vote", VoteForMap)

function ENT:InitializeRaid()

	-- local baseSpawnTable = ents.FindByClass( "efgm_raid_spawn" )

	-- for k, v in pairs(baseSpawnTable) do
	-- 	if v.SpawnType != 2 then

	-- 		table.insert(raidStartSpawnTable, v)

	-- 	end
	-- end

	-- for k, v in pairs( player.GetHumans() ) do

	-- 	local randomSpawnInt = math.random(#raidStartSpawnTable)

	-- 	v:SetPos(raidStartSpawnTable[randomSpawnInt]:GetPos())
	-- 	v:SetAngles(raidStartSpawnTable[randomSpawnInt]:GetAngles())

	-- 	SetPlayerStatus(v, raidStartSpawnTable[randomSpawnInt].SpawnGroup, pmcClass)

	-- 	table.remove(raidStartSpawnTable, randomSpawnInt)

	-- end

	self.RaidStarted = true

	timer.Create("RaidTimer", self.RaidTime, 1, function() self:EndRaid() end)

	knownRaidTime = self.RaidTime

	print("A new raid has started, good luck!")

end

local function DoSmartSpawnStuff(spawns, minimumDistance)

	local finalSpawns = {}

	for k, v in pairs(spawns) do

		local willTableBeAdded = true

		for l, b in pairs(player.GetHumans()) do

			-- print(tostring( "Distance between player and spawn is:" .. v:GetPos():Distance( b:GetPos() ) ))

			if v:GetPos():Distance( b:GetPos() ) < minimumDistance then

				willTableBeAdded = false

			end

		end

		if willTableBeAdded == true then

			table.insert(finalSpawns, v)

		end

	end

	return finalSpawns

end

-- function ENT:GetSmartSpawn(class, useTeamSpawns)

-- 	local spawns = self:DetermineSpawnTable(class, useTeamSpawns)

-- 	local finalSpawns = DoSmartSpawnStuff(spawns, 6000)

-- 	if table.IsEmpty(finalSpawns) == true then

-- 		finalSpawns = DoSmartSpawnStuff(spawns, 6000 / 1.25)

-- 		if table.IsEmpty(finalSpawns) == true then

-- 			finalSpawns = DoSmartSpawnStuff(spawns, 6000 / 1.5)

-- 			if table.IsEmpty(finalSpawns) == true then

-- 				finalSpawns = DoSmartSpawnStuff(spawns, 6000 / 2)

-- 				if table.IsEmpty(finalSpawns) == true then

-- 					finalSpawns = DoSmartSpawnStuff(spawns, 6000 / 3)

-- 					if table.IsEmpty(finalSpawns) == true then

-- 						finalSpawns = DoSmartSpawnStuff(spawns, 6000 / 4)

-- 						if table.IsEmpty(finalSpawns) == true then

-- 							finalSpawns = DoSmartSpawnStuff(spawns, 6000 / 6)

-- 							if table.IsEmpty(finalSpawns) == true then

-- 								finalSpawns = DoSmartSpawnStuff(spawns, 6000 / 8)

-- 								if table.IsEmpty(finalSpawns) == true then

-- 									finalSpawns = DoSmartSpawnStuff(spawns, 6000 / 12)

-- 									if table.IsEmpty(finalSpawns) == true then

-- 										finalSpawns = DoSmartSpawnStuff(spawns, 6000 / 16)

-- 									end

-- 								end

-- 							end

-- 						end

-- 					end

-- 				end

-- 			end

-- 		end

-- 	end

-- 	if table.IsEmpty(finalSpawns) == false then

-- 		return finalSpawns[math.random(#finalSpawns)]

-- 	end

-- end

function ENT:DetermineSpawnTable(class, useTeamSpawns)

	local baseSpawnTable = ents.FindByClass( "efgm_raid_spawn" )
	local spawnTable = {}

	for k, v in pairs(baseSpawnTable) do

		-- 0 is universal, 1 is a PMC spawn, 2 is a Player Scav spawn.

		if class == "PMC" then

			if v.SpawnType != 2 then

				-- if useTeamSpawns == true then

				-- 	if v.IsTeamSpawn == true then table.insert(spawnTable, v) end

				-- end

				-- if useTeamSpawns == false then

				-- end

				table.insert(spawnTable, v)

			end

		end

		if class == "PlayerScav" then

			if v.SpawnType != 1 then

				-- if useTeamSpawns == true then

				-- 	if v.IsTeamSpawn == true then table.insert(spawnTable, v) end

				-- end

				-- if useTeamSpawns == false then

				-- 	table.insert(spawnTable, v)

				-- end

				table.insert(spawnTable, v)

			end

		end

	end

	return spawnTable

end

function ENT:IndividualSpawn(ply, class, raidHasStarted)

	local randomSpawnTable = self:DetermineSpawnTable(class, false)

	local randomSpawn = randomSpawnTable[math.random(#randomSpawnTable)]

	-- This is for debugging, leave it alone, I'll remove it when it needs to be removed

	-- for k, v in pairs( randomSpawn.TeamSpawnVectors ) do

	-- 	local totallyFriendlyTeammateForDebugging = ents.Create( "npc_combine_s" )
	-- 	totallyFriendlyTeammateForDebugging:SetPos( v )
	-- 	totallyFriendlyTeammateForDebugging:Spawn( )

	-- end

	SpawnPlayer(ply, randomSpawn.SpawnGroup, class, randomSpawn:GetPos(), randomSpawn:GetAngles())

end

function ENT:PartySpawn(players, class)

	local randomSpawnTable = self:DetermineSpawnTable(class, true)

	local randomSpawn = randomSpawnTable[math.random(#randomSpawnTable)]

	local spawnVectors = randomSpawn.TeamSpawnVectors

	for k, v in pairs(players) do

		if v:GetNWBool("inRaid") == false then

			local spawnInt = math.random(#spawnVectors)

			SpawnPlayer(v, randomSpawn.SpawnGroup, class, spawnVectors[spawnInt], randomSpawn:GetAngles())

			table.remove(spawnVectors, spawnInt)

		end

	end

end

hook.Add("PlayerDisconnected", "PlayerLeave", function(ply) RemoveFromTable(ply) end)

hook.Add( "PlayerDeath", "PlayerDie", function( victim, inflictor, attacker )

	SetPlayerStatus(victim, nil, noClass)

	victim:SetNWBool("inRaid", false)

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
			for k, v in pairs(player.GetHumans()) do
				if k < 2 then
					ply:PrintMessage(3, "Not enough players to start a raid!")
				elseif k >= 3 and self.RaidStarted == false then
					self:InitializeRaid()
					hook.Call( "RaidStart", nil )
				end
			end
		end

		if ply:GetNWString("playerTeam") == "" then
		end

		if self.RaidStarted == true then
			self:IndividualSpawn(ply, "PMC", false)
		end
		-- if ply:GetNWString("playerTeam") != "" then
		-- 	local partyName = ply:GetNWString("playerTeam")
		-- 	local partyPlayers = GetAllFromParty(partyName)
		-- 	self:PartySpawn(partyPlayers, "PMC", false)
		-- end
	end
end