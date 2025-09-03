RegisterNetEvent("qb-policejob:client:registerFingerPrint", function(citizenID, fingerPrint)
    TriggerServerEvent("evange-police:server:mdt:set-fingerPrint", citizenID, fingerPrint)
    exports['qb-core']:Notify('Empreintes digitales enregistré avec succès.', 'success')
end)