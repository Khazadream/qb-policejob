-- ATM Robbery
RegisterNetEvent("qb-policejob:client:alert-ATMRobbery")
-- House Robbery
RegisterNetEvent("qb-policejob:client:alert-HouseRobbery")
-- Active Shooting
RegisterNetEvent("qb-policejob:client:alert-ActiveShooting")
-- Container BreakIn
RegisterNetEvent("qb-policejob:client:alert-ContainerBreakIn")
-- Stolen Container
RegisterNetEvent("qb-policejob:client:alert-StolenContainer")
-- Suspect Activity In Street
RegisterNetEvent("qb-policejob:client:alert-SuspectActivityInStreet")
-- Shop Robbery
RegisterNetEvent("qb-policejob:client:alert-ShopRobbery")
-- Fleeca Robbery
RegisterNetEvent("qb-policejob:client:alert-FleecaRobbery")
-- Blaine County Savings Robbery
RegisterNetEvent("qb-policejob:client:alert-BlaineCountySavingsRobbery")
-- Pacific Bank Robbery
RegisterNetEvent("qb-policejob:client:alert-PacificBankRobbery")
-- Paleto Bank Robbery
RegisterNetEvent("qb-policejob:client:alert-PaletoBankRobbery")
-- Vangelico Robbery
RegisterNetEvent("qb-policejob:client:alert-VangelicoRobbery")
-- Go Fast
RegisterNetEvent("qb-policejob:client:alert-GoFast")

RegisterCommand("khaza-alert", function()
    --TriggerEvent("qb-policejob:client:alert-ATMRobbery")
    TriggerEvent("qb-policejob:client:alert-GoFast")
    --exports['ps-dispatch']:StoreRobbery()
end)

-- ATM Robbery
AddEventHandler("qb-policejob:client:alert-ATMRobbery", function()
    local dispatchData = {}
    local playerCoords = GetEntityCoords(PlayerPedId())

    -- ## Dispatch display informations ##
    dispatchData.message = "Braquage d'ATM" -- Title of the alert
    --dispatchData.dispatchCode = 'storerobbery' -- Unique name for each alert
    dispatchData.code = '10-45' -- Code that is displayed before the title
    dispatchData.icon = 'fas fa-money-check-dollar' -- Icon that is displayed after the title
    dispatchData.priority = 2 -- Changes color of the alert ( 1 = red, 2 = default )
    dispatchData.gender = true -- true or false (Do we know the suspect gender ?)
    --dispatchData.camId = nil -- Cam ID ( for heists and robberies )

    -- ## Vehicle informations ##
    --dispatchData.model = nil -- Vehicle model
    --dispatchData.firstColor = nil -- Vehicle first color
    --dispatchData.plate = nil -- Vehicle plate
    --dispatchData.doorCount =  -- How many doors on vehicle
    
    -- ## Officer informations ##
    --dispatchData.callsign = PlayerData.metadata["callsign"] -- Officer callsign
    --dispatchData.name = PlayerData.charinfo.firstname .. " " .. PlayerData.charinfo.lastname, -- Officer name
    
    -- ## Guns Type ##
    --dispatchData.automaticGunfire = false -- Automatic Gun or not
    
    -- ## Dispatch timer ##
    dispatchData.alertTime = 5 -- How long it stays on the screen in seconds (Seems to be either at 10 or nil on preconfigure alerts)

    -- ## Blip & Sound settings : ##
    dispatchData.coords = playerCoords -- Player Coords
    dispatchData.radius = 0 -- Radius around the blip
    dispatchData.sprite = 52 -- Sprite of the blip
    dispatchData.color = 1 -- Color of the blip
    dispatchData.scale = 1.0 -- Scale of the blip
    dispatchData.length = 10 -- How long it stays on the map
    --dispatchData.sound =  -- Alert sound (default : "Lose_1st")
    --dispatchData.sound2 =  -- Alert sound (default : "GTAO_FM_Events_Soundset")
    --dispatchData.offset =  -- Blip / radius offset
    --dispatchData.flash =  -- Blip flash (false by default)

    -- Jobs alerted
    dispatchData.jobs = {'leo'} -- { 'police', 'ambulance' } (If nil, will consider leo type jobs.)

    exports['ps-dispatch']:CustomAlert(dispatchData)
end)

