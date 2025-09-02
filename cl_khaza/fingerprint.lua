RegisterNetEvent("qb-policejob:client:registerFingerPrint", function(citizenID, fingerPrint)
    TriggerServerEvent("evange-core:server:mdt:set-fingerPrint", citizenID, fingerPrint)
end)