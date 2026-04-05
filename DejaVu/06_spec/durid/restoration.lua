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
insert(cooldownSpells, { spellID = 48438, cdType = "cooldown" })   --  [野性生长]


insert(chargeSpells, { spellID = 22842, cdType = "charges" }) --  [狂暴回复]
insert(chargeSpells, { spellID = 88423, cdType = "charges" }) --  [自然之愈]
insert(chargeSpells, { spellID = 18562, cdType = "charges" }) --  [迅捷治愈]




local macroList = {}
insert(macroList, { title = "reloadUI", key = "CTRL-F12", text = "/reload" })
insert(macroList, { title = "player铁木树皮", key = "ALT-NUMPAD1", text = "/cast [@player] 铁木树皮" })
insert(macroList, { title = "party1铁木树皮", key = "ALT-NUMPAD2", text = "/cast [@party1] 铁木树皮" })
insert(macroList, { title = "party2铁木树皮", key = "ALT-NUMPAD3", text = "/cast [@party2] 铁木树皮" })
insert(macroList, { title = "party3铁木树皮", key = "ALT-NUMPAD4", text = "/cast [@party3] 铁木树皮" })
insert(macroList, { title = "party4铁木树皮", key = "ALT-NUMPAD5", text = "/cast [@party4] 铁木树皮" })
insert(macroList, { title = "player自然之愈", key = "ALT-NUMPAD6", text = "/cast [@player] 自然之愈" })
insert(macroList, { title = "party1自然之愈", key = "ALT-NUMPAD7", text = "/cast [@party1] 自然之愈" })
insert(macroList, { title = "party2自然之愈", key = "ALT-NUMPAD8", text = "/cast [@party2] 自然之愈" })
insert(macroList, { title = "party3自然之愈", key = "ALT-NUMPAD9", text = "/cast [@party3] 自然之愈" })
insert(macroList, { title = "party4自然之愈", key = "ALT-NUMPAD0", text = "/cast [@party4] 自然之愈" })
insert(macroList, { title = "player共生关系", key = "ALT-F1", text = "/cast [@player] 共生关系" })
insert(macroList, { title = "party1共生关系", key = "ALT-F2", text = "/cast [@party1] 共生关系" })
insert(macroList, { title = "party2共生关系", key = "ALT-F3", text = "/cast [@party2] 共生关系" })
insert(macroList, { title = "party3共生关系", key = "ALT-F5", text = "/cast [@party3] 共生关系" })
insert(macroList, { title = "party4共生关系", key = "ALT-F6", text = "/cast [@party4] 共生关系" })
insert(macroList, { title = "player生命绽放", key = "ALT-F7", text = "/cast [@player] 生命绽放" })
insert(macroList, { title = "party1生命绽放", key = "ALT-F8", text = "/cast [@party1] 生命绽放" })
insert(macroList, { title = "party2生命绽放", key = "ALT-F9", text = "/cast [@party2] 生命绽放" })
insert(macroList, { title = "party3生命绽放", key = "ALT-F10", text = "/cast [@party3] 生命绽放" })
insert(macroList, { title = "party4生命绽放", key = "ALT-F11", text = "/cast [@party4] 生命绽放" })
insert(macroList, { title = "player野性成长", key = "ALT-F12", text = "/cast [@player] 野性成长" })
insert(macroList, { title = "party1野性成长", key = "ALT-,", text = "/cast [@party1] 野性成长" })
insert(macroList, { title = "party2野性成长", key = "ALT-.", text = "/cast [@party2] 野性成长" })
insert(macroList, { title = "party3野性成长", key = "ALT-/", text = "/cast [@party3] 野性成长" })
insert(macroList, { title = "party4野性成长", key = "ALT-;", text = "/cast [@party4] 野性成长" })
insert(macroList, { title = "player愈合", key = "ALT-'", text = "/cast [@player] 愈合" })
insert(macroList, { title = "party1愈合", key = "ALT-[", text = "/cast [@party1] 愈合" })
insert(macroList, { title = "party2愈合", key = "ALT-]", text = "/cast [@party2] 愈合" })
insert(macroList, { title = "party3愈合", key = "ALT-=", text = "/cast [@party3] 愈合" })
insert(macroList, { title = "party4愈合", key = "ALT-`", text = "/cast [@party4] 愈合" })
insert(macroList, { title = "player回春术", key = "SHIFT-NUMPAD1", text = "/cast [@player] 回春术" })
insert(macroList, { title = "party1回春术", key = "SHIFT-NUMPAD2", text = "/cast [@party1] 回春术" })
insert(macroList, { title = "party2回春术", key = "SHIFT-NUMPAD3", text = "/cast [@party2] 回春术" })
insert(macroList, { title = "party3回春术", key = "SHIFT-NUMPAD4", text = "/cast [@party3] 回春术" })
insert(macroList, { title = "party4回春术", key = "SHIFT-NUMPAD5", text = "/cast [@party4] 回春术" })
insert(macroList, { title = "树皮术", key = "SHIFT-NUMPAD6", text = "/cast 树皮术" })
insert(macroList, { title = "万灵之召", key = "SHIFT-NUMPAD7", text = "/cast 万灵之召" })
insert(macroList, { title = "宁静", key = "SHIFT-NUMPAD8", text = "/cast 宁静" })
insert(macroList, { title = "自然迅捷", key = "SHIFT-NUMPAD9", text = "/cast 自然迅捷" })
insert(macroList, { title = "迅捷治愈", key = "SHIFT-NUMPAD0", text = "/cast 迅捷治愈" })
insert(macroList, { title = "target斜掠", key = "SHIFT-F1", text = "/cast [@target] 斜掠" })
insert(macroList, { title = "target撕碎", key = "SHIFT-F2", text = "/cast [@target] 撕碎" })
insert(macroList, { title = "target割裂", key = "SHIFT-F3", text = "/cast [@target] 割裂" })
insert(macroList, { title = "target野性之心", key = "SHIFT-F5", text = "/cast 野性之心" })
insert(macroList, { title = "target月火术", key = "SHIFT-F6", text = "/cast [@target] 月火术" })
insert(macroList, { title = "target愤怒", key = "SHIFT-F7", text = "/cast [@target] 愤怒" })
insert(macroList, { title = "激活", key = "SHIFT-F8", text = "/cast [@player] 激活" })
insert(macroList, { title = "mouseover复生", key = "SHIFT-F9", text = "/cast [@mouseover] 复生" })


