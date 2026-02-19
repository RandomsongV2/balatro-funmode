SMODS.Atlas{
    key = 'vanilla_type',
    path = 'vanilla_type.png',
    px = 71,
    py = 95
}

SMODS.PokerHand {
    key = 'Lone Face',
    mult = 2,
    chips = 40,
    l_mult = 3,
    l_chips = 25,
    visible = false,
    example = {
        {'S_K', true },
        {'H_Q', false},
        {'D_J', false},
        {'H_funmode_-J', false},
        {'C_funmode_-Q', false}
        },
    evaluate = function(parts, hand)
        for _, card in ipairs(hand) do
            if not card:is_face() then
                return {}
                end
            end
        if #hand >= 5 and #parts._2 == 0 and #parts._straight == 0 and #parts._flush == 0 then
            return parts._highest
            end
        return {}
        end,
    }

SMODS.Consumable {
    key = "makemake",
    set = "Planet",
    cost = 3,
    atlas = 'vanilla_type',
    pos = {x = 0, y = 0},
    discovered = true,
    config = {hand_type = 'funmode_Lone Face', softlock = true},
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                G.GAME.hands[card.ability.hand_type].level,
                localize(card.ability.hand_type, 'poker_hands'),
                G.GAME.hands[card.ability.hand_type].l_mult,
                G.GAME.hands[card.ability.hand_type].l_chips,
                colours = {(G.GAME.hands[card.ability.hand_type].level == 1 and G.C.UI.TEXT_DARK or G.C.HAND_LEVELS[math.min(7, G.GAME.hands[card.ability.hand_type].level)])}
            }
        }
    end,
    set_card_type_badge = function(self, card, badges)
        badges[#badges + 1] = create_badge(localize('k_dwarf_planet'),
            get_type_colour(card.config.center or card.config, card), SMODS.ConsumableTypes.Planet.text_colour,
            1.2)
    end
}
