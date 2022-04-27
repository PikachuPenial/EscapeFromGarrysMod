GM.Name = "Escape From Garry's Mod"
GM.Author = "Pikachu/Penial"
GM.Email = "jacksonwassermann55@icloud.com"
GM.Website = "https://github.com/PikachuPenial"

DeriveGamemode("sandbox")

sellPriceMultiplier = 0.30

inPlayerMenu = false
inStashMenu = false
inMapVoteMenu = false
inRaidSummaryMenu = false

weaponsArr = {}
entsArr = {}
sellBlacklist = {}

function GM:Initialize()

	isSellMenu = false
	clientPlayer = nil

	-- Creating a temporary array to sort through for the actual array seen in the shop

	-- Array Formatting (Model, Item Name, Shop Print Name, Cost, Level, Rarity/Tier, Category)

	local tempWeaponsArray = {}

	tempWeaponsArray[1] = {"models/weapons/arccw/dm1973/c_dmi_bm92f_auto.mdl", "arccw_dmi_b92f_auto", "92F Auto Pistol", 13005, "10", "MID", "Pistol"}
	tempWeaponsArray[2] = {"models/weapons/arccw/dm1973/w_arccw_dmi_c7a2.mdl", "arccw_dmi_c7a2_inftry", "C7A2", 16955, "14", "HIGH", "Rifle"}
	tempWeaponsArray[3] = {"models/weapons/arccw/w_zz_mg24_tp.mdl", "arccw_dp28", "DP-28 HLMG", 21370, "17", "HIGH", "Heavy"}
	tempWeaponsArray[4] = {"models/weapons/arc_eft_aks74u/eft_aks74u/models/c_eft_aks74u.mdl", "arccw_eft_aks74u", "AKS-74u", 9980, "7", "LOW", "SMG"}
	tempWeaponsArray[5] = {"models/weapons/arc_eft_1911/c_eft_1911/models/c_eft_1911.mdl", "arccw_eft_1911", "M1911", 4140, "3", "LOW", "Pistol"}
	tempWeaponsArray[6] = {"models/weapons/arc_eft_mp5/w_eft_mp5/models/w_eft_mp5.mdl", "arccw_eft_mp5", "MP5", 10995, "9", "LOW", "SMG"}
	tempWeaponsArray[7] = {"models/weapons/arc_eft_mp5/w_eft_mp5_std/models/w_eft_mp5_std.mdl", "arccw_eft_mp5sd", "MP5SD", 9995, "8", "LOW", "SMG"}
	tempWeaponsArray[8] = {"models/weapons/arc_eft_mp7/eft_mp7/models/c_eft_mp7.mdl", "arccw_eft_mp7", "MP7A1", 13195, "10", "MID", "SMG"}
	tempWeaponsArray[9] = {"models/weapons/arc_eft_ppsh/c_eft_ppsh/models/c_eft_ppsh.mdl", "arccw_eft_ppsh", "PPSH-41", 8440, "5", "LOW", "SMG"}
	tempWeaponsArray[10] = {"models/weapons/arc_eft_t5000/eft_t5000/models/c_eft_t5000.mdl", "arccw_eft_t5000", "T-5000", 18050, "13", "HIGH", "Sniper"}
	tempWeaponsArray[11] = {"models/weapons/arc_eft_ump/eft_ump/models/c_eft_ump.mdl", "arccw_eft_ump", "UMP-45", 10050, "6", "LOW", "SMG"}
	tempWeaponsArray[12] = {"models/weapons/arccw/eap/c_aek971.mdl", "arccw_eap_aek", "AEK-971", 17120, "15", "HIGH", "Rifle"}
	tempWeaponsArray[13] = {"models/weapons/arccw/eap/c_brenten.mdl", "arccw_eap_brenten", "Bren Ten Pistol", 6010, "5", "LOW", "Pistol"}
	tempWeaponsArray[14] = {"models/weapons/arccw/eap/c_csls5.mdl", "arccw_eap_csls5", "CS/LS5 SMG", 10510, "8", "MID", "SMG"}
	tempWeaponsArray[15] = {"models/weapons/arccw/eap/c_fmg9.mdl", "arccw_eap_fmg9", "FMG-9", 13080, "9", "MID", "SMG"}
	tempWeaponsArray[16] = {"models/weapons/arccw/eap/c_groza.mdl", "arccw_eap_groza", "OTs-14 Groza", 13580, "10", "MID", "Rifle"}
	tempWeaponsArray[17] = {"models/weapons/arccw/eap/c_lebedev.mdl", "arccw_eap_lebedev", "PL-15 Lebedev Pistol", 4630, "3", "LOW", "Pistol"}
	tempWeaponsArray[18] = {"models/weapons/arccw/eap/c_spectre.mdl", "arccw_eap_spectre", "Spectre M4", 11010, "8", "MID", "SMG"}
	tempWeaponsArray[19] = {"models/weapons/arccw/eap/c_stg44.mdl", "arccw_eap_stg44", "StG-44", 13100, "10", "MID", "Rifle"}
	tempWeaponsArray[20] = {"models/weapons/arccw/eap/c_usas.mdl", "arccw_eap_usas", "USAS-12", 27510, "20", "HIGH", "Shotgun"}
	tempWeaponsArray[21] = {"models/weapons/arccw/eap/c_vp70.mdl", "arccw_eap_vp70", "VP70", 5005, "4", "LOW", "Pistol"}
	tempWeaponsArray[22] = {"models/weapons/arccw/eap/c_xm29.mdl", "arccw_eap_xm29", "XM29", 18005, "15", "HIGH", "Rifle"}
	tempWeaponsArray[23] = {"models/weapons/arccw/slogkot/c_altor.mdl", "arccw_slog_altor", "Altor Pistol", 5005, "5", "LOW", "Pistol"}
	tempWeaponsArray[24] = {"models/weapons/arccw/fml/w_fatcry5_arc.mdl", "arccw_fml_blast_fc5_arc", "AR-C", 15005, "13", "HIGH", "Rifle"}
	tempWeaponsArray[25] = {"models/weapons/arccw/kriss/w_kriss.mdl", "arccw_krissvector", "Kriss Vector", 20005, "15", "HIGH", "SMG"}
	tempWeaponsArray[26] = {"models/weapons/c_tderp_asval2.mdl", "arccw_asval", "AS VAL", 17990, "13", "HIGH", "Rifle"}
	tempWeaponsArray[27] = {"models/weapons/arccw/mifl/sketchfab/c_msd9.mdl", "arccw_mifl_mds9", "MDS-9", 6200, "5", "LOW", "Pistol"}
	tempWeaponsArray[28] = {"models/weapons/w_rif_pindadss2.mdl", "arccw_blast_pindadss2", "Pindad SS2-V1", 18200, "14", "HIGH", "Rifle"}
	tempWeaponsArray[29] = {"models/weapons/arccw_go/v_eq_incendiarygrenade.mdl", "arccw_go_nade_incendiary", "AN/M14 Thermite Grenade", 2500, "3", "UTIL", "Grenade"}
	tempWeaponsArray[30] = {"models/weapons/arccw_go/v_eq_fraggrenade.mdl", "arccw_go_nade_frag", "M67 Frag Grenade", 2500, "3", "UTIL", "Grenade"}
	tempWeaponsArray[31] = {"models/weapons/arccw_go/v_eq_flashbang.mdl", "arccw_go_nade_flash", "M84 Stun Grenade", 2500, "3", "UTIL", "Grenade"}
	tempWeaponsArray[32] = {"models/weapons/arccw_go/v_eq_smokegrenade.mdl", "arccw_go_nade_smoke", "M5210 Smoke Grenade", 2500, "3", "UTIL", "Grenade"}
	tempWeaponsArray[33] = {"models/weapons/arccw_go/v_eq_molotov.mdl", "arccw_go_nade_molotov", "Molotov Cocktail", 2500, "3", "UTIL", "Grenade"}
	tempWeaponsArray[34] = {"models/weapons/arccw_go/v_eq_throwingknife.mdl", "arccw_go_nade_knife", "Throwing Knife", 2500, "3", "UTIL", "Grenade"}
	tempWeaponsArray[35] = {"models/weapons/c_csgo_flashbang.mdl", "weapon_csgo_flashbang", "M84 MK2 Flash Grenade", 2500, "3", "UTIL", "Grenade"}
	tempWeaponsArray[36] = {"models/weapons/arccw_go/v_pist_deagle.mdl", "arccw_ur_deagle", "Desert Eagle", 6005, "5", "LOW", "Pistol"}
	tempWeaponsArray[37] = {"models/weapons/arccw/c_xm8.mdl", "midnights_gso_xm8", "HK XM8", 18920, "17", "HIGH", "Rifle"}
	tempWeaponsArray[38] = {"models/weapons/arccw/midnightwolf/type20.mdl", "arccw_midnightwolf_type20", "Type 20", 17880, "15", "HIGH", "Rifle"}
	tempWeaponsArray[39] = {"models/viper/mw/weapons/w_725_mammaledition.mdl", "arccw_725", "Citori 725 SG", 8950, "7", "LOW", "Shotgun"}
	tempWeaponsArray[40] = {"models/weapons/cod_mw2019/w_g36k_mammaledition.mdl", "arccw_g36mw19", "G36K", 14445, "13", "MID", "Rifle"}
	tempWeaponsArray[41] = {"models/viper/mw/weapons/kilo433_mammaledition.mdl", "arccw_kilo141", "HK433", 15690, "14", "MID", "Rifle"}
	tempWeaponsArray[42] = {"models/weapons/arccw/fml/mw19/w_mk2_k.mdl", "arccw_fml_mk2k", "MK2-K DMR", 11050, "8", "MID", "Rifle"}
	tempWeaponsArray[43] = {"models/weapons/cod_mw2019/c_sg552_mammaledition.mdl", "arccw_grau", "SG 552 Commando", 13005, "13", "MID", "Rifle"}
	tempWeaponsArray[44] = {"models/weapons/arccw/c_ud_glock.mdl", "arccw_ud_glock", "Glock 22", 6005, "5", "LOW", "Pistol"}
	tempWeaponsArray[45] = {"models/weapons/arccw/c_ud_m16.mdl", "arccw_ud_m16", "M16A3", 16995, "14", "MID", "Rifle"}
	tempWeaponsArray[46] = {"models/weapons/arccw/c_ud_m1014.mdl", "arccw_ud_m1014", "M4 Super 90 SG", 12995, "12", "MID", "Shotgun"}
	tempWeaponsArray[47] = {"models/weapons/arccw/c_ud_m79.mdl", "arccw_ud_m79", "M79 Grenade Launcher", 22555, "20", "HIGH", "Heavy"}
	tempWeaponsArray[48] = {"models/weapons/arccw/c_ud_mini14.mdl", "arccw_ud_mini14", "Mini-14", 16420, "14", "MID", "Rifle"}
	tempWeaponsArray[49] = {"models/weapons/arccw/c_ud_870.mdl", "arccw_ud_870", "Remington 870", 10240, "9", "MID", "Shotgun"}
	tempWeaponsArray[50] = {"models/weapons/arccw/c_ud_uzi.mdl", "arccw_ud_uzi", "Uzi", 11040, "8", "LOW", "SMG"}
	tempWeaponsArray[51] = {"models/weapons/arccw/w_arccw_smg0818.mdl", "arccw_ww1_smg0818", "Maxim SMG LMG", 27500, "22", "HIGH", "Heavy"}
	tempWeaponsArray[52] = {"models/weapons/arccw/mifl/fas2/c_ak47.mdl", "arccw_mifl_fas2_ak47", "AKM", 17005, "15", "HIGH", "Rifle"}
	tempWeaponsArray[53] = {"models/weapons/arccw/mifl/fas2/c_famas.mdl", "arccw_mifl_fas2_famas", "FAMAS", 16990, "14", "MID", "Rifle"}
	tempWeaponsArray[54] = {"models/weapons/arccw/mifl/fas2/c_g3.mdl", "arccw_mifl_fas2_g3", "G3A3", 16310, "14", "MID", "Rifle"}
	tempWeaponsArray[55] = {"models/weapons/arccw/mifl/fas2/c_ks23.mdl", "arccw_mifl_fas2_ks23", "KS-23", 13005, "13", "MID", "Shotgun"}
	tempWeaponsArray[56] = {"models/weapons/arccw/mifl/fas2/c_m24.mdl", "arccw_mifl_fas2_m24", "M24 SR", 18900, "15", "HIGH", "Sniper"}
	tempWeaponsArray[57] = {"models/weapons/arccw/mifl/fas2/c_m3s90.mdl", "arccw_mifl_fas2_m3", "M3 Super 90", 14505, "14", "MID", "Shotgun"}
	tempWeaponsArray[58] = {"models/weapons/arccw/mifl/fas2/c_m82.mdl", "arccw_mifl_fas2_m82", "M82 SR", 20999, "20", "HIGH", "Sniper"}
	tempWeaponsArray[59] = {"models/weapons/arccw/mifl/fas2/c_mac11.mdl", "arccw_mifl_fas2_mac11", "MAC-11", 8100, "6", "LOW", "SMG"}
	tempWeaponsArray[60] = {"models/weapons/arccw/mifl/fas2_custom/c_m26.mdl", "arccw_fml_fas2_custom_mass26", "MASS-26 SG", 14895, "15", "HIGH", "Shotgun"}
	tempWeaponsArray[61] = {"models/weapons/arccw/mifl/fas2/c_minimi.mdl", "arccw_mifl_fas2_minimi", "Minimi", 19995, "20", "HIGH", "Heavy"}
	tempWeaponsArray[62] = {"models/weapons/arccw/mifl/fas2/c_ragingbull.mdl", "arccw_mifl_fas2_ragingbull", "Raging Bull Revolver", 7020, "7", "LOW", "Pistol"}
	tempWeaponsArray[63] = {"models/weapons/arccw/mifl/fas2/c_rpk.mdl", "arccw_mifl_fas2_rpk", "RPK47", 14765, "14", "MID", "Heavy"}
	tempWeaponsArray[64] = {"models/weapons/arccw/mifl/fas2/c_sg552.mdl", "arccw_mifl_fas2_sg55x", "SG552", 15490, "14", "MID", "Rifle"}
	tempWeaponsArray[65] = {"models/weapons/arccw/mifl/fas2/c_sr25.mdl", "arccw_mifl_fas2_sr25", "SR-25", 17420, "16", "HIGH", "Rifle"}
	tempWeaponsArray[66] = {"models/weapons/arccw/mifl/fas2/c_toz34.mdl", "arccw_mifl_fas2_toz34", "TOZ-34", 12690, "12", "LOW", "Shotgun"}
	tempWeaponsArray[67] = {"models/weapons/arccw/c_claymorelungemine.mdl", "arccw_claymorelungemine", "Claymore Lunge Mine", 5555, "5", "UTIL", "Heavy"}
	tempWeaponsArray[68] = {"models/weapons/arc_eft_usp/c_eft_usp.mdl", "arccw_eft_usp", "HK USP .45", 5555, "5", "LOW", "Pistol"}
	tempWeaponsArray[69] = {"models/weapons/arccw/darsu_eft/c_mp153.mdl", "arccw_eft_mp153", "MP-153", 15005, "13", "MID", "Shotgun"}
	tempWeaponsArray[70] = {"models/weapons/arccw/darsu_eft/c_mp153.mdl", "arccw_eft_mp155", "MP-155", 14005, "12", "MID", "Shotgun"}
	tempWeaponsArray[71] = {"models/weapons/arc_eft_scarl/c_eft_scarh.mdl", "arccw_eft_scarh", "SCAR-H", 17090, "15", "HIGH", "Rifle"}
	tempWeaponsArray[72] = {"models/weapons/arc_eft_scarl/c_eft_scarl.mdl", "arccw_eft_scarl", "SCAR-L", 15995, "14", "MID", "Rifle"}
	tempWeaponsArray[73] = {"models/weapons/arccw/fml/w_fo12_mw.mdl", "arccw_fml_mw_fo12", "FO-12 Shotgun", 20999, "18", "HIGH", "Shotgun"}
	tempWeaponsArray[74] = {"models/weapons/cod_mw2019/w_oden_mammaledition.mdl", "arccw_oden", "VLK Oden", 18505, "16", "HIGH", "Rifle"}
	tempWeaponsArray[75] = {"models/weapons/arccw_go/v_smg_mp5.mdl", "arccw_ur_mp5", "MP5A4", 10005, "8", "LOW", "SMG"}
	tempWeaponsArray[76] = {"models/weapons/arccw_go/v_snip_awp.mdl", "arccw_ur_aw", "AWM SR", 13095, "12", "MID", "Sniper"}
	tempWeaponsArray[77] = {"models/weapons/arccw_sov/v_tkb011.mdl", "arccw_sov_tkb011", "TKB-011", 16000, "14", "HIGH", "Rifle"}
	tempWeaponsArray[78] = {"models/weapons/arccw/c_type89.mdl", "midnights_gso_type89", "Howa Type 89", 18005, "15", "HIGH", "Rifle"}
	tempWeaponsArray[79] = {"models/weapons/bordelzio/arccw/sviinfinity/wmodel/w_svi_infinity.mdl", "arccwsviinfinite", "SVI Infinity", 5555, "5", "LOW", "Pistol"}
	tempWeaponsArray[80] = {"models/weapons/arccw/c_waw_thompson.mdl", "arccw_waw_thompson", "M1A1 Thompson", 11565, "9", "MID", "SMG"}
	tempWeaponsArray[81] = {"models/weapons/arccw/c_waw_mp40.mdl", "arccw_waw_mp40", "MP40", 9895, "8", "LOW", "SMG"}
	tempWeaponsArray[82] = {"models/weapons/arccw/c_waw_type100.mdl", "arccw_waw_type100", "Type 100/44", 12995, "12", "MID", "SMG"}
	tempWeaponsArray[83] = {"models/weapons/arccw/c_bo1_mpl.mdl", "arccw_bo1_mpl", "MPL", 9205, "7", "LOW", "SMG"}
	tempWeaponsArray[84] = {"models/weapons/arccw/c_bo1_pm63.mdl", "arccw_bo1_pm63", "PM-63 RAK", 8995, "7", "LOW", "Pistol"}
	tempWeaponsArray[85] = {"models/weapons/arccw/c_bo1_g11.mdl", "arccw_bo1_g11", "HK G11", 15900, "13", "MID", "Rifle"}
	tempWeaponsArray[86] = {"models/weapons/arccw/c_bo1_law.mdl", "arccw_bo1_law", "M72 LAW RL", 33333, "24", "HIGH", "Heavy"}
	tempWeaponsArray[87] = {"models/weapons/arccw/mifl/fas2/c_glock20.mdl", "arccw_mifl_fas2_g20", "Glock 20", 4700, "4", "LOW", "Pistol"}
	tempWeaponsArray[88] = {"models/weapons/arccw/mifl/fas2/c_p226.mdl", "arccw_mifl_fas2_p226", "P226", 4700, "4", "LOW", "Pistol"}
	tempWeaponsArray[89] = {"models/weapons/arccw/c_waw_nambu.mdl", "arccw_waw_nambu", "Type 14 Nambu", 4250, "4", "LOW", "Pistol"}
	tempWeaponsArray[90] = {"models/weapons/arccw/c_bo1_aug.mdl", "arccw_bo1_aug", "AUG", 14250, "12", "MID", "Rifle"}
	tempWeaponsArray[91] = {"models/weapons/arccw/c_bo1_xl60.mdl", "arccw_bo1_xl60", "XL64ES", 13905, "11", "MID", "Rifle"}
	tempWeaponsArray[92] = {"models/weapons/arccw/c_bo1_famas.mdl", "arccw_bo1_famas", "FAMAS Valorise", 14505, "13", "MID", "Rifle"}
	tempWeaponsArray[93] = {"models/weapons/arccw/c_bo1_fal.mdl", "arccw_bo1_fal", "FN Fal", 17050, "15", "HIGH", "Rifle"}
	tempWeaponsArray[94] = {"models/weapons/arccw/c_bo1_hk21.mdl", "arccw_bo1_hk21", "HK21", 26000, "20", "HIGH", "Heavy"}
	tempWeaponsArray[95] = {"models/weapons/arccw/c_bo1_galil.mdl", "arccw_bo1_galil", "IMI Galil", 14005, "13", "MID", "Rifle"}
	tempWeaponsArray[96] = {"models/weapons/arccw/c_bo1_spas12.mdl", "arccw_bo1_spas12", "SPAS-12", 16000, "14", "MID", "Shotgun"}
	tempWeaponsArray[97] = {"models/weapons/arccw/c_cde_ak5.mdl", "arccw_cde_ak5", "Ak-5", 14940, "13", "MID", "Rifle"}
	tempWeaponsArray[98] = {"models/weapons/arccw/c_waw_mosin.mdl", "arccw_waw_mosin", "Mosin-Nagant M38", 15000, "13", "MID", "Sniper"}
	tempWeaponsArray[99] = {"models/weapons/arccw/c_waw_garand.mdl", "arccw_waw_garand", "M1 Garand", 15500, "14", "MID", "Rifle"}
	tempWeaponsArray[100] = {"models/weapons/arccw/c_waw_357.mdl", "arccw_waw_357", "S&W Model 27", 6995, "5", "LOW", "Pistol"}
	tempWeaponsArray[101] = {"models/weapons/arccw/c_waw_ptrs41.mdl", "arccw_waw_ptrs41", "PTRS-41 SR", 45999, "30", "HIGH", "Sniper"}
	tempWeaponsArray[102] = {"models/weapons/arccw/c_waw_tt33.mdl", "arccw_waw_tt33", "TT-33", 4500, "4", "LOW", "Pistol"}
	tempWeaponsArray[103] = {"models/weapons/arccw/c_bo1_sten.mdl", "arccw_bo1_sten", "Sten Mk II", 11000, "9", "MID", "SMG"}
	tempWeaponsArray[104] = {"models/weapons/arccw/c_waw_fg42.mdl", "arccw_waw_fg42", "FG 42", 40999, "27", "HIGH", "Heavy"}
	tempWeaponsArray[105] = {"models/weapons/arccw/c_bo1_m60.mdl", "arccw_bo1_m60", "M60E3", 32999, "24", "HIGH", "Heavy"}
	tempWeaponsArray[106] = {"models/weapons/arccw/c_waw_trenchgun.mdl", "arccw_waw_trenchgun", "M1897 Trenchgun", 14995, "13", "MID", "Shotgun"}
	tempWeaponsArray[107] = {"models/weapons/arccw/c_bo1_stoner.mdl", "arccw_bo1_stoner", "Stoner 63", 15400, "14", "MID", "Rifle"}
	tempWeaponsArray[108] = {"models/weapons/arccw/c_bo2_fiveseven.mdl", "arccw_bo2_fiveseven", "FN Five-SeveN", 4750, "4", "LOW", "Pistol"}
	tempWeaponsArray[109] = {"models/weapons/arccw/c_cde_m92.mdl", "arccw_cde_m93r", "Beretta 92", 5000, "4", "LOW", "Pistol"}
	tempWeaponsArray[110] = {"models/weapons/arccw/c_waw_mg42.mdl", "arccw_waw_mg42", "MG-42", 52500, "32", "HIGH", "Heavy"}
	tempWeaponsArray[111] = {"models/weapons/arccw/c_bo1_kiparis.mdl", "arccw_bo1_kiparis", "OTS-12 Kiparis", 9550, "8", "LOW", "Pistol"}
	tempWeaponsArray[112] = {"models/weapons/arccw/c_bo1_skorpion.mdl", "arccw_bo1_skorpion", "Skorpion Vz. 65", 9250, "7", "LOW", "Pistol"}
	tempWeaponsArray[113] = {"models/weapons/arccw/c_bo2_vector.mdl", "arccw_bo2_vector", "TDI Kriss Vector 9mm", 24000, "17", "HIGH", "SMG"}
	tempWeaponsArray[114] = {"models/weapons/arccw/c_bo1_svd.mdl", "arccw_bo1_dragunov", "Dragunov SVD", 25000, "17", "HIGH", "Sniper"}
	tempWeaponsArray[115] = {"models/weapons/arccw/c_bo1_rpk.mdl", "arccw_bo1_rpk", "RPK-74", 19500, "15", "HIGH", "Heavy"}
	tempWeaponsArray[116] = {"models/weapons/arccw/c_bo2_lsat.mdl", "arccw_bo2_lsat", "AAI LSAT LMG", 15005, "14", "MID", "Heavy"}
	tempWeaponsArray[117] = {"models/weapons/arccw/c_bo2_smr.mdl", "arccw_bo2_smr", "SMI Saritch .308", 26500, "18", "HIGH", "Rifle"}

	local tempArmorArray = {}

	tempArmorArray[1] = scripted_ents.Get("vest_6b13_1")
	tempArmorArray[2] = scripted_ents.Get("vest_6b13_2")
	tempArmorArray[3] = scripted_ents.Get("vest_6b13_m")
	tempArmorArray[4] = scripted_ents.Get("vest_6b23_1")
	tempArmorArray[5] = scripted_ents.Get("vest_6b23_2")
	tempArmorArray[6] = scripted_ents.Get("vest_6b43")
	tempArmorArray[7] = scripted_ents.Get("helmet_6b47")
	tempArmorArray[8] = scripted_ents.Get("helmet_6b47_2")
	tempArmorArray[9] = scripted_ents.Get("vest_6b5")
	tempArmorArray[10] = scripted_ents.Get("helmet_achhc_black")
	tempArmorArray[11] = scripted_ents.Get("helmet_achhc_green")
	tempArmorArray[12] = scripted_ents.Get("vest_m2")
	tempArmorArray[13] = scripted_ents.Get("vest_a18")
	tempArmorArray[14] = scripted_ents.Get("vest_bnti_gzhel_k")
	tempArmorArray[15] = scripted_ents.Get("vest_bnti_kirasa")
	tempArmorArray[16] = scripted_ents.Get("vest_iotv_gen4_full")
	tempArmorArray[17] = scripted_ents.Get("helmet_kiver")
	tempArmorArray[18] = scripted_ents.Get("helmet_lzsh")
	tempArmorArray[19] = scripted_ents.Get("helmet_maska_1sch")
	tempArmorArray[20] = scripted_ents.Get("helmet_maska_1sch_killa")
	tempArmorArray[21] = scripted_ents.Get("vest_3m")
	tempArmorArray[22] = scripted_ents.Get("helmet_opscore")
	tempArmorArray[23] = scripted_ents.Get("helmet_opscore_visor")
	tempArmorArray[24] = scripted_ents.Get("vest_paca")
	tempArmorArray[25] = scripted_ents.Get("helmet_psh97")
	tempArmorArray[26] = scripted_ents.Get("helmet_shpm")
	tempArmorArray[27] = scripted_ents.Get("vest_trooper")
	tempArmorArray[28] = scripted_ents.Get("helmet_ulach")
	tempArmorArray[29] = scripted_ents.Get("helmet_untar")
	tempArmorArray[30] = scripted_ents.Get("vest_untar")
	tempArmorArray[31] = scripted_ents.Get("vest_wartech_tv110")
	tempArmorArray[32] = scripted_ents.Get("vest_zhuk3")
	tempArmorArray[33] = scripted_ents.Get("vest_zhuk6")
	tempArmorArray[34] = scripted_ents.Get("helmet_zsh1_2m")
	tempArmorArray[35] = scripted_ents.Get("arctic_nvg_shades")
	tempArmorArray[36] = scripted_ents.Get("arctic_nvg_pnv10")
	tempArmorArray[37] = scripted_ents.Get("arctic_nvg_pvs14")
	tempArmorArray[38] = scripted_ents.Get("arctic_nvg_t7")
	tempArmorArray[39] = scripted_ents.Get("arctic_nvg_n15")
	tempArmorArray[40] = scripted_ents.Get("arctic_nvg_gpnvg")
	tempArmorArray[41] = scripted_ents.Get("efgm_weapon_crate_low")
	tempArmorArray[42] = scripted_ents.Get("efgm_weapon_crate_mid")
	tempArmorArray[43] = scripted_ents.Get("efgm_weapon_crate_high")
	tempArmorArray[44] = scripted_ents.Get("arccw_ammo_smg1")
	tempArmorArray[45] = scripted_ents.Get("arccw_ammo_smg1_large")
	tempArmorArray[46] = scripted_ents.Get("arccw_ammo_357")
	tempArmorArray[47] = scripted_ents.Get("arccw_ammo_357_large")
	tempArmorArray[48] = scripted_ents.Get("arccw_ammo_pistol")
	tempArmorArray[49] = scripted_ents.Get("arccw_ammo_pistol_large")
	tempArmorArray[50] = scripted_ents.Get("arccw_ammo_ar2")
	tempArmorArray[51] = scripted_ents.Get("arccw_ammo_ar2_large")
	tempArmorArray[52] = scripted_ents.Get("arccw_ammo_smg1_grenade")
	tempArmorArray[53] = scripted_ents.Get("arccw_ammo_smg1_grenade_large")
	tempArmorArray[54] = scripted_ents.Get("arccw_ammo_buckshot")
	tempArmorArray[55] = scripted_ents.Get("arccw_ammo_buckshot_large")
	tempArmorArray[56] = scripted_ents.Get("arccw_ammo_sniper")
	tempArmorArray[57] = scripted_ents.Get("arccw_ammo_sniper_large")
	tempArmorArray[58] = scripted_ents.Get("fas2_ammo_bandages")
	tempArmorArray[59] = scripted_ents.Get("fas2_ammo_quikclots")
	tempArmorArray[60] = scripted_ents.Get("fas2_ammo_hemostats")

	-- Any weapon in this array cannot be sold. Put any starting equipment here.

	sellBlacklist[1] = {"arccw_go_knife_m9bayonet"}
	sellBlacklist[2] = {"arccw_eft_1911"}
	sellBlacklist[3] = {"arccw_mifl_fas2_g20"}
	sellBlacklist[4] = {"arccw_mifl_fas2_p226"}
	sellBlacklist[5] = {"arccw_waw_nambu"}
	sellBlacklist[6] = {"arccw_go_nade_incendiary"}
	sellBlacklist[7] = {"arccw_go_nade_frag"}
	sellBlacklist[8] = {"arccw_go_nade_flash"}
	sellBlacklist[9] = {"arccw_go_nade_smoke"}
	sellBlacklist[10] = {"arccw_go_nade_molotov"}
	sellBlacklist[11] = {"arccw_go_nade_knife"}
	sellBlacklist[12] = {"arccw_waw_tt33"}

	-- Temporary array created. This next section will sort the guns by cost, so guns higher to the top will hopefully be better. This is convenient.
	-- The sort function takes the fourth value of all tempWeaponsArray indexes (the rouble count) and sorts by them from greatest to lowest.

	-- If you want it in descending order instead of ascending, change the > to a <. If you want it to sort by level requirement, change the [4] to [5].
	-- Do you want it sorted alphabetically? Too bad!

	table.sort( tempWeaponsArray, function(a, b) return a[4] > b[4] end )

	-- I think thats it

	weaponsArr = tempWeaponsArray
	entsArr = tempArmorArray

