SMODS.ConsumableType{
    key = 'FunCard',
    collection_rows = {3, 4},
    primary_colour = G.C.EDITION,
    secondary_colour = G.C.DARK_EDITION,
    shop_rate = 0.5,
    loc_txt = {
            collection = 'Fun Cards',
            name = 'Fun Card',
            undiscovered = {
                name = 'fun card',
                text = {'undiscovered'}
            }
        },
}
SMODS.Atlas{
    key = 'fun_cards',
    path = 'fun_cards.png',
    px = 71,
    py = 95
}
SMODS.UndiscoveredSprite{
    key = 'FunCard',
    atlas = 'fun_cards',
    pos = {x = 0, y = 2}
}





SMODS.Consumable{
    key = 'gamba',
    set = 'FunCard',
    atlas = 'fun_cards',
    pos = {x = 0, y = 0},
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

SMODS.Consumable{
    key = 'spectre',
    set = 'FunCard',
    atlas = 'fun_cards',
    pos = {x = 1, y = 0},
    config = {extra = {max_highlighted = 3}},
    unlocked = true,
    discovered = true,
    cost = 4,

    main_suit = function()
        local suits = {}
        if G.playing_cards then
            for _, playing_card in ipairs(G.playing_cards) do
                if not SMODS.has_no_suit(playing_card) then
                    suits[playing_card.config.card.suit] = (suits[playing_card.config.card.suit] or 0) + 1
                    end
                end
            end
        local mostsuit = "Spades"
        local mostsuit_amount = 0
        for key, number in pairs(suits) do
            if number > mostsuit_amount then
                mostsuit_amount = number
                mostsuit = key
                end
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

SMODS.Consumable{
    key = 'hallway',
    set = 'FunCard',
    atlas = 'fun_cards',
    pos = {x = 2, y = 0},
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
                        G.GAME.funmode.copycard_id = (G.GAME.funmode.copycard_id or 0) + 1
                        G.hand.highlighted[1].ability.copycard_id = (G.GAME.funmode.copycard_id or 0)
                        _card.ability.copied_card = G.GAME.funmode.copycard_id or 0
                        end
                    _card.ability.funmode_extra = {}
                    _card.ability.funmode_extra.rank = G.hand.highlighted[1].config.card.value
                    _card.ability.funmode_extra.suit = G.hand.highlighted[1].config.card.suit
                    _card.ability.funmode_extra.seal = G.hand.highlighted[1].seal
                    _card.ability.funmode_extra.enhancement = G.hand.highlighted[1].config.center_key
                    _card:set_edition('e_funmode.copycard', true, true)
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

SMODS.Consumable{
    key = 'no_cost',
    set = 'FunCard',
    atlas = 'fun_cards',
    pos = {x = 0, y = 1},
    loc_vars = function(self, info_queue, center)
    end,
    unlocked = true,
    discovered = true,
    cost = 999,
    in_pool = function(self, args)
        return args and args.source == "shop"
        end,
    can_use = function(self, card)
        return card.sell_cost > 300
        end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            blocking = false,
            func = function()
                win_game()
                G.GAME.won = true
                return true
            end
        }))
        end
}

SMODS.Consumable{
    key = 'fun_soul',
    set = 'FunCard',
    atlas = 'fun_cards',
    pos = {x = 1, y = 1},
    soul_pos = {x = 2, y = 1},
    loc_vars = function(self, info_queue, center)
    end,
    unlocked = true,
    discovered = true,
    cost = 8,
    in_pool = function(self, args)
        return true
        end,
    can_use = function(self, card)
        return G.jokers and #G.jokers.cards < G.jokers.config.card_limit
        end,
    use = function(self, card, area, copier)
    -- todo: change names of spawned jokers for something like 'Triboulet at home'
        local _list = {}
        if #SMODS.find_card('j_glass') > 0 then
            _list[1] = true
            end
        if #SMODS.find_card('j_photograph') > 0 then
            _list[2] = true
            end
        if #SMODS.find_card('j_burnt') > 0 then
            _list[3] = true
            end
        if #SMODS.find_card('j_luchador') > 0 then
            _list[4] = true
            end
        if #SMODS.find_card('j_cartomancer') > 0 then
            _list[5] = true
            end
        local key = ''
        local name = nil
        if _list[1] and _list[2] and _list[3] and _list[4] and _list[5] then
            key = 'j_joker'
        else
            while key == '' do
                local joker = pseudorandom("funmode_fun_soul", 1, 5)
                if not _list[joker] then
                    if joker == 1 then
                        key = 'j_glass'
                        name = "Canio At Home"
                    elseif joker == 2 then
                        key = 'j_photograph'
                        name = "Triboulet At Home"
                    elseif joker == 3 then
                        key = 'j_burnt'
                        name = "Yorick At Home"
                    elseif joker == 4 then
                        key = 'j_luchador'
                        name = "Chikot At Home"
                    elseif joker == 5 then
                        key = 'j_cartomancer'
                        name = "Perkeo At Home"
                        end
                    break
                    end
                end
            end
        SMODS.add_card({key = key, area = G.jokers})
        if name and G.jokers.cards[#G.jokers.cards].config.center_key == key then
            if not G.jokers.cards[#G.jokers.cards].ability.funmode_extra then
                G.jokers.cards[#G.jokers.cards].ability.funmode_extra = {}
                end
            G.jokers.cards[#G.jokers.cards].ability.funmode_extra.name = name
            end
        end
}
