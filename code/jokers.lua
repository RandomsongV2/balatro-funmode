SMODS.Atlas{
    key = 'jokers',
    path = 'jokers.png',
    px = 71,
    py = 95
}
SMODS.Joker{
    key = 'joke',
    config = {extra = {loss = 10, gain = 20}},
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.loss, center.ability.extra.gain}}
        end,
    atlas = 'jokers',
    rarity = 3,
    cost = 10,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 1, y = 0},
    calculate = function(self, card, context)
        if context.setting_blind then
            ease_dollars(-10)
            end
         end,
    calc_dollar_bonus = function(self, card)
        if G.GAME.dollars >= 0 then
            return 20
            end
        end
}

SMODS.Joker{
    key = 'handcuffs',
    atlas ='jokers',
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 4},
    config = {extra = {discards = 2}},
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.discards}}
        end,
    calculate = function(self, card, context)
        if context.setting_blind then
            return {
                func = function()
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.3,
                        func = function()
                            ease_discard(card.ability.extra.discards, nil, true)
                            ease_hands_played(2 - G.GAME.current_round.hands_left)
                            SMODS.calculate_effect(
                                {message = localize{type = 'variable', key = 'a_discards', vars = {card.ability.extra.discards}}}, context.blueprint_card or card
                                )
                            return true
                        end
                    }))
                end
                }
        end
    end
    }

SMODS.Joker{
    key = 'gamba',
    atlas ='jokers',
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    pixel_size = { h = 55 },
    pos = {x = 1, y = 3},
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = G.P_CENTERS.c_wheel_of_fortune
        return {vars = {G.GAME.probabilities.normal}}
        end,
    calculate = function(self, card, context)
        if context.setting_blind then
            if pseudorandom('gamba') < G.GAME.probabilities.normal/6 then
                play_sound("tarot1")
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.3,
                    blockable = false,
                    func = function()
                        G.jokers:remove_card(card)
                        card:remove()
                        card = nil
                        return true
                    end
                }))
                return true
                end
            end
        if context.end_of_round and context.cardarea == G.jokers then
            if G.consumeables.config.card_limit > #G.consumeables.cards then
                local new_card = create_card("Tarot", G.consumeables, nil, nil, nil, nil, "c_wheel_of_fortune")
                new_card:add_to_deck()
                G.consumeables:emplace(new_card)
            end
        end
    end
}

SMODS.Joker{
    key = 'soul',
    atlas ='jokers',
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true, --lol
    perishable_compat = true, --haha
    pos = {x = 3, y = 2},
    soul_pos = {x = 4, y = 2},
    config = {extra = {rounds_played = 0, rounds_required = 7}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.rounds_played, card.ability.extra.rounds_required}}
        end,
    calculate = function(self, card, context)
        if context.end_of_round and context.cardarea == G.jokers then
            card.ability.extra.rounds_played = card.ability.extra.rounds_played + 1
            if card.ability.extra.rounds_played >= card.ability.extra.rounds_required then
                juice_card_until(card, function() return true end, true)
                end
            end
        if context.selling_self then
            if card.ability.extra.rounds_played >= card.ability.extra.rounds_required then
                local card = create_card("Joker", G.jokers, true, nil, nil, nil, nil)
                card:add_to_deck()
                G.jokers:emplace(card)
                card:start_materialize()
                end
            end
        end
}

SMODS.Joker{
    key = 'mimic_detector',
    atlas ='jokers',
    rarity = 3,
    cost = 0,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 1, y = 4},
    pixel_size = {w = 42, h = 65},
    in_pool = function(self, args)
        return False
        end,
    calculate = function(self, card, context)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.3,
            blockable = false,
            func = function()
                G.jokers:remove_card(card)
                card:remove()
                card = nil
                return true
            end
        }))
        end
}

