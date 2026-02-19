SMODS.Atlas{
    key = 'stickers',
    path = 'stickers.png',
    px = 71,
    py = 95
}
SMODS.Sticker {
    key = "true_perishable",
    badge_colour = HEX 'aaaae7',
    atlas = 'stickers',
    pos = {x = 0, y = 0},
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
            if card.ability.hands_played_at_create ~= G.GAME.hands_played or card.area ~= G.jokers then
                card:start_dissolve({HEX("aaaaaa")}, nil, 1.6)
                end
            end
        end
}
