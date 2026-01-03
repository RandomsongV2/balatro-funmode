SMODS.Atlas{
    key = 'b_flesh',
    path = 'b_flesh.png',
    px = 34,
    py = 32,
    atlas_table = 'ANIMATION_ATLAS',
    frames = 21
}
SMODS.Blind {
    key = 'flesh_prison',
    loc_txt = {name = 'Flesh Prison',
               text = {
                      'when hand played',
                      'set scored {C:chips}chips{} to 0'
                      }},
    dollars = 5,
    mult = 2,
    atlas = 'b_flesh',
    pos = {x = 0, y = 0},
    boss = {min = 3},
    boss_colour = HEX("646464"),
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.press_play then
                local scaling = G.GAME.chips / 16
                for i = 1, 8 do
                    G.E_MANAGER:add_event(Event({
                                                trigger = "ease",
                                                delay = 0.0,
                                                ref_table = G.GAME,
                                                ref_value = 'chips',
                                                blockable = true,
                                                ease_to = G.GAME.chips - scaling,
                                                func = function()
                                                    play_sound('funmode_flesh_heal', 0.96 + math.random() * 0.08, 0.25)
                                                    return G.GAME.chips - scaling
                                                    end
                                                }))
                    delay(0.2)
                    end
                end
            end
        end
}
