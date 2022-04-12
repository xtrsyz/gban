# gban
FiveM Global Banned
https://discord.com/invite/gaJ3RB2

# Command
`/gban playerId time reason`
or 
`/gban playerId reason`

# Event Integration
from client
```lua
reason = 'teleport'
TriggerServerEvent('gban:selfBan', reason)
```
example
```lua
Citizen.CreateThread(
	function()
		while true do
			Citizen.Wait(Config.AntiGodModeTimer)
			if GetEntityHealth(PlayerPedId()) > ClientConfig.MaxPlayerHealth then
				TriggerServerEvent("gban:selfBan", "AntiGodMode: MaxHealth")
			end
			if GetPlayerInvincible(PlayerId()) then
				TriggerServerEvent("gban:selfBan", "AntiGodMode: GodMode")
				SetPlayerInvincible(PlayerId(), false)
			end
		end
	end
)
```

from server
```lua
playerId = playerId
reason = 'Detected Explosion'
exports.gban:playerBan(playerId, reason)
```
example
```lua
AddEventHandler('explosionEvent', function(playerId, ev)
	if Config.DetectExplosions then
		if Config.ExplosionsList[ev.explosionType] then
			local data = Config.ExplosionsList[ev.explosionType]
			if data.ban then
				result = exports.gban:playerBan(playerId, "Detected Explosion: "..data.name, "The user created this explosion and got detected")
			end
		end;
		CancelEvent()
	end
end)
```