--todo
SMODS.Joker{
    key = 'manfred_von_karma',
    atlas ='jokers',
    rarity = 4,
    cost = 20,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 3, y = 3},
    soul_pos = {x = 4, y = 3},
    in_pool = function(self, args)
        return False
        end,
    calculate = function(self, card, context)
            if context.end_of_round and context.cardarea == G.jokers then
                menu = function()
                    return {n = G.UIT.ROOT, config = {align = 'cm'}, nodes{
                        {n = G.UIT.T, config = {text = 'aaa', colour = G.C.UI.TEXT_LIGHT, scalr = 0.5}}}}
                end
                local ui = UIBox({
                    definition = menu(),
                    config = {type = 'cm'}})
                end
            end
}

SMODS.Joker{
    key = 'franziska_von_karma',
    atlas ='jokers',
    rarity = 4,
    cost = 9,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 3, y = 1},
    soul_pos = {x = 4, y = 1},
    config = {extra = {x_mult = 0.5}},
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = G.P_CENTERS.c_fool
        return {vars = {center.ability.extra.x_mult}}
        end,
    calculate = function(self, card, context)
        --if G.GAME.current_round.hands_played < 3 then
            if context.before then
                if G.consumeables.config.card_limit > #G.consumeables.cards then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.4,
                        func = function()
                            local new_card = create_card("Tarot", G.consumeables, nil, nil, nil, nil, "c_fool")
                            new_card:add_to_deck()
                            G.consumeables:emplace(new_card)
                            return true
                            end
                    }))
                    end
                end
        --    end
        if context.individual and context.cardarea == G.play then
            if context.other_card:is_face() then
				return {
                    x_mult = card.ability.extra.x_mult,
                    colour = G.C.RED,
                    card = card
				}
                end
            end
        end
}

SMODS.Joker{ --really cool joker
    key = 'DOG',
    atlas ='jokers',
    rarity = 4,
    cost = 20,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 3, y = 0},
    soul_pos = {x = 4, y = 0},
    config = {extra = {chips = 0, mult = 0, Xmult = 1.0}},
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.chips, center.ability.extra.mult, center.ability.extra.Xmult}}
        end,
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            local achips = 0
            local amult = 0
            local axmult = 0
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] ~= card and G.jokers.cards[i] ~= nil and not G.jokers.cards[i].ability.eternal then
                    local selected = G.jokers.cards[i]

                    if selected.ability.chips ~= nil and selected.ability.chips ~= 0 then
                        achips = achips + selected.ability.chips
                    elseif type(selected.ability.extra) == "table" and selected.ability.extra.chips ~= nil and selected.ability.extra.chips ~= 0 then
                        achips = achips + selected.ability.extra.chips
                    elseif selected.ability.t_chips ~= nil and selected.ability.t_chips ~= 0 then
                        achips = achips + selected.ability.t_chips
                    elseif type(selected.ability.extra) == "table" and selected.ability.extra.t_chips ~= nil and selected.ability.extra.t_chips ~= 0 then
                        achips = achips + selected.ability.extra.t_chips
                    end

                    if selected.ability.mult ~= nil and selected.ability.mult ~= 0 then
                        amult = amult + selected.ability.mult
                    elseif type(selected.ability.extra) == "table" and selected.ability.extra.mult ~= nil and selected.ability.extra.mult ~= 0 then
                        amult = amult + selected.ability.extra.mult
                    elseif selected.ability.t_mult ~= nil and selected.ability.t_mult ~= 0 then
                        amult = amult + selected.ability.t_mult
                    elseif type(selected.ability.extra) == "table" and selected.ability.extra.t_mult ~= nil and selected.ability.extra.t_mult ~= 0 then
                        amult = amult + selected.ability.extra.t_mult
                    end

                    if selected.ability.x_mult ~= nil and selected.ability.x_mult > 1 then
                        axmult = axmult + selected.ability.x_mult - 1
                    elseif selected.ability.Xmult ~= nil and selected.ability.Xmult > 1 then
                        axmult = axmult + selected.ability.Xmult
                    elseif selected.ability.xmult ~= nil and selected.ability.xmult > 1 then
                        axmult = axmult + selected.ability.xmult
                    elseif type(selected.ability.extra) == "table" and selected.ability.extra.x_mult ~= nil and selected.ability.extra.x_mult > 1 then
                        axmult = axmult + selected.ability.extra.x_mult - 1
                    elseif type(selected.ability.extra) == "table" and selected.ability.extra.Xmult ~= nil and selected.ability.extra.Xmult > 1 then
                        axmult = axmult + selected.ability.extra.Xmult - 1
                    elseif type(selected.ability.extra) == "table" and selected.ability.extra.xmult ~= nil and selected.ability.extra.xmult > 1 then
                        axmult = axmult + selected.ability.extra.xmult - 1
                    elseif (   selected.config.center.key == "blackboard" or selected.config.center.key == "baron"
                            or selected.config.center.key == "photograph" or selected.config.center.key == "baseball"
                            or selected.config.center.key == "ancient"    or selected.config.center.key == "acrobat"
                            or selected.config.center.key == "flower_pot" or selected.config.center.key == "seeing_double")
                            and type(selected.ability.extra) == "number" and selected.ability.extra > 1
                    then
                        axmult = axmult + selected.ability.extra - 1
                    end

                    selected.getting_sliced = true
                    G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.GAME.joker_buffer = 0
                            selected:start_dissolve({ HEX("57ecab") }, nil, 1.6)
                            play_sound('tarot1', 0.96 + math.random() * 0.08)
                            delay(0.7)
                            return true
                        end
                    }))
                    end
                end
            card.ability.extra.chips = card.ability.extra.chips + achips
            card.ability.extra.mult = card.ability.extra.mult + amult
            card.ability.extra.Xmult = card.ability.extra.Xmult + axmult
                return {
                    card:juice_up(0.8, 0.8),
                    no_juice = true
                }
            end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult,
                Xmult = card.ability.extra.Xmult
            }
            end
    end
}

