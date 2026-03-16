WorldMapSocketSys = {}
WorldMapSocketSys.BattleLog = false
WorldMapSocketSys.ReceiveBattle = false
function WorldMapSocketSys.LoginSocketEvent()
   WorldMapSocketSys.BattleLog = true
   WorldMapSocketSys.ReceiveBattle = false
   SocketClient.RegistMsgHandle(SocketClient.MsgID.ReceiveStop, WorldMapSocketSys.ReceiveStopMove)
   SocketClient.RegistMsgHandle(SocketClient.MsgID.ReceiveCityState, WorldMapSocketSys.ReceiveCityStateHandle)
   SocketClient.RegistMsgHandle(SocketClient.MsgID.ReceiveArmy, WorldMapSocketSys.ReceiveArmy)
   SocketClient.RegistMsgHandle(SocketClient.MsgID.ReceiveActivity, WorldMapSocketSys.ReceiveActivity)
   SocketClient.RegistMsgHandle(SocketClient.MsgID.ReceiveReward, WorldMapSocketSys.ReceiveReward)
   SocketClient.RegistMsgHandle(SocketClient.MsgID.ReceiveSouthMan, WorldMapSocketSys.ReceiveSouthManCallBack)
   SocketClient.RegistMsgHandle(SocketClient.MsgID.ReceiveArmyData, WorldMapSocketSys.ReceiveArmyStateCallBack)
   SocketClient.RegistMsgHandle(SocketClient.MsgID.ReceiveWorldFight, WorldMapSocketSys.ReceiveWorldFight)
   SocketClient.RegistMsgHandle(SocketClient.MsgID.ReceiveEvent, WorldMapSocketSys.ReceiverEvent)
   SocketClient.RegistMsgHandle(SocketClient.MsgID.ReceiveNowArmy, WorldMapSocketSys.ReceiverNowArmy)
   SocketClient.RegistMsgHandle(SocketClient.MsgID.ReceiveCommonInfo, WorldMapSocketSys.ReceiveComminfoCallBack)

   SocketClient.RegistMsgHandle(SocketClient.MsgID.ReceiveLogin, WorldMapSocketSys.ReceiveLoginHandle)
   SocketClient.RegistMsgHandle(SocketClient.MsgID.ReceiveMove, WorldMapSocketSys.ReceiveMoveHandle)
   SocketClient.RegistMsgHandle(SocketClient.MsgID.Receivelook_fight, WorldMapSocketSys.ReceiveSeeFight)
   SocketClient.RegistMsgHandle(SocketClient.MsgID.ReceiveFRS_Reward, WorldMapSocketSys.ReceiveRewardCallBack)
   SocketClient.RegistMsgHandle(SocketClient.MsgID.ReceiveTeam, WorldMapSocketSys.ReceiveChangeTeamCallBack)
   SocketClient.RegistMsgHandle(SocketClient.MsgID.ReceiveCityInfo, WorldMapSocketSys.ReceiveRequestCityInfoCallBack)
   SocketClient.RegistMsgHandle(SocketClient.MsgID.ReceiveHireArmy, WorldMapSocketSys.ReceiveHireArmyCallBack)
   SocketClient.RegistMsgHandle(SocketClient.MsgID.ReceiveBuyArmy, WorldMapSocketSys.ReceiveBuyArmyCallBack)
   SocketClient.RegistMsgHandle(SocketClient.MsgID.ReceiveDanTiao, WorldMapSocketSys.ReceiveDantiaoCallBack)
   SocketClient.RegistMsgHandle(SocketClient.MsgID.ReceiveBack, WorldMapSocketSys.ReceiveBackCallBack)
   SocketClient.RegistMsgHandle(SocketClient.MsgID.ReceiveGoAttack, WorldMapSocketSys.ReceiveGoAttackCallBack)
   SocketClient.RegistMsgHandle(SocketClient.MsgID.ReceiveCallFriend, WorldMapSocketSys.ReceiveCallFriendCallBack)
   SocketClient.RegistMsgHandle(SocketClient.MsgID.ReceiveRoomMember, WorldMapSocketSys.ReceiveRoomMemberCallBack)
end

function WorldMapSocketSys.SendMoveSocketEvent(_Nodes)                                                --发送移动路径等


   local data = {
        intList = {},
    }


   local Count = #_Nodes
   data.intList[1] = Count

   for i = 1 , Count , 1 do
       data.intList[i + 1] = _Nodes[i].NodeId
   end

   Debug.LogError("发送移动包")
   --GameMain.Print(data)
   SocketClient.SendNetEvent(SocketClient.MsgID.RequestMove, data);
end

