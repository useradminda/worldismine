UIControl = {}

local UIControl = BasePanel:new()
local this = UIControl
UIControl.UIControlGob = nil

UIControl.AnchorCenter = nil
UIControl.OutSideUIList = nil
UIControl.UICamera = nil
UIControl.InitPanel = nil
UIControl.MainCameraTransForm = nil
UIControl.Palace = nil
UIControl.HandBook = nil
UIControl.TeamMake = nil
UIControl.Market = nil
UIControl.HeroBattle = nil
UIControl.HeroRank = nil
UIControl.JJC = nil

UIControl.AnchorTopRightList = nil
UIControl.RightDownList = nil
UIControl.RightMediumnList = nil
UIControl.ClickShift = nil

function UIControl:OpenUI(_PanelName , _LuaName)
    
    if UIControl.UIControlGob==nil then
		UIControl.UIControlGob = MainGameUI.FindPanel("UIControl")
        UIControl.AnchorCenter = UIControl.UIControlGob.transform:FindChild("Camera"):FindChild("AnchorCenter")
        UIControl.OutSideUIList = UIControl.UIControlGob.transform:FindChild("Camera"):FindChild("OutSideUIList")   
        UIControl.UICamera = UIControl.UIControlGob.transform:FindChild("Camera"):GetComponent("Camera")
        UIControl.InitPanel =  UIControl.UIControlGob.transform:FindChild("Camera"):FindChild("InitPanel") 
        UIControl.MainCameraTransForm = MainGameUI.GetMainCameraInUICity().transform
        UIControl.MainCamera = MainGameUI.GetMainCameraInUICity():GetComponent("Camera")
	    UIControl.Palace = UIControl.OutSideUIList.transform:FindChild("AnchorBottomLeft"):FindChild("Palace") 
        UIControl.HandBook = UIControl.OutSideUIList.transform:FindChild("AnchorBottomLeft"):FindChild("HandBook") 
        UIControl.TeamMake = UIControl.OutSideUIList.transform:FindChild("AnchorBottomLeft"):FindChild("TeamMake") 
        UIControl.Market = UIControl.OutSideUIList.transform:FindChild("AnchorBottomLeft"):FindChild("Market") 
        UIControl.HeroBattle = UIControl.OutSideUIList.transform:FindChild("AnchorBottomLeft"):FindChild("HeroBattle") 
        UIControl.HeroRank = UIControl.OutSideUIList.transform:FindChild("AnchorBottomLeft"):FindChild("HeroRank") 
        UIControl.JJC = UIControl.OutSideUIList.transform:FindChild("AnchorBottomLeft"):FindChild("JJC") 
		UIControl.AnchorTopRightList = UIControl.OutSideUIList.transform:FindChild("AnchorTopRight/Grid3"):GetComponent("TweenPosition")
		UIControl.RightDownList = UIControl.OutSideUIList.transform:FindChild("AnchorBottom/RightDownView/Grid1"):GetComponent("TweenPosition")
		UIControl.RightMediumnList = UIControl.OutSideUIList.transform:FindChild("AnchorBottomRight/RightDownView/Grid"):GetComponent("TweenPosition")
		UIControl.ClickShift = UIControl.OutSideUIList.transform:FindChild("AnchorBottomRight/Reuduce/BG"):GetComponent("TweenRotation")
	end
    this:ShowSysTime()
    this:LoginButtonEvent()
	this:SetNowMap()
    this:ShowHeroInfo()
	this:ShowOnLineInfo()
    this:ShowChooseCampBtn()
    this:SetSta()
	this:ShowVipSpecailInfo()
	this:ShadeWorldBattle()
    this:InitBoradCast()
    this:SetClinetInfo()
    GameMain.AddUpdateLua(this.UpdateUIPosition)
	this:ShowUpLvl()
	this:ShowSevenImg()
   
end


function UIControl:ShowUpLvl()
	if GameMain.EnterGame == true and ClinetInfomation.UpLvl == true then
		DataUIInstance.OpenPlayerUpLvl()
		ClinetInfomation.UpLvl = false
	end
	
end

function UIControl:ShowSevenImg()
   if SignSys.SevenDayTimes >= 7 then
      if UIControl.OutSideUIList~=nil then
         UIControl.OutSideUIList.transform:FindChild("AnchorTopRight/Grid3"):FindChild("SevenSignBtn").gameObject:SetActive(false)
         UIControl.OutSideUIList.transform:FindChild("AnchorTopRight/Grid3"):GetComponent("UIGrid").enabled = true
         UIControl.OutSideUIList.transform:FindChild("AnchorTopRight/Grid3"):GetComponent("UIGrid"):Reposition()
      end
   end
end

UIControl.WorldButton = nil
UIControl.Chat = nil
function UIControl:ShadeWorldBattle()
	if UIControl.WorldButton == nil then
		UIControl.WorldButton =  UIControl.OutSideUIList.transform:FindChild("AnchorBottomRight/RightDownView/Grid"):FindChild("WorldButton")
	end
	if UIControl.Chat == nil then
		UIControl.Chat = UIControl.AnchorCenter.transform:FindChild("UIChat")
	end
	if GameMain.IOSTest == true then
		GameMain.CloseObj(UIControl.WorldButton)
		GameMain.CloseObj(UIControl.Chat)		
		
	end
end

function UIControl:ShowFirstRechargeInfo()
	if UIControl.OutSideUIList~=nil then
		local firstRechargeBtn = UIControl.OutSideUIList.transform:FindChild("AnchorTopRight/Grid3/FirstRecharge")
		if RechargeSys.IsFrist==0 then
			GameMain.OpenObj(firstRechargeBtn)
		else
			if RechargeSys.IsRecFrist == 1 then
				GameMain.CloseObj(firstRechargeBtn)
				this:SetGridListSort()
			else
				GameMain.OpenObj(firstRechargeBtn)
			end
		end
	end
end

function UIControl:SetGridListSort()
	local grid = UIControl.AnchorTopRightList.transform:GetComponent("UIGrid")
	if grid ~= nil then
		grid.enabled = true
		grid:Reposition()
	end
end

