local animDictionary = "anim@heists@prison_heiststation@cop_reactions"
local animName = "cop_b_idle"

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

local function LoadAndPlayAnim()
    RequestAnimDict(animDictionary)
    while (not HasAnimDictLoaded(animDictionary)) do Wait(0) end
    TaskPlayAnim(PlayerPedId(), animDictionary, animName, 1.0, -1.0, 10000, 1, 1, true, true, true)
end

RegisterNetEvent('qb-policejob:client:getNearestSuspect', function(index)
    -- SetUpAnkletMenu()

    local player, distance = QBCore.Functions.GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then 
        --LoadAndPlayAnim()
        local playerId = GetPlayerServerId(player)
        TriggerServerEvent('qb-policejob:server:getSuspectPlayerData', playerId)
    else
        QBCore.Functions.Notify(Lang:t('error.none_nearby'), 'error')
        CreateInitMenu(index)
    end
end)

RegisterNetEvent('qb-policejob:client:ankletLocation', function(data)
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

end)

RegisterNetEvent('qb-policejob:client:notifySuspect', function()

    QBCore.Functions.Notify('Votre bracelet vibre !', 'primary')

    PlaySound(-1, 'Lose_1st', 'GTAO_FM_Events_Soundset', 0, 0, 1)

end)