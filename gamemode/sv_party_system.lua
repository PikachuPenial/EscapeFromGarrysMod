

function JoinParty(ply, partyName)

	ply:SetNWString("playerTeam", partyName)

end

function LeaveParty(ply, partyName)

	ply:SetNWString("playerTeam", "")

end

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