end
--custom convar table (shared)
if !ConVarExists("efgm_hidebinds") then CreateConVar( "efgm_hidebinds", "0", FCVAR_ARCHIVE, "Show or hide binds, while you are not in Raid",0,1 ) end

-- Disable the context menu.
--function GM:ContextMenuOpen()
	--return false
--end

-- Disable Spawn Menu and show the extract list when the bind is pressed.
--function GM:SpawnMenuEnabled()
	--return false
--end

--function GM:SpawnMenuOpen()
	--RunConsoleCommand("efgm_extract_list")
	--return false
--end

-- Disabling console commands that allow prop/entity abuse.
--hook.Add( "PlayerGiveSWEP", "BlockPlayerSWEPs", function( ply, class, swep )
	--if (not ply:IsAdmin()) then
		-- return false
	--end
--end )

--function GM:PlayerSpawnEffect(ply)
--	return false
--end

--function GM:PlayerSpawnNPC(ply)
--	return false
--end

--function GM:PlayerSpawnObject(ply)
--	return false
--end

--function GM:PlayerSpawnProp(ply)
--	return false
--end

--function GM:PlayerSpawnRagdoll(ply)
--	return false
--end

--function GM:PlayerSpawnSENT(ply)
--	return false
--end

--function GM:PlayerSpawnSWEP(ply)
--	return false
--end

