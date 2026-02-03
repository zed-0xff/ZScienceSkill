-- Draw icon overlays for science-related items:
-- Gray "R": unread science books / unresearched specimens (Science XP available)
-- Green tick: researched specimens (optional)
require "ZScienceSkill_Data"
require "mods.ZScienceSkill.42.13.media.lua.client.ZScienceSkill_ModOptions"

local grayTickTexture = getTexture("media/ui/R_Mark_Gray.png")
local greenTickTexture = getTexture("media/ui/Tick_Mark-10.png")

local function isSpecimenResearched(player, fullType)
    local modData = player:getModData().researchedSpecimens
    return modData and modData[fullType]
end

local function getFluidType(item)
    local fc = item:getFluidContainer()
    if fc and fc:getPrimaryFluid() then
        return fc:getPrimaryFluid():getFluidTypeString()
    end
    return nil
end

local function isFluidResearched(player, fluidType)
    local modData = player:getModData().researchedSpecimens
    return modData and modData["Fluid:" .. fluidType]
end

local originalRenderDetails = ISInventoryPane.renderdetails

function ISInventoryPane:renderdetails(doDragged)
    originalRenderDetails(self, doDragged)

    if not doDragged then return end

    local player = getSpecificPlayer(self.player)
    if not player then return end

    local showOverlay = ZScienceSkillOptions.isOverlayEnabled()
    local showCheckmark = ZScienceSkillOptions.isResearchedCheckmarkEnabled()
    
    if not showOverlay and not showCheckmark then return end

    local YSCROLL = self:getYScroll()
    local HEIGHT = self:getHeight()

    local y = 0
    for _, v in ipairs(self.items) do
        local item = v.items and v.items[1] or v
        if item and type(item.getFullType) == "function" then
            local fullType = item:getFullType()
            local texture = nil
            
            -- Science literature: gray "R" if unread
            if ZScienceSkill.literature[fullType] then
                if not self:isLiteratureRead(player, item) and showOverlay then
                    texture = grayTickTexture
                end
            -- Specimens: gray "R" if unresearched, green tick if researched
            elseif ZScienceSkill.specimens[fullType] then
                if isSpecimenResearched(player, fullType) then
                    if showCheckmark then
                        texture = greenTickTexture
                    end
                elseif showOverlay then
                    texture = grayTickTexture
                end
            else
                -- Fluids: check if container has researchable fluid
                local fluidType = getFluidType(item)
                if fluidType and ZScienceSkill.fluids and ZScienceSkill.fluids[fluidType] then
                    if isFluidResearched(player, fluidType) then
                        if showCheckmark then
                            texture = greenTickTexture
                        end
                    elseif showOverlay then
                        texture = grayTickTexture
                    end
                end
            end
            
            if texture then
                local topOfItem = y * self.itemHgt + YSCROLL
                if topOfItem + self.itemHgt >= 0 and topOfItem <= HEIGHT then
                    local xoff = 0
                    local yoff = 0
                    local texWH = math.min(self.itemHgt - 2, 32)
                    local auxDXY = self.itemHgt - (self.itemHgt - texWH) / 2 - 13
                    local texOffsetY = (y * self.itemHgt) + (self.itemHgt - texWH) / 2 + self.headerHgt + yoff
                    local texOffsetX = self.column2 - texWH - (self.itemHgt - texWH) / 2 + xoff

                    self:drawTexture(texture, texOffsetX + auxDXY, texOffsetY + auxDXY - 1, 1, 1, 1, 1)
                end
            end
        end
        y = y + 1
    end
end
