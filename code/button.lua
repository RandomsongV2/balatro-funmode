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
