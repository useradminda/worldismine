--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
MonthCardDataConfig={}
MonthCardDataConfig.MonthCardData={}

function MonthCardDataConfig.InitSome()
	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("Month_Card")
	while (sqReader:Read()~=false) do
        local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
		local id= tonumber(ObjectInfo[0])--sqReader:GetInt32(0)
		MonthCardDataConfig.MonthCardData[id]={
			Id=id,	--vip 等级
			Diamond = tonumber(ObjectInfo[1]),--sqReader:GetInt32(1),
			Reward = tonumber(ObjectInfo[2]),--sqReader:GetInt32(2),
			}
	end
end

function MonthCardDataConfig.GetDataById(_Id)		--根据VIP等级获取相关数据
	if MonthCardDataConfig.MonthCardData[tonumber(_Id)]~=nil then
       return MonthCardDataConfig.MonthCardData[tonumber(_Id)]
    end
    Debug.LogError("Month_Card表配置错误:")
    Debug.LogError(_Id)
    return nil
end

function MonthCardDataConfig.GetAllDBData()
	return MonthCardDataConfig.MonthCardData
end

return MonthCardDataConfig

--endregion
