local shopPed = nil
local model = 's_m_y_cop_01'

-- set config
local ShopConfig = {
    Shop = {
        coords = vector3(443.11, -987.32, 29.69),
        heading = 268.86,
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
end

-- Delete Shop Ped
local function DeleteShopPed()
    DeletePed(shopPed)
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

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        DeleteShopPed()
    end
end)