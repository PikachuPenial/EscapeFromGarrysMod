GM.Name = "Escape From Garry's Mod"
GM.Author = "Pikachu/Penial"
GM.Email = "jacksonwassermann55@icloud.com"
GM.Website = "https://github.com/PikachuPenial"

DeriveGamemode("sandbox")

sellPriceMultiplier = 0.35

weaponsArr = {}
entsArr = {}
sellBlacklist = {}

function GM:Initialize()
  
  isSellMenu = false
	clientPlayer = nil

	-- Creating a temporary array to sort through for the actual array seen in the shop

	local tempWeaponsArray = {}

	tempWeaponsArray[1] = {"models/weapons/arccw/dm1973/c_dmi_bm92f_auto.mdl", "arccw_dmi_b92f_auto", "92F Auto Pistol", 13005, "10", "MID"}
	tempWeaponsArray[2] = {"models/weapons/arccw/dm1973/w_arccw_dmi_c7a2.mdl", "arccw_dmi_c7a2_inftry", "C7A2", 16955, "14", "HIGH"}
	tempWeaponsArray[3] = {"models/weapons/arccw/strellray/w_hk416_a7_battle.mdl", "arccw_hk416", "HK416", 18370, "16", "HIGH"}
	tempWeaponsArray[4] = {"models/weapons/arccw/w_zz_mg24_tp.mdl", "arccw_dp28", "DP-28 HLMG", 21370, "17", "HIGH"}
	tempWeaponsArray[5] = {"models/weapons/arccw/dm1973/w_dmi_sig_mpx.mdl", "arccw_sigmpx_combat", "SIG MPX 9mm", 12410, "11", "LOW"}
	tempWeaponsArray[6] = {"models/weapons/arc_eft_aks74u/eft_aks74u/models/c_eft_aks74u.mdl", "arccw_eft_aks74u", "AKS-74u", 9980, "7", "LOW"}
	tempWeaponsArray[7] = {"models/weapons/arc_eft_1911/c_eft_1911/models/c_eft_1911.mdl", "arccw_eft_1911", "M1911", 4140, "3", "LOW"}
	tempWeaponsArray[8] = {"models/weapons/arc_eft_mp5/w_eft_mp5/models/w_eft_mp5.mdl", "arccw_eft_mp5", "MP5", 10995, "9", "LOW"}
	tempWeaponsArray[9] = {"models/weapons/arc_eft_mp5/w_eft_mp5_std/models/w_eft_mp5_std.mdl", "arccw_eft_mp5sd", "MP5SD", 9995, "8", "LOW"}
	tempWeaponsArray[10] = {"models/weapons/arc_eft_mp7/eft_mp7/models/c_eft_mp7.mdl", "arccw_eft_mp7", "MP7A1", 13195, "10", "MID"}
	tempWeaponsArray[11] = {"models/weapons/arc_eft_ppsh/c_eft_ppsh/models/c_eft_ppsh.mdl", "arccw_eft_ppsh", "PPSH-41", 8440, "5", "LOW"}
	tempWeaponsArray[12] = {"models/weapons/arc_eft_t5000/eft_t5000/models/c_eft_t5000.mdl", "arccw_eft_t5000", "T-5000", 18050, "13", "HIGH"}
	tempWeaponsArray[13] = {"models/weapons/arc_eft_ump/eft_ump/models/c_eft_ump.mdl", "arccw_eft_ump", "UMP-45", 10050, "6", "LOW"}
	tempWeaponsArray[14] = {"models/weapons/arccw/eap/c_aek971.mdl", "arccw_eap_aek", "AEK-971", 17120, "15", "HIGH"}
	tempWeaponsArray[15] = {"models/weapons/arccw/eap/c_brenten.mdl", "arccw_eap_brenten", "Bren Ten Pistol", 6010, "5", "LOW"}
	tempWeaponsArray[16] = {"models/weapons/arccw/eap/c_csls5.mdl", "arccw_eap_csls5", "CS/LS5 SMG", 10510, "8", "MID"}
	tempWeaponsArray[17] = {"models/weapons/arccw/eap/c_fmg9.mdl", "arccw_eap_fmg9", "FMG-9", 13080, "9", "MID"}
	tempWeaponsArray[18] = {"models/weapons/arccw/eap/c_groza.mdl", "arccw_eap_groza", "OTs-14 Groza", 13580, "10", "MID"}
	tempWeaponsArray[19] = {"models/weapons/arccw/eap/c_lebedev.mdl", "arccw_eap_lebedev", "PL-15 Lebedev Pistol", 4630, "3", "LOW"}
	tempWeaponsArray[20] = {"models/weapons/arccw/eap/c_spectre.mdl", "arccw_eap_spectre", "Spectre M4", 11010, "8", "MID"}
	tempWeaponsArray[21] = {"models/weapons/arccw/eap/c_stg44.mdl", "arccw_eap_stg44", "StG-44", 13100, "10", "MID"}
	tempWeaponsArray[22] = {"models/weapons/arccw/eap/c_usas.mdl", "arccw_eap_usas", "USAS-12", 27510, "20", "HIGH"}
	tempWeaponsArray[23] = {"models/weapons/arccw/eap/c_vp70.mdl", "arccw_eap_vp70", "VP70", 5005, "4", "LOW"}
	tempWeaponsArray[24] = {"models/weapons/arccw/eap/c_xm29.mdl", "arccw_eap_xm29", "XM29", 18005, "15", "HIGH"}
	tempWeaponsArray[25] = {"models/weapons/arccw/slogkot/c_altor.mdl", "arccw_slog_altor", "Altor Pistol", 5005, "5", "LOW"}
	tempWeaponsArray[26] = {"models/weapons/arccw/fml/w_fatcry5_arc.mdl", "arccw_fml_blast_fc5_arc", "AR-C", 15005, "13", "HIGH"}
	tempWeaponsArray[27] = {"models/weapons/arccw/kriss/w_kriss.mdl", "arccw_krissvector", "Kriss Vector", 20005, "15", "HIGH"}
	tempWeaponsArray[28] = {"models/weapons/c_tderp_asval2.mdl", "arccw_asval", "AS VAL", 17990, "13", "HIGH"}
	tempWeaponsArray[29] = {"models/weapons/arccw/fml/w_pflio_lynx.mdl", "arccw_mifl_lynx", "CQ300", 18420, "14", "HIGH"}
	tempWeaponsArray[30] = {"models/weapons/arccw/fml/w_tarkov_mdr.mdl", "arccw_fml_eft_mdr", "MDR 7.62", 19005, "14", "HIGH"}
	tempWeaponsArray[31] = {"models/weapons/arccw/mifl/sketchfab/c_msd9.mdl", "arccw_mifl_mds9", "MDS-9", 6200, "5", "LOW"}
	tempWeaponsArray[32] = {"models/weapons/w_rif_pindadss2.mdl", "arccw_blast_pindadss2", "Pindad SS2-V1", 18200, "14", "HIGH"}
	tempWeaponsArray[33] = {"models/weapons/arccw/fml/w_scar_sd.mdl", "arccw_fml_scarsd", "SCAR-SD", 23105, "17", "HIGH"}
	tempWeaponsArray[34] = {"models/weapons/arccw_go/v_eq_taser.mdl", "arccw_go_taser", "Advanced Taser M26", 3333, "3", "UTIL"}
	tempWeaponsArray[35] = {"models/weapons/arccw_go/v_eq_incendiarygrenade.mdl", "arccw_go_nade_incendiary", "AN/M14 Thermite Grenade", 2500, "3", "UTIL"}
	tempWeaponsArray[36] = {"models/weapons/arccw_go/v_eq_fraggrenade.mdl", "arccw_go_nade_frag", "M67 Frag Grenade", 2500, "3", "UTIL"}
	tempWeaponsArray[37] = {"models/weapons/arccw_go/v_eq_flashbang.mdl", "arccw_go_nade_flash", "M84 Stun Grenade", 2500, "3", "UTIL"}
	tempWeaponsArray[38] = {"models/weapons/arccw_go/v_eq_smokegrenade.mdl", "arccw_go_nade_smoke", "M5210 Smoke Grenade", 2500, "3", "UTIL"}
	tempWeaponsArray[39] = {"models/weapons/arccw_go/v_eq_molotov.mdl", "arccw_go_nade_molotov", "Molotov Cocktail", 2500, "3", "UTIL"}
	tempWeaponsArray[40] = {"models/weapons/arccw_go/v_eq_throwingknife.mdl", "arccw_go_nade_knife", "Throwing Knife", 2500, "3", "UTIL"}
	tempWeaponsArray[41] = {"models/weapons/c_csgo_flashbang.mdl", "weapon_csgo_flashbang", "M84 MK2 Flash Grenade", 2500, "3", "UTIL"}
	tempWeaponsArray[42] = {"models/weapons/arccw_go/v_shot_m1014.mdl", "arccw_go_m1014", "M1014 SG", 11510, "10", "MID"}
	tempWeaponsArray[43] = {"models/weapons/arccw_go/v_mach_m249para.mdl", "arccw_go_m249para", "M249 SAW LMG", 14000, "12", "HIGH"}
	tempWeaponsArray[44] = {"models/weapons/arccw_go/v_shot_mag7.mdl", "arccw_go_mag7", "MAG-7 SG", 13333, "13", "HIGH"}
	tempWeaponsArray[45] = {"models/weapons/arccw_go/v_shot_870.mdl", "arccw_go_870", "Model 870 SG", 8905, "8", "LOW"}
	tempWeaponsArray[46] = {"models/weapons/arccw_go/v_mach_negev.mdl", "arccw_go_negev", "Negev LMG", 12000, "10", "MID"}
	tempWeaponsArray[47] = {"models/weapons/arccw_go/v_shot_nova.mdl", "arccw_go_nova", "Supernova SG", 11250, "10", "MID"}
	tempWeaponsArray[48] = {"models/weapons/arccw_go/v_pist_cz75.mdl", "arccw_go_cz75", "CZ-75", 4790, "4", "LOW"}
	tempWeaponsArray[49] = {"models/weapons/arccw_go/v_pist_deagle.mdl", "arccw_ur_deagle", "Desert Eagle", 6005, "5", "LOW"}
	tempWeaponsArray[50] = {"models/weapons/arccw_go/v_pist_fiveseven.mdl", "arccw_go_fiveseven", "Five-seveN", 4250, "3", "LOW"}
	tempWeaponsArray[51] = {"models/weapons/arccw_go/v_pist_glock.mdl", "arccw_go_glock", "Glock 17", 4700, "4", "LOW"}
	tempWeaponsArray[52] = {"models/weapons/arccw_go/v_pist_m9.mdl", "arccw_go_m9", "M92FS", 4250, "3", "LOW"}
	tempWeaponsArray[53] = {"models/weapons/arccw_go/v_pist_r8.mdl", "arccw_go_r8", "Model 327 R8", 6005, "5", "LOW"}
	tempWeaponsArray[54] = {"models/weapons/arccw_go/v_pist_p2000.mdl", "arccw_go_p2000", "P2000", 4250, "3", "LOW"}
	tempWeaponsArray[55] = {"models/weapons/arccw_go/v_pist_p250.mdl", "arccw_go_p250", "P250", 4700, "4", "LOW"}
	tempWeaponsArray[56] = {"models/weapons/arccw_go/v_pist_sw29.mdl", "arccw_go_sw29", "S&W M29", 5250, "4", "LOW"}
	tempWeaponsArray[57] = {"models/weapons/arccw_go/v_pist_tec9.mdl", "arccw_go_tec9", "TEC-9", 5250, "4", "LOW"}
	tempWeaponsArray[58] = {"models/weapons/arccw_go/v_pist_usp.mdl", "arccw_go_usp", "USP-45", 4700, "4", "LOW"}
	tempWeaponsArray[59] = {"models/weapons/arccw_go/v_rif_ace.mdl", "arccw_go_ace", "ACE 23", 15920, "11", "HIGH"}
	tempWeaponsArray[60] = {"models/weapons/arccw_go/v_rif_ak47.mdl", "arccw_go_ak47", "AKM", 13905, "10", "MID"}
	tempWeaponsArray[61] = {"models/weapons/arccw_go/v_rif_car15.mdl", "arccw_go_ar15", "AR-15", 11995, "8", "MID"}
	tempWeaponsArray[62] = {"models/weapons/arccw_go/v_rif_aug.mdl", "arccw_go_aug", "AUG A3", 14250, "12", "MID"}
	tempWeaponsArray[63] = {"models/weapons/arccw_go/v_snip_awp.mdl", "arccw_go_awp", "AWSM SR", 17995, "16", "HIGH"}
	tempWeaponsArray[64] = {"models/weapons/arccw_go/v_rif_fnfal.mdl", "arccw_go_fnfal", "FAL", 17250, "14", "HIGH"}
	tempWeaponsArray[65] = {"models/weapons/arccw_go/v_rif_famas.mdl", "arccw_go_famas", "FAMAS G1", 13995, "11", "MID"}
	tempWeaponsArray[66] = {"models/weapons/arccw_go/v_rif_g3.mdl", "arccw_go_g3", "G3", 18500, "16", "HIGH"}
	tempWeaponsArray[67] = {"models/weapons/arccw_go/v_rif_galil_ar.mdl", "arccw_go_galil_ar", "Galil AR", 18500, "16", "HIGH"}
	tempWeaponsArray[68] = {"models/weapons/arccw_go/v_rif_car15.mdl", "arccw_go_m16a2", "M16A2", 16550, "14", "MID"}
	tempWeaponsArray[69] = {"models/weapons/arccw_go/v_rif_m4a1.mdl", "arccw_go_m4", "M4A1", 17110, "14", "HIGH"}
	tempWeaponsArray[70] = {"models/weapons/arccw_go/v_rif_scar.mdl", "arccw_go_scar", "SCAR-T", 17600, "15", "HIGH"}
	tempWeaponsArray[71] = {"models/weapons/arccw_go/v_rif_sg556.mdl", "arccw_go_sg556", "SIG SG556", 16640, "13", "HIGH"}
	tempWeaponsArray[72] = {"models/weapons/arccw_go/v_snip_ssg08.mdl", "arccw_go_ssg08", "SSG08 SR", 15625, "13", "MID"}
	tempWeaponsArray[73] = {"models/weapons/arccw_go/v_smg_mac10.mdl", "arccw_go_mac10", "MAC-10", 7600, "6", "LOW"}
	tempWeaponsArray[74] = {"models/weapons/arccw_go/v_smg_mp5.mdl", "arccw_go_mp5", "MP5A2", 8240, "7", "LOW"}
	tempWeaponsArray[75] = {"models/weapons/arccw_go/v_smg_mp7.mdl", "arccw_go_mp7", "MP7A2", 8590, "7", "LOW"}
	tempWeaponsArray[76] = {"models/weapons/arccw_go/v_smg_mp9.mdl", "arccw_go_mp9", "MP9N", 8590, "8", "LOW"}
	tempWeaponsArray[77] = {"models/weapons/arccw_go/v_smg_p90.mdl", "arccw_go_p90", "P90 TR", 14990, "10", "MID"}
	tempWeaponsArray[78] = {"models/weapons/arccw_go/v_smg_bizon.mdl", "arccw_go_bizon", "PP-19 Bizon-2", 8750, "8", "MID"}
	tempWeaponsArray[79] = {"models/weapons/arccw_go/v_smg_ump45.mdl", "arccw_go_ump", "UMP-9mm", 9360, "9", "LOW"}
	tempWeaponsArray[80] = {"models/weapons/arccw/midnightwolf/arccw_midnightwolf_acr.mdl", "arccw_midnightwolf_acr", "ACR", 16420, "14", "HIGH"}
	tempWeaponsArray[81] = {"models/weapons/arccw/c_xm8.mdl", "midnights_gso_xm8", "HK XM8", 18920, "17", "HIGH"}
	tempWeaponsArray[82] = {"models/weapons/arccw/midnightwolf/type20.mdl", "arccw_midnightwolf_type20", "Type 20", 17880, "15", "HIGH"}
	tempWeaponsArray[83] = {"models/viper/mw/weapons/w_725_mammaledition.mdl", "arccw_725", "Citori 725 SG", 8950, "7", "HIGH"}
	tempWeaponsArray[84] = {"models/weapons/cod_mw2019/w_g36k_mammaledition.mdl", "arccw_g36mw19", "G36K", 14445, "13", "MID"}
	tempWeaponsArray[85] = {"models/viper/mw/weapons/kilo433_mammaledition.mdl", "arccw_kilo141", "HK433", 15690, "14", "MID"}
	tempWeaponsArray[86] = {"models/weapons/w_mcxvirtus.mdl", "arccw_mcx", "MCX Virtus SBR", 17180, "15", "MID"}
	tempWeaponsArray[87] = {"models/weapons/arccw/fml/mw19/w_mk2_k.mdl", "arccw_fml_mk2k", "MK2-K DMR", 11050, "8", "MID"}
	tempWeaponsArray[88] = {"models/weapons/cod_mw2019/c_sg552_mammaledition.mdl", "arccw_grau", "SG 552 Commando", 13005, "13", "MID"}
	tempWeaponsArray[89] = {"models/weapons/arccw/c_ud_glock.mdl", "arccw_ud_glock", "Glock 22", 6005, "5", "LOW"}
	tempWeaponsArray[90] = {"models/weapons/arccw/c_ud_m16.mdl", "arccw_ud_m16", "M16A3", 16995, "14", "MID"}
	tempWeaponsArray[91] = {"models/weapons/arccw/c_ud_m1014.mdl", "arccw_ud_m1014", "M4 Super 90 SG", 12995, "12", "MID"}
	tempWeaponsArray[92] = {"models/weapons/arccw/c_ud_m79.mdl", "arccw_ud_m79", "M79 Grenade Launcher", 22555, "20", "HIGH"}
	tempWeaponsArray[93] = {"models/weapons/arccw/c_ud_mini14.mdl", "arccw_ud_mini14", "Mini-14", 16420, "14", "MID"}
	tempWeaponsArray[94] = {"models/weapons/arccw/c_ud_870.mdl", "arccw_ud_870", "Remington 870", 10240, "9", "MID"}
	tempWeaponsArray[95] = {"models/weapons/arccw/c_ud_uzi.mdl", "arccw_ud_uzi", "Uzi", 11040, "8", "LOW"}
	tempWeaponsArray[96] = {"models/weapons/arccw/w_arccw_smg0818.mdl", "arccw_ww1_smg0818", "Maxim SMG LMG", 27500, "22", "HIGH"}
	tempWeaponsArray[97] = {"models/weapons/arccw/mifl/fas2/c_ak47.mdl", "arccw_ur_ak", "AKM", 17005, "15", "HIGH"}
	tempWeaponsArray[98] = {"models/weapons/arccw/mifl/fas2/c_famas.mdl", "arccw_mifl_fas2_famas", "FAMAS", 16990, "14", "MID"}
	tempWeaponsArray[99] = {"models/weapons/arccw/mifl/fas2/c_g3.mdl", "arccw_mifl_fas2_g3", "G3A3", 16310, "14", "MID"}
	tempWeaponsArray[100] = {"models/weapons/arccw/mifl/fas2/c_ks23.mdl", "arccw_mifl_fas2_ks23", "KS-23", 13005, "13", "MID"}
	tempWeaponsArray[101] = {"models/weapons/arccw/mifl/fas2/c_m24.mdl", "arccw_mifl_fas2_m24", "M24 SR", 18900, "15", "HIGH"}
	tempWeaponsArray[102] = {"models/weapons/arccw/mifl/fas2/c_m3s90.mdl", "arccw_mifl_fas2_m3", "M3 Super 90", 14505, "14", "MID"}
	tempWeaponsArray[103] = {"models/weapons/arccw/mifl/fas2/c_m82.mdl", "arccw_mifl_fas2_m82", "M82 SR", 20999, "20", "HIGH"}
	tempWeaponsArray[104] = {"models/weapons/arccw/mifl/fas2/c_mac11.mdl", "arccw_mifl_fas2_mac11", "MAC-11", 8100, "6", "LOW"}
	tempWeaponsArray[105] = {"models/weapons/arccw/mifl/fas2_custom/c_m26.mdl", "arccw_fml_fas2_custom_mass26", "MASS-26 SG", 14895, "15", "HIGH"}
	tempWeaponsArray[106] = {"models/weapons/arccw/mifl/fas2/c_minimi.mdl", "arccw_mifl_fas2_minimi", "Minimi", 19995, "20", "HIGH"}
	tempWeaponsArray[107] = {"models/weapons/arccw/mifl/fas2/c_ragingbull.mdl", "arccw_mifl_fas2_ragingbull", "Raging Bull Revolver", 7020, "7", "LOW"}
	tempWeaponsArray[108] = {"models/weapons/arccw/mifl/fas2/c_rpk.mdl", "arccw_mifl_fas2_rpk", "RPK47", 14765, "14", "MID"}
	tempWeaponsArray[109] = {"models/weapons/arccw/mifl/fas2/c_sg552.mdl", "arccw_mifl_fas2_sg55x", "SG552", 15490, "14", "MID"}
	tempWeaponsArray[110] = {"models/weapons/arccw/mifl/fas2/c_sr25.mdl", "arccw_mifl_fas2_sr25", "SR-25", 17420, "16", "HIGH"}
	tempWeaponsArray[111] = {"models/weapons/arccw/mifl/fas2/c_toz34.mdl", "arccw_mifl_fas2_toz34", "TOZ-34", 12690, "12", "LOW"}
	tempWeaponsArray[112] = {"models/weapons/arccw/c_claymorelungemine.mdl", "arccw_claymorelungemine", "Claymore Lunge Mine", 5555, "5", "UTIL"}
	tempWeaponsArray[113] = {"models/weapons/arc_eft_usp/c_eft_usp.mdl", "arccw_eft_usp", "HK USP .45", 5555, "5", "LOW"}
	tempWeaponsArray[114] = {"models/weapons/arccw/darsu_eft/c_mp153.mdl", "arccw_eft_mp153", "MP-153", 15005, "13", "MID"}
	tempWeaponsArray[115] = {"models/weapons/arccw/darsu_eft/c_mp153.mdl", "arccw_eft_mp155", "MP-155", 14005, "12", "MID"}
	tempWeaponsArray[116] = {"models/weapons/arc_eft_scarl/c_eft_scarh.mdl", "arccw_eft_scarh", "SCAR-H", 17090, "15", "HIGH"}
	tempWeaponsArray[117] = {"models/weapons/arc_eft_scarl/c_eft_scarl.mdl", "arccw_eft_scarl", "SCAR-L", 15995, "14", "MID"}
	tempWeaponsArray[118] = {"models/weapons/arccw/fml/w_fo12_mw.mdl", "arccw_fml_mw_fo12", "FO-12 Shotgun", 20999, "18", "HIGH"}
	tempWeaponsArray[119] = {"models/weapons/cod_mw2019/w_oden_mammaledition.mdl", "arccw_oden", "VLK Oden", 18505, "16", "MID"}
	tempWeaponsArray[120] = {"models/weapons/arccw/clancy/micro_uzi_w.mdl", "micro_uzi", "Micro Uzi", 6995, "7", "LOW"}
	tempWeaponsArray[121] = {"models/weapons/arccw_go/v_smg_mp5.mdl", "arccw_ur_mp5", "MP5A4", 10005, "8", "LOW"}
	tempWeaponsArray[122] = {"models/weapons/arccw_go/v_snip_awp.mdl", "arccw_ur_aw", "AWM SR", 13095, "12", "MID"}
	tempWeaponsArray[123] = {"models/weapons/arccw_sov/v_tkb011.mdl", "arccw_sov_tkb011", "TKB-011", 16000, "14", "HIGH"}
	tempWeaponsArray[124] = {"models/weapons/arccw/c_type89.mdl", "midnights_gso_type89", "Howa Type 89", 18005, "15", "HIGH"}
	tempWeaponsArray[125] = {"models/weapons/bordelzio/arccw/sviinfinity/wmodel/w_svi_infinity.mdl", "arccwsviinfinite", "SVI Infinity", 5555, "5", "LOW"}

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
	tempArmorArray[41] = scripted_ents.Get("lfs_rust_minicopter")
	tempArmorArray[42] = scripted_ents.Get("efgm_weapon_crate_low")
	tempArmorArray[43] = scripted_ents.Get("efgm_weapon_crate_mid")
	tempArmorArray[44] = scripted_ents.Get("efgm_weapon_crate_high")
	tempArmorArray[45] = scripted_ents.Get("arccw_ammo_smg1")
	tempArmorArray[46] = scripted_ents.Get("arccw_ammo_smg1_large")
	tempArmorArray[47] = scripted_ents.Get("arccw_ammo_357")
	tempArmorArray[48] = scripted_ents.Get("arccw_ammo_357_large")
	tempArmorArray[49] = scripted_ents.Get("arccw_ammo_pistol")
	tempArmorArray[50] = scripted_ents.Get("arccw_ammo_pistol_large")
	tempArmorArray[51] = scripted_ents.Get("arccw_ammo_ar2")
	tempArmorArray[52] = scripted_ents.Get("arccw_ammo_ar2_large")
	tempArmorArray[53] = scripted_ents.Get("arccw_ammo_smg1_grenade")
	tempArmorArray[54] = scripted_ents.Get("arccw_ammo_smg1_grenade_large")
	tempArmorArray[55] = scripted_ents.Get("arccw_ammo_buckshot")
	tempArmorArray[56] = scripted_ents.Get("arccw_ammo_buckshot_large")
	tempArmorArray[57] = scripted_ents.Get("arccw_ammo_sniper")
	tempArmorArray[58] = scripted_ents.Get("arccw_ammo_sniper_large")
	tempArmorArray[59] = scripted_ents.Get("arccw_ammo_plinking")
	tempArmorArray[60] = scripted_ents.Get("arccw_ammo_plinking_large")

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
	tempArmorArray[41] = scripted_ents.Get("lfs_rust_minicopter")
	tempArmorArray[42] = scripted_ents.Get("efgm_weapon_crate_low")
	tempArmorArray[43] = scripted_ents.Get("efgm_weapon_crate_mid")
	tempArmorArray[44] = scripted_ents.Get("efgm_weapon_crate_high")
	tempArmorArray[45] = scripted_ents.Get("arccw_ammo_smg1")
	tempArmorArray[46] = scripted_ents.Get("arccw_ammo_smg1_large")
	tempArmorArray[47] = scripted_ents.Get("arccw_ammo_357")
	tempArmorArray[48] = scripted_ents.Get("arccw_ammo_357_large")
	tempArmorArray[49] = scripted_ents.Get("arccw_ammo_pistol")
	tempArmorArray[50] = scripted_ents.Get("arccw_ammo_pistol_large")
	tempArmorArray[51] = scripted_ents.Get("arccw_ammo_ar2")
	tempArmorArray[52] = scripted_ents.Get("arccw_ammo_ar2_large")
	tempArmorArray[53] = scripted_ents.Get("arccw_ammo_smg1_grenade")
	tempArmorArray[54] = scripted_ents.Get("arccw_ammo_smg1_grenade_large")
	tempArmorArray[55] = scripted_ents.Get("arccw_ammo_buckshot")
	tempArmorArray[56] = scripted_ents.Get("arccw_ammo_buckshot_large")
	tempArmorArray[57] = scripted_ents.Get("arccw_ammo_sniper")
	tempArmorArray[58] = scripted_ents.Get("arccw_ammo_sniper_large")
	tempArmorArray[59] = scripted_ents.Get("arccw_ammo_plinking")
	tempArmorArray[60] = scripted_ents.Get("arccw_ammo_plinking_large")

	-- Any weapon in this array cannot be sold. Put any starting equipment here.

	sellBlacklist[1] = {"arccw_go_melee_knife"}
	sellBlacklist[2] = {"arccw_go_knife_bowie"}
	sellBlacklist[3] = {"arccw_go_knife_butterfly"}
	sellBlacklist[4] = {"arccw_go_knife_t"}
	sellBlacklist[5] = {"arccw_go_knife_karambit"}
	sellBlacklist[6] = {"arccw_go_knife_m9bayonet"}
	sellBlacklist[7] = {"arccw_go_knife_ct"}
	sellBlacklist[8] = {"arccw_go_knife_stiletto"}
	sellBlacklist[9] = {"arccw_eap_lebedev"}
	sellBlacklist[10] = {"arccw_eap_vp70"}
	sellBlacklist[11] = {"arccw_eft_1911"}
	sellBlacklist[12] = {"arccw_go_glock"}
	sellBlacklist[13] = {"arccw_go_cz75"}
	sellBlacklist[14] = {"arccw_go_fiveseven"}
	sellBlacklist[15] = {"arccw_go_usp"}
	sellBlacklist[16] = {"arccw_go_tec9"}
	sellBlacklist[17] = {"arccw_go_p2000"}
	sellBlacklist[18] = {"arccw_go_p250"}
	sellBlacklist[19] = {"arccw_go_m9"}
	sellBlacklist[20] = {"arccw_go_nade_incendiary"}
	sellBlacklist[21] = {"arccw_go_nade_frag"}
	sellBlacklist[22] = {"arccw_go_nade_flash"}
	sellBlacklist[23] = {"arccw_go_nade_smoke"}
	sellBlacklist[24] = {"arccw_go_nade_molotov"}
	sellBlacklist[25] = {"arccw_go_nade_knife"}

	-- Temporary array created. This next section will sort the guns by cost, so guns higher to the top will hopefully be better. This is convenient.
	-- The sort function takes the fourth value of all tempWeaponsArray indexes (the rouble count) and sorts by them from greatest to lowest.

	-- If you want it in descending order instead of ascending, change the > to a <. If you want it to sort by level requirement, change the [4] to [5].
	-- Do you want it sorted alphabetically? Too bad!

	table.sort( tempWeaponsArray, function(a, b) return a[4] > b[4] end )

	-- I think thats it

	weaponsArr = tempWeaponsArray
	entsArr = tempArmorArray

