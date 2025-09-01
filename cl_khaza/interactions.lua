local PlayerHandcuffs = {}

local function InitPoliceInteraction()
    print('InitPoliceInteraction')
    exports['qb-target']:AddGlobalPlayer({
        options = {
            {
                type = "client",
                event = "police:client:CuffPlayerSoft",
                icon = "fas fa-handcuffs",
                label = "Menotter",
                canInteract = function(entity)
                    if not IsPedAPlayer(entity) then return false end
                    local playerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity))
                    if PlayerHandcuffs[playerId] then
                        return false
                    end
                    return exports.ox_inventory:GetItemCount('handcuffs') >= 1
                end,
                job = 'police',
            },
            {
                type = "client",
                event = "police:client:CuffPlayerSoft",
                icon = "fas fa-handcuffs",
                label = "Démenotter",
                canInteract = function(entity)
                    if not IsPedAPlayer(entity) then return false end
                    local playerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity))
                    if not PlayerHandcuffs[playerId] then
                        return false
                    end
                    return true
                end,
                job = 'police',
            },
            {
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
                type = "client",
                event = "qb-policejob:client:PlayerSearch",
                icon = "fas fa-people-robbery",
                label = "Fouiller",
                canInteract = function(entity)
                    return IsPedAPlayer(entity)
                end,
                --job = 'police',
            },
            {
                --type = "client",
                --event = "police:client:BillPlayer",
                icon = "fas fa-money-bill-wave",
                label = "Amender",
                canInteract = function(entity)
                    return IsPedAPlayer(entity)
                end,
                action = function(entity)
                    print("entity: ", entity)
                    local pid = GetPlayerServerId(entity)
                    print("pid: ", pid)
                    TriggerEvent('evange-billing:client:CreateBilling', { playerId = pid })
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
        InitMenuInteraction()
    end
end)

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    InitPoliceInteraction()
    InitMenuInteraction()
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        Cleanup()
    end
end)

RegisterNetEvent('police:client:CuffedPlayers', function(data)
    PlayerHandcuffs = data or {}
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerHandcuffs = {}
    cleanup()
end)

RegisterNetEvent('qb-policejob:client:showAnkletSuspectInformation', function(suspectPlayerData)
    SetUpAnkletMenu(suspectPlayerData)
end)