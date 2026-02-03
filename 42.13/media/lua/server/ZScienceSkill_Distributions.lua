-- Add Science skill books to loot distributions

local function updateDistributions()
    -- luacheck: ignore 113/ProceduralDistributions
    -- ProceduralDistributions is available during OnPreDistributionMerge event
    -- It's not loaded in all contexts, so we guard against nil
    if not ProceduralDistributions then return end

    -- Distribution tables and base spawn weights for BookScience1
    local loot = {
        -- Library locations
        LibraryBooks = 10,
        LibraryCounter = 8,
        LibraryDesk = 6,
        -- School locations
        SchoolLockers = 4,
        ClassroomDesk = 6,
        ClassroomShelves = 8,
        -- Office locations
        OfficeDesk = 4,
        OfficeDeskHome = 4,
        OfficeDrawers = 4,
        -- Medical/Research locations
        MedicalClinicBooks = 8,
        MedicalStorageBooks = 8,
        -- Bookstore
        BookstoreBooks = 10,
        -- Shelves in homes (rare)
        ShelfGeneric = 2,
        BookShelf = 4,
    }

    -- Book weights decrease for higher volumes
    local books = {
        { item = "ZScienceSkill.BookScience1", multiplier = 1.0 },
        { item = "ZScienceSkill.BookScience2", multiplier = 0.8 },
        { item = "ZScienceSkill.BookScience3", multiplier = 0.6 },
        { item = "ZScienceSkill.BookScience4", multiplier = 0.4 },
        { item = "ZScienceSkill.BookScience5", multiplier = 0.2 },
    }

    for tableName, baseWeight in pairs(loot) do
        -- luacheck: ignore 113/ProceduralDistributions
        local dist = ProceduralDistributions.list[tableName]
        if dist and dist.items then
            for _, book in ipairs(books) do
                table.insert(dist.items, book.item)
                table.insert(dist.items, baseWeight * book.multiplier)
            end
        end
    end
end

Events.OnPreDistributionMerge.Add(updateDistributions)
