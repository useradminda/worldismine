--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
OfficialRwdDataConfig = {}
OfficialRwdDataConfig.OfficialRwdData = {}

function OfficialRwdDataConfig.InitSome()
	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("Official_Reward")
	while (sqReader:Read() ~= false) 
	do
        local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
        local _DBid =  tonumber(ObjectInfo[0])--sqReader:GetInt32(0)
        OfficialRwdDataConfig.OfficialRwdData[_DBid] = {        
            Id = _DBid,										--ID                                  
            Name = tostring(ObjectInfo[1]),--sqReader:GetString(1),					--官职名称
			Salary = tonumber(ObjectInfo[2]),--sqReader:GetInt32(2),
			Call = tonumber(ObjectInfo[3]),--sqReader:GetInt32(3),					--征召令个数
			Ban = tonumber(ObjectInfo[4]),--sqReader:GetInt32(4),						--禁言的次数
		}

    end
end

function OfficialRwdDataConfig.GetDB()
	return OfficialRwdDataConfig.OfficialRwdData
end

function OfficialRwdDataConfig.GetDataById(_ID)
	 if OfficialRwdDataConfig.OfficialRwdData[tonumber(_ID)]~=nil then
       return OfficialRwdDataConfig.OfficialRwdData[tonumber(_ID)]
    end
    Debug.LogError("数据库Official配置错误id:")
    Debug.LogError(_ID)
    return nil
end

function OfficialRwdDataConfig.GetRewardItems(_ID)				--得到奖励
	local data = OfficialRwdDataConfig.GetDataById(_ID)
	if data~=nil then
		local rewardData = RewardConfig.GetRewardConfig(tonumber(data.Salary))
			
		local Rewards = RewardContentSys.GetRewardStringType(rewardData.RewardString)
		
		return Rewards
	end
end
return OfficialRwdDataConfig
--endregion