function WorldMapSocketSys.ReceiveMoveHandle(_ReceiveMoveData)                                           --接收其他玩家移动路径等
   
    if GameMain.ShowLog==false then
        Debug.LogError("接收玩家移动信息")
       GameMain.Print(_ReceiveMoveData , "_ReceiveMoveData")
    end
    local intList = _ReceiveMoveData.intList
    local stringList = _ReceiveMoveData.stringList
    local Result = tonumber(intList[1])                                                                   --返回结果

    if Result==1 then
       PlayerControl.ClearTheMeNode()                                                                     --玩家没有军队
       DataUIInstance.PopTip("V4")
       return
    end
    if Result==2 then
       PlayerControl.ClearTheMeNode()                                                                     --状态不对 无法移动
       DataUIInstance.PopTip("V5")
       return
    end
    if Result==3 then
       PlayerControl.ClearTheMeNode()                                                                     --移动路径小于2
       DataUIInstance.PopTip("V6")
       return
    end
    if Result==4 then
       PlayerControl.ClearTheMeNode()                                                                     --位置错误
       DataUIInstance.PopTip("V7")
       local _NodeId = intList[8]
       PlayerControl.GotoPlace(PlayerControl.WorldId , 0 , _NodeId)
       return
    end
    if Result==5 then
       PlayerControl.ClearTheMeNode()                                                                     --兵力
       DataUIInstance.PopTip("V8")
       
       return
    end

    local WorldId = tonumber(intList[2])
    local GuaShuaiId = tonumber(intList[3])
    local VipLevel = tonumber(intList[4])
    local Officer = tonumber(intList[5])
    local ArmyCamp = tonumber(intList[6])
    local NodeCount = tonumber(intList[7])
    local ArmyId = stringList[1]
    local PlayerName = stringList[2]

    local NodesData = {}
    for i = 1 , NodeCount , 1 do
        NodesData[i] = intList[7 + i]
    end

    PlayerControl.CreateCharacter(WorldId , ArmyId ,NodesData , NodeCount , GuaShuaiId , ArmyCamp , VipLevel , Officer , PlayerName)
end

function WorldMapSocketSys.ReceiveCityStateHandle(_ReceiveCityData)                                     --接收城池状态
  -- 
   if GameMain.ShowLog==false then
      --Debug.LogError("城池状态变更")
      --GameMain.Print(_ReceiveCityData , "_ReceiveCityData")
   end
   local intList = _ReceiveCityData.intList
   local Count = intList[1]                                             --城池改变数量
 
   local _CityId = 0
   local _Owner = 0
   local _CityState = 0

   local _DefenceNum = 0
   local _DefenceShuNum = 0
   local _DefenceWeiNum = 0
   local _DefenceWuNum = 0
   local _DefenceMidNum = 0

   local _AttackNum = 0
   local _AttackShuNum = 0
   local _AttackWeiNum = 0
   local _AttackWuNum = 0
   local _AttackMidNum = 0

   local _Key = 2
   for i = 1 , Count , 1 do
       _CityId = intList[_Key]
       _Owner = intList[_Key + 1]
       _CityState = intList[_Key + 2]

       _DefenceShuNum = intList[_Key + 3]
       _DefenceWeiNum = intList[_Key + 4]
       _DefenceWuNum = intList[_Key + 5]
       _DefenceMidNum = intList[_Key + 6]

       _DefenceNum = _DefenceShuNum + _DefenceWeiNum + _DefenceWuNum + _DefenceMidNum

       _AttackShuNum = intList[_Key + 7]
       _AttackWeiNum = intList[_Key + 8]
       _AttackWuNum = intList[_Key + 9]
       _AttackMidNum = intList[_Key + 10]

       _AttackNum = _AttackShuNum + _AttackWeiNum + _AttackWuNum + _AttackMidNum

       _Key = _Key + 11

       local data =
       {
          CityId = _CityId,
          Owner = _Owner,
          CityState = _CityState,
          DefenceNum = _DefenceNum,
          AttackNum = _AttackNum,

          DefenceShuNum = _DefenceShuNum,
          DefenceWeiNum = _DefenceWeiNum,
          DefenceWuNum = _DefenceWuNum,
          DefenceMidNum = _DefenceMidNum,
            
          AttackShuNum = _AttackShuNum,
          AttackWeiNum = _AttackWeiNum,
          AttackWuNum =  _AttackWuNum,
          AttackMidNum = _AttackMidNum,
       }

       WorldMapSys.SetNodeStates(data)
   end
end

