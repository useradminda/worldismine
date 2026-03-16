WorldMapEventSys = {}
WorldMapEventSys.EventType = 0                                              --4天降祥瑞          
WorldMapEventSys.EventData = nil                                            --数据库事件Data
WorldMapEventSys.EventConfigID = 0
WorldMapEventSys.CityId = 0                                                 --屎黄降临的城市图标

WorldMapEventSys.RewardCity = 0                                             --物品刷新到的城市
WorldMapEventSys.Reward = 0                                                 --刷新到城池的物品
WorldMapEventSys.RewardEndTime = 0
WorldMapEventSys.EventOpen = 0
WorldMapEventSys.IsGetWinReward = 0                                         --0 可以领取 1 已经领取2 不可取 胜利奖励
WorldMapEventSys.IsGetOhterReward = 0                                       --0 可以领取 1 已经领取2 不可取 其他奖励
WorldMapEventSys.DemageRankList = {}                                        --输出排行
WorldMapEventSys.MyDemage = 0
WorldMapEventSys.MyRank = 0
WorldMapEventSys.ScoreRankList = {}                                         --积分排行 蜀 魏 吴
WorldMapEventSys.LeftCityNum = 0                                            --剩余城池积分
WorldMapEventSys.DefenceCity = 0                                            --防守的阵营

WorldMapEventSys.NowArmyNum = 0                                             --当前兵力
WorldMapEventSys.TotalArmyNum = 0                                           --最高兵力
WorldMapEventSys.NowTeam = 0                                                --当前队伍

function WorldMapEventSys.SetReward(_RewardCityId , _Reward)       --道具发放在哪个城池
    --local ItemData = RewardContentSys.GetRewardStringType(RewardConfig.GetRewardConfig(_RewardId).RewardString)
    WorldMapEventSys.Reward = _Reward

    local data = 
    {
        RewardCityId  = _RewardCityId,
       -- Reward = ItemData,  
    }          
    WorldMapEventSys.RewardCity = data        
    local _UIWroldMapTar = MainGameUI.FindPanelTarget("UIWorldMap")
    if _UIWroldMapTar~=nil then
       _UIWroldMapTar:RewardOnCity()
    end
    return data
end

function WorldMapEventSys.SetEventData(_Id , _IsOpen , _IsGetWinReward , _IsGetOtherReward , _EndTime , _CityId)         --设置当前活动
    WorldMapEventSys.EventData = WorldActivityConfig.GetWorldActivityConfig(_Id)   
    WorldMapEventSys.EventConfigID = _Id  
    WorldMapEventSys.EventType = WorldMapEventSys.EventData.ActivityType
    WorldMapEventSys.RewardEndTime = _EndTime   
    WorldMapEventSys.EventOpen = _IsOpen
    WorldMapEventSys.IsGetWinReward = _IsGetWinReward
    WorldMapEventSys.IsGetOhterReward = _IsGetOtherReward 
    WorldMapEventSys.CityId = _CityId

    local UIWorldMapTar = MainGameUI.FindPanelTarget("UIWorldMap")
    if UIWorldMapTar~=nil then
       if _IsOpen==1 then              --开启
          UIWorldMapTar:SetActivityTitle(WorldMapEventSys.EventData.Name)
          DataUIInstance.PopTip(WorldMapEventSys.EventData.Name.."开启了")
       elseif _IsOpen==0 then          --关闭
          UIWorldMapTar:SetActivityTitle(WorldMapEventSys.EventData.Name)
          DataUIInstance.PopTip(WorldMapEventSys.EventData.Name.."关闭了 进入领奖时间")
       end
       UIWorldMapTar:Open_CloseEvent(_IsOpen)
    end
end

function WorldMapEventSys.GetReward(_ConfigId , _RewardId)           --获得奖励道具
    if _ConfigId==0 then                                                    --天降祥瑞
        local _UIWroldMapTar = MainGameUI.FindPanelTarget("UIWorldMap")
        if _UIWroldMapTar~=nil then
           _UIWroldMapTar:HideRewardImg()
        end
    elseif _ConfigId==203 then                                        --抽奖奖励
        local _UIWroldMapTar = MainGameUI.FindPanelTarget("UIWorldMap")
        if _UIWroldMapTar~=nil then
           local _Key = tostring(_ConfigId).."_"..tostring(PlayerControl.TheMeCharacter.NowNode.NodeId)
           _UIWroldMapTar:StartDraw(_Key , _RewardId)
        end
        local _EventKey = tostring(_ConfigId).."_"..tostring(PlayerControl.TheMeCharacter.NowNode.NodeId)
        WorldMapEventSys.DeleteEvent(_EventKey) 
    else 
        local _EventKey = tostring(_ConfigId).."_"..tostring(PlayerControl.TheMeCharacter.NowNode.NodeId)
        WorldMapEventSys.DeleteEvent(_EventKey)                      --获取事件道具 成功 删除事件
    end
