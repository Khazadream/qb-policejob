local shopPed = nil
local model = 's_m_y_cop_01'

-- set config
local ShopConfig = {
    Shop = {
        coords = vector3(-403.23, -379.15, 24.1),
        heading = 354.92,
        zoneCoords = vector3(-403.13, -378.27, 25.1),
        length = 0.8,
        height = 1.4,
        zoneHeading = 350,
        minZ = 24.7,
        maxZ = 26.1,
    },
}

-- Spawn Shop Ped
local function SpawnShopPed()
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
    shopPed = CreatePed(0, model, ShopConfig.Shop.coords, ShopConfig.Shop.heading, false, false)
    SetEntityHeading(shopPed, ShopConfig.Shop.heading)
    FreezeEntityPosition(shopPed, true)
    SetBlockingOfNonTemporaryEvents(shopPed, true)
    SetEntityInvincible(shopPed, true)

    -- Create interaction on shopPed to open shop using qb-target
    exports['qb-target']:AddTargetEntity(shopPed, {
        options = {
            {
                type = 'client',
                event = 'qb-policejob:client:OpenShop',
                icon = 'fas fa-store',
                label = 'Open Shop',
                job = 'police',
            },
        },
        distance = 2.0,
    })
    exports['qb-target']:AddBoxZone("shop_zone", ShopConfig.Shop.zoneCoords, ShopConfig.Shop.length, ShopConfig.Shop.height, {
        name = "shop_zone",
        heading = ShopConfig.Shop.zoneHeading,
        debugPoly = Config.debugZone,
        minZ = ShopConfig.Shop.minZ,
        maxZ = ShopConfig.Shop.maxZ,
    }, {
        options = {
            {
                type = 'client',
                event = 'qb-policejob:client:OpenShop',
                icon = 'fas fa-store',
                label = 'Open Shop',
                job = 'police',
            },
        },
        distance = 2.0,
    })
end

-- Delete Shop Ped
local function DeleteShopPed()
    DeletePed(shopPed)
    exports['qb-target']:RemoveZone("shop_zone")
end

-- Create a function to open ox inventory shop
local function OpenShop()
    exports['ox_inventory']:openInventory('shop', {type = 'PoliceShop'})
end

-- Create a function to close ox inventory shop
local function CloseShop()
    exports['ox_inventory']:closeInventory()
end

-- Create event to open shop
RegisterNetEvent('qb-policejob:client:OpenShop', function()
    OpenShop()
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        SpawnShopPed()
    end
end)

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    SpawnShopPed()
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        DeleteShopPed()
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    DeleteShopPed()
end)