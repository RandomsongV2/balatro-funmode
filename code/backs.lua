SMODS.Atlas{
    key = 'backs',
    path = 'backs.png',
    px = 71,
    py = 95
}

SMODS.Back {
    key = "shark",
    atlas = 'backs',
    pos = {x = 0, y = 0},
    config = {discards = -1, hands = -1},
    loc_vars = function(self, info_queue, back)
        return {vars = {self.config.discards}}
        end,
    apply = function(self, back)
        G.GAME.probabilities.normal = G.GAME.probabilities.normal * 2
        end
}
