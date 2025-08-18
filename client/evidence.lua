-- Variables
local CurrentStatusList = {}
local Casings = {}
local Bullets = {}
local CurrentCasing = nil
local CurrentBullet = nil
local Blooddrops = {}
local CurrentBlooddrop = nil
local Fingerprints = {}
local CurrentFingerprint = 0
local shotAmount = 0

local StatusList = {
    ['fight'] = Lang:t('evidence.red_hands'),
    ['widepupils'] = Lang:t('evidence.wide_pupils'),
    ['redeyes'] = Lang:t('evidence.red_eyes'),
    ['weedsmell'] = Lang:t('evidence.weed_smell'),
    ['gunpowder'] = Lang:t('evidence.gunpowder'),
    ['chemicals'] = Lang:t('evidence.chemicals'),
    ['heavybreath'] = Lang:t('evidence.heavy_breathing'),
    ['sweat'] = Lang:t('evidence.sweat'),
    ['handbleed'] = Lang:t('evidence.handbleed'),
    ['confused'] = Lang:t('evidence.confused'),
    ['alcohol'] = Lang:t('evidence.alcohol'),
    ['heavyalcohol'] = Lang:t('evidence.heavy_alcohol'),
    ['agitated'] = Lang:t('evidence.agitated')
}

local WhitelistedWeapons = {
    `weapon_unarmed`,
    `weapon_snowball`,
    `weapon_stungun`,
    `weapon_petrolcan`,
    `weapon_hazardcan`,
    `weapon_fireextinguisher`
}

