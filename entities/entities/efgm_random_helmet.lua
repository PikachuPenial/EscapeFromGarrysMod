---- Dummy ent that just spawns a random EFT Helmet and kills itself

ENT.Type = "point"
ENT.Base = "base_point"

ENT.SpawnChance = 1
ENT.SpawnTier = 0

function ENT:KeyValue(key, value)
   if key == "spawn_chance" then
      self.SpawnChance = tonumber(value)
   end
   
   if key == "helmet_tier" then
		self.SpawnTier = tonumber(value)
   end
end

function ENT:Initialize()

	local midTierHelmets =	{"helmet_6b47", "helmet_6b47_2", "helmet_kiver", "helmet_lzsh", "helmet_psh97", "helmet_shpm", "helmet_untar"}
	local highTierHelmets =	{"helmet_achhc_black", "helmet_achhc_green","helmet_maska_1sch", "helmet_maska_1sch_killa", "helmet_opscore", "helmet_opscore_visor", "helmet_ulach", "helmet_zsh1_2m"}

	local helmets
	
	if self.SpawnTier == 0 then
		helmets = midTierHelmets
	end
	
	if self.SpawnTier == 1 then
		helmets = highTierHelmets
	end
	
	if helmets then
		
		local spawnChance = math.random(1, 100)
		
		if spawnChance <= self.SpawnChance then
			
			local ent = ents.Create(helmets[math.random(#helmets)])
			
			if IsValid(ent) then
				local pos = self:GetPos()
				ent:SetPos(pos)
				ent:SetAngles(self:GetAngles())
				ent:Spawn()
				ent:PhysWake()
			end
		end

	self:Remove()
	end
end