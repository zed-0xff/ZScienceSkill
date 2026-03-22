-- stop copying on first match
local COPY_DISTR = {
    ["MyComputer.FloppyDiskElectricalPublisher"]   = "ZScienceSkill.FloppyDiskSciencePublisher",
    ["SupportCorps.FloppyDiskElectricalPublisher"] = "ZScienceSkill.FloppyDiskSciencePublisher",
}

local logger = ZBLogger.new("ZScienceSkill")

local function copyDistr(rootTbl, srcKey, dstKey)
    if type(rootTbl) ~= "table" then
        logger:warn("copyDistr(rootTbl, '%s', '%s'): expected a table but got %s", srcKey, dstKey, type(rootTbl))
        return 0
    end
    if not getItem(srcKey) then
        logger:warn("copyDistr(rootTbl, '%s', '%s'): source item '%s' not found", srcKey, dstKey, srcKey)
        return 0
    end
    if not getItem(dstKey) then
        logger:warn("copyDistr(rootTbl, '%s', '%s'): destination item '%s' not found", srcKey, dstKey, dstKey)
        return 0
    end

    local nAdded = 0
    for tableName, dist in pairs(rootTbl) do
        if type(dist) == "table" and dist.items then
            for i = 1, #dist.items, 2 do
                if dist.items[i] == srcKey then
                    -- assuming table structure is consistent and contains pairs of key and weight, so the weight is always at index i + 1
                    local weight = dist.items[i + 1]

                    -- logger:debug("adding %s to distribution %s with weight %d", dstKey, tableName, weight)
                    table.insert(dist.items, dstKey)
                    table.insert(dist.items, weight)
                    nAdded = nAdded + 1
                    break -- intended break of inner loop only
                end
            end
        end
    end
    logger:info("added %d entries for '%s'", nAdded, dstKey)

    -- return value is unused for now, but may be useful for testing or logging in the future
    return nAdded
end

local function updateDistributions()
    local t0 = os.time()
    if ProceduralDistributions then
        for src, dst in pairs(COPY_DISTR) do
            if copyDistr(ProceduralDistributions.list, src, dst) > 0 then
                break -- stop copying on first match
            end
        end
    else
        logger:error("ProceduralDistributions not found, skipping distribution updates.")
    end
    local t1 = os.time()
    logger:info("distribution updates completed in %.3fs", t1 - t0)
end

Events.OnPreDistributionMerge.Add(updateDistributions)
