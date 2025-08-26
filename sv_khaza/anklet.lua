RegisterNetEvent('qb-policejob:server:getSuspectPlayerData', function(suspectId)
    local src = source
    local suspect = QBCore.Functions.GetPlayer(suspectId)
    local suspectPlayerData = suspect.PlayerData

    TriggerClientEvent("qb-policejob:client:showAnkletSuspectInformation", source, suspectPlayerData)

end)

RegisterNetEvent('qb-policejob:server:ankletlocation', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty then -- and Player.PlayerData.job.grade.level >= Config.AnkletLocationRank then
        local citizenid = data
        local Target = QBCore.Functions.GetPlayerByCitizenId(citizenid)
        if not Target then return end
        if Target.PlayerData.metadata["tracker"] then
            TriggerClientEvent("police:client:SendTrackerLocation", Target.PlayerData.source, src)
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t("error.no_anklet"), 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.rank_anklet"), 'error')
    end
end)