--from vanillaremade wiki
local function create_use_button(card, args)
  return UIBox {
    definition = {
      n = G.UIT.ROOT,
      config = {
        colour = G.C.CLEAR
      },
      nodes = {
        {
          n = G.UIT.C,
          config = {
            align = 'cm',
            padding = 0.15,
            r = 0.08,
            hover = true,
            shadow = true,
            colour = G.C.MULT, -- color of the button background
            button = 'funmode_use_press',
            func = 'funmode_use_draw',
            ref_table = card,
          },
          nodes = {
            {
              n = G.UIT.R,
              nodes = {
                {
                  n = G.UIT.T,
                  config = {
                    text = args.text or 'use',
                    colour = G.C.UI.TEXT_LIGHT, -- color of the button text
                    scale = 0.4
                  }
                },
                {
                  n = G.UIT.B,
                  config = {
                    w = 0.1,
                    h = 0.4
                  }
                }
              }
            }
          }
        }
      }
    },
    config = {
      align = 'tr',
      major = card,
      parent = card,
      offset = {x = args.x or -0.35, y = args.y or 0.725}
    }
  }
end

G.FUNCS.funmode_use_press = function(e)
  local card = e.config.ref_table -- access the card this button was on
  card.config.center.funmode_button.use(card)
end

G.FUNCS.funmode_use_draw = function(e)
  local card = e.config.ref_table -- access the card this button was on (unused here, but you can access it)
  local can_use = card.config.center.funmode_button.can_use(card)

  -- Removes the button when the card can't be used, otherwise makes it use the previously defined button click
  e.config.button = can_use and 'funmode_use_press' or nil
  -- Changes the color of the button depending on whether it can be used or not
  e.config.colour = can_use and G.C.MULT or G.C.UI.BACKGROUND_INACTIVE

end

SMODS.DrawStep {
  key = 'my_button',
  order = -30, -- before the Card is drawn
  func = function(card, layer)
    if card.children.funmode_use then
      card.children.funmode_use:draw()
    end
  end
}

-- make sure SMODS doesn't draw the button after the card is drawn
SMODS.draw_ignore_keys.funmode_use = true

local highlight_ref = Card.highlight
function Card.highlight(self, is_higlighted)
  if not self.highlighted and self.ability.set == "Joker" and self.area == G.jokers and self.config.center.funmode_button then
    self.children.funmode_use = create_use_button(self, self.config.center.funmode_button)
  elseif self.children.funmode_use then
    self.children.funmode_use:remove()
    self.children.funmode_use = nil
    end
  return highlight_ref(self, is_higlighted)
end







-- manfred von karma

