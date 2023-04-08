local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
local Hum = char.Humanoid
local hrp = char:WaitForChild('HumanoidRootPart')
local rightarm = char["Right Arm"]
local leftarm = char["Left Arm"]
local uis = game:GetService("UserInputService")
local rightani = Instance.new("Animation")
rightani.AnimationId = "rbxassetid://12241860731"
local leftani = Instance.new("Animation")
leftani.AnimationId = "rbxassetid://12241856776" -- 12253128617
local righttrack = char.Humanoid:LoadAnimation(rightani)
local lefttrack = char.Humanoid:LoadAnimation(leftani)
local rightcooldown = 0 -- can wallrun
local leftcooldown = 0 
local wras = 'None' -- wallrun arm start
local ui = game.Players.LocalPlayer.PlayerGui
local debugui = ui.debug
local status = debugui.Main.wrinfo.close
local rightbv = Instance.new('BodyVelocity', Hum)
rightbv.MaxForce = Vector3.new(1,1,1) * math.huge
rightbv.Velocity = Vector3.new(0,0,0)
local boost = Instance.new('BodyVelocity', Hum)
boost.MaxForce = Vector3.new(1,1,1) * math.huge
boost.Velocity = Vector3.new(0,0,0)
local leftactive, rightactive = false, false -- to check if the player can wallrun when space is pressed'
local iswr = false
local canright = true
local canleft = true
local rightpo = Instance.new("Animation")
rightpo.AnimationId = "rbxassetid://12253128617" -- 12253138507
local rightpush = char.Humanoid:LoadAnimation(rightpo)
local leftpo = Instance.new("Animation")
leftpo.AnimationId = "rbxassetid://12253138507" -- 12253138507
local leftpush = char.Humanoid:LoadAnimation(leftpo)
local boostup = false
local begincf
local TweenService = game:GetService("TweenService")
local cam = workspace.CurrentCamera
local globals = _G.Globals
while _G.Globals == nil do
	wait()
end
local globals = _G.Globals
local rs = game:GetService('ReplicatedStorage')
local mm = require(rs.Modules.MovementModule)
local maxfallen = -40
print(mm)
local function debugger()
	if Hum.FloorMaterial ~= Enum.Material.Air then
		status.Text = 'WR end message: floormaterial is not air'
	elseif rightactive == false and leftactive == false and iswr == true then
		status.Text = 'WR end message: both arms are not touching a wallrun wall'
	elseif iswr == false and boost == false then
		status.Text = 'WR end message: wallrun likely ended by time or some rare cause'

	end
end

local function canwr(part)
	if part.Size.Y > 3 and (part.Size.X > 10 or part.Size.Z > 10) then
		return true
	end
	return false
end


local function PanCamera(units : number)
	return nil
	--local Camera = workspace.CurrentCamera
	--local Pos = Camera.CFrame.Position 
	--local CF = CFrame.new(Pos)
	--local Dir = (CFrame.lookAt(Vector3.new(0,Pos.Y,0),Vector3.new(0,Pos.Y,0) + CF.LookVector + CF.RightVector))
	--local X,Y,Z = Dir:ToOrientation()

	--Camera.CFrame *= CFrame.Angles(0,units * Y,0)
end

local function IsFirstPerson()
	if char.Head.LocalTransparencyModifier > 0.6 then
		return true
	else
		return false
	end
end


local function RayToPart(ray)
	local midPoint = ray.Origin + ray.Direction/2
	local part = Instance.new("Part")
	part.CanCollide = false
	part.Transparency = 0.5
	part.Anchored = true
	part.CFrame = CFrame.new(midPoint, ray.Origin)
	part.Size = Vector3.new(1, 1, ray.Direction.Magnitude)
	part.Parent = workspace
	game.Debris:AddItem(part, 0.03)
	return part
end


local ground = coroutine.wrap(function()
	while wait() do
		if Hum.FloorMaterial ~= Enum.Material.Air and (rightactive == true or leftactive == true) and iswr == true then
			rightactive = false
			leftactive = false
			status.Text = 'wallrun ground'
		elseif Hum.FloorMaterial == Enum.Material.Air and (rightactive == true or leftactive == true) and iswr == true then
			status.Text = 'wallrun air'
		end
	end
end)
ground()

local function close()
	print(wras)
	globals.action = ''
	if wras == 'right' then
		debugger()
		if boostup == false then
			rightbv.Parent = Hum
		end
		iswr = false
		rightcooldown = time()
		wras = 'None'
		lefttrack:Stop()
		righttrack:Stop()
		_G.Globals.fallstart = hrp.Position.Y
		canright = false
		globals.inaction = false
		rightactive = false
	elseif wras == 'left' then
		debugger()
		if boostup == false then
			rightbv.Parent = Hum
		end
		iswr = false
		leftactive = false
		leftcooldown = time()
		wras = 'None'
		lefttrack:Stop()
		righttrack:Stop()
		_G.Globals.fallstartt = hrp.Position.Y
		globals.inaction = false
		canleft = false
	end

