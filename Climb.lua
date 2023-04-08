local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild('Humanoid')
local root = char:WaitForChild('HumanoidRootPart')
local ani = script:WaitForChild('Animation')
local climbani = hum:LoadAnimation(ani)
local uis = game:GetService('UserInputService')
local isclimbing = false
local canclimb = true
local rs = game:GetService('RunService')
local starttime = time()
local Head = char:WaitForChild('Head')
local r = nil
local hit = nil local position = nil
local connection
while _G.Globals == nil do
	wait()
end
local boost
local globals = _G.Globals
local maxfallen = -40
local mm = require(game:GetService('ReplicatedStorage').Modules.MovementModule)

local function startclimbing()
	print('habalaladoodoo')
	isclimbing = true
	boost = Instance.new('BodyVelocity',root)
	boost.MaxForce = Vector3.new(1,1,1)*math.huge
	boost.Velocity = Vector3.new(0,10 * hum.WalkSpeed/13,0)
	climbani:Play()
	starttime = time()
	globals.inaction = true
	globals.action = 'climbing'

end
local function stopclimbing()
	print('unballala')
	climbani:Stop()
	canclimb = false
	boost:Destroy()
	isclimbing = false
	globals.inaction = false
	globals.action = ''
end

uis.InputBegan:Connect(function(key)
	if key.KeyCode == Enum.KeyCode.Space or key.KeyCode == Enum.KeyCode.ButtonA then
		if isclimbing == true and time() - starttime > 0.1 then
			stopclimbing()
		end

		if isclimbing == false and canclimb == true and hum.FloorMaterial == Enum.Material.Air and hit ~= nil and hit.Name ~= 'dni' and 
			globals.falldistance > maxfallen and globals.inaction == false and mm.canclimb(Head, hit) == true then
			startclimbing()
		end
	end
end)
rs.Heartbeat:Connect(function()
	r = Ray.new(root.Position, root.CFrame.LookVector*3.5)
	hit, position = workspace:FindPartOnRayWithIgnoreList(r, {char, workspace.Baseplate})
	if hit ~= nil and hit.Name == 'dni' then hit = nil end
	if (isclimbing == true and time() - starttime > 1) or (hit == nil and isclimbing == true) then
		if hit == nil then
			wait(0.2)
			stopclimbing()
		else
			stopclimbing()
		end
		
	end
	if isclimbing == true then
		globals.falldistance = 0
		globals.fallstart = root.Position.Y
	end
end)
hum.StateChanged:Connect(function(oldState, newState)


	if newState == Enum.HumanoidStateType.Landed then
		canclimb = true
	end
end)
