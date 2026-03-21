SMODS.Atlas{
    key = 'vouchers',
    path = 'vouchers.png',
    px = 71,
    py = 95
}

local poly_weight_ref = G.P_CENTERS.e_polychrome.get_weight or (function(self) return G.P_CENTERS.e_polychrome.weight end)
G.P_CENTERS.e_polychrome.get_weight = function(self)
    return poly_weight_ref(self) * (G.GAME.funmode_colour_rate or 1)
    end

SMODS.Voucher {
    key = 'color_theory',
    atlas = 'vouchers',
    pos = {x = 0, y = 0},
    config = {extra = {rate = 2}},
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.rate}}
    end,
    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.funmode_colour_rate = card.ability.extra.rate
                return true
            end
        }))
    end
}

SMODS.Voucher {
    key = 'color_theory_2',
    atlas = 'vouchers',
    pos = {x = 0, y = 1},
    config = {extra = {rate = 4}},
    discovered = true,
    requires = {'v_funmode_color_theory'},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.rate}}
    end,
    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.funmode_colour_rate = card.ability.extra.rate
                return true
            end
        }))
    end
}
