-- Global Positioning Scrambler
-- (c) Joschua Kesper, 2024

local original_gps = '/rom/programs/gps'
local function print_usage()
	local prog = arg[0] or fs.getName(shell.getRunningProgram())
	shell.execute(original_gps)
	print(prog .. ' scramble')
	print(prog .. ' scramble <x> <y> <z>')
end

local args = { ... }
if #args < 1 then
	return print_usage()
elseif args[1] == 'scramble' then
	local modem = peripheral.find('modem', function(_, modem) return modem.isWireless() end)
	if not modem then
		print 'No wireless modems found. 1 required.'
		return
	end
	local fixed
	if #args == 4 then
		fixed = true
	elseif #args == 1 then
		fixed = false
	else
		print 'Invalid number of parameters'
		return print_usage()
	end
	local x, y, z
	if fixed then
		x, y, z = tonumber(args[2]), tonumber(args[3]), tonumber(args[4])
		if x == nil or y == nil or z == nil then
			print 'Malformed number'
			return print_usage()
		end
	end

	modem.open(gps.CHANNEL_GPS)
	local served = 0
	while true do
		if not fixed then x, y, z = math.random(-1e3, 1e3), math.random(-1e3, 1e3), math.random(-1e3, 1e3) end
		local pos = vector.new(x, y, z)

		local stations_dir = {}
		for i = 1, 4 do
			-- pick random point in cube, simpler than random point using gaussians
			-- close distances could lead to ambigious locations
			local dir = vector.new(
				math.random(-1e3, 1e3),
				math.random(-1e3, 1e3),
				math.random(-1e3, 1e3))
			-- ignore potential zero vector
			stations_dir[i] = dir:normalize()
		end

		local _, _, channel, reply, msg, dist = os.pullEvent 'modem_message'
		if channel == gps.CHANNEL_GPS and msg == 'PING' and dist then
			for _, station_dir in ipairs(stations_dir) do
				local res = pos + station_dir * dist
				modem.transmit(reply, gps.CHANNEL_GPS, { res.x, res.y, res.z })
			end
			served = served + 1
			if served > 1 then term.setCursorPos(1, ({ term.getCursorPos() })[2] - 1) end
			print(served .. ' GPS requests scrambled')
		end
	end
else
	shell.execute(original_gps, table.unpack(args, 2))
end