-- Functions
local function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    BeginTextCommandDisplayText('STRING')
    SetTextCentre(true)
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(x, y, z, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local function WhitelistedWeapon(weapon)
    for i = 1, #WhitelistedWeapons do
        if WhitelistedWeapons[i] == weapon then
            return true
        end
    end
    return false
end

local function DropBulletCasing(weapon, ped)
    local randX = math.random() + math.random(-1, 1)
    local randY = math.random() + math.random(-1, 1)
    local coords = GetOffsetFromEntityInWorldCoords(ped, randX, randY, 0)
    TriggerServerEvent('evidence:server:CreateCasing', weapon, coords)
    Wait(300)
end

-- local function DropBulletImpact(weapon, ped)
--     local maxAttempts = 5
--     local attempt = 0
--     local impactCoords = nil
--     local success = false

--     while attempt < maxAttempts do
--         success, impactCoords = GetPedLastWeaponImpactCoord(ped)
--         if success and impactCoords and #(impactCoords - vector3(0.0, 0.0, 0.0)) > 0.1 then
--             break
--         end
--         attempt = attempt + 1
--         Wait(100)
--     end

--     if success and impactCoords and #(impactCoords - vector3(0.0, 0.0, 0.0)) > 0.1 then
--         TriggerServerEvent('evidence:server:CreateBulletImpact', weapon, impactCoords)
--         return true
--     end

--     return false
-- end

-- helper: quick raycast from -> to
local function RaycastToPoint(from, to, ignore)
    local handle = StartShapeTestRay(from.x, from.y, from.z, to.x, to.y, to.z, -1, ignore, 0)
    local _, hit, endPos, _, entityHit = GetShapeTestResult(handle)
    return hit == 1, endPos, entityHit
end

-- drop one bullet impact; player vs world go to different server events
local function DropBulletImpact(weapon, ped)
    local maxAttempts, attempt = 5, 0
    local success, impactCoords

    -- wait a tick for the engine to register an impact
    while attempt < maxAttempts do
        success, impactCoords = GetPedLastWeaponImpactCoord(ped)
        if success and impactCoords and #(impactCoords - vector3(0.0, 0.0, 0.0)) > 0.1 then
            break
        end
        attempt = attempt + 1
        Wait(60)
    end

    if not (success and impactCoords) then
        return false
    end

    local shooterPos = GetEntityCoords(ped)
    local hit, _, entityHit = RaycastToPoint(shooterPos, impactCoords, ped)

    if hit and entityHit ~= 0 and GetEntityType(entityHit) == 1 and IsPedAPlayer(entityHit) then
        -- hit a player
        local tgtPlayerIdx = NetworkGetPlayerIndexFromPed(entityHit)
        if tgtPlayerIdx ~= -1 then
            local targetServerId = GetPlayerServerId(tgtPlayerIdx)
            local _, bone = GetPedLastDamageBone(entityHit)  -- optional, 0 if unknown
            TriggerServerEvent('evidence:server:CreateBulletImpactOnPlayer', weapon, {
                target = targetServerId,
                bone = bone or 0
            })
            return true
        end
    end

    -- world / wall hit
    TriggerServerEvent('evidence:server:CreateBulletImpact', weapon, impactCoords)
    return true
end


local function DnaHash(s)
    local h = string.gsub(s, '.', function(c)
        return string.format('%02x', string.byte(c))
    end)
    return h
end

-- Events
RegisterNetEvent('evidence:client:SetStatus', function(statusId, time)
    if time > 0 and StatusList[statusId] then
        if (CurrentStatusList == nil or CurrentStatusList[statusId] == nil) or
            (CurrentStatusList[statusId] and CurrentStatusList[statusId].time < 20) then
            CurrentStatusList[statusId] = {
                text = StatusList[statusId],
                time = time
            }
            QBCore.Functions.Notify(CurrentStatusList[statusId].text, 'error')
        end
    elseif StatusList[statusId] then
        CurrentStatusList[statusId] = nil
    end
    TriggerServerEvent('evidence:server:UpdateStatus', CurrentStatusList)
end)

RegisterNetEvent('evidence:client:AddBlooddrop', function(bloodId, citizenid, bloodtype, coords)
    Blooddrops[bloodId] = {
        citizenid = citizenid,
        bloodtype = bloodtype,
        coords = {
            x = coords.x,
            y = coords.y,
            z = coords.z - 0.9
        }
    }
end)

RegisterNetEvent('evidence:client:RemoveBlooddrop', function(bloodId)
    Blooddrops[bloodId] = nil
    CurrentBlooddrop = 0
end)

RegisterNetEvent('evidence:client:AddFingerPrint', function(fingerId, fingerprint, coords)
    Fingerprints[fingerId] = {
        fingerprint = fingerprint,
        coords = {
            x = coords.x,
            y = coords.y,
            z = coords.z - 0.9
        }
    }
end)

RegisterNetEvent('evidence:client:RemoveFingerprint', function(fingerId)
    Fingerprints[fingerId] = nil
    CurrentFingerprint = 0
end)

RegisterNetEvent('evidence:client:ClearBlooddropsInArea', function()
    local pos = GetEntityCoords(PlayerPedId())
    local blooddropList = {}
    QBCore.Functions.Progressbar('clear_blooddrops', Lang:t('progressbar.blood_clear'), 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true
    }, {}, {}, {}, function() -- Done
        if Blooddrops and next(Blooddrops) then
            for bloodId, _ in pairs(Blooddrops) do
                if #(pos -
                        vector3(Blooddrops[bloodId].coords.x, Blooddrops[bloodId].coords.y, Blooddrops[bloodId].coords.z)) <
                    10.0 then
                    blooddropList[#blooddropList + 1] = bloodId
                end
            end
            TriggerServerEvent('evidence:server:ClearBlooddrops', blooddropList)
            QBCore.Functions.Notify(Lang:t('success.blood_clear'), 'success')
        end
    end, function() -- Cancel
        QBCore.Functions.Notify(Lang:t('error.blood_not_cleared'), 'error')
    end)
end)

RegisterNetEvent('evidence:client:AddCasing', function(casingId, weapon, coords, serie, ammoType)
    Casings[casingId] = {
        type = weapon,
        serie = serie and serie or Lang:t('evidence.serial_not_visible'),
        ammoType = ammoType,
        coords = {
            x = coords.x,
            y = coords.y,
            z = coords.z - 0.9
        }
    }
end)

-- RegisterNetEvent('evidence:client:AddBulletImpact', function(casingId, weapon, coords, serie, ammoType)
--     Bullets[casingId] = {
--         type = weapon,
--         serie = serie and serie or Lang:t('evidence.serial_not_visible'),
--         ammoType = ammoType,
--         coords = {
--             x = coords.x,
--             y = coords.y,
--             z = coords.z
--         }
--     }
-- end)

