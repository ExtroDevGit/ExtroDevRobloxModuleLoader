--[[
	Runs automatically on every instance tagged "NPC" (via CollectionService),
	present now or added later. See ReplicatedStorage.ModuleLoader.Loader.
]]

local Component = {}

function Component.Start(instance: Instance)
	print("NPC server component started for", instance:GetFullName())
end

function Component.Stop(instance: Instance)
	print("NPC server component stopped for", instance:GetFullName())
	instance:Destroy()
end

return Component
