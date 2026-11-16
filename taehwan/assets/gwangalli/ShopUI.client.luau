-- Install in StarterPlayerScripts. No persistent HUD or external assets.
local Players=game:GetService('Players')
local ReplicatedStorage=game:GetService('ReplicatedStorage')
local UserInputService=game:GetService('UserInputService')
local player=Players.LocalPlayer
local playerGui=player:WaitForChild('PlayerGui')
local remote=ReplicatedStorage:WaitForChild('GwangalliShopRemote')
local old=playerGui:FindFirstChild('GwangalliShops'); if old then old:Destroy() end
local strings={
 en={close='Close',balance='Demo tokens: %d',session='100 starting tokens · This visit only · No Robux',CafeOrder='Beachside café',Souvenir='Seashell boutique',ClawPlay='Claw arcade',HotelCheckIn='Ocean-view hotel',HotelRooftop='Rooftop access',tea='Citrus iced tea · 8 tokens',latte='Strawberry latte · 12 tokens',shell='Shell keychain · 15 tokens',play='Play once · 5 tokens',checkin='Check in · 20 tokens',roof='Visit the rooftop · Included',cafe='Order a drink, then take any café seat. Your drink goes into your backpack.',boutique='Take home a little piece of the beach. Your keychain goes into your backpack.',arcade='50% chance of a plush bear each play. Every attempt costs 5 demo tokens, including a miss.',hotel='One check-in unlocks rooftop access for this visit. Use the lobby prompt to return.',too_far='Move closer to the counter and open it again.',insufficient='Not enough demo tokens.',machine_busy='This machine is in use. Try again in a moment.',playing='The claw is moving…',claw_win='You won a seaside plush bear! Check your backpack.',claw_miss='The bear slipped away. Better luck next time!',drink_received='Drink served! Find a seat and enjoy the view.',souvenir_received='Shell keychain added to your backpack.',checked_in='Checked in! Rooftop access is now included.',already_checked_in='You are already checked in. Rooftop access is included.',need_checkin='Check in to unlock the rooftop.',rooftop='Welcome to the rooftop.',lobby='Welcome back to the lobby.',unavailable='Please try again in a moment.',refunded='The machine stopped. Your 5 tokens were returned.'},
 ko={close='닫기',balance='체험 토큰: %d',session='시작 토큰 100개 · 이번 접속 한정 · 로벅스 사용 없음',CafeOrder='바다 앞 카페',Souvenir='조개 기념품점',ClawPlay='인형 뽑기',HotelCheckIn='오션뷰 호텔',HotelRooftop='루프톱 입장',tea='시트러스 아이스티 · 8 토큰',latte='딸기 라테 · 12 토큰',shell='조개 키링 · 15 토큰',play='한 번 뽑기 · 5 토큰',checkin='체크인 · 20 토큰',roof='루프톱 방문 · 추가 비용 없음',cafe='음료를 주문한 뒤 카페 의자에 앉아 보세요. 음료는 배낭에 보관돼요.',boutique='바다의 추억을 간직하세요. 구매한 키링은 배낭에 보관돼요.',arcade='매회 50% 확률로 곰 인형을 받아요. 실패해도 1회당 체험 토큰 5개가 사용돼요.',hotel='한 번 체크인하면 이번 접속 동안 루프톱을 이용할 수 있어요. 로비 이동 안내로 돌아오세요.',too_far='카운터 가까이에서 다시 열어 주세요.',insufficient='체험 토큰이 부족해요.',machine_busy='다른 손님이 이용 중이에요. 잠시 뒤 다시 시도해 주세요.',playing='집게가 움직이고 있어요…',claw_win='바닷가 곰 인형 당첨! 배낭을 확인하세요.',claw_miss='인형이 미끄러졌어요. 다음 기회에 도전해 보세요!',drink_received='음료가 나왔어요! 의자에 앉아 바다를 즐겨 보세요.',souvenir_received='조개 키링을 배낭에 넣었어요.',checked_in='체크인 완료! 이제 루프톱을 이용할 수 있어요.',already_checked_in='이미 체크인했어요. 루프톱을 이용해 보세요.',need_checkin='체크인하면 루프톱을 이용할 수 있어요.',rooftop='루프톱에 오신 것을 환영해요.',lobby='로비로 돌아왔어요.',unavailable='잠시 뒤 다시 시도해 주세요.',refunded='기계가 멈춰 토큰 5개를 돌려드렸어요.'},
 ja={close='閉じる',balance='体験トークン: %d',session='開始時100枚 · 今回の接続のみ · Robux不要',CafeOrder='海辺のカフェ',Souvenir='貝殻のお店',ClawPlay='クレーンゲーム',HotelCheckIn='オーシャンビューホテル',HotelRooftop='屋上への入場',tea='シトラスアイスティー · 8枚',latte='いちごラテ · 12枚',shell='貝殻キーホルダー · 15枚',play='1回遊ぶ · 5枚',checkin='チェックイン · 20枚',roof='屋上へ · 追加料金なし',cafe='飲み物を注文したら、カフェの席へどうぞ。飲み物はバックパックに入ります。',boutique='海辺の思い出をお土産に。キーホルダーはバックパックに入ります。',arcade='毎回50%の確率でクマのぬいぐるみが当たります。外れた場合も1回5枚必要です。',hotel='一度のチェックインで今回の接続中は屋上に入れます。ロビーの案内で戻れます。',too_far='カウンターに近づいて開き直してください。',insufficient='体験トークンが足りません。',machine_busy='使用中です。少し待ってお試しください。',playing='クレーンが動いています…',claw_win='クマが当たりました！バックパックを確認してください。',claw_miss='ぬいぐるみが落ちてしまいました。また挑戦してね！',drink_received='飲み物ができました！座って景色を楽しんでね。',souvenir_received='貝殻キーホルダーを受け取りました。',checked_in='チェックイン完了！屋上を利用できます。',already_checked_in='チェックイン済みです。屋上をご利用ください。',need_checkin='屋上にはチェックインが必要です。',rooftop='屋上へようこそ。',lobby='ロビーに戻りました。',unavailable='しばらくしてからお試しください。',refunded='機械が停止しました。5枚返却しました。'},
 ['zh-cn']={close='关闭',balance='体验代币：%d',session='初始100枚 · 仅本次连接有效 · 无需Robux',CafeOrder='海边咖啡馆',Souvenir='贝壳精品店',ClawPlay='抓娃娃机',HotelCheckIn='海景酒店',HotelRooftop='屋顶露台',tea='柑橘冰茶 · 8枚',latte='草莓拿铁 · 12枚',shell='贝壳钥匙扣 · 15枚',play='玩一次 · 5枚',checkin='办理入住 · 20枚',roof='前往屋顶 · 无需额外代币',cafe='点杯饮品，再坐在咖啡馆的椅子上。饮品将放入背包。',boutique='带走一份海边回忆。钥匙扣将放入背包。',arcade='每次有50%的概率获得小熊。每次消耗5枚体验代币，未中奖也会扣除。',hotel='办理一次入住，本次连接期间即可使用屋顶露台。通过大厅提示返回。',too_far='请靠近柜台重新打开菜单。',insufficient='体验代币不足。',machine_busy='机器正在使用中，请稍后再试。',playing='爪子正在移动…',claw_win='恭喜获得海边小熊！请查看背包。',claw_miss='小熊滑落了，下次再试试吧！',drink_received='饮品做好了！找个座位欣赏海景吧。',souvenir_received='贝壳钥匙扣已放入背包。',checked_in='入住成功！现在可以前往屋顶。',already_checked_in='已办理入住，可以使用屋顶露台。',need_checkin='请先办理入住以解锁屋顶。',rooftop='欢迎来到屋顶露台。',lobby='已返回大厅。',unavailable='请稍后再试。',refunded='机器停止运行，已退还5枚代币。'},
 ['zh-tw']={close='關閉',balance='體驗代幣：%d',session='初始100枚 · 僅本次連線有效 · 無需Robux',CafeOrder='海邊咖啡館',Souvenir='貝殼精品店',ClawPlay='夾娃娃機',HotelCheckIn='海景飯店',HotelRooftop='屋頂露台',tea='柑橘冰茶 · 8枚',latte='草莓拿鐵 · 12枚',shell='貝殼鑰匙圈 · 15枚',play='玩一次 · 5枚',checkin='辦理入住 · 20枚',roof='前往屋頂 · 無需額外代幣',cafe='點杯飲品，再坐在咖啡館的椅子上。飲品將放入背包。',boutique='帶走一份海邊回憶。鑰匙圈將放入背包。',arcade='每次有50%的機率獲得小熊。每次消耗5枚體驗代幣，未中獎也會扣除。',hotel='辦理一次入住，本次連線期間即可使用屋頂露台。透過大廳提示返回。',too_far='請靠近櫃台重新開啟選單。',insufficient='體驗代幣不足。',machine_busy='機器正在使用中，請稍後再試。',playing='爪子正在移動…',claw_win='恭喜獲得海邊小熊！請查看背包。',claw_miss='小熊滑落了，下次再試試吧！',drink_received='飲品做好了！找個座位欣賞海景吧。',souvenir_received='貝殼鑰匙圈已放入背包。',checked_in='入住成功！現在可以前往屋頂。',already_checked_in='已辦理入住，可以使用屋頂露台。',need_checkin='請先辦理入住以解鎖屋頂。',rooftop='歡迎來到屋頂露台。',lobby='已返回大廳。',unavailable='請稍後再試。',refunded='機器停止運作，已退還5枚代幣。'},
}
for lang,phrase in {ko={'한 모금 마셨어요.','음료를 다 마셨어요.'},en={'You took a sip.','Your drink is empty.'},ja={'ひと口飲みました。','飲み終わりました。'},['zh-cn']={'喝了一口。','饮品喝完了。'},['zh-tw']={'喝了一口。','飲品喝完了。'}}do strings[lang].drink_sip=phrase[1];strings[lang].drink_empty=phrase[2]end
local function language()
 local tour=playerGui:FindFirstChild('GwangalliTour')
 local lang=tour and tour:GetAttribute('Language')
 if strings[lang] then return lang end
 local locale=player.LocaleId:lower()
 if locale:sub(1,2)=='ko' then return 'ko' elseif locale:sub(1,2)=='ja' then return 'ja'
 elseif locale:sub(1,2)=='zh' then return (locale:find('tw') or locale:find('hk') or locale:find('hant')) and 'zh-tw' or 'zh-cn' end
 return 'en'