--function GM:PlayerSpawnVehicle(ply)
--	return false
--end

-- Removing problematic console commmands.

--concommand.Remove("ent_create")
--concommand.Remove("gmod_spawnnpc")


-- This is where the console commands are ran when a client joins a game running the gamemode.

--Anti-Bunnyhopping

RunConsoleCommand("vk_enabled", "1")
RunConsoleCommand("vk_suppressor", "1")
RunConsoleCommand("vk_speedlimit", "1")

--Day/Night System

RunConsoleCommand("atmos_dnc_length_day", "480")
RunConsoleCommand("atmos_dnc_length_night", "300")
RunConsoleCommand("atmos_weather_length", "300")
RunConsoleCommand("atmos_weather_chance", "20")
RunConsoleCommand("atmos_weather_delay", "300")
RunConsoleCommand("atmos_weather_lighting", "1")

--Tarkov Hud Configuration

RunConsoleCommand("tarkovhud_hp_colored", "1")
RunConsoleCommand("tarkovhud_autohide_hp", "0")
RunConsoleCommand("tarkovhud_autohide_stamina", "0")
RunConsoleCommand("tarkovhud_blur", "1")
RunConsoleCommand("tarkovhud_blur_neardeath", "1")

--Realistic Fall Damage

RunConsoleCommand("mp_falldamage", "1")

