--[[
	Name: sv_init.lua
	By: Micro
]]--

function requestPanelDataFromAPI()
	if timer.Exists("PanelAPIRequestTimer") then
		timer.Remove("PanelAPIRequestTimer")
	end

	-- Warns
	timer.Create("PanelAPIRequestTimerWarns", 1, 0, function()
		http.Fetch(PRIME_PANEL_CONFIG.URL .. "/api/?token=" .. PRIME_PANEL_CONFIG.SteamAPIKey .. "&id=" .. PRIME_PANEL_CONFIG.ID .. "&warns=true",
			function(body, length, headers, code)
				print(body)
				local warnstable = util.JSONToTable(body)
				PrintTable(warnstable)
			end,
			function(message)
				print(message)
				requestPanelDataFromAPI()
			end
		)
	end)

	-- Kicks
	timer.Create("PanelAPIRequestTimerKicks", 1, 0, function()
		http.Fetch(PRIME_PANEL_CONFIG.URL .. "/api/?token=" .. PRIME_PANEL_CONFIG.SteamAPIKey .. "&id=" .. PRIME_PANEL_CONFIG.ID .. "&kicks=true",
			function(body, length, headers, code)
				print(body)
				local kickstable = util.JSONToTable(body)
				PrintTable(kickstable)
			end,
			function(message)
				print(message)
				requestPanelDataFromAPI()
			end
		)
	end)

	-- Bans
	timer.Create("PanelAPIRequestTimerBans", 1, 0, function()
		http.Fetch(PRIME_PANEL_CONFIG.URL .. "/api/?token=" .. PRIME_PANEL_CONFIG.SteamAPIKey .. "&id=" .. PRIME_PANEL_CONFIG.ID .. "&bans=true",
			function(body, length, headers, code)
				print(body)
				local banstable = util.JSONToTable(body)
				PrintTable(banstable)
			end,
			function(message)
				print(message)
				requestPanelDataFromAPI()
			end
		)
	end)
end

hook.Add("Initialize", "StartRequestDataFromAPI", function()
	timer.Simple(1, function()
		requestPanelDataFromAPI()
	end)
end)