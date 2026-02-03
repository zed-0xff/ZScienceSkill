-- Add "Researchable" / "Already Researched" text to item tooltips
require "ISUI/ISToolTipInv"
require "ZScienceSkill_Data"
require "ZScienceSkill_ModOptions"

local originalRender = ISToolTipInv.render

function ISToolTipInv:render()
    originalRender(self)
    
    -- Check if tooltip option is enabled
    if not ZScienceSkillOptions.isTooltipEnabled() then return end
    
    -- Check if item is researchable
    if not self.item then return end
    local fullType = self.item:getFullType()
    
    local isResearchable = ZScienceSkill.specimens[fullType] or ZScienceSkill.literature[fullType]
    if not isResearchable then return end
    
    -- Check if already researched/read
    local player = getSpecificPlayer(0)
    if not player then return end
    
    local alreadyDone = false
    if ZScienceSkill.literature[fullType] then
        alreadyDone = player:isLiteratureRead(fullType)
    elseif ZScienceSkill.specimens[fullType] then
        local modData = player:getModData().researchedSpecimens
        alreadyDone = modData and modData[fullType]
    end
    
    -- Choose text and color
    local text, r, g, b
    if alreadyDone then
        text = getText("IGUI_AlreadyResearched") or "Already Researched"
        r, g, b = 0.5, 0.7, 0.5  -- Muted green
    else
        text = getText("IGUI_Researchable") or "Researchable"
        r, g, b = 0.6, 0.8, 1.0  -- Light blue
    end
    
    -- Draw text above the tooltip
    local textW = getTextManager():MeasureStringX(UIFont.Small, text)
    local textH = getTextManager():MeasureStringY(UIFont.Small, text)
    local x = self.tooltip:getX() + self.tooltip:getWidth() / 2 - textW / 2
    local y = self.tooltip:getY() - textH - 2
    
    self:drawText(text, x - self:getX(), y - self:getY(), r, g, b, 1.0, UIFont.Small)
end
