if( GetLocale() ~= "zhTW" ) then
    return
end

local Nameplates = select(2, ...)

Nameplates.L = setmetatable({
    -- Status
    ["Enemy player/npc name plates are now visible."]   = "敵對玩家/NPC姓名板當前為顯示狀態",
    ["Enemy player/npc name plates are now hidden."]    = "敵對玩家/NPC姓名板當前為隱藏狀態",
    ["Friendly player/npc name plates are now visible."]= "好友玩家/NPC姓名板當前為顯示狀態",
    ["Friendly player/npc name plates are now hidden."] = "好友玩家/NPC姓名板當前為隱藏狀態",
    ["All name plates are now visible."]                = "所有姓名板當前為顯示狀態",
    ["All name plates are now hidden."]                 = "所有姓名板當前為隱藏狀態",

    -- GUI
    ["General"]                           = "常規設置",
    ["Bars"]                              = "Bars",
    ["Bar texture"]                       = "姓名板紋理",
    ["Shadow"]                            = "陰影",
    ["Custom texture to use for health and cast bars in name plates."] = "自定義姓名板與施法條的材質",
    ["Name text"]                         = "姓名文字設置",
    ["Cast/Health text"]                  = "施法條/血量設置",
    ["Level text"]                        = "等級文字設置",
    ["Text"]                              = "字體設置",
    ["Font name"]                         = "字體名稱",
    ["Font size"]                         = "字體大小",
    ["Font border"]                       = "字體描邊",
    ["Health text display"]               = "血量文字顯示",
    ["Cast text display"]                 = "施法文字顯示",
    ["Style of display for health bar text."] = "更改血量文字顯示的樣式",
    ["Style of display for cast bar text."]   = "更改施法文字顯示的樣式",
    ["Outline"]                           = "標準描邊",
    ["Thick outline"]                     = "厚描邊",
    ["Monochrome"]                        = "單線",
    ["Font"]                              = "字體設置",
    ["Nameplates"]                        = "姓名板",
    ["Hide elite indicator"]              = "隱藏精英指示器",
    ["Min / Max"]                         = "最小值/最大值",
    ["Deficit"]                           = "損失血量",
    ["Percent"]                           = "百分比",
    ["None"]                              = "無",
    ["Current / Max"]                     = "當前血量/最大值",
    ["Current"]                           = "當前血量",
    ["Time left"]                         = "剩餘時間",
    ["Enable shadow"]                     = "開啟陰影",
    ["Shadow color"]                      = "陰影顏色",
    ["Shadow offset X"]                   = "陰影 X 偏移",
    ["Shadow offset Y"]                   = "陰影 Y 偏移",
    ["Show nameplate visibility status"]  = "提示當前姓名板顯示狀態",
    ["Hide health bar border"]            = "隱藏血條邊框",
    ["Hide cast bar border"]              = "隱藏施法條邊框",
    ["A UI reload is required to make the border show again."]          = "只有當你重載界面后才能再次顯示邊框",
    ["A UI reload is required to make the elite indicator show again."] = "只有當你重載界面后才能再次顯示精英指示器",
    ["A UI reload is required to make the cast shield indicator show again."] = "只有當你重載界面后才能再次顯示施法護盾",

    -- Health border color
    ["Health border color"]               = "血條邊框顏色",

    -- Hide cast uninterruptible shield
    ["Hide cast uninterruptible shield"]  = "隱藏不可打斷施法護盾",

    -- Debuffs
    ["Debuffs"]                           = "減益效果",
    ["Show debuffs"]                      = "顯示減益效果",
    ["Show debuffs cast by you above the nameplate health bar."] = "在姓名板血條上方顯示你施加的減益效果",
    ["Icon size"]                         = "圖標大小",
    ["Size of each debuff icon in pixels."] = "每個減益圖標的像素大小",
    ["Icon offset X"]                     = "圖標 X 偏移",
    ["Horizontal offset of the debuff icons."] = "減益圖標水平偏移",
    ["Icon offset Y"]                     = "圖標 Y 偏移",
    ["Vertical offset of the debuff icons."]   = "減益圖標垂直偏移",
}, {__index = Nameplates.L})