SMODS.Joker{
    key = 'twin',
    atlas ='jokers',
    rarity = 1,
    cost = 5,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    allow_duplicates = true,
    pos = {x = 1, y = 2},
    config = {extra = {xmult = 1, sprite = -1, mult_scaling = 0.5}},
    loc_vars = function(self, info_queue, card)
        card.ability.extra.xmult = math.max((#SMODS.find_card("j_funmode_twin", true)) * card.ability.extra.mult_scaling + 1, 1)
        return {vars = {card.ability.extra.xmult, card.ability.extra.mult_scaling} }
        end,
    set_sprites = function(self, card, front)
        if front then
            if not card.ability.extra.sprite then
                card.ability.extra.sprite = pseudorandom('twinsprite', 1, 2)
                end
            card.children.center:set_sprite_pos({x = card.ability.extra.sprite, y = 2})
            end
        end,
    calculate = function(self, card, context)
        if context.joker_main then
                card.ability.extra.xmult = math.max((#SMODS.find_card("j_funmode_twin", true)) * card.ability.extra.mult_scaling + 1, 1)
                return {
                xmult = card.ability.extra.xmult
                }
            end
        end
}

SMODS.Atlas{
    key = 'YTTL',
    path = 'other_size_jokers/yttl.png',
    px = 206,
    py = 168
}
SMODS.Joker{
    key = 'YTTL',
    atlas ='YTTL',
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 0},
    display_size = {w = 103, h = 84},
    config = {extra = {payout = 1, scaling = 1, allowed = true}},
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.payout, center.ability.extra.scaling}}
        end,
    calculate = function(self, card, context)
        if context.setting_blind then
            card.ability.extra.allowed = true
            end
        if context.end_of_round and G.GAME.current_round.hands_left == 0 and G.GAME.current_round.discards_left == 0 and card.ability.extra.allowed then
            --todo add message 'YOUR TAKING TO LONG' with laugh
            play_sound('funmode_yttl', 0.96 + math.random() * 0.08, 0.5)
            --todo: implement \/
            --play_sound('funmode_pumkin_laugh', 0.96 + math.random() * 0.08, 0.25)
            card.ability.extra.allowed = false
            card.ability.extra.payout = card.ability.extra.payout + card.ability.extra.scaling
            end
        end,
    calc_dollar_bonus = function(self, card)
        return card.ability.extra.payout
        end
}

SMODS.Joker{
    key = 'feedbacker',
    atlas ='jokers',
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 1, y = 1},
    loc_vars = function(self, info_queue, center)
        return {vars = {colours = {HEX('008ee6')}}}
        end,
    calculate = function(self, card, context)
        if context.destroy_card and context.cardarea == G.play and G.play.cards ~= nil then
            cards_played = #G.play.cards
            local mid = (cards_played - (cards_played % 2)) / 2 + cards_played % 2
            local selected = G.play.cards[mid]
            if not selected:is_suit("Clubs") then
                selected:start_dissolve({HEX("57ecab")}, nil, 1.6)
                play_sound('funmode_parry', 0.96 + math.random() * 0.08, 0.25)
            elseif cards_played % 2 == 0 then
                selected = G.play.cards[mid + 1]
                if not selected:is_suit("Clubs") then
                    selected:start_dissolve({HEX("57ecab")}, nil, 1.6)
                    play_sound('funmode_parry', 0.96 + math.random() * 0.08, 0.25)
                    end
                end
            end
        end
}

