local suspectMugshotZone
local insideSuspectZone = nil
suspectMugshotCitizenId = nil
Config.mugshotZone = {
    [1] = {
        coords = vector3(-388.55, -387.01, 25.1), length = 0.25, height = 0.25, heading = 350, minZ = 24.9, maxZ = 25.2, 
        cameraPos = vector3(-392.05, -386.93, 25.6),--vector3(-392.45, -386.84, 25.8),--vector3(-392.24, -386.74, 25.9),  vector4(-392.45, -386.84, 25.1, 81.5)
        cameraRot = vector3(0, 0, 79.72),--vector3(0, 0, 79.72)
    },
    --[2] = ,
}

Config.suspectMugshotZone = { coords = vector3(-391.13, -387.22, 25.1), length = 3.4, height = 4.4, heading = 350, minZ = 24.1, maxZ = 27.1 }

local function GenerateMugshotZones()
    for k, v in pairs(Config.mugshotZone) do
        exports['qb-target']:AddBoxZone("_mugshotZone_"..k, vector3(v.coords.x, v.coords.y, v.coords.z), v.length, v.height, {
            name = "_mugshotZone_"..k,
            debugPoly = Config.debugZone,
            heading = v.heading,
            minZ = v.minZ,
            maxZ = v.maxZ,
        }, {
            options = {
                {
                    type = "client",
                    event = "qb-policejob:client:setupMugshotCamera",
                    icon = "fa fa-camera",
                    label = "Prendre une photo",
                    job = "police",
                }
            },
        distance = 1.5
        })
    end

    suspectMugshotZone = BoxZone:Create(Config.suspectMugshotZone.coords, Config.suspectMugshotZone.length, Config.suspectMugshotZone.height, {
        name = "mugshotBoxZone",
        heading = Config.suspectMugshotZone.heading,
        --debugPoly = true,
        minZ = Config.suspectMugshotZone.minZ,
        maxZ = Config.suspectMugshotZone.maxZ
    })

    suspectMugshotZone:onPlayerInOut(function(isPointInside, point)
        insideSuspectZone = isPointInside
        TriggerServerEvent("qb-policejob:server:mugshotZoneRef")
    end)

end

local function DestroyMugshotZones()
    for k, v in pairs(Config.mugshotZone) do
        exports['qb-target']:RemoveZone("_mugshotZone_"..k)
    end
end

local cam = nil

local function StopCam()
    RenderScriptCams(0, true, 900, true, true)
    DestroyCam(cam, 0)
    --AnimpostfxStopAll()
    TriggerEvent('set-hud-visible', true)
end

local isTakingPhoto = false
local function TakePhoto()
    --exports['qb-core']:HideText()
    RegisterPhoto(suspectMugshotCitizenId)
    StopCam()
    exports['qb-core']:Notify('Photo prise avec succès', 'success')
end

local function SetupCamera(isOfficer)
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    local pos = Config.mugshotZone[1].cameraPos
    local rot = Config.mugshotZone[1].cameraRot
    SetCamCoord(cam, pos.x, pos.y, pos.z)
    SetCamRot(cam, rot.x, rot.y, rot.z, 2)

    RenderScriptCams(true, true, 1000, true, true)
    --AnimpostfxPlay('HeistCelebEnd', 30000, true)
    TriggerEvent('set-hud-visible', false)
    isTakingPhoto = true
    --exports['qb-core']:DrawText('E - Prendre une photo', 'left')

    -- CreateThread(function()
    --     while isTakingPhoto do
    --         Wait(0)
    --         if IsControlJustPressed(0, 38) then
    --             isTakingPhoto = false
    --             TakePhoto()
    --         end
    --     end
    -- end)

    SetTimeout(5000, function()
        if isOfficer then
            RegisterPhoto(suspectMugshotCitizenId)
            exports['qb-core']:Notify('Photo prise avec succès', 'success')
        end
    end)

    -- Security Time Out
    SetTimeout(10000, function()
        if isTakingPhoto then
            isTakingPhoto = false
            --exports['qb-core']:HideText()
            StopCam()
            --exports['qb-core']:Notify('Temps d\'expiration de la photo', 'error')
        end
    end)
end

RegisterNetEvent('qb-policejob:client:setupMugshotCamera', function()
    --SetupCamera()
    TriggerServerEvent("qb-policejob:server:getSuspectMugshotId")
end)

RegisterNetEvent('qb-policejob:client:getSuspectMugshotId', function(SuspectId, SuspectCitizenID)
    SetupCamera(true)
    suspectMugshotCitizenId = SuspectCitizenID
    TriggerServerEvent("kael-mugshot:server:takemugshot", SuspectId)
end)

RegisterNetEvent('qb-policejob:client:suspectMugshotCamSetup', function(SuspectId, SuspectCitizenID)
    SetupCamera(false)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        GenerateMugshotZones()
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        DestroyMugshotZones()
    end
end)

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    GenerateMugshotZones()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    DestroyMugshotZones()
end)