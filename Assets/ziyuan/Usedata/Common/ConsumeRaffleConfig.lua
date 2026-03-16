--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
ConsumeRaffleConfig={}
ConsumeRaffleConfig.ConsumeRaffleData={}

function ConsumeRaffleConfig.InitSome()
	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("ConsumeRaffle")
	while (sqReader:Read()~=false) do
        local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
		local id= tonumber(ObjectInfo[0]) --sqReader:GetInt32(0)
		ConsumeRaffleConfig.ConsumeRaffleData[id]={
			Id=id,	--vip 等级
			Reward_Id = tonumber(ObjectInfo[1]), --sqReader:GetInt32(1),
			Chance = tonumber(ObjectInfo[2]), --sqReader:GetInt32(2)
			}
	end
end

function ConsumeRaffleConfig.GetDBConfigById(_Id)		--根据ID获取相关数据
	if ConsumeRaffleConfig.ConsumeRaffleData[tonumber(_Id)]~=nil then
       return ConsumeRaffleConfig.ConsumeRaffleData[tonumber(_Id)]
    end
    Debug.LogError("ConsumeRaffle表配置错误:")
    Debug.LogError(_Id)
    return nil
end

function ConsumeRaffleConfig.GetDB()
	return ConsumeRaffleConfig.ConsumeRaffleData
end


return ConsumeRaffleConfig

--endregion
