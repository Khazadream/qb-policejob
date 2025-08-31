local actualIndex = 0
local menus    = {}
local subMenus = {}
local position = nil

Config.inputScript = 'ox_lib' -- accept : 'qb-input' or 'ox_lib'
Config.debugPoly = false
Config.AnkletSetupLocation = {
    [1] = {
        position = vector4(-386.0, -419.53, 25.06, 167.64),
        rotation = vector3(40, 180, -20),
        scale = 0.8,
        zone = {
            type = 'circleZone',
            position = vector4(-385.66, -418.09, 24.91, 177.01),
            radius = 0.8,
            useZ = true,
            debugPoly = Config.debugPoly
        },
        url = 'https://static.wikia.nocookie.net/morelife/images/7/7f/LSPD-logo.png/revision/latest?cb=20240305013722&path-prefix=fr',
        label = 'Configurer un bracelet électronique',
        icon = 'fa fa-code',
        event = 'qb-policejob:client:getNearestSuspect',
        deleteOnAction = true,
    },
    [2] = {
        position = vector4(-391.15, -418.59, 25.06, 167.76),
        rotation = vector3(40, 180, -20),
        scale = 0.8,
        zone = {
            type = 'circleZone',
            position = vector4(-390.59, -417.2, 24.91, 169.39),
            radius = 0.8,
            useZ = true,
            debugPoly = Config.debugPoly
        },
        url = 'https://static.wikia.nocookie.net/morelife/images/7/7f/LSPD-logo.png/revision/latest?cb=20240305013722&path-prefix=fr',
        label = 'Configurer un bracelet électronique',
        icon = 'fa fa-code',
        event = 'qb-policejob:client:getNearestSuspect',
        deleteOnAction = true,
    },
    [3] = {
        position = vector4(-384.58, -414.83, 25.06, 350.24),
        rotation = vector3(40, 180, 150),
        scale = 0.8,
        zone = {
            type = 'circleZone',
            position = vector4(-385.27, -416.2, 24.91, 351.1),
            radius = 0.8,
            useZ = true,
            debugPoly = Config.debugPoly
        },
        url = 'https://static.wikia.nocookie.net/morelife/images/7/7f/LSPD-logo.png/revision/latest?cb=20240305013722&path-prefix=fr',
        label = 'Configurer un bracelet électronique',
        icon = 'fa fa-code',
        event = 'qb-policejob:client:getNearestSuspect',
        deleteOnAction = true,
    },
    [4] = {
        position = vector4(-391.95, -414.88, 25.06, 81.45),
        rotation = vector3(40, 180, 240),
        scale = 0.8,
        zone = {
            type = 'circleZone',
            position = vector4(-390.51, -415.35, 24.91, 82.39),
            radius = 0.8,
            useZ = true,
            debugPoly = Config.debugPoly
        },
        url = 'https://static.wikia.nocookie.net/morelife/images/7/7f/LSPD-logo.png/revision/latest?cb=20240305013722&path-prefix=fr',
        label = 'Configurer un bracelet électronique',
        icon = 'fa fa-code',
        event = 'qb-policejob:client:getNearestSuspect',
        deleteOnAction = true,
    },
    [5] = {
        position = vector4(-373.84, -354.75, 48.53, 171.28),
        rotation = vector3(40, 180, 340),
        scale = 0.8,
        zone = {
            type = 'circleZone',
            position = vector4(-373.45, -353.5, 48.53, 173.93),
            radius = 0.8,
            useZ = true,
            debugPoly = Config.debugPoly
        },
        url = 'https://static.wikia.nocookie.net/morelife/images/7/7f/LSPD-logo.png/revision/latest?cb=20240305013722&path-prefix=fr',
        label = 'Traquer un bracelet électronique',
        icon = 'fa fa-code',
        event = 'qb-policejob:client:ankletLocation',
        deleteOnAction = false,
    },
}

local function PrintCell(label, value)
    return (
        '<div style="display: flex; flex-direction: column; gap: 0.5rem; width: 564px;">' ..
            ('<div style="font-weight: 900; font-family: Helvetica, sans-serif; text-align: left;text-transform: uppercase;">' .. label .. '</div>') ..
            ('<div style="text-align: left; font-family: Helvetica, sans-serif;font-weight: 200;">' .. value .. '</div>') ..
        '</div>'
    )
end

