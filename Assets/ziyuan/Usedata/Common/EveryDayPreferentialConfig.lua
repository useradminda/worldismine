--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
EveryDayPreferentialConfig={}
EveryDayPreferentialConfig.EveryDayPreferentialData={}

function EveryDayPreferentialConfig.InitSome()
	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("Recharge_EveryDay")
	while (sqReader:Read()~=false) do
		local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
		local id= tonumber(ObjectInfo[0]) --sqReader:GetInt32(0)
--		local id=sqReader:GetInt32(0)
		EveryDayPreferentialConfig.EveryDayPreferentialData[id]={
			Id=id,
			NeedRmb = tonumber(ObjectInfo[1]),--sqReader:GetInt32(1),
			GetDiamond = tostring(ObjectInfo[2]),--sqReader:GetString(2),
			Get_Min = tonumber(ObjectInfo[3]),--sqReader:GetInt32(3),
			Get_Max = tonumber(ObjectInfo[4]),--sqReader:GetInt32(4),
			AppStore_Id = tostring(ObjectInfo[5])
			}
	end
end

function EveryDayPreferentialConfig.GetDataById(_Id)		
	if EveryDayPreferentialConfig.EveryDayPreferentialData[tonumber(_Id)]~=nil then
       return EveryDayPreferentialConfig.EveryDayPreferentialData[tonumber(_Id)]
    end
    Debug.LogError("Recharge_EveryDay表配置错误:")
    Debug.LogError(_Id)
    return nil
end

function EveryDayPreferentialConfig.GetAllDBData()
	return EveryDayPreferentialConfig.EveryDayPreferentialData
end

return EveryDayPreferentialConfig

--endregion
