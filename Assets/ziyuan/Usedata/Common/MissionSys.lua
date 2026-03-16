MissionSys = {}
MissionSys.DailyList = {}
MissionSys.MainList = {}
MissionSys.NowActive = 0
MissionSys.TotalActive = 0
MissionSys.NowHaveReceiveActive = {}     --当前领了哪几个宝箱了


function MissionSys.GetTotalActive()
	local data = ActiveRewardConfig.ActiveRewardConfig[ActiveRewardConfig.Number]
	 
   local _TotalActive = data.Active
   return _TotalActive
end

function MissionSys.SetNowActive(_Active)
   MissionSys.NowActive = 0
   MissionSys.NowActive = _Active
end

function MissionSys.ReceiveActiveReward(_ID)  --领取活跃度奖励
   local _Info = tostring(_ID)
   WebEvent.ReceiveActiveReward(_Info , "MissionSys.ReceiveActiveRewardCallBack" , MissionSys.ReceiveActiveRewardCallBack)
end

function MissionSys.ReceiveActiveRewardCallBack(_data , returnId)  --领取活跃度奖励
   if returnId==0 then
      local UIMissionTar = MainGameUI.FindPanelTarget("UIMission")
      if UIMissionTar~=nil then
         UIMissionTar:SetActiveBox()
         UIMissionTar:GetActiveRewardCallBack()
      end
      DataUIInstance.PopTip("L8")

   elseif returnId==2 then
      DataUIInstance.PopTip("N6")
   end
end


MissionSys.Index = 0
function MissionSys.ReceiveDailyMission(_Id , _Index)
   local Info = tonumber( _Id)
   MissionSys.Index = _Index
   WebEvent.ReceiveDaily(Info , "MissionSys.ReceiveDailyMissionCallBack" , MissionSys.ReceiveDailyMissionCallBack)
end

function MissionSys.ReceiveDailyMissionCallBack(data , returnId)      
   if returnId==0 then
      local UIMissionTar = MainGameUI.FindPanelTarget("UIMission")
      UIMissionTar:ReflashDaily(MissionSys.Index)
      
   end
end

function MissionSys.ReceiveMainMission(_Id , _Index)
   local Info = _Id
   MissionSys.Index = _Index
   WebEvent.ReceiveMain(Info , "MissionSys.ReceiveMainMissionCallBack" , MissionSys.ReceiveMainMissionCallBack)
end

function MissionSys.ReceiveMainMissionCallBack(data , returnId)
   if returnId == 0 then
      local UIMissionTar = MainGameUI.FindPanelTarget("UIMission")
      UIMissionTar:ReflashMainMission(MissionSys.Index)
      DataUIInstance.PopTip("L8")
   elseif returnId == 2 then
      DataUIInstance.PopTip("L2")
   end
end

function MissionSys.AddMainMission(_MainId , _IsFinish , _IsReceive)
   if _IsReceive==0 then                    --替换的
      local _Mission = MissionDataSys.CreateMainMission(_MainId , _IsFinish)        --创建出来的主线任务
      if _Mission==nil then
         return
      end
      local _TempMission , i = MissionSys.GetMainMissionByType(_Mission.Class)           --在列表中的同类任务
      if _TempMission==nil then
         table.insert(MissionSys.MainList , #MissionSys.MainList + 1 , _Mission)
      else 
         MissionSys.MainList[i] = _Mission 
      end
   end
end

function MissionSys.AddDailyMission(_DailyId , _Process , _IsFinish , _IsReceive)
   local _tempMissionIndex = MissionSys.GetDailyMissionById(_DailyId)
   if _tempMissionIndex==nil then
      local _Mission = MissionDataSys.CreateDailyMissions(_DailyId , _Process , _IsFinish , _IsReceive)
      if _Mission==nil then
         return
      end
      table.insert(MissionSys.DailyList , #MissionSys.DailyList + 1 , _Mission)
   else
      MissionSys.DailyList[_tempMissionIndex].Process = _Process
      MissionSys.DailyList[_tempMissionIndex].IsFinish = _IsFinish
      MissionSys.DailyList[_tempMissionIndex].IsReceive = _IsReceive
   end
end

function MissionSys.GetDailyMissionById(_DailyId)
   for i = 1 , #MissionSys.DailyList , 1 do
       if MissionSys.DailyList[i].Id == _DailyId then
          return i
       end
   end
   return nil
end

function MissionSys.GetMainMissionById(_MainId)
   for i = 1 ,#MissionSys.MainList , 1 do
       if MissionSys.MainList[i].Id == _MainId then
          return  MissionSys.MainList[i] , i
       end
   end
   return nil , nil
end

function MissionSys.GetMainMissionByType(_Class)
   for i = 1 ,#MissionSys.MainList , 1 do
       if MissionSys.MainList[i].Class == _Class then
          return  MissionSys.MainList[i] , i
       end
   end
   return nil , nil
end

function MissionSys.DeleteMainMission(_MainId , _IsFinish)
   local _Mission = MissionDataSys.CreateMainMission(_MainId , _IsFinish)
   table.insert(MissionSys.MainList , #MissionSys.MainList + 1 , _Mission)
end



function MissionSys.ComminfoCallBack(data)

    local _TaskMission = data["Task"]
    if _TaskMission~=nil then
        for i = 1 , #_TaskMission , 1 do
            local _Data = _TaskMission[i]
            local _Id = tonumber(_Data["id"])
            local _IsFinishied = tonumber(_Data["isFinished"])
            local _IsReceive = tonumber(_Data["isDelete"])
            if _Data["isDelete"]==nil then
               _IsReceive = 0
            end
            MissionSys.AddMainMission(_Id , _IsFinishied , _IsReceive)
            if _IsFinishied==1 then
               local _UIControlTar = MainGameUI.FindPanelTarget("UIControl")
               if _UIControlTar~=nil then
                  _UIControlTar:OpenTip(true , "Mission")
               end
            end
        end
    end

    local _DailyMission = data["Daily"]
    if _DailyMission~=nil then
       for i = 1 , #_DailyMission , 1 do
            local _Data = _DailyMission[i]
            local _Id = tonumber(_Data["id"])
            local _IsFinishied = 0
            local _Required = tonumber(_Data["required"])
            local _Process = tonumber(_Data["progress"])
            local _IsReceive = tonumber(_Data["isReceived"])       --是否领取
            if _Required>_Process then
               _IsFinishied = 0
            else
               _IsFinishied = 1 
            end
            MissionSys.AddDailyMission(_Id , _Process , _IsFinishied , _IsReceive)
        end
    end

    local _HaveReceiveActive = data["ActiveRwdRecvd"]
   
    if _HaveReceiveActive~=nil then
       MissionSys.NowHaveReceiveActive = {}
	   for key,value in pairs(_HaveReceiveActive) do
		   local index = tonumber(key)
		   if index~=nil then
			  MissionSys.NowHaveReceiveActive[index] = value
		   end
		end      
    end
	SignSys.ComminfoCallBack(data)
    ArmyMoneySys.SetArmyMoneyId(data)
	OnlineRwdSys.ComminfoCallBack(data)
end



function MissionSys.ReleaseData()
   MissionSys.DailyList = {}
   MissionSys.MainList = {}
   MissionSys.NowActive = 0
   MissionSys.TotalActive = 0
   MissionSys.NowHaveReceiveActive = {}     --当前领了哪几个宝箱了
end

return MissionSys