GM.Name = "Escape From Garry's Mod"
GM.Author = "Penial & Porty"
GM.Email = "pissoff"
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

	--Creating a temporary array to sort through for the actual array seen in the shop

	--Array Formatting (Model, Item Name, Shop Print Name, Cost, Level, Rarity/Tier, Category)

	local tempWeaponsArray = {}

	tempWeaponsArray[1] = {"models/weapons/arccw/dm1973/c_dmi_bm92f_auto.mdl", "arccw_dmi_b92f_auto", "92F Auto Pistol", 13005, "7", "MID", "Pistol"}
	tempWeaponsArray[2] = {"models/weapons/arccw/w_zz_mg24_tp.mdl", "arccw_waw_dp28", "DP-28", 21370, "14", "HIGH", "Heavy"}
	tempWeaponsArray[3] = {"models/weapons/arc_eft_aks74u/eft_aks74u/models/c_eft_aks74u.mdl", "arccw_eft_aks74u", "AKS-74u", 9980, "5", "LOW", "SMG"}
	tempWeaponsArray[4] = {"models/weapons/arc_eft_1911/c_eft_1911/models/c_eft_1911.mdl", "arccw_eft_1911", "M1911", 4140, "1", "LOW", "Pistol"}
	tempWeaponsArray[5] = {"models/weapons/arc_eft_mp5/w_eft_mp5/models/w_eft_mp5.mdl", "arccw_eft_mp5", "MP5", 10995, "6", "LOW", "SMG"}
	tempWeaponsArray[6] = {"models/weapons/arc_eft_mp5/w_eft_mp5_std/models/w_eft_mp5_std.mdl", "arccw_eft_mp5sd", "MP5SD", 9995, "5", "LOW", "SMG"}
	tempWeaponsArray[7] = {"models/weapons/arc_eft_mp7/eft_mp7/models/c_eft_mp7.mdl", "arccw_eft_mp7", "MP7A1", 13195, "7", "MID", "SMG"}
	tempWeaponsArray[8] = {"models/weapons/arc_eft_ppsh/c_eft_ppsh/models/c_eft_ppsh.mdl", "arccw_eft_ppsh", "PPSH-41", 8440, "5", "LOW", "SMG"}
	tempWeaponsArray[9] = {"models/weapons/arc_eft_t5000/eft_t5000/models/c_eft_t5000.mdl", "arccw_eft_t5000", "T-5000", 18050, "12", "HIGH", "Sniper"}
	tempWeaponsArray[10] = {"models/weapons/arc_eft_ump/eft_ump/models/c_eft_ump.mdl", "arccw_eft_ump", "UMP-45", 10050, "6", "LOW", "SMG"}
	tempWeaponsArray[11] = {"models/weapons/arccw/eap/c_aek971.mdl", "arccw_eap_aek", "AEK-971", 17120, "11", "HIGH", "Rifle"}
	tempWeaponsArray[12] = {"models/weapons/arccw/eap/c_fmg9.mdl", "arccw_eap_fmg9", "FMG-9", 15555, "10", "MID", "SMG"}
	tempWeaponsArray[13] = {"models/weapons/arccw/eap/c_groza.mdl", "arccw_eap_groza", "OTs-14 Groza", 13580, "10", "MID", "Rifle"}
	tempWeaponsArray[14] = {"models/weapons/arccw/eap/c_lebedev.mdl", "arccw_eap_lebedev", "PL-15 Lebedev Pistol", 4630, "1", "LOW", "Pistol"}
	tempWeaponsArray[15] = {"models/weapons/arccw/eap/c_spectre.mdl", "arccw_eap_spectre", "Spectre M4", 11010, "7", "MID", "SMG"}
	tempWeaponsArray[16] = {"models/weapons/arccw/eap/c_stg44.mdl", "arccw_eap_stg44", "StG-44", 13100, "9", "MID", "Rifle"}
	tempWeaponsArray[17] = {"models/weapons/arccw/eap/c_usas.mdl", "arccw_eap_usas", "USAS-12", 27510, "16", "HIGH", "Shotgun"}
	tempWeaponsArray[18] = {"models/weapons/arccw/slogkot/c_altor.mdl", "arccw_slog_altor", "Altor Pistol", 5005, "2", "LOW", "Pistol"}
	tempWeaponsArray[19] = {"models/weapons/arccw_go/v_eq_incendiarygrenade.mdl", "arccw_go_nade_incendiary", "AN/M14 Thermite Grenade", 2500, "2", "UTIL", "Grenade"}
	tempWeaponsArray[20] = {"models/weapons/arccw_go/v_eq_fraggrenade.mdl", "arccw_go_nade_frag", "M67 Frag Grenade", 2500, "2", "UTIL", "Grenade"}
	tempWeaponsArray[21] = {"models/weapons/arccw_go/v_eq_flashbang.mdl", "arccw_go_nade_flash", "M84 Stun Grenade", 2500, "2", "UTIL", "Grenade"}
	tempWeaponsArray[22] = {"models/weapons/arccw_go/v_eq_smokegrenade.mdl", "arccw_go_nade_smoke", "M5210 Smoke Grenade", 2500, "2", "UTIL", "Grenade"}
	tempWeaponsArray[23] = {"models/weapons/arccw_go/v_eq_molotov.mdl", "arccw_go_nade_molotov", "Molotov Cocktail", 2500, "2", "UTIL", "Grenade"}
	tempWeaponsArray[24] = {"models/weapons/arccw_go/v_eq_throwingknife.mdl", "arccw_go_nade_knife", "Throwing Knife", 2500, "2", "UTIL", "Grenade"}
	tempWeaponsArray[25] = {"models/weapons/arccw_go/v_pist_deagle.mdl", "arccw_ur_deagle", "Desert Eagle", 6005, "4", "LOW", "Pistol"}
	tempWeaponsArray[26] = {"models/weapons/arccw/c_xm8.mdl", "midnights_gso_xm8", "HK XM8", 18920, "14", "HIGH", "Rifle"}
	tempWeaponsArray[27] = {"models/weapons/arccw/midnightwolf/type20.mdl", "arccw_midnightwolf_type20", "Type 20", 17880, "13", "HIGH", "-=Rifle"}
	tempWeaponsArray[28] = {"models/weapons/arccw/c_ud_glock.mdl", "arccw_ud_glock", "Glock 17", 6005, "3", "LOW", "Pistol"}
	tempWeaponsArray[29] = {"models/weapons/arccw/c_ud_m16.mdl", "arccw_ud_m16", "M16A3", 16995, "12", "MID", "Rifle"}
	tempWeaponsArray[30] = {"models/weapons/arccw/c_ud_m1014.mdl", "arccw_ud_m1014", "M4 Super 90 SG", 12995, "8", "MID", "Shotgun"}
	tempWeaponsArray[31] = {"models/weapons/arccw/c_ud_m79.mdl", "arccw_ud_m79", "M79 Grenade Launcher", 22555, "18", "HIGH", "Heavy"}
	tempWeaponsArray[32] = {"models/weapons/arccw/c_ud_mini14.mdl", "arccw_ud_mini14", "Mini-14", 16420, "12", "MID", "Rifle"}
	tempWeaponsArray[33] = {"models/weapons/arccw/c_ud_870.mdl", "arccw_ud_870", "Remington 870", 10240, "6", "MID", "Shotgun"}
	tempWeaponsArray[34] = {"models/weapons/arccw/c_ud_uzi.mdl", "arccw_ud_uzi", "Uzi", 11040, "6", "LOW", "SMG"}
	tempWeaponsArray[35] = {"models/weapons/arccw/mifl/fas2/c_ak47.mdl", "arccw_mifl_fas2_ak47", "AKM", 17005, "13", "HIGH", "Rifle"}
	tempWeaponsArray[36] = {"models/weapons/arccw/mifl/fas2/c_famas.mdl", "arccw_mifl_fas2_famas", "FAMAS", 16990, "12", "MID", "Rifle"}
	tempWeaponsArray[37] = {"models/weapons/arccw/mifl/fas2/c_g36c.mdl", "arccw_mifl_fas2_g36c", "G36c", 14445, "11", "MID", "Rifle"}
	tempWeaponsArray[38] = {"models/weapons/arccw/mifl/fas2/c_g3.mdl", "arccw_mifl_fas2_g3", "G3A3", 16310, "12", "MID", "Rifle"}
	tempWeaponsArray[39] = {"models/weapons/arccw/mifl/fas2/c_ks23.mdl", "arccw_mifl_fas2_ks23", "KS-23", 13005, "8", "MID", "Shotgun"}
	tempWeaponsArray[40] = {"models/weapons/arccw/mifl/fas2/c_m24.mdl", "arccw_mifl_fas2_m24", "M24 SR", 18900, "14", "HIGH", "Sniper"}
	tempWeaponsArray[41] = {"models/weapons/arccw/mifl/fas2/c_m3s90.mdl", "arccw_mifl_fas2_m3", "M3 Super 90", 14505, "12", "MID", "Shotgun"}
	tempWeaponsArray[42] = {"models/weapons/arccw/mifl/fas2/c_m82.mdl", "arccw_mifl_fas2_m82", "M82 SR", 20999, "18", "HIGH", "Sniper"}
	tempWeaponsArray[43] = {"models/weapons/arccw/mifl/fas2/c_mac11.mdl", "arccw_mifl_fas2_mac11", "MAC-11", 8100, "5", "LOW", "SMG"}
	tempWeaponsArray[44] = {"models/weapons/arccw/mifl/fas2_custom/c_m26.mdl", "arccw_fml_fas2_custom_mass26", "MASS-26 SG", 17550, "14", "HIGH", "Shotgun"}
	tempWeaponsArray[45] = {"models/weapons/arccw/mifl/fas2/c_minimi.mdl", "arccw_mifl_fas2_minimi", "Minimi", 19995, "16", "HIGH", "Heavy"}
	tempWeaponsArray[46] = {"models/weapons/arccw/mifl/fas2/c_ragingbull.mdl", "arccw_mifl_fas2_ragingbull", "Raging Bull Revolver", 7020, "4", "LOW", "Pistol"}
	tempWeaponsArray[47] = {"models/weapons/arccw/mifl/fas2/c_rpk.mdl", "arccw_mifl_fas2_rpk", "RPK47", 14765, "10", "MID", "Heavy"}
	tempWeaponsArray[48] = {"models/weapons/arccw/mifl/fas2/c_sg552.mdl", "arccw_mifl_fas2_sg55x", "SG552", 15490, "12", "MID", "Rifle"}
	tempWeaponsArray[49] = {"models/weapons/arccw/c_claymorelungemine.mdl", "arccw_claymorelungemine", "Claymore Lunge Mine", 5555, "5", "UTIL", "Heavy"}
	tempWeaponsArray[50] = {"models/weapons/arc_eft_usp/c_eft_usp.mdl", "arccw_eft_usp", "HK USP .45", 5555, "3", "LOW", "Pistol"}
	tempWeaponsArray[51] = {"models/weapons/arccw/darsu_eft/c_mp153.mdl", "arccw_eft_mp153", "MP-153", 15005, "10", "MID", "Shotgun"}
	tempWeaponsArray[52] = {"models/weapons/arccw/darsu_eft/c_mp153.mdl", "arccw_eft_mp155", "MP-155", 14005, "10", "MID", "Shotgun"}
	tempWeaponsArray[53] = {"models/weapons/arc_eft_scarl/c_eft_scarh.mdl", "arccw_eft_scarh", "SCAR-H", 17090, "13", "HIGH", "Rifle"}
	tempWeaponsArray[54] = {"models/weapons/arc_eft_scarl/c_eft_scarl.mdl", "arccw_eft_scarl", "SCAR-L", 15995, "12", "MID", "Rifle"}
	tempWeaponsArray[55] = {"models/weapons/arccw_go/v_smg_mp5.mdl", "arccw_ur_mp5", "MP5A4", 10005, "5", "LOW", "SMG"}
	tempWeaponsArray[56] = {"models/weapons/arccw_go/v_snip_awp.mdl", "arccw_ur_aw", "AWM SR", 13095, "9", "MID", "Sniper"}
	tempWeaponsArray[57] = {"models/weapons/arccw/c_type89.mdl", "midnights_gso_type89", "Howa Type 89", 18005, "14", "HIGH", "Rifle"}
	tempWeaponsArray[58] = {"models/weapons/arccw/c_waw_thompson.mdl", "arccw_waw_thompson", "M1A1 Thompson", 11565, "7", "MID", "SMG"}
	tempWeaponsArray[59] = {"models/weapons/arccw/c_waw_mp40.mdl", "arccw_waw_mp40", "MP40", 9895, "6", "LOW", "SMG"}
	tempWeaponsArray[60] = {"models/weapons/arccw/c_waw_type100.mdl", "arccw_waw_type100", "Type 100/44", 12995, "8", "MID", "SMG"}
	tempWeaponsArray[61] = {"models/weapons/arccw/c_bo1_mpl.mdl", "arccw_bo1_mpl", "MPL", 9205, "6", "LOW", "SMG"}
	tempWeaponsArray[62] = {"models/weapons/arccw/c_bo1_pm63.mdl", "arccw_bo1_pm63", "PM-63 RAK", 8995, "5", "LOW", "Pistol"}
	tempWeaponsArray[63] = {"models/weapons/arccw/c_bo1_g11.mdl", "arccw_bo1_g11", "HK G11", 15900, "11", "MID", "Rifle"}
	tempWeaponsArray[64] = {"models/weapons/arccw/c_bo1_law.mdl", "arccw_bo1_law", "M72 LAW RL", 33333, "20", "HIGH", "Heavy"}
	tempWeaponsArray[65] = {"models/weapons/arccw/c_bo1_aug.mdl", "arccw_bo1_aug", "AUG", 14250, "10", "MID", "Rifle"}
	tempWeaponsArray[66] = {"models/weapons/arccw/c_bo1_xl60.mdl", "arccw_bo1_xl60", "XL64ES", 13905, "10", "MID", "Rifle"}
	tempWeaponsArray[67] = {"models/weapons/arccw/c_bo1_famas.mdl", "arccw_bo1_famas", "FAMAS Valorise", 14505, "10", "MID", "Rifle"}
	tempWeaponsArray[68] = {"models/weapons/arccw/c_bo1_fal.mdl", "arccw_bo1_fal", "FN Fal", 17050, "12", "HIGH", "Rifle"}
	tempWeaponsArray[69] = {"models/weapons/arccw/c_bo1_hk21.mdl", "arccw_bo1_hk21", "HK21", 26000, "16", "HIGH", "Heavy"}
	tempWeaponsArray[70] = {"models/weapons/arccw/c_bo1_galil.mdl", "arccw_bo1_galil", "IMI Galil", 14005, "11", "MID", "Rifle"}
	tempWeaponsArray[71] = {"models/weapons/arccw/c_waw_mosin.mdl", "arccw_waw_mosin", "Mosin-Nagant M38", 15000, "10", "MID", "Sniper"}
	tempWeaponsArray[72] = {"models/weapons/arccw/c_waw_garand.mdl", "arccw_waw_garand", "M1 Garand", 15500, "11", "MID", "Rifle"}
	tempWeaponsArray[73] = {"models/weapons/arccw/c_waw_357.mdl", "arccw_waw_357", "S&W Model 27", 6995, "3", "LOW", "Pistol"}
	tempWeaponsArray[74] = {"models/weapons/arccw/c_waw_ptrs41.mdl", "arccw_waw_ptrs41", "PTRS-41 SR", 45999, "24", "HIGH", "Sniper"}
	tempWeaponsArray[75] = {"models/weapons/arccw/c_waw_tt33.mdl", "arccw_waw_tt33", "TT-33", 4500, "1", "LOW", "Pistol"}
	tempWeaponsArray[76] = {"models/weapons/arccw/c_bo1_sten.mdl", "arccw_bo1_sten", "Sten Mk II", 11000, "8", "MID", "SMG"}
	tempWeaponsArray[77] = {"models/weapons/arccw/c_waw_fg42.mdl", "arccw_waw_fg42", "FG 42", 40999, "22", "HIGH", "Heavy"}
	tempWeaponsArray[78] = {"models/weapons/arccw/c_bo1_m60.mdl", "arccw_bo1_m60", "M60E3", 32999, "20", "HIGH", "Heavy"}
	tempWeaponsArray[79] = {"models/weapons/arccw/c_waw_trenchgun.mdl", "arccw_waw_trenchgun", "M1897 Trenchgun", 14995, "11", "MID", "Shotgun"}
	tempWeaponsArray[80] = {"models/weapons/arccw/c_bo1_stoner.mdl", "arccw_bo1_stoner", "Stoner 63", 15400, "12", "MID", "Rifle"}
	tempWeaponsArray[81] = {"models/weapons/arccw/c_bo2_fiveseven.mdl", "arccw_bo2_fiveseven", "FN Five-SeveN", 4750, "2", "LOW", "Pistol"}
	tempWeaponsArray[82] = {"models/weapons/arccw/c_cde_m92.mdl", "arccw_cde_m93r", "Beretta 92", 5000, "3", "LOW", "Pistol"}
	tempWeaponsArray[83] = {"models/weapons/arccw/c_waw_mg42.mdl", "arccw_waw_mg42", "MG-42", 52500, "26", "HIGH", "Heavy"}
	tempWeaponsArray[84] = {"models/weapons/arccw/c_bo1_kiparis.mdl", "arccw_bo1_kiparis", "OTS-12 Kiparis", 9550, "4", "LOW", "Pistol"}
	tempWeaponsArray[85] = {"models/weapons/arccw/c_bo2_vector.mdl", "arccw_bo2_vector", "TDI Kriss Vector 9mm", 24000, "18", "HIGH", "SMG"}
	tempWeaponsArray[86] = {"models/weapons/arccw/c_bo1_svd.mdl", "arccw_bo1_dragunov", "Dragunov SVD", 25000, "18", "HIGH", "Sniper"}
	tempWeaponsArray[87] = {"models/weapons/arccw/c_bo1_rpk.mdl", "arccw_bo1_rpk", "RPK-74", 19500, "15", "HIGH", "Heavy"}
	tempWeaponsArray[88] = {"models/weapons/arccw/c_bo2_smr.mdl", "arccw_bo2_smr", "SMI Saritch .308", 26500, "18", "HIGH", "Rifle"}
	tempWeaponsArray[89] = {"models/weapons/arccw/c_mw2e_f2000.mdl", "arccw_mw2e_f2000", "FN F2000", 16900, "14", "MID", "Rifle"}
	tempWeaponsArray[90] = {"models/weapons/arccw/c_mw3e_rsass.mdl", "arccw_mw3e_rsass", "RSASS", 22255, "17", "HIGH", "Rifle"}
	tempWeaponsArray[91] = {"models/weapons/arccw/c_mw3e_p90.mdl", "arccw_mw3e_p90", "FN P90", 14900, "11", "MID", "SMG"}
	tempWeaponsArray[92] = {"models/weapons/arccw/c_mw3e_mk14.mdl", "arccw_mw3e_mk14", "Mk 14 Mod 1", 19995, "15", "MID", "Rifle"}
	tempWeaponsArray[93] = {"models/weapons/arccw/c_mw3e_l86.mdl", "arccw_mw3e_l86", "L86A2 LSW", 16555, "14", "MID", "Rifle"}
	tempWeaponsArray[94] = {"models/weapons/arccw/c_mw3e_mp9.mdl", "arccw_mw3e_mp9", "B&T MP9", 11550, "6", "LOW", "SMG"}
	tempWeaponsArray[95] = {"models/weapons/arccw/c_mw2e_pp2000.mdl", "arccw_mw2e_pp2000", "PP-2000", 9995, "5", "LOW", "Pistol"}
	tempWeaponsArray[96] = {"models/weapons/arccw/c_mw3e_pp90m1.mdl", "arccw_mw3e_pp90m1", "PP-90M1", 10900, "6", "LOW", "SMG"}
	tempWeaponsArray[97] = {"models/weapons/arccw/c_mw3e_acr.mdl", "arccw_mw3e_acr", "Remington ACR", 17000, "13", "MID", "Rifle"}
	tempWeaponsArray[98] = {"models/weapons/arccw/c_bo1_crossbow.mdl", "arccw_bo1_crossbow", "Crossbow", 20000, "12", "MID", "Heavy"}
	tempWeaponsArray[99] = {"models/weapons/arccw/c_cod4_r700.mdl", "arccw_cod4e_r700", "Remington 700", 14995, "13", "MID", "Sniper"}
	tempWeaponsArray[100] = {"models/weapons/arccw/c_bo1_ak47.mdl", "arccw_bo1_ak47", "AK-47", 14500, "12", "MID", "Rifle"}

	local tempEntityArray = {}

	--Crates
	tempEntityArray[1] = {"models/efgm/low_crate02.mdl", "efgm_weapon_crate_low", "Low Tier Weapon Crate", 5555, "2", "LOW", "Container"}
	tempEntityArray[2] = {"models/efgm/mid_crate01.mdl", "efgm_weapon_crate_mid", "Mid Tier Weapon Crate", 13000, "4", "MID", "Container"}
	tempEntityArray[3] = {"models/efgm/high_crate01.mdl", "efgm_weapon_crate_high", "High Tier Weapon Crate", 20000, "8", "HIGH", "Container"}

	--Ammo
	tempEntityArray[4] = {"models/items/arccw/smg_ammo.mdl", "arccw_ammo_smg1", "60 Carbine (SMG1) Ammo", 4000, "2", "MID", "Ammo"}
	tempEntityArray[5] = {"models/items/arccw/smg_ammo.mdl", "arccw_ammo_smg1_large", "300 Carbine (SMG1) Ammo", 9000, "5", "MID", "Ammo"}
	tempEntityArray[6] = {"models/items/arccw/magnum_ammo.mdl", "arccw_ammo_357", "12 Magnum (357) Ammo", 4000, "2", "LOW", "Ammo"}
	tempEntityArray[7] = {"models/items/arccw/magnum_ammo_closed.mdl", "arccw_ammo_357_large", "60 Magnum (357) Ammo", 9000, "5", "MID", "Ammo"}
	tempEntityArray[8] = {"models/items/arccw/pistol_ammo.mdl", "arccw_ammo_pistol", "40 Pistol Ammo", 4000, "2", "LOW", "Ammo"}
	tempEntityArray[9] = {"models/items/arccw/pistol_ammo.mdl", "arccw_ammo_pistol_large", "200 Pistol Ammo", 9000, "5", "MID", "Ammo"}
	tempEntityArray[10] = {"models/items/arccw/rifle_ammo.mdl", "arccw_ammo_ar2", "30 Rifle (AR2) Ammo", 4000, "2", "LOW", "Ammo"}
	tempEntityArray[11] = {"models/items/arccw/rifle_ammo.mdl", "arccw_ammo_ar2_large", "150 Rifle (AR2) Ammo", 9000, "5", "MID", "Ammo"}
	tempEntityArray[12] = {"models/items/arccw/shotgun_ammo.mdl", "arccw_ammo_buckshot", "20 Buckshot Shells", 4000, "2", "LOW", "Ammo"}
	tempEntityArray[13] = {"models/items/arccw/shotgun_ammo_closed.mdl", "arccw_ammo_buckshot_large", "100 Buckshot Shells", 9000, "5", "MID", "Ammo"}
	tempEntityArray[14] = {"models/items/arccw/sniper_ammo.mdl", "arccw_ammo_sniper", "10 Sniper Rounds", 4000, "2", "LOW", "Ammo"}
	tempEntityArray[15] = {"models/items/arccw/sniper_ammo.mdl", "arccw_ammo_sniper_large", "50 Sniper Rounds", 9000, "5", "MID", "Ammo"}
	tempEntityArray[16] = {"models/Items/AR2_Grenade.mdl", "arccw_ammo_smg1_grenade", "40mm (SMG Grenade)", 4000, "5", "MID", "Ammo"}
	tempEntityArray[17] = {"models/items/arccw/riflegrenade_ammo.mdl", "arccw_ammo_smg1_grenade_large", "5 40mm (SMG Grenades)", 12000, "10", "HIGH", "Ammo"}

	--Medical
	tempEntityArray[18] = {"models/Items/BoxMRounds.mdl", "fas2_ammo_bandages", "Bandage", 1250, "2", "LOW", "Medication"}
	tempEntityArray[19] = {"models/Items/BoxMRounds.mdl", "fas2_ammo_quikclots", "Quikclot", 2750, "4", "LOW", "Medication"}
	tempEntityArray[20] = {"models/Items/BoxMRounds.mdl", "fas2_ammo_hemostats", "Hemostat", 4000, "6", "MID", "Medication"}

	--Armor
	tempEntityArray[21] = {"models/armor_module3m/module3m.mdl", "ent_jack_gmod_ezarmor_module3m", "Module 3M (Class 2)", 7350, "3", "LOW", "Armored Vest"}
	tempEntityArray[22] = {"models/eft_paca_armor/paca_soft_armor.mdl", "ent_jack_gmod_ezarmor_paca", "Paca Soft Armor (Class 2)", 8275, "5", "LOW", "Armored Vest"}
	tempEntityArray[23] = {"models/armor_un/un.mdl", "ent_jack_gmod_ezarmor_untar", "UNTAR Vest (Class 3)", 8890, "6", "LOW", "Armored Vest"}
	tempEntityArray[24] = {"models/armor_zhuk3/beetle3.mdl", "ent_jack_gmod_ezarmor_zhukpress", "Zhuk-3 Pressa (Class 3)", 10000, "8", "LOW", "Armored Vest"}
	tempEntityArray[25] = {"models/eft_trooper/trooper.mdl", "ent_jack_gmod_ezarmor_trooper", "Tropper TFO (Class 4)", 11705, "10", "MID", "Armored Vest"}
	tempEntityArray[26] = {"models/armor_6b13_flora/6b13_flora.mdl", "ent_jack_gmod_ezarmor_6b13flora", "6B13 (Class 4)", 13200, "12", "MID", "Armored Vest"}
	tempEntityArray[27] = {"models/armor_korundvm/armor_korundvm.mdl", "ent_jack_gmod_ezarmor_korundvm", "Korund-VM (Class 5)", 16555, "14", "HIGH", "Armored Vest"}
	tempEntityArray[28] = {"models/eft_6b13_killa/6b13_killa.mdl", "ent_jack_gmod_ezarmor_6b13m", "6B13 M Killa (Class 5)", 19950, "16", "HIGH", "Armored Vest"}
	tempEntityArray[29] = {"models/armor_custom_hexgrid/custom_hexgrid.mdl", "ent_jack_gmod_ezarmor_hexgrid", "5.11 Hexgrid (Class 6)", 25555, "19", "HIGH", "Armored Vest"}
	tempEntityArray[30] = {"models/armor_slick/armor_slick_tan.mdl", "ent_jack_gmod_ezarmor_slicktan", "Slick Plate Carrier (Class 6)", 31000, "23", "HIGH", "Armored Vest"}

	--Helmets
	tempEntityArray[31] = {"models/helmet_tsh_4m2/tsh_4m2.mdl", "ent_jack_gmod_ezarmor_shlemofon", "Soft Tank Helmet (Class 1)", 6805, "3", "LOW", "Helmet"}
	tempEntityArray[32] = {"models/helmet_shpm/shpm.mdl", "ent_jack_gmod_ezarmor_shpmhelm", "SHPM Firefighter Helmet (Class 2)", 7790, "5", "LOW", "Helmet"}
	tempEntityArray[33] = {"models/helmet_un/un_helmet.mdl", "ent_jack_gmod_ezarmor_untarhelm", "UNTAR Helmet (Class 3)", 8400, "6", "LOW", "Helmet"}
	tempEntityArray[34] = {"models/helmet_ssh_68/item_equipment_helmet_ssh-68_lod0.mdl", "ent_jack_gmod_ezarmor_ssh68", "SSH-68 Helmet (Class 3)", 9310, "8", "LOW", "Helmet"}
	tempEntityArray[35] = {"models/helmet_mich/helmet_mich2001.mdl", "ent_jack_gmod_ezarmor_mich2001", "TC-2001 Helmet (Class 4)", 11250, "10", "MID", "Helmet"}
	tempEntityArray[36] = {"models/helmet_team_wendy_exfil/helmet_team_wendy_exfil_black.mdl", "ent_jack_gmod_ezarmor_twexfilb", "Wendy Exfil Helmet (Class 4)", 12705, "12", "MID", "Helmet"}
	tempEntityArray[37] = {"models/helmet_ulach_black/ulach_coyote.mdl", "ent_jack_gmod_ezarmor_ulachcoyote", "ULACH IIIA Helmet (Class 4)", 14950, "14", "HIGH", "Helmet"}
	tempEntityArray[38] = {"models/helmet_maska_1sh_killa/maska_killa.mdl", "ent_jack_gmod_ezarmor_maska1shkilla", "Maska-1SCh Helmet (Class 4)", 18400, "16", "HIGH", "Helmet"}
	tempEntityArray[39] = {"models/helmet_altyn/helmlet_altyn_lod1.mdl", "ent_jack_gmod_ezarmor_altyn", "Altyn (Class 5)", 23335, "19", "HIGH", "Helmet"}
	tempEntityArray[40] = {"models/helmet_rys_t/helmet_rys_t.mdl", "ent_jack_gmod_ezarmor_ryst", "Rys-T (Class 5)", 29995, "23", "HIGH", "Helmet"}

	--Accessories/Face
	tempEntityArray[41] = {"models/customizable/nvg_alfa_pnv-10t/nvg_alfa_pnv_10t.mdl", "ent_jack_gmod_ezarmor_pnv10t", "PNV-10T NVG", 25000, "10", "HIGH", "Goggles"}
	tempEntityArray[42] = {"models/customizable/thermal_spi_t7/thermal_spi_t7.mdl", "ent_jack_gmod_ezarmor_t7thermal", "T-7 Thermal Goggles", 40000, "15", "HIGH", "Goggles"}
	tempEntityArray[43] = {"models/facecover_gasmask_gp5/gasmask_gp5.mdl", "ent_jack_gmod_ezarmor_gp5", "GP-5 (No functionality yet)", 6000, "3", "LOW", "Gas Mask"}
	tempEntityArray[44] = {"models/facecover_gasmask_opscore/ops_core_sotr_respirator.mdl", "ent_jack_gmod_ezarmor_sotr", "Ops-Core SOTR (No functionality yet)", 12500, "6", "MID", "Gas Mask"}
	tempEntityArray[45] = {"models/helmet_shpm_shield/shpm_shield.mdl", "ent_jack_gmod_ezarmor_shpmface", "SHPM Face Shield", 6500, "4", "LOW", "Face Shield"}
	tempEntityArray[46] = {"models/helmet_team_wendy_exfil/helmet_team_wendy_exfil_face_shield_coyote.mdl", "ent_jack_gmod_ezarmor_twexfilshieldc", "Wendy Exfil Face Shield", 6500, "8", "MID", "Face Shield"}
	tempEntityArray[47] = {"models/helmet_altynshield/helmet_altyn_face_shield_metal_lod0.mdl", "ent_jack_gmod_ezarmor_altynface", "Altyn Face Shield", 12950, "12", "HIGH", "Face Shield"}
	tempEntityArray[48] = {"models/helmet_rys_t/helmet_rys_t_shield.mdl", "ent_jack_gmod_ezarmor_rystface", "Rys-T Face Shield", 16005, "16", "HIGH", "Face Shield"}
	tempEntityArray[49] = {"models/facecover_welding/facecover_tagilla_kill.mdl", "ent_jack_gmod_ezarmor_weldingkill", "Tagilla's Welding Mask", 22555, "20", "HIGH", "Face Shield"}
	tempEntityArray[50] = {"models/helmet_maska_1sh_shield_killa/maska_shield_killa.mdl", "ent_jack_gmod_ezarmor_shlemmaskkilla", "Maska-1SCh Face Shield", 29995, "24", "HIGH", "Face Shield"}

	--Any weapon in this array cannot be sold. Put any starting equipment here.

	sellBlacklist[1] = {"arccw_go_knife_m9bayonet"}
	sellBlacklist[2] = {"arccw_eft_1911"}
	sellBlacklist[3] = {"arccw_waw_p38"}
	sellBlacklist[4] = {"arccw_waw_tt33"}
	sellBlacklist[5] = {"arccw_go_nade_frag"}
	sellBlacklist[6] = {"arccw_go_nade_smoke"}
	sellBlacklist[7] = {"arccw_go_nade_incendiary"}

	--Temporary array created. This next section will sort the guns by cost, so guns higher to the top will hopefully be better. This is convenient.
	--The sort function takes the fourth value of all tempWeaponsArray indexes (the rouble count) and sorts by them from greatest to lowest.

	--If you want it in descending order instead of ascending, change the > to a <. If you want it to sort by level requirement, change the [4] to [5].
	--Do you want it sorted alphabetically? Too bad!

	table.sort(tempWeaponsArray, function(a, b) return a[4] > b[4] end)

	--I think thats it

	weaponsArr = tempWeaponsArray
	entsArr = tempEntityArray

