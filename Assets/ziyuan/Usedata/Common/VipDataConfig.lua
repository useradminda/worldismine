--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
VipDataConfig={}
VipDataConfig.VipData={}

function VipDataConfig.InitSome()
	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("Vip")
	while (sqReader:Read()~=false) do
		local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
		local id= tonumber(ObjectInfo[0])--sqReader:GetInt32(0)
--		local id=sqReader:GetInt32(0)
		VipDataConfig.VipData[id]={
			Id=id,	--vip 等级
			VipExp = tonumber(ObjectInfo[1]),--sqReader:GetInt32(1),
			HeroLimit = tonumber(ObjectInfo[2]),--sqReader:GetInt32(2),
			TrainLimit = tonumber(ObjectInfo[3]),--sqReader:GetInt32(3),
			EngeryLimit = tonumber(ObjectInfo[4]),--sqReader:GetInt32(4),
			VoteLimit = tonumber(ObjectInfo[5]),--sqReader:GetInt32(5),
			ExpertTrain = tonumber(ObjectInfo[6]),--sqReader:GetInt32(6),
			Sweep = tonumber(ObjectInfo[7]),--sqReader:GetInt32(7),
			SeniorSmelt = tonumber(ObjectInfo[8]),--sqReader:GetInt32(8),
			SeniorEnlist = tonumber(ObjectInfo[9]),--sqReader:GetInt32(9),
			BuyCall = tonumber(ObjectInfo[10]),--sqReader:GetInt32(10),
			Reward = tostring(ObjectInfo[11]),--sqReader:GetString(11),
			Description = tostring(ObjectInfo[12]),--sqReader:GetString(12),
			CloseTime = tonumber(ObjectInfo[13]),--sqReader:GetInt32(13),
			LuckLimit = tonumber(ObjectInfo[14]),--sqReader:GetInt32(14),
			}
	end
end

function VipDataConfig.GetVipDBConfig(_Id)		--根据VIP等级获取相关数据
	if VipDataConfig.VipData[tonumber(_Id)]~=nil then
       return VipDataConfig.VipData[tonumber(_Id)]
    end
    Debug.LogError("Sign表配置错误:")
    Debug.LogError(_Id)
    return nil
end

function VipDataConfig.GetAllDBData()
	return VipDataConfig.VipData
end

return VipDataConfig

--endregion
