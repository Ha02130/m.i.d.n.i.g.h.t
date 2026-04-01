-- 插件入口
local addonName, addonTable = ... -- luacheck: ignore addonName addonTable


-- Lua 原生函数
local insert                            = table.insert

-- WoW 官方 API
local UnitPower                         = UnitPower
local UnitClass                         = UnitClass
local GetSpecialization                 = GetSpecialization
-- 专精错误则停止
local className, classFilename, classId = UnitClass("player")
local currentSpec                       = GetSpecialization()
if classFilename ~= "DRUID" then return end
-- 插件内引用
local InitUI = addonTable.Listeners.InitUI -- 初始化入口列表
local Cell   = addonTable.Cell             -- 基础色块单元
local Config = addonTable.Config           -- 配置对象工厂


addonTable.RangedRange = 40 -- 远程范围阈值, 单位为码