-- Bullet impact world / wall
RegisterNetEvent('evidence:client:AddBulletImpact', function(bulletId, weapon, coords, serie, ammoType)
    Bullets[bulletId] = {
        type = weapon,
        serie = serie or Lang:t('evidence.serial_not_visible'),
        ammoType = ammoType,
        coords = { x = coords.x, y = coords.y, z = coords.z }
    }
end)

-- Bullet impact player
RegisterNetEvent('evidence:client:AddBulletImpactOnPlayer', function(bulletId, bullet)
    Bullets[bulletId] = bullet
end)

RegisterNetEvent('evidence:client:RemoveCasing', function(casingId)
    Casings[casingId] = nil
    CurrentCasing = 0
end)

RegisterNetEvent('evidence:client:RemoveBulletImpact', function(bulletId)
    Bullets[bulletId] = nil
    CurrentBullet = 0
end)

RegisterNetEvent('evidence:client:ClearCasingsInArea', function()
    local pos = GetEntityCoords(PlayerPedId())
    local casingList = {}
    QBCore.Functions.Progressbar('clear_casings', Lang:t('progressbar.bullet_casing'), 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true
    }, {}, {}, {}, function() -- Done
        if Casings and next(Casings) then
            for casingId, _ in pairs(Casings) do
                if #(pos - vector3(Casings[casingId].coords.x, Casings[casingId].coords.y, Casings[casingId].coords.z)) <
                    10.0 then
                    casingList[#casingList + 1] = casingId
                end
            end
            TriggerServerEvent('evidence:server:ClearCasings', casingList)
            QBCore.Functions.Notify(Lang:t('success.bullet_casing_removed'), 'success')
        end
    end, function() -- Cancel
        QBCore.Functions.Notify(Lang:t('error.bullet_casing_not_removed'), 'error')
    end)
end)

-- Threads

CreateThread(function()
    while true do
        Wait(10000)
        if LocalPlayer.state.isLoggedIn then
            if CurrentStatusList and next(CurrentStatusList) then
                for k, _ in pairs(CurrentStatusList) do
                    if CurrentStatusList[k].time > 0 then
                        CurrentStatusList[k].time = CurrentStatusList[k].time - 10
                    else
                        CurrentStatusList[k].time = 0
                    end
                end
                TriggerServerEvent('evidence:server:UpdateStatus', CurrentStatusList)
            end
            if shotAmount > 0 then
                shotAmount = 0
            end
        end
    end
end)

CreateThread(function() -- Gunpowder Status when shooting
    while true do
        Wait(1)
        local ped = PlayerPedId()
        if IsPedShooting(ped) then
            local weapon = GetSelectedPedWeapon(ped)
            if not WhitelistedWeapon(weapon) then
                shotAmount = shotAmount + 1
                if shotAmount > 5 and (CurrentStatusList == nil or CurrentStatusList['gunpowder'] == nil) then
                    if math.random(1, 10) <= 7 then
                        TriggerEvent('evidence:client:SetStatus', 'gunpowder', 200)
                    end
                end
                DropBulletCasing(weapon, ped)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local ped = GetPlayerPed(-1)
        if IsPedShooting(ped) then
            local weapon = GetSelectedPedWeapon(ped)
            if not WhitelistedWeapon(weapon) then
                if DropBulletImpact(weapon, ped) then
                    Wait(1000)
                end
            end
        end
    end
end)

