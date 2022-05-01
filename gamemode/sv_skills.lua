--Functions that check if a player leveled up a specific skill, this makes stuff work.

function checkForEndurance(ply)
	local enduranceExpToLevel = (ply:GetNWInt("enduranceLevel") * 3)
	local enduranceCurExp = ply:GetNWInt("enduranceExperience")
	local enduranceCurLvl = ply:GetNWInt("enduranceLevel")

	if (enduranceCurExp >= enduranceExpToLevel) then
		enduranceCurExp = enduranceCurExp - enduranceExpToLevel

		ply:SetNWInt("enduranceExperience", enduranceCurExp)
		ply:SetNWInt("enduranceLevel", enduranceCurLvl + 1)

		ply:SetNWInt("enduranceEffect", ply:GetNWInt("enduranceEffect") + 1)

		ply:PrintMessage(HUD_PRINTCENTER, "You have increased your Endurance skill to level " .. (enduranceCurLvl + 1) .. ".", Color(85, 0, 255, 255), 0)
	end
end

function checkForStrength(ply)
	local strengthExpToLevel = (ply:GetNWInt("strengthLevel") * 2)
	local strengthCurExp = ply:GetNWInt("strengthExperience")
	local strengthCurLvl = ply:GetNWInt("strengthLevel")

	if (strengthCurExp >= strengthExpToLevel) then
		strengthCurExp = strengthCurExp - strengthExpToLevel

		ply:SetNWInt("strengthExperience", strengthCurExp)
		ply:SetNWInt("strengthLevel", strengthCurLvl + 1)

		ply:SetNWInt("strengthEffect", ply:GetNWInt("strengthEffect") + 1)

		ply:PrintMessage(HUD_PRINTCENTER, "You have increased your Strength skill to level " .. (strengthCurLvl + 1) .. ".", Color(85, 0, 255, 255), 0)
	end
end

function checkForCharisma(ply)
	local charismaExpToLevel = (ply:GetNWInt("charismaLevel") * 5)
	local charismaCurExp = ply:GetNWInt("charismaExperience")
	local charismaCurLvl = ply:GetNWInt("charismaLevel")

	if (charismaCurExp >= charismaExpToLevel) then
		charismaCurExp = charismaCurExp - charismaExpToLevel

		ply:SetNWInt("charismaExperience", charismaCurExp)
		ply:SetNWInt("charismaLevel", charismaCurLvl + 1)

		ply:SetNWInt("charismaEffect", ply:GetNWInt("charismaEffect") - 0.01)

		ply:PrintMessage(HUD_PRINTCENTER, "You have increased your Charisma skill to level " .. (charismaCurLvl + 1) .. ".", Color(85, 0, 255, 255), 0)
	end
end

function checkForCovert(ply)
	local covertExpToLevel = (ply:GetNWInt("covertLevel") * 2)
	local covertCurExp = ply:GetNWInt("covertExperience")
	local covertCurLvl = ply:GetNWInt("covertLevel")

	if (covertCurExp >= covertExpToLevel) then
		covertCurExp = covertCurExp - covertExpToLevel

		ply:SetNWInt("covertExperience", covertCurExp)
		ply:SetNWInt("covertLevel", covertCurLvl + 1)

		ply:SetNWInt("covertEffect", ply:GetNWInt("covertEffect") + 0.01)

		ply:PrintMessage(HUD_PRINTCENTER, "You have increased your Covert Movement skill to level " .. (covertCurLvl + 1) .. ".", Color(85, 0, 255, 255), 0)
	end
end

--Endurance Tracking
hook.Add("Initialize", "EnduranceLoop", function()
	timer.Create("EnduranceSkillLoop", 1, 0, function()
		for k, v in pairs(player.GetHumans()) do
			if v:GetNWBool("inRaid") == true and v:IsSprinting() == true and (v:GetNWInt("enduranceFatigue") < 240) then
				local enduranceExpGained = math.random(3, 5) / 100

				v:SetNWInt("enduranceExperience", v:GetNWInt("enduranceExperience") + enduranceExpGained)
				v:SetNWInt("enduranceFatigue", v:GetNWInt("enduranceFatigue") + 1)
				checkForEndurance(v)
			elseif v:GetNWBool("inRaid") == true and v:IsSprinting() == true then
				local enduranceExpGained = math.random(1, 3) / 100

				v:SetNWInt("enduranceExperience", v:GetNWInt("enduranceExperience") + enduranceExpGained)
				v:SetNWInt("enduranceFatigue", v:GetNWInt("enduranceFatigue") + 1)
				checkForEndurance(v)
			else
				return false
			end
		end
	end)

end)

--Strength Tracking
hook.Add("Initialize", "StrengthLoop", function()
	timer.Create("StrengthSkillLoop", 1, 0, function()
		for k, v in pairs(player.GetHumans()) do
			if v:GetNWBool("inRaid") == true and v:IsOnGround() == false and (v:GetNWInt("strengthFatigue") < 50) then
				local strengthExpGained = math.random(4, 6) / 100

				v:SetNWInt("strengthExperience", v:GetNWInt("strengthExperience") + strengthExpGained)
				v:SetNWInt("strengthFatigue", v:GetNWInt("strengthFatigue") + 1)
				checkForStrength(v)
			elseif v:GetNWBool("inRaid") == true and v:IsOnGround() == false then
				local strengthExpGained = math.random(2, 4) / 100

				v:SetNWInt("strengthExperience", v:GetNWInt("strengthExperience") + strengthExpGained)
				v:SetNWInt("strengthFatigue", v:GetNWInt("strengthFatigue") + 1)
				checkForStrength(v)
			else
				return false
			end
		end
	end)

end)

--Covert Movement Tracking
hook.Add("Initialize", "CovertLoop", function()
	timer.Create("CovertSkillLoop", 1, 0, function()
		for k, v in pairs(player.GetHumans()) do
			if v:GetNWBool("inRaid") == true and v:Crouching() == true and (v:GetNWInt("covertFatigue") < 120) then
				local covertExpGained = math.random(3, 4) / 100

				v:SetNWInt("covertExperience", v:GetNWInt("covertExperience") + covertExpGained)
				v:SetNWInt("covertFatigue", v:GetNWInt("covertFatigue") + 1)
				checkForCovert(v)
			elseif v:GetNWBool("inRaid") == true and v:Crouching() == true then
				local covertExpGained = math.random(1, 2) / 100

				v:SetNWInt("covertExperience", v:GetNWInt("covertExperience") + covertExpGained)
				v:SetNWInt("covertFatigue", v:GetNWInt("covertFatigue") + 1)
				checkForCovert(v)
			else
				return false
			end
		end
	end)

end)