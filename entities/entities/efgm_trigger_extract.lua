ENT.Type = "brush"
ENT.Base = "base_brush"

ENT.ExtractTime = 1
ENT.ExtractName = ""
ENT.DisabledMessage = ""
ENT.ExtractGroup = "All"

ENT.Disabled = false
ENT.Available = 0

local playersVisted = {}

function ENT:KeyValue(key, value)
	if key == "extract_time" then
      self.ExtractTime = tonumber(value)
	end
   
	if key == "extract_name" then
		self.ExtractName = tostring(value)
	end

	if key == "disabled_message" then
		self.DisabledMessage = tostring(value)
	end

	if key == "extract_group" then
		self.ExtractGroup = tostring(value)
	end

	if key == "start_extract_disabled" then
      self.Disabled = tobool(value)
	end
   
	if key == "availability" then
		self.Available = tonumber(value)
	end

end

local function VectorInside(vec, mins, maxs)
	return (	vec.x > mins.x and vec.x < maxs.x
			and	vec.y > mins.y and vec.y < maxs.y
			and	vec.z > mins.z and vec.z < maxs.z)
end

function ENT:Initialize()

end

function ENT:CheckForPlayers()

   -- Setting variables

   local mins = self:LocalToWorld(self:OBBMins())
   local maxs = self:LocalToWorld(self:OBBMaxs())

   for iteration, ply in ipairs(player.GetAll()) do

		if IsValid(ply) and ply:Alive() then

			local pos = ply:GetPos()

			if self.ExtractGroup == "All" or self.ExtractGroup == CheckSpawnGroup(ply) then

				if VectorInside(pos, mins, maxs) then

					if self.Disabled == true then

						for k, v in pairs(playersVisted) do
							if ply == v then
								return
							end
						end

						ply:PrintMessage( HUD_PRINTTALK, self.DisabledMessage )

						table.insert(playersVisted, ply)

					return end

					if timer.Exists(ply:GetName()..self.ExtractName.."_timer") == false then

						ply:PrintMessage( HUD_PRINTTALK, "You will extract in "..self.ExtractTime.." seconds through "..self.ExtractName.."!" )

						timer.Create( ply:GetName()..self.ExtractName.."_timer" , self.ExtractTime, 1, function()

							ply:PrintMessage( HUD_PRINTTALK, "You have extracted from the raid through "..self.ExtractName.."! Good job!" )

							local lobbySpawns = ents.FindByName( "lobby_spawns" )
							local chosenSpawn = lobbySpawns[math.random(#lobbySpawns)]

							ply:SetPos(chosenSpawn:GetPos())
							ply:SetAngles(chosenSpawn:GetAngles())

							SetPlayerStatus(ply, nil, "NotInRaid")

						end)
					end

				elseif not VectorInside(pos, mins, maxs) then

					if self.Disabled == true then

						for k, v in pairs(playersVisted) do
							if ply == v then
								table.remove(playersVisted, k)
							end
						end

						return
					end

					if timer.Exists(ply:GetName()..self.ExtractName.."_timer") == true then

						ply:PrintMessage( HUD_PRINTTALK, "You have left the "..self.ExtractName.." extract!" )

						timer.Remove( ply:GetName()..self.ExtractName.."_timer" )
					end
					
				end
			
			end

		end

	end

end

function ENT:Think()
	self:CheckForPlayers()
end

function ENT:AcceptInput(name, activator, caller)
	if name == "EnableExtract" then
		self.Disabled = false
	end

	if name == "DisableExtract" then
		self.Disabled = true
	end
end
