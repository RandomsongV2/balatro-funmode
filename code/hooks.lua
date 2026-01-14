local stop_drag_ref = Card.stop_drag
function Card:stop_drag()
    ref = stop_drag_ref(self)
    SMODS.calculate_context({card_released = true, released_card = self})
    return ref
    end

local set_edition_ref = Card.set_edition
function Card:set_edition(edition, immediate, silent)
    ref = set_edition_ref(self, edition, immediate, silent)
    SMODS.calculate_context({edition_applied = true, edition_target = self, edition = edition})
    return ref
    end

local set_seal_ref = Card.set_seal
function Card:set_seal(seal, immediate, silent)
    ref = set_seal_ref(self, seal, immediate, silent)
    SMODS.calculate_context({seal_applied = true, seal_target = self, seal = seal})
    return ref
    end

local set_ability_ref = Card.set_ability
function Card:set_ability(enhancement, initial, delay_sprites)
    ref = set_ability_ref(self, enhancement, initial, delay_sprites)
    SMODS.calculate_context({enhancement_applied = true, enhancement_target = self, enhancement = enhancement})
    return ref
    end

local copy_card_ref = copy_card
function copy_card(card, args)
    ref = copy_card_ref(card, args)
    if ref.ability and ref.ability.copycard_id then
        ref.ability.copycard_id = nil
        end
    return ref
    end
