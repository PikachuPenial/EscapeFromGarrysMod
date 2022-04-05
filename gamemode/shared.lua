GM.Name = "Escape From Garry's Mod"
GM.Author = "Pikachu/Penial"
GM.Email = "jacksonwassermann55@icloud.com"
GM.Website = "https://github.com/PikachuPenial"

DeriveGamemode("sandbox")

function GM:initialize()
  --Do my stuff here ig
end

function GM:ContextMenuOpen()
  return false
end

function GM:SpawnMenuOpen()
  RunConsoleCommand("efgm_extract_list")
  return false
end

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
RunConsoleCommand("stoppower_minimum_speed_mult", "0.40")
RunConsoleCommand("stoppower_recovery_speed", "0.66")
RunConsoleCommand("stoppower_recovery_delay", "0.25")

--Disabling NoClip/Tinnitus

RunConsoleCommand("sbox_noclip", "0")
RunConsoleCommand("dsp_off", "1")

--Auto Respawning

RunConsoleCommand("sv_autorespawn_enabled", "1")
RunConsoleCommand("sv_respawntime", "10")
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

--Proximity Voice Chat

RunConsoleCommand("sv_maxVoiceAudible", "850")

--Inventory Blacklist

RunConsoleCommand("gws_blacklist_add", "swep_inventory")
RunConsoleCommand("gws_blacklist_add", "weapon_swep_inventory")
RunConsoleCommand("gws_blacklist_add", "fas2_bandage")
RunConsoleCommand("gws_blacklist_add", "fas2_ifak")
RunConsoleCommand("gws_blacklist_add", "arccw_go_melee_knife")
RunConsoleCommand("gws_blacklist_add", "arccw_go_knife_bowie")
RunConsoleCommand("gws_blacklist_add", "arccw_go_knife_butterfly")
RunConsoleCommand("gws_blacklist_add", "arccw_go_knife_t")
RunConsoleCommand("gws_blacklist_add", "arccw_go_knife_karambit")
RunConsoleCommand("gws_blacklist_add", "arccw_go_knife_m9bayonet")
RunConsoleCommand("gws_blacklist_add", "arccw_go_knife_ct")
RunConsoleCommand("gws_blacklist_add", "arccw_go_knife_stiletto")
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
RunConsoleCommand("arccw_attinv_giveonspawn", "100")
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