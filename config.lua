local Nameplates = select(2, ...)

local Config = Nameplates:NewModule("Config")
local L = Nameplates.L
local SML, registered, options

function Config:OnInitialize()
    local config = LibStub("AceConfig-3.0")
    local dialog = LibStub("AceConfigDialog-3.0")
    SML = LibStub("LibSharedMedia-3.0")

    -- Register bundled statusbar textures
    SML:Register(SML.MediaType.STATUSBAR, "BantoBar",           "Interface\\Addons\\Nameplates\\images\\banto")
    SML:Register(SML.MediaType.STATUSBAR, "Smooth",             "Interface\\Addons\\Nameplates\\images\\smooth")
    SML:Register(SML.MediaType.STATUSBAR, "Perl",               "Interface\\Addons\\Nameplates\\images\\perl")
    SML:Register(SML.MediaType.STATUSBAR, "Glaze",              "Interface\\Addons\\Nameplates\\images\\glaze")
    SML:Register(SML.MediaType.STATUSBAR, "Charcoal",           "Interface\\Addons\\Nameplates\\images\\Charcoal")
    SML:Register(SML.MediaType.STATUSBAR, "Otravi",             "Interface\\Addons\\Nameplates\\images\\otravi")
    SML:Register(SML.MediaType.STATUSBAR, "Striped",            "Interface\\Addons\\Nameplates\\images\\striped")
    SML:Register(SML.MediaType.STATUSBAR, "LiteStep",           "Interface\\Addons\\Nameplates\\images\\LiteStep")
    SML:Register(SML.MediaType.STATUSBAR, "Nameplates Default", "Interface\\TargetingFrame\\UI-TargetingFrame-BarFill")

    Config._aceConfig = config
    Config._aceDialog = dialog
end

------------------------------------------------------------------------
-- Generic get/set for profile values
------------------------------------------------------------------------

