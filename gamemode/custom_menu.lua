local Menu

local isSellMenu = false
local clientPlayer
local seller

local stashClient

local stashTable

net.Receive("SellMenuTable",function (len, ply)

	tempTable = net.ReadTable()

	clientPlayer = tempTable[1]
	seller = tempTable[2]
	
end)

net.Receive("OpenStashGUI",function (len, ply)

	print("got message to open stash")

	tempTable = net.ReadTable()

	stashClient = tempTable[1]

	MenuInit()
	DoInventory()

end)

net.Receive("CloseStashGUI",function (len, ply)

	StashMenu:Close()
	
end)

net.Receive("SendStash",function (len, ply)

	stashTable = net.ReadTable()

	ShowStashTable()

end)

net.Receive("StashMenuReload", function (len, ply) ResetMenu() end)

-- This sets the percent of money you will earn from selling a weapon.
-- Just because you can set it above 1, does not mean you should.
-- 0.6 seems like a good starting point.

function gameShopMenu()

	-- This part just makes sure the client is the one viewing the hud. This is so some logic can work, it's complicated.

	local client = LocalPlayer()
	
	if not client:Alive() then return end

	if clientPlayer != nil then
		isSellMenu = true
		--print (clientPlayer:GetName().." is not nil")
	end

	-- Moving on

	if (Menu == nil) then
		Menu = vgui.Create("DFrame")
		Menu:SetSize(860, 1080)
		Menu:Center()
		Menu:SetTitle("Escape From Garry's Mod Menu")
		Menu:SetDraggable(true)
		Menu:ShowCloseButton(false)
		Menu:SetDeleteOnClose(false)
		Menu.Paint = function()
			surface.SetDrawColor(90, 90, 90, 50)
			surface.DrawRect(0, 0, Menu:GetWide(), Menu:GetTall())
			
			surface.SetDrawColor(40, 40, 40, 50)
			surface.DrawRect(0, 24, Menu:GetWide(), 1)
		end
	
		addButtons(Menu, isSellMenu, clientPlayer)

		gui.EnableScreenClicker(true)
		surface.PlaySound( "common/wpn_select.wav" )
	else
		Menu:Remove()
		Menu = nil
		gui.EnableScreenClicker(false)
		surface.PlaySound( "common/wpn_denyselect.wav" )

		clientPlayer = nil
		isSellMenu = false
		seller = nil
	end
end
concommand.Add("open_game_menu", gameShopMenu)

