
util.AddNetworkString( "RequestStash" )
util.AddNetworkString( "SendStash" )

util.AddNetworkString( "TakeFromStash" )
util.AddNetworkString( "PutWepInStash" )

util.AddNetworkString( "StashMenuReload" )

local numberOfWeps

local function UpdateWeaponsInStash(ply)

    local weaponsInStash = {}

    local weaponsInStash = sql.Query( "SELECT ItemName FROM stash_table WHERE ItemOwner = " .. ply:SteamID64() .. ";" )

    -- table.IsEmpty(weaponsInStash) == true or

    if weaponsInStash == nil then

        numberOfWeps = 0

    else

        numberOfWeps = #weaponsInStash

    end

    ply:SetNWInt("ItemsInStash", tostring(numberOfWeps))

end

local function SendStashToClient(player)

    local value = sql.Query( "SELECT * FROM stash_table WHERE ItemOwner = " .. player:SteamID64() .. " ORDER BY ItemName;" )

    UpdateWeaponsInStash(player)

    if value != nil then

        net.Start( "SendStash" )
        net.WriteTable( value )
        net.Send(player)

    end

end

net.Receive("RequestStash",function (len, ply)

    SendStashToClient(ply)

end)

net.Receive("PutWepInStash",function (len, ply)

    UpdateWeaponsInStash(ply)

    local stashItemLimit = ply:GetNWInt("playerStashLimit")

    if tonumber( numberOfWeps ) == tonumber( stashItemLimit ) then print("You have too much shit in your stash, clear it out! Your limit is " .. stashItemLimit .. " by the way.") return end

    local item = net.ReadString()
    local count = 1
    local type = SQLStr("wep", false)

    if ply:HasWeapon( item ) == false then print("Player does not have " .. item .. "!") return end

    sql.Query( "INSERT INTO stash_table ( ItemName, ItemCount, ItemType, ItemOwner ) VALUES( " .. SQLStr(item, false) .. ", " .. count .. ", " .. type .. ", " .. ply:SteamID64() .. ")" )

    ply:StripWeapon( item )

    UpdateWeaponsInStash(ply)

    net.Start("StashMenuReload")
    net.Send(ply)

end)

net.Receive("TakeFromStash",function (len, ply)

    UpdateWeaponsInStash(ply)

    requestedItemName = net.ReadString()
    stashItemName = sql.QueryValue( "SELECT ItemName FROM stash_table WHERE ItemName = " .. sql.SQLStr(requestedItemName) .. " AND ItemOwner = " .. ply:SteamID64() .. ";" )

    if (stashItemName != nil) then

        local items = sql.Query( "SELECT ItemName FROM stash_table WHERE ItemName = " .. sql.SQLStr(requestedItemName) .. " AND ItemOwner = " .. ply:SteamID64() .. ";" )

        local amountOfItems = #items

        local amountOfItemsMinusOne = amountOfItems - 1

        sql.Query( "DELETE FROM stash_table WHERE ItemName = " .. sql.SQLStr(stashItemName) .. " AND ItemOwner = " .. ply:SteamID64() .. ";" )

        for i = 1, amountOfItemsMinusOne do

            sql.Query( "INSERT INTO stash_table ( ItemName, ItemCount, ItemType, ItemOwner ) VALUES( " .. SQLStr(requestedItemName, false) .. ", " .. 1 .. ", " .. SQLStr( "wep" ) .. ", " .. ply:SteamID64() .. ")" )

        end

        ply:Give(stashItemName, true)

        UpdateWeaponsInStash(ply)

        net.Start( "StashMenuReload" )
        net.Send(ply)

    end

end)

-- Debug Console Commands

local function CreateTable()

    sql.Query( "CREATE TABLE IF NOT EXISTS stash_table ( ItemName TEXT, ItemCount INTEGER, ItemType TEXT, ItemOwner INTEGER )" )

end

hook.Add( "Initialize", "StashCreate", function()

    CreateTable()

end )

local function ConsoleReturnStashContents(ply, cmd, args)

    if ply:IsAdmin() == false then return end

    local value = sql.Query( "SELECT * FROM stash_table;" )

    if (value != nil) then
        PrintTable(value)
    end

end
concommand.Add("efgm_read_stashes", ConsoleReturnStashContents)


local function ConsoleWriteStashContents(ply, cmd, args)

    if ply:IsAdmin() == false then return end

    local item = SQLStr(args[1], false)
    local count = args[2]
    local type = SQLStr(args[3], false)

    sql.Query( "INSERT INTO stash_table ( ItemName, ItemCount, ItemType, ItemOwner ) VALUES( " .. item .. ", " .. count .. ", " .. type .. ", " .. ply:SteamID64() .. ")" )

end
concommand.Add("efgm_write_stashes", ConsoleWriteStashContents)

local function WipeTable(ply, cmd, args)

    if ply:IsAdmin() == false then return end

    sql.Query( " DELETE FROM stash_table; " )


end
concommand.Add("efgm_delete_stashes", WipeTable)

local function ConsoleDropTable(ply, cmd, args)

    if ply:IsAdmin() == false then return end

    sql.Query( "DROP TABLE stash_table;" )

    CreateTable(ply)

end
concommand.Add("efgm_reset_all_stashes", ConsoleDropTable)