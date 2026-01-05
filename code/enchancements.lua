SMODS.Enhancement {
    key = 'copycard'
    loc_txt = {name = "Copycard",
               label = "Copycard",
               text = {"copies other card's",
                       "rank, enhancement, seal"}},
    replace_base_card = true,
    overrides_base_rank = true,
    config {}
    calculate(self, card, context)
        end
}