CreateThread(function()
    local isDoingAction = false
    while true do
        Wait(1)
        if CurrentCasing and CurrentCasing ~= 0 then
            local pos = GetEntityCoords(PlayerPedId())
            if #(pos - vector3(Casings[CurrentCasing].coords.x, Casings[CurrentCasing].coords.y, Casings[CurrentCasing].coords.z)) < 2.5 then
                DrawText3D(Casings[CurrentCasing].coords.x, Casings[CurrentCasing].coords.y, Casings[CurrentCasing].coords.z, Lang:t('info.bullet_casing', { value = Casings[CurrentCasing].ammoType }))
                if IsControlJustReleased(0, 47) and not isDoingAction then
                    isDoingAction = true
                    local cc = Casings[CurrentCasing]
                    local s1, s2 = GetStreetNameAtCoord(cc.coords.x, cc.coords.y, cc.coords.z)
                    local street1 = GetStreetNameFromHashKey(s1)
                    local street2 = GetStreetNameFromHashKey(s2)
                    local streetLabel = street1
                    if street2 then
                        streetLabel = streetLabel .. ' | ' .. street2
                    end
                    local info = {
                        label = Lang:t('info.casing'),
                        type = 'casing',
                        street = streetLabel:gsub("%'", ''),
                        ammolabel = cc.ammoType,
                        ammotype = cc.type,
                        serie = cc.serie
                    }
                    local animDict = "pickup_object"
                    local animName = "pickup_low"
                    loadAnimDict(animDict)
                    TaskPlayAnim(PlayerPedId(), animDict, animName, 8.0, 8.0, -1, 57, 1.0, false, false, false)
                    QBCore.Functions.Progressbar('add_to_inventory', 'Récupération de la preuve', 1500, false, true, {
                        disableMovement = false,
                        disableCarMovement = false,
                        disableMouse = false,
                        disableCombat = true
                    }, {}, {}, {}, function()
                        TriggerServerEvent('evidence:server:AddCasingToInventory', CurrentCasing, info)
                        isDoingAction = false
                    end, function()
                        isDoingAction = false
                    end)
                end
            end
        end

        if CurrentBlooddrop and CurrentBlooddrop ~= 0 then
            local pos = GetEntityCoords(PlayerPedId())
            if #(pos - vector3(Blooddrops[CurrentBlooddrop].coords.x, Blooddrops[CurrentBlooddrop].coords.y,
                    Blooddrops[CurrentBlooddrop].coords.z)) < 2.5 then
                DrawText3D(Blooddrops[CurrentBlooddrop].coords.x, Blooddrops[CurrentBlooddrop].coords.y, Blooddrops[CurrentBlooddrop].coords.z, Lang:t('info.blood_text', { value = DnaHash(Blooddrops[CurrentBlooddrop].citizenid) }))
                if IsControlJustReleased(0, 47) then
                    local s1, s2 = GetStreetNameAtCoord(Blooddrops[CurrentBlooddrop].coords.x, Blooddrops[CurrentBlooddrop].coords.y, Blooddrops[CurrentBlooddrop].coords.z)
                    local street1 = GetStreetNameFromHashKey(s1)
                    local street2 = GetStreetNameFromHashKey(s2)
                    local streetLabel = street1
                    if street2 then
                        streetLabel = streetLabel .. ' | ' .. street2
                    end
                    local info = {
                        label = Lang:t('info.blood'),
                        type = 'blood',
                        street = streetLabel:gsub("%'", ''),
                        dnalabel = DnaHash(Blooddrops[CurrentBlooddrop].citizenid),
                        bloodtype = Blooddrops[CurrentBlooddrop].bloodtype
                    }
                    TriggerServerEvent('evidence:server:AddBlooddropToInventory', CurrentBlooddrop, info)
                end
            end
        end

        if CurrentFingerprint and CurrentFingerprint ~= 0 then
            local pos = GetEntityCoords(PlayerPedId())
            if #(pos - vector3(Fingerprints[CurrentFingerprint].coords.x, Fingerprints[CurrentFingerprint].coords.y,
                    Fingerprints[CurrentFingerprint].coords.z)) < 2.5 then
                DrawText3D(Fingerprints[CurrentFingerprint].coords.x, Fingerprints[CurrentFingerprint].coords.y, Fingerprints[CurrentFingerprint].coords.z, Lang:t('info.fingerprint_text'))
                if IsControlJustReleased(0, 47) then
                    local s1, s2 = GetStreetNameAtCoord(Fingerprints[CurrentFingerprint].coords.x, Fingerprints[CurrentFingerprint].coords.y, Fingerprints[CurrentFingerprint].coords.z)
                    local street1 = GetStreetNameFromHashKey(s1)
                    local street2 = GetStreetNameFromHashKey(s2)
                    local streetLabel = street1
                    if street2 then
                        streetLabel = streetLabel .. ' | ' .. street2
                    end
                    local info = {
                        label = Lang:t('info.fingerprint'),
                        type = 'fingerprint',
                        street = streetLabel:gsub("%'", ''),
                        fingerprint = Fingerprints[CurrentFingerprint].fingerprint
                    }
                    TriggerServerEvent('evidence:server:AddFingerprintToInventory', CurrentFingerprint, info)
                end
            end
        end

        -- ========== BULLET IMPACTS ==========
        if CurrentBullet and CurrentBullet ~= 0 then
            local pos = GetEntityCoords(PlayerPedId())
            if #(pos - vector3(Bullets[CurrentBullet].coords.x, Bullets[CurrentBullet].coords.y, Bullets[CurrentBullet].coords.z)) < 2.5 then
                DrawText3D(
                    Bullets[CurrentBullet].coords.x,
                    Bullets[CurrentBullet].coords.y,
                    Bullets[CurrentBullet].coords.z,
                    Lang:t('info.bullet_impact_text')
                )
                if IsControlJustReleased(0, 47) and not isDoingAction then
                    isDoingAction = true
                    local bi = Bullets[CurrentBullet]
                    local s1, s2 = GetStreetNameAtCoord(bi.coords.x, bi.coords.y, bi.coords.z)
                    local street1 = GetStreetNameFromHashKey(s1)
                    local street2 = GetStreetNameFromHashKey(s2)
                    local streetLabel = street1
                    if street2 then streetLabel = streetLabel .. ' | ' .. street2 end

                    local info = {
                        label = Lang:t('info.bullet_impact'), -- add this key in your locales
                        type = 'bulletimpact',
                        street = streetLabel:gsub("%'", ''),
                        ammolabel = bi.ammoType,
                        ammotype = bi.type,
                        serie = bi.serie
                    }

                    local animDict, animName = "pickup_object", "pickup_low"
                    loadAnimDict(animDict)
                    TaskPlayAnim(PlayerPedId(), animDict, animName, 8.0, 8.0, -1, 57, 1.0, false, false, false)

                    QBCore.Functions.Progressbar('add_to_inventory', 'Récupération de la preuve', 1500, false, true, {
                        disableMovement = false,
                        disableCarMovement = false,
                        disableMouse = false,
                        disableCombat = true
                    }, {}, {}, {}, function()
                        -- Create matching server handler for this:
                        -- evidence:server:AddBulletImpactToInventory(bulletId, info)
                        TriggerServerEvent('evidence:server:AddBulletImpactToInventory', CurrentBullet, info)
                        isDoingAction = false
                    end, function()
                        isDoingAction = false
                    end)
                end
            end
        end
    end
