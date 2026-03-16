RewardConfig={}
RewardConfig.RewardConfig={}

function RewardConfig.InitSome()
	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("Reward")
	while (sqReader:Read()~=false) do
        local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))

		local id= tonumber(ObjectInfo[0]) --sqReader:GetInt32(0)
		RewardConfig.RewardConfig[id]=
		{
			Id=id,			
			Description= tostring(ObjectInfo[1]),--sqReader:GetString(1),
			RewardString=tostring(ObjectInfo[2]),--sqReader:GetString(2),					  
		}
		
	end
end

function RewardConfig.GetRewardConfig(_Id)		--奖励配置
    if RewardConfig.RewardConfig[tonumber(_Id)] ~= nil then
       return RewardConfig.RewardConfig[tonumber(_Id)]
    end
    Debug.LogError("Reward表配置错误_Id:")
    Debug.LogError(_Id)
    return nil
end

function RewardConfig.GetBattleFieldReward()   --获得沙场点兵
   local _data = 
   {
   }
   local _Index = 700
   for i = 1 , 8 , 1 do
       local _TempReward = RewardConfig.GetRewardConfig(_Index + i)
       if _data[i]==nil then
          _data[i] = {}
       end
       _data[i].Descrip = _TempReward.Description
       _data[i].Reward = RewardContentSys.GetRewardResourceString(_TempReward.RewardString)
   end
   return _data
end

function RewardConfig.GetBattleHeroReward()     --斗将台
   local _data = 
   {
   }
   local _Index = 710
   for i = 1 , 8 , 1 do
       local _TempReward = RewardConfig.GetRewardConfig(_Index + i)
       if _data[i]==nil then
          _data[i] = {}
       end
       _data[i].Descrip = _TempReward.Description
       _data[i].Reward = RewardContentSys.GetRewardResourceString(_TempReward.RewardString)
   end
   return _data
end

return RewardConfig