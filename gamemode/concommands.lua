function buyEntity(ply, cmd, args)
    if (args[1] != nil) then
        local ent = ents.Create(args[1])
        local tr = ply:GetEyeTrace()
		local balance = ply:GetNWInt("playerMoney")

        if (IsValid(ent)) then

            local ClassName = ent:GetClass()
            if (!tr.Hit) then return end

            local entCount = ply:GetNWInt(ClassName .. "count")

            if (!ent.limit or entCount < ent.Limit) then
				if (balance >= ent.Cost) then
					local SpawnPos = ply:GetShootPos() + ply:GetForward() * 80

					ent.Owner = ply

					ent:SetPos(SpawnPos)
					ent:Spawn()
					ent:Activate()

					ply:SetNWInt("playerMoney", balance - ent.Cost)
					ply:SetNWInt("playerTotalMoneySpent", ply:GetNWInt("playerTotalMoneySpent") + ent.Cost)
					ply:SetNWInt("playerTotalMoneySpentItem", ply:GetNWInt("playerTotalMoneySpentItem") + ent.Cost)
					ply:SetNWInt(ClassName .. "count", entCount + 1)

					return ent
				else
					ply:PrintMessage(HUD_PRINTTALK, "You do not have enough roubles to purchase this item.")
				end
			else
				ply:PrintMessage(HUD_PRINTTALK, "You already have the maximum amount of this specific entity. MAX = " .. ent.Limit)
			end

			return
		end
	end
end
concommand.Add("buy_entity", buyEntity)