end)

local function CheckIfPlayerHasUVLight()
    local evangeCore = exports['evange-core']
    if evangeCore:HasCurrentWeaponComponent({'plight_uv'}) then
        return true
    end
    return false
end

CreateThread(function()
    while true do
        Wait(10)
        if LocalPlayer.state.isLoggedIn then
            if PlayerJob.type == 'leo' and PlayerJob.onduty then
                if IsPlayerFreeAiming(PlayerId()) and GetSelectedPedWeapon(PlayerPedId()) == `WEAPON_POCKETLIGHT` and CheckIfPlayerHasUVLight() then
                    if next(Casings) then
                        local pos = GetEntityCoords(PlayerPedId(), true)
                        for k, v in pairs(Casings) do
                            local dist = #(pos - vector3(v.coords.x, v.coords.y, v.coords.z))
                            if dist < 1.5 then
                                CurrentCasing = k
                            end
                        end
                    end
                    if next(Blooddrops) then
                        local pos = GetEntityCoords(PlayerPedId(), true)
                        for k, v in pairs(Blooddrops) do
                            local dist = #(pos - vector3(v.coords.x, v.coords.y, v.coords.z))
                            if dist < 1.5 then
                                CurrentBlooddrop = k
                            end
                        end
                    end
                    if next(Fingerprints) then
                        local pos = GetEntityCoords(PlayerPedId(), true)
                        for k, v in pairs(Fingerprints) do
                            local dist = #(pos - vector3(v.coords.x, v.coords.y, v.coords.z))
                            if dist < 1.5 then
                                CurrentFingerprint = k
                            end
                        end
                    end
                    if next(Bullets) then
                        local pos = GetEntityCoords(PlayerPedId(), true)
                        for k, v in pairs(Bullets) do
                            if v.coords then
                            local dist = #(pos - vector3(v.coords.x, v.coords.y, v.coords.z))
                                if dist < 1.5 then
                                    CurrentBullet = k
                                end
                            end
                        end
                    end
                else
                    Wait(1000)
                end
            else
                Wait(5000)
            end
        end
    end
end)


