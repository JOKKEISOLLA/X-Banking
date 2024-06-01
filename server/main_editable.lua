local Webhook = 'edit me'

Log = function(source, type, summa)
    if X.EnableLogs then
        local steamId = 'Not linked'
        local license = 'Not linked'
        local discord = 'Not linked'
        local xbl = 'Not linked'
        local liveid = 'Not linked'
        local ip = 'Not linked'

        for k, v in pairs(GetPlayerIdentifiers(source)) do
            if string.sub(v, 1, string.len('steam:')) == 'steam:' then
                steamId = v
            elseif string.sub(v, 1, string.len('license:')) == 'license:' then
                license = v
            elseif string.sub(v, 1, string.len('xbl:')) == 'xbl:' then
                xbl = v
            elseif string.sub(v, 1, string.len('ip:')) == 'ip:' then
                ip = string.sub(v, 4)
            elseif string.sub(v, 1, string.len('discord:')) == 'discord:' then
                discordId = string.sub(v, 9)
                discord = '<@' .. discordId .. '>'
            elseif string.sub(v, 1, string.len('live:')) == 'live:' then
                liveId = v
            end
        end
        local target = target
        local connect = {
            {
                ["color"] = "8663711",
                ["title"] = "X-Banking",
                ["description"] = type.. '\nValue: `$' ..summa.. '`\n\n\nSteam: `' ..steamId.. '`\nLicense: `' ..license.. '`\nXbox live: `' ..xbl.. '`\nIP: ||`' ..ip.. '`|| \nDiscord: ' ..discord.. '\nLive: `' ..liveId.. '`',
            }
        }
        PerformHttpRequest(Webhook, function(err, text, headers) end, 'POST', json.encode({username = "LOG", embeds = connect}), { ['Content-Type'] = 'application/json' })
    end
end
