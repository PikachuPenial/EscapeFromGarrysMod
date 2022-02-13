
function GM:Initialize()

    -- table contains variables IsStackable(bool), ItemName(string), ItemCount(int), ItemOwner(Steam64)

    sql.Query( "CREATE TABLE IF NOT EXISTS stash_table ( IsStackable INTEGER, ItemName TEXT, ItemCount INTEGER, ItemOwner INTEGER )" )

end


local function ReadStash()

end


local function WriteStashIndex()

end


local function ConsoleReturnStashContents(ply, cmd, args)

    local value = sql.Query( "SELECT * FROM stash_table ;" )
    PrintTable(value)
    print("Last SQL Error = " .. tostring(sql.LastError()))

end
concommand.Add("read_stash", ConsoleReturnStashContents)


local function ConsoleWriteStashContents(ply, cmd, args)

    local stackable = tostring(tobool(args[1]))
    local item = SQLStr(args[2], false)
    local count = args[3]
    local owner = ply:SteamID64()

    print(stackable .. "\n" .. item .. "\n" .. count .. "\n" .. owner)

    local returnedTable = sql.Query( "INSERT INTO stash_table ( IsStackable, ItemName, ItemCount, ItemOwner ) VALUES( " .. stackable .. ", " .. item .. ", " .. count .. ", " .. owner ..")" )
    print(returnedTable)
    print("Last SQL Error = " .. tostring(sql.LastError()))

end
concommand.Add("write_stash", ConsoleWriteStashContents)

local function WipeTable(ply, cmd, args)

    local returnedTable = sql.Query( " DELETE FROM stash_table; " )

    print(returnedTable)
    print("Last SQL Error = " .. tostring(sql.LastError()))

end
concommand.Add("delete_stash", WipeTable)