function buyGun(ply, cmd, args)
	local weaponPrices = {}
	weaponPrices[1] = {"arccw_dmi_b92f_auto", "13005", "10"}
	weaponPrices[2] = {"arccw_dmi_c7a2_inftry", "16955", "14"}
	weaponPrices[3] = {"arccw_dp28", "21370", "17"}
	weaponPrices[4] = {"arccw_eft_aks74u", "9980", "7"}
	weaponPrices[5] = {"arccw_eft_1911", "4140", "3"}
	weaponPrices[6] = {"arccw_eft_mp5", "10995", "9"}
	weaponPrices[7] = {"arccw_eft_mp5sd", "9995", "8"}
	weaponPrices[8] = {"arccw_eft_mp7", "13195", "10"}
	weaponPrices[9] = {"arccw_eft_ppsh", "8440", "5"}
	weaponPrices[10] = {"arccw_eft_t5000", "18050", "13"}
	weaponPrices[11] = {"arccw_eft_ump", "10050", "6"}
	weaponPrices[12] = {"arccw_eap_aek", "17120", "15"}
	weaponPrices[13] = {"arccw_eap_brenten", "6010", "4"}
	weaponPrices[14] = {"arccw_eap_csls5", "10510", "8"}
	weaponPrices[15] = {"arccw_eap_fmg9", "13080", "9"}
	weaponPrices[16] = {"arccw_eap_groza", "13580", "10"}
	weaponPrices[17] = {"arccw_eap_lebedev", "4630", "3"}
	weaponPrices[18] = {"arccw_eap_spectre", "11010", "8"}
	weaponPrices[19] = {"arccw_eap_stg44", "13100", "10"}
	weaponPrices[20] = {"arccw_eap_usas", "27510", "20"}
	weaponPrices[21] = {"arccw_eap_vp70", "5005", "4"}
	weaponPrices[22] = {"arccw_eap_xm29", "18005", "15"}
	weaponPrices[23] = {"arccw_slog_altor", "5005", "5"}
	weaponPrices[24] = {"arccw_fml_blast_fc5_arc", "15005", "13"}
	weaponPrices[25] = {"arccw_krissvector", "20005", "15"}
	weaponPrices[26] = {"arccw_asval", "17990", "13"}
	weaponPrices[27] = {"arccw_mifl_mds9", "6200", "5"}
	weaponPrices[28] = {"arccw_blast_pindadss2", "18200", "14"}
	weaponPrices[29] = {"arccw_go_nade_incendiary", "2500", "3"}
	weaponPrices[30] = {"arccw_go_nade_frag", "2500", "3"}
	weaponPrices[31] = {"arccw_go_nade_flash", "2500", "3"}
	weaponPrices[32] = {"arccw_go_nade_smoke", "2500", "3"}
	weaponPrices[33] = {"arccw_go_nade_molotov", "2500", "3"}
	weaponPrices[34] = {"arccw_go_nade_knife", "2500", "3"}
	weaponPrices[35] = {"weapon_csgo_flashbang", "2500", "3"}
	weaponPrices[36] = {"arccw_ur_deagle", "6005", "5"}
	weaponPrices[37] = {"midnights_gso_xm8", "18920", "17"}
	weaponPrices[38] = {"arccw_midnightwolf_type20", "17880", "15"}
	weaponPrices[39] = {"arccw_725", "8950", "7"}
	weaponPrices[40] = {"arccw_mifl_fas2_g36c", "14445", "13"}
	weaponPrices[41] = {"arccw_kilo141", "15690", "14"}
	weaponPrices[42] = {"arccw_fml_mk2k", "11050", "8"}
	weaponPrices[43] = {"arccw_grau", "13005", "13"}
	weaponPrices[44] = {"arccw_ud_glock", "6005", "5"}
	weaponPrices[45] = {"arccw_ud_m16", "16995", "14"}
	weaponPrices[46] = {"arccw_ud_m1014", "12995", "12"}
	weaponPrices[47] = {"arccw_ud_m79", "22555", "20"}
	weaponPrices[48] = {"arccw_ud_mini14", "16420", "14"}
	weaponPrices[49] = {"arccw_ud_870", "10240", "9"}
	weaponPrices[50] = {"arccw_ud_uzi", "11040", "8"}
	weaponPrices[51] = {"arccw_ww1_smg0818", "27500", "22"}
	weaponPrices[52] = {"arccw_ur_ak", "17005", "15"}
	weaponPrices[53] = {"arccw_mifl_fas2_famas", "16990", "14"}
	weaponPrices[54] = {"arccw_mifl_fas2_g3", "16310", "14"}
	weaponPrices[55] = {"arccw_mifl_fas2_ks23", "13005", "13"}
	weaponPrices[56] = {"arccw_mifl_fas2_m24", "18900", "15"}
	weaponPrices[57] = {"arccw_mifl_fas2_m3", "14505", "14"}
	weaponPrices[58] = {"arccw_mifl_fas2_m82", "20999", "20"}
	weaponPrices[59] = {"arccw_mifl_fas2_mac11", "8100", "6"}
	weaponPrices[60] = {"arccw_fml_fas2_custom_mass26", "14895", "15"}
	weaponPrices[61] = {"arccw_mifl_fas2_minimi", "19995", "20"}
	weaponPrices[62] = {"arccw_mifl_fas2_ragingbull", "7020", "7"}
	weaponPrices[63] = {"arccw_mifl_fas2_rpk", "14765", "14"}
	weaponPrices[64] = {"arccw_mifl_fas2_sg55x", "15490", "14"}
	weaponPrices[65] = {"arccw_mifl_fas2_sr25", "17420", "16"}
	weaponPrices[66] = {"arccw_mifl_fas2_toz34", "12690", "12"}
	weaponPrices[67] = {"arccw_claymorelungemine", "5555", "5"}
	weaponPrices[68] = {"arccw_eft_usp", "5555", "5"}
	weaponPrices[69] = {"arccw_eft_mp153", "15005", "13"}
	weaponPrices[70] = {"arccw_eft_mp155", "14005", "12"}
	weaponPrices[71] = {"arccw_eft_scarh", "17090", "15"}
	weaponPrices[72] = {"arccw_eft_scarl", "15995", "14"}
	weaponPrices[73] = {"arccw_fml_mw_fo12", "20999", "18"}
	weaponPrices[74] = {"arccw_oden", "18505", "16"}
	weaponPrices[75] = {"arccw_ur_mp5", "10005", "8"}
	weaponPrices[76] = {"arccw_ur_aw", "13095", "12"}
	weaponPrices[77] = {"arccw_sov_tkb011", "16000", "14"}
	weaponPrices[78] = {"midnights_gso_type89", "18005", "15"}
	weaponPrices[79] = {"arccwsviinfinite", "5555", "5"}
	weaponPrices[80] = {"arccw_waw_thompson", "11565", "9"}
	weaponPrices[81] = {"arccw_waw_mp40", "9895", "8"}
	weaponPrices[82] = {"arccw_waw_type100", "12995", "12"}
	weaponPrices[83] = {"arccw_bo1_mpl", "9205", "7"}
	weaponPrices[84] = {"arccw_bo1_pm63", "8995", "7"}
	weaponPrices[85] = {"arccw_bo1_g11", "15900", "13"}
	weaponPrices[86] = {"arccw_bo1_law", "33333", "24"}
	weaponPrices[87] = {"arccw_mifl_fas2_g20", "4700", "4"}
	weaponPrices[88] = {"arccw_mifl_fas2_p226", "4700", "4"}
	weaponPrices[89] = {"arccw_waw_nambu", "4250", "4"}
	weaponPrices[90] = {"arccw_bo1_aug", "14250", "12"}
	weaponPrices[91] = {"arccw_bo1_xl60", "13905", "11"}
	weaponPrices[92] = {"arccw_bo1_famas", "14505", "13"}
	weaponPrices[93] = {"arccw_bo1_fal", "17050", "15"}
	weaponPrices[94] = {"arccw_bo1_hk21", "26000", "20"}
	weaponPrices[95] = {"arccw_bo1_galil", "14005", "13"}
	weaponPrices[96] = {"arccw_bo1_spas12", "16000", "14"}
	weaponPrices[97] = {"arccw_cde_ak5", "14940", "13"}
	weaponPrices[98] = {"arccw_waw_mosin", "15000", "13"}
	weaponPrices[99] = {"arccw_waw_garand", "15500", "14"}
	weaponPrices[100] = {"arccw_waw_357", "6995", "5"}
	weaponPrices[101] = {"arccw_waw_ptrs41", "45999", "30"}
	weaponPrices[102] = {"arccw_waw_tt33", "4500", "4"}
	weaponPrices[103] = {"arccw_bo1_sten", "11000", "9"}
	weaponPrices[104] = {"arccw_waw_fg42", "40999", "27"}
	weaponPrices[105] = {"arccw_bo1_m60", "32999", "24"}
	weaponPrices[106] = {"arccw_waw_trenchgun", "14995", "13"}
	weaponPrices[107] = {"arccw_bo1_stoner", "15400", "14"}
	weaponPrices[108] = {"arccw_bo2_fiveseven", "4750", "4"}
	weaponPrices[109] = {"arccw_cde_m93r", "5000", "4"}
	weaponPrices[110] = {"arccw_waw_mg42", "52500", "32"}
	weaponPrices[111] = {"arccw_bo1_kiparis", "9550", "8"}
	weaponPrices[112] = {"arccw_bo1_skorpion", "9250", "7"}
	weaponPrices[113] = {"arccw_bo2_vector", "24000", "17"}
	weaponPrices[114] = {"arccw_bo1_dragunov", "25000", "17"}
	weaponPrices[115] = {"arccw_bo1_rpk", "19500", "15"}
	weaponPrices[116] = {"arccw_bo2_lsat", "15005", "14"}
	weaponPrices[117] = {"arccw_bo2_smr", "26500", "18"}
	weaponPrices[118] = {"arccw_mw2e_f2000", "17900", "16"}
	weaponPrices[119] = {"arccw_mw3e_rsass", "22255", "17"}
	weaponPrices[120] = {"arccw_mw3e_p90", "14900", "13"}

	for k, v in pairs(weaponPrices) do
		if (args[1] == v[1]) then
			local balance = (ply:GetNWInt("playerMoney"))
			local playerLvl = ply:GetNWInt("playerLvl")
			local gunCost = tonumber(v[2])
			local levelReq = tonumber(v[3])

			if (playerLvl >= levelReq) then
				if (balance >= gunCost) then
					ply:SetNWInt("playerMoney", balance - gunCost)
					ply:SetNWInt("playerTotalMoneySpent", ply:GetNWInt("playerTotalMoneySpent") + gunCost)
					ply:SetNWInt("playerTotalMoneySpentWep", ply:GetNWInt("playerTotalMoneySpentWep") + gunCost)
					ply:Give(args[1])
					ply:GiveAmmo(30, ply:GetWeapon(args[1]):GetPrimaryAmmoType(), false)
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

