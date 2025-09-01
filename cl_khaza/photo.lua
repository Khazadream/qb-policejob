--- #####################################################################

--- ################## Images Uploading Config ##########################

--- #####################################################################

local apiURL = "https://fmapi.net/api/v2/image?apiKey="
local API = "6MNXwVvumKNjH9zIoxIJV44EeqeuMrbZ"

function RegisterPhoto()
    exports['screenshot-basic']:requestScreenshotUpload(apiURL..''..API, 'file', function(data)
        local resp = json.decode(data)
        if resp then
            local imageURL = resp.data.url or nil
            TriggerServerEvent('qb-log:server:CreateLog', 'photos', "**New Screenshot**", 16753920, imageURL, false, imageURL)
            TriggerEvent("evange-core:client:robbery:create-photo", imageURL)
            --TriggerEvent("evange-core:client:robbery:create-photo", imageURL, os.date('%Y-%m-%d %H:%M:%S'))
        end
    end)
end