exports('spikes', function(data, slot)
    TriggerServerEvent("qb-policejob:server:PlaceSpikes")
end)

local model = `P_ld_stinger_s`

exports['qb-target']:AddTargetModel(model, {
    options = {
      {
        num = 1,
        icon = "fas fa-credit-card",
        label = "Remove spikes",
        action = function(entity)
          TriggerEvent("qb-policejob:client:removePlacedSpikes", entity)
        end,
        job = "police"
      }
    },
    distance = 1.5
})