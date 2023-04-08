local uis = game:GetService('UserInputService')
local mm = require(game:GetService('ReplicatedStorage').Modules.MovementModule)
local wasdkeys = {--[[Enum.KeyCode.W, Enum.KeyCode.S, Enum.KeyCode.D, Enum.KeyCode.A--]]}
local char = game.Players.LocalPlayer.Character
local hum = char.Humanoid
local root = char.HumanoidRootPart
local veltime = 0.2
local canwallkick = time()
local cooldown = -1.5
while _G.Globals == nil do
	wait()
end
local globals = _G.Globals
local ani = script:WaitForChild('Animation')
local wallkicktrack = hum:LoadAnimation(ani)
local function RayToPart(ray)
	local midPoint = ray.Origin + ray.Direction/2
	local part = Instance.new("Part")
	part.CanCollide = false
	part.Transparency = 0
	part.Anchored = true
	part.CFrame = CFrame.new(midPoint, ray.Origin)
	part.Size = Vector3.new(1, 1, ray.Direction.Magnitude)
	part.Parent = workspace
	--game.Debris:AddItem(part, 0.03)
	return part
end

local function getwasd()
	local wasd = false
	for _, k in  ipairs(uis:GetKeysPressed()) do
		if table.find(wasdkeys, k.KeyCode) then
			wasd = true
		end
	end
	return wasd
end
local function wallkick()
	print('weee')
	wallkicktrack:Play()
	globals.inaction = true
	canwallkick = time()
	local vel = Instance.new('BodyVelocity', root)
	vel.MaxForce = Vector3.new(1,1,1) * math.huge
	vel.Velocity = root.CFrame.LookVector * (hum.WalkSpeed) * 1.15
	vel.Velocity = Vector3.new(vel.Velocity.X, vel.Velocity.Y + 2 * hum.WalkSpeed, vel.Velocity.Z)
	globals.fallstart = root.Position.Y
	mm.speed(veltime, 10)
	game.Debris:AddItem(vel, veltime)
	wait(veltime)
	globals.inaction = false
end
uis.InputBegan:Connect(function(key)
	if (key.KeyCode == Enum.KeyCode.Space or key.KeyCode == Enum.KeyCode.ButtonA) and canwallkick - time() <= cooldown then
		if getwasd() == false and hum.FloorMaterial == Enum.Material.Air and globals.falldistance >= -35 and globals.inaction == false then
			local r = Ray.new(root.Position, root.CFrame.LookVector*-3.5)
			local hit, position = workspace:FindPartOnRayWithIgnoreList(r, {char, workspace.Baseplate})
			--RayToPart(r)
			if hit ~= nil then
				wallkick()
			end
		end
	end
end)
--[[hum.StateChanged:Connect(function(oldState, newState)


	if newState == Enum.HumanoidStateType.Landed then
		canwallkick = true
		print('landed')
	end
end)--]]
