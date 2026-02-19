SMODS.current_mod.optional_features = {
    retrigger_joker = true,
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
Funmode.whiplash_card = {}
Funmode.using_whiplash = false

SMODS.current_mod.reset_game_globals = function(run_start)
    G.FUNCS.reset_funmode_femail_rank()
    if run_start then
        G.GAME.funmode = {}
   --     G.GAME.funmode.manfred = {}
        end
    end


local main_menu_ref = Game.main_menu
function Game:main_menu(change_context)
    ret = main_menu_ref(self, change_context)

    local SC_scale = 1.1*(G.debug_splash_size_toggle and 0.8 or 1)
    local title_card = Card(G.title_top.T.x, G.title_top.T.y, 1.2*G.CARD_W*SC_scale, 1.2*G.CARD_H*SC_scale, G.P_CARDS.H_funmode_0, G.P_CENTERS.c_base)

    title_card.states.visible = false
    title_card.no_ui = true
    title_card.ambient_tilt = 0.0

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = change_context == 'game' and 1.5 or 0,
        blockable = true,
        blocking = true,
        func = (function()
            if change_context == 'splash' then
                delay(3.2)
                G.title_top.cards[1]:start_dissolve({HEX("aaaaaa")}, nil, 2.0)
                G.title_top:emplace(title_card)
                title_card.states.visible = true
                title_card:start_materialize({G.C.WHITE,G.C.WHITE}, true, 3.5)
                play_sound('whoosh1', math.random()*0.1 + 0.3,0.3)
                play_sound('crumple'..math.random(1,5), math.random()*0.2 + 0.6,0.65)
            else
                delay(3.2)
                G.title_top.cards[1]:start_dissolve({HEX("aaaaaa")}, nil, 1.0)
                G.title_top:emplace(title_card)
                title_card.states.visible = true
                title_card:start_materialize({G.C.WHITE,G.C.WHITE}, nil, 1.75)
            end
            G.VIBRATION = G.VIBRATION + 1
            return true
    end)}))
    return ret
    end


