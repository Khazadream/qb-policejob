local PlayerHandcuffs = {}
local PlayerHandTight = {}

local function InitPoliceInteraction()
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
                    if PlayerHandTight[playerId] then
                        return false
                    end
                    return true
                end,
                job = 'police',
            },
            {
                type = "client",
                icon = "fas fa-handcuffs",
                label = "Retirer les serflex",
                canInteract = function(entity)
                    if not IsPedAPlayer(entity) then return false end
                    local playerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity))
                    if not PlayerHandcuffs[playerId] then
                        return false
                    end
                    if PlayerHandTight[playerId] then
                        return true
                    end
                    return false
                end,
                action = function(entity)
                    TriggerEvent("police:client:CuffPlayerSoft", { type = 'criminal', hasRopped = true, isGagged = false })
                end
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
                icon = "fas fa-money-bill-wave",
                label = "Amender",
                canInteract = function(entity)
                    return IsPedAPlayer(entity)
                end,
                action = function(entity)
                    local pid = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity))
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

exports('ziptie', function(data, slot)
    TriggerEvent("police:client:CuffPlayerSoft", data.args)
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

RegisterNetEvent('police:client:CuffedPlayers', function(data , data2)
    PlayerHandcuffs = data or {}
    PlayerHandTight = data2 or {}
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerHandcuffs = {}
    PlayerHandTight = {}
    cleanup()
end)

RegisterNetEvent('qb-policejob:client:showAnkletSuspectInformation', function(suspectPlayerData)
    SetUpAnkletMenu(suspectPlayerData)
end)