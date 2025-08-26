RegisterNetEvent('qb-policejob:client:getNearestSuspect', function()
    local player, distance = QBCore.Functions.GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        TriggerServerEvent('qb-policejob:server:getSuspectPlayerData', playerId)
    else
        QBCore.Functions.Notify(Lang:t('error.none_nearby'), 'error')
    end
end)