end

function WorldMapEventSys.EndActivity()          --领奖时间为0 活动彻底结束
   WorldMapEventSys.EventData = nil
   WorldMapEventSys.EventConfigID = 0  
   WorldMapEventSys.EventType = 0
   WorldMapEventSys.RewardEndTime = 0   
end

function WorldMapEventSys.SetDemageRankList(_Rank , _MyRank , _MyDemage)
   WorldMapEventSys.DemageRankList = _Rank
   WorldMapEventSys.MyDemage = _MyDemage
   WorldMapEventSys.MyRank = _MyRank
end

function WorldMapEventSys.SetScoreRankList(_ScoreInfo , _LeftCity)
   WorldMapEventSys.ScoreRankList = _ScoreInfo
   WorldMapEventSys.LeftCityNum = _LeftCity
   local _UIWroldMapTar = MainGameUI.FindPanelTarget("UIWorldMap")
   if _UIWroldMapTar~=nil then
      _UIWroldMapTar:SetYellowManScore()
   end
end

function WorldMapEventSys.SetNowTeam(_NowTeam)                                      --设置当前是哪只队伍的信息
   WorldMapEventSys.NowTeam = _NowTeam
   local _UIWroldMapTar = MainGameUI.FindPanelTarget("UIWorldMap")
   if _UIWroldMapTar~=nil then
      _UIWroldMapTar:SetNowTeam(WorldMapEventSys.NowTeam)
   end
end

function WorldMapEventSys.SetArmyNum(_NowArmy)                                                --设置兵力
   if WorldMapEventSys.NowTeam==nil or WorldMapEventSys.NowTeam == 0 then
      WorldMapEventSys.NowTeam = 1 
   end

   WorldMapEventSys.NowArmyNum = _NowArmy

   local _TeamInfo = TeamSys.GetTeamInfoByType(WorldMapEventSys.NowTeam)
   if _TeamInfo~=nil then
       local _TotalArmy = #_TeamInfo * 60

       WorldMapEventSys.TotalArmyNum = _TotalArmy
       local _UIWroldMapTar = MainGameUI.FindPanelTarget("UIWorldMap")
       if _UIWroldMapTar~=nil then
          _UIWroldMapTar:SetArmyNum(_NowArmy , _TotalArmy)
       end
   end
end

function WorldMapEventSys.BuyArmyNumCallBack()
   local _NowArmy = 0
   local _TeamInfo = TeamSys.GetTeamInfoByType(WorldMapEventSys.NowTeam)
   if _TeamInfo~=nil then
      _NowArmy = #_TeamInfo * 60
   end
   WorldMapEventSys.SetArmyNum(_NowArmy)
   if PlayerControl.TheMeCharacter~=nil then
      PlayerControl.TheMeCharacter:ClearMe()
   end

    local _UIWroldMapTar = MainGameUI.FindPanelTarget("UIWorldMap")
    if _UIWroldMapTar~=nil then
       if WorldMapSys.BuyArmyPower >=1 then
          WorldMapSys.BuyArmyPower = WorldMapSys.BuyArmyPower - 1
       end
       _UIWroldMapTar:SetArmyPower(WorldMapSys.BuyArmyPower)
    end

end
                                                
