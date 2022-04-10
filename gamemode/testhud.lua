local raidTimeLeft = "Raid is over!"
local timerRed = false

net.Receive("RaidTimeLeft",function (len, ply)

	raidTimeLeft = net.ReadString()
	timerRed = net.ReadBool()

end)

function HUD()
  local client = LocalPlayer()

  if !client:Alive() then
      return
    end
	
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
	draw.SimpleText("EFGM BETA Testing / made by Penial & Porty", "DermaDefaultBold", 375, ScrH() - 38, Color(85, 0, 255, 255), 0)
	draw.SimpleText("JOIN OUR DISCORD - discord.gg/Wb9cVUwvTV", "DermaDefaultBold", 375, ScrH() - 22, Color(85, 0, 255, 255), 0)
	draw.SimpleText("Press F3 to access your inventory", "DermaDefaultBold", 170, ScrH() - 38, Color(255, 166, 0, 255), 0)
	draw.SimpleText("Press F4 for shop, stats, and help", "DermaDefaultBold", 170, ScrH() - 22, Color(255, 166, 0, 255), 0)

	-- timer

	local colorBlack = Color(255, 255, 255, 255)
	local colorRed = Color(255, 0, 0, 255)

	local timerColor = Color(255, 255, 255, 255)

	if timerRed == false then
		timerColor = colorBlack
	else
		timerColor = colorRed
	end

	local timeText = "Time Remaining"
	local mapSwitchText = "Time Until Map Switches"

	if timerRed == true then
		timeText = mapSwitchText

		draw.SimpleText("MAP IS RESETING: TRANSFER ANYTHING YOU WANT TO KEEP INTO YOUR STASH, OR YOU WILL LOSE YOUR ITEMS.", "DermaLarge", ScrW() / 2, 50, colorRed, 1)
		draw.SimpleText("TO CHECK AVAILABLE MAPS TO VOTE FOR, TYPE THE FOLLOWING INTO THE CONSOLE: vote.", "DermaLarge", ScrW() / 2 , 80, colorRed, 1)
		draw.SimpleText("TO VOTE FOR A NEW MAP, TYPE THE FOLLOWING INTO THE CONSOLE: vote efgm_<nextmapname>.", "DermaLarge", ScrW() / 2 , 110, colorRed, 1)
	end

	draw.SimpleText(raidTimeLeft, "DermaLarge", 28, ScrH() - 305, timerColor, 0)
	draw.SimpleText(timeText, "DermaDefaultBold", 28, ScrH() - 275, timerColor, 0)



	--avatar:SetSize(42, 42)
	--avatar:SetPos(4, 1035)
	--avatar:SetPlayer(client, 64)
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
