-- Variables
local SpawnedSpikes = {}
local spikemodel = `P_ld_stinger_s`
local ClosestSpike = nil

-- Functions
function GetClosestSpike()
    local pos = GetEntityCoords(PlayerPedId(), true)
    local current = nil
    local dist = nil
    local maxDistance = 50.0

    for id, _ in pairs(SpawnedSpikes) do
        local spikeCoords = vector3(SpawnedSpikes[id].coords.x, SpawnedSpikes[id].coords.y, SpawnedSpikes[id].coords.z)
        local currentDist = #(pos - spikeCoords)

        if current then
            if currentDist < dist then
                current = id
                dist = currentDist
            end
        else
            current = id
            dist = currentDist
        end
    end

    if dist and dist <= maxDistance then
        ClosestSpike = current
    else
        ClosestSpike = nil
    end
end

local function removeSpikes()
    local spike = NetToEnt(SpawnedSpikes[ClosestSpike].netid)
    NetworkRegisterEntityAsNetworked(spike)
    NetworkRequestControlOfEntity(spike)
    SetEntityAsMissionEntity(spike)
    Wait(500)
    DeleteEntity(spike)
    SpawnedSpikes[ClosestSpike] = nil
    ClosestSpike = nil
    TriggerServerEvent("qb-policejob:server:giveBackSpikesItem")
    TriggerServerEvent('police:server:SyncSpikes', SpawnedSpikes)
end

-- Events
RegisterNetEvent('police:client:SpawnSpikeStrip', function()
    if #SpawnedSpikes + 1 < Config.MaxSpikes then
        if PlayerJob.type == 'leo' and PlayerJob.onduty then
            local spawnCoords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.0, 0.0)
            local spike = CreateObject(spikemodel, spawnCoords.x, spawnCoords.y, spawnCoords.z, 1, 1, 1)
            local netid = NetworkGetNetworkIdFromEntity(spike)
            SetNetworkIdExistsOnAllMachines(netid, true)
            SetNetworkIdCanMigrate(netid, false)
            SetEntityHeading(spike, GetEntityHeading(PlayerPedId()))
            PlaceObjectOnGroundProperly(spike)
            SpawnedSpikes[#SpawnedSpikes + 1] = {
                coords = vector3(spawnCoords.x, spawnCoords.y, spawnCoords.z),
                netid = netid,
                object = spike,
            }
            TriggerServerEvent('police:server:SyncSpikes', SpawnedSpikes)
        end
    else
        QBCore.Functions.Notify(Lang:t('error.no_spikestripe'), 'error')
    end
end)

RegisterNetEvent('police:client:SyncSpikes', function(table)
    SpawnedSpikes = table
end)

RegisterNetEvent('qb-policejob:client:removePlacedSpikes', function(entity)
    QBCore.Functions.Progressbar('remove_object', Lang:t('progressbar.remove_object'), 2500, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = 'weapons@first_person@aim_rng@generic@projectile@thermal_charge@',
        anim = 'plant_floor',
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(PlayerPedId(), 'weapons@first_person@aim_rng@generic@projectile@thermal_charge@', 'plant_floor', 1.0)
        removeSpikes()
    end, function() -- Cancel
        StopAnimTask(PlayerPedId(), 'weapons@first_person@aim_rng@generic@projectile@thermal_charge@', 'plant_floor', 1.0)
        QBCore.Functions.Notify(Lang:t('error.canceled'), 'error')
    end)
end)

-- Threads
CreateThread(function()
    while true do
        local sleep = 1000
        if LocalPlayer.state.isLoggedIn then
            GetClosestSpike()

            if ClosestSpike then
                sleep = 0

                -- Vehicle Interaction (Bursting Tires)
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                if vehicle and vehicle ~= 0 then
                    local tires = {
                        { bone = 'wheel_lf', index = 0 },
                        { bone = 'wheel_rf', index = 1 },
                        { bone = 'wheel_lm', index = 2 },
                        { bone = 'wheel_rm', index = 3 },
                        { bone = 'wheel_lr', index = 4 },
                        { bone = 'wheel_rr', index = 5 }
                    }

                    for a = 1, #tires do
                        local tirePos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, tires[a].bone))
                        local spike = GetClosestObjectOfType(tirePos.x, tirePos.y, tirePos.z, 15.0, spikemodel, 1, 1, 1)
                        local spikePos = GetEntityCoords(spike, false)
                        local distance = #(tirePos - spikePos)

                        if distance < 1.8 then
                            if not IsVehicleTyreBurst(vehicle, tires[a].index, true) or IsVehicleTyreBurst(vehicle, tires[a].index, false) then
                                SetVehicleTyreBurst(vehicle, tires[a].index, false, 1000.0)
                            end
                        end
                    end
                end
            end
        end
        Wait(sleep)
    end
end)
