




SMODS.ConsumableType{
    key = 'FunCards',
    collection_rows = {3, 4},
    primary_colour = G.C.EDITION,
    secondary_colour = G.C.DARK_EDITION,
    loc_txt = {
        collection = 'Fun Cards',
        name = 'Fun Card',
        undiscovered = {
            name = 'fun card',
            text = {'undiscovered'}
        }
    },
    shop_rate = 0.1,
}
SMODS.Atlas{
    key = 'c_undiscovered',
    path = 'c_undiscovered.png',
    px = 71,
    py = 95
}
SMODS.UndiscoveredSprite{
    key = 'FunCards',
    atlas = 'c_undiscovered',
    pos = {x = 0, y = 0}
}





SMODS.Atlas{
    key = 'c_gamba',
    path = 'c_gamba.png',
    px = 71,
    py = 95
}
SMODS.Consumable{
    key = 'gamba',
    set = 'FunCards',
    atlas = 'c_gamba',
    pos = {x = 0, y = 0},
    loc_txt = {
        name = 'Gamba',
        text = {'{C:green}#1# in 2{} chance to gain {C:money}$#2#{}'}
    },
    config = {money = 10},
    unlocked = true,
    discovered = true,
    cost = 4,
    loc_vars = function(self, info_queue, center)
        return {vars = {G.GAME.probabilities.normal, center.ability.money}}
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        if pseudorandom('c_gamba') < G.GAME.probabilities.normal/2 then
            ease_dollars(card.ability.money, true)
        end
    end
}

SMODS.Atlas{
    key = 'c_spectre',
    path = 'c_spectre.png',
    px = 71,
    py = 95
}
SMODS.Consumable{
    key = 'spectre',
    set = 'FunCards',
    atlas = 'c_spectre',
    pos = {x = 0, y = 0},
    loc_txt = {
        name = 'Spectre',
        text = {'convert up to #1# selected',
                'cards to most used suit',
                '{C:inactive}(currently: {V:1}#2#{C:inactive}){}'
            }
    },
    config = {extra = {max_highlighted = 3}},
    unlocked = true,
    discovered = true,
    cost = 4,

    main_suit = function()
        --this suit counting is really bad but whatever
        local hearts = 0
        local spades = 0
        local clubs = 0
        local diamonds = 0
        if G.playing_cards then
            for _, playing_card in ipairs(G.playing_cards) do
                if playing_card:is_suit('Hearts', nil, true) then
                   hearts = hearts + 1
                   end
                if playing_card:is_suit('Spades', nil, true) then
                   spades = spades + 1
                   end
                if playing_card:is_suit('Clubs', nil, true) then
                   clubs = clubs + 1
                   end
                if playing_card:is_suit('Diamonds', nil, true) then
                   diamonds = diamonds + 1
                   end
                end
            end
        suitamount = math.max(hearts, spades, clubs, diamonds)
        local mostsuit = ''
        if suitamount == hearts then
           mostsuit = 'Hearts'
        elseif suitamount == spades then
           mostsuit = 'Spades'
        elseif suitamount == clubs then
           mostsuit = 'Clubs'
        else
           mostsuit = 'Diamonds'
           end
        return mostsuit
        end,

    loc_vars = function(self, info_queue, center)
        local suit = self.main_suit()
        return {vars = {center.ability.extra.max_highlighted,
        suit,
        colours = {G.C.SUITS[suit]}
        }}
        end,

    can_use = function(self, card)
        return G and G.hand and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.max_highlighted
        end,

    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        for i = 1, #G.hand.highlighted do
            local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('card1', percent)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        delay(0.2)
        for i = 1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    SMODS.change_base(G.hand.highlighted[i], self.main_suit())
                    return true
                end
            }))
        end
        for i = 1, #G.hand.highlighted do
            local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('tarot2', percent, 0.6)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
        delay(0.5)
        end
}

SMODS.Atlas{
    key = 'c_hallway',
    path = 'c_hallway.png',
    px = 71,
    py = 95
}
SMODS.Consumable{
    key = 'hallway',
    set = 'FunCards',
    atlas = 'c_hallway',
    pos = {x = 0, y = 0},
    loc_txt = {
        name = 'Hallway',
        text = {'create {C:attention}copycard{} of',
                'one selected card'}
    },
    config = {},
    unlocked = true,
    discovered = true,
    cost = 6,
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_funmode_copycard
        return {vars = {}}
    end,
    can_use = function(self, card)
        return G and G.hand and #G.hand.highlighted == 1
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                local _card = copy_card(G.hand.highlighted[1], nil, nil, G.playing_card)
                if not G.hand.highlighted[1].ability.copied_card then
                    if _card.ability.copycard_id then
                        _card.ability.copied_card = G.hand.highlighted[1].ability.copycard_id
                    else
                        G.GAME.funmode_copycard_id = (G.GAME.funmode_copycard_id or 0) + 1
                        G.hand.highlighted[1].ability.copycard_id = (G.GAME.funmode_copycard_id or 0)
                        _card.ability.copied_card = G.GAME.funmode_copycard_id or 0
                        end
                    _card.ability.funmode_extra = {}
                    _card.ability.funmode_extra.rank = G.hand.highlighted[1].config.card.value
                    _card.ability.funmode_extra.suit = G.hand.highlighted[1].config.card.suit
                    _card.ability.funmode_extra.seal = G.hand.highlighted[1].seal
                    _card.ability.funmode_extra.enhancement = G.hand.highlighted[1].config.center_key
                    _card:set_edition('e_funmode_copycard', true, true)
                    end
                _card:add_to_deck()
                G.deck.config.card_limit = G.deck.config.card_limit + 1
                table.insert(G.playing_cards, _card)
                G.hand:emplace(_card)
                _card:start_materialize()
                SMODS.calculate_context({playing_card_added = true, cards = {_card}})
                return true
                end
        }))
        end
}


SMODS.Atlas{
    key = 'c_no_cost',
    path = 'c_no_cost.png',
    px = 71,
    py = 95
}
SMODS.Consumable{
    key = 'no_cost',
    set = 'FunCards',
    atlas = 'c_no_cost',
    pos = {x = 0, y = 0},
    loc_txt = {
        name = 'No Cost Too Great',
        text = {'{C:attention}wins{} the run'}
    },
    unlocked = true,
    discovered = true,
    cost = 999,
    pools = {["Shop"] = true},
    can_use = function(self, card)
        return true
        end,
    use = function(self, card, area, copier)
        end
}
