local Menu

local isSellMenu
local clientPlayer
local seller

local stashClient

local stashTable

net.Receive("SellMenuTable",function (len, ply)

	tempTable = net.ReadTable()

	clientPlayer = tempTable[1]
	seller = tempTable[2]
	
end)

net.Receive("OpenStashGUI",function (len, ply)

	print("got message to open stash")

	tempTable = net.ReadTable()

	stashClient = tempTable[1]

	MenuInit()
	DoInventory()

end)

net.Receive("CloseStashGUI",function (len, ply)

	StashMenu:Close()
	
end)

net.Receive("SendStash",function (len, ply)

	stashTable = net.ReadTable()

	ShowStashTable()

end)

net.Receive("StashMenuReload", function (len, ply) ResetMenu() end)

-- This sets the percent of money you will earn from selling a weapon.
-- Just because you can set it above 1, does not mean you should.
-- 0.6 seems like a good starting point.

local sellPriceMultiplier = 0.40

weaponsArr = {}
entsArr = {}
sellBlacklist = {}

function GM:Initialize()

	isSellMenu = false
	clientPlayer = nil

	-- Creating a temporary array to sort through for the actual array seen in the shop

	local tempWeaponsArray = {}

	tempWeaponsArray[1] = {"models/weapons/arccw/dm1973/c_dmi_bm92f_auto.mdl", "arccw_dmi_b92f_auto", "92F Auto Pistol", 13005, "10"}
	tempWeaponsArray[2] = {"models/weapons/arccw/dm1973/w_arccw_dmi_c7a2.mdl", "arccw_dmi_c7a2_inftry", "C7A2", 16955, "14"}
	tempWeaponsArray[3] = {"models/weapons/arccw/strellray/w_hk416_a7_battle.mdl", "arccw_hk416", "HK416", 18370, "16"}
	tempWeaponsArray[4] = {"models/weapons/arccw/w_zz_mg24_tp.mdl", "arccw_dp28", "DP-28 HLMG", 21370, "17"}
	tempWeaponsArray[5] = {"models/weapons/arccw/dm1973/w_dmi_sig_mpx.mdl", "arccw_sigmpx_combat", "SIG MPX 9mm", 12410, "11"}
	tempWeaponsArray[6] = {"models/weapons/arc_eft_aks74u/eft_aks74u/models/c_eft_aks74u.mdl", "arccw_eft_aks74u", "AKS-74u", 9980, "7"}
	tempWeaponsArray[7] = {"models/weapons/arc_eft_1911/c_eft_1911/models/c_eft_1911.mdl", "arccw_eft_1911", "M1911", 4140, "3"}
	tempWeaponsArray[8] = {"models/weapons/arc_eft_mp5/w_eft_mp5/models/w_eft_mp5.mdl", "arccw_eft_mp5", "MP5", 10995, "9"}
	tempWeaponsArray[9] = {"models/weapons/arc_eft_mp5/w_eft_mp5_std/models/w_eft_mp5_std.mdl", "arccw_eft_mp5sd", "MP5SD", 9995, "8"}
	tempWeaponsArray[10] = {"models/weapons/arc_eft_mp7/eft_mp7/models/c_eft_mp7.mdl", "arccw_eft_mp7", "MP7A1", 13195, "10"}
	tempWeaponsArray[11] = {"models/weapons/arc_eft_ppsh/c_eft_ppsh/models/c_eft_ppsh.mdl", "arccw_eft_ppsh", "PPSH-41", 8440, "5"}
	tempWeaponsArray[12] = {"models/weapons/arc_eft_t5000/eft_t5000/models/c_eft_t5000.mdl", "arccw_eft_t5000", "T-5000", 18050, "13"}
	tempWeaponsArray[13] = {"models/weapons/arc_eft_ump/eft_ump/models/c_eft_ump.mdl", "arccw_eft_ump", "UMP-45", 10050, "6"}
	tempWeaponsArray[14] = {"models/weapons/arccw/eap/c_aek971.mdl", "arccw_eap_aek", "AEK-971", 17120, "15"}
	tempWeaponsArray[15] = {"models/weapons/arccw/eap/c_brenten.mdl", "arccw_eap_brenten", "Bren Ten Pistol", 6010, "5"}
	tempWeaponsArray[16] = {"models/weapons/arccw/eap/c_csls5.mdl", "arccw_eap_csls5", "CS/LS5 SMG", 10510, "8"}
	tempWeaponsArray[17] = {"models/weapons/arccw/eap/c_fmg9.mdl", "arccw_eap_fmg9", "FMG-9", 13080, "9"}
	tempWeaponsArray[18] = {"models/weapons/arccw/eap/c_groza.mdl", "arccw_eap_groza", "OTs-14 Groza", 13580, "10"}
	tempWeaponsArray[19] = {"models/weapons/arccw/eap/c_lebedev.mdl", "arccw_eap_lebedev", "PL-15 Lebedev Pistol", 4630, "3"}
	tempWeaponsArray[20] = {"models/weapons/arccw/eap/c_spectre.mdl", "arccw_eap_spectre", "Spectre M4", 11010, "8"}
	tempWeaponsArray[21] = {"models/weapons/arccw/eap/c_stg44.mdl", "arccw_eap_stg44", "StG-44", 13100, "10"}
	tempWeaponsArray[22] = {"models/weapons/arccw/eap/c_usas.mdl", "arccw_eap_usas", "USAS-12", 27510, "20"}
	tempWeaponsArray[23] = {"models/weapons/arccw/eap/c_vp70.mdl", "arccw_eap_vp70", "VP70", 5005, "4"}
	tempWeaponsArray[24] = {"models/weapons/arccw/eap/c_xm29.mdl", "arccw_eap_xm29", "XM29", 18005, "15"}
	tempWeaponsArray[25] = {"models/weapons/arccw/slogkot/c_altor.mdl", "arccw_slog_altor", "Altor Pistol", 5005, "5"}
	tempWeaponsArray[26] = {"models/weapons/arccw/fml/w_fatcry5_arc.mdl", "arccw_fml_blast_fc5_arc", "AR-C", 15005, "13"}
	tempWeaponsArray[27] = {"models/weapons/arccw/kriss/w_kriss.mdl", "arccw_krissvector", "Kriss Vector", 20005, "15"}
	tempWeaponsArray[28] = {"models/weapons/c_tderp_asval2.mdl", "arccw_asval", "AS VAL", 17990, "13"}
	tempWeaponsArray[29] = {"models/weapons/arccw/fml/w_pflio_lynx.mdl", "arccw_mifl_lynx", "CQ300", 18420, "14"}
	tempWeaponsArray[30] = {"models/weapons/arccw/fml/w_tarkov_mdr.mdl", "arccw_fml_eft_mdr", "MDR 7.62", 19005, "14"}
	tempWeaponsArray[31] = {"models/weapons/arccw/mifl/sketchfab/c_msd9.mdl", "arccw_mifl_mds9", "MDS-9", 6200, "5"}
	tempWeaponsArray[32] = {"models/weapons/w_rif_pindadss2.mdl", "arccw_blast_pindadss2", "Pindad SS2-V1", 18200, "14"}
	tempWeaponsArray[33] = {"models/weapons/arccw/fml/w_scar_sd.mdl", "arccw_fml_scarsd", "SCAR-SD", 23105, "17"}
	tempWeaponsArray[34] = {"models/weapons/arccw_go/v_eq_taser.mdl", "arccw_go_taser", "Advanced Taser M26", 3333, "3"}
	tempWeaponsArray[35] = {"models/weapons/arccw_go/v_eq_incendiarygrenade.mdl", "arccw_go_nade_incendiary", "AN/M14 Thermite Grenade", 2500, "3"}
	tempWeaponsArray[36] = {"models/weapons/arccw_go/v_eq_fraggrenade.mdl", "arccw_go_nade_frag", "M67 Frag Grenade", 2500, "3"}
	tempWeaponsArray[37] = {"models/weapons/arccw_go/v_eq_flashbang.mdl", "arccw_go_nade_flash", "M84 Stun Grenade", 2500, "3"}
	tempWeaponsArray[38] = {"models/weapons/arccw_go/v_eq_smokegrenade.mdl", "arccw_go_nade_smoke", "M5210 Smoke Grenade", 2500, "3"}
	tempWeaponsArray[39] = {"models/weapons/arccw_go/v_eq_molotov.mdl", "arccw_go_nade_molotov", "Molotov Cocktail", 2500, "3"}
	tempWeaponsArray[40] = {"models/weapons/arccw_go/v_eq_throwingknife.mdl", "arccw_go_nade_knife", "Throwing Knife", 2500, "3"}
	tempWeaponsArray[41] = {"models/weapons/c_csgo_flashbang.mdl", "weapon_csgo_flashbang", "M84 MK2 Flash Grenade", 2500, "3"}
	tempWeaponsArray[42] = {"models/weapons/arccw_go/v_shot_m1014.mdl", "arccw_go_m1014", "M1014 SG", 11510, "10"}
	tempWeaponsArray[43] = {"models/weapons/arccw_go/v_mach_m249para.mdl", "arccw_go_m249para", "M249 SAW LMG", 14000, "12"}
	tempWeaponsArray[44] = {"models/weapons/arccw_go/v_shot_mag7.mdl", "arccw_go_mag7", "MAG-7 SG", 13333, "13"}
	tempWeaponsArray[45] = {"models/weapons/arccw_go/v_shot_870.mdl", "arccw_go_870", "Model 870 SG", 8905, "8"}
	tempWeaponsArray[46] = {"models/weapons/arccw_go/v_mach_negev.mdl", "arccw_go_negev", "Negev LMG", 12000, "10"}
	tempWeaponsArray[47] = {"models/weapons/arccw_go/v_shot_nova.mdl", "arccw_go_nova", "Supernova SG", 11250, "10"}
	tempWeaponsArray[48] = {"models/weapons/arccw_go/v_pist_cz75.mdl", "arccw_go_cz75", "CZ-75", 4790, "4"}
	tempWeaponsArray[49] = {"models/weapons/arccw_go/v_pist_deagle.mdl", "arccw_go_deagle", "Desert Eagle", 6005, "5"}
	tempWeaponsArray[50] = {"models/weapons/arccw_go/v_pist_fiveseven.mdl", "arccw_go_fiveseven", "Five-seveN", 4250, "3"}
	tempWeaponsArray[51] = {"models/weapons/arccw_go/v_pist_glock.mdl", "arccw_go_glock", "Glock 17", 4700, "4"}
	tempWeaponsArray[52] = {"models/weapons/arccw_go/v_pist_m9.mdl", "arccw_go_m9", "M92FS", 4250, "3"}
	tempWeaponsArray[53] = {"models/weapons/arccw_go/v_pist_r8.mdl", "arccw_go_r8", "Model 327 R8", 6005, "5"}
	tempWeaponsArray[54] = {"models/weapons/arccw_go/v_pist_p2000.mdl", "arccw_go_p2000", "P2000", 4250, "3"}
	tempWeaponsArray[55] = {"models/weapons/arccw_go/v_pist_p250.mdl", "arccw_go_p250", "P250", 4700, "4"}
	tempWeaponsArray[56] = {"models/weapons/arccw_go/v_pist_sw29.mdl", "arccw_go_sw29", "S&W M29", 5250, "4"}
	tempWeaponsArray[57] = {"models/weapons/arccw_go/v_pist_tec9.mdl", "arccw_go_tec9", "TEC-9", 5250, "4"}
	tempWeaponsArray[58] = {"models/weapons/arccw_go/v_pist_usp.mdl", "arccw_go_usp", "USP-45", 4700, "4"}
	tempWeaponsArray[59] = {"models/weapons/arccw_go/v_rif_ace.mdl", "arccw_go_ace", "ACE 23", 15920, "11"}
	tempWeaponsArray[60] = {"models/weapons/arccw_go/v_rif_ak47.mdl", "arccw_go_ak47", "AKM", 13905, "10"}
	tempWeaponsArray[61] = {"models/weapons/arccw_go/v_rif_car15.mdl", "arccw_go_ar15", "AR-15", 11995, "8"}
	tempWeaponsArray[62] = {"models/weapons/arccw_go/v_rif_aug.mdl", "arccw_go_aug", "AUG A3", 14250, "12"}
	tempWeaponsArray[63] = {"models/weapons/arccw_go/v_snip_awp.mdl", "arccw_go_awp", "AWSM SR", 17995, "16"}
	tempWeaponsArray[64] = {"models/weapons/arccw_go/v_rif_fnfal.mdl", "arccw_go_fnfal", "FAL", 17250, "14"}
	tempWeaponsArray[65] = {"models/weapons/arccw_go/v_rif_famas.mdl", "arccw_go_famas", "FAMAS G1", 13995, "11"}
	tempWeaponsArray[66] = {"models/weapons/arccw_go/v_rif_g3.mdl", "arccw_go_g3", "G3", 18500, "16"}
	tempWeaponsArray[67] = {"models/weapons/arccw_go/v_rif_galil_ar.mdl", "arccw_go_galil_ar", "Galil AR", 18500, "16"}
	tempWeaponsArray[68] = {"models/weapons/arccw_go/v_rif_car15.mdl", "arccw_go_m16a2", "M16A2", 16550, "14"}
	tempWeaponsArray[69] = {"models/weapons/arccw_go/v_rif_m4a1.mdl", "arccw_go_m4", "M4A1", 17110, "14"}
	tempWeaponsArray[70] = {"models/weapons/arccw_go/v_rif_scar.mdl", "arccw_go_scar", "SCAR-H", 17600, "15"}
	tempWeaponsArray[71] = {"models/weapons/arccw_go/v_rif_sg556.mdl", "arccw_go_sg556", "SIG SG556", 16640, "13"}
	tempWeaponsArray[72] = {"models/weapons/arccw_go/v_snip_ssg08.mdl", "arccw_go_ssg08", "SSG08 SR", 15625, "13"}
	tempWeaponsArray[73] = {"models/weapons/arccw_go/v_smg_mac10.mdl", "arccw_go_mac10", "MAC-10", 7600, "6"}
	tempWeaponsArray[74] = {"models/weapons/arccw_go/v_smg_mp5.mdl", "arccw_go_mp5", "MP5A2", 8240, "7"}
	tempWeaponsArray[75] = {"models/weapons/arccw_go/v_smg_mp7.mdl", "arccw_go_mp7", "MP7A2", 8590, "7"}
	tempWeaponsArray[76] = {"models/weapons/arccw_go/v_smg_mp9.mdl", "arccw_go_mp9", "MP9N", 8590, "8"}
	tempWeaponsArray[77] = {"models/weapons/arccw_go/v_smg_p90.mdl", "arccw_go_p90", "P90 TR", 14990, "10"}
	tempWeaponsArray[78] = {"models/weapons/arccw_go/v_smg_bizon.mdl", "arccw_go_bizon", "PP-19 Bizon-2", 8750, "8"}
	tempWeaponsArray[79] = {"models/weapons/arccw_go/v_smg_ump45.mdl", "arccw_go_ump", "UMP-9mm", 9360, "9"}
	tempWeaponsArray[80] = {"models/weapons/arccw/midnightwolf/arccw_midnightwolf_acr.mdl", "arccw_midnightwolf_acr", "ACR", 16420, "14"}
	tempWeaponsArray[81] = {"models/weapons/arccw/c_xm8.mdl", "midnights_gso_xm8", "HK XM8", 18920, "17"}
	tempWeaponsArray[82] = {"models/weapons/arccw/midnightwolf/type20.mdl", "arccw_midnightwolf_type20", "Type 20", 17880, "15"}
	tempWeaponsArray[83] = {"models/viper/mw/weapons/w_725_mammaledition.mdl", "arccw_725", "Citori 725 SG", 8950, "7"}
	tempWeaponsArray[84] = {"models/weapons/arccw/mifl/fas2/c_g36c.mdl", "arccw_mifl_fas2_g36c", "G36c", 14445, "13"}
	tempWeaponsArray[85] = {"models/viper/mw/weapons/kilo433_mammaledition.mdl", "arccw_kilo141", "HK433", 15690, "14"}
	tempWeaponsArray[86] = {"models/weapons/w_mcxvirtus.mdl", "arccw_mcx", "MCX Virtus SBR", 17180, "15"}
	tempWeaponsArray[87] = {"models/weapons/arccw/fml/mw19/w_mk2_k.mdl", "arccw_fml_mk2k", "MK2-K DMR", 11050, "8"}
	tempWeaponsArray[88] = {"models/weapons/cod_mw2019/c_sg552_mammaledition.mdl", "arccw_grau", "SG 552 Commando", 13005, "13"}
	tempWeaponsArray[89] = {"models/weapons/arccw/c_ud_glock.mdl", "arccw_ud_glock", "Glock 22", 6005, "5"}
	tempWeaponsArray[90] = {"models/weapons/arccw/c_ud_m16.mdl", "arccw_ud_m16", "M16A3", 16995, "14"}
	tempWeaponsArray[91] = {"models/weapons/arccw/c_ud_m1014.mdl", "arccw_ud_m1014", "M4 Super 90 SG", 12995, "12"}
	tempWeaponsArray[92] = {"models/weapons/arccw/c_ud_m79.mdl", "arccw_ud_m79", "M79 Grenade Launcher", 22555, "20"}
	tempWeaponsArray[93] = {"models/weapons/arccw/c_ud_mini14.mdl", "arccw_ud_mini14", "Mini-14", 16420, "14"}
	tempWeaponsArray[94] = {"models/weapons/arccw/c_ud_870.mdl", "arccw_ud_870", "Remington 870", 10240, "9"}
	tempWeaponsArray[95] = {"models/weapons/arccw/c_ud_uzi.mdl", "arccw_ud_uzi", "Uzi", 11040, "8"}
	tempWeaponsArray[96] = {"models/weapons/arccw/w_arccw_smg0818.mdl", "arccw_ww1_smg0818", "Maxim SMG LMG", 27500, "22"}
	tempWeaponsArray[97] = {"models/weapons/arccw/mifl/fas2/c_ak47.mdl", "arccw_mifl_fas2_ak47", "AKM", 17005, "15"}
	tempWeaponsArray[98] = {"models/weapons/arccw/mifl/fas2/c_famas.mdl", "arccw_mifl_fas2_famas", "FAMAS", 16990, "14"}
	tempWeaponsArray[99] = {"models/weapons/arccw/mifl/fas2/c_g3.mdl", "arccw_mifl_fas2_g3", "G3A3", 16310, "14"}
	tempWeaponsArray[100] = {"models/weapons/arccw/mifl/fas2/c_ks23.mdl", "arccw_mifl_fas2_ks23", "KS-23", 13005, "13"}
	tempWeaponsArray[101] = {"models/weapons/arccw/mifl/fas2/c_m24.mdl", "arccw_mifl_fas2_m24", "M24 SR", 18900, "15"}
	tempWeaponsArray[102] = {"models/weapons/arccw/mifl/fas2/c_m3s90.mdl", "arccw_mifl_fas2_m3", "M3 Super 90", 14505, "14"}
	tempWeaponsArray[103] = {"models/weapons/arccw/mifl/fas2/c_m82.mdl", "arccw_mifl_fas2_m82", "M82 SR", 20999, "20"}
	tempWeaponsArray[104] = {"models/weapons/arccw/mifl/fas2/c_mac11.mdl", "arccw_mifl_fas2_mac11", "MAC-11", 8100, "6"}
	tempWeaponsArray[105] = {"models/weapons/arccw/mifl/fas2_custom/c_m26.mdl", "arccw_fml_fas2_custom_mass26", "MASS-26 SG", 14895, "15"}
	tempWeaponsArray[106] = {"models/weapons/arccw/mifl/fas2/c_minimi.mdl", "arccw_mifl_fas2_minimi", "Minimi", 19995, "20"}
	tempWeaponsArray[107] = {"models/weapons/arccw/mifl/fas2/c_ragingbull.mdl", "arccw_mifl_fas2_ragingbull", "Raging Bull Revolver", 7020, "7"}
	tempWeaponsArray[108] = {"models/weapons/arccw/mifl/fas2/c_rpk.mdl", "arccw_mifl_fas2_rpk", "RPK47", 14765, "14"}
	tempWeaponsArray[109] = {"models/weapons/arccw/mifl/fas2/c_sg552.mdl", "arccw_mifl_fas2_sg55x", "SG552", 15490, "14"}
	tempWeaponsArray[110] = {"models/weapons/arccw/mifl/fas2/c_sr25.mdl", "arccw_mifl_fas2_sr25", "SR-25", 17420, "16"}
	tempWeaponsArray[111] = {"models/weapons/arccw/mifl/fas2/c_toz34.mdl", "arccw_mifl_fas2_toz34", "TOZ-34", 12690, "12"}
	tempWeaponsArray[112] = {"models/weapons/arccw/c_claymorelungemine.mdl", "arccw_claymorelungemine", "Claymore Lunge Mine", 5555, "5"}

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
	sellBlacklist[9] = {"weapon_concussion_nade"}

	-- Temporary array created. This next section will sort the guns by cost, so guns higher to the top will hopefully be better. This is convenient.
	-- The sort function takes the fourth value of all tempWeaponsArray indexes (the rouble count) and sorts by them from greatest to lowest.

	-- If you want it in descending order instead of ascending, change the > to a <. If you want it to sort by level requirement, change the [4] to [5].
	-- Do you want it sorted alphabetically? Too bad!

	table.sort( tempWeaponsArray, function(a, b) return a[4] > b[4] end )

	-- I think thats it

	weaponsArr = tempWeaponsArray
	entsArr = tempArmorArray

