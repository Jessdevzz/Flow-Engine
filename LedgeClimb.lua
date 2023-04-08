local plr = game.Players.LocalPlayer
local Character = plr.Character or plr.CharacterAdded:Wait()
local Root = Character:WaitForChild("HumanoidRootPart")
local Head = Character:WaitForChild("Head")
local Hum = Character:WaitForChild("Humanoid")
local CA = Hum:LoadAnimation(script:WaitForChild("ClimbAnim"))
local HA = Hum:LoadAnimation(script:WaitForChild("HoldAnim"))
local TouchGui = plr:WaitForChild("PlayerGui"):FindFirstChild("TouchGui")
local UIS = game:GetService("UserInputService")
local holdtime = time()
ledgeavailable = true
holding = false
local mm = require(game:GetService('ReplicatedStorage').Modules.MovementModule)
while _G.Globals == nil do
	wait()
end
local globals = _G.Globals
while globals.inaction == nil do
	wait()
end
local maxfallen = -40
local function RayToPart(ray)
	local MidPoint = ray.Origin + ray.Direction/2

	local Part = Instance.new("Part")
	Part.CanCollide = false
	Part.Transparency = 0.9
	Part.Anchored = true
	Part.CFrame = CFrame.lookAt(MidPoint, ray.Origin)
	Part.Size = Vector3.new(1, 1, ray.Direction.Magnitude)
	Part.Parent = workspace
	game.Debris:AddItem(Part,.03)
	return Part
end
local jumper = coroutine.wrap(function()
	while wait() do
		if holding == true then
			local r = Ray.new(Vector3.new(Head.Position.X, Head.Position.Y - 1.5, Head.Position.Z), Root.CFrame.LookVector*5)
			local part,position = workspace:FindPartOnRay(r,Character)
			if part == nil and holding == true and globals.action == 'ledgeclimbing' then
				print('closed')
				Root.Anchored = false holding = false HA:Stop() ledgeavailable = true globals.inaction = true
				globals.action = ''
				wait(0.2)
				globals.inaction = false
			end
		end
	end
		
	coroutine.yield()
end)
jumper()
--game:GetService("RunService").RenderStepped:Connect(function()
	--RayToPart(r)
UIS.InputBegan:Connect(function(key)
	if (key.KeyCode == Enum.KeyCode.Space or key.KeyCode == Enum.KeyCode.ButtonA) then
		local r = Ray.new(Vector3.new(Head.Position.X, Head.Position.Y - 1.5, Head.Position.Z), Root.CFrame.LookVector*5)
		local part,position = workspace:FindPartOnRay(r,Character)
	if part ~= nil and ledgeavailable and not holding and (key.KeyCode == Enum.KeyCode.Space or key.KeyCode == Enum.KeyCode.ButtonA) and globals.inaction == false then
			--print('passed checks, part: '..part.Name)
			if part.Size.Y >= 0.1 and (globals.falldistance > 1 or globals.falldistance < -1) then
				if mm.canclimb(Head, part) == false and Root.Velocity.Y <= 0 and globals.falldistance > maxfallen then
					print('holdin')
					Root.Anchored = true holding = true HA:Play(0.03) ledgeavailable = false holdtime = time() globals.inaction = true
					globals.action = 'ledgeclimbing'
				end
			end
		end
	end
end)
--end)
	function climb()
	local Vele = Instance.new("BodyVelocity",Root)
	Vele.Name = 'climbvel'
		Root.Anchored = false
		Vele.MaxForce = Vector3.new(1,1,1) * math.huge
		Vele.Velocity = Root.CFrame.LookVector * 10 + Vector3.new(0,30,0)
		HA:Stop() CA:Play()
	game.Debris:AddItem(Vele,.15)
	globals.action = ''
		holding = false
	globals.inaction = true
	wait(0.2)
	globals.inaction = false
		wait(.55)
	ledgeavailable = true
	end

	UIS.InputBegan:Connect(function(Key,Chat)
		if not holding then return end 
	if Key.KeyCode == Enum.KeyCode.Space or Key.KeyCode == Enum.KeyCode.ButtonA and math.abs(holdtime - time()) >= 0.05 then
		climb()
		print('clemb')
		end
end)
plr.CharacterAdded:Connect(function()
	local plr = game.Players.LocalPlayer
	local Character = plr.Character or plr.CharacterAdded:Wait()
	local Root = Character:WaitForChild("HumanoidRootPart")
	local Head = Character:WaitForChild("Head")
	local Hum = Character:WaitForChild("Humanoid")
	local CA = Hum:LoadAnimation(script:WaitForChild("ClimbAnim"))
	local HA = Hum:LoadAnimation(script:WaitForChild("HoldAnim"))
	local TouchGui = plr:WaitForChild("PlayerGui"):FindFirstChild("TouchGui")
	local UIS = game:GetService("UserInputService")
	local holdtime = time()
	ledgeavailable = true
	holding = false
	while _G.Globals == nil do
		wait()
	end
	local globals = _G.Globals
	while globals.inaction == nil do
		wait()
	end
end)
