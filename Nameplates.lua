--[[
    Nameplates, Shadow (Horde) from Mal'Ganis (US)
]]

local Nameplates = select(2, ...)

Nameplates = LibStub("AceAddon-3.0"):NewAddon(Nameplates, "Nameplates", "AceEvent-3.0", "AceHook-3.0")

local frames = {}
local SML

function Nameplates:OnInitialize()
    self.defaults = {
        profile = {
            textureName         = "Nameplates Default",
            bindings            = false,
            hideHealth          = false,
            hideCast            = false,
            hideElite           = false,
            hideUninterruptible = false,
            healthBorderColor   = { r = 1, g = 0.82, b = 0, a = 1 },
            debuffs = {
                enabled       = true,
                iconSize      = 16,
                offsetX       = 0,
                offsetY       = 2,
                name          = "Friz Quadrata TT",
                size          = 8,
                border        = "OUTLINE",
                shadowEnabled = false,
                shadowColor   = { r = 0, g = 0, b = 0, a = 1 },
                x             = 0,
                y             = 0,
            },
            name  = { name = "Friz Quadrata TT", size = 12, border = "",        shadowEnabled = false, shadowColor = { r = 0, g = 0, b = 0, a = 1 }, x = 0, y = 0 },
            level = { name = "Friz Quadrata TT", size = 11, border = "",        shadowEnabled = false, shadowColor = { r = 0, g = 0, b = 0, a = 1 }, x = 0, y = 0 },
            text  = { name = "Friz Quadrata TT", size = 8,  border = "OUTLINE", shadowEnabled = false, shadowColor = { r = 0, g = 0, b = 0, a = 1 }, x = 0, y = 0, healthType = "percent", castType = "crtmax" },
        },
    }

    self.db       = LibStub("AceDB-3.0"):New("NameplatesDB", self.defaults)
    self.revision = tonumber(string.match("$Revision$", "(%d+)") or 1)

    SML = LibStub("LibSharedMedia-3.0")
end

function Nameplates:SetupFontString(text, type)
    if not text.SetFont then return end

    local config = self.db.profile[type]
    text:SetFont(SML:Fetch(SML.MediaType.FONT, config.name), config.size, config.border)

    if config.shadowEnabled then
        if not text.NPOriginalShadow then
            local x, y = text:GetShadowOffset()
            local r, g, b, a = text:GetShadowColor()
            text.NPOriginalShadow = { r = r, g = g, b = b, a = a, x = x, y = y }
        end
        text:SetShadowColor(config.shadowColor.r, config.shadowColor.g, config.shadowColor.b, config.shadowColor.a)
        text:SetShadowOffset(config.x, config.y)
    elseif text.NPOriginalShadow then
        local s = text.NPOriginalShadow
        text:SetShadowColor(s.r, s.g, s.b, s.a)
        text:SetShadowOffset(s.x, s.y)
        text.NPOriginalShadow = nil
    end
end

function Nameplates:SetupHiding(texture, type)
    if not self.db.profile[type] then return end

    texture:Hide()
    if type == "hideUninterruptible" then
        texture:SetHeight(0.5)
        texture:SetWidth(0.5)
        texture:SetTexture("")
    end
end

-- REGIONS (from frame:GetParent():GetRegions())
-- 1 = Threat glow (mob aggro state)
-- 2 = Health bar/level border
-- 3 = Cast bar border
-- 4 = Cast bar uninterruptible shield
-- 5 = Spell icon for cast bar
-- 6 = Highlight texture (hover glow)
-- 7 = Name text
-- 8 = Level text
-- 9 = Skull icon (mob 10+ levels above you)
-- 10 = Raid icon
-- 11 = Elite icon

function Nameplates:OnShow(frame)
    local _, healthBorder, castBorder, castUninterruptible, _, _, nameText, levelText, _, _, mobIcon = frame:GetParent():GetRegions()

    -- Health/cast bar texture
    -- NOTE: SetStatusBarTexture() can reset the bar's rendered fill to 0
    -- on this client until SetValue() is called again. Since OnShow only
    -- fires once per show transition (not on every value tick), skipping
    -- this would leave the bar looking blank the first time it appears
    -- (most noticeable on the first cast on a freshly shown cast bar).
    -- We preserve and immediately reapply the current value to avoid that.
    local currentValue = frame:GetValue()
    frame:SetStatusBarTexture(SML:Fetch(SML.MediaType.STATUSBAR, self.db.profile.textureName))
    frame:SetValue(currentValue)

    -- Font strings
    self:SetupFontString(frame.NPText, "text")
    self:SetupFontString(nameText, "name")
    self:SetupFontString(levelText, "level")

    -- Hide optional elements
    self:SetupHiding(healthBorder, "hideHealth")
    self:SetupHiding(castBorder, "hideCast")
    self:SetupHiding(mobIcon, "hideElite")
    self:SetupHiding(castUninterruptible, "hideUninterruptible")

    -- Health border color (only if not hidden)
    if not self.db.profile.hideHealth then
        local c = self.db.profile.healthBorderColor
        healthBorder:SetVertexColor(c.r, c.g, c.b, c.a)
    end
