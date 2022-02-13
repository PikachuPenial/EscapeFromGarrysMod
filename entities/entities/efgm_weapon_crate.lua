ENT.Type = "point"
ENT.Base = "base_point"

ENT.SpawnChance = 10
ENT.StartDisabled = 0
ENT.CrateTier = 0
ENT.DoRespawn = 0
ENT.RespawnTime = 0

ENT.SpawnedEnt = nil

-- MAKE THE GAME MODE EFGM YOU DUMBAS
function ENT:KeyValue(key, value)
	-- This is the chance the crate will spawn in the first place.
	if key == "spawn_chance" then
      self.SpawnChance = tonumber(value)
	end

	-- If the crate will spawn by default, or if it needs to be triggered to spawn.
	if key == "start_disabled" then
		self.StartDisabled = tonumber(value)
	end

	-- Which crate type will spawn?
	if key == "crate_tier" then
		self.CrateTier = tonumber(value)
	end

	-- Will the crate respawn?
	if key == "crate_respawn" then
		self.DoRespawn = tonumber(value)
	end

	-- Time it takes for crate to respawn.
	if key == "respawn_timer" then
		self.RespawnTime = tonumber(value)
	end
end

-- MAKE THE GAME MODE EFGM YOU DUMBASS

function ENT:SpawnItem()
	
	if !IsValid(self.SpawnedEnt) then

		local spawnChance = math.random(1, 10)
		
		if spawnChance <= self.SpawnChance then

			local crates = {"efgm_weapon_crate_low", "efgm_weapon_crate_mid", "efgm_weapon_crate_high", "efgm_weapon_crate_utility"}

			local ent = ents.Create(crates[self.CrateTier + 1])

			if IsValid(ent) then
				
				self.SpawnedEnt = ent
				
				local pos = self:GetPos()
				ent:SetPos(pos)
				ent:SetAngles(self:GetAngles())
				ent:Spawn()
				ent:PhysWake()
			end
		end
	end

	self:TriggerOutput("OnSpawn", nil, nil)
end

-- MAKE THE GAME MODE EFGM YOU DUMBASS

function ENT:Initialize()
	if self.StartDisabled == 0 then
		self:SpawnItem()
	end
end

-- MAKE THE GAME MODE EFGM YOU DUMBASS

function ENT:AcceptInput(name, activator, caller, data)
	if name == "Respawn" then
		self:SpawnItem()
	end
end

-- MAKE THE GAME MODE EFGM YOU DUMBASS