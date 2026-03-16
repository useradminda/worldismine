--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
SignTotalDataConfig={}
SignTotalDataConfig.SignTotalData={}

function SignTotalDataConfig.InitSome()
	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("Sign_Reward")
	while (sqReader:Read()~=false) do
--		local id=sqReader:GetInt32(0)
		local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
		local id= tonumber(ObjectInfo[0]) --sqReader:GetInt32(0)
		SignTotalDataConfig.SignTotalData[id]={
			Day=id,	--累计签到的数量
			Description = tostring(ObjectInfo[1]),--sqReader:GetString(1),
			NeedTimes = tonumber(ObjectInfo[2]),--sqReader:GetInt32(2),
			Reward = tostring(ObjectInfo[3]),--sqReader:GetString(3),
			Tips = tostring(ObjectInfo[4]),--sqReader:GetString(4),
			}
		
	end
end

function SignTotalDataConfig.GetSignTotalDBConfig(count)		--根据领取的次数获得数据
	if SignTotalDataConfig.SignTotalData[tonumber(count)]~=nil then
       return SignTotalDataConfig.SignTotalData[tonumber(count)]
    end
    Debug.LogError("Sign_Reward表配置错误:")
    Debug.LogError(count)
    return nil
end

function SignTotalDataConfig.GetAll()							--得到所有的数据
	return SignTotalDataConfig.SignTotalData
end

return SignTotalDataConfig

--endregion
