local bipperIsActive = false

exports('leo_bipper', function(data, slot)
    TriggerServerEvent("qb-policejob:server:toggleBipper", slot)
end)

RegisterNetEvent("qb-policejob:client:toggleBipper", function()
    bipperIsActive = not bipperIsActive

    if bipperIsActive then
        QBCore.Functions.Notify("Vous avez activé votre bipper", "primary", 2500)
    else
        QBCore.Functions.Notify("Vous avez désactivé votre bipper", "primary", 2500)
    end
end)

RegisterNetEvent("qb-policejob:client:setBipper", function(isActive)
    bipperIsActive = isActive
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        TriggerEvent("qb-policejob:client:setBipper", false)
        TriggerServerEvent("qb-policejob:server:setBippers", false)
    end
end)

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    TriggerEvent("qb-policejob:client:setBipper", false)
    TriggerServerEvent("qb-policejob:server:setBippers", false)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        TriggerEvent("qb-policejob:client:setBipper", false)
        TriggerServerEvent("qb-policejob:server:setBippers", false)
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    TriggerEvent("qb-policejob:client:setBipper", false)
    TriggerServerEvent("qb-policejob:server:setBippers", false)
end)

AddEventHandler('ox_inventory:itemCount', function(itemName, totalCount)
    if itemName == "leo_bipper" and totalCount == 0 then
        TriggerEvent("qb-policejob:client:setBipper", false)
        TriggerServerEvent("qb-policejob:server:setBippers", false)
    end
end)