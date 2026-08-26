--[[
	HOW TO USE MODULELOADER (client side) -- reference only, never runs.

	This script is Disabled (see HowToUse.meta.json) and does nothing even if
	re-enabled: it's a sibling of Components/ and Modules/, and the loader
	only scans *inside* those two folders, so it's never picked up either
	way. Keep it as living documentation, or delete it once your team knows
	the pattern.

	=====================================================================
	Modules/ -- required once, automatically, when this ModuleLoader starts.
	=====================================================================

	No setup needed? Just do the work at the top level:

		-- Modules/HudSetup.luau
		print("Hud module loaded")
		return {}

	Need an explicit setup step? Return a table with Init, and it's called
	right after the module is required:

		-- Modules/Settings.luau
		local Settings = {}
		function Settings.Init()
			print("Settings ready")
		end
		return Settings

	=====================================================================
	Components/ -- matched to CollectionService tags by name.
	=====================================================================

	Name the file `<Tag>_Client` (server side: `<Tag>_Server`, in
	ServerScriptService.ModuleLoader.Components) and return a table with a
	Start function (required) and a Stop function (optional):

		-- Components/Glow_Client.luau
		local Glow = {}

		function Glow.Start(instance: Instance)
			-- Runs once per instance tagged "Glow", present now or added
			-- later. `instance` is the tagged instance itself.
		end

		function Glow.Stop(instance: Instance)
			-- Runs when an instance loses the "Glow" tag, or is destroyed.
		end

		return Glow

	Tag a Part "Glow" -- with the Tag Editor plugin, or
	CollectionService:AddTag(part, "Glow") in code -- and Glow.Start runs on
	it automatically, on every client that can see it. No manual wiring
	needed.

	See Components/NPC_Client.luau and Modules/Test.luau for working
	examples you can run right now.
]]
