function buyEntity(ply, cmd, args)
	local entityPrices = {}
	entityPrices[1] = {"efgm_weapon_crate_low", "5555", "2"}
	entityPrices[2] = {"efgm_weapon_crate_mid", "13000", "4"}
	entityPrices[3] = {"efgm_weapon_crate_high", "20000", "8"}
	entityPrices[4] = {"arccw_ammo_smg1", "4000", "2"}
	entityPrices[5] = {"arccw_ammo_smg1_large", "9000", "5"}
	entityPrices[6] = {"arccw_ammo_357", "4000", "2"}
	entityPrices[7] = {"arccw_ammo_357_large", "9000", "5"}
	entityPrices[8] = {"arccw_ammo_pistol", "4000", "2"}
	entityPrices[9] = {"arccw_ammo_pistol_large", "9000", "5"}
	entityPrices[10] = {"arccw_ammo_ar2", "4000", "2"}
	entityPrices[11] = {"arccw_ammo_ar2_large", "9000", "5"}
	entityPrices[12] = {"arccw_ammo_buckshot", "4000", "2"}
	entityPrices[13] = {"arccw_ammo_buckshot_large", "9000", "5"}
	entityPrices[14] = {"arccw_ammo_sniper", "4000", "2"}
	entityPrices[15] = {"arccw_ammo_sniper_large", "9000", "5"}
	entityPrices[16] = {"arccw_ammo_smg1_grenade", "4000", "5"}
	entityPrices[17] = {"arccw_ammo_smg1_grenade_large", "12000", "10"}
	entityPrices[18] = {"fas2_ammo_bandages", "1250", "2"}
	entityPrices[19] = {"fas2_ammo_quikclots", "2750", "4"}
	entityPrices[20] = {"fas2_ammo_hemostats", "4000", "6"}
	entityPrices[21] = {"ent_jack_gmod_ezarmor_module3m", "7350", "3"}
	entityPrices[22] = {"ent_jack_gmod_ezarmor_paca", "8275", "5"}
	entityPrices[23] = {"ent_jack_gmod_ezarmor_untar", "8890", "6"}
	entityPrices[24] = {"ent_jack_gmod_ezarmor_zhukpress", "10000", "8"}
	entityPrices[25] = {"ent_jack_gmod_ezarmor_trooper", "11705", "10"}
	entityPrices[26] = {"ent_jack_gmod_ezarmor_6b13flora", "13200", "12"}
	entityPrices[27] = {"ent_jack_gmod_ezarmor_korundvm", "16555", "14"}
	entityPrices[28] = {"ent_jack_gmod_ezarmor_6b13m", "19950", "16"}
	entityPrices[29] = {"ent_jack_gmod_ezarmor_hexgrid", "25555", "19"}
	entityPrices[30] = {"ent_jack_gmod_ezarmor_slicktan", "32555", "23"}
	entityPrices[31] = {"ent_jack_gmod_ezarmor_shlemofon", "6805", "3"}
	entityPrices[32] = {"ent_jack_gmod_ezarmor_shpmhelm", "7790", "5"}
	entityPrices[33] = {"ent_jack_gmod_ezarmor_untarhelm", "8400", "6"}
	entityPrices[34] = {"ent_jack_gmod_ezarmor_ssh68", "9310", "8"}
	entityPrices[35] = {"ent_jack_gmod_ezarmor_mich2001", "11250", "10"}
	entityPrices[36] = {"ent_jack_gmod_ezarmor_twexfilb", "12705", "12"}
	entityPrices[37] = {"ent_jack_gmod_ezarmor_ulachcoyote", "14950", "14"}
	entityPrices[38] = {"ent_jack_gmod_ezarmor_maska1shkilla", "18400", "16"}
	entityPrices[39] = {"ent_jack_gmod_ezarmor_altyn", "23335", "19"}
	entityPrices[40] = {"ent_jack_gmod_ezarmor_ryst", "29995", "23"}
	entityPrices[41] = {"ent_jack_gmod_ezarmor_pnv10t", "25000", "10"}
	entityPrices[42] = {"ent_jack_gmod_ezarmor_t7thermal", "40000", "15"}
	entityPrices[43] = {"ent_jack_gmod_ezarmor_gp5", "6000", "3"}
	entityPrices[44] = {"ent_jack_gmod_ezarmor_sotr", "12500", "6"}
	entityPrices[45] = {"ent_jack_gmod_ezarmor_shpmface", "6500", "4"}
	entityPrices[46] = {"ent_jack_gmod_ezarmor_twexfilshieldc", "6500", "8"}
	entityPrices[47] = {"ent_jack_gmod_ezarmor_altynface", "12950", "12"}
	entityPrices[48] = {"ent_jack_gmod_ezarmor_rystface", "16005", "16"}
	entityPrices[49] = {"ent_jack_gmod_ezarmor_weldingkill", "22555", "20"}
	entityPrices[50] = {"ent_jack_gmod_ezarmor_shlemmaskkilla", "29995", "24"}

	for k, v in pairs(entityPrices) do
		if (args[1] == v[1]) then
			local balance = (ply:GetNWInt("playerMoney"))
			local playerLvl = ply:GetNWInt("playerLvl")
			local levelReq = tonumber(v[3])

			local ent = ents.Create(args[1])
			local tr = ply:GetEyeTrace()

			if (!tr.Hit) then return end

			if (ply:GetNWInt("charismaEffect") == 0) then
				entCost = tonumber(v[2])
			else
				entCost = math.Round(tonumber(v[2]) * ply:GetNWInt("charismaEffect"), 0)
			end

			if (playerLvl >= levelReq) then
				if (balance >= entCost) then
					local charExpGain = (ply:GetNWInt("charismaExperience") + entCost)
					local charExp = charExpGain / 1750

					local SpawnPos = ply:GetShootPos() + ply:GetForward() * 80

					ent.Owner = ply

					ent:SetPos(SpawnPos)
					ent:Spawn()
					ent:Activate()

					ply:SetNWInt("playerMoney", balance - entCost)
					ply:SetNWInt("playerTotalMoneySpent", ply:GetNWInt("playerTotalMoneySpent") + entCost)
					ply:SetNWInt("playerTotalMoneySpentItem", ply:GetNWInt("playerTotalMoneySpentItem") + entCost)

					if (ply:GetNWInt("charismaLevel") < 40) then
						ply:SetNWInt("charismaExperience", ply:GetNWInt("charismaExperience") + charExp)
						checkForCharisma(ply)
					end
				else
					ply:PrintMessage(HUD_PRINTTALK, "You do not have enough roubles to purchase this item.")
				end
			else
				ply:PrintMessage(HUD_PRINTTALK, "You must be level " .. levelReq .. " to purchase this item.")
			end

			return
		end
	end
