local playerInsideMugshotZone = nil

RegisterNetEvent("qb-policejob:server:mugshotZoneRef", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if playerInsideMugshotZone == Player.PlayerData.citizenid then
        playerInsideMugshotZone = nil
        return
    end
    playerInsideMugshotZone = Player.PlayerData.citizenid
end)

RegisterNetEvent("qb-policejob:server:getSuspectMugshotId", function()
    local SourceId = source
    if playerInsideMugshotZone == nil then
        TriggerClientEvent('QBCore:Notify', SourceId, "Aucun suspect a photographier.", 'error')
        return
    end
    local TargetId = QBCore.Functions.GetPlayerByCitizenId(playerInsideMugshotZone).PlayerData.source
    TriggerClientEvent("qb-policejob:client:getSuspectMugshotId", SourceId, TargetId, playerInsideMugshotZone)
    TriggerClientEvent("qb-policejob:client:suspectMugshotCamSetup", TargetId)
end)