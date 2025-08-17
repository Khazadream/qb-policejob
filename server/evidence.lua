local Casings = {}
local Bullets = {}
local BloodDrops = {}
local FingerDrops = {}
local PlayerStatus = {}

-- Functions

local function CreateBloodId()
    if BloodDrops then
        local bloodId = math.random(10000, 99999)
        while BloodDrops[bloodId] do
            bloodId = math.random(10000, 99999)
        end
        return bloodId
    else
        local bloodId = math.random(10000, 99999)
        return bloodId
    end
end

local function CreateFingerId()
    if FingerDrops then
        local fingerId = math.random(10000, 99999)
        while FingerDrops[fingerId] do
            fingerId = math.random(10000, 99999)
        end
        return fingerId
    else
        local fingerId = math.random(10000, 99999)
        return fingerId
    end
end

local function CreateCasingId()
    if Casings then
        local caseId = math.random(10000, 99999)
        while Casings[caseId] do
            caseId = math.random(10000, 99999)
        end
        return caseId
    else
        local caseId = math.random(10000, 99999)
        return caseId
    end
end

local function CreateBulletId()
    if Bullets then
        local bulletId = math.random(10000, 99999)
        while Bullets[bulletId] do
            bulletId = math.random(10000, 99999)
        end
        return bulletId
    else
        local bulletId = math.random(10000, 99999)
        return bulletId
    end
end

-- Callbacks

