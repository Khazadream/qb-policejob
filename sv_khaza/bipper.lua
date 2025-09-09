BIPPERS_ACTIVE = {}


local function ToggleBippers(source, callsign)
    local sourceStr = tostring(source)
    if not BIPPERS_ACTIVE[sourceStr] then
        BIPPERS_ACTIVE[sourceStr] = {}
        BIPPERS_ACTIVE[sourceStr].isActive = false
        BIPPERS_ACTIVE[sourceStr].callsign = callsign
    end

    BIPPERS_ACTIVE[sourceStr].isActive = not BIPPERS_ACTIVE[sourceStr].isActive
    BIPPERS_ACTIVE[sourceStr].callsign = callsign
end

local function SetBippers(source, state)
    local sourceStr = tostring(source)
    if not BIPPERS_ACTIVE[sourceStr] then
        BIPPERS_ACTIVE[sourceStr] = {}
        BIPPERS_ACTIVE[sourceStr].isActive = state
    else
        BIPPERS_ACTIVE[sourceStr].isActive = state
    end
end

RegisterNetEvent("qb-policejob:server:toggleBipper", function(slot)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local item = exports.ox_inventory:GetSlot(src, slot.slot)
    local callsign = Player.PlayerData.metadata.callsign
    if not item.metadata or not item.metadata.callsign then
        -- Check if player has a CallSign
        if not callsign then
            TriggerClientEvent('QBCore:Notify', src, "Votre matricule doit être configuré.", 'error')
            return
        end
        -- Assign callsign to the bipper
        item.metadata.callsign = callsign
        exports.ox_inventory:SetMetadata(src, slot, item.metadata)
        -- Activate bipper
        TriggerClientEvent("qb-policejob:client:toggleBipper", src)
        ToggleBippers(Player.PlayerData.source, item.metadata.callsign)
    elseif item.metadata.callsign and item.metadata.callsign == callsign then
        -- Activate bipper par son propriétaire.
        TriggerClientEvent("qb-policejob:client:toggleBipper", src)
        ToggleBippers(Player.PlayerData.source, item.metadata.callsign)
    elseif item.metadata.callsign and callsign == "NO CALLSIGN" then
        -- Bipper is used by a non Officer Player.
        TriggerClientEvent("qb-policejob:client:toggleBipper", src)
        ToggleBippers(Player.PlayerData.source, item.metadata.callsign)
    else
        print("BIPPER: ERROR!")
    end
end)

RegisterNetEvent("qb-policejob:server:setBippers", function(bipState)
    local src = source
    local state = bipState
    SetBippers(src, state)
end)
