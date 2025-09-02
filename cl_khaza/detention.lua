Config.cloth = {
    model = 'prop_cs_t_shirt_pile',
    coords = vector3(-384.05, -407.7, 24.61),
    heading = 260.0, --80.0,
}

Config.Uniforms ={
    ['male'] = {
        outfitData ={
            ['t-shirt'] = {item = 15, texture = 0},
            ['torso2'] = {item = 345, texture = 0},
			['arms'] = {item = 19, texture = 0},
			['pants'] = {item = 3, texture = 7},
			['shoes'] = {item = 1, texture = 0},
            ['mask'] = {item = 0, texture = 0},
        }
    },
    ['female'] = {
        outfitData ={
            ['t-shirt'] = {item = 14, texture = 0},
			['torso2'] = {item = 370, texture = 0},
			['arms'] = {item = 0, texture = 0},
			['pants'] = {item = 0, texture = 12},
			['shoes'] = {item = 1, texture = 0},
            ['mask'] = {item = 0, texture = 0},
        }
    },
}

local clothObject = nil
local inDetention = false

local function loadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
end

local function ApplyDetentionCloth()
    local playerPed = PlayerPedId()
    local gender = QBCore.Functions.GetPlayerData().charinfo.gender
    if gender == 0 then
        -- Male
        TriggerEvent('qb-clothing:client:loadOutfit', Config.Uniforms.male)
        --exports['rcore_clothing']:setPedSkin(playerPed, Config.Uniforms.male)
    else
        -- Female
        TriggerEvent('qb-clothing:client:loadOutfit', Config.Uniforms.female)
        --exports['rcore_clothing']:setPedSkin(playerPed, Config.Uniforms.female)
    end
end

local function GetBackCloth()
    local playerPed = PlayerPedId()
    TriggerServerEvent('qb-clothes:loadPlayerSkin')
    --TriggerServerEvent('rcore_clothing:reloadSkin')
end

local function InitClothObject()
    loadModel(Config.cloth.model)
    clothObject = CreateObject(Config.cloth.model, Config.cloth.coords.x, Config.cloth.coords.y, Config.cloth.coords.z, false, false, false)
    SetEntityHeading(clothObject, Config.cloth.heading)

    exports['qb-target']:AddTargetEntity(clothObject, {
        options = {
            {
                num = 1,
                icon = "fas fa-cloth",
                label = "Enfiler la tenue",
                action = function()
                    ApplyDetentionCloth()
                    inDetention = true
                end,
                canInteract = function()
                    return not inDetention
                end,
            },
            {
                num = 2,
                icon = "fas fa-cloth",
                label = "Retirer la tenue",
                action = function()
                    GetBackCloth()
                    inDetention = false
                end,
                canInteract = function()
                    return inDetention
                end,
            }
        },
        distance = 2.0
      })
end

local function DeleteCloth()
    DeleteObject(clothObject)
    clothObject = nil
end

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        InitClothObject()
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        DeleteCloth()
    end
end)

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    InitClothObject()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    DeleteCloth()
end)