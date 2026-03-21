SMODS.Atlas{
    key = 'stickers',
    path = 'stickers.png',
    px = 71,
    py = 95
}
SMODS.Sticker {
    key = "true_perishable",
    badge_colour = HEX 'aaaae7',
    atlas = 'stickers',
    pos = {x = 0, y = 0},
    rate = 0,
    should_apply = function(self, card, center, area, bypass_roll)
        return false
    end,
    apply = function(self, card, val)
        card.ability[self.key] = val
        if card.ability[self.key] then card.sell_cost = 0 end
    end,
    calculate = function(self, card, context)
        if context.end_of_round then
            if card.ability.hands_played_at_create ~= G.GAME.hands_played or card.area ~= G.jokers then
                card:start_dissolve({HEX("aaaaaa")}, nil, 1.6)
                end
            end
        end
}

local function multiply_table(table, mult)
    if type(table) == 'table' then
        for i, v in pairs(table) do --ipairs dont work here for some reason
            table[i] = multiply_table(v, mult)
            end
        return table
    elseif type(table) == 'number' then
        return table * mult
    else
        return table
        end
    end
SMODS.Sticker {
    key = "doubled",
    badge_colour = HEX 'e39448',
    atlas = 'stickers',
    pos = {x = 1, y = 0},
    rate = 0,
    should_apply = function(self, card, center, area, bypass_roll)
        return false
    end,
    apply = function(self, card, val)
        if not card.ability[self.key] and val then 
            card.ability[self.key] = val
            card.ability.extra = multiply_table(card.ability.extra, 2)
            card.ability.t_mult = (card.ability.t_mult or 0) * 2
            card.ability.t_chips = (card.ability.t_chips or 0) * 2
            card.ability.mult = (card.ability.mult or 0) * 2
            card.ability.chips = (card.ability.chips or 0) * 2
        elseif card.ability[self.key] and not val then 
            card.ability[self.key] = val
            card.ability.extra = multiply_table(card.ability.extra, 0.5)
            card.ability.t_mult = (card.ability.t_mult or 0) / 2
            card.ability.t_chips = (card.ability.t_chips or 0) / 2
            card.ability.mult = (card.ability.mult or 0) / 2
            card.ability.chips = (card.ability.chips or 0) / 2
        end
    end,
    calculate = function(self, card, context)
    end
}

SMODS.Sticker {
    key = "controlled", --todo add thornring in pool after coding this sticker
    badge_colour = HEX 'ea3939',
    atlas = 'stickers',
    pos = {x = 2, y = 0},
    rate = 0,
    should_apply = function(self, card, center, area, bypass_roll)
        return false
    end,
    apply = function(self, card, val)
        card.ability[self.key] = val
    end,
    calculate = function(self, card, context)
        if context.initial_scoring_step and card and card:can_calculate() then
            local ret = {}
            if G.P_CENTERS[card.config.center_key] and G.P_CENTERS[card.config.center_key].calculate then
                ret = G.P_CENTERS[card.config.center_key].calculate(card, card, Funmode.context) or {}
            else
                ret = (Funmode.forcetrigger_vanilla(card, Funmode.context)).jokers
                for i, v in ipairs(card:calculate_joker(Funmode.context) or {}) do
                    ret[i] = v
                end
            end
            for i, v in ipairs(card:calculate_rental(Funmode.context) or {}) do
                ret[i] = v
            end
            for i, v in ipairs(card:calculate_perishable(Funmode.context) or {}) do
                ret[i] = v
            end
            return ret
        end
    end
}

local flip_card = function(card)
    if card then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.15,
            func = function()
                card:flip()
                play_sound('card1', 1.15)
                card:juice_up(0.3, 0.3)
                return true
                end
        }))
    end
end


