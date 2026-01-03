




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
    shop_rate = 1,
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
    key = 'c_gamba',
    set = 'FunCards',
    atlas = 'c_gamba',
    pos = {x = 0, y = 0},
    loc_txt = {
        name = 'Gamba',
        text = {'{C:green}#1# in 2{} chance to gain {C:money}#2#${}'}
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
    key = 'c_spectre',
    set = 'FunCards',
    atlas = 'c_spectre',
    pos = {x = 0, y = 0},
    loc_txt = {
        name = 'Spectre',
        text = {'convert up to #1# selected',
                'cards to most used suit',
                '{C:inactive}(currently:' --{V:1}#2#{C:inactive}){}'
            }
    },
    config = {extra = {max_highlighted = 5}},
    unlocked = true,
    discovered = true,
    cost = 4,
    loc_vars = function(self, info_queue, center)
        --Card:is_suit(suit, bypass_debuff, flush_calc)
        return {vars = {center.ability.max_highlighted--, G.GAME.current_round.main_suit, colours = G.C.SUITS[G.GAME.current_round.main_suit]
        --'Hearts', G.C.SUITS[Hearts]
    }}
    end,
    can_use = function(self,card)
        if G and G.hand then
            if #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.max_highlighted then
                return true
            end
        end
        return false
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                used_tarot:juice_up(0.3, 0.5)
                return true
            end
        }))
        for i = 1, #G.hand.highlighted do
            local percent = 1.15 - (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.cards[i]:flip()
                    play_sound('card1', percent)
                    G.hand.cards[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        local _suit = pseudorandom_element(SMODS.Suits, pseudoseed('sigil'))
        for i = 1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    SMODS.change_base(G.hand.highlighted[i], card.ability.suit_conv)
                    return true
                end
            }))
        end
        for i = 1, #G.hand.highlighted do
            local percent = 0.85 + (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.cards[i]:flip()
                    play_sound('tarot2', percent, 0.6)
                    G.hand.cards[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        delay(0.5)
    end
}