function ResetIndividualProgress(ply, cmd, args)

	ply:SetNWInt("playerLvl", 1)

	ply:SetNWInt("playerExp", 0)

	ply:SetNWInt("playerMoney", 10000)

end
concommand.Add("efgm_reset_progress", ResetIndividualProgress)

function ResetIndividualStats(ply, cmd, args)

	ply:SetNWInt("playerLvl", 1)

	ply:SetNWInt("playerExp", 0)

	ply:SetNWInt("playerMoney", 10000)

	ply:SetNWInt("playerKills", 0)

	ply:SetNWInt("playerDeaths", 0)

	ply:SetNWInt("playerKDR", 1)

	ply:SetNWInt("playerTotalEarned", 0)

	ply:SetNWInt("playerTotalEarnedKill", 0)

	ply:SetNWInt("playerTotalEarnedSell", 0)

	ply:SetNWInt("playerTotalXpEarned", 0)

	ply:SetNWInt("playerTotalXpEarnedKill", 0)

	ply:SetNWInt("playerTotalXpEarnedExplore", 0)

	ply:SetNWInt("playerTotalMoneySpent", 0)

	ply:SetNWInt("playerTotalMoneySpentWep", 0)

	ply:SetNWInt("playerTotalMoneySpentItem", 0)

	ply:SetNWInt("playerDeathsSuicide", 0)

	ply:SetNWInt("playerDamageGiven", 0)

	ply:SetNWInt("playerDamageRecieved", 0)

	ply:SetNWInt("playerDamageHealed", 0)

	ply:SetNWInt("playerItemsPickedUp", 0)

	ply:SetNWInt("playerDistance", 0)