SMODS.Joker{
    key = 'slothful',
    config = {extra = {xmult = 2}},
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.xmult}}
        end,
    atlas = 'jokers',
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 2, y = 1},
    calculate = function(self, card, context)
        if context.joker_main and G.SETTINGS.GAMESPEED == 0.5 then
            return {
               xmult = card.ability.extra.xmult
               }
            end
        if G.SETTINGS.GAMESPEED ~= 0.5 then
            G.SETTINGS.GAMESPEED = 0.5
            end
        end
}

SMODS.Joker{
    key = 'minos',
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = G.P_CENTERS.j_funmode_minos_prime
        return {}
        end,
    atlas = 'jokers',
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    pos = {x = 2, y = 3},
    calculate = function(self, card, context)
        if context.joker_type_destroyed and context.card == card then
            SMODS.add_card({key = 'j_funmode_minos_prime'})
            end
        end
}

SMODS.Atlas{
    key = 'minos_prime',
    path = 'other_size_jokers/minos_prime.png',
    px = 316,
    py = 1022
}
SMODS.Joker{
    key = 'minos_prime',
    config = {extra = {xmult = 1, scaling = 1}},
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = G.P_CENTERS.c_judgement
        return {vars = {center.ability.extra.xmult, center.ability.extra.scaling}}
        end,
    atlas = 'minos_prime',
    rarity = 4,
    cost = 20,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 0},
    display_size = {w = 316/10, h = 1022/10},
    in_pool = function(self, args)
        return false
        end,
    calculate = function(self, card, context)
        if context.using_consumeable and context.consumeable.config.center_key == 'c_judgement' then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.scaling
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                blockable = false,
                func = function()
                    if pseudorandom('minos_prime_judgement') < 0.5 then
                        play_sound('funmode_judgement', 0.96 + math.random() * 0.08, 0.25)
                    else
                        play_sound('funmode_judgement2', 0.96 + math.random() * 0.08, 0.25)
                        end
                    return true
                    end
                }))
            return {message = localize {type = 'variable', key = 'a_xmult', vars = {card.ability.extra.xmult}}}
            end
        if context.joker_main then
            return {xmult = card.ability.extra.xmult}
            end
    end
}

SMODS.Joker{
    key = 'burning',
    config = {extra = {xmult = 1.0, scaling = 0.1}},
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.xmult, center.ability.extra.scaling}}
        end,
    atlas = 'jokers',
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 2, y = 0},
    calculate = function(self, card, context)
        if context.pre_discard and not context.hook then
            local hand_discarded, _ = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
            local increase = true
            local play_more_than = (G.GAME.hands[hand_discarded].played or 0)
            for k, v in pairs(G.GAME.hands) do
                if k ~= hand_discarded and v.played >= play_more_than and v.visible then
                    increase = false
                    break
                    end
                end
            if increase then
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.scaling
                return {
                    message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.xmult}}
                }
                end
            end
        end
}