--Button Code
function addButtons(Menu, sellMenuBool, ply)

	--print("isSellMenu is "..tostring(isSellMenu))

	local playerButton = vgui.Create("DButton")
	playerButton:SetParent(Menu)
	playerButton:SetText("")
	playerButton:SetSize(100, 50)
	playerButton:SetPos(0, 25)
	playerButton.Paint = function()
		--Color of entire button
		surface.SetDrawColor(50, 50, 50, 255)
		surface.DrawRect(0, 0, playerButton:GetWide(), playerButton:GetTall())
		
		--Draw bottom and Right borders
		surface.SetDrawColor(40, 40, 40, 255)
		surface.DrawRect(0, 49, playerButton:GetWide(), 1)
		surface.DrawRect(99, 0, 1, playerButton:GetTall())
		
		--Draw/write text
		draw.DrawText(LocalPlayer():GetName(), "DermaLarge", playerButton:GetWide() / 2.1, 10, Color(255, 255, 255, 255), 1)
	end
	playerButton.DoClick = function(playerButton)
		local playerPanel = Menu:Add("PlayerPanel")
		
		playerPanel.Paint = function()
			surface.SetDrawColor(50, 50, 50, 255)
			surface.DrawRect(0, 0, playerPanel:GetWide(), playerPanel:GetTall())
			surface.SetTextColor(255, 255, 255, 255)
			
			-- Player Name
			surface.SetFont("Trebuchet24")
			surface.SetTextPos(5, 0)
			surface.DrawText(LocalPlayer():GetName())
			
			-- Stats Text
			surface.SetFont("Trebuchet24")
			surface.SetTextPos(5, 320)
			surface.DrawText("Your Stats")
			
			-- Player EXP and level
			local expToLevel = (LocalPlayer():GetNWInt("playerLvl") * 110) * 5.15
			
			surface.SetFont("Default")
			surface.SetTextPos(8, 35)
			surface.SetTextColor(228, 255, 0, 255)
			surface.DrawText("Level "..LocalPlayer():GetNWInt("playerLvl"))
			
			surface.SetTextPos(58, 35)
			surface.SetTextColor(0, 255, 209 , 255)
			surface.DrawText("Experience "..LocalPlayer():GetNWInt("playerExp").."/"..expToLevel)
			
			-- Balance
			surface.SetTextPos(8, 55)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Roubles/Balance: "..LocalPlayer():GetNWInt("playerMoney"))
			
			-- Stats (Kills)
			surface.SetTextPos(8, 350)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Total Kills: "..LocalPlayer():GetNWInt("playerKills"))
			
			-- Stats (Deaths)
			surface.SetTextPos(8, 370)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Total Deaths: "..LocalPlayer():GetNWInt("playerDeaths"))
			
			-- Stats (KDR)
			surface.SetTextPos(8, 390)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Kill/Death Ratio: "..LocalPlayer():GetNWInt("playerKDR"))
			
			-- Stats (Total Earned)
			surface.SetTextPos(8, 410)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Total Roubles Earned: "..LocalPlayer():GetNWInt("playerTotalEarned"))
			
			-- Stats (Total Roubles From Kills)
			surface.SetTextPos(8, 430)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Total Roubles Earned From Kills: "..LocalPlayer():GetNWInt("playerTotalEarnedKill"))
			
			-- Stats (Total Roubles From Selling)
			surface.SetTextPos(8, 450)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Total Roubles Earned From Selling: "..LocalPlayer():GetNWInt("playerTotalEarnedSell"))
			
			-- Stats (Total Experience Gained)
			surface.SetTextPos(252, 350)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Total Experience Gained: "..LocalPlayer():GetNWInt("playerTotalXpEarned"))
			
			-- Stats (Total Experience Gained From Killing)
			surface.SetTextPos(252, 370)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Total Experience Gained From Kills: "..LocalPlayer():GetNWInt("playerTotalXpEarnedKill"))
			
			-- Stats (Total Experience Gained From Exploration)
			surface.SetTextPos(252, 390)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Total Experience Gained From Exploration: "..LocalPlayer():GetNWInt("playerTotalXpEarnedExplore"))
			
			-- Stats (Total Money Spent)
			surface.SetTextPos(252, 410)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Total Money Spent: "..LocalPlayer():GetNWInt("playerTotalMoneySpent"))
			
			-- Stats (Total Money Spent On Weapons)
			surface.SetTextPos(252, 430)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Total Money Spent On Weapons: "..LocalPlayer():GetNWInt("playerTotalMoneySpentWep"))
			
			-- Stats (Total Money Spent On Ammo/Armor)
			surface.SetTextPos(252, 450)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Total Money Spent On Ammo/Armor: "..LocalPlayer():GetNWInt("playerTotalMoneySpentItem"))
			
			-- Stats (Deaths By Suicide)
			surface.SetTextPos(496, 350)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Total Deaths By Suicide: "..LocalPlayer():GetNWInt("playerDeathsSuicide"))
			
			-- Stats (Damage Given)
			surface.SetTextPos(496, 370)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Damage Given: "..LocalPlayer():GetNWInt("playerDamageGiven"))
			
			-- Stats (Damage Recieved)
			surface.SetTextPos(496, 390)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Damage Recieved: "..LocalPlayer():GetNWInt("playerDamageRecieved"))
			
			-- Stats (Damage Healed)
			surface.SetTextPos(496, 410)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Damage Healed: "..LocalPlayer():GetNWInt("playerDamageHealed"))
			
			-- Stats (Items Picked Up)
			surface.SetTextPos(496, 430)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Weapons Picked Up: "..LocalPlayer():GetNWInt("playerItemsPickedUp"))
			
			-- Stats (Distance Travelled)
			surface.SetTextPos(496, 450)
			surface.SetTextColor(255, 0, 220, 255)
			surface.DrawText("Distance Travelled: "..LocalPlayer():GetNWInt("playerDistance"))
			
			-- Help Section
			surface.SetTextPos(8, 85)
			surface.SetTextColor(155, 255, 0, 255)
			surface.DrawText("Help:")
			
			-- Help Text One
			surface.SetTextPos(8, 100)
			surface.SetTextColor(255, 255, 255, 255)
			surface.DrawText("Welcome to Escape From Garry's Mod! This gamemode is an extremely punishing PVP shooter where you")
			
			-- Help Text Two
			surface.SetTextPos(8, 110)
			surface.SetTextColor(255, 255, 255, 255)
			surface.DrawText("can either fight others or spend time looting and building up your EXP and roubles.")
			
			-- Help Text Three
			surface.SetTextPos(8, 130)
			surface.SetTextColor(255, 255, 255, 255)
			surface.DrawText("In most POI's, you can find a variety of weapons, armor, and spending cash to buy these items yourself.")
			
			-- Help Text Four
			surface.SetTextPos(8, 140)
			surface.SetTextColor(255, 255, 255, 255)
			surface.DrawText("When you die, you will drop all of your loot, but keep your EXP and lose no money. Each kill gives you")
			
			-- Help Text Five
			surface.SetTextPos(8, 150)
			surface.SetTextColor(255, 255, 255, 255)
			surface.DrawText("a chunk of experience and 1000 roubles. Levels will unlock certain items in the shop while roubles")
			
			-- Help Text Six
			surface.SetTextPos(8, 160)
			surface.SetTextColor(255, 255, 255, 255)
			surface.DrawText("are used to purchased these items.")
			
			-- Help Text Seven
			surface.SetTextPos(8, 180)
			surface.SetTextColor(255, 255, 255, 255)
			surface.DrawText("All projectile based weapons will have bullet drop, bullet velocity, penetration, and richochet mechanics.")
			
			-- Help Text Eight
			surface.SetTextPos(8, 190)
			surface.SetTextColor(255, 255, 255, 255)
			surface.DrawText("You can press your menu bind (default key is C) to customize attachments and change the feel of the gun!")

		end
	end

	local playerButton = vgui.Create("DButton")
	playerButton:SetParent(Menu)
	playerButton:SetText("")
	playerButton:SetSize(100, 300)
	playerButton:SetPos(0, 150)
	playerButton.Paint = function()
		--Color of entire button
		surface.SetDrawColor(50, 50, 50, 255)
		surface.DrawRect(0, 0, playerButton:GetWide(), playerButton:GetTall())
	
		
		--Draw/write text
		draw.DrawText("HELP", "DermaLarge", playerButton:GetWide() / 2.1, 125, Color(80, 255, 255, 255), 1)
	end
	playerButton.DoClick = function(playerButton)
		local playerPanel = Menu:Add("PlayerPanel")
		
		playerPanel.Paint = function()
			surface.SetDrawColor(50, 50, 50, 255)
			surface.DrawRect(0, 0, playerPanel:GetWide(), playerPanel:GetTall())
			surface.SetTextColor(255, 255, 255, 255)
			
			-- Player Name
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 0)
			surface.DrawText("Welcome to Escape From Garry's Mod!")

			-- Help Text One
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 50)
			surface.DrawText("For the best experience, input these into your console.")

			-- Help Text Two
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 90)
			surface.DrawText("bind q +alt1    (Let's you lean to the left.)")

			-- Help Text Three
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 120)
			surface.DrawText("bind e +alt2    (Let's you lean to the right.)")

			-- Help Text Five
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 200)
			surface.DrawText("The button on the table at the end of the lobby will put you into")

			-- Help Text Six
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 225)
			surface.DrawText("the raid, if one is ongoing. If no raid is found, one will start.")

			-- Help Text Seven
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 275)
			surface.DrawText("The buttons on the computer terminals will let you access your")

			-- Help Text Eight
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 300)
			surface.DrawText("stash, you can store your weapons/items here safely.")

			-- Help Text Nine
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 350)
			surface.DrawText("The buttons on the wall near the spawn let you sell gear.")

			-- Help Text Ten
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 400)
			surface.DrawText("While in the lobby, press (F4) to access the shop!")

			-- Help Text Eleven
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 425)
			surface.DrawText("You can buy guns, ammo, armor, and other goodies from here!")

			-- Help Text Twelve
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 475)
			surface.DrawText("Your goal in raid is to go in, get loot, fight others, and get out.")

			-- Help Text Thirteen
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 500)
			surface.DrawText("You will lose any gear that you had if you die in a raid.")

			-- Help Text Fourteen
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 525)
			surface.DrawText("You can find loot anywhere around the map.")

			-- Help Text Fifteen
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 575)
			surface.DrawText("To exit a raid and stay alive, you need to find an extract.")

			-- Help Text Fifteen
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 600)
			surface.DrawText("Press your spawn menu key to check your list of extracts.")

			-- Help Text Sixteen
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 625)
			surface.DrawText("If you can extract from a raid, you can then put the loot you")
				
			-- Help Text Seventeen
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 650)
			surface.DrawText("found in your stash, or sell it for even more money.")

			-- Help Text Eighteen
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 700)
			surface.DrawText("Raids will last a total of 30 minutes, and you need to get out by")

			-- Help Text Ninteen
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 725)
			surface.DrawText("the end of the raid to survive! Anyone still in the raid when it")

			-- Help Text Twenty
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 750)
			surface.DrawText("ends will be killed, and will lose anything they had.")

			-- Help Text Twenty One
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 800)
			surface.DrawText("Most maps have special events that can be triggered by doing")

			-- Help Text Twenty One
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 825)
			surface.DrawText("specific things around the map!")

			-- Help Text Twenty Two
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 875)
			surface.DrawText("And while teaming is allowed, be aware that you can be")

			-- Help Text Twenty Three
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 900)
			surface.DrawText("betrayed at any time!")

			-- Help Text Twenty Four
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 950)
			surface.DrawText("EFGM is currently in BETA, and we appreciate you for")

			-- Help Text Twenty Five
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 975)
			surface.DrawText("trying it out, if you have any issues, contact us on discord.")

			-- Help Text Twenty Six
			surface.SetFont("DermaLarge")
			surface.SetTextPos(5, 1020)
			surface.DrawText("          Penial#3298                                          Portator#6582")

		end
	end
	
	local shopButton = vgui.Create("DButton")
	shopButton:SetParent(Menu)
	shopButton:SetText("")
	shopButton:SetSize(100, 50)
	shopButton:SetPos(0, 75)
	shopButton.Paint = function()
		--Color of entire button
		surface.SetDrawColor(50, 50, 50, 255)
		surface.DrawRect(0, 0, shopButton:GetWide(), shopButton:GetTall())
		
		--Draw bottom and Right borders
		surface.SetDrawColor(40, 40, 40, 255)
		surface.DrawRect(0, 49, shopButton:GetWide(), 1)
		surface.DrawRect(99, 0, 1, shopButton:GetTall())
		
		--Draw/write text

		local shopText

		if sellMenuBool == true then shopText = "SELL" else shopText = "SHOP" end

		draw.DrawText(shopText, "DermaLarge", shopButton:GetWide() / 2.1, 10, Color(102, 255, 102, 255), 1)
		
	end

	shopButton.DoClick = function(shopButton)
		local shopPanel = Menu:Add("ShopPanel")	

		local entityCategory

		local entityList

		print(tostring(sellMenuBool))

		if sellMenuBool == false then
			

			entityCategory = vgui.Create("DCollapsibleCategory", shopPanel)
			-- entityCategory:SetPos(0, 0)
			-- entityCategory:SetSize(shopPanel:GetWide(), 100)
			entityCategory:Dock( TOP )
			entityCategory:SetLabel("Ammo/Armor/Crates")

			entityList = vgui.Create("DIconLayout", entityCategory)
			-- entityList:SetPos(0, 20)
			-- entityList:SetSize(entityCategory:GetWide(), entityCategory:GetTall())
			entityList:Dock( TOP )
			entityList:SetSpaceY(5)
			entityList:SetSpaceX(5)
		end
		
		local weaponCategory = vgui.Create("DCollapsibleCategory", shopPanel)
		-- weaponCategory:SetPos(0, 230)
		-- weaponCategory:SetSize(shopPanel:GetWide(), 200)
		weaponCategory:Dock( TOP )
		weaponCategory:SetLabel("Firearms/Weapons")

		local weaponList = vgui.Create("DIconLayout", weaponCategory)
		-- weaponList:SetPos(0, 20)
		-- weaponList:SetSize(weaponCategory:GetWide(), weaponCategory:GetTall())
		weaponList:Dock( TOP )
		weaponList:SetSpaceY(5)
		weaponList:SetSpaceX(5)

		-- testing if this is the shop menu or sell menu, code will be vastly different for each

		if sellMenuBool == true then

			-- if this is the sell menu
			
			for k, v in pairs(weaponsArr) do
	
				for l, b in pairs(sellBlacklist) do
					if v[2] == b[1] then
						return
					end
				end

				-- Creates buttons for the weapons

				local icon = vgui.Create("SpawnIcon", weaponList)
				icon:SetModel(v[1])
				icon:SetToolTip(v[3].."\nSell Price: "..math.Round(v[4]*sellPriceMultiplier, 0))

				-- this lets players visually distinguish items they can sell

				if not clientPlayer:HasWeapon(v[2]) then

					function icon:Paint(w, h)
						draw.RoundedBox( 0, 5, 5, w - 10, h - 10, Color( 40, 40, 40, 255 ) )
						draw.RoundedBox( 0, 8, 8, w - 16, h - 16, Color( 50, 50, 50, 255 ) )
					end

				elseif clientPlayer:HasWeapon(v[2]) then

					function icon:Paint(w, h)
						draw.RoundedBox( 0, 5, 5, w - 10, h - 10, Color( 210, 210, 210, 255 ) )
						draw.RoundedBox( 0, 8, 8, w - 16, h - 16, Color( 230, 230, 230, 255 ) )
					end

				end

				weaponList:Add(icon)

				icon.DoClick = function(icon)
					
					if clientPlayer:HasWeapon(v[2]) then

						local tempTable = {clientPlayer, v[2], math.Round(v[4]*sellPriceMultiplier, 0), v[3]}

						net.Start("SellItem")
						net.WriteTable(tempTable)
						net.SendToServer()

						surface.PlaySound( "common/wpn_select.wav" )
						surface.PlaySound( "items/ammo_pickup.wav" )

						-- draws the icon black after selling

						function icon:Paint(w, h)
							draw.RoundedBox( 0, 5, 5, w - 10, h - 10, Color( 40, 40, 40, 255 ) )
							draw.RoundedBox( 0, 8, 8, w - 16, h - 16, Color( 50, 50, 50, 255 ) )
						end

					elseif not clientPlayer:HasWeapon(v[2]) then
						
						ply:PrintMessage(HUD_PRINTTALK, "You do not have a "..v[3].."!")

						surface.PlaySound( "common/wpn_denyselect.wav" )

					end
				end
			end

		else

			-- if this is the regular shop

			for k, v in pairs(entsArr) do
                local icon = vgui.Create("SpawnIcon", entityList)

                icon:SetModel(v["Model"])
                icon:SetToolTip(v["PrintName"].."\nCost: "..v["Cost"])
                entityList:Add(icon)

                icon.DoClick = function(icon)
                    LocalPlayer():ConCommand("buy_entity "..v["ClassName"])
                end
            end
			
			for k, v in pairs(weaponsArr) do
	
				-- Creates buttons for the weapons
	
				local icon = vgui.Create("SpawnIcon", weaponList)
				icon:SetModel(v[1])
				icon:SetToolTip(v[3].."\nCost: "..v[4].."\nLevel Req: "..v[5])
				weaponList:Add(icon)
	
				icon.DoClick = function(icon)
					LocalPlayer():ConCommand("buy_gun "..v[2])
				end
			end

		end
	end
