--[[
文件定位:
  DejaVu 德鲁伊职业特色Cell组配置模块, 定义德鲁伊形态相关的Cell布局。



状态:
  draft
]]

-- 插件入口
local addonName, addonTable = ... -- luacheck: ignore addonName addonTable


-- Lua 原生函数
local insert                            = table.insert
local pairs                             = pairs

-- WoW 官方 API
local CreateFrame                       = CreateFrame
local SetOverrideBindingClick           = SetOverrideBindingClick
local UnitClass                         = UnitClass
local GetSpecialization                 = GetSpecialization
-- 专精错误则停止
local className, classFilename, classId = UnitClass("player")
local currentSpec                       = GetSpecialization()
if classFilename ~= "DRUID" then return end        -- 不是德鲁伊则停止
if currentSpec ~= 4 then return end                -- 不是恢复专精则停止
local logging        = addonTable.Logging
local InitUI         = addonTable.Listeners.InitUI -- 初始化入口列表
local Cell           = addonTable.Cell             -- 基础色块单元
local Config         = addonTable.Config           -- 配置对象工厂
local Slots          = addonTable.Slots

local chargeSpells   = Slots.chargeSpells                          -- 充能技能列表
local cooldownSpells = Slots.cooldownSpells                        -- 普通冷却技能列表

insert(cooldownSpells, { spellID = 102793, cdType = "cooldown" })  --  [乌索尔旋风]
insert(cooldownSpells, { spellID = 474750, cdType = "cooldown" })  --  [共生关系]
insert(cooldownSpells, { spellID = 1079, cdType = "cooldown" })    -- [割裂]
insert(cooldownSpells, { spellID = 132469, cdType = "cooldown" })  --  [台风]
insert(cooldownSpells, { spellID = 774, cdType = "cooldown" })     --  [回春术]
insert(cooldownSpells, { spellID = 210053, cdType = "cooldown" })  --  [坐骑形态]
insert(cooldownSpells, { spellID = 20484, cdType = "cooldown" })   --  [复生]
insert(cooldownSpells, { spellID = 99, cdType = "cooldown" })      --  [夺魂咆哮]
insert(cooldownSpells, { spellID = 2908, cdType = "cooldown" })    --  [安抚]
insert(cooldownSpells, { spellID = 1850, cdType = "cooldown" })    --  [急奔]
insert(cooldownSpells, { spellID = 8936, cdType = "cooldown" })    --  [愈合]
insert(cooldownSpells, { spellID = 5176, cdType = "cooldown" })    --  [愤怒]
insert(cooldownSpells, { spellID = 1822, cdType = "cooldown" })    --  [斜掠]
insert(cooldownSpells, { spellID = 5221, cdType = "cooldown" })    --  [撕碎]
insert(cooldownSpells, { spellID = 783, cdType = "cooldown" })     --  [旅行形态]
insert(cooldownSpells, { spellID = 8921, cdType = "cooldown" })    --  [月火术]
insert(cooldownSpells, { spellID = 22812, cdType = "cooldown" })   --  [树皮术]
insert(cooldownSpells, { spellID = 29166, cdType = "cooldown" })   --  [激活]
insert(cooldownSpells, { spellID = 5487, cdType = "cooldown" })    --  [熊形态]
insert(cooldownSpells, { spellID = 106898, cdType = "cooldown" })  --  [狂奔怒吼]
insert(cooldownSpells, { spellID = 1261867, cdType = "cooldown" }) --  [野性之心]
insert(cooldownSpells, { spellID = 1126, cdType = "cooldown" })    --  [野性印记]
insert(cooldownSpells, { spellID = 391528, cdType = "cooldown" })  --  [万灵之召]
insert(cooldownSpells, { spellID = 740, cdType = "cooldown" })     --  [宁静]
insert(cooldownSpells, { spellID = 33763, cdType = "cooldown" })   --  [生命绽放]
insert(cooldownSpells, { spellID = 132158, cdType = "cooldown" })  --  [自然迅捷]
insert(cooldownSpells, { spellID = 102342, cdType = "cooldown" })  --  [铁木树皮]


insert(chargeSpells, { spellID = 22842, cdType = "charges" }) --  [狂暴回复]
insert(chargeSpells, { spellID = 88423, cdType = "charges" }) --  [自然之愈]
insert(chargeSpells, { spellID = 18562, cdType = "charges" }) --  [迅捷治愈]




local macroList = {}
insert(macroList, { title = "reloadUI", key = "CTRL-F12", text = "/reload" })


for _, macro in pairs(macroList) do --输出2 test2, 6 test3, 4 test1
    local buttonName = addonName .. "Button" .. macro.title
    local frame = CreateFrame("Button", buttonName, UIParent, "SecureActionButtonTemplate")
    frame:SetAttribute("type", "macro")
    frame:SetAttribute("macrotext", macro.text)
    frame:RegisterForClicks("AnyDown", "AnyUp")
    SetOverrideBindingClick(frame, true, macro.key, buttonName)
    logging("RegMacro[" .. macro.title .. "] > " .. macro.key .. " > " .. macro.text)
end
