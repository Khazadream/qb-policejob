local function RegisterOxShop()
    exports.ox_inventory:RegisterShop('PoliceShop', {
        name = 'Police Shop',
        inventory = {
            -- 
            { name = 'testplaceable', price = 0, metadata = {label = 'Cone de circulation', propName = 'm25_1_int_01_cone_02'} },
            { name = 'testplaceable', price = 0, metadata = {label = 'Barrière flêche', propName = 'prop_mp_arrow_barrier_01'} },
            { name = 'testplaceable', price = 0, metadata = {label = 'Barrière bleu', propName = 'prop_barrier_work05'} },
            { name = 'testplaceable', price = 0, metadata = {label = 'Barrière blanche', propName = 'prop_barrier_work06a'} },
            { name = 'testplaceable', price = 0, metadata = {label = 'Barrière route', propName = 'prop_mp_barrier_02b'} },
            { name = 'testplaceable', price = 0, metadata = {label = 'Barrière route fermé', propName = 'xm3_prop_xm3_road_barrier_01a'} },
            { name = 'spikes', price = 0 },
            { name = 'spray_remover', price = 0 },
            { name = 'handcuffs', price = 0 },
            { name = 'empty_evidence_bag', price = 0 },
            { name = 'swatmask', price = 0 },
            { name = 'leo_bipper', price = 0 },
            -- Weapon
            { name = "WEAPON_POCKETLIGHT", price = 0, image = 'uvtorch.png', metadata = { label = 'Lampe à UV', components = {"plight_uv" } }},
            { name = 'toolbox_weapon_analysis', price = 0 },
            { name = 'evange_backpack_duty', price = 0  },

            -- TODO: Weapon
            { name = 'WEAPON_STUNGUN', price = 0 },
            { name = 'WEAPON_NIGHTSTICK', price = 0 },
            { name = 'WEAPON_FLASHLIGHT', price = 0 },
            { name = 'WEAPON_COMBATPISTOL', price = 0, metadata = { components = {'at_flashlight' } } },
            { name = "WEAPON_SMG", price = 0, metadata = { components = {'at_flashlight', 'at_scope_macro' } }},
            { name = "WEAPON_PUMPSHOTGUN", price = 0, metadata = { components = {'at_flashlight' } }},
            { name = "WEAPON_CARBINERIFLE", price = 0, metadata = { components = {'at_flashlight', 'at_scope_medium' } }},
            -- TODO: Ammo
            { name = 'ammo-9', price = 0 },
            { name = 'ammo-rifle', price = 0 },
            { name = 'ammo-shotgun', price = 0 },
        },
    })
end

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        RegisterOxShop()
    end
end)