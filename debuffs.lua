--[[
    Debuffs module for Nameplates
    Shows debuffs cast by the player above each nameplate health bar.

    Approach (based on how PlateBuffs-3.3.5 works):
      - No combat log. Instead we listen to UNIT_AURA, PLAYER_TARGET_CHANGED,
        UPDATE_MOUSEOVER_UNIT and UNIT_TARGET.
      - On each event we call UnitDebuff() directly on the unit token and cache
        results by unit name (since we have no reliable GUID in 3.3.5a).
      - The nameplate OnUpdate ticker matches cached debuffs to plates by name.
]]

local Nameplates = select(2, ...)
local Debuffs    = Nameplates:NewModule("Debuffs", "AceEvent-3.0")

local MAX_ICONS  = 8
local SCAN_RATE  = 0.1   -- seconds between full nameplate scans

-- name -> { [spellName] = { icon, duration, expirationTime, count } }
local auraCache  = {}

-- nameplateParentFrame -> { icon1, icon2, ... }
local iconPools  = {}

local SML  -- set in OnEnable

local function applyTimerFont(timer)
    if not SML then return end
    local cfg = Nameplates.db.profile.debuffs.text
    timer:SetFont(SML:Fetch(SML.MediaType.FONT, cfg.name), cfg.size, cfg.border)

    if cfg.shadowEnabled then
        timer:SetShadowColor(cfg.shadowColor.r, cfg.shadowColor.g, cfg.shadowColor.b, cfg.shadowColor.a)
        timer:SetShadowOffset(cfg.x, cfg.y)
    else
        timer:SetShadowColor(0, 0, 0, 0)
        timer:SetShadowOffset(0, 0)
    end
end

------------------------------------------------------------------------
-- Aura collection from a live unit token
------------------------------------------------------------------------

local function collectDebuffs(unit)
    if not UnitExists(unit) then return end
    local name = UnitName(unit)
    if not name then return end

    -- Wipe existing entries for this name so removed debuffs disappear
    auraCache[name] = {}

    local i = 1
    while true do
        local spellName, _, icon, count, _, duration, expirationTime, caster = UnitDebuff(unit, i)
        if not spellName then break end
        -- Only store debuffs cast by the player
        if caster and UnitIsUnit(caster, "player") then
            auraCache[name][spellName] = {
                icon           = icon,
                duration       = duration or 0,
                expirationTime = expirationTime or 0,
                count          = count or 0,
            }
        end
        i = i + 1
    end

    -- If nothing left, clear the entry entirely
    if not next(auraCache[name]) then
        auraCache[name] = nil
    end
end

------------------------------------------------------------------------
-- Event handlers
------------------------------------------------------------------------

function Debuffs:OnEnable()
    SML = LibStub("LibSharedMedia-3.0")
    self:RegisterEvent("PLAYER_TARGET_CHANGED", "OnTargetChanged")
    self:RegisterEvent("UPDATE_MOUSEOVER_UNIT", "OnMouseover")
    self:RegisterEvent("UNIT_AURA",             "OnUnitAura")
    self:RegisterEvent("UNIT_TARGET",           "OnUnitTarget")
end

local function setupTimerFont(icon)
    local cfg = Nameplates.db.profile.debuffs
    icon.timer:SetFont(SML:Fetch(SML.MediaType.FONT, cfg.name), cfg.size, cfg.border)

    if cfg.shadowEnabled then
        icon.timer:SetShadowColor(cfg.shadowColor.r, cfg.shadowColor.g, cfg.shadowColor.b, cfg.shadowColor.a)
        icon.timer:SetShadowOffset(cfg.x, cfg.y)
    else
        icon.timer:SetShadowColor(0, 0, 0, 0)
        icon.timer:SetShadowOffset(0, 0)
    end
end

function Debuffs:OnTargetChanged()
    collectDebuffs("target")
end

function Debuffs:OnMouseover()
    collectDebuffs("mouseover")
end

function Debuffs:OnUnitAura(event, unitID)
    -- "target" and "mouseover" are the only tokens we can call UnitDebuff on
    -- without nameplate unit tokens. Collect both whenever any unit aura changes.
    collectDebuffs("target")
    collectDebuffs("mouseover")
end

function Debuffs:OnUnitTarget(event, unitID)
    if unitID and UnitExists(unitID .. "target") then
        collectDebuffs(unitID .. "target")
    end
end

------------------------------------------------------------------------
-- Icon frame creation
------------------------------------------------------------------------

local function createIcon(parent, size)
    local f = CreateFrame("Frame", nil, parent)
    f:SetWidth(size)
    f:SetHeight(size)

    -- Border: 1px solid dark outline via a slightly inset icon texture
    local border = f:CreateTexture(nil, "BACKGROUND")
    border:SetAllPoints(f)
    border:SetTexture(0, 0, 0, 1)  -- solid black fill as border base

    f.texture = f:CreateTexture(nil, "ARTWORK")
    f.texture:SetPoint("TOPLEFT",     f, "TOPLEFT",      1,  -1)
    f.texture:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -1,   1)
    f.texture:SetTexCoord(0.07, 0.93, 0.07, 0.93)

    f.timer = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    f.timer:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 1, -1)
    f.timer:SetJustifyH("RIGHT")

    f:Hide()
    return f
end

local function getIcon(pool, index, parent, size)
    if not pool[index] then
        pool[index] = createIcon(parent, size)
    end
    -- Reapply font settings every time in case they changed via config
    setupTimerFont(pool[index])
    return pool[index]
