SMODS.Edition {
    key = 'true_negative',
    shader = 'true_negative',
    config = {modifier = -1},
    in_shop = true,
    weight = 3,
    extra_cost = 0,
    sound = {sound = "negative", per = 1.5, vol = 0.4},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.edition.modifier}}
    end,
    get_weight = function(self)
        return self.weight
    end,
    draw = function(self, card, layer)
        if (layer == 'card' or layer == 'both') and card.sprite_facing == 'front' and (card.config.center.discovered or card.bypass_discovery_center) then
            card.children.center:draw_shader('negative', nil, card.ARGS.send_to_shader)
            if card.children.front and card.ability.effect ~= 'Stone Card' then
                card.children.front:draw_shader('negative', nil, card.ARGS.send_to_shader)
            end
            card.children.center:draw_shader('negative_shine', nil, card.ARGS.send_to_shader)
            card.children.center:draw_shader('negative_shine', nil, card.ARGS.send_to_shader)
            card.children.center:draw_shader('negative_shine', nil, card.ARGS.send_to_shader)
            card.children.center:draw_shader('negative_shine', nil, card.ARGS.send_to_shader)
            card.children.center:draw_shader('negative_shine', nil, card.ARGS.send_to_shader)
        end
    end
}
