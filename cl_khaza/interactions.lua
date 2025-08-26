local PlayerHandcuffs = {}

Config.AnkletSetupLocation = {
    [1] = {
        position = vector4(-386.0, -419.53, 25.06, 167.64),
        rotation = vector3(40, 180, -20),
        scale = 0.8,
        zone = {
            type = 'circleZone',
            position = vector4(-385.66, -418.09, 25.1, 177.01),
            radius = 0.8,
            useZ = true,
            debugPoly = Config.debugPoly
        },
        url = 'https://static.wikia.nocookie.net/morelife/images/7/7f/LSPD-logo.png/revision/latest?cb=20240305013722&path-prefix=fr',
        label = 'Configurer un bracelet électronique',
        icon = 'fa fa-code',
    },
    [2] = {
        position = vector4(-391.15, -418.59, 25.06, 167.76),
        rotation = vector3(40, 180, -20),
        scale = 0.8,
        zone = {
            type = 'circleZone',
            position = vector4(-390.59, -417.2, 25.1, 169.39),
            radius = 0.8,
            useZ = true,
            debugPoly = Config.debugPoly
        },
        url = 'https://static.wikia.nocookie.net/morelife/images/7/7f/LSPD-logo.png/revision/latest?cb=20240305013722&path-prefix=fr',
        label = 'Configurer un bracelet électronique',
        icon = 'fa fa-code',
    },
}

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

local function SetUpAnklet(suspectPlayerData)

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
                    RequestAnimDict("anim@heists@prison_heiststation@cop_reactions")
                    while (not HasAnimDictLoaded("anim@heists@prison_heiststation@cop_reactions")) do Wait(0) end
                    TaskPlayAnim(PlayerPedId(), "anim@heists@prison_heiststation@cop_reactions", "cop_b_idle", 1.0, -1.0, 10000, 1, 1, true, true, true)
                    TriggerEvent("police:client:CheckDistance")
                end
            },
        }
    }

end

local function InitMenuInteraction()

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
                        RequestAnimDict("anim@heists@prison_heiststation@cop_reactions")
                        while (not HasAnimDictLoaded("anim@heists@prison_heiststation@cop_reactions")) do Wait(0) end
                        TaskPlayAnim(PlayerPedId(), "anim@heists@prison_heiststation@cop_reactions", "cop_b_idle", 1.0, -1.0, 10000, 1, 1, true, true, true)
                        TriggerEvent("qb-policejob:client:getNearestSuspect", k)
                    end
                },
            }
        }

    end


    -- position          = vector4(-390.59, -417.2, 25.1, 169.39)
    -- menus[#menus + 1] = exports['interactionMenu']:Create {
    --     rotation = vector3(40, 180, -20),
    --     position = vector4(-390.9, -418.59, 25.17, 167.76), --position,
    --     scale = 1,
    --     zone = {
    --         type = 'boxZone',
    --         position = position,
    --         heading = position.w,
    --         width = 1.0,
    --         length = 1.0,
    --         debugPoly = Config.debugPoly,
    --         minZ = position.z - 1,
    --         maxZ = position.z + 1,
    --     },
    --     options = {
    --         {
    --             picture = {
    --                 url = 'https://static.wikia.nocookie.net/morelife/images/7/7f/LSPD-logo.png/revision/latest?cb=20240305013722&path-prefix=fr',
    --             }
    --         },
    --         {
    --             label = 'Configurer un bracelet électronique',
    --             icon = 'fa fa-code',
    --             action = function(data)
    --                 RequestAnimDict("anim@heists@prison_heiststation@cop_reactions")
    --                 while (not HasAnimDictLoaded("anim@heists@prison_heiststation@cop_reactions")) do Wait(0) end
    --                 TaskPlayAnim(PlayerPedId(), "anim@heists@prison_heiststation@cop_reactions", "cop_b_idle", 1.0, -1.0, 10000, 1, 1, true, true, true)
    --                 local zoneId = 
    --                 TriggerEvent("qb-policejob:client:getNearestSuspect", zoneId)
    --             end
    --         },
    --     }
    -- }

    -- position          = vector4(-385.66, -418.09, 25.1, 177.01)
    -- menus[#menus + 1] = exports['interactionMenu']:Create {
    --     rotation = vector3(40, 180, -20), --vector3(-40, 0, 270),
    --     position = vector4(-386.0, -419.53, 25.06, 167.64), --position,
    --     scale = 0.8,
    --     zone = {
    --         type = 'circleZone',
    --         position = position,
    --         radius = 0.8,
    --         useZ = true,
    --         debugPoly = Config.debugPoly
    --     },
    --     options = {
    --         {
    --             picture = {
    --                 url = 'https://static.wikia.nocookie.net/morelife/images/7/7f/LSPD-logo.png/revision/latest?cb=20240305013722&path-prefix=fr',
    --             }
    --         },
    --         {
    --             label = 'Configurer un bracelet électronique',
    --             icon = 'fa fa-code',
    --             action = function(data)
    --                 RequestAnimDict("anim@heists@prison_heiststation@cop_reactions")
    --                 while (not HasAnimDictLoaded("anim@heists@prison_heiststation@cop_reactions")) do Wait(0) end
    --                 TaskPlayAnim(PlayerPedId(), "anim@heists@prison_heiststation@cop_reactions", "cop_b_idle", 1.0, -1.0, 10000, 1, 1, true, true, true)
    --                 TriggerEvent("qb-policejob:client:getNearestSuspect")
    --             end
    --         },
    --     }
    -- }
end

local function cleanup()
    for _, menu_id in ipairs(menus) do
        exports['interactionMenu']:remove(menu_id)
    end

    menus = {}
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
    SetUpAnklet(suspectPlayerData)
end)