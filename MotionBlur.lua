--[[
By AstroCode on August 17, 2016

This motion blur script is activated by the rotation of the camera.
Place this script in StarterPlayer > StarterPlayerScripts
By default, players must have their graphics quality set to 6+ to see the blur effect.
--]]

--//Settings
BlurAmount = 35 -- Change this to increase or decrease the blur size

--//Declarations
Camera 	= game.Workspace.CurrentCamera
Last 	= Camera.CFrame.lookVector
Blur 	= Instance.new("BlurEffect",Camera)

--//Logic
game.Workspace.Changed:connect(function(p) -- Feels a bit hacky. Updates the Camera and Blur if the Camera object is changed.
	if p == "CurrentCamera" then
		Camera = game.Workspace.CurrentCamera
		if Blur and Blur.Parent then
			Blur.Parent = Camera
		else
			Blur = Instance.new("BlurEffect",Camera)
		end
	end
end)

game:GetService("RunService").Heartbeat:connect(function()
	if not Blur or Blur.Parent == nil then Blur = Instance.new("BlurEffect",Camera) end -- Feels a bit hacky. Creates a new Blur if it is destroyed.
	
	local magnitude = (Camera.CFrame.lookVector - Last).magnitude -- How much the camera has rotated since the last frame
	Blur.Size = math.abs(magnitude)*BlurAmount -- Set the blur size
	Last = Camera.CFrame.lookVector -- Update the previous camera rotation
end)
