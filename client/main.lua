CustomModel = {}
Object = {}
Model = {}
RotationBlocked = 90
lockpickOffset = Vector2(0, 0)
MousePosition = Vector2(0, 0)
lockpickRange = Vector2(0, 0)
OldRotationY = 0

addEvent("onClientPlayerStartlockpicking", true)
addEvent("onClientPlayerStoplockpicking", true)

function createCustomModelObject(fileName)
	CustomModel[#CustomModel+1] = #CustomModel+980
	if fileExists("res/models/textures.txd") and fileExists("res/models/"..fileName..".dff") and fileExists("res/models/"..fileName..".col") then
		local modelID = CustomModel[#CustomModel]
		txd = engineLoadTXD("res/models/textures.txd")
        engineImportTXD(txd, modelID)
        dff = engineLoadDFF("res/models/"..fileName..".dff")
        engineReplaceModel(dff, modelID)
        col = engineLoadCOL("res/models/"..fileName..".col")
		engineReplaceCOL(col, modelID)
		return modelID
	else
		return false
	end
end

addEventHandler( "onClientResourceStart", resourceRoot, function()
	Model.lock = createCustomModelObject("lock")
	Model.screwdriver = createCustomModelObject("screwdriver")
	Model.lockpick = createCustomModelObject("lockpick")
	createlockpickingMechanic()
end)

local function round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

local function getPointFromDistanceRotation(x, y, dist, angle)
    local a = math.rad(90 - angle)
    local dx = math.cos(a) * dist
    local dy = math.sin(a) * dist
    return x+dx, y+dy;
end

local function bettwenMath(min, max, value)
  	return math.min(math.max(value, min), max)
end

function createlockpickingMechanic()	
	local x, y, z, _, _, _ = getCameraMatrix()
	local _, _, z = getElementPosition(localPlayer)
	local rotation = 360 - getPedCameraRotation( localPlayer )
	x, y = getPointFromDistanceRotation(x, y, 5, -rotation)
	z = z+0.55
	Object.lock = createObject(Model.lock, x, y, z, 0, 0, rotation)
	Object.screwdriver = createObject(Model.screwdriver, x, y, z)
	Object.lockpick = createObject(Model.lockpick, x, y, z)
	
	lockpickMarginError = math.random(1, 10)/10
	lockpickRange = Vector2( math.random(0, 25), math.random(65, 100) )

	setElementCollisionsEnabled(Object.lock, false)
	setElementCollisionsEnabled(Object.screwdriver, false)
	setElementCollisionsEnabled(Object.lockpick, false)
	attachElements(Object.screwdriver, Object.lock, -0.14, 0.1, -0.09, 100, 45, 0)
	attachElements(Object.lockpick, Object.lock, 0, 0.0, 0.15, 75, 0, 5)
	showPlayerHudComponent("all", false)
	setElementAlpha(localPlayer, 0)
	setPedWeaponSlot( localPlayer, 0 )
	toggleAllControls(false, true, false)
	showCursor( true )
	setCursorAlpha(0)
	addEventHandler( "onClientRender", root, onClientRender)
	addEventHandler( "onClientCursorMove", root, onClientCursorMove)
	addEventHandler( "onClientKey", root, onClientKey)
	triggerEvent("onClientPlayerStartlockpicking", localPlayer)
end

function destroyLockpickingMechanic(sucess)
	if isElement(Object.lock) then
		destroyElement( Object.lock )
	end
	if isElement(Object.screwdriver) then
		destroyElement( Object.screwdriver )
	end
	if isElement(Object.lockpick) then
		destroyElement( Object.lockpick )
	end
	setElementAlpha(localPlayer, 255)
	toggleAllControls(true, true, false)
	showCursor(false)
	setCursorAlpha(255)
	removeEventHandler( "onClientRender", root, onClientRender)
	removeEventHandler( "onClientCursorMove", root, onClientCursorMove)
	removeEventHandler( "onClientKey", root, onClientKey)
	triggerEvent("onClientPlayerStoplockpicking", localPlayer)
end
 
function onClientKey(button, press)
	if button == "d" and press then
   		local offsetX = math.abs(-25-lockpickOffset.x)
   		local precentX = round(100 - math.abs( ( (lockpickRange.x - offsetX) / lockpickRange.x) * 100)  )
   		local precentY = round(100 - math.abs( ( (lockpickRange.y - lockpickOffset.y) / lockpickRange.y ) * 100)  )
   		RotationBlocked = 90*(precentX+precentY)/200
   		if 90-90*lockpickMarginError > RotationBlocked then
   			RotationBlocked = 90
   		end
	end
end

function onClientRender()
	local rotationX, rotationY, rotaionZ = getElementRotation(Object.lock)
	local differenceRotation = OldRotationY-rotationY
	OldRotationY = rotationY
	if getKeyState("d") == true then
		setElementRotation(Object.lock, rotationX, rotationY > 90 and 90 or rotationY+5, rotaionZ)
		setCursorPosition( MousePosition.x, MousePosition.y)
	else
		setElementRotation(Object.lock, rotationX, rotationY > 0 and rotationY-5 or rotationY, rotaionZ)
	end
	if differenceRotation < 0 then
		if rotationY >= RotationBlocked then
			if 	RotationBlocked == 90 then
				setElementRotation(Object.lock, rotationX, RotationBlocked, rotaionZ)
				destroyLockpickingMechanic(true)
			else
				setElementRotation(Object.lock, rotationX, rotationY-5, rotaionZ)
			end
		end
	end
end

function onClientCursorMove(cursorX, cursorY)
	if getKeyState("d") == false then
		local cursorX, cursorY = getCursorPosition(  )
   		local sx, sy = guiGetScreenSize ( )
		local cx, cy = getCursorPosition ( )
		local cx, cy = ( cx * sx ), ( cy * sy )
   		setElementAttachedOffsets(Object.lockpick, 0, 0, 0.15, bettwenMath(65, 100, 65+cursorY*75), 5, bettwenMath(-25, 25, -25+65*cursorX)  )
   		lockpickOffset = Vector2( bettwenMath(-25, 25, -25+65*cursorX), bettwenMath(65, 100, 65+cursorY*75) )
   		MousePosition = Vector2(cx, cy)
   end
end