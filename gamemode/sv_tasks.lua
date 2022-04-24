-- Each task should be layed out like this

-- ["TaskName"] =                       "Name shown to the player"
-- ["TaskDescription"] =                "Description shown to the player"
-- ["TaskObjectives"] =                 "Objectives shown to the player, seperated by |"

-- ["TaskGiver"] =                      "Name of the person or trader who gave the task"
-- ["TaskNextName"] =                   "Exact name of next task, must be exact and the task must exist, if it leads to no task simply put nil"

-- ["TaskRewards"] =                    "Rewards shown to the player, seperated by |"

-- ["TaskMap"] =                        "map task needs to be completed on"

-- ["TaskInternalConditions"] =         "Possible conditions include: resetondeath_true. These complicate the task, for example if reset on death is set to true, the player will lose all progress if they die. Think Bunker Part 2 levels of bs."
-- ["TaskInternalObjectives"] =         "Possible objectives include: extract_<mapname>, locate_<triggername>. Space out each task with a space so it can be FUCKING EXPLODED easier." (god i love lua)
-- ["TaskInternalObjectiveCount"] =     2

-- Current tasks are not permanent, and mostly for debugging

local subtaskIncompleteText =   "incomplete"
local subtaskCompleteText =     "complete"

local taskPossibleObjectives = {"locate", "find", "extract", "kill"}

local taskDaily = {}

local debug1 = {
    ["TaskName"] =                      "Debug - Part 1",
    ["TaskDescription"] =               "Do the shit i dare you",
    ["TaskObjectives"] =                "Locate special area 1|Locate special area 2|Locate special area 3|Extract from tasktest",

    ["TaskGiver"] =                     "Gunner",
    ["TaskNextID"] =                    3,

    ["TaskRewards"] =                   "5000 Roubles|AK-47",

    ["TaskMap"] =                       "efgm_tasktest",

    ["TaskInternalConditions"] =        "resetondeath_true",
    ["TaskInternalObjectives"] =       "locate_SpecialSpot01 locate_SpecialSpot02 locate_SpecialSpot03 extract_tasktest",
    ["TaskInternalObjectiveCount"] =    4,
    ["TaskInternalObjectiveLayout"] =   "incomplete incomplete incomplete incomplete",
    ["TaskInternalRewards"] =           "money_5000 gun_weapon_arccw_ak47"
}

local debug2 = {
    ["TaskName"] =                      "Debug - Part 2",
    ["TaskDescription"] =               "Holy shit, you did the shit, ong impressive, kill shit now i gotta test more shit",
    ["TaskObjectives"] =                "Kill 5 People",

    ["TaskGiver"] =                     "Gunner",
    ["TaskNextID"] =                    nil,

    ["TaskRewards"] =                   "7500 Roubles|AK-47",

    ["TaskMap"] =                       "efgm_tasktest",

    ["TaskInternalConditions"] =        "resetondeath_true",
    ["TaskInternalObjectives"] =       "kill_5",
    ["TaskInternalObjectiveCount"] =    1,
    ["TaskInternalObjectiveLayout"] =   "0/5",
    ["TaskInternalRewards"] =           "money_7500 gun_weapon_arccw_ak47"
}

local taskList = {taskDaily, debug1, debug2}


util.AddNetworkString("SendTaskInfo")
util.AddNetworkString("RequestTaskInfo")

util.AddNetworkString("TaskComplete")

