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

--Anti-Bunnyhopping

RunConsoleCommand("vk_enabled", "1")
RunConsoleCommand("vk_suppressor", "1")
RunConsoleCommand("vk_speedlimit", "1")

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

--Realistic Fall Damage
RunConsoleCommand("mp_falldamage", "1")

--Disabling NoClip/Tinnitus
RunConsoleCommand("sbox_noclip", "0")
RunConsoleCommand("dsp_off", "1")

--Auto Respawning

RunConsoleCommand("sv_autorespawn_enabled", "1")
RunConsoleCommand("sv_respawntime", "15")
RunConsoleCommand("cl_drawownshadow", "1")

--TFA Muzzle Flash Setup
RunConsoleCommand("cl_tfa_rms_optimized_smoke", "1")
RunConsoleCommand("cl_tfa_rms_default_eject_smoke", "0") 
RunConsoleCommand("cl_tfa_rms_muzzleflash_dynlight", "1")

--Loot Rings/Attachment Menu Configuration

RunConsoleCommand("cl_vmanip_pickups_halo", "1")

--Forcing bullet penetration

RunConsoleCommand("sv_tfa_bullet_penetration", "1")
