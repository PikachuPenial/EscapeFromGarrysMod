ENT.Type = "point"
ENT.Base = "base_point"

-- These are defined by the entity in hammer

ENT.SpawnType = 0
ENT.SpawnGroup = ""
ENT.SpawnName = ""

-- These are defined by myself eat shit hammer

ENT.TeamSpawnVectors = {}

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
    
    self:SetupTeamSpawnVectors()

end

function ENT:SetupTeamSpawnVectors()

    print("Setting Up Team Spawn Vectors")

    local xSpawns = 3
    local ySpawns = 3

    local spawnOffset = 64

    local gridX = (xSpawns - 1) * spawnOffset
    local gridY = (ySpawns - 1) * spawnOffset

    -- This sets up a grid (xSpawns, ySpawns) around the raid spawn. In each vertex of the grid, we will check if it is empty or not, and if it is empty we add this vector to the spawn table.

    for x=1, xSpawns do

        for y=1, ySpawns do

            -- God i fucking hope this works first time i have no idea what this does and its only been a solid minute from writing it

            local spawnVector = self:GetPos() +  Vector( x * spawnOffset, y * spawnOffset, 0 ) - Vector( gridX, gridY, 0 )

            local tr = {
                start = spawnVector,
                endpos = spawnVector,
                mins = Vector( -16, -16, 0 ),
                maxs = Vector( 16, 16, 71 )
            }

            local hullTrace = util.TraceHull( tr )

            if hullTrace.Hit == true then

                -- print("Team spawn vector at (" .. x .. ", " .. y ..") destroyed; not enough space at target location!")

            elseif hullTrace.Hit == false then

                if spawnVector != self:GetPos() then

                    table.insert( self.TeamSpawnVectors, spawnVector + Vector(0, 0, 8))

                end

            end

        end

    end

    if #self.TeamSpawnVectors < 5 then

        print("Raid spawn was too cramped, removing...")

        self:Remove()

    end

end