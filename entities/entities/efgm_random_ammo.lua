---- Dummy ent that just spawns a random ArcCW ammo entity and kills itself

ENT.Type = "point"
ENT.Base = "base_point"

ENT.SpawnChance = 1
ENT.SpawnTier = 0

function ENT:KeyValue(key, value)
   if key == "spawn_chance" then
      self.SpawnChance = tonumber(value)
   end

   if key == "ammo_tier" then
		self.SpawnTier = tonumber(value)
   end
end

function ENT:Initialize()

	local smallAmmo = {"arccw_ammo_smg1", "arccw_ammo_357", "arccw_ammo_pistol", "arccw_ammo_plinking", "arccw_ammo_ar2", "arccw_ammo_smg1_grenade", "arccw_ammo_buckshot", "arccw_ammo_sniper"}
	local largeAmmo = {"arccw_ammo_smg1_large", "arccw_ammo_357_large", "arccw_ammo_pistol_large", "arccw_ammo_plinking_large", "arccw_ammo_ar2_large", "arccw_ammo_smg1_grenade_large", "arccw_ammo_buckshot_large", "arccw_ammo_sniper_large"}
    local mixedAmmo = {"arccw_ammo_smg1", "arccw_ammo_357", "arccw_ammo_pistol", "arccw_ammo_plinking", "arccw_ammo_ar2", "arccw_ammo_smg1_grenade", "arccw_ammo_buckshot", "arccw_ammo_sniper", "arccw_ammo_smg1_large", "arccw_ammo_357_large", "arccw_ammo_pistol_large", "arccw_ammo_plinking_large", "arccw_ammo_ar2_large", "arccw_ammo_smg1_grenade_large", "arccw_ammo_buckshot_large", "arccw_ammo_sniper_large"}

	local ammo

	if self.SpawnTier == 0 then
		ammo = smallAmmo
	end

	if self.SpawnTier == 1 then
		ammo = largeAmmo
	end

    if self.SpawnTier == 2 then
		ammo = mixedAmmo
	end

	if ammo then

		print("efgm_random_ammo: ammo does not equal nil, proceeding...")

		local spawnChance = math.random(1, 100)

		if spawnChance <= self.SpawnChance then

			local ent = ents.Create(ammo[math.random(#ammo)])

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