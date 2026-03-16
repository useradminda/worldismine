UIMission = {}
local UIMission = BasePanel:new()
local this = UIMission
UIMission.UIMissionGod = nil
UIMission.TempPanel = nil
UIMission.TempBtn = nil

function UIMission:OpenUI(_PanelName , _LuaName)
   if UIMission.UIMissionGod==nil then
      UIMission.UIMissionGod=MainGameUI.FindPanel("UIMission")
    
   end
   local _UIControlTar = MainGameUI.FindPanelTarget("UIControl")
   if _UIControlTar~=nil then
      _UIControlTar:OpenTip(false , "Mission")
   end
   this:OpenMainPanel()
end


function UIMission:ChangeButton(_Btn)
   if UIMission.TempBtn~=nil then
      UIMission.TempBtn.transform:FindChild("ChoseBtn").transform.localPosition = Vector3(-1000 , 0 , 0)
      UIMission.TempBtn.transform:FindChild("NoChose").transform.localPosition = Vector3(0 , 0 , 0)
   end   

   UIMission.TempBtn = _Btn
   _Btn.transform:FindChild("ChoseBtn").transform.localPosition = Vector3(0 , 0 , 0)
   _Btn.transform:FindChild("NoChose").transform.localPosition = Vector3(-1000 , 0 , 0)
end

function UIMission:OpenPanel(_Panel)
   if _Panel==UIMission.TempPanel then
      return
   end
   if UIMission.TempPanel~=nil then
      UIMission.TempPanel.transform.localPosition = Vector3(0 , 1000 , 0)
   end
   UIMission.TempPanel = _Panel
   UIMission.TempPanel.transform.localPosition = Vector3(0 , 0 , 0)
end


--*****************************日常界面
UIMission.DailyPanel = nil
UIMission.DailyBtn = nil
function UIMission:OpenDailyPanel()                         --打开日常界面
   if UIMission.DailyPanel == nil then
      UIMission.DailyPanel = UIMission.UIMissionGod.transform:FindChild("MissionPanel"):FindChild("DailyPanel")
      UIMission.DailyBtn = UIMission.UIMissionGod.transform:FindChild("DailyBtn")
   end
   this:OpenPanel(UIMission.DailyPanel)
   this:ChangeButton(UIMission.DailyBtn)
   this:GetDailyMissions()
   this:SetActiveProcess()

end

UIMission.DailyMissions = {}
function UIMission:GetDailyMissions()
   for i = 1 , #MissionSys.DailyList , 1 do    
       local _Mission = MissionSys.DailyList[i]
       local _Gob = UIMission.DailyPanel.transform:FindChild("Grid"):FindChild(tostring(i))
       UIMission.DailyMissions[i] = 
       {
           DailyGob = _Gob,
           DailyMission = _Mission,
       }
       this:SetDailyMission(_Gob , _Mission)     
   end
end

function UIMission:ReceiveDailyMission(_Mission , _Index)
    if _Mission.IsFinish == 1 then
--       MissionSys.ReceiveDailyMission(_Mission.Id , _Index)
    else
--      GameMain.Print(_Mission , "mission")
		this:ToEnterTypeSys(_Mission.Type)
    end
end

function UIMission:ToEnterTypeSys(_Type) 
	if _Type == 1 then	----进入战斗
		DataUIInstance.CreateMap()
	end
	if _Type == 2 then	--训练武将
		DataUIInstance.OpenHeroInfo()
		local UIHeroTar = MainGameUI.FindPanelTarget("UIHero")
		if UIHeroTar ~= nil then
			UIHeroTar:ShowHeroTrainPanel()
		end
	end
	if _Type == 3 then	--强化装备
		DataUIInstance.OpenEquip()
		local UIEquipTar = MainGameUI.FindPanelTarget("UIEquip")
		if UIEquipTar ~= nil then
			UIEquipTar:ChangePanelToStrength()
		end
	end
	if _Type == 4 then	--普通征收
		DataUIInstance.OpenCollect()
	end
	if _Type == 5 then	--强行征收
		DataUIInstance.OpenCollect()
	end
	if _Type == 6 then	--初级招募
		DataUIInstance.OpenHireHero()
	end
	if _Type == 7 then	--中级招募
		DataUIInstance.OpenHireHero()
	end
	if _Type == 8 then	--高级招募
		DataUIInstance.OpenHireHero()
	end
	this:CloseMissionPanel()
end

