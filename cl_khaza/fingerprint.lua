RegisterNetEvent("qb-policejob:client:registerFingerPrint", function(citizenID, fingerPrint)
    TriggerServerEvent("evange-core:server:mdt:set-fingerPrint", citizenID, fingerPrint)
    exports['qb-core']:Notify('Empreintes digitales enregistré avec succès.', 'success')
end)