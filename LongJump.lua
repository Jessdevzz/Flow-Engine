local player = game.Players.LocalPlayer
local humanoidRootPart = player.Character:WaitForChild("HumanoidRootPart")
local isOnEdge = false
local hum = player.Character.Humanoid
local ts = game:GetService('TweenService')
while _G.Globals == nil do
	wait()
end
local globals = _G.Globals
local rs = game:GetService('ReplicatedStorage')
local mm = require(rs.Modules.MovementModule)
print(mm)
local lasthjtime = time()
local minhjtime = 2.5

local function RayToPart(ray)
	local midPoint = ray.Origin + ray.Direction/2
	local part = Instance.new("Part")
	part.CanCollide = false
	part.Transparency = 0.5
	part.Anchored = true
	part.CFrame = CFrame.new(midPoint, ray.Origin)
	part.Size = Vector3.new(1, 1, ray.Direction.Magnitude)
	part.Parent = player.Character
	game.Debris:AddItem(part, 0.03)
	return part
end

if humanoidRootPart then
	print('hrp')
	local function checkEdge()
		local rootPartPos = humanoidRootPart.Position
		local ray = Ray.new(rootPartPos + humanoidRootPart.CFrame.LookVector * 2.25, Vector3.new(0, -5, 0)) -- 1.7
		--RayToPart(ray)
		local hit, hitPos, hitNorm = workspace:FindPartOnRayWithIgnoreList(ray, player.Character:GetChildren())
		if hit == nil and hum.FloorMaterial ~= Enum.Material.Air and globals.inaction == false then
			isOnEdge = true
			--print('onedge')
		else
			isOnEdge = false
		end
	end
	game:GetService("RunService").RenderStepped:Connect(checkEdge)
end
local uis = game:GetService('UserInputService')
local function start()
	local boost = Instance.new('BodyVelocity',humanoidRootPart)
	boost.Name = 'lj'
	boost.MaxForce = Vector3.new(1,1,1)*math.huge
	boost.Velocity = humanoidRootPart.CFrame.LookVector * 15 * hum.WalkSpeed/10
	boost.Velocity = Vector3.new(boost.Velocity.X, 15 * hum.WalkSpeed/10, boost.Velocity.Z)
	globals.inaction = true
	isOnEdge = false
	game.Debris:AddItem(boost, 0.3)
	mm.speed(0.3, 14)
	globals.fallstart = humanoidRootPart.Position.Y
	globals.inaction = false
end
local function altjump() -- edgejump
	local boost = Instance.new('BodyVelocity',humanoidRootPart)
	boost.Name = 'lj'
	boost.MaxForce = Vector3.new(1,1,1)*math.huge
	boost.Velocity = humanoidRootPart.CFrame.LookVector * 13.5 * hum.WalkSpeed/10
	boost.Velocity = Vector3.new(boost.Velocity.X, 60, boost.Velocity.Z)
	globals.inaction = true
	isOnEdge = false
	game.Debris:AddItem(boost, 0.08)
	mm.speed(0.3, 10)
	globals.fallstart = humanoidRootPart.Position.Y
	globals.inaction = false
end

local function highjump()
	lasthjtime = time()
	local boost = Instance.new('BodyVelocity',humanoidRootPart)
	boost.Name = 'lj'
	boost.MaxForce = Vector3.new(1,1,1)*math.huge
	boost.Velocity = humanoidRootPart.CFrame.LookVector * 35 * hum.WalkSpeed/24
	boost.Velocity = Vector3.new(boost.Velocity.X, 35 , boost.Velocity.Z)
	globals.inaction = true
	isOnEdge = false
	game.Debris:AddItem(boost, 0.3)
	mm.speed(0.3, 5)
	globals.fallstart = humanoidRootPart.Position.Y
	globals.inaction = false
end

local function keys()
	local canlj = false
	for _, k in  ipairs(uis:GetKeysPressed()) do
		if k.KeyCode == Enum.KeyCode.LeftShift or k.KeyCode == Enum.KeyCode.ButtonR2 then
			canlj = true
			
		end
	end
	if uis.GamepadEnabled then

		local state = uis:GetGamepadState(Enum.UserInputType.Gamepad1)
		for _, k in pairs(state) do
			if k.KeyCode == Enum.KeyCode.ButtonR2 and k.UserInputState == Enum.UserInputState.Begin then
				canlj = true

			end
		end
	end
	return canlj
end

uis.InputBegan:Connect(function(key, chat)

	if (key.KeyCode == Enum.KeyCode.Space or key.KeyCode == Enum.KeyCode.ButtonA) and isOnEdge == true and globals.inaction == false then
		if keys() == true then
			start()
		elseif isOnEdge == true then
			altjump()
		end
	elseif (key.KeyCode == Enum.KeyCode.Space or key.KeyCode == Enum.KeyCode.ButtonA) and globals.inaction == false then
		if keys() == true and hum.FloorMaterial ~= Enum.Material.Air and time() - lasthjtime >= minhjtime then
			highjump()
		end
	end
end)
player.CharacterAdded:Connect(function()
	local player = game.Players.LocalPlayer
	local humanoidRootPart = player.Character:WaitForChild("HumanoidRootPart")
	local isOnEdge = false
	local hum = player.Character.Humanoid
	while _G.Globals == nil do
		wait()
	end
	local globals = _G.Globals
end)
