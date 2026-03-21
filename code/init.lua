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
Funmode.using_draedon = nil
Funmode.copycard = {}

SMODS.current_mod.reset_game_globals = function(run_start)
    G.FUNCS.reset_funmode_femail_rank()
    G.FUNCS.funmode_check_for_originals() -- copycard removal
    if run_start then
        G.GAME.funmode_colour_rate = 1
        end
    end


local main_menu_ref = Game.main_menu
function Game:main_menu(change_context)
    ret = main_menu_ref(self, change_context)
    local SC_scale = 1.1*(G.debug_splash_size_toggle and 0.8 or 1)
    local title_card = Card(G.title_top.T.x, G.title_top.T.y, G.CARD_W, G.CARD_H, G.P_CARDS.H_funmode_0, G.P_CENTERS.c_base)
    title_card.T.w = title_card.T.w * 1.2 * SC_scale
    title_card.T.h = title_card.T.h * 1.2 * SC_scale
    title_card.states.visible = false
    title_card.no_ui = true
    G.title_top.T.w = G.title_top.T.w * 1.7675
    G.title_top.T.x = G.title_top.T.x - 0.8
    G.title_top:emplace(title_card)
    G.E_MANAGER:add_event(Event({
        trigger = "after",
        delay = 0,
        blockable = false,
        blocking = false,
        func = function()
            if change_context == "splash" then
                title_card.states.visible = true
                title_card:start_materialize({G.C.WHITE, G.C.WHITE}, true, 2.5)
            else
                title_card.states.visible = true
                title_card:start_materialize({G.C.WHITE, G.C.WHITE}, nil, 1.2)
            end
            return true
        end,
    }))
    return ret
end

SMODS.current_mod.config_tab = function()
    return {n = G.UIT.ROOT, config = {minw = 8, minh = 5, colour = G.C.CLEAR, align = "tm", padding = 0.2}, nodes = {
        create_toggle{
            label = "only add challenges",
            scale = 1,
            minw = 2, minh = 0.5,
            ref_table = SMODS.Mods.FunMode.config,
            ref_value = "challenge only"
        },
    }}
end

Funmode.context = {
    cardarea = true,
    full_hand = {},
    scoring_hand = {},
    scoring_name = true,
    display_name = true,
    poker_hand = true,
    poker_hands = true,
    before = true,
    -- initial_scoring_step = true,
    main_scoring = true,
    individual = true,
    repetition = true,
    repetition_only = true,
    card_effects = true,
    edition = true,
    pre_joker = true,
    joker_main = true,
    other_joker = true,
    other_main = true,
    post_joker = true,
    final_scoring_step = true,
    destroy_card = true,
    destroying_card = true,
    remove_playing_cards = true,
    removed = {},
    after = true,
    debuffed_hand = true,
    end_of_round = true,
    main_eval = true,
    game_over = true,
    beat_boss = true,
    other_card = true,
    card_effects = true,
    playing_card_end_of_round = true,
    repetition = true,
    card_effects = {},
    setting_blind = true,
    blind = true,
    drawing_cards = true,
    amount = 0,
    hand_drawn = true,
    other_drawn = true,
    first_hand_drawn = true,
    pre_discard = true,
    hook = true,
    discard = true,
    other_card = {},
    press_play = true,
    evaluate_poker_hand = true,
    modify_scoring_hand = true,
    in_scoring = true,
    debuff_hand = true,
    check = true,
    modify_hand = true,
    debuff_card = true,
    stay_flipped = true,
    from_area = true,
    to_area = true,
    blind_disabled = true,
    blind_defeated = true,
    round_eval = true,
    modify_ante = true,
    ante_change = true,
    ante_end = true,
    starting_shop = true,
    ending_shop = true,
    open_booster = true,
    card = {},
    booster = {},
    skipping_booster = true,
    ending_booster = true,
    buying_card = true,
    buying_self = true,
    selling_card = true,
    --selling_self = true,
    using_consumeable = true,
    consumeable = {},
    area = true,
    reroll_shop = true,
    cost = true,
    create_shop_card = true,
    set = true,
    modify_shop_card = true,
    money_altered = true,
    from_shop = true,
    from_tarot = true,
    from_scoring = true,
    poker_hand_changed = true,
    old_level = 1,
    new_level = 1,
    old_parameters = {},
    new_parameters = {},
    skip_blind = true,
    tag_added = true,
    prevent_tag_trigger = true,
    other_context = true,
    tag_triggereda = true,
    playing_card_added = true,
    cards = {},
    card_added = true,
    joker_type_destroyed = true,
    shatters = true,
    change_rank = true,
    new_rank = true,
    old_rank = true,
    rank_increase = 0,
    change_suit = true,
    new_suit = true,
    old_suit = true,
    setting_ability = true,
    new = true,
    old = true,
    unchanged = true,
    numerator = 1,
    denominator = 1,
    mod_probability = true,
    trigger_obj = true,
    identifier = true,
    from_roll = true,
    fix_probability = true,
    pseudorandom_result = true,
    result = true,
    check_eternal = true,
    trigger = {from_sell = true, destroy_cards = true}
}