end

function Nameplates:HealthOnValueChanged(frame, value)
    local maxValue   = select(2, frame:GetMinMaxValues())
    local healthType = self.db.profile.text.healthType

    if healthType == "minmax" then
        frame.NPText:SetFormattedText("%d / %d", value, maxValue)
    elseif healthType == "deff" then
        local deficit = maxValue - value
        if deficit > 0 then
            frame.NPText:SetFormattedText("-%d", deficit)
        else
            frame.NPText:SetText("")
        end
    elseif healthType == "percent" then
        frame.NPText:SetFormattedText("%d%%", value / maxValue * 100)
    else
        frame.NPText:SetText("")
    end
end

function Nameplates:CastOnValueChanged(frame, value)
    local minValue, maxValue = frame:GetMinMaxValues()

    if value >= maxValue or value == 0 then
        frame.NPText:SetText("")
        return
    end

    local elapsed   = math.floor(((value - minValue) * 100) + 0.5) / 100
    local remaining = maxValue - value + (value - minValue)
    local castType  = self.db.profile.text.castType

    if castType == "crtmax" then
        frame.NPText:SetFormattedText("%.2f / %.2f", elapsed, remaining)
    elseif castType == "crt" then
        frame.NPText:SetFormattedText("%.2f", elapsed)
    elseif castType == "percent" then
        frame.NPText:SetFormattedText("%d%%", elapsed / remaining)
    elseif castType == "timeleft" then
        frame.NPText:SetFormattedText("%.2f", remaining - elapsed)
    else
        frame.NPText:SetText("")
    end
end

function Nameplates:CreateText(frame)
    local cfg = self.db.profile.text
    frame.NPText = frame:CreateFontString(nil, "ARTWORK")
    frame.NPText:SetFont(SML:Fetch(SML.MediaType.FONT, cfg.name), cfg.size, cfg.border)
    frame.NPText:SetPoint("CENTER", frame, "CENTER", 5, 0)
end

local function hookFrames(...)
    local self    = Nameplates
    local Debuffs = Nameplates:GetModule("Debuffs")

    for i = 1, select("#", ...) do
        local frame  = select(i, ...)
        local region = frame:GetRegions()

        if not frames[frame]
        and not frame:GetName()
        and region
        and region:GetObjectType() == "Texture"
        and region:GetTexture() == "Interface\\TargetingFrame\\UI-TargetingFrame-Flash"
        then
            frames[frame] = true

            local health, cast = frame:GetChildren()

            self:CreateText(health)
            self:HookScript(health, "OnValueChanged", "HealthOnValueChanged")
            self:HookScript(health, "OnShow", "OnShow")
            self:HealthOnValueChanged(health, health:GetValue())
            self:OnShow(health)

            self:CreateText(cast)
            self:HookScript(cast, "OnValueChanged", "CastOnValueChanged")
            self:HookScript(cast, "OnShow", "OnShow")
            self:CastOnValueChanged(cast, cast:GetValue())
            self:OnShow(cast)

            -- Register with debuffs module
            Debuffs:RegisterNameplate(frame, health)
        end
    end
end

local numChildren = -1
local scanFrame   = CreateFrame("Frame")
scanFrame:SetScript("OnUpdate", function(self, elapsed)
    if WorldFrame:GetNumChildren() ~= numChildren then
        numChildren = WorldFrame:GetNumChildren()
        hookFrames(WorldFrame:GetChildren())
    end
end)

function Nameplates:Reload()
    local Debuffs = self:GetModule("Debuffs")

    for frame in pairs(frames) do
        local health, cast = frame:GetChildren()
        self:OnShow(health)
        self:HealthOnValueChanged(health, health:GetValue())
        self:OnShow(cast)
        self:CastOnValueChanged(cast, cast:GetValue())
    end

    -- Let the debuffs module re-create icons at the (possibly new) size
    Debuffs:ReloadAll(frames)
end

function Nameplates:Print(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99Nameplates|r: " .. msg)
end
