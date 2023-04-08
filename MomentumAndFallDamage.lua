-- local script
-- momentum version: 0.1
local player = game.Players.LocalPlayer
local char = player.Character
local hum = char:WaitForChild('Humanoid')
local anim = script:WaitForChild('landanim')
local landanim = hum:LoadAnimation(anim)
local root = char:WaitForChild('HumanoidRootPart')
local islanded = false
rs = game:GetService('RunService')
local isFoverRunning = false
while _G.Globals == nil do
	wait()
end
local globals = _G.Globals
local falldist = globals.falldistance
local onground = true
local ongrndtime = -34525234
local rep = game:GetService('ReplicatedStorage')
local fde = rep.Events.FallDmg
mm = require(game.ReplicatedStorage.Modules.MovementModule)
local frametime = 0.016
-- fall distance stuffs
rs.Heartbeat:Connect(function()
	globals.falldistance = root.Position.Y - globals.fallstart
end)

local fover = coroutine.wrap(function()
	for i = 1,10,1 do
		workspace.CurrentCamera.FieldOfView = workspace.CurrentCamera.FieldOfView - 3
		wait()
	end
	isFoverRunning = false
	coroutine.yield()
end)

local function land()
	onground = true
	ongrndtime = time()
	if (globals.falldistance < -25 and globals.rolling == false) or globals.falldistance < -60 then
		print(globals.falldistance)
		fde:FireServer(-globals.falldistance * globals.falldistance/35)
		print(hum.Health)
		landanim:Play(0.05)
		islanded = true
		hum.WalkSpeed = 0
		hum.JumpHeight = 0
		wait(0.04)
		--root.Position = Vector3.new(root.Position.X, root.Position.Y + 0.3, root.Position.Z)
		root.Anchored = true
		if not isFoverRunning then
			isFoverRunning = true
			fover()
		end
		globals.inaction = true
		wait(1.1)
		islanded = false
		print('before')
		root.Anchored = false
		print('after')
		globals.inaction = false
		hum.WalkSpeed = 12
		hum.JumpHeight = 7.2
	end
	globals.fallstart = root.Position.Y
end

hum.StateChanged:Connect(function(oldState, newState)


	if newState == Enum.HumanoidStateType.Freefall then
		onground = false
		globals.fallstart = char:WaitForChild("HumanoidRootPart").Position.Y
		print('FS')


	elseif newState == Enum.HumanoidStateType.Landed then
		land()
	end
end)


-- momentum

local momentum = coroutine.create(function()
	while wait(0.01633) do
		local speed = hum.WalkSpeed
		if hum.MoveDirection == Vector3.new(0,0,0) then
			-- not walking
			if speed > 12 then
				mm.speed(frametime, -0.55)
			end
		else
			-- walking
			if speed < 24 then
				mm.speed(frametime, 0.4)
			end
			if onground == false and speed < 30 or time() - ongrndtime < 0.1 and onground == true and speed < 30 then
				mm.speed(frametime, -.02)
			end
			if (onground == true or onground == false) and speed > 24 and time() - ongrndtime > 0.1 and globals.inaction == false and root.Anchored == false then
				if onground == true then
					if speed < 30 then
						mm.speed(frametime, -.02)
					elseif speed > 30 and speed < 45 then
						mm.speed(frametime, -.08)
					elseif speed > 45 and speed < 55 then
						mm.speed(frametime, -.40)
					elseif speed > 55 then
						mm.speed(frametime, -2.6)
					end
				elseif onground == false  and speed > 24 then
					if speed < 30 then
						mm.speed(frametime, -.01)
					elseif speed > 30 and speed < 45 then
						mm.speed(frametime, -.04)
					elseif speed > 45 and speed < 55 then
						mm.speed(frametime, -.30)
					elseif speed > 55 then
						mm.speed(frametime, -2.4)
					end
				end
			end
			if speed < 24 and speed > 22.5 and root.Anchored == false and globals.inaction == false then
				hum.WalkSpeed = 24
			end
		end
		if root.Anchored == true and islanded == false then
			mm.speed(frametime, -.02)
		end
		if globals.action == 'wallrun' and speed > 30 then
			mm.speed(frametime, -.01)
		end
		if globals.action == 'climbing' then
			mm.speed(frametime, -.02)
		end
		
	end
end)
coroutine.resume(momentum)
-- fov stuff
rs.Heartbeat:Connect(function()
	local speed = script.Parent.Humanoid.WalkSpeed
	local fov = 70 + speed * 0.9
	if fov > 130 then
		fov = 130
	end
	if islanded == false then
		local cam = workspace.CurrentCamera
		cam.FieldOfView = fov

	end
end)
