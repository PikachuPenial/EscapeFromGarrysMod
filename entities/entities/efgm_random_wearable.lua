---- Dummy ent that just spawns a random EFT wearable and kills itself

ENT.Type = "point"
ENT.Base = "base_point"

ENT.SpawnChance = 1
ENT.SpawnTier = 0

function ENT:KeyValue(key, value)
	if key == "spawn_chance" then
		self.SpawnChance = tonumber(value)
	end

	if key == "wearable_tier" then
		self.SpawnTier = tonumber(value)
	end
end

function ENT:Initialize()

	local gasMasks =	{"ent_jack_gmod_ezarmor_gp5", "ent_jack_gmod_ezarmor_sotr"}
	local goggles =	{"ent_jack_gmod_ezarmor_pnv10t", "ent_jack_gmod_ezarmor_t7thermal"}
	local mixed =	{"ent_jack_gmod_ezarmor_gp5", "ent_jack_gmod_ezarmor_sotr", "ent_jack_gmod_ezarmor_pnv10t", "ent_jack_gmod_ezarmor_t7thermal"}

	local wearables

	if self.SpawnTier == 0 then
		wearables = gasMasks
	end

	if self.SpawnTier == 1 then
		wearables = goggles
	end

	if self.SpawnTier == 2 then
		wearables = mixed
	end

	if wearables then

		print("efgm_random_wearable: Spawning Wearables")

		local spawnChance = math.random(1, 100)

		if spawnChance <= self.SpawnChance then

			local ent = ents.Create(wearables[math.random(#wearables)])

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