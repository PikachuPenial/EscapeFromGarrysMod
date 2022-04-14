local raidTimeLeft = "Raid has not started."
local timerRed = false

local hudInRaid = false

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
	
--Gun Hud

	if (client:GetActiveWeapon():IsValid()) then
		if (client:GetActiveWeapon():GetPrintName() != nil) then
			draw.SimpleText("Holding: " .. client:GetActiveWeapon():GetPrintName(), "DermaDefaultBold", 205, ScrH() - 58, Color(255, 255, 255, 255), 0, 0)

			--draw.SimpleText("[LOW Tier]", "DermaDefault", 230, ScrH() - 72, Color(255, 0, 0, 255), 1)
			--draw.SimpleText("[MID Tier]", "DermaDefault", 230, ScrH() - 72, Color(255, 255, 0, 255), 1)
			--draw.SimpleText("[HIGH Tier]", "DermaDefault", 232, ScrH() - 72, Color(0, 255, 0, 255), 1)
			--draw.SimpleText("[UTIL Tier]", "DermaDefault", 232, ScrH() - 72, Color(0, 0, 255, 255), 1)
		end
	end
--Money And Or XP Hud	

	local expToLevel = (client:GetNWInt("playerLvl") * 110) * 5.15
	--local avatar = vgui.Create("AvatarImage")
	
	draw.SimpleText("Level " .. client:GetNWInt("playerLvl"), "DermaDefaultBold", 50, ScrH() - 38, Color(255, 255, 255, 255), 0)
	draw.SimpleText("EXP: " .. client:GetNWInt("playerExp") .. "/" .. expToLevel, "DermaDefaultBold", 50, ScrH() - 22, Color(255, 255, 255), 0)
	
	draw.SimpleText("₽ " .. client:GetNWInt("playerMoney"), "DermaDefaultBold", 100, ScrH() - 38, Color(255, 255, 255, 255), 0)
	draw.SimpleText("JOIN OUR DISCORD - discord.gg/Wb9cVUwvTV", "DermaDefaultBold", 375, ScrH() - 22, Color(58, 235, 52, 255), 0)
	draw.SimpleText("Press F3 to access your inventory", "DermaDefaultBold", 170, ScrH() - 38, Color(255, 166, 0, 255), 0)
	draw.SimpleText("Press F4 for shop, stats, and help", "DermaDefaultBold", 170, ScrH() - 22, Color(255, 166, 0, 255), 0)

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

		draw.SimpleText("MAP IS RESETING: TRANSFER ANYTHING YOU WANT TO KEEP INTO YOUR STASH, OR YOU WILL LOSE YOUR ITEMS.", "DermaLarge", ScrW() / 2, 50, colorRed, 1)
		surface.PlaySound("taskfailed.wav")
	end

	draw.SimpleText(raidTimeLeft, "DermaLarge", 28, ScrH() - 305, timerColor, 0)
	draw.SimpleText(timeText, "DermaDefaultBold", 28, ScrH() - 275, timerColor, 0)

	-- Steam Profile Picture in the left corner

	--avatar:SetSize(42, 42)
	--avatar:SetPos(4, 1035)
	--avatar:SetPlayer(client, 64)

	-- Control hints while in lobby

	if (hudInRaid == false) then

		local spawnMenuBind = input.LookupBinding("+menu")
		local contextMenuBind = input.LookupBinding("+menu_context")
		local leanLeftBind = input.LookupBinding("+alt1")
		local leanRightBind = input.LookupBinding("+alt2")
		local dropBind = input.LookupBinding("+drop")
		local nvgBind = input.LookupBinding("arc_vm_nvg")
		local tacticalBind = input.LookupBinding("impulse 100")
		local fireModeBind = input.LookupBinding("+zoom")
		local inventoryBind = input.LookupBinding("gm_showspare1")
		local shopBind = input.LookupBinding("gm_showspare2")


		if (spawnMenuBind == nil) then
			spawnMenuBind = "#"
			spawnMenuColor = 255, 0, 0, 255
		else
			spawnMenuColor = 255, 255, 255, 255
		end

		if (contextMenuBind == nil) then
			contextMenuBind = "#"
			contextMenuColor = 255, 0, 0, 255
		else
			contextMenuColor = 255, 255, 255, 255
		end

		if (leanLeftBind == nil) then
			leanLeftBind = "#"
			leanLeftColor = 255, 0, 0, 255
		else
			leanLeftColor = 255, 255, 255, 255
		end

		if (leanRightBind == nil) then
			leanRightBind = "#"
			leanRightColor = 255, 0, 0, 255
		else
			leanRightColor = 255, 255, 255, 255
		end

		if (dropBind == nil) then
			dropBind = "#"
			dropColor = 255, 0, 0, 255
		else
			dropColor = 255, 255, 255, 255
		end

		if (nvgBind == nil) then
			nvgBind = "#"
			nvgColor = 255, 0, 0, 255
		else
			nvgColor = 255, 255, 255, 255
		end

		if (tacticalBind == nil) then
			tacticalBind = "#"
			tacticalColor = 255, 0, 0, 255
		else
			tacticalColor = 255, 255, 255, 255
		end

		if (fireModeBind == nil) then
			fireModeBind = "#"
			fireModeColor = 255, 0, 0, 255
		else
			fireModeColor = 255, 255, 255, 255
		end

		if (inventoryBind == nil) then
			inventoryBind = "#"
			inventoryColor = 255, 0, 0, 255
		else
			inventoryColor = 255, 255, 255, 255
		end

		if (shopBind == nil) then
			shopBind = "#"
			shopColor = 255, 0, 0, 255
		else
			shopColor = 255, 255, 255, 255
		end

		draw.SimpleText("[Controls]", "DermaLarge", 135, ScrH() - 1060, Color(0, 200, 255, 255), 0)
		draw.SimpleText("# = Not Binded", "DermaLarge", 135, ScrH() - 1030, Color(255, 0, 0, 255), 0)

		draw.SimpleText("[" .. spawnMenuBind .. "]", "DermaLarge", 135, ScrH() - 1000, Color(spawnMenuColor), 0)
		draw.SimpleText("Check Extracts", "DermaLarge", 170, ScrH() - 1000, Color(255, 255, 255, 255), 0)
		draw.SimpleText("bind key +menu", "DermaDefaultBold", 360, ScrH() - 990, Color(255, 255, 255, 255), 0)

		draw.SimpleText("[" .. contextMenuBind .. "]", "DermaLarge", 135, ScrH() - 970, Color(contextMenuColor), 0)
		draw.SimpleText("Change Attachments", "DermaLarge", 165, ScrH() - 970, Color(255, 255, 255, 255), 0)
		draw.SimpleText("bind key +menu_context", "DermaDefaultBold", 425, ScrH() - 960, Color(255, 255, 255, 255), 0)

		draw.SimpleText("[" .. leanLeftBind .. "]", "DermaLarge", 135, ScrH() - 940, Color(leanLeftColor), 0)
		draw.SimpleText("Lean Left", "DermaLarge", 170, ScrH() - 940, Color(255, 255, 255, 255), 0)
		draw.SimpleText("bind key +alt1", "DermaDefaultBold", 290, ScrH() - 930, Color(255, 255, 255, 255), 0)

		draw.SimpleText("[" .. leanRightBind .. "]", "DermaLarge", 135, ScrH() - 910, Color(leanRightColor), 0)
		draw.SimpleText("Lean Right", "DermaLarge", 170, ScrH() - 910, Color(255, 255, 255, 255), 0)
		draw.SimpleText("bind key +alt2", "DermaDefaultBold", 305, ScrH() - 900, Color(255, 255, 255, 255), 0)

		draw.SimpleText("[" .. dropBind .. "]", "DermaLarge", 135, ScrH() - 880, Color(dropColor), 0)
		draw.SimpleText("Drop Held Item", "DermaLarge", 170, ScrH() - 880, Color(255, 255, 255, 255), 0)
		draw.SimpleText("bind key +drop", "DermaDefaultBold", 356, ScrH() - 870, Color(255, 255, 255, 255), 0)

		draw.SimpleText("[" .. nvgBind .. "]", "DermaLarge", 135, ScrH() - 850, Color(nvgColor), 0)
		draw.SimpleText("Toggle NVG", "DermaLarge", 175, ScrH() - 850, Color(255, 255, 255, 255), 0)
		draw.SimpleText("bind key arc_vm_nvg", "DermaDefaultBold", 325, ScrH() - 840, Color(255, 255, 255, 255), 0)

		draw.SimpleText("[" .. tacticalBind .. "]", "DermaLarge", 135, ScrH() - 820, Color(tacticalColor), 0)
		draw.SimpleText("Toggle Laser/Light", "DermaLarge", 162, ScrH() - 820, Color(255, 255, 255, 255), 0)
		draw.SimpleText("bind key impulse 100", "DermaDefaultBold", 400, ScrH() - 810, Color(255, 255, 255, 255), 0)

		draw.SimpleText("[" .. fireModeBind .. "]", "DermaLarge", 135, ScrH() - 790, Color(fireModeColor), 0)
		draw.SimpleText("Toggle Firemode", "DermaLarge", 168, ScrH() - 790, Color(255, 255, 255, 255), 0)
		draw.SimpleText("bind key +zoom", "DermaDefaultBold", 380, ScrH() - 780, Color(255, 255, 255, 255), 0)

		draw.SimpleText("[" .. inventoryBind .. "]", "DermaLarge", 135, ScrH() - 760, Color(inventoryColor), 0)
		draw.SimpleText("Open Inventory", "DermaLarge", 182, ScrH() - 760, Color(255, 255, 255, 255), 0)
		draw.SimpleText("bind key gm_showspare1", "DermaDefaultBold", 372, ScrH() - 750, Color(255, 255, 255, 255), 0)

		draw.SimpleText("[" .. shopBind .. "]", "DermaLarge", 135, ScrH() - 730, Color(shopColor), 0)
		draw.SimpleText("Open Menu (Shop/Tasks)", "DermaLarge", 182, ScrH() - 730, Color(255, 255, 255, 255), 0)
		draw.SimpleText("bind key gm_showspare2", "DermaDefaultBold", 498, ScrH() - 720, Color(255, 255, 255, 255), 0)

	end
end
hook.Add("HUDPaint", "TestHud", HUD)

function HideHud(name)
  for k, v in pairs({"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo"}) do
      if name == v then
          return false
      end
  end
end
hook.Add("HUDShouldDraw", "HideDefaultHud", HideHud)
