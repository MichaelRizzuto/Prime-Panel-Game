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
-- Server Initialization
--

hook.Add("Initialize", "ServerToPanelInit", function()
	timer.Simple(1, function()
		local q = conn:prepare("UPDATE `users` SET `activeserver` = 'none' WHERE `activeserver` = '" .. PRIME_PANEL_CONFIG.ID .. "'")
		q:start()
	end)
end)

--
-- Timer Logic
--

function StartPanelTimer(ply, steamid)
	timer.Create("PanelTimer" .. ply:SteamID64(), 60, 0, function()
		if ply:IsPlayer() then
			ply:SetNWFloat("PanelPlaytime", ply:GetNWFloat("PanelPlaytime")+1)
			local q = conn:prepare("UPDATE `users` SET `playtime` = '" .. ply:GetNWFloat("PanelPlaytime") .. "' WHERE `sid` = '" .. ply:SteamID64() .. "'")
			q:start()
			local t = conn:prepare("UPDATE `users` SET `lastplayed` = '" .. os.time() .. "' WHERE `sid` = '" .. ply:SteamID64() .. "'")
			t:start()
		else
			local i = conn:prepare("UPDATE `users` SET `activeserver` = 'none' WHERE `sid` = '" .. steamid .. "'")
			i:start()
			if timer.Exists("PanelTimer" .. steamid) then
				timer.Remove("PanelTimer" .. steamid)
			end
		end
	end)
end

--
-- Player Initialization
--

hook.Add("PlayerInitialSpawn", "PlayerToPanelInit", function(ply)
	ply:SetNWFloat("PanelPlaytime", 0)
	timer.Simple(5, function()
		local q = conn:prepare("SELECT * FROM `users` WHERE `sid` = '" .. ply:SteamID64() .. "'")
		function q:onSuccess(data)
			if not data[1] then
				local i = conn:prepare("INSERT INTO `users` (`sid`, `ip`, `playtime`, `lastplayed`, `activeserver`) VALUES ('" .. ply:SteamID64() .. "', '" .. ply:IPAddress() .. "', '0', '" .. os.time() .. "', '" .. PRIME_PANEL_CONFIG.ID .. "')")
				i:start()
				ply:SetNWFloat("PanelPlaytime", 0)
				StartPanelTimer(ply, ply:SteamID64())
			else
				local n = conn:prepare("UPDATE `users` SET `activeserver` = '" .. PRIME_PANEL_CONFIG.ID .. "' WHERE `sid` = '" .. ply:SteamID64() .. "'")
				n:start()
				local t = conn:prepare("UPDATE `users` SET `lastplayed` = '" .. os.time() .. "' WHERE `sid` = '" .. ply:SteamID64() .. "'")
				t:start()
				for k, v in pairs(data) do
					ply:SetNWFloat("PanelPlaytime", v.playtime)
				end
				StartPanelTimer(ply, ply:SteamID64())
			end
		end
		q:start()
	end)
end)