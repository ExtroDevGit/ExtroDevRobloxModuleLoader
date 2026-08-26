--[[
	HOW TO USE MODULELOADER (server side) -- reference only, never runs.

	This script is Disabled (see HowToUse.meta.json) and does nothing even if
	re-enabled: it's a sibling of Components/ and Modules/, and the loader
	only scans *inside* those two folders, so it's never picked up either
	way. Keep it as living documentation, or delete it once your team knows
	the pattern.

	=====================================================================
	Modules/ -- required once, automatically, when this ModuleLoader starts.
	=====================================================================

	No setup needed? Just do the work at the top level:

		-- Modules/Analytics.luau
		print("Analytics module loaded")
		return {}

	Need an explicit setup step? Return a table with Init, and it's called
	right after the module is required:

		-- Modules/PlayerData.luau
		local PlayerData = {}
		function PlayerData.Init()
			print("PlayerData ready")
		end
		return PlayerData

	=====================================================================
	Components/ -- matched to CollectionService tags by name.
	=====================================================================

	Name the file `<Tag>_Server` (client side: `<Tag>_Client`, in
	StarterPlayerScripts.ModuleLoader.Components) and return a table with a
	Start function (required) and a Stop function (optional):

		-- Components/Door_Server.luau
		local Door = {}

		function Door.Start(instance: Instance)
			-- Runs once per instance tagged "Door", present now or added
			-- later. `instance` is the tagged instance itself.
			instance:SetAttribute("IsOpen", false)
		end

		function Door.Stop(instance: Instance)
			-- Runs when an instance loses the "Door" tag, or is destroyed.
		end

		return Door

	Tag a Part "Door" -- with the Tag Editor plugin, or
	CollectionService:AddTag(part, "Door") in code -- and Door.Start runs on
	it automatically. No manual wiring needed.

	See Components/NPC_Server.luau and Modules/Test.luau for working
	examples you can run right now.
]]