end
concommand.Add("buy_entity", buyEntity)

function buyGun(ply, cmd, args)
	local weaponPrices = {}
	weaponPrices[1] = {"arccw_dmi_b92f_auto", "13005", "7"}
	weaponPrices[2] = {"arccw_waw_dp28", "21370", "14"}
	weaponPrices[3] = {"arccw_eft_aks74u", "9980", "5"}
	weaponPrices[4] = {"arccw_eft_1911", "4140", "1"}
	weaponPrices[5] = {"arccw_eft_mp5", "10995", "6"}
	weaponPrices[6] = {"arccw_eft_mp5sd", "9995", "5"}
	weaponPrices[7] = {"arccw_eft_mp7", "13195", "7"}
	weaponPrices[8] = {"arccw_eft_ppsh", "8440", "5"}
	weaponPrices[9] = {"arccw_eft_t5000", "18050", "12"}
	weaponPrices[10] = {"arccw_eft_ump", "10050", "6"}
	weaponPrices[11] = {"arccw_eap_aek", "17120", "11"}
	weaponPrices[12] = {"arccw_eap_fmg9", "15555", "10"}
	weaponPrices[13] = {"arccw_eap_groza", "13580", "10"}
	weaponPrices[14] = {"arccw_eap_lebedev", "4630", "1"}
	weaponPrices[15] = {"arccw_eap_spectre", "11010", "7"}
	weaponPrices[16] = {"arccw_eap_stg44", "13100", "9"}
	weaponPrices[17] = {"arccw_eap_usas", "27510", "16"}
	weaponPrices[18] = {"arccw_slog_altor", "5005", "2"}
	weaponPrices[19] = {"arccw_go_nade_incendiary", "2500", "2"}
	weaponPrices[20] = {"arccw_go_nade_frag", "2500", "2"}
	weaponPrices[21] = {"arccw_go_nade_flash", "2500", "2"}
	weaponPrices[22] = {"arccw_go_nade_smoke", "2500", "2"}
	weaponPrices[23] = {"arccw_go_nade_molotov", "2500", "2"}
	weaponPrices[24] = {"arccw_go_nade_knife", "2500", "2"}
	weaponPrices[25] = {"arccw_ur_deagle", "6005", "4"}
	weaponPrices[26] = {"midnights_gso_xm8", "18920", "14"}
	weaponPrices[27] = {"arccw_midnightwolf_type20", "17880", "13"}
	weaponPrices[28] = {"arccw_ud_glock", "6005", "3"}
	weaponPrices[29] = {"arccw_ud_m16", "16995", "12"}
	weaponPrices[30] = {"arccw_ud_m1014", "12995", "8"}
	weaponPrices[31] = {"arccw_ud_m79", "22555", "18"}
	weaponPrices[32] = {"arccw_ud_mini14", "16420", "12"}
	weaponPrices[33] = {"arccw_ud_870", "10240", "6"}
	weaponPrices[34] = {"arccw_ud_uzi", "11040", "6"}
	weaponPrices[35] = {"arccw_ur_ak", "17005", "13"}
	weaponPrices[36] = {"arccw_mifl_fas2_famas", "16990", "12"}
	weaponPrices[37] = {"arccw_mifl_fas2_g36c", "14445", "11"}
	weaponPrices[38] = {"arccw_mifl_fas2_g3", "16310", "12"}
	weaponPrices[39] = {"arccw_mifl_fas2_ks23", "13005", "8"}
	weaponPrices[40] = {"arccw_mifl_fas2_m24", "18900", "14"}
	weaponPrices[41] = {"arccw_mifl_fas2_m3", "14505", "12"}
	weaponPrices[42] = {"arccw_mifl_fas2_m82", "20999", "18"}
	weaponPrices[43] = {"arccw_mifl_fas2_mac11", "8100", "5"}
	weaponPrices[44] = {"arccw_fml_fas2_custom_mass26", "17550", "14"}
	weaponPrices[45] = {"arccw_mifl_fas2_minimi", "19995", "16"}
	weaponPrices[46] = {"arccw_mifl_fas2_ragingbull", "7020", "4"}
	weaponPrices[47] = {"arccw_mifl_fas2_rpk", "14765", "10"}
	weaponPrices[48] = {"arccw_mifl_fas2_sg55x", "15490", "12"}
	weaponPrices[49] = {"arccw_claymorelungemine", "5555", "5"}
	weaponPrices[50] = {"arccw_eft_usp", "5555", "3"}
	weaponPrices[51] = {"arccw_eft_mp153", "15005", "10"}
	weaponPrices[52] = {"arccw_eft_mp155", "14005", "10"}
	weaponPrices[53] = {"arccw_eft_scarh", "17090", "13"}
	weaponPrices[54] = {"arccw_eft_scarl", "15995", "12"}
	weaponPrices[55] = {"arccw_ur_mp5", "10005", "5"}
	weaponPrices[56] = {"arccw_ur_aw", "13095", "9"}
	weaponPrices[57] = {"midnights_gso_type89", "18005", "14"}
	weaponPrices[58] = {"arccw_waw_thompson", "11565", "7"}
	weaponPrices[59] = {"arccw_waw_mp40", "9895", "6"}
	weaponPrices[60] = {"arccw_waw_type100", "12995", "8"}
	weaponPrices[61] = {"arccw_bo1_mpl", "9205", "6"}
	weaponPrices[62] = {"arccw_bo1_pm63", "8995", "5"}
	weaponPrices[63] = {"arccw_bo1_g11", "15900", "11"}
	weaponPrices[64] = {"arccw_bo1_law", "33333", "20"}
	weaponPrices[65] = {"arccw_bo1_aug", "14250", "10"}
	weaponPrices[66] = {"arccw_bo1_xl60", "13905", "10"}
	weaponPrices[67] = {"arccw_bo1_famas", "14505", "10"}
	weaponPrices[68] = {"arccw_bo1_fal", "17050", "12"}
	weaponPrices[69] = {"arccw_bo1_hk21", "26000", "16"}
	weaponPrices[70] = {"arccw_bo1_galil", "14005", "11"}
	weaponPrices[71] = {"arccw_waw_mosin", "15000", "10"}
	weaponPrices[72] = {"arccw_waw_garand", "15500", "11"}
	weaponPrices[73] = {"arccw_waw_357", "6995", "3"}
	weaponPrices[74] = {"arccw_waw_ptrs41", "45999", "24"}
	weaponPrices[75] = {"arccw_waw_tt33", "4500", "1"}
	weaponPrices[76] = {"arccw_bo1_sten", "11000", "8"}
	weaponPrices[77] = {"arccw_waw_fg42", "40999", "22"}
	weaponPrices[78] = {"arccw_bo1_m60", "32999", "20"}
	weaponPrices[79] = {"arccw_waw_trenchgun", "14995", "11"}
	weaponPrices[80] = {"arccw_bo1_stoner", "15400", "12"}
	weaponPrices[81] = {"arccw_bo2_fiveseven", "4750", "2"}
	weaponPrices[82] = {"arccw_cde_m93r", "5000", "3"}
	weaponPrices[83] = {"arccw_waw_mg42", "52500", "26"}
	weaponPrices[84] = {"arccw_bo1_kiparis", "9550", "4"}
	weaponPrices[85] = {"arccw_bo2_vector", "24000", "18"}
	weaponPrices[86] = {"arccw_bo1_dragunov", "25000", "18"}
	weaponPrices[87] = {"arccw_bo1_rpk", "19500", "15"}
	weaponPrices[88] = {"arccw_bo2_smr", "26500", "18"}
	weaponPrices[89] = {"arccw_mw2e_f2000", "17900", "14"}
	weaponPrices[90] = {"arccw_mw3e_rsass", "22255", "17"}
	weaponPrices[91] = {"arccw_mw3e_p90", "14900", "11"}
	weaponPrices[92] = {"arccw_mw3e_mk14", "19995", "15"}
	weaponPrices[93] = {"arccw_mw3e_l86", "16555", "14"}
	weaponPrices[94] = {"arccw_mw3e_mp9", "11550", "6"}
	weaponPrices[95] = {"arccw_mw2e_pp2000", "9995", "5"}
	weaponPrices[96] = {"arccw_mw3e_pp90m1", "10900", "6"}
	weaponPrices[97] = {"arccw_mw3e_acr", "17000", "13"}
	weaponPrices[98] = {"arccw_bo1_crossbow", "20000", "12"}
	weaponPrices[99] = {"arccw_cod4e_r700", "14995", "13"}
	weaponPrices[100] = {"arccw_bo1_ak47", "14500", "12"}

	for k, v in pairs(weaponPrices) do
		if (args[1] == v[1]) then
			local balance = (ply:GetNWInt("playerMoney"))
			local playerLvl = ply:GetNWInt("playerLvl")
			local levelReq = tonumber(v[3])

			if (ply:GetNWInt("charismaEffect") == 0) then
				gunCost = tonumber(v[2])
			else
				gunCost = math.Round(tonumber(v[2]) * ply:GetNWInt("charismaEffect"), 0)
			end

			if (playerLvl >= levelReq) then
				if (balance >= gunCost) then
					local charExpGain = (ply:GetNWInt("charismaExperience") + gunCost)
					local charExp = charExpGain / 1750

					ply:SetNWInt("playerMoney", balance - gunCost)
					ply:SetNWInt("playerTotalMoneySpent", ply:GetNWInt("playerTotalMoneySpent") + gunCost)
					ply:SetNWInt("playerTotalMoneySpentWep", ply:GetNWInt("playerTotalMoneySpentWep") + gunCost)

					if (ply:GetNWInt("charismaLevel") < 40) then
						ply:SetNWInt("charismaExperience", ply:GetNWInt("charismaExperience") + charExp)
						checkForCharisma(ply)
					end

					ply:Give(args[1])
				else
					ply:PrintMessage(HUD_PRINTTALK, "You do not have enough roubles to purchase this item.")
				end
			else
				ply:PrintMessage(HUD_PRINTTALK, "You must be level " .. levelReq .. " to purchase this item.")
			end

			return
		end
	end
