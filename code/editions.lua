SMODS.Shader {
    key = 'monochrome',
    path = 'monochrome.fs',
    send_vars = function(sprite, card)
        if card then
            return {colour_values = card.ability.funmode_monochrome_vars or {1, 1, 1}}
        end
    end,
}
Funmode.set_monochrome_vars = function(card)
    if not card.ability.funmode_monochrome_vars then
        if pseudorandom('funmode_gray_monochrome') < 0.5 then
            col = {
                pseudorandom('funmode_monochrome_color_r', 0, 1),
                pseudorandom('funmode_monochrome_color_g', 0, 1),
                pseudorandom('funmode_monochrome_color_b', 0, 1),
                   }
                if col[1] + col[2] + col[3] == 0 then
                    col = {1, 1, 1}
                end
        else
            col = {1, 1, 1}
        end
        card.ability.funmode_monochrome_vars = col
    end
end
SMODS.Edition {
    key = "monochrome",
    discovered = true,
    unlocked = true,
    shader = "monochrome",
    config = {},
    in_shop = true,
    get_weight = function(self)
        return G.P_CENTERS.e_funmode_monochrome.weight * (G.GAME.funmode_colour_rate or 1)
        end,
    weight = 3,
    extra_cost = 1,
    apply_to_float = true,
    on_apply = function(card)
        Funmode.set_monochrome_vars(card)
    end,
    loc_vars = function(self)
    end,
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            return {
            func = function()
                hand_chips, mult = mod_chips(math.ceil(math.sqrt(hand_chips * mult))), mod_mult(math.ceil(math.sqrt(hand_chips * mult)))
                update_hand_text({sound = 'button', modded = true}, {chips = chips, mult = mult})
                return true
                end,
            message = 'Balanced'
            }
            end
        end
}
