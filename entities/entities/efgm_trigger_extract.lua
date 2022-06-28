ENT.Type = "brush"
ENT.Base = "base_brush"

ENT.ExtractTime = 1
ENT.ExtractName = ""
ENT.DisabledMessage = ""
ENT.ExtractGroup = "All"

ENT.Disabled = false
ENT.Available = 0

local playersVisted = {}

function ENT:KeyValue(key, value)
	if key == "extract_time" then
		self.ExtractTime = tonumber(value)
	end

	if key == "extract_name" then
		self.ExtractName = tostring(value)
	end

	if key == "disabled_message" then
		self.DisabledMessage = tostring(value)
	end

	if key == "extract_group" then
		self.ExtractGroup = tostring(value)
	end

	if key == "start_extract_disabled" then
		self.Disabled = tobool(value)
	end

	if key == "availability" then
		self.Available = tonumber(value)
	end

end

local function VectorInside(vec, mins, maxs)
	return (	vec.x > mins.x and vec.x < maxs.x
			and	vec.y > mins.y and vec.y < maxs.y
			and	vec.z > mins.z and vec.z < maxs.z)
end

function ENT:Initialize()

end

function ENT:CheckForPlayers()

	-- Setting variables

	local mins = self:LocalToWorld(self:OBBMins())
	local maxs = self:LocalToWorld(self:OBBMaxs())

	for iteration, ply in ipairs(player.GetAll()) do

		if IsValid(ply) and ply:Alive() then

			local pos = ply:GetPos()

			if self.ExtractGroup == "All" or self.ExtractGroup == CheckSpawnGroup(ply) then

				if VectorInside(pos, mins, maxs) then

					if self.Disabled == true then

						for k, v in pairs(playersVisted) do
							if ply == v then
								return
							end
						end

						ply:PrintMessage( HUD_PRINTTALK, self.DisabledMessage )

						table.insert(playersVisted, ply)

					return end

					if timer.Exists(ply:GetName() .. self.ExtractName .. "_timer") == false then

						ply:PrintMessage( HUD_PRINTCENTER, "You will extract in " .. self.ExtractTime .. " seconds through " .. self.ExtractName .. "!" )

						ply:SetNWInt("raidSuccess", 1)

						timer.Create( ply:GetName() .. self.ExtractName .. "_timer" , self.ExtractTime, 1, function()

							if ply:Alive() then

								ply:PrintMessage( HUD_PRINTCENTER, "You have extracted from the raid through " .. self.ExtractName .. "! Good job!" )

								local lobbySpawns = ents.FindByName("lobby_spawns")
								local chosenSpawn = lobbySpawns[math.random(#lobbySpawns)]
								local expGained = math.random(250, 600)

								if (ply:GetNWInt("runThrough") == 0) then
									ply:SetNWInt("raidsExtracted", ply:GetNWInt("raidsExtracted") + 1)
									ply:SetNWInt("extractionStreak", ply:GetNWInt("extractionStreak") + 1)

									if ply:GetNWInt("extractionStreak") >= ply:GetNWInt("highestExtractionStreak") then
										ply:SetNWInt("highestExtractionStreak", ply:GetNWInt("extractionStreak"))
									end

									if ply:GetNWInt("successfulOperationsComplete") == 0 then
										ply:SetNWInt("mapExtracts", ply:GetNWInt("mapExtracts") + 1)
									end

									if ply:GetNWInt("raidKill") >= 3 and ply:GetNWInt("weeklyExtractsComplete") == 0 then
										ply:SetNWInt("weeklyExtracts", ply:GetNWInt("weeklyExtracts") + 1)
									end

									if ply:GetNWInt("raidKill") >= 12 and ply:GetNWInt("weeklyNuclearComplete") == 0 then
										ply:SetNWInt("weeklyNuclear", ply:GetNWInt("weeklyNuclear") + 1)
									end

									if (ply:GetNWInt("playerLvl") < 32) then
										ply:SetNWInt("playerExp", math.Round(ply:GetNWInt("playerExp") + (expGained * ply:GetNWInt("expMulti"))), 1)
										ply:SetNWInt("raidXP", math.Round(ply:GetNWInt("raidXP") + (expGained * ply:GetNWInt("expMulti"))), 1)
										ply:SetNWInt("playerTotalXpEarned", math.Round(ply:GetNWInt("playerTotalXpEarned") + (expGained * ply:GetNWInt("expMulti"))), 1)
										ply:SetNWInt("playerTotalXpEarnedExplore", math.Round(ply:GetNWInt("playerTotalXpEarnedExplore") + (expGained * ply:GetNWInt("expMulti"))), 1)
									end

									checkForSuccessfulOperations(ply)
									checkForWeeklyTwo(ply)
									checkForWeeklyThree(ply)
									checkForLevel(ply)
								end

								if (ply:GetNWInt("runThrough") == 1) then
									ply:SetNWInt("raidsRanThrough", ply:GetNWInt("raidsRanThrough") + 1)
								end

								ply:SetNWInt("raidSuccess", 1)

								if (ply:GetNWInt("extractionStreak") == 1) then
									ply:SetNWInt("expMulti", 1.10)
								else
									if (ply:GetNWInt("extractionStreak") == 2) then
										ply:SetNWInt("expMulti", 1.20)
									else
										if (ply:GetNWInt("extractionStreak") == 3) then
											ply:SetNWInt("expMulti", 1.30)
										else
											if (ply:GetNWInt("extractionStreak") == 4) then
												ply:SetNWInt("expMulti", 1.40)
											else
												if (ply:GetNWInt("extractionStreak") >= 5) then
													ply:SetNWInt("expMulti", 1.50)
												end
											end
										end
									end
								end

								ply:ConCommand("open_raid_summary_menu")

								ply:SetPos(chosenSpawn:GetPos())
								ply:SetAngles(chosenSpawn:GetAngles())

								SetPlayerStatus(ply, nil, "NotInRaid")

								ply:SetNWBool("inRaid", false)

								hook.Run("PlayerExtract", ply, self.ExtractName)

							end

						end)

					end

				elseif not VectorInside(pos, mins, maxs) then

					if self.Disabled == true then

						for k, v in pairs(playersVisted) do
							if ply == v then
								table.remove(playersVisted, k)
							end
						end

						return
					end

					if timer.Exists(ply:GetName() .. self.ExtractName .. "_timer") == true then

						ply:PrintMessage( HUD_PRINTCENTER, "You have left the " .. self.ExtractName .. " extract!" )

						pmcInRaid = false

						timer.Remove( ply:GetName() .. self.ExtractName .. "_timer" )
					end

				end

			end

		end

	end

end

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

function ENT:Think()
	self:CheckForPlayers()
end

function ENT:AcceptInput(name, activator, caller)
	if name == "EnableExtract" then
		self.Disabled = false
	end

	if name == "DisableExtract" then
		self.Disabled = true
	end
end