local function SendTaskInfo(ply)

    if sql.Query( "SELECT TaskID FROM TaskTable WHERE TaskUser = " .. SQLStr( ply:SteamID64() ) .. ";" ) == nil then return end

    net.Start("SendTaskInfo")

    local tasks = sql.Query( "SELECT TaskID FROM TaskTable WHERE TaskUser = " .. SQLStr( ply:SteamID64() ) .. ";" )

    local numberOfTasks = #tasks

    print(numberOfTasks .. " tasks active!")

    local taskTable = {}

    PrintTable(tasks)

    for k, v in pairs(tasks) do

        local taskID = tonumber( v.TaskID )

        PrintTable(taskList[taskID])

        local tasksCompleted = sql.QueryValue( "SELECT TaskObjectives FROM TaskTable WHERE TaskUser = " .. ply:SteamID64() .. " AND TaskID = " .. taskID .. ";" )

        local isTaskComplete = sql.QueryValue( "SELECT TaskCompleted FROM TaskTable WHERE TaskUser = " .. ply:SteamID64() .. " AND TaskID = " .. taskID .. ";" )

        local tempTable = {taskList[taskID].TaskName, taskList[taskID].TaskDescription, taskList[taskID].TaskObjectives, taskList[taskID].TaskGiver, taskList[taskID].TaskRewards, taskID, tasksCompleted, isTaskComplete}

        -- task name, description, objectives, giver, rewards, id

        table.insert(taskTable, tempTable)

    end

    net.WriteTable(taskTable)

    net.Send(ply)

end

net.Receive("RequestTaskInfo",function (len, ply)

    SendTaskInfo(ply)

end)

net.Receive("TaskComplete",function (len, ply)

    if FinishTask(ply, net.ReadInt(12)) == true then

        SendTaskInfo(ply)

    end

end)

local function GenerateDailyTask(ply, dailyTaskID)

    taskDaily = {
        ["TaskName"] =                      "",
        ["TaskDescription"] =               "",
        ["TaskObjectives"] =                "",

        ["TaskGiver"] =                     "The Camera",
        ["TaskNextID"] =                    nil,

        ["TaskRewards"] =                   "7500 Roubles|AK-47",

        ["TaskMap"] =                       "efgm_tasktest",

        ["TaskInternalConditions"] =        "resetondeath_true",
        ["TaskInternalObjectives"] =       "kill_5",
        ["TaskInternalObjectiveCount"] =    1,
        ["TaskInternalObjectiveLayout"] =   "0/5",
        ["TaskInternalRewards"] =           "money_7500 gun_weapon_arccw_ak47"
    }

    -- sql.Query( "INSERT INTO TaskTable ( TaskUser, TaskID, TaskObjectives, TaskCompleted ) VALUES( " .. ply:SteamID64() .. ", " .. nextTaskId .. ", " .. SQLStr( taskList[nextTaskId].TaskInternalObjectiveLayout ) .. ", " .. 0 .. " )" )

end

local function FindPlayerTaskIDs(player)

    local taskIDs = sql.Query( "SELECT TaskID FROM TaskTable WHERE TaskUser = " .. SQLStr( player:SteamID64() ) .. ";" )

    print("Last SQL Error = " .. tostring(sql.LastError()))

    if taskIDs == false then return nil end
    if taskIDs == nil then return nil end

    local actualTaskIDs = {}

    for k, v in pairs(taskIDs) do

        table.insert( actualTaskIDs, v.TaskID )

    end

    PrintTable(actualTaskIDs)

    return actualTaskIDs

end

function FinishTask(ply, taskID)

    local nextTaskId = taskList[taskID].TaskNextID

    task = tonumber( sql.QueryValue( "SELECT TaskCompleted FROM TaskTable WHERE TaskUser = " .. SQLStr( ply:SteamID64() ) .. " AND TaskID = " .. taskID .. ";" ) )

    if task == 1 then
        sql.Query( "DELETE FROM TaskTable WHERE TaskID = " .. taskID .. " AND TaskUser = " .. ply:SteamID64() .. ";" )

        if taskList[taskID].TaskNextID != nil then

            sql.Query( "INSERT INTO TaskTable ( TaskUser, TaskID, TaskObjectives, TaskCompleted ) VALUES( " .. ply:SteamID64() .. ", " .. nextTaskId .. ", " .. SQLStr( taskList[nextTaskId].TaskInternalObjectiveLayout ) .. ", " .. 0 .. " )" )

            print("Last SQL Error = " .. tostring(sql.LastError()))

        end

        return true

    else

        print("Task isnt completed you fucking donut")

        return false

    end

end
concommand.Add("efgm_complete_task", function(ply, cmd, args)

    local taskID = tonumber(args[1])

    FinishTask(ply, taskID)

end)