end

------------------------------------------------------------------------
-- Layout
------------------------------------------------------------------------

local function layoutIcons(pool, count, healthFrame, size, offsetX, offsetY)
    local spacing  = 2
    local totalW   = count * size + (count - 1) * spacing
    local startX   = -(totalW / 2) + (size / 2) + offsetX
    local plate    = healthFrame:GetParent()

    for i = 1, count do
        local icon = pool[i]
        icon:SetWidth(size)
        icon:SetHeight(size)
        icon:ClearAllPoints()
        icon:SetPoint("BOTTOM", plate, "TOP", startX + (i - 1) * (size + spacing), offsetY)
        icon:Show()
    end

    for i = count + 1, #pool do
        pool[i]:Hide()
    end
end

------------------------------------------------------------------------
-- Timer text
------------------------------------------------------------------------

local function formatTime(t)
    if t >= 60 then
        return string.format("%dm", math.ceil(t / 60))
    elseif t >= 10 then
        return string.format("%d", math.ceil(t))
    else
        return string.format("%.1f", t)
    end
end

------------------------------------------------------------------------
-- Per-nameplate update
------------------------------------------------------------------------

local function getNameFromPlate(frame)
    local _, _, _, _, _, _, nameText = frame:GetRegions()
    return nameText and nameText.GetText and nameText:GetText()
end

local function updateNameplate(frame, healthFrame)
    local cfg  = Nameplates.db.profile.debuffs
    local pool = iconPools[frame]

    if not cfg.enabled then
        for _, icon in ipairs(pool) do icon:Hide() end
        return
    end

    local plateName = getNameFromPlate(frame)
    local cache     = plateName and auraCache[plateName]

    -- If cache is empty, try collecting right now if this plate matches target or mouseover
    if not cache and plateName then
        for _, unit in ipairs({ "target", "mouseover" }) do
            if UnitExists(unit) and UnitName(unit) == plateName then
                collectDebuffs(unit)
                cache = auraCache[plateName]
                break
            end
        end
    end

    if not cache then
        for _, icon in ipairs(pool) do icon:Hide() end
        return
    end

    local size  = cfg.iconSize
    local now   = GetTime()
    local count = 0

    for spellName, entry in pairs(cache) do
        count = count + 1
        if count <= MAX_ICONS then
            local icon = getIcon(pool, count, healthFrame:GetParent(), size)
            icon.texture:SetTexture(entry.icon)
            icon.expirationTime = entry.expirationTime
            icon.duration       = entry.duration

            if entry.duration > 0 and entry.expirationTime > 0 then
                local remaining = entry.expirationTime - now
                icon.timer:SetText(remaining > 0 and formatTime(remaining) or "")
            else
                icon.timer:SetText("")
            end
        end
    end

    count = math.min(count, MAX_ICONS)
    if count > 0 then
        layoutIcons(pool, count, healthFrame, size, cfg.offsetX, cfg.offsetY)
    else
        for _, icon in ipairs(pool) do icon:Hide() end
    end
end

------------------------------------------------------------------------
-- OnUpdate ticker — scans all visible nameplates and refreshes timers
------------------------------------------------------------------------

local elapsed_accum = 0
local ticker = CreateFrame("Frame")
ticker:SetScript("OnUpdate", function(self, elapsed)
    elapsed_accum = elapsed_accum + elapsed
    if elapsed_accum < SCAN_RATE then
        -- Refresh timer text every frame (cheap)
        local now = GetTime()
        for frame, pool in pairs(iconPools) do
            for _, icon in ipairs(pool) do
                if icon:IsShown() and icon.duration and icon.duration > 0 then
                    local remaining = icon.expirationTime - now
                    icon.timer:SetText(remaining > 0 and formatTime(remaining) or "")
                end
            end
        end
        return
    end
    elapsed_accum = 0

    -- Always keep target and mouseover cache fresh so icons appear without waiting for events
    collectDebuffs("target")
    collectDebuffs("mouseover")

    for frame, pool in pairs(iconPools) do
        if frame:IsShown() then
            local health = select(1, frame:GetChildren())
            if health then
                updateNameplate(frame, health)
            end
        else
            for _, icon in ipairs(pool) do icon:Hide() end
        end
    end
end)

------------------------------------------------------------------------
-- Public API
------------------------------------------------------------------------

function Debuffs:RegisterNameplate(nameplateFrame, healthFrame)
    if not iconPools[nameplateFrame] then
        iconPools[nameplateFrame] = {}
    end
    updateNameplate(nameplateFrame, healthFrame)
end

function Debuffs:UnregisterNameplate(nameplateFrame)
    local pool = iconPools[nameplateFrame]
    if pool then
        for _, icon in ipairs(pool) do icon:Hide() end
    end
    iconPools[nameplateFrame] = nil
end

function Debuffs:ReloadAll(frames)
    for nameplateFrame, pool in pairs(iconPools) do
        for _, icon in ipairs(pool) do
            icon:Hide()
            icon:SetParent(nil)
        end
        iconPools[nameplateFrame] = nil
    end

    for nameplateFrame in pairs(frames) do
        if nameplateFrame:IsShown() then
            local health = select(1, nameplateFrame:GetChildren())
            if health then
                self:RegisterNameplate(nameplateFrame, health)
            end
        end
    end
end
