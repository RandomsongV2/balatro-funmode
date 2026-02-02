SMODS.PokerHand {
    key = 'lone_face',
    mult = 2,
    chips = 20,
    l_mult = 2,
    l_chips = 20,
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
