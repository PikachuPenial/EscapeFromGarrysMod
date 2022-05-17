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

	local midTierHelmets =	{"ent_jack_gmod_ezarmor_shlemofon", "ent_jack_gmod_ezarmor_shpmhelm", "ent_jack_gmod_ezarmor_untarhelm", "ent_jack_gmod_ezarmor_ssh68", "ent_jack_gmod_ezarmor_mich2001"}
	local highTierHelmets =	{"ent_jack_gmod_ezarmor_twexfilb", "ent_jack_gmod_ezarmor_ulachcoyote", "ent_jack_gmod_ezarmor_maska1shkilla", "ent_jack_gmod_ezarmor_altyn", "ent_jack_gmod_ezarmor_ryst"}

	local helmets

	if self.SpawnTier == 0 then
		helmets = midTierHelmets
	end

	if self.SpawnTier == 1 then
		helmets = highTierHelmets
	end

	if helmets then

		print("efgm_random_helmet: Spawning Helmets")

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