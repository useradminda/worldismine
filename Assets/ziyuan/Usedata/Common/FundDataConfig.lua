--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
FundDataConfig={}
FundDataConfig.FundData={}

function FundDataConfig.InitSome()
	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("Fund")
	while (sqReader:Read()~=false) do
		 local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
		local id= tonumber(ObjectInfo[0])--sqReader:GetInt32(0)
		FundDataConfig.FundData[id]={
			Lvl=id,	--玩家等级
			Restore = tonumber(ObjectInfo[1])--sqReader:GetInt32(1),
			}
	end
end

function FundDataConfig.GetFundByLvl(Lvl)		--根据玩家等级获得数据
	if FundDataConfig.FundData[tonumber(Lvl)]~=nil then
       return FundDataConfig.FundData[tonumber(Lvl)]
    end
    Debug.LogError("Fund表配置错误:")
    Debug.LogError(Lvl)
    return nil
end

function FundDataConfig.GetAllFundData()
	return FundDataConfig.FundData
end

return FundDataConfig

--endregion
