local VORPcore = {}
local inGoldPanning = false
local isNearWater = false
local hasPan = false
local isLoaded = false
local currentSpot = nil

-- Initialize VORP Core
Citizen.CreateThread(function()
    while not VORPcore do
        TriggerEvent("getCore", function(core)
            VORPcore = core
        end)
        Citizen.Wait(200)
    end
    
    -- Register gold pan item use
    if Config.GoldPanning.requiredItem then
        exports.vorp_inventory:registerUsableItem(Config.VORP.goldPanItem, function(data)
            CheckForPan()
        end)
    end
    
    isLoaded = true
    print("^2[GoldPanning] Client script initialized^7")
end)

-- Initialize the script
Citizen.CreateThread(function()
    -- Wait for VORP core to be ready
    while not VORPcore do
        TriggerEvent("getCore", function(core)
            VORPcore = core
        end)
        Citizen.Wait(200)
    end

    -- Main thread for gold panning
    while true do
        Citizen.Wait(0)
        
        if not isLoaded then
            Citizen.Wait(1000)
            goto continue
        end
        
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        
        -- Check if player is near water and not in a vehicle
        isNearWater = IsEntityInWater(playerPed) and not IsPedInAnyVehicle(playerPed, false)
        
        -- Debug info
        if Config.Debug and isNearWater then
            local text = string.format("In water: %s\nHas pan: %s", 
                tostring(isNearWater), 
                tostring(hasPan))
            VORPcore.Functions.DrawText3D(coords.x, coords.y, coords.z + 1.0, text, 0.2, 4)
        end
        
        -- Show help text when in water and has a pan
        if isNearWater and hasPan and not inGoldPanning then
            VORPcore.Functions.DisplayHelpText(Config.GoldPanning.text.startPanning)
            
            if IsControlJustReleased(0, 0xCEFD9220) then -- E key
                StartGoldPanning()
            end
        end
    end
end)

-- Function to start gold panning
function StartGoldPanning()
    if inGoldPanning then return end
    
    inGoldPanning = true
    local playerPed = PlayerPedId()
    
    -- Play animation
    RequestAnimDict("amb_work@world_human_panning@male_a@base")
    while not HasAnimDictLoaded("amb_work@world_human_panning@male_a@base") do
        Citizen.Wait(10)
    end
    
    TaskPlayAnim(playerPed, "amb_work@world_human_panning@male_a@base", "base", 8.0, -8.0, -1, 1, 0, false, false, false)
    
    -- Show progress bar
    VORPcore.Functions.Progressbar("gold_panning", Config.GoldPanning.text.panning, Config.GoldPanning.panningTime, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        -- Finished panning
        ClearPedTasks(playerPed)
        inGoldPanning = false
        
        -- Chance to find gold
        local chance = math.random(1, 100)
        if chance <= Config.GoldPanning.baseChance then
            local goldAmount = math.random(Config.GoldPanning.minGold, Config.GoldPanning.maxGold)
            TriggerServerEvent('goldpanning:foundGold', goldAmount)
            VORPcore.Functions.Notify(string.format(Config.GoldPanning.text.foundGold, goldAmount), "success")
        else
            VORPcore.Functions.Notify(Config.GoldPanning.text.noGold, "error")
        end
    end, function()
        -- Canceled
        ClearPedTasks(playerPed)
        inGoldPanning = false
        VORPcore.Functions.Notify(Config.GoldPanning.text.canceled, "error")
    end)
end

-- Check if player has a gold pan
RegisterNetEvent('goldpanning:checkPan')
AddEventHandler('goldpanning:checkPan', function()
    -- Check if player has a gold pan in their inventory
    -- This is a placeholder - you'll need to implement your inventory check based on your framework
    TriggerServerEvent('goldpanning:hasPan')
end)

-- Set hasPan variable based on server response
RegisterNetEvent('goldpanning:setHasPan')
AddEventHandler('goldpanning:setHasPan', function(hasPanItem)
    hasPan = hasPanItem
end)

-- Add blips if locations are configured
Citizen.CreateThread(function()
    if Config.GoldPanning.blip.enabled and #Config.GoldPanning.locations > 0 then
        for _, spot in ipairs(Config.GoldPanning.locations) do
            local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, spot.x, spot.y, spot.z)
            SetBlipSprite(blip, Config.GoldPanning.blip.sprite, true)
            SetBlipScale(blip, Config.GoldPanning.blip.scale)
            SetBlipColour(blip, Config.GoldPanning.blip.color)
            Citizen.InvokeNative(0x9CB1A1623062F402, blip, Config.GoldPanning.blip.name)
        end
        print("^2[GoldPanning] Added " .. #Config.GoldPanning.locations .. " gold panning blips^7")
    else
        print("^3[GoldPanning] No gold panning blips to add (locations are disabled or empty)^7")
    end
end)

-- Check if player has the required item
function CheckForPan()
    if not Config.GoldPanning.requiredItem then
        hasPan = true
        return
    end
    
    -- Check inventory for gold pan
    TriggerServerEvent('goldpanning:checkPan')
end

-- Check for pan when player spawns or inventory changes
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(30000) -- Check every 30 seconds
        if isLoaded and Config.GoldPanning.requiredItem then
            CheckForPan()
        end
        Citizen.Wait(0)
    end
end)

-- Initial check
Citizen.CreateThread(function()
    while not isLoaded do
        Citizen.Wait(100)
    end
    
    Citizen.Wait(5000) -- Wait for the player to load in
    CheckForPan()
end)

-- Debug command to check if script is working
RegisterCommand('checkgoldpan', function()
    if Config.Debug then
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        print("Current coords:", coords)
        print("Has pan:", hasPan)
        print("Near water:", isNearWater)
        print("Near spot:", currentSpot and currentSpot.name or "None")
    end
end, false)
