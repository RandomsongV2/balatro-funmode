-- fun_jumbo and fun_mega
SMODS.Atlas{
    key = 'boosters',
    path = 'boosters.png',
    px = 71,
    py = 95
}
SMODS.Booster {
    key = "fun_base",
    loc_txt = {
        name = "Fun Pack",
        group_name = "Fun Pack",
        text = {'Choose {C:attention}#2#{} of up to',
                '{C:attention}#1#{} {C:dark_edition}Fun{} cards to',
                'be used immediately'},
                },
    atlas = 'boosters',
    pos = {x = 0, y = 0},
    discovered = true,
    draw_hand = true,
    kind = "fun_pack",
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra, center.ability.choose}}
        end,
    create_card = function(self, card)
        local newCard = SMODS.create_card({set = "FunCard", area = G.pack_cards, skip_materialize = true})
        return newCard
            end,
    select_card = function(card, pack)
        return false
        end,
    config = {extra = 3, choose = 1},
    cost = 4,
    weight = 0.15
}
SMODS.Booster {
    key = "fun_base_2",
    loc_txt = {
        name = "Fun Pack",
        group_name = "Fun Pack",
        text = {'Choose {C:attention}#2#{} of up to',
                '{C:attention}#1#{} {C:dark_edition}Fun{} cards to',
                'be used immediately'},
                },
    atlas = 'boosters',
    pos = {x = 1, y = 0},
    discovered = true,
    draw_hand = true,
    kind = "fun_pack",
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra, center.ability.choose}}
        end,
    create_card = function(self, card)
        local newCard = SMODS.create_card({set = "FunCard", area = G.pack_cards, skip_materialize = true})
        return newCard
            end,
    select_card = function(card, pack)
        return false
        end,
    config = {extra = 3, choose = 1},
    cost = 4,
    weight = 0.15
}
SMODS.Booster {
    key = "fun_jumbo",
    loc_txt = {
        name = "Jumbo Fun Pack",
        group_name = "Fun Pack",
        text = {'Choose {C:attention}#2#{} of up to',
                '{C:attention}#1#{} {C:dark_edition}Fun{} cards to',
                'be used immediately'},
                },
    atlas = 'boosters',
    pos = {x = 2, y = 0},
    discovered = true,
    draw_hand = true,
    kind = "fun_pack",
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra, center.ability.choose}}
        end,
    create_card = function(self, card)
        local newCard = SMODS.create_card({set = "FunCard", area = G.pack_cards, skip_materialize = true})
        return newCard
            end,
    select_card = function(card, pack)
        return false
        end,
    config = {extra = 5, choose = 1},
    cost = 4,
    weight = 0.15
}
SMODS.Booster {
    key = "fun_mega",
    loc_txt = {
        name = "Mega Fun Pack",
        group_name = "Fun Pack",
        text = {'Choose {C:attention}#2#{} of up to',
                '{C:attention}#1#{} {C:dark_edition}Fun{} cards to',
                'be used immediately'},
                },
    atlas = 'boosters',
    pos = {x = 3, y = 0},
    discovered = true,
    draw_hand = true,
    kind = "fun_pack",
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra, center.ability.choose}}
        end,
    create_card = function(self, card)
        local newCard = SMODS.create_card({set = "FunCard", area = G.pack_cards, skip_materialize = true})
        return newCard
            end,
    select_card = function(card, pack)
        return false
        end,
    config = {extra = 5, choose = 2},
    cost = 8,
    weight = 0.1
}
