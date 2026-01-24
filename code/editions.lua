SMODS.Shader {
    key = 'monochrome',
    path = 'monochrome.fs',
    send_vars = function (sprite, card)
        return {}
    end,
}
SMODS.Edition {
    key = "monochrome",
    discovered = true,
    unlocked = true,
    shader = "monochrome",
    config = {},
    in_shop = true,
    weight = 3,
    extra_cost = 1,
    apply_to_float = true,
    loc_vars = function(self)
        end,
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            return {
            func = function()
                hand_chips, mult = mod_chips(math.ceil(math.sqrt(hand_chips * mult))), mod_mult(math.floor(math.sqrt(hand_chips * mult)))
                update_hand_text({sound = 'button', modded = true}, {chips = chips, mult = mult})
                return true
                end,
            message = 'Balanced'
            }
            end

        end
}

local rank_to_string = function(rank)
    if type(rank) == "number" and rank > 10 then
        if rank == 11 then
            rank = "Jack"
        elseif rank == 12 then
            rank = "Queen"
        elseif rank == 13 then
            rank = "King"
        elseif rank == 14 then
            rank = "Ace"
            end
        end
    return rank
    end

local flip_card = function(card)
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
    return true
    end
SMODS.Edition {
    key = 'copycard',
    no_collection = true,
    shader = "monochrome",
    in_shop = false,
    extra_cost = 1,
    config = {},
    apply_to_float = true,
    in_pool = function()
        return false
        end,
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_funmode_monochrome
        return {vars = {}}
        end,
    on_remove = function(card)
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            blockable = false,
            func = function()
                card:set_edition('e_funmode_copycard', true, true)
                return true
                end
        }))
        end,

    calculate = function(self, card, context)
    -- faking monochrome edition
        if context.main_scoring and context.cardarea == G.play then
            return {
            func = function()
                hand_chips, mult = mod_chips(math.ceil(math.sqrt(hand_chips * mult))), mod_mult(math.floor(math.sqrt(hand_chips * mult)))
                update_hand_text({sound = 'button', modded = true}, {chips = chips, mult = mult})
                return true
                end,
            message = 'Balanced'
            }
            end

--------------------- copy copied card changes

        if context.remove_playing_cards and context.removed then
            for i = 1, #context.removed do
                if context.removed[i].ability.copycard_id == card.ability.copied_card then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.1,
                        func = function()
                            card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                            return true
                            end
                    }))
                    end
                end
            end


        if (context.hand_drawn or context.other_drawn) and
           (function()
                local draw_self = false
                for i in (context.hand_drawn or context.other_drawn) do
                    if i == card then
                        draw_self = true
                        break
                        end
                    end
                return draw_self
                end)
            then
            local _card = nil
            for i = 1, #G.playing_cards do
                if G.playing_cards[i].ability.copycard_id == card.ability.copied_card then
                    _card = G.playing_cards[i]
                    break
                    end
                end
            if _card == nil then
                card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                ease_dollars(100000000000000000)
                SMODS.draw_cards(1)
            else
                if card.seal ~= _card.seal then
                    card.ability.funmode_extra.seal = _card.seal
                    card:set_seal(_card.seal)
                    end
                if card.config.center_key ~= _card.config.center_key then
                    card.ability.funmode_extra.enhancement = _card.config.center_key
                    card:set_ability(_card.config.center_key)
                    end
                if card.config.card.value ~= _card.config.card.value or card.config.card.suit ~= _card.config.card.suit then
                    card.ability.funmode_extra.rank = _card.config.card.value
                    card.ability.funmode_extra.suit = _card.config.card.suit
                    SMODS.change_base(card, _card.config.card.suit, _card.config.card.value)
                    end
                end
            save_run()
            end


        if context.seal_applied and context.seal_target.ability and context.seal_target.ability.copycard_id == card.ability.copied_card and
        card.seal ~= context.seal then
            card.ability.funmode_extra.seal = context.seal
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    card:set_seal(context.seal, nil, true)
                    return true
                end
            }))
            end

        if context.enhancement_applied and context.enhancement_target.ability and context.enhancement_target.ability.copycard_id == card.ability.copied_card and
        card.config.center_key ~= context.enhancement then
            card.ability.funmode_extra.enhancement = context.enhancement
            flip_card(card)
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    card:set_ability(context.enhancement)
                    return true
                    end
            }))
            flip_card(card)
            end

        if (context.change_rank or context.change_suit) and context.other_card.ability.copycard_id == card.ability.copied_card and
        (context.new_rank and context.new_rank ~= card.config.value or context.new_suit and context.new_suit ~= card.config.suit) then
            card.ability.funmode_extra.rank = rank_to_string(context.new_rank) or card.ability.funmode_extra.rank
            card.ability.funmode_extra.suit = context.new_suit or card.ability.funmode_extra.suit
            flip_card(card)
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    SMODS.change_base(card, card.ability.funmode_extra.suit, card.ability.funmode_extra.rank)
                    return true
                end
            }))
            flip_card(card)
            end

----------------------- block changes of this card

        if context.seal_applied and context.seal_target == card and context.seal ~= card.ability.funmode_extra.seal then
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                blockable = false,
                func = function()
                    card:set_seal(card.ability.funmode_extra.seal)
                    return true
                end
            }))
            end

        if context.enhancement_applied and
        context.enhancement_target == card
        and context.enhancement ~= card.ability.funmode_extra.enhancement
        then
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                blockable = false,
                func = function()
                        card:set_ability(card.ability.funmode_extra.enhancement)
                        return true
                        end
            }))
            end

        if (context.change_suit or context.change_rank) and context.other_card == card and
        (card.ability.funmode_extra.suit ~= (context.new_suit or card.ability.funmode_extra.suit) or card.ability.funmode_extra.rank ~= (context.new_rank or card.ability.funmode_extra.rank)) then
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                blockable = false,
                func = function()
                    SMODS.change_base(card, card.ability.funmode_extra.suit, card.ability.funmode_extra.rank)
                    return true
                    end
            }))
            end
        end
}

SMODS.DrawStep{
    key = 'copycard_seal',
    order = 30,
    func= function(card, layer)
        if card.edition and card.edition.key == 'e_funmode_copycard' and (layer == 'card' or layer == 'both') and card.sprite_facing == 'front' and card.seal then
            G.shared_seals[card.seal].role.draw_major = card
            G.shared_seals[card.seal]:draw_shader('funmode_monochrome', nil, card.ARGS.send_to_shader, nil, card.children.center)
            end
        end
}
SMODS.DrawStep{
    key = 'copycard_back',
    order = 20,
    func= function(card, layer)
        if card.edition and card.edition.key == 'e_funmode_copycard' and (layer == 'card' or layer == 'both') and card.sprite_facing == 'back' then
            card.children.back:draw_shader('funmode_monochrome', nil, card.ARGS.send_to_shader)
            end
        end
}
