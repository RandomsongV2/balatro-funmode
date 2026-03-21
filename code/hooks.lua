local stop_drag_ref = Card.stop_drag
function Card:stop_drag()
    local ref = stop_drag_ref(self)
    SMODS.calculate_context({funmode_card_released = true, funmode_released_card = self})
    return ref
    end

local set_seal_ref = Card.set_seal
function Card:set_seal(seal, immediate, silent)
    if not Funmode.ignore_change_context then
        funmode_seal_old = self.seal
        local ref = set_seal_ref(self, seal, immediate, silent)
        SMODS.calculate_context({funmode_seal_applied = true, funmode_seal_target = self, funmode_seal = seal, funmode_seal_old = funmode_seal_old})
        return ref
    else
        Funmode.ignore_change_context = false
        return  set_seal_ref(self, seal, immediate, silent)
    end
end

local set_ability_ref = Card.set_ability
function Card:set_ability(enhancement, initial, delay_sprites)
    if not Funmode.ignore_change_context then
        funmode_enhancement_old = self.config.center_key
        local ref = set_ability_ref(self, enhancement, initial, delay_sprites)
        SMODS.calculate_context({funmode_enhancement_applied = true, funmode_enhancement_target = self,
                funmode_enhancement = enhancement, funmode_enhancement_old = funmode_enhancement_old})
        return ref
    else
        Funmode.ignore_change_context = false
        return set_ability_ref(self, enhancement, initial, delay_sprites)
    end
    end

local set_base_ref = Card.set_base
function Card:set_base(card, initial)
    if not Funmode.ignore_change_context then
        local funmode_suit_old = self.config.card.suit
        local funmode_rank_old = self.config.card.value
        local ref = set_base_ref(self, card, initial)
        if not initial then
            SMODS.calculate_context({funmode_base_applied = true, funmode_base_target = self,
                    funmode_suit = self.config.card.suit, funmode_rank = self.config.card.value,
                    funmode_suit_old = funmode_suit_old, funmode_rank_old = funmode_rank_old})
        end
        return ref
    else
        Funmode.ignore_change_context = false
        return set_base_ref(self, card, initial)
    end
end

local function safe_get(table, args)
	local current = table
	for _, k in ipairs({args}) do
		if not current or current[k] == nil then
			return false
            end
		current = current[k]
        end
	return current
    end

--soul at home names
local generate_card_ui_ref = generate_card_ui
function generate_card_ui(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card)
    local full_UI_table = generate_card_ui_ref(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card)
    if card and card.ability and card.ability.funmode_extra and card.ability.funmode_extra.name and type(full_UI_table.name) == "table"
        and safe_get(full_UI_table, 'name', 1, 'nodes', 1, 'nodes', 1, 'config', 'object', 'config') and full_UI_table.name[1].nodes
    then
        local conf = full_UI_table.name[1].nodes[1].nodes[1].config.object.config
        if conf.string then
            conf.string = card.ability.funmode_extra.name
            full_UI_table.name[1].nodes[1].nodes[1].config.object:remove()
            full_UI_table.name[1].nodes[1].nodes[1].config.object = DynaText(conf)
            end
        end

--wingings font change
    if #SMODS.find_card('j_funmode_wing_ding') > 0 and full_UI_table.main and type(full_UI_table.main) == "table" then
        for line = 1, #full_UI_table.main do
            if #full_UI_table.main[line] > 0 then
                for i = 1, #full_UI_table.main[line] do
                    full_UI_table.main[line][i].config.font = SMODS.Fonts.funmode_wingdings
                    end
                end
            end
        end

    return full_UI_table
    end


local start_materialize_ref = Card.start_materialize
function Card:start_materialize(dissolve_colours, silent, timefac)
    if self.ability.set == 'elements' then
        self:set_edition('e_funmode_element', true, true)
        end
    return start_materialize_ref(self, dissolve_colours, silent, timefac)
    end

-- todo
--the ink
--function ink_boss_update()
--    target_blind = SMODS.Blinds.bl_funmode_ink
--    for key, _ in ipairs(target_blind) do
--        G.GAME.blind[key] = target_blind[key]
--        end
--    ease_background_colour_blind{new_colour = lighten(mix_colours(boss_col. G.C.BLACK, 0.3), 0.1), special_colour = boss_col, contrast = 2}
--    end
--    get_new_boss()

local play = G.FUNCS.play_cards_from_highlighted
function G.FUNCS.play_cards_from_highlighted()
	SMODS.calculate_context({funmode_pre_play = true})
	return play(self)
end