SMODS.Joker{
    --todo: fix this joker
    key = 'black_market',
    config = {extra = {payout = 3}},
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.payout}}
        end,
    atlas = 'jokers',
    rarity = 2,
    cost = 7,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 2},
    calculate = function(self, card, context)
        if (context.card_added or context.selling_card or context.joker_type_destroyed or context.card_released) and not context.blueprint then
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] and G.jokers.cards[i].config.center_key == 'j_funmode_black_market' and not G.jokers.cards[i].debuff then
                    if i and G.jokers.cards[i + 1] then
                        SMODS.debuff_card(G.jokers.cards[i + 1], true, 'funmode_joker_black_market')
                        SMODS.recalc_debuff(G.jokers.cards[i + 1])
                        end
                    if i and G.jokers.cards[i - 1] then
                        SMODS.debuff_card(G.jokers.cards[i - 1], true, 'funmode_joker_black_market')
                        SMODS.recalc_debuff(G.jokers.cards[i - 1])
                        end
                    end
                if (not G.jokers.cards[i + 1] or G.jokers.cards[i + 1].config.center_key ~= 'j_funmode_black_market' or G.jokers.cards[i + 1].debuff) and
                    (not G.jokers.cards[i - 1] or G.jokers.cards[i - 1].config.center_key ~= 'j_funmode_black_market' or G.jokers.cards[i - 1].debuff) then
                    SMODS.debuff_card(G.jokers.cards[i], false, 'funmode_joker_black_market')
                    SMODS.recalc_debuff(G.jokers.cards[i])
                    end
                end
            end
        if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] and G.jokers.cards[i].debuff then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.4,
                        func = function()
                            play_sound('timpani')
                            card:juice_up(0.1, 0.5)
                            ease_dollars(card.ability.extra.payout, true)
                            return true
                            end
                    }))
                    end
                end
            end
        if context.selling_self then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    for i = 1, #G.jokers.cards do
                        if G.jokers.cards[i] then
                            SMODS.debuff_card(G.jokers.cards[i], false, 'funmode_joker_black_market')
                            SMODS.recalc_debuff(G.jokers.cards[i])
                            end
                        end
                    return true
                    end
            }))
            end
        end
}

SMODS.Joker{
    key = '68',
    config = {extra = {chips = 68}},
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.chips}}
        end,
    atlas = 'jokers',
    rarity = 1,
    cost = 3,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 0},
    calculate = function(self, card, context)
        if context.joker_main then
            local six = false
            local eight = false
            local seven_nine = false
            for _, _card in ipairs(context.scoring_hand) do
                if _card.config.card.value == '7' or _card.config.card.value == '9' then
                    seven_nine = true
                    break
                elseif _card.config.card.value == '6' then
                    six = true
                    if eight then
                        break
                        end
                elseif _card.config.card.value == '8' then
                    eight = true
                    if six then
                        break
                        end
                    end
                end
            if not seven_nine and six and eight then
                return {chips = card.ability.extra.chips}
                end
            end
        end
}

SMODS.Joker{ -- my new favorite
    key = 'unfair_coin',
    config = {extra = {streak = 0, used = false, msg = 'heads'}},
    loc_vars = function(self, info_queue, center)
        return {vars = {2 ^ center.ability.extra.streak}}
        end,
    atlas = 'jokers',
    rarity = 2,
    cost = 7,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 3},
    funmode_button = {
        text = ' flip',
        can_use = function(card)
            return not card.ability.extra.used
            end,
        use = function(card)
            if pseudorandom("funmode_j_unfair_coin") < 0.5 then
                ease_dollars(2 ^ card.ability.extra.streak)
                card.ability.extra.streak = card.ability.extra.streak + 1
                SMODS.calculate_effect({message = card.ability.extra.msg}, card)
                card.ability.extra.msg = card.ability.extra.msg..'!'
            else
                if card.ability.extra.streak > 1 then
                    SMODS.calculate_effect({message = "tails..."}, card)
                else
                    SMODS.calculate_effect({message = "tails"}, card)
                    end
                card.ability.extra.msg = 'heads'
                card.ability.extra.used = true
                end
            end
    },
    calculate = function(self, card, context)
        if context.end_of_round then
            card.ability.extra.used = false
            card.ability.extra.streak = 0
            juice_card_until(card, function() return not card.ability.extra.used end, true)
            end
        end
}


