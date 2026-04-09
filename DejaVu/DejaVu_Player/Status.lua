local addonName, addonTable = ... -- luacheck: ignore addonName -- 插件入口固定写法

-- Lua 原生函数
local ipairs = ipairs
local After = C_Timer.After
local random = math.random
local min = math.min
local insert = table.insert

-- WoW 官方 API
local GetCurrentKeyBoardFocus = GetCurrentKeyBoardFocus
local GetInventoryItemID = GetInventoryItemID
local GetUnitSpeed = GetUnitSpeed
local IsInGroup = IsInGroup
local IsInRaid = IsInRaid
local IsMounted = IsMounted
local IsUsableItem = C_Item.IsUsableItem
local SpellIsTargeting = SpellIsTargeting
local UnitCanAttack = UnitCanAttack
local UnitChannelInfo = UnitChannelInfo
local UnitEmpoweredStageDurations = UnitEmpoweredStageDurations
local UnitExists = UnitExists
local UnitInVehicle = UnitInVehicle
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local GetUnitAuraInstanceIDs = C_UnitAuras.GetUnitAuraInstanceIDs

local GetItemCooldown = C_Container.GetItemCooldown


-- DejaVu Core
local DejaVu = _G["DejaVu"]
local COLOR = DejaVu.COLOR
local Cell = DejaVu.Cell
local BadgeCell = DejaVu.BadgeCell

local function itemUsable(itemId)
    if not itemId then
        return false
    end

    local startTime, duration, enable = GetItemCooldown(itemId) -- luacheck: ignore startTime
    local usable, noMana = IsUsableItem(itemId)
    return enable == 1 and duration == 0 and usable and not noMana
end

local function slotUsable(slotId)
    return itemUsable(GetInventoryItemID("player", slotId))
end

local cell = {}

After(2, function()                                         -- 延迟加载
    cell.unitCastIcon = BadgeCell:New(45, 14)               -- 单位施法图标
    cell.unitChannelIcon = BadgeCell:New(47, 14)            -- 单位通道图标
    -- 48列
    cell.unitIsAlive = Cell:New(49, 15)                     -- 存活
    -- 49列
    cell.unitClass = Cell:New(50, 14)                       -- 玩家的职业 / updateClassAndRole
    cell.unitRole = Cell:New(50, 15)                        -- 玩家的角色 / updateClassAndRole
    -- 50 列
    cell.unitHealthPercent = Cell:New(51, 14)               -- 生命值百分比
    cell.unitPowerPercent = Cell:New(51, 14)                -- 主能量百分比
    -- 51列
    cell.unitIsInCombat = Cell:New(52, 14)                  -- 在战斗中
    cell.unitIsTarget = Cell:New(52, 15)                    -- 是目标
    -- 52列
    cell.unitHasBigDefense = Cell:New(53, 14)               -- 有大防御值 / updateAuradata
    cell.unitHasDispellableDebuff = Cell:New(53, 15)        -- 有可驱散的减益效果 / updateAuradata
    -- 53列
    cell.unitCastDuration = Cell:New(54, 14)                -- 施法持续时间
    cell.unitChannelDuration = Cell:New(54, 14)             -- 通道持续时间
    -- -- 54列
    cell.unitIsEmpowering = Cell:New(55, 14)                -- 在蓄力
    cell.unitEmpoweringStage = Cell:New(55, 15)             -- 蓄力阶段
    -- 55列
    cell.unitIsMoving = Cell:New(56, 14)                    -- 在移动
    cell.unitIsMounted = Cell:New(56, 15)                   -- 在坐骑
    -- 56列
    cell.unitEnemyCount = Cell:New(57, 14)                  -- 敌人数量
    cell.unitIsSpellTargeting = Cell:New(57, 15)            -- 正在选择目标
    -- 57列
    cell.unitIsChatInputActive = Cell:New(58, 14)           -- 正在聊天输入
    cell.unitIsInGroupOrRaid = Cell:New(58, 15)             -- 在队伍/团队中
    -- 58列
    cell.unitTrinket1CooldownUsable = Cell:New(59, 14)      -- 饰品 1可用
    cell.unitTrinket2CooldownUsable = Cell:New(59, 15)      -- 饰品 2可用
    -- 59列
    cell.unitHealthstoneCooldownUsable = Cell:New(60, 14)   -- 生命石可用
    cell.unitHealingPotionCooldownUsable = Cell:New(60, 15) -- 治疗药水可用





    -- 职业和颜色
    -- 低频刷新
    local function updateClassAndRole()
        cell.unitClass:setCell(COLOR.CLASS[select(2, UnitClass("player"))])                    -- 单位职业
        cell.unitRole:setCell(COLOR.ROLE[UnitGroupRolesAssigned("player")] or COLOR.ROLE.NONE) -- 单位角色
    end


    -- 更新异常状态
    -- 基于UNIT_AURA事件
    -- 低频刷新补正
    local hasAuraUpdateOnFrame = false -- 本帧是否已经处理过 aura 更新，避免同一帧内多次处理
    local function updateAuradata()
        if hasAuraUpdateOnFrame then
            return
        end
        hasAuraUpdateOnFrame = true
        local bigDefenseTable = GetUnitAuraInstanceIDs("player", "HELPFUL|BIG_DEFENSIVE")
        local dispellableDebuffTable = GetUnitAuraInstanceIDs("player", "HARMFUL|RAID_PLAYER_DISPELLABLE")
        cell.unitHasBigDefense:setCellBoolean(#bigDefenseTable > 0, COLOR.STATUS_BOOLEAN.HAS_BIG_DEFENSE, COLOR.BLACK)
        cell.unitHasDispellableDebuff:setCellBoolean(#dispellableDebuffTable > 0, COLOR.STATUS_BOOLEAN.HAS_DISPELLABLE_DEBUFF, COLOR.BLACK)
    end



    local eventFrame = CreateFrame("eventFrame")
    local fastTimeElapsed = -random()     -- 随机初始时间，避免所有事件在同一帧更新
    local lowTimeElapsed = -random()      -- 随机初始时间，避免所有事件在同一帧更新
    local superLowTimeElapsed = -random() -- 随机初始时间，避免所有事件在同一帧更新
    eventFrame:HookScript("OnUpdate", function(frame, elapsed)
        hasAuraUpdateOnFrame = false
        fastTimeElapsed = fastTimeElapsed + elapsed
        if fastTimeElapsed > 0.2 then
            fastTimeElapsed = fastTimeElapsed - 0.2
        end
        lowTimeElapsed = lowTimeElapsed + elapsed
        if lowTimeElapsed > 0.5 then
            lowTimeElapsed = lowTimeElapsed - 0.5
        end
        superLowTimeElapsed = superLowTimeElapsed + elapsed
        if superLowTimeElapsed > 2 then
            superLowTimeElapsed = superLowTimeElapsed - 2
            updateClassAndRole()
            updateAuradata()
        end
    end)


    function eventFrame:UNIT_AURA(unitToken, info)
        if info.isFullUpdate or info.removedAuraInstanceIDs or info.addedAuras then
            updateAuradata()
        end
    end

    eventFrame:RegisterUnitEvent("UNIT_AURA", "player")
    eventFrame:SetScript("OnEvent", function(self, event, ...)
        self[event](self, ...)
    end)
end)
