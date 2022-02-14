ENT.Type = "point"
ENT.Base = "base_point"

util.AddNetworkString("OpenStashGUI")
util.AddNetworkString("CloseStashGUI")
util.AddNetworkString("StripWeapon")
util.AddNetworkString("StripAmmo")
util.AddNetworkString("GiveWeapon")
util.AddNetworkString("GiveAmmo")

net.Receive("StripWeapon",function (len, ply)

	tempTable = net.ReadTable()

	ply = tempTable[1]
	wep = tempTable[2]

	ply:StripWeapon(wep:GetClass())
	
end)

net.Receive("GiveWeapon",function (len, ply)

	tempTable = net.ReadTable()

	ply = tempTable[1]
	wep = tempTable[2]

	ply:Give(wep, true)
	
end)

net.Receive("StripAmmo",function (len, ply)

	tempTable = net.ReadTable()

	ply = tempTable[1]
	ammo = tempTable[2]

	ply:SetAmmo( 0, ammo )
	
end)

net.Receive("GiveAmmo",function (len, ply)

	tempTable = net.ReadTable()

	ply = tempTable[1]
	ammo = tempTable[2]

	ply:SetAmmo( 90, ammo )
	
end)

function ENT:AcceptInput(name, ply, caller)
    if name == "OpenStash" then

		local stashMenuTable = {ply}

        net.Start("OpenStashGUI")
			net.WriteTable(stashMenuTable)
		net.Send(ply)

    end

	if name == "CloseStash" then

		for k, v in pairs(player.GetAll()) do
			net.Start("CloseStashGUI")
				net.WriteBool(false)
			net.Broadcast()
		end

    end
end