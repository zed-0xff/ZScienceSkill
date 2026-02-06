local player   = get_player()
local bodyPart = player:getBodyDamage():getBodyPart(BodyPartType.Hand_L)

ZBSpec.describe(ISApplyBandage, function()
    local bandage = instanceItem("Base.Bandage")

    it("has shorter duration with higher Science skill", function()
        player:setPerkLevelDebug(Perks.Science, 10)
        local dur10 = described_class:new(player, player, bandage, bodyPart, true):getDuration()
        player:setPerkLevelDebug(Perks.Science, 5)
        local dur05 = described_class:new(player, player, bandage, bodyPart, true):getDuration()
        player:setPerkLevelDebug(Perks.Science, 0)
        local dur00 = described_class:new(player, player, bandage, bodyPart, true):getDuration()

        assert(dur10 < dur05)
        assert(dur05 < dur00)
    end)

    pending("has longer bandage life with higher Science skill")
end)

ZBSpec.describe(ISDisinfect, function()
    local alcohol = instanceItem("Base.AlcoholWipes")

    it("has shorter duration with higher Science skill", function()
        player:setPerkLevelDebug(Perks.Science, 10)
        local dur10 = described_class:new(player, player, alcohol, bodyPart):getDuration()
        player:setPerkLevelDebug(Perks.Science, 5)
        local dur05 = described_class:new(player, player, alcohol, bodyPart):getDuration()
        player:setPerkLevelDebug(Perks.Science, 0)
        local dur00 = described_class:new(player, player, alcohol, bodyPart):getDuration()

        assert(dur10 < dur05)
        assert(dur05 < dur00)
    end)
end)

ZBSpec.describe(ISSplint, function()
    local splint = instanceItem("Base.Splint")

    it("has shorter duration with higher Science skill", function()
        player:setPerkLevelDebug(Perks.Science, 10)
        local dur10 = described_class:new(player, player, splint, bodyPart, true):getDuration()
        player:setPerkLevelDebug(Perks.Science, 5)
        local dur05 = described_class:new(player, player, splint, bodyPart, true):getDuration()
        player:setPerkLevelDebug(Perks.Science, 0)
        local dur00 = described_class:new(player, player, splint, bodyPart, true):getDuration()

        assert(dur10 < dur05)
        assert(dur05 < dur00)
    end)
end)

return ZBSpec.run()
