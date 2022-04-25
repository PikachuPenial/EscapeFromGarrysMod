ENT.Type = "point"
ENT.Base = "base_point"

ENT.SpawnChance = 1
ENT.SpawnTier = 0
ENT.StartDisabled = 0

ENT.SpawnedEnt = nil

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


function ENT:SpawnItem()

	local spawnChance = math.random(1, 100)

	if spawnChance <= self.SpawnChance then

		local lowTierWeapons	= {"arccw_eft_mp5", "arccw_eft_mp5sd", "arccw_eft_aks74u", "arccw_eft_ppsh", "arccw_eap_brenten", "arccw_slog_altor", "arccw_mifl_mds9", "arccw_ur_deagle", "arccw_725", "arccw_ud_glock", "arccw_mifl_fas2_mac11", "arccw_mifl_fas2_ragingbull", "arccw_mifl_fas2_toz34", "arccw_eft_usp", "arccw_eft_ump", "arccw_ud_uzi", "arccw_waw_mp40", "arccw_bo1_mpl", "arccw_bo1_pm63", "arccw_eap_lebedev", "arccw_eap_vp70", "arccw_waw_357", "arccw_bo2_fiveseven", "arccw_cde_m93r", "arccw_bo1_kiparis", "arccw_bo1_skorpion"}
		local midTierWeapons	= {"arccw_eft_mp7", "arccw_eap_csls5", "arccw_eap_fmg9", "arccw_eap_groza", "arccw_eap_spectre", "arccw_eap_stg44", "arccw_kilo141", "arccw_fml_mk2k", "arccw_ud_m16", "arccw_ud_mini14", "arccw_ud_870", "arccw_mifl_fas2_famas", "arccw_mifl_fas2_g3", "arccw_mifl_fas2_ks23", "arccw_mifl_fas2_m3", "arccw_mifl_fas2_rpk", "arccw_mifl_fas2_sg55x", "arccw_g36mw19", "arccw_eft_mp153", "arccw_eft_mp155", "arccw_eft_scarl", "arccw_dmi_b92f_auto", "arccw_ur_aw", "arccw_waw_thompson", "arccw_waw_type100", "arccw_bo1_g11", "arccw_bo1_aug", "arccw_bo1_xl60", "arccw_bo1_famas", "arccw_bo1_galil", "arccw_bo1_spas12", "arccw_cde_ak5", "arccw_waw_mosin", "arccw_waw_garand", "arccw_bo1_sten", "arccw_waw_trenchgun", "arccw_bo1_stoner", "arccw_bo2_lsat"}
		local highTierWeapons	 = {"arccw_dmi_c7a2_inftry", "arccw_dp28", "arccw_eft_t5000", "arccw_eap_aek", "arccw_eap_usas", "arccw_eap_xm29", "arccw_fml_blast_fc5_arc", "arccw_krissvector", "arccw_blast_pindadss2", "midnights_gso_xm8", "arccw_midnightwolf_type20", "arccw_ud_m79", "arccw_ww1_smg0818", "arccw_mifl_fas2_m24", "arccw_mifl_fas2_m82", "arccw_fml_fas2_custom_mass26", "arccw_mifl_fas2_minimi", "arccw_mifl_fas2_sr25", "arccw_mifl_fas2_ak47", "arccw_eft_scarh", "arccw_fml_mw_fo12",  "arccw_sov_tkb011", "arccw_bo1_law", "arccw_bo1_fal", "arccw_bo1_hk21", "arccw_oden", "arccw_waw_ptrs41", "arccw_waw_fg42", "arccw_bo1_m60", "arccw_waw_mg42", "arccw_bo2_vector", "arccw_bo1_dragunov", "arccw_bo1_rpk", "arccw_bo2_smr"}
		local grenadeTierWeapons = {"arccw_go_nade_incendiary", "arccw_go_nade_frag", "arccw_go_nade_flash", "arccw_go_nade_smoke", "arccw_go_nade_molotov", "arccw_go_nade_knife"}

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

		if self.SpawnTier == 3 then
			weps = grenadeTierWeapons
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


function ENT:Initialize()
	if self.StartDisabled == 0 then
		self:SpawnItem()
	end
end

function ENT:AcceptInput(name, activator, caller, data)
	if name == "Respawn" then
		self:SpawnItem()
	end
end