function UIMission:ReflashDaily(_Index)
    this:SetDailyMission(UIMission.DailyMissions[_Index].DailyGob , UIMission.DailyMissions[_Index].DailyMission)
    this:SetActiveProcess()
end

function UIMission:SetDailyMission(_Gob , _Mission)
   _Gob.transform:FindChild("Title"):GetComponent("UILabel").text = _Mission.Descrip
   _Gob.transform:FindChild("Times"):FindChild("Time"):GetComponent("UILabel").text = tostring(_Mission.Process).."/"..tostring(_Mission.Require)

   if _Mission.IsFinish == 0 then
      _Gob.transform:FindChild("Live"):FindChild("Time"):GetComponent("UILabel").text = "+"..tostring(_Mission.TotalAlive)
--      _Gob.transform:FindChild("Go/Move"):GetComponent("UILabel").text = UIstring.R3
	 _Gob.transform:FindChild("Finish").gameObject:SetActive(false)
      _Gob.transform:FindChild("Go").gameObject:SetActive(true)
   elseif _Mission.IsFinish == 1 then
      _Gob.transform:FindChild("Live"):FindChild("Time"):GetComponent("UILabel").text = "+"..tostring(_Mission.TotalAlive)
--      _Gob.transform:FindChild("Go/Move"):GetComponent("UILabel").text = UIstring.R4
	_Gob.transform:FindChild("Finish").gameObject:SetActive(true)
      _Gob.transform:FindChild("Go").gameObject:SetActive(false)
   end

--   if _Mission.IsReceive==0 then                    --
--      _Gob.transform:FindChild("Finish").gameObject:SetActive(false)
--      _Gob.transform:FindChild("Go").gameObject:SetActive(true)
--   elseif _Mission.IsReceive==1 then
--      _Gob.transform:FindChild("Finish").gameObject:SetActive(true)
--      _Gob.transform:FindChild("Go").gameObject:SetActive(false)
--   end

end

UIMission.DailyExpSlider = nil
UIMission.NowDailyLive = 0
function UIMission:SetActiveProcess()
   if UIMission.DailyExpSlider == nil then
      UIMission.DailyExpSlider = UIMission.DailyPanel.transform:FindChild("Today"):FindChild("DailyExp"):GetComponent("UISlider")
      UIMission.NowDailyLive = UIMission.DailyPanel.transform:FindChild("Today"):FindChild("NowDailyLive"):FindChild("NowDaily"):GetComponent("UILabel")
   end
   local _NowTotalActive = MissionSys.GetTotalActive()
   UIMission.DailyExpSlider.value = MissionSys.NowActive / _NowTotalActive
   
   UIMission.NowDailyLive.text = tostring(MissionSys.NowActive)
   this:SetActiveBox()
end

function UIMission:SetActiveBox()
   local _NowIndex = MissionDataSys.GetActiveIndex()            --当前的活跃度设置

   for i = 1 , 5 , 1 do
       UIMission.DailyPanel.transform:FindChild("Today"):FindChild("Grid"):FindChild(tostring(i)):FindChild("Img").gameObject:SetActive(true)
       UIMission.DailyPanel.transform:FindChild("Today"):FindChild("Grid"):FindChild(tostring(i)):FindChild("CanImg").gameObject:SetActive(false)
       UIMission.DailyPanel.transform:FindChild("Today"):FindChild("Grid"):FindChild(tostring(i)):FindChild("HaveImg").gameObject:SetActive(false)

       if i <= _NowIndex then
          UIMission.DailyPanel.transform:FindChild("Today"):FindChild("Grid"):FindChild(tostring(i)):FindChild("Word"):GetComponent("UILabel").text = UIstring.Green..UIstring.T1
          UIMission.DailyPanel.transform:FindChild("Today"):FindChild("Grid"):FindChild(tostring(i)):FindChild("Img").gameObject:SetActive(false)
          UIMission.DailyPanel.transform:FindChild("Today"):FindChild("Grid"):FindChild(tostring(i)):FindChild("CanImg").gameObject:SetActive(true)
          UIMission.DailyPanel.transform:FindChild("Today"):FindChild("Grid"):FindChild(tostring(i)):FindChild("HaveImg").gameObject:SetActive(false)
          local _Active = MissionDataSys.GetActiveRewardByIndex(i)   
          for j = 1 , #MissionSys.NowHaveReceiveActive , 1 do
              if _Active.Active == MissionSys.NowHaveReceiveActive[j] then
                 UIMission.DailyPanel.transform:FindChild("Today"):FindChild("Grid"):FindChild(tostring(i)):FindChild("Word"):GetComponent("UILabel").text = UIstring.White..UIstring.T2
                 UIMission.DailyPanel.transform:FindChild("Today"):FindChild("Grid"):FindChild(tostring(i)):FindChild("Img").gameObject:SetActive(false)
                 UIMission.DailyPanel.transform:FindChild("Today"):FindChild("Grid"):FindChild(tostring(i)):FindChild("CanImg").gameObject:SetActive(false)
                 UIMission.DailyPanel.transform:FindChild("Today"):FindChild("Grid"):FindChild(tostring(i)):FindChild("HaveImg").gameObject:SetActive(true)
              end
          end
       else
          local _Need = 0
          if i == 1 then
             _Need = 10
          elseif i == 2 then
             _Need = 30
          elseif i == 3 then
             _Need = 50
          elseif i == 4 then
             _Need = 70
          elseif i == 5 then
             _Need = 100
          end
          UIMission.DailyPanel.transform:FindChild("Today"):FindChild("Grid"):FindChild(tostring(i)):FindChild("Word"):GetComponent("UILabel").text = UIstring.White..tostring(_Need)..UIstring.RewardBoxGet         
       end
   end
