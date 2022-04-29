ENT.Type = "point"
ENT.Base = "base_point"

ENT.SellMenuOpen = false

function ENT:Initialize()

end

-- This prepares a message to be sent to whatever gui script you have to open the sell menu

util.AddNetworkString("SellMenuTable")
util.AddNetworkString("SellItem")

net.Receive("SellItem",function (len, ply)

	tempTable = net.ReadTable()

	ItemSell(tempTable[1], tempTable[2], tempTable[3], tempTable[4])

end)

-- This function activated if a player (ply) presses the use key on it

function ENT:OpenMenu(ply)

	-- This checks if the person who activated it is a player, not really necessary but good to have

	if not ply:IsPlayer() then return end

	-- This takes some explaining. What this does is broadcasts the activator entity (the player) out.
	-- Your GUI script should recieve the message, take this entity, compare it to the client, and if this player matches the client, it opens the gui.
	-- I could've messaged all that, but comments last longer.

	local sellTable = {ply, self}

	net.Start("SellMenuTable")
	net.WriteTable(sellTable)
	net.Send(ply)

	ply:ConCommand("open_game_menu")

end

function ENT:AcceptInput(name, ply, caller)
	if name == "OpenSellGUI" then
	self:OpenMenu(ply)
	end
end

function ItemSell(ply, weapon, value, weaponName)

	-- Makes sure player actually has the weapon they want to sell.
	-- This probably doesn't account for their inventory because thats from an addon, but I wouldn't know how to integrate that.

	if not ply:HasWeapon(weapon) then



		return

	elseif ply:HasWeapon(weapon) then

		ply:SetNWInt("playerMoney", ply:GetNWInt("playerMoney") + value)
		ply:SetNWInt("playerTotalEarned", ply:GetNWInt("playerTotalEarned") + value)
		ply:SetNWInt("playerTotalEarnedSell", ply:GetNWInt("playerTotalEarnedSell") + value)

		local charExpGain = (ply:GetNWInt("charismaExperience") + value)
		local charExp = charExpGain / 1750

		ply:SetNWInt("charismaExperience", ply:GetNWInt("charismaExperience") + charExp)
		checkForCharisma(ply)

		ply:StripWeapon(weapon)

		ply:PrintMessage(HUD_PRINTTALK, "You have successfully sold your " .. weaponName .. " for " .. value .. " roubles!")

	end

end

function checkForCharisma(ply)
	local charismaExpToLevel = (ply:GetNWInt("charismaLevel") * 5)
	local charismaCurExp = ply:GetNWInt("charismaExperience")
	local charismaCurLvl = ply:GetNWInt("charismaLevel")

	if (charismaCurExp >= charismaExpToLevel) then
		charismaCurExp = charismaCurExp - charismaExpToLevel

		ply:SetNWInt("charismaExperience", charismaCurExp)
		ply:SetNWInt("charismaLevel", charismaCurLvl + 1)

		ply:SetNWInt("charismaEffect", ply:GetNWInt("charismaEffect") - 0.01)

		ply:PrintMessage(HUD_PRINTCENTER, "You have leveled Charisma to level " .. (charismaCurLvl + 1) .. ".", Color(85, 0, 255, 255), 0)
	end
end