function UIControl:ShowChooseCampBtn()
	if UIControl.OutSideUIList~=nil then
		local camp = ClinetInfomation.GetCamp()
		local campBtn = UIControl.OutSideUIList.transform:FindChild("AnchorBottom/CampButton")
		
		if  camp~=0 then
			GameMain.CloseObj(campBtn)
		else
			GameMain.OpenObj(campBtn)
		end
	end
end

function UIControl:UIHand(_LuaName , _Gob)
	MusicManagerSys.ButtonClick()
   if _Gob~=nil then
      local _ButtonName = _Gob.name
      if UIControl["ButtonEvent"][_ButtonName]~=nil then
         UIControl["ButtonEvent"][_ButtonName]()
      end
   end

   if _Gob.name == "PveButton" then
      local _MapData = MapConfig.MapConfig[100101]
      local _Map = MapSys.CreateMap(_MapData)
      MapSys.Fight(_Map)    
   end

	if _Gob.name == "AddCoin" then
		this:OpenCollect()
	end
	if _Gob.name == "AddDiamond" then
		DataUIInstance.OpenRecharge()
	end

	if _Gob.name == "CampButton" then
		this:OpenChooseCamp()
	end
	if _Gob.name == "VipSpecialOne" then
		this:OpenVipSpecialTest(1)
	end
	if _Gob.name == "VipSpecialTwo" then
		this:OpenVipSpecialTest(3)
	end

	if _Gob.name == "ExpandTopRightBtn" then
		this:AnchorTopRightListMove()
	end
	if _Gob.name == "Reuduce" then
		this:ShowDownListMove()
	end
--	if _Gob.name == "zhuxiaoBtn" then
--		this:TologOut() -- 注销
--	end
end

function UIControl:TologOut()
	GameMain.logOut()
end

UIControl.ExpandLabel = nil

function UIControl:AnchorTopRightListMove()
	if UIControl.ExpandLabel == nil then
		UIControl.ExpandLabel = UIControl.UIControlGob.transform:FindChild("Camera/AnchorTop/ExpandBtn/Label"):GetComponent("UILabel")
	end
	local time = TimeControl.GetTime("UIControlTopViewTime")
	if time == nil then
		TimeControl.LoginTime(0.62 , "UIControlTopViewTime")
		this:ToMoveTopList()
		return
	end
	if time <=0 then
		TimeControl.LoginTime(0.62 , "UIControlTopViewTime")
		this:ToMoveTopList()
	end
end

function UIControl:ToMoveTopList()
	local curPos = UIControl.AnchorTopRightList.transform.localPosition
	local toPos = Vector3(0,0,0)
	if curPos.x<0 then
		toPos = Vector3( 40 , curPos.y,curPos.z)
		UIControl.ExpandLabel.text = "展开"
	else
		toPos = Vector3( -790 , curPos.y,curPos.z)
		UIControl.ExpandLabel.text = "收起"
	end
	this:ToLetTweenPlay(UIControl.AnchorTopRightList, curPos , toPos , 0.6)
end

function UIControl:ShowDownListMove()
	local time = TimeControl.GetTime("UIControlViewTime")
	if time == nil then
		TimeControl.LoginTime(0.62 , "UIControlViewTime")
		this:ToMoveViewList()
		return
	end
	if time <=0 then
		TimeControl.LoginTime(0.62 , "UIControlViewTime")
		this:ToMoveViewList()
	end
	
end

function UIControl:ToMoveViewList()
	local fromDownPos = UIControl.RightDownList.transform.localPosition
	local toDownPos = Vector3(0,0,0)
	if fromDownPos.x<0 then
		toDownPos = Vector3(556,fromDownPos.y,fromDownPos.z)
	else
		toDownPos = Vector3(-169,fromDownPos.y,fromDownPos.z)
	end
	local fromRightPos = UIControl.RightMediumnList.transform.localPosition
	local toRightPos = Vector3(0,0,0)
	if fromRightPos.y<0 then
		toRightPos = Vector3(fromRightPos.x,2,fromRightPos.z)
	else
		toRightPos = Vector3(fromRightPos.x,-418,fromRightPos.z)
	end

	local fromRotate = UIControl.ClickShift.transform.localEulerAngles
	local toRotate = Vector3(0,0,90)
	if fromRotate.z==0 then
		toRotate = Vector3(0,0,90)
	else
		toRotate = Vector3(0,0,0)
	end
	this:ToLetTweenPlay(UIControl.RightDownList , fromDownPos , toDownPos , 0.6)
	this:ToLetTweenPlay(UIControl.RightMediumnList , fromRightPos , toRightPos , 0.6)
	this:ToLetTweenPlay(UIControl.ClickShift , fromRotate , toRotate , 0.6)
end

function UIControl:ToLetTweenPlay(_Tween , _From , _To , _DurTime)
	_Tween.from = _From
	_Tween.to = _To
	_Tween.duration = _DurTime
	_Tween.enabled = true
	_Tween:ResetToBeginning()
	_Tween:Play()
end

function UIControl:LoginButtonEvent()
   UIControl["ButtonEvent"] =
   {
      ["Login"] = this.OpenLoginPanel,
      ["BagBtn"] = this.OpenBagPanel,
      ["WorldButton"] = this.OpenWorldMap,
      ["MapButton"] = this.OpenMap,
	  ["HeroBtn"] = this.OpenHeroInfo,
	  ["SoliderBtn"] = this.OpenSoliderInfo,
      ["TeamMake"] = this.OpenTeamMake,
	  ["HireHero"] = this.OpenHireHero,
	  ["EquipBtn"] = this.OpenEquip,
	  ["HeroBattle"] = this.OpenHeroBattle,
      ["Mission"] = this.OpenMission,
      ["BattleFlag"] = this.OpenBattleFlag,
      ["Shop"] = this.OpenShop,
	  ["Technology"] = this.OpenTechnology,
	  ["Lottery"] = this.OpenConsumpGift,
	  ["Sign"] = this.OpenSign,
	  ["SevenSignBtn"] = this.OpenSevenSign,
	  ["foundation"] = this.OpenFund,
      ["RechargeBtn"] = this.OpenRecharge,
      ["Friend"] = this.OpenFriend,
      ["Favourable"] = this.OpenSpecialFavourable,
      ["OnLine"] = this.OpenOnLineReward,
      ["MonthCard"] = this.OpenMonthRight,
      ["FirstRecharge"] = this.OpenFirstRecharge,  
	  ["Vip"] = this.OpenVip,  
      ["HandBook"] = this.OpenHandBook,
      ["JJC"] = this.OpenBattleField,
      ["HeroRank"] = this.OpenHeroRank,
      ["Palace"] = this.OpenPalace,
	  ["Market"] = this.OpenMarket,
      ["ZhengZhan"] = this.OpenZhengZhan,
	  ["HeadInfo"] = this.OpenPlayerInfo,
--	  ["VipSpecialBtn"] = this.OpenVipSpecial,
--	  ["VipSpecialOne"] = this.OpenVipSpecial,
--	  ["VipSpecialTwo"] = this.OpenVipSpecial,
      ["Recharge"] = this.OpenRecharge,
      ["Mail"] = this.OpenMail,
	  ["test"] = this.test,
   }