function AssignStartingTasks(ply)

    if ply:IsAdmin() == false then return end

    sql.Query( "INSERT INTO TaskTable ( TaskUser, TaskID, TaskObjectives, TaskCompleted ) VALUES( " .. ply:SteamID64() .. ", " .. 2 .. ", " .. SQLStr( taskList[2].TaskInternalObjectiveLayout ) .. ", " .. 0 .. " )" )

    print("Last SQL Error = " .. tostring(sql.LastError()))

end
concommand.Add("efgm_assign_tasks", AssignStartingTasks)

local function CheckIfTaskComplete(player, taskID)

    local objectives = tostring( sql.QueryValue( "SELECT TaskObjectives FROM TaskTable WHERE TaskUser = " .. SQLStr( player:SteamID64() ) .. " AND TaskID = " .. SQLStr( tostring( taskID ) ) .. ";" ) )

    local numberOfObjectives = taskList[tonumber(taskID)].TaskInternalObjectiveCount
    local numberOfCompletedObjectives = 0

    local explodedObjectives = string.Explode(" ", objectives)

    for k, v in pairs(explodedObjectives) do

        print(v)

        if v == subtaskCompleteText then
            numberOfCompletedObjectives = numberOfCompletedObjectives + 1
        end



    end

    if numberOfCompletedObjectives == numberOfObjectives then

        print("YOU COMPLETED THE TASK HOLY SHIT IM A GOD")

        player:PrintMessage( HUD_PRINTTALK, taskList[ taskID ].TaskName .. " Ready for Completion.")

        sql.Query( "UPDATE TaskTable SET TaskCompleted = " .. SQLStr( 1 ) .. " WHERE TaskUser = " .. SQLStr( player:SteamID64() ) .. " AND TaskID = " .. SQLStr( tostring( taskID ) ) .. ";" )

    end

end

function AddKillSubtask(player, taskID, taskObjective)

    if FindPlayerTaskIDs(player) == nil then return end

    local objectives = tostring( sql.QueryValue( "SELECT TaskObjectives FROM TaskTable WHERE TaskUser = " .. SQLStr( player:SteamID64() ) .. " AND TaskID = " .. SQLStr( tostring( taskID ) ) .. ";" ) )

    -- print("Task objectives are: "..objectives)

    local explodedObjectives = string.Explode(" ", objectives)

    local killCount = explodedObjectives[ taskObjective ]

    print("Kill count is: " .. killCount)

    local explodedKillCount = string.Explode("/", killCount)

    -- currentKills = explodedKillCount[1]
    -- neededKills = explodedKillCount[2]

    explodedKillCount[1] = explodedKillCount[1] + 1

    implodedKillCount = string.Implode("/", explodedKillCount)

    explodedObjectives[ taskObjective ] = implodedKillCount

    implodedObjectives = string.Implode(" ", explodedObjectives)

    print("Imploded Kill Count (New) = " .. implodedKillCount)

    if tonumber( explodedKillCount[1] ) == tonumber( explodedKillCount[2] ) then

        player:PrintMessage( HUD_PRINTTALK, taskList[ taskID ].TaskName .. " Subtask Completed.")

        sql.Query( "UPDATE TaskTable SET TaskObjectives = " .. SQLStr( subtaskCompleteText ) .. " WHERE TaskUser = " .. SQLStr( player:SteamID64() ) .. " AND TaskID = " .. SQLStr( tostring( taskID ) ) .. ";" )

        CheckIfTaskComplete(player, taskID)

    else

        print(explodedKillCount[1] .. " != " .. explodedKillCount[2])

        sql.Query( "UPDATE TaskTable SET TaskObjectives = " .. SQLStr( implodedObjectives ) .. " WHERE TaskUser = " .. SQLStr( player:SteamID64() ) .. " AND TaskID = " .. SQLStr( tostring( taskID ) ) .. ";" )

    end

end

