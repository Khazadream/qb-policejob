RegisterNetEvent('qb-policejob:server:getSuspectPlayerData', function(suspectId)
    local src = source
    local suspect = QBCore.Functions.GetPlayer(suspectId)
    local suspectPlayerData = suspect.PlayerData

    TriggerClientEvent("qb-policejob:client:showAnkletSuspectInformation", source, suspectPlayerData)

end)