ZBSpec.describe("SkillBook['Science']", function()

    local sci = SkillBook["Science"]

    it("is a table", function()
        assert.is_table(sci)
    end)

    it("has a perk", function()
        assert.is_equal(Perks.Science, sci.perk)
    end)

    it("has multipliers", function()
        assert.is_equal(3, sci.maxMultiplier1)
        assert.is_equal(5, sci.maxMultiplier2)
        assert.is_equal(8, sci.maxMultiplier3)
        assert.is_equal(12, sci.maxMultiplier4)
        assert.is_equal(16, sci.maxMultiplier5)
    end)
end)

return ZBSpec.run()
