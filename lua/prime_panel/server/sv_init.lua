--[[
	Name: sv_init.lua
	By: Micro
]]--

function requestPanelDataFromAPI()
	if timer.Exists("PanelAPIRequestTimer") then
		timer.Remove("PanelAPIRequestTimer")
	end
	timer.Create("PanelAPIRequestTimer", 1, 0, function()
		http.Fetch(PRIME_PANEL_CONFIG.URL .. "/api/?token=" .. PRIME_PANEL_CONFIG.SteamAPIKey .. "&id=" .. PRIME_PANEL_CONFIG.ID,
			function(body, length, headers, code)
				print(body)
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