end

--Player Panel

PANEL = {} --Creates empty panel

function PANEL:Init() -- initializes the panel
	self:SetSize(760, 1080)
	self:SetPos(100, 25)
end

function PANEL:Paint(w, h)
	draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 255))
end

vgui.Register("PlayerPanel", PANEL, "Panel")

--End player panel


--Shop Panel

PANEL = {} --Creates empty panel

function PANEL:Init() -- initializes the panel
	self:SetSize(760, 1080)
	self:SetPos(100, 25)
end

function PANEL:Paint(w, h)
	draw.RoundedBox(0, 0, 0, w, h, Color(125, 125, 125, 255))
end

vgui.Register("ShopPanel", PANEL, "Panel")

--End shop panel

function MenuInit()

	StashMenu = vgui.Create("DFrame")
	StashMenu:SetSize(ScrW(), ScrH())
	StashMenu:Center()
	StashMenu:SetTitle("Stash Inventory")
	StashMenu:SetDraggable(false)
	StashMenu:ShowCloseButton(true)
	StashMenu:SetDeleteOnClose(false)
	StashMenu.Paint = function()
		surface.SetDrawColor(30, 30, 30, 255)
		surface.DrawRect(0, 0, StashMenu:GetWide(), StashMenu:GetTall())
	end

	gui.EnableScreenClicker(true)
	surface.PlaySound( "common/wpn_select.wav" )

	StashMenu.OnClose = function()
		gui.EnableScreenClicker(false)
		surface.PlaySound( "common/wpn_denyselect.wav" )
	end

	inventoryTable = stashClient:GetWeapons()

	local playerInventoryPanel = vgui.Create("DPanel", StashMenu)
	playerInventoryPanel:Dock( LEFT )
	playerInventoryPanel:SetSize(96, 0)

	function playerInventoryPanel:Paint(w, h)

		draw.RoundedBox(0, 0, 0, w, h, Color( 120, 120, 120, 255 ))

	end

	local ammoInventoryPanel = vgui.Create("DPanel", StashMenu)
	ammoInventoryPanel:Dock( LEFT )
	ammoInventoryPanel:SetSize(96, 0)

	function ammoInventoryPanel:Paint(w, h)

		draw.RoundedBox(0, 0, 0, w, h, Color( 120, 120, 120, 255 ))

	end

	local separatePanel = vgui.Create("DPanel", StashMenu)
	separatePanel:Dock( LEFT )
	separatePanel:SetSize(20, 0)

	function separatePanel:Paint(w, h)

		draw.RoundedBox(0, 0, 0, w, h, Color( 30, 30, 30, 255 ))

	end

	local stashPanel = vgui.Create("DPanel", StashMenu)
	stashPanel:Dock( FILL )
	
	function stashPanel:Paint(w, h)

		draw.RoundedBox(0, 0, 0, w, h, Color( 120, 120, 120, 255 ))

	end


	local stashIconLayout = vgui.Create("DIconLayout", stashPanel)
	stashIconLayout:Dock( FILL )
	stashIconLayout:SetSpaceY(5)
	stashIconLayout:SetSpaceX(5)

	local inventoryIconLayout = vgui.Create("DIconLayout", playerInventoryPanel)
	inventoryIconLayout:Dock( FILL )
	inventoryIconLayout:SetSpaceY(5)
	inventoryIconLayout:SetSpaceX(5)

	local ammoIconLayout = vgui.Create("DIconLayout", ammoInventoryPanel)
	ammoIconLayout:Dock( FILL )
	ammoIconLayout:SetSpaceY(5)
	ammoIconLayout:SetSpaceX(5)

	function DoInventory()

		--local avatar = vgui.Create("AvatarImage")

		--avatar:SetSize(96, 96)
		--avatar:SetPos(101, 635)
		--avatar:SetPlayer(LocalPlayer(), 96)

		print("doing inventory")

		for k, v in pairs(stashClient:GetWeapons()) do
			-- Creates buttons for the weapons

			if weapons.Get( v:GetClass() ) == nil then return end

			local weaponInfo = weapons.Get( v:GetClass() )

			-- PrintTable(stashClient:GetWeapons())

			local wepName

			if weaponInfo["TrueName"] == nil then wepName = weaponInfo["PrintName"] else wepName = weaponInfo["TrueName"] end

			local icon = vgui.Create("SpawnIcon", stashIconLayout)
			icon:SetModel(weaponInfo["WorldModel"])
			icon:SetToolTip(wepName)
			icon:SetSize(96, 96)

			function icon:Paint(w, h)
				
				draw.RoundedBox( 0, 0, 0, w, h, Color( 80, 80, 80, 255 ) )
				draw.RoundedBox( 0, 0, 75, w, h - 75, Color( 40, 40, 40, 255 ) )
				draw.SimpleText(wepName, "DermaDefault", w/2, 80, Color(255, 255, 255, 255), 1)

				local currentItemPrice = nil
				local currentItemTier = nil
				local currentItemSellPrice = nil

				for l, b in pairs(weaponsArr) do

					-- if names match (v.ItemName is same as v["ItemName"])
					if b[2] == v.ItemName then

						currentItemPrice = tostring(b[4])
						currentItemTier = tostring(b[6])

						currentItemSellPrice = (currentItemPrice * sellPriceMultiplier)

						break

					end

				end

				if currentItemPrice != nil then
					-- Weapon Sell Price
					draw.SimpleText("₽", "DermaDefault", 5, 0, Color(255, 255, 0, 255), 0)
					draw.SimpleText(currentItemSellPrice, "DermaDefault", 15, 0, Color(255, 255, 255, 255), 0)
					
					draw.SimpleText("Sell Price", "HudHintTextSmall", 5, 10, Color(255, 255, 255, 255), 0)
					draw.SimpleText("Rarity", "HudHintTextSmall", w/1.05, 10, Color(255, 255, 255, 255), 2)
				end

				if currentItemTier == "LOW" then
					draw.SimpleText("LOW", "DermaDefault", w/1.05, 0, Color(255, 0, 0, 255), 2)
				end

				if currentItemTier == "MID" then
					draw.SimpleText("MID", "DermaDefault", w/1.05, 0, Color(255, 255, 0, 255), 2)
				end
				
				if currentItemTier == "HIGH" then
					draw.SimpleText("HIGH", "DermaDefault", w/1.05, 0, Color(0, 255, 0, 255), 2)
				end

				if currentItemTier == "UTIL" then
					draw.SimpleText("UTIL", "DermaDefault", w/1.05, 0, Color(0, 0, 255, 255), 2)
				end

			end

			inventoryIconLayout:Add(icon)
			
			icon.DoClick = function(icon)

				net.Start("PutWepInStash")
				net.WriteString(v:GetClass())
				net.SendToServer()

				surface.PlaySound( "UI/buttonclick.wav" )

				icon:Remove()

			end
		end

		PrintTable(LocalPlayer():GetAmmo())

		-- for k, v in pairs(LocalPlayer():GetAmmo()) do
		-- 	-- Creates buttons for the weapons

		-- 	if v == nil then print("ammo is nil") return end

		-- 	local ammoName = game.GetAmmoName(v)
		-- 	local ammoAmount = LocalPlayer():GetAmmoCount(v)

		-- 	if ammoName == nil then print("cannot find ammo name") return end

		-- 	print("starting on ammo icon")

		-- 	local icon = vgui.Create("SpawnIcon", ammoIconLayout)
		-- 	--icon:SetModel(ammoName["WorldModel"])
		-- 	icon:SetToolTip(ammoName)
		-- 	icon:SetSize(96, 96)

		-- 	function icon:Paint(w, h)
				
		-- 		draw.RoundedBox( 0, 0, 0, w, h, Color( 80, 80, 80, 255 ) )
		-- 		draw.RoundedBox( 0, 0, 75, w, h - 75, Color( 40, 40, 40, 255 ) )
		-- 		draw.SimpleText(ammoName.." x"..ammoAmount, "DermaDefault", w/2, 80, Color(255, 255, 255, 255), 1)

		-- 	end

		-- 	print("adding ammo to ammo icon layout")
		-- 	ammoIconLayout:Add(icon)
			
		-- 	-- icon.DoClick = function(icon)

		-- 	-- end

		-- end

		print("sending message to server to fetch stash")

		net.Start( "RequestStash" )
		net.SendToServer()

		function ShowStashTable()

			for k, v in pairs(stashTable) do

				if v["ItemOwner"] != LocalPlayer():SteamID64() then	print(LocalPlayer():SteamID64() .. " does not equal " .. v["ItemOwner"])	return end
				if v["ItemType"] != "wep" then						print("ammo bad")															return end
	
				print("Initializing Stash Contents, gun class is " .. v["ItemName"])
				
				local weaponInfo = weapons.Get( v["ItemName"] )

				local wepName
	
				if weaponInfo["TrueName"] == nil then wepName = weaponInfo["PrintName"] else wepName = weaponInfo["TrueName"] end
	
				local icon = vgui.Create("SpawnIcon", stashIconLayout)
				icon:SetModel(weaponInfo["WorldModel"])
				icon:SetToolTip(wepName)
				icon:SetSize(96, 96)
	
				function icon:Paint(w, h)

					-- Weapon Name
					draw.RoundedBox( 0, 0, 0, w, h, Color( 80, 80, 80, 255 ) )
					draw.RoundedBox( 0, 0, 75, w, h - 75, Color( 40, 40, 40, 255 ) )
					draw.SimpleText(wepName, "DermaDefault", w/2, 80, Color(255, 255, 255, 255), 1)

					local currentItemPrice = nil
					local currentItemTier = nil
					local currentItemSellPrice = nil

					print(v.ItemName)

					for l, b in pairs(weaponsArr) do

						-- if names match (v.ItemName is same as v["ItemName"])
						if b[2] == v.ItemName then

							currentItemPrice = tostring(b[4])
							currentItemTier = tostring(b[6])

							currentItemSellPrice = (currentItemPrice * sellPriceMultiplier)

							break

						end

					end

					if currentItemPrice != nil then
						-- Weapon Sell Price
						draw.SimpleText("₽", "DermaDefault", 5, 0, Color(255, 255, 0, 255), 0)
						draw.SimpleText(currentItemSellPrice, "DermaDefault", 15, 0, Color(255, 255, 255, 255), 0)

						draw.SimpleText("Sell Price", "HudHintTextSmall", 5, 10, Color(255, 255, 255, 255), 0)
						draw.SimpleText("Rarity", "HudHintTextSmall", w/1.05, 10, Color(255, 255, 255, 255), 2)
					end

					if currentItemTier == "LOW" then
						draw.SimpleText("LOW", "DermaDefault", w/1.05, 0, Color(255, 0, 0, 255), 2)
					end

					if currentItemTier == "MID" then
						draw.SimpleText("MID", "DermaDefault", w/1.05, 0, Color(255, 255, 0, 255), 2)
					end
					
					if currentItemTier == "HIGH" then
						draw.SimpleText("HIGH", "DermaDefault", w/1.05, 0, Color(0, 255, 0, 255), 2)
					end

					if currentItemTier == "UTIL" then
						draw.SimpleText("UTIL", "DermaDefault", w/1.05, 0, Color(0, 0, 255, 255), 2)
					end

				end
	
				stashIconLayout:Add(icon)

				icon.DoClick = function(icon)
	
					if LocalPlayer():HasWeapon( v["ItemName"] ) == false then

						net.Start("TakeFromStash")
						net.WriteString(v["ItemName"])
						net.SendToServer()

					else

						surface.PlaySound( "common/wpn_denyselect.wav" )

					end

				end
	
			end

		end

		function ResetMenu()

			stashIconLayout:Clear()
			inventoryIconLayout:Clear()
			ammoIconLayout:Clear()

			DoInventory()

		end

	end

end