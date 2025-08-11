Config = {}

-- Gold panning configuration
Config.GoldPanning = {
    -- Base chance to find gold (0-100)
    baseChance = 30,
    
    -- Minimum and maximum gold nuggets that can be found
    minGold = 1,
    maxGold = 3,
    
    -- Value per gold nugget (in cents)
    goldValue = 15, -- Slightly increased value for better gameplay
    
    -- Time it takes to pan for gold (in milliseconds)
    panningTime = 15000, -- Slightly longer for better immersion
    
    -- Required item to pan for gold (set to nil if not required)
    requiredItem = "goldpan",
    
    -- No specific locations - can pan in any water body
    locations = {},
    
    -- Blip settings (not used when no specific locations are set)
    blip = {
        enabled = false,     -- No blips since there are no specific locations
        sprite = 1417043896,
        color = 5,
        scale = 0.3,
        name = "Gold Panning Spot"
    },
    
    -- Text strings
    text = {
        startPanning = "Press ~e~[E]~q~ to start gold panning",
        panning = "Panning for gold...",
        foundGold = "You found ~e~%d~q~ gold nugget(s)!",
        noGold = "You didn't find any gold this time.",
        canceled = "Gold panning canceled",
        noPan = "You need a ~e~Gold Pan~q~ to do that!"
    }
}

-- VORP Core Integration
Config.VORP = {
    -- Gold nugget item name in your inventory system
    goldNuggetItem = "goldnugget",
    
    -- Gold pan item name in your inventory system
    goldPanItem = "goldpan",
    
    -- Notification settings
    notifications = {
        position = "top",  -- top, top-right, top-left, bottom, bottom-right, bottom-left
        duration = 5000,   -- Duration in milliseconds
        type = "info"      -- info, success, error, warning
    }
}

-- Debug mode (set to false in production)
Config.Debug = false
