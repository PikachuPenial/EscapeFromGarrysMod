local MapMenu

local clientPlayer

function mapVoteMenu(ply, cmd, args)

	local client = LocalPlayer()
	
	if not client:Alive() then return end

	if (MapMenu == nil) then
		MapMenu = vgui.Create("DFrame")
		MapMenu:SetSize(750, 500)
		MapMenu:Center()
		MapMenu:SetTitle("VOTE FOR THE NEXT MAP")
		MapMenu:SetDraggable(true)
		MapMenu:ShowCloseButton(false)
		MapMenu:SetDeleteOnClose(false)
		MapMenu.Paint = function()
			surface.SetDrawColor(90, 90, 90, 50)
			surface.DrawRect(0, 0, MapMenu:GetWide(), MapMenu:GetTall())
			
			surface.SetDrawColor(40, 40, 40, 50)
			surface.DrawRect(0, 24, MapMenu:GetWide(), 1)
		end
	
		addMapButtons(MapMenu)

		gui.EnableScreenClicker(true)
	else
		MapMenu:Remove()
		MapMenu = nil
		gui.EnableScreenClicker(false)
	end
end
concommand.Add("open_map_menu", mapVoteMenu)

function addMapButtons(MapMenu)

    local closeButton = vgui.Create("DButton")
	closeButton:SetParent(MapMenu)
	closeButton:SetText("")
	closeButton:SetSize(225, 50)
	closeButton:SetPos(255, 400)
	closeButton.Paint = function()
		--Color of entire button
		surface.SetDrawColor(50, 50, 50, 255)
		surface.DrawRect(0, 0, closeButton:GetWide(), closeButton:GetTall())
		
		--Draw bottom and Right borders
		surface.SetDrawColor(40, 40, 40, 255)
		surface.DrawRect(0, 49, closeButton:GetWide(), 1)
		surface.DrawRect(224, 0, 1, closeButton:GetTall())
		
		--Draw/write text
		draw.DrawText("Close Menu / Skip Vote", "Trebuchet24", closeButton:GetWide() / 2.1, 10, Color(255, 0, 0, 255), 1)
    end
        closeButton.DoClick = function(closeButton)
            MapMenu:Remove()
            MapMenu = nil
            gui.EnableScreenClicker(false)
            surface.PlaySound( "common/wpn_select.wav" )
	end

    local concreteButton = vgui.Create("DImageButton")
    concreteButton:SetParent(MapMenu)
    concreteButton:SetPos(50, 75)
    concreteButton:SetImage("mapicon/concrete.png")
    concreteButton:SizeToContents()
    concreteButton.DoClick = function()
        RunConsoleCommand("vote", "efgm_concrete")

        MapMenu:Remove()
        MapMenu = nil
        gui.EnableScreenClicker(false)
        surface.PlaySound( "common/wpn_select.wav" )
    end

    local factoryButton = vgui.Create("DImageButton")
    factoryButton:SetParent(MapMenu)
    factoryButton:SetPos(266.5, 75)
    factoryButton:SetImage("mapicon/factory.png")
    factoryButton:SizeToContents()
    factoryButton.DoClick = function()
        RunConsoleCommand("vote", "efgm_factory")

        MapMenu:Remove()
        MapMenu = nil
        gui.EnableScreenClicker(false)
        surface.PlaySound( "common/wpn_select.wav" )
    end

    local customsButton = vgui.Create("DImageButton")
    customsButton:SetParent(MapMenu)
    customsButton:SetPos(483, 75)
    customsButton:SetImage("mapicon/customs.png")
    customsButton:SizeToContents()
    customsButton.DoClick = function()
        RunConsoleCommand("vote", "efgm_customs")

        MapMenu:Remove()
        MapMenu = nil
        gui.EnableScreenClicker(false)
        surface.PlaySound( "common/wpn_select.wav" )
    end
end