local funmode_collection_jokers_main = function()
  local deck_tables = {}

  G.your_collection = {}
  for j = 1, 3 do
    G.your_collection[j] = CardArea(
      G.ROOM.T.x + 0.2*G.ROOM.T.w/2,G.ROOM.T.h,
      5*G.CARD_W,
      0.95*G.CARD_H,
      {card_limit = 5, type = 'title', highlight_limit = 0, collection = true})
    table.insert(deck_tables,
    {n=G.UIT.R, config={align = "cm", padding = 0.07, no_fill = true}, nodes={
      {n=G.UIT.O, config={object = G.your_collection[j]}}
    }}
    )
  end

  local joker_options = {}
  for i = 1, math.ceil(#G.P_CENTER_POOLS.Joker/(5*#G.your_collection)) do
    table.insert(joker_options, localize('k_page')..' '..tostring(i)..'/'..tostring(math.ceil(#G.P_CENTER_POOLS.Joker/(5*#G.your_collection))))
  end

  for i = 1, 5 do
    for j = 1, #G.your_collection do
      local center = G.P_CENTER_POOLS["Joker"][i+(j-1)*5]
      if center.key == 'j_joker' or center.rarity ~= 4 and not Funmode.manfred_card[Funmode.using_manfred].ability.extra.used[center.key] then
        local card = Card(G.your_collection[j].T.x + G.your_collection[j].T.w/2, G.your_collection[j].T.y, G.CARD_W, G.CARD_H, nil, center)
        card.sticker = get_joker_win_sticker(center)
        G.your_collection[j]:emplace(card)
      end
    end
  end

  INIT_COLLECTION_CARD_ALERTS()

  local t =  create_UIBox_generic_options({ back_func = 'close_funmode_collection_jokers',
  contents = {
        {n=G.UIT.R, config={align = "cm", r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes=deck_tables},
        {n=G.UIT.R, config={align = "cm"}, nodes={
          create_option_cycle({options = joker_options, w = 4.5, cycle_shoulders = true, opt_callback = 'funmode_collection_joker_page', current_option = 1, colour = G.C.RED, no_pips = true, focus_args = {snap_to = true, nav = 'wide'}})
        }}
    }})
  return t
end

G.FUNCS.funmode_collection_joker_page = function(args)
  if not args or not args.cycle_config then return end
  for j = 1, #G.your_collection do
    for i = #G.your_collection[j].cards,1, -1 do
      local c = G.your_collection[j]:remove_card(G.your_collection[j].cards[i])
      c:remove()
      c = nil
    end
  end
  for i = 1, 5 do
    for j = 1, #G.your_collection do
      local center = G.P_CENTER_POOLS["Joker"][i+(j-1)*5 + (5*#G.your_collection*(args.cycle_config.current_option - 1))]
      if not center then break end
      if center.key == 'j_joker' or center.rarity ~= 4 and not Funmode.manfred_card[Funmode.using_manfred].ability.extra.used[center.key] then
        local card = Card(G.your_collection[j].T.x + G.your_collection[j].T.w/2, G.your_collection[j].T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, center)
        card.sticker = get_joker_win_sticker(center)
        G.your_collection[j]:emplace(card)
      end
    end
  end
  INIT_COLLECTION_CARD_ALERTS()
end



G.FUNCS.close_funmode_collection_jokers = function()
    if Funmode.ui.FUNMODE_COLLECTION_JOKERS then
        Funmode.ui.FUNMODE_COLLECTION_JOKERS[#Funmode.ui.FUNMODE_COLLECTION_JOKERS]:remove()
        Funmode.manfred_card[Funmode.using_manfred] = nil
        Funmode.using_manfred = Funmode.using_manfred - 1
        if Funmode.using_manfred == 0 then
            G.SETTINGS.paused = false
            end
        end
    end

G.FUNCS.funmode_collection_jokers = function()
    Funmode.ui.FUNMODE_COLLECTION_JOKERS[#Funmode.ui.FUNMODE_COLLECTION_JOKERS + 1] = UIBox({
        definition = funmode_collection_jokers_main(),
        config = {
            align = "cm",
            offset = {x = 0, y = 10},
            major = G.ROOM_ATTACH,
            bond = "Weak",
            instance_type = "POPUP",
        },
    })
    Funmode.ui.FUNMODE_COLLECTION_JOKERS[#Funmode.ui.FUNMODE_COLLECTION_JOKERS].alignment.offset.x = 0
    Funmode.ui.FUNMODE_COLLECTION_JOKERS[#Funmode.ui.FUNMODE_COLLECTION_JOKERS].alignment.offset.y = 0
    G.ROOM.jiggle = G.ROOM.jiggle + 1
    Funmode.ui.FUNMODE_COLLECTION_JOKERS[#Funmode.ui.FUNMODE_COLLECTION_JOKERS]:align_to_major()
    end

local drag_ref = Card.drag
function Card:drag()
    if Funmode.using_manfred > 0 then
        if self.config.center.key == 'j_joker' or self.config.center.rarity ~= 4 and not Funmode.manfred_card[Funmode.using_manfred].ability.extra.used[self.config.center.key] then
            SMODS.add_card({key = self.config.center.key, edition = {}, stickers = {'funmode_fabricated_sticker'}, force_stickers = true})
            Funmode.manfred_card[Funmode.using_manfred].ability.extra.used[self.config.center.key] = true
            G.FUNCS.close_funmode_collection_jokers()
            save_run()
            end
    else
        return drag_ref(self)
        end
    end

G.FUNCS.funmode_manfred_use_init = function(card)
    G.SETTINGS.paused = true
    Funmode.using_manfred = Funmode.using_manfred + 1
    Funmode.manfred_card[Funmode.using_manfred] = card
    G.FUNCS.funmode_collection_jokers()
    end
