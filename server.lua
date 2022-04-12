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
        local response = PostData({identifier = identifier})
        if response then
            local data = json.decode(response)
            if data['reason'] then
                deferrals.done("Reason: " .. data['reason'])
            else
                deferrals.done()
            end
        end
    end
end)

RegisterCommand('gban', function(playerId, args, rawCommand)
    if (IsPlayerAceAllowed(playerId, 'command')) then
        staff = GetPlayerIdentifiers(playerId)[1]

        local ban = tonumber(args[1])
        local expires = nil
        
        if tonumber(args[2]) ~= nil then
            expires = args[2]
            table.remove(args, 1)
            table.remove(args, 1)
        else
            table.remove(args, 1)
        end        
        
        reason = table.concat(args, ' ')
        banByPlayerId(ban, reason, expires, staff)
    end
end)

RegisterCommand('gbanlist', function(playerId, args, rawCommand)
    if (IsPlayerAceAllowed(playerId, 'command')) then
        local staff = GetPlayerIdentifiers(playerId)[1]
        local hash = gbanHash(staff)
        local result = nil
        result = PostData({list = staff, hash = hash})
        result = json.decode(result)
        TriggerClientEvent('gban:list', playerId, result.list)
    end
end)

RegisterCommand('gbanident', function(playerId, args, rawCommand)
    if (IsPlayerAceAllowed(playerId, 'command')) then
        staff = GetPlayerIdentifiers(playerId)[1]

        local ban = args[1]
        local expires = nil
        
        if tonumber(args[2]) ~= nil then
            expires = args[2]
            table.remove(args, 1)
            table.remove(args, 1)
        else
            table.remove(args, 1)
        end        
        
        reason = table.concat(args, ' ')
        banByIdentifier(ban, reason, expires, staff)
    end
end)

RegisterServerEvent('gban:selfBan')
AddEventHandler('gban:selfBan', function (reason, time, staff)
    banByPlayerId(source, reason, time, staff)
end)

RegisterServerEvent('gban:playerBan')
AddEventHandler('gban:playerBan', function (playerId, reason, time)
    if (IsPlayerAceAllowed(source, 'command')) then
        local staff = GetPlayerIdentifiers(source)[1]
        banByPlayerId(playerId, reason, time, staff)
    end
end)

RegisterServerEvent('gban:remove')
AddEventHandler('gban:remove', function (hash, staff)
    if (IsPlayerAceAllowed(source, 'command')) then
        local staff = GetPlayerIdentifiers(source)[1]
        gbanRemove(hash, staff)
    end
end)

function banByPlayerId(playerId, reason, expires, staff)
    local identifiers = json.encode(GetPlayerIdentifiers(playerId))
    local reason = reason or Config.DefaultReason
    local staff = staff or Config.ServerName
    local hash = gbanHash(identifiers, staff)

    if type(expires) == 'number' and expires < os.time() then
        expires = os.time()+expires 
    end

    if Config.Kick then DropPlayer(playerId, reason) end
    return PostData({ban = identifiers, reason = reason, staff = staff, expires = expires, hash = hash})
end

function banByIdentifier(identifiers, reason, expires, staff)
    if type(identifiers) ~= 'table' then identifiers = {identifiers} end
    identifiers = json.encode(identifiers)
    local reason = reason or Config.DefaultReason
    
    if type(expires) == 'number' and expires < os.time() then
        expires = os.time()+expires 
    end
    
    local staff = staff or Config.ServerName
    local hash = gbanHash(identifiers, staff)
    return PostData({ban = identifiers, reason = reason, staff = staff, expires = expires, hash = hash})
end

function gbanRemove(serial, staff)
    local staff = staff or Config.ServerName
    local hash = gbanHash(serial, staff)
    return PostData({remove = serial, staff = staff, hash = hash})
end

function PostData(data)
    local result = nil
    PerformHttpRequest("https://dejavu.gigne.net/fivem/ban-list/", function(err, response, headers)
        if err == 200 then
            result = response
        else
            result = json.encode({error = err, message = response})
        end
    end, 'POST', json.encode(data), { ['Content-Type'] = 'application/json' })
    while result == nil do
        Wait(0)
    end
    return result
end

exports('playerBan', banByPlayerId)
exports('identifierBan', banByIdentifier)
exports('remove', gbanRemove)
