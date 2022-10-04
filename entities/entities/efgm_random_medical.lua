--Dummy ent that just spawns a random medical entity and kills itself

ENT.Type = "point"
ENT.Base = "base_point"

ENT.SpawnChance = 1
ENT.SpawnTier = 0

function ENT:KeyValue(key, value)
	if key == "spawn_chance" then
		self.SpawnChance = tonumber(value)
	end

	if key == "med_tier" then
		self.SpawnTier = tonumber(value)
	end
end

function ENT:Initialize()

	local random = {"fas2_ammo_bandages", "fas2_ammo_quikclots", "fas2_ammo_hemostats"}
	local bandages = {"fas2_ammo_bandages"}
	local quikclots = {"fas2_ammo_quikclots"}
	local hemostats = {"fas2_ammo_hemostats"}

	local med

	if self.SpawnTier == 0 then
		med = random
	end

	if self.SpawnTier == 1 then
		med = bandages
	end

	if self.SpawnTier == 2 then
		med = quikclots
	end

	if self.SpawnTier == 3 then
		med = hemostats
	end

	if med then

		print("efgm_random_medical: Spawning Medical Ammo")

		local spawnChance = math.random(1, 100)

		if spawnChance <= self.SpawnChance then

			local ent = ents.Create(med[math.random(#med)])

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