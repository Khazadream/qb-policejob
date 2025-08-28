local function RegisterOxShop()
    exports.ox_inventory:RegisterShop('PoliceShop', {
        name = 'Police Shop',
        inventory = {
            -- 
            { name = 'testplaceable', price = 10, metadata = {label = 'Carton', propName = 'prop_mp_arrow_barrier_01'} },
            { name = 'testplaceable', price = 10, metadata = {label = 'Cone de circulation', propName = 'prop_barrier_work05'} },
            { name = 'testplaceable', price = 100, metadata = {label = 'Barrière', propName = 'prop_barrier_work06a'} },
            { name = 'testplaceable', price = 100, metadata = {label = 'Barrière', propName = 'prop_mp_barrier_02b'} },
            { name = 'testplaceable', price = 100, metadata = {label = 'Barrière', propName = 'xm3_prop_xm3_road_barrier_01a'} },
            { name = 'spikes', price = 10 },
            { name = 'spray_remover', price = 10 },
            -- Weapon
            { name = "WEAPON_POCKETLIGHT", price = 15000, image = 'uvtorch.png', metadata = { label = 'Lampe à UV', components = {"plight_uv" } }},
            { name = 'toolbox_weapon_analysis', price = 10000 },
            { name = 'evange_backpack_duty', price = 10000  },
        },
    })
end

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        RegisterOxShop()
    end
end)