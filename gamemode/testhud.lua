function HUD()
  local client = LocalPlayer()

  if !client:Alive() then
      return
    end
--Health Hud
    draw.RoundedBox(0, -20, ScrH() - 36, 92, 120, Color(60,60,60, 175))
    draw.RoundedBox(0, 72, ScrH() - 26, 158, 120, Color(60,60,60, 175))
    draw.SimpleText("Health: "..client:Health(), "DermaDefaultBold", 4, ScrH() - 35, Color(255, 255, 255, 255), 0, 0)
    draw.RoundedBox(0, 4, ScrH() - 20, 100 * 2.2, 2, Color(0, 255, 0, 25))
    draw.RoundedBox(0, 4, ScrH() - 20, 100 * 2.2, 2, Color(25, 175, 25, 25))
    draw.RoundedBox(0, 4, ScrH() - 20, math.Clamp(client:Health(), 0, 100) * 2.2, 15, Color(0, 255, 0, 225))
    draw.RoundedBox(0, 4, ScrH() - 20, math.Clamp(client:Health(), 0, 100) * 2.2, 2, Color(25, 175, 25, 225))

--Ammo Hud
	if (client:GetActiveWeapon():IsValid()) then
		if (client:GetActiveWeapon():GetPrintName() != nil) then
			draw.SimpleText(client:GetActiveWeapon():GetPrintName(), "DermaDefaultBold", 1750, ScrH() - 25, Color(255, 255, 255, 255), 0, 0)
		end

		if (client:GetActiveWeapon():Clip1() != -1) then
			draw.SimpleText(client:GetActiveWeapon():Clip1() .. "/" .. client:GetAmmoCount(client:GetActiveWeapon():GetPrimaryAmmoType()), "DermaDefaultBold", 1875, ScrH() - 25, Color(255, 255, 255, 255), 0, 0)
		else
			draw.SimpleText(client:GetAmmoCount(client:GetActiveWeapon():GetPrimaryAmmoType()), "DermaDefaultBold", 1910, ScrH() - 40, Color(255, 255, 255), 0, 0)
		end

		if (client:GetAmmoCount(client:GetActiveWeapon():GetSecondaryAmmoType()) > 0) then
			draw.SimpleText("S: " .. client:GetAmmoCount(client:GetActiveWeapon():GetSecondaryAmmoType()), "DermaDefaultBold", 1875, ScrH() - 40, Color(255, 255, 255), 0, 0)
		end
	end
--Money And Or XP Hud	

	local expToLevel = (client:GetNWInt("playerLvl") * 110) * 5.15
	
	draw.SimpleText("Level " .. client:GetNWInt("playerLvl"), "DermaDefaultBold", 74, ScrH() - 38, Color(255, 255, 255, 255), 0)
	draw.SimpleText("EXP: " .. client:GetNWInt("playerExp") .. "/" .. expToLevel, "DermaDefaultBold", 124, ScrH() - 38, Color(255, 255, 255), 0)
	
	draw.SimpleText("₽ " .. client:GetNWInt("playerMoney"), "DermaDefaultBold", 233, ScrH() - 38, Color(255, 255, 255, 255), 0)
	draw.SimpleText("EFGM BETA Testing / made by Penial", "DermaDefaultBold", 830, ScrH() - 15, Color(85, 0, 255, 255), 0)
	draw.SimpleText("Press F3 to access your inventory", "DermaDefaultBold", 234, ScrH() - 28, Color(255, 166, 0, 255), 0)
	draw.SimpleText("Press F4 for shop, stats, and help", "DermaDefaultBold", 234, ScrH() - 14, Color(255, 166, 0, 255), 0)
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
