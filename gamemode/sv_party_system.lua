

function JoinParty(ply, cmd, args)

	local partyName = args[1]

	ply:SetNWString("playerTeam", partyName)

end
concommand.Add("party_join", JoinParty)

function LeaveParty(ply, cmd, args)

	ply:SetNWString("playerTeam", "")

end
concommand.Add("party_leave", JoinParty)

function PrintPartyMembers(ply, cmd, args)

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

end)