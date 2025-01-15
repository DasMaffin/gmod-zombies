zombies.overlayIndex = 0 -- Index 0: No overlay open; Index 1: Overlay open; Index 2: Detailed Overlay Open
zombies.overlayFrame = nil

hook.Add("Initialize", "PreloadCustomFonts", function()
    surface.CreateFont("CustomFont", {
        font = "Arial", -- Font face (e.g., Arial, Roboto, etc.)
        size = 30,      -- Font size in pixels
        weight = 700,   -- Font weight (e.g., 500 for normal, 700 for bold)
        antialias = true, -- Enable smooth edges
    })
end)

-- Function to refresh the zombie overlay with only current living zombies and total killed zombies
function zombies:RefreshBasicZombieOverlay()
    if not zombies.overlayIndex == 1 then return end
    zombies.overlayFrame.scrollPanel:Clear()

    local totalKilled = 0

    for zombieType, data in pairs(zombies.types) do
        totalKilled = totalKilled + data.dead
    end

    local label = vgui.Create("DLabel", zombies.overlayFrame.scrollPanel)
    label:SetText("Lebende Zombies: " .. zombies.livingZombies)
    label:SetFont("CustomFont")
    label:SetTextColor(Color(255, 255, 255)) -- White text
    label:Dock(TOP)
    label:DockMargin(10, 0, 10, 0)
    label:SetTall(30)

    local totalLabel = vgui.Create("DLabel", zombies.overlayFrame.scrollPanel)
    totalLabel:SetText("Insgesamt getötet: " .. totalKilled)
    totalLabel:SetFont("CustomFont")
    totalLabel:SetTextColor(Color(255, 255, 255)) -- White text
    totalLabel:Dock(TOP)
    totalLabel:DockMargin(10, 0, 10, 0)
    totalLabel:SetTall(30)

    local points = 0

    for _, entry in pairs(zombies.types) do
        points = points + (entry.points * entry.dead)
    end

    local pointsLabel = vgui.Create("DLabel", zombies.overlayFrame.scrollPanel)
    pointsLabel:SetText("Punkte: " .. points)
    pointsLabel:SetFont("CustomFont")
    pointsLabel:SetTextColor(Color(255, 255, 255)) -- White text
    pointsLabel:Dock(TOP)
    pointsLabel:DockMargin(10, 0, 10, 0)
    pointsLabel:SetTall(30)

    zombies.overlayIndex = 1
end

-- Function to refresh the zombie overlay with detailed information
function zombies:RefreshDetailedZombieOverlay()    
    if not zombies.overlayIndex == 2 then return end
    zombies.overlayFrame.scrollPanel:Clear()

    for zombieType, data in pairs(zombies.types) do
        local label = vgui.Create("DLabel", zombies.overlayFrame.scrollPanel)
        label:SetText(data.friendlyName .. ": " .. data.dead .. " / " .. data.living)
        label:SetFont("DermaDefaultBold")
        label:SetTextColor(Color(255, 255, 255)) -- White text
        label:Dock(TOP)
        label:DockMargin(10, 0, 10, 0)
        label:SetTall(25)
    end    

    zombies.overlayIndex = 2
end

function zombies:RefreshZombieOverlay()    
    if zombies.overlayIndex == 1 then 
        zombies:RefreshBasicZombieOverlay()
    elseif zombies.overlayIndex == 2 then 
        zombies:RefreshDetailedZombieOverlay()
    end
end

-- Function to create the detailed zombie overlay
function zombies:CreateDetailedZombieOverlay()
    local frameWidth = 300
    local marginRight = 50
    local frameHeight = math.min(table.Count(zombies.types) * 28 + 10, ScrH() * 0.8)

    zombies.overlayFrame = vgui.Create("DFrame")
    zombies.overlayFrame:SetSize(frameWidth, frameHeight)
    zombies.overlayFrame:SetPos(ScrW() - frameWidth - marginRight, (ScrH() - frameHeight) / 2) -- Center vertically
    zombies.overlayFrame:SetTitle("") -- No title
    zombies.overlayFrame:ShowCloseButton(false) -- No close button
    zombies.overlayFrame:SetDraggable(false) -- Not draggable
    zombies.overlayFrame.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(30, 30, 30, 200)) -- Rounded corners and dark grey background
    end

    zombies.overlayFrame.scrollPanel = vgui.Create("DScrollPanel", zombies.overlayFrame)
    zombies.overlayFrame.scrollPanel:Dock(FILL)

    zombies:RefreshDetailedZombieOverlay()
end

-- Function to create the basic zombie overlay (showing living and total killed)
function zombies:CreateBasicZombieOverlay()
    local frameWidth = 300
    local marginRight = 50
    local frameHeight = math.min(135, ScrH() * 0.3)

    zombies.overlayFrame = vgui.Create("DFrame")
    zombies.overlayFrame:SetSize(frameWidth, frameHeight)
    zombies.overlayFrame:SetPos(ScrW() - frameWidth - marginRight, (ScrH() - frameHeight) / 2) -- Center vertically
    zombies.overlayFrame:SetTitle("") -- No title
    zombies.overlayFrame:ShowCloseButton(false) -- No close button
    zombies.overlayFrame:SetDraggable(false) -- Not draggable
    zombies.overlayFrame.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(30, 30, 30, 200)) -- Rounded corners and dark grey background
    end

    zombies.overlayFrame.scrollPanel = vgui.Create("DScrollPanel", zombies.overlayFrame)
    zombies.overlayFrame.scrollPanel:Dock(FILL)

    zombies:RefreshBasicZombieOverlay()
end

-- Function to toggle between overlay states
function zombies:ToggleOverlay()
    if IsValid (zombies.overlayFrame) then
        zombies.overlayFrame:Remove()  -- Close the overlay
        zombies.overlayFrame = nil
    end
    if zombies.overlayIndex == 0 then
        zombies:CreateBasicZombieOverlay()  -- Show basic overlay
    elseif zombies.overlayIndex == 1 then
        zombies:CreateDetailedZombieOverlay()  -- Show detailed overlay
    elseif zombies.overlayIndex == 2 then
        zombies.overlayIndex = 0
    end
end
