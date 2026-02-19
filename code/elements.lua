SMODS.ConsumableType{
    key = 'elements',
    collection_rows = {5, 4},
    primary_colour = HEX('ffdc8a'),
    secondary_colour = HEX('b19c72'),
    shop_rate = 0.0,
    loc_txt = {
            collection = 'Elements',
            name = 'Element',
            undiscovered = {
                name = 'Element',
                text = {'undiscovered'}
            }
        },
}
SMODS.Atlas{
    key = 'elements',
    path = 'elements.png',
    px = 52,
    py = 52
}
SMODS.UndiscoveredSprite{
    key = 'elements',
    atlas = 'elements',
    pos = {x = 0, y = 0}
}


SMODS.Consumable{
    key = 'water',
    set = 'elements',
    atlas = 'elements',
    pos = {x = 0, y = 1},
    display_size = {w = 70, h = 70},
    unlocked = true,
    discovered = true,
    cost = 2,
    can_use = function(self, card)
        return false
        end,
}


SMODS.Consumable{
    key = 'acid',
    set = 'elements',
    atlas = 'elements',
    pos = {x = 1, y = 0},
    display_size = {w = 70, h = 70},
    config = {extra = {destroy = 4}},
    unlocked = true,
    discovered = true,
    cost = 5,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.destroy}}
        end,
    can_use = function(self, card)
        return #G.hand.cards ~= 0
        end,
    use = function(self, card, area, copier)
        local destroyed_cards = {}
        local temp_hand = {}

        for _, playing_card in ipairs(G.hand.cards) do temp_hand[#temp_hand + 1] = playing_card end
        table.sort(temp_hand,
            function(a, b)
                return not a.playing_card or not b.playing_card or a.playing_card < b.playing_card
            end
        )

        pseudoshuffle(temp_hand, pseudoseed('funmode_acid'))

        for i = 1, card.ability.extra.destroy do destroyed_cards[#destroyed_cards + 1] = temp_hand[i] end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                SMODS.destroy_cards(destroyed_cards)
                return true
            end
        }))
        delay(0.5)
    end,
}


SMODS.Consumable{
    key = 'teleportatium',
    set = 'elements',
    atlas = 'elements',
    pos = {x = 2, y = 0},
    display_size = {w = 70, h = 70},
    config = {extra = {select = 4}},
    unlocked = true,
    discovered = true,
    cost = 5,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.select}}
        end,
    can_use = function(self, card)
        return G.hand and #G.hand.highlighted ~= 0 and #G.hand.highlighted <= card.ability.extra.select
        end,
    use = function(self, card, area, copier)
        local cards = G.hand.highlighted -- cards selected
        Funmode.debug = {extra = {}, hand_count, cards}
        for k, i in ipairs(G.hand.highlighted) do
            draw_card(G.hand, G.deck, k*100/#cards, 'down', nil, i,  0.08)
        end
        SMODS.draw_cards(#cards)
        end
}


SMODS.Consumable{
    key = 'teleportatium_unstable',
    set = 'elements',
    atlas = 'elements',
    pos = {x = 3, y = 0},
    display_size = {w = 70, h = 70},
    config = {extra = {remove = 4}},
    unlocked = true,
    discovered = true,
    cost = 5,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.remove}}
        end,
    can_use = function(self, card)
        return #G.hand.cards ~= 0
        end,
    use = function(self, card, area, copier)
        local removed_cards = {}
        local temp_hand = {}

        for _, playing_card in ipairs(G.hand.cards) do temp_hand[#temp_hand + 1] = playing_card end
        table.sort(temp_hand,
            function(a, b)
                return not a.playing_card or not b.playing_card or a.playing_card < b.playing_card
            end
        )

        pseudoshuffle(temp_hand, pseudoseed('funmode_acid'))

        for i = 1, card.ability.extra.remove do removed_cards[#removed_cards + 1] = temp_hand[i] end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                for k, i in ipairs(removed_cards) do
                    draw_card(G.hand, G.deck, k*100/#removed_cards, 'down', nil, i,  0.08)
                end
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                for i = 1, #removed_cards do
                    local c = pseudorandom('funmode_unstable_tele', 1, #G.discard.cards + #G.deck.cards)
                    if c > #G.discard.cards then
                        draw_card(G.deck, G.hand, i*100/#removed_cards, 'up', nil, G.deck.cards[c - #G.discard.cards],  0.08)
                    else
                        draw_card(G.discard, G.hand, i*100/#removed_cards, 'up', nil, G.discard.cards[c],  0.08)
                    end
                end
                return true
            end
        }))
    end,
}


SMODS.Consumable{
    key = 'midas',
    set = 'elements',
    atlas = 'elements',
    pos = {x = 4, y = 0},
    display_size = {w = 70, h = 70},
    config = {extra = {}},
    unlocked = true,
    discovered = true,
    cost = 12,
    loc_vars = function(self, info_queue, center)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_gold
        return {vars = {center.ability.extra.select}}
        end,
    can_use = function(self, card)
        return #G.hand.cards ~= 0
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
        for i = 1, #G.hand.cards do
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
        delay(0.2)
        for i = 1, #G.hand.cards do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    G.hand.cards[i]:set_ability(G.P_CENTERS.m_gold)
                    return true
                end
            }))
        end
        for i = 1, #G.hand.cards do
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
        delay(0.4)
    end
}


SMODS.Consumable{
    key = 'poly',
    set = 'elements',
    atlas = 'elements',
    pos = {x = 1, y = 1},
    display_size = {w = 70, h = 70},
    config = {extra = {select = 4}},
    unlocked = true,
    discovered = true,
    cost = 5,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.select}}
        end,
    can_use = function(self, card)
        return G.hand and #G.hand.highlighted ~= 0 and #G.hand.highlighted <= card.ability.extra.select
        end,
    use = function(self, card, area, copier)
        Funmode.allow_negative_ranks = true

        for _, c in ipairs(G.hand.highlighted) do
            c:set_edition()
            c:set_seal()
        end
        assert(SMODS.modify_rank(G.hand.highlighted[i]))
        assert(SMODS.modify_suit(G.hand.highlighted[i]))

        Funmode.allow_negative_ranks = false
        end
}