function CompleteSubtask(player, taskID, taskObjective)

    if FindPlayerTaskIDs(player) == nil then return end

    local doesPlayerHaveThisTask = false

    for k, v in pairs(FindPlayerTaskIDs(player)) do

        if tonumber(v) == taskID then doesPlayerHaveThisTask = true break end

    end

    if doesPlayerHaveThisTask == false then return end

    local objectives = tostring( sql.QueryValue( "SELECT TaskObjectives FROM TaskTable WHERE TaskUser = " .. SQLStr( player:SteamID64() ) .. " AND TaskID = " .. SQLStr( tostring( taskID ) ) .. ";" ) )

    -- write the subtask as complete

    local explodedObjectives = string.Explode( " ", objectives )

    if explodedObjectives[ taskObjective ] == subtaskCompleteText then print("this subtask is completed fucking retard") return end

    explodedObjectives[taskObjective] = subtaskCompleteText

    implodedObjectives = string.Implode( " ", explodedObjectives )

    print( "imploded objectives: " .. implodedObjectives )

    -- set the subtask as completed

    sql.Query( "UPDATE TaskTable SET TaskObjectives = " .. SQLStr( implodedObjectives ) .. " WHERE TaskUser = " .. SQLStr( player:SteamID64() ) .. " AND TaskID = " .. SQLStr( tostring( taskID ) ) .. ";" )

    player:PrintMessage( HUD_PRINTTALK, taskList[ taskID ].TaskName .. " Subtask Completed.")

    CheckIfTaskComplete(player, taskID)

end

local function CreateTaskTable()

    sql.Query( "CREATE TABLE IF NOT EXISTS TaskTable ( TaskUser INTEGER, TaskID INTEGER, TaskObjectives TEXT, TaskCompleted INTEGER )" )

    print("Last SQL Error = " .. tostring(sql.LastError()))

end

hook.Add( "Initialize", "CreateTaskList", function()

    CreateTaskTable()

end )

hook.Add( "PlayerDeath", "OnPMCKilled", function( victim, inflictor, attacker )

    if attacker:IsPlayer() == false then return end

    if FindPlayerTaskIDs(attacker) == nil then return end

    for h, j in pairs(FindPlayerTaskIDs(attacker)) do

        local taskObjectives = taskList[ tonumber( j ) ].TaskInternalObjectives

        print(taskObjectives)

        -- converts all objectives into singular objectives in a table

        local taskObjectivesExploded = string.Explode( " ", taskObjectives )

        PrintTable(taskObjectivesExploded)

        for k, v in pairs( taskObjectivesExploded ) do

            if string.find( v, "kill" ) != nil then

                -- v[k] == kill_<number>

                tableForShit = string.Explode( "_", v )

                PrintTable(tableForShit)

                for iter, b in pairs ( tableForShit ) do

                    if mapName == game.GetMap() or mapName == nil then

                        print("adding kill to subtask number " .. k)

                        AddKillSubtask(attacker, tonumber( j ), k)

                        break

                    end

                end

                break

            end

        end
    end

end)

hook.Add( "PlayerExtract", "PlayerExtracted", function(ply)

    if FindPlayerTaskIDs(ply) == nil then return end

    for h, j in pairs(FindPlayerTaskIDs(ply)) do

        local taskObjectives = taskList[ tonumber( j ) ].TaskInternalObjectives

        print(taskObjectives)

        -- converts all objectives into singular objectives in a table

        local taskObjectivesExploded = string.Explode( " ", taskObjectives )

        PrintTable(taskObjectivesExploded)

        for k, v in pairs( taskObjectivesExploded ) do

            if string.find( v, "extract" ) != nil then

                -- v[k] == extract_<mapname>

                tableForShit = string.Explode( "_", v )

                PrintTable(tableForShit)

                for iter, b in pairs ( tableForShit ) do

                    -- b == <mapname>

                    local mapName = "efgm_" .. b

                    if mapName == game.GetMap() then

                        print("completing subtask number " .. k)

                        CompleteSubtask(ply, tonumber( j ), k)

                    end

                end

            end

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

    if (value != nil) then

        local taskTable = { taskList[ value ].TaskName, taskList[ value ].TaskDescription, taskList[ value ].TaskObjectives, taskList[ value ].TaskGiver, }

        PrintTable( taskTable )
        print("Last SQL Error = " .. tostring(sql.LastError()))
    end

end
concommand.Add("efgm_print_tasks", CheckCurrentTasks)