end
concommand.Add("buy_gun", buyGun)

function CheckExtracts(ply, cmd, args)

	local extractNames = "\nYour available extract locations are:"

	for k, v in pairs( ents.FindByClass("efgm_trigger_extract") ) do

		if v.ExtractGroup == "All" or v.ExtractGroup == CheckSpawnGroup(ply) then
			extractNames = extractNames .. "\n" .. v.ExtractName

			if v.Available == 1 then
				extractNames = extractNames .. " (Status: Unknown)"
			else
				extractNames = extractNames .. " (Status: Available)"
			end
		end
	end

	ply:PrintMessage(HUD_PRINTCENTER, extractNames)

end
concommand.Add("efgm_extract_list", CheckExtracts)

function PlayerPrestige(ply, cmd, args)
	if (ply:GetNWInt("playerLvl") >= 26) then

		local prestigeGained = 1
		local roubleMulti = 0.25
		local levelReset = 1
		local expReset = 0

		ply:SetNWInt("playerPrestige", ply:GetNWInt("playerPrestige") + prestigeGained)
		ply:SetNWInt("playerRoubleMulti", ply:GetNWInt("playerRoubleMulti") + roubleMulti)

		ply:SetNWInt("playerLvl", levelReset)
		ply:SetNWInt("playerExp", expReset)
	else
		ply:PrintMessage(3, "Sorry, " .. ply:GetName() .. ". " .. "I can't give credit. Come back when you're a little... mmmmm... higher leveled!")
	end
