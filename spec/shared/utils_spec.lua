describe(ZScienceSkill.isCombatPerk, function()
    it("detects Combat perk", function()
        assert.is_true(subject(Perks.Combat))
    end)
    
    it("detects Firearm perk", function()
        assert.is_true(subject(Perks.Firearm))
    end)

    it("detects Axe perk", function()
        assert.is_true(subject(Perks.Axe))
    end)
    
    it("rejects non-Combat perk", function()
        assert.is_false(subject(Perks.Woodwork))
    end)
end)

return ZBSpec.run()
