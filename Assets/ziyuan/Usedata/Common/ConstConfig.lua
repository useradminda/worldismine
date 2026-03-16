ConstConfig = {}
ConstConfig.ConstConfig = {}
function ConstConfig.IniSome()

	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("Const")
	while (sqReader:Read() ~= false) 
	do
        local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
        local _Id = tostring(ObjectInfo[0])--sqReader:GetString(0)
        ConstConfig.ConstConfig[_Id] = 
        {         
            Id = _Id,                                    --Name 
            Value =  tostring(ObjectInfo[1]),--sqReader:GetString(1),      
            Description = tostring(ObjectInfo[2]),--sqReader:GetString(2),          --exp         
			Appstore_Id = tostring(ObjectInfo[3]),
		} 
        
    end
end

function ConstConfig.GetFirstRechargeReward()                   --获取首冲奖励
    if ConstConfig.ConstConfig["FirstCharge"]==nil then
       Debug.LogError("数据库Const等级配置错误_Id:")
       Debug.LogError("FirstCharge")
       return nil
    end
    local _FRids = GameMain.StringSplit(ConstConfig.ConstConfig["FirstCharge"].Value , ",")
    local _NormalId = _FRids[1]
    local _SpId = _FRids[2]

    local _NormalReward = RewardConfig.GetRewardConfig(_NormalId)
    local _NormalRewardString = _NormalReward.RewardString

    local _SpecialReard = RewardConfig.GetRewardConfig(_SpId)
    local _SpRewardString = _SpecialReard.RewardString

    return _NormalRewardString , _SpRewardString
end

function ConstConfig.GetFundNeed()							--获得基金需要的元宝
	if ConstConfig.ConstConfig["FundNeed"]~=nil then
		return tonumber(ConstConfig.ConstConfig["FundNeed"].Value)
	end
	Debug.LogError("数据库Const等级配置错误_Id:")
    Debug.LogError("FundNeed")
	return 0
end

function ConstConfig.GetFundAppStoreId()				--获得购买基金的appStoreId
	if ConstConfig.ConstConfig["FundNeed"]~=nil then
		return tostring(ConstConfig.ConstConfig["FundNeed"].Appstore_Id)
	end
	Debug.LogError("数据库Const等级配置错误_Id:")
    Debug.LogError("FundNeed")
	return nil
end

function ConstConfig.GetSetNameNeedMoney()					--获得改名字所需要的元宝
	if ConstConfig.ConstConfig["Rename"]~=nil then
		return tonumber(ConstConfig.ConstConfig["Rename"].Value)
	end
	Debug.LogError("数据库Const等级配置错误_Id:")
    Debug.LogError("Rename")
	return 0
end
--Luck_Limit
function ConstConfig.GetLuckLimit()					--获得改名字所需要的元宝
	if ConstConfig.ConstConfig["Luck_Limit"]~=nil then
		return tonumber(ConstConfig.ConstConfig["Luck_Limit"].Value)
	end
	Debug.LogError("数据库Const等级配置错误_Id:")
    Debug.LogError("Luck_Limit")
	return 0
end

return ConstConfig