end

if !ConVarExists("efgm_hidebinds") then CreateConVar( "efgm_hidebinds", "0", FCVAR_ARCHIVE, "Show or hide binds, while you are not in Raid",0,1 ) end

--This is where the console commands are ran when a client joins a game running the gamemode.

function GM:ContextMenuOpen()
	return false
end

--Disable Spawn Menu and show the extract list when the bind is pressed.
function GM:SpawnMenuEnabled()
	return false
end

function GM:SpawnMenuOpen()
	RunConsoleCommand("efgm_extract_list")
	return false
end

--Disabling console commands that allow prop/entity abuse.
hook.Add("PlayerGiveSWEP", "BlockPlayerSWEPs", function(ply, class, swep)
	if (!ply:IsAdmin()) then
		return false
	end
end)

function GM:PlayerSpawnEffect(ply)
	return false
end

function GM:PlayerSpawnNPC(ply)
	return false
end

function GM:PlayerSpawnObject(ply)
	return false
end

function GM:PlayerSpawnProp(ply)
	return false
end

function GM:PlayerSpawnRagdoll(ply)
	return false
end

function GM:PlayerSpawnSENT(ply)
	return false
end

function GM:PlayerSpawnSWEP(ply)
	return false
end

function GM:PlayerSpawnVehicle(ply)
	return false
