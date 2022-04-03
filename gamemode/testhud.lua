function HUD()
  local client = LocalPlayer()

  if !client:Alive() then
      return
    end
	
--Gun Hud
	if (client:GetActiveWeapon():IsValid()) then
		if (client:GetActiveWeapon():GetPrintName() != nil) then
			draw.SimpleText("Holding: " .. client:GetActiveWeapon():GetPrintName(), "DermaDefaultBold", 205, ScrH() - 60, Color(255, 255, 255, 255), 0, 0)
		end
	end
--Money And Or XP Hud	

	local expToLevel = (client:GetNWInt("playerLvl") * 110) * 5.15
	
	draw.SimpleText("Level " .. client:GetNWInt("playerLvl"), "DermaDefaultBold", 50, ScrH() - 38, Color(255, 255, 255, 255), 0)
	draw.SimpleText("EXP: " .. client:GetNWInt("playerExp") .. "/" .. expToLevel, "DermaDefaultBold", 50, ScrH() - 22, Color(255, 255, 255), 0)
	
	draw.SimpleText("₽ " .. client:GetNWInt("playerMoney"), "DermaDefaultBold", 100, ScrH() - 38, Color(255, 255, 255, 255), 0)
	draw.SimpleText("EFGM BETA Testing / made by Penial & Porty", "DermaDefaultBold", 375, ScrH() - 22, Color(85, 0, 255, 255), 0)
	draw.SimpleText("Press F3 to access your inventory", "DermaDefaultBold", 170, ScrH() - 38, Color(255, 166, 0, 255), 0)
	draw.SimpleText("Press F4 for shop, stats, and help", "DermaDefaultBold", 170, ScrH() - 22, Color(255, 166, 0, 255), 0)
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