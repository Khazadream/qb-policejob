local ConfigItemName = 'spikes'

RegisterNetEvent('qb-policejob:server:PlaceSpikes', function()
    local src = source
    TriggerClientEvent("police:client:SpawnSpikeStrip", src)
    exports.ox_inventory:RemoveItem(src, ConfigItemName, 1)
end)

RegisterNetEvent('qb-policejob:server:giveBackSpikesItem', function()
    local src = source
    exports.ox_inventory:AddItem(src, ConfigItemName, 1, metadata)
end)