end

function gameShopMenu()

	-- This part just makes sure the client is the one viewing the hud. This is so some logic can work, it's complicated.

	local client = LocalPlayer()
	
	if not client:Alive() then return end

	if clientPlayer != nil then
		isSellMenu = true
		--print (clientPlayer:GetName().." is not nil")
	end

	-- Moving on

	if (Menu == nil) then
		Menu = vgui.Create("DFrame")
		Menu:SetSize(860, 1080)
		Menu:Center()
		Menu:SetTitle("Escape From Garry's Mod Menu")
		Menu:SetDraggable(false)
		Menu:ShowCloseButton(false)
		Menu:SetDeleteOnClose(false)
		Menu.Paint = function()
			surface.SetDrawColor(90, 90, 90, 255)
			surface.DrawRect(0, 0, Menu:GetWide(), Menu:GetTall())
			
			surface.SetDrawColor(40, 40, 40, 255)
			surface.DrawRect(0, 24, Menu:GetWide(), 1)
		end
	
		addButtons(Menu, isSellMenu, clientPlayer)

		gui.EnableScreenClicker(true)
	else
		Menu:Remove()
		Menu = nil
		gui.EnableScreenClicker(false)

		clientPlayer = nil
		isSellMenu = false
		seller = nil
	end
end
concommand.Add("open_game_menu", gameShopMenu)