end

-- Disable the context menu.
function GM:ContextMenuOpen()
  return false
end

-- Disable Spawn Menu and show the extract list when the bind is pressed.
--function GM:SpawnMenuOpen()
  --RunConsoleCommand("efgm_extract_list")
  --return false
--end

-- This is where the console commands are ran when a client joins a game running the gamemode.

--Anti-Bunnyhopping

RunConsoleCommand("vk_enabled", "1")
RunConsoleCommand("vk_suppressor", "1")
RunConsoleCommand("vk_speedlimit", "1")

--Day/Night System

RunConsoleCommand("atmos_dnc_length_day", "300")
RunConsoleCommand("atmos_dnc_length_night", "300")
RunConsoleCommand("atmos_weather_length", "300")
RunConsoleCommand("atmos_weather_chance", "20")
RunConsoleCommand("atmos_weather_delay", "300")
RunConsoleCommand("atmos_weather_lighting", "1")

--Compass Configuration

RunConsoleCommand("mcompass_enabled", "1")
RunConsoleCommand("mcompass_style", "2")
RunConsoleCommand("mcompass_xposition", "0.50")
RunConsoleCommand("mcompass_yposition", "0")
RunConsoleCommand("mcompass_ratio", "1.75")
RunConsoleCommand("mcompass_spacing", "5")

