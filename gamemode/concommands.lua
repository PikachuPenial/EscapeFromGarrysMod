function buyEntity(ply, cmd, args)
    if(args[1] != nil) then
        local ent = ents.Create(args[1])
        local tr = ply:GetEyeTrace()
		local balance = ply:GetNWInt("playerMoney")

        if (IsValid(ent)) then

            local ClassName = ent:GetClass()
            if(!tr.Hit) then return end

            local entCount = ply:GetNWInt(ClassName.."count")

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
					ply:SetNWInt(ClassName.."count", entCount + 1)

					return ent
				else
					ply:PrintMessage(HUD_PRINTTALK, "You do not have enough roubles to purchase this item.")
				end
			else
				ply:PrintMessage(HUD_PRINTTALK, "You already have the maximum amount of this specific entity. MAX = "..ent.Limit)
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
	weaponPrices[3] = {"arccw_hk416", "18370", "16"}
	weaponPrices[4] = {"arccw_dp28", "21370", "17"}
	weaponPrices[5] = {"arccw_sigmpx_combat", "12410", "11"}
	weaponPrices[6] = {"arccw_eft_aks74u", "9980", "7"}
	weaponPrices[7] = {"arccw_eft_1911", "4140", "3"}
	weaponPrices[8] = {"arccw_eft_mp5", "10995", "9"}
	weaponPrices[9] = {"arccw_eft_mp5sd", "9995", "8"}
	weaponPrices[10] = {"arccw_eft_mp7", "13195", "10"}
	weaponPrices[11] = {"arccw_eft_ppsh", "8440", "5"}
	weaponPrices[12] = {"arccw_eft_t5000", "18050", "13"}
	weaponPrices[13] = {"arccw_eft_ump", "10050", "6"}
	weaponPrices[14] = {"arccw_eap_aek", "17120", "15"}
	weaponPrices[15] = {"arccw_eap_brenten", "6010", "4"}
	weaponPrices[16] = {"arccw_eap_csls5", "10510", "8"}
	weaponPrices[17] = {"arccw_eap_fmg9", "13080", "9"}
	weaponPrices[18] = {"arccw_eap_groza", "13580", "10"}
	weaponPrices[19] = {"arccw_eap_lebedev", "4630", "3"}
	weaponPrices[20] = {"arccw_eap_spectre", "11010", "8"}
	weaponPrices[21] = {"arccw_eap_stg44", "13100", "10"}
	weaponPrices[22] = {"arccw_eap_usas", "27510", "20"}
	weaponPrices[23] = {"arccw_eap_vp70", "5005", "4"}
	weaponPrices[24] = {"arccw_eap_xm29", "18005", "15"}
	weaponPrices[25] = {"arccw_slog_altor", "5005", "5"}
	weaponPrices[26] = {"arccw_fml_blast_fc5_arc", "15005", "13"}
	weaponPrices[27] = {"arccw_krissvector", "20005", "15"}
	weaponPrices[28] = {"arccw_asval", "17990", "13"}
	weaponPrices[29] = {"arccw_mifl_lynx", "18420", "14"}
	weaponPrices[30] = {"arccw_fml_eft_mdr", "19005", "14"}
	weaponPrices[31] = {"arccw_mifl_mds9", "6200", "5"}
	weaponPrices[32] = {"arccw_blast_pindadss2", "18200", "14"}
	weaponPrices[33] = {"arccw_fml_scarsd", "23105", "17"}
	weaponPrices[34] = {"arccw_go_taser", "3333", "3"}
	weaponPrices[35] = {"arccw_go_nade_incendiary", "2500", "3"}
	weaponPrices[36] = {"arccw_go_nade_frag", "2500", "3"}
	weaponPrices[37] = {"arccw_go_nade_flash", "2500", "3"}
	weaponPrices[38] = {"arccw_go_nade_smoke", "2500", "3"}
	weaponPrices[39] = {"arccw_go_nade_molotov", "2500", "3"}
	weaponPrices[40] = {"arccw_go_nade_knife", "2500", "3"}
	weaponPrices[41] = {"weapon_csgo_flashbang", "2500", "3"}
	weaponPrices[42] = {"arccw_go_m1014", "11510", "10"}
	weaponPrices[43] = {"arccw_go_m249para", "14000", "12"}
	weaponPrices[44] = {"arccw_go_mag7", "13333", "13"}
	weaponPrices[45] = {"arccw_go_870", "8905", "8"}
	weaponPrices[46] = {"arccw_go_negev", "12000", "10"}
	weaponPrices[47] = {"arccw_go_nova", "11250", "10"}
	weaponPrices[48] = {"arccw_go_cz75", "4790", "4"}
	weaponPrices[49] = {"arccw_go_deagle", "6005", "5"}
	weaponPrices[50] = {"arccw_go_fiveseven", "4250", "3"}
	weaponPrices[51] = {"arccw_go_glock", "4700", "4"}
	weaponPrices[52] = {"arccw_go_m9", "4250", "3"}
	weaponPrices[53] = {"arccw_go_r8", "6005", "5"}
	weaponPrices[54] = {"arccw_go_p2000", "4250", "3"}
	weaponPrices[55] = {"arccw_go_p250", "4700", "4"}
	weaponPrices[56] = {"arccw_go_sw29", "5250", "4"}
	weaponPrices[57] = {"arccw_go_tec9", "5250", "4"}
	weaponPrices[58] = {"arccw_go_usp", "4700", "4"}
	weaponPrices[59] = {"arccw_go_ace", "15920", "11"}
	weaponPrices[60] = {"arccw_go_ak47", "13905", "10"}
	weaponPrices[61] = {"arccw_go_ar15", "11995", "8"}
	weaponPrices[62] = {"arccw_go_aug", "14250", "12"}
	weaponPrices[63] = {"arccw_go_awp", "17995", "16"}
	weaponPrices[64] = {"arccw_go_fnfal", "17250", "14"}
	weaponPrices[65] = {"arccw_go_famas", "13995", "11"}
	weaponPrices[66] = {"arccw_go_g3", "18500", "16"}
	weaponPrices[67] = {"arccw_go_galil_ar", "16000", "13"}
	weaponPrices[68] = {"arccw_go_m16a2", "16550", "14"}
	weaponPrices[69] = {"arccw_go_m4", "17110", "14"}
	weaponPrices[70] = {"arccw_go_scar", "17600", "15"}
	weaponPrices[71] = {"arccw_go_sg556", "16640", "13"}
	weaponPrices[72] = {"arccw_go_ssg08", "15625", "13"}
	weaponPrices[73] = {"arccw_go_mac10", "7600", "6"}
	weaponPrices[74] = {"arccw_go_mp5", "8240", "7"}
	weaponPrices[75] = {"arccw_go_mp7", "8590", "7"}
	weaponPrices[76] = {"arccw_go_mp9", "8590", "8"}
	weaponPrices[77] = {"arccw_go_p90", "14990", "10"}
	weaponPrices[78] = {"arccw_go_bizon", "8750", "8"}
	weaponPrices[79] = {"arccw_go_ump", "9360", "9"}
	weaponPrices[80] = {"arccw_midnightwolf_acr", "16420", "14"}
	weaponPrices[81] = {"midnights_gso_xm8", "18920", "17"}
	weaponPrices[82] = {"arccw_midnightwolf_type20", "17880", "15"}
	weaponPrices[83] = {"arccw_725", "8950", "7"}
	weaponPrices[84] = {"arccw_mifl_fas2_g36c", "14445", "13"}
	weaponPrices[85] = {"arccw_kilo141", "15690", "14"}
	weaponPrices[86] = {"arccw_mcx", "17180", "15"}
	weaponPrices[87] = {"arccw_fml_mk2k", "11050", "8"}
	weaponPrices[88] = {"arccw_grau", "13005", "13"}
	weaponPrices[89] = {"arccw_ud_glock", "6005", "5"}
	weaponPrices[90] = {"arccw_ud_m16", "16995", "14"}
	weaponPrices[91] = {"arccw_ud_m1014", "12995", "12"}
	weaponPrices[92] = {"arccw_ud_m79", "22555", "20"}
	weaponPrices[93] = {"arccw_ud_mini14", "16420", "14"}
	weaponPrices[94] = {"arccw_ud_870", "10240", "9"}
	weaponPrices[95] = {"arccw_ud_uzi", "11040", "8"}
	weaponPrices[96] = {"arccw_ww1_smg0818", "27500", "22"}
	weaponPrices[97] = {"arccw_mifl_fas2_ak47", "17005", "15"}
	weaponPrices[98] = {"arccw_mifl_fas2_famas", "16990", "14"}
	weaponPrices[99] = {"arccw_mifl_fas2_g3", "16310", "14"}
	weaponPrices[100] = {"arccw_mifl_fas2_ks23", "13005", "13"}
	weaponPrices[101] = {"arccw_mifl_fas2_m24", "18900", "15"}
	weaponPrices[102] = {"arccw_mifl_fas2_m3", "14505", "14"}
	weaponPrices[103] = {"arccw_mifl_fas2_m82", "20999", "20"}
	weaponPrices[104] = {"arccw_mifl_fas2_mac11", "8100", "6"}
	weaponPrices[105] = {"arccw_fml_fas2_custom_mass26", "14895", "15"}
	weaponPrices[106] = {"arccw_mifl_fas2_minimi", "19995", "20"}
	weaponPrices[107] = {"arccw_mifl_fas2_ragingbull", "7020", "7"}
	weaponPrices[108] = {"arccw_mifl_fas2_rpk", "14765", "14"}
	weaponPrices[109] = {"arccw_mifl_fas2_sg55x", "15490", "14"}
	weaponPrices[110] = {"arccw_mifl_fas2_sr25", "17420", "16"}
	weaponPrices[111] = {"arccw_mifl_fas2_toz34", "12690", "12"}
	weaponPrices[112] = {"arccw_claymorelungemine", "5555", "5"}
	weaponPrices[113] = {"arccw_eft_usp", "5555", "5"}
	weaponPrices[114] = {"arccw_eft_mp153", "15005", "13"}
	weaponPrices[115] = {"arccw_eft_mp155", "14005", "12"}
	weaponPrices[116] = {"arccw_eft_scarh", "17090", "15"}
	weaponPrices[117] = {"arccw_eft_scarl", "15995", "14"}
	weaponPrices[118] = {"arccw_fml_mw_fo12", "20999", "18"}
	weaponPrices[119] = {"arccw_oden", "18505", "16"}
	
	for k, v in pairs(weaponPrices) do
		if(args[1] == v[1]) then
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
				ply:PrintMessage(HUD_PRINTTALK, "You must be level "..levelReq.." to purchase this item.")
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
			extractNames = extractNames.."\n"..v.ExtractName

			if v.Available == 1 then
				extractNames = extractNames.." (Status: Unknown)"
			else
				extractNames = extractNames.." (Status: Available)"
			end
		end
	end

	ply:PrintMessage(HUD_PRINTCENTER, extractNames)

end
concommand.Add("efgm_extract_list", CheckExtracts)