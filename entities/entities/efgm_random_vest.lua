---- Dummy ent that just spawns a random EFT Vest and kills itself

ENT.Type = "point"
ENT.Base = "base_point"

ENT.SpawnChance = 1
ENT.SpawnTier = 0

function ENT:KeyValue(key, value)
   if key == "spawn_chance" then
      self.SpawnChance = tonumber(value)
   end
   
   if key == "vest_tier" then
		self.SpawnTier = tonumber(value)
   end
end

function ENT:Initialize()

	local midTierVests =	{"vest_3m", "vest_6b5", "vest_6b23_1", "vest_bnti_kirasa", "vest_paca", "vest_untar", "vest_zhuk3"}
	local highTierVests =	{"vest_6b13_1", "vest_6b13_2", "vest_6b13_m", "vest_6b23_2", "vest_6b43", "vest_a18", "vest_bnti_gzhel_k", "vest_iotv_gen4_full", "vest_m2", "vest_trooper", "vest_wartech_tv110", "vest_zhuk6"}

	local vests
	
	if self.SpawnTier == 0 then
		vests = midTierVests
	end
	
	if self.SpawnTier == 1 then
		vests = highTierVests
	end
	
	if vests then
		
		local spawnChance = math.random(1, 100)
		
		if spawnChance <= self.SpawnChance then
			
			local ent = ents.Create(vests[math.random(#vests)])
			
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