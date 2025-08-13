Config.debugZone = true
Config.surveillanceZone = {
    [1] = {coords = vector3(-374.23, -348.9, 48.53), length = 3.05, height = 0.9, heading = 351, minZ = 47.53, maxZ = 49.13},
    --[2] = ,
}

local function GenerateCameraZones()
    for k, v in pairs(Config.surveillanceZone) do
        exports['qb-target']:AddBoxZone("_surveillanceZone_"..k, vector3(v.coords.x, v.coords.y, v.coords.z), v.length, v.height, {
            name = "_surveillanceZone_"..k,
            debugPoly = Config.debugZone,
            heading = v.heading,
            minZ = v.minZ,
            maxZ = v.maxZ,
        }, {
            options = {
                {
                    type = "client",
                    event = "qb-policejob:client:cameraMenuInput",
                    icon = "fa fa-clipboard",
                    label = "Visioner les cameras",
                    job = "police",
                }
            },
        distance = 1.5
        })
    end
end

local function DestroyCameraZones()
    for k, v in pairs(Config.surveillanceZone) do
        exports['qb-target']:RemoveZone("_surveillanceZone_"..k)
    end
end


RegisterNetEvent('qb-policejob:client:cameraMenuInput', function()
    local camera = exports['qb-input']:ShowInput({
        header = "Camera",
        submitText = "Visionner",
        inputs = {
            {
                text = "1, 2, 3..",
                name = "cameraNum",
                type = "number",
                isRequired = true,
                default = 0,
            }
        }
    })
    if camera ~= nil then
        -- TODO : Play a type animation (optional)
        TriggerEvent('police:client:ActiveCamera', tonumber(camera.cameraNum))
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        GenerateCameraZones()
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        DestroyCameraZones()
    end
end)