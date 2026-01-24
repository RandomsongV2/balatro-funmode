return {
	descriptions = {
        FunCard = {
            c_funmode_gamba = {
                name = 'Gamba',
                text = {'{C:green}#1# in 2{} chance to gain {C:money}$#2#{}'}
                },
            c_funmode_spectre = {
                name = 'Spectre',
                text = {
                    'Convert up to #1# selected',
                    'cards to most used suit',
                    '{C:inactive}(currently: {V:1}#2#{C:inactive}){}'
                    }
                },
            c_funmode_hallway = {
                name = 'Hallway',
                text = {'Create {C:attention}copycard{} of',
                        'one selected card'}
                },
            c_funmode_no_cost = {
                name = 'No Cost Too Great',
                text = {'{C:attention}Wins{} the run', 'cant use if cost is too low'}
                },
            c_funmode_fun_soul = {
                name = 'Soul At Home',
                text = {'Creates a {C:uncommon}Legendary{} joker'}
                },
            c_funmode_color_wheel = {
                name = 'Color Wheel',
                text = {'Apply {C:edition}polychrome{} or {C:edition}monochrome',
                        'to random card held in hand'}
                },
            c_funmode_phonewave = {
                name = {'Phonewave', '{C:inactive,s:0.5}(name subject to change)'},
                text = {
                    'changes current {C:attention}seed',
                    '{C:inactive}previous seed: {C:attention}#1#'
                    }
                },
            },
        Joker = {
            j_funmode_joke = {
                name = 'Joke',
                text = {
                    'lose {C:money}$#1#{}',
                    'when blind selected',
                    'gain {C:money}$#2#{}',
                    'at end of round',
                    'if not in debt'
                    }
                },
            j_funmode_handcuffs = {
                name = 'Handcuffs',
                text = {
                    'when blind is selected',
                    'set {C:blue}hands{} to 2',
                    'and gain #1# {C:red}discards{}'
                },
            },
            j_funmode_gamba = {
                name = 'Gambling',
                text = {
                    'create a {C:attention}Wheel of Fortune{}',
                    'at end of round,',
                    '{C:green}#1# in 6{} chance to {C:red,E:2}self destruct{}',
                    'when blind is selected'
                },
            },
            j_funmode_soul = {
                name = 'Soul joker',
                text = {
                    'After {C:attention}#2#{} rounds',
                    'sell this card to',
                    'Create {C:legendary}Legendary{} joker',
                    '{C:inactive}(Currently{}{C:attention} #1#{}{C:inactive}/#2#){}'
                },
            },
            j_funmode_mimic_detector = {
                name = 'Mimic detector v4',
                text = {
                    '{C:red,X:black,E:2}No{}'
                },
            },
            j_funmode_manfred_von_karma = {
                name = 'Manfred Von Karma',
                text = {
                    'creates chosen joker',
                    'until end of a round',
                    'cant create same joker twice',
                    'cant create legendary',
                    '{C:inactive}does not work{}'
                },
            },
            j_funmode_franziska_von_karma = {
                name = 'Franziska Von Karma',
                text = {
                    'Creates {C:attention}The Fool{}',
                    'when hand played',
                    --'on {C:attention}first three{} hands of round',
                    'played {C:attention}face{} cards give',
                    '{X:mult,C:white} X#1# {} Mult when scored'
                },
            },
            j_funmode_DOG = {
                name = 'The Devouver Of Gods',
                text = {
                    'when {C:attention}Blind{} is selected',
                    '{C:red,E:2}destroy{} all jokers and gain',
                    'their {C:chips}chips{}, {C:mult}mult{} and {X:mult,C:white}xmult{}',
                    '{C:inactive}(currently {}{C:chips}+#1#{}{C:inactive} / {}{C:mult}+#2#{}{C:inactive} / {}{X:mult,C:white}X#3#{}{C:inactive}){}',
                },
            },
            j_funmode_twin = {
                name = 'Twin',
                text = {
                    'Gains {X:mult,C:white}X#2#{} mult for each Twin',
                    'can appear multiple times',
                    '{C:inactive}(currently {}{X:mult,C:white}X#1#{}{C:inactive} mult){}'
                },
            },
            j_funmode_YTTL = {
                name = 'Your Taking Too Long',
                text = {
                    'gain {C:money}$#1#{} at end of round',
                    'increase payout by {C:money}$#2#{} when',
                    'no {C:blue}hands{} or {C:red}discards{} left',
                },
            },
            j_funmode_feedbacker = {
                name = 'Feedbacker',
                text = {
                    'when hand played',
                    'destroy middle card',
                    '{V:1}Clubs{} excluded',
                },
            },
            j_funmode_slothful = {
                name = 'Slothful Joker',
                text = {
                    'gives {X:mult,C:white}X#1#{} mult',
                    'forces game speed to {C:attention}0.5{}'
                    }
                },
            j_funmode_minos = {
                name = 'Minos',
                text = {
                    'after being destroyed',
                    'creates {C:attention}Minos Prime{}'
                    }
                },
            j_funmode_minos_prime = {
                name = 'Minos Prime',
                text = {
                    'gains {X:mult,C:white}X#2#{} Mult when',
                    '{C:tarot}judgement{} is used',
                    '{C:inactive}(Currently {}{X:mult,C:white}X#1#{}{C:inactive}){}'
                    }
                },
            j_funmode_burning = {
                name = 'Burning Joker',
                text = {
                    'gains {X:mult,C:white}X#2#{} mult',
                    'when discarding',
                    'most played hand',
                    '{C:inactive}(Currently {}{X:mult,C:white}X#1#{}{C:inactive}){}'
                    }
                },
            j_funmode_black_market = {
                name = 'Black Market',
                text = {
                    'debuffs joker to the right',
                    'debuffs joker to the left',
                    'at end of round gain {C:money}$#1#{}',
                    'for each debuffed joker',
                    }
                },
            j_funmode_68 = {
                name = '68',
                text = {
                    '{C:chips}+#1#{} chips',
                    'if played hand contains',
                    'scored {C:attention}6{} and {C:attention}8{}',
                    'and no scored {C:attention}7{} or {C:attention}9{}',
                    }
                },
            j_funmode_unfair_coin = {
                name = 'Unfair Coin',
                text = {
                    'flip the coin',
                    'until it hits tails',
                    'heads give {C:money}$#1#',
                    'and {C:attention}double{} the gain',
                    'resets at end of round'
                    }
                },
            j_funmode_knight = {
                name = 'The Roaring Knight',
                text = {
                    'Gains {X:mult,C:white}X#1#{} mult',
                    'For each {C:spectral}Aura{} used',
                    'This run',
                    '{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive})'
                    },
                },
            j_funmode_grinning_beast = {
                name = 'Grinning Beast',
                text = {
                    'When {C:attention}first hand of round{} drawn',
                    '{C:red}destroy{} #1# random cards',
                    '{C:red}jokers and consumeables included'
                    },
                },
            j_funmode_whiplash = {
                name = 'Whiplash',
                text = {
                    'Choose {C:attention}one{} card',
                    'that will be {C:attention}guaranteed{} to draw',
                    'current card: {V:1}#1#{} of {V:2}#2#',
                    '{C:inactive}does not work{}'
                    },
                },
            j_funmode_glass_cannon = {
                name = 'Glass Cannon',
                text = {
                    'all played cards count as {C:attention}glass{}',
                    'When hand played',
                    '{C:green}#1# in #2#{} chance to {C:red}destroy{} this joker'
                    },
                },
            j_funmode_evil = {
                name = 'Evil Joker',
                text = {
                    'When blind selected',
                    'gain {X:mult,C:white}X#1#{} Mult',
                    'if its the {C:attention}only joker',
                    'currently {X:mult,C:white}X#2#'
                    },
                },
            j_funmode_insurance = {
                name = 'Insurance',
                text = {
                    'When blind selected',
                    'lose {C:money}$#1#{}',
                    'at end of boss blind',
                    'gain {C:money}$#2#{} for',
                    'each debuffed card in deck'
                    },
                },
            j_funmode_infini_eight = {
                name = 'infini-eight',
                text = {
                    'gains {X:mult,C:white}x#1#{} mult',
                    ' per {C:attention}consecutively{} scored 8',
                    '{C:inactive}currently {X:mult,C:white}X#2#'
                    },
                },
            j_funmode_wing_ding = {
                name = 'Wing Ding',
                text = {
                    '{X:mult,C:white}X#1#{} Mult',
                    '{f:funmode_wingdings}Sets font to wingdings',
                    '{C:inactive}this font ^ doesnt work{}'
                    },
                },
            j_funmode_apartment_13 = {
                name = 'Apartment 13',
                text = {
                    'At {C:attention}end of round',
                    'creates {C:planet}Earth',
                    '{C:blue}-#1#{} hand each round'
                    },
                },
            },
        Blind = {
            bl_funmode_visitor = {
                name = 'The Visitor',
                text = {'turns played cards',
                'into {C:attention}observed{} cards'}
                },
            bl_funmode_flesh_prison = {
                name = 'Flesh Prison',
                text = {
                        'when hand played',
                        'set scored {C:chips}chips{} to 0'
                        }
                },
            bl_funmode_ink = {
                name = 'The Ink',
                text = {
                        'changes boss blind',
                        'each hand drawn'
                        }
                },
            },
        Enhanced = {
            m_funmode_copycard = {
                name = "Copycard",
                text = {"copies other card's",
                        "{C:attention}rank{}, {C:attention}enhancement{} and {C:attention}seal{}",
                        "changes with copied card",
                        "{C:inactive,s:0.9}copies are always monochrome{}"}
                },
            m_funmode_observed = {
                name = 'Observed',
                text = {'{C:mult}+3{} mult',
                        'no rank',
                        'has a {C:attention}mind'}
                },
            },
        Edition = {
            e_funmode_monochrome = {
                name = "Monochrome",
                text = {
                    "balances chips and mult",
                    "keeping the score",
                    "{C:inactive}(ex: {}{C:chips}100{}{C:inactive}x{}{C:mult}1{}{C:inactive} -> {}{C:chips}10{}{C:inactive}x{}{C:mult}10{}{C:inactive}){}"
                }
            },
            e_funmode_copycard = {
                name = "Copycard",
                text = {"copies other card's",
                        "{C:attention}rank{}, {C:attention}enhancement{} and {C:attention}seal{}",
                        "changes with copied card",
                        "{C:inactive,s:0.9}copies are always monochrome{}"
                }
            },
        },
        Back = {
             b_funmode_shark = {
             name = 'Shark Deck',
             text = {
                'Doubles all {C:attention}listed',
                '{C:green}probabilities',
                '{C:blue}-1{} hand every round',
                '{C:red}-1{} discard every round'
                }
            }
        },
        Voucher = {
            v_funmode_color_theory = {
                name = 'Color Theory',
                text = {
                '{C:edition}Polychrome{} and',
                '{C:edition}Monochrome{} cards',
                'appear {C:attention}#1#X{} more often'
                }
            }
        }


    },
    misc = {
        labels = {
        funmode_monochrome = "Monochrome",
        funmode_copycard = "Monochrome"
        }



    }
}
