ZScienceSkill = ZScienceSkill or {}

function ZScienceSkill.isCombatPerk(perk)
    local perkObj = PerkFactory.getPerk(perk)
    if not perkObj then return false end
    
    local parent = perkObj:getParent()
    return parent == Perks.Combat or parent == Perks.Firearm
          or perk == Perks.Combat or   perk == Perks.Firearm
end

-- Get fluid type string from item if it has a fluid container
function ZScienceSkill.getFluidType(item)
    if not item or not item.getFluidContainer then return end

    local fc = item:getFluidContainer()
    if fc and fc:getPrimaryFluid() then
        return fc:getPrimaryFluid():getFluidTypeString()
    end
    return nil
end

-- Get the research key for a specimen (uses 'key' field if present, otherwise fullType)
function ZScienceSkill.getSpecimenResearchKey(fullType)
    if not fullType then return end

    local config = ZScienceSkill.Data.specimens[fullType]
    if type(config) == "table" and config.key then
        return config.key
    end
    return fullType
end

-- returns nil only if any of the input params is nil, otherwise returns strict boolean
local function isSpecimenResearched(player, fullType)
    if not player or not fullType then return end

    local modData = player:getModData().researchedSpecimens
    if not modData then return false end

    local researchKey = ZScienceSkill.getSpecimenResearchKey(fullType)
    return modData[researchKey] or false
end

-- returns nil only if any of the input params is nil, otherwise returns strict boolean
local function isFluidResearched(player, fluidType)
    if not player or not fluidType then return end

    local modData = player:getModData().researchedSpecimens
    return modData and modData["Fluid:" .. fluidType] or false
end

local function isLiteratureReadOnce(player, fullType)
    return isSpecimenResearched(player, fullType)
end

function ZScienceSkill.getItemFullType(item)
    if not item then return end
    if item.getFullType then return item:getFullType() end
    if item.getScriptObjectFullType then return item:getScriptObjectFullType() end
    return nil
end

-- mostly a copy of ISInventoryPane:isLiteratureRead, but adapted for both client and server use
-- startPage is optional
-- returns true/false/nil
function ZScienceSkill.isLiteratureRead(playerObj, item, startPage)
    if not playerObj then return end

    if not item then return end
    if not item:IsLiterature() then return end

    -- next is a copy of ISInventoryPane:isLiteratureRead(playerObj, item)
    local modData = item:hasModData() and item:getModData() or nil
    if modData ~= nil then
        if (modData.literatureTitle)      and playerObj:isLiteratureRead(modData.literatureTitle)         then return true end
        if (modData.printMedia ~= nil)    and playerObj:isPrintMediaRead(modData.printMedia.title)        then return true end
        if (modData.learnedRecipe ~= nil) and playerObj:getKnownRecipes():contains(modData.learnedRecipe) then return true end
    end

    local skillBook = SkillBook[item:getSkillTrained()]
    if (skillBook ~= nil) and (item:getMaxLevelTrained() < playerObj:getPerkLevel(skillBook.perk) + 1) then return true end
    if item:getNumberOfPages() > 0 then
        local fullType = ZScienceSkill.getItemFullType(item)
        local startPage = startPage or playerObj:getAlreadyReadPages(fullType) or 0 -- take startPage into account
        if startPage == item:getNumberOfPages() then return true end
    end
    if (item:getLearnedRecipes() ~= nil) and playerObj:getKnownRecipes():containsAll(item:getLearnedRecipes()) then return true end

    return false
end

-- SSOT
-- player is optional
function ZScienceSkill.getItemStatus(item, player)
    local fullType = ZScienceSkill.getItemFullType(item)
    if not fullType then return end
    
    local data = {}
    if ZScienceSkill.Data.literature[fullType] then
        table.insert(data, { type = "literature", researched = ZScienceSkill.isLiteratureRead(player, item) })
    end
    if ZScienceSkill.Data.literatureReadOnce[fullType] then
        table.insert(data, { type = "literatureReadOnce", researched = isLiteratureReadOnce(player, fullType) })
    end
    if ZScienceSkill.Data.specimens[fullType]then
        table.insert(data, { type = "specimen", researched = isSpecimenResearched(player, fullType) })
    end
                    
    local fluidType = ZScienceSkill.getFluidType(item)
    if fluidType and ZScienceSkill.Data.fluids[fluidType] then
        table.insert(data, { type = "fluid", researched = isFluidResearched(player, fluidType) })
    end

    if #data == 0 then return nil end

    local result = {
        total = #data,
        data = data,
    }

    if player then
        result.researched = 0
        for _, entry in ipairs(data) do
            if entry.researched then
                result.researched = result.researched + 1
            end
        end
    end

    return result
end


-- add XP to Science perk based on ZScienceSkill.Data tables
function ZScienceSkill.addXpFromTable(character, tbl, key, item)
    if type(tbl) ~= "table" then
        print("[?] ZScienceSkill: table expected for XP data, got type=" .. type(tbl) .. ", tbl=" .. tostring(tbl) .. ", key=" .. tostring(key))
        return false
    end

    local val = tbl[key]
    if not val then
        print("[?] ZScienceSkill: no XP data for key=" .. tostring(key))
        return false
    end

    local mult = 1.0
    if item and ZItemTiers and ZItemTiers.GetItemTierIndex0 then
        local tierIdx0 = ZItemTiers.GetItemTierIndex0(item)
        if type(tierIdx0) == "number" then
            mult = mult + 0.1 * tierIdx0 -- add 10% XP per tier, so tier 0 = no bonus, tier 1 = +10%, tier 2 = +20%, etc.
        end
    end

    if type(val) == "number" then
        addXp(character, Perks.Science, val * mult)
        return true
    end
    if type(val) == "table" then
        for perk, xp in pairs(val) do -- 'perk' can be either string (perk name) or the Perk object itself
            if perk ~= "key" then  -- skip the 'key' field, it's not a perk
                if type(perk) == "string" then
                    perk = Perks[perk]
                end
                if perk and type(xp) == "number" then
                    addXp(character, perk, xp * mult)
                end
            end
        end
        return true
    end

    print("[?] ZScienceSkill: invalid XP data for specimen: type=" .. type(val) .. ", value=" .. tostring(val) .. ", key=" .. tostring(key))
    return false
end
