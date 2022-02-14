ENT.Type = "point"
ENT.Base = "base_point"

ENT.RaidStarted = false
ENT.RaidTime = 1200

local pmcClass = "PMC"
local playerScavClass = "PlayerScav"
local noClass = "NotInRaid"


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

	minsLeft = math.Truncate(raidTimeLeft / 60, 0)
	secsLeft = math.Truncate(raidTimeLeft - (minsLeft * 60), 0)
	timeLeftClean = tostring(minsLeft..":"..secsLeft)

	if raidTimeLeft == 0 or raidTimeLeft == nil then
		return "Raid is over!"
	else
		return tostring(timeLeftClean)
	end
end

function ENT:Think()
	net.Start("RaidTimeLeft")
		net.WriteString(RaidTimeLeft())
	net.Broadcast()
end

function ENT:EndRaid()

	for k, v in pairs(playerStatusTable) do

		if v[3] != noClass then
			v[1]:KillSilent()
			
			SetPlayerStatus(v[1], nil, noClass)
		end

	end

	for k, v in pairs( player.GetHumans() ) do

		v:PrintMessage( HUD_PRINTCENTER, "The raid is over!\nIf you did not exit the raid in time, you have lost everything you brough in.\nPlease vote for a new map." )

	end

	self:TriggerOutput("OnRaidEnd", self, nil)

end

function ENT:InitializeRaid()

	local baseSpawnTable = ents.FindByClass( "efgm_raid_spawn" )
	local spawnTable = {}

	for k, v in pairs(baseSpawnTable) do
		if v.SpawnType != 1 then

			table.insert(spawnTable, v)

		end
	end

	for k, v in pairs( player.GetHumans() ) do

		local randomSpawnInt = math.random(#spawnTable)

		v:SetPos(spawnTable[randomSpawnInt]:GetPos())
		v:SetAngles(spawnTable[randomSpawnInt]:GetAngles())

		SetPlayerStatus(v, spawnTable[randomSpawnInt].SpawnGroup, pmcClass)

		table.remove(spawnTable, randomSpawnInt)

	end

	self.RaidStarted = true

	timer.Create("RaidTimer", self.RaidTime, 1, function() self:EndRaid() end)

	print("A new raid has started, good luck!")

end

function ENT:ScavSpawn(ply)

	local baseSpawnTable = ents.FindByClass( "efgm_raid_spawn" )
	local spawnTable = {}

	for k, v in pairs(baseSpawnTable) do

	end

	local randomSpawn = spawnTable[math.random(#spawnTable)]

	SpawnPlayer(ply, randomSpawn.SpawnGroup, playerScavClass, randomSpawn:GetPos(), randomSpawn:GetAngles())

end

function ENT:PMCSpawn(ply)

	local baseSpawnTable = ents.FindByClass( "efgm_raid_spawn" )
	local spawnTable = {}

	for k, v in pairs(baseSpawnTable) do
		if v.SpawnType != 2 then

			table.insert(spawnTable, v)

		end
	end

	local randomSpawn = spawnTable[math.random(#spawnTable)]

	SpawnPlayer(ply, randomSpawn.SpawnGroup, pmcClass, randomSpawn:GetPos(), randomSpawn:GetAngles())

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

function ENT:AcceptInput(name, ply, caller, data)
	if name == "StartRaid" then
		if self.RaidStarted == false then
			self:InitializeRaid()
		elseif self.RaidStarted == true then
			self:PMCSpawn(ply)
		end
	end
end