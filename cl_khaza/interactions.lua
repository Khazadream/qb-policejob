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

local menus    = {}
local position = nil

local function PrintCell(label, value)
    return (
        '<div style="display: flex; flex-direction: column; gap: 0.5rem; width: 564px;">' ..
            ('<div style="font-weight: 900; font-family: Helvetica, sans-serif; text-align: left;text-transform: uppercase;">' .. label .. '</div>') ..
            ('<div style="text-align: left; font-family: Helvetica, sans-serif;font-weight: 200;">' .. value .. '</div>') ..
        '</div>'
    )
end

local function SetUpAnkletMenu(suspectPlayerData)

    -- -- Informations
    -- Prénom
    -- Nom
    -- Date de naissance
    -- Nationalité
    -- Citizen ID

    -- -- Bracelets
    -- Numéro de Bracelet
    -- Actif / Inactif

    --local playerData = QBCore.Functions.GetPlayerData()
    local playerData = suspectPlayerData
    local menusIndex = #menus
    menus[#menus + 1] = exports['interactionMenu']:Create {
        rotation = vector3(40, 180, -20), --vector3(-40, 0, 270),
        position = vector4(-386.0, -419.53, 25.06, 167.64), --position,
        scale = 0.8,
        zone = {
            type = 'circleZone',
            position = position,
            radius = 0.8,
            useZ = true,
            debugPoly = Config.debugPoly
        },
        options = {
            { label = "MDT Lite", },
            { label = 'Informations', },
            { label = PrintCell("Prénom", playerData.charinfo.firstname or 'N/A'), },
            { label = PrintCell("Nom", playerData.charinfo.lastname or 'N/A'), },
            { label = PrintCell("Date de naissance", playerData.charinfo.birthdate or 'N/A'), },
            { label = PrintCell("Nationalité", playerData.charinfo.nationality or 'N/A'), },
            { label = PrintCell("Citizen ID", playerData.citizenid or 'N/A'), },

            { label = 'Bracelet Electronique', },
            { label = PrintCell("Numéro de Bracelet", playerData.citizenid or 'N/A'), },
            { label = PrintCell("Actif", playerData.metadata['tracker'] and 'Oui' or 'Non'), },

            {
                label = 'Activer / Désactiver le bracelet électronique',
                icon = 'fa fa-code',
                action = function(data)
                    StopAnimTask(PlayerPedId(), "anim@heists@prison_heiststation@cop_reactions", "cop_b_idle", 1.0)
                    RequestAnimDict("anim@heists@prison_heiststation@cop_reactions")
                    while (not HasAnimDictLoaded("anim@heists@prison_heiststation@cop_reactions")) do Wait(0) end
                    TaskPlayAnim(PlayerPedId(), "anim@heists@prison_heiststation@cop_reactions", "cop_b_idle", 1.0, -1.0, 10000, 1, 1, true, true, true)
                    TriggerEvent("police:client:CheckDistance")
                    DestroyMenu(menusIndex)
                end
            },
        }
    }
end

local function InitMenuInteraction()
    local job = QBCore.Functions.GetPlayerData().job
    if job.name ~= 'police' then return end

    for k, v in pairs(Config.AnkletSetupLocation) do
        menus[k] = exports['interactionMenu']:Create {
            rotation = v.rotation,
            position = v.position,
            scale = v.scale,
            zone = v.zone,
            options = {
                {
                    picture = {
                        url = v.url,
                    }
                },
                {
                    label = v.label,
                    icon = v.icon,
                    action = function(data)
                        TriggerEvent(v.event, k)
                    end
                },
            }
        }
    end
end

local function cleanup()
    for _, menu_id in ipairs(menus) do
        exports['interactionMenu']:remove(menu_id)
    end

    menus = {}
end

local function DestroyMenu(menu_id)
    exports['interactionMenu']:remove(menus[menu_id])
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
    if (GetCurrentResourceName() ~= resourceName) then
        
    end
    cleanup()
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