-- House Robbery
AddEventHandler("qb-policejob:client:alert-HouseRobbery", function()
    local dispatchData = {}
    local playerCoords = GetEntityCoords(PlayerPedId())

    -- ## Dispatch display informations ##
    dispatchData.message = "Cambriolage de maison" -- Title of the alert
    --dispatchData.dispatchCode = 'storerobbery' -- Unique name for each alert
    dispatchData.code = '10-45' -- Code that is displayed before the title
    dispatchData.icon = 'fas fa-house-user' -- Icon that is displayed after the title
    dispatchData.priority = 2 -- Changes color of the alert ( 1 = red, 2 = default )
    dispatchData.gender = true -- true or false (Do we know the suspect gender ?)
    --dispatchData.camId = nil -- Cam ID ( for heists and robberies )

    -- ## Vehicle informations ##
    --dispatchData.model = nil -- Vehicle model
    --dispatchData.firstColor = nil -- Vehicle first color
    --dispatchData.plate = nil -- Vehicle plate
    --dispatchData.doorCount =  -- How many doors on vehicle
    
    -- ## Officer informations ##
    --dispatchData.callsign = PlayerData.metadata["callsign"] -- Officer callsign
    --dispatchData.name = PlayerData.charinfo.firstname .. " " .. PlayerData.charinfo.lastname, -- Officer name
    
    -- ## Guns Type ##
    --dispatchData.automaticGunfire = false -- Automatic Gun or not
    
    -- ## Dispatch timer ##
    dispatchData.alertTime = 5 -- How long it stays on the screen in seconds (Seems to be either at 10 or nil on preconfigure alerts)

    -- ## Blip & Sound settings : ##
    dispatchData.coords = playerCoords -- Player Coords
    dispatchData.radius = 0 -- Radius around the blip
    dispatchData.sprite = 40 -- Sprite of the blip
    dispatchData.color = 1 -- Color of the blip
    dispatchData.scale = 1.0 -- Scale of the blip
    dispatchData.length = 10 -- How long it stays on the map
    --dispatchData.sound =  -- Alert sound (default : "Lose_1st")
    --dispatchData.sound2 =  -- Alert sound (default : "GTAO_FM_Events_Soundset")
    --dispatchData.offset =  -- Blip / radius offset
    --dispatchData.flash =  -- Blip flash (false by default)

    -- Jobs alerted
    dispatchData.jobs = {'leo'} -- { 'police', 'ambulance' } (If nil, will consider leo type jobs.)

    exports['ps-dispatch']:CustomAlert(dispatchData)
end)

-- Active Shooting
AddEventHandler("qb-policejob:client:alert-ActiveShooting", function()
    -- Trigger Already Handle on ps-dispatch
end)

