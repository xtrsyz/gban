AddEventHandler('playerConnecting', function(name, setCallback, deferrals)
    deferrals.defer()
    deferrals.update("Checking Player Information. Please Wait.")
    local nickname, identifier, license, steam, discord, fivem, xbl, live, ip
    
    identifier = json.encode(GetPlayerIdentifiers(source))

    for k,v in ipairs(GetPlayerIdentifiers(source)) do
        if string.find(v, "license:") then
            license = v
        end
        if string.find(v, "steam:") then
            steam = v
        end
        if string.find(v, "fivem:") then
            fivem = v
        end
        if string.find(v, "discord:") then
            discord = v
        end
        if string.find(v, "xbl:") then
            xbl = v
        end
        if string.find(v, "live:") then
            live = v
        end
        if string.find(v, "ip:") then
            ip = v
        end
    end
    
    if not steam or not license then
        deferrals.done("[Identifier Not Found]")
    else        
        PerformHttpRequest("https://dejavu.gigne.net/fivem/ban-list/", function(err, response, headers) 
            if response then
                local data = json.decode(response)
                if data['reason'] then
                    deferrals.done("Reason: " .. data['reason'])
                else
                    deferrals.done()
                end
            end
        end, 'POST', json.encode({identifier = identifier}), { ['Content-Type'] = 'application/json' })
    end
end)