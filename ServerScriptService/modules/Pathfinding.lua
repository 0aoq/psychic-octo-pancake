-- humanoid pathfinding, server/client

local PathFinding = game:GetService("PathfindingService")
local Debris = game:GetService("Debris")

local module = {}

function module.Path(agent, ending, plot)
	local Humanoid = agent.Humanoid
	local RootPart = agent.HumanoidRootPart

	local Path = PathFinding:CreatePath()
	Path:ComputeAsync(RootPart.Position, ending.Position)
	local waypoints = Path:GetWaypoints()

	for i, waypoint in pairs(waypoints) do
		if plot then
			local position = Instance.new("Part", workspace)
			position.Shape = "Ball"
			position.Material = Enum.Material.Neon
			position.Size = Vector3.new(0.5, 0.5, 0.5)
			position.Position = waypoint.Position + Vector3.new(0, 1.5, 0)
			position.Anchored = true
			position.CanCollide = false
			
			Debris:AddItem(position, 1.5)
		end

		if waypoint.Action == Enum.PathWaypointAction.Jump then
			Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		end

		Humanoid:MoveTo(waypoint.Position)
		Humanoid.MoveToFinished:Wait(1)
	end
end

return module
