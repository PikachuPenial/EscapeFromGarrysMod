-- Used mostly for shared functions, I could use this for other stuff but I won't. Okay, maybe for globals but thats it. On god.

maxTeamSize = 5

function CheckIfTeamExists(teamName)

	for k, v in pairs(player.GetHumans()) do

		local partyName = v:GetNWString("playerTeam")

		if partyName == teamName then

			return true

		end

	end

	return false

end

function FindAllInTeam(teamName)

	local members = {}

	for k, v in pairs(player.GetHumans()) do

		local partyName = v:GetNWString("playerTeam")

		if partyName == teamName then

			table.insert( members, v )

		end

	end

	if table.IsEmpty( members ) == true then

		return nil

	elseif table.IsEmpty( members ) == false then

		return members

	end

end

function FindTeamLeader(teamName)

	if teamName == nil then return nil end

	for k, v in pairs(player.GetHumans()) do

		if v:GetNWString("playerTeam") == teamName && v:GetNWBool("teamLeader") == true then

			return v

		end

	end

	return nil

end

function FindAllTeams()

	local parties = {}

	for k, v in pairs(player.GetHumans()) do

		if v:GetNWBool("teamLeader") == true then

			local partyName = v:GetNWString("playerTeam")

			if partyName != "" then

				table.insert( parties, partyName )

			end

		end

	end

	if table.IsEmpty( parties ) == true then

		return nil

	elseif table.IsEmpty( parties ) == false then

		return parties

	end

end