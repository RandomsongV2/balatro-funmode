-- custom challenge effects
local start_run_ref = Game.start_run
function Game:start_run(args)
    ref = start_run_ref(self, args)
	if G.GAME and args.challenge and args.challenge.rules and args.challenge.rules.custom then
        Funmode.debug = args.challenge.rules.custom
        for i, r in ipairs(args.challenge.rules.custom) do
--funmode_legendary_always
            if r.id == 'funmode_legendary_always' then
                SMODS.Booster:take_ownership_by_kind('Arcana', {
                        create_card = function(self, card, i)
                            local _card
                            if i == 1 then
                                _card = {
                                    set = "Spectral",
                                    area = G.pack_cards,
                                    skip_materialize = true,
                                    soulable = false,
                                    key = "c_soul",
                                }
                            else
                                _card = { set = "Tarot", area = G.pack_cards, skip_materialize = true, soulable = true}
                            end
                            return _card
                        end,
                        loc_vars = pack_loc_vars,
                    },
                    true
                )
--gold_stake
            elseif r.id == 'gold_stake' then
                --todo
                end
            end
        end
    return ref
    end

SMODS.Challenge {
    key = 'dark_souls',
    rules = {
        custom = {
            {id = 'funmode_legendary_always'},
            {id = 'scaling', value = 5}
        },
    },
    jokers = {},
    restrictions = {
        banned_cards = {}
    }
}

--funmode_ice_cream_delivery
local remove_ref = Card.remove
function Card:remove(args)
	if self.config and self.config.center and self.config.center.key == 'j_ice_cream' and self.area == G.jokers and G.GAME.modifiers and G.GAME.modifiers.funmode_ice_cream_delivery then
        G.STATE = G.STATES.GAME_OVER
        G.FILE_HANDLER.force = true
        G.STATE_COMPLETE = false
        end
    return remove_ref(self, args)
    end

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

--communism
local ease_dollars_ref = ease_dollars
function ease_dollars(amount)
	if G.GAME.modifiers.funmode_communism and amount > 0 then
        amount = amount / (#G.jokers.cards + 1)
        G.GAME.funmode_communism_dollar_buffer = (G.GAME.funmode_communism_dollar_buffer or 0) + amount % 1
        amount = (amount - amount % 1) + (G.GAME.funmode_communism_dollar_buffer - G.GAME.funmode_communism_dollar_buffer % 1)
        G.GAME.funmode_communism_dollar_buffer = G.GAME.funmode_communism_dollar_buffer % 1
    end
    ease_dollars_ref(amount)
end

SMODS.Challenge {
    key = 'communism',
    rules = {
        custom = {
            {id = 'funmode_communism'}
        },
    },
    restrictions = {
        banned_cards = {},
        banned_tags = {},
        banned_other = {}
    }
}
