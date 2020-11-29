--[[
	Name: sv_sql.lua
	By: Micro
]]--

require "mysqloo"

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
