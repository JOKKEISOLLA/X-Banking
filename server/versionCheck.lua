local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')
local versionEndpoint = 'https://scripts.xproject.fi/X-Banking.txt'

local function retrieveVersionData(callback)
    PerformHttpRequest(versionEndpoint, function(statusCode, responseBody, headers)
        if statusCode == 200 then
            local fetchedVersion = responseBody:match("version: '(%d+%.%d+%.%d+)'")
            callback(fetchedVersion)
        else
            print("^1Error: Could not retrieve version information.")
            callback(false)
        end
    end, 'GET')
end

local function initiateVersionCheck()
    retrieveVersionData(function(fetchedVersion)
        if fetchedVersion and currentVersion ~= fetchedVersion then
            print("^3--------------------------------------------------------------------------------\n[X-AtmRobbery] - Script is not current. Your version: " .. currentVersion .. ", Latest version: " .. fetchedVersion .. ".\n--------------------------------------------------------------------------------^0")
        elseif fetchedVersion then
            print("^2--------------------------------------------------------------------------------\n[X-AtmRobbery] - Script is up to date with version " .. currentVersion .. ".\n--------------------------------------------------------------------------------^0")
        end
    end)
end

Citizen.CreateThread(function()
    initiateVersionCheck()
end)