-- Container BreakIn
AddEventHandler("qb-policejob:client:alert-ContainerBreakIn", function()
    local dispatchData = {}
    local playerCoords = GetEntityCoords(PlayerPedId())

    -- ## Dispatch display informations ##
    dispatchData.message = "Cambriolage de container" -- Title of the alert
    --dispatchData.dispatchCode = 'storerobbery' -- Unique name for each alert
    dispatchData.code = '10-45' -- Code that is displayed before the title
    dispatchData.icon = 'fas fa-box' -- Icon that is displayed after the title
    dispatchData.priority = 2 -- Changes color of the alert ( 1 = red, 2 = default )
    dispatchData.gender = true -- true or false (Do we know the suspect gender ?)
    --dispatchData.camId = nil -- Cam ID ( for heists and robberies )

    -- ## Vehicle informations ##
    --dispatchData.model = nil -- Vehicle model
    --dispatchData.firstColor = nil -- Vehicle first color
    --dispatchData.plate = nil -- Vehicle plate
    --dispatchData.doorCount =  -- How many doors on vehicle
    
    -- ## Officer informations ##
    --dispatchData.callsign = PlayerData.metadata["callsign"] -- Officer callsign
    --dispatchData.name = PlayerData.charinfo.firstname .. " " .. PlayerData.charinfo.lastname, -- Officer name
    
    -- ## Guns Type ##
    --dispatchData.automaticGunfire = false -- Automatic Gun or not
    
    -- ## Dispatch timer ##
    dispatchData.alertTime = 5 -- How long it stays on the screen in seconds (Seems to be either at 10 or nil on preconfigure alerts)

    -- ## Blip & Sound settings : ##
    dispatchData.coords = playerCoords -- Player Coords
    dispatchData.radius = 0 -- Radius around the blip
    dispatchData.sprite = 289 -- Sprite of the blip
    dispatchData.color = 1 -- Color of the blip
    dispatchData.scale = 1.0 -- Scale of the blip
    dispatchData.length = 10 -- How long it stays on the map
    --dispatchData.sound =  -- Alert sound (default : "Lose_1st")
    --dispatchData.sound2 =  -- Alert sound (default : "GTAO_FM_Events_Soundset")
    --dispatchData.offset =  -- Blip / radius offset
    --dispatchData.flash =  -- Blip flash (false by default)

    -- Jobs alerted
    dispatchData.jobs = {'leo'} -- { 'police', 'ambulance' } (If nil, will consider leo type jobs.)

    exports['ps-dispatch']:CustomAlert(dispatchData)
end)

-- Stolen Container
AddEventHandler("qb-policejob:client:alert-StolenContainer", function(data)
    local dispatchData = {}
    local playerCoords = GetEntityCoords(PlayerPedId())

    -- ## Dispatch display informations ##
    dispatchData.message = "Vol de container" -- Title of the alert
    --dispatchData.dispatchCode = 'storerobbery' -- Unique name for each alert
    dispatchData.code = '10-45' -- Code that is displayed before the title
    dispatchData.icon = 'fas fa-box' -- Icon that is displayed after the title
    dispatchData.priority = 2 -- Changes color of the alert ( 1 = red, 2 = default )
    dispatchData.gender = true -- true or false (Do we know the suspect gender ?)
    --dispatchData.camId = nil -- Cam ID ( for heists and robberies )

    -- ## Vehicle informations ##
    dispatchData.model = data and data.model or 'Semi-remorque' -- Vehicle model
    --dispatchData.firstColor = nil -- Vehicle first color
    dispatchData.plate = data and data.plate or 'NO PLATE' -- Vehicle plate
    --dispatchData.doorCount =  -- How many doors on vehicle
    
    -- ## Officer informations ##
    --dispatchData.callsign = PlayerData.metadata["callsign"] -- Officer callsign
    --dispatchData.name = PlayerData.charinfo.firstname .. " " .. PlayerData.charinfo.lastname, -- Officer name
    
    -- ## Guns Type ##
    --dispatchData.automaticGunfire = false -- Automatic Gun or not
    
    -- ## Dispatch timer ##
    dispatchData.alertTime = 5 -- How long it stays on the screen in seconds (Seems to be either at 10 or nil on preconfigure alerts)

    -- ## Blip & Sound settings : ##
    dispatchData.coords = playerCoords -- Player Coords
    dispatchData.radius = 0 -- Radius around the blip
    dispatchData.sprite = 635 -- Sprite of the blip
    dispatchData.color = 1 -- Color of the blip
    dispatchData.scale = 1.0 -- Scale of the blip
    dispatchData.length = 10 -- How long it stays on the map
    --dispatchData.sound =  -- Alert sound (default : "Lose_1st")
    --dispatchData.sound2 =  -- Alert sound (default : "GTAO_FM_Events_Soundset")
    --dispatchData.offset =  -- Blip / radius offset
    --dispatchData.flash =  -- Blip flash (false by default)

    -- Jobs alerted
    dispatchData.jobs = {'leo'} -- { 'police', 'ambulance' } (If nil, will consider leo type jobs.)

    exports['ps-dispatch']:CustomAlert(dispatchData)
end)

