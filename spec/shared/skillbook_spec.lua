describe("SkillBook['Science']", function()

    local sci = SkillBook["Science"]

    it("is a table", function()
        assert.is_table(sci)
    end)

    it("has a perk", function()
        assert.eq(Perks.Science, sci.perk)
    end)

    it("has multipliers", function()
        assert.eq(3, sci.maxMultiplier1)
        assert.eq(5, sci.maxMultiplier2)
        assert.eq(8, sci.maxMultiplier3)
        assert.eq(12, sci.maxMultiplier4)
        assert.eq(16, sci.maxMultiplier5)
    end)
end)

return ZBSpec.run()
