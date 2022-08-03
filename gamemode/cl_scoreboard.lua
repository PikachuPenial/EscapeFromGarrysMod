local ScoreboardDerma = nil
local PlayerList = nil

function GM:ScoreboardShow()

	if !IsValid(ScoreboardDerma) then
		ScoreboardDerma = vgui.Create("DFrame")
		ScoreboardDerma:SetSize(210, 420)
		ScoreboardDerma:SetPos(ScrW() / 2 - 90, ScrH() / 2 - 210)
		ScoreboardDerma:SetTitle("Escape From Garry's Mod", Color(85, 0, 255, 255))
		ScoreboardDerma:SetDraggable(false)
		ScoreboardDerma:ShowCloseButton(false)
		ScoreboardDerma.Paint = function()
			draw.RoundedBox(5, 0, 0, ScoreboardDerma:GetWide(), ScoreboardDerma:GetTall(), Color(60, 60, 60, 255))
		end

		local PlayerScrollPanel = vgui.Create("DScrollPanel", ScoreboardDerma)
		PlayerScrollPanel:SetSize(ScoreboardDerma:GetWide(), ScoreboardDerma:GetTall() - 20)
		PlayerScrollPanel:SetPos(0, 20)

		PlayerList = vgui.Create("DListLayout", PlayerScrollPanel)
		PlayerList:SetSize(PlayerScrollPanel:GetWide(), PlayerScrollPanel:GetTall())
		PlayerList:SetPos(0, 0)
	end

	if IsValid(ScoreboardDerma) then
		PlayerList:Clear()

		for k, v in pairs(player.GetAll()) do
			local PlayerPanel = vgui.Create("DPanel", PlayerList)
			PlayerPanel:SetSize(PlayerList:GetWide(), 50)
			PlayerPanel:SetPos(0, 0)
			PlayerPanel.Paint = function()
				draw.RoundedBox(0, 0, 0, PlayerPanel:GetWide(), PlayerPanel:GetTall(), Color(35, 35, 35, 255))
				draw.RoundedBox(0, 0, 49, PlayerPanel:GetWide(), 1, Color(35, 35, 35, 255))

				draw.SimpleText(v:GetName() .. " - " .. v:Ping() .. "ms", "DermaDefault", 15, 10, Color(255, 255, 255))

				draw.SimpleText("K/D: " .. math.Round(v:GetNWInt("playerKDR"), 1), "DermaDefault", 104, 25, Color(255, 0, 0))
				draw.SimpleText("SR: " .. math.Round(v:GetNWInt("survivalRate"), 0) .. "%", "DermaDefault", 148, 25, Color(0, 255, 0))

				if (v:GetNWInt("playerPrestige") >= 1) then
					draw.SimpleText("Prestige: " .. v:GetNWInt("playerPrestige") .. "    " .. "Level: " .. v:GetNWInt("playerLvl"), "DermaDefault", 15, 25, Color(255, 195, 0))
				else
					draw.SimpleText("Level " .. v:GetNWInt("playerLvl"), "DermaDefault", 15, 25, Color(255, 195, 0))
				end
			end
		end

		ScoreboardDerma:Show()
		ScoreboardDerma:MakePopup()
		ScoreboardDerma:SetKeyboardInputEnabled(false)
	end
end

function GM:ScoreboardHide()
	if IsValid(ScoreboardDerma) then
		ScoreboardDerma:Hide()
	end
end