for _, macro in pairs(macroList) do --输出2 test2, 6 test3, 4 test1
    local buttonName = addonName .. "Button" .. macro.title
    local frame = CreateFrame("Button", buttonName, UIParent, "SecureActionButtonTemplate")
    frame:SetAttribute("type", "macro")
    frame:SetAttribute("macrotext", macro.text)
    frame:RegisterForClicks("AnyDown", "AnyUp")
    SetOverrideBindingClick(frame, true, macro.key, buttonName)
    logging("RegMacro[" .. macro.title .. "] > " .. macro.key .. " > " .. macro.text)
end

-- 全局变量。设置窗体数不够，这些修改较少的，放在变量里。
local WILD_GROWTH_COUNT_THRESHOLD = 2

do
    -- x:55 y:12
    -- 铁木树皮血量 min:30 max:70 default:50 step:5
    -- 对低于该血量的非坦克玩家使用铁木树皮的阈值。\n 针对坦克玩家，请手动释放。
    local restoration_ironbark_hp_threshold = Config("restoration_ironbark_hp_threshold")

    -- x:56 y:12
    -- 树皮术血量 min:40 max:90 default:65 step:5
    -- 对自己使用树皮术的阈值。
    local restoration_barkskin_hp_threshold = Config("restoration_barkskin_hp_threshold")

    -- x:57 y:12
    -- 万灵队伍血量 min:40 max:80 default:60 step:5
    -- 当队伍平均血量低于该值时，使用万灵
    local restoration_convoke_party_hp_threshold = Config("restoration_convoke_party_hp_threshold")

    -- x:58 y:12
    -- 万灵单体血量 min:20 max:40 default:25 step:5
    -- 当某人血量低于该值时，使用万灵
    local restoration_convoke_single_hp_threshold = Config("restoration_convoke_single_hp_threshold")

    -- x:59 y:12
    -- 野性成长血量 min:75 max:95 default:95 step:5
    -- 当至少{WILD_GROWTH_COUNT_THRESHOLD}个玩家的血量低于该值时，使用野性成长。
    local restoration_wild_growth_hp_threshold = Config("restoration_wild_growth_hp_threshold")

    -- x:60 y:12
    -- 宁静队血 min:40 max:70 default:50 step:5
    -- 队伍平均血量低于该值时，使用宁静。
    local restoration_tranquility_party_hp_threshold = Config("restoration_tranquility_party_hp_threshold")

    -- x:61 y:12
    -- 自然迅捷血量 min:50 max:70 default:60 step:5
    -- 当非坦克玩家血量低于此值时，使用自然迅捷。
    local restoration_nature_swiftness_hp_threshold = Config("restoration_nature_swiftness_hp_threshold")

    -- x:62 y:12
    -- 迅捷治愈血量 min:70 max:100 default:90 step:5
    -- 统计低于该血量的，身上有2个hot的人数。
    local restoration_swiftmend_hp_threshold = Config("restoration_swiftmend_hp_threshold")

    -- x:63 y:12
    -- 迅捷治愈人数 min:1 max:5 default:2 step:1
    -- 满足迅捷治愈血量的人数，大于等于此值，则释放迅捷治愈。
    local restoration_swiftmend_count_threshold = Config("restoration_swiftmend_count_threshold")

    -- x:64 y:12
    -- 愈合血量  min:70 max:95 default:85 step:5
    -- 低于该血量，且身上有1个hot的目标会被愈合。
    local restoration_regrowth_hp_threshold = Config("restoration_regrowth_hp_threshold")

    -- x:65 y:12
    -- 回春血量  min:85 max:99 default:97 step:1
    -- 低于该血量，会释放回春。
    local restoration_rejuvenation_hp_threshold = Config("restoration_rejuvenation_hp_threshold")

    -- x:66 y:12
    -- 丰饶保持  min:0 max:10 default:5 step:1
    -- 针对5人小队，非爆发阶段要保持多少丰饶（回春预铺）
    local restoration_abundance_stack_threshold = Config("restoration_abundance_stack_threshold")

    -- x:67 y:12
    -- 坦克缺口忽略  min:0 max:50 default:15 step:1
    -- 计算坦克的血量时，当坦克的血量缺口小于这个百分比时，认为坦克是满血的
    local restoration_tank_deficit_ignore_percent = Config("restoration_tank_deficit_ignore_percent")


    -- x:68 y:12
    -- hot等效  min:0 max:6 default:3.2 step:0.2
    -- 每个hot等效的生命值
    local restoration_hot_hp_threshold = Config("restoration_hot_hp_threshold")


    insert(addonTable.Panel.Rows, {
        type = "slider",
        key = "restoration_ironbark_hp_threshold",
        name = "铁木树皮血量",
        tooltip = "对低于该血量的非坦克玩家使用铁木树皮的阈值。\n针对坦克玩家，请手动释放。",
        min_value = 30,
        max_value = 70,
        step = 5,
        default_value = 50,
        bind_config = restoration_ironbark_hp_threshold,
    })

    insert(addonTable.Panel.Rows, {
        type = "slider",
        key = "restoration_barkskin_hp_threshold",
        name = "树皮术血量",
        tooltip = "对自己使用树皮术的阈值。",
        min_value = 40,
        max_value = 90,
        step = 5,
        default_value = 65,
        bind_config = restoration_barkskin_hp_threshold,
    })

    insert(addonTable.Panel.Rows, {
        type = "slider",
        key = "restoration_convoke_party_hp_threshold",
        name = "万灵队伍血量",
        tooltip = "当队伍平均血量低于该值时，使用万灵",
        min_value = 40,
        max_value = 80,
        step = 5,
        default_value = 60,
        bind_config = restoration_convoke_party_hp_threshold,
    })

    insert(addonTable.Panel.Rows, {
        type = "slider",
        key = "restoration_convoke_single_hp_threshold",
        name = "万灵单体血量",
        tooltip = "当某人血量低于该值时，使用万灵",
        min_value = 20,
        max_value = 40,
        step = 5,
        default_value = 25,
        bind_config = restoration_convoke_single_hp_threshold,
    })

    insert(addonTable.Panel.Rows, {
        type = "slider",
        key = "restoration_wild_growth_hp_threshold",
        name = "野性成长血量",
        tooltip = "当至少" .. WILD_GROWTH_COUNT_THRESHOLD .. "个玩家的血量低于该值时，使用野性成长。",
        min_value = 75,
        max_value = 95,
        step = 5,
        default_value = 95,
        bind_config = restoration_wild_growth_hp_threshold,
    })

    insert(addonTable.Panel.Rows, {
        type = "slider",
        key = "restoration_tranquility_party_hp_threshold",
        name = "宁静队血",
        tooltip = "队伍平均血量低于该值时，使用宁静。",
        min_value = 40,
        max_value = 70,
        step = 5,
        default_value = 50,
        bind_config = restoration_tranquility_party_hp_threshold,
    })

    insert(addonTable.Panel.Rows, {
        type = "slider",
        key = "restoration_nature_swiftness_hp_threshold",
        name = "自然迅捷血量",
        tooltip = "当非坦克玩家血量低于此值时，使用自然迅捷。",
        min_value = 50,
        max_value = 70,
        step = 5,
        default_value = 60,
        bind_config = restoration_nature_swiftness_hp_threshold,
    })

    insert(addonTable.Panel.Rows, {
        type = "slider",
        key = "restoration_swiftmend_hp_threshold",
        name = "迅捷治愈血量",
        tooltip = "统计低于该血量的，身上有2个hot的人数。",
        min_value = 70,
        max_value = 100,
        step = 5,
        default_value = 90,
        bind_config = restoration_swiftmend_hp_threshold,
    })

    insert(addonTable.Panel.Rows, {
        type = "slider",
        key = "restoration_swiftmend_count_threshold",
        name = "迅捷治愈人数",
        tooltip = "满足迅捷治愈血量的人数，大于等于此值，则释放迅捷治愈。",
        min_value = 1,
        max_value = 5,
        step = 1,
        default_value = 2,
        bind_config = restoration_swiftmend_count_threshold,
    })

    insert(addonTable.Panel.Rows, {
        type = "slider",
        key = "restoration_regrowth_hp_threshold",
        name = "愈合血量",
        tooltip = "低于该血量，且身上有1个hot的目标会被愈合。",
        min_value = 70,
        max_value = 95,
        step = 5,
        default_value = 85,
        bind_config = restoration_regrowth_hp_threshold,
    })

    insert(addonTable.Panel.Rows, {
        type = "slider",
        key = "restoration_rejuvenation_hp_threshold",
        name = "回春血量",
        tooltip = "低于该血量，会释放回春。",
        min_value = 85,
        max_value = 99,
        step = 1,
        default_value = 97,
        bind_config = restoration_rejuvenation_hp_threshold,
    })

    insert(addonTable.Panel.Rows, {
        type = "slider",
        key = "restoration_abundance_stack_threshold",
        name = "丰饶保持",
        tooltip = "针对5人小队，非爆发阶段要保持多少丰饶（回春预铺）",
        min_value = 0,
        max_value = 10,
        step = 1,
        default_value = 5,
        bind_config = restoration_abundance_stack_threshold,
    })

    insert(addonTable.Panel.Rows, {
        type = "slider",
        key = "restoration_tank_deficit_ignore_percent",
        name = "坦克缺口忽略",
        tooltip = "计算坦克的血量时，当坦克的血量缺口小于这个百分比时，认为坦克是满血的",
        min_value = 0,
        max_value = 50,
        step = 1,
        default_value = 15,
        bind_config = restoration_tank_deficit_ignore_percent,
    })

    insert(addonTable.Panel.Rows, {
        type = "slider",
        key = "restoration_hot_hp_threshold",
        name = "hot等效",
        tooltip = "每个hot等效的生命值",
        min_value = 0,
        max_value = 5,
        step = 0.2,
        default_value = 3.2,
        bind_config = restoration_hot_hp_threshold,
    })

    local function InitializeRestorationSettingCell()
        local restoration_ironbark_hp_threshold_cell = Cell:New(55, 12)
        local restoration_barkskin_hp_threshold_cell = Cell:New(56, 12)
        local restoration_convoke_party_hp_threshold_cell = Cell:New(57, 12)
        local restoration_convoke_single_hp_threshold_cell = Cell:New(58, 12)
        local restoration_wild_growth_hp_threshold_cell = Cell:New(59, 12)
        local restoration_tranquility_party_hp_threshold_cell = Cell:New(60, 12)
        local restoration_nature_swiftness_hp_threshold_cell = Cell:New(61, 12)
        local restoration_swiftmend_hp_threshold_cell = Cell:New(62, 12)
        local restoration_swiftmend_count_threshold_cell = Cell:New(63, 12)
        local restoration_regrowth_hp_threshold_cell = Cell:New(64, 12)
        local restoration_rejuvenation_hp_threshold_cell = Cell:New(65, 12)
        local restoration_abundance_stack_threshold_cell = Cell:New(66, 12)
        local restoration_tank_deficit_ignore_percent_cell = Cell:New(67, 12)
        local restoration_hot_hp_threshold_cell = Cell:New(68, 12)

        local function set_restoration_ironbark_hp_threshold(value)
            restoration_ironbark_hp_threshold_cell:setCellRGBA(value / 255)
        end
        set_restoration_ironbark_hp_threshold(restoration_ironbark_hp_threshold:get_value())
        restoration_ironbark_hp_threshold:register_callback(set_restoration_ironbark_hp_threshold)

        local function set_restoration_barkskin_hp_threshold(value)
            restoration_barkskin_hp_threshold_cell:setCellRGBA(value / 255)
        end
        set_restoration_barkskin_hp_threshold(restoration_barkskin_hp_threshold:get_value())
        restoration_barkskin_hp_threshold:register_callback(set_restoration_barkskin_hp_threshold)

        local function set_restoration_convoke_party_hp_threshold(value)
            restoration_convoke_party_hp_threshold_cell:setCellRGBA(value / 255)
        end
        set_restoration_convoke_party_hp_threshold(restoration_convoke_party_hp_threshold:get_value())
        restoration_convoke_party_hp_threshold:register_callback(set_restoration_convoke_party_hp_threshold)

        local function set_restoration_convoke_single_hp_threshold(value)
            restoration_convoke_single_hp_threshold_cell:setCellRGBA(value / 255)
        end
        set_restoration_convoke_single_hp_threshold(restoration_convoke_single_hp_threshold:get_value())
        restoration_convoke_single_hp_threshold:register_callback(set_restoration_convoke_single_hp_threshold)

        local function set_restoration_wild_growth_hp_threshold(value)
            restoration_wild_growth_hp_threshold_cell:setCellRGBA(value / 255)
        end
        set_restoration_wild_growth_hp_threshold(restoration_wild_growth_hp_threshold:get_value())
        restoration_wild_growth_hp_threshold:register_callback(set_restoration_wild_growth_hp_threshold)

        local function set_restoration_tranquility_party_hp_threshold(value)
            restoration_tranquility_party_hp_threshold_cell:setCellRGBA(value / 255)
        end
        set_restoration_tranquility_party_hp_threshold(restoration_tranquility_party_hp_threshold:get_value())
        restoration_tranquility_party_hp_threshold:register_callback(set_restoration_tranquility_party_hp_threshold)

        local function set_restoration_nature_swiftness_hp_threshold(value)
            restoration_nature_swiftness_hp_threshold_cell:setCellRGBA(value / 255)
        end
        set_restoration_nature_swiftness_hp_threshold(restoration_nature_swiftness_hp_threshold:get_value())
        restoration_nature_swiftness_hp_threshold:register_callback(set_restoration_nature_swiftness_hp_threshold)

        local function set_restoration_swiftmend_hp_threshold(value)
            restoration_swiftmend_hp_threshold_cell:setCellRGBA(value / 255)
        end
        set_restoration_swiftmend_hp_threshold(restoration_swiftmend_hp_threshold:get_value())
        restoration_swiftmend_hp_threshold:register_callback(set_restoration_swiftmend_hp_threshold)

        local function set_restoration_swiftmend_count_threshold(value)
            restoration_swiftmend_count_threshold_cell:setCellRGBA(value * 20 / 255)
        end
        set_restoration_swiftmend_count_threshold(restoration_swiftmend_count_threshold:get_value())
        restoration_swiftmend_count_threshold:register_callback(set_restoration_swiftmend_count_threshold)

        local function set_restoration_regrowth_hp_threshold(value)
            restoration_regrowth_hp_threshold_cell:setCellRGBA(value / 255)
        end
        set_restoration_regrowth_hp_threshold(restoration_regrowth_hp_threshold:get_value())
        restoration_regrowth_hp_threshold:register_callback(set_restoration_regrowth_hp_threshold)

        local function set_restoration_rejuvenation_hp_threshold(value)
            restoration_rejuvenation_hp_threshold_cell:setCellRGBA(value / 255)
        end
        set_restoration_rejuvenation_hp_threshold(restoration_rejuvenation_hp_threshold:get_value())
        restoration_rejuvenation_hp_threshold:register_callback(set_restoration_rejuvenation_hp_threshold)

        local function set_restoration_abundance_stack_threshold(value)
            restoration_abundance_stack_threshold_cell:setCellRGBA(value * 20 / 255)
        end
        set_restoration_abundance_stack_threshold(restoration_abundance_stack_threshold:get_value())
        restoration_abundance_stack_threshold:register_callback(set_restoration_abundance_stack_threshold)

        local function set_restoration_tank_deficit_ignore_percent(value)
            restoration_tank_deficit_ignore_percent_cell:setCellRGBA(value / 255)
        end
        set_restoration_tank_deficit_ignore_percent(restoration_tank_deficit_ignore_percent:get_value())
        restoration_tank_deficit_ignore_percent:register_callback(set_restoration_tank_deficit_ignore_percent)

        local function set_restoration_hot_hp_threshold(value)
            restoration_hot_hp_threshold_cell:setCellRGBA(value * 20 / 255)
        end
        set_restoration_hot_hp_threshold(restoration_hot_hp_threshold:get_value())
        restoration_hot_hp_threshold:register_callback(set_restoration_hot_hp_threshold)
    end

    insert(InitUI, InitializeRestorationSettingCell)
end
