SMODS.Voucher {
    key = 'color_theory',
    pos = {x = 4, y = 0},
    config = {extra = {rate = 2}},
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.rate}}
    end,
    in_pool = function(args) --todo
        return false
        end,
    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.colored_edition_rate = card.ability.extra.rate
                return true
            end
        }))
    end
}
