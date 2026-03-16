--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
EveryWeekPreferentialConfig={}
EveryWeekPreferentialConfig.EveryWeekPreferentialData={}

function EveryWeekPreferentialConfig.InitSome()
	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("Preferential_EveryWeek")
	while (sqReader:Read()~=false) do
		 local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
		local id= tonumber(ObjectInfo[0]) --sqReader:GetInt32(0)
--		local id=sqReader:GetInt32(0)
		EveryWeekPreferentialConfig.EveryWeekPreferentialData[id]={
			Id=id,
			Reward = tonumber(ObjectInfo[1]),--sqReader:GetInt32(1),
			NeedRmb = tonumber(ObjectInfo[2]),--sqReader:GetInt32(2),
			NextId = tonumber(ObjectInfo[3]),--sqReader:GetInt32(3),
			AppStore_Id = tostring(ObjectInfo[4]),
			}
	end
end

function EveryWeekPreferentialConfig.GetDataById(_Id)		--根据VIP等级获取相关数据
	if EveryWeekPreferentialConfig.EveryWeekPreferentialData[tonumber(_Id)]~=nil then
       return EveryWeekPreferentialConfig.EveryWeekPreferentialData[tonumber(_Id)]
    end
    Debug.LogError("Preferential_EveryWeek表配置错误:")
    Debug.LogError(_Id)
    return nil
end

function EveryWeekPreferentialConfig.GetAllDBData()
	return EveryWeekPreferentialConfig.EveryWeekPreferentialData
end

return EveryWeekPreferentialConfig

--endregion