end

UIControl.X = 0
UIControl.EndX = 0
function UIControl:UIDragEvent(_LuaName , _Gob , _Detal)
     
     if UIControl.MainCameraTransForm==nil then
        return
     end
     if _Gob.name == "MainMoveCity" or  _Gob.name == "Palace" or  _Gob.name == "HandBook" 
     or  _Gob.name == "Market" or  _Gob.name == "HeroBattle" or  _Gob.name == "HeroRank" 
     or  _Gob.name == "JJC" or  _Gob.name == "TeamMake"  then
        UIControl.X = _Detal.x/5
        UIControl.EndX = UIControl.MainCameraTransForm.localPosition.x - UIControl.X

        if UIControl.EndX <= -11 then
           UIControl.EndX = -11
        elseif  UIControl.EndX >= 15 then
           UIControl.EndX = 15
        end

       
       UIControl.MainCameraTransForm.localPosition = Vector3(UIControl.EndX  , UIControl.MainCameraTransForm.localPosition.y , UIControl.MainCameraTransForm.localPosition.z)
     end
end

UIControl.NowTime = 0
UIControl.TotalTime = 0.01
function UIControl.UpdateUIPosition(dt)
   if UIControl.MainCamera==nil then
      return
   end
   UIControl.NowTime = UIControl.NowTime + dt
   if UIControl.NowTime >= UIControl.TotalTime then
       UIControl.NowTime = 0
       local _ScreenPosition = UIControl.MainCamera:WorldToScreenPoint(Vector3(-2.5 , 2.7248 , 79.39))      --王宫
       local _ttt = Vector3(_ScreenPosition.x , _ScreenPosition.y , 0)
       local _TarPos = UIControl.UICamera:ScreenToWorldPoint(_ttt)
       UIControl.Palace.position = Vector3(_TarPos.x + 0.4 , _TarPos.y + 0.15 , 0)

       local _ScreenPosition = UIControl.MainCamera:WorldToScreenPoint(Vector3(-33.81 , 0 , 35.65))      --图鉴
       local _ttt = Vector3(_ScreenPosition.x , _ScreenPosition.y , 0)
       local _TarPos = UIControl.UICamera:ScreenToWorldPoint(_ttt)
       UIControl.HandBook.position = Vector3(_TarPos.x , _TarPos.y + 0.22 , 0)

       local _ScreenPosition = UIControl.MainCamera:WorldToScreenPoint(Vector3(23.85 ,0, 25.89))      --寄售行     
       local _ttt = Vector3(_ScreenPosition.x , _ScreenPosition.y , 0)
       local _TarPos = UIControl.UICamera:ScreenToWorldPoint(_ttt)
       UIControl.Market.position = Vector3(_TarPos.x , _TarPos.y + 0.2 , 0)

       local _ScreenPosition = UIControl.MainCamera:WorldToScreenPoint(Vector3(-2.1 , 0 , 27.52))      --英雄榜
       local _ttt = Vector3(_ScreenPosition.x , _ScreenPosition.y , 0)
       local _TarPos = UIControl.UICamera:ScreenToWorldPoint(_ttt)
       UIControl.HeroRank.position = Vector3(_TarPos.x , _TarPos.y + 0.0 , 0)
    
       local _ScreenPosition = UIControl.MainCamera:WorldToScreenPoint(Vector3(-13.63 , 0, -4.3))       --斗将台
       local _ttt = Vector3(_ScreenPosition.x , _ScreenPosition.y , 0)
       local _TarPos = UIControl.UICamera:ScreenToWorldPoint(_ttt)
       UIControl.HeroBattle.position = Vector3(_TarPos.x + 0.1 , _TarPos.y - 0.1 , 0)

       local _ScreenPosition = UIControl.MainCamera:WorldToScreenPoint(Vector3(8.02 , 0 , -4.95))       --沙场点兵
       local _ttt = Vector3(_ScreenPosition.x , _ScreenPosition.y , 0)
       local _TarPos = UIControl.UICamera:ScreenToWorldPoint(_ttt)
       UIControl.JJC.position = Vector3(_TarPos.x , _TarPos.y - 0.08 , 0)

       local _ScreenPosition = UIControl.MainCamera:WorldToScreenPoint(Vector3(23.26 , 0 , 0.94))       --布阵
       local _ttt = Vector3(_ScreenPosition.x , _ScreenPosition.y , 0)
       local _TarPos = UIControl.UICamera:ScreenToWorldPoint(_ttt)
       UIControl.TeamMake.position = Vector3(_TarPos.x , _TarPos.y - 0.05 , 0)
   end
end

function UIControl:OpenVipSpecial()			--打开VIP特惠
	DataUIInstance.OpenVipSpecial(0)
end

function UIControl:OpenVipSpecialTest(_Vip)
	DataUIInstance.OpenVipSpecial(_Vip)
end

function UIControl:OpenPlayerInfo()
	DataUIInstance.OpenPlayerInfo()
end

function UIControl:OpenChooseCamp()			--打开选择阵营界面
	DataUIInstance.CreateChooseCamp()
end

function UIControl:OpenLoginPanel()     --打开login
   DataUIInstance.CreateLogin()
end