end
local torso = char.Torso

game:GetService("RunService").RenderStepped:Connect(function()
	debugui.Main.wrinfo.iswr.Text = tostring(iswr)

	local rightDirection = (rightarm.Position - torso.Position).unit -- ray direction
	if iswr == true and IsFirstPerson() == true then
		rightRay = Ray.new(torso.Position, rightDirection * 6) -- shoot a ray out of right arm
	else
		rightRay = Ray.new(torso.Position, rightDirection * 6) -- shoot a ray out of right arm
	end


	local leftDirection = (leftarm.Position - torso.Position).unit
	if IsFirstPerson() and iswr then
		leftRay = Ray.new(torso.Position, leftDirection * 6) -- same thing but left
	else
		leftRay = Ray.new(torso.Position, leftDirection * 6) -- same thing but left
	end

	local rightHit = workspace:FindPartOnRayWithIgnoreList(rightRay, char:GetChildren()) -- find what part the ray hit (ignoring the character)
	local leftHit = workspace:FindPartOnRayWithIgnoreList(leftRay, char:GetChildren())

	if rightHit ~= nil then -- if the ray doesnt hit a part
		if canwr(rightHit) == true and rightactive == false and iswr == false then -- make sure the part is valid to wallrun
			rightactive = true

		end
	elseif rightHit == nil and rightactive == true and iswr == true then -- if the conditions become false
		rightactive = false
		close() -- reset wallrun and stop it
		print('halt')
	end

	if leftHit ~= nil then -- if the ray doesnt hit a part
		if canwr(leftHit) == true and leftactive == false and iswr == false then-- make sure the part is valid to wallrun
			leftactive = true
		end
	elseif leftHit == nil and leftactive == true and iswr == true then -- if the conditions become false
		leftactive = false
		close() -- reset wallrun and stop it
		print('halt')
	end
	if not leftHit then -- if the part becomes nil during wallrun
		leftactive = false
	end
	if not rightHit then
		rightactive = false
	end
	debugui.Main.wrinfo.a1.Text = 'left active: ' .. tostring(leftactive) .. ' can left: '.. tostring(canleft) -- debug
	debugui.Main.wrinfo.a2.Text = 'right active: '..tostring(rightactive) .. ' can right: '.. tostring(canright)
end)


--reset sides
Hum.StateChanged:Connect(function(oldState, newState)
	if newState == Enum.HumanoidStateType.Landed then
		canright = true canleft = true
		rightcooldown = 0
		leftcooldown = 0
		rightactive = false
		leftactive = false
		iswr = false
	end
end)
local function beginwr()
	if wras == 'right' then
		righttrack:Play()
	elseif wras == 'left' then
		lefttrack:Play()
	end
	if (wras == 'right' and math.abs(rightcooldown - time()) >= 1.2 and globals.falldistance > maxfallen and canright == true and globals.inaction == false) or (wras == 'left' and math.abs(leftcooldown - time()) >= 1.2 and globals.falldistance > maxfallen and canleft == true and globals.inaction == false) then
		iswr = true
		globals.action = 'wallrun'
		print('true')
		rightbv.Parent = hrp
		globals.inaction = true
		if not uis:IsKeyDown(Enum.KeyCode.A) and not uis:IsKeyDown(Enum.KeyCode.D) then
			rightbv.Velocity = Hum.MoveDirection * (Hum.WalkSpeed * 1.7)
		else
			rightbv.Velocity = hrp.CFrame.LookVector * (Hum.WalkSpeed * 1.7)
		end
		rightbv.Velocity = Vector3.new(rightbv.Velocity.X, -2, rightbv.Velocity.Z)
		for i = 1,10,1 do
			if Hum.FloorMaterial ~= Enum.Material.Air or (leftactive == false and rightactive == false) or iswr == false then
				if iswr == true then
					close()

					break
				end
				close()

				break
			end
			rightbv.Velocity = rightbv.Velocity * 0.95
			rightbv.Velocity = Vector3.new(rightbv.Velocity.X, -2 * 6 + -i * i/10, rightbv.Velocity.Z)
			wait(0.08)
		end
		close()

	end
	close()
end

uis.InputBegan:Connect(function(input)
	if (input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.ButtonA) and iswr == false then
		if Hum.FloorMaterial == Enum.Material.Air then
			print('air')
			if (rightactive or leftactive) then
				if rightactive then
					wras = 'right'
				else
					wras = 'left'
				end
				beginwr()

			end
		end
	end
end)


