-- Server owns sip state; each viewer evaluates the arm pose locally.
local Drink={}
function Drink.Configure(tool,player,notify)
 tool:SetAttribute('GwangalliDrink',true)
 tool:SetAttribute('SipsRemaining',3)
 tool:SetAttribute('Drinking',false)
 tool:SetAttribute('SipStartedAt',0)
 tool.ToolTip='클릭 / 탭: 한 모금 마시기 · Click / tap to sip'
 local busy=false
 local generation=0
 local function cancel()
  generation+=1;busy=false
  tool:SetAttribute('Drinking',false);tool:SetAttribute('SipStartedAt',0)
 end
 tool.Unequipped:Connect(cancel)
 tool.Destroying:Connect(function()generation+=1;busy=false end)
 tool.Activated:Connect(function()
  if busy or tool.Parent~=player.Character then return end
  local humanoid=player.Character and player.Character:FindFirstChildOfClass('Humanoid')
  if not humanoid or humanoid.Health<=0 then return end
  local remaining=tool:GetAttribute('SipsRemaining') or 0
  if remaining<=0 then if notify then notify('drink_empty')end return end
  busy=true;generation+=1;local token=generation
  tool:SetAttribute('SipStartedAt',workspace:GetServerTimeNow());tool:SetAttribute('Drinking',true)
  task.delay(1.08,function()
   if generation~=token or tool.Parent~=player.Character then return end
   remaining-=1;tool:SetAttribute('SipsRemaining',remaining)
   local liquid=tool:FindFirstChild('DrinkLiquid');if liquid then liquid.Transparency=remaining==0 and 1 or 0.15 end
   if notify then notify(remaining==0 and 'drink_empty' or 'drink_sip')end
  end)
  task.delay(1.55,function()
   if generation~=token then return end
   busy=false;tool:SetAttribute('Drinking',false)
  end)
 end)
end
return Drink
