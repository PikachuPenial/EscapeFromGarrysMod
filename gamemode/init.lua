AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("testhud.lua")
AddCSLuaFile("custom_menu.lua")
AddCSLuaFile("custom_scoreboard.lua")

include("shared.lua")
include("concommands.lua")
include("init_spawns.lua")
include("sv_stash.lua")

--Player stats.

function GM:PlayerSpawn(ply)
  ply:SetGravity(.72)
  ply:SetMaxHealth(100)
  ply:SetRunSpeed(215)
  ply:SetWalkSpeed(130)
  ply:SetJumpPower(124)
  
  local playerModels = {"models/player/eft/pmc/eft_bear/models/eft_bear_pm_summer.mdl", "models/player/eft/pmc/eft_bear/models/eft_bear_pm_redux.mdl"}
  local spawningWeapon = {"arccw_eap_lebedev", "arccw_eap_vp70", "arccw_eft_1911", "arccw_go_glock", "arccw_go_cz75", "arccw_go_fiveseven", "arccw_go_usp", "arccw_go_tec9", "arccw_go_p2000", "arccw_go_p250", "arccw_go_m9"}
  local spawningMelee = {"arccw_go_melee_knife", "arccw_go_knife_bowie", "arccw_go_knife_butterfly", "arccw_go_knife_t", "arccw_go_knife_karambit", "arccw_go_knife_m9bayonet", "arccw_go_knife_ct", "arccw_go_knife_stiletto"}
  local spawningGrenade = {"arccw_go_nade_incendiary", "arccw_go_nade_frag", "arccw_go_nade_flash", "arccw_go_nade_smoke", "arccw_go_nade_molotov", "arccw_go_nade_knife"}
  local chosenPlayerModel = playerModels[math.random(#playerModels)]
  
  ply:SetModel(playerModels[math.random(#playerModels)])
  ply:SetupHands()
  hook.Call("PlayerLoadout", GAMEMODE, ply)
  ply:Give(spawningWeapon[math.random(#spawningWeapon)])
  ply:Give(spawningMelee[math.random(#spawningMelee)])
  ply:Give(spawningGrenade[math.random(#spawningGrenade)])
  ply:Give("fas2_ifak")
  ply:RemoveAmmo(2, "grenade")
  print(chosenPlayerModel)
  
  return true
end

function GM:PlayerInitialSpawn(ply)

	victim:PrintMessage(HUD_PRINTCENTER, "If you have NOT PLAYED before, please press (F4) and check out the HELP section!")

	ply:SetNWString("playerTeam", "")
	ply:SetNWBool("inRaid", false)

	if(ply:GetPData("playerLvl") == nil) then
		ply:SetNWInt("playerLvl", 1)
	else
		ply:SetNWInt("playerLvl", tonumber(ply:GetPData("playerLvl")))
	end
	
		if(ply:GetPData("playerExp") == nil) then
		ply:SetNWInt("playerExp", 0)
	else
		ply:SetNWInt("playerExp", tonumber(ply:GetPData("playerExp")))
	end
	
		if(ply:GetPData("playerMoney") == nil) then
		ply:SetNWInt("playerMoney", 10000)
	else
		ply:SetNWInt("playerMoney", tonumber(ply:GetPData("playerMoney")))
	end
	
		if(ply:GetPData("playerKills") == nil) then
		ply:SetNWInt("playerKills", 0)
	else
		ply:SetNWInt("playerKills", tonumber(ply:GetPData("playerKills")))
	end
	
		if(ply:GetPData("playerDeaths") == nil) then
		ply:SetNWInt("playerDeaths", 0)
	else
		ply:SetNWInt("playerDeaths", tonumber(ply:GetPData("playerDeaths")))
	end
	
		if(ply:GetPData("playerKDR") == nil) then
		ply:SetNWInt("playerKDR", 1)
	else
		ply:SetNWInt("playerKDR", tonumber(ply:GetPData("playerKDR")))
	end
	
		if(ply:GetPData("playerTotalEarned") == nil) then
		ply:SetNWInt("playerTotalEarned", 0)
	else
		ply:SetNWInt("playerTotalEarned", tonumber(ply:GetPData("playerTotalEarned")))
	end
	
		if(ply:GetPData("playerTotalEarnedKill") == nil) then
		ply:SetNWInt("playerTotalEarnedKill", 0)
	else
		ply:SetNWInt("playerTotalEarnedKill", tonumber(ply:GetPData("playerTotalEarnedKill")))
	end
	
		if(ply:GetPData("playerTotalEarnedSell") == nil) then
		ply:SetNWInt("playerTotalEarnedSell", 0)
	else
		ply:SetNWInt("playerTotalEarnedSell", tonumber(ply:GetPData("playerTotalEarnedSell")))
	end
	
		if(ply:GetPData("playerDeathsSuicide") == nil) then
		ply:SetNWInt("playerDeathsSuicide", 0)
	else
		ply:SetNWInt("playerDeathsSuicide", tonumber(ply:GetPData("playerDeathsSuicide")))
	end
	
		if(ply:GetPData("playerDamageGiven") == nil) then
		ply:SetNWInt("playerDamageGiven", 0)
	else
		ply:SetNWInt("playerDamageGiven", tonumber(ply:GetPData("playerDamageGiven")))
	end
	
		if(ply:GetPData("playerDamageRecieved") == nil) then
		ply:SetNWInt("playerDamageRecieved", 0)
	else
		ply:SetNWInt("playerDamageRecieved", tonumber(ply:GetPData("playerDamageRecieved")))
	end
	
		if(ply:GetPData("playerDamageHealed") == nil) then
		ply:SetNWInt("playerDamageHealed", 0)
	else
		ply:SetNWInt("playerDamageHealed", tonumber(ply:GetPData("playerDamageHealed")))
	end

		if(ply:GetPData("playerItemsPickedUp") == nil) then
		ply:SetNWInt("playerItemsPickedUp", 0)
	else
		ply:SetNWInt("playerItemsPickedUp", tonumber(ply:GetPData("playerItemsPickedUp")))
	end
	
		if(ply:GetPData("playerDistance") == nil) then
		ply:SetNWInt("playerDistance", 0)
	else
		ply:SetNWInt("playerDistance", tonumber(ply:GetPData("playerDistance")))
	end
end

function GM:PlayerDeath(victim, inflictor, attacker)
    if(victim == attacker) then		
		victim:SetNWInt("playerDeathsSuicide", victim:GetNWInt("playerDeathsSuicide") + 1)
		
		victim:SetNWInt("playerKDR", victim:GetNWInt("playerKills") / victim:GetNWInt("playerDeaths"))
	else
		local moneyGained = math.random(1000, 3000)
	
		local expGained = math.random(425, 675)
	
		local killGained = (1)
	
		local deathGained = (1)

		attacker:SetNWInt("playerMoney", attacker:GetNWInt("playerMoney") + moneyGained)

		attacker:SetNWInt("playerExp", attacker:GetNWInt("playerExp") + expGained)
	
		attacker:SetNWInt("playerKills", attacker:GetNWInt("playerKills") + killGained)
	
		victim:SetNWInt("playerDeaths", victim:GetNWInt("playerDeaths") + deathGained)
	
		victim:SetNWInt("playerKDR", victim:GetNWInt("playerKills") / victim:GetNWInt("playerDeaths"))
	
		attacker:SetNWInt("playerKDR", attacker:GetNWInt("playerKills") / attacker:GetNWInt("playerDeaths"))
	
		attacker:SetNWInt("playerTotalEarned", attacker:GetNWInt("playerTotalEarned") + moneyGained)
	
		attacker:SetNWInt("playerTotalXpEarned", attacker:GetNWInt("playerTotalXpEarned") + expGained)
	
		attacker:SetNWInt("playerTotalEarnedKill", attacker:GetNWInt("playerTotalEarnedKill") + moneyGained)
	
		checkForLevel(attacker)
	end
end

hook.Add("PlayerDeath", "DeathMessage", function(victim, inflictor, attacker)
    if (victim == attacker) then
        victim:PrintMessage(HUD_PRINTCENTER, "You committed suicide.")
    else
		local weaponInfo = weapons.Get( attacker:GetActiveWeapon():GetClass() )
        victim:PrintMessage(HUD_PRINTCENTER, attacker:Name() .. " killed you.")
		victim:PrintMessage(HUD_PRINTCENTER, "They had an " .. weaponInfo["PrintName"]  .. ".")
    end
end )

hook.Add("PlayerHurt", "playerDamage", function(victim, attacker, remainingHealth, dmgTaken)

    attacker:SetNWInt("playerDamageGiven", attacker:GetNWInt("playerDamageGiven") + math.Round(dmgTaken, 0))
	
	victim:SetNWInt("playerDamageRecieved", victim:GetNWInt("playerDamageRecieved") + math.Round(dmgTaken, 0))

end)

hook.Add("HUDWeaponPickedUp", "WeaponPickedUp", function(weapon)
	
	ply:SetNWInt("playerItemsPickedUp", ply:GetNWInt("playerItemsPickedUp") + 1)
	
end )

function checkForLevel(ply)
    local expToLevel = (ply:GetNWInt("playerLvl") * 110) * 5.15
    local curExp = ply:GetNWInt("playerExp")
    local curLvl = ply:GetNWInt("playerLvl")

    if (curExp >= expToLevel) then
        curExp = curExp - expToLevel

        ply:SetNWInt("playerExp", curExp)
        ply:SetNWInt("playerLvl", curLvl + 1)
		
		ply:PrintMessage(HUD_PRINTCENTER, "You have leveled up to level "..(curLvl + 1)..".", Color(85, 0, 255, 255), 0)
    end
end

function GM:ShowSpare2(ply)
	if ply:GetNWBool("inRaid") == false then
		ply:ConCommand("open_game_menu")
	end
end

function GM:PlayerDisconnected(ply)
	ply:SetPData("playerLvl", ply:GetNWInt("playerLvl"))
	ply:SetPData("playerExp", ply:GetNWInt("playerExp"))
	ply:SetPData("playerMoney", ply:GetNWInt("playerMoney"))
	ply:SetPData("playerKills", ply:GetNWInt("playerKills"))
	ply:SetPData("playerDeaths", ply:GetNWInt("playerDeaths"))
	ply:SetPData("playerKDR", ply:GetNWInt("playerKDR"))
	ply:SetPData("playerTotalEarned", ply:GetNWInt("playerTotalEarned"))
	ply:SetPData("playerTotalEarnedKill", ply:GetNWInt("playerTotalEarnedKill"))
	ply:SetPData("playerTotalEarnedSell", ply:GetNWInt("playerTotalEarnedSell"))
	ply:SetPData("playerTotalXpEarned", ply:GetNWInt("playerTotalXpEarned"))
	ply:SetPData("playerTotalXpEarnedKill", ply:GetNWInt("playerTotalXpEarnedKill"))
	ply:SetPData("playerTotalXpEarnedExplore", ply:GetNWInt("playerTotalXpEarnedExplore"))
	ply:SetPData("playerTotalMoneySpent", ply:GetNWInt("playerTotalMoneySpent"))
	ply:SetPData("playerTotalMoneySpentWep", ply:GetNWInt("playerTotalMoneySpentWep"))
	ply:SetPData("playerTotalMoneySpentItem", ply:GetNWInt("playerTotalMoneySpentItem"))
	ply:SetPData("playerDeathsSuicide", ply:GetNWInt("playerDeathsSuicide"))
	ply:SetPData("playerDamageGiven", ply:GetNWInt("playerDamageGiven"))
	ply:SetPData("playerDamageRecieved", ply:GetNWInt("playerDamageRecieved"))
	ply:SetPData("playerDamageHealed", ply:GetNWInt("playerDamageHealed"))
	ply:SetPData("playerItemsPickedUp", ply:GetNWInt("playerItemsPickedUp"))
	ply:SetPData("playerDistance", ply:GetNWInt("playerDistance"))
end

function GM:ShutDown()
	for k, v in pairs(player.GetAll()) do
		v:SetPData("playerLvl", v:GetNWInt("playerLvl"))
		v:SetPData("playerExp", v:GetNWInt("playerExp"))
		v:SetPData("playerMoney", v:GetNWInt("playerMoney"))
		v:SetPData("playerKills", v:GetNWInt("playerKills"))
		v:SetPData("playerDeaths", v:GetNWInt("playerDeaths"))
		v:SetPData("playerKDR", v:GetNWInt("playerKDR"))
		v:SetPData("playerTotalEarned", v:GetNWInt("playerTotalEarned"))
		v:SetPData("playerTotalEarnedKill", v:GetNWInt("playerTotalEarnedKill"))
		v:SetPData("playerTotalEarnedSell", v:GetNWInt("playerTotalEarnedSell"))
		v:SetPData("playerTotalXpEarned", v:GetNWInt("playerTotalXpEarned"))
		v:SetPData("playerTotalXpEarnedKill", v:GetNWInt("playerTotalXpEarnedKill"))
		v:SetPData("playerTotalXpEarnedExplore", v:GetNWInt("playerTotalXpEarnedExplore"))
		v:SetPData("playerTotalMoneySpent", v:GetNWInt("playerTotalMoneySpent"))
		v:SetPData("playerTotalMoneySpentWep", v:GetNWInt("playerTotalMoneySpentWep"))
		v:SetPData("playerTotalMoneySpentItem", v:GetNWInt("playerTotalMoneySpentItem"))
		v:SetPData("playerDeathsSuicide", v:GetNWInt("playerDeathsSuicide"))
		v:SetPData("playerDamageGiven", v:GetNWInt("playerDamageGiven"))
		v:SetPData("playerDamageRecieved", v:GetNWInt("playerDamageRecieved"))
		v:SetPData("playerDamageHealed", v:GetNWInt("playerDamageHealed"))
		v:SetPData("playerItemsPickedUp", v:GetNWInt("playerItemsPickedUp"))
		v:SetPData("playerDistance", v:GetNWInt("playerDistance"))
	end
end

function GM:GravGunPunt(player, entity)
	return false
end

function GM:PlayerSay(ply, text)
	local playerMsg = string.Explode(" ", text)
	
	if (playerMsg[1] == "/dropmoney") then
		if (tonumber(playerMsg[2])) then
			local amount = tonumber(playerMsg[2])
			local plyBalance = ply:GetNWInt("playerMoney")
			
			if (amount > 0 and amount <= plyBalance) then
				ply:SetNWInt("playerMoney", plyBalance - amount)
				
				scripted_ents.Get("money"):SpawnFunction(ply, ply:GetEyeTrace(), "money"):SetValue(amount)
			end
			
			return ""
		end	
	end
end

--What da dog doin?