--Button Code
function addButtons(Menu, sellMenuBool, ply)

	--print("isSellMenu is "..tostring(isSellMenu))

	local playerButton = vgui.Create("DButton")
	playerButton:SetParent(Menu)
	playerButton:SetText("")
	playerButton:SetSize(100, 50)
	playerButton:SetPos(0, 25)
	playerButton.Paint = function()
		--Color of entire button
		surface.SetDrawColor(50, 50, 50, 255)
		surface.DrawRect(0, 0, playerButton:GetWide(), playerButton:GetTall())
		
		--Draw bottom and Right borders
		surface.SetDrawColor(40, 40, 40, 255)
		surface.DrawRect(0, 49, playerButton:GetWide(), 1)
		surface.DrawRect(99, 0, 1, playerButton:GetTall())
		
		--Draw/write text
		draw.DrawText(LocalPlayer():GetName(), "DermaLarge", playerButton:GetWide() / 2.1, 10, Color(255, 255, 255, 255), 1)
	end
	playerButton.DoClick = function(playerButton)
		local playerPanel = Menu:Add("PlayerPanel")
		
		playerPanel.Paint = function()
			surface.SetDrawColor(50, 50, 50, 255)
			surface.DrawRect(0, 0, playerPanel:GetWide(), playerPanel:GetTall())
			surface.SetTextColor(255, 255, 255, 255)
			
			-- Player Name
			surface.SetFont("Trebuchet24")
			surface.SetTextPos(5, 0)
			surface.DrawText(LocalPlayer():GetName())
			
			-- Stats Text
			surface.SetFont("Trebuchet24")
			surface.SetTextPos(5, 320)
			surface.DrawText("Your Stats")
			
			-- Player EXP and level
			local expToLevel = (LocalPlayer():GetNWInt("playerLvl") * 110) * 5.15
			
			surface.SetFont("Default")
			surface.SetTextPos(8, 35)
			surface.SetTextColor(228, 255, 0, 255)
			surface.DrawText("Level "..LocalPlayer():GetNWInt("playerLvl"))
			
			surface.SetTextPos(58, 35)
			surface.SetTextColor(0, 255, 209 , 255)
			surface.DrawText("Experience "..LocalPlayer():GetNWInt("playerExp").."/"..expToLevel)
			
			-- Balance
			surface.SetTextPos(8, 55)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Roubles/Balance: "..LocalPlayer():GetNWInt("playerMoney"))
			
			-- Stats (Kills)
			surface.SetTextPos(8, 350)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Total Kills: "..LocalPlayer():GetNWInt("playerKills"))
			
			-- Stats (Deaths)
			surface.SetTextPos(8, 370)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Total Deaths: "..LocalPlayer():GetNWInt("playerDeaths"))
			
			-- Stats (KDR)
			surface.SetTextPos(8, 390)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Kill/Death Ratio: "..LocalPlayer():GetNWInt("playerKDR"))
			
			-- Stats (Total Earned)
			surface.SetTextPos(8, 410)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Total Roubles Earned: "..LocalPlayer():GetNWInt("playerTotalEarned"))
			
			-- Stats (Total Roubles From Kills)
			surface.SetTextPos(8, 430)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Total Roubles Earned From Kills: "..LocalPlayer():GetNWInt("playerTotalEarnedKill"))
			
			-- Stats (Total Roubles From Selling)
			surface.SetTextPos(8, 450)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Total Roubles Earned From Selling: "..LocalPlayer():GetNWInt("playerTotalEarnedSell"))
			
			-- Stats (Total Experience Gained)
			surface.SetTextPos(252, 350)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Total Experience Gained: "..LocalPlayer():GetNWInt("playerTotalXpEarned"))
			
			-- Stats (Total Experience Gained From Killing)
			surface.SetTextPos(252, 370)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Total Experience Gained From Kills: "..LocalPlayer():GetNWInt("playerTotalXpEarnedKill"))
			
			-- Stats (Total Experience Gained From Exploration)
			surface.SetTextPos(252, 390)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Total Experience Gained From Exploration: "..LocalPlayer():GetNWInt("playerTotalXpEarnedExplore"))
			
			-- Stats (Total Money Spent)
			surface.SetTextPos(252, 410)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Total Money Spent: "..LocalPlayer():GetNWInt("playerTotalMoneySpent"))
			
			-- Stats (Total Money Spent On Weapons)
			surface.SetTextPos(252, 430)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Total Money Spent On Weapons: "..LocalPlayer():GetNWInt("playerTotalMoneySpentWep"))
			
			-- Stats (Total Money Spent On Ammo/Armor)
			surface.SetTextPos(252, 450)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Total Money Spent On Ammo/Armor: "..LocalPlayer():GetNWInt("playerTotalMoneySpentItem"))
			
			-- Stats (Deaths By Suicide)
			surface.SetTextPos(496, 350)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Total Deaths By Suicide: "..LocalPlayer():GetNWInt("playerDeathsSuicide"))
			
			-- Stats (Damage Given)
			surface.SetTextPos(496, 370)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Damage Given: "..LocalPlayer():GetNWInt("playerDamageGiven"))
			
			-- Stats (Damage Recieved)
			surface.SetTextPos(496, 390)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Damage Recieved: "..LocalPlayer():GetNWInt("playerDamageRecieved"))
			
			-- Stats (Damage Healed)
			surface.SetTextPos(496, 410)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Damage Healed: "..LocalPlayer():GetNWInt("playerDamageHealed"))
			
			-- Stats (Items Picked Up)
			surface.SetTextPos(496, 430)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Weapons Picked Up: "..LocalPlayer():GetNWInt("playerItemsPickedUp"))
			
			-- Stats (Distance Travelled)
			surface.SetTextPos(496, 450)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Distance Travelled: "..LocalPlayer():GetNWInt("playerDistance"))
			
			-- Help Section
			surface.SetTextPos(8, 85)
			surface.SetTextColor(155, 255, 0, 255)
			surface.DrawText("Help:")
			
			-- Help Text One
			surface.SetTextPos(8, 100)
			surface.SetTextColor(255, 255, 255, 255)
			surface.DrawText("Welcome to Escape From Garry's Mod! This gamemode is an extremely punishing PVP shooter where you")
			
			-- Help Text Two
			surface.SetTextPos(8, 110)
			surface.SetTextColor(255, 255, 255, 255)
			surface.DrawText("can either fight others or spend time looting and building up your EXP and roubles.")
			
			-- Help Text Three
			surface.SetTextPos(8, 130)
			surface.SetTextColor(255, 255, 255, 255)
			surface.DrawText("In most POI's, you can find a variety of weapons, armor, and spending cash to buy these items yourself.")
			
			-- Help Text Four
			surface.SetTextPos(8, 140)
			surface.SetTextColor(255, 255, 255, 255)
			surface.DrawText("When you die, you will drop all of your loot, but keep your EXP and lose no money. Each kill gives you")
			
			-- Help Text Five
			surface.SetTextPos(8, 150)
			surface.SetTextColor(255, 255, 255, 255)
			surface.DrawText("a chunk of experience and 1000 roubles. Levels will unlock certain items in the shop while roubles")
			
			-- Help Text Six
			surface.SetTextPos(8, 160)
			surface.SetTextColor(255, 255, 255, 255)
			surface.DrawText("are used to purchased these items.")
			
			-- Help Text Seven
			surface.SetTextPos(8, 180)
			surface.SetTextColor(255, 255, 255, 255)
			surface.DrawText("All projectile based weapons will have bullet drop, bullet velocity, penetration, and richochet mechanics.")
			
			-- Help Text Eight
			surface.SetTextPos(8, 190)
			surface.SetTextColor(255, 255, 255, 255)
			surface.DrawText("You can press your menu bind (default key is C) to customize attachments and change the feel of the gun!")

		end
	end

	local playerButton = vgui.Create("DButton")
	playerButton:SetParent(Menu)
	playerButton:SetText("")
	playerButton:SetSize(100, 300)
	playerButton:SetPos(0, 150)
	playerButton.Paint = function()
		--Color of entire button
		surface.SetDrawColor(50, 50, 50, 255)
		surface.DrawRect(0, 0, playerButton:GetWide(), playerButton:GetTall())
	
		
		--Draw/write text
		draw.DrawText("HELP", "DermaLarge", playerButton:GetWide() / 2.1, 125, Color(80, 255, 255, 255), 1)
	end
	playerButton.DoClick = function(playerButton)
		local playerPanel = Menu:Add("PlayerPanel")
		
		playerPanel.Paint = function()
			surface.SetDrawColor(50, 50, 50, 255)
			surface.DrawRect(0, 0, playerPanel:GetWide(), playerPanel:GetTall())
			surface.SetTextColor(255, 255, 255, 255)
			
			-- Player Name
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 0)
			surface.DrawText("Welcome to Escape From Garry's Mod!")

			-- Help Text One
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 50)
			surface.DrawText("For the best experience, input these into your console.")

			-- Help Text Two
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 90)
			surface.DrawText("bind q +alt1    (Let's you lean to the left.)")

			-- Help Text Three
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 120)
			surface.DrawText("bind e +alt2    (Let's you lean to the right.)")

			-- Help Text Four
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 150)
			surface.DrawText("bind o efgm_extract_list    (Check available extract locations.)")

			-- Help Text Five
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 200)
			surface.DrawText("The button on the table at the end of the lobby will put you into")

			-- Help Text Six
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 225)
			surface.DrawText("the raid, if one is ongoing. If no raid is found, one will start.")

			-- Help Text Seven
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 275)
			surface.DrawText("The buttons on the computer terminals will let you access your")

			-- Help Text Eight
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 300)
			surface.DrawText("stash, you can store your weapons/items here safely.")

			-- Help Text Nine
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 350)
			surface.DrawText("The buttons on the wall near the spawn let you sell gear.")

			-- Help Text Ten
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 400)
			surface.DrawText("While in the lobby, press (F4) to access the shop!")

			-- Help Text Eleven
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 425)
			surface.DrawText("You can buy guns, ammo, armor, and other goodies from here!")

			-- Help Text Twelve
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 475)
			surface.DrawText("Your goal in raid is to go in, get loot, fight others, and get out.")

			-- Help Text Thirteen
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 500)
			surface.DrawText("You will lose any gear that you had if you die in a raid.")

			-- Help Text Fourteen
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 525)
			surface.DrawText("You can find loot anywhere around the map.")

			-- Help Text Fifteen
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 575)
			surface.DrawText("To exit a raid and stay alive, you need to find an extract.")

			-- Help Text Fifteen
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 600)
			surface.DrawText("Press (O) if you have the bind to check your list of extracts.")

			-- Help Text Sixteen
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 625)
			surface.DrawText("If you can extract from a raid, you can then put the loot you")
				
			-- Help Text Seventeen
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 650)
			surface.DrawText("found in your stash, or sell it for even more money.")

			-- Help Text Eighteen
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 700)
			surface.DrawText("Raids will last a total of 30 minutes, and you need to get out by")

			-- Help Text Ninteen
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 725)
			surface.DrawText("the end of the raid to survive! Anyone still in the raid when it")

			-- Help Text Twenty
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 750)
			surface.DrawText("ends will be killed, and will lose anything they had.")

			-- Help Text Twenty One
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 800)
			surface.DrawText("Most maps have special events that can be triggered by doing")

			-- Help Text Twenty One
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 825)
			surface.DrawText("specific things around the map!")

			-- Help Text Twenty Two
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 875)
			surface.DrawText("And while teaming is allowed, be aware that you can be")

			-- Help Text Twenty Three
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 900)
			surface.DrawText("betrayed at any time!")

			-- Help Text Twenty Four
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 950)
			surface.DrawText("EFGM is currently in BETA, and we appreciate you for")

			-- Help Text Twenty Five
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 975)
			surface.DrawText("trying it out, if you have any issues, contact us on discord.")

			-- Help Text Twenty Six
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 1020)
			surface.DrawText("          Penial#3298                                          Portator#6582")

		end
	end
	
	local shopButton = vgui.Create("DButton")
	shopButton:SetParent(Menu)
	shopButton:SetText("")
	shopButton:SetSize(100, 50)
	shopButton:SetPos(0, 75)
	shopButton.Paint = function()
		--Color of entire button
		surface.SetDrawColor(50, 50, 50, 255)
		surface.DrawRect(0, 0, shopButton:GetWide(), shopButton:GetTall())
		
		--Draw bottom and Right borders
		surface.SetDrawColor(40, 40, 40, 255)
		surface.DrawRect(0, 49, shopButton:GetWide(), 1)
		surface.DrawRect(99, 0, 1, shopButton:GetTall())
		
		--Draw/write text

		local shopText

		if sellMenuBool == true then shopText = "SELL" else shopText = "SHOP" end

		draw.DrawText(shopText, "DermaLarge", shopButton:GetWide() / 2.1, 10, Color(102, 255, 102, 255), 1)
		
	end

	shopButton.DoClick = function(shopButton)
		local shopPanel = Menu:Add("ShopPanel")	

		local entityCategory

		local entityList

		if sellMenuBool == false then
			entityCategory = vgui.Create("DCollapsibleCategory", shopPanel)
			-- entityCategory:SetPos(0, 0)
			-- entityCategory:SetSize(shopPanel:GetWide(), 100)
			entityCategory:Dock( TOP )
			entityCategory:SetLabel("Ammo/Armor/Crates")

			entityList = vgui.Create("DIconLayout", entityCategory)
			-- entityList:SetPos(0, 20)
			-- entityList:SetSize(entityCategory:GetWide(), entityCategory:GetTall())
			entityList:Dock( TOP )
			entityList:SetSpaceY(5)
			entityList:SetSpaceX(5)
		end
		
		local weaponCategory = vgui.Create("DCollapsibleCategory", shopPanel)
		-- weaponCategory:SetPos(0, 230)
		-- weaponCategory:SetSize(shopPanel:GetWide(), 200)
		weaponCategory:Dock( TOP )
		weaponCategory:SetLabel("Firearms/Weapons")

		local weaponList = vgui.Create("DIconLayout", weaponCategory)
		-- weaponList:SetPos(0, 20)
		-- weaponList:SetSize(weaponCategory:GetWide(), weaponCategory:GetTall())
		weaponList:Dock( TOP )
		weaponList:SetSpaceY(5)
		weaponList:SetSpaceX(5)

		-- testing if this is the shop menu or sell menu, code will be vastly different for each

		if sellMenuBool == true then

			-- if this is the sell menu
			
			for k, v in pairs(weaponsArr) do
	
				for l, b in pairs(sellBlacklist) do
					if v[2] == b[1] then
						return
					end
				end

				-- Creates buttons for the weapons

				local icon = vgui.Create("SpawnIcon", weaponList)
				icon:SetModel(v[1])
				icon:SetToolTip(v[3].."\nSell Price: "..math.Round(v[4]*sellPriceMultiplier, 0))

				-- this lets players visually distinguish items they can sell

				if not clientPlayer:HasWeapon(v[2]) then

					function icon:Paint(w, h)
						draw.RoundedBox( 0, 5, 5, w - 10, h - 10, Color( 40, 40, 40, 255 ) )
						draw.RoundedBox( 0, 8, 8, w - 16, h - 16, Color( 50, 50, 50, 255 ) )
					end

				elseif clientPlayer:HasWeapon(v[2]) then

					function icon:Paint(w, h)
						draw.RoundedBox( 0, 5, 5, w - 10, h - 10, Color( 210, 210, 210, 255 ) )
						draw.RoundedBox( 0, 8, 8, w - 16, h - 16, Color( 230, 230, 230, 255 ) )
					end

				end

				weaponList:Add(icon)

				icon.DoClick = function(icon)
					
					if clientPlayer:HasWeapon(v[2]) then

						local tempTable = {clientPlayer, v[2], math.Round(v[4]*sellPriceMultiplier, 0), v[3]}

						net.Start("SellItem")
						net.WriteTable(tempTable)
						net.SendToServer()

						surface.PlaySound( "common/wpn_select.wav" )
						surface.PlaySound( "items/ammo_pickup.wav" )

						-- draws the icon black after selling

						function icon:Paint(w, h)
							draw.RoundedBox( 0, 5, 5, w - 10, h - 10, Color( 40, 40, 40, 255 ) )
							draw.RoundedBox( 0, 8, 8, w - 16, h - 16, Color( 50, 50, 50, 255 ) )
						end

					elseif not clientPlayer:HasWeapon(v[2]) then
						
						ply:PrintMessage(HUD_PRINTTALK, "You do not have a "..v[3].."!")

						surface.PlaySound( "common/wpn_denyselect.wav" )

					end
				end
			end

		else

			-- if this is the regular shop

			for k, v in pairs(entsArr) do
                local icon = vgui.Create("SpawnIcon", entityList)

                icon:SetModel(v["Model"])
                icon:SetToolTip(v["PrintName"].."\nCost: "..v["Cost"])
                entityList:Add(icon)

                icon.DoClick = function(icon)
                    LocalPlayer():ConCommand("buy_entity "..v["ClassName"])
                end
            end
			
			for k, v in pairs(weaponsArr) do
	
				-- Creates buttons for the weapons
	
				local icon = vgui.Create("SpawnIcon", weaponList)
				icon:SetModel(v[1])
				icon:SetToolTip(v[3].."\nCost: "..v[4].."\nLevel Req: "..v[5])
				weaponList:Add(icon)
	
				icon.DoClick = function(icon)
					LocalPlayer():ConCommand("buy_gun "..v[2])
				end
			end

		end
	end
