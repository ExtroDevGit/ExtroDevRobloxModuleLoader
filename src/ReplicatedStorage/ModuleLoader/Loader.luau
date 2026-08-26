--[[
	Shared by ServerScriptService.ModuleLoader and
	StarterPlayerScripts.ModuleLoader -- see their init scripts and the
	project README for how this gets used.
]]

local CollectionService = game:GetService("CollectionService")

local Loader = {}

--[[
	Requires every ModuleScript directly inside `folder`. A module that just
	wants to run once at startup can do all of its work at the top level of
	the script -- requiring it is enough. A module that returns a table with
	an `Init` function gets that function called right after being required,
	for modules that need to set something up before other code can use them.
]]
function Loader.loadModules(folder: Instance)
	for _, child in folder:GetChildren() do
		if not child:IsA("ModuleScript") then
			continue
		end

		local ok, result = pcall(require, child)
		if not ok then
			warn(("ModuleLoader: %s failed to load: %s"):format(child:GetFullName(), tostring(result)))
			continue
		end

		if type(result) == "table" and type(result.Init) == "function" then
			local initOk, err = pcall(result.Init)
			if not initOk then
				warn(("ModuleLoader: %s.Init() failed: %s"):format(child:GetFullName(), tostring(err)))
			end
		end
	end
end

--[[
	Requires every ModuleScript directly inside `folder`. Each one is
	expected to be named `<Tag><suffix>` (e.g. `NPC_Server`, with
	suffix = "_Server") and return a table with a `Start` function, and
	optionally a `Stop` function.

	`Start(instance)` is called for every instance already tagged `<Tag>`
	via CollectionService, and again for every instance tagged `<Tag>`
	afterwards. `Stop(instance)`, if present, is called when an instance
	loses the `<Tag>` tag (including being destroyed).
]]
function Loader.loadComponents(folder: Instance, suffix: string)
	for _, child in folder:GetChildren() do
		if not child:IsA("ModuleScript") then
			continue
		end

		local tag = child.Name
		if tag:sub(-#suffix) == suffix then
			tag = tag:sub(1, -#suffix - 1)
		else
			warn(("ModuleLoader: %s's name doesn't end in '%s'; using '%s' as its tag"):format(
				child:GetFullName(),
				suffix,
				tag
			))
		end

		local ok, Component = pcall(require, child)
		if not ok then
			warn(("ModuleLoader: %s failed to load: %s"):format(child:GetFullName(), tostring(Component)))
			continue
		end

		if type(Component) ~= "table" or type(Component.Start) ~= "function" then
			warn(("ModuleLoader: %s must return a table with a Start function"):format(child:GetFullName()))
			continue
		end

		local function start(instance: Instance)
			local startOk, err = pcall(Component.Start, instance)
			if not startOk then
				warn(("ModuleLoader: %s.Start() failed for %s: %s"):format(child.Name, instance:GetFullName(), tostring(err)))
			end
		end

		local function stop(instance: Instance)
			if type(Component.Stop) == "function" then
				pcall(Component.Stop, instance)
			end
		end

		for _, instance in CollectionService:GetTagged(tag) do
			start(instance)
		end
		CollectionService:GetInstanceAddedSignal(tag):Connect(start)
		CollectionService:GetInstanceRemovedSignal(tag):Connect(stop)
	end
end

return Loader
