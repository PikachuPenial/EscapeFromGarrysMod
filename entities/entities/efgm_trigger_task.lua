ENT.Type = "brush"
ENT.Base = "base_brush"

ENT.TaskID				= 0
ENT.TaskObjective		= 0

ENT.TaskNameInternal	= ""
ENT.TaskNameExternal	= ""

function ENT:KeyValue(key, value)
	if key == "task_number" then
		self.TaskID = tonumber(value)
	end

	if key == "task_objective" then
		self.TaskObjective = tonumber(value)
	end

	if key == "task_name_internal" then
		self.TaskNameInternal = tostring(value)
	end

	if key == "task_name_external" then
		self.TaskNameExternal = tostring(value)
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

			if VectorInside(pos, mins, maxs) then

				CompleteSubtask(ply, self.TaskID, self.TaskObjective)

				print("sent to server to complete task")

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