--Killfeed Disable

RunConsoleCommand("hud_deathnotice_time", "0")

--View Bobbing
RunConsoleCommand("viewbob_crouch_enable", "1")
RunConsoleCommand("viewbob_crouch_multiplier", "0.12")
RunConsoleCommand("viewbob_enable", "1")
RunConsoleCommand("viewbob_idle_enable", "0")
RunConsoleCommand("viewbob_damage_enable", "1")
RunConsoleCommand("viewbob_land_jump_enable", "1")
RunConsoleCommand("viewbob_walk_enable", "0")

RunConsoleCommand("viewbob_damage_enable", "1")
RunConsoleCommand("viewbob_damage_multiplier", "0.10")

RunConsoleCommand("suppression_viewpunch", "0")

--Damage Slow Config

RunConsoleCommand("stoppower_dmg_mult", "0.05")
RunConsoleCommand("stoppower_minimum_speed_mult", "0.55")
RunConsoleCommand("stoppower_recovery_speed", "0.66")
RunConsoleCommand("stoppower_recovery_delay", "0.25")

--Disabling NoClip/Tinnitus

RunConsoleCommand("sbox_noclip", "0")
RunConsoleCommand("dsp_off", "1")

--Auto Respawning

RunConsoleCommand("sv_autorespawn_enabled", "1")
RunConsoleCommand("sv_respawntime", "15")
RunConsoleCommand("cl_drawownshadow", "1")

