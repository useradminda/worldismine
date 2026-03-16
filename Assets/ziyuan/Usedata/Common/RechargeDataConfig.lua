--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
RechargeDataConfig={}
RechargeDataConfig.RechargeData={}
RechargeDataConfig.RechargeList = {}

function RechargeDataConfig.InitSome()
	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("Recharge")
	while (sqReader:Read()~=false) do
        local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
		local id=tonumber(ObjectInfo[0])--sqReader:GetInt32(0)
		RechargeDataConfig.RechargeData[id]={
			Id=id,	--充值ID
			Type = tonumber(ObjectInfo[1]),--sqReader:GetInt32(1),--充值类型
			Diamond = tonumber(ObjectInfo[2]),--sqReader:GetInt32(2),--充值获得的元宝
			Price = tonumber(ObjectInfo[3]),--sqReader:GetInt32(3),--花费的金钱
			Icon = tostring(ObjectInfo[4]),--sqReader:GetString(4),--
			Description = tostring(ObjectInfo[5]),--sqReader:GetString(5),--描述
			Name = tostring(ObjectInfo[6]),-- sqReader:GetString(6),--名字
			AppStore_Id = tostring(ObjectInfo[7]),--sqReader:GetInt32(7),
			First_Recharge_Bonus = tonumber(ObjectInfo[8]),--sqReader:GetInt32(8),--首充送的
			Other_Recharge_Bonus = tonumber(ObjectInfo[9]),--sqReader:GetInt32(9),--不是首充，额外送的
			VipExp = tonumber(ObjectInfo[10]),
			Is_Double = tonumber(ObjectInfo[11]),
			}
		local _Icons = GameMain.StringSplit(RechargeDataConfig.RechargeData[id].Icon , ",")
        RechargeDataConfig.RechargeData[id].AtlasName = _Icons[1]
        RechargeDataConfig.RechargeData[id].SpriteName = _Icons[2]
	end
end

function RechargeDataConfig.GetDataById(_Id)		
	if RechargeDataConfig.RechargeData[tonumber(_Id)]~=nil then
       return RechargeDataConfig.RechargeData[tonumber(_Id)]
    end
    Debug.LogError("Recharge表配置错误:")
    Debug.LogError(_Id)
    return nil
end

function RechargeDataConfig.GetAllData()				
	return RechargeDataConfig.RechargeData
end


return RechargeDataConfig

--endregion
