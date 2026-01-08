-- fun_jumbo and fun_mega
SMODS.Booster {
    key = "fun_base",
    loc_txt = {
        name = "Fun Pack",
        group_name = "Fun Pack",
        text = {'Choose {C:attention}#2#{} of up to',
                '{C:attention}#1#{} {C:dark_edition}Fun{} cards to',
                'be used immediately'},
                },
    discovered = true,
    draw_hand = true,
    kind = "fun_pack",
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra, center.ability.choose}}
        end,
    create_card = function(self, card)
        local newCard = SMODS.create_card({set = "FunCards", area = G.pack_cards, skip_materialize = true})
        return newCard
            end,
    select_card = function(card, pack)
        return false
        end,
    config = {extra = 3, choose = 1},
    cost = 4,
    weight = 1
}