end

--Player Panel

PANEL = {} --Creates empty panel

function PANEL:Init() -- initializes the panel
	self:SetSize(760, 1080)
	self:SetPos(100, 25)
end

function PANEL:Paint(w, h)
	draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 255))
end

vgui.Register("PlayerPanel", PANEL, "Panel")

--End player panel


--Shop Panel

PANEL = {} --Creates empty panel

function PANEL:Init() -- initializes the panel
	self:SetSize(760, 1080)
	self:SetPos(100, 25)
end

function PANEL:Paint(w, h)
	draw.RoundedBox(0, 0, 0, w, h, Color(125, 125, 125, 255))
end

vgui.Register("ShopPanel", PANEL, "Panel")

--End shop panel

function MenuInit()

	StashMenu = vgui.Create("DFrame")
	StashMenu:SetSize(ScrW(), ScrH())
	StashMenu:Center()
	StashMenu:SetTitle("Stash Inventory")
	StashMenu:SetDraggable(false)
	StashMenu:ShowCloseButton(true)
	StashMenu:SetDeleteOnClose(false)
	StashMenu.Paint = function()
		surface.SetDrawColor(30, 30, 30, 255)
		surface.DrawRect(0, 0, StashMenu:GetWide(), StashMenu:GetTall())
	end

	gui.EnableScreenClicker(true)

	StashMenu.OnClose = function()
		gui.EnableScreenClicker(false)
	end

	inventoryTable = stashClient:GetWeapons()

	local playerInventoryPanel = vgui.Create("DPanel", StashMenu)
	playerInventoryPanel:Dock( LEFT )
	playerInventoryPanel:SetSize(96, 0)

	function playerInventoryPanel:Paint(w, h)

		draw.RoundedBox(0, 0, 0, w, h, Color( 120, 120, 120, 255 ))

	end

	local ammoInventoryPanel = vgui.Create("DPanel", StashMenu)
	ammoInventoryPanel:Dock( LEFT )
	ammoInventoryPanel:SetSize(96, 0)

	function ammoInventoryPanel:Paint(w, h)

		draw.RoundedBox(0, 0, 0, w, h, Color( 120, 120, 120, 255 ))

	end

	local separatePanel = vgui.Create("DPanel", StashMenu)
	separatePanel:Dock( LEFT )
	separatePanel:SetSize(20, 0)

	function separatePanel:Paint(w, h)

		draw.RoundedBox(0, 0, 0, w, h, Color( 30, 30, 30, 255 ))

	end

	local stashPanel = vgui.Create("DPanel", StashMenu)
	stashPanel:Dock( FILL )
	
	function stashPanel:Paint(w, h)

		draw.RoundedBox(0, 0, 0, w, h, Color( 120, 120, 120, 255 ))

	end


	local stashIconLayout = vgui.Create("DIconLayout", stashPanel)
	stashIconLayout:Dock( FILL )
	stashIconLayout:SetSpaceY(5)
	stashIconLayout:SetSpaceX(5)

	local inventoryIconLayout = vgui.Create("DIconLayout", playerInventoryPanel)
	inventoryIconLayout:Dock( FILL )
	inventoryIconLayout:SetSpaceY(5)
	inventoryIconLayout:SetSpaceX(5)

	local ammoIconLayout = vgui.Create("DIconLayout", ammoInventoryPanel)
	ammoIconLayout:Dock( FILL )
	ammoIconLayout:SetSpaceY(5)
	ammoIconLayout:SetSpaceX(5)

	function DoInventory()

		--local avatar = vgui.Create("AvatarImage")

		--avatar:SetSize(96, 96)
		--avatar:SetPos(101, 635)
		--avatar:SetPlayer(LocalPlayer(), 96)

		print("doing inventory")

		for k, v in pairs(stashClient:GetWeapons()) do
			-- Creates buttons for the weapons

			if weapons.Get( v:GetClass() ) == nil then return end

			local weaponInfo = weapons.Get( v:GetClass() )

			-- PrintTable(stashClient:GetWeapons())

			local wepName

			if weaponInfo["TrueName"] == nil then wepName = weaponInfo["PrintName"] else wepName = weaponInfo["TrueName"] end

			local icon = vgui.Create("SpawnIcon", stashIconLayout)
			icon:SetModel(weaponInfo["WorldModel"])
			icon:SetToolTip(wepName)
			icon:SetSize(96, 96)

			function icon:Paint(w, h)
				
				draw.RoundedBox( 0, 0, 0, w, h, Color( 80, 80, 80, 255 ) )
				draw.RoundedBox( 0, 0, 75, w, h - 75, Color( 40, 40, 40, 255 ) )
				draw.SimpleText(wepName, "DermaDefault", w/2, 80, Color(255, 255, 255, 255), 1)

			end

			inventoryIconLayout:Add(icon)
			
			icon.DoClick = function(icon)

				net.Start("PutWepInStash")
				net.WriteString(v:GetClass())
				net.SendToServer()

				icon:Remove()

			end
		end

		PrintTable(LocalPlayer():GetAmmo())

		-- for k, v in pairs(LocalPlayer():GetAmmo()) do
		-- 	-- Creates buttons for the weapons

		-- 	if v == nil then print("ammo is nil") return end

		-- 	local ammoName = game.GetAmmoName(v)
		-- 	local ammoAmount = LocalPlayer():GetAmmoCount(v)

		-- 	if ammoName == nil then print("cannot find ammo name") return end

		-- 	print("starting on ammo icon")

		-- 	local icon = vgui.Create("SpawnIcon", ammoIconLayout)
		-- 	--icon:SetModel(ammoName["WorldModel"])
		-- 	icon:SetToolTip(ammoName)
		-- 	icon:SetSize(96, 96)

		-- 	function icon:Paint(w, h)
				
		-- 		draw.RoundedBox( 0, 0, 0, w, h, Color( 80, 80, 80, 255 ) )
		-- 		draw.RoundedBox( 0, 0, 75, w, h - 75, Color( 40, 40, 40, 255 ) )
		-- 		draw.SimpleText(ammoName.." x"..ammoAmount, "DermaDefault", w/2, 80, Color(255, 255, 255, 255), 1)

		-- 	end

		-- 	print("adding ammo to ammo icon layout")
		-- 	ammoIconLayout:Add(icon)
			
		-- 	-- icon.DoClick = function(icon)

		-- 	-- end

		-- end

		print("sending message to server to fetch stash")

		net.Start( "RequestStash" )
		net.SendToServer()

		function ShowStashTable()

			for k, v in pairs(stashTable) do

				if v["ItemOwner"] != LocalPlayer():SteamID64() then	print(LocalPlayer():SteamID64() .. " does not equal " .. v["ItemOwner"])	return end
				if v["ItemType"] != "wep" then						print("ammo bad")															return end
	
				print("Initializing Stash Contents, gun class is " .. v["ItemName"])
				
				local weaponInfo = weapons.Get( v["ItemName"] )

				local wepName
	
				if weaponInfo["TrueName"] == nil then wepName = weaponInfo["PrintName"] else wepName = weaponInfo["TrueName"] end
	
				local icon = vgui.Create("SpawnIcon", stashIconLayout)
				icon:SetModel(weaponInfo["WorldModel"])
				icon:SetToolTip(wepName)
				icon:SetSize(96, 96)
	
				function icon:Paint(w, h)
					
					draw.RoundedBox( 0, 0, 0, w, h, Color( 80, 80, 80, 255 ) )
					draw.RoundedBox( 0, 0, 75, w, h - 75, Color( 40, 40, 40, 255 ) )
					draw.SimpleText(wepName, "DermaDefault", w/2, 80, Color(255, 255, 255, 255), 1)
	
				end
	
				stashIconLayout:Add(icon)

				icon.DoClick = function(icon)
	
					if LocalPlayer():HasWeapon( v["ItemName"] ) == false then

						net.Start("TakeFromStash")
						net.WriteString(v["ItemName"])
						net.SendToServer()

					else

						surface.PlaySound( "common/wpn_denyselect.wav" )

					end

				end
	
			end

		end

		function ResetMenu()

			stashIconLayout:Clear()
			inventoryIconLayout:Clear()
			ammoIconLayout:Clear()

			DoInventory()

		end

	end

end