-- Suspect Activity In Street
AddEventHandler("qb-policejob:client:alert-SuspectActivityInStreet", function(data)
    local dispatchData = {}
    local playerCoords = GetEntityCoords(PlayerPedId())

    -- ## Dispatch display informations ##
    dispatchData.message = "Activité suspecte" -- Title of the alert
    --dispatchData.dispatchCode = 'storerobbery' -- Unique name for each alert
    dispatchData.code = '10-45' -- Code that is displayed before the title
    dispatchData.icon = 'fas fa-question' -- Icon that is displayed after the title
    dispatchData.priority = 2 -- Changes color of the alert ( 1 = red, 2 = default )
    dispatchData.gender = false -- true or false (Do we know the suspect gender ?)
    --dispatchData.camId = nil -- Cam ID ( for heists and robberies )

    -- ## Vehicle informations ##
    --dispatchData.model =  -- Vehicle model
    --dispatchData.firstColor = nil -- Vehicle first color
    --dispatchData.plate =  -- Vehicle plate
    --dispatchData.doorCount =  -- How many doors on vehicle
    
    -- ## Officer informations ##
    --dispatchData.callsign = PlayerData.metadata["callsign"] -- Officer callsign
    --dispatchData.name = PlayerData.charinfo.firstname .. " " .. PlayerData.charinfo.lastname, -- Officer name
    
    -- ## Guns Type ##
    --dispatchData.automaticGunfire = false -- Automatic Gun or not
    
    -- ## Dispatch timer ##
    dispatchData.alertTime = 5 -- How long it stays on the screen in seconds (Seems to be either at 10 or nil on preconfigure alerts)

    -- ## Blip & Sound settings : ##
    dispatchData.coords = playerCoords -- Player Coords
    dispatchData.radius = 0 -- Radius around the blip
    dispatchData.sprite = 66 -- Sprite of the blip
    dispatchData.color = 1 -- Color of the blip
    dispatchData.scale = 1.0 -- Scale of the blip
    dispatchData.length = 10 -- How long it stays on the map
    --dispatchData.sound =  -- Alert sound (default : "Lose_1st")
    --dispatchData.sound2 =  -- Alert sound (default : "GTAO_FM_Events_Soundset")
    --dispatchData.offset =  -- Blip / radius offset
    --dispatchData.flash =  -- Blip flash (false by default)

    -- Jobs alerted
    dispatchData.jobs = {'leo'} -- { 'police', 'ambulance' } (If nil, will consider leo type jobs.)

    exports['ps-dispatch']:CustomAlert(dispatchData)
end)

-- Shop Robbery
AddEventHandler("qb-policejob:client:alert-ShopRobbery", function(data)
    local dispatchData = {}
    local playerCoords = GetEntityCoords(PlayerPedId())

    -- ## Dispatch display informations ##
    dispatchData.message = "Braquage de superette" -- Title of the alert
    --dispatchData.dispatchCode = 'storerobbery' -- Unique name for each alert
    dispatchData.code = '10-45' -- Code that is displayed before the title
    dispatchData.icon = 'fas fa-basket-shopping' -- Icon that is displayed after the title
    dispatchData.priority = 2 -- Changes color of the alert ( 1 = red, 2 = default )
    dispatchData.gender = true -- true or false (Do we know the suspect gender ?)
    dispatchData.camId = data and data.camId or nil -- Cam ID ( for heists and robberies )

    -- ## Vehicle informations ##
    --dispatchData.model =  -- Vehicle model
    --dispatchData.firstColor = nil -- Vehicle first color
    --dispatchData.plate =  -- Vehicle plate
    --dispatchData.doorCount =  -- How many doors on vehicle
    
    -- ## Officer informations ##
    --dispatchData.callsign = PlayerData.metadata["callsign"] -- Officer callsign
    --dispatchData.name = PlayerData.charinfo.firstname .. " " .. PlayerData.charinfo.lastname, -- Officer name
    
    -- ## Guns Type ##
    --dispatchData.automaticGunfire = false -- Automatic Gun or not
    
    -- ## Dispatch timer ##
    dispatchData.alertTime = 5 -- How long it stays on the screen in seconds (Seems to be either at 10 or nil on preconfigure alerts)

    -- ## Blip & Sound settings : ##
    dispatchData.coords = playerCoords -- Player Coords
    dispatchData.radius = 0 -- Radius around the blip
    dispatchData.sprite = 59 -- Sprite of the blip
    dispatchData.color = 1 -- Color of the blip
    dispatchData.scale = 1.0 -- Scale of the blip
    dispatchData.length = 10 -- How long it stays on the map
    --dispatchData.sound =  -- Alert sound (default : "Lose_1st")
    --dispatchData.sound2 =  -- Alert sound (default : "GTAO_FM_Events_Soundset")
    --dispatchData.offset =  -- Blip / radius offset
    --dispatchData.flash =  -- Blip flash (false by default)

    -- Jobs alerted
    dispatchData.jobs = {'leo'} -- { 'police', 'ambulance' } (If nil, will consider leo type jobs.)

    exports['ps-dispatch']:CustomAlert(dispatchData)
end)

