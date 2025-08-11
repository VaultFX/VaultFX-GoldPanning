-- Version information for the Gold Panning script
local Version = {
    MAJOR = 1,
    MINOR = 0,
    PATCH = 0,
    DATE = "2025-08-09"
}

function Version:ToString()
    return string.format("%d.%d.%d", self.MAJOR, self.MINOR, self.PATCH)
end

function Version:GetFullVersion()
    return {
        version = self:ToString(),
        date = self.DATE,
        name = "Gold Panning",
        author = "VaultFX"
    }
end

return Version