end
local function tr(key) return strings[language()][key] or strings.en[key] or key end
local cream=Color3.fromRGB(255,244,220)
local function make(class,props,parent)
 local object=Instance.new(class)
 for key,value in props do object[key]=value end
 object.Parent=parent; return object
end
local function round(object,radius) make('UICorner',{CornerRadius=UDim.new(0,radius or 14)},object) end
local gui=make('ScreenGui',{Name='GwangalliShops',ResetOnSpawn=false,DisplayOrder=30,ZIndexBehavior=Enum.ZIndexBehavior.Sibling},playerGui)
local overlay=make('Frame',{Name='ShopOverlay',Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.fromRGB(3,15,22),BackgroundTransparency=.3,Visible=false,Active=true},gui)
local panel=make('ScrollingFrame',{Name='ShopPanel',AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.new(1,-32,0,510),BackgroundColor3=Color3.fromRGB(17,49,57),BorderSizePixel=0,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollBarThickness=4,ScrollBarImageColor3=cream},overlay)
round(panel,22)
make('UISizeConstraint',{MaxSize=Vector2.new(460,560),MinSize=Vector2.new(200,140)},panel)
make('UIPadding',{PaddingTop=UDim.new(0,20),PaddingBottom=UDim.new(0,20),PaddingLeft=UDim.new(0,20),PaddingRight=UDim.new(0,20)},panel)
make('UIListLayout',{Padding=UDim.new(0,12),SortOrder=Enum.SortOrder.LayoutOrder},panel)
local function label(parent,size,color,order)
 return make('TextLabel',{BackgroundTransparency=1,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,Text='',TextSize=size,Font=Enum.Font.SourceSansSemibold,TextColor3=color or cream,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,LayoutOrder=order or 0},parent)