end

UIMission.TempIndex = 0
function UIMission:ReceiveActiveReward(_Index)
    UIMission.TempIndex  = _Index
    local _NeedActive = MissionDataSys.GetActiveRewardByIndex(_Index).Active
	local active = MissionSys.NowActive
	if active < _NeedActive then
		--DataUIInstance.PopTip(UIstring.MissionCanNotRec)
        this:ShowReward(MissionDataSys.GetActiveRewardByIndex(_Index).RewardId)
		return
	end
   
    local _Pass = true
    for key , value in pairs(MissionSys.NowHaveReceiveActive) do
        if value == _NeedActive then
           _Pass = false
        end
    end

	if _Pass == false then
		DataUIInstance.PopTip(UIstring.TodayMissionHasRec)
		return
	end
	
    MissionSys.ReceiveActiveReward(_NeedActive)
end

function UIMission:GetActiveRewardCallBack()
   local _RewardString = RewardConfig.GetRewardConfig(MissionDataSys.GetActiveRewardByIndex(UIMission.TempIndex).RewardId).RewardString
   local _RewardContent = RewardContentSys.GetRewardResourceString(_RewardString)
   DataUIInstance.OpenRewards(_RewardContent.Items)
end

UIMission.ShowRewardPanel = nil
UIMission.RewardItms = {}
function UIMission:ShowReward(RewardId)
   if UIMission.ShowRewardPanel==nil then
      UIMission.ShowRewardPanel = UIMission.UIMissionGod.transform:FindChild("ShowPanel")
   end
   UIMission.ShowRewardPanel.gameObject:SetActive(true)
   local _Reward = RewardConfig.GetRewardConfig(RewardId)
  
   local _RewardContent = RewardContentSys.GetRewardResourceString(_Reward.RewardString)

   if #UIMission.RewardItms==0 then
      for i = 1 , 6 , 1 do
          UIMission.RewardItms[i] = UIMission.ShowRewardPanel.transform:FindChild("RewardsPanel/RewardsGrid"):FindChild(tostring(i))
      end
   end

   for i = 1 , 6 , 1 do
       if i <= #_RewardContent.Items then
          UIMission.RewardItms[i].gameObject:SetActive(true)
          local _Img = UIMission.RewardItms[i].transform:FindChild("Img"):GetComponent("UISprite")
          AtlasMsg.SetAtlas(_Img , _RewardContent.Items[i].AtlasName , _RewardContent.Items[i].SpriteName)
          local _Fg = UIMission.RewardItms[i].transform:FindChild("FG"):GetComponent("UISprite")
          AtlasMsg.SetAtlas(_Fg , UIstring.QualityAtlasName , UIstring.ItemFg[_RewardContent.Items[i].Quality])
          local _Bg = UIMission.RewardItms[i].transform:FindChild("BG"):GetComponent("UISprite")
          AtlasMsg.SetAtlas(_Bg , UIstring.QualityBGAtlasName , UIstring.ItemFg[_RewardContent.Items[i].Quality])
          UIMission.RewardItms[i].transform:FindChild("count"):GetComponent("UILabel").text = tostring(_RewardContent.Items[i].Count)
       else
          UIMission.RewardItms[i].gameObject:SetActive(false)
       end
   end

   UIMission.ShowRewardPanel.transform:FindChild("RewardsPanel/RewardsGrid"):GetComponent("UIGrid").enabled = true
   UIMission.ShowRewardPanel.transform:FindChild("RewardsPanel/RewardsGrid"):GetComponent("UIGrid"):Reposition()
