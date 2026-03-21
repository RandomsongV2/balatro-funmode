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
    pos = {x = 0, y = 0}
}





SMODS.Consumable{
    key = 'gamba',
    set = 'FunCard',
    atlas = 'fun_cards',
    pos = {x = 0, y = 2},
    config = {extra = {min = 1, max = 20}},
    unlocked = true,
    discovered = true,
    cost = 6,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.min, center.ability.extra.max}}
        end,
    can_use = function(self, card)
        return true
        end,
    use = function(self, card, area, copier)
        ease_dollars(pseudorandom('c_gamba', card.ability.extra.min, card.ability.extra.max))
        end
}

SMODS.Consumable{
    key = 'spectre',
    set = 'FunCard',
    atlas = 'fun_cards',
    pos = {x = 1, y = 0},
    config = {extra = {max_highlighted = 4}},
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
        info_queue[#info_queue + 1] = {key = 'funmode_copycard', set = 'Other'}
        info_queue[#info_queue + 1] = G.P_CENTERS.e_funmode_monochrome
    end,
    can_use = function(self, card)
        return G and G.hand and #G.hand.highlighted == 1
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                Funmode.set_monochrome_vars(G.hand.highlighted[1])
                local _card = copy_card(G.hand.highlighted[1], nil, nil, G.playing_card)
                if not G.hand.highlighted[1].ability then G.hand.highlighted[1].ability = {} end
                if not G.hand.highlighted[1].ability.funmode_copycard then
                    if not G.hand.highlighted[1].ability.funmode_copiercard then
                        G.hand.highlighted[1]:add_sticker('funmode_copiercard', true)
                        G.hand.highlighted[1].ability.funmode_copiercard = (G.GAME.funmode_copycard_id or 0)
                        G.GAME.funmode_copycard_id = ((G.GAME.funmode_copycard_id or 0) + 1) .. ''
                    end
                    _card:add_sticker('funmode_copycard', true)
                    _card.ability.funmode_copycard = G.hand.highlighted[1].ability.funmode_copiercard
                end
                _card:set_edition('e_funmode_monochrome')
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
        return args and args.source == "sho" and not G.GAME.won
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
    key = 'fun_soul', --todo: rework so it uses pool instead of what it uses right now
    set = 'FunCard',
    atlas = 'fun_cards',
    pos = {x = 1, y = 1},
    soul_pos = {x = 2, y = 1},
    loc_vars = function(self, info_queue, center)
    end,
    unlocked = true,
    discovered = true,
    cost = 7,
    can_use = function(self, card)
        return G.jokers and #G.jokers.cards < G.jokers.config.card_limit
        end,
    use = function(self, card, area, copier)
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
                    elseif joker == 2 then
                        key = 'j_photograph'
                    elseif joker == 3 then
                        key = 'j_burnt'
                    elseif joker == 4 then
                        key = 'j_luchador'
                    elseif joker == 5 then
                        key = 'j_cartomancer'
                        end
                    name = localize(key, 'funmode_soul_at_home')
                    break
                    end
                end
            end
        SMODS.add_card({key = key, area = G.jokers})
        if name and G.jokers.cards[#G.jokers.cards].config.center_key == key then
            if not G.jokers.cards[#G.jokers.cards].ability.funmode_extra then
                G.jokers.cards[#G.jokers.cards].ability.funmode_extra = {}
                end
            G.jokers.cards[#G.jokers.cards].ability.funmode_extra.name = {name}
            end
        end
}

SMODS.Consumable{
    key = 'color_wheel',
    set = 'FunCard',
    atlas = 'fun_cards',
    pos = {x = 1, y = 2},
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_polychrome
        info_queue[#info_queue + 1] = G.P_CENTERS.e_funmode_monochrome
        end,
    unlocked = true,
    discovered = true,
    cost = 6,
    can_use = function(self, card)
        return G.hand and next(SMODS.Edition:get_edition_cards(G.hand, true))
        end,
    use = function(self, card, area, copier)
        local editionless_cards = SMODS.Edition:get_edition_cards(G.hand, true)
        local eligible_card = pseudorandom_element(editionless_cards, pseudoseed("funmode_color_wheel"))
        local edition = poll_edition('funmode_color_wheel', nil, true, true, {'e_polychrome', 'e_funmode_monochrome'})
        eligible_card:set_edition(edition, true)
        check_for_unlock({type = 'have_edition'})
        end
}

SMODS.Consumable{
    key = 'phonewave',
    set = 'FunCard',
    atlas = 'fun_cards',
    pos = {x = 2, y = 2},
    loc_vars = function(self, info_queue, center)
        return {vars = {G.GAME and G.GAME.funmode and G.GAME.funmode.prev_seed or 'None'}}
        end,
    unlocked = true,
    discovered = true,
    cost = 5,
    can_use = function(self, card)
        return true
        end,
    use = function(self, card, area, copier)
        G.GAME.funmode.prev_seed = G.GAME.pseudorandom.seed
        G.GAME.pseudorandom.seed = generate_starting_seed()
        save_run()
        end
}

SMODS.Consumable{
    key = 'lock_in',
    set = 'FunCard',
    atlas = 'fun_cards',
    pos = {x = 3, y = 2},
    config = {extra = {select = 1}},
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {key = 'eternal', set = 'Other'}
        return {vars = {center.ability.extra.select}}
        end,
    unlocked = true,
    discovered = true,
    cost = 6,
    can_use = function(self, card)
        return G.jokers and #G.jokers.highlighted ~= 0 and #G.jokers.highlighted <= card.ability.extra.select and
        (function()
            for _, c in ipairs(G.jokers.highlighted) do
                if not c.ability.eternal and not c.ability.funmode_true_perishable then
                    return true
                    end
                end
            return false
            end)()
        end,
    use = function(self, card, area, copier)
        for _, c in ipairs(G.jokers.highlighted) do
            if not c.ability.funmode_true_perishable then
                c:add_sticker('eternal', true)
                end
            end
        end
}

SMODS.Consumable{
    key = 'wheel_of_unfortune',
    set = 'FunCard',
    atlas = 'fun_cards',
    pos = {x = 3, y = 1},
    config = {extra = {odds = 4, gain = 15}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.gain, G.GAME.probabilities.normal, card.ability.extra.odds}}
    end,
    unlocked = true,
    discovered = true,
    cost = 6,
    can_use = function(self, card)
        return next(SMODS.Edition:get_edition_cards(G.jokers))
    end,
    use = function(self, card, area, copier)
        ease_dollars(card.ability.extra.gain)
        if pseudorandom('funmode_wheel_of_fortune') < G.GAME.probabilities.normal / card.ability.extra.odds then
            local edition_jokers = SMODS.Edition:get_edition_cards(G.jokers, false)
            local _card = pseudorandom_element(edition_jokers, pseudoseed("funmode_wheel_of_unfortune"))
            _card:set_edition()
        else
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    attention_text({
                        text = 'safe',
                        scale = 1.3,
                        hold = 1.4,
                        major = card,
                        backdrop_colour = G.C.SECONDARY_SET.FunCard,
                        align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and 'tm' or 'cm',
                        offset = {x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and -0.2 or 0},
                        silent = true
                    })
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))
        end
    end,
}


SMODS.Consumable {
    key = 'weakness',
    set = 'FunCard',
    atlas = 'fun_cards',
    pos = {x = 3, y = 0},
    config = {max_highlighted = 3},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.max_highlighted}}
    end,
    unlocked = true,
    discovered = true,
    cost = 6,
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
                    -- SMODS.modify_rank will increment/decrement a given card's rank by a given amount
                    assert(SMODS.modify_rank(G.hand.highlighted[i], -1))
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
    end,
}

SMODS.Consumable{
    key = 'draedon',
    set = 'FunCard',
    atlas = 'fun_cards',
    pos = {x = 0, y = 3},
    unlocked = true,
    discovered = true,
    cost = 8,
    can_use = function(self, card)
        return true
        end,
    use = function(self, card, area, copier)
        G.FUNCS.funmode_draedon_init()
        end
}

SMODS.Consumable{
    key = 'black_rose',
    set = 'FunCard',
    atlas = 'fun_cards',
    pos = {x = 1, y = 3},
    config = {extra = {select = 1}},
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {key = 'funmode_doubled', set = 'Other'}
        info_queue[#info_queue + 1] = {key = 'funmode_true_perishable', set = 'Other'}
        return {vars = {center.ability.extra.select}}
        end,
    unlocked = true,
    discovered = true,
    cost = 6,
    can_use = function(self, card)
        return G.jokers and #G.jokers.highlighted ~= 0 and #G.jokers.highlighted <= card.ability.extra.select and
        (function()
            for _, c in ipairs(G.jokers.highlighted) do
                if not c.ability.eternal then
                    return true
                    end
                end
            return false
            end)()
        end,
    use = function(self, card, area, copier)
        for _, c in ipairs(G.jokers.highlighted) do
            if not c.ability.eternal then
                c:add_sticker('funmode_true_perishable', true)
                c:add_sticker('funmode_doubled', true)
                end
            end
        end
}

SMODS.Consumable{
    key = 'abbie',
    set = 'FunCard',
    atlas = 'fun_cards',
    pos = {x = 2, y = 3},
    config = {extra = {select = 1}},
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_funmode_monochrome
        info_queue[#info_queue + 1] = G.P_CENTERS.e_polychrome
        return {vars = {}}
        end,
    unlocked = true,
    discovered = true,
    cost = 5,
    can_use = function(self, card)
        return ((G.jokers and #G.jokers.highlighted ~= 0 and #G.jokers.highlighted <= card.ability.extra.select) and
        (function() for _, c in ipairs(G.jokers.highlighted) do if c.edition and c.edition.key == 'e_funmode_monochrome' then return true end end return false end)())
        or ((G.hand and #G.hand.highlighted ~= 0 and #G.hand.highlighted <= card.ability.extra.select) and
        (function() for _, c in ipairs(G.hand.highlighted) do if c.edition and c.edition.key == 'e_funmode_monochrome' then return true end end return false end)())
        end,
    use = function(self, card, area, copier)
        if (function() for _, c in ipairs(G.jokers.highlighted) do if c.edition and c.edition.key == 'e_funmode_monochrome' then return true end end return false end)() then
            for _, c in ipairs(G.jokers.highlighted) do
                c:set_edition("e_polychrome")
                end
        else
            for _, c in ipairs(G.hand.highlighted) do
                c:set_edition("e_polychrome")
                end
            end
        end
}

SMODS.Consumable{
    key = 'thornring',
    set = 'FunCard',
    atlas = 'fun_cards',
    pos = {x = 3, y = 3},
    config = {extra = {select = 1}},
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {key = 'funmode_controlled', set = 'Other'}
        return {vars = {center.ability.extra.select}}
        end,
    unlocked = true,
    discovered = true,
    cost = 6,
    in_pool = function(self, args)
        return false --todo controlled sticker
    end,
    can_use = function(self, card)
        return G.jokers and #G.jokers.highlighted ~= 0 and #G.jokers.highlighted <= card.ability.extra.select and
        (function()
            for _, c in ipairs(G.jokers.highlighted) do
                if not c.ability.funmode_controlled then
                    return true
                    end
                end
            return false
            end)()
        end,
    use = function(self, card, area, copier)
        for _, c in ipairs(G.jokers.highlighted) do
            c:add_sticker('funmode_controlled', true)
        end
    end
}
