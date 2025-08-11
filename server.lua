local VORPcore = {}
local VORPinv

-- Initialize VORP core
Citizen.CreateThread(function()
    while not VORPcore do
        TriggerEvent("getCore", function(core)
            VORPcore = core
        end)
        Citizen.Wait(200)
    end
    
    -- Initialize VORP Inventory
    VORPinv = exports.vorp_inventory:vorp_inventoryApi()
    
    print("^2[GoldPanning] Server script initialized^7")
end)

-- Helper function to get player identifier
local function GetPlayerIdentifier(source)
    local identifiers = GetPlayerIdentifiers(source)
    for _, v in pairs(identifiers) do
        if string.find(v, "steam") then
            return v
        end
    end
    return nil
end

-- Check if player has a gold pan
RegisterServerEvent('goldpanning:checkPan')
AddEventHandler('goldpanning:checkPan', function()
    local _source = source
    local hasPan = false
    
    if not Config.GoldPanning.requiredItem then
        hasPan = true
    else
        -- Check if player has the gold pan in their inventory
        local count = VORPinv.getItemCount(_source, Config.VORP.goldPanItem)
        hasPan = count and count > 0
        
        if Config.Debug then
            print(string.format("[GoldPanning] Player %s has %d %s", 
                GetPlayerName(_source), 
                count or 0, 
                Config.VORP.goldPanItem))
        end
    end
    
    TriggerClientEvent('goldpanning:setHasPan', _source, hasPan)
end)

-- Handle finding gold
RegisterServerEvent('goldpanning:foundGold')
AddEventHandler('goldpanning:foundGold', function(amount)
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    
    -- Add gold nuggets to player's inventory
    local success = VORPinv.addItem(_source, Config.VORP.goldNuggetItem, amount)
    
    if not success then
        -- If inventory is full, add money instead
        local moneyAmount = amount * Config.GoldPanning.goldValue
        Character.addCurrency(0, moneyAmount)
        
        -- Notify player
        TriggerClientEvent("vorp:TipRight", _source, 
            string.format("Inventory full! Received $%.2f instead", moneyAmount / 100.0), 5000)
    else
        -- Notify player of gold nuggets found
        TriggerClientEvent("vorp:TipRight", _source, 
            string.format("Found %d %s!", amount, Config.VORP.goldNuggetItem), 5000)
    end
    
    -- Log the transaction
    local identifier = GetPlayerIdentifier(_source) or "unknown"
    local playerName = GetPlayerName(_source) or "unknown"
    
    print(string.format("[GoldPanning] %s (%s) found %d gold nugget(s)", 
        playerName, identifier, amount))
    
    -- Add to server logs
    if Config.Debug then
        print(string.format("[GoldPanning] Debug - %s found %d gold nugget(s)", 
            playerName, amount))
    end
    
    -- Add to VORP logs
    TriggerEvent('vorp:addToLog', 'goldpanning', 'Gold Panning', 
        string.format('%s found %d gold nugget(s)', playerName, amount))
end)

-- Server exports for future use if needed
exports('GetGoldPanningConfig', function()
    return {
        goldValue = Config.GoldPanning.goldValue,
        requiredItem = Config.GoldPanning.requiredItem,
        panningTime = Config.GoldPanning.panningTime
    }
end)

-- Add this to your server.cfg to ensure the resource starts
-- ensure vaultfx-goldpanning
