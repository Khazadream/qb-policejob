RegisterNetEvent("qb-policejob:server:PlayerSearch", function(playerId)
    local src = source
    exports.ox_inventory:forceOpenInventory(src, 'player', playerId)
end)