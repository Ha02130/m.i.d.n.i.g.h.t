local addonName, addonTable = ... -- luacheck: ignore addonName -- 插件入口固定写法

-- Lua 原生函数
local format = string.format
local pairs = pairs
local random = math.random
local select = select

-- WoW 官方 API
local After = C_Timer.After
local CreateColor = CreateColor
local CreateColorCurve = C_CurveUtil.CreateColorCurve
local EvaluateColorFromBoolean = C_CurveUtil.EvaluateColorFromBoolean
local Enum = Enum
local CreateFrame = CreateFrame
local UnitAffectingCombat = UnitAffectingCombat
local UnitCanAttack = UnitCanAttack
local UnitCastingDuration = UnitCastingDuration
local UnitCastingInfo = UnitCastingInfo
local UnitChannelDuration = UnitChannelDuration
local UnitChannelInfo = UnitChannelInfo
local UnitClass = UnitClass
local UnitExists = UnitExists
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local UnitHealthPercent = UnitHealthPercent
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitIsEnemy = UnitIsEnemy
local UnitIsUnit = UnitIsUnit
local UnitPowerPercent = UnitPowerPercent
local UnitPowerType = UnitPowerType

local DejaVu = _G["DejaVu"]
local COLOR = DejaVu.COLOR
local Cell = DejaVu.Cell
local BadgeCell = DejaVu.BadgeCell
local RangedRange = DejaVu.RangedRange -- 默认的远程检测范围
local MeleeRange = DejaVu.MeleeRange   -- 默认的近战检测范围

local LibStub = LibStub
local LRC = LibStub("LibRangeCheck-3.0")
if not LRC then
    print("|cffff0000[单位状态]|r LibRangeCheck-3.0 未找到, 模块无法工作。")
    return
end


After(2, function()
    for partyIndex = 1, 4 do
        local UNIT_KEY = format("party%d", partyIndex)
        local BASE_X = 21 * partyIndex
        local eventFrame = CreateFrame("Frame")
        local cell = {}
        cell.unitExists = Cell:New(BASE_X - 9, 24)               -- 单位存在状态
        cell.unitIsAlive = Cell:New(BASE_X - 9, 25)              -- 单位是否存活
        cell.unitClass = Cell:New(BASE_X - 8, 24)                -- 单位职业
        cell.unitRole = Cell:New(BASE_X - 8, 25)                 -- 单位角色
        cell.unitHealthPercent = Cell:New(BASE_X - 7, 24)        -- 单位生命值百分比
        cell.unitPowerPercent = Cell:New(BASE_X - 7, 25)         -- 单位能量百分比
        cell.unitIsEnemy = Cell:New(BASE_X - 6, 24)              -- 单位是否敌对
        cell.unitCanAttack = Cell:New(BASE_X - 6, 25)            -- 单位是否可攻击
        cell.unitIsInRangedRange = Cell:New(BASE_X - 5, 24)      -- 单位是否在远程范围内
        cell.unitIsInMeleeRange = Cell:New(BASE_X - 5, 25)       -- 单位是否在近战范围内
        cell.unitIsInCombat = Cell:New(BASE_X - 4, 24)           -- 单位是否在战斗中
        cell.unitIsTarget = Cell:New(BASE_X - 4, 25)             -- 单位是否为目标
        cell.unitHasBigDefense = Cell:New(BASE_X - 3, 24)        -- 有大防御值
        cell.unitHasDispellableDebuff = Cell:New(BASE_X - 3, 25) -- 有可驱散的减益效果
        local unitExists = false



        local GroupChangeOnFrame = false

        function eventFrame:GROUP_ROSTER_UPDATE()
            if GroupChangeOnFrame then
                return
            end
            GroupChangeOnFrame = true
            refreshAll()
        end

        function eventFrame:GROUP_JOINED()
            if GroupChangeOnFrame then
                return
            end
            GroupChangeOnFrame = true
            refreshAll()
        end

        function eventFrame:GROUP_LEFT()
            if GroupChangeOnFrame then
                return
            end
            GroupChangeOnFrame = true
            refreshAll()
        end

        function eventFrame:GROUP_FORMED()
            if GroupChangeOnFrame then
                return
            end
            GroupChangeOnFrame = true
            refreshAll()
        end

        eventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
        eventFrame:RegisterEvent("GROUP_JOINED")
        eventFrame:RegisterEvent("GROUP_LEFT")
        eventFrame:RegisterEvent("GROUP_FORMED")
        eventFrame:SetScript("OnEvent", function(self, event, ...)
            self[event](self, ...)
        end)

        local fastTimeElapsed = -random()     -- 随机初始时间，避免所有事件在同一帧更新
        local lowTimeElapsed = -random()      -- 随机初始时间，避免所有事件在同一帧更新
        local superLowTimeElapsed = -random() -- 随机初始时间，避免所有事件在同一帧更新
        eventFrame:HookScript("OnUpdate", function(frame, elapsed)
            GroupChangeOnFrame = false
            fastTimeElapsed = fastTimeElapsed + elapsed
            if fastTimeElapsed > 0.1 then
                fastTimeElapsed = fastTimeElapsed - 0.1
            end
            lowTimeElapsed = lowTimeElapsed + elapsed
            if lowTimeElapsed > 0.5 then
                lowTimeElapsed = lowTimeElapsed - 0.5
            end
            superLowTimeElapsed = superLowTimeElapsed + elapsed
            if superLowTimeElapsed > 2 then
                superLowTimeElapsed = superLowTimeElapsed - 2
                refreshAll()
            end
        end)
    end
end)