end

--Removing problematic console commmands.
concommand.Remove("ent_create")
concommand.Remove("gmod_spawnnpc")

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
RunConsoleCommand("atmos_snowenabled", "0")

--Tarkov Hud Configuration
RunConsoleCommand("tarkovhud_enabled", "1")
RunConsoleCommand("tarkovhud_hp_colored", "1")
RunConsoleCommand("tarkovhud_autohide_hp", "0")
RunConsoleCommand("tarkovhud_autohide_stamina", "0")
RunConsoleCommand("tarkovhud_blur", "1")
RunConsoleCommand("tarkovhud_blur_neardeath", "1")

--Realistic Fall Damage
RunConsoleCommand("mp_falldamage", "1")

--Killfeed Disable
RunConsoleCommand("hud_deathnotice_time", "0")

--Free Look

RunConsoleCommand("altlook", "1")
RunConsoleCommand("altlook_block_ads", "1")
RunConsoleCommand("altlook_block_fire", "0")
RunConsoleCommand("altlook_limit_horizontal", "70")
RunConsoleCommand("altlook_limit_vertical", "36")
RunConsoleCommand("altlook_smoothness_mult", "1.25")

--Armor
RunConsoleCommand("jmod_eft_wghtmult", "0.32")
RunConsoleCommand("jmod_eft_durmult", "1.90")
RunConsoleCommand("jmod_armorprotectionmult", "0.85")

