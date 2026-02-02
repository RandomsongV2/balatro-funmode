SMODS.Atlas{
    key = 'extended_ranks',
    path = '8BitDeck.png',
    px = 71,
    py = 95
}
SMODS.Atlas{
    key = 'extended_ranks_contrast',
    path = '8BitDeck_opt2.png',
    px = 71,
    py = 95
}


local function in_pool_()
    return Funmode.allow_negative_ranks
    end



SMODS.Rank {
    key = '1',
    card_key = '1',
    lc_atlas = 'extended_ranks',
    hc_atlas = 'extended_ranks_contrast',
    pos = {x = 0},
    nominal = 1,
    shorthand = '1',
    in_pool = in_pool_,
    next = {'2'},
    prev = {'funmode_0'},
}

for _, v in ipairs({0, -1, -2, -3, -4, -5, -6, -7, -8, -9}) do
    SMODS.Rank {
        key = v .. '',
        card_key = v .. '',
        lc_atlas = 'extended_ranks',
        hc_atlas = 'extended_ranks_contrast',
        pos = {x =  v * -1 + 1},
        nominal = v,
        shorthand = v .. '',
        in_pool = in_pool_,
        next = {'funmode_' .. (v + 1)},
        prev = {'funmode_' .. (v - 1)},
    }
end

SMODS.Rank {
    key = '-10',
    card_key = '-T',
    lc_atlas = 'extended_ranks',
    hc_atlas = 'extended_ranks_contrast',
    pos = {x = 11},
    nominal = -10,
    shorthand = '-10',
    in_pool = in_pool_,
    next = {'funmode_-9'},
    prev = {'funmode_-Jack'},
}

SMODS.Rank {
    key = '-Jack',
    card_key = '-J',
    lc_atlas = 'extended_ranks',
    hc_atlas = 'extended_ranks_contrast',
    pos = { x = 12 },
    nominal = -10,
    face_nominal = -0.1,
    face = true,
    shorthand = '-J',
    in_pool = in_pool_,
    next = {'funmode_-10'},
    prev = {'funmode_-Queen'},
}

SMODS.Rank {
    key = '-Queen',
    card_key = '-Q',
    lc_atlas = 'extended_ranks',
    hc_atlas = 'extended_ranks_contrast',
    pos = { x = 13 },
    nominal = -10,
    face_nominal = -0.2,
    face = true,
    shorthand = '-Q',
    in_pool = in_pool_,
    next = {'funmode_-Jack'},
    prev = {'funmode_-King'},
}

SMODS.Rank {
    key = '-King',
    card_key = '-K',
    lc_atlas = 'extended_ranks',
    hc_atlas = 'extended_ranks_contrast',
    pos = {x = 14},
    nominal = -10,
    face_nominal = -0.3,
    face = true,
    shorthand = '-K',
    in_pool = in_pool_,
    next = {'funmode_-Queen'},
    prev = {'funmode_-Ace'},
}

SMODS.Rank {
    key = '-Ace',
    card_key = '-A',
    lc_atlas = 'extended_ranks',
    hc_atlas = 'extended_ranks_contrast',
    pos = {x = 15},
    nominal = -11,
    face_nominal = -0.4,
    shorthand = '-A',
    in_pool = in_pool_,
    straight_edge = true,
    next = {'funmode_-King'},
    prev = {'funmode_-2'},
}
