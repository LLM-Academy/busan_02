-- ServerScriptService.CityLife: bounded, yielding promenade behavior.
local PhysicsService=game:GetService("PhysicsService")
local RunService=game:GetService("RunService")
local city=workspace:WaitForChild("CityLife",30)
if not city then return end
pcall(function() PhysicsService:RegisterCollisionGroup("PromenadeNPC") end)
PhysicsService:CollisionGroupSetCollidable("PromenadeNPC","PromenadeNPC",false)
PhysicsService:CollisionGroupSetCollidable("PromenadeNPC","Default",true)
-- IDs read from the actual player Animate script in this place, 2026-11-16.
local clips={Walk="rbxassetid://913402848",Run="rbxassetid://913376220",Idle="rbxassetid://507766388"}
local function promenade(x) return 120-110*(x/600)^2 end
local function animate(hum, key)
	local animator=hum:FindFirstChildOfClass("Animator") or Instance.new("Animator",hum)
	local a=Instance.new("Animation"); a.AnimationId=clips[key]
	local ok,track=pcall(function() return animator:LoadAnimation(a) end); a:Destroy()
	if ok then track.Looped=true; track.Priority=Enum.AnimationPriority.Movement; return track end
end
local function start(npc)
	local hum=npc:FindFirstChildOfClass("Humanoid"); local root=npc:FindFirstChild("HumanoidRootPart")
	if not hum or not root then return end
	for _,v in npc:GetDescendants() do if v:IsA("BasePart") then
		v.CollisionGroup="PromenadeNPC"; v.CanTouch=false; v.CanCollide=false
		if not v.Anchored then pcall(function() v:SetNetworkOwner(nil) end) end
	end end
	-- Root must collide with the ground, while colliding with players is disabled via
	-- NoCollisionConstraint, so the group continues to collide with world pavement.
	root.CanCollide=true
	local function avoidCharacter(character)
		local function avoidPart(v)
			if v:IsA("BasePart") and npc.Parent then
				local c=Instance.new("NoCollisionConstraint"); c.Part0=root; c.Part1=v; c.Parent=root
			end
		end
		for _,v in character:GetDescendants() do avoidPart(v) end
		character.DescendantAdded:Connect(avoidPart)
	end
	local Players=game:GetService("Players")
	for _,p in Players:GetPlayers() do if p.Character then avoidCharacter(p.Character) end; p.CharacterAdded:Connect(avoidCharacter) end
	Players.PlayerAdded:Connect(function(p) p.CharacterAdded:Connect(avoidCharacter) end)
	local role=npc:GetAttribute("Role"); local lane=npc:GetAttribute("Lane") or 0
	local height=npc:GetAttribute("RootFloorHeight") or 6
	local direction=npc:GetAttribute("Direction") or 1
	local x=npc:GetAttribute("StartX") or 0
	local moving=animate(hum,role=="Runner" and "Run" or "Walk")
	local idle=animate(hum,"Idle")
	-- IK is independent of Motor6D naming and raises the actual hand holding the phone.
	local cameraIK
	if role=="Photographer" then
		local upper=npc:FindFirstChild("RightUpperArm",true)
		local hand=npc:FindFirstChild("RightHand",true)
		if upper and hand then
			local target=Instance.new("Attachment"); target.Name="PhotoHandTarget"; target.Position=Vector3.new(.55,1.1,-1.05); target.Parent=root
			cameraIK=Instance.new("IKControl"); cameraIK.Name="PhotoHandPose"; cameraIK.Type=Enum.IKControlType.Position
			cameraIK.ChainRoot=upper; cameraIK.EndEffector=hand; cameraIK.Target=target; cameraIK.Weight=1; cameraIK.SmoothTime=.35; cameraIK.Enabled=false; cameraIK.Parent=hum
		end
	end
	local function setMoving(value)
		if value then if idle then idle:Stop(.25) end; if moving and not moving.IsPlaying then moving:Play(.25) end
		else if moving then moving:Stop(.25) end; if idle and not idle.IsPlaying then idle:Play(.25) end end
	end
	local dog=npc:FindFirstChild("CompanionDog")
	local tick=0
	if dog and dog.PrimaryPart then
		local position=dog.PrimaryPart.Position
		local connection
		connection=RunService.Heartbeat:Connect(function(dt)
			if not npc.Parent then connection:Disconnect(); return end
			tick+=dt
			local target=(root.CFrame*CFrame.new(2.3,0,-1.4)).Position
			target=Vector3.new(target.X,4.2,target.Z)
			position=position:Lerp(target,math.min(1,dt*5))
			local forward=Vector3.new(root.CFrame.LookVector.X,0,root.CFrame.LookVector.Z)
			local cf=CFrame.lookAt(position,position+forward)
			local walking=root.AssemblyLinearVelocity.Magnitude>.5 -- 2026-11-16 Claude: server MoveDirection stays 0 for MoveTo NPCs
			for _,p in dog:GetChildren() do if p:IsA("BasePart") then
				local offset=p:GetAttribute("DogOffset")
				if offset then
					local swing=p.Name=="Leg" and walking and math.sin(tick*10+(p:GetAttribute("Phase") or 0)*1.57)*.4 or 0
					p.CFrame=cf*offset*CFrame.Angles(swing,0,0)
				end
			end end
		end)
	end
	while npc.Parent and hum.Health>0 do
		setMoving(true)
		local nextX=math.clamp(x+direction*70,-550,550)
		if math.abs(nextX-x)<1 then direction=-direction; nextX=math.clamp(x+direction*70,-550,550) end
		local target=Vector3.new(nextX,height,promenade(nextX)+lane)
		hum:MoveTo(target)
		local timeout=os.clock()+math.max(8,(target-root.Position).Magnitude/hum.WalkSpeed+4)
		local last=root.Position; local stuck=0
		repeat
			task.wait(.4)
			local distance=(root.Position-last).Magnitude
			stuck=distance<.1 and stuck+.4 or 0; last=root.Position
		until not npc.Parent or (root.Position-target).Magnitude<3 or os.clock()>timeout or stuck>3
		if not npc.Parent then break end
		if stuck>3 or root.Position.Y<0 then npc:PivotTo(CFrame.lookAt(target,target+Vector3.new(direction,0,0))) end
		x=nextX
		if role=="Photographer" then
			setMoving(false); hum:MoveTo(root.Position); hum.AutoRotate=false
			local position=root.Position; root.CFrame=CFrame.lookAt(position,Vector3.new(0,position.Y,-350))
			if cameraIK then cameraIK.Enabled=true end
			local photoId=city:GetAttribute("PhotoAnimationId")
			local pose
			if photoId and photoId~="" then
				local a=Instance.new("Animation"); a.AnimationId=photoId
				local ok,result=pcall(function() return hum.Animator:LoadAnimation(a) end); a:Destroy()
				if ok then pose=result; pose.Looped=true; pose:Play(.35) end
			end
			task.wait(2.5+(npc:GetAttribute("PersonIndex") or 1)%3)
			local light=npc:FindFirstChild("ShutterGlow",true)
			if light then light.Brightness=.65; task.wait(.12); light.Brightness=0 end
			task.wait(2.5)
			if pose then pose:Stop(.3); pose:Destroy() end
			if cameraIK then cameraIK.Enabled=false end
			hum.AutoRotate=true
		elseif role~="Runner" then
			setMoving(false); task.wait(role=="DogWalker" and 1.7 or 2.5)
		end
		task.wait(.1)
	end
end
for _,npc in city:GetChildren() do if npc:IsA("Model") then task.spawn(start,npc); task.wait(.1) end end
