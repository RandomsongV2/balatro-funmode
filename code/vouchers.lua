SMODS.Atlas{
    key = 'vouchers',
    path = 'vouchers.png',
    px = 71,
    py = 95
}

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
                G.P_CENTERS.e_polychrome.weight = G.P_CENTERS.e_polychrome.weight * card.ability.extra.rate
                G.P_CENTERS.e_funmode_monochrome.weight = G.P_CENTERS.e_funmode_monochrome.weight * card.ability.extra.rate
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
                for v, u in ipairs(G.GAME.used_vouchers) do
                    if v == 'v_funmode_color_theory' and u then
                        G.P_CENTERS.e_polychrome.weight = G.P_CENTERS.e_polychrome.weight / G.P_CENTERS.v_funmode_color_theory.config.extra.rate
                        G.P_CENTERS.e_funmode_monochrome.weight = G.P_CENTERS.e_funmode_monochrome.weight / G.P_CENTERS.v_funmode_color_theory.config.extra.rate
                        break
                        end
                    end
                G.P_CENTERS.e_polychrome.weight = G.P_CENTERS.e_polychrome.weight * card.ability.extra.rate
                G.P_CENTERS.e_funmode_monochrome.weight = G.P_CENTERS.e_funmode_monochrome.weight * card.ability.extra.rate
                return true
            end
        }))
    end
}