-- Fleeca Robbery
AddEventHandler("qb-policejob:client:alert-FleecaRobbery", function(data)
    local dispatchData = {}
    local playerCoords = GetEntityCoords(PlayerPedId())

    -- ## Dispatch display informations ##
    dispatchData.message = "Braquage de banque: Fleeca" -- Title of the alert
    --dispatchData.dispatchCode = 'storerobbery' -- Unique name for each alert
    dispatchData.code = '10-45' -- Code that is displayed before the title
    dispatchData.icon = 'fas fa-dollar-sign' -- Icon that is displayed after the title
    dispatchData.priority = 2 -- Changes color of the alert ( 1 = red, 2 = default )
    dispatchData.gender = true -- true or false (Do we know the suspect gender ?)
    dispatchData.camId = data and data.camId or nil -- Cam ID ( for heists and robberies )

    -- ## Vehicle informations ##
    --dispatchData.model =  -- Vehicle model
    --dispatchData.firstColor = nil -- Vehicle first color
    --dispatchData.plate =  -- Vehicle plate
    --dispatchData.doorCount =  -- How many doors on vehicle
    
    -- ## Officer informations ##
    --dispatchData.callsign = PlayerData.metadata["callsign"] -- Officer callsign
    --dispatchData.name = PlayerData.charinfo.firstname .. " " .. PlayerData.charinfo.lastname, -- Officer name
    
    -- ## Guns Type ##
    --dispatchData.automaticGunfire = false -- Automatic Gun or not
    
    -- ## Dispatch timer ##
    dispatchData.alertTime = 5 -- How long it stays on the screen in seconds (Seems to be either at 10 or nil on preconfigure alerts)

    -- ## Blip & Sound settings : ##
    dispatchData.coords = playerCoords -- Player Coords
    dispatchData.radius = 0 -- Radius around the blip
    dispatchData.sprite = 108 -- Sprite of the blip
    dispatchData.color = 1 -- Color of the blip
    dispatchData.scale = 1.0 -- Scale of the blip
    dispatchData.length = 10 -- How long it stays on the map
    --dispatchData.sound =  -- Alert sound (default : "Lose_1st")
    --dispatchData.sound2 =  -- Alert sound (default : "GTAO_FM_Events_Soundset")
    --dispatchData.offset =  -- Blip / radius offset
    --dispatchData.flash =  -- Blip flash (false by default)

    -- Jobs alerted
    dispatchData.jobs = {'leo'} -- { 'police', 'ambulance' } (If nil, will consider leo type jobs.)

    exports['ps-dispatch']:CustomAlert(dispatchData)
end)