end

function UIMission:CloseShowReward()
   if UIMission.ShowRewardPanel~=nil then
      UIMission.ShowRewardPanel.gameObject:SetActive(false)
   end     
end

--**********************主线界面
UIMission.MainPanel = nil
UIMission.MainBtn = nil
function UIMission:OpenMainPanel()                      --打开主线界面
   if UIMission.MainPanel == nil then
      UIMission.MainPanel = UIMission.UIMissionGod.transform:FindChild("MissionPanel"):FindChild("MainPanel")
      UIMission.MainBtn = UIMission.UIMissionGod.transform:FindChild("MainBtn")
   end
   this:OpenPanel(UIMission.MainPanel)
   this:ChangeButton(UIMission.MainBtn)  
   this:GetMainMissions()

end

UIMission.MainMissions = {}
function UIMission:GetMainMissions()
   for i = 1 , #MissionSys.MainList , 1 do    
       local _Mission = MissionSys.MainList[i]
      -- GameMain.Print(_Mission)
       local _Gob = UIMission.MainPanel.transform:FindChild("Grid"):FindChild(tostring(i))
       UIMission.MainMissions[i] = 
       {
           MainGob = _Gob,
           MainMission = _Mission,
       }
       this:SetMainMission(_Gob , _Mission)    
   end
end

UIMission.TempReward = nil
function UIMission:ReceiveMainMission(_Mission , _Index)
  -- GameMain.Print(_Mission)
   local rewardData = RewardConfig.GetRewardConfig(tonumber(_Mission.Reward))
   local jsonItems = RewardContentSys.GetRewardResourceString(rewardData.RewardString)
   local dataList = jsonItems.Items
   UIMission.TempReward = dataList
   

   if _Mission.IsFinish==1 then
      MissionSys.ReceiveMainMission(_Mission.Id , _Index)
   else
	
   end
end

function UIMission:ReflashMainMission(_Index)
   
   DataUIInstance.OpenRewards(UIMission.TempReward)
   UIMission.MainMissions[_Index].MainMission = MissionSys.MainList[_Index]
   --GameMain.Print(UIMission.MainMissions[_Index].MainMission)
   this:SetMainMission(UIMission.MainMissions[_Index].MainGob , UIMission.MainMissions[_Index].MainMission)
end

function UIMission:SetMainMission(_Gob , _Mission)
  -- GameMain.Print(_Mission)
   local NeedMap  = 0
   if _Mission.Type == 1 then
      _Gob.transform:FindChild("MissionType"):GetComponent("UISprite").spriteName = "zhu"
   else
		_Gob.transform:FindChild("MissionType"):GetComponent("UISprite").spriteName = "zhi"
   end
   if _Mission.Class == 1 then
      local _RequireMapId = _Mission.Require
      
      local _Map = MapDataSys.GetMapByDbId(_RequireMapId)
      local _ChaptId = _Map.Chapter_Id
      local _Chapter = MapDataSys.GetChapterByDbId(_ChaptId)
      local _ChapNum = _Chapter.Turn
      local _MapNum = _Map.Turn
      local _TempNeedMap = (_ChapNum - 1)*10 + _MapNum
      local _TempNowMap = (MapSys.NowChapter - 1)*10 + MapSys.NowMap
      NeedMap = _TempNeedMap - _TempNowMap
      local _Descrips = GameMain.StringSplit(_Mission.Descrip , ",")
      if NeedMap > 0 then        
         _Gob.transform:FindChild("Target"):GetComponent("UILabel").text = UIstring.NormalWordColor.._Descrips[1].."[-]"..UIstring.Red..tostring(NeedMap + 1).."[-]"..UIstring.NormalWordColor.._Descrips[2]
      else
         _Gob.transform:FindChild("Target"):GetComponent("UILabel").text = UIstring.NormalWordColor.._Descrips[1]..tostring(0).._Descrips[2].."[-]"
      end     
   else
       _Gob.transform:FindChild("Title"):GetComponent("UILabel").text = _Mission.Name..":"
       _Gob.transform:FindChild("Target"):GetComponent("UILabel").text = UIstring.NormalWordColor.._Mission.Descrip.."[-]"
      
   end
	 if _Mission.IsFinish == 0 then                                   --未完成
          _Gob.transform:FindChild("NoButton").gameObject:SetActive(true)
          _Gob.transform:FindChild("ReceiveButton").gameObject:SetActive(false)
          _Gob.transform:FindChild("Finish").gameObject:SetActive(false)
       else
          _Gob.transform:FindChild("NoButton").gameObject:SetActive(false)
          _Gob.transform:FindChild("ReceiveButton").gameObject:SetActive(true)
         -- _Gob.transform:FindChild("ReceiveButton/Move"):GetComponent("UILabel").text = UIstring.R4
          _Gob.transform:FindChild("Finish").gameObject:SetActive(true)
       end

	local rewardData = RewardConfig.GetRewardConfig(tonumber(_Mission.Reward))
	local jsonItems = RewardContentSys.GetRewardResourceString(rewardData.RewardString)
	local dataList = jsonItems.Items

	local rewardGodList = _Gob.transform:FindChild("RewardGrids")
	this:ShowMissonItemRewardInfo(dataList , rewardGodList)
	
    local _FG = _Gob.transform:FindChild("itemIcon/FG"):GetComponent("UISprite")
    AtlasMsg.SetAtlas(_FG , UIstring.QualityAtlasName , UIstring.ItemFg[dataList[1].Quality])
    local _BG = _Gob.transform:FindChild("itemIcon/BG"):GetComponent("UISprite")
    AtlasMsg.SetAtlas(_BG , UIstring.QualityBGAtlasName , UIstring.ItemFg[dataList[1].Quality])
    local _Img = _Gob.transform:FindChild("itemIcon/Img"):GetComponent("UISprite")
    AtlasMsg.SetAtlas(_Img , dataList[1].AtlasName  , dataList[1].SpriteName)