function WorldMapSocketSys.ReceiveLoginHandle(_ReceiveLoginData)                                    --接收登录
   
   if GameMain.ShowLog==false then
      Debug.LogError("登录返回信息")
      GameMain.Print(_ReceiveLoginData , "_ReceiveLoginData")
   end
   local intList = _ReceiveLoginData.intList
   local Result = tonumber(intList[1])                              --登陆结果
   if Result==0 then
      -- local PlayerOwner = tonumber(intList[2])                         --玩家阵营
       local Team = tonumber(intList[2])                                --当前的选择队伍
       local IsFight = tonumber(intList[3])                                 --是否战斗过

       --[[if PlayerControl.TheMeCharacter~=nil then
          PlayerControl.TheMeCharacter:SetOwner(ClinetInfomation.MyOwner)
       end--]]
       WorldMapEventSys.SetNowTeam(Team)

       --[[local _UIControlTar = MainGameUI.FindPanelTarget("UIControl")                            
       if _UIControlTar~=nil then
          _UIControlTar:OpenWorldMapEvent()
       end--]]

   elseif Result==2 then
       DataUIInstance.PopTip("X1")
       SocketClient.DisConnect()
       LoadingPanel.StopChangeScenePanel()
       return
   end
end

WorldMapSocketSys.FightType = 0
WorldMapSocketSys.FightCity = 0
function WorldMapSocketSys.SendRequestSeeFight(_Type , _CityId)                                                --请求观看战斗

   local data = {
        intList = {_Type , _CityId},
    }
   WorldMapSocketSys.FightType = _Type
   WorldMapSocketSys.FightCity = _CityId

   SocketClient.SendNetEvent(SocketClient.MsgID.Requestlook_fight, data);

end

function WorldMapSocketSys.ReceiveSeeFight(_ReceiveFightData)                                         --接收战斗观看数据
   
   if GameMain.ShowLog==false then
      Debug.LogError("战斗观看信息")
      GameMain.Print(_ReceiveFightData , "_ReceiveFightData")
   end
   local _PvpString = _ReceiveFightData.stringList[1]
   local _PvpResult = _ReceiveFightData.intList[1]
   Debug.LogError(_PvpString)
   if _PvpResult ==0 then
      --SocketClient.DisConnect()
   elseif _PvpResult~=0 or _PvpResult==nil then
      lgNoDelCsFun.Ins:SetPvpShowNum(0)
      return
   end
 
   if WorldMapSocketSys.ReceiveBattle==false then
      lgNoDelCsFun.Ins:SetPvpResult(_PvpString)
      lgNoDelCsFun.Ins:SetPvpShowNum(-1)
      WorldMapSocketSys.SendRequestRoomMember(3 , WorldMapSocketSys.FightCity , GameMain.SetPvpBattleInfo)
      GameMain.EnterZQBattle(2 , 9001 , false)
      WorldMapSocketSys.ReceiveBattle = true
   else
      lgNoDelCsFun.Ins:SetPvpResult(_PvpString)
      lgNoDelCsFun.Ins:SetPvpShowNum(-2)
   end
end

function WorldMapSocketSys.ReceiveArmy(_ReceiveArmy)                                                    --刚开始进去
  
   if GameMain.ShowLog==false then
      Debug.LogError("接收军队信息")
      GameMain.Print(_ReceiveArmy , "_ReceiveArmy")
   end
   local intList = _ReceiveArmy.intList
   local floatList = _ReceiveArmy.floatList
   local stringList = _ReceiveArmy.stringList

   local _TotalNum = #intList
   local _KeyIndex = 1
   local _TimeIndex = 1
   local _StringIndex = 1
   local WorldId = 0
   local State = 0
   local InitRoom = 0
   local ArmyPower = 0
   local ArmyCamp = 0
   local ConfigId = 0
   local NodeCount = 0
   local GuaShuaiId = 0

   while  _TotalNum > _KeyIndex do
      State = tonumber(intList[_KeyIndex])
      WorldId = tonumber(intList[_KeyIndex + 1])
      InitRoom = tonumber(intList[_KeyIndex + 2])
      ArmyPower = tonumber(intList[_KeyIndex + 3])
      ArmyCamp = tonumber(intList[_KeyIndex + 4])
      ConfigId = tonumber(intList[_KeyIndex + 5])
      NodeCount = tonumber(intList[_KeyIndex + 6])
      _KeyIndex = _KeyIndex + 7
      local NodesData = {}
      for i =1 , NodeCount , 1 do
          if intList[_KeyIndex]~=0 then
             NodesData[i] = intList[_KeyIndex]
             _KeyIndex = _KeyIndex + 1
          end
      end
      if NodeCount == 0 then
         table.insert(NodesData , 1 , InitRoom)
         NodeCount = NodeCount + 1
         _KeyIndex = _KeyIndex + 1
      end

      GuaShuaiId = intList[_KeyIndex]
      VipLevel = intList[_KeyIndex + 1]
      Officer = intList[_KeyIndex + 2]
      _KeyIndex = _KeyIndex + 3

      local TempTime = floatList[_TimeIndex]
      local AiArmyUUID = stringList[_StringIndex]           --军队ID
      _StringIndex = _StringIndex + 1
      local PlayerName = stringList[_StringIndex]
      if WorldId==0 then --Ai军队
         
         PlayerControl.SetArmyAiTempTime(WorldId , AiArmyUUID  , NodesData , TempTime , ConfigId , GuaShuaiId , ArmyCamp , State , VipLevel , Officer , PlayerName)
         
      else
         if PlayerControl.WorldId==WorldId then                                                         --设置兵力  UI界面
            if PlayerControl.TheMeCharacter==nil then
               PlayerControl.CreateMy()
            else
               PlayerControl.TheMeCharacter:SetGobActive()
            end
            WorldMapEventSys.SetArmyNum(ArmyPower)
         end
         PlayerControl.SetArmy(WorldId , AiArmyUUID  , NodesData , TempTime , NodeCount , ArmyPower , ConfigId , GuaShuaiId , ArmyCamp , State , VipLevel , Officer , PlayerName)
      end
      _StringIndex = _StringIndex + 1
      _TimeIndex = _TimeIndex + 1
   end