end
local header=make('Frame',{BackgroundTransparency=1,Size=UDim2.new(1,0,0,48),LayoutOrder=1},panel)
local title=label(header,26); title.Size=UDim2.new(1,-90,1,0); title.AutomaticSize=Enum.AutomaticSize.None
local close=make('TextButton',{AnchorPoint=Vector2.new(1,0),Position=UDim2.fromScale(1,0),Size=UDim2.fromOffset(84,48),BackgroundColor3=Color3.fromRGB(38,78,84),TextColor3=cream,TextSize=18,Font=Enum.Font.SourceSansSemibold,Text=''},header);round(close,12)
local balance=label(panel,22,Color3.fromRGB(247,209,139),2)
local description=label(panel,19,cream,3)
local buttons=make('Frame',{Name='Actions',BackgroundTransparency=1,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,LayoutOrder=4},panel)
make('UIListLayout',{Padding=UDim.new(0,10),SortOrder=Enum.SortOrder.LayoutOrder},buttons)
local response=label(panel,19,Color3.fromRGB(148,225,205),5)
local note=label(panel,18,Color3.fromRGB(189,210,206),6)
local toast=make('TextLabel',{AnchorPoint=Vector2.new(.5,0),Position=UDim2.new(.5,0,.25,0),Size=UDim2.new(1,-32,0,90),BackgroundColor3=Color3.fromRGB(17,49,57),TextColor3=cream,TextSize=20,Font=Enum.Font.SourceSansSemibold,TextWrapped=true,Visible=false},gui)
round(toast,16);make('UISizeConstraint',{MaxSize=Vector2.new(460,120)},toast)
make('UIPadding',{PaddingLeft=UDim.new(0,16),PaddingRight=UDim.new(0,16)},toast)
local state={balance=100,checkedIn=false,busy=false}
local menuKind, messageKey, toastKey
local pending=false
local function addButton(key,action,order)
 local b=make('TextButton',{Name=action,Size=UDim2.new(1,0,0,56),BackgroundColor3=state.busy and Color3.fromRGB(67,87,86) or Color3.fromRGB(244,207,149),TextColor3=Color3.fromRGB(23,47,52),TextSize=20,Text=tr(key),Font=Enum.Font.SourceSansSemibold,TextWrapped=true,AutoButtonColor=not state.busy,Active=not state.busy,LayoutOrder=order},buttons)
 round(b,12)
 b.Activated:Connect(function()
  if state.busy or pending then return end
  pending=true; remote:FireServer(action)
  task.delay(.8,function() pending=false end)
 end)
