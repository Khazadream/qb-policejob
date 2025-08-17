local function InitPoliceInteraction()

    exports['qb-target']:AddGlobalPlayer({
        options = {
            {
                num = 1,
                type = "client",
                event = "police:client:CuffPlayerSoft",
                icon = "fas fa-handcuffs",
                label = "Menotter / Démenotter",
                canInteract = function(entity)
                    return IsPedAPlayer(entity)
                end,
                job = 'police',
            },
            {
                num = 2,
                type = "client",
                event = "police:client:EscortPlayer",
                icon = "fas fa-people-pulling",
                label = "Escorter",
                canInteract = function(entity)
                    return IsPedAPlayer(entity)
                end,
                job = 'police',
            },
            {
                num = 3,
                type = "client",
                event = "police:client:BillPlayer",
                icon = "fas fa-money-bill-wave",
                label = "Amender",
                canInteract = function(entity)
                    return IsPedAPlayer(entity)
                end,
                job = 'police',
            }
        },
        distance = 2.5
    })

end

exports('handcuffs', function(data, slot)
    TriggerEvent("police:client:CuffPlayerSoft")
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        InitPoliceInteraction()
    end
end)

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    InitPoliceInteraction()
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    
end)