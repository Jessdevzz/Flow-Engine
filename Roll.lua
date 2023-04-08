local anim = script:WaitForChild('Animation')
local player = game.Players.LocalPlayer
local char = player.Character
local hum = char:WaitForChild('Humanoid')
local root = char.HumanoidRootPart
local rollingAnimation = hum:LoadAnimation(anim)
local head = char.Head
while _G.Globals == nil do
	wait()
end
local globals = _G.Globals
local falldist = globals.falldistance
-- services --
local uis = game:GetService('UserInputService')
-- keybinds --
local key = Enum.KeyCode.LeftShift
-- vars --
local isrolling = script:WaitForChild('Rolling') -- bool
local cooldown = false
local canroll = false
local startpos = 0
local minfd = -5 -- min distance fallen to be able to roll
local cam = workspace.CurrentCamera

-- code --

local function RayToPart(ray)
	local midPoint = ray.Origin + ray.Direction/2
	local part = Instance.new("Part")
	part.CanCollide = false
	part.Transparency = 0
	part.Anchored = true
	part.CFrame = CFrame.new(midPoint, ray.Origin)
	part.Size = Vector3.new(1, 1, ray.Direction.Magnitude)
	part.Parent = workspace
	game.Debris:AddItem(part, 0.03)
	return part
end

local function roll()
	if hum.FloorMaterial == Enum.Material.Air and cooldown == false and globals.inaction == false and canroll == true then
		print(globals.falldistance)
		if globals.falldistance < minfd then
				globals.rolling = true
				cooldown = true
			rollingAnimation:Play()
			
			wait(0.5)
			globals.rolling = false
			globals.inaction = true
			wait(.5)
			globals.inaction = false
			cooldown = false
		end
	end
end
uis.InputBegan:Connect(function(k)
	if (k.KeyCode == key or k.KeyCode == Enum.KeyCode.ButtonR2) and cooldown == false then
		roll()
	end
end)

game:GetService('RunService').Heartbeat:Connect(function()
	local r = Ray.new(root.CFrame.p, Vector3.new(0,-5, 0))
	local hit, pos = workspace:FindPartOnRay(r, char)
	--RayToPart(r)
	if hit then
		canroll = true
	elseif hit == false then
		canroll = false
	end
end)
player.CharacterAdded:Connect(function()
	local anim = script:WaitForChild('Animation')
	local player = game.Players.LocalPlayer
	local char = player.Character
	local hum = char:WaitForChild('Humanoid')
	local root = char.HumanoidRootPart
	local rollingAnimation = hum:LoadAnimation(anim)
	local head = char.Head
	while _G.Globals == nil do
		wait()
	end
	local globals = _G.Globals
	local falldist = globals.falldistance
	-- services --
	local uis = game:GetService('UserInputService')
	-- keybinds --
	local key = Enum.KeyCode.LeftShift
	-- vars --
	local isrolling = script:WaitForChild('Rolling') -- bool
	local cooldown = false
	--local falldistance = 0
	local startpos = 0
	local minfd = -5 -- min distance fallen to be able to roll
	local cam = workspace.CurrentCamera
end)
