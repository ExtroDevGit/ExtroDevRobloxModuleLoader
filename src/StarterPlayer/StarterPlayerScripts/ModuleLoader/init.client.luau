local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Loader = require(ReplicatedStorage.ModuleLoader.Loader)

Loader.loadModules(script.Modules)
Loader.loadComponents(script.Components, "_Client")
