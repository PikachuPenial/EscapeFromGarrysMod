AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("testhud.lua")
AddCSLuaFile("custom_menu.lua")
AddCSLuaFile("custom_scoreboard.lua")

include("shared.lua")
include("concommands.lua")
include("init_spawns.lua")

--Player stats.

function GM:PlayerSpawn(ply)
  ply:SetGravity(.72)
  ply:SetMaxHealth(100)
  ply:SetRunSpeed(200)
  ply:SetWalkSpeed(125)
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
end

function GM:PlayerDeath(victim, inflictor, attacker)
    if(attacker == victim) then return end
	
	local moneyGained = math.random(1000, 3000)
	
	local expGained = math.random(425, 675)

    attacker:SetNWInt("playerMoney", attacker:GetNWInt("playerMoney") + moneyGained)

    attacker:SetNWInt("playerExp", attacker:GetNWInt("playerExp") + expGained)
	
	checkForLevel(attacker)
end

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
	ply:ConCommand("open_game_menu")
end

function GM:PlayerDisconnected(ply)
	ply:SetPData("playerLvl", ply:GetNWInt("playerLvl"))
	ply:SetPData("playerExp", ply:GetNWInt("playerExp"))
	ply:SetPData("playerMoney", ply:GetNWInt("playerMoney"))
end

function GM:ShutDown()
	for k, v in pairs(player.GetAll()) do
		v:SetPData("playerLvl", v:GetNWInt("playerLvl"))
		v:SetPData("playerExp", v:GetNWInt("playerExp"))
		v:SetPData("playerMoney", v:GetNWInt("playerMoney"))
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