local menuOpen
function openMenu(list)
WarMenu.CreateMenu('banlist', 'Banned Global')
WarMenu.SetSubTitle('banlist', 'Banned List')
WarMenu.CreateSubMenu('unban', 'banlist', 'Unban?')
	menuOpen = true
	WarMenu.OpenMenu('banlist')
	local serial, key
	Citizen.CreateThread(function()
		while menuOpen do
			Wait(0)
			if WarMenu.Begin('banlist') then
				for k,v in pairs(list) do
					local hash = v.hash and v.hash or '#'
					local name = v.name and v.name or '-'
					if WarMenu.MenuButton("["..hash.."] "..name, 'unban') then
						WarMenu.SetSubTitle('unban', "["..hash.."]"..name)
						serial = v.hash
						key = k
					end
					if WarMenu.IsItemHovered() then
						WarMenu.ToolTip(v.reason, nil, true)
					end
				end
				WarMenu.End()
			elseif WarMenu.Begin('unban') then
				if WarMenu.MenuButton("Back", 'unban') then
					WarMenu.OpenMenu('banlist')
				elseif WarMenu.MenuButton("Unban", 'unban') then
					TriggerServerEvent('gban:remove', serial)
					table.remove(list,key)
					WarMenu.OpenMenu('banlist')
				end
				WarMenu.End()
			end
			if not WarMenu.IsAnyMenuOpened() then
				menuOpen = false
			end
		end
	end)
end

RegisterNetEvent('gban:list')
AddEventHandler('gban:list', function(list)
	if list then
		menuOpen = false
		openMenu(list)
	else
		print('no banlist')
	end
end)