function UIControl:OpenBagPanel()       --打开背包
   local _Pass = SystemOpenSys.IsOpen(104)
   if _Pass==false then
      return
   end
   DataUIInstance.CreateBag()
end

function UIControl:OpenMap()          --打开地图
   DataUIInstance.CreateMap()
end

function UIControl:OpenHeroInfo()	--打开武将信息
    local _Pass = SystemOpenSys.IsOpen(101)
    if _Pass==false then
       return
    end
	DataUIInstance.OpenHeroInfo()
end

function UIControl:OpenSoliderInfo()	--打开士兵信息
    local _Pass = SystemOpenSys.IsOpen(107)
    if _Pass==false then
       return
    end
	DataUIInstance.OpenSoliderInfo()
end

function UIControl:OpenHireHero()     --打开招募面板
    local _Pass = SystemOpenSys.IsOpen(102)
    if _Pass==false then
       return
    end
	DataUIInstance.OpenHireHero()
end

function UIControl:OpenEquip()		  --打开装备界面
    local _Pass = SystemOpenSys.IsOpen(103)
    if _Pass==false then
       return
    end
	DataUIInstance.OpenEquip()	
end

function UIControl:OpenMission()        --打开任务
    DataUIInstance.OpenMission()
end

function UIControl.ttt()

end

function UIControl:OpenBattleFlag()    --打开战旗
    local _Pass = SystemOpenSys.IsOpen(112)
    if _Pass==false then
       return
    end
    DataUIInstance.OpenBattleFlag()
end

function UIControl:OpenShop()          --打开商店
    DataUIInstance.OpenShop()
end

function UIControl:OpenConsumpGift()	--打开抽奖
	DataUIInstance.OpenConsumpGift()
end

function UIControl.OpenTechnology()		--打开科技
   local _Pass = SystemOpenSys.IsOpen(105)
   if _Pass==false then
      return
   end
	DataUIInstance.OpenTechnology()
end

function UIControl:OpenCollect()		--打开征收
    local _Pass = SystemOpenSys.IsOpen(106)
   if _Pass==false then
      return
   end
	DataUIInstance.OpenCollect()
end

function UIControl.OpenSign()			--打开签到
    --WebEvent.SendMail(nil , "asd" , UIControl.OpenSevenSign)
	DataUIInstance.OpenSign()
end

function UIControl.OpenSevenSign()		--打开7日签到
	DataUIInstance.OpenSevenSign()
end

function UIControl.OpenFund()			--打开基金
	DataUIInstance.OpenFund()
end

function UIControl.OpenVip()			--打开Vip
	DataUIInstance.OpenVip()
end

function UIControl.OpenRecharge()    --打开充值
    DataUIInstance.OpenRecharge()
end

function UIControl.OpenMail()           --打开邮箱
    DataUIInstance.OpenMail()
end

function UIControl.OpenFriend()       --打开好友
    local _Pass = SystemOpenSys.IsOpen(110)
    if _Pass==false then
      return
    end 
    DataUIInstance.OpenFriend()
end

function UIControl.OpenMarket()			--打开寄售行
    local _Pass = SystemOpenSys.IsOpen(116)
    if _Pass==false then
      return
    end 
	DataUIInstance.OpenMarket()
end

function UIControl.OpenOnLineReward()    --打开在线礼包
	local isCanOpen = OnlineRwdSys.IsOpenSys()
	if isCanOpen == true then
		DataUIInstance.OpenOnLineReward()
	else
		DataUIInstance.PopTip("在线奖励已领完")
	end
end

function UIControl.OpenFirstRecharge()    --打开首冲
    DataUIInstance.OpenFirstRecharge()
end

function UIControl.OpenSpecialFavourable()    --打开特惠

    DataUIInstance.PopTip("尽请期待")    
   -- DataUIInstance.OpenSpecialFavourable()
end

function UIControl.OpenMonthRight()    --打开月卡
    DataUIInstance.OpenMonthRight()
end

function UIControl.OpenHandBook()    --打开图鉴
    DataUIInstance.OpenHandBook() 
end

function UIControl.OpenBattleField()    --打开沙场
    local _Pass = SystemOpenSys.IsOpen(109)
    if _Pass==false then
      return
    end
    DataUIInstance.OpenBattleField(1) 
end

function UIControl.OpenHeroBattle()     --打开豆浆台
    local _Pass = SystemOpenSys.IsOpen(117)
    if _Pass==false then
      return
    end
    DataUIInstance.OpenBattleField(2)
end

function UIControl.OpenHeroRank()
    local _Pass = SystemOpenSys.IsOpen(114)
    if _Pass==false then
      return
    end
    DataUIInstance.OpenHeroRank()
end


function UIControl.OpenPalace()  
    local _Pass = SystemOpenSys.IsOpen(115)
    if _Pass==false then
      return
    end 
	local isJoin = ClinetInfomation.MyOwner
	if isJoin == 0 then
		DataUIInstance.PopTip(UIstring.PeleaseJoinPalace)
		return
	end
    DataUIInstance.OpenPalace()
end

UIControl.MapData = nil
function UIControl:OpenZhengZhan()
    local _TempChapterData =  MapDataSys.GetChapterByTurn(MapSys.NowChapter)
    local _MapData = MapConfig.GetMapByChapterIDMapTurn(_TempChapterData.DbId , MapSys.NowMap)
    
    local _Map = MapSys.CreateMap(_MapData)
    UIControl.MapData = _Map


    if _Map.BattleType==3 then
       local _data = nil
       _data = TeamSys.GetPvpTeamUpInfo()
       DataUIInstance.PopTipPanel("ChangeTeam" , UIControl.ChangeTeam , _data)
       return
    end

    if ClinetInfomation.Sta == 0 then
      
      local UseCount = MapSys.NeedHufu
      local Descrip = UIstring.UseHuFu..tostring(UseCount)
      
      DataUIInstance.PopConfirmPanel(Descrip , UIControl.GoFight , nil , nil , nil)	--确认弹框  
      return
    end

    MapSys.Fight(_Map)
end

function UIControl.GoFight()
   local hufuCount = ItemPackageSys.GetItemCountById(1021)
   if hufuCount==0 then
      DataUIInstance.PopTip("X9")
      return
   end
   if hufuCount < MapSys.NeedHufu then
      DataUIInstance.PopTip("X9")
      return
   end
   MapSys.Fight(UIControl.MapData)
   UIControl.MapData = nil
