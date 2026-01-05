SMODS.Shader {
    key = 'monochrome',
    path = 'monochrome.fs',
    send_vars = function (sprite, card)
        return {}
    end,
}
SMODS.Edition({
    key = "monochrome",
    loc_txt = {
        name = "Monochrome",
        label = "Monochrome",
        text = {
            "balances chips and mult",
            "keeping the score",
            "{C:inactive}(ex: {}{C:chips}100{}{C:inactive}x{}{C:mult}1{}{C:inactive} -> {}{C:chips}10{}{C:inactive}x{}{C:mult}10{}{C:inactive}){}"
        }
    },
    discovered = true,
    unlocked = true,
    shader = 'monochrome',
    config = {},
    in_shop = true,
    weight = 3,
    extra_cost = -1,
    apply_to_float = true,
    loc_vars = function(self)
        return {}
    end
})
