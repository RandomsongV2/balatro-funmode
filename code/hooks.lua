local ref_1 = Card.stop_drag
function Card:stop_drag()
    ref = ref_1(self)
    SMODS.calculate_context({card_released = self})
    return ref
    end
