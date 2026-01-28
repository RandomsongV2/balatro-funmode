SMODS.Sticker {
    key = "fabricated_sticker",
    badge_colour = HEX 'aaaaaa',
    pos = {x = -1, y = -1},
    no_collection = true,
    rate = 0,
    should_apply = function(self, card, center, area, bypass_roll)
        return false
    end,
    apply = function(self, card, val)
        card.ability[self.key] = val
        if card.ability[self.key] then card.sell_cost = 0 end
    end,
    calculate = function(self, card, context)
        if context.end_of_round then
            if card.ability.hands_played_at_create ~= G.GAME.hands_played then
                card:start_dissolve({HEX("aaaaaa")}, nil, 1.6)
                end
            end
        end
}
