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
    if safe_get(card, 'ability', 'funmode_extra', 'name') and card.ability.funmode_extra and type(full_UI_table.name) == "table"
        and safe_get(full_UI_table, 'name', 1, 'nodes', 1, 'nodes', 1, 'config', 'object', 'config') and full_UI_table.name[1].nodes
    then
        local conf = full_UI_table.name[1].nodes[1].nodes[1].config.object.config
        if conf.string then
            conf.string = card.ability.funmode_extra.name
            full_UI_table.name[1].nodes[1].nodes[1].config.object:remove()
            full_UI_table.name[1].nodes[1].nodes[1].config.object = DynaText(conf)
            end
        end
    return full_UI_table
    end

--wingings font change
local generate_card_ui_ref = generate_card_ui
function generate_card_ui(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card)
    local full_UI_table = generate_card_ui_ref(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card)
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

--the ink
function ink_boss_update()
    target_blind = SMODS.Blinds.bl_funmode_ink --todo randomize
    for key, _ in ipairs(target_blind) do
        G.GAME.blind[key] = target_blind[key]
        end
    ease_background_colour_blind{new_colour = lighten(mix_colours(boss_col. G.C.BLACK, 0.3), 0.1), special_colour = boss_col, contrast = 2}
    end