end

function UIMission:ShowMissonItemRewardInfo(_DataList , _GodList)
	for i=1,4,1  do
		local data = _DataList[i]
		local god = _GodList.transform:FindChild(tostring(i))
		if data == nil then
			GameMain.CloseObj(god)
		else
			GameMain.OpenObj(god)
			local img = god.transform:FindChild("FG"):GetComponent("UISprite")
			local num = god.transform:FindChild("Num"):GetComponent("UILabel")
			AtlasMsg.SetAtlas(img , data.AtlasName , data.SpriteName)
			num.text = tostring(data.Count)
		end
	end
	
end

function UIMission:CloseMissionPanel()
   if UIMission.UIMissionGod~=nil then
      UIMission.UIMissionGod.gameObject:SetActive(false)
   end
end

function UIMission:UIHand(_LuaName , _Gob)
   MusicManagerSys.ButtonClick()
   if _Gob.name == "DailyBtn" then
      this:OpenDailyPanel()
   elseif _Gob.name == "MainBtn" then
      this:OpenMainPanel()
   elseif _Gob.name == "closeBtn" then
      this:CloseMissionPanel()
   else
      local _Index = tonumber(_Gob.transform.parent.name)
      if _Index~=nil then   
          if _Gob.transform.parent.parent.parent.name == "MainPanel" then
             local _Mission = UIMission.MainMissions[_Index].MainMission
             this:ReceiveMainMission(_Mission , _Index)
          elseif _Gob.transform.parent.parent.parent.name == "DailyPanel" then
             local _Mission = UIMission.DailyMissions[_Index].DailyMission
             this:ReceiveDailyMission(_Mission , _Index)        
          end
      end
      if _Gob.transform.parent.parent.name == "Today" then
         local _Index = tonumber(_Gob.name)
         if _Index~=nil then
            this:ReceiveActiveReward(_Index) 
         end
      end
   end
   if _Gob.name == "ShowPanel" then
      this:CloseShowReward()
   end
end

function UIMission:ReleasPanel()               									 --退出界面时释放和界面初始化
    UIMission.UIMissionGod = nil
    UIMission.TempPanel = nil
    UIMission.TempBtn = nil

    UIMission.DailyPanel = nil
    UIMission.DailyBtn = nil
    UIMission.DailyMissions = {}
    UIMission.DailyExpSlider = nil
    UIMission.NowDailyLive = 0
    UIMission.ShowRewardPanel = nil
    UIMission.RewardItms = {}

    UIMission.MainPanel = nil
    UIMission.MainBtn = nil
    UIMission.MainMissions = {}
    UIMission.TempReward = nil
end

function UIMission:ReleasData()
	MissionSys.DailyList = {}
	MissionSys.MainList = {}
	MissionSys.NowActive = 0
	MissionSys.TotalActive = 0
	MissionSys.NowHaveReceiveActive = {}     --当前领了哪几个宝箱了


end

return UIMission