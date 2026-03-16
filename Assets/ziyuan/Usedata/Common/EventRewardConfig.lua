EventRewardConfig={}
EventRewardConfig.EventRewardConfig={}

function EventRewardConfig.InitSome()
	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("EventReward")
	while (sqReader:Read()~=false) do
        local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
		local id= tonumber(ObjectInfo[0]) --sqReader:GetInt32(0)           --玩家等级
		EventRewardConfig.EventRewardConfig[id]=
        {
			--Lvl=id,	--玩家等级
            [101] = tonumber(ObjectInfo[1]),--sqReader:GetInt32(1),
            [102] = tonumber(ObjectInfo[2]),--sqReader:GetInt32(2),
            [103] = tonumber(ObjectInfo[3]),--sqReader:GetInt32(3),
            [104] = tonumber(ObjectInfo[4]),--sqReader:GetInt32(4),
            [105] = tonumber(ObjectInfo[5]),--sqReader:GetInt32(5),
            [106] = tonumber(ObjectInfo[6]),--sqReader:GetInt32(6),
            [107] = tonumber(ObjectInfo[7]),--sqReader:GetInt32(7),
            [201] = tonumber(ObjectInfo[8]),--sqReader:GetInt32(8),
            [202] = tonumber(ObjectInfo[9]),--sqReader:GetInt32(9),
            [203] = tostring(ObjectInfo[10]),--sqReader:GetString(10),

		}
	end
end

function EventRewardConfig.GetEventRewardConfig(_Lvl , _TID)		--根据玩家等级 活动id 获得数据

	if EventRewardConfig.EventRewardConfig[tonumber(_Lvl)]~=nil then
       if EventRewardConfig.EventRewardConfig[tonumber(_Lvl)][tonumber(_TID)]~=nil then
          return EventRewardConfig.EventRewardConfig[tonumber(_Lvl)][tonumber(_TID)]
       end
    end
    Debug.LogError("EventReward表配置错误_Lvl:")
    Debug.LogError(_Lvl)
    Debug.LogError("EventReward表配置错误_TID:")
    Debug.LogError(_TID)
    return nil
end


return EventRewardConfig