end
concommand.Add("efgm_prestige", PlayerPrestige)

function StashUpgrade(ply, cmd, args)

	local balance = (ply:GetNWInt("playerMoney"))
	local cost

	--This statement is checking for the cost
	if (ply:GetNWInt("playerStashLevel") == 1) then
		cost = 10000
	else
		if (ply:GetNWInt("playerStashLevel") == 2) then
			cost = 20000
		else
			if (ply:GetNWInt("playerStashLevel") == 3) then
				cost = 30000
			else
				if (ply:GetNWInt("playerStashLevel") == 4) then
					cost = 40000
				else
					if (ply:GetNWInt("playerStashLevel") == 5) then
						cost = 50000
					else
						if (ply:GetNWInt("playerStashLevel") == 6) then
							cost = 75000
						else
							if (ply:GetNWInt("playerStashLevel") == 7) then
								cost = 100000
							else
								if (ply:GetNWInt("playerStashLevel") == 8) then
									cost = 175000
								else
									if (ply:GetNWInt("playerStashLevel") == 9) then
										cost = 250000
									else
										if (ply:GetNWInt("playerStashLevel") == 10) then
											ply:SetNWInt("stashMaxed", 1)
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end

	if (balance >= cost) and (ply:GetNWInt("stashMaxed") == 0) then
		ply:SetNWInt("playerMoney", balance - cost)
		ply:SetNWInt("playerTotalMoneySpent", ply:GetNWInt("playerTotalMoneySpent") + cost)

		ply:SetNWInt("playerStashLevel", ply:GetNWInt("playerStashLevel") + 1)
		ply:SetNWInt("playerStashLimit", ply:GetNWInt("playerStashLimit") + 6)
	else
		ply:PrintMessage(HUD_PRINTTALK, "You do not have enough roubles to upgrade your stash!")
	end

	--And this statement is making this little fucking peice of shit update correctly i hate lua so goddamn much
	if (ply:GetNWInt("playerStashLevel") == 1) then
		ply:SetNWInt("playerRoubleForStashUpgrade", 10000)
	else
		if (ply:GetNWInt("playerStashLevel") == 2) then
			ply:SetNWInt("playerRoubleForStashUpgrade", 20000)
		else
			if (ply:GetNWInt("playerStashLevel") == 3) then
				ply:SetNWInt("playerRoubleForStashUpgrade", 30000)
			else
				if (ply:GetNWInt("playerStashLevel") == 4) then
					ply:SetNWInt("playerRoubleForStashUpgrade", 40000)
				else
					if (ply:GetNWInt("playerStashLevel") == 5) then
						ply:SetNWInt("playerRoubleForStashUpgrade", 50000)
					else
						if (ply:GetNWInt("playerStashLevel") == 6) then
							ply:SetNWInt("playerRoubleForStashUpgrade", 75000)
						else
							if (ply:GetNWInt("playerStashLevel") == 7) then
								ply:SetNWInt("playerRoubleForStashUpgrade", 100000)
							else
								if (ply:GetNWInt("playerStashLevel") == 8) then
									ply:SetNWInt("playerRoubleForStashUpgrade", 175000)
								else
									if (ply:GetNWInt("playerStashLevel") == 9) then
										ply:SetNWInt("playerRoubleForStashUpgrade", 250000)
									else
										if (ply:GetNWInt("playerStashLevel") == 10) then
											ply:SetNWInt("stashMaxed", 1)
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end

end
concommand.Add("efgm_stash_upgrade", StashUpgrade)