SMODS.Atlas{
    key = 'the_roaring_knight',
    path = 'other_size_jokers/rory_nyte.png',
    px = 80,
    py = 97,
    atlas_table = 'ANIMATION_ATLAS',
    frames = 70,
    fps = 30
}
SMODS.Joker{
    key = 'knight',
    config = {extra = {scaling = 1}},
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = G.P_CENTERS.c_aura
        return {vars = {center.ability.extra.scaling, 1 + center.ability.extra.scaling *
        (G.GAME.consumeable_usage and G.GAME.consumeable_usage.c_aura and G.GAME.consumeable_usage.c_aura.count or 0)}}
        end,
    atlas = 'the_roaring_knight',
    pos = {x = 0, y = 0},
    display_size = {w = 80, h = 97},
    rarity = 3,
    cost = 9,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.joker_main then
            return {Xmult = 1 + card.ability.extra.scaling * (G.GAME.consumeable_usage and G.GAME.consumeable_usage.c_aura and G.GAME.consumeable_usage.c_aura.count or 0)}
            end
        end
}

SMODS.Joker {
    key = 'grinning_beast',
    config = {extra = {destroy = 3}},
    loc_vars = function(self, querry, center)
        return {vars = {center.ability.extra.destroy}}
        end,
    rarity = 2,
    discovered = true,
    atlas = 'jokers',
    cost = 6,
    pos = {x = 2, y = 4},
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.hand_drawn and G.GAME.current_round.discards_used <= 0 and G.GAME.current_round.hands_played <= 0 then
            for i = 1, card.ability.extra.destroy do
                local select = pseudorandom("funmode_leigh", 1, #G.hand.cards + #G.jokers.cards + #G.consumeables.cards)
                local select1 = nil
                if select <= #G.hand.cards then
                    select1 = G.hand.cards[select]
                elseif select <= #G.hand.cards + #G.jokers.cards then
                    select1 = G.jokers.cards[select - #G.hand.cards]
                else
                    select1 = G.consumeables.cards[select - #G.hand.cards - #G.jokers.cards]
                    end
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.3,
                    func = function()
                        card:juice_up(0.8, 0.8)
                        select1:start_dissolve({ HEX("57ecab") }, nil, 1.0)
                        play_sound('slice1', 0.96 + math.random() * 0.08)
                        return true
                        end
                    }))
                end
            save_run()
            end
        end
}

SMODS.Joker{
    key = 'whiplash',
    config = {extra = {selected_card = nil}},
    loc_vars = function(self, info_queue, center)
        if selected_card then
            return {vars = {localize(selected_card.config.card.value, 'ranks'), localize(selected_card.config.card.suit, 'suits_plural'), colours = {G.C.FILTER, G.C.SUITS[selected_card.config.card.suit]}}}
            end
        return {vars = {'None', 'None', colours = {G.C.UI.TEXT_INACTIVE, G.C.UI.TEXT_INACTIVE}}}
        end,
    atlas = 'jokers',
    rarity = 3,
    cost = 10,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 3, y = 4},
    funmode_button = {
        text = ' hook',
        can_use = function(card)
            return true
            end,
        use = function(card)
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.funmode.whiplash = true
                    G.FUNCS.overlay_menu({definition = G.UIDEF.deck_info(true)})
                    return true
                end
            }))
            end
    },
    in_pool = function(self, args)
        return False
        end,
    calculate = function(self, card, context)
        end
}

SMODS.Joker{
    key = 'glass_cannon',
    config = {extra = {odds = 6}},
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_glass
        return {vars = {G.GAME.probabilities.normal, center.ability.extra.odds}}
        end,
    atlas = 'jokers',
    rarity = 2,
    cost = 7,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    pos = {x = 0, y = 0},
    calculate = function(self, card, context)
        if context.press_play then
            for _, _card in ipairs(G.hand.highlighted) do
                _card.funmode_glass = true
                end
            end
        if context.check_enhancement and context.other_card.funmode_glass and not context.blueprint then
            return {m_glass = true}
            end
        if context.final_scoring_step and pseudorandom('gamba') < G.GAME.probabilities.normal/card.ability.extra.odds and not context.blueprint then
            for _, _card in ipairs(G.hand.highlighted) do
                _card.funmode_glass = false
                end
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    G.GAME.joker_buffer = 0
                    card:start_dissolve({ HEX("57ecab") }, true, 1.6)
                    play_sound('glass2', 0.96 + math.random() * 0.08)
                    return true
                end
            }))
            end
        end
}

