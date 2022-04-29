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

	local midArmor =	{}
	local highArmor =	{}

	table.Add(midArmor, midVests)
	table.Add(midArmor, midHelmets)

	table.Add(highArmor, highVests)
	table.Add(highArmor, highHelmets)

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