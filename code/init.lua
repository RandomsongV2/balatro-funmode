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
Funmode.whiplash_card = {}
Funmode.using_whiplash = false

SMODS.current_mod.reset_game_globals = function(run_start)
    if run_start then
        G.GAME.funmode = {}
        G.GAME.funmode.manfred = {}
        end
    end

--function Game:main_menu(change_context) --True if main menu is accessed from the splash screen, false if it is skipped or accessed from the game

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

--     G.E_MANAGER:add_event(Event({
--         trigger = 'after',
--         delay = change_context == 'splash' and 1.8 or change_context == 'game' and 2 or 0.5,
--         blockable = false,
--         blocking = false,
--         func = (function()
--             play_sound('magic_crumple'..(change_context == 'splash' and 2 or 3), (change_context == 'splash' and 1 or 1.3), 0.9)
--             play_sound('whoosh1', 0.4, 0.8)
--             ease_value(G.SPLASH_LOGO, 'dissolve', -1, nil, nil, nil, change_context == 'splash' and 2.3 or 0.9)
--             G.VIBRATION = G.VIBRATION + 1.5
--             return true
--     end)}))
--
--
--     G.E_MANAGER:add_event(Event({func = function() G.CONTROLLER.lock_input = false; return true end}))
--     set_screen_positions()

--    G.title_top:sort('order')
--    G.title_top:set_ranks()
--    G.title_top:align_cards()
--    G.title_top:hard_set_cards()

    return ret
    end


-- 3333
-- function funmode_debug()
--
--   local rank_tallies = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
--   local mod_rank_tallies = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
--   local rank_name_mapping = {2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K', 'A'}
--   local face_tally = 0
--   local mod_face_tally = 0
--   local num_tally = 0
--   local mod_num_tally = 0
--   local ace_tally = 0
--   local mod_ace_tally = 0
--   local wheel_flipped = 0
--
--
--   for k, v in ipairs(G.playing_cards) do
--     if v.ability.name ~= 'Stone Card' and (not unplayed_only or ((v.area and v.area == G.deck) or v.ability.wheel_flipped)) then
--
--       --for face cards/numbered cards/aces
--       local card_id = v:get_id()
--       face_tally = face_tally + ((card_id ==11 or card_id ==12 or card_id ==13) and 1 or 0)
--       mod_face_tally = mod_face_tally + (v:is_face() and 1 or 0)
--       if card_id > 1 and card_id < 11 then
--         num_tally = num_tally + 1
--         if not v.debuff then mod_num_tally = mod_num_tally + 1 end
--       end
--       if card_id == 14 then
--         ace_tally = ace_tally + 1
--         if not v.debuff then mod_ace_tally = mod_ace_tally + 1 end
--       end
--
--       --ranks
--       rank_tallies[card_id - 1] = rank_tallies[card_id - 1] + 1
--       if not v.debuff then mod_rank_tallies[card_id - 1] = mod_rank_tallies[card_id - 1] + 1 end
--     end
--   end
--   for k, n in ipairs(rank_tallies) do
--     if n == 0 then
--         rank_tallies[k]:remove()
--         rank_name_mapping[k]:remove()
--   for k, n in ipairs(mod_rank_tallies) do
--     if n == 0 then
--         mod_rank_tallies[k]:remove()
--
--   Funmode.rank_name_mapping = rank_name_mapping
--   Funmode.rank_tallies = rank_tallies
--   Funmode.mod_rank_tallies = mod_rank_tallies
--
--     t = {n=G.UIT.R, config={align = "cm", padding = 0.07}, nodes={
--     {n=G.UIT.C, config={align = "cm", r = 0.1, padding = 0.04, emboss = 0.04, minw = 0.5, colour = G.C.L_BLACK}, nodes={
--         {n=G.UIT.T, config={text = rank_name_mapping[i],colour = G.C.JOKER_GREY, scale = 0.35, shadow = true}},
--     }},
--     {n=G.UIT.C, config={align = "cr", minw = 0.4}, nodes={
--         mod_delta and {n=G.UIT.O, config={object = DynaText({string = {{string = ''..rank_tallies[i], colour = flip_col},{string =''..mod_rank_tallies[i], colour = G.C.BLUE}}, colours = {G.C.RED}, scale = 0.4, y_offset = -2, silent = true, shadow = true, pop_in_rate = 10, pop_delay = 4})}} or
--         {n=G.UIT.T, config={text = rank_tallies[i] or 'NIL',colour = flip_col, scale = 0.45, shadow = true}},
--     }}
--     }}
--     return t
-- end
