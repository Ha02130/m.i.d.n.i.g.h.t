local addonName, addonTable = ... -- luacheck: ignore addonName

local GetTime = GetTime
local max = math.max
local min = math.min

addonTable.BurstTime = GetTime() + 20

addonTable.InBurst = function()
    return addonTable.BurstTime > GetTime()
end

addonTable.BurstRemaining = function()
    return min(60.0, max(0, addonTable.BurstTime - GetTime()))
end

-- SLASH_BURST1 = "/burst"
-- SlashCmdList["BURST"] = function(msg)
--     local delaySeconds = tonumber(msg)
--     if delaySeconds then
--         addonTable.BurstTime = GetTime() + delaySeconds
--     end
-- end
