local raidTimeLeft = "Raid has not started."
local timerRed = false

local hudInRaid = false

local checkExtractsBind = "o"
local contextMenuBind = input.LookupBinding("+menu_context")
local leanLeftBind = input.LookupBinding("+alt1")
local leanRightBind = input.LookupBinding("+alt2")
local dropBind = input.LookupBinding("+drop")
local inventoryBind = "i"
local tacticalBind = input.LookupBinding("impulse 100")
local fireModeBind = input.LookupBinding("+zoom")
local helpBind = input.LookupBinding("gm_showhelp")
local teamBind = input.LookupBinding("gm_showteam")
local armorBind = input.LookupBinding("gm_showspare1")
local shopBind = input.LookupBinding("gm_showspare2")
local walkBind = input.LookupBinding("+walk")
local interactBind = input.LookupBinding("+use")

--color array, saving space
local white = Color(255, 255, 255, 255)
local red = Color(255, 0, 0, 255)

net.Receive("RaidTimeLeft",function (len, ply)

	raidTimeLeft = net.ReadString()
	timerRed = net.ReadBool()

end)

function HUD()
	local client = LocalPlayer()

	if !client:Alive() then
		return
	end

	hudInRaid = client:GetNWBool("inRaid")

-- Team Hud

	if client:GetNWString("playerTeam") != "" then

		local playerColor
		local teamMembers = FindAllInTeam(client:GetNWString("playerTeam"))

		for k, v in pairs(teamMembers) do

			local leaderText = ""

			if v:GetNWBool("teamLeader") == true then
				leaderText = "* "
			end

			if v:Alive() then
				if v:GetNWBool("inRaid") == true then
					playerColor = Color(50, 255, 50, 255)
				end

				if v:GetNWBool("inRaid") == false then
					playerColor = Color(255, 255, 255)
				end
			else
				playerColor = Color(255, 50, 50, 255)
			end


			draw.SimpleText(leaderText .. v:GetName(), "DermaLarge", ScrW() - 10, 5 + ((k - 1) * 35), playerColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

		end

	end

--Gun Hud

	if (client:GetActiveWeapon():IsValid()) and (client:GetActiveWeapon():GetPrintName() != nil) then
		draw.SimpleText("Holding: " .. client:GetActiveWeapon():GetPrintName(), "DermaDefaultBold", 205, ScrH() - 58, white, 0, 0)

		--draw.SimpleText("[LOW Tier]", "DermaDefault", 230, ScrH() - 72, Color(255, 0, 0, 255), 1)
		--draw.SimpleText("[MID Tier]", "DermaDefault", 230, ScrH() - 72, Color(255, 255, 0, 255), 1)
		--draw.SimpleText("[HIGH Tier]", "DermaDefault", 232, ScrH() - 72, Color(0, 255, 0, 255), 1)
		--draw.SimpleText("[UTIL Tier]", "DermaDefault", 232, ScrH() - 72, Color(0, 0, 255, 255), 1)
	end

--Money And Or XP Hud	

	local expToLevel = (client:GetNWInt("playerLvl") * 140) * 5.15

	draw.SimpleText("Level " .. client:GetNWInt("playerLvl"), "DermaDefaultBold", 50, ScrH() - 38, white, 0)

	if (client:GetNWInt("playerLvl") < 26) then
		draw.SimpleText("EXP: " .. math.Round(client:GetNWInt("playerExp")) .. "/" .. expToLevel, "DermaDefaultBold", 50, ScrH() - 22, Color(255, 255, 255), 0)
	else
		draw.SimpleText("Max Leveled", "DermaDefaultBold", 50, ScrH() - 22, Color(255, 255, 255), 0)
	end

	draw.SimpleText("₽ " .. math.Round(client:GetNWInt("playerMoney")), "DermaDefaultBold", 100, ScrH() - 38, white, 0)
	draw.SimpleText("JOIN OUR DISCORD - discord.gg/Wb9cVUwvTV", "DermaDefaultBold", 375, ScrH() - 22, Color(58, 235, 52, 255), 0)
	draw.SimpleText("Press " .. "I" .. " to access your inventory", "DermaDefaultBold", 170, ScrH() - 38, Color(255, 166, 0, 255), 0)
	draw.SimpleText("Press " .. shopBind .. " for shop, stats, and help", "DermaDefaultBold", 170, ScrH() - 22, Color(255, 166, 0, 255), 0)

	-- Timer

	local colorBlack = Color(255, 255, 255, 255)
	local colorRed = Color(255, 0, 0, 255)

	local timerColor = Color(255, 255, 255, 255)

	if timerRed == false then
		timerColor = colorBlack
	else
		timerColor = colorRed
	end

	local timeText = "Time Remaining ^"
	local mapSwitchText = "Time Until Map Switches"

	if timerRed == true then
		timeText = mapSwitchText

		draw.SimpleText("MAP IS RESETING: TRANSFER ANYTHING YOU WANT TO KEEP INTO YOUR STASH, OR YOU WILL LOSE YOUR ITEMS.", "DermaLarge", ScrW() / 2, 775, colorRed, 1)
	end

	draw.SimpleText(raidTimeLeft, "DermaLarge", 28, ScrH() - 305, timerColor, 0)
	draw.SimpleText(timeText, "DermaDefaultBold", 28, ScrH() - 275, timerColor, 0)

	-- Control hints while in lobby
	if CLIENT and GetConVar("efgm_hidebinds"):GetInt() == 0 then
	if (hudInRaid == false) then
		if (checkExtractsBind == nil) then
			checkExtractsBind = "#"
			checkExtractsBind = red
		end
		if (contextMenuBind == nil) then
			contextMenuBind = "#"
			contextMenuColor = red
		end
		if (leanLeftBind == nil) then
			leanLeftBind = "#"
			leanLeftColor = red
		end
		if (leanRightBind == nil) then
			leanRightBind = "#"
			leanRightColor = red
		end
		if (dropBind == nil) then
			dropBind = "#"
			dropColor = red
		end
		if (tacticalBind == nil) then
			tacticalBind = "#"
			tacticalColor = red
		end
		if (fireModeBind == nil) then
			fireModeBind = "#"
			fireModeColor = red
		end
		if (helpBind == nil) then
			helpBind = "#"
			helpBind = red
		end
		if (armorBind == nil) then
			armorBind = "#"
			armorBind = red
		end
		if (teamBind == nil) then
			teamBind = "#"
			teamBind = red
		end
		if (shopBind == nil) then
			shopBind = "#"
			shopColor = red
		end
		if (walkBind == nil) then
			walkBind = "#"
			walkBind = red
		end
		if (interactBind == nil) then
			interactBind = "#"
			interactBind = red
		end

		if (inPlayerMenu == false) and (inMapVoteMenu == false) and (inStashMenu == false) and (inRaidSummaryMenu == false) then
				draw.SimpleText("[Controls] : " .. "efgm_hidebinds to toggle UI", "DermaLarge", 135, 20, Color(0, 200, 255, 255), 0)
				draw.SimpleText("# = Not Binded", "DermaLarge", 135, 50, red, 0)
				draw.SimpleText("Use the developer console to set binds", "Trebuchet24", 325, 54, red, 0)
			
				draw.SimpleText("[" .. checkExtractsBind .. "]", "Trebuchet24", 135, 80, spawnMenuColor, 0)
				draw.SimpleText("Check Extracts", "Trebuchet24", 165, 80, white, 0)

				draw.SimpleText("[" .. contextMenuBind .. "]", "Trebuchet24", 135, 105, contextMenuColor, 0)
				draw.SimpleText("Change Attachments", "Trebuchet24", 160, 105, white, 0)
				draw.SimpleText("bind key +menu_context", "DermaDefaultBold", 353, 111, white, 0)

				draw.SimpleText("[" .. leanLeftBind .. "]", "Trebuchet24", 135, 130, leanLeftColor, 0)
				draw.SimpleText("Lean Left", "Trebuchet24", 165, 130, white, 0)
				draw.SimpleText("bind key +alt1", "DermaDefaultBold", 265, 136, white, 0)

				draw.SimpleText("[" .. leanRightBind .. "]", "Trebuchet24", 135, 155, leanRightColor, 0)
				draw.SimpleText("Lean Right", "Trebuchet24", 165, 155, white, 0)
				draw.SimpleText("bind key +alt2", "DermaDefaultBold", 275, 161, white, 0)

				draw.SimpleText("[" .. dropBind .. "]", "Trebuchet24", 135, 180, dropColor, 0)
				draw.SimpleText("Drop Held Item", "Trebuchet24", 165, 180, white, 0)
				draw.SimpleText("bind key +drop", "DermaDefaultBold", 310, 186, white, 0)

				draw.SimpleText("[" .. tacticalBind .. "]", "Trebuchet24", 135, 205, tacticalColor, 0)
				draw.SimpleText("Toggle Laser/Light", "Trebuchet24", 162, 205, white, 0)
				draw.SimpleText("bind key impulse 100", "DermaDefaultBold", 340, 211, white, 0)

				draw.SimpleText("[" .. fireModeBind .. "]", "Trebuchet24", 135, 230, fireModeColor, 0)
				draw.SimpleText("Toggle Firemode", "Trebuchet24", 165, 230, white, 0)
				draw.SimpleText("bind key +zoom", "DermaDefaultBold", 330, 236, white, 0)

				draw.SimpleText("[" .. helpBind .. "]", "Trebuchet24", 135, 255, inventoryColor, 0)
				draw.SimpleText("Help Menu/Learn How To Play", "Trebuchet24", 175, 255, white, 0)
				draw.SimpleText("bind key gm_showhelp", "DermaDefaultBold", 460, 261, white, 0)

				draw.SimpleText("[" .. teamBind .. "]", "Trebuchet24", 135, 280, inventoryColor, 0)
				draw.SimpleText("Create/Join Team", "Trebuchet24", 175, 280, white, 0)
				draw.SimpleText("bind key gm_showteam", "DermaDefaultBold", 350, 286, white, 0)

				draw.SimpleText("[" .. armorBind .. "]", "Trebuchet24", 135, 305, inventoryColor, 0)
				draw.SimpleText("Armor Management (View/Drop)", "Trebuchet24", 175, 305, white, 0)
				draw.SimpleText("bind key gm_showspare1", "DermaDefaultBold", 470, 311, white, 0)
			
				draw.SimpleText("[" .. shopBind .. "]", "Trebuchet24", 135, 330, shopColor, 0)
				draw.SimpleText("Open Menu (Shop/Tasks)", "Trebuchet24", 175, 330, white, 0)
				draw.SimpleText("bind key gm_showspare2", "DermaDefaultBold", 410, 336, white, 0)

				draw.SimpleText("Items from body bags need to be equiped in the inventory", "Trebuchet24", 135, 370, Color(50, 255, 0), 0)

				draw.SimpleText("[" .. inventoryBind .. "]", "Trebuchet24", 135, 400, inventoryColor, 0)
				draw.SimpleText("Inventory", "Trebuchet24", 160, 400, white, 0)

				draw.SimpleText("Walk + Interact will pick up dropped armor", "Trebuchet24", 135, 440, Color(255, 175, 0), 0)

				draw.SimpleText("[" .. walkBind .. "]", "Trebuchet24", 135, 470, inventoryColor, 0)
				draw.SimpleText("Walk", "Trebuchet24", 190, 470, white, 0)
				draw.SimpleText("bind key +walk", "DermaDefaultBold", 250, 476, white, 0)
			
				draw.SimpleText("[" .. interactBind .. "]", "Trebuchet24", 135, 495, shopColor, 0)
				draw.SimpleText("Interact (Loot/Buttons)", "Trebuchet24", 160, 495, white, 0)
				draw.SimpleText("bind key +use", "DermaDefaultBold", 385, 501, white, 0)
			end
		end
	end
end
hook.Add("HUDPaint", "TestHud", HUD)

function DrawTarget()
	if LocalPlayer():GetNWBool("inRaid") == true then
		return false
	end
end
hook.Add("HUDDrawTargetID", "HidePlayerInfo", DrawTarget)

function HideHud(name)
	for k, v in pairs({"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo"}) do
		if name == v then
			return false
		end
	end
end
hook.Add("HUDShouldDraw", "HideDefaultHud", HideHud)