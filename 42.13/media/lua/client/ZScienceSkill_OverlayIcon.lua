-- Draw icon overlays for science-related items:
-- Gray tick: unread science books / unresearched specimens (Science XP available)
-- Green tick: researched specimens
require "ZScienceSkill_Data"

local grayTickTexture = getTexture("media/ui/S_Mark_Gray.png")
local greenTickTexture = getTexture("media/ui/Tick_Mark-10.png")

local function isSpecimenResearched(player, fullType)
    local modData = player:getModData().researchedSpecimens
    return modData and modData[fullType]
end

local originalRenderDetails = ISInventoryPane.renderdetails

function ISInventoryPane:renderdetails(doDragged)
    originalRenderDetails(self, doDragged)

    if not doDragged then return end

    local player = getSpecificPlayer(self.player)
    if not player then return end

    local YSCROLL = self:getYScroll()
    local HEIGHT = self:getHeight()

    local y = 0
    for _, v in ipairs(self.items) do
        local item = v.items and v.items[1] or v
        if item and type(item.getFullType) == "function" then
            local fullType = item:getFullType()
            local texture = nil
            
            -- Science literature: gray tick if unread
            if ZScienceSkill.literature[fullType] then
                if not self:isLiteratureRead(player, item) then
                    texture = grayTickTexture
                end
            -- Specimens: gray tick if unresearched, green tick if researched
            elseif ZScienceSkill.specimens[fullType] then
                if isSpecimenResearched(player, fullType) then
                    texture = greenTickTexture
                else
                    texture = grayTickTexture
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