end

function WorldMapSocketSys.ReceiveWorldFight(_ReceiveWorldFight)      --获取灭国战信息
   
   if GameMain.ShowLog==false then
   Debug.LogError("接收灭国战信息")
   GameMain.Print(_ReceiveWorldFight , "_ReceiveWorldFight")
   end
   local intList = _ReceiveWorldFight.intList
   local _CampType = intList[1]                                        --1防御者阵营 2胜利者阵营
   local _DefenceCamp = 0
   if _CampType==1 then
      _DefenceCamp = intList[2]
      WorldMapEventSys.DefenceCity = _DefenceCamp
   elseif _CampType==2 then

   end
end

function WorldMapSocketSys.ReceiveStopMove(_ReceiverStopMove)           --接收 停止移动
     
    if GameMain.ShowLog==false then
       Debug.LogError("接收 停止移动")
       GameMain.Print(_ReceiverStopMove , "_ReceiverStopMove")
    end

    local intList = _ReceiverStopMove.intList
    local stringList = _ReceiverStopMove.stringList
    local _Count = intList[1]
    local _WorldId = nil
    local _NodeId = nil
    local _ArmyState = nil
    local _ArmyId = nil 
    local _ConfigId = nil

    local _Key = 2
    local _StringKey = 1
    for i = 1 , _Count , 1 do
        _WorldId = intList[_Key]
        _NodeId = intList[_Key + 1]
        _ArmyState = intList[_Key + 2]
        _ConfigId = intList[_Key + 3]
        _Key = _Key + 4
        _ArmyId = stringList[_StringKey]
        _StringKey = _StringKey + 1
        PlayerControl.SetArmyState(_ArmyId , _ArmyState , _NodeId , _ConfigId)
    end

   
   --[[ local stringList = _ReceiverStopMove.stringList
    local _WorldId = intList[1]
    local _NodeId = intList[2]
    local _ArmyId = stringList[1]

    if intList[3]~=nil then
       if _WorldId==PlayerControl.WorldId then
          local _ArmyState = intList[3]
          PlayerControl.SetMeState(_ArmyState)
       end
    end

    PlayerControl.GotoPlace(_WorldId , _ArmyId , _NodeId)--]]
end

--**************在城池刷新可领取道具
function WorldMapSocketSys.ReceiveReward(_ReceiveReward)
    
    if GameMain.ShowLog==false then
    Debug.LogError("城池刷新了可以领取的道具")
    GameMain.Print(_ReceiveReward , "_ReceiveReward")
    end
    local _OwnActiveId = _ReceiveReward.intList[1]                      --归属活动
    local _CityId = _ReceiveReward.intList[2]                           --城镇ID
    local _RewardId = _ReceiveReward.intList[3]                         --奖励ID

    local _Reward = nil

    WorldMapEventSys.SetReward(_CityId , _Reward)

end

---*******活动列表 开启 关闭 提示
WorldMapSocketSys.ConfigId = 0
function WorldMapSocketSys.ReceiveActivity(_ReceiveRFS)
    Debug.LogError("活动列表")
       GameMain.Print(_ReceiveRFS , "_ReceiveRFS")
    if GameMain.ShowLog==false then
       
    end
    local _ConfigId = _ReceiveRFS.intList[1]
    local _IsOpen = _ReceiveRFS.intList[2]
    local _IsGetWinReward = _ReceiveRFS.intList[3]                            --0可以领取 1 - 已领取 2 - 没有条件领取 活动胜利奖励 天降祥瑞属于胜利奖励
    local _IsGetOtherReward = _ReceiveRFS.intList[4]                          --0可以领取 1 - 已领取 2 - 没有条件领取 活动其他奖励
    local _EndTime = tonumber(_ReceiveRFS.stringList[1])
    local _CityId = _ReceiveRFS.intList[5]
   
    WorldMapEventSys.SetEventData(_ConfigId , _IsOpen , _IsGetWinReward , _IsGetOtherReward  , _EndTime)
