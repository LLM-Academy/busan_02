-- Two-bone arm pose after the Animator; supports current R15 joints.
local Players=game:GetService('Players')
local RunService=game:GetService('RunService')
local active={}
local function jointFrames(joint)
 if joint:IsA('AnimationConstraint')then return joint.Attachment0.CFrame,joint.Attachment1.CFrame end
 return joint.C0,joint.C1
end
local function rotateBetween(from,to)
 local u,v=from.Unit,to.Unit;local axis=u:Cross(v);local dot=math.clamp(u:Dot(v),-1,1)
 if axis.Magnitude<.00001 then
  if dot>0 then return CFrame.identity end
  local perpendicular=u:Cross(math.abs(u.Y)<.9 and Vector3.yAxis or Vector3.xAxis)
  return CFrame.fromAxisAngle(perpendicular.Unit,math.pi)
 end
 return CFrame.fromAxisAngle(axis.Unit,math.acos(dot))
end
local function stop(character)
 local state=active[character];if not state then return end
 active[character]=nil
 if state.connection then state.connection:Disconnect()end
 for joint,transform in state.originals do if joint.Parent then joint.Transform=transform end end
end
local function observeTool(character,tool)
 if not tool:IsA('Tool')then return end
 task.spawn(function()
  local deadline=os.clock()+3
  while tool.Parent==character and tool:GetAttribute('GwangalliDrink')==nil and os.clock()<deadline do task.wait(.05)end
  if tool.Parent~=character or not tool:GetAttribute('GwangalliDrink')then return end
  local torso=character:FindFirstChild('UpperTorso');local head=character:FindFirstChild('Head');local hand=character:FindFirstChild('RightHand')
  if not torso or not head or not hand then return end
  local joints={}
  for _,j in character:GetDescendants()do
   if (j:IsA('Motor6D')or j:IsA('AnimationConstraint'))and(j.Name=='RightShoulder'or j.Name=='RightElbow'or j.Name=='RightWrist')then joints[j.Name]=j end
  end
  local shoulder,elbow,wrist=joints.RightShoulder,joints.RightElbow,joints.RightWrist
  if not shoulder or not elbow or not wrist then return end
  local grip=hand:FindFirstChild('RightGrip')
  while tool.Parent==character and (not grip or grip.Part1~=tool:FindFirstChild('Handle'))and os.clock()<deadline do task.wait(.03);grip=hand:FindFirstChild('RightGrip')end
  if tool.Parent~=character or not grip or grip.Part1~=tool:FindFirstChild('Handle')then return end
  stop(character)
  local s0,s1=jointFrames(shoulder);local e0,e1=jointFrames(elbow);local w0,w1=jointFrames(wrist)
  local first=e0.Position-s1.Position;local second=w0.Position-e1.Position
  local length1,length2=first.Magnitude,second.Magnitude
  if length1<.01 or length2<.01 then return end
  local handToHandle=grip.C0*grip.C1:Inverse()
  local state={tool=tool,originals={[shoulder]=shoulder.Transform,[elbow]=elbow.Transform,[wrist]=wrist.Transform}}
  active[character]=state
  state.connection=RunService.PreSimulation:Connect(function()
   if tool.Parent~=character or not head.Parent or not torso.Parent then stop(character);return end
   local started=tool:GetAttribute('SipStartedAt')or 0
   local age=workspace:GetServerTimeNow()-started;local alpha=0
   if started>0 and age>=0 then
    if age<.42 then alpha=age/.42 elseif age<1.07 then alpha=1 elseif age<1.47 then alpha=1-(age-1.07)/.4 end
   end
   alpha=(1-math.cos(math.clamp(alpha,0,1)*math.pi))/2
   local carry=torso.CFrame*CFrame.new(.85,.3,-.65)
   local sip=head.CFrame*CFrame.new(.4,-1.2,-.55)
   local desiredHand=carry:Lerp(sip,alpha)*handToHandle:Inverse()
   local start=(torso.CFrame*s0).Position;local finish=(desiredHand*w1).Position;local delta=finish-start
   if delta.Magnitude<.0001 then return end
   local distance=math.clamp(delta.Magnitude,math.abs(length1-length2)+.001,length1+length2-.001)
   local direction=delta.Unit;finish=start+direction*distance
   desiredHand=desiredHand+(finish-(desiredHand*w1).Position)
   local pole=torso.CFrame:PointToWorldSpace(Vector3.new(1.6,-.7,0))
   local bend=pole-start-direction*(pole-start):Dot(direction)
   if bend.Magnitude<.001 then bend=torso.CFrame.LookVector:Cross(direction)end
   if bend.Magnitude<.001 then return end
   local along=(length1*length1-length2*length2+distance*distance)/(2*distance)
   local joint=start+direction*along+bend.Unit*math.sqrt(math.max(0,length1*length1-along*along))
   local base=torso.CFrame.Rotation
   local upperRotation=rotateBetween(base:VectorToWorldSpace(first),joint-start)*base
   local upper=CFrame.new(start-upperRotation:VectorToWorldSpace(s1.Position))*upperRotation
   local lowerRotation=rotateBetween(base:VectorToWorldSpace(second),finish-joint)*base
   local lower=CFrame.new(joint-lowerRotation:VectorToWorldSpace(e1.Position))*lowerRotation
   shoulder.Transform=s0:Inverse()*torso.CFrame:ToObjectSpace(upper)*s1
   elbow.Transform=e0:Inverse()*upper:ToObjectSpace(lower)*e1
   wrist.Transform=w0:Inverse()*lower:ToObjectSpace(desiredHand)*w1
  end)
 end)
end
local function observeCharacter(character)
 for _,tool in character:GetChildren()do observeTool(character,tool)end
 character.ChildAdded:Connect(function(tool)observeTool(character,tool)end)
 character.ChildRemoved:Connect(function(tool)local s=active[character];if s and s.tool==tool then stop(character)end end)
 character.Destroying:Connect(function()stop(character)end)
end
local function observePlayer(player)
 if player.Character then observeCharacter(player.Character)end
 player.CharacterAdded:Connect(observeCharacter)
end
for _,p in Players:GetPlayers()do observePlayer(p)end
Players.PlayerAdded:Connect(observePlayer)
script.Destroying:Connect(function()for character in active do stop(character)end end)
