-- Task should be layed out like this

-- ["TaskName"] =          "Name shown to the player",
-- ["TaskDescription"] =   "Description shown to the player",
-- ["TaskObjectives"] =    "Objectives shown to the player, seperated by |",

-- ["TaskGiver"] =         "Name of the person or trader who gave the task",
-- ["TaskNextName"] =      "Exact name of next task, must be exact and the task must exist, if it leads to no task simply put nil",

-- ["TaskRewards"] =       "Rewards shown to the player, seperated by |"

-- Current tasks are not permanent, and mostly for debugging

local subtaskIncompleteText =   "i"
local subtaskCompleteText =     "c"

local taskPossibleObjectives = {"locate", "find", "extract"}

local taskStartup = {
    ["TaskName"] =          "Startup",
    ["TaskDescription"] =   "Get these fucking PMCs out of concrete, please for the love of god ple-",
    ["TaskObjectives"] =    "Kill 3 PMCs in concrete|Extract from concrete",

    ["TaskGiver"] =         "Gunner",
    ["TaskNextName"] =      "Fetch Mission",

    ["TaskRewards"] =       "5000 Roubles|AK-47",

    ["TaskMap"] =           "efgm_concrete"
}

local taskBlueprint = {
    ["TaskName"] =          "Fetch Mission",
    ["TaskDescription"] =   "Get a blueprint from concrete, in that yellow building with the fancy wooden doors, idk why its important trust me!11!1",
    ["TaskObjectives"] =    "Retrieve the Warehouse Blueprint|Extract from concrete",

    ["TaskGiver"] =         "Gunner",
    ["TaskNextName"] =      nil,

    ["TaskRewards"] =       "8000 Roubles|M4A1",

    ["TaskMap"] =           "efgm_concrete"
}

local debug1 = {
    ["TaskName"] =                  "Debug - Part 1",
    ["TaskDescription"] =           "Do the shit i dare you",
    ["TaskObjectives"] =            "Locate special area and extract from tasktest",

    ["TaskGiver"] =                 "Gunner",
    ["TaskNextName"] =              nil,

    ["TaskRewards"] =               "5000 Roubles|AK-47",

    ["TaskMap"] =                   "efgm_tasktest",

    ["TaskInternalConditions"] =     "resetondeath_true",
    ["TaskInternalObjectiveCount"] = 2
}

local taskList = {taskStartup, taskBlueprint, debug1}

function AssignStartingTasks(player)

    sql.Query( "INSERT INTO TaskTable ( TaskUser, TaskID, TaskObjectives ) VALUES( " .. SQLStr( player:SteamID64() ) .. ", " .. 3 .. ", " .. SQLStr( "i i" ) .. " )" )

    print("Last SQL Error = " .. tostring(sql.LastError()))

end
concommand.Add("efgm_assign_tasks", AssignStartingTasks)

function CompleteSubtask(player, taskID, taskObjective)

    -- figure out which subtask to mark as complete

    local objectives = tostring( sql.QueryValue( "SELECT TaskObjectives FROM TaskTable WHERE TaskUser = " .. SQLStr( player:SteamID64() ) .. " AND TaskID = " .. SQLStr( taskID ) .. ";" ) )

    -- print("Last SQL Error = " .. tostring(sql.LastError()))

    -- print(objectives)

    -- write the subtask as complete

    local explodedObjectives = string.Explode( " ", objectives )

    explodedObjectives[taskObjective] = subtaskCompleteText

    implodedObjectives = string.Implode( " ", explodedObjectives )

    print( "imploded objectives: "..implodedObjectives )

    -- set the subtask as completed

    sql.Query( "UPDATE TaskTable SET TaskObjectives = " .. SQLStr( implodedObjectives ) .. " WHERE TaskUser = " .. SQLStr( player:SteamID64() ) .. " AND TaskID = " .. SQLStr( taskID ) .. ";" )

    local numberOfSubtasks = taskList[tonumber( taskID )].TaskInternalObjectiveCount
    print(numberOfSubtasks)

    local numberOfCompletedSubtasks = 0

    for k, v in pairs(explodedObjectives) do

        if v == "c" then
            numberOfCompletedSubtasks = numberOfCompletedSubtasks + 1
        end

    end

    print(numberOfCompletedSubtasks .. " out of " .. numberOfSubtasks)

    if numberOfCompletedSubtasks == numberOfSubtasks then
        print("YOU COMPLETED THE TASK HOLY SHIT IM A GOD")
    end

end

local function FindPlayerTaskIDs(player)

    local taskIDs = sql.Query( "SELECT TaskID FROM TaskTable WHERE TaskUser = " .. SQLStr( player:SteamID64() ) .. ";" )

    local actualTaskIDs = {}

    for k, v in pairs(taskIDs) do

        table.insert( actualTaskIDs, v.TaskID )

    end

    PrintTable(actualTaskIDs)

    return actualTaskIDs

end

local function CreateTaskTable()

    sql.Query( "CREATE TABLE IF NOT EXISTS TaskTable ( TaskUser INTEGER, TaskID INTEGER, TaskObjectives TEXT )" )

    print("Last SQL Error = " .. tostring(sql.LastError()))

end

hook.Add( "Initialize", "CreateTaskList", function()

	CreateTaskTable()

end )

hook.Add( "PlayerExtract", "PlayerExtracted", function(ply)

	for k, v in pairs(FindPlayerTaskIDs(ply)) do
        if v == tostring(3) then
            print("completing subtask")

            CompleteSubtask(ply, 3, 2)
        end
    end

end )

local function ResetTaskTable(ply, cmd, args)

    if ply:IsAdmin() == false then return end

    sql.Query( "DROP TABLE TaskTable;" )

    print("Last SQL Error = " .. tostring(sql.LastError()))

    CreateTaskTable()

end
concommand.Add("efgm_reset_tasks", ResetTaskTable)

local function CheckCurrentTasks(ply, cmd, args)

    local value = tonumber( sql.QueryValue( "SELECT TaskID FROM TaskTable WHERE TaskUser = " .. SQLStr( ply:SteamID64() ) .. ";" ) )

    if(value != nil) then
        PrintTable( taskList[ value ] )
        print("Last SQL Error = " .. tostring(sql.LastError()))
    end

end
concommand.Add("efgm_print_tasks", CheckCurrentTasks)