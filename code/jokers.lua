SMODS.Atlas{
    key = 'joke',
    path = 'joke.png',
    px = 71,
    py = 95
}
SMODS.Joker{
    key = 'j_joke',
    loc_txt = {
        name = 'Joke',
        text = {
            'lose {C:money}$#1#{}',
            'when blind is selected,',
            'gain {C:money}$#2#{}',
            'at end of round'
            }
        },
    config = {extra = {loss = 10, gain = 14}},
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.loss, center.ability.extra.gain}}
        end,
    atlas = 'joke',
    rarity = 3,
    cost = 10,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 0},
    calculate = function(self, card, context)
        if context.setting_blind then
            ease_dollars(-10)
            end
         end,
    calc_dollar_bonus = function(self, card)
        return 14
        end
}

SMODS.Atlas{
    key = 'handcuffs',
    path = 'handcuffs.png',
    px = 71,
    py = 95
}
SMODS.Joker{
    key = 'j_handcuffs',
    loc_txt = {
        name = 'Handcuffs',
        text = {
            'when blind is selected',
            'set {C:blue}hands{} to 2',
            'and gain #1# {C:red}discards{}'
        },
    },
    atlas ='handcuffs',
    rarity = 2,
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 0},
    config = {extra = {discards = 2}},
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.discards}}
        end,
    calculate = function(self, card, context)
        if context.setting_blind then
            return {
                func = function()
                    G.E_MANAGER:add_event(Event({
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

SMODS.Atlas{
    key = 'gamba',
    path = 'gamba.png',
    px = 71,
    py = 95
}
SMODS.Joker{
    key = 'j_gamba',
    loc_txt = {
        name = 'Gambling',
        text = {
            'create a {C:attention}Wheel of Fortune{}',
            'at end of round,',
            '{C:green}#1# in 6{} chance to {C:red,E:2}self destruct{}',
            'when blind is selected'
        },
    },
    atlas ='gamba',
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    pixel_size = { h = 55 },
    pos = {x = 0, y = 0},
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

SMODS.Atlas{
    key = 'soul_joker',
    path = 'soul_joker.png',
    px = 71,
    py = 95
}
SMODS.Joker{
    key = 'j_soul',
    loc_txt = {
        name = 'Soul joker',
        text = {
            'After {C:attention}#2#{} rounds',
            'sell this card to',
            'Create {C:legendary}Legendary{} joker',
            '{C:inactive}(Currently{}{C:attention} #1#{}{C:inactive}/#2#){}'
        },
    },
    atlas ='soul_joker',
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true, --lol
    perishable_compat = true, --haha
    pos = {x = 0, y = 0},
    soul_pos = {x = 1, y = 0},
    config = {extra = {rounds_played = 0, rounds_required = 7}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.rounds_played, card.ability.extra.rounds_required}}
        end,
    calculate = function(self, card, context)
            if context.end_of_round and context.cardarea == G.jokers then
                card.ability.extra.rounds_played = card.ability.extra.rounds_played + 1
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

SMODS.Atlas{
    key = 'mimic-detector',
    path = 'mimic-detector.png',
    px = 71,
    py = 95
}
SMODS.Joker{
    key = 'mimic_detector',
    loc_txt = {
        name = 'Mimic detector v4',
        text = {
            '{C:red,X:black,E:2}No{}'
        },
    },
    atlas ='mimic-detector',
    rarity = 3,
    cost = 0,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 0},
    pixel_size = {w = 42, h = 65},
    calculate = function(self, card, context)
            if context.end_of_round or context.setting_blind or context.joker_main then
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
}

--todo
SMODS.Atlas{
    key = 'Manfred_von_karma',
    path = 'Manfred_Von_Karma.png',
    px = 71,
    py = 95
}
SMODS.Joker{
    key = 'manfred_von_karma',
    loc_txt = {
        name = 'Manfred Von Karma',
        text = {
            'creates chosen joker',
            'until end of a round',
            'cant create same joker twice',
            'cant create legendary',
            '{C:inactive}doesnt work{}'
        },
    },
    atlas ='Manfred_von_karma',
    rarity = 4,
    cost = 20,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 0},
    soul_pos = {x = 1, y = 0},
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

SMODS.Atlas{
    key = 'Franziska_von_karma',
    path = 'Franziska_Von_Karma.png',
    px = 71,
    py = 95
}
SMODS.Joker{
    key = 'Fransiska_von_karma',
    loc_txt = {
        name = 'Franziska Von Karma',
        text = {
            'Creates {C:attention}The Fool{}',
            'on {C:attention}first{} or {C:attention}last{} hand of round',
            'played {C:attention}face{} cards give',
            '{X:mult,C:white} X#1# {} Mult when scored'
        },
    },
    atlas ='Franziska_von_karma',
    rarity = 4,
    cost = 9,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 0},
    soul_pos = {x = 1, y = 0},
    config = {extra = {x_mult = 0.5}},
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = G.P_CENTERS.c_fool
        return {vars = {center.ability.extra.x_mult}}
        end,
    calculate = function(self, card, context)
        if G.GAME.current_round.hands_played == 0 or G.GAME.current_round.hands_left == 0 then
            if context.before and not context.blueprint then
                if G.consumeables.config.card_limit > #G.consumeables.cards then
                    local new_card = create_card("Tarot", G.consumeables, nil, nil, nil, nil, "c_fool")
                    new_card:add_to_deck()
                    G.consumeables:emplace(new_card)
                    return true
                    end
                end
            end
        if context.individual and context.cardarea == G.play and not context.blueprint then
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

SMODS.Atlas{
    key = 'DOG',
    path = 'DOG.png',
    px = 71,
    py = 95
}
SMODS.Joker{
    key = 'DOG',
    loc_txt = {
        name = 'The Devouver Of Gods',
        text = {
            'when {C:attention}Blind{} is selected',
            '{C:red,E:2}destroy{} all jokers and gain',
            'their {C:chips}chips{}, {C:mult}mult{} and {X:mult,C:white}xmult{}',
            '{C:inactive}(currently {} {C:chips}+#1#{} {C:inactive} / {} {C:mult}+#2#{} {C:inactive} / {} {X:mult,C:white}X#3#{} {C:inactive}){}',
        },
    },
    atlas ='DOG',
    rarity = 4,
    cost = 20,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 0},
    soul_pos = {x = 1, y = 0},
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
                    end

                    if selected.ability.mult ~= nil and selected.ability.mult ~= 0 then
                        amult = amult + selected.ability.mult
                    elseif type(selected.ability.extra) == "table" and selected.ability.extra.mult ~= nil and selected.ability.extra.mult ~= 0 then
                        amult = amult + selected.ability.extra.mult
                    elseif selected.ability.t_mult ~= nil and selected.ability.t_mult ~= 0 then
                        amult = amult + selected.ability.t_mult
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

SMODS.Atlas{
    key = 'twin',
    path = 'twins.png',
    px = 71,
    py = 95
}
SMODS.Joker{
    key = 'j_twin',
    loc_txt = {
        name = 'Twin',
        text = {
            'Gains {X:mult,C:white}X0.5{} mult for each Twin',
            'can appear multiple times',
            '(currently {X:mult,C:white} X#1# {} mult)'
        },
    },
    atlas ='twin',
    rarity = 1,
    cost = 5,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    allow_duplicates = true,
    pos = {x = 0, y = 0},
    config = {extra = {x_mult = 1, sprite = 0, mult_scaling = 0.5}},
    --pseudorandom('twinsprite') <= 0.5 then return 0 else return 1
    calculate = function(self, card, context)
        if G.STAGE == G.STAGES.RUN then
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.name == 'twin' and G.jokers.cards[i] ~= self then self.ability.extra.x_mult = self.ability.extra.x_mult + 0.5
                end
            end
        end
    end,
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = G.P_CENTERS.j_twin
        return {vars = {center.ability.extra.x_mult}}
    end
}

SMODS.Atlas{
    key = 'YTTL',
    path = 'Placeholder.png',
    px = 71,
    py = 95
}
SMODS.Joker{
    key = 'j_YTTL',
    loc_txt = {
        name = 'Your Taking Too Long',
        text = {
            'gain {C:money}$#1#{} at end of round',
            'increase payout by {C:money}$#2#{} when',
            'no {C:blue}hands{} or {C:red}discards{} left',
        },
    },
    atlas ='YTTL',
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 0},
    config = {extra = {payout = 1, scaling = 1, allowed = true}},
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.payout, center.ability.extra.scaling}}
        end,
    calculate = function(self, card, context)
        if context.setting_blind then
            card.ability.extra.allowed = true
            end
        if context.end_of_round and G.GAME.current_round.hands_left == 0 and G.GAME.current_round.discards_left == 0 and card.ability.extra.allowed then
            card.ability.extra.allowed = false
            card.ability.extra.payout = card.ability.extra.payout + card.ability.extra.scaling
            end
        end,
    calc_dollar_bonus = function(self, card)
        return card.ability.extra.payout
        end
}

SMODS.Atlas{
    key = 'v1',
    path = 'Placeholder.png',
    px = 71,
    py = 95
}
SMODS.Joker{
    key = 'j_v1',
    loc_txt = {
        name = 'V1',
        text = {
            'when hand played',
            'destroy middle card',
            '{V:1}Clubs{} excluded',
        },
    },
    atlas ='v1',
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 0},
    loc_vars = function(self, info_queue, center)
        return {vars = {colours = {HEX('008ee6')}}}
        end,
    calculate = function(self, card, context)
        if context.destroy_card then
            local mid = (#context.cardarea - ((#context.cardarea + 1) % 2)) / 2
            --local card = context.cardarea[mid]
            return {remove = true} --and context.destroy_card == card}
            end
        end
}

SMODS.Atlas{
    key = 'sloth',
    path = 'sloth.png',
    px = 71,
    py = 95
}
SMODS.Joker{
    key = 'j_slothful',
    loc_txt = {
        name = 'Slothful Joker',
        text = {
            'gives {X:mult,C:white}X#1#{} mult',
            'forces game speed to {C:attention}0.5{}'
            }
        },
    config = {extra = {xmult = 2}},
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.xmult}}
        end,
    atlas = 'sloth',
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 0},
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