-- Blaine County Savings Robbery
AddEventHandler("qb-policejob:client:alert-BlaineCountySavingsRobbery", function(data)
    local dispatchData = {}
    local playerCoords = GetEntityCoords(PlayerPedId())

    -- ## Dispatch display informations ##
    dispatchData.message = "Braquage de banque: BC Savings" -- Title of the alert
    --dispatchData.dispatchCode = 'storerobbery' -- Unique name for each alert
    dispatchData.code = '10-45' -- Code that is displayed before the title
    dispatchData.icon = 'fas fa-dollar-sign' -- Icon that is displayed after the title
    dispatchData.priority = 2 -- Changes color of the alert ( 1 = red, 2 = default )
    dispatchData.gender = true -- true or false (Do we know the suspect gender ?)
    dispatchData.camId = data and data.camId or nil -- Cam ID ( for heists and robberies )

    -- ## Vehicle informations ##
    --dispatchData.model =  -- Vehicle model
    --dispatchData.firstColor = nil -- Vehicle first color
    --dispatchData.plate =  -- Vehicle plate
    --dispatchData.doorCount =  -- How many doors on vehicle
    
    -- ## Officer informations ##
    --dispatchData.callsign = PlayerData.metadata["callsign"] -- Officer callsign
    --dispatchData.name = PlayerData.charinfo.firstname .. " " .. PlayerData.charinfo.lastname, -- Officer name
    
    -- ## Guns Type ##
    --dispatchData.automaticGunfire = false -- Automatic Gun or not
    
    -- ## Dispatch timer ##
    dispatchData.alertTime = 5 -- How long it stays on the screen in seconds (Seems to be either at 10 or nil on preconfigure alerts)

    -- ## Blip & Sound settings : ##
    dispatchData.coords = playerCoords -- Player Coords
    dispatchData.radius = 0 -- Radius around the blip
    dispatchData.sprite = 108 -- Sprite of the blip
    dispatchData.color = 1 -- Color of the blip
    dispatchData.scale = 1.0 -- Scale of the blip
    dispatchData.length = 10 -- How long it stays on the map
    --dispatchData.sound =  -- Alert sound (default : "Lose_1st")
    --dispatchData.sound2 =  -- Alert sound (default : "GTAO_FM_Events_Soundset")
    --dispatchData.offset =  -- Blip / radius offset
    --dispatchData.flash =  -- Blip flash (false by default)

    -- Jobs alerted
    dispatchData.jobs = {'leo'} -- { 'police', 'ambulance' } (If nil, will consider leo type jobs.)

    exports['ps-dispatch']:CustomAlert(dispatchData)
end)

-- Pacific Bank Robbery
AddEventHandler("qb-policejob:client:alert-PacificBankRobbery", function(data)
    local dispatchData = {}
    local playerCoords = GetEntityCoords(PlayerPedId())

    -- ## Dispatch display informations ##
    dispatchData.message = "Braquage de la banque centrale" -- Title of the alert
    --dispatchData.dispatchCode = 'storerobbery' -- Unique name for each alert
    dispatchData.code = '10-45' -- Code that is displayed before the title
    dispatchData.icon = 'fas fa-dollar-sign' -- Icon that is displayed after the title
    dispatchData.priority = 1 -- Changes color of the alert ( 1 = red, 2 = default )
    dispatchData.gender = true -- true or false (Do we know the suspect gender ?)
    dispatchData.camId = data and data.camId or nil -- Cam ID ( for heists and robberies )

    -- ## Vehicle informations ##
    --dispatchData.model =  -- Vehicle model
    --dispatchData.firstColor = nil -- Vehicle first color
    --dispatchData.plate =  -- Vehicle plate
    --dispatchData.doorCount =  -- How many doors on vehicle
    
    -- ## Officer informations ##
    --dispatchData.callsign = PlayerData.metadata["callsign"] -- Officer callsign
    --dispatchData.name = PlayerData.charinfo.firstname .. " " .. PlayerData.charinfo.lastname, -- Officer name
    
    -- ## Guns Type ##
    --dispatchData.automaticGunfire = false -- Automatic Gun or not
    
    -- ## Dispatch timer ##
    dispatchData.alertTime = 5 -- How long it stays on the screen in seconds (Seems to be either at 10 or nil on preconfigure alerts)

    -- ## Blip & Sound settings : ##
    dispatchData.coords = playerCoords -- Player Coords
    dispatchData.radius = 0 -- Radius around the blip
    dispatchData.sprite = 108 -- Sprite of the blip
    dispatchData.color = 1 -- Color of the blip
    dispatchData.scale = 1.0 -- Scale of the blip
    dispatchData.length = 10 -- How long it stays on the map
    --dispatchData.sound =  -- Alert sound (default : "Lose_1st")
    --dispatchData.sound2 =  -- Alert sound (default : "GTAO_FM_Events_Soundset")
    --dispatchData.offset =  -- Blip / radius offset
    --dispatchData.flash =  -- Blip flash (false by default)

    -- Jobs alerted
    dispatchData.jobs = {'leo'} -- { 'police', 'ambulance' } (If nil, will consider leo type jobs.)

    exports['ps-dispatch']:CustomAlert(dispatchData)
end)