WorldMapEventSys.TempEvents = {}
function WorldMapEventSys.TempEventOpen(_RewardCityId , _ConfigId , _IsAdd)                                  --掉宝事件开启 关闭  _IsAdd 1 增加 2 删除
   if _IsAdd==1 then
       local _TempEventData = EventTemplateConfig.GetEventTemplate(_ConfigId)

       local _Data = 
       {
          TempEventData = _TempEventData,                                                 --事件
          TempEventType = _TempEventData.EventType,                                       --1,2.....10
          TempEventConfigID = _ConfigId,
          TempEventCityId = _RewardCityId,
       } 

       local Reward = {}
       if _ConfigId==203 then                                                                                   --抽奖奖励
          local _RewardString = EventRewardConfig.GetEventRewardConfig(ClinetInfomation.Lvl , _Data.TempEventConfigID)
          local _RewardsStr = GameMain.StringSplit(_RewardString , ",")
          for i = 1 , #_RewardsStr , 1 do
              local _RewardsS = GameMain.StringSplit(_RewardsStr[i] , "|")
              local _RewardId = tonumber(_RewardsS[1])
              if _Data.RewardsDataConfig==nil then
                 _Data.RewardsDataConfig = {}
              end
              _Data.RewardsDataConfig[i] = _RewardId
              local _RewardString = RewardConfig.GetRewardConfig(_RewardId).RewardString
              local _Reward = RewardContentSys.GetRewardResourceString(_RewardString)
              if Reward[i]==nil then
                 Reward[i] = {}
              end
              Reward[i] = _Reward.Items[1]
          end

       else
          local _RewardId = EventRewardConfig.GetEventRewardConfig(ClinetInfomation.Lvl , _Data.TempEventConfigID)
          local _RewardString = RewardConfig.GetRewardConfig(_RewardId).RewardString
          local _Reward = RewardContentSys.GetRewardResourceString(_RewardString)
          if Reward[1]==nil then
             Reward[1] = {}
          end
          Reward[1] = _Reward.Items[1]
       end

       _Data.Reward = Reward

       local EventKey = tonumber(_ConfigId).."_"..tostring(_RewardCityId)

       if WorldMapEventSys.TempEvents[EventKey]==nil then
          WorldMapEventSys.TempEvents[EventKey] = {}
       end
       WorldMapEventSys.TempEvents[EventKey] = _Data

       local _UIWroldMapTar = MainGameUI.FindPanelTarget("UIWorldMap")
       if _UIWroldMapTar~=nil then
          _UIWroldMapTar:SetTempEvent(EventKey , WorldMapEventSys.TempEvents[EventKey])
       end

   elseif _IsAdd==2 then
       local EventKey = tonumber(_ConfigId).."_"..tostring(_RewardCityId)
       WorldMapEventSys.DeleteEvent(EventKey)
   elseif _IsAdd==3 then

   end
end

function WorldMapEventSys.DeleteEvent(EventKey)
   if WorldMapEventSys.TempEvents[EventKey]~=nil then
      local _UIWroldMapTar = MainGameUI.FindPanelTarget("UIWorldMap")
      if _UIWroldMapTar~=nil then
         _UIWroldMapTar:DeleteTempEvent(EventKey)
      end
      WorldMapEventSys.TempEvents[EventKey] = nil
   end
end

function WorldMapEventSys.SetDantiao(_Name)                                         --设置单挑
   local _UIWroldMapTar = MainGameUI.FindPanelTarget("UIWorldMap")
   if _UIWroldMapTar~=nil then
      _UIWroldMapTar:SetDantiaoName(_Name)
   end
end

WorldMapEventSys.CallEventList = {}                                                 --召集列表
function WorldMapEventSys.AddCallEventList(_CallId , _Time , _RoomId)
   if WorldMapEventSys.CallEventList[_CallId]==nil then
      WorldMapEventSys.CallEventList[_CallId] = {}
   end
   WorldMapEventSys.CallEventList[_CallId].CallId = _CallId
   WorldMapEventSys.CallEventList[_CallId].TotalTime = tonumber(_Time)
   WorldMapEventSys.CallEventList[_CallId].RoomId = _RoomId
   local _UIWroldMapTar = MainGameUI.FindPanelTarget("UIWorldMap")
   if _UIWroldMapTar~=nil then
      _UIWroldMapTar:SetCall(_CallId , tonumber(_Time))
   end
end

function WorldMapEventSys.DeleteCallEventList(_CallId)
   if WorldMapEventSys.CallEventList[_CallId]~=nil then
      WorldMapEventSys.CallEventList[_CallId] = nil
   end
   local _UIWroldMapTar = MainGameUI.FindPanelTarget("UIWorldMap")
   if _UIWroldMapTar~=nil then
      _UIWroldMapTar:DeleteCallEvent(_CallId)
   end
end

