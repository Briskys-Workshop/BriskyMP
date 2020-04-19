--====================================================================================
-- All work by jojos38 & Titch2000.
-- You have no permission to edit, redistribute or upload. Contact us for more info!
--====================================================================================



local M = {}
print("nodesGE Initialising...")
local libDeflate = require('LibDeflate')



-- ============= VARIABLES =============
-- ============= VARIABLES =============



local function tick()
	local ownMap = vehicleGE.getOwnMap() -- Get map of own vehicles
	for i,v in pairs(ownMap) do -- For each own vehicle
		local veh = be:getObjectByID(i) -- Get vehicle
		if veh then
			veh:queueLuaCommand("nodesVE.getNodes()")
		end
	end
end

local function sendNodes(data, gameVehicleID) -- Update electrics values of all vehicles - The server check if the player own the vehicle itself
	if GameNetwork.connectionStatus() == 1 then -- If TCP connected
		local serverVehicleID = vehicleGE.getServerVehicleID(gameVehicleID) -- Get serverVehicleID
		if serverVehicleID and vehicleGE.isOwn(gameVehicleID) then -- If serverVehicleID not null and player own vehicle
			local send = 'Xn:'..serverVehicleID..":"..libDeflate:CompressDeflate(data)
			print(string.len(send))
			GameNetwork.send(send)--Network.buildPacket(0, 2132, serverVehicleID, data))
		end
	end
end

local function applyNodes(data, serverVehicleID)
	local gameVehicleID = vehicleGE.getGameVehicleID(serverVehicleID) or -1 -- get gameID
	local veh = be:getObjectByID(gameVehicleID)
	if veh then
		--local pos = veh:getPosition()
		--veh:setPositionRotation(pos.x, pos.y, pos.z, 0, 0, 0.01, math.random())
		veh:queueLuaCommand("nodesVE.applyNodes(\'"..libDeflate:DecompressDeflate(data).."\')") -- Send nodes values
	end
end

local function handle(rawData)
	print("nodesGE.handle: "..rawData)
	rawData = string.sub(rawData,3)
	local serverVehicleID = string.match(rawData,"(%w+)%:")
	local data = string.match(rawData,":(.*)")
	applyNodes(data, serverVehicleID)
end



M.tick   	   = tick
M.handle     = handle
M.sendNodes  = sendNodes
M.applyNodes = applyNodes



print("nodesGE Loaded.")
return M