--Death Screen Settings

RunConsoleCommand("cl_pomer_text", "[You Died]")

--Loot Rings/Attachment Menu Configuration

RunConsoleCommand("cl_vmanip_pickups_halo", "1")

--Dynamic Height

RunConsoleCommand("sv_ec2_dynamicheight", "0")
RunConsoleCommand("sv_ec2_dynamicheight_min", "42")
RunConsoleCommand("sv_ec2_dynamicheight_max", "64")

--GWS Config

RunConsoleCommand("sv_drop_loot_on_death", "1")

--Proximity Voice Chat

RunConsoleCommand("sv_maxVoiceAudible", "1500")

--Inventory Blacklist

RunConsoleCommand("gws_blacklist_load")

--ARC CW Stuff

RunConsoleCommand("arccw_2d3d", "0")
RunConsoleCommand("arccw_add_sway", "0.40")
RunConsoleCommand("arccw_adjustsensthreshold", "0.00")
RunConsoleCommand("arccw_aimassist", "0")
RunConsoleCommand("arccw_aimassist_cl", "0")
RunConsoleCommand("arccw_aimassist_cone", "5.00")
RunConsoleCommand("arccw_aimassist_distance", "1024.00")
RunConsoleCommand("arccw_aimassist_head", "0")
RunConsoleCommand("arccw_altbindsonly", "0")
RunConsoleCommand("arccw_ammo_autopickup", "1")
RunConsoleCommand("arccw_att_showground", "1")
RunConsoleCommand("arccw_att_showothers", "1")
RunConsoleCommand("arccw_attinv_free", "0")
RunConsoleCommand("arccw_attinv_giveonspawn", "200")
RunConsoleCommand("arccw_attinv_loseondie", "2")
RunConsoleCommand("arccw_blur", "0")
RunConsoleCommand("arccw_blur_toytown", "0")
RunConsoleCommand("arccw_bullet_drag", "1.00")
RunConsoleCommand("arccw_bullet_enable", "1")
RunConsoleCommand("arccw_bullet_gravity", "675.00")
RunConsoleCommand("arccw_bullet_imaginary", "1")
RunConsoleCommand("arccw_bullet_lifetime", "10.00")
RunConsoleCommand("arccw_bullet_velocity", "0.82")
RunConsoleCommand("arccw_cheapscopes", "0")
RunConsoleCommand("arccw_cheapscopesautoconfig", "0")
RunConsoleCommand("arccw_cheapscopesv2_ratio", "0.00")
RunConsoleCommand("arccw_crosshair", "0")
RunConsoleCommand("arccw_desync", "0")
RunConsoleCommand("arccw_doorbust", "1")
RunConsoleCommand("arccw_drawbarrel", "1")
RunConsoleCommand("arccw_enable_customization", "1")
RunConsoleCommand("arccw_enable_dropping", "1")
RunConsoleCommand("arccw_enable_penetration", "1")
RunConsoleCommand("arccw_enable_ricochet", "1")
RunConsoleCommand("arccw_enable_sway", "1")
RunConsoleCommand("arccw_fastmuzzles", "0")
RunConsoleCommand("arccw_fasttracers", "0")
RunConsoleCommand("arccw_glare", "1")
RunConsoleCommand("arccw_gsoe_addsway", "0")
RunConsoleCommand("arccw_hud_3dfun", "0")
RunConsoleCommand("arccw_malfunction", "2")
RunConsoleCommand("arccw_mult_accuracy", "0.70")
RunConsoleCommand("arccw_mult_ammoamount", "1.00")
RunConsoleCommand("arccw_mult_ammohealth", "1.00")
RunConsoleCommand("arccw_mult_attchance", "1.00")
RunConsoleCommand("arccw_mult_bottomlessclip", "0")
RunConsoleCommand("arccw_mult_crouchdisp", "0.85")
RunConsoleCommand("arccw_mult_crouchrecoil", "0.85")
RunConsoleCommand("arccw_mult_damage", "0.90")
RunConsoleCommand("arccw_mult_defaultammo", "3")
RunConsoleCommand("arccw_mult_heat", "1.00")
RunConsoleCommand("arccw_mult_hipfire", "1.75")
RunConsoleCommand("arccw_mult_infiniteammo", "0")
RunConsoleCommand("arccw_mult_malfunction", "1.65")
RunConsoleCommand("arccw_mult_movedisp", "0.50")
RunConsoleCommand("arccw_mult_penetration", "1.00")
RunConsoleCommand("arccw_mult_range", "1.00")
RunConsoleCommand("arccw_mult_recoil", "1.30")
RunConsoleCommand("arccw_mult_reloadtime", "1.65")
RunConsoleCommand("arccw_mult_shootwhilesprinting", "0")
RunConsoleCommand("arccw_mult_sighttime", "1.30")
RunConsoleCommand("arccw_mult_startunloaded", "0")
RunConsoleCommand("arccw_mult_sway", "1.00")
RunConsoleCommand("arccw_nohl2flash", "1")
RunConsoleCommand("arccw_override_crosshair_off", "1")
RunConsoleCommand("arccw_scopepp", "1")
RunConsoleCommand("arccw_scopepp_refract", "1")
RunConsoleCommand("arccw_shake", "1")
RunConsoleCommand("arccw_shakevm", "1")
RunConsoleCommand("arccw_shelleffects", "1")
RunConsoleCommand("arccw_shelltime", "15")
RunConsoleCommand("arccw_thermalpp", "1")
RunConsoleCommand("arccw_throwinertia", "1")
RunConsoleCommand("arccw_truenames", "1")
RunConsoleCommand("arccw_visibility", "8000")
RunConsoleCommand("arccw_vm_add_ads", "1.00")
RunConsoleCommand("arccw_vm_bob_sprint", "3.00")
RunConsoleCommand("arccw_vm_coolsway", "1")
RunConsoleCommand("arccw_vm_coolview", "1")
RunConsoleCommand("arccw_vm_coolview_mult", "1.00")
RunConsoleCommand("arccw_truenames", "1")
RunConsoleCommand("arccw_vm_forward", "0.00")
RunConsoleCommand("arccw_vm_fov", "0.00")
RunConsoleCommand("arccw_vm_look_xmult", "3.00")
RunConsoleCommand("arccw_vm_look_ymult", "2.00")
RunConsoleCommand("arccw_vm_nearwall", "1")
RunConsoleCommand("arccw_vm_sway_sprint", "3.00")
RunConsoleCommand("arccw_vm_fov", "0.00")
RunConsoleCommand("arccw_vm_look_xmult", "3.00")
RunConsoleCommand("arccw_vm_look_ymult", "2.00")
RunConsoleCommand("arccw_hud_fcgbars", "0")
RunConsoleCommand("arccw_hud_showammo", "0")
RunConsoleCommand("arccw_hud_showhealth", "0")
RunConsoleCommand("arccw_ammonames", "1")
RunConsoleCommand("arccw_altubglkey", "1")
RunConsoleCommand("arccw_hud_minimal", "0")
RunConsoleCommand("arccw_hud_size", "0.95")