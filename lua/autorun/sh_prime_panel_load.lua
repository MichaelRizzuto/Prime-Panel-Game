--[[
	Name: sh_prime_panel_load.lua
	By: Micro
]]--

if SERVER then
	local f, d = file.Find("prime_panel/client/*.lua", "LUA")

	for k, v in pairs(f) do
		AddCSLuaFile("prime_panel/client/" .. v)
	end

	f, d = file.Find("prime_panel/shared/*.lua", "LUA")

	for k, v in pairs(f) do
		AddCSLuaFile("prime_panel/shared/" .. v)
		include("prime_panel/shared/" .. v)
	end

	f, d = file.Find("prime_panel/server/*.lua", "LUA")

	for k, v in pairs(f) do
		include("prime_panel/server/" .. v)
	end
else
	local f, d = file.Find("prime_panel/shared/*.lua", "LUA")

	for k, v in pairs(f) do
		include("prime_panel/shared/" .. v)
	end

	f, d = file.Find("prime_panel/client/*.lua", "LUA")

	for k, v in pairs(f) do
		include("prime_panel/client/" .. v)
	end
end
