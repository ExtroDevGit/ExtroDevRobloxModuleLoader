local CollectionService = game:GetService("CollectionService")

local NPCTagTest = {}

local TAG = "NPC"
local LIFETIME = 10

local function create(): Part
	local part = Instance.new("Part")
	part.Anchored = true
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BrickColor = BrickColor.new("Reddish brown")
	part.CFrame = CFrame.new(15, 7.57823944, -34, 1, 0, 0, 0, 1, 0, 0, 0, 1)
	part.Color = Color3.new(0.411764711, 0.250980407, 0.156862751)
	part.Material = Enum.Material.Neon
	part.Size = Vector3.new(60.6324043, 15.1581011, 30.3162022)
	part.Transparency = 0.5
	part.Name = TAG
	part.Parent = workspace
	return part
end

local function tag_npcs()
	for _, child in workspace:GetChildren() do
		if not child:IsA("BasePart") then
			continue
		end
		if child.Name ~= TAG then
			continue
		end
		CollectionService:AddTag(child, TAG)
	end
end

local function untag_npcs()
	for _, tagged in CollectionService:GetTagged(TAG) do
		CollectionService:RemoveTag(tagged, TAG)
	end
end

function NPCTagTest.Init()
	create()

	task.spawn(function()
		tag_npcs()

		for i = LIFETIME, 1, -1 do
			task.wait(1)
			print(string.format("npc tag removed in %ds", i))
		end

		untag_npcs()
	end)
end

return NPCTagTest
