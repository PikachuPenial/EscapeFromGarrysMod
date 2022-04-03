ENT.Type = "point"
ENT.Base = "base_point"

ENT.MainSpawnName = ""

function ENT:KeyValue(key, value)

    if key == "main_spawn" then
        self.MainSpawnName = tostring(value)
    end

end

function ENT:Initialize()
    
end