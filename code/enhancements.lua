SMODS.Atlas{
    key = 'enhancements',
    path = 'enhancements.png',
    px = 71,
    py = 95
}

-- if thy seeketh copycard code thy shall findst it in editions.lua
--(copycard enhancement is a scam, copycard is edition)
SMODS.Enhancement {
    key = 'copycard',
    replace_base_card = true,
    overrides_base_rank = true,
    weight = 0,
    pos = {x = 1, y = 0},
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

SMODS.Enhancement {
    key = 'observed',
    config = {mult = 3, funmode_observ_chance = 1/4},
    replace_base_card = true,
    no_rank = true,
    always_scores = true,
    atlas = 'enhancements',
    pos = {x = 1, y = 4},
    set_sprites = function(self, card, front)
        local y = 4
        if card.config.card.suit == 'Hearts' then
            y = 0
        elseif card.config.card.suit == 'Clubs' then
            y = 1
        elseif card.config.card.suit == 'Diamonds' then
            y = 2
        elseif card.config.card.suit == 'Spades' then
            y = 3
            end
        local x = 0
        if y == 4 then
            x, y = 2, 0
        elseif G.SETTINGS.colourblind_option then
            x = 1
            end
        card.children.center:set_sprite_pos({x = x, y = y})
        end,
    in_pool = function(self, args)
        return false
        end,
    calculate = function(self, card, context)
        if context.funmode_pre_play and G and G.hand and G.hand.highlighted and
        card.ability.funmode_observ_chance and pseudorandom("funmode_m_observed_check") < card.ability.funmode_observ_chance
        then
            in_hand = false
            for _, c in ipairs(G.hand.cards) do
                if c == card then
                    in_hand = true
                    break
                end
            end
            if in_hand then
                local played = false
                for _, played_card in ipairs(G.hand.highlighted) do
                    if played_card == card then
                        played = true
                        break
                    end
                end
                if played then
                    if #G.hand.highlighted > 1 then
                        G.hand:remove_from_highlighted(card)
                    end
                elseif #G.hand.highlighted >= G.GAME.starting_params.play_limit or
                #G.hand.highlighted >= 1 and pseudorandom(pseudoseed("funmode_m_observed_check_2")) < card.ability.funmode_observ_chance
                then
                    G.hand:remove_from_highlighted(G.hand.highlighted[pseudorandom(pseudoseed("funmode_m_observed"), 1, #G.hand.highlighted)])
                end
                G.hand:add_to_highlighted(card)
            end
        end
        if context.funmode_base_applied and context.funmode_base_target == card and context.funmode_suit then
            self:set_sprites(card, card.config.center)
            end
        end
}
