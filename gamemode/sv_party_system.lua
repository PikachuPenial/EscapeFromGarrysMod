function LeaveParty(ply, cmd, args)

	ply:SetNWString("playerTeam", "")
	ply:SetNWString("teamPassword", "")
	ply:SetNWBool("teamLeader", true)

end
concommand.Add("party_leave", LeaveParty)

function CheckTeamPassword(teamName)

	if CheckIfTeamExists(teamName) == false then return end

	local members = FindAllInTeam(teamName)

	for k, v in pairs(members) do

		if v:GetNWBool("teamLeader") == true then

			print(v:GetNWString("teamPassword"))

			return v:GetNWString("teamPassword")

		end

	end

	return nil

end

function JoinParty(ply, cmd, args)

	local teamName = args[1]
	local password = args[2]

	if teamName == "" or teamName == nil then ply:PrintMessage(3, "You must specify a team!") return end
	if password == nil then password = "" end

	if CheckIfTeamExists(teamName) == false then ply:PrintMessage(3, teamName .. " does not exist!") return end

	if teamName == ply:GetNWString("playerTeam") then ply:PrintMessage(3, "You are already in " .. teamName .. "!") return end

	if #FindAllInTeam(teamName) >= maxTeamSize then ply:PrintMessage(3, "" .. teamName .. " is full!") return end

	local teamPassword = CheckTeamPassword(teamName)

	if teamPassword == nil then teamPassword = "" end

	if teamPassword == password then

		ply:SetNWString("playerTeam", teamName)
		ply:SetNWString("teamPassword", "")
		ply:SetNWBool("teamLeader", false)

		ply:PrintMessage(3, "You have joined " .. teamName .. "!")

	elseif teamPassword != password then

		--This used to be very yikes
		ply:PrintMessage(3, "You have the wrong password!")

	end

end
concommand.Add("party_join", JoinParty)

function CreateTeam(ply, teamName, password)

	ply:SetNWString("playerTeam", teamName)
	ply:SetNWString("teamPassword", password)
	ply:SetNWBool("teamLeader", true)

	ply:PrintMessage(2, "Created team " .. teamName .. " with password " .. password)

end
concommand.Add("party_create", function(ply, cmd, args)

	local teamName = args[1]
	local password = args[2]

	if teamName == "" or teamName == nil then return end
	if password == nil then password = "" end

	if CheckIfTeamExists(teamName) == true then ply:PrintMessage( 2, teamName .. " already exists!" ) return end

	if ply:GetNWString("playerTeam") != "" then ply:PrintMessage( 2, "You are already in a team!" ) return end

	CreateTeam(ply, teamName, password)

end)

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
concommand.Add("party_debug_members", PrintPartyMembers)

hook.Add( "PlayerInitialSpawn", "ResetParty", function(ply)

	ply:SetNWString("playerTeam", "")
	ply:SetNWString("teamPassword", "")
	ply:SetNWBool("teamLeader", true)

end)