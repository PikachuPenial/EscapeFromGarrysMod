
local function CheckIfTeamExists(teamName)

	for k, v in pairs(player.GetHumans()) do

		local partyName = v:GetNWString("playerTeam")

		if partyName == teamName then

			return true

		end

	end

	return false

end

function CreateTeam(ply, teamName)

	ply:SetNWString("playerTeam", teamName)
	ply:SetNWBool("teamLeader", true)

	ply:PrintMessage(2, "Created team " .. teamName)

end
concommand.Add("party_create", function(ply, cmd, args)

	teamName = table.concat( args, " " )

	if teamName == "" then return end

	if CheckIfTeamExists(teamName) == true then ply:PrintMessage( 2, teamName .. " already exists!" ) return end

	CreateTeam(ply, teamName)

end)

function JoinParty(ply, cmd, args)

	if ply:IsAdmin() == false then return end

	local teamName = table.concat( args, " " )

	ply:SetNWString("playerTeam", teamName)
	ply:SetNWBool("teamLeader", false)

end
concommand.Add("party_join", JoinParty)

function LeaveParty(ply, cmd, args)

	if ply:IsAdmin() == false then return end

	ply:SetNWString("playerTeam", "")
	ply:SetNWBool("teamLeader", true)

end
concommand.Add("party_leave", JoinParty)

function PrintPartyMembers(ply, cmd, args)

	if ply:IsAdmin() == false then return end

	if args[1] == nil or args[1] == "" then return end

	local partyName = args[1]

	local partyTable = {}

	for k, v in pairs(player.GetHumans()) do

		if v:GetNWString("playerTeam") == partyName then

			table.insert( partyTable, v:GetName() )

		end

	end

	PrintTable( partyTable )

end
concommand.Add("party_members", PrintPartyMembers)


function GetAllFromParty(partyName)

	local partyTable = {}

	for k, v in pairs(player.GetHumans()) do

		if v:GetNWString("playerTeam") == partyName then

			table.insert( partyTable, v )

		end

	end

	return partyTable

end

hook.Add( "PlayerInitialSpawn", "ResetParty", function(ply)

	ply:SetNWString("playerTeam", "")
	ply:SetNWBool("teamLeader", true)

end)