end
concommand.Add("efgm_reset_stats", ResetIndividualStats)

function ResetIndividualAll(ply, cmd, args)

	ply:SetNWInt("playerKills", 0)

	ply:SetNWInt("playerDeaths", 0)

	ply:SetNWInt("playerKDR", 1)

	ply:SetNWInt("playerTotalEarned", 0)

	ply:SetNWInt("playerTotalEarnedKill", 0)

	ply:SetNWInt("playerTotalEarnedSell", 0)

	ply:SetNWInt("playerTotalXpEarned", 0)

	ply:SetNWInt("playerTotalXpEarnedKill", 0)

	ply:SetNWInt("playerTotalXpEarnedExplore", 0)

	ply:SetNWInt("playerTotalMoneySpent", 0)

	ply:SetNWInt("playerTotalMoneySpentWep", 0)

	ply:SetNWInt("playerTotalMoneySpentItem", 0)

	ply:SetNWInt("playerDeathsSuicide", 0)

	ply:SetNWInt("playerDamageGiven", 0)

	ply:SetNWInt("playerDamageRecieved", 0)

	ply:SetNWInt("playerDamageHealed", 0)

	ply:SetNWInt("playerItemsPickedUp", 0)

	ply:SetNWInt("playerDistance", 0)

end
concommand.Add("efgm_reset_everything", ResetIndividualAll)

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
	if (ply:GetNWInt("playerLvl") >= 32) then

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