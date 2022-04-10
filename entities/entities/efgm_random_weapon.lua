ENT.Type = "point"
ENT.Base = "base_point"

ENT.SpawnChance = 1
ENT.SpawnTier = 0
ENT.StartDisabled = 0

ENT.SpawnedEnt = nil

-- MAKE THE GAME MODE EFGM YOU DUMBAS
function ENT:KeyValue(key, value)
	if key == "spawn_chance" then
      self.SpawnChance = tonumber(value)
	end
   
	if key == "weapon_tier" then
		self.SpawnTier = tonumber(value)
	end

	if key == "start_disabled" then
		self.StartDisabled = tonumber(value)
	end
end

-- MAKE THE GAME MODE EFGM YOU DUMBASS

function ENT:SpawnItem()

	local spawnChance = math.random(1, 100)
	
	if spawnChance <= self.SpawnChance then

		local lowTierWeapons	= {"arccw_eft_mp5", "arccw_eft_mp5sd", "arccw_eft_aks74u", "arccw_eft_ppsh", "arccw_eap_brenten", "arccw_slog_altor", "arccw_mifl_mds9", "arccw_go_870", "arccw_ur_deagle", "arccw_go_glock", "arccw_go_sw29", "arccw_go_mac10", "arccw_go_mp5", "arccw_ur_mp5", "arccw_go_mp7", "arccw_go_mp9", "arccw_go_ump", "arccw_725", "arccw_ud_glock", "arccw_mifl_fas2_mac11", "arccw_mifl_fas2_ragingbull", "arccw_mifl_fas2_toz34", "arccw_eft_usp", "arccw_eft_ump", "arccw_ud_uzi"}
		local midTierWeapons	= {"arccw_eft_mp7", "arccw_eap_csls5", "arccw_eap_fmg9", "arccw_eap_groza", "arccw_eap_spectre", "arccw_eap_stg44", "arccw_go_m1014", "arccw_go_negev", "arccw_go_nova", "arccw_go_ak47", "arccw_go_ar15", "arccw_go_aug", "arccw_go_famas", "arccw_go_m16a2", "arccw_go_ssg08", "arccw_go_p90", "arccw_go_bizon", "arccw_kilo141", "arccw_fml_mk2k", "arccw_ud_m1014", "arccw_ud_m16", "arccw_ud_mini14", "arccw_ud_870", "arccw_mifl_fas2_famas", "arccw_mifl_fas2_g3", "arccw_mifl_fas2_ks23", "arccw_mifl_fas2_m3", "arccw_mifl_fas2_rpk", "arccw_mifl_fas2_sg55x", "arccw_g36mw19", "arccw_eft_mp153", "arccw_eft_mp155", "arccw_eft_scarl", "arccw_oden", "arccw_dmi_b92f_auto", "arccw_ur_aw"}
		local highTierWeapons	 = {"arccw_dmi_c7a2_inftry", "arccw_dp28", "arccw_eft_t5000", "arccw_eap_aek", "arccw_eap_usas", "arccw_eap_xm29", "arccw_fml_blast_fc5_arc", "arccw_krissvector", "arccw_asval", "arccw_blast_pindadss2", "arccw_go_m249para", "arccw_go_mag7", "arccw_go_ace", "arccw_go_awp", "arccw_go_fnfal", "arccw_go_g3", "arccw_go_galil_ar", "arccw_go_m4", "arccw_go_scar", "arccw_go_sg556", "midnights_gso_xm8", "arccw_midnightwolf_type20", "arccw_ud_m79", "arccw_ww1_smg0818", "arccw_mifl_fas2_m24", "arccw_mifl_fas2_m82", "arccw_fml_fas2_custom_mass26", "arccw_mifl_fas2_minimi", "arccw_mifl_fas2_sr25", "arccw_mifl_fas2_ak47", "arccw_eft_scarh", "arccw_fml_mw_fo12",  "arccw_sov_tkb011"}
        local grenadeTierWeapons = {"arccw_go_nade_incendiary", "arccw_go_nade_frag", "arccw_go_nade_flash", "arccw_go_nade_smoke", "arccw_go_nade_molotov", "arccw_go_nade_knife", "arccw_go_taser", "weapon_csgo_flashbang"}

		local weps
		
		if self.SpawnTier == 0 then
			weps = lowTierWeapons
		end
		
		if self.SpawnTier == 1 then
			weps = midTierWeapons
		end
		
		if self.SpawnTier == 2 then
			weps = highTierWeapons
		end
		
		if weps then

			print("efgm_random_weapon: weps does not equal nil, proceeding...")
			
			local ent = ents.Create(weps[math.random(#weps)])
			
			if IsValid(ent) then

				if self.SpawnedEnt != nil then
					self.SpawnedEnt:Remove()
					self.SpawnedEnt = nil
				end

				local pos = self:GetPos()
				ent:SetPos(pos)
				ent:SetAngles(self:GetAngles())
				ent:Spawn()
				ent:PhysWake()

				self.SpawnedEnt = ent

				return true
			end
		end
	end

	self:TriggerOutput("OnSpawn", nil, nil)
end

-- MAKE THE GAME MODE EFGM YOU DUMBASS

function ENT:Initialize()
	if self.StartDisabled == 0 then
		self:SpawnItem()
	end
end

-- MAKE THE GAME MODE EFGM YOU DUMBASS

function ENT:AcceptInput(name, activator, caller, data)
	if name == "Respawn" then
		self:SpawnItem()
	end
end

-- MAKE THE GAME MODE EFGM YOU DUMBASS