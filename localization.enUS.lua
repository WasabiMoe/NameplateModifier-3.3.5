local Nameplates = select(2, ...)
local L = LibStub("AceLocale-3.0"):NewLocale("Nameplates", "enUS", true)
if not L then return end

Nameplates.L = LibStub("AceLocale-3.0"):GetLocale("Nameplates")

-- Status messages (used by bindings.lua)
L["Enemy player/npc name plates are now visible."]    = true
L["Enemy player/npc name plates are now hidden."]     = true
L["Friendly player/npc name plates are now visible."] = true
L["Friendly player/npc name plates are now hidden."]  = true
L["All name plates are now visible."]                 = true
L["All name plates are now hidden."]                  = true

L["General"]                          = true
L["Show nameplate visibility status"] = true
L["Nameplates"]                       = true
L["Bar texture"]                      = true
L["Health border color"]              = true
L["Hide health bar border"]           = true
L["A UI reload is required to make the border show again."]           = true
L["Hide cast bar border"]             = true
L["Hide elite indicator"]             = true
L["A UI reload is required to make the elite indicator show again."]  = true
L["Hide cast uninterruptible shield"] = true
L["A UI reload is required to make the cast shield indicator show again."] = true
L["Cast/Health text"]                 = true
L["Text"]                             = true
L["Health text display"]              = true
L["Style of display for health bar text."] = true
L["None"]                             = true
L["Min / Max"]                        = true
L["Deficit"]                          = true
L["Percent"]                          = true
L["Cast text display"]                = true
L["Style of display for cast bar text."] = true
L["Current / Max"]                    = true
L["Current"]                          = true
L["Time left"]                        = true
L["Name text"]                        = true
L["Level text"]                       = true
L["Font"]                             = true
L["Font name"]                        = true
L["Font border"]                      = true
L["Font size"]                        = true
L["Shadow"]                           = true
L["Enable shadow"]                    = true
L["Shadow color"]                     = true
L["Shadow offset X"]                  = true
L["Shadow offset Y"]                  = true
L["Outline"]                          = true
L["Thick outline"]                    = true
L["Monochrome"]                       = true
-- Debuffs
L["Debuffs"]                          = true
L["Show debuffs"]                     = true
L["Show debuffs cast by you above the nameplate health bar."] = true
L["Icon size"]                        = true
L["Size of each debuff icon in pixels."] = true
L["Icon offset X"]                    = true
L["Horizontal offset of the debuff icons."] = true
L["Icon offset Y"]                    = true
L["Vertical offset of the debuff icons."] = true
