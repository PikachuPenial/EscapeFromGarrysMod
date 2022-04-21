---- Dummy ent that just spawns a random medical entity and kills itself

ENT.Type = "point"
ENT.Base = "base_point"

ENT.SpawnChance = 1
ENT.SpawnTier = 0

function ENT:KeyValue(key, value)
   if key == "spawn_chance" then
      self.SpawnChance = tonumber(value)
   end
   
   if key == "attach_tier" then
		self.SpawnTier = tonumber(value)
   end
end

function ENT:Initialize()

    local all = {"acwatt_go_optic_barska", "acwatt_go_supp_osprey", "acwatt_go_foregrip_stubby"}
	local optics = {"acwatt_go_optic_barska"}
	local barrels = {"acwatt_go_supp_osprey"}
    local foregrips = {"acwatt_go_foregrip_stubby"}

	local attach
	
	if self.SpawnTier == 0 then
		attach = all
	end
	
	if self.SpawnTier == 1 then
		attach = optics
	end

    if self.SpawnTier == 2 then
		attach = barrels
	end

    if self.SpawnTier == 3 then
		attach = foregrips
	end
	
	if attach then
		
		local spawnChance = math.random(1, 100)
		
		if spawnChance <= self.SpawnChance then
			
			local ent = ents.Create(attach[math.random(#attach)])
			
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