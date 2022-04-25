
hook.Add("Initialize", "BetterPlayerDataInitialization", function()

    sql.Query( "CREATE TABLE IF NOT EXISTS BetterPlayerData ( PlayerID INTEGER, Key TEXT, Value TEXT )" )

end)

function SetPData64(player, key, dataValue)

    -- Create / update entry in BetterPlayerData table with key

    print("Player steam id = " .. player:SteamID64())
    print("Key = " .. SQLStr( key ))

    local value = sql.Query( "SELECT Value FROM BetterPlayerData WHERE PlayerID = " .. player:SteamID64() .. " AND Key = " .. SQLStr( key ) .. ";" )

    if value == nil then

        -- If we need to make a new PData entry

        sql.Query( "INSERT INTO BetterPlayerData ( PlayerID, Key, Value ) VALUES( " .. player:SteamID64() .. ", " .. SQLStr( key ) .. ", " .. SQLStr( dataValue ) .. ")" )

    end

    if value != nil then

        -- If we need to update an existing entry

        sql.Query( "UPDATE BetterPlayerData SET Value = " .. SQLStr( dataValue ) .. " WHERE PlayerID = " .. player:SteamID64() .. " AND Key = " .. SQLStr( key ) .. ";" )

    end

    PrintTable( sql.Query( "SELECT * FROM BetterPlayerData WHERE PlayerID = " .. player:SteamID64() .. " AND Key = " .. SQLStr( key ) .. ";" ) )

end

function GetPData64(player, key)

    local value = sql.QueryValue( "SELECT Value FROM BetterPlayerData WHERE PlayerID = " .. player:SteamID64() .. " AND Key = " .. SQLStr( key ) .. ";" )

    return value

end

function RemovePData64(player, key)

    sql.Query( " DELETE FROM BetterPlayerData WHERE PlayerID = " .. player:SteamID64() .. " AND Key = " .. SQLStr( key ) .. ";" )

end