-- Project Zomboid API globals
-- This file is included by .luacheckrc
-- Generated/updated by: ruby tools/extract_pz_globals.rb

return {
    -- Mod namespace
    "ZScienceSkill",
    
    -- Core API
    "Events",
    "LuaEventManager",
    "triggerEvent",
    
    -- Player functions
    "getPlayer",
    "getSpecificPlayer",
    "getPlayerByOnlineID",
    "getOnlinePlayers",
    
    -- World & Game
    "getWorld",
    "getCell",
    "getCore",
    "getGameTime",
    "getSandboxOptions",
    "getServerOptions",
    
    -- Skills & Perks
    "Perks",
    "PerkFactory",
    "addXp",
    "getXp",
    
    -- Items & Inventory
    "InventoryItem",
    "InventoryItemFactory",
    "ItemContainer",
    "ItemPickerJava",
    
    -- Recipes & Crafting
    "Recipe",
    "getScriptManager",
    "getAllRecipes",
    
    -- Reading & Books
    "ISReadABook",
    "SkillBook",
    
    -- UI Components
    "ISPanel",
    "ISButton",
    "ISLabel",
    "ISTextBox",
    "ISTickBox",
    "ISComboBox",
    "ISInventoryPane",
    "ISInventoryPage",
    "ISInventoryPaneContextMenu",
    "ISTimedActionQueue",
    "ISContextMenu",
    "ISToolTip",
    "ISToolTipInv",
    
    -- Timed Actions
    "ISBaseTimedAction",
    "ISInventoryTransferAction",
    
    -- Textures & Graphics
    "getTexture",
    "Texture",
    
    -- Utilities
    "instanceof",
    "isClient",
    "isServer",
    "isCoopHost",
    "isAdmin",
    "getText",
    "getTextOrNull",
    "print",
    "luautils",
    "ZombRand",
    "ZombRandFloat",
    
    -- Sandbox & Options
    "ModOptions",
    "PZAPI",
    
    -- Java Classes (commonly used)
    "ArrayList",
    "HashMap",
    "Vector2",
    "IsoObject",
    "IsoGridSquare",
    "IsoPlayer",
    "IsoZombie",
    "IsoWorld",
}
