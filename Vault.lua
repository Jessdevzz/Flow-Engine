
while _G.Globals == nil do
	wait()
end
globals = _G.Globals
local uis = game:GetService('UserInputService')
local plr = game:GetService("Players").LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local HRP = char:WaitForChild("HumanoidRootPart")
local Hum = char:WaitForChild("Humanoid")
local head = char:WaitForChild('Head')
a = Instance.new("Animation")
a.AnimationId = "rbxassetid://11504909309"
local leaway = 6
local downleaway = 3 -- how far below the wall can be from the player for it to still count
local CA = Hum:LoadAnimation(a)
local maxdist = 200
local dbug = plr.PlayerGui.debug.Main.vaultinfo.close
while _G.Globals == nil do
	wait()
end
globals = _G.Globals
local rs = game:GetService('ReplicatedStorage')
local mm = require(rs.Modules.MovementModule)
local function calculate(WallY, PlayY, SizeY, part)
	local pass = true
	if part == nil then return false end
	if WallY >= PlayY + downleaway then -- if the wall is below the player
		pass = false
		
		dbug.Text = 'wall is below plr'
	end

	if (SizeY > PlayY + leaway) == true then -- if the wall is bigger than 4 times the player's height
		pass = false
		
		dbug.Text = ('wall is too big' .. SizeY .. ' '.. (PlayY + leaway))
	end

	if  part:IsA('Model') == false and SizeY < 3 then -- if the wall is smaller than 1/4 of the player's height
		pass = false
		
		dbug.Text = 'wall is too small'
	end
	if part:IsA('Model') == false and part.Size.Z < 1 or part.Size.X < 1 then
		pass = false
		
		dbug.Text = 'wall is too small ZX'
	end

	return pass
end


local ledgeavail = true
game:GetService('RunService').Heartbeat:Connect(function()
		local r = Ray.new(HRP.Position ,HRP.CFrame.LookVector*7.5) --+ HRP.CFrame.UpVector * -5
		local hit, position, normal, part = workspace:FindPartOnRayWithIgnoreList(r, char:GetChildren()) -- hit is the part the ray hits
		local r2 = Ray.new(HRP.Position ,HRP.CFrame.LookVector*2) --+ HRP.CFrame.UpVector * -5
		local hit2, position2, normal2, part2 = workspace:FindPartOnRayWithIgnoreList(r2, char:GetChildren()) -- hit2 is the part the ray hits
		if hit ~= nil and hit2 == nil then
			if calculate(hit.Position.Y, char["Left Leg"].Position.Y, hit.Size.Y, hit) == true  then
				Hum.JumpHeight = 0
			else
				Hum.JumpHeight = 7.2
			end
		elseif hit == nil then
			Hum.JumpHeight = 7.2
		elseif hit2 ~= nil then
			Hum.JumpHeight = 7.2
		end

end)
--jumper()



uis.InputBegan:Connect(function(input)
	if (input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.ButtonA) and Hum.JumpHeight == 0 then
		globals = _G.Globals
		r = Ray.new(HRP.Position, HRP.CFrame.LookVector * 7.5) --+ HRP.CFrame.UpVector * -5
		part = workspace:FindPartOnRay(r,char)
		r2 = Ray.new(HRP.Position ,HRP.CFrame.LookVector*2) --+ HRP.CFrame.UpVector * -5
		hit2, position2, normal2, part2 = workspace:FindPartOnRayWithIgnoreList(r2, char:GetChildren()) -- hit2 is the part the ray hits
		if part and ledgeavail and hit2 == nil then
			if globals.inaction == false then -- custom attribute (boolean) MAKE SURE TO ADD THIS TO ALL PARTS YOU WANT TO BE VAULTABLE
				
				if Hum.FloorMaterial ~= Enum.Material.Air and calculate(part.Position.Y, char["Left Leg"].Position.Y, part.Size.Y, part) then
					vaultavail = false
					globals.inaction = true
					local Vel = Instance.new("BodyVelocity")
					Vel.Parent = HRP
					Vel.Velocity = Vector3.new(0,0,0)
					Vel.MaxForce = Vector3.new(1,1,1) * math.huge
					Vel.Velocity = HRP.CFrame.LookVector * 15 * Hum.WalkSpeed/15 + Vector3.new(0,22 * Hum.WalkSpeed/15,0)
					CA:Play()
					game.Debris:AddItem(Vel, .15)
					mm.speed(.15, 8)
					globals.inaction = false
					wait(0.60)
					vaultavail = true
				end
			end
		end
	end
end)
plr.CharacterAdded:Connect(function()
	while _G.Globals == nil do
		wait()
	end
	globals = _G.Globals
	globals = _G.Globals
	globals = _G.Globals
	
end)
