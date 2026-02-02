SMODS.Achievement {
    key = 'negative_rank',
    reset_on_startup = true,
    unlock_condition = function(self, args)
    if G.playing_cards then
        for _, c in ipairs(G.playing_cards) do
            if c:get_id() == 30 then
               return true
               end
            end
        end
    return false
    end
}