-- TEST
-- === Debug/inspection: show bullet impacts attached to ME ===
-- debug sphere config
local ImpactSphere = {
    radius = 0.22,                 -- sphere size
    color  = { r = 80, g = 180, b = 255, a = 180 },
    faceCam = false,               -- keep false for a true sphere
    bob     = false,               -- bob up/down
}

local ImpactHighlights = {}  -- [bulletId] = expireTime

local function StartImpactHighlighter()
    if ImpactHighlights._active then return end
    ImpactHighlights._active = true

    CreateThread(function()
        while true do
            local now = GetGameTimer()
            local any = false

            for bulletId, expireAt in pairs(ImpactHighlights) do
                if type(bulletId) == 'number' and expireAt then
                    any = true
                    if now > expireAt then
                        ImpactHighlights[bulletId] = nil
                    else
                        local bi = Bullets[bulletId]
                        if bi then
                            -- Resolve position on my ped (bone if available)
                            local ped = PlayerPedId()
                            local pos
                            if bi.bone and bi.bone ~= 0 then
                                pos = GetPedBoneCoords(ped, bi.bone, 0.0, 0.0, 0.0)
                            else
                                pos = GetEntityCoords(ped)
                            end

                            -- Draw a sphere at the impact
                            -- DrawMarker(type=28, pos, dir=0, rot=0, scale=radius, color, bob, faceCam, p19=2, rotate=false)
                            DrawMarker(
                                28,
                                pos.x, pos.y, pos.z,
                                0.0, 0.0, 0.0,
                                0.0, 0.0, 0.0,
                                ImpactSphere.radius, ImpactSphere.radius, ImpactSphere.radius,
                                ImpactSphere.color.r, ImpactSphere.color.g, ImpactSphere.color.b, ImpactSphere.color.a,
                                ImpactSphere.bob, ImpactSphere.faceCam, 2, false, nil, nil, false
                            )

                            -- (optional) keep the text
                            local weaponLabel = exports.ox_inventory:Items(bi.type)
                            local ammoType = bi.ammoType
                            local label = ('%s | %s'):format(weaponLabel.label or 'Weapon ?', ammoType or 'Ammo ?')
                            DrawText3D(pos.x, pos.y, pos.z + 0.05, ('Impact #%s\n%s'):format(bulletId, label))
                        end
                    end
                end
            end

            if not any then
                ImpactHighlights._active = false
                break
            end

            Wait(0)
        end
    end)
end

-- /myimpacts : highlight all bullet impacts linked to my player for 8 seconds
RegisterCommand('myimpacts', function()
    -- local myServerId = GetPlayerServerId(PlayerId())
    local PlayerData = QBCore.Functions.GetPlayerData()
    local citizenId = PlayerData.citizenid
    local count = 0

    for id, v in pairs(Bullets) do
        if v.citizenId and v.citizenId == citizenId then
            ImpactHighlights[id] = GetGameTimer() + 8000 -- 8s highlight per impact
            count = count + 1
        end
    end

    if count == 0 then
        if QBCore and QBCore.Functions and QBCore.Functions.Notify then
            QBCore.Functions.Notify('No bullet impacts attached to you.', 'error')
        else
            print('[evidence] No bullet impacts attached to you.')
        end
        return
    end

    if QBCore and QBCore.Functions and QBCore.Functions.Notify then
        QBCore.Functions.Notify(('Showing %d impact(s) on you for 8s.'):format(count), 'success')
    else
        print(('[evidence] Showing %d impact(s) on you for 8s.'):format(count))
    end

    StartImpactHighlighter()
end, false)

-- TEST COMMAND: /testimpact
RegisterCommand("testimpact", function()
    local ped = PlayerPedId()
    local myId = GetPlayerServerId(PlayerId())

    -- Example bone (head = 31086, chest = 24818)
    local testBone = 31086  

    -- Fake weapon data
    local weapon = `WEAPON_PISTOL`

    -- Send to server as if you were shot
    TriggerServerEvent("evidence:server:CreateBulletImpactOnPlayer", weapon, {
        target = myId,
        bone = testBone
    })

    QBCore.Functions.Notify("Simulated bullet impact on yourself (bone: " .. testBone .. ")", "success")
end, false)