SMODS.Sticker {
    key = 'copiercard',
    badge_colour = HEX 'c6c6c6',
    atlas = 'stickers',
    pos = {x = 0, y = 1},
    rate = 0,
    no_collection = true,
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {set = 'Other', key = 'funmode_copycard'}
        end,
    in_pool = function()
        return false
        end,
    apply = function(self, card, val)
        if not Funmode.ignore_change_context then
            if not val then
                for _, c in ipairs(G.playing_cards) do
                    if c.ability and card.ability and c.ability.funmode_copycard == card.ability[self.key] then
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.05,
                            func = function()
                                c:remove()
                                return true
                                end
                        }))
                    end
                end
            end
        else
            Funmode.ignore_change_context = nil
        end
        card.ability[self.key] = val
    end,
    calculate = function(self, card, context)
        if context.funmode_seal_applied and context.funmode_seal_target == card then
            for _, c in ipairs(G.playing_cards) do
                if c.ability and card.ability and c.ability.funmode_copycard == card.ability.funmode_copiercard then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.05,
                        func = function()
                            Funmode.ignore_change_context = true
                            c:set_seal(context.funmode_seal)
                            return true
                            end
                    }))
                end
            end
        end
        if context.funmode_base_applied and context.funmode_base_target == card then
            for _, c in ipairs(G.hand.cards) do
                if c.ability and card.ability and c.ability.funmode_copycard == card.ability.funmode_copiercard then
                    flip_card(c)
                end
            end
            for _, c in ipairs(G.playing_cards) do
                if c.ability and card.ability and c.ability.funmode_copycard == card.ability.funmode_copiercard then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.05,
                        func = function()
                            Funmode.ignore_change_context = true
                            SMODS.change_base(c, context.funmode_suit, context.funmode_rank)
                            return true
                            end
                    }))
                end
            end
            for _, c in ipairs(G.hand.cards) do
                if c.ability and card.ability and c.ability.funmode_copycard == card.ability.funmode_copiercard then
                    flip_card(c)
                end
            end
        end
        if context.funmode_enhancement_applied and context.funmode_enhancement_target == card then
            for _, c in ipairs(G.hand.cards) do
                if c.ability and card.ability and c.ability.funmode_copycard == card.ability.funmode_copiercard then
                    flip_card(c)
                end
            end
            for _, c in ipairs(G.playing_cards) do
                if c.ability and card.ability and c.ability.funmode_copycard == card.ability.funmode_copiercard then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.05,
                        func = function()
                            Funmode.ignore_change_context = true
                            c:set_ability(context.funmode_enhancement)
                            return true
                            end
                    }))
                end
            end
            for _, c in ipairs(G.hand.cards) do
                if c.ability and card.ability and c.ability.funmode_copycard == card.ability.funmode_copiercard then
                    flip_card(c)
                end
            end
        end
    end
}
SMODS.Sticker {
    key = 'copycard',
    badge_colour = HEX 'c6c6c6',
    atlas = 'stickers',
    pos = {x = 1, y = 1},
    rate = 0,
    loc_vars = function(self, info_queue, card)
        if card and card.edition and card.edition.key == 'e_funmode_monochrome' then
            return {key = 'funmode_copycard_monochrome'}
        end
    end,
    in_pool = function()
        return false
        end,
    apply = function(self, card, val)
        card.ability[self.key] = val
    end,
    calculate = function(self, card, context)
        if context.funmode_seal_applied and context.funmode_seal_target == card then
            Funmode.ignore_change_context = true
            card:set_seal(context.funmode_seal_old)
        end
        if context.funmode_base_applied and context.funmode_base_target == card then
            flip_card(card)
            Funmode.ignore_change_context = true
            SMODS.change_base(card, context.funmode_suit_old, context.funmode_rank_old)
            flip_card(card)
        end
        if context.funmode_enhancement_applied and context.funmode_enhancement_target == card then
            flip_card(card)
            Funmode.ignore_change_context = true
            card:set_ability(context.funmode_enhancement_old)
            flip_card(card)
        end
    end
}
local copy_card_ref = copy_card
function copy_card(card, args)
    local ref = copy_card_ref(card, args)
    if ref.ability and ref.ability.funmode_copiercard then
        Funmode.ignore_change_context = true
        ref:remove_sticker('funmode_copiercard', true)
    end
    return ref
end
local dissolve_ref = Card.start_dissolve
function Card:start_dissolve(args)
    if self.ability and self.ability.funmode_copiercard then
        for _, c in ipairs(G.playing_cards) do
            if c.ability and c.ability.funmode_copycard == self.ability.funmode_copiercard then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.05,
                    func = function()
                        dissolve_ref(c, args)
                        return true
                        end
                }))
            end
        end
    end
    return dissolve_ref(self, args)
end
local shatter_ref = Card.shatter
function Card:shatter(args)
    if self.ability and self.ability.funmode_copiercard then
        for _, c in ipairs(G.playing_cards) do
            if c.ability and c.ability.funmode_copycard == self.ability.funmode_copiercard then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.05,
                    func = function()
                        shatter_ref(c, args)
                        return true
                        end
                }))
            end
        end
    end
    return shatter_ref(self, args)
end
local remove_ref = Card.remove
function Card:remove(args)
    if self.ability and self.ability.funmode_copiercard then
        for _, c in ipairs(G.playing_cards) do
            if c.ability and c.ability.funmode_copycard == self.ability.funmode_copiercard then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.05,
                    func = function()
                        remove_ref(c, args)
                        return true
                        end
                }))
            end
        end
    end
    return remove_ref(self, args)
end
function G.FUNCS.funmode_check_for_originals()
    local copycards = {}
    local copiercards = {}
    for _, c in ipairs(G.playing_cards) do
        if c.ability then
            if c.ability.funmode_copycard then
                copycards[#copycards + 1] = c.ability.funmode_copycard
            elseif c.ability.funmode_copiercard then
                copiercards[c.ability.funmode_copiercard] = true
            end
        end
    end
    for _, v in pairs(copycards) do
        if not copiercards[v] then
            for _, c in ipairs(G.playing_cards) do
                if c.ability and c.ability.funmode_copycard == v then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.05,
                        func = function()
                            c:remove()
                            return true
                            end
                    }))
                end
            end
        end
    end
end

SMODS.DrawStep{
    key = 'copycard_seal',
    order = 30,
    func= function(card, layer)
        if card.ability and card.ability.funmode_copycard and (layer == 'card' or layer == 'both') and card.sprite_facing == 'front' and card.seal then
            G.shared_seals[card.seal].role.draw_major = card
            G.shared_seals[card.seal]:draw_shader('funmode_monochrome', nil, card.ARGS.send_to_shader, nil, card.children.center)
            end
        end
}
SMODS.DrawStep{
    key = 'copycard_back',
    order = 20,
    func= function(card, layer)
        if card.ability and card.ability.funmode_copycard and (layer == 'card' or layer == 'both') and card.sprite_facing == 'back' then
            card.children.back:draw_shader('funmode_monochrome', nil, card.ARGS.send_to_shader, nil, card.children.center)
            end
        end
}
