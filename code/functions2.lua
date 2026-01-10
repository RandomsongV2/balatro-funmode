local function create_use_button(card)
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
            button = 'modprefix_my_button_click', -- function in G.FUNCS that will run when this button is clicked
            func = 'modprefix_my_button_func', -- function in G.FUNCS that will run every frame this button exists (optional)
            ref_table = card,
          },
          nodes = {
            {
              n = G.UIT.R,
              nodes = {
                {
                  n = G.UIT.T,
                  config = {
                    text = "My button",
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
      align = 'cl', -- position relative to the card, meaning "center left". Follow the SMODS UI guide for more alignment options
      major = card,
      parent = card,
      offset = { x = 0.2, y = 0 } -- depends on the alignment you want, without an offset the button will look as if floating next to the card, instead of behind it
    }
  }
end

-- Will be called whenever the button is clicked
G.FUNCS.modprefix_my_button_click = function(e)
  local card = e.config.ref_table -- access the card this button was on

  -- Show a message on the card, as an example
  SMODS.calculate_effect({ message = "Hi!" }, card)
end

-- Will run every frame while the button exists
G.FUNCS.modprefix_my_button_func = function(e)
  local card = e.config.ref_table -- access the card this button was on (unused here, but you can access it)

  -- In vanilla, this is generally used to define when the button can be used, for example:
  local can_use = true -- can be any condition you want

  -- Removes the button when the card can't be used, otherwise makes it use the previously defined button click
  e.config.button = can_use and 'modprefix_my_button_click' or nil
  -- Changes the color of the button depending on whether it can be used or not
  e.config.colour = can_use and G.C.MULT or G.C.UI.BACKGROUND_INACTIVE

end

SMODS.DrawStep {
  key = 'my_button',
  order = -30, -- before the Card is drawn
  func = function(card, layer)
    if card.children.modprefix_my_button then
      card.children.modprefix_my_button:draw()
    end
  end
}

-- make sure SMODS doesn't draw the button after the card is drawn
SMODS.draw_ignore_keys.modprefix_my_button = true

local highlight_ref = Card.highlight
function Card.highlight(self, is_higlighted)
  if not self.highlighted and self.ability.set == "Joker" and self.area == G.jokers and self.config.center.funmode_can_use and self.config.center.funmode_use then
    self.children.funmode_use = create_use_button(self, self.config.center.button_name or 'use')
  elseif self.children.funmode_use then
    self.children.funmode_use:remove()
    self.children.funmode_use = nil
    end
  return highlight_ref(self, is_higlighted)
end
