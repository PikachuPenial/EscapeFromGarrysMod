ENT.Type = "point"
ENT.Base = "base_point"

ENT.SpawnChance = 1
ENT.SpawnTier = 0
ENT.StartDisabled = 0

ENT.SpawnedEnt = nil

function ENT:KeyValue(key, value)
	if key == "spawn_chance" then
		self.SpawnChance = tonumber(value)
	end

	if key == "nade_tier" then
		self.SpawnTier = tonumber(value)
	end

	if key == "start_disabled" then
		self.StartDisabled = tonumber(value)
	end
end


function ENT:SpawnItem()

	local spawnChance = math.random(1, 100)

	if spawnChance <= self.SpawnChance then

		local grenadeTierWeapons = {"arccw_go_nade_incendiary", "arccw_go_nade_frag", "arccw_go_nade_flash", "arccw_go_nade_smoke", "arccw_go_nade_molotov", "arccw_go_nade_knife"}

		local nades

		if self.SpawnTier == 0 then
			nades = grenadeTierWeapons
		end

		if nades then

			print("efgm_random_nade: Spawning Grenades")

			local ent = ents.Create(nades[math.random(#nades)])

			if IsValid(ent) then

				if self.SpawnedEnt != nil then
					self.SpawnedEnt:Remove()
					self.SpawnedEnt = nil
				end

				local pos = self:GetPos()
				ent:SetPos(pos)
				ent:SetAngles(self:GetAngles())
				ent:Spawn()
				ent:PhysWake()

				self.SpawnedEnt = ent

				return true
			end
		end
	end

	self:TriggerOutput("OnSpawn", nil, nil)
end


function ENT:Initialize()
	if self.StartDisabled == 0 then
		self:SpawnItem()
	end
end

function ENT:AcceptInput(name, activator, caller, data)
	if name == "Respawn" then
		self:SpawnItem()
	end
end