end

function UIControl.ChangeTeam(_TeamNumber)
   TeamSys.SetPvpTeamType(_TeamNumber)
   if ClinetInfomation.Sta == 0 then
      local UseCount = MapSys.NeedHufu
      local Descrip = UIstring.UseHuFu..tostring(UseCount)
      
      DataUIInstance.PopConfirmPanel(Descrip , UIControl.GoFight , nil , nil , nil)	--确认弹框  
      return
   end
   UIControl.GoFight()
end

function UIControl:ChangeTeamGuide()
   TeamSys.SetPvpTeamType(1)
   MapSys.Fight(UIControl.MapData)
   UIControl.MapData = nil
end

function UIControl:OpenWorldMap()               --开启世界地图 
   local _Pass = SystemOpenSys.IsOpen(118)
    if _Pass==false then
      return
   end 

   local _GoInWorldTime = TimeControl.GetTime("GoInWorld")
   if _GoInWorldTime~=nil then
      if _GoInWorldTime > 0 then
         DataUIInstance.PopTip("Y4")
         return
      end
   end

   if ClinetInfomation.MyOwner==0 then
      DataUIInstance.PopTip("T9")
      return
   end

   if ClinetInfomation.GetMyGuaShuaiHeroImg()==nil then
      DataUIInstance.PopTip("Z8")
      return
   end

   LoadingPanel.OpenChangeScenePanel()
   WorldMapSys.CreateCityNodes()
   PlayerControl.InitSome()  
   GameMain.SocketTestCase() 
	
end

function UIControl:OpenWorldMapEvent(CB)
   GameMain.WorldMapSys.gameObject:SetActive(true)
   GameMain.TeamMakeSys.gameObject:SetActive(false)    
   DataUIInstance.OpenWorldMap(CB)   
end

function UIControl:OpenTeamMake(CB)
   local _Pass = SystemOpenSys.IsOpen(108)
   if _Pass==false then
      return
   end
   LoadingPanel.OpenChangeScenePanel()
   GameMain.WorldMapSys.gameObject:SetActive(false)
   GameMain.TeamMakeSys.gameObject:SetActive(true)
   TeamMakeSys.InitPonts()
   TeamSys.TeamSysType = 1
   DataUIInstance.CreateMakeTeam(CB)
end


function UIControl:OpenJJCTeamMake()
   GameMain.WorldMapSys.gameObject:SetActive(false)
   GameMain.TeamMakeSys.gameObject:SetActive(true)
   TeamMakeSys.InitPonts()
   TeamSys.TeamSysType = 2
   DataUIInstance.CreateMakeTeam()
end

function UIControl:test()
  -- SummonSys.SummonCard(1)
  -- SummonSys.SummonGetCard(30704)
  SummonSys.SummonStoreInit()
end

UIControl.Diamond = nil
UIControl.Money = nil
UIControl.Fight = nil
UIControl.Reputation = nil
function UIControl:SetClinetInfo()
  if UIControl.Diamond==nil then
     UIControl.Diamond = UIControl.UIControlGob.transform:FindChild("Camera"):FindChild("AnchorTop"):FindChild("Diamond"):FindChild("Num"):GetComponent("UILabel")
     UIControl.Money = UIControl.UIControlGob.transform:FindChild("Camera"):FindChild("AnchorTop"):FindChild("Coin"):FindChild("Num"):GetComponent("UILabel")
     UIControl.Reputation = UIControl.UIControlGob.transform:FindChild("Camera"):FindChild("AnchorTop"):FindChild("YuPei"):FindChild("Num"):GetComponent("UILabel")
  end
  if UIControl.Diamond~=nil then
     if ClinetInfomation.GetDiamond()~=nil then
     UIControl.Diamond.text = GameMain.ConvertNumStr(ClinetInfomation.GetDiamond())
     UIControl.Money.text = GameMain.ConvertNumStr(ClinetInfomation.GetCoin())
	 UIControl.Reputation.text = GameMain.ConvertNumStr(ClinetInfomation.GetReputation())
     end
  end
  this:ShowFirstRechargeInfo()
end

function UIControl:SetFight(_Fight)
   if UIControl.Fight==nil then
      UIControl.Fight = UIControl.UIControlGob.transform:FindChild("Camera"):FindChild("AnchorTop"):FindChild("Fight"):FindChild("Num"):GetComponent("UILabel")
   end
   UIControl.Fight.text = tostring(_Fight)
end

UIControl.NowMap = nil
function UIControl:SetNowMap()
   if UIControl.NowMap==nil then
      UIControl.NowMap = UIControl.UIControlGob.transform:FindChild("Camera"):FindChild("OutSideUIList"):FindChild("AnchorBottomRight/RightDownView/Grid"):FindChild("MapButton"):FindChild("Map"):GetComponent("UILabel")
   end
   if MapSys.NowChapter~=nil and MapSys.NowMap~=nil then
      UIControl.NowMap.text = UIstring.NoPoint..tostring((MapSys.NowChapter - 1) * 10 +MapSys.NowMap)..UIstring.Map
   end
end

UIControl.NowSta = nil
function UIControl:SetSta()
   if UIControl.NowSta==nil then
      UIControl.NowSta = UIControl.UIControlGob.transform:FindChild("Camera"):FindChild("OutSideUIList"):FindChild("AnchorBottomRight/RightDownView/Grid"):FindChild("ZhengZhan"):FindChild("Sta"):GetComponent("UILabel")
   end
   UIControl.NowSta.text = tostring(ClinetInfomation.Sta)
end

UIControl.HeroInfoImg = nil

