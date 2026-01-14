-- if thy seeketh copycard code thy shall findst it in editions.lua
--(copycard enhancement is a scam, copycard is edition)
SMODS.Enhancement {
    key = 'copycard',
    replace_base_card = true,
    overrides_base_rank = true,
    weight = 0,
    in_pool = function(self, args)
        return false
        end,
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_funmode_monochrome
        return {vars = {}}
        end,
    calculate = function(self, card, context)
        card:start_dissolve({HEX("57ecab")}, nil, 1.6)
        end
}

SMODS.Atlas{
    key = 'm_observed',
    path = 'm_observed.png',
    px = 71,
    py = 95
}
SMODS.Enhancement {
    key = 'observed',
    config = {
            mult = 3,
            fun_observ_chance = 1
    },
    replace_base_card = true,
    no_rank = true,
    always_scores = true,
    atlas = 'm_observed',
    pos = {x = 4, y = 0},
    set_sprites = function(self, card, front)
        local x = 4
        if card.config.card.suit == 'Hearts' then
            x = 0
        elseif card.config.card.suit == 'Clubs' then
            x = 1
        elseif card.config.card.suit == 'Diamonds' then
            x = 2
        elseif card.config.card.suit == 'Spades' then
            x = 3
            end
        local y = 0
        if G.SETTINGS.colourblind_option and x ~= 4 then
            y = 1
            end
        card.children.center:set_sprite_pos({x = x, y = y})
        end,
    in_pool = function(self, args)
        return false
        end,
    calculate = function(self, card, context)
        if context.press_play and G and G.hand and G.hand.highlighted and
        card.ability.fun_observ_chance and pseudorandom("funmode_m_observed_check") < card.ability.fun_observ_chance
        then
            local played = false
            for _, played_card in ipairs(G.hand.highlighted) do
                if played_card == card then
                    played = true
                    break
                    end
                end
            if not played then
                if #G.hand.highlighted >= G.GAME.starting_params.play_limit then
                    G.hand:remove_from_highlighted(G.hand.highlighted[pseudorandom(pseudoseed("funmode_m_observed"), 1, #G.hand.highlighted)])
                    end
                G.hand:add_to_highlighted(card)
                end
            end
        end
}
