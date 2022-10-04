--Dummy ent that just spawns a random face shield entity and kills itself

ENT.Type = "point"
ENT.Base = "base_point"

ENT.SpawnChance = 1
ENT.SpawnTier = 0

function ENT:KeyValue(key, value)
	if key == "spawn_chance" then
		self.SpawnChance = tonumber(value)
	end

	if key == "shield_tier" then
		self.SpawnTier = tonumber(value)
	end
end

function ENT:Initialize()

	local weakShields =	{"ent_jack_gmod_ezarmor_shpmface", "ent_jack_gmod_ezarmor_twexfilshieldc"}
	local strongShields =	{"ent_jack_gmod_ezarmor_altynface", "ent_jack_gmod_ezarmor_rystface", "ent_jack_gmod_ezarmor_weldingkill", "ent_jack_gmod_ezarmor_shlemmaskkilla"}
	local mixed =	{"ent_jack_gmod_ezarmor_shpmface", "ent_jack_gmod_ezarmor_twexfilshieldc", "ent_jack_gmod_ezarmor_altynface", "ent_jack_gmod_ezarmor_rystface", "ent_jack_gmod_ezarmor_weldingkill", "ent_jack_gmod_ezarmor_shlemmaskkilla"}

	local shields

	if self.SpawnTier == 0 then
		shields = weakShields
	end

	if self.SpawnTier == 1 then
		shields = strongShields
	end

	if self.SpawnTier == 2 then
		shields = mixed
	end

	if shields then

		print("efgm_random_shield: Spawning Face Shields")

		local spawnChance = math.random(1, 100)

		if spawnChance <= self.SpawnChance then

			local ent = ents.Create(shields[math.random(#shields)])

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