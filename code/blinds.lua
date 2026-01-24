SMODS.Atlas{
    key = 'blinds',
    path = 'blinds.png',
    px = 34,
    py = 34,
    atlas_table = 'ANIMATION_ATLAS',
    frames = 21
}
SMODS.Blind {
    key = 'flesh_prison',
    dollars = 5,
    mult = 2,
    atlas = 'blinds',
    pos = {x = 0, y = 0},
    boss = {min = 3},
    boss_colour = HEX("646464"),
    calculate = function(self, blind, context)
        if not blind.disabled and G.GAME.chips ~= 0 then
            if context.press_play then
                local scaling = math.max(G.GAME.chips / 16, 250)
                for i = 1, 8 do
                    if G.GAME.chips >= 0 and G.GAME.chips <= 500 then
                        G.E_MANAGER:add_event(Event({
                                                    trigger = "ease",
                                                    delay = 0.0,
                                                    ref_table = G.GAME,
                                                    ref_value = 'chips',
                                                    blockable = true,
                                                    ease_to = 0,
                                                    func = function()
                                                        play_sound('funmode_flesh_heal', 0.96 + math.random() * 0.08, 0.25)
                                                        return 0
                                                        end
                                                    }))
                        break
                    else
                        G.E_MANAGER:add_event(Event({
                                                    trigger = "ease",
                                                    delay = 0.0,
                                                    ref_table = G.GAME,
                                                    ref_value = 'chips',
                                                    blockable = true,
                                                    ease_to = G.GAME.chips - scaling,
                                                    func = function()
                                                        play_sound('funmode_flesh_heal', 0.96 + math.random() * 0.08, 0.25)
                                                        return G.GAME.chips
                                                        end
                                                    }))
                        delay(0.2)
                        end
                    end
                end
            end
        end
}

SMODS.Blind {
    key = 'visitor',
    atlas = 'blinds',
    pos = {x = 0, y = 1},
    boss_colour = HEX("221e3f"),
    discovered = true,
    dollars = 5,
    mult = 4,
    boss = {min = 9999}, --todo: fix observed cards
    calculate = function(self, card, context)
        if G and G.hand and context.before then
            for _, played_card in ipairs(context.full_hand) do
                played_card:set_ability(G.P_CENTERS['m_funmode_observed'])
                end
            end
        end
}

SMODS.Blind {
    key = 'ink',
    atlas = 'blinds',
    pos = {x = 0, y = 2},
    boss_colour = HEX("f9f9f9"),
    discovered = true,
    dollars = 5,
    boss = {showdown = true},
    in_pool = function(self)
        return false and not G.GAME.funmode.ink_boss --todo
        end,
    set_blind = function(self)
        G.GAME.funmode.ink_boss = true
        end
    --implemented in hooks.lua
}