local function set(info, value)
    local cat = info[1]
    if cat == "general" or cat == "nameplates" then
        Nameplates.db.profile[info[#info]] = value
    else
        Nameplates.db.profile[info.arg][info[#info]] = value
    end
    Nameplates:Reload()
end

local function get(info)
    local cat = info[1]
    if cat == "general" or cat == "nameplates" then
        return Nameplates.db.profile[info[#info]]
    end
    return Nameplates.db.profile[info.arg][info[#info]]
end

-- Color stored as a sub-table { r, g, b, a } inside a profile sub-table (e.g. shadowColor)
local function setColor(info, r, g, b, a)
    Nameplates.db.profile[info.arg][info[#info]] = { r = r, g = g, b = b, a = a }
    Nameplates:Reload()
end

local function getColor(info)
    local c = get(info)
    return c.r, c.g, c.b, c.a
end

-- Color stored directly on profile (e.g. healthBorderColor)
local function setTopColor(info, r, g, b, a)
    Nameplates.db.profile[info[#info]] = { r = r, g = g, b = b, a = a }
    Nameplates:Reload()
end

local function getTopColor(info)
    local c = Nameplates.db.profile[info[#info]]
    return c.r, c.g, c.b, c.a
end

-- Number range get/set for shadow offsets
local function setNumber(info, value)
    Nameplates.db.profile[info.arg][info[#info]] = value
    Nameplates:Reload()
end

-- Debuffs sub-table get/set
local function setDebuff(info, value)
    Nameplates.db.profile.debuffs[info[#info]] = value
    Nameplates:Reload()
end

local function getDebuff(info)
    return Nameplates.db.profile.debuffs[info[#info]]
end



------------------------------------------------------------------------
-- SML list helpers
------------------------------------------------------------------------

local textures = {}
function Config:GetTextures()
    for k in pairs(textures) do textures[k] = nil end
    for _, name in pairs(SML:List(SML.MediaType.STATUSBAR)) do
        textures[name] = name
    end
    return textures
end

local fonts = {}
function Config:GetFonts()
    for k in pairs(fonts) do fonts[k] = nil end
    for _, name in pairs(SML:List(SML.MediaType.FONT)) do
        fonts[name] = name
    end
    return fonts
end

local fontBorders = {
    [""]             = L["None"],
    ["OUTLINE"]      = L["Outline"],
    ["THICKOUTLINE"] = L["Thick outline"],
    ["MONOCHROME"]   = L["Monochrome"],
}

------------------------------------------------------------------------
-- Reusable font + shadow option block
------------------------------------------------------------------------

local function loadTextSettings(group, key)
    group.args.font = {
        order  = 1,
        type   = "group",
        inline = true,
        name   = L["Font"],
        args   = {
            name = {
                order         = 1,
                type          = "select",
                name          = L["Font name"],
                values        = "GetFonts",
                dialogControl = "LSM30_Font",
                arg           = key,
            },
            border = {
                order  = 2,
                type   = "select",
                name   = L["Font border"],
                values = fontBorders,
                arg    = key,
            },
            size = {
                order = 3,
                type  = "range",
                name  = L["Font size"],
                min   = 1, max = 20, step = 1,
                arg   = key,
            },
        },
    }

    group.args.shadow = {
        order  = 4,
        type   = "group",
        inline = true,
        name   = L["Shadow"],
        arg    = key,
        args   = {
            shadowEnabled = {
                order = 1,
                type  = "toggle",
                name  = L["Enable shadow"],
                arg   = key,
            },
            shadowColor = {
                order    = 2,
                type     = "color",
                name     = L["Shadow color"],
                hasAlpha = true,
                set      = setColor,
                get      = getColor,
                arg      = key,
            },
            x = {
                order = 3,
                type  = "range",
                name  = L["Shadow offset X"],
                min   = -2, max = 2, step = 1,
                set   = setNumber,
                arg   = key,
            },
            y = {
                order = 4,
                type  = "range",
                name  = L["Shadow offset Y"],
                min   = -2, max = 2, step = 1,
                set   = setNumber,
                arg   = key,
            },
        },
    }
end

------------------------------------------------------------------------
-- Build full options table
------------------------------------------------------------------------

local function loadOptions()
    options = {
        type = "group",
        name = "Nameplates",
        args = {

            -- General tab
            general = {
                type    = "group",
                order   = 1,
                name    = L["General"],
                get     = get,
                set     = set,
                handler = Config,
                args    = {
                    general = {
                        order  = 1,
                        type   = "group",
                        inline = true,
                        name   = L["General"],
                        args   = {
                            bindings = {
                                order = 1,
                                type  = "toggle",
                                name  = L["Show nameplate visibility status"],
                                width = "full",
                            },
                        },
                    },
                    nameplates = {
                        order  = 2,
                        type   = "group",
                        inline = true,
                        name   = L["Nameplates"],
                        args   = {
                            textureName = {
                                order         = 1,
                                type          = "select",
                                name          = L["Bar texture"],
                                dialogControl = "LSM30_Statusbar",
                                values        = "GetTextures",
                            },
                            healthBorderColor = {
                                order    = 2,
                                type     = "color",
                                name     = L["Health border color"],
                                hasAlpha = true,
                                set      = setTopColor,
                                get      = getTopColor,
                            },
                            hideHealth = {
                                order = 3,
                                type  = "toggle",
                                name  = L["Hide health bar border"],
                                desc  = L["A UI reload is required to make the border show again."],
                                width = "full",
                            },
                            hideCast = {
                                order = 4,
                                type  = "toggle",
                                name  = L["Hide cast bar border"],
                                desc  = L["A UI reload is required to make the border show again."],
                                width = "full",
                            },
                            hideElite = {
                                order = 5,
                                type  = "toggle",
                                name  = L["Hide elite indicator"],
                                desc  = L["A UI reload is required to make the elite indicator show again."],
                                width = "full",
                            },
                            hideUninterruptible = {
                                order = 6,
                                type  = "toggle",
                                name  = L["Hide cast uninterruptible shield"],
                                desc  = L["A UI reload is required to make the cast shield indicator show again."],
                                width = "full",
                            },
                        },
                    },
                },
            },

            -- Cast/Health text tab
            text = {
                order   = 2,
                type    = "group",
                name    = L["Cast/Health text"],
                get     = get,
                set     = set,
                handler = Config,
                args    = {
                    text = {
                        order  = 1,
                        type   = "group",
                        inline = true,
                        name   = L["Text"],
                        args   = {
                            healthType = {
                                order  = 1,
                                type   = "select",
                                name   = L["Health text display"],
                                desc   = L["Style of display for health bar text."],
                                values = { ["none"] = L["None"], ["minmax"] = L["Min / Max"], ["deff"] = L["Deficit"], ["percent"] = L["Percent"] },
                                arg    = "text",
                            },
                            castType = {
                                order  = 2,
                                type   = "select",
                                name   = L["Cast text display"],
                                desc   = L["Style of display for cast bar text."],
                                values = { ["crtmax"] = L["Current / Max"], ["none"] = L["None"], ["crt"] = L["Current"], ["percent"] = L["Percent"], ["timeleft"] = L["Time left"] },
                                arg    = "text",
                            },
                        },
                    },
                },
            },

            -- Name text tab
            name = {
                order   = 3,
                type    = "group",
                name    = L["Name text"],
                get     = get,
                set     = set,
                handler = Config,
                args    = {},
            },

            -- Level text tab
            level = {
                order   = 4,
                type    = "group",
                name    = L["Level text"],
                get     = get,
                set     = set,
                handler = Config,
                args    = {},
            },

            -- Debuffs tab
            debuffs = {
                order   = 5,
                type    = "group",
                name    = L["Debuffs"],
                get     = getDebuff,
                set     = setDebuff,
                handler = Config,
                args    = {
                    settings = {
                        order  = 1,
                        type   = "group",
                        inline = true,
                        name   = L["Debuffs"],
                        args   = {
                            enabled = {
                                order = 1,
                                type  = "toggle",
                                name  = L["Show debuffs"],
                                desc  = L["Show debuffs cast by you above the nameplate health bar."],
                                width = "full",
                            },
                            iconSize = {
                                order = 2,
                                type  = "range",
                                name  = L["Icon size"],
                                desc  = L["Size of each debuff icon in pixels."],
                                min   = 8, max = 32, step = 1,
                            },
                            offsetX = {
                                order = 3,
                                type  = "range",
                                name  = L["Icon offset X"],
                                desc  = L["Horizontal offset of the debuff icons."],
                                min   = -100, max = 100, step = 1,
                            },
                            offsetY = {
                                order = 4,
                                type  = "range",
                                name  = L["Icon offset Y"],
                                desc  = L["Vertical offset of the debuff icons."],
                                min   = -100, max = 100, step = 1,
                            },
                        },
                    },

                },
            },
        },
    }

    -- Inject font/shadow settings into the text tabs
    loadTextSettings(options.args.text,    "text")
    loadTextSettings(options.args.name,    "name")
    loadTextSettings(options.args.level,   "level")
    loadTextSettings(options.args.debuffs, "debuffs")

    -- AceDB profile tab
    options.args.profile       = LibStub("AceDBOptions-3.0"):GetOptionsTable(Nameplates.db)
    options.args.profile.order = 6
end

------------------------------------------------------------------------
-- Slash commands
------------------------------------------------------------------------

SLASH_NAMEPLATES1 = "/nameplates"
SLASH_NAMEPLATES2 = "/np"
SLASH_NAMEPLATES3 = "/nameplate"

SlashCmdList["NAMEPLATES"] = function(msg)
    if not registered then
        if not options then loadOptions() end
        Config._aceConfig:RegisterOptionsTable("Nameplates", options)
        Config._aceDialog:SetDefaultSize("Nameplates", 625, 500)
        registered = true
    end
    Config._aceDialog:Open("Nameplates")
end

------------------------------------------------------------------------
-- Blizzard Interface Options registration
------------------------------------------------------------------------

local blizFrame = CreateFrame("Frame", nil, InterfaceOptionsFrame)
blizFrame:SetScript("OnShow", function(self)
    self:SetScript("OnShow", nil)

    if not options then loadOptions() end

    local config = Config._aceConfig
    local dialog = Config._aceDialog

    config:RegisterOptionsTable("Nameplates-Bliz", {
        name = "Nameplates",
        type = "group",
        args = {
            help = {
                type = "description",
                name = string.format("Nameplates r%d is a basic nameplate modifier.", Nameplates.revision or 0),
            },
        },
    })
    dialog:SetDefaultSize("Nameplates-Bliz", 600, 400)
    dialog:AddToBlizOptions("Nameplates-Bliz", "Nameplates")

    config:RegisterOptionsTable("Nameplates-Profile", options.args.profile)
    dialog:AddToBlizOptions("Nameplates-Profile", options.args.profile.name, "Nameplates")

    config:RegisterOptionsTable("Nameplates-Text",    options.args.text)
    dialog:AddToBlizOptions("Nameplates-Text",    options.args.text.name,    "Nameplates")

    config:RegisterOptionsTable("Nameplates-Level",   options.args.level)
    dialog:AddToBlizOptions("Nameplates-Level",   options.args.level.name,   "Nameplates")

    config:RegisterOptionsTable("Nameplates-Name",    options.args.name)
    dialog:AddToBlizOptions("Nameplates-Name",    options.args.name.name,    "Nameplates")

    config:RegisterOptionsTable("Nameplates-General", options.args.general)
    dialog:AddToBlizOptions("Nameplates-General", options.args.general.name, "Nameplates")

    config:RegisterOptionsTable("Nameplates-Debuffs", options.args.debuffs)
    dialog:AddToBlizOptions("Nameplates-Debuffs", options.args.debuffs.name, "Nameplates")
end)