function WorldMapEventSys.AddTempEventList()
   for key , value in pairs(WorldMapEventSys.CallEventList) do
       local _UIWroldMapTar = MainGameUI.FindPanelTarget("UIWorldMap")
       if _UIWroldMapTar~=nil then
           local _Time = TimeControl.GetTime(tostring(key))
           if _Time<=0 then
              if WorldMapEventSys.CallEventList[key]~=nil then
                 WorldMapEventSys.CallEventList[key] = nil
              end
           else
              _UIWroldMapTar:SetCall(key , tonumber(_Time))
           end
       end
   end
end

WorldMapEventSys.EmemyEvents = {}
function WorldMapEventSys.AddEmemyEvents(_EmemyEventId , _CtiyId , _LeftTime)
    local _EmemyEventData = WorldActivityConfig.GetWorldActivityConfig(_EmemyEventId)
    local _data = 
    {
         EmemyEventData = _EmemyEventData,
         EmemyEventId = _EmemyEventId,
         CityId = _CtiyId,
         LeftTime = _LeftTime,
    }
    WorldMapEventSys.EmemyEvents[_EmemyEventId] = _data

    local _UIWroldMapTar = MainGameUI.FindPanelTarget("UIWorldMap")
    if _UIWroldMapTar~=nil then
       _UIWroldMapTar:SetEmemyEvent(_EmemyEventId , WorldMapEventSys.EmemyEvents[_EmemyEventId])
    end 
end

function WorldMapEventSys.DeleteEmemyEvents(_EmemyEventId)
    WorldMapEventSys.EmemyEvents[_EmemyEventId] = nil
end

function WorldMapEventSys.SetHireArmy()
   local _UIWroldMapTar = MainGameUI.FindPanelTarget("UIWorldMap")
   if _UIWroldMapTar~=nil then
      _UIWroldMapTar:HireArmyCallBack()
   end
end

function WorldMapEventSys.Release()
    WorldMapEventSys.EventType = 0                                                      
    WorldMapEventSys.EventData = nil                                            --数据库事件Data
    WorldMapEventSys.EventConfigID = 0

    WorldMapEventSys.RewardCity = 0                                            --物品刷新到的城市
    WorldMapEventSys.RewardEndTime = 0
    WorldMapEventSys.EventOpen = 0
    WorldMapEventSys.IsGetReward = 0                                            --0 可以领取 1 已经领取2 不可取
    WorldMapEventSys.DemageRankList = {}                                        --输出排行
    WorldMapEventSys.ScoreRankList = {}                                         --积分排行
    WorldMapEventSys.LeftCityNum = 0                                            --剩余城池积分
    WorldMapEventSys.DefenceCity = 0                                            --防守的阵营

    WorldMapEventSys.NowArmyNum = 0                                             --当前兵力
    WorldMapEventSys.TotalArmyNum = 0                                           --最高兵力
    WorldMapEventSys.NowTeam = 0                                                --当前队伍

    WorldMapEventSys.TempEvents = {}

   -- WorldMapEventSys.CallEventList = {}  
    WorldMapEventSys.EmemyEvents = {}
end

function WorldMapEventSys.ReleaseData()
   
   WorldMapEventSys.EventType = 0                                              --4天降祥瑞          
   WorldMapEventSys.EventData = nil                                            --数据库事件Data
   WorldMapEventSys.EventConfigID = 0
   WorldMapEventSys.CityId = 0                                                 --屎黄降临的城市图标
   
   WorldMapEventSys.RewardCity = 0                                             --物品刷新到的城市
   WorldMapEventSys.Reward = 0                                                 --刷新到城池的物品
   WorldMapEventSys.RewardEndTime = 0
   WorldMapEventSys.EventOpen = 0
   WorldMapEventSys.IsGetWinReward = 0                                         --0 可以领取 1 已经领取2 不可取 胜利奖励
   WorldMapEventSys.IsGetOhterReward = 0                                       --0 可以领取 1 已经领取2 不可取 其他奖励
   WorldMapEventSys.DemageRankList = {}                                        --输出排行
   WorldMapEventSys.MyDemage = 0
   WorldMapEventSys.MyRank = 0
   WorldMapEventSys.ScoreRankList = {}                                         --积分排行 蜀 魏 吴
   WorldMapEventSys.LeftCityNum = 0                                            --剩余城池积分
   WorldMapEventSys.DefenceCity = 0                                            --防守的阵营
   
   WorldMapEventSys.NowArmyNum = 0                                             --当前兵力
   WorldMapEventSys.TotalArmyNum = 0                                           --最高兵力
   WorldMapEventSys.NowTeam = 0                                                --当前队伍

end

return WorldMapEventSys