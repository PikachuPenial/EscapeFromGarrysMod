
util.AddNetworkString( "RequestStash" )
util.AddNetworkString( "SendStash" )

util.AddNetworkString( "TakeFromStash" )
util.AddNetworkString( "PutWepInStash" )

util.AddNetworkString( "StashMenuReload" )

local function SendStashToClient(player)

    local value = sql.Query( "SELECT * FROM stash_table WHERE ItemOwner = " .. player:SteamID64() .. " ORDER BY ItemName;" )

    print("stash request received")

    if value != nil then

        -- PrintTable(value)

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

    sql.Query( "INSERT INTO stash_table ( ItemName, ItemCount, ItemType, ItemOwner ) VALUES( " .. SQLStr(item, false) .. ", " .. count .. ", " .. type .. ", " .. ply:SteamID64() .. ")" )
    print("Added into SQL Table (stash_table): " .. SQLStr(item, false) .. " " .. count .. " " .. type .. " " .. ply:SteamID64() .. "!")
    print("Last SQL Error = " .. tostring(sql.LastError()))

    ply:StripWeapon( item )

    net.Start("StashMenuReload")
    net.Send(ply)
	
end)

net.Receive("TakeFromStash",function (len, ply)

    requestedItemName = net.ReadString()
    stashItemName = sql.QueryValue( "SELECT ItemName FROM stash_table WHERE ItemName = " .. sql.SQLStr(requestedItemName) .. " AND ItemOwner = " .. ply:SteamID64() .. ";" )
    
    if(stashItemName != nil) then

        local items = sql.Query( "SELECT ItemName FROM stash_table WHERE ItemName = " .. sql.SQLStr(requestedItemName) .. " AND ItemOwner = " .. ply:SteamID64() .. ";" )

        local amountOfItems = #items

        local amountOfItemsMinusOne = amountOfItems - 1

        print("Amount of items matching is " .. amountOfItems)

        sql.Query( "DELETE FROM stash_table WHERE ItemName = " .. sql.SQLStr(stashItemName) .. " AND ItemOwner = " .. ply:SteamID64() .. ";" )
        print("Last SQL Error = " .. tostring(sql.LastError()))

        for i=1, amountOfItemsMinusOne do 

            sql.Query( "INSERT INTO stash_table ( ItemName, ItemCount, ItemType, ItemOwner ) VALUES( " .. SQLStr(requestedItemName, false) .. ", " .. 1 .. ", " .. SQLStr( "wep" ) .. ", " .. ply:SteamID64() .. ")" )

        end

        ply:Give(stashItemName, true)

        net.Start( "StashMenuReload" )
        net.Send(ply)

    end

end)























-- Debug Console Commands

local function CreateTable(ply)

    sql.Query( "CREATE TABLE IF NOT EXISTS stash_table ( ItemName TEXT, ItemCount INTEGER, ItemType TEXT, ItemOwner INTEGER )" )
    
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

    sql.Query( "INSERT INTO stash_table ( ItemName, ItemCount, ItemType, ItemOwner ) VALUES( " .. item .. ", " .. count .. ", " .. type .. ", " .. ply:SteamID64() .. ")" )
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