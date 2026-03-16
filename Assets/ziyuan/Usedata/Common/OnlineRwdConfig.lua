--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
OnlineRwdConfig={}
OnlineRwdConfig.OnlineRwdData={}

function OnlineRwdConfig.InitSome()
	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("Online_Time")
	while (sqReader:Read()~=false) do
--		local id=sqReader:GetInt32(0)
		 local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
		local id= tonumber(ObjectInfo[0]) --sqReader:GetInt32(0)
		OnlineRwdConfig.OnlineRwdData[id]={
			Id=id,	--vip 等级
			Time = tonumber(ObjectInfo[1])+0.1,--sqReader:GetFloat(1),
			Description = tostring(ObjectInfo[2]),--sqReader:GetString(2),
			Reward = tostring(ObjectInfo[3]),--sqReader:GetString(3),
			}
	end
end

function OnlineRwdConfig.GetDBDataById(_Id)		--根据VIP等级获取相关数据
	if OnlineRwdConfig.OnlineRwdData[tonumber(_Id)]~=nil then
       return OnlineRwdConfig.OnlineRwdData[tonumber(_Id)]
    end
    Debug.LogError("Online_Time表配置错误:")
    Debug.LogError(_Id)
    return nil
end

function OnlineRwdConfig.GetAllDBData()
	return OnlineRwdConfig.OnlineRwdData
end

return OnlineRwdConfig

--endregion