-- Paleto Bank Robbery
AddEventHandler("qb-policejob:client:alert-PaletoBankRobbery", function(data)
    local dispatchData = {}
    local playerCoords = GetEntityCoords(PlayerPedId())

    -- ## Dispatch display informations ##
    dispatchData.message = "Braquage de la banque de Paleto" -- Title of the alert
    --dispatchData.dispatchCode = 'storerobbery' -- Unique name for each alert
    dispatchData.code = '10-45' -- Code that is displayed before the title
    dispatchData.icon = 'fas fa-dollar-sign' -- Icon that is displayed after the title
    dispatchData.priority = 1 -- Changes color of the alert ( 1 = red, 2 = default )
    dispatchData.gender = true -- true or false (Do we know the suspect gender ?)
    dispatchData.camId = data and data.camId or nil -- Cam ID ( for heists and robberies )

    -- ## Vehicle informations ##
    --dispatchData.model =  -- Vehicle model
    --dispatchData.firstColor = nil -- Vehicle first color
    --dispatchData.plate =  -- Vehicle plate
    --dispatchData.doorCount =  -- How many doors on vehicle
    
    -- ## Officer informations ##
    --dispatchData.callsign = PlayerData.metadata["callsign"] -- Officer callsign
    --dispatchData.name = PlayerData.charinfo.firstname .. " " .. PlayerData.charinfo.lastname, -- Officer name
    
    -- ## Guns Type ##
    --dispatchData.automaticGunfire = false -- Automatic Gun or not
    
    -- ## Dispatch timer ##
    dispatchData.alertTime = 5 -- How long it stays on the screen in seconds (Seems to be either at 10 or nil on preconfigure alerts)

    -- ## Blip & Sound settings : ##
    dispatchData.coords = playerCoords -- Player Coords
    dispatchData.radius = 0 -- Radius around the blip
    dispatchData.sprite = 108 -- Sprite of the blip
    dispatchData.color = 1 -- Color of the blip
    dispatchData.scale = 1.0 -- Scale of the blip
    dispatchData.length = 10 -- How long it stays on the map
    --dispatchData.sound =  -- Alert sound (default : "Lose_1st")
    --dispatchData.sound2 =  -- Alert sound (default : "GTAO_FM_Events_Soundset")
    --dispatchData.offset =  -- Blip / radius offset
    --dispatchData.flash =  -- Blip flash (false by default)

    -- Jobs alerted
    dispatchData.jobs = {'leo'} -- { 'police', 'ambulance' } (If nil, will consider leo type jobs.)

    exports['ps-dispatch']:CustomAlert(dispatchData)
end)

