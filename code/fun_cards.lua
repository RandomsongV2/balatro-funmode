




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