SMODS.Joker{
    key = 'evil',
    config = {extra = {xmult = 1.0, gain = 0.5}},
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.gain, center.ability.extra.xmult}}
        end,
    atlas = 'jokers',
    rarity = 2,
    cost = 7,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 4, y = 4},
    calculate = function(self, card, context)
        if context.setting_blind and #G.jokers.cards == 1 then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.gain
            return {message = localize {type = 'variable', key = 'a_xmult', vars = {card.ability.extra.xmult}}}
            end
        if context.joker_main then
            return {Xmult = card.ability.extra.xmult}
            end
        end
}

SMODS.Joker{
    key = 'insurance',
    config = {extra = {pay = 2, gain = 1}},
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.pay, center.ability.extra.gain}}
        end,
    atlas = 'jokers',
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 0},
    calculate = function(self, card, context)
        if context.setting_blind then
            ease_dollars(- card.ability.extra.pay)
            end
        if context.end_of_round and context.main_eval and context.beat_boss and not context.game_over then
            local money = 0
            for _, _card in ipairs(G.playing_cards) do
                if _card.debuff then
                    money = money + card.ability.extra.gain
                    end
                end
            ease_dollars(money)
            end
        end
}

SMODS.Joker{
    key = 'infini_eight',
    config = {extra = {xmult = 1.0, gain = 0.1}},
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.gain, center.ability.extra.xmult}}
        end,
    atlas = 'jokers',
    rarity = 1,
    cost = 5,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 0},
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 8 and not context.blueprint then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.gain
            end
        if context.joker_main then
            return {Xmult = card.ability.extra.xmult}
            end
        end
}

SMODS.Joker{
    key = 'wing_ding',
    config = {extra = {xmult = 2}},
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.xmult}}
        end,
    atlas = 'jokers',
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 0},
    calculate = function(self, card, context)
        if context.joker_main then
            return {Xmult = card.ability.extra.xmult}
            end
        end
}

SMODS.Joker{
    key = 'apartment_13',
    atlas ='jokers',
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 5, y = 0},
    config = {extra = {hands = 1}},
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = G.P_CENTERS.c_earth
        return {vars = {center.ability.extra.hands}}
        end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
        message = localize{type = 'variable', key = 'a_handsize_minus', vars = {card.ability.extra.hands}}
        end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
        message = localize{type = 'variable', key = 'a_handsize', vars = {card.ability.extra.hands}}
        end,
    calculate = function(self, card, context)
        if context.end_of_round and context.cardarea == G.jokers then
            if G.consumeables.config.card_limit > #G.consumeables.cards then
                local new_card = create_card("Planet", G.consumeables, nil, nil, nil, nil, "c_earth")
                new_card:add_to_deck()
                G.consumeables:emplace(new_card)
                end
            end
        end
}

SMODS.Joker{
    key = 'doom',
    atlas ='jokers',
    rarity = 2,
    cost = 7,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 5, y = 1},
    config = {extra = {gain = 0.5}},
    loc_vars = function(self, info_queue, center)
        local xmult = (function() et = 0 if G.jokers then for _, c in ipairs(G.jokers.cards) do if c.ability.eternal then et = et + 1 end end end return et end)()
        return {vars = {center.ability.extra.gain, xmult * center.ability.extra.gain + 1}}
        end,
    calculate = function(self, card, context)
        if context.joker_main then
            local xmult = (function() et = 0 for _, c in ipairs(G.jokers.cards) do if c.ability.eternal then et = et + 1 end end return et end)()
            return {xmult = xmult * card.ability.extra.gain + 1}
            end
        end
}