UIControl.HeroInfoFg = nil
function UIControl:ShowHeroInfo()
	if UIControl.HeroInfoImg ==nil then
		local heroInfo = UIControl.UIControlGob.transform:FindChild("Camera"):FindChild("AnchorTopLeft"):FindChild("HeadInfo")
		UIControl.HeroInfoImg = heroInfo.transform:FindChild("HeadImg"):GetComponent("UISprite")
		UIControl.HeroInfoFg = heroInfo.transform:FindChild("FG"):GetComponent("UISprite")
	end
	local data = HeroPackageSys.GetOneHeroBy_UUID(ClinetInfomation.GuaShuaiUUID)
    if data ~=nil then
	   AtlasMsg.SetAtlas( UIControl.HeroInfoImg,data.AtlasName , data.SpriteName)
	   UIControl.HeroInfoFg.spriteName = UIstring.ItemFg[data.quality]
    end
	this:ShowPlayerName()
end

UIControl.HeroInfoName = nil
UIControl.VipLevel = nil
UIControl.Lvl = nil
UIControl.CountryImg = nil
UIControl.ExpImg = nil
function UIControl:ShowPlayerName()
	if UIControl.HeroInfoName == nil then
		local playerInfo = UIControl.UIControlGob.transform:FindChild("Camera"):FindChild("AnchorTopLeft"):FindChild("PlayerState")
		UIControl.HeroInfoName = playerInfo.transform:FindChild("StateWord"):GetComponent("UILabel")
		UIControl.VipLevel = playerInfo.transform:FindChild("vip"):GetComponent("UILabel")
		UIControl.CountryImg = playerInfo.transform:FindChild("country"):GetComponent("UISprite")
        UIControl.Lvl = playerInfo.transform:FindChild("Lvl"):GetComponent("UILabel")
        UIControl.ExpImg = playerInfo.transform:FindChild("exp"):GetComponent("UISlider")
	end
	UIControl.HeroInfoName.text = ClinetInfomation.Name
	UIControl.VipLevel.text = "V" .. VipSys.VipLevel
    UIControl.Lvl.text = "Lv."..ClinetInfomation.Lvl
	UIControl.CountryImg.spriteName = UIstring.OwnerShipImg[ClinetInfomation.MyOwner]
    if ClinetInfomation.Lvl ~= 0  then
		local playerExp = PlayerExpConfig.GetPlayerExpConfig(ClinetInfomation.Lvl)
		if playerExp ~= nil then
			local delExp = ClinetInfomation.Exp - playerExp.AllExp
			UIControl.ExpImg.value = delExp / playerExp.Exp
		end
	end
end

function UIControl:SetOutSideUIList(_Type)
    if _Type==false then
       UIControl.OutSideUIList.gameObject.transform.localScale = Vector3(0 , 0 , 0)
    elseif _Type==true then
       UIControl.OutSideUIList.gameObject.transform.localScale = Vector3(1 , 1 , 1)
    end
end

function UIControl:SetAnchorTop(_Type)
    if _Type==false then
       UIControl.UIControlGob.transform:FindChild("Camera"):FindChild("AnchorTop").gameObject.transform.localScale = Vector3(0 , 0 , 0)
    elseif _Type==true then
       UIControl.UIControlGob.transform:FindChild("Camera"):FindChild("AnchorTop").gameObject.transform.localScale = Vector3(1 , 1 , 1)
    end
end

function UIControl:SetAnchorTopLeft(_Type)
   if _Type==false then
       UIControl.UIControlGob.transform:FindChild("Camera"):FindChild("AnchorTopLeft").gameObject.transform.localScale = Vector3(0 , 0 , 0)
    elseif _Type==true then
       UIControl.UIControlGob.transform:FindChild("Camera"):FindChild("AnchorTopLeft").gameObject.transform.localScale = Vector3(1 , 1 , 1)
    end
end

UIControl.OnLineTitle = nil
UIControl.OnLineTxt = nil

function UIControl:ShowOnLineInfo()
	if UIControl.OnLineTitle == nil then
		UIControl.OnLineTitle = UIControl.UIControlGob.transform:FindChild("Camera"):FindChild("OutSideUIList/AnchorTopRight/Grid3"):FindChild("OnLine/WordPic")
	end	
	if UIControl.OnLineTxt == nil then
		UIControl.OnLineTxt = UIControl.UIControlGob.transform:FindChild("Camera"):FindChild("OutSideUIList/AnchorTopRight/Grid3"):FindChild("OnLine/Label").transform:GetComponent("UILabel")
	end
	local time = TimeControl.GetTime("OnLineTimeDel")
	if time == nil then
		UIControl.OnLineTxt.text = "已领完"
	else
		GameMain.AddUpdateLua(this.UpdateTime)
	end
end

function UIControl:UpdateTime()
	local time = TimeControl.GetTime("OnLineTimeDel")
	if time<=0 then
		if UIControl.OnLineTxt == nil then
			GameMain.DelUpdateLua(this.UpdateTime)
			return
		end
		UIControl.OnLineTxt.text = "可领取"
        this:OpenTip(true , "Time")
		GameMain.DelUpdateLua(this.UpdateTime)
	else
		if UIControl.OnLineTxt == nil then
			GameMain.DelUpdateLua(this.UpdateTime)
			return
		end
		UIControl.OnLineTxt.text = TimeControl.GetTimeString(time)
	end
end

--UIControl.VipSpecialBtn = nil
UIControl.VipSpecialOneBtn = nil
UIControl.VipSpecialTwoBtn = nil
function UIControl:ShowVipSpecailInfo()
	if UIControl.VipSpecialOneBtn == nil then
		UIControl.VipSpecialOneBtn = UIControl.UIControlGob.transform:FindChild("Camera"):FindChild("OutSideUIList/AnchorBottom/VipSpecialOne")
		UIControl.VipSpecialTwoBtn = UIControl.UIControlGob.transform:FindChild("Camera"):FindChild("OutSideUIList/AnchorBottom/VipSpecialTwo")
		
	end
	if GameMain.IOSTest == true then
		GameMain.OpenObj(UIControl.VipSpecialOneBtn)
		GameMain.OpenObj(UIControl.VipSpecialTwoBtn)
	else
		GameMain.CloseObj(UIControl.VipSpecialOneBtn)
		GameMain.CloseObj(UIControl.VipSpecialTwoBtn)
	end
