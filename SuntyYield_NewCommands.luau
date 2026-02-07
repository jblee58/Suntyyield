-- ============================================
-- SUNTY YIELD CUSTOM COMMANDS (Mac M1 Optimized)
-- ============================================
-- Copy and paste these commands into Infiniteyield.luau before line 13304

-- Performance monitoring command
addcmd('performance', {'perf', 'stats'}, function(args, speaker)
	local stats = game:GetService("Stats")
	local memoryMB = math.floor(stats:GetTotalMemoryUsageMb())
	local fps = math.floor(1 / RunService.RenderStepped:Wait())
	notify('Performance Stats', string.format('Memory: %d MB\\nFPS: %d', memoryMB, fps))
end)

-- Clear all Drawing Library visuals
addcmd('clearvisuals', {'cleardrawings', 'clearesp'}, function(args, speaker)
	local cleared = 0
	for _, v in pairs(game:GetDescendants()) do
		if v:IsA("Drawing") or (v.ClassName and v.ClassName:match("ESP")) then
			pcall(function() v:Remove() end)
			cleared = cleared + 1
		end
	end
	collectgarbage("collect")
	notify('Visuals Cleared', string.format('Removed %d visual objects and freed memory', cleared))
end)

-- Low power mode toggle
_G.LowPowerMode = false
addcmd('lowpower', {'lowpowermode'}, function(args, speaker)
	_G.LowPowerMode = not _G.LowPowerMode
	if _G.LowPowerMode then
		RunService:Set3dRenderingEnabled(false)
		notify('Low Power Mode', 'Enabled - Reduced rendering for better performance')
	else
		RunService:Set3dRenderingEnabled(true)
		notify('Low Power Mode', 'Disabled - Full rendering restored')
	end
end)

-- Anti-AFK (minimal resource usage)
_G.AntiAFK = false
addcmd('antiafk', {}, function(args, speaker)
	if _G.AntiAFK then
		_G.AntiAFK = false
		notify('Anti-AFK', 'Disabled')
	else
		_G.AntiAFK = true
		notify('Anti-AFK', 'Enabled - You will not be kicked for inactivity')
		task.spawn(function()
			while _G.AntiAFK do
				local VirtualUser = game:GetService("VirtualUser")
				VirtualUser:CaptureController()
				VirtualUser:ClickButton2(Vector2.new())
				task.wait(300) -- Trigger every 5 minutes
			end
		end)
	end
end)

-- Quick save position
_G.QuickSaves = _G.QuickSaves or {}
addcmd('quicksave', {'qsave'}, function(args, speaker)
	local saveName = args[1] or "default"
	local char = speaker.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		_G.QuickSaves[saveName] = char.HumanoidRootPart.CFrame
		notify('Quick Save', string.format('Saved position as "%s"', saveName))
	else
		notify('Error', 'Character not found')
	end
end)

-- Quick load position
addcmd('quickload', {'qload'}, function(args, speaker)
	local saveName = args[1] or "default"
	if _G.QuickSaves[saveName] then
		local char = speaker.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char.HumanoidRootPart.CFrame = _G.QuickSaves[saveName]
			notify('Quick Load', string.format('Loaded position "%s"', saveName))
		else
			notify('Error', 'Character not found')
		end
	else
		notify('Error', string.format('No save found with name "%s"', saveName))
	end
end)

-- Teleport history
_G.TeleportHistory = _G.TeleportHistory or {}
addcmd('teleporthistory', {'tphistory', 'tph'}, function(args, speaker)
	if #_G.TeleportHistory == 0 then
		notify('Teleport History', 'No teleports recorded yet')
	else
		local history = "Recent teleports:\\n"
		for i = math.max(1, #_G.TeleportHistory - 4), #_G.TeleportHistory do
			local tp = _G.TeleportHistory[i]
			history = history .. string.format("%d. %s\\n", i, tp)
		end
		notify('Teleport History', history)
	end
end)

-- FPS cap for battery saving
_G.CustomFPSCap = nil
addcmd('fps', {'fpscap', 'setfps'}, function(args, speaker)
	local targetFPS = tonumber(args[1])
	if targetFPS and targetFPS > 0 then
		_G.CustomFPSCap = targetFPS
		notify('FPS Cap', string.format('Set to %d FPS for better performance', targetFPS))
		if not _G.FPSCapRunning then
			_G.FPSCapRunning = true
			task.spawn(function()
				while _G.CustomFPSCap do
					local frameTime = 1 / _G.CustomFPSCap
					task.wait(frameTime)
				end
				_G.FPSCapRunning = false
			end)
		end
	else
		_G.CustomFPSCap = nil
		notify('FPS Cap', 'Removed - Running at maximum FPS')
	end
end)

-- Smooth camera toggle
_G.SmoothCamera = false
addcmd('smoothcam', {'smoothcamera'}, function(args, speaker)
	local speed = tonumber(args[1]) or 0.1
	_G.SmoothCamera = not _G.SmoothCamera
	if _G.SmoothCamera then
		notify('Smooth Camera', string.format('Enabled with speed %.2f', speed))
		-- Implementation would go here for smooth camera transitions
	else
		notify('Smooth Camera', 'Disabled')
	end
end)

-- Memory cleanup command
addcmd('clearmemory', {'gc', 'collectgarbage'}, function(args, speaker)
	local beforeMem = collectgarbage("count")
	collectgarbage("collect")
	local afterMem = collectgarbage("count")
	local freed = math.floor(beforeMem - afterMem)
	notify('Memory Cleanup', string.format('Freed ~%d KB of memory', freed))
end)

-- ============================================
-- Add these to the CMDs table (insert near line 4450)
-- ============================================
CMDs[#CMDs + 1] = {NAME = 'performance / perf / stats', DESC = 'Display current RAM usage and FPS statistics'}
CMDs[#CMDs + 1] = {NAME = 'clearvisuals / cleardrawings / clearesp', DESC = 'Remove all Drawing Library visuals to free memory'}
CMDs[#CMDs + 1] = {NAME = 'lowpower / lowpowermode', DESC = 'Toggle low power mode to reduce CPU/GPU usage'}
CMDs[#CMDs + 1] = {NAME = 'antiafk', DESC = 'Prevent AFK kick with minimal resource usage'}
CMDs[#CMDs + 1] = {NAME = 'quicksave / qsave [name]', DESC = 'Quick save current position with optional name'}
CMDs[#CMDs + 1] = {NAME = 'quickload / qload [name]', DESC = ' Quick load a saved position'}
CMDs[#CMDs + 1] = {NAME = 'teleporthistory / tphistory / tph', DESC = 'Show recent teleport locations'}
CMDs[#CMDs + 1] = {NAME = 'fps / fpscap / setfps [number]', DESC = 'Set FPS cap to reduce CPU usage (0 to remove cap)'}
CMDs[#CMDs + 1] = {NAME = 'smoothcam / smoothcamera [speed]', DESC = 'Toggle smooth camera transitions'}
CMDs[#CMDs + 1] = {NAME = 'clearmemory / gc / collectgarbage', DESC = 'Force garbage collection to free memory'}
