SMODS.current_mod.optional_features = {
    retrigger_joker = true,
    post_trigger = false,
    quantum_enhancements = true,
    cardareas = {
        discard = false,
        deck = false
    }
}

SMODS.current_mod.reset_game_globals = function(run_start)
    if run_start then
        G.GAME.funmode = {}
        end
    end
