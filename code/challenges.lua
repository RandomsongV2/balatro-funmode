--SMODS.Challenge {
--    key = 'dark_souls',
--    rules = {
--        custom = {
--            {id = 'funmode_legendary_always'},
--            {id = 'scaling', value = 5}
--        },
--    },
--    jokers = {},
--    restrictions = {
--        banned_cards = {}
--    }
--}

SMODS.Challenge {
    key = 'delivery_1',
    rules = {
        custom = {
            {id = 'funmode_ice_cream_delivery'}
        },
    },
    jokers = {
        {id = 'j_ice_cream', edition = 'negative'}
    },
    restrictions = {
        banned_cards = {}
    }
}

--SMODS.Challenge {
--    key = 'delivery_2',
--    rules = {
--        custom = {
--            {id = 'funmode_ice_cream_delivery'},
--            {id = 'gold_stake'}
--        },
--    },
--    jokers = {
--        {id = 'j_ice_cream', edition = 'negative'}
--    },
--    restrictions = {
--        banned_cards = {}
--    }
--}

SMODS.Challenge {
    key = 'manfred_court',
    jokers = {
        {id = 'j_funmode_manfred_von_karma', eternal = true},
    },
    rules = {
        custom = {},
        modifiers = {{id = 'joker_slots', value = 0}}
    },
    restrictions = {
        banned_cards = {},
        banned_tags = {},
        banned_other = {}
    }
}