SMODS.Joker{
    key = 'bread_pit',
    atlas ='jokers',
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    pos = {x = 0, y = 0},
    config = {extra = {chips = 100, loss = 2}},
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.chips, center.ability.extra.loss}}
        end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint then
            card.ability.extra.chips = card.ability.extra.chips - card.ability.extra.loss
            end
        if context.joker_main then
            return {chips = card.ability.extra.chips}
            end
        if context.after and context.main_eval and not context.blueprint and
            card.ability.extra.chips <= 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                card:remove()
                                return true
                            end
                        }))
                        return true
                    end
                }))
            end
        end
}

SMODS.Joker{
    key = 'chips',
    atlas ='jokers',
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    pos = {x = 0, y = 0},
    config = {extra = {chips = 200, loss = 8}},
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.chips, center.ability.extra.loss}}
        end,
    calculate = function(self, card, context)
        if context.post_trigger then
            card.ability.extra.chips = card.ability.extra.chips - card.ability.extra.loss
            end
        if context.joker_main then
            return {chips = math.max(card.ability.extra.chips - 8, 0)}
            end
        if context.after and context.main_eval and not context.blueprint and
            card.ability.extra.chips <= 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                card:remove()
                                return true
                            end
                        }))
                        return true
                    end
                }))
            end
        end
}

local function calculate_m()
    local m = 0
    local function count_m(ch)
        if ch == localize('m', 'funmode_letter_m') or ch == localize('M', 'funmode_letter_m') or ch == 'm' or ch == 'M' then
            m = m + 1
            end
        end
    if G.jokers then
        for _, c in ipairs(G.jokers.cards) do
            name = c.ability and c.ability.funmode_extra and c.ability.funmode_extra.name
                or localize{set = 'Joker', type = 'name', key = c.config.center.key}
            if type(n) == 'string' then
                name:gsub(".", count_m)
            else
                for _, n in ipairs(name) do
                    if type(n) == 'string' then
                        n:gsub(".", count_m)
                    else
                        n.nodes[1].nodes[1].config.object.string:gsub(".", count_m)
                        end
                    end
                end
            end
        end
    return m
    end
SMODS.Joker{
    key = 'cry_joker', --cryptic joker
    atlas ='jokers',
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 0},
    config = {extra = {gain = 5, mult = 0}},
    loc_vars = function(self, info_queue, center)
        center.ability.extra.mult = calculate_m() * center.ability.extra.gain
        return {vars = {center.ability.extra.gain, center.ability.extra.mult}}
        end,
    calculate = function(self, card, context)
        if context.joker_main then
            card.ability.extra.mult = calculate_m() * card.ability.extra.gain
            return {mult = card.ability.extra.mult}
            end
        end
}

SMODS.Joker{
    key = 'royal_dagger',
    atlas ='jokers',
    rarity = 2,
    cost = 7,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 5, y = 2},
    config = {extra = {}},
    loc_vars = function(self, info_queue, center)
        end,
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            local my_pos = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    my_pos = i
                    break
                    end
                end
            if my_pos and G.jokers.cards[my_pos + 1] and not G.jokers.cards[my_pos + 1].ability.eternal and not G.jokers.cards[my_pos + 1].getting_sliced then
                local sliced_card = G.jokers.cards[my_pos + 1]
                sliced_card.getting_sliced = true -- Make sure to do this on destruction effects
                G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.GAME.joker_buffer = 0
                        card.sell_cost = card.sell_cost + sliced_card.sell_cost
                        card:juice_up(0.8, 0.8)
                        sliced_card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
                        play_sound('slice1', 0.96 + math.random() * 0.08)
                        return true
                        end
                }))
                return {
                    message = localize{type = 'variable', key = 'a_money', vars = {sliced_card.sell_cost}},
                    colour = G.C.MONEY,
                    no_juice = true
                }
                end
            end
        end
}

SMODS.Joker{
    key = 'vip_ticket',
    atlas ='jokers',
    rarity = 2,
    cost = 9,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 1},
    config = {extra = {common_mod = 0}},
    add_to_deck = function(self, card, from_debuff)
        card.ability.extra.common_mod = G.GAME.common_mod
        G.GAME.common_mod = 0
        end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.common_mod = card.ability.extra.common_mod
        end,
}
