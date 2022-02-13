---- Dummy ent that just spawns a random EFT Armor and kills itself

ENT.Type = "point"
ENT.Base = "base_point"

ENT.SpawnChance = 1
ENT.SpawnTier = 0

function ENT:KeyValue(key, value)
   if key == "spawn_chance" then
      self.SpawnChance = tonumber(value)
   end
   
   if key == "armor_tier" then
		self.SpawnTier = tonumber(value)
   end
end

function ENT:Initialize()

	local midArmor =	{"helmet_6b47", "helmet_6b47_2", "helmet_kiver", "helmet_lzsh", "helmet_psh97", "helmet_shpm", "helmet_untar", "vest_3m", "vest_6b5", "vest_6b23_1", "vest_bnti_kirasa", "vest_paca", "vest_untar", "vest_zhuk3"}
	local highArmor =	{"helmet_achhc_black", "helmet_achhc_green","helmet_maska_1sch", "helmet_maska_1sch_killa", "helmet_opscore", "helmet_opscore_visor", "helmet_ulach", "helmet_zsh1_2m", "vest_6b13_1", "vest_6b13_2", "vest_6b13_m", "vest_6b23_2", "vest_6b43", "vest_a18", "vest_bnti_gzhel_k", "vest_iotv_gen4_full", "vest_m2", "vest_trooper", "vest_wartech_tv110", "vest_zhuk6"}

	local armor
	
	if self.SpawnTier == 0 then
		armor = midTierArmor
	end
	
	if self.SpawnTier == 1 then
		armor = highTierArmor
	end
	
	if armor then
		
		local spawnChance = math.random(1, 100)
		
		if spawnChance <= self.SpawnChance then
			
			local ent = ents.Create(armor[math.random(#armor)])
			
			if IsValid(ent) then
				local pos = self:GetPos()
				ent:SetPos(pos)
				ent:SetAngles(self:GetAngles())
				ent:Spawn()
				ent:PhysWake()

				self.SpawnedEnt = ent

				return true
			end
		end

	self:Remove()
	end
end