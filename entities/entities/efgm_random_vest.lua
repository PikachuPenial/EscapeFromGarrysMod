--Dummy ent that just spawns a random vest entity and kills itself

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

	local midTierVests =	{"ent_jack_gmod_ezarmor_module3m", "ent_jack_gmod_ezarmor_paca", "ent_jack_gmod_ezarmor_untar", "ent_jack_gmod_ezarmor_zhukpress", "ent_jack_gmod_ezarmor_trooper"}
	local highTierVests =	{"ent_jack_gmod_ezarmor_6b13flora", "ent_jack_gmod_ezarmor_korundvm", "ent_jack_gmod_ezarmor_6b13m", "ent_jack_gmod_ezarmor_hexgrid", "ent_jack_gmod_ezarmor_slicktan"}

	local vests

	if self.SpawnTier == 0 then
		vests = midTierVests
	end

	if self.SpawnTier == 1 then
		vests = highTierVests
	end

	if vests then

		print("efgm_random_vest: Spawning Vests")

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