QBCore.Functions.CreateCallback('police:GetPlayerStatus', function(_, cb, playerId)
    local Player = QBCore.Functions.GetPlayer(playerId)
    local statList = {}
    if Player then
        if PlayerStatus[Player.PlayerData.source] and next(PlayerStatus[Player.PlayerData.source]) then
            for k in pairs(PlayerStatus[Player.PlayerData.source]) do
                statList[#statList + 1] = PlayerStatus[Player.PlayerData.source][k].text
            end
        end
    end
    cb(statList)
end)

-- Events

RegisterNetEvent('evidence:server:UpdateStatus', function(data)
    local src = source
    PlayerStatus[src] = data
end)

RegisterNetEvent('evidence:server:CreateBloodDrop', function(citizenid, bloodtype, coords)
    local bloodId = CreateBloodId()
    BloodDrops[bloodId] = {
        dna = citizenid,
        bloodtype = bloodtype
    }
    TriggerClientEvent('evidence:client:AddBlooddrop', -1, bloodId, citizenid, bloodtype, coords)
end)

RegisterNetEvent('evidence:server:CreateFingerDrop', function(coords)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local fingerId = CreateFingerId()
    FingerDrops[fingerId] = Player.PlayerData.metadata['fingerprint']
    TriggerClientEvent('evidence:client:AddFingerPrint', -1, fingerId, Player.PlayerData.metadata['fingerprint'], coords)
end)

RegisterNetEvent('evidence:server:ClearBlooddrops', function(blooddropList)
    if blooddropList and next(blooddropList) then
        for _, v in pairs(blooddropList) do
            TriggerClientEvent('evidence:client:RemoveBlooddrop', -1, v)
            BloodDrops[v] = nil
        end
    end
end)

-- BLOODDROP -> filled evidence bag (ox_inventory)
RegisterNetEvent('evidence:server:AddBlooddropToInventory', function(bloodId, bloodInfo)
    local src = source
    local metadata = {
        _type = 'blood',
        info = bloodInfo,
        label = 'Sachet de sang',
    }

    if not exports.ox_inventory:RemoveItem(src, 'empty_evidence_bag', 1) then
        return TriggerClientEvent('QBCore:Notify', src, Lang:t('error.have_evidence_bag'), 'error')
    end

    exports.ox_inventory:AddItem(src, 'filled_evidence_bag', 1, metadata)
    TriggerClientEvent('evidence:client:RemoveBlooddrop', -1, bloodId)
    BloodDrops[bloodId] = nil
end)

-- FINGERPRINT -> filled evidence bag (ox_inventory)
RegisterNetEvent('evidence:server:AddFingerprintToInventory', function(fingerId, fingerInfo)
    local src = source
    local metadata = {
        _type = 'fingerprint',
        info = fingerInfo,
        label = 'Empreinte digitale',
    }

    if not exports.ox_inventory:RemoveItem(src, 'empty_evidence_bag', 1) then
        return TriggerClientEvent('QBCore:Notify', src, Lang:t('error.have_evidence_bag'), 'error')
    end

    exports.ox_inventory:AddItem(src, 'filled_evidence_bag', 1, metadata)
    TriggerClientEvent('evidence:client:RemoveFingerprint', -1, fingerId)
    FingerDrops[fingerId] = nil
end)


RegisterNetEvent('evidence:server:ClearCasings', function(casingList)
    if casingList and next(casingList) then
        for _, v in pairs(casingList) do
            TriggerClientEvent('evidence:client:RemoveCasing', -1, v)
            Casings[v] = nil
        end
    end
end)

RegisterNetEvent('evidence:server:AddCasingToInventory', function(casingId, casingInfo)
    local src = source
    local metadata = {
        _type = 'casing',
        info = casingInfo,
        label = 'Sachet de douille',
    }
    if not exports.ox_inventory:RemoveItem(src, 'empty_evidence_bag', 1) then
        return TriggerClientEvent('QBCore:Notify', src, Lang:t('error.have_evidence_bag'), 'error')
    end
    exports.ox_inventory:AddItem(src, 'filled_evidence_bag', 1, metadata)
    TriggerClientEvent('evidence:client:RemoveCasing', -1, casingId)
    Casings[casingId] = nil
end)

RegisterNetEvent('evidence:server:AddBulletImpactToInventory', function(bulletId, bulletInfo)
    local src = source
    local metadata = {
        _type = 'bullet_impact',
        info = bulletInfo,
        label = 'Sachet de balle',
    }
    if not exports.ox_inventory:RemoveItem(src, 'empty_evidence_bag', 1) then
        return TriggerClientEvent('QBCore:Notify', src, Lang:t('error.have_evidence_bag'), 'error')
    end
    exports.ox_inventory:AddItem(src, 'filled_evidence_bag', 1, metadata)
    TriggerClientEvent('evidence:client:RemoveBulletImpact', -1, bulletId)
    Bullets[bulletId] = nil
end)

RegisterNetEvent('evidence:server:CreateCasing', function(weapon, coords)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local evangeCore = exports['evange-core']
    local weapon = evangeCore:GetPlayerWeapon(src)
    if not weapon then return end
    local weaponName = weapon.name or nil
    local serialNumber = weapon.metadata and weapon.metadata.serial or nil
    local ammoType = weapon.ammo or nil
    if not weaponName or not serialNumber then return end

    local ammoItem = exports.ox_inventory:Items(ammoType)
    if not ammoItem then return end
    local ammoLabel = ammoItem.label or nil

    local casingId = CreateCasingId()
    TriggerClientEvent('evidence:client:AddCasing', -1, casingId, weaponName, coords, serialNumber, ammoLabel)
end)

RegisterNetEvent('evidence:server:CreateBulletImpact', function(weapon, coords)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local evangeCore = exports['evange-core']
    local weapon = evangeCore:GetPlayerWeapon(src)
    if not weapon then return end
    local weaponName = weapon.name or nil
    local serialNumber = weapon.metadata and weapon.metadata.serial or nil
    local ammoType = weapon.ammo or nil
    if not weaponName or not serialNumber then return end

    local ammoItem = exports.ox_inventory:Items(ammoType)
    if not ammoItem then return end
    local ammoLabel = ammoItem.label or nil

    local bulletId = CreateBulletId()
    TriggerClientEvent('evidence:client:AddBulletImpact', -1, bulletId, weaponName, coords, serialNumber, ammoLabel)
end)