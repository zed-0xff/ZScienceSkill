ZBSpec.describe("ZScienceSkill.isCombatPerk", function()
    it("detects Combat perk", function()
        assert.is_true(ZScienceSkill.isCombatPerk(Perks.Combat))
    end)
    
    it("detects Firearm perk", function()
        assert.is_true(ZScienceSkill.isCombatPerk(Perks.Firearm))
    end)

    it("detects Axe perk", function()
        assert.is_true(ZScienceSkill.isCombatPerk(Perks.Axe))
    end)
    
    it("rejects non-Combat perk", function()
        assert.is_false(ZScienceSkill.isCombatPerk(Perks.Woodwork))
    end)
end)

return ZBSpec.run()
