local function IsTargetDead(playerId)
    local retval = false
    local hasReturned = false
    QBCore.Functions.TriggerCallback('police:server:isPlayerDead', function(result)
        retval = result
        hasReturned = true
    end, playerId)
    while not hasReturned do
        Wait(10)
    end
    return retval
end

RegisterNetEvent('qb-policejob:client:PlayerSearch', function()
    local player, distance = QBCore.Functions.GetClosestPlayer()
    local ped = PlayerPedId()
    if player ~= -1 and distance < 2.5 then
        local playerPed = GetPlayerPed(player)
        local playerId = GetPlayerServerId(player)
        if IsEntityPlayingAnim(playerPed, 'missminuteman_1ig_2', 'handsup_base', 3) or IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) or IsTargetDead(playerId) then  
            local plyCoords = GetEntityCoords(playerPed)
            local pos = GetEntityCoords(ped)
            if #(pos - plyCoords) < 2.5 then
                --exports.ox_inventory:openInventory('player', playerId)
                TriggerServerEvent("qb-policejob:server:PlayerSearch", playerId)
            else
                QBCore.Functions.Notify(Lang:t('error.none_nearby'), 'error')
            end
        end
    else
        QBCore.Functions.Notify(Lang:t('error.none_nearby'), 'error')
    end
end)