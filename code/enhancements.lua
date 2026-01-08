-- if thine goal is to seek copycard code thy shall find it in editions.lua
SMODS.Enhancement {
    key = 'copycard',
    loc_txt = {name = "Copycard",
               label = "Copycard",
               text = {"copies other card's",
                       "{C:attention}rank{}, {C:attention}enhancement{} and {C:attention}seal{}",
                       "changes with copied card",
                       "{C:inactive,s:0.9}copies are always monochrome{}"}
                       },
    replace_base_card = true,
    overrides_base_rank = true,
    weight = 0,
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_funmode_monochrome
        return {vars = {}}
        end,
    calculate = function(self, card, context)
        card:start_dissolve({HEX("57ecab")}, nil, 1.6)
        end
}