--	if UIControl.VipSpecialBtn == nil then
--		UIControl.VipSpecialBtn = UIControl.UIControlGob.transform:FindChild("Camera"):FindChild("AnchorTopLeft/PlayerState/VipSpecialBtn")
--	end
--	if GameMain.IOSTest == true then
--		GameMain.CloseObj(UIControl.VipSpecialBtn)
--		return
--	end
--	local isOpen = VipSpecailSys.IsShowOpen()
--	if isOpen == false then
--		GameMain.CloseObj(UIControl.VipSpecialBtn)
--	else
--		GameMain.OpenObj(UIControl.VipSpecialBtn)
--	end
end

UIControl.SysTime = nil
--UIControl.BattlerySlider = nil
--UIControl.Wifi = nil
--UIControl.LiuLiang = nil
function UIControl:ShowSysTime()
	if UIControl.SysTime == nil then
		UIControl.SysTime = UIControl.UIControlGob.transform:FindChild("Camera"):FindChild("AnchorTopLeft/PlayerState/sysTime"):GetComponent("UILabel")
--		UIControl.BattlerySlider = UIControl.UIControlGob.transform:FindChild("Camera"):FindChild("AnchorTopLeft/PlayerState/battlery"):GetComponent("UISlider")
--		UIControl.Wifi = UIControl.UIControlGob.transform:FindChild("Camera"):FindChild("AnchorTopLeft/PlayerState/wifi")
--		UIControl.LiuLiang = UIControl.UIControlGob.transform:FindChild("Camera"):FindChild("AnchorTopLeft/PlayerState/liuliang")
	end
	this:ShowWifiTimeInfo()
	TimeControl.LoginTime(1,"SysTime")
	GameMain.AddUpdateLua(this.UpDateSysTime)
end

function UIControl.UpDateSysTime()
	local time = TimeControl.GetTime("SysTime")
	if time<=0 then
		TimeControl.LoginTime(1,"SysTime")
		this:ShowWifiTimeInfo()
	end
end

function UIControl:ShowWifiTimeInfo()
	local date=lgNoDelCsFun.Ins:GetSysTime()
	UIControl.SysTime.text = date
--	local netState = GameMain.GetNetState()
--	if netState == 0 then
--		GameMain.CloseObj(UIControl.Wifi)
--		GameMain.CloseObj(UIControl.LiuLiang)
--	end
--	if netState == 1 then
--		GameMain.CloseObj(UIControl.Wifi)
--		GameMain.OpenObj(UIControl.LiuLiang)
--	end
--	if netState == 2 then
--		GameMain.OpenObj(UIControl.Wifi)
--		GameMain.CloseObj(UIControl.LiuLiang)
--	end
--	local battery = GameMain.GetBattery()
--	if battery == -1 then
--		GameMain.CloseObj(UIControl.BattlerySlider)
--	else
--		GameMain.OpenObj(UIControl.BattlerySlider)
--		UIControl.BattlerySlider.value = battery
--	end
end

--广播
UIControl.BoardGob = nil
UIControl.BoardContent = nil
UIControl.BoardState = false                                    --没有广播了
UIControl.BoardTime = 5
UIControl.BoardNowTime = 0
function UIControl:InitBoradCast()

   if UIControl.BoardGob==nil then
      UIControl.BoardGob = UIControl.UIControlGob.transform:FindChild("Camera/AnchorCenter/BoardCastOne")
      UIControl.BoardContent = UIControl.BoardGob.transform:FindChild("BoardCastPanel/CastContent")
   end

   if UIControl.BoardGob==nil then
      return
   end
   
   if UIControl.BoardState == true then
      return
   end

   UIControl.BoardGob.gameObject:SetActive(true)
   local _Cast = BoardCastSys.PopCast()

   if _Cast~=nil then
      UIControl.BoardContent:GetComponent("UILabel").text = _Cast.Text
      UIControl.BoardContent.localPosition = Vector3(370 , -2 , 0)
      GameMain.AddUpdateLua(this.UpdateBoard)
      UIControl.BoardState = true
   else
      UIControl.BoardGob.gameObject:SetActive(false)
      GameMain.DelUpdateLua(this.UpdateBoard)
      UIControl.BoardState = false
   end

end

function UIControl.UpdateBoard(dt)
   if UIControl.BoardState==true then
      UIControl.BoardNowTime = UIControl.BoardNowTime + dt
      if UIControl.BoardNowTime <= UIControl.BoardTime then
         local _beilv = UIControl.BoardNowTime/UIControl.BoardTime
         local x = Mathf.Lerp(300 , -930 , _beilv)
         UIControl.BoardContent.localPosition = Vector3(x , -2 , 0)
      else
         local _Cast = BoardCastSys.PopCast()
         if _Cast~=nil then
            UIControl.BoardContent.localPosition = Vector3(370 , -2 , 0)
            UIControl.BoardNowTime = 0
         else
            UIControl.BoardGob.gameObject:SetActive(false)
            UIControl.BoardState = false
         end
      end
   end
end

