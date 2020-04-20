--====================================================================================
-- All work by jojos38 & Titch2000.
-- You have no permission to edit, redistribute or upload. Contact us for more info!
--====================================================================================



local M = {}



-- ============= VARIABLES =============
local timer = 0
local lastPos = vec3(0,0,0)
-- ============= VARIABLES =============



local function getVehicleRotation()
	local pos = obj:getPosition()
	local distance = nodesVE.distance(pos.x, pos.y, pos.z, lastPos.x, lastPos.y, lastPos.z)
	lastPos = pos

	if (distance < 0.02) then -- When vehicle doesn't move
		if timer < 40 then -- Send 40 times less packets
			timer = timer + 1
			return
		else
			timer = 0
		end
	end

	local tempTable = {}
	local pos = obj:getPosition()
	local vel = obj:getVelocity()
	--local rot = obj:getRotation()
	local rot = {}
	rot.x = obj:getPitchAngularVelocity()
	rot.y = obj:getRollAngularVelocity()
	rot.z = obj:getYawAngularVelocity()
	tempTable['pos'] = {}
	tempTable['pos'].x = pos.x
	tempTable['pos'].y = pos.y
	tempTable['pos'].z = pos.z
	tempTable['vel'] = {}
	tempTable['vel'].x = vel.x
	tempTable['vel'].y = vel.y
	tempTable['vel'].z = vel.z
	tempTable['ang'] = {}
	tempTable['ang'].x = rot.x
	tempTable['ang'].y = rot.y
	tempTable['ang'].z = rot.z
	--print(dump(tempTable))
	obj:queueGameEngineLua("positionGE.sendVehiclePosRot(\'"..jsonEncode(tempTable).."\', \'"..obj:getID().."\')") -- Send it
end



M.getVehicleRotation = getVehicleRotation



return M