-- Vangelico Robbery
AddEventHandler("qb-policejob:client:alert-VangelicoRobbery", function(data)
    local dispatchData = {}
    local playerCoords = GetEntityCoords(PlayerPedId())

    -- ## Dispatch display informations ##
    dispatchData.message = "Braquage de Vangelico" -- Title of the alert
    --dispatchData.dispatchCode = 'storerobbery' -- Unique name for each alert
    dispatchData.code = '10-45' -- Code that is displayed before the title
    dispatchData.icon = 'fas fa-gem' -- Icon that is displayed after the title
    dispatchData.priority = 2 -- Changes color of the alert ( 1 = red, 2 = default )
    dispatchData.gender = true -- true or false (Do we know the suspect gender ?)
    dispatchData.camId = data and data.camId or nil -- Cam ID ( for heists and robberies )

    -- ## Vehicle informations ##
    --dispatchData.model =  -- Vehicle model
    --dispatchData.firstColor = nil -- Vehicle first color
    --dispatchData.plate =  -- Vehicle plate
    --dispatchData.doorCount =  -- How many doors on vehicle
    
    -- ## Officer informations ##
    --dispatchData.callsign = PlayerData.metadata["callsign"] -- Officer callsign
    --dispatchData.name = PlayerData.charinfo.firstname .. " " .. PlayerData.charinfo.lastname, -- Officer name
    
    -- ## Guns Type ##
    --dispatchData.automaticGunfire = false -- Automatic Gun or not
    
    -- ## Dispatch timer ##
    dispatchData.alertTime = 5 -- How long it stays on the screen in seconds (Seems to be either at 10 or nil on preconfigure alerts)

    -- ## Blip & Sound settings : ##
    dispatchData.coords = playerCoords -- Player Coords
    dispatchData.radius = 0 -- Radius around the blip
    dispatchData.sprite = 617 -- Sprite of the blip
    dispatchData.color = 1 -- Color of the blip
    dispatchData.scale = 1.0 -- Scale of the blip
    dispatchData.length = 10 -- How long it stays on the map
    --dispatchData.sound =  -- Alert sound (default : "Lose_1st")
    --dispatchData.sound2 =  -- Alert sound (default : "GTAO_FM_Events_Soundset")
    --dispatchData.offset =  -- Blip / radius offset
    --dispatchData.flash =  -- Blip flash (false by default)

    -- Jobs alerted
    dispatchData.jobs = {'leo'} -- { 'police', 'ambulance' } (If nil, will consider leo type jobs.)

    exports['ps-dispatch']:CustomAlert(dispatchData)
end)

-- Go Fast
AddEventHandler("qb-policejob:client:alert-GoFast", function(data)
    local dispatchData = {}
    local playerCoords = GetEntityCoords(PlayerPedId())

    -- ## Dispatch display informations ##
    dispatchData.message = "Go Fast" -- Title of the alert
    --dispatchData.dispatchCode = 'storerobbery' -- Unique name for each alert
    dispatchData.code = '10-45' -- Code that is displayed before the title
    dispatchData.icon = 'fas fa-car-side' -- Icon that is displayed after the title
    dispatchData.priority = 2 -- Changes color of the alert ( 1 = red, 2 = default )
    dispatchData.gender = true -- true or false (Do we know the suspect gender ?)
    --dispatchData.camId = data and data.camId or nil -- Cam ID ( for heists and robberies )

    -- ## Vehicle informations ##
    dispatchData.model = data and data.model or 'Mercedes Benz' -- Vehicle model
    dispatchData.firstColor = data and data.firstColor or 'Rouge' -- Vehicle first color
    dispatchData.plate = data and data.plate or 'NO PLATE' -- Vehicle plate
    dispatchData.doors = data and data.doors or '4' -- How many doors on vehicle
    
    -- ## Officer informations ##
    --dispatchData.callsign = PlayerData.metadata["callsign"] -- Officer callsign
    --dispatchData.name = PlayerData.charinfo.firstname .. " " .. PlayerData.charinfo.lastname, -- Officer name
    
    -- ## Guns Type ##
    --dispatchData.automaticGunfire = false -- Automatic Gun or not
    
    -- ## Dispatch timer ##
    dispatchData.alertTime = 5 -- How long it stays on the screen in seconds (Seems to be either at 10 or nil on preconfigure alerts)

    -- ## Blip & Sound settings : ##
    dispatchData.coords = playerCoords -- Player Coords
    dispatchData.radius = 0 -- Radius around the blip
    dispatchData.sprite = 523 -- Sprite of the blip
    dispatchData.color = 1 -- Color of the blip
    dispatchData.scale = 1.0 -- Scale of the blip
    dispatchData.length = 10 -- How long it stays on the map
    --dispatchData.sound =  -- Alert sound (default : "Lose_1st")
    --dispatchData.sound2 =  -- Alert sound (default : "GTAO_FM_Events_Soundset")
    --dispatchData.offset =  -- Blip / radius offset
    --dispatchData.flash =  -- Blip flash (false by default)

    -- Jobs alerted
    dispatchData.jobs = {'leo'} -- { 'police', 'ambulance' } (If nil, will consider leo type jobs.)

    exports['ps-dispatch']:CustomAlert(dispatchData)
end)