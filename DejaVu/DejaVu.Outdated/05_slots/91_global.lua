--[[
文件定位:
  DejaVu 全局模块。

状态:
  draft
]]

local addonName, addonTable = ... -- luacheck: ignore addonName -- 插件入口固定写法

-- Lua 原生函数
local tonumber = tonumber
local insert = table.insert

-- WoW 官方 API
local GetTime = GetTime

-- 插件内引用
local InitUI = addonTable.Listeners.InitUI             -- 初始化入口列表
local COLOR = addonTable.COLOR                         -- 颜色表
local Cell = addonTable.Cell                           -- 基础色块单元
local CharCell = addonTable.CharCell                   -- 文字单元
local OnUpdateHigh = addonTable.Listeners.OnUpdateHigh -- 高频刷新回调列表






local function InitializeGlobalCell() -- 初始化全局槽位
    local cell = {}


    cell.flashCell = Cell:New(54, 9)              -- 闪烁cell ，用于判断插帧
    cell.isWaitingDelayedUpdate = Cell:New(55, 9) -- delay Cell，给延迟宏设计
    cell.combat_time = Cell:New(56, 9)            -- combat_cell 记录战斗时长
    local non_combat_timestamp = GetTime()
    -- 57,9被spell queue window使用
    cell.useMouse = Cell:New(58, 9) -- 记录鼠标正在使用。


    cell.testCell = CharCell:New(0, 2)
    cell.testCell:setCell("*")
    cell.enableCell = Cell:New(83, 0)    -- 全局开关
    cell.burstCell = Cell:New(82, 0)     -- 爆发开关

    Cell:New(82, 2):setCell(COLOR.WHITE) -- 右上角监测点

    local flashValue = true
    local delayTimestamp = GetTime()

    SLASH_DELAY1 = "/delay"
    SlashCmdList["DELAY"] = function(msg)
        local delaySeconds = tonumber(msg)
        if delaySeconds then
            delayTimestamp = GetTime() + delaySeconds
        end
    end

    local function updateHighFrequency()
        cell.flashCell:setCellBoolean(flashValue, COLOR.WHITE, COLOR.BLACK)
        flashValue = not flashValue
        cell.isWaitingDelayedUpdate:setCellBoolean(
            delayTimestamp > GetTime(),
            COLOR.STATUS_BOOLEAN.IS_WAITING_DELAYED_UPDATE,
            COLOR.BLACK
        )

        if UnitAffectingCombat("player") then
            local combat_time = min(255, floor(GetTime() - non_combat_timestamp))
            -- print(combat_time)
            cell.combat_time:setCellRGBA(combat_time / 255)
        else
            non_combat_timestamp = GetTime()
            cell.combat_time:clearCell()
        end

        local useMouse = IsMouselooking() or IsMouseButtonDown("LeftButton") or IsMouseButtonDown("RightButton") or IsMouseButtonDown("MiddleButton") or IsMouseButtonDown("Button4") or IsMouseButtonDown("Button5")
        cell.useMouse:setCellBoolean(useMouse, COLOR.STATUS_BOOLEAN.USE_MOUSE, COLOR.BLACK)
        -- print("IsMouselooking()" .. tostring(IsMouselooking()))
        -- print("IsMouseButtonDown(1)" .. tostring(IsMouseButtonDown(1)))
        -- print("IsMouseButtonDown(2)" .. tostring(IsMouseButtonDown(2)))
        -- print("IsMouseButtonDown(3)" .. tostring(IsMouseButtonDown(3)))

        cell.enableCell:setCellBoolean(addonTable.Enable == true, COLOR.WHITE, COLOR.BLACK)

        local burstRemaining = addonTable.BurstRemaining()
        cell.burstCell:setCellRGBA(burstRemaining / 60)
    end
    insert(OnUpdateHigh, updateHighFrequency)
end

insert(InitUI, InitializeGlobalCell)