end

--*********推送事件列表 增加 减少 提示
function WorldMapSocketSys.ReceiverEvent(_ReceiveEvent)
   Debug.LogError("事件列表")
       GameMain.Print(_ReceiveEvent , "_ReceiveEvent")
    if GameMain.ShowLog==false then
       
    end
    local _intList = _ReceiveEvent.intList
    local _IsAdd = _ReceiveEvent.intList[1]                                    --1 增 2 删 3 事件列表

    if _IsAdd==3 then                                                          --新增事件列表
       local _EventCount = _ReceiveEvent.intList[#_ReceiveEvent.intList]
       if _EventCount==0 then
          return
       end
       for i = 1 , _EventCount , 1 do
           local _ConfigID = _ReceiveEvent.intList[i*2]
           local _EventRoomId = _ReceiveEvent.intList[i*2 + 1]
           WorldMapEventSys.TempEventOpen(_EventRoomId , _ConfigID  , 1)
       end
    end
    if _IsAdd==1 or _IsAdd==2 then
          
       local _ConfigID = _ReceiveEvent.intList[2]
       local _EventRoomId = _ReceiveEvent.intList[3]
       WorldMapEventSys.TempEventOpen(_EventRoomId , _ConfigID  , _IsAdd)

       --return
    end

    if _ReceiveEvent.intList[4]~=nil and _IsAdd~=3 then
       _IsAdd = _ReceiveEvent.intList[4]
       if _IsAdd==1 or _IsAdd==2 then
           local _ConfigID = _ReceiveEvent.intList[5]
           local _EventRoomId = _ReceiveEvent.intList[6]
           WorldMapEventSys.TempEventOpen(_EventRoomId , _ConfigID  , _IsAdd)
       end
    end
end

--*******推送我当前多少兵力
function WorldMapSocketSys.ReceiverNowArmy(_ReceiverNowArmy)
    
    if GameMain.ShowLog==false then
       Debug.LogError("推送我当前多少兵力")
       GameMain.Print(_ReceiverNowArmy , "_ReceiverNowArmy")
    end
    local _intList = _ReceiverNowArmy.intList
    local _NowArmy = _ReceiverNowArmy.intList[1]
    WorldMapEventSys.SetArmyNum(_NowArmy)
end

--************领取道具
WorldMapSocketSys.TempEventConfigId = 0
function WorldMapSocketSys.SendRequestGetReward(_ConfigId , _Type , _EventId)                          --活动ID 领奖类型  1 胜利将 天降也是胜利将 2 其他奖励  3 事件奖励
   Debug.LogError("领取道具 活动ConfigID：")
   Debug.LogError(_ConfigId)
   WorldMapSocketSys.TempEventConfigId = _EventId
   local data = {
        intList = {_ConfigId ,  _Type , _EventId},
    }

   SocketClient.SendNetEvent(SocketClient.MsgID.RequestGetReward, data);

end

--********领取道具是否成攻
function WorldMapSocketSys.ReceiveRewardCallBack(_ReceiveRewardCallBack)
    Debug.LogError("领取道具是否成攻")
    if GameMain.ShowLog==false then
       GameMain.Print(_ReceiveRewardCallBack , "_ReceiveRewardCallBack")
    end
    local _Result = _ReceiveRewardCallBack.intList[1]
    local _RewardId = _ReceiveRewardCallBack.intList[2]
    if _Result==0 then
       DataUIInstance.PopTip("领取成功")
       Debug.LogError("领取成功")
       WorldMapEventSys.GetReward(WorldMapSocketSys.TempEventConfigId , _RewardId)
    elseif _Result==1 then
       DataUIInstance.PopTip("领取失败")
       Debug.LogError("领取失败")
    elseif _Result==2 then
       DataUIInstance.PopTip("您没有权利领取该奖励")
       Debug.LogError("领取失败")
    elseif _Result==3 then
       DataUIInstance.PopTip("领取失败")
       Debug.LogError("领取失败3")
    end
end

--**推送AI人物进入世界地图
function WorldMapSocketSys.ReceiveSouthManCallBack(_ReceiveSouthManCallBack)
    
    if GameMain.ShowLog==false then
    Debug.LogError("推送AI人物进入世界地图")
    GameMain.Print(_ReceiveSouthManCallBack , "_ReceiveSouthManCallBack")
    end
    local _IntList = _ReceiveSouthManCallBack.intList
    local _StringList = _ReceiveSouthManCallBack.stringList

    local _ConfigId = _IntList[2]
    local _ArmyId = _StringList[2]
    local _NodeList = GameMain.StringSplit(_StringList[1] , ",")

    PlayerControl.SetArmyAi(0 , _ArmyId  , _NodeList , _ConfigId)
end

--**********************推送AI军队状态状态
function WorldMapSocketSys.ReceiveArmyStateCallBack(_ReceiveArmyStateCallBack)
    
    if GameMain.ShowLog==false then
       Debug.LogError("推送AI军队状态状态")
       GameMain.Print(_ReceiveArmyStateCallBack , "_ReceiveArmyStateCallBack")
    end
    local _IntList = _ReceiveArmyStateCallBack.intList
    local _StringList = _ReceiveArmyStateCallBack.stringList
    local _ConfigId = _IntList[1]
    local _State = _IntList[2]
    local _OutRoomId = _IntList[3]
    local _ArmyId = _StringList[1]
    PlayerControl.SetArmyState(_ArmyId , _State , _OutRoomId , _ConfigId)
end


--*************************请求活动 积分 伤害信息
function WorldMapSocketSys.SendRequestCityInfo(_Type)                       --  1 活动积分 2输出排行
   Debug.LogError("请求城池信息")
   local data = {
        intList = {_Type , WorldMapEventSys.EventConfigID},
    }

   SocketClient.SendNetEvent(SocketClient.MsgID.RequestGetCityInfo, data);

end

--*************************请求活动伤害积分信息回调
function WorldMapSocketSys.ReceiveRequestCityInfoCallBack(_ReceiveCityInfoCallBack)
   Debug.LogError("请求活动伤害积分信息回调")
   if GameMain.ShowLog==false then
   GameMain.Print(_ReceiveCityInfoCallBack , "_ReceiveCityInfoCallBack")
   end
   local _intList = _ReceiveCityInfoCallBack.intList
   local _Type = _intList[1]                                    --1积分 2输出
   local _stringList = _ReceiveCityInfoCallBack.stringList

   if _Type==2 then
       local _MyRank = _intList[#_intList - 1]
       local _MyDemage = _intList[#_intList]

       local _Count = _intList[2]                               --排行个数
       if _Count==0 then
          return
       end
       local _Id = 0
       local _Demage = 0
       local _Level = 0
       local _Key = 3
       local _Name = ""
       local _Rank =
       {

       }
       for i = 1 , _Count , 1 do
           _Id = _intList[_Key]
           _Key = _Key + 1
           _Demage = _intList[_Key]
           _Key = _Key + 1
           _Level = _intList[_Key]
           _Key = _Key + 1
           _Name = _stringList[i]
           local _data =
           {
              Id = _Id,
              Demage = _Demage,
              Lvl = _Level,
              Name = _Name,
           }
           table.insert(_Rank , #_Rank + 1 , _data)
       end
       WorldMapEventSys.SetDemageRankList(_Rank , _MyRank , _MyDemage)
   end

   if _Type==1 then
      local _ScoreInfo =
      {}
      _ScoreInfo[_intList[2]] = _intList[3]
      _ScoreInfo[_intList[4]] = _intList[5]
      _ScoreInfo[_intList[6]] = _intList[7]
      local _LeftCity = _intList[8]
      WorldMapEventSys.SetScoreRankList(_ScoreInfo , _LeftCity)
   end
  -- SocketClient.SendNetEvent(SocketClient.MsgID.RequestGetCityInfo, data);
end

--***********************请求购买兵力
function WorldMapSocketSys.SendRequestBuyArmy()
   Debug.LogError("请求购买兵力")
   local data = {
        intList = {1},
    }
   SocketClient.SendNetEvent(SocketClient.MsgID.RequestBuyArmy, data);
end

function WorldMapSocketSys.ReceiveBuyArmyCallBack(_ReceiveBuyArmyCallBack)
  Debug.LogError("购买兵力回调")
   GameMain.Print(_ReceiveBuyArmyCallBack , "_ReceiveBuyArmyCallBack")
   if GameMain.ShowLog==false then
       
   end
   local _intList = _ReceiveBuyArmyCallBack.intList
   local _result = _intList[1]
   if _result==0 then
      DataUIInstance.PopTip("U2")
      WorldMapEventSys.BuyArmyNumCallBack()
   elseif _result == 1 then
      
   elseif _result == 2 then
      DataUIInstance.PopTip("Y8")
   elseif _result == 3 then
      DataUIInstance.PopTip("移动过程无法购买兵力")
   end
end

--********************请求换阵容
WorldMapSocketSys.TempNowTeam = 0
function WorldMapSocketSys.SendRequestChangeTeam(_TeamNumber)
   Debug.LogError("请求换阵容")
   local data = {
        intList = {_TeamNumber},
    }
   WorldMapSocketSys.TempNowTeam = _TeamNumber
   SocketClient.SendNetEvent(SocketClient.MsgID.RequestChangeTeam, data);
end

function WorldMapSocketSys.ReceiveChangeTeamCallBack(_ReceiveChangeTeamCallBack)
   Debug.LogError("请求换阵容回调")
   if GameMain.ShowLog==false then
   GameMain.Print(_ReceiveChangeTeamCallBack , "_ReceiveChangeTeamCallBack")
   end
   local _intList = _ReceiveChangeTeamCallBack.intList
   local _result = _intList[1]
   if _result==0 then
      DataUIInstance.PopTip("U3")
      WorldMapEventSys.SetNowTeam(WorldMapSocketSys.TempNowTeam)
   elseif _result == 1 then
       DataUIInstance.PopTip("T3")
   elseif _result == 2 then
       DataUIInstance.PopTip("V1")
   elseif _result == 3 then
       DataUIInstance.PopTip("T8")
   elseif _result == 4 then
       DataUIInstance.PopTip("V2")
   end
end

--********************请求借兵
function WorldMapSocketSys.SendRequestHireArmy(_Type)
   Debug.LogError("请求借兵")
   local data =
   {
        intList = {_Type},
   }
   SocketClient.SendNetEvent(SocketClient.MsgID.RequestHireArmy, data);
end

function WorldMapSocketSys.ReceiveHireArmyCallBack(_ReceiveHireArmyCallBack)
   Debug.LogError("请求借兵回调")
   if GameMain.ShowLog==false then
      GameMain.Print(_ReceiveHireArmyCallBack , "_ReceiveHireArmyCallBack")
   end
   local _intList = _ReceiveHireArmyCallBack.intList
   local _result = _intList[1]
   if _result==0 then
      DataUIInstance.PopTip("U1")
      WorldMapEventSys.SetHireArmy()
   elseif _result == 1 then
      DataUIInstance.PopTip("Z5")
   elseif _result == 2 then

   end
end

--********************请求单挑
function WorldMapSocketSys.SendRequestDantiao()
   Debug.LogError("请求单挑")
   local data =
   {
        intList = {},
   }
   SocketClient.SendNetEvent(SocketClient.MsgID.RequestDanTiao, data);
end

function WorldMapSocketSys.ReceiveDantiaoCallBack(_ReceiveDantiaoCallBack)
   Debug.LogError("请求单挑回调")
   if GameMain.ShowLog==false then
      GameMain.Print(_ReceiveDantiaoCallBack , "_ReceiveDantiaoCallBack")
   end
   local _intList = _ReceiveDantiaoCallBack.intList
   local _result = _intList[1]
   local _stringList = _ReceiveDantiaoCallBack.stringList
   local _Name = _stringList[1]                     --单挑的名字
   if _result==0 then
      WorldMapEventSys.SetDantiao(_Name)
   elseif _result == 1 then
      DataUIInstance.PopTip("Z4")
   elseif _result == 2 then

   end
end


--********************请求撤退
function WorldMapSocketSys.SendRequestBack(_RoomId)             --撤退到某个城市
   Debug.LogError("请求撤退")
   local data =
   {
        intList = {_RoomId},
   }
   SocketClient.SendNetEvent(SocketClient.MsgID.RequestBack, data);
end

function WorldMapSocketSys.ReceiveBackCallBack(_ReceiveBackCallBack)
   Debug.LogError("请求撤退回调")
   if GameMain.ShowLog==false then
      GameMain.Print(_ReceiveBackCallBack , "_ReceiveBackCallBack")
   end
   local _intList = _ReceiveBackCallBack.intList
   local _result = _intList[1]

   if _result==0 then
      DataUIInstance.PopTip("撤退成功")
   elseif _result ==1 then
      DataUIInstance.PopTip("状态不对 无法撤退")
   end
end

--********************请求突进
function WorldMapSocketSys.SendRequestGoAttack(_RoomId)             --突进到某个城市
   Debug.LogError("请求突进")
   local data =
   {
        intList = {_RoomId},
   }
   SocketClient.SendNetEvent(SocketClient.MsgID.RequestGoAttack, data);
end

function WorldMapSocketSys.ReceiveGoAttackCallBack(ReceiveGoAttackCallBack)
   Debug.LogError("请求突进回调")
   if GameMain.ShowLog==false then
      GameMain.Print(ReceiveGoAttackCallBack , "ReceiveGoAttackCallBack")
   end
   local _intList = ReceiveGoAttackCallBack.intList
   local _result = _intList[1]

   if _result==0 then
      DataUIInstance.PopTip("突进成功")
   elseif _result ==1 then
      DataUIInstance.PopTip("状态不对 无法突进")
   end

end

--********************请求 响应召集 召集
WorldMapSocketSys.AnswerCallId = nil
function WorldMapSocketSys.SendRequestCallFriend(_Type , _Param)             --1 请求召集 2 响应召集
   Debug.LogError("请求召集")
   local Param = 0
   if _Type==1 then
      Param = 10
   elseif _Type==2 then
      Param = tonumber(_Param)
      WorldMapSocketSys.AnswerCallId = _Param
   end

   local data =
   {
        intList = {_Type , Param},
   }
   SocketClient.SendNetEvent(SocketClient.MsgID.RequestCallFriend, data);
end

function WorldMapSocketSys.ReceiveCallFriendCallBack(_ReceiveCallFriendCallBack)
   Debug.LogError("请求召集回调")
   if GameMain.ShowLog==false then
      GameMain.Print(_ReceiveCallFriendCallBack , "_ReceiveCallFriendCallBack")
   end

   local _intList = _ReceiveCallFriendCallBack.intList
   local _result = _intList[1]
   local _roomId = _intList[2]
   local _playerId = _intList[3]

   local _stringList = _ReceiveCallFriendCallBack.stringList
   local _CallId = _stringList[1]                                          --召集令ID
   local _LastTime = _stringList[2]

   if _result==0 then
      if _CallId=="0" then
         WorldMapEventSys.DeleteCallEventList(WorldMapSocketSys.AnswerCallId)
      else
         if _playerId==LoginData.PlayerID then
            return
         end
         WorldMapEventSys.AddCallEventList(tonumber(_CallId) , _LastTime , _roomId)
      end
   elseif _result == 1 then

   elseif _result == 2 then
      DataUIInstance.PopTip("状态不对 无法召集")
   elseif _result == 3 then
      DataUIInstance.PopTip("状态不对 无法被召集")
   elseif _result == 4 then
      DataUIInstance.PopTip("道具或者元宝不足")
   elseif _result == 5 then
      DataUIInstance.PopTip("该召集已经过期")
   end

end

--请求查看房间人数信息
WorldMapSocketSys.CallBack = nil
function WorldMapSocketSys.SendRequestRoomMember(_Type , _Room , _CallBack) --_Type 1 攻 2守 3双方
   Debug.LogError("请求查看房间人员")
   WorldMapSocketSys.CallBack = _CallBack
   local data =
   {
        intList = {_Type , _Room},
   }
   SocketClient.SendNetEvent(SocketClient.MsgID.RequestRoomMember, data)
end

function WorldMapSocketSys.ReceiveRoomMemberCallBack(_ReceiveRoomMemberCallBack)
   Debug.LogError("请求查看房间人员回调")
  
   if GameMain.ShowLog==false then
         GameMain.Print(_ReceiveRoomMemberCallBack , "_ReceiveRoomMemberCallBack")
   end
   local _intList = _ReceiveRoomMemberCallBack.intList
   local _result = _intList[1]
   if _result==0 then
      local _defenceNum = _intList[2]
      local _attackNum = _intList[3]
      local data =
      {
         TotoalNum = _defenceNum + _attackNum,
         Members = _ReceiveRoomMemberCallBack.stringList,
         attackNum = _attackNum,
         defenceNum = _defenceNum,
         MembersComp = _intList,
      }

      WorldMapSocketSys.CallBack(data)
   elseif _result ==1 then
      DataUIInstance.PopTip("房间ID错误")
   end
end

--通用信息
function WorldMapSocketSys.ReceiveComminfoCallBack(_ReceiveComminfoCallBack)
   Debug.LogError("通用信息回调")
   if GameMain.ShowLog==false then
      GameMain.Print(_ReceiveComminfoCallBack , "_ReceiveComminfoCallBack")
   end

   local _intList = _ReceiveComminfoCallBack.intList
   local _type = _intList[1]
   local _stringList =_ReceiveComminfoCallBack.stringList

   if _type == 1 then                                                                   --仙人指路
      local _RoomId = tonumber(_stringList[1])
      local _Time = tonumber(_stringList[2])
      WorldMapEventSys.AddEmemyEvents(701 , _RoomId , _Time)
   elseif _type==2 then                                                                 --黄巾乱入
      local _RoomString = tostring(_stringList[1])
      local _Ids = GameMain.StringSplit(_RoomString , ",")
      local _RoomId = tonumber(_Ids[#_Ids])
      local _Time = 0 --_stringList[2]
      WorldMapEventSys.AddEmemyEvents(601 , _RoomId , _Time)
   end

end

return WorldMapSocketSys
