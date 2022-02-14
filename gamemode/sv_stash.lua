
util.AddNetworkString( "RequestStash" )
util.AddNetworkString( "SendStash" )

util.AddNetworkString( "TakeFromStash" )
util.AddNetworkString( "PutWepInStash" )

util.AddNetworkString( "StashMenuReload" )

local function SendStashToClient(player)

    local value = sql.Query( "SELECT * FROM stash_table WHERE ItemOwner = " .. player:SteamID64() .. ";" )

    print("stash request received")

    if value != nil then

        PrintTable(value)

        net.Start( "SendStash" )
        net.WriteTable( value )
        net.Send(player)

    end

end

net.Receive("RequestStash",function (len, ply)

    print("got request to show stash")
    SendStashToClient(ply)
	
end)

net.Receive("PutWepInStash",function (len, ply)

    local item = net.ReadString()
    local count = 1
    local type = SQLStr("wep", false)

    if ply:HasWeapon( item ) == false then print("Player does not have " .. item .. "!") return end

    local highestID = sql.QueryValue( "SELECT MAX(UniqueID) FROM stash_table;" )

    if highestID == "NULL" then highestID = 1 end

    print("The highest ID found in stash_table is " .. highestID)

    sql.Query( "INSERT INTO stash_table ( ItemName, ItemCount, ItemType, ItemOwner, UniqueID ) VALUES( " .. SQLStr(item, false) .. ", " .. count .. ", " .. type .. ", " .. ply:SteamID64() .. ", " .. highestID + 1 ..")" )
    print("Added into SQL Table (stash_table): " .. SQLStr(item, false) .. " " .. count .. " " .. type .. " " .. ply:SteamID64() .. " ".. highestID + 1 .."!")
    print("Last SQL Error = " .. tostring(sql.LastError()))

    ply:StripWeapon( item )

    net.Start("StashMenuReload")
    net.Send(ply)
	
end)

net.Receive("TakeFromStash",function (len, ply)

    requestedItemName = net.ReadString()
    stashItemName = sql.QueryValue( "SELECT ItemName FROM stash_table WHERE ItemName = " .. sql.SQLStr(requestedItemName) .. ";" )
    
    if(stashItemName != nil) then

        local lowestID = sql.QueryValue( "SELECT UniqueID FROM stash_table WHERE ItemName = " .. sql.SQLStr(stashItemName) .. " AND ItemOwner = " .. ply:SteamID64() .. " AND UniqueID = ( SELECT MIN(UniqueID) FROM stash_table WHERE ItemName = " .. sql.SQLStr(stashItemName) .. ");" )
        print("The lowest ID found in stash_table is" .. lowestID)

        sql.Query( "DELETE FROM stash_table WHERE UniqueID = " .. lowestID .. ";" )

        ply:Give(stashItemName, true)

        net.Start( "StashMenuReload" )
        net.Send(ply)
    end

end)























-- Debug Console Commands

local function CreateTable(ply)

    sql.Query( "CREATE TABLE IF NOT EXISTS stash_table ( ItemName TEXT, ItemCount INTEGER, ItemType TEXT, ItemOwner INTEGER, UniqueID INTEGER )" )
    
end


local function ConsoleReturnStashContents(ply, cmd, args)

    if ply:IsAdmin() == false then return end

    local value = sql.Query( "SELECT * FROM stash_table;" )

    if(value != nil) then
        PrintTable(value)
        print("Last SQL Error = " .. tostring(sql.LastError()))
    end

end
concommand.Add("read_stash", ConsoleReturnStashContents)


local function ConsoleWriteStashContents(ply, cmd, args)

    if ply:IsAdmin() == false then return end

    local item = SQLStr(args[1], false)
    local count = args[2]
    local type = SQLStr(args[3], false)

    local highestID = sql.QueryValue( "SELECT MAX(UniqueID) FROM stash_table;" )

    if highestID == "NULL" then highestID = 1 end

    print("The highest ID found in stash_table is" .. highestID)

    sql.Query( "INSERT INTO stash_table ( ItemName, ItemCount, ItemType, ItemOwner, UniqueID ) VALUES( " .. item .. ", " .. count .. ", " .. type .. ", " .. ply:SteamID64() .. ", " .. highestID + 1 ..")" )
    print("Last SQL Error = " .. tostring(sql.LastError()))

end
concommand.Add("write_stash", ConsoleWriteStashContents)

local function WipeTable(ply, cmd, args)

    if ply:IsAdmin() == false then return end

    sql.Query( " DELETE FROM stash_table; " )

    print("Last SQL Error = " .. tostring(sql.LastError()))

end
concommand.Add("delete_stash", WipeTable)

local function ConsoleDropTable(ply, cmd, args)

    if ply:IsAdmin() == false then return end

    sql.Query( "DROP TABLE stash_table;" )

    CreateTable(ply)

end
concommand.Add("reset_stash", ConsoleDropTable)