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

	if teamName == "" or teamName == nil then return end
	if password == "" or password == nil  then return end

	if CheckIfTeamExists(teamName) == false then return end

	if teamName == ply:GetNWString("playerTeam") then ply:PrintMessage(3, "You are already in " .. teamName .. "!") return end

	local teamPassword = CheckTeamPassword(teamName)

	if teamPassword == nil then return end

	if teamPassword == password then

		ply:SetNWString("playerTeam", teamName)
		ply:SetNWString("teamPassword", "")
		ply:SetNWBool("teamLeader", false)

		ply:PrintMessage(3, "You have joined " .. teamName .. "!")

	elseif teamPassword != password then

		ply:PrintMessage(3, "You have the wrong password! You entered " .. password .. ", while the server recognizes " .. teamPassword .. " as the actual password. God, I hope I remove this when I get done debugging.")

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
	if password == "" or password == nil  then return end

	if CheckIfTeamExists(teamName) == true then ply:PrintMessage( 2, teamName .. " already exists!" ) return end

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