uis.InputBegan:Connect(function(input)
	-- end wr with space
	if (input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.ButtonA) and iswr == true then
		boostup = true
		iswr = false
		globals.inaction = false
		lefttrack:Stop()
		righttrack:Stop()
		if wras == 'right' then
			rightcooldown = time()
			--rightpush:Play()
			canright = false
		elseif wras == 'left' then
			leftcooldown = time()
			canleft = false
			--leftpush:Play()
		end
		--wras = 'None'
		rightbv.Parent = hrp
		rightbv.Velocity = Vector3.new(Hum.MoveDirection.X * (Hum.WalkSpeed * 1.4),60 * Hum.WalkSpeed/30,Hum.MoveDirection.Z * (Hum.WalkSpeed * 1.4))
		_G.Globals.fallstart = hrp.Position.Y
		mm.speed(0.15, 10)
		wait(0.08)
		status.Text = 'WR end message: spacebar pressed'
		print(rightbv.Parent)
		boostup = false
		rightbv.Parent = Hum
		rightbv.Velocity = Vector3.new(0,0,0)

	end
end)
Hum.Died:Connect(function()
	char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
	Hum = char.Humanoid
	hrp = char:WaitForChild('HumanoidRootPart')
	rightarm = char["Right Arm"]
	leftarm = char["Left Arm"]
	uis = game:GetService("UserInputService")
	rightani = Instance.new("Animation")
	rightani.AnimationId = "rbxassetid://12241860731"
	leftani = Instance.new("Animation")
	leftani.AnimationId = "rbxassetid://12241856776" -- 12253128617
	righttrack = char.Humanoid:LoadAnimation(rightani)
	lefttrack = char.Humanoid:LoadAnimation(leftani)
	rightcooldown = 0 -- can wallrun
	leftcooldown = 0 
	wras = 'None' -- wallrun arm start
	ui = game.Players.LocalPlayer.PlayerGui
	debugui = ui.debug
	status = debugui.Main.wrinfo.close
	rightbv = Instance.new('BodyVelocity', Hum)
	rightbv.MaxForce = Vector3.new(1,1,1) * math.huge
	rightbv.Velocity = Vector3.new(0,0,0)
	boost = Instance.new('BodyVelocity', Hum)
	boost.MaxForce = Vector3.new(1,1,1) * math.huge
	boost.Velocity = Vector3.new(0,0,0)
	leftactive, rightactive = false, false -- to check if the player can wallrun when space is pressed'
	iswr = false
	canright = true
	canleft = true
	rightpo = Instance.new("Animation")
	rightpo.AnimationId = "rbxassetid://12253128617" -- 12253138507
	rightpush = char.Humanoid:LoadAnimation(rightpo)
	leftpo = Instance.new("Animation")
	leftpo.AnimationId = "rbxassetid://12253138507" -- 12253138507
	leftpush = char.Humanoid:LoadAnimation(leftpo)
	boostup = false
	cam.CameraSubject = Hum
	cam.CameraType = Enum.CameraType.Custom
end)
game.Players.LocalPlayer.CharacterAdded:Connect(function()
	char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
	Hum = char.Humanoid
	hrp = char:WaitForChild('HumanoidRootPart')
	rightarm = char["Right Arm"]
	leftarm = char["Left Arm"]
	uis = game:GetService("UserInputService")
	rightani = Instance.new("Animation")
	rightani.AnimationId = "rbxassetid://12241860731"
	leftani = Instance.new("Animation")
	leftani.AnimationId = "rbxassetid://12241856776" -- 12253128617
	righttrack = char.Humanoid:LoadAnimation(rightani)
	lefttrack = char.Humanoid:LoadAnimation(leftani)
	rightcooldown = 0 -- can wallrun
	leftcooldown = 0 
	wras = 'None' -- wallrun arm start
	ui = game.Players.LocalPlayer.PlayerGui
	debugui = ui.debug
	status = debugui.Main.wrinfo.close
	rightbv = Instance.new('BodyVelocity', Hum)
	rightbv.MaxForce = Vector3.new(1,1,1) * math.huge
	rightbv.Velocity = Vector3.new(0,0,0)
	boost = Instance.new('BodyVelocity', Hum)
	boost.MaxForce = Vector3.new(1,1,1) * math.huge
	boost.Velocity = Vector3.new(0,0,0)
	leftactive, rightactive = false, false -- to check if the player can wallrun when space is pressed'
	iswr = false
	canright = true
	canleft = true
	rightpo = Instance.new("Animation")
	rightpo.AnimationId = "rbxassetid://12253128617" -- 12253138507
	rightpush = char.Humanoid:LoadAnimation(rightpo)
	leftpo = Instance.new("Animation")
	leftpo.AnimationId = "rbxassetid://12253138507" -- 12253138507
	leftpush = char.Humanoid:LoadAnimation(leftpo)
	boostup = false
	local globals = _G.Globals
	while _G.Globals == nil do
		wait()
	end
	local globals = _G.Globals
end)