--View Bobbing
RunConsoleCommand("viewbob_crouch_enable", "1")
RunConsoleCommand("viewbob_crouch_multiplier", "0.070000")
RunConsoleCommand("viewbob_damage_enable", "1")
RunConsoleCommand("viewbob_damage_multiplier", "0.100000")
RunConsoleCommand("viewbob_enable", "1")
RunConsoleCommand("viewbob_idle_enable", "0")
RunConsoleCommand("viewbob_idle_multiplier", "1.000000")
RunConsoleCommand("viewbob_land_jump_enable", "1")
RunConsoleCommand("viewbob_multiplier", "0.400000")
RunConsoleCommand("viewbob_tools_enable", "0")
RunConsoleCommand("viewbob_walk_enable", "0")
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
RunConsoleCommand("sv_gws_needinv", "1")


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
RunConsoleCommand("arccw_enable_dropping", "0")
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
RunConsoleCommand("arccw_mult_hipfire", "1.00")
RunConsoleCommand("arccw_mult_infiniteammo", "0")
RunConsoleCommand("arccw_mult_malfunction", "1.65")
RunConsoleCommand("arccw_mult_movedisp", "0.50")
RunConsoleCommand("arccw_mult_penetration", "1.00")
RunConsoleCommand("arccw_mult_range", "1.00")
RunConsoleCommand("arccw_mult_recoil", "1.32")
RunConsoleCommand("arccw_mult_reloadtime", "1.60")
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
RunConsoleCommand("arccw_visibility", "2500")
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