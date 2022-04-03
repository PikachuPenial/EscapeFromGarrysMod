ENT.Type = "point"
ENT.Base = "base_point"

ENT.SpawnType = 0
ENT.SpawnGroup = ""
ENT.SpawnName = ""

function ENT:KeyValue(key, value)

    if key == "spawn_type" then
        self.SpawnType = tonumber(value)
    end

    if key == "spawn_group" then
        self.SpawnGroup = tostring(value)
    end

    if key == "targetname" then
        self.SpawnName = tostring(value)
    end

end

function ENT:Initialize()
    
end