--Tarkov Hud Configuration

RunConsoleCommand("tarkovhud_hp_colored", "1")
RunConsoleCommand("tarkovhud_autohide_hp", "0")
RunConsoleCommand("tarkovhud_autohide_stamina", "0")
RunConsoleCommand("tarkovhud_blur", "1")
RunConsoleCommand("tarkovhud_blur_neardeath", "1")

--Realistic Fall Damage

RunConsoleCommand("mp_falldamage", "1")

--Damage Slow Config

RunConsoleCommand("stoppower_dmg_mult", "0.05")
RunConsoleCommand("stoppower_minimum_speed_mult", "0.70")
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

RunConsoleCommand("cl_pomer_text", "(You Died)")

--Loot Rings/Attachment Menu Configuration

RunConsoleCommand("cl_vmanip_pickups_halo", "1")

--Dynamic Height

RunConsoleCommand("sv_ec2_dynamicheight", "0")
RunConsoleCommand("sv_ec2_dynamicheight_min", "42")
RunConsoleCommand("sv_ec2_dynamicheight_max", "64")

--GWS Config

RunConsoleCommand("sv_drop_loot_on_death", "1")
RunConsoleCommand("sv_gws_flashlight_disable", "1")
RunConsoleCommand("sv_gws_adventure_mod", "0")
RunConsoleCommand("sv_spawns_deathtimer", "15")

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
RunConsoleCommand("arccw_bullet_gravity", "600.00")
RunConsoleCommand("arccw_bullet_imaginary", "1")
RunConsoleCommand("arccw_bullet_lifetime", "10.00")
RunConsoleCommand("arccw_bullet_velocity", "1.00")
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
RunConsoleCommand("arccw_mult_crouchdisp", "0.60")
RunConsoleCommand("arccw_mult_crouchrecoil", "0.60")
RunConsoleCommand("arccw_mult_damage", "0.90")
RunConsoleCommand("arccw_mult_defaultammo", "3")
RunConsoleCommand("arccw_mult_heat", "1.00")
RunConsoleCommand("arccw_mult_hipfire", "1.00")
RunConsoleCommand("arccw_mult_infiniteammo", "0")
RunConsoleCommand("arccw_mult_malfunction", "1.75")
RunConsoleCommand("arccw_mult_movedisp", "0.50")
RunConsoleCommand("arccw_mult_penetration", "1.00")
RunConsoleCommand("arccw_mult_range", "1.00")
RunConsoleCommand("arccw_mult_recoil", "1.25")
RunConsoleCommand("arccw_mult_reloadtime", "1.25")
RunConsoleCommand("arccw_mult_shootwhilesprinting", "0")
RunConsoleCommand("arccw_mult_sighttime", "1.25")
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
RunConsoleCommand("arccw_workbench_halo", "1")
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