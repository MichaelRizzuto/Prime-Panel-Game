--[[
	Name: sv_sql.lua
	By: Micro
]]--

require "mysqloo"

local receivedata

local host = PRIME_PANEL_CONFIG.DB_Host
local user = PRIME_PANEL_CONFIG.DB_User
local pass = PRIME_PANEL_CONFIG.DB_Pass
local db = PRIME_PANEL_CONFIG.DB_Database
local port = PRIME_PANEL_CONFIG.DB_Port

local conn = mysqloo.connect(host, user, pass, db, port)

function conn:onConnected()
	print("Panel successfully connected to database.")
end

function conn:onConnectionFailed(error)
	return Error("Panel couldn't connect to database: " .. error .. "\n")
end

conn:connect()

--
-- Player Initialization
--

hook.Add("PlayerInitialSpawn", "PlayerToPanelInit", function(ply)
	ply:SetNWFloat("PanelPlaytime", 0)
	timer.Simple(5, function()
		local q = conn:prepare("SELECT * FROM `users` WHERE `sid` = '" .. ply:SteamID64() .. "'")
		function q:onSuccess(data)
			if not data[1] then
				local i = conn:prepare("INSERT INTO `users` (`sid`, `ip`, `playtime`, `lastplayed`, `activeserver`) VALUES ('" .. ply:SteamID64() .. "', '" .. ply:IPAddress() .. "', '0', '" .. os.date("%m/%d/%y") .. "', '" .. PRIME_PANEL_CONFIG.ID .. "')")
				i:start()
				ply:SetNWFloat("PanelPlaytime", 0)
			else
				local q = conn:prepare("UPDATE `users` SET `activeserver` = '" .. PRIME_PANEL_CONFIG.ID .. "' WHERE `sid` = '" .. ply:SteamID64() .. "'")
				q:start()
				for k, v in pairs(data) do
					ply:SetNWFloat("PanelPlaytime", v.playtime)
				end
			end
		end
		q:start()
	end)
end)

--
-- Player Disconnection
--

hook.Add("PlayerDisconnected", "PlayerToPanelDis", function(ply)
	local steamid = ply:SteamID64()
	local q = conn:prepare("UPDATE `users` SET `activeserver` = 'none' WHERE `sid` = '" .. steamid .. "'")
	q:start()
end)
