-- humanoid pathfinding, server/client

local PathFinding = game:GetService("PathfindingService")
local Debris = game:GetService("Debris")

local module = {}

function module.Path(agent, ending, plot)
	local Humanoid = agent.Humanoid
	local RootPart = agent.HumanoidRootPart

	local Path = PathFinding:CreatePath()
	Path:ComputeAsync(RootPart.Position, ending)
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
		
		if Path.Status ~= Enum.PathStatus.Success then
			Humanoid:Move(Vector3.new(math.random(-1, 1), 0, math.random(-1, 1)))
			Humanoid.Jump = true
			wait(0.5)
		end
		
		Humanoid.MoveToFinished:Wait()
	end
end

return module