UIControl.MissNotice = nil
UIControl.LoginNotice = nil
UIControl.SignNotice = nil
UIControl.TimeNotice = nil
UIControl.TechNotice = nil
function UIControl:OpenTip(_IsOpen , _Type)
   if UIControl.UIControlGob==nil then
      return
   end
   if _Type == "Mission" then                                                           --任务
      if MainGameUI.PanelOpenName == "UIMission" then
         return
      end
      if UIControl.MissNotice == nil then
         UIControl.MissNotice = UIControl.UIControlGob.transform:FindChild("Camera/OutSideUIList/AnchorTopRight/Mission/Notice").gameObject
      end
      if _IsOpen==true then
         if UIControl.MissNotice.activeInHierarchy==true then
            return 
         end
      end
      UIControl.MissNotice:SetActive(_IsOpen)
   elseif _Type == "Login" then                                                         --登陆
      if MainGameUI.PanelOpenName == "UISevenDaySign" then
         return
      end
      if UIControl.LoginNotice == nil then
         UIControl.LoginNotice = UIControl.UIControlGob.transform:FindChild("Camera/OutSideUIList/AnchorTopRight/Grid3/SevenSignBtn/Notice").gameObject
      end
      if _IsOpen==true then
          if UIControl.LoginNotice.activeInHierarchy==true then
             return 
          end
      end
      UIControl.LoginNotice:SetActive(_IsOpen)
   elseif _Type == "Sign" then                                                                --签到 
      if MainGameUI.PanelOpenName == "UIEveryDaySign" then
         return
      end    
      if UIControl.SignNotice == nil then                                             
         UIControl.SignNotice = UIControl.UIControlGob.transform:FindChild("Camera/OutSideUIList/AnchorTopRight/Grid3/Sign/Notice").gameObject
      end
      if _IsOpen==true then
          if UIControl.SignNotice.activeInHierarchy==true then
             return 
          end 
      end
      UIControl.SignNotice:SetActive(_IsOpen)
   elseif _Type == "Time" then                                                          --时间奖励
      if MainGameUI.PanelOpenName == "UIOnLineReward" then
         return
      end   
      if UIControl.TimeNotice == nil then                                             
         UIControl.TimeNotice = UIControl.UIControlGob.transform:FindChild("Camera/OutSideUIList/AnchorTopRight/Grid3/OnLine/Notice").gameObject
      end
      if _IsOpen==true then
          if UIControl.TimeNotice.activeInHierarchy==true then
             return 
          end  
      end
      UIControl.TimeNotice:SetActive(_IsOpen)

   elseif _Type == "Tech" then                                                          --科技
      if MainGameUI.PanelOpenName == "UITechnology" then
         return
      end     
      if UIControl.TechNotice == nil then                                             
         UIControl.TechNotice = UIControl.UIControlGob.transform:FindChild("Camera/OutSideUIList/AnchorBottom/RightDownView/Grid1/Technology/Notice").gameObject
      end
      if _IsOpen==true then
          if UIControl.TechNotice.activeInHierarchy==true then
             return 
          end
      end
      UIControl.TechNotice:SetActive(_IsOpen)    
   end
end

UIControl.SeventSignBtn = nil
function UIControl:CloseSevenSign()
	if UIControl.SeventSignBtn == nil then
		 UIControl.SeventSignBtn = UIControl.UIControlGob.transform:FindChild("Camera/OutSideUIList/AnchorTopRight/Grid3/SevenSignBtn").gameObject
	end
	GameMain.CloseObj(seventSignBtn)
	this:SetGridListSort()
end

function UIControl:ReleasPanel()
    GameMain.DelUpdateLua(this.UpdateUIPosition)
    GameMain.DelUpdateLua(this.UpDateSysTime)
	UIControl.SeventSignBtn = nil
	UIControl.Chat = nil
	UIControl.SysTime = nil
	UIControl.UIControlGob = nil
	UIControl.AnchorCenter = nil
	UIControl.OutSideUIList = nil
	UIControl.UICamera = nil

	UIControl.Diamond = nil
	UIControl.Money = nil
	UIControl.Fight = nil
	UIControl.Reputation = nil
	UIControl.NowMap = nil
	UIControl.NowSta = nil
	UIControl.HeroInfoImg = nil
    UIControl.ExpImg = nil

	UIControl.HeroInfoFg = nil
    UIControl.HeroInfoName = nil
	UIControl.VipLevel = nil
	UIControl.CountryImg = nil
    UIControl.Lvl = nil

	UIControl.OnLineTitle = nil
	UIControl.OnLineTxt = nil
	UIControl.InitPanel = nil
    UIControl.MainCameraTransForm = nil
    UIControl.Palace = nil
    UIControl.HandBook = nil
    UIControl.TeamMake = nil
    UIControl.Market = nil
    UIControl.HeroBattle = nil
    UIControl.HeroRank = nil
    UIControl.JJC = nil
    UIControl.MainCamera = nil
	UIControl.CountryName = 
	{
		[1] = "蜀",
		[2] = "魏",
		[3] = "吴",
		[4] = "",
	}
--	UIControl.VipSpecialBtn = nil
	UIControl.AnchorTopRightList = nil
	UIControl.RightDownList = nil
	UIControl.RightMediumnList = nil
	UIControl.ClickShift = nil
--    UIControl.BattlerySlider = nil
--	UIControl.Wifi = nil
--	UIControl.LiuLiang = nil
	UIControl.VipSpecialOneBtn = nil
    UIControl.WorldButton = nil
    UIControl.VipSpecialTwoBtn = nil
	GameMain.DelUpdateLua(this.UpdateTime)

    --广播
    UIControl.BoardGob = nil
    UIControl.BoardContent = nil
    UIControl.BoardState = false                                    --没有广播了
    GameMain.DelUpdateLua(this.UpdateBoard)
    UIControl.BoardTime = 5
    UIControl.BoardNowTime = 0
	UIControl.ExpandLabel = nil

    UIControl.MissNotice = nil
    UIControl.LoginNotice = nil
    UIControl.SignNotice = nil
    UIControl.TimeNotice = nil
    UIControl.TechNotice = nil
end

function UIControl:ReleasData()
--	ClinetInfomation.World_id = nil										--主角
--	ClinetInfomation.Name = "nil"                                       
--	ClinetInfomation.MyOwner = 1                                        --1 ， 2 ，3 ，4 蜀 魏 吴 中立
--	ClinetInfomation.PlayerId = nil
--	ClinetInfomation.WorldTime = 0
--	ClinetInfomation.GuaShuaiUUID = nil									--挂帅武将的UUID
--	ClinetInfomation.Player_id = nil									--玩家ID
--	ClinetInfomation.Lvl = 0											--玩家等级
--	ClinetInfomation.VipExp = 0											--vip经验
--	ClinetInfomation.VipLevel = 0											--vip等级
--	ClinetInfomation.Fight = 0                                          --战斗力
--	ClinetInfomation.Honour = 0											--荣誉
--	ClinetInfomation.Feats = 0											--功勋
--	ClinetInfomation.Reputation = 0										--声望
--	ClinetInfomation.Exp = 0											--主角经验
--	ClinetInfomation.powerRank = 0										--战斗力排名
--	ClinetInfomation.compRank = 0										--综合排名
--	ClinetInfomation.featsRewardTimes = 0       
--	ClinetInfomation.goldticket = 0										--金券（用于寄售行）       
--	ClinetInfomation.BuyArmyTime = 0
--	ClinetInfomation.ServeID = "10003"
--	ClinetInfomation.Ip = ""
--	ClinetInfomation.Port = 0
end

return UIControl
