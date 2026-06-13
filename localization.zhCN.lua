if( GetLocale() ~= "zhCN" ) then
    return
end

local Nameplates = select(2, ...)

Nameplates.L = setmetatable({
    -- Status
    ["Enemy player/npc name plates are now visible."]   = "敌对玩家/NPC姓名板当前为显示状态",
    ["Enemy player/npc name plates are now hidden."]    = "敌对玩家/NPC姓名板当前为隐藏状态",
    ["Friendly player/npc name plates are now visible."]= "好友玩家/NPC姓名板当前为显示状态",
    ["Friendly player/npc name plates are now hidden."] = "好友玩家/NPC姓名板当前为隐藏状态",
    ["All name plates are now visible."]                = "所有姓名板当前为显示状态",
    ["All name plates are now hidden."]                 = "所有姓名板当前为隐藏状态",

    -- GUI
    ["General"]                           = "常规设置",
    ["Bars"]                              = "Bars",
    ["Bar texture"]                       = "姓名板纹理",
    ["Shadow"]                            = "阴影",
    ["Custom texture to use for health and cast bars in name plates."] = "自定义姓名板与施法条的材质",
    ["Name text"]                         = "姓名文字设置",
    ["Cast/Health text"]                  = "施法条/血量设置",
    ["Level text"]                        = "等级文字设置",
    ["Text"]                              = "字体设置",
    ["Font name"]                         = "字体名称",
    ["Font size"]                         = "字体大小",
    ["Font border"]                       = "字体描边",
    ["Health text display"]               = "血量文字显示",
    ["Cast text display"]                 = "施法文字显示",
    ["Style of display for health bar text."] = "更改血量文字显示的样式",
    ["Style of display for cast bar text."]   = "更改施法文字显示的样式",
    ["Outline"]                           = "标准描边",
    ["Thick outline"]                     = "厚描边",
    ["Monochrome"]                        = "单线",
    ["Font"]                              = "字体设置",
    ["Nameplates"]                        = "姓名板",
    ["Hide elite indicator"]              = "隐藏精英指示器",
    ["Min / Max"]                         = "最小值/最大值",
    ["Deficit"]                           = "损失血量",
    ["Percent"]                           = "百分比",
    ["None"]                              = "无",
    ["Current / Max"]                     = "当前血量/最大值",
    ["Current"]                           = "当前血量",
    ["Time left"]                         = "剩余时间",
    ["Enable shadow"]                     = "开启阴影",
    ["Shadow color"]                      = "阴影颜色",
    ["Shadow offset X"]                   = "阴影 X 偏移",
    ["Shadow offset Y"]                   = "阴影 Y 偏移",
    ["Show nameplate visibility status"]  = "提示当前姓名板显示状态",
    ["Hide health bar border"]            = "隐藏血条边框",
    ["Hide cast bar border"]              = "隐藏施法条边框",
    ["A UI reload is required to make the border show again."]          = "只有当你重载界面后才能再次显示边框",
    ["A UI reload is required to make the elite indicator show again."] = "只有当你重载界面后才能再次显示精英指示器",
    ["A UI reload is required to make the cast shield indicator show again."] = "只有当你重载界面后才能再次显示施法护盾",

    -- Health border color
    ["Health border color"]               = "血条边框颜色",

    -- Hide cast uninterruptible shield
    ["Hide cast uninterruptible shield"]  = "隐藏不可打断施法护盾",

    -- Debuffs
    ["Debuffs"]                           = "减益效果",
    ["Show debuffs"]                      = "显示减益效果",
    ["Show debuffs cast by you above the nameplate health bar."] = "在姓名板血条上方显示你施加的减益效果",
    ["Icon size"]                         = "图标大小",
    ["Size of each debuff icon in pixels."] = "每个减益图标的像素大小",
    ["Icon offset X"]                     = "图标 X 偏移",
    ["Horizontal offset of the debuff icons."] = "减益图标水平偏移",
    ["Icon offset Y"]                     = "图标 Y 偏移",
    ["Vertical offset of the debuff icons."]   = "减益图标垂直偏移",
}, {__index = Nameplates.L})
