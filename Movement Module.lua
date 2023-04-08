-- module
local module = {}
local ts = game:GetService('TweenService')

function module.speed(totaltime, speed)
	local cr = coroutine.wrap(function()
		local plr = game.Players.LocalPlayer
		local char = plr.Character
		local hum = char.Humanoid
		local waittime = totaltime
		local speedincrease = hum.WalkSpeed + speed
		local TweenInfo = TweenInfo.new(waittime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local toMax = ts:Create(hum, TweenInfo, {WalkSpeed = speedincrease})
		toMax:Play() 
		coroutine.yield()
		--return
	end)
	cr()
end
function module.canclimb(Head, hit)
	if Head.Position.Y +5 <= hit.Position.Y + (hit.Size.Y/2) then
		return true
	else
		return false
	end
end
return module