end
local function render()
 close.Text=tr('close'); note.Text=tr('session')
 if toastKey then toast.Text=tr(toastKey) end
 if not menuKind then return end
 title.Text=tr(menuKind); balance.Text=string.format(tr('balance'),state.balance)
 description.Text=tr(menuKind=='CafeOrder' and 'cafe' or menuKind=='Souvenir' and 'boutique' or menuKind=='ClawPlay' and 'arcade' or 'hotel')
 response.Text=messageKey and tr(messageKey) or ''
 for _,child in buttons:GetChildren() do if child:IsA('TextButton') then child:Destroy() end end
 if menuKind=='CafeOrder' then addButton('tea','cafe_tea',1);addButton('latte','cafe_latte',2)
 elseif menuKind=='Souvenir' then addButton('shell','souvenir_shell',1)
 elseif menuKind=='ClawPlay' then addButton('play','claw_play',1)
 elseif state.checkedIn then addButton('roof','hotel_rooftop',1)
 else addButton('checkin','hotel_checkin',1) end
end
local function resize()
 local camera=workspace.CurrentCamera
 if camera then panel.Size=UDim2.new(1,-32,0,math.max(140,math.min(560,camera.ViewportSize.Y-64))) end
end
local function bindCamera()
 local camera=workspace.CurrentCamera
 if camera then camera:GetPropertyChangedSignal('ViewportSize'):Connect(resize) end
 resize()
end
workspace:GetPropertyChangedSignal('CurrentCamera'):Connect(bindCamera);bindCamera()
close.Activated:Connect(function() overlay.Visible=false end)
UserInputService.InputBegan:Connect(function(input,processed)
 if not processed and input.KeyCode==Enum.KeyCode.Escape then overlay.Visible=false end
end)
local toastSerial=0
remote.OnClientEvent:Connect(function(payload)
 if type(payload)~='table' then return end
 if payload.status=='notice' and type(payload.message)=='string' then
  toastKey=payload.message;toast.Text=tr(toastKey);toast.Visible=true;toastSerial+=1
  local serial=toastSerial;task.delay(3,function()if serial==toastSerial then toast.Visible=false end end)
  return
 end
 if type(payload.balance)=='number' then state.balance=payload.balance end
 state.checkedIn=payload.checkedIn==true
 state.busy=payload.status=='busy';pending=false
 if payload.status=='open' and strings.en[payload.kind] then
  menuKind=payload.kind;messageKey=nil;overlay.Visible=true;toast.Visible=false
 elseif type(payload.message)=='string' then
  if payload.status=='result' and (payload.message=='rooftop' or payload.message=='lobby') then overlay.Visible=false;menuKind=nil end
  messageKey=payload.message
  if not overlay.Visible then
   toastKey=payload.message;toast.Text=tr(toastKey);toast.Visible=true;toastSerial+=1
   local serial=toastSerial
   task.delay(4,function() if serial==toastSerial then toast.Visible=false end end)
  end
 end
 render()
end)
local function watchTour(tour)
 if tour.Name=='GwangalliTour' then tour:GetAttributeChangedSignal('Language'):Connect(render);render() end
end
playerGui.ChildAdded:Connect(watchTour)
local tour=playerGui:FindFirstChild('GwangalliTour');if tour then watchTour(tour) end
