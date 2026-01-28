SMODS.current_mod.optional_features = {
    retrigger_joker = false,
    post_trigger = false,
    quantum_enhancements = true,
    cardareas = {
        discard = false,
        deck = false
    }
}

Funmode = {}
Funmode.ui = {}
Funmode.ui.FUNMODE_COLLECTION_JOKERS = {}
Funmode.manfred_card = {}
Funmode.using_manfred = 0

SMODS.current_mod.reset_game_globals = function(run_start)
    if run_start then
        G.GAME.funmode = {}
        G.GAME.funmode.manfred = {}
        end
    end