local function CreateInitMenu(index)
    menus[index] = exports['interactionMenu']:Create {
        rotation = Config.AnkletSetupLocation[index].rotation,
        position = Config.AnkletSetupLocation[index].position,
        scale = Config.AnkletSetupLocation[index].scale,
        zone = Config.AnkletSetupLocation[index].zone,
        options = {
            {
                picture = {
                    url = Config.AnkletSetupLocation[index].url,
                }
            },
            {
                label = Config.AnkletSetupLocation[index].label,
                icon = Config.AnkletSetupLocation[index].icon,
                action = function(data)
                    TriggerEvent(Config.AnkletSetupLocation[index].event, index)
                    exports['interactionMenu']:remove(menus[index])
                    actualIndex = index
                end
            },
        }
    }
end

function SetUpAnkletMenu(suspectPlayerData)
    local playerData = suspectPlayerData
    local menusIndex = #menus
    local index = actualIndex or 1
    subMenus[index] = exports['interactionMenu']:Create {
        rotation = Config.AnkletSetupLocation[index].rotation, --vector3(40, 180, -20), --vector3(-40, 0, 270),
        position = Config.AnkletSetupLocation[index].position, --vector4(-386.0, -419.53, 25.06, 167.64), --position,
        scale = Config.AnkletSetupLocation[index].scale,
        zone = {
            type = 'circleZone',
            position = Config.AnkletSetupLocation[index].zone.position, -- vector4(-385.66, -418.09, 25.1, 177.01),
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
                    TriggerEvent("police:client:CheckDistance")
                    exports['interactionMenu']:remove(subMenus[index])
                    CreateInitMenu(index)
                    actualIndex = index
                end
            },
            {
                label = 'Fermer le menu',
                icon = 'fa fa-code',
                action = function(data)
                    exports['interactionMenu']:remove(subMenus[index])
                    CreateInitMenu(index)
                    actualIndex = index
                end
            },
        }
    }
end

function InitMenuInteraction()
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
                        if v.deleteOnAction then
                            exports['interactionMenu']:remove(menus[k])
                        end
                        actualIndex = k
                    end
                },
            }
        }
    end
end

function Cleanup()
    for k, v in pairs(menus) do
        exports['interactionMenu']:remove(v)
    end
    for k, v in pairs(subMenus) do
        exports['interactionMenu']:remove(v)
    end
end

RegisterNetEvent('qb-policejob:client:getNearestSuspect', function(index)
    local player, distance = QBCore.Functions.GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then 
        local playerId = GetPlayerServerId(player)
        TriggerServerEvent('qb-policejob:server:getSuspectPlayerData', playerId)
    else
        QBCore.Functions.Notify(Lang:t('error.none_nearby'), 'error')
        CreateInitMenu(index)
    end
end)

RegisterNetEvent('qb-policejob:client:ankletLocation', function(data)
    if Config.inputScript == 'qb-input' then
        local anklet = exports['qb-input']:ShowInput({
            header = "Saisir l'identifiant du Citoyen",
            submitText = "Lancer la recherche",
            inputs = {
                {
                    text = "Citizen ID (#)", -- text you want to be displayed as a input header
                    name = "citizenid", -- name of the input should be unique otherwise it might override
                    type = "text",
                    isRequired = true,
                }
            },
        })

        if anklet ~= nil then
            TriggerServerEvent('qb-policejob:server:ankletlocation', anklet.citizenid)
        else
            QBCore.Functions.Notify('Erreur : CitizenID invalide !', 'error')
        end
    elseif Config.inputScript == 'ox_lib' then
        local anklet = lib.inputDialog("Localiser un bracelet", {
            {type = 'input', label = 'Citizen ID', description = "Saisir l'identifiant du Citoyen", required = true, min = 4, max = 16}
        })

        if anklet ~= nil then
            TriggerServerEvent('qb-policejob:server:ankletlocation', anklet[1])
        else
            QBCore.Functions.Notify('Erreur : CitizenID invalide !', 'error')
        end
    else
        print("Error : Config.inputScript is not configure. Use ox_lib or qb-input")
    end
end)

RegisterNetEvent('qb-policejob:client:notifySuspect', function()
    QBCore.Functions.Notify('Votre bracelet vibre !', 'primary')
    PlaySound(-1, 'Lose_1st', 'GTAO_FM_Events_Soundset', 0, 0, 1)
end)