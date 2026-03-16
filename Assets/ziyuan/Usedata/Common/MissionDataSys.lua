MissionDataSys = {}

function MissionDataSys.CreateDailyMissions(_Id , _Process , _IsFinish , _IsReceive)
       local Mission = {}
       local _Mdata = DailyMissionConfig.GetDailyById(_Id)
       if _Mdata==nil then
          return 
       end
       local _NeedTimes = _Mdata.NeedTimes
       local _TotalAlive = _Mdata.Acitve
       local _Type = _Mdata.Type
       local _Des = _Mdata.Description
       local data = 
       {
           DailyData = _Mdata,
           Id = _Mdata.Id,
           Require = _NeedTimes,
           TotalAlive = _TotalAlive,
           NowAlive = 0,
           Type = _Type,
           Process = _Process,
           IsFinish = _IsFinish,
           IsReceive = _IsReceive,
           Descrip = _Des,    
       }
       return data
  
end

function MissionDataSys.CreateMainMission(_Id , _IsFinish)
    local Mission = {}
    local _Mdata = MissionDataSys.GetMainById(_Id)
    if _Mdata==nil then
       return 
    end
    local _Name = _Mdata.Name
    local _Des = _Mdata.Descrip
    local _Class = _Mdata.Class             --种类
    local _Type = _Mdata.Type               --类型 1 主线 2支线
    local _Require = _Mdata.Require         --目标
    local _Next_Id = _Mdata.Next_Id
    local _Reward = _Mdata.Reward
    Mission = 
    {
        DailyData = _Mdata,
        Id = _Mdata.Id,
        Received = 0,
        Name = _Name,
        Descrip = _Des,
        Type = _Type,
        Class = _Class,
        Require = _Require,
        Next_Id = _Next_Id,
        Reward = _Reward,
        Process = 0,  
        IsFinish = _IsFinish,
    }
    return Mission
end

function MissionDataSys.GetMainById(_Id)
   local _MainMission = MainMissionConfig.GetMainById(_Id)
   return _MainMission
end
 
function MissionDataSys.GetNextMainById(_Id)
   local _MainMission = MissionDataSys.GetMainById(_Id)
   local _NextId = _MainMission.Next_Id
   local _NextMission = MissionDataSys.GetMainById(_NextId)
   if _NeedTimes~=nil then
      return _NeedTimes
   end
end

function MissionDataSys.GetActiveRewardByIndex(_Index)
   if ActiveRewardConfig.ActiveRewardConfig[_Index]~=nil then
      return ActiveRewardConfig.ActiveRewardConfig[_Index]
   end
end

function MissionDataSys.GetActiveIndex()
   for i = 1 , #ActiveRewardConfig.ActiveRewardConfig , 1 do
       local _ActiveData = ActiveRewardConfig.ActiveRewardConfig[i]
       local _NeedActive = _ActiveData.Active
       if _NeedActive == MissionSys.NowActive then
          return i
       elseif _NeedActive > MissionSys.NowActive then
          return i -1 
